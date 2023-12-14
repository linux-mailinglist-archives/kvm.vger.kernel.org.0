Return-Path: <kvm+bounces-4413-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E06381254C
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 03:30:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E3C921F21A63
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 02:30:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDB37111D;
	Thu, 14 Dec 2023 02:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AdgUcm+R"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4258EC2;
	Thu, 14 Dec 2023 02:30:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 45A2FC433C9;
	Thu, 14 Dec 2023 02:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702521024;
	bh=y2EG/KCgi10FK3ZjxuBE7voXPUxlA3BWrqZZbqiJ5Oo=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=AdgUcm+RBxdeixXwNYvhBeQgFJ3ag5pzjVKRfxRgFoX1/SvisIwal+nsp5IvjDLNi
	 uLSSz0Y+etp1gJeJhXfZPJ52TvnYSnRQG8+3851k6MvOsvEwNHN05vEvcqMiFM+c+6
	 qRxrbPWf+/el5giVZel4x0curTIHgUUWhj5oUiUcip3noH3zSMtP4G8g+1MHLEGqZ6
	 nwCw4520GyA089w+RJqo4Kv2fqU9rE3y64le9ghPkKznMlFzLaOTbN+rotd9D/B25e
	 QDEgfFKlf5Aw3k1YnWkBZM8r7VknUWzspCfvLUKffEPGCzxmwFMDI+UlSpHJKD6QhN
	 eNbXBHSNwUbeA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2C62AC4314C;
	Thu, 14 Dec 2023 02:30:24 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] vsock/virtio: Fix unsigned integer wrap around in
 virtio_transport_has_space()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <170252102417.28832.15985840662984348558.git-patchwork-notify@kernel.org>
Date: Thu, 14 Dec 2023 02:30:24 +0000
References: <20231211162317.4116625-1-kniv@yandex-team.ru>
In-Reply-To: <20231211162317.4116625-1-kniv@yandex-team.ru>
To: Nikolay Kuratov <kniv@yandex-team.ru>
Cc: linux-kernel@vger.kernel.org, sgarzare@redhat.com, netdev@vger.kernel.org,
 virtualization@lists.linux.dev, kvm@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 11 Dec 2023 19:23:17 +0300 you wrote:
> We need to do signed arithmetic if we expect condition
> `if (bytes < 0)` to be possible
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE
> 
> Fixes: 06a8fc78367d ("VSOCK: Introduce virtio_vsock_common.ko")
> Signed-off-by: Nikolay Kuratov <kniv@yandex-team.ru>
> 
> [...]

Here is the summary with links:
  - [v2] vsock/virtio: Fix unsigned integer wrap around in virtio_transport_has_space()
    https://git.kernel.org/netdev/net/c/60316d7f10b1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



