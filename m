Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD8E31FE16
	for <lists+kvm@lfdr.de>; Fri, 19 Feb 2021 18:43:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbhBSRl2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Feb 2021 12:41:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:26927 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229734AbhBSRlU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Feb 2021 12:41:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613756393;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=23DXGFBg27YE0s/hCFn43oTEX31jOtnU+ISUArv5+bE=;
        b=IcQ2AKXs++61QBO0a1ox544KU5XDzKHjZEBKrHaL5JgGgQhBvuDIra0LSyQNdE7gKo8jgT
        yQsUSdD4thYkYWNJQKI/PDNNY/61WANoL+3M52HGtYtSAIVcjdn+Gy2gs8d7+V9qr9xh6u
        s0aMVjPSdaUPDTXDdX+BdWbf1b5zjrI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-602-NTANttm1MkKGdUkO7WTkmA-1; Fri, 19 Feb 2021 12:39:49 -0500
X-MC-Unique: NTANttm1MkKGdUkO7WTkmA-1
Received: by mail-wr1-f70.google.com with SMTP id l3so1135880wrx.15
        for <kvm@vger.kernel.org>; Fri, 19 Feb 2021 09:39:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=23DXGFBg27YE0s/hCFn43oTEX31jOtnU+ISUArv5+bE=;
        b=iwcNicuwmFJC/66enQ3X0fvDqrllcaQptO9JQ5jUe34Bhgqfz+VDjqftNGhT92xE+G
         szUqRI3V417JSfK3BEEFLwSN44QuD2pH1Wo0v2pgdaHlCnoMmWMl+/69fR+BLoku8/4V
         91OLYMird7oyu72tQdraOd/hwdI572wqyfqi05Cj+LT0BZqJYm4FOPK9wdcu+ldC8mTq
         hC0vcCUVDhpWPain1DKTbqaqltGVaggc5/3PXu5q2MzIILwH55zmg7J6IvlpAsTzhN+O
         xjbT0ALdaopxkjm5taJlNvyFSZlZ9QBF+LC3GFlSqVLY1Aar+9xEKzvPbWd9ceq3hWxG
         7XfA==
X-Gm-Message-State: AOAM530f5ySQNv0JutVV0fM9+rRX5V2FrX142p+yOQtPkoUAFBPq+dU2
        YFppBhitJd3a3qrCCrcF57dQFB5M/crGTo1rl/fYqsDPPIKegLV8q2wh4L2r6b9MaF9VAxhTxfB
        NzAp03LRCSr/g
X-Received: by 2002:a7b:c095:: with SMTP id r21mr3049546wmh.48.1613756387884;
        Fri, 19 Feb 2021 09:39:47 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxiAWfgHRpHyAW3kKe8U38bgrZikJVMduVGw3sP0TrSilsr1/3Kg29a0ZDcfjt7MheizWAw2g==
X-Received: by 2002:a7b:c095:: with SMTP id r21mr3049522wmh.48.1613756387730;
        Fri, 19 Feb 2021 09:39:47 -0800 (PST)
Received: from localhost.localdomain (68.red-83-57-175.dynamicip.rima-tde.net. [83.57.175.68])
        by smtp.gmail.com with ESMTPSA id v9sm9098392wrn.86.2021.02.19.09.39.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Feb 2021 09:39:47 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Aurelien Jarno <aurelien@aurel32.net>,
        Peter Maydell <peter.maydell@linaro.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        qemu-ppc@nongnu.org, qemu-s390x@nongnu.org,
        Halil Pasic <pasic@linux.ibm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        xen-devel@lists.xenproject.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        qemu-arm@nongnu.org, Stefano Stabellini <sstabellini@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        BALATON Zoltan <balaton@eik.bme.hu>,
        Leif Lindholm <leif@nuviainc.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Radoslaw Biernacki <rad@semihalf.com>,
        Alistair Francis <alistair@alistair23.me>,
        Paul Durrant <paul@xen.org>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        =?UTF-8?q?Herv=C3=A9=20Poussineau?= <hpoussin@reactos.org>,
        Greg Kurz <groug@kaod.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH v2 10/11] hw/board: Only allow TCG accelerator by default
Date:   Fri, 19 Feb 2021 18:38:46 +0100
Message-Id: <20210219173847.2054123-11-philmd@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210219173847.2054123-1-philmd@redhat.com>
References: <20210219173847.2054123-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

By default machines can only use the TCG and QTest accelerators.

If a machine can use another accelerator, it has to explicitly
list it in its MachineClass valid_accelerators[].

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 include/hw/boards.h | 4 ++--
 hw/core/machine.c   | 8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/hw/boards.h b/include/hw/boards.h
index 4d08bc12093..b93d290b348 100644
--- a/include/hw/boards.h
+++ b/include/hw/boards.h
@@ -146,8 +146,8 @@ typedef struct {
  * @valid_accelerators:
  *    If this machine supports a specific set of virtualization accelerators,
  *    this contains a NULL-terminated list of the accelerators that can be
- *    used. If this field is not set, any accelerator is valid. The QTest
- *    accelerator is always valid.
+ *    used. If this field is not set, a default list containing only the TCG
+ *    accelerator is used. The QTest accelerator is always valid.
  * @kvm_type:
  *    Return the type of KVM corresponding to the kvm-type string option or
  *    computed based on other criteria such as the host kernel capabilities
diff --git a/hw/core/machine.c b/hw/core/machine.c
index c42d8e382b1..ca7c9ee2a0c 100644
--- a/hw/core/machine.c
+++ b/hw/core/machine.c
@@ -520,11 +520,11 @@ static void machine_set_nvdimm_persistence(Object *obj, const char *value,
 
 bool machine_class_valid_for_accelerator(MachineClass *mc, const char *acc_name)
 {
-    const char *const *name = mc->valid_accelerators;
+    static const char *const default_accels[] = {
+        "tcg", NULL
+    };
+    const char *const *name = mc->valid_accelerators ? : default_accels;
 
-    if (!name) {
-        return true;
-    }
     if (strcmp(acc_name, "qtest") == 0) {
         return true;
     }
-- 
2.26.2

