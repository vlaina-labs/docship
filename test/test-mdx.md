> ⚠️ **This is a test file for DocShip development. The content below is sample documentation.**

# MDX/JSX Syntax Test

## JSX Components

<Button>Click me</Button>

<Card title="Test">
  Content inside card
</Card>

<MyComponent prop={value} />

<Component
  prop1="string"
  prop2={123}
  prop3={true}
  prop4={{ key: 'value' }}
  prop5={[1, 2, 3]}
/>

## JSX Expressions

{1 + 1}
{variable}
{items.map(item => <li>{item}</li>)}
{condition && <span>Shown</span>}
{condition ? <A /> : <B />}

## Import/Export Statements

import Component from './Component'
import { named } from 'package'
export const meta = { title: 'Test' }
export default function Page() {}

## Self-closing Tags

<br />
<hr />
<img src="test.png" />
<input type="text" />
<Component />

## Fragments

<>
  <p>First</p>
  <p>Second</p>
</>

<React.Fragment>
  Content
</React.Fragment>

## Invalid JSX

<Component without="closing"
<unclosed>content
<123invalid>numbers</123invalid>
<-invalid>dash</-invalid>

## Normal Content

This should render normally.
