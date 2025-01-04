import Link from 'next/link';
import { useRouter } from 'next/router';
import { Nav } from 'react-bootstrap';
import { useState, useEffect } from 'react';
import Loading from './Loading';

export default function Layout({ children }: { children: React.ReactNode }) {
  const router = useRouter();
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    const handleStart = () => setLoading(true);
    const handleComplete = () => setLoading(false);

    router.events.on('routeChangeStart', handleStart);
    router.events.on('routeChangeComplete', handleComplete);
    router.events.on('routeChangeError', handleComplete);

    return () => {
      router.events.off('routeChangeStart', handleStart);
      router.events.off('routeChangeComplete', handleComplete);
      router.events.off('routeChangeError', handleComplete);
    };
  }, [router]);

  const navItems = [
    { href: '/', label: 'Home' },
    { href: '/sector-performance', label: 'Sector Performance' },
    { href: '/pe-ratio', label: 'P/E Analysis' },
    { href: '/market-cap', label: 'Market Cap' },
    { href: '/dividends', label: 'Dividend Analysis' },
    { href: '/growth', label: 'Growth Metrics' },
    { href: '/financial-health', label: 'Financial Health' },
    { href: '/value-growth', label: 'Value vs Growth' }
  ];

  return (
    <div className="d-flex">
      {/* Sidebar */}
      <div className="bg-dark text-white sidebar" style={{ width: '250px', minHeight: '100vh', position: 'fixed' }}>
        <div className="p-3">
          <h5 className="sidebar-heading d-flex justify-content-between align-items-center px-3 mt-4 mb-4 text-muted">
            <span>Market Analysis</span>
          </h5>
          <Nav className="flex-column">
            {navItems.map((item) => (
              <Link 
                key={item.href}
                href={item.href}
                className={`nav-link ${router.pathname === item.href ? 'active' : ''}`}
                style={{ color: router.pathname === item.href ? '#fff' : '#adb5bd' }}
              >
                {item.label}
              </Link>
            ))}
          </Nav>
        </div>
      </div>

      {/* Main Content */}
      <div className="flex-grow-1 p-4" style={{ marginLeft: '250px' }}>
        <main className="container-fluid">
          {loading ? <Loading /> : children}
        </main>
      </div>
    </div>
  );
} 