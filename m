Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9797A6A2E
	for <lists+kvm@lfdr.de>; Tue, 19 Sep 2023 19:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232290AbjISRu6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Sep 2023 13:50:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232935AbjISRuq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Sep 2023 13:50:46 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60062CC3
        for <kvm@vger.kernel.org>; Tue, 19 Sep 2023 10:50:33 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id 98e67ed59e1d1-2746ce771f7so4264116a91.1
        for <kvm@vger.kernel.org>; Tue, 19 Sep 2023 10:50:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695145833; x=1695750633; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WDqS9gCK2hWJbMjalAxBpmnQXFt//tHeeybGxVMKHYk=;
        b=lMTmNEnz2Ppt85oaRrXLphKyQu2r6rLKdcC4x/r9LmdMoKBb145+agyYkwSmW4MxXg
         kG9werJRuD8xvp5bfmA2SuJUDrnvB3lblEwJ7ivQBoBQi52PbzxIOlLkolkTqj1ztdj/
         Z9A45hZpQNDSRxxOXUb/4YLoL6mptHvja7XfmCcyWpz0j3n4N40ULygNVlTENPD0uASL
         /4xIxdo6Pyi5f5CyAQ0d4BkMNwXpjOplg0y7/DKWCWu1oQ6Zk5u22LFiLYHnttnj7CW3
         t+shNYhdheLx4MP9mwTzESJUmpCejYV4KIGsI7Z+hvCAKhCSoOslxg4V1x4iYuDmvi3V
         8jig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695145833; x=1695750633;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WDqS9gCK2hWJbMjalAxBpmnQXFt//tHeeybGxVMKHYk=;
        b=KgJxBvdVL/XL3pHPdYNUcahMHqNwCWMSYnqzPkH/ya1cThUF2LVKTOrLJsZsjNo+XB
         RGUZBOi0dSc3EOOYvWwZ41ALGN011DLvktUST1IozMmj5G1MBaKoYkFLyHvlQTciIJed
         hQhVaRfFuTC3rXc7Us4Asv1AgultDVUAr1HeF9J27VnuWuLXm7Mom9RNMUEk2W/Y784Y
         4komMcEfj2ND+m5LLshfvEf+JgafWstu1diSX0V6D+X7kwx5X8ybW6gaSrxyCuO1a7tW
         C7K2KarKpK5mlBV8dvdobp3MTsCtgkvlXr66dfPRtHmnPI8BDq2eBjNZSSTYBhl0RKuY
         Uo0Q==
X-Gm-Message-State: AOJu0YxReS7ap5kYLN7BnSnxc/ZFoVoEM6eDlH55o+8JO7Uwq+kp46tz
        mGgdJTgmH0febjgQc9ier64J/S4rtDngHXbKiZq6If2E+xw4mFd0PYo+DN99xA3ytY8vAlema7r
        0rrOBZNV4NJ/SuhRZ19SdJlKQmFfJ26SkKwQG4qoOr18CVzyHiO3rg/HddVML9Oc03hiXZIs=
X-Google-Smtp-Source: AGHT+IFN34HCsWwHcm0VPaYd7vZlKFFWGc9Vo3Vmh+MXi2TsekzYPzoQupklZxM0iu6EWzoGRPjs/bXawpslssLVYQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:90a:fa12:b0:268:1d63:b9ae with
 SMTP id cm18-20020a17090afa1200b002681d63b9aemr8189pjb.3.1695145831933; Tue,
 19 Sep 2023 10:50:31 -0700 (PDT)
Date:   Tue, 19 Sep 2023 10:50:16 -0700
In-Reply-To: <20230919175017.538312-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230919175017.538312-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.42.0.459.ge4e396fd5e-goog
Message-ID: <20230919175017.538312-5-jingzhangos@google.com>
Subject: [PATCH v1 4/4] KVM: arm64: Reject attempts to set invalid debug arch version
From:   Jing Zhang <jingzhangos@google.com>
To:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>
Cc:     Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Suraj Jitindar Singh <surajjs@amazon.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Shaoqin Huang <shahuang@redhat.com>,
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Oliver Upton <oliver.upton@linux.dev>

The debug architecture is mandatory in ARMv8, so KVM should not allow
userspace to configure a vCPU with less than that. Of course, this isn't
handled elegantly by the generic ID register plumbing, as the respective
ID register fields have a nonzero starting value.

Add an explicit check for debug versions less than v8 of the
architecture.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/sys_regs.c | 32 +++++++++++++++++++++++++++++---
 1 file changed, 29 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 4dcc9272fbb8..fdebd9d042c3 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1216,8 +1216,14 @@ static s64 kvm_arm64_ftr_safe_value(u32 id, const struct arm64_ftr_bits *ftrp,
 	/* Some features have different safe value type in KVM than host features */
 	switch (id) {
 	case SYS_ID_AA64DFR0_EL1:
-		if (kvm_ftr.shift == ID_AA64DFR0_EL1_PMUVer_SHIFT)
+		switch (kvm_ftr.shift) {
+		case ID_AA64DFR0_EL1_PMUVer_SHIFT:
 			kvm_ftr.type = FTR_LOWER_SAFE;
+			break;
+		case ID_AA64DFR0_EL1_DebugVer_SHIFT:
+			kvm_ftr.type = FTR_LOWER_SAFE;
+			break;
+		}
 		break;
 	case SYS_ID_DFR0_EL1:
 		if (kvm_ftr.shift == ID_DFR0_EL1_PerfMon_SHIFT)
@@ -1476,14 +1482,22 @@ static u64 read_sanitised_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 	return val;
 }
 
+#define ID_REG_LIMIT_FIELD_ENUM(val, reg, field, limit)			       \
+({									       \
+	u64 __f_val = FIELD_GET(reg##_##field##_MASK, val);		       \
+	(val) &= ~reg##_##field##_MASK;					       \
+	(val) |= FIELD_PREP(reg##_##field##_MASK,			       \
+			min(__f_val, (u64)reg##_##field##_##limit));	       \
+	(val);								       \
+})
+
 static u64 read_sanitised_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 					  const struct sys_reg_desc *rd)
 {
 	u64 val = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
 
 	/* Limit debug to ARMv8.0 */
-	val &= ~ID_AA64DFR0_EL1_DebugVer_MASK;
-	val |= SYS_FIELD_PREP_ENUM(ID_AA64DFR0_EL1, DebugVer, IMP);
+	val = ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64DFR0_EL1, DebugVer, IMP);
 
 	/*
 	 * Only initialize the PMU version if the vCPU was configured with one.
@@ -1503,6 +1517,7 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 			       const struct sys_reg_desc *rd,
 			       u64 val)
 {
+	u8 debugver = SYS_FIELD_GET(ID_AA64DFR0_EL1, DebugVer, val);
 	u8 pmuver = SYS_FIELD_GET(ID_AA64DFR0_EL1, PMUVer, val);
 
 	/*
@@ -1522,6 +1537,13 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 	if (pmuver == ID_AA64DFR0_EL1_PMUVer_IMP_DEF)
 		val &= ~ID_AA64DFR0_EL1_PMUVer_MASK;
 
+	/*
+	 * ID_AA64DFR0_EL1.DebugVer is one of those awkward fields with a
+	 * nonzero minimum safe value.
+	 */
+	if (debugver < ID_AA64DFR0_EL1_DebugVer_IMP)
+		return -EINVAL;
+
 	return set_id_reg(vcpu, rd, val);
 }
 
@@ -1543,6 +1565,7 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 			   u64 val)
 {
 	u8 perfmon = SYS_FIELD_GET(ID_DFR0_EL1, PerfMon, val);
+	u8 copdbg = SYS_FIELD_GET(ID_DFR0_EL1, CopDbg, val);
 
 	if (perfmon == ID_DFR0_EL1_PerfMon_IMPDEF) {
 		val &= ~ID_DFR0_EL1_PerfMon_MASK;
@@ -1558,6 +1581,9 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 	if (perfmon != 0 && perfmon < ID_DFR0_EL1_PerfMon_PMUv3)
 		return -EINVAL;
 
+	if (copdbg < ID_DFR0_EL1_CopDbg_Armv8)
+		return -EINVAL;
+
 	return set_id_reg(vcpu, rd, val);
 }
 
-- 
2.42.0.459.ge4e396fd5e-goog

