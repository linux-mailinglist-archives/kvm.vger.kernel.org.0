Return-Path: <kvm+bounces-72003-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wHI1AV5YoGkNigQAu9opvQ
	(envelope-from <kvm+bounces-72003-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 15:27:42 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 70FAA1A787F
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 15:27:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4977D308DCD1
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 14:21:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DF113B95E5;
	Thu, 26 Feb 2026 14:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=cispa.de header.i=@cispa.de header.b="Tg5qcR4Q"
X-Original-To: kvm@vger.kernel.org
Received: from mx-2023-1.gwdg.de (mx-2023-1.gwdg.de [134.76.10.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AC82374174;
	Thu, 26 Feb 2026 14:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=134.76.10.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772115630; cv=none; b=jN2+CTt+qlDz83TGV3VC7JrJNV+bqkZ34gfPC0XR+nCavCMnM4cpagdnFE3MK2YCkdo/tRUmAz+LvkAt+4QO7IQ7IaphI/1Rv4cOqn6oidlaQpwzIFhtBOqbQTf6kP90zwC53npKHdJGvvCOVVpsp301sgCjh3QZE9Hzw7y0XNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772115630; c=relaxed/simple;
	bh=pjzrvKEuoSjY816OWcjYa5SX1DBMtRpisKeOqvc4J74=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=oK7s16Qu0883t3fOYU9EhOBkHLQHNBgqOv9/IOXLvBNQEsp3Ze4yDeIEm9CA229GAW4R0zsLN0lxwsVkmKRnu268ZOYtP8pCM4F0RPvHuiaMvhUbDSRgtijuYkma8XrD6o70XUxOsK8yIhYMERuixisOiCxc6Su2KiHC00oFOZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cispa.de; spf=pass smtp.mailfrom=cispa.de; dkim=pass (2048-bit key) header.d=cispa.de header.i=@cispa.de header.b=Tg5qcR4Q; arc=none smtp.client-ip=134.76.10.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cispa.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cispa.de
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cispa.de;
	s=2023-rsa; h=CC:To:In-Reply-To:References:Message-ID:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From:Sender:
	Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender
	:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=ZFcl30SuXm+JwQ5EbT5XB2vzMzMRZ5Ig39tXZ+wAMMU=; b=Tg5qcR4Q3rz50AyY0MXi6UFXA2
	95a3R//Uyh6GL/HtfEy57b5I9SYP09nQTFnCvHXS4XD9y9XMaGArAsj8pkZ8rug4tq/foH/UexPj7
	FNQK3GnWkECgm+YLBDjW8dKZih203aRH/Rs0H0CiubkBTsRp9i0p92pQ/XCuUhJiD8DOkDN7mc6oX
	Tb+V7G+xPdBy3we8GQgG5UFpE7ZwGdv9e7RTXHpGLm/r4+Lg5xma0eq+3ZYrG0deauO3VdysDEfGW
	zibiiAbTqpcHYyeoAcj+gytnA7MD1AgcnUFybDPm5Dws3TsFANQLRKi0eFX7OebNzkvLxmPnCAPhy
	wrvwN2eA==;
Received: from mailer.gwdg.de ([134.76.10.26]:36710)
	by mailer.gwdg.de with esmtp (GWDG Mailer)
	(envelope-from <lukas.gerlach@cispa.de>)
	id 1vvcD6-006EFr-08;
	Thu, 26 Feb 2026 15:19:29 +0100
Received: from mbx19-sub-05.um.gwdg.de ([10.108.142.70] helo=email.gwdg.de)
	by mailer.gwdg.de with esmtps (TLS1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
	(GWDG Mailer)
	(envelope-from <lukas.gerlach@cispa.de>)
	id 1vvcD6-0009ur-1r;
	Thu, 26 Feb 2026 15:19:24 +0100
Received: from
 1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.ip6.arpa
 (10.250.9.200) by MBX19-SUB-05.um.gwdg.de (10.108.142.70) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.37; Thu, 26 Feb 2026 15:19:23 +0100
From: Lukas Gerlach <lukas.gerlach@cispa.de>
Date: Thu, 26 Feb 2026 15:18:58 +0100
Subject: [PATCH 1/4] KVM: riscv: Fix Spectre-v1 in ONE_REG register access
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260226-kvm-riscv-spectre-v1-v1-1-5f930ea16691@cispa.de>
References: <20260226-kvm-riscv-spectre-v1-v1-0-5f930ea16691@cispa.de>
In-Reply-To: <20260226-kvm-riscv-spectre-v1-v1-0-5f930ea16691@cispa.de>
To: Anup Patel <anup@brainfault.org>, Atish Patra <atish.patra@linux.dev>,
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert
 Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, Andrew Jones
	<ajones@ventanamicro.com>
CC: <kvm@vger.kernel.org>, <kvm-riscv@lists.infradead.org>,
	<linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>, Daniel
 Weber <daniel.weber@cispa.de>, Michael Schwarz <michael.schwarz@cispa.de>,
	Marton Bognar <marton.bognar@kuleuven.be>, Jo Van Bulck
	<jo.vanbulck@kuleuven.be>, Lukas Gerlach <lukas.gerlach@cispa.de>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=4768;
 i=lukas.gerlach@cispa.de; h=from:subject:message-id;
 bh=pjzrvKEuoSjY816OWcjYa5SX1DBMtRpisKeOqvc4J74=;
 b=owGbwMvMwCGWoTIjqP/42kTG02pJDJkLwuK9un98mr7lp8Cs9AbmJ7zn3Ir/bZCK/9uoJ+18I
 qT8H8/PjlIWBjEOBlkxRZapgq8Z+/Y48CRlHj4HM4eVCWQIAxenAEykRp3hf2XH8l1vN/t/yUxb
 MNfgcIjij8XvQ26xaH0XDOjuMNxva8fIsHGihnWni7bCBZnSneGuq/m/CN5qS56zfpXfBOEbPp0
 dPAA=
X-Developer-Key: i=lukas.gerlach@cispa.de; a=openpgp;
 fpr=9511EB018EBC400C6269C3CE682498528FC7AD61
X-ClientProxiedBy: mbx19-sub-02.um.gwdg.de (10.108.142.55) To
 MBX19-SUB-05.um.gwdg.de (10.108.142.70)
X-Virus-Scanned: (clean) by clamav
X-Spam-Level: -
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_REJECT(1.00)[cispa.de:s=2023-rsa];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[cispa.de : SPF not aligned (relaxed),none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-72003-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[cispa.de:-];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[lukas.gerlach@cispa.de,kvm@vger.kernel.org];
	PRECEDENCE_BULK(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[6];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.997];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,cispa.de:mid,cispa.de:email]
X-Rspamd-Queue-Id: 70FAA1A787F
X-Rspamd-Action: no action

User-controlled register indices from the ONE_REG ioctl are used to
index into arrays of register values. Sanitize them with
array_index_nospec() to prevent speculative out-of-bounds access.

Signed-off-by: Lukas Gerlach <lukas.gerlach@cispa.de>
---
 arch/riscv/kvm/vcpu_onereg.c | 36 ++++++++++++++++++++++++++++--------
 1 file changed, 28 insertions(+), 8 deletions(-)

diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
index e7ab6cb00646..a4c8703a96a9 100644
--- a/arch/riscv/kvm/vcpu_onereg.c
+++ b/arch/riscv/kvm/vcpu_onereg.c
@@ -10,6 +10,7 @@
 #include <linux/bitops.h>
 #include <linux/errno.h>
 #include <linux/err.h>
+#include <linux/nospec.h>
 #include <linux/uaccess.h>
 #include <linux/kvm_host.h>
 #include <asm/cacheflush.h>
@@ -127,6 +128,7 @@ static int kvm_riscv_vcpu_isa_check_host(unsigned long kvm_ext, unsigned long *g
 	    kvm_ext >= ARRAY_SIZE(kvm_isa_ext_arr))
 		return -ENOENT;
 
+	kvm_ext = array_index_nospec(kvm_ext, ARRAY_SIZE(kvm_isa_ext_arr));
 	*guest_ext = kvm_isa_ext_arr[kvm_ext];
 	switch (*guest_ext) {
 	case RISCV_ISA_EXT_SMNPM:
@@ -443,13 +445,16 @@ static int kvm_riscv_vcpu_get_reg_core(struct kvm_vcpu *vcpu,
 	unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
 					    KVM_REG_SIZE_MASK |
 					    KVM_REG_RISCV_CORE);
+	unsigned long regs_max = sizeof(struct kvm_riscv_core) / sizeof(unsigned long);
 	unsigned long reg_val;
 
 	if (KVM_REG_SIZE(reg->id) != sizeof(unsigned long))
 		return -EINVAL;
-	if (reg_num >= sizeof(struct kvm_riscv_core) / sizeof(unsigned long))
+	if (reg_num >= regs_max)
 		return -ENOENT;
 
+	reg_num = array_index_nospec(reg_num, regs_max);
+
 	if (reg_num == KVM_REG_RISCV_CORE_REG(regs.pc))
 		reg_val = cntx->sepc;
 	else if (KVM_REG_RISCV_CORE_REG(regs.pc) < reg_num &&
@@ -476,13 +481,16 @@ static int kvm_riscv_vcpu_set_reg_core(struct kvm_vcpu *vcpu,
 	unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
 					    KVM_REG_SIZE_MASK |
 					    KVM_REG_RISCV_CORE);
+	unsigned long regs_max = sizeof(struct kvm_riscv_core) / sizeof(unsigned long);
 	unsigned long reg_val;
 
 	if (KVM_REG_SIZE(reg->id) != sizeof(unsigned long))
 		return -EINVAL;
-	if (reg_num >= sizeof(struct kvm_riscv_core) / sizeof(unsigned long))
+	if (reg_num >= regs_max)
 		return -ENOENT;
 
+	reg_num = array_index_nospec(reg_num, regs_max);
+
 	if (copy_from_user(&reg_val, uaddr, KVM_REG_SIZE(reg->id)))
 		return -EFAULT;
 
@@ -507,10 +515,13 @@ static int kvm_riscv_vcpu_general_get_csr(struct kvm_vcpu *vcpu,
 					  unsigned long *out_val)
 {
 	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
+	unsigned long regs_max = sizeof(struct kvm_riscv_csr) / sizeof(unsigned long);
 
-	if (reg_num >= sizeof(struct kvm_riscv_csr) / sizeof(unsigned long))
+	if (reg_num >= regs_max)
 		return -ENOENT;
 
+	reg_num = array_index_nospec(reg_num, regs_max);
+
 	if (reg_num == KVM_REG_RISCV_CSR_REG(sip)) {
 		kvm_riscv_vcpu_flush_interrupts(vcpu);
 		*out_val = (csr->hvip >> VSIP_TO_HVIP_SHIFT) & VSIP_VALID_MASK;
@@ -526,10 +537,13 @@ static int kvm_riscv_vcpu_general_set_csr(struct kvm_vcpu *vcpu,
 					  unsigned long reg_val)
 {
 	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
+	unsigned long regs_max = sizeof(struct kvm_riscv_csr) / sizeof(unsigned long);
 
-	if (reg_num >= sizeof(struct kvm_riscv_csr) / sizeof(unsigned long))
+	if (reg_num >= regs_max)
 		return -ENOENT;
 
+	reg_num = array_index_nospec(reg_num, regs_max);
+
 	if (reg_num == KVM_REG_RISCV_CSR_REG(sip)) {
 		reg_val &= VSIP_VALID_MASK;
 		reg_val <<= VSIP_TO_HVIP_SHIFT;
@@ -548,11 +562,14 @@ static inline int kvm_riscv_vcpu_smstateen_set_csr(struct kvm_vcpu *vcpu,
 						   unsigned long reg_val)
 {
 	struct kvm_vcpu_smstateen_csr *csr = &vcpu->arch.smstateen_csr;
+	unsigned long regs_max = sizeof(struct kvm_riscv_smstateen_csr) /
+		sizeof(unsigned long);
 
-	if (reg_num >= sizeof(struct kvm_riscv_smstateen_csr) /
-		sizeof(unsigned long))
+	if (reg_num >= regs_max)
 		return -EINVAL;
 
+	reg_num = array_index_nospec(reg_num, regs_max);
+
 	((unsigned long *)csr)[reg_num] = reg_val;
 	return 0;
 }
@@ -562,11 +579,14 @@ static int kvm_riscv_vcpu_smstateen_get_csr(struct kvm_vcpu *vcpu,
 					    unsigned long *out_val)
 {
 	struct kvm_vcpu_smstateen_csr *csr = &vcpu->arch.smstateen_csr;
+	unsigned long regs_max = sizeof(struct kvm_riscv_smstateen_csr) /
+		sizeof(unsigned long);
 
-	if (reg_num >= sizeof(struct kvm_riscv_smstateen_csr) /
-		sizeof(unsigned long))
+	if (reg_num >= regs_max)
 		return -EINVAL;
 
+	reg_num = array_index_nospec(reg_num, regs_max);
+
 	*out_val = ((unsigned long *)csr)[reg_num];
 	return 0;
 }

-- 
2.51.0


