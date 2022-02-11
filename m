Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E823F4B2C2D
	for <lists+kvm@lfdr.de>; Fri, 11 Feb 2022 18:55:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352391AbiBKRxl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Feb 2022 12:53:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344793AbiBKRxk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Feb 2022 12:53:40 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2957038F
        for <kvm@vger.kernel.org>; Fri, 11 Feb 2022 09:53:39 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id t4-20020a17090a510400b001b8c4a6cd5dso9520565pjh.5
        for <kvm@vger.kernel.org>; Fri, 11 Feb 2022 09:53:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GR8YI4ZUVVkcMkfN5n/I4ApVj24WcUZ3xy5k7vXwB3c=;
        b=gfNgwwaZGmKRhsYpF5xWdH7KWoDCgT6PqXTPoVSQjk7Uae3en5i8wL5l01rY0Tmppo
         PShnO2uaKQnjE7BV/+gSCyjo6arwMpRc+7lf+MFcK6/Z97uuQQ7rHBoMK/kMWYOvq1J8
         pMeqVp0KU0AUdP+yoV+smm6RtZGp3buYqZYX77xk5t/LutQP591p5W/owIkKLg5GkkWM
         CgELIjfJ3+ICoe+QZe6HDB93aGSRXXntjYV4HC7ujGvtn9JAPgr4di+yKiKoSnnvIzma
         DZTKT2t0TWEkbfFZNgZDO5LLbpVuHN7j6DkwgMpu9yY5wpTM0mM8YwdMBZ0jNroOMc6P
         nC/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GR8YI4ZUVVkcMkfN5n/I4ApVj24WcUZ3xy5k7vXwB3c=;
        b=uKIuEIwWycC8smZJDW+/dXshaFm5Tm6FgyZA3P2xsZWd+/EmbQo6tS0AEyrw0eM/lr
         2ANqxHEbtvehr9FXO2961GYy3qTx9OkSoKGkDs5ST5+5j2j7cH3ge4YpJ99JTa55pR9K
         vPqx1AhRJlgRx66Tqc91AZ+4fQCmRGE7CBtmI/BswmH47z+OueTZ3aciHk3uVTDAlt4N
         DbLgb9TOKv4gpZtIcrWCKnVZaD1F346X8O3suYe4cZr/iBEsEEJxzcnUyKIow7l9ED7A
         pJHs8ku5xw8dPbJPnByuouHWml5+YgI9QfbSw99zjv3T/D1W39aguyuJ8eZbv3rPENTf
         wYUQ==
X-Gm-Message-State: AOAM533OhrgZVedthxtIKWTP8Hx4GmsIRlP1YdrM6hjdtoPhqWfiCqW8
        ES6RBQY8fh/LvF/FBdg8a8GuCw==
X-Google-Smtp-Source: ABdhPJzLlfDEU5PO8AgWctvqRPPpzE55qWjOXriCo0/5uHQks2oaJC2d9s8IO8ZGJr2xf8x7e0n8Hw==
X-Received: by 2002:a17:90b:3a82:: with SMTP id om2mr1586423pjb.58.1644602018334;
        Fri, 11 Feb 2022 09:53:38 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id z13sm27643393pfe.20.2022.02.11.09.53.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 09:53:37 -0800 (PST)
Date:   Fri, 11 Feb 2022 17:53:34 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com, mlevitsk@redhat.com, dmatlack@google.com
Subject: Re: [PATCH 11/12] KVM: MMU: remove kvm_mmu_calc_root_page_role
Message-ID: <Ygainod2tgZy1e3c@google.com>
References: <20220209170020.1775368-1-pbonzini@redhat.com>
 <20220209170020.1775368-12-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220209170020.1775368-12-pbonzini@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

IMO, the shortlog is too literal and doesn't help understand the implications of
the change.  I prefer something like:

  KVM: x86/mmu: Always use current mmu's role when loading new PGD

On Wed, Feb 09, 2022, Paolo Bonzini wrote:
> Since the guest PGD is now loaded after the MMU has been set up
> completely, the desired role for a cache hit is simply the current
> mmu_role.  There is no need to compute it again, so __kvm_mmu_new_pgd
> can be folded in kvm_mmu_new_pgd.
> 
> For the !tdp_enabled case, it would also have been possible to use
> the role that is already in vcpu->arch.mmu.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

With a different shortlog and newline,

Reviewed-by: Sean Christopherson <seanjc@google.com>

>  arch/x86/kvm/mmu/mmu.c | 29 ++++-------------------------
>  1 file changed, 4 insertions(+), 25 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index df9e0a43513c..38b40ddcaad7 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -190,8 +190,6 @@ struct kmem_cache *mmu_page_header_cache;
>  static struct percpu_counter kvm_total_used_mmu_pages;
>  
>  static void mmu_spte_set(u64 *sptep, u64 spte);
> -static union kvm_mmu_page_role
> -kvm_mmu_calc_root_page_role(struct kvm_vcpu *vcpu);
>  
>  struct kvm_mmu_role_regs {
>  	const unsigned long cr0;
> @@ -4172,9 +4170,9 @@ static bool fast_pgd_switch(struct kvm_vcpu *vcpu, gpa_t new_pgd,
>  		return cached_root_find_and_replace(vcpu, new_pgd, new_role);
>  }
>  
> -static void __kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd,
> -			      union kvm_mmu_page_role new_role)
> +void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd)
>  {
> +	union kvm_mmu_page_role new_role = vcpu->arch.mmu->mmu_role.base;

Newline needed.

>  	if (!fast_pgd_switch(vcpu, new_pgd, new_role)) {
>  		/* kvm_mmu_ensure_valid_pgd will set up a new root.  */
>  		return;
