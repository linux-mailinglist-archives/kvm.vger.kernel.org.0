Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B3B8377A33
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 04:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbhEJCoq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 9 May 2021 22:44:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32912 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229977AbhEJCop (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 9 May 2021 22:44:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620614620;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mulqbmYCJzxkz4O6WDiZBqOQpSapir8tgrTEx7eXEf0=;
        b=Axa8yYLqG9hpbZairLIdSziPh7fOqHaoghp9oEcTCEZ3EaoVoVMMDToXDzTFShwA6omjK2
        N9i6+/uMdil5RtrYRqPFMJH7wB+S4y07Uqqv3LNRjefR7yWWRKbMIWQnLLzvAWeDOc911V
        tf7rwGp4CT8CnRvj5anbqfKJmm++dyg=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-184-AraLuT_oOriz7mEuNTIK4Q-1; Sun, 09 May 2021 22:43:39 -0400
X-MC-Unique: AraLuT_oOriz7mEuNTIK4Q-1
Received: by mail-pf1-f198.google.com with SMTP id q11-20020aa7842b0000b029028ed2e63c85so9803198pfn.15
        for <kvm@vger.kernel.org>; Sun, 09 May 2021 19:43:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=mulqbmYCJzxkz4O6WDiZBqOQpSapir8tgrTEx7eXEf0=;
        b=fgPMC7KHwqUMYgNXBH4Tlt8ejtJbdd5COC+8RV8l9XNHGClqHIMZFYeAgZ2PaxqFLc
         vftSZOaOStWKnO1I5GbpLpzRQskj+jUaBFbksx5gCnPQDFvaoKF5LdBor3An0M349tUb
         jzJZSQ9ykPPkGkWkfCM4nAun+ZSPpSI9orP5D5LZzcyEufBmEtgOKOIVf++pPpOvGpRe
         n+qBVS8MG15GccjkBIXYFBQReFcEiXmI87Qygp0v098N3WLLHU+m0bST7azcy5peWxaW
         g36udYUK7H2L2TyYT2FUAOytJe3eVeieSqLbivbh21KffDktovYwD7DcNuYa6wGMyh6M
         96Cw==
X-Gm-Message-State: AOAM533Je1wGT8cu7iyQit4yayoG20mZPfcOytFCgJjqoCTotfQK9zd8
        DVRAvrDLmky5D2znComRUI1Y+8bmyrji90j3KGdBPpbzHHsKQstdZw6N/zi4SUYAbOZyNDYXHmC
        K8dmsHmZjFL6a
X-Received: by 2002:a17:90b:31cc:: with SMTP id jv12mr25766753pjb.33.1620614617984;
        Sun, 09 May 2021 19:43:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJybC1NO/4Q9cZqXH0xZRhpzh1PaT5pm26/xrlPVsxZSmPdWLQ9Q2jknen5avHzgs4cCcc2RFA==
X-Received: by 2002:a17:90b:31cc:: with SMTP id jv12mr25766727pjb.33.1620614617731;
        Sun, 09 May 2021 19:43:37 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c13sm11716971pjc.43.2021.05.09.19.43.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 May 2021 19:43:34 -0700 (PDT)
Subject: Re: [PATCH] Revert "irqbypass: do not start cons/prod when failed
 connect"
To:     Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com,
        maz@kernel.org, alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, cohuck@redhat.com,
        stable@vger.kernel.org
References: <20210508071152.722425-1-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <b309c02d-9570-6400-9a0c-63030aed7ff7@redhat.com>
Date:   Mon, 10 May 2021 10:43:23 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210508071152.722425-1-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


ÔÚ 2021/5/8 ÏÂÎç3:11, Zhu Lingshan Ð´µÀ:
> This reverts commit a979a6aa009f3c99689432e0cdb5402a4463fb88.
>
> The reverted commit may cause VM freeze on arm64 platform.
> Because on arm64 platform, stop a consumer will suspend the VM,
> the VM will freeze without a start consumer
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>


Acked-by: Jason Wang <jasowang@redhat.com>

Please resubmit with the formal process of stable (stable-kernel-rules.rst).

Thanks


> ---
>   virt/lib/irqbypass.c | 16 ++++++----------
>   1 file changed, 6 insertions(+), 10 deletions(-)
>
> diff --git a/virt/lib/irqbypass.c b/virt/lib/irqbypass.c
> index c9bb3957f58a..28fda42e471b 100644
> --- a/virt/lib/irqbypass.c
> +++ b/virt/lib/irqbypass.c
> @@ -40,21 +40,17 @@ static int __connect(struct irq_bypass_producer *prod,
>   	if (prod->add_consumer)
>   		ret = prod->add_consumer(prod, cons);
>   
> -	if (ret)
> -		goto err_add_consumer;
> -
> -	ret = cons->add_producer(cons, prod);
> -	if (ret)
> -		goto err_add_producer;
> +	if (!ret) {
> +		ret = cons->add_producer(cons, prod);
> +		if (ret && prod->del_consumer)
> +			prod->del_consumer(prod, cons);
> +	}
>   
>   	if (cons->start)
>   		cons->start(cons);
>   	if (prod->start)
>   		prod->start(prod);
> -err_add_producer:
> -	if (prod->del_consumer)
> -		prod->del_consumer(prod, cons);
> -err_add_consumer:
> +
>   	return ret;
>   }
>   

