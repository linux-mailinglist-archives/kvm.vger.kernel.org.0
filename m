Return-Path: <kvm+bounces-6411-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 43A3B830EBD
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 22:47:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D8DD21F219A7
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 21:47:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 088A428695;
	Wed, 17 Jan 2024 21:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o+sqG+Ag"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 303122561B;
	Wed, 17 Jan 2024 21:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705528015; cv=none; b=dT4vDjYs3teBzVQR5w97Fh2mzeCZidy410xBfWNc0Ocx2614sFenCeyid3X+pLyvgxDyzlKQzJ+nA109HJZn/zXaRTX+5Y1MBGQJxxAirpq9pL8Qe3VuDn1Cn5oAAO8zyvFHee3YlvtGch8dG7XZFAor5jQSfsbPA9a1fki58Pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705528015; c=relaxed/simple;
	bh=KC/Mvme2sAJVxBH3+nBuIJtmttQck3mkEqKBqWlbRZk=;
	h=Received:DKIM-Signature:Received:Subject:From:In-Reply-To:
	 References:X-PR-Tracked-List-Id:X-PR-Tracked-Message-Id:
	 X-PR-Tracked-Remote:X-PR-Tracked-Commit-Id:X-PR-Merge-Tree:
	 X-PR-Merge-Refname:X-PR-Merge-Commit-Id:Message-Id:Date:To:Cc; b=l7gOaipeavKWULpPh7e9JaNmKX71oSOmGnrOh8wqyCvYaizrosKoA5Ev3fxdSC8CYA7jAD2Rq94JHNRgaHI7kXc0xFGUTn6hsh40kq+wDdb2OTU0s16zdJPAqb5pQzgHGGa51+et+EzhlRt8kRS3+9QrKVtdyT/OCDGFw6XSa2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o+sqG+Ag; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 09829C433F1;
	Wed, 17 Jan 2024 21:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705528015;
	bh=KC/Mvme2sAJVxBH3+nBuIJtmttQck3mkEqKBqWlbRZk=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=o+sqG+AghYXgrNRg39GHRJQoJlhR/vMRKWVfBV3oVWRWfwZGhWpm1hLe+1E0W5kR/
	 DeAe4KyhJkoWeMEvyNhUFbV35COhlNLGl0PGMhgiIR0sKHlirIii/2kDXG7IiSN0lm
	 3h1C92DqVTywps1LbJyoJyy0GZy3m9JMjtS8q7PeYkNyT+0P0gsv5BlThA7Mjqxn0i
	 pV6Xb+uML3U+SyRFIOubgkm9FzqtIIRJl6Uk7Zw7C/fA9KvrlVRiXCuyy5gG/F4Uxt
	 Wm3GyTlzZbvjsob1Ni/KSUPbzgMz5G12d29hDdXh6dOcd/B2j/XzUxg4ioKzDpggbm
	 jqnyCllFtAGAA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id ED2A0D8C978;
	Wed, 17 Jan 2024 21:46:54 +0000 (UTC)
Subject: Re: [GIT PULL] KVM changes for Linux 6.8-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20240110101653.830047-1-pbonzini@redhat.com>
References: <20240110101653.830047-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20240110101653.830047-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 1c6d984f523f67ecfad1083bb04c55d91977bb15
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 09d1c6a80f2cf94c6e70be919203473d4ab8e26c
Message-Id: <170552801496.31446.11256952375024171201.pr-tracker-bot@kernel.org>
Date: Wed, 17 Jan 2024 21:46:54 +0000
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 10 Jan 2024 05:16:53 -0500:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/09d1c6a80f2cf94c6e70be919203473d4ab8e26c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

