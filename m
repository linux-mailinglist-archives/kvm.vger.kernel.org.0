Return-Path: <kvm+bounces-31476-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 063E99C3FD3
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 14:50:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B27F01F22AEC
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 13:50:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5631819E804;
	Mon, 11 Nov 2024 13:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b="CHXPUy6E"
X-Original-To: kvm@vger.kernel.org
Received: from mx1.sberdevices.ru (mx1.sberdevices.ru [37.18.73.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD8F153BF6;
	Mon, 11 Nov 2024 13:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.18.73.165
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731333016; cv=none; b=aBP7k2QgsZmjAV9uWCoBHuzUa+s4OMaT/Gf1LXqSWSPxZWJ7JrcKz8Uopnjz25Y23SBMbrElHPTBmPZZnTPq5FscHPNffijV0FxymHBzbCdOm8vpgaPzGNJ3NZ1sAubPNRywP+J6KOZHYGxLU+dvS150r1PPCEBeyffKqTwfT0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731333016; c=relaxed/simple;
	bh=sJVpMYEIzB9SFeNfXS1EZPH02Rwcl8iCgMdd51bIvlM=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=PTVjUD+t1zK6NofL489e+rEm8qEqFms39gBPTgQ/53hgY3v5G9GQtVSoOAKfwWI+xEhF9DTGCVHlwTT0bgC5fHDGUKbVpIUmd/g5HpxJeX9Y8kb2rbydbQZP6tBbHoRIM4GrDkrzEqYozjxjQShFmXAeuTlcdLK93243uuDC1bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com; spf=pass smtp.mailfrom=salutedevices.com; dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b=CHXPUy6E; arc=none smtp.client-ip=37.18.73.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=salutedevices.com
Received: from p-infra-ksmg-sc-msk01.sberdevices.ru (localhost [127.0.0.1])
	by mx1.sberdevices.ru (Postfix) with ESMTP id 4C40E100007;
	Mon, 11 Nov 2024 16:49:57 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 4C40E100007
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
	s=mail; t=1731332997;
	bh=g0pytZrpgBh3guU1TbfOEDaDMwQNAGs2S0K7Jt+304I=;
	h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type:From;
	b=CHXPUy6Ekmyj0Zq/tZxfwosjmYBVkjpe5vjmTfbW1r/4bZQA0GVC/Yasss/h79rCG
	 QWfexo/NDWPrrlU7aMdOoE5lziwSpFZgQMP7gunVJFqgoYF8O+rLdxFgubsR4xVU83
	 LSB4N6fTRISFcx9FlEyDYMs6AMTaAg18xn77JI1FHAaImJf198T+Bql3jMeEaA7xcU
	 x0hEM9tLo3KqDx7LokNx8MkaUEGcEBwpYkD7IqDWiJdTw+F0GGVVSNKuW9ctqP8NFK
	 V4ZQYn8C6elL+rj+7/nJocOBV05gUgJk8bMaaZi72WQ8vBAUkg13U8Mh3aPHWzpV3a
	 wU7eT+l5G/PXQ==
Received: from smtp.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.sberdevices.ru (Postfix) with ESMTPS;
	Mon, 11 Nov 2024 16:49:57 +0300 (MSK)
Message-ID: <5d9cc8ba-ba60-cf37-5ffd-1e6bacf773c3@salutedevices.com>
Date: Mon, 11 Nov 2024 16:49:51 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net 3/4] virtio/vsock: Improve MSG_ZEROCOPY error handling
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
References: <20241106-vsock-mem-leaks-v1-0-8f4ffc3099e6@rbox.co>
 <20241106-vsock-mem-leaks-v1-3-8f4ffc3099e6@rbox.co>
From: Arseniy Krasnov <avkrasnov@salutedevices.com>
In-Reply-To: <20241106-vsock-mem-leaks-v1-3-8f4ffc3099e6@rbox.co>
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
X-KSMG-AntiSpam-Info: LuaCore: 41 0.3.41 623e98d5198769c015c72f45fabbb9f77bdb702b, {Tracking_from_domain_doesnt_match_to}, smtp.sberdevices.ru:7.1.1,5.0.1;127.0.0.199:7.1.2;salutedevices.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1, FromAlignment: s
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2024/11/11 06:58:00 #26843820
X-KSMG-AntiVirus-Status: Clean, skipped



On 06.11.2024 20:51, Michal Luczaj wrote:
> Add a missing kfree_skb() to prevent memory leaks.
> 
> Fixes: 581512a6dc93 ("vsock/virtio: MSG_ZEROCOPY flag support")
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

