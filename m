Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA95177014B
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 15:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbjHDNTg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 09:19:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230387AbjHDNTR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 09:19:17 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F3AA65BA;
        Fri,  4 Aug 2023 06:16:41 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id ffacd0b85a97d-317715ec496so1870568f8f.3;
        Fri, 04 Aug 2023 06:16:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691154983; x=1691759783;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VJ2X2HBPBjlK5cmYSx4H9cuzLrGI58K9JZKpo4Xy3vI=;
        b=h6L4y7JZ2Lr9QabYGQ8CESpHeNpDiqEUiLL5s7ge76CRTWbzOMckQblguv18BkxkCD
         AmOJe4459BTGxnecqV1T0S83gGj4Jy38AJlOYVky5P7XFtU24LUKbuvjTTmqzi6sV4aT
         yJkMfoAh3tNdNlOQUz7xUizqsIewFotWODRaRD74ADM0mS+qO7bVeGj7zlOvT0AFpWbn
         tCt5PSyFyy3/CpZ3970K1ehtgSiFTIuKNAYeU2mjKHGhjWewHVYa07ZqmOrBNYckaHkR
         8ycTxapxAyPEvm1XHWCnJa0iwcuaUkivy85pqt0sKeRvk//FvL/FCEEy8CuZHKV75R1r
         4lnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691154983; x=1691759783;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VJ2X2HBPBjlK5cmYSx4H9cuzLrGI58K9JZKpo4Xy3vI=;
        b=WfFxKZv2gDxRYWt+Nr+g5eSLJxMugkAsa0OAsjBn6qwUR7RPNecX5OODCSytvN9v40
         ydXdgSi3XabuSvVdfOFXmJWs/JqPce36jAzTek9no1fIJyFR+whR/acYkz7IeIqti7HI
         yJgyrzYeHu27SQ9gbyD0h4VII3ynvfrIcOISuvAQDePb4TRKQgAYWFjydmCZypeaKnNp
         8Y4sKkVuSODMCxe0RWjOMSXLXhR3Wu0N8sw4SoI0vCpYaIARz+/S0hj87ChI/crJm1VZ
         I80ghjrwYmpZ61DP2VwFnWXX0o2vL/3ogVYvwKNdI9s2c279LFqYoqY2XyolzzatNq3a
         HC4w==
X-Gm-Message-State: AOJu0YyU/5uHKKkrSf1iVAuo2uIXHHHhdwUhUmBUYnCsB8ZM0fZfB+C5
        PVNBxpiEs4ZLbkiYuWdbvb8=
X-Google-Smtp-Source: AGHT+IEn4dpnZkXnJ6fq/PioittfuWfTWExTDir3eQh8yZv6b5rw+HsT0toSSif9qDdhLmtBkdtNVQ==
X-Received: by 2002:a5d:65cc:0:b0:317:727f:3bc7 with SMTP id e12-20020a5d65cc000000b00317727f3bc7mr1346868wrw.17.1691154983415;
        Fri, 04 Aug 2023 06:16:23 -0700 (PDT)
Received: from [10.9.105.115] ([41.86.56.122])
        by smtp.gmail.com with ESMTPSA id p8-20020adff208000000b003176a4394d7sm2526686wro.24.2023.08.04.06.16.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Aug 2023 06:16:23 -0700 (PDT)
Message-ID: <799f5757-4af0-7336-ac27-beaa62eda635@gmail.com>
Date:   Fri, 4 Aug 2023 16:16:11 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH RFC net-next v5 11/14] vhost/vsock: implement datagram
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
 <20230413-b4-vsock-dgram-v5-11-581bd37fdb26@bytedance.com>
 <b15d237e-31b5-40ae-83fc-e71649febd2b@gmail.com> <ZMFd+Jd/LrfpJsVA@bullseye>
 <acd54194-d397-e721-28e4-73a69257a2a9@gmail.com> <ZMrJX/mBF1HbbOkO@bullseye>
From:   Arseniy Krasnov <oxffffaa@gmail.com>
In-Reply-To: <ZMrJX/mBF1HbbOkO@bullseye>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 03.08.2023 00:23, Bobby Eshleman wrote:
> On Thu, Jul 27, 2023 at 11:00:55AM +0300, Arseniy Krasnov wrote:
>>
>>
>> On 26.07.2023 20:55, Bobby Eshleman wrote:
>>> On Sat, Jul 22, 2023 at 11:42:38AM +0300, Arseniy Krasnov wrote:
>>>>
>>>>
>>>> On 19.07.2023 03:50, Bobby Eshleman wrote:
>>>>> This commit implements datagram support for vhost/vsock by teaching
>>>>> vhost to use the common virtio transport datagram functions.
>>>>>
>>>>> If the virtio RX buffer is too small, then the transmission is
>>>>> abandoned, the packet dropped, and EHOSTUNREACH is added to the socket's
>>>>> error queue.
>>>>>
>>>>> Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
>>>>> ---
>>>>>  drivers/vhost/vsock.c    | 62 +++++++++++++++++++++++++++++++++++++++++++++---
>>>>>  net/vmw_vsock/af_vsock.c |  5 +++-
>>>>>  2 files changed, 63 insertions(+), 4 deletions(-)
>>>>>
>>>>> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>>>>> index d5d6a3c3f273..da14260c6654 100644
>>>>> --- a/drivers/vhost/vsock.c
>>>>> +++ b/drivers/vhost/vsock.c
>>>>> @@ -8,6 +8,7 @@
>>>>>   */
>>>>>  #include <linux/miscdevice.h>
>>>>>  #include <linux/atomic.h>
>>>>> +#include <linux/errqueue.h>
>>>>>  #include <linux/module.h>
>>>>>  #include <linux/mutex.h>
>>>>>  #include <linux/vmalloc.h>
>>>>> @@ -32,7 +33,8 @@
>>>>>  enum {
>>>>>  	VHOST_VSOCK_FEATURES = VHOST_FEATURES |
>>>>>  			       (1ULL << VIRTIO_F_ACCESS_PLATFORM) |
>>>>> -			       (1ULL << VIRTIO_VSOCK_F_SEQPACKET)
>>>>> +			       (1ULL << VIRTIO_VSOCK_F_SEQPACKET) |
>>>>> +			       (1ULL << VIRTIO_VSOCK_F_DGRAM)
>>>>>  };
>>>>>  
>>>>>  enum {
>>>>> @@ -56,6 +58,7 @@ struct vhost_vsock {
>>>>>  	atomic_t queued_replies;
>>>>>  
>>>>>  	u32 guest_cid;
>>>>> +	bool dgram_allow;
>>>>>  	bool seqpacket_allow;
>>>>>  };
>>>>>  
>>>>> @@ -86,6 +89,32 @@ static struct vhost_vsock *vhost_vsock_get(u32 guest_cid)
>>>>>  	return NULL;
>>>>>  }
>>>>>  
>>>>> +/* Claims ownership of the skb, do not free the skb after calling! */
>>>>> +static void
>>>>> +vhost_transport_error(struct sk_buff *skb, int err)
>>>>> +{
>>>>> +	struct sock_exterr_skb *serr;
>>>>> +	struct sock *sk = skb->sk;
>>>>> +	struct sk_buff *clone;
>>>>> +
>>>>> +	serr = SKB_EXT_ERR(skb);
>>>>> +	memset(serr, 0, sizeof(*serr));
>>>>> +	serr->ee.ee_errno = err;
>>>>> +	serr->ee.ee_origin = SO_EE_ORIGIN_NONE;
>>>>> +
>>>>> +	clone = skb_clone(skb, GFP_KERNEL);
>>>>
>>>> May for skb which is error carrier we can use 'sock_omalloc()', not 'skb_clone()' ? TCP uses skb
>>>> allocated by this function as carriers of error structure. I guess 'skb_clone()' also clones data of origin,
>>>> but i think that there is no need in data as we insert it to error queue of the socket.
>>>>
>>>> What do You think?
>>>
>>> IIUC skb_clone() is often used in this scenario so that the user can
>>> retrieve the error-causing packet from the error queue.  Is there some
>>> reason we shouldn't do this?
>>>
>>> I'm seeing that the serr bits need to occur on the clone here, not the
>>> original. I didn't realize the SKB_EXT_ERR() is a skb->cb cast. I'm not
>>> actually sure how this passes the test case since ->cb isn't cloned.
>>
>> Ah yes, sorry, You are right, I just confused this case with zerocopy completion
>> handling - there we allocate "empty" skb which carries completion metadata in its
>> 'cb' field.
>>
>> Hm, but can't we just reinsert current skb (update it's 'cb' as 'sock_exterr_skb')
>> to error queue of the socket without cloning it ?
>>
>> Thanks, Arseniy
>>
> 
> I just assumed other socket types used skb_clone() for some reason
> unknown to me and I didn't want to deviate.
> 
> If it is fine to just use the skb directly, then I am happy to make that
> change.

Agree, it is better to use behaviour from already implemented sockets.
I also found, that ICMP clones skb in this way:

https://elixir.bootlin.com/linux/latest/source/net/ipv4/ip_sockglue.c#L412
skb = skb_clone(skb, GFP_ATOMIC);

I guess there is some sense beyond 'skb = skb_clone(skb)'...

Thanks, Arseniy

> 
> Best,
> Bobby
> 
>>>
>>>>
>>>>> +	if (!clone)
>>>>> +		return;
>>>>
>>>> What will happen here 'if (!clone)' ? skb will leak as it was removed from queue?
>>>>
>>>
>>> Ah yes, true.
>>>
>>>>> +
>>>>> +	if (sock_queue_err_skb(sk, clone))
>>>>> +		kfree_skb(clone);
>>>>> +
>>>>> +	sk->sk_err = err;
>>>>> +	sk_error_report(sk);
>>>>> +
>>>>> +	kfree_skb(skb);
>>>>> +}
>>>>> +
>>>>>  static void
>>>>>  vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
>>>>>  			    struct vhost_virtqueue *vq)
>>>>> @@ -160,9 +189,15 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
>>>>>  		hdr = virtio_vsock_hdr(skb);
>>>>>  
>>>>>  		/* If the packet is greater than the space available in the
>>>>> -		 * buffer, we split it using multiple buffers.
>>>>> +		 * buffer, we split it using multiple buffers for connectible
>>>>> +		 * sockets and drop the packet for datagram sockets.
>>>>>  		 */
>>>>>  		if (payload_len > iov_len - sizeof(*hdr)) {
>>>>> +			if (le16_to_cpu(hdr->type) == VIRTIO_VSOCK_TYPE_DGRAM) {
>>>>> +				vhost_transport_error(skb, EHOSTUNREACH);
>>>>> +				continue;
>>>>> +			}
>>>>> +
>>>>>  			payload_len = iov_len - sizeof(*hdr);
>>>>>  
>>>>>  			/* As we are copying pieces of large packet's buffer to
>>>>> @@ -394,6 +429,7 @@ static bool vhost_vsock_more_replies(struct vhost_vsock *vsock)
>>>>>  	return val < vq->num;
>>>>>  }
>>>>>  
>>>>> +static bool vhost_transport_dgram_allow(u32 cid, u32 port);
>>>>>  static bool vhost_transport_seqpacket_allow(u32 remote_cid);
>>>>>  
>>>>>  static struct virtio_transport vhost_transport = {
>>>>> @@ -410,7 +446,8 @@ static struct virtio_transport vhost_transport = {
>>>>>  		.cancel_pkt               = vhost_transport_cancel_pkt,
>>>>>  
>>>>>  		.dgram_enqueue            = virtio_transport_dgram_enqueue,
>>>>> -		.dgram_allow              = virtio_transport_dgram_allow,
>>>>> +		.dgram_allow              = vhost_transport_dgram_allow,
>>>>> +		.dgram_addr_init          = virtio_transport_dgram_addr_init,
>>>>>  
>>>>>  		.stream_enqueue           = virtio_transport_stream_enqueue,
>>>>>  		.stream_dequeue           = virtio_transport_stream_dequeue,
>>>>> @@ -443,6 +480,22 @@ static struct virtio_transport vhost_transport = {
>>>>>  	.send_pkt = vhost_transport_send_pkt,
>>>>>  };
>>>>>  
>>>>> +static bool vhost_transport_dgram_allow(u32 cid, u32 port)
>>>>> +{
>>>>> +	struct vhost_vsock *vsock;
>>>>> +	bool dgram_allow = false;
>>>>> +
>>>>> +	rcu_read_lock();
>>>>> +	vsock = vhost_vsock_get(cid);
>>>>> +
>>>>> +	if (vsock)
>>>>> +		dgram_allow = vsock->dgram_allow;
>>>>> +
>>>>> +	rcu_read_unlock();
>>>>> +
>>>>> +	return dgram_allow;
>>>>> +}
>>>>> +
>>>>>  static bool vhost_transport_seqpacket_allow(u32 remote_cid)
>>>>>  {
>>>>>  	struct vhost_vsock *vsock;
>>>>> @@ -799,6 +852,9 @@ static int vhost_vsock_set_features(struct vhost_vsock *vsock, u64 features)
>>>>>  	if (features & (1ULL << VIRTIO_VSOCK_F_SEQPACKET))
>>>>>  		vsock->seqpacket_allow = true;
>>>>>  
>>>>> +	if (features & (1ULL << VIRTIO_VSOCK_F_DGRAM))
>>>>> +		vsock->dgram_allow = true;
>>>>> +
>>>>>  	for (i = 0; i < ARRAY_SIZE(vsock->vqs); i++) {
>>>>>  		vq = &vsock->vqs[i];
>>>>>  		mutex_lock(&vq->mutex);
>>>>> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>>>>> index e73f3b2c52f1..449ed63ac2b0 100644
>>>>> --- a/net/vmw_vsock/af_vsock.c
>>>>> +++ b/net/vmw_vsock/af_vsock.c
>>>>> @@ -1427,9 +1427,12 @@ int vsock_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
>>>>>  		return prot->recvmsg(sk, msg, len, flags, NULL);
>>>>>  #endif
>>>>>  
>>>>> -	if (flags & MSG_OOB || flags & MSG_ERRQUEUE)
>>>>> +	if (unlikely(flags & MSG_OOB))
>>>>>  		return -EOPNOTSUPP;
>>>>>  
>>>>> +	if (unlikely(flags & MSG_ERRQUEUE))
>>>>> +		return sock_recv_errqueue(sk, msg, len, SOL_VSOCK, 0);
>>>>> +
>>>>
>>>> Sorry, but I get build error here, because SOL_VSOCK in undefined. I think it should be added to
>>>> include/linux/socket.h and to uapi files also for future use in userspace.
>>>>
>>>
>>> Strange, I built each patch individually without issue. My base is
>>> netdev/main with your SOL_VSOCK patch applied. I will look today and see
>>> if I'm missing something.
>>>
>>>> Also Stefano Garzarella <sgarzare@redhat.com> suggested to add define something like VSOCK_RECVERR,
>>>> in the same way as IP_RECVERR, and use it as last parameter of 'sock_recv_errqueue()'.
>>>>
>>>
>>> Got it, thanks.
>>>
>>>>>  	transport = vsk->transport;
>>>>>  
>>>>>  	/* Retrieve the head sk_buff from the socket's receive queue. */
>>>>>
>>>>
>>>> Thanks, Arseniy
>>>
>>> Thanks,
>>> Bobby
