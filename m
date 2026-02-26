Return-Path: <kvm+bounces-72002-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qOrgBIZYoGlPigQAu9opvQ
	(envelope-from <kvm+bounces-72002-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 15:28:22 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AE4A1A78AB
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 15:28:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 07501315AA8A
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 14:20:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1A3A3D523E;
	Thu, 26 Feb 2026 14:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=cispa.de header.i=@cispa.de header.b="g0biczdi"
X-Original-To: kvm@vger.kernel.org
Received: from mx-2023-1.gwdg.de (mx-2023-1.gwdg.de [134.76.10.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9944F3D412A;
	Thu, 26 Feb 2026 14:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=134.76.10.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772115607; cv=none; b=aZ9CQ3nmCK0mFu/AbWtadhltgOTG49R51hgDBLwuv6CZnoLt7X14wp5cVOtIELPm5j73zqbaiRnHpIAjVW9ifQEQryTyyDZvsJmluMI4G5NkdSxvVCbRno2wek+/Qu7/9edFl3r8RlksODjFLvi99WXZXnzNj3+Tj4yY5Odq8es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772115607; c=relaxed/simple;
	bh=QO6W13mYtTFxnI3cEgo5wylvGnvsvcChLTvNH02DBEI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=R7Jd1LZ8T1tLTwW0QD+xrENvRXRkPLktW4GQAnh4gf0I/ay1llMIHiyOx0KiW4YzJIWrnSq6TYPT/AgyKkqjp9IstrT4fjEGIYkolV2PFXW3CmuaLDx71YJapvhO3Wl245TkfmcxIrX1CBwZcB1amAGpE4W3GnWPf7NbZXkplXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cispa.de; spf=pass smtp.mailfrom=cispa.de; dkim=pass (2048-bit key) header.d=cispa.de header.i=@cispa.de header.b=g0biczdi; arc=none smtp.client-ip=134.76.10.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cispa.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cispa.de
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cispa.de;
	s=2023-rsa; h=CC:To:In-Reply-To:References:Message-ID:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From:Sender:
	Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender
	:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=y2EV8E69I5jJrpaeHXHly91RKfTm2Mt/UXnHLNf1qIo=; b=g0biczdiy3N2TWnxwivxJ+2VuE
	nlkN4XrKRP7q3LAV4Zfn4TLawUMxvEI/t+nHLBBnNEaxpE6YOMlThtTN//WJPZUr8srjTjIdLUrVY
	Vy1Oyk2v1hXXWdUiOQJXIZfqMiD6Gggjrj6pY0eO70pqsD0ZLmfpQjeM+K4WALV74Mcy6ZVf2gRxl
	dnEAn+nOQk6UvjtiypXNeVlmfKHTz7XgK8rUD+gKMhBP7Ts2ixJcLVDiJmJ+eIIu5xlt5IfQKWmz8
	PuAm9/Jca7A3VxX2hUrD1HDYCOnL1xyH75N7j766hst81T+HS9kdJ/CUYz59MsEX0i59En1v38zH2
	79jE7vAw==;
Received: from mailer.gwdg.de ([134.76.10.26]:41130)
	by mailer.gwdg.de with esmtp (GWDG Mailer)
	(envelope-from <lukas.gerlach@cispa.de>)
	id 1vvcDd-006EHN-36;
	Thu, 26 Feb 2026 15:19:58 +0100
Received: from mbx19-sub-05.um.gwdg.de ([10.108.142.70] helo=email.gwdg.de)
	by mailer.gwdg.de with esmtps (TLS1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
	(GWDG Mailer)
	(envelope-from <lukas.gerlach@cispa.de>)
	id 1vvcDe-000AAN-1W;
	Thu, 26 Feb 2026 15:19:58 +0100
Received: from
 1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.ip6.arpa
 (10.250.9.200) by MBX19-SUB-05.um.gwdg.de (10.108.142.70) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.37; Thu, 26 Feb 2026 15:19:30 +0100
From: Lukas Gerlach <lukas.gerlach@cispa.de>
Date: Thu, 26 Feb 2026 15:19:00 +0100
Subject: [PATCH 3/4] KVM: riscv: Fix Spectre-v1 in floating-point register
 access
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260226-kvm-riscv-spectre-v1-v1-3-5f930ea16691@cispa.de>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2543;
 i=lukas.gerlach@cispa.de; h=from:subject:message-id;
 bh=QO6W13mYtTFxnI3cEgo5wylvGnvsvcChLTvNH02DBEI=;
 b=owGbwMvMwCGWoTIjqP/42kTG02pJDJkLwuJTLbtiFk9ImH6Me/FHrZCV37W+bm/6n+idPUty7
 qY2iz1OHaUsDGIcDLJiiixTBV8z9u1x4EnKPHwOZg4rE8gQBi5OAZjIsX5Ghk9fC55YbCkLCTDq
 ulca9mvdym3sKnxsTpo8W2tVXzXVqjH897JfuWPL577733quJYuw9Gbq77B5brVz6yKxk7kufO8
 TmQA=
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
	TAGGED_FROM(0.00)[bounces-72002-lists,kvm=lfdr.de];
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
	NEURAL_HAM(-0.00)[-0.998];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,cispa.de:mid,cispa.de:email]
X-Rspamd-Queue-Id: 8AE4A1A78AB
X-Rspamd-Action: no action

User-controlled indices are used to index into floating-point registers.
Sanitize them with array_index_nospec() to prevent speculative
out-of-bounds access.

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


