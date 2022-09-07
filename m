Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADAF15AFB0C
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 06:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229594AbiIGEV1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 00:21:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiIGEVZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 00:21:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE7C895F4
        for <kvm@vger.kernel.org>; Tue,  6 Sep 2022 21:21:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662524483;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S+P+z8TSJ/Zyfj7d1c5azECG0cOYl08GFb3K30xN3HE=;
        b=cbSdOOb7+214i8IH3P/vk8Atr/xd3h0iKiR95sSTIDCNQtFaY+BQjzQBK6n9cjyworqzdu
        Ix5vqALJJpm1l63yRA2rSnq5MjscAWoW56zJB9u/o/Xf3fVlBG0nHKV04P+1nNvZttf8xO
        zreuvx7GUyLk3pZxiM0+xjKuIer/CJU=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-609-GKUXAxcCOU-uKri2Rlx_SQ-1; Wed, 07 Sep 2022 00:21:20 -0400
X-MC-Unique: GKUXAxcCOU-uKri2Rlx_SQ-1
Received: by mail-pf1-f199.google.com with SMTP id x25-20020aa79199000000b005358eeebf49so6903541pfa.17
        for <kvm@vger.kernel.org>; Tue, 06 Sep 2022 21:21:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=S+P+z8TSJ/Zyfj7d1c5azECG0cOYl08GFb3K30xN3HE=;
        b=qJCULP5r4etEJaS1QAFywm791XXo/lBsuCRl1umkSrruhDddsuaNbK3gPEJqva7nIi
         0NKjtWsJZmI4LAVIiwwJwoBqo3pzOR8sHLqWKLyChweiZxNVkKwasahUrDjXKkC+/znH
         eF1Au+ZPstJ5SzmIlYbUpTIRtuIZOtsQIipOSWBkpYHFOzYIZVCV9EDGl3PHl+vN+Tys
         nYG46zJ9aD2TkctvRlT8QAn1JCsDBUx4aFIn6ss3ftIKPhnIN4I/aQcdwtd/zNaClJAv
         euN4disa3ajVFAFzXNhYxIT1mQsx13nPfmegNfTqZyleNgADaTNmL1k6hXwnVzBlZi8n
         WzBA==
X-Gm-Message-State: ACgBeo2ts4CgI3lNUtkLzpoLNWJP9/aRaLSZAUxw9ULo2c08YXpLQbBx
        cmAXsVxcNLBsqPZ6W5qxy+7XW1ZBDaPLAx6xK42YxQ9doPhkRuXV5wV9lI0ztZmfQvekGzcAKmQ
        xJ6om0IAoW5pQ
X-Received: by 2002:a05:6a00:22c7:b0:53a:bea5:9abd with SMTP id f7-20020a056a0022c700b0053abea59abdmr1770315pfj.3.1662524479095;
        Tue, 06 Sep 2022 21:21:19 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7FdPkXihchbJtJv8Jd83bDgPxk3tYbsa2yRZ4rh/+Tyemh4rXUJmUXF5h6WyCU3XNVQ3nufA==
X-Received: by 2002:a05:6a00:22c7:b0:53a:bea5:9abd with SMTP id f7-20020a056a0022c700b0053abea59abdmr1770291pfj.3.1662524478842;
        Tue, 06 Sep 2022 21:21:18 -0700 (PDT)
Received: from [10.72.13.171] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b28-20020aa78edc000000b0053ae6a3c51asm11172533pfr.186.2022.09.06.21.21.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Sep 2022 21:21:18 -0700 (PDT)
Message-ID: <dcf40392-26a7-b4f1-ad2c-44fac99fb330@redhat.com>
Date:   Wed, 7 Sep 2022 12:21:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [RFC v3 1/7] vhost: expose used buffers
Content-Language: en-US
To:     Guo Zhi <qtxuning1999@sjtu.edu.cn>, eperezma@redhat.com,
        sgarzare@redhat.com, mst@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
References: <20220901055434.824-1-qtxuning1999@sjtu.edu.cn>
 <20220901055434.824-2-qtxuning1999@sjtu.edu.cn>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220901055434.824-2-qtxuning1999@sjtu.edu.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2022/9/1 13:54, Guo Zhi 写道:
> Follow VIRTIO 1.1 spec, only writing out a single used ring for a batch
> of descriptors.
>
> Signed-off-by: Guo Zhi <qtxuning1999@sjtu.edu.cn>
> ---
>   drivers/vhost/vhost.c | 16 +++++++++++++---
>   1 file changed, 13 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 40097826cff0..26862c8bf751 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -2376,10 +2376,20 @@ static int __vhost_add_used_n(struct vhost_virtqueue *vq,
>   	vring_used_elem_t __user *used;
>   	u16 old, new;
>   	int start;
> +	int copy_n = count;
>   
> +	/**
> +	 * If in order feature negotiated, devices can notify the use of a batch of buffers to
> +	 * the driver by only writing out a single used ring entry with the id corresponding
> +	 * to the head entry of the descriptor chain describing the last buffer in the batch.
> +	 */
> +	if (vhost_has_feature(vq, VIRTIO_F_IN_ORDER)) {
> +		copy_n = 1;
> +		heads = &heads[count - 1];
> +	}


Would it better to have a dedicated helper like 
vhost_add_used_in_order() here?


>   	start = vq->last_used_idx & (vq->num - 1);
>   	used = vq->used->ring + start;
> -	if (vhost_put_used(vq, heads, start, count)) {
> +	if (vhost_put_used(vq, heads, start, copy_n)) {
>   		vq_err(vq, "Failed to write used");
>   		return -EFAULT;
>   	}
> @@ -2388,7 +2398,7 @@ static int __vhost_add_used_n(struct vhost_virtqueue *vq,
>   		smp_wmb();
>   		/* Log used ring entry write. */
>   		log_used(vq, ((void __user *)used - (void __user *)vq->used),
> -			 count * sizeof *used);
> +			 copy_n * sizeof(*used));
>   	}
>   	old = vq->last_used_idx;
>   	new = (vq->last_used_idx += count);
> @@ -2410,7 +2420,7 @@ int vhost_add_used_n(struct vhost_virtqueue *vq, struct vring_used_elem *heads,
>   
>   	start = vq->last_used_idx & (vq->num - 1);
>   	n = vq->num - start;
> -	if (n < count) {
> +	if (n < count && !vhost_has_feature(vq, VIRTIO_F_IN_ORDER)) {


This seems strange, any reason for this? (Actually if we support 
in-order we only need one used slot which fit for the case here)

Thanks


>   		r = __vhost_add_used_n(vq, heads, n);
>   		if (r < 0)
>   			return r;

