Return-Path: <kvm+bounces-58406-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7548CB92984
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 20:27:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ED3312A3EBE
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 18:27:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DAB231985D;
	Mon, 22 Sep 2025 18:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WT5S0VXr"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 877262E2DC1;
	Mon, 22 Sep 2025 18:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758565667; cv=none; b=V2SU/cWKcQ3rbsdfsF0Csd6xfiNUlY1hepFK8sEQFGfieA+ZOKkLKWFSFfT3hGajdLmR+J3FZhhUvBcjkgCpay67OI0FuijiioXgZ3alV+yqam6Wh5L3pr8OqiOG/dJ4oKVsZh4lJXV+08adR5r3S/k23SmSFVJwDQa3Nucpvjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758565667; c=relaxed/simple;
	bh=tL2cBrBG1PNTyJ8g1Faef6A7twf3MNrHJVTlnkfJAmw=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=kmdtEJKWZL4Z6xYd93+DNtS1w3frkrdonmdjjeNt+nDICwLJZluZW8OU9s5isrMA2u0MOB7BVhOxivxzNTeRbY+HMxsQkwafnCcmcB/mJ+qFpatItNyQAJBV0AKkn7o8f8yipkJ/XKvlsN0rfwF+tDeN4jjOz4wsSAqbQ3ieuUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WT5S0VXr; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D37EC4CEF0;
	Mon, 22 Sep 2025 18:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758565667;
	bh=tL2cBrBG1PNTyJ8g1Faef6A7twf3MNrHJVTlnkfJAmw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=WT5S0VXrtJFxaIhOP8lzAEnTtdgqG95vaz+vqube7VA5//sAVOWLXHkqc6GbkovLT
	 rHSUe4568Nvz4jnbfsf7h3ymALlhXzdlRIVu2dOs393n5IlEyEYGzlFLMNGbZvO2N8
	 d8fcwXogxQfl9EJfNA0CuNXvu9IKISKYe+4J+VagFphsSgpvmK6dsBhUF0P4E+ftbw
	 S//gCIhSapDuu5kIwJUe0MEI/UD1Kci4vr6fn19tdtqMCrDaEnM9bKBJGf30jc9OJm
	 4haHJRqK/UjvTds1LjI3A4T/+DuVWp3pLbUedFvpZKZLd2oG78UXs8oeQPNcoIuNeG
	 n5wpxwnUOALcQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33FC339D0C20;
	Mon, 22 Sep 2025 18:27:46 +0000 (UTC)
Subject: Re: [GIT PULL] Please pull IOMMUFD subsystem changes
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250922143329.GA2529959@nvidia.com>
References: <20250922143329.GA2529959@nvidia.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250922143329.GA2529959@nvidia.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd
X-PR-Tracked-Commit-Id: 43f6bee02196e56720dd68eea847d213c6e69328
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d4c7fccfa784da0583fed9c8f98ed78236c030fb
Message-Id: <175856566468.1111894.13694066385590267385.pr-tracker-bot@kernel.org>
Date: Mon, 22 Sep 2025 18:27:44 +0000
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, iommu@lists.linux.dev, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 22 Sep 2025 11:33:29 -0300:

> git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d4c7fccfa784da0583fed9c8f98ed78236c030fb

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

