Return-Path: <kvm+bounces-69053-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AG9NOaivdWm2HgEAu9opvQ
	(envelope-from <kvm+bounces-69053-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 25 Jan 2026 06:52:40 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 724737FD8E
	for <lists+kvm@lfdr.de>; Sun, 25 Jan 2026 06:52:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 582C63003810
	for <lists+kvm@lfdr.de>; Sun, 25 Jan 2026 05:52:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2F1C3112DD;
	Sun, 25 Jan 2026 05:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=aosc.io header.i=@aosc.io header.b="BUZHRdST"
X-Original-To: kvm@vger.kernel.org
Received: from relay-us1.mymailcheap.com (relay-us1.mymailcheap.com [51.81.35.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29FD2311960;
	Sun, 25 Jan 2026 05:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.81.35.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769320355; cv=none; b=RBctnoGXXyYWbEj8ekdo86PNqta6K2NJcGm/IFAa5qjXu0wnYoDaPCu8L2mvgeGABg4hHID1KdfiWTJ48sjCRn+wwQFytMPQpEdPmKEyIzpuJWygWnWTZj45QR09RmD1FeHJUEKfWQ1VtdS/rqrQd1Dc+WH0Ii8piKat/k0Htu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769320355; c=relaxed/simple;
	bh=Vm3XpbxQjg8eNNf05oSuTwoCh2D+UTbeYUaTvqCtz/0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Cp5ENtpBrL5N2GUakXqPKL+Py9IBNn+1BZjiXgZBX+83mPAkooaB8x8vqiC4L/LQIQapR6zokgPgzaO0KMYK+Qd1hb8XbJEujWYan2xvS5JIHXxZ3rGiU1WMLPV9kZqS4iciSkta6NUL6yA1ff0EVBHJb7t3jmMs3iLYklkNOvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aosc.io; spf=pass smtp.mailfrom=aosc.io; dkim=pass (1024-bit key) header.d=aosc.io header.i=@aosc.io header.b=BUZHRdST; arc=none smtp.client-ip=51.81.35.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aosc.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aosc.io
Received: from relay5.mymailcheap.com (relay5.mymailcheap.com [159.100.241.64])
	by relay-us1.mymailcheap.com (Postfix) with ESMTPS id 0DF9D2021B;
	Sun, 25 Jan 2026 05:44:09 +0000 (UTC)
Received: from relay4.mymailcheap.com (relay4.mymailcheap.com [137.74.80.156])
	by relay5.mymailcheap.com (Postfix) with ESMTPS id 2414720233;
	Sun, 25 Jan 2026 05:44:00 +0000 (UTC)
Received: from nf2.mymailcheap.com (nf2.mymailcheap.com [54.39.180.165])
	by relay4.mymailcheap.com (Postfix) with ESMTPS id 2614F2073A;
	Sun, 25 Jan 2026 05:43:51 +0000 (UTC)
Received: from mail20.mymailcheap.com (mail20.mymailcheap.com [51.83.111.147])
	by nf2.mymailcheap.com (Postfix) with ESMTPSA id 1CBC540073;
	Sun, 25 Jan 2026 05:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=aosc.io; s=default;
	t=1769319828; bh=Vm3XpbxQjg8eNNf05oSuTwoCh2D+UTbeYUaTvqCtz/0=;
	h=From:To:Cc:Subject:Date:From;
	b=BUZHRdSTk9aVp5GdKTYJNz5juygpyljFqCUvnAZAnFzJl/VmPjln88e3Nlw+N+FnC
	 kvrU1actQ4DJsx9Ea7YHCWSLtLS0cVvdvcDNkTfJrLAXbL0J6EzcJQkOdyFyYPdESd
	 NmnufOu/yHhemlfXPlOC9k5lh7/Iwqei8snTjCJg=
Received: from liushuyu-p15 (unknown [117.151.124.108])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail20.mymailcheap.com (Postfix) with ESMTPSA id BDBE24097F;
	Sun, 25 Jan 2026 05:43:35 +0000 (UTC)
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
	Miguel Ojeda <ojeda@kernel.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	kvm@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	rust-for-linux@vger.kernel.org
Subject: [PATCH 1/1] KVM: Add KVM_GET_REG_LIST ioctl for LoongArch
Date: Sun, 25 Jan 2026 13:43:22 +0800
Message-ID: <20260125054322.1237687-1-liushuyu@aosc.io>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[aosc.io:s=default];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[28];
	TAGGED_FROM(0.00)[bounces-69053-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[aosc.io,redhat.com,lwn.net,loongson.cn,kernel.org,dabbelt.com,eecs.berkeley.edu,ghiti.fr,gmail.com,garyguo.net,protonmail.com,google.com,umich.edu,vger.kernel.org,lists.linux.dev,lists.infradead.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[aosc.io];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[liushuyu@aosc.io,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[aosc.io:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.970];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: 724737FD8E
X-Rspamd-Action: no action

This ioctl can be used by userspace applications to determine which
(special) registers are get/set-able.

This can be very useful for cross-platform VMMs so that they do not have
to hardcode register indices for each supported architectures.

Signed-off-by: Zixing Liu <liushuyu@aosc.io>
---

For example, this ioctl could be used by rust-vmm/rust-kvm or maybe
VirtualBox-kvm in the future.

 Documentation/virt/kvm/api.rst |  2 +-
 arch/loongarch/kvm/vcpu.c      | 69 ++++++++++++++++++++++++++++++++++
 2 files changed, 70 insertions(+), 1 deletion(-)

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
index 656b954c1134..b884eb9c76aa 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -1186,6 +1186,57 @@ static int kvm_loongarch_vcpu_set_attr(struct kvm_vcpu *vcpu,
 	return ret;
 }
 
+static unsigned long kvm_loongarch_num_lbt_regs(void)
+{
+	/* +1 for the LBT_FTOP flag (inside arch.fpu) */
+	return sizeof(struct loongarch_lbt) / sizeof(unsigned long) + 1;
+}
+
+static unsigned long kvm_loongarch_num_regs(struct kvm_vcpu *vcpu)
+{
+	/* +1 for the KVM_REG_LOONGARCH_COUNTER register */
+	unsigned long res = CSR_MAX_NUMS + KVM_MAX_CPUCFG_REGS + 1;
+
+	if (kvm_guest_has_lbt(&vcpu->arch))
+		res += kvm_loongarch_num_lbt_regs();
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
+	for (i = 0; i < CSR_MAX_NUMS; i++) {
+		reg = KVM_IOC_CSRID(i);
+		if (put_user(reg, uindices++))
+			return -EFAULT;
+	}
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
+	for (i = 1; i <= kvm_loongarch_num_lbt_regs(); i++) {
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
@@ -1251,6 +1302,24 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
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


