import React from 'react';
import Link from 'next/link';
import { Card, Container, Row, Col } from 'react-bootstrap';

const HomePage: React.FC = () => {
  return (
    <Container className="mt-5">
      <h1 className="mb-4">S&P 500 Financial Reports Dashboard</h1>
      <p className="lead">
        This dashboard provides insights into various financial metrics and trends based on the S&P 500 index. The reports analyze historical and current data to help investors make informed decisions by understanding market dynamics, sector performance, and company valuations within the S&P 500.
      </p>
      <Row>
        <Col md={6} className="mb-4">
          <Card>
            <Card.Body>
              <Card.Title>Value vs Growth Analysis</Card.Title>
              <Card.Text>
                This report compares value and growth companies across different sectors. It helps investors understand which sectors are dominated by value stocks and which by growth stocks, providing insights into market trends and investment opportunities.
              </Card.Text>
              <Link href="/value-growth" passHref>
                <Card.Link>View Report</Card.Link>
              </Link>
            </Card.Body>
          </Card>
        </Col>
        <Col md={6} className="mb-4">
          <Card>
            <Card.Body>
              <Card.Title>Top Growth Companies</Card.Title>
              <Card.Text>
                This report ranks companies based on their growth potential, using metrics like P/E, P/B, and P/S ratios. It is essential for identifying high-growth companies that may offer significant returns.
              </Card.Text>
              <Link href="/growth" passHref>
                <Card.Link>View Report</Card.Link>
              </Link>
            </Card.Body>
          </Card>
        </Col>
        <Col md={6} className="mb-4">
          <Card>
            <Card.Body>
              <Card.Title>Market Cap Distribution</Card.Title>
              <Card.Text>
                This report analyzes the distribution of companies by market cap category, providing insights into the size and scale of companies within the market. It helps investors understand the market's composition and identify potential investment opportunities.
              </Card.Text>
              <Link href="/market-cap" passHref>
                <Card.Link>View Report</Card.Link>
              </Link>
            </Card.Body>
          </Card>
        </Col>
        <Col md={6} className="mb-4">
          <Card>
            <Card.Body>
              <Card.Title>P/E Ratio Analysis</Card.Title>
              <Card.Text>
                This report examines the P/E ratios across sectors and subsectors, offering insights into market valuations. It is crucial for investors looking to assess whether sectors are overvalued or undervalued.
              </Card.Text>
              <Link href="/pe-ratio" passHref>
                <Card.Link>View Report</Card.Link>
              </Link>
            </Card.Body>
          </Card>
        </Col>
        <Col md={6} className="mb-4">
          <Card>
            <Card.Body>
              <Card.Title>Sector Performance</Card.Title>
              <Card.Text>
                This report provides an overview of sector performance, including average market cap and dividend yields. It helps investors identify strong and weak sectors, guiding strategic investment decisions.
              </Card.Text>
              <Link href="/sector-performance" passHref>
                <Card.Link>View Report</Card.Link>
              </Link>
            </Card.Body>
          </Card>
        </Col>
      </Row>
    </Container>
  );
};

export default HomePage;