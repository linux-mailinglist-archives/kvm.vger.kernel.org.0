Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3D69726A0F
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 21:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231458AbjFGTqM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 15:46:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231585AbjFGTqF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 15:46:05 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9770F1FFA
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 12:46:04 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1b03f9dfd52so30861125ad.3
        for <kvm@vger.kernel.org>; Wed, 07 Jun 2023 12:46:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686167164; x=1688759164;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=huLg6ss0tcmHNDWws/J4wYZLAswrAiv7bwqrVCr+Www=;
        b=rvQpvgjutLDBUFD6re8s66cYIwgJnhk30RuWpsooLwa0/DnV1KMpLh1QKXz+AU3+EJ
         toULyYGPVwLcH+MSf1zAwjIgC+QmNBB84JuvtVGLm32grPQNsyGJC3yXIN+pXqUx0vmf
         kYkm0cPqzfksnRtP/WQ3XaIV5kyL5FExnTnvHnNEHk9QkXCUYZPtMjAyqZOwoW4K0Hq1
         y35uWuI4QoY/hqnEX3uFzWlae+hnEGx6aU+9CDnIEosOHdw7Xdp/4v0Mg9VKQ9GeT0yk
         980+Iqqj10VIbOSXVkqMt9C0azx+wOnrkAIodnSMgi7gX9SdshzFmuUiEcp8K2mTBDU0
         eicg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686167164; x=1688759164;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=huLg6ss0tcmHNDWws/J4wYZLAswrAiv7bwqrVCr+Www=;
        b=caUo6xMMkt8TNXXP49uWMU3ja2L01Vr0rRRocOiP21G3ud2eua9dkuPmoMDkg/H0je
         cUrKOLzJSV8JwzMKmK3v2nu+lP+Rbtc3uTGzHY2wabzFm52vvu3zhIjop/rOTNeBrhEA
         gIGVu3Sr9h4da0Z8kLmEt8Q79bxKz77rbc+4NI2LWjnNP98KbCrHudYE0B0TPEhFhgYU
         Gcw2YLXRSw98TS4wdwjCVyB2WUojNV1oZDOUC1FuuzHQZDMw/5/KnULBmRuRk9keNzYN
         8X6LZqHN5wo/TxcPr+nTy96FMc3uafJnVr2lVT21L4QToM6Mtj5gh9TwVXf75Ceo7RsI
         pWHg==
X-Gm-Message-State: AC+VfDxUoEd5BOZuY+ewHH+Qrlku9u7vrZf1kal/ZJwytJ8GBP/PyoxK
        4fhksqkyXx+a7wYRryxdyRuT5Gv634ScmYqZDSHmM/Xn4iPnkG/xrLYq8q07O1zFBxFPyzSr2yB
        ++PhCFX5B1Z8LDwG5zT15Y1h2yhVWvrvZ2rX5L5cJHFg5nV68+P8Ser2BwMCeuMHjgEhN00Q=
X-Google-Smtp-Source: ACHHUZ4hJXt9tbUdkBWtP+0/4Tl+ZJnlb3E1BRZjLecrD3nbq3Co9zEpbNCwpWdnYYtl6Y/VvwJ4Y5DV8ySaS3odNA==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:903:453:b0:1ae:549f:af6e with SMTP
 id iw19-20020a170903045300b001ae549faf6emr1907179plb.7.1686167163943; Wed, 07
 Jun 2023 12:46:03 -0700 (PDT)
Date:   Wed,  7 Jun 2023 19:45:53 +0000
In-Reply-To: <20230607194554.87359-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230607194554.87359-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230607194554.87359-4-jingzhangos@google.com>
Subject: [PATCH v4 3/4] KVM: arm64: Enable writable for ID_AA64PFR0_EL1
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
        Suraj Jitindar Singh <surajjs@amazon.com>,
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

Return an error if userspace tries to set SVE field of the register
to a value that conflicts with SVE configuration for the guest.
SIMD/FP/SVE fields of the requested value are validated according to
Arm ARM.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/sys_regs.c | 31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 3964a85a89fe..8f3ad9c12b27 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1509,9 +1509,36 @@ static u64 read_sanitised_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 
 	val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_AMU);
 
+	if (!system_supports_sve())
+		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_SVE);
+
 	return val;
 }
 
+static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
+			       const struct sys_reg_desc *rd,
+			       u64 val)
+{
+	int fp, simd;
+	bool has_sve = id_aa64pfr0_sve(val);
+
+	simd = cpuid_feature_extract_signed_field(val, ID_AA64PFR0_EL1_AdvSIMD_SHIFT);
+	fp = cpuid_feature_extract_signed_field(val, ID_AA64PFR0_EL1_FP_SHIFT);
+	/* AdvSIMD field must have the same value as FP field */
+	if (simd != fp)
+		return -EINVAL;
+
+	/* fp must be supported when sve is supported */
+	if (has_sve && (fp < 0))
+		return -EINVAL;
+
+	/* Check if there is a conflict with a request via KVM_ARM_VCPU_INIT */
+	if (vcpu_has_sve(vcpu) ^ has_sve)
+		return -EPERM;
+
+	return set_id_reg(vcpu, rd, val);
+}
+
 static u64 read_sanitised_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 					  const struct sys_reg_desc *rd)
 {
@@ -2049,9 +2076,9 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_ID_AA64PFR0_EL1),
 	  .access = access_id_reg,
 	  .get_user = get_id_reg,
-	  .set_user = set_id_reg,
+	  .set_user = set_id_aa64pfr0_el1,
 	  .reset = read_sanitised_id_aa64pfr0_el1,
-	  .val = ID_AA64PFR0_EL1_CSV2_MASK | ID_AA64PFR0_EL1_CSV3_MASK, },
+	  .val = GENMASK(63, 0), },
 	ID_SANITISED(ID_AA64PFR1_EL1),
 	ID_UNALLOCATED(4,2),
 	ID_UNALLOCATED(4,3),
-- 
2.41.0.rc0.172.g3f132b7071-goog

