Return-Path: <kvm+bounces-21969-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA3A2937CFF
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 21:38:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 26114B215C5
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 19:38:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B30BA148FE3;
	Fri, 19 Jul 2024 19:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K6qkUcq9"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD03E148312;
	Fri, 19 Jul 2024 19:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721417911; cv=none; b=WAxiPAY+4wXqupgn+u2nMBeBqFAJtbHCqIKR7J9ooA/hRPSsvsewuINsm8vzvavk/XW5KHZTZIHmqL5jNU5XytUX+knaiURuy9tpPLbALvQpGpqln3q9nOzwLdMqGodbkQGkdeIYFMHGH+nHxlROPY10DuQwIlEzCccWpo+kkpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721417911; c=relaxed/simple;
	bh=BQQ4gUyNtdAxl2x8domtZ+ufxzlreqkCZXMkJzDD5os=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=EmBdBhIJEZ0BqGGF4emNKPHQPYCWTXInFK3tUTmtHfphyIpWm8uRVMdO/W1kEOPVGD0SrKDwdxw6SLaoqttTnZXTIYyC4z8LxBC9Qu/8S4R9siNKA1LTirBUxUIY9hG1XbvIDGkf6I4bvF0zV//C9V9V4ThwVkyyUNwDFS5AOBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K6qkUcq9; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id B17F8C32782;
	Fri, 19 Jul 2024 19:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721417911;
	bh=BQQ4gUyNtdAxl2x8domtZ+ufxzlreqkCZXMkJzDD5os=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=K6qkUcq9pUKrYZtgjFvH/ve1UoiRrs61LY6LO/Vjv9ZTQunWwsRDho8RfQOYJv9fF
	 Tj6WIxxUBkV09KEncwPUzc3VcraA6I/3XwSg+GP1eOn2xIqcqznu2Jx62qsZrNjEnS
	 v5766nSCFM+5B442ul4LKOAIhssHotff043IXtrSi6O138tv5tx4x37yrzNRz8Rtrv
	 pqYJB4QUGTV0afnqARcmYkB0HlYgUapxxZvaFHqQ4QOmHPUTfdkBIPNtjj599CwBJv
	 RWwti2G6zjSdDsrK/NkMkNo2xQapBBb8pmtRLXe6m77sG+9TJCCqMhe+mKfE02Tg8i
	 S3X5iLfTebcvg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A8E01C4332D;
	Fri, 19 Jul 2024 19:38:31 +0000 (UTC)
Subject: Re: [GIT PULL] VFIO updates for v6.11-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20240718123535.270f63f2.alex.williamson@redhat.com>
References: <20240718123535.270f63f2.alex.williamson@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20240718123535.270f63f2.alex.williamson@redhat.com>
X-PR-Tracked-Remote: https://github.com/awilliam/linux-vfio.git tags/vfio-v6.11-rc1
X-PR-Tracked-Commit-Id: 0756bec2e45b206ccb5fc3e8791c08d696dd06f7
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f66b07c56119833b88bffa4ecaf9f983834675de
Message-Id: <172141791168.26000.15604863716946823281.pr-tracker-bot@kernel.org>
Date: Fri, 19 Jul 2024 19:38:31 +0000
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 18 Jul 2024 12:35:35 -0600:

> https://github.com/awilliam/linux-vfio.git tags/vfio-v6.11-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f66b07c56119833b88bffa4ecaf9f983834675de

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

