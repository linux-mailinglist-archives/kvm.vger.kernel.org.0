Return-Path: <kvm+bounces-17800-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 42FBE8CA45A
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 00:09:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EC8EC1F22607
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 22:09:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03972139D0A;
	Mon, 20 May 2024 22:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cIcu7PRh"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21AB51C286;
	Mon, 20 May 2024 22:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716242946; cv=none; b=jF955ElzRfO/hIkvXzs8HgGvBdopOLn40YRie+LI5DhrZZWGpfRyTdDpa1KjNCU0AILYz4OS0s8iR1DBNO4e3DeN4YYaV8PBCi+nNP1aMpSNkTPZEF9jh0QlP00YcYkL+WY3QHn3ERzHTVi+WniKKuhIEycqDmCaRwB8CAs3Pj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716242946; c=relaxed/simple;
	bh=qwriMweA8xJjU9Vz6gjzbEt6G1rPNodg9p/lRmGM6wg=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=MvcZueAtYslBc/Kpgyobb+v0b5ifn8sna6XWrM7pqUBq3ouO23d1OdIS7QeCHXEkbtSSx2BKWIvfS+jFQSthWpD2tg9t2X/BzZEP1/ghniLDsIWJRDGAUi3aNI+TTPKKg09ZaYY4Y4LBpBvghd277kQysgAOmlrvjythPKYGUgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cIcu7PRh; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id F3C21C2BD10;
	Mon, 20 May 2024 22:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716242946;
	bh=qwriMweA8xJjU9Vz6gjzbEt6G1rPNodg9p/lRmGM6wg=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=cIcu7PRhg67uIr2rLOXId6vR0tPhr/5ShbuY2RoSi6tgdRriDEu3HDv8d/gcgZNIb
	 PRffGW7xeHf+CfbcJh6KNN2Q662leCqYs1E1ULg/KF6G29uvPvfiSRTEqGh0dt8r9e
	 8olU3y4em11H3LmDjMoicEkf1c56q9BAEaBTIrTYVRnT1usH/F4JbMTNJdtoXXIZvV
	 7vp8v7OXQobBvsS8LOvRN/qgwqBOASKovXnq4dvY9Nel7crO2OuKcetfxHRlwPrH3d
	 RnzOQoKIW+RwSeeJ105+O835GzkXlnWEktreJzIj/r3tSK0k/g5rgDKRwTXis7ALRE
	 7AXPoI5gjosFw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E89F7C43332;
	Mon, 20 May 2024 22:09:05 +0000 (UTC)
Subject: Re: [GIT PULL] VFIO updates for v6.10-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20240520121223.5be06e39.alex.williamson@redhat.com>
References: <20240520121223.5be06e39.alex.williamson@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20240520121223.5be06e39.alex.williamson@redhat.com>
X-PR-Tracked-Remote: https://github.com/awilliam/linux-vfio.git tags/vfio-v6.10-rc1
X-PR-Tracked-Commit-Id: cbb325e77fbe62a06184175aa98c9eb98736c3e8
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 30aec6e1bb617e1349d7fa5498898d7d4351d71e
Message-Id: <171624294594.5056.2043882398761130962.pr-tracker-bot@kernel.org>
Date: Mon, 20 May 2024 22:09:05 +0000
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 20 May 2024 12:12:23 -0600:

> https://github.com/awilliam/linux-vfio.git tags/vfio-v6.10-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/30aec6e1bb617e1349d7fa5498898d7d4351d71e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

