Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EED82770F69
	for <lists+kvm@lfdr.de>; Sat,  5 Aug 2023 13:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbjHELMp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 5 Aug 2023 07:12:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbjHELMn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 5 Aug 2023 07:12:43 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31A854215;
        Sat,  5 Aug 2023 04:12:42 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id 5b1f17b1804b1-3fe4a89e8c4so10364555e9.3;
        Sat, 05 Aug 2023 04:12:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691233960; x=1691838760;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AgWNyMxZp4Y1lh0jk2J1qrZPUTJ7GIIzr1e92o6ob7k=;
        b=cKmgs4BJFFxaeuZ5IzJVkWbattNKwAIpvXEbiG+5x2RXmSHhuMydTXXJuwD91FmNUN
         EKpnlNizgvrkXzwk9ZBoWiokiIbJkgnKgZAZ4fJ91rW3xbyyyfH+fFNwWGtv5fmyjdFT
         vAddfbPfNLiXwz1D/swITFXSrrol1g8R5/AgWaMlrLhfx+E3ykwmNj2qRR+RYAh7smrF
         BC8wtEk9wp1MdqWtpFBSfKNQgxyKYO8BMVBQd1WCajnk0WnYFr2tUZ38trEMXI8Kamlo
         rR91p6OY50F7YylO7E70NuH4EFy70sHU/tsjFT5UcChoPqwb0Eb0Man9sc+7MYfCVs11
         sT+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691233960; x=1691838760;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AgWNyMxZp4Y1lh0jk2J1qrZPUTJ7GIIzr1e92o6ob7k=;
        b=UNZfHDBcvaq/FwBQdtpbiBDRGTucxuOD0yX4IpqILhbc1ZNlpR5cNzbLHJtcfTbgtZ
         4yzQ6z9nNlbnmpZ3BGJNmzMVeS9y3d9ESgiUzJxmK1qm35PE1dv09B7HKgXQmlGWBVMy
         ljJpnLKjh4s8ziN49jxvn6HTkoNq/PFrvgd2fynK3vI3GaT+6JEQBk6JgnnJH4A97yLn
         XoIpHGAsuL2BvVKJ/lSxoL0V8RZZVwjnXKLX+Ff91ULqZ2as+01FpCaJpSKenDOTEZOn
         wO8DfJUV7T5RH+viX+a36L0zitfYWkYOQWz6TlAGOy88BEo/ExRODZsyVcQfHAIAKJ5f
         DXeQ==
X-Gm-Message-State: AOJu0YzwgwlRpwtLd5G9Jpeatm/AZPNmLiWExG0ukudXpdaeOmM4C3OV
        vgiKSHGqcMvC8aa+4nK/LCc=
X-Google-Smtp-Source: AGHT+IHO+ScG2K5CxPHsNMjHBz7qpit0hydbZUw0LLo5aF8s89U16DxNKWlP5CNpZlsFcq7lFoCGZA==
X-Received: by 2002:a1c:f717:0:b0:3fe:45e7:1d6f with SMTP id v23-20020a1cf717000000b003fe45e71d6fmr3073239wmh.21.1691233960365;
        Sat, 05 Aug 2023 04:12:40 -0700 (PDT)
Received: from [192.168.22.144] ([41.86.43.41])
        by smtp.gmail.com with ESMTPSA id y8-20020a7bcd88000000b003fe2b081661sm9165411wmj.30.2023.08.05.04.12.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Aug 2023 04:12:39 -0700 (PDT)
Message-ID: <0e1a5faf-88b7-87c5-ff92-413991878894@gmail.com>
Date:   Sat, 5 Aug 2023 14:12:33 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next v5 4/4] vsock/virtio: MSG_ZEROCOPY flag support
Content-Language: en-US
To:     Paolo Abeni <pabeni@redhat.com>,
        Arseniy Krasnov <AVKrasnov@sberdevices.ru>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@sberdevices.ru
References: <20230730085905.3420811-1-AVKrasnov@sberdevices.ru>
 <20230730085905.3420811-5-AVKrasnov@sberdevices.ru>
 <8a7772a50a16fbbcb82fc0c5e09f9e31f3427e3d.camel@redhat.com>
From:   Arseniy Krasnov <oxffffaa@gmail.com>
In-Reply-To: <8a7772a50a16fbbcb82fc0c5e09f9e31f3427e3d.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 01.08.2023 16:34, Paolo Abeni wrote:
> On Sun, 2023-07-30 at 11:59 +0300, Arseniy Krasnov wrote:
>> +static int virtio_transport_fill_skb(struct sk_buff *skb,
>> +				     struct virtio_vsock_pkt_info *info,
>> +				     size_t len,
>> +				     bool zcopy)
>> +{
>> +	if (zcopy) {
>> +		return __zerocopy_sg_from_iter(info->msg, NULL, skb,
>> +					      &info->msg->msg_iter,
>> +					      len);
>> +	} else {
> 
> 
> No need for an else statement after 'return'
> 
>> +		void *payload;
>> +		int err;
>> +
>> +		payload = skb_put(skb, len);
>> +		err = memcpy_from_msg(payload, info->msg, len);
>> +		if (err)
>> +			return -1;
>> +
>> +		if (msg_data_left(info->msg))
>> +			return 0;
>> +
> 
> This path does not update truesize, evem if it increases the skb len...

Sorry, but what is potential problem here ? In this path I copy data from the user's
buffer to the linear skb (there is no fragged part in this case). I think 'truesize'
is constant in this case - it is SKB_TRUESIZE(length of skb buffer) - there is no need
to update it as 'truesize' does not show amount of data in skb, only real size of
skb's buffer.

For non-linear case, __zerocopy_sg_from_iter() always updates 'sk_wmem_alloc' of the
socket during iterating over frags array.

Also 'skb_set_owner_w()' is called before this code, thus setting 'sk_wmem_alloc' to the
'truesize' value of the skb.

Thanks, Arseniy

> 
>> +		return 0;
>> +	}
>> +}
> 
> [...]
> 
>> @@ -214,6 +251,70 @@ static u16 virtio_transport_get_type(struct sock *sk)
>>  		return VIRTIO_VSOCK_TYPE_SEQPACKET;
>>  }
>>  
>> +static struct sk_buff *virtio_transport_alloc_skb(struct vsock_sock *vsk,
>> +						  struct virtio_vsock_pkt_info *info,
>> +						  size_t payload_len,
>> +						  bool zcopy,
>> +						  u32 src_cid,
>> +						  u32 src_port,
>> +						  u32 dst_cid,
>> +						  u32 dst_port)
>> +{
>> +	struct sk_buff *skb;
>> +	size_t skb_len;
>> +
>> +	skb_len = VIRTIO_VSOCK_SKB_HEADROOM;
>> +
>> +	if (!zcopy)
>> +		skb_len += payload_len;
>> +
>> +	skb = virtio_vsock_alloc_skb(skb_len, GFP_KERNEL);
>> +	if (!skb)
>> +		return NULL;
>> +
>> +	virtio_transport_init_hdr(skb, info, src_cid, src_port,
>> +				  dst_cid, dst_port,
>> +				  payload_len);
>> +
>> +	/* Set owner here, because '__zerocopy_sg_from_iter()' uses
>> +	 * owner of skb without check to update 'sk_wmem_alloc'.
>> +	 */
>> +	if (vsk)
>> +		skb_set_owner_w(skb, sk_vsock(vsk));
> 
> ... which can lead to bad things(TM) if the skb goes trough some later
> non trivial processing, due to the above skb_set_owner_w().
> 
> Additionally can be the following condition be true:
> 
> 	vsk == NULL && (info->msg && payload_len > 0) && zcopy
> 
> ???
> 
> If so it looks like skb can go through __zerocopy_sg_from_iter() even
> without a prior skb_set_owner_w()...
> 
> 
> Cheers,
> 
> Paolo
> 
