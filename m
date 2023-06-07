Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6F64726A10
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 21:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231772AbjFGTqS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 15:46:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231605AbjFGTqI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 15:46:08 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 974DC1FF7
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 12:46:06 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-543a4a54469so1275450a12.1
        for <kvm@vger.kernel.org>; Wed, 07 Jun 2023 12:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686167166; x=1688759166;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Kt9Re8VhD2+c+e08bfchTfKK01Rj2MUePQIf0sCv4Xg=;
        b=qnLVcf4LBOV1GocAfKmE7OOXWzG9JXsx+o5fD5NyUihLa4ZmEEtGXBCpzgiwnDFzpW
         3i9IE5h6ihvg8wwHtLHRzRrmvSiqyq53LJ5VdfHiV/e3LDQnWSjiBl2omUAEyOSXHCvb
         CHDx0jkRuYbIVXezwbq9YBlEropjp33Q5X5v8O3ixEuMOEQeQ8f1dVDxgyOFKJPD+e8v
         8eqaxzIAlQKYECNoDAZ2EDzO7PmAJgcbwIXx6TA6P1gNq8IfNTK8hknyk2zzl5/syfVP
         N64VmdmpBXc9YSc4MaxWzquMO6VleuSWpfh2cPXzcRKY2zF8umgZx0vTVuieF++qHdj4
         q5Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686167166; x=1688759166;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Kt9Re8VhD2+c+e08bfchTfKK01Rj2MUePQIf0sCv4Xg=;
        b=h0M9pfdUldmHTaJEgft3ENFi3FJi7NFrLEiIJS0jFT4Ph4t6SPJ4iibgKelRCat4VE
         LwEY73CkWbykqVw01IpKsSDfwzZOnXuJn7IeXOmJwdjBUHIKgOsU5xb0BpXkohYv48T1
         HR21f0tkgY/TT7BJsP3hj/prjUEIERcdaRtY+lcBpwz5lpdMGEPJNuxDFqf1foA2I51m
         G7z4p4/leCwrXzp6rPn9xYS5wcefRpEMAr/ae+5aUvh+/g7nqJbBb5/8rDpR/llAW+gk
         Y+fzrpJFPYHuzwdLlJQG6emuL9OR1hB+Hz5Hm/62GL8ZIKd9GGtg1G7x5yhCZlgd2X66
         vJBg==
X-Gm-Message-State: AC+VfDx9wbNZ6PRBheFz7e3NhU9FrvkaBYEp1rsehG9xVa8lBnbrR/nv
        UNuGnUUgTVI3R8sGlcspJRjyN5ySN0WCaaqifNDnnQMklMEGha7XzjXA6FPzl+syCKTRQVvZt6X
        R0sBwDStvHLp6hitbh5/zhJP20qN8pi5wbdyEgkg8U7KDTUgHq4N6BEC/gqyZt0U8kByOjiY=
X-Google-Smtp-Source: ACHHUZ6AdZhHVsK3gBqZ29mngq3wYJzUe8nyFBCy0MXmvWuiKLwI//W+KPq7fWqN45t7RWSqbJlvv7QNt3JQHgOuqw==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:902:db02:b0:1b0:4af9:9032 with
 SMTP id m2-20020a170902db0200b001b04af99032mr2121642plx.0.1686167165934; Wed,
 07 Jun 2023 12:46:05 -0700 (PDT)
Date:   Wed,  7 Jun 2023 19:45:54 +0000
In-Reply-To: <20230607194554.87359-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230607194554.87359-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230607194554.87359-5-jingzhangos@google.com>
Subject: [PATCH v4 4/4] KVM: arm64: Enable writable for ID_AA64MMFR{0, 1, 2}_EL1
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

Enable writable from userspace for ID_AA64MMFR{0, 1, 2}_EL1.
Added a macro for defining general writable idregs.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/sys_regs.c | 36 ++++++++++++++++++++++++++++++------
 1 file changed, 30 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 8f3ad9c12b27..54c762c95983 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1391,9 +1391,6 @@ static u64 kvm_arm_read_id_reg(const struct kvm_vcpu *vcpu, u32 encoding)
 		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon),
 				  pmuver_to_perfmon(vcpu_pmuver(vcpu)));
 		break;
-	case SYS_ID_AA64MMFR2_EL1:
-		val &= ~ID_AA64MMFR2_EL1_CCIDX_MASK;
-		break;
 	case SYS_ID_MMFR4_EL1:
 		val &= ~ARM64_FEATURE_MASK(ID_MMFR4_EL1_CCIDX);
 		break;
@@ -1663,6 +1660,18 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 	return pmuver_update(vcpu, rd, val, perfmon_to_pmuver(perfmon), valid_pmu);
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
@@ -1898,6 +1907,16 @@ static unsigned int elx2_visibility(const struct kvm_vcpu *vcpu,
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
@@ -2113,9 +2132,14 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	ID_UNALLOCATED(6,7),
 
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
 	ID_UNALLOCATED(7,3),
 	ID_UNALLOCATED(7,4),
 	ID_UNALLOCATED(7,5),
-- 
2.41.0.rc0.172.g3f132b7071-goog

