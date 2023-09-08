Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E79A79888C
	for <lists+kvm@lfdr.de>; Fri,  8 Sep 2023 16:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243822AbjIHOW6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Sep 2023 10:22:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243789AbjIHOW5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Sep 2023 10:22:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 457F31BFC
        for <kvm@vger.kernel.org>; Fri,  8 Sep 2023 07:22:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694182925;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q8s7qWm1hXNJSjwsdxL6SMu6onsy76kevioaNWWVl20=;
        b=XjZfm0yS5EDMoImGYbL4KTTBJbgLUDh4v0p6p0O9lFIXECHAcs5YBOGusJyJ+3mmrsjg4Q
        wSqkcq1Q7+Sb0CwBk7wmdu4cJav1JX5kDOpC4cfzNL8diiPVlaXPKoDuijXART8YXx+uUV
        i88puc54hHw+L/9i0pm2QYyIWPNfsJM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-17-9rJQ9ttnMyCEKHvWFGitTA-1; Fri, 08 Sep 2023 10:22:01 -0400
X-MC-Unique: 9rJQ9ttnMyCEKHvWFGitTA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C6293800C78;
        Fri,  8 Sep 2023 14:22:00 +0000 (UTC)
Received: from t14s.redhat.com (unknown [10.39.194.76])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 25895C03295;
        Fri,  8 Sep 2023 14:21:58 +0000 (UTC)
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
Subject: [PATCH v3 07/16] stubs: Rename qmp_memory_device.c to memory_device.c
Date:   Fri,  8 Sep 2023 16:21:27 +0200
Message-ID: <20230908142136.403541-8-david@redhat.com>
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

We want to place non-qmp stubs in there, so let's rename it. While at
it, put it into the MAINTAINERS file under "Memory devices".

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 MAINTAINERS                                    | 1 +
 stubs/{qmp_memory_device.c => memory_device.c} | 0
 stubs/meson.build                              | 2 +-
 3 files changed, 2 insertions(+), 1 deletion(-)
 rename stubs/{qmp_memory_device.c => memory_device.c} (100%)

diff --git a/MAINTAINERS b/MAINTAINERS
index b471973e1e..89b0093e81 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2852,6 +2852,7 @@ F: hw/mem/pc-dimm.c
 F: include/hw/mem/memory-device.h
 F: include/hw/mem/nvdimm.h
 F: include/hw/mem/pc-dimm.h
+F: stubs/memory_device.c
 F: docs/nvdimm.txt
 
 SPICE
diff --git a/stubs/qmp_memory_device.c b/stubs/memory_device.c
similarity index 100%
rename from stubs/qmp_memory_device.c
rename to stubs/memory_device.c
diff --git a/stubs/meson.build b/stubs/meson.build
index ef6e39a64d..cde44972bf 100644
--- a/stubs/meson.build
+++ b/stubs/meson.build
@@ -32,7 +32,7 @@ stub_ss.add(files('monitor.c'))
 stub_ss.add(files('monitor-core.c'))
 stub_ss.add(files('physmem.c'))
 stub_ss.add(files('qemu-timer-notify-cb.c'))
-stub_ss.add(files('qmp_memory_device.c'))
+stub_ss.add(files('memory_device.c'))
 stub_ss.add(files('qmp-command-available.c'))
 stub_ss.add(files('qmp-quit.c'))
 stub_ss.add(files('qtest.c'))
-- 
2.41.0

