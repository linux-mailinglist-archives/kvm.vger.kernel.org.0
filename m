Return-Path: <kvm+bounces-630-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C622C7E15FF
	for <lists+kvm@lfdr.de>; Sun,  5 Nov 2023 20:11:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 720872812AE
	for <lists+kvm@lfdr.de>; Sun,  5 Nov 2023 19:11:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81A0B171B4;
	Sun,  5 Nov 2023 19:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FyVuPQXT"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29721C8F8;
	Sun,  5 Nov 2023 19:11:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6F1D9C433C7;
	Sun,  5 Nov 2023 19:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1699211477;
	bh=fj+FVGAWPpO8O4n2zH2qGswvpwohotxhcBOI/kdauVY=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=FyVuPQXTNhrbM6b1buXlqxjijt0f3WQu4hDFcnkGkk6C95speJxRgwIVZvadxu7eu
	 pFHOYDTMnm6pwwL8Uw76DtzjVF9ecKGQ8Hb08qc0F+xpZ9l+nmME+wwxr7aW1DNkwN
	 MYP/uubV6iV5/oQoYRRr7CDTUKR9IUsLmtxV6edyE4lR/wdwkuBT0wFrCWr/neh1ci
	 zppVp8hFNVXLFakiCgEtfaN95w0dJbXn4U97119lF92QaLfmgMVRjwJ9F5zisHvUvx
	 D+fR5pXZ/0NGnah6TmaXTBtO54db+qnenYKyIybqoFQFExaM8RDV+XU39QVoQ/H9ca
	 1vcGqKszp2adw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5B186C395FC;
	Sun,  5 Nov 2023 19:11:17 +0000 (UTC)
Subject: Re: [GIT PULL] vhost,virtio,vdpa: features, fixes, cleanups
From: pr-tracker-bot@kernel.org
In-Reply-To: <20231105105806-mutt-send-email-mst@kernel.org>
References: <20231105105806-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: Linux virtualization <virtualization.lists.linux-foundation.org>
X-PR-Tracked-Message-Id: <20231105105806-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: 86f6c224c97911b4392cb7b402e6a4ed323a449e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 77fa2fbe87fc605c4bfa87dff87be9bfded0e9a3
Message-Id: <169921147736.31662.3355128222514557498.pr-tracker-bot@kernel.org>
Date: Sun, 05 Nov 2023 19:11:17 +0000
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, xuanzhuo@linux.alibaba.com, geert+renesas@glider.be, kvm@vger.kernel.org, mst@redhat.com, simon.horman@corigine.com, netdev@vger.kernel.org, xieyongji@bytedance.com, xueshi.hu@smartx.com, pizhenwei@bytedance.com, linux-kernel@vger.kernel.org, eperezma@redhat.com, leiyang@redhat.com, gregkh@linuxfoundation.org, shawn.shao@jaguarmicro.com, virtualization@lists.linux-foundation.org, leon@kernel.org
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Sun, 5 Nov 2023 10:58:06 -0500:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/77fa2fbe87fc605c4bfa87dff87be9bfded0e9a3

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

