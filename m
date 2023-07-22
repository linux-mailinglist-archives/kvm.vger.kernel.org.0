Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E215875DAFC
	for <lists+kvm@lfdr.de>; Sat, 22 Jul 2023 10:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbjGVIQN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Jul 2023 04:16:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjGVIQM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Jul 2023 04:16:12 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2D812D58;
        Sat, 22 Jul 2023 01:16:10 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id 2adb3069b0e04-4fbc0314a7bso4145828e87.2;
        Sat, 22 Jul 2023 01:16:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690013769; x=1690618569;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TzDFSq9ToW2a8ApBbamX9DH0vv1xgjFWtYbk7I9a3zo=;
        b=iLHQMkzn513/CX45oKtJQROkuU6hKVIZtEYUjvD8YJbi8M6JmgtmRhQr8qCCfW6sdV
         fFnJktywfx3lh713VRE/fpTLUGqhM7eTtC4QGaI16YgOTN1N1RTwTfgVP8hfSsogJ4Nh
         Gq5zI3yjt4KPOpZPg4HVs9+68A9F1c3ow4aYnJy4wxziSVrWyulj/l1Fulkx4BOi3SuC
         h7jIKRY5ZXAm/vee7nES09uZfZXSOuWR6CM0mm8qUF8fDTKFYxuiIt1hdwjN2Ts2u3wX
         pF/YDQRQsnvC/hus4QYTvt3uKjLEN801mEl09d9/j82Uc2pBNbhVPFZpqdbQO1RCnAS+
         HfTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690013769; x=1690618569;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TzDFSq9ToW2a8ApBbamX9DH0vv1xgjFWtYbk7I9a3zo=;
        b=afzJg4c+UW48CY1ExkWpybNKiZsTkBDgFu09tmZQ0N9kILrpvnt1VvTa59ub5B/Eqc
         qnf73oYyb2FM2x+V4gUSw3Ex3+s37jb32XkgrSzvTyNCH2A5Afu8pjBtFaJ7weO3LGV3
         pLPIQVwlxUKxvvv8T5+6Q/RKInRI1dYv+jnyn7pFj6/IN7ZgLgJhFt8vLWM39+qF9Zxv
         4Tv8Rj0FxuFAEtrPlsrD2ZiZQ7i4IASMUkMtoUNISeRPFMqoANcHqorzKsuxeUAkN9DE
         TthzCw7W5hvaY2mWnJEQmjCQkpHHkNNA92Q7DNYyOaNUR1PpAHXipzWCPrtnKnrR57dj
         S/8Q==
X-Gm-Message-State: ABy/qLaF0YC2gAXV6yCeeWV2OzVG6Pt7YMbYEmdPLj1R9v3qGhTjWxcH
        ZWNE5mLD1OtDBw7M0YUZqdA=
X-Google-Smtp-Source: APBJJlF4G37yXBGyU+5UfZllj5K9yoI0tYISBTZQihm07jz0DksXS19CbW3keLZz1+QQUk60QkISJg==
X-Received: by 2002:ac2:4dbb:0:b0:4fb:772a:af12 with SMTP id h27-20020ac24dbb000000b004fb772aaf12mr2254319lfe.21.1690013768483;
        Sat, 22 Jul 2023 01:16:08 -0700 (PDT)
Received: from ?IPV6:2a00:1e88:c228:ec00:1b41:4959:c1a0:b9eb? ([2a00:1e88:c228:ec00:1b41:4959:c1a0:b9eb])
        by smtp.gmail.com with ESMTPSA id er14-20020a05651248ce00b004fdb27909cesm1097750lfb.5.2023.07.22.01.16.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Jul 2023 01:16:08 -0700 (PDT)
Message-ID: <051e4091-556c-4592-4a72-4dacf0015da8@gmail.com>
Date:   Sat, 22 Jul 2023 11:16:05 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH RFC net-next v5 07/14] virtio/vsock: add common datagram
 send path
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
 <20230413-b4-vsock-dgram-v5-7-581bd37fdb26@bytedance.com>
From:   Arseniy Krasnov <oxffffaa@gmail.com>
In-Reply-To: <20230413-b4-vsock-dgram-v5-7-581bd37fdb26@bytedance.com>
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
> This commit implements the common function
> virtio_transport_dgram_enqueue for enqueueing datagrams. It does not add
> usage in either vhost or virtio yet.
> 
> Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
> ---
>  net/vmw_vsock/virtio_transport_common.c | 76 ++++++++++++++++++++++++++++++++-
>  1 file changed, 75 insertions(+), 1 deletion(-)
> 
> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> index ffcbdd77feaa..3bfaff758433 100644
> --- a/net/vmw_vsock/virtio_transport_common.c
> +++ b/net/vmw_vsock/virtio_transport_common.c
> @@ -819,7 +819,81 @@ virtio_transport_dgram_enqueue(struct vsock_sock *vsk,
>  			       struct msghdr *msg,
>  			       size_t dgram_len)
>  {
> -	return -EOPNOTSUPP;
> +	/* Here we are only using the info struct to retain style uniformity
> +	 * and to ease future refactoring and merging.
> +	 */
> +	struct virtio_vsock_pkt_info info_stack = {
> +		.op = VIRTIO_VSOCK_OP_RW,
> +		.msg = msg,
> +		.vsk = vsk,
> +		.type = VIRTIO_VSOCK_TYPE_DGRAM,
> +	};
> +	const struct virtio_transport *t_ops;
> +	struct virtio_vsock_pkt_info *info;
> +	struct sock *sk = sk_vsock(vsk);
> +	struct virtio_vsock_hdr *hdr;
> +	u32 src_cid, src_port;
> +	struct sk_buff *skb;
> +	void *payload;
> +	int noblock;
> +	int err;
> +
> +	info = &info_stack;

I think 'info' assignment could be moved below, to the place where it is used
first time.

> +
> +	if (dgram_len > VIRTIO_VSOCK_MAX_PKT_BUF_SIZE)
> +		return -EMSGSIZE;
> +
> +	t_ops = virtio_transport_get_ops(vsk);
> +	if (unlikely(!t_ops))
> +		return -EFAULT;
> +
> +	/* Unlike some of our other sending functions, this function is not
> +	 * intended for use without a msghdr.
> +	 */
> +	if (WARN_ONCE(!msg, "vsock dgram bug: no msghdr found for dgram enqueue\n"))
> +		return -EFAULT;

Sorry, but is that possible? I thought 'msg' is always provided by general socket layer (e.g. before
af_vsock.c code) and can't be NULL for DGRAM. Please correct me if i'm wrong.

Also I see, that in af_vsock.c , 'vsock_dgram_sendmsg()' dereferences 'msg' for checking MSG_OOB without any
checks (before calling transport callback - this function in case of virtio). So I think if we want to keep
this type of check - such check must be placed in af_vsock.c or somewhere before first dereference of this pointer.

> +
> +	noblock = msg->msg_flags & MSG_DONTWAIT;
> +
> +	/* Use sock_alloc_send_skb to throttle by sk_sndbuf. This helps avoid
> +	 * triggering the OOM.
> +	 */
> +	skb = sock_alloc_send_skb(sk, dgram_len + VIRTIO_VSOCK_SKB_HEADROOM,
> +				  noblock, &err);
> +	if (!skb)
> +		return err;
> +
> +	skb_reserve(skb, VIRTIO_VSOCK_SKB_HEADROOM);
> +
> +	src_cid = t_ops->transport.get_local_cid();
> +	src_port = vsk->local_addr.svm_port;
> +
> +	hdr = virtio_vsock_hdr(skb);
> +	hdr->type	= cpu_to_le16(info->type);
> +	hdr->op		= cpu_to_le16(info->op);
> +	hdr->src_cid	= cpu_to_le64(src_cid);
> +	hdr->dst_cid	= cpu_to_le64(remote_addr->svm_cid);
> +	hdr->src_port	= cpu_to_le32(src_port);
> +	hdr->dst_port	= cpu_to_le32(remote_addr->svm_port);
> +	hdr->flags	= cpu_to_le32(info->flags);
> +	hdr->len	= cpu_to_le32(dgram_len);
> +
> +	skb_set_owner_w(skb, sk);
> +
> +	payload = skb_put(skb, dgram_len);
> +	err = memcpy_from_msg(payload, msg, dgram_len);
> +	if (err)
> +		return err;

Do we need free allocated skb here ?

> +
> +	trace_virtio_transport_alloc_pkt(src_cid, src_port,
> +					 remote_addr->svm_cid,
> +					 remote_addr->svm_port,
> +					 dgram_len,
> +					 info->type,
> +					 info->op,
> +					 0);
> +
> +	return t_ops->send_pkt(skb);
>  }
>  EXPORT_SYMBOL_GPL(virtio_transport_dgram_enqueue);
>  
> 

Thanks, Arseniy
