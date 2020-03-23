Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF1CE18EE5C
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 04:15:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbgCWDOl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 Mar 2020 23:14:41 -0400
Received: from mga11.intel.com ([192.55.52.93]:48945 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726979AbgCWDOl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 Mar 2020 23:14:41 -0400
IronPort-SDR: nR0e1RPjKV7of4bnnfQqMSE+M0HdX+E54ZY0Z7uOoQ8bE+GTVmvXXBzq4TU2zrPYDczozlOT7a
 aQ88ds83WkHg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2020 20:14:40 -0700
IronPort-SDR: pRX5EL3s7jKlUC0DyiWxWVCif4V9kHdzoAikBRqVPuPVWdDrntlbDIQIGRJvr185g3LRvS86fT
 K8iiw9uLqCUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,294,1580803200"; 
   d="scan'208";a="292453683"
Received: from lxy-clx-4s.sh.intel.com ([10.239.43.161])
  by FMSMGA003.fm.intel.com with ESMTP; 22 Mar 2020 20:14:38 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>
Cc:     kvm@vger.kernel.org, qemu-devel@nongnu.org,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH 1/3] target/i386: Rename CORE_CAPABILITY to CORE_CAPABILITIES
Date:   Mon, 23 Mar 2020 10:56:56 +0800
Message-Id: <20200323025658.4540-2-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200323025658.4540-1-xiaoyao.li@intel.com>
References: <20200323025658.4540-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Intel SDM updates the name of MSR CORE_CAPABILITY to CORE_CAPABILITIES,
so updating it QEMU.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/cpu.c | 12 ++++++------
 target/i386/cpu.h |  6 +++---
 target/i386/kvm.c |  6 +++---
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 34b511f078e5..1de7f3cd533e 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1216,7 +1216,7 @@ static FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
             .index = MSR_IA32_ARCH_CAPABILITIES,
         },
     },
-    [FEAT_CORE_CAPABILITY] = {
+    [FEAT_CORE_CAPABILITIES] = {
         .type = MSR_FEATURE_WORD,
         .feat_names = {
             NULL, NULL, NULL, NULL,
@@ -1229,7 +1229,7 @@ static FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
             NULL, NULL, NULL, NULL,
         },
         .msr = {
-            .index = MSR_IA32_CORE_CAPABILITY,
+            .index = MSR_IA32_CORE_CAPABILITIES,
         },
     },
 
@@ -1406,8 +1406,8 @@ static FeatureDep feature_dependencies[] = {
         .to = { FEAT_ARCH_CAPABILITIES,     ~0ull },
     },
     {
-        .from = { FEAT_7_0_EDX,             CPUID_7_0_EDX_CORE_CAPABILITY },
-        .to = { FEAT_CORE_CAPABILITY,       ~0ull },
+        .from = { FEAT_7_0_EDX,             CPUID_7_0_EDX_CORE_CAPABILITIES },
+        .to = { FEAT_CORE_CAPABILITIES,     ~0ull },
     },
     {
         .from = { FEAT_1_ECX,               CPUID_EXT_VMX },
@@ -3709,8 +3709,8 @@ static X86CPUDefinition builtin_x86_defs[] = {
         .features[FEAT_7_0_EDX] =
             CPUID_7_0_EDX_SPEC_CTRL |
             CPUID_7_0_EDX_ARCH_CAPABILITIES | CPUID_7_0_EDX_SPEC_CTRL_SSBD |
-            CPUID_7_0_EDX_CORE_CAPABILITY,
-        .features[FEAT_CORE_CAPABILITY] =
+            CPUID_7_0_EDX_CORE_CAPABILITIES,
+        .features[FEAT_CORE_CAPABILITIES] =
             MSR_CORE_CAP_SPLIT_LOCK_DETECT,
         /*
          * Missing: XSAVES (not supported by some Linux versions,
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 60d797d5941f..f6c54412ba5e 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -349,7 +349,7 @@ typedef enum X86Seg {
 #define MSR_VIRT_SSBD                   0xc001011f
 #define MSR_IA32_PRED_CMD               0x49
 #define MSR_IA32_UCODE_REV              0x8b
-#define MSR_IA32_CORE_CAPABILITY        0xcf
+#define MSR_IA32_CORE_CAPABILITIES      0xcf
 
 #define MSR_IA32_ARCH_CAPABILITIES      0x10a
 #define ARCH_CAP_TSX_CTRL_MSR		(1<<7)
@@ -526,7 +526,7 @@ typedef enum FeatureWord {
     FEAT_XSAVE_COMP_LO, /* CPUID[EAX=0xd,ECX=0].EAX */
     FEAT_XSAVE_COMP_HI, /* CPUID[EAX=0xd,ECX=0].EDX */
     FEAT_ARCH_CAPABILITIES,
-    FEAT_CORE_CAPABILITY,
+    FEAT_CORE_CAPABILITIES,
     FEAT_VMX_PROCBASED_CTLS,
     FEAT_VMX_SECONDARY_CTLS,
     FEAT_VMX_PINBASED_CTLS,
@@ -777,7 +777,7 @@ typedef uint64_t FeatureWordArray[FEATURE_WORDS];
 /* Arch Capabilities */
 #define CPUID_7_0_EDX_ARCH_CAPABILITIES (1U << 29)
 /* Core Capability */
-#define CPUID_7_0_EDX_CORE_CAPABILITY   (1U << 30)
+#define CPUID_7_0_EDX_CORE_CAPABILITIES (1U << 30)
 /* Speculative Store Bypass Disable */
 #define CPUID_7_0_EDX_SPEC_CTRL_SSBD    (1U << 31)
 
diff --git a/target/i386/kvm.c b/target/i386/kvm.c
index 69eb43d796e6..6888cb7caeae 100644
--- a/target/i386/kvm.c
+++ b/target/i386/kvm.c
@@ -2051,7 +2051,7 @@ static int kvm_get_supported_msrs(KVMState *s)
             case MSR_IA32_ARCH_CAPABILITIES:
                 has_msr_arch_capabs = true;
                 break;
-            case MSR_IA32_CORE_CAPABILITY:
+            case MSR_IA32_CORE_CAPABILITIES:
                 has_msr_core_capabs = true;
                 break;
             case MSR_IA32_VMX_VMFUNC:
@@ -2696,8 +2696,8 @@ static void kvm_init_msrs(X86CPU *cpu)
     }
 
     if (has_msr_core_capabs) {
-        kvm_msr_entry_add(cpu, MSR_IA32_CORE_CAPABILITY,
-                          env->features[FEAT_CORE_CAPABILITY]);
+        kvm_msr_entry_add(cpu, MSR_IA32_CORE_CAPABILITIES,
+                          env->features[FEAT_CORE_CAPABILITIES]);
     }
 
     if (has_msr_ucode_rev) {
-- 
2.20.1

