Return-Path: <kvm+bounces-72327-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iL3tNWXOpGl9rwUAu9opvQ
	(envelope-from <kvm+bounces-72327-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 00:40:21 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D1CB61D1F3A
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 00:40:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 040C13006D45
	for <lists+kvm@lfdr.de>; Sun,  1 Mar 2026 23:40:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C333C30BBB8;
	Sun,  1 Mar 2026 23:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="huEY/m7E"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 043C0277C81;
	Sun,  1 Mar 2026 23:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772408416; cv=none; b=n5SStMHJO/bUcOGxJhQn25/EnmglXuabIb+74sg3LyaCQNRel8ZPUdDqMxBPzftXfLJk84z/y1nheaWZhwV46xTBLnD29PYwRKf7+/+6rvqtJc2kRXgSrbNimFfJRulub+6BElqr0ZKFgy3JqXE+FlpfSwQJ/HNzRxcMwzo/WfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772408416; c=relaxed/simple;
	bh=rB6cHgHWljujraVsxeCL3GSF3dbHY1U8aJGp1IvlCZI=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=FaprHkXRCvRbKFpDhHuv1tGwuJmsSBTrwRA0B4LbuSPgtr1g0rD9aFL4PDs2BdHIlhGi5xkvg15/E3fJH+U6rJfYsBEz4HLvokX2Ly69Dq+9tx0uSt0pGSqGNccNzd3oP1V25ktqfykKSb1s5Ljqes6jsRZbujnMRODDlQTkmCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=huEY/m7E; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB071C116C6;
	Sun,  1 Mar 2026 23:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772408415;
	bh=rB6cHgHWljujraVsxeCL3GSF3dbHY1U8aJGp1IvlCZI=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=huEY/m7Ea196XKMZur/4pv8xAv+VOQI/MGX78ohYFbEZcyjo9Fb9DYUQncBe6Tb8K
	 eadPmE1+uDny02WdZB6h6lIyjMynfx0g3UW40WjqUSFLTdjEjCRE33Yn4Znc36OT+B
	 1NWUhLdzC5urPrxVciu62T0BUhGW+UwGxcWRI8jBExHGgApXtr9il5vPdf8z4bWSQz
	 djaUF8q7SL/HR7kODJ0z6z80tPrFeS6O9qQgUg5f8JMBVjEqTicUUWnTnyvl1/4sVM
	 66rqH/A41vBzUePNJ1AkJNzar6KD7XwsnvDsIovV/PaI8s8SLGXQGdagfRO3GYg5fU
	 wzAT07mh/MKBg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7D01D39308CE;
	Sun,  1 Mar 2026 23:40:19 +0000 (UTC)
Subject: Re: [GIT PULL] KVM changes for Linux 7.0-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260301141507.444155-1-pbonzini@redhat.com>
References: <20260301141507.444155-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260301141507.444155-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 55365ab85a93edec22395547cdc7cbe73a98231b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 949d0a46ad1b9ab3450fb6ed69ff1e3e13c657bd
Message-Id: <177240841810.3443558.3204616118429348999.pr-tracker-bot@kernel.org>
Date: Sun, 01 Mar 2026 23:40:18 +0000
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_FROM(0.00)[bounces-72327-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_NO_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pr-tracker-bot@kernel.org,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D1CB61D1F3A
X-Rspamd-Action: no action

The pull request you sent on Sun,  1 Mar 2026 15:15:07 +0100:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/949d0a46ad1b9ab3450fb6ed69ff1e3e13c657bd

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

