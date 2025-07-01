Return-Path: <kvm+bounces-51142-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E1B0AAEECC8
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 05:10:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 36C33441FFE
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 03:10:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5FA01EFF8D;
	Tue,  1 Jul 2025 03:08:58 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 506F421128D;
	Tue,  1 Jul 2025 03:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751339338; cv=none; b=MHSPD3Fz78Qd+/Lzfb3wQ4+qAg4dNBY+p/pbAlFKmSq7mR9/2yxSLigUBYvh28Tt83YbgFRvfdUnAVuByunUh7WfObMi603ilebNqxx4dwv2hXMxGidGMGgvzLLP/LzBKip2SJjCu5IiRIiUddMVZxbLOxJhE6VK+wGU60oeZDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751339338; c=relaxed/simple;
	bh=d/GiWxD6/wZ5aEnjqtmRQr87jpApf2kZ01B12WVEuLs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CxJZkDCZN3dJsyOz1AyKKmAnLJmY3Lzg2SXoHc4JmPGzs00PGJysjpdBByEzItz2gWybih0SCD12OUD3t027YvYg7lKuV4G9lyIk03HqwsysFaIinFyMPI91DYePLRcfSG0jtox6BLP3ZR7hGsGrx8h2hFdq+nrI94qLF4rtAIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8CxLGtHUWNouk4gAQ--.5240S3;
	Tue, 01 Jul 2025 11:08:55 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJBxpeQ7UWNolGYEAA--.27732S9;
	Tue, 01 Jul 2025 11:08:54 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	Xianglai Li <lixianglai@loongson.cn>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 07/13] LoongArch: KVM: Remove some unnecessary local variables
Date: Tue,  1 Jul 2025 11:08:36 +0800
Message-Id: <20250701030842.1136519-8-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20250701030842.1136519-1-maobibo@loongson.cn>
References: <20250701030842.1136519-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJBxpeQ7UWNolGYEAA--.27732S9
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Local variable coreisr and old_coreisr is replaced with data and
old_data, and the latter is widely used in other sentences.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/kvm/intc/eiointc.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/arch/loongarch/kvm/intc/eiointc.c b/arch/loongarch/kvm/intc/eiointc.c
index b49611c00b0e..31f2c7476d6f 100644
--- a/arch/loongarch/kvm/intc/eiointc.c
+++ b/arch/loongarch/kvm/intc/eiointc.c
@@ -474,7 +474,6 @@ static int loongarch_eiointc_writeq(struct kvm_vcpu *vcpu,
 	int i, index, irq, bits, ret = 0;
 	u8 cpu;
 	u64 data, old_data;
-	u64 coreisr, old_coreisr;
 	gpa_t offset;
 
 	data = *(u64 *)val;
@@ -525,17 +524,16 @@ static int loongarch_eiointc_writeq(struct kvm_vcpu *vcpu,
 		index = (offset - EIOINTC_COREISR_START) >> 3;
 		/* use attrs to get current cpu index */
 		cpu = vcpu->vcpu_id;
-		coreisr = data;
-		old_coreisr = s->coreisr.reg_u64[cpu][index];
+		old_data = s->coreisr.reg_u64[cpu][index];
 		/* write 1 to clear interrupt */
-		s->coreisr.reg_u64[cpu][index] = old_coreisr & ~coreisr;
-		coreisr &= old_coreisr;
+		s->coreisr.reg_u64[cpu][index] = old_data & ~data;
+		data &= old_data;
 		bits = sizeof(data) * 8;
-		irq = find_first_bit((void *)&coreisr, bits);
+		irq = find_first_bit((void *)&data, bits);
 		while (irq < bits) {
 			eiointc_update_irq(s, irq + index * bits, 0);
-			bitmap_clear((void *)&coreisr, irq, 1);
-			irq = find_first_bit((void *)&coreisr, bits);
+			bitmap_clear((void *)&data, irq, 1);
+			irq = find_first_bit((void *)&data, bits);
 		}
 		break;
 	case EIOINTC_COREMAP_START ... EIOINTC_COREMAP_END:
-- 
2.39.3


