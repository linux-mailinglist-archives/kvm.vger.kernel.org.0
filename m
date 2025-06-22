Return-Path: <kvm+bounces-50264-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C721EAE31D2
	for <lists+kvm@lfdr.de>; Sun, 22 Jun 2025 21:55:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C5C103AF824
	for <lists+kvm@lfdr.de>; Sun, 22 Jun 2025 19:54:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CB521FA85A;
	Sun, 22 Jun 2025 19:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XeuMDS6r"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B193D163;
	Sun, 22 Jun 2025 19:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750622114; cv=none; b=OqTqJEuCBncNWPbP8ox/QK9Mnxx2pvS4md/d/b1mmgBRuhGy5d2vr2qltFibD0KX6TwKdvzP+4oI1aKfOEtPuz6SwohkI8M39yU4kG2/2gdOp8EUqbR6Z3hniZqKIQTcgKO1dBe5ENRksHERw4X+tfSkpZDroidNGtzzfxNO9t8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750622114; c=relaxed/simple;
	bh=bDTCzQiDM3TrIueTN/wC8gyKnuT1wEe8+J9kDycX33Q=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=ukbgOfDA420m/LF7i07pCQOjDAkG4YMq97tCBHKzyFK9QMaFGRjTA8cv+YV2wjE28q8lkwOHlSRnhR2MAwRCxSC5vLJPbrWvACj90+Tdw2gXNYP30xfWwr9Etf3UZrIH85XK2LLWD+qVO58peSveaOUhXy3uIa0Er5ThzVSDPZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XeuMDS6r; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91099C4CEE3;
	Sun, 22 Jun 2025 19:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750622114;
	bh=bDTCzQiDM3TrIueTN/wC8gyKnuT1wEe8+J9kDycX33Q=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=XeuMDS6r4GsJSlhS6CZkzDri4MlmzALmEfRexZ4N/selHI0HVkA2AAxnuLB3jYPgp
	 E0iin5ArWyhPCQdBbimDYNb/Y753Y1t1Ncz8s2bDL52DvbasfWvgtuTig27Nebg1ED
	 MuLOIB6mFHLjy52Mg/kFBEsTNwiX+rRkzNyww6ouKjySIPn7z8B9PhjlUOJkJnNyg3
	 FzlFfguSypTbWkXFufOoLjnB7BxvgVJQa+CY4dS4rTTSDSOvQ3Cc+S/j63dKTbN6QO
	 Yvnm3mdUgwV7VQJc3YXT4oR7ANIM6oPGpVCiA3FJM4cqUg9lWBPc3YwuU5x8zwqTW1
	 oWonLxdgIB2rA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33E2039FEB77;
	Sun, 22 Jun 2025 19:55:43 +0000 (UTC)
Subject: Re: [GIT PULL] KVM fixes for Linux 6.16-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250622073328.201148-1-pbonzini@redhat.com>
References: <20250622073328.201148-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250622073328.201148-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 25e8b1dd4883e6c251c3db5b347f3c8ae4ade921
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e669e322c52c49c161e46492963e64319fbb53a8
Message-Id: <175062214185.2132065.3237496525781193982.pr-tracker-bot@kernel.org>
Date: Sun, 22 Jun 2025 19:55:41 +0000
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Sun, 22 Jun 2025 03:33:28 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e669e322c52c49c161e46492963e64319fbb53a8

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

