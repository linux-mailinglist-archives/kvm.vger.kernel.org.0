Return-Path: <kvm+bounces-32326-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BA9F9D54A2
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 22:20:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B8EA31F2115C
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 21:20:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C37CF1DAC83;
	Thu, 21 Nov 2024 21:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="It4e0CFa"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E369E1D04A0;
	Thu, 21 Nov 2024 21:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732224010; cv=none; b=Q65rRgyeVm0J3z3Pvc5uI3fxoTOVc3hEyVRUkGOp6SoudUrLY3NvhHEsiTMoAlU6oYXrgq+OVOIwIn5WjWw6csv2UjdPsDEn45btbw6z5S/b3V6ZaKlRyr5W7AXzcseIMynnDcERV9ZU1s728j3J3Fusbodsr4L3aJviTsEsR6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732224010; c=relaxed/simple;
	bh=KZT12RXt0vKAg5pmQ87+f1k0Iy0lnqOh0HqDe6idbj0=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=H/5AZ6KPgp65wj4pDqyKS25Ez42xPIc5X+oQV0FM80QhFXDtoZ+19xLojOXkas8vdx1fREerbbght63MrkSxNJjEKrYtRO7d7Yc20x/71DynHUTVYIuixKs7zorFG7G01yG7BYTXpFQdkZJaDmb544rbsWWi3qvE5zPEW84wELQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=It4e0CFa; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6A8AC4CECC;
	Thu, 21 Nov 2024 21:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732224009;
	bh=KZT12RXt0vKAg5pmQ87+f1k0Iy0lnqOh0HqDe6idbj0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=It4e0CFagg4D/sw8EwNXPRpPxuwnZGk3RkCvbvcqiwp8xiCQ1FJQqsu7+k7yWhcrZ
	 LEeTAk0Z3nVTjthXzHG/LoImO3wUCbCzMcqNinvaMoHQgpzYLCRE7xiRZ/qr5yoNda
	 AIiLAJluOvvkg+3vx51rgcYVIv7fsbXwA0bCwjpJ5jtGaWPdDlQlxUEwg3/XaGSZ69
	 qpA14EcTYzG0fFJjLILpLvZc6G/C1fT4xjoohSUP7ZeEjepIqk8Djxor6CkpioNWdR
	 XLadxiS5kvbcKH+D1uLiPaDiz3u1twLHrJIrMezxE8nzOd+PAOK8/+WSuOg9hwBeVN
	 wQhVXJmPsNULw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EBA703809A00;
	Thu, 21 Nov 2024 21:20:22 +0000 (UTC)
Subject: Re: [GIT PULL] Please pull IOMMUFD subsystem changes
From: pr-tracker-bot@kernel.org
In-Reply-To: <20241120145345.GA811296@nvidia.com>
References: <20241120145345.GA811296@nvidia.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20241120145345.GA811296@nvidia.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd
X-PR-Tracked-Commit-Id: 6d026e6d48cd2a95407c8fdd8d6187b871401c23
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 341d041daae52cd5f014f68c1c7d9039db818fca
Message-Id: <173222402140.2113520.3056559889313201720.pr-tracker-bot@kernel.org>
Date: Thu, 21 Nov 2024 21:20:21 +0000
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, iommu@lists.linux.dev, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 20 Nov 2024 10:53:45 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/341d041daae52cd5f014f68c1c7d9039db818fca

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

