Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 879493CE50F
	for <lists+kvm@lfdr.de>; Mon, 19 Jul 2021 18:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240546AbhGSPrj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jul 2021 11:47:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350258AbhGSPpq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jul 2021 11:45:46 -0400
Received: from mail-wm1-x34a.google.com (mail-wm1-x34a.google.com [IPv6:2a00:1450:4864:20::34a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AEEDC0225B4
        for <kvm@vger.kernel.org>; Mon, 19 Jul 2021 08:38:13 -0700 (PDT)
Received: by mail-wm1-x34a.google.com with SMTP id 1-20020a05600c0201b029022095f349f3so142589wmi.0
        for <kvm@vger.kernel.org>; Mon, 19 Jul 2021 09:03:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=k10DPudObTvcj74PA9oJ4czrG2bf/iAmYaVF6bRkhko=;
        b=BPSFlH5yAUOM5EqitdPB3laSW+FRnNWn2lMenmzoSKl27Cvko3VreV9gcyS/C6J0HR
         ftiwwxS3VzE+ufspgaVIXd/18+Mnb++5SN5atFtMk9JTNyLuHjVfsffTqfhXXKFtxnQn
         vyL2kEoKt6INYuLNeMb0i517AmrACvOQMrsLA34LiYFNPvevZrY6W9bKO0Snob3nWrpw
         MtUOlJNHX6tC7etd5Uld5WJZqkSo6TmdYef+MefU3jc3GV+HlmZfQ2fbTUNGFcxH7pCP
         VOIuBF9TfW4mnHTY4Ktp5AGgwmLd0xvteF5dEK55U4E5DGzE5a6tJLKKQeYP/lQ7M8dK
         Glxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=k10DPudObTvcj74PA9oJ4czrG2bf/iAmYaVF6bRkhko=;
        b=Zti8H0CWHnadSicHstQdob5r0WeecMeL0h/D/6amvM4DA0GNAmxtX3dVy49wn70G08
         nj7lhUyqlZGzGMsxODqr97M8gJ2gWxVRtXZ3p5oXOiuQM+PrTZs68au5K0wUSMT3E8z9
         WA+gBRE14aG0xukATnLzx810JiQ4Or3dDPcFjMiI96DWKWYZI5aVh8OTcuwilIxD9AHX
         MhB28qcy+fF0wj0h/4x7XDhBFo0QUfOEqdxqDxMaQCRQ3VkIWIot3Xqeel5TFyyirqol
         TLBWQWV7qHiClqBH73030HWwp0clNesxtfH6HjAsljgVseCFF9Bp4HIjVbo03vBIrAGV
         Wu/g==
X-Gm-Message-State: AOAM533xc81yfPESJtA34qfhZTNwWEZLndyIcITq6LZ/VzKMZPzYliwC
        9IPU50fNLacqSy7+++HwRTXwb3rJLw==
X-Google-Smtp-Source: ABdhPJwJ28BjxRQydXSdv3kpZHN6Lpf07TsYNXVlePcsPh5Xqgyd/MpQ7FE52+v1uJMUFASUHF3DQsPCaQ==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a5d:4048:: with SMTP id w8mr30885618wrp.82.1626710636444;
 Mon, 19 Jul 2021 09:03:56 -0700 (PDT)
Date:   Mon, 19 Jul 2021 17:03:35 +0100
In-Reply-To: <20210719160346.609914-1-tabba@google.com>
Message-Id: <20210719160346.609914-5-tabba@google.com>
Mime-Version: 1.0
References: <20210719160346.609914-1-tabba@google.com>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH v3 04/15] KVM: arm64: Fix names of config register fields
From:   Fuad Tabba <tabba@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, will@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, drjones@redhat.com, qperret@google.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel-team@android.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Change the names of hcr_el2 register fields to match the Arm
Architecture Reference Manual. Easier for cross-referencing and
for grepping.

Also, change the name of CPTR_EL2_RES1 to CPTR_NVHE_EL2_RES1,
because res1 bits are different for VHE.

No functional change intended.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_arm.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 6a523ec83415..a928b2dc0b0f 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -32,9 +32,9 @@
 #define HCR_TVM		(UL(1) << 26)
 #define HCR_TTLB	(UL(1) << 25)
 #define HCR_TPU		(UL(1) << 24)
-#define HCR_TPC		(UL(1) << 23)
+#define HCR_TPC		(UL(1) << 23) /* HCR_TPCP if FEAT_DPB */
 #define HCR_TSW		(UL(1) << 22)
-#define HCR_TAC		(UL(1) << 21)
+#define HCR_TACR	(UL(1) << 21)
 #define HCR_TIDCP	(UL(1) << 20)
 #define HCR_TSC		(UL(1) << 19)
 #define HCR_TID3	(UL(1) << 18)
@@ -61,7 +61,7 @@
  * The bits we set in HCR:
  * TLOR:	Trap LORegion register accesses
  * RW:		64bit by default, can be overridden for 32bit VMs
- * TAC:		Trap ACTLR
+ * TACR:	Trap ACTLR
  * TSC:		Trap SMC
  * TSW:		Trap cache operations by set/way
  * TWE:		Trap WFE
@@ -76,7 +76,7 @@
  * PTW:		Take a stage2 fault if a stage1 walk steps in device memory
  */
 #define HCR_GUEST_FLAGS (HCR_TSC | HCR_TSW | HCR_TWE | HCR_TWI | HCR_VM | \
-			 HCR_BSU_IS | HCR_FB | HCR_TAC | \
+			 HCR_BSU_IS | HCR_FB | HCR_TACR | \
 			 HCR_AMO | HCR_SWIO | HCR_TIDCP | HCR_RW | HCR_TLOR | \
 			 HCR_FMO | HCR_IMO | HCR_PTW )
 #define HCR_VIRT_EXCP_MASK (HCR_VSE | HCR_VI | HCR_VF)
@@ -275,8 +275,8 @@
 #define CPTR_EL2_TTA	(1 << 20)
 #define CPTR_EL2_TFP	(1 << CPTR_EL2_TFP_SHIFT)
 #define CPTR_EL2_TZ	(1 << 8)
-#define CPTR_EL2_RES1	0x000032ff /* known RES1 bits in CPTR_EL2 */
-#define CPTR_EL2_DEFAULT	CPTR_EL2_RES1
+#define CPTR_NVHE_EL2_RES1	0x000032ff /* known RES1 bits in CPTR_EL2 (nVHE) */
+#define CPTR_EL2_DEFAULT	CPTR_NVHE_EL2_RES1
 
 /* Hyp Debug Configuration Register bits */
 #define MDCR_EL2_E2TB_MASK	(UL(0x3))
-- 
2.32.0.402.g57bb445576-goog

