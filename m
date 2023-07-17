Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B1997567F1
	for <lists+kvm@lfdr.de>; Mon, 17 Jul 2023 17:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbjGQP2k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jul 2023 11:28:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232262AbjGQP2B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jul 2023 11:28:01 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6632919B0
        for <kvm@vger.kernel.org>; Mon, 17 Jul 2023 08:27:33 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-668728bb904so4033442b3a.2
        for <kvm@vger.kernel.org>; Mon, 17 Jul 2023 08:27:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689607653; x=1692199653;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5mV2IQqjJWtXV0PBatZiBNfFvtLn0ngWE8+KQeRLOuQ=;
        b=qm7jCuMGI1Mba8afWkB5TQIv1cP7qNZPaBN/f7uEc95NpTwIrp6JKD6gRmDnRas6SA
         hKWz3eQh08Nxj5N9oXcrKW+yfrKo119N0LNYhGanZOznYQnpeBtgicuhvzDlP/BddKfP
         rlFQbc19xL0TNZ/4gcOkHrqeAt6/Lh8BQ9Z+L6H1+leLnUn253uACBCo+AygTvkGjIAG
         nEqm5rY8/DjGvLpRAz1TV+wuo1TwLDKupzMJmuyDtoRsAEZdOQeNoDcQ9ERejIaZZsL9
         DLIDOzCenx70HCkeBlqXxlVnTnyMCnIYdWkxurspO7jgVDpi/JCTNd5Hjh+Qk67mLW9U
         iQpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689607653; x=1692199653;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5mV2IQqjJWtXV0PBatZiBNfFvtLn0ngWE8+KQeRLOuQ=;
        b=gQkpCZyIVxoDfXt9QB08wBSyCx2ByUUeasc8ihvVK5LQdTIcS1BG+WeV4cpHMgRjWX
         S3+Q7+Pys5S5+hl9gzVH2TYxlS1UcHqVwOr+TV9ZM5fh4gQoaix85x44i5Pije6Py1QW
         bNy9pH+7xGJUMOf3HGpoyQZB0N07TMy7U0AFL2K3b/5HgBoqB4kxG15u/99QWjgjY1aV
         3JO4Z9UByQSh/kra4fZYL9XJX9tBGjMDgQ1XaWNHmDFKoDEYba2f9lAhhvvszf9a1ciA
         3Mr6Q3yq46RJ31jwDFUoLkT7Zr2YRCO0GK7QngfmfpQAA9b5dl14bYqk6kYA18SRl7ZJ
         /23g==
X-Gm-Message-State: ABy/qLZn3MjYYzMaMyFIvnRkvyKrR1qRLoToU5a+qcg4kCdvpQUdDV9a
        hlM9wv+PTye5zx31qyiMtd6BNkyxzQpUGbCUztQHSdb70Mxu29RU7nj8fGrExoLTNZ4tj5cLLVf
        RLAFnGnwRD18FkCnP1q/ireWkOVrEsiaJWHseTwKHxibrq25IYruhDeC9RiOSZgRn5Cb6uVU=
X-Google-Smtp-Source: APBJJlGWPC7Roh8Pd0zejhfDsSo3VBfRNb6G9bRpZN3JPepGli2gJO4trCOigT9eujUPRt4Q/PqJoaBeAl+3o8yMZw==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a05:6a00:3a13:b0:668:95c1:b507 with
 SMTP id fj19-20020a056a003a1300b0066895c1b507mr145112pfb.6.1689607652562;
 Mon, 17 Jul 2023 08:27:32 -0700 (PDT)
Date:   Mon, 17 Jul 2023 15:27:21 +0000
In-Reply-To: <20230717152722.1837864-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230717152722.1837864-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230717152722.1837864-5-jingzhangos@google.com>
Subject: [PATCH v6 4/5] KVM: arm64: Enable writable for ID_AA64MMFR{0, 1, 2, 3}_EL1
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

Enable writable from userspace for ID_AA64MMFR{0, 1, 2, 3}_EL1.
Added a macro for defining general writable idregs.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/sys_regs.c | 38 +++++++++++++++++++++++++++++++-------
 1 file changed, 31 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index fab525508510..5fbf14320ad9 100644
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

