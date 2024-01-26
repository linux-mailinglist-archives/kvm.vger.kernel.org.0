Return-Path: <kvm+bounces-7037-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E9BDB83D1B0
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 01:50:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9FC1D1F25200
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 00:50:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF88F15BF;
	Fri, 26 Jan 2024 00:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZLbxS+Qq"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E50E385;
	Fri, 26 Jan 2024 00:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706230225; cv=none; b=uP6S7JpbHaUEA7vhrDdq1G3DPGCSVwK1vOKaX6rKozLeqlTrSx7B0wEbJOqOGB26MAL8nSRwAUsKvWS3uw5L7Z25hyJdeC6b+6QpBAYKtat6PjxYxnoPQxs69HaxCeH8uezs8Jo4lflxLsPAKl+pImPvK12Jbwt537S6wnmFIzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706230225; c=relaxed/simple;
	bh=2f0+fGYPXiafkD5YRHJqtQggSgsQRRMUS/0Y3PHqaJE=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=U49tLZutXtyI3BDpkKEPzPNT5Rf0bswIkoybEmBQg16iTT170N0dt7fR0myJAessiMdPwrFGHgdWk+J4r+CTnOpjj8tx2PXbN/RJrbGwExFwV598yy/0WZWZlyC2c+b8hSl/xPR1nVwhl9tvEo8tPbMrO0/TPSAo7Vr+4E5EKio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZLbxS+Qq; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 94EC6C433C7;
	Fri, 26 Jan 2024 00:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706230224;
	bh=2f0+fGYPXiafkD5YRHJqtQggSgsQRRMUS/0Y3PHqaJE=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=ZLbxS+QqAwJ3MZjsrlR6b7jgfJi5Sb2chYquq+uDsiJrC/+aJY+UIx9N5/Sqv2DVP
	 WpvSAOBj+bPKrHE4rVNTJYkt3ExZw2hoSOUzpOSqjhpcBEE3dZasburGtExxXJJzOw
	 tMgwBbQ1xkYKkwFvsn7oAD0vuryqgXFkUJw4UMAxt3legR2ELv9P5uh8C+pMBG9//K
	 ZuDVZFSYFhG1s96FAowUsExKsyyZD5qdVqQ/fY+Cbe4Vs7X3qdSC/jyTteuut4rY8i
	 gi4lBDNPJBH0nf0UKAa3YXcKPZIl8Z1iX5kDsTBWaEfiO4HlzKS+U3ke5S7NVIopx1
	 OW59UfvjkXB/w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 70EB6DFF767;
	Fri, 26 Jan 2024 00:50:24 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v1] vsock/test: print type for SOCK_SEQPACKET
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <170623022445.19620.11117902716691954284.git-patchwork-notify@kernel.org>
Date: Fri, 26 Jan 2024 00:50:24 +0000
References: <20240124193255.3417803-1-avkrasnov@salutedevices.com>
In-Reply-To: <20240124193255.3417803-1-avkrasnov@salutedevices.com>
To: Arseniy Krasnov <avkrasnov@salutedevices.com>
Cc: stefanha@redhat.com, sgarzare@redhat.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, mst@redhat.com,
 jasowang@redhat.com, bobby.eshleman@bytedance.com, kvm@vger.kernel.org,
 virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, kernel@sberdevices.ru, oxffffaa@gmail.com

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 24 Jan 2024 22:32:55 +0300 you wrote:
> SOCK_SEQPACKET is supported for virtio transport, so do not interpret
> such type of socket as unknown.
> 
> Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
> ---
>  tools/testing/vsock/vsock_diag_test.c | 2 ++
>  1 file changed, 2 insertions(+)

Here is the summary with links:
  - [net-next,v1] vsock/test: print type for SOCK_SEQPACKET
    https://git.kernel.org/netdev/net-next/c/767ec326f985

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



