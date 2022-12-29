Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E97C165930D
	for <lists+kvm@lfdr.de>; Fri, 30 Dec 2022 00:09:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234185AbiL2XI6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Dec 2022 18:08:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiL2XI5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Dec 2022 18:08:57 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCE5C16487
        for <kvm@vger.kernel.org>; Thu, 29 Dec 2022 15:08:55 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id r18so13204669pgr.12
        for <kvm@vger.kernel.org>; Thu, 29 Dec 2022 15:08:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1uBF/3j0WIDXFgMLD0BBFJnaPRgXW8rWIdUqCliUk28=;
        b=o8k176u9Fx68XEZFOaqbZrvDBhoKwKHTUECLvK6Rlq/LAUShh33PlDmF3tmzRHhAP7
         XuwaxNjDpAhjMiGQzvflmsJiPud4SuTSHjEBb0KN8/+eSUuRp1hsWkyMpGAlBIr+x5pU
         ztG5QuFqbnQwl6PRrmnAmaVs13Lg09Of6MDyvmHpyYw7FYEQ++UlzVWRY7y0kLJKbM6i
         kqfhSSmpwLWZrdMbfWIIkInnNFWtjnkxM4j+PTieAZl2V4RCCBhh/7x2f1rp8Bbeq7DK
         2dSiTggk0pfuWdS6PlKsKArPRHtZXSRVjYCCQO2aHtiOFeW4QqVlypQYc5k9trhLicDY
         avng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1uBF/3j0WIDXFgMLD0BBFJnaPRgXW8rWIdUqCliUk28=;
        b=KxvmYXzWjvzf9pev20OT4yEPvARrqH3hOVViNn92p818muLIVBk4zOf/F6eUK4qg9A
         zbA1w7bK92qn/q1KMr6BFJTARvHKjqL2rOHYYhUX7Ca+5UHnC0CPFUjBf3fKJiAmi2zp
         riI8uPSW+vu784hmrJWkRztuJo3rzRudWL5GsDp7ChjDEbiMsXYYW6cEiXXXY7DBD769
         4rIKbHUe8dzdmh0aVLZy69kxCn1tQxEcEAKVz1JF8tO4B0iQ7IFzxrWzt4baOxI6EY7r
         MraqSwznpqWaCx7LLMMFjeGdsKmpcZjwogGeMYkm5rc5Jhgoe7ocVYJadNu75PrFR8Nx
         smLQ==
X-Gm-Message-State: AFqh2kphUL4lMovO4VzVDgsROcSx/yxfIh7ZsEWzCFt0b2UHy7kO0PGt
        3L3Og7llKArjzUAxFUEiOGvT3Q==
X-Google-Smtp-Source: AMrXdXtiQJ2APm1XDpUKD4aOX4bgyZq7ptUcOV4ia83xtCM09AOcKsEzaKoIy1g8Rf/Ibarmbr2zgg==
X-Received: by 2002:a62:1550:0:b0:576:f02e:d0ef with SMTP id 77-20020a621550000000b00576f02ed0efmr33039487pfv.4.1672355334973;
        Thu, 29 Dec 2022 15:08:54 -0800 (PST)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id i15-20020a056a00004f00b005769eed61e3sm12509793pfk.83.2022.12.29.15.08.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Dec 2022 15:08:54 -0800 (PST)
Date:   Thu, 29 Dec 2022 15:08:50 -0800
From:   David Matlack <dmatlack@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, bgardon@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Patch v3 6/9] KVM: Provide NUMA node support to
 kvm_mmu_memory_cache{}
Message-ID: <Y64eAvm4JglT1au4@google.com>
References: <20221222023457.1764-1-vipinsh@google.com>
 <20221222023457.1764-7-vipinsh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221222023457.1764-7-vipinsh@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 21, 2022 at 06:34:54PM -0800, Vipin Sharma wrote:
> Add 'node' variable in kvm_mmu_memory_cache{} to denote which NUMA node
> this cache should allocate memory from. Default initialize to
> NUMA_NO_NODE in all architectures.
> 
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> ---
>  arch/arm64/kvm/arm.c      |  2 +-
>  arch/arm64/kvm/mmu.c      |  4 +++-
>  arch/mips/kvm/mips.c      |  2 ++
>  arch/riscv/kvm/mmu.c      |  2 +-
>  arch/riscv/kvm/vcpu.c     |  2 +-
>  arch/x86/kvm/mmu/mmu.c    | 22 ++++++++++++----------
>  include/linux/kvm_host.h  |  6 ++++++
>  include/linux/kvm_types.h |  2 ++
>  8 files changed, 28 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 9c5573bc4614..52a41f4532e2 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -340,7 +340,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>  	vcpu->arch.target = -1;
>  	bitmap_zero(vcpu->arch.features, KVM_VCPU_MAX_FEATURES);
>  
> -	vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
> +	INIT_KVM_MMU_MEMORY_CACHE(&vcpu->arch.mmu_page_cache, NULL, NUMA_NO_NODE);
>  
>  	/*
>  	 * Default value for the FP state, will be overloaded at load
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 31d7fa4c7c14..bd07155e17fa 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -894,12 +894,14 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
>  {
>  	phys_addr_t addr;
>  	int ret = 0;
> -	struct kvm_mmu_memory_cache cache = { .gfp_zero = __GFP_ZERO };
> +	struct kvm_mmu_memory_cache cache;
>  	struct kvm_pgtable *pgt = kvm->arch.mmu.pgt;
>  	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_DEVICE |
>  				     KVM_PGTABLE_PROT_R |
>  				     (writable ? KVM_PGTABLE_PROT_W : 0);
>  
> +	INIT_KVM_MMU_MEMORY_CACHE(&cache, NULL, NUMA_NO_NODE);

This is not any better than setting cache.node = NUMA_NO_NODE directly.
Yes it's less lines of code, but it's harder to read (what does NULL
mean here?), and every user of kvm_mmu_memory_cache still has to know to
pass NUMA_NO_NODE.

When I originally gave this suggestion, I intended to suggest that
INIT_KVM_MMU_MEMORY_CACHE() provide just default initialization.
Non-default initialization for gfp_zero, gfp_custom, kmem_cache, and
node would remain as they are.

Yes this adds some more lines, but keeps things readable, and doesn't
every initialization site of kvm_mmu_memory_cache to know what to pass
for gfp_zero, node, and kmem_cache. It only needs to set the fields
*it* cares about.

Here's what I mean specifically, based on INIT_LIST_HEAD. I don't think
I got all the kvm_mmu_memory_cache users, but you get the point.


diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 9c5573bc4614..0e138dcaf4d4 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -340,6 +340,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	vcpu->arch.target = -1;
 	bitmap_zero(vcpu->arch.features, KVM_VCPU_MAX_FEATURES);
 
+	INIT_KVM_MMU_MEMORY_CACHE(&vcpu->arch.mmu_page_cache);
 	vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
 
 	/*
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 31d7fa4c7c14..f5fd78a4f084 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -894,12 +894,14 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 {
 	phys_addr_t addr;
 	int ret = 0;
-	struct kvm_mmu_memory_cache cache = { .gfp_zero = __GFP_ZERO };
+	KVM_MMU_MEMORY_CACHE(cache);
 	struct kvm_pgtable *pgt = kvm->arch.mmu.pgt;
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_DEVICE |
 				     KVM_PGTABLE_PROT_R |
 				     (writable ? KVM_PGTABLE_PROT_W : 0);
 
+	cache.gfp_zero = __GFP_ZERO;
+
 	if (is_protected_kvm_enabled())
 		return -EPERM;
 
diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index 34b57e0be2ef..7915a5a2d104 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -351,10 +351,11 @@ int kvm_riscv_gstage_ioremap(struct kvm *kvm, gpa_t gpa,
 	int ret = 0;
 	unsigned long pfn;
 	phys_addr_t addr, end;
-	struct kvm_mmu_memory_cache pcache = {
-		.gfp_custom = (in_atomic) ? GFP_ATOMIC | __GFP_ACCOUNT : 0,
-		.gfp_zero = __GFP_ZERO,
-	};
+	KVM_MMU_MEMORY_CACHE(pcache);
+
+	pcache.gfp_zero = __GFP_ZERO;
+	if (in_atomic)
+		pcache.gfp_custom = GFP_ATOMIC | __GFP_ACCOUNT;
 
 	end = (gpa + size + PAGE_SIZE - 1) & PAGE_MASK;
 	pfn = __phys_to_pfn(hpa);
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 7c08567097f0..3d73ab3ec9a4 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -161,6 +161,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 
 	/* Mark this VCPU never ran */
 	vcpu->arch.ran_atleast_once = false;
+	INIT_KVM_MMU_MEMORY_CACHE(&vcpu->arch.mmu_page_header_cache);
 	vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
 	bitmap_zero(vcpu->arch.isa, RISCV_ISA_EXT_MAX);
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 254bc46234e0..d4cd8e64cc03 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5909,14 +5909,19 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
 {
 	int ret;
 
+	INIT_KVM_MMU_MEMORY_CACHE(&vcpu->arch.mmu_pte_list_desc_cache);
 	vcpu->arch.mmu_pte_list_desc_cache.kmem_cache = pte_list_desc_cache;
 	vcpu->arch.mmu_pte_list_desc_cache.gfp_zero = __GFP_ZERO;
 
+	INIT_KVM_MMU_MEMORY_CACHE(&vcpu->arch.mmu_page_header_cache);
 	vcpu->arch.mmu_page_header_cache.kmem_cache = mmu_page_header_cache;
 	vcpu->arch.mmu_page_header_cache.gfp_zero = __GFP_ZERO;
 
+	INIT_KVM_MMU_MEMORY_CACHE(&vcpu->arch.mmu_shadow_page_cache);
 	vcpu->arch.mmu_shadow_page_cache.gfp_zero = __GFP_ZERO;
 
+	INIT_KVM_MMU_MEMORY_CACHE(&vcpu->arch.mmu_shadowed_info_cache);
+
 	vcpu->arch.mmu = &vcpu->arch.root_mmu;
 	vcpu->arch.walk_mmu = &vcpu->arch.root_mmu;
 
@@ -6083,11 +6088,14 @@ int kvm_mmu_init_vm(struct kvm *kvm)
 	node->track_flush_slot = kvm_mmu_invalidate_zap_pages_in_memslot;
 	kvm_page_track_register_notifier(kvm, node);
 
+	INIT_KVM_MMU_MEMORY_CACHE(&kvm->arch.split_page_header_cache);
 	kvm->arch.split_page_header_cache.kmem_cache = mmu_page_header_cache;
 	kvm->arch.split_page_header_cache.gfp_zero = __GFP_ZERO;
 
+	INIT_KVM_MMU_MEMORY_CACHE(&kvm->arch.split_shadow_page_cache);
 	kvm->arch.split_shadow_page_cache.gfp_zero = __GFP_ZERO;
 
+	INIT_KVM_MMU_MEMORY_CACHE(&kvm->arch.split_desc_cache);
 	kvm->arch.split_desc_cache.kmem_cache = pte_list_desc_cache;
 	kvm->arch.split_desc_cache.gfp_zero = __GFP_ZERO;
 
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index 76de36e56cdf..eb7ff9afa5c7 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -98,6 +98,17 @@ struct kvm_mmu_memory_cache {
 	int capacity;
 	void **objects;
 };
+
+#define KVM_MMU_MEMORY_CACHE_INIT() (struct kvm_mmu_memory_cache) { \
+}
+
+#define KVM_MMU_MEMORY_CACHE(_name) \
+	struct kvm_mmu_memory_cache _name = KVM_MMU_MEMORY_CACHE_INIT()
+
+static inline void INIT_KVM_MMU_MEMORY_CACHE(struct kvm_mmu_memory_cache *cache)
+{
+	*cache = KVM_MMU_MEMORY_CACHE_INIT();
+}
 #endif
 
 #define HALT_POLL_HIST_COUNT			32

> +
>  	if (is_protected_kvm_enabled())
>  		return -EPERM;
>  
> diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
> index a25e0b73ee70..b017c29a9340 100644
> --- a/arch/mips/kvm/mips.c
> +++ b/arch/mips/kvm/mips.c
> @@ -304,6 +304,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>  		     HRTIMER_MODE_REL);
>  	vcpu->arch.comparecount_timer.function = kvm_mips_comparecount_wakeup;
>  
> +	vcpu->arch.mmu_page_cache.node = NUMA_NO_NODE;
> +
>  	/*
>  	 * Allocate space for host mode exception handlers that handle
>  	 * guest mode exits
> diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> index 34b57e0be2ef..119de4520cc6 100644
> --- a/arch/riscv/kvm/mmu.c
> +++ b/arch/riscv/kvm/mmu.c
> @@ -353,9 +353,9 @@ int kvm_riscv_gstage_ioremap(struct kvm *kvm, gpa_t gpa,
>  	phys_addr_t addr, end;
>  	struct kvm_mmu_memory_cache pcache = {
>  		.gfp_custom = (in_atomic) ? GFP_ATOMIC | __GFP_ACCOUNT : 0,
> -		.gfp_zero = __GFP_ZERO,
>  	};
>  
> +	INIT_KVM_MMU_MEMORY_CACHE(&pcache, NULL, NUMA_NO_NODE);
>  	end = (gpa + size + PAGE_SIZE - 1) & PAGE_MASK;
>  	pfn = __phys_to_pfn(hpa);
>  
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index 7c08567097f0..189b14feb365 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -161,7 +161,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>  
>  	/* Mark this VCPU never ran */
>  	vcpu->arch.ran_atleast_once = false;
> -	vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
> +	INIT_KVM_MMU_MEMORY_CACHE(&vcpu->arch.mmu_page_cache, NULL, NUMA_NO_NODE);
>  	bitmap_zero(vcpu->arch.isa, RISCV_ISA_EXT_MAX);
>  
>  	/* Setup ISA features available to VCPU */
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 6f6a10d7a871..23a3b82b2384 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5954,13 +5954,14 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
>  {
>  	int ret;
>  
> -	vcpu->arch.mmu_pte_list_desc_cache.kmem_cache = pte_list_desc_cache;
> -	vcpu->arch.mmu_pte_list_desc_cache.gfp_zero = __GFP_ZERO;
> +	INIT_KVM_MMU_MEMORY_CACHE(&vcpu->arch.mmu_pte_list_desc_cache,
> +				  pte_list_desc_cache, NUMA_NO_NODE);
>  
> -	vcpu->arch.mmu_page_header_cache.kmem_cache = mmu_page_header_cache;
> -	vcpu->arch.mmu_page_header_cache.gfp_zero = __GFP_ZERO;
> +	INIT_KVM_MMU_MEMORY_CACHE(&vcpu->arch.mmu_page_header_cache,
> +				  mmu_page_header_cache, NUMA_NO_NODE);
>  
> -	vcpu->arch.mmu_shadow_page_cache.gfp_zero = __GFP_ZERO;
> +	INIT_KVM_MMU_MEMORY_CACHE(&vcpu->arch.mmu_shadow_page_cache,
> +				  NULL, NUMA_NO_NODE);
>  	spin_lock_init(&vcpu->arch.mmu_shadow_page_cache_lock);
>  
>  	vcpu->arch.mmu = &vcpu->arch.root_mmu;
> @@ -6124,14 +6125,15 @@ int kvm_mmu_init_vm(struct kvm *kvm)
>  	node->track_flush_slot = kvm_mmu_invalidate_zap_pages_in_memslot;
>  	kvm_page_track_register_notifier(kvm, node);
>  
> -	kvm->arch.split_page_header_cache.kmem_cache = mmu_page_header_cache;
> -	kvm->arch.split_page_header_cache.gfp_zero = __GFP_ZERO;
> +	INIT_KVM_MMU_MEMORY_CACHE(&kvm->arch.split_page_header_cache,
> +				  mmu_page_header_cache, NUMA_NO_NODE);
>  
> -	kvm->arch.split_shadow_page_cache.gfp_zero = __GFP_ZERO;
> +	INIT_KVM_MMU_MEMORY_CACHE(&kvm->arch.split_shadow_page_cache,
> +				  NULL, NUMA_NO_NODE);
>  	spin_lock_init(&kvm->arch.split_shadow_page_cache_lock);
>  
> -	kvm->arch.split_desc_cache.kmem_cache = pte_list_desc_cache;
> -	kvm->arch.split_desc_cache.gfp_zero = __GFP_ZERO;
> +	INIT_KVM_MMU_MEMORY_CACHE(&kvm->arch.split_desc_cache,
> +				  pte_list_desc_cache, NUMA_NO_NODE);
>  
>  	return 0;
>  }
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index a262e15ebd19..719687a37ef7 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2302,4 +2302,10 @@ static inline void kvm_account_pgtable_pages(void *virt, int nr)
>  /* Max number of entries allowed for each kvm dirty ring */
>  #define  KVM_DIRTY_RING_MAX_ENTRIES  65536
>  
> +#define INIT_KVM_MMU_MEMORY_CACHE(_cache, _kmem_cache, _node) ({	\
> +	(_cache)->kmem_cache = _kmem_cache;				\
> +	(_cache)->gfp_zero = __GFP_ZERO;				\
> +	(_cache)->node = _node;						\
> +})
> +
>  #endif
> diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
> index 76de36e56cdf..9c70ce95e51f 100644
> --- a/include/linux/kvm_types.h
> +++ b/include/linux/kvm_types.h
> @@ -97,6 +97,8 @@ struct kvm_mmu_memory_cache {
>  	struct kmem_cache *kmem_cache;
>  	int capacity;
>  	void **objects;
> +	/* Node on which memory should be allocated by default */
> +	int node;
>  };
>  #endif
>  
> -- 
> 2.39.0.314.g84b9a713c41-goog
> 
