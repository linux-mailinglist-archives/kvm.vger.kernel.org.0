Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1B33732BC3
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 11:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343683AbjFPJbM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 05:31:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344767AbjFPJaO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 05:30:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B9D53AAB
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 02:28:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686907640;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=odcrL41tL0J76rDneIgWHoMsdg/15Ub++D/5ea+DdKw=;
        b=QXk2FBI7CQZ/pX3DpiUfYdU0ZiS5m/Pv1484YjLTv3TNyKPlhXMpDbEyswq+LtJ/YECEk7
        uxkn0c5+eeXg8IXOonp1DJs1ConJSPRWMGtuZkYAP5em2cZH744uB6/LULsn/Us07f3CLy
        yKzjflir+X1ua/fopVc9ravyovExSyY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-418--8SSEMSJPJicBGTms1NJEw-1; Fri, 16 Jun 2023 05:27:15 -0400
X-MC-Unique: -8SSEMSJPJicBGTms1NJEw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 524D885A58A;
        Fri, 16 Jun 2023 09:27:15 +0000 (UTC)
Received: from t480s.fritz.box (unknown [10.39.194.44])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 983681121314;
        Fri, 16 Jun 2023 09:27:12 +0000 (UTC)
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
        kvm@vger.kernel.org
Subject: [PATCH v1 02/15] kvm: Add stub for kvm_get_max_memslots()
Date:   Fri, 16 Jun 2023 11:26:41 +0200
Message-Id: <20230616092654.175518-3-david@redhat.com>
In-Reply-To: <20230616092654.175518-1-david@redhat.com>
References: <20230616092654.175518-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
index 7679f397ae..94d672010e 100644
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
index 5d2dd8f351..506bc8c9e4 100644
--- a/accel/stubs/kvm-stub.c
+++ b/accel/stubs/kvm-stub.c
@@ -108,6 +108,11 @@ int kvm_irqchip_remove_irqfd_notifier_gsi(KVMState *s, EventNotifier *n,
     return -ENOSYS;
 }
 
+unsigned int kvm_get_max_memslots(void)
+{
+    return UINT_MAX;
+}
+
 bool kvm_has_free_slot(MachineState *ms)
 {
     return false;
diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index 88f5ccfbce..7a999eff52 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -213,6 +213,7 @@ typedef struct KVMRouteChange {
 
 /* external API */
 
+unsigned int kvm_get_max_memslots(void);
 bool kvm_has_free_slot(MachineState *ms);
 bool kvm_has_sync_mmu(void);
 int kvm_has_vcpu_events(void);
@@ -559,7 +560,6 @@ int kvm_set_one_reg(CPUState *cs, uint64_t id, void *source);
  */
 int kvm_get_one_reg(CPUState *cs, uint64_t id, void *target);
 struct ppc_radix_page_info *kvm_get_radix_page_info(void);
-int kvm_get_max_memslots(void);
 
 /* Notify resamplefd for EOI of specific interrupts. */
 void kvm_resample_fd_notify(int gsi);
-- 
2.40.1

