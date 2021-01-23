Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B31E63012B8
	for <lists+kvm@lfdr.de>; Sat, 23 Jan 2021 04:43:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726662AbhAWDl0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jan 2021 22:41:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726628AbhAWDlO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jan 2021 22:41:14 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0C19C0613D6
        for <kvm@vger.kernel.org>; Fri, 22 Jan 2021 19:40:33 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id w18so5101781pfu.9
        for <kvm@vger.kernel.org>; Fri, 22 Jan 2021 19:40:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:subject:in-reply-to:cc:from:to:message-id:mime-version
         :content-transfer-encoding;
        bh=naeE5gIDed6EjJFYvJLpw1MxYlVt28w1zoWV9Wms6wo=;
        b=pH4MqiBKmz7nOt3QrVWL15doTnx4l4mtYihAZElWAyHJ1ywm4Lo+pWGuR4LCtc1Li/
         KNAMSLNRauBBhVuAP1dZ5oEuWPHooDoL7fqnEM4wOSKRbt9Xl8zsGPiDguPYTY3PYafN
         ATaEy7hLJ6zUgVwj0Pi4mBxwSsAzM467zUHMcoUBSZm56o2vWDsKFGbVnOxs9caQQymK
         hHNKeb2LBwMsZk5nXhW+OxVILbm6Ym/L8wjcg+//HT12bbAQWGWwNs1TCq+cCOYk4kCH
         EQ3eJw8j0bRLt/5W+M0ogrjBvvsjWsUdpvT98nbbxHj224ivRaQFYgA8ckcJc7B5WGZb
         o1Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
         :mime-version:content-transfer-encoding;
        bh=naeE5gIDed6EjJFYvJLpw1MxYlVt28w1zoWV9Wms6wo=;
        b=QQS6zRvzpt1Fd3BOzFOT2hgCiEOJHBXAE2ug/aLkw5J9geYYs23El0TLjECNOPP/ZK
         Z35EgN/II6gbzFGbnVmz4G9Y4L0rvOrVB8AqjppXlRU+shquqTvZd/3iTv792HEe8EuJ
         G3Nq2i/dzjgtXvYnS/qbf42DTmqVvyYxxfjJPk2R3xRSjN/r0j5SP9O6WDKEGhw/+1od
         bHBZn8r8KL3fGizb3MxtvZ7C3DhdJjcjuy6IafJNPmD72GSoXwfPF1PBOhIZLeb7eaUd
         Hphcl/ueZyRbqqHMoLd7cZN0hfuFZbNOKrUUOShV6FoaffO4ET3ey7ydI9YvmHR83of7
         vI6A==
X-Gm-Message-State: AOAM533NiTy4+5oW0el0snackvodEr+KDghrTabQYpVd4dpbz0toeIMq
        JsKdgQEQgp0ZiXn9FEFBJiRYUQ==
X-Google-Smtp-Source: ABdhPJx4zk4btyPJF3ksLoFggK5QxJuu0e5pvjqVta2+DwBJ1lTQ7EdPK31RXmMl1Y7H+a0wMI4bbQ==
X-Received: by 2002:a63:844:: with SMTP id 65mr2876426pgi.371.1611373232930;
        Fri, 22 Jan 2021 19:40:32 -0800 (PST)
Received: from localhost (76-210-143-223.lightspeed.sntcca.sbcglobal.net. [76.210.143.223])
        by smtp.gmail.com with ESMTPSA id a4sm10263880pfg.41.2021.01.22.19.40.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jan 2021 19:40:32 -0800 (PST)
Date:   Fri, 22 Jan 2021 19:40:32 -0800 (PST)
X-Google-Original-Date: Fri, 22 Jan 2021 19:40:01 PST (-0800)
Subject:     Re: [PATCH v16 00/17] KVM RISC-V Support
In-Reply-To: <20210115121846.114528-1-anup.patel@wdc.com>
CC:     Paul Walmsley <paul.walmsley@sifive.com>, aou@eecs.berkeley.edu,
        pbonzini@redhat.com, graf@amazon.com,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>, anup@brainfault.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        Anup Patel <Anup.Patel@wdc.com>
From:   Palmer Dabbelt <palmerdabbelt@google.com>
To:     Anup Patel <Anup.Patel@wdc.com>
Message-ID: <mhng-a4e92a0a-085d-4be0-863e-6af99dc27c18@palmerdabbelt-glaptop>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 15 Jan 2021 04:18:29 PST (-0800), Anup Patel wrote:
> This series adds initial KVM RISC-V support. Currently, we are able to boot
> Linux on RV64/RV32 Guest with multiple VCPUs.

Thanks.  IIUC the spec is still in limbo at the RISC-V foundation?  I haven't
really been paying attention lately.

>
> Key aspects of KVM RISC-V added by this series are:
> 1. No RISC-V specific KVM IOCTL
> 2. Minimal possible KVM world-switch which touches only GPRs and few CSRs
> 3. Both RV64 and RV32 host supported
> 4. Full Guest/VM switch is done via vcpu_get/vcpu_put infrastructure
> 5. KVM ONE_REG interface for VCPU register access from user-space
> 6. PLIC emulation is done in user-space
> 7. Timer and IPI emuation is done in-kernel
> 8. Both Sv39x4 and Sv48x4 supported for RV64 host
> 9. MMU notifiers supported
> 10. Generic dirtylog supported
> 11. FP lazy save/restore supported
> 12. SBI v0.1 emulation for KVM Guest available
> 13. Forward unhandled SBI calls to KVM userspace
> 14. Hugepage support for Guest/VM
> 15. IOEVENTFD support for Vhost
>
> Here's a brief TODO list which we will work upon after this series:
> 1. SBI v0.2 emulation in-kernel
> 2. SBI v0.2 hart state management emulation in-kernel
> 3. In-kernel PLIC emulation
> 4. ..... and more .....
>
> This series can be found in riscv_kvm_v16 branch at:
> https//github.com/avpatel/linux.git
>
> Our work-in-progress KVMTOOL RISC-V port can be found in riscv_v6 branch
> at: https//github.com/avpatel/kvmtool.git
>
> The QEMU RISC-V hypervisor emulation is done by Alistair and is available
> in master branch at: https://git.qemu.org/git/qemu.git
>
> To play around with KVM RISC-V, refer KVM RISC-V wiki at:
> https://github.com/kvm-riscv/howto/wiki
> https://github.com/kvm-riscv/howto/wiki/KVM-RISCV64-on-QEMU
> https://github.com/kvm-riscv/howto/wiki/KVM-RISCV64-on-Spike
>
> Changes since v15:
>  - Rebased on Linux-5.11-rc3
>  - Fixed kvm_stage2_map() to use gfn_to_pfn_prot() for determing
>    writeability of a host pfn.
>  - Use "__u64" in-place of "u64" and "__u32" in-place of "u32" for
>    uapi/asm/kvm.h
>
> Changes since v14:
>  - Rebased on Linux-5.10-rc3
>  - Fixed Stage2 (G-stage) PDG allocation to ensure it is 16KB aligned
>
> Changes since v13:
>  - Rebased on Linux-5.9-rc3
>  - Fixed kvm_riscv_vcpu_set_reg_csr() for SIP updation in PATCH5
>  - Fixed instruction length computation in PATCH7
>  - Added ioeventfd support in PATCH7
>  - Ensure HSTATUS.SPVP is set to correct value before using HLV/HSV
>    intructions in PATCH7
>  - Fixed stage2_map_page() to set PTE 'A' and 'D' bits correctly
>    in PATCH10
>  - Added stage2 dirty page logging in PATCH10
>  - Allow KVM user-space to SET/GET SCOUNTER CSR in PATCH5
>  - Save/restore SCOUNTEREN in PATCH6
>  - Reduced quite a few instructions for __kvm_riscv_switch_to() by
>    using CSR swap instruction in PATCH6
>  - Detect and use Sv48x4 when available in PATCH10
>
> Changes since v12:
>  - Rebased patches on Linux-5.8-rc4
>  - By default enable all counters in HCOUNTEREN
>  - RISC-V H-Extension v0.6.1 spec support
>
> Changes since v11:
>  - Rebased patches on Linux-5.7-rc3
>  - Fixed typo in typecast of stage2_map_size define
>  - Introduced struct kvm_cpu_trap to represent trap details and
>    use it as function parameter wherever applicable
>  - Pass memslot to kvm_riscv_stage2_map() for supporing dirty page
>    logging in future
>  - RISC-V H-Extension v0.6 spec support
>  - Send-out first three patches as separate series so that it can
>    be taken by Palmer for Linux RISC-V
>
> Changes since v10:
>  - Rebased patches on Linux-5.6-rc5
>  - Reduce RISCV_ISA_EXT_MAX from 256 to 64
>  - Separate PATCH for removing N-extension related defines
>  - Added comments as requested by Palmer
>  - Fixed HIDELEG CSR programming
>
> Changes since v9:
>  - Rebased patches on Linux-5.5-rc3
>  - Squash PATCH19 and PATCH20 into PATCH5
>  - Squash PATCH18 into PATCH11
>  - Squash PATCH17 into PATCH16
>  - Added ONE_REG interface for VCPU timer in PATCH13
>  - Use HTIMEDELTA for VCPU timer in PATCH13
>  - Updated KVM RISC-V mailing list in MAINTAINERS entry
>  - Update KVM kconfig option to depend on RISCV_SBI and MMU
>  - Check for SBI v0.2 and SBI v0.2 RFENCE extension at boot-time
>  - Use SBI v0.2 RFENCE extension in VMID implementation
>  - Use SBI v0.2 RFENCE extension in Stage2 MMU implementation
>  - Use SBI v0.2 RFENCE extension in SBI implementation
>  - Moved to RISC-V Hypervisor v0.5 draft spec
>  - Updated Documentation/virt/kvm/api.txt for timer ONE_REG interface
>
> Changes since v8:
>  - Rebased series on Linux-5.4-rc3 and Atish's SBI v0.2 patches
>  - Use HRTIMER_MODE_REL instead of HRTIMER_MODE_ABS in timer emulation
>  - Fixed kvm_riscv_stage2_map() to handle hugepages
>  - Added patch to forward unhandled SBI calls to user-space
>  - Added patch for iterative/recursive stage2 page table programming
>  - Added patch to remove per-CPU vsip_shadow variable
>  - Added patch to fix race-condition in kvm_riscv_vcpu_sync_interrupts()
>
> Changes since v7:
>  - Rebased series on Linux-5.4-rc1 and Atish's SBI v0.2 patches
>  - Removed PATCH1, PATCH3, and PATCH20 because these already merged
>  - Use kernel doc style comments for ISA bitmap functions
>  - Don't parse X, Y, and Z extension in riscv_fill_hwcap() because it will
>    be added in-future
>  - Mark KVM RISC-V kconfig option as EXPERIMENTAL
>  - Typo fix in commit description of PATCH6 of v7 series
>  - Use separate structs for CORE and CSR registers of ONE_REG interface
>  - Explicitly include asm/sbi.h in kvm/vcpu_sbi.c
>  - Removed implicit switch-case fall-through in kvm_riscv_vcpu_exit()
>  - No need to set VSSTATUS.MXR bit in kvm_riscv_vcpu_unpriv_read()
>  - Removed register for instruction length in kvm_riscv_vcpu_unpriv_read()
>  - Added defines for checking/decoding instruction length
>  - Added separate patch to forward unhandled SBI calls to userspace tool
>
> Changes since v6:
>  - Rebased patches on Linux-5.3-rc7
>  - Added "return_handled" in struct kvm_mmio_decode to ensure that
>    kvm_riscv_vcpu_mmio_return() updates SEPC only once
>  - Removed trap_stval parameter from kvm_riscv_vcpu_unpriv_read()
>  - Updated git repo URL in MAINTAINERS entry
>
> Changes since v5:
>  - Renamed KVM_REG_RISCV_CONFIG_TIMEBASE register to
>    KVM_REG_RISCV_CONFIG_TBFREQ register in ONE_REG interface
>  - Update SPEC in kvm_riscv_vcpu_mmio_return() for MMIO exits
>  - Use switch case instead of illegal instruction opcode table for simplicity
>  - Improve comments in stage2_remote_tlb_flush() for a potential remote TLB
>   flush optimization
>  - Handle all unsupported SBI calls in default case of
>    kvm_riscv_vcpu_sbi_ecall() function
>  - Fixed kvm_riscv_vcpu_sync_interrupts() for software interrupts
>  - Improved unprivilege reads to handle traps due to Guest stage1 page table
>  - Added separate patch to document RISC-V specific things in
>    Documentation/virt/kvm/api.txt
>
> Changes since v4:
>  - Rebased patches on Linux-5.3-rc5
>  - Added Paolo's Acked-by and Reviewed-by
>  - Updated mailing list in MAINTAINERS entry
>
> Changes since v3:
>  - Moved patch for ISA bitmap from KVM prep series to this series
>  - Make vsip_shadow as run-time percpu variable instead of compile-time
>  - Flush Guest TLBs on all Host CPUs whenever we run-out of VMIDs
>
> Changes since v2:
>  - Removed references of KVM_REQ_IRQ_PENDING from all patches
>  - Use kvm->srcu within in-kernel KVM run loop
>  - Added percpu vsip_shadow to track last value programmed in VSIP CSR
>  - Added comments about irqs_pending and irqs_pending_mask
>  - Used kvm_arch_vcpu_runnable() in-place-of kvm_riscv_vcpu_has_interrupt()
>    in system_opcode_insn()
>  - Removed unwanted smp_wmb() in kvm_riscv_stage2_vmid_update()
>  - Use kvm_flush_remote_tlbs() in kvm_riscv_stage2_vmid_update()
>  - Use READ_ONCE() in kvm_riscv_stage2_update_hgatp() for vmid
>
> Changes since v1:
>  - Fixed compile errors in building KVM RISC-V as module
>  - Removed unused kvm_riscv_halt_guest() and kvm_riscv_resume_guest()
>  - Set KVM_CAP_SYNC_MMU capability only after MMU notifiers are implemented
>  - Made vmid_version as unsigned long instead of atomic
>  - Renamed KVM_REQ_UPDATE_PGTBL to KVM_REQ_UPDATE_HGATP
>  - Renamed kvm_riscv_stage2_update_pgtbl() to kvm_riscv_stage2_update_hgatp()
>  - Configure HIDELEG and HEDELEG in kvm_arch_hardware_enable()
>  - Updated ONE_REG interface for CSR access to user-space
>  - Removed irqs_pending_lock and use atomic bitops instead
>  - Added separate patch for FP ONE_REG interface
>  - Added separate patch for updating MAINTAINERS file
>
> Anup Patel (13):
>   RISC-V: Add hypervisor extension related CSR defines
>   RISC-V: Add initial skeletal KVM support
>   RISC-V: KVM: Implement VCPU create, init and destroy functions
>   RISC-V: KVM: Implement VCPU interrupts and requests handling
>   RISC-V: KVM: Implement KVM_GET_ONE_REG/KVM_SET_ONE_REG ioctls
>   RISC-V: KVM: Implement VCPU world-switch
>   RISC-V: KVM: Handle MMIO exits for VCPU
>   RISC-V: KVM: Handle WFI exits for VCPU
>   RISC-V: KVM: Implement VMID allocator
>   RISC-V: KVM: Implement stage2 page table programming
>   RISC-V: KVM: Implement MMU notifiers
>   RISC-V: KVM: Document RISC-V specific parts of KVM API
>   RISC-V: KVM: Add MAINTAINERS entry
>
> Atish Patra (4):
>   RISC-V: KVM: Add timer functionality
>   RISC-V: KVM: FP lazy save/restore
>   RISC-V: KVM: Implement ONE REG interface for FP registers
>   RISC-V: KVM: Add SBI v0.1 support
>
>  Documentation/virt/kvm/api.rst          |  193 ++++-
>  MAINTAINERS                             |   11 +
>  arch/riscv/Kconfig                      |    1 +
>  arch/riscv/Makefile                     |    2 +
>  arch/riscv/include/asm/csr.h            |   89 ++
>  arch/riscv/include/asm/kvm_host.h       |  278 +++++++
>  arch/riscv/include/asm/kvm_types.h      |    7 +
>  arch/riscv/include/asm/kvm_vcpu_timer.h |   44 +
>  arch/riscv/include/asm/pgtable-bits.h   |    1 +
>  arch/riscv/include/uapi/asm/kvm.h       |  128 +++
>  arch/riscv/kernel/asm-offsets.c         |  156 ++++
>  arch/riscv/kvm/Kconfig                  |   36 +
>  arch/riscv/kvm/Makefile                 |   15 +
>  arch/riscv/kvm/main.c                   |  118 +++
>  arch/riscv/kvm/mmu.c                    |  860 +++++++++++++++++++
>  arch/riscv/kvm/tlb.S                    |   74 ++
>  arch/riscv/kvm/vcpu.c                   | 1012 +++++++++++++++++++++++
>  arch/riscv/kvm/vcpu_exit.c              |  701 ++++++++++++++++
>  arch/riscv/kvm/vcpu_sbi.c               |  173 ++++
>  arch/riscv/kvm/vcpu_switch.S            |  400 +++++++++
>  arch/riscv/kvm/vcpu_timer.c             |  225 +++++
>  arch/riscv/kvm/vm.c                     |   81 ++
>  arch/riscv/kvm/vmid.c                   |  120 +++
>  drivers/clocksource/timer-riscv.c       |    8 +
>  include/clocksource/timer-riscv.h       |   16 +
>  include/uapi/linux/kvm.h                |    8 +
>  26 files changed, 4748 insertions(+), 9 deletions(-)
>  create mode 100644 arch/riscv/include/asm/kvm_host.h
>  create mode 100644 arch/riscv/include/asm/kvm_types.h
>  create mode 100644 arch/riscv/include/asm/kvm_vcpu_timer.h
>  create mode 100644 arch/riscv/include/uapi/asm/kvm.h
>  create mode 100644 arch/riscv/kvm/Kconfig
>  create mode 100644 arch/riscv/kvm/Makefile
>  create mode 100644 arch/riscv/kvm/main.c
>  create mode 100644 arch/riscv/kvm/mmu.c
>  create mode 100644 arch/riscv/kvm/tlb.S
>  create mode 100644 arch/riscv/kvm/vcpu.c
>  create mode 100644 arch/riscv/kvm/vcpu_exit.c
>  create mode 100644 arch/riscv/kvm/vcpu_sbi.c
>  create mode 100644 arch/riscv/kvm/vcpu_switch.S
>  create mode 100644 arch/riscv/kvm/vcpu_timer.c
>  create mode 100644 arch/riscv/kvm/vm.c
>  create mode 100644 arch/riscv/kvm/vmid.c
>  create mode 100644 include/clocksource/timer-riscv.h
