Return-Path: <kvm+bounces-27387-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D44FA984BB0
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 21:37:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5C1FAB224BC
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 19:37:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19BFE1AC8A7;
	Tue, 24 Sep 2024 19:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CuM/n9fy"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FE2E1AB529;
	Tue, 24 Sep 2024 19:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727206583; cv=none; b=SspemV7rhcLdVYXGx5x15o9M2dFDwMwsWRMaPyh8Un5PQzq7x4BcWtev/8UhE7kcnMvdYXtIAlRUUhDHcDionginTOMqqOEz4gqQtMPLtVgSjmkTWAFosW+QzNx4n5G8zAZDmNxGmHy66UBojBZSuxkBqF5QFPZPfeXaZxqQW+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727206583; c=relaxed/simple;
	bh=0xTfJdT1/GzkyS6PqMIq465To2G4PliHfI40BdKdlxU=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=pQF+Ha7aQ6cDNHMYkHD5vFCJJ5R/S9Fy/A/Hns2SRGEZkvvR5kWLeziLN/GCEaLuZorsFTb+wuvgeBWJwTfYFjf6ngebytthWO6vGiYd4cL8g2uvdaCYhdvs+U5FFpoxDIVB+mwhC0x9qE2vug9Hxq032we2OUKVIqF2rXrsRBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CuM/n9fy; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 483C1C4CED0;
	Tue, 24 Sep 2024 19:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727206583;
	bh=0xTfJdT1/GzkyS6PqMIq465To2G4PliHfI40BdKdlxU=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=CuM/n9fyGtfmyC1WuRp1u0jLIpKedBCYSOiKxp7luTGLJBhEcrN7tXbyJ7xnyATf+
	 ivqQyY86uPPLvD6FZ4CaUu2tQvM0QDEBfpLYA8HbvKrJAlKgXPzmXnts2qVrkOShWF
	 nhxKVwjTbRPZM+saz0YQeDEvQX69he3GvkJN41Bak6WN66084po6lVPFVEvMg59ksI
	 so7re6VOXQRFoDTdyi9aJR5gYq7UDiH0wlPwl+SJCTdDpsMl38YoWl4mkCdb+U6JLU
	 AA8Lj5fX3tq3pqT9TpTmUF2/whPk/+yXAqC50RStLplkgUkl5K8Tw3nFiRvpl2jYpZ
	 UovZZ/CXpIHJQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EB5063806656;
	Tue, 24 Sep 2024 19:36:26 +0000 (UTC)
Subject: Re: [GIT PULL] VFIO updates for v6.12-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20240924121927.07b82b38.alex.williamson@redhat.com>
References: <20240924121927.07b82b38.alex.williamson@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20240924121927.07b82b38.alex.williamson@redhat.com>
X-PR-Tracked-Remote: https://github.com/awilliam/linux-vfio.git tags/vfio-v6.12-rc1
X-PR-Tracked-Commit-Id: aab439ffa1ca1067c0114773d4044828fab582af
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7bc21c5e1f94351b04b6082c16c5d4887c28a414
Message-Id: <172720658568.4172315.12529905809740975243.pr-tracker-bot@kernel.org>
Date: Tue, 24 Sep 2024 19:36:25 +0000
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Tue, 24 Sep 2024 12:19:27 +0200:

> https://github.com/awilliam/linux-vfio.git tags/vfio-v6.12-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7bc21c5e1f94351b04b6082c16c5d4887c28a414

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

