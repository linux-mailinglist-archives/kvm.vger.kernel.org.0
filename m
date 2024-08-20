Return-Path: <kvm+bounces-24673-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A19895915D
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 01:52:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 544A32843F8
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 23:52:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E91E11C8FB0;
	Tue, 20 Aug 2024 23:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uoCi1XJe"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E8618E351;
	Tue, 20 Aug 2024 23:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724197944; cv=none; b=BV48g+wsYjCzSMc/wGiAX77CPmQqoFqb0Qmn/q0Tx3GeEnor8iqj188gJampn2BmhPP6D2clB3IwkHl77Su4Dq7L7hJpV9PHOWKCg32Hz+WgF8EZdQ9Okf3+FWj2JKLW/NklkSyrPVzX3HYinQHHRleaSAqyLRWNeyhV/YCd/wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724197944; c=relaxed/simple;
	bh=QrAFz6/On8von0ohcwI3J6cKXBt4YkE9R96SuhbDEFU=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=QrBNqkz4BkJXXjtJXrFqkw5bIXj53D+REBpZRLvAbc08jrIw6p3yz9P2EmcErZ9GxT7bcYxOuaeYwx2yg7gunf+/0hDJIzZgAGfJE5RkZxfnOU9qzq4LjbWN1ZQmg2977eyhVI038g6RaB2NRUZKlLK+ntZjBbX6KXYOeRTMDxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uoCi1XJe; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB032C4AF0B;
	Tue, 20 Aug 2024 23:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724197944;
	bh=QrAFz6/On8von0ohcwI3J6cKXBt4YkE9R96SuhbDEFU=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=uoCi1XJe+BbKKO+9xA2bEIOZsndzBnRgVs5kN5XJzAjPXl3mvCBKJw1zPyj3Zd2eJ
	 limsmyqgkPfOlukvTGtR7VbS6iKIfrA7xK9FVvFO/Ka3dnn1q1e7acbbMhl5qc7KlU
	 Gx/LcEH5BrG1OziB9b9R2xfQefS/jJYYehXEY2WYAUs/SBKFNedB/xoIIWGTvla0Jd
	 1puA2ZsBoqqQYiTCM0oNL6UpNPgTf8vKBvzUETrzNqWrPI/2WO5KuxtP+ooNE8gjeh
	 ARWzTOJMYu2GhjmU0BrSNh74Mo2JbHAtbAbqVuYMAOvgvk1DKNRZV/YhUVcAd5RMZS
	 BK/2rRNWzZrAg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id AF4433804CB5;
	Tue, 20 Aug 2024 23:52:24 +0000 (UTC)
Subject: Re: [GIT PULL] Please pull IOMMUFD subsystem changes
From: pr-tracker-bot@kernel.org
In-Reply-To: <20240820224837.GA1570264@nvidia.com>
References: <20240820224837.GA1570264@nvidia.com>
X-PR-Tracked-List-Id: <iommu.lists.linux.dev>
X-PR-Tracked-Message-Id: <20240820224837.GA1570264@nvidia.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd
X-PR-Tracked-Commit-Id: cf1e515c9a40caa8bddb920970d3257bb01c1421
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0108b7be2a18d85face1e10c68ecc0138f1bed58
Message-Id: <172419794311.1273793.8742959991162677899.pr-tracker-bot@kernel.org>
Date: Tue, 20 Aug 2024 23:52:23 +0000
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, iommu@lists.linux.dev, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Tue, 20 Aug 2024 19:48:37 -0300:

> git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0108b7be2a18d85face1e10c68ecc0138f1bed58

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

