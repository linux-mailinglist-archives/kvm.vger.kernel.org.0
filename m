Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E81447834DA
	for <lists+kvm@lfdr.de>; Mon, 21 Aug 2023 23:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbjHUVXN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Aug 2023 17:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230109AbjHUVXM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Aug 2023 17:23:12 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78BE012F
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 14:23:04 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id 98e67ed59e1d1-26d5970cbdbso4409374a91.0
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 14:23:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692652984; x=1693257784;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YgTaLJAmUad0YLnHfOMQe2MEne8LxCU1g5ZxaAq3g0U=;
        b=PIl6nC2/xM90YAB0x/YrU1gwi0CviK/tWjFaeL65SWUQbUQsgpVJRPn76978PnD4u6
         bUaiGMw+W7iOfyNuZAthpf6LJK0IfuZJxGAKOM4HQxgVOzLTvOyp7yDPUmb9Ph83bDfG
         ndD0X9hQe7EuKGLXb4bi1CDpqCtvhSOmD/vKTKnjOYnuaZTj9q3ogcV31WaBh6QSOyx1
         Nw8263cJrnqh4ffttwH7WVpUuT+SdZZkOIr7M+JIiktCM/PUS00fUySXtJrPPSXXD/BA
         uS14x06dGL1jh7ry9crzF+Wkj3pcTJZOipAmWYUuxHCaKUvBZdWM0hPeHvv7L7w7JzNB
         krxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692652984; x=1693257784;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YgTaLJAmUad0YLnHfOMQe2MEne8LxCU1g5ZxaAq3g0U=;
        b=jqkSuFZayPJfOA2y1WUja4Ph8QdfCoU1ScWup5tMzUlDzQugnWU0tcYt4zhbWRSt4g
         FO1q58Fi/oaTN2zmNQSUIll2guBqmOMykvpkl1vzYHV7WXyEqCJXUkfeYojGTNBfXsGI
         77tq9fsfmtCjE4KbuJL7HuDjPNKtzQ9FZjpQcmP6y3Szu/rYyN08ZjMvGDIMWUi8t85I
         Bzlc88epFH4C40/AlmRzJUsZ9+UlIQYbChUjBm/nymI/5EAVNUlAx6pw+l3V7rrnv/fo
         w2M+nvp6B43PIGi2vqFLrJwQLwJnn+ANGBVWkMQq3txWpHSmcDSuxc6Vu6zavpjioTr6
         aDQA==
X-Gm-Message-State: AOJu0Yy58WDReS3ITxc6a/8J4frk88nKzhWape+U0x/Ha/b1dqlIBLrJ
        9Ax98qp4u9tj6V64EIiDXi9TQmaHgCy3ej4RMH1qCN8c5z+xM5Izy+8SyqZGGQ59WsyBDIMXh1X
        dC1yW638GFjOhjvkQmggXJmtxl4OklJUJKbra58EEoYvnWJtUEY4Kb0CFA/nbrpip6+SP+x8=
X-Google-Smtp-Source: AGHT+IHMLzQuvWaAzxElJKP9Dp9OtXD637SCTtUsKnZJ0SqP6VYj3mFXGJE3BulMdkjVz/lV1VBaWwqQYtRJCXaReA==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:902:cec9:b0:1bc:f6d:b2f1 with SMTP
 id d9-20020a170902cec900b001bc0f6db2f1mr3958879plg.5.1692652983926; Mon, 21
 Aug 2023 14:23:03 -0700 (PDT)
Date:   Mon, 21 Aug 2023 14:22:41 -0700
In-Reply-To: <20230821212243.491660-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230821212243.491660-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
Message-ID: <20230821212243.491660-10-jingzhangos@google.com>
Subject: [PATCH v9 09/11] KVM: arm64: Enable writable for ID_AA64MMFR{0, 1, 2, 3}_EL1
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
        Shaoqin Huang <shahuang@redhat.com>,
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enable writable from userspace for ID_AA64MMFR{0, 1, 2, 3}_EL1.
RES0 fields and those fields not exposed by KVM are not writable.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/sys_regs.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 44d164d47756..96a1dccf1af5 100644
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
@@ -1936,6 +1942,10 @@ static bool access_spsr(struct kvm_vcpu *vcpu,
 }
 
 #define ID_AA64DFR0_EL1_RES0_MASK (GENMASK(59, 56) | GENMASK(27, 24) | GENMASK(19, 16))
+#define ID_AA64MMFR0_EL1_RES0_MASK GENMASK(55, 48)
+#define ID_AA64MMFR1_EL1_RES0_MASK GENMASK(63, 60)
+#define ID_AA64MMFR2_EL1_RES0_MASK GENMASK(47, 44)
+#define ID_AA64MMFR3_EL1_RES0_MASK (GENMASK(59, 32) | GENMASK(27, 8))
 
 /*
  * Architected system registers.
@@ -2068,10 +2078,11 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	ID_UNALLOCATED(6,7),
 
 	/* CRm=7 */
-	ID_SANITISED(ID_AA64MMFR0_EL1),
-	ID_SANITISED(ID_AA64MMFR1_EL1),
-	ID_SANITISED(ID_AA64MMFR2_EL1),
-	ID_SANITISED(ID_AA64MMFR3_EL1),
+	ID_SANITISED_W(ID_AA64MMFR0_EL1, ~ID_AA64MMFR0_EL1_RES0_MASK),
+	ID_SANITISED_W(ID_AA64MMFR1_EL1, ~ID_AA64MMFR1_EL1_RES0_MASK),
+	_ID_SANITISED_W(ID_AA64MMFR2_EL1, set_id_reg, read_sanitised_id_aa64mmfr2_el1,
+			~(ID_AA64MMFR2_EL1_CCIDX_MASK | ID_AA64MMFR2_EL1_RES0_MASK)),
+	ID_SANITISED_W(ID_AA64MMFR3_EL1, ~ID_AA64MMFR3_EL1_RES0_MASK),
 	ID_UNALLOCATED(7,4),
 	ID_UNALLOCATED(7,5),
 	ID_UNALLOCATED(7,6),
-- 
2.42.0.rc1.204.g551eb34607-goog

