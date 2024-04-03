Return-Path: <kvm+bounces-13485-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B30A989775D
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 19:52:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5897C1F32630
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 17:52:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D637D158215;
	Wed,  3 Apr 2024 17:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hAV1H7G4"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFB5D1581FB;
	Wed,  3 Apr 2024 17:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712165738; cv=none; b=rHVHymjCSE1it1YVYLQFfT2A5NuO5KJxLbzaM2KYgf8netJtEmI6W1GT3AbsugEZJiz2DJC4cnjvc62DBjjlxZHqBjR4uhdBHCL5k65EZm/iFxaiHP85a1FDvhn+Ccu83dMA/A8DdOFg616NGs1pl3tiNCtb1M9B/IGBJaJCD6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712165738; c=relaxed/simple;
	bh=vJsurg6svvfHm+chaH065sC6/08D9Wk8hDVuI24R2F0=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=b011x6NvTHUcJkDkfRiGIFkib5ArSWivT+zkB0/iLKNG+5dHIXne5E1vjK+4t1Xsg7igWU9k3Q34PvnOFCGYFYzf4nkOI3Iy9emUglGkPvNsA/8qMe/umzICq7A8A+bMlKpAiGsnsO88em6rMQ+sihlbskxSb1/zCLSa1CBxsMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hAV1H7G4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id BACFFC433C7;
	Wed,  3 Apr 2024 17:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712165737;
	bh=vJsurg6svvfHm+chaH065sC6/08D9Wk8hDVuI24R2F0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=hAV1H7G4JUjA3TTXlSeF9LUW5aWF/c+7290+Zi+fwQuwW8gNZD3b/5ZwrmwGnkMCz
	 RTPY1a+sEIrwDUCMJeQEec70GVgJVzTIGo74vkruw7XBIa79v6ezGlVrpaZtJp1V9K
	 B6IIwRUcSZxjCr4gmCY53QdLyQ2vca+o4ml+vtkk5uDMxcGkAn5nkRKG9bZNQPptPc
	 zs03y98Axqb/xNO22bIIktozYbi7JQZxz80O9z71/BtkJF9rEB3mYAebZkkExCfO97
	 O0GnUT6z0kTcjaXVvMoYBLN+ur7qgX6lydItqJcs/fcaYUaR4ki/spH2Q+hvMBObVP
	 35MciMnMe/KBQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B1A8AC43168;
	Wed,  3 Apr 2024 17:35:37 +0000 (UTC)
Subject: Re: [GIT PULL] KVM fixes for Linux 6.9-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <20240403130418.3068910-1-pbonzini@redhat.com>
References: <20240403130418.3068910-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20240403130418.3068910-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 9bc60f733839ab6fcdde0d0b15cbb486123e6402
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0f099dc9d1149ceaa9319810dba44ffd06f3aef7
Message-Id: <171216573772.31118.9742310011470575125.pr-tracker-bot@kernel.org>
Date: Wed, 03 Apr 2024 17:35:37 +0000
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Wed,  3 Apr 2024 09:04:18 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0f099dc9d1149ceaa9319810dba44ffd06f3aef7

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

