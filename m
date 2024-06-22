Return-Path: <kvm+bounces-20324-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B4B49134C1
	for <lists+kvm@lfdr.de>; Sat, 22 Jun 2024 17:21:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B23751F23999
	for <lists+kvm@lfdr.de>; Sat, 22 Jun 2024 15:21:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BD9716FF2A;
	Sat, 22 Jun 2024 15:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MHKFBZn8"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0956B660;
	Sat, 22 Jun 2024 15:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719069669; cv=none; b=rs9qqQbPywoiagKimIOUmDFTq6IaHN4lZHdhiPJ075mL8L+URIbaSIDYR66b18nuixZH0trv1ctz8MfxCr2/lbuau1WKedfd83UhwTR/ZeOeqlxz0kZTgEJk2xqW2O1hBmkZc+KuEB8utc6P40H8bO43HXlGzGSnKdWPtJB84Ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719069669; c=relaxed/simple;
	bh=reXOg+ZVcl2rfHZSYk6CqaM1Qr5wpQ8KZkToPZt3TKw=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Lty0ogcFQ2YdtMI3afFRJnJY2lz9nQidcFxvFM17ClnzE5ymiL9ojWUAy6hLZOAhZID8lSyIiBSCqLWicZ208ika1J1qeldgBAUySggcqyP9LE1jgj8A6/pOfPGmU+/E9eNoz8wAu/E2XTBo2J6uKPZIoGAoGVGE1sFXK+85V8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MHKFBZn8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id A1BC7C4AF07;
	Sat, 22 Jun 2024 15:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719069669;
	bh=reXOg+ZVcl2rfHZSYk6CqaM1Qr5wpQ8KZkToPZt3TKw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=MHKFBZn8vnQiGDJkjAcYrVTuggVNq+jK83k14FN/CWzkw0Bkra7r27WreB3WOZpFp
	 W70wP87NbfvTToL7E0oG/hsuT/RNNp3JleCEojceruWHYb2ocu28aOyUwtmC6FwiNJ
	 M7AOK842aVwZkgUb8VmrYQ8aDog8HKN0oAsFiOW/qAJbntHO/sEeEUfr50oQz48aAz
	 NHzOm4mSjdo8IjX5i1am0yWqBRS4XJ19zmg8U2HHrUELgZ7JIr2Pb30dr3pErQEmT8
	 kMzCjrd9sjz7eCI5epOS+ZqRGsafrwMiGmmMuOZGWk0ZLoGFLhaHDyED2ugZjWnvej
	 B703/SntJZENw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9853FC43619;
	Sat, 22 Jun 2024 15:21:09 +0000 (UTC)
Subject: Re: [GIT PULL] KVM fixes for Linux 6.10-rc5
From: pr-tracker-bot@kernel.org
In-Reply-To: <20240622064128.135621-1-pbonzini@redhat.com>
References: <20240622064128.135621-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20240622064128.135621-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: e159d63e6940a2a16bb73616d8c528e93b84a6bb
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: fe37fe2a5e98f96ffc0b938a05ec73ab84bf3587
Message-Id: <171906966961.9703.8310033795492598234.pr-tracker-bot@kernel.org>
Date: Sat, 22 Jun 2024 15:21:09 +0000
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 22 Jun 2024 02:41:28 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/fe37fe2a5e98f96ffc0b938a05ec73ab84bf3587

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

