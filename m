Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFEA23EE81C
	for <lists+kvm@lfdr.de>; Tue, 17 Aug 2021 10:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239015AbhHQIMe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 04:12:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239044AbhHQIMb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Aug 2021 04:12:31 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42098C0617AE
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 01:11:58 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id f10-20020a0ccc8a0000b02903521ac3b9d7so14791211qvl.15
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 01:11:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=a1FkHacsvxlpxAzLdiQ+8Ppyqt1oFw+G4RPgD2elyDM=;
        b=t0d/tLo4vOpJ97R2R+WJ7E/Mn4CRyatYvLNI5+XDc6d/D+D+iLgcP9l1mJgMMW9YmC
         kVwXzlYCgOVFk41QkuGxihN3Ogbvf8N7scHCRdnhB4nAXWmv7IzXURY2zHD/BEaiAYQ6
         TjllHsJE6UJZxmu5jPld1CQCptRH4i9F1tLftMV5Up+OoJBqprQPLjcmAPDwjY/fPrPm
         MgayAcPlA5qUJ9BfoFBR4cwAWBAWBStqE38TrSHqPxMV2Y/TZ/+xqz54kWQ1t5U7JoFY
         tyqZiyJQxEAJV5Ngl04xPkh8FINI1IP4yATCktZ30SJa5aIxa3ns9CXj2hbSkYio9nU2
         0ZrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=a1FkHacsvxlpxAzLdiQ+8Ppyqt1oFw+G4RPgD2elyDM=;
        b=Gr+VOeVmambwjvSaEjdAoXQ1uVUsCFVF8fGZSh/AjphAIZDd8UUt0bP3/0GTxIrz0z
         Zh8KIyxZupMw2Pmh42YeYFE4rxaBtTwx1Ne/nTeW82EkAasIKIsP1jbIAnzGRtCU/sW/
         6P7tBMehcSCz30Uvn6X5NIPoVqVoeZQbq2DJPKklxv3rg9d8i0JKustVt2WE5wMP1SX3
         q3vIK4gDfsJsJf6m50QVQ6hyulmVr+4jWRTlwqbYx+dRtTWWdEecq2RBzCW2K/QDIOxs
         UhYObP+Wn0Ollx0ZEOMfn3qQCGbWVAUYbhftbHTSEO6uWj9llm1TXnHcYc8XUqxQOXSD
         jhzg==
X-Gm-Message-State: AOAM530U/3aZDuvkIYa+9Ac1iZnOsMXfqbnnTYJau+6zeyXnnhIS5ujU
        OJ5hxuE6sXMfyZVUa72Q9J3n6dtIyQ==
X-Google-Smtp-Source: ABdhPJxzcsyia+26TWJ1TMac1dWdSAXLmVDa71Pii4xoLoi/YWFmQv5nVNTZT9RkOEJvlwiLzHDZH4e6Ug==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a05:6214:10c4:: with SMTP id
 r4mr2134444qvs.58.1629187917427; Tue, 17 Aug 2021 01:11:57 -0700 (PDT)
Date:   Tue, 17 Aug 2021 09:11:29 +0100
In-Reply-To: <20210817081134.2918285-1-tabba@google.com>
Message-Id: <20210817081134.2918285-11-tabba@google.com>
Mime-Version: 1.0
References: <20210817081134.2918285-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v4 10/15] KVM: arm64: Add config register bit definitions
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

Add hardware configuration register bit definitions for HCR_EL2
and MDCR_EL2. Future patches toggle these hyp configuration
register bits to trap on certain accesses.

No functional change intended.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_arm.h | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index a928b2dc0b0f..327120c0089f 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -12,8 +12,13 @@
 #include <asm/types.h>
 
 /* Hyp Configuration Register (HCR) bits */
+
+#define HCR_TID5	(UL(1) << 58)
+#define HCR_DCT		(UL(1) << 57)
 #define HCR_ATA_SHIFT	56
 #define HCR_ATA		(UL(1) << HCR_ATA_SHIFT)
+#define HCR_AMVOFFEN	(UL(1) << 51)
+#define HCR_FIEN	(UL(1) << 47)
 #define HCR_FWB		(UL(1) << 46)
 #define HCR_API		(UL(1) << 41)
 #define HCR_APK		(UL(1) << 40)
@@ -56,6 +61,7 @@
 #define HCR_PTW		(UL(1) << 2)
 #define HCR_SWIO	(UL(1) << 1)
 #define HCR_VM		(UL(1) << 0)
+#define HCR_RES0	((UL(1) << 48) | (UL(1) << 39))
 
 /*
  * The bits we set in HCR:
@@ -277,11 +283,21 @@
 #define CPTR_EL2_TZ	(1 << 8)
 #define CPTR_NVHE_EL2_RES1	0x000032ff /* known RES1 bits in CPTR_EL2 (nVHE) */
 #define CPTR_EL2_DEFAULT	CPTR_NVHE_EL2_RES1
+#define CPTR_NVHE_EL2_RES0	(GENMASK(63, 32) |	\
+				 GENMASK(29, 21) |	\
+				 GENMASK(19, 14) |	\
+				 BIT(11))
 
 /* Hyp Debug Configuration Register bits */
 #define MDCR_EL2_E2TB_MASK	(UL(0x3))
 #define MDCR_EL2_E2TB_SHIFT	(UL(24))
+#define MDCR_EL2_HPMFZS		(UL(1) << 36)
+#define MDCR_EL2_HPMFZO		(UL(1) << 29)
+#define MDCR_EL2_MTPME		(UL(1) << 28)
+#define MDCR_EL2_TDCC		(UL(1) << 27)
+#define MDCR_EL2_HCCD		(UL(1) << 23)
 #define MDCR_EL2_TTRF		(UL(1) << 19)
+#define MDCR_EL2_HPMD		(UL(1) << 17)
 #define MDCR_EL2_TPMS		(UL(1) << 14)
 #define MDCR_EL2_E2PB_MASK	(UL(0x3))
 #define MDCR_EL2_E2PB_SHIFT	(UL(12))
@@ -293,6 +309,12 @@
 #define MDCR_EL2_TPM		(UL(1) << 6)
 #define MDCR_EL2_TPMCR		(UL(1) << 5)
 #define MDCR_EL2_HPMN_MASK	(UL(0x1F))
+#define MDCR_EL2_RES0		(GENMASK(63, 37) |	\
+				 GENMASK(35, 30) |	\
+				 GENMASK(25, 24) |	\
+				 GENMASK(22, 20) |	\
+				 BIT(18) |		\
+				 GENMASK(16, 15))
 
 /* For compatibility with fault code shared with 32-bit */
 #define FSC_FAULT	ESR_ELx_FSC_FAULT
-- 
2.33.0.rc1.237.g0d66db33f3-goog

