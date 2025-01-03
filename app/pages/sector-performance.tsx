import { GetServerSideProps } from 'next';
import Chart from '../components/Chart';
import { executeQuery } from '../lib/db';
import fs from 'fs/promises';
import path from 'path';

interface SectorData {
  sector: string;
  company_count: number;
  avg_market_cap: number;
  avg_pe_ratio: number;
  avg_dividend_yield: number;
}

export const getServerSideProps: GetServerSideProps = async () => {
  try {
    const sqlFile = await fs.readFile(
      path.join(process.cwd(), '../sql/reports/sector_performance.sql'),
      'utf8'
    );
    const data = await executeQuery<SectorData[]>(sqlFile);
    return { props: { data } };
  } catch (error) {
    console.error('Error fetching sector data:', error);
    return { props: { data: [] } };
  }
};

export default function SectorPerformance({ data }: { data: SectorData[] }) {
  const chartData = [
    {
      x: data.map(d => d.sector),
      y: data.map(d => d.avg_market_cap),
      name: 'Avg Market Cap',
      type: 'bar'
    },
    {
      x: data.map(d => d.sector),
      y: data.map(d => d.avg_pe_ratio),
      name: 'Avg P/E Ratio',
      yaxis: 'y2',
      type: 'scatter'
    }
  ];

  const layout = {
    title: 'Sector Performance Analysis',
    yaxis: { title: 'Average Market Cap' },
    yaxis2: {
      title: 'Average P/E Ratio',
      overlaying: 'y',
      side: 'right'
    },
    barmode: 'group'
  };

  return (
    <Chart
      data={chartData}
      layout={layout}
      title="Sector Performance"
    />
  );
} 