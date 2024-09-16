Return-Path: <kvm+bounces-26955-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A52D8979AFD
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 08:13:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 50FF81F2389F
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 06:13:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4D0413E3EF;
	Mon, 16 Sep 2024 06:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gTjDkVqp"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2105513D61B;
	Mon, 16 Sep 2024 06:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726467147; cv=none; b=FV7+DIt90b7I6Wu9B6pFraEC8P2JSpA0cyi1IO9k41fQwFxMh+wvZi3BKwyYq5P5766l3ot3z3l1jMCXSZ13++yMrdXdF0r3sXNSaPTyXUIkxfevblkwTDixf0yQZZT3sk8pNb0gr3kPRj97bFZHCAf4p3P/4SIRTVIEznckav8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726467147; c=relaxed/simple;
	bh=PxI4bwBFyZh63Bp9syZliPp0NEWWkAV/chRfdCYaKkk=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=cxsBi+ddMXxmuHhS5f5o80UjiBVOyL5zFYRW62F/XOuxydv7xQqtcQ435QsR3XvBJRd1c0juLVylOVtoTwzR0hxVmWFhcy7LYgvSX4UOYDAPbNs14OfES8wHNhnKqa5T15LzGTbuNgQQxDjKW2p5xQXLFPxXteNC4R6dUI5aBSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gTjDkVqp; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E963DC4CEC4;
	Mon, 16 Sep 2024 06:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726467146;
	bh=PxI4bwBFyZh63Bp9syZliPp0NEWWkAV/chRfdCYaKkk=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=gTjDkVqpkQLKaRJYJMSQUca03sjY5NLmy+Qm4hpRqhcGbFKvpScFiclYkk+FK8gqQ
	 e7rTHUICMiSzbVuuDaqLYpkPO8P9wYBi6grVTAcDfs4p29KcSIJz4EoNMNn58yZtVX
	 kaeDUcf4jabMO2Y6CeRDtLetllt0sgnO6JPkBR5F/HLwDpTUbzJY9LUNbuJ0BXR8PA
	 ja/wpnO9qjuyJEdVRMjyLGKFssoY729kmnvHCgfYTib42TCStc+FZWdKxBFs3ktw1R
	 iLwJLS5DVS67W4jakI2LuwiczaVficYWxag6JWCPy4MsYXZn7s7L08ZvmIBZhfi8rA
	 vIJFjhc4aXWLQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADC7B3809A80;
	Mon, 16 Sep 2024 06:12:29 +0000 (UTC)
Subject: Re: [GIT PULL] First batch of KVM changes for Linux 6.12
From: pr-tracker-bot@kernel.org
In-Reply-To: <20240915064621.5268-1-pbonzini@redhat.com>
References: <20240915064621.5268-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20240915064621.5268-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus-non-x86
X-PR-Tracked-Commit-Id: 0cdcc99eeaedf2422c80d75760293fdbb476cec1
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 64dd3b6a79f0907d36de481b0f15fab323a53e5a
Message-Id: <172646714820.3261404.5169800781338971223.pr-tracker-bot@kernel.org>
Date: Mon, 16 Sep 2024 06:12:28 +0000
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Sun, 15 Sep 2024 02:46:21 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus-non-x86

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/64dd3b6a79f0907d36de481b0f15fab323a53e5a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

