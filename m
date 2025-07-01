Return-Path: <kvm+bounces-51149-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 68D9FAEECED
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 05:16:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D37733E24AD
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 03:16:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F59222689C;
	Tue,  1 Jul 2025 03:15:15 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B671218ADC;
	Tue,  1 Jul 2025 03:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751339714; cv=none; b=G1Oye2cutCxRzTN5yyn4y7SqwNLYoa9SOm6Q8Pg4qtVTx+ptZdMc4mu4sIXhJUqyqTMZXtSY5U2spSp/g1krdZv8apOxpQ06HwI11n3hA65VPZ9PTUAP+smF6eNZfqvR3Feq0OOcUaVemgqeL5004CHdzQ+k9YG3wCTONjvOoho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751339714; c=relaxed/simple;
	bh=r6pQNO+LV24ERrRpRddUuJqYDzpQsXc/V3a5Tlz8ZyE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=b9cYcFv2d2PUqVYPOAwBccEK1KKYJuPAwvH1OquXHcVAV8n6evS1czlez/g1EcPIxShxdZlwoz+LG2Te3BDVxxTQwxEx294jZUB0nJGWYAlNC54WB/7r1tzAtVNMKkB3Axpa9oJ/fdIpPEtnmrcnCChas0Gq9DEBf7br3XcK3PM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8AxquC5UmNoMVAgAQ--.29866S3;
	Tue, 01 Jul 2025 11:15:05 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJCxocK4UmNo7GcEAA--.27349S4;
	Tue, 01 Jul 2025 11:15:05 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	Xianglai Li <lixianglai@loongson.cn>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 11/13] LoongArch: KVM: Rename old_data with old
Date: Tue,  1 Jul 2025 11:15:02 +0800
Message-Id: <20250701031504.1233777-3-maobibo@loongson.cn>
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
X-CM-TRANSID:qMiowJCxocK4UmNo7GcEAA--.27349S4
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

For simplicity, rename local variable old_data with old.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/kvm/intc/eiointc.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/loongarch/kvm/intc/eiointc.c b/arch/loongarch/kvm/intc/eiointc.c
index c2687fbee106..7844463ee2b9 100644
--- a/arch/loongarch/kvm/intc/eiointc.c
+++ b/arch/loongarch/kvm/intc/eiointc.c
@@ -473,7 +473,7 @@ static int loongarch_eiointc_writeq(struct kvm_vcpu *vcpu,
 {
 	int index, irq, ret = 0;
 	u8 cpu;
-	u64 data, old_data;
+	u64 data, old;
 
 	data = *(u64 *)val;
 	addr -= EIOINTC_BASE;
@@ -488,18 +488,17 @@ static int loongarch_eiointc_writeq(struct kvm_vcpu *vcpu,
 		 * ipmap cannot be set at runtime, can be set only at the beginning
 		 * of irqchip driver, need not update upper irq level
 		 */
-		index = (addr - EIOINTC_IPMAP_START) >> 3;
 		s->ipmap.reg_u64 = data;
 		break;
 	case EIOINTC_ENABLE_START ... EIOINTC_ENABLE_END:
 		index = (addr - EIOINTC_ENABLE_START) >> 3;
-		old_data = s->enable.reg_u64[index];
+		old = s->enable.reg_u64[index];
 		s->enable.reg_u64[index] = data;
 		/*
 		 * 1: enable irq.
 		 * update irq when isr is set.
 		 */
-		data = s->enable.reg_u64[index] & ~old_data & s->isr.reg_u64[index];
+		data = s->enable.reg_u64[index] & ~old & s->isr.reg_u64[index];
 		while (data) {
 			irq = __ffs(data);
 			eiointc_update_irq(s, irq + index * 64, 1);
@@ -510,7 +509,7 @@ static int loongarch_eiointc_writeq(struct kvm_vcpu *vcpu,
 		 * 0: disable irq.
 		 * update irq when isr is set.
 		 */
-		data = ~s->enable.reg_u64[index] & old_data & s->isr.reg_u64[index];
+		data = ~s->enable.reg_u64[index] & old & s->isr.reg_u64[index];
 		while (data) {
 			irq = __ffs(data);
 			eiointc_update_irq(s, irq + index * 64, 0);
@@ -526,10 +525,10 @@ static int loongarch_eiointc_writeq(struct kvm_vcpu *vcpu,
 		index = (addr - EIOINTC_COREISR_START) >> 3;
 		/* use attrs to get current cpu index */
 		cpu = vcpu->vcpu_id;
-		old_data = s->coreisr.reg_u64[cpu][index];
+		old = s->coreisr.reg_u64[cpu][index];
 		/* write 1 to clear interrupt */
-		s->coreisr.reg_u64[cpu][index] = old_data & ~data;
-		data &= old_data;
+		s->coreisr.reg_u64[cpu][index] = old & ~data;
+		data &= old;
 		while (data) {
 			irq = __ffs(data);
 			eiointc_update_irq(s, irq + index * 64, 0);
-- 
2.39.3


