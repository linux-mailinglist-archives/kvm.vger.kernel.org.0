Return-Path: <kvm+bounces-72231-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UPp7JeEQomkmywQAu9opvQ
	(envelope-from <kvm+bounces-72231-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 22:47:13 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BFA0A1BE465
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 22:47:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 9D7973001A56
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 21:46:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A420472791;
	Fri, 27 Feb 2026 21:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bKfXHw78"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC3123644C9;
	Fri, 27 Feb 2026 21:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772228811; cv=none; b=rkDxens3ryG4A5NpHm4U+Y3E7q8J2IGBLihOQVtXP0W7oz2m55Hbc6sGJtT7N+b/mbu2pj+eB4jnP5oVg5UMW0ctwzNp+RAceSOEdKtf6qXyhYhggWKrNKCQe0VM3GTpoFqZNtOD1+Vw42a8ug+//0HxwViMlXBvwjABh2Z6izo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772228811; c=relaxed/simple;
	bh=bfFqfg34JQ70oKrrmSHJMW1lQghTvl7YQD/EXhTg5Ao=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=fZzzHNjSXbt4XjY+7R5uWVnT1gQjxJRdn3y7Y3r/xxsDq1KyTjIRzlGT7b9Rw3Y2iBgj5oqyk5By58pDSdAFeyDWI+4nQUJmsuzdN6ad+pTSXk8/0MFe3AeYsgAEZamQ8/a3lq9vozJxTMU8cuk+dHj/UpiRIsVUrDntBuYgar0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bKfXHw78; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EDB8C116C6;
	Fri, 27 Feb 2026 21:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772228811;
	bh=bfFqfg34JQ70oKrrmSHJMW1lQghTvl7YQD/EXhTg5Ao=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=bKfXHw781Yqs+cfxkGwre/AFKhoEOAnOqcCk0mFJ5DgBeFqhs7sQv7euoryHUlSOb
	 w0Md1KhUdHozHv9AaYW0leuDNj2pXJGbVHq9ALCAmk8ykR2IJWxCNPGkSL5ge+ZcVf
	 ccQeFv3/1l/AXg9qaWSBShgx2lpxxQJn/y6XFL2cqBUbD9xllgwwhc3esVT7txw4Sx
	 0g5bVwLM79NBZw8jKDBAjrBPAOJBYgLEI0Awj/JVoawNPaH4RbBE970gT9Evdat09t
	 kmm0mWqCSP3FdJ9zE5LnaoLPxgXn4IJtd87BRmAaa4SRxZzdNwJmQV71CcOTO5oLcy
	 AUdVqVfMch4yg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7D06F39E961E;
	Fri, 27 Feb 2026 21:46:56 +0000 (UTC)
Subject: Re: [GIT PULL] PCI fixes for v7.0
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260227200859.GA3913790@bhelgaas>
References: <20260227200859.GA3913790@bhelgaas>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260227200859.GA3913790@bhelgaas>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/pci/pci.git tags/pci-v7.0-fixes-2
X-PR-Tracked-Commit-Id: 39195990e4c093c9eecf88f29811c6de29265214
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 1c63df24be5f06f61b94e63cbe01aa852e463438
Message-Id: <177222881540.2772866.14710365594855540486.pr-tracker-bot@kernel.org>
Date: Fri, 27 Feb 2026 21:46:55 +0000
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kwilczynski@kernel.org>, Manivannan Sadhasivam <mani@kernel.org>, David Woodhouse <dwmw2@infradead.org>, Baruch Siach <baruch@tkos.co.il>, Alex Williamson <alex@shazbot.org>, Niklas Cassel <cassel@kernel.org>, Frank Li <Frank.Li@nxp.com>, Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Koichiro Den <den@valinux.co.jp>, Shawn Guo <shawnguo@kernel.org>, kvm@vger.kernel.org
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[16];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72231-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
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
X-Rspamd-Queue-Id: BFA0A1BE465
X-Rspamd-Action: no action

The pull request you sent on Fri, 27 Feb 2026 14:08:59 -0600:

> git://git.kernel.org/pub/scm/linux/kernel/git/pci/pci.git tags/pci-v7.0-fixes-2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/1c63df24be5f06f61b94e63cbe01aa852e463438

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

