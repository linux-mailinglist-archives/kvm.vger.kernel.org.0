Return-Path: <kvm+bounces-69664-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eLDLM8kifGnJKgIAu9opvQ
	(envelope-from <kvm+bounces-69664-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 04:17:29 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E584B6C4F
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 04:17:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id ECBF63013AB1
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 03:17:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB0AC32F745;
	Fri, 30 Jan 2026 03:17:15 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 015AB1DF74F;
	Fri, 30 Jan 2026 03:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769743035; cv=none; b=ZpSDnnvmnjhf5/186m23wQJBEFMaU9xiIPkjF3/C00elWPxKyZjpIaKwIrwLSlwve7nu/To4zA6kHCZy9NuR9QWrcSg3/5hgHeIbR3WCgADpVRj/vL+cjQdLgPnprILi3KFtzPbWWvva5NYXY06AGyqBMtlWAA8A8N5bS0ihH0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769743035; c=relaxed/simple;
	bh=ESBPA/l+Ci9xq0i97uA6ugk5N/WDMpXEIz/ZRAqUW0o=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=lI9OS1HDiE29r631HW5meNXFYK18fg1T9ILBNNDg5WC8n1DzZEPltdfMh8xIX4lYVdKboJgluJtcgsRM4R2PAeP44gXzfhtH4TBHeTjW5BCsM/kpgjZGfRNH++omk1P8hYK0VdLAOJOBxqxxMTy8YZOwgGhnAKVecad6V3nt8/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8BxHMO0InxpQyYOAA--.46013S3;
	Fri, 30 Jan 2026 11:17:08 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJBxSeCyInxpuvg5AA--.45071S2;
	Fri, 30 Jan 2026 11:17:07 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Tianrui Zhao <zhaotianrui@loongson.cn>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] LoongArch: KVM: Set default return value in kvm IO bus ops
Date: Fri, 30 Jan 2026 11:17:05 +0800
Message-Id: <20260130031705.3929925-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJBxSeCyInxpuvg5AA--.45071S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.04 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	DMARC_NA(0.00)[loongson.cn];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-69664-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	PRECEDENCE_BULK(0.00)[];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-0.997];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NEQ_ENVFROM(0.00)[maobibo@loongson.cn,kvm@vger.kernel.org];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,loongson.cn:mid,loongson.cn:email]
X-Rspamd-Queue-Id: 5E584B6C4F
X-Rspamd-Action: no action

When irqchip in kernel is enabled, its register area is registered
in the IO bus list with API kvm_io_bus_register_dev(). In MMIO/IOCSR
register access emulation, kvm_io_bus_write/kvm_io_bus_read is called
firstly. If it returns 0, it shows that in kernel irqchip handles
the emulation already, else it returns to VMM and lets VMM emulate
the register access.

Once irqchip in kernel is enabled, it should return 0 if the address
is within range of the registered IO bus. It should not return to VMM
since VMM does not know how to handle it, and irqchip is handled in
kernel already.

Here set default return value with 0 in KVM IO bus operations.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
v1 ... v2:
  1. Set return value with 0 in function mail_send() and send_ipi_data()
---
 arch/loongarch/kvm/intc/eiointc.c | 43 ++++++++++++-------------------
 arch/loongarch/kvm/intc/ipi.c     | 24 ++++++++---------
 arch/loongarch/kvm/intc/pch_pic.c | 31 ++++++++++------------
 3 files changed, 42 insertions(+), 56 deletions(-)

diff --git a/arch/loongarch/kvm/intc/eiointc.c b/arch/loongarch/kvm/intc/eiointc.c
index dfaf6ccfdd8b..e498a3f1e136 100644
--- a/arch/loongarch/kvm/intc/eiointc.c
+++ b/arch/loongarch/kvm/intc/eiointc.c
@@ -119,7 +119,7 @@ void eiointc_set_irq(struct loongarch_eiointc *s, int irq, int level)
 static int loongarch_eiointc_read(struct kvm_vcpu *vcpu, struct loongarch_eiointc *s,
 				gpa_t addr, unsigned long *val)
 {
-	int index, ret = 0;
+	int index;
 	u64 data = 0;
 	gpa_t offset;
 
@@ -150,40 +150,36 @@ static int loongarch_eiointc_read(struct kvm_vcpu *vcpu, struct loongarch_eioint
 		data = s->coremap[index];
 		break;
 	default:
-		ret = -EINVAL;
 		break;
 	}
 	*val = data;
 
-	return ret;
+	return 0;
 }
 
 static int kvm_eiointc_read(struct kvm_vcpu *vcpu,
 			struct kvm_io_device *dev,
 			gpa_t addr, int len, void *val)
 {
-	int ret = -EINVAL;
 	unsigned long flags, data, offset;
 	struct loongarch_eiointc *eiointc = vcpu->kvm->arch.eiointc;
 
 	if (!eiointc) {
 		kvm_err("%s: eiointc irqchip not valid!\n", __func__);
-		return -EINVAL;
+		return 0;
 	}
 
 	if (addr & (len - 1)) {
 		kvm_err("%s: eiointc not aligned addr %llx len %d\n", __func__, addr, len);
-		return -EINVAL;
+		return 0;
 	}
 
 	offset = addr & 0x7;
 	addr -= offset;
 	vcpu->stat.eiointc_read_exits++;
 	spin_lock_irqsave(&eiointc->lock, flags);
-	ret = loongarch_eiointc_read(vcpu, eiointc, addr, &data);
+	loongarch_eiointc_read(vcpu, eiointc, addr, &data);
 	spin_unlock_irqrestore(&eiointc->lock, flags);
-	if (ret)
-		return ret;
 
 	data = data >> (offset * 8);
 	switch (len) {
@@ -208,7 +204,7 @@ static int loongarch_eiointc_write(struct kvm_vcpu *vcpu,
 				struct loongarch_eiointc *s,
 				gpa_t addr, u64 value, u64 field_mask)
 {
-	int index, irq, ret = 0;
+	int index, irq;
 	u8 cpu;
 	u64 data, old, mask;
 	gpa_t offset;
@@ -287,29 +283,27 @@ static int loongarch_eiointc_write(struct kvm_vcpu *vcpu,
 		eiointc_update_sw_coremap(s, index * 8, data, sizeof(data), true);
 		break;
 	default:
-		ret = -EINVAL;
 		break;
 	}
 
-	return ret;
+	return 0;
 }
 
 static int kvm_eiointc_write(struct kvm_vcpu *vcpu,
 			struct kvm_io_device *dev,
 			gpa_t addr, int len, const void *val)
 {
-	int ret = -EINVAL;
 	unsigned long flags, value;
 	struct loongarch_eiointc *eiointc = vcpu->kvm->arch.eiointc;
 
 	if (!eiointc) {
 		kvm_err("%s: eiointc irqchip not valid!\n", __func__);
-		return -EINVAL;
+		return 0;
 	}
 
 	if (addr & (len - 1)) {
 		kvm_err("%s: eiointc not aligned addr %llx len %d\n", __func__, addr, len);
-		return -EINVAL;
+		return 0;
 	}
 
 	vcpu->stat.eiointc_write_exits++;
@@ -317,24 +311,24 @@ static int kvm_eiointc_write(struct kvm_vcpu *vcpu,
 	switch (len) {
 	case 1:
 		value = *(unsigned char *)val;
-		ret = loongarch_eiointc_write(vcpu, eiointc, addr, value, 0xFF);
+		loongarch_eiointc_write(vcpu, eiointc, addr, value, 0xFF);
 		break;
 	case 2:
 		value = *(unsigned short *)val;
-		ret = loongarch_eiointc_write(vcpu, eiointc, addr, value, USHRT_MAX);
+		loongarch_eiointc_write(vcpu, eiointc, addr, value, USHRT_MAX);
 		break;
 	case 4:
 		value = *(unsigned int *)val;
-		ret = loongarch_eiointc_write(vcpu, eiointc, addr, value, UINT_MAX);
+		loongarch_eiointc_write(vcpu, eiointc, addr, value, UINT_MAX);
 		break;
 	default:
 		value = *(unsigned long *)val;
-		ret = loongarch_eiointc_write(vcpu, eiointc, addr, value, ULONG_MAX);
+		loongarch_eiointc_write(vcpu, eiointc, addr, value, ULONG_MAX);
 		break;
 	}
 	spin_unlock_irqrestore(&eiointc->lock, flags);
 
-	return ret;
+	return 0;
 }
 
 static const struct kvm_io_device_ops kvm_eiointc_ops = {
@@ -352,7 +346,7 @@ static int kvm_eiointc_virt_read(struct kvm_vcpu *vcpu,
 
 	if (!eiointc) {
 		kvm_err("%s: eiointc irqchip not valid!\n", __func__);
-		return -EINVAL;
+		return 0;
 	}
 
 	addr -= EIOINTC_VIRT_BASE;
@@ -376,28 +370,25 @@ static int kvm_eiointc_virt_write(struct kvm_vcpu *vcpu,
 				struct kvm_io_device *dev,
 				gpa_t addr, int len, const void *val)
 {
-	int ret = 0;
 	unsigned long flags;
 	u32 value = *(u32 *)val;
 	struct loongarch_eiointc *eiointc = vcpu->kvm->arch.eiointc;
 
 	if (!eiointc) {
 		kvm_err("%s: eiointc irqchip not valid!\n", __func__);
-		return -EINVAL;
+		return 0;
 	}
 
 	addr -= EIOINTC_VIRT_BASE;
 	spin_lock_irqsave(&eiointc->lock, flags);
 	switch (addr) {
 	case EIOINTC_VIRT_FEATURES:
-		ret = -EPERM;
 		break;
 	case EIOINTC_VIRT_CONFIG:
 		/*
 		 * eiointc features can only be set at disabled status
 		 */
 		if ((eiointc->status & BIT(EIOINTC_ENABLE)) && value) {
-			ret = -EPERM;
 			break;
 		}
 		eiointc->status = value & eiointc->features;
@@ -407,7 +398,7 @@ static int kvm_eiointc_virt_write(struct kvm_vcpu *vcpu,
 	}
 	spin_unlock_irqrestore(&eiointc->lock, flags);
 
-	return ret;
+	return 0;
 }
 
 static const struct kvm_io_device_ops kvm_eiointc_virt_ops = {
diff --git a/arch/loongarch/kvm/intc/ipi.c b/arch/loongarch/kvm/intc/ipi.c
index 1058c13dba7f..b269c249e037 100644
--- a/arch/loongarch/kvm/intc/ipi.c
+++ b/arch/loongarch/kvm/intc/ipi.c
@@ -111,7 +111,7 @@ static int mail_send(struct kvm *kvm, uint64_t data)
 	vcpu = kvm_get_vcpu_by_cpuid(kvm, cpu);
 	if (unlikely(vcpu == NULL)) {
 		kvm_err("%s: invalid target cpu: %d\n", __func__, cpu);
-		return -EINVAL;
+		return 0;
 	}
 	mailbox = ((data & 0xffffffff) >> 2) & 0x7;
 	offset = IOCSR_IPI_BUF_20 + mailbox * 4;
@@ -159,10 +159,17 @@ static int send_ipi_data(struct kvm_vcpu *vcpu, gpa_t addr, uint64_t data)
 	idx = srcu_read_lock(&vcpu->kvm->srcu);
 	ret = kvm_io_bus_write(vcpu, KVM_IOCSR_BUS, addr, 4, &val);
 	srcu_read_unlock(&vcpu->kvm->srcu, idx);
+	/*
+	 * There is no way to forward new IOCSR addr and CPU ID to user
+	 * mode VMM, since anysend IOCSR is emulated in kernel already.
+	 *
+	 * Assuming that anysend IOCSR is only used on eiointc routing
+	 * setting
+	 */
 	if (unlikely(ret))
 		kvm_err("%s: : write data to addr %llx failed\n", __func__, addr);
 
-	return ret;
+	return 0;
 }
 
 static int any_send(struct kvm *kvm, uint64_t data)
@@ -174,7 +181,7 @@ static int any_send(struct kvm *kvm, uint64_t data)
 	vcpu = kvm_get_vcpu_by_cpuid(kvm, cpu);
 	if (unlikely(vcpu == NULL)) {
 		kvm_err("%s: invalid target cpu: %d\n", __func__, cpu);
-		return -EINVAL;
+		return 0;
 	}
 	offset = data & 0xffff;
 
@@ -183,7 +190,6 @@ static int any_send(struct kvm *kvm, uint64_t data)
 
 static int loongarch_ipi_readl(struct kvm_vcpu *vcpu, gpa_t addr, int len, void *val)
 {
-	int ret = 0;
 	uint32_t offset;
 	uint64_t res = 0;
 
@@ -202,28 +208,23 @@ static int loongarch_ipi_readl(struct kvm_vcpu *vcpu, gpa_t addr, int len, void
 		spin_unlock(&vcpu->arch.ipi_state.lock);
 		break;
 	case IOCSR_IPI_SET:
-		res = 0;
-		break;
 	case IOCSR_IPI_CLEAR:
-		res = 0;
 		break;
 	case IOCSR_IPI_BUF_20 ... IOCSR_IPI_BUF_38 + 7:
 		if (offset + len > IOCSR_IPI_BUF_38 + 8) {
 			kvm_err("%s: invalid offset or len: offset = %d, len = %d\n",
 				__func__, offset, len);
-			ret = -EINVAL;
 			break;
 		}
 		res = read_mailbox(vcpu, offset, len);
 		break;
 	default:
 		kvm_err("%s: unknown addr: %llx\n", __func__, addr);
-		ret = -EINVAL;
 		break;
 	}
 	*(uint64_t *)val = res;
 
-	return ret;
+	return 0;
 }
 
 static int loongarch_ipi_writel(struct kvm_vcpu *vcpu, gpa_t addr, int len, const void *val)
@@ -239,7 +240,6 @@ static int loongarch_ipi_writel(struct kvm_vcpu *vcpu, gpa_t addr, int len, cons
 
 	switch (offset) {
 	case IOCSR_IPI_STATUS:
-		ret = -EINVAL;
 		break;
 	case IOCSR_IPI_EN:
 		spin_lock(&vcpu->arch.ipi_state.lock);
@@ -257,7 +257,6 @@ static int loongarch_ipi_writel(struct kvm_vcpu *vcpu, gpa_t addr, int len, cons
 		if (offset + len > IOCSR_IPI_BUF_38 + 8) {
 			kvm_err("%s: invalid offset or len: offset = %d, len = %d\n",
 				__func__, offset, len);
-			ret = -EINVAL;
 			break;
 		}
 		write_mailbox(vcpu, offset, data, len);
@@ -273,7 +272,6 @@ static int loongarch_ipi_writel(struct kvm_vcpu *vcpu, gpa_t addr, int len, cons
 		break;
 	default:
 		kvm_err("%s: unknown addr: %llx\n", __func__, addr);
-		ret = -EINVAL;
 		break;
 	}
 
diff --git a/arch/loongarch/kvm/intc/pch_pic.c b/arch/loongarch/kvm/intc/pch_pic.c
index 4addb34bf432..a175f52fcf7f 100644
--- a/arch/loongarch/kvm/intc/pch_pic.c
+++ b/arch/loongarch/kvm/intc/pch_pic.c
@@ -74,7 +74,7 @@ void pch_msi_set_irq(struct kvm *kvm, int irq, int level)
 
 static int loongarch_pch_pic_read(struct loongarch_pch_pic *s, gpa_t addr, int len, void *val)
 {
-	int ret = 0, offset;
+	int offset;
 	u64 data = 0;
 	void *ptemp;
 
@@ -121,34 +121,32 @@ static int loongarch_pch_pic_read(struct loongarch_pch_pic *s, gpa_t addr, int l
 		data = s->isr;
 		break;
 	default:
-		ret = -EINVAL;
+		break;
 	}
 	spin_unlock(&s->lock);
 
-	if (ret == 0) {
-		offset = (addr - s->pch_pic_base) & 7;
-		data = data >> (offset * 8);
-		memcpy(val, &data, len);
-	}
+	offset = (addr - s->pch_pic_base) & 7;
+	data = data >> (offset * 8);
+	memcpy(val, &data, len);
 
-	return ret;
+	return 0;
 }
 
 static int kvm_pch_pic_read(struct kvm_vcpu *vcpu,
 			struct kvm_io_device *dev,
 			gpa_t addr, int len, void *val)
 {
-	int ret;
+	int ret = 0;
 	struct loongarch_pch_pic *s = vcpu->kvm->arch.pch_pic;
 
 	if (!s) {
 		kvm_err("%s: pch pic irqchip not valid!\n", __func__);
-		return -EINVAL;
+		return ret;
 	}
 
 	if (addr & (len - 1)) {
 		kvm_err("%s: pch pic not aligned addr %llx len %d\n", __func__, addr, len);
-		return -EINVAL;
+		return ret;
 	}
 
 	/* statistics of pch pic reading */
@@ -161,7 +159,7 @@ static int kvm_pch_pic_read(struct kvm_vcpu *vcpu,
 static int loongarch_pch_pic_write(struct loongarch_pch_pic *s, gpa_t addr,
 					int len, const void *val)
 {
-	int ret = 0, offset;
+	int offset;
 	u64 old, data, mask;
 	void *ptemp;
 
@@ -226,29 +224,28 @@ static int loongarch_pch_pic_write(struct loongarch_pch_pic *s, gpa_t addr,
 	case PCH_PIC_ROUTE_ENTRY_START ... PCH_PIC_ROUTE_ENTRY_END:
 		break;
 	default:
-		ret = -EINVAL;
 		break;
 	}
 	spin_unlock(&s->lock);
 
-	return ret;
+	return 0;
 }
 
 static int kvm_pch_pic_write(struct kvm_vcpu *vcpu,
 			struct kvm_io_device *dev,
 			gpa_t addr, int len, const void *val)
 {
-	int ret;
+	int ret = 0;
 	struct loongarch_pch_pic *s = vcpu->kvm->arch.pch_pic;
 
 	if (!s) {
 		kvm_err("%s: pch pic irqchip not valid!\n", __func__);
-		return -EINVAL;
+		return ret;
 	}
 
 	if (addr & (len - 1)) {
 		kvm_err("%s: pch pic not aligned addr %llx len %d\n", __func__, addr, len);
-		return -EINVAL;
+		return ret;
 	}
 
 	/* statistics of pch pic writing */

base-commit: 4d310797262f0ddf129e76c2aad2b950adaf1fda
-- 
2.39.3


