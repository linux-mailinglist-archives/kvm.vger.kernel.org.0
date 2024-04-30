Return-Path: <kvm+bounces-16269-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 43C6C8B80E8
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 21:55:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D7E8C1F25F3C
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 19:55:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E0FB1A0AF5;
	Tue, 30 Apr 2024 19:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OBBuLBIJ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 906C9199E9E;
	Tue, 30 Apr 2024 19:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714506807; cv=none; b=EDEin5A+iRlNi880eF4963ObZMvXjmZZ4hlefj28myBkSAM5YYuDhvunVSEz8sAHGRRqmicPoFpbojYC6Yb3F5j+UNkCjicizRpp3rdt7D8E2bt4/7Tx8Cr72G7NCl+/Y7Rj7gh/7+/gYT515svt19UnkHuOBhvtnK78M2VjilY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714506807; c=relaxed/simple;
	bh=Sn1Y1SSIN2ib/B3HSGAJygyN5WHo5Dvk1NIuPQiTDbs=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=mopX94R9LprHRslhPUyq5OijgdQlbAeEFQkj77HTELRLBrS0Ad1NesxsRWE/hGvLz9EM8+N71o4DHa0Sk40Rw0Js3OjFCqrhiNFx4dJLXwBIOY33O+k/u/cq8gzTH1k5BsMY2DfyNXWAuTJBbfog/NdB5ekz3We0hES1vhl0+oU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OBBuLBIJ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 078A9C2BBFC;
	Tue, 30 Apr 2024 19:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714506807;
	bh=Sn1Y1SSIN2ib/B3HSGAJygyN5WHo5Dvk1NIuPQiTDbs=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=OBBuLBIJyYZLL2u31fakftbbNJhHn7+nBZpgwUU766ufDqy58/Yz5nNKWt6Uc/Xrn
	 xYnVv60ZKwnauKM3sUpVVzdL1idTlaze7y6lkJMI0Es2TIVqv58QJJGxfwzzwYHB95
	 n1gmLJ9WTWEOIBnN2O6LgJHf7uCPgkEkj8C8d2hoZXQGsyLlYKWuQpP7a08gue8iGs
	 o1+eX7rDOv3kUdbFyzLXb7miuMmpxXSS/sauyrETAIgjBpQ295BpUNyLivPgHTXBL7
	 9mAdafs4yWPRYcd1Rr0QS1ESLpiqDPZNT6x2x9NozuILWM6J9vQr0TUfPOrM4ghG4n
	 WigY1jR3p0NUw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EE42BC433E9;
	Tue, 30 Apr 2024 19:53:26 +0000 (UTC)
Subject: Re: [GIT PULL] KVM fix for Linux 6.9-rc7
From: pr-tracker-bot@kernel.org
In-Reply-To: <20240430180709.3897108-1-pbonzini@redhat.com>
References: <20240430180709.3897108-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20240430180709.3897108-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 16c20208b9c2fff73015ad4e609072feafbf81ad
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 18daea77cca626f590fb140fc11e3a43c5d41354
Message-Id: <171450680696.32038.14442315184609210618.pr-tracker-bot@kernel.org>
Date: Tue, 30 Apr 2024 19:53:26 +0000
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Tue, 30 Apr 2024 14:07:09 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/18daea77cca626f590fb140fc11e3a43c5d41354

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

