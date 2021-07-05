Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 218EE3BBB7E
	for <lists+kvm@lfdr.de>; Mon,  5 Jul 2021 12:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231166AbhGEKtX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jul 2021 06:49:23 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:51877 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231190AbhGEKtW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 5 Jul 2021 06:49:22 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 9A6C51940A20;
        Mon,  5 Jul 2021 06:46:45 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 05 Jul 2021 06:46:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=KJRqPn/DOPHLDjX4HZi4nttSvHg/cdDqRBzhFwFLuKU=; b=RbwHLDhV
        ItAsp1LXS34jtM5rdp0ZcZC+e/OuKgMzM+kayTRZ+BamC77sprg2W6psAQRxVNwy
        Yf+7TUwFrh0/M5l6HpxZnvo4N5nK0tHC/1ufIFXF3oXSvUHEvKlRFD16r8Bcmx8f
        IgO4SuA7R0J1CTtcxIbPqu5dBTJnDn1AZl3TvFEE18Xkk+u2+bnl1jnw3UQgqeRY
        2P/eg+MU6ek6vwvPU6VbaUJxtgKO128WaXgtQOIz2PKGXRG2I2ruvvlHFv/MJEgZ
        4C6Z5ZcwApuyicA6sa+ZXiSHyReQ+H5kCh1QQKLnPmNHP/JTwVLfnmieao4LOCpZ
        ZFEAuOv1CACZsQ==
X-ME-Sender: <xms:FOPiYOEKonHM5a34iWM4DyDWTempB_2DXS9D9hLZKwQhlhsl0HmJtA>
    <xme:FOPiYPXjJmV1ioR7dLb1pOuvSdvqJHz-cP9dljJ7PmzoN_5rRzEEhOFyVLW-2Gz5s
    26ziD872M9Xyl94yeg>
X-ME-Received: <xmr:FOPiYIKFmZXZwvPMDQ-pFpRMVYMrQyJKXiLD8RCuFexfYa_NUMWptkFSPILAQLE2-YBTfq4vWWZ-XoFj-4BR1uJMf9QFiGagE_UirCOAIO8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeejgedgfeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeffrghvihgu
    ucfgughmohhnughsohhnuceouggrvhhiugdrvggumhhonhgushhonhesohhrrggtlhgvrd
    gtohhmqeenucggtffrrghtthgvrhhnpedufeetjefgfefhtdejhfehtdfftefhteekhefg
    leehfffhiefhgeelgfejtdehkeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpegurghvihgurdgvughmohhnughsohhnsehorhgrtghlvgdrtgho
    mh
X-ME-Proxy: <xmx:FOPiYIEQDLXj85QCUICol0zMNE1rGClMIDmKJ_fNWwgtQ77FPZ4k6Q>
    <xmx:FOPiYEWxJj5IEvFoBXRH1wHzLti9aYaNdNiucWjzjUihAdMskK4GMg>
    <xmx:FOPiYLMUQPyo2BGM_7FTcxC30U0dwV0Iqy3DHVNWvmjzVaKcqIksmQ>
    <xmx:FePiYKYbCuPKKTJ1lPvnzTa2KWxBYSpemOY_UiHEdxOT3FJ7DWTVWw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 5 Jul 2021 06:46:43 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id 3de58af9;
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
Subject: [RFC PATCH 6/8] target/i386: Observe XSAVE state area offsets
Date:   Mon,  5 Jul 2021 11:46:30 +0100
Message-Id: <20210705104632.2902400-7-david.edmondson@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705104632.2902400-1-david.edmondson@oracle.com>
References: <20210705104632.2902400-1-david.edmondson@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rather than relying on the X86XSaveArea structure definition directly,
the routines that manipulate the XSAVE state area should observe the
offsets declared in the x86_ext_save_areas array.

Currently the offsets declared in the array are derived from the
structure definition, resulting in no functional change.

Signed-off-by: David Edmondson <david.edmondson@oracle.com>
---
 target/i386/xsave_helper.c | 262 ++++++++++++++++++++++++++++---------
 1 file changed, 200 insertions(+), 62 deletions(-)

diff --git a/target/i386/xsave_helper.c b/target/i386/xsave_helper.c
index b16c6ac0fe..ac61a96344 100644
--- a/target/i386/xsave_helper.c
+++ b/target/i386/xsave_helper.c
@@ -9,13 +9,20 @@
 void x86_cpu_xsave_all_areas(X86CPU *cpu, void *buf, uint32_t buflen)
 {
     CPUX86State *env = &cpu->env;
-    X86XSaveArea *xsave = buf;
-    uint16_t cwd, swd, twd;
+    const ExtSaveArea *e, *f;
     int i;
 
-    assert(buflen >= sizeof(*xsave));
+    X86LegacyXSaveArea *legacy;
+    X86XSaveHeader *header;
+    uint16_t cwd, swd, twd;
+
+    memset(buf, 0, buflen);
+
+    e = &x86_ext_save_areas[XSTATE_FP_BIT];
+
+    legacy = buf + e->offset;
+    header = buf + e->offset + sizeof(*legacy);
 
-    memset(xsave, 0, buflen);
     twd = 0;
     swd = env->fpus & ~(7 << 11);
     swd |= (env->fpstt & 7) << 11;
@@ -23,91 +30,222 @@ void x86_cpu_xsave_all_areas(X86CPU *cpu, void *buf, uint32_t buflen)
     for (i = 0; i < 8; ++i) {
         twd |= (!env->fptags[i]) << i;
     }
-    xsave->legacy.fcw = cwd;
-    xsave->legacy.fsw = swd;
-    xsave->legacy.ftw = twd;
-    xsave->legacy.fpop = env->fpop;
-    xsave->legacy.fpip = env->fpip;
-    xsave->legacy.fpdp = env->fpdp;
-    memcpy(&xsave->legacy.fpregs, env->fpregs,
-            sizeof env->fpregs);
-    xsave->legacy.mxcsr = env->mxcsr;
-    xsave->header.xstate_bv = env->xstate_bv;
-    memcpy(&xsave->bndreg_state.bnd_regs, env->bnd_regs,
-            sizeof env->bnd_regs);
-    xsave->bndcsr_state.bndcsr = env->bndcs_regs;
-    memcpy(&xsave->opmask_state.opmask_regs, env->opmask_regs,
-            sizeof env->opmask_regs);
+    legacy->fcw = cwd;
+    legacy->fsw = swd;
+    legacy->ftw = twd;
+    legacy->fpop = env->fpop;
+    legacy->fpip = env->fpip;
+    legacy->fpdp = env->fpdp;
+    memcpy(&legacy->fpregs, env->fpregs,
+           sizeof(env->fpregs));
+    legacy->mxcsr = env->mxcsr;
 
     for (i = 0; i < CPU_NB_REGS; i++) {
-        uint8_t *xmm = xsave->legacy.xmm_regs[i];
-        uint8_t *ymmh = xsave->avx_state.ymmh[i];
-        uint8_t *zmmh = xsave->zmm_hi256_state.zmm_hi256[i];
+        uint8_t *xmm = legacy->xmm_regs[i];
+
         stq_p(xmm,     env->xmm_regs[i].ZMM_Q(0));
-        stq_p(xmm+8,   env->xmm_regs[i].ZMM_Q(1));
-        stq_p(ymmh,    env->xmm_regs[i].ZMM_Q(2));
-        stq_p(ymmh+8,  env->xmm_regs[i].ZMM_Q(3));
-        stq_p(zmmh,    env->xmm_regs[i].ZMM_Q(4));
-        stq_p(zmmh+8,  env->xmm_regs[i].ZMM_Q(5));
-        stq_p(zmmh+16, env->xmm_regs[i].ZMM_Q(6));
-        stq_p(zmmh+24, env->xmm_regs[i].ZMM_Q(7));
+        stq_p(xmm + 8, env->xmm_regs[i].ZMM_Q(1));
+    }
+
+    header->xstate_bv = env->xstate_bv;
+
+    e = &x86_ext_save_areas[XSTATE_YMM_BIT];
+    if (e->size && e->offset) {
+        XSaveAVX *avx;
+
+        avx = buf + e->offset;
+
+        for (i = 0; i < CPU_NB_REGS; i++) {
+            uint8_t *ymmh = avx->ymmh[i];
+
+            stq_p(ymmh,     env->xmm_regs[i].ZMM_Q(2));
+            stq_p(ymmh + 8, env->xmm_regs[i].ZMM_Q(3));
+        }
+    }
+
+    e = &x86_ext_save_areas[XSTATE_BNDREGS_BIT];
+    if (e->size && e->offset) {
+        XSaveBNDREG *bndreg;
+        XSaveBNDCSR *bndcsr;
+
+        f = &x86_ext_save_areas[XSTATE_BNDCSR_BIT];
+        assert(f->size);
+        assert(f->offset);
+
+        bndreg = buf + e->offset;
+        bndcsr = buf + f->offset;
+
+        memcpy(&bndreg->bnd_regs, env->bnd_regs,
+               sizeof(env->bnd_regs));
+        bndcsr->bndcsr = env->bndcs_regs;
     }
 
+    e = &x86_ext_save_areas[XSTATE_OPMASK_BIT];
+    if (e->size && e->offset) {
+        XSaveOpmask *opmask;
+        XSaveZMM_Hi256 *zmm_hi256;
+#ifdef TARGET_X86_64
+        XSaveHi16_ZMM *hi16_zmm;
+#endif
+
+        f = &x86_ext_save_areas[XSTATE_ZMM_Hi256_BIT];
+        assert(f->size);
+        assert(f->offset);
+
+        opmask = buf + e->offset;
+        zmm_hi256 = buf + f->offset;
+
+        memcpy(&opmask->opmask_regs, env->opmask_regs,
+               sizeof(env->opmask_regs));
+
+        for (i = 0; i < CPU_NB_REGS; i++) {
+            uint8_t *zmmh = zmm_hi256->zmm_hi256[i];
+
+            stq_p(zmmh,      env->xmm_regs[i].ZMM_Q(4));
+            stq_p(zmmh + 8,  env->xmm_regs[i].ZMM_Q(5));
+            stq_p(zmmh + 16, env->xmm_regs[i].ZMM_Q(6));
+            stq_p(zmmh + 24, env->xmm_regs[i].ZMM_Q(7));
+        }
+
 #ifdef TARGET_X86_64
-    memcpy(&xsave->hi16_zmm_state.hi16_zmm, &env->xmm_regs[16],
-            16 * sizeof env->xmm_regs[16]);
-    memcpy(&xsave->pkru_state, &env->pkru, sizeof env->pkru);
+        f = &x86_ext_save_areas[XSTATE_Hi16_ZMM_BIT];
+        assert(f->size);
+        assert(f->offset);
+
+        hi16_zmm = buf + f->offset;
+
+        memcpy(&hi16_zmm->hi16_zmm, &env->xmm_regs[16],
+               16 * sizeof(env->xmm_regs[16]));
+#endif
+    }
+
+#ifdef TARGET_X86_64
+    e = &x86_ext_save_areas[XSTATE_PKRU_BIT];
+    if (e->size && e->offset) {
+        XSavePKRU *pkru = buf + e->offset;
+
+        memcpy(pkru, &env->pkru, sizeof(env->pkru));
+    }
 #endif
 }
 
 void x86_cpu_xrstor_all_areas(X86CPU *cpu, const void *buf, uint32_t buflen)
 {
     CPUX86State *env = &cpu->env;
-    const X86XSaveArea *xsave = buf;
+    const ExtSaveArea *e, *f, *g;
     int i;
+
+    const X86LegacyXSaveArea *legacy;
+    const X86XSaveHeader *header;
     uint16_t cwd, swd, twd;
 
-    assert(buflen >= sizeof(*xsave));
+    e = &x86_ext_save_areas[XSTATE_FP_BIT];
 
-    cwd = xsave->legacy.fcw;
-    swd = xsave->legacy.fsw;
-    twd = xsave->legacy.ftw;
-    env->fpop = xsave->legacy.fpop;
+    legacy = buf + e->offset;
+    header = buf + e->offset + sizeof(*legacy);
+
+    cwd = legacy->fcw;
+    swd = legacy->fsw;
+    twd = legacy->ftw;
+    env->fpop = legacy->fpop;
     env->fpstt = (swd >> 11) & 7;
     env->fpus = swd;
     env->fpuc = cwd;
     for (i = 0; i < 8; ++i) {
         env->fptags[i] = !((twd >> i) & 1);
     }
-    env->fpip = xsave->legacy.fpip;
-    env->fpdp = xsave->legacy.fpdp;
-    env->mxcsr = xsave->legacy.mxcsr;
-    memcpy(env->fpregs, &xsave->legacy.fpregs,
-            sizeof env->fpregs);
-    env->xstate_bv = xsave->header.xstate_bv;
-    memcpy(env->bnd_regs, &xsave->bndreg_state.bnd_regs,
-            sizeof env->bnd_regs);
-    env->bndcs_regs = xsave->bndcsr_state.bndcsr;
-    memcpy(env->opmask_regs, &xsave->opmask_state.opmask_regs,
-            sizeof env->opmask_regs);
+    env->fpip = legacy->fpip;
+    env->fpdp = legacy->fpdp;
+    env->mxcsr = legacy->mxcsr;
+    memcpy(env->fpregs, &legacy->fpregs,
+           sizeof(env->fpregs));
 
     for (i = 0; i < CPU_NB_REGS; i++) {
-        const uint8_t *xmm = xsave->legacy.xmm_regs[i];
-        const uint8_t *ymmh = xsave->avx_state.ymmh[i];
-        const uint8_t *zmmh = xsave->zmm_hi256_state.zmm_hi256[i];
+        const uint8_t *xmm = legacy->xmm_regs[i];
+
         env->xmm_regs[i].ZMM_Q(0) = ldq_p(xmm);
-        env->xmm_regs[i].ZMM_Q(1) = ldq_p(xmm+8);
-        env->xmm_regs[i].ZMM_Q(2) = ldq_p(ymmh);
-        env->xmm_regs[i].ZMM_Q(3) = ldq_p(ymmh+8);
-        env->xmm_regs[i].ZMM_Q(4) = ldq_p(zmmh);
-        env->xmm_regs[i].ZMM_Q(5) = ldq_p(zmmh+8);
-        env->xmm_regs[i].ZMM_Q(6) = ldq_p(zmmh+16);
-        env->xmm_regs[i].ZMM_Q(7) = ldq_p(zmmh+24);
+        env->xmm_regs[i].ZMM_Q(1) = ldq_p(xmm + 8);
+    }
+
+    env->xstate_bv = header->xstate_bv;
+
+    e = &x86_ext_save_areas[XSTATE_YMM_BIT];
+    if (e->size && e->offset) {
+        const XSaveAVX *avx;
+
+        avx = buf + e->offset;
+        for (i = 0; i < CPU_NB_REGS; i++) {
+            const uint8_t *ymmh = avx->ymmh[i];
+
+            env->xmm_regs[i].ZMM_Q(2) = ldq_p(ymmh);
+            env->xmm_regs[i].ZMM_Q(3) = ldq_p(ymmh + 8);
+        }
+    }
+
+    e = &x86_ext_save_areas[XSTATE_BNDREGS_BIT];
+    if (e->size && e->offset) {
+        const XSaveBNDREG *bndreg;
+        const XSaveBNDCSR *bndcsr;
+
+        f = &x86_ext_save_areas[XSTATE_BNDCSR_BIT];
+        assert(f->size);
+        assert(f->offset);
+
+        bndreg = buf + e->offset;
+        bndcsr = buf + f->offset;
+
+        memcpy(env->bnd_regs, &bndreg->bnd_regs,
+               sizeof(env->bnd_regs));
+        env->bndcs_regs = bndcsr->bndcsr;
     }
 
+    e = &x86_ext_save_areas[XSTATE_OPMASK_BIT];
+    if (e->size && e->offset) {
+        const XSaveOpmask *opmask;
+        const XSaveZMM_Hi256 *zmm_hi256;
 #ifdef TARGET_X86_64
-    memcpy(&env->xmm_regs[16], &xsave->hi16_zmm_state.hi16_zmm,
-           16 * sizeof env->xmm_regs[16]);
-    memcpy(&env->pkru, &xsave->pkru_state, sizeof env->pkru);
+        const XSaveHi16_ZMM *hi16_zmm;
+#endif
+
+        f = &x86_ext_save_areas[XSTATE_ZMM_Hi256_BIT];
+        assert(f->size);
+        assert(f->offset);
+
+        g = &x86_ext_save_areas[XSTATE_Hi16_ZMM_BIT];
+        assert(g->size);
+        assert(g->offset);
+
+        opmask = buf + e->offset;
+        zmm_hi256 = buf + f->offset;
+#ifdef TARGET_X86_64
+        hi16_zmm = buf + g->offset;
+#endif
+
+        memcpy(env->opmask_regs, &opmask->opmask_regs,
+               sizeof(env->opmask_regs));
+
+        for (i = 0; i < CPU_NB_REGS; i++) {
+            const uint8_t *zmmh = zmm_hi256->zmm_hi256[i];
+
+            env->xmm_regs[i].ZMM_Q(4) = ldq_p(zmmh);
+            env->xmm_regs[i].ZMM_Q(5) = ldq_p(zmmh + 8);
+            env->xmm_regs[i].ZMM_Q(6) = ldq_p(zmmh + 16);
+            env->xmm_regs[i].ZMM_Q(7) = ldq_p(zmmh + 24);
+        }
+
+#ifdef TARGET_X86_64
+        memcpy(&env->xmm_regs[16], &hi16_zmm->hi16_zmm,
+               16 * sizeof(env->xmm_regs[16]));
+#endif
+    }
+
+#ifdef TARGET_X86_64
+    e = &x86_ext_save_areas[XSTATE_PKRU_BIT];
+    if (e->size && e->offset) {
+        const XSavePKRU *pkru;
+
+        pkru = buf + e->offset;
+        memcpy(&env->pkru, pkru, sizeof(env->pkru));
+    }
 #endif
 }
-- 
2.30.2

