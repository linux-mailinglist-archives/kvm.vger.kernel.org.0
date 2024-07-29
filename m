Return-Path: <kvm+bounces-22527-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 17EBC93FEE0
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 22:13:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 96DE31F22871
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 20:13:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 045C218A923;
	Mon, 29 Jul 2024 20:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b="X1ABmKZ4"
X-Original-To: kvm@vger.kernel.org
Received: from mx1.sberdevices.ru (mx2.sberdevices.ru [45.89.224.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E8AC188CB3;
	Mon, 29 Jul 2024 20:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.89.224.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722283983; cv=none; b=hxdvfq2DwU92VldLit3I3Kz0NSpnRodxcV8l8Kw+88jW/NX8Sc1zkpkfKeEIzoVZ7qEGY+SRjxuXerU6LcXI5cMFLAZerfDNSl6LANtaqdFq08AZbxzyuchqdRfgYzZxy340CE3uRo4WOyhn8cMpEZkJHZ0TY81TQbmGVjzx6/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722283983; c=relaxed/simple;
	bh=crICF1i5RQKEnw5gmthwsCxsW7dV+fc7ifqG4NAJLHE=;
	h=Message-ID:Date:MIME-Version:In-Reply-To:To:CC:From:Subject:
	 Content-Type; b=jQ0epu8aBDU2Umyz53hq9AFaLVq8U6YhNPidTLxgx58L1yOh65fKowCwaxyrIpbUWM+sdJguC/Cu9IG2LwSplVoZbvBLkcKB5vSAf1NoZIJaIoLvWChAFFUKDeFC+earSKX04VQuV2ksjqM0u38xDIxejug4Rztb7Zzq/QWDdU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com; spf=pass smtp.mailfrom=salutedevices.com; dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b=X1ABmKZ4; arc=none smtp.client-ip=45.89.224.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=salutedevices.com
Received: from p-infra-ksmg-sc-msk02.sberdevices.ru (localhost [127.0.0.1])
	by mx1.sberdevices.ru (Postfix) with ESMTP id E8F50120003;
	Mon, 29 Jul 2024 23:12:56 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru E8F50120003
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
	s=mail; t=1722283976;
	bh=wqCOH0OMZnBR80J18ev/8FeOuZRcI6ZPg6yEni5bP5E=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type:From;
	b=X1ABmKZ44Jlf8L31CHuQAeIk4ZIqA6FntZHkexU9nNc/jFP1zP/GqdXt8tmR7aRMK
	 hEXlF60medUb1VpmwEdY2Y78WUdmT8XBBB5wJSljFT6TrIDVQZWlSFJxxKpxTzxL67
	 TIpv7Dctt1Rxat40rZVpl75dUMp+7ohkUBxK5f2qxfZbad28FuC5mqduVUtMX29L2B
	 uKqrvUuC76txADmCn6hykswCviJN2lJe2SS/Yw0nyaOwe2P/Fp8a/Ub9npGnph8hhp
	 tpMLqcRmiINh5AiqbgvlWCWZECR6KtPcgC5d2cEBoEohi196cjA4z5FnM+CJuNRAQM
	 L/wZAreMfwHOw==
Received: from smtp.sberdevices.ru (p-i-exch-sc-m02.sberdevices.ru [172.16.192.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.sberdevices.ru (Postfix) with ESMTPS;
	Mon, 29 Jul 2024 23:12:56 +0300 (MSK)
Received: from [172.28.128.200] (100.64.160.123) by
 p-i-exch-sc-m02.sberdevices.ru (172.16.192.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Mon, 29 Jul 2024 23:12:55 +0300
Message-ID: <e1647f5f-5056-5cf0-e81c-5ef71fd6efd0@salutedevices.com>
Date: Mon, 29 Jul 2024 23:00:36 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US
In-Reply-To: <20240710212555.1617795-8-amery.hung@bytedance.com>
To: <stefanha@redhat.com>, <sgarzare@redhat.com>, <mst@redhat.com>,
	<jasowang@redhat.com>, <xuanzhuo@linux.alibaba.com>, <davem@davemloft.net>,
	<edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<kys@microsoft.com>, <haiyangz@microsoft.com>, <wei.liu@kernel.org>,
	<decui@microsoft.com>, <bryantan@vmware.com>, <vdasa@vmware.com>,
	<pv-drivers@vmware.com>
CC: <dan.carpenter@linaro.org>, <simon.horman@corigine.com>,
	<oxffffaa@gmail.com>, <kvm@vger.kernel.org>,
	<virtualization@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-hyperv@vger.kernel.org>,
	<bpf@vger.kernel.org>, <bobby.eshleman@bytedance.com>,
	<jiang.wang@bytedance.com>, <amery.hung@bytedance.com>,
	<ameryhung@gmail.com>, <xiyou.wangcong@gmail.com>, <kernel@sberdevices.ru>
From: Arseniy Krasnov <avkrasnov@salutedevices.com>
Subject: [RFC PATCH net-next v6 07/14] virtio/vsock: add common datagram send
 path
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) To
 p-i-exch-sc-m02.sberdevices.ru (172.16.192.103)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 186779 [Jul 29 2024]
X-KSMG-AntiSpam-Version: 6.1.0.4
X-KSMG-AntiSpam-Envelope-From: avkrasnov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 24 0.3.24 186c4d603b899ccfd4883d230c53f273b80e467f, {Tracking_from_domain_doesnt_match_to}, smtp.sberdevices.ru:5.0.1,7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;salutedevices.com:7.1.1;100.64.160.123:7.1.2;127.0.0.199:7.1.2, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2024/07/29 16:49:00 #26175127
X-KSMG-AntiVirus-Status: Clean, skipped

Hi,

> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> index a1c76836d798..46cd1807f8e3 100644
> --- a/net/vmw_vsock/virtio_transport_common.c
> +++ b/net/vmw_vsock/virtio_transport_common.c
> @@ -1040,13 +1040,98 @@ int virtio_transport_shutdown(struct vsock_sock *vsk, int mode)
>  }
>  EXPORT_SYMBOL_GPL(virtio_transport_shutdown);
>  
> +static int virtio_transport_dgram_send_pkt_info(struct vsock_sock *vsk,
> +						struct virtio_vsock_pkt_info *info)
> +{
> +	u32 src_cid, src_port, dst_cid, dst_port;
> +	const struct vsock_transport *transport;
> +	const struct virtio_transport *t_ops;
> +	struct sock *sk = sk_vsock(vsk);
> +	struct virtio_vsock_hdr *hdr;
> +	struct sk_buff *skb;
> +	void *payload;
> +	int noblock = 0;
> +	int err;
> +
> +	info->type = virtio_transport_get_type(sk_vsock(vsk));
> +
> +	if (info->pkt_len > VIRTIO_VSOCK_MAX_PKT_BUF_SIZE)
> +		return -EMSGSIZE;

Small suggestion, i think we can check for packet length earlier ? Before
info->type = ...

> +
> +	transport = vsock_dgram_lookup_transport(info->remote_cid, info->remote_flags);
> +	t_ops = container_of(transport, struct virtio_transport, transport);
> +	if (unlikely(!t_ops))
> +		return -EFAULT;
> +
> +	if (info->msg)
> +		noblock = info->msg->msg_flags & MSG_DONTWAIT;
> +
> +	/* Use sock_alloc_send_skb to throttle by sk_sndbuf. This helps avoid
> +	 * triggering the OOM.
> +	 */
> +	skb = sock_alloc_send_skb(sk, info->pkt_len + VIRTIO_VSOCK_SKB_HEADROOM,
> +				  noblock, &err);
> +	if (!skb)
> +		return err;
> +
> +	skb_reserve(skb, VIRTIO_VSOCK_SKB_HEADROOM);
> +
> +	src_cid = t_ops->transport.get_local_cid();
> +	src_port = vsk->local_addr.svm_port;
> +	dst_cid = info->remote_cid;
> +	dst_port = info->remote_port;
> +
> +	hdr = virtio_vsock_hdr(skb);
> +	hdr->type	= cpu_to_le16(info->type);
> +	hdr->op		= cpu_to_le16(info->op);
> +	hdr->src_cid	= cpu_to_le64(src_cid);
> +	hdr->dst_cid	= cpu_to_le64(dst_cid);
> +	hdr->src_port	= cpu_to_le32(src_port);
> +	hdr->dst_port	= cpu_to_le32(dst_port);
> +	hdr->flags	= cpu_to_le32(info->flags);
> +	hdr->len	= cpu_to_le32(info->pkt_len);

There is function 'virtio_transport_init_hdr()' in this file, may be reuse it ?

> +
> +	if (info->msg && info->pkt_len > 0) {

If pkt_len is 0, do we really need to send such packets ? Because for connectible
sockets, we ignore empty OP_RW packets.

> +		payload = skb_put(skb, info->pkt_len);
> +		err = memcpy_from_msg(payload, info->msg, info->pkt_len);
> +		if (err)
> +			goto out;
> +	}
> +
> +	trace_virtio_transport_alloc_pkt(src_cid, src_port,
> +					 dst_cid, dst_port,
> +					 info->pkt_len,
> +					 info->type,
> +					 info->op,
> +					 info->flags,
> +					 false);

^^^ For SOCK_DGRAM, include/trace/events/vsock_virtio_transport_common.h also should
be updated?

> +
> +	return t_ops->send_pkt(skb);
> +out:
> +	kfree_skb(skb);
> +	return err;
> +}
> +
>  int
>  virtio_transport_dgram_enqueue(struct vsock_sock *vsk,
>  			       struct sockaddr_vm *remote_addr,
>  			       struct msghdr *msg,
>  			       size_t dgram_len)
>  {
> -	return -EOPNOTSUPP;
> +	/* Here we are only using the info struct to retain style uniformity
> +	 * and to ease future refactoring and merging.
> +	 */
> +	struct virtio_vsock_pkt_info info = {
> +		.op = VIRTIO_VSOCK_OP_RW,
> +		.remote_cid = remote_addr->svm_cid,
> +		.remote_port = remote_addr->svm_port,
> +		.remote_flags = remote_addr->svm_flags,
> +		.msg = msg,
> +		.vsk = vsk,
> +		.pkt_len = dgram_len,
> +	};
> +
> +	return virtio_transport_dgram_send_pkt_info(vsk, &info);
>  }
>  EXPORT_SYMBOL_GPL(virtio_transport_dgram_enqueue);
>  
> -- 
> 2.20.1

Thanks, Arseniy

