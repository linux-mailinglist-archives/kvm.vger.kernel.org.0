Return-Path: <kvm+bounces-51350-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F210BAF65AD
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 00:51:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5D8B81BC1E92
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 22:51:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC82D2E03F5;
	Wed,  2 Jul 2025 22:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SFAK2wl/"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0D352727E0;
	Wed,  2 Jul 2025 22:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751496604; cv=none; b=J6asYMo25fWIXgyUoqw0V6+NmKtdzzxc6sveJlLbHP7EtH3Eyff7DCU7/LtdHPTOSnRqTwn0FuMtGnqGDSn8bW88FAEJ4vnyG9OSqU56//4a1346WW1qX7iQSUBxtud7w8uCOsdbwDp5v2a6x181kXO8ap/RjjES8ilMWFijNc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751496604; c=relaxed/simple;
	bh=nvl1bDqpj1Z2UVFPCbzHZAWIxNl+Kv9fy6TqHKapdE0=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=VR8OB/Rp3IPfqwHof7CCHM063c46DpklMhDI48eFdPvWrSnzdDfsryswnZ8opxnn5W+v3CkF45vsL6aWcr+FyifH7yF3C4FtXqrhcrn9gdAvv+I57dsoMpojNunp75B4y3jK1jE4xmu3lBaYLXt/FviejnTQ2FapUf/hEw3xam8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SFAK2wl/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 424E2C4CEE7;
	Wed,  2 Jul 2025 22:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751496604;
	bh=nvl1bDqpj1Z2UVFPCbzHZAWIxNl+Kv9fy6TqHKapdE0=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=SFAK2wl/srK1bQZwhg3G3Ns6fvdzfQ4vevBIixC98/LsMk++bQuN3vkl4lGvxkol5
	 XYHQd2FNJn2mAxfKd9ICH8b5YGvvmpHfBnGn63ilY28sD310feJFDowJALnwUNI5/O
	 QKmj2vdC/2Wpv1rckVV23wsQ4KG6O8KUre6ogZ9ogs16EURbz0uhk2zijlwnPk48xu
	 vL95M0PUcV94zSxq5B+HXQN34f8SScvfB0QCVJo1vhSLvLTLrGc5s9M20btBpbwzfe
	 jbgIOOpTf7gr7jB95wHcd6bAQKFdD0KUE7oOROAbL2xcW4sFqt+nLYQRjS/Qz54yXE
	 0fRU9hugnpXsg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70CC2383B273;
	Wed,  2 Jul 2025 22:50:28 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next V3 1/2] tun: remove unnecessary tun_xdp_hdr
 structure
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <175149662701.890932.18390688649373807942.git-patchwork-notify@kernel.org>
Date: Wed, 02 Jul 2025 22:50:27 +0000
References: <20250701010352.74515-1-jasowang@redhat.com>
In-Reply-To: <20250701010352.74515-1-jasowang@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: willemdebruijn.kernel@gmail.com, andrew+netdev@lunn.ch,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 mst@redhat.com, eperezma@redhat.com, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 virtualization@lists.linux.dev, willemb@google.com

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  1 Jul 2025 09:03:51 +0800 you wrote:
> With f95f0f95cfb7("net, xdp: Introduce xdp_init_buff utility routine"),
> buffer length could be stored as frame size so there's no need to have
> a dedicated tun_xdp_hdr structure. We can simply store virtio net
> header instead.
> 
> Acked-by: Willem de Bruijn <willemb@google.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> 
> [...]

Here is the summary with links:
  - [net-next,V3,1/2] tun: remove unnecessary tun_xdp_hdr structure
    https://git.kernel.org/netdev/net-next/c/4d313f2bd222
  - [net-next,V3,2/2] vhost-net: reduce one userspace copy when building XDP buff
    https://git.kernel.org/netdev/net-next/c/97b2409f28e0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



