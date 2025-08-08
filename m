Return-Path: <kvm+bounces-54310-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 47F4FB1E111
	for <lists+kvm@lfdr.de>; Fri,  8 Aug 2025 05:59:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 030A45672A9
	for <lists+kvm@lfdr.de>; Fri,  8 Aug 2025 03:59:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12D941D54C2;
	Fri,  8 Aug 2025 03:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ON9M83+X"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3439D2AE74;
	Fri,  8 Aug 2025 03:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754625556; cv=none; b=seHTQfqrs4WRh06RjBE4Zrg5lgbGO2Z2RZMCsiHTduwStLprnb9rpfxSAhGGq2gxY7K+lQ85ItT8dD8AGAbOwZJ0rAL7rVAVyeJF0us34VQgX0C9EBCn0Bsd3Px14VhtXqRJNo/mtYOR1UctkpVE3cGIFHswX6B24RkiFLYSKqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754625556; c=relaxed/simple;
	bh=ljvdP6Lnfm1PY+j0GIMGtIa6gjo7I2ezz1+J9fW+I0Y=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=F+dZFsgiJYEODOS0GwLZq/Yq0EqGzpswVWQqBdw2xW9NfIjWhDx68df0dPw8mJ526q1381P3m9pBehCKh/biFxYJR2vZGlizJV6beHi3UegSCzDQrEjwmu9ORg0PcTB3lZYQJNVOAa1MNpesE8dNqW/VyG2rlF4xOSiR9VjL1nQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ON9M83+X; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13A7EC4CEF0;
	Fri,  8 Aug 2025 03:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754625556;
	bh=ljvdP6Lnfm1PY+j0GIMGtIa6gjo7I2ezz1+J9fW+I0Y=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=ON9M83+XrEhayMhNPS+DYqM/xZAX2QUjmvIaqnBANau7hdVbSbGjIVhuPSIgAxP1V
	 w4gcxgIWgpI9b5Dx05z610LcKh6LrRO7/lHz6LNwURJEyQhY9LxwT/e1UVfyaAVhK3
	 7YDzgBC6JgbtokQ2hTVMIBOwSxMuqI2dCKKK5ao8q45krvB5vCqZ6a+guxX9iYUdv+
	 9Ty6ayWsvv1L8S8p4xKETc71WaXqJ+QMUgrGyfBeYOMzFaBV6sIxqnhe8NmWJV9O/6
	 D8Bp2O/xORr9+ZqOnPcEbmDFo5C/MJnmqOqAI5JWN/6lXu0VUftAHilrHTElVcE/VP
	 KNUjcsNTEUpFA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id AE0CB383BF4E;
	Fri,  8 Aug 2025 03:59:30 +0000 (UTC)
Subject: Re: [GIT PULL] vhost: bugfix
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250807084721-mutt-send-email-mst@kernel.org>
References: <20250807084721-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250807084721-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: 6a20f9fca30c4047488a616b5225acb82367ef6b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: b1e06c19abd2efbdd080047b2e70195c04ac2139
Message-Id: <175462556918.3795225.10405999923797232759.pr-tracker-bot@kernel.org>
Date: Fri, 08 Aug 2025 03:59:29 +0000
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, jasowang@redhat.com, jhkim@linux.ibm.com, leitao@debian.org, mst@redhat.com
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 7 Aug 2025 08:47:21 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/b1e06c19abd2efbdd080047b2e70195c04ac2139

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

