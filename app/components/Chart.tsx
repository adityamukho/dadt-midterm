import dynamic from 'next/dynamic';
import React, { useState, CSSProperties } from 'react';
const Plot = dynamic(() => import('react-plotly.js'), { ssr: false });

interface ChartProps {
  data: any[];
  layout: any;
  title: string;
  onClick?: (event: any) => void;
  useResizeHandler?: boolean;
  style?: CSSProperties;
  config?: Partial<Plotly.Config>;
}

export default function Chart({ data, layout, title, onClick }: ChartProps) {
  const [isLoading, setIsLoading] = useState(true);

  return (
    <div className="mb-4">
      <h2>{title}</h2>
      <div className="chart-container">
        <div style={{ position: 'relative' }}>
          {isLoading && (
            <div
              style={{
                width: '100%',
                height: '400px',
                backgroundColor: '#f0f0f0',
                borderRadius: '8px',
                animation: 'pulse 1.5s infinite ease-in-out',
              }}
            />
          )}
          <div style={{ display: isLoading ? 'none' : 'block' }}>
            <Plot
              data={data}
              layout={{
                ...layout,
                autosize: true,
                height: 500,
              }}
              useResizeHandler={true}
              style={{ 
                width: '100%',
                height: '100%',
                visibility: isLoading ? 'hidden' : 'visible' 
              }}
              onInitialized={() => setIsLoading(false)}
              onUpdate={() => setIsLoading(false)}
              onClick={onClick}
            />
          </div>
        </div>
      </div>
    </div>
  );
} 