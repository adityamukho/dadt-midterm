import { GetServerSideProps } from 'next';
import { executeQuery } from '../lib/db';
import fs from 'fs/promises';
import path from 'path';
import { Table, Form, Button } from 'react-bootstrap';
import { useState, useMemo } from 'react';
import Chart from '../components/Chart';

interface ValueGrowthData {
  sector: string;
  subsector: string;
  value_companies: number;
  growth_companies: number;
  avg_pb_ratio: number;
  avg_pe_ratio: number;
}

export const getServerSideProps: GetServerSideProps = async () => {
  try {
    const sqlFile = await fs.readFile(
      path.join(process.cwd(), '../sql/reports/value_vs_growth.sql'),
      'utf8'
    );
    const data = await executeQuery<ValueGrowthData[]>(sqlFile);
    return { props: { data } };
  } catch (error) {
    console.error('Error fetching value vs growth data:', error);
    return { props: { data: [] } };
  }
};

const formatNumber = (value: number | null): string => {
  if (value === null || isNaN(value)) return 'N/A';
  return Number(value).toFixed(2);
};

const formatCount = (value: number | null): string => {
  if (value === null || isNaN(value)) return 'N/A';
  return value.toLocaleString();
};

export default function ValueVsGrowth({ data }: { data: ValueGrowthData[] }) {
  const [viewMode, setViewMode] = useState<'table' | 'chart'>('chart');
  const [selectedSector, setSelectedSector] = useState<string | null>(null);
  const [sortField, setSortField] = useState<keyof ValueGrowthData>('sector');
  const [sortDirection, setSortDirection] = useState<'asc' | 'desc'>('asc');
  const [searchTerm, setSearchTerm] = useState('');

  const sectorData = useMemo(() => {
    const sectors = new Map<string, { value: number; growth: number }>();
    
    data.forEach(item => {
      if (!sectors.has(item.sector)) {
        sectors.set(item.sector, { value: 0, growth: 0 });
      }
      const current = sectors.get(item.sector)!;
      current.value += item.value_companies;
      current.growth += item.growth_companies;
    });

    return Array.from(sectors.entries()).map(([sector, counts]) => ({
      sector,
      ...counts
    }));
  }, [data]);

  const chartData = useMemo(() => {
    const source = selectedSector 
      ? data.filter(d => d.sector === selectedSector)
      : sectorData;

    return [{
      name: 'Value Companies',
      type: 'bar',
      x: source.map(d => selectedSector ? d.subsector : d.sector),
      y: source.map(d => 'value_companies' in d ? d.value_companies : d.value),
      marker: { color: '#2E86C1' }
    }, {
      name: 'Growth Companies',
      type: 'bar',
      x: source.map(d => selectedSector ? d.subsector : d.sector),
      y: source.map(d => 'growth_companies' in d ? d.growth_companies : d.growth),
      marker: { color: '#E74C3C' }
    }];
  }, [data, selectedSector, sectorData]);

  const handleChartClick = (event: any) => {
    if (!selectedSector) {
      const sector = event.points[0].x;
      setSelectedSector(sector);
    } else {
      setSelectedSector(null);
    }
  };

  const layout = {
    barmode: 'group',
    title: selectedSector 
      ? `Value vs Growth Companies in ${selectedSector} Sector`
      : 'Value vs Growth Companies by Sector (Click to drill down)',
    xaxis: {
      tickangle: -45,
      automargin: true
    },
    yaxis: {
      title: 'Number of Companies'
    },
    height: 500,
    autosize: true,
    margin: {
      l: 50,
      r: 50,
      b: 150,
      t: 50,
      pad: 4
    }
  };

  const sortedAndFilteredData = useMemo(() => {
    return [...data]
      .filter(item => 
        Object.values(item).some(
          value => value.toString().toLowerCase().includes(searchTerm.toLowerCase())
        )
      )
      .sort((a, b) => {
        if (a[sortField] < b[sortField]) return sortDirection === 'asc' ? -1 : 1;
        if (a[sortField] > b[sortField]) return sortDirection === 'asc' ? 1 : -1;
        return 0;
      });
  }, [data, sortField, sortDirection, searchTerm]);

  const handleSort = (field: keyof ValueGrowthData) => {
    if (field === sortField) {
      setSortDirection(sortDirection === 'asc' ? 'desc' : 'asc');
    } else {
      setSortField(field);
      setSortDirection('desc');
    }
  };

  return (
    <div>
      <h2 className="mb-4">Value vs Growth Analysis</h2>
      <div className="mb-3">
        <Button 
          variant={viewMode === 'chart' ? 'primary' : 'outline-primary'}
          onClick={() => setViewMode('chart')}
          className="me-2"
        >
          Chart View
        </Button>
        <Button 
          variant={viewMode === 'table' ? 'primary' : 'outline-primary'}
          onClick={() => setViewMode('table')}
        >
          Table View
        </Button>
      </div>

      {viewMode === 'chart' ? (
        <div className="chart-container">
          <Chart
            title="Value vs Growth by Sector"
            data={chartData}
            layout={layout}
            useResizeHandler={true}
            style={{ width: '100%', height: '100%' }}
            config={{ responsive: true }}
            onClick={handleChartClick}
          />
          {selectedSector && (
            <div className="text-center mt-2">
              <Button variant="outline-secondary" size="sm" onClick={() => setSelectedSector(null)}>
                ← Back to Sectors Overview
              </Button>
            </div>
          )}
        </div>
      ) : (
        <div>
          <Form.Group className="mb-3">
            <Form.Control
              type="text"
              placeholder="Search..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
            />
          </Form.Group>
          <div className="table-responsive">
            <Table striped hover>
              <thead>
                <tr>
                  <th onClick={() => handleSort('sector')} style={{ cursor: 'pointer' }}>
                    Sector {sortField === 'sector' && (sortDirection === 'asc' ? '↑' : '↓')}
                  </th>
                  <th onClick={() => handleSort('subsector')} style={{ cursor: 'pointer' }}>
                    Subsector {sortField === 'subsector' && (sortDirection === 'asc' ? '↑' : '↓')}
                  </th>
                  <th onClick={() => handleSort('value_companies')} style={{ cursor: 'pointer' }}>
                    Value Companies {sortField === 'value_companies' && (sortDirection === 'asc' ? '↑' : '↓')}
                  </th>
                  <th onClick={() => handleSort('growth_companies')} style={{ cursor: 'pointer' }}>
                    Growth Companies {sortField === 'growth_companies' && (sortDirection === 'asc' ? '↑' : '↓')}
                  </th>
                  <th onClick={() => handleSort('avg_pb_ratio')} style={{ cursor: 'pointer' }}>
                    Avg Price/Book Ratio {sortField === 'avg_pb_ratio' && (sortDirection === 'asc' ? '↑' : '↓')}
                  </th>
                  <th onClick={() => handleSort('avg_pe_ratio')} style={{ cursor: 'pointer' }}>
                    Avg Price/Earnings Ratio {sortField === 'avg_pe_ratio' && (sortDirection === 'asc' ? '↑' : '↓')}
                  </th>
                </tr>
              </thead>
              <tbody>
                {sortedAndFilteredData.map((row, index) => (
                  <tr key={index}>
                    <td>{row.sector}</td>
                    <td>{row.subsector}</td>
                    <td>{formatCount(row.value_companies)}</td>
                    <td>{formatCount(row.growth_companies)}</td>
                    <td>{formatNumber(row.avg_pb_ratio)}</td>
                    <td>{formatNumber(row.avg_pe_ratio)}</td>
                  </tr>
                ))}
              </tbody>
            </Table>
          </div>
        </div>
      )}
    </div>
  );
} 