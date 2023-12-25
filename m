Return-Path: <kvm+bounces-5239-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A74F581E2F8
	for <lists+kvm@lfdr.de>; Tue, 26 Dec 2023 00:32:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3689B1C21315
	for <lists+kvm@lfdr.de>; Mon, 25 Dec 2023 23:32:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F177F54279;
	Mon, 25 Dec 2023 23:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BFyLr59Q"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 154492207A;
	Mon, 25 Dec 2023 23:32:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DE4BCC433C8;
	Mon, 25 Dec 2023 23:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703547128;
	bh=PGXjSb2z/+GZe8RbxgK5X6umCs2Bx6W20pluRRv2SoQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=BFyLr59Q0FMINUyAkHQkeekRtlNktmxI6fybR3nafrm/2tGwS8xLhakq3bWoBJ3gH
	 m0yPCJtJAXdGl3Unf0AF6hyeCE7PMlcGd/UtWGLtPoqq1YODe+Wjiptdxa4a0m7jRq
	 VCB+WL9T4A1Jmb60WcVJ7ssECjRIwkTJNLmhtVDcdVD2ftAA+JGPORIiv3lkmycQnI
	 fBsJRHPgT7GKx0T+S878nPtSPlik+HhXWv2rCTfDuXvoNtcaPJQtwhvSMygiqZbGCu
	 ArO3AbNkmkGmIMARqZfAuSdFRH5V+M9TcJNXAfq88MZmtPpdPYowRAPZTj77leW1Zg
	 LMnVBYwInFUtQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C8EE9E333D5;
	Mon, 25 Dec 2023 23:32:08 +0000 (UTC)
Subject: Re: [GIT PULL] virtio: bugfixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <20231225082749-mutt-send-email-mst@kernel.org>
References: <20231225082749-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <virtualization.lists.linux.dev>
X-PR-Tracked-Message-Id: <20231225082749-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: b8e0792449928943c15d1af9f63816911d139267
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: fbafc3e621c3f4ded43720fdb1d6ce1728ec664e
Message-Id: <170354712881.9636.17664823386333098363.pr-tracker-bot@kernel.org>
Date: Mon, 25 Dec 2023 23:32:08 +0000
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, hongyu.ning@linux.intel.com, jasowang@redhat.com, lkp@intel.com, mst@redhat.com, stefanha@redhat.com, suwan.kim027@gmail.com, xuanzhuo@linux.alibaba.com
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 25 Dec 2023 08:27:49 -0500:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/fbafc3e621c3f4ded43720fdb1d6ce1728ec664e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

