Return-Path: <kvm+bounces-23013-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E6B599459EA
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 10:30:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 710FEB227D4
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 08:30:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58DBF1C3783;
	Fri,  2 Aug 2024 08:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eAlTSE9m"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CE161BF30C;
	Fri,  2 Aug 2024 08:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722587432; cv=none; b=tfKowTjMV+HUD3HKRUgICDW/ZlKgKEkK+gBFPFyc1FClPAocd8sis/BDbhhzXgheEV3KJFZhvVI1LiSL6gwbxLrcXa5wQk4lMSMU3v0dx0MDK+1jfYcFR+lEXhGTIU++YKO5NhfHLDurRbXhXoZV+ieYJ7cI5RxW3p2gaEZhOEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722587432; c=relaxed/simple;
	bh=6WMpdjlol5l0iHOC17lwxSuTbJY8SqxdvaO51gx5V64=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=k/iANKC6H0w/N2Abg57/pb4Ay/2UZH0OgHJ6uiCSi61ug+NOZiwt27w0vs07aJgIERdd053+K0pWsWyhT3bqO0ECjTy063i5WAxI/7rgFE2LO7xMESH1n4JND/jIHtAm7e0TeZbvWNnKnWaGv66pRaRIiUEMQur61gSQnMHooic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eAlTSE9m; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id F27A4C4AF0A;
	Fri,  2 Aug 2024 08:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722587432;
	bh=6WMpdjlol5l0iHOC17lwxSuTbJY8SqxdvaO51gx5V64=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=eAlTSE9m3F/pO+sxKo8tm4I5ZBhKX2unoAh/W3BWblqFUl3PBZZ8qlxA3/kMuTlzg
	 DNd1rutEsB0bVKOALnvvFrRyK7z6UcGMlqnqu4GHlTIHpzavQj9w88rxo3KIXzqQsb
	 z+4zy7ml2Zj3Hvcj0OHfLyf8e9p2QF+8UDenzuMw18SHgNS0CkbgWPWm06CPsL4qiN
	 w321oZQ9JCk3SFA9E+YHGMHyqXTL5ZQuTRNTmdxiZWAwYhkRlsZHoLktrf+JRcCSI1
	 UXeHTplMpsNMo3EY3CwrWn5z/PB+8dCZe2gIWjkviaJD7fBclOXOgul7nkxTle1eqh
	 x53mV+nqUNJAw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E0225C4332C;
	Fri,  2 Aug 2024 08:30:31 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4 0/3] ioctl support for AF_VSOCK and
 virtio-based transports
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <172258743191.4228.3464399584779982501.git-patchwork-notify@kernel.org>
Date: Fri, 02 Aug 2024 08:30:31 +0000
References: <20240730-ioctl-v4-0-16d89286a8f0@outlook.com>
In-Reply-To: <20240730-ioctl-v4-0-16d89286a8f0@outlook.com>
To: Luigi Leonardi via B4 Relay <devnull+luigi.leonardi.outlook.com@kernel.org>
Cc: sgarzare@redhat.com, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, stefanha@redhat.com, mst@redhat.com,
 jasowang@redhat.com, eperezma@redhat.com, xuanzhuo@linux.alibaba.com,
 virtualization@lists.linux.dev, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 luigi.leonardi@outlook.com, daan.j.demeyer@gmail.com

Hello:

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Tue, 30 Jul 2024 21:43:05 +0200 you wrote:
> This patch series introduce the support for ioctl(s) in AF_VSOCK.
> The only ioctl currently available is SIOCOUTQ, which returns
> the number of unsent or unacked packets. It is available for
> SOCK_STREAM, SOCK_SEQPACKET and SOCK_DGRAM.
> 
> As this information is transport-dependent, a new optional callback
> is introduced: unsent_bytes.
> 
> [...]

Here is the summary with links:
  - [net-next,v4,1/3] vsock: add support for SIOCOUTQ ioctl
    https://git.kernel.org/netdev/net-next/c/744500d81f81
  - [net-next,v4,2/3] vsock/virtio: add SIOCOUTQ support for all virtio based transports
    https://git.kernel.org/netdev/net-next/c/e6ab45005772
  - [net-next,v4,3/3] test/vsock: add ioctl unsent bytes test
    https://git.kernel.org/netdev/net-next/c/18ee44ce97c1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



