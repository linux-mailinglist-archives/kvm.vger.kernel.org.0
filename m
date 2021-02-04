Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A015530EDCB
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 08:54:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234765AbhBDHwh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 02:52:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234658AbhBDHw3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Feb 2021 02:52:29 -0500
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EF72C061573
        for <kvm@vger.kernel.org>; Wed,  3 Feb 2021 23:51:49 -0800 (PST)
Received: by mail-il1-x135.google.com with SMTP id y5so1742007ilg.4
        for <kvm@vger.kernel.org>; Wed, 03 Feb 2021 23:51:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NtyD2v3IYsZzz7ag3t9ZeEezT/xLcNhvZXSj2TEZJD0=;
        b=nl55z2/eUuWCm5DtuDz4rELLxxv12SVo5WZISxn/vBIjMmoGVYE/dmD1AyrxGud8dF
         r6mWAm5Hsh8FAYQTVOfKrEDflKLZ0RQDbgd6s7UuvesuXAc3nLyA9H/RNc2BBjNr63os
         6bhK2+nFMcMBHpFbaEpCVmu5bcXLROdvgxjNf7JdB9jDFHgZlzjT+T6ydY6CzrK6UyqA
         rCVb/crx5HjfFwf+VO5KqWVNp4ERZjBMjhgFPcGKC/98snC2uE59RiKSPiQ1WCzZXE/w
         xSb2R5x6LRDLzaA0MtyyHcygJCy5cVTu87P1pbThmm7okiqCeDJezVWSbC3GY+bVAanK
         +8Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NtyD2v3IYsZzz7ag3t9ZeEezT/xLcNhvZXSj2TEZJD0=;
        b=tVe1xx7vRhkHoy5+iIgOXlxAcMngqA1PkksuSf93hc9pPBkJJwsiyQwbaA0T5od4uB
         LzhpiSlSdIDJLe1kIyFySvAlp2Ko9gdg8EE86q3QM7K9E8jn+yWAZO0vWBgzbjLzyNVS
         3ITP7nkH6iPfcMuLwkwRcyJeeF0Rn2Q6hUJoSbm9sphN2Xj4qbbYDXHdau943IC2GAft
         i6XX2rBuHP+jELfIkAkRu6L7Gm7SBHbZAVV6AsxW10ifkUvWOhUW+gsvcIJisXVKqh2m
         pFNd3qUMm5ej7h3Ad38ru1dU1/CYid/j8t7FaJ+FtOYJEEsi3pJmMD6ydHg5oFMwVr9B
         eGXw==
X-Gm-Message-State: AOAM532Vmt1SM+5CIqjS8sghjhULjQILAAlCfReUOPcB0Wd6O66hvPns
        iqLYjsweSDjbl0rXjgB8VdK1LxO2GaN4nsPqLEJa
X-Google-Smtp-Source: ABdhPJx9QlxfV568dWSo24uHgFDPktBA/ix/rkB+jLCWkWvolTBtDbUFV91PZ2xKFHzUPsd0hsPVC52ORYQBNSk0dvM=
X-Received: by 2002:a05:6e02:1bca:: with SMTP id x10mr5603507ilv.71.1612425108645;
 Wed, 03 Feb 2021 23:51:48 -0800 (PST)
MIME-Version: 1.0
References: <20201210160002.1407373-1-maz@kernel.org> <CAJc+Z1FQmUFS=5xEG8mPkJCUZ+ecBt4G=YbxGJTO4YFbfGMg3w@mail.gmail.com>
In-Reply-To: <CAJc+Z1FQmUFS=5xEG8mPkJCUZ+ecBt4G=YbxGJTO4YFbfGMg3w@mail.gmail.com>
From:   Haibo Xu <haibo.xu@linaro.org>
Date:   Thu, 4 Feb 2021 15:51:37 +0800
Message-ID: <CAJc+Z1HE2oFWM8oerrM_3VDNuTOoc3D1Ao7sB2tYj7n6doNBbA@mail.gmail.com>
Subject: Re: [PATCH v3 00/66] KVM: arm64: ARMv8.3/8.4 Nested Virtualization support
To:     Marc Zyngier <maz@kernel.org>
Cc:     arm-mail-list <linux-arm-kernel@lists.infradead.org>,
        kvmarm <kvmarm@lists.cs.columbia.edu>, kvm@vger.kernel.org,
        kernel-team@android.com, Andre Przywara <andre.przywara@arm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Kindly ping!

On Thu, 21 Jan 2021 at 11:03, Haibo Xu <haibo.xu@linaro.org> wrote:
>
> Re-send in case the previous email was blocked for the inlined hyper-link.
>
> Hi Marc,
>
> I have tried to enable the NV support in Qemu, and now I can
> successfully boot a L2 guest
> in Qemu KVM mode.
>
> This patch series looks good from the Qemu side except for two minor
> requirements:
> (1) Qemu will check whether a feature was supported by the KVM cap
> when the user tries
>      to enable it in the command line, so a new capability was
> prefered for the NV(KVM_CAP_ARM_NV?).
> (2) According to the Documentation/virt/kvm/api.rst, userspace can
> call KVM_ARM_VCPU_INIT
>      multiple times for a given vcpu, but the kvm_vcpu_init_nested()
> do have some issue when
>      called multiple times(please refer to the detailed comments in patch 63)
>
> Regards,
> Haibo
>
> On Fri, 11 Dec 2020 at 00:00, Marc Zyngier <maz@kernel.org> wrote:
> >
> > This is a rework of the NV series that I posted 10 months ago[1], as a
> > lot of the KVM code has changed since, and the series apply anymore
> > (not that anybody really cares as the the HW is, as usual, made of
> > unobtainium...).
> >
> > From the previous version:
> >
> > - Integration with the new page-table code
> > - New exception injection code
> > - No more messing with the nVHE code
> > - No AArch32!!!!
> > - Rebased on v5.10-rc4 + kvmarm/next for 5.11
> >
> > From a functionality perspective, you can expect a L2 guest to work,
> > but don't even think of L3, as we only partially emulate the
> > ARMv8.{3,4}-NV extensions themselves. Same thing for vgic, debug, PMU,
> > as well as anything that would require a Stage-1 PTW. What we want to
> > achieve is that with NV disabled, there is no performance overhead and
> > no regression.
> >
> > The series is roughly divided in 5 parts: exception handling, memory
> > virtualization, interrupts and timers for ARMv8.3, followed by the
> > ARMv8.4 support. There are of course some dependencies, but you'll
> > hopefully get the gist of it.
> >
> > For the most courageous of you, I've put out a branch[2]. Of course,
> > you'll need some userspace. Andre maintains a hacked version of
> > kvmtool[3] that takes a --nested option, allowing the guest to be
> > started at EL2. You can run the whole stack in the Foundation
> > model. Don't be in a hurry ;-).
> >
> > And to be clear: although Jintack and Christoffer have written tons of
> > the stuff originaly, I'm the one responsible for breaking it!
> >
> > [1] https://lore.kernel.org/r/20200211174938.27809-1-maz@kernel.org
> > [2] git://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git kvm-arm64/nv-5.11.-WIP
> > [3] git://linux-arm.org/kvmtool.git nv/nv-wip-5.2-rc5
> >
> > Andre Przywara (1):
> >   KVM: arm64: nv: vgic: Allow userland to set VGIC maintenance IRQ
> >
> > Christoffer Dall (15):
> >   KVM: arm64: nv: Introduce nested virtualization VCPU feature
> >   KVM: arm64: nv: Reset VCPU to EL2 registers if VCPU nested virt is set
> >   KVM: arm64: nv: Allow userspace to set PSR_MODE_EL2x
> >   KVM: arm64: nv: Add nested virt VCPU primitives for vEL2 VCPU state
> >   KVM: arm64: nv: Reset VMPIDR_EL2 and VPIDR_EL2 to sane values
> >   KVM: arm64: nv: Handle trapped ERET from virtual EL2
> >   KVM: arm64: nv: Emulate PSTATE.M for a guest hypervisor
> >   KVM: arm64: nv: Trap EL1 VM register accesses in virtual EL2
> >   KVM: arm64: nv: Only toggle cache for virtual EL2 when SCTLR_EL2
> >     changes
> >   KVM: arm64: nv: Implement nested Stage-2 page table walk logic
> >   KVM: arm64: nv: Unmap/flush shadow stage 2 page tables
> >   KVM: arm64: nv: arch_timer: Support hyp timer emulation
> >   KVM: arm64: nv: vgic: Emulate the HW bit in software
> >   KVM: arm64: nv: Add nested GICv3 tracepoints
> >   KVM: arm64: nv: Sync nested timer state with ARMv8.4
> >
> > Jintack Lim (19):
> >   arm64: Add ARM64_HAS_NESTED_VIRT cpufeature
> >   KVM: arm64: nv: Handle HCR_EL2.NV system register traps
> >   KVM: arm64: nv: Support virtual EL2 exceptions
> >   KVM: arm64: nv: Inject HVC exceptions to the virtual EL2
> >   KVM: arm64: nv: Trap SPSR_EL1, ELR_EL1 and VBAR_EL1 from virtual EL2
> >   KVM: arm64: nv: Trap CPACR_EL1 access in virtual EL2
> >   KVM: arm64: nv: Handle PSCI call via smc from the guest
> >   KVM: arm64: nv: Respect virtual HCR_EL2.TWX setting
> >   KVM: arm64: nv: Respect virtual CPTR_EL2.{TFP,FPEN} settings
> >   KVM: arm64: nv: Respect the virtual HCR_EL2.NV bit setting
> >   KVM: arm64: nv: Respect virtual HCR_EL2.TVM and TRVM settings
> >   KVM: arm64: nv: Respect the virtual HCR_EL2.NV1 bit setting
> >   KVM: arm64: nv: Emulate EL12 register accesses from the virtual EL2
> >   KVM: arm64: nv: Configure HCR_EL2 for nested virtualization
> >   KVM: arm64: nv: Introduce sys_reg_desc.forward_trap
> >   KVM: arm64: nv: Set a handler for the system instruction traps
> >   KVM: arm64: nv: Trap and emulate AT instructions from virtual EL2
> >   KVM: arm64: nv: Trap and emulate TLBI instructions from virtual EL2
> >   KVM: arm64: nv: Nested GICv3 Support
> >
> > Marc Zyngier (31):
> >   KVM: arm64: nv: Add EL2 system registers to vcpu context
> >   KVM: arm64: nv: Add non-VHE-EL2->EL1 translation helpers
> >   KVM: arm64: nv: Handle virtual EL2 registers in
> >     vcpu_read/write_sys_reg()
> >   KVM: arm64: nv: Handle SPSR_EL2 specially
> >   KVM: arm64: nv: Handle HCR_EL2.E2H specially
> >   KVM: arm64: nv: Save/Restore vEL2 sysregs
> >   KVM: arm64: nv: Forward debug traps to the nested guest
> >   KVM: arm64: nv: Filter out unsupported features from ID regs
> >   KVM: arm64: nv: Hide RAS from nested guests
> >   KVM: arm64: nv: Support multiple nested Stage-2 mmu structures
> >   KVM: arm64: nv: Handle shadow stage 2 page faults
> >   KVM: arm64: nv: Restrict S2 RD/WR permissions to match the guest's
> >   KVM: arm64: nv: Fold guest's HCR_EL2 configuration into the host's
> >   KVM: arm64: nv: Add handling of EL2-specific timer registers
> >   KVM: arm64: nv: Load timer before the GIC
> >   KVM: arm64: nv: Don't load the GICv4 context on entering a nested
> >     guest
> >   KVM: arm64: nv: Implement maintenance interrupt forwarding
> >   KVM: arm64: nv: Allow userspace to request KVM_ARM_VCPU_NESTED_VIRT
> >   KVM: arm64: nv: Add handling of ARMv8.4-TTL TLB invalidation
> >   KVM: arm64: nv: Invalidate TLBs based on shadow S2 TTL-like
> >     information
> >   KVM: arm64: Allow populating S2 SW bits
> >   KVM: arm64: nv: Tag shadow S2 entries with nested level
> >   KVM: arm64: nv: Add include containing the VNCR_EL2 offsets
> >   KVM: arm64: Map VNCR-capable registers to a separate page
> >   KVM: arm64: nv: Move nested vgic state into the sysreg file
> >   KVM: arm64: Add ARMv8.4 Enhanced Nested Virt cpufeature
> >   KVM: arm64: nv: Synchronize PSTATE early on exit
> >   KVM: arm64: nv: Allocate VNCR page when required
> >   KVM: arm64: nv: Enable ARMv8.4-NV support
> >   KVM: arm64: nv: Fast-track 'InHost' exception returns
> >   KVM: arm64: nv: Fast-track EL1 TLBIs for VHE guests
> >
> >  .../admin-guide/kernel-parameters.txt         |    4 +
> >  .../virt/kvm/devices/arm-vgic-v3.rst          |   12 +-
> >  arch/arm64/include/asm/cpucaps.h              |    2 +
> >  arch/arm64/include/asm/esr.h                  |    6 +
> >  arch/arm64/include/asm/kvm_arm.h              |   28 +-
> >  arch/arm64/include/asm/kvm_asm.h              |    4 +
> >  arch/arm64/include/asm/kvm_emulate.h          |  145 +-
> >  arch/arm64/include/asm/kvm_host.h             |  175 ++-
> >  arch/arm64/include/asm/kvm_hyp.h              |    2 +
> >  arch/arm64/include/asm/kvm_mmu.h              |   17 +-
> >  arch/arm64/include/asm/kvm_nested.h           |  152 ++
> >  arch/arm64/include/asm/kvm_pgtable.h          |   10 +
> >  arch/arm64/include/asm/sysreg.h               |  104 +-
> >  arch/arm64/include/asm/vncr_mapping.h         |   73 +
> >  arch/arm64/include/uapi/asm/kvm.h             |    2 +
> >  arch/arm64/kernel/cpufeature.c                |   35 +
> >  arch/arm64/kvm/Makefile                       |    4 +-
> >  arch/arm64/kvm/arch_timer.c                   |  189 ++-
> >  arch/arm64/kvm/arm.c                          |   34 +-
> >  arch/arm64/kvm/at.c                           |  231 ++++
> >  arch/arm64/kvm/emulate-nested.c               |  186 +++
> >  arch/arm64/kvm/guest.c                        |    6 +
> >  arch/arm64/kvm/handle_exit.c                  |   81 +-
> >  arch/arm64/kvm/hyp/exception.c                |   44 +-
> >  arch/arm64/kvm/hyp/include/hyp/switch.h       |   31 +-
> >  arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h    |   28 +-
> >  arch/arm64/kvm/hyp/nvhe/switch.c              |   10 +-
> >  arch/arm64/kvm/hyp/nvhe/sysreg-sr.c           |    2 +-
> >  arch/arm64/kvm/hyp/pgtable.c                  |    6 +
> >  arch/arm64/kvm/hyp/vgic-v3-sr.c               |    2 +-
> >  arch/arm64/kvm/hyp/vhe/switch.c               |  207 ++-
> >  arch/arm64/kvm/hyp/vhe/sysreg-sr.c            |  125 +-
> >  arch/arm64/kvm/hyp/vhe/tlb.c                  |   83 ++
> >  arch/arm64/kvm/inject_fault.c                 |   62 +-
> >  arch/arm64/kvm/mmu.c                          |  183 ++-
> >  arch/arm64/kvm/nested.c                       |  908 ++++++++++++
> >  arch/arm64/kvm/reset.c                        |   14 +-
> >  arch/arm64/kvm/sys_regs.c                     | 1226 ++++++++++++++++-
> >  arch/arm64/kvm/sys_regs.h                     |    6 +
> >  arch/arm64/kvm/trace_arm.h                    |   65 +-
> >  arch/arm64/kvm/vgic/vgic-init.c               |   30 +
> >  arch/arm64/kvm/vgic/vgic-kvm-device.c         |   22 +
> >  arch/arm64/kvm/vgic/vgic-nested-trace.h       |  137 ++
> >  arch/arm64/kvm/vgic/vgic-v3-nested.c          |  240 ++++
> >  arch/arm64/kvm/vgic/vgic-v3.c                 |   39 +-
> >  arch/arm64/kvm/vgic/vgic.c                    |   44 +
> >  arch/arm64/kvm/vgic/vgic.h                    |   10 +
> >  include/kvm/arm_arch_timer.h                  |    7 +
> >  include/kvm/arm_vgic.h                        |   16 +
> >  tools/arch/arm/include/uapi/asm/kvm.h         |    1 +
> >  50 files changed, 4890 insertions(+), 160 deletions(-)
> >  create mode 100644 arch/arm64/include/asm/kvm_nested.h
> >  create mode 100644 arch/arm64/include/asm/vncr_mapping.h
> >  create mode 100644 arch/arm64/kvm/at.c
> >  create mode 100644 arch/arm64/kvm/emulate-nested.c
> >  create mode 100644 arch/arm64/kvm/nested.c
> >  create mode 100644 arch/arm64/kvm/vgic/vgic-nested-trace.h
> >  create mode 100644 arch/arm64/kvm/vgic/vgic-v3-nested.c
> >
> > --
> > 2.29.2
> >
> > _______________________________________________
> > kvmarm mailing list
> > kvmarm@lists.cs.columbia.edu
> > https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
