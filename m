Return-Path: <kvm+bounces-68285-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DC6DDD2B03E
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 04:53:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 99AE730127A7
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 03:53:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E524B343D6D;
	Fri, 16 Jan 2026 03:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fUUTJz4z"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BCC329A1;
	Fri, 16 Jan 2026 03:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768535622; cv=none; b=Ogeqz0Q5OVLQ5bv+9bU6aCQIZ8pVLPA+oqkV79JOVEIzl1qmWBWkUuDF3p1LWQP8s/VSPDw+T3bHRMXXOy5KDscGq5zwkUOaPAcylp5VhPwuyCNMHgPouKqbfnIZCK90YrZZdtH8L/ytDVE2yszDVZEdOE4Dyy4kQSTW+v7c70M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768535622; c=relaxed/simple;
	bh=ees821A/NRyoXsrx3xfbPYGegZtOUU+kLtT35pR1m6I=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=iW/kLXYzp0HVmNGlSLFUSuPe1tapVMezzzFlzuWRuyP7roaWfzyNkbTg9oyPb4gDp773P0htYyQGhQRd3XJEY2gY1UBLspegDPbXWR5Cr8eOvt/5tfVEijRu8cVLphOi+Eke+e/mPFLarIjMMf0d6S6vDimrLlufVfP8QaSgRI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fUUTJz4z; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D98E0C116C6;
	Fri, 16 Jan 2026 03:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768535621;
	bh=ees821A/NRyoXsrx3xfbPYGegZtOUU+kLtT35pR1m6I=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=fUUTJz4zzhiey11yCDXou4SYTiAR5Azs2vfoy5dsBP00Yp4sxsRc+EyJf4u9Bs8OE
	 GccNYWkdtnPNKA5raPdyrQFjuEkg0bdvY8/d8KYaeGYQJP5QS7B5AotXa0KIsUb6Tk
	 7FNccr4ci1Wvxj2RAfw+EZpt5n7FAczQmKleGA1Fjuqy3/UChRZdbN2UNBIEA9GQpb
	 ZqWFgDjQtRoc3+Y6upOwA2ZFFZEOMRFrXWzvwDvDTqZxfQ+H3XLlQwXNuUSovHx3hG
	 BenA/sCwuL2tvlsXNfpXO31YD46Un5FEKneKo+HrrWNBgmYHNUjZCpbnSpk/0KihQj
	 rGolUTNyYf9HQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id F2D49380AA4C;
	Fri, 16 Jan 2026 03:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/2] vsock/virtio: Fix data loss/disclosure due to
 joining of non-linear skb
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <176853541379.73880.1523933518591592704.git-patchwork-notify@kernel.org>
Date: Fri, 16 Jan 2026 03:50:13 +0000
References: <20260113-vsock-recv-coalescence-v2-0-552b17837cf4@rbox.co>
In-Reply-To: <20260113-vsock-recv-coalescence-v2-0-552b17837cf4@rbox.co>
To: Michal Luczaj <mhal@rbox.co>
Cc: mst@redhat.com, jasowang@redhat.com, xuanzhuo@linux.alibaba.com,
 eperezma@redhat.com, stefanha@redhat.com, sgarzare@redhat.com,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 horms@kernel.org, avkrasnov@salutedevices.com, kvm@vger.kernel.org,
 virtualization@lists.linux.dev, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 13 Jan 2026 16:08:17 +0100 you wrote:
> Loopback transport coalesces some skbs too eagerly. Handling a zerocopy
> (non-linear) skb as a linear one leads to skb data loss and kernel memory
> disclosure.
> 
> Plug the loss/leak by allowing only linear skb join. Provide a test.
> 
> Signed-off-by: Michal Luczaj <mhal@rbox.co>
> 
> [...]

Here is the summary with links:
  - [net,v2,1/2] vsock/virtio: Coalesce only linear skb
    https://git.kernel.org/netdev/net/c/0386bd321d0f
  - [net,v2,2/2] vsock/test: Add test for a linear and non-linear skb getting coalesced
    https://git.kernel.org/netdev/net/c/a63e5fe09592

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



