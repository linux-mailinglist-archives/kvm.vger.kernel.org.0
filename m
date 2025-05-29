Return-Path: <kvm+bounces-47991-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 29DABAC8110
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 18:41:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1B9961BA89D3
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 16:41:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BB0822DA03;
	Thu, 29 May 2025 16:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kzpl3vsI"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C6F1362;
	Thu, 29 May 2025 16:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748536884; cv=none; b=aKjptb4ejppnSgS3t4KQsYi58tc9XWYHcGZJ9G26KSO2J0ZXdI1GcMbCUdYu2RrBjx/zx6Zf7PbNgJYbopPU2eRDYadtiRbKUowADDoHtkT72hXjMC0XYcYDtmCw8ElceuLZmeA36YJO4aVH2/wYMudDqK7Y7bejr2cXSVTePZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748536884; c=relaxed/simple;
	bh=qnw7mE6VR/cF8SJ5dx8gOVUWZbrCj5l1an71R/J6OEE=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=e2MADM/pwqGsVZR1r/YJLVly21YVrEqNXEfJdjDXvjOutACDFaiaCBBuhoGIzic4FsSCYvTgmd7snHX3ZE7Z+me0awwQkB6M14FsryIPJquh7EhZxPutgSX7bI+TBX0v8FGhOT6JiWekbKdmfXkRri8fK4oBolF46+/ei3mL36Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kzpl3vsI; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F0C4C4CEE7;
	Thu, 29 May 2025 16:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748536884;
	bh=qnw7mE6VR/cF8SJ5dx8gOVUWZbrCj5l1an71R/J6OEE=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=kzpl3vsIC9lSeTZDWuYPfgb0cDHeE+1oOj39OH8mw3RaBuPO6XMxMF7pTFXXcSEFo
	 /gQcLsa2fx4YyGq2/f3ylxPb6coD9zMH0QNf+a/UVxn1/4sJcHxbWBeaqPwULbocLr
	 lSzdcLi62/+ey1vbEd+b5IiSSDu+U6vdfJLX+IKE3rsl+Kq9VqbNYy4+/vVDpQtICp
	 xbr9TBC8eJfo+DE9Lhyg4SRX1tZyg6geYlBxpwjTTX3pIvMDDFABMgiEOSX2wFUAvH
	 dX+hSrN2JUvhPCE6fEDV7BQLj8eo3XJap7ntDmX9Z5SOJZvKoQQgAomZKfedAFmFRc
	 2TYMNLiNXYuwQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EB266380664F;
	Thu, 29 May 2025 16:41:58 +0000 (UTC)
Subject: Re: [GIT PULL] First batch of KVM changes for Linux 6.16 merge window
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250528172432.8396-1-pbonzini@redhat.com>
References: <20250528172432.8396-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250528172432.8396-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: e9f17038d814c0185e017a3fa62305a12d52f45c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 43db1111073049220381944af4a3b8a5400eda71
Message-Id: <174853691754.3320073.1602185763371516740.pr-tracker-bot@kernel.org>
Date: Thu, 29 May 2025 16:41:57 +0000
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 28 May 2025 13:24:30 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/43db1111073049220381944af4a3b8a5400eda71

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

