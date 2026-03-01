Return-Path: <kvm+bounces-72299-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +NiBOVKno2mWJAUAu9opvQ
	(envelope-from <kvm+bounces-72299-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 01 Mar 2026 03:41:22 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DC4E1CDCE2
	for <lists+kvm@lfdr.de>; Sun, 01 Mar 2026 03:41:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9687F320453D
	for <lists+kvm@lfdr.de>; Sun,  1 Mar 2026 01:33:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 096432DBF40;
	Sun,  1 Mar 2026 01:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ddETAojx"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FAE929A9E9;
	Sun,  1 Mar 2026 01:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772328763; cv=none; b=CMavcugjx0nRGNr36edurUwIaqYe00qDtDXA6AafZZ1/ZuQ2KuvPiA7uY/8dJ3sYo5LpZWkVoX+RpWp1if93ivIsxI6e0ayZiltVbRvA2LfUs3nc0nLFeI54u2Wf6DZhzMaG4bf2iZfuIwHWYOLZ7nkMhiW2i1vg4VDbhqMTNNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772328763; c=relaxed/simple;
	bh=RR0DWG+igudPtxILEgmvaTUm9DW+EU+t8snrhECsS54=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AE+KtO2OfLVnqgjhz4egX5tBTEFWaz9eCaj0WdPOCZdzioTinIt6QIvlWCenKXz00nAN8JBmMhV0q3tJdx0z+GcBGy/W/1xs2TkF1x861an0mlpWfqOU4zGe0XNwcJpdgFfjCUw4gCHI4QxLFyWYsw4jzjDnwYs0Xolq++Xvyjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ddETAojx; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71F98C19421;
	Sun,  1 Mar 2026 01:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772328763;
	bh=RR0DWG+igudPtxILEgmvaTUm9DW+EU+t8snrhECsS54=;
	h=From:To:Cc:Subject:Date:From;
	b=ddETAojxw0HUMuYzVejCihVnkbp7g/wTWxpb1TMQEWmnbvC+Lg+oh/3R1ZZGZdRM7
	 HS7oBQ6gwnxNbhdtdGuhsRHS8IFpZejCe1NvcI7GFi43FqsBt9tUVxbzZA60AteoK9
	 J2zrtS8rlw7fElHm9EGzdE4AmypZBgD2AcEGxEojuOa1UIOqb2mNZwNSEC8J3Kw05B
	 fblx9qD6XmI3h9+7M6/b4uG0zC2rl7wE8NKsOfMSRs+jpEz627JOloWFCS051zq56L
	 lglTu0oXdMhOTJWnnatmIM4zb4+LY3U2OVmKTHPrdf507PuRuWrmWAKQ874XhqbFNL
	 BNlySZZnl+wtQ==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	yosry@kernel.org
Cc: Maxim Levitsky <mlevitsk@redhat.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Sean Christopherson <seanjc@google.com>,
	kvm@vger.kernel.org
Subject: FAILED: Patch "KVM: nSVM: Always use vmcb01 in VMLOAD/VMSAVE emulation" failed to apply to 6.6-stable tree
Date: Sat, 28 Feb 2026 20:32:41 -0500
Message-ID: <20260301013241.1691709-1-sashal@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72299-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sashal@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,msgid.link:url]
X-Rspamd-Queue-Id: 8DC4E1CDCE2
X-Rspamd-Action: no action

The patch below does not apply to the 6.6-stable tree.
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





