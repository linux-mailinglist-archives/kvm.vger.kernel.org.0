Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1402FE230
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 07:01:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbhAUGAl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 01:00:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729567AbhAUDFM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jan 2021 22:05:12 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75E85C0613D3
        for <kvm@vger.kernel.org>; Wed, 20 Jan 2021 19:03:39 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id p72so1178326iod.12
        for <kvm@vger.kernel.org>; Wed, 20 Jan 2021 19:03:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=49fv5m5ZCfOtjJ909fahXhO6rbzTEITVE7JNaqYcExI=;
        b=zIqWpdUtONjv+iNl4fal4rvG9gS1yfJYVTDldkNTGAdK0sIygi7Nk7f9haTYVWO4io
         +EYnnNjU40IbQ04rvSPZZfP/sjfV5TjamNie6oy52OEEWg2jUFZm+W5UlHfeXMYkHEbR
         soUbXu0w3SAnADuhC5TOgMka3kdnQCM5ftr7wd2PifcqTOaKiFWgZnNS8HWgwuIhg/3y
         JiyXnHtjIApoMAvMPIFKND2grRQDavB6DvBwurk4RBmZadX6ctv1XqL8R6U3jf9VpslB
         EfjugaBC9fEcVTncubyYFIP8Kw2XJPiw/KKTmw/TfGrc99QGTL5FasRSDZefuFV3+rL3
         76IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=49fv5m5ZCfOtjJ909fahXhO6rbzTEITVE7JNaqYcExI=;
        b=dQ9QL4BnfWc2v1uxAmt88H+bbIZYiw2aKNRMgbN8D5fBUE4rauRDchv6IsyYV0mg4Z
         eT2MWqcb3XrNT6KO9PEPMlUT7kldzmsgP3b0ClLYVF108kJIRRdYItgko313A/CHJA7t
         MsmOaH+5DTa8pWYhbxODAvblQ4yCjT8ipM2tYzLqn/XZN8qTNacUkqmhkULvVyCug6k+
         VWuZTaWorhPvFamFqaJAtZzo3KqtP8QqcCRb1CeKD1fZIo4KW/vyaISm9M708pFGczEK
         HGOy2mP0PsaNUBO6ZAk1Z63pGZ55+GMysFqCVHjaHdXGA4aW9xSL/CWDhFriUL2dUKXY
         s+iw==
X-Gm-Message-State: AOAM530QsqG47NUazB4yuscXUdYO3bNdGyxtDNYW5aaPj8fFF3CioSni
        XinWJlXD2biRwqOs/tZ4UvR2c6RyOzaQJu3rgWPk6XNHuqFH
X-Google-Smtp-Source: ABdhPJzr+rB8p5Mk3VaN7I2CVpYfNidIq1sphVuO90aZFtW9AZBDNDYgzFMdc8+oMGfbfetZhRcEVisO5+1ETZSjMUg=
X-Received: by 2002:a5e:9612:: with SMTP id a18mr8856785ioq.13.1611198218728;
 Wed, 20 Jan 2021 19:03:38 -0800 (PST)
MIME-Version: 1.0
References: <20201210160002.1407373-1-maz@kernel.org>
In-Reply-To: <20201210160002.1407373-1-maz@kernel.org>
From:   Haibo Xu <haibo.xu@linaro.org>
Date:   Thu, 21 Jan 2021 11:03:27 +0800
Message-ID: <CAJc+Z1FQmUFS=5xEG8mPkJCUZ+ecBt4G=YbxGJTO4YFbfGMg3w@mail.gmail.com>
Subject: Re: [PATCH v3 00/66] KVM: arm64: ARMv8.3/8.4 Nested Virtualization support
To:     Marc Zyngier <maz@kernel.org>
Cc:     arm-mail-list <linux-arm-kernel@lists.infradead.org>,
        kvmarm <kvmarm@lists.cs.columbia.edu>, kvm@vger.kernel.org,
        kernel-team@android.com, Andre Przywara <andre.przywara@arm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Re-send in case the previous email was blocked for the inlined hyper-link.

Hi Marc,

I have tried to enable the NV support in Qemu, and now I can
successfully boot a L2 guest
in Qemu KVM mode.

This patch series looks good from the Qemu side except for two minor
requirements:
(1) Qemu will check whether a feature was supported by the KVM cap
when the user tries
     to enable it in the command line, so a new capability was
prefered for the NV(KVM_CAP_ARM_NV?).
(2) According to the Documentation/virt/kvm/api.rst, userspace can
call KVM_ARM_VCPU_INIT
     multiple times for a given vcpu, but the kvm_vcpu_init_nested()
do have some issue when
     called multiple times(please refer to the detailed comments in patch 63)

Regards,
Haibo

On Fri, 11 Dec 2020 at 00:00, Marc Zyngier <maz@kernel.org> wrote:
>
> This is a rework of the NV series that I posted 10 months ago[1], as a
> lot of the KVM code has changed since, and the series apply anymore
> (not that anybody really cares as the the HW is, as usual, made of
> unobtainium...).
>
> From the previous version:
>
> - Integration with the new page-table code
> - New exception injection code
> - No more messing with the nVHE code
> - No AArch32!!!!
> - Rebased on v5.10-rc4 + kvmarm/next for 5.11
>
> From a functionality perspective, you can expect a L2 guest to work,
> but don't even think of L3, as we only partially emulate the
> ARMv8.{3,4}-NV extensions themselves. Same thing for vgic, debug, PMU,
> as well as anything that would require a Stage-1 PTW. What we want to
> achieve is that with NV disabled, there is no performance overhead and
> no regression.
>
> The series is roughly divided in 5 parts: exception handling, memory
> virtualization, interrupts and timers for ARMv8.3, followed by the
> ARMv8.4 support. There are of course some dependencies, but you'll
> hopefully get the gist of it.
>
> For the most courageous of you, I've put out a branch[2]. Of course,
> you'll need some userspace. Andre maintains a hacked version of
> kvmtool[3] that takes a --nested option, allowing the guest to be
> started at EL2. You can run the whole stack in the Foundation
> model. Don't be in a hurry ;-).
>
> And to be clear: although Jintack and Christoffer have written tons of
> the stuff originaly, I'm the one responsible for breaking it!
>
> [1] https://lore.kernel.org/r/20200211174938.27809-1-maz@kernel.org
> [2] git://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git kvm-arm64/nv-5.11.-WIP
> [3] git://linux-arm.org/kvmtool.git nv/nv-wip-5.2-rc5
>
> Andre Przywara (1):
>   KVM: arm64: nv: vgic: Allow userland to set VGIC maintenance IRQ
>
> Christoffer Dall (15):
>   KVM: arm64: nv: Introduce nested virtualization VCPU feature
>   KVM: arm64: nv: Reset VCPU to EL2 registers if VCPU nested virt is set
>   KVM: arm64: nv: Allow userspace to set PSR_MODE_EL2x
>   KVM: arm64: nv: Add nested virt VCPU primitives for vEL2 VCPU state
>   KVM: arm64: nv: Reset VMPIDR_EL2 and VPIDR_EL2 to sane values
>   KVM: arm64: nv: Handle trapped ERET from virtual EL2
>   KVM: arm64: nv: Emulate PSTATE.M for a guest hypervisor
>   KVM: arm64: nv: Trap EL1 VM register accesses in virtual EL2
>   KVM: arm64: nv: Only toggle cache for virtual EL2 when SCTLR_EL2
>     changes
>   KVM: arm64: nv: Implement nested Stage-2 page table walk logic
>   KVM: arm64: nv: Unmap/flush shadow stage 2 page tables
>   KVM: arm64: nv: arch_timer: Support hyp timer emulation
>   KVM: arm64: nv: vgic: Emulate the HW bit in software
>   KVM: arm64: nv: Add nested GICv3 tracepoints
>   KVM: arm64: nv: Sync nested timer state with ARMv8.4
>
> Jintack Lim (19):
>   arm64: Add ARM64_HAS_NESTED_VIRT cpufeature
>   KVM: arm64: nv: Handle HCR_EL2.NV system register traps
>   KVM: arm64: nv: Support virtual EL2 exceptions
>   KVM: arm64: nv: Inject HVC exceptions to the virtual EL2
>   KVM: arm64: nv: Trap SPSR_EL1, ELR_EL1 and VBAR_EL1 from virtual EL2
>   KVM: arm64: nv: Trap CPACR_EL1 access in virtual EL2
>   KVM: arm64: nv: Handle PSCI call via smc from the guest
>   KVM: arm64: nv: Respect virtual HCR_EL2.TWX setting
>   KVM: arm64: nv: Respect virtual CPTR_EL2.{TFP,FPEN} settings
>   KVM: arm64: nv: Respect the virtual HCR_EL2.NV bit setting
>   KVM: arm64: nv: Respect virtual HCR_EL2.TVM and TRVM settings
>   KVM: arm64: nv: Respect the virtual HCR_EL2.NV1 bit setting
>   KVM: arm64: nv: Emulate EL12 register accesses from the virtual EL2
>   KVM: arm64: nv: Configure HCR_EL2 for nested virtualization
>   KVM: arm64: nv: Introduce sys_reg_desc.forward_trap
>   KVM: arm64: nv: Set a handler for the system instruction traps
>   KVM: arm64: nv: Trap and emulate AT instructions from virtual EL2
>   KVM: arm64: nv: Trap and emulate TLBI instructions from virtual EL2
>   KVM: arm64: nv: Nested GICv3 Support
>
> Marc Zyngier (31):
>   KVM: arm64: nv: Add EL2 system registers to vcpu context
>   KVM: arm64: nv: Add non-VHE-EL2->EL1 translation helpers
>   KVM: arm64: nv: Handle virtual EL2 registers in
>     vcpu_read/write_sys_reg()
>   KVM: arm64: nv: Handle SPSR_EL2 specially
>   KVM: arm64: nv: Handle HCR_EL2.E2H specially
>   KVM: arm64: nv: Save/Restore vEL2 sysregs
>   KVM: arm64: nv: Forward debug traps to the nested guest
>   KVM: arm64: nv: Filter out unsupported features from ID regs
>   KVM: arm64: nv: Hide RAS from nested guests
>   KVM: arm64: nv: Support multiple nested Stage-2 mmu structures
>   KVM: arm64: nv: Handle shadow stage 2 page faults
>   KVM: arm64: nv: Restrict S2 RD/WR permissions to match the guest's
>   KVM: arm64: nv: Fold guest's HCR_EL2 configuration into the host's
>   KVM: arm64: nv: Add handling of EL2-specific timer registers
>   KVM: arm64: nv: Load timer before the GIC
>   KVM: arm64: nv: Don't load the GICv4 context on entering a nested
>     guest
>   KVM: arm64: nv: Implement maintenance interrupt forwarding
>   KVM: arm64: nv: Allow userspace to request KVM_ARM_VCPU_NESTED_VIRT
>   KVM: arm64: nv: Add handling of ARMv8.4-TTL TLB invalidation
>   KVM: arm64: nv: Invalidate TLBs based on shadow S2 TTL-like
>     information
>   KVM: arm64: Allow populating S2 SW bits
>   KVM: arm64: nv: Tag shadow S2 entries with nested level
>   KVM: arm64: nv: Add include containing the VNCR_EL2 offsets
>   KVM: arm64: Map VNCR-capable registers to a separate page
>   KVM: arm64: nv: Move nested vgic state into the sysreg file
>   KVM: arm64: Add ARMv8.4 Enhanced Nested Virt cpufeature
>   KVM: arm64: nv: Synchronize PSTATE early on exit
>   KVM: arm64: nv: Allocate VNCR page when required
>   KVM: arm64: nv: Enable ARMv8.4-NV support
>   KVM: arm64: nv: Fast-track 'InHost' exception returns
>   KVM: arm64: nv: Fast-track EL1 TLBIs for VHE guests
>
>  .../admin-guide/kernel-parameters.txt         |    4 +
>  .../virt/kvm/devices/arm-vgic-v3.rst          |   12 +-
>  arch/arm64/include/asm/cpucaps.h              |    2 +
>  arch/arm64/include/asm/esr.h                  |    6 +
>  arch/arm64/include/asm/kvm_arm.h              |   28 +-
>  arch/arm64/include/asm/kvm_asm.h              |    4 +
>  arch/arm64/include/asm/kvm_emulate.h          |  145 +-
>  arch/arm64/include/asm/kvm_host.h             |  175 ++-
>  arch/arm64/include/asm/kvm_hyp.h              |    2 +
>  arch/arm64/include/asm/kvm_mmu.h              |   17 +-
>  arch/arm64/include/asm/kvm_nested.h           |  152 ++
>  arch/arm64/include/asm/kvm_pgtable.h          |   10 +
>  arch/arm64/include/asm/sysreg.h               |  104 +-
>  arch/arm64/include/asm/vncr_mapping.h         |   73 +
>  arch/arm64/include/uapi/asm/kvm.h             |    2 +
>  arch/arm64/kernel/cpufeature.c                |   35 +
>  arch/arm64/kvm/Makefile                       |    4 +-
>  arch/arm64/kvm/arch_timer.c                   |  189 ++-
>  arch/arm64/kvm/arm.c                          |   34 +-
>  arch/arm64/kvm/at.c                           |  231 ++++
>  arch/arm64/kvm/emulate-nested.c               |  186 +++
>  arch/arm64/kvm/guest.c                        |    6 +
>  arch/arm64/kvm/handle_exit.c                  |   81 +-
>  arch/arm64/kvm/hyp/exception.c                |   44 +-
>  arch/arm64/kvm/hyp/include/hyp/switch.h       |   31 +-
>  arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h    |   28 +-
>  arch/arm64/kvm/hyp/nvhe/switch.c              |   10 +-
>  arch/arm64/kvm/hyp/nvhe/sysreg-sr.c           |    2 +-
>  arch/arm64/kvm/hyp/pgtable.c                  |    6 +
>  arch/arm64/kvm/hyp/vgic-v3-sr.c               |    2 +-
>  arch/arm64/kvm/hyp/vhe/switch.c               |  207 ++-
>  arch/arm64/kvm/hyp/vhe/sysreg-sr.c            |  125 +-
>  arch/arm64/kvm/hyp/vhe/tlb.c                  |   83 ++
>  arch/arm64/kvm/inject_fault.c                 |   62 +-
>  arch/arm64/kvm/mmu.c                          |  183 ++-
>  arch/arm64/kvm/nested.c                       |  908 ++++++++++++
>  arch/arm64/kvm/reset.c                        |   14 +-
>  arch/arm64/kvm/sys_regs.c                     | 1226 ++++++++++++++++-
>  arch/arm64/kvm/sys_regs.h                     |    6 +
>  arch/arm64/kvm/trace_arm.h                    |   65 +-
>  arch/arm64/kvm/vgic/vgic-init.c               |   30 +
>  arch/arm64/kvm/vgic/vgic-kvm-device.c         |   22 +
>  arch/arm64/kvm/vgic/vgic-nested-trace.h       |  137 ++
>  arch/arm64/kvm/vgic/vgic-v3-nested.c          |  240 ++++
>  arch/arm64/kvm/vgic/vgic-v3.c                 |   39 +-
>  arch/arm64/kvm/vgic/vgic.c                    |   44 +
>  arch/arm64/kvm/vgic/vgic.h                    |   10 +
>  include/kvm/arm_arch_timer.h                  |    7 +
>  include/kvm/arm_vgic.h                        |   16 +
>  tools/arch/arm/include/uapi/asm/kvm.h         |    1 +
>  50 files changed, 4890 insertions(+), 160 deletions(-)
>  create mode 100644 arch/arm64/include/asm/kvm_nested.h
>  create mode 100644 arch/arm64/include/asm/vncr_mapping.h
>  create mode 100644 arch/arm64/kvm/at.c
>  create mode 100644 arch/arm64/kvm/emulate-nested.c
>  create mode 100644 arch/arm64/kvm/nested.c
>  create mode 100644 arch/arm64/kvm/vgic/vgic-nested-trace.h
>  create mode 100644 arch/arm64/kvm/vgic/vgic-v3-nested.c
>
> --
> 2.29.2
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
