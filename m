Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A69C475825C
	for <lists+kvm@lfdr.de>; Tue, 18 Jul 2023 18:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbjGRQpf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 12:45:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231707AbjGRQpd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 12:45:33 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A102E10E5
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 09:45:32 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1b8a4571c1aso30890555ad.0
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 09:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689698732; x=1692290732;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cSCQIj8rChbfCOl6GeXcnV+0FBKWws4kYFyMtOPVmVQ=;
        b=OFsJK+dXwdPf0RBHA0ktO8jyJwBWRS1dwKOOctx+6jTzsxE7Cm7G+aqSattjLShdXu
         Z1qEeVo/XnXv038/OcnI7aY4yaf6gIrxk7Yu8buHeU93ihINCwy+xSarl5JDKHVGZC+M
         3Og0PhCKsDnvJjLI3hTMWIVp5uuq5wD2KrEv5IJeN8vWscPpElLbacdMXDahXUUuLz7d
         GxQzZMyPLVQndGVszsOp5ZJPzng4Dpv/fwzxPF2B7kiwaO1r9/xsTEi+b60g6UHQrIO9
         wzQl8Px7jc6UzlzwbUibnrBIsenNSSeqRnlyMjAcq0uuiL0RJEauLpErf+JQ/a9OtAnU
         6jNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689698732; x=1692290732;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cSCQIj8rChbfCOl6GeXcnV+0FBKWws4kYFyMtOPVmVQ=;
        b=UZlJ4Ro4/QX+fuywZfFXCS0sqwWrjGADIEZW8iU87piurYKyxGKlv7U9YA8hgPrN/R
         9kkuDx1HCXixesGIIwGNqSTjpiJmJFkf2eW5msyQ1lf9NHJkra1nrogvhkQ2hJ5zn8kE
         bAmi/1w8gaBB/27Pzi/ACMududcxn3Rmk9w848MwvPBUkUKqOEcWqS3zRspHCqYHbJKy
         yetMoWqRanBeNFnMN8EONhYNn0EqTaOvkIToRDdQwxwbpFfU0f9RSk+tDnooO4qw08DT
         LOENpQGywi982huDHZ6W7iiB6m9UfvSn44Tjmr4nFEhlk1ulLyvFm7fZTLyVNkalV4n2
         Jg8Q==
X-Gm-Message-State: ABy/qLbRro0cWPSXEf7wHNCww3z+7ti2qQF56tJq41SNRTNMAOhpvnh3
        KQMZCdQ7COqipbzznWflxwqia9CcYRkJPtsHoR+VPNZIss6p56rK9dXGNdQq4qZ/b6FE+PZNVmE
        8oQCH3BtMv8UEZ8OhM5bp2en8FRQg3wKebz952JcIk98NoAUEN3Uerak+wTd1MosBlPBSrnk=
X-Google-Smtp-Source: APBJJlEvf6ms5QOH822cn1EVJyhNAJK5wSXxGxatRmMDn9eETOI47IUA/zPlPUd4v3/huIcfn7gFBUTLmfU4n0bWaA==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:902:e812:b0:1ae:6895:cb96 with
 SMTP id u18-20020a170902e81200b001ae6895cb96mr1340plg.5.1689698730965; Tue,
 18 Jul 2023 09:45:30 -0700 (PDT)
Date:   Tue, 18 Jul 2023 16:45:18 +0000
In-Reply-To: <20230718164522.3498236-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230718164522.3498236-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230718164522.3498236-3-jingzhangos@google.com>
Subject: [PATCH v6 2/6] KVM: arm64: Reject attempts to set invalid debug arch version
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
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
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
 arch/arm64/kvm/sys_regs.c | 34 +++++++++++++++++++++++++++++++---
 1 file changed, 31 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c1a5ec1a016e..053d8057ff1e 100644
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
+	val = ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64DFR0_EL1, DebugVer, V8P8);
 
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
 
@@ -1528,6 +1550,8 @@ static u64 read_sanitised_id_dfr0_el1(struct kvm_vcpu *vcpu,
 	if (kvm_vcpu_has_pmu(vcpu))
 		val |= SYS_FIELD_PREP(ID_DFR0_EL1, PerfMon, perfmon);
 
+	val = ID_REG_LIMIT_FIELD_ENUM(val, ID_DFR0_EL1, CopDbg, Debugv8p8);
+
 	return val;
 }
 
@@ -1536,6 +1560,7 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 			   u64 val)
 {
 	u8 perfmon = SYS_FIELD_GET(ID_DFR0_EL1, PerfMon, val);
+	u8 copdbg = SYS_FIELD_GET(ID_DFR0_EL1, CopDbg, val);
 
 	if (perfmon == ID_DFR0_EL1_PerfMon_IMPDEF) {
 		val &= ~ID_DFR0_EL1_PerfMon_MASK;
@@ -1551,6 +1576,9 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 	if (perfmon != 0 && perfmon < ID_DFR0_EL1_PerfMon_PMUv3)
 		return -EINVAL;
 
+	if (copdbg < ID_DFR0_EL1_CopDbg_Armv8)
+		return -EINVAL;
+
 	return set_id_reg(vcpu, rd, val);
 }
 
-- 
2.41.0.255.g8b1d071c50-goog

