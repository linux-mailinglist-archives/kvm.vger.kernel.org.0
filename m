Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FAD01B5FBB
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 17:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729327AbgDWPnW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 11:43:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729072AbgDWPnU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Apr 2020 11:43:20 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10453C09B040
        for <kvm@vger.kernel.org>; Thu, 23 Apr 2020 08:43:20 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id c21so1678564plz.4
        for <kvm@vger.kernel.org>; Thu, 23 Apr 2020 08:43:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:subject:in-reply-to:cc:from:to:message-id:mime-version
         :content-transfer-encoding;
        bh=naiEjarGJmHy037G60NXRczIZuNXv0o/OKI14B0jZVg=;
        b=IhwBsvqCPzzzp1E+oRVvDL+D1p6d+q73df1F/elc1dKECwbpqSyjts4p+GfDM4PH0q
         F+LRndqkuPjILRlcC44Zw2kxXMlaYVQW5M9lueQu1BFNcoXV8U0232n4Mq0Lqe6c5Vha
         SJqYIdz9EHMbCUgvS2TJoawUZuonBXMRe2x3VcKBS1G27M0GS4XnH31Ra2cLv1b84TtN
         VyVDhZDvEFj39buQ7I9DhJj/+/fM44y1H/f8wNYSmyPft216pLRibRyk8H8vhtJNHna0
         0W5Ktq/ge/e+tIzrWpFvlncmyFhO9k30J2R2Ux4SD0rJ4xpCBNG5OM8n8ndn2j6ki7l+
         kLBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
         :mime-version:content-transfer-encoding;
        bh=naiEjarGJmHy037G60NXRczIZuNXv0o/OKI14B0jZVg=;
        b=riga1pPjWn9pWKGp6q4U9bri96e4lr2f4PbYEyS8NYu19oH/1L5I++0b0rwtmsQjRS
         reiFiRlBE/EGmiYMQycl/+5xqZip8YYyJ4FCrgEunskRq/sGCdxIp8cvP+l1HcSuy3hK
         +HWhJ8KbEB8DqZ15gb2nCvVkw2BFovJKngm+RI2TspEH25dI0OIWWUl6VauB4cXIrlAY
         76nvhWMuQkoor57ccBNJJ3mY6uzR/nkYJ/y3cjjEQd2W8qQTUaHuQA58Cst5/aRP6im0
         SZly3tGU3+/9hhKC3gK2US8GRdmNr8hXR3SFajRuqcSTKUw98srzmrGd1wUsWv9UUj21
         GAag==
X-Gm-Message-State: AGi0Pua7ZyOCI2a5IN9imggJhY28n22hEEeYUay8X2fBtsqBqAoZMJS1
        PP7qmU0sh2phK51t/dfM+j+35w==
X-Google-Smtp-Source: APiQypIBgt3Ye6Uizvw379STfEYPTggCrYbyxj+uJi6i6O9VgGeXWIU7StKFAdfK1F6UiyMb033pVQ==
X-Received: by 2002:a17:90a:2450:: with SMTP id h74mr1303260pje.57.1587656599117;
        Thu, 23 Apr 2020 08:43:19 -0700 (PDT)
Received: from localhost (76-210-143-223.lightspeed.sntcca.sbcglobal.net. [76.210.143.223])
        by smtp.gmail.com with ESMTPSA id 23sm2730724pjb.11.2020.04.23.08.43.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2020 08:43:18 -0700 (PDT)
Date:   Thu, 23 Apr 2020 08:43:18 -0700 (PDT)
X-Google-Original-Date: Thu, 23 Apr 2020 08:42:24 PDT (-0700)
Subject:     Re: [PATCH v11 00/20] KVM RISC-V Support
In-Reply-To: <CAAhSdy32E_aTPqij3Lgs3mekMWcHw0VfXSwFc=0K8j+GrC+Kug@mail.gmail.com>
CC:     Paul Walmsley <paul.walmsley@sifive.com>, aou@eecs.berkeley.edu,
        pbonzini@redhat.com, rkrcmar@redhat.com, graf@amazon.com,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@lst.de>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <Anup.Patel@wdc.com>
From:   Palmer Dabbelt <palmerdabbelt@google.com>
To:     anup@brainfault.org
Message-ID: <mhng-fc3ce6fc-01a4-45b7-92c5-370d2d6a0f9e@palmerdabbelt-glaptop1>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 17 Apr 2020 05:45:31 PDT (-0700), anup@brainfault.org wrote:
> Hi Palmer,
>
> On Fri, Mar 13, 2020 at 1:22 PM Anup Patel <anup.patel@wdc.com> wrote:
>>
>> This series adds initial KVM RISC-V support. Currently, we are able to boot
>> RISC-V 64bit Linux Guests with multiple VCPUs.
>>
>> Few key aspects of KVM RISC-V added by this series are:
>> 1. Minimal possible KVM world-switch which touches only GPRs and few CSRs.
>> 2. Full Guest/VM switch is done via vcpu_get/vcpu_put infrastructure.
>> 3. KVM ONE_REG interface for VCPU register access from user-space.
>> 4. PLIC emulation is done in user-space.
>> 5. Timer and IPI emuation is done in-kernel.
>> 6. MMU notifiers supported.
>> 7. FP lazy save/restore supported.
>> 8. SBI v0.1 emulation for KVM Guest available.
>> 9. Forward unhandled SBI calls to KVM userspace.
>> 10. Hugepage support for Guest/VM
>>
>> Here's a brief TODO list which we will work upon after this series:
>> 1. SBI v0.2 emulation in-kernel
>> 2. SBI v0.2 hart state management emulation in-kernel
>> 3. In-kernel PLIC emulation
>> 4. ..... and more .....
>>
>> This series can be found in riscv_kvm_v11 branch at:
>> https//github.com/avpatel/linux.git
>>
>> Our work-in-progress KVMTOOL RISC-V port can be found in riscv_v2 branch
>> at: https//github.com/avpatel/kvmtool.git
>>
>> The QEMU RISC-V hypervisor emulation is done by Alistair and is available
>> in mainline/anup/riscv-hyp-ext-v0.5.3 branch at:
>> https://github.com/kvm-riscv/qemu.git
>>
>> To play around with KVM RISC-V, refer KVM RISC-V wiki at:
>> https://github.com/kvm-riscv/howto/wiki
>> https://github.com/kvm-riscv/howto/wiki/KVM-RISCV64-on-QEMU
>>
>> Changes since v10:
>>  - Rebased patches on Linux-5.6-rc5
>>  - Reduce RISCV_ISA_EXT_MAX from 256 to 64
>>  - Separate PATCH for removing N-extension related defines
>>  - Added comments as requested by Palmer
>>  - Fixed HIDELEG CSR programming
>>
>> Changes since v9:
>>  - Squash PATCH19 and PATCH20 into PATCH5
>>  - Squash PATCH18 into PATCH11
>>  - Squash PATCH17 into PATCH16
>>  - Added ONE_REG interface for VCPU timer in PATCH13
>>  - Use HTIMEDELTA for VCPU timer in PATCH13
>>  - Updated KVM RISC-V mailing list in MAINTAINERS entry
>>  - Update KVM kconfig option to depend on RISCV_SBI and MMU
>>  - Check for SBI v0.2 and SBI v0.2 RFENCE extension at boot-time
>>  - Use SBI v0.2 RFENCE extension in VMID implementation
>>  - Use SBI v0.2 RFENCE extension in Stage2 MMU implementation
>>  - Use SBI v0.2 RFENCE extension in SBI implementation
>>  - Moved to RISC-V Hypervisor v0.5 draft spec
>>  - Updated Documentation/virt/kvm/api.txt for timer ONE_REG interface
>>  - Rebased patches on Linux-5.5-rc3
>>
>> Changes since v8:
>>  - Rebased series on Linux-5.4-rc3 and Atish's SBI v0.2 patches
>>  - Use HRTIMER_MODE_REL instead of HRTIMER_MODE_ABS in timer emulation
>>  - Fixed kvm_riscv_stage2_map() to handle hugepages
>>  - Added patch to forward unhandled SBI calls to user-space
>>  - Added patch for iterative/recursive stage2 page table programming
>>  - Added patch to remove per-CPU vsip_shadow variable
>>  - Added patch to fix race-condition in kvm_riscv_vcpu_sync_interrupts()
>>
>> Changes since v7:
>> - Rebased series on Linux-5.4-rc1 and Atish's SBI v0.2 patches
>> - Removed PATCH1, PATCH3, and PATCH20 because these already merged
>> - Use kernel doc style comments for ISA bitmap functions
>> - Don't parse X, Y, and Z extension in riscv_fill_hwcap() because it will
>>   be added in-future
>> - Mark KVM RISC-V kconfig option as EXPERIMENTAL
>> - Typo fix in commit description of PATCH6 of v7 series
>> - Use separate structs for CORE and CSR registers of ONE_REG interface
>> - Explicitly include asm/sbi.h in kvm/vcpu_sbi.c
>> - Removed implicit switch-case fall-through in kvm_riscv_vcpu_exit()
>> - No need to set VSSTATUS.MXR bit in kvm_riscv_vcpu_unpriv_read()
>> - Removed register for instruction length in kvm_riscv_vcpu_unpriv_read()
>> - Added defines for checking/decoding instruction length
>> - Added separate patch to forward unhandled SBI calls to userspace tool
>>
>> Changes since v6:
>> - Rebased patches on Linux-5.3-rc7
>> - Added "return_handled" in struct kvm_mmio_decode to ensure that
>>   kvm_riscv_vcpu_mmio_return() updates SEPC only once
>> - Removed trap_stval parameter from kvm_riscv_vcpu_unpriv_read()
>> - Updated git repo URL in MAINTAINERS entry
>>
>> Changes since v5:
>> - Renamed KVM_REG_RISCV_CONFIG_TIMEBASE register to
>>   KVM_REG_RISCV_CONFIG_TBFREQ register in ONE_REG interface
>> - Update SPEC in kvm_riscv_vcpu_mmio_return() for MMIO exits
>> - Use switch case instead of illegal instruction opcode table for simplicity
>> - Improve comments in stage2_remote_tlb_flush() for a potential remote TLB
>>   flush optimization
>> - Handle all unsupported SBI calls in default case of
>>   kvm_riscv_vcpu_sbi_ecall() function
>> - Fixed kvm_riscv_vcpu_sync_interrupts() for software interrupts
>> - Improved unprivilege reads to handle traps due to Guest stage1 page table
>> - Added separate patch to document RISC-V specific things in
>>   Documentation/virt/kvm/api.txt
>>
>> Changes since v4:
>> - Rebased patches on Linux-5.3-rc5
>> - Added Paolo's Acked-by and Reviewed-by
>> - Updated mailing list in MAINTAINERS entry
>>
>> Changes since v3:
>> - Moved patch for ISA bitmap from KVM prep series to this series
>> - Make vsip_shadow as run-time percpu variable instead of compile-time
>> - Flush Guest TLBs on all Host CPUs whenever we run-out of VMIDs
>>
>> Changes since v2:
>> - Removed references of KVM_REQ_IRQ_PENDING from all patches
>> - Use kvm->srcu within in-kernel KVM run loop
>> - Added percpu vsip_shadow to track last value programmed in VSIP CSR
>> - Added comments about irqs_pending and irqs_pending_mask
>> - Used kvm_arch_vcpu_runnable() in-place-of kvm_riscv_vcpu_has_interrupt()
>>   in system_opcode_insn()
>> - Removed unwanted smp_wmb() in kvm_riscv_stage2_vmid_update()
>> - Use kvm_flush_remote_tlbs() in kvm_riscv_stage2_vmid_update()
>> - Use READ_ONCE() in kvm_riscv_stage2_update_hgatp() for vmid
>>
>> Changes since v1:
>> - Fixed compile errors in building KVM RISC-V as module
>> - Removed unused kvm_riscv_halt_guest() and kvm_riscv_resume_guest()
>> - Set KVM_CAP_SYNC_MMU capability only after MMU notifiers are implemented
>> - Made vmid_version as unsigned long instead of atomic
>> - Renamed KVM_REQ_UPDATE_PGTBL to KVM_REQ_UPDATE_HGATP
>> - Renamed kvm_riscv_stage2_update_pgtbl() to kvm_riscv_stage2_update_hgatp()
>> - Configure HIDELEG and HEDELEG in kvm_arch_hardware_enable()
>> - Updated ONE_REG interface for CSR access to user-space
>> - Removed irqs_pending_lock and use atomic bitops instead
>> - Added separate patch for FP ONE_REG interface
>> - Added separate patch for updating MAINTAINERS file
>>
>> Anup Patel (16):
>>   RISC-V: Export riscv_cpuid_to_hartid_mask() API
>>   RISC-V: Add bitmap reprensenting ISA features common across CPUs
>>   RISC-V: Remove N-extension related defines
>>   RISC-V: Add hypervisor extension related CSR defines
>>   RISC-V: Add initial skeletal KVM support
>>   RISC-V: KVM: Implement VCPU create, init and destroy functions
>>   RISC-V: KVM: Implement VCPU interrupts and requests handling
>>   RISC-V: KVM: Implement KVM_GET_ONE_REG/KVM_SET_ONE_REG ioctls
>>   RISC-V: KVM: Implement VCPU world-switch
>>   RISC-V: KVM: Handle MMIO exits for VCPU
>>   RISC-V: KVM: Handle WFI exits for VCPU
>>   RISC-V: KVM: Implement VMID allocator
>>   RISC-V: KVM: Implement stage2 page table programming
>>   RISC-V: KVM: Implement MMU notifiers
>>   RISC-V: KVM: Document RISC-V specific parts of KVM API
>>   RISC-V: KVM: Add MAINTAINERS entry
>>
>> Atish Patra (4):
>>   RISC-V: KVM: Add timer functionality
>>   RISC-V: KVM: FP lazy save/restore
>>   RISC-V: KVM: Implement ONE REG interface for FP registers
>>   RISC-V: KVM: Add SBI v0.1 support
>>
>>  Documentation/virt/kvm/api.rst          | 193 ++++-
>>  MAINTAINERS                             |  11 +
>>  arch/riscv/Kconfig                      |   2 +
>>  arch/riscv/Makefile                     |   2 +
>>  arch/riscv/include/asm/csr.h            |  78 +-
>>  arch/riscv/include/asm/hwcap.h          |  22 +
>>  arch/riscv/include/asm/kvm_host.h       | 264 +++++++
>>  arch/riscv/include/asm/kvm_vcpu_timer.h |  44 ++
>>  arch/riscv/include/asm/pgtable-bits.h   |   1 +
>>  arch/riscv/include/uapi/asm/kvm.h       | 127 +++
>>  arch/riscv/kernel/asm-offsets.c         | 148 ++++
>>  arch/riscv/kernel/cpufeature.c          |  83 +-
>>  arch/riscv/kernel/smp.c                 |   2 +
>>  arch/riscv/kvm/Kconfig                  |  34 +
>>  arch/riscv/kvm/Makefile                 |  14 +
>>  arch/riscv/kvm/main.c                   |  97 +++
>>  arch/riscv/kvm/mmu.c                    | 762 ++++++++++++++++++
>>  arch/riscv/kvm/tlb.S                    |  43 +
>>  arch/riscv/kvm/vcpu.c                   | 997 ++++++++++++++++++++++++
>>  arch/riscv/kvm/vcpu_exit.c              | 639 +++++++++++++++
>>  arch/riscv/kvm/vcpu_sbi.c               | 171 ++++
>>  arch/riscv/kvm/vcpu_switch.S            | 382 +++++++++
>>  arch/riscv/kvm/vcpu_timer.c             | 225 ++++++
>>  arch/riscv/kvm/vm.c                     |  86 ++
>>  arch/riscv/kvm/vmid.c                   | 120 +++
>>  drivers/clocksource/timer-riscv.c       |   8 +
>>  include/clocksource/timer-riscv.h       |  16 +
>>  include/uapi/linux/kvm.h                |   8 +
>>  28 files changed, 4564 insertions(+), 15 deletions(-)
>>  create mode 100644 arch/riscv/include/asm/kvm_host.h
>>  create mode 100644 arch/riscv/include/asm/kvm_vcpu_timer.h
>>  create mode 100644 arch/riscv/include/uapi/asm/kvm.h
>>  create mode 100644 arch/riscv/kvm/Kconfig
>>  create mode 100644 arch/riscv/kvm/Makefile
>>  create mode 100644 arch/riscv/kvm/main.c
>>  create mode 100644 arch/riscv/kvm/mmu.c
>>  create mode 100644 arch/riscv/kvm/tlb.S
>>  create mode 100644 arch/riscv/kvm/vcpu.c
>>  create mode 100644 arch/riscv/kvm/vcpu_exit.c
>>  create mode 100644 arch/riscv/kvm/vcpu_sbi.c
>>  create mode 100644 arch/riscv/kvm/vcpu_switch.S
>>  create mode 100644 arch/riscv/kvm/vcpu_timer.c
>>  create mode 100644 arch/riscv/kvm/vm.c
>>  create mode 100644 arch/riscv/kvm/vmid.c
>>  create mode 100644 include/clocksource/timer-riscv.h
>>
>> --
>> 2.17.1
>>
>
> Can you please consider PATCH1, PATCH2, and PATCH3 of
> this series for Linux-5.7-rcX ??

Sure.  Can you send them as their own patch set, based on a recent RC?
