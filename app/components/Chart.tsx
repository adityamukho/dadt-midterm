import dynamic from 'next/dynamic';
const Plot = dynamic(() => import('react-plotly.js'), { ssr: false });

interface ChartProps {
  data: any[];
  layout: any;
  title: string;
  onClick?: (event: any) => void;
}

export default function Chart({ data, layout, title, onClick }: ChartProps) {
  return (
    <div className="mb-4">
      <h2>{title}</h2>
      <div className="chart-container">
        <Plot
          data={data}
          layout={{
            ...layout,
            autosize: true,
            height: 500,
          }}
          useResizeHandler={true}
          style={{ width: '100%', height: '100%' }}
          onClick={onClick}
        />
      </div>
    </div>
  );
} 