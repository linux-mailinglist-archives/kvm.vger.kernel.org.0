Return-Path: <kvm+bounces-47778-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 19623AC4BC6
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 11:50:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9E9DB3ABCB2
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 09:49:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BA02254844;
	Tue, 27 May 2025 09:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q8B2haYf"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 838FF1F4CAC;
	Tue, 27 May 2025 09:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748339400; cv=none; b=UzI8AeXjTuyHOXX5l5bVCgR6tFkyDm+YfM4SCE68kEVHWJ3rlM/KbXAjpASdzYu0BHeYMjFJYI0T42QUzPaFbQUJx4jfC24hdalZHtYLrPrpU6hVCe6QCLzCXOUVa8PcEdtpGgH+J8Sm4jjHmcuoYb2Mpl2Tu7dOaVFg5Abo8tA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748339400; c=relaxed/simple;
	bh=K0rIG/9jfPhF/mymGPSs9fjPZlzOBraUDXaxA48k/Mw=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=A2UQKcF5I8j9N5kfxO46YSAkvxdLCFsoizSc6AVjWmSOUZrCruQfXmbDFi2n2JwAu6sXVW3cFg9cyWF9O7RO7byCcnpHLBPf321cxsUqEy0gaC1htCQVBeBUxEdi11IBokcWHeD9Z/oEA+8JUQ4R3ZO7WNBP/Z3Anv5oxbz+N60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q8B2haYf; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E94A3C4CEE9;
	Tue, 27 May 2025 09:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748339400;
	bh=K0rIG/9jfPhF/mymGPSs9fjPZlzOBraUDXaxA48k/Mw=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=q8B2haYfaB8NgWtHLnnpPv5UnD86hnvaQOeueWauy8h+tCxsS89t8TXYpM7L1ksFJ
	 yBwVh4KXcEg0bLRL/eG2++ZclwQab7O3Ty7DxDgF7FxKQHXUHBSvz6xAgnPExPUbxU
	 R/LZ6e7xbXanWtcIM04629N9ZYQlbUUDTztv6D07YzBWGuVaqa8PQPPA7TukBigrpR
	 YEKh8VwC7u4PSnEfGec12qcakMlG7+9f6ryr23SDqqiHzw6Jk9WtVO5JvWClGWliQc
	 7dutcMld1ChsPGlW2bOk5ZZyZ+LrS4hy/EXFEiuGAwf3dbNFTG3Wt/9H8qWkPq+t4A
	 zwVcFirSXEzsg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70E28380AAE2;
	Tue, 27 May 2025 09:50:35 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v6 0/5] vsock: SOCK_LINGER rework
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <174833943425.1235580.6276796573046054337.git-patchwork-notify@kernel.org>
Date: Tue, 27 May 2025 09:50:34 +0000
References: <20250522-vsock-linger-v6-0-2ad00b0e447e@rbox.co>
In-Reply-To: <20250522-vsock-linger-v6-0-2ad00b0e447e@rbox.co>
To: Michal Luczaj <mhal@rbox.co>
Cc: sgarzare@redhat.com, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, mst@redhat.com,
 jasowang@redhat.com, xuanzhuo@linux.alibaba.com, eperezma@redhat.com,
 stefanha@redhat.com, virtualization@lists.linux.dev, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Thu, 22 May 2025 01:18:20 +0200 you wrote:
> Change vsock's lingerning to wait on close() until all data is sent, i.e.
> until workers picked all the packets for processing.
> 
> Changes in v6:
> - Make vsock_wait_sent() return bool, parametrize enable_so_linger() with
>   timeout, don't open code DIV_ROUND_UP [Stefano]
> - Link to v5: https://lore.kernel.org/r/20250521-vsock-linger-v5-0-94827860d1d6@rbox.co
> 
> [...]

Here is the summary with links:
  - [net-next,v6,1/5] vsock/virtio: Linger on unsent data
    https://git.kernel.org/netdev/net-next/c/1c39f5dbbfd2
  - [net-next,v6,2/5] vsock: Move lingering logic to af_vsock core
    https://git.kernel.org/netdev/net-next/c/5ec40864aaec
  - [net-next,v6,3/5] vsock/test: Introduce vsock_wait_sent() helper
    https://git.kernel.org/netdev/net-next/c/e78e0596c762
  - [net-next,v6,4/5] vsock/test: Introduce enable_so_linger() helper
    https://git.kernel.org/netdev/net-next/c/8b07b7e5c253
  - [net-next,v6,5/5] vsock/test: Add test for an unexpectedly lingering close()
    https://git.kernel.org/netdev/net-next/c/393d070135ad

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



