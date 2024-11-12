Return-Path: <kvm+bounces-31647-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E65D9C6280
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 21:26:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A9938B3FD17
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 18:07:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26D77215C67;
	Tue, 12 Nov 2024 18:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A8N1juX8"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43902215007;
	Tue, 12 Nov 2024 18:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731434843; cv=none; b=F7HSd6u5sNjF8A0zg0yHeXHVYl3lLTfWduhcVZeDspzLlnNfqPkiMYR4p8qWrm46aOfA2ocFvRgHVQxkZ6V7f7CsBHXhlaPxZovWpEdVhYl1XFiGlCTQqOW/jZKaTZ1B4semkOWZjOg+LFdKiax1sJTDpfGLkFCKy90DQs30g9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731434843; c=relaxed/simple;
	bh=YfH1GvXFKsdKUR7M0E2fxAHJRtaL1PPV2LsMW7nnb7E=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=dthvOS75e8k8KrKn2O4iuSbMHzga3hmMBr+qFwA7uj5YaBcRULxdCR0xLXldGSxh4KOAdLf967UAv/sjBxNWzGvY7xn+NqMWkxriUe1I0Ilyw0TwgyX9H0nim/U33r2s4s/VhPuNR1cbLllOi6wFvM0y0f2WyuHfDvnwHfsBkb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A8N1juX8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CE40C4CECD;
	Tue, 12 Nov 2024 18:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731434843;
	bh=YfH1GvXFKsdKUR7M0E2fxAHJRtaL1PPV2LsMW7nnb7E=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=A8N1juX8oS7mci0uA1LWmOIwJnYN/dTzG7Xl1GwrLgifbW4vnChXbb4imPHknhp6E
	 IzK2dguEDPAKvHiVkJ86/WfF2u5Wv3yGcT71EBQdrsWp2au17o9wbOmvI32XKIA2yw
	 7McP/jgLmFZUWMaK0vQKQkfXBjcx/8cSywdxJ8uD3sEP8Rhv5u69WeJCbvGzrSd8+0
	 wNMlHHRGie2AIauCb+Q4pcIzzj4XdX2/8ctZqo3GUfTV7DtvdPgQLiS6/DaBRimYPs
	 QU2ZPgizTgpRidU17FJ6wHWcwNWC1BvyBz8Q/pYAXneItnP/WCYbN+JDGOQ57wMSin
	 AFPjQUCHK81Bw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 71DFB3809A80;
	Tue, 12 Nov 2024 18:07:34 +0000 (UTC)
Subject: Re: [GIT PULL] virtio: bugfixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <20241111085050-mutt-send-email-mst@kernel.org>
References: <20241111085050-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20241111085050-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: 83e445e64f48bdae3f25013e788fcf592f142576
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0ccd733ac99edc473aaee90c8f6adc346d82befb
Message-Id: <173143485302.621786.7229515238200918820.pr-tracker-bot@kernel.org>
Date: Tue, 12 Nov 2024 18:07:33 +0000
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, angus.chen@jaguarmicro.com, christophe.jaillet@wanadoo.fr, cvam0000@gmail.com, dtatulea@nvidia.com, eperezma@redhat.com, feliu@nvidia.com, gregkh@linuxfoundation.org, jasowang@redhat.com, jiri@nvidia.com, lege.wang@jaguarmicro.com, lingshan.zhu@kernel.org, mst@redhat.com, pstanner@redhat.com, qwerty@theori.io, v4bel@theori.io, yuancan@huawei.com
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 11 Nov 2024 08:50:50 -0500:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0ccd733ac99edc473aaee90c8f6adc346d82befb

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

