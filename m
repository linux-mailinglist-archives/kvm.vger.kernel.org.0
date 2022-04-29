Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8FA95146D8
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 12:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357512AbiD2Kjo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 06:39:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239189AbiD2Kjm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 06:39:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DF2786D4FF
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 03:36:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651228583;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=knWK0Y8frXg6J98D5BcmAr8AdGVxrh9ZiI9zaWutHAM=;
        b=SmIYSuDWO9owVGJYxDgM0bjgF/emzRbBK+6R1yaMNqdgklOU9F2k/MdO9qR8hboCf5GEHJ
        XXiOClNAndp9AGUur5sSreR/hPluvgluK9cQB1zFoQEKBCQJyGHIwJTlMbB+uAtRw/YapY
        /92kIjNSHGARaUU4GqVjgVJtd9oUKZk=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-64-KpX6VbFdMGqzi1FWpcMTcA-1; Fri, 29 Apr 2022 06:36:22 -0400
X-MC-Unique: KpX6VbFdMGqzi1FWpcMTcA-1
Received: by mail-ed1-f70.google.com with SMTP id n4-20020a5099c4000000b00418ed58d92fso4316976edb.0
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 03:36:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=knWK0Y8frXg6J98D5BcmAr8AdGVxrh9ZiI9zaWutHAM=;
        b=xKyjawWUHlJCJTr8R6xie0SRm2Set41ZhMVV77Zo6WEJjOVbugi9dBimfCxGMcFMbG
         UVPHO0CypEG9xghNgkvb7+oDurrUbqPoE/TK6pZX7GUTm0e9F+iY4FcZtZPADNgL4Asd
         0f4o0sSKzLtfMa0ZQkVG4zV+70/75KmxXGC8q7cTzFyXvMlcfsed8v72eXZbVIetuqob
         r3gfQXCQbsoA5v5hrG+OgREJ/1es8AVvmYjS5HXUQSy3CICRIy9NbphJIH4U+/kyKRpR
         oIIcyo//vQT9eJH0/bts39WsCj9oUJ+VskL27m4/MLRcfVHw1xWxivx9+U/ZQMggnSe5
         BJtA==
X-Gm-Message-State: AOAM530zQcNMeja6xVYBt4LOsvqVS79sf8C4B+PgtAipGZRrVm4fyKtv
        bmKiaS1/NfVFd4P+tb/2Qdm5+082NQPlx8ViJ/8yyu4vLx0446GFHnZY4Q83bUP6ueStGwDJP01
        42XF2/7KYFc9Z
X-Received: by 2002:a17:907:62a9:b0:6da:7953:4df0 with SMTP id nd41-20020a17090762a900b006da79534df0mr35562115ejc.316.1651228580130;
        Fri, 29 Apr 2022 03:36:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzjNUwFr2ENYmQquNOdOGTCTOiQRf4+2XbN/e53rcyNLLCKXfuQZPAme1QwaBZUJFq7LeDa8w==
X-Received: by 2002:a17:907:62a9:b0:6da:7953:4df0 with SMTP id nd41-20020a17090762a900b006da79534df0mr35562094ejc.316.1651228579840;
        Fri, 29 Apr 2022 03:36:19 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id jz26-20020a17090775fa00b006f3ef214e49sm515627ejc.175.2022.04.29.03.36.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Apr 2022 03:36:18 -0700 (PDT)
Message-ID: <337332ca-835c-087c-c99b-92c35ea8dcd3@redhat.com>
Date:   Fri, 29 Apr 2022 12:36:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>
References: <20220428233416.2446833-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: x86/mmu: Do not create SPTEs for GFNs that exceed
 host.MAXPHYADDR
In-Reply-To: <20220428233416.2446833-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/29/22 01:34, Sean Christopherson wrote:

> +static inline gfn_t kvm_mmu_max_gfn_host(void)
> +{
> +	/*
> +	 * Disallow SPTEs (via memslots or cached MMIO) whose gfn would exceed
> +	 * host.MAXPHYADDR.  Assuming KVM is running on bare metal, guest
> +	 * accesses beyond host.MAXPHYADDR will hit a #PF(RSVD) and never hit
> +	 * an EPT Violation/Misconfig / #NPF, and so KVM will never install a
> +	 * SPTE for such addresses.  That doesn't hold true if KVM is running
> +	 * as a VM itself, e.g. if the MAXPHYADDR KVM sees is less than
> +	 * hardware's real MAXPHYADDR, but since KVM can't honor such behavior
> +	 * on bare metal, disallow it entirely to simplify e.g. the TDP MMU.
> +	 */
> +	return (1ULL << (shadow_phys_bits - PAGE_SHIFT)) - 1;

The host.MAXPHYADDR however does not matter if EPT/NPT is not in use, because
the shadow paging fault path can accept any gfn.

> -static inline gfn_t tdp_mmu_max_gfn_host(void)
> +static inline gfn_t tdp_mmu_max_exclusive_gfn_host(void)
>   {
>   	/*
> -	 * Bound TDP MMU walks at host.MAXPHYADDR, guest accesses beyond that
> -	 * will hit a #PF(RSVD) and never hit an EPT Violation/Misconfig / #NPF,
> -	 * and so KVM will never install a SPTE for such addresses.
> +	 * Bound TDP MMU walks at host.MAXPHYADDR.  KVM disallows memslots with
> +	 * a gpa range that would exceed the max gfn, and KVM does not create
> +	 * MMIO SPTEs for "impossible" gfns, instead sending such accesses down
> +	 * the slow emulation path every time.
>   	 */
> -	return 1ULL << (shadow_phys_bits - PAGE_SHIFT);
> +	return kvm_mmu_max_gfn_host() + 1;
>   }

Slightly nicer name, tdp_mmu_max_gfn_exclusive().  It has to be the host
one because EPT/NPT is in use, but it doesn't really matter.

> +		 * whose gfn is greater than host.MAXPHYADDR, any guest that
> +		 * generates such gfns is either malicious or in the weeds.
> +		 * Note, it's possible to observe a gfn > host.MAXPHYADDR if
> +		 * and only if host.MAXPHYADDR is inaccurate with respect to
> +		 * hardware behavior, e.g. if KVM itself is running as a VM.

I don't think maliciousness is particularly likely, and "in the weeds" implies
L2 is the buggy one.  Slightly more accurate:

         * whose gfn is greater than host.MAXPHYADDR, any guest that
         * generates such gfns is running nested and is being tricked
         * by L0 userspace (you can observe gfn > L1.MAXPHYADDR if
         * and only if L1's MAXPHYADDR is inaccurate with respect to
         * the hardware's).

Putting everything together and rebasing on top of kvm/master:

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index e6cae6f22683..dba275d323a7 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -65,6 +65,30 @@ static __always_inline u64 rsvd_bits(int s, int e)
  	return ((2ULL << (e - s)) - 1) << s;
  }
  
+/*
+ * The number of non-reserved physical address bits irrespective of features
+ * that repurpose legal bits, e.g. MKTME.
+ */
+extern u8 __read_mostly shadow_phys_bits;
+
+static inline gfn_t kvm_mmu_max_gfn(void)
+{
+	/*
+	 * Note that this uses the host MAXPHYADDR, not the guest's.
+	 * EPT/NPT cannot support GPAs that would exceed host.MAXPHYADDR;
+	 * assuming KVM is running on bare metal, guest accesses beyond
+	 * host.MAXPHYADDR will hit a #PF(RSVD) and never cause a vmexit
+	 * (either EPT Violation/Misconfig or #NPF), and so KVM will never
+	 * install a SPTE for such addresses.  If KVM is running as a VM
+	 * itself, on the other hand, it might see a MAXPHYADDR that is less
+	 * than hardware's real MAXPHYADDR.  Using the host MAXPHYADDR
+	 * disallows such SPTEs entirely and simplifies the TDP MMU.
+	 */
+	int max_gpa_bits = likely(tdp_enabled) ? shadow_phys_bits : 52;
+
+	return (1ULL << (max_gpa_bits - PAGE_SHIFT)) - 1;
+}
+
  void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask);
  void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only);
  
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index af7910a46c12..7b632a4f81cb 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3033,9 +3033,15 @@ static bool handle_abnormal_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fa
  		/*
  		 * If MMIO caching is disabled, emulate immediately without
  		 * touching the shadow page tables as attempting to install an
-		 * MMIO SPTE will just be an expensive nop.
+		 * MMIO SPTE will just be an expensive nop.  Do not cache MMIO
+		 * whose gfn is greater than host.MAXPHYADDR, any guest that
+		 * generates such gfns is running nested and is being tricked
+		 * by L0 userspace (you can observe gfn > L1.MAXPHYADDR if
+		 * and only if L1's MAXPHYADDR is inaccurate with respect to
+		 * the hardware's).
  		 */
-		if (unlikely(!shadow_mmio_value)) {
+		if (unlikely(!shadow_mmio_value) ||
+		    unlikely(fault->gfn > kvm_mmu_max_gfn())) {
  			*ret_val = RET_PF_EMULATE;
  			return true;
  		}
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 73f12615416f..e4abeb5df1b1 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -201,12 +201,6 @@ static inline bool is_removed_spte(u64 spte)
   */
  extern u64 __read_mostly shadow_nonpresent_or_rsvd_lower_gfn_mask;
  
-/*
- * The number of non-reserved physical address bits irrespective of features
- * that repurpose legal bits, e.g. MKTME.
- */
-extern u8 __read_mostly shadow_phys_bits;
-
  static inline bool is_mmio_spte(u64 spte)
  {
  	return (spte & shadow_mmio_mask) == shadow_mmio_value &&
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index c472769e0300..edc68538819b 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -815,14 +815,15 @@ static inline bool __must_check tdp_mmu_iter_cond_resched(struct kvm *kvm,
  	return iter->yielded;
  }
  
-static inline gfn_t tdp_mmu_max_gfn_host(void)
+static inline gfn_t tdp_mmu_max_gfn_exclusive(void)
  {
  	/*
-	 * Bound TDP MMU walks at host.MAXPHYADDR, guest accesses beyond that
-	 * will hit a #PF(RSVD) and never hit an EPT Violation/Misconfig / #NPF,
-	 * and so KVM will never install a SPTE for such addresses.
+	 * Bound TDP MMU walks at host.MAXPHYADDR.  KVM disallows memslots with
+	 * a gpa range that would exceed the max gfn, and KVM does not create
+	 * MMIO SPTEs for "impossible" gfns, instead sending such accesses down
+	 * the slow emulation path every time.
  	 */
-	return 1ULL << (shadow_phys_bits - PAGE_SHIFT);
+	return kvm_mmu_max_gfn() + 1;
  }
  
  static void __tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
@@ -830,7 +831,7 @@ static void __tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
  {
  	struct tdp_iter iter;
  
-	gfn_t end = tdp_mmu_max_gfn_host();
+	gfn_t end = tdp_mmu_max_gfn_exclusive();
  	gfn_t start = 0;
  
  	for_each_tdp_pte_min_level(iter, root, zap_level, start, end) {
@@ -923,7 +924,7 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
  {
  	struct tdp_iter iter;
  
-	end = min(end, tdp_mmu_max_gfn_host());
+	end = min(end, tdp_mmu_max_gfn_exclusive());
  
  	lockdep_assert_held_write(&kvm->mmu_lock);
  
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 278b2fdd3590..015ecc249c2e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11994,8 +11994,12 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
  				   struct kvm_memory_slot *new,
  				   enum kvm_mr_change change)
  {
-	if (change == KVM_MR_CREATE || change == KVM_MR_MOVE)
+	if (change == KVM_MR_CREATE || change == KVM_MR_MOVE) {
+		if ((new->base_gfn + new->npages - 1) > kvm_mmu_max_gfn())
+			return -EINVAL;
+
  		return kvm_alloc_memslot_metadata(kvm, new);
+	}
  
  	if (change == KVM_MR_FLAGS_ONLY)
  		memcpy(&new->arch, &old->arch, sizeof(old->arch));

