Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E8D975825F
	for <lists+kvm@lfdr.de>; Tue, 18 Jul 2023 18:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232389AbjGRQpj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 12:45:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232371AbjGRQpi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 12:45:38 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3228610D2
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 09:45:37 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-55c79a55650so4537599a12.0
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 09:45:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689698736; x=1692290736;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7vkCbr047ltjyeNSod64c+hA+AaA1LNd8Iy2F1bOfBE=;
        b=yDDdm3Z98ZL51ezeU3dyZisGjIZSm1scHPakb810LlPtbzZdWtSUIYn/IEOov5bS/a
         HhyaKTMZfG3GGLqUcOZEO3jWAbeBWbTi5j8vYHEICwvgbi8Qv93SV86ZXZ0R9uRIOEfU
         tfW4QxvXTLOQmrAp6N5uWwOcYGCQ1yrqQNnUXmzNz4YhAyyA4TJE3vbPvZe52JEjQ19o
         rSCyDjo7l5I7KgLtNETHDoB9SexVb9joZl0xIE+DtxXUBwwJrN0HrgEesHZL1dS3a3f9
         1WXahQMOWqNCdfgQgckue6kJBtPxpTLLOYavVWjQIXyOfD4f5EYp3T1flDKM9NrTNHJg
         ca5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689698736; x=1692290736;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7vkCbr047ltjyeNSod64c+hA+AaA1LNd8Iy2F1bOfBE=;
        b=C/JYacIE+dcSg6NtGxzMu5XoEbd2vgQoK1NAHVMDPveSj0GpespHYw/H7q3X4p7a9S
         DJ3P6J/7WbpanUvlgk/soygkA7VexdEja6U6/PA9yEppCoR1OqqSJYTbK463UuFwfhJt
         OurzSK+EwVG9pLfcHAl9MdTFDxfR2sa0hvdng/Z72oZPCEVpHQI6qwVwEG8+khK4J06K
         hDTe+nYzjlXDz0KMeUPFXJQRtvzI+QxTu/BtlQdG2IMkJ6OZ74T1zN6jjhY5WzF1z8pi
         mRFatYU5GmNe17ANXGBR/dipKLc8NtwGQQzMopBwTIc9ZOK9Mf/sWYgMwf2AyHtv6P9V
         B6Vw==
X-Gm-Message-State: ABy/qLalGZaJUIu+vy2FpnNbsWVN8KAH01n6ACx1kcgZYZq6yvK7vqmc
        Ky7jwZAfAofyKxV/ykHeCfVor+idT9jN14XO2zZN35G+GVlA890YyEznYAS757OfzOrPTzrIDan
        pOOxHpDHM/HWttb+I+n2kGiTPoS6dyaD64lvh/MCUZEU0BDKSzQelOZG+zUrNquYux6ouFd0=
X-Google-Smtp-Source: APBJJlHDDu+HxPs3scZlNF4+YoM4eumiXMxf7JemKCB4eK0aLPYXrlzf6mMhZxkgAMPgiQBQLnY7YjFAQ4oSoy0Zbw==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a05:6a00:158e:b0:677:c9da:14b6 with
 SMTP id u14-20020a056a00158e00b00677c9da14b6mr159486pfk.4.1689698736287; Tue,
 18 Jul 2023 09:45:36 -0700 (PDT)
Date:   Tue, 18 Jul 2023 16:45:21 +0000
In-Reply-To: <20230718164522.3498236-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230718164522.3498236-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230718164522.3498236-6-jingzhangos@google.com>
Subject: [PATCH v6 5/6] KVM: arm64: Enable writable for ID_AA64MMFR{0, 1, 2, 3}_EL1
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

Enable writable from userspace for ID_AA64MMFR{0, 1, 2, 3}_EL1.
Added a macro for defining general writable idregs.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/sys_regs.c | 38 +++++++++++++++++++++++++++++++-------
 1 file changed, 31 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 12b81ab27dbe..d560fc178a76 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1346,9 +1346,6 @@ static u64 __kvm_read_sanitised_id_reg(const struct kvm_vcpu *vcpu,
 			val &= ~ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1_WFxT);
 		val &= ~ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1_MOPS);
 		break;
-	case SYS_ID_AA64MMFR2_EL1:
-		val &= ~ID_AA64MMFR2_EL1_CCIDX_MASK;
-		break;
 	case SYS_ID_MMFR4_EL1:
 		val &= ~ARM64_FEATURE_MASK(ID_MMFR4_EL1_CCIDX);
 		break;
@@ -1582,6 +1579,18 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 	return set_id_reg(vcpu, rd, val);
 }
 
+static u64 read_sanitised_id_aa64mmfr2_el1(struct kvm_vcpu *vcpu,
+					   const struct sys_reg_desc *rd)
+{
+	u64 val;
+	u32 id = reg_to_encoding(rd);
+
+	val = read_sanitised_ftr_reg(id);
+	val &= ~ID_AA64MMFR2_EL1_CCIDX_MASK;
+
+	return val;
+}
+
 /*
  * cpufeature ID register user accessors
  *
@@ -1856,6 +1865,16 @@ static unsigned int elx2_visibility(const struct kvm_vcpu *vcpu,
 	.val = 0,				\
 }
 
+#define ID_SANITISED_WRITABLE(name) {		\
+	SYS_DESC(SYS_##name),			\
+	.access	= access_id_reg,		\
+	.get_user = get_id_reg,			\
+	.set_user = set_id_reg,			\
+	.visibility = id_visibility,		\
+	.reset = kvm_read_sanitised_id_reg,	\
+	.val = GENMASK(63, 0),			\
+}
+
 /* sys_reg_desc initialiser for known cpufeature ID registers */
 #define AA32_ID_SANITISED(name) {		\
 	SYS_DESC(SYS_##name),			\
@@ -2077,10 +2096,15 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	ID_UNALLOCATED(6,7),
 
 	/* CRm=7 */
-	ID_SANITISED(ID_AA64MMFR0_EL1),
-	ID_SANITISED(ID_AA64MMFR1_EL1),
-	ID_SANITISED(ID_AA64MMFR2_EL1),
-	ID_SANITISED(ID_AA64MMFR3_EL1),
+	ID_SANITISED_WRITABLE(ID_AA64MMFR0_EL1),
+	ID_SANITISED_WRITABLE(ID_AA64MMFR1_EL1),
+	{ SYS_DESC(SYS_ID_AA64MMFR2_EL1),
+	  .access = access_id_reg,
+	  .get_user = get_id_reg,
+	  .set_user = set_id_reg,
+	  .reset = read_sanitised_id_aa64mmfr2_el1,
+	  .val = GENMASK(63, 0), },
+	ID_SANITISED_WRITABLE(ID_AA64MMFR3_EL1),
 	ID_UNALLOCATED(7,4),
 	ID_UNALLOCATED(7,5),
 	ID_UNALLOCATED(7,6),
-- 
2.41.0.255.g8b1d071c50-goog

