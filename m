Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C44BB3FAE
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2019 19:41:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387784AbfIPRlO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Sep 2019 13:41:14 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:36787 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387723AbfIPRlO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Sep 2019 13:41:14 -0400
Received: by mail-pg1-f194.google.com with SMTP id m29so409925pgc.3
        for <kvm@vger.kernel.org>; Mon, 16 Sep 2019 10:41:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=date:subject:in-reply-to:cc:from:to:message-id:mime-version
         :content-transfer-encoding;
        bh=bMcdXfbJ1riLi9JAK1iwlL88k1aVkELdY7KmYtHMseo=;
        b=hBqa6dyZ7sWquxE5FVCH7hW+6C4IyhXgRt/wDCQPTHMe4M1vuYzE0za1IQKmSWkE04
         Khr7LNmPpnFMbg6ALWzKHKHcfia9rLYcQN3G66msGXC9wB6E9qLna6FO7eRvvJStTkGX
         EpsQ9dRIZjHQGraVGCBTKofN+/zru9jrjjwdJdnbd9HPX4RvSnEO4q5bKh/UKvw5okED
         W8F4MBvdKofKdZNZD2eu/2dnYCJ7uAkYTvVtrb8Vgqd+jxTRijPXehgiEx9b1APtK0Rm
         yHJ+lC2gar0elK1Er6V2J/3p6rPCBSCG/B9/vpDc/f7iAG1KuvmSutTPdM0GmX7q/n+k
         YhAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
         :mime-version:content-transfer-encoding;
        bh=bMcdXfbJ1riLi9JAK1iwlL88k1aVkELdY7KmYtHMseo=;
        b=CXWRKi6HYgONtStlL5YnYZK+0SAuVn5AqFvyht/97hvDzroCjXx2viR26tfQ0gxM4K
         g4F8jbb9knTW85WTK73wTqybc021OLjT+V+VIzOYkR0/H6PFD9ICMXM3X+rN1AQw71RL
         sbwb7GOo6QjNuQjllLrq1PA+5Xr7Bm/KsSbUgtP2yuLnZZmIp5eDHAEgx2SElHj4xmXw
         jUb6w/YcGbdgCLmVRiq2qauePNpHL8es3AwMXN7SfzyW7Ucdkyb/3+L/UQ3G/8fVDdaC
         Gund5IV7RjC2i0waNFWSSam+5r3DJMPVvrceOef8eZR3ne3K0ysGAyfMLVbSXttVn4gh
         AlgQ==
X-Gm-Message-State: APjAAAXUWSyVwR6bhYoAD7QSXaPbOIqaH23/weXnYBxIenRCOOeE4Dl8
        znZ5vfuGbjQKPIPgcdW7DjHpTw==
X-Google-Smtp-Source: APXvYqyFhdiOjIDAQaP1Mn+6slxe6gt9/32AMHp4zhwkNPujUH7OtCbj7utQo3zTqp/5825Yz3WP0w==
X-Received: by 2002:a17:90a:b001:: with SMTP id x1mr394005pjq.114.1568655671668;
        Mon, 16 Sep 2019 10:41:11 -0700 (PDT)
Received: from localhost ([12.206.222.5])
        by smtp.gmail.com with ESMTPSA id d69sm42991797pfd.175.2019.09.16.10.41.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Sep 2019 10:41:10 -0700 (PDT)
Date:   Mon, 16 Sep 2019 10:41:10 -0700 (PDT)
X-Google-Original-Date: Mon, 16 Sep 2019 10:41:04 PDT (-0700)
Subject:     Re: [GIT PULL] First batch of KVM changes for Linux 5.4
In-Reply-To: <1568652881-21933-1-git-send-email-pbonzini@redhat.com>
CC:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, rkrcmar@redhat.com,
        kvm@vger.kernel.org
From:   Palmer Dabbelt <palmer@sifive.com>
To:     pbonzini@redhat.com
Message-ID: <mhng-2c21c47b-7978-4a19-83ef-2b0db183202e@palmer-si-x1c4>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 16 Sep 2019 09:54:41 PDT (-0700), pbonzini@redhat.com wrote:
> Linus,
>
> The following changes since commit e4427372398c31f57450565de277f861a4db5b3b:
>
>   selftests/kvm: make platform_info_test pass on AMD (2019-08-21 19:08:18 +0200)
>
> are available in the git repository at:
>
>   https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
>
> for you to fetch changes up to fb3925d06c285e1acb248addc5d80b33ea771b0f:
>
>   KVM: X86: Use IPI shorthands in kvm guest when support (2019-09-14 00:19:46 +0200)
>
> ----------------------------------------------------------------
> * s390: ioctl hardening, selftests
>
> * ARM: ITS translation cache; support for 512 vCPUs, various cleanups
> and bugfixes
>
> * PPC: various minor fixes and preparation
>
> * x86: bugfixes all over the place (posted interrupts, SVM, emulation
> corner cases, blocked INIT), some IPI optimizations
>
> ----------------------------------------------------------------
>
> RISC-V was delayed even though it is basically ready as far as I am
> concerned.  More x86 changes will come next week.

The issue with the RISC-V port is that the ISA isn't finalized yet, and we 
don't want to take a port for an ISA that may be changing.

> Alexander Graf (1):
>       KVM: x86: Disable posted interrupts for non-standard IRQs delivery modes
>
> Alexandru Elisei (1):
>       KVM: arm/arm64: vgic: Make function comments match function declarations
>
> Cornelia Huck (1):
>       KVM: s390: improve documentation for S390_MEM_OP
>
> Cédric Le Goater (1):
>       KVM: PPC: Book3S HV: XIVE: Free escalation interrupts before disabling the VP
>
> Dan Carpenter (1):
>       x86: KVM: svm: Fix a check in nested_svm_vmrun()
>
> Eric Auger (1):
>       KVM: arm/arm64: vgic: Use a single IO device per redistributor
>
> Fabiano Rosas (1):
>       KVM: PPC: Remove leftover comment from emulate_loadstore.c
>
> James Morse (1):
>       arm64: KVM: Device mappings should be execute-never
>
> Jan Dakinevich (2):
>       KVM: x86: always stop emulation on page fault
>       KVM: x86: set ctxt->have_exception in x86_decode_insn()
>
> Jiří Paleček (1):
>       kvm: Nested KVM MMUs need PAE root too
>
> Liran Alon (3):
>       KVM: x86: Return to userspace with internal error on unexpected exit reason
>       KVM: VMX: Introduce exit reason for receiving INIT signal on guest-mode
>       KVM: x86: Fix INIT signal handling in various CPU states
>
> Marc Zyngier (13):
>       KVM: arm/arm64: vgic: Add LPI translation cache definition
>       KVM: arm/arm64: vgic: Add __vgic_put_lpi_locked primitive
>       KVM: arm/arm64: vgic-its: Add MSI-LPI translation cache invalidation
>       KVM: arm/arm64: vgic-its: Invalidate MSI-LPI translation cache on specific commands
>       KVM: arm/arm64: vgic-its: Invalidate MSI-LPI translation cache on disabling LPIs
>       KVM: arm/arm64: vgic-its: Invalidate MSI-LPI translation cache on ITS disable
>       KVM: arm/arm64: vgic-its: Invalidate MSI-LPI translation cache on vgic teardown
>       KVM: arm/arm64: vgic-its: Cache successful MSI->LPI translation
>       KVM: arm/arm64: vgic-its: Check the LPI translation cache on MSI injection
>       KVM: arm/arm64: vgic-irqfd: Implement kvm_arch_set_irq_inatomic
>       KVM: Call kvm_arch_vcpu_blocking early into the blocking sequence
>       KVM: arm/arm64: vgic: Remove spurious semicolons
>       KVM: arm/arm64: vgic: Allow more than 256 vcpus for KVM_IRQ_LINE
>
> Mark Cave-Ayland (1):
>       KVM: PPC: Book3S PR: Fix software breakpoints
>
> Mark Rutland (1):
>       arm64/kvm: Remove VMID rollover I-cache maintenance
>
> Paolo Bonzini (6):
>       KVM: x86: fix reporting of AMD speculation bug CPUID leaf
>       KVM: x86: always expose VIRT_SSBD to guests
>       KVM: x86: use Intel speculation bugs and features as derived in generic x86 code
>       Merge tag 'kvm-ppc-next-5.4-1' of git://git.kernel.org/.../paulus/powerpc into HEAD
>       Merge tag 'kvmarm-5.4' of git://git.kernel.org/.../kvmarm/kvmarm into HEAD
>       Merge tag 'kvm-s390-next-5.4-1' of git://git.kernel.org/.../kvms390/linux into HEAD
>
> Paul Mackerras (7):
>       KVM: PPC: Book3S HV: Fix race in re-enabling XIVE escalation interrupts
>       KVM: PPC: Book3S HV: Don't push XIVE context when not using XIVE device
>       powerpc/xive: Implement get_irqchip_state method for XIVE to fix shutdown race
>       Merge remote-tracking branch 'remotes/powerpc/topic/ppc-kvm' into kvm-ppc-next
>       KVM: PPC: Book3S: Enable XIVE native capability only if OPAL has required functions
>       KVM: PPC: Book3S HV: Check for MMU ready on piggybacked virtual cores
>       KVM: PPC: Book3S HV: Don't lose pending doorbell request on migration on P9
>
> Paul Menzel (1):
>       KVM: PPC: Book3S: Mark expected switch fall-through
>
> Peter Xu (4):
>       KVM: X86: Trace vcpu_id for vmexit
>       KVM: X86: Remove tailing newline for tracepoints
>       KVM: VMX: Change ple_window type to unsigned int
>       KVM: X86: Tune PLE Window tracepoint
>
> Sean Christopherson (12):
>       KVM: x86: Fix x86_decode_insn() return when fetching insn bytes fails
>       KVM: x86: Rename access permissions cache member in struct kvm_vcpu_arch
>       KVM: x86/mmu: Add explicit access mask for MMIO SPTEs
>       KVM: x86/mmu: Consolidate "is MMIO SPTE" code
>       KVM: x86: Unconditionally call x86 ops that are always implemented
>       KVM: Assert that struct kvm_vcpu is always as offset zero
>       KVM: VMX: Fix and tweak the comments for VM-Enter
>       KVM: x86: Manually calculate reserved bits when loading PDPTRS
>       KVM: x86: Refactor up kvm_{g,s}et_msr() to simplify callers
>       KVM: x86: Add kvm_emulate_{rd,wr}msr() to consolidate VXM/SVM code
>       KVM: nVMX: add tracepoint for failed nested VM-Enter
>       KVM: nVMX: trace nested VM-Enter failures detected by H/W
>
> Suraj Jitindar Singh (1):
>       KVM: PPC: Book3S HV: Define usage types for rmap array in guest memslot
>
> Thomas Huth (7):
>       KVM: selftests: Split ucall.c into architecture specific files
>       KVM: selftests: Implement ucall() for s390x
>       KVM: selftests: Enable dirty_log_test on s390x
>       KVM: s390: Test for bad access register and size at the start of S390_MEM_OP
>       KVM: selftests: Add a test for the KVM_S390_MEM_OP ioctl
>       KVM: s390: Disallow invalid bits in kvm_valid_regs and kvm_dirty_regs
>       KVM: selftests: Test invalid bits in kvm_valid_regs and kvm_dirty_regs on s390x
>
> Vitaly Kuznetsov (7):
>       x86: KVM: svm: don't pretend to advance RIP in case wrmsr_interception() results in #GP
>       x86: kvm: svm: propagate errors from skip_emulated_instruction()
>       x86: KVM: clear interrupt shadow on EMULTYPE_SKIP
>       x86: KVM: add xsetbv to the emulator
>       x86: KVM: svm: remove hardcoded instruction length from intercepts
>       x86: KVM: svm: eliminate weird goto from vmrun_interception()
>       x86: KVM: svm: eliminate hardcoded RIP advancement from vmrun_interception()
>
> Wanpeng Li (4):
>       KVM: X86: Add pv tlb shootdown tracepoint
>       KVM: LAPIC: Micro optimize IPI latency
>       KVM: VMX: Stop the preemption timer during vCPU reset
>       KVM: X86: Use IPI shorthands in kvm guest when support
>
> Xiaoyao Li (1):
>       doc: kvm: Fix return description of KVM_SET_MSRS
>
>  .gitignore                                         |   3 +
>  .mailmap                                           |   3 +
>  Documentation/PCI/pci-error-recovery.rst           |   5 +-
>  Documentation/RCU/rculist_nulls.txt                |   2 +-
>  Documentation/admin-guide/conf.py                  |  10 -
>  Documentation/admin-guide/hw-vuln/spectre.rst      |  88 ++-
>  Documentation/admin-guide/kernel-parameters.txt    |   8 +-
>  Documentation/admin-guide/mm/transhuge.rst         |   2 +-
>  Documentation/conf.py                              |  30 +-
>  Documentation/core-api/conf.py                     |  10 -
>  Documentation/crypto/conf.py                       |  10 -
>  Documentation/dev-tools/conf.py                    |  10 -
>  .../devicetree/bindings/arm/idle-states.txt        |   2 +-
>  Documentation/devicetree/bindings/arm/renesas.yaml |   2 +-
>  .../bindings/arm/socionext/milbeaut.yaml           |   2 +-
>  .../devicetree/bindings/arm/ti/ti,davinci.yaml     |   2 +-
>  .../bindings/clock/allwinner,sun4i-a10-ccu.yaml    |   2 +-
>  .../intel,ixp4xx-network-processing-engine.yaml    |   2 +-
>  .../devicetree/bindings/iio/accel/adi,adxl345.yaml |   2 +-
>  .../devicetree/bindings/iio/accel/adi,adxl372.yaml |   2 +-
>  .../interrupt-controller/amazon,al-fic.txt         |  16 +-
>  .../intel,ixp4xx-interrupt.yaml                    |   2 +-
>  ...er.yaml => intel,ixp4xx-ahb-queue-manager.yaml} |   2 +-
>  .../bindings/net/allwinner,sun8i-a83t-emac.yaml    |   2 +-
>  .../bindings/nvmem/allwinner,sun4i-a10-sid.yaml    |   4 +-
>  .../devicetree/bindings/nvmem/nvmem-consumer.yaml  |  45 ++
>  Documentation/devicetree/bindings/nvmem/nvmem.txt  |  81 +--
>  Documentation/devicetree/bindings/nvmem/nvmem.yaml |  93 +++
>  .../phy/allwinner,sun6i-a31-mipi-dphy.yaml         |   2 +-
>  Documentation/devicetree/bindings/riscv/cpus.txt   | 162 -----
>  Documentation/devicetree/bindings/riscv/cpus.yaml  |  16 +
>  .../devicetree/bindings/riscv/sifive.yaml          |   2 +-
>  .../devicetree/bindings/spi/spi-controller.yaml    |   1 -
>  .../bindings/timer/intel,ixp4xx-timer.yaml         |   2 +-
>  Documentation/devicetree/bindings/usb/usb251xb.txt |   6 +-
>  Documentation/doc-guide/conf.py                    |  10 -
>  Documentation/driver-api/80211/conf.py             |  10 -
>  Documentation/driver-api/conf.py                   |  10 -
>  Documentation/driver-api/generic-counter.rst       |   4 +-
>  Documentation/driver-api/phy/phy.rst               |   4 +-
>  Documentation/driver-api/pm/conf.py                |  10 -
>  Documentation/filesystems/cifs/TODO                |  26 +-
>  Documentation/filesystems/conf.py                  |  10 -
>  Documentation/gpu/conf.py                          |  10 -
>  Documentation/hwmon/k8temp.rst                     |   2 +-
>  Documentation/index.rst                            |   3 +
>  Documentation/input/conf.py                        |  10 -
>  Documentation/kernel-hacking/conf.py               |  10 -
>  Documentation/locking/spinlocks.rst                |   4 +-
>  Documentation/maintainer/conf.py                   |  10 -
>  Documentation/media/conf.py                        |  12 -
>  Documentation/memory-barriers.txt                  |   2 +-
>  Documentation/networking/conf.py                   |  10 -
>  Documentation/networking/tls-offload.rst           |  23 +-
>  Documentation/power/index.rst                      |   2 +-
>  .../powerpc/{bootwrapper.txt => bootwrapper.rst}   |  28 +-
>  .../powerpc/{cpu_families.txt => cpu_families.rst} |  23 +-
>  .../powerpc/{cpu_features.txt => cpu_features.rst} |   6 +-
>  Documentation/powerpc/{cxl.txt => cxl.rst}         |  46 +-
>  .../powerpc/{cxlflash.txt => cxlflash.rst}         |  10 +-
>  .../powerpc/{DAWR-POWER9.txt => dawr-power9.rst}   |  15 +-
>  Documentation/powerpc/{dscr.txt => dscr.rst}       |  18 +-
>  ...ror-recovery.txt => eeh-pci-error-recovery.rst} | 108 +--
>  ...ssisted-dump.txt => firmware-assisted-dump.rst} | 117 ++--
>  Documentation/powerpc/{hvcs.txt => hvcs.rst}       | 108 +--
>  Documentation/powerpc/index.rst                    |  34 +
>  Documentation/powerpc/isa-versions.rst             |  15 +-
>  Documentation/powerpc/{mpc52xx.txt => mpc52xx.rst} |  12 +-
>  ...powernv.txt => pci_iov_resource_on_powernv.rst} |  15 +-
>  Documentation/powerpc/{pmu-ebb.txt => pmu-ebb.rst} |   1 +
>  Documentation/powerpc/ptrace.rst                   | 156 +++++
>  Documentation/powerpc/ptrace.txt                   | 151 -----
>  .../powerpc/{qe_firmware.txt => qe_firmware.rst}   |  37 +-
>  .../{syscall64-abi.txt => syscall64-abi.rst}       |  29 +-
>  ...ctional_memory.txt => transactional_memory.rst} |  45 +-
>  Documentation/process/conf.py                      |  10 -
>  Documentation/process/deprecated.rst               |  14 +
>  Documentation/s390/vfio-ccw.rst                    |  31 +-
>  Documentation/sh/conf.py                           |  10 -
>  Documentation/sound/conf.py                        |  10 -
>  Documentation/sphinx/load_config.py                |  27 +-
>  .../translations/it_IT/doc-guide/sphinx.rst        |  19 +-
>  Documentation/translations/it_IT/process/index.rst |   1 +
>  .../translations/it_IT/process/kernel-docs.rst     |  11 +-
>  .../it_IT/process/maintainer-pgp-guide.rst         |  25 +-
>  .../it_IT/process/programming-language.rst         |  51 ++
>  .../translations/ko_KR/memory-barriers.txt         |   2 +-
>  Documentation/userspace-api/conf.py                |  10 -
>  Documentation/virt/kvm/api.txt                     |  33 +-
>  Documentation/virt/kvm/index.rst                   |   1 +
>  Documentation/virt/kvm/mmu.txt                     |   4 +-
>  Documentation/vm/conf.py                           |  10 -
>  Documentation/vm/hmm.rst                           |   2 +-
>  Documentation/watchdog/hpwdt.rst                   |   2 +-
>  Documentation/x86/conf.py                          |  10 -
>  MAINTAINERS                                        |  61 +-
>  Makefile                                           |  28 +-
>  arch/arm/Kconfig.debug                             |   5 -
>  arch/arm/boot/dts/bcm47094-linksys-panamera.dts    |   3 +
>  arch/arm/boot/dts/imx6ul-14x14-evk.dtsi            |   2 +-
>  arch/arm/boot/dts/imx6ul-geam.dts                  |   2 +-
>  arch/arm/boot/dts/imx6ul-isiot.dtsi                |   2 +-
>  arch/arm/boot/dts/imx6ul-pico-hobbit.dts           |   2 +-
>  arch/arm/boot/dts/imx6ul-pico-pi.dts               |   4 +-
>  arch/arm/boot/dts/imx7ulp.dtsi                     |   2 +-
>  arch/arm/configs/u8500_defconfig                   |  34 +-
>  arch/arm/include/asm/dma-mapping.h                 |   4 +-
>  arch/arm/include/uapi/asm/kvm.h                    |   4 +-
>  arch/arm/kernel/hw_breakpoint.c                    |   5 +
>  arch/arm/kernel/signal.c                           |   1 +
>  arch/arm/mach-davinci/sleep.S                      |   1 +
>  arch/arm/mach-ep93xx/crunch.c                      |   1 +
>  arch/arm/mach-netx/Kconfig                         |  22 -
>  arch/arm/mach-netx/Makefile                        |  13 -
>  arch/arm/mach-netx/Makefile.boot                   |   3 -
>  arch/arm/mach-netx/fb.c                            |  65 --
>  arch/arm/mach-netx/fb.h                            |  12 -
>  arch/arm/mach-netx/generic.c                       | 182 -----
>  arch/arm/mach-netx/generic.h                       |  14 -
>  arch/arm/mach-netx/include/mach/hardware.h         |  27 -
>  arch/arm/mach-netx/include/mach/irqs.h             |  58 --
>  arch/arm/mach-netx/include/mach/netx-regs.h        | 420 ------------
>  arch/arm/mach-netx/include/mach/pfifo.h            |  42 --
>  arch/arm/mach-netx/include/mach/uncompress.h       |  63 --
>  arch/arm/mach-netx/include/mach/xc.h               |  30 -
>  arch/arm/mach-netx/nxdb500.c                       | 197 ------
>  arch/arm/mach-netx/nxdkn.c                         |  90 ---
>  arch/arm/mach-netx/nxeb500hmi.c                    | 174 -----
>  arch/arm/mach-netx/pfifo.c                         |  56 --
>  arch/arm/mach-netx/time.c                          | 141 ----
>  arch/arm/mach-netx/xc.c                            | 246 -------
>  arch/arm/mach-tegra/reset.c                        |   2 +-
>  arch/arm/mm/Kconfig                                |   5 +
>  arch/arm/mm/alignment.c                            |   4 +-
>  arch/arm/mm/dma-mapping.c                          |  61 ++
>  arch/arm/mm/init.c                                 |   5 +
>  arch/arm/plat-omap/dma.c                           |  14 +-
>  arch/arm64/Makefile                                |   2 +-
>  arch/arm64/boot/dts/freescale/imx8mm-pinfunc.h     |   4 +-
>  arch/arm64/boot/dts/freescale/imx8mq.dtsi          |   3 +-
>  arch/arm64/include/asm/arch_gicv3.h                |   6 +
>  arch/arm64/include/asm/cpufeature.h                |   7 +-
>  arch/arm64/include/asm/daifflags.h                 |   2 +
>  arch/arm64/include/asm/efi.h                       |   6 +-
>  arch/arm64/include/asm/elf.h                       |   2 +-
>  arch/arm64/include/asm/memory.h                    |  10 +-
>  arch/arm64/include/asm/pgtable-prot.h              |   2 +-
>  arch/arm64/include/asm/pgtable.h                   |  12 +-
>  arch/arm64/include/asm/processor.h                 |  14 +-
>  arch/arm64/include/asm/ptrace.h                    |   2 +-
>  arch/arm64/include/asm/stacktrace.h                |  78 ++-
>  arch/arm64/include/asm/vdso/compat_gettimeofday.h  |  40 ++
>  arch/arm64/include/uapi/asm/bpf_perf_event.h       |   2 +-
>  arch/arm64/include/uapi/asm/kvm.h                  |   4 +-
>  arch/arm64/kernel/cpufeature.c                     |   8 +-
>  arch/arm64/kernel/debug-monitors.c                 |  14 +-
>  arch/arm64/kernel/entry.S                          |  22 +-
>  arch/arm64/kernel/fpsimd.c                         |  29 +-
>  arch/arm64/kernel/hw_breakpoint.c                  |  11 +-
>  arch/arm64/kernel/module.c                         |   4 +
>  arch/arm64/kernel/perf_callchain.c                 |   7 +-
>  arch/arm64/kernel/probes/kprobes.c                 |  40 +-
>  arch/arm64/kernel/process.c                        |  36 +-
>  arch/arm64/kernel/return_address.c                 |  12 +-
>  arch/arm64/kernel/smp.c                            |   2 +-
>  arch/arm64/kernel/stacktrace.c                     |  62 +-
>  arch/arm64/kernel/time.c                           |   7 +-
>  arch/arm64/kernel/traps.c                          |  13 +-
>  arch/arm64/kernel/vdso/Makefile                    |  13 +-
>  arch/arm64/kernel/vdso32/Makefile                  |  14 +-
>  arch/arm64/kvm/hyp/tlb.c                           |  14 +-
>  arch/arm64/mm/fault.c                              |  57 +-
>  arch/csky/include/uapi/asm/byteorder.h             |   2 +-
>  arch/csky/include/uapi/asm/cachectl.h              |   2 +-
>  arch/csky/include/uapi/asm/perf_regs.h             |   2 +-
>  arch/csky/include/uapi/asm/ptrace.h                |   2 +-
>  arch/csky/include/uapi/asm/sigcontext.h            |   2 +-
>  arch/csky/include/uapi/asm/unistd.h                |   2 +-
>  arch/mips/cavium-octeon/octeon-usb.c               |   1 +
>  arch/mips/kernel/cacheinfo.c                       |   2 +
>  arch/mips/kernel/i8253.c                           |   3 +-
>  arch/mips/kvm/emulate.c                            |   1 +
>  arch/mips/oprofile/op_model_mipsxx.c               |  13 +
>  arch/mips/pci/ops-bcm63xx.c                        |   1 +
>  arch/mips/vdso/vdso.h                              |   1 +
>  arch/nds32/include/uapi/asm/auxvec.h               |   2 +-
>  arch/nds32/include/uapi/asm/byteorder.h            |   2 +-
>  arch/nds32/include/uapi/asm/cachectl.h             |   2 +-
>  arch/nds32/include/uapi/asm/fp_udfiex_crtl.h       |   2 +-
>  arch/nds32/include/uapi/asm/param.h                |   2 +-
>  arch/nds32/include/uapi/asm/ptrace.h               |   2 +-
>  arch/nds32/include/uapi/asm/sigcontext.h           |   2 +-
>  arch/nds32/include/uapi/asm/unistd.h               |   2 +-
>  arch/parisc/Makefile                               |   5 +-
>  arch/parisc/boot/compressed/Makefile               |   4 +-
>  arch/parisc/boot/compressed/vmlinux.lds.S          |   4 +-
>  .../configs/{default_defconfig => defconfig}       |   0
>  arch/parisc/include/asm/kprobes.h                  |   4 +
>  arch/parisc/kernel/ftrace.c                        |   3 +-
>  arch/parisc/kernel/pacache.S                       |   3 +-
>  arch/parisc/math-emu/Makefile                      |   1 +
>  arch/parisc/mm/fault.c                             |   1 +
>  arch/powerpc/Kconfig                               |   1 +
>  arch/powerpc/include/asm/cache.h                   |   8 +-
>  arch/powerpc/include/asm/hvcall.h                  |  11 +-
>  arch/powerpc/include/asm/kvm_host.h                |  22 +-
>  arch/powerpc/include/asm/kvm_ppc.h                 |   1 +
>  arch/powerpc/include/asm/pmc.h                     |   5 +-
>  arch/powerpc/include/asm/unistd.h                  |   1 +
>  arch/powerpc/include/asm/xive.h                    |   9 +
>  arch/powerpc/include/uapi/asm/bpf_perf_event.h     |   2 +-
>  arch/powerpc/kernel/Makefile                       |   3 +-
>  arch/powerpc/kernel/align.c                        |   4 +
>  arch/powerpc/kernel/dma-common.c                   |  17 +
>  arch/powerpc/kernel/entry_32.S                     |   8 +
>  arch/powerpc/kernel/entry_64.S                     |   5 +
>  arch/powerpc/kernel/exceptions-64s.S               |   2 +-
>  arch/powerpc/kernel/signal_32.c                    |   3 +
>  arch/powerpc/kernel/signal_64.c                    |   5 +
>  arch/powerpc/kernel/syscalls/syscall.tbl           |   2 +-
>  arch/powerpc/kvm/book3s.c                          |   8 +-
>  arch/powerpc/kvm/book3s_32_mmu.c                   |   1 +
>  arch/powerpc/kvm/book3s_hv.c                       |  37 +-
>  arch/powerpc/kvm/book3s_hv_rm_mmu.c                |   2 +-
>  arch/powerpc/kvm/book3s_hv_rmhandlers.S            |  38 +-
>  arch/powerpc/kvm/book3s_xive.c                     |  64 +-
>  arch/powerpc/kvm/book3s_xive.h                     |   2 +
>  arch/powerpc/kvm/book3s_xive_native.c              |  27 +-
>  arch/powerpc/kvm/e500.c                            |   3 +
>  arch/powerpc/kvm/emulate.c                         |   1 +
>  arch/powerpc/kvm/emulate_loadstore.c               |   6 -
>  arch/powerpc/kvm/powerpc.c                         |   3 +-
>  arch/powerpc/mm/book3s64/hash_utils.c              |   9 +
>  arch/powerpc/mm/kasan/kasan_init_32.c              |   7 +-
>  arch/powerpc/mm/mem.c                              |   2 +-
>  arch/powerpc/platforms/pseries/papr_scm.c          |  73 +-
>  arch/powerpc/sysdev/xive/common.c                  |  94 ++-
>  arch/powerpc/sysdev/xive/native.c                  |   7 +
>  arch/riscv/boot/dts/sifive/fu540-c000.dtsi         |  16 +-
>  .../riscv/boot/dts/sifive/hifive-unleashed-a00.dts |   9 +
>  arch/riscv/configs/defconfig                       |  10 +-
>  arch/riscv/include/asm/Kbuild                      |   1 +
>  arch/riscv/include/uapi/asm/auxvec.h               |   2 +-
>  arch/riscv/include/uapi/asm/bitsperlong.h          |   2 +-
>  arch/riscv/include/uapi/asm/byteorder.h            |   2 +-
>  arch/riscv/include/uapi/asm/hwcap.h                |   2 +-
>  arch/riscv/include/uapi/asm/ptrace.h               |   2 +-
>  arch/riscv/include/uapi/asm/sigcontext.h           |   2 +-
>  arch/riscv/include/uapi/asm/ucontext.h             |   2 +-
>  arch/riscv/include/uapi/asm/unistd.h               |   1 +
>  arch/riscv/kernel/vdso/Makefile                    |   2 +-
>  arch/riscv/lib/Makefile                            |   2 -
>  arch/riscv/lib/delay.c                             |   6 +-
>  arch/riscv/lib/udivdi3.S                           |  32 -
>  arch/s390/boot/Makefile                            |   2 +-
>  arch/s390/boot/boot.h                              |   2 +
>  arch/s390/boot/head.S                              |   1 +
>  arch/s390/boot/ipl_parm.c                          |   2 -
>  arch/s390/boot/kaslr.c                             |   1 +
>  arch/s390/boot/version.c                           |   7 +
>  arch/s390/configs/debug_defconfig                  | 330 ++++++----
>  arch/s390/configs/defconfig                        | 233 ++++---
>  arch/s390/configs/zfcpdump_defconfig               |  31 +-
>  arch/s390/hypfs/hypfs_vm.c                         |   4 +-
>  arch/s390/include/asm/bitops.h                     |  73 +-
>  arch/s390/include/asm/page.h                       |   2 +
>  arch/s390/include/asm/qdio.h                       |  10 +-
>  arch/s390/include/asm/setup.h                      |   5 +-
>  arch/s390/include/asm/unistd.h                     |   1 +
>  arch/s390/include/uapi/asm/bpf_perf_event.h        |   2 +-
>  arch/s390/include/uapi/asm/ipl.h                   |   2 +-
>  arch/s390/include/uapi/asm/kvm.h                   |   6 +
>  arch/s390/include/uapi/asm/zcrypt.h                |  35 +-
>  arch/s390/kernel/dumpstack.c                       |   6 +-
>  arch/s390/kernel/head64.S                          |   7 -
>  arch/s390/kernel/ipl.c                             |   9 -
>  arch/s390/kernel/machine_kexec_reloc.c             |   1 +
>  arch/s390/kernel/perf_cpum_cf_diag.c               |   2 +-
>  arch/s390/kernel/setup.c                           |   3 +-
>  arch/s390/kernel/syscalls/syscall.tbl              |   2 +-
>  arch/s390/kernel/vdso.c                            |   5 -
>  arch/s390/kernel/vmlinux.lds.S                     |  10 +-
>  arch/s390/kvm/kvm-s390.c                           |   6 +-
>  arch/s390/lib/xor.c                                |   1 +
>  arch/s390/mm/dump_pagetables.c                     |  12 +-
>  arch/s390/mm/fault.c                               |   3 +
>  arch/s390/mm/gmap.c                                |   4 +-
>  arch/s390/mm/pgalloc.c                             |   6 +-
>  arch/s390/scripts/Makefile.chkbss                  |   3 +-
>  arch/sh/include/uapi/asm/setup.h                   |   2 +-
>  arch/sh/include/uapi/asm/types.h                   |   2 +-
>  arch/sparc/include/uapi/asm/oradax.h               |   2 +-
>  arch/x86/boot/string.c                             |   8 +
>  arch/x86/entry/calling.h                           |  17 +
>  arch/x86/entry/entry_32.S                          |  13 +-
>  arch/x86/entry/entry_64.S                          |  21 +-
>  arch/x86/events/intel/core.c                       |   9 +-
>  arch/x86/events/intel/ds.c                         |   2 +-
>  arch/x86/include/asm/cpufeatures.h                 |   3 +
>  arch/x86/include/asm/kvm_emulate.h                 |   3 +-
>  arch/x86/include/asm/kvm_host.h                    |  19 +-
>  arch/x86/include/asm/vdso/gettimeofday.h           |  36 +
>  arch/x86/include/asm/vmx.h                         |  14 +
>  arch/x86/include/uapi/asm/byteorder.h              |   2 +-
>  arch/x86/include/uapi/asm/hwcap2.h                 |   2 +-
>  arch/x86/include/uapi/asm/sigcontext32.h           |   2 +-
>  arch/x86/include/uapi/asm/types.h                  |   2 +-
>  arch/x86/include/uapi/asm/vmx.h                    |   2 +
>  arch/x86/kernel/cpu/bugs.c                         | 107 ++-
>  arch/x86/kernel/cpu/common.c                       |  44 +-
>  arch/x86/kernel/cpu/mtrr/cyrix.c                   |   1 +
>  arch/x86/kernel/head_64.S                          |   8 +-
>  arch/x86/kernel/hpet.c                             |  12 +-
>  arch/x86/kernel/kvm.c                              |  12 -
>  arch/x86/kernel/ptrace.c                           |   1 +
>  arch/x86/kernel/stacktrace.c                       |   2 +-
>  arch/x86/kernel/sysfb_efi.c                        |  46 ++
>  arch/x86/kvm/cpuid.c                               |  27 +-
>  arch/x86/kvm/emulate.c                             |  27 +-
>  arch/x86/kvm/lapic.c                               |  20 +-
>  arch/x86/kvm/mmu.c                                 |  61 +-
>  arch/x86/kvm/mmu.h                                 |   2 +-
>  arch/x86/kvm/svm.c                                 | 198 +++---
>  arch/x86/kvm/trace.h                               |  74 ++-
>  arch/x86/kvm/vmx/nested.c                          | 305 +++++----
>  arch/x86/kvm/vmx/vmenter.S                         |   4 +-
>  arch/x86/kvm/vmx/vmx.c                             |  94 +--
>  arch/x86/kvm/vmx/vmx.h                             |   2 +-
>  arch/x86/kvm/x86.c                                 | 197 ++++--
>  arch/x86/kvm/x86.h                                 |   2 +-
>  arch/x86/lib/cpu.c                                 |   1 +
>  arch/x86/mm/fault.c                                |  15 +-
>  arch/x86/purgatory/Makefile                        |  36 +-
>  arch/x86/purgatory/purgatory.c                     |   6 +
>  arch/x86/purgatory/string.c                        |  23 -
>  arch/xtensa/kernel/coprocessor.S                   |   1 +
>  block/bfq-iosched.c                                | 135 ++--
>  block/blk-cgroup.c                                 |   9 +-
>  block/blk-iolatency.c                              |   3 +
>  block/blk-mq-sched.h                               |   9 -
>  block/blk-mq.c                                     |  10 +-
>  block/blk-rq-qos.c                                 |   7 +-
>  block/blk-settings.c                               |   3 +-
>  block/genhd.c                                      |   2 +-
>  drivers/acpi/arm64/iort.c                          |   4 +-
>  drivers/acpi/device_pm.c                           |   4 +-
>  drivers/acpi/nfit/core.c                           |  28 +-
>  drivers/acpi/nfit/nfit.h                           |  24 +
>  drivers/acpi/scan.c                                |   6 +
>  drivers/android/binder.c                           |   5 +-
>  drivers/ata/libahci_platform.c                     |   4 +-
>  drivers/ata/libata-scsi.c                          |  21 +
>  drivers/ata/libata-sff.c                           |   6 +
>  drivers/ata/libata-zpodd.c                         |   2 +-
>  drivers/ata/pata_rb532_cf.c                        |   1 -
>  drivers/atm/iphase.c                               |   8 +-
>  drivers/base/core.c                                |  83 ++-
>  drivers/base/firmware_loader/firmware.h            |   4 +-
>  drivers/base/platform.c                            |   9 +-
>  drivers/block/aoe/aoedev.c                         |  13 +-
>  drivers/block/ataflop.c                            |   1 +
>  drivers/block/drbd/drbd_receiver.c                 |  14 +-
>  drivers/block/loop.c                               |  18 +-
>  drivers/block/nbd.c                                |   2 +-
>  drivers/bluetooth/hci_ath.c                        |   3 +
>  drivers/bluetooth/hci_bcm.c                        |   3 +
>  drivers/bluetooth/hci_intel.c                      |   3 +
>  drivers/bluetooth/hci_ldisc.c                      |  13 +
>  drivers/bluetooth/hci_mrvl.c                       |   3 +
>  drivers/bluetooth/hci_qca.c                        |   3 +
>  drivers/bluetooth/hci_uart.h                       |   1 +
>  drivers/char/hpet.c                                |   3 +-
>  drivers/char/ipmi/ipmb_dev_int.c                   |   2 +-
>  drivers/char/tpm/tpm-chip.c                        |  43 +-
>  drivers/char/tpm/tpm.h                             |   2 +
>  drivers/char/tpm/tpm1-cmd.c                        |  36 +-
>  drivers/char/tpm/tpm2-cmd.c                        |   6 +-
>  drivers/clk/at91/clk-generated.c                   |   2 +
>  drivers/clk/mediatek/clk-mt8183.c                  |  46 +-
>  drivers/clk/renesas/renesas-cpg-mssr.c             |  16 +-
>  drivers/clk/sprd/Kconfig                           |   1 +
>  drivers/clocksource/timer-riscv.c                  |   6 +-
>  drivers/connector/connector.c                      |   6 +-
>  drivers/cpufreq/pasemi-cpufreq.c                   |  23 +-
>  drivers/crypto/ccp/ccp-crypto-aes-galois.c         |  14 +
>  drivers/crypto/ccp/ccp-ops.c                       |  33 +-
>  drivers/crypto/ux500/cryp/cryp.c                   |   6 +
>  drivers/firewire/core-device.c                     |   2 +-
>  drivers/firewire/core-iso.c                        |   2 +-
>  drivers/firewire/core-topology.c                   |   1 +
>  drivers/firmware/Kconfig                           |   5 +-
>  drivers/firmware/iscsi_ibft.c                      |   4 +
>  drivers/fpga/Kconfig                               |   1 +
>  drivers/gpio/gpiolib.c                             |  23 +-
>  drivers/gpu/drm/Kconfig                            |   2 +-
>  drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c   |   3 +-
>  drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c             |  26 +-
>  drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c        |   2 +-
>  drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |   2 +-
>  drivers/gpu/drm/amd/amdgpu/amdgpu_gds.h            |   1 -
>  drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c             |  78 ++-
>  drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c            |  19 +-
>  drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h            |   1 +
>  drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c             |  22 +-
>  drivers/gpu/drm/amd/amdgpu/gfx_v7_0.c              |   9 +
>  drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c              |  49 ++
>  drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c              |   9 +
>  drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c              |  47 +-
>  drivers/gpu/drm/amd/amdkfd/kfd_chardev.c           |  28 -
>  drivers/gpu/drm/amd/amdkfd/kfd_crat.c              |   1 +
>  drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v10.c   |   1 -
>  .../amd/display/dc/clk_mgr/dce110/dce110_clk_mgr.c |   4 +-
>  .../amd/display/dc/clk_mgr/dce112/dce112_clk_mgr.c |   4 +-
>  .../amd/display/dc/clk_mgr/dce120/dce120_clk_mgr.c |   4 +-
>  .../amd/display/dc/clk_mgr/dcn20/dcn20_clk_mgr.c   |   3 +
>  drivers/gpu/drm/amd/display/dc/core/dc.c           |   6 +-
>  drivers/gpu/drm/amd/display/dc/core/dc_link.c      |  30 +-
>  drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c   |  39 +-
>  drivers/gpu/drm/amd/display/dc/core/dc_resource.c  |  11 +-
>  drivers/gpu/drm/amd/display/dc/core/dc_stream.c    |   3 +-
>  drivers/gpu/drm/amd/display/dc/dce/dce_abm.c       |   4 +
>  .../amd/display/dc/dce110/dce110_hw_sequencer.c    |  24 +-
>  .../drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c  |  21 +-
>  .../gpu/drm/amd/display/dc/dcn10/dcn10_resource.c  |   2 +-
>  drivers/gpu/drm/amd/display/dc/dcn20/dcn20_dccg.c  |   5 +
>  .../gpu/drm/amd/display/dc/dcn20/dcn20_hubbub.c    |  18 +-
>  drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c |  22 +-
>  drivers/gpu/drm/amd/display/dc/dcn20/dcn20_optc.c  |   2 +-
>  .../gpu/drm/amd/display/dc/dcn20/dcn20_resource.c  |   4 +
>  drivers/gpu/drm/amd/display/dc/dcn20/dcn20_vmid.c  |  37 ++
>  drivers/gpu/drm/amd/display/dc/dsc/drm_dsc_dc.c    |   6 +
>  drivers/gpu/drm/amd/display/dc/inc/core_types.h    |   2 +-
>  drivers/gpu/drm/amd/display/dc/inc/hw/dchubbub.h   |   4 +-
>  drivers/gpu/drm/amd/display/dc/inc/hw/hw_shared.h  |   1 +
>  drivers/gpu/drm/amd/display/include/dpcd_defs.h    |   2 +-
>  drivers/gpu/drm/amd/include/kgd_pp_interface.h     |   1 +
>  drivers/gpu/drm/amd/powerplay/amdgpu_smu.c         | 125 ++--
>  drivers/gpu/drm/amd/powerplay/hwmgr/smu10_hwmgr.c  |   9 +
>  drivers/gpu/drm/amd/powerplay/inc/amdgpu_smu.h     |  12 +-
>  drivers/gpu/drm/amd/powerplay/navi10_ppt.c         | 211 ++++--
>  drivers/gpu/drm/amd/powerplay/navi10_ppt.h         |   4 +
>  drivers/gpu/drm/amd/powerplay/smu_v11_0.c          |  56 +-
>  drivers/gpu/drm/amd/powerplay/vega20_ppt.c         |  54 +-
>  drivers/gpu/drm/bochs/bochs_kms.c                  |   1 +
>  drivers/gpu/drm/bridge/Kconfig                     |   4 +-
>  drivers/gpu/drm/drm_client.c                       |  60 +-
>  drivers/gpu/drm/drm_client_modeset.c               |   2 +-
>  drivers/gpu/drm/drm_fb_helper.c                    |  51 +-
>  drivers/gpu/drm/drm_framebuffer.c                  |   2 +-
>  drivers/gpu/drm/drm_modes.c                        |   6 +-
>  drivers/gpu/drm/exynos/Kconfig                     |   1 +
>  drivers/gpu/drm/exynos/exynos_drm_fimc.c           |   2 +-
>  drivers/gpu/drm/exynos/exynos_drm_g2d.c            |   2 +-
>  drivers/gpu/drm/exynos/exynos_drm_gsc.c            |   2 +-
>  drivers/gpu/drm/exynos/exynos_drm_scaler.c         |   4 +-
>  drivers/gpu/drm/i915/Makefile                      |   1 -
>  drivers/gpu/drm/i915/display/intel_bios.c          |   2 +-
>  drivers/gpu/drm/i915/display/intel_bw.c            |  15 +-
>  drivers/gpu/drm/i915/display/intel_cdclk.c         |  11 +
>  drivers/gpu/drm/i915/display/intel_display.c       |   6 +-
>  drivers/gpu/drm/i915/display/intel_display_power.c |  11 +-
>  drivers/gpu/drm/i915/display/intel_dp.c            |   1 +
>  drivers/gpu/drm/i915/display/intel_hdcp.c          |   3 +-
>  drivers/gpu/drm/i915/display/intel_vbt_defs.h      |   6 +-
>  drivers/gpu/drm/i915/display/vlv_dsi_pll.c         |   4 +-
>  drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c     |  20 +-
>  drivers/gpu/drm/i915/gem/i915_gem_mman.c           |   2 +-
>  drivers/gpu/drm/i915/gem/i915_gem_pages.c          |   2 +-
>  drivers/gpu/drm/i915/gem/i915_gem_pm.c             |   7 +-
>  drivers/gpu/drm/i915/gem/i915_gem_userptr.c        |  10 +-
>  drivers/gpu/drm/i915/gt/intel_context.c            |  27 +-
>  drivers/gpu/drm/i915/gt/intel_engine_cs.c          |  20 +-
>  drivers/gpu/drm/i915/gt/intel_engine_pm.c          |  24 -
>  drivers/gpu/drm/i915/gt/intel_engine_pm.h          |  12 +-
>  drivers/gpu/drm/i915/gt/intel_engine_types.h       |  12 +
>  drivers/gpu/drm/i915/gt/intel_gt_pm.c              |  21 +-
>  drivers/gpu/drm/i915/gt/intel_gt_pm.h              |   2 +-
>  drivers/gpu/drm/i915/gt/intel_lrc.c                |  10 +-
>  drivers/gpu/drm/i915/gt/intel_reset.c              |  58 +-
>  drivers/gpu/drm/i915/gt/intel_ringbuffer.c         |  31 +-
>  drivers/gpu/drm/i915/gt/intel_workarounds.c        |  38 +-
>  drivers/gpu/drm/i915/gt/mock_engine.c              |   1 +
>  drivers/gpu/drm/i915/gt/selftest_reset.c           |   5 +-
>  drivers/gpu/drm/i915/gt/selftest_workarounds.c     |   7 +-
>  drivers/gpu/drm/i915/gvt/cmd_parser.c              |  10 -
>  drivers/gpu/drm/i915/gvt/fb_decoder.c              |   6 +-
>  drivers/gpu/drm/i915/gvt/gtt.c                     |   9 +
>  drivers/gpu/drm/i915/gvt/kvmgt.c                   |  12 +
>  drivers/gpu/drm/i915/gvt/scheduler.c               |  59 +-
>  drivers/gpu/drm/i915/gvt/trace_points.c            |   2 -
>  drivers/gpu/drm/i915/i915_drv.h                    |   5 +-
>  drivers/gpu/drm/i915/i915_gem.c                    |  25 +-
>  drivers/gpu/drm/i915/i915_gem_gtt.c                |   8 +-
>  drivers/gpu/drm/i915/i915_gpu_error.c              |   7 +-
>  drivers/gpu/drm/i915/i915_perf.c                   |  67 +-
>  drivers/gpu/drm/i915/i915_trace.h                  |  76 +--
>  drivers/gpu/drm/i915/intel_runtime_pm.c            |  10 +-
>  drivers/gpu/drm/i915/intel_wakeref.h               |  15 +
>  drivers/gpu/drm/msm/adreno/a5xx_gpu.c              |   2 +
>  drivers/gpu/drm/msm/adreno/a6xx_gpu.c              |   1 +
>  drivers/gpu/drm/msm/adreno/adreno_gpu.c            |   1 +
>  drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c        |   3 +-
>  drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c          |  16 +-
>  drivers/gpu/drm/msm/disp/mdp5/mdp5_kms.c           |   2 +-
>  drivers/gpu/drm/msm/msm_drv.c                      |   5 +-
>  drivers/gpu/drm/msm/msm_gem.c                      |  47 +-
>  drivers/gpu/drm/nouveau/dispnv50/disp.c            |   2 +-
>  drivers/gpu/drm/nouveau/nouveau_svm.c              |  47 +-
>  drivers/gpu/drm/rockchip/analogix_dp-rockchip.c    |   2 +-
>  drivers/gpu/drm/tegra/output.c                     |   8 +-
>  drivers/gpu/drm/ttm/ttm_page_alloc_dma.c           |   6 +-
>  drivers/gpu/drm/vmwgfx/vmwgfx_msg.c                |   4 +-
>  drivers/hid/hid-a4tech.c                           |  30 +-
>  drivers/hid/hid-holtek-kbd.c                       |   9 +-
>  drivers/hid/hid-ids.h                              |   5 +-
>  drivers/hid/hid-logitech-dj.c                      |  10 +-
>  drivers/hid/hid-logitech-hidpp.c                   |  32 +-
>  drivers/hid/hid-quirks.c                           |   2 +
>  drivers/hid/hid-sony.c                             |  15 +-
>  drivers/hid/hid-tmff.c                             |  12 +
>  drivers/hid/usbhid/hiddev.c                        |  12 +
>  drivers/hid/wacom_wac.c                            |  12 +-
>  drivers/hwmon/lm75.c                               |   2 +-
>  drivers/hwmon/nct6775.c                            |   3 +-
>  drivers/hwmon/nct7802.c                            |   6 +-
>  drivers/hwmon/occ/common.c                         |   6 +-
>  drivers/hwtracing/coresight/coresight-etm-perf.c   |   1 +
>  drivers/i2c/busses/i2c-at91-core.c                 |   2 +-
>  drivers/i2c/busses/i2c-at91-master.c               |   9 +-
>  drivers/i2c/busses/i2c-bcm-iproc.c                 |  10 +-
>  drivers/i2c/busses/i2c-nvidia-gpu.c                |   2 +-
>  drivers/i2c/busses/i2c-s3c2410.c                   |   1 +
>  drivers/iio/accel/cros_ec_accel_legacy.c           |   1 -
>  drivers/iio/adc/ingenic-adc.c                      |  54 ++
>  drivers/iio/adc/max9611.c                          |   2 +-
>  drivers/iio/adc/rcar-gyroadc.c                     |   4 +-
>  drivers/iio/imu/inv_mpu6050/inv_mpu_core.c         |  43 ++
>  drivers/infiniband/core/core_priv.h                |   5 +-
>  drivers/infiniband/core/counters.c                 |  11 +-
>  drivers/infiniband/core/device.c                   | 102 ++-
>  drivers/infiniband/core/mad.c                      |  20 +-
>  drivers/infiniband/core/user_mad.c                 |   6 +-
>  drivers/infiniband/hw/bnxt_re/ib_verbs.c           |   7 +-
>  drivers/infiniband/hw/bnxt_re/qplib_res.c          |  13 +-
>  drivers/infiniband/hw/bnxt_re/qplib_res.h          |   2 +-
>  drivers/infiniband/hw/bnxt_re/qplib_sp.c           |  14 +-
>  drivers/infiniband/hw/bnxt_re/qplib_sp.h           |   7 +-
>  drivers/infiniband/hw/hfi1/chip.c                  |  11 +-
>  drivers/infiniband/hw/hfi1/rc.c                    |   2 -
>  drivers/infiniband/hw/hfi1/tid_rdma.c              |  43 +-
>  drivers/infiniband/hw/hfi1/verbs.c                 |   2 +
>  drivers/infiniband/hw/hns/Kconfig                  |   6 +-
>  drivers/infiniband/hw/hns/Makefile                 |   8 +-
>  drivers/infiniband/hw/hns/hns_roce_db.c            |  15 +-
>  drivers/infiniband/hw/hns/hns_roce_hw_v1.c         |   4 +-
>  drivers/infiniband/hw/mlx5/main.c                  |   7 +-
>  drivers/infiniband/hw/mlx5/mlx5_ib.h               |   1 +
>  drivers/infiniband/hw/mlx5/mr.c                    |  50 +-
>  drivers/infiniband/hw/mlx5/odp.c                   |   7 +-
>  drivers/infiniband/hw/mlx5/qp.c                    |  13 +-
>  drivers/infiniband/hw/qedr/main.c                  |  10 +-
>  drivers/infiniband/sw/siw/siw_cm.c                 |   3 +-
>  drivers/infiniband/sw/siw/siw_main.c               |   1 +
>  drivers/infiniband/sw/siw/siw_qp.c                 |   6 +-
>  drivers/input/joystick/iforce/iforce-usb.c         |   5 +
>  drivers/input/keyboard/Kconfig                     |   2 +
>  drivers/input/keyboard/applespi.c                  |  29 +-
>  drivers/input/mouse/elantech.c                     |  55 +-
>  drivers/input/mouse/synaptics.c                    |   1 +
>  drivers/input/tablet/kbtab.c                       |   6 +-
>  drivers/input/touchscreen/usbtouchscreen.c         |   2 +
>  drivers/iommu/amd_iommu_init.c                     |  90 +++
>  drivers/iommu/amd_iommu_types.h                    |   9 +
>  drivers/iommu/intel-iommu-debugfs.c                |   4 +-
>  drivers/iommu/intel-iommu.c                        | 189 +++---
>  drivers/iommu/iova.c                               |  23 +-
>  drivers/iommu/virtio-iommu.c                       |  40 +-
>  drivers/irqchip/irq-gic-v3-its.c                   |   2 +-
>  drivers/irqchip/irq-gic-v3.c                       |   4 +
>  drivers/irqchip/irq-imx-gpcv2.c                    |   1 +
>  drivers/irqchip/irq-mbigen.c                       |   9 +-
>  drivers/isdn/hardware/mISDN/hfcsusb.c              |  13 +-
>  drivers/macintosh/smu.c                            |   1 +
>  drivers/md/bcache/super.c                          |   3 +
>  drivers/md/bcache/sysfs.c                          |  20 +-
>  drivers/md/dm-table.c                              |  16 +-
>  drivers/media/platform/vivid/vivid-core.c          |   8 +-
>  drivers/media/v4l2-core/v4l2-subdev.c              |   2 +-
>  drivers/mfd/db8500-prcmu.c                         |   2 +
>  drivers/mfd/omap-usb-host.c                        |   4 +-
>  drivers/misc/eeprom/Kconfig                        |   3 +
>  drivers/misc/eeprom/at24.c                         |   2 +-
>  drivers/misc/habanalabs/command_submission.c       |   2 +-
>  drivers/misc/habanalabs/firmware_if.c              |  22 +-
>  drivers/misc/habanalabs/goya/goya.c                |  11 +-
>  drivers/misc/habanalabs/habanalabs.h               |  16 +-
>  drivers/misc/mei/hw-me-regs.h                      |   3 +
>  drivers/misc/mei/pci-me.c                          |   3 +
>  drivers/mmc/core/queue.c                           |   5 +
>  drivers/mmc/host/cavium.c                          |   4 +-
>  drivers/mmc/host/dw_mmc.c                          |   3 +-
>  drivers/mmc/host/meson-mx-sdio.c                   |   2 +-
>  drivers/mmc/host/sdhci-acpi.c                      |   2 +-
>  drivers/mmc/host/sdhci-esdhc-imx.c                 |   2 +-
>  drivers/mmc/host/sdhci-of-at91.c                   |   2 +-
>  drivers/mmc/host/sdhci-pci-core.c                  |   4 +-
>  drivers/mmc/host/sdhci-pxav3.c                     |   2 +-
>  drivers/mmc/host/sdhci-s3c.c                       |   2 +-
>  drivers/mmc/host/sdhci-sprd.c                      |   3 +-
>  drivers/mmc/host/sdhci-xenon.c                     |   2 +-
>  drivers/mmc/host/sdhci.c                           |   4 +-
>  drivers/mmc/host/sdhci.h                           |   2 +-
>  drivers/mtd/hyperbus/Kconfig                       |   3 +-
>  drivers/mtd/nand/onenand/onenand_base.c            |   1 +
>  drivers/mtd/nand/raw/nand_micron.c                 |  14 +-
>  drivers/net/arcnet/arc-rimi.c                      |   3 +
>  drivers/net/arcnet/com20020-isa.c                  |   6 +
>  drivers/net/arcnet/com90io.c                       |   2 +
>  drivers/net/arcnet/com90xx.c                       |   3 +
>  drivers/net/bonding/bond_main.c                    |   9 +
>  drivers/net/can/at91_can.c                         |   6 +-
>  drivers/net/can/dev.c                              |   2 +
>  drivers/net/can/flexcan.c                          |  39 +-
>  drivers/net/can/peak_canfd/peak_pciefd_main.c      |   2 +-
>  drivers/net/can/rcar/rcar_canfd.c                  |   9 +-
>  drivers/net/can/sja1000/peak_pcmcia.c              |   2 +-
>  drivers/net/can/spi/mcp251x.c                      |  52 +-
>  drivers/net/can/usb/peak_usb/pcan_usb.c            |   2 +-
>  drivers/net/can/usb/peak_usb/pcan_usb_core.c       |  10 +-
>  drivers/net/can/usb/peak_usb/pcan_usb_fd.c         |   2 +-
>  drivers/net/can/usb/peak_usb/pcan_usb_pro.c        |   2 +-
>  drivers/net/dsa/mv88e6xxx/chip.c                   |  29 +-
>  drivers/net/dsa/qca8k.c                            |  10 +-
>  drivers/net/dsa/sja1105/sja1105_dynamic_config.c   |  14 +-
>  drivers/net/dsa/sja1105/sja1105_main.c             | 143 ++--
>  drivers/net/dsa/sja1105/sja1105_ptp.c              |   7 +-
>  drivers/net/ethernet/8390/Kconfig                  |   4 +-
>  drivers/net/ethernet/agere/et131x.c                |   2 +-
>  drivers/net/ethernet/allwinner/sun4i-emac.c        |   4 +-
>  drivers/net/ethernet/amd/Kconfig                   |   2 +-
>  drivers/net/ethernet/apple/Kconfig                 |   4 +-
>  drivers/net/ethernet/atheros/ag71xx.c              |   2 +-
>  drivers/net/ethernet/broadcom/Kconfig              |   6 +-
>  drivers/net/ethernet/broadcom/bcmsysport.c         |   2 +-
>  drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c    |   6 +-
>  drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   2 +-
>  drivers/net/ethernet/broadcom/genet/bcmgenet.c     |   2 +-
>  drivers/net/ethernet/cavium/thunder/thunder_bgx.c  |  18 +-
>  drivers/net/ethernet/chelsio/cxgb/my3126.c         |   4 +-
>  drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c    |   5 +-
>  drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |   6 +-
>  .../net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c   |   3 +-
>  drivers/net/ethernet/chelsio/cxgb4/t4_hw.c         |   9 +-
>  drivers/net/ethernet/emulex/benet/be_cmds.c        |   6 +-
>  drivers/net/ethernet/emulex/benet/be_main.c        |   7 +-
>  drivers/net/ethernet/freescale/enetc/Kconfig       |   2 +
>  drivers/net/ethernet/freescale/fman/fman.c         |   3 -
>  drivers/net/ethernet/google/gve/gve.h              |   8 +-
>  drivers/net/ethernet/google/gve/gve_ethtool.c      |   4 +-
>  drivers/net/ethernet/google/gve/gve_rx.c           |  34 +-
>  drivers/net/ethernet/hisilicon/hip04_eth.c         |  28 +-
>  drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h    |   2 +-
>  .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |   2 +-
>  .../ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c   |   4 +-
>  drivers/net/ethernet/ibm/ehea/ehea_main.c          |   2 +-
>  drivers/net/ethernet/intel/igc/igc_main.c          |  12 +-
>  drivers/net/ethernet/marvell/mvmdio.c              |  31 +-
>  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |  87 ++-
>  drivers/net/ethernet/marvell/sky2.c                |   7 +
>  drivers/net/ethernet/mediatek/Kconfig              |   1 -
>  drivers/net/ethernet/mellanox/mlx5/core/dev.c      |   2 +-
>  drivers/net/ethernet/mellanox/mlx5/core/en.h       |  12 +-
>  .../net/ethernet/mellanox/mlx5/core/en/params.h    |   5 +-
>  drivers/net/ethernet/mellanox/mlx5/core/en/port.c  |  27 +-
>  drivers/net/ethernet/mellanox/mlx5/core/en/port.h  |   6 +-
>  .../ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c |   2 +-
>  .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  69 +-
>  .../ethernet/mellanox/mlx5/core/en_fs_ethtool.c    |   3 +-
>  drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  41 +-
>  drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |   7 +-
>  drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |   8 +-
>  drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |   4 +-
>  drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c  |   4 +-
>  drivers/net/ethernet/mellanox/mlx5/core/fs_core.h  |   5 +-
>  .../net/ethernet/mellanox/mlx5/core/fs_counters.c  |   5 +
>  .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |   7 +-
>  .../ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c |   1 +
>  drivers/net/ethernet/mellanox/mlxsw/spectrum.c     |  17 +-
>  drivers/net/ethernet/mellanox/mlxsw/spectrum.h     |   4 +
>  .../net/ethernet/mellanox/mlxsw/spectrum_buffers.c |   4 +-
>  drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c |   1 +
>  drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.h |   1 +
>  .../ethernet/mellanox/mlxsw/spectrum_nve_vxlan.c   |  76 ++-
>  drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c |  17 +
>  drivers/net/ethernet/mscc/ocelot.c                 |   1 +
>  drivers/net/ethernet/mscc/ocelot_flower.c          |  11 +-
>  drivers/net/ethernet/mscc/ocelot_tc.c              |   6 +-
>  .../net/ethernet/netronome/nfp/flower/offload.c    |  11 +-
>  .../net/ethernet/netronome/nfp/nfp_net_ethtool.c   |   4 +-
>  drivers/net/ethernet/ni/Kconfig                    |   2 +-
>  drivers/net/ethernet/packetengines/Kconfig         |   6 +-
>  drivers/net/ethernet/packetengines/Makefile        |   2 +-
>  drivers/net/ethernet/qlogic/qed/qed_int.c          |   2 +-
>  drivers/net/ethernet/qlogic/qed/qed_rdma.c         |   7 +-
>  .../net/ethernet/qualcomm/rmnet/rmnet_map_data.c   |  13 +-
>  drivers/net/ethernet/realtek/r8169_main.c          |  18 +-
>  drivers/net/ethernet/rocker/rocker_main.c          |   2 +
>  drivers/net/ethernet/samsung/Kconfig               |   2 +-
>  drivers/net/ethernet/smsc/smc911x.c                |   1 +
>  drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c  |   4 +
>  drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h     |   7 +-
>  .../net/ethernet/stmicro/stmmac/dwxgmac2_core.c    |  87 ++-
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  50 +-
>  .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |   7 +
>  drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c    |   2 +-
>  drivers/net/ethernet/toshiba/spider_net.c          |   1 +
>  drivers/net/ethernet/xscale/Kconfig                |   2 +-
>  drivers/net/hamradio/baycom_epp.c                  |   3 +-
>  drivers/net/hyperv/netvsc_drv.c                    |   1 -
>  drivers/net/phy/fixed_phy.c                        |   6 +-
>  drivers/net/phy/mscc.c                             |  16 +-
>  drivers/net/phy/phy_device.c                       |   6 +
>  drivers/net/phy/phy_led_triggers.c                 |   3 +-
>  drivers/net/phy/phylink.c                          |  10 +-
>  drivers/net/phy/sfp.c                              |   2 +-
>  drivers/net/ppp/pppoe.c                            |   3 +
>  drivers/net/ppp/pppox.c                            |  13 +
>  drivers/net/ppp/pptp.c                             |   3 +
>  drivers/net/tun.c                                  |   9 +-
>  drivers/net/usb/pegasus.c                          |   2 +-
>  drivers/net/usb/qmi_wwan.c                         |   1 +
>  drivers/net/usb/r8152.c                            |  12 +-
>  drivers/net/vrf.c                                  |  58 +-
>  drivers/net/wan/sdla.c                             |   1 +
>  drivers/net/wireless/ath/wil6210/cfg80211.c        |   4 +
>  .../wireless/broadcom/brcm80211/brcmfmac/vendor.c  |   1 +
>  drivers/net/wireless/intel/iwlwifi/fw/api/rx.h     |   3 +-
>  drivers/net/wireless/intel/iwlwifi/fw/dbg.c        |  22 +-
>  drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |   4 +-
>  drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |  29 +-
>  drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  58 +-
>  drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |   8 +-
>  drivers/net/wireless/intel/iwlwifi/mvm/nvm.c       |   2 +-
>  drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   4 +-
>  drivers/net/wireless/intel/iwlwifi/mvm/rs.c        | 539 ++++++++-------
>  drivers/net/wireless/intel/iwlwifi/mvm/rs.h        |   3 +-
>  drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      | 185 ++++--
>  drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |   6 +-
>  drivers/net/wireless/intel/iwlwifi/mvm/sta.h       |  12 +-
>  drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |   3 +-
>  drivers/net/wireless/intel/iwlwifi/mvm/utils.c     |   4 +-
>  drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |   3 +
>  drivers/net/wireless/intel/iwlwifi/pcie/tx.c       |   2 +
>  drivers/net/wireless/mac80211_hwsim.c              |   8 +-
>  drivers/net/wireless/marvell/mwifiex/main.h        |   1 +
>  drivers/net/wireless/marvell/mwifiex/scan.c        |   3 +-
>  drivers/net/wireless/ti/wlcore/vendor_cmd.c        |   3 +
>  drivers/nfc/nfcmrvl/main.c                         |   4 +-
>  drivers/nfc/nfcmrvl/uart.c                         |   4 +-
>  drivers/nfc/nfcmrvl/usb.c                          |   1 +
>  drivers/nfc/st-nci/se.c                            |   2 +
>  drivers/nfc/st21nfca/se.c                          |   2 +
>  drivers/ntb/msi.c                                  |   5 -
>  drivers/nvdimm/btt_devs.c                          |  16 +-
>  drivers/nvdimm/bus.c                               | 210 ++++--
>  drivers/nvdimm/core.c                              |  10 +-
>  drivers/nvdimm/dimm_devs.c                         |   4 +-
>  drivers/nvdimm/namespace_devs.c                    |  36 +-
>  drivers/nvdimm/nd-core.h                           |  71 +-
>  drivers/nvdimm/pfn_devs.c                          |  24 +-
>  drivers/nvdimm/pmem.c                              |   4 +-
>  drivers/nvdimm/region.c                            |  24 +-
>  drivers/nvdimm/region_devs.c                       |  12 +-
>  drivers/nvme/host/core.c                           |  12 +-
>  drivers/nvme/host/multipath.c                      |   8 +-
>  drivers/nvme/host/nvme.h                           |   6 +-
>  drivers/nvme/host/pci.c                            |   6 +-
>  drivers/nvmem/nvmem-sysfs.c                        |  15 +-
>  drivers/pci/pci.c                                  |  29 +-
>  drivers/pci/pci.h                                  |   1 -
>  drivers/pci/pcie/portdrv_core.c                    |  66 --
>  drivers/pcmcia/db1xxx_ss.c                         |   4 +
>  drivers/perf/arm_pmu.c                             |   2 +-
>  drivers/pinctrl/aspeed/pinctrl-aspeed-g4.c         |   2 +-
>  drivers/pinctrl/aspeed/pinctrl-aspeed-g5.c         |  92 ++-
>  drivers/pinctrl/aspeed/pinctrl-aspeed.c            |  12 +-
>  drivers/pinctrl/aspeed/pinmux-aspeed.c             |   2 +-
>  drivers/pinctrl/aspeed/pinmux-aspeed.h             |   5 +-
>  drivers/platform/olpc/olpc-xo175-ec.c              |   6 +
>  drivers/platform/x86/intel_pmc_core.c              |   1 +
>  drivers/platform/x86/pcengines-apuv2.c             |   6 +-
>  drivers/powercap/intel_rapl_common.c               |   2 +-
>  drivers/powercap/powercap_sys.c                    |   2 +-
>  drivers/pwm/core.c                                 |   7 +-
>  drivers/regulator/axp20x-regulator.c               |  10 +-
>  drivers/regulator/lp87565-regulator.c              |   8 +-
>  drivers/regulator/of_regulator.c                   |   4 +-
>  drivers/s390/block/dasd_alias.c                    |  22 +-
>  drivers/s390/char/con3215.c                        |   1 +
>  drivers/s390/char/tape_core.c                      |   3 +
>  drivers/s390/cio/qdio_main.c                       |  24 +-
>  drivers/s390/cio/vfio_ccw_async.c                  |   2 +-
>  drivers/s390/cio/vfio_ccw_cp.c                     |  28 +-
>  drivers/s390/cio/vfio_ccw_drv.c                    |   2 +-
>  drivers/s390/crypto/ap_queue.c                     |   1 +
>  drivers/s390/crypto/zcrypt_msgtype6.c              |  17 +-
>  drivers/s390/net/ctcm_fsms.c                       |   1 +
>  drivers/s390/net/ctcm_mpc.c                        |   3 +
>  drivers/s390/net/qeth_l2_main.c                    |   2 +-
>  drivers/s390/virtio/virtio_ccw.c                   |   4 +
>  drivers/scsi/Kconfig                               |   4 +-
>  drivers/scsi/arm/fas216.c                          |   8 +
>  drivers/scsi/device_handler/scsi_dh_alua.c         |   7 +-
>  drivers/scsi/fcoe/fcoe_ctlr.c                      | 140 ++--
>  drivers/scsi/hpsa.c                                |  18 +-
>  drivers/scsi/ibmvscsi/ibmvfc.c                     |   2 +-
>  drivers/scsi/libfc/fc_rport.c                      |   5 +-
>  drivers/scsi/megaraid/megaraid_sas_base.c          |   5 +-
>  drivers/scsi/megaraid/megaraid_sas_fusion.c        |  27 +-
>  drivers/scsi/mpt3sas/mpt3sas_base.c                |  12 +-
>  drivers/scsi/qla2xxx/qla_init.c                    |   2 +-
>  drivers/scsi/scsi_lib.c                            |   6 +-
>  drivers/soc/fsl/qe/qe.c                            |   2 +-
>  drivers/spi/spi-bcm2835.c                          |   3 +-
>  drivers/spi/spi-fsl-qspi.c                         |   2 +-
>  drivers/spi/spi-gpio.c                             |   6 +
>  drivers/spi/spi-pxa2xx.c                           |  14 +-
>  drivers/staging/android/ion/ion_page_pool.c        |   3 +
>  drivers/staging/fbtft/fb_bd663474.c                |   2 +-
>  drivers/staging/fbtft/fb_ili9163.c                 |   2 +-
>  drivers/staging/fbtft/fb_ili9325.c                 |   2 +-
>  drivers/staging/fbtft/fb_s6d1121.c                 |   2 +-
>  drivers/staging/fbtft/fb_ssd1289.c                 |   2 +-
>  drivers/staging/fbtft/fb_ssd1331.c                 |   4 +-
>  drivers/staging/fbtft/fb_upd161704.c               |   2 +-
>  drivers/staging/fbtft/fbtft-bus.c                  |   2 +-
>  drivers/staging/fbtft/fbtft-core.c                 |  47 +-
>  drivers/staging/gasket/apex_driver.c               |   2 +-
>  drivers/staging/unisys/visornic/visornic_main.c    |   3 +-
>  drivers/staging/wilc1000/wilc_wfi_cfgoperations.c  |   1 +
>  drivers/target/iscsi/cxgbit/cxgbit_cm.c            |   8 +-
>  drivers/target/iscsi/cxgbit/cxgbit_main.c          |   3 +-
>  .../int340x_thermal/processor_thermal_device.c     |   4 +
>  drivers/tty/hvc/hvcs.c                             |   2 +-
>  drivers/tty/serial/Kconfig                         |  19 -
>  drivers/tty/serial/Makefile                        |   1 -
>  drivers/tty/serial/kgdboc.c                        |   4 +
>  drivers/tty/serial/netx-serial.c                   | 733 ---------------------
>  drivers/tty/tty_ldsem.c                            |   5 +-
>  drivers/tty/vt/vt.c                                |   6 +-
>  drivers/usb/core/devio.c                           |   2 -
>  drivers/usb/core/hcd.c                             | 127 +---
>  drivers/usb/core/sysfs.c                           | 121 ++++
>  drivers/usb/core/usb.h                             |   5 +
>  drivers/usb/host/ehci-pci.c                        |   4 +-
>  drivers/usb/host/hwa-hc.c                          |   2 +-
>  drivers/usb/host/ohci-pci.c                        |   2 +-
>  drivers/usb/host/pci-quirks.c                      |  45 +-
>  drivers/usb/host/pci-quirks.h                      |   2 +-
>  drivers/usb/host/xhci-pci.c                        |   2 +-
>  drivers/usb/host/xhci-rcar.c                       |   9 +-
>  drivers/usb/host/xhci.c                            |  10 +
>  drivers/usb/host/xhci.h                            |   3 +-
>  drivers/usb/misc/iowarrior.c                       |   7 +-
>  drivers/usb/misc/rio500.c                          |  43 +-
>  drivers/usb/misc/usb251xb.c                        |  15 +-
>  drivers/usb/misc/yurex.c                           |   2 +-
>  drivers/usb/storage/scsiglue.c                     |  11 +
>  drivers/usb/typec/tcpm/tcpm.c                      |  58 +-
>  drivers/usb/typec/ucsi/ucsi_ccg.c                  |   2 +-
>  drivers/vhost/vhost.h                              |   2 +-
>  drivers/video/fbdev/omap/omapfb_main.c             |   8 +
>  drivers/watchdog/ar7_wdt.c                         |   1 +
>  drivers/watchdog/pcwd.c                            |   2 +-
>  drivers/watchdog/riowd.c                           |   2 +-
>  drivers/watchdog/sb_wdog.c                         |   1 +
>  drivers/watchdog/scx200_wdt.c                      |   1 +
>  drivers/watchdog/wdt.c                             |   2 +-
>  drivers/watchdog/wdt977.c                          |   2 +-
>  drivers/xen/gntdev.c                               |   2 +-
>  drivers/xen/privcmd.c                              |  35 +-
>  drivers/xen/swiotlb-xen.c                          |  34 +-
>  drivers/xen/xen-pciback/conf_space_capability.c    |   3 +-
>  drivers/xen/xlate_mmu.c                            |  32 +
>  fs/afs/fsclient.c                                  |  51 +-
>  fs/afs/yfsclient.c                                 |  54 +-
>  fs/block_dev.c                                     | 135 +++-
>  fs/btrfs/Kconfig                                   |   1 +
>  fs/btrfs/backref.c                                 |   2 +-
>  fs/btrfs/disk-io.c                                 |   1 +
>  fs/btrfs/inode.c                                   |  24 +-
>  fs/btrfs/locking.c                                 |   9 +-
>  fs/btrfs/ordered-data.c                            |  11 +-
>  fs/btrfs/send.c                                    |  77 +--
>  fs/btrfs/transaction.c                             |  32 +-
>  fs/btrfs/transaction.h                             |   3 +
>  fs/btrfs/volumes.c                                 |  10 +-
>  fs/cifs/connect.c                                  |   1 +
>  fs/cifs/smb2ops.c                                  |  39 +-
>  fs/cifs/smb2pdu.c                                  |   7 +-
>  fs/compat_ioctl.c                                  |   3 -
>  fs/coredump.c                                      |  44 +-
>  fs/dax.c                                           |   4 +-
>  fs/exec.c                                          |   2 +-
>  fs/f2fs/file.c                                     |  63 +-
>  fs/f2fs/gc.c                                       |  70 +-
>  fs/f2fs/super.c                                    |  48 +-
>  fs/gfs2/bmap.c                                     | 179 +++--
>  fs/io_uring.c                                      |  82 ++-
>  fs/iomap/Makefile                                  |   2 +-
>  fs/namespace.c                                     |   4 +-
>  fs/nfs/delegation.c                                |  25 +-
>  fs/nfs/delegation.h                                |   2 +-
>  fs/nfs/fscache.c                                   |   7 +-
>  fs/nfs/fscache.h                                   |   2 +-
>  fs/nfs/nfs4_fs.h                                   |   3 +-
>  fs/nfs/nfs4client.c                                |   5 +-
>  fs/nfs/nfs4proc.c                                  | 109 +--
>  fs/nfs/nfs4state.c                                 |  49 +-
>  fs/nfs/pnfs.c                                      |   7 +-
>  fs/nfs/super.c                                     |   1 +
>  fs/ocfs2/xattr.c                                   |   3 -
>  fs/open.c                                          |  19 +
>  fs/super.c                                         |   5 +-
>  fs/xfs/scrub/dabtree.c                             |   6 +-
>  fs/xfs/xfs_itable.c                                |   3 +
>  include/asm-generic/futex.h                        |  21 +-
>  include/asm-generic/getorder.h                     |  50 +-
>  include/drm/drm_client.h                           |   2 +
>  include/drm/drm_mode_config.h                      |   7 +
>  include/kvm/arm_vgic.h                             |   4 +-
>  include/linux/blk-cgroup.h                         |   1 +
>  include/linux/blk_types.h                          |   5 +-
>  include/linux/ccp.h                                |   2 +
>  include/linux/clk.h                                |   1 +
>  include/linux/connector.h                          |   1 -
>  include/linux/cred.h                               |   8 +-
>  include/linux/device.h                             |   6 +
>  include/linux/dim.h                                |  56 --
>  include/linux/dma-mapping.h                        |   4 +-
>  include/linux/elevator.h                           |   1 -
>  include/linux/filter.h                             |  13 +
>  include/linux/fs.h                                 |   6 +
>  include/linux/gpio/consumer.h                      |  64 +-
>  include/linux/hmm.h                                |  54 --
>  include/linux/if_pppox.h                           |   3 +
>  include/linux/if_rmnet.h                           |   4 +-
>  include/linux/iova.h                               |   6 +
>  include/linux/mlx5/fs.h                            |   1 +
>  include/linux/mlx5/mlx5_ifc.h                      |   6 +-
>  include/linux/mod_devicetable.h                    |   1 +
>  include/linux/netfilter/nf_conntrack_h323_asn1.h   |   3 +-
>  include/linux/of.h                                 |   2 +-
>  include/linux/page-flags-layout.h                  |  18 +-
>  include/linux/page-flags.h                         |   4 +
>  include/linux/sched.h                              |  10 +-
>  include/linux/sched/numa_balancing.h               |   4 +-
>  include/linux/skmsg.h                              |   8 +-
>  include/linux/wait.h                               |  13 +
>  include/net/cfg80211.h                             |  17 +-
>  include/net/flow_offload.h                         |  30 +-
>  include/net/netfilter/nf_conntrack_expect.h        |  12 +-
>  include/net/netfilter/nf_conntrack_synproxy.h      |   1 +
>  include/net/netfilter/nf_tables.h                  |   5 +-
>  include/net/pkt_cls.h                              |   5 +-
>  include/net/sch_generic.h                          |   8 +-
>  include/net/tc_act/tc_police.h                     |   4 +-
>  include/net/tc_act/tc_sample.h                     |   2 +-
>  include/net/tcp.h                                  |   8 +
>  include/net/tls.h                                  |  13 +-
>  include/rdma/ib_verbs.h                            |   4 +-
>  include/rdma/rdmavt_qp.h                           |   9 +-
>  include/scsi/libfc.h                               |  52 +-
>  include/scsi/libfcoe.h                             |   3 +-
>  include/soc/fsl/qe/qe.h                            |   2 +-
>  include/sound/compress_driver.h                    |   5 +-
>  include/sound/simple_card_utils.h                  |   4 +
>  include/sound/sof/control.h                        |   2 +-
>  include/sound/sof/dai-intel.h                      |   2 +-
>  include/sound/sof/dai.h                            |   2 +-
>  include/sound/sof/header.h                         |   2 +-
>  include/sound/sof/info.h                           |   2 +-
>  include/sound/sof/pm.h                             |   2 +-
>  include/sound/sof/stream.h                         |   2 +-
>  include/sound/sof/topology.h                       |   2 +-
>  include/sound/sof/trace.h                          |   2 +-
>  include/sound/sof/xtensa.h                         |   2 +-
>  include/trace/events/dma_fence.h                   |   2 +-
>  include/trace/events/napi.h                        |   4 +-
>  include/trace/events/qdisc.h                       |   4 +-
>  include/trace/events/tegra_apb_dma.h               |   4 +-
>  include/uapi/linux/bpfilter.h                      |   2 +-
>  include/uapi/linux/ipmi_bmc.h                      |   2 +-
>  include/uapi/linux/isst_if.h                       |   2 +-
>  include/uapi/linux/kfd_ioctl.h                     |  20 +-
>  include/uapi/linux/kvm.h                           |   3 +
>  include/uapi/linux/netfilter/nf_synproxy.h         |   2 +-
>  include/uapi/linux/netfilter/xt_connlabel.h        |   6 +
>  include/uapi/linux/nl80211.h                       |   2 +-
>  include/uapi/linux/psp-sev.h                       |   2 +-
>  include/uapi/linux/rxrpc.h                         |   2 +-
>  include/uapi/linux/serial_core.h                   |   3 -
>  include/uapi/linux/socket.h                        |  19 +-
>  include/uapi/linux/usb/g_uvc.h                     |   2 +-
>  include/uapi/linux/vbox_vmmdev_types.h             |   2 +-
>  include/uapi/linux/vboxguest.h                     |   2 +-
>  include/uapi/linux/videodev2.h                     |   8 +-
>  include/uapi/linux/virtio_iommu.h                  |  32 +-
>  include/uapi/linux/virtio_pmem.h                   |   2 +-
>  include/uapi/linux/vmcore.h                        |   2 +-
>  include/uapi/linux/wmi.h                           |   2 +-
>  include/uapi/misc/fastrpc.h                        |   2 +-
>  include/uapi/rdma/rvt-abi.h                        |   2 +-
>  include/uapi/rdma/siw-abi.h                        |   2 +-
>  include/uapi/scsi/scsi_bsg_ufs.h                   |   2 +-
>  include/uapi/sound/skl-tplg-interface.h            |   2 +-
>  include/uapi/sound/sof/fw.h                        |  16 +-
>  include/uapi/sound/sof/header.h                    |  14 +-
>  include/xen/xen-ops.h                              |   3 +
>  kernel/Kconfig.preempt                             |   8 +-
>  kernel/Makefile                                    |   1 -
>  kernel/bpf/verifier.c                              |   4 +-
>  kernel/cred.c                                      |  21 +-
>  kernel/dma/contiguous.c                            |   8 +-
>  kernel/dma/mapping.c                               |  13 +-
>  kernel/events/core.c                               |   2 +-
>  kernel/exit.c                                      |   6 +-
>  kernel/fork.c                                      |   2 +-
>  kernel/irq/affinity.c                              |   6 +-
>  kernel/locking/lockdep.c                           |  13 +-
>  kernel/locking/lockdep_proc.c                      |   3 +-
>  kernel/locking/mutex.c                             |  11 +-
>  kernel/locking/rwsem.c                             |  28 +-
>  kernel/sched/deadline.c                            |   8 -
>  kernel/sched/fair.c                                | 144 ++--
>  kernel/sched/psi.c                                 |   4 +-
>  kernel/signal.c                                    |   3 +-
>  kernel/trace/trace_functions_graph.c               |  17 +-
>  lib/Kconfig.kasan                                  |  11 +-
>  lib/Makefile                                       |   3 +-
>  lib/dim/dim.c                                      |   4 +-
>  lib/dim/net_dim.c                                  |  56 ++
>  lib/raid6/Makefile                                 |   2 +-
>  lib/test_firmware.c                                |   5 +-
>  lib/test_meminit.c                                 |   2 +-
>  lib/vdso/gettimeofday.c                            |  79 ++-
>  mm/Makefile                                        |   1 +
>  mm/balloon_compaction.c                            |  69 +-
>  mm/compaction.c                                    |  11 +-
>  mm/hmm.c                                           |  10 +-
>  mm/kmemleak.c                                      |   2 +-
>  mm/memory_hotplug.c                                |   2 -
>  {kernel => mm}/memremap.c                          |   6 +
>  mm/migrate.c                                       |  21 +-
>  mm/slub.c                                          |   8 +-
>  mm/vmalloc.c                                       |   9 +
>  mm/vmscan.c                                        |   9 +-
>  net/bridge/br.c                                    |   5 +-
>  net/bridge/br_multicast.c                          |   3 +
>  net/bridge/br_private.h                            |   9 +-
>  net/bridge/br_vlan.c                               |  29 +-
>  net/bridge/netfilter/Kconfig                       |   6 +-
>  net/bridge/netfilter/ebtables.c                    |  32 +-
>  net/bridge/netfilter/nft_meta_bridge.c             |  10 +-
>  net/can/gw.c                                       |  48 +-
>  net/core/dev.c                                     |  17 +-
>  net/core/filter.c                                  |   6 +-
>  net/core/flow_offload.c                            |  22 +-
>  net/core/skmsg.c                                   |   4 +-
>  net/core/sock_map.c                                |  19 +-
>  net/dsa/slave.c                                    |   6 +-
>  net/dsa/tag_sja1105.c                              |  12 +-
>  net/ipv4/inet_fragment.c                           |   2 +-
>  net/ipv4/ipip.c                                    |   3 +
>  net/ipv4/netfilter/ipt_CLUSTERIP.c                 |   4 +-
>  net/ipv4/netfilter/ipt_SYNPROXY.c                  |   2 +
>  net/ipv4/netfilter/ipt_rpfilter.c                  |   1 +
>  net/ipv4/netfilter/nf_nat_h323.c                   |  12 +-
>  net/ipv4/tcp_output.c                              |  13 +-
>  net/ipv4/tcp_ulp.c                                 |  13 +
>  net/ipv6/ip6_gre.c                                 |   3 +-
>  net/ipv6/ip6_tunnel.c                              |   6 +-
>  net/ipv6/netfilter/ip6t_SYNPROXY.c                 |   2 +
>  net/ipv6/netfilter/ip6t_rpfilter.c                 |   8 +-
>  net/ipv6/route.c                                   |   2 +-
>  net/iucv/af_iucv.c                                 |  14 +-
>  net/l2tp/l2tp_ppp.c                                |   3 +
>  net/mac80211/cfg.c                                 |   8 +-
>  net/mac80211/driver-ops.c                          |  13 +-
>  net/mac80211/iface.c                               |   1 -
>  net/mac80211/mlme.c                                |  10 +
>  net/mac80211/util.c                                |   7 +-
>  net/netfilter/Kconfig                              |   6 +-
>  net/netfilter/ipset/ip_set_bitmap_ipmac.c          |   2 +-
>  net/netfilter/ipset/ip_set_core.c                  |   2 +-
>  net/netfilter/ipset/ip_set_hash_ipmac.c            |   6 +-
>  net/netfilter/ipvs/ip_vs_nfct.c                    |   2 +-
>  net/netfilter/nf_conntrack_amanda.c                |   2 +-
>  net/netfilter/nf_conntrack_broadcast.c             |   2 +-
>  net/netfilter/nf_conntrack_core.c                  |   4 +-
>  net/netfilter/nf_conntrack_expect.c                |  26 +-
>  net/netfilter/nf_conntrack_ftp.c                   |   2 +-
>  net/netfilter/nf_conntrack_h323_asn1.c             |   5 +-
>  net/netfilter/nf_conntrack_h323_main.c             |  18 +-
>  net/netfilter/nf_conntrack_irc.c                   |   2 +-
>  net/netfilter/nf_conntrack_netlink.c               |   4 +-
>  net/netfilter/nf_conntrack_pptp.c                  |   4 +-
>  net/netfilter/nf_conntrack_proto_gre.c             |   2 -
>  net/netfilter/nf_conntrack_proto_icmp.c            |   2 +-
>  net/netfilter/nf_conntrack_proto_tcp.c             |   8 +-
>  net/netfilter/nf_conntrack_sane.c                  |   2 +-
>  net/netfilter/nf_conntrack_sip.c                   |  10 +-
>  net/netfilter/nf_conntrack_tftp.c                  |   2 +-
>  net/netfilter/nf_nat_amanda.c                      |   2 +-
>  net/netfilter/nf_nat_core.c                        |   2 +-
>  net/netfilter/nf_nat_ftp.c                         |   2 +-
>  net/netfilter/nf_nat_irc.c                         |   2 +-
>  net/netfilter/nf_nat_sip.c                         |   8 +-
>  net/netfilter/nf_nat_tftp.c                        |   2 +-
>  net/netfilter/nf_synproxy_core.c                   |   8 +-
>  net/netfilter/nf_tables_api.c                      |   4 +-
>  net/netfilter/nf_tables_offload.c                  |   5 +-
>  net/netfilter/nfnetlink.c                          |   2 +-
>  net/netfilter/nft_chain_filter.c                   |   2 +-
>  net/netfilter/nft_chain_nat.c                      |   3 +
>  net/netfilter/nft_ct.c                             |   2 +-
>  net/netfilter/nft_hash.c                           |   2 +-
>  net/netfilter/nft_meta.c                           |  18 +-
>  net/netfilter/nft_redir.c                          |   2 +-
>  net/netfilter/nft_synproxy.c                       |   2 +
>  net/netrom/af_netrom.c                             |   1 +
>  net/openvswitch/datapath.c                         |  15 +-
>  net/openvswitch/flow.c                             |   8 +-
>  net/openvswitch/flow.h                             |   4 +-
>  net/openvswitch/flow_table.c                       |   8 +-
>  net/rds/rdma_transport.c                           |   5 +-
>  net/rxrpc/ar-internal.h                            |   1 +
>  net/rxrpc/peer_event.c                             |   2 +-
>  net/rxrpc/peer_object.c                            |  18 +
>  net/rxrpc/sendmsg.c                                |   1 +
>  net/sched/act_bpf.c                                |   9 +-
>  net/sched/act_connmark.c                           |   9 +-
>  net/sched/act_csum.c                               |   9 +-
>  net/sched/act_ct.c                                 |   9 +-
>  net/sched/act_ctinfo.c                             |   9 +-
>  net/sched/act_gact.c                               |   8 +-
>  net/sched/act_ife.c                                |  13 +-
>  net/sched/act_mirred.c                             |  13 +-
>  net/sched/act_mpls.c                               |   8 +-
>  net/sched/act_nat.c                                |   9 +-
>  net/sched/act_pedit.c                              |  10 +-
>  net/sched/act_police.c                             |   8 +-
>  net/sched/act_sample.c                             |  10 +-
>  net/sched/act_simple.c                             |  10 +-
>  net/sched/act_skbedit.c                            |  11 +-
>  net/sched/act_skbmod.c                             |  11 +-
>  net/sched/act_tunnel_key.c                         |   8 +-
>  net/sched/act_vlan.c                               |  25 +-
>  net/sched/cls_api.c                                |  16 +-
>  net/sched/cls_bpf.c                                |   2 +-
>  net/sched/cls_flower.c                             |   2 +-
>  net/sched/cls_matchall.c                           |   2 +-
>  net/sched/cls_u32.c                                |   6 +-
>  net/sched/sch_codel.c                              |   6 +-
>  net/sctp/socket.c                                  |   4 +-
>  net/smc/af_smc.c                                   |  15 +-
>  net/tipc/netlink_compat.c                          |  11 +-
>  net/tipc/socket.c                                  |   3 +-
>  net/tipc/topsrv.c                                  |   2 +-
>  net/tls/tls_main.c                                 |  97 +--
>  net/tls/tls_sw.c                                   |  83 ++-
>  net/vmw_vsock/hyperv_transport.c                   |   8 +
>  net/wireless/core.c                                |   6 +-
>  net/wireless/nl80211.c                             |   4 +-
>  net/wireless/util.c                                |  27 +-
>  samples/vfio-mdev/mdpy-defs.h                      |   2 +-
>  scripts/Kbuild.include                             |   3 -
>  scripts/Kconfig.include                            |   2 +-
>  scripts/Makefile.build                             |  11 +-
>  scripts/Makefile.lib                               |   2 -
>  scripts/Makefile.modpost                           |  86 +--
>  scripts/gen_compile_commands.py                    |   4 +-
>  scripts/headers_install.sh                         |   6 +
>  scripts/kconfig/confdata.c                         |   4 +
>  scripts/link-vmlinux.sh                            |   2 +-
>  scripts/sphinx-pre-install                         | 118 +++-
>  security/Kconfig.hardening                         |   7 +
>  security/selinux/ss/policydb.c                     |   6 +-
>  security/selinux/ss/sidtab.c                       |   5 +
>  sound/ac97/bus.c                                   |  13 +-
>  sound/core/compress_offload.c                      |  60 +-
>  sound/core/pcm_native.c                            |  12 +-
>  sound/firewire/packets-buffer.c                    |   2 +-
>  sound/hda/hdac_i915.c                              |  10 +-
>  sound/pci/hda/hda_codec.c                          |   2 +-
>  sound/pci/hda/hda_controller.c                     |  13 +-
>  sound/pci/hda/hda_controller.h                     |   2 +-
>  sound/pci/hda/hda_intel.c                          |  68 +-
>  sound/pci/hda/patch_conexant.c                     |   1 +
>  sound/soc/amd/raven/acp3x-pcm-dma.c                |  20 +-
>  sound/soc/codecs/cs42xx8.c                         | 116 +++-
>  sound/soc/codecs/max98357a.c                       |  25 +-
>  sound/soc/codecs/max98373.c                        |   6 +
>  sound/soc/codecs/max98373.h                        |   2 +
>  sound/soc/codecs/pcm3060-i2c.c                     |   4 +-
>  sound/soc/codecs/pcm3060-spi.c                     |   4 +-
>  sound/soc/codecs/pcm3060.c                         |   4 +-
>  sound/soc/codecs/pcm3060.h                         |   2 +-
>  sound/soc/codecs/rt1011.c                          |   4 +-
>  sound/soc/codecs/rt1308.c                          |   0
>  sound/soc/codecs/rt1308.h                          |   0
>  sound/soc/generic/audio-graph-card.c               |  30 +-
>  sound/soc/generic/simple-card-utils.c              |   7 +
>  sound/soc/generic/simple-card.c                    |  26 +-
>  sound/soc/intel/boards/bytcht_es8316.c             |   8 +
>  sound/soc/intel/common/soc-acpi-intel-bxt-match.c  |   2 +-
>  sound/soc/intel/common/soc-acpi-intel-byt-match.c  |   2 +-
>  sound/soc/intel/common/soc-acpi-intel-cht-match.c  |   2 +-
>  sound/soc/intel/common/soc-acpi-intel-cnl-match.c  |   2 +-
>  sound/soc/intel/common/soc-acpi-intel-glk-match.c  |   2 +-
>  sound/soc/intel/common/soc-acpi-intel-hda-match.c  |   2 +-
>  .../intel/common/soc-acpi-intel-hsw-bdw-match.c    |   2 +-
>  sound/soc/intel/common/soc-acpi-intel-icl-match.c  |   2 +-
>  sound/soc/intel/common/soc-acpi-intel-kbl-match.c  |   2 +-
>  sound/soc/intel/common/soc-acpi-intel-skl-match.c  |   2 +-
>  sound/soc/qcom/apq8016_sbc.c                       |  16 +-
>  sound/soc/rockchip/rockchip_i2s.c                  |   5 +-
>  sound/soc/rockchip/rockchip_max98090.c             |  32 +
>  sound/soc/samsung/odroid.c                         |   8 +-
>  sound/soc/soc-core.c                               |   7 +-
>  sound/soc/soc-dapm.c                               |  10 +-
>  sound/soc/sof/intel/cnl.c                          |   4 +-
>  sound/soc/sof/intel/hda-ipc.c                      |   4 +-
>  sound/soc/sunxi/sun4i-i2s.c                        |   4 +-
>  sound/soc/ti/davinci-mcasp.c                       |  46 +-
>  sound/sound_core.c                                 |   3 +-
>  sound/usb/helper.c                                 |   2 +-
>  sound/usb/hiface/pcm.c                             |  11 +-
>  sound/usb/line6/podhd.c                            |   2 +-
>  sound/usb/line6/variax.c                           |   2 +-
>  sound/usb/stream.c                                 |   1 +
>  tools/arch/arm/include/uapi/asm/kvm.h              |  12 +
>  tools/arch/arm64/include/uapi/asm/kvm.h            |  10 +
>  tools/arch/powerpc/include/uapi/asm/mman.h         |   4 -
>  tools/arch/sparc/include/uapi/asm/mman.h           |   4 -
>  tools/arch/x86/include/uapi/asm/kvm.h              |  22 +-
>  tools/arch/x86/include/uapi/asm/vmx.h              |   1 -
>  tools/include/uapi/asm-generic/mman-common.h       |  15 +-
>  tools/include/uapi/asm-generic/mman.h              |  10 +-
>  tools/include/uapi/asm-generic/unistd.h            |   8 +-
>  tools/include/uapi/drm/drm.h                       |   1 +
>  tools/include/uapi/drm/i915_drm.h                  | 209 +++++-
>  tools/include/uapi/linux/if_link.h                 |   5 +
>  tools/include/uapi/linux/kvm.h                     |   3 +
>  tools/include/uapi/linux/sched.h                   |  30 +-
>  tools/include/uapi/linux/usbdevice_fs.h            |  26 +
>  tools/lib/bpf/btf.c                                |   5 +-
>  tools/lib/bpf/hashmap.h                            |   5 +
>  tools/lib/bpf/libbpf.c                             |  34 +-
>  tools/lib/bpf/xsk.c                                |  11 +-
>  tools/objtool/check.c                              |   7 +-
>  tools/objtool/check.h                              |   3 +-
>  tools/perf/Documentation/Makefile                  |   2 +-
>  tools/perf/Documentation/perf-script.txt           |   8 +-
>  tools/perf/Documentation/perf.data-file-format.txt |   2 +-
>  tools/perf/arch/s390/util/machine.c                |  31 +-
>  tools/perf/arch/x86/entry/syscalls/syscall_64.tbl  |   2 +
>  tools/perf/bench/numa.c                            |   6 +-
>  tools/perf/builtin-ftrace.c                        |   2 +-
>  tools/perf/builtin-probe.c                         |  10 +
>  tools/perf/builtin-script.c                        |   2 +-
>  tools/perf/builtin-stat.c                          |   9 +-
>  tools/perf/pmu-events/jevents.c                    |   1 +
>  tools/perf/trace/beauty/usbdevfs_ioctl.sh          |   9 +-
>  tools/perf/ui/browser.c                            |   9 +-
>  tools/perf/ui/tui/progress.c                       |   2 +-
>  tools/perf/util/annotate.c                         |   2 +-
>  tools/perf/util/cpumap.c                           |   5 +-
>  tools/perf/util/evsel.c                            |   2 +
>  tools/perf/util/header.c                           |  11 +-
>  tools/perf/util/machine.c                          |   3 +-
>  tools/perf/util/machine.h                          |   2 +-
>  tools/perf/util/probe-event.c                      |   1 +
>  tools/perf/util/session.c                          |  22 +-
>  tools/perf/util/session.h                          |   1 +
>  tools/perf/util/stat-shadow.c                      |   3 +-
>  tools/perf/util/symbol.c                           |   7 +-
>  tools/perf/util/symbol.h                           |   1 +
>  tools/perf/util/thread.c                           |  12 +-
>  tools/perf/util/zstd.c                             |   4 +-
>  tools/scripts/Makefile.include                     |   9 +-
>  tools/testing/ktest/config-bisect.pl               |   4 +-
>  tools/testing/selftests/bpf/Makefile               |   3 +-
>  tools/testing/selftests/bpf/progs/sendmsg6_prog.c  |   3 +-
>  tools/testing/selftests/bpf/test_xdp_vlan.sh       |  57 +-
>  .../selftests/bpf/test_xdp_vlan_mode_generic.sh    |   9 +
>  .../selftests/bpf/test_xdp_vlan_mode_native.sh     |   9 +
>  tools/testing/selftests/bpf/verifier/ctx_skb.c     |  11 +
>  tools/testing/selftests/cgroup/cgroup_util.c       |   3 +-
>  .../selftests/drivers/net/mlxsw/qos_mc_aware.sh    |   4 +-
>  tools/testing/selftests/kmod/kmod.sh               |   6 +-
>  tools/testing/selftests/kselftest.h                |  15 +
>  tools/testing/selftests/kvm/Makefile               |  10 +-
>  tools/testing/selftests/kvm/dirty_log_test.c       |  61 +-
>  tools/testing/selftests/kvm/include/kvm_util.h     |   8 +-
>  tools/testing/selftests/kvm/lib/aarch64/ucall.c    | 112 ++++
>  tools/testing/selftests/kvm/lib/s390x/ucall.c      |  56 ++
>  tools/testing/selftests/kvm/lib/ucall.c            | 157 -----
>  tools/testing/selftests/kvm/lib/x86_64/ucall.c     |  56 ++
>  tools/testing/selftests/kvm/s390x/memop.c          | 166 +++++
>  tools/testing/selftests/kvm/s390x/sync_regs_test.c |  36 +-
>  tools/testing/selftests/livepatch/functions.sh     |  46 +-
>  tools/testing/selftests/net/.gitignore             |   4 +-
>  .../selftests/net/forwarding/gre_multipath.sh      |  28 +-
>  tools/testing/selftests/net/tls.c                  | 223 +++++++
>  tools/testing/selftests/pidfd/pidfd_test.c         |   6 +-
>  .../tc-testing/tc-tests/actions/vlan.json          |  94 +++
>  tools/testing/selftests/x86/test_vsyscall.c        |   2 +-
>  usr/include/Makefile                               |   4 -
>  virt/kvm/arm/arm.c                                 |   2 +
>  virt/kvm/arm/vgic/vgic-init.c                      |   8 +-
>  virt/kvm/arm/vgic/vgic-irqfd.c                     |  36 +-
>  virt/kvm/arm/vgic/vgic-its.c                       | 207 ++++++
>  virt/kvm/arm/vgic/vgic-mmio-v3.c                   |  85 +--
>  virt/kvm/arm/vgic/vgic-v2.c                        |   7 +-
>  virt/kvm/arm/vgic/vgic-v3.c                        |   7 +-
>  virt/kvm/arm/vgic/vgic.c                           |  26 +-
>  virt/kvm/arm/vgic/vgic.h                           |   5 +
>  virt/kvm/kvm_main.c                                |   7 +-
>  1329 files changed, 13434 insertions(+), 9949 deletions(-)
>  delete mode 100644 Documentation/admin-guide/conf.py
>  delete mode 100644 Documentation/core-api/conf.py
>  delete mode 100644 Documentation/crypto/conf.py
>  delete mode 100644 Documentation/dev-tools/conf.py
>  rename Documentation/devicetree/bindings/misc/{intel,ixp4xx-queue-manager.yaml => intel,ixp4xx-ahb-queue-manager.yaml} (95%)
>  create mode 100644 Documentation/devicetree/bindings/nvmem/nvmem-consumer.yaml
>  create mode 100644 Documentation/devicetree/bindings/nvmem/nvmem.yaml
>  delete mode 100644 Documentation/devicetree/bindings/riscv/cpus.txt
>  delete mode 100644 Documentation/doc-guide/conf.py
>  delete mode 100644 Documentation/driver-api/80211/conf.py
>  delete mode 100644 Documentation/driver-api/conf.py
>  delete mode 100644 Documentation/driver-api/pm/conf.py
>  delete mode 100644 Documentation/filesystems/conf.py
>  delete mode 100644 Documentation/gpu/conf.py
>  delete mode 100644 Documentation/input/conf.py
>  delete mode 100644 Documentation/kernel-hacking/conf.py
>  delete mode 100644 Documentation/maintainer/conf.py
>  delete mode 100644 Documentation/media/conf.py
>  delete mode 100644 Documentation/networking/conf.py
>  rename Documentation/powerpc/{bootwrapper.txt => bootwrapper.rst} (93%)
>  rename Documentation/powerpc/{cpu_families.txt => cpu_families.rst} (95%)
>  rename Documentation/powerpc/{cpu_features.txt => cpu_features.rst} (97%)
>  rename Documentation/powerpc/{cxl.txt => cxl.rst} (95%)
>  rename Documentation/powerpc/{cxlflash.txt => cxlflash.rst} (98%)
>  rename Documentation/powerpc/{DAWR-POWER9.txt => dawr-power9.rst} (95%)
>  rename Documentation/powerpc/{dscr.txt => dscr.rst} (91%)
>  rename Documentation/powerpc/{eeh-pci-error-recovery.txt => eeh-pci-error-recovery.rst} (82%)
>  rename Documentation/powerpc/{firmware-assisted-dump.txt => firmware-assisted-dump.rst} (80%)
>  rename Documentation/powerpc/{hvcs.txt => hvcs.rst} (91%)
>  create mode 100644 Documentation/powerpc/index.rst
>  rename Documentation/powerpc/{mpc52xx.txt => mpc52xx.rst} (91%)
>  rename Documentation/powerpc/{pci_iov_resource_on_powernv.txt => pci_iov_resource_on_powernv.rst} (97%)
>  rename Documentation/powerpc/{pmu-ebb.txt => pmu-ebb.rst} (99%)
>  create mode 100644 Documentation/powerpc/ptrace.rst
>  delete mode 100644 Documentation/powerpc/ptrace.txt
>  rename Documentation/powerpc/{qe_firmware.txt => qe_firmware.rst} (95%)
>  rename Documentation/powerpc/{syscall64-abi.txt => syscall64-abi.rst} (82%)
>  rename Documentation/powerpc/{transactional_memory.txt => transactional_memory.rst} (93%)
>  delete mode 100644 Documentation/process/conf.py
>  delete mode 100644 Documentation/sh/conf.py
>  delete mode 100644 Documentation/sound/conf.py
>  create mode 100644 Documentation/translations/it_IT/process/programming-language.rst
>  delete mode 100644 Documentation/userspace-api/conf.py
>  delete mode 100644 Documentation/vm/conf.py
>  delete mode 100644 Documentation/x86/conf.py
>  delete mode 100644 arch/arm/mach-netx/Kconfig
>  delete mode 100644 arch/arm/mach-netx/Makefile
>  delete mode 100644 arch/arm/mach-netx/Makefile.boot
>  delete mode 100644 arch/arm/mach-netx/fb.c
>  delete mode 100644 arch/arm/mach-netx/fb.h
>  delete mode 100644 arch/arm/mach-netx/generic.c
>  delete mode 100644 arch/arm/mach-netx/generic.h
>  delete mode 100644 arch/arm/mach-netx/include/mach/hardware.h
>  delete mode 100644 arch/arm/mach-netx/include/mach/irqs.h
>  delete mode 100644 arch/arm/mach-netx/include/mach/netx-regs.h
>  delete mode 100644 arch/arm/mach-netx/include/mach/pfifo.h
>  delete mode 100644 arch/arm/mach-netx/include/mach/uncompress.h
>  delete mode 100644 arch/arm/mach-netx/include/mach/xc.h
>  delete mode 100644 arch/arm/mach-netx/nxdb500.c
>  delete mode 100644 arch/arm/mach-netx/nxdkn.c
>  delete mode 100644 arch/arm/mach-netx/nxeb500hmi.c
>  delete mode 100644 arch/arm/mach-netx/pfifo.c
>  delete mode 100644 arch/arm/mach-netx/time.c
>  delete mode 100644 arch/arm/mach-netx/xc.c
>  rename arch/parisc/configs/{default_defconfig => defconfig} (100%)
>  create mode 100644 arch/powerpc/kernel/dma-common.c
>  delete mode 100644 arch/riscv/lib/udivdi3.S
>  create mode 100644 arch/s390/boot/version.c
>  delete mode 100644 arch/x86/purgatory/string.c
>  delete mode 100644 drivers/tty/serial/netx-serial.c
>  rename {kernel => mm}/memremap.c (98%)
>  mode change 100755 => 100644 sound/soc/codecs/rt1308.c
>  mode change 100755 => 100644 sound/soc/codecs/rt1308.h
>  create mode 100755 tools/testing/selftests/bpf/test_xdp_vlan_mode_generic.sh
>  create mode 100755 tools/testing/selftests/bpf/test_xdp_vlan_mode_native.sh
>  create mode 100644 tools/testing/selftests/kvm/lib/aarch64/ucall.c
>  create mode 100644 tools/testing/selftests/kvm/lib/s390x/ucall.c
>  delete mode 100644 tools/testing/selftests/kvm/lib/ucall.c
>  create mode 100644 tools/testing/selftests/kvm/lib/x86_64/ucall.c
>  create mode 100644 tools/testing/selftests/kvm/s390x/memop.c
