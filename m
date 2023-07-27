Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 418147649A7
	for <lists+kvm@lfdr.de>; Thu, 27 Jul 2023 10:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233502AbjG0IAF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jul 2023 04:00:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233431AbjG0H7i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jul 2023 03:59:38 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E67B91727;
        Thu, 27 Jul 2023 00:57:09 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id 38308e7fff4ca-2b962c226ceso9081551fa.3;
        Thu, 27 Jul 2023 00:57:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690444627; x=1691049427;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ARhledSl3QTGEGdemUznkguTQvORRBgIePoG3OHZLX0=;
        b=kAVILpgf9PWEo6kqHSy0GZHW7//7UJo6EeLXQN+jGobCUZGARX96Xr3JspeJIQdO1D
         hBShEwn6fNCaDTBhGpyJR4L6N62r5xxLzFK+jMdtfztGFupWCBMQbsdhvU/HxZDSJnOy
         T672KVe7L8Z5Vg0LbBRxCq+lKQdWC6PH73mUf55sxA5aY3GzZ3gIXzCHfXYC899jy1UR
         3Btuh+iOiKYaEfIK87W/bfaDaBYRbEV6EqFTb8I3oG4RWHyARty+4Q20EzxsxzexWiXt
         pRiXk2Zqgy52tHG20hJ7ZS2VEVbDFBNskOaR5EhmlFNKwsu/AFeiOW9gJOlj4RpnLVu5
         Lt/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690444627; x=1691049427;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ARhledSl3QTGEGdemUznkguTQvORRBgIePoG3OHZLX0=;
        b=YFLEB0YWsLVDyB2jYJ7Kxr+yUZfxEldeYlh2dtnhG5sW2GqS8akMzjOwO8Aw+P8aw9
         kBWoIlLKE2OFnBxp1L8ZkPIg+n1KfgS5jhO2skmQySC/LxRhb1QlIyZGhFvXaoLJ9Hfv
         BwqzS/WND02LFNqYMS8s5JQ+OBzDN3g26x4ziP4uiVAgJoZ/DFpqtFObSIm7Rlkn1fSy
         eF/CMM7k6vcu76f8JsNBWzyF8yvGDkR2eH6kCnN4+AxdWfoQRdi7gJCEiv8LfSfTflkc
         ZJvULoQaKrBanaeMb29GpKE/UJCGmds0fzaogRS143pT3/TSEjLTf+j5gS28lbziGeRu
         iQDw==
X-Gm-Message-State: ABy/qLZFfK7ynw/Fg2dzqJHITKMmTZJ74rxLoqq4Qn/IGNtnApVWNR5X
        e+U2JKC/iL35MklXYSuTrOQ=
X-Google-Smtp-Source: APBJJlGUEqszz20wUK1KKNzHsQgmvHQEDGcDX4RSlRskSTOnLFzTpwy3Dn6fyjgMusil+3lP1IwseQ==
X-Received: by 2002:a2e:b60e:0:b0:2b9:af56:f4b8 with SMTP id r14-20020a2eb60e000000b002b9af56f4b8mr1193635ljn.10.1690444627233;
        Thu, 27 Jul 2023 00:57:07 -0700 (PDT)
Received: from [192.168.0.112] ([77.220.140.242])
        by smtp.gmail.com with ESMTPSA id l14-20020a2e3e0e000000b002b6e13fcedcsm197684lja.122.2023.07.27.00.57.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Jul 2023 00:57:06 -0700 (PDT)
Message-ID: <dbf36361-8b94-e2e3-8478-c643bab54e43@gmail.com>
Date:   Thu, 27 Jul 2023 10:57:05 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH RFC net-next v5 07/14] virtio/vsock: add common datagram
 send path
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
 <20230413-b4-vsock-dgram-v5-7-581bd37fdb26@bytedance.com>
 <051e4091-556c-4592-4a72-4dacf0015da8@gmail.com> <ZMFS+MlAPTso6wjQ@bullseye>
From:   Arseniy Krasnov <oxffffaa@gmail.com>
In-Reply-To: <ZMFS+MlAPTso6wjQ@bullseye>
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



On 26.07.2023 20:08, Bobby Eshleman wrote:
> On Sat, Jul 22, 2023 at 11:16:05AM +0300, Arseniy Krasnov wrote:
>>
>>
>> On 19.07.2023 03:50, Bobby Eshleman wrote:
>>> This commit implements the common function
>>> virtio_transport_dgram_enqueue for enqueueing datagrams. It does not add
>>> usage in either vhost or virtio yet.
>>>
>>> Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
>>> ---
>>>  net/vmw_vsock/virtio_transport_common.c | 76 ++++++++++++++++++++++++++++++++-
>>>  1 file changed, 75 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>>> index ffcbdd77feaa..3bfaff758433 100644
>>> --- a/net/vmw_vsock/virtio_transport_common.c
>>> +++ b/net/vmw_vsock/virtio_transport_common.c
>>> @@ -819,7 +819,81 @@ virtio_transport_dgram_enqueue(struct vsock_sock *vsk,
>>>  			       struct msghdr *msg,
>>>  			       size_t dgram_len)
>>>  {
>>> -	return -EOPNOTSUPP;
>>> +	/* Here we are only using the info struct to retain style uniformity
>>> +	 * and to ease future refactoring and merging.
>>> +	 */
>>> +	struct virtio_vsock_pkt_info info_stack = {
>>> +		.op = VIRTIO_VSOCK_OP_RW,
>>> +		.msg = msg,
>>> +		.vsk = vsk,
>>> +		.type = VIRTIO_VSOCK_TYPE_DGRAM,
>>> +	};
>>> +	const struct virtio_transport *t_ops;
>>> +	struct virtio_vsock_pkt_info *info;
>>> +	struct sock *sk = sk_vsock(vsk);
>>> +	struct virtio_vsock_hdr *hdr;
>>> +	u32 src_cid, src_port;
>>> +	struct sk_buff *skb;
>>> +	void *payload;
>>> +	int noblock;
>>> +	int err;
>>> +
>>> +	info = &info_stack;
>>
>> I think 'info' assignment could be moved below, to the place where it is used
>> first time.
>>
>>> +
>>> +	if (dgram_len > VIRTIO_VSOCK_MAX_PKT_BUF_SIZE)
>>> +		return -EMSGSIZE;
>>> +
>>> +	t_ops = virtio_transport_get_ops(vsk);
>>> +	if (unlikely(!t_ops))
>>> +		return -EFAULT;
>>> +
>>> +	/* Unlike some of our other sending functions, this function is not
>>> +	 * intended for use without a msghdr.
>>> +	 */
>>> +	if (WARN_ONCE(!msg, "vsock dgram bug: no msghdr found for dgram enqueue\n"))
>>> +		return -EFAULT;
>>
>> Sorry, but is that possible? I thought 'msg' is always provided by general socket layer (e.g. before
>> af_vsock.c code) and can't be NULL for DGRAM. Please correct me if i'm wrong.
>>
>> Also I see, that in af_vsock.c , 'vsock_dgram_sendmsg()' dereferences 'msg' for checking MSG_OOB without any
>> checks (before calling transport callback - this function in case of virtio). So I think if we want to keep
>> this type of check - such check must be placed in af_vsock.c or somewhere before first dereference of this pointer.
>>
> 
> There is some talk about dgram sockets adding additional messages types
> in the future that help with congestion control. Those messages won't
> come from the socket layer, so msghdr will be null. Since there is no
> other function for sending datagrams, it seemed likely that this
> function would be reworked for that purpose. I felt that adding this
> check was a direct way to make it explicit that this function is
> currently designed only for the socket-layer caller.
> 
> Perhaps a comment would suffice?

I see, thanks, it is for future usage. Sorry for dumb question: but if msg is NULL, how
we will decide what to do in this call? Interface of this callback will be updated or
some fields of 'vsock_sock' will contain type of such messages ?

Thanks, Arseniy

> 
>>> +
>>> +	noblock = msg->msg_flags & MSG_DONTWAIT;
>>> +
>>> +	/* Use sock_alloc_send_skb to throttle by sk_sndbuf. This helps avoid
>>> +	 * triggering the OOM.
>>> +	 */
>>> +	skb = sock_alloc_send_skb(sk, dgram_len + VIRTIO_VSOCK_SKB_HEADROOM,
>>> +				  noblock, &err);
>>> +	if (!skb)
>>> +		return err;
>>> +
>>> +	skb_reserve(skb, VIRTIO_VSOCK_SKB_HEADROOM);
>>> +
>>> +	src_cid = t_ops->transport.get_local_cid();
>>> +	src_port = vsk->local_addr.svm_port;
>>> +
>>> +	hdr = virtio_vsock_hdr(skb);
>>> +	hdr->type	= cpu_to_le16(info->type);
>>> +	hdr->op		= cpu_to_le16(info->op);
>>> +	hdr->src_cid	= cpu_to_le64(src_cid);
>>> +	hdr->dst_cid	= cpu_to_le64(remote_addr->svm_cid);
>>> +	hdr->src_port	= cpu_to_le32(src_port);
>>> +	hdr->dst_port	= cpu_to_le32(remote_addr->svm_port);
>>> +	hdr->flags	= cpu_to_le32(info->flags);
>>> +	hdr->len	= cpu_to_le32(dgram_len);
>>> +
>>> +	skb_set_owner_w(skb, sk);
>>> +
>>> +	payload = skb_put(skb, dgram_len);
>>> +	err = memcpy_from_msg(payload, msg, dgram_len);
>>> +	if (err)
>>> +		return err;
>>
>> Do we need free allocated skb here ?
>>
> 
> Yep, thanks.
> 
>>> +
>>> +	trace_virtio_transport_alloc_pkt(src_cid, src_port,
>>> +					 remote_addr->svm_cid,
>>> +					 remote_addr->svm_port,
>>> +					 dgram_len,
>>> +					 info->type,
>>> +					 info->op,
>>> +					 0);
>>> +
>>> +	return t_ops->send_pkt(skb);
>>>  }
>>>  EXPORT_SYMBOL_GPL(virtio_transport_dgram_enqueue);
>>>  
>>>
>>
>> Thanks, Arseniy
> 
> Thanks for the review!
> 
> Best,
> Bobby
