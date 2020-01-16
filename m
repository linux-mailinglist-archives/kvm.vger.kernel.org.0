Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7919E13D1AC
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2020 02:45:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730302AbgAPBpS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jan 2020 20:45:18 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:39867 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730200AbgAPBpS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jan 2020 20:45:18 -0500
Received: by mail-pf1-f195.google.com with SMTP id q10so9399911pfs.6
        for <kvm@vger.kernel.org>; Wed, 15 Jan 2020 17:45:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:subject:cc:to:in-reply-to:references:message-id
         :mime-version:content-transfer-encoding;
        bh=iBfKznrjDfOXVEYb5TeuwJiU2hNbcYzYfdXywlkBHWE=;
        b=VTF8/HGy532e2jsfHi5wHrFQJga1kXe1mNKkVHcuRdNroutmqmg6CnwVxMxnOG6bXK
         LTWz2QPox3RYEFm/KX4BU7Cy94aJc+80TQ6UfmfxfWE9Ogt2FePMdUpHno+v9MkuwDN9
         1wtdFQa1qdkGu1LgnogYwF1sa4SZeygEGODfXgeLzTX6ambfoQASDwaj15XhXcbonSoF
         zKf+02nrh+KPrEwJ+95sogjaWYlt4h0Quc2j57+UpJDl1luCyxBHpTDhyw+YWk93KXCh
         PP3lsnmN7BqReUpUpHc13u+y8S8t/w6pO5xIzU0xNXQGiOyrJa6U/7NgA56E+OBWgMGx
         J2xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:cc:to:in-reply-to:references
         :message-id:mime-version:content-transfer-encoding;
        bh=iBfKznrjDfOXVEYb5TeuwJiU2hNbcYzYfdXywlkBHWE=;
        b=ZFowRdrePf1hUbdM8Rd5TZ8jS2W7V3a9c/r1I+W376pe4YNqor6WWuGTOTDQIIxmaY
         OwopIm7FKNsroNepKCphZ3gw9l2VmN69FfVkjGMjpsifTPo3Kk8TN1IYkl7yFyyITUYx
         rNPx2ZBldVFn8yI8dmXJdNQhyTPS7HJ4O7mfw7BEGdaunAZ65Qx0oiiIcZ7l0BfXwkyL
         jLHliozwLdo+UNZXf8yJDKuubxQAguvri4uybDl4/xgW8LNv4YMEGtU8wYW+SuvofOr4
         3UwBe52q6xbesk7q4/9vZcdho4njP9nlcKXMml0MtZ14Q81OZR7JCCafzlD2lSz2Amqa
         2EuQ==
X-Gm-Message-State: APjAAAUBy4zB3FfNSQMfdOV5vOYpr6FWS45KPgJhF8kcUjMek3RX/GVx
        dL/elNQRLgCe9MBIxEMQ/rsObQ==
X-Google-Smtp-Source: APXvYqz+pDN10QbvivbpkovIgcyt2Ic3ZJAfabaBFDcr8AyvVOffqG68IPLsLyEEEwdXcEmKCrjk9w==
X-Received: by 2002:aa7:982d:: with SMTP id q13mr35086384pfl.152.1579139117127;
        Wed, 15 Jan 2020 17:45:17 -0800 (PST)
Received: from localhost ([2620:0:1000:2514:7f69:cd98:a2a2:a03d])
        by smtp.gmail.com with ESMTPSA id ep12sm1085581pjb.7.2020.01.15.17.45.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2020 17:45:16 -0800 (PST)
Date:   Wed, 15 Jan 2020 17:45:16 -0800 (PST)
X-Google-Original-Date: Wed, 15 Jan 2020 17:45:03 PST (-0800)
From:   Palmer Dabbelt <palmerdabbelt@google.com>
X-Google-Original-From: Palmer Dabbelt <palmer@dabbelt.com>
Subject:     Re: [PATCH v10 00/19] KVM RISC-V Support
CC:     Paul Walmsley <paul.walmsley@sifive.com>, aou@eecs.berkeley.edu,
        pbonzini@redhat.com, rkrcmar@redhat.com, graf@amazon.com,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@lst.de>, anup@brainfault.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        Anup Patel <Anup.Patel@wdc.com>
To:     Anup Patel <Anup.Patel@wdc.com>
In-Reply-To: <20191223113443.68969-1-anup.patel@wdc.com>
References: <20191223113443.68969-1-anup.patel@wdc.com>
Message-ID: <mhng-b9472d3d-a2fc-4616-ba52-10346d72c640@palmerdabbelt-glaptop>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 23 Dec 2019 03:35:10 PST (-0800), Anup Patel wrote:
> This series adds initial KVM RISC-V support. Currently, we are able to boot
> RISC-V 64bit Linux Guests with multiple VCPUs.

Thanks for doing this.  I haven't had time to take a real look at the patch
series yet, but it's at the top of my inbox now so I'll try to take a look this
week.

>
> Few key aspects of KVM RISC-V added by this series are:
> 1. Minimal possible KVM world-switch which touches only GPRs and few CSRs.
> 2. Full Guest/VM switch is done via vcpu_get/vcpu_put infrastructure.
> 3. KVM ONE_REG interface for VCPU register access from user-space.
> 4. PLIC emulation is done in user-space.
> 5. Timer and IPI emuation is done in-kernel.
> 6. MMU notifiers supported.
> 7. FP lazy save/restore supported.
> 8. SBI v0.1 emulation for KVM Guest available.
> 9. Forward unhandled SBI calls to KVM userspace.
> 10. Hugepage support for Guest/VM
>
> Here's a brief TODO list which we will work upon after this series:
> 1. SBI v0.2 emulation in-kernel
> 2. SBI v0.2 hart state management emulation in-kernel
> 3. In-kernel PLIC emulation
> 4. ..... and more .....
>
> This series can be found in riscv_kvm_v10 branch at:
> https//github.com/avpatel/linux.git
>
> Our work-in-progress KVMTOOL RISC-V port can be found in riscv_v1 branch
> at: https//github.com/avpatel/kvmtool.git
>
> The QEMU RISC-V hypervisor emulation is done by Alistair and is available
> in mainline/alistair/riscv-hyp-ext-v0.5.1 branch at:
> https://github.com/kvm-riscv/qemu.git
>
> To play around with KVM RISC-V, refer KVM RISC-V wiki at:
> https://github.com/kvm-riscv/howto/wiki
> https://github.com/kvm-riscv/howto/wiki/KVM-RISCV64-on-QEMU
>
> Changes since v9:
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
>  - Rebased patches on Linux-5.5-rc3
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
> - Rebased series on Linux-5.4-rc1 and Atish's SBI v0.2 patches
> - Removed PATCH1, PATCH3, and PATCH20 because these already merged
> - Use kernel doc style comments for ISA bitmap functions
> - Don't parse X, Y, and Z extension in riscv_fill_hwcap() because it will
>   be added in-future
> - Mark KVM RISC-V kconfig option as EXPERIMENTAL
> - Typo fix in commit description of PATCH6 of v7 series
> - Use separate structs for CORE and CSR registers of ONE_REG interface
> - Explicitly include asm/sbi.h in kvm/vcpu_sbi.c
> - Removed implicit switch-case fall-through in kvm_riscv_vcpu_exit()
> - No need to set VSSTATUS.MXR bit in kvm_riscv_vcpu_unpriv_read()
> - Removed register for instruction length in kvm_riscv_vcpu_unpriv_read()
> - Added defines for checking/decoding instruction length
> - Added separate patch to forward unhandled SBI calls to userspace tool
>
> Changes since v6:
> - Rebased patches on Linux-5.3-rc7
> - Added "return_handled" in struct kvm_mmio_decode to ensure that
>   kvm_riscv_vcpu_mmio_return() updates SEPC only once
> - Removed trap_stval parameter from kvm_riscv_vcpu_unpriv_read()
> - Updated git repo URL in MAINTAINERS entry
>
> Changes since v5:
> - Renamed KVM_REG_RISCV_CONFIG_TIMEBASE register to
>   KVM_REG_RISCV_CONFIG_TBFREQ register in ONE_REG interface
> - Update SPEC in kvm_riscv_vcpu_mmio_return() for MMIO exits
> - Use switch case instead of illegal instruction opcode table for simplicity
> - Improve comments in stage2_remote_tlb_flush() for a potential remote TLB
>   flush optimization
> - Handle all unsupported SBI calls in default case of
>   kvm_riscv_vcpu_sbi_ecall() function
> - Fixed kvm_riscv_vcpu_sync_interrupts() for software interrupts
> - Improved unprivilege reads to handle traps due to Guest stage1 page table
> - Added separate patch to document RISC-V specific things in
>   Documentation/virt/kvm/api.txt
>
> Changes since v4:
> - Rebased patches on Linux-5.3-rc5
> - Added Paolo's Acked-by and Reviewed-by
> - Updated mailing list in MAINTAINERS entry
>
> Changes since v3:
> - Moved patch for ISA bitmap from KVM prep series to this series
> - Make vsip_shadow as run-time percpu variable instead of compile-time
> - Flush Guest TLBs on all Host CPUs whenever we run-out of VMIDs
>
> Changes since v2:
> - Removed references of KVM_REQ_IRQ_PENDING from all patches
> - Use kvm->srcu within in-kernel KVM run loop
> - Added percpu vsip_shadow to track last value programmed in VSIP CSR
> - Added comments about irqs_pending and irqs_pending_mask
> - Used kvm_arch_vcpu_runnable() in-place-of kvm_riscv_vcpu_has_interrupt()
>   in system_opcode_insn()
> - Removed unwanted smp_wmb() in kvm_riscv_stage2_vmid_update()
> - Use kvm_flush_remote_tlbs() in kvm_riscv_stage2_vmid_update()
> - Use READ_ONCE() in kvm_riscv_stage2_update_hgatp() for vmid
>
> Changes since v1:
> - Fixed compile errors in building KVM RISC-V as module
> - Removed unused kvm_riscv_halt_guest() and kvm_riscv_resume_guest()
> - Set KVM_CAP_SYNC_MMU capability only after MMU notifiers are implemented
> - Made vmid_version as unsigned long instead of atomic
> - Renamed KVM_REQ_UPDATE_PGTBL to KVM_REQ_UPDATE_HGATP
> - Renamed kvm_riscv_stage2_update_pgtbl() to kvm_riscv_stage2_update_hgatp()
> - Configure HIDELEG and HEDELEG in kvm_arch_hardware_enable()
> - Updated ONE_REG interface for CSR access to user-space
> - Removed irqs_pending_lock and use atomic bitops instead
> - Added separate patch for FP ONE_REG interface
> - Added separate patch for updating MAINTAINERS file
>
> Anup Patel (15):
>   RISC-V: Export riscv_cpuid_to_hartid_mask() API
>   RISC-V: Add bitmap reprensenting ISA features common across CPUs
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
>   RISC-V: KVM: Document RISC-V specific parts of KVM API.
>   RISC-V: KVM: Add MAINTAINERS entry
>
> Atish Patra (4):
>   RISC-V: KVM: Add timer functionality
>   RISC-V: KVM: FP lazy save/restore
>   RISC-V: KVM: Implement ONE REG interface for FP registers
>   RISC-V: KVM: Add SBI v0.1 support
>
>  Documentation/virt/kvm/api.txt          |  169 +++-
>  MAINTAINERS                             |   11 +
>  arch/riscv/Kconfig                      |    2 +
>  arch/riscv/Makefile                     |    2 +
>  arch/riscv/include/asm/csr.h            |   78 +-
>  arch/riscv/include/asm/hwcap.h          |   22 +
>  arch/riscv/include/asm/kvm_host.h       |  264 ++++++
>  arch/riscv/include/asm/kvm_vcpu_timer.h |   44 +
>  arch/riscv/include/asm/pgtable-bits.h   |    1 +
>  arch/riscv/include/uapi/asm/kvm.h       |  127 +++
>  arch/riscv/kernel/asm-offsets.c         |  148 ++++
>  arch/riscv/kernel/cpufeature.c          |   83 +-
>  arch/riscv/kernel/smp.c                 |    2 +
>  arch/riscv/kvm/Kconfig                  |   34 +
>  arch/riscv/kvm/Makefile                 |   14 +
>  arch/riscv/kvm/main.c                   |   97 +++
>  arch/riscv/kvm/mmu.c                    |  762 +++++++++++++++++
>  arch/riscv/kvm/tlb.S                    |   43 +
>  arch/riscv/kvm/vcpu.c                   | 1013 +++++++++++++++++++++++
>  arch/riscv/kvm/vcpu_exit.c              |  639 ++++++++++++++
>  arch/riscv/kvm/vcpu_sbi.c               |  171 ++++
>  arch/riscv/kvm/vcpu_switch.S            |  382 +++++++++
>  arch/riscv/kvm/vcpu_timer.c             |  225 +++++
>  arch/riscv/kvm/vm.c                     |   86 ++
>  arch/riscv/kvm/vmid.c                   |  120 +++
>  drivers/clocksource/timer-riscv.c       |    8 +
>  include/clocksource/timer-riscv.h       |   16 +
>  include/uapi/linux/kvm.h                |    8 +
>  28 files changed, 4558 insertions(+), 13 deletions(-)
>  create mode 100644 arch/riscv/include/asm/kvm_host.h
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
>
> -- 
> 2.17.1
