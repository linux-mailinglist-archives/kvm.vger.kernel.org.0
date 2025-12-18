Return-Path: <kvm+bounces-66282-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 85461CCD9AC
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 21:57:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 36D87304FBB0
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 20:52:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D89233DEEC;
	Thu, 18 Dec 2025 20:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W5E5lJyz"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C88862E7179;
	Thu, 18 Dec 2025 20:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766090581; cv=none; b=RhzA5J02UjzDqCt+SCIdR9abAzcv2i8AKrLhwxDaievHko7haL8uGMrS+GcAsTfy2RA4/FyLYDDloD+tHQR1W8i4mJkdHMlOrP1nVxzrnE6+7sq8fjNqiPFlQNWfxtdplevkzKPyPHGJ8DJGZyCsgsXpXHsf0Yi7lzbYsJ5AZVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766090581; c=relaxed/simple;
	bh=Q291t2IrgnJLa/opNZQt+QVUZGhFXFn9nq8SW7IRq3o=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=gVnLfqjvgZ51m4gxyoZuRGyA2n2Ov8ttNFXhIkvEc20VoOVsX1Rj5xuEVCOK2qffmtJ2V8q3/SZIpCCcZ85/Al2o5EQs9tP/XPdoxKGz2KOoDOfN0Ncp8SLohy1FxpIY9HoAFQjvvwXfWjx7BCXA3KbRJJIC27RKsv4YyIJ3LxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W5E5lJyz; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A88F3C4CEFB;
	Thu, 18 Dec 2025 20:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766090581;
	bh=Q291t2IrgnJLa/opNZQt+QVUZGhFXFn9nq8SW7IRq3o=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=W5E5lJyzii+lfWKYEi+Z+6gERyLpLyv2ipPsa2WIC1W9Ij4Vn2tPFhD7FNo2KqPgv
	 /dd9+WyrdI29rLrV7H3UX5NaRPCYkMtT+XaEVEbJAbV/ve2rBOTW0s6zyZgXyLkbTd
	 ddxbCc9Y2DgJ4yZHSy5pGVgusDt9gX+ckrYIs3Aef/1TIiwPVYBCBlEdli240QW1UA
	 FCh2q7ZV0xH49W9CVotVhiq6329JQ/2lShroc2tabc8yqSvwNHt3GUD1yVhYK71wQj
	 CzHPDQMmBsl3q+9bKkb9J2/XHiwIdPDi7MXOyfAfWEbesMcuax9hk0QK3tJNymcCjN
	 +kF685aPGzITg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3B7F4380AA41;
	Thu, 18 Dec 2025 20:39:52 +0000 (UTC)
Subject: Re: [GIT PULL] Please pull IOMMUFD subsystem changes
From: pr-tracker-bot@kernel.org
In-Reply-To: <20251218185201.GA308224@nvidia.com>
References: <20251218185201.GA308224@nvidia.com>
X-PR-Tracked-List-Id: <iommu.lists.linux.dev>
X-PR-Tracked-Message-Id: <20251218185201.GA308224@nvidia.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd
X-PR-Tracked-Commit-Id: e6a973af11135439de32ece3b9cbe3bfc043bea8
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: cf26839d7fca7eb33ecadb7813427dbff3a7a2cd
Message-Id: <176609039094.3123765.7211827919485803329.pr-tracker-bot@kernel.org>
Date: Thu, 18 Dec 2025 20:39:50 +0000
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, iommu@lists.linux.dev, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 18 Dec 2025 14:52:01 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/cf26839d7fca7eb33ecadb7813427dbff3a7a2cd

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

