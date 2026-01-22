Return-Path: <kvm+bounces-68898-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UBlKKaJDcmnpfAAAu9opvQ
	(envelope-from <kvm+bounces-68898-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 16:34:58 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 2503468F8D
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 16:34:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C7A939A4374
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 14:51:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 698D226FA5A;
	Thu, 22 Jan 2026 14:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Iu0T1Xkz"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7125231A04E;
	Thu, 22 Jan 2026 14:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769093414; cv=none; b=QoXDueFBEkbmne51PBOMbZQ5O9pqN/0Y5GdPjclCfRzwPBB0z3bJeoFyFX3Qvd2sugUnrmL/Q/eErPpbfB1dELststjUaae63S9mKude6MQQe/tkJsQV2eCmyV96hxdknEbzfmQ8YN9L9XeJ4e218NIdM051rtbKwfcp/Lvjric=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769093414; c=relaxed/simple;
	bh=QeuSu09iZdi7umNIF+AkNkdR72XK1n5h/SkPckL2lro=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=SiPMRvftw+NIX6RZuzFUzh7fDrtKo3/MOdsPks1qnKBnPBKd8uj+v0yUeskh6uMBSTIyuHA5U0sObyRNhWcJPYaqMzYNwmjoILbUwGWjYY6d8l3biXcTNM0fPDSgb/dUZnLm5Iy9sy7CwixkhjH8a4CxAInNQtkerNkMVJd9k1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Iu0T1Xkz; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CACDCC116C6;
	Thu, 22 Jan 2026 14:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769093413;
	bh=QeuSu09iZdi7umNIF+AkNkdR72XK1n5h/SkPckL2lro=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=Iu0T1XkzFZ+virX1Vekgs1Nv2Hw056yHJZJOxyfwmJU+8bQG52Nlq0RG+xGCx9/95
	 ggIPOTV+eDYWJz09e25oXOAXMJUnjj94EE/r5uCnf++aLuSLowCv/7FuZAhVzJ6Jnb
	 +MYxKhuMezSjc7lbfZkg/wNAAGrt4WLcn9fSFGcf+lw4aLMtubOqwDeJC7+Om9FcU/
	 cPlXyJNFOQMldxDb1VQtI7556N0CkQXz8IgJEYePn4F0JJOODrdim5FQDMdt9KB0/K
	 hXwsW6ZdS3trHtSfC6y9fJa+y3rG7bxuMt0f5ZStPzVZy3aYpP89GyrTA7Folec9Q2
	 EgpaWCf0lwe4g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 8BE223808200;
	Thu, 22 Jan 2026 14:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v6 0/4] vsock/virtio: fix TX credit handling
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <176909341035.1749791.8198129903228053036.git-patchwork-notify@kernel.org>
Date: Thu, 22 Jan 2026 14:50:10 +0000
References: <20260121093628.9941-1-sgarzare@redhat.com>
In-Reply-To: <20260121093628.9941-1-sgarzare@redhat.com>
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: netdev@vger.kernel.org, horms@kernel.org, edumazet@google.com,
 mst@redhat.com, AVKrasnov@sberdevices.ru, davem@davemloft.net,
 virtualization@lists.linux.dev, pabeni@redhat.com, kuba@kernel.org,
 stefanha@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 imbrenda@linux.vnet.ibm.com, jasowang@redhat.com, xuanzhuo@linux.alibaba.com,
 eperezma@redhat.com, asias@redhat.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.96 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	DMARC_POLICY_ALLOW(0.00)[kernel.org,quarantine];
	TAGGED_FROM(0.00)[bounces-68898-lists,kvm=lfdr.de,netdevbpf];
	RCVD_TLS_LAST(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[142.0.200.124:from];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[18];
	MIME_TRACE(0.00)[0:+];
	FROM_NEQ_ENVFROM(0.00)[patchwork-bot@kernel.org,kvm@vger.kernel.org];
	FROM_NO_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	MISSING_XM_UA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[52.25.139.140:received,10.30.226.201:received];
	ASN(0.00)[asn:7979, ipnet:142.0.200.0/24, country:US];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:helo,dfw.mirrors.kernel.org:rdns]
X-Rspamd-Queue-Id: 2503468F8D
X-Rspamd-Action: no action

Hello:

This series was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 21 Jan 2026 10:36:24 +0100 you wrote:
> The original series was posted by Melbin K Mathew <mlbnkm1@gmail.com> till v4.
> Since it's a real issue and the original author seems busy, I'm sending
> the new version fixing my comments but keeping the authorship (and restoring
> mine on patch 2 as reported on v4).
> 
> v6:
> - Rebased on net tree since there was a conflict on patch 4 with another
>   test added.
> - No code changes.
> 
> [...]

Here is the summary with links:
  - [net,v6,1/4] vsock/virtio: fix potential underflow in virtio_transport_get_credit()
    https://git.kernel.org/netdev/net/c/3ef3d52a1a98
  - [net,v6,2/4] vsock/test: fix seqpacket message bounds test
    https://git.kernel.org/netdev/net/c/0a98de801369
  - [net,v6,3/4] vsock/virtio: cap TX credit to local buffer size
    https://git.kernel.org/netdev/net/c/8ee784fdf006
  - [net,v6,4/4] vsock/test: add stream TX credit bounds test
    https://git.kernel.org/netdev/net/c/2a689f76edd0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



