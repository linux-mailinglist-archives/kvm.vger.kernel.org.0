Return-Path: <kvm+bounces-67837-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 88331D156A4
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 22:22:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3024B30274E7
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 21:21:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8620E33FE2B;
	Mon, 12 Jan 2026 21:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="kUyhV8kN"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [185.226.149.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1DFF32E6BE;
	Mon, 12 Jan 2026 21:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768252880; cv=none; b=Ht7t1yGjwqPs0yMOOi4ZsYSYXSG/xilpM6wTPezIf0UPuYUwwOFPpLH93TWSor6XfOiIWt/9MAImBB3y4QzMuqhphUY4bIRUf0LZgPT3DsrufD5cza7a5tdpsSvT8/8HJtRUa3jySq/AepBVpEsXpt/JJ2bgH7HkX9Z6SHpJa6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768252880; c=relaxed/simple;
	bh=M2b/BVcIqPLH0m20b1o8UtrXdhDBjzroQliQQoaNdlM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NWAEvUx74IuoEbhGZrTU8htjXCgLmRlsIGKmIg8Q5nNrzrya3JXMUKi+0uRgNvD9sN8nQc/aCUcbFxDZ8ncDyj2SMgqI53IyW3Oy7HH+LSiZqJEyPPA6c87mr8pMo0MKBwj1All9b5fGRrmsVJJs5BE8qgkgG1Br5yxXGVAD8ME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=kUyhV8kN; arc=none smtp.client-ip=185.226.149.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
	by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1vfPLX-00E2ld-SM; Mon, 12 Jan 2026 22:21:07 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector2; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID;
	bh=rBR6vEUMh1Kl8UFFaGiQBub9jPk+Q3NHps34ZQeAWJo=; b=kUyhV8kNbBVDZ33ER/KR0TO31L
	qUmYM3IIozMfFBjFgpM/H0YIp/Qe/+WpDWV6BsGiDTTgL184ZM+IFmqy1U4FogjKfK0vK4+wuagPN
	1drjit2ZngjAAQXXfoeX1pxO5AhlBfeTcShP13pwkP7npucIRXFJ6t1+bMg9wlEOEPyGcanSlhhYZ
	yZesd8MpsEFA2FfMDaxX2wUn/KxFHbAa+vEYOfEJ+bfNus8fLNDIfPrxlOaZuMNY+/7XlDmUrq3K7
	u0HMgqdluuRcN3xYUcUwqZ6VXaWExpShaXm1uCzv8uJBOR79s/WdHT3m2CTx9bnj9o1d9gWDEZHOD
	KEUQ2zhA==;
Received: from [10.9.9.74] (helo=submission03.runbox)
	by mailtransmit02.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1vfPLW-0000Da-V6; Mon, 12 Jan 2026 22:21:07 +0100
Received: by submission03.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1vfPLH-00B6J8-L6; Mon, 12 Jan 2026 22:20:51 +0100
Message-ID: <0b15644b-9394-4734-9c0e-0a6d1355604a@rbox.co>
Date: Mon, 12 Jan 2026 22:20:50 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] vsock/test: Add test for a linear and non-linear skb
 getting coalesced
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>,
 Arseniy Krasnov <avkrasnov@salutedevices.com>, kvm@vger.kernel.org,
 virtualization@lists.linux.dev, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260108-vsock-recv-coalescence-v1-0-26f97bb9a99b@rbox.co>
 <20260108-vsock-recv-coalescence-v1-2-26f97bb9a99b@rbox.co>
 <aWEqjjE1vb_t35lQ@sgarzare-redhat>
 <76ca0c9f-dcda-4a53-ac1f-c5c28d1ecf44@rbox.co>
 <aWT6EH8oWpw-ADtm@sgarzare-redhat>
 <080d7ae8-e184-4af8-bd72-765bb30b63a5@rbox.co>
 <aWUk0axv-GZu7VD2@sgarzare-redhat>
Content-Language: pl-PL, en-GB
From: Michal Luczaj <mhal@rbox.co>
In-Reply-To: <aWUk0axv-GZu7VD2@sgarzare-redhat>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/12/26 17:48, Stefano Garzarella wrote:
>>>>>> diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
>>>>>> index bbe3723babdc..21c8616100f1 100644
>>>>>> --- a/tools/testing/vsock/vsock_test.c
>>>>>> +++ b/tools/testing/vsock/vsock_test.c
>>>>>> @@ -2403,6 +2403,11 @@ static struct test_case test_cases[] = {
>>>>>> 		.run_client = test_stream_accepted_setsockopt_client,
>>>>>> 		.run_server = test_stream_accepted_setsockopt_server,
>>>>>> 	},
>>>>>> +	{
>>>>>> +		.name = "SOCK_STREAM MSG_ZEROCOPY coalescence corruption",
>>>>>
>>>>> This is essentially a regression test for virtio transport, so I'd add
>>>>> virtio in the test name.
>>>>
>>>> Isn't virtio transport unaffected? It's about loopback transport (that
>>>> shares common code with virtio transport).
>>>
>>> Why virtio transport is not affected?
>>
>> With the usual caveat that I may be completely missing something, aren't
>> all virtio-transport's rx skbs linear? See virtio_vsock_alloc_linear_skb()
>> in virtio_vsock_rx_fill().
>>
> 
> True, but what about drivers/vhost/vsock.c ?
> 
> IIUC in vhost_vsock_handle_tx_kick() we call vhost_vsock_alloc_skb(), 
> that calls virtio_vsock_alloc_skb() and pass that skb to 
> virtio_transport_recv_pkt(). So, it's also affected right?

virtio_vsock_alloc_skb() returns a non-linear skb only if size >
SKB_WITH_OVERHEAD(PAGE_SIZE << PAGE_ALLOC_COSTLY_ORDER)). And that is way
more than GOOD_COPY_LEN, so we're good.

At least until someone increases GOOD_COPY_LEN and/or reduces the size
condition for non-linear allocation. So, yeah, a bit brittle.

> BTW in general we consider loopback as one of virtio devices since it 
> really shares with them most of the code.

Fair enough, I'll add "virtio" to the test name.

> That said, now I'm thinking more about Fixes tag.
> Before commit 6693731487a8 ("vsock/virtio: Allocate nonlinear SKBs for 
> handling large transmit buffers") was that a real issue?

I don't really think that commit changes anything for the zerocopy case. It
only makes some big (>GOOD_COPY_LEN) non-ZC skbs turn non-linear.


