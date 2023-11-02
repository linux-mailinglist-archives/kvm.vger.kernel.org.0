Return-Path: <kvm+bounces-345-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0054D7DE925
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 01:01:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2A8261C20E85
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 00:01:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 190081C35;
	Thu,  2 Nov 2023 00:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VDEFXhnT"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD46910F6
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 00:01:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4BFE6C433C8;
	Thu,  2 Nov 2023 00:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1698883280;
	bh=ntQko+8dkscPDZRJ3pZ8fhtqtiQ5uxRbqAcj1V/+OPw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=VDEFXhnTqKO2+JVjxw0Ip6tt4JRxCjc7Qza8nUB0VcFahonXpZYioIdqLF5szkWfI
	 +ro4V39oK9Dnt1xI/9iCGBbm2x314qRlv96Hj7ylyMhkjR7LneIMqmP0zwov+Lmt2+
	 EBkHXk9Tm4Ja/3aom4JVAXrqdzS/vVuekZmPtx8IFd+3lzh3xY1sIkGoc3awaNzM/h
	 BNs+bAHS/XMTy028IdlvhiqSM/vjEtsemzk45TL4xvfx4Cc8A78uob6VCpJhDqAYiK
	 1S8W9ikceQo/0T2gdCuFz7WPTDI+9etSj8eVpu1GBzZI1MOW9g+O15Kg/U/DmYekJC
	 EWHy/LuwCSbIg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3BF1DC4316B;
	Thu,  2 Nov 2023 00:01:20 +0000 (UTC)
Subject: Re: [GIT PULL] VFIO updates for v6.7-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20231031115400.570e00d1.alex.williamson@redhat.com>
References: <20231031115400.570e00d1.alex.williamson@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20231031115400.570e00d1.alex.williamson@redhat.com>
X-PR-Tracked-Remote: https://github.com/awilliam/linux-vfio.git tags/vfio-v6.7-rc1
X-PR-Tracked-Commit-Id: 2b88119e35b00d8cb418d86abbace3b90a993bd7
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: deefd5024f0772cf56052ace9a8c347dc70bcaf3
Message-Id: <169888328023.31464.13235227422474558237.pr-tracker-bot@kernel.org>
Date: Thu, 02 Nov 2023 00:01:20 +0000
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Tue, 31 Oct 2023 11:54:00 -0600:

> https://github.com/awilliam/linux-vfio.git tags/vfio-v6.7-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/deefd5024f0772cf56052ace9a8c347dc70bcaf3

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

