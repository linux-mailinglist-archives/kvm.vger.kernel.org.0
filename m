Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7D1841B4A5
	for <lists+kvm@lfdr.de>; Tue, 28 Sep 2021 19:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241945AbhI1RD4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 13:03:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241916AbhI1RDz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Sep 2021 13:03:55 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0E4CC06161C
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 10:02:15 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id 71so7298874ybe.6
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 10:02:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HGZ7MH6XTCWdr3UBmQc13KRqobgBuN8/CwnjXc5THb4=;
        b=f5ikQYgtuNRMcYG9Q4AfAxJMTHpbqJwkfJxwc4PbF7xLSDb9afaLDNAt4i/cGXkh50
         xxh+pBV4Q9qaTzDPvsQmW4Rx0eMSCLWRaAkdMR4aRpHncb3JVUCiwirlherBD3TP5uXG
         i2JIUIkxwjYLqBSOYWyUzBMZ74xDTdWTtS8YNUoLFAEsMP75H4wlbQCsR1c8jDXF2x0g
         C+UpEfRwoVjdN+3uZ7FygApe9ydg7Nots1W6FPtkLrI5vQomWXZgy+l8j0U95tasQNsl
         nWqBd2wKQx2Zc+bM9guq7g7eCJ1VlDhkk/Ej67VUR4UEMZ5XsGt2CSlQXkKfl2hBjZaS
         jxMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HGZ7MH6XTCWdr3UBmQc13KRqobgBuN8/CwnjXc5THb4=;
        b=jq+PTnnIu7Kpnku4Y0ACN2sQT0UhfvrwSFZQnxExNa7aCPurGpNU03PNsYTr3i0H+u
         uXnHxjnsOYaEbdQNOpEheBAcYhjbW9qFcWqEzIGo3HWm09a0/o+/EI03oqSa/vPdrc/p
         8ICLf6R0+FFDp8WH0QGVuUWCbJbxMHc4JtnMIbhq1peWaF2UjRJyZVWyg86hCIhLn+KR
         1NxUoc32dc4/FpzA4+1yHGTRxZu1/WZiQE9pdWV+uYREFD98P4VkhqTKKxoHDkdY6NVd
         aYdldvtB3b3WgTyuAUI3VHIEvLnC84dTdjprY9j43HenALHhIYI54b5lsVQCFAWkRBL4
         QsQw==
X-Gm-Message-State: AOAM530dsC8wmlJdYER903wj7aCmqolxwTJraTu6LB7L2nhU6kvQbx03
        1Mg8lcCnNUUbeZd71I8svzwnAai7CRkTcGphpKIGNw==
X-Google-Smtp-Source: ABdhPJwPYe1y/alZSlUpEy1YyDqpWine+//rf/TJF63+p0Fcb7XpGY6tKmZQRQQk9UySwgPe00cQC/XFm37oqItlonU=
X-Received: by 2002:a25:fc18:: with SMTP id v24mr5706628ybd.23.1632848533698;
 Tue, 28 Sep 2021 10:02:13 -0700 (PDT)
MIME-Version: 1.0
References: <20210914223114.435273-1-rananta@google.com>
In-Reply-To: <20210914223114.435273-1-rananta@google.com>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Tue, 28 Sep 2021 10:02:03 -0700
Message-ID: <CAJHc60y9T2X_EuP5=kiLuCu-3kH4PrvivFSaZsw7R1DgtkKhtQ@mail.gmail.com>
Subject: Re: [PATCH v7 00/15] KVM: arm64: selftests: Introduce arch_timer selftest
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello all,

I think all the patches in the series have 'Reviewed-by' now. Please
let me know if there's anything to do from my end for it move forward.

Regards,
Raghavendra



On Tue, Sep 14, 2021 at 3:31 PM Raghavendra Rao Ananta
<rananta@google.com> wrote:
>
> Hello,
>
> The patch series adds a KVM selftest to validate the behavior of
> ARM's generic timer (patch-14). The test programs the timer IRQs
> periodically, and for each interrupt, it validates the behaviour
> against the architecture specifications. The test further provides
> a command-line interface to configure the number of vCPUs, the
> period of the timer, and the number of iterations that the test
> has to run for.
>
> Patch-15 adds an option to randomly migrate the vCPUs to different
> physical CPUs across the system. The bug for the fix provided by
> Marc with commit 3134cc8beb69d0d ("KVM: arm64: vgic: Resample HW
> pending state on deactivation") was discovered using arch_timer
> test with vCPU migrations.
>
> Since the test heavily depends on interrupts, patch-13 adds a host
> library to setup ARM Generic Interrupt Controller v3 (GICv3). This
> includes creating a vGIC device, setting up distributor and
> redistributor attributes, and mapping the guest physical addresses.
> Symmetrical to this, patch-12 adds a guest library to talk to the vGIC,
> which includes initializing the controller, enabling/disabling the
> interrupts, and so on.
>
> The following patches are utility patches that the above ones make use
> of:
> Patch-1 adds readl/writel support for guests to access MMIO space.
>
> Patch-2 imports arch/arm64/include/asm/sysreg.h into
> tools/arch/arm64/include/asm/ to make use of the register encodings
> and read/write definitions.
>
> Patch-3 is not directly related to the test, but makes
> aarch64/debug-exceptions.c use the read/write definitions from the
> imported sysreg.h and remove the existing definitions of read_sysreg()
> and write_sysreg().
>
> Patch-4 introduces ARM64_SYS_KVM_REG, that helps convert the SYS_*
> register encodings in sysreg.h to be acceptable by get_reg() and set_reg().
> It further replaces the users of ARM64_SYS_REG to use the new macro.
>
> Patch-5 adds the support for cpu_relax().
>
> Patch-6 adds basic arch_timer framework.
>
> Patch-7 adds udelay() support for the guests to utilize.
>
> Patch-8 adds local_irq_enable() and local_irq_disable() for the guests
> to enable/disable interrupts.
>
> Patch-9 is also unrelated to the test. It modifies the prototype of
> aarch64_vcpu_setup() to accept vcpuid as uint32_t, to keep it consistent
> with the other parts of code.
>
> Patch-10 adds the support to get the vcpuid for the guests. This allows
> them to access any cpu-centric private data in the upcoming patches.
>
> Patch-11 adds a light-weight support for spinlocks for the guests to
> use.
>
> The patch series, specifically the library support, is derived from the
> kvm-unit-tests and the kernel itself.
>
> Regards,
> Raghavendra
>
> v6 -> v7:
>
> Addressed comments by Andrew:
>
> - Changed the prototype of aarch64_vcpu_setup() to accept vcpuid as
>   uint32_t.
> - Modified the prototype of guest_get_vcpuid() to return uint32_t.
> - Renamed assert messages in lib/aarch64/vgic.c to use "Number".
>
> v5 -> v6:
>
> - Corrected the syntax for write_sysreg_s in gic_v3.c (11/14) so that
>   the file can be compiled with the unmodified
>   arch/arm64/include/asm/sysreg.h that's imported into tools/.
>
> v4 -> v5:
>
> Addressed the comments by Andrew, Oliver, and Reiji (Thanks, again):
> - Squashed patches 17/18 and 18/18 into 3/18 and 14/18, respectively.
> - Dropped patches to keep track kvm_utils of nr_vcpus (12/18) and
>   vm_get_mode() (13/18) as they were no longer needed.
> - Instead of creating the a map, exporting the vcpuid to the guest
>   is done by using the TPIDR_EL1 register.
> - Just to be on the safer side, gic.c's gic_dist_init() explicitly
>   checks if gic_ops is NULL.
> - Move sysreg.h from within selftests to tool/arch/arm64/include/asm/.
> - Rename ARM64_SYS_KVM_REG to KVM_ARM64_SYS_REG to improve readability.
> - Use the GIC regions' sizes from asm/kvm.h instead of re-defining it
>   in the vgic host support.
> - Get the timer IRQ numbers via timer's device attributes
>   (KVM_ARM_VCPU_TIMER_IRQ_PTIMER, KVM_ARM_VCPU_TIMER_IRQ_VTIMER) instead
>   of depending on default numbers to be safe.
> - Add check to see if the vCPU migrations are in fact enabled, before
>   looking for at least two online physical CPUs for the test.
> - Add missing blank lines in the arch_timer test.
>
> v3 -> v4:
>
> Addressed the comments by Andrew, Oliver, and Ricardo (Thank you):
> - Reimplemented get_vcpuid() by exporting a map of vcpuid:mpidr to the
>   guest.
> - Import sysreg.h from arch/arm64/include/asm/sysreg.h to get the system
>   register encodings and its read/write support. As a result, delete the
>   existing definitions in processor.h.
> - Introduce ARM64_SYS_KVM_REG that converts SYS_* register definitions
>   from sysreg.h into the encodings accepted by get_reg() and set_reg().
> - Hence, remove the existing encodings of system registers (CPACR_EL1,
>   TCR_EL1, and friends) and replace all the its consumers throughout
>   the selftests with ARM64_SYS_KVM_REG.
> - Keep track of number of vCPUs in 'struct kvm_vm'.
> - Add a helper method to get the KVM VM's mode.
> - Modify the vGIC host function vgic_v3_setup to make use of the above
>   two helper methods, which prevents it from accepting nr_vcpus as
>   an argument.
> - Move the definition of REDIST_REGION_ATTR_ADDR from lib/aarch64/vgic.c
>   to include/aarch64/vgic.h.
> - Make the selftest, vgic_init.c, use the definition of REDIST_REGION_ATTR_ADDR
>   from include/aarch64/vgic.h.
> - Turn ON vCPU migration by default (-m 2).
> - Add pr_debug() to log vCPU migrations. Helpful for diagnosis.
> - Change TEST_ASSERT(false,...) to TEST_FAIL() in the base arch_timer
>   test.
> - Include linux/types.h for __force definitions.
> - Change the type of 'val' to 'int' in spin_lock() to match the lock
>   value type.
> - Fix typos in code files and comments.
>
> v2 -> v3:
>
> - Addressed the comments from Ricardo regarding moving the vGIC host
>   support for selftests to its own library.
> - Added an option (-m) to migrate the guest vCPUs to physical CPUs
>   in the system.
>
> v1 -> v2:
>
> Addressed comments from Zenghui in include/aarch64/arch_timer.h:
> - Correct the header description
> - Remove unnecessary inclusion of linux/sizes.h
> - Re-arrange CTL_ defines in ascending order
> - Remove inappropriate 'return' from timer_set_* functions, which
>   returns 'void'.
>
> v1: https://lore.kernel.org/kvmarm/20210813211211.2983293-1-rananta@google.com/
> v2: https://lore.kernel.org/kvmarm/20210818184311.517295-1-rananta@google.com/
> v3: https://lore.kernel.org/kvmarm/20210901211412.4171835-1-rananta@google.com/
> v4: https://lore.kernel.org/kvmarm/20210909013818.1191270-1-rananta@google.com/
> v5: https://lore.kernel.org/kvmarm/20210913204930.130715-1-rananta@google.com/
> v6: https://lore.kernel.org/kvmarm/20210913230955.156323-1-rananta@google.com/
>
> Raghavendra Rao Ananta (15):
>   KVM: arm64: selftests: Add MMIO readl/writel support
>   tools: arm64: Import sysreg.h
>   KVM: arm64: selftests: Use read/write definitions from sysreg.h
>   KVM: arm64: selftests: Introduce ARM64_SYS_KVM_REG
>   KVM: arm64: selftests: Add support for cpu_relax
>   KVM: arm64: selftests: Add basic support for arch_timers
>   KVM: arm64: selftests: Add basic support to generate delays
>   KVM: arm64: selftests: Add support to disable and enable local IRQs
>   KVM: arm64: selftests: Maintain consistency for vcpuid type
>   KVM: arm64: selftests: Add guest support to get the vcpuid
>   KVM: arm64: selftests: Add light-weight spinlock support
>   KVM: arm64: selftests: Add basic GICv3 support
>   KVM: arm64: selftests: Add host support for vGIC
>   KVM: arm64: selftests: Add arch_timer test
>   KVM: arm64: selftests: arch_timer: Support vCPU migration
>
>  tools/arch/arm64/include/asm/sysreg.h         | 1296 +++++++++++++++++
>  tools/testing/selftests/kvm/.gitignore        |    1 +
>  tools/testing/selftests/kvm/Makefile          |    3 +-
>  .../selftests/kvm/aarch64/arch_timer.c        |  479 ++++++
>  .../selftests/kvm/aarch64/debug-exceptions.c  |   30 +-
>  .../selftests/kvm/aarch64/psci_cpu_on_test.c  |    2 +-
>  .../testing/selftests/kvm/aarch64/vgic_init.c |    3 +-
>  .../kvm/include/aarch64/arch_timer.h          |  142 ++
>  .../selftests/kvm/include/aarch64/delay.h     |   25 +
>  .../selftests/kvm/include/aarch64/gic.h       |   21 +
>  .../selftests/kvm/include/aarch64/processor.h |   90 +-
>  .../selftests/kvm/include/aarch64/spinlock.h  |   13 +
>  .../selftests/kvm/include/aarch64/vgic.h      |   20 +
>  .../testing/selftests/kvm/include/kvm_util.h  |    2 +
>  tools/testing/selftests/kvm/lib/aarch64/gic.c |   95 ++
>  .../selftests/kvm/lib/aarch64/gic_private.h   |   21 +
>  .../selftests/kvm/lib/aarch64/gic_v3.c        |  240 +++
>  .../selftests/kvm/lib/aarch64/gic_v3.h        |   70 +
>  .../selftests/kvm/lib/aarch64/processor.c     |   24 +-
>  .../selftests/kvm/lib/aarch64/spinlock.c      |   27 +
>  .../testing/selftests/kvm/lib/aarch64/vgic.c  |   70 +
>  21 files changed, 2626 insertions(+), 48 deletions(-)
>  create mode 100644 tools/arch/arm64/include/asm/sysreg.h
>  create mode 100644 tools/testing/selftests/kvm/aarch64/arch_timer.c
>  create mode 100644 tools/testing/selftests/kvm/include/aarch64/arch_timer.h
>  create mode 100644 tools/testing/selftests/kvm/include/aarch64/delay.h
>  create mode 100644 tools/testing/selftests/kvm/include/aarch64/gic.h
>  create mode 100644 tools/testing/selftests/kvm/include/aarch64/spinlock.h
>  create mode 100644 tools/testing/selftests/kvm/include/aarch64/vgic.h
>  create mode 100644 tools/testing/selftests/kvm/lib/aarch64/gic.c
>  create mode 100644 tools/testing/selftests/kvm/lib/aarch64/gic_private.h
>  create mode 100644 tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
>  create mode 100644 tools/testing/selftests/kvm/lib/aarch64/gic_v3.h
>  create mode 100644 tools/testing/selftests/kvm/lib/aarch64/spinlock.c
>  create mode 100644 tools/testing/selftests/kvm/lib/aarch64/vgic.c
>
> --
> 2.33.0.309.g3052b89438-goog
>
