Return-Path: <kvm+bounces-63586-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A206C6B423
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 19:40:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by tor.lore.kernel.org (Postfix) with ESMTPS id 432FD29035
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 18:40:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC8D92DC79C;
	Tue, 18 Nov 2025 18:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uOdXnjzg"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9900C2D9EDF;
	Tue, 18 Nov 2025 18:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763491196; cv=none; b=eMDjfOZxHf0kDJIa6d1JVu43vCFygzuDGpCHackjF8RHQpPHaB5titkauT0cPAuKGQCkhUVOmHgEW8bnr7a7AD0XTO4yfc0O95ajphf97PzL0nLOOJMAxp5P/kbAIdTvMeziSMx/BYIpo+WrWe3+/3GRbk+5+JoMqPoRYf1a5UU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763491196; c=relaxed/simple;
	bh=hnSHWdhSBXMhEnU6t1mm/i/gYTu7XFbGT8VRGvAEpxA=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=P1ur2OdO6u/45S9XQ0UT6ZrYygDrQ3IU3XzDfsftAp0vZKMSk4raEsQpxkVThbJpm8bBVrWKAkFxSXNM1E34wCMDpG78PjuFaN/7yRpfRC8HgeDXHVIlguKGybT4+UGQO7V0wlRF2yZmyEIX4ukHxOk9U+l4d2KgbvFg1R6hkN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uOdXnjzg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A5FCC2BCB2;
	Tue, 18 Nov 2025 18:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763491196;
	bh=hnSHWdhSBXMhEnU6t1mm/i/gYTu7XFbGT8VRGvAEpxA=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=uOdXnjzgeyqxSAdE3b+RWCAR8h8BIdl03/6UtSC2xDsyNWn2NjOZp+TWmrjkja2ef
	 9vkG5uOF+AFd5OXQpVH7tfIngknDnrsLNi4YOhSBWdKB+f4hu4OPN2Jtg1TN+PdA5Y
	 s8oJLEBIXxcHZc0PGDkXbyop7x+V1XRaJ79i+5BMtOkB5yruZBWcgiGmjJan/7zf7x
	 yNAsfaAm4pNunquFk8vuewj3ojWlHlaNGNwf85/cgcjskb6Hh9IwlWnt2qyPabsmwU
	 ZOQYpMIlV/kDXf+rYUKfhZ13hHjn/1la+oRe1DVakBgOgPjIbuSbWHOGWgkIu8ElP9
	 nbMY1XTHqyh/Q==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EB2633809A98;
	Tue, 18 Nov 2025 18:39:22 +0000 (UTC)
Subject: Re: [GIT PULL] KVM changes for Linux 6.18-rc7
From: pr-tracker-bot@kernel.org
In-Reply-To: <20251118175819.753688-1-pbonzini@redhat.com>
References: <20251118175819.753688-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20251118175819.753688-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 3fa05f96fc08dff5e846c2cc283a249c1bf029a1
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8b690556d8fe074b4f9835075050fba3fb180e93
Message-Id: <176349116165.62780.12299818915084716975.pr-tracker-bot@kernel.org>
Date: Tue, 18 Nov 2025 18:39:21 +0000
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Tue, 18 Nov 2025 18:58:19 +0100:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8b690556d8fe074b4f9835075050fba3fb180e93

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

