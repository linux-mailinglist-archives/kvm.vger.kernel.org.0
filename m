Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA6C38F5F0
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 00:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbhEXW7E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 18:59:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbhEXW7D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 May 2021 18:59:03 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1056C061756
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 15:57:33 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id t11so15743648pjm.0
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 15:57:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:subject:in-reply-to:cc:from:to:message-id:mime-version
         :content-transfer-encoding;
        bh=llD08iVcRtpvzEEXXKZ2+uHTvLG8FPV8/JzQyEqJI60=;
        b=hDjr/jgiYK4djpiM9K5gHUo9pEBgdlQMvY/ujCJvjAbx59PsbLQEHAUGIp9C/ZgaqJ
         ZDO8kYPnLoNanUZ82H3OSQdhpKsxt2Da45hanJw8x+8EuqHmjXzvslCkhykbC8s+XLhE
         U4EqOAc8Ng+JnTHPz0NkOxldf6Cj5P/PTPFWsM0GNkJlbyVVSL/e9PHA6RjKerlz95Tz
         Zj9/BerIz6mYmdE5DnHas2iYaaFL9dDmsLhoDZYDV8XeuAJoewgv+A5Cfnxvxz4d9dx5
         jERduoW5WjV3GPCuENdBOVIWbE/m6s0zjMfYSQkGy1jx+BOQNL5aY4bqOLwC053vSsBt
         XTTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
         :mime-version:content-transfer-encoding;
        bh=llD08iVcRtpvzEEXXKZ2+uHTvLG8FPV8/JzQyEqJI60=;
        b=bAvxRoSzjHdz2J4Q4x/pJHjf5H2MPpTywKqgTJT5U+dFYp4AYUiPdNQR9MB+biuGJt
         lAVPi+tUfZT9+7jCMP3vz2E3ku3CyWT3sanqvsFj9YmAUwgO8ketjHxZ8WXVKcWbFLhG
         /JYQaeus5zF9CqllsuOcJGoSsAZkfm2V3TisfMTPhLvdnQpuWnyrOxsuoKYVvFApEfmv
         oQ2wnydXrdR/ouD4EhuP7Svw9YiY89loGMvANL/rwRO6gumtIDZijWs5Dl7iWoUM7saJ
         MdhklmnBGsjGC7Aw7WRwZ69h5OhkI8IYw7MIuLCUTzFckl1Mixd/isHN+AOjt6bfVi+h
         Wn3A==
X-Gm-Message-State: AOAM532cyChwJ1ZDC4RiCoeW95+msZ1tsY2CV7A/FESbWZ/S02Ncw7MS
        BvXywP4LRuU+YtwTuX/Kr/f7+g==
X-Google-Smtp-Source: ABdhPJzTQFm8XEEcVofXtcxG2lH39kstQx7aSbDEiSPXbi7r/FQLNRgb5Ot4xFK5J9kUkvx6tr0BuQ==
X-Received: by 2002:a17:90a:ab96:: with SMTP id n22mr27231450pjq.28.1621897052787;
        Mon, 24 May 2021 15:57:32 -0700 (PDT)
Received: from localhost (76-210-143-223.lightspeed.sntcca.sbcglobal.net. [76.210.143.223])
        by smtp.gmail.com with ESMTPSA id h36sm12784528pgh.63.2021.05.24.15.57.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 15:57:32 -0700 (PDT)
Date:   Mon, 24 May 2021 15:57:32 -0700 (PDT)
X-Google-Original-Date: Mon, 24 May 2021 15:57:29 PDT (-0700)
Subject:     Re: [PATCH v18 00/18] KVM RISC-V Support
In-Reply-To: <CAJF2gTSSHba78A3KWjUVV9241r63+M4G=VeDpL8VGPjGKzssnA@mail.gmail.com>
CC:     Anup Patel <Anup.Patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        aou@eecs.berkeley.edu, pbonzini@redhat.com, corbet@lwn.net,
        Greg KH <gregkh@linuxfoundation.org>, graf@amazon.com,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>, anup@brainfault.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-staging@lists.linux.dev
From:   Palmer Dabbelt <palmerdabbelt@google.com>
To:     guoren@kernel.org
Message-ID: <mhng-b093a5aa-ff9d-437f-a10b-47558f182639@palmerdabbelt-glaptop>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 24 May 2021 00:09:45 PDT (-0700), guoren@kernel.org wrote:
> Thx Anup,
>
> Tested-by: Guo Ren <guoren@kernel.org> (Just on qemu-rv64)
>
> I'm following your KVM patchset and it's a great job for riscv
> H-extension. I think hardware companies hope Linux KVM ready first
> before the real chip. That means we can ensure the hardware could run
> mainline linux.

I understand that it would be wonderful for hardware vendors to have a 
guarantee that their hardware will be supported by the software 
ecosystem, but that's not what we're talking about here.  Specifically, 
the proposal for this code is to track the latest draft extension which 
would specifically leave vendors who implement the current draft out in 
the cold was something to change.  In practice that is the only way to 
move forward with any draft extension that doesn't have hardware 
available, as the software RISC-V implementations rapidly deprecate 
draft extensions and without a way to test our code it is destined to 
bit rot.

If vendors want to make sure their hardware is supported then the best 
way to do that is to make sure specifications get ratified in a timely 
fashion that describe the behavior required from their products.  That 
way we have an agreed upon interface that vendors can implement and 
software can rely on.  I understand that a lot of people are frustrated 
with the pace of that process when it comes to the H extension, but 
circumventing that process doesn't fix the fundamental problem.  If 
there really are products out there that people can't build because the 
H extension isn't upstream then we need to have a serious discussion 
about those, but without something specific to discuss this is just 
going to devolve into speculation which isn't a good use of time.

I can't find any hardware that implements the draft H extension, at 
least via poking around on Google and in my email.  I'm very hesitant to 
talk about private vendor roadmaps in public, as that's getting way too 
close to my day job, but I've yet to have a vendor raise this as an 
issue to me privately and I do try my best to make sure to talk to the 
RISC-V hardware vendors whenever possible (though I try to stick to 
public roadmaps there, to avoid issues around discussions like this and 
conflicts with work).  Anup is clearly in a much more privileged 
position than I am here, given that he has real hardware and is able to 
allude to vendor roadmaps that I can't find in public, but until we can 
all get on the same page about that it's going to be difficult to have a 
reasonable discussion -- if we all have different information we're 
naturally going to arrive at different conclusions, which IMO is why 
this argument just keeps coming up.  It's totally possible I'm just 
missing something here, in which case I'd love to be corrected as we can 
be having a very different discussion.

I certainly hope that vendors understand that we're willing to work with 
them when it comes to making the software run on their hardware.  I've 
always tried to be quite explicit that's our goal here, both by just 
saying so and by demonstrating that we're willing to take code that 
exhibits behavior not specified by the specifications but that is 
necessary to make real hardware work.  There's always a balance here and 
I can't commit to making every chip with a RISC-V logo on it run Linux 
well, as there will always be some implementations that are just 
impossible to run real code on, but I'm always willing to do whatever I 
can to try to make things work.

If anyone has concrete concerns about RISC-V hardware not being 
supported by Linux then I'm happy to have a discussion about that.  
Having a discussion in public is always best, as then everyone can be on 
the same page, but as far as I know we're doing a good job supporting 
the publicly available hardware -- not saying we're perfect, but given 
the size of the RISC-V user base and how new much of the hardware is I 
think we're well above average when it comes to upstream support of real 
hardware.  I have a feeling anyone's worries would be about unreleased 
hardware, in which case I can understand it's difficult to have concrete 
discussions in public.  I'm always happy to at least make an attempt to 
have private discussions about these (private discussion are tricky, 
though, so I can't promise I can always participate), and while I don't 
think those discussions should meaningfully sway the kernel's policies 
one way or the other it could at least help alleviate any acute concerns 
that vendors have.  We've gotten to the point where some pretty serious 
accusations are starting to get thrown around, and that sort of thing 
really doesn't benefit anyone so I'm willing to do whatever I can to 
help fix that.

IMO we're just trying to follow the standard Linux development policies 
here, where the focus is on making real hardware work in a way that can 
be sustainably maintained so we don't break users.  If anything I think 
we're a notch more liberal WRT the code we accept than standard with the 
current policy, as accepting anything in a frozen extension doesn't even 
require a commitment from a hardware vendor WRT implementing the code.  
That obviously opens us up to behavior differences between the hardware 
and the specification, which have historically been retrofitted back to 
the specifications, but I'm willing to take on the extra work as it 
helps lend weight to the specification development process.

If I'm just missing something here and there is publicly available 
hardware that implements the H extension then I'd be happy to have that 
pointed out and very much change the tune of this discussion, but until 
hardware shows up or the ISA is frozen I just don't see any way to 
maintain this code up the standards generally set by Linux or 
specifically by arch/riscv and therefor cannot support merging it.

>
> Good luck!
>
> On Wed, May 19, 2021 at 11:36 AM Anup Patel <anup.patel@wdc.com> wrote:
>>
>> From: Anup Patel <anup@brainfault.org>
>>
>> This series adds initial KVM RISC-V support. Currently, we are able to boot
>> Linux on RV64/RV32 Guest with multiple VCPUs.
>>
>> Key aspects of KVM RISC-V added by this series are:
>> 1. No RISC-V specific KVM IOCTL
>> 2. Minimal possible KVM world-switch which touches only GPRs and few CSRs
>> 3. Both RV64 and RV32 host supported
>> 4. Full Guest/VM switch is done via vcpu_get/vcpu_put infrastructure
>> 5. KVM ONE_REG interface for VCPU register access from user-space
>> 6. PLIC emulation is done in user-space
>> 7. Timer and IPI emuation is done in-kernel
>> 8. Both Sv39x4 and Sv48x4 supported for RV64 host
>> 9. MMU notifiers supported
>> 10. Generic dirtylog supported
>> 11. FP lazy save/restore supported
>> 12. SBI v0.1 emulation for KVM Guest available
>> 13. Forward unhandled SBI calls to KVM userspace
>> 14. Hugepage support for Guest/VM
>> 15. IOEVENTFD support for Vhost
>>
>> Here's a brief TODO list which we will work upon after this series:
>> 1. SBI v0.2 emulation in-kernel
>> 2. SBI v0.2 hart state management emulation in-kernel
>> 3. In-kernel PLIC emulation
>> 4. ..... and more .....
>>
>> This series can be found in riscv_kvm_v18 branch at:
>> https//github.com/avpatel/linux.git
>>
>> Our work-in-progress KVMTOOL RISC-V port can be found in riscv_v7 branch
>> at: https//github.com/avpatel/kvmtool.git
>>
>> The QEMU RISC-V hypervisor emulation is done by Alistair and is available
>> in master branch at: https://git.qemu.org/git/qemu.git
>>
>> To play around with KVM RISC-V, refer KVM RISC-V wiki at:
>> https://github.com/kvm-riscv/howto/wiki
>> https://github.com/kvm-riscv/howto/wiki/KVM-RISCV64-on-QEMU
>> https://github.com/kvm-riscv/howto/wiki/KVM-RISCV64-on-Spike
>>
>> Changes since v17:
>>  - Rebased on Linux-5.13-rc2
>>  - Moved to new KVM MMU notifier APIs
>>  - Removed redundant kvm_arch_vcpu_uninit()
>>  - Moved KVM RISC-V sources to drivers/staging for compliance with
>>    Linux RISC-V patch acceptance policy
>>
>> Changes since v16:
>>  - Rebased on Linux-5.12-rc5
>>  - Remove redundant kvm_arch_create_memslot(), kvm_arch_vcpu_setup(),
>>    kvm_arch_vcpu_init(), kvm_arch_has_vcpu_debugfs(), and
>>    kvm_arch_create_vcpu_debugfs() from PATCH5
>>  - Make stage2_wp_memory_region() and stage2_ioremap() as static
>>    in PATCH13
>>
>> Changes since v15:
>>  - Rebased on Linux-5.11-rc3
>>  - Fixed kvm_stage2_map() to use gfn_to_pfn_prot() for determing
>>    writeability of a host pfn.
>>  - Use "__u64" in-place of "u64" and "__u32" in-place of "u32" for
>>    uapi/asm/kvm.h
>>
>> Changes since v14:
>>  - Rebased on Linux-5.10-rc3
>>  - Fixed Stage2 (G-stage) PDG allocation to ensure it is 16KB aligned
>>
>> Changes since v13:
>>  - Rebased on Linux-5.9-rc3
>>  - Fixed kvm_riscv_vcpu_set_reg_csr() for SIP updation in PATCH5
>>  - Fixed instruction length computation in PATCH7
>>  - Added ioeventfd support in PATCH7
>>  - Ensure HSTATUS.SPVP is set to correct value before using HLV/HSV
>>    intructions in PATCH7
>>  - Fixed stage2_map_page() to set PTE 'A' and 'D' bits correctly
>>    in PATCH10
>>  - Added stage2 dirty page logging in PATCH10
>>  - Allow KVM user-space to SET/GET SCOUNTER CSR in PATCH5
>>  - Save/restore SCOUNTEREN in PATCH6
>>  - Reduced quite a few instructions for __kvm_riscv_switch_to() by
>>    using CSR swap instruction in PATCH6
>>  - Detect and use Sv48x4 when available in PATCH10
>>
>> Changes since v12:
>>  - Rebased patches on Linux-5.8-rc4
>>  - By default enable all counters in HCOUNTEREN
>>  - RISC-V H-Extension v0.6.1 spec support
>>
>> Changes since v11:
>>  - Rebased patches on Linux-5.7-rc3
>>  - Fixed typo in typecast of stage2_map_size define
>>  - Introduced struct kvm_cpu_trap to represent trap details and
>>    use it as function parameter wherever applicable
>>  - Pass memslot to kvm_riscv_stage2_map() for supporing dirty page
>>    logging in future
>>  - RISC-V H-Extension v0.6 spec support
>>  - Send-out first three patches as separate series so that it can
>>    be taken by Palmer for Linux RISC-V
>>
>> Changes since v10:
>>  - Rebased patches on Linux-5.6-rc5
>>  - Reduce RISCV_ISA_EXT_MAX from 256 to 64
>>  - Separate PATCH for removing N-extension related defines
>>  - Added comments as requested by Palmer
>>  - Fixed HIDELEG CSR programming
>>
>> Changes since v9:
>>  - Rebased patches on Linux-5.5-rc3
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
>>  - Rebased series on Linux-5.4-rc1 and Atish's SBI v0.2 patches
>>  - Removed PATCH1, PATCH3, and PATCH20 because these already merged
>>  - Use kernel doc style comments for ISA bitmap functions
>>  - Don't parse X, Y, and Z extension in riscv_fill_hwcap() because it will
>>    be added in-future
>>  - Mark KVM RISC-V kconfig option as EXPERIMENTAL
>>  - Typo fix in commit description of PATCH6 of v7 series
>>  - Use separate structs for CORE and CSR registers of ONE_REG interface
>>  - Explicitly include asm/sbi.h in kvm/vcpu_sbi.c
>>  - Removed implicit switch-case fall-through in kvm_riscv_vcpu_exit()
>>  - No need to set VSSTATUS.MXR bit in kvm_riscv_vcpu_unpriv_read()
>>  - Removed register for instruction length in kvm_riscv_vcpu_unpriv_read()
>>  - Added defines for checking/decoding instruction length
>>  - Added separate patch to forward unhandled SBI calls to userspace tool
>>
>> Changes since v6:
>>  - Rebased patches on Linux-5.3-rc7
>>  - Added "return_handled" in struct kvm_mmio_decode to ensure that
>>    kvm_riscv_vcpu_mmio_return() updates SEPC only once
>>  - Removed trap_stval parameter from kvm_riscv_vcpu_unpriv_read()
>>  - Updated git repo URL in MAINTAINERS entry
>>
>> Changes since v5:
>>  - Renamed KVM_REG_RISCV_CONFIG_TIMEBASE register to
>>    KVM_REG_RISCV_CONFIG_TBFREQ register in ONE_REG interface
>>  - Update SPEC in kvm_riscv_vcpu_mmio_return() for MMIO exits
>>  - Use switch case instead of illegal instruction opcode table for simplicity
>>  - Improve comments in stage2_remote_tlb_flush() for a potential remote TLB
>>   flush optimization
>>  - Handle all unsupported SBI calls in default case of
>>    kvm_riscv_vcpu_sbi_ecall() function
>>  - Fixed kvm_riscv_vcpu_sync_interrupts() for software interrupts
>>  - Improved unprivilege reads to handle traps due to Guest stage1 page table
>>  - Added separate patch to document RISC-V specific things in
>>    Documentation/virt/kvm/api.txt
>>
>> Changes since v4:
>>  - Rebased patches on Linux-5.3-rc5
>>  - Added Paolo's Acked-by and Reviewed-by
>>  - Updated mailing list in MAINTAINERS entry
>>
>> Changes since v3:
>>  - Moved patch for ISA bitmap from KVM prep series to this series
>>  - Make vsip_shadow as run-time percpu variable instead of compile-time
>>  - Flush Guest TLBs on all Host CPUs whenever we run-out of VMIDs
>>
>> Changes since v2:
>>  - Removed references of KVM_REQ_IRQ_PENDING from all patches
>>  - Use kvm->srcu within in-kernel KVM run loop
>>  - Added percpu vsip_shadow to track last value programmed in VSIP CSR
>>  - Added comments about irqs_pending and irqs_pending_mask
>>  - Used kvm_arch_vcpu_runnable() in-place-of kvm_riscv_vcpu_has_interrupt()
>>    in system_opcode_insn()
>>  - Removed unwanted smp_wmb() in kvm_riscv_stage2_vmid_update()
>>  - Use kvm_flush_remote_tlbs() in kvm_riscv_stage2_vmid_update()
>>  - Use READ_ONCE() in kvm_riscv_stage2_update_hgatp() for vmid
>>
>> Changes since v1:
>>  - Fixed compile errors in building KVM RISC-V as module
>>  - Removed unused kvm_riscv_halt_guest() and kvm_riscv_resume_guest()
>>  - Set KVM_CAP_SYNC_MMU capability only after MMU notifiers are implemented
>>  - Made vmid_version as unsigned long instead of atomic
>>  - Renamed KVM_REQ_UPDATE_PGTBL to KVM_REQ_UPDATE_HGATP
>>  - Renamed kvm_riscv_stage2_update_pgtbl() to kvm_riscv_stage2_update_hgatp()
>>  - Configure HIDELEG and HEDELEG in kvm_arch_hardware_enable()
>>  - Updated ONE_REG interface for CSR access to user-space
>>  - Removed irqs_pending_lock and use atomic bitops instead
>>  - Added separate patch for FP ONE_REG interface
>>  - Added separate patch for updating MAINTAINERS file
>>
>> Anup Patel (14):
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
>>   RISC-V: KVM: Move sources to drivers/staging directory
>>   RISC-V: KVM: Add MAINTAINERS entry
>>
>> Atish Patra (4):
>>   RISC-V: KVM: Add timer functionality
>>   RISC-V: KVM: FP lazy save/restore
>>   RISC-V: KVM: Implement ONE REG interface for FP registers
>>   RISC-V: KVM: Add SBI v0.1 support
>>
>>  Documentation/virt/kvm/api.rst                | 193 +++-
>>  MAINTAINERS                                   |  11 +
>>  arch/riscv/Kconfig                            |   1 +
>>  arch/riscv/Makefile                           |   1 +
>>  arch/riscv/include/uapi/asm/kvm.h             | 128 +++
>>  drivers/clocksource/timer-riscv.c             |   9 +
>>  drivers/staging/riscv/kvm/Kconfig             |  36 +
>>  drivers/staging/riscv/kvm/Makefile            |  23 +
>>  drivers/staging/riscv/kvm/asm/kvm_csr.h       | 105 ++
>>  drivers/staging/riscv/kvm/asm/kvm_host.h      | 271 +++++
>>  drivers/staging/riscv/kvm/asm/kvm_types.h     |   7 +
>>  .../staging/riscv/kvm/asm/kvm_vcpu_timer.h    |  44 +
>>  drivers/staging/riscv/kvm/main.c              | 118 +++
>>  drivers/staging/riscv/kvm/mmu.c               | 802 ++++++++++++++
>>  drivers/staging/riscv/kvm/riscv_offsets.c     | 170 +++
>>  drivers/staging/riscv/kvm/tlb.S               |  74 ++
>>  drivers/staging/riscv/kvm/vcpu.c              | 997 ++++++++++++++++++
>>  drivers/staging/riscv/kvm/vcpu_exit.c         | 701 ++++++++++++
>>  drivers/staging/riscv/kvm/vcpu_sbi.c          | 173 +++
>>  drivers/staging/riscv/kvm/vcpu_switch.S       | 401 +++++++
>>  drivers/staging/riscv/kvm/vcpu_timer.c        | 225 ++++
>>  drivers/staging/riscv/kvm/vm.c                |  81 ++
>>  drivers/staging/riscv/kvm/vmid.c              | 120 +++
>>  include/clocksource/timer-riscv.h             |  16 +
>>  include/uapi/linux/kvm.h                      |   8 +
>>  25 files changed, 4706 insertions(+), 9 deletions(-)
>>  create mode 100644 arch/riscv/include/uapi/asm/kvm.h
>>  create mode 100644 drivers/staging/riscv/kvm/Kconfig
>>  create mode 100644 drivers/staging/riscv/kvm/Makefile
>>  create mode 100644 drivers/staging/riscv/kvm/asm/kvm_csr.h
>>  create mode 100644 drivers/staging/riscv/kvm/asm/kvm_host.h
>>  create mode 100644 drivers/staging/riscv/kvm/asm/kvm_types.h
>>  create mode 100644 drivers/staging/riscv/kvm/asm/kvm_vcpu_timer.h
>>  create mode 100644 drivers/staging/riscv/kvm/main.c
>>  create mode 100644 drivers/staging/riscv/kvm/mmu.c
>>  create mode 100644 drivers/staging/riscv/kvm/riscv_offsets.c
>>  create mode 100644 drivers/staging/riscv/kvm/tlb.S
>>  create mode 100644 drivers/staging/riscv/kvm/vcpu.c
>>  create mode 100644 drivers/staging/riscv/kvm/vcpu_exit.c
>>  create mode 100644 drivers/staging/riscv/kvm/vcpu_sbi.c
>>  create mode 100644 drivers/staging/riscv/kvm/vcpu_switch.S
>>  create mode 100644 drivers/staging/riscv/kvm/vcpu_timer.c
>>  create mode 100644 drivers/staging/riscv/kvm/vm.c
>>  create mode 100644 drivers/staging/riscv/kvm/vmid.c
>>  create mode 100644 include/clocksource/timer-riscv.h
>>
>> --
>> 2.25.1
>>
