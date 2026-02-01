Return-Path: <kvm+bounces-69784-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IKDMNmn/fmn5hwIAu9opvQ
	(envelope-from <kvm+bounces-69784-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 01 Feb 2026 08:23:21 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BE19C51ED
	for <lists+kvm@lfdr.de>; Sun, 01 Feb 2026 08:23:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9E220301BF5E
	for <lists+kvm@lfdr.de>; Sun,  1 Feb 2026 07:22:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B93E52E62DC;
	Sun,  1 Feb 2026 07:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=aosc.io header.i=@aosc.io header.b="iOhL+zKY"
X-Original-To: kvm@vger.kernel.org
Received: from relay5.mymailcheap.com (relay5.mymailcheap.com [159.100.241.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 692732253A0;
	Sun,  1 Feb 2026 07:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.100.241.64
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769930577; cv=none; b=B/n5dZq1NYqo7oqtg7dMatkQyP1FyjX+9Vaa/1eaUHnasKmbzZUr5j0aUyuCKOk1LoIyyAa0fpDvZ0322/RsX0Sh+EYL8voMHA2oyl+6VSYiuKzTWrSLEaKQCk6Zf4pNZcrO3ergqcj8bSIHKoVQTgXEdBaP8dfB7dkZEHnovj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769930577; c=relaxed/simple;
	bh=tsYztuBMmDw9dhEyvXm134zQnSNewOglMstDiOxHhEs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RGJ+OysOQr/DCo2b57osvwF7JFvuIvFZvz3KB5SdaZm7GtGuXgMsQF8moazzTINVXNUAR0EOzAN/BYEsPE+yfylcZnv3Yx062jWWYmIxou1pWMb5JOyXLETJMV5FIIOeVDdhaa1B1kBOE0q0VVoQhNEJrAKKo5tvNssuDselwgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aosc.io; spf=pass smtp.mailfrom=aosc.io; dkim=pass (1024-bit key) header.d=aosc.io header.i=@aosc.io header.b=iOhL+zKY; arc=none smtp.client-ip=159.100.241.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aosc.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aosc.io
Received: from relay1.mymailcheap.com (relay1.mymailcheap.com [144.217.248.100])
	by relay5.mymailcheap.com (Postfix) with ESMTPS id D68EA20229;
	Sun,  1 Feb 2026 07:22:46 +0000 (UTC)
Received: from nf1.mymailcheap.com (nf1.mymailcheap.com [51.75.14.91])
	by relay1.mymailcheap.com (Postfix) with ESMTPS id 97D883E904;
	Sun,  1 Feb 2026 07:22:38 +0000 (UTC)
Received: from mail20.mymailcheap.com (mail20.mymailcheap.com [51.83.111.147])
	by nf1.mymailcheap.com (Postfix) with ESMTPSA id 826E0400D5;
	Sun,  1 Feb 2026 07:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=aosc.io; s=default;
	t=1769930557; bh=tsYztuBMmDw9dhEyvXm134zQnSNewOglMstDiOxHhEs=;
	h=From:To:Cc:Subject:Date:From;
	b=iOhL+zKYkoaHk3q1iqoOy9vIybwQDY0uOe0dcyxM0fekb06r8/iElx7VHqGrQLrmW
	 Nq5KtnialzdQJDUTS7l4exM7Cfr1d7oc0NqtorLP9rC03FzHVPirO+E/uGdk6lON0I
	 AN60QrXkkS2p2R2XBlpim+5ZagooXqlnbQZigupg=
Received: from liushuyu-p15 (unknown [117.151.13.225])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail20.mymailcheap.com (Postfix) with ESMTPSA id B594B40563;
	Sun,  1 Feb 2026 07:22:28 +0000 (UTC)
From: Zixing Liu <liushuyu@aosc.io>
To: WANG Xuerui <kernel@xen0n.name>,
	Huacai Chen <chenhuacai@kernel.org>,
	Bibo Mao <maobibo@loongson.cn>
Cc: Kexy Biscuit <kexybiscuit@aosc.io>,
	Mingcong Bai <jeffbai@aosc.io>,
	Zixing Liu <liushuyu@aosc.io>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	kvm@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org
Subject: [PATCH v3] KVM: Add KVM_GET_REG_LIST ioctl for LoongArch
Date: Sun,  1 Feb 2026 15:21:23 +0800
Message-ID: <20260201072124.566587-1-liushuyu@aosc.io>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[aosc.io:s=default];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DMARC_NA(0.00)[aosc.io];
	RCVD_TLS_LAST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-69784-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[18];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[liushuyu@aosc.io,kvm@vger.kernel.org];
	NEURAL_HAM(-0.00)[-1.000];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	DKIM_TRACE(0.00)[aosc.io:+];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 7BE19C51ED
X-Rspamd-Action: no action

This ioctl can be used by the userspace applications to determine which
(special) registers are get/set-able in a meaningful way.

This can be very useful for cross-platform VMMs so that they do not have
to hardcode register indices for each supported architectures.

Signed-off-by: Zixing Liu <liushuyu@aosc.io>
---
 Documentation/virt/kvm/api.rst |  2 +-
 arch/loongarch/kvm/vcpu.c      | 81 ++++++++++++++++++++++++++++++++++
 2 files changed, 82 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 01a3abef8abb..f46dd8be282f 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -3603,7 +3603,7 @@ VCPU matching underlying host.
 ---------------------
 
 :Capability: basic
-:Architectures: arm64, mips, riscv, x86 (if KVM_CAP_ONE_REG)
+:Architectures: arm64, loongarch, mips, riscv, x86 (if KVM_CAP_ONE_REG)
 :Type: vcpu ioctl
 :Parameters: struct kvm_reg_list (in/out)
 :Returns: 0 on success; -1 on error
diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 656b954c1134..fb8001deadc9 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -14,6 +14,8 @@
 #define CREATE_TRACE_POINTS
 #include "trace.h"
 
+#define NUM_LBT_REGS 6
+
 const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	KVM_GENERIC_VCPU_STATS(),
 	STATS_DESC_COUNTER(VCPU, int_exits),
@@ -1186,6 +1188,67 @@ static int kvm_loongarch_vcpu_set_attr(struct kvm_vcpu *vcpu,
 	return ret;
 }
 
+static int kvm_loongarch_walk_csrs(struct kvm_vcpu *vcpu, u64 __user *uindices)
+{
+	unsigned int i, count;
+
+	for (i = 0, count = 0; i < CSR_MAX_NUMS; i++) {
+		if (!(get_gcsr_flag(i) & (SW_GCSR | HW_GCSR)))
+			continue;
+		const u64 reg = KVM_IOC_CSRID(i);
+		if (uindices && put_user(reg, uindices++))
+			return -EFAULT;
+		count++;
+	}
+
+	return count;
+}
+
+static unsigned long kvm_loongarch_num_regs(struct kvm_vcpu *vcpu)
+{
+	/* +1 for the KVM_REG_LOONGARCH_COUNTER register */
+	unsigned long res =
+		kvm_loongarch_walk_csrs(vcpu, NULL) + KVM_MAX_CPUCFG_REGS + 1;
+
+	if (kvm_guest_has_lbt(&vcpu->arch))
+		res += NUM_LBT_REGS;
+
+	return res;
+}
+
+static int kvm_loongarch_copy_reg_indices(struct kvm_vcpu *vcpu,
+					  u64 __user *uindices)
+{
+	u64 reg;
+	unsigned int i;
+
+	i = kvm_loongarch_walk_csrs(vcpu, uindices);
+	if (i < 0)
+		return i;
+	uindices += i;
+
+	for (i = 0; i < KVM_MAX_CPUCFG_REGS; i++) {
+		reg = KVM_IOC_CPUCFG(i);
+		if (put_user(reg, uindices++))
+			return -EFAULT;
+	}
+
+	reg = KVM_REG_LOONGARCH_COUNTER;
+	if (put_user(reg, uindices++))
+		return -EFAULT;
+
+	if (!kvm_guest_has_lbt(&vcpu->arch))
+		return 0;
+
+	for (i = 1; i <= NUM_LBT_REGS; i++) {
+		reg = (KVM_REG_LOONGARCH_LBT | KVM_REG_SIZE_U64 | i);
+		if (put_user(reg, uindices++))
+			return -EFAULT;
+	}
+
+	return 0;
+}
+
 long kvm_arch_vcpu_ioctl(struct file *filp,
 			 unsigned int ioctl, unsigned long arg)
 {
@@ -1251,6 +1314,24 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		r = kvm_loongarch_vcpu_set_attr(vcpu, &attr);
 		break;
 	}
+	case KVM_GET_REG_LIST: {
+		struct kvm_reg_list __user *user_list = argp;
+		struct kvm_reg_list reg_list;
+		unsigned n;
+
+		r = -EFAULT;
+		if (copy_from_user(&reg_list, user_list, sizeof(reg_list)))
+			break;
+		n = reg_list.n;
+		reg_list.n = kvm_loongarch_num_regs(vcpu);
+		if (copy_to_user(user_list, &reg_list, sizeof(reg_list)))
+			break;
+		r = -E2BIG;
+		if (n < reg_list.n)
+			break;
+		r = kvm_loongarch_copy_reg_indices(vcpu, user_list->reg);
+		break;
+	}
 	default:
 		r = -ENOIOCTLCMD;
 		break;
-- 
2.52.0


