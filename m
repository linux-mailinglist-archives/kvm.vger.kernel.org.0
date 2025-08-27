Return-Path: <kvm+bounces-55908-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0298DB38881
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 19:24:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DE1D0202F1F
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 17:24:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 380E42D542F;
	Wed, 27 Aug 2025 17:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mtk9YdDa"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A5B42D061C;
	Wed, 27 Aug 2025 17:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756315451; cv=none; b=Q6jCfY9sy7k9TBYQWHS9eQUNb7aCLpNCJrVXqgMbxv2ku2g3T5h2pxtXmVELaal0y4n+M3KuNfkkedgvPTL/Zt1DYVvhkrXtHGs8JrFQyvjm4mu0Rf2PqqDtAid+d41YRld+4GqeIb7TMMvoDIqtfoNfOJ7DrorvlZUSWSrecLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756315451; c=relaxed/simple;
	bh=3eWm1ndCPbeq4+Uwm7c8oAy0V/FmWVSF4NbyqjdoRrA=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=IPKS2fiWDN8PDlw7upLO82Li3qyzwPLiRaMnxM24jLyba51W7vIkVew64v4HbRGcwkwJi9+rZK12CWQNxtqEoGgbHjd9OBP80t0ikk4Fe8omOy65Hy9LG+GU7T/oZIUNiyVy5ScF20YZJz0/G0Q9zC4wdTYnmcOh4kh9yxlNxiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mtk9YdDa; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22E5CC4CEEB;
	Wed, 27 Aug 2025 17:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756315451;
	bh=3eWm1ndCPbeq4+Uwm7c8oAy0V/FmWVSF4NbyqjdoRrA=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=mtk9YdDaZfjiA5p52xMC5gPa+PC1HAnZ4GTkSKKCt2k1IlsOmsgxNeatDdtsV8tia
	 5sZfHlBdbhrHQxaHs89wA7Z6HCFTcJAHL9Imd2IsM48LQBvvjp8c1cpGh6QEbOUDaE
	 FqvDL/cOQ8mVxc688ufsZoKrb7k31MpPk0QcZczmPmqejhhgmSBisMNe7/7nbrNhEx
	 z/RJB0bvu49ZJS9XSjHgwVLr4AqH1ZfA/AXyLUitFBdO7PnMJrkN/bX+edmaABuVDW
	 qPv3XE5lONron7ScVL6Vy9tz5htFDascGTK7H0khfo6k68jcYPxJE8ebU6wEmLkMo2
	 20cFqV9c45sTQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id AE282383BF76;
	Wed, 27 Aug 2025 17:24:19 +0000 (UTC)
Subject: Re: [GIT PULL] virtio,vhost: fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250827102004-mutt-send-email-mst@kernel.org>
References: <20250827102004-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <virtualization.lists.linux.dev>
X-PR-Tracked-Message-Id: <20250827102004-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: 45d8ef6322b8a828d3b1e2cfb8893e2ff882cb23
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 39f90c1967215375f7d87b81d14b0f3ed6b40c29
Message-Id: <175631545834.782678.18372880333763945686.pr-tracker-bot@kernel.org>
Date: Wed, 27 Aug 2025 17:24:18 +0000
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, arbn@yandex-team.com, igor.torrente@collabora.com, junnan01.wu@samsung.com, kniv@yandex-team.ru, leiyang@redhat.com, liming.wu@jaguarmicro.com, mst@redhat.com, namhyung@kernel.org, stable@vger.kernel.org, ying01.gao@samsung.com, ying123.xu@samsung.com
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 27 Aug 2025 10:20:04 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/39f90c1967215375f7d87b81d14b0f3ed6b40c29

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

