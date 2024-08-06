Return-Path: <kvm+bounces-23427-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E80B4949787
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 20:25:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1BBA11C206A8
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 18:25:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 531357AE5D;
	Tue,  6 Aug 2024 18:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HuLFwHdB"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63CCC28DD1;
	Tue,  6 Aug 2024 18:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722968732; cv=none; b=tWJAIBd6KfRRPa7h8BLnE5fdNyhrVf+ZAHFf/WPz3qn/McDeufXRV8ha59phXdP7PvyJ7g5wXOxdn8BuEErig5QmGxyUecFmFJ83Dd3rWu6iJeo89Kf1IXVQn+ncmr9dhEKOxk05jUm+c/m6gXe/9Ke0e55/qcYdDoWWQ3s7liQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722968732; c=relaxed/simple;
	bh=iU42ztsF59RemOZGmfY9bIY+jPcLw4R8DUsI3VzS39Y=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=DHKIdFns1AkoLH2WReKpO24xbD7VswVj/lPOdPCLVDuWBb0hL0/iPRGuVrnTjnEj/dfgEHshDIIBAgSassUao77pXX2GH9fJcO1V/hDXc7RDFY5ISDRV32Z+qdRSCWfSfln3kBLeQlo31w3jLTw6eLPSF1ZiBWm4E2dyJ40iKUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HuLFwHdB; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41DB8C32786;
	Tue,  6 Aug 2024 18:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722968732;
	bh=iU42ztsF59RemOZGmfY9bIY+jPcLw4R8DUsI3VzS39Y=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=HuLFwHdBoQA2ubJAqanE2ACb+DrYwGWc/hkRREtpq/34TCH/0pHBbQ3FEVm/C7F7t
	 qwtcgEPysgBxWIIQdnqRb0sancQfuhFz1Dvs/1yfTv7lfXCqzzKa+wW1Phj7JoyGpg
	 lxizAKOfUUcFyl4U3BUWr5aDGPXlFwA/rl1KO48tPMbxCFdXMmWHPogVLSHqZ0jewg
	 Lh5AozScJTZc2Pj48KLmNky4mH9zcsgedGLKzOFtCENarbR5vvBpQnSz0xoMu4tE5j
	 WOEeIh8FlLjxXMU8qJJxknY1qO9DObu+KKDcEwaFzuEhQSK3jjMFF0sRWN+hUhHLFi
	 gsCEEcVgW2WDQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33D9F3822F99;
	Tue,  6 Aug 2024 18:25:32 +0000 (UTC)
Subject: Re: [GIT PULL] virtio: bugfix
From: pr-tracker-bot@kernel.org
In-Reply-To: <20240806135722-mutt-send-email-mst@kernel.org>
References: <20240806135722-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20240806135722-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: 0823dc64586ba5ea13a7d200a5d33e4c5fa45950
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d4560686726f7a357922f300fc81f5964be8df04
Message-Id: <172296873074.1388134.15266811486107132547.pr-tracker-bot@kernel.org>
Date: Tue, 06 Aug 2024 18:25:30 +0000
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, dtatulea@nvidia.com, jasowang@redhat.com, mst@redhat.com, stable@vger.kernel.org
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Tue, 6 Aug 2024 13:57:22 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d4560686726f7a357922f300fc81f5964be8df04

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

