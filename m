Return-Path: <kvm+bounces-2368-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 19C637F64A1
	for <lists+kvm@lfdr.de>; Thu, 23 Nov 2023 18:00:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 179B31C20ABA
	for <lists+kvm@lfdr.de>; Thu, 23 Nov 2023 17:00:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52F673FE5B;
	Thu, 23 Nov 2023 17:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AVlUgOAd"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C3433FB35;
	Thu, 23 Nov 2023 17:00:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A0B39C43395;
	Thu, 23 Nov 2023 17:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700758826;
	bh=QAhKOwmSyYL/06pMRYmwqRumPVYS4ikPDyPLMLk4BuA=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=AVlUgOAd/6Qj6nT4t8NFVdUtPwQ2l/VvAr/AsYAyEhcsdIDgNE74ytiYqDubRqE6S
	 p0e/zkaOVwOAzshbkNW6MePqAsUbguzkjL48aPfFSqbNhpH1U70AWOr3jAAdyiSBic
	 EVtmD37c45/gc21eptnlVFgYG/z2ZiNP1/wwzFi1VbaFCpzS2nJxCdUX/cVxQu7zld
	 ezgZjc97kOLjvSYG9EPn/1PHIzVE04Gdl5kPsMZt1D8vH5sytLhN6Ytj/g0zSkZIGo
	 rXjYt3gI0HhFVPv/fqpnNH1Wv5qV53VHTAMUFgwPGG3PHkHWZgiEPitcHT5BcrbR/o
	 Uulq4AblryAaw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8277EE00087;
	Thu, 23 Nov 2023 17:00:26 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v1] vsock/test: fix SEQPACKET message bounds test
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <170075882653.541.9262158470588794948.git-patchwork-notify@kernel.org>
Date: Thu, 23 Nov 2023 17:00:26 +0000
References: <20231121211642.163474-1-avkrasnov@salutedevices.com>
In-Reply-To: <20231121211642.163474-1-avkrasnov@salutedevices.com>
To: Arseniy Krasnov <avkrasnov@salutedevices.com>
Cc: stefanha@redhat.com, sgarzare@redhat.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, mst@redhat.com,
 jasowang@redhat.com, bobby.eshleman@bytedance.com, kvm@vger.kernel.org,
 virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, kernel@sberdevices.ru, oxffffaa@gmail.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 22 Nov 2023 00:16:42 +0300 you wrote:
> Tune message length calculation to make this test work on machines
> where 'getpagesize()' returns >32KB. Now maximum message length is not
> hardcoded (on machines above it was smaller than 'getpagesize()' return
> value, thus we get negative value and test fails), but calculated at
> runtime and always bigger than 'getpagesize()' result. Reproduced on
> aarch64 with 64KB page size.
> 
> [...]

Here is the summary with links:
  - [net,v1] vsock/test: fix SEQPACKET message bounds test
    https://git.kernel.org/netdev/net/c/f0863888f6cf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



