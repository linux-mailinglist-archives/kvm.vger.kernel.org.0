Return-Path: <kvm+bounces-6455-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B137B8322B0
	for <lists+kvm@lfdr.de>; Fri, 19 Jan 2024 01:43:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6A0B828795C
	for <lists+kvm@lfdr.de>; Fri, 19 Jan 2024 00:43:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B06722112;
	Fri, 19 Jan 2024 00:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Io/QxJib"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D30A815A4;
	Fri, 19 Jan 2024 00:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705624964; cv=none; b=WIAias4aU0QML61J9NRTXhspIg+pRo5aQIQz5DP6TV7gC8ly+dvXEvpFpUJJeVjR2f/b7d3ZX1tDNG2pk1iN5CkiwUEpw5zWZGoYyD6AziQwfkxiPFuPYMHKp/MGQt5GhmQKKpJZjiYcSZ17WtVRAVk1gCPq3XFgyo17L3ifQn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705624964; c=relaxed/simple;
	bh=wAfFiwS+y4GzbnfIf20gNvI21wt6KZrRxbm1IOzy4Hk=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Gqhjxw7JF+S5Z0232sJ9tMf/E4ki+8/3n2yFGfOOnwfi91QClxAjlEHSOCi0KgQAR9nFA5SO7kjTDlf5bEF+ilGsTzXeGWx/fc69panpmCLOLEV7zE+MHFJ70ygbBeVWPOVfAxbsegFf2z8aI3PV2jWL7JauZfKPwHQlhLfm/OY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Io/QxJib; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5F4C5C433B1;
	Fri, 19 Jan 2024 00:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705624964;
	bh=wAfFiwS+y4GzbnfIf20gNvI21wt6KZrRxbm1IOzy4Hk=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=Io/QxJibe+eMtKdUyX5pNRyEp5YIw98Juh5qZPvvygF/4TFxb8f2ZPhM/U/IztY9k
	 uw2IS5byReC7zUwSIug6HG8ssgSyNu0Pa/Tv6Q5t/F6fzOAJGtX1DDuc2mLtVjCAX5
	 aK58vokgfHPDbA9TLRcIx+QO3fMA0N1g72TVbAH2x2iNpKxriF9LnSputRMEQbsA87
	 rGZTkX3ZNsmjxEiUubVGOrbZ3CdWxoSYmOQxnce4Q7C6AYzmKZVQiEcWGF3wPRDCtF
	 CsHiyPcluKeAKJB9t0EyZq670y4Xi7ZkHDP4yA1rBweqYZ92W1q86EvP0Yo/uTFbCt
	 oHlfMP0rDrrOA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4ED06D8C970;
	Fri, 19 Jan 2024 00:42:44 +0000 (UTC)
Subject: Re: [GIT PULL] VFIO updates for v6.8-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20240112123134.2deb3896.alex.williamson@redhat.com>
References: <20240112123134.2deb3896.alex.williamson@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20240112123134.2deb3896.alex.williamson@redhat.com>
X-PR-Tracked-Remote: https://github.com/awilliam/linux-vfio.git tags/vfio-v6.8-rc1
X-PR-Tracked-Commit-Id: 78f70c02bdbccb5e9b0b0c728185d4aeb7044ace
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 244aefb1c64ad562b48929e6d85e07bc79e331d6
Message-Id: <170562496431.3707.17399285529633098993.pr-tracker-bot@kernel.org>
Date: Fri, 19 Jan 2024 00:42:44 +0000
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, mst@redhat.com
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 12 Jan 2024 12:31:34 -0700:

> https://github.com/awilliam/linux-vfio.git tags/vfio-v6.8-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/244aefb1c64ad562b48929e6d85e07bc79e331d6

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

