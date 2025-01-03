import { Container, Nav, Navbar } from 'react-bootstrap';
import Link from 'next/link';

export default function Layout({ children }: { children: React.ReactNode }) {
  return (
    <>
      <Navbar bg="dark" variant="dark" expand="lg">
        <Container>
          <Navbar.Brand href="/">S&P 500 Analytics</Navbar.Brand>
          <Navbar.Toggle />
          <Navbar.Collapse>
            <Nav className="me-auto">
              <Link href="/sector-performance" passHref legacyBehavior>
                <Nav.Link>Sector Performance</Nav.Link>
              </Link>
              <Link href="/pe-ratio" passHref legacyBehavior>
                <Nav.Link>PE Ratio Analysis</Nav.Link>
              </Link>
              <Link href="/market-cap" passHref legacyBehavior>
                <Nav.Link>Market Cap Distribution</Nav.Link>
              </Link>
              <Link href="/growth-companies" passHref legacyBehavior>
                <Nav.Link>Growth Companies</Nav.Link>
              </Link>
            </Nav>
          </Navbar.Collapse>
        </Container>
      </Navbar>
      <Container className="py-4">
        {children}
      </Container>
    </>
  );
} 