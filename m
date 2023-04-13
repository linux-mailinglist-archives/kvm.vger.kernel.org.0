Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2DF76E145B
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 20:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbjDMSnF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Apr 2023 14:43:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbjDMSnA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Apr 2023 14:43:00 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C37E16E8B
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 11:42:37 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id v6so15148819wrv.8
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 11:42:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1681411356; x=1684003356;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W3zF9L90WHl9HX3lIHN8PhlLKSh7mZHA2/MDuZLToOo=;
        b=bTBM0JW+C7BcYhZCr/ZwN4e0PJj2h+EypJpRzhNHtzdmPJ9j8O7zkDjNbB2AAyGH3T
         oslP9XaSbUfejZqApiMG7qhUAN/DJ7vfosUlrvZ29Yel3NVxbD08TroxGdmBiC1koic2
         xYTYhpUWBE4T8Znm2+S31VhDQhrYIbMgu9RV8sF6/9IWLw11QkTqB8F8Z+4/lyBSpD35
         B1JWqPFXqxuS0PnZoI1/uQTgxi6iS4s3xEUMZV1KA5NS2jJMDVloIPLd6RKAQSk2HfQd
         nuDuSvNlICgDVcY7c+xHMSq92MF9RUyEbCd6COnPc4Dzrljp2E5wody+r3asBrdXAD/4
         JXQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681411356; x=1684003356;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W3zF9L90WHl9HX3lIHN8PhlLKSh7mZHA2/MDuZLToOo=;
        b=MVNNgPSBXAFwHrd0Zs+xSCZ3bfVm38syNVTdp/XRZdfK4UMOnDtOZ6mr5OzjGT91Ac
         5HR0kw/YQH5YOPCRxF8dz/5k5gBF8YMLoKHImvpjnDTnMn3k9O5GBucAVaUxSCn4YI/V
         xsPS7gTMtPx4ZRcotECzokTFDGqxYfGIzcejCW2g3Q2vrNSrtnwxiLJiEPZE0cHVSqFt
         4vG9NCrYO8tJXyjBAIWDyjgE+CEcBCan8X8Uj+M2WY3bOgXMX8p2k8J+8zFaclKnoN1w
         dgfBl1ViAaBgXveLd25XMC6zR8LgzzwvbByHESTjDKYry/RBie8Uyv8EO8LTbUgF4eX2
         5xIw==
X-Gm-Message-State: AAQBX9dOC4e6DratK24H7Vor4IE9jAG9syGZs8j4RrS/krAi52krE6FI
        pS5lakG4xbiQlGSiTwuneQpYZA==
X-Google-Smtp-Source: AKy350aRw8htUWdbvnPpcFbpyEpuVQs4L7rJo5vRSpgLgaecwjUsgpDcuzfkEF8di/oB25AYWTFikg==
X-Received: by 2002:adf:e7c1:0:b0:2ce:9fb8:b560 with SMTP id e1-20020adfe7c1000000b002ce9fb8b560mr2250082wrn.8.1681411356302;
        Thu, 13 Apr 2023 11:42:36 -0700 (PDT)
Received: from nuc.fritz.box (p200300f6af154800ce0bb7f104d5fcf7.dip0.t-ipconnect.de. [2003:f6:af15:4800:ce0b:b7f1:4d5:fcf7])
        by smtp.gmail.com with ESMTPSA id x15-20020a5d6b4f000000b002c8476dde7asm1812652wrw.114.2023.04.13.11.42.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 11:42:35 -0700 (PDT)
From:   Mathias Krause <minipli@grsecurity.net>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Cc:     Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH v2 01/16] x86: Drop types.h
Date:   Thu, 13 Apr 2023 20:42:04 +0200
Message-Id: <20230413184219.36404-2-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230413184219.36404-1-minipli@grsecurity.net>
References: <20230413184219.36404-1-minipli@grsecurity.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The file types.h never declared any types, only exception vectors which
are partially re-defined in processor.h.

Move the remaining vector definitions to processor.h and remove types.h,
as all users already include processor.h

Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 lib/x86/processor.h |  7 +++++++
 x86/types.h         | 21 ---------------------
 x86/cmpxchg8b.c     |  1 -
 x86/emulator.c      |  1 -
 x86/pmu_pebs.c      |  1 -
 x86/svm.c           |  1 -
 x86/svm_tests.c     |  1 -
 x86/vmx_tests.c     |  1 -
 8 files changed, 7 insertions(+), 27 deletions(-)
 delete mode 100644 x86/types.h

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 6555056e8a13..91a9022ef43c 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -19,16 +19,23 @@
 #  define S "4"
 #endif
 
+#define DE_VECTOR 0
 #define DB_VECTOR 1
+#define NMI_VECTOR 2
 #define BP_VECTOR 3
+#define OF_VECTOR 4
+#define BR_VECTOR 5
 #define UD_VECTOR 6
+#define NM_VECTOR 7
 #define DF_VECTOR 8
 #define TS_VECTOR 10
 #define NP_VECTOR 11
 #define SS_VECTOR 12
 #define GP_VECTOR 13
 #define PF_VECTOR 14
+#define MF_VECTOR 16
 #define AC_VECTOR 17
+#define MC_VECTOR 18
 #define CP_VECTOR 21
 
 #define X86_CR0_PE_BIT		(0)
diff --git a/x86/types.h b/x86/types.h
deleted file mode 100644
index 56ce5ececdec..000000000000
--- a/x86/types.h
+++ /dev/null
@@ -1,21 +0,0 @@
-#ifndef X86_TYPES_H
-#define X86_TYPES_H
-
-#define DE_VECTOR 0
-#define DB_VECTOR 1
-#define NMI_VECTOR 2
-#define BP_VECTOR 3
-#define OF_VECTOR 4
-#define BR_VECTOR 5
-#define UD_VECTOR 6
-#define NM_VECTOR 7
-#define DF_VECTOR 8
-#define TS_VECTOR 10
-#define NP_VECTOR 11
-#define SS_VECTOR 12
-#define GP_VECTOR 13
-#define PF_VECTOR 14
-#define MF_VECTOR 16
-#define MC_VECTOR 18
-
-#endif
diff --git a/x86/cmpxchg8b.c b/x86/cmpxchg8b.c
index a416f44f2067..8afe629ea257 100644
--- a/x86/cmpxchg8b.c
+++ b/x86/cmpxchg8b.c
@@ -2,7 +2,6 @@
 #include "vm.h"
 #include "libcflat.h"
 #include "desc.h"
-#include "types.h"
 #include "processor.h"
 
 static void test_cmpxchg8b(u32 *mem)
diff --git a/x86/emulator.c b/x86/emulator.c
index ad9437403fef..f8bdc26b70ad 100644
--- a/x86/emulator.c
+++ b/x86/emulator.c
@@ -4,7 +4,6 @@
 #include "vm.h"
 #include "libcflat.h"
 #include "desc.h"
-#include "types.h"
 #include "processor.h"
 #include "vmalloc.h"
 #include "alloc_page.h"
diff --git a/x86/pmu_pebs.c b/x86/pmu_pebs.c
index 894ae6c784f9..d1a68ca336ab 100644
--- a/x86/pmu_pebs.c
+++ b/x86/pmu_pebs.c
@@ -8,7 +8,6 @@
 #include "alloc.h"
 
 #include "vm.h"
-#include "types.h"
 #include "processor.h"
 #include "vmalloc.h"
 #include "alloc_page.h"
diff --git a/x86/svm.c b/x86/svm.c
index ba435b4ac3af..63a84720709d 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -10,7 +10,6 @@
 #include "vm.h"
 #include "fwcfg.h"
 #include "smp.h"
-#include "types.h"
 #include "alloc_page.h"
 #include "isr.h"
 #include "apic.h"
diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 27ce47b4f98e..691ac937288a 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -5,7 +5,6 @@
 #include "msr.h"
 #include "vm.h"
 #include "smp.h"
-#include "types.h"
 #include "alloc_page.h"
 #include "isr.h"
 #include "apic.h"
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 7952ccb932ea..96104ab018d8 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -16,7 +16,6 @@
 #include "isr.h"
 #include "desc.h"
 #include "apic.h"
-#include "types.h"
 #include "vmalloc.h"
 #include "alloc_page.h"
 #include "smp.h"
-- 
2.39.2

