Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 264DE74DE22
	for <lists+kvm@lfdr.de>; Mon, 10 Jul 2023 21:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230358AbjGJTYv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jul 2023 15:24:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230487AbjGJTYr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jul 2023 15:24:47 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60849E3
        for <kvm@vger.kernel.org>; Mon, 10 Jul 2023 12:24:43 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-553d076dce5so5583926a12.3
        for <kvm@vger.kernel.org>; Mon, 10 Jul 2023 12:24:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689017083; x=1691609083;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=q8Pfm1k8D0yA8LpBE9VtBtVTcRMyZS82/djAneCpkmQ=;
        b=GDvwqv1MlzXGhRLJnLJVug7YjvSyOR6eGB5341bF6QxHQZRZgkvaDlH66y4otQAjxR
         44UbQIWUSOEUnsrC+JRRpIOD794NJBNrvpilQ7LO6keqcvGltAH1FCmFC3SyXkOwYQ/0
         crkiuQnUI2yGw0A4pjGjbwtLO3U6I5Dh1NwZzexJa3qLV/JxBB+WCx0PBSJDgoXI72sq
         LXWeycLBLLeq7lyQ+Kz3VJhHfDhYEvJ/rpKj4QaoZuWnuNfv2i5xlOK+8ONgEsLm1Gze
         4kc8pmZHweX9syFCVFkCQQ7hmDa3KevbPWic1vjbctzP5FGA9XSCZpASTHh3DdJ0ZRsF
         merg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689017083; x=1691609083;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q8Pfm1k8D0yA8LpBE9VtBtVTcRMyZS82/djAneCpkmQ=;
        b=jW3+CZ2QMCA/ustvXfIgs+uAufaVKTZxNMdU35YfRB+u8vysKVnuZTqdDV2oogDFqd
         QrrRPRql5ied51ylQ4n3+0AR7zLDSyr/5mC4uYMvBVrjDo5dragfvHfz9PqW6RG0rHJ8
         wcxc54i3YxhAqFXJIo0tMXbxDEKsIupIKRwWoVG6TCUzzCEhSJs0LTwoOxiTIqANqr+A
         93X7WHD8o6TmGV/uAk3Vu95GinCvZoKYXALGF0vXQ+WVoGOrPhKu2UgTcwFfExdceAeU
         3gZL3BX+K+P/E9OVKxBIkbj0BHb262L2qTIUW1R8NcrVkfRWf4NkEjkZYRQAAeXWzx+K
         Isfg==
X-Gm-Message-State: ABy/qLZJ79L3OUxh5AWVP6/flMJ434QNOBGyxWY5Z9r3dLU+MhDl8/i4
        /FcB0gCmtQXkft9aSr8JMuVfdahIwVtd45z/SAhW0aryHyiwh7x3Z9EAUpdeDuKsgHcjcdAxg3Z
        3RtYmswfyY642Fzmbfdawi4qtpkRcGP7BG/6kMpjNDScNOEiNSXgnfEgkx1bmGxPlOz2KlzM=
X-Google-Smtp-Source: APBJJlGBCHc1RRKkPANqOkNMUbhIdTsh4hoWApD9cH5zSD49oQpk7M8yIJXyvY9F4ifLaUr+n7yMTQtPbIKIxkg7Jw==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a63:6:0:b0:550:d2d6:525b with SMTP id
 6-20020a630006000000b00550d2d6525bmr9180529pga.12.1689017082796; Mon, 10 Jul
 2023 12:24:42 -0700 (PDT)
Date:   Mon, 10 Jul 2023 19:24:28 +0000
In-Reply-To: <20230710192430.1992246-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230710192430.1992246-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230710192430.1992246-6-jingzhangos@google.com>
Subject: [PATCH v5 5/6] KVM: arm64: Enable writable for ID_AA64MMFR{0, 1, 2, 3}_EL1
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
index 967ecd57a86a..78ccc95624fa 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1340,9 +1340,6 @@ static u64 __kvm_read_sanitised_id_reg(const struct kvm_vcpu *vcpu,
 			val &= ~ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1_WFxT);
 		val &= ~ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1_MOPS);
 		break;
-	case SYS_ID_AA64MMFR2_EL1:
-		val &= ~ID_AA64MMFR2_EL1_CCIDX_MASK;
-		break;
 	case SYS_ID_MMFR4_EL1:
 		val &= ~ARM64_FEATURE_MASK(ID_MMFR4_EL1_CCIDX);
 		break;
@@ -1566,6 +1563,18 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
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
@@ -1840,6 +1849,16 @@ static unsigned int elx2_visibility(const struct kvm_vcpu *vcpu,
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
@@ -2061,10 +2080,15 @@ static const struct sys_reg_desc sys_reg_descs[] = {
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

