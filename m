Return-Path: <kvm+bounces-529-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D4157E0975
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 20:29:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1EFDCB21354
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 19:29:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E46EB23767;
	Fri,  3 Nov 2023 19:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iKzyFt6M"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04C0822F1F
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 19:29:31 +0000 (UTC)
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 840E61BD
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 12:29:30 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-da04fb79246so2804445276.2
        for <kvm@vger.kernel.org>; Fri, 03 Nov 2023 12:29:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699039769; x=1699644569; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/ej9TKa7ZSJIOAJS1B/2lr9o03XnT9TFq89fTO+C5Ds=;
        b=iKzyFt6MgbESFFR1CEQKLrpfkdiKEj/I5H7K956bdIOcQ8UiWB3TFU4bkamptLXXOC
         IAMesiBzPmz1gcRe2CGPMc5i+LxG4lBSEEqCfMkKRpnl3mS/Y02mQQhwGVptzbKJ+TL4
         8aiFzSQeMaVoCcI5Au4DWb9CarNmSntabfp5rNNTymrUWb9rsJQJjOUL02gH4mN8GjR3
         +2MJVS2GMmVALK0ED/p82A6iE5cLOFGANLnTevSH+u8owsJIylSRYHieGdv2NPpz0LL1
         RuAcefObmAOghBdqkFABMxUm/uKkOX8cdXCfhBkQyKdgwp5dwcyxL87MHqq0vkgd2dJW
         pymg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699039769; x=1699644569;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/ej9TKa7ZSJIOAJS1B/2lr9o03XnT9TFq89fTO+C5Ds=;
        b=AA0sMsbEtvQ0zMGUO8XKXviAdonM/TCNHSKtVBxsSK21hYMa+pWoWIBzC1GQaLJ0b0
         zR4HQxZrL+G/nW3PCutIbKVsnXlIKusxKnP+hM/6eqKzTITfz+ylQEQOqXvkuq3SzFF1
         /3PbvnoGg62qag3Tg7QmkPCNF5FZCAZ/W/mGyYYrbpMitDObZkkBJTU1TYqSryHViBxJ
         iTqnrBDzz5TnTrsv3Gz8YWSLWKB+jYXs7toNopYEMzMRSJ26/U3JRURKAjO2bh4ZEIjm
         iI0Jor4erYV7i3jwSfwke/z5zcroT5Rx5xUgQxa6PlpeQRCPI49QblMrg3f3zjhA0AzD
         LosA==
X-Gm-Message-State: AOJu0YzLKZp554JwBSiwa8C88lGvgYx5x2vAfe0RUDAthq9ITA3sJzZT
	s/OKD/NsnLnbC//DhjYF3QlfaM8QXmk8mpa0KuwI8zE4uP+ZfrnhjkPyd5f6Hr9Z35sFxvgPaR5
	OBvIp5qdVWeNa6p1HkrTI0ovu5lXiaPPP2EKtU0H/9nWTg4tB/a2ItCACK02GHmCXPaE3iZs=
X-Google-Smtp-Source: AGHT+IFHprlg+8CuBn3dAnKWLLisYwZoGaeLvdHj+lnYB5xuNReCG2ZD3zHPD6Ahxm/WYC4ajyf4OuQZtVCmY8RAOA==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a25:2688:0:b0:da0:29ba:668c with SMTP
 id m130-20020a252688000000b00da029ba668cmr412352ybm.10.1699039769635; Fri, 03
 Nov 2023 12:29:29 -0700 (PDT)
Date: Fri,  3 Nov 2023 19:29:14 +0000
In-Reply-To: <20231103192915.2209393-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231103192915.2209393-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231103192915.2209393-3-coltonlewis@google.com>
Subject: [PATCH v3 2/3] KVM: arm64: selftests: Guarantee interrupts are handled
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Ricardo Koller <ricarkol@google.com>, kvmarm@lists.linux.dev, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Break up the asm instructions poking daifclr and daifset to handle
interrupts. R_RBZYL specifies pending interrupts will be handle after
context synchronization events such as an ISB.

Introduce a function wrapper for the WFI instruction.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 tools/testing/selftests/kvm/aarch64/vgic_irq.c    | 12 ++++++------
 tools/testing/selftests/kvm/include/aarch64/gic.h |  3 +++
 tools/testing/selftests/kvm/lib/aarch64/gic.c     |  5 +++++
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
index d3bf584d2cc1..85f182704d79 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
@@ -269,13 +269,13 @@ static void guest_inject(struct test_args *args,
 	KVM_INJECT_MULTI(cmd, first_intid, num);

 	while (irq_handled < num) {
-		asm volatile("wfi\n"
-			     "msr daifclr, #2\n"
-			     /* handle IRQ */
-			     "msr daifset, #2\n"
-			     : : : "memory");
+		gic_wfi();
+		local_irq_enable();
+		isb();
+		/* handle IRQ */
+		local_irq_disable();
 	}
-	asm volatile("msr daifclr, #2" : : : "memory");
+	local_irq_enable();

 	GUEST_ASSERT_EQ(irq_handled, num);
 	for (i = first_intid; i < num + first_intid; i++)
diff --git a/tools/testing/selftests/kvm/include/aarch64/gic.h b/tools/testing/selftests/kvm/include/aarch64/gic.h
index 9043eaef1076..f474714e4cb2 100644
--- a/tools/testing/selftests/kvm/include/aarch64/gic.h
+++ b/tools/testing/selftests/kvm/include/aarch64/gic.h
@@ -47,4 +47,7 @@ void gic_irq_clear_pending(unsigned int intid);
 bool gic_irq_get_pending(unsigned int intid);
 void gic_irq_set_config(unsigned int intid, bool is_edge);

+/* Execute a Wait For Interrupt instruction. */
+void gic_wfi(void);
+
 #endif /* SELFTEST_KVM_GIC_H */
diff --git a/tools/testing/selftests/kvm/lib/aarch64/gic.c b/tools/testing/selftests/kvm/lib/aarch64/gic.c
index 9d15598d4e34..392e3f581ae0 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/gic.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/gic.c
@@ -164,3 +164,8 @@ void gic_irq_set_config(unsigned int intid, bool is_edge)
 	GUEST_ASSERT(gic_common_ops);
 	gic_common_ops->gic_irq_set_config(intid, is_edge);
 }
+
+void gic_wfi(void)
+{
+	asm volatile("wfi");
+}
--
2.42.0.869.gea05f2083d-goog

