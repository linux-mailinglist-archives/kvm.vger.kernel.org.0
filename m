Return-Path: <kvm+bounces-21968-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A8C46937CFC
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 21:38:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 65EF728293A
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 19:38:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF69F1487EF;
	Fri, 19 Jul 2024 19:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S1Oj05aE"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14B3654BE7;
	Fri, 19 Jul 2024 19:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721417903; cv=none; b=mLYw9OBlmLK8FZEILWBcd83LYhDD+Yt3Ol0F/XPgc6AkKeKWbeAQi7xBzDroRAUVo+INNNEsGH8gA9qYgpnT4V5uPI4tA1NMrzSLx6+a9tSZ/rD093K640KvjwAFDu1LUnyjLRx0ZftOe+D16fLhFegcKK4kXEhzZ4Evo+xCV4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721417903; c=relaxed/simple;
	bh=NWxD6l+tF/NnFkaZBW9wWD7Mbr238N1lcgMrmU841ac=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=uhgmu3tiFD4by+6J3DtWedJXbE48L1oomzbxnMNyMTff2vupElSKXY3v3nozBblimm7/2gNPqgcxaX8DNYcyZhh6JbpRBi2lJgJnhQYhPTwWmlBHUIsZBDfPZfo80loCPSiJR7ttYT7E5wo0+29nFCPl/X43aKId58sva0MyFvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S1Oj05aE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id D53CEC4AF0A;
	Fri, 19 Jul 2024 19:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721417902;
	bh=NWxD6l+tF/NnFkaZBW9wWD7Mbr238N1lcgMrmU841ac=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=S1Oj05aEkv1Rq7+5YWuTNb+c31C6T7n7dlmWIk0GI46m1Ifi+jb67QW1POoLQe9yp
	 vrMQjFMtCnxOUNezVTJ/l3MBSGsUT1/CBSYKiUpiBN9c1RMeI6/x4ohp2ouRENfKzy
	 aVDrX7StH3MufZwvUVietRcChvbQ7UJCH00xN6qxZt8VChmKeB6+oH/4DIOzVS2m38
	 kD6osb6RFRvAszTEHhQITeGPKYI0biZ1cte/+6QZ4RL9f/6vitGSwtjDfLaE9oE0fe
	 Ddtwf2eTmg7I9Yhr85dV8yEoTwr+HwOxqmdd5Xbk7PArAjr4iQb8LgcXV3bNohsDng
	 09iiFV5rTS5qA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C8C62C4332D;
	Fri, 19 Jul 2024 19:38:22 +0000 (UTC)
Subject: Re: [GIT PULL] virtio: features, fixes, cleanups
From: pr-tracker-bot@kernel.org
In-Reply-To: <20240717053034-mutt-send-email-mst@kernel.org>
References: <20240717053034-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20240717053034-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: 6c85d6b653caeba2ef982925703cbb4f2b3b3163
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f4f92db4391285ef3a688cdad25d5c76db200a30
Message-Id: <172141790281.26000.2833728574962008166.pr-tracker-bot@kernel.org>
Date: Fri, 19 Jul 2024 19:38:22 +0000
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, aha310510@gmail.com, arefev@swemel.ru, arseny.krasnov@kaspersky.com, davem@davemloft.net, dtatulea@nvidia.com, eperezma@redhat.com, glider@google.com, iii@linux.ibm.com, jasowang@redhat.com, jiri@nvidia.com, jiri@resnulli.us, kuba@kernel.org, lingshan.zhu@intel.com, mst@redhat.com, ndabilpuram@marvell.com, pgootzen@nvidia.com, pizhenwei@bytedance.com, quic_jjohnson@quicinc.com, schalla@marvell.com, stefanha@redhat.com, sthotton@marvell.com, syzbot+6c21aeb59d0e82eb2782@syzkaller.appspotmail.com, vattunuru@marvell.com, will@kernel.org, xuanzhuo@linux.alibaba.com, yskelg@gmail.com
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 17 Jul 2024 05:30:34 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f4f92db4391285ef3a688cdad25d5c76db200a30

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

