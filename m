Return-Path: <kvm+bounces-52931-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EB685B0AB33
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 22:51:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 314E217E24F
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 20:51:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D51FA21CA14;
	Fri, 18 Jul 2025 20:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oYYlwviy"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0791C1CA84;
	Fri, 18 Jul 2025 20:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752871852; cv=none; b=pHSQj4Bo2cNGXKGXzz0k71ZsF9mEc3nj2rQByg1jGf+GSuQAZ0PfG04g/6VM+lB8KIwE1jdDaeKssSFXcyjgqDRO6xrMyAeIMIQhLtiCOzmVmU1Obivz6422rE5MI2XZJw9+XtAgavq5OrhqYdz3gUQUaBPZgCnwOOeVHjYfbN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752871852; c=relaxed/simple;
	bh=NWearn8MFz7DQ5cO2gemZS4+vEBVqz6QUuFY3s2HRZE=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=lnw5jMZwzIRP7WqpsO4BGok89u1XFpVy0BbQpPZo7mJDA51ub546VUa03FCBauMXJSEx1kWYBzAtvtOIVMkPDi1EYscY0GLze7XZD8DgvQBjf2o00+hhl1yXfeTdWtuY5PjVSZoY2KPjuYouFxXGhwkbBt4tk27ngOy11U/jVNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oYYlwviy; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA8DBC4CEEB;
	Fri, 18 Jul 2025 20:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752871851;
	bh=NWearn8MFz7DQ5cO2gemZS4+vEBVqz6QUuFY3s2HRZE=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=oYYlwviyD/xL6bGNmoirTRTM0u+g/5X4TXUj9MBtDA7c+7drfwcnATHaM3aUmfpxl
	 Rt9oBv1uPVrNTg7zpZi2+bhUcV/fByW/atcAWzpl/HRcGMkH8AhMrAZyMa3/sY4dqz
	 7usLw4tX4Mmn+ui+KXH0MDnEYiz7/elDhtzLNtQhD8g7SUGUIb6wl7cFCO+PqHEbfI
	 ykAa+OOMNkhEiuTCvXH2FIUms4IcL3R3xE0TKbFx8UBwikOW1lUvCsOIkP59c1ko3r
	 O4WFzoMgQTW/VRxVfWTJU4SV2lpM/mfcbI43vnNswxZlU5SaInabGbDbmIyF1BYqFA
	 Eec5WkA8C/HZg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id AE0A8383BA3C;
	Fri, 18 Jul 2025 20:51:12 +0000 (UTC)
Subject: Re: [GIT PULL] KVM fixes, and documentation changes, for Linux 6.16-rc7
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250718145026.179015-1-pbonzini@redhat.com>
References: <20250718145026.179015-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250718145026.179015-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 4b7d440de209cb2bb83827c30107ba05884a50c7
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c7de79e662b8681f54196c107281f1e63c26a3db
Message-Id: <175287187116.2789450.10008898222047090293.pr-tracker-bot@kernel.org>
Date: Fri, 18 Jul 2025 20:51:11 +0000
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 18 Jul 2025 16:50:26 +0200:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c7de79e662b8681f54196c107281f1e63c26a3db

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

