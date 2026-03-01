Return-Path: <kvm+bounces-72306-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GFesB8+ao2l4IAUAu9opvQ
	(envelope-from <kvm+bounces-72306-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 01 Mar 2026 02:47:59 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id E48DE1CBC79
	for <lists+kvm@lfdr.de>; Sun, 01 Mar 2026 02:47:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 50B0B305FB6E
	for <lists+kvm@lfdr.de>; Sun,  1 Mar 2026 01:42:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6676026ED35;
	Sun,  1 Mar 2026 01:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n9WrRiHk"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BC8B277C9D;
	Sun,  1 Mar 2026 01:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772329318; cv=none; b=sOREAoKvNQ2QpjHYqqmQ5EAbBNYOBs2SWP0JMk7N/xVQcLhHRL6KO8878dHJfrG8WeOkIfsw8aTBrsUIttO6LtdPJR4ysv1DWKBiP8I7f4E2JFx5kD2F/OHoPlNAiWhiAIqK8WSbfxAhH+RX54KP7CTz5I/howYiOf/Q1Ka/UvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772329318; c=relaxed/simple;
	bh=sNIm/syIpXLQY8irgCpfUS8E+jfY6JWMK27YtMlbmb4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hwfMjppcCcUmRjbonjv6jo7m/qK7S/mVM5LXDXu9JbXXcSaLjgPnzldeOdKbixPjHKk/5JiAlvPUh4Unztp4YJbrM/SkzT135G5ouefzztzSzvUktgm9HjkrHBhDx/jZqvZL2ZENtHAriIY4pNr3lQtb+thT2/j6pbTv0Wp8eCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n9WrRiHk; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6A11C19421;
	Sun,  1 Mar 2026 01:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772329318;
	bh=sNIm/syIpXLQY8irgCpfUS8E+jfY6JWMK27YtMlbmb4=;
	h=From:To:Cc:Subject:Date:From;
	b=n9WrRiHkAefXdzbwwkagnVr1gE2ZkDYkJPRyW7QmZsYFXaRMRaCMQ/sL9yvAB86K4
	 mwLvGphCImg0gVKTvdzE1e0+jQE5o2tFJ1CKE6MLNT37lttg3Wc/2DeDGO9QCwb9x5
	 YyKoxHjf+/9dFiybMgATTHU/9pd8Wy3JGZre0R3bpiotvVsEEv32LyqCWwYxh0s0pi
	 Z/9xFoLyV9pLDdlRaav+NPQZKziRTdlKry8HisUhpa4raoF5h06hm+343EYUBM9KUB
	 snvBOj4Ki4KBs6pLqJwQaVn6Gy4KMsXTSbbHA3CjUBiTC+scY20shBtcUzGq6BL5Rs
	 2lYR1gNU3AxHw==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	yosry@kernel.org
Cc: Maxim Levitsky <mlevitsk@redhat.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Sean Christopherson <seanjc@google.com>,
	kvm@vger.kernel.org
Subject: FAILED: Patch "KVM: nSVM: Always use vmcb01 in VMLOAD/VMSAVE emulation" failed to apply to 6.1-stable tree
Date: Sat, 28 Feb 2026 20:41:56 -0500
Message-ID: <20260301014156.1703695-1-sashal@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72306-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sashal@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,msgid.link:url,linux.dev:email]
X-Rspamd-Queue-Id: E48DE1CBC79
X-Rspamd-Action: no action

The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From 127ccae2c185f62e6ecb4bf24f9cb307e9b9c619 Mon Sep 17 00:00:00 2001
From: Yosry Ahmed <yosry.ahmed@linux.dev>
Date: Sat, 10 Jan 2026 00:48:18 +0000
Subject: [PATCH] KVM: nSVM: Always use vmcb01 in VMLOAD/VMSAVE emulation

Commit cc3ed80ae69f ("KVM: nSVM: always use vmcb01 to for vmsave/vmload
of guest state") made KVM always use vmcb01 for the fields controlled by
VMSAVE/VMLOAD, but it missed updating the VMLOAD/VMSAVE emulation code
to always use vmcb01.

As a result, if VMSAVE/VMLOAD is executed by an L2 guest and is not
intercepted by L1, KVM will mistakenly use vmcb02. Always use vmcb01
instead of the current VMCB.

Fixes: cc3ed80ae69f ("KVM: nSVM: always use vmcb01 to for vmsave/vmload of guest state")
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Link: https://patch.msgid.link/20260110004821.3411245-2-yosry.ahmed@linux.dev
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index e454ae095cf7c..f1a5b61bdb5bc 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2122,12 +2122,13 @@ static int vmload_vmsave_interception(struct kvm_vcpu *vcpu, bool vmload)
 
 	ret = kvm_skip_emulated_instruction(vcpu);
 
+	/* KVM always performs VMLOAD/VMSAVE on VMCB01 (see __svm_vcpu_run()) */
 	if (vmload) {
-		svm_copy_vmloadsave_state(svm->vmcb, vmcb12);
+		svm_copy_vmloadsave_state(svm->vmcb01.ptr, vmcb12);
 		svm->sysenter_eip_hi = 0;
 		svm->sysenter_esp_hi = 0;
 	} else {
-		svm_copy_vmloadsave_state(vmcb12, svm->vmcb);
+		svm_copy_vmloadsave_state(vmcb12, svm->vmcb01.ptr);
 	}
 
 	kvm_vcpu_unmap(vcpu, &map);
-- 
2.51.0





