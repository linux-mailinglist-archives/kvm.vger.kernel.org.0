Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1211165E2C
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 14:06:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728117AbgBTNGR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 08:06:17 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:52266 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728096AbgBTNGQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Feb 2020 08:06:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582203975;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HHWlfXnpQqqcljyzd6YNAX2WRGDbItCch3DvOI+vpOQ=;
        b=T+HlGPSZPZl57fRrVdfVB3niHlNbiZy9QuIRjPoU3TlnMY8hvWB/TlO7scA4tDyUI+jhSa
        RErQREcq8TUXB0aQOTcycJL6G8QuNI/1G+CcGNn5BeXvG9Yep7ajMDIjAQhX12sEiPmqoA
        lBOp5h2z9pBE36K1WjgSIBI4/kDeom4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-412-PPfB_DDEOUK88Ylcr_9pRA-1; Thu, 20 Feb 2020 08:06:13 -0500
X-MC-Unique: PPfB_DDEOUK88Ylcr_9pRA-1
Received: by mail-wm1-f72.google.com with SMTP id y7so578725wmd.4
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2020 05:06:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HHWlfXnpQqqcljyzd6YNAX2WRGDbItCch3DvOI+vpOQ=;
        b=lW0DRQObsUzXZl0BGPIN4GbWSOuPd6ZI7zMsVkB/t1PtobgfuHzrlwAZhq5zQ5LyfH
         XwbuLib+5pKpODESy7Wyml8Yrjz4PMcEAIKjA4n+RcvlJ1oaE8ptns1dGCbmMJ+doKYP
         pm6T2PPA62qAkGx2Q/861x2jmzyXZ2+O1yhFwTR8JzS2A2h8pQ02+kkd7CoMvaKHHYwB
         tePbeFy6lQkvsRTRDwgJ9udBsFpTgaZo+JPJqR6z74GRlb5VsZp+SHnK3DHNYDBhRM2y
         WJHiUZVfuVoR7toGhEjcr7FML//QlQUU51RT1ZUlJzZ6uoZD86QFDo6KiSC5PvI1l4vV
         2A3Q==
X-Gm-Message-State: APjAAAXnR8pCCHbqZlKzwtufWdZ6yZM+WGhS/ikn8OZWrr2UgSDHH4EG
        J6oK7OS/dQEbmfbkDpQ15pU7MqZwwQ2QPK1ermdFWXJ5jfZAaSnztc+enlrNvQrG4650w8FMwlc
        jowHOlQM/ZMKi
X-Received: by 2002:adf:e781:: with SMTP id n1mr45107553wrm.56.1582203972576;
        Thu, 20 Feb 2020 05:06:12 -0800 (PST)
X-Google-Smtp-Source: APXvYqxKBcX8rH6rx55ITZPEmcOIUOejSB/5dplr56Z6ALR3ecPn0w2hMCkhVWEBs3126xsvrTMCAw==
X-Received: by 2002:adf:e781:: with SMTP id n1mr45107502wrm.56.1582203972354;
        Thu, 20 Feb 2020 05:06:12 -0800 (PST)
Received: from localhost.localdomain (78.red-88-21-202.staticip.rima-tde.net. [88.21.202.78])
        by smtp.gmail.com with ESMTPSA id b67sm4594690wmc.38.2020.02.20.05.06.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2020 05:06:11 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     Peter Maydell <peter.maydell@linaro.org>, qemu-devel@nongnu.org
Cc:     "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        Fam Zheng <fam@euphon.net>,
        =?UTF-8?q?Herv=C3=A9=20Poussineau?= <hpoussin@reactos.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        kvm@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>, Stefan Weil <sw@weilnetz.de>,
        Eric Auger <eric.auger@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        qemu-s390x@nongnu.org,
        Aleksandar Rikalo <aleksandar.rikalo@rt-rk.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Michael Walle <michael@walle.cc>, qemu-ppc@nongnu.org,
        Gerd Hoffmann <kraxel@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, qemu-arm@nongnu.org,
        Alistair Francis <alistair@alistair23.me>,
        qemu-block@nongnu.org,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Jason Wang <jasowang@redhat.com>,
        xen-devel@lists.xenproject.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Dmitry Fleytman <dmitry.fleytman@gmail.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Igor Mitsyanko <i.mitsyanko@gmail.com>,
        Paul Durrant <paul@xen.org>,
        Richard Henderson <rth@twiddle.net>,
        John Snow <jsnow@redhat.com>
Subject: [PATCH v3 05/20] exec: Let flatview API take void pointer arguments
Date:   Thu, 20 Feb 2020 14:05:33 +0100
Message-Id: <20200220130548.29974-6-philmd@redhat.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200220130548.29974-1-philmd@redhat.com>
References: <20200220130548.29974-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Only flatview_[read/write]_continue use a byte pointer to increment
an offset. For the users, we are only dealing with a blob buffer.
Use a void pointer argument. This will let us simplify the
address_space API in the next commit.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 include/exec/memory.h |  2 +-
 exec.c                | 14 ++++++++------
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/include/exec/memory.h b/include/exec/memory.h
index e85b7de99a..6f8084f45e 100644
--- a/include/exec/memory.h
+++ b/include/exec/memory.h
@@ -2336,7 +2336,7 @@ void address_space_unmap(AddressSpace *as, void *buffer, hwaddr len,
 MemTxResult address_space_read_full(AddressSpace *as, hwaddr addr,
                                     MemTxAttrs attrs, uint8_t *buf, hwaddr len);
 MemTxResult flatview_read_continue(FlatView *fv, hwaddr addr,
-                                   MemTxAttrs attrs, uint8_t *buf,
+                                   MemTxAttrs attrs, void *buf,
                                    hwaddr len, hwaddr addr1, hwaddr l,
                                    MemoryRegion *mr);
 void *qemu_map_ram_ptr(RAMBlock *ram_block, ram_addr_t addr);
diff --git a/exec.c b/exec.c
index 06e386dc72..980cc0e2b2 100644
--- a/exec.c
+++ b/exec.c
@@ -2780,9 +2780,9 @@ void cpu_check_watchpoint(CPUState *cpu, vaddr addr, vaddr len,
 }
 
 static MemTxResult flatview_read(FlatView *fv, hwaddr addr,
-                                 MemTxAttrs attrs, uint8_t *buf, hwaddr len);
+                                 MemTxAttrs attrs, void *buf, hwaddr len);
 static MemTxResult flatview_write(FlatView *fv, hwaddr addr, MemTxAttrs attrs,
-                                  const uint8_t *buf, hwaddr len);
+                                  const void *buf, hwaddr len);
 static bool flatview_access_valid(FlatView *fv, hwaddr addr, hwaddr len,
                                   bool is_write, MemTxAttrs attrs);
 
@@ -3147,7 +3147,7 @@ static bool prepare_mmio_access(MemoryRegion *mr)
 /* Called within RCU critical section.  */
 static MemTxResult flatview_write_continue(FlatView *fv, hwaddr addr,
                                            MemTxAttrs attrs,
-                                           const uint8_t *buf,
+                                           const void *ptr,
                                            hwaddr len, hwaddr addr1,
                                            hwaddr l, MemoryRegion *mr)
 {
@@ -3155,6 +3155,7 @@ static MemTxResult flatview_write_continue(FlatView *fv, hwaddr addr,
     uint64_t val;
     MemTxResult result = MEMTX_OK;
     bool release_lock = false;
+    const uint8_t *buf = ptr;
 
     for (;;) {
         if (!memory_access_is_direct(mr, true)) {
@@ -3194,7 +3195,7 @@ static MemTxResult flatview_write_continue(FlatView *fv, hwaddr addr,
 
 /* Called from RCU critical section.  */
 static MemTxResult flatview_write(FlatView *fv, hwaddr addr, MemTxAttrs attrs,
-                                  const uint8_t *buf, hwaddr len)
+                                  const void *buf, hwaddr len)
 {
     hwaddr l;
     hwaddr addr1;
@@ -3211,7 +3212,7 @@ static MemTxResult flatview_write(FlatView *fv, hwaddr addr, MemTxAttrs attrs,
 
 /* Called within RCU critical section.  */
 MemTxResult flatview_read_continue(FlatView *fv, hwaddr addr,
-                                   MemTxAttrs attrs, uint8_t *buf,
+                                   MemTxAttrs attrs, void *ptr,
                                    hwaddr len, hwaddr addr1, hwaddr l,
                                    MemoryRegion *mr)
 {
@@ -3219,6 +3220,7 @@ MemTxResult flatview_read_continue(FlatView *fv, hwaddr addr,
     uint64_t val;
     MemTxResult result = MEMTX_OK;
     bool release_lock = false;
+    uint8_t *buf = ptr;
 
     for (;;) {
         if (!memory_access_is_direct(mr, false)) {
@@ -3256,7 +3258,7 @@ MemTxResult flatview_read_continue(FlatView *fv, hwaddr addr,
 
 /* Called from RCU critical section.  */
 static MemTxResult flatview_read(FlatView *fv, hwaddr addr,
-                                 MemTxAttrs attrs, uint8_t *buf, hwaddr len)
+                                 MemTxAttrs attrs, void *buf, hwaddr len)
 {
     hwaddr l;
     hwaddr addr1;
-- 
2.21.1

