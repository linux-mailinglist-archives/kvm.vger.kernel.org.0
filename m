Return-Path: <kvm+bounces-69224-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0CkeAceMeGmqqwEAu9opvQ
	(envelope-from <kvm+bounces-69224-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 11:00:39 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id DFF34924FB
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 11:00:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 6D9013004F34
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 10:00:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A24882E8897;
	Tue, 27 Jan 2026 10:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bwq33vMM"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C23FE42A80;
	Tue, 27 Jan 2026 10:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769508028; cv=none; b=Rjcz+fw+3pgL/rWjFgh9X3TvDVtC0q5D8IZ1eds/C4LU/uNn5VEZIqGjs13nvrg4zSrDlnvAKrxjKtGZSmDBWZHE1a/CO9MVIPqyWreorIJ2EckWcmmPy4F+3vyPVMtBWu5C3PMKh0+PjM4G9gjhOJzL0avAwSHnI+csnOY5BW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769508028; c=relaxed/simple;
	bh=pFX7o4jnF86Kw+kDPGmdPv5bnMWnQbrDfS2O1hpEqs4=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=cytgWZfPvRg8BH7/ll53SBK2jcA/md8doyZwUO5MEQ1UFSwTgDBGqNtsqly3/9ACzD7oVGioX2g/7T33s3/fDtGr/ro+3mhD+oZT1ZcbCbRqwUbotoslmrM7/EyMaGT4iSZ5icJXK471RUipMx3UNUCfzrOnDLTfPrPCZpevv6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bwq33vMM; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EF80C116C6;
	Tue, 27 Jan 2026 10:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769508028;
	bh=pFX7o4jnF86Kw+kDPGmdPv5bnMWnQbrDfS2O1hpEqs4=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=Bwq33vMMxxBbY+usGcLH3tB23eOxWDQavWIXv+/3aqwvQAZDDxI7Quk79oREjQaHB
	 lehYy3Hk0p85ALNuOihE1gI8raMTsGeeK5PZx35Xg80sA8KoB30XzR4SCAKNocjpLt
	 aiAmB51isIp8feiKM5CqA1lSqinLTeTH4zpbcxWHOufnD2kgS6r+Teq+yZ1pUZ9O+K
	 xt63LFwp5ZuwaPT/G+YIWsr9qYIz/dTcYJnXZsOmYtM/73M6J9Z1FEjdRmvMcA0yW8
	 5SUGh84fXLebmJ33+mQXDwqQoHRXyRzL2uwAGxzX6eQjK/YmXTV8Z2LAZmKj785jhY
	 w3UEKSsO3bv7A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id C8E36380A970;
	Tue, 27 Jan 2026 10:00:23 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v16 00/12] vsock: add namespace support to
 vhost-vsock and loopback
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <176950802260.768623.1051400818624436461.git-patchwork-notify@kernel.org>
Date: Tue, 27 Jan 2026 10:00:22 +0000
References: <20260121-vsock-vmtest-v16-0-2859a7512097@meta.com>
In-Reply-To: <20260121-vsock-vmtest-v16-0-2859a7512097@meta.com>
To: Bobby Eshleman <bobbyeshleman@gmail.com>
Cc: sgarzare@redhat.com, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, stefanha@redhat.com,
 mst@redhat.com, jasowang@redhat.com, eperezma@redhat.com,
 xuanzhuo@linux.alibaba.com, kys@microsoft.com, haiyangz@microsoft.com,
 wei.liu@kernel.org, decui@microsoft.com, bryan-bt.tan@broadcom.com,
 vishnu.dasa@broadcom.com, bcm-kernel-feedback-list@broadcom.com,
 shuah@kernel.org, longli@microsoft.com, corbet@lwn.net,
 linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
 netdev@vger.kernel.org, kvm@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-kselftest@vger.kernel.org, berrange@redhat.com, sargun@sargun.me,
 linux-doc@vger.kernel.org, bobbyeshleman@meta.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69224-lists,kvm=lfdr.de,netdevbpf];
	RCVD_TLS_LAST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[patchwork-bot@kernel.org,kvm@vger.kernel.org];
	FREEMAIL_TO(0.00)[gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCPT_COUNT_TWELVE(0.00)[32];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NO_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	MISSING_XM_UA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,vmtest.sh:url]
X-Rspamd-Queue-Id: DFF34924FB
X-Rspamd-Action: no action

Hello:

This series was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 21 Jan 2026 14:11:40 -0800 you wrote:
> This series adds namespace support to vhost-vsock and loopback. It does
> not add namespaces to any of the other guest transports (virtio-vsock,
> hyperv, or vmci).
> 
> The current revision supports two modes: local and global. Local
> mode is complete isolation of namespaces, while global mode is complete
> sharing between namespaces of CIDs (the original behavior).
> 
> [...]

Here is the summary with links:
  - [net-next,v16,01/12] vsock: add netns to vsock core
    https://git.kernel.org/netdev/net-next/c/eafb64f40ca4
  - [net-next,v16,02/12] virtio: set skb owner of virtio_transport_reset_no_sock() reply
    https://git.kernel.org/netdev/net-next/c/a6ae12a599e0
  - [net-next,v16,03/12] vsock: add netns support to virtio transports
    https://git.kernel.org/netdev/net-next/c/a69686327e42
  - [net-next,v16,04/12] selftests/vsock: increase timeout to 1200
    https://git.kernel.org/netdev/net-next/c/873e7de9f9a3
  - [net-next,v16,05/12] selftests/vsock: add namespace helpers to vmtest.sh
    https://git.kernel.org/netdev/net-next/c/423ec6383edb
  - [net-next,v16,06/12] selftests/vsock: prepare vm management helpers for namespaces
    https://git.kernel.org/netdev/net-next/c/fd1b41725d58
  - [net-next,v16,07/12] selftests/vsock: add vm_dmesg_{warn,oops}_count() helpers
    https://git.kernel.org/netdev/net-next/c/4e870ac81df7
  - [net-next,v16,08/12] selftests/vsock: use ss to wait for listeners instead of /proc/net
    https://git.kernel.org/netdev/net-next/c/7418f3bb3aa2
  - [net-next,v16,09/12] selftests/vsock: add tests for proc sys vsock ns_mode
    https://git.kernel.org/netdev/net-next/c/06cf7895abf9
  - [net-next,v16,10/12] selftests/vsock: add namespace tests for CID collisions
    https://git.kernel.org/netdev/net-next/c/605caec5adc2
  - [net-next,v16,11/12] selftests/vsock: add tests for host <-> vm connectivity with namespaces
    https://git.kernel.org/netdev/net-next/c/0424ee7c3a17
  - [net-next,v16,12/12] selftests/vsock: add tests for namespace deletion
    https://git.kernel.org/netdev/net-next/c/b3b7b33264c6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



