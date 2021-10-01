Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5983541EB19
	for <lists+kvm@lfdr.de>; Fri,  1 Oct 2021 12:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353280AbhJAKnH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Oct 2021 06:43:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353192AbhJAKnG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Oct 2021 06:43:06 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CDF1C06177B
        for <kvm@vger.kernel.org>; Fri,  1 Oct 2021 03:41:22 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id d207-20020a1c1dd8000000b00307e2d1ec1aso6409343wmd.5
        for <kvm@vger.kernel.org>; Fri, 01 Oct 2021 03:41:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=igYvG3jKxx1GJ77cjz/9gfqeRzqBxjpi1jAfEuEXPSE=;
        b=V7rDC4uVTACh9SzCAbsxvPndlU6ec8bu4kt7THzlXwIGy7kZxEi0Ht71sGMBKfRzne
         j4Z1znIyuAa+QvqQJVQedTr53zSHABkjjrweqyGlrtAW3463z2Yz22LZqU9KMlnCWQir
         uC/MoSCBc94pTynegNh0+TyAh8AxWcoaLo1W72raWEHfVwHO306uXibPMwVveRnKxRqw
         v/xAU9FL8NT9BGwWfJcd1oXDUR/sH4KRzSvDoATv2mrUnq0Aan/FJ9qvwdmoMN1ZkvO9
         9xxaoQwZesDn2GxszY+92UvELYH7YqbSUexXjqlqp1EYFfWfia90j/1Z1WcRSoB3PmjB
         qR/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=igYvG3jKxx1GJ77cjz/9gfqeRzqBxjpi1jAfEuEXPSE=;
        b=4ER35zCLEbV2Ppvu3xQDnkf32pSwclW6ANDTDydpp6tQXmawcWaJd/ZJo8Rm9QbYtN
         hZX6ItD5+yIbXO8RN3NiSQmGi6X5ueuOI5WCDXj859BD2JEIz90XYe21dN/6M8lKotR5
         N2gTm2z6r9w9a/M5wQ9Df0d20UK5VGn+T31FMs+rYTRXG1l6Dwx0QIS5AY2HOX8PIxb4
         FTMD0zHvYiG7oS7P5ABfZWU/NM2Ly8Ef2nUA3aTGHWvJxECvMpSPGvjeCEjwMwqQ2Jd8
         LjJM9KFkFCMwohP4znHRS0WsRseUzjobo5Or/V12R9uc3AkJTqLp23Aueurw/sWbCxfQ
         h41A==
X-Gm-Message-State: AOAM531HpWR4yy4KWCAqq3pHfQApbos1CBPypUVYZeqyDYzLGm+fyiMR
        EgnfAg/GbEHjfkqer9b+/ZeHooOlnckJhKLF6pmNpw==
X-Google-Smtp-Source: ABdhPJyeJtjAP6LFEtJOTnF4IU+BnDsRcwhyOrPoqQgipf7O52x2YM8Tfl+6zY4NnnToLgvTZDWYXjrU4wcKV0WFIPo=
X-Received: by 2002:a7b:cc14:: with SMTP id f20mr3550841wmh.137.1633084880395;
 Fri, 01 Oct 2021 03:41:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210927114016.1089328-1-anup.patel@wdc.com> <CAAhSdy1yZ11L=A3g06GXM8tFtonBX0Cj5NDyGHQ1v44vJ8MqSA@mail.gmail.com>
 <CAFiDJ5_--KsNd3aH1gT_cgU32C+wzunzXeSKtn8HTNj_La7n5A@mail.gmail.com>
In-Reply-To: <CAFiDJ5_--KsNd3aH1gT_cgU32C+wzunzXeSKtn8HTNj_La7n5A@mail.gmail.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Fri, 1 Oct 2021 16:11:08 +0530
Message-ID: <CAAhSdy1un6ab62LN-0ihV=oku8EH3fZ5YzbX1zzUFAEbatVAuQ@mail.gmail.com>
Subject: Re: [PATCH v20 00/17] KVM RISC-V Support
To:     Ley Foon Tan <lftan.linux@gmail.com>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexander Graf <graf@amazon.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        KVM General <kvm@vger.kernel.org>,
        kvm-riscv@lists.infradead.org,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Anup Patel <anup.patel@wdc.com>,
        Philipp Tomsich <philipp.tomsich@vrull.eu>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 1, 2021 at 2:33 PM Ley Foon Tan <lftan.linux@gmail.com> wrote:
>
> On Mon, Sep 27, 2021 at 8:01 PM Anup Patel <anup@brainfault.org> wrote:
> >
> > Hi Palmer, Hi Paolo,
> >
> > On Mon, Sep 27, 2021 at 5:10 PM Anup Patel <anup.patel@wdc.com> wrote:
> > >
> > > This series adds initial KVM RISC-V support. Currently, we are able to boot
> > > Linux on RV64/RV32 Guest with multiple VCPUs.
> > >
> > > Key aspects of KVM RISC-V added by this series are:
> > > 1. No RISC-V specific KVM IOCTL
> > > 2. Loadable KVM RISC-V module supported
> > > 3. Minimal possible KVM world-switch which touches only GPRs and few CSRs
> > > 4. Both RV64 and RV32 host supported
> > > 5. Full Guest/VM switch is done via vcpu_get/vcpu_put infrastructure
> > > 6. KVM ONE_REG interface for VCPU register access from user-space
> > > 7. PLIC emulation is done in user-space
> > > 8. Timer and IPI emuation is done in-kernel
> > > 9. Both Sv39x4 and Sv48x4 supported for RV64 host
> > > 10. MMU notifiers supported
> > > 11. Generic dirtylog supported
> > > 12. FP lazy save/restore supported
> > > 13. SBI v0.1 emulation for KVM Guest available
> > > 14. Forward unhandled SBI calls to KVM userspace
> > > 15. Hugepage support for Guest/VM
> > > 16. IOEVENTFD support for Vhost
> > >
> > > Here's a brief TODO list which we will work upon after this series:
> > > 1. KVM unit test support
> > > 2. KVM selftest support
> > > 3. SBI v0.3 emulation in-kernel
> > > 4. In-kernel PMU virtualization
> > > 5. In-kernel AIA irqchip support
> > > 6. Nested virtualizaiton
> > > 7. ..... and more .....
> > >
> > > This series can be found in riscv_kvm_v20 branch at:
> > > https//github.com/avpatel/linux.git
> > >
> > > Our work-in-progress KVMTOOL RISC-V port can be found in riscv_v9 branch
> > > at: https//github.com/avpatel/kvmtool.git
> > >
> > > The QEMU RISC-V hypervisor emulation is done by Alistair and is available
> > > in master branch at: https://git.qemu.org/git/qemu.git
> > >
> > > To play around with KVM RISC-V, refer KVM RISC-V wiki at:
> > > https://github.com/kvm-riscv/howto/wiki
> > > https://github.com/kvm-riscv/howto/wiki/KVM-RISCV64-on-QEMU
> > > https://github.com/kvm-riscv/howto/wiki/KVM-RISCV64-on-Spike
> > >
> > > Changes since v19:
> > >  - Rebased on Linux-5.15-rc3
> > >  - Converted kvm_err() to kvm_debug() in kvm_set_spte_gfn() function
> > >    added by PATCH11
> > >
> > > Changes since v18:
> > >  - Rebased on Linux-5.14-rc3
> > >  - Moved to new KVM debugfs interface
> > >  - Dropped PATCH17 of v18 series for having KVM RISC-V in drivers/staging
> > >
> > > Changes since v17:
> > >  - Rebased on Linux-5.13-rc2
> > >  - Moved to new KVM MMU notifier APIs
> > >  - Removed redundant kvm_arch_vcpu_uninit()
> > >  - Moved KVM RISC-V sources to drivers/staging for compliance with
> > >    Linux RISC-V patch acceptance policy
> > >
> > > Changes since v16:
> > >  - Rebased on Linux-5.12-rc5
> > >  - Remove redundant kvm_arch_create_memslot(), kvm_arch_vcpu_setup(),
> > >    kvm_arch_vcpu_init(), kvm_arch_has_vcpu_debugfs(), and
> > >    kvm_arch_create_vcpu_debugfs() from PATCH5
> > >  - Make stage2_wp_memory_region() and stage2_ioremap() as static
> > >    in PATCH13
> > >
> > > Changes since v15:
> > >  - Rebased on Linux-5.11-rc3
> > >  - Fixed kvm_stage2_map() to use gfn_to_pfn_prot() for determing
> > >    writeability of a host pfn.
> > >  - Use "__u64" in-place of "u64" and "__u32" in-place of "u32" for
> > >    uapi/asm/kvm.h
> > >
> > > Changes since v14:
> > >  - Rebased on Linux-5.10-rc3
> > >  - Fixed Stage2 (G-stage) PDG allocation to ensure it is 16KB aligned
> > >
> > > Changes since v13:
> > >  - Rebased on Linux-5.9-rc3
> > >  - Fixed kvm_riscv_vcpu_set_reg_csr() for SIP updation in PATCH5
> > >  - Fixed instruction length computation in PATCH7
> > >  - Added ioeventfd support in PATCH7
> > >  - Ensure HSTATUS.SPVP is set to correct value before using HLV/HSV
> > >    intructions in PATCH7
> > >  - Fixed stage2_map_page() to set PTE 'A' and 'D' bits correctly
> > >    in PATCH10
> > >  - Added stage2 dirty page logging in PATCH10
> > >  - Allow KVM user-space to SET/GET SCOUNTER CSR in PATCH5
> > >  - Save/restore SCOUNTEREN in PATCH6
> > >  - Reduced quite a few instructions for __kvm_riscv_switch_to() by
> > >    using CSR swap instruction in PATCH6
> > >  - Detect and use Sv48x4 when available in PATCH10
> > >
> > > Changes since v12:
> > >  - Rebased patches on Linux-5.8-rc4
> > >  - By default enable all counters in HCOUNTEREN
> > >  - RISC-V H-Extension v0.6.1 spec support
> > >
> > > Changes since v11:
> > >  - Rebased patches on Linux-5.7-rc3
> > >  - Fixed typo in typecast of stage2_map_size define
> > >  - Introduced struct kvm_cpu_trap to represent trap details and
> > >    use it as function parameter wherever applicable
> > >  - Pass memslot to kvm_riscv_stage2_map() for supporing dirty page
> > >    logging in future
> > >  - RISC-V H-Extension v0.6 spec support
> > >  - Send-out first three patches as separate series so that it can
> > >    be taken by Palmer for Linux RISC-V
> > >
> > > Changes since v10:
> > >  - Rebased patches on Linux-5.6-rc5
> > >  - Reduce RISCV_ISA_EXT_MAX from 256 to 64
> > >  - Separate PATCH for removing N-extension related defines
> > >  - Added comments as requested by Palmer
> > >  - Fixed HIDELEG CSR programming
> > >
> > > Changes since v9:
> > >  - Rebased patches on Linux-5.5-rc3
> > >  - Squash PATCH19 and PATCH20 into PATCH5
> > >  - Squash PATCH18 into PATCH11
> > >  - Squash PATCH17 into PATCH16
> > >  - Added ONE_REG interface for VCPU timer in PATCH13
> > >  - Use HTIMEDELTA for VCPU timer in PATCH13
> > >  - Updated KVM RISC-V mailing list in MAINTAINERS entry
> > >  - Update KVM kconfig option to depend on RISCV_SBI and MMU
> > >  - Check for SBI v0.2 and SBI v0.2 RFENCE extension at boot-time
> > >  - Use SBI v0.2 RFENCE extension in VMID implementation
> > >  - Use SBI v0.2 RFENCE extension in Stage2 MMU implementation
> > >  - Use SBI v0.2 RFENCE extension in SBI implementation
> > >  - Moved to RISC-V Hypervisor v0.5 draft spec
> > >  - Updated Documentation/virt/kvm/api.txt for timer ONE_REG interface
> > >
> > > Changes since v8:
> > >  - Rebased series on Linux-5.4-rc3 and Atish's SBI v0.2 patches
> > >  - Use HRTIMER_MODE_REL instead of HRTIMER_MODE_ABS in timer emulation
> > >  - Fixed kvm_riscv_stage2_map() to handle hugepages
> > >  - Added patch to forward unhandled SBI calls to user-space
> > >  - Added patch for iterative/recursive stage2 page table programming
> > >  - Added patch to remove per-CPU vsip_shadow variable
> > >  - Added patch to fix race-condition in kvm_riscv_vcpu_sync_interrupts()
> > >
> > > Changes since v7:
> > >  - Rebased series on Linux-5.4-rc1 and Atish's SBI v0.2 patches
> > >  - Removed PATCH1, PATCH3, and PATCH20 because these already merged
> > >  - Use kernel doc style comments for ISA bitmap functions
> > >  - Don't parse X, Y, and Z extension in riscv_fill_hwcap() because it will
> > >    be added in-future
> > >  - Mark KVM RISC-V kconfig option as EXPERIMENTAL
> > >  - Typo fix in commit description of PATCH6 of v7 series
> > >  - Use separate structs for CORE and CSR registers of ONE_REG interface
> > >  - Explicitly include asm/sbi.h in kvm/vcpu_sbi.c
> > >  - Removed implicit switch-case fall-through in kvm_riscv_vcpu_exit()
> > >  - No need to set VSSTATUS.MXR bit in kvm_riscv_vcpu_unpriv_read()
> > >  - Removed register for instruction length in kvm_riscv_vcpu_unpriv_read()
> > >  - Added defines for checking/decoding instruction length
> > >  - Added separate patch to forward unhandled SBI calls to userspace tool
> > >
> > > Changes since v6:
> > >  - Rebased patches on Linux-5.3-rc7
> > >  - Added "return_handled" in struct kvm_mmio_decode to ensure that
> > >    kvm_riscv_vcpu_mmio_return() updates SEPC only once
> > >  - Removed trap_stval parameter from kvm_riscv_vcpu_unpriv_read()
> > >  - Updated git repo URL in MAINTAINERS entry
> > >
> > > Changes since v5:
> > >  - Renamed KVM_REG_RISCV_CONFIG_TIMEBASE register to
> > >    KVM_REG_RISCV_CONFIG_TBFREQ register in ONE_REG interface
> > >  - Update SPEC in kvm_riscv_vcpu_mmio_return() for MMIO exits
> > >  - Use switch case instead of illegal instruction opcode table for simplicity
> > >  - Improve comments in stage2_remote_tlb_flush() for a potential remote TLB
> > >   flush optimization
> > >  - Handle all unsupported SBI calls in default case of
> > >    kvm_riscv_vcpu_sbi_ecall() function
> > >  - Fixed kvm_riscv_vcpu_sync_interrupts() for software interrupts
> > >  - Improved unprivilege reads to handle traps due to Guest stage1 page table
> > >  - Added separate patch to document RISC-V specific things in
> > >    Documentation/virt/kvm/api.txt
> > >
> > > Changes since v4:
> > >  - Rebased patches on Linux-5.3-rc5
> > >  - Added Paolo's Acked-by and Reviewed-by
> > >  - Updated mailing list in MAINTAINERS entry
> > >
> > > Changes since v3:
> > >  - Moved patch for ISA bitmap from KVM prep series to this series
> > >  - Make vsip_shadow as run-time percpu variable instead of compile-time
> > >  - Flush Guest TLBs on all Host CPUs whenever we run-out of VMIDs
> > >
> > > Changes since v2:
> > >  - Removed references of KVM_REQ_IRQ_PENDING from all patches
> > >  - Use kvm->srcu within in-kernel KVM run loop
> > >  - Added percpu vsip_shadow to track last value programmed in VSIP CSR
> > >  - Added comments about irqs_pending and irqs_pending_mask
> > >  - Used kvm_arch_vcpu_runnable() in-place-of kvm_riscv_vcpu_has_interrupt()
> > >    in system_opcode_insn()
> > >  - Removed unwanted smp_wmb() in kvm_riscv_stage2_vmid_update()
> > >  - Use kvm_flush_remote_tlbs() in kvm_riscv_stage2_vmid_update()
> > >  - Use READ_ONCE() in kvm_riscv_stage2_update_hgatp() for vmid
> > >
> > > Changes since v1:
> > >  - Fixed compile errors in building KVM RISC-V as module
> > >  - Removed unused kvm_riscv_halt_guest() and kvm_riscv_resume_guest()
> > >  - Set KVM_CAP_SYNC_MMU capability only after MMU notifiers are implemented
> > >  - Made vmid_version as unsigned long instead of atomic
> > >  - Renamed KVM_REQ_UPDATE_PGTBL to KVM_REQ_UPDATE_HGATP
> > >  - Renamed kvm_riscv_stage2_update_pgtbl() to kvm_riscv_stage2_update_hgatp()
> > >  - Configure HIDELEG and HEDELEG in kvm_arch_hardware_enable()
> > >  - Updated ONE_REG interface for CSR access to user-space
> > >  - Removed irqs_pending_lock and use atomic bitops instead
> > >  - Added separate patch for FP ONE_REG interface
> > >  - Added separate patch for updating MAINTAINERS file
> > >
> > > Anup Patel (13):
> > >   RISC-V: Add hypervisor extension related CSR defines
> > >   RISC-V: Add initial skeletal KVM support
> > >   RISC-V: KVM: Implement VCPU create, init and destroy functions
> > >   RISC-V: KVM: Implement VCPU interrupts and requests handling
> > >   RISC-V: KVM: Implement KVM_GET_ONE_REG/KVM_SET_ONE_REG ioctls
> > >   RISC-V: KVM: Implement VCPU world-switch
> > >   RISC-V: KVM: Handle MMIO exits for VCPU
> > >   RISC-V: KVM: Handle WFI exits for VCPU
> > >   RISC-V: KVM: Implement VMID allocator
> > >   RISC-V: KVM: Implement stage2 page table programming
> > >   RISC-V: KVM: Implement MMU notifiers
> > >   RISC-V: KVM: Document RISC-V specific parts of KVM API
> > >   RISC-V: KVM: Add MAINTAINERS entry
> > >
> > > Atish Patra (4):
> > >   RISC-V: KVM: Add timer functionality
> > >   RISC-V: KVM: FP lazy save/restore
> > >   RISC-V: KVM: Implement ONE REG interface for FP registers
> > >   RISC-V: KVM: Add SBI v0.1 support
> > >
> > >  Documentation/virt/kvm/api.rst          | 193 ++++-
> > >  MAINTAINERS                             |  12 +
> > >  arch/riscv/Kconfig                      |   1 +
> > >  arch/riscv/Makefile                     |   1 +
> > >  arch/riscv/include/asm/csr.h            |  87 +++
> > >  arch/riscv/include/asm/kvm_host.h       | 266 +++++++
> > >  arch/riscv/include/asm/kvm_types.h      |   7 +
> > >  arch/riscv/include/asm/kvm_vcpu_timer.h |  44 ++
> > >  arch/riscv/include/uapi/asm/kvm.h       | 128 +++
> > >  arch/riscv/kernel/asm-offsets.c         | 156 ++++
> > >  arch/riscv/kvm/Kconfig                  |  36 +
> > >  arch/riscv/kvm/Makefile                 |  25 +
> > >  arch/riscv/kvm/main.c                   | 118 +++
> > >  arch/riscv/kvm/mmu.c                    | 802 +++++++++++++++++++
> > >  arch/riscv/kvm/tlb.S                    |  74 ++
> > >  arch/riscv/kvm/vcpu.c                   | 997 ++++++++++++++++++++++++
> > >  arch/riscv/kvm/vcpu_exit.c              | 701 +++++++++++++++++
> > >  arch/riscv/kvm/vcpu_sbi.c               | 185 +++++
> > >  arch/riscv/kvm/vcpu_switch.S            | 400 ++++++++++
> > >  arch/riscv/kvm/vcpu_timer.c             | 225 ++++++
> > >  arch/riscv/kvm/vm.c                     |  97 +++
> > >  arch/riscv/kvm/vmid.c                   | 120 +++
> > >  drivers/clocksource/timer-riscv.c       |   9 +
> > >  include/clocksource/timer-riscv.h       |  16 +
> > >  include/uapi/linux/kvm.h                |   8 +
> > >  25 files changed, 4699 insertions(+), 9 deletions(-)
> > >  create mode 100644 arch/riscv/include/asm/kvm_host.h
> > >  create mode 100644 arch/riscv/include/asm/kvm_types.h
> > >  create mode 100644 arch/riscv/include/asm/kvm_vcpu_timer.h
> > >  create mode 100644 arch/riscv/include/uapi/asm/kvm.h
> > >  create mode 100644 arch/riscv/kvm/Kconfig
> > >  create mode 100644 arch/riscv/kvm/Makefile
> > >  create mode 100644 arch/riscv/kvm/main.c
> > >  create mode 100644 arch/riscv/kvm/mmu.c
> > >  create mode 100644 arch/riscv/kvm/tlb.S
> > >  create mode 100644 arch/riscv/kvm/vcpu.c
> > >  create mode 100644 arch/riscv/kvm/vcpu_exit.c
> > >  create mode 100644 arch/riscv/kvm/vcpu_sbi.c
> > >  create mode 100644 arch/riscv/kvm/vcpu_switch.S
> > >  create mode 100644 arch/riscv/kvm/vcpu_timer.c
> > >  create mode 100644 arch/riscv/kvm/vm.c
> > >  create mode 100644 arch/riscv/kvm/vmid.c
> > >  create mode 100644 include/clocksource/timer-riscv.h
> > >
> > > --
> > > 2.25.1
> > >
> >
> > The RISC-V H-extension is now frozen. Please refer to the latest
> > RISC-V privilege specification v1.12 which is in public review.
> > https://github.com/riscv/riscv-isa-manual/releases/download/riscv-privileged-20210915-public-review/riscv-privileged-20210915-public-review.pdf
> >
> > Currently, the RISC-V H-extension is on it's way to being ratified.
> > https://wiki.riscv.org/display/TECH/ISA+Extensions+On+Deck+for+Freeze+Milestone
> > https://wiki.riscv.org/display/TECH/ISA+Extensions+On+Deck+-+Ready+for+Ratification+Milestone
> >
> > Here's the announcement on twitter from Mark (CTO, RISC-V International)
> > https://twitter.com/mark_riscv/status/1441375977624375296
> >
> > This means the KVM RISC-V series now satisfies the
> > requirements of the Linux RISC-V patch acceptance policy.
> >
> > Can we consider the KVM RISC-V series for Linux-5.16 ?
> >
> > Regards,
> > Anup
>
> Hi Anup
>
> I have tried this patchset, but have problems starting the kvm on host linux.
> Both Qemu and Spike are unable to run kvm.
>
> 1. Qemu: have the following error when starting kvm.
>
> [   17.877101] Run /init as init process
> [  217.908013] kvm [61]: VCPU exit error -14
> [  217.908577] kvm [61]: SEPC=0x7e86a SSTATUS=0x4020 HSTATUS=0x200200080
> [  217.909626] kvm [61]: SCAUSE=0x2 STVAL=0x20866633 HTVAL=0x0 HTINST=0x0
> KVM_RUN failed: Bad address
>
> 2. Spike: Stop at this line when starting kvm.
>
> [    1.116675] sit: IPv6, IPv4 and MPLS over IPv4 tunneling driver
> [    1.120875] NET: Registered PF_PACKET protocol family
> [    1.123830] 9pnet: Installing 9P2000 support
> [    1.127935] Key type dns_resolver registered
> [    1.130390] debug_vm_pgtable: [debug_vm_pgtable         ]:
> Validating architecture page table helpers

It's strange everything works for me on QEMU at least. Although, I did
not have time to try on Spike.

>
> These are the git repo that I'm using:
> Linux: https://github.com/avpatel/linux/tree/riscv_kvm_v20
> Qemu: https://gitlab.com/qemu-project/qemu.git  (master branch)
> Spike: https://github.com/riscv/riscv-isa-sim.git (master branch)
> kvm-tool: https//github.com/avpatel/kvmtool.git

You should be using riscv_v9 branch of
https//github.com/avpatel/kvmtool.git

>
> Any other things that need to be updated to make it work?

If you want to use exact same QEMU which I am using then
PULL riscv_aia_v2 branch of
https://github.com/avpatel/qemu.git

I have provided my QEMU log below as well.

Regards,
Anup

>
> Note, previous v19 patchset is okay.
>
> Regards
> Ley Foon

anup@anup-ubuntu64-vm:~/Work/riscv-test$ qemu-system-riscv64 -cpu
rv64,x-h=true -M virt -m 512M -nographic -bios
opensbi/build/platform/generic/firmware/fw_jump.bin -kernel
./build-riscv64/arch/riscv/boot/Image -initrd ./rootfs_kvm_riscv64.img
-append "root=/dev/ram rw console=ttyS0 earlycon=sbi" -smp 6

OpenSBI v0.9-165-g4478809
   ____                    _____ ____ _____
  / __ \                  / ____|  _ \_   _|
 | |  | |_ __   ___ _ __ | (___ | |_) || |
 | |  | | '_ \ / _ \ '_ \ \___ \|  _ < | |
 | |__| | |_) |  __/ | | |____) | |_) || |_
  \____/| .__/ \___|_| |_|_____/|____/_____|
        | |
        |_|

Platform Name             : riscv-virtio,qemu
Platform Features         : medeleg
Platform HART Count       : 6
Platform IPI Device       : aclint-mswi
Platform Timer Device     : aclint-mtimer @ 10000000Hz
Platform Console Device   : uart8250
Platform HSM Device       : ---
Platform SysReset Device  : sifive_test
Firmware Base             : 0x80000000
Firmware Size             : 304 KB
Runtime SBI Version       : 0.3

Domain0 Name              : root
Domain0 Boot HART         : 2
Domain0 HARTs             : 0*,1*,2*,3*,4*,5*
Domain0 Region00          : 0x0000000002000000-0x000000000200ffff (I)
Domain0 Region01          : 0x0000000080000000-0x000000008007ffff ()
Domain0 Region02          : 0x0000000000000000-0xffffffffffffffff (R,W,X)
Domain0 Next Address      : 0x0000000080200000
Domain0 Next Arg1         : 0x0000000082200000
Domain0 Next Mode         : S-mode
Domain0 SysReset          : yes

Boot HART ID              : 2
Boot HART Domain          : root
Boot HART ISA             : rv64imafdcsuh
Boot HART Features        : scounteren,mcounteren,time
Boot HART PMP Count       : 16
Boot HART PMP Granularity : 4
Boot HART PMP Address Bits: 54
Boot HART MHPM Count      : 0
Boot HART MIDELEG         : 0x0000000000001666
Boot HART MEDELEG         : 0x0000000000f0b509
[    0.000000] Linux version 5.15.0-rc3-00020-g3940bf8c7e02
(anup@anup-ubuntu64-vm) (riscv64-unknown-linux-gnu-gcc (GCC) 9.2.0,
GNU ld (GNU Binutils) 2.34) #3 SMP Mon Sep 27 11:55:05 IST 2021
[    0.000000] OF: fdt: Ignoring memory range 0x80000000 - 0x80200000
[    0.000000] Machine model: riscv-virtio,qemu
[    0.000000] earlycon: sbi0 at I/O port 0x0 (options '')
[    0.000000] printk: bootconsole [sbi0] enabled
[    0.000000] efi: UEFI not found.
[    0.000000] Zone ranges:
[    0.000000]   DMA32    [mem 0x0000000080200000-0x000000009fffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000080200000-0x000000009fffffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000080200000-0x000000009fffffff]
[    0.000000] SBI specification v0.3 detected
[    0.000000] SBI implementation ID=0x1 Version=0x9
[    0.000000] SBI TIME extension detected
[    0.000000] SBI IPI extension detected
[    0.000000] SBI RFENCE extension detected
[    0.000000] SBI SRST extension detected
[    0.000000] SBI v0.2 HSM extension detected
[    0.000000] riscv: ISA extensions acdfhimsu
[    0.000000] riscv: ELF capabilities acdfim
[    0.000000] percpu: Embedded 17 pages/cpu s31080 r8192 d30360 u69632
[    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: 128775
[    0.000000] Kernel command line: root=/dev/ram rw console=ttyS0 earlycon=sbi
[    0.000000] Dentry cache hash table entries: 65536 (order: 7,
524288 bytes, linear)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144
bytes, linear)
[    0.000000] mem auto-init: stack:off, heap alloc:off, heap free:off
[    0.000000] Virtual kernel memory layout:
[    0.000000]       fixmap : 0xffffffcefee00000 - 0xffffffceff000000
 (2048 kB)
[    0.000000]       pci io : 0xffffffceff000000 - 0xffffffcf00000000
 (  16 MB)
[    0.000000]      vmemmap : 0xffffffcf00000000 - 0xffffffcfffffffff
 (4095 MB)
[    0.000000]      vmalloc : 0xffffffd000000000 - 0xffffffdfffffffff
 (65535 MB)
[    0.000000]       lowmem : 0xffffffe000000000 - 0xffffffe01fe00000
 ( 510 MB)
[    0.000000]       kernel : 0xffffffff80000000 - 0xffffffffffffffff
 (2047 MB)
[    0.000000] Memory: 461472K/522240K available (7348K kernel code,
4928K rwdata, 4096K rodata, 2147K init, 299K bss, 60768K reserved, 0K
cma-reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=6, Nodes=1
[    0.000000] rcu: Hierarchical RCU implementation.
[    0.000000] rcu:     RCU restricting CPUs from NR_CPUS=8 to nr_cpu_ids=6.
[    0.000000] rcu:     RCU debug extended QS entry/exit.
[    0.000000]     Tracing variant of Tasks RCU enabled.
[    0.000000] rcu: RCU calculated value of scheduler-enlistment delay
is 25 jiffies.
[    0.000000] rcu: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=6
[    0.000000] NR_IRQS: 64, nr_irqs: 64, preallocated irqs: 0
[    0.000000] riscv-intc: 64 local interrupts mapped
[    0.000000] plic: plic@c000000: mapped 53 interrupts with 6
handlers for 12 contexts.
[    0.000000] random: get_random_bytes called from
start_kernel+0x4be/0x6d0 with crng_init=0
[    0.000000] riscv_timer_init_dt: Registering clocksource cpuid [0] hartid [2]
[    0.000000] clocksource: riscv_clocksource: mask:
0xffffffffffffffff max_cycles: 0x24e6a1710, max_idle_ns: 440795202120
ns
[    0.000098] sched_clock: 64 bits at 10MHz, resolution 100ns, wraps
every 4398046511100ns
[    0.007687] Console: colour dummy device 80x25
[    0.022506] Calibrating delay loop (skipped), value calculated
using timer frequency.. 20.00 BogoMIPS (lpj=40000)
[    0.024665] pid_max: default: 32768 minimum: 301
[    0.028336] Mount-cache hash table entries: 1024 (order: 1, 8192
bytes, linear)
[    0.037197] Mountpoint-cache hash table entries: 1024 (order: 1,
8192 bytes, linear)
[    0.099528] ASID allocator disabled
[    0.102334] rcu: Hierarchical SRCU implementation.
[    0.105587] EFI services will not be available.
[    0.111331] smp: Bringing up secondary CPUs ...
[    0.142352] smp: Brought up 1 node, 6 CPUs
[    0.169452] devtmpfs: initialized
[    0.188459] clocksource: jiffies: mask: 0xffffffff max_cycles:
0xffffffff, max_idle_ns: 7645041785100000 ns
[    0.191145] futex hash table entries: 2048 (order: 5, 131072 bytes, linear)
[    0.203626] NET: Registered PF_NETLINK/PF_ROUTE protocol family
[    0.274557] HugeTLB registered 2.00 MiB page size, pre-allocated 0 pages
[    0.287213] vgaarb: loaded
[    0.289575] SCSI subsystem initialized
[    0.296764] usbcore: registered new interface driver usbfs
[    0.297502] usbcore: registered new interface driver hub
[    0.299242] usbcore: registered new device driver usb
[    0.331551] clocksource: Switched to clocksource riscv_clocksource
[    0.392658] NET: Registered PF_INET protocol family
[    0.394693] IP idents hash table entries: 8192 (order: 4, 65536
bytes, linear)
[    0.400489] tcp_listen_portaddr_hash hash table entries: 256
(order: 1, 10240 bytes, linear)
[    0.401236] TCP established hash table entries: 4096 (order: 3,
32768 bytes, linear)
[    0.402002] TCP bind hash table entries: 4096 (order: 5, 131072
bytes, linear)
[    0.402824] TCP: Hash tables configured (established 4096 bind 4096)
[    0.405079] UDP hash table entries: 256 (order: 2, 24576 bytes, linear)
[    0.406084] UDP-Lite hash table entries: 256 (order: 2, 24576 bytes, linear)
[    0.409396] NET: Registered PF_UNIX/PF_LOCAL protocol family
[    0.417946] RPC: Registered named UNIX socket transport module.
[    0.418574] RPC: Registered udp transport module.
[    0.418907] RPC: Registered tcp transport module.
[    0.419565] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.420333] PCI: CLS 0 bytes, default 64
[    0.421657] kvm [1]: hypervisor extension available
[    0.422370] kvm [1]: using Sv48x4 G-stage page table format
[    0.422849] kvm [1]: VMID 14 bits available
[    0.430261] workingset: timestamp_bits=62 max_order=17 bucket_order=0
[    0.433208] Unpacking initramfs...
[    0.453698] NFS: Registering the id_resolver key type
[    0.455536] Key type id_resolver registered
[    0.455945] Key type id_legacy registered
[    0.456826] nfs4filelayout_init: NFSv4 File Layout Driver Registering...
[    0.457448] nfs4flexfilelayout_init: NFSv4 Flexfile Layout Driver
Registering...
[    0.460062] 9p: Installing v9fs 9p2000 file system support
[    0.464474] NET: Registered PF_ALG protocol family
[    0.472960] Block layer SCSI generic (bsg) driver version 0.4
loaded (major 251)
[    0.473738] io scheduler mq-deadline registered
[    0.474674] io scheduler kyber registered
[    0.500235] pci-host-generic 30000000.pci: host bridge
/soc/pci@30000000 ranges:
[    0.501816] pci-host-generic 30000000.pci:       IO
0x0003000000..0x000300ffff -> 0x0000000000
[    0.504308] pci-host-generic 30000000.pci:      MEM
0x0040000000..0x007fffffff -> 0x0040000000
[    0.504957] pci-host-generic 30000000.pci:      MEM
0x0400000000..0x07ffffffff -> 0x0400000000
[    0.506348] pci-host-generic 30000000.pci: Memory resource size
exceeds max for 32 bits
[    0.510652] pci-host-generic 30000000.pci: ECAM at [mem
0x30000000-0x3fffffff] for [bus 00-ff]
[    0.517617] pci-host-generic 30000000.pci: PCI host bridge to bus 0000:00
[    0.519442] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.520018] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    0.520772] pci_bus 0000:00: root bus resource [mem 0x40000000-0x7fffffff]
[    0.521355] pci_bus 0000:00: root bus resource [mem 0x400000000-0x7ffffffff]
[    0.524395] pci 0000:00:00.0: [1b36:0008] type 00 class 0x060000
[    0.679883] Freeing initrd memory: 31888K
[    0.815789] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.825590] printk: console [ttyS0] disabled
[    0.829565] 10000000.uart: ttyS0 at MMIO 0x10000000 (irq = 2,
base_baud = 230400) is a 16550A
[    0.833171] printk: console [ttyS0] enabled
[    0.833171] printk: console [ttyS0] enabled
[    0.834330] printk: bootconsole [sbi0] disabled
[    0.834330] printk: bootconsole [sbi0] disabled
[    0.838103] [drm] radeon kernel modesetting enabled.
[    0.866158] loop: module loaded
[    0.872649] libphy: Fixed MDIO Bus: probed
[    0.874646] tun: Universal TUN/TAP device driver, 1.6
[    0.877187] e1000e: Intel(R) PRO/1000 Network Driver
[    0.877444] e1000e: Copyright(c) 1999 - 2015 Intel Corporation.
[    0.878396] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.878808] ehci-pci: EHCI PCI platform driver
[    0.879603] ehci-platform: EHCI generic platform driver
[    0.880429] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.880848] ohci-pci: OHCI PCI platform driver
[    0.881460] ohci-platform: OHCI generic platform driver
[    0.883955] usbcore: registered new interface driver uas
[    0.884628] usbcore: registered new interface driver usb-storage
[    0.886314] mousedev: PS/2 mouse device common for all mice
[    0.890923] goldfish_rtc 101000.rtc: registered as rtc0
[    0.892046] goldfish_rtc 101000.rtc: setting system clock to
2021-10-01T10:33:38 UTC (1633084418)
[    0.899464] syscon-poweroff soc:poweroff: pm_power_off already
claimed for sbi_srst_power_off
[    0.900071] syscon-poweroff: probe of soc:poweroff failed with error -16
[    0.901020] sdhci: Secure Digital Host Controller Interface driver
[    0.901287] sdhci: Copyright(c) Pierre Ossman
[    0.901751] sdhci-pltfm: SDHCI platform and OF driver helper
[    0.904482] usbcore: registered new interface driver usbhid
[    0.904790] usbhid: USB HID core driver
[    0.908639] NET: Registered PF_INET6 protocol family
[    0.927664] Segment Routing with IPv6
[    0.928044] In-situ OAM (IOAM) with IPv6
[    0.928708] sit: IPv6, IPv4 and MPLS over IPv4 tunneling driver
[    0.932629] NET: Registered PF_PACKET protocol family
[    0.934783] 9pnet: Installing 9P2000 support
[    0.935834] Key type dns_resolver registered
[    0.939287] debug_vm_pgtable: [debug_vm_pgtable         ]:
Validating architecture page table helpers
[    0.997012] Freeing unused kernel image (initmem) memory: 2144K
[    1.009790] Run /init as init process
           _  _
          | ||_|
          | | _ ____  _   _  _  _
          | || |  _ \| | | |\ \/ /
          | || | | | | |_| |/    \
          |_||_|_| |_|\____|\_/\_/

               Busybox Rootfs

Please press Enter to activate this console.
/ #
/ #
/ #
/ #
/ # ./apps/lkvm-static run -m 256 -c2 --console serial -p "console=ttyS0 earlyco
n=sbi" -k ./apps/Image --debug
  # lkvm run -k ./apps/Image -m 256 -c 2 --name guest-73
  Info: (riscv/kvm.c) kvm__arch_load_kernel_image:115: Loaded kernel
to 0x80200000 (19828224 bytes)
  Info: (riscv/kvm.c) kvm__arch_load_kernel_image:126: Placing fdt at
0x81c00000 - 0x8fffffff
  Info: (virtio/mmio.c) virtio_mmio_init:325:
virtio-mmio.devices=0x200@0x10000000:5
  Info: (virtio/mmio.c) virtio_mmio_init:325:
virtio-mmio.devices=0x200@0x10000200:6
  Info: (virtio/mmio.c) virtio_mmio_init:325:
virtio-mmio.devices=0x200@0x10000400:7
[    0.000000] Linux version 5.15.0-rc3-00020-g3940bf8c7e02
(anup@anup-ubuntu64-vm) (riscv64[   18.277856] random: fast init done
-unknown-linux-gnu-gcc (GCC) 9.2.0, GNU ld (GNU Binutils) 2.34) #3 SMP
Mon Sep 27 11:55:05 IST 2021
[    0.000000] OF: fdt: Ignoring memory range 0x80000000 - 0x80200000
[    0.000000] Machine model: linux,dummy-virt
[    0.000000] earlycon: sbi0 at I/O port 0x0 (options '')
[    0.000000] printk: bootconsole [sbi0] enabled
[    0.000000] efi: UEFI not found.
[    0.000000] Zone ranges:
[    0.000000]   DMA32    [mem 0x0000000080200000-0x000000008fffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000080200000-0x000000008fffffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000080200000-0x000000008fffffff]
[    0.000000] SBI specification v0.1 detected
[    0.000000] riscv: ISA extensions acdfimsu
[    0.000000] riscv: ELF capabilities acdfim
[    0.000000] percpu: Embedded 17 pages/cpu s31080 r8192 d30360 u69632
[    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: 64135
[    0.000000] Kernel command line:  console=ttyS0 rw
rootflags=trans=virtio,version=9p2000.L,cache=loose rootfstype=9p
init=/virt/init  ip=dhcp console=ttyS0 earlycon=sbi
[    0.000000] Dentry cache hash table entries: 32768 (order: 6,
262144 bytes, linear)
[    0.000000] Inode-cache hash table entries: 16384 (order: 5, 131072
bytes, linear)
[    0.000000] mem auto-init: stack:off, heap alloc:off, heap free:off
[    0.000000] Virtual kernel memory layout:
[    0.000000]       fixmap : 0xffffffcefee00000 - 0xffffffceff000000
 (2048 kB)
[    0.000000]       pci io : 0xffffffceff000000 - 0xffffffcf00000000
 (  16 MB)
[    0.000000]      vmemmap : 0xffffffcf00000000 - 0xffffffcfffffffff
 (4095 MB)
[    0.000000]      vmalloc : 0xffffffd000000000 - 0xffffffdfffffffff
 (65535 MB)
[    0.000000]       lowmem : 0xffffffe000000000 - 0xffffffe00fe00000
 ( 254 MB)
[    0.000000]       kernel : 0xffffffff80000000 - 0xffffffffffffffff
 (2047 MB)
[    0.000000] Memory: 235480K/260096K available (7348K kernel code,
4928K rwdata, 4096K rodata, 2147K init, 299K bss, 24616K reserved, 0K
cma-reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] rcu: Hierarchical RCU implementation.
[    0.000000] rcu:     RCU restricting CPUs from NR_CPUS=8 to nr_cpu_ids=2.
[    0.000000] rcu:     RCU debug extended QS entry/exit.
[    0.000000]     Tracing variant of Tasks RCU enabled.
[    0.000000] rcu: RCU calculated value of scheduler-enlistment delay
is 25 jiffies.
[    0.000000] rcu: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=2
[    0.000000] NR_IRQS: 64, nr_irqs: 64, preallocated irqs: 0
[    0.000000] riscv-intc: 64 local interrupts mapped
[    0.000000] plic: interrupt-controller@0c000000: mapped 1023
interrupts with 2 handlers for 4 contexts.
[    0.000000] random: get_random_bytes called from
start_kernel+0x4be/0x6d0 with crng_init=0
[    0.000000] riscv_timer_init_dt: Registering clocksource cpuid [0] hartid [0]
[    0.000000] clocksource: riscv_clocksource: mask:
0xffffffffffffffff max_cycles: 0x24e6a1710, max_idle_ns: 440795202120
ns
[    0.000105] sched_clock: 64 bits at 10MHz, resolution 100ns, wraps
every 4398046511100ns
[    0.047895] Console: colour dummy device 80x25
[    0.070813] Calibrating delay loop (skipped), value calculated
using timer frequency.. 20.00 BogoMIPS (lpj=40000)
[    0.097962] pid_max: default: 32768 minimum: 301
[    0.120511] Mount-cache hash table entries: 512 (order: 0, 4096
bytes, linear)
[    0.139480] Mountpoint-cache hash table entries: 512 (order: 0,
4096 bytes, linear)
[    0.317809] ASID allocator disabled
[    0.327541] rcu: Hierarchical SRCU implementation.
[    0.356508] EFI services will not be available.
[    0.403586] smp: Bringing up secondary CPUs ...
[    0.458170] smp: Brought up 1 node, 2 CPUs
[    0.529462] devtmpfs: initialized
[    0.603517] clocksource: jiffies: mask: 0xffffffff max_cycles:
0xffffffff, max_idle_ns: 7645041785100000 ns
[    0.627416] futex hash table entries: 512 (order: 3, 32768 bytes, linear)
[    0.691307] NET: Registered PF_NETLINK/PF_ROUTE protocol family
[    0.857061] HugeTLB registered 2.00 MiB page size, pre-allocated 0 pages
[    0.903144] vgaarb: loaded
[    0.930196] SCSI subsystem initialized
[    0.971577] usbcore: registered new interface driver usbfs
[    0.992211] usbcore: registered new interface driver hub
[    1.014991] usbcore: registered new device driver usb
[    1.089570] clocksource: Switched to clocksource riscv_clocksource
[    1.312442] NET: Registered PF_INET protocol family
[    1.332297] IP idents hash table entries: 4096 (order: 3, 32768
bytes, linear)
[    1.368581] tcp_listen_portaddr_hash hash table entries: 128
(order: 0, 5120 bytes, linear)
[    1.389779] TCP established hash table entries: 2048 (order: 2,
16384 bytes, linear)
[    1.415814] TCP bind hash table entries: 2048 (order: 4, 65536 bytes, linear)
[    1.451789] TCP: Hash tables configured (established 2048 bind 2048)
[    1.492552] UDP hash table entries: 256 (order: 2, 24576 bytes, linear)
[    1.516653] UDP-Lite hash table entries: 256 (order: 2, 24576 bytes, linear)
[    1.551271] NET: Registered PF_UNIX/PF_LOCAL protocol family
[    1.644965] RPC: Registered named UNIX socket transport module.
[    1.662890] RPC: Registered udp transport module.
[    1.672738] RPC: Registered tcp transport module.
[    1.684608] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    1.699605] PCI: CLS 0 bytes, default 64
[    1.712981] kvm [1]: hypervisor extension not available
[    1.751290] workingset: timestamp_bits=62 max_order=16 bucket_order=0
[    1.900334] NFS: Registering the id_resolver key type
[    1.911896] Key type id_resolver registered
[    1.920084] Key type id_legacy registered
[    1.936737] nfs4filelayout_init: NFSv4 File Layout Driver Registering...
[    1.958536] nfs4flexfilelayout_init: NFSv4 Flexfile Layout Driver
Registering...
[    1.984251] 9p: Installing v9fs 9p2000 file system support
[    2.018560] NET: Registered PF_ALG protocol family
[    2.031591] Block layer SCSI generic (bsg) driver version 0.4
loaded (major 251)
[    2.054728] io scheduler mq-deadline registered
[    2.066140] io scheduler kyber registered
[    2.123648] pci-host-generic 30000000.pci: host bridge /smb/pci ranges:
[    2.140214] pci-host-generic 30000000.pci:       IO
0x0000000000..0x000000ffff -> 0x0000000000
[    2.159639] pci-host-generic 30000000.pci:      MEM
0x0040000000..0x007fffffff -> 0x0040000000
[    2.186223] pci-host-generic 30000000.pci: ECAM at [mem
0x30000000-0x3fffffff] for [bus 00-01]
[    2.212533] pci-host-generic 30000000.pci: PCI host bridge to bus 0000:00
[    2.230607] pci_bus 0000:00: root bus resource [bus 00-01]
[    2.244304] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    2.261587] pci_bus 0000:00: root bus resource [mem 0x40000000-0x7fffffff]
[    3.247473] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    3.287475] printk: console [ttyS0] disabled
[    3.301067] 3f8.U6_16550A: ttyS0 at MMIO 0x3f8 (irq = 4, base_baud
= 115200) is a 16550A
[    3.339067] printk: console [ttyS0] enabled
[    3.339067] printk: console [ttyS0] enabled
[    3.379379] printk: bootconsole [sbi0] disabled
[    3.379379] printk: bootconsole [sbi0] disabled
[    3.424926] 2f8.U6_16550A: ttyS1 at MMIO 0x2f8 (irq = 6, base_baud
= 115200) is a 16550A
[    3.474126] 3e8.U6_16550A: ttyS2 at MMIO 0x3e8 (irq = 7, base_baud
= 115200) is a 16550A
[    3.518645] 2e8.U6_16550A: ttyS3 at MMIO 0x2e8 (irq = 8, base_baud
= 115200) is a 16550A
[    3.569005] [drm] radeon kernel modesetting enabled.
[    3.764244] loop: module loaded
[    3.823261] libphy: Fixed MDIO Bus: probed
[    3.874746] tun: Universal TUN/TAP device driver, 1.6
[    3.955899] net eth0: Fail to set guest offload.
[    3.974623] virtio_net virtio2 eth0: set_features() failed (-22);
wanted 0x0000000000134829, left 0x0080000000134829
[    4.039551] e1000e: Intel(R) PRO/1000 Network Driver
[    4.066605] e1000e: Copyright(c) 1999 - 2015 Intel Corporation.
[    4.094301] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.121598] ehci-pci: EHCI PCI platform driver
[    4.139321] ehci-platform: EHCI generic platform driver
[    4.163482] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    4.190231] ohci-pci: OHCI PCI platform driver
[    4.211914] ohci-platform: OHCI generic platform driver
[    4.262796] usbcore: registered new interface driver uas
[    4.291123] usbcore: registered new interface driver usb-storage
[    4.315228] mousedev: PS/2 mouse device common for all mice
[    4.344139] sdhci: Secure Digital Host Controller Interface driver
[    4.377006] sdhci: Copyright(c) Pierre Ossman
[    4.400437] sdhci-pltfm: SDHCI platform and OF driver helper
[    4.438821] usbcore: registered new interface driver usbhid
[    4.464857] usbhid: USB HID core driver
[    4.513075] NET: Registered PF_INET6 protocol family
[    4.607772] Segment Routing with IPv6
[    4.620961] In-situ OAM (IOAM) with IPv6
[    4.647281] sit: IPv6, IPv4 and MPLS over IPv4 tunneling driver
[    4.689995] NET: Registered PF_PACKET protocol family
[    4.722695] 9pnet: Installing 9P2000 support
[    4.763733] Key type dns_resolver registered
[    4.795638] debug_vm_pgtable: [debug_vm_pgtable         ]:
Validating architecture page table helpers
[    4.926827] Sending DHCP requests ., OK
[    4.966566] IP-Config: Got DHCP answer from 192.168.33.1, my
address is 192.168.33.15
[    4.994534] IP-Config: Complete:
[    5.006236]      device=eth0, hwaddr=02:15:15:15:15:15,
ipaddr=192.168.33.15, mask=255.255.255.0, gw=192.168.33.1
[    5.042790]      host=192.168.33.15, domain=, nis-domain=(none)
[    5.065080]      bootserver=192.168.33.1, rootserver=0.0.0.0, rootpath=
[    5.065399]      nameserver0=192.168.33.1
[    5.183771] VFS: Mounted root (9p filesystem) on device 0:15.
[    5.223392] devtmpfs: mounted
[    5.470393] Freeing unused kernel image (initmem) memory: 2144K
[    5.503256] Run /virt/init as init process
Mounting...
/ #
/ # [    6.766025] random: fast init done
/ # cat /proc/interrupts
           CPU0       CPU1
  1:        129          0  SiFive PLIC   5 Edge      virtio0
  2:        175          0  SiFive PLIC   6 Edge      virtio1
  3:         11          0  SiFive PLIC   7 Edge      virtio2
  4:         57          0  SiFive PLIC   1 Edge      ttyS0
  5:        765        884  RISC-V INTC   5 Edge      riscv-timer
IPI0:         3         19  Rescheduling interrupts
IPI1:       792        845  Function call interrupts
IPI2:         0          0  CPU stop interrupts
IPI3:         0          0  IRQ work interrupts
IPI4:         0          0  Timer broadcast interrupts
/ #
