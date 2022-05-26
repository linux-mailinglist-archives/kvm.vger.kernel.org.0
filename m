Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6B4A535578
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 23:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239216AbiEZV27 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 17:28:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231351AbiEZV25 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 17:28:57 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49A83ABF49
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 14:28:56 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id d129so2313028pgc.9
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 14:28:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=n/dQumpwP7TjnB5SFXHOsq0ojlkNiebJVgxbXnsVWEw=;
        b=UORJmqEl1ZcTStO8P44GY6cM5VBCI4XXU11RYFlagzJPjwgLYfR9fWKFey4MYWSAtR
         v6ZMhIP8kBUlqH+CMgZgxU5WofSdJGzn19kuixH59EZk9g2tEAr7gbO8gPRgedJPOzMA
         mPef4VS8XoKCVT/bJiD31KTs7du7pbYzTMDguk0MpNBwU9sfSBZr54e/ZpZaCcLHI/Rc
         tzWGa3K74/Y+4F5nT3uc0RoUahIwXQMYu2QsQVtvXeOZEHl64ToezAaklWdfbsGv2fJT
         nD6b3CuKWQnXjRwEDb878ABVSl5/lYkaTSRriEltMT5Pnw0eiJT1doQ4WE5HWlR72QnD
         9fIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=n/dQumpwP7TjnB5SFXHOsq0ojlkNiebJVgxbXnsVWEw=;
        b=CHpOQ4uCMA92aDdMZb6BdwWoXaB8rMuniDPUh3mYPw/oqOaW6Mh58pzUn2yoGLFthc
         R25ROIArLHW84f2eL6oSehhMRj5/SMw/qLrL+dIVWtr4sIjNtbis+xPhDQ6NH1YTK3nd
         HA/78HhZdWCZOxpPHVPuSxm+dBOAN9ldXz9zfZcgj7GqEexp36ouxSiVHwNPrTwJ28c7
         CZkTUhqYkvup7rGtBJLtRMdP89FcsChVoA+jO85zdz5I61xShI8D65vhEPHmVVHrMXfR
         wf9KMKcPYxgw5JnS09dClt5Sp44VOSVw8RI5rRK8KbqzPltcPZXDC5v8bxLvkG1uywVJ
         7XlQ==
X-Gm-Message-State: AOAM5312/4zxCt3cr8nyOij3khlYP8snfiU1jodlfL/VNBFC4dR6T3Aa
        MXhj5rL8FTMcUz6HyruxBaNR/4zTRjJv4A==
X-Google-Smtp-Source: ABdhPJzlDei3c5LPTtjJF4767PxFoKhAc+XnedidW9jrARRoSw5p5T61izwk+1esqhopcAZjZotTBw==
X-Received: by 2002:a63:7d3:0:b0:3f6:885:cd22 with SMTP id 202-20020a6307d3000000b003f60885cd22mr35097498pgh.143.1653600535500;
        Thu, 26 May 2022 14:28:55 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id n24-20020a17090ac69800b001e26c391d28sm83742pjt.54.2022.05.26.14.28.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 14:28:54 -0700 (PDT)
Date:   Thu, 26 May 2022 21:28:50 +0000
From:   David Matlack <dmatlack@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
Subject: Re: [PATCH V3 02/12] KVM: X86/MMU: Add using_local_root_page()
Message-ID: <Yo/xEirUJBLLQqCf@google.com>
References: <20220521131700.3661-1-jiangshanlai@gmail.com>
 <20220521131700.3661-3-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220521131700.3661-3-jiangshanlai@gmail.com>
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

On Sat, May 21, 2022 at 09:16:50PM +0800, Lai Jiangshan wrote:
> From: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> 
> In some cases, local root pages are used for MMU.  It is often using
> to_shadow_page(mmu->root.hpa) to check if local root pages are used.
> 
> Add using_local_root_page() to directly check if local root pages are
> used or needed to be used even mmu->root.hpa is not set.
> 
> Prepare for making to_shadow_page(mmu->root.hpa) returns non-NULL via
> using local shadow [root] pages.
> 
> Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 40 +++++++++++++++++++++++++++++++++++++---
>  1 file changed, 37 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index efe5a3dca1e0..624b6d2473f7 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1690,6 +1690,39 @@ static void drop_parent_pte(struct kvm_mmu_page *sp,
>  	mmu_spte_clear_no_track(parent_pte);
>  }
>  
> +/*
> + * KVM uses the VCPU's local root page (vcpu->mmu->pae_root) when either the
> + * shadow pagetable is using PAE paging or the host is shadowing nested NPT for
> + * 32bit L1 hypervisor.

How about using the terms "private" and "shared" instead of "local" and
"non-local"? I think that more accurately conveys what is special about
these pages: they are private to the vCPU using them. And then "shared"
is more intuitive to understand than "non-local" (which is used
elsewhere in this series).

> + *
> + * It includes cases:
> + *	nonpaging when !tdp_enabled				(direct paging)
> + *	shadow paging for 32 bit guest when !tdp_enabled	(shadow paging)
> + *	NPT in 32bit host (not shadowing nested NPT)		(direct paging)
> + *	shadow nested NPT for 32bit L1 hypervisor in 32bit host (shadow paging)
> + *	shadow nested NPT for 32bit L1 hypervisor in 64bit host (shadow paging)
> + *
> + * For the first four cases, mmu->root_role.level is PT32E_ROOT_LEVEL and the
> + * shadow pagetable is using PAE paging.
> + *
> + * For the last case, it is
> + * 	mmu->root_role.level > PT32E_ROOT_LEVEL &&
> + * 	!mmu->root_role.direct && mmu->cpu_role.base.level <= PT32E_ROOT_LEVEL
> + * And if this condition is true, it must be the last case.
> + *
> + * With the two conditions combined, the checking condition is:
> + * 	mmu->root_role.level == PT32E_ROOT_LEVEL ||
> + * 	(!mmu->root_role.direct && mmu->cpu_role.base.level <= PT32E_ROOT_LEVEL)
> + *
> + * (There is no "mmu->root_role.level > PT32E_ROOT_LEVEL" here, because it is
> + *  already ensured that mmu->root_role.level >= PT32E_ROOT_LEVEL)
> + */
> +static bool using_local_root_page(struct kvm_mmu *mmu)
> +{
> +	return mmu->root_role.level == PT32E_ROOT_LEVEL ||
> +	       (!mmu->root_role.direct && mmu->cpu_role.base.level <= PT32E_ROOT_LEVEL);
> +}
> +
>  static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, int direct)
>  {
>  	struct kvm_mmu_page *sp;
> @@ -4252,10 +4285,11 @@ static bool fast_pgd_switch(struct kvm *kvm, struct kvm_mmu *mmu,
>  {
>  	/*
>  	 * For now, limit the caching to 64-bit hosts+VMs in order to avoid
> -	 * having to deal with PDPTEs. We may add support for 32-bit hosts/VMs
> -	 * later if necessary.
> +	 * having to deal with PDPTEs.  Local roots can not be put into
> +	 * mmu->prev_roots[] because mmu->pae_root can not be shared for
> +	 * different roots at the same time.

This comment ends up being a little confusing by the end of this series
because using_local_root_page() does not necessarily imply pae_root is
in use. i.e. case 5 (shadow nested NPT for 32bit L1 hypervisor in 64bit
host) does not use pae_root.

How about rewording this commit to say something like:

  If the vCPU is using a private root, it might be using pae_root, which
  cannot be shared for different roots at the same time.

>  	 */
> -	if (VALID_PAGE(mmu->root.hpa) && !to_shadow_page(mmu->root.hpa))
> +	if (unlikely(using_local_root_page(mmu)))
>  		kvm_mmu_free_roots(kvm, mmu, KVM_MMU_ROOT_CURRENT);
>  
>  	if (VALID_PAGE(mmu->root.hpa))
> -- 
> 2.19.1.6.gb485710b
> 
