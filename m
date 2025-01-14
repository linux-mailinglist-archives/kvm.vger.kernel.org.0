Return-Path: <kvm+bounces-35369-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6171AA105EB
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 12:50:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7EAA7168368
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 11:50:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CF71229602;
	Tue, 14 Jan 2025 11:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BNoJBLCw"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6374D234CE0;
	Tue, 14 Jan 2025 11:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736855410; cv=none; b=HOdekrfDmgWGAiC+EpSlgRUBtc+2STeB5Jvfqkj8uI65Aas3bMpfZDcAYyfSux0y710rJ5FdLxKk/YfWxWeTN9mK9J/DfqdSnY/UK+OF8Mo3b86LWHjB2NvGQsfbWNGEY+gk7s9xBmzTmwSdZopqqZJLsaOaZ5v4Ytt9H2tILAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736855410; c=relaxed/simple;
	bh=GCxYjZ5hf3huRSklB4FS3TwTSDlGgElvK3MC+6LmkMU=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=OnIAyFFfPCjfAf2E8m28RN4KlayL4AlPkxLgIMrX4WAhuQiLExyCgPmsPVERqcBDYGfHkO2RSvVc7vL6DVJAnAm2x0vIYkUMuc3Dg1vNhPmEqiGe5VWnNFt7T+mG4MR0q6Cel+p5ml8x5uuz4rrGXm6+3tB/psLR0fCgy2eIIQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BNoJBLCw; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCD3AC4CEDD;
	Tue, 14 Jan 2025 11:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736855409;
	bh=GCxYjZ5hf3huRSklB4FS3TwTSDlGgElvK3MC+6LmkMU=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=BNoJBLCwCVJAf+TDh5g46vlldTwbYbU6hfCbR8SRjoJ5QXK+86xhS7Rxk0C3WmbSp
	 Ge9fwW0EhkLoJ5Y8GGiD3S6dnlvoJh7bLBCfat53Yhe5k4L+gGp6dCop7eZXGWX6jj
	 ilCY9AdznBgbnZsTDz7xKOVEbAJ8aG6OCua1P9iLHgkRSx6sgWlzmC6dCGwcyCB94z
	 /Sg6PhQik5C9RI6+aUdeGopL2aA177yCYZtokB3JJIN0SWfGZY8L1Bes5+Tewx87MA
	 /64gcQHdOgHk7lwT/sCsrgCRtlcOOIcZMDrL2bQaB8jKMnanOmv03q3Ch6f9Ogxlbc
	 9EbfrRgttTA8w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id AE17B380AA5F;
	Tue, 14 Jan 2025 11:50:33 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/5] vsock: some fixes due to transport de-assignment
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <173685543253.4153435.8360593210112873590.git-patchwork-notify@kernel.org>
Date: Tue, 14 Jan 2025 11:50:32 +0000
References: <20250110083511.30419-1-sgarzare@redhat.com>
In-Reply-To: <20250110083511.30419-1-sgarzare@redhat.com>
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: netdev@vger.kernel.org, xuanzhuo@linux.alibaba.com, bpf@vger.kernel.org,
 linux-kernel@vger.kernel.org, leonardi@redhat.com, davem@davemloft.net,
 qwerty@theori.io, eperezma@redhat.com, mst@redhat.com, edumazet@google.com,
 kvm@vger.kernel.org, pabeni@redhat.com, stefanha@redhat.com,
 jasowang@redhat.com, horms@kernel.org, v4bel@theori.io, kuba@kernel.org,
 mhal@rbox.co, virtualization@lists.linux.dev, bobby.eshleman@bytedance.com

Hello:

This series was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Fri, 10 Jan 2025 09:35:06 +0100 you wrote:
> v1: https://lore.kernel.org/netdev/20250108180617.154053-1-sgarzare@redhat.com/
> v2:
> - Added patch 3 to cancel the virtio close delayed work when de-assigning
>   the transport
> - Added patch 4 to clean the socket state after de-assigning the transport
> - Added patch 5 as suggested by Michael and Hyunwoo Kim. It's based on
>   Hyunwoo Kim and Wongi Lee patch [1] but using WARN_ON and covering more
>   functions
> - Added R-b/T-b tags
> 
> [...]

Here is the summary with links:
  - [net,v2,1/5] vsock/virtio: discard packets if the transport changes
    https://git.kernel.org/netdev/net/c/2cb7c756f605
  - [net,v2,2/5] vsock/bpf: return early if transport is not assigned
    https://git.kernel.org/netdev/net/c/f6abafcd32f9
  - [net,v2,3/5] vsock/virtio: cancel close work in the destructor
    https://git.kernel.org/netdev/net/c/df137da9d6d1
  - [net,v2,4/5] vsock: reset socket state when de-assigning the transport
    https://git.kernel.org/netdev/net/c/a24009bc9be6
  - [net,v2,5/5] vsock: prevent null-ptr-deref in vsock_*[has_data|has_space]
    https://git.kernel.org/netdev/net/c/91751e248256

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



