Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1088F4313D5
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 11:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbhJRJym (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 05:54:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbhJRJyl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Oct 2021 05:54:41 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4C3AC06161C
        for <kvm@vger.kernel.org>; Mon, 18 Oct 2021 02:52:30 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id s18-20020a0568301e1200b0054e77a16651so2560281otr.7
        for <kvm@vger.kernel.org>; Mon, 18 Oct 2021 02:52:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hIvrEUDH4eO0WYJ4PqJYB49yqlYXOG/SemvYMWXPzyU=;
        b=HIxagS8WVeBE+G0ajyTJaAZdzxBaPmgZ+XMi01ATbiVxu+clkd0Bz18OdiZgOtmSD7
         cHkARs/25XkG6o5e2c5DYFpyeaqzpJ3hll/HXce3Zu+fzjAeDhEViSGG4n5NSu4VHpAK
         kS41yZx1OWhbnZ1oGLTCOZHDQ00vJhfZHwHWhRMjo3YFLUJEM24PXUzLAX6KNtWcIPKg
         B1VtBf8zTh4/BhuO5HZvNuApQUkbwcU+Ue+KFPtlZw9GlLYGan4W2ve8Ba/SPRQx8JG7
         caFgv+79cmRM2Pn7v2/wVRS7kEIEvYZ52lrDPI49WkHCp7njfE0tuIJeypQH+BR57BrF
         JN1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hIvrEUDH4eO0WYJ4PqJYB49yqlYXOG/SemvYMWXPzyU=;
        b=p064eVPT0XGO0DEHhEqts+GBB+akpC1bW1zxjCx2IH4CXKUGYUHBFEKGycOarNz3f2
         hc8PAb4r10UJdzly3WVAR2wfNpE8cljXni8IOYns2JLqZQi97/3yEcGDEkm4vTVpCAaz
         Q67Vd/y1bpO7+dGttTvdcAW3FTCJ03Ss/VRscElTzJ5zgdEYfo4Rzy0lpxlys0fiWmCF
         ay51OxoTBvZ0gE26xl6emu9gkPKz+NKQn+qPheJOH5R9xKaKklEa9Uk/UQlBiMVBicCS
         sEDmiqIICx+tu19aZkSa5CMz5xvT4ZM06T1wR4xyxzxixx3lT0TIxTTbi55bYw5q5IA+
         d7sg==
X-Gm-Message-State: AOAM531+U16b/fYmZQHT+FCYhlcu6yZ3LCIymzEw5HDsYKB223nTWxRt
        SwEl1/AoPWTyo2T3ZC8ItnjF/H7Abp9XjxqtT4t9wA==
X-Google-Smtp-Source: ABdhPJzWZHsVsaIL9xeEZSzoCxSaBPHvIjAdCQFyH94KbtFqpNnFfKiOBxLaRi9JpKRLWzlcKnSs/4ctWMJp6q2c9Cg=
X-Received: by 2002:a05:6830:210c:: with SMTP id i12mr20576774otc.102.1634550749852;
 Mon, 18 Oct 2021 02:52:29 -0700 (PDT)
MIME-Version: 1.0
References: <20211010145636.1950948-12-tabba@google.com> <20211013120346.2926621-1-maz@kernel.org>
In-Reply-To: <20211013120346.2926621-1-maz@kernel.org>
From:   Fuad Tabba <tabba@google.com>
Date:   Mon, 18 Oct 2021 10:51:54 +0100
Message-ID: <CA+EHjTxBW2fzSk5wMLceRwExqJwXGTtrK1GZ2L6J-Oh9VCDJJg@mail.gmail.com>
Subject: Re: [PATCH v9 00/22] KVM: arm64: Fixed features for protected VMs
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, will@kernel.org,
        james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, mark.rutland@arm.com, pbonzini@redhat.com,
        drjones@redhat.com, oupton@google.com, qperret@google.com,
        kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Wed, Oct 13, 2021 at 1:04 PM Marc Zyngier <maz@kernel.org> wrote:
>
> This is an update on Fuad's series[1].
>
> Instead of going going back and forth over a series that has seen a
> fair few versions, I've opted for simply writing a set of fixes on
> top, hopefully greatly simplifying the handling of most registers, and
> moving things around to suit my own taste (just because I can).
>
> I won't be reposting the initial 11 patches, which is why this series
> in is reply to patch 11.

Thanks for this series. I've reviewed, built it, and tested it with a
dummy protected VM (since we don't have proper protected VMs yet),
which initializes some of the relevant protected VMs metadata as well
as its control registers. So fwiw:

Reviewed-by: Fuad Tabba <tabba@google.com>

And to whatever extent possible at this stage:
Tested-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad





> Thanks,
>
>         M.
>
> [1] https://lore.kernel.org/r/20211010145636.1950948-1-tabba@google.com
>
> Fuad Tabba (8):
>   KVM: arm64: Pass struct kvm to per-EC handlers
>   KVM: arm64: Add missing field descriptor for MDCR_EL2
>   KVM: arm64: Simplify masking out MTE in feature id reg
>   KVM: arm64: Add handlers for protected VM System Registers
>   KVM: arm64: Initialize trap registers for protected VMs
>   KVM: arm64: Move sanitized copies of CPU features
>   KVM: arm64: Trap access to pVM restricted features
>   KVM: arm64: Handle protected guests at 32 bits
>
> Marc Zyngier (14):
>   KVM: arm64: Move __get_fault_info() and co into their own include file
>   KVM: arm64: Don't include switch.h into nvhe/kvm-main.c
>   KVM: arm64: Move early handlers to per-EC handlers
>   KVM: arm64: Fix early exit ptrauth handling
>   KVM: arm64: pkvm: Use a single function to expose all id-regs
>   KVM: arm64: pkvm: Make the ERR/ERX*_EL1 registers RAZ/WI
>   KVM: arm64: pkvm: Drop AArch32-specific registers
>   KVM: arm64: pkvm: Drop sysregs that should never be routed to the host
>   KVM: arm64: pkvm: Handle GICv3 traps as required
>   KVM: arm64: pkvm: Preserve pending SError on exit from AArch32
>   KVM: arm64: pkvm: Consolidate include files
>   KVM: arm64: pkvm: Move kvm_handle_pvm_restricted around
>   KVM: arm64: pkvm: Pass vpcu instead of kvm to
>     kvm_get_exit_handler_array()
>   KVM: arm64: pkvm: Give priority to standard traps over pvm handling
>
>  arch/arm64/include/asm/kvm_arm.h              |   1 +
>  arch/arm64/include/asm/kvm_asm.h              |   1 +
>  arch/arm64/include/asm/kvm_host.h             |   2 +
>  arch/arm64/include/asm/kvm_hyp.h              |   5 +
>  arch/arm64/kvm/arm.c                          |  13 +
>  arch/arm64/kvm/hyp/include/hyp/fault.h        |  75 +++
>  arch/arm64/kvm/hyp/include/hyp/switch.h       | 235 ++++-----
>  .../arm64/kvm/hyp/include/nvhe/fixed_config.h | 200 +++++++
>  .../arm64/kvm/hyp/include/nvhe/trap_handler.h |   2 +
>  arch/arm64/kvm/hyp/nvhe/Makefile              |   2 +-
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  11 +-
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c         |   8 +-
>  arch/arm64/kvm/hyp/nvhe/pkvm.c                | 185 +++++++
>  arch/arm64/kvm/hyp/nvhe/setup.c               |   3 +
>  arch/arm64/kvm/hyp/nvhe/switch.c              |  99 ++++
>  arch/arm64/kvm/hyp/nvhe/sys_regs.c            | 487 ++++++++++++++++++
>  arch/arm64/kvm/hyp/vhe/switch.c               |  16 +
>  arch/arm64/kvm/sys_regs.c                     |  10 +-
>  18 files changed, 1200 insertions(+), 155 deletions(-)
>  create mode 100644 arch/arm64/kvm/hyp/include/hyp/fault.h
>  create mode 100644 arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
>  create mode 100644 arch/arm64/kvm/hyp/nvhe/pkvm.c
>  create mode 100644 arch/arm64/kvm/hyp/nvhe/sys_regs.c
>
> --
> 2.30.2
>
