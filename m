Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67E3A6DB522
	for <lists+kvm@lfdr.de>; Fri,  7 Apr 2023 22:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbjDGUU1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 16:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230424AbjDGUUS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 16:20:18 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB6B7C666
        for <kvm@vger.kernel.org>; Fri,  7 Apr 2023 13:20:07 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id v67-20020a254846000000b00b8189f73e94so22644231yba.12
        for <kvm@vger.kernel.org>; Fri, 07 Apr 2023 13:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680898807; x=1683490807;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gDOIz19mFLXVjh2KEN4BbSPwap6txMB8kY9CE7752rg=;
        b=reXZKVgJAcUhKBFqAhAfXZIMQul2LNsezKlEEoHtiLFTJvynT88LRPnZVM8H43my2O
         0AdWQfw3AEOAoOIF7B7AWJxVFSFD/w3Q2pEfhk9TLSFsHjsMCNwDjt1nToC3Erq9lXvB
         g1LbxQEVzYJTdlQ5MYz5hDc9P8gRoRV3iaOFlg0OdPEkY2HKDJ8CNZ5ywg2KOO/iF5t6
         lVplsBeH6uvx9ev0WzAiyQG3vF+n90o7T5CR+YbfiXxyMGTfkTZG4CFGpeaqYlO+IJif
         dO3yYbv3bKl2jMrlV2SrXMEB8JHo/vfYywtDCcW7wAKIKF7yN3CbU+qRkgehxk1sT0AX
         eQgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680898807; x=1683490807;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gDOIz19mFLXVjh2KEN4BbSPwap6txMB8kY9CE7752rg=;
        b=zYsDoiuTiyeYDbE8PxWT+uz0Wo9/n2juZlN05m3yv+8D7pxJ1Xngk/E3KIxs4e6YQS
         pPDvyxyiN0dtwHcLOsfs/MURYuOVIjylQgBr8j2/AEL9f8DTRHQ6xU/hA2iBec4LkOfe
         wtkKfzidOUirtpgoTJu1AH1ngej4cvrMv38pYH0n5ipYy481/I7aTAgnxUIId6fTweMd
         KUpzkIgaQQ5nHC6Htgf/BdjtDZY1mOAASS72tfwKw3V1cdxLsytzAobxY+PwVrbmZEK7
         3AClGKDcM/MQ5nh0fuQZC4k4bDkklgV3Ocls+Uue9A5Bsaf2gwz8h5TUCl15Gzg/NvAN
         yMyw==
X-Gm-Message-State: AAQBX9cYcSJdCLuPveCTvRp1SC/DnXDWEqpqA6svUQxCs+JFHQ8nXjPW
        Dv8gHqnYBZOOsBCzi349DEuOdbpIuNTCEkFhBZXW+NaGZaV0o1g6x9FpR/ZeM44loc/4LLT+WmX
        heUzTkWjH5syL//N2Q8QyTvBnlanpGr9ktUzlm3Fm8usRZ3qPhQrkiuY=
X-Google-Smtp-Source: AKy350bhhE80rWXZROApfO8xLPaZj9ts5o8abPpaSzK+xmA5azXLcrO5jVnu2rk1aXyBf4QNsfLxthLxYg==
X-Received: from sagi.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:241b])
 (user=sagis job=sendgmr) by 2002:a05:6902:909:b0:a27:3ecc:ffe7 with SMTP id
 bu9-20020a056902090900b00a273eccffe7mr5158014ybb.3.1680898807168; Fri, 07 Apr
 2023 13:20:07 -0700 (PDT)
Date:   Fri,  7 Apr 2023 20:19:20 +0000
In-Reply-To: <20230407201921.2703758-1-sagis@google.com>
Mime-Version: 1.0
References: <20230407201921.2703758-1-sagis@google.com>
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <20230407201921.2703758-5-sagis@google.com>
Subject: [RFC PATCH 4/5] KVM: TDX: Implement moving private pages between 2 TDs
From:   Sagi Shahar <sagis@google.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Erdem Aktas <erdemaktas@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sagi Shahar <sagis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Added functionality for moving the private EPT table from one TD to a
new one.

This function moves the root of the private EPT table and overwrite
the root of the destination.

Signed-off-by: Sagi Shahar <sagis@google.com>
---
 arch/x86/kvm/mmu.h         |  2 +
 arch/x86/kvm/mmu/mmu.c     | 60 +++++++++++++++++++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.c | 77 +++++++++++++++++++++++++++++++++++---
 arch/x86/kvm/mmu/tdp_mmu.h |  3 ++
 4 files changed, 137 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index d10b08eeaefee..09bae7fe18a12 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -120,6 +120,8 @@ void kvm_mmu_unload(struct kvm_vcpu *vcpu);
 void kvm_mmu_free_obsolete_roots(struct kvm_vcpu *vcpu);
 void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu);
 void kvm_mmu_sync_prev_roots(struct kvm_vcpu *vcpu);
+int kvm_mmu_move_private_pages_from(struct kvm_vcpu *vcpu,
+				    struct kvm_vcpu *src_vcpu);
 
 static inline int kvm_mmu_reload(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a35f2e7f9bc70..1acc9338323da 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3789,6 +3789,66 @@ static int mmu_first_shadow_root_alloc(struct kvm *kvm)
 	return r;
 }
 
+int kvm_mmu_move_private_pages_from(struct kvm_vcpu *vcpu,
+				    struct kvm_vcpu *src_vcpu)
+{
+	struct kvm_mmu *mmu = vcpu->arch.mmu;
+	struct kvm_mmu *src_mmu = src_vcpu->arch.mmu;
+	gfn_t gfn_shared = kvm_gfn_shared_mask(vcpu->kvm);
+	hpa_t private_root_hpa, shared_root_hpa;
+	int r = -EINVAL;
+
+	// Hold locks for both src and dst. Always take the src lock first.
+	write_lock(&src_vcpu->kvm->mmu_lock);
+	write_lock(&vcpu->kvm->mmu_lock);
+
+	if (!gfn_shared)
+		goto out_unlock;
+
+	WARN_ON_ONCE(!is_tdp_mmu_active(vcpu));
+	WARN_ON_ONCE(!is_tdp_mmu_active(src_vcpu));
+
+	r = mmu_topup_memory_caches(vcpu, !vcpu->arch.mmu->root_role.direct);
+	if (r)
+		goto out_unlock;
+
+	/*
+	 * The private root is moved from the src to the dst and is marked as
+	 * invalid in the src.
+	 */
+	private_root_hpa = kvm_tdp_mmu_move_private_pages_from(vcpu, src_vcpu);
+	if (private_root_hpa == INVALID_PAGE) {
+		/*
+		 * This likely means that the private root was already moved by
+		 * another vCPU.
+		 */
+		private_root_hpa = kvm_tdp_mmu_get_vcpu_root_hpa_no_alloc(vcpu, true);
+		if (private_root_hpa == INVALID_PAGE) {
+			r = -EINVAL;
+			goto out_unlock;
+		}
+	}
+
+	mmu->private_root_hpa = private_root_hpa;
+	src_mmu->private_root_hpa = INVALID_PAGE;
+
+	/*
+	 * The shared root is allocated normally and is not moved from the src.
+	 */
+	shared_root_hpa = kvm_tdp_mmu_get_vcpu_root_hpa(vcpu, false);
+	mmu->root.hpa = shared_root_hpa;
+
+	kvm_mmu_load_pgd(vcpu);
+	static_call(kvm_x86_flush_tlb_current)(vcpu);
+
+out_unlock:
+	write_unlock(&vcpu->kvm->mmu_lock);
+	write_unlock(&src_vcpu->kvm->mmu_lock);
+
+	return r;
+}
+EXPORT_SYMBOL(kvm_mmu_move_private_pages_from);
+
 static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 327dee4f6170e..685528fdc0ad6 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -296,6 +296,23 @@ static void tdp_mmu_init_sp(struct kvm_mmu_page *sp, tdp_ptep_t sptep,
 	trace_kvm_mmu_get_page(sp, true);
 }
 
+static struct kvm_mmu_page *
+kvm_tdp_mmu_get_vcpu_root_no_alloc(struct kvm_vcpu *vcpu, union kvm_mmu_page_role role)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_mmu_page *root;
+
+	lockdep_assert_held_read(&kvm->mmu_lock);
+
+	for_each_tdp_mmu_root(kvm, root, kvm_mmu_role_as_id(role)) {
+		if (root->role.word == role.word &&
+		    kvm_tdp_mmu_get_root(root))
+			return root;
+	}
+
+	return NULL;
+}
+
 static struct kvm_mmu_page *kvm_tdp_mmu_get_vcpu_root(struct kvm_vcpu *vcpu,
 						      bool private)
 {
@@ -311,11 +328,9 @@ static struct kvm_mmu_page *kvm_tdp_mmu_get_vcpu_root(struct kvm_vcpu *vcpu,
 	 */
 	if (private)
 		kvm_mmu_page_role_set_private(&role);
-	for_each_tdp_mmu_root(kvm, root, kvm_mmu_role_as_id(role)) {
-		if (root->role.word == role.word &&
-		    kvm_tdp_mmu_get_root(root))
-			goto out;
-	}
+	root = kvm_tdp_mmu_get_vcpu_root_no_alloc(vcpu, role);
+	if (!!root)
+		goto out;
 
 	root = tdp_mmu_alloc_sp(vcpu, role);
 	tdp_mmu_init_sp(root, NULL, 0);
@@ -330,6 +345,58 @@ static struct kvm_mmu_page *kvm_tdp_mmu_get_vcpu_root(struct kvm_vcpu *vcpu,
 	return root;
 }
 
+hpa_t kvm_tdp_mmu_move_private_pages_from(struct kvm_vcpu *vcpu,
+					  struct kvm_vcpu *src_vcpu)
+{
+	union kvm_mmu_page_role role = vcpu->arch.mmu->root_role;
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm *src_kvm = src_vcpu->kvm;
+	struct kvm_mmu_page *private_root = NULL;
+	struct kvm_mmu_page *root;
+	s64 num_private_pages, old;
+
+	lockdep_assert_held_write(&vcpu->kvm->mmu_lock);
+	lockdep_assert_held_write(&src_vcpu->kvm->mmu_lock);
+
+	/* Find the private root of the source. */
+	kvm_mmu_page_role_set_private(&role);
+	for_each_tdp_mmu_root(src_kvm, root, kvm_mmu_role_as_id(role)) {
+		if (root->role.word == role.word) {
+			private_root = root;
+			break;
+		}
+	}
+	if (!private_root)
+		return INVALID_PAGE;
+
+	/* Remove the private root from the src kvm and add it to dst kvm. */
+	list_del_rcu(&private_root->link);
+	list_add_rcu(&private_root->link, &kvm->arch.tdp_mmu_roots);
+
+	num_private_pages = atomic64_read(&src_kvm->arch.tdp_private_mmu_pages);
+	old = atomic64_cmpxchg(&kvm->arch.tdp_private_mmu_pages, 0,
+			       num_private_pages);
+	/* The destination VM should have no private pages at this point. */
+	WARN_ON(old);
+	atomic64_set(&src_kvm->arch.tdp_private_mmu_pages, 0);
+
+	return __pa(private_root->spt);
+}
+
+hpa_t kvm_tdp_mmu_get_vcpu_root_hpa_no_alloc(struct kvm_vcpu *vcpu, bool private)
+{
+	struct kvm_mmu_page *root;
+	union kvm_mmu_page_role role = vcpu->arch.mmu->root_role;
+
+	if (private)
+		kvm_mmu_page_role_set_private(&role);
+	root = kvm_tdp_mmu_get_vcpu_root_no_alloc(vcpu, role);
+	if (!root)
+		return INVALID_PAGE;
+
+	return __pa(root->spt);
+}
+
 hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu, bool private)
 {
 	return __pa(kvm_tdp_mmu_get_vcpu_root(vcpu, private)->spt);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 3ae3c3b8642ac..0e9d38432673d 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -11,6 +11,9 @@ int kvm_mmu_init_tdp_mmu(struct kvm *kvm);
 void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm);
 
 hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu, bool private);
+hpa_t kvm_tdp_mmu_get_vcpu_root_hpa_no_alloc(struct kvm_vcpu *vcpu, bool private);
+hpa_t kvm_tdp_mmu_move_private_pages_from(struct kvm_vcpu *vcpu,
+					  struct kvm_vcpu *src_vcpu);
 
 __must_check static inline bool kvm_tdp_mmu_get_root(struct kvm_mmu_page *root)
 {
-- 
2.40.0.348.gf938b09366-goog

