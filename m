Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3D5A76B879
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 17:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234145AbjHAPUa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 11:20:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234204AbjHAPUX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 11:20:23 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05C541FD6
        for <kvm@vger.kernel.org>; Tue,  1 Aug 2023 08:20:20 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-5646e695ec1so600074a12.1
        for <kvm@vger.kernel.org>; Tue, 01 Aug 2023 08:20:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690903219; x=1691508019;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=F/Zz52cr37YYz5qudyTKGXR9rwDQJucFObDOl9aUEDg=;
        b=pwD5NDzMN0ZaqAhUReAoaSGZuHJujSbu7LQv3w0SSLFlD8hdqiNKVD+AtyhpQV8ij0
         6+P3+SCydVe1MmipFZVk5u2szQuAW0uXKIuNsIXW5v9vwsp6ON4LdkrI3bsegIU1gsMU
         BZ3x7uM5DtevwpLRXdbQAW1GRNdMBW/2vECxNZi3fhHneUHoVPAKsrjiKYbAEx0wQN8R
         ihWibgBta9V0Y5j40dYn3ATvLyx8XH/6Zl/lcWQnXjM48mGjW72CuRt9U1a2C71hTyEz
         gcTT3k171nabvSthY0WO13HT+E3NkqRNTCkObhFXpZId2TcshX8zF33z/j68NvS7VQkU
         F26Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690903219; x=1691508019;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F/Zz52cr37YYz5qudyTKGXR9rwDQJucFObDOl9aUEDg=;
        b=L/VpiPeJVsqynj+B0KV6pmKTrbS08eNr+/CZ8OHOcVPJtRAJwXMbrWrlH9EgxtpARJ
         lAxnZUq9Sg5CGq7F5OErCMtEpl1quJ8XCtuSHxdouZMOqO/1IbiBNZSiOs+RQJtyrP/p
         Tg7q+yDKLMJJ0J9iIOKZJBdAm44cywTdXLm4n06dpGlFYJ7648ZdhOKP/uA22m4yBx9V
         GpYqCTBuYZ103mkXkfJKnDrKgKCvaNru0K9ie8QvaDWOlZwcwu0L+Q1bZm4j35myEeOA
         TspGP6ax5k/wfGgqGNZLHqkzPei31x1W+9JUxM1DpYT2pnZInXWfgUSxTeq9B70GZi3m
         2imw==
X-Gm-Message-State: ABy/qLZs+pd5GBrytvYHOt+qepIGiK8NjCv77DoBi+YJLrylZICqTQAA
        P8TanoPz7Vba0+M1MGLKs2jj3j42sHiaBwUAjfscgrPz84NdOnPoG+SSFOhss8p6lvmlBpFbnkn
        ePmFJ1vcJR9b4Na8Gp/0yWbXaz0+/FgqJMaQw9ntN5Depggk6paCgRifNd4tvIMhhvxsDXt0=
X-Google-Smtp-Source: APBJJlEU6slKPFvHDou8lIX/zwI3ydVRH/xm4jxxrY4DkSK02BWVfX+/WC72cAYM7HGpHk9ZmMhsP8T4jRmLclfXjA==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a63:794c:0:b0:55c:357a:95e0 with SMTP
 id u73-20020a63794c000000b0055c357a95e0mr65755pgc.6.1690903219210; Tue, 01
 Aug 2023 08:20:19 -0700 (PDT)
Date:   Tue,  1 Aug 2023 08:20:00 -0700
In-Reply-To: <20230801152007.337272-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230801152007.337272-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <20230801152007.337272-5-jingzhangos@google.com>
Subject: [PATCH v7 04/10] KVM: arm64: Reject attempts to set invalid debug
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
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
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
index 6eab45ce05d9..7fcbc317f100 100644
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
2.41.0.585.gd2178a4bd4-goog

