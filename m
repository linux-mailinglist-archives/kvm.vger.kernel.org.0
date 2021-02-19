Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28BB231F88F
	for <lists+kvm@lfdr.de>; Fri, 19 Feb 2021 12:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbhBSLqJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Feb 2021 06:46:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59273 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230308AbhBSLqH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Feb 2021 06:46:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613735080;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=98X4DsBNdk1BN09KWcHx0mE3/gzzTZdKxOLSGajyIeI=;
        b=NtMesX1+Zeqvpm9/jZNRgi1h4EN5bIYdcec9PvD9MpsI067OC7+Ra5jscK2053LG5ADn02
        ekJcpy94Oj5PTsbjMqUN8nO2Z96s9GddyUWYUK98lpmDGPq69H171LQ6jT+YtPC1Z8K52z
        4GSvGFKhHf+SvH375bFUqbRhSelBBow=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-508-RpR5mxJUPa-9twbBIAnbmQ-1; Fri, 19 Feb 2021 06:44:38 -0500
X-MC-Unique: RpR5mxJUPa-9twbBIAnbmQ-1
Received: by mail-wm1-f71.google.com with SMTP id b201so2353510wmb.9
        for <kvm@vger.kernel.org>; Fri, 19 Feb 2021 03:44:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=98X4DsBNdk1BN09KWcHx0mE3/gzzTZdKxOLSGajyIeI=;
        b=bo8O9xJsG0C37oRFi51piBi3j4+HUu8p182tmWi1O/23aL7GnO77GX9tIkFNRqkuEn
         X2ICIroGFP3Ms9Dna5/bppa0oNLn3K2pNWUAQoSwN/4yMif/54yzPpuIxsrgsQX/RIAI
         RnTaNR7FEBsVQyiTMJFBb3KbSNgSbCzjEKKqhYkD5NP19k+j2mTZkOZWawEHhoKmpcmB
         UZTkLYS/RFLbPpw53tWkPXT8sVR4nZ2OpSWuCaiWM9Gzjvx1gYH9y5My8flQ1UsgKPwM
         FfneMsAfhRqwMJagpDccHFZpn4QkiTd7KFhxE1NzYTTme0hU4BCd87oAaZLyGBlgDVjE
         cI+A==
X-Gm-Message-State: AOAM530yX+t3SPgdKOFH8iDrzmxYi7Mpqilg8USD28TZuIta7MzuN8cQ
        XhjWGYA9tly5+TdpBo7/zMMx6ayrWSZeRYG30OaV6r0hTEurR9dTs4Va3u+1dNJH94OXAf9qn3B
        KLOujmeqS3Maa
X-Received: by 2002:adf:b357:: with SMTP id k23mr8694387wrd.354.1613735077426;
        Fri, 19 Feb 2021 03:44:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy8BoyDIy3MZrDx4a9/uBNg8Gu4uQrRfjBpdhkb1HenxWvZ3lMMW1roaXGxl/Jsmb64BZpXBA==
X-Received: by 2002:adf:b357:: with SMTP id k23mr8694350wrd.354.1613735077292;
        Fri, 19 Feb 2021 03:44:37 -0800 (PST)
Received: from localhost.localdomain (68.red-83-57-175.dynamicip.rima-tde.net. [83.57.175.68])
        by smtp.gmail.com with ESMTPSA id w81sm11424135wmb.3.2021.02.19.03.44.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Feb 2021 03:44:36 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Radoslaw Biernacki <rad@semihalf.com>,
        Paolo Bonzini <pbonzini@redhat.com>, qemu-s390x@nongnu.org,
        Greg Kurz <groug@kaod.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        qemu-arm@nongnu.org, Cornelia Huck <cohuck@redhat.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        BALATON Zoltan <balaton@eik.bme.hu>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Leif Lindholm <leif@nuviainc.com>,
        Alistair Francis <alistair@alistair23.me>,
        Thomas Huth <thuth@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, qemu-ppc@nongnu.org,
        =?UTF-8?q?Herv=C3=A9=20Poussineau?= <hpoussin@reactos.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        kvm@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH 1/7] accel/kvm: Check MachineClass kvm_type() return value
Date:   Fri, 19 Feb 2021 12:44:22 +0100
Message-Id: <20210219114428.1936109-2-philmd@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210219114428.1936109-1-philmd@redhat.com>
References: <20210219114428.1936109-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

MachineClass::kvm_type() can return -1 on failure.
Document it, and add a check in kvm_init().

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 include/hw/boards.h | 3 ++-
 accel/kvm/kvm-all.c | 6 ++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/hw/boards.h b/include/hw/boards.h
index a46dfe5d1a6..68d3d10f6b0 100644
--- a/include/hw/boards.h
+++ b/include/hw/boards.h
@@ -127,7 +127,8 @@ typedef struct {
  *    implement and a stub device is required.
  * @kvm_type:
  *    Return the type of KVM corresponding to the kvm-type string option or
- *    computed based on other criteria such as the host kernel capabilities.
+ *    computed based on other criteria such as the host kernel capabilities
+ *    (which can't be negative), or -1 on error.
  * @numa_mem_supported:
  *    true if '--numa node.mem' option is supported and false otherwise
  * @smp_parse:
diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 84c943fcdb2..b069938d881 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2057,6 +2057,12 @@ static int kvm_init(MachineState *ms)
                                                             "kvm-type",
                                                             &error_abort);
         type = mc->kvm_type(ms, kvm_type);
+        if (type < 0) {
+            ret = -EINVAL;
+            fprintf(stderr, "Failed to detect kvm-type for machine '%s'\n",
+                    mc->name);
+            goto err;
+        }
     }
 
     do {
-- 
2.26.2

