Return-Path: <kvm+bounces-22015-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A9E609382C7
	for <lists+kvm@lfdr.de>; Sat, 20 Jul 2024 22:02:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1C4A7B214BE
	for <lists+kvm@lfdr.de>; Sat, 20 Jul 2024 20:02:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2AF114884F;
	Sat, 20 Jul 2024 20:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g0CxAQXt"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8BD984052;
	Sat, 20 Jul 2024 20:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721505719; cv=none; b=GNOZto5Xk7Yawwv7ZA0Qp+UwMnhAhUo31NQP6EIgKr3IllpHOlbub4UME4DWumX6Y8wtjZN1mTyKVKKSrUGhtMCVaAunjJGPOTpzDPO/GXNziZStjHu+tDHDO2xdY0KxhF3/WYJuZT/r9/+H9Ii4K2DhNVCN5RcWh/dN5n98SFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721505719; c=relaxed/simple;
	bh=NPfqvLukHLyqn/0FhQvEpjMaLyjd2ZvMvmSgk8g8dkE=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=PVoI9x8N7iqHrFJHFMSU2WevGjyD7/Smm3qT33KScWQk3T/zG2aRWhEGnBh/efPZ9v7QkbHmfDQSJ68WT5LpgwFPBilVeZ7ikMvMqILOcH106kmJYLJJAacB5iwo5xk4sGnygXLnp4afgg4ZEQdDlWXzCwRk2Yhmf3C1lx3o+/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g0CxAQXt; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id AD388C2BD10;
	Sat, 20 Jul 2024 20:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721505719;
	bh=NPfqvLukHLyqn/0FhQvEpjMaLyjd2ZvMvmSgk8g8dkE=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=g0CxAQXtmWcek5I6MJn4m+SJhz4vn8orBU/cWLa6yeAgoHvUXXtMnYprXXaT8L/OE
	 UDJSxDA7Yt72xUy2iwfkiJ4X3T0VGw32aT6KTrTtsZJEFE6YzwfVT3sugXNhW9MInk
	 8+HgqWeNFX17FeefXu7Px4qy+anbvspjmQucq+iCzf+I4sEuivdJAqrijRxG/JQL30
	 g32D4K7EkyJbSVvkurI2wtFlg+pnBGiAaC+D4MO01O6qJMgo/TOF382ODjBEesT71h
	 M9ZXgeH8QOIvgim16QuRD83J7+XfmEXaaUaWtNmw3IovLyDKb71RF6Q2o9JJMSBBrW
	 NM4D2jl3LZbRw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A44A4C4332C;
	Sat, 20 Jul 2024 20:01:59 +0000 (UTC)
Subject: Re: [GIT PULL] KVM changes for 6.11 merge window
From: pr-tracker-bot@kernel.org
In-Reply-To: <20240719145339.55027-1-pbonzini@redhat.com>
References: <20240719145339.55027-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20240719145339.55027-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 332d2c1d713e232e163386c35a3ba0c1b90df83f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2c9b3512402ed192d1f43f4531fb5da947e72bd0
Message-Id: <172150571966.22424.13265747310916028300.pr-tracker-bot@kernel.org>
Date: Sat, 20 Jul 2024 20:01:59 +0000
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 19 Jul 2024 10:53:38 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2c9b3512402ed192d1f43f4531fb5da947e72bd0

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

