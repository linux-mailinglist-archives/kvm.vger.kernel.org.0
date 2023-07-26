Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAB01763D3F
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 19:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232100AbjGZRIN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jul 2023 13:08:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230109AbjGZRIM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jul 2023 13:08:12 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7C479B;
        Wed, 26 Jul 2023 10:08:10 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-686efb9ee3cso34628b3a.3;
        Wed, 26 Jul 2023 10:08:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690391290; x=1690996090;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jyXhagd27xsfagA4mpBvlczZOCwL70cnZ1O+Bi2yCeM=;
        b=WiRpf8xXnnPC2cDTySvVbHxkgThqpZ0c6oaaRYfTClFXawhCqp+jOW55lULpKEqU8M
         LO2CWdxcXYpZjZSoAaKs1dPRwlsf1EsGR6j710vfmVhImIBT7opyYJmwXzvYLD2FXwTM
         +dBEmqmarjHESBn3nXrpsFRKFOZvlAYnbsh5PrCC/4E1TQMTX2L37yhBsMmGPa5fSqf2
         7M5lKKi8ANw/XpxFBsFXmr98MzXGSL72Af98+FFSXEek7e1CulNPIycG8n3+lWVDCaJC
         AORitu/f+aJuVUu3bRMeQCg5RIAwvGrauvxQAsn2W9lieKqA/D9XqARHu1H/qaxRCIRX
         9v0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690391290; x=1690996090;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jyXhagd27xsfagA4mpBvlczZOCwL70cnZ1O+Bi2yCeM=;
        b=aQP4LPcwMvugw4MMBBMt9vLQ0tMaUoCXipOSpKXi4pQ93YJZSScDieat00f0OLzF1s
         nPC4j0qM4RuQWBTqGx55tC4H/5owBLj9nj8cMqkIQqjuniEk3kfUGun5tRSBXTmB75m2
         QZ4mdjfkJKRHEEvZJjqB+jIT15V62vwABp8tOSQsh5Jmg98AWIrhqMmaZ4vcMi3SGcsT
         rIpGOBox8dzxlDZFMmspIxAq/M+U8pU/yA+7YgMHRgS0+/MQcB5arSzERu6lOBYiB8Ll
         oQTz6JmeEPMmjNA77sw2BeApbl68WpiXh1fT71cy2SsOPEexIx3Q+hPvBZ68omGDlQSG
         TIPg==
X-Gm-Message-State: ABy/qLZScavji0eS3BA+Bc/H7v87fWGr1GW29Y8GcvwICDi86eQ/+p7j
        wbCQE+Fiao06cHpO/iVbdALOLktOkGtU/TBN
X-Google-Smtp-Source: APBJJlHoUxrL7Gb3vH3wGr3Zh4JL6JMMrXCYEcjaAvIOxbH/nVhdWi3v0nrKCkDeyj1henERh81tDA==
X-Received: by 2002:aa7:88c6:0:b0:682:a6c5:6f28 with SMTP id k6-20020aa788c6000000b00682a6c56f28mr3411995pff.32.1690391290004;
        Wed, 26 Jul 2023 10:08:10 -0700 (PDT)
Received: from localhost (c-73-190-126-111.hsd1.wa.comcast.net. [73.190.126.111])
        by smtp.gmail.com with ESMTPSA id x17-20020aa793b1000000b0064f51ee5b90sm12014pff.62.2023.07.26.10.08.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jul 2023 10:08:09 -0700 (PDT)
Date:   Wed, 26 Jul 2023 17:08:08 +0000
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
Subject: Re: [PATCH RFC net-next v5 07/14] virtio/vsock: add common datagram
 send path
Message-ID: <ZMFS+MlAPTso6wjQ@bullseye>
References: <20230413-b4-vsock-dgram-v5-0-581bd37fdb26@bytedance.com>
 <20230413-b4-vsock-dgram-v5-7-581bd37fdb26@bytedance.com>
 <051e4091-556c-4592-4a72-4dacf0015da8@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <051e4091-556c-4592-4a72-4dacf0015da8@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jul 22, 2023 at 11:16:05AM +0300, Arseniy Krasnov wrote:
> 
> 
> On 19.07.2023 03:50, Bobby Eshleman wrote:
> > This commit implements the common function
> > virtio_transport_dgram_enqueue for enqueueing datagrams. It does not add
> > usage in either vhost or virtio yet.
> > 
> > Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
> > ---
> >  net/vmw_vsock/virtio_transport_common.c | 76 ++++++++++++++++++++++++++++++++-
> >  1 file changed, 75 insertions(+), 1 deletion(-)
> > 
> > diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> > index ffcbdd77feaa..3bfaff758433 100644
> > --- a/net/vmw_vsock/virtio_transport_common.c
> > +++ b/net/vmw_vsock/virtio_transport_common.c
> > @@ -819,7 +819,81 @@ virtio_transport_dgram_enqueue(struct vsock_sock *vsk,
> >  			       struct msghdr *msg,
> >  			       size_t dgram_len)
> >  {
> > -	return -EOPNOTSUPP;
> > +	/* Here we are only using the info struct to retain style uniformity
> > +	 * and to ease future refactoring and merging.
> > +	 */
> > +	struct virtio_vsock_pkt_info info_stack = {
> > +		.op = VIRTIO_VSOCK_OP_RW,
> > +		.msg = msg,
> > +		.vsk = vsk,
> > +		.type = VIRTIO_VSOCK_TYPE_DGRAM,
> > +	};
> > +	const struct virtio_transport *t_ops;
> > +	struct virtio_vsock_pkt_info *info;
> > +	struct sock *sk = sk_vsock(vsk);
> > +	struct virtio_vsock_hdr *hdr;
> > +	u32 src_cid, src_port;
> > +	struct sk_buff *skb;
> > +	void *payload;
> > +	int noblock;
> > +	int err;
> > +
> > +	info = &info_stack;
> 
> I think 'info' assignment could be moved below, to the place where it is used
> first time.
> 
> > +
> > +	if (dgram_len > VIRTIO_VSOCK_MAX_PKT_BUF_SIZE)
> > +		return -EMSGSIZE;
> > +
> > +	t_ops = virtio_transport_get_ops(vsk);
> > +	if (unlikely(!t_ops))
> > +		return -EFAULT;
> > +
> > +	/* Unlike some of our other sending functions, this function is not
> > +	 * intended for use without a msghdr.
> > +	 */
> > +	if (WARN_ONCE(!msg, "vsock dgram bug: no msghdr found for dgram enqueue\n"))
> > +		return -EFAULT;
> 
> Sorry, but is that possible? I thought 'msg' is always provided by general socket layer (e.g. before
> af_vsock.c code) and can't be NULL for DGRAM. Please correct me if i'm wrong.
> 
> Also I see, that in af_vsock.c , 'vsock_dgram_sendmsg()' dereferences 'msg' for checking MSG_OOB without any
> checks (before calling transport callback - this function in case of virtio). So I think if we want to keep
> this type of check - such check must be placed in af_vsock.c or somewhere before first dereference of this pointer.
> 

There is some talk about dgram sockets adding additional messages types
in the future that help with congestion control. Those messages won't
come from the socket layer, so msghdr will be null. Since there is no
other function for sending datagrams, it seemed likely that this
function would be reworked for that purpose. I felt that adding this
check was a direct way to make it explicit that this function is
currently designed only for the socket-layer caller.

Perhaps a comment would suffice?

> > +
> > +	noblock = msg->msg_flags & MSG_DONTWAIT;
> > +
> > +	/* Use sock_alloc_send_skb to throttle by sk_sndbuf. This helps avoid
> > +	 * triggering the OOM.
> > +	 */
> > +	skb = sock_alloc_send_skb(sk, dgram_len + VIRTIO_VSOCK_SKB_HEADROOM,
> > +				  noblock, &err);
> > +	if (!skb)
> > +		return err;
> > +
> > +	skb_reserve(skb, VIRTIO_VSOCK_SKB_HEADROOM);
> > +
> > +	src_cid = t_ops->transport.get_local_cid();
> > +	src_port = vsk->local_addr.svm_port;
> > +
> > +	hdr = virtio_vsock_hdr(skb);
> > +	hdr->type	= cpu_to_le16(info->type);
> > +	hdr->op		= cpu_to_le16(info->op);
> > +	hdr->src_cid	= cpu_to_le64(src_cid);
> > +	hdr->dst_cid	= cpu_to_le64(remote_addr->svm_cid);
> > +	hdr->src_port	= cpu_to_le32(src_port);
> > +	hdr->dst_port	= cpu_to_le32(remote_addr->svm_port);
> > +	hdr->flags	= cpu_to_le32(info->flags);
> > +	hdr->len	= cpu_to_le32(dgram_len);
> > +
> > +	skb_set_owner_w(skb, sk);
> > +
> > +	payload = skb_put(skb, dgram_len);
> > +	err = memcpy_from_msg(payload, msg, dgram_len);
> > +	if (err)
> > +		return err;
> 
> Do we need free allocated skb here ?
> 

Yep, thanks.

> > +
> > +	trace_virtio_transport_alloc_pkt(src_cid, src_port,
> > +					 remote_addr->svm_cid,
> > +					 remote_addr->svm_port,
> > +					 dgram_len,
> > +					 info->type,
> > +					 info->op,
> > +					 0);
> > +
> > +	return t_ops->send_pkt(skb);
> >  }
> >  EXPORT_SYMBOL_GPL(virtio_transport_dgram_enqueue);
> >  
> > 
> 
> Thanks, Arseniy

Thanks for the review!

Best,
Bobby
