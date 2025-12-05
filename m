Return-Path: <kvm+bounces-65307-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id A0A0CCA5F44
	for <lists+kvm@lfdr.de>; Fri, 05 Dec 2025 04:04:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 16EE130472EE
	for <lists+kvm@lfdr.de>; Fri,  5 Dec 2025 03:04:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EEBE2E6CA5;
	Fri,  5 Dec 2025 03:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e2sp4tge"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E47D18D658;
	Fri,  5 Dec 2025 03:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764903855; cv=none; b=puUOyQYoPvR6tox0T7BWlhEPg2+9wwLooRgZxYxIUTfsDKlvwrvhQ2rlG6Ss56XgcqlCUwQ9f+B9aVcmnqrS5c3pvkVFOqMZy+KVZqvG2RpT9MVSs22x4sP03TPk5/3f/VcjZM+ZNFKbf6dEy8B+GbThF5u3xDqneOWLA45UPo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764903855; c=relaxed/simple;
	bh=/JQhc3V/qRD89UuPy9qhr18vhsDsM0Qv0lDC34gPhfA=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=MxF5zuq0gERheM5iTc/OWpCkMr5VikUvtCZ8Qx1xIYPT/lMMsfZuTeNxOnP0ZC2cRIh0weQK9bYh6EIym/yEu+AUkEmUDSVHDXBf2Mf/xmhLqUh+w83KcUddRaFBWD2DHR0HuydKF0XheIL/5ujnHp14fx3GKKTQ4pmRvcqNV5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e2sp4tge; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C6C6C4CEFB;
	Fri,  5 Dec 2025 03:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764903855;
	bh=/JQhc3V/qRD89UuPy9qhr18vhsDsM0Qv0lDC34gPhfA=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=e2sp4tgeeJSkYr5EtF9YWosF6pstypUhquLr0xATJAoeMJypK13d62wtPyE/BuuF2
	 bZaSzllReiPlqMfZZmouqsVIvKWlVpN1cL4vRQwzLDXi3xmuxYrKGhl8eAIoHvCDcu
	 zmzzh73fg+2vjcuhHvW/xc3Dt5ikfOOnftACx5gd1w6pSUNtf5TQA6fGXV8ADClTSG
	 NAW3lqtVtP9ZVI4qsNh5OMz9eGo/AYL2vkEFI0NzbiY2PgylwHiZHugcS6u5oKtYsi
	 5Exje65zuax5F9jfiUdULVcy6LI15e57oknLU5rpo5aRXyU1E2CMm3JSAeZgnQB/tc
	 IOkM0rBuyRj3Q==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 78B043AA9A89;
	Fri,  5 Dec 2025 03:01:14 +0000 (UTC)
Subject: Re: [GIT PULL] virtio,vhost: fixes, cleanups
From: pr-tracker-bot@kernel.org
In-Reply-To: <20251202150721-mutt-send-email-mst@kernel.org>
References: <20251202150721-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <virtualization.lists.linux.dev>
X-PR-Tracked-Message-Id: <20251202150721-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: 205dd7a5d6ad6f4c8e8fcd3c3b95a7c0e7067fee
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: bc69ed975203c3ffe34f873531f3052914d4e497
Message-Id: <176490367301.1073302.8927903391156784773.pr-tracker-bot@kernel.org>
Date: Fri, 05 Dec 2025 03:01:13 +0000
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, alex.williamson@redhat.com, alok.a.tiwari@oracle.com, jasowang@redhat.com, kriish.sharma2006@gmail.com, linmq006@gmail.com, marco.crivellari@suse.com, michael.christie@oracle.com, mst@redhat.com, pabeni@redhat.com, stable@vger.kernel.org, yishaih@nvidia.com
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Tue, 2 Dec 2025 15:07:21 -0500:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/bc69ed975203c3ffe34f873531f3052914d4e497

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

