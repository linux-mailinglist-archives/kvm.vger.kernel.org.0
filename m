Return-Path: <kvm+bounces-58786-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 62D56BA0A4E
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 18:37:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6A314621F20
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 16:37:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB450307AFA;
	Thu, 25 Sep 2025 16:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tIWqlZ8H"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E18AD2E6CCF;
	Thu, 25 Sep 2025 16:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758818247; cv=none; b=oE0n0coZyOPmNDVq47xtTxaajg6xta9QoGs4h7/lNuPnqNnvvAZF9+mJfW5S1kQeEZPmMLUwypqxDPsEcCFOye4RTvYtb/rYt1bpPyAcfnglJNeeBdj0ai/FfIlQyERsqWp3BM614wJFqJqtN/ZMqeFsJMxoNlYjECgifZqrfB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758818247; c=relaxed/simple;
	bh=9tcBYDdZ4S6nbwrUFIFB3h4QO456zS81f4jRq6orFXs=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=mFmbdgeEBe73P3MjLwj5EVatZNTgDj+WaSdAXRzolGaC8oRZK/SRa8+P7oUhAP8vX4CBXZAkMyargN3BNaWwQnAt+op1HESxxhtra3/1EAaV1/3OyAyOytXWuzfRTpwXUOtlhiX0H1wZiXPZi/CYiS80U5151ZUmSPKPpYrFhE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tIWqlZ8H; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C267CC4CEF0;
	Thu, 25 Sep 2025 16:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758818246;
	bh=9tcBYDdZ4S6nbwrUFIFB3h4QO456zS81f4jRq6orFXs=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=tIWqlZ8HejUNKANLk/MejQIG4f/GpvCn/AESrfpzylBzsxhFqdnjwRwkLIZzi6Yqk
	 pHq9ww1nIRPbxalyOiv2W9QRxxt8jOMzVfDxRrFncI4MYqevMCkYHLM81S+eCvG45S
	 jCFlYDWhpGf5GTrk24CWmPCV/kw8nPlM5sBWL2KIsYkRpkvvrOvLOfEEge0emW4IQ9
	 H2qOij0Dj3PBFLiQWgaXPgrqzLN43MwGNKY+Kxb6msaVyGtkb5LrTH1lMspRdDUUAZ
	 cWgnfnNqxP/z1KriQhw1WGFNK+xZwNCicT7Y83tCN3rYzN5a7zVTWKTTdJAqYwgEiQ
	 7gFXWkmoQVb7Q==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EB13E39D0C9F;
	Thu, 25 Sep 2025 16:37:23 +0000 (UTC)
Subject: Re: [GIT PULL] virtio,vhost: last minute fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250925091012-mutt-send-email-mst@kernel.org>
References: <20250925091012-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <stable.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250925091012-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: cde7e7c3f8745a61458cea61aa28f37c3f5ae2b4
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 93a274456158f178aa713fbb60642e0094e6065e
Message-Id: <175881824263.3435360.2694015779934794373.pr-tracker-bot@kernel.org>
Date: Thu, 25 Sep 2025 16:37:22 +0000
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, alok.a.tiwari@oracle.com, ashwini@wisig.com, bigeasy@linutronix.de, hi@alyssa.is, jasowang@redhat.com, jon@nutanix.com, mst@redhat.com, peter.hilber@oss.qualcomm.com, seanjc@google.com, stable@vger.kernel.org
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 25 Sep 2025 09:10:12 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/93a274456158f178aa713fbb60642e0094e6065e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

