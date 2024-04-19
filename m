Return-Path: <kvm+bounces-15373-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 574CE8AB63C
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 23:07:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 80BC11C211CE
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 21:07:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56F6D137C5A;
	Fri, 19 Apr 2024 21:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KxKl+fC5"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AFF52E3EB;
	Fri, 19 Apr 2024 21:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713560853; cv=none; b=n6vo6uzWariGvmhi3Z7pGl57/dcVVuEB3QGf/Ovb9Ty2cMtfGPHkAWL0xr+OJISK+UwWn4KndtWsAXIl7jIsB7NJnpu3YDVD5iwsGDmGgAThaV/bqZp1/dTGIMsZIgobvFKDD4ivjPVjMMjZpIjsO5l80mjfj0ExF39ablMxZG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713560853; c=relaxed/simple;
	bh=cO/TBUlzFoOsKknR7feDgzAhN0y6FpuTMUHILleBcgo=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=oGZJ97ziNyfoCMgJuQCbr/iwLWl06uhJxxjatAMNqJn/QtAe+JZ65b+zNhwKh1iJJcVRGG75JqYjq5FtS1GGG0KK08l2QAO36qa6x/Y/WkjpLk7kLUG/7SCTzT40iduCIiDtlrCx6bi3yW706uvr4Q5UQaJzA13UX94ER9Vg9Wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KxKl+fC5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0AAB2C116B1;
	Fri, 19 Apr 2024 21:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713560853;
	bh=cO/TBUlzFoOsKknR7feDgzAhN0y6FpuTMUHILleBcgo=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=KxKl+fC5hdNMe410L5hW5I+pl+rQbBMeb59LHJiS9l6MJipSoYR/f+6jUFxSQFh5J
	 YhGV7P+h7cQpuEa1jWy5+KD7/4pVzj8A2icJ8iuOtH0u4qJwzl3uULjq8x6cJfCCFm
	 1weOf4PjLf0/Z47tFQXw1fLX42KQIFOX2VBssXT+eJnDnU8RNTGussZwu2/zl95b25
	 ejqEYdzSQbmdZMev9ia210mGPQIeCJHmVMPuYzYOZLktwjFqUtGaFAaPOc4R8Uohk4
	 RubBzDkM2h3zQOsSTM+V2uabEu9KCGgToKnoBSvtbyyElNMa4ImjUJX6cL/pMXML5t
	 v963+5z/8bxJA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F2047C43616;
	Fri, 19 Apr 2024 21:07:32 +0000 (UTC)
Subject: Re: [GIT PULL] Please pull IOMMUFD subsystem changes
From: pr-tracker-bot@kernel.org
In-Reply-To: <20240419172900.GA3818133@nvidia.com>
References: <20240419172900.GA3818133@nvidia.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20240419172900.GA3818133@nvidia.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd
X-PR-Tracked-Commit-Id: 2760c51b8040d7cffedc337939e7475a17cc4b19
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 50a1317fd18acc2793edcb1d078909527c273a9e
Message-Id: <171356085298.511.4817697475850127979.pr-tracker-bot@kernel.org>
Date: Fri, 19 Apr 2024 21:07:32 +0000
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, iommu@lists.linux.dev, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 19 Apr 2024 14:29:00 -0300:

> git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/50a1317fd18acc2793edcb1d078909527c273a9e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

