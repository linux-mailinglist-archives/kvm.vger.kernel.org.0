Return-Path: <kvm+bounces-350-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F9B97DEAF1
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 03:51:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5E53D1C20D85
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 02:51:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EAF51860;
	Thu,  2 Nov 2023 02:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k1hPjoL8"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02ACA15D2;
	Thu,  2 Nov 2023 02:51:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 77B37C433C9;
	Thu,  2 Nov 2023 02:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1698893492;
	bh=rZ4OuooRolOsB44aW9nZuPPoINVmvXpmNNL08taFfm8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=k1hPjoL8kQkQu+tyiqj0yUkL+Qw+vmpHHJgeda90Qj2IlB2aQsgrd8Atc/vCZarkP
	 btJ4q4Um+qJXycH2vPZlvpEqmGaOX7kp0qQT6eC823bfFIY7N7LqbfSRMMev6y18QD
	 kXUgF3sDqW2eyTx9TuqMjdRRXNkM1pCOTLgwP0FA6eqzSbuqViqE704ypIQRWeL6c0
	 bajK2wHWymSI6QjqDxHIduxWdUJpF8FFVWHkG/hg7XIfyLIq4cnHoOX8oMSp8Jr2Gb
	 9t4BKZ9Zy3mXarFaV3xNIYHevHMj7dhmaf0n+X9qf9whtNVdmMWt9zKslkJRHaRU/g
	 Lpfu1nEqJW2TA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 66F02C395F3;
	Thu,  2 Nov 2023 02:51:32 +0000 (UTC)
Subject: Re: [GIT PULL] Please pull IOMMUFD subsystem changes
From: pr-tracker-bot@kernel.org
In-Reply-To: <20231031131417.GA1815719@nvidia.com>
References: <20231031131417.GA1815719@nvidia.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20231031131417.GA1815719@nvidia.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd
X-PR-Tracked-Commit-Id: b2b67c997bf74453f3469d8b54e4859f190943bd
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 463f46e114f74465cf8d01b124e7b74ad1ce2afd
Message-Id: <169889349241.17707.8262732702876780148.pr-tracker-bot@kernel.org>
Date: Thu, 02 Nov 2023 02:51:32 +0000
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, iommu@lists.linux.dev, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Tue, 31 Oct 2023 10:14:17 -0300:

> git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/463f46e114f74465cf8d01b124e7b74ad1ce2afd

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

