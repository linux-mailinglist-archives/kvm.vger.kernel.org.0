Return-Path: <kvm+bounces-38273-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 12164A36BE6
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 05:00:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4BF1A1896B28
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 04:00:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E03B18BC36;
	Sat, 15 Feb 2025 04:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ta0Xm+cR"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35A5C189BB8;
	Sat, 15 Feb 2025 04:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739592007; cv=none; b=aaanW/kj/kqqDU4+g2WFB0AOyVQAv0YCkEASMKpQM9WI0bxlk+vWK4OooFV5G16bhW14iGRpS52qKoedQ+fGe2Soo5XLIMZvQ0X/qiP4D4z/Sn8OB5IF+tGYPLzgoAHUmXfrusDqSYvZOpatjf5FJ2/CxdB+6gXhEiQCsdY5qQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739592007; c=relaxed/simple;
	bh=ulhZIH8qu/KoCTkdFhojWRMot3sncbbRiEu6ZMsFa0o=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=mfvYq4TWPeUHXSr3AMaPZpBeDOx7qcNqTmqSXOIdwHw514ar1nAh5hZN1D6Go+dbihv6LZTFGlGFJX/MGQjtSjQlq/bhAxJTMrx7CVnDIeav6AMmFohckdUKEQ1TsKRHS0n1S0XnYcwP1L/uQzP4tRIUYCC0Q3ptcUeefF3EPwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ta0Xm+cR; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A363BC4CEE4;
	Sat, 15 Feb 2025 04:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739592006;
	bh=ulhZIH8qu/KoCTkdFhojWRMot3sncbbRiEu6ZMsFa0o=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=ta0Xm+cR25aPg93RJzFmnUsh7nAzUv2PF8ssNvZcshSsFxk2tegeHyhpt87Z0UHja
	 Ald92xLNYRmCkq4UmpEPDSUBIlwumABhRjY6vNxsPR+PSRlALzB0l/wzS982peVThH
	 Bub5ltUvgnKPoSn1DjJHHJz3QpoDhsyMKSregco+2OKwasOs+iv4ZesYzybtF7cTcW
	 Qno6jDlT7KC9Oyjzq+0Kjno89BwNGclcR9uajNX8WgrQD5Mz3kvrDLsPiLmQQTzFEi
	 2bbDACiqK/J7ur7W8AZ7Svp+bppIvxciWrrWQvEM/Sic9dQqPKRtLTIFtUtS+xTZZ3
	 3s18OUY4r8aZw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70E08380CEE9;
	Sat, 15 Feb 2025 04:00:37 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [Patch net v3] vsock/virtio: fix variables initialization during
 resuming
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <173959203625.2185212.746025659708481674.git-patchwork-notify@kernel.org>
Date: Sat, 15 Feb 2025 04:00:36 +0000
References: <20250214012200.1883896-1-junnan01.wu@samsung.com>
In-Reply-To: <20250214012200.1883896-1-junnan01.wu@samsung.com>
To: Junnan Wu <junnan01.wu@samsung.com>
Cc: sgarzare@redhat.com, davem@davemloft.net, edumazet@google.com,
 eperezma@redhat.com, horms@kernel.org, jasowang@redhat.com, kuba@kernel.org,
 kvm@vger.kernel.org, lei19.wang@samsung.com, linux-kernel@vger.kernel.org,
 mst@redhat.com, netdev@vger.kernel.org, pabeni@redhat.com,
 q1.huang@samsung.com, stefanha@redhat.com, virtualization@lists.linux.dev,
 xuanzhuo@linux.alibaba.com, ying01.gao@samsung.com, ying123.xu@samsung.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 14 Feb 2025 09:22:00 +0800 you wrote:
> When executing suspend to ram twice in a row,
> the `rx_buf_nr` and `rx_buf_max_nr` increase to three times vq->num_free.
> Then after virtqueue_get_buf and `rx_buf_nr` decreased
> in function virtio_transport_rx_work,
> the condition to fill rx buffer
> (rx_buf_nr < rx_buf_max_nr / 2) will never be met.
> 
> [...]

Here is the summary with links:
  - [net,v3] vsock/virtio: fix variables initialization during resuming
    https://git.kernel.org/netdev/net/c/55eff109e76a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



