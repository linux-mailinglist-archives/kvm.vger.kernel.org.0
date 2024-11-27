Return-Path: <kvm+bounces-32608-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B466C9DAF06
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 22:41:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4CB84282444
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 21:41:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C97D92036F6;
	Wed, 27 Nov 2024 21:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pi1oYbPk"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED9CC20010A;
	Wed, 27 Nov 2024 21:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732743692; cv=none; b=EmKr3nOI5Rom1d0nA2pu3ElXEN+KP5DzOBHXqywwWW5ONTbiaTfIqJqqt8QtpaBFMCseA2cXbySlf/9YSD43T2PENdclJzStKcGaREIW238yM4encHgbJfmSm4BI3GrKGEnVnqk22vJamwGooluSakRis96kQ8Z8vlfI5if97JY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732743692; c=relaxed/simple;
	bh=w+uYQf4hLqaCc4og5nLpG2t0EaTaS/ibKW6jeLLv6ek=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=j2s8eGc4ZhE+6HG+MWpttKapr3RgsUu2kWoJpPVSrxDgMKHEC+urAhyXxHkhL69XmQGO1cqcez3q+B11GwPRuds+vM6zlPaqZsmzmgZ5Ly6az8RJv+Ov8x8QZ1adB6tyABYMHcAVFLE6e+zNVKVfyhGZRW8x34S6xMrQmEISaNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pi1oYbPk; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDE7CC4CECC;
	Wed, 27 Nov 2024 21:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732743691;
	bh=w+uYQf4hLqaCc4og5nLpG2t0EaTaS/ibKW6jeLLv6ek=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=pi1oYbPkf3JoqpL5KbkQN6sMJXtBtkeaJVSitgpUJIJbSaTAo2jUMuBVRin82N0ne
	 DarwwOfOMoRjkr0Cy8jPxpxxEdgDqJaCpCvjL17h9CW4sjrcyed/gtgiOO40hqPSQM
	 kgP+SH6LFMH0my8L4kC4O7fywTb+HEHuATydTgijzqFJp5aeSAUF8W+hMR1kEP2Tsg
	 Z+xaTjhMiYuy62h4y0dfkSp80Y0cjCAysUaPtvYefqF6vDBAdVWJUmTj6Gdmcwt4Bg
	 L05CYe4qUpQADuMlSsLtGm+WINJ5KidPOTE6+F+1Sb/CC0F7wr2Mg6uU0EVSnbSK/U
	 K5CI6kgGnrtgg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 34393380A944;
	Wed, 27 Nov 2024 21:41:46 +0000 (UTC)
Subject: Re: [GIT PULL] VFIO updates for v6.13-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20241126092324.272debec.alex.williamson@redhat.com>
References: <20241126092324.272debec.alex.williamson@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20241126092324.272debec.alex.williamson@redhat.com>
X-PR-Tracked-Remote: https://github.com/awilliam/linux-vfio.git tags/vfio-v6.13-rc1
X-PR-Tracked-Commit-Id: fe4bf8d0b6716a423b16495d55b35d3fe515905d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4aca98a8a150f3531fea782c3040ada0ad1ce3b6
Message-Id: <173274370483.1220377.3519519644863315639.pr-tracker-bot@kernel.org>
Date: Wed, 27 Nov 2024 21:41:44 +0000
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Tue, 26 Nov 2024 09:23:24 -0700:

> https://github.com/awilliam/linux-vfio.git tags/vfio-v6.13-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4aca98a8a150f3531fea782c3040ada0ad1ce3b6

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

