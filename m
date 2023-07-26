Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40CF4763E4B
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 20:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbjGZSVN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jul 2023 14:21:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbjGZSVL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jul 2023 14:21:11 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 002F1B6;
        Wed, 26 Jul 2023 11:21:09 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-6862842a028so134869b3a.0;
        Wed, 26 Jul 2023 11:21:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690395669; x=1691000469;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fG9psAaaT6cNG6UQJT99/dag4u8eIusCPjtkO7qk2cM=;
        b=UUnKMljF572cwYgATBjn6xcOJRm5u99d7220iu5mfbMz9k9LWqw7lO+FU+J4outnDI
         ve3bPYxYvpHQMN5xTJ58mb9k4QYHe9whYJyaPM6a0cX70+pl9nIcO9XK3j5N/1kEIhPj
         D6XiL13bXO7UTNyhVQrxZbmNhkplycEEFm1Wx/gb/NUMybxv3bdrgcB6lr8mxl6nLbDk
         9+a+1qROyQ5PGoDbRMbYDeiapLINTr9kukNKs+HxeOur9BtO+VDlpahKVxu8VCLjfysD
         kvnjpqlTpp39BWHj8xSRr7KgbMQ6Lla258e9+8Ra2+ZxeWJWPjdn25Fiq9BVDkTl1GVz
         rM+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690395669; x=1691000469;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fG9psAaaT6cNG6UQJT99/dag4u8eIusCPjtkO7qk2cM=;
        b=aZy2qz7QbgR2gqLaoBBkHjqnAyFC+0vvmu9HHIr9SY+CR/Qk2IinOf9DuUrQ59yhSJ
         GJg12GOXUdzq0Lut9TFRu4KshXSLZ1p6qWuBuDLA+Gra89GDWdOyC57DkdLeIJ8l+cjF
         Y5LtSvjsGI5MN+J9Gk1tuSX+OO7Ll4Mlcv6Wo1niRKBQmJYZXJAiCDTOouDspN1iGNL8
         QecIm59JxGsPpaMAnGJUT7TUq8/oAlcWDlI/IKDDQoANH0hsEWn0EK9CzNYlUn5Rie5Z
         iAR/PUzYbn/iU0PFX4XszJHViFinAa07l/ByExfSRATj3QONsYAQ/3BabSDugAqDnpt6
         cJmQ==
X-Gm-Message-State: ABy/qLakjzx32cU2dxGCjPGRoL9ZgeN82AGFJ2kuraxL4X/DjIc1xbVD
        ykwIZn0r+j2j6nP0zKdBawM=
X-Google-Smtp-Source: APBJJlEQYh1pfG/657rsqUPj7JzTFMd7Nv3G2LS4VIDlfrBgUKRjiKDjhL6T9dUbeiLla1+dPsNzrw==
X-Received: by 2002:a05:6a21:71cb:b0:137:48cc:9cfa with SMTP id ay11-20020a056a2171cb00b0013748cc9cfamr2571643pzc.24.1690395669337;
        Wed, 26 Jul 2023 11:21:09 -0700 (PDT)
Received: from localhost (c-73-190-126-111.hsd1.wa.comcast.net. [73.190.126.111])
        by smtp.gmail.com with ESMTPSA id 17-20020aa79211000000b0063f1a1e3003sm11667539pfo.166.2023.07.26.11.21.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jul 2023 11:21:08 -0700 (PDT)
Date:   Wed, 26 Jul 2023 18:21:08 +0000
From:   Bobby Eshleman <bobbyeshleman@gmail.com>
To:     Arseniy Krasnov <oxffffaa@gmail.com>
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
Subject: Re: [PATCH RFC net-next v5 01/14] af_vsock: generalize
 vsock_dgram_recvmsg() to all transports
Message-ID: <ZMFkFE0AqaOUfric@bullseye>
References: <20230413-b4-vsock-dgram-v5-0-581bd37fdb26@bytedance.com>
 <20230413-b4-vsock-dgram-v5-1-581bd37fdb26@bytedance.com>
 <27a430f8-18e9-7cc2-c773-dde8ae824bfc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27a430f8-18e9-7cc2-c773-dde8ae824bfc@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 24, 2023 at 09:11:44PM +0300, Arseniy Krasnov wrote:
> 
> 
> On 19.07.2023 03:50, Bobby Eshleman wrote:
> > This commit drops the transport->dgram_dequeue callback and makes
> > vsock_dgram_recvmsg() generic to all transports.
> > 
> > To make this possible, two transport-level changes are introduced:
> > - implementation of the ->dgram_addr_init() callback to initialize
> >   the sockaddr_vm structure with data from incoming socket buffers.
> > - transport implementations set the skb->data pointer to the beginning
> >   of the payload prior to adding the skb to the socket's receive queue.
> >   That is, they must use skb_pull() before enqueuing. This is an
> >   agreement between the transport and the socket layer that skb->data
> >   always points to the beginning of the payload (and not, for example,
> >   the packet header).
> > 
> > Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
> > ---
> >  drivers/vhost/vsock.c                   |  1 -
> >  include/linux/virtio_vsock.h            |  5 ---
> >  include/net/af_vsock.h                  |  3 +-
> >  net/vmw_vsock/af_vsock.c                | 40 ++++++++++++++++++++++-
> >  net/vmw_vsock/hyperv_transport.c        |  7 ----
> >  net/vmw_vsock/virtio_transport.c        |  1 -
> >  net/vmw_vsock/virtio_transport_common.c |  9 -----
> >  net/vmw_vsock/vmci_transport.c          | 58 ++++++---------------------------
> >  net/vmw_vsock/vsock_loopback.c          |  1 -
> >  9 files changed, 50 insertions(+), 75 deletions(-)
> > 
> > diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> > index 6578db78f0ae..ae8891598a48 100644
> > --- a/drivers/vhost/vsock.c
> > +++ b/drivers/vhost/vsock.c
> > @@ -410,7 +410,6 @@ static struct virtio_transport vhost_transport = {
> >  		.cancel_pkt               = vhost_transport_cancel_pkt,
> >  
> >  		.dgram_enqueue            = virtio_transport_dgram_enqueue,
> > -		.dgram_dequeue            = virtio_transport_dgram_dequeue,
> >  		.dgram_bind               = virtio_transport_dgram_bind,
> >  		.dgram_allow              = virtio_transport_dgram_allow,
> >  
> > diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
> > index c58453699ee9..18cbe8d37fca 100644
> > --- a/include/linux/virtio_vsock.h
> > +++ b/include/linux/virtio_vsock.h
> > @@ -167,11 +167,6 @@ virtio_transport_stream_dequeue(struct vsock_sock *vsk,
> >  				size_t len,
> >  				int type);
> >  int
> > -virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
> > -			       struct msghdr *msg,
> > -			       size_t len, int flags);
> > -
> > -int
> >  virtio_transport_seqpacket_enqueue(struct vsock_sock *vsk,
> >  				   struct msghdr *msg,
> >  				   size_t len);
> > diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
> > index 0e7504a42925..305d57502e89 100644
> > --- a/include/net/af_vsock.h
> > +++ b/include/net/af_vsock.h
> > @@ -120,11 +120,10 @@ struct vsock_transport {
> >  
> >  	/* DGRAM. */
> >  	int (*dgram_bind)(struct vsock_sock *, struct sockaddr_vm *);
> > -	int (*dgram_dequeue)(struct vsock_sock *vsk, struct msghdr *msg,
> > -			     size_t len, int flags);
> >  	int (*dgram_enqueue)(struct vsock_sock *, struct sockaddr_vm *,
> >  			     struct msghdr *, size_t len);
> >  	bool (*dgram_allow)(u32 cid, u32 port);
> > +	void (*dgram_addr_init)(struct sk_buff *skb, struct sockaddr_vm *addr);
> >  
> >  	/* STREAM. */
> >  	/* TODO: stream_bind() */
> > diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> > index deb72a8c44a7..ad71e084bf2f 100644
> > --- a/net/vmw_vsock/af_vsock.c
> > +++ b/net/vmw_vsock/af_vsock.c
> > @@ -1272,11 +1272,15 @@ static int vsock_dgram_connect(struct socket *sock,
> >  int vsock_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
> >  			size_t len, int flags)
> >  {
> > +	const struct vsock_transport *transport;
> >  #ifdef CONFIG_BPF_SYSCALL
> >  	const struct proto *prot;
> >  #endif
> >  	struct vsock_sock *vsk;
> > +	struct sk_buff *skb;
> > +	size_t payload_len;
> >  	struct sock *sk;
> > +	int err;
> >  
> >  	sk = sock->sk;
> >  	vsk = vsock_sk(sk);
> > @@ -1287,7 +1291,41 @@ int vsock_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
> >  		return prot->recvmsg(sk, msg, len, flags, NULL);
> >  #endif
> >  
> > -	return vsk->transport->dgram_dequeue(vsk, msg, len, flags);
> > +	if (flags & MSG_OOB || flags & MSG_ERRQUEUE)
> > +		return -EOPNOTSUPP;
> > +
> > +	transport = vsk->transport;
> > +
> > +	/* Retrieve the head sk_buff from the socket's receive queue. */
> > +	err = 0;
> > +	skb = skb_recv_datagram(sk_vsock(vsk), flags, &err);
> > +	if (!skb)
> > +		return err;
> > +
> > +	payload_len = skb->len;
> > +
> > +	if (payload_len > len) {
> > +		payload_len = len;
> > +		msg->msg_flags |= MSG_TRUNC;
> > +	}
> > +
> > +	/* Place the datagram payload in the user's iovec. */
> > +	err = skb_copy_datagram_msg(skb, 0, msg, payload_len);
> > +	if (err)
> > +		goto out;
> > +
> > +	if (msg->msg_name) {
> > +		/* Provide the address of the sender. */
> > +		DECLARE_SOCKADDR(struct sockaddr_vm *, vm_addr, msg->msg_name);
> > +
> > +		transport->dgram_addr_init(skb, vm_addr);
> 
> Do we need check that dgram_addr_init != NULL? because I see that not all transports have this
> callback set in this patch
> 

How about adding the check somewhere outside of the hotpath, such as
when the transport is assigned?

> > +		msg->msg_namelen = sizeof(*vm_addr);
> > +	}
> > +	err = payload_len;
> > +
> > +out:
> > +	skb_free_datagram(&vsk->sk, skb);
> > +	return err;
> >  }
> >  EXPORT_SYMBOL_GPL(vsock_dgram_recvmsg);
> >  
> > diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
> > index 7cb1a9d2cdb4..7f1ea434656d 100644
> > --- a/net/vmw_vsock/hyperv_transport.c
> > +++ b/net/vmw_vsock/hyperv_transport.c
> > @@ -556,12 +556,6 @@ static int hvs_dgram_bind(struct vsock_sock *vsk, struct sockaddr_vm *addr)
> >  	return -EOPNOTSUPP;
> >  }
> >  
> > -static int hvs_dgram_dequeue(struct vsock_sock *vsk, struct msghdr *msg,
> > -			     size_t len, int flags)
> > -{
> > -	return -EOPNOTSUPP;
> > -}
> > -
> >  static int hvs_dgram_enqueue(struct vsock_sock *vsk,
> >  			     struct sockaddr_vm *remote, struct msghdr *msg,
> >  			     size_t dgram_len)
> > @@ -833,7 +827,6 @@ static struct vsock_transport hvs_transport = {
> >  	.shutdown                 = hvs_shutdown,
> >  
> >  	.dgram_bind               = hvs_dgram_bind,
> > -	.dgram_dequeue            = hvs_dgram_dequeue,
> >  	.dgram_enqueue            = hvs_dgram_enqueue,
> >  	.dgram_allow              = hvs_dgram_allow,
> >  
> > diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
> > index e95df847176b..66edffdbf303 100644
> > --- a/net/vmw_vsock/virtio_transport.c
> > +++ b/net/vmw_vsock/virtio_transport.c
> > @@ -429,7 +429,6 @@ static struct virtio_transport virtio_transport = {
> >  		.cancel_pkt               = virtio_transport_cancel_pkt,
> >  
> >  		.dgram_bind               = virtio_transport_dgram_bind,
> > -		.dgram_dequeue            = virtio_transport_dgram_dequeue,
> >  		.dgram_enqueue            = virtio_transport_dgram_enqueue,
> >  		.dgram_allow              = virtio_transport_dgram_allow,
> >  
> > diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> > index b769fc258931..01ea1402ad40 100644
> > --- a/net/vmw_vsock/virtio_transport_common.c
> > +++ b/net/vmw_vsock/virtio_transport_common.c
> > @@ -583,15 +583,6 @@ virtio_transport_seqpacket_enqueue(struct vsock_sock *vsk,
> >  }
> >  EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_enqueue);
> >  
> > -int
> > -virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
> > -			       struct msghdr *msg,
> > -			       size_t len, int flags)
> > -{
> > -	return -EOPNOTSUPP;
> > -}
> > -EXPORT_SYMBOL_GPL(virtio_transport_dgram_dequeue);
> > -
> >  s64 virtio_transport_stream_has_data(struct vsock_sock *vsk)
> >  {
> >  	struct virtio_vsock_sock *vvs = vsk->trans;
> > diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
> > index b370070194fa..0bbbdb222245 100644
> > --- a/net/vmw_vsock/vmci_transport.c
> > +++ b/net/vmw_vsock/vmci_transport.c
> > @@ -641,6 +641,7 @@ static int vmci_transport_recv_dgram_cb(void *data, struct vmci_datagram *dg)
> >  	sock_hold(sk);
> >  	skb_put(skb, size);
> >  	memcpy(skb->data, dg, size);
> > +	skb_pull(skb, VMCI_DG_HEADERSIZE);
> >  	sk_receive_skb(sk, skb, 0);
> >  
> >  	return VMCI_SUCCESS;
> > @@ -1731,57 +1732,18 @@ static int vmci_transport_dgram_enqueue(
> >  	return err - sizeof(*dg);
> >  }
> >  
> > -static int vmci_transport_dgram_dequeue(struct vsock_sock *vsk,
> > -					struct msghdr *msg, size_t len,
> > -					int flags)
> > +static void vmci_transport_dgram_addr_init(struct sk_buff *skb,
> > +					   struct sockaddr_vm *addr)
> >  {
> > -	int err;
> >  	struct vmci_datagram *dg;
> > -	size_t payload_len;
> > -	struct sk_buff *skb;
> > -
> > -	if (flags & MSG_OOB || flags & MSG_ERRQUEUE)
> > -		return -EOPNOTSUPP;
> > -
> > -	/* Retrieve the head sk_buff from the socket's receive queue. */
> > -	err = 0;
> > -	skb = skb_recv_datagram(&vsk->sk, flags, &err);
> > -	if (!skb)
> > -		return err;
> > -
> > -	dg = (struct vmci_datagram *)skb->data;
> > -	if (!dg)
> > -		/* err is 0, meaning we read zero bytes. */
> > -		goto out;
> > -
> > -	payload_len = dg->payload_size;
> > -	/* Ensure the sk_buff matches the payload size claimed in the packet. */
> > -	if (payload_len != skb->len - sizeof(*dg)) {
> > -		err = -EINVAL;
> > -		goto out;
> > -	}
> > -
> > -	if (payload_len > len) {
> > -		payload_len = len;
> > -		msg->msg_flags |= MSG_TRUNC;
> > -	}
> > +	unsigned int cid, port;
> >  
> > -	/* Place the datagram payload in the user's iovec. */
> > -	err = skb_copy_datagram_msg(skb, sizeof(*dg), msg, payload_len);
> > -	if (err)
> > -		goto out;
> > -
> > -	if (msg->msg_name) {
> > -		/* Provide the address of the sender. */
> > -		DECLARE_SOCKADDR(struct sockaddr_vm *, vm_addr, msg->msg_name);
> > -		vsock_addr_init(vm_addr, dg->src.context, dg->src.resource);
> > -		msg->msg_namelen = sizeof(*vm_addr);
> > -	}
> > -	err = payload_len;
> > +	WARN_ONCE(skb->head == skb->data, "vmci vsock bug: bad dgram skb");
> >  
> > -out:
> > -	skb_free_datagram(&vsk->sk, skb);
> > -	return err;
> > +	dg = (struct vmci_datagram *)skb->head;
> > +	cid = dg->src.context;
> > +	port = dg->src.resource;
> > +	vsock_addr_init(addr, cid, port);
> 
> I think we
> 
> 1) can short this to:
> 
> vsock_addr_init(addr, dg->src.context, dg->src.resource);
> 
> 2) w/o previous point, cid and port better be u32, as VMCI structure has u32 fields 'context' and
>    'resource' and 'vsock_addr_init()' also has u32 type for both arguments.
> 
> Thanks, Arseniy

Sounds good, thanks.

> 
> >  }
> >  
> >  static bool vmci_transport_dgram_allow(u32 cid, u32 port)
> > @@ -2040,9 +2002,9 @@ static struct vsock_transport vmci_transport = {
> >  	.release = vmci_transport_release,
> >  	.connect = vmci_transport_connect,
> >  	.dgram_bind = vmci_transport_dgram_bind,
> > -	.dgram_dequeue = vmci_transport_dgram_dequeue,
> >  	.dgram_enqueue = vmci_transport_dgram_enqueue,
> >  	.dgram_allow = vmci_transport_dgram_allow,
> > +	.dgram_addr_init = vmci_transport_dgram_addr_init,
> >  	.stream_dequeue = vmci_transport_stream_dequeue,
> >  	.stream_enqueue = vmci_transport_stream_enqueue,
> >  	.stream_has_data = vmci_transport_stream_has_data,
> > diff --git a/net/vmw_vsock/vsock_loopback.c b/net/vmw_vsock/vsock_loopback.c
> > index 5c6360df1f31..2a59dd177c74 100644
> > --- a/net/vmw_vsock/vsock_loopback.c
> > +++ b/net/vmw_vsock/vsock_loopback.c
> > @@ -62,7 +62,6 @@ static struct virtio_transport loopback_transport = {
> >  		.cancel_pkt               = vsock_loopback_cancel_pkt,
> >  
> >  		.dgram_bind               = virtio_transport_dgram_bind,
> > -		.dgram_dequeue            = virtio_transport_dgram_dequeue,
> >  		.dgram_enqueue            = virtio_transport_dgram_enqueue,
> >  		.dgram_allow              = virtio_transport_dgram_allow,
> >  
> > 

Thanks,
Bobby
