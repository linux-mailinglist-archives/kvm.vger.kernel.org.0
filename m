Return-Path: <kvm+bounces-42974-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F75EA819D1
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 02:25:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 28186466794
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 00:24:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FC3215E97;
	Wed,  9 Apr 2025 00:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tTzaqL9g"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66A082905;
	Wed,  9 Apr 2025 00:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744158246; cv=none; b=bOFCUujDiqxn4LMCVyYEmDXLhAFuPiHgfuk1FTpn+iEupIG9GRB7NmyIRLf4bTY7pd56wtkAoDVjRRn+JKoiAMInkKsDeJT97q/iLh1k1Q3tYM5a9ukA/M4DuQkoK4swGinkY/Ga/RwUi6LpSeRVJZM/kaivG17wJtafA5qH/ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744158246; c=relaxed/simple;
	bh=ZowPEHsmiZMbB04fhvv6MJNQxQaIotoryoftkPUtzO4=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=XnEeL+emPQfCX+d9SGeaAxcHRfp9cqgj8hmtf75HoNslODgHnXIWGm8SNB1tyvBOFuwW/DojNFRJRAQLFowJzIKG/U9hoK/X2fYwm6I6pAbiNfoxipCaYrauSfLri0bCKkwny9GS+ih0gXVKYUbqGK8xQRq1DubjPQntjG+12Dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tTzaqL9g; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47465C4CEE5;
	Wed,  9 Apr 2025 00:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744158246;
	bh=ZowPEHsmiZMbB04fhvv6MJNQxQaIotoryoftkPUtzO4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=tTzaqL9gcmGBvdE45uA09OzgCPUnv9ei+GYIGDgzfzquqha1mRlylwfrECJ9tG0qB
	 KlwtQlg1YC2EKWfHOhlH9WiJWlItftgNxjcKwYADO42PbWFkqemLTpMwDcYH2zJRXz
	 tx7WoN7t2YGvJpfNT+iKMLIelhSegXu1LwU5c1p878ur0Aj/aMuMYe42WfZLtVQgL6
	 P2PiAc8dX/KPrgyIghjn4J8ElHD2OEDJZbWkx6itG0Wvgg6jcjr+RKU+nkuAq1wX7N
	 00HDZv3eYW/0v2M6/4AVYcfvgnWrMfu2hb1k7vsqy4rFk3bxFj75anEgEEkZmG9/q7
	 JU5NGgQY1jhWg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EB43038111D4;
	Wed,  9 Apr 2025 00:24:44 +0000 (UTC)
Subject: Re: [GIT PULL] KVM fixes for Linux 6.15-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250408100638.202531-1-pbonzini@redhat.com>
References: <20250408100638.202531-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250408100638.202531-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: c478032df0789250afe861bff5306d0dc4a8f9e5
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0e8863244ef5b7d4391816062fcc07ff49aa7dcf
Message-Id: <174415828355.2257907.11753314701129732958.pr-tracker-bot@kernel.org>
Date: Wed, 09 Apr 2025 00:24:43 +0000
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Tue,  8 Apr 2025 06:06:37 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0e8863244ef5b7d4391816062fcc07ff49aa7dcf

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

