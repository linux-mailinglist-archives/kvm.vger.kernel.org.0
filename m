Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD2A43BBB7D
	for <lists+kvm@lfdr.de>; Mon,  5 Jul 2021 12:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbhGEKtW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jul 2021 06:49:22 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:49197 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231199AbhGEKtW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 5 Jul 2021 06:49:22 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailforward.nyi.internal (Postfix) with ESMTP id 23ED719409BF;
        Mon,  5 Jul 2021 06:46:45 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 05 Jul 2021 06:46:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=3ngrxv/e5H1HRwO7HipjFf1e4EewKqhfmFJcIin+TD4=; b=mMxdzhUZ
        6Ar9JAgg0Z380biQqJNlFD1YrKwyvwIjjDajDkk3btX3W5oiudh1kVGvZl+yCVly
        uN6ZcItuXR4ypPVOXvzi0YNGkEG2dO+7HJb6aq40EEL0jP2GdtsWBOoCKN/jlli0
        jGWNtedDxT4WqqCD4u7VzQ5D+s6nN6wWQFt9Pylz7r++VVDnLtL++p77o0QJOuWd
        sgtkAQeP0aSHHF2sCcerouu4vNFVy+IH3BuWNrSg85uzuR4SKaLmgaqtPUyNKLi2
        nTO5hdPRDgwS/ssWFqTrKXhnXoKx7/7/xFdbDSokYp6GLbHzonfkFgt/DW14jOBD
        rrucHzD2ERHI3A==
X-ME-Sender: <xms:FePiYFdv-Jx5pKH_jJQ962FThayL7Kug244qu550wEA_Qf7_-4UJzQ>
    <xme:FePiYDOu-Wc7IWn6bmIMgdwHJH1kYMS2uizqbVc8BCEuFpM0w0HbjZ1QULqvosD_5
    5G6URC-hnr1rPiQm4M>
X-ME-Received: <xmr:FePiYOhVNWDfK3HNesbrnp3tLjiZlG4j24RJOfECBbtID8qHf0SplcFnazvNaND9SlVI2c7stdX0Jo2wLTGkEQJU6OjHnBxIAaHDvEoCzi8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeejgedgfeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeffrghvihgu
    ucfgughmohhnughsohhnuceouggrvhhiugdrvggumhhonhgushhonhesohhrrggtlhgvrd
    gtohhmqeenucggtffrrghtthgvrhhnpedufeetjefgfefhtdejhfehtdfftefhteekhefg
    leehfffhiefhgeelgfejtdehkeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmh
    epmhgrihhlfhhrohhmpegurghvihgurdgvughmohhnughsohhnsehorhgrtghlvgdrtgho
    mh
X-ME-Proxy: <xmx:FePiYO9vp4g9CVLYsswC0R7lrhUbGLCt9PJmRF4CidpRlbkz2nOOjw>
    <xmx:FePiYBsnc0x7YIwsWcMOViP-GT-3Eu2pESrKLXLTJwqvW4MOhFSbpQ>
    <xmx:FePiYNGE9Pl4ltSZiDFlE7mjULbKATAftA_R4Ipp5B7RpQ8QZnxOpg>
    <xmx:FePiYFTi-pn0Hj-X-maAvKtw1CCHTvT0qo6YZSmD-IBwnHrtYmotkQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 5 Jul 2021 06:46:43 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id 035c34ad;
        Mon, 5 Jul 2021 10:46:33 +0000 (UTC)
From:   David Edmondson <david.edmondson@oracle.com>
To:     qemu-devel@nongnu.org
Cc:     Richard Henderson <richard.henderson@linaro.org>,
        Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, babu.moger@amd.com,
        Cameron Esfahani <dirty@apple.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        David Edmondson <david.edmondson@oracle.com>
Subject: [RFC PATCH 7/8] target/i386: Populate x86_ext_save_areas offsets using cpuid where possible
Date:   Mon,  5 Jul 2021 11:46:31 +0100
Message-Id: <20210705104632.2902400-8-david.edmondson@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705104632.2902400-1-david.edmondson@oracle.com>
References: <20210705104632.2902400-1-david.edmondson@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rather than relying on the X86XSaveArea structure definition,
determine the offset of XSAVE state areas using CPUID leaf 0xd where
possible (KVM and HVF).

Signed-off-by: David Edmondson <david.edmondson@oracle.com>
---
 target/i386/cpu.c         | 13 +------------
 target/i386/cpu.h         |  2 +-
 target/i386/hvf/hvf-cpu.c | 34 ++++++++++++++++++++++++++++++++++
 target/i386/kvm/kvm-cpu.c | 36 ++++++++++++++++++++++++++++++++++++
 target/i386/tcg/tcg-cpu.c | 20 ++++++++++++++++++++
 5 files changed, 92 insertions(+), 13 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 13caa0de50..5f595a0d7e 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1304,48 +1304,37 @@ static const X86RegisterInfo32 x86_reg_info_32[CPU_NB_REGS32] = {
 };
 #undef REGISTER
 
-const ExtSaveArea x86_ext_save_areas[XSAVE_STATE_AREA_COUNT] = {
+ExtSaveArea x86_ext_save_areas[XSAVE_STATE_AREA_COUNT] = {
     [XSTATE_FP_BIT] = {
         /* x87 FP state component is always enabled if XSAVE is supported */
         .feature = FEAT_1_ECX, .bits = CPUID_EXT_XSAVE,
-        /* x87 state is in the legacy region of the XSAVE area */
-        .offset = 0,
         .size = sizeof(X86LegacyXSaveArea) + sizeof(X86XSaveHeader),
     },
     [XSTATE_SSE_BIT] = {
         /* SSE state component is always enabled if XSAVE is supported */
         .feature = FEAT_1_ECX, .bits = CPUID_EXT_XSAVE,
-        /* SSE state is in the legacy region of the XSAVE area */
-        .offset = 0,
         .size = sizeof(X86LegacyXSaveArea) + sizeof(X86XSaveHeader),
     },
     [XSTATE_YMM_BIT] =
           { .feature = FEAT_1_ECX, .bits = CPUID_EXT_AVX,
-            .offset = offsetof(X86XSaveArea, avx_state),
             .size = sizeof(XSaveAVX) },
     [XSTATE_BNDREGS_BIT] =
           { .feature = FEAT_7_0_EBX, .bits = CPUID_7_0_EBX_MPX,
-            .offset = offsetof(X86XSaveArea, bndreg_state),
             .size = sizeof(XSaveBNDREG)  },
     [XSTATE_BNDCSR_BIT] =
           { .feature = FEAT_7_0_EBX, .bits = CPUID_7_0_EBX_MPX,
-            .offset = offsetof(X86XSaveArea, bndcsr_state),
             .size = sizeof(XSaveBNDCSR)  },
     [XSTATE_OPMASK_BIT] =
           { .feature = FEAT_7_0_EBX, .bits = CPUID_7_0_EBX_AVX512F,
-            .offset = offsetof(X86XSaveArea, opmask_state),
             .size = sizeof(XSaveOpmask) },
     [XSTATE_ZMM_Hi256_BIT] =
           { .feature = FEAT_7_0_EBX, .bits = CPUID_7_0_EBX_AVX512F,
-            .offset = offsetof(X86XSaveArea, zmm_hi256_state),
             .size = sizeof(XSaveZMM_Hi256) },
     [XSTATE_Hi16_ZMM_BIT] =
           { .feature = FEAT_7_0_EBX, .bits = CPUID_7_0_EBX_AVX512F,
-            .offset = offsetof(X86XSaveArea, hi16_zmm_state),
             .size = sizeof(XSaveHi16_ZMM) },
     [XSTATE_PKRU_BIT] =
           { .feature = FEAT_7_0_ECX, .bits = CPUID_7_0_ECX_PKU,
-            .offset = offsetof(X86XSaveArea, pkru_state),
             .size = sizeof(XSavePKRU) },
 };
 
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index c9c0a34330..96b672f8bd 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -1377,7 +1377,7 @@ typedef struct ExtSaveArea {
 
 #define XSAVE_STATE_AREA_COUNT (XSTATE_PKRU_BIT + 1)
 
-extern const ExtSaveArea x86_ext_save_areas[XSAVE_STATE_AREA_COUNT];
+extern ExtSaveArea x86_ext_save_areas[XSAVE_STATE_AREA_COUNT];
 
 typedef enum TPRAccess {
     TPR_ACCESS_READ,
diff --git a/target/i386/hvf/hvf-cpu.c b/target/i386/hvf/hvf-cpu.c
index 8fbc423888..3c7c44698f 100644
--- a/target/i386/hvf/hvf-cpu.c
+++ b/target/i386/hvf/hvf-cpu.c
@@ -30,6 +30,38 @@ static void hvf_cpu_max_instance_init(X86CPU *cpu)
         hvf_get_supported_cpuid(0xC0000000, 0, R_EAX);
 }
 
+static void hvf_cpu_xsave_init(void)
+{
+    int i;
+
+    /*
+     * The allocated storage must be large enough for all of the
+     * possible XSAVE state components.
+     */
+    assert(hvf_get_supported_cpuid(0xd, 0, R_ECX) <= 4096);
+
+    /* x87 state is in the legacy region of the XSAVE area. */
+    x86_ext_save_areas[XSTATE_FP_BIT].offset = 0;
+    /* SSE state is in the legacy region of the XSAVE area. */
+    x86_ext_save_areas[XSTATE_SSE_BIT].offset = 0;
+
+    for (i = XSTATE_SSE_BIT + 1; i < XSAVE_STATE_AREA_COUNT; i++) {
+        ExtSaveArea *esa = &x86_ext_save_areas[i];
+
+        if (esa->size) {
+            int sz = hvf_get_supported_cpuid(0xd, i, R_EAX);
+
+            if (sz != 0) {
+                assert(esa->size == sz);
+
+                esa->offset = hvf_get_supported_cpuid(0xd, i, R_EBX);
+                fprintf(stderr, "%s: state area %d: offset 0x%x, size 0x%x\n",
+                        __func__, i, esa->offset, esa->size);
+            }
+        }
+    }
+}
+
 static void hvf_cpu_instance_init(CPUState *cs)
 {
     X86CPU *cpu = X86_CPU(cs);
@@ -42,6 +74,8 @@ static void hvf_cpu_instance_init(CPUState *cs)
     if (cpu->max_features) {
         hvf_cpu_max_instance_init(cpu);
     }
+
+    hvf_cpu_xsave_init();
 }
 
 static void hvf_cpu_accel_class_init(ObjectClass *oc, void *data)
diff --git a/target/i386/kvm/kvm-cpu.c b/target/i386/kvm/kvm-cpu.c
index 00369c2000..f474cc5b83 100644
--- a/target/i386/kvm/kvm-cpu.c
+++ b/target/i386/kvm/kvm-cpu.c
@@ -122,6 +122,40 @@ static void kvm_cpu_max_instance_init(X86CPU *cpu)
         kvm_arch_get_supported_cpuid(s, 0xC0000000, 0, R_EAX);
 }
 
+static void kvm_cpu_xsave_init(void)
+{
+    KVMState *s = kvm_state;
+    int i;
+
+    /*
+     * The allocated storage must be large enough for all of the
+     * possible XSAVE state components.
+     */
+    assert(sizeof(struct kvm_xsave) >=
+           kvm_arch_get_supported_cpuid(s, 0xd, 0, R_ECX));
+
+    /* x87 state is in the legacy region of the XSAVE area. */
+    x86_ext_save_areas[XSTATE_FP_BIT].offset = 0;
+    /* SSE state is in the legacy region of the XSAVE area. */
+    x86_ext_save_areas[XSTATE_SSE_BIT].offset = 0;
+
+    for (i = XSTATE_SSE_BIT + 1; i < XSAVE_STATE_AREA_COUNT; i++) {
+        ExtSaveArea *esa = &x86_ext_save_areas[i];
+
+        if (esa->size) {
+            int sz = kvm_arch_get_supported_cpuid(s, 0xd, i, R_EAX);
+
+            if (sz != 0) {
+                assert(esa->size == sz);
+
+                esa->offset = kvm_arch_get_supported_cpuid(s, 0xd, i, R_EBX);
+                fprintf(stderr, "%s: state area %d: offset 0x%x, size 0x%x\n",
+                        __func__, i, esa->offset, esa->size);
+            }
+        }
+    }
+}
+
 static void kvm_cpu_instance_init(CPUState *cs)
 {
     X86CPU *cpu = X86_CPU(cs);
@@ -141,6 +175,8 @@ static void kvm_cpu_instance_init(CPUState *cs)
     if (cpu->max_features) {
         kvm_cpu_max_instance_init(cpu);
     }
+
+    kvm_cpu_xsave_init();
 }
 
 static void kvm_cpu_accel_class_init(ObjectClass *oc, void *data)
diff --git a/target/i386/tcg/tcg-cpu.c b/target/i386/tcg/tcg-cpu.c
index 014ebea2f6..e96ec9bbcc 100644
--- a/target/i386/tcg/tcg-cpu.c
+++ b/target/i386/tcg/tcg-cpu.c
@@ -80,6 +80,24 @@ static void tcg_cpu_class_init(CPUClass *cc)
     cc->init_accel_cpu = tcg_cpu_init_ops;
 }
 
+static void tcg_cpu_xsave_init(void)
+{
+#define XO(bit, field) \
+    x86_ext_save_areas[bit].offset = offsetof(X86XSaveArea, field);
+
+    XO(XSTATE_FP_BIT, legacy);
+    XO(XSTATE_SSE_BIT, legacy);
+    XO(XSTATE_YMM_BIT, avx_state);
+    XO(XSTATE_BNDREGS_BIT, bndreg_state);
+    XO(XSTATE_BNDCSR_BIT, bndcsr_state);
+    XO(XSTATE_OPMASK_BIT, opmask_state);
+    XO(XSTATE_ZMM_Hi256_BIT, zmm_hi256_state);
+    XO(XSTATE_Hi16_ZMM_BIT, hi16_zmm_state);
+    XO(XSTATE_PKRU_BIT, pkru_state);
+
+#undef XO
+}
+
 /*
  * TCG-specific defaults that override all CPU models when using TCG
  */
@@ -93,6 +111,8 @@ static void tcg_cpu_instance_init(CPUState *cs)
     X86CPU *cpu = X86_CPU(cs);
     /* Special cases not set in the X86CPUDefinition structs: */
     x86_cpu_apply_props(cpu, tcg_default_props);
+
+    tcg_cpu_xsave_init();
 }
 
 static void tcg_cpu_accel_class_init(ObjectClass *oc, void *data)
-- 
2.30.2

