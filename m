Return-Path: <kvm+bounces-72293-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IHzODXuVo2l7HQUAu9opvQ
	(envelope-from <kvm+bounces-72293-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 01 Mar 2026 02:25:15 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 12EEC1CA801
	for <lists+kvm@lfdr.de>; Sun, 01 Mar 2026 02:25:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 06552301BDF1
	for <lists+kvm@lfdr.de>; Sun,  1 Mar 2026 01:23:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6B7025A2A2;
	Sun,  1 Mar 2026 01:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QW98TqwA"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 174322727EB;
	Sun,  1 Mar 2026 01:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772328211; cv=none; b=g3W2VB5xDoikAj2TGQMROQopiFapHa22xB3hoKC724f9PRJuBz/l16H2fe8qf/2uqiHt731fCoAbLjuFCcAvGiCUtpkQyFIj96MHovxbryHRai4mLgPDVr943o1Z8mbwttU7afYd3G4+a+IL4LPoMruqKUK5AGAYylXrhl/r8FI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772328211; c=relaxed/simple;
	bh=A3+1fcinTQPIBQXsLzCktl21b04BCGy1w53xCJ6r/QI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IGfoRn+Y0N5Dsgc5obl68+96yIVy1D1bAWLEN2BpuMis80UFm3P6RebRDBQ9MUJCeN6fl+bwrPg56OwzQBWvno7d5UMbXsNYGLEhPXUty4oQWzjTID9EVFMu6UIjmXHYJv8UgRFdksXAymg+tRDq5jHBWh83j49gb4krq0LSudw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QW98TqwA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C316C19421;
	Sun,  1 Mar 2026 01:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772328210;
	bh=A3+1fcinTQPIBQXsLzCktl21b04BCGy1w53xCJ6r/QI=;
	h=From:To:Cc:Subject:Date:From;
	b=QW98TqwAPzuyKEvYuimCam6hB1ezMPQO3Ipp1UjJR4bW4W3krg/3bWZqgERYP0QuU
	 eDcYAUpEPh8D2RbNgKPd2D66xY23rV1600kTzfbguAb0/O7uSZEyYqzhYMa/d5+I3Z
	 uG2PEI5DwD1YdhUgwMPdPtIm9CxQGel0EYLAdLCNVgi1UduRo+tQHeljifGZTFn0T8
	 WAfBTJXpnmOWg8f3nSbVOkBWBXEpCBvFLevE0aZe0mil3xOYcFbcCLzBny0vBbUVKW
	 dNsUaYMsGSVAJw7yp0isSCSXKyTCNSwezKPwemNBTf82yLeyx3xzoweSGWJuTht0rF
	 uBtElXscT1kYA==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	kovalev@altlinux.org
Cc: Sean Christopherson <seanjc@google.com>,
	kvm@vger.kernel.org
Subject: FAILED: Patch "KVM: x86: Add SRCU protection for reading PDPTRs in __get_sregs2()" failed to apply to 6.12-stable tree
Date: Sat, 28 Feb 2026 20:23:28 -0500
Message-ID: <20260301012329.1680196-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72293-lists,kvm=lfdr.de];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCPT_COUNT_THREE(0.00)[4];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sashal@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linuxtesting.org:url,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,altlinux.org:email,msgid.link:url]
X-Rspamd-Queue-Id: 12EEC1CA801
X-Rspamd-Action: no action

The patch below does not apply to the 6.12-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From 95d848dc7e639988dbb385a8cba9b484607cf98c Mon Sep 17 00:00:00 2001
From: Vasiliy Kovalev <kovalev@altlinux.org>
Date: Sat, 24 Jan 2026 01:28:01 +0300
Subject: [PATCH] KVM: x86: Add SRCU protection for reading PDPTRs in
 __get_sregs2()

Add SRCU read-side protection when reading PDPTR registers in
__get_sregs2().

Reading PDPTRs may trigger access to guest memory:
kvm_pdptr_read() -> svm_cache_reg() -> load_pdptrs() ->
kvm_vcpu_read_guest_page() -> kvm_vcpu_gfn_to_memslot()

kvm_vcpu_gfn_to_memslot() dereferences memslots via __kvm_memslots(),
which uses srcu_dereference_check() and requires either kvm->srcu or
kvm->slots_lock to be held. Currently only vcpu->mutex is held,
triggering lockdep warning:

=============================
WARNING: suspicious RCU usage in kvm_vcpu_gfn_to_memslot
6.12.59+ #3 Not tainted

include/linux/kvm_host.h:1062 suspicious rcu_dereference_check() usage!

other info that might help us debug this:

rcu_scheduler_active = 2, debug_locks = 1
1 lock held by syz.5.1717/15100:
 #0: ff1100002f4b00b0 (&vcpu->mutex){+.+.}-{3:3}, at: kvm_vcpu_ioctl+0x1d5/0x1590

Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0xf0/0x120 lib/dump_stack.c:120
 lockdep_rcu_suspicious+0x1e3/0x270 kernel/locking/lockdep.c:6824
 __kvm_memslots include/linux/kvm_host.h:1062 [inline]
 __kvm_memslots include/linux/kvm_host.h:1059 [inline]
 kvm_vcpu_memslots include/linux/kvm_host.h:1076 [inline]
 kvm_vcpu_gfn_to_memslot+0x518/0x5e0 virt/kvm/kvm_main.c:2617
 kvm_vcpu_read_guest_page+0x27/0x50 virt/kvm/kvm_main.c:3302
 load_pdptrs+0xff/0x4b0 arch/x86/kvm/x86.c:1065
 svm_cache_reg+0x1c9/0x230 arch/x86/kvm/svm/svm.c:1688
 kvm_pdptr_read arch/x86/kvm/kvm_cache_regs.h:141 [inline]
 __get_sregs2 arch/x86/kvm/x86.c:11784 [inline]
 kvm_arch_vcpu_ioctl+0x3e20/0x4aa0 arch/x86/kvm/x86.c:6279
 kvm_vcpu_ioctl+0x856/0x1590 virt/kvm/kvm_main.c:4663
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:907 [inline]
 __se_sys_ioctl fs/ioctl.c:893 [inline]
 __x64_sys_ioctl+0x18b/0x210 fs/ioctl.c:893
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xbd/0x1d0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Suggested-by: Sean Christopherson <seanjc@google.com>
Cc: stable@vger.kernel.org
Fixes: 6dba94035203 ("KVM: x86: Introduce KVM_GET_SREGS2 / KVM_SET_SREGS2")
Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
Link: https://patch.msgid.link/20260123222801.646123-1-kovalev@altlinux.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 386cdb775fd48..1ea94f4a3dcbc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12145,9 +12145,11 @@ static void __get_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2)
 		return;
 
 	if (is_pae_paging(vcpu)) {
+		kvm_vcpu_srcu_read_lock(vcpu);
 		for (i = 0 ; i < 4 ; i++)
 			sregs2->pdptrs[i] = kvm_pdptr_read(vcpu, i);
 		sregs2->flags |= KVM_SREGS2_FLAGS_PDPTRS_VALID;
+		kvm_vcpu_srcu_read_unlock(vcpu);
 	}
 }
 
-- 
2.51.0





