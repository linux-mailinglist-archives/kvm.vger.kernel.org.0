Return-Path: <kvm+bounces-43994-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B60B1A996A9
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 19:29:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A46191B8639C
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 17:29:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B0F728D852;
	Wed, 23 Apr 2025 17:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EvatOY7j"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD6EC28D831;
	Wed, 23 Apr 2025 17:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745429344; cv=none; b=KGcnFyHv0tGxcI4ZXcymThxe54bhYrTXA4sSre9xlrgpSRoaRNpfSF3TF5iiK57WwUfWxVV73DyEhEov3rJmAv0RSzu2+eO2dcPm363korJVWqoICXigYCz4rf34Fj/vOoAKmtJvJchSlA/4L1uCRG8N3uCmXURrfO8UunrJfEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745429344; c=relaxed/simple;
	bh=vlh4+BR1H/RmxNREq1KSV9QK1KeKmMVnQikynmcuhwo=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=jPjOZgJ147LM2gjPafIY5mV7+JnEKxcMa9qgRZMG9A1Hma17UbIl/aqflh0IjqWbX2J6YXgwCsF7SOSDJisXmSZ1J3qx5h8cJYLmWzLldM07n5TRM9nHk5P+ynPx1ZxH2bGKsttlzOHTtH3oCFxZsvu35pdZzS2uCxu8PFOIpn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EvatOY7j; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AA69C4CEE2;
	Wed, 23 Apr 2025 17:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745429344;
	bh=vlh4+BR1H/RmxNREq1KSV9QK1KeKmMVnQikynmcuhwo=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=EvatOY7j4yFv4XGVGP3rNEdg/WKME+vsbamFNlzOONW7QA8WC2SVwQYVbLVtItU9c
	 nI7MSrPUcMdNxrj5PaIFmpCudbbBbjLQt6iAzDWDXpjNxQRtwz4BgmqDcIafWyGNJ6
	 Etvuga9n13LB6xyr8GSQH6RRpJBZ7sSqTTZANjmJzHo6SyByVMDMhcqcovZPHMEF4e
	 3M+WqNF1OPH1SMrEiQWRmzTu0gpn1BhvGFJQ9w1pGV14qHGuw+x/YCwTvaijd8fgMT
	 0+tCyJlNXblO+0wdqPfpymr3kcTekTMZtf6NLNIkbUnTgVwqpcLb2/82am44eacyA7
	 OvjXbylSjPxNA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EB0D9380CED9;
	Wed, 23 Apr 2025 17:29:43 +0000 (UTC)
Subject: Re: [GIT PULL] virtio, vhost: fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250423024239-mutt-send-email-mst@kernel.org>
References: <20250423024239-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250423024239-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: 58465d86071b61415e25fb054201f61e83d21465
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0251ddbffbeb213f0f74ef94b2cacce580eb8d76
Message-Id: <174542938258.2710377.13663228633712440875.pr-tracker-bot@kernel.org>
Date: Wed, 23 Apr 2025 17:29:42 +0000
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, danielj@nvidia.com, dongli.zhang@oracle.com, eauger@redhat.com, eric.auger@redhat.com, jasowang@redhat.com, jfalempe@redhat.com, maxbr@linux.ibm.com, mst@redhat.com, pasic@linux.ibm.com, quic_zhonhan@quicinc.com, sgarzare@redhat.com, syzbot+efe683d57990864b8c8e@syzkaller.appspotmail.com
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 23 Apr 2025 02:42:39 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0251ddbffbeb213f0f74ef94b2cacce580eb8d76

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

