Return-Path: <kvm+bounces-36578-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E68CA1BDFF
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 22:45:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7C6FE188D026
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 21:45:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0D641E98F8;
	Fri, 24 Jan 2025 21:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ow6mVkB1"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14CF01DDC2F;
	Fri, 24 Jan 2025 21:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737755102; cv=none; b=WOq5dDIUnF5xE7WC+Z0O6WTVlRF3u7hEyqJQi6NLYUNsYSULh76dx8RCh7QzDn+4cA1lfrOlzGfUjTkaQlrMEl9lsX0cR8RG/t08ZVw0t2iDG9ga2J2BkW4UhxusEghKNQIIvd41ddJ1S5388VdOMM8TGEQSNpw3jJFLcuA/ekU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737755102; c=relaxed/simple;
	bh=VXxBIvMTCwYLnSWzYh83inBm3PkB3WB+t4egyeHzFOk=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Q4BImvdGTJbmcP7KEB6MOxVVKcLcVyl2adEu2C/4Aw2qMongEEUcLkqDlB3Af0AsiTBFQFf6ji2B4hUMCO8NiIQfgqKKNbKbSEy/JL4Nzx3AIWHUC+V1FGEc5Pr0R+d1qOWAJSnQL7Qjt+nQTYy0Il8qzmdDmcj9Gq9jkskhCiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ow6mVkB1; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F4D0C4CED2;
	Fri, 24 Jan 2025 21:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737755101;
	bh=VXxBIvMTCwYLnSWzYh83inBm3PkB3WB+t4egyeHzFOk=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=Ow6mVkB10F52LTolSviSuYr5sLZUEUJyHehx81LYtEv0iJPE78YcVnoqsP8i75c1t
	 Egus6KkjC1/c0xlmk5lzmMI5oLQY1VJhbY2LyUCvqVwPYxuwqZSD8kcjz6VEoodJok
	 YpS7kVtbLW167SpZdcZdwyIi62UK6iFNhCK6aiF2Bf+so6y0MRxaUp+47QJzOH9i8d
	 I/1K0HF73Rr95/j3PS5spbVZddqAo8wUXn9w6XkOHeMTmtUEXQ5iHkBcL9Gp4QqhYv
	 og8yWIQ1YOkZtZAdkaV5HDDJUEB8RvGOS4SsJSSCtfnwHNZJ+rue7aWfyY1ISv4RYr
	 r0OkRudA1V2rA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id AE039380AA79;
	Fri, 24 Jan 2025 21:45:27 +0000 (UTC)
Subject: Re: [GIT PULL] Please pull IOMMUFD subsystem changes
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250123165923.GA1053196@nvidia.com>
References: <20250123165923.GA1053196@nvidia.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250123165923.GA1053196@nvidia.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd
X-PR-Tracked-Commit-Id: e721f619e3ec9bae08bf419c3944cf1e6966c821
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: aa44198a6cf599837350aa954b5153b75feaed2d
Message-Id: <173775512613.2173506.15913161180289238858.pr-tracker-bot@kernel.org>
Date: Fri, 24 Jan 2025 21:45:26 +0000
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, iommu@lists.linux.dev, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 23 Jan 2025 12:59:23 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/aa44198a6cf599837350aa954b5153b75feaed2d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

