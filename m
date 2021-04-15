Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F567360EDC
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 17:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233966AbhDOPXK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Apr 2021 11:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234382AbhDOPXI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Apr 2021 11:23:08 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CF0EC061761
        for <kvm@vger.kernel.org>; Thu, 15 Apr 2021 08:22:28 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id w8so9913851plg.9
        for <kvm@vger.kernel.org>; Thu, 15 Apr 2021 08:22:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4MfX1+P60MGmNVVH7ZUGlM2p8KOEUPebyk1Sqm9t4sU=;
        b=VJi4ly6znLIiXmj9w6RSyN6XYiGto3MkA4d5rVsmYSu8Jblx4kGk2H24I0q//k6a9k
         eP13+IAepXR37tFBKtMLzF1KmjgGKXmhliJLtfOApzUbh38vyWTOsOOgYTYqvg+QmBlg
         LoxemceXdvdqnvumBhiHsnfrcj1LUVSDIKkprzxuLrmest+WfOBKJtOsrlFTNGvPFZ3k
         KWoaBQstlwfrGso7VjVJtUt089Zlp40OaXDWoEyHWn+O1v+betutIRIl5m+IxnprCsxh
         7WAv/4JwqmESvH3fC3V1ygZBFxyFOyj5LpguLxcWU0NgEtj/W0jOZH+fEq287a68QfsC
         O4yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4MfX1+P60MGmNVVH7ZUGlM2p8KOEUPebyk1Sqm9t4sU=;
        b=fqBPmCTsSmHbYGyBzaBz22Z/H3nql5ICUsdg3tBWL6BFHPFx5EO/CYYMqvDfivlwDU
         F7UFOdU03R0jxD3adRV7og6FcF1Oab+NRwFE4YNXbh7nU4Guh3yvgfZVRR9Uu9arUiUl
         +SlV9NwxnnjiSFqRkuwUBn3YTzGT+Kmy2vQtIIguNZ5FiFNcu8aTZvFbaUhzAuXZBHKp
         1KpBJ3o4wLP3gdsFAhYziwvdz5Zhhnv52jThQCNyiOuM5VJMNJS3XWQksVGGnZCFsWK8
         DtWmwlp+FiezsOU/1ncM60kNxYsQFLhENItXJMFTQbK0777pm7Y2uqaB9EclaafMWTRj
         K7Fg==
X-Gm-Message-State: AOAM530iGycRSqXsPD+NR1CXeaDzRnbGeWhZC1WdRx65Xmzxbvo1iX9T
        vDBk4eTei0XU/RD0nqqX3F1F/A==
X-Google-Smtp-Source: ABdhPJwdh6/H/slrmajnKLFGAKio1FQZZhqdh/0R95UoTVYzD3IhDt4gFlNVzfvLMFOlJ8P37OkAJw==
X-Received: by 2002:a17:90a:c203:: with SMTP id e3mr4418851pjt.173.1618500147730;
        Thu, 15 Apr 2021 08:22:27 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id r14sm2762510pjz.43.2021.04.15.08.22.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 08:22:26 -0700 (PDT)
Date:   Thu, 15 Apr 2021 15:22:23 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: x86/mmu: Remove duplicate MMU trace log
Message-ID: <YHhaL2+cq9cfCoL1@google.com>
References: <20210415040141.5218-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210415040141.5218-1-weijiang.yang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 15, 2021, Yang Weijiang wrote:
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 018d82e73e31..0bd4c9972fc8 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -781,8 +781,6 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu, int write,
>  		trace_kvm_mmu_set_spte(iter->level, iter->gfn,
>  				       rcu_dereference(iter->sptep));
>  
> -	trace_kvm_mmu_set_spte(iter->level, iter->gfn,
> -			       rcu_dereference(iter->sptep));
>  	if (!prefault)
>  		vcpu->stat.pf_fixed++;

Already queued in kvm/next, commit 3849e0924ef1 ("KVM: x86/mmu: Drop redundant
trace_kvm_mmu_set_spte() in the TDP MMU").

Thanks!
