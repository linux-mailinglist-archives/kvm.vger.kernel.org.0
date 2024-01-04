Return-Path: <kvm+bounces-5612-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 16D58823AF1
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 04:00:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8388528800B
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 03:00:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3207214A88;
	Thu,  4 Jan 2024 03:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sKteGbFf"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C45318E01;
	Thu,  4 Jan 2024 03:00:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E4F78C433CA;
	Thu,  4 Jan 2024 03:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704337227;
	bh=1bPukBR0uyMDLPdvzFBfZjdpRwBpPfkRhMLqOlSGgeA=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=sKteGbFfbXblAprT3gKvzEsGLXUJp14XCjBSgkqugD14K96skA+I1dShHmwekf6Kl
	 Sifml0duW4oXlzP2nvtXcc7lc+6fW7D0EQDEeshGGBsaGqWXKBjRY2hwI0PFhtSfeG
	 Z0kTyyB82HcwvE79AoKr/zfUL22xS/7kwyjnA3tGqTYXU+ymugneGkS5GXtMpUkebK
	 NfUaHY8gcjFE0+fmcjHKKtwSkIMed1ddH9iEXqG7ca1HUBEd5vsBYHeeJWLuwV+R/w
	 qESb1O+u/6sx4uKq57RGRHeUfjPejTyeqLF7q1onoYdfGvG8VtNuJA9HrzdIq3TSO4
	 cNpTjVEWdEYiQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CC17DC43168;
	Thu,  4 Jan 2024 03:00:26 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3] vsock/virtio: use skb_frag_*() helpers
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <170433722683.32402.12583350651179529381.git-patchwork-notify@kernel.org>
Date: Thu, 04 Jan 2024 03:00:26 +0000
References: <20240102205905.793738-1-almasrymina@google.com>
In-Reply-To: <20240102205905.793738-1-almasrymina@google.com>
To: Mina Almasry <almasrymina@google.com>
Cc: kvm@vger.kernel.org, virtualization@lists.linux.dev,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, stefanha@redhat.com,
 sgarzare@redhat.com, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  2 Jan 2024 12:59:04 -0800 you wrote:
> Minor fix for virtio: code wanting to access the fields inside an skb
> frag should use the skb_frag_*() helpers, instead of accessing the
> fields directly. This allows for extensions where the underlying
> memory is not a page.
> 
> Acked-by: Stefano Garzarella <sgarzare@redhat.com>
> Signed-off-by: Mina Almasry <almasrymina@google.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v3] vsock/virtio: use skb_frag_*() helpers
    https://git.kernel.org/netdev/net-next/c/06d9b446c4d4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



