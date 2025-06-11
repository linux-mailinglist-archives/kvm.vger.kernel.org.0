Return-Path: <kvm+bounces-48949-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C0EDAD4840
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 03:50:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EC7383AA357
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 01:49:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CE0D1DF970;
	Wed, 11 Jun 2025 01:47:16 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 874601C6FFB;
	Wed, 11 Jun 2025 01:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749606435; cv=none; b=WpCQ7WX8RH62c/Nzboa4YJ823iZjPVypHIaYMqMSRZ8GyHJzS65ecT9c34YcvDYX98AEOMyVaA2/87/Tf4bXyRsuLtxPhuH2C5Sxbf1yYrCaOA94vVTWoOap57jLL+aoxo+6iAID/dcef8RJcBlM7mHEBpCmGyfTfbU39Q/qXAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749606435; c=relaxed/simple;
	bh=2m9/vuV3j46QGITAqf7bOKrk3jOUuBuESFmNz+39bVs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GOMa7h+bdUAUuZuvR/xPE1TQyz8iem3hB7rvpG0zrMGYeSEgrOKLz71PgRTB/G9oUMY8ZWtGpMsUtWkQQlLhmD5pB/NGjz9yfCdZkujd2r5mW75XVneLTdSiPS9J7wBgjkrW/pEenUIOXbik4PaBVSoNcb5gIuwdpeipQKTAivY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8DxjXIf4Ehot0ITAQ--.47174S3;
	Wed, 11 Jun 2025 09:47:11 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowMCx7MQL4Eho0EoVAQ--.65102S9;
	Wed, 11 Jun 2025 09:47:11 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	Xianglai Li <lixianglai@loongson.cn>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 7/9] LoongArch: KVM: INTC: Remove unused parameter len
Date: Wed, 11 Jun 2025 09:46:49 +0800
Message-Id: <20250611014651.3042734-8-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20250611014651.3042734-1-maobibo@loongson.cn>
References: <20250611014651.3042734-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMCx7MQL4Eho0EoVAQ--.65102S9
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
index 0a3c5cd0993a..1dad8342d84e 100644
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
@@ -501,7 +501,7 @@ static int loongarch_eiointc_writew(struct kvm_vcpu *vcpu,
 
 static int loongarch_eiointc_writel(struct kvm_vcpu *vcpu,
 				struct loongarch_eiointc *s,
-				gpa_t addr, int len, const void *val)
+				gpa_t addr, const void *val)
 {
 	int i, index, irq, bits, ret = 0;
 	u8 cpu;
@@ -586,7 +586,7 @@ static int loongarch_eiointc_writel(struct kvm_vcpu *vcpu,
 
 static int loongarch_eiointc_writeq(struct kvm_vcpu *vcpu,
 				struct loongarch_eiointc *s,
-				gpa_t addr, int len, const void *val)
+				gpa_t addr, const void *val)
 {
 	int i, index, irq, bits, ret = 0;
 	u8 cpu;
@@ -686,16 +686,16 @@ static int kvm_eiointc_write(struct kvm_vcpu *vcpu,
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


