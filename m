Return-Path: <kvm+bounces-67365-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C81BFD0202B
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 11:06:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 60EE3317D2E8
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 09:59:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E2CB3AA1A6;
	Thu,  8 Jan 2026 09:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="CYqvsQfW"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [185.226.149.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B643ACA51;
	Thu,  8 Jan 2026 09:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767866318; cv=none; b=CBqRUYT9vxt4TdkTSv0TIBJFP2pAQDTu1inG0IwrA4xc/CuwhTc25EZ/tkmZ+hdM5WpBZpHNfYimAqcZ805B8cipnGRriuCGByVhlLbdshz5Jc2GHHVKa/qo1RzWm4qrTeNh3rbG9mIC6JZDTrwtW9iq6/ENkL5AdStC/SjW/Ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767866318; c=relaxed/simple;
	bh=OOi7zdhUhSxjZEg80i3heu5/A/kVGWDlC+6FE0vP2L4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KHRMsXkc3xEXCL9nGroktRYaBjlqYbZygGUYB0FEgBxsTjwMPqVx0boyaPwErsOcBgiQQacTy+HA3iLvrV8Xf6nCIDACV9C7c9RILKLyiPc3PLSbWLEUOOm1LRnFrcxvvQ9ZqxvOPGrpuBPew4t14SScA8n14y+boNJOd8L5n5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=CYqvsQfW; arc=none smtp.client-ip=185.226.149.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
	by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1vdmmY-0002Iq-PK; Thu, 08 Jan 2026 10:58:18 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector2; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID;
	bh=a4f65bwhcNDzgchnTfsfzNek4RVFvclKBpnDIBiuh5o=; b=CYqvsQfWsh6zVT3HpZSKzGluhz
	QFMy9K4ERI0k1L0eCx316lWKhdG+J+Ci6fkHh/EGj2S31I0YvPHIumKbdOrnxPYxQdVkTk+Nv8fcO
	0Q1+Z86IfyEvzx5XiEjTaWTL3l3LESD7Uer99JFIdmfgPB6e4J9wJ0m6uGwIj+roym6C8VcCLgu88
	5d7cM+Gy5cQYA3m9Dh09KDQJGesZP5ph4Oa5yS0KwUwhPPxC3uSCLAN2VIQkDvTgL+/tDva08XfPg
	6kXOz57GFCE+zj14BMuGz4rKny8/e9kTMgwhANAtW0D1Rg0fe2bEj5Oznx5FAJCNQRRgdL4WetmWA
	o0XsUkSg==;
Received: from [10.9.9.72] (helo=submission01.runbox)
	by mailtransmit03.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1vdmmY-0006dW-En; Thu, 08 Jan 2026 10:58:18 +0100
Received: by submission01.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1vdmmJ-0001RB-1Q; Thu, 08 Jan 2026 10:58:03 +0100
Message-ID: <5ae4dbd2-52e0-467d-8342-d3dd6d7029ff@rbox.co>
Date: Thu, 8 Jan 2026 10:58:01 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] vsock/virtio: Fix data loss/disclosure due to joining
 of non-linear skb in RX queue
To: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>,
 Stefano Garzarella <sgarzare@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>,
 Arseniy Krasnov <avkrasnov@salutedevices.com>
Cc: kvm@vger.kernel.org, virtualization@lists.linux.dev,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260108-vsock-recv-coalescence-v1-0-26f97bb9a99b@rbox.co>
Content-Language: pl-PL, en-GB
From: Michal Luczaj <mhal@rbox.co>
In-Reply-To: <20260108-vsock-recv-coalescence-v1-0-26f97bb9a99b@rbox.co>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/8/26 10:54, Michal Luczaj wrote:
> Loopback transport coalesces some skbs too eagerly. Handling a zerocopy
> (non-linear) skb as a linear one leads to skb data loss and kernel memory
> disclosure.
> 
> Plug the loss/leak by allowing only linear skb join. Provide a test.

Aaand I forgot to set the "net" prefix. Please let me know if I should
resend just for that.

Sorry,
Michal


