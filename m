Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3536E764BF8
	for <lists+kvm@lfdr.de>; Thu, 27 Jul 2023 10:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234207AbjG0IUd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jul 2023 04:20:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231154AbjG0IR0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jul 2023 04:17:26 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 480485FC6;
        Thu, 27 Jul 2023 01:10:11 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id 2adb3069b0e04-4fe0bb9500aso1142038e87.1;
        Thu, 27 Jul 2023 01:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690445363; x=1691050163;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xiUxgezQ5qkaa0qvpV7WRHRt1+Z+nieJXbLHqjI/O3A=;
        b=H2fID3UP9XooW3VhY5Axw7dEGEJFmttljx7Sfy9BQHD0WL0rZG5uAQrtzvH8I2Hj0A
         VsDsdkFkAVoBX9GBJEDxmtwCc6AeDOmrI74AWy5CiG52nL8tg/ze2+Op6jr98MfYcZwP
         YFifZerd/SGlEUR/W6PRWZE8jhkZkAm8Zk9XWUTpLVu9kvn9PAERmPAmicpDQcFseHbc
         AM09nJI8IJOh4WD701FsWK4t/HTnkbQD8nGwTKOoyFylOvJ8oI2+5GpGn/RqXDBG4w95
         nv+0fewb0OQYCZlIraM5WDcVpUIzSHhDh60pbmLi/8u0k4rPf1LRHbmHcewD1KlyOzoZ
         b8TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690445363; x=1691050163;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xiUxgezQ5qkaa0qvpV7WRHRt1+Z+nieJXbLHqjI/O3A=;
        b=InKE8Io7jIx/CHTo+WqjaHjC3GySw9X0mAnEzDc0c6CKLJXhbP3EK1ljHNh87gQSdm
         3LBzf9J0rBzqr1Lp7u4J2IgOd/8UlAdTUZlSgtnrEpMwVpoftfvSuDEunbmXa1KtSd/W
         hHtkAVWKA29qfMf8ARuPsbxDt6tsjzB4Ipun9h6juyZvmDcTuZK33sHdHIrrlIpDUT5a
         ytCo+ROEPCMQN4sYeV7zQJcf58igaNKQ1Xktgqja3IXUVX+e0WqR/yBLkwVdwiZT5/00
         X3iu9h9RAfyeNt9HYAuJ0SHa09hyesH2q9xgIgwijkutnIlKN9ZC3IO40OMcUNsxNaaL
         +MhQ==
X-Gm-Message-State: ABy/qLZ30B77z2uyZqVxmaQ2Mab9aDn6tzsuGZgKEyILB1C1ZMSUa71s
        +xPeCAd0A7k8ypWtPrgkFjI=
X-Google-Smtp-Source: APBJJlH865Tp8uBcV1iKrM/p9GDkWXd8sduKWaW615rgpOcY27CSHvxDYR2EfMZ71In5Apukj3zxQQ==
X-Received: by 2002:a05:6512:12c3:b0:4f9:5ca5:f1a6 with SMTP id p3-20020a05651212c300b004f95ca5f1a6mr1408395lfg.17.1690445363111;
        Thu, 27 Jul 2023 01:09:23 -0700 (PDT)
Received: from [192.168.0.112] ([77.220.140.242])
        by smtp.gmail.com with ESMTPSA id o1-20020ac24941000000b004faeedbb2a0sm194192lfi.78.2023.07.27.01.09.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Jul 2023 01:09:22 -0700 (PDT)
Message-ID: <f04d2aa5-32d8-cdc4-3b51-f15b0f42a1e8@gmail.com>
Date:   Thu, 27 Jul 2023 11:09:21 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH RFC net-next v5 13/14] virtio/vsock: implement datagram
 support
Content-Language: en-US
To:     Bobby Eshleman <bobbyeshleman@gmail.com>
Cc:     Bobby Eshleman <bobby.eshleman@bytedance.com>,
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
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        Dan Carpenter <dan.carpenter@linaro.org>,
        Simon Horman <simon.horman@corigine.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        bpf@vger.kernel.org
References: <20230413-b4-vsock-dgram-v5-0-581bd37fdb26@bytedance.com>
 <20230413-b4-vsock-dgram-v5-13-581bd37fdb26@bytedance.com>
 <adeed3a8-68fe-bdb7-e4a1-48044dbe5436@gmail.com> <ZMFetBpO0OdzXtnK@bullseye>
From:   Arseniy Krasnov <oxffffaa@gmail.com>
In-Reply-To: <ZMFetBpO0OdzXtnK@bullseye>
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



On 26.07.2023 20:58, Bobby Eshleman wrote:
> On Sat, Jul 22, 2023 at 11:45:29AM +0300, Arseniy Krasnov wrote:
>>
>>
>> On 19.07.2023 03:50, Bobby Eshleman wrote:
>>> This commit implements datagram support for virtio/vsock by teaching
>>> virtio to use the general virtio transport ->dgram_addr_init() function
>>> and implementation a new version of ->dgram_allow().
>>>
>>> Additionally, it drops virtio_transport_dgram_allow() as an exported
>>> symbol because it is no longer used in other transports.
>>>
>>> Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
>>> ---
>>>  include/linux/virtio_vsock.h            |  1 -
>>>  net/vmw_vsock/virtio_transport.c        | 24 +++++++++++++++++++++++-
>>>  net/vmw_vsock/virtio_transport_common.c |  6 ------
>>>  3 files changed, 23 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
>>> index b3856b8a42b3..d0a4f08b12c1 100644
>>> --- a/include/linux/virtio_vsock.h
>>> +++ b/include/linux/virtio_vsock.h
>>> @@ -211,7 +211,6 @@ void virtio_transport_notify_buffer_size(struct vsock_sock *vsk, u64 *val);
>>>  u64 virtio_transport_stream_rcvhiwat(struct vsock_sock *vsk);
>>>  bool virtio_transport_stream_is_active(struct vsock_sock *vsk);
>>>  bool virtio_transport_stream_allow(u32 cid, u32 port);
>>> -bool virtio_transport_dgram_allow(u32 cid, u32 port);
>>>  void virtio_transport_dgram_addr_init(struct sk_buff *skb,
>>>  				      struct sockaddr_vm *addr);
>>>  
>>> diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>>> index ac2126c7dac5..713718861bd4 100644
>>> --- a/net/vmw_vsock/virtio_transport.c
>>> +++ b/net/vmw_vsock/virtio_transport.c
>>> @@ -63,6 +63,7 @@ struct virtio_vsock {
>>>  
>>>  	u32 guest_cid;
>>>  	bool seqpacket_allow;
>>> +	bool dgram_allow;
>>>  };
>>>  
>>>  static u32 virtio_transport_get_local_cid(void)
>>> @@ -413,6 +414,7 @@ static void virtio_vsock_rx_done(struct virtqueue *vq)
>>>  	queue_work(virtio_vsock_workqueue, &vsock->rx_work);
>>>  }
>>>  
>>> +static bool virtio_transport_dgram_allow(u32 cid, u32 port);
>>
>> May be add body here? Without prototyping? Same for loopback and vhost.
>>
> 
> Sounds okay with me, but this seems to go against the pattern
> established by seqpacket. Any reason why?

Stefano Garzarella <sgarzare@redhat.com> commented my patch with the same approach:

https://lore.kernel.org/netdev/lex6l5suez7azhirt22lidndtjomkbagfbpvvi5p7c2t7klzas@4l2qly7at37c/

Thanks, Arseniy


> 
>>>  static bool virtio_transport_seqpacket_allow(u32 remote_cid);
>>>  
>>>  static struct virtio_transport virtio_transport = {
>>> @@ -430,6 +432,7 @@ static struct virtio_transport virtio_transport = {
>>>  
>>>  		.dgram_enqueue            = virtio_transport_dgram_enqueue,
>>>  		.dgram_allow              = virtio_transport_dgram_allow,
>>> +		.dgram_addr_init          = virtio_transport_dgram_addr_init,
>>>  
>>>  		.stream_dequeue           = virtio_transport_stream_dequeue,
>>>  		.stream_enqueue           = virtio_transport_stream_enqueue,
>>> @@ -462,6 +465,21 @@ static struct virtio_transport virtio_transport = {
>>>  	.send_pkt = virtio_transport_send_pkt,
>>>  };
>>>  
>>> +static bool virtio_transport_dgram_allow(u32 cid, u32 port)
>>> +{
>>> +	struct virtio_vsock *vsock;
>>> +	bool dgram_allow;
>>> +
>>> +	dgram_allow = false;
>>> +	rcu_read_lock();
>>> +	vsock = rcu_dereference(the_virtio_vsock);
>>> +	if (vsock)
>>> +		dgram_allow = vsock->dgram_allow;
>>> +	rcu_read_unlock();
>>> +
>>> +	return dgram_allow;
>>> +}
>>> +
>>>  static bool virtio_transport_seqpacket_allow(u32 remote_cid)
>>>  {
>>>  	struct virtio_vsock *vsock;
>>> @@ -655,6 +673,9 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
>>>  	if (virtio_has_feature(vdev, VIRTIO_VSOCK_F_SEQPACKET))
>>>  		vsock->seqpacket_allow = true;
>>>  
>>> +	if (virtio_has_feature(vdev, VIRTIO_VSOCK_F_DGRAM))
>>> +		vsock->dgram_allow = true;
>>> +
>>>  	vdev->priv = vsock;
>>>  
>>>  	ret = virtio_vsock_vqs_init(vsock);
>>> @@ -747,7 +768,8 @@ static struct virtio_device_id id_table[] = {
>>>  };
>>>  
>>>  static unsigned int features[] = {
>>> -	VIRTIO_VSOCK_F_SEQPACKET
>>> +	VIRTIO_VSOCK_F_SEQPACKET,
>>> +	VIRTIO_VSOCK_F_DGRAM
>>>  };
>>>  
>>>  static struct virtio_driver virtio_vsock_driver = {
>>> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>>> index 96118e258097..77898f5325cd 100644
>>> --- a/net/vmw_vsock/virtio_transport_common.c
>>> +++ b/net/vmw_vsock/virtio_transport_common.c
>>> @@ -783,12 +783,6 @@ bool virtio_transport_stream_allow(u32 cid, u32 port)
>>>  }
>>>  EXPORT_SYMBOL_GPL(virtio_transport_stream_allow);
>>>  
>>> -bool virtio_transport_dgram_allow(u32 cid, u32 port)
>>> -{
>>> -	return false;
>>> -}
>>> -EXPORT_SYMBOL_GPL(virtio_transport_dgram_allow);
>>> -
>>>  int virtio_transport_connect(struct vsock_sock *vsk)
>>>  {
>>>  	struct virtio_vsock_pkt_info info = {
>>>
>>
>> Thanks, Arseniy
> 
> Thanks,
> Bobby
