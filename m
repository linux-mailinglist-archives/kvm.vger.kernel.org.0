Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4A73691498
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 00:36:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbjBIXgQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 18:36:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231222AbjBIXfu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 18:35:50 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0EEF6E9A4
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 15:34:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675985679;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fijRSvjFkArAa0ryGscnf/miuX0tMpTEdiQbyj+yK9k=;
        b=eYYxo15/ZI4eib7y5zD4fgocFif4pSaJ+owKTYJfhDCgKzXAJDbEY+ZrJu1wB3NjQrOqDW
        UOxs5IBK9nQsh8nLG+ELZkjDHV28ltC1E9IqwHOyLrjAKspY/ZIwsOLTzHzxBMIqZXLaHv
        l0D3FGEy9oKKYMUtC7DbsEaTT0fupPc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-507-ByzmAmSfMpiH7YTJqk-JtQ-1; Thu, 09 Feb 2023 18:34:36 -0500
X-MC-Unique: ByzmAmSfMpiH7YTJqk-JtQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4033729A9D35;
        Thu,  9 Feb 2023 23:34:36 +0000 (UTC)
Received: from secure.mitica (unknown [10.39.192.29])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4EEC7175AD;
        Thu,  9 Feb 2023 23:34:34 +0000 (UTC)
From:   Juan Quintela <quintela@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Juan Quintela <quintela@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        Li Zhang <lizhang@suse.de>
Subject: [PULL 03/17] multifd: Remove some redundant code
Date:   Fri, 10 Feb 2023 00:34:12 +0100
Message-Id: <20230209233426.37811-4-quintela@redhat.com>
In-Reply-To: <20230209233426.37811-1-quintela@redhat.com>
References: <20230209233426.37811-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Li Zhang <lizhang@suse.de>

Clean up some unnecessary code

Signed-off-by: Li Zhang <lizhang@suse.de>
Signed-off-by: Juan Quintela <quintela@redhat.com>
---
 migration/multifd.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/migration/multifd.c b/migration/multifd.c
index c8132ab7e8..7aa030fb19 100644
--- a/migration/multifd.c
+++ b/migration/multifd.c
@@ -892,19 +892,15 @@ static void multifd_new_send_channel_async(QIOTask *task, gpointer opaque)
     Error *local_err = NULL;
 
     trace_multifd_new_send_channel_async(p->id);
-    if (qio_task_propagate_error(task, &local_err)) {
-        goto cleanup;
-    } else {
+    if (!qio_task_propagate_error(task, &local_err)) {
         p->c = QIO_CHANNEL(sioc);
         qio_channel_set_delay(p->c, false);
         p->running = true;
-        if (!multifd_channel_connect(p, sioc, local_err)) {
-            goto cleanup;
+        if (multifd_channel_connect(p, sioc, local_err)) {
+            return;
         }
-        return;
     }
 
-cleanup:
     multifd_new_send_channel_cleanup(p, sioc, local_err);
 }
 
@@ -1115,10 +1111,7 @@ static void *multifd_recv_thread(void *opaque)
 
         ret = qio_channel_read_all_eof(p->c, (void *)p->packet,
                                        p->packet_len, &local_err);
-        if (ret == 0) {   /* EOF */
-            break;
-        }
-        if (ret == -1) {   /* Error */
+        if (ret == 0 || ret == -1) {   /* 0: EOF  -1: Error */
             break;
         }
 
-- 
2.39.1

