Return-Path: <kvm+bounces-3411-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A4E4880413B
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 22:59:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4EFE6281315
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 21:59:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FE1B3A8DC;
	Mon,  4 Dec 2023 21:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u5RjSasI"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C5CD39FEF;
	Mon,  4 Dec 2023 21:59:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 81235C433C7;
	Mon,  4 Dec 2023 21:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701727142;
	bh=mG8wdYHgXcY62vLiVOvKhsnH6FtRt36cVg8GDLHLCA4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=u5RjSasIwqJItsP3bJhxJTXbT/tYtv/19VAIwjPdiPxzAYpGzWPubjmImEjK0/ZVA
	 JzqramSgvZODUSz6kBREpgrJqvO7l7JeRzNz1IHzTH+c5INOBBcdL9tiYHyH1Ye+ee
	 lmHbZhcG4qsVsVWgBGGz/yZ6trefSDIxmHgWGiME3w3tDm8zpwepxoIGFdvB9WQki/
	 VFtwWfi5LaYvrtiN94c2PjX2cLzhoymCVuLQsvvcJkUsACzTixkOW25rDa6uxfIGFc
	 c41kO4r7bIFWFCX4oeRtb5qTrg9AYpRFly92Cu4xh5SDAG9G6fqQgXlIlzDMfEnpBp
	 mdxS7PRsAT0oQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6B500DD4EEF;
	Mon,  4 Dec 2023 21:59:02 +0000 (UTC)
Subject: Re: [GIT PULL] Please pull IOMMUFD subsystem changes
From: pr-tracker-bot@kernel.org
In-Reply-To: <20231204193534.GA2755851@nvidia.com>
References: <20231204193534.GA2755851@nvidia.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20231204193534.GA2755851@nvidia.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd
X-PR-Tracked-Commit-Id: 6f9c4d8c468c189d6dc470324bd52955f8aa0a10
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: bee0e7762ad2c6025b9f5245c040fcc36ef2bde8
Message-Id: <170172714243.21763.11586425434188265851.pr-tracker-bot@kernel.org>
Date: Mon, 04 Dec 2023 21:59:02 +0000
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, iommu@lists.linux.dev, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 4 Dec 2023 15:35:34 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/bee0e7762ad2c6025b9f5245c040fcc36ef2bde8

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

