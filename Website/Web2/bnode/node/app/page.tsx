import Image from 'next/image'
import React, {useEffect, } from "react";

export default function Home() {
  return (

    <main className="flex min-h-screen flex-col items-center justify-between p-24">
      <div className="z-10 w-full max-w-5xl items-center justify-between font-mono text-sm lg:flex">
        <p className="fixed left-0 top-0 flex w-full justify-center border-b border-gray-300 bg-gradient-to-b from-zinc-200 pb-6 pt-8 backdrop-blur-2xl dark:border-neutral-800 dark:bg-zinc-800/30 dark:from-inherit lg:static lg:w-auto  lg:rounded-xl lg:border lg:bg-gray-200 lg:p-4 lg:dark:bg-zinc-800/30">
          Block Node Chain&nbsp;
          <code className="font-mono font-bold"></code>
          under Development
        </p>
        <div className="fixed bottom-0 left-0 flex h-48 w-full items-end justify-center bg-gradient-to-t from-white via-white dark:from-black dark:via-black lg:static lg:h-auto lg:w-auto lg:bg-none">
          <a
            className="pointer-events-none flex place-items-center gap-2 p-8 lg:pointer-events-auto lg:p-0"
            href="https://www.linkedin.com/company/lfnbnc"
            target="_blank"
            rel="noopener noreferrer"
          >
            {' '}
            <Image
              src="/Main.png"
              alt="Logo"
              
              width={30}
              height={24}
              priority
            />
          </a>
        </div>
      </div>
      <div>
        <video
        className="absolute top-0 left-0 w-full h-full object-cover z-0"
         
          src="/vd.mp4"
          width={200}
          height={100}
          autoPlay
          loop
          muted
        />
      </div>
      <div className="mb-20 grid text-bottom lg:mb-2 lg:grid-cols-4 lg:text-center">
        <a
          href="https://github.com/L-F-N-BlockNodeChain"
          className="group border border-transparent px-10 py-10 transition-colors hover:border-violet-500 hover:bg-gray-100 hover:blue:border-neutral-700 hover:dark:bg-neutral-800/30">
          <h1 className={` text-0x0 font-bold `}>
            Block Node Chain {' '}
          </h1>
        </a>
      </div>
    </main>
  )
}



