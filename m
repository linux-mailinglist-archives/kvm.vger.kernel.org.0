Return-Path: <kvm+bounces-64927-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id AC197C91788
	for <lists+kvm@lfdr.de>; Fri, 28 Nov 2025 10:37:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 6E5C434EA25
	for <lists+kvm@lfdr.de>; Fri, 28 Nov 2025 09:36:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B27330507E;
	Fri, 28 Nov 2025 09:35:59 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC7D9304BBA;
	Fri, 28 Nov 2025 09:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764322558; cv=none; b=jKVPOyWX4uxYD62Kal1/YftHQ4HlayiO6dT/Dpzrj05TQcx9B+11dE4ikGPzHh56Mev37lplUHpB1tpC4BWxdBp7/HVDP9G98x8QKOZPclQx0lZYkuUFhKqx1Yp2ZQLf/D9vgJ+T3H5dT965R2TwqWYUThepWWvkqr7RycWPvrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764322558; c=relaxed/simple;
	bh=0bkBUmx97QCJuRrNjTkHuif5W//TZyFWDqBdkm9fmcM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sGn22S4DaRta13KElbk084/0x6CVa3ORl0vuyd9F4g4c+P1xr4YQ9hD7Xi243OL+7547DKl1u/vTdiDcRXnD2Zv4DobFIJ/zprbH+AA35nOmPuRm52c4xhXEg8XNUxZgDQkBbxHp3ImL6i978RKatY9dcYCoZ5ej+92ZcJtiYuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.185])
	by gateway (Coremail) with SMTP id _____8Bx37_ubClpQA8pAA--.20619S3;
	Fri, 28 Nov 2025 17:35:42 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
	by front1 (Coremail) with SMTP id qMiowJCx2sDtbClpo+xBAQ--.23356S3;
	Fri, 28 Nov 2025 17:35:42 +0800 (CST)
From: Song Gao <gaosong@loongson.cn>
To: maobibo@loongson.cn,
	chenhuacai@kernel.org
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	kernel@xen0n.name,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/4] LongArch: KVM: Add some maccros for AVEC
Date: Fri, 28 Nov 2025 17:11:22 +0800
Message-Id: <20251128091125.2720148-2-gaosong@loongson.cn>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20251128091125.2720148-1-gaosong@loongson.cn>
References: <20251128091125.2720148-1-gaosong@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJCx2sDtbClpo+xBAQ--.23356S3
X-CM-SenderInfo: 5jdr20tqj6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Add some maccros for AVEC interrupt controller, so the dintc can use
those maccros.

Signed-off-by: Song Gao <gaosong@loongson.cn>
---
 arch/loongarch/include/asm/irq.h     | 8 ++++++++
 drivers/irqchip/irq-loongarch-avec.c | 5 +++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/loongarch/include/asm/irq.h b/arch/loongarch/include/asm/irq.h
index 12bd15578c33..aaa022fcb9e3 100644
--- a/arch/loongarch/include/asm/irq.h
+++ b/arch/loongarch/include/asm/irq.h
@@ -50,6 +50,14 @@ void spurious_interrupt(void);
 #define NR_LEGACY_VECTORS	16
 #define IRQ_MATRIX_BITS		NR_VECTORS
 
+#define AVEC_VIRQ_SHIFT		4
+#define AVEC_VIRQ_BIT		8
+#define AVEC_VIRQ_MASK		GENMASK(AVEC_VIRQ_BIT - 1, 0)
+#define AVEC_CPU_SHIFT		12
+#define AVEC_CPU_BIT		16
+#define AVEC_CPU_MASK		GENMASK(AVEC_CPU_BIT - 1, 0)
+
+
 #define arch_trigger_cpumask_backtrace arch_trigger_cpumask_backtrace
 void arch_trigger_cpumask_backtrace(const struct cpumask *mask, int exclude_cpu);
 
diff --git a/drivers/irqchip/irq-loongarch-avec.c b/drivers/irqchip/irq-loongarch-avec.c
index bf52dc8345f5..f0118cfd4363 100644
--- a/drivers/irqchip/irq-loongarch-avec.c
+++ b/drivers/irqchip/irq-loongarch-avec.c
@@ -209,8 +209,9 @@ static void avecintc_compose_msi_msg(struct irq_data *d, struct msi_msg *msg)
 	struct avecintc_data *adata = irq_data_get_irq_chip_data(d);
 
 	msg->address_hi = 0x0;
-	msg->address_lo = (loongarch_avec.msi_base_addr | (adata->vec & 0xff) << 4)
-			  | ((cpu_logical_map(adata->cpu & 0xffff)) << 12);
+	msg->address_lo = (loongarch_avec.msi_base_addr |
+			(adata->vec & AVEC_VIRQ_MASK) << AVEC_VIRQ_SHIFT) |
+			((cpu_logical_map(adata->cpu & AVEC_CPU_MASK)) << AVEC_CPU_SHIFT);
 	msg->data = 0x0;
 }
 
-- 
2.39.3


