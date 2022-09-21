Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E96C5BF33A
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 04:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231597AbiIUCCv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 22:02:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231343AbiIUCCp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 22:02:45 -0400
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [IPv6:2a0c:5a00:149::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C09F079680
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 19:02:42 -0700 (PDT)
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
        by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1oap4S-00Eb3A-PP
        for kvm@vger.kernel.org; Wed, 21 Sep 2022 04:02:40 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector2; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From;
        bh=0sI0Du0iuAjvbQy6NgS3kmyNTVwKNPO017/LNGxPHz4=; b=aicXtrxrK3fuVB39OHfVLdakN+
        nT+8sMLvvWgS56IUIFFTomIq/fRu7EUMsuE1S8zXmyvGIm5av2JNXVX0LKD2/jkIZud3AAOcja4AI
        uqSrST0wbJ6/QQeDtbKEfSleHKNdRLL7Ge0a6l/UZ/jm4U5+d1QPOAKrY/7bs6QyZdUtG0Ef7kHiO
        llo6ZcTv98Y4Anp182+28qhZBs4xiEDsDvtALK2xkuKWTmAWXEewgVWbcMiueR0uqcMFBjeTGAb2i
        KIb7mfsUwxit+I+E3tkIUg4jz3J160gxWlCVIGWNeZJuwLZEs6tEPLDc2qeiTaE/nXZzID0hSw3sf
        6cr2oXIA==;
Received: from [10.9.9.73] (helo=submission02.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1oap4S-0002To-GE; Wed, 21 Sep 2022 04:02:40 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1oap3x-0006er-2v; Wed, 21 Sep 2022 04:02:09 +0200
From:   Michal Luczaj <mhal@rbox.co>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com,
        Michal Luczaj <mhal@rbox.co>
Subject: [PATCH 3/8] KVM: x86: Remove unused argument in gpc_unmap_khva()
Date:   Wed, 21 Sep 2022 04:01:35 +0200
Message-Id: <20220921020140.3240092-4-mhal@rbox.co>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220921020140.3240092-1-mhal@rbox.co>
References: <YySujDJN2Wm3ivi/@google.com>
 <20220921020140.3240092-1-mhal@rbox.co>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

First argument is never used, remove it.

Signed-off-by: Michal Luczaj <mhal@rbox.co>
---
 virt/kvm/pfncache.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index cc65fab0dbef..76f1b669cf28 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -95,7 +95,7 @@ bool kvm_gpc_check(struct kvm *kvm, struct gfn_to_pfn_cache *gpc, gpa_t gpa,
 }
 EXPORT_SYMBOL_GPL(kvm_gpc_check);
 
-static void gpc_unmap_khva(struct kvm *kvm, kvm_pfn_t pfn, void *khva)
+static void gpc_unmap_khva(kvm_pfn_t pfn, void *khva)
 {
 	/* Unmap the old pfn/page if it was mapped before. */
 	if (!is_error_noslot_pfn(pfn) && khva) {
@@ -174,7 +174,7 @@ static kvm_pfn_t hva_to_pfn_retry(struct kvm *kvm, struct gfn_to_pfn_cache *gpc)
 			 * the existing mapping and didn't create a new one.
 			 */
 			if (new_khva != old_khva)
-				gpc_unmap_khva(kvm, new_pfn, new_khva);
+				gpc_unmap_khva(new_pfn, new_khva);
 
 			kvm_release_pfn_clean(new_pfn);
 
@@ -313,7 +313,7 @@ int kvm_gpc_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc, gpa_t gpa,
 	mutex_unlock(&gpc->refresh_lock);
 
 	if (old_pfn != new_pfn)
-		gpc_unmap_khva(kvm, old_pfn, old_khva);
+		gpc_unmap_khva(old_pfn, old_khva);
 
 	return ret;
 }
@@ -342,7 +342,7 @@ void kvm_gpc_unmap(struct kvm *kvm, struct gfn_to_pfn_cache *gpc)
 	write_unlock_irq(&gpc->lock);
 	mutex_unlock(&gpc->refresh_lock);
 
-	gpc_unmap_khva(kvm, old_pfn, old_khva);
+	gpc_unmap_khva(old_pfn, old_khva);
 }
 EXPORT_SYMBOL_GPL(kvm_gpc_unmap);
 
-- 
2.37.3

