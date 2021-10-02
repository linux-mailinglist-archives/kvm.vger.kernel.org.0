Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7F5041FBEA
	for <lists+kvm@lfdr.de>; Sat,  2 Oct 2021 14:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233305AbhJBM4D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 2 Oct 2021 08:56:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:54955 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233277AbhJBM4C (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 2 Oct 2021 08:56:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633179256;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PLN18Kg90p6yE/kKbVk7ZeNbapKw0JC8XYHCCSL7Hxc=;
        b=YqOIYt51o9O0/haJF1hiBqvCXQudbr3IhwIeRxxkJ/itSPYDd7kbeTKP6XPtvPDrRd0yeH
        DUJW671V52xh8x7gN4VpMFpvKbRydKb8OotOBa7I0csqWO5l+utEJ9BlslsSQBlteIpZ7S
        /3U5+8kuE3pbYp6aGdlHG0Y0NMg85bo=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-3-OEm_g37eNJqB4S-Nf965yA-1; Sat, 02 Oct 2021 08:54:14 -0400
X-MC-Unique: OEm_g37eNJqB4S-Nf965yA-1
Received: by mail-wm1-f71.google.com with SMTP id m2-20020a05600c3b0200b0030cd1310631so3791381wms.7
        for <kvm@vger.kernel.org>; Sat, 02 Oct 2021 05:54:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PLN18Kg90p6yE/kKbVk7ZeNbapKw0JC8XYHCCSL7Hxc=;
        b=w9P7CmKtNYBWxNBauEiOehSdwWzbcp1k6g7EqF0bFpJ/vTJsfktwwSAi3gUZnxxelm
         rRIZIuTug8aPWTa9iHGIKw54WSBCy7CzoncgOY5fi5FNENTZa4vzokRRsvDE7JLdmbv/
         ulwQosqqEoPvMFj5Eab042znxM/SKGcZ3NXI5c9okjk5Sd5mkcQPvNsA5ijIzTMTgp8i
         Bd3aEYTYQhBsUSeyTtecd97pwof8BxHb46DJ2a8QYBI11mRwcf8zcnOLpgdkZ5G0tcBD
         urY7UfGKqB3c42nDaH9v8wBbRWkaJtsfL5gAx9IdcZS/fRPmNwYN0xmqNqLe+RgMp64X
         RtFA==
X-Gm-Message-State: AOAM533062MDzx11a23mhrleO8JcyPRdnqOiTyYxoPDuEMCQ30ViW326
        tgvigYhQ95JDVy+EvOy1DxH468C9Te9bSsn0NdzwD2otNARW4THwfX3CMByD+q1xNTdGRIKiFiz
        INZoB4yOJ+JS/
X-Received: by 2002:a1c:451:: with SMTP id 78mr9420870wme.158.1633179253571;
        Sat, 02 Oct 2021 05:54:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxvcuP74ApKFXkJudhkd8SG4XnSX9kLVw5i9VtVFVZpVk56S2QPWclGVjksHGgaC8beyVsBGA==
X-Received: by 2002:a1c:451:: with SMTP id 78mr9420859wme.158.1633179253445;
        Sat, 02 Oct 2021 05:54:13 -0700 (PDT)
Received: from x1w.. (118.red-83-35-24.dynamicip.rima-tde.net. [83.35.24.118])
        by smtp.gmail.com with ESMTPSA id f3sm4714202wmb.12.2021.10.02.05.54.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Oct 2021 05:54:13 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Sergio Lopez <slp@redhat.com>, kvm@vger.kernel.org,
        James Bottomley <jejb@linux.ibm.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        "Daniel P . Berrange" <berrange@redhat.com>
Subject: [PATCH v3 12/22] target/i386/sev: Declare system-specific functions in 'sev_i386.h'
Date:   Sat,  2 Oct 2021 14:53:07 +0200
Message-Id: <20211002125317.3418648-13-philmd@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211002125317.3418648-1-philmd@redhat.com>
References: <20211002125317.3418648-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

While prefixed with sysemu, 'sysemu/sev.h' contains the architecture
specific declarations. The system specific parts are declared in
'sev_i386.h'.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 include/sysemu/sev.h   | 6 ------
 target/i386/sev_i386.h | 7 +++++++
 hw/i386/pc_sysfw.c     | 2 +-
 3 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/include/sysemu/sev.h b/include/sysemu/sev.h
index 94d821d737c..a329ed75c1c 100644
--- a/include/sysemu/sev.h
+++ b/include/sysemu/sev.h
@@ -18,11 +18,5 @@
 
 bool sev_enabled(void);
 int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp);
-int sev_encrypt_flash(uint8_t *ptr, uint64_t len, Error **errp);
-int sev_inject_launch_secret(const char *hdr, const char *secret,
-                             uint64_t gpa, Error **errp);
-
-int sev_es_save_reset_vector(void *flash_ptr, uint64_t flash_size);
-void sev_es_set_reset_vector(CPUState *cpu);
 
 #endif
diff --git a/target/i386/sev_i386.h b/target/i386/sev_i386.h
index afa19a0a161..0798ab3519a 100644
--- a/target/i386/sev_i386.h
+++ b/target/i386/sev_i386.h
@@ -33,4 +33,11 @@ extern SevCapability *sev_get_capabilities(Error **errp);
 extern SevAttestationReport *
 sev_get_attestation_report(const char *mnonce, Error **errp);
 
+int sev_encrypt_flash(uint8_t *ptr, uint64_t len, Error **errp);
+int sev_inject_launch_secret(const char *hdr, const char *secret,
+                             uint64_t gpa, Error **errp);
+
+int sev_es_save_reset_vector(void *flash_ptr, uint64_t flash_size);
+void sev_es_set_reset_vector(CPUState *cpu);
+
 #endif
diff --git a/hw/i386/pc_sysfw.c b/hw/i386/pc_sysfw.c
index 68d6b1f783e..0b202138b66 100644
--- a/hw/i386/pc_sysfw.c
+++ b/hw/i386/pc_sysfw.c
@@ -37,7 +37,7 @@
 #include "hw/qdev-properties.h"
 #include "hw/block/flash.h"
 #include "sysemu/kvm.h"
-#include "sysemu/sev.h"
+#include "sev_i386.h"
 
 #define FLASH_SECTOR_SIZE 4096
 
-- 
2.31.1

