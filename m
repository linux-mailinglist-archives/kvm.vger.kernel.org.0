Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5776763B44E
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 22:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234310AbiK1VkY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 16:40:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234276AbiK1VkD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 16:40:03 -0500
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 636772B615;
        Mon, 28 Nov 2022 13:40:02 -0800 (PST)
Received: by mail-wm1-f50.google.com with SMTP id 83-20020a1c0256000000b003d03017c6efso12125652wmc.4;
        Mon, 28 Nov 2022 13:40:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PuADqb5ObhzEay83Rgmmr1DjvxatfIL6idtDUz9yxI4=;
        b=C6xpSCTW3Z/VKrA8D6cruFuz5UfhIHi6yVPyt/AgaKPj5gjYRJrXnDw1+Wm5fpmeGE
         1HZ9FCKOSQWiZy8PHs/dxK7GXE0Y4vEhvrLm7qOpTIZz+T7uDBnM6bhJWzkLNxhfTrt5
         G22oI6ox2js94+/wHp9XlIf67yK09Sv9ftmjdjzIszYziOGn0El8bznDcuGY1LPk9jcv
         48ZoJny5J0Op7ocjXj5Nja5ByWMh25wSU1UBW9Dzr3cwI+Vd8zz6LRwbQcHaonDCHFSy
         cW1p42UrvzqIXbfgDZowdwdD6bYJTyBOxa6EilJjITIWqo7kZfvBcSlnWOR5GBRBxigX
         MlhA==
X-Gm-Message-State: ANoB5pk3KDLS450cOTK1Qf5T55LlNSJBzf3Pg1AR8sPQxVphcAa5nqKe
        cKybZGj5tESLANxaEtUIeYk=
X-Google-Smtp-Source: AA0mqf4jl/SNFyThnBoPGJGYxLKgxzanGCNlLcmlaw2dWgCUMSZ38ex9VgfvPd0+RTIeLoijC35l/Q==
X-Received: by 2002:a05:600c:5388:b0:3cf:37b1:e581 with SMTP id hg8-20020a05600c538800b003cf37b1e581mr37853395wmb.96.1669671600900;
        Mon, 28 Nov 2022 13:40:00 -0800 (PST)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id i11-20020a5d438b000000b00241b5af8697sm11614853wrq.85.2022.11.28.13.39.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 13:40:00 -0800 (PST)
Date:   Mon, 28 Nov 2022 21:39:58 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Wei Liu <wei.liu@kernel.org>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86/mmu: fix an incorrect comment in kvm_mmu_new_pgd
Message-ID: <Y4Uqrs7SBDCKISll@liuwe-devbox-debian-v2>
References: <20221127221245.204208-1-wei.liu@kernel.org>
 <Y4T3xsxszDShKqK0@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4T3xsxszDShKqK0@google.com>
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 28, 2022 at 06:02:46PM +0000, Sean Christopherson wrote:
> On Sun, Nov 27, 2022, Wei Liu wrote:
> > There is no function named kvm_mmu_ensure_valid_pgd.
> 
> () when referecing functions, here and in the comment.
> 
> > Fix the comment and remove the pair of braces to conform to Linux kernel
> > coding style.
> > 
> > Signed-off-by: Wei Liu <wei.liu@kernel.org>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 8 +++++---
> >  1 file changed, 5 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index b6f96d47e596..361574124fbe 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -4452,10 +4452,12 @@ void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd)
> >  	struct kvm_mmu *mmu = vcpu->arch.mmu;
> >  	union kvm_mmu_page_role new_role = mmu->root_role;
> >  
> > -	if (!fast_pgd_switch(vcpu->kvm, mmu, new_pgd, new_role)) {
> > -		/* kvm_mmu_ensure_valid_pgd will set up a new root.  */
> > +	/*
> > +	 * Return immediately if no usable root is found. A new root will be
> 
> s/is/was
> 
> And technically, it may not be a "new" root, e.g. if a different vCPU creates a
> usable root between now and kvm_mmu_reload().
> 
> > +	 * set up in vcpu_enter_guest prior to the next vmenter.
> 
> s/vmenter/VM-Enter
> 
> Pointing a reader at vcpu_enter_guest() isn't very helpful since that's a massive
> function; kvm_mmu_reload() is where the real magic happens.  I generally prefer to
> avoid referencing functions in comments unless doing so is absolutely "necessary"
> because such comments always seem to become stale, but in this case I think it's
> worthwhile.
> 
> 	/*
> 	 * Return immediately if no usable was found, kvm_mmu_reload() will
> 	 * establish a valid root prior to the next VM-Enter.
> 	 */
> 

Thanks for the feedback. v2 coming shortly.

Thanks,
Wei.
