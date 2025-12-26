Return-Path: <kvm+bounces-66713-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C9092CDEF32
	for <lists+kvm@lfdr.de>; Fri, 26 Dec 2025 20:53:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AF57D300FFB6
	for <lists+kvm@lfdr.de>; Fri, 26 Dec 2025 19:53:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DA83280035;
	Fri, 26 Dec 2025 19:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LQ8XNy9m"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 611671C695;
	Fri, 26 Dec 2025 19:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766778789; cv=none; b=nhoGnvJaw3JTycqBZs9RvCwdQmWojfNVEuy6XxVZh2VDoNPgtyFAdMm3bnFNdxrMlCBcvYCpLB3FAqfhi8Ly+m2bNSkWumg0WZZpW0UpGApG6mtZMzcnhVNknm8YK0c4nBvG3dfj0IfLT3LRB3fAB9W8fY+HMxcSTMKWAMFmihE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766778789; c=relaxed/simple;
	bh=hgtHt1Ym0whBpm/tq4nMQqk5Cv8h2rFacLOvCET6REQ=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=TlMgngzbsxlFBz+gjFKEbNwQ0ncadzXdLykl6E1dyjj9Pcnf8rKUqaptyHbxnaTM6182ZrIMMHm/PKLmiEzWZmpjrqF3J8ZEUlSBST1YNfi6I7TN9kUniCcCuJQ3DqMByQu03rPbbM8Ovrs2CdLyldiXL47ovWrrwV+VmJ9kCHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LQ8XNy9m; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB980C4CEF7;
	Fri, 26 Dec 2025 19:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766778784;
	bh=hgtHt1Ym0whBpm/tq4nMQqk5Cv8h2rFacLOvCET6REQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=LQ8XNy9mCVSG2KbDXj+xs2Y5Fsq5esHCXbBg55Pwads/SxzWu9pHITm4NPg1Xkzoq
	 GQfNx62DX/KGifPmO9s3rAqG2HbQoGKe99aAqIwaSbeNll4CmFshpKV4mTPi0/bSQ9
	 nAgOsXvkB4ewztrGutdBW9Sfn2gjnyR8BS1LnMbdzkwFvgUzSQ4w6EkuD3eoI+6szn
	 3tsy6SK0yVBUKDFKIMp0MJB8yw9szNY1XUCBr0GbeDhsVn/J2Qw3P+9jDeKsqGyqb/
	 o0QmgYElea4AYpsj0BZQn1sQpITMOH7hY/Lb/kIFVcPP3S4WRdBlHWEqS9DfasoKuL
	 P4kuiLeykwOHA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 78D02380A959;
	Fri, 26 Dec 2025 19:49:50 +0000 (UTC)
Subject: Re: [GIT PULL] virtio,vhost: fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <20251226093606-mutt-send-email-mst@kernel.org>
References: <20251226093606-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <virtualization.lists.linux.dev>
X-PR-Tracked-Message-Id: <20251226093606-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: d8ee3cfdc89b75dc059dc21c27bef2c1440f67eb
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8f0cbedc86cfc93ea869bbff420a2d86f6373f57
Message-Id: <176677858907.1987757.13007166201967025863.pr-tracker-bot@kernel.org>
Date: Fri, 26 Dec 2025 19:49:49 +0000
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, jasowang@redhat.com, mst@redhat.com, sgarzare@redhat.com, stefanha@redhat.com
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 26 Dec 2025 09:36:06 -0500:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8f0cbedc86cfc93ea869bbff420a2d86f6373f57

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

