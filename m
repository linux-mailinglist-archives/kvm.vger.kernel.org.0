Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 350F03FE535
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 00:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243571AbhIAWGJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 18:06:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243091AbhIAWGI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Sep 2021 18:06:08 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75E7BC061575
        for <kvm@vger.kernel.org>; Wed,  1 Sep 2021 15:05:11 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id u7so813164ilk.7
        for <kvm@vger.kernel.org>; Wed, 01 Sep 2021 15:05:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+DuLck7trE3/jeuLJyQqFOD4gSDy3mwIoW3d+ThIoWc=;
        b=ue60hZ708cIr7G42kkYJi/pAO26l3GQIlDpRhHkRx9vrX7fkrGwcxv381hWQHI/80W
         u697z+xufWYfztWIL9kzUPbDj+ybhEp3ZG4QiSDxRsFBVYWZhhiadTaAty6AcHC1yd9s
         +RtPFgqGxGPHaBXwIGpGCa/G0bn8zAC5+mwkup6bTH+Ybsz7vXo5hFvzG7kxwf5kJnQX
         mCOcBpbHGFnARtedqKBlXB95AWHySM3o4dW9WeC4PFn7tLnsDhQQFB0XSPli72Glti9S
         5PNsiN0EZfP0B1y9voI1vv+Wx7UuCoYBBbTI5YMtJ9ZqNUut17oqsZ4+Y1pvn+g+sG9N
         NP2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+DuLck7trE3/jeuLJyQqFOD4gSDy3mwIoW3d+ThIoWc=;
        b=nKV56jlt9aO6VIot5kwSg/W6GnErZ5O11tKVHR7vEfqHOuyMtNPra8fN8RdRP6/Rcr
         5J5Y7d9yaow5TCJUA5Pj7hNAQ6IMwBiX7x4LKGiZtNYbI1PxGLeA679EXBgz2WzQkxfV
         cklxvJXaJzYoH1LMPo+DwjiOANYsCL5en6u0MVWHsc3lJIEpyYRTGE2tQGAE6kb6Fm8O
         I5sgjibANFiqm2tOT4UIBMc2xUQRpNw4nsEwnNbNijlqVrcESCMqXYwJ4Septkli8ezu
         rh7WWknBYjSmcIBH4yxFs1N7J1xpJL4mdn2p7vAo0qH9r7gufGOsYtdf5wkUHzYTuqK+
         QWYA==
X-Gm-Message-State: AOAM530kYfYL2URXhcMbB+XcEOWScevbf0avlWu/D2wMtMp2UVJVmQCP
        WTs7ZozUKYQbFsY1yyZt7D8oNg==
X-Google-Smtp-Source: ABdhPJyz03AQjKq617pC8w9b66FNA0eCW4EBtDeYY+hkxM2sCWzfoOh7yUadawftcIzUoT8TCwMRug==
X-Received: by 2002:a92:c609:: with SMTP id p9mr1138171ilm.135.1630533910160;
        Wed, 01 Sep 2021 15:05:10 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id h9sm518789ioz.30.2021.09.01.15.05.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 15:05:09 -0700 (PDT)
Date:   Wed, 1 Sep 2021 22:05:06 +0000
From:   Oliver Upton <oupton@google.com>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        drjones@redhat.com
Subject: Re: [PATCH v3 00/12] KVM: arm64: selftests: Introduce arch_timer
 selftest
Message-ID: <YS/5EjjPSWjWb6BI@google.com>
References: <20210901211412.4171835-1-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210901211412.4171835-1-rananta@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+cc Andrew Jones

On Wed, Sep 01, 2021 at 09:14:00PM +0000, Raghavendra Rao Ananta wrote:
> Hello,
> 
> The patch series adds a KVM selftest to validate the behavior of
> ARM's generic timer (patch-11). The test programs the timer IRQs
> periodically, and for each interrupt, it validates the behaviour
> against the architecture specifications. The test further provides
> a command-line interface to configure the number of vCPUs, the
> period of the timer, and the number of iterations that the test
> has to run for.
> 
> Patch-12 adds an option to randomly migrate the vCPUs to different
> physical CPUs across the system. The bug for the fix provided by
> Marc with commit 3134cc8beb69d0d ("KVM: arm64: vgic: Resample HW
> pending state on deactivation") was discovered using arch_timer
> test with vCPU migrations.
> 
> Since the test heavily depends on interrupts, patch-10 adds a host
> library to setup ARM Generic Interrupt Controller v3 (GICv3). This
> includes creating a vGIC device, setting up distributor and
> redistributor attributes, and mapping the guest physical addresses.
> Symmetrical to this, patch-9 adds a guest library to talk to the vGIC,
> which includes initializing the controller, enabling/disabling the
> interrupts, and so on.
> 
> Furthermore, additional processor utilities such as accessing the MMIO
> (via readl/writel), read/write to assembler unsupported registers,
> basic delay generation, enable/disable local IRQs, and so on, are also
> introduced that the test/GICv3 takes advantage of (patches 1 through 8).
> 
> The patch series, specifically the library support, is derived from the
> kvm-unit-tests and the kernel itself.
> 
> Regards,
> Raghavendra
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
> Raghavendra Rao Ananta (12):
>   KVM: arm64: selftests: Add MMIO readl/writel support
>   KVM: arm64: selftests: Add write_sysreg_s and read_sysreg_s
>   KVM: arm64: selftests: Add support for cpu_relax
>   KVM: arm64: selftests: Add basic support for arch_timers
>   KVM: arm64: selftests: Add basic support to generate delays
>   KVM: arm64: selftests: Add support to disable and enable local IRQs
>   KVM: arm64: selftests: Add support to get the vcpuid from MPIDR_EL1
>   KVM: arm64: selftests: Add light-weight spinlock support
>   KVM: arm64: selftests: Add basic GICv3 support
>   KVM: arm64: selftests: Add host support for vGIC
>   KVM: arm64: selftests: Add arch_timer test
>   KVM: arm64: selftests: arch_timer: Support vCPU migration
> 
>  tools/testing/selftests/kvm/.gitignore        |   1 +
>  tools/testing/selftests/kvm/Makefile          |   3 +-
>  .../selftests/kvm/aarch64/arch_timer.c        | 457 ++++++++++++++++++
>  .../kvm/include/aarch64/arch_timer.h          | 142 ++++++
>  .../selftests/kvm/include/aarch64/delay.h     |  25 +
>  .../selftests/kvm/include/aarch64/gic.h       |  21 +
>  .../selftests/kvm/include/aarch64/processor.h | 140 +++++-
>  .../selftests/kvm/include/aarch64/spinlock.h  |  13 +
>  .../selftests/kvm/include/aarch64/vgic.h      |  14 +
>  tools/testing/selftests/kvm/lib/aarch64/gic.c |  93 ++++
>  .../selftests/kvm/lib/aarch64/gic_private.h   |  21 +
>  .../selftests/kvm/lib/aarch64/gic_v3.c        | 240 +++++++++
>  .../selftests/kvm/lib/aarch64/gic_v3.h        |  70 +++
>  .../selftests/kvm/lib/aarch64/spinlock.c      |  27 ++
>  .../testing/selftests/kvm/lib/aarch64/vgic.c  |  67 +++
>  15 files changed, 1332 insertions(+), 2 deletions(-)
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
> 2.33.0.153.gba50c8fa24-goog
> 
