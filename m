Return-Path: <kvm+bounces-72533-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UK7EFGvupmlKaQAAu9opvQ
	(envelope-from <kvm+bounces-72533-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 15:21:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 70E181F159E
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 15:21:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 41A443014A21
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 14:20:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1E4E42F54D;
	Tue,  3 Mar 2026 14:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=cispa.de header.i=@cispa.de header.b="RnSE4LFc"
X-Original-To: kvm@vger.kernel.org
Received: from mx-2023-1.gwdg.de (mx-2023-1.gwdg.de [134.76.10.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 976113E5565;
	Tue,  3 Mar 2026 14:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=134.76.10.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772547598; cv=none; b=Rqdj33o71+Slq9jed6m5NMFMFoYdPYB8FZjWHKE9b65BajbN/I35OILWJXktSPupEnVHJp7JREMEOPONLSgiHeuKPJM46T5OqjyNYsh9cKrL0CHAnAlBw2CsUtXIGTROmOdPAdOrqPBN9rLq6E76wbuTD9sFlJPAgBnvxfuhIiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772547598; c=relaxed/simple;
	bh=R92BAr2kqx5spiyvOG2j2jtmK0XMGCxxNze/Hhxk7C0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=qRb4PpLICItiwKG3Ga9I/4/CfNbGD5AahuvkzzzVQGh03+jIXNmDBcKNG+R8fUKKZh5xO+CkGN9ByBT339qU1zOXh0t26mziMSSR0eiGvFldKQF5U5v2VK0U3Wc7RkWkh8E5GIfbHbPpjbUIh6doSL+Kn0aH8U+Tw9wMjjtMesQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cispa.de; spf=pass smtp.mailfrom=cispa.de; dkim=pass (2048-bit key) header.d=cispa.de header.i=@cispa.de header.b=RnSE4LFc; arc=none smtp.client-ip=134.76.10.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cispa.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cispa.de
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cispa.de;
	s=2023-rsa; h=CC:To:In-Reply-To:References:Message-ID:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From:Sender:
	Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender
	:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=evQ738m5JttBj+gPIuFYJobVsWsJ7zXSUvfhaD0owBA=; b=RnSE4LFcCzWkOaKFYLcMgodKeL
	Ny0/rCrW5yuTNCZmfkPlfhGNn6O3Oq53za1rYD+fyUXyFVgGcg7LjObOmkBZwXfQJI5bMTGKJG+IL
	mUjZ/kJdFu19rdoPI0RJZApaeuGy0bMX6mJUV2LJaJuPl02DPqI6uf44WHU1yMwFp7jYL7wfeDqFc
	mX3TX+1QS99jcpPjpNXDymDNzazISQ9Ap1iM51O8H40YOwTadTRIHRiCfGU0WUswqi2zn4eEXlJXK
	wx1eALBvdrwpwoCENCoj5jPKtzT83fXTm4EP1drUOxrZRjm+6ItM+5oXuO6rLAux9mrf63tjXhWj0
	Xsy/BeBA==;
Received: from mailer.gwdg.de ([134.76.10.26]:33561)
	by mailer.gwdg.de with esmtp (GWDG Mailer)
	(envelope-from <lukas.gerlach@cispa.de>)
	id 1vxQb9-00850W-0W;
	Tue, 03 Mar 2026 15:19:43 +0100
Received: from mbx19-sub-05.um.gwdg.de ([10.108.142.70] helo=email.gwdg.de)
	by mailer.gwdg.de with esmtps (TLS1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
	(GWDG Mailer)
	(envelope-from <lukas.gerlach@cispa.de>)
	id 1vxQb9-0006kf-2q;
	Tue, 03 Mar 2026 15:19:43 +0100
Received: from lukass-mbp-7.lan (10.250.9.200) by MBX19-SUB-05.um.gwdg.de
 (10.108.142.70) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.37; Tue, 3 Mar
 2026 15:19:43 +0100
From: Lukas Gerlach <lukas.gerlach@cispa.de>
Date: Tue, 3 Mar 2026 15:19:43 +0100
Subject: [PATCH v2 3/4] KVM: riscv: Fix Spectre-v1 in floating-point
 register access
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-ID: <20260303-kvm-riscv-spectre-v1-v2-3-192caab8e0dc@cispa.de>
References: <20260303-kvm-riscv-spectre-v1-v2-0-192caab8e0dc@cispa.de>
In-Reply-To: <20260303-kvm-riscv-spectre-v1-v2-0-192caab8e0dc@cispa.de>
To: Anup Patel <anup@brainfault.org>, Atish Patra <atish.patra@linux.dev>,
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert
 Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, Andrew Jones
	<ajones@ventanamicro.com>
CC: =?utf-8?q?Radim_Kr=C4=8Dm=C3=A1=C5=99?= <radim.krcmar@oss.qualcomm.com>,
	<kvm@vger.kernel.org>, <kvm-riscv@lists.infradead.org>,
	<linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>, Daniel
 Weber <daniel.weber@cispa.de>, Michael Schwarz <michael.schwarz@cispa.de>,
	Marton Bognar <marton.bognar@kuleuven.be>, Jo Van Bulck
	<jo.vanbulck@kuleuven.be>, Lukas Gerlach <lukas.gerlach@cispa.de>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2605;
 i=lukas.gerlach@cispa.de; h=from:subject:message-id;
 bh=R92BAr2kqx5spiyvOG2j2jtmK0XMGCxxNze/Hhxk7C0=;
 b=owGbwMvMwCGWoTIjqP/42kTG02pJDJnL3v71qeE88bRvtcBki9R24ekFUhNfzZf4L3vS+7Zs2
 v6AJZdud5SyMIhxMMiKKbJMFXzN2LfHgScp8/A5mDmsTCBDGLg4BWAibCcY/or0qoSYX/jy3HHH
 Rb0gc+aNj6RdD3z0WJI17dwvo7I/J14z/NNg+bFIXtg6PfBLxKKXH7zmfVz98tG6misylzYXPpQ
 7tocDAA==
X-Developer-Key: i=lukas.gerlach@cispa.de; a=openpgp;
 fpr=9511EB018EBC400C6269C3CE682498528FC7AD61
X-ClientProxiedBy: MBX19-SUB-05.um.gwdg.de (10.108.142.70) To
 MBX19-SUB-05.um.gwdg.de (10.108.142.70)
X-Virus-Scanned: (clean) by clamav
X-Spam-Level: -
X-Rspamd-Queue-Id: 70E181F159E
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_REJECT(1.00)[cispa.de:s=2023-rsa];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[cispa.de : SPF not aligned (relaxed),none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	MIME_TRACE(0.00)[0:+];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[lukas.gerlach@cispa.de,kvm@vger.kernel.org];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.979];
	RCVD_COUNT_FIVE(0.00)[6];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72533-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[cispa.de:-]
X-Rspamd-Action: no action

User-controlled indices are used to index into floating-point registers.
Sanitize them with array_index_nospec() to prevent speculative
out-of-bounds access.

Reviewed-by: Radim Krčmář <radim.krcmar@oss.qualcomm.com>
Signed-off-by: Lukas Gerlach <lukas.gerlach@cispa.de>
---
 arch/riscv/kvm/vcpu_fp.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/arch/riscv/kvm/vcpu_fp.c b/arch/riscv/kvm/vcpu_fp.c
index 030904d82b58..bd5a9e7e7165 100644
--- a/arch/riscv/kvm/vcpu_fp.c
+++ b/arch/riscv/kvm/vcpu_fp.c
@@ -10,6 +10,7 @@
 #include <linux/errno.h>
 #include <linux/err.h>
 #include <linux/kvm_host.h>
+#include <linux/nospec.h>
 #include <linux/uaccess.h>
 #include <asm/cpufeature.h>
 
@@ -93,9 +94,11 @@ int kvm_riscv_vcpu_get_reg_fp(struct kvm_vcpu *vcpu,
 		if (reg_num == KVM_REG_RISCV_FP_F_REG(fcsr))
 			reg_val = &cntx->fp.f.fcsr;
 		else if ((KVM_REG_RISCV_FP_F_REG(f[0]) <= reg_num) &&
-			  reg_num <= KVM_REG_RISCV_FP_F_REG(f[31]))
+			  reg_num <= KVM_REG_RISCV_FP_F_REG(f[31])) {
+			reg_num = array_index_nospec(reg_num,
+					ARRAY_SIZE(cntx->fp.f.f));
 			reg_val = &cntx->fp.f.f[reg_num];
-		else
+		} else
 			return -ENOENT;
 	} else if ((rtype == KVM_REG_RISCV_FP_D) &&
 		   riscv_isa_extension_available(vcpu->arch.isa, d)) {
@@ -107,6 +110,8 @@ int kvm_riscv_vcpu_get_reg_fp(struct kvm_vcpu *vcpu,
 			   reg_num <= KVM_REG_RISCV_FP_D_REG(f[31])) {
 			if (KVM_REG_SIZE(reg->id) != sizeof(u64))
 				return -EINVAL;
+			reg_num = array_index_nospec(reg_num,
+					ARRAY_SIZE(cntx->fp.d.f));
 			reg_val = &cntx->fp.d.f[reg_num];
 		} else
 			return -ENOENT;
@@ -138,9 +143,11 @@ int kvm_riscv_vcpu_set_reg_fp(struct kvm_vcpu *vcpu,
 		if (reg_num == KVM_REG_RISCV_FP_F_REG(fcsr))
 			reg_val = &cntx->fp.f.fcsr;
 		else if ((KVM_REG_RISCV_FP_F_REG(f[0]) <= reg_num) &&
-			  reg_num <= KVM_REG_RISCV_FP_F_REG(f[31]))
+			  reg_num <= KVM_REG_RISCV_FP_F_REG(f[31])) {
+			reg_num = array_index_nospec(reg_num,
+					ARRAY_SIZE(cntx->fp.f.f));
 			reg_val = &cntx->fp.f.f[reg_num];
-		else
+		} else
 			return -ENOENT;
 	} else if ((rtype == KVM_REG_RISCV_FP_D) &&
 		   riscv_isa_extension_available(vcpu->arch.isa, d)) {
@@ -152,6 +159,8 @@ int kvm_riscv_vcpu_set_reg_fp(struct kvm_vcpu *vcpu,
 			   reg_num <= KVM_REG_RISCV_FP_D_REG(f[31])) {
 			if (KVM_REG_SIZE(reg->id) != sizeof(u64))
 				return -EINVAL;
+			reg_num = array_index_nospec(reg_num,
+					ARRAY_SIZE(cntx->fp.d.f));
 			reg_val = &cntx->fp.d.f[reg_num];
 		} else
 			return -ENOENT;

-- 
2.51.0


