Return-Path: <kvm+bounces-58911-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3906CBA56F2
	for <lists+kvm@lfdr.de>; Sat, 27 Sep 2025 02:50:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E7DEF38011E
	for <lists+kvm@lfdr.de>; Sat, 27 Sep 2025 00:50:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 526331E379B;
	Sat, 27 Sep 2025 00:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fLYKMFIe"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 650961547F2;
	Sat, 27 Sep 2025 00:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758934212; cv=none; b=HkZmC3oE2/Kjlqz8g1YwJ4Eeia90SX5iOzkURe3h8OX+szhT+QkJcxa7uCOApKm2WLwsPcMmMXS0Me98tT2GcgHrIOJHA6s67k+r1kSbIhbALDGOe7EpPCfV+rGRE7pvmUvkOTZTFzL+VIwcUSS5unIx+qeRLPr2TiZ6ZB68tTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758934212; c=relaxed/simple;
	bh=Xbe9ASBuOGk7KLtVQvp/E0YWO8f6x1bVH2QJvW2rd/s=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=taS5iY5eIh0Kh37iIhZDj2o3jT1qRm/o99te13yzSjMEbNZixlN5AYVt7EkbQOvDG8brjpf/HfQC27T5z3IeBFgksC15lst/bH5AJtjEhX9jelxxaoTFH0u7j12HqILNLP8vDzDbaFjkg6+5PnElDW6lQo02efa+jV6OM+nXUPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fLYKMFIe; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2CCBC4CEF4;
	Sat, 27 Sep 2025 00:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758934211;
	bh=Xbe9ASBuOGk7KLtVQvp/E0YWO8f6x1bVH2QJvW2rd/s=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=fLYKMFIef30W+ZRXSUVot6T9Ck3pYdXZvyDkKVIEg8EocQ79NduS4PX33nN6jAfxJ
	 m17tTfLsfAfKzSgEGiV7snt0SfiJj1XFH0MIEjIq2uny2kQvSKoce7UDAzZxfZtreS
	 QEUdiIZtQY43GBPVyAmHvcndr75QsaGPO7nJ5lp5G1JjQ/Tjd89Xr18pZ/6ZOuxwOe
	 AwHkA0BlnsE73D+hSzZv3xheYX2BnrXIEnT2PxvZrjEy4jaGQwP7yKERxCrl8Roc4n
	 rnCsoTscGseMWfiIlrSZzsIWl59k9DOkbT+PSit19j0KbfwqCGD6jGXJoQ+2AcY4ht
	 qp99KoApgPeFw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 342F939D0C3F;
	Sat, 27 Sep 2025 00:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] vhost: vringh: Fix copy_to_iter return value check
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <175893420700.108864.10199269230355246073.git-patchwork-notify@kernel.org>
Date: Sat, 27 Sep 2025 00:50:07 +0000
References: 
 <cd637504a6e3967954a9e80fc1b75e8c0978087b.1758723310.git.mst@redhat.com>
In-Reply-To: 
 <cd637504a6e3967954a9e80fc1b75e8c0978087b.1758723310.git.mst@redhat.com>
To: Michael S. Tsirkin <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, zhangjiao2@cmss.chinamobile.com,
 jasowang@redhat.com, eperezma@redhat.com, kvm@vger.kernel.org,
 virtualization@lists.linux.dev, netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 25 Sep 2025 02:04:08 -0400 you wrote:
> The return value of copy_to_iter can't be negative, check whether the
> copied length is equal to the requested length instead of checking for
> negative values.
> 
> Cc: zhang jiao <zhangjiao2@cmss.chinamobile.com>
> Link: https://lore.kernel.org/all/20250910091739.2999-1-zhangjiao2@cmss.chinamobile.com
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> 
> [...]

Here is the summary with links:
  - [net] vhost: vringh: Fix copy_to_iter return value check
    https://git.kernel.org/netdev/net/c/439263376c2c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



