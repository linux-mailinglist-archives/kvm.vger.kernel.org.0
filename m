Return-Path: <kvm+bounces-26029-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B018996FCAF
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 22:28:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 66A381F255B8
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 20:28:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8039B1D86F6;
	Fri,  6 Sep 2024 20:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RZI+ALMx"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A61B21D67BD;
	Fri,  6 Sep 2024 20:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725654494; cv=none; b=fbPQl3PTqegd3QesV8mJd+8KyfZzPgAmLR4UICkdzXzADomW52x47EsLJb4s1DPoVMHtJUafJ0Tg9w+ixeUH3mr3O75C369CyyQMFIWjk6FhX4wWltZjZP2aEjk6IsH0TQc/9H8cnoq9w3mmihVRBhtV8mrZKl6hgUibrv5bFsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725654494; c=relaxed/simple;
	bh=ouCfRkTNDIuv96CGGzkU1jq0KUrJI96ccvRbsDBKyzg=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=YyIuqz6Do5Hj4CgXP+g2in0LAWKTHIjF75d0JNlS1UxQLkGf6jW3uDXCtZA9t25wgHVy9t34NUqarPYtWPO1YHwUXE39PU216CysCmbJAEngdtE43aYMmyeMCtF42/m+nx0Do+iLVdmOhmFVP4x0+uYgBVCbd9tf7WQ81cBzuBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RZI+ALMx; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87F0AC4CEC4;
	Fri,  6 Sep 2024 20:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725654494;
	bh=ouCfRkTNDIuv96CGGzkU1jq0KUrJI96ccvRbsDBKyzg=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=RZI+ALMx9c6u1jz9XqejhEHyNFk5b4vog8PJNl7YLHcyix6JpqEYlxzbPLo2X9jwq
	 hZIEFu0eYsgd74sJbmQD+hJgR2GgsShhGkyE1zz9lEQCVLNfMDkpYMnHgN/94fT5Ri
	 6oDAa8a8RXnYyOOiW9z7XVbVZm0cEB5gqKAJVYL2n+ewtLq4qqWY5z9AZ6D2br//so
	 qEsWwKKJ2rv8cLllX5l/osfuCdTPBOkrep4w862uOMgjL3/iVvN9s/1U0Me7/SQ0Ax
	 EyjigFTThP7v69V9/szNnpTpcBg6qXFVhbBybnSEGVNtjm565SQUM/1iYQDh61bbDT
	 0EXJNlgZ6p6lg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADD113806644;
	Fri,  6 Sep 2024 20:28:16 +0000 (UTC)
Subject: Re: [GIT PULL] KVM fixes for Linux 6.11-rc7
From: pr-tracker-bot@kernel.org
In-Reply-To: <20240906154517.191976-1-pbonzini@redhat.com>
References: <20240906154517.191976-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20240906154517.191976-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 59cbd4eea48fdbc68fc17a29ad71188fea74b28b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d45111e52b81e0da6307bde9de8f2a5ac72d9ca9
Message-Id: <172565449528.2515438.733530337643143549.pr-tracker-bot@kernel.org>
Date: Fri, 06 Sep 2024 20:28:15 +0000
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Fri,  6 Sep 2024 11:45:17 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d45111e52b81e0da6307bde9de8f2a5ac72d9ca9

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

