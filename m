Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4B2E74DE1E
	for <lists+kvm@lfdr.de>; Mon, 10 Jul 2023 21:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbjGJTYl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jul 2023 15:24:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbjGJTYi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jul 2023 15:24:38 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F8F81A8
        for <kvm@vger.kernel.org>; Mon, 10 Jul 2023 12:24:35 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1b8130aceefso74217035ad.2
        for <kvm@vger.kernel.org>; Mon, 10 Jul 2023 12:24:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689017075; x=1691609075;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=T195FWXfqucyEBgiIGQAY+Lmu6WGEseWSNrrUvHiu4k=;
        b=WEL8yeJBXLqzExhD6IHURdek5D4wvVU763ij1nXK8iYTaLrwHbm45oCwnW5EiOyICr
         ECOVHHRt04C8aCXCcHarD1e5tpbz/VD9139ooil7auwC5ZX9SeFEFSQJQEYvgMCiTJJT
         priMyy7eGQZOHQvWd+Rnvzdk2a6yDeqadOA2wAjDN8MohQcROJA4VCNaJhMeqzczzGNc
         Q4fO1VvryLtbUuk7JkXj6jkZV2sPZ65InW8KYpLm/PQIIg1Nyn5ZjHpKrB8rZ3myZCNl
         WhDLT/kCjBT6z1aYNMZP2KN/0p6C17+ILwBIKj2LCquGaWN+Po9fmNCZD1mreciXtBox
         ZcGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689017075; x=1691609075;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T195FWXfqucyEBgiIGQAY+Lmu6WGEseWSNrrUvHiu4k=;
        b=kKuWZuOp++k+DYJzhy99EA0jjS8eb2eHvdY+Wk+KbaFxyP7Ey7DP3isCegF0DHeRt5
         dT6zsRhjrXB8pRkPiikABkevQYtanDL9gX8PKhqc5S3lUeKghinNPxpdzSyYceVu+4d3
         LEjZjRFNvYOrHsClvDwYmUrrxsTbqQszr8/3Sih2zL/l5Zl7TFYpklVcGa67zv48Tnn4
         csvTbyeT/y2AUUFLOTkg9j8jSpqmHHSxntd46h0qLo4MK1hrlgkBaoM0pK4QtxULp9OA
         A3dl8vXYs1o/djh5F51FmqKwZ0MOP5wZE2XKD8bNTWjASdIamlGQcsIwCopgOTPO88Ms
         lC4w==
X-Gm-Message-State: ABy/qLYEprnkFy1cIDmk+GSjkptkeKF2MbRs9VfOqy2AXzEjyOCApcxA
        N2w8orAkSoja2L2ZarghtMf/5qZvf1rOwgZ+qGAFJSAoBUHA5SUPiq+fjTZwWww90i2UFf3DGXl
        46xJAXZM7m+agbO6XQyOzu2+MmXjB55MQLTqmQZbvdqL1dqpmvdkB4dlPEEZp/ncO3dHH/1k=
X-Google-Smtp-Source: APBJJlF18xsYgsI0CxYuUZH80Cwz7kk1zPTVFelfLYuD+GDrkVgWul4z+afhe2yJxGfDVGHbruy74hyRYY9cbvtPLw==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:903:41c9:b0:1b7:ef3f:5ed3 with
 SMTP id u9-20020a17090341c900b001b7ef3f5ed3mr13176575ple.5.1689017075354;
 Mon, 10 Jul 2023 12:24:35 -0700 (PDT)
Date:   Mon, 10 Jul 2023 19:24:24 +0000
In-Reply-To: <20230710192430.1992246-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230710192430.1992246-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230710192430.1992246-2-jingzhangos@google.com>
Subject: [PATCH v5 1/6] KVM: arm64: Use guest ID register values for the sake
 of emulation
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

Since KVM now supports per-VM ID registers, use per-VM ID register
values for the sake of emulation for DBGDIDR and LORegion.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/sys_regs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index bd3431823ec5..c1a5ec1a016e 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -379,7 +379,7 @@ static bool trap_loregion(struct kvm_vcpu *vcpu,
 			  struct sys_reg_params *p,
 			  const struct sys_reg_desc *r)
 {
-	u64 val = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
+	u64 val = IDREG(vcpu->kvm, SYS_ID_AA64MMFR1_EL1);
 	u32 sr = reg_to_encoding(r);
 
 	if (!(val & (0xfUL << ID_AA64MMFR1_EL1_LO_SHIFT))) {
@@ -2429,8 +2429,8 @@ static bool trap_dbgdidr(struct kvm_vcpu *vcpu,
 	if (p->is_write) {
 		return ignore_write(vcpu, p);
 	} else {
-		u64 dfr = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
-		u64 pfr = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
+		u64 dfr = IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1);
+		u64 pfr = IDREG(vcpu->kvm, SYS_ID_AA64PFR0_EL1);
 		u32 el3 = !!cpuid_feature_extract_unsigned_field(pfr, ID_AA64PFR0_EL1_EL3_SHIFT);
 
 		p->regval = ((((dfr >> ID_AA64DFR0_EL1_WRPs_SHIFT) & 0xf) << 28) |
-- 
2.41.0.255.g8b1d071c50-goog

