Return-Path: <kvm+bounces-55561-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D2C8FB3249E
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 23:34:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 433A51D65318
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 21:32:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A4C5342CA7;
	Fri, 22 Aug 2025 21:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WGVVpaVD"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F963334393;
	Fri, 22 Aug 2025 21:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755898117; cv=none; b=VBeOrp41lTwUak/TuDaxfl5wi8uU189e+7sgCN25v5S8wx/gLB30bU7YYsY+FO1LmU6o5cQW5r7ldVFAUgWf88a+Fop09e0+MIwQ0IAZ9PWawpYPXMVOw6k/nUHPyLJaQuypyl5To9hFufDoUFls57vmlK1tyRYsYlnFVw4wtGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755898117; c=relaxed/simple;
	bh=m2FGZbQGjF9BGlxPc9v4UN3eSSOl7EKIl3avYXKqa8Q=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=mNj6oKdTMl9IJLxS/tofDC4DIQYb8KIXuHfuJ2pNWRsxwT9RlNBs+ZMw9bOEMJGtfGU+ppQaPX3NgsiSAoHT8bfOOydU6dfvs+M2m5th5gYVI7yTA0O32ZdyInSZOKIN8cpef5XbeIG6JTXQb1lfiwY1E7Y4qb1iCY8W1weUcng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WGVVpaVD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16750C4CEED;
	Fri, 22 Aug 2025 21:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755898117;
	bh=m2FGZbQGjF9BGlxPc9v4UN3eSSOl7EKIl3avYXKqa8Q=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=WGVVpaVDeZJqFLNyJiiG+R+F0DAmGytDWQ1R4KCnBfkqjFUOnIwuO6u6B1ZIqkB3t
	 bJUGAG01WAzxNM3X6Mc4Sd7TtTtGGNwCPxc60i2bEXW9rkfDmSQEzirDcjO6UU7D0w
	 w1Dm9TthLlxFQpmxh5GpkMzTMlDXz727Hqxdxph8S76ZBez+srZ7J9/c5C14WfGUIl
	 J6rZ1TXTWb1cpgS0+J2bU61aKBzQhcjOJH1BF+OcJVEdSChWpZLqqtcV/n5BtMriUm
	 9B9rRRZFr6J0TgDqRBabOUuFhZnAcnY3R3FzZBViCjgyLcHgPZnpsLApgYIKAbRVdb
	 wt8HLgPy5wbHA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 340B3383BF69;
	Fri, 22 Aug 2025 21:28:47 +0000 (UTC)
Subject: Re: [GIT PULL] Please pull IOMMUFD subsystem changes
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250822142147.GA1404783@nvidia.com>
References: <20250822142147.GA1404783@nvidia.com>
X-PR-Tracked-List-Id: <iommu.lists.linux.dev>
X-PR-Tracked-Message-Id: <20250822142147.GA1404783@nvidia.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd
X-PR-Tracked-Commit-Id: 447c6141e8ea68ef4e56c55144fd18f43e6c8dca
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 471b25a2fcbb25dccd7c9bece30313f2440a554e
Message-Id: <175589812570.2007126.4430947425513981391.pr-tracker-bot@kernel.org>
Date: Fri, 22 Aug 2025 21:28:45 +0000
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, iommu@lists.linux.dev, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 22 Aug 2025 11:21:47 -0300:

> git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/471b25a2fcbb25dccd7c9bece30313f2440a554e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

