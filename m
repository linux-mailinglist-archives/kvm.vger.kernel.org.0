Return-Path: <kvm+bounces-52058-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 24D39B00D65
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 22:50:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3C69E3BEF37
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 20:49:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B90D2FD893;
	Thu, 10 Jul 2025 20:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YSvh7jSX"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85B5427145D;
	Thu, 10 Jul 2025 20:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752180594; cv=none; b=g9HAyLpgE9ONU4oPsxg32YrKbmjTOZ0ntFCK5EzBZLKpCtmnebt9Gg6tIRNami9H0Tf5av0yovMjCMGC5HCRqSFbgIW/FenU0OJYcfM0lQdod3ez2AkyLFyN3/VDnEOEPsqH/jJ32WB1NqRW2l8bJqlg+TYOtKV5XsNAUfj2tr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752180594; c=relaxed/simple;
	bh=FonGx0PMmsJZJeroYI35EkzdSHwzvxNrNh1su+eHKdw=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=i2oc/4uMpCNlLy9rLxQM5W6tb8QjE5jrMrf3cEFqwMFPGuS2tOFUDYWWUfRpT23IvqVxK+U/Ep7RpfejpjNXS+DyewcslQb52uKMsKZYCrhmXjiNASDJUb8I5BUcBB1vAmcj3b98xtwwDYe3kIHqJGHKa1xbb4xQ2BeF1agO0lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YSvh7jSX; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04B21C4CEE3;
	Thu, 10 Jul 2025 20:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752180594;
	bh=FonGx0PMmsJZJeroYI35EkzdSHwzvxNrNh1su+eHKdw=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=YSvh7jSXDvEbuHIMpz+AEps8bPLXWp3pV4VccB8aRCOc8s1jMmGBWzi9ErFtB95SB
	 cJ9EZaBS0VOTigaIjex59o+W9PsprNwkjxXhVC3LUKnXcPW4d+ytJ1LwuJUAFduHdB
	 kPTJuXZXCgNCEMVzUC0sXa8q+0+8cLW8qff1sKmEOO7nBOrAUziVLy06YfHCGsfXaV
	 CptQEAdXBmiKaWVGTT2ic6Mvmo3x77+jNWFoPOSzQDn4U8csZo0Rpo6UyX36/WWO0A
	 h1wgZP4XzMnyPopWrFp2YJTWa9wh1QcIc8iwfzX/4jH5bllnXnloTPaow7gZ7/3w37
	 7OJG2Z3gWgk1Q==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70C99383B266;
	Thu, 10 Jul 2025 20:50:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v7 net-next 0/9] virtio: introduce GSO over UDP tunnel
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <175218061625.1662273.4950681592128022716.git-patchwork-notify@kernel.org>
Date: Thu, 10 Jul 2025 20:50:16 +0000
References: <cover.1751874094.git.pabeni@redhat.com>
In-Reply-To: <cover.1751874094.git.pabeni@redhat.com>
To: Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org, willemdebruijn.kernel@gmail.com,
 jasowang@redhat.com, andrew+netdev@lunn.ch, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, mst@redhat.com,
 xuanzhuo@linux.alibaba.com, eperezma@redhat.com, yuri.benditovich@daynix.com,
 akihiko.odaki@daynix.com, corbet@lwn.net, kvm@vger.kernel.org,
 linux-doc@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Tue,  8 Jul 2025 09:08:56 +0200 you wrote:
> Some virtualized deployments use UDP tunnel pervasively and are impacted
> negatively by the lack of GSO support for such kind of traffic in the
> virtual NIC driver.
> 
> The virtio_net specification recently introduced support for GSO over
> UDP tunnel, this series updates the virtio implementation to support
> such a feature.
> 
> [...]

Here is the summary with links:
  - [v7,net-next,1/9] scripts/kernel_doc.py: properly handle VIRTIO_DECLARE_FEATURES
    https://git.kernel.org/netdev/net-next/c/eade9f57ca72
  - [v7,net-next,2/9] virtio: introduce extended features
    https://git.kernel.org/netdev/net-next/c/e7d4c1c5a546
  - [v7,net-next,3/9] virtio_pci_modern: allow configuring extended features
    https://git.kernel.org/netdev/net-next/c/69b946151224
  - [v7,net-next,4/9] vhost-net: allow configuring extended features
    https://git.kernel.org/netdev/net-next/c/333c515d1896
  - [v7,net-next,5/9] virtio_net: add supports for extended offloads
    https://git.kernel.org/netdev/net-next/c/3b17aa13015c
  - [v7,net-next,6/9] net: implement virtio helpers to handle UDP GSO tunneling.
    https://git.kernel.org/netdev/net-next/c/a2fb4bc4e2a6
  - [v7,net-next,7/9] virtio_net: enable gso over UDP tunnel support.
    https://git.kernel.org/netdev/net-next/c/56a06bd40fab
  - [v7,net-next,8/9] tun: enable gso over UDP tunnel support.
    (no matching commit)
  - [v7,net-next,9/9] vhost/net: enable gso over UDP tunnel support.
    https://git.kernel.org/netdev/net-next/c/bbca931fce26

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



