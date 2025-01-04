import { GetServerSideProps } from 'next';
import Chart from '../components/Chart';
import { executeQuery } from '../lib/db';
import fs from 'fs/promises';
import path from 'path';
import { useState } from 'react';

interface MarketCapData {
  cap_category: string;
  company_count: number;
  avg_market_cap: number;
  min_market_cap: number;
  max_market_cap: number;
}

export const getServerSideProps: GetServerSideProps = async () => {
  try {
    const sqlFile = await fs.readFile(
      path.join(process.cwd(), '../sql/reports/market_cap_distribution.sql'),
      'utf8'
    );
    const data = await executeQuery<MarketCapData[]>(sqlFile);
    return { props: { data } };
  } catch (error) {
    console.error('Error fetching market cap data:', error);
    return { props: { data: [] } };
  }
};

export default function MarketCapDistribution({ data }: { data: MarketCapData[] }) {
  const [selectedCategory, setSelectedCategory] = useState<string | null>(null);

  const distributionData = [
    {
      x: data.map(d => d.cap_category),
      y: data.map(d => d.company_count),
      name: 'Number of Companies',
      type: 'bar',
      marker: { color: '#2E86C1' },
      hovertemplate: 'Companies: %{y}<br>Category: %{x}<extra></extra>'
    }
  ];

  const marketCapRangeData = [
    {
      x: data.map(d => d.cap_category),
      y: data.map(d => d.avg_market_cap / 1e9), // Convert to billions
      name: 'Average Market Cap',
      type: 'bar',
      yaxis: 'y',
      marker: { color: '#3498DB' },
      hovertemplate: 'Avg Market Cap: $%{y:.1f}B<extra></extra>'
    },
    {
      x: data.map(d => d.cap_category),
      y: data.map(d => d.min_market_cap / 1e9),
      name: 'Min Market Cap',
      type: 'scatter',
      mode: 'markers',
      yaxis: 'y',
      marker: { 
        color: '#8E44AD',
        size: 10,
        symbol: 'triangle-down'
      },
      hovertemplate: 'Min Market Cap: $%{y:.1f}B<extra></extra>'
    },
    {
      x: data.map(d => d.cap_category),
      y: data.map(d => d.max_market_cap / 1e9),
      name: 'Max Market Cap',
      type: 'scatter',
      mode: 'markers',
      yaxis: 'y',
      marker: { 
        color: '#E74C3C',
        size: 10,
        symbol: 'triangle-up'
      },
      hovertemplate: 'Max Market Cap: $%{y:.1f}B<extra></extra>'
    }
  ];

  const distributionLayout = {
    title: 'Company Distribution by Market Cap Category',
    yaxis: { 
      title: 'Number of Companies',
      gridcolor: '#E5E5E5'
    },
    xaxis: {
      title: 'Market Cap Category',
      gridcolor: '#E5E5E5'
    },
    height: 400,
    showlegend: true,
    plot_bgcolor: '#FFFFFF',
    paper_bgcolor: '#FFFFFF'
  };

  const rangeLayout = {
    title: 'Market Cap Range by Category (Log-Scaled y-Axis)',
    yaxis: { 
      title: 'Market Cap (Billions USD)',
      gridcolor: '#E5E5E5',
      type: 'log',
      tickformat: '.1f',
      tickprefix: '$',
      ticksuffix: 'B'
    },
    xaxis: {
      title: 'Market Cap Category',
      gridcolor: '#E5E5E5'
    },
    height: 400,
    showlegend: true,
    plot_bgcolor: '#FFFFFF',
    paper_bgcolor: '#FFFFFF',
    hovermode: 'closest'
  };

  return (
    <div>
      <div className="mb-8">
        <Chart
          data={distributionData}
          layout={distributionLayout}
          title="Market Cap Distribution"
        />
      </div>
      <div className="mb-8">
        <Chart
          data={marketCapRangeData}
          layout={rangeLayout}
          title="Market Cap Range Analysis"
        />
      </div>
    </div>
  );
} 