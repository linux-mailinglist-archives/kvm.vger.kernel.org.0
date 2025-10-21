Return-Path: <kvm+bounces-60721-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C850ABF9109
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 00:36:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7B2B63BEC43
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 22:36:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11B182BDC1B;
	Tue, 21 Oct 2025 22:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Er+BFMlj"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F5CA27FD51;
	Tue, 21 Oct 2025 22:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761086162; cv=none; b=kc4TY9ANqMb6LN2YeX6JlteT0wx/NotSyBeMwVRANHQY6V6J9Tegs+sEN+w14gM+Nrz0drHCDoGArvEknruIUL2brNVrg9yxtHyKzAAlBU0vwsvwEAq/xk/UtRduWeBu8dwjRi+hw5zKl4HtcqSAxCPFmGmv1rVdYOG8nb+r9QE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761086162; c=relaxed/simple;
	bh=MxAt8xltWszjH26vXEAy/z42CxXmERcd6R4DQnzgMQ0=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=TIu3xgfqpVtO5XcyAwT1Co1Snk9+XaoyxXts6cEv87XmfL4baly91Bi6CCfKUt+dPhGPYBrK2x6iKjFGwBU1VwodCtlRju45suv6witBt6QbV6yEeHwGdOzCZiyZZH8UHzDwBjSkbiXcYpdsxxiMpz4DI/H8EuHjW2bvYHFtSXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Er+BFMlj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2B44C4CEF1;
	Tue, 21 Oct 2025 22:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761086161;
	bh=MxAt8xltWszjH26vXEAy/z42CxXmERcd6R4DQnzgMQ0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=Er+BFMljl5cm7i6NmsGG9XqnHG8nhMSyRnAP/lOmjOZsBLW1sk0I8IBoH9/hbuxUv
	 rERVnNwaVVHlE6DnnHozdFkNKYI4Z5+FIz4xanzeOwEDYsJhcuJQkMHd2g2OUzuKIW
	 8ZGwDX1rLAup9ZNSrQt4PgtecEHaSBjgw9eGoC1gtEvc3Sy1vXRSZmSJ+SIO6pNWk1
	 MpwdydJf1hbsgsb/BR0AfyaVwyjbGj8uktUeE4yYErJbcWYDxbjiy3GVN9MVztoecw
	 iapYtGXWVqf6nYjxT+AuGl3/9qDd3jQtpkpnXHkqf2JvZRRJfzLYP2ugxx/TBYnx1Q
	 tqFQ+FGlm9IZQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 342493A55F99;
	Tue, 21 Oct 2025 22:35:44 +0000 (UTC)
Subject: Re: [GIT PULL] VFIO update for v6.18-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <20251021115615.4e5dd756@shazbot.org>
References: <20251021115615.4e5dd756@shazbot.org>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20251021115615.4e5dd756@shazbot.org>
X-PR-Tracked-Remote: https://github.com/awilliam/linux-vfio.git tags/vfio-v6.18-rc3
X-PR-Tracked-Commit-Id: b2c37c1168f537900158c860174001d055d8d583
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 552c50713f273b494ac6c77052032a49bc9255e2
Message-Id: <176108614284.1257044.6335388980314648589.pr-tracker-bot@kernel.org>
Date: Tue, 21 Oct 2025 22:35:42 +0000
To: Alex Williamson <alex@shazbot.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, alex.williamson@redhat.com
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Tue, 21 Oct 2025 11:56:15 -0600:

> https://github.com/awilliam/linux-vfio.git tags/vfio-v6.18-rc3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/552c50713f273b494ac6c77052032a49bc9255e2

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

