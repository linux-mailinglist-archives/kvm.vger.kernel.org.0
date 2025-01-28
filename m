Return-Path: <kvm+bounces-36714-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EC90A202D5
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 02:07:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 84D537A386D
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 01:06:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA98A433A6;
	Tue, 28 Jan 2025 01:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n1LISSgy"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 022DF2905;
	Tue, 28 Jan 2025 01:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738026410; cv=none; b=C2SYdkqKqS0Eod6fScZdeB/3D1uPXwQ1Bmb9eoomtxK+9JuB2BaJvAmKeySkl7IkvbfFGIg32Bs+6SZDXbRD+fbgRv3oI7y1J4oczsEmvzhFnadkq56+zsUHKtKvdaNjYRZ6o9JrVcgQhf1XmmWhAf+XwswC125osdcNuGyPUXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738026410; c=relaxed/simple;
	bh=g2QvMiT5LUVcP9OrA0RXuReUPgCnilj54mqxus/bMCI=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=ihsMJASbNF8mgMdTvqVQd02Silw7y+RTfug2UJuSIenK2qvppEuzmAnkIclgv2bkfnMmZnah6JucyqGAAaEmWfU8zglijwlNZXboTllIEu2z6XCUzIQQDJ7i+7kRhYOGqd5k3BnRv60YMBgGPRY4NZlkgdEIqyxzZQmmMPn/cCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n1LISSgy; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE052C4CED2;
	Tue, 28 Jan 2025 01:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738026409;
	bh=g2QvMiT5LUVcP9OrA0RXuReUPgCnilj54mqxus/bMCI=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=n1LISSgyLEpO/HQUoAZHZSjx3otHAyJjrw0qLjl/TKvV+YHKGmtIrJG9n0FAVTt1N
	 cMoKIn9/z4bTjFm9puxzImMC7gWXbto2O6PceHR7vQj9Hed/RO4CBlsMffKRwsck73
	 XyWG5TGoKHiUlgB8VPDKAE4yx8HNSr/zqtebigiZx1xzbnDncZOmacwHMJjL46kdVf
	 DhatUM+kOLMr+qIGRxgsjmhzlG6zxCPLsalMoi5syfsw2+DQWyUk4H4hi8uC6G35na
	 UL6O6oZT//TgpVIW10vqvlAA2F6rGulb0JhbKydFSAlQ10ytrZFur661THvdrvFdqc
	 Dw2mqeanivqbw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id AE02B380AA63;
	Tue, 28 Jan 2025 01:07:16 +0000 (UTC)
Subject: Re: [GIT PULL] virtio: features, fixes, cleanups
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250127095138-mutt-send-email-mst@kernel.org>
References: <20250127095138-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <virtualization.lists.linux.dev>
X-PR-Tracked-Message-Id: <20250127095138-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: 5820a3b08987951e3e4a89fca8ab6e1448f672e1
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: deee7487f5d495d0d9e5ab40d866d69ad524c46a
Message-Id: <173802643525.3281647.14447011836115468769.pr-tracker-bot@kernel.org>
Date: Tue, 28 Jan 2025 01:07:15 +0000
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, akihiko.odaki@daynix.com, akpm@linux-foundation.org, bhe@redhat.com, david@redhat.com, israelr@nvidia.com, jasowang@redhat.com, mst@redhat.com, pstanner@redhat.com, sgarzare@redhat.com, skoteshwar@marvell.com, sthotton@marvell.com, xieyongji@bytedance.com, yuxue.liu@jaguarmicro.com, zhangjiao2@cmss.chinamobile.com
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 27 Jan 2025 09:51:38 -0500:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/deee7487f5d495d0d9e5ab40d866d69ad524c46a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

