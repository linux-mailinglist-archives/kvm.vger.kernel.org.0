Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0484B76B87F
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 17:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234939AbjHAPUj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 11:20:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231454AbjHAPUb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 11:20:31 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B99521FD0
        for <kvm@vger.kernel.org>; Tue,  1 Aug 2023 08:20:30 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d052f49702dso6568052276.3
        for <kvm@vger.kernel.org>; Tue, 01 Aug 2023 08:20:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690903230; x=1691508030;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=b/7Lgt+l6L+++1Locph+rfoqbHtbNhHaO0z9TCoQ7fA=;
        b=m8jGBw2adbOMlLu5IFSNQ4EEvH0Ez123QLCDkpVzma0hLcKJB0hrQYrwi/tGEwsMfD
         LLCb6tCWiodRr7skiCc5p4TBnmeXPwIoaUpK1g0NUxN3qtDZfS4LOB2KSMR2SjXdMis9
         jnuTNeQCoruTPRCFK1+opcYKcIcLCcnVFVEvONsFZePKbLcYaO4l+FNAzdjt0TyS4ndY
         QeSXTj1fwbiYO453mbGEU/AdHaggKRbyhm6++ckwevPbP6s8eR5Q6eT3xXzIqDI2a+RG
         YnTSTziEXYKvC8ij9UxT6USGN/yhsuhByvuePWb1yMDUP/R/kaCMXNA//gEBag6eigUE
         53Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690903230; x=1691508030;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b/7Lgt+l6L+++1Locph+rfoqbHtbNhHaO0z9TCoQ7fA=;
        b=eQ3oz+EyF2Wi2kFCNZz8ajZNzYVR3kXeaXCQEQrNlVl/mAkm85z3DI9d/gQy+9onbN
         wr8cn7msG51dhLB+i++84ZL4AA+MYMwSEABYTcZgQPY/x3bBNNLt34siKKwH1JPC86Rr
         AB0VAf/0NiQlje05bnAGI3wm6a0qcmARCLgrXdT8Hr4wxR5o02MNkZ4t1iXMbPWsGax0
         o3Myyb0tQuRGwxQbz4mX5GWI+QYcTEUhqWwJ/j6u43WBKmr6gFLsi3zkp2UbTMn5Jj8i
         8rQtCVNDRxmFzRKFemUrPFrg84n5fW5AA6Jw51zn7NA8aMYF9d0rAfwvxu1ZtPZUdOuj
         vzTQ==
X-Gm-Message-State: ABy/qLZ2wPKMuQekaC8MMhOJMJDTOa2e0xlN+RskYZqyzQkR1+I4PlYW
        gwx5++dw2qD5nv5oUgEWEWMMdfOMN/sTrpolQVKMHcWbhxlhhvwIxN1g+8znHguCaf5y0rOpC0D
        jbrZDk0zLZInRKzeEqhZ+XytGGXnE8Kx7NMsjpqQz6R4uNQTgq8VsQKsNW71+47CLH7rPJKQ=
X-Google-Smtp-Source: APBJJlHzVwXMgVQQFdwSLT/blqJxTGWY8QTbzn3EO4lzgefNJKzxZfyyaG0mqKCJlhRCBb/Kq++VwHj9ggc+2qA52g==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a25:1446:0:b0:d31:b7c5:5170 with SMTP
 id 67-20020a251446000000b00d31b7c55170mr42960ybu.12.1690903229712; Tue, 01
 Aug 2023 08:20:29 -0700 (PDT)
Date:   Tue,  1 Aug 2023 08:20:05 -0700
In-Reply-To: <20230801152007.337272-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230801152007.337272-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <20230801152007.337272-10-jingzhangos@google.com>
Subject: [PATCH v7 09/10] KVM: arm64: Enable writable for ID_AA64MMFR{0, 1, 2, 3}_EL1
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

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/sys_regs.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 9ca23cfec9e5..67b50a088eac 100644
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
@@ -1581,6 +1578,15 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 	return set_id_reg(vcpu, rd, val);
 }
 
+static u64 read_sanitised_id_aa64mmfr2_el1(struct kvm_vcpu *vcpu,
+					   const struct sys_reg_desc *rd)
+{
+	u64 val = read_sanitised_ftr_reg(SYS_ID_AA64MMFR2_EL1);
+
+	val &= ~ID_AA64MMFR2_EL1_CCIDX_MASK;
+	return val;
+}
+
 /*
  * cpufeature ID register user accessors
  *
@@ -2063,10 +2069,10 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	ID_UNALLOCATED(6,7),
 
 	/* CRm=7 */
-	ID_SANITISED(ID_AA64MMFR0_EL1),
-	ID_SANITISED(ID_AA64MMFR1_EL1),
-	ID_SANITISED(ID_AA64MMFR2_EL1),
-	ID_SANITISED(ID_AA64MMFR3_EL1),
+	ID_SANITISED_W(ID_AA64MMFR0_EL1),
+	ID_SANITISED_W(ID_AA64MMFR1_EL1),
+	_ID_SANITISED_W(ID_AA64MMFR2_EL1, set_id_reg, read_sanitised_id_aa64mmfr2_el1),
+	ID_SANITISED_W(ID_AA64MMFR3_EL1),
 	ID_UNALLOCATED(7,4),
 	ID_UNALLOCATED(7,5),
 	ID_UNALLOCATED(7,6),
-- 
2.41.0.585.gd2178a4bd4-goog

