Return-Path: <kvm+bounces-73001-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wIqgLR+bqmmbUQEAu9opvQ
	(envelope-from <kvm+bounces-73001-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 10:15:11 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A36521DB61
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 10:15:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 38F573023ABE
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 09:14:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48F9233B6D2;
	Fri,  6 Mar 2026 09:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="KMShgcHI"
X-Original-To: kvm@vger.kernel.org
Received: from out162-62-58-211.mail.qq.com (out162-62-58-211.mail.qq.com [162.62.58.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 217A433D509;
	Fri,  6 Mar 2026 09:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.58.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772788461; cv=none; b=F3w2Ill8vRZLzzm+5Gr5Zd1XFaEiUmZU46riq3Z65+exOLCbAwS3T0HHXWoy7SpaT03YEPeyZ6+jOTOvMAEmzW4ecDqpIdfsi07WjS/UUWRg5qv3hzsSy8Mb6b+kXGWvdTw50K+6N5GHmIS+TCPiqnhhCe2cNTNI5+r7vm1/slM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772788461; c=relaxed/simple;
	bh=JKzMlTcipeSWdd4kI5ZolpM+mSx8A4Dj6G+S++QpsY8=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=WWoDznP/w2q59PuEYvyQ7ZipCkq1EBZLnWAMxgF4WshYaRdiwZzIEe0VHZ4NnoTHpo8+9chCC5etGKk+Y98bFPIOmMsyJtjHI9mNI5ygEMUeCMDvhboRO1PujST2Y/KgjpKjGHpLPr2F0d0YhFCxrUDWOY7ZFcuqWTVSyPSxkI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=KMShgcHI; arc=none smtp.client-ip=162.62.58.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1772788448; bh=A5j5LGtzImJEs4JwbuwYYdP2w1Tc4QKsLVwxO5vOn2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KMShgcHIacBIWGvi2iIOSIQGaq3FNgk+sh59Kp40lrk/DezPJpVaBHxZlRGjDxCfR
	 4GdT0UdakhMz+NtXJlr5MrNdJqlFZEgBBQPRD26SsLxnOETeWk8I283JgkDhGhQIFc
	 5QvD2y9XBHcy5IKo7VfKp7g7A4zPtA76X/TYNCC8=
Received: from localhost.localdomain ([101.6.30.191])
	by newxmesmtplogicsvrsza53-0.qq.com (NewEsmtp) with SMTP
	id 32309E2A; Fri, 06 Mar 2026 17:12:35 +0800
X-QQ-mid: xmsmtpt1772788355t1dzbkko9
Message-ID: <tencent_7A9F1B4D75468C0CF5DE1B6902038C948B07@qq.com>
X-QQ-XMAILINFO: Od8VqZhFMB3N6T8rBpCruW62bDg84CRETrT5Z1ygtPyhw3g7tTNAG6EFL9/XIy
	 QRZQLURIWVYagYtKVNPOzYvSRsbz6xZmxoEhm1n7Wd5yV7o5g+IRN/6X3WDgFsQe06CTm7Qh0cMY
	 R0Wnazw0hJs8FGX3kGAllTZRi2asrSHs0oxbEpeSm65qjsxw0j0K3v1kZ2r+aLYrt655lZBCMyU/
	 qn5Bxbw5MECQZDl9GWNqwUKyWM56S/qTvkdGfCkzcovfx1cTl6TGAGeoLU5r8Ey1/U6IhzCU3VXo
	 ndTRdJqldwavaxhN0gPtveNCY8icbUA4YXRirDjOxqzL52nOf/r6YFs9FP6G8Cyqo1SSrGLrSDGo
	 eXApfrhIGoV0pw302ZTm03/0La1XZ8pSBXXNgx+yJKcaYNPKHR8vGeQCgWLEBY5VdcV0l/JcwwQR
	 vUkEtJt9HkKvxSBuKcm6DXgHPZij0I8BFWxTiWpKmrtrTB4J0LvVQxoxmRU7S1HxYTfpWCLTpr2z
	 lRplAgRzpxTZrH/GGNLtM3iYop6DEOmXQiZ8KA1J9F09vKaTh00vvuCGYkNLbQlHybFFrfW/lEnN
	 Xd3KpqnK0HKhH4+jmEioUV/0PSm3Ls5NsvOMfAmJfiKHmhXuUlwOneKXWt5zk4sdBYPRNOO1N6tr
	 rotLaYOyUBsp/N2oADi7RVEu7FoZImjHrA48pGq6vunLpaBLGq5QYJBMea8rhEJIHFvDKQI5HiuS
	 DcZBt9uEeCnw45KpG42o6r334hFTYQXN4+pzrkIIJpUBNwErbjduyFCceZgYUZMbFm5As7apmTQg
	 kr2WKiImQ7lS0gIMpbfa8CFBaddjCwuXWdaWr7l++3eMa6Ys2pk3Oqlv4QXh+th04u2Ycp6mGApA
	 LOtDpspscrj4UmoQSCEuRKd2Cfs1XNgQpzTrjgtSOQhpeRjrGD8CT5KQ9A9lvU5wkcNe50U3p7nN
	 HcYYM55EuVCr0sGJbuLXwaaa5E5C2KpL8kTVRH+LnbGBMsS0EakYvUxSneDyShq47iwb6wmpzCxm
	 Js1IAGiwz/bSSzTKRs
X-QQ-XMRINFO: Nq+8W0+stu50tPAe92KXseR0ZZmBTk3gLg==
From: xuanqingshi <1356292400@qq.com>
To: seanjc@google.com,
	pbonzini@redhat.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	xuanqingshi <1356292400@qq.com>
Subject: [PATCH v2] KVM: x86: Add LAPIC guard in kvm_apic_write_nodecode()
Date: Fri,  6 Mar 2026 17:12:32 +0800
X-OQ-MSGID: <20260306091232.2756961-1-1356292400@qq.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <aamiMBRsSwn7yxu0@google.com>
References: <aamiMBRsSwn7yxu0@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1A36521DB61
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[qq.com,quarantine];
	R_DKIM_ALLOW(-0.20)[qq.com:s=s201512];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_FROM(0.00)[qq.com];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73001-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,qq.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[1356292400@qq.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[qq.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo,qq.com:dkim,qq.com:email,qq.com:mid]
X-Rspamd-Action: no action

kvm_apic_write_nodecode() dereferences vcpu->arch.apic without first
checking whether the in-kernel LAPIC has been initialized.  If it has
not (e.g. the vCPU was created without an in-kernel LAPIC), the
dereference results in a NULL pointer access.

While APIC-write VM-Exits are not expected to occur on a vCPU without
an in-kernel LAPIC, kvm_apic_write_nodecode() should be robust against
such a scenario as a defense-in-depth measure, e.g. to guard against
KVM bugs or CPU errata that could generate a spurious APIC-write
VM-Exit.

Use KVM_BUG_ON() with lapic_in_kernel() instead of a simple
WARN_ON_ONCE(), as suggested by Sean Christopherson, so that KVM
kills the VM outright rather than letting it continue in a broken
state.

Found by a VMCS-targeted fuzzer based on syzkaller.

Signed-off-by: xuanqingshi <1356292400@qq.com>
---
 arch/x86/kvm/lapic.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 9381c58d4c85..02f2039d5f99 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2657,6 +2657,9 @@ void kvm_apic_write_nodecode(struct kvm_vcpu *vcpu, u32 offset)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
 
+	if (KVM_BUG_ON(!lapic_in_kernel(vcpu), vcpu->kvm))
+		return;
+
 	/*
 	 * ICR is a single 64-bit register when x2APIC is enabled, all others
 	 * registers hold 32-bit values.  For legacy xAPIC, ICR writes need to
-- 
2.25.1


