Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9928D75DB1B
	for <lists+kvm@lfdr.de>; Sat, 22 Jul 2023 10:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbjGVIph (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Jul 2023 04:45:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjGVIpf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Jul 2023 04:45:35 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA46A10E;
        Sat, 22 Jul 2023 01:45:33 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id 2adb3069b0e04-4fb7373dd35so4761039e87.1;
        Sat, 22 Jul 2023 01:45:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690015532; x=1690620332;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qNPbeAHBl5rZYo6p/dBywIQoJn2BzsCFDGFgQ0D7bHI=;
        b=IkwyHI1frBJgDy0fzlqAxqFOcX36jKKZcb1PUGOH2UnEE1bZr/5U/A1NQU0wn4QqJq
         S72FwDq35OBDxeB+dc52XHtIjIzEW1upjbbiFJ9GjYN92SOmdbztRtGPB4c0X0lh7/Dl
         wUJXUV6ZCGN8VqAuWW2zMKTjb/3cFG47KOgZU+/wWwNfzSJXG2TVvjHCs0LDIjiZ610A
         3Qk9pyDbZdGSU6wJW7LAZoin/+PR//lKi/F0mO47nuvB/AQOwXhsojWDe4JQCDlNDoOj
         h6vuc719aDNUxS5m7+es4RC1xfKV4y2JUTDeYYlFe4E/IK7ttF35GkR9ti7NiShn/QLV
         2lOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690015532; x=1690620332;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qNPbeAHBl5rZYo6p/dBywIQoJn2BzsCFDGFgQ0D7bHI=;
        b=bs+VZ0LXSv2c5rwLqGwjIoKLySS3pv5j+Y7HYe+aR/6hKPNrlhJyvnj2DID7ld0D08
         j8R15WkWY9n8V3A/QUHeNHXaynQBjAsxz7NGO0FHADyjHXUW4Z+o4DMV5wFX6/wQ+iS6
         BHiQJrX08ICbn6WgdqKip1+qc/2gRPelPXs1LBwGONUjQX9XXUlnUJKbFCOibswIgTEb
         YFZNOy6bEXpYFv5YJtSDHVPgZ70TsWTKs4YRK0MK6dSHW7ioJGlN4rXnoz7+LJYavrty
         AB1wb7nOq/ihohy80+xiWqNVtlVSQwipzSnvRytk4CeJI0Oyo5JYDsjn7mZlEZxXmpLA
         YUqg==
X-Gm-Message-State: ABy/qLaj7HlgxnDYhQ1SoPPNCN8qH6PHWm6LsLbpeXIrK53p288w8UC4
        C8NdlqpowZQ1XCGBzblgK64=
X-Google-Smtp-Source: APBJJlE3M34DvNoQ9ZNn/7kDaH26taA0JGkVy11S2dAW2BH/ApAVBuMzxDnW0mirZpuZeTcTqRbRNQ==
X-Received: by 2002:a05:6512:3c8e:b0:4fb:fdf1:8b25 with SMTP id h14-20020a0565123c8e00b004fbfdf18b25mr2094939lfv.24.1690015531783;
        Sat, 22 Jul 2023 01:45:31 -0700 (PDT)
Received: from ?IPV6:2a00:1e88:c228:ec00:1b41:4959:c1a0:b9eb? ([2a00:1e88:c228:ec00:1b41:4959:c1a0:b9eb])
        by smtp.gmail.com with ESMTPSA id a11-20020a056512020b00b004f85d80ca64sm1097524lfo.221.2023.07.22.01.45.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Jul 2023 01:45:31 -0700 (PDT)
Message-ID: <adeed3a8-68fe-bdb7-e4a1-48044dbe5436@gmail.com>
Date:   Sat, 22 Jul 2023 11:45:29 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH RFC net-next v5 13/14] virtio/vsock: implement datagram
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
 <20230413-b4-vsock-dgram-v5-13-581bd37fdb26@bytedance.com>
From:   Arseniy Krasnov <oxffffaa@gmail.com>
In-Reply-To: <20230413-b4-vsock-dgram-v5-13-581bd37fdb26@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 19.07.2023 03:50, Bobby Eshleman wrote:
> This commit implements datagram support for virtio/vsock by teaching
> virtio to use the general virtio transport ->dgram_addr_init() function
> and implementation a new version of ->dgram_allow().
> 
> Additionally, it drops virtio_transport_dgram_allow() as an exported
> symbol because it is no longer used in other transports.
> 
> Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
> ---
>  include/linux/virtio_vsock.h            |  1 -
>  net/vmw_vsock/virtio_transport.c        | 24 +++++++++++++++++++++++-
>  net/vmw_vsock/virtio_transport_common.c |  6 ------
>  3 files changed, 23 insertions(+), 8 deletions(-)
> 
> diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
> index b3856b8a42b3..d0a4f08b12c1 100644
> --- a/include/linux/virtio_vsock.h
> +++ b/include/linux/virtio_vsock.h
> @@ -211,7 +211,6 @@ void virtio_transport_notify_buffer_size(struct vsock_sock *vsk, u64 *val);
>  u64 virtio_transport_stream_rcvhiwat(struct vsock_sock *vsk);
>  bool virtio_transport_stream_is_active(struct vsock_sock *vsk);
>  bool virtio_transport_stream_allow(u32 cid, u32 port);
> -bool virtio_transport_dgram_allow(u32 cid, u32 port);
>  void virtio_transport_dgram_addr_init(struct sk_buff *skb,
>  				      struct sockaddr_vm *addr);
>  
> diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
> index ac2126c7dac5..713718861bd4 100644
> --- a/net/vmw_vsock/virtio_transport.c
> +++ b/net/vmw_vsock/virtio_transport.c
> @@ -63,6 +63,7 @@ struct virtio_vsock {
>  
>  	u32 guest_cid;
>  	bool seqpacket_allow;
> +	bool dgram_allow;
>  };
>  
>  static u32 virtio_transport_get_local_cid(void)
> @@ -413,6 +414,7 @@ static void virtio_vsock_rx_done(struct virtqueue *vq)
>  	queue_work(virtio_vsock_workqueue, &vsock->rx_work);
>  }
>  
> +static bool virtio_transport_dgram_allow(u32 cid, u32 port);

May be add body here? Without prototyping? Same for loopback and vhost.

>  static bool virtio_transport_seqpacket_allow(u32 remote_cid);
>  
>  static struct virtio_transport virtio_transport = {
> @@ -430,6 +432,7 @@ static struct virtio_transport virtio_transport = {
>  
>  		.dgram_enqueue            = virtio_transport_dgram_enqueue,
>  		.dgram_allow              = virtio_transport_dgram_allow,
> +		.dgram_addr_init          = virtio_transport_dgram_addr_init,
>  
>  		.stream_dequeue           = virtio_transport_stream_dequeue,
>  		.stream_enqueue           = virtio_transport_stream_enqueue,
> @@ -462,6 +465,21 @@ static struct virtio_transport virtio_transport = {
>  	.send_pkt = virtio_transport_send_pkt,
>  };
>  
> +static bool virtio_transport_dgram_allow(u32 cid, u32 port)
> +{
> +	struct virtio_vsock *vsock;
> +	bool dgram_allow;
> +
> +	dgram_allow = false;
> +	rcu_read_lock();
> +	vsock = rcu_dereference(the_virtio_vsock);
> +	if (vsock)
> +		dgram_allow = vsock->dgram_allow;
> +	rcu_read_unlock();
> +
> +	return dgram_allow;
> +}
> +
>  static bool virtio_transport_seqpacket_allow(u32 remote_cid)
>  {
>  	struct virtio_vsock *vsock;
> @@ -655,6 +673,9 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
>  	if (virtio_has_feature(vdev, VIRTIO_VSOCK_F_SEQPACKET))
>  		vsock->seqpacket_allow = true;
>  
> +	if (virtio_has_feature(vdev, VIRTIO_VSOCK_F_DGRAM))
> +		vsock->dgram_allow = true;
> +
>  	vdev->priv = vsock;
>  
>  	ret = virtio_vsock_vqs_init(vsock);
> @@ -747,7 +768,8 @@ static struct virtio_device_id id_table[] = {
>  };
>  
>  static unsigned int features[] = {
> -	VIRTIO_VSOCK_F_SEQPACKET
> +	VIRTIO_VSOCK_F_SEQPACKET,
> +	VIRTIO_VSOCK_F_DGRAM
>  };
>  
>  static struct virtio_driver virtio_vsock_driver = {
> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> index 96118e258097..77898f5325cd 100644
> --- a/net/vmw_vsock/virtio_transport_common.c
> +++ b/net/vmw_vsock/virtio_transport_common.c
> @@ -783,12 +783,6 @@ bool virtio_transport_stream_allow(u32 cid, u32 port)
>  }
>  EXPORT_SYMBOL_GPL(virtio_transport_stream_allow);
>  
> -bool virtio_transport_dgram_allow(u32 cid, u32 port)
> -{
> -	return false;
> -}
> -EXPORT_SYMBOL_GPL(virtio_transport_dgram_allow);
> -
>  int virtio_transport_connect(struct vsock_sock *vsk)
>  {
>  	struct virtio_vsock_pkt_info info = {
> 

Thanks, Arseniy
