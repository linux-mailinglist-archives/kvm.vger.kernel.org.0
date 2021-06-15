Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0553A80E8
	for <lists+kvm@lfdr.de>; Tue, 15 Jun 2021 15:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231876AbhFONmt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Jun 2021 09:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbhFONmW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Jun 2021 09:42:22 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61E09C0619F6
        for <kvm@vger.kernel.org>; Tue, 15 Jun 2021 06:40:00 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id m205-20020a25d4d60000b029052a8de1fe41so19764066ybf.23
        for <kvm@vger.kernel.org>; Tue, 15 Jun 2021 06:40:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=29BZ8y2wSdq8zl7iml6Bt00bIzQdXVAxUwLgng+5GpY=;
        b=mbhqUAYoLWki9ZQC/43jymFoWJjm7rNBAqWPNEdO+rubaFQpVPtB+CSPxuFRA7oUWd
         65odqls7yHsM2e3bt+lZE3gzA/fZz5rl5z2U4B196nGEcZ8LrEGw5GfJ/UrX3lSz9Nsm
         TsW0qKYlLkzVp3rVRHt5QFVwtHnbOygRjTQAjxieK1Jo5YdtoQ5dCaS0KCAbK/tcQM4g
         BwMO35UW38lyuAype8tfgSb7jUTEm20Pa2d3U9Qja/YhafAsS4YViH6SAfXH+CyjNn7x
         stl0fOclU4ioqm48YDsYXSifaSpYoFVEKtX3Fn+NN/T0PYF4w+R9Xbjbt2UHzjTLb6Ur
         GlSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=29BZ8y2wSdq8zl7iml6Bt00bIzQdXVAxUwLgng+5GpY=;
        b=MJe5w1oKfspVZclUlcIX6TQD+nTPDn/zjGZmBhyAQ/vUJ7AvzB+wKVKB7KiJt0QsB5
         CH5akQEHFYVEziKdFqG72ThtwSwXp/UUw4trDuTBlyWgK+ljqwJZ6nYkdPF946VIyLfZ
         SNHl8ddPPMXTn4Dus8toYJaiazMJlNBN2IStuicBXQvIt0Bo5Imi+MsFQQ0U6fhZEt+q
         N+FzQq1DdE+3mCvjVn1AM0vEubrUM3jE1AmHcFHbiF07uvUg3ibPyzsX2quj4jJSzNLJ
         CQNk9uRLfMjk64NX4LecT2MIUqdflcTKmR/ilcTnh5u8j1iP+KRqmy6I8xnXPbeSuXVN
         eUsw==
X-Gm-Message-State: AOAM530ZbxnpMxGPhY98tz39JorQhE1dVzgi+/RkRgW46qGOI930RRNV
        y9naRr//ZDIu60GWLiBghKlY/6aIuw==
X-Google-Smtp-Source: ABdhPJyqfduLDddGb1lOk/v5X9rCS+Pp0WuT0RKnWKDhyYRJKRIbrBPP1usWU75SZZd85GaYbhcHDfsJRA==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a25:4641:: with SMTP id t62mr34041829yba.253.1623764399546;
 Tue, 15 Jun 2021 06:39:59 -0700 (PDT)
Date:   Tue, 15 Jun 2021 14:39:40 +0100
In-Reply-To: <20210615133950.693489-1-tabba@google.com>
Message-Id: <20210615133950.693489-4-tabba@google.com>
Mime-Version: 1.0
References: <20210615133950.693489-1-tabba@google.com>
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
Subject: [PATCH v2 03/13] KVM: arm64: Fix names of config register fields
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

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_arm.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 25d8a61888e4..bee1ba6773fb 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -31,9 +31,9 @@
 #define HCR_TVM		(UL(1) << 26)
 #define HCR_TTLB	(UL(1) << 25)
 #define HCR_TPU		(UL(1) << 24)
-#define HCR_TPC		(UL(1) << 23)
+#define HCR_TPCP	(UL(1) << 23)
 #define HCR_TSW		(UL(1) << 22)
-#define HCR_TAC		(UL(1) << 21)
+#define HCR_TACR	(UL(1) << 21)
 #define HCR_TIDCP	(UL(1) << 20)
 #define HCR_TSC		(UL(1) << 19)
 #define HCR_TID3	(UL(1) << 18)
@@ -60,7 +60,7 @@
  * The bits we set in HCR:
  * TLOR:	Trap LORegion register accesses
  * RW:		64bit by default, can be overridden for 32bit VMs
- * TAC:		Trap ACTLR
+ * TACR:	Trap ACTLR
  * TSC:		Trap SMC
  * TSW:		Trap cache operations by set/way
  * TWE:		Trap WFE
@@ -75,7 +75,7 @@
  * PTW:		Take a stage2 fault if a stage1 walk steps in device memory
  */
 #define HCR_GUEST_FLAGS (HCR_TSC | HCR_TSW | HCR_TWE | HCR_TWI | HCR_VM | \
-			 HCR_BSU_IS | HCR_FB | HCR_TAC | \
+			 HCR_BSU_IS | HCR_FB | HCR_TACR | \
 			 HCR_AMO | HCR_SWIO | HCR_TIDCP | HCR_RW | HCR_TLOR | \
 			 HCR_FMO | HCR_IMO | HCR_PTW )
 #define HCR_VIRT_EXCP_MASK (HCR_VSE | HCR_VI | HCR_VF)
@@ -274,8 +274,8 @@
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
2.32.0.272.g935e593368-goog

