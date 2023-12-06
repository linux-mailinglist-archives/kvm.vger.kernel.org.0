Return-Path: <kvm+bounces-3745-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 023ED8077BD
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 19:42:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B233E2821FF
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 18:42:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2A973FE3E;
	Wed,  6 Dec 2023 18:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b="AAV+fcuh"
X-Original-To: kvm@vger.kernel.org
Received: from mx1.sberdevices.ru (mx1.sberdevices.ru [37.18.73.165])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20C13D67;
	Wed,  6 Dec 2023 10:42:40 -0800 (PST)
Received: from p-infra-ksmg-sc-msk01 (localhost [127.0.0.1])
	by mx1.sberdevices.ru (Postfix) with ESMTP id 32B6710008B;
	Wed,  6 Dec 2023 21:42:37 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 32B6710008B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
	s=mail; t=1701888157;
	bh=PAf3gWYNr1X6Etoo5fn0Vczq30SXtQKZGFNGORjRGC8=;
	h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type:From;
	b=AAV+fcuhHm0Evps55dof7IXXSARFQOz4XCrLKyDmqV/MHnMv+FBbH20vGfXDcx+DZ
	 vVGUzbH1+BI16V3d8jpitWxYN/JE+rvI2+PlqHJPY0b4tw+oYpbcIJnp3fZiFDoNCH
	 0BZoEqwFlLTZ36xUwhqX2A32xzhPAhMJ0kbFG+TXn53QKR6RncJ62fnvp9u+kYYrOj
	 ZeksIl0PPQx2XYMQjx3O2yejtKDzcx7/UF1Z5nHc3pXOCrXUr+KMU/Jj3hyKvZ0EZM
	 7TgUzpJ4nNNEx810vz6MtHB701dA/QCLJRiMBLOK8zwezjeAk0e7Rr1qAVJvFJ6D+a
	 2fQBHpWr1thXA==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.sberdevices.ru (Postfix) with ESMTPS;
	Wed,  6 Dec 2023 21:42:36 +0300 (MSK)
Received: from [192.168.0.106] (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Wed, 6 Dec 2023 21:42:36 +0300
Message-ID: <44c8b8dd-24e4-24c9-c7f9-3d7db892095d@salutedevices.com>
Date: Wed, 6 Dec 2023 21:34:27 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net] vsock/virtio: fix "comparison of distinct pointer
 types lacks a cast" warning
Content-Language: en-US
To: Stefano Garzarella <sgarzare@redhat.com>, <netdev@vger.kernel.org>
CC: Jakub Kicinski <kuba@kernel.org>, "David S. Miller" <davem@davemloft.net>,
	<virtualization@lists.linux.dev>, "Michael S. Tsirkin" <mst@redhat.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Stefan Hajnoczi
	<stefanha@redhat.com>, Eric Dumazet <edumazet@google.com>, Paolo Abeni
	<pabeni@redhat.com>
References: <20231206164143.281107-1-sgarzare@redhat.com>
From: Arseniy Krasnov <avkrasnov@salutedevices.com>
In-Reply-To: <20231206164143.281107-1-sgarzare@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 181917 [Dec 06 2023]
X-KSMG-AntiSpam-Version: 6.0.0.2
X-KSMG-AntiSpam-Envelope-From: avkrasnov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 5 0.3.5 98d108ddd984cca1d7e65e595eac546a62b0144b, {Tracking_from_domain_doesnt_match_to}, p-i-exch-sc-m01.sberdevices.ru:5.0.1,7.1.1;100.64.160.123:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2;salutedevices.com:7.1.1, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/12/06 17:41:00 #22621737
X-KSMG-AntiVirus-Status: Clean, skipped



On 06.12.2023 19:41, Stefano Garzarella wrote:
> After backporting commit 581512a6dc93 ("vsock/virtio: MSG_ZEROCOPY
> flag support") in CentOS Stream 9, CI reported the following error:
> 
>     In file included from ./include/linux/kernel.h:17,
>                      from ./include/linux/list.h:9,
>                      from ./include/linux/preempt.h:11,
>                      from ./include/linux/spinlock.h:56,
>                      from net/vmw_vsock/virtio_transport_common.c:9:
>     net/vmw_vsock/virtio_transport_common.c: In function ‘virtio_transport_can_zcopy‘:
>     ./include/linux/minmax.h:20:35: error: comparison of distinct pointer types lacks a cast [-Werror]
>        20 |         (!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
>           |                                   ^~
>     ./include/linux/minmax.h:26:18: note: in expansion of macro ‘__typecheck‘
>        26 |                 (__typecheck(x, y) && __no_side_effects(x, y))
>           |                  ^~~~~~~~~~~
>     ./include/linux/minmax.h:36:31: note: in expansion of macro ‘__safe_cmp‘
>        36 |         __builtin_choose_expr(__safe_cmp(x, y), \
>           |                               ^~~~~~~~~~
>     ./include/linux/minmax.h:45:25: note: in expansion of macro ‘__careful_cmp‘
>        45 | #define min(x, y)       __careful_cmp(x, y, <)
>           |                         ^~~~~~~~~~~~~
>     net/vmw_vsock/virtio_transport_common.c:63:37: note: in expansion of macro ‘min‘
>        63 |                 int pages_to_send = min(pages_in_iov, MAX_SKB_FRAGS);
> 
> We could solve it by using min_t(), but this operation seems entirely
> unnecessary, because we also pass MAX_SKB_FRAGS to iov_iter_npages(),
> which performs almost the same check, returning at most MAX_SKB_FRAGS
> elements. So, let's eliminate this unnecessary comparison.
> 
> Fixes: 581512a6dc93 ("vsock/virtio: MSG_ZEROCOPY flag support")
> Cc: avkrasnov@salutedevices.com
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---

Reviewed-by: Arseniy Krasnov <avkrasnov@salutedevices.com>

>  net/vmw_vsock/virtio_transport_common.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> index f6dc896bf44c..c8e162c9d1df 100644
> --- a/net/vmw_vsock/virtio_transport_common.c
> +++ b/net/vmw_vsock/virtio_transport_common.c
> @@ -59,8 +59,7 @@ static bool virtio_transport_can_zcopy(const struct virtio_transport *t_ops,
>  	t_ops = virtio_transport_get_ops(info->vsk);
>  
>  	if (t_ops->can_msgzerocopy) {
> -		int pages_in_iov = iov_iter_npages(iov_iter, MAX_SKB_FRAGS);
> -		int pages_to_send = min(pages_in_iov, MAX_SKB_FRAGS);
> +		int pages_to_send = iov_iter_npages(iov_iter, MAX_SKB_FRAGS);
>  
>  		/* +1 is for packet header. */
>  		return t_ops->can_msgzerocopy(pages_to_send + 1);

