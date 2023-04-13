Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3FC6E1497
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 20:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230397AbjDMSuH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Apr 2023 14:50:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230359AbjDMSt7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Apr 2023 14:49:59 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B97481BE6
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 11:49:57 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-54fde069e4aso10607547b3.3
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 11:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681411797; x=1684003797;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=V7eNnfqvdgMeRty47sKZ5bDGUPYodxrLNUCKpwstgjo=;
        b=CTbsWQK70jTAAZEZw5xTf0JraamlWh/P6VoLkUMzM6+xZraQCKaDXgSwtGP23CpKQ4
         28+7tW/GJiOQDZI/LvfjicMX5g/KPsOCFHAK21OdmVj69oNg2JqBhF4GfkfAJMLLZ32I
         AiPL7l6MfHB6WWt99DxqbCT6Q1i3uXbF+AfYMMJsOsh/sYkq5RuTbM3p5t8TNHX4xNob
         IAeogAbsGFMZu9ulTw+CTccj7fDpoXe4NQBCdEAs4ce+d4fjVox7ClAxSCBJv2r1WXGv
         RmoEozErTmfr+zRAXV0t//Ta5K3MXQfRzx0PkXDmXFQWcsMqdpT13QdodE48JuXXygG9
         RQ8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681411797; x=1684003797;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V7eNnfqvdgMeRty47sKZ5bDGUPYodxrLNUCKpwstgjo=;
        b=M34msxBfLMtCwYuBq8K4Jzm8n3PN5BKgKLkOts4KKVwwoQ3/zYWHmQPacLnModgkeP
         N3qvwjbq92fUQu5xlGdC5iJesVz05LEYiRBbBWhxVx2boy5ZQ/qQ6cAd24SAfgqKnQwO
         wz4EiwKD0U/K8oypoe6QeagbgJz3H3SIQQnEhplVhx9QArqwwG5LAyXJWoWB7zLlmYnt
         UgxWctpNFogJUbXhgFG9+6bN1O4EIB478ryzdVwt5pwNDnXT9eYFlAG7+MVpt7t8+IRu
         6y+BEP7ouK8jOfedhplAUQcKhoPk7ji25NQUSU5QaWNv4mpU4EO7G1j4nypThKl6COqD
         u5jw==
X-Gm-Message-State: AAQBX9emLi9YuHBTszpL4FfNVOQjZJy6Ho4lrY+L4/jSC2rMpk+bS9Xo
        HjwigxKncFQ/n8mQwKXZAhJjYHn5np8=
X-Google-Smtp-Source: AKy350Ypu1HlHhhKWX1xKy7iIKom4hmmKKxP/dyDK+eGTwrVEtPdv2zCGwTvbnGZ5xRECkrQ0HbkQ/uu/to=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:40f:0:b0:b26:884:c35e with SMTP id
 15-20020a25040f000000b00b260884c35emr5108853ybe.4.1681411797065; Thu, 13 Apr
 2023 11:49:57 -0700 (PDT)
Date:   Thu, 13 Apr 2023 11:49:55 -0700
In-Reply-To: <ZDg6w+1v4e/uRDfF@google.com>
Mime-Version: 1.0
References: <20230227171751.1211786-1-jpiotrowski@linux.microsoft.com>
 <ZAd2MRNLw1JAXmOf@google.com> <959c5bce-beb5-b463-7158-33fc4a4f910c@linux.microsoft.com>
 <ZDSa9Bbqvh0btgQo@google.com> <ecd3d8de-859b-e5dd-c3bf-ea9c3c0aac60@linux.microsoft.com>
 <ZDWEgXM/UILjPGiG@google.com> <61d131da-7239-6aae-753f-2eb4f1b84c24@linux.microsoft.com>
 <ZDg6w+1v4e/uRDfF@google.com>
Message-ID: <ZDhO02VeRcOMTQz0@google.com>
Subject: Re: [PATCH] KVM: SVM: Disable TDP MMU when running on Hyper-V
From:   Sean Christopherson <seanjc@google.com>
To:     Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tianyu Lan <ltykernel@gmail.com>,
        Michael Kelley <mikelley@microsoft.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 13, 2023, Sean Christopherson wrote:
> Aha!  Idea.  There are _at most_ 4 possible roots the TDP MMU can encounter.
> 4-level non-SMM, 4-level SMM, 5-level non-SMM, and 5-level SMM.  I.e. not keeping
> inactive roots on a per-VM basis is just monumentally stupid.  Ugh, and that's not
> even the worst of our stupidity.  The truly awful side of all this is that we
> spent an absurd amount of time getting kvm_tdp_mmu_put_root() to play nice with
> putting the last reference to a valid root while holding mmu_lock for read.
> 
> Give me a few hours to whip together and test a patch, I think I see a way to fix
> this without a massive amount of churn, and with fairly simple rules for how things
> work.

Can you test the below patch?  I need to do more testing before posting, but it
holds up to basic testing.  With this, I can do kvm_mmu_reset_context() on every
non-fastpash VM-Exit with pretty much zero performance degradation.

Trying to do the same without this patch just hangs at the reset vector because
KVM can't make forward progress on EPT violations.  Skipping EPT violations still
hangs because of a KVM oddity/flaw where debug register exits require making
forward progress before the next VM-Exit (KVM really should emulate and skip the
first exit).  Skipping DR exits boots, but with amusing performance degration:
9s versus ~2s to get to PID 1, and 30s versus ~4s to console.

I verified forcing kvm_mmu_reset_context() does trigger a "new" root allocation,
e.g. 15 vs. 100k "allocations", so unless I guessed wrong about SMM-induced
kvm_mmu_reset_context() calls being the problem, this should do the trick.

FWIW, my best guess as to why you observe multiple minute boot times is that there
is an "asynchronous" source of SMIs, whereas my hack-a-test is largely limited to
synchronous exits.

---
 arch/x86/kvm/mmu/tdp_mmu.c | 80 +++++++++++++-------------------------
 1 file changed, 28 insertions(+), 52 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index b2fca11b91ff..343deccab511 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -40,7 +40,17 @@ static __always_inline bool kvm_lockdep_assert_mmu_lock_held(struct kvm *kvm,
 
 void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
 {
-	/* Also waits for any queued work items.  */
+	/*
+	 * Invalidate all roots, which besides the obvious, schedules all roots
+	 * for zapping and thus puts the TDP MMU's reference to each root, i.e.
+	 * ultimately frees all roots.
+	 */
+	kvm_tdp_mmu_invalidate_all_roots(kvm);
+
+	/*
+	 * Destroying a workqueue also first flushes the workqueue, i.e. no
+	 * need to invoke kvm_tdp_mmu_zap_invalidated_roots().
+	 */
 	destroy_workqueue(kvm->arch.tdp_mmu_zap_wq);
 
 	WARN_ON(atomic64_read(&kvm->arch.tdp_mmu_pages));
@@ -116,16 +126,6 @@ static void tdp_mmu_schedule_zap_root(struct kvm *kvm, struct kvm_mmu_page *root
 	queue_work(kvm->arch.tdp_mmu_zap_wq, &root->tdp_mmu_async_work);
 }
 
-static inline bool kvm_tdp_root_mark_invalid(struct kvm_mmu_page *page)
-{
-	union kvm_mmu_page_role role = page->role;
-	role.invalid = true;
-
-	/* No need to use cmpxchg, only the invalid bit can change.  */
-	role.word = xchg(&page->role.word, role.word);
-	return role.invalid;
-}
-
 void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
 			  bool shared)
 {
@@ -134,45 +134,12 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
 	if (!refcount_dec_and_test(&root->tdp_mmu_root_count))
 		return;
 
-	WARN_ON(!is_tdp_mmu_page(root));
-
 	/*
-	 * The root now has refcount=0.  It is valid, but readers already
-	 * cannot acquire a reference to it because kvm_tdp_mmu_get_root()
-	 * rejects it.  This remains true for the rest of the execution
-	 * of this function, because readers visit valid roots only
-	 * (except for tdp_mmu_zap_root_work(), which however
-	 * does not acquire any reference itself).
-	 *
-	 * Even though there are flows that need to visit all roots for
-	 * correctness, they all take mmu_lock for write, so they cannot yet
-	 * run concurrently. The same is true after kvm_tdp_root_mark_invalid,
-	 * since the root still has refcount=0.
-	 *
-	 * However, tdp_mmu_zap_root can yield, and writers do not expect to
-	 * see refcount=0 (see for example kvm_tdp_mmu_invalidate_all_roots()).
-	 * So the root temporarily gets an extra reference, going to refcount=1
-	 * while staying invalid.  Readers still cannot acquire any reference;
-	 * but writers are now allowed to run if tdp_mmu_zap_root yields and
-	 * they might take an extra reference if they themselves yield.
-	 * Therefore, when the reference is given back by the worker,
-	 * there is no guarantee that the refcount is still 1.  If not, whoever
-	 * puts the last reference will free the page, but they will not have to
-	 * zap the root because a root cannot go from invalid to valid.
+	 * The TDP MMU itself holds a reference to each root until the root is
+	 * explicitly invalidated, i.e. the final reference should be never be
+	 * put for a valid root.
 	 */
-	if (!kvm_tdp_root_mark_invalid(root)) {
-		refcount_set(&root->tdp_mmu_root_count, 1);
-
-		/*
-		 * Zapping the root in a worker is not just "nice to have";
-		 * it is required because kvm_tdp_mmu_invalidate_all_roots()
-		 * skips already-invalid roots.  If kvm_tdp_mmu_put_root() did
-		 * not add the root to the workqueue, kvm_tdp_mmu_zap_all_fast()
-		 * might return with some roots not zapped yet.
-		 */
-		tdp_mmu_schedule_zap_root(kvm, root);
-		return;
-	}
+	KVM_BUG_ON(!is_tdp_mmu_page(root) || !root->role.invalid, kvm);
 
 	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
 	list_del_rcu(&root->link);
@@ -320,7 +287,14 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
 	root = tdp_mmu_alloc_sp(vcpu);
 	tdp_mmu_init_sp(root, NULL, 0, role);
 
-	refcount_set(&root->tdp_mmu_root_count, 1);
+	/*
+	 * TDP MMU roots are kept until they are explicitly invalidated, either
+	 * by a memslot update or by the destruction of the VM.  Initialize the
+	 * refcount to two; one reference for the vCPU, and one reference for
+	 * the TDP MMU itself, which is held until the root is invalidated and
+	 * is ultimately put by tdp_mmu_zap_root_work().
+	 */
+	refcount_set(&root->tdp_mmu_root_count, 2);
 
 	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
 	list_add_rcu(&root->link, &kvm->arch.tdp_mmu_roots);
@@ -964,10 +938,12 @@ void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm)
 {
 	struct kvm_mmu_page *root;
 
-	lockdep_assert_held_write(&kvm->mmu_lock);
+	/* No need to hold mmu_lock when the VM is being destroyed. */
+	if (refcount_read(&kvm->users_count))
+		lockdep_assert_held_write(&kvm->mmu_lock);
+
 	list_for_each_entry(root, &kvm->arch.tdp_mmu_roots, link) {
-		if (!root->role.invalid &&
-		    !WARN_ON_ONCE(!kvm_tdp_mmu_get_root(root))) {
+		if (!root->role.invalid) {
 			root->role.invalid = true;
 			tdp_mmu_schedule_zap_root(kvm, root);
 		}

base-commit: 62cf1e941a1169a5e8016fd8683d4d888ab51e01
-- 

