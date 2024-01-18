Return-Path: <kvm+bounces-6454-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C29AD832252
	for <lists+kvm@lfdr.de>; Fri, 19 Jan 2024 00:36:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 46BFAB2210B
	for <lists+kvm@lfdr.de>; Thu, 18 Jan 2024 23:36:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6C2928E03;
	Thu, 18 Jan 2024 23:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aPE+TvdR"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA1681E4BD;
	Thu, 18 Jan 2024 23:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705620943; cv=none; b=oVX4jJ3aKfE/BHIiJSj9OC+858GrOVSrjDgD5X4IGr6kVD43ljQ1w7Sw79cniRxaHHFkLBFCHs6sWnlbrd/5urtOoBxp1kD+A2uJTxXQT9PvvpsE9ybM9XoWNXFQexA/Rj2uFlN6WDcsjxLECiAjTdjB8WUKJ1EP6MItEaEvtOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705620943; c=relaxed/simple;
	bh=wFRSluolQH99ztHRxbO31KKEpcLA/48Rhskk4mHCbpM=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=KH/o11RMBBu/6fMA/fJcMWAVUz+sbytuX2yd6eGhsZjse/Zc5iSjaCfXx/xLAl8qPoD1WBH52LK6sfUgmeMJ8c4lhh0jpI++VcukU6zi/ePAAKw2HzREh4gimIWTfYEW/eVqfA//l4+fEZwfzfArGxf5nv9kcV4/AhvkQ74ujWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aPE+TvdR; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id A260CC43390;
	Thu, 18 Jan 2024 23:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705620943;
	bh=wFRSluolQH99ztHRxbO31KKEpcLA/48Rhskk4mHCbpM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=aPE+TvdRQNJIL5ehb6u/heMLqXAAt2lOZtfwIj1srKTiK49o+gqrR+PjLfE3VC2Ya
	 7gM+Xy1sYOeMM2HS/+/Ln+9HrQUWRFPejaX+XM1F0gL9srTVfUWvLUEx3lRB3S+GQK
	 ejavQ+CvBMm6wvhes+vaerpcLLhjtIlaTTupsalDnqgQ82oLn1GtCwJXiacO2HVDDX
	 qfmwX1tGROCdOkV/NUkW3e6QeqAJfi/dXrzwMb3e3zv9B6jpKWeFyj95qN3BdXH4CY
	 G5uqA+3eR8j2K/eB8vIJWXZCSCmkUYS74Og+DI4Q1CFRMQ/gf1iIBefFj2Gt8+pBMn
	 AqAPxra8NtJ2g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9216DD8C970;
	Thu, 18 Jan 2024 23:35:43 +0000 (UTC)
Subject: Re: [GIT PULL] Please pull IOMMUFD subsystem changes
From: pr-tracker-bot@kernel.org
In-Reply-To: <20240112174928.GA828978@nvidia.com>
References: <20240112174928.GA828978@nvidia.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20240112174928.GA828978@nvidia.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd
X-PR-Tracked-Commit-Id: 47f2bd2ff382e5fe766b1322e354558a8da4a470
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 86c4d58a99ab1ccfa03860d4dead157be51eb2b6
Message-Id: <170562094359.32628.11758373488382686307.pr-tracker-bot@kernel.org>
Date: Thu, 18 Jan 2024 23:35:43 +0000
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, iommu@lists.linux.dev, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 12 Jan 2024 13:49:28 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/86c4d58a99ab1ccfa03860d4dead157be51eb2b6

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

