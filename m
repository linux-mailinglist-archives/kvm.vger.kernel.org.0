Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86D417834D4
	for <lists+kvm@lfdr.de>; Mon, 21 Aug 2023 23:22:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbjHUVW7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Aug 2023 17:22:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230038AbjHUVW4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Aug 2023 17:22:56 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22CADF3
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 14:22:55 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-5659b9ae3ebso4010900a12.1
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 14:22:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692652974; x=1693257774;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MXfGcvHnrV8S9zRO9Bsrfmw8dC1LaW1sFLJCfI+pK2A=;
        b=jtoqkcm66LalS3kbEpe2aa1AzZH6iqnCu3v79V3VYfzejtR8C1xS5a+JygUMBrXTfP
         3vd5aOrV7YJ1LD2prB477eBuLLFsM3TMW8jFp67NJ4FTJB63ui1vH9ZiL2gGTPomUmbt
         q1fj1qUMSO0KoCusjxrIWL6/WW6BbYqqf3I3kEfUKDeUWzAvxhWPt4MBCV1CbvjtC1fx
         qnCzRC/sZgyHP6lFWSbHfsgkPIFP0pDYKPeevvdVfBW6y1wLysfEYLe/qMAKtH3T/sxR
         6yH4NhAiddBBTax+LP8j5eYqBE4+xkrS0qom+bA1Ij3mf4Hu/8LF64hNMDhj4PQl3ZDN
         FitA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692652974; x=1693257774;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MXfGcvHnrV8S9zRO9Bsrfmw8dC1LaW1sFLJCfI+pK2A=;
        b=eXYnLGVq1wKpVTfhx8KdXVxs1M3pDbWOsvr/+lZawZxqjpsrYIulkOGrN+uCgHXrwK
         O1ovVdkRotpAEH3GL3huKqNJ6lQQF2L0NxUCPeaRwMle5ldSFJnOR7bpBEXSYnkh0Dvl
         +TSY5W5lsTu3kfk5aRPpPIAcfw9PIpeNniGZHH2nlcszc9/o45Ul0NUwq/GxXx2d9ayn
         efnhuFooz0Av7fS030ID5Fryx+TqZkZRqql80a5EFr8VOT8PQKaPUjx2wnPASdIdQW3X
         WnjxScjrhCyW++m9fnZOkObGl/YxktEpj54Ga6EN1v0uKemhhtXLF4ikIOeupBR4R8SW
         jB8g==
X-Gm-Message-State: AOJu0YwU+dhW4dQse+JbTqrdLtS5qjq4n0MU3e2hgUx43WDJliRQtL8y
        CpLuwXcgQf1NDVl98625E+oxDFdTM1RDG03+n6cLzJoaPJLiPvhUcndQcrlsmlVJ0GKWR7PkxL3
        emygY7V+fFMy0+osnT+OtVdUpKdaxqcttwInxX63f5dGm8pBC2PWKKPk24TfbFiF6CGR4sHI=
X-Google-Smtp-Source: AGHT+IGcMeKikR30UgqAPn7XnN7bWajJTeQ74B+zyCETF1yUbUuLnyIdcf6/vCoZva7LorprnBBEYmtK7U29axiYoA==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a63:7b02:0:b0:56b:b9b1:34e2 with SMTP
 id w2-20020a637b02000000b0056bb9b134e2mr753451pgc.11.1692652974552; Mon, 21
 Aug 2023 14:22:54 -0700 (PDT)
Date:   Mon, 21 Aug 2023 14:22:36 -0700
In-Reply-To: <20230821212243.491660-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230821212243.491660-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
Message-ID: <20230821212243.491660-5-jingzhangos@google.com>
Subject: [PATCH v9 04/11] KVM: arm64: Reject attempts to set invalid debug
 arch version
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
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Suraj Jitindar Singh <surajjs@amazon.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Shaoqin Huang <shahuang@redhat.com>,
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
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
index 42c4d71f40f3..afade7186675 100644
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
@@ -1469,14 +1475,22 @@ static u64 read_sanitised_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
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
@@ -1496,6 +1510,7 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 			       const struct sys_reg_desc *rd,
 			       u64 val)
 {
+	u8 debugver = SYS_FIELD_GET(ID_AA64DFR0_EL1, DebugVer, val);
 	u8 pmuver = SYS_FIELD_GET(ID_AA64DFR0_EL1, PMUVer, val);
 
 	/*
@@ -1515,6 +1530,13 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
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
 
@@ -1536,6 +1558,7 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 			   u64 val)
 {
 	u8 perfmon = SYS_FIELD_GET(ID_DFR0_EL1, PerfMon, val);
+	u8 copdbg = SYS_FIELD_GET(ID_DFR0_EL1, CopDbg, val);
 
 	if (perfmon == ID_DFR0_EL1_PerfMon_IMPDEF) {
 		val &= ~ID_DFR0_EL1_PerfMon_MASK;
@@ -1551,6 +1574,9 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 	if (perfmon != 0 && perfmon < ID_DFR0_EL1_PerfMon_PMUv3)
 		return -EINVAL;
 
+	if (copdbg < ID_DFR0_EL1_CopDbg_Armv8)
+		return -EINVAL;
+
 	return set_id_reg(vcpu, rd, val);
 }
 
-- 
2.42.0.rc1.204.g551eb34607-goog

