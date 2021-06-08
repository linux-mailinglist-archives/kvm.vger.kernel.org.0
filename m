Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1705339F9F3
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 17:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233788AbhFHPJl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 11:09:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20586 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233757AbhFHPJl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 8 Jun 2021 11:09:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623164868;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8oEC6CaaT/gHb7RKpF7zDNUqX2rhoUKcZ31i04rDTCw=;
        b=cuHT8aUXTpwJbJdqDztrszZkYsiLIK+23sZkOKA5UmOeT1XJp3yHSfU4Ta3lGhwVqwjjue
        nCrBrVW92xTUV7hnxmHIdwrqPXzQtNm91vEIdEoDqWpnviQ7DZjifpXA6fAa/97sMHsabj
        F3PP785ztuuFGvgNwGcNsWwSjKt92EI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-463-V1SwI8m0N4isR4nAhzme7g-1; Tue, 08 Jun 2021 11:07:44 -0400
X-MC-Unique: V1SwI8m0N4isR4nAhzme7g-1
Received: by mail-wr1-f71.google.com with SMTP id h104-20020adf90710000b029010de8455a3aso9582798wrh.12
        for <kvm@vger.kernel.org>; Tue, 08 Jun 2021 08:07:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8oEC6CaaT/gHb7RKpF7zDNUqX2rhoUKcZ31i04rDTCw=;
        b=uAdBactxpQ0BPIPzB4kyxqDBwJeDLF6ppIyS+9muh5wWPOU2E1uuTdLi7NNl0ukAiR
         5Cr/xCPzgePbS+JQ21uFJPWDUi96udofhs8PLXJ6Zn2GzYx6YPqhzrI+aJ10k3knymR0
         cJ5y/Ep+q5UVBv1hFgB58V3Cs2va8rxA1+jh6PZr2EtWodK2Ckhvsl67+fZ6a+SK8HG9
         dr1SNGqbIl2Quvhe7Q8enWT0lTLRYEM5D7vrp8pLRDGCcPAKyb9+0NrVjkAom16syeE3
         +Th7h+kD4DEQtqpvG7o/5rLdnOjO7JZT21If6/TKJmjM4AyrJXPW3pgbRRAxRe+qh9jQ
         igiQ==
X-Gm-Message-State: AOAM532wBbAw9rs/RF6ArEG7Hup5cArCdwGk1I+rxFDYJ4A+zPxPuRDP
        tWS1ecSdhdllIBSKcHcqNJj0OGtzKqSX2okiZzi9V3whxLmQgQl35xRedv0WM3DRcWz9Hct0e9q
        snudRXIqppbuV
X-Received: by 2002:a1c:9dcd:: with SMTP id g196mr4843706wme.135.1623164863490;
        Tue, 08 Jun 2021 08:07:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwKDtNOesB1A4Sct7Gz5HSXh1eFBM+EnmhLeEvmHG0eAj+H0vieU7hbUe51VQ8Q4K+A899ZEQ==
X-Received: by 2002:a1c:9dcd:: with SMTP id g196mr4843685wme.135.1623164863293;
        Tue, 08 Jun 2021 08:07:43 -0700 (PDT)
Received: from gator (93-137-73-123.adsl.net.t-com.hr. [93.137.73.123])
        by smtp.gmail.com with ESMTPSA id h15sm2054583wrq.88.2021.06.08.08.07.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 08:07:42 -0700 (PDT)
Date:   Tue, 8 Jun 2021 17:07:39 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Fuad Tabba <tabba@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, kernel-team@android.com,
        kvm@vger.kernel.org, maz@kernel.org, pbonzini@redhat.com,
        will@kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v1 00/13] KVM: arm64: Fixed features for protected VMs
Message-ID: <20210608150739.7ztstw52ynxh6m5p@gator>
References: <20210608141141.997398-1-tabba@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210608141141.997398-1-tabba@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 08, 2021 at 03:11:28PM +0100, Fuad Tabba wrote:
> Hi,
> 
> This patch series adds support for restricting CPU features for protected VMs
> in KVM [1].
> 
> Various feature configurations are allowed in KVM/arm64. Supporting all
> these features in pKVM is difficult, as it either involves moving much of
> the handling code to EL2, which adds bloat and results in a less verifiable
> trusted code base. Or it involves leaving the code handling at EL1, which
> risks having an untrusted host kernel feeding wrong information to the EL2
> and to the protected guests.
> 
> This series attempts to mitigate this by reducing the configuration space,
> providing a reduced amount of feature support at EL2 with the least amount of
> compromise of protected guests' capabilities.
> 
> This is done by restricting CPU features exposed to protected guests through
> feature registers. These restrictions are enforced by trapping register
> accesses as well as instructions associated with these features, and injecting
> an undefined exception into the guest if it attempts to use a restricted
> feature.
> 
> The features being restricted (only for protected VMs in protected mode) are
> the following:
> - Debug, Trace, and DoubleLock
> - Performance Monitoring (PMU)
> - Statistical Profiling (SPE)
> - Scalable Vector Extension (SVE)
> - Memory Partitioning and Monitoring (MPAM)
> - Activity Monitoring (AMU)
> - Memory Tagging (MTE)
> - Limited Ordering Regions (LOR)
> - AArch32 State
> - Generic Interrupt Controller (GIC) (depending on rVIC support)
> - Nested Virtualization (NV)
> - Reliability, Availability, and Serviceability (RAS) above V1
> - Implementation-defined Features

Hi Fuad,

I see this series takes the approach we currently have in KVM of masking
features we don't want to expose to the guest. This approach adds yet
another "reject list" to be maintained as hardware evolves. I'd rather see
that we first change KVM to using an accept list, i.e. mask everything and
then only set what we want to enable. Mimicking that new accept list in
pKVM, where much less would be enabled, would reduce the amount of
maintenance needed.

Thanks,
drew

> 
> This series is based on kvmarm/next and Will's patches for an Initial pKVM user
> ABI [1]. You can find the applied series here [2].
> 
> Cheers,
> /fuad
> 
> [1] https://lore.kernel.org/kvmarm/20210603183347.1695-1-will@kernel.org/
> 
> For more details about pKVM, please refer to Will's talk at KVM Forum 2020:
> https://www.youtube.com/watch?v=edqJSzsDRxk
> 
> [2] https://android-kvm.googlesource.com/linux/+/refs/heads/tabba/el2_fixed_feature_v1
> 
> To: kvmarm@lists.cs.columbia.edu
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Will Deacon <will@kernel.org>
> Cc: James Morse <james.morse@arm.com>
> Cc: Alexandru Elisei <alexandru.elisei@arm.com>
> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Christoffer Dall <christoffer.dall@arm.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Quentin Perret <qperret@google.com>
> Cc: kvm@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: kernel-team@android.com
> 
> Fuad Tabba (13):
>   KVM: arm64: Remove trailing whitespace in comments
>   KVM: arm64: MDCR_EL2 is a 64-bit register
>   KVM: arm64: Fix name of HCR_TACR to match the spec
>   KVM: arm64: Refactor sys_regs.h,c for nVHE reuse
>   KVM: arm64: Restore mdcr_el2 from vcpu
>   KVM: arm64: Add feature register flag definitions
>   KVM: arm64: Add config register bit definitions
>   KVM: arm64: Guest exit handlers for nVHE hyp
>   KVM: arm64: Add trap handlers for protected VMs
>   KVM: arm64: Move sanitized copies of CPU features
>   KVM: arm64: Trap access to pVM restricted features
>   KVM: arm64: Handle protected guests at 32 bits
>   KVM: arm64: Check vcpu features at pVM creation
> 
>  arch/arm64/include/asm/kvm_arm.h        |  34 +-
>  arch/arm64/include/asm/kvm_asm.h        |   2 +-
>  arch/arm64/include/asm/kvm_host.h       |   2 +-
>  arch/arm64/include/asm/kvm_hyp.h        |   4 +
>  arch/arm64/include/asm/sysreg.h         |   6 +
>  arch/arm64/kvm/arm.c                    |   4 +
>  arch/arm64/kvm/debug.c                  |   5 +-
>  arch/arm64/kvm/hyp/include/hyp/switch.h |  42 ++
>  arch/arm64/kvm/hyp/nvhe/Makefile        |   2 +-
>  arch/arm64/kvm/hyp/nvhe/debug-sr.c      |   2 +-
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c   |   6 -
>  arch/arm64/kvm/hyp/nvhe/switch.c        | 114 +++++-
>  arch/arm64/kvm/hyp/nvhe/sys_regs.c      | 501 ++++++++++++++++++++++++
>  arch/arm64/kvm/hyp/vhe/debug-sr.c       |   2 +-
>  arch/arm64/kvm/pkvm.c                   |  31 ++
>  arch/arm64/kvm/sys_regs.c               |  62 +--
>  arch/arm64/kvm/sys_regs.h               |  35 ++
>  17 files changed, 782 insertions(+), 72 deletions(-)
>  create mode 100644 arch/arm64/kvm/hyp/nvhe/sys_regs.c
> 
> 
> base-commit: 35b256a5eebe3ac715b4ea6234aa4236a10d1a88
> -- 
> 2.32.0.rc1.229.g3e70b5a671-goog
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> 

