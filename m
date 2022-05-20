Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5265B52EE68
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 16:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350424AbiETOrp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 10:47:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350418AbiETOrl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 10:47:41 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F1C1163F47
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 07:47:40 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id o13-20020a17090a9f8d00b001df3fc52ea7so11679614pjp.3
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 07:47:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zVVHAEEmHtd6Xr1McHOOkF0bHjzq13Enfst+KzXC/fA=;
        b=DCZOfv5818BEulYuDkt1d5/g2ITF2okgF+6PJMwvkD0fgu5Aa2YIoQPEyecGL6bh9p
         hMa9nSYl5TyGmC4gPhbGU1iGJ1ZO1m6IHH+IUot105yWqOqbM8kHZk+4yrW8QvVRLb9q
         U3CmR6eV0/k1ZEH5FoaeZJQQAkXxV6awd0Uc31bQ1EqDu829RQhpALl0NQR3iOf66CDx
         IhKCcel2A26b08DMzRqlbPkOLYoaaGFQ2HDQX4kFf+lMpFe97qbRoS09i+44LuwQgbMv
         KZf248psQ6XGj1Fp2RjxcX9K9t9nC3qjwieNEPNX4Xfnn07biL+v5fQ4dPm/jl2O+RTG
         LGzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zVVHAEEmHtd6Xr1McHOOkF0bHjzq13Enfst+KzXC/fA=;
        b=FKU4K212FZ6+10Mrc9y6bh/EEHAdj7FrKYTVQWY5mDWFbA25H862zkVEjnsb0ya0nn
         whVA8Xqbo1/bvHk9+6582mU3H921pX3Qg/ygOZqXSUR9Df42Hjd+Zutob81Nk4/Zf5Xt
         zoWjSNAG0BcoVIdnxCpSJ0UJhxaJ6ActZCdw/T2Ze1F56Onk48YEUN8fkNy+ir6V5iof
         yk1rTDKFD2d0u1hGb99tAUoXeSs9IvP6cQDkfsTrGWnRKLltPyG+A5ko4rANVyQRCzTS
         KItcD382dsObqRKEeo+a27R8h4vNqrrBMm8z7LXmeYWxxRvwgxnK+DGXwh9Ddcv2hmsh
         e+LA==
X-Gm-Message-State: AOAM530TfpcAkoC6WWD8ZiIpPAugpvHkaE617RiV0oyUIgVctNMF4Hb5
        wrhzc5MaMM4wWjgG8TCFE3FmXA==
X-Google-Smtp-Source: ABdhPJyRMbCAAWVZvRwKzWuxCupyvrVpKIv4kXvy0yE21CqqYPFziUDGjSqMnDtWNtk7TKJxXkXkmg==
X-Received: by 2002:a17:90b:1650:b0:1df:a92d:c614 with SMTP id il16-20020a17090b165000b001dfa92dc614mr11073345pjb.205.1653058059443;
        Fri, 20 May 2022 07:47:39 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id p36-20020a635b24000000b003c6a37b1628sm5336362pgb.13.2022.05.20.07.47.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 May 2022 07:47:38 -0700 (PDT)
Date:   Fri, 20 May 2022 14:47:35 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yuan Yao <yuan.yao@linux.intel.com>
Cc:     Yun Lu <luyun_611@163.com>, pbonzini@redhat.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86/mmu: optimizing the code in
 mmu_try_to_unsync_pages
Message-ID: <YoeqB2KAN/wsHMpk@google.com>
References: <20220520060907.863136-1-luyun_611@163.com>
 <20220520095428.bahy37jxkznqtwx5@yy-desk-7060>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220520095428.bahy37jxkznqtwx5@yy-desk-7060>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 20, 2022, Yuan Yao wrote:
> On Fri, May 20, 2022 at 02:09:07PM +0800, Yun Lu wrote:
> > There is no need to check can_unsync and prefetch in the loop
> > every time, just move this check before the loop.
> >
> > Signed-off-by: Yun Lu <luyun@kylinos.cn>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 12 ++++++------
> >  1 file changed, 6 insertions(+), 6 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 311e4e1d7870..e51e7735adca 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -2534,6 +2534,12 @@ int mmu_try_to_unsync_pages(struct kvm *kvm, const struct kvm_memory_slot *slot,
> >  	if (kvm_slot_page_track_is_active(kvm, slot, gfn, KVM_PAGE_TRACK_WRITE))
> >  		return -EPERM;
> >
> > +	if (!can_unsync)
> > +		return -EPERM;
> > +
> > +	if (prefetch)
> > +		return -EEXIST;
> > +
> >  	/*
> >  	 * The page is not write-tracked, mark existing shadow pages unsync
> >  	 * unless KVM is synchronizing an unsync SP (can_unsync = false).  In
> > @@ -2541,15 +2547,9 @@ int mmu_try_to_unsync_pages(struct kvm *kvm, const struct kvm_memory_slot *slot,
> >  	 * allowing shadow pages to become unsync (writable by the guest).
> >  	 */
> >  	for_each_gfn_indirect_valid_sp(kvm, sp, gfn) {
> > -		if (!can_unsync)
> > -			return -EPERM;
> > -
> >  		if (sp->unsync)
> >  			continue;
> >
> > -		if (prefetch)
> > -			return -EEXIST;
> > -
> 
> Consider the case that for_each_gfn_indirect_valid_sp() loop is
> not triggered, means the gfn is not MMU page table page:
> 
> The old behavior when : return 0;
> The new behavior with this change: returrn -EPERM / -EEXIST;
> 
> It at least breaks FNAME(sync_page) -> make_spte(prefetch = true, can_unsync = false)
> which removes PT_WRITABLE_MASK from last level mapping unexpectedly.

Yep, the flags should be queried if and only if there's at least one valid, indirect
SP for th gfn.  And querying whether there's such a SP is quite expesnive and requires
looping over a list, so checking every iteration of the loop is far cheaper.  E.g. each
check is a single uop on modern CPUs as both gcc and clang are smart enough to stash
the flags in registers so that there's no reload from memory on each loop.  And that
also means the CPU can more than likely correctly predict subsequent iterations.
