Return-Path: <kvm+bounces-64595-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id AB54BC88029
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 05:02:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 633B83556F1
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 04:01:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27049311975;
	Wed, 26 Nov 2025 04:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Le8gsF2f"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4681F3112DB;
	Wed, 26 Nov 2025 04:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764129665; cv=none; b=O5D/3dCsfr+3do8YiMEq49KsXAYx56Ebo989ozhpjghDlUyrN0JYjsu0qI9wazK/QWAbqY+qJUsIAM1O6eMMB4w9b+zDErVOwMGs5QwviyVYnZt5bGBww2KuwarKrd+WaSz6r1pW3SoXTIy1Fy0puIpFg475VxsigPRW+too/04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764129665; c=relaxed/simple;
	bh=e66W30nBm93lSeox4A0GZFfHktSjddRZJws2hous++Y=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=c3liPkIqu/Vmqi7CtjRBZ5nEe2QNHDvakcCynFez0KuToOVpfRtVFFQ49kDvTKTNwgITJm9W4XLzxUu7bTioJwC9yfQGWP+PR4tt4M3r3F0p1A7ANqxa81uoyzsfcGmJDcAI3ZTxWdx9aRhP0oiqbrGEUKELCg2w5kZcrwYjR0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Le8gsF2f; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA401C116C6;
	Wed, 26 Nov 2025 04:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764129664;
	bh=e66W30nBm93lSeox4A0GZFfHktSjddRZJws2hous++Y=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=Le8gsF2f2odt9z3fNK9mprG0lWvNfxD3cW4POqW7GXP4b01gf/v7c3NAocSYOd94k
	 v1xh7p8tCFaD0czlXv1X4qTCoR6A+bwg+GebAbRf0bslvjooA79fq+ORbzpi0njNMc
	 YdNQbqu2pSIOIBZ0NLyfpaAmAD/0hYqP0tBSIpj5IJNianCyqBvNYdqykOlLh3I6VX
	 +PEGQ8YdJSR6oxhoh3Dp01MCoi+/sfMrUQ8L4s2nPhxqKHWc627QcP7mMaphAxDeYj
	 1gx7zinW0cJi9MHyYCXEVTYimfFoMFrLvxzh/Uhyqg4cucPvIfB5ea4psiKh3LZ/C/
	 deh1LZD9RuQOQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33D5F380AA73;
	Wed, 26 Nov 2025 04:00:28 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] virtio_net: enhance wake/stop tx queue statistics
 accounting
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <176412962675.1513924.17474261080340416413.git-patchwork-notify@kernel.org>
Date: Wed, 26 Nov 2025 04:00:26 +0000
References: <20251120015320.1418-1-liming.wu@jaguarmicro.com>
In-Reply-To: <20251120015320.1418-1-liming.wu@jaguarmicro.com>
To: Liming Wu <liming.wu@jaguarmicro.com>
Cc: mst@redhat.com, jasowang@redhat.com, xuanzhuo@linux.alibaba.com,
 eperezma@redhat.com, kvm@vger.kernel.org,
 virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
 angus.chen@jaguarmicro.com

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 20 Nov 2025 09:53:20 +0800 you wrote:
> From: Liming Wu <liming.wu@jaguarmicro.com>
> 
> This patch refines and strengthens the statistics collection of TX queue
> wake/stop events introduced by commit c39add9b2423 ("virtio_net: Add TX
> stopped and wake counters").
> 
> Previously, the driver only recorded partial wake/stop statistics
> for TX queues. Some wake events triggered by 'skb_xmit_done()' or resume
> operations were not counted, which made the per-queue metrics incomplete.
> 
> [...]

Here is the summary with links:
  - [v2] virtio_net: enhance wake/stop tx queue statistics accounting
    https://git.kernel.org/netdev/net-next/c/cfeb7cd80f40

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



