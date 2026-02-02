Return-Path: <kvm+bounces-69814-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OFNqN3tggGlj7AIAu9opvQ
	(envelope-from <kvm+bounces-69814-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 09:29:47 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CCE1C9B06
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 09:29:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 242C23030B18
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 08:26:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C59842AD20;
	Mon,  2 Feb 2026 08:26:46 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C452355807;
	Mon,  2 Feb 2026 08:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770020802; cv=none; b=pkVatpqYNvbCp/cU1u3jL09OUBwdPVsqBS+ZQqM1ban4La8BOdLhndoONwMg9QnPD7rOocI7QOjmN8JISbeBwgE2kT/5igG+qQ2iFO8phWA18HIsJPGEzCWErqi4IWZskq8Hz1xlompCdXg9cizZdpcc1WEb6ptaZPHvbkxsL9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770020802; c=relaxed/simple;
	bh=6fmNYn0NTsklDikjGnzkTnyM7QmuqmVVrN18Q8dAXKI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Y2gEqzggeAStSchRlKBqff66M3uijaAjaJ/jxb/Mmxjfv3ZAdXWgfzySBeYc/5r6C90JMfV0YqOeYDu99CbkRl+/BeC0UFlR+FBImXh3JW+Wx0+ZKby27XIv4WlWR0IXHqV7Iz+XerN53l77TUQ5IDyA1kdHK5G1JNCMnNtK+Lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8DxHvC6X4BpdecOAA--.49488S3;
	Mon, 02 Feb 2026 16:26:34 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJCxPMK5X4BpvRI+AA--.48024S2;
	Mon, 02 Feb 2026 16:26:33 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Tianrui Zhao <zhaotianrui@loongson.cn>
Cc: loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH v3] LoongArch: KVM: Add more CPUCFG mask bit
Date: Mon,  2 Feb 2026 16:26:31 +0800
Message-Id: <20260202082631.1678388-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJCxPMK5X4BpvRI+AA--.48024S2
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
	TAGGED_FROM(0.00)[bounces-69814-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	PRECEDENCE_BULK(0.00)[];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NEQ_ENVFROM(0.00)[maobibo@loongson.cn,kvm@vger.kernel.org];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[loongson.cn:mid,loongson.cn:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 4CCE1C9B06
X-Rspamd-Action: no action

With LA664 CPU there are more features supported which are indicated
in CPUCFG2 bit24:30 and CPUCFG3 bit17 and bit 23. KVM hypervisor
cannot enable or disable these features and there is no KVM exception
when instructions of these features are executed in guest mode.

Here add more CPUCFG mask support with LA664 CPU type.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
v2 ... v3:
  1. Add CPUCFG3_ALDORDER_STA and CPUCFG3_ASTORDER_STA in cpucfg3.
  2. Disable bit CPUCFG3_SFB since VM does not support SFB controling.
  3. Add checking with max supported page directory level and max virtual
     address width.
 
v1 ... v2:
  1. Rebase on the latest version since some common CPUCFG bit macro
     definitions are merged.
  2. Modifiy the comments explaining why it comes from feature detect
     of host CPU.
---
 arch/loongarch/kvm/vcpu.c | 32 +++++++++++++++++++++++++++++---
 1 file changed, 29 insertions(+), 3 deletions(-)

diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 656b954c1134..7bea5e162a4d 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -652,6 +652,8 @@ static int _kvm_setcsr(struct kvm_vcpu *vcpu, unsigned int id, u64 val)
 
 static int _kvm_get_cpucfg_mask(int id, u64 *v)
 {
+	unsigned int config;
+
 	if (id < 0 || id >= KVM_MAX_CPUCFG_REGS)
 		return -EINVAL;
 
@@ -684,9 +686,26 @@ static int _kvm_get_cpucfg_mask(int id, u64 *v)
 		if (cpu_has_ptw)
 			*v |= CPUCFG2_PTW;
 
+		/*
+		 * The capability indication of some features are the same
+		 * between host CPU and guest vCPU, and there is no special
+		 * feature detect method with vCPU. Also KVM hypervisor can
+		 * not enable or disable these features.
+		 *
+		 * Here use host CPU detected features for vCPU
+		 */
+		config = read_cpucfg(LOONGARCH_CPUCFG2);
+		*v |= config & (CPUCFG2_FRECIPE | CPUCFG2_DIV32 | CPUCFG2_LAM_BH);
+		*v |= config & (CPUCFG2_LAMCAS | CPUCFG2_LLACQ_SCREL | CPUCFG2_SCQ);
 		return 0;
 	case LOONGARCH_CPUCFG3:
-		*v = GENMASK(16, 0);
+		/*
+		 * VM does not support memory order and SFB setting
+		 * only support memory order display
+		 */
+		*v = read_cpucfg(LOONGARCH_CPUCFG3) & GENMASK(23, 0);
+		*v &= ~(CPUCFG3_ALDORDER_CAP | CPUCFG3_ASTORDER_CAP | CPUCFG3_SLDORDER_CAP);
+		*v &= ~CPUCFG3_SFB;
 		return 0;
 	case LOONGARCH_CPUCFG4:
 	case LOONGARCH_CPUCFG5:
@@ -716,7 +735,7 @@ static int _kvm_get_cpucfg_mask(int id, u64 *v)
 
 static int kvm_check_cpucfg(int id, u64 val)
 {
-	int ret;
+	int ret, host;
 	u64 mask = 0;
 
 	ret = _kvm_get_cpucfg_mask(id, &mask);
@@ -746,9 +765,16 @@ static int kvm_check_cpucfg(int id, u64 val)
 			/* LASX architecturally implies LSX and FP but val does not satisfy that */
 			return -EINVAL;
 		return 0;
+	case LOONGARCH_CPUCFG3:
+		host = read_cpucfg(LOONGARCH_CPUCFG3);
+		if ((val & CPUCFG3_SPW_LVL) > (host & CPUCFG3_SPW_LVL))
+			return -EINVAL;
+		if ((val & CPUCFG3_RVAMAX) > (host & CPUCFG3_RVAMAX))
+			return -EINVAL;
+		return 0;
 	case LOONGARCH_CPUCFG6:
 		if (val & CPUCFG6_PMP) {
-			u32 host = read_cpucfg(LOONGARCH_CPUCFG6);
+			host = read_cpucfg(LOONGARCH_CPUCFG6);
 			if ((val & CPUCFG6_PMBITS) != (host & CPUCFG6_PMBITS))
 				return -EINVAL;
 			if ((val & CPUCFG6_PMNUM) > (host & CPUCFG6_PMNUM))

base-commit: 18f7fcd5e69a04df57b563360b88be72471d6b62
-- 
2.39.3


