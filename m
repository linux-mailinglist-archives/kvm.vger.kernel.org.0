Return-Path: <kvm+bounces-31613-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A32129C56C9
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 12:40:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5C3581F2301A
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 11:40:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 531CA2309B8;
	Tue, 12 Nov 2024 11:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y7tWldnR"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D5BD23099B;
	Tue, 12 Nov 2024 11:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731411620; cv=none; b=eEpQ3A5I01NTzDKJtMlc73qfMgmwFDi7XSlZfkxKi8l20FrOxslb5Hz+RbtBhviFnA0JATPdqvIt0niVJ2fXBSn6R3pklWNSWRTiw8HkRrFL02oDKeKkZTiqDcBA69vKPAd8JN1mK2bPxSlbfplwGgoEIwh8nhIgz0/+FkPaLtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731411620; c=relaxed/simple;
	bh=8qmj0pHUDgMKjJ62WWArHo5zo6dEwy07xVsYgZ4lj5A=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=kymfNh/QgzWxwj8WHq8ksZT6kg+p2AmHtzo7KJ7eth0SoFVgK61EEOQDF+zuVaqmaYejFOF6EgAlGDO3t4wWZdufHECPmJ6+qpddVEzcstvtCDn1sDc5h/tnhaIjJFNOHFL7Jc+3JXBp8cvW2hqn2V4LG0drUXTFFvptNCuZpDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y7tWldnR; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EDA6C4CECD;
	Tue, 12 Nov 2024 11:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731411620;
	bh=8qmj0pHUDgMKjJ62WWArHo5zo6dEwy07xVsYgZ4lj5A=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=Y7tWldnREzY69DhPL2F5PQ7pFRxkb1KpKGgUFx3athIhRv2OPwsy2I9luyTFKtl6X
	 hRpHbJOy5ETGWvmB18KsjvEQs5NYG9gfZg+uovkGu94RbAPZzh3qP41RsloKFsoTv7
	 BrPX9WyFZ56ACcdDjxjkDuIql8NftBrIMQ55yKdcenG7TaHQWo0ekAoJUvMmzVZKqp
	 IRDF/vXzMZBiHVYWoQ670cJzf1rK+oLun15YJMi3VXRYem8an4L0xm1AKu5qlU4lGZ
	 nPeO3jEHUat4TNugTLo6wVM831E7oeYKPkxua7ARmF6vA8EglLWKBrEzEzK8uxNOEi
	 UTAr9rSON+jJA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 711BB3809A80;
	Tue, 12 Nov 2024 11:40:31 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/3] virtio/vsock: Fix memory leaks
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <173141163025.493337.14764955128462375316.git-patchwork-notify@kernel.org>
Date: Tue, 12 Nov 2024 11:40:30 +0000
References: <20241107-vsock-mem-leaks-v2-0-4e21bfcfc818@rbox.co>
In-Reply-To: <20241107-vsock-mem-leaks-v2-0-4e21bfcfc818@rbox.co>
To: Michal Luczaj <mhal@rbox.co>
Cc: stefanha@redhat.com, sgarzare@redhat.com, mst@redhat.com,
 jasowang@redhat.com, xuanzhuo@linux.alibaba.com, eperezma@redhat.com,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 horms@kernel.org, justin.he@arm.com, avkrasnov@salutedevices.com,
 dtor@vmware.com, acking@vmware.com, georgezhang@vmware.com,
 kvm@vger.kernel.org, virtualization@lists.linux.dev, netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Thu, 07 Nov 2024 21:46:11 +0100 you wrote:
> Short series fixing some memory leaks that I've stumbled upon while toying
> with the selftests.
> 
> Signed-off-by: Michal Luczaj <mhal@rbox.co>
> ---
> Changes in v2:
> - Remove the refactoring patch from the series [Stefano]
> - PATCH 2: Drop "virtio" from the commit title [Stefano]
> - Collect Reviewed-by [Stefano]
> - Link to v1: https://lore.kernel.org/r/20241106-vsock-mem-leaks-v1-0-8f4ffc3099e6@rbox.co
> 
> [...]

Here is the summary with links:
  - [net,v2,1/3] virtio/vsock: Fix accept_queue memory leak
    https://git.kernel.org/netdev/net/c/d7b0ff5a8667
  - [net,v2,2/3] vsock: Fix sk_error_queue memory leak
    https://git.kernel.org/netdev/net/c/fbf7085b3ad1
  - [net,v2,3/3] virtio/vsock: Improve MSG_ZEROCOPY error handling
    https://git.kernel.org/netdev/net/c/60cf6206a1f5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



