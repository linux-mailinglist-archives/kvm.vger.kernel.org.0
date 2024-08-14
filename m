Return-Path: <kvm+bounces-24197-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 633CD952440
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 22:54:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0A2C21F28B17
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 20:54:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA7CA1D1F56;
	Wed, 14 Aug 2024 20:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fRkGAP8s"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDAA21C4603;
	Wed, 14 Aug 2024 20:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723668668; cv=none; b=FvjqlBfHvNv/77rFsT+DWS0LMAK/VnsNf/LAFlAuewiX7dP0Y7ilYyJkydI+FMhjOZsA4vg3/oXE8FQGzU77bgMYDBjpjZUuk0aLbVJa/47sFtnesUPVpl6XXnYFLzNvW8UcP4dAkPCF3QaNqXnWxgF39xIXScu3uaZkEFpT1JU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723668668; c=relaxed/simple;
	bh=SGp7ihp501vNVxMuCOsihJIVMZwcFxhUpY/7B9rJYk8=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=pM6C/PrYCEybX6HEDz1XHADuSVKPJCNDzaZh/mtAq3rAWy+1r+brCWiQOTGAOXgoU8XD76H/4Z88Sr3IIVOgMySAYFYPKliR5jRyUcqqzZ25aipLfnMR+gl3s9e7SSCM/c7AGd+reloJSzgcuJ9VWTpj0oVzclfk2+clzhjc0xY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fRkGAP8s; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C054DC32786;
	Wed, 14 Aug 2024 20:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723668667;
	bh=SGp7ihp501vNVxMuCOsihJIVMZwcFxhUpY/7B9rJYk8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=fRkGAP8sKM8VerZfQu82ca6TvEevkDRw0t44F++3DJvqJsxyGmdT1T/rM+p3rRxqR
	 rIzLkT+4ZPXw5/jtb8u2oaI/KtfAJS78iVlSISzoBvM48ehHPv/F8quR1OwDUNql7+
	 IAvVPDzlFsVuRQ5pTBVeOcRU/GjhjSmKapl3JWxUz1zTjTbBx4Wzl2rJ6RTtZPX1KG
	 lcu3ndxTWJuJTzEUi0VrP00mTe83WzsqRyjtQ5nVvFc0DKFaiU5y/77JfIOHMtF8Tz
	 KT/jcl2MDcq64d9vHa7fnyhsObGPC/OS6ztSKyRpdkKFbyDqDTdU1aYoifHBH4vk8G
	 L4ixpWCTc3s7A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3456538232A8;
	Wed, 14 Aug 2024 20:51:08 +0000 (UTC)
Subject: Re: [GIT PULL] KVM changes for Linux 6.11-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <20240814183348.148233-1-pbonzini@redhat.com>
References: <20240814183348.148233-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20240814183348.148233-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 1c0e5881691a787a9399a99bff4d56ead6e75e91
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d07b43284ab356daf7ec5ae1858a16c1c7b6adab
Message-Id: <172366866676.2382938.8788479646921026.pr-tracker-bot@kernel.org>
Date: Wed, 14 Aug 2024 20:51:06 +0000
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 14 Aug 2024 14:33:48 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d07b43284ab356daf7ec5ae1858a16c1c7b6adab

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

