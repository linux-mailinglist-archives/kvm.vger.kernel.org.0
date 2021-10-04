Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 686EA4204F0
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 04:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232290AbhJDCaG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 3 Oct 2021 22:30:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230513AbhJDCaF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 3 Oct 2021 22:30:05 -0400
Received: from mail-ua1-x935.google.com (mail-ua1-x935.google.com [IPv6:2607:f8b0:4864:20::935])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C3F5C0613EC;
        Sun,  3 Oct 2021 19:28:17 -0700 (PDT)
Received: by mail-ua1-x935.google.com with SMTP id t36so11243987uad.4;
        Sun, 03 Oct 2021 19:28:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E0SmXOJFXjvRs/s+aJXGqr/1udo2EYK0UBqZiIXY/VQ=;
        b=ErDKEAe9Eq4x9eeVXjvhEUkAcOEdAHEhdxiaKPnDKmkcaQIoRMBewO3vAf8lol7vnq
         r9FZcC2h7ui2wXyQgsqXmcHpzFnhEtRp2wSbNSrFEkdma6wSNb+Sp/j2QeYwbj9qwomL
         9lRaFknKybfI9GLABzM2rS14GpIK5oNKhoPW7c+OYx0ScB1kJcWi4hfEenSF7+Zdmmr9
         2URIn1Wldzrcd0d9jd7RaKZPgDSq5M9cwnLbxasUd3ajBEX4IvUBIxAlTZHHJMjBWIA/
         lrSOE8dnL6Nt5nMnGz46YOndozN7NrZOcYdle0sj5tQQOnLo2TQ6/OfclrtYKtA8PUZd
         nAuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E0SmXOJFXjvRs/s+aJXGqr/1udo2EYK0UBqZiIXY/VQ=;
        b=xBmpV71v2iyHe2zAZ7CFdbZlx0Kqy/gxSeCWVLgf0iVAPrU9DYIFvRCPTXx1ENHipr
         BSiBP8i7h2+8B+Mseg6OjKVGE4I23yPiK+dUsxd3al7R2yesd6Iw4HZv2NwPAAM+UnXW
         OTKwuCctF19q9WtUMjhd7hdCgoU6I+d8lsKP6hXt54sZr8G1es9SnrQh9eEUOOFM/TGe
         dLlbpJ/uP2BxJ6yvHSuqgn/G22MYq+oJOk4i5y6U60IcL27h/Cc2R0VdtAhpqvYlv/qs
         55L76d6yJO+/0GiOAYI20mY8HTCVOoFHBzIz2fvzo5Vfi2Jz9R09s3sFMvSQ8fTSiXAq
         XVaw==
X-Gm-Message-State: AOAM533iuHjRLmMVkmk67YWMr21ofQY4HeGAHrVEckwH1ZhlPw4Gs0wC
        zO735AvciGAzgbJ55WOdqxIwzDkA/oy+XQceG+Y=
X-Google-Smtp-Source: ABdhPJwOUZm7fS3RYfBebQ3MGO2OjxQYCYT1aBdAS6JwH1f0/JmY11L7LllTOXkqs7JV04gEiplg7MLG3mKoSh6tR5g=
X-Received: by 2002:ab0:5448:: with SMTP id o8mr4765435uaa.59.1633314496407;
 Sun, 03 Oct 2021 19:28:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210927114016.1089328-1-anup.patel@wdc.com> <CAAhSdy1yZ11L=A3g06GXM8tFtonBX0Cj5NDyGHQ1v44vJ8MqSA@mail.gmail.com>
 <CAFiDJ5_--KsNd3aH1gT_cgU32C+wzunzXeSKtn8HTNj_La7n5A@mail.gmail.com> <CAAhSdy1un6ab62LN-0ihV=oku8EH3fZ5YzbX1zzUFAEbatVAuQ@mail.gmail.com>
In-Reply-To: <CAAhSdy1un6ab62LN-0ihV=oku8EH3fZ5YzbX1zzUFAEbatVAuQ@mail.gmail.com>
From:   Ley Foon Tan <lftan.linux@gmail.com>
Date:   Mon, 4 Oct 2021 10:28:05 +0800
Message-ID: <CAFiDJ5-Pew6311w7pS-_ADWQnP=H7gFEUUuU8MqhsMHEDrofdA@mail.gmail.com>
Subject: Re: [PATCH v20 00/17] KVM RISC-V Support
To:     Anup Patel <anup@brainfault.org>
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

On Fri, Oct 1, 2021 at 6:41 PM Anup Patel <anup@brainfault.org> wrote:
>
> On Fri, Oct 1, 2021 at 2:33 PM Ley Foon Tan <lftan.linux@gmail.com> wrote:
> >
> > On Mon, Sep 27, 2021 at 8:01 PM Anup Patel <anup@brainfault.org> wrote:
> > >
> > > Hi Palmer, Hi Paolo,
> > >
> > > On Mon, Sep 27, 2021 at 5:10 PM Anup Patel <anup.patel@wdc.com> wrote:
> > > >
> > > > This series adds initial KVM RISC-V support. Currently, we are able to boot
> > > > Linux on RV64/RV32 Guest with multiple VCPUs.
> > > >
> > > > Key aspects of KVM RISC-V added by this series are:
> > > > 1. No RISC-V specific KVM IOCTL
> > > > 2. Loadable KVM RISC-V module supported
> > > > 3. Minimal possible KVM world-switch which touches only GPRs and few CSRs
> > > > 4. Both RV64 and RV32 host supported
> > > > 5. Full Guest/VM switch is done via vcpu_get/vcpu_put infrastructure
> > > > 6. KVM ONE_REG interface for VCPU register access from user-space
> > > > 7. PLIC emulation is done in user-space
> > > > 8. Timer and IPI emuation is done in-kernel
> > > > 9. Both Sv39x4 and Sv48x4 supported for RV64 host
> > > > 10. MMU notifiers supported
> > > > 11. Generic dirtylog supported
> > > > 12. FP lazy save/restore supported
> > > > 13. SBI v0.1 emulation for KVM Guest available
> > > > 14. Forward unhandled SBI calls to KVM userspace
> > > > 15. Hugepage support for Guest/VM
> > > > 16. IOEVENTFD support for Vhost
> > > >
> > > > Here's a brief TODO list which we will work upon after this series:
> > > > 1. KVM unit test support
> > > > 2. KVM selftest support
> > > > 3. SBI v0.3 emulation in-kernel
> > > > 4. In-kernel PMU virtualization
> > > > 5. In-kernel AIA irqchip support
> > > > 6. Nested virtualizaiton
> > > > 7. ..... and more .....
> > > >
> > > > This series can be found in riscv_kvm_v20 branch at:
> > > > https//github.com/avpatel/linux.git
> > > >
> > > > Our work-in-progress KVMTOOL RISC-V port can be found in riscv_v9 branch
> > > > at: https//github.com/avpatel/kvmtool.git
> > > >
> > > > The QEMU RISC-V hypervisor emulation is done by Alistair and is available
> > > > in master branch at: https://git.qemu.org/git/qemu.git
> > > >
> > > > To play around with KVM RISC-V, refer KVM RISC-V wiki at:
> > > > https://github.com/kvm-riscv/howto/wiki
> > > > https://github.com/kvm-riscv/howto/wiki/KVM-RISCV64-on-QEMU
> > > > https://github.com/kvm-riscv/howto/wiki/KVM-RISCV64-on-Spike
> > > >
> > > > Changes since v19:
> > > >  - Rebased on Linux-5.15-rc3
> > > >  - Converted kvm_err() to kvm_debug() in kvm_set_spte_gfn() function
> > > >    added by PATCH11
> > > >
> > > > Changes since v18:
> > > >  - Rebased on Linux-5.14-rc3
> > > >  - Moved to new KVM debugfs interface
> > > >  - Dropped PATCH17 of v18 series for having KVM RISC-V in drivers/staging
> > > >
> > > > Changes since v17:
> > > >  - Rebased on Linux-5.13-rc2
> > > >  - Moved to new KVM MMU notifier APIs
> > > >  - Removed redundant kvm_arch_vcpu_uninit()
> > > >  - Moved KVM RISC-V sources to drivers/staging for compliance with
> > > >    Linux RISC-V patch acceptance policy
> > > >
> > > > Changes since v16:
> > > >  - Rebased on Linux-5.12-rc5
> > > >  - Remove redundant kvm_arch_create_memslot(), kvm_arch_vcpu_setup(),
> > > >    kvm_arch_vcpu_init(), kvm_arch_has_vcpu_debugfs(), and
> > > >    kvm_arch_create_vcpu_debugfs() from PATCH5
> > > >  - Make stage2_wp_memory_region() and stage2_ioremap() as static
> > > >    in PATCH13
> > > >
> > > > Changes since v15:
> > > >  - Rebased on Linux-5.11-rc3
> > > >  - Fixed kvm_stage2_map() to use gfn_to_pfn_prot() for determing
> > > >    writeability of a host pfn.
> > > >  - Use "__u64" in-place of "u64" and "__u32" in-place of "u32" for
> > > >    uapi/asm/kvm.h
> > > >
> > > > Changes since v14:
> > > >  - Rebased on Linux-5.10-rc3
> > > >  - Fixed Stage2 (G-stage) PDG allocation to ensure it is 16KB aligned
> > > >
> > > > Changes since v13:
> > > >  - Rebased on Linux-5.9-rc3
> > > >  - Fixed kvm_riscv_vcpu_set_reg_csr() for SIP updation in PATCH5
> > > >  - Fixed instruction length computation in PATCH7
> > > >  - Added ioeventfd support in PATCH7
> > > >  - Ensure HSTATUS.SPVP is set to correct value before using HLV/HSV
> > > >    intructions in PATCH7
> > > >  - Fixed stage2_map_page() to set PTE 'A' and 'D' bits correctly
> > > >    in PATCH10
> > > >  - Added stage2 dirty page logging in PATCH10
> > > >  - Allow KVM user-space to SET/GET SCOUNTER CSR in PATCH5
> > > >  - Save/restore SCOUNTEREN in PATCH6
> > > >  - Reduced quite a few instructions for __kvm_riscv_switch_to() by
> > > >    using CSR swap instruction in PATCH6
> > > >  - Detect and use Sv48x4 when available in PATCH10
> > > >
> > > > Changes since v12:
> > > >  - Rebased patches on Linux-5.8-rc4
> > > >  - By default enable all counters in HCOUNTEREN
> > > >  - RISC-V H-Extension v0.6.1 spec support
> > > >
> > > > Changes since v11:
> > > >  - Rebased patches on Linux-5.7-rc3
> > > >  - Fixed typo in typecast of stage2_map_size define
> > > >  - Introduced struct kvm_cpu_trap to represent trap details and
> > > >    use it as function parameter wherever applicable
> > > >  - Pass memslot to kvm_riscv_stage2_map() for supporing dirty page
> > > >    logging in future
> > > >  - RISC-V H-Extension v0.6 spec support
> > > >  - Send-out first three patches as separate series so that it can
> > > >    be taken by Palmer for Linux RISC-V
> > > >
> > > > Changes since v10:
> > > >  - Rebased patches on Linux-5.6-rc5
> > > >  - Reduce RISCV_ISA_EXT_MAX from 256 to 64
> > > >  - Separate PATCH for removing N-extension related defines
> > > >  - Added comments as requested by Palmer
> > > >  - Fixed HIDELEG CSR programming
> > > >
> > > > Changes since v9:
> > > >  - Rebased patches on Linux-5.5-rc3
> > > >  - Squash PATCH19 and PATCH20 into PATCH5
> > > >  - Squash PATCH18 into PATCH11
> > > >  - Squash PATCH17 into PATCH16
> > > >  - Added ONE_REG interface for VCPU timer in PATCH13
> > > >  - Use HTIMEDELTA for VCPU timer in PATCH13
> > > >  - Updated KVM RISC-V mailing list in MAINTAINERS entry
> > > >  - Update KVM kconfig option to depend on RISCV_SBI and MMU
> > > >  - Check for SBI v0.2 and SBI v0.2 RFENCE extension at boot-time
> > > >  - Use SBI v0.2 RFENCE extension in VMID implementation
> > > >  - Use SBI v0.2 RFENCE extension in Stage2 MMU implementation
> > > >  - Use SBI v0.2 RFENCE extension in SBI implementation
> > > >  - Moved to RISC-V Hypervisor v0.5 draft spec
> > > >  - Updated Documentation/virt/kvm/api.txt for timer ONE_REG interface
> > > >
> > > > Changes since v8:
> > > >  - Rebased series on Linux-5.4-rc3 and Atish's SBI v0.2 patches
> > > >  - Use HRTIMER_MODE_REL instead of HRTIMER_MODE_ABS in timer emulation
> > > >  - Fixed kvm_riscv_stage2_map() to handle hugepages
> > > >  - Added patch to forward unhandled SBI calls to user-space
> > > >  - Added patch for iterative/recursive stage2 page table programming
> > > >  - Added patch to remove per-CPU vsip_shadow variable
> > > >  - Added patch to fix race-condition in kvm_riscv_vcpu_sync_interrupts()
> > > >
> > > > Changes since v7:
> > > >  - Rebased series on Linux-5.4-rc1 and Atish's SBI v0.2 patches
> > > >  - Removed PATCH1, PATCH3, and PATCH20 because these already merged
> > > >  - Use kernel doc style comments for ISA bitmap functions
> > > >  - Don't parse X, Y, and Z extension in riscv_fill_hwcap() because it will
> > > >    be added in-future
> > > >  - Mark KVM RISC-V kconfig option as EXPERIMENTAL
> > > >  - Typo fix in commit description of PATCH6 of v7 series
> > > >  - Use separate structs for CORE and CSR registers of ONE_REG interface
> > > >  - Explicitly include asm/sbi.h in kvm/vcpu_sbi.c
> > > >  - Removed implicit switch-case fall-through in kvm_riscv_vcpu_exit()
> > > >  - No need to set VSSTATUS.MXR bit in kvm_riscv_vcpu_unpriv_read()
> > > >  - Removed register for instruction length in kvm_riscv_vcpu_unpriv_read()
> > > >  - Added defines for checking/decoding instruction length
> > > >  - Added separate patch to forward unhandled SBI calls to userspace tool
> > > >
> > > > Changes since v6:
> > > >  - Rebased patches on Linux-5.3-rc7
> > > >  - Added "return_handled" in struct kvm_mmio_decode to ensure that
> > > >    kvm_riscv_vcpu_mmio_return() updates SEPC only once
> > > >  - Removed trap_stval parameter from kvm_riscv_vcpu_unpriv_read()
> > > >  - Updated git repo URL in MAINTAINERS entry
> > > >
> > > > Changes since v5:
> > > >  - Renamed KVM_REG_RISCV_CONFIG_TIMEBASE register to
> > > >    KVM_REG_RISCV_CONFIG_TBFREQ register in ONE_REG interface
> > > >  - Update SPEC in kvm_riscv_vcpu_mmio_return() for MMIO exits
> > > >  - Use switch case instead of illegal instruction opcode table for simplicity
> > > >  - Improve comments in stage2_remote_tlb_flush() for a potential remote TLB
> > > >   flush optimization
> > > >  - Handle all unsupported SBI calls in default case of
> > > >    kvm_riscv_vcpu_sbi_ecall() function
> > > >  - Fixed kvm_riscv_vcpu_sync_interrupts() for software interrupts
> > > >  - Improved unprivilege reads to handle traps due to Guest stage1 page table
> > > >  - Added separate patch to document RISC-V specific things in
> > > >    Documentation/virt/kvm/api.txt
> > > >
> > > > Changes since v4:
> > > >  - Rebased patches on Linux-5.3-rc5
> > > >  - Added Paolo's Acked-by and Reviewed-by
> > > >  - Updated mailing list in MAINTAINERS entry
> > > >
> > > > Changes since v3:
> > > >  - Moved patch for ISA bitmap from KVM prep series to this series
> > > >  - Make vsip_shadow as run-time percpu variable instead of compile-time
> > > >  - Flush Guest TLBs on all Host CPUs whenever we run-out of VMIDs
> > > >
> > > > Changes since v2:
> > > >  - Removed references of KVM_REQ_IRQ_PENDING from all patches
> > > >  - Use kvm->srcu within in-kernel KVM run loop
> > > >  - Added percpu vsip_shadow to track last value programmed in VSIP CSR
> > > >  - Added comments about irqs_pending and irqs_pending_mask
> > > >  - Used kvm_arch_vcpu_runnable() in-place-of kvm_riscv_vcpu_has_interrupt()
> > > >    in system_opcode_insn()
> > > >  - Removed unwanted smp_wmb() in kvm_riscv_stage2_vmid_update()
> > > >  - Use kvm_flush_remote_tlbs() in kvm_riscv_stage2_vmid_update()
> > > >  - Use READ_ONCE() in kvm_riscv_stage2_update_hgatp() for vmid
> > > >
> > > > Changes since v1:
> > > >  - Fixed compile errors in building KVM RISC-V as module
> > > >  - Removed unused kvm_riscv_halt_guest() and kvm_riscv_resume_guest()
> > > >  - Set KVM_CAP_SYNC_MMU capability only after MMU notifiers are implemented
> > > >  - Made vmid_version as unsigned long instead of atomic
> > > >  - Renamed KVM_REQ_UPDATE_PGTBL to KVM_REQ_UPDATE_HGATP
> > > >  - Renamed kvm_riscv_stage2_update_pgtbl() to kvm_riscv_stage2_update_hgatp()
> > > >  - Configure HIDELEG and HEDELEG in kvm_arch_hardware_enable()
> > > >  - Updated ONE_REG interface for CSR access to user-space
> > > >  - Removed irqs_pending_lock and use atomic bitops instead
> > > >  - Added separate patch for FP ONE_REG interface
> > > >  - Added separate patch for updating MAINTAINERS file
> > > >
> > > > Anup Patel (13):
> > > >   RISC-V: Add hypervisor extension related CSR defines
> > > >   RISC-V: Add initial skeletal KVM support
> > > >   RISC-V: KVM: Implement VCPU create, init and destroy functions
> > > >   RISC-V: KVM: Implement VCPU interrupts and requests handling
> > > >   RISC-V: KVM: Implement KVM_GET_ONE_REG/KVM_SET_ONE_REG ioctls
> > > >   RISC-V: KVM: Implement VCPU world-switch
> > > >   RISC-V: KVM: Handle MMIO exits for VCPU
> > > >   RISC-V: KVM: Handle WFI exits for VCPU
> > > >   RISC-V: KVM: Implement VMID allocator
> > > >   RISC-V: KVM: Implement stage2 page table programming
> > > >   RISC-V: KVM: Implement MMU notifiers
> > > >   RISC-V: KVM: Document RISC-V specific parts of KVM API
> > > >   RISC-V: KVM: Add MAINTAINERS entry
> > > >
> > > > Atish Patra (4):
> > > >   RISC-V: KVM: Add timer functionality
> > > >   RISC-V: KVM: FP lazy save/restore
> > > >   RISC-V: KVM: Implement ONE REG interface for FP registers
> > > >   RISC-V: KVM: Add SBI v0.1 support
> > > >
> > > >  Documentation/virt/kvm/api.rst          | 193 ++++-
> > > >  MAINTAINERS                             |  12 +
> > > >  arch/riscv/Kconfig                      |   1 +
> > > >  arch/riscv/Makefile                     |   1 +
> > > >  arch/riscv/include/asm/csr.h            |  87 +++
> > > >  arch/riscv/include/asm/kvm_host.h       | 266 +++++++
> > > >  arch/riscv/include/asm/kvm_types.h      |   7 +
> > > >  arch/riscv/include/asm/kvm_vcpu_timer.h |  44 ++
> > > >  arch/riscv/include/uapi/asm/kvm.h       | 128 +++
> > > >  arch/riscv/kernel/asm-offsets.c         | 156 ++++
> > > >  arch/riscv/kvm/Kconfig                  |  36 +
> > > >  arch/riscv/kvm/Makefile                 |  25 +
> > > >  arch/riscv/kvm/main.c                   | 118 +++
> > > >  arch/riscv/kvm/mmu.c                    | 802 +++++++++++++++++++
> > > >  arch/riscv/kvm/tlb.S                    |  74 ++
> > > >  arch/riscv/kvm/vcpu.c                   | 997 ++++++++++++++++++++++++
> > > >  arch/riscv/kvm/vcpu_exit.c              | 701 +++++++++++++++++
> > > >  arch/riscv/kvm/vcpu_sbi.c               | 185 +++++
> > > >  arch/riscv/kvm/vcpu_switch.S            | 400 ++++++++++
> > > >  arch/riscv/kvm/vcpu_timer.c             | 225 ++++++
> > > >  arch/riscv/kvm/vm.c                     |  97 +++
> > > >  arch/riscv/kvm/vmid.c                   | 120 +++
> > > >  drivers/clocksource/timer-riscv.c       |   9 +
> > > >  include/clocksource/timer-riscv.h       |  16 +
> > > >  include/uapi/linux/kvm.h                |   8 +
> > > >  25 files changed, 4699 insertions(+), 9 deletions(-)
> > > >  create mode 100644 arch/riscv/include/asm/kvm_host.h
> > > >  create mode 100644 arch/riscv/include/asm/kvm_types.h
> > > >  create mode 100644 arch/riscv/include/asm/kvm_vcpu_timer.h
> > > >  create mode 100644 arch/riscv/include/uapi/asm/kvm.h
> > > >  create mode 100644 arch/riscv/kvm/Kconfig
> > > >  create mode 100644 arch/riscv/kvm/Makefile
> > > >  create mode 100644 arch/riscv/kvm/main.c
> > > >  create mode 100644 arch/riscv/kvm/mmu.c
> > > >  create mode 100644 arch/riscv/kvm/tlb.S
> > > >  create mode 100644 arch/riscv/kvm/vcpu.c
> > > >  create mode 100644 arch/riscv/kvm/vcpu_exit.c
> > > >  create mode 100644 arch/riscv/kvm/vcpu_sbi.c
> > > >  create mode 100644 arch/riscv/kvm/vcpu_switch.S
> > > >  create mode 100644 arch/riscv/kvm/vcpu_timer.c
> > > >  create mode 100644 arch/riscv/kvm/vm.c
> > > >  create mode 100644 arch/riscv/kvm/vmid.c
> > > >  create mode 100644 include/clocksource/timer-riscv.h
> > > >
> > > > --
> > > > 2.25.1
> > > >
> > >
> > > The RISC-V H-extension is now frozen. Please refer to the latest
> > > RISC-V privilege specification v1.12 which is in public review.
> > > https://github.com/riscv/riscv-isa-manual/releases/download/riscv-privileged-20210915-public-review/riscv-privileged-20210915-public-review.pdf
> > >
> > > Currently, the RISC-V H-extension is on it's way to being ratified.
> > > https://wiki.riscv.org/display/TECH/ISA+Extensions+On+Deck+for+Freeze+Milestone
> > > https://wiki.riscv.org/display/TECH/ISA+Extensions+On+Deck+-+Ready+for+Ratification+Milestone
> > >
> > > Here's the announcement on twitter from Mark (CTO, RISC-V International)
> > > https://twitter.com/mark_riscv/status/1441375977624375296
> > >
> > > This means the KVM RISC-V series now satisfies the
> > > requirements of the Linux RISC-V patch acceptance policy.
> > >
> > > Can we consider the KVM RISC-V series for Linux-5.16 ?
> > >
> > > Regards,
> > > Anup
> >
> > Hi Anup
> >
> > I have tried this patchset, but have problems starting the kvm on host linux.
> > Both Qemu and Spike are unable to run kvm.
> >
> > 1. Qemu: have the following error when starting kvm.
> >
> > [   17.877101] Run /init as init process
> > [  217.908013] kvm [61]: VCPU exit error -14
> > [  217.908577] kvm [61]: SEPC=0x7e86a SSTATUS=0x4020 HSTATUS=0x200200080
> > [  217.909626] kvm [61]: SCAUSE=0x2 STVAL=0x20866633 HTVAL=0x0 HTINST=0x0
> > KVM_RUN failed: Bad address
> >
> > 2. Spike: Stop at this line when starting kvm.
> >
> > [    1.116675] sit: IPv6, IPv4 and MPLS over IPv4 tunneling driver
> > [    1.120875] NET: Registered PF_PACKET protocol family
> > [    1.123830] 9pnet: Installing 9P2000 support
> > [    1.127935] Key type dns_resolver registered
> > [    1.130390] debug_vm_pgtable: [debug_vm_pgtable         ]:
> > Validating architecture page table helpers
>
> It's strange everything works for me on QEMU at least. Although, I did
> not have time to try on Spike.
>
> >
> > These are the git repo that I'm using:
> > Linux: https://github.com/avpatel/linux/tree/riscv_kvm_v20
> > Qemu: https://gitlab.com/qemu-project/qemu.git  (master branch)
> > Spike: https://github.com/riscv/riscv-isa-sim.git (master branch)
> > kvm-tool: https//github.com/avpatel/kvmtool.git
>.
> You should be using riscv_v9 branch of
> https//github.com/avpatel/kvmtool.git
>
> >
> > Any other things that need to be updated to make it work?
>
> If you want to use exact same QEMU which I am using then
> PULL riscv_aia_v2 branch of
> https://github.com/avpatel/qemu.git
>
Hi Anup

It is able to boot up to kvm guest OS after change to use
https://github.com/avpatel/qemu.git, riscv_aia_v2 branch.
Is there dependency to AIA hardware feature for KVM?


Log:

[    6.212484] Run /virt/init as init process
Mounting...
[    7.202552] random: fast init done
/ # cat /proc/cpuinfo
processor : 0
hart : 1
isa : rv64imafdcsu
mmu : sv48

processor : 1
hart : 0
isa : rv64imafdcsu
mmu : sv48

/ # cat /proc/interrupts
           CPU0       CPU1
  1:        355          0  SiFive PLIC   5 Edge      virtio0
  2:        212          0  SiFive PLIC   6 Edge      virtio1
  3:         11          0  SiFive PLIC   7 Edge      virtio2
  4:        155          0  SiFive PLIC   1 Edge      ttyS0
  5:       1150        942  RISC-V INTC   5 Edge      riscv-timer
IPI0:        19          5  Rescheduling interrupts
IPI1:        50        565  Function call interrupts
IPI2:         0          0  CPU stop interrupts
IPI3:         0          0  IRQ work interrupts
IPI4:         0          0  Timer broadcast interrupts


Thanks.

Regards
Ley Foon
