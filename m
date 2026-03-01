Return-Path: <kvm+bounces-72291-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uIvoN4KVo2lPHgUAu9opvQ
	(envelope-from <kvm+bounces-72291-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 01 Mar 2026 02:25:22 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id E8ACE1CA834
	for <lists+kvm@lfdr.de>; Sun, 01 Mar 2026 02:25:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 64C763014F4E
	for <lists+kvm@lfdr.de>; Sun,  1 Mar 2026 01:21:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34C4D2848AD;
	Sun,  1 Mar 2026 01:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PFcy/J/L"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 698532BD0B;
	Sun,  1 Mar 2026 01:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772328059; cv=none; b=FXjTLG7MIwg10DCgoHpGSQKYeKLs7A/d0xTKITBnBA02j/s01hSWV9Kn7AqYfRx6PA/Blp9mrximgAE8tbbReqtNrzzpgZzGzy4A0foPWVRStbkNVEdNdZMpZaN5LE+pZtmxuhtHHrHUeaM4x47UrQW8w62B7o3FOlg3rhYus9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772328059; c=relaxed/simple;
	bh=zCvOeCqR4GE1v1zY+J8ukX5yI1snoTKj7zOaqopj7WM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=n8S0nZlUn8L4yhWMX1Ll+qkwerjwCd0QS8LvxYiB1vBhjyQfdP5WrpwmI5gLh9JSsDlq4Z5MYVGn0x9fW0pqX4/n8EE05Xaoo5zsxtDhoH6ptGesfXwkqYoEyIAvrafM+KH2+Q3bmfXwiTrEWHm4I4aDl6Ly2W5pu2oAxFFSPkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PFcy/J/L; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD729C19421;
	Sun,  1 Mar 2026 01:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772328059;
	bh=zCvOeCqR4GE1v1zY+J8ukX5yI1snoTKj7zOaqopj7WM=;
	h=From:To:Cc:Subject:Date:From;
	b=PFcy/J/LKdGSPnmyQywBBb1tvgRuKxnvdNiFhqE6dwxw8lLnrT+9JECzr26iJXz4a
	 EMtBtfPBNIrgT5FsD8BbVC7q4I3v9mqIPynjxQBWXpnuSIOSsq6zdiFd9wB0e2/4IE
	 rian/fVmAN5weJvEhlXDWuM66ctfgs+KGCvbYOLKhIPvB+PlZIppsxZtPcIn/24riW
	 B5cIFnESpralStGdwiSJVc9O+B0yFTYA/W7y99uP/0VAj8YnGENvOts33KxMAFm+G9
	 8ERE4Ae/wppUnyAMq2gANeygcK8zEq10vZCuomGa+2e7yR08Jw75D1LTazc0TF933t
	 89kDLSZ4zwuvg==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	seanjc@google.com
Cc: Alessandro Ratti <alessandro@0x65c.net>,
	syzbot+1522459a74d26b0ac33a@syzkaller.appspotmail.com,
	kvm@vger.kernel.org
Subject: FAILED: Patch "KVM: x86: Ignore -EBUSY when checking nested events from vcpu_block()" failed to apply to 6.12-stable tree
Date: Sat, 28 Feb 2026 20:20:57 -0500
Message-ID: <20260301012057.1676727-1-sashal@kernel.org>
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
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-72291-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sashal@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-0.995];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm,1522459a74d26b0ac33a];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[syzkaller.appspot.com:url,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,appspotmail.com:email,msgid.link:url]
X-Rspamd-Queue-Id: E8ACE1CA834
X-Rspamd-Action: no action

The patch below does not apply to the 6.12-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From ead63640d4e72e6f6d464f4e31f7fecb79af8869 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Thu, 8 Jan 2026 19:06:57 -0800
Subject: [PATCH] KVM: x86: Ignore -EBUSY when checking nested events from
 vcpu_block()

Ignore -EBUSY when checking nested events after exiting a blocking state
while L2 is active, as exiting to userspace will generate a spurious
userspace exit, usually with KVM_EXIT_UNKNOWN, and likely lead to the VM's
demise.  Continuing with the wakeup isn't perfect either, as *something*
has gone sideways if a vCPU is awakened in L2 with an injected event (or
worse, a nested run pending), but continuing on gives the VM a decent
chance of surviving without any major side effects.

As explained in the Fixes commits, it _should_ be impossible for a vCPU to
be put into a blocking state with an already-injected event (exception,
IRQ, or NMI).  Unfortunately, userspace can stuff MP_STATE and/or injected
events, and thus put the vCPU into what should be an impossible state.

Don't bother trying to preserve the WARN, e.g. with an anti-syzkaller
Kconfig, as WARNs can (hopefully) be added in paths where _KVM_ would be
violating x86 architecture, e.g. by WARNing if KVM attempts to inject an
exception or interrupt while the vCPU isn't running.

Cc: Alessandro Ratti <alessandro@0x65c.net>
Cc: stable@vger.kernel.org
Fixes: 26844fee6ade ("KVM: x86: never write to memory from kvm_vcpu_check_block()")
Fixes: 45405155d876 ("KVM: x86: WARN if a vCPU gets a valid wakeup that KVM can't yet inject")
Link: https://syzkaller.appspot.com/text?tag=ReproC&x=10d4261a580000
Reported-by: syzbot+1522459a74d26b0ac33a@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/671bc7a7.050a0220.455e8.022a.GAE@google.com
Link: https://patch.msgid.link/20260109030657.994759-1-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e4418409b468d..fe9d324da72ab 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11597,8 +11597,7 @@ static inline int vcpu_block(struct kvm_vcpu *vcpu)
 	if (is_guest_mode(vcpu)) {
 		int r = kvm_check_nested_events(vcpu);
 
-		WARN_ON_ONCE(r == -EBUSY);
-		if (r < 0)
+		if (r < 0 && r != -EBUSY)
 			return 0;
 	}
 
-- 
2.51.0





