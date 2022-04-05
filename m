Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0C9D4F4973
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 02:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384693AbiDEWQs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Apr 2022 18:16:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1453023AbiDEPzx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 11:55:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 341A813858C
        for <kvm@vger.kernel.org>; Tue,  5 Apr 2022 07:59:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649170741;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m2sfKB74gTolYuaOLfzO0CaB/byjGpQyOkAPbwbPHJY=;
        b=CKRvQ9nae+f9pPC/LcCnQ28IS++GKZ0sZUvOgFFMaFniTTcDpFeiukbvzoAq+2ADLEUbT9
        GNq+6XsETMoMPOWW7Gk4gUSctNpmIVYwV/RLoQXKtwP1N1IsVfj9CIZdJpNn6ns76MdW5h
        SdF/D5l7g7aW+UgBuqpOH5OTCxyMUNM=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-425-zt2zn7_rNLuSgUVWnE-cfQ-1; Tue, 05 Apr 2022 10:58:59 -0400
X-MC-Unique: zt2zn7_rNLuSgUVWnE-cfQ-1
Received: by mail-qv1-f70.google.com with SMTP id a3-20020a056214062300b00443cd6175c8so7552525qvx.4
        for <kvm@vger.kernel.org>; Tue, 05 Apr 2022 07:58:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=m2sfKB74gTolYuaOLfzO0CaB/byjGpQyOkAPbwbPHJY=;
        b=sfPQukNbnWpSW3ii1+ukPGdkPEdBllntdAQAXRivY8TfNm1Vaclvo/v2UuujyFeajh
         zMWsUsXR7b6fFqy/3rdv+yUsx464vZSnFD6QSPVvyky8v3k1Hpc/cqStEiQ/SZPtY6ti
         wtg6Yu5USQBjIZL8kra1IblthMdZomEOdn5cItx2CygX2K0SC3U949XacGIIZ3Je0iiX
         tkMehOmPoO5etrusYwu4WDXvWKXdC240zhg7Q7MAqNHJWpldREetWBt5jJ7qM4LgL0T6
         VV+RM0hTpQCFmSEih7+xyHznvX2UtKPLHNNMOZLkf4bAN846w5dPcjJoonT/MRa5H2QJ
         X/NA==
X-Gm-Message-State: AOAM53016iPcsX2GIzkGDNDInLk95cuJY9OVnfucd4T55L1gX+aIlTCV
        1WlWYnH1AFwIjN/QGLu0wDZVBtT8bYtds6zArpBF42eoTORyf3UzAxwWYDSdfp0y45XptNpr2LC
        tf5zYKyA+vE0d
X-Received: by 2002:a05:620a:210f:b0:67b:119d:f32d with SMTP id l15-20020a05620a210f00b0067b119df32dmr2596720qkl.316.1649170739261;
        Tue, 05 Apr 2022 07:58:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyxrv+hAz704UHG1GvBC1bddnp2MT4csXtUyD6rb0x6BFrLO5qGXa/QxqcDJp3NxZ4dggSgJw==
X-Received: by 2002:a05:620a:210f:b0:67b:119d:f32d with SMTP id l15-20020a05620a210f00b0067b119df32dmr2596698qkl.316.1649170738832;
        Tue, 05 Apr 2022 07:58:58 -0700 (PDT)
Received: from [10.32.181.87] (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.googlemail.com with ESMTPSA id c27-20020a05620a165b00b0067d32238bc8sm8030769qko.125.2022.04.05.07.58.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 07:58:58 -0700 (PDT)
Message-ID: <fbd5271c-5d6d-ded6-63dc-6ee3a7ccd305@redhat.com>
Date:   Tue, 5 Apr 2022 16:58:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 047/104] KVM: x86/mmu: add a private pointer to
 struct kvm_mmu_page
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <499d1fd01b0d1d9a8b46a55bb863afd0c76f1111.1646422845.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <499d1fd01b0d1d9a8b46a55bb863afd0c76f1111.1646422845.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/4/22 20:49, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Add a private pointer to kvm_mmu_page for private EPT.
> 
> To resolve KVM page fault on private GPA, it will allocate additional page
> for Secure EPT in addition to private EPT.  Add memory allocator for it and
> topup its memory allocator before resolving KVM page fault similar to
> shared EPT page.  Allocation of those memory will be done for TDP MMU by
> alloc_tdp_mmu_page().  Freeing those memory will be done for TDP MMU on
> behalf of kvm_tdp_mmu_zap_all() called by kvm_mmu_zap_all().  Private EPT
> page needs to carry one more page used for Secure EPT in addition to the
> private EPT page.  Add private pointer to struct kvm_mmu_page for that
> purpose and Add helper functions to allocate/free a page for Secure EPT.
> Also add helper functions to check if a given kvm_mmu_page is private.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/include/asm/kvm_host.h |  1 +
>   arch/x86/kvm/mmu/mmu.c          |  9 ++++
>   arch/x86/kvm/mmu/mmu_internal.h | 84 +++++++++++++++++++++++++++++++++
>   arch/x86/kvm/mmu/tdp_mmu.c      |  3 ++
>   4 files changed, 97 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index fcab2337819c..0c8cc7d73371 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -689,6 +689,7 @@ struct kvm_vcpu_arch {
>   	struct kvm_mmu_memory_cache mmu_shadow_page_cache;
>   	struct kvm_mmu_memory_cache mmu_gfn_array_cache;
>   	struct kvm_mmu_memory_cache mmu_page_header_cache;
> +	struct kvm_mmu_memory_cache mmu_private_sp_cache;
>   
>   	/*
>   	 * QEMU userspace and the guest each have their own FPU state.
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 6e9847b1124b..8def8b97978f 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -758,6 +758,13 @@ static int mmu_topup_shadow_page_cache(struct kvm_vcpu *vcpu)
>   	struct kvm_mmu_memory_cache *mc = &vcpu->arch.mmu_shadow_page_cache;
>   	int start, end, i, r;
>   
> +	if (kvm_gfn_stolen_mask(vcpu->kvm)) {
> +		r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_private_sp_cache,
> +					       PT64_ROOT_MAX_LEVEL);
> +		if (r)
> +			return r;
> +	}
> +
>   	if (shadow_init_value)
>   		start = kvm_mmu_memory_cache_nr_free_objects(mc);
>   
> @@ -799,6 +806,7 @@ static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
>   {
>   	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache);
>   	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadow_page_cache);
> +	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_private_sp_cache);
>   	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_gfn_array_cache);
>   	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache);
>   }
> @@ -1791,6 +1799,7 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, int direct
>   	if (!direct)
>   		sp->gfns = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_gfn_array_cache);
>   	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
> +	kvm_mmu_init_private_sp(sp);
>   
>   	/*
>   	 * active_mmu_pages must be a FIFO list, as kvm_zap_obsolete_pages()
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index da6166b5c377..80f7a74a71dc 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -53,6 +53,10 @@ struct kvm_mmu_page {
>   	u64 *spt;
>   	/* hold the gfn of each spte inside spt */
>   	gfn_t *gfns;
> +#ifdef CONFIG_KVM_MMU_PRIVATE
> +	/* associated private shadow page, e.g. SEPT page */
> +	void *private_sp;
> +#endif
>   	/* Currently serving as active root */
>   	union {
>   		int root_count;
> @@ -104,6 +108,86 @@ static inline int kvm_mmu_page_as_id(struct kvm_mmu_page *sp)
>   	return kvm_mmu_role_as_id(sp->role);
>   }
>   
> +/*
> + * TDX vcpu allocates page for root Secure EPT page and assigns to CPU secure
> + * EPT pointer.  KVM doesn't need to allocate and link to the secure EPT.
> + * Dummy value to make is_pivate_sp() return true.
> + */
> +#define KVM_MMU_PRIVATE_SP_ROOT	((void *)1)
> +
> +#ifdef CONFIG_KVM_MMU_PRIVATE
> +static inline bool is_private_sp(struct kvm_mmu_page *sp)
> +{
> +	return !!sp->private_sp;
> +}
> +
> +static inline bool is_private_spte(u64 *sptep)
> +{
> +	return is_private_sp(sptep_to_sp(sptep));
> +}
> +
> +static inline void *kvm_mmu_private_sp(struct kvm_mmu_page *sp)
> +{
> +	return sp->private_sp;
> +}
> +
> +static inline void kvm_mmu_init_private_sp(struct kvm_mmu_page *sp)
> +{
> +	sp->private_sp = NULL;
> +}
> +
> +/* Valid sp->role.level is required. */
> +static inline void kvm_mmu_alloc_private_sp(struct kvm_vcpu *vcpu,
> +					struct kvm_mmu_page *sp)
> +{
> +	if (vcpu->arch.mmu->shadow_root_level == sp->role.level)
> +		sp->private_sp = KVM_MMU_PRIVATE_SP_ROOT;
> +	else
> +		sp->private_sp =
> +			kvm_mmu_memory_cache_alloc(
> +				&vcpu->arch.mmu_private_sp_cache);
> +	/*
> +	 * Because mmu_private_sp_cache is topped up before staring kvm page
> +	 * fault resolving, the allocation above shouldn't fail.
> +	 */
> +	WARN_ON_ONCE(!sp->private_sp);
> +}
> +
> +static inline void kvm_mmu_free_private_sp(struct kvm_mmu_page *sp)
> +{
> +	if (sp->private_sp != KVM_MMU_PRIVATE_SP_ROOT)
> +		free_page((unsigned long)sp->private_sp);
> +}
> +#else
> +static inline bool is_private_sp(struct kvm_mmu_page *sp)
> +{
> +	return false;
> +}
> +
> +static inline bool is_private_spte(u64 *sptep)
> +{
> +	return false;
> +}
> +
> +static inline void *kvm_mmu_private_sp(struct kvm_mmu_page *sp)
> +{
> +	return NULL;
> +}
> +
> +static inline void kvm_mmu_init_private_sp(struct kvm_mmu_page *sp)
> +{
> +}
> +
> +static inline void kvm_mmu_alloc_private_sp(struct kvm_vcpu *vcpu,
> +					struct kvm_mmu_page *sp)
> +{
> +}
> +
> +static inline void kvm_mmu_free_private_sp(struct kvm_mmu_page *sp)
> +{
> +}
> +#endif
> +
>   static inline bool kvm_mmu_page_ad_need_write_protect(struct kvm_mmu_page *sp)
>   {
>   	/*
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 8db262440d5c..a68f3a22836b 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -59,6 +59,8 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
>   
>   static void tdp_mmu_free_sp(struct kvm_mmu_page *sp)
>   {
> +	if (is_private_sp(sp))
> +		kvm_mmu_free_private_sp(sp);
>   	free_page((unsigned long)sp->spt);
>   	kmem_cache_free(mmu_page_header_cache, sp);
>   }
> @@ -184,6 +186,7 @@ static struct kvm_mmu_page *alloc_tdp_mmu_page(struct kvm_vcpu *vcpu, gfn_t gfn,
>   	sp->role.word = page_role_for_level(vcpu, level).word;
>   	sp->gfn = gfn;
>   	sp->tdp_mmu_page = true;
> +	kvm_mmu_init_private_sp(sp);
>   
>   	trace_kvm_mmu_get_page(sp, true);
>   

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

