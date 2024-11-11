Return-Path: <kvm+bounces-31478-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F15F9C3FFB
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 14:55:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9102A1C21B9E
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 13:55:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA44219E98C;
	Mon, 11 Nov 2024 13:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b="fRakcPYQ"
X-Original-To: kvm@vger.kernel.org
Received: from mx1.sberdevices.ru (mx2.sberdevices.ru [45.89.224.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77FF918BBA8;
	Mon, 11 Nov 2024 13:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.89.224.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731333291; cv=none; b=RHQ2w+wGu0vBw7ok2GoO7Fy0NI+HdyfDmkMnAXwZkytL4LbgFWovWxybB48RsH8s5NIs/jlZ5FopiLq/fRR29dPMkz0oWp/0gfHukwGDzHqmzoDleQwKVsbKG/TXuFtKHf7x2KX17v5AF2en3Gw3fUkxnLD8YyukqS2qzrWRwNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731333291; c=relaxed/simple;
	bh=To4Ng8I3roAF+xOZUz5oVZlbkp04BFvmLmbeIlXb85U=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=YJLP4FjqUunqZa/G48rdEpUCEJfNl/L9tSMlx7cKFJEA0559UNRJg/LZjLjWZMn4EK8JwKnJvCVpNIktVD8iZsPd3uEDk7D8lMwioKD4qY5cu2myCsCBjEsZSQA/RHxTfZvppiyxDVHy9yl1yQB+H86e9n6KdrselavH7XvpxdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com; spf=pass smtp.mailfrom=salutedevices.com; dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b=fRakcPYQ; arc=none smtp.client-ip=45.89.224.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=salutedevices.com
Received: from p-infra-ksmg-sc-msk02.sberdevices.ru (localhost [127.0.0.1])
	by mx1.sberdevices.ru (Postfix) with ESMTP id A5B2B120004;
	Mon, 11 Nov 2024 16:54:36 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru A5B2B120004
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
	s=mail; t=1731333276;
	bh=wG9GJftNEn9P2eUQzPGTJwlvGfDRgfnCYXn/04LGPHA=;
	h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type:From;
	b=fRakcPYQAS8KGUIkck3q/wKYodijRNeAz6OWjTyJ2gWS5gGqIDFTK+xkw0rrnqaT4
	 9JKg6gT9HYPOI9ARZgzljWSDXcIbtinvbNdkhSQ54abTxPQMvq3myzIeYWeMnMfbLF
	 NLegoYZz3cJeoZEYaTwsYBRgkPf9m7P5x/jvTkJxJzdkdyncQAYTbu57vWgpEI7O2+
	 iF3htMBT+Y/LarsqQjn+7sqOS7TNG/V3shmJkvbeCwMYb3WP5jROz92Cg1RO/oiAX0
	 /SmRTGXwZ8VxNDnzMgnOyjIBg7LPd5v07jq+ih5JHkl1Ei4A/vaVHJho2hQupGUbdu
	 lUk1ay3tICF2Q==
Received: from smtp.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.sberdevices.ru (Postfix) with ESMTPS;
	Mon, 11 Nov 2024 16:54:36 +0300 (MSK)
Message-ID: <39067785-6f2c-91fa-8d05-50ebe78f0151@salutedevices.com>
Date: Mon, 11 Nov 2024 16:54:35 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net v2 3/3] virtio/vsock: Improve MSG_ZEROCOPY error
 handling
Content-Language: en-US
To: Michal Luczaj <mhal@rbox.co>, Stefan Hajnoczi <stefanha@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>, "Michael S. Tsirkin"
	<mst@redhat.com>, Jason Wang <jasowang@redhat.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=c3=a9rez?=
	<eperezma@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Simon Horman <horms@kernel.org>, Jia He
	<justin.he@arm.com>, Dmitry Torokhov <dtor@vmware.com>, Andy King
	<acking@vmware.com>, George Zhang <georgezhang@vmware.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux.dev>,
	<netdev@vger.kernel.org>
References: <20241107-vsock-mem-leaks-v2-0-4e21bfcfc818@rbox.co>
 <20241107-vsock-mem-leaks-v2-3-4e21bfcfc818@rbox.co>
From: Arseniy Krasnov <avkrasnov@salutedevices.com>
In-Reply-To: <20241107-vsock-mem-leaks-v2-3-4e21bfcfc818@rbox.co>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: p-i-exch-a-m2.sberdevices.ru (172.24.196.120) To
 p-i-exch-a-m1.sberdevices.ru (172.24.196.116)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 189084 [Nov 11 2024]
X-KSMG-AntiSpam-Version: 6.1.1.7
X-KSMG-AntiSpam-Envelope-From: avkrasnov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 41 0.3.41 623e98d5198769c015c72f45fabbb9f77bdb702b, {Tracking_from_domain_doesnt_match_to}, smtp.sberdevices.ru:5.0.1,7.1.1;127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;salutedevices.com:7.1.1, FromAlignment: s
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2024/11/11 06:58:00 #26843820
X-KSMG-AntiVirus-Status: Clean, skipped



On 07.11.2024 23:46, Michal Luczaj wrote:
> Add a missing kfree_skb() to prevent memory leaks.
> 
> Fixes: 581512a6dc93 ("vsock/virtio: MSG_ZEROCOPY flag support")
> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
> Signed-off-by: Michal Luczaj <mhal@rbox.co>
> ---
>  net/vmw_vsock/virtio_transport_common.c | 1 +
>  1 file changed, 1 insertion(+)

Acked-by: Arseniy Krasnov <avkrasnov@salutedevices.com>

> 
> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> index cd075f608d4f6f48f894543e5e9c966d3e5f22df..e2e6a30b759bdc6371bb0d63ee2e77c0ba148fd2 100644
> --- a/net/vmw_vsock/virtio_transport_common.c
> +++ b/net/vmw_vsock/virtio_transport_common.c
> @@ -400,6 +400,7 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
>  			if (virtio_transport_init_zcopy_skb(vsk, skb,
>  							    info->msg,
>  							    can_zcopy)) {
> +				kfree_skb(skb);
>  				ret = -ENOMEM;
>  				break;
>  			}
> 

