Return-Path: <kvm+bounces-46125-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C501EAB2A4E
	for <lists+kvm@lfdr.de>; Sun, 11 May 2025 20:39:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 897727A3D2B
	for <lists+kvm@lfdr.de>; Sun, 11 May 2025 18:38:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 732A025F968;
	Sun, 11 May 2025 18:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dV739ZUj"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95EFB18BC1D;
	Sun, 11 May 2025 18:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746988762; cv=none; b=SSeow/jdVfTSJ+/o8+v/9ZPYuK4l5gFfCXfr3V1a3MWg35qx1birsgB6GAnDEJ1NOQAVF444O1b26OP7m6QlDBwhOZgGMnVoQjd1QDwIBUQoXfjlW3HURq9lAmILEM2d01Jqyi6UDOtgrsooRI9Bgu2ewJxLT6e0FdM18U0IMYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746988762; c=relaxed/simple;
	bh=Fm8Qmue4vd3P36ZJfzYg/7cv/1oKQx1YcTD/jG24/Rc=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=gPwioLqAhUSrH45l0X3+Z2w73nPYdPHahkRlf0l+UWNRYo2Z7pwD4ivWsWJkeZHOSB8rP7X0zedFSgIzCUEWhwd6jHRvO0sSsLmPP8c7D4f56nLp+N45hhc9OGd7mO59NBks5ukfGRdlJwu57bQLFvcgNqt8uzaui6tsxA2OeKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dV739ZUj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77AAEC4CEE4;
	Sun, 11 May 2025 18:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746988762;
	bh=Fm8Qmue4vd3P36ZJfzYg/7cv/1oKQx1YcTD/jG24/Rc=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=dV739ZUj5Gnj+h9oBEs6Sj52G+xp9swbqOvvutf5mMYgSjVVrQJumpg/gNGANDQOf
	 8qMqdIQAdoBOiaw6WtqSGUVBaiRUxmZqqI1HiwWThNx6R8k1tJR08NGSJvkPKMe7Rh
	 /E2cxEv9086iyJ1pms6siE0f+bN1+klf08w+Ix6tiWUcZjG1OJ2OwpshB9hDBqlQhF
	 rFJARVDRmJ9K6Auuo2tv4J5GqbQ9W7bmvRcdLy74AV2EUq7FXba2i6p0TjzeRYgRmU
	 WBLD0Kpl+pNNth/D35WG8N4HjB9OYXrbjMSXRDzWEj3+jfwdYx7rSXrigqxvfudtkF
	 kOktGLHb5WNGg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADDC93805D89;
	Sun, 11 May 2025 18:40:01 +0000 (UTC)
Subject: Re: [GIT PULL] KVM changes for Linux 6.15-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250511112225.47328-1-pbonzini@redhat.com>
References: <20250511112225.47328-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250511112225.47328-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: add20321af2f882ad18716a2fb7b2ce861963f76
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: cd802e7e5f1e77ae68cd98653fb70a97189eb937
Message-Id: <174698880021.20988.4431164883451742152.pr-tracker-bot@kernel.org>
Date: Sun, 11 May 2025 18:40:00 +0000
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Sun, 11 May 2025 13:22:23 +0200:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/cd802e7e5f1e77ae68cd98653fb70a97189eb937

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

