Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0A9E6CF2AF
	for <lists+kvm@lfdr.de>; Wed, 29 Mar 2023 21:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbjC2TEN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Mar 2023 15:04:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230057AbjC2TEL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Mar 2023 15:04:11 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E71B6A6B
        for <kvm@vger.kernel.org>; Wed, 29 Mar 2023 12:04:03 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id dw14so10966673pfb.6
        for <kvm@vger.kernel.org>; Wed, 29 Mar 2023 12:04:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680116643;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SMGM08tRxG27yXqBsfq0V5zIva3ZJOMRax6YddvPX/s=;
        b=JO15gFo8XUkNpMUv9jpbA9ppGSO/f07bF6P1yHTnuh5QRE1vZ01coAufA6yFmq2/nv
         v4WGCevI+v25hYy27Bh2f6zmjUJNNyqL+fxbbQDUO4N5IRja5SsfNEfO9g2paxVtwYDs
         a2qZUWACtWbjDscC6/oX57rHN7CoSIOtDNzYMoeGFR2dND/oUTCRjgpSTnS+vJfICvkd
         rdG92vKGLKXy2uG8JY9KXqWBQQdFi6F0JQVyMlWzpTiYVyonwPLIV4TXCWLIAP3HWgmn
         VPBeOcTyRbmn4sW7kUZLEHdUnA1sg9a39yMaHGXb/MfHmfskMoRTPd4mMZxCqZ/+OrLh
         4SBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680116643;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SMGM08tRxG27yXqBsfq0V5zIva3ZJOMRax6YddvPX/s=;
        b=Mx7bLSBC7JXFlbmswboRm9pr5TPu22A7ffXg6FXp7Ttf22YU5wZOLeyvJM+jekIiAp
         T28moNnO3Fx4Ot6ZcwF9ydCor2s+amvUMWGJXZ2JZsSwho4GTZJhxlIZPVzrmUrqcRP5
         l5McQFp0MoFwEkWpukFXOFnpChaasIwp0lVFnosL5LKg8dbGwdf+AUEraAjgdA9JvBxj
         5yfXhBaZp1E9dJqxJAGcy9OwmUfOn+HJ9tiInEFiipvV+J3AX0rtMmAJwhkaKzJOV+tj
         j5jmDsuxaO9u+OlOdKxB28QMdgqizPSo8pMdEPF/bDD2BT0WvZwnlwocWrAYaP+XJeuL
         gnuQ==
X-Gm-Message-State: AAQBX9c3qgzZla9vdd/h/wLkB4GeqwMinHThIUqiBdSZBHzr+eS3AGFS
        bQ1O0xXUVOf+wxtb1tZaFZpyWW5t/iS66mb18ATH2A==
X-Google-Smtp-Source: AKy350YFmtvf9vr/uMGgsbmXySwi49qNAWnBorwC6uCwaZQADMmVUftLKwvp7ngDnae9ihpT+2M25A==
X-Received: by 2002:a62:1b47:0:b0:62a:1267:2042 with SMTP id b68-20020a621b47000000b0062a12672042mr18889438pfb.2.1680116642624;
        Wed, 29 Mar 2023 12:04:02 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id g6-20020aa78186000000b00592417157f2sm24102087pfi.148.2023.03.29.12.04.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 12:04:01 -0700 (PDT)
Date:   Wed, 29 Mar 2023 12:03:57 -0700
From:   David Matlack <dmatlack@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, bgardon@google.com,
        jmattson@google.com, mizhang@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Patch v4 16/18] KVM: x86/mmu: Allocate numa aware page tables
 during page fault
Message-ID: <ZCSLnRj2V5tOx4gU@google.com>
References: <20230306224127.1689967-1-vipinsh@google.com>
 <20230306224127.1689967-17-vipinsh@google.com>
 <ZCOEiVT31xEPKZ3H@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZCOEiVT31xEPKZ3H@google.com>
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 28, 2023 at 05:21:29PM -0700, David Matlack wrote:
> On Mon, Mar 06, 2023 at 02:41:25PM -0800, Vipin Sharma wrote:
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 64de083cd6b9..77d3aa368e5e 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -787,7 +787,7 @@ struct kvm_vcpu_arch {
> >  	struct kvm_mmu *walk_mmu;
> >  
> >  	struct kvm_mmu_memory_cache mmu_pte_list_desc_cache;
> > -	struct kvm_mmu_memory_cache mmu_shadow_page_cache;
> > +	struct kvm_mmu_memory_cache mmu_shadow_page_cache[MAX_NUMNODES];
> 
> I think we need an abstraction for a NUMA-aware mmu cache, since there
> is more than one by the end of this series.
> 
> e.g. A wrapper struct (struct kvm_mmu_numa_memory_cache) or make
> NUMA-awareness an optional feature within kvm_mmu_memory_cache, plus
> common helper functions for operations like initializing, topping-up,
> and freeing.
> 
> I have some ideas I want to try but I ran out of time today.

Something like this (compile test only, applies on top of this series):

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 041302d6132c..b44f867d0ed2 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -787,7 +787,7 @@ struct kvm_vcpu_arch {
 	struct kvm_mmu *walk_mmu;
 
 	struct kvm_mmu_memory_cache mmu_pte_list_desc_cache;
-	struct kvm_mmu_memory_cache mmu_shadow_page_cache[MAX_NUMNODES];
+	struct kvm_mmu_numa_memory_cache mmu_shadow_page_cache;
 	struct kvm_mmu_memory_cache mmu_shadowed_info_cache;
 	struct kvm_mmu_memory_cache mmu_page_header_cache;
 
@@ -1453,7 +1453,7 @@ struct kvm_arch {
 	 *
 	 * Protected by kvm->slots_lock.
 	 */
-	struct kvm_mmu_memory_cache split_shadow_page_cache[MAX_NUMNODES];
+	struct kvm_mmu_numa_memory_cache split_shadow_page_cache;
 	struct kvm_mmu_memory_cache split_page_header_cache;
 
 	/*
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 5463ce6e52fa..fb7b3932f08d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -702,7 +702,7 @@ static void mmu_free_sp_memory_cache(struct kvm_mmu_memory_cache *cache)
 
 static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
 {
-	int r, nid = KVM_MMU_DEFAULT_CACHE_INDEX;
+	int r;
 
 	/* 1 rmap, 1 parent PTE per level, and the prefetched rmaps. */
 	r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache,
@@ -710,16 +710,8 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
 	if (r)
 		return r;
 
-	if (kvm_numa_aware_page_table_enabled(vcpu->kvm)) {
-		for_each_online_node(nid) {
-			r = mmu_topup_sp_memory_cache(&vcpu->arch.mmu_shadow_page_cache[nid],
-						      KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE);
-		}
-	} else {
-		r = mmu_topup_sp_memory_cache(&vcpu->arch.mmu_shadow_page_cache[nid],
-					      KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE);
-	}
-
+	r = kvm_mmu_topup_numa_memory_cache(&vcpu->arch.mmu_shadow_page_cache,
+					    KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE);
 	if (r)
 		return r;
 
@@ -735,12 +727,9 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
 
 static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
 {
-	int nid;
-
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache);
 	mutex_lock(&vcpu->arch.mmu_shadow_page_cache_lock);
-	for_each_node(nid)
-		mmu_free_sp_memory_cache(&vcpu->arch.mmu_shadow_page_cache[nid]);
+	kvm_mmu_free_numa_memory_cache(&vcpu->arch.mmu_shadow_page_cache);
 	mmu_free_sp_memory_cache(&vcpu->arch.mmu_shadowed_info_cache);
 	mutex_unlock(&vcpu->arch.mmu_shadow_page_cache_lock);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache);
@@ -2262,7 +2251,7 @@ static struct kvm_mmu_page *kvm_mmu_get_shadow_page(struct kvm_vcpu *vcpu,
 {
 	struct shadow_page_caches caches = {
 		.page_header_cache = &vcpu->arch.mmu_page_header_cache,
-		.shadow_page_cache = &vcpu->arch.mmu_shadow_page_cache[nid],
+		.shadow_page_cache = &vcpu->arch.mmu_shadow_page_cache.nodes[nid],
 		.shadowed_info_cache = &vcpu->arch.mmu_shadowed_info_cache,
 	};
 
@@ -5977,7 +5966,7 @@ static int __kvm_mmu_create(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
 
 int kvm_mmu_create(struct kvm_vcpu *vcpu)
 {
-	int ret, nid;
+	int ret;
 
 	INIT_KVM_MMU_MEMORY_CACHE(&vcpu->arch.mmu_pte_list_desc_cache);
 	vcpu->arch.mmu_pte_list_desc_cache.kmem_cache = pte_list_desc_cache;
@@ -5985,11 +5974,9 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
 	INIT_KVM_MMU_MEMORY_CACHE(&vcpu->arch.mmu_page_header_cache);
 	vcpu->arch.mmu_page_header_cache.kmem_cache = mmu_page_header_cache;
 
-	for_each_node(nid) {
-		INIT_KVM_MMU_MEMORY_CACHE(&vcpu->arch.mmu_shadow_page_cache[nid]);
-		if (kvm_numa_aware_page_table_enabled(vcpu->kvm))
-			vcpu->arch.mmu_shadow_page_cache[nid].node = nid;
-	}
+	kvm_mmu_init_numa_memory_cache(&vcpu->arch.mmu_shadow_page_cache);
+	if (kvm_numa_aware_page_table_enabled(vcpu->kvm))
+		kvm_mmu_enable_numa_memory_cache(&vcpu->arch.mmu_shadow_page_cache);
 
 	mutex_init(&vcpu->arch.mmu_shadow_page_cache_lock);
 
@@ -6140,7 +6127,7 @@ static void kvm_mmu_invalidate_zap_pages_in_memslot(struct kvm *kvm,
 int kvm_mmu_init_vm(struct kvm *kvm)
 {
 	struct kvm_page_track_notifier_node *node = &kvm->arch.mmu_sp_tracker;
-	int r, nid;
+	int r;
 
 	INIT_LIST_HEAD(&kvm->arch.active_mmu_pages);
 	INIT_LIST_HEAD(&kvm->arch.possible_nx_huge_pages);
@@ -6159,9 +6146,7 @@ int kvm_mmu_init_vm(struct kvm *kvm)
 	INIT_KVM_MMU_MEMORY_CACHE(&kvm->arch.split_page_header_cache);
 	kvm->arch.split_page_header_cache.kmem_cache = mmu_page_header_cache;
 
-	for_each_node(nid)
-		INIT_KVM_MMU_MEMORY_CACHE(&kvm->arch.split_shadow_page_cache[nid]);
-
+	kvm_mmu_init_numa_memory_cache(&kvm->arch.split_shadow_page_cache);
 
 	INIT_KVM_MMU_MEMORY_CACHE(&kvm->arch.split_desc_cache);
 	kvm->arch.split_desc_cache.kmem_cache = pte_list_desc_cache;
@@ -6171,13 +6156,10 @@ int kvm_mmu_init_vm(struct kvm *kvm)
 
 static void mmu_free_vm_memory_caches(struct kvm *kvm)
 {
-	int nid;
-
 	kvm_mmu_free_memory_cache(&kvm->arch.split_desc_cache);
 	kvm_mmu_free_memory_cache(&kvm->arch.split_page_header_cache);
 	mutex_lock(&kvm->slots_lock);
-	for_each_node(nid)
-		mmu_free_sp_memory_cache(&kvm->arch.split_shadow_page_cache[nid]);
+	kvm_mmu_free_numa_memory_cache(&kvm->arch.split_shadow_page_cache);
 	mutex_unlock(&kvm->slots_lock);
 }
 
@@ -6299,7 +6281,7 @@ static bool need_topup_split_caches_or_resched(struct kvm *kvm, int nid)
 	 */
 	return need_topup(&kvm->arch.split_desc_cache, SPLIT_DESC_CACHE_MIN_NR_OBJECTS) ||
 	       need_topup(&kvm->arch.split_page_header_cache, 1) ||
-	       need_topup(&kvm->arch.split_shadow_page_cache[nid], 1);
+	       need_topup(&kvm->arch.split_shadow_page_cache.nodes[nid], 1);
 }
 
 static int topup_split_caches(struct kvm *kvm, int nid)
@@ -6332,7 +6314,7 @@ static int topup_split_caches(struct kvm *kvm, int nid)
 	if (r)
 		return r;
 
-	return mmu_topup_sp_memory_cache(&kvm->arch.split_shadow_page_cache[nid], 1);
+	return mmu_topup_sp_memory_cache(&kvm->arch.split_shadow_page_cache.nodes[nid], 1);
 }
 
 static struct kvm_mmu_page *shadow_mmu_get_sp_for_split(struct kvm *kvm, u64 *huge_sptep,
@@ -6357,7 +6339,7 @@ static struct kvm_mmu_page *shadow_mmu_get_sp_for_split(struct kvm *kvm, u64 *hu
 
 	/* Direct SPs do not require a shadowed_info_cache. */
 	caches.page_header_cache = &kvm->arch.split_page_header_cache;
-	caches.shadow_page_cache = &kvm->arch.split_shadow_page_cache[nid];
+	caches.shadow_page_cache = &kvm->arch.split_shadow_page_cache.nodes[nid];
 
 	/* Safe to pass NULL for vCPU since requesting a direct SP. */
 	return __kvm_mmu_get_shadow_page(kvm, NULL, &caches, gfn, role);
@@ -6760,7 +6742,7 @@ static unsigned long mmu_shrink_scan(struct shrinker *shrink,
 		list_move_tail(&kvm->vm_list, &vm_list);
 
 		kvm_for_each_vcpu(i, vcpu, kvm) {
-			freed += mmu_memory_cache_try_empty(vcpu->arch.mmu_shadow_page_cache,
+			freed += mmu_memory_cache_try_empty(vcpu->arch.mmu_shadow_page_cache.nodes,
 							    MAX_NUMNODES,
 							    &vcpu->arch.mmu_shadow_page_cache_lock);
 			freed += mmu_memory_cache_try_empty(&vcpu->arch.mmu_shadowed_info_cache,
@@ -6769,7 +6751,7 @@ static unsigned long mmu_shrink_scan(struct shrinker *shrink,
 			if (freed >= sc->nr_to_scan)
 				goto out;
 		}
-		freed += mmu_memory_cache_try_empty(kvm->arch.split_shadow_page_cache,
+		freed += mmu_memory_cache_try_empty(kvm->arch.split_shadow_page_cache.nodes,
 						    MAX_NUMNODES, &kvm->slots_lock);
 		if (freed >= sc->nr_to_scan)
 			goto out;
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 63113a66f560..721d5a415807 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -265,7 +265,7 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp(struct kvm_vcpu *vcpu, int nid)
 	struct kvm_mmu_page *sp;
 
 	sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
-	sp->spt = mmu_sp_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache[nid]);
+	sp->spt = mmu_sp_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache.nodes[nid]);
 
 	return sp;
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d8ea39b248cd..940099629626 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6176,7 +6176,7 @@ int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *irq_event,
 int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 			    struct kvm_enable_cap *cap)
 {
-	int r, nid;
+	int r;
 
 	if (cap->flags)
 		return -EINVAL;
@@ -6399,9 +6399,7 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 			kvm->arch.numa_aware_page_table = true;
 
 			mutex_lock(&kvm->slots_lock);
-			for_each_node(nid) {
-				kvm->arch.split_shadow_page_cache[nid].node = nid;
-			}
+			kvm_mmu_enable_numa_memory_cache(&kvm->arch.split_shadow_page_cache);
 			mutex_unlock(&kvm->slots_lock);
 			r = 0;
 		}
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 31586a65e346..d5d966e4a8bf 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1365,6 +1365,11 @@ int kvm_mmu_memory_cache_nr_free_objects(struct kvm_mmu_memory_cache *mc);
 void kvm_mmu_empty_memory_cache(struct kvm_mmu_memory_cache *mc);
 void kvm_mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc);
 void *kvm_mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
+
+void kvm_mmu_init_numa_memory_cache(struct kvm_mmu_numa_memory_cache *cache);
+void kvm_mmu_enable_numa_memory_cache(struct kvm_mmu_numa_memory_cache *cache);
+int kvm_mmu_topup_numa_memory_cache(struct kvm_mmu_numa_memory_cache *cache, int min);
+void kvm_mmu_free_numa_memory_cache(struct kvm_mmu_numa_memory_cache *cache);
 #endif
 
 void kvm_mmu_invalidate_begin(struct kvm *kvm, unsigned long start,
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index 13032da2ddfc..7a58ea37bc15 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -101,6 +101,10 @@ struct kvm_mmu_memory_cache {
 	int node;
 };
 
+struct kvm_mmu_numa_memory_cache {
+	struct kvm_mmu_memory_cache nodes[MAX_NUMNODES];
+};
+
 #define KVM_MMU_MEMORY_CACHE_INIT() {	\
 	.gfp_zero = __GFP_ZERO,		\
 	.node = NUMA_NO_NODE,		\
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 25a549705c8e..2607b546c3c9 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -476,6 +476,43 @@ void *kvm_mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
 	BUG_ON(!p);
 	return p;
 }
+
+void kvm_mmu_init_numa_memory_cache(struct kvm_mmu_numa_memory_cache *cache)
+{
+	int node;
+
+	for_each_node(node)
+		INIT_KVM_MMU_MEMORY_CACHE(&cache->nodes[node]);
+}
+
+void kvm_mmu_enable_numa_memory_cache(struct kvm_mmu_numa_memory_cache *cache)
+{
+	int node;
+
+	for_each_node(node)
+		cache->nodes[node].node = node;
+}
+
+int kvm_mmu_topup_numa_memory_cache(struct kvm_mmu_numa_memory_cache *cache, int min)
+{
+	int r, node;
+
+	for_each_online_node(node) {
+		r = kvm_mmu_topup_memory_cache(&cache->nodes[node], min);
+		if (r)
+			return r;
+	}
+
+	return 0;
+}
+
+void kvm_mmu_free_numa_memory_cache(struct kvm_mmu_numa_memory_cache *cache)
+{
+	int node;
+
+	for_each_node(node)
+		kvm_mmu_free_memory_cache(&cache->nodes[node]);
+}
 #endif
 
 static void kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
