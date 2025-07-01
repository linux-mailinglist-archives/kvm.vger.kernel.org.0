Return-Path: <kvm+bounces-51146-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C0ECAEECE7
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 05:15:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9ACC53BB0CE
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 03:15:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48D371F4634;
	Tue,  1 Jul 2025 03:15:10 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CEE91E1E1E;
	Tue,  1 Jul 2025 03:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751339709; cv=none; b=t2/57V+uT31jqsESXngUJDl/I4MZ8mm12jHawn6XzoSv8/PIDVO1Yx9v4iR4/I5pGLfnoo2gC6oFblQTsWqCIfUDQd86i6wwk1RaNX+r4ypzs+zYGC+aI5P4vgBZ4v2klBRVJxhKRQXD3gRiSKMrVAaRIUKutLw+5Md6XwmKFSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751339709; c=relaxed/simple;
	bh=MGT+fTl2sRAydGF0Mk/yyn4RoOfW/7vN4A7VhoOQ29E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MOMqgUT9xWfYqvEceLIeAWVBpgP8DhiJTM0v5AwpnfLNucKYeX92jMZpWZerhxCyQVDXfvL3hod2youiDWWw1jG1b7jnM8BOJmj0Y3v7uGlnaxHwiW0usgIcJ9OTuZ9HAQ2UOtzGTk1nTwhSdi6f3bsHp0YULzdovfm59IfUptM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8DxjXK5UmNoLlAgAQ--.4965S3;
	Tue, 01 Jul 2025 11:15:05 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJCxocK4UmNo7GcEAA--.27349S3;
	Tue, 01 Jul 2025 11:15:05 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	Xianglai Li <lixianglai@loongson.cn>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 10/13] LoongArch: KVM: Remove local variable offset
Date: Tue,  1 Jul 2025 11:15:01 +0800
Message-Id: <20250701031504.1233777-2-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20250701031504.1233777-1-maobibo@loongson.cn>
References: <20250701030842.1136519-1-maobibo@loongson.cn>
 <20250701031504.1233777-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJCxocK4UmNo7GcEAA--.27349S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Local variable offset is removed and addr is used directly.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/kvm/intc/eiointc.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/arch/loongarch/kvm/intc/eiointc.c b/arch/loongarch/kvm/intc/eiointc.c
index 5f2c291049b1..c2687fbee106 100644
--- a/arch/loongarch/kvm/intc/eiointc.c
+++ b/arch/loongarch/kvm/intc/eiointc.c
@@ -474,14 +474,13 @@ static int loongarch_eiointc_writeq(struct kvm_vcpu *vcpu,
 	int index, irq, ret = 0;
 	u8 cpu;
 	u64 data, old_data;
-	gpa_t offset;
 
 	data = *(u64 *)val;
-	offset = addr - EIOINTC_BASE;
+	addr -= EIOINTC_BASE;
 
-	switch (offset) {
+	switch (addr) {
 	case EIOINTC_NODETYPE_START ... EIOINTC_NODETYPE_END:
-		index = (offset - EIOINTC_NODETYPE_START) >> 3;
+		index = (addr - EIOINTC_NODETYPE_START) >> 3;
 		s->nodetype.reg_u64[index] = data;
 		break;
 	case EIOINTC_IPMAP_START ... EIOINTC_IPMAP_END:
@@ -489,11 +488,11 @@ static int loongarch_eiointc_writeq(struct kvm_vcpu *vcpu,
 		 * ipmap cannot be set at runtime, can be set only at the beginning
 		 * of irqchip driver, need not update upper irq level
 		 */
-		index = (offset - EIOINTC_IPMAP_START) >> 3;
+		index = (addr - EIOINTC_IPMAP_START) >> 3;
 		s->ipmap.reg_u64 = data;
 		break;
 	case EIOINTC_ENABLE_START ... EIOINTC_ENABLE_END:
-		index = (offset - EIOINTC_ENABLE_START) >> 3;
+		index = (addr - EIOINTC_ENABLE_START) >> 3;
 		old_data = s->enable.reg_u64[index];
 		s->enable.reg_u64[index] = data;
 		/*
@@ -520,11 +519,11 @@ static int loongarch_eiointc_writeq(struct kvm_vcpu *vcpu,
 		break;
 	case EIOINTC_BOUNCE_START ... EIOINTC_BOUNCE_END:
 		/* do not emulate hw bounced irq routing */
-		index = (offset - EIOINTC_BOUNCE_START) >> 3;
+		index = (addr - EIOINTC_BOUNCE_START) >> 3;
 		s->bounce.reg_u64[index] = data;
 		break;
 	case EIOINTC_COREISR_START ... EIOINTC_COREISR_END:
-		index = (offset - EIOINTC_COREISR_START) >> 3;
+		index = (addr - EIOINTC_COREISR_START) >> 3;
 		/* use attrs to get current cpu index */
 		cpu = vcpu->vcpu_id;
 		old_data = s->coreisr.reg_u64[cpu][index];
@@ -538,7 +537,7 @@ static int loongarch_eiointc_writeq(struct kvm_vcpu *vcpu,
 		}
 		break;
 	case EIOINTC_COREMAP_START ... EIOINTC_COREMAP_END:
-		irq = offset - EIOINTC_COREMAP_START;
+		irq = addr - EIOINTC_COREMAP_START;
 		index = irq >> 3;
 		s->coremap.reg_u64[index] = data;
 		eiointc_update_sw_coremap(s, irq, data, sizeof(data), true);
-- 
2.39.3


