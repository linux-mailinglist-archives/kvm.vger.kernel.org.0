Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9E3764980
	for <lists+kvm@lfdr.de>; Thu, 27 Jul 2023 09:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233594AbjG0H4d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jul 2023 03:56:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233129AbjG0H4J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jul 2023 03:56:09 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90DEC359C;
        Thu, 27 Jul 2023 00:53:18 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id 2adb3069b0e04-4f954d7309fso784335e87.1;
        Thu, 27 Jul 2023 00:53:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690444397; x=1691049197;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PZy9WK27qcKRkfE4r4NzAnnUDv8fmzE8MslrqWOIPZo=;
        b=h//3iYtwVI/lcHfINWHg0miTQsBobT0251MlcYrffGM9xj7nxuujx8WyZj/ih77iQu
         dtQSaZ81ZU7XwFzv9skD49763T0DfEvN7Wm813weKYOAX/qnJhccZUMXmGJ4VYtOvrbs
         A+acA+jlPLbIGzNLLww7DZYSLIfkT8PY+iF4J6n+i+3ZyoqabYbOZzfSxpQWGYTQgQ5G
         X4v8ux6Nu4mIJfI2QcKYlCFJKwOuQodQxH/SgNZDDAeCg/KI+tsM/DCrVogFtW8lGiQw
         CHuEKki7ck/DN3k+cf3t1WYqkaWAxG6QdqsJiRw55oKG2johNYQJEGLcC7yrrA7HiIW0
         Fnsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690444397; x=1691049197;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PZy9WK27qcKRkfE4r4NzAnnUDv8fmzE8MslrqWOIPZo=;
        b=MLqrH19L8+c54ZLFtkq05RYtlBFfSs+mepFqlEE0U0GLIWSijLR9EPRIerKr0W13tg
         DZMj/eDwPyRFKXHJTa6445DHlbcs8ij9hyWoNiuOnuh1wgZc/NhnUN11tavNtFoe3z3I
         IQ9/hDRLXPEIIpMS4sMvDo8mfqGgLbuU2QMmRD6dbTvsVbPee2qNUSH5DfhaG7GuKFwY
         v5+5DyF0vFPNsiQwM6sYJ3ZFkLy37K272J+iYRc5xufY6/v27fNVuaIxyD5YHOd6EHUQ
         YhE9RZYHJjQVVSGXTQeK8O7KYvAh4MIQ4Kzb4GSj5oG8z2+q1ciQu64NnmqkV8bLya5C
         8J5Q==
X-Gm-Message-State: ABy/qLa2atWex472/2yChNxc2tV4LsLXzLxzgOhjD5K0Zs/gGeXFZuYV
        Yc8XuNVI6mwsXdute+wDqRw=
X-Google-Smtp-Source: APBJJlFuCXetQMc65qnz0mWXxqHNQrVlKRUTUKML/oP/nh6hzCCRe0W+VtRR907vnfydMk2k4QElDg==
X-Received: by 2002:a05:6512:6d6:b0:4fd:d1b9:f835 with SMTP id u22-20020a05651206d600b004fdd1b9f835mr656312lff.1.1690444396437;
        Thu, 27 Jul 2023 00:53:16 -0700 (PDT)
Received: from [192.168.0.112] ([77.220.140.242])
        by smtp.gmail.com with ESMTPSA id l21-20020a19c215000000b004fba5c20ab1sm189150lfc.167.2023.07.27.00.53.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Jul 2023 00:53:16 -0700 (PDT)
Message-ID: <f0bca831-207c-6cbb-48e9-7d2ea02229ff@gmail.com>
Date:   Thu, 27 Jul 2023 10:53:14 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH RFC net-next v5 01/14] af_vsock: generalize
 vsock_dgram_recvmsg() to all transports
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
 <20230413-b4-vsock-dgram-v5-1-581bd37fdb26@bytedance.com>
 <27a430f8-18e9-7cc2-c773-dde8ae824bfc@gmail.com> <ZMFkFE0AqaOUfric@bullseye>
From:   Arseniy Krasnov <oxffffaa@gmail.com>
In-Reply-To: <ZMFkFE0AqaOUfric@bullseye>
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



On 26.07.2023 21:21, Bobby Eshleman wrote:
> On Mon, Jul 24, 2023 at 09:11:44PM +0300, Arseniy Krasnov wrote:
>>
>>
>> On 19.07.2023 03:50, Bobby Eshleman wrote:
>>> This commit drops the transport->dgram_dequeue callback and makes
>>> vsock_dgram_recvmsg() generic to all transports.
>>>
>>> To make this possible, two transport-level changes are introduced:
>>> - implementation of the ->dgram_addr_init() callback to initialize
>>>   the sockaddr_vm structure with data from incoming socket buffers.
>>> - transport implementations set the skb->data pointer to the beginning
>>>   of the payload prior to adding the skb to the socket's receive queue.
>>>   That is, they must use skb_pull() before enqueuing. This is an
>>>   agreement between the transport and the socket layer that skb->data
>>>   always points to the beginning of the payload (and not, for example,
>>>   the packet header).
>>>
>>> Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
>>> ---
>>>  drivers/vhost/vsock.c                   |  1 -
>>>  include/linux/virtio_vsock.h            |  5 ---
>>>  include/net/af_vsock.h                  |  3 +-
>>>  net/vmw_vsock/af_vsock.c                | 40 ++++++++++++++++++++++-
>>>  net/vmw_vsock/hyperv_transport.c        |  7 ----
>>>  net/vmw_vsock/virtio_transport.c        |  1 -
>>>  net/vmw_vsock/virtio_transport_common.c |  9 -----
>>>  net/vmw_vsock/vmci_transport.c          | 58 ++++++---------------------------
>>>  net/vmw_vsock/vsock_loopback.c          |  1 -
>>>  9 files changed, 50 insertions(+), 75 deletions(-)
>>>
>>> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>>> index 6578db78f0ae..ae8891598a48 100644
>>> --- a/drivers/vhost/vsock.c
>>> +++ b/drivers/vhost/vsock.c
>>> @@ -410,7 +410,6 @@ static struct virtio_transport vhost_transport = {
>>>  		.cancel_pkt               = vhost_transport_cancel_pkt,
>>>  
>>>  		.dgram_enqueue            = virtio_transport_dgram_enqueue,
>>> -		.dgram_dequeue            = virtio_transport_dgram_dequeue,
>>>  		.dgram_bind               = virtio_transport_dgram_bind,
>>>  		.dgram_allow              = virtio_transport_dgram_allow,
>>>  
>>> diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
>>> index c58453699ee9..18cbe8d37fca 100644
>>> --- a/include/linux/virtio_vsock.h
>>> +++ b/include/linux/virtio_vsock.h
>>> @@ -167,11 +167,6 @@ virtio_transport_stream_dequeue(struct vsock_sock *vsk,
>>>  				size_t len,
>>>  				int type);
>>>  int
>>> -virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
>>> -			       struct msghdr *msg,
>>> -			       size_t len, int flags);
>>> -
>>> -int
>>>  virtio_transport_seqpacket_enqueue(struct vsock_sock *vsk,
>>>  				   struct msghdr *msg,
>>>  				   size_t len);
>>> diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
>>> index 0e7504a42925..305d57502e89 100644
>>> --- a/include/net/af_vsock.h
>>> +++ b/include/net/af_vsock.h
>>> @@ -120,11 +120,10 @@ struct vsock_transport {
>>>  
>>>  	/* DGRAM. */
>>>  	int (*dgram_bind)(struct vsock_sock *, struct sockaddr_vm *);
>>> -	int (*dgram_dequeue)(struct vsock_sock *vsk, struct msghdr *msg,
>>> -			     size_t len, int flags);
>>>  	int (*dgram_enqueue)(struct vsock_sock *, struct sockaddr_vm *,
>>>  			     struct msghdr *, size_t len);
>>>  	bool (*dgram_allow)(u32 cid, u32 port);
>>> +	void (*dgram_addr_init)(struct sk_buff *skb, struct sockaddr_vm *addr);
>>>  
>>>  	/* STREAM. */
>>>  	/* TODO: stream_bind() */
>>> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>>> index deb72a8c44a7..ad71e084bf2f 100644
>>> --- a/net/vmw_vsock/af_vsock.c
>>> +++ b/net/vmw_vsock/af_vsock.c
>>> @@ -1272,11 +1272,15 @@ static int vsock_dgram_connect(struct socket *sock,
>>>  int vsock_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
>>>  			size_t len, int flags)
>>>  {
>>> +	const struct vsock_transport *transport;
>>>  #ifdef CONFIG_BPF_SYSCALL
>>>  	const struct proto *prot;
>>>  #endif
>>>  	struct vsock_sock *vsk;
>>> +	struct sk_buff *skb;
>>> +	size_t payload_len;
>>>  	struct sock *sk;
>>> +	int err;
>>>  
>>>  	sk = sock->sk;
>>>  	vsk = vsock_sk(sk);
>>> @@ -1287,7 +1291,41 @@ int vsock_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
>>>  		return prot->recvmsg(sk, msg, len, flags, NULL);
>>>  #endif
>>>  
>>> -	return vsk->transport->dgram_dequeue(vsk, msg, len, flags);
>>> +	if (flags & MSG_OOB || flags & MSG_ERRQUEUE)
>>> +		return -EOPNOTSUPP;
>>> +
>>> +	transport = vsk->transport;
>>> +
>>> +	/* Retrieve the head sk_buff from the socket's receive queue. */
>>> +	err = 0;
>>> +	skb = skb_recv_datagram(sk_vsock(vsk), flags, &err);
>>> +	if (!skb)
>>> +		return err;
>>> +
>>> +	payload_len = skb->len;
>>> +
>>> +	if (payload_len > len) {
>>> +		payload_len = len;
>>> +		msg->msg_flags |= MSG_TRUNC;
>>> +	}
>>> +
>>> +	/* Place the datagram payload in the user's iovec. */
>>> +	err = skb_copy_datagram_msg(skb, 0, msg, payload_len);
>>> +	if (err)
>>> +		goto out;
>>> +
>>> +	if (msg->msg_name) {
>>> +		/* Provide the address of the sender. */
>>> +		DECLARE_SOCKADDR(struct sockaddr_vm *, vm_addr, msg->msg_name);
>>> +
>>> +		transport->dgram_addr_init(skb, vm_addr);
>>
>> Do we need check that dgram_addr_init != NULL? because I see that not all transports have this
>> callback set in this patch
>>
> 
> How about adding the check somewhere outside of the hotpath, such as
> when the transport is assigned?

Yes, may be we can return ESOCKTNOSUPPORT if this callback is not provided by transport (as we dereference
it here without any checks).

Thanks, Arseniy

> 
>>> +		msg->msg_namelen = sizeof(*vm_addr);
>>> +	}
>>> +	err = payload_len;
>>> +
>>> +out:
>>> +	skb_free_datagram(&vsk->sk, skb);
>>> +	return err;
>>>  }
>>>  EXPORT_SYMBOL_GPL(vsock_dgram_recvmsg);
>>>  
>>> diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
>>> index 7cb1a9d2cdb4..7f1ea434656d 100644
>>> --- a/net/vmw_vsock/hyperv_transport.c
>>> +++ b/net/vmw_vsock/hyperv_transport.c
>>> @@ -556,12 +556,6 @@ static int hvs_dgram_bind(struct vsock_sock *vsk, struct sockaddr_vm *addr)
>>>  	return -EOPNOTSUPP;
>>>  }
>>>  
>>> -static int hvs_dgram_dequeue(struct vsock_sock *vsk, struct msghdr *msg,
>>> -			     size_t len, int flags)
>>> -{
>>> -	return -EOPNOTSUPP;
>>> -}
>>> -
>>>  static int hvs_dgram_enqueue(struct vsock_sock *vsk,
>>>  			     struct sockaddr_vm *remote, struct msghdr *msg,
>>>  			     size_t dgram_len)
>>> @@ -833,7 +827,6 @@ static struct vsock_transport hvs_transport = {
>>>  	.shutdown                 = hvs_shutdown,
>>>  
>>>  	.dgram_bind               = hvs_dgram_bind,
>>> -	.dgram_dequeue            = hvs_dgram_dequeue,
>>>  	.dgram_enqueue            = hvs_dgram_enqueue,
>>>  	.dgram_allow              = hvs_dgram_allow,
>>>  
>>> diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>>> index e95df847176b..66edffdbf303 100644
>>> --- a/net/vmw_vsock/virtio_transport.c
>>> +++ b/net/vmw_vsock/virtio_transport.c
>>> @@ -429,7 +429,6 @@ static struct virtio_transport virtio_transport = {
>>>  		.cancel_pkt               = virtio_transport_cancel_pkt,
>>>  
>>>  		.dgram_bind               = virtio_transport_dgram_bind,
>>> -		.dgram_dequeue            = virtio_transport_dgram_dequeue,
>>>  		.dgram_enqueue            = virtio_transport_dgram_enqueue,
>>>  		.dgram_allow              = virtio_transport_dgram_allow,
>>>  
>>> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>>> index b769fc258931..01ea1402ad40 100644
>>> --- a/net/vmw_vsock/virtio_transport_common.c
>>> +++ b/net/vmw_vsock/virtio_transport_common.c
>>> @@ -583,15 +583,6 @@ virtio_transport_seqpacket_enqueue(struct vsock_sock *vsk,
>>>  }
>>>  EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_enqueue);
>>>  
>>> -int
>>> -virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
>>> -			       struct msghdr *msg,
>>> -			       size_t len, int flags)
>>> -{
>>> -	return -EOPNOTSUPP;
>>> -}
>>> -EXPORT_SYMBOL_GPL(virtio_transport_dgram_dequeue);
>>> -
>>>  s64 virtio_transport_stream_has_data(struct vsock_sock *vsk)
>>>  {
>>>  	struct virtio_vsock_sock *vvs = vsk->trans;
>>> diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
>>> index b370070194fa..0bbbdb222245 100644
>>> --- a/net/vmw_vsock/vmci_transport.c
>>> +++ b/net/vmw_vsock/vmci_transport.c
>>> @@ -641,6 +641,7 @@ static int vmci_transport_recv_dgram_cb(void *data, struct vmci_datagram *dg)
>>>  	sock_hold(sk);
>>>  	skb_put(skb, size);
>>>  	memcpy(skb->data, dg, size);
>>> +	skb_pull(skb, VMCI_DG_HEADERSIZE);
>>>  	sk_receive_skb(sk, skb, 0);
>>>  
>>>  	return VMCI_SUCCESS;
>>> @@ -1731,57 +1732,18 @@ static int vmci_transport_dgram_enqueue(
>>>  	return err - sizeof(*dg);
>>>  }
>>>  
>>> -static int vmci_transport_dgram_dequeue(struct vsock_sock *vsk,
>>> -					struct msghdr *msg, size_t len,
>>> -					int flags)
>>> +static void vmci_transport_dgram_addr_init(struct sk_buff *skb,
>>> +					   struct sockaddr_vm *addr)
>>>  {
>>> -	int err;
>>>  	struct vmci_datagram *dg;
>>> -	size_t payload_len;
>>> -	struct sk_buff *skb;
>>> -
>>> -	if (flags & MSG_OOB || flags & MSG_ERRQUEUE)
>>> -		return -EOPNOTSUPP;
>>> -
>>> -	/* Retrieve the head sk_buff from the socket's receive queue. */
>>> -	err = 0;
>>> -	skb = skb_recv_datagram(&vsk->sk, flags, &err);
>>> -	if (!skb)
>>> -		return err;
>>> -
>>> -	dg = (struct vmci_datagram *)skb->data;
>>> -	if (!dg)
>>> -		/* err is 0, meaning we read zero bytes. */
>>> -		goto out;
>>> -
>>> -	payload_len = dg->payload_size;
>>> -	/* Ensure the sk_buff matches the payload size claimed in the packet. */
>>> -	if (payload_len != skb->len - sizeof(*dg)) {
>>> -		err = -EINVAL;
>>> -		goto out;
>>> -	}
>>> -
>>> -	if (payload_len > len) {
>>> -		payload_len = len;
>>> -		msg->msg_flags |= MSG_TRUNC;
>>> -	}
>>> +	unsigned int cid, port;
>>>  
>>> -	/* Place the datagram payload in the user's iovec. */
>>> -	err = skb_copy_datagram_msg(skb, sizeof(*dg), msg, payload_len);
>>> -	if (err)
>>> -		goto out;
>>> -
>>> -	if (msg->msg_name) {
>>> -		/* Provide the address of the sender. */
>>> -		DECLARE_SOCKADDR(struct sockaddr_vm *, vm_addr, msg->msg_name);
>>> -		vsock_addr_init(vm_addr, dg->src.context, dg->src.resource);
>>> -		msg->msg_namelen = sizeof(*vm_addr);
>>> -	}
>>> -	err = payload_len;
>>> +	WARN_ONCE(skb->head == skb->data, "vmci vsock bug: bad dgram skb");
>>>  
>>> -out:
>>> -	skb_free_datagram(&vsk->sk, skb);
>>> -	return err;
>>> +	dg = (struct vmci_datagram *)skb->head;
>>> +	cid = dg->src.context;
>>> +	port = dg->src.resource;
>>> +	vsock_addr_init(addr, cid, port);
>>
>> I think we
>>
>> 1) can short this to:
>>
>> vsock_addr_init(addr, dg->src.context, dg->src.resource);
>>
>> 2) w/o previous point, cid and port better be u32, as VMCI structure has u32 fields 'context' and
>>    'resource' and 'vsock_addr_init()' also has u32 type for both arguments.
>>
>> Thanks, Arseniy
> 
> Sounds good, thanks.
> 
>>
>>>  }
>>>  
>>>  static bool vmci_transport_dgram_allow(u32 cid, u32 port)
>>> @@ -2040,9 +2002,9 @@ static struct vsock_transport vmci_transport = {
>>>  	.release = vmci_transport_release,
>>>  	.connect = vmci_transport_connect,
>>>  	.dgram_bind = vmci_transport_dgram_bind,
>>> -	.dgram_dequeue = vmci_transport_dgram_dequeue,
>>>  	.dgram_enqueue = vmci_transport_dgram_enqueue,
>>>  	.dgram_allow = vmci_transport_dgram_allow,
>>> +	.dgram_addr_init = vmci_transport_dgram_addr_init,
>>>  	.stream_dequeue = vmci_transport_stream_dequeue,
>>>  	.stream_enqueue = vmci_transport_stream_enqueue,
>>>  	.stream_has_data = vmci_transport_stream_has_data,
>>> diff --git a/net/vmw_vsock/vsock_loopback.c b/net/vmw_vsock/vsock_loopback.c
>>> index 5c6360df1f31..2a59dd177c74 100644
>>> --- a/net/vmw_vsock/vsock_loopback.c
>>> +++ b/net/vmw_vsock/vsock_loopback.c
>>> @@ -62,7 +62,6 @@ static struct virtio_transport loopback_transport = {
>>>  		.cancel_pkt               = vsock_loopback_cancel_pkt,
>>>  
>>>  		.dgram_bind               = virtio_transport_dgram_bind,
>>> -		.dgram_dequeue            = virtio_transport_dgram_dequeue,
>>>  		.dgram_enqueue            = virtio_transport_dgram_enqueue,
>>>  		.dgram_allow              = virtio_transport_dgram_allow,
>>>  
>>>
> 
> Thanks,
> Bobby
