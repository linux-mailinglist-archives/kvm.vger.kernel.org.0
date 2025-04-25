Return-Path: <kvm+bounces-44339-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 193CCA9D212
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 21:45:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1F6AD4C7A04
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 19:44:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1641D21CC4B;
	Fri, 25 Apr 2025 19:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kc1Gi7W2"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CFC31DF971;
	Fri, 25 Apr 2025 19:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745610288; cv=none; b=WNZxxphs3HbRkX6YjxqgocytUEVbTOpkaIGxQhcfaKQgxttgVjk7ofhDNeZVZo5iEY8kXkYOnd5d4fWRgNZT+NDhkReInEfQaQSYeUdnEeDg7ThtqeH9YTmbJRXQJhfrvAaUCIMHGdOJn/iOuD+lwiswtOMRZJHvS7Qw7Ljylz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745610288; c=relaxed/simple;
	bh=Nk1rq1w1Q4qY7WrJ49YtegS30+z6N/DpaSF8evy+KHg=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=SZSfvW4ftiy2jFPZsTZ0Ye+Na7KeUW5Mqm1kaauYypP8/dv3z5wJ4KRNt9Q2aDHbWFEWUk7VTM4Svw7eBy9Gn4qldFPwiTB3sJGvKXGRRRTh3KxwGxLzn6X3DN3PnEOvf3pEcBLx7oBQ6nn0YhadJ7zFt+3HAiD05OrVoOZk+n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kc1Gi7W2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BE62C4CEED;
	Fri, 25 Apr 2025 19:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745610288;
	bh=Nk1rq1w1Q4qY7WrJ49YtegS30+z6N/DpaSF8evy+KHg=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=Kc1Gi7W2iknL9Pv/6vmgoRKcedBxzRDFYdgezMMFpDpyIoxoMeG1E7K+B0KUmKUCS
	 qMZyTVvOO9avptSoljPPHwKMkJyYUldG2LYhmDypFnnpfjwfssRQsSTtrBzjkgv1pk
	 z2hC5NTHKsD25bkxUPf9teIMrNYh6FhmJdYHR4skLxSDUB8vlywycQTJuE8VAH2uZV
	 ViLcJCMrwX9AIRgRiA73OdEtvTf47HSKJkHARqjeP7ACvuRrla5UxbkXLxgYq+J51w
	 2hOy6qWthWyJTxrVgo6LLORVYAZt3N22f9BfpsCpEbb38ihINP9EQxJZabIMLNoqIE
	 ohZaIXBMWMYPA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EB07C380CFD7;
	Fri, 25 Apr 2025 19:45:27 +0000 (UTC)
Subject: Re: [GIT PULL] KVM fixes for Linux 6.15-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250425162927.404532-1-pbonzini@redhat.com>
References: <20250425162927.404532-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250425162927.404532-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 2d7124941a273c7233849a7a2bbfbeb7e28f1caa
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c405e182ea5092fd34df7e9b72ba00150350c304
Message-Id: <174561032649.3819423.8742133576923699282.pr-tracker-bot@kernel.org>
Date: Fri, 25 Apr 2025 19:45:26 +0000
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 25 Apr 2025 12:29:27 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c405e182ea5092fd34df7e9b72ba00150350c304

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

