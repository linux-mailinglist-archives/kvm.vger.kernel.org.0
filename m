Return-Path: <kvm+bounces-51890-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E48C0AFE1CC
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 10:04:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 23D94541EB6
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 08:03:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB5ED274B49;
	Wed,  9 Jul 2025 08:02:48 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C2992749DC;
	Wed,  9 Jul 2025 08:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752048168; cv=none; b=rr8kroxpdCKltL1RjZhMOvDz3VYR5szPUUsUVv18HFWsGInetu9JMekNYbxCZd7ilTQ87ahognIXHXDpHYeTWfRkTks5Xxy2LI2HX4cfnE/wKnWv9HWGWfzngYWPW5Kml8cR6cRdLJF/HYkC4frKT+J64j0swFe3d0eR1lJxb+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752048168; c=relaxed/simple;
	bh=o4TIx92RBZnLsQZf5EAsiMP4FKhwveOeG+D2/fxYzmQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VylOGSSBq1aqmElgR7pcgiHPInoNZDJa0bnxYCg5GmV/0IXYRUoNJYgTtUXyePPChxgObnnbZ+mCE9FD+7QkoadBZDdlDU6r7Oba8zJ8Pq4jt14zWJdX8xHWR+ReJkIUjxx7qO6Yc+1z8XR9YFpJlWiX1LPAuxhU675V+SpqXII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8CxqmobIm5oVSklAQ--.38718S3;
	Wed, 09 Jul 2025 16:02:35 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJBxpeQZIm5oS6cPAA--.24964S4;
	Wed, 09 Jul 2025 16:02:34 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	Xianglai Li <lixianglai@loongson.cn>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v6 2/8] LoongArch: KVM: Remove unused parameter len
Date: Wed,  9 Jul 2025 16:02:27 +0800
Message-Id: <20250709080233.3948503-3-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20250709080233.3948503-1-maobibo@loongson.cn>
References: <20250709080233.3948503-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJBxpeQZIm5oS6cPAA--.24964S4
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Parameter len is unused in some functions with eiointc emulation
driver, remove it here.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/kvm/intc/eiointc.c | 32 +++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/arch/loongarch/kvm/intc/eiointc.c b/arch/loongarch/kvm/intc/eiointc.c
index 3cf9894999da..acd975ce9608 100644
--- a/arch/loongarch/kvm/intc/eiointc.c
+++ b/arch/loongarch/kvm/intc/eiointc.c
@@ -131,7 +131,7 @@ static inline void eiointc_enable_irq(struct kvm_vcpu *vcpu,
 }
 
 static int loongarch_eiointc_readb(struct kvm_vcpu *vcpu, struct loongarch_eiointc *s,
-				gpa_t addr, int len, void *val)
+				gpa_t addr, void *val)
 {
 	int index, ret = 0;
 	u8 data = 0;
@@ -173,7 +173,7 @@ static int loongarch_eiointc_readb(struct kvm_vcpu *vcpu, struct loongarch_eioin
 }
 
 static int loongarch_eiointc_readw(struct kvm_vcpu *vcpu, struct loongarch_eiointc *s,
-				gpa_t addr, int len, void *val)
+				gpa_t addr, void *val)
 {
 	int index, ret = 0;
 	u16 data = 0;
@@ -215,7 +215,7 @@ static int loongarch_eiointc_readw(struct kvm_vcpu *vcpu, struct loongarch_eioin
 }
 
 static int loongarch_eiointc_readl(struct kvm_vcpu *vcpu, struct loongarch_eiointc *s,
-				gpa_t addr, int len, void *val)
+				gpa_t addr, void *val)
 {
 	int index, ret = 0;
 	u32 data = 0;
@@ -257,7 +257,7 @@ static int loongarch_eiointc_readl(struct kvm_vcpu *vcpu, struct loongarch_eioin
 }
 
 static int loongarch_eiointc_readq(struct kvm_vcpu *vcpu, struct loongarch_eiointc *s,
-				gpa_t addr, int len, void *val)
+				gpa_t addr, void *val)
 {
 	int index, ret = 0;
 	u64 data = 0;
@@ -320,16 +320,16 @@ static int kvm_eiointc_read(struct kvm_vcpu *vcpu,
 	spin_lock_irqsave(&eiointc->lock, flags);
 	switch (len) {
 	case 1:
-		ret = loongarch_eiointc_readb(vcpu, eiointc, addr, len, val);
+		ret = loongarch_eiointc_readb(vcpu, eiointc, addr, val);
 		break;
 	case 2:
-		ret = loongarch_eiointc_readw(vcpu, eiointc, addr, len, val);
+		ret = loongarch_eiointc_readw(vcpu, eiointc, addr, val);
 		break;
 	case 4:
-		ret = loongarch_eiointc_readl(vcpu, eiointc, addr, len, val);
+		ret = loongarch_eiointc_readl(vcpu, eiointc, addr, val);
 		break;
 	case 8:
-		ret = loongarch_eiointc_readq(vcpu, eiointc, addr, len, val);
+		ret = loongarch_eiointc_readq(vcpu, eiointc, addr, val);
 		break;
 	default:
 		WARN_ONCE(1, "%s: Abnormal address access: addr 0x%llx, size %d\n",
@@ -342,7 +342,7 @@ static int kvm_eiointc_read(struct kvm_vcpu *vcpu,
 
 static int loongarch_eiointc_writeb(struct kvm_vcpu *vcpu,
 				struct loongarch_eiointc *s,
-				gpa_t addr, int len, const void *val)
+				gpa_t addr, const void *val)
 {
 	int index, irq, bits, ret = 0;
 	u8 cpu;
@@ -421,7 +421,7 @@ static int loongarch_eiointc_writeb(struct kvm_vcpu *vcpu,
 
 static int loongarch_eiointc_writew(struct kvm_vcpu *vcpu,
 				struct loongarch_eiointc *s,
-				gpa_t addr, int len, const void *val)
+				gpa_t addr, const void *val)
 {
 	int i, index, irq, bits, ret = 0;
 	u8 cpu;
@@ -506,7 +506,7 @@ static int loongarch_eiointc_writew(struct kvm_vcpu *vcpu,
 
 static int loongarch_eiointc_writel(struct kvm_vcpu *vcpu,
 				struct loongarch_eiointc *s,
-				gpa_t addr, int len, const void *val)
+				gpa_t addr, const void *val)
 {
 	int i, index, irq, bits, ret = 0;
 	u8 cpu;
@@ -591,7 +591,7 @@ static int loongarch_eiointc_writel(struct kvm_vcpu *vcpu,
 
 static int loongarch_eiointc_writeq(struct kvm_vcpu *vcpu,
 				struct loongarch_eiointc *s,
-				gpa_t addr, int len, const void *val)
+				gpa_t addr, const void *val)
 {
 	int i, index, irq, bits, ret = 0;
 	u8 cpu;
@@ -696,16 +696,16 @@ static int kvm_eiointc_write(struct kvm_vcpu *vcpu,
 	spin_lock_irqsave(&eiointc->lock, flags);
 	switch (len) {
 	case 1:
-		ret = loongarch_eiointc_writeb(vcpu, eiointc, addr, len, val);
+		ret = loongarch_eiointc_writeb(vcpu, eiointc, addr, val);
 		break;
 	case 2:
-		ret = loongarch_eiointc_writew(vcpu, eiointc, addr, len, val);
+		ret = loongarch_eiointc_writew(vcpu, eiointc, addr, val);
 		break;
 	case 4:
-		ret = loongarch_eiointc_writel(vcpu, eiointc, addr, len, val);
+		ret = loongarch_eiointc_writel(vcpu, eiointc, addr, val);
 		break;
 	case 8:
-		ret = loongarch_eiointc_writeq(vcpu, eiointc, addr, len, val);
+		ret = loongarch_eiointc_writeq(vcpu, eiointc, addr, val);
 		break;
 	default:
 		WARN_ONCE(1, "%s: Abnormal address access: addr 0x%llx, size %d\n",
-- 
2.39.3


