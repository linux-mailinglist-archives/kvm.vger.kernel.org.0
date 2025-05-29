Return-Path: <kvm+bounces-47990-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CD56AC8109
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 18:39:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 64BAF501EE8
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 16:39:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83BFB22DF9A;
	Thu, 29 May 2025 16:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XTTNDLYb"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DD2522D796;
	Thu, 29 May 2025 16:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748536773; cv=none; b=b5iZw11tk35kmRnhXdG6h/vflQNbf+1QTVsEI+tAPik6o6EkSWp/0E7pLhQNNwegWJM6+My2GZmHrTYqOfmtCRqLnxU5aPH2Z96B+YmXz4VMviSgV/wVO3uoRF4pD9DoI3WAVp3x2JgYIriFvdIjaszuaTwEhwZRmrqhzrlm5Os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748536773; c=relaxed/simple;
	bh=AV7mRmu/eJ0wXPouJqUI5yuujO4QNYzfTIJ7tqJ+ZQI=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=TqDDQPJfcf0AT1JzmCABK2lNUyi0hlViRClrh9qLhVCumcNDUA1d/9iTN8Oo85GvntrFBVsaOZvxkzllNwJ3d2YacOF9Djtz8Gsf9KD7OELm+mAq0z3Tdq3ltC/giRX4EAtY8yQmfMfghWhTYTkxiHTuM7G6/GJC110pq72T8T8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XTTNDLYb; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78857C4CEE7;
	Thu, 29 May 2025 16:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748536773;
	bh=AV7mRmu/eJ0wXPouJqUI5yuujO4QNYzfTIJ7tqJ+ZQI=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=XTTNDLYbJQ5htcIEwZrLRwO+/Y/Hbf1U/LyjubxjR1zyrKnl3+EWuuFffUagEOmqK
	 5bzY3FPryDQTIEStuxG35aqzA/6lx8mp4D1DlAVNbe2eVnRw+b0nqQx2aMqx0CUUbd
	 u7xaR6cjy8LIKGGA6/3ss9lyVrdh5elbpoZCEp9AcfcS6XoGOqlDcp0gNQtSdFUN8Z
	 wDU0srEkvOYTxhPxwgKEfnx5NIJarMmJI2QrrvLOs6WXSt6L4r+4E1qbawQOp+MES7
	 IV/+wjvUhg09ubVL9cQqna+vBxcU7R4fjZ93cG9AUSvJU7zQSQBOvccimWfbsQuGs2
	 mn+zLM2xsUWgg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7134A380664F;
	Thu, 29 May 2025 16:40:08 +0000 (UTC)
Subject: Re: [GIT PULL] virtio, vhost: features, fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250528032724-mutt-send-email-mst@kernel.org>
References: <20250528032724-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250528032724-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: 206cc44588f72b49ad4d7e21a7472ab2a72a83df
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8ca154e4910efff1b04e7750e007d75732c68323
Message-Id: <174853680707.3320073.17659236547655577423.pr-tracker-bot@kernel.org>
Date: Thu, 29 May 2025 16:40:07 +0000
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, alexandre.belloni@bootlin.com, dongli.zhang@oracle.com, hch@lst.de, israelr@nvidia.com, kees@kernel.org, leiyang@redhat.com, mst@redhat.com, phasta@kernel.org, quic_philber@quicinc.com, sami.md.ko@gmail.com, vattunuru@marvell.com
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 28 May 2025 03:27:24 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8ca154e4910efff1b04e7750e007d75732c68323

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

