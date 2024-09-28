Return-Path: <kvm+bounces-27645-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 46E92989095
	for <lists+kvm@lfdr.de>; Sat, 28 Sep 2024 18:46:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0209D281421
	for <lists+kvm@lfdr.de>; Sat, 28 Sep 2024 16:46:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30D17187861;
	Sat, 28 Sep 2024 16:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y0j5fGKh"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56DE71865F6;
	Sat, 28 Sep 2024 16:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727541915; cv=none; b=W/tLCsl3tmdknXZsGWWeq74FLaGQgdZqod0RVme6na/+zoadbpMrpwhHZ3xN99WAu7sTQzAlDAzyLwv31pb4blbuhMLRt8sLyjCnSUq5jO+r9Mw8G0KuR6Rk+chrs2CxDfEkiZ5xDNCMsgQIyJaqe7LEwarNiwjASTK5wnZQ2SI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727541915; c=relaxed/simple;
	bh=obB9ZBsesxXaAxs8hrO4DYdTVgeIenw9QLBKy4kVAPs=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=E9VvMDPAPAx+Ga8e+gudiE9Bl3haI/PtjYW5lR6696opennmjTMr3ZwcyJq1T0HOdkmbHS4AoVO34y4HLykLjrlw/LQzap6aqutsu4ILAuXH/ZYaemBIZOMV5uGLxCdReYtBJOj833HRG3EflsflNGCGOJ94OhlvwE3GnvQTrXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y0j5fGKh; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B35AC4CECE;
	Sat, 28 Sep 2024 16:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727541915;
	bh=obB9ZBsesxXaAxs8hrO4DYdTVgeIenw9QLBKy4kVAPs=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=Y0j5fGKhrUcTeCYu5UEIwgHje61ft32jnPSIwWMQUWq0dNIKkulUcF3dKzKvJOAFH
	 zi2nVk8az6wWHEKcVQZNqkh4IP4GJ1286wQefWh5qf1aBASFNeNeNKPCwl/hwFDsTW
	 mkQ7CjXQpJLDr9cxuai1YaLya61/0xWwo0DosMIs2PrXBE88R/4HSe7TDOIHshu0tV
	 /shQFlyLIfZh5aHp4OWpupjsAz0SK6ZIsBKYvjTAZrDiAAZ/hrla2lr56/tyBYaCGq
	 srHycsiOvuT/1Uz9/Hk3qvSGSYo+bHa5sCL6Dijkjxg1tzHu5wUqaTlEZfYyvdrD3E
	 BVl7AtPCBI5sA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33FF03809A80;
	Sat, 28 Sep 2024 16:45:19 +0000 (UTC)
Subject: Re: [GIT PULL] KVM/x86 changes for Linux 6.12
From: pr-tracker-bot@kernel.org
In-Reply-To: <20240928153302.92406-1-pbonzini@redhat.com>
References: <20240928153302.92406-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20240928153302.92406-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: efbc6bd090f48ccf64f7a8dd5daea775821d57ec
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3efc57369a0ce8f76bf0804f7e673982384e4ac9
Message-Id: <172754191786.2302262.6073223623361742953.pr-tracker-bot@kernel.org>
Date: Sat, 28 Sep 2024 16:45:17 +0000
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 28 Sep 2024 11:33:02 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3efc57369a0ce8f76bf0804f7e673982384e4ac9

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

