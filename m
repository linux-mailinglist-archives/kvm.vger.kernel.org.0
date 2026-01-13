Return-Path: <kvm+bounces-67948-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EBEF1D19CFC
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 16:19:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2A9A630EA1C2
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 15:12:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD61638FEE8;
	Tue, 13 Jan 2026 15:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="CI+oWJf0"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [185.226.149.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C3FB2EA743;
	Tue, 13 Jan 2026 15:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768317117; cv=none; b=Ju0K4LkTeRwwt7KrlEOLOcahYbWfVdSmDLOCMMFAYrZwVitZXFNBvDQumhkjLoA8hlaIiM6+I7xs7+zyvpg8WyQ7fnbsaFAK4IzXnb7WhE2RzTGT4vrXnvh1nCsXvQLfIS1AqYwm4mVevpsOaZyqLRbK1LORI9aW0fF0/IeT6PU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768317117; c=relaxed/simple;
	bh=hx7AqJD3qv9gfYaKs+593kiJFrdJtZyUf80B12a0amk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=epYsFD3bPQyNrv+m2YL3Zp/ZzhUXvt9+mB9dgI1kPEjhwlqPgBVvK3Ye4RXhtMUVykh1LqDurKimyzd9jlbuMiXJbMkMWKjYAs9c8dQVkTDoJyof9uowN5+aqecnYQZggnd8p7pMBorS6Uzyg158fR2o4b4PhR75M4stDUNl9eA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=CI+oWJf0; arc=none smtp.client-ip=185.226.149.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
	by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1vfg3j-00GGMD-D0; Tue, 13 Jan 2026 16:11:51 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector2; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID;
	bh=1hHdeBqT1SYDsAZ2LmaivRkI41scFYVMHnCQzatSUk0=; b=CI+oWJf05SwV7jhnCaW7k7gABT
	qxVNCxGtOCUx4Mke4CP+G4yuHaLOTKzMi/LRhRT6NNNlzR/i7LOD0r+1j1TtuEKvsVI5T1TMO4hBF
	rmhyqW+uk/6voTHvGvWSk4cn5IaVxmQmmOy41ufnOeGPnDRit0Dd/uMw+qAYBwNCik9bU1fsKLM9h
	kWDthD/gdyWwpzOG45TPuyTISMB+obB45/LfQdiBvTDYt8Xo6jtwzqnAGxW80Cxz1iMfyHDqbauaF
	IF7ltuGvxFEbrl2vKzATcNY4/fodLaTGsZcs20CGDd+hyDCxmfnN7Y2B53KLUGhxTfKMYwZeJjPlx
	mSOvHL1A==;
Received: from [10.9.9.74] (helo=submission03.runbox)
	by mailtransmit03.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1vfg3i-0008Bn-TX; Tue, 13 Jan 2026 16:11:51 +0100
Received: by submission03.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1vfg3S-00D7GU-TT; Tue, 13 Jan 2026 16:11:35 +0100
Message-ID: <e16c6062-ca32-4c78-bb97-5860c28102fd@rbox.co>
Date: Tue, 13 Jan 2026 16:11:33 +0100
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
 <0b15644b-9394-4734-9c0e-0a6d1355604a@rbox.co>
 <aWYQRK-fRHOqQNc8@sgarzare-redhat>
Content-Language: pl-PL, en-GB
From: Michal Luczaj <mhal@rbox.co>
In-Reply-To: <aWYQRK-fRHOqQNc8@sgarzare-redhat>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/13/26 10:36, Stefano Garzarella wrote:
> On Mon, Jan 12, 2026 at 10:20:50PM +0100, Michal Luczaj wrote:
>> On 1/12/26 17:48, Stefano Garzarella wrote:
>>>>>>>> diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
>>>>>>>> index bbe3723babdc..21c8616100f1 100644
>>>>>>>> --- a/tools/testing/vsock/vsock_test.c
>>>>>>>> +++ b/tools/testing/vsock/vsock_test.c
>>>>>>>> @@ -2403,6 +2403,11 @@ static struct test_case test_cases[] = {
>>>>>>>> 		.run_client = test_stream_accepted_setsockopt_client,
>>>>>>>> 		.run_server = test_stream_accepted_setsockopt_server,
>>>>>>>> 	},
>>>>>>>> +	{
>>>>>>>> +		.name = "SOCK_STREAM MSG_ZEROCOPY coalescence corruption",
>>>>>>>
>>>>>>> This is essentially a regression test for virtio transport, so I'd add
>>>>>>> virtio in the test name.
>>>>>>
>>>>>> Isn't virtio transport unaffected? It's about loopback transport (that
>>>>>> shares common code with virtio transport).
>>>>>
>>>>> Why virtio transport is not affected?
>>>>
>>>> With the usual caveat that I may be completely missing something, aren't
>>>> all virtio-transport's rx skbs linear? See virtio_vsock_alloc_linear_skb()
>>>> in virtio_vsock_rx_fill().
>>>>
>>>
>>> True, but what about drivers/vhost/vsock.c ?
>>>
>>> IIUC in vhost_vsock_handle_tx_kick() we call vhost_vsock_alloc_skb(),
>>> that calls virtio_vsock_alloc_skb() and pass that skb to
>>> virtio_transport_recv_pkt(). So, it's also affected right?
>>
>> virtio_vsock_alloc_skb() returns a non-linear skb only if size >
>> SKB_WITH_OVERHEAD(PAGE_SIZE << PAGE_ALLOC_COSTLY_ORDER)). And that is way
>> more than GOOD_COPY_LEN, so we're good.
>>
>> At least until someone increases GOOD_COPY_LEN and/or reduces the size
>> condition for non-linear allocation. So, yeah, a bit brittle.
> 
> I see, thanks for clarify. So please add all of this conclusions in the 
> patch 1 description to make it clear that only loopback is affected, so 
> no guest/host attack is possible. (not really severe CVE)

OK, here's v2:
https://lore.kernel.org/netdev/20260113-vsock-recv-coalescence-v2-0-552b17837cf4@rbox.co/


