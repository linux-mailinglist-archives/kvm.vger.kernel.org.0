Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8676DB51D
	for <lists+kvm@lfdr.de>; Fri,  7 Apr 2023 22:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbjDGUT7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 16:19:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbjDGUT4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 16:19:56 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5DB2C660
        for <kvm@vger.kernel.org>; Fri,  7 Apr 2023 13:19:55 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d2-20020a170902cec200b001a1e8390831so24469870plg.5
        for <kvm@vger.kernel.org>; Fri, 07 Apr 2023 13:19:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680898795; x=1683490795;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8b0y9dzGATppcj8q9R3EYlNwH8XwDGz6PntC1PTa0lM=;
        b=kVkihDPr/2wcKyOVlHQk1B6rs/tWhOM8mww1inoytYh7iKm5x67D2NyRve2+XK9jnl
         y50/l1iKtKC5LzduH0aqkWUFALmZcItOqyfohGKWVmSf9aMu6zllI5ks8kPNysQtvZHS
         wJ1FosoGrMpU/qJwrubMmQRiXytK2DXFJhIQtsc39RDr1ACjSnKLorktmolfRB+5lluB
         LVCdw30oylwxXqslJbJDvRraCncjkV3Fsst1lK+eX2DoL1MnMtmILAZ5KLba1pQ499Sw
         sOBOa6f9Jeg5PHSFk5QBFh0xhUP4qdblmkBOiJFfqYNqeiJtU6Xopnp4rxVwAg21QdRI
         ebkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680898795; x=1683490795;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8b0y9dzGATppcj8q9R3EYlNwH8XwDGz6PntC1PTa0lM=;
        b=K9oLAZtlBcUTU/aQRxbkrovy6jH1DwfZaJiJNR++kUnOAcCO00+wVBT88voky1LVx8
         k9sbhSyi2XmlODTaiCqtp5DlU/VD5OQzSMzNocqm3LT3TZArVbPt5+gQvRbLc0FKpeZ9
         rL9Bl+469p6NBmhHjAxuREHje9B5HC88Yugqjo0g79nhIBof/uFRO4ksSpyyPP2qmdpY
         oySY3fUr8FRe/yUI1J9ILsNIroOX7YK9tPVZldr+NLcVlyVvhtf24Wo3viOr7n366m3O
         8dnx8+xeFs8sbiGvpDJKQhtF7iYiIAVLv+Ju0eI92sER06HiwPkB+zcUlD7bE6gzherN
         klUw==
X-Gm-Message-State: AAQBX9fOrQRIjmdlFdvUkLyYFmSiTgumEL9qZ5cFU1Xty53RPNDuiItz
        UWWguV/PD34NfhxsmvsNJSGMYk2roNMvBT23wA848M7jZH1q871W4BgU5skDruqClpXtFRNhJE0
        BZHISf1fHInM6rn8xT4i2b1vkmok+yQwWL0/BYAsW9x44/UHPV9Nsxh0=
X-Google-Smtp-Source: AKy350Yu52fhDPmtG31yJRW3kZkCKp3NE4S4e24lBBsLq7eYvF3p6JmBw3w8hLndanVHtKew+WdWfgWzyg==
X-Received: from sagi.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:241b])
 (user=sagis job=sendgmr) by 2002:a63:24c3:0:b0:513:2523:1b5f with SMTP id
 k186-20020a6324c3000000b0051325231b5fmr725494pgk.3.1680898795205; Fri, 07 Apr
 2023 13:19:55 -0700 (PDT)
Date:   Fri,  7 Apr 2023 20:19:17 +0000
In-Reply-To: <20230407201921.2703758-1-sagis@google.com>
Mime-Version: 1.0
References: <20230407201921.2703758-1-sagis@google.com>
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <20230407201921.2703758-2-sagis@google.com>
Subject: [RFC PATCH 1/5] KVM: Split tdp_mmu_pages to private and shared lists
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

tdp_mmu_pages holds all the active pages used by the mmu. When we
transfer the state during intra-host migration we need to transfer the
private pages but not the shared ones.

Keeping them in separate counters makes this transfer more efficient.

Signed-off-by: Sagi Shahar <sagis@google.com>
---
 arch/x86/include/asm/kvm_host.h |  5 ++++-
 arch/x86/kvm/mmu/tdp_mmu.c      | 11 +++++++++--
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ae377eec81987..5ed70cd9d74bf 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1426,9 +1426,12 @@ struct kvm_arch {
 	struct task_struct *nx_huge_page_recovery_thread;
 
 #ifdef CONFIG_X86_64
-	/* The number of TDP MMU pages across all roots. */
+	/* The number of non-private TDP MMU pages across all roots. */
 	atomic64_t tdp_mmu_pages;
 
+	/* Same as tdp_mmu_pages but only for private pages. */
+	atomic64_t tdp_private_mmu_pages;
+
 	/*
 	 * List of struct kvm_mmu_pages being used as roots.
 	 * All struct kvm_mmu_pages in the list should have
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 58a236a69ec72..327dee4f6170e 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -44,6 +44,7 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
 	destroy_workqueue(kvm->arch.tdp_mmu_zap_wq);
 
 	WARN_ON(atomic64_read(&kvm->arch.tdp_mmu_pages));
+	WARN_ON(atomic64_read(&kvm->arch.tdp_private_mmu_pages));
 	WARN_ON(!list_empty(&kvm->arch.tdp_mmu_roots));
 
 	/*
@@ -373,13 +374,19 @@ static void handle_changed_spte_dirty_log(struct kvm *kvm, int as_id, gfn_t gfn,
 static void tdp_account_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	kvm_account_pgtable_pages((void *)sp->spt, +1);
-	atomic64_inc(&kvm->arch.tdp_mmu_pages);
+	if (is_private_sp(sp))
+		atomic64_inc(&kvm->arch.tdp_private_mmu_pages);
+	else
+		atomic64_inc(&kvm->arch.tdp_mmu_pages);
 }
 
 static void tdp_unaccount_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	kvm_account_pgtable_pages((void *)sp->spt, -1);
-	atomic64_dec(&kvm->arch.tdp_mmu_pages);
+	if (is_private_sp(sp))
+		atomic64_dec(&kvm->arch.tdp_private_mmu_pages);
+	else
+		atomic64_dec(&kvm->arch.tdp_mmu_pages);
 }
 
 /**
-- 
2.40.0.348.gf938b09366-goog

