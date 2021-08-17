Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB6803EE816
	for <lists+kvm@lfdr.de>; Tue, 17 Aug 2021 10:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239022AbhHQIMV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 04:12:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238727AbhHQIMT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Aug 2021 04:12:19 -0400
Received: from mail-wr1-x44a.google.com (mail-wr1-x44a.google.com [IPv6:2a00:1450:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22FF7C0613C1
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 01:11:46 -0700 (PDT)
Received: by mail-wr1-x44a.google.com with SMTP id z2-20020adff1c20000b0290154f60e3d2aso6278424wro.23
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 01:11:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=riHWMzrcAM6+2VGU16NZVkOvNT6zBw95n97WEjCFhB0=;
        b=s1oZnJt8O/uB5Wwp8GNi245aDjnSiO28K1OSCUNw1ROwfCqi3EgMK4iE927kUSKT30
         4yEWfpfnx083c3a9drJcp3aLhMZz3DtzxRmiy/UP03TtNMwLAbMEsHLoymw6XflNKY05
         P4IXrRa6/exnENEb+ASBa9N1KOml7QiHy+BpZMx/XkfFYbtOszA48db1Yokeo24EI4JS
         Jl+Xpq8Ge4XjtRSXbZkE04V9TDxRZg8elSN2wbKZCNLVOCFofOhVzd2Ff0BRTEW8usyM
         PjvxJg7+BZ/Bp4OJAL++xGJIVrMQoS9fwTHr2QPDfsDa0G2gvHqDm42H2sYywYGflvec
         ICeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=riHWMzrcAM6+2VGU16NZVkOvNT6zBw95n97WEjCFhB0=;
        b=Hbxkj/bUqrtRKIQdB+n5mgr/0rMb7XYLRyE8Ff8XyHJGpeNwopfCuF2q7OTDWv0b7O
         SL3Y8TfwLhEbOq4j83qNKTgnuA0QtkU+4sPDlnw4hGQ2GQ6Pb3ixJwKQhYN839QuLKnl
         PHG/kimXU4BUuWUZ/PhQq0Q0z2CTKnd2ZzXUFzvFbqcS+S9vzoTHQ2sLl4b423yU+BB2
         Zyo70eAOWAPr2GSFwwrIqM6cP5M1ls8Ixa6qYKks4/159ufcsV2PbyXwSMiihsQs+yVW
         0QgL9Qz2QigRJwOOFPsZJD1E1W7vp9m7S0GjQmaCta9XYFSePv53jeiP5gkAmli9QviH
         NT/Q==
X-Gm-Message-State: AOAM531kvHHudJuhpFTWlZ2tqSg5Xb2WgBCPOaXsQ40X5TwVa7amEPPb
        3We15HDJHrrFVC7ELikrSomCVQkKiA==
X-Google-Smtp-Source: ABdhPJxBqdSlQUtDWbtnb0OOe/ZNbip8Q5Yu0vjbiyQ+GBy166dIhRK0a6EK8PCVu03u8H+XwdSKSynECw==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a05:600c:35d3:: with SMTP id
 r19mr227788wmq.1.1629187904044; Tue, 17 Aug 2021 01:11:44 -0700 (PDT)
Date:   Tue, 17 Aug 2021 09:11:23 +0100
In-Reply-To: <20210817081134.2918285-1-tabba@google.com>
Message-Id: <20210817081134.2918285-5-tabba@google.com>
Mime-Version: 1.0
References: <20210817081134.2918285-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v4 04/15] KVM: arm64: Fix names of config register fields
From:   Fuad Tabba <tabba@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, will@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, drjones@redhat.com, oupton@google.com,
        qperret@google.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
        tabba@google.com
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
2.33.0.rc1.237.g0d66db33f3-goog

