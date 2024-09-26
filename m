Return-Path: <kvm+bounces-27570-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3710E9877AA
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 18:38:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4E7D81F22889
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 16:38:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E24615CD6E;
	Thu, 26 Sep 2024 16:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iJbzHoSr"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B638615B551;
	Thu, 26 Sep 2024 16:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727368668; cv=none; b=n6QxZSXimsnvEAoxyJ2UOEOHDBZ3CrMKT4Usl/5cEY/pMe+GCK+IPCTfbtVb36FniQ4OJMNMtbkRXO8ms6M3rq1ukyZBqZn1FSCfPN+F46uHE7KCloblNiKdXGSyYTacLg2bNgk1BuQ+Uy07rYd8iu0dyNEBUyKW2OLVO2RbBZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727368668; c=relaxed/simple;
	bh=DeJLVfa+98msi+WOdi6aZw7WZW+rjhDtw9LT+pzpoOo=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=tNTLs4LZ/WTE8whh9aziTK/Wb+eN9HRwOKpVtzRuIFhgDB9yIdfne9FlmnGLB1egFhcokmaVxAhTOgUb6MlDm04cu5mRnBEGZ1u3eE/Tu0FNrxDpKpdiiOH+Kde+1mJAzkY8whjQz8Rb5jEJiWkgqAhwsNeIGx+n+lhA4ID65Os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iJbzHoSr; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5738C4CEC5;
	Thu, 26 Sep 2024 16:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727368667;
	bh=DeJLVfa+98msi+WOdi6aZw7WZW+rjhDtw9LT+pzpoOo=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=iJbzHoSrdvQ+e+RNwota6cvSa9hKcDOOPpEyHz0PotTZMeimzmouwxMfWQP1+TbjG
	 yiLXOQNsPNVw1UGnm6gja55mpHSS3IqabWs2ceQ5wH4RdivDjsdSj6w/omUhLmjhQr
	 X1B9e/UawSw6vkmJnYZUxJwPTjezctVk9QfZ34r89r7yMrM7mJoE9i6wHNgEgm+jqk
	 6fqLhOr1GpMUGxyzUu8kPpl1cRd2t24kteZUJKcU6bi5qjtXU7HGxW2o2lLIsBiJy9
	 UM+DNs/M+Js1/SHmX1uh6ADT7LhQX+jBNjaOVnp+7I9/StVbYZSg617Sb6tbUPs9Ip
	 tNYXbirX8J6sw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 710F8380DBF5;
	Thu, 26 Sep 2024 16:37:51 +0000 (UTC)
Subject: Re: [GIT PULL v2] virtio: features, fixes, cleanups
From: pr-tracker-bot@kernel.org
In-Reply-To: <20240925070949-mutt-send-email-mst@kernel.org>
References: <20240925070949-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20240925070949-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: efcd71af38be403fa52223092f79ada446e121ba
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0181f8c809d6116a8347d8beb25a8c35ed22f7d7
Message-Id: <172736867005.1312674.17372931311041898879.pr-tracker-bot@kernel.org>
Date: Thu, 26 Sep 2024 16:37:50 +0000
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, david@redhat.com, dtatulea@nvidia.com, eperezma@redhat.com, jasowang@redhat.com, leiyang@redhat.com, leonro@nvidia.com, lihongbo22@huawei.com, luigi.leonardi@outlook.com, lulu@redhat.com, marco.pinn95@gmail.com, mgurtovoy@nvidia.com, mst@redhat.com, pankaj.gupta.linux@gmail.com, philipchen@chromium.org, pizhenwei@bytedance.com, sgarzare@redhat.com, yuehaibing@huawei.com, zhujun2@cmss.chinamobile.com
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 25 Sep 2024 07:09:49 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0181f8c809d6116a8347d8beb25a8c35ed22f7d7

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

