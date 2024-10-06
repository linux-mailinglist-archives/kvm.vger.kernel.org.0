Return-Path: <kvm+bounces-28040-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 36EDC992090
	for <lists+kvm@lfdr.de>; Sun,  6 Oct 2024 21:14:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 54FE41C20BF0
	for <lists+kvm@lfdr.de>; Sun,  6 Oct 2024 19:14:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D25018B485;
	Sun,  6 Oct 2024 19:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SdzogdNG"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C063189F2D;
	Sun,  6 Oct 2024 19:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728242025; cv=none; b=XZ+mmeKctVJGq7vUCSZUwfZBFD2McBq0nUjPetkZNmDDdsAl1WFpt/FY9I+A3/XoGbbBmi5uktBREHqsKaJh+ya9rT8p2Z0Fz15cKmhj84KyoE8johG2kYrSrFQNymf/bGuaXSSmSAv5z903uNNRVis+su2fen9i3MGXlb94dj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728242025; c=relaxed/simple;
	bh=fVbaj72A3ZbJszCYgWr01JEmzTGXe22UNSJDDyaYiYU=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=grOibfKDIW15CkwEk4Chpa0ZM3tiWaygykJQbWBSi8JmSZcnbjSkPQZJendmUbpiRv0QokY1im/w4EoUT0nxblhO9UPdqSV+P/NjEtJ9EiDR/gI3/585Tgc59AZVJz9JguCsqNZc+xwQF9Oo43vZH6u7773Y+QlhB7tqw27+wwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SdzogdNG; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F64BC4CEC5;
	Sun,  6 Oct 2024 19:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728242025;
	bh=fVbaj72A3ZbJszCYgWr01JEmzTGXe22UNSJDDyaYiYU=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=SdzogdNG0+7MvfSVjAeTDHfL26QKbqsMzWr3H7NJJviWfbcoPJSaE6S2a7G/vbhNW
	 rqte3wpbU97pJtP/Q4ZR3EtzfRxlPhBR8Xkf0NnIbqzEIaeQdVoLnldWA1EzepSR+F
	 CvobQgAXOhwU+5zWWzWZ7Ah6tboVpHEjloTTpxIoyfnI42Cm5U1Vkn0JBdTvHT9paV
	 XGAGQlWZ7/dVWq3T/W+TN0VfKQUmAcjUyDb4AOgsrRDICNK/oqkIOAyuh9hgCSJLt8
	 +/20x/JqEef/zBYu4rzFgQ7MeSKKxghQl7lx4vsEJYFiygXoqFCX5ltJFq+oylMzNK
	 G+Rz3LNkpBRGg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70DDA3806656;
	Sun,  6 Oct 2024 19:13:50 +0000 (UTC)
Subject: Re: [GIT PULL] KVM fixes for Linux 6.12-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <20241006103814.1173034-1-pbonzini@redhat.com>
References: <20241006103814.1173034-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20241006103814.1173034-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: c8d430db8eec7d4fd13a6bea27b7086a54eda6da
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4563243edeeb3dc17355a80ec16bbfdc675702cb
Message-Id: <172824202894.3486601.3453862399020632512.pr-tracker-bot@kernel.org>
Date: Sun, 06 Oct 2024 19:13:48 +0000
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Sun,  6 Oct 2024 12:38:14 +0200:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4563243edeeb3dc17355a80ec16bbfdc675702cb

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

