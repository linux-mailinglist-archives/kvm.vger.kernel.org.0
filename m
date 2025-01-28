Return-Path: <kvm+bounces-36811-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C2CAA21482
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 23:39:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D2F9C3A8033
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 22:39:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 745451F3FE6;
	Tue, 28 Jan 2025 22:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XRXcZUet"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 925A21DF260;
	Tue, 28 Jan 2025 22:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738103932; cv=none; b=WO58IcyolEpF+Mv/r9z2K6NavA0CTfQIRgMD1ft4KxOpd6MYNQ23LDhNsfLW8Uz2OBRB9kwswwestjENJNZS47hIf9V2ujLznrRLP4YTCyQLJj+tnj7gEqGP5ix/gVZI1pkflRDWolSYzBWZRQgN58wv8wGXKhL2tkJc1ii4kOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738103932; c=relaxed/simple;
	bh=SkWEDtdNb9JMvWR1afcGBxTUbJsjGd8eu9eJtGGY800=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=dfJin5XBF1b+6J3wA8FPum9nFWJP21p78n/mRjBM807uxTIoPcnvvDGxo8CpRgxZf3yiCPPQIaRn7r/RX10YoiwbQxWK06ZEDAP4/FQ2G0U57SNV7tVoFnbVVodxzLscly8a35Rn5MfEvK0cj+yFXY+goI/D1h5TaTC3gF59Cp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XRXcZUet; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18D03C4CEE4;
	Tue, 28 Jan 2025 22:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738103932;
	bh=SkWEDtdNb9JMvWR1afcGBxTUbJsjGd8eu9eJtGGY800=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=XRXcZUetZPiHGj6bIRnUojKdRnfR32wufGdXpPiV4jsuwN0guw0sYE1KKZqu+C6CP
	 IWPGKn2weDaGoupkjlVDrgtKOrhATXZOaprDVfgSizSct+UKvW5hTxvEzbSRPhAjtU
	 pSbeH7cblh1NYTAzkJavOuAWLXCGUlVLLTQ+8Xs431TeFHl5jw8Tg86pOxvmgI1j/n
	 4Aix7Vasv8lL6GH15w6+xs1uzqjH6o7gf0sqng9Ng/YGXcmZIYWXteFWu0FPBUiNU+
	 N0xEXgxVF0SLIerHkCygbf4DXO1Yc0n7wm4gTo53cJjgROgbjBZguwb+R+Y97S/P4R
	 kWBH5CGxvstzw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33C9B380AA66;
	Tue, 28 Jan 2025 22:39:19 +0000 (UTC)
Subject: Re: [GIT PULL] VFIO updates for v6.14-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250128142439.3f6dd5b7.alex.williamson@redhat.com>
References: <20250128142439.3f6dd5b7.alex.williamson@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250128142439.3f6dd5b7.alex.williamson@redhat.com>
X-PR-Tracked-Remote: https://github.com/awilliam/linux-vfio.git tags/vfio-v6.14-rc1
X-PR-Tracked-Commit-Id: 2bb447540e71ee530388750c38e1b2c8ea08b4b7
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3673f5be0ec4798089c2c014505e54fc361d3616
Message-Id: <173810395786.3944426.5181741573210462800.pr-tracker-bot@kernel.org>
Date: Tue, 28 Jan 2025 22:39:17 +0000
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Tue, 28 Jan 2025 14:24:39 -0700:

> https://github.com/awilliam/linux-vfio.git tags/vfio-v6.14-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3673f5be0ec4798089c2c014505e54fc361d3616

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

