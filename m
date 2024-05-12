Return-Path: <kvm+bounces-17274-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E2EA8C3856
	for <lists+kvm@lfdr.de>; Sun, 12 May 2024 22:11:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 29486B20CD8
	for <lists+kvm@lfdr.de>; Sun, 12 May 2024 20:11:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E921655C3B;
	Sun, 12 May 2024 20:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="picFkeNe"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1770554750;
	Sun, 12 May 2024 20:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715544680; cv=none; b=mXJm9zj9mwF9Hqt3NAHOaMOUBW++ZMykGBTxhIOtQx4z/B45sTQ8aDHqFm0z8RSbZp1n6+ouctLkDmAKWkz9mQWOR5h231StQ9GVVR03VigI+akX0ppmLKccQ04r8essYTjQlbqFc1z10JOGevvfjPHcjSDdfRiiK2SnmTaB6Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715544680; c=relaxed/simple;
	bh=pHF1vH8cQN56bRf/CcUImOHVIx+ckC3b7O815ZK//4c=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Npzdep7NW0DOj7l/xxQ2MDt8pv6WVgZnU9FaJP7nwr1FU9Pv9M93M5i4ih0g9dMmD/rG8vkh+4HhE0oD/uFaKjCH1MtX74+jSuvWAPVSKzEnoYqrug5G34J8kGpne2t9L4O9RQ6txAb6hwglIacjF5dfWftmCYGZzELJSkLYhSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=picFkeNe; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id E5914C4AF0F;
	Sun, 12 May 2024 20:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715544679;
	bh=pHF1vH8cQN56bRf/CcUImOHVIx+ckC3b7O815ZK//4c=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=picFkeNedxDBAbim2M0wh7hxu2Mb9PbhdWtbDyQeM4pyotTmpBjxxBI+VLdpW3l1t
	 s7obBkQ44rEYNT7mikJtkaX7GFkEksxfCSQ3ra7dRDD1A8QqIV18Uw4bw+/B1aObNU
	 8h8+J/ns2fMkg7avoVs7PAiz+8c6akn9JL7Ki4NbK2jFrVmUd3+1kId/h3/LlhCiEe
	 rfTkzgTBTSoMBFitEgI8oEzCEbUWr6SpjNh2J62nXhQm1GoJnztoanWu5y2r4gwK3j
	 jtgyeMPj2A5u6zF55+HsSxT9rAMX47UJk4FwTtA5OOM3TDomm8isegyngv9ntmImcm
	 yckfJcm6kvHTg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DAAE3C43440;
	Sun, 12 May 2024 20:11:19 +0000 (UTC)
Subject: Re: [GIT PULL] Final KVM change for Linux 6.9
From: pr-tracker-bot@kernel.org
In-Reply-To: <20240512081458.4022758-1-pbonzini@redhat.com>
References: <20240512081458.4022758-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20240512081458.4022758-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus-6.9
X-PR-Tracked-Commit-Id: 0a9c28bec202bbd14ae3fd184522490e5f5498b5
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2842076beb698b8b5f76aa9c987f4aa95b0e74d7
Message-Id: <171554467989.30874.3904173329734105320.pr-tracker-bot@kernel.org>
Date: Sun, 12 May 2024 20:11:19 +0000
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Sun, 12 May 2024 04:14:58 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus-6.9

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2842076beb698b8b5f76aa9c987f4aa95b0e74d7

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

