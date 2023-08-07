Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 459B6772A7C
	for <lists+kvm@lfdr.de>; Mon,  7 Aug 2023 18:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231470AbjHGQW2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Aug 2023 12:22:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231461AbjHGQW0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Aug 2023 12:22:26 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B457E10EC
        for <kvm@vger.kernel.org>; Mon,  7 Aug 2023 09:22:22 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d1c693a29a0so5546413276.1
        for <kvm@vger.kernel.org>; Mon, 07 Aug 2023 09:22:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691425342; x=1692030142;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=R4CrS57Ui+vIH37q2fjm0JOhC2MTgvKnwusSkAjV8jA=;
        b=jRz3kS/PNv/xzBk6N/rbGseVKSKOKf1VGGXgSb1zGe0UHTesmPZR0GPVJqULks/Wc+
         GXrM6sybQ3K32tlW/gM5hztC7/b4IPk0WDIJdOcZA5kDeGXHK32jcaahZEGzEuYmlNEI
         k+BhpeQsrjnlitICTF8XMT14Lg4en1ZFt5XgR34GqKqhK/4x7f1liO73OXNAW5/bgbAu
         8CaUaJbdCJgFviZudb0t0hcDpaDMg1OLJ03wUEefMY19oktJGSaiT+kI6Y9a7pZ+X1Yn
         pq81nmlk07aP7Gj6Dpv1dRFHt/aBsjmOAu50iVIu3Rl6rvGVkTsMGGKXVSNBRqYh1m43
         17+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691425342; x=1692030142;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R4CrS57Ui+vIH37q2fjm0JOhC2MTgvKnwusSkAjV8jA=;
        b=fSJ7IoumBY4PyOHS693t/GnTan4vUGJBMo8jpyjtFD+dcVjjYeXtUQL+3B6rYyTyQX
         32srHJb1Agz9+GHlmAZFJgyF4PIstMeguY4hNEDgCw+SU/MwJvAh0+nbjn00p+pQe2vj
         3HiUM836qFRhyYQ1+j7nidhRtE0KHddgg5BoQt6srzKQHHN+iDW4cG8BSWWpXOs9xyMx
         fE0ZmPsHCNihT+gykM+P+QasXUeWNXfxdHRhKrPvC4xt31+fNGa7IQxHmY82xwXwURYU
         dGMtnQKcst/y0DISbrEbanzBsm+Ppto10fdIZXOYSJz9lAZ7sBtVQXei9mkATGlovP0D
         zS7g==
X-Gm-Message-State: AOJu0YypNN/1EAEJKNH+7DUSAGIpGiEnx/bXPf+dr1HMynckMEeSuCSP
        9/fmzVUHKk7jL5W39x7TEghB1/V2TwdP78L6JqRbtz31C3fQUxbFYfjtHEkXVrj8DWNkDP4rHAy
        4voGGc+WJsfqF3zm+eSE0bOYto21AMY1cd6VWBc5aQyOeKDHI1IFZ57hHLb56j2KKmeUFjAU=
X-Google-Smtp-Source: AGHT+IFcW3NYSpTHuaXEbU99GJKjTIW+9gY5XfepG2W3dguUnNeSlbldFbAPdu5CzYltlS4EiP4aPTE/QkExspiISQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a25:23d6:0:b0:d4c:f456:d54f with SMTP
 id j205-20020a2523d6000000b00d4cf456d54fmr32902ybj.8.1691425341466; Mon, 07
 Aug 2023 09:22:21 -0700 (PDT)
Date:   Mon,  7 Aug 2023 09:22:02 -0700
In-Reply-To: <20230807162210.2528230-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230807162210.2528230-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <20230807162210.2528230-5-jingzhangos@google.com>
Subject: [PATCH v8 04/11] KVM: arm64: Reject attempts to set invalid debug
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
2.41.0.585.gd2178a4bd4-goog

