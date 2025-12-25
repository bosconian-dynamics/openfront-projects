import { LitElement, html, css } from 'lit';
import { customElement, state } from 'lit/decorators.js';
import * as THREE from 'three';

/**
 * Main application component for the OpenFront Map Editor
 */
@customElement('map-editor-app')
export class MapEditorApp extends LitElement {
  static styles = css`
    :host {
      display: block;
      width: 100%;
      height: 100vh;
      margin: 0;
      padding: 0;
      font-family: system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
    }

    .container {
      display: flex;
      flex-direction: column;
      width: 100%;
      height: 100%;
    }

    header {
      padding: 1rem;
      background-color: #2c3e50;
      color: white;
      box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    }

    h1 {
      margin: 0;
      font-size: 1.5rem;
    }

    .canvas-container {
      flex: 1;
      position: relative;
      overflow: hidden;
      background-color: #34495e;
    }

    #renderCanvas {
      width: 100%;
      height: 100%;
      display: block;
    }

    .info {
      position: absolute;
      bottom: 10px;
      left: 10px;
      color: white;
      background-color: rgba(0, 0, 0, 0.7);
      padding: 0.5rem;
      border-radius: 4px;
      font-size: 0.875rem;
    }
  `;

  @state()
  private threeVersion: string = THREE.REVISION;

  private scene?: THREE.Scene;
  private camera?: THREE.OrthographicCamera;
  private renderer?: THREE.WebGLRenderer;
  private animationFrameId?: number;
  private boundHandleResize?: () => void;

  override connectedCallback(): void {
    super.connectedCallback();
  }

  override disconnectedCallback(): void {
    super.disconnectedCallback();
    this.cleanup();
  }

  override firstUpdated(): void {
    this.initThreeJS();
  }

  private initThreeJS(): void {
    const canvas = this.shadowRoot?.querySelector('#renderCanvas') as HTMLCanvasElement;
    if (!canvas) return;

    // Create scene
    this.scene = new THREE.Scene();
    this.scene.background = new THREE.Color(0x1a1a1a);

    // Create orthographic camera for 2D rendering
    const aspect = canvas.clientWidth / canvas.clientHeight;
    const frustumSize = 10;
    this.camera = new THREE.OrthographicCamera(
      frustumSize * aspect / -2,
      frustumSize * aspect / 2,
      frustumSize / 2,
      frustumSize / -2,
      0.1,
      1000
    );
    this.camera.position.z = 5;

    // Create renderer
    this.renderer = new THREE.WebGLRenderer({
      canvas,
      antialias: true
    });
    this.renderer.setSize(canvas.clientWidth, canvas.clientHeight);
    this.renderer.setPixelRatio(window.devicePixelRatio);

    // Add a simple grid helper for reference
    const gridHelper = new THREE.GridHelper(10, 10, 0x444444, 0x222222);
    gridHelper.rotation.x = Math.PI / 2;
    this.scene.add(gridHelper);

    // Start animation loop
    this.startAnimationLoop();

    // Handle window resize
    this.boundHandleResize = this.handleResize.bind(this);
    window.addEventListener('resize', this.boundHandleResize);
  }

  private handleResize(): void {
    const canvas = this.shadowRoot?.querySelector('#renderCanvas') as HTMLCanvasElement;
    if (!canvas || !this.camera || !this.renderer) return;

    const aspect = canvas.clientWidth / canvas.clientHeight;
    const frustumSize = 10;

    this.camera.left = frustumSize * aspect / -2;
    this.camera.right = frustumSize * aspect / 2;
    this.camera.top = frustumSize / 2;
    this.camera.bottom = frustumSize / -2;
    this.camera.updateProjectionMatrix();

    this.renderer.setSize(canvas.clientWidth, canvas.clientHeight);
  }

  private startAnimationLoop(): void {
    this.animationFrameId = requestAnimationFrame(() => this.startAnimationLoop());

    if (this.renderer && this.scene && this.camera) {
      this.renderer.render(this.scene, this.camera);
    }
  }

  private cleanup(): void {
    if (this.animationFrameId !== undefined) {
      cancelAnimationFrame(this.animationFrameId);
    }

    if (this.boundHandleResize) {
      window.removeEventListener('resize', this.boundHandleResize);
    }

    if (this.renderer) {
      this.renderer.dispose();
    }

    if (this.scene) {
      this.scene.clear();
    }
  }

  override render() {
    return html`
      <div class="container">
        <header>
          <h1>OpenFront Map Editor</h1>
        </header>
        <div class="canvas-container">
          <canvas id="renderCanvas"></canvas>
          <div class="info">
            Three.js r${this.threeVersion} | WebGL 2D Map Renderer
          </div>
        </div>
      </div>
    `;
  }
}

declare global {
  interface HTMLElementTagNameMap {
    'map-editor-app': MapEditorApp;
  }
}
