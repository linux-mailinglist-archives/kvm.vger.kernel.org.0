Return-Path: <kvm+bounces-10698-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8333D86EDE1
	for <lists+kvm@lfdr.de>; Sat,  2 Mar 2024 02:31:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 13478B24709
	for <lists+kvm@lfdr.de>; Sat,  2 Mar 2024 01:31:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FA72101F7;
	Sat,  2 Mar 2024 01:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jNuVKAWx"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F13E8C04;
	Sat,  2 Mar 2024 01:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709343085; cv=none; b=UkZJyUAwf6et+hM4bEwtdcKXN+zDAYZ3t/X5dBM4yX0KYJnLfXuPyhzW+vzQNsl83VqWQ8I8FT8f9dOmu7+tbkqKUYc4K076ukkWRcgWhFDWHXmL+Kbu9e9hdpDOGnZud7RC6MnfGf8XhLeu2laM4fdGJ2FClAr/naRmvohRp3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709343085; c=relaxed/simple;
	bh=V9wN941yxIWLzFym7oX+c5t3roYu7Zr1N4koZtJwmyo=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=t74vkz0FnLjkGMDA/cSIdDKlgurj7fpFpeGGFzLNE5no6nVFYVby4QKejOYEBJUYJGRsVxyEeU6z8bREr0nTlqh/WZG/pDt5TxpzA3cn+UR0mCBg54+ExI2lbV+pLo/j17Qot0z74eq5VINKEwqnIEUNyPAMTK/H7J1N9Cg7Byg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jNuVKAWx; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 07599C43390;
	Sat,  2 Mar 2024 01:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709343085;
	bh=V9wN941yxIWLzFym7oX+c5t3roYu7Zr1N4koZtJwmyo=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=jNuVKAWxZrC/XX2ZCGYSwJSQWaOQ7yd+05ttoWApHm32Eue4Od65/h5wdn9gs34SH
	 bniOfPhO6icDZk1NWHmyc32pN1Khk1+gWjM5biALLQ+uT7Gm8dnyKJaNNUCJAsXWE5
	 raOxJPIP5xGEwbbIgZpsIqmyn0/mpE/eA+pDgZQYI922+XcA5hwwR+qplAbUq5T1uD
	 TsNcdPutiVSDst9wNfDhwXFwbs8Q1unZH8oFvBkqmFiR152lzUMtIJGPAg/ELak4Vo
	 DATIpo4FJQnxS2UvInXTMSxXzBAZbstGNEALmDioIVOKaYHuBbQznMxlzK/qkui2wH
	 XTl5qxXa6JKuA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E4CA2D8C9B0;
	Sat,  2 Mar 2024 01:31:24 +0000 (UTC)
Subject: Re: [GIT PULL] Please pull IOMMUFD subsystem changes
From: pr-tracker-bot@kernel.org
In-Reply-To: <20240302000829.GA749229@nvidia.com>
References: <20240302000829.GA749229@nvidia.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20240302000829.GA749229@nvidia.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd
X-PR-Tracked-Commit-Id: bb04d13353885f81c87879b2deb296bd2adb6cab
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e613c90ddabcef5134ec4daa23b319ad7c99b94b
Message-Id: <170934308493.29596.8762206635856811258.pr-tracker-bot@kernel.org>
Date: Sat, 02 Mar 2024 01:31:24 +0000
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, iommu@lists.linux.dev, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 1 Mar 2024 20:08:29 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e613c90ddabcef5134ec4daa23b319ad7c99b94b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

