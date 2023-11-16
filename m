Return-Path: <kvm+bounces-1885-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 972C07EE111
	for <lists+kvm@lfdr.de>; Thu, 16 Nov 2023 14:07:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4C2B51F24A24
	for <lists+kvm@lfdr.de>; Thu, 16 Nov 2023 13:07:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4616430671;
	Thu, 16 Nov 2023 13:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JBmwkGjI"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1488645943;
	Thu, 16 Nov 2023 13:06:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A2F81C433C8;
	Thu, 16 Nov 2023 13:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700140018;
	bh=p4MjUYmwNsoB0zXjL2QElamoa3NDWfUyYXsPy3eVInM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=JBmwkGjIsSE1vcTsOpwTK1gUCAMeXbLozosp2IWfDBGlRfxi3kXwckKu3+iIZsT9N
	 vLqxMktN/9pUTIyq0Q81/B+sN/NxpIzqIt2YuEAxX3dScmd+vDHIHSzUJhrIHRUY7l
	 maZmdKKfKc9gpuIU6jQE9TgRk+iEYlcsyXwHtVg/RRw7+9x7pU8xTSlskLNbNC+N30
	 YmkNuaUA31R6ogLVckBmFCfLeQXY1vURh2Pii4GiTPLMBBrgYEur9cposQpME9XE/2
	 ivAR1q+kLEe6H98Gw4O3ox8dADglM+/H+TsizvaI/DZtgPbHcWk0tl1vAyCXvGcYY8
	 5AcippUo6AmNw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 90506E1F660;
	Thu, 16 Nov 2023 13:06:58 +0000 (UTC)
Subject: Re: [GIT PULL] vhost,virtio,vdpa,firmware: bugfixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <20231114152436-mutt-send-email-mst@kernel.org>
References: <20231114152436-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20231114152436-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: e07754e0a1ea2d63fb29574253d1fd7405607343
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 372bed5fbb87314abf410c3916e51578cd382cd1
Message-Id: <170014001858.19711.13760886707112955163.pr-tracker-bot@kernel.org>
Date: Thu, 16 Nov 2023 13:06:58 +0000
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, alistair.francis@wdc.com, bjorn@rivosinc.com, cleger@rivosinc.com, dan.carpenter@linaro.org, eperezma@redhat.com, jakub@cloudflare.com, jasowang@redhat.com, mst@redhat.com, sgarzare@redhat.com
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Tue, 14 Nov 2023 15:24:36 -0500:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/372bed5fbb87314abf410c3916e51578cd382cd1

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

