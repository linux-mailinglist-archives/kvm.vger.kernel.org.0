Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5DD4772A82
	for <lists+kvm@lfdr.de>; Mon,  7 Aug 2023 18:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbjHGQWl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Aug 2023 12:22:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231460AbjHGQWj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Aug 2023 12:22:39 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15FB510CF
        for <kvm@vger.kernel.org>; Mon,  7 Aug 2023 09:22:32 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1bbbc4ae328so36810845ad.1
        for <kvm@vger.kernel.org>; Mon, 07 Aug 2023 09:22:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691425352; x=1692030152;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KQ512HkIoQ+JjDzsBkwZD/O45k5sXYn+9E1zCZiXBTM=;
        b=6Lo9H24x8NTxC0n4kLhv0iJn7Shulw6bzYqLRydoTq7ITj9ZEMtDdbusgZ9Y2360bu
         8NAb1ux1MMgQTMc8dIKPjKpIrjK4OZOPoRUbHDDyBJHa4zmV0qeicuZ/SnRbEsghTWjR
         lttSTUslekgfspuAH2XPtE1/wt36SeLpKlZ6+xPvzi8ODkznx8oJj1ikC9iK4bWBKIQQ
         acWXrbWLULbOeWV9v9a4MPSNMIk1DxvuLoTVeWG6dvqOMiuM7T8/yBCa1NgGWbMC4p0R
         Y+OUL3O7tPB99sQDEj1N6mSEVTvcs/IfpMSvIM6SiAPjpfk9lVMgwgECFWXNRIAUaALI
         L2ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691425352; x=1692030152;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KQ512HkIoQ+JjDzsBkwZD/O45k5sXYn+9E1zCZiXBTM=;
        b=ZLs7eK34n99yeGuMKr8zeUkI4wXWDjB2d+/M2T/vUPmLnMlTKbM4i9+pBZl4LkkLnw
         nB+D0JM2yPjsIxRsVzPXP/rGnTUc0kKcV3fXejqCyvM6sOfhPXNlXMSd/oBEFPDBEe37
         9y7xFX2gn4Yc9pEXYwCIf1Rg9iPHaOQOEKwArfbwzUoGzAwxzYbupjHKdr5yx2zcgfeI
         QNdJ/xoixpMm6GvV+LjZB7hxtzseUXIJq5WvxJPiokETHQwX2Lpn2jw7oZsGN+swqvGA
         jzEcJ7yOWywLna2PXRWVPtKbhbLeigkg41j+SSrZKU0Uj01O5SGpbV6VPurV156lwYOy
         gnvw==
X-Gm-Message-State: AOJu0YzAfWcj4/pSU9EQv3iuki5zpXi40fAOGzrwUHnAZ1owBC7f73Qm
        9BRJdUxTjYEFcDstmb1mTt1S8Z6cqId8TuQ+vAGZajXg/qzO5Nkr34wgTHPd5erquFl7AWKPGij
        79MRpCSZYx2AoqtSWYWBbr7BxbRDGC2EtyROcy/PpOI4yWs8N7VUgYMxbqNh5x4Sg252AjAQ=
X-Google-Smtp-Source: AGHT+IHp4MVAV4n481W5LCw7P/7em8n7s/3BaGvDZ7vncQfCYL58OphuOXpZAfvPrGytnKkgdfgjYDyzmGS6V7A3kQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:903:22c2:b0:1b9:e338:a8b7 with
 SMTP id y2-20020a17090322c200b001b9e338a8b7mr41787plg.5.1691425351454; Mon,
 07 Aug 2023 09:22:31 -0700 (PDT)
Date:   Mon,  7 Aug 2023 09:22:07 -0700
In-Reply-To: <20230807162210.2528230-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230807162210.2528230-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <20230807162210.2528230-10-jingzhangos@google.com>
Subject: [PATCH v8 09/11] KVM: arm64: Enable writable for ID_AA64MMFR{0, 1, 2, 3}_EL1
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
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
index 85b5312bdee6..59c590fff4f2 100644
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

