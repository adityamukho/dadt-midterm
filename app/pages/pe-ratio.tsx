import { GetServerSideProps } from 'next';
import Chart from '../components/Chart';
import { executeQuery } from '../lib/db';
import fs from 'fs/promises';
import path from 'path';
import { useState } from 'react';

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
    const [selectedSector, setSelectedSector] = useState<string | null>(null);

    const sectorPEData = [
        {
            x: data.map(d => d.sector),
            y: data.map(d => d.min_pe_ratio),
            name: 'Min P/E',
            type: 'bar',
            hovertemplate: 'Click to see subsector breakdown<br>Min P/E: %{y:.2f}<extra></extra>',
            cursor: 'pointer'
        },
        {
            x: data.map(d => d.sector),
            y: data.map(d => d.median_pe_ratio),
            name: 'Median P/E',
            type: 'bar',
            hovertemplate: 'Click to see subsector breakdown<br>Median P/E: %{y:.2f}<extra></extra>',
            cursor: 'pointer'
        },
        {
            x: data.map(d => d.sector),
            y: data.map(d => d.avg_pe_ratio),
            name: 'Average P/E',
            type: 'bar',
            hovertemplate: 'Click to see subsector breakdown<br>Average P/E: %{y:.2f}<extra></extra>',
            cursor: 'pointer'
        },
        {
            x: data.map(d => d.sector),
            y: data.map(d => d.max_pe_ratio),
            name: 'Max P/E',
            type: 'bar',
            hovertemplate: 'Click to see subsector breakdown<br>Max P/E: %{y:.2f}<extra></extra>',
            cursor: 'pointer'
        }
    ];

    const sectorLayout = {
        title: 'P/E Ratio by Sector <b>(Click on a group to drill-down)</b>',
        yaxis: { title: 'P/E Ratio' },
        barmode: 'group' as const,
        height: 400,
        showlegend: true,
        hoverlabel: {
            bgcolor: '#FFF',
            bordercolor: '#DDD',
            font: { size: 13 }
        }
    };

    const handleSectorClick = (event: any) => {
        const sector = event.points[0].x;
        setSelectedSector(sector === selectedSector ? null : sector);
    };

    const getSubsectorData = () => {
        if (!selectedSector) return null;

        const sectorData = data.filter(d => d.sector === selectedSector);
        return [
            {
                x: sectorData.map(d => d.subsector),
                y: sectorData.map(d => d.min_pe_ratio),
                name: 'Min P/E',
                type: 'bar',
                hovertemplate: 'Min P/E: %{y:.2f}<extra></extra>'
            },
            {
                x: sectorData.map(d => d.subsector),
                y: sectorData.map(d => d.median_pe_ratio),
                name: 'Median P/E',
                type: 'bar',
                hovertemplate: 'Median P/E: %{y:.2f}<extra></extra>'
            },
            {
                x: sectorData.map(d => d.subsector),
                y: sectorData.map(d => d.avg_pe_ratio),
                name: 'Average P/E',
                type: 'bar',
                hovertemplate: 'Average P/E: %{y:.2f}<extra></extra>'
            },
            {
                x: sectorData.map(d => d.subsector),
                y: sectorData.map(d => d.max_pe_ratio),
                name: 'Max P/E',
                type: 'bar',
                hovertemplate: 'Max P/E: %{y:.2f}<extra></extra>'
            }
        ];
    };

    const subsectorLayout = {
        title: `P/E Ratio by Subsector (${selectedSector})`,
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
                    title="P/E Ratio Analysis"
                    onClick={handleSectorClick}
                />
            </div>
            {selectedSector && (
                <div className="mb-8">
                    <Chart
                        data={getSubsectorData()}
                        layout={subsectorLayout}
                        title={`${selectedSector} Subsector Analysis`}
                    />
                </div>
            )}
        </div>
    );
} 