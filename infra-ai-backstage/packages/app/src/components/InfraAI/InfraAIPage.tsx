import React, { useState } from 'react';
import {
  Content,
  Header,
  Page,
  InfoCard,
} from '@backstage/core-components';
import { Grid, Button, TextField, Typography, CircularProgress } from '@material-ui/core';
import { CloudUpload, Description } from '@material-ui/icons';

export const InfraAIPage = () => {
  const [textDescription, setTextDescription] = useState('');
  const [selectedFile, setSelectedFile] = useState<File | null>(null);
  const [loading, setLoading] = useState(false);
  const [result, setResult] = useState<any>(null);
  const [error, setError] = useState<string>('');

  const handleTextAnalysis = async () => {
    if (!textDescription.trim()) {
      setError('Por favor ingresa una descripción');
      return;
    }

    setLoading(true);
    setError('');
    
    try {
      const formData = new FormData();
      formData.append('description', textDescription);
      
      const response = await fetch('http://localhost:8000/process-text', {
        method: 'POST',
        body: formData,
      });
      
      if (!response.ok) {
        throw new Error(`Error: ${response.status}`);
      }
      
      const data = await response.json();
      setResult(data);
    } catch (err) {
      console.error('Error en análisis de texto:', err);
      setError(err instanceof Error ? err.message : `Error: ${String(err)}`);
    } finally {
      setLoading(false);
    }
  };

  const handleImageAnalysis = async () => {
    if (!selectedFile) {
      setError('Por favor selecciona una imagen');
      return;
    }

    setLoading(true);
    setError('');
    setResult(null);
    
    try {
      console.log('📁 Enviando archivo:', selectedFile.name, selectedFile.type);
      
      const formData = new FormData();
      formData.append('file', selectedFile);
      
      const response = await fetch('http://localhost:8000/process-image', {
        method: 'POST',
        body: formData,
      });
      
      console.log('📡 Respuesta recibida:', response.status, response.statusText);
      
      if (!response.ok) {
        const errorText = await response.text();
        console.error('❌ Error del servidor:', errorText);
        throw new Error(`Error HTTP ${response.status}: ${errorText}`);
      }
      
      const data = await response.json();
      console.log('✅ Datos recibidos:', data);
      setResult(data);
    } catch (err) {
      console.error('❌ Error en análisis de imagen:', err);
      setError(err instanceof Error ? err.message : `Error: ${String(err)}`);
    } finally {
      setLoading(false);
    }
  };

  const handleFileChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    const file = event.target.files?.[0];
    if (file) {
      console.log('📁 Archivo seleccionado:', file.name, file.type, file.size);
      setSelectedFile(file);
      setError('');
    }
  };

  return (
    <Page themeId="tool">
      <Header title="Infrastructure AI Platform" subtitle="Análisis automático de arquitecturas AWS" />
      <Content>
        <Grid container spacing={3}>
          {/* Análisis de Texto */}
          <Grid item xs={12} md={6}>
            <InfoCard title="🔍 Procesar Arquitectura">
              <TextField
                fullWidth
                multiline
                rows={4}
                variant="outlined"
                label="Describe tu arquitectura AWS"
                placeholder="Ej: Aplicación web con S3, CloudFront y Lambda para análisis de imágenes"
                value={textDescription}
                onChange={(e) => setTextDescription(e.target.value)}
                style={{ marginBottom: 16 }}
              />
              <Button
                variant="contained"
                color="primary"
                startIcon={<Description />}
                onClick={handleTextAnalysis}
                disabled={loading}
                fullWidth
              >
                {loading ? <CircularProgress size={20} /> : 'Procesar Arquitectura'}
              </Button>
            </InfoCard>
          </Grid>

          {/* Análisis de Imagen */}
          <Grid item xs={12} md={6}>
            <InfoCard title="🖼️ Analizar Imagen">
              <input
                accept="image/*"
                style={{ display: 'none' }}
                id="image-upload"
                type="file"
                onChange={handleFileChange}
              />
              <label htmlFor="image-upload">
                <Button
                  variant="outlined"
                  component="span"
                  startIcon={<CloudUpload />}
                  fullWidth
                  style={{ marginBottom: 16 }}
                >
                  Seleccionar Imagen
                </Button>
              </label>
              
              {selectedFile && (
                <Typography variant="body2" style={{ marginBottom: 16 }}>
                  Archivo: {selectedFile.name}
                </Typography>
              )}
              
              <Button
                variant="contained"
                color="secondary"
                startIcon={<CloudUpload />}
                onClick={handleImageAnalysis}
                disabled={loading || !selectedFile}
                fullWidth
              >
                {loading ? <CircularProgress size={20} /> : 'Analizar Imagen'}
              </Button>
            </InfoCard>
          </Grid>

          {/* Resultados */}
          {error && (
            <Grid item xs={12}>
              <InfoCard title="❌ Error">
                <Typography color="error">{error}</Typography>
              </InfoCard>
            </Grid>
          )}

          {result && (
            <Grid item xs={12}>
              <InfoCard title="✅ Resultado del Análisis">
                <Typography variant="h6" gutterBottom>
                  Template: {result.template_data?.project_name || result.project_name}
                </Typography>
                
                {result.analysis && (
                  <div style={{ marginBottom: 16 }}>
                    <Typography variant="subtitle1">Servicios detectados:</Typography>
                    <Typography variant="body2">
                      {result.analysis.services?.join(', ') || result.aws_services?.join(', ')}
                    </Typography>
                  </div>
                )}

                {result.github_url && (
                  <div style={{ marginBottom: 16 }}>
                    <Typography variant="subtitle1">GitHub:</Typography>
                    <a href={result.github_url} target="_blank" rel="noopener noreferrer">
                      {result.github_url}
                    </a>
                  </div>
                )}

                {result.backstage_url && (
                  <div>
                    <Typography variant="subtitle1">Backstage:</Typography>
                    <a href={result.backstage_url} target="_blank" rel="noopener noreferrer">
                      Crear proyecto en Backstage
                    </a>
                  </div>
                )}
              </InfoCard>
            </Grid>
          )}
        </Grid>
      </Content>
    </Page>
  );
};
