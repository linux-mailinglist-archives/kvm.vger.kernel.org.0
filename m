Return-Path: <kvm+bounces-59490-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D139FBB87D2
	for <lists+kvm@lfdr.de>; Sat, 04 Oct 2025 03:41:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 90C5C4A3A1E
	for <lists+kvm@lfdr.de>; Sat,  4 Oct 2025 01:41:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 339861DE8BE;
	Sat,  4 Oct 2025 01:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jEetfDGi"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 449E01B0413;
	Sat,  4 Oct 2025 01:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759542066; cv=none; b=YOrOoOlIN2zRWWDQdEjeKcyjAz+dE2mkNGXsx1xnsKbw0Swnaeu3KAYZ9Eucg/DJ7mD1X0hqBVkHS+9VhdwUZZyFlaLlzG1LHKsir12tzBzwfEUSMqS35HMsy4rmW+tSrV6ra9+rjfV5CwsVXXyHhQDPHVprFKrptTDWXe6i43w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759542066; c=relaxed/simple;
	bh=G3p8JhuGE4303ArBUb1IE6wQQ2neeIGqqCKsalyLc2o=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=PMW3skcUpfBOAd2/AlyR/0ZHF/BmsRpPCQv7z5pWZhSl0GPxpa9JFpoCZe7GpJ32WVUGuj8FwBAXALy47E64d+B4yZMb+D17ta9J+TqKbV2f5jCBRJop3APD6DivvoZdnc3o9AiOZeMYBZtu9rZEiKoV5kIQ9gT8Z0pXDwwuXLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jEetfDGi; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C057AC4CEF5;
	Sat,  4 Oct 2025 01:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759542065;
	bh=G3p8JhuGE4303ArBUb1IE6wQQ2neeIGqqCKsalyLc2o=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=jEetfDGi7dzGpqfDLc1lf1LbLprBF1WBPEIbWop/hNrLjWAOtUllweZeC0mxUK4d1
	 ke3TJENp5ueePaN7HGhsqUlf176Ltjhw/nGFCUhdRxqEIQO9vk/srmgx9kMCbrNElM
	 YSbJ8CoR85H9qWd9ai8wAx5agNpnstsrTzel1y75s30h+eABvxq1+EbcA5sLC7qvV+
	 WdhyCp8qYDt92pQiWnLP7GHTBiikA/J+rVhITcXbwvEgGxNpmsn2Zqnj/yT8Q2yTVp
	 D/FYRmwgF6lhV7Po0WFrmLEsd2C9VM1PUaaGb/aiVBMw43IT8hODpNoeBaDYoU2GnM
	 8ZhSk50bsfa8w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33D5839D0C1A;
	Sat,  4 Oct 2025 01:40:58 +0000 (UTC)
Subject: Re: [GIT PULL] Please pull IOMMUFD subsystem changes
From: pr-tracker-bot@kernel.org
In-Reply-To: <20251002142926.GA3295849@nvidia.com>
References: <20251002142926.GA3295849@nvidia.com>
X-PR-Tracked-List-Id: <iommu.lists.linux.dev>
X-PR-Tracked-Message-Id: <20251002142926.GA3295849@nvidia.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd
X-PR-Tracked-Commit-Id: 2a918911ed3d0841923525ed0fe707762ee78844
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e56ebe27a00dee1e083621b67ec23310d8e0319a
Message-Id: <175954205681.144727.15322076420047053322.pr-tracker-bot@kernel.org>
Date: Sat, 04 Oct 2025 01:40:56 +0000
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, iommu@lists.linux.dev, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 2 Oct 2025 11:29:26 -0300:

> git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e56ebe27a00dee1e083621b67ec23310d8e0319a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

