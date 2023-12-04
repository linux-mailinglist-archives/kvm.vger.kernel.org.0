Return-Path: <kvm+bounces-3410-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FFFD80413A
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 22:59:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DE55D1F21325
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 21:59:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E13B3A8CE;
	Mon,  4 Dec 2023 21:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MeqkDXwP"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E25BD2377C;
	Mon,  4 Dec 2023 21:59:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6BBC2C433C8;
	Mon,  4 Dec 2023 21:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701727142;
	bh=4akh1rC0M9jmWAqlssoPVtfX3XuQwBwyV+kVe6CKKoM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=MeqkDXwP2g+C3IlQVxb2MPczoqWb43F58+S64DwRa0C96/RgSFeonT54QEStxdh5T
	 efgHyoYJwuk3j5QMp4YQ/6O6aZvtxLW0eFwAXV7caOtrs/mNuiACv0oTvfjl96Ul3/
	 dSkdHKQpdv4lM4wADMSUyb7ocOweooA8hzFzCPQc8cutUPdwIY5yeMqbgyY2/YH3VT
	 A4/J+XtkyIV3Xff7a/PRt4KuNJhtiRfHhUuuIQ8Bycq4fHYgR1UdvRAVDsha+u0+Ti
	 8fTzMY/VKrH7uhfCubpcbnX7Ja0nmJeW+rsjLy8Ryu+RIFnFpFadwCtA6+aLLMvGrN
	 wnGrnF89E0KgQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 58A6AC41677;
	Mon,  4 Dec 2023 21:59:02 +0000 (UTC)
Subject: Re: [GIT PULL] vdpa: bugfixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <20231204083808-mutt-send-email-mst@kernel.org>
References: <20231204083808-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20231204083808-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: cefc9ba6aed48a3aa085888e3262ac2aa975714b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 1e535748449a51842872c46db61525f7524fc63a
Message-Id: <170172714235.21763.13703793577004715330.pr-tracker-bot@kernel.org>
Date: Mon, 04 Dec 2023 21:59:02 +0000
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, eperezma@redhat.com, jasowang@redhat.com, lkp@intel.com, mst@redhat.com, shannon.nelson@amd.com, steven.sistare@oracle.com
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 4 Dec 2023 08:38:08 -0500:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/1e535748449a51842872c46db61525f7524fc63a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

