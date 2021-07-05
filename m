Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18AE53BBB7B
	for <lists+kvm@lfdr.de>; Mon,  5 Jul 2021 12:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231222AbhGEKtV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jul 2021 06:49:21 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:59627 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231202AbhGEKtU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 5 Jul 2021 06:49:20 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id D6E5E1940A24;
        Mon,  5 Jul 2021 06:46:43 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 05 Jul 2021 06:46:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=zn9zUGz57ivQbtIoDzG6NwEdWAVLVWzxpCG0kNQ8R9Y=; b=whhAGXfQ
        uHYstsMicIYNU+NXuUCVrYe7QZcmblGHhbPIyrpO/+rJB+V47yzm31kiZ2radUQ9
        SfOA73gQp7H0dXTzOZta2s4g/zuZ8JyEMvEZFTsT5TT9wTrOwqJINksp33dKJKCt
        zZ3F4LXYarFelCjF+Ef/c2uI8NJSIGXohejuBaGNvpEO0Ep4wLfZ/e9HfRfK8IPI
        xITKltiKx4Qkxs1IIFr43PcJHowfT6kf5ZI1OQQAWbLS068CVLKXw5IkZ/XmZOSl
        1eRJD105FCKWwsvxOaKb92TpiBdQ9jfJRKUh5V80F5FQjWdEQ4h4/g2B41/3Qpdo
        VFp3usuzWNMe6A==
X-ME-Sender: <xms:EuPiYMJJD5eFAjLxoMqwNWcigHGjRdVl2w9SbNr-PC7SRVlooDd-8A>
    <xme:EuPiYMLPlJCRoOyKNMoQiRuUU4wCqN5pR4XDZy0jQe5E0uv8t4pM_rQ_4QlgUf2aS
    4tRs0OYfQdogL_b640>
X-ME-Received: <xmr:EuPiYMsZPfxJp7vC81o5Fji5TwTc-1mfJFDFPyCcdqyhjbgRP_IL1tIWpV-EE-Y2KCntHVM0Fr2I0frwcfES_v8TrSnz8iq46dOJhahY6rg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeejgedgfeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeffrghvihgu
    ucfgughmohhnughsohhnuceouggrvhhiugdrvggumhhonhgushhonhesohhrrggtlhgvrd
    gtohhmqeenucggtffrrghtthgvrhhnpedufeetjefgfefhtdejhfehtdfftefhteekhefg
    leehfffhiefhgeelgfejtdehkeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpegurghvihgurdgvughmohhnughsohhnsehorhgrtghlvgdrtgho
    mh
X-ME-Proxy: <xmx:EuPiYJbJN2HZD0111XnTyhuymNfnKEVB-Y1ivBV2J9flAzRAk5fg9A>
    <xmx:EuPiYDZdaapCsn4Kh65r2BNYohkvpK5_FkwdhJ9qMCF3WMGpJUXs6g>
    <xmx:EuPiYFDQSXv_qtJpEOY4uYn-UH9XmW4P_X2nU9jfKBuiKQ91Ope00Q>
    <xmx:E-PiYJsZddk-YR7qPI8gsarAoY3Dqr-0pwnXJmjYWsTrhSK5SeDmKg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 5 Jul 2021 06:46:41 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id 22e66db2;
        Mon, 5 Jul 2021 10:46:32 +0000 (UTC)
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
Subject: [RFC PATCH 4/8] target/i386: Pass buffer and length to XSAVE helper
Date:   Mon,  5 Jul 2021 11:46:28 +0100
Message-Id: <20210705104632.2902400-5-david.edmondson@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705104632.2902400-1-david.edmondson@oracle.com>
References: <20210705104632.2902400-1-david.edmondson@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In preparation for removing assumptions about XSAVE area offsets, pass
a buffer pointer and buffer length to the XSAVE helper functions.

Signed-off-by: David Edmondson <david.edmondson@oracle.com>
---
 target/i386/cpu.h          |  5 +++--
 target/i386/hvf/hvf.c      |  3 ++-
 target/i386/hvf/x86hvf.c   | 19 ++++++++-----------
 target/i386/kvm/kvm.c      | 13 +++++++------
 target/i386/xsave_helper.c | 17 +++++++++--------
 5 files changed, 29 insertions(+), 28 deletions(-)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 92f9ca264c..ada2941c6e 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -1667,6 +1667,7 @@ typedef struct CPUX86State {
     uint64_t apic_bus_freq;
 #if defined(CONFIG_KVM) || defined(CONFIG_HVF)
     void *xsave_buf;
+    uint32_t xsave_buf_len;
 #endif
 #if defined(CONFIG_KVM)
     struct kvm_nested_state *nested_state;
@@ -2227,8 +2228,8 @@ void x86_cpu_dump_local_apic_state(CPUState *cs, int flags);
 /* cpu.c */
 bool cpu_is_bsp(X86CPU *cpu);
 
-void x86_cpu_xrstor_all_areas(X86CPU *cpu, const X86XSaveArea *buf);
-void x86_cpu_xsave_all_areas(X86CPU *cpu, X86XSaveArea *buf);
+void x86_cpu_xrstor_all_areas(X86CPU *cpu, const void *buf, uint32_t buflen);
+void x86_cpu_xsave_all_areas(X86CPU *cpu, void *buf, uint32_t buflen);
 void x86_update_hflags(CPUX86State* env);
 
 static inline bool hyperv_feat_enabled(X86CPU *cpu, int feat)
diff --git a/target/i386/hvf/hvf.c b/target/i386/hvf/hvf.c
index 346dbcc26f..e62e8df028 100644
--- a/target/i386/hvf/hvf.c
+++ b/target/i386/hvf/hvf.c
@@ -267,7 +267,8 @@ int hvf_arch_init_vcpu(CPUState *cpu)
     wvmcs(cpu->hvf->fd, VMCS_TPR_THRESHOLD, 0);
 
     x86cpu = X86_CPU(cpu);
-    x86cpu->env.xsave_buf = qemu_memalign(4096, 4096);
+    x86cpu->env.xsave_buf_len = 4096;
+    x86cpu->env.xsave_buf = qemu_memalign(4096, x86cpu->env.xsave_buf_len);
 
     hv_vcpu_enable_native_msr(cpu->hvf->fd, MSR_STAR, 1);
     hv_vcpu_enable_native_msr(cpu->hvf->fd, MSR_LSTAR, 1);
diff --git a/target/i386/hvf/x86hvf.c b/target/i386/hvf/x86hvf.c
index 2ced2c2478..05ec1bddc4 100644
--- a/target/i386/hvf/x86hvf.c
+++ b/target/i386/hvf/x86hvf.c
@@ -73,14 +73,12 @@ void hvf_get_segment(SegmentCache *qseg, struct vmx_segment *vmx_seg)
 
 void hvf_put_xsave(CPUState *cpu_state)
 {
+    void *xsave = X86_CPU(cpu_state)->env.xsave_buf;
+    uint32_t xsave_len = X86_CPU(cpu_state)->env.xsave_buf_len;
 
-    struct X86XSaveArea *xsave;
+    x86_cpu_xsave_all_areas(X86_CPU(cpu_state), xsave, xsave_len);
 
-    xsave = X86_CPU(cpu_state)->env.xsave_buf;
-
-    x86_cpu_xsave_all_areas(X86_CPU(cpu_state), xsave);
-
-    if (hv_vcpu_write_fpstate(cpu_state->hvf->fd, (void*)xsave, 4096)) {
+    if (hv_vcpu_write_fpstate(cpu_state->hvf->fd, xsave, xsave_len)) {
         abort();
     }
 }
@@ -158,15 +156,14 @@ void hvf_put_msrs(CPUState *cpu_state)
 
 void hvf_get_xsave(CPUState *cpu_state)
 {
-    struct X86XSaveArea *xsave;
-
-    xsave = X86_CPU(cpu_state)->env.xsave_buf;
+    void *xsave = X86_CPU(cpu_state)->env.xsave_buf;
+    uint32_t xsave_len = X86_CPU(cpu_state)->env.xsave_buf_len;
 
-    if (hv_vcpu_read_fpstate(cpu_state->hvf->fd, (void*)xsave, 4096)) {
+    if (hv_vcpu_read_fpstate(cpu_state->hvf->fd, xsave, xsave_len)) {
         abort();
     }
 
-    x86_cpu_xrstor_all_areas(X86_CPU(cpu_state), xsave);
+    x86_cpu_xrstor_all_areas(X86_CPU(cpu_state), xsave, xsave_len);
 }
 
 void hvf_get_segments(CPUState *cpu_state)
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 3ab1d71775..41b0764ab7 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -1888,8 +1888,9 @@ int kvm_arch_init_vcpu(CPUState *cs)
     }
 
     if (has_xsave) {
-        env->xsave_buf = qemu_memalign(4096, sizeof(struct kvm_xsave));
-        memset(env->xsave_buf, 0, sizeof(struct kvm_xsave));
+        env->xsave_buf_len = sizeof(struct kvm_xsave);
+        env->xsave_buf = qemu_memalign(4096, env->xsave_buf_len);
+        memset(env->xsave_buf, 0, env->xsave_buf_len);
     }
 
     max_nested_state_len = kvm_max_nested_state_length();
@@ -2469,12 +2470,12 @@ static int kvm_put_fpu(X86CPU *cpu)
 static int kvm_put_xsave(X86CPU *cpu)
 {
     CPUX86State *env = &cpu->env;
-    X86XSaveArea *xsave = env->xsave_buf;
+    void *xsave = env->xsave_buf;
 
     if (!has_xsave) {
         return kvm_put_fpu(cpu);
     }
-    x86_cpu_xsave_all_areas(cpu, xsave);
+    x86_cpu_xsave_all_areas(cpu, xsave, env->xsave_buf_len);
 
     return kvm_vcpu_ioctl(CPU(cpu), KVM_SET_XSAVE, xsave);
 }
@@ -3119,7 +3120,7 @@ static int kvm_get_fpu(X86CPU *cpu)
 static int kvm_get_xsave(X86CPU *cpu)
 {
     CPUX86State *env = &cpu->env;
-    X86XSaveArea *xsave = env->xsave_buf;
+    void *xsave = env->xsave_buf;
     int ret;
 
     if (!has_xsave) {
@@ -3130,7 +3131,7 @@ static int kvm_get_xsave(X86CPU *cpu)
     if (ret < 0) {
         return ret;
     }
-    x86_cpu_xrstor_all_areas(cpu, xsave);
+    x86_cpu_xrstor_all_areas(cpu, xsave, env->xsave_buf_len);
 
     return 0;
 }
diff --git a/target/i386/xsave_helper.c b/target/i386/xsave_helper.c
index 818115e7d2..b16c6ac0fe 100644
--- a/target/i386/xsave_helper.c
+++ b/target/i386/xsave_helper.c
@@ -6,14 +6,16 @@
 
 #include "cpu.h"
 
-void x86_cpu_xsave_all_areas(X86CPU *cpu, X86XSaveArea *buf)
+void x86_cpu_xsave_all_areas(X86CPU *cpu, void *buf, uint32_t buflen)
 {
     CPUX86State *env = &cpu->env;
     X86XSaveArea *xsave = buf;
-
     uint16_t cwd, swd, twd;
     int i;
-    memset(xsave, 0, sizeof(X86XSaveArea));
+
+    assert(buflen >= sizeof(*xsave));
+
+    memset(xsave, 0, buflen);
     twd = 0;
     swd = env->fpus & ~(7 << 11);
     swd |= (env->fpstt & 7) << 11;
@@ -56,17 +58,17 @@ void x86_cpu_xsave_all_areas(X86CPU *cpu, X86XSaveArea *buf)
             16 * sizeof env->xmm_regs[16]);
     memcpy(&xsave->pkru_state, &env->pkru, sizeof env->pkru);
 #endif
-
 }
 
-void x86_cpu_xrstor_all_areas(X86CPU *cpu, const X86XSaveArea *buf)
+void x86_cpu_xrstor_all_areas(X86CPU *cpu, const void *buf, uint32_t buflen)
 {
-
     CPUX86State *env = &cpu->env;
     const X86XSaveArea *xsave = buf;
-
     int i;
     uint16_t cwd, swd, twd;
+
+    assert(buflen >= sizeof(*xsave));
+
     cwd = xsave->legacy.fcw;
     swd = xsave->legacy.fsw;
     twd = xsave->legacy.ftw;
@@ -108,5 +110,4 @@ void x86_cpu_xrstor_all_areas(X86CPU *cpu, const X86XSaveArea *buf)
            16 * sizeof env->xmm_regs[16]);
     memcpy(&env->pkru, &xsave->pkru_state, sizeof env->pkru);
 #endif
-
 }
-- 
2.30.2

