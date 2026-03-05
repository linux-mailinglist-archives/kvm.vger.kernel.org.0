Return-Path: <kvm+bounces-72808-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uMTWLpJkqWmB6gAAu9opvQ
	(envelope-from <kvm+bounces-72808-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 12:10:10 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EC1C2105A4
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 12:10:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id D95273024BF1
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 11:08:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52DEF3845D2;
	Thu,  5 Mar 2026 11:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="u8XH++Ny"
X-Original-To: kvm@vger.kernel.org
Received: from out162-62-57-252.mail.qq.com (out162-62-57-252.mail.qq.com [162.62.57.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17FA53859E8;
	Thu,  5 Mar 2026 11:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.252
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772708899; cv=none; b=kevz7S0bAIshLHRFKsMiqNIbRuft/xzMf6hzDVPM8eywz4R6PTH5/RN9sl8LbjRZ7G/AtAHiX7Iac1kg91KbqvYVt2+qB45zv3WBBpuKjyzP1svwv049pL7l4BWR7ptzxpzyz3IwLl5QYsstecaoONv7PcEjgcNNuLIX4YYkp5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772708899; c=relaxed/simple;
	bh=UXb4sZI8YwnhUH/PBfc/DXgXZISTku4AtPXoV74Lmao=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=UxCE6vuV4tfHUAD8N48HaUFSkmwhEcqnobZe/Zux1MhdfaFnVRgrcSedL73uIHPZu4VPOR9yxu13FpiGuLGzTUqHnvXQHF3K+24jlxBJhWWDtpQe8wguM2pV+Iss7lIl19rgH5rhVOd7EdSLfFWPNzZ+NpQEYSF4e0eGlMoNzss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=u8XH++Ny; arc=none smtp.client-ip=162.62.57.252
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1772708886; bh=aJ0+7T1qICbCK7VFbFhr3fYHwEbG3O9P5mFrYabjhdI=;
	h=From:To:Cc:Subject:Date;
	b=u8XH++NyB/h3To7h9bD9XsuCraYDW3Z4rdyCeoxGg7OXOXF4ARfZbRFwqPRHxuv9C
	 b4S+VZNqG+nmQDsCVSkOOds7WQeDLxnjf77ikbpTAkp4wFJHDLCo7JafihCAWAi3my
	 RncozI1MjQCm9rZVT5glyLoYzQM7+pYjA6wv8/08=
Received: from localhost.localdomain ([101.6.30.191])
	by newxmesmtplogicsvrsza53-0.qq.com (NewEsmtp) with SMTP
	id 1F9B10F5; Thu, 05 Mar 2026 19:07:57 +0800
X-QQ-mid: xmsmtpt1772708877tee0fkhag
Message-ID: <tencent_4897299F3F479A188C8C19A7BD58D2A40608@qq.com>
X-QQ-XMAILINFO: NwU6Bou9okj/qNygOt772l9yfwiVhzW4IQ0Ag/yV27/BsK2WwZrax1e+/EomqE
	 5zgluaeMcgh4wqw9diaywDUo/b5beP8jTc6dZjwouYWRw/48PkY95s6FgF/eD1mpwGmynBsr28qT
	 lJS77XRP/aCHy7gLmlrK4IwLYbQzappLoy1SBRwifanYZV6Fbx2+L4oSWnxLDs0KwndJNmy9pHiG
	 AZ9OmrZcl1fVEumCsED8Ih/Zk6MFm3SdkneeeS3jW4FUNE3VfEjfMyO/vFLbzBOx/o2z1MvOHiAY
	 S3cfE7mJtRdTSs76L1AqVGA5M/BaY5O/2EkRnaJH6p1pzKc/6EYWCbs1wP7ppEkhE0aIBeAOAaB/
	 KH6TCHQrgek57lgma3wCQ/ZMWrIBFfVGImeKXVpIfmUV2nofgkWo7N2JDGUZoZt6doCk1O8MGuci
	 rxqtarzr2QC0B05tuURfNc0iB9KxDxWZ4Ie68eEDr5fS33uQjKU+W48aM6BPjj5JhtZbSbFwmHfx
	 v+EaAGefG8BYml7jX+76Wa080j1gvs/h3GW4s4N0GSsU/kErzwdQsogjlvfgVy1YPQmQ47fDPeaS
	 zOzO49WElNdIXw5O4ye2KPrG9P5dUX1TsFJ/Wo1elmVLFnwm7wX+gpsrX5bsGWbe5FfXKuxkX2fy
	 mqT3+SrebfkuSd1gndbbeA4Wu/K4Cl+79s/7UjKfQKHFWVdsXpSYmVxSFAq+9YWNbmg5CASQkS1Z
	 pyAt3QY+Jb8FN/DbaAk8SNG+nf8kMzlYauwWCo+csu6vlPDY1+Vq9zsEufq9O1OyBODb42cp1eP5
	 4AbdtZfMBNCoImQme+GovnyukWwjf9kuAcjq1sUY7AmMJj8UTKgecZgyO3h7I4eGOONZS5J6E6LX
	 IvF0bQvQy2u01kVhdW9LQO8cyAtxk4rFdgxcO8D8ZpXzbL4WKEVCaCj2KnW6wrrQGDRHwLV27zzN
	 LBr7/O37lzSaT7VuvKvy4x1quZjXZNPhHIgZJEcLF7WyuuBG3IEkwU2jk5QrihR4x6P8/bGluHv2
	 UQJKIQYg==
X-QQ-XMRINFO: MSVp+SPm3vtSI1QTLgDHQqIV1w2oNKDqfg==
From: xuanqingshi <1356292400@qq.com>
To: seanjc@google.com,
	pbonzini@redhat.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	xuanqingshi <1356292400@qq.com>
Subject: [PATCH] KVM: x86: Add LAPIC guard in kvm_apic_write_nodecode()
Date: Thu,  5 Mar 2026 19:07:53 +0800
X-OQ-MSGID: <20260305110753.2709162-1-1356292400@qq.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0EC1C2105A4
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
	TAGGED_FROM(0.00)[bounces-72808-lists,kvm=lfdr.de];
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

Add a WARN_ON_ONCE() guard and bail early if vcpu->arch.apic is NULL.

Found by a VMCS-targeted fuzzer based on syzkaller.

Signed-off-by: xuanqingshi <1356292400@qq.com>
---
 arch/x86/kvm/lapic.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 9381c58d4c85..0f9d314dfa2a 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2657,6 +2657,9 @@ void kvm_apic_write_nodecode(struct kvm_vcpu *vcpu, u32 offset)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
 
+	if (WARN_ON_ONCE(!apic))
+		return;
+
 	/*
 	 * ICR is a single 64-bit register when x2APIC is enabled, all others
 	 * registers hold 32-bit values.  For legacy xAPIC, ICR writes need to
-- 
2.25.1


