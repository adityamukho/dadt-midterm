import { GetServerSideProps } from 'next';
import Chart from '../components/Chart';
import { executeQuery } from '../lib/db';
import fs from 'fs/promises';
import path from 'path';

interface PERatioData {
  sector: string;
  subsector: string;
  avg_pe_ratio: number;
  median_pe_ratio: number;
  min_pe_ratio: number;
  max_pe_ratio: number;
  company_count: number;
}

export const getServerSideProps: GetServerSideProps = async () => {
  try {
    const sqlFile = await fs.readFile(
      path.join(process.cwd(), '../sql/reports/pe_ratio_comparison.sql'),
      'utf8'
    );
    const data = await executeQuery<PERatioData[]>(sqlFile);
    return { props: { data } };
  } catch (error) {
    console.error('Error fetching P/E ratio data:', error);
    return { props: { data: [] } };
  }
};

export default function PERatioAnalysis({ data }: { data: PERatioData[] }) {
  const sectorPEData = [
    {
      x: data.map(d => d.sector),
      y: data.map(d => d.avg_pe_ratio),
      name: 'Average P/E',
      type: 'bar'
    },
    {
      x: data.map(d => d.sector),
      y: data.map(d => d.median_pe_ratio),
      name: 'Median P/E',
      type: 'scatter',
      mode: 'lines+markers'
    }
  ];

  const peRangeData = [
    {
      x: data.map(d => d.sector),
      y: data.map(d => d.min_pe_ratio),
      name: 'Min P/E',
      type: 'bar'
    },
    {
      x: data.map(d => d.sector),
      y: data.map(d => d.max_pe_ratio),
      name: 'Max P/E',
      type: 'bar'
    }
  ];

  const sectorLayout = {
    title: 'Sector P/E Ratio Analysis',
    yaxis: { title: 'P/E Ratio' },
    barmode: 'group' as const,
    height: 400,
    showlegend: true
  };

  const rangeLayout = {
    title: 'P/E Ratio Range by Sector',
    yaxis: { title: 'P/E Ratio' },
    barmode: 'group' as const,
    height: 400,
    showlegend: true
  };

  return (
    <div>
      <div className="mb-8">
        <Chart
          data={sectorPEData}
          layout={sectorLayout}
          title="Sector P/E Analysis"
        />
      </div>
      <div className="mb-8">
        <Chart
          data={peRangeData}
          layout={rangeLayout}
          title="P/E Range Analysis"
        />
      </div>
    </div>
  );
} 