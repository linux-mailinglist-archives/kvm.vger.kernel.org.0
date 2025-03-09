Return-Path: <kvm+bounces-40529-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B244A5877E
	for <lists+kvm@lfdr.de>; Sun,  9 Mar 2025 20:18:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7B260188B430
	for <lists+kvm@lfdr.de>; Sun,  9 Mar 2025 19:18:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D9FA2144AE;
	Sun,  9 Mar 2025 19:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YZL6CqSg"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 640F9610D;
	Sun,  9 Mar 2025 19:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741547895; cv=none; b=tZPWuyh4++09WAjxOg+N/DUVEe+Qq9Idg9rAzaH+CiBZnewvdJNU1/nhccSxMzNTawZ+KfNGk1dXVPd7hIBQc/fmmyWLnJqNfzp9BhE8IJj/LhS14X4MhXOfNg6eRuMkrSZ0w9sfYfSW29VxOimqm90cSHFm6bSziErntt2rYAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741547895; c=relaxed/simple;
	bh=FgosdftbOwCQyIAPPUMU0zUp4h0QZKMgvQ5KT9oVL4Y=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=pS09jsuGeRdq8dabQHbtHecDK4ZFpc1c5ah3phEtcpoUgIpLO5UomnJFUACoI7FgFTYBpoTS2Dw/AixqPfMsSwFURJVSYMDqcJaGy8CQ3nDMYLWdkzyrQyd78g6nt6hGKuw1I4SyC71FjxlHCm+1jsDdNj5vlM7gZwhrvecJf7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YZL6CqSg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC858C4CEEC;
	Sun,  9 Mar 2025 19:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741547894;
	bh=FgosdftbOwCQyIAPPUMU0zUp4h0QZKMgvQ5KT9oVL4Y=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=YZL6CqSgQNHTH0cIoFRdbTMZ6wbyPV6fjvc6+m6MNW2cUu8D7hMtPMir5fA0IfuYB
	 tPNByDfnJ6iS0nyzvKB50k7rsOJeFZXgvyMbHjF/yROMudZV9o3Oo5Xfw31Ya/VKXT
	 iZjP4ARF9Cg9rTwUso+40nkXt9YDAr7WTJ8ugM8gkhgb64PyIwGOEj6xl7Iv+u4cN2
	 S1INm47dOXiW0qIq44TaWCNl5+LSmdm1lhu+FmnVDKi2QiCoSb2FpYbQLxAqPULeNe
	 xYncfdjaF6RbN6hUFdoXkLr+bRXMEdH283BLNqlrTZb+TghjWrShyts+/IXvap9xp0
	 Yo330AzZLXFGA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EB4A5380DBC0;
	Sun,  9 Mar 2025 19:18:49 +0000 (UTC)
Subject: Re: [GIT PULL] KVM fixes for Linux-6.14-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250309081118.2953196-1-pbonzini@redhat.com>
References: <20250309081118.2953196-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250309081118.2953196-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: ea9bd29a9c0d757b3384ae3e633e6bbaddf00725
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a382b06d297e78ed7ac67afd0d8e8690406ac4ca
Message-Id: <174154792853.2953179.17394782701701666952.pr-tracker-bot@kernel.org>
Date: Sun, 09 Mar 2025 19:18:48 +0000
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Sun,  9 Mar 2025 04:11:18 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a382b06d297e78ed7ac67afd0d8e8690406ac4ca

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

