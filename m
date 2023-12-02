Return-Path: <kvm+bounces-3265-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EE09C801FCF
	for <lists+kvm@lfdr.de>; Sun,  3 Dec 2023 00:52:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4E45BB20A97
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 23:52:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2D9A224D4;
	Sat,  2 Dec 2023 23:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aDCBgnXD"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5F262136F
	for <kvm@vger.kernel.org>; Sat,  2 Dec 2023 23:52:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4B19AC433CA;
	Sat,  2 Dec 2023 23:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701561164;
	bh=8pI1kBZE2n42eBSeESHipDtfuEYuFGMc4j17vAkRywE=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=aDCBgnXDl7rW1hCaanbXplMN5betDxiBuk/llN62tMnHO2UDrmXJBDEunpPI6yg/h
	 vXYU+Qi0oLXw/RRBNWrU4KhqngUkky2WNulvnCkxZ49Uc3ONmIIkp6tQJ83xB+ftDx
	 D4XDVJkbeHq7LTRtYsysh/ulMm2eazxQLJd3aF5R5/3JZugr9fKW2YsoyKBnSf/VCA
	 V3sXVBqWkmTFjVOJAI8kRDtSxKaVmiYmggCzgfDY+D/q11/acei5WX1DVd07s5VTQA
	 YxwL53gGzYELvHzbvRWPXhsP4KioSH87xVI9ktRPKicNTehAZiCmaq30/VRfB+SDYF
	 T/v6c/z2ySgPA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3A3C8DFAA84;
	Sat,  2 Dec 2023 23:52:44 +0000 (UTC)
Subject: Re: [GIT PULL] VFIO fix for v6.7-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <20231201162209.1298a086.alex.williamson@redhat.com>
References: <20231201162209.1298a086.alex.williamson@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20231201162209.1298a086.alex.williamson@redhat.com>
X-PR-Tracked-Remote: https://github.com/awilliam/linux-vfio.git tags/vfio-v6.7-rc4
X-PR-Tracked-Commit-Id: 4ea95c04fa6b9043a1a301240996aeebe3cb28ec
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 17b17be28d42f59f579ef9da2557b92a97291777
Message-Id: <170156116423.30388.7214139415340277781.pr-tracker-bot@kernel.org>
Date: Sat, 02 Dec 2023 23:52:44 +0000
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 1 Dec 2023 16:22:09 -0700:

> https://github.com/awilliam/linux-vfio.git tags/vfio-v6.7-rc4

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/17b17be28d42f59f579ef9da2557b92a97291777

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

