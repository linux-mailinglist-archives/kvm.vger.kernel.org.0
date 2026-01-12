Return-Path: <kvm+bounces-67772-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id E6D28D13D04
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 16:53:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 60116300A52A
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 15:52:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BA413624B5;
	Mon, 12 Jan 2026 15:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="EuMAKbbp"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [185.226.149.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 000D036165F;
	Mon, 12 Jan 2026 15:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768233153; cv=none; b=AIJKsk07pwRBIo51PE6VeIOgZJkgl67og8ybx6GtggrnpxwWThKCgKOn7ysS3GSWCngLKwKbWC73TMAltowzXTZX8IQlQZQREpbgzh+2EVNU0V+3q+olLqSVM1H0GwgAPLOa/tSWRttmLtfMrbpsUixD2lPV2enFwLI2hzedyos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768233153; c=relaxed/simple;
	bh=uWdMfLpyFqCM6QUQnGBqJ9Jverl7VYci/FbX9kLLCBU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s2Yx3Pe+0VPzWTAhM8fgJVIvH+8/Yetm/ZaTJXtG5SGyrFxevMHjvVj09uW4OJLfMtO0DatuzLrm7I2WB4pZs+4saSMjq/SffO3WBL4LkoKY1kK1aL75Bky8GaNioB2hN/yvWSMMZ35D+/DUFv/srEjBMx8DBXJDEvWrkCA83W8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=EuMAKbbp; arc=none smtp.client-ip=185.226.149.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
	by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1vfKDL-00DJku-4N; Mon, 12 Jan 2026 16:52:19 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector2; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID;
	bh=GWWW8b5mnc7rG7rUOW75O/sWS9DviVgrNbyP0oeVT/4=; b=EuMAKbbpxHZytDsHQcTcxY/tRf
	M6EQpShuvBzpVefeW1VnwJx688LOINe0gGPfEuYjixo4uqNGNxyVix73MZKqz6q/wjV0DOtLCdSWk
	HPgGyv3Y/9GuCprScaQfHB0sd2JYUQcHB/w83puYt3JyRvQqOFbFn0/XAEh+K1qLvMf1B9nQJizyK
	MMRPfmVH5J2d5KAuilYCERiegQzHvxp1WeOCcrSAnVrvfpZMcN8CjiR7KnlsE7+WtZFPa5DVjZ4kI
	v6b0Q8fbjQFzq5LKlV5g/to4CxempGfyW6DhWkU6mt9j506ILSqI60MEfT7s403TuCjwVRlKNWH8C
	RIbFEvvg==;
Received: from [10.9.9.72] (helo=submission01.runbox)
	by mailtransmit02.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1vfKDJ-000717-W0; Mon, 12 Jan 2026 16:52:18 +0100
Received: by submission01.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1vfKD6-00AWYO-OL; Mon, 12 Jan 2026 16:52:04 +0100
Message-ID: <080d7ae8-e184-4af8-bd72-765bb30b63a5@rbox.co>
Date: Mon, 12 Jan 2026 16:52:02 +0100
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
Content-Language: pl-PL, en-GB
From: Michal Luczaj <mhal@rbox.co>
In-Reply-To: <aWT6EH8oWpw-ADtm@sgarzare-redhat>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/12/26 14:44, Stefano Garzarella wrote:
> On Sun, Jan 11, 2026 at 11:59:54AM +0100, Michal Luczaj wrote:
>>>> diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
>>>> index bbe3723babdc..21c8616100f1 100644
>>>> --- a/tools/testing/vsock/vsock_test.c
>>>> +++ b/tools/testing/vsock/vsock_test.c
>>>> @@ -2403,6 +2403,11 @@ static struct test_case test_cases[] = {
>>>> 		.run_client = test_stream_accepted_setsockopt_client,
>>>> 		.run_server = test_stream_accepted_setsockopt_server,
>>>> 	},
>>>> +	{
>>>> +		.name = "SOCK_STREAM MSG_ZEROCOPY coalescence corruption",
>>>
>>> This is essentially a regression test for virtio transport, so I'd add
>>> virtio in the test name.
>>
>> Isn't virtio transport unaffected? It's about loopback transport (that
>> shares common code with virtio transport).
> 
> Why virtio transport is not affected?

With the usual caveat that I may be completely missing something, aren't
all virtio-transport's rx skbs linear? See virtio_vsock_alloc_linear_skb()
in virtio_vsock_rx_fill().


