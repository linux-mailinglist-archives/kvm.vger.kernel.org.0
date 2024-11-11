Return-Path: <kvm+bounces-31479-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 91EDD9C4000
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 14:55:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C36E11C20399
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 13:55:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCC4919F40B;
	Mon, 11 Nov 2024 13:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b="ilXtI8LN"
X-Original-To: kvm@vger.kernel.org
Received: from mx1.sberdevices.ru (mx1.sberdevices.ru [37.18.73.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1D4E19E7E2;
	Mon, 11 Nov 2024 13:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.18.73.165
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731333300; cv=none; b=LZ8krpODU9Tk+tcnj1U5+DqtdFei/O8BjE2zrFkL9Iyci750Mw2XzeZ/ntavoZc2adv+gjizrzcQShatwgaYmzZlLCIc+oy3EpAsdTVviVCIokhPB/PsGsdeq6ATVLQXoEFxWlKldso+fgnw2XJ1mk/Zb27ljK9fjrQA1yZtLwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731333300; c=relaxed/simple;
	bh=3AIzRIC5OKVPpTyWM/+8Z0N6yN6wKhmacDAOLD7O/TU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=EI9AZZqzgysrRxwbXr6yJ1UkcZ1DfljStuGym4oGNsrQpj7rHc24TYq2qC30gqHG6HJAcVvnvoeR4wTnR8dclXitXzzvFiz0cIJpn8xLV3zeXs7fvK7bAFDYhophLpjdzFtRnYGWygoZffj57K0fSP/15M/h44hz+z3ZqAYif4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com; spf=pass smtp.mailfrom=salutedevices.com; dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b=ilXtI8LN; arc=none smtp.client-ip=37.18.73.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=salutedevices.com
Received: from p-infra-ksmg-sc-msk01.sberdevices.ru (localhost [127.0.0.1])
	by mx1.sberdevices.ru (Postfix) with ESMTP id 1273F10000C;
	Mon, 11 Nov 2024 16:54:57 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 1273F10000C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
	s=mail; t=1731333297;
	bh=FWV3Qqqdnc9utZGXylqg53RcuPq+O2myaXXkkrv4XRk=;
	h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type:From;
	b=ilXtI8LNtANmZrwoM0tpn9wdFq7tL/ttQrqzYNx7kqc3IqAAnFMKLgiVSUDdijFOt
	 YCV2isJkVQXB2TQFOoVzoMGIItFKbSRvtcXvaY+Detdh4ituMFkQ3u4zDNYl38+mio
	 bJQvf3b996Rp7RIKmHcUZK9XVdybTYte02qfayzzcnp8gCIrAP6MY9a3Wm1aePwN/d
	 yNDr9/kUulkGBiv12+OmynOfvOzzncn//k8BdWtEZ6VIdQ24D7lQfDkN3hJzu9vELk
	 +mpudjZzvgo2U5vkjM0YeNWLETCTW2z9YBYIENdAAJacHTYekkM0auo5QJ6mZA65hD
	 7RwxkZGJh72pA==
Received: from smtp.sberdevices.ru (p-i-exch-sc-m02.sberdevices.ru [172.16.192.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.sberdevices.ru (Postfix) with ESMTPS;
	Mon, 11 Nov 2024 16:54:56 +0300 (MSK)
Message-ID: <b128c2ac-a8cc-4750-12e0-1b42a0ffdb89@salutedevices.com>
Date: Mon, 11 Nov 2024 16:54:55 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net v2 2/3] vsock: Fix sk_error_queue memory leak
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
 <20241107-vsock-mem-leaks-v2-2-4e21bfcfc818@rbox.co>
From: Arseniy Krasnov <avkrasnov@salutedevices.com>
In-Reply-To: <20241107-vsock-mem-leaks-v2-2-4e21bfcfc818@rbox.co>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: p-i-exch-a-m1.sberdevices.ru (172.24.196.116) To
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



On 07.11.2024 23:46, Michal Luczaj wrote:
> Kernel queues MSG_ZEROCOPY completion notifications on the error queue.
> Where they remain, until explicitly recv()ed. To prevent memory leaks,
> clean up the queue when the socket is destroyed.
> 
> unreferenced object 0xffff8881028beb00 (size 224):
>   comm "vsock_test", pid 1218, jiffies 4294694897
>   hex dump (first 32 bytes):
>     90 b0 21 17 81 88 ff ff 90 b0 21 17 81 88 ff ff  ..!.......!.....
>     00 00 00 00 00 00 00 00 00 b0 21 17 81 88 ff ff  ..........!.....
>   backtrace (crc 6c7031ca):
>     [<ffffffff81418ef7>] kmem_cache_alloc_node_noprof+0x2f7/0x370
>     [<ffffffff81d35882>] __alloc_skb+0x132/0x180
>     [<ffffffff81d2d32b>] sock_omalloc+0x4b/0x80
>     [<ffffffff81d3a8ae>] msg_zerocopy_realloc+0x9e/0x240
>     [<ffffffff81fe5cb2>] virtio_transport_send_pkt_info+0x412/0x4c0
>     [<ffffffff81fe6183>] virtio_transport_stream_enqueue+0x43/0x50
>     [<ffffffff81fe0813>] vsock_connectible_sendmsg+0x373/0x450
>     [<ffffffff81d233d5>] ____sys_sendmsg+0x365/0x3a0
>     [<ffffffff81d246f4>] ___sys_sendmsg+0x84/0xd0
>     [<ffffffff81d26f47>] __sys_sendmsg+0x47/0x80
>     [<ffffffff820d3df3>] do_syscall_64+0x93/0x180
>     [<ffffffff8220012b>] entry_SYSCALL_64_after_hwframe+0x76/0x7e
> 
> Fixes: 581512a6dc93 ("vsock/virtio: MSG_ZEROCOPY flag support")
> Signed-off-by: Michal Luczaj <mhal@rbox.co>
> ---
>  net/vmw_vsock/af_vsock.c | 3 +++
>  1 file changed, 3 insertions(+)

Acked-by: Arseniy Krasnov <avkrasnov@salutedevices.com>

> 
> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> index 35681adedd9aaec3565495158f5342b8aa76c9bc..dfd29160fe11c4675f872c1ee123d65b2da0dae6 100644
> --- a/net/vmw_vsock/af_vsock.c
> +++ b/net/vmw_vsock/af_vsock.c
> @@ -836,6 +836,9 @@ static void vsock_sk_destruct(struct sock *sk)
>  {
>  	struct vsock_sock *vsk = vsock_sk(sk);
>  
> +	/* Flush MSG_ZEROCOPY leftovers. */
> +	__skb_queue_purge(&sk->sk_error_queue);
> +
>  	vsock_deassign_transport(vsk);
>  
>  	/* When clearing these addresses, there's no need to set the family and
> 

