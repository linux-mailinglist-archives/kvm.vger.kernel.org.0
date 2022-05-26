Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ADCE5355B4
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 23:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241358AbiEZVio (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 17:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238014AbiEZVim (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 17:38:42 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61673EE08
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 14:38:41 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id a17so2522367plb.4
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 14:38:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vVTqN7pCfmppUlOW7BTlh6toTmZUY9VqhlcoRPNA4yo=;
        b=hWYKSw2dXO1XGN3m3BW1ovRH9ixLo9XMl7iD0sa5rT8uFj/kl6e7U4gP3XYvlHlug7
         qkgdBmEw32k3+dtfrHMftqYp/XnCZ8VJJoNbUsG7wS1KhkPy3m16HTWczD6LDyFsuXJs
         grA82IH6DnQThbOKZzpp47ZjwtRsGPnTlGeyzO7uGpN1nrIBwFzkeRKVw08kl82bQHM6
         MQZL7+ZDe5ww80cdKw7KIVgaz2hOT4ytwplNZ/W4CcjfJFaNwjkOmETyHPS086KptD4i
         bsqyW4baEgQzT+dgLJ7Qu+P/9md73M38XZ8xCR4NKnhPJ5WxbIuVUd6vv1sYi9N2yepS
         tUKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vVTqN7pCfmppUlOW7BTlh6toTmZUY9VqhlcoRPNA4yo=;
        b=FgFWqjxD1wDF50e3VPW5pJc+3bGH319OUCgAnY9TIJnbzWZEr7yEdwcnMVNb4PVWZn
         XM5PxCEWlnQj5UgJurfTL4WQ1zq/Wcx6cRFAKWMrEBXfm5sDLaURqJJxhtar1LlnT4oe
         3SuE+C+y+1dkRVvHtodD0NqjbJ83S7/Rq1Etwe1EsAAUZX/KcmZ5CHYdvHzV7wmT0+Bw
         TJZTj7UmGpXhky2LuaEj6ULg9TgwLbkeDT2qHMilM68O/bz4mr6Z9vJTPTrX1rc8uayX
         g0wiY3YpbWTa1u1oczkWgPxiWhGtg1pWZBPGAibHhxuYwbAAJAmMpKA2ml3xqtQWa8ed
         YHUQ==
X-Gm-Message-State: AOAM532wAm8usXo40BMSy5xS9ivNfd2gZYtb2hGaso83hyVvN+dcDweR
        Ig7yBg/Qh5Zv4Gb7LsuIjZLMYg==
X-Google-Smtp-Source: ABdhPJxcpy08hib0oHlrrKjE3qTEH11YpF25aho7pZMFoZhy8xa75zoIrVUa2VMybXhWgOtV9R3/fQ==
X-Received: by 2002:a17:902:b615:b0:161:64e6:85b7 with SMTP id b21-20020a170902b61500b0016164e685b7mr38513499pls.29.1653601120611;
        Thu, 26 May 2022 14:38:40 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id az2-20020a17090b028200b001d95c09f877sm115206pjb.35.2022.05.26.14.38.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 14:38:39 -0700 (PDT)
Date:   Thu, 26 May 2022 21:38:36 +0000
From:   David Matlack <dmatlack@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
Subject: Re: [PATCH V3 04/12] KVM: X86/MMU: Add local shadow pages
Message-ID: <Yo/zXOGQYVWe0RI9@google.com>
References: <20220521131700.3661-1-jiangshanlai@gmail.com>
 <20220521131700.3661-5-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220521131700.3661-5-jiangshanlai@gmail.com>
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

On Sat, May 21, 2022 at 09:16:52PM +0800, Lai Jiangshan wrote:
> From: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> 
> Local shadow pages are shadow pages to hold PDPTEs for 32bit guest or
> higher level shadow pages having children local shadow pages when
> shadowing nested NPT for 32bit L1 in 64 bit L0.
> 
> Current code use mmu->pae_root, mmu->pml4_root, and mmu->pml5_root to
> setup local root page.  The initialization code is complex and the root
> pages are not associated with struct kvm_mmu_page which causes the code
> more complex.
> 
> Add kvm_mmu_alloc_local_shadow_page() and mmu_free_local_root_page() to
> allocate and free local shadow pages and prepare for using local
> shadow pages to replace current logic and share the most logic with
> non-local shadow pages.
> 
> The code is not activated since using_local_root_page() is false in
> the place where it is inserted.
> 
> Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 109 ++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 108 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 240ebe589caf..c941a5931bc3 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1764,6 +1764,76 @@ static bool using_local_root_page(struct kvm_mmu *mmu)
>  		return mmu->cpu_role.base.level <= PT32E_ROOT_LEVEL;
>  }
>  
> +/*
> + * Local shadow pages are shadow pages to hold PDPTEs for 32bit guest or higher
> + * level shadow pages having children local shadow pages when shadowing nested
> + * NPT for 32bit L1 in 64 bit L0.
> + *
> + * Local shadow pages are often local shadow root pages (or local root pages for
> + * short) except when shadowing nested NPT for 32bit L1 in 64 bit L0 which has
> + * 2 or 3 levels of local shadow pages on top of non-local shadow pages.
> + *
> + * Local shadow pages are locally allocated.  If the local shadow page's level

Can you clarify what you mean by "locally allocated"?

> + * is PT32E_ROOT_LEVEL, it will use the preallocated mmu->pae_root for its
> + * sp->spt.  Because sp->spt may need to be put in the 32 bits CR3 (even in
> + * x86_64) or decrypted.  Using the preallocated one to handle these
> + * requirements makes the allocation simpler.
> + *
> + * Local shadow pages are only visible to local VCPU except through
> + * sp->parent_ptes rmap from their children, so they are not in the
> + * kvm->arch.active_mmu_pages nor in the hash.
> + *
> + * And they are neither accounted nor write-protected since they don't shadow a
> + * guest page table.
> + *
> + * Because of above, local shadow pages can not be freed nor zapped like
> + * non-local shadow pages.  They are freed directly when the local root page
> + * is freed, see mmu_free_local_root_page().
> + *
> + * Local root page can not be put on mmu->prev_roots because the comparison
> + * must use PDPTEs instead of CR3 and mmu->pae_root can not be shared for multi
> + * local root pages.
> + *
> + * Except above limitations, all the other abilities are the same as other
> + * shadow page, like link, parent rmap, sync, unsync etc.
> + *
> + * Local shadow pages can be obsoleted in a little different way other than
> + * the non-local shadow pages.  When the obsoleting process is done, all the
> + * obsoleted non-local shadow pages are unlinked from the local shadow pages
> + * by the help of the sp->parent_ptes rmap and the local shadow pages become
> + * theoretically valid again except sp->mmu_valid_gen may be still outdated.
> + * If there is no other event to cause a VCPU to free the local root page and
> + * the VCPU is being preempted by the host during two obsoleting processes,
> + * sp->mmu_valid_gen might become valid again and the VCPU can reuse it when
> + * the VCPU is back.  It is different from the non-local shadow pages which
> + * are always freed after obsoleted.
> + */
> +static struct kvm_mmu_page *
> +kvm_mmu_alloc_local_shadow_page(struct kvm_vcpu *vcpu, union kvm_mmu_page_role role)
> +{
> +	struct kvm_mmu_page *sp;
> +
> +	sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
> +	sp->gfn = 0;
> +	sp->role = role;
> +	/*
> +	 * Use the preallocated mmu->pae_root when the shadow page's
> +	 * level is PT32E_ROOT_LEVEL which may need to be put in the 32 bits
> +	 * CR3 (even in x86_64) or decrypted.  The preallocated one is prepared
> +	 * for the requirements.

Thanks for adding this comment. It helps a lot.

> +	 */
> +	if (role.level == PT32E_ROOT_LEVEL &&
> +	    !WARN_ON_ONCE(!vcpu->arch.mmu->pae_root))
> +		sp->spt = vcpu->arch.mmu->pae_root;
> +	else
> +		sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
> +	/* sp->gfns is not used for local shadow page */
> +	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
> +	sp->mmu_valid_gen = vcpu->kvm->arch.mmu_valid_gen;
> +
> +	return sp;
> +}
> +
>  static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, int direct)
>  {
>  	struct kvm_mmu_page *sp;
> @@ -2121,6 +2191,9 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
>  	if (level <= vcpu->arch.mmu->cpu_role.base.level)
>  		role.passthrough = 0;
>  
> +	if (unlikely(level >= PT32E_ROOT_LEVEL && using_local_root_page(vcpu->arch.mmu)))
> +		return kvm_mmu_alloc_local_shadow_page(vcpu, role);
> +
>  	sp_list = &vcpu->kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
>  	for_each_valid_sp(vcpu->kvm, sp, sp_list) {
>  		if (sp->gfn != gfn) {
> @@ -3351,6 +3424,37 @@ static void mmu_free_root_page(struct kvm *kvm, hpa_t *root_hpa,
>  	*root_hpa = INVALID_PAGE;
>  }
>  
> +static void mmu_free_local_root_page(struct kvm *kvm, struct kvm_mmu *mmu)
> +{
> +	u64 spte = mmu->root.hpa;
> +	struct kvm_mmu_page *sp = to_shadow_page(spte & PT64_BASE_ADDR_MASK);
> +	int i;
> +
> +	/* Free level 5 or 4 roots for shadow NPT for 32 bit L1 */
> +	while (sp->role.level > PT32E_ROOT_LEVEL)
> +	{
> +		spte = sp->spt[0];
> +		mmu_page_zap_pte(kvm, sp, sp->spt + 0, NULL);
> +		free_page((unsigned long)sp->spt);
> +		kmem_cache_free(mmu_page_header_cache, sp);
> +		if (!is_shadow_present_pte(spte))
> +			return;
> +		sp = to_shadow_page(spte & PT64_BASE_ADDR_MASK);
> +	}
> +
> +	if (WARN_ON_ONCE(sp->role.level != PT32E_ROOT_LEVEL))
> +		return;
> +
> +	/* Disconnect PAE root from the 4 PAE page directories */
> +	for (i = 0; i < 4; i++)
> +		mmu_page_zap_pte(kvm, sp, sp->spt + i, NULL);
> +
> +	if (sp->spt != mmu->pae_root)
> +		free_page((unsigned long)sp->spt);
> +
> +	kmem_cache_free(mmu_page_header_cache, sp);
> +}
> +
>  /* roots_to_free must be some combination of the KVM_MMU_ROOT_* flags */
>  void kvm_mmu_free_roots(struct kvm *kvm, struct kvm_mmu *mmu,
>  			ulong roots_to_free)
> @@ -3384,7 +3488,10 @@ void kvm_mmu_free_roots(struct kvm *kvm, struct kvm_mmu *mmu,
>  
>  	if (free_active_root) {
>  		if (to_shadow_page(mmu->root.hpa)) {
> -			mmu_free_root_page(kvm, &mmu->root.hpa, &invalid_list);
> +			if (using_local_root_page(mmu))
> +				mmu_free_local_root_page(kvm, mmu);
> +			else
> +				mmu_free_root_page(kvm, &mmu->root.hpa, &invalid_list);

What do you think about adding a separate patch to rename
mmu_free_root_page() to mmu_put_root_page()? I think that would make the
code much more clear when combined with my suggestion to use "private".
i.e. We'd end up with:

  if (using_private_root_page(mmu))
        mmu_free_private_root_page(mmu);
  else
        mmu_put_root_page(kvm, &mmu->root.hpa, &invalid_list);

This makes it clear that the vCPU owns private root pages, so can free
them directly. But for shared root pages (i.e. else clause), we are just
putting a reference and only freeing if the reference (root_count) goes
to 0.

>  		} else if (mmu->pae_root) {
>  			for (i = 0; i < 4; ++i) {
>  				if (!IS_VALID_PAE_ROOT(mmu->pae_root[i]))
> -- 
> 2.19.1.6.gb485710b
> 
