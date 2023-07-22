Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AABB75DB16
	for <lists+kvm@lfdr.de>; Sat, 22 Jul 2023 10:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbjGVInL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Jul 2023 04:43:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbjGVInK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Jul 2023 04:43:10 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD4FC26A2;
        Sat, 22 Jul 2023 01:42:44 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id 38308e7fff4ca-2b962535808so39424821fa.0;
        Sat, 22 Jul 2023 01:42:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690015362; x=1690620162;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1K17AalY+/hbLxI4K6YWiK8biPt1eaJq2leKEYGTWQc=;
        b=cFXBo/LvcqUTmRG9VlRlqzYmsWUdnwSzY/vKxHUIDv+FchTXJM0dEeKSc8MJFM5lPD
         mFaWd5LzrB9Qy+E8U2JvzhZau3ErQ75lGc0BYxtSnJvay1Hl7kkZbOdavAaXbWugukGY
         lra+xHwltifp2R8OM2I5AeMAbmIxqG3Wi/w8qgO/XvoZYwDdv0DnViiiga2o1lqxRHtZ
         pzWEESPgj9VNc4tZdL6v6XDw9My0XXfne/J6Mx3jqfb3/DJKOQUstRm0qkFZE44Lpq+O
         qMraaY0lgJyt0BWpws7T5m6HolO1kZh/P1bizFRVpj32SwnnHYa5y+jJLFCwo+razPYT
         RoFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690015362; x=1690620162;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1K17AalY+/hbLxI4K6YWiK8biPt1eaJq2leKEYGTWQc=;
        b=ZX7SildzlJSV2ASto/KNB7nem4/5GK8dp1R22lpt1XxpANaocwclcey69+j8WGYWTA
         mYJtRx84x+qLn+DHOsgay2zCV4B9jrxxs83Bnh0gqZI4S9fyeV+ADalPPOFD8oNF5fd2
         vieEBAiJeWe+mcv9sFbcaDLC6lAp5zKOgpBE/wueBouVdpKIW8d9ZIJDQFr/a/sWUP76
         DCNmbJKkW/ZRI/cZs2DGiunKHAuKHr9I0PsZzeWUqUCfqYIy3ZSagONSmdwjS5AHATrw
         nyt+ZgLWlJP1jbeY1YOHS5+xznyjZM4sd45cwuSm7QO1FYGBDqXUxzLnQ8WFDgeHV5Vg
         JJ5Q==
X-Gm-Message-State: ABy/qLZfP8oGKp6OZJaFu9o+obc4fJgRQbH9M0DvSajgPvUBXmERV5LC
        Yhx9i33zf/oVboznfxLXdZ8=
X-Google-Smtp-Source: APBJJlGm8XSLp/HEZ7qHXI4LBq9oLYyh/ZzUNMxGlbm48bQ+HKz129fG4naTXYiF6ikNyzet3ZlkuA==
X-Received: by 2002:a2e:8043:0:b0:2b6:d084:e589 with SMTP id p3-20020a2e8043000000b002b6d084e589mr3234452ljg.47.1690015361689;
        Sat, 22 Jul 2023 01:42:41 -0700 (PDT)
Received: from ?IPV6:2a00:1e88:c228:ec00:1b41:4959:c1a0:b9eb? ([2a00:1e88:c228:ec00:1b41:4959:c1a0:b9eb])
        by smtp.gmail.com with ESMTPSA id v13-20020a2e7a0d000000b002b736576a10sm1428606ljc.137.2023.07.22.01.42.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Jul 2023 01:42:40 -0700 (PDT)
Message-ID: <b15d237e-31b5-40ae-83fc-e71649febd2b@gmail.com>
Date:   Sat, 22 Jul 2023 11:42:38 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH RFC net-next v5 11/14] vhost/vsock: implement datagram
 support
Content-Language: en-US
To:     Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>
Cc:     Dan Carpenter <dan.carpenter@linaro.org>,
        Simon Horman <simon.horman@corigine.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        bpf@vger.kernel.org
References: <20230413-b4-vsock-dgram-v5-0-581bd37fdb26@bytedance.com>
 <20230413-b4-vsock-dgram-v5-11-581bd37fdb26@bytedance.com>
From:   Arseniy Krasnov <oxffffaa@gmail.com>
In-Reply-To: <20230413-b4-vsock-dgram-v5-11-581bd37fdb26@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 19.07.2023 03:50, Bobby Eshleman wrote:
> This commit implements datagram support for vhost/vsock by teaching
> vhost to use the common virtio transport datagram functions.
> 
> If the virtio RX buffer is too small, then the transmission is
> abandoned, the packet dropped, and EHOSTUNREACH is added to the socket's
> error queue.
> 
> Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
> ---
>  drivers/vhost/vsock.c    | 62 +++++++++++++++++++++++++++++++++++++++++++++---
>  net/vmw_vsock/af_vsock.c |  5 +++-
>  2 files changed, 63 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> index d5d6a3c3f273..da14260c6654 100644
> --- a/drivers/vhost/vsock.c
> +++ b/drivers/vhost/vsock.c
> @@ -8,6 +8,7 @@
>   */
>  #include <linux/miscdevice.h>
>  #include <linux/atomic.h>
> +#include <linux/errqueue.h>
>  #include <linux/module.h>
>  #include <linux/mutex.h>
>  #include <linux/vmalloc.h>
> @@ -32,7 +33,8 @@
>  enum {
>  	VHOST_VSOCK_FEATURES = VHOST_FEATURES |
>  			       (1ULL << VIRTIO_F_ACCESS_PLATFORM) |
> -			       (1ULL << VIRTIO_VSOCK_F_SEQPACKET)
> +			       (1ULL << VIRTIO_VSOCK_F_SEQPACKET) |
> +			       (1ULL << VIRTIO_VSOCK_F_DGRAM)
>  };
>  
>  enum {
> @@ -56,6 +58,7 @@ struct vhost_vsock {
>  	atomic_t queued_replies;
>  
>  	u32 guest_cid;
> +	bool dgram_allow;
>  	bool seqpacket_allow;
>  };
>  
> @@ -86,6 +89,32 @@ static struct vhost_vsock *vhost_vsock_get(u32 guest_cid)
>  	return NULL;
>  }
>  
> +/* Claims ownership of the skb, do not free the skb after calling! */
> +static void
> +vhost_transport_error(struct sk_buff *skb, int err)
> +{
> +	struct sock_exterr_skb *serr;
> +	struct sock *sk = skb->sk;
> +	struct sk_buff *clone;
> +
> +	serr = SKB_EXT_ERR(skb);
> +	memset(serr, 0, sizeof(*serr));
> +	serr->ee.ee_errno = err;
> +	serr->ee.ee_origin = SO_EE_ORIGIN_NONE;
> +
> +	clone = skb_clone(skb, GFP_KERNEL);

May for skb which is error carrier we can use 'sock_omalloc()', not 'skb_clone()' ? TCP uses skb
allocated by this function as carriers of error structure. I guess 'skb_clone()' also clones data of origin,
but i think that there is no need in data as we insert it to error queue of the socket.

What do You think?

> +	if (!clone)
> +		return;

What will happen here 'if (!clone)' ? skb will leak as it was removed from queue?

> +
> +	if (sock_queue_err_skb(sk, clone))
> +		kfree_skb(clone);
> +
> +	sk->sk_err = err;
> +	sk_error_report(sk);
> +
> +	kfree_skb(skb);
> +}
> +
>  static void
>  vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
>  			    struct vhost_virtqueue *vq)
> @@ -160,9 +189,15 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
>  		hdr = virtio_vsock_hdr(skb);
>  
>  		/* If the packet is greater than the space available in the
> -		 * buffer, we split it using multiple buffers.
> +		 * buffer, we split it using multiple buffers for connectible
> +		 * sockets and drop the packet for datagram sockets.
>  		 */
>  		if (payload_len > iov_len - sizeof(*hdr)) {
> +			if (le16_to_cpu(hdr->type) == VIRTIO_VSOCK_TYPE_DGRAM) {
> +				vhost_transport_error(skb, EHOSTUNREACH);
> +				continue;
> +			}
> +
>  			payload_len = iov_len - sizeof(*hdr);
>  
>  			/* As we are copying pieces of large packet's buffer to
> @@ -394,6 +429,7 @@ static bool vhost_vsock_more_replies(struct vhost_vsock *vsock)
>  	return val < vq->num;
>  }
>  
> +static bool vhost_transport_dgram_allow(u32 cid, u32 port);
>  static bool vhost_transport_seqpacket_allow(u32 remote_cid);
>  
>  static struct virtio_transport vhost_transport = {
> @@ -410,7 +446,8 @@ static struct virtio_transport vhost_transport = {
>  		.cancel_pkt               = vhost_transport_cancel_pkt,
>  
>  		.dgram_enqueue            = virtio_transport_dgram_enqueue,
> -		.dgram_allow              = virtio_transport_dgram_allow,
> +		.dgram_allow              = vhost_transport_dgram_allow,
> +		.dgram_addr_init          = virtio_transport_dgram_addr_init,
>  
>  		.stream_enqueue           = virtio_transport_stream_enqueue,
>  		.stream_dequeue           = virtio_transport_stream_dequeue,
> @@ -443,6 +480,22 @@ static struct virtio_transport vhost_transport = {
>  	.send_pkt = vhost_transport_send_pkt,
>  };
>  
> +static bool vhost_transport_dgram_allow(u32 cid, u32 port)
> +{
> +	struct vhost_vsock *vsock;
> +	bool dgram_allow = false;
> +
> +	rcu_read_lock();
> +	vsock = vhost_vsock_get(cid);
> +
> +	if (vsock)
> +		dgram_allow = vsock->dgram_allow;
> +
> +	rcu_read_unlock();
> +
> +	return dgram_allow;
> +}
> +
>  static bool vhost_transport_seqpacket_allow(u32 remote_cid)
>  {
>  	struct vhost_vsock *vsock;
> @@ -799,6 +852,9 @@ static int vhost_vsock_set_features(struct vhost_vsock *vsock, u64 features)
>  	if (features & (1ULL << VIRTIO_VSOCK_F_SEQPACKET))
>  		vsock->seqpacket_allow = true;
>  
> +	if (features & (1ULL << VIRTIO_VSOCK_F_DGRAM))
> +		vsock->dgram_allow = true;
> +
>  	for (i = 0; i < ARRAY_SIZE(vsock->vqs); i++) {
>  		vq = &vsock->vqs[i];
>  		mutex_lock(&vq->mutex);
> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> index e73f3b2c52f1..449ed63ac2b0 100644
> --- a/net/vmw_vsock/af_vsock.c
> +++ b/net/vmw_vsock/af_vsock.c
> @@ -1427,9 +1427,12 @@ int vsock_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
>  		return prot->recvmsg(sk, msg, len, flags, NULL);
>  #endif
>  
> -	if (flags & MSG_OOB || flags & MSG_ERRQUEUE)
> +	if (unlikely(flags & MSG_OOB))
>  		return -EOPNOTSUPP;
>  
> +	if (unlikely(flags & MSG_ERRQUEUE))
> +		return sock_recv_errqueue(sk, msg, len, SOL_VSOCK, 0);
> +

Sorry, but I get build error here, because SOL_VSOCK in undefined. I think it should be added to
include/linux/socket.h and to uapi files also for future use in userspace.

Also Stefano Garzarella <sgarzare@redhat.com> suggested to add define something like VSOCK_RECVERR,
in the same way as IP_RECVERR, and use it as last parameter of 'sock_recv_errqueue()'.

>  	transport = vsk->transport;
>  
>  	/* Retrieve the head sk_buff from the socket's receive queue. */
> 

Thanks, Arseniy
