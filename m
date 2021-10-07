Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0824257A8
	for <lists+kvm@lfdr.de>; Thu,  7 Oct 2021 18:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242684AbhJGQU0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 12:20:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20318 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242564AbhJGQUY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Oct 2021 12:20:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633623510;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lGxIOiDkjtO7lLXCNUhDroR/93vYB4x6AaMAet+1gIs=;
        b=avXcXbAy4urC9toGCKeIuRglne29Z41Ke5WBUtOexhmyloLzugSkFiPm8zBeNo5T5e2CSX
        mZ+12hsYjAi7FTUNn+KBrsPUo7W50KBIgn5Q8ELbOMbK8RGO6y0H2vHHKOQneMfk+xzkrL
        Ifbhd0Ou4nd6znyDjLUPIC4Kx7kGVFc=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-170-FaRU5B4gMHSjKF8viroyhQ-1; Thu, 07 Oct 2021 12:18:29 -0400
X-MC-Unique: FaRU5B4gMHSjKF8viroyhQ-1
Received: by mail-wr1-f69.google.com with SMTP id k2-20020adfc702000000b0016006b2da9bso5116334wrg.1
        for <kvm@vger.kernel.org>; Thu, 07 Oct 2021 09:18:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lGxIOiDkjtO7lLXCNUhDroR/93vYB4x6AaMAet+1gIs=;
        b=0forFgsQJbVdKBE0PsprCoXwC6UljhJQgXf8lxKiJRCEAI6l0iloVClQPDBzmrA9Pd
         kufm3tvOMaDSaZoPktbs11GmET6bOhtaqajL1fiSsaymN2zyKQvEJHXAovOr3QNA9Jvi
         oRvtqYsF/j/YBQG7ClCeb0wysIQ7HIiz3K5oXT1HWbq+P0Tj71e3fjewUa1Ef2fZJJt9
         39ORjDU4hSFuMsoMtzbuIsADMZCKPU6amulMc2hXbfSM7q3sLeYZpnmNG1/EwWjnNMXz
         +h0BDjMiRHWOPuCMDI21CI95/MB5GT3Hzyxf/sRT4CrrWTiNrbyXxs9ghbNM601FSrQQ
         N16g==
X-Gm-Message-State: AOAM530VZG15tyJujn0PwRxD3zMpD+TKHsKy+cAZXcYOC5bO3lNLoWGC
        AHs9VfU9vayNS6y/Z1LUpbXZkYSXbQ9RlZ/RF80QzT6BpkE315BnKav6qKhiesG0QPP5BFxPWj2
        9MKirZzeiUaLb
X-Received: by 2002:a05:6000:18a3:: with SMTP id b3mr6651388wri.178.1633623507249;
        Thu, 07 Oct 2021 09:18:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxGxFUSQBIuymUcqyNofEv5FzSKPyuPr7MuNzby3hK9l903zkFHngcL71AixMMoIYrkPVrZ9w==
X-Received: by 2002:a05:6000:18a3:: with SMTP id b3mr6651373wri.178.1633623507093;
        Thu, 07 Oct 2021 09:18:27 -0700 (PDT)
Received: from x1w.redhat.com (118.red-83-35-24.dynamicip.rima-tde.net. [83.35.24.118])
        by smtp.gmail.com with ESMTPSA id v185sm4584081wme.35.2021.10.07.09.18.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 09:18:26 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Sergio Lopez <slp@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH v4 15/23] target/i386/sev: Declare system-specific functions in 'sev.h'
Date:   Thu,  7 Oct 2021 18:17:08 +0200
Message-Id: <20211007161716.453984-16-philmd@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211007161716.453984-1-philmd@redhat.com>
References: <20211007161716.453984-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

"sysemu/sev.h" is only used from x86-specific files. Let's move it
to include/hw/i386, and merge it with target/i386/sev.h.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 include/sysemu/sev.h       | 28 ----------------------------
 target/i386/sev.h          | 12 +++++++++++-
 hw/i386/pc_sysfw.c         |  2 +-
 target/i386/kvm/kvm.c      |  1 -
 target/i386/kvm/sev-stub.c |  2 +-
 target/i386/monitor.c      |  1 -
 6 files changed, 13 insertions(+), 33 deletions(-)
 delete mode 100644 include/sysemu/sev.h

diff --git a/include/sysemu/sev.h b/include/sysemu/sev.h
deleted file mode 100644
index 94d821d737c..00000000000
--- a/include/sysemu/sev.h
+++ /dev/null
@@ -1,28 +0,0 @@
-/*
- * QEMU Secure Encrypted Virutualization (SEV) support
- *
- * Copyright: Advanced Micro Devices, 2016-2018
- *
- * Authors:
- *  Brijesh Singh <brijesh.singh@amd.com>
- *
- * This work is licensed under the terms of the GNU GPL, version 2 or later.
- * See the COPYING file in the top-level directory.
- *
- */
-
-#ifndef QEMU_SEV_H
-#define QEMU_SEV_H
-
-#include "sysemu/kvm.h"
-
-bool sev_enabled(void);
-int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp);
-int sev_encrypt_flash(uint8_t *ptr, uint64_t len, Error **errp);
-int sev_inject_launch_secret(const char *hdr, const char *secret,
-                             uint64_t gpa, Error **errp);
-
-int sev_es_save_reset_vector(void *flash_ptr, uint64_t flash_size);
-void sev_es_set_reset_vector(CPUState *cpu);
-
-#endif
diff --git a/target/i386/sev.h b/target/i386/sev.h
index d83428fa265..c96072bf78d 100644
--- a/target/i386/sev.h
+++ b/target/i386/sev.h
@@ -14,7 +14,7 @@
 #ifndef QEMU_SEV_I386_H
 #define QEMU_SEV_I386_H
 
-#include "sysemu/sev.h"
+#include "exec/confidential-guest-support.h"
 #include "qapi/qapi-types-misc-target.h"
 
 #define SEV_POLICY_NODBG        0x1
@@ -35,6 +35,7 @@ typedef struct SevKernelLoaderContext {
     size_t cmdline_size;
 } SevKernelLoaderContext;
 
+bool sev_enabled(void);
 extern bool sev_es_enabled(void);
 extern SevInfo *sev_get_info(void);
 extern uint32_t sev_get_cbit_position(void);
@@ -45,4 +46,13 @@ extern SevAttestationReport *
 sev_get_attestation_report(const char *mnonce, Error **errp);
 extern bool sev_add_kernel_loader_hashes(SevKernelLoaderContext *ctx, Error **errp);
 
+int sev_encrypt_flash(uint8_t *ptr, uint64_t len, Error **errp);
+int sev_inject_launch_secret(const char *hdr, const char *secret,
+                             uint64_t gpa, Error **errp);
+
+int sev_es_save_reset_vector(void *flash_ptr, uint64_t flash_size);
+void sev_es_set_reset_vector(CPUState *cpu);
+
+int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp);
+
 #endif
diff --git a/hw/i386/pc_sysfw.c b/hw/i386/pc_sysfw.c
index 68d6b1f783e..c8b17af9535 100644
--- a/hw/i386/pc_sysfw.c
+++ b/hw/i386/pc_sysfw.c
@@ -37,7 +37,7 @@
 #include "hw/qdev-properties.h"
 #include "hw/block/flash.h"
 #include "sysemu/kvm.h"
-#include "sysemu/sev.h"
+#include "sev.h"
 
 #define FLASH_SECTOR_SIZE 4096
 
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index a5f6ff63c81..0eb7a0340cf 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -44,7 +44,6 @@
 #include "hw/i386/intel_iommu.h"
 #include "hw/i386/x86-iommu.h"
 #include "hw/i386/e820_memory_layout.h"
-#include "sysemu/sev.h"
 
 #include "hw/pci/pci.h"
 #include "hw/pci/msi.h"
diff --git a/target/i386/kvm/sev-stub.c b/target/i386/kvm/sev-stub.c
index 9587d1b2a31..6080c007a2e 100644
--- a/target/i386/kvm/sev-stub.c
+++ b/target/i386/kvm/sev-stub.c
@@ -13,7 +13,7 @@
 
 #include "qemu/osdep.h"
 #include "qemu-common.h"
-#include "sysemu/sev.h"
+#include "sev.h"
 
 int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
 {
diff --git a/target/i386/monitor.c b/target/i386/monitor.c
index 109e4e61c0a..935a8ee8ca4 100644
--- a/target/i386/monitor.c
+++ b/target/i386/monitor.c
@@ -30,7 +30,6 @@
 #include "qapi/qmp/qdict.h"
 #include "qapi/qmp/qerror.h"
 #include "sysemu/kvm.h"
-#include "sysemu/sev.h"
 #include "qapi/error.h"
 #include "sev.h"
 #include "qapi/qapi-commands-misc-target.h"
-- 
2.31.1

