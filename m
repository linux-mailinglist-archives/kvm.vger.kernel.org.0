Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E7931FCE15
	for <lists+kvm@lfdr.de>; Wed, 17 Jun 2020 15:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbgFQNIJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jun 2020 09:08:09 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:59882 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726134AbgFQNII (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Jun 2020 09:08:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592399286;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=fCMg1kyMR7N+Ov+rmWJLbOZmzhhnmVRoJdGi9LpTDn0=;
        b=RVHdz7kwkzymeFnzd9yLewByyDGKGEfpZuH9TCvpMBFqC9zC7/AO/GmZYZlVSRFyg76GsS
        c9YzNg9tnbw2BRvwFTCXg5WR6x+qjR8g/Kb+e9CXsFRAH6Al47aMbNrIrQwOQtTLziAO8T
        jES857rfFE0/CSqIyoZXc7TrI4P4Wmc=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-101-1bie_mK8NnK8pZITc4e_Qw-1; Wed, 17 Jun 2020 09:08:04 -0400
X-MC-Unique: 1bie_mK8NnK8pZITc4e_Qw-1
Received: by mail-ed1-f71.google.com with SMTP id bs22so844927edb.0
        for <kvm@vger.kernel.org>; Wed, 17 Jun 2020 06:08:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fCMg1kyMR7N+Ov+rmWJLbOZmzhhnmVRoJdGi9LpTDn0=;
        b=IvJgRFncpTEuFm4vkqv87NQvr6muCY0De+w1uYiwphltnilc8gw5xUJwtk28XPI1M5
         KsZa5kt5X7NQEsL14Bgp1nyl8JAfknP2lv18AZSFoTvIIjSKlqCplP8l9quYSCTSb0eN
         w+1NgqPD0vC6V9u2x2rVnreEh5UH1rx0D0DEKCIqpcbYz7U4w94702Vkmjm1MW2DKe1p
         a0t/Joa95XdXKapwJwOoa1KikMnGojCiKPo5Uq0gc3qflAEQHIk3ORu1Lngq/ndGtS+e
         O49ALrn/RGwH0k4AKv3JQ99rU1CdtlV4xqgCQUwd9cqhfqctBmAQ3Hl6aC2dIY4LLb7h
         WEXw==
X-Gm-Message-State: AOAM533L5AT9AVvtRJrVqjRGYdbPYpCHVm4zNObF6/KxbELI3luEB8U1
        +IW4SXcVAyIv+OL7S1hayOezs7BDhymUOCd65m+lZpd88FttWHLcYOdhTRS3gaNukBdwIpE2cf1
        VyvvfbdWxDfrY
X-Received: by 2002:a17:906:55c9:: with SMTP id z9mr7766498ejp.276.1592399283544;
        Wed, 17 Jun 2020 06:08:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzqGwZAlp1/5617vMNvkO75RiBgN5ywDU37uIBjmwAxJX74lr3MvZAKptbotXpKIAHgsvXJ8Q==
X-Received: by 2002:a17:906:55c9:: with SMTP id z9mr7766472ejp.276.1592399283279;
        Wed, 17 Jun 2020 06:08:03 -0700 (PDT)
Received: from x1w.redhat.com (93.red-83-59-160.dynamicip.rima-tde.net. [83.59.160.93])
        by smtp.gmail.com with ESMTPSA id ce23sm13475432ejc.53.2020.06.17.06.08.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2020 06:08:02 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
        kvm@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>,
        Andrew Jones <drjones@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Haibo Xu <haibo.xu@linaro.org>
Subject: [PATCH] target/arm/kvm: Check supported feature per accelerator (not per vCPU)
Date:   Wed, 17 Jun 2020 15:08:00 +0200
Message-Id: <20200617130800.26355-1-philmd@redhat.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since commit d70c996df23f, when enabling the PMU we get:

  $ qemu-system-aarch64 -cpu host,pmu=on -M virt,accel=kvm,gic-version=3
  Segmentation fault (core dumped)

  Thread 1 "qemu-system-aar" received signal SIGSEGV, Segmentation fault.
  0x0000aaaaaae356d0 in kvm_ioctl (s=0x0, type=44547) at accel/kvm/kvm-all.c:2588
  2588        ret = ioctl(s->fd, type, arg);
  (gdb) bt
  #0  0x0000aaaaaae356d0 in kvm_ioctl (s=0x0, type=44547) at accel/kvm/kvm-all.c:2588
  #1  0x0000aaaaaae31568 in kvm_check_extension (s=0x0, extension=126) at accel/kvm/kvm-all.c:916
  #2  0x0000aaaaaafce254 in kvm_arm_pmu_supported (cpu=0xaaaaac214ab0) at target/arm/kvm.c:213
  #3  0x0000aaaaaafc0f94 in arm_set_pmu (obj=0xaaaaac214ab0, value=true, errp=0xffffffffe438) at target/arm/cpu.c:1111
  #4  0x0000aaaaab5533ac in property_set_bool (obj=0xaaaaac214ab0, v=0xaaaaac223a80, name=0xaaaaac11a970 "pmu", opaque=0xaaaaac222730, errp=0xffffffffe438) at qom/object.c:2170
  #5  0x0000aaaaab5512f0 in object_property_set (obj=0xaaaaac214ab0, v=0xaaaaac223a80, name=0xaaaaac11a970 "pmu", errp=0xffffffffe438) at qom/object.c:1328
  #6  0x0000aaaaab551e10 in object_property_parse (obj=0xaaaaac214ab0, string=0xaaaaac11b4c0 "on", name=0xaaaaac11a970 "pmu", errp=0xffffffffe438) at qom/object.c:1561
  #7  0x0000aaaaab54ee8c in object_apply_global_props (obj=0xaaaaac214ab0, props=0xaaaaac018e20, errp=0xaaaaabd6fd88 <error_fatal>) at qom/object.c:407
  #8  0x0000aaaaab1dd5a4 in qdev_prop_set_globals (dev=0xaaaaac214ab0) at hw/core/qdev-properties.c:1218
  #9  0x0000aaaaab1d9fac in device_post_init (obj=0xaaaaac214ab0) at hw/core/qdev.c:1050
  ...
  #15 0x0000aaaaab54f310 in object_initialize_with_type (obj=0xaaaaac214ab0, size=52208, type=0xaaaaabe237f0) at qom/object.c:512
  #16 0x0000aaaaab54fa24 in object_new_with_type (type=0xaaaaabe237f0) at qom/object.c:687
  #17 0x0000aaaaab54fa80 in object_new (typename=0xaaaaabe23970 "host-arm-cpu") at qom/object.c:702
  #18 0x0000aaaaaaf04a74 in machvirt_init (machine=0xaaaaac0a8550) at hw/arm/virt.c:1770
  #19 0x0000aaaaab1e8720 in machine_run_board_init (machine=0xaaaaac0a8550) at hw/core/machine.c:1138
  #20 0x0000aaaaaaf95394 in qemu_init (argc=5, argv=0xffffffffea58, envp=0xffffffffea88) at softmmu/vl.c:4348
  #21 0x0000aaaaaada3f74 in main (argc=<optimized out>, argv=<optimized out>, envp=<optimized out>) at softmmu/main.c:48

This is because in frame #2, cpu->kvm_state is still NULL
(the vCPU is not yet realized).

KVM has a hard requirement of all cores supporting the same
feature set. We only need to check if the accelerator supports
a feature, not each vCPU individually.

Fix by kvm_arm_<FEATURE>_supported() functions take a AccelState
argument (already realized/valid at this point) instead of a
CPUState argument.

Reported-by: Haibo Xu <haibo.xu@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 target/arm/kvm_arm.h | 25 +++++++++++++------------
 target/arm/cpu.c     |  2 +-
 target/arm/cpu64.c   | 10 +++++-----
 target/arm/kvm.c     |  4 ++--
 target/arm/kvm64.c   | 14 +++++---------
 5 files changed, 26 insertions(+), 29 deletions(-)

diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
index 48bf5e16d5..8209525f20 100644
--- a/target/arm/kvm_arm.h
+++ b/target/arm/kvm_arm.h
@@ -12,6 +12,7 @@
 #define QEMU_KVM_ARM_H
 
 #include "sysemu/kvm.h"
+#include "sysemu/accel.h"
 #include "exec/memory.h"
 #include "qemu/error-report.h"
 
@@ -269,29 +270,29 @@ void kvm_arm_add_vcpu_properties(Object *obj);
 
 /**
  * kvm_arm_aarch32_supported:
- * @cs: CPUState
+ * @as: AccelState
  *
- * Returns: true if the KVM VCPU can enable AArch32 mode
+ * Returns: true if the KVM accelerator can enable AArch32 mode
  * and false otherwise.
  */
-bool kvm_arm_aarch32_supported(CPUState *cs);
+bool kvm_arm_aarch32_supported(AccelState *as);
 
 /**
  * kvm_arm_pmu_supported:
- * @cs: CPUState
+ * @as: AccelState
  *
- * Returns: true if the KVM VCPU can enable its PMU
+ * Returns: true if the KVM accelerator can enable its PMU
  * and false otherwise.
  */
-bool kvm_arm_pmu_supported(CPUState *cs);
+bool kvm_arm_pmu_supported(AccelState *as);
 
 /**
  * kvm_arm_sve_supported:
- * @cs: CPUState
+ * @as: AccelState
  *
- * Returns true if the KVM VCPU can enable SVE and false otherwise.
+ * Returns true if the KVM accelerator can enable SVE and false otherwise.
  */
-bool kvm_arm_sve_supported(CPUState *cs);
+bool kvm_arm_sve_supported(AccelState *as);
 
 /**
  * kvm_arm_get_max_vm_ipa_size:
@@ -359,17 +360,17 @@ static inline void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu)
 
 static inline void kvm_arm_add_vcpu_properties(Object *obj) {}
 
-static inline bool kvm_arm_aarch32_supported(CPUState *cs)
+static inline bool kvm_arm_aarch32_supported(AccelState *as)
 {
     return false;
 }
 
-static inline bool kvm_arm_pmu_supported(CPUState *cs)
+static inline bool kvm_arm_pmu_supported(AccelState *as)
 {
     return false;
 }
 
-static inline bool kvm_arm_sve_supported(CPUState *cs)
+static inline bool kvm_arm_sve_supported(AccelState *as)
 {
     return false;
 }
diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index 5b7a36b5d7..29b314427c 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -1108,7 +1108,7 @@ static void arm_set_pmu(Object *obj, bool value, Error **errp)
     ARMCPU *cpu = ARM_CPU(obj);
 
     if (value) {
-        if (kvm_enabled() && !kvm_arm_pmu_supported(CPU(cpu))) {
+        if (kvm_enabled() && !kvm_arm_pmu_supported(current_accel())) {
             error_setg(errp, "'pmu' feature not supported by KVM on this host");
             return;
         }
diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
index 778cecc2e6..13835768ab 100644
--- a/target/arm/cpu64.c
+++ b/target/arm/cpu64.c
@@ -266,7 +266,7 @@ void arm_cpu_sve_finalize(ARMCPU *cpu, Error **errp)
 
     /* Collect the set of vector lengths supported by KVM. */
     bitmap_zero(kvm_supported, ARM_MAX_VQ);
-    if (kvm_enabled() && kvm_arm_sve_supported(CPU(cpu))) {
+    if (kvm_enabled() && kvm_arm_sve_supported(current_accel())) {
         kvm_arm_sve_get_vls(CPU(cpu), kvm_supported);
     } else if (kvm_enabled()) {
         assert(!cpu_isar_feature(aa64_sve, cpu));
@@ -473,7 +473,7 @@ static void cpu_max_set_sve_max_vq(Object *obj, Visitor *v, const char *name,
         return;
     }
 
-    if (kvm_enabled() && !kvm_arm_sve_supported(CPU(cpu))) {
+    if (kvm_enabled() && !kvm_arm_sve_supported(current_accel())) {
         error_setg(errp, "cannot set sve-max-vq");
         error_append_hint(errp, "SVE not supported by KVM on this host\n");
         return;
@@ -519,7 +519,7 @@ static void cpu_arm_set_sve_vq(Object *obj, Visitor *v, const char *name,
         return;
     }
 
-    if (value && kvm_enabled() && !kvm_arm_sve_supported(CPU(cpu))) {
+    if (value && kvm_enabled() && !kvm_arm_sve_supported(current_accel())) {
         error_setg(errp, "cannot enable %s", name);
         error_append_hint(errp, "SVE not supported by KVM on this host\n");
         return;
@@ -556,7 +556,7 @@ static void cpu_arm_set_sve(Object *obj, Visitor *v, const char *name,
         return;
     }
 
-    if (value && kvm_enabled() && !kvm_arm_sve_supported(CPU(cpu))) {
+    if (value && kvm_enabled() && !kvm_arm_sve_supported(current_accel())) {
         error_setg(errp, "'sve' feature not supported by KVM on this host");
         return;
     }
@@ -751,7 +751,7 @@ static void aarch64_cpu_set_aarch64(Object *obj, bool value, Error **errp)
      * uniform execution state like do_interrupt.
      */
     if (value == false) {
-        if (!kvm_enabled() || !kvm_arm_aarch32_supported(CPU(cpu))) {
+        if (!kvm_enabled() || !kvm_arm_aarch32_supported(current_accel())) {
             error_setg(errp, "'aarch64' feature cannot be disabled "
                              "unless KVM is enabled and 32-bit EL1 "
                              "is supported");
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index eef3bbd1cc..2247a96757 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -208,9 +208,9 @@ void kvm_arm_add_vcpu_properties(Object *obj)
     }
 }
 
-bool kvm_arm_pmu_supported(CPUState *cpu)
+bool kvm_arm_pmu_supported(AccelState *as)
 {
-    return kvm_check_extension(cpu->kvm_state, KVM_CAP_ARM_PMU_V3);
+    return kvm_check_extension(KVM_STATE(as), KVM_CAP_ARM_PMU_V3);
 }
 
 int kvm_arm_get_max_vm_ipa_size(MachineState *ms)
diff --git a/target/arm/kvm64.c b/target/arm/kvm64.c
index f09ed9f4df..ae4e37ce78 100644
--- a/target/arm/kvm64.c
+++ b/target/arm/kvm64.c
@@ -652,18 +652,14 @@ bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
     return true;
 }
 
-bool kvm_arm_aarch32_supported(CPUState *cpu)
+bool kvm_arm_aarch32_supported(AccelState *as)
 {
-    KVMState *s = KVM_STATE(current_accel());
-
-    return kvm_check_extension(s, KVM_CAP_ARM_EL1_32BIT);
+    return kvm_check_extension(KVM_STATE(as), KVM_CAP_ARM_EL1_32BIT);
 }
 
-bool kvm_arm_sve_supported(CPUState *cpu)
+bool kvm_arm_sve_supported(AccelState *as)
 {
-    KVMState *s = KVM_STATE(current_accel());
-
-    return kvm_check_extension(s, KVM_CAP_ARM_SVE);
+    return kvm_check_extension(KVM_STATE(as), KVM_CAP_ARM_SVE);
 }
 
 QEMU_BUILD_BUG_ON(KVM_ARM64_SVE_VQ_MIN != 1);
@@ -798,7 +794,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
         env->features &= ~(1ULL << ARM_FEATURE_PMU);
     }
     if (cpu_isar_feature(aa64_sve, cpu)) {
-        assert(kvm_arm_sve_supported(cs));
+        assert(kvm_arm_sve_supported(ACCEL(cs->kvm_state)));
         cpu->kvm_init_features[0] |= 1 << KVM_ARM_VCPU_SVE;
     }
 
-- 
2.21.3

