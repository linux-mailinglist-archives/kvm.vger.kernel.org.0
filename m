Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABEA7764A47
	for <lists+kvm@lfdr.de>; Thu, 27 Jul 2023 10:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232328AbjG0IId (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jul 2023 04:08:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233961AbjG0IIN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jul 2023 04:08:13 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5DE844B5;
        Thu, 27 Jul 2023 01:04:22 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id 2adb3069b0e04-4fe0c566788so1197704e87.0;
        Thu, 27 Jul 2023 01:04:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690445054; x=1691049854;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cGFm1yCSFddb2U6pFJa1ekT2q99QXapQbICr7xQFL6Q=;
        b=NaN/cBwLyXcOxi/0/n/O3CQXbGg4eFDpcsKE90ntjRuaWvKgVhHlqXtdLPkouPCijv
         4smfSR9Qmx7XcrA6DLjeWyDtztD9vxQDcK7cU8kxKucscZUzJmS59wHATdOtTcyeDNW2
         +PuxTscYHTrXmNcChtg7clL40ejdKhoaxJJIPYEpZwk1hJvUq0SXuqbILOYmkUK0UtDQ
         N2ARD9gZ0EysaWmmwSfhLGmLHKg+3n2YVKEqZmSNsHo8q84htg+zKA6Ew4GwNSFwY4DP
         wzvgJPno9AWSrlJbMza4oVM5s69Ecp9A/AST8dyq07UMD8tT+b0C0zo0kSIS+jjid6zP
         7vww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690445054; x=1691049854;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cGFm1yCSFddb2U6pFJa1ekT2q99QXapQbICr7xQFL6Q=;
        b=d+Nuogrq8gsdSpevgbn+RtvT7CtPLybyWuruOtruiD5BnUJeDwOdPjAifNeJK4mZ/n
         QH0VGvhwKoMgKtXCKcseFMqDWKUkFj4yrr5XRgNA68x4V9+im+kTTFROftz+LVODQEzS
         sYV49KnwJz8Z9Q7zV8Y9J8H3B9UgxfwGANCqur9LUu2hLBc2iYK7zu0tsc5DijUv7HZa
         B4wDtSttpll6eLB8L2XRN4X+S4KthnapzbiIhkzFLqP3BQRCbGFUIdx1aRXrEQsPvkOC
         a42x/lMBip1jFfs6pmDqGKh1+hlzy0GS824wJ6ouVYlFOpcTZTH8qyC5ZGrqmMW9/oMi
         eAAw==
X-Gm-Message-State: ABy/qLZ68ipC6aeFASJ51LVWKSMi3oBaHtoz2vAfGQanPNO7Gs4HXBKR
        ZxK7bmmUEYiigqG3XLr8TRU6urx9nw4jGA==
X-Google-Smtp-Source: APBJJlF7MqWM+A8HbDTNrG5idX2O2DITz9XFWgYIRgRC9SHcB8tcCD4qkf8cHNUzO7ZLz6SVbgsmgw==
X-Received: by 2002:a05:6512:3b99:b0:4fd:d016:c2e8 with SMTP id g25-20020a0565123b9900b004fdd016c2e8mr1276836lfv.43.1690445054321;
        Thu, 27 Jul 2023 01:04:14 -0700 (PDT)
Received: from [192.168.0.112] ([77.220.140.242])
        by smtp.gmail.com with ESMTPSA id h26-20020a19701a000000b004fa52552c82sm191076lfc.155.2023.07.27.01.04.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Jul 2023 01:04:13 -0700 (PDT)
Message-ID: <9bc7db9c-1848-ee6c-58c2-d3ef8f153db5@gmail.com>
Date:   Thu, 27 Jul 2023 11:04:12 +0300
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
From:   Arseniy Krasnov <oxffffaa@gmail.com>
In-Reply-To: <ZMFd+Jd/LrfpJsVA@bullseye>
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



On 26.07.2023 20:55, Bobby Eshleman wrote:
> On Sat, Jul 22, 2023 at 11:42:38AM +0300, Arseniy Krasnov wrote:
>>
>>
>> On 19.07.2023 03:50, Bobby Eshleman wrote:
>>> This commit implements datagram support for vhost/vsock by teaching
>>> vhost to use the common virtio transport datagram functions.
>>>
>>> If the virtio RX buffer is too small, then the transmission is
>>> abandoned, the packet dropped, and EHOSTUNREACH is added to the socket's
>>> error queue.
>>>
>>> Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
>>> ---
>>>  drivers/vhost/vsock.c    | 62 +++++++++++++++++++++++++++++++++++++++++++++---
>>>  net/vmw_vsock/af_vsock.c |  5 +++-
>>>  2 files changed, 63 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>>> index d5d6a3c3f273..da14260c6654 100644
>>> --- a/drivers/vhost/vsock.c
>>> +++ b/drivers/vhost/vsock.c
>>> @@ -8,6 +8,7 @@
>>>   */
>>>  #include <linux/miscdevice.h>
>>>  #include <linux/atomic.h>
>>> +#include <linux/errqueue.h>
>>>  #include <linux/module.h>
>>>  #include <linux/mutex.h>
>>>  #include <linux/vmalloc.h>
>>> @@ -32,7 +33,8 @@
>>>  enum {
>>>  	VHOST_VSOCK_FEATURES = VHOST_FEATURES |
>>>  			       (1ULL << VIRTIO_F_ACCESS_PLATFORM) |
>>> -			       (1ULL << VIRTIO_VSOCK_F_SEQPACKET)
>>> +			       (1ULL << VIRTIO_VSOCK_F_SEQPACKET) |
>>> +			       (1ULL << VIRTIO_VSOCK_F_DGRAM)
>>>  };
>>>  
>>>  enum {
>>> @@ -56,6 +58,7 @@ struct vhost_vsock {
>>>  	atomic_t queued_replies;
>>>  
>>>  	u32 guest_cid;
>>> +	bool dgram_allow;
>>>  	bool seqpacket_allow;
>>>  };
>>>  
>>> @@ -86,6 +89,32 @@ static struct vhost_vsock *vhost_vsock_get(u32 guest_cid)
>>>  	return NULL;
>>>  }
>>>  
>>> +/* Claims ownership of the skb, do not free the skb after calling! */
>>> +static void
>>> +vhost_transport_error(struct sk_buff *skb, int err)
>>> +{
>>> +	struct sock_exterr_skb *serr;
>>> +	struct sock *sk = skb->sk;
>>> +	struct sk_buff *clone;
>>> +
>>> +	serr = SKB_EXT_ERR(skb);
>>> +	memset(serr, 0, sizeof(*serr));
>>> +	serr->ee.ee_errno = err;
>>> +	serr->ee.ee_origin = SO_EE_ORIGIN_NONE;
>>> +
>>> +	clone = skb_clone(skb, GFP_KERNEL);
>>
>> May for skb which is error carrier we can use 'sock_omalloc()', not 'skb_clone()' ? TCP uses skb
>> allocated by this function as carriers of error structure. I guess 'skb_clone()' also clones data of origin,
>> but i think that there is no need in data as we insert it to error queue of the socket.
>>
>> What do You think?
> 
> IIUC skb_clone() is often used in this scenario so that the user can
> retrieve the error-causing packet from the error queue.  Is there some
> reason we shouldn't do this?
> 
> I'm seeing that the serr bits need to occur on the clone here, not the
> original. I didn't realize the SKB_EXT_ERR() is a skb->cb cast. I'm not
> actually sure how this passes the test case since ->cb isn't cloned.
> 
>>
>>> +	if (!clone)
>>> +		return;
>>
>> What will happen here 'if (!clone)' ? skb will leak as it was removed from queue?
>>
> 
> Ah yes, true.
> 
>>> +
>>> +	if (sock_queue_err_skb(sk, clone))
>>> +		kfree_skb(clone);
>>> +
>>> +	sk->sk_err = err;
>>> +	sk_error_report(sk);
>>> +
>>> +	kfree_skb(skb);
>>> +}
>>> +
>>>  static void
>>>  vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
>>>  			    struct vhost_virtqueue *vq)
>>> @@ -160,9 +189,15 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
>>>  		hdr = virtio_vsock_hdr(skb);
>>>  
>>>  		/* If the packet is greater than the space available in the
>>> -		 * buffer, we split it using multiple buffers.
>>> +		 * buffer, we split it using multiple buffers for connectible
>>> +		 * sockets and drop the packet for datagram sockets.
>>>  		 */
>>>  		if (payload_len > iov_len - sizeof(*hdr)) {
>>> +			if (le16_to_cpu(hdr->type) == VIRTIO_VSOCK_TYPE_DGRAM) {
>>> +				vhost_transport_error(skb, EHOSTUNREACH);
>>> +				continue;
>>> +			}
>>> +
>>>  			payload_len = iov_len - sizeof(*hdr);
>>>  
>>>  			/* As we are copying pieces of large packet's buffer to
>>> @@ -394,6 +429,7 @@ static bool vhost_vsock_more_replies(struct vhost_vsock *vsock)
>>>  	return val < vq->num;
>>>  }
>>>  
>>> +static bool vhost_transport_dgram_allow(u32 cid, u32 port);
>>>  static bool vhost_transport_seqpacket_allow(u32 remote_cid);
>>>  
>>>  static struct virtio_transport vhost_transport = {
>>> @@ -410,7 +446,8 @@ static struct virtio_transport vhost_transport = {
>>>  		.cancel_pkt               = vhost_transport_cancel_pkt,
>>>  
>>>  		.dgram_enqueue            = virtio_transport_dgram_enqueue,
>>> -		.dgram_allow              = virtio_transport_dgram_allow,
>>> +		.dgram_allow              = vhost_transport_dgram_allow,
>>> +		.dgram_addr_init          = virtio_transport_dgram_addr_init,
>>>  
>>>  		.stream_enqueue           = virtio_transport_stream_enqueue,
>>>  		.stream_dequeue           = virtio_transport_stream_dequeue,
>>> @@ -443,6 +480,22 @@ static struct virtio_transport vhost_transport = {
>>>  	.send_pkt = vhost_transport_send_pkt,
>>>  };
>>>  
>>> +static bool vhost_transport_dgram_allow(u32 cid, u32 port)
>>> +{
>>> +	struct vhost_vsock *vsock;
>>> +	bool dgram_allow = false;
>>> +
>>> +	rcu_read_lock();
>>> +	vsock = vhost_vsock_get(cid);
>>> +
>>> +	if (vsock)
>>> +		dgram_allow = vsock->dgram_allow;
>>> +
>>> +	rcu_read_unlock();
>>> +
>>> +	return dgram_allow;
>>> +}
>>> +
>>>  static bool vhost_transport_seqpacket_allow(u32 remote_cid)
>>>  {
>>>  	struct vhost_vsock *vsock;
>>> @@ -799,6 +852,9 @@ static int vhost_vsock_set_features(struct vhost_vsock *vsock, u64 features)
>>>  	if (features & (1ULL << VIRTIO_VSOCK_F_SEQPACKET))
>>>  		vsock->seqpacket_allow = true;
>>>  
>>> +	if (features & (1ULL << VIRTIO_VSOCK_F_DGRAM))
>>> +		vsock->dgram_allow = true;
>>> +
>>>  	for (i = 0; i < ARRAY_SIZE(vsock->vqs); i++) {
>>>  		vq = &vsock->vqs[i];
>>>  		mutex_lock(&vq->mutex);
>>> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>>> index e73f3b2c52f1..449ed63ac2b0 100644
>>> --- a/net/vmw_vsock/af_vsock.c
>>> +++ b/net/vmw_vsock/af_vsock.c
>>> @@ -1427,9 +1427,12 @@ int vsock_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
>>>  		return prot->recvmsg(sk, msg, len, flags, NULL);
>>>  #endif
>>>  
>>> -	if (flags & MSG_OOB || flags & MSG_ERRQUEUE)
>>> +	if (unlikely(flags & MSG_OOB))
>>>  		return -EOPNOTSUPP;
>>>  
>>> +	if (unlikely(flags & MSG_ERRQUEUE))
>>> +		return sock_recv_errqueue(sk, msg, len, SOL_VSOCK, 0);
>>> +
>>
>> Sorry, but I get build error here, because SOL_VSOCK in undefined. I think it should be added to
>> include/linux/socket.h and to uapi files also for future use in userspace.
>>
> 
> Strange, I built each patch individually without issue. My base is
> netdev/main with your SOL_VSOCK patch applied. I will look today and see
> if I'm missing something.

I see, this is difference, because i'm trying to run this patchset on the last net-next (as it is
supposed to be merged to net-next). I guess You should add this define anyway when You be ready to
be merged to net-next (I really don't know which SOL_VSOCK will be merged first - "Your" or "my" :) )

Thanks, Arseniy

> 
>> Also Stefano Garzarella <sgarzare@redhat.com> suggested to add define something like VSOCK_RECVERR,
>> in the same way as IP_RECVERR, and use it as last parameter of 'sock_recv_errqueue()'.
>>
> 
> Got it, thanks.
> 
>>>  	transport = vsk->transport;
>>>  
>>>  	/* Retrieve the head sk_buff from the socket's receive queue. */
>>>
>>
>> Thanks, Arseniy
> 
> Thanks,
> Bobby
