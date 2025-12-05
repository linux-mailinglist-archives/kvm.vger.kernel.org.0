Return-Path: <kvm+bounces-65309-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C73CCA5F86
	for <lists+kvm@lfdr.de>; Fri, 05 Dec 2025 04:13:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B312831DE4F5
	for <lists+kvm@lfdr.de>; Fri,  5 Dec 2025 03:12:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A93682F39AD;
	Fri,  5 Dec 2025 03:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CiGOxBsz"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE3902F2900;
	Fri,  5 Dec 2025 03:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764903880; cv=none; b=oV/ggHxxm8fYRv71T1yMn/cliW6aIIg3WDYFXXUOsmPBi7fA5RUk+GjEvE1PD+0d4Zth4E9G6HmGrdYlbbaH5eyYZiS6pMTVYs9U64WkbxBvEOhAB/KxZbi4oZp1XRKJDay6ib+HwpcEWXsGqM6i0GP9gOSbjmOGmabmrmXtPhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764903880; c=relaxed/simple;
	bh=1/rTJeJ4I+6N5sfWCdWxYO5vN605zgqJ/g5N1OSZ1Js=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=VbdKoPb7oGyEr1d2vuZxBmooGOZUiwoZbfKz3ol2ZalRNrxifHfITcr4KFPOAyoSlwdsEiP8qITrKvoWREkYdE7ptjzwAKvA7vM/Wyji9QvDuJP4jiSEQXibig1azhcrRPNeoWqep2oa+e8Kg1AkMRx2sY7T5DAkFna2LDM5N2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CiGOxBsz; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CC70C4CEFB;
	Fri,  5 Dec 2025 03:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764903880;
	bh=1/rTJeJ4I+6N5sfWCdWxYO5vN605zgqJ/g5N1OSZ1Js=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=CiGOxBszLiuwUsB5kaOKss+JO+O24XrL7WiZLXvlbBxNGxbp4NofwmYu/hNHyzCCA
	 9WAIE53tX3ou16kSnNHfuYS/6/UYgqjPviBsJT+l5QxAdcXJW+qHVJqhRaDpD48aXE
	 0CNXgnMEdBc1yoHkb0sN1IKWvTUHPHt1rkEaivH+8C/cBuff6wMc+AUJGxBBr0TMdH
	 +3/KDQoDT4AFxDzBMxjsacuBdkgCpNE7V4Vj5ijrScwzaY8lZCZSTxOiAa6fDlQ6VW
	 HgTZsvaPlVQBeC2GKLl9KnXvBjXzm2PNCRacNryr5Zu2sO7so9FjcyO7HtlCqGIboU
	 5ueX9VJ9ps8JQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B57593AA9A89;
	Fri,  5 Dec 2025 03:01:39 +0000 (UTC)
Subject: Re: [GIT PULL] VFIO updates for v6.19-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20251203130435.4ab658aa.alex@shazbot.org>
References: <20251203130435.4ab658aa.alex@shazbot.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20251203130435.4ab658aa.alex@shazbot.org>
X-PR-Tracked-Remote: https://github.com/awilliam/linux-vfio.git tags/vfio-v6.19-rc1
X-PR-Tracked-Commit-Id: d721f52e31553a848e0e9947ca15a49c5674aef3
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a3ebb59eee2e558e8f8f27fc3f75cd367f17cd8e
Message-Id: <176490369821.1073302.4503886015231113392.pr-tracker-bot@kernel.org>
Date: Fri, 05 Dec 2025 03:01:38 +0000
To: Alex Williamson <alex@shazbot.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Jason Gunthorpe <jgg@nvidia.com>, Leon Romanovsky <leon@kernel.org>, Ankit Agrawal <ankita@nvidia.com>, David Matlack <dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 3 Dec 2025 13:04:35 -0700:

> https://github.com/awilliam/linux-vfio.git tags/vfio-v6.19-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a3ebb59eee2e558e8f8f27fc3f75cd367f17cd8e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

