Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE7D60FCDE
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 18:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236609AbiJ0QT3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 12:19:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236499AbiJ0QSz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 12:18:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4586F18E2AC
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 09:18:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666887533;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sdeKLDOmzDc50wX69zF5oFbNHmj+GE1oHwYqIBezFig=;
        b=OfzzWNAUAkhVwBQQzQQrpeP7J/jHS+M2s9KkF0Bg+0/vN++D2o+c1hZBzVGs4utA3xfwHu
        7K7LntDJP39DRE3YAs5449ZyM/g6OYwkw93BeCxbJ9+BrpjpZXu3LJF9Bv2P/lHNXB9GnU
        AJpbw7QeKqzDg4iadGighstIdC4qnAU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-164-jk2I3IdsMVml6cTGwIp4ag-1; Thu, 27 Oct 2022 12:18:51 -0400
X-MC-Unique: jk2I3IdsMVml6cTGwIp4ag-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 36A8A185A7A3;
        Thu, 27 Oct 2022 16:18:51 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 14F131400B19;
        Thu, 27 Oct 2022 16:18:51 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     mhal@rbox.co, seanjc@google.com
Subject: [PATCH 05/16] KVM: x86: Remove unused argument in gpc_unmap_khva()
Date:   Thu, 27 Oct 2022 12:18:38 -0400
Message-Id: <20221027161849.2989332-6-pbonzini@redhat.com>
In-Reply-To: <20221027161849.2989332-1-pbonzini@redhat.com>
References: <20221027161849.2989332-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Michal Luczaj <mhal@rbox.co>

Remove the unused @kvm argument from gpc_unmap_khva().

Signed-off-by: Michal Luczaj <mhal@rbox.co>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20221013211234.1318131-6-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 virt/kvm/pfncache.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 23180f1d9c1c..32ccf168361b 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -98,7 +98,7 @@ bool kvm_gpc_check(struct kvm *kvm, struct gfn_to_pfn_cache *gpc, gpa_t gpa,
 }
 EXPORT_SYMBOL_GPL(kvm_gpc_check);
 
-static void gpc_unmap_khva(struct kvm *kvm, kvm_pfn_t pfn, void *khva)
+static void gpc_unmap_khva(kvm_pfn_t pfn, void *khva)
 {
 	/* Unmap the old pfn/page if it was mapped before. */
 	if (!is_error_noslot_pfn(pfn) && khva) {
@@ -177,7 +177,7 @@ static kvm_pfn_t hva_to_pfn_retry(struct kvm *kvm, struct gfn_to_pfn_cache *gpc)
 			 * the existing mapping and didn't create a new one.
 			 */
 			if (new_khva != old_khva)
-				gpc_unmap_khva(kvm, new_pfn, new_khva);
+				gpc_unmap_khva(new_pfn, new_khva);
 
 			kvm_release_pfn_clean(new_pfn);
 
@@ -324,7 +324,7 @@ int kvm_gpc_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc, gpa_t gpa,
 	mutex_unlock(&gpc->refresh_lock);
 
 	if (unmap_old)
-		gpc_unmap_khva(kvm, old_pfn, old_khva);
+		gpc_unmap_khva(old_pfn, old_khva);
 
 	return ret;
 }
@@ -353,7 +353,7 @@ void kvm_gpc_unmap(struct kvm *kvm, struct gfn_to_pfn_cache *gpc)
 	write_unlock_irq(&gpc->lock);
 	mutex_unlock(&gpc->refresh_lock);
 
-	gpc_unmap_khva(kvm, old_pfn, old_khva);
+	gpc_unmap_khva(old_pfn, old_khva);
 }
 EXPORT_SYMBOL_GPL(kvm_gpc_unmap);
 
-- 
2.31.1


