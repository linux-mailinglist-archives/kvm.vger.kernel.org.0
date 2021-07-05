Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A06713BBB7F
	for <lists+kvm@lfdr.de>; Mon,  5 Jul 2021 12:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbhGEKtZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jul 2021 06:49:25 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:54333 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231199AbhGEKtY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 5 Jul 2021 06:49:24 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 263BF1940A33;
        Mon,  5 Jul 2021 06:46:47 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 05 Jul 2021 06:46:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=kSTjC8Sl+aOJouiYIFKzOztHdUokHFkzp1fkQ3Gmlt8=; b=Bav4Zuw3
        3syLuKxyr0BjAd6IIDUPYjwZnCuJus4qEg3I50/ur2tyXjQ/NvnSgNWCqQ7biHWy
        cg38VGr4CzhQioTY72/CdAVXksV06HSV0AWM4U9bAXNb5k62V6Ab7itM1ya+FS4B
        YVpZfBOb/id7L+5FLs+EeSsgZCo4etse31JPPATnVhWNFNv3iuyz1To1oyVpwSvM
        qUzS0NmcrBoq+ACYiuWOdTsGo+7DC2WiE/dMcmYuajQlyAMHLx/KhqfpRCk0OTR5
        NIK2acCz74v0HDBHZXBvNCI4iHUZrdMULIpICyIdU4bdGHPJ0me/XouBybBbHjZ+
        lZF8R0Cg3zcyWQ==
X-ME-Sender: <xms:FePiYESFjbGozmxo_jtgX15Owb5veP1jdavVWozG9HUDI13a-VhmUw>
    <xme:FePiYBzyotkz81nNe0RiWbrgt_EHeoIcs3SxA68H59W65UHa26_sftHZ_N3pr2PHV
    XIqx2qvIKL9MIfEJjw>
X-ME-Received: <xmr:FePiYB2WFoHoy9HL3BqRRgOuzNL8iS9ZRIc2CCY7ZlJ1QIapC1G3QFLtnhqx3rW1yRaXMdsKKNDtDIKLv78MTcIZlfUi_XoVZBOQDIofG2I>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeejgedgfeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeffrghvihgu
    ucfgughmohhnughsohhnuceouggrvhhiugdrvggumhhonhgushhonhesohhrrggtlhgvrd
    gtohhmqeenucggtffrrghtthgvrhhnpedufeetjefgfefhtdejhfehtdfftefhteekhefg
    leehfffhiefhgeelgfejtdehkeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpegurghvihgurdgvughmohhnughsohhnsehorhgrtghlvgdrtgho
    mh
X-ME-Proxy: <xmx:FePiYIBkGw-I-mil7D6FPcib3sm_KBQwNL_dIXO2PIGolTbre5bGgA>
    <xmx:FePiYNiOOO0l7H6BfiReHL6i_JjrLV5tcH5WbMVjJHq80Pp-8KYuRA>
    <xmx:FePiYEp-cVGcUWN7PWsY2qgUUIPZCwF8IYXZhmNGjIwu88iMG5tiJg>
    <xmx:F-PiYEVGjZ6JTdas2XF9XItskFY738DAR8_EpfXSXouD1ThZLCdckw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 5 Jul 2021 06:46:44 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id 72435e5b;
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
Subject: [RFC PATCH 8/8] target/i386: Move X86XSaveArea into TCG
Date:   Mon,  5 Jul 2021 11:46:32 +0100
Message-Id: <20210705104632.2902400-9-david.edmondson@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705104632.2902400-1-david.edmondson@oracle.com>
References: <20210705104632.2902400-1-david.edmondson@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Given that TCG is now the only consumer of X86XSaveArea, move the
structure definition and associated offset declarations and checks to a
TCG specific header.

Signed-off-by: David Edmondson <david.edmondson@oracle.com>
---
 target/i386/cpu.h            | 57 ------------------------------------
 target/i386/tcg/fpu_helper.c |  1 +
 target/i386/tcg/tcg-cpu.h    | 57 ++++++++++++++++++++++++++++++++++++
 3 files changed, 58 insertions(+), 57 deletions(-)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 96b672f8bd..0f7ddbfeae 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -1305,48 +1305,6 @@ typedef struct XSavePKRU {
     uint32_t padding;
 } XSavePKRU;
 
-#define XSAVE_FCW_FSW_OFFSET    0x000
-#define XSAVE_FTW_FOP_OFFSET    0x004
-#define XSAVE_CWD_RIP_OFFSET    0x008
-#define XSAVE_CWD_RDP_OFFSET    0x010
-#define XSAVE_MXCSR_OFFSET      0x018
-#define XSAVE_ST_SPACE_OFFSET   0x020
-#define XSAVE_XMM_SPACE_OFFSET  0x0a0
-#define XSAVE_XSTATE_BV_OFFSET  0x200
-#define XSAVE_AVX_OFFSET        0x240
-#define XSAVE_BNDREG_OFFSET     0x3c0
-#define XSAVE_BNDCSR_OFFSET     0x400
-#define XSAVE_OPMASK_OFFSET     0x440
-#define XSAVE_ZMM_HI256_OFFSET  0x480
-#define XSAVE_HI16_ZMM_OFFSET   0x680
-#define XSAVE_PKRU_OFFSET       0xa80
-
-typedef struct X86XSaveArea {
-    X86LegacyXSaveArea legacy;
-    X86XSaveHeader header;
-
-    /* Extended save areas: */
-
-    /* AVX State: */
-    XSaveAVX avx_state;
-
-    /* Ensure that XSaveBNDREG is properly aligned. */
-    uint8_t padding[XSAVE_BNDREG_OFFSET
-                    - sizeof(X86LegacyXSaveArea)
-                    - sizeof(X86XSaveHeader)
-                    - sizeof(XSaveAVX)];
-
-    /* MPX State: */
-    XSaveBNDREG bndreg_state;
-    XSaveBNDCSR bndcsr_state;
-    /* AVX-512 State: */
-    XSaveOpmask opmask_state;
-    XSaveZMM_Hi256 zmm_hi256_state;
-    XSaveHi16_ZMM hi16_zmm_state;
-    /* PKRU State: */
-    XSavePKRU pkru_state;
-} X86XSaveArea;
-
 QEMU_BUILD_BUG_ON(sizeof(XSaveAVX) != 0x100);
 QEMU_BUILD_BUG_ON(sizeof(XSaveBNDREG) != 0x40);
 QEMU_BUILD_BUG_ON(sizeof(XSaveBNDCSR) != 0x40);
@@ -1355,21 +1313,6 @@ QEMU_BUILD_BUG_ON(sizeof(XSaveZMM_Hi256) != 0x200);
 QEMU_BUILD_BUG_ON(sizeof(XSaveHi16_ZMM) != 0x400);
 QEMU_BUILD_BUG_ON(sizeof(XSavePKRU) != 0x8);
 
-QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, legacy.fcw) != XSAVE_FCW_FSW_OFFSET);
-QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, legacy.ftw) != XSAVE_FTW_FOP_OFFSET);
-QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, legacy.fpip) != XSAVE_CWD_RIP_OFFSET);
-QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, legacy.fpdp) != XSAVE_CWD_RDP_OFFSET);
-QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, legacy.mxcsr) != XSAVE_MXCSR_OFFSET);
-QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, legacy.fpregs) != XSAVE_ST_SPACE_OFFSET);
-QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, legacy.xmm_regs) != XSAVE_XMM_SPACE_OFFSET);
-QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, avx_state) != XSAVE_AVX_OFFSET);
-QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, bndreg_state) != XSAVE_BNDREG_OFFSET);
-QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, bndcsr_state) != XSAVE_BNDCSR_OFFSET);
-QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, opmask_state) != XSAVE_OPMASK_OFFSET);
-QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, zmm_hi256_state) != XSAVE_ZMM_HI256_OFFSET);
-QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, hi16_zmm_state) != XSAVE_HI16_ZMM_OFFSET);
-QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, pkru_state) != XSAVE_PKRU_OFFSET);
-
 typedef struct ExtSaveArea {
     uint32_t feature, bits;
     uint32_t offset, size;
diff --git a/target/i386/tcg/fpu_helper.c b/target/i386/tcg/fpu_helper.c
index 4e11965067..74bbe94b80 100644
--- a/target/i386/tcg/fpu_helper.c
+++ b/target/i386/tcg/fpu_helper.c
@@ -20,6 +20,7 @@
 #include "qemu/osdep.h"
 #include <math.h>
 #include "cpu.h"
+#include "tcg-cpu.h"
 #include "exec/helper-proto.h"
 #include "fpu/softfloat.h"
 #include "fpu/softfloat-macros.h"
diff --git a/target/i386/tcg/tcg-cpu.h b/target/i386/tcg/tcg-cpu.h
index 36bd300af0..53a8494455 100644
--- a/target/i386/tcg/tcg-cpu.h
+++ b/target/i386/tcg/tcg-cpu.h
@@ -19,6 +19,63 @@
 #ifndef TCG_CPU_H
 #define TCG_CPU_H
 
+#define XSAVE_FCW_FSW_OFFSET    0x000
+#define XSAVE_FTW_FOP_OFFSET    0x004
+#define XSAVE_CWD_RIP_OFFSET    0x008
+#define XSAVE_CWD_RDP_OFFSET    0x010
+#define XSAVE_MXCSR_OFFSET      0x018
+#define XSAVE_ST_SPACE_OFFSET   0x020
+#define XSAVE_XMM_SPACE_OFFSET  0x0a0
+#define XSAVE_XSTATE_BV_OFFSET  0x200
+#define XSAVE_AVX_OFFSET        0x240
+#define XSAVE_BNDREG_OFFSET     0x3c0
+#define XSAVE_BNDCSR_OFFSET     0x400
+#define XSAVE_OPMASK_OFFSET     0x440
+#define XSAVE_ZMM_HI256_OFFSET  0x480
+#define XSAVE_HI16_ZMM_OFFSET   0x680
+#define XSAVE_PKRU_OFFSET       0xa80
+
+typedef struct X86XSaveArea {
+    X86LegacyXSaveArea legacy;
+    X86XSaveHeader header;
+
+    /* Extended save areas: */
+
+    /* AVX State: */
+    XSaveAVX avx_state;
+
+    /* Ensure that XSaveBNDREG is properly aligned. */
+    uint8_t padding[XSAVE_BNDREG_OFFSET
+                    - sizeof(X86LegacyXSaveArea)
+                    - sizeof(X86XSaveHeader)
+                    - sizeof(XSaveAVX)];
+
+    /* MPX State: */
+    XSaveBNDREG bndreg_state;
+    XSaveBNDCSR bndcsr_state;
+    /* AVX-512 State: */
+    XSaveOpmask opmask_state;
+    XSaveZMM_Hi256 zmm_hi256_state;
+    XSaveHi16_ZMM hi16_zmm_state;
+    /* PKRU State: */
+    XSavePKRU pkru_state;
+} X86XSaveArea;
+
+QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, legacy.fcw) != XSAVE_FCW_FSW_OFFSET);
+QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, legacy.ftw) != XSAVE_FTW_FOP_OFFSET);
+QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, legacy.fpip) != XSAVE_CWD_RIP_OFFSET);
+QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, legacy.fpdp) != XSAVE_CWD_RDP_OFFSET);
+QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, legacy.mxcsr) != XSAVE_MXCSR_OFFSET);
+QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, legacy.fpregs) != XSAVE_ST_SPACE_OFFSET);
+QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, legacy.xmm_regs) != XSAVE_XMM_SPACE_OFFSET);
+QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, avx_state) != XSAVE_AVX_OFFSET);
+QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, bndreg_state) != XSAVE_BNDREG_OFFSET);
+QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, bndcsr_state) != XSAVE_BNDCSR_OFFSET);
+QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, opmask_state) != XSAVE_OPMASK_OFFSET);
+QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, zmm_hi256_state) != XSAVE_ZMM_HI256_OFFSET);
+QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, hi16_zmm_state) != XSAVE_HI16_ZMM_OFFSET);
+QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, pkru_state) != XSAVE_PKRU_OFFSET);
+
 bool tcg_cpu_realizefn(CPUState *cs, Error **errp);
 
 #endif /* TCG_CPU_H */
-- 
2.30.2

