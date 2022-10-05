Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8265F5480
	for <lists+kvm@lfdr.de>; Wed,  5 Oct 2022 14:31:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbiJEMbt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 08:31:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229828AbiJEMbp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 08:31:45 -0400
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [IPv6:2a0c:5a00:149::26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 621B9360A4
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 05:31:44 -0700 (PDT)
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
        by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1og3Ys-00Gedf-Mb; Wed, 05 Oct 2022 14:31:42 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector2; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From;
        bh=0sI0Du0iuAjvbQy6NgS3kmyNTVwKNPO017/LNGxPHz4=; b=quRKVZSGRypwl/cBNsypsNqTcA
        MFpHWTyk3lNvnbVUL4kPDMElbGhSFQHG+3P1Udzcwjp8bBSdwb6adNcXgU2oUdh0bsny1gpGvfiCE
        vTobu4kapAruaFp47KKtyW5BlbVWML5AuEJQaBNx/CEyt3hmFpX08PaqzsG9fll0Wgp+qBOHfVSh6
        PJPF6Npj5queIqCKr/U6CUKwoJeiozCIse+SppH9sjlJqMLL7zjjsRlM1LT2QP/BK5w4QSEvR4mJl
        JQIZOTc0oCCWiX6Ph0CrlenC3F9tGIE1HhmIZz+hHqy85mhD39EeRB6NAg/4j8oKhxXqb0l/oC2Hv
        8D07Fm8Q==;
Received: from [10.9.9.73] (helo=submission02.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1og3Ys-00060z-E0; Wed, 05 Oct 2022 14:31:42 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1og3YQ-0007vp-Ca; Wed, 05 Oct 2022 14:31:14 +0200
From:   Michal Luczaj <mhal@rbox.co>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com,
        Michal Luczaj <mhal@rbox.co>
Subject: [PATCH v2 3/8] KVM: x86: Remove unused argument in gpc_unmap_khva()
Date:   Wed,  5 Oct 2022 14:30:46 +0200
Message-Id: <20221005123051.895056-4-mhal@rbox.co>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221005123051.895056-1-mhal@rbox.co>
References: <YySujDJN2Wm3ivi/@google.com>
 <20221005123051.895056-1-mhal@rbox.co>
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

