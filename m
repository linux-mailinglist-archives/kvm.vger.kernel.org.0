Return-Path: <kvm+bounces-6895-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2706C83B704
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 03:10:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D31F728639A
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 02:10:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91B6A6FC9;
	Thu, 25 Jan 2024 02:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tl0AtRgr"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADFA15C9A;
	Thu, 25 Jan 2024 02:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706148626; cv=none; b=ZcGo+o6onxDqr8kxUHtP1Vze5Z3uEM1wkHuineaoxnQ8Gk/Ka8N2leubChRGRVgyB5Ods7ffZ0oBUWLKKWiMFdgMf1ferRS10GAgmXXRbRwd1K8YAFvQu0wnEqow4FQ0mAKHpBNXg2ngzYZjRNYxaI/JnleyE2U7FfugMkDv/rU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706148626; c=relaxed/simple;
	bh=exbNsUO+6hEk5AT7leqbsd2aeyVCGYHr5/DdVbI3xxw=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=Ma8g3G6l2xaogCl2eumxRtoK8jq7tha0FPu3EDojuNpvaH9JFTN6vAPxs6l/3UFMVchmCchK4EsJ/xYme6njbgaPfHdYiaCqzuvSNpNJhfI8wU3+FWa82REaeqwZHnNMq1r+6iHNXaLCPYBGdXkqOL2Ny9h95Da4k30UtGZ0pWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tl0AtRgr; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2EFB7C433C7;
	Thu, 25 Jan 2024 02:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706148626;
	bh=exbNsUO+6hEk5AT7leqbsd2aeyVCGYHr5/DdVbI3xxw=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=tl0AtRgrA50fu6DljdBxD7qdCGPntWYlJI8VDDzBPYFJ7W7uielVp5gQI8zpshB4m
	 JDM/GZP6IoRoDMnCk+/0RIGRuPs3lCKGTNmzGpjlvhMpnvr5E0+RnhtnhuDy+eKL7t
	 j74oGigM1eiWIh/Bd2dpF89GFT+BqdBGVeoHCFpJqZmuCTc5F8JeSmPzaWo8tkaXh6
	 fxIoJNj/Z3SFeJRThnmxe2Xgue/9y8Doaf0ZkJRPy1z+9UICGOX902WXOggws6vRTc
	 MYvxupdnfb53ND3PAHIN5AphM8jzdJax9a0mOnahIlf6l/up9qcTAypEqUI6zsVWEH
	 MM0TDQRF6vD2g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 16F39D8C966;
	Thu, 25 Jan 2024 02:10:26 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] vsock/test: add '--peer-port' input argument
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <170614862608.13756.13921214804637913157.git-patchwork-notify@kernel.org>
Date: Thu, 25 Jan 2024 02:10:26 +0000
References: <20240123072750.4084181-1-avkrasnov@salutedevices.com>
In-Reply-To: <20240123072750.4084181-1-avkrasnov@salutedevices.com>
To: Arseniy Krasnov <avkrasnov@salutedevices.com>
Cc: stefanha@redhat.com, sgarzare@redhat.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, mst@redhat.com,
 jasowang@redhat.com, bobby.eshleman@bytedance.com, kvm@vger.kernel.org,
 virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, kernel@sberdevices.ru, oxffffaa@gmail.com

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 23 Jan 2024 10:27:50 +0300 you wrote:
> Implement port for given CID as input argument instead of using
> hardcoded value '1234'. This allows to run different test instances
> on a single CID. Port argument is not required parameter and if it is
> not set, then default value will be '1234' - thus we preserve previous
> behaviour.
> 
> Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v2] vsock/test: add '--peer-port' input argument
    https://git.kernel.org/netdev/net-next/c/e18c709230cb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



