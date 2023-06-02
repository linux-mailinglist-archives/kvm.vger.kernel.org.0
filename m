Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEC6771F779
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 03:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233149AbjFBBDi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 21:03:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231407AbjFBBDg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 21:03:36 -0400
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3D2D128
        for <kvm@vger.kernel.org>; Thu,  1 Jun 2023 18:03:34 -0700 (PDT)
Received: by mail-qv1-xf31.google.com with SMTP id 6a1803df08f44-6261a61b38cso13680166d6.1
        for <kvm@vger.kernel.org>; Thu, 01 Jun 2023 18:03:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685667814; x=1688259814;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=fifPbYRt7uf4jrnxrsmNmTUn9mTwVSfuWFw3+q4TwW4=;
        b=e7RU9qqs4L6U85i40ME9dyzQJXpwlCftOi1R9nWukod3Agcnhs30TAxD8LtgeLlujq
         kKB9XNk6rVLc7GEWpfsTGBfKy0T89eE24XValGAPK9hnMIoC8mX7Fc5u5kDaCHucKy6k
         d2vXW9xHCEiPQRbWx4sChy4Q6nPxWc8lNLzaX3Bi+KPrwLimAJvH/b846GYEERefarUT
         P6z61PBGyWsUoG006Yz6zD9sEnI5OgYdh2uabGHNtt5Rgk2LwM0m9m/qVdDGf6wDelWf
         xRTNowpsmSkzbjL28pGaHUoGCOskLub7pwtzjedwZZfcEeSylZ0ZtjrDgZ/o4xepZA1i
         AAtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685667814; x=1688259814;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fifPbYRt7uf4jrnxrsmNmTUn9mTwVSfuWFw3+q4TwW4=;
        b=EwY8ysJ7Kg0jV6Bpcl0199KpLPSASSpIjPtMCcvMGjlChnbJ8zVNP3sHISI5lSp7pj
         eOofVfD8pH2J4dhXVyfOE5zd1lfwNh/42AUaMEqDoszsbLo4rDq+c69KHb1X1EXzVamy
         KaKtXuTrhZD/OhIabcD/9zWH18LccH7mNvVPugALcRH/iC8CO0pU9FRWY4A/XLdXx+Jc
         nLjxkW5y+LAcXBJxjG4IW0RXEsQbTdUuEIbMANJZwdug38tnTSQQCqLvVDlZUB4GBSDg
         Qkx9JEyBGlhrRsIj21uq73SkK+323f9RbbofZzedk6gMaU9T/jTgEKBcZbutwjqQz2Gr
         rhbA==
X-Gm-Message-State: AC+VfDwt5EOVQVGgFR+CDBKoqibutcqYOgJQAVZeLonCADvYsK0Tf0SC
        5tQmmQoViDKk25gNWSY3itU=
X-Google-Smtp-Source: ACHHUZ5T0KF0cSCpFqB8uSg5fYLmyxjn0HPTgo4HHSq2D++cg5aR8NqChT+OJzQ/G+ItyXaZREE0zQ==
X-Received: by 2002:a05:6214:1c4a:b0:61a:197b:605 with SMTP id if10-20020a0562141c4a00b0061a197b0605mr15130271qvb.1.1685667813695;
        Thu, 01 Jun 2023 18:03:33 -0700 (PDT)
Received: from [192.168.201.150] (54-240-198-32.amazon.com. [54.240.198.32])
        by smtp.googlemail.com with ESMTPSA id v8-20020ac873c8000000b003f0af201a2dsm82285qtp.81.2023.06.01.18.03.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jun 2023 18:03:33 -0700 (PDT)
Message-ID: <cdbbd0d45079d58afcc92318114f04e2a43f0fd7.camel@gmail.com>
Subject: Re: [PATCH v9 5/5] KVM: arm64: Refactor writings for
 PMUVer/CSV2/CSV3
From:   Suraj Jitindar Singh <sjitindarsingh@gmail.com>
To:     Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>,
        KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@google.com>
Cc:     Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Suraj Jitindar Singh <surajjs@amazon.com>
Date:   Thu, 01 Jun 2023 18:03:30 -0700
In-Reply-To: <20230517061015.1915934-6-jingzhangos@google.com>
References: <20230517061015.1915934-1-jingzhangos@google.com>
         <20230517061015.1915934-6-jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu1 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

With the patch set you posted I get some kvm unit tests failures due to
being unable to update register values from userspace. I propose the
following patch as a solution:

[PATCH 1/2] KVM: arm64: Update id_reg limit value based on per vcpu
 flags

There are multiple features the availability of which is
enabled/disabled
and tracked on a per vcpu level in vcpu->arch.flagset e.g. sve,
ptrauth,
and pmu. While the vm wide value of the id regs which represent the
availability of these features is stored in the id_regs kvm struct
their
value needs to be manipulated on a per vcpu basis. This is done at read
time in kvm_arm_read_id_reg().

The value of these per vcpu flags needs to be factored in when
calculating
the id_reg limit value in check_features() as otherwise we can run into
the
following scenario.

[ running on cpu which supports sve ]
1. AA64PFR0.SVE set in id_reg by kvm_arm_init_id_regs() (cpu supports
it
   and so is set in value returned from read_sanitised_ftr_reg())
2. vcpus created without sve feature enabled
3. vmm reads AA64PFR0 and attempts to write the same value back
   (writing the same value back is allowed)
4. write fails in check_features() as limit has AA64PFR0.SVE set
however it
   is not set in the value being written and although a lower value is
   allowed for this feature it is not in the mask of bits which can be
   modified and so much match exactly.

Thus add a step in check_features() to update the limit returned from
id_reg->reset() with the per vcpu features which may have been
enabled/disabled at vcpu creation time after the id_regs were
initialised.
Split this update into a new function named kvm_arm_update_id_reg() so
it
can be called from check_features() as well as kvm_arm_read_id_reg() to
dedup code.

While we're here there are features which are masked in
kvm_arm_update_id_reg() which cannot change through out a vms
lifecycle.
Thus rather than masking them each time the register is read, mask them
at
id_reg init time so that the value in the kvm id_reg reflects the state
of
support for that feature.
Move masking of AA64PFR0_EL1.GIC and AA64PFR0_EL1.AMU into
read_sanitised_id_aa64pfr0_el1().
Create read_sanitised_id_aa64pfr1_el1() and mask AA64PFR1_EL1.SME.
Create read_sanitised_id_[mmfr4|aa64mmfr2] and mask CCIDX.

Finally remove set_id_aa64pfr0_el1() as all it does is mask
AA64PFR0_EL1_CS[2|3]. The limit for these fields is already set
according
to cpu support in read_sanitised_id_aa64pfr0_el1() and then checked
when
writing the register in check_features() as such there is no need to
perform the check twice.

Signed-off-by: Suraj Jitindar Singh <surajjs@amazon.com>
---
 arch/arm64/kvm/sys_regs.c | 113 ++++++++++++++++++++++++--------------
 1 file changed, 73 insertions(+), 40 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index bec02ba45ee7..ca793cd692fe 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -42,6 +42,7 @@
  */
=20
 static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc
*rd, u64 val);
+static u64 kvm_arm_update_id_reg(const struct kvm_vcpu *vcpu, u32 id,
u64 val);
 static u64 kvm_arm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id);
 static u64 sys_reg_to_index(const struct sys_reg_desc *reg);
=20
@@ -1241,6 +1242,7 @@ static int arm64_check_features(struct kvm_vcpu
*vcpu,
 	/* For hidden and unallocated idregs without reset, only val =3D
0 is allowed. */
 	if (rd->reset) {
 		limit =3D rd->reset(vcpu, rd);
+		limit =3D kvm_arm_update_id_reg(vcpu, id, limit);
 		ftr_reg =3D get_arm64_ftr_reg(id);
 		if (!ftr_reg)
 			return -EINVAL;
@@ -1317,24 +1319,17 @@ static u64
general_read_kvm_sanitised_reg(struct kvm_vcpu *vcpu, const struct sy
 	return read_sanitised_ftr_reg(reg_to_encoding(rd));
 }
=20
-static u64 kvm_arm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
+/* Provide an updated value for an ID register based on per vcpu flags
*/
+static u64 kvm_arm_update_id_reg(const struct kvm_vcpu *vcpu, u32 id,
u64 val)
 {
-	u64 val =3D IDREG(vcpu->kvm, id);
-
 	switch (id) {
 	case SYS_ID_AA64PFR0_EL1:
 		if (!vcpu_has_sve(vcpu))
 			val &=3D
~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_SVE);
-		if (kvm_vgic_global_state.type =3D=3D VGIC_V3) {
-			val &=3D
~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_GIC);
-			val |=3D
FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_GIC), 1);
-		}
 		break;
 	case SYS_ID_AA64PFR1_EL1:
 		if (!kvm_has_mte(vcpu->kvm))
 			val &=3D
~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_MTE);
-
-		val &=3D ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_SME);
 		break;
 	case SYS_ID_AA64ISAR1_EL1:
 		if (!vcpu_has_ptrauth(vcpu))
@@ -1347,8 +1342,6 @@ static u64 kvm_arm_read_id_reg(const struct
kvm_vcpu *vcpu, u32 id)
 		if (!vcpu_has_ptrauth(vcpu))
 			val &=3D
~(ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1_APA3) |
 			=09
ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1_GPA3));
-		if (!cpus_have_final_cap(ARM64_HAS_WFXT))
-			val &=3D
~ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1_WFxT);
 		break;
 	case SYS_ID_AA64DFR0_EL1:
 		/* Set PMUver to the required version */
@@ -1361,17 +1354,18 @@ static u64 kvm_arm_read_id_reg(const struct
kvm_vcpu *vcpu, u32 id)
 		val |=3D
FIELD_PREP(ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon),
 				=20
pmuver_to_perfmon(vcpu_pmuver(vcpu)));
 		break;
-	case SYS_ID_AA64MMFR2_EL1:
-		val &=3D ~ID_AA64MMFR2_EL1_CCIDX_MASK;
-		break;
-	case SYS_ID_MMFR4_EL1:
-		val &=3D ~ARM64_FEATURE_MASK(ID_MMFR4_EL1_CCIDX);
-		break;
 	}
=20
 	return val;
 }
=20
+static u64 kvm_arm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
+{
+	u64 val =3D IDREG(vcpu->kvm, id);
+
+	return kvm_arm_update_id_reg(vcpu, id, val);
+}
+
 /* Read a sanitised cpufeature ID register by sys_reg_desc */
 static u64 read_id_reg(const struct kvm_vcpu *vcpu, struct
sys_reg_desc const *r)
 {
@@ -1477,34 +1471,28 @@ static u64
read_sanitised_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 		val |=3D
FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3), 1);
 	}
=20
+	if (kvm_vgic_global_state.type =3D=3D VGIC_V3) {
+		val &=3D ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_GIC);
+		val |=3D
FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_GIC), 1);
+	}
+
 	val &=3D ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_AMU);
=20
 	return val;
 }
=20
-static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
-			       const struct sys_reg_desc *rd,
-			       u64 val)
+static u64 read_sanitised_id_aa64pfr1_el1(struct kvm_vcpu *vcpu,
+					  const struct sys_reg_desc
*rd)
 {
-	u8 csv2, csv3;
+	u64 val;
+	u32 id =3D reg_to_encoding(rd);
=20
-	/*
-	 * Allow AA64PFR0_EL1.CSV2 to be set from userspace as long as
-	 * it doesn't promise more than what is actually provided (the
-	 * guest could otherwise be covered in ectoplasmic residue).
-	 */
-	csv2 =3D cpuid_feature_extract_unsigned_field(val,
ID_AA64PFR0_EL1_CSV2_SHIFT);
-	if (csv2 > 1 ||
-	    (csv2 && arm64_get_spectre_v2_state() !=3D
SPECTRE_UNAFFECTED))
-		return -EINVAL;
+	val =3D read_sanitised_ftr_reg(id);
=20
-	/* Same thing for CSV3 */
-	csv3 =3D cpuid_feature_extract_unsigned_field(val,
ID_AA64PFR0_EL1_CSV3_SHIFT);
-	if (csv3 > 1 ||
-	    (csv3 && arm64_get_meltdown_state() !=3D
SPECTRE_UNAFFECTED))
-		return -EINVAL;
+	/* SME is not supported */
+	val &=3D ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_SME);
=20
-	return set_id_reg(vcpu, rd, val);
+	return val;
 }
=20
 static u64 read_sanitised_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
@@ -1680,6 +1668,34 @@ static int set_id_dfr0_el1(struct kvm_vcpu
*vcpu,
 	return ret;
 }
=20
+static u64 read_sanitised_id_mmfr4_el1(struct kvm_vcpu *vcpu,
+				       const struct sys_reg_desc *rd)
+{
+	u64 val;
+	u32 id =3D reg_to_encoding(rd);
+
+	val =3D read_sanitised_ftr_reg(id);
+
+	/* CCIDX is not supported */
+	val &=3D ~ARM64_FEATURE_MASK(ID_MMFR4_EL1_CCIDX);
+
+	return val;
+}
+
+static u64 read_sanitised_id_aa64mmfr2_el1(struct kvm_vcpu *vcpu,
+					   const struct sys_reg_desc
*rd)
+{
+	u64 val;
+	u32 id =3D reg_to_encoding(rd);
+
+	val =3D read_sanitised_ftr_reg(id);
+
+	/* CCIDX is not supported */
+	val &=3D ~ID_AA64MMFR2_EL1_CCIDX_MASK;
+
+	return val;
+}
+
 /*
  * cpufeature ID register user accessors
  *
@@ -2089,7 +2105,14 @@ static const struct sys_reg_desc sys_reg_descs[]
=3D {
 	AA32_ID_SANITISED(ID_ISAR3_EL1),
 	AA32_ID_SANITISED(ID_ISAR4_EL1),
 	AA32_ID_SANITISED(ID_ISAR5_EL1),
-	AA32_ID_SANITISED(ID_MMFR4_EL1),
+	{ SYS_DESC(SYS_ID_MMFR4_EL1),
+	  .access     =3D access_id_reg,
+	  .get_user   =3D get_id_reg,
+	  .set_user   =3D set_id_reg,
+	  .visibility =3D aa32_id_visibility,
+	  .reset      =3D read_sanitised_id_mmfr4_el1,
+	  .val =3D 0, },
+	ID_HIDDEN(ID_AFR0_EL1),
 	AA32_ID_SANITISED(ID_ISAR6_EL1),
=20
 	/* CRm=3D3 */
@@ -2107,10 +2130,15 @@ static const struct sys_reg_desc
sys_reg_descs[] =3D {
 	{ SYS_DESC(SYS_ID_AA64PFR0_EL1),
 	  .access =3D access_id_reg,
 	  .get_user =3D get_id_reg,
-	  .set_user =3D set_id_aa64pfr0_el1,
+	  .set_user =3D set_id_reg,
 	  .reset =3D read_sanitised_id_aa64pfr0_el1,
 	  .val =3D ID_AA64PFR0_EL1_CSV2_MASK |
ID_AA64PFR0_EL1_CSV3_MASK, },
-	ID_SANITISED(ID_AA64PFR1_EL1),
+	{ SYS_DESC(SYS_ID_AA64PFR1_EL1),
+	  .access =3D access_id_reg,
+	  .get_user =3D get_id_reg,
+	  .set_user =3D set_id_reg,
+	  .reset =3D read_sanitised_id_aa64pfr1_el1,
+	  .val =3D 0, },
 	ID_UNALLOCATED(4,2),
 	ID_UNALLOCATED(4,3),
 	ID_SANITISED(ID_AA64ZFR0_EL1),
@@ -2146,7 +2174,12 @@ static const struct sys_reg_desc sys_reg_descs[]
=3D {
 	/* CRm=3D7 */
 	ID_SANITISED(ID_AA64MMFR0_EL1),
 	ID_SANITISED(ID_AA64MMFR1_EL1),
-	ID_SANITISED(ID_AA64MMFR2_EL1),
+	{ SYS_DESC(SYS_ID_AA64MMFR2_EL1),
+	  .access =3D access_id_reg,
+	  .get_user =3D get_id_reg,
+	  .set_user =3D set_id_reg,
+	  .reset =3D read_sanitised_id_aa64mmfr2_el1,
+	  .val =3D 0, },
 	ID_UNALLOCATED(7,3),
 	ID_UNALLOCATED(7,4),
 	ID_UNALLOCATED(7,5),

