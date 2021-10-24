Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6F04389E2
	for <lists+kvm@lfdr.de>; Sun, 24 Oct 2021 17:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231721AbhJXPjs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 24 Oct 2021 11:39:48 -0400
Received: from elvis.franken.de ([193.175.24.41]:37591 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231548AbhJXPjq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 24 Oct 2021 11:39:46 -0400
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1mefYp-0006bc-00; Sun, 24 Oct 2021 17:37:23 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
        id EA98EC2649; Sun, 24 Oct 2021 17:26:04 +0200 (CEST)
Date:   Sun, 24 Oct 2021 17:26:04 +0200
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Rob Herring <robh+dt@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-perf-users@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH] MIPS: Remove NETLOGIC support
Message-ID: <20211024152604.GA4721@alpha.franken.de>
References: <20211020124923.130298-1-tsbogend@alpha.franken.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211020124923.130298-1-tsbogend@alpha.franken.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 20, 2021 at 02:49:13PM +0200, Thomas Bogendoerfer wrote:
> No (active) developer owns this hardware, so let's remove Linux support.
> 
> Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> ---
>  arch/mips/Kbuild.platforms                    |   1 -
>  arch/mips/Kconfig                             |  91 +--
>  arch/mips/boot/compressed/uart-16550.c        |  12 -
>  arch/mips/boot/dts/Makefile                   |   1 -
>  arch/mips/boot/dts/netlogic/Makefile          |   8 -
>  arch/mips/boot/dts/netlogic/xlp_evp.dts       | 131 ----
>  arch/mips/boot/dts/netlogic/xlp_fvp.dts       | 131 ----
>  arch/mips/boot/dts/netlogic/xlp_gvp.dts       |  89 ---
>  arch/mips/boot/dts/netlogic/xlp_rvp.dts       |  89 ---
>  arch/mips/boot/dts/netlogic/xlp_svp.dts       | 131 ----
>  arch/mips/configs/nlm_xlp_defconfig           | 557 -----------------
>  arch/mips/configs/nlm_xlr_defconfig           | 508 ----------------
>  arch/mips/include/asm/cop2.h                  |  11 -
>  arch/mips/include/asm/cpu-type.h              |   8 -
>  arch/mips/include/asm/cpu.h                   |   2 +-
>  arch/mips/include/asm/hazards.h               |   2 +-
>  .../asm/mach-netlogic/cpu-feature-overrides.h |  57 --
>  arch/mips/include/asm/mach-netlogic/irq.h     |  17 -
>  .../include/asm/mach-netlogic/multi-node.h    |  74 ---
>  arch/mips/include/asm/netlogic/common.h       | 132 ----
>  arch/mips/include/asm/netlogic/haldefs.h      | 171 ------
>  arch/mips/include/asm/netlogic/interrupt.h    |  45 --
>  arch/mips/include/asm/netlogic/mips-extns.h   | 301 ---------
>  arch/mips/include/asm/netlogic/psb-bootinfo.h |  95 ---
>  .../include/asm/netlogic/xlp-hal/bridge.h     | 186 ------
>  .../include/asm/netlogic/xlp-hal/cpucontrol.h |  89 ---
>  .../mips/include/asm/netlogic/xlp-hal/iomap.h | 214 -------
>  .../include/asm/netlogic/xlp-hal/pcibus.h     | 113 ----
>  arch/mips/include/asm/netlogic/xlp-hal/pic.h  | 366 -----------
>  arch/mips/include/asm/netlogic/xlp-hal/sys.h  | 213 -------
>  arch/mips/include/asm/netlogic/xlp-hal/uart.h | 192 ------
>  arch/mips/include/asm/netlogic/xlp-hal/xlp.h  | 119 ----
>  arch/mips/include/asm/netlogic/xlr/bridge.h   | 104 ----
>  arch/mips/include/asm/netlogic/xlr/flash.h    |  55 --
>  arch/mips/include/asm/netlogic/xlr/fmn.h      | 365 -----------
>  arch/mips/include/asm/netlogic/xlr/gpio.h     |  74 ---
>  arch/mips/include/asm/netlogic/xlr/iomap.h    | 109 ----
>  arch/mips/include/asm/netlogic/xlr/msidef.h   |  84 ---
>  arch/mips/include/asm/netlogic/xlr/pic.h      | 306 ----------
>  arch/mips/include/asm/netlogic/xlr/xlr.h      |  59 --
>  arch/mips/include/asm/processor.h             |  13 -
>  arch/mips/include/asm/vermagic.h              |   4 -
>  arch/mips/kernel/cpu-probe.c                  |  84 ---
>  arch/mips/kernel/idle.c                       |   2 -
>  arch/mips/kernel/perf_event_mipsxx.c          |  86 ---
>  arch/mips/kvm/entry.c                         |   8 +-
>  arch/mips/mm/c-r4k.c                          |   2 -
>  arch/mips/mm/tlbex.c                          |   9 +-
>  arch/mips/netlogic/Kconfig                    |  86 ---
>  arch/mips/netlogic/Makefile                   |   4 -
>  arch/mips/netlogic/Platform                   |  16 -
>  arch/mips/netlogic/common/Makefile            |   5 -
>  arch/mips/netlogic/common/earlycons.c         |  63 --
>  arch/mips/netlogic/common/irq.c               | 350 -----------
>  arch/mips/netlogic/common/reset.S             | 299 ---------
>  arch/mips/netlogic/common/smp.c               | 285 ---------
>  arch/mips/netlogic/common/smpboot.S           | 141 -----
>  arch/mips/netlogic/common/time.c              | 110 ----
>  arch/mips/netlogic/xlp/Makefile               |  11 -
>  arch/mips/netlogic/xlp/ahci-init-xlp2.c       | 390 ------------
>  arch/mips/netlogic/xlp/ahci-init.c            | 209 -------
>  arch/mips/netlogic/xlp/cop2-ex.c              | 121 ----
>  arch/mips/netlogic/xlp/dt.c                   |  95 ---
>  arch/mips/netlogic/xlp/nlm_hal.c              | 508 ----------------
>  arch/mips/netlogic/xlp/setup.c                | 174 ------
>  arch/mips/netlogic/xlp/usb-init-xlp2.c        | 288 ---------
>  arch/mips/netlogic/xlp/usb-init.c             | 149 -----
>  arch/mips/netlogic/xlp/wakeup.c               | 212 -------
>  arch/mips/netlogic/xlr/Makefile               |   3 -
>  arch/mips/netlogic/xlr/fmn-config.c           | 296 ---------
>  arch/mips/netlogic/xlr/fmn.c                  | 199 ------
>  arch/mips/netlogic/xlr/platform-flash.c       | 216 -------
>  arch/mips/netlogic/xlr/platform.c             | 250 --------
>  arch/mips/netlogic/xlr/setup.c                | 206 -------
>  arch/mips/netlogic/xlr/wakeup.c               |  85 ---
>  arch/mips/pci/Makefile                        |   3 -
>  arch/mips/pci/msi-xlp.c                       | 571 ------------------
>  arch/mips/pci/pci-xlp.c                       | 332 ----------
>  arch/mips/pci/pci-xlr.c                       | 368 -----------
>  79 files changed, 6 insertions(+), 11559 deletions(-)
>  delete mode 100644 arch/mips/boot/dts/netlogic/Makefile
>  delete mode 100644 arch/mips/boot/dts/netlogic/xlp_evp.dts
>  delete mode 100644 arch/mips/boot/dts/netlogic/xlp_fvp.dts
>  delete mode 100644 arch/mips/boot/dts/netlogic/xlp_gvp.dts
>  delete mode 100644 arch/mips/boot/dts/netlogic/xlp_rvp.dts
>  delete mode 100644 arch/mips/boot/dts/netlogic/xlp_svp.dts
>  delete mode 100644 arch/mips/configs/nlm_xlp_defconfig
>  delete mode 100644 arch/mips/configs/nlm_xlr_defconfig
>  delete mode 100644 arch/mips/include/asm/mach-netlogic/cpu-feature-overrides.h
>  delete mode 100644 arch/mips/include/asm/mach-netlogic/irq.h
>  delete mode 100644 arch/mips/include/asm/mach-netlogic/multi-node.h
>  delete mode 100644 arch/mips/include/asm/netlogic/common.h
>  delete mode 100644 arch/mips/include/asm/netlogic/haldefs.h
>  delete mode 100644 arch/mips/include/asm/netlogic/interrupt.h
>  delete mode 100644 arch/mips/include/asm/netlogic/mips-extns.h
>  delete mode 100644 arch/mips/include/asm/netlogic/psb-bootinfo.h
>  delete mode 100644 arch/mips/include/asm/netlogic/xlp-hal/bridge.h
>  delete mode 100644 arch/mips/include/asm/netlogic/xlp-hal/cpucontrol.h
>  delete mode 100644 arch/mips/include/asm/netlogic/xlp-hal/iomap.h
>  delete mode 100644 arch/mips/include/asm/netlogic/xlp-hal/pcibus.h
>  delete mode 100644 arch/mips/include/asm/netlogic/xlp-hal/pic.h
>  delete mode 100644 arch/mips/include/asm/netlogic/xlp-hal/sys.h
>  delete mode 100644 arch/mips/include/asm/netlogic/xlp-hal/uart.h
>  delete mode 100644 arch/mips/include/asm/netlogic/xlp-hal/xlp.h
>  delete mode 100644 arch/mips/include/asm/netlogic/xlr/bridge.h
>  delete mode 100644 arch/mips/include/asm/netlogic/xlr/flash.h
>  delete mode 100644 arch/mips/include/asm/netlogic/xlr/fmn.h
>  delete mode 100644 arch/mips/include/asm/netlogic/xlr/gpio.h
>  delete mode 100644 arch/mips/include/asm/netlogic/xlr/iomap.h
>  delete mode 100644 arch/mips/include/asm/netlogic/xlr/msidef.h
>  delete mode 100644 arch/mips/include/asm/netlogic/xlr/pic.h
>  delete mode 100644 arch/mips/include/asm/netlogic/xlr/xlr.h
>  delete mode 100644 arch/mips/netlogic/Kconfig
>  delete mode 100644 arch/mips/netlogic/Makefile
>  delete mode 100644 arch/mips/netlogic/Platform
>  delete mode 100644 arch/mips/netlogic/common/Makefile
>  delete mode 100644 arch/mips/netlogic/common/earlycons.c
>  delete mode 100644 arch/mips/netlogic/common/irq.c
>  delete mode 100644 arch/mips/netlogic/common/reset.S
>  delete mode 100644 arch/mips/netlogic/common/smp.c
>  delete mode 100644 arch/mips/netlogic/common/smpboot.S
>  delete mode 100644 arch/mips/netlogic/common/time.c
>  delete mode 100644 arch/mips/netlogic/xlp/Makefile
>  delete mode 100644 arch/mips/netlogic/xlp/ahci-init-xlp2.c
>  delete mode 100644 arch/mips/netlogic/xlp/ahci-init.c
>  delete mode 100644 arch/mips/netlogic/xlp/cop2-ex.c
>  delete mode 100644 arch/mips/netlogic/xlp/dt.c
>  delete mode 100644 arch/mips/netlogic/xlp/nlm_hal.c
>  delete mode 100644 arch/mips/netlogic/xlp/setup.c
>  delete mode 100644 arch/mips/netlogic/xlp/usb-init-xlp2.c
>  delete mode 100644 arch/mips/netlogic/xlp/usb-init.c
>  delete mode 100644 arch/mips/netlogic/xlp/wakeup.c
>  delete mode 100644 arch/mips/netlogic/xlr/Makefile
>  delete mode 100644 arch/mips/netlogic/xlr/fmn-config.c
>  delete mode 100644 arch/mips/netlogic/xlr/fmn.c
>  delete mode 100644 arch/mips/netlogic/xlr/platform-flash.c
>  delete mode 100644 arch/mips/netlogic/xlr/platform.c
>  delete mode 100644 arch/mips/netlogic/xlr/setup.c
>  delete mode 100644 arch/mips/netlogic/xlr/wakeup.c
>  delete mode 100644 arch/mips/pci/msi-xlp.c
>  delete mode 100644 arch/mips/pci/pci-xlp.c
>  delete mode 100644 arch/mips/pci/pci-xlr.c

applied to mips-next.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
