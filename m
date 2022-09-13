Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42C8E5B6A83
	for <lists+kvm@lfdr.de>; Tue, 13 Sep 2022 11:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231600AbiIMJSF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Sep 2022 05:18:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231179AbiIMJSE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Sep 2022 05:18:04 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33DA8B6A;
        Tue, 13 Sep 2022 02:18:03 -0700 (PDT)
Received: from canpemm500002.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MRd9521tmznV1W;
        Tue, 13 Sep 2022 17:15:21 +0800 (CST)
Received: from huawei.com (10.175.124.27) by canpemm500002.china.huawei.com
 (7.192.104.244) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 13 Sep
 2022 17:18:01 +0800
From:   Miaohe Lin <linmiaohe@huawei.com>
To:     <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>
CC:     <x86@kernel.org>, <hpa@zytor.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linmiaohe@huawei.com>
Subject: [PATCH] KVM: x86/mmu: fix some comment typos
Date:   Tue, 13 Sep 2022 17:17:25 +0800
Message-ID: <20220913091725.35953-1-linmiaohe@huawei.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 canpemm500002.china.huawei.com (7.192.104.244)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix some typos in comments.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 arch/x86/kvm/mmu/mmu.c  | 2 +-
 arch/x86/kvm/mmu/spte.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 45c532d00f78..3a08209725aa 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1882,7 +1882,7 @@ static bool is_obsolete_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 	if (sp->role.invalid)
 		return true;
 
-	/* TDP MMU pages due not use the MMU generation. */
+	/* TDP MMU pages do not use the MMU generation. */
 	return !sp->tdp_mmu_page &&
 	       unlikely(sp->mmu_valid_gen != kvm->arch.mmu_valid_gen);
 }
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 7670c13ce251..79560d77aa4c 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -188,7 +188,7 @@ extern u64 __read_mostly shadow_nonpresent_or_rsvd_mask;
  * should not modify the SPTE.
  *
  * Use a semi-arbitrary value that doesn't set RWX bits, i.e. is not-present on
- * bot AMD and Intel CPUs, and doesn't set PFN bits, i.e. doesn't create a L1TF
+ * both AMD and Intel CPUs, and doesn't set PFN bits, i.e. doesn't create a L1TF
  * vulnerability.  Use only low bits to avoid 64-bit immediates.
  *
  * Only used by the TDP MMU.
-- 
2.23.0

