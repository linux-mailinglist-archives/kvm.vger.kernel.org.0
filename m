Return-Path: <kvm+bounces-33828-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 423409F256B
	for <lists+kvm@lfdr.de>; Sun, 15 Dec 2024 19:45:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E14761645AB
	for <lists+kvm@lfdr.de>; Sun, 15 Dec 2024 18:45:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E9241BD014;
	Sun, 15 Dec 2024 18:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hP3jFiPu"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A2C1BBBF7;
	Sun, 15 Dec 2024 18:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734288322; cv=none; b=UGbdTi0RZx1EZWz+GP4m9ZAKXe76i3MFaAdXYZUdYg9OKneV4FzgEujy7uHUezqT1E3ttE0ur8kkCCd2IIkyqzDQTqhPc8TzwB55IJmdRpXcgEANjCZhvyL0UaANMhbKTxrsAWyQEwKiePUxf2wD55eYlpymc3X7mEKwoE4A3Lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734288322; c=relaxed/simple;
	bh=db21HdDJjRE9Gm7rY4cNTJT0QygzJu5zBIZGzYZ4V6M=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=huZqvgXBKVg286ix4cU18X2JcyHu2VoPAQn+rOcdNpcTgxAfkczP4JVv/8Jz+2jFNqgVFOs4PhFMPdSj7P+LXmKIQDbMMv+whML4TQpOZhMFaAZl9XDPEluh3sdDE8ysQJZhH2GNXGJdshXi7dBoaNCBdu30sbTDXI/ziVpmUGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hP3jFiPu; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51572C4CECE;
	Sun, 15 Dec 2024 18:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734288322;
	bh=db21HdDJjRE9Gm7rY4cNTJT0QygzJu5zBIZGzYZ4V6M=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=hP3jFiPuBADz8m/U0aJjBJM824TNKZ02JpFlgM7JN5GdOOjYMu4E90lRI5BBAur/r
	 d+EU0j8+1skb5ycHYSO0SgC+C2bt12AKWY/0QuPQrmN9oi562McS0st/u+san3t2Qz
	 GmVlHy3Hr3oUZTH2e3/qSA4C1jL2zyKFFUf4TnXp+xl4l6N7ztKeHXY15JST75gqq0
	 su4RkSjJrfbN3r4Ho8/TcV9YkhvbKFpkcvyMpIwM6qkd5mv+kZRmWY14NTzqJlSosH
	 4Kzl3JKd6kerKLKDxLXDptykWuxEhjKvRN/M2IF1eYnvN5HoZVZth2ZWoxhoyQ8VMQ
	 hnGmr8s9HKdZw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70CED3806656;
	Sun, 15 Dec 2024 18:45:40 +0000 (UTC)
Subject: Re: [GIT PULL] KVM changes for Linux 6.13-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <20241215084339.319122-1-pbonzini@redhat.com>
References: <20241215084339.319122-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20241215084339.319122-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 3522c419758ee8dca5a0e8753ee0070a22157bc1
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 81576a9a27dfee37acc2f8a71c7326f233bbbeba
Message-Id: <173428833904.3562041.16948021306791905624.pr-tracker-bot@kernel.org>
Date: Sun, 15 Dec 2024 18:45:39 +0000
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Sun, 15 Dec 2024 03:43:39 -0500:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/81576a9a27dfee37acc2f8a71c7326f233bbbeba

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

