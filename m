Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FB6476DAB3
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 00:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234067AbjHBWW0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 18:22:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232763AbjHBWWG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 18:22:06 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DADF46B7;
        Wed,  2 Aug 2023 15:20:30 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1bb119be881so3287645ad.3;
        Wed, 02 Aug 2023 15:20:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691014814; x=1691619614;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fsO18jbro23/540UiL63McF01EyAUYZvzhuNfCuznL4=;
        b=WZXqrWQ8f0yIm2LQBBhvr3Fa4+eH+Qt3mWIjtAM+wP4e988G9Dh0kG1Yv7OtIuKwsF
         5MgSi+QjNJQXv0+uFK/KwhIANABiEMebGq2NAEwKxuiAk8TlnfsLOt+sLWJBwfj8UGVm
         fnD9jhi+qGL3tTYJ/ctWPw0HooKTZLNcaNelgD/uw2K1rTXsw6MI1YKMlPnuGdSmf40w
         yYMHaHGF78r7iCGQlOo/cgX1Hx46JhbiiDJip9xt+7If03OQe6hvt1kk2iU2d1xNIzPn
         1Y9qtd9HJm0x/C2lxQhAu4Jc2REzMWDUure3Yeef5b81cAm//KCzIbN1V3tFG6qQJzH7
         i2fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691014814; x=1691619614;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fsO18jbro23/540UiL63McF01EyAUYZvzhuNfCuznL4=;
        b=SMrlq7vpc7/uZH805Ek5DQ3yt1TJ+LKAVmdgOESu51p4ggmmS5YNEBgJn+X6kYLrgN
         Ol3y+vnOMhN6uzsNdsr6wYNjiuqKyxN9wk4GkE7xWuWFs7eOib29BcMOGlttnaIqSRIF
         eFgHqRtlW/8Zey3+0XAfHNAxEak/8dId9PWltdkppv9IiwD3/8AdAGHKgqptEctMJagJ
         hZF7N3QUG+6k5k0P16cmANP2726Rcm5O/rCDSYNG3sizACBr9xitEXApmz4xoruk3X6Y
         6ppk8MU16+Vo6DNZOlTiaFmSJH4t6U7SZLRh6TPLwpC7w7G0mkA3S+kszSVSjVfBz9pP
         tuGA==
X-Gm-Message-State: ABy/qLaM2W7HYvMjHZUH8vTb2e5s4vVRxLW/5LTd5XV60HKdtcH1xE10
        cRRJdaIyxPwIUbA/ho/NAoM=
X-Google-Smtp-Source: APBJJlGru4c6zFfgUeuBFSmQHEAVj9BnJRBBzAjnkXgiijxG1Thgs2LpEKcuV62N5/b70m9SiRkCpg==
X-Received: by 2002:a17:902:e746:b0:1ab:11c8:777a with SMTP id p6-20020a170902e74600b001ab11c8777amr20667592plf.13.1691014814102;
        Wed, 02 Aug 2023 15:20:14 -0700 (PDT)
Received: from localhost (ec2-52-8-182-0.us-west-1.compute.amazonaws.com. [52.8.182.0])
        by smtp.gmail.com with ESMTPSA id e12-20020a170902ed8c00b001b9cea4e8a2sm12884062plj.293.2023.08.02.15.20.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Aug 2023 15:20:13 -0700 (PDT)
Date:   Wed, 2 Aug 2023 21:23:43 +0000
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
Subject: Re: [PATCH RFC net-next v5 11/14] vhost/vsock: implement datagram
 support
Message-ID: <ZMrJX/mBF1HbbOkO@bullseye>
References: <20230413-b4-vsock-dgram-v5-0-581bd37fdb26@bytedance.com>
 <20230413-b4-vsock-dgram-v5-11-581bd37fdb26@bytedance.com>
 <b15d237e-31b5-40ae-83fc-e71649febd2b@gmail.com>
 <ZMFd+Jd/LrfpJsVA@bullseye>
 <acd54194-d397-e721-28e4-73a69257a2a9@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acd54194-d397-e721-28e4-73a69257a2a9@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 27, 2023 at 11:00:55AM +0300, Arseniy Krasnov wrote:
> 
> 
> On 26.07.2023 20:55, Bobby Eshleman wrote:
> > On Sat, Jul 22, 2023 at 11:42:38AM +0300, Arseniy Krasnov wrote:
> >>
> >>
> >> On 19.07.2023 03:50, Bobby Eshleman wrote:
> >>> This commit implements datagram support for vhost/vsock by teaching
> >>> vhost to use the common virtio transport datagram functions.
> >>>
> >>> If the virtio RX buffer is too small, then the transmission is
> >>> abandoned, the packet dropped, and EHOSTUNREACH is added to the socket's
> >>> error queue.
> >>>
> >>> Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
> >>> ---
> >>>  drivers/vhost/vsock.c    | 62 +++++++++++++++++++++++++++++++++++++++++++++---
> >>>  net/vmw_vsock/af_vsock.c |  5 +++-
> >>>  2 files changed, 63 insertions(+), 4 deletions(-)
> >>>
> >>> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> >>> index d5d6a3c3f273..da14260c6654 100644
> >>> --- a/drivers/vhost/vsock.c
> >>> +++ b/drivers/vhost/vsock.c
> >>> @@ -8,6 +8,7 @@
> >>>   */
> >>>  #include <linux/miscdevice.h>
> >>>  #include <linux/atomic.h>
> >>> +#include <linux/errqueue.h>
> >>>  #include <linux/module.h>
> >>>  #include <linux/mutex.h>
> >>>  #include <linux/vmalloc.h>
> >>> @@ -32,7 +33,8 @@
> >>>  enum {
> >>>  	VHOST_VSOCK_FEATURES = VHOST_FEATURES |
> >>>  			       (1ULL << VIRTIO_F_ACCESS_PLATFORM) |
> >>> -			       (1ULL << VIRTIO_VSOCK_F_SEQPACKET)
> >>> +			       (1ULL << VIRTIO_VSOCK_F_SEQPACKET) |
> >>> +			       (1ULL << VIRTIO_VSOCK_F_DGRAM)
> >>>  };
> >>>  
> >>>  enum {
> >>> @@ -56,6 +58,7 @@ struct vhost_vsock {
> >>>  	atomic_t queued_replies;
> >>>  
> >>>  	u32 guest_cid;
> >>> +	bool dgram_allow;
> >>>  	bool seqpacket_allow;
> >>>  };
> >>>  
> >>> @@ -86,6 +89,32 @@ static struct vhost_vsock *vhost_vsock_get(u32 guest_cid)
> >>>  	return NULL;
> >>>  }
> >>>  
> >>> +/* Claims ownership of the skb, do not free the skb after calling! */
> >>> +static void
> >>> +vhost_transport_error(struct sk_buff *skb, int err)
> >>> +{
> >>> +	struct sock_exterr_skb *serr;
> >>> +	struct sock *sk = skb->sk;
> >>> +	struct sk_buff *clone;
> >>> +
> >>> +	serr = SKB_EXT_ERR(skb);
> >>> +	memset(serr, 0, sizeof(*serr));
> >>> +	serr->ee.ee_errno = err;
> >>> +	serr->ee.ee_origin = SO_EE_ORIGIN_NONE;
> >>> +
> >>> +	clone = skb_clone(skb, GFP_KERNEL);
> >>
> >> May for skb which is error carrier we can use 'sock_omalloc()', not 'skb_clone()' ? TCP uses skb
> >> allocated by this function as carriers of error structure. I guess 'skb_clone()' also clones data of origin,
> >> but i think that there is no need in data as we insert it to error queue of the socket.
> >>
> >> What do You think?
> > 
> > IIUC skb_clone() is often used in this scenario so that the user can
> > retrieve the error-causing packet from the error queue.  Is there some
> > reason we shouldn't do this?
> > 
> > I'm seeing that the serr bits need to occur on the clone here, not the
> > original. I didn't realize the SKB_EXT_ERR() is a skb->cb cast. I'm not
> > actually sure how this passes the test case since ->cb isn't cloned.
> 
> Ah yes, sorry, You are right, I just confused this case with zerocopy completion
> handling - there we allocate "empty" skb which carries completion metadata in its
> 'cb' field.
> 
> Hm, but can't we just reinsert current skb (update it's 'cb' as 'sock_exterr_skb')
> to error queue of the socket without cloning it ?
> 
> Thanks, Arseniy
> 

I just assumed other socket types used skb_clone() for some reason
unknown to me and I didn't want to deviate.

If it is fine to just use the skb directly, then I am happy to make that
change.

Best,
Bobby

> > 
> >>
> >>> +	if (!clone)
> >>> +		return;
> >>
> >> What will happen here 'if (!clone)' ? skb will leak as it was removed from queue?
> >>
> > 
> > Ah yes, true.
> > 
> >>> +
> >>> +	if (sock_queue_err_skb(sk, clone))
> >>> +		kfree_skb(clone);
> >>> +
> >>> +	sk->sk_err = err;
> >>> +	sk_error_report(sk);
> >>> +
> >>> +	kfree_skb(skb);
> >>> +}
> >>> +
> >>>  static void
> >>>  vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
> >>>  			    struct vhost_virtqueue *vq)
> >>> @@ -160,9 +189,15 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
> >>>  		hdr = virtio_vsock_hdr(skb);
> >>>  
> >>>  		/* If the packet is greater than the space available in the
> >>> -		 * buffer, we split it using multiple buffers.
> >>> +		 * buffer, we split it using multiple buffers for connectible
> >>> +		 * sockets and drop the packet for datagram sockets.
> >>>  		 */
> >>>  		if (payload_len > iov_len - sizeof(*hdr)) {
> >>> +			if (le16_to_cpu(hdr->type) == VIRTIO_VSOCK_TYPE_DGRAM) {
> >>> +				vhost_transport_error(skb, EHOSTUNREACH);
> >>> +				continue;
> >>> +			}
> >>> +
> >>>  			payload_len = iov_len - sizeof(*hdr);
> >>>  
> >>>  			/* As we are copying pieces of large packet's buffer to
> >>> @@ -394,6 +429,7 @@ static bool vhost_vsock_more_replies(struct vhost_vsock *vsock)
> >>>  	return val < vq->num;
> >>>  }
> >>>  
> >>> +static bool vhost_transport_dgram_allow(u32 cid, u32 port);
> >>>  static bool vhost_transport_seqpacket_allow(u32 remote_cid);
> >>>  
> >>>  static struct virtio_transport vhost_transport = {
> >>> @@ -410,7 +446,8 @@ static struct virtio_transport vhost_transport = {
> >>>  		.cancel_pkt               = vhost_transport_cancel_pkt,
> >>>  
> >>>  		.dgram_enqueue            = virtio_transport_dgram_enqueue,
> >>> -		.dgram_allow              = virtio_transport_dgram_allow,
> >>> +		.dgram_allow              = vhost_transport_dgram_allow,
> >>> +		.dgram_addr_init          = virtio_transport_dgram_addr_init,
> >>>  
> >>>  		.stream_enqueue           = virtio_transport_stream_enqueue,
> >>>  		.stream_dequeue           = virtio_transport_stream_dequeue,
> >>> @@ -443,6 +480,22 @@ static struct virtio_transport vhost_transport = {
> >>>  	.send_pkt = vhost_transport_send_pkt,
> >>>  };
> >>>  
> >>> +static bool vhost_transport_dgram_allow(u32 cid, u32 port)
> >>> +{
> >>> +	struct vhost_vsock *vsock;
> >>> +	bool dgram_allow = false;
> >>> +
> >>> +	rcu_read_lock();
> >>> +	vsock = vhost_vsock_get(cid);
> >>> +
> >>> +	if (vsock)
> >>> +		dgram_allow = vsock->dgram_allow;
> >>> +
> >>> +	rcu_read_unlock();
> >>> +
> >>> +	return dgram_allow;
> >>> +}
> >>> +
> >>>  static bool vhost_transport_seqpacket_allow(u32 remote_cid)
> >>>  {
> >>>  	struct vhost_vsock *vsock;
> >>> @@ -799,6 +852,9 @@ static int vhost_vsock_set_features(struct vhost_vsock *vsock, u64 features)
> >>>  	if (features & (1ULL << VIRTIO_VSOCK_F_SEQPACKET))
> >>>  		vsock->seqpacket_allow = true;
> >>>  
> >>> +	if (features & (1ULL << VIRTIO_VSOCK_F_DGRAM))
> >>> +		vsock->dgram_allow = true;
> >>> +
> >>>  	for (i = 0; i < ARRAY_SIZE(vsock->vqs); i++) {
> >>>  		vq = &vsock->vqs[i];
> >>>  		mutex_lock(&vq->mutex);
> >>> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> >>> index e73f3b2c52f1..449ed63ac2b0 100644
> >>> --- a/net/vmw_vsock/af_vsock.c
> >>> +++ b/net/vmw_vsock/af_vsock.c
> >>> @@ -1427,9 +1427,12 @@ int vsock_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
> >>>  		return prot->recvmsg(sk, msg, len, flags, NULL);
> >>>  #endif
> >>>  
> >>> -	if (flags & MSG_OOB || flags & MSG_ERRQUEUE)
> >>> +	if (unlikely(flags & MSG_OOB))
> >>>  		return -EOPNOTSUPP;
> >>>  
> >>> +	if (unlikely(flags & MSG_ERRQUEUE))
> >>> +		return sock_recv_errqueue(sk, msg, len, SOL_VSOCK, 0);
> >>> +
> >>
> >> Sorry, but I get build error here, because SOL_VSOCK in undefined. I think it should be added to
> >> include/linux/socket.h and to uapi files also for future use in userspace.
> >>
> > 
> > Strange, I built each patch individually without issue. My base is
> > netdev/main with your SOL_VSOCK patch applied. I will look today and see
> > if I'm missing something.
> > 
> >> Also Stefano Garzarella <sgarzare@redhat.com> suggested to add define something like VSOCK_RECVERR,
> >> in the same way as IP_RECVERR, and use it as last parameter of 'sock_recv_errqueue()'.
> >>
> > 
> > Got it, thanks.
> > 
> >>>  	transport = vsk->transport;
> >>>  
> >>>  	/* Retrieve the head sk_buff from the socket's receive queue. */
> >>>
> >>
> >> Thanks, Arseniy
> > 
> > Thanks,
> > Bobby
