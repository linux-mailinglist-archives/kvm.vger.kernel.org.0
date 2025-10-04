Return-Path: <kvm+bounces-59493-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 69B88BB90C3
	for <lists+kvm@lfdr.de>; Sat, 04 Oct 2025 20:18:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9C28F189F6F0
	for <lists+kvm@lfdr.de>; Sat,  4 Oct 2025 18:19:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7551C28506A;
	Sat,  4 Oct 2025 18:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dxmAQ57L"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9300F3594B;
	Sat,  4 Oct 2025 18:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759601906; cv=none; b=i9j3eef/bMHLNG6YPtnALfszcXBFcoMSWztjVFy16hzRqg96u/SCEk04XpZIYaEEJ6Jdz4IC0hbzBzSC1YtY2KIpCJ3sd1fAVnDhWGZqr2KlHF8/XihVMRcoGy19XqNB9aioLSscyDA9LGwAj9NVsEvuKO+tAr7NbADwYOCqlX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759601906; c=relaxed/simple;
	bh=i7OcrDhq2FGhw/m5oLOMq0EFBA0ZUiAzydJLyf54Ebg=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=nHkmrM1vaL9wokvDdbh8io+/X01Mgy0yx9WkAkW9tfGTF1jz3OPRLQtyFTHEiVlbGzbH6ILx7BmGYDh0cADNpgGPrfgScMT8wJAmiQcQSJ1fsOWlkkgp1p2zHMh3eKDwY5pCINj3ohoMvRef6mSIrsBE6phH/+73JWQqLkMjlA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dxmAQ57L; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73ABBC4CEF1;
	Sat,  4 Oct 2025 18:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759601906;
	bh=i7OcrDhq2FGhw/m5oLOMq0EFBA0ZUiAzydJLyf54Ebg=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=dxmAQ57LBAYQcM/H3tJWJaxLiwRj/ym41BGff++pn1wQY/fMiWfvMhMEltvEElQWZ
	 w4EepO7M6iiE161GlkGRKdMgS75KEECpM34jOY/6C4RuSxkabVk6WGzTdPoYIv0Ht+
	 WYNtvikXstg9y63KI0Z0dd/oKf1eNHMkX1w2U66M+0zL+DfCrIB6L8O9JZYDp3CAte
	 DKwfEsfb3ogA+31JA3YiRozPegSiUAbAm9N1rJZcslpcP8BF+b3mDiUOlGrqPCNcAC
	 HTwjmgLroZvgWUKMPAM10YX+EoCCDbQPdIEUA+eq479VHHBWm8FC+3pm914lifEoPG
	 AJg7opZfr9tfQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7298C39D0C1A;
	Sat,  4 Oct 2025 18:18:18 +0000 (UTC)
Subject: Re: [GIT PULL] VFIO updates for v6.18-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250930124221.39523455.alex.williamson@redhat.com>
References: <20250930124221.39523455.alex.williamson@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250930124221.39523455.alex.williamson@redhat.com>
X-PR-Tracked-Remote: https://github.com/awilliam/linux-vfio.git tags/vfio-v6.18-rc1
X-PR-Tracked-Commit-Id: 407aa63018d15c35a34938633868e61174d2ef6e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 55a42f78ffd386e01a5404419f8c5ded7db70a21
Message-Id: <175960189709.404121.13140580536352007182.pr-tracker-bot@kernel.org>
Date: Sat, 04 Oct 2025 18:18:17 +0000
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Tue, 30 Sep 2025 12:42:21 -0600:

> https://github.com/awilliam/linux-vfio.git tags/vfio-v6.18-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/55a42f78ffd386e01a5404419f8c5ded7db70a21

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

