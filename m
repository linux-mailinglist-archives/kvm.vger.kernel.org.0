Return-Path: <kvm+bounces-39808-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CBB14A4AD62
	for <lists+kvm@lfdr.de>; Sat,  1 Mar 2025 19:36:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4F89B3B60CD
	for <lists+kvm@lfdr.de>; Sat,  1 Mar 2025 18:36:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 054481E5B7F;
	Sat,  1 Mar 2025 18:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XRRedVIp"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B66D1519BE;
	Sat,  1 Mar 2025 18:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740854211; cv=none; b=Gwy0Qt9P36gWcKBfuabk0ZJmkXeoeFB8c1uMURCJQwoAr862T5j+5vEL8M4NKoqwLpP1XNVTvdafZWGveOgO/Nfzv+KGRR/+XXL7mTUacFpIh3mdiXmc4JcS4X9guee755L95GHivA5sJHZ0guuSslBALU5ycvwbMNYO8jxc85o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740854211; c=relaxed/simple;
	bh=dI2Hwo9CzpygTTeDzcXIP5UB49yjMzR6X0UUh+yvk9E=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Vktgsey47qDnGMUH+PDTW511VS7SEMpmEPH+tyoKe9Eg391fX+2HFMXGiqL822jBP/gvYWATUeWEvyYT7xBtuVl1CMQSc8WtRz3XrmhYvT6KVORQ0dyeFVIx2UqZt8UENvmfTfJLh3LFhZn+DNLSrmLB1IrMc1NQ2IeW4kthAso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XRRedVIp; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B0D5C4CEDD;
	Sat,  1 Mar 2025 18:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740854211;
	bh=dI2Hwo9CzpygTTeDzcXIP5UB49yjMzR6X0UUh+yvk9E=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=XRRedVIpDIWzU5mLH7oeZrBLpsJSpiZCDodhuLBAWWUvLwDelf+Quk7Mba86lGonT
	 4tX60m7Hm7W32rgU8tUEG5OjRk5w/ByQfEM7ezd0063hEdNrNELaU3wnegzi3JadO8
	 pbDrHLk7mODCvVnRK2akJRFxJy0h4jsZJ5iwbEOctSLNrRs/GCI0oQyru+PmBn6rxW
	 koRcjmcZstBZecrw/uh+tic39FNH8FdOIHUKVso1Hgpv7oixBKvg1Vq2tNkepIM+k7
	 ydterO/b1CIthc04qspt2Yaj6+kmakZTXA6NOqjFMCyKMQCP6J9orUEovUufB4gv6W
	 evZuijefSBjVA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADCE1380AACF;
	Sat,  1 Mar 2025 18:37:24 +0000 (UTC)
Subject: Re: [GIT PULL] KVM fixes for Linux 6.14-rc5
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250301075732.2438425-1-pbonzini@redhat.com>
References: <20250301075732.2438425-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250301075732.2438425-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 916b7f42b3b3b539a71c204a9b49fdc4ca92cd82
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 209cd6f2ca94fab1331b9aa58dc9a17c7fc1f550
Message-Id: <174085424333.2484297.2895064618693734305.pr-tracker-bot@kernel.org>
Date: Sat, 01 Mar 2025 18:37:23 +0000
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Sat,  1 Mar 2025 02:57:32 -0500:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/209cd6f2ca94fab1331b9aa58dc9a17c7fc1f550

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

