Return-Path: <kvm+bounces-27386-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6031B984BA5
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 21:36:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 915691C23296
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 19:36:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC7C513B2BB;
	Tue, 24 Sep 2024 19:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bqiHtIHb"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 803B2136E30;
	Tue, 24 Sep 2024 19:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727206567; cv=none; b=Gi0IRWfbHovWDtFHbPRvLZq+rYuNPxcEWd+Rmwuh7KZZt+1WxuSULVwJkK4OuA3bRTLhWFCrlrRVfe86+sGb8R0++aKcLoXQ1dZgD4OUyBS5YTMYFBSeLd25tRUs1vhnilJiqEO9zCLW2ALe23FS67tY1g/3m97EmqpCxr8MUpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727206567; c=relaxed/simple;
	bh=QVzu4tSaJYMgEP5xkExJzhqs2kGSqAkfmVJyR33Alew=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=sGFU94rKK/3on/y8NQJR1nXLaNUp96PiaW6DVeVJXp/UB9ycQVesKuV0KMsIukkXuuYxhVkdBwcxcBmLRcVp+MpCFp0cykTmoRUwSA5fqi2ZuqNrN2AqTOHmr8ITaeKYszYSf4m/a3t8qsEXlwqMUm5EEFO0s0iivAcrvQUkKyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bqiHtIHb; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A26AC4CEC4;
	Tue, 24 Sep 2024 19:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727206567;
	bh=QVzu4tSaJYMgEP5xkExJzhqs2kGSqAkfmVJyR33Alew=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=bqiHtIHbJsEf+5VJ7XYQXOsP0UwTA1ZC9vyID+BLUJl6NBOEm+L7Mt381pUHDnY+w
	 9lyhzgXa9ykfWAvpx222dfp4KURj/1dV2CzVhjg6H7pHVq3YeoImNnp8dtivb/9Oq9
	 /zsgLxfABK/9QaSWJ3KbR2B5Kx9IOcNV1bRanIbDIZ/gmsx4nqJNM7lyb20k7kiYJU
	 NXWA15JAPzklpwvw6HGHGBQr4G94ImmFcD2fTkeURDch6r5Ol8MNQQfDDmGwO0rEPy
	 2JSm65HTzJPKivf9Df89gN5Ih+jpvYvl8tApukDeVDNdWYzQe9a9D4kaxefsq3UcJN
	 2ZVHJP4sKbF2g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EB5353806656;
	Tue, 24 Sep 2024 19:36:10 +0000 (UTC)
Subject: Re: [GIT PULL] Please pull IOMMUFD subsystem changes
From: pr-tracker-bot@kernel.org
In-Reply-To: <20240923174535.GA77474@nvidia.com>
References: <20240923174535.GA77474@nvidia.com>
X-PR-Tracked-List-Id: <iommu.lists.linux.dev>
X-PR-Tracked-Message-Id: <20240923174535.GA77474@nvidia.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd
X-PR-Tracked-Commit-Id: 79805c1bbbf9846fe91c16933d64614cbbff1dee
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: db78436bed06708a8cadb61c60881d568fb4ae27
Message-Id: <172720656965.4172315.17252943873000541412.pr-tracker-bot@kernel.org>
Date: Tue, 24 Sep 2024 19:36:09 +0000
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, iommu@lists.linux.dev, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 23 Sep 2024 14:45:35 -0300:

> git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/db78436bed06708a8cadb61c60881d568fb4ae27

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

