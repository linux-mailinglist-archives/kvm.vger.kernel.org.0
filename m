Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7B1F6BBAAF
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 18:16:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbjCORQt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 13:16:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbjCORQs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 13:16:48 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 933631A4A9
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 10:16:47 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id j7-20020a17090aeb0700b0023d19dfe884so1245192pjz.4
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 10:16:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678900607;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=x/aF4Es41tXjL7SKFsAs+MrZMJLEL8H3oIxff+R9CG4=;
        b=gV4ywxElAUQQ95X+ZnUag11P8fOeUU5/FuJNXgvuVVqqwzWa9UVMzK4YuACa9iarwg
         U8PBDr4gk47JL0PBAbz4rjbfHjgoU538eo5UhJcmg6Ljokw1pMXoSJWegHklt2RtxmhR
         0iGlr/3Y11mSOlpBxa+tZODXHTrCrJO/oOSvWQnIANjeZ5rDF3VK3oDnNZW9TseqcSq6
         B8qb9ZSg1kA/UAryZhn3q8KFMSUhdTAKqMwrnWhfYD7pfrmDK3CHJjYyd/q7aD+ysrGz
         yifV/dC28ydJLwXa1FnFaii8yj8TyA8J+55bnll+chj1C20vY5zPpyJ1XgPR2byljT/T
         H6rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678900607;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x/aF4Es41tXjL7SKFsAs+MrZMJLEL8H3oIxff+R9CG4=;
        b=vtNz8ekFOyHhAUzDhugpIlhCs3yCMmBVLtJ4ZFUqluzD8hziQPaOGdKeA/Wud2tLd7
         SGm2Bz+LaL1LTDNF9fZsLFnhCrgg9NfFbmtRoIjS5MUk8G/acqwbkBKz14w/ltw9co+k
         jaWRvVTbUmI1bAiCgw+Nby7Tj1zOzasxNnANwNFSacSv748qHNETlaC7YiMowFbH6uM+
         ZIotCGyYP/+uNP+Pk8xkU2bMr1//3QUHm/JQ5DaOoNuX14G3D8Gw8KPINS6Bolh0pxLq
         WOxULN7W3btSQBoVA1gYWFTdB5lAq+okKAzZIi+hQna5H432ql1Es1YxL7CMIv68D2wj
         XDYQ==
X-Gm-Message-State: AO0yUKUwkIwid8ZteOdtRPbkTanQIXtWOSrYVF1RXpXpnURRnEyjbP5S
        bM332ZWaA8eJF+jUAvuInBynDRBWJmQ=
X-Google-Smtp-Source: AK7set8rJXOntLa7QM2hdktYoMgS9UfLnxiJhuIiWnthSPQ6oY1Np9ERejXRNpUdaoysiVc8NpsTJJwcmvs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:6386:0:b0:4fb:a38d:c09b with SMTP id
 h6-20020a656386000000b004fba38dc09bmr906pgv.10.1678900607084; Wed, 15 Mar
 2023 10:16:47 -0700 (PDT)
Date:   Wed, 15 Mar 2023 10:16:45 -0700
In-Reply-To: <20221003235722.2085145-1-aik@ozlabs.ru>
Mime-Version: 1.0
References: <20221003235722.2085145-1-aik@ozlabs.ru>
Message-ID: <ZBH9fZ3aMnHKtrZj@google.com>
Subject: Re: [PATCH kernel v4] KVM: PPC: Make KVM_CAP_IRQFD_RESAMPLE support
 platform dependent
From:   Sean Christopherson <seanjc@google.com>
To:     Alexey Kardashevskiy <aik@ozlabs.ru>
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm-riscv@lists.infradead.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Anup Patel <anup@brainfault.org>, kvm-ppc@vger.kernel.org,
        Nicholas Piggin <npiggin@gmail.com>,
        Marc Zyngier <maz@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+Michael and KVM s390 maintainers

On Tue, Oct 04, 2022, Alexey Kardashevskiy wrote:
> When introduced, IRQFD resampling worked on POWER8 with XICS. However
> KVM on POWER9 has never implemented it - the compatibility mode code
> ("XICS-on-XIVE") misses the kvm_notify_acked_irq() call and the native
> XIVE mode does not handle INTx in KVM at all.
> 
> This moved the capability support advertising to platforms and stops
> advertising it on XIVE, i.e. POWER9 and later.
> 
> This should cause no behavioural change for other architectures.
> 
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> Acked-by: Nicholas Piggin <npiggin@gmail.com>
> Acked-by: Marc Zyngier <maz@kernel.org>
> ---

If no one objects, I'll grab this for 6.4 and route it through kvm-x86/generic.

> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
> index fb1490761c87..908ce8bd91c9 100644
> --- a/arch/powerpc/kvm/powerpc.c
> +++ b/arch/powerpc/kvm/powerpc.c
> @@ -593,6 +593,12 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>                 break;
>  #endif
>
> +#ifdef CONFIG_HAVE_KVM_IRQFD
> +       case KVM_CAP_IRQFD_RESAMPLE:
> +               r = !xive_enabled();
> +               break;
> +#endif

@PPC folks, do you want to avoid the #ifdef?  If so, I can tweak to this when
applying.

	case KVM_CAP_IRQFD_RESAMPLE:
		r = IS_ENABLED(CONFIG_HAVE_KVM_IRQFD) && !xive_enabled();
		break;
