Return-Path: <kvm+bounces-62364-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 18574C41C4C
	for <lists+kvm@lfdr.de>; Fri, 07 Nov 2025 22:22:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B73213A3181
	for <lists+kvm@lfdr.de>; Fri,  7 Nov 2025 21:22:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C7812F25E1;
	Fri,  7 Nov 2025 21:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="owzssi+0"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FCF22EE5FE;
	Fri,  7 Nov 2025 21:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762550534; cv=none; b=C9gvhCT8G6R8+Sz1K9uyJ9e/78M0fh0fGm3NriZvGIw8ZDKswnwT/iXw8lvO8vEJETsO3o2ZliS47xWERCBZXjQJiw3FySCfOGoTDbuEBDdgRmplASdkA9UArZNH/yX9LCHWMaiXc3+GbAwdVbl0/OGtbZsPbZoiPYj+AieCRuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762550534; c=relaxed/simple;
	bh=dd4QqlJ4brPXoktjduhMsX0SIxj6nQ3i8Pug2ye50tk=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=azptsGyadjQieGFRLJFVlVHbRWogI9pSH+kVUPdud4N0GKIZx/f6UrAQgtt2WHyW3AF8TbC0zKXzjfKhm8ySLWWBoGkFEkIIpDp95BA7rhUKXqVW5ilVZItry34UJFee5pzgh32u9eomYJx0NNQE2PsQ1pIDLBtnjyvIRanp5hA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=owzssi+0; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2C51C4CEF7;
	Fri,  7 Nov 2025 21:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762550533;
	bh=dd4QqlJ4brPXoktjduhMsX0SIxj6nQ3i8Pug2ye50tk=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=owzssi+06JWtJbz/8pLfqBcnOQBw2MPBCgPIw4VNBvxNZf6OKUCD3rBDugK3MIJRH
	 URDImIRCXz/ppauv73L8D7pgBfR768ta70zLZLTHUXc0diuNZOlbDKt/nXALkszk6Q
	 Sx1X/YdTqcTSDbdvF0o5HItQxQw6+rA2qCRuki7jpa6eISPDivXHocMe63PLYLdaF+
	 5ZemH61R2RiL64N2FwHYLKbBAe+iB06A/GhGP75heq8u4I1evwOSyJuilRPJoa8v/l
	 hHhTqS0f4qpDOARkRZLXeh5fiUbIIVcC/Ajpj+Mr+7BFpabgo9n+pUY/UqnUjVM4ZB
	 usXKL9vMkakNQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33E5F3A40FC8;
	Fri,  7 Nov 2025 21:21:47 +0000 (UTC)
Subject: Re: [GIT PULL] Please pull IOMMUFD subsystem changes
From: pr-tracker-bot@kernel.org
In-Reply-To: <20251107185139.GA1981854@nvidia.com>
References: <20251107185139.GA1981854@nvidia.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20251107185139.GA1981854@nvidia.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd
X-PR-Tracked-Commit-Id: afb47765f9235181fddc61c8633b5a8cfae29fd2
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a2e33fb92649f4efcc9e81c1d1a1905ca2a76d03
Message-Id: <176255050571.1164216.5840804120672902852.pr-tracker-bot@kernel.org>
Date: Fri, 07 Nov 2025 21:21:45 +0000
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, iommu@lists.linux.dev, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 7 Nov 2025 14:51:39 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a2e33fb92649f4efcc9e81c1d1a1905ca2a76d03

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

