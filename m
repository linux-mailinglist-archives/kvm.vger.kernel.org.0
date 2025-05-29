Return-Path: <kvm+bounces-47920-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B1C8AC7545
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 03:12:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2CB05A217E4
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 01:12:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFB7C207DF7;
	Thu, 29 May 2025 01:11:18 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 701321D6194;
	Thu, 29 May 2025 01:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748481078; cv=none; b=FQmtQICYfRlgBeyt+2CxDdbrha14g5b7QJjRrP+LoGr5D2dYUd1/cndJQLDYZzvEDdU6U16V7owAyWjFxK72Q7dc60uBV+eVVglfUWvrIjWre6FFhfWA7yLUzicJE+75EzMCau6HsJ06xDb8h8AQyYAlYK/uSLbJgCkrM3H4150=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748481078; c=relaxed/simple;
	bh=fuEkZAgcVPhsiFb0WuQVgKJco0f6gnpzL76c6CKoNkU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fd1tBSq+F8NVFqSN2NtLtbkG5Eh4Mg8/cxQOYfP9BfXjmd+4S6c85eNRin/PjJQr5L7WebTwn2xdVsVy1mEfLM3ctL/poWnaf36cVLtoFJX/TZSf0kFav8dpUCLCjxMh87UwoSzp1vP9P4qC9p4d4Rxaynfkbh+cAJoqVZE5G7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8CxNHAxtDdovh4BAQ--.19886S3;
	Thu, 29 May 2025 09:11:13 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowMCx_cYmtDdoR0P5AA--.57458S6;
	Thu, 29 May 2025 09:11:13 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	Xianglai Li <lixianglai@loongson.cn>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] LoongArch: KVM: Remove unused parameter len
Date: Thu, 29 May 2025 09:11:01 +0800
Message-Id: <20250529011102.378749-5-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20250529011102.378749-1-maobibo@loongson.cn>
References: <20250529011102.378749-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMCx_cYmtDdoR0P5AA--.57458S6
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
index b3aa6e305a18..41fe1e6e9d3b 100644
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
@@ -315,16 +315,16 @@ static int kvm_eiointc_read(struct kvm_vcpu *vcpu,
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
@@ -337,7 +337,7 @@ static int kvm_eiointc_read(struct kvm_vcpu *vcpu,
 
 static int loongarch_eiointc_writeb(struct kvm_vcpu *vcpu,
 				struct loongarch_eiointc *s,
-				gpa_t addr, int len, const void *val)
+				gpa_t addr, const void *val)
 {
 	int index, irq, bits, ret = 0;
 	u8 cpu;
@@ -416,7 +416,7 @@ static int loongarch_eiointc_writeb(struct kvm_vcpu *vcpu,
 
 static int loongarch_eiointc_writew(struct kvm_vcpu *vcpu,
 				struct loongarch_eiointc *s,
-				gpa_t addr, int len, const void *val)
+				gpa_t addr, const void *val)
 {
 	int i, index, irq, bits, ret = 0;
 	u8 cpu;
@@ -502,7 +502,7 @@ static int loongarch_eiointc_writew(struct kvm_vcpu *vcpu,
 
 static int loongarch_eiointc_writel(struct kvm_vcpu *vcpu,
 				struct loongarch_eiointc *s,
-				gpa_t addr, int len, const void *val)
+				gpa_t addr, const void *val)
 {
 	int i, index, irq, bits, ret = 0;
 	u8 cpu;
@@ -588,7 +588,7 @@ static int loongarch_eiointc_writel(struct kvm_vcpu *vcpu,
 
 static int loongarch_eiointc_writeq(struct kvm_vcpu *vcpu,
 				struct loongarch_eiointc *s,
-				gpa_t addr, int len, const void *val)
+				gpa_t addr, const void *val)
 {
 	int i, index, irq, bits, ret = 0;
 	u8 cpu;
@@ -689,16 +689,16 @@ static int kvm_eiointc_write(struct kvm_vcpu *vcpu,
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


