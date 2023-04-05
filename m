Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDE6F6D84C7
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 19:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232579AbjDERWE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 13:22:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232832AbjDERWB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 13:22:01 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8CB05FF7
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 10:21:56 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id s4-20020a170902ea0400b001a1f4137086so21345903plg.14
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 10:21:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680715316;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UvpttxDeu38t6uCXwtc4ExjJWc8qq+r7jPXfQje5vdU=;
        b=NzvbConKRfZmjeRYY4ZIKW7d6n/06Bcqi2jzYI0bLEaoiJmlJ4wOm3OBaRZMMQMY29
         VtPMCSTH2RqjKqVLc1IOrdvK1P1aar/cEXzWCSKgK5VwaRU/nrA3OYr1g1NTFzj4GUfk
         T3Ge3uzp7ymc94n04CcSKcwcMum1Ogl16KCZxyo7nj85dOXg9qDhP9hB1ln0bv7HWy+h
         aErsiBjHczmUrUGLkJqfjbpIAIcS69dLPa/eRn5elxvQWuv5CjVdQmgAPgHPd4YO2lzE
         WE6cTtzWvTvEVFvWrC7UR2RlUqnsKbSmJ3F8VcMqdp8ynmpgOknsKuKeZNuc5F3jU6C7
         kZug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680715316;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UvpttxDeu38t6uCXwtc4ExjJWc8qq+r7jPXfQje5vdU=;
        b=n0pQqVHWOmwy88YaE5HyXg+d7rHhe2LXzycX0NF5T4k3uOGmNeJ759bjfnf9BEBGfF
         /+uK3y5iEwAyXs70JNDzR6ogIAaSLVOd41Dria+OTZVH9ukLwFVdXOV4WhdWXe/WDs0L
         XU/575V5nGdpwPzsmffVS3LwZt6W4LXBIh9vFbCyHpDFr5DUgkWvBlj3wlCVnbQZPHUb
         cbQ3d7mIoo3bBqU+UmXyLG/85edZFmYP5cDuztadd0deEGq9UrnEMlj5zK4IN9r7KClE
         eJVJuNdedcBuqtvF2CN4E6uGnWZW+T0ETdLZq8c1d1MPAl8tKrkgW9jW92aNVQvVbOW9
         Mrig==
X-Gm-Message-State: AAQBX9dCAhVb/pygSzG2WE+azYtvKcTKB6mfJBuOn6tjyupbVl6dhhMu
        M0hUeD61a602wI5q8+Qc/CnY9g2uT5nyes1CTtW9GqwLaIeB7dKukReXguO36XNEE/5wBk+tYPl
        a5ynRrDcUucPVz/mQw0qJsSwBiXV+wSOXSTSGvvCi5M1N6ekhStoa1gCxprIO4GOiNBKneb0=
X-Google-Smtp-Source: AKy350akcsU16jl5QYSPwfchNud01UBUPV/zdN8kiaHxCRLdIPkOCGbugdWzGITNVuofppPsBCQDKnUCU0vQzaZ5JA==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a05:6a00:988:b0:5e6:f9a1:e224 with
 SMTP id u8-20020a056a00098800b005e6f9a1e224mr3886627pfg.6.1680715315928; Wed,
 05 Apr 2023 10:21:55 -0700 (PDT)
Date:   Wed,  5 Apr 2023 17:21:46 +0000
In-Reply-To: <20230405172146.297208-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230405172146.297208-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230405172146.297208-5-jingzhangos@google.com>
Subject: [PATCH v3 4/4] KVM: arm64: Enable writable for ID_AA64MMFR{0, 1, 2}_EL1
From:   Jing Zhang <jingzhangos@google.com>
To:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@google.com>
Cc:     Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enable writable from userspace for ID_AA64MMFR{0, 1, 2}_EL1.
Added a macro for defining general writable idregs.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/id_regs.c | 36 ++++++++++++++++++++++++++++++------
 1 file changed, 30 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
index 20d1a2d2a0cc..29e344d3c8be 100644
--- a/arch/arm64/kvm/id_regs.c
+++ b/arch/arm64/kvm/id_regs.c
@@ -164,9 +164,6 @@ u64 kvm_arm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
 		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon),
 				  pmuver_to_perfmon(vcpu_pmuver(vcpu)));
 		break;
-	case SYS_ID_AA64MMFR2_EL1:
-		val &= ~ID_AA64MMFR2_EL1_CCIDX_MASK;
-		break;
 	case SYS_ID_MMFR4_EL1:
 		val &= ~ARM64_FEATURE_MASK(ID_MMFR4_EL1_CCIDX);
 		break;
@@ -488,6 +485,18 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 	return 0;
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
  * Since reset() callback and field val are not used for idregs, they will be
  * used for specific purposes for idregs.
@@ -510,6 +519,16 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 	.val = 0,				\
 }
 
+#define ID_SANITISED_WRITABLE(name) {		\
+	SYS_DESC(SYS_##name),			\
+	.access	= access_id_reg,		\
+	.get_user = get_id_reg,			\
+	.set_user = set_id_reg,			\
+	.visibility = id_visibility,		\
+	.reset = general_read_kvm_sanitised_reg,\
+	.val = GENMASK(63, 0),			\
+}
+
 /* sys_reg_desc initialiser for known cpufeature ID registers */
 #define AA32_ID_SANITISED(name) {		\
 	SYS_DESC(SYS_##name),			\
@@ -636,9 +655,14 @@ const struct sys_reg_desc id_reg_descs[KVM_ARM_ID_REG_NUM] = {
 	ID_UNALLOCATED(6, 7),
 
 	/* CRm=7 */
-	ID_SANITISED(ID_AA64MMFR0_EL1),
-	ID_SANITISED(ID_AA64MMFR1_EL1),
-	ID_SANITISED(ID_AA64MMFR2_EL1),
+	ID_SANITISED_WRITABLE(ID_AA64MMFR0_EL1),
+	ID_SANITISED_WRITABLE(ID_AA64MMFR1_EL1),
+	{ SYS_DESC(SYS_ID_AA64MMFR2_EL1),
+	  .access = access_id_reg,
+	  .get_user = get_id_reg,
+	  .set_user = set_id_reg,
+	  .reset = read_sanitised_id_aa64mmfr2_el1,
+	  .val = GENMASK(63, 0), },
 	ID_UNALLOCATED(7, 3),
 	ID_UNALLOCATED(7, 4),
 	ID_UNALLOCATED(7, 5),
-- 
2.40.0.348.gf938b09366-goog

