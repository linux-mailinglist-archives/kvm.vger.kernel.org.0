Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 536CE186FDA
	for <lists+kvm@lfdr.de>; Mon, 16 Mar 2020 17:18:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732005AbgCPQSk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Mar 2020 12:18:40 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:30854 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731545AbgCPQSj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Mar 2020 12:18:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584375518;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WUQmK3jX+ITRgjT53gJOYB77qbIWiqXEgYr8J8FbjTA=;
        b=ZyxYnznZFFpwgBIrvnEqFnHvPDDy5LxYF/LBIMfhNjAATkXGrnZ4BRJXAyeghwRXmliayO
        yynP63D8i4L4TOXPfQRDZ9tSc5XPA0xfMRn0Q9l0iivXZr5oRRnlTe7P54AGXXrXbeY/FK
        7YHRq4LEb4CH/bmfAnxtLEdbt0i3pAQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-139-8fK9p7SXPHKMlaIwDbeE-w-1; Mon, 16 Mar 2020 12:06:45 -0400
X-MC-Unique: 8fK9p7SXPHKMlaIwDbeE-w-1
Received: by mail-wr1-f69.google.com with SMTP id w11so9253211wrp.20
        for <kvm@vger.kernel.org>; Mon, 16 Mar 2020 09:06:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WUQmK3jX+ITRgjT53gJOYB77qbIWiqXEgYr8J8FbjTA=;
        b=qJN0epzUfboFFZAZdVODeqvnhgFgOcI/6odg5TAL+1+1ueS2a5LlA9ruG6TPXIYFq+
         d5qooN85LMszAm+upWjA8Omtd5T7aPm5aItOJ/KmRDWEW6HPBxIs+ExD8WuC1dSBeYEH
         tmg9lX0jqaIETJcbE7bU5z3Gr8uzqw+u236p6+UkXtFT+59ow90wG/C9YB7Yt2KBAsbN
         l98uoRnU9YOst1njAG2d5T58wIQ1NimXAAUXvtFM1NM3OL16SRCdSnwFQU9CTeQc1Tnl
         kEcIVNY2A2S3jMzKFPjKR1cYczWj5wGn2+yD8jXCGEdddzE7Ztr2rr/tG7wX2qUeGwMl
         Uq0Q==
X-Gm-Message-State: ANhLgQ2BlHpf4c0rEkg+dtmwvRu6+QdiRpB0KieQ7tglxuFeAKQOGK0P
        KPl68p4dow+zXEb+3FwIcN+3zE0HfyRIjzI5/9OZJsPJLA5fw52EiIvj4mEIDwbWEyeGeBfC70S
        wT0nzXiW9TgtY
X-Received: by 2002:a1c:ab04:: with SMTP id u4mr28378905wme.88.1584374803976;
        Mon, 16 Mar 2020 09:06:43 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtV0XnwGOD9HZ+gDhSELi6gG1sO2wgoMuiEbFWxHuGz29Lw9cyiUjcbAj92lhznjafti4kUQw==
X-Received: by 2002:a1c:ab04:: with SMTP id u4mr28378818wme.88.1584374802766;
        Mon, 16 Mar 2020 09:06:42 -0700 (PDT)
Received: from localhost.localdomain (96.red-83-59-163.dynamicip.rima-tde.net. [83.59.163.96])
        by smtp.gmail.com with ESMTPSA id a10sm480884wrv.89.2020.03.16.09.06.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2020 09:06:42 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        qemu-arm@nongnu.org, Fam Zheng <fam@euphon.net>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: [PATCH v3 01/19] target/arm: Rename KVM set_feature() as kvm_set_feature()
Date:   Mon, 16 Mar 2020 17:06:16 +0100
Message-Id: <20200316160634.3386-2-philmd@redhat.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200316160634.3386-1-philmd@redhat.com>
References: <20200316160634.3386-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 target/arm/kvm32.c | 10 +++++-----
 target/arm/kvm64.c | 16 ++++++++--------
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/target/arm/kvm32.c b/target/arm/kvm32.c
index f271181ab8..0ab28b473a 100644
--- a/target/arm/kvm32.c
+++ b/target/arm/kvm32.c
@@ -22,7 +22,7 @@
 #include "internals.h"
 #include "qemu/log.h"
 
-static inline void set_feature(uint64_t *features, int feature)
+static inline void kvm_set_feature(uint64_t *features, int feature)
 {
     *features |= 1ULL << feature;
 }
@@ -146,14 +146,14 @@ bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
      * timers; this in turn implies most of the other feature
      * bits, but a few must be tested.
      */
-    set_feature(&features, ARM_FEATURE_V7VE);
-    set_feature(&features, ARM_FEATURE_GENERIC_TIMER);
+    kvm_set_feature(&features, ARM_FEATURE_V7VE);
+    kvm_set_feature(&features, ARM_FEATURE_GENERIC_TIMER);
 
     if (extract32(id_pfr0, 12, 4) == 1) {
-        set_feature(&features, ARM_FEATURE_THUMB2EE);
+        kvm_set_feature(&features, ARM_FEATURE_THUMB2EE);
     }
     if (extract32(ahcf->isar.mvfr1, 12, 4) == 1) {
-        set_feature(&features, ARM_FEATURE_NEON);
+        kvm_set_feature(&features, ARM_FEATURE_NEON);
     }
 
     ahcf->features = features;
diff --git a/target/arm/kvm64.c b/target/arm/kvm64.c
index be5b31c2b0..ad33e048e4 100644
--- a/target/arm/kvm64.c
+++ b/target/arm/kvm64.c
@@ -447,12 +447,12 @@ void kvm_arm_pmu_set_irq(CPUState *cs, int irq)
     }
 }
 
-static inline void set_feature(uint64_t *features, int feature)
+static inline void kvm_set_feature(uint64_t *features, int feature)
 {
     *features |= 1ULL << feature;
 }
 
-static inline void unset_feature(uint64_t *features, int feature)
+static inline void kvm_unset_feature(uint64_t *features, int feature)
 {
     *features &= ~(1ULL << feature);
 }
@@ -648,11 +648,11 @@ bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
      * with VFPv4+Neon; this in turn implies most of the other
      * feature bits.
      */
-    set_feature(&features, ARM_FEATURE_V8);
-    set_feature(&features, ARM_FEATURE_NEON);
-    set_feature(&features, ARM_FEATURE_AARCH64);
-    set_feature(&features, ARM_FEATURE_PMU);
-    set_feature(&features, ARM_FEATURE_GENERIC_TIMER);
+    kvm_set_feature(&features, ARM_FEATURE_V8);
+    kvm_set_feature(&features, ARM_FEATURE_NEON);
+    kvm_set_feature(&features, ARM_FEATURE_AARCH64);
+    kvm_set_feature(&features, ARM_FEATURE_PMU);
+    kvm_set_feature(&features, ARM_FEATURE_GENERIC_TIMER);
 
     ahcf->features = features;
 
@@ -802,7 +802,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
     if (cpu->has_pmu) {
         cpu->kvm_init_features[0] |= 1 << KVM_ARM_VCPU_PMU_V3;
     } else {
-        unset_feature(&env->features, ARM_FEATURE_PMU);
+        kvm_unset_feature(&env->features, ARM_FEATURE_PMU);
     }
     if (cpu_isar_feature(aa64_sve, cpu)) {
         assert(kvm_arm_sve_supported(cs));
-- 
2.21.1

