Return-Path: <kvm+bounces-70262-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wBufEeSUg2mppgMAu9opvQ
	(envelope-from <kvm+bounces-70262-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 19:50:12 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id DAA28EBC2A
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 19:50:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A65DB303DAB2
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 18:49:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED9F242846D;
	Wed,  4 Feb 2026 18:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t+MsPTDr"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 252E63DA7CE;
	Wed,  4 Feb 2026 18:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770230965; cv=none; b=rmLDJ1PFY6Y4rJBkutZz1cT62IqzH1OsVttrinJNr6M6cq9nPJxYStzZc7TRZrdOE/Pyoo5k9FVol1PwrERPTf9js/jC1wDjsXhikl4v+r+fjOlQGcDboP+/Q/6R7uoFj5FUpcUTtYDnyqEnOKHKYou10sKKgY1NH/tsa6rSAsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770230965; c=relaxed/simple;
	bh=CP//iRJXawB3TPu7bul2ZmaEPILlCQ82JYQhhLZzjR8=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=KVGYokQOfwRNpIeBGoXVlzLnon19nDQGwgqrJRGR+cuthCkguxReOxvw6FQs/pZk3T37++UXTO3Nflkd/UL0KveI9bunkGIMCiMUO+yyrFbYQgMJkqmmFkpI2BUWCNLaJNvthjG/2h1N/W5RCckWmMFR+xWCbXi+mgqOl3RY+Wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t+MsPTDr; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFD32C4CEF7;
	Wed,  4 Feb 2026 18:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770230964;
	bh=CP//iRJXawB3TPu7bul2ZmaEPILlCQ82JYQhhLZzjR8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=t+MsPTDr1vb+J+b3ntsUM9jCdRWy7Ql9egnWkY2wRKop5kCO/olkqOyFM9HFvmRGe
	 O3OkR6v8skq/1EQeGo7t+im89zA5/zVmL9GWQqIt9yVA7JQd5ZAZ+jGiApwd7Yl8ez
	 rFyuhn4fxQZ4no2BElCtz30zsULl37sQ5rkHHyZGaEYN2IpapIJJ2IxrDj4yjBC2fh
	 NzH5WvqOxbV8njT8TEiO7n90Qhe+iDj2d6X3JXpaZDIyFg+Bp8JwSh6rXSDFS9KnXq
	 jLMus8gwt3p8fsRSKVEQ+lGBUvf8FtCWTCxuKalCJSbIcEqqZr3ozq5EhIuhw4KF0z
	 FY2bbJcNMy4eQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 0B4753808200;
	Wed,  4 Feb 2026 18:49:24 +0000 (UTC)
Subject: Re: [GIT PULL] Final KVM changes for Linux 6.19
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260204175509.163280-1-pbonzini@redhat.com>
References: <20260204175509.163280-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260204175509.163280-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 0de4a0eec25b9171f2a2abb1a820e125e6797770
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 27db1ae6ecdf23f4176276da6037eaafbd23bf94
Message-Id: <177023096266.20076.8450701601882633761.pr-tracker-bot@kernel.org>
Date: Wed, 04 Feb 2026 18:49:22 +0000
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_FROM(0.00)[bounces-70262-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: DAA28EBC2A
X-Rspamd-Action: no action

The pull request you sent on Wed,  4 Feb 2026 18:55:09 +0100:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/27db1ae6ecdf23f4176276da6037eaafbd23bf94

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

