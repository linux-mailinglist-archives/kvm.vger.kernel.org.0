Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3151A79888F
	for <lists+kvm@lfdr.de>; Fri,  8 Sep 2023 16:22:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243838AbjIHOXB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Sep 2023 10:23:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243813AbjIHOW7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Sep 2023 10:22:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16F501FC1
        for <kvm@vger.kernel.org>; Fri,  8 Sep 2023 07:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694182934;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=76sLIvIi1LRlkl4IyII47l3BU7MLPwQ+dI9Px2upkuc=;
        b=P1a9kxpMvn6nZywizl7oEwyxGwyRwNQB5QyWOrt/LJeo36a3CREnoRxN/ox9dn5u17Vzk8
        LmKyW8Bh2pEoldAg/5eM/NTLOTvnoKeMYRs1YzPY8nkPE7ZZmE7GQgAptxCCOGqKkE6//2
        z0hIA3KikAa/m5DIkp4AhR3+1+BkG9I=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-385-yM6MKPrHNgmVi4RSUOESow-1; Fri, 08 Sep 2023 10:22:10 -0400
X-MC-Unique: yM6MKPrHNgmVi4RSUOESow-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 98E02181C280;
        Fri,  8 Sep 2023 14:22:09 +0000 (UTC)
Received: from t14s.redhat.com (unknown [10.39.194.76])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B5BADC4F860;
        Fri,  8 Sep 2023 14:22:06 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     David Hildenbrand <david@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Michal Privoznik <mprivozn@redhat.com>,
        =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        kvm@vger.kernel.org
Subject: [PATCH v3 10/16] kvm: Add stub for kvm_get_max_memslots()
Date:   Fri,  8 Sep 2023 16:21:30 +0200
Message-ID: <20230908142136.403541-11-david@redhat.com>
In-Reply-To: <20230908142136.403541-1-david@redhat.com>
References: <20230908142136.403541-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We'll need the stub soon from memory device context.

While at it, use "unsigned int" as return value and place the
declaration next to kvm_get_free_memslots().

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 accel/kvm/kvm-all.c    | 2 +-
 accel/stubs/kvm-stub.c | 5 +++++
 include/sysemu/kvm.h   | 2 +-
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index a29906d441..5383bfddc3 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -174,7 +174,7 @@ void kvm_resample_fd_notify(int gsi)
     }
 }
 
-int kvm_get_max_memslots(void)
+unsigned int kvm_get_max_memslots(void)
 {
     KVMState *s = KVM_STATE(current_accel());
 
diff --git a/accel/stubs/kvm-stub.c b/accel/stubs/kvm-stub.c
index a5d4442d8f..51f522e52e 100644
--- a/accel/stubs/kvm-stub.c
+++ b/accel/stubs/kvm-stub.c
@@ -109,6 +109,11 @@ int kvm_irqchip_remove_irqfd_notifier_gsi(KVMState *s, EventNotifier *n,
     return -ENOSYS;
 }
 
+unsigned int kvm_get_max_memslots(void)
+{
+    return 0;
+}
+
 unsigned int kvm_get_free_memslots(void)
 {
     return 0;
diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index c3d831baef..97a8a4f201 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -215,6 +215,7 @@ typedef struct KVMRouteChange {
 
 /* external API */
 
+unsigned int kvm_get_max_memslots(void);
 unsigned int kvm_get_free_memslots(void);
 bool kvm_has_sync_mmu(void);
 int kvm_has_vcpu_events(void);
@@ -552,7 +553,6 @@ int kvm_set_one_reg(CPUState *cs, uint64_t id, void *source);
  */
 int kvm_get_one_reg(CPUState *cs, uint64_t id, void *target);
 struct ppc_radix_page_info *kvm_get_radix_page_info(void);
-int kvm_get_max_memslots(void);
 
 /* Notify resamplefd for EOI of specific interrupts. */
 void kvm_resample_fd_notify(int gsi);
-- 
2.41.0

