Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6118E3BBB7C
	for <lists+kvm@lfdr.de>; Mon,  5 Jul 2021 12:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231225AbhGEKtW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jul 2021 06:49:22 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:45489 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231190AbhGEKtV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 5 Jul 2021 06:49:21 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.nyi.internal (Postfix) with ESMTP id 01C2719409D5;
        Mon,  5 Jul 2021 06:46:44 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Mon, 05 Jul 2021 06:46:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=uHtzc5hD5n2kpYfDdA4+xmzSapD2LfwWyUZ1ufnaLg4=; b=Hx9D4/IF
        IAxJNCW8R6Ewi2C7ssRf/JdN1kYEpb4nNkbRtKVjYt8RuzVwEjkFR5P8kxbx26w2
        CnfDKtOdmUmlz9DZ21WThY5gNDxjUF415Y0+0nleZZ5yLAff2ORijnvqZys8ndot
        Y/sq2zpKWz4kxYuplYn5eOITGD0C3HijEuXvmanOFaKJApoXQGlADyuViu+i5ys7
        d4rpbSLaxxm5cVc++uh0jrEmnTghDrF/E+CJBnzBVqOiLOImKTv39zM2No+jWuO0
        7OcF5hgKIteNgTPq5Iy/HxGbYTImXQ4NW4P3M5qdfNeogqDK2NwekQXw1O8ENguB
        zqHnH08y5GfLBg==
X-ME-Sender: <xms:E-PiYLt-B8vm6eQQtOmk34bNzpsrlRpqFfm1_wuirGDjTfUTEZYwog>
    <xme:E-PiYMcTZ3T0ARmtTOD0DpynSv_dzj1EON807sxrCszo86LnDXkplcPnPM30uWiO6
    9mw9eMjfRxnv79feBg>
X-ME-Received: <xmr:E-PiYOyNfPCu-DgJdvl4LPSrcHE24_6eY-dp87dv8Id5ckGjafCN4RLNIP4tcB9Th5vQlTR5fgI73wYJBsk2aW6D4Sraqj0byj2R8LnsFIE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeejgedgfeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeffrghvihgu
    ucfgughmohhnughsohhnuceouggrvhhiugdrvggumhhonhgushhonhesohhrrggtlhgvrd
    gtohhmqeenucggtffrrghtthgvrhhnpedufeetjefgfefhtdejhfehtdfftefhteekhefg
    leehfffhiefhgeelgfejtdehkeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpegurghvihgurdgvughmohhnughsohhnsehorhgrtghlvgdrtgho
    mh
X-ME-Proxy: <xmx:E-PiYKPh_Q4VT-GA3wf8i9bj0-IImma2_iZqjRuFxg_SkrC7JWJ14Q>
    <xmx:E-PiYL9IWRMnxOqegXF0OYgZd2VJkUZRj08_5ZYw0pOVJvr6XFw0oQ>
    <xmx:E-PiYKUvWqcg84GMlhZpSS8lyJg28JrFJWm73sdUV77mP_MeOuzBKA>
    <xmx:E-PiYIjLF7-VFoU7tpyvL-ZIJ7nEs9YXKsHDVSISLzrcfPJJ42gy3g>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 5 Jul 2021 06:46:42 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id f3fd2bd6;
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
Subject: [RFC PATCH 5/8] target/i386: Make x86_ext_save_areas visible outside cpu.c
Date:   Mon,  5 Jul 2021 11:46:29 +0100
Message-Id: <20210705104632.2902400-6-david.edmondson@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705104632.2902400-1-david.edmondson@oracle.com>
References: <20210705104632.2902400-1-david.edmondson@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Provide visibility of the x86_ext_save_areas array and associated type
outside of cpu.c.

Signed-off-by: David Edmondson <david.edmondson@oracle.com>
---
 target/i386/cpu.c | 7 +------
 target/i386/cpu.h | 9 +++++++++
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index d8f3ab3192..13caa0de50 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1304,12 +1304,7 @@ static const X86RegisterInfo32 x86_reg_info_32[CPU_NB_REGS32] = {
 };
 #undef REGISTER
 
-typedef struct ExtSaveArea {
-    uint32_t feature, bits;
-    uint32_t offset, size;
-} ExtSaveArea;
-
-static const ExtSaveArea x86_ext_save_areas[] = {
+const ExtSaveArea x86_ext_save_areas[XSAVE_STATE_AREA_COUNT] = {
     [XSTATE_FP_BIT] = {
         /* x87 FP state component is always enabled if XSAVE is supported */
         .feature = FEAT_1_ECX, .bits = CPUID_EXT_XSAVE,
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index ada2941c6e..c9c0a34330 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -1370,6 +1370,15 @@ QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, zmm_hi256_state) != XSAVE_ZMM_HI256_OFF
 QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, hi16_zmm_state) != XSAVE_HI16_ZMM_OFFSET);
 QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, pkru_state) != XSAVE_PKRU_OFFSET);
 
+typedef struct ExtSaveArea {
+    uint32_t feature, bits;
+    uint32_t offset, size;
+} ExtSaveArea;
+
+#define XSAVE_STATE_AREA_COUNT (XSTATE_PKRU_BIT + 1)
+
+extern const ExtSaveArea x86_ext_save_areas[XSAVE_STATE_AREA_COUNT];
+
 typedef enum TPRAccess {
     TPR_ACCESS_READ,
     TPR_ACCESS_WRITE,
-- 
2.30.2

