Return-Path: <kvm+bounces-61731-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C6E1C270AC
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 22:30:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id CACFA351BDE
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 21:30:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00A29328B7C;
	Fri, 31 Oct 2025 21:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dNnLimzf"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18532324B33;
	Fri, 31 Oct 2025 21:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761946212; cv=none; b=m87N7IU2D+pODF/Jm8Gsany4mmUXAdmRMcPHIwG2D05FC72ig1OpGRrDXFA1snazOI18F6FroQmqWGwlWgld1E691FtK4OWPiAqGDjHL9/T1sgh1gsvXKwJRYRFaJ2UrgRrsCaIXdGZMUdEviPc3qZQpgTAgjz7ypuEfnZACdIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761946212; c=relaxed/simple;
	bh=xD4ny52vkCtsAXPAQsH4viZT5jkjKDdNSEEPUu8x4VY=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=e43lmHOvjdQYWOxAP65XVuMQNZj9FyPkq1f6zH3hNR6KzcKGc+oa6+DwKgrcxumQoMgknHOX3JajIcdsD4N70dtZ94dXWbfFOKiEV3yNNPTRaKe8wrYjlPP0p311dURq19cpTwHxaBKVvrLcNvKaBWx2WtvPMIsr6IYyd/e/pTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dNnLimzf; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECBD0C4CEE7;
	Fri, 31 Oct 2025 21:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761946212;
	bh=xD4ny52vkCtsAXPAQsH4viZT5jkjKDdNSEEPUu8x4VY=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=dNnLimzfwEUDXN15wHdhRWC+KsskBV91kiUzHwNeXqRVOhlj9jheeKiCVi74Jns08
	 rJFg7FtCCnoKwKkQPi8IHlCKL+I3t0pnQzvahyu8eCFiOepDWCgSAqDnDulDZEv8YJ
	 M1g/7MRGj6ecGKgarfghykJ3WRHbF9z0wdpQj9ipZO+cF6av9Z2p6Ml5zg2IcRqFbx
	 E9J1iW8KLM18Ton4JfnC/qEpNFx8sxDqsIvwK1khUEXvc2EK5cPf9tnHppTgkos/0T
	 rsN2uTTqE3PZYpTQ8HZZQtO5HvxGE3mtdj5bJH5GyE7ZHr8g2PY41stzLMwQoowH3h
	 789xpCU1f8UkQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33DA23809A00;
	Fri, 31 Oct 2025 21:29:49 +0000 (UTC)
Subject: Re: [GIT PULL] VFIO update for v6.18-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <20251031141747.1fd01a0a@shazbot.org>
References: <20251031141747.1fd01a0a@shazbot.org>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20251031141747.1fd01a0a@shazbot.org>
X-PR-Tracked-Remote: https://github.com/awilliam/linux-vfio.git tags/vfio-v6.18-rc4
X-PR-Tracked-Commit-Id: de8d1f2fd5a510bf2c1c25b84e1a718a0f0af105
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 39bcf0f7d415fee440d2eba877b9b618cbd6d824
Message-Id: <176194618768.642175.4668962282938795803.pr-tracker-bot@kernel.org>
Date: Fri, 31 Oct 2025 21:29:47 +0000
To: Alex Williamson <alex@shazbot.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, linux-kernel@vger.kernel.org, amastro@fb.com
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 31 Oct 2025 14:17:47 -0600:

> https://github.com/awilliam/linux-vfio.git tags/vfio-v6.18-rc4

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/39bcf0f7d415fee440d2eba877b9b618cbd6d824

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

