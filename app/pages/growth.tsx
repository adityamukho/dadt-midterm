import { GetServerSideProps } from 'next';
import { executeQuery } from '../lib/db';
import fs from 'fs/promises';
import path from 'path';
import { Table, Card } from 'react-bootstrap';

interface GrowthCompany {
  name: string;
  'Sector/Subsector': string;
  price_earnings: number;
  price_book: number;
  price_sales: number;
  market_cap: number;
}

export const getServerSideProps: GetServerSideProps = async () => {
  try {
    const sqlFile = await fs.readFile(
      path.join(process.cwd(), '../sql/reports/top_companies_by_growth.sql'),
      'utf8'
    );
    const data = await executeQuery<GrowthCompany[]>(sqlFile);
    return { props: { data } };
  } catch (error) {
    console.error('Error fetching growth companies:', error);
    return { props: { data: [] } };
  }
};

const formatRatio = (value: number | null): string => {
  if (value === null || isNaN(value)) return 'N/A';
  return Number(value).toFixed(2);
};

const formatMarketCap = (value: number | null): string => {
  if (value === null || isNaN(value)) return 'N/A';
  const billion = 1000000000;
  return `$${(value / billion).toFixed(1)}B`;
};

export default function GrowthCompanies({ data }: { data: GrowthCompany[] }) {
  return (
    <div>
      <h2 className="mb-4">Top Growth Companies</h2>
      <Card className="mb-4">
        <Card.Body>
          <Card.Text>
            Companies are ranked based on a composite growth score calculated from their P/E, P/B, and P/S ratios.
            Higher multiples typically indicate higher growth expectations from the market.
          </Card.Text>
        </Card.Body>
      </Card>
      <div className="table-responsive">
        <Table striped hover>
          <thead>
            <tr>
              <th>Rank</th>
              <th>Company</th>
              <th>Sector/Subsector</th>
              <th>Price/Earnings</th>
              <th>Price/Book</th>
              <th>Price/Sales</th>
              <th>Market Cap</th>
              <th>Growth Score</th>
            </tr>
          </thead>
          <tbody>
            {data.map((company, index) => {
              const growthScore = (
                company.price_earnings * 
                company.price_book * 
                company.price_sales
              ).toFixed(2);
              
              return (
                <tr key={company.name}>
                  <td>{index + 1}</td>
                  <td>{company.name}</td>
                  <td>{company['Sector/Subsector']}</td>
                  <td>{formatRatio(company.price_earnings)}</td>
                  <td>{formatRatio(company.price_book)}</td>
                  <td>{formatRatio(company.price_sales)}</td>
                  <td>{formatMarketCap(company.market_cap)}</td>
                  <td>{growthScore}</td>
                </tr>
              );
            })}
          </tbody>
        </Table>
      </div>
      <Card className="mt-4">
        <Card.Body>
          <Card.Title>Understanding the Metrics</Card.Title>
          <ul className="mb-0">
            <li><strong>Price/Earnings (P/E):</strong> Higher ratios suggest higher expected earnings growth</li>
            <li><strong>Price/Book (P/B):</strong> Higher ratios indicate strong return on equity and growth potential</li>
            <li><strong>Price/Sales (P/S):</strong> Higher ratios suggest expectations of strong revenue growth</li>
            <li><strong>Growth Score:</strong> Composite metric combining all three ratios (P/E × P/B × P/S)</li>
          </ul>
        </Card.Body>
      </Card>
    </div>
  );
} 