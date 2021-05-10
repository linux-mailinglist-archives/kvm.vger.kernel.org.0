Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC87377B41
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 06:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbhEJEfp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 00:35:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45100 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229533AbhEJEfp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 May 2021 00:35:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620621280;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5uXhSn/w6CZf/GcmcktyqqIlCH6uf+CBfk9ICAipjiM=;
        b=OboNuuOZRZHL8sNJC95aOMWlFV6tpbKlugYyeU5zJ0GtxsTSPZXmsYVGW8IAyDPblCfTsL
        TqkqwTmzxkwMEKP5glUzr4gAlWKF45W2U4XN3Fq9imy2//G7LPkVlgRDlnCUxRVS573b/R
        rbmlclDWauIl1EOK2HLf81weeWRS5fY=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-z1uHHYlvOkKoi4FzZSrMKg-1; Mon, 10 May 2021 00:34:38 -0400
X-MC-Unique: z1uHHYlvOkKoi4FzZSrMKg-1
Received: by mail-pg1-f198.google.com with SMTP id r16-20020a63a5500000b02902155900cc63so5745187pgu.9
        for <kvm@vger.kernel.org>; Sun, 09 May 2021 21:34:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=5uXhSn/w6CZf/GcmcktyqqIlCH6uf+CBfk9ICAipjiM=;
        b=moxDoEyxp3wMrn0TE66iti9XI+wgI/9Did9cscMTh+TDZeSFDL9jETDQvuazU/R/kQ
         MznbxA/eHIx0JG6frAR+JTY9MPz/ieIVWozeKpajOz6z6tpOM0SzKN+cPzy391XrrYJa
         nYHaOamoUUuavpFTxuJcgU9HbJYSjyVzNwBMi9SGNU8TjCksdyp6W9YNIIDBZSNtLlUx
         2ZIaHvgnjqOU/QuBO5IJvLFuS9+moaXbd/NhrrAFSBPCD6WFODLAQfdIl5lwcBxAaAny
         NtXsfX9wbYeoxvz6lnmXakkpneMbPLfanC9G/D+RMb0MSZF/iSOqqvvAuxUrhajgLPg9
         KqMg==
X-Gm-Message-State: AOAM530JvV3Vbvq1sDzGDuTNCxXv1e1dicFGkf4K17kzLTJBGbMM0/EO
        Gjq4KH0ZOq22LRbji7KAWlhwTI1QM9w4ZRnBVP1JZuZTNKnWg3GSbNfhVkizaDMDV74NJ0QhLUB
        C9+46sB3lpzrL
X-Received: by 2002:a63:4512:: with SMTP id s18mr23457199pga.275.1620621277260;
        Sun, 09 May 2021 21:34:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJygmSy3Fdas8cpmiqmQfqfLtuCoMdKjuVFbGs0UxKU35ro+F/44i5Shmvs9MQ/0/XJwJ1PxMg==
X-Received: by 2002:a63:4512:: with SMTP id s18mr23457181pga.275.1620621277002;
        Sun, 09 May 2021 21:34:37 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h36sm10483782pgh.63.2021.05.09.21.34.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 May 2021 21:34:35 -0700 (PDT)
Subject: Re: [PATCH] Revert "irqbypass: do not start cons/prod when failed
 connect"
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>, mst@redhat.com,
        maz@kernel.org, alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, cohuck@redhat.com,
        stable@vger.kernel.org
References: <20210508071152.722425-1-lingshan.zhu@intel.com>
 <b309c02d-9570-6400-9a0c-63030aed7ff7@redhat.com>
 <a659fc6f-2c7a-23d2-9c34-0044d5a31861@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <e5d63867-7a4a-963f-9fbd-741ccd3ec360@redhat.com>
Date:   Mon, 10 May 2021 12:34:25 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <a659fc6f-2c7a-23d2-9c34-0044d5a31861@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2021/5/10 上午11:00, Zhu, Lingshan 写道:
>
>
> On 5/10/2021 10:43 AM, Jason Wang wrote:
>>
>> 在 2021/5/8 下午3:11, Zhu Lingshan 写道:
>>> This reverts commit a979a6aa009f3c99689432e0cdb5402a4463fb88.
>>>
>>> The reverted commit may cause VM freeze on arm64 platform.
>>> Because on arm64 platform, stop a consumer will suspend the VM,
>>> the VM will freeze without a start consumer
>>>
>>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>>
>>
>> Acked-by: Jason Wang <jasowang@redhat.com>
>>
>> Please resubmit with the formal process of stable 
>> (stable-kernel-rules.rst).
> sure, I will re-submit it to stable kernel once it is merged into 
> Linus tree.
>
> Thanks


I think it's better to resubmit (option 1), see how 
stable-kernel-rules.rst said:

""

:ref:`option_1` is **strongly** preferred, is the easiest and most common.
:ref:`option_2` and :ref:`option_3` are more useful if the patch isn't 
deemed
worthy at the time it is applied to a public git tree (for instance, because
it deserves more regression testing first).

"""

Thanks


>>
>> Thanks
>>
>>
>>> ---
>>>   virt/lib/irqbypass.c | 16 ++++++----------
>>>   1 file changed, 6 insertions(+), 10 deletions(-)
>>>
>>> diff --git a/virt/lib/irqbypass.c b/virt/lib/irqbypass.c
>>> index c9bb3957f58a..28fda42e471b 100644
>>> --- a/virt/lib/irqbypass.c
>>> +++ b/virt/lib/irqbypass.c
>>> @@ -40,21 +40,17 @@ static int __connect(struct irq_bypass_producer 
>>> *prod,
>>>       if (prod->add_consumer)
>>>           ret = prod->add_consumer(prod, cons);
>>>   -    if (ret)
>>> -        goto err_add_consumer;
>>> -
>>> -    ret = cons->add_producer(cons, prod);
>>> -    if (ret)
>>> -        goto err_add_producer;
>>> +    if (!ret) {
>>> +        ret = cons->add_producer(cons, prod);
>>> +        if (ret && prod->del_consumer)
>>> +            prod->del_consumer(prod, cons);
>>> +    }
>>>         if (cons->start)
>>>           cons->start(cons);
>>>       if (prod->start)
>>>           prod->start(prod);
>>> -err_add_producer:
>>> -    if (prod->del_consumer)
>>> -        prod->del_consumer(prod, cons);
>>> -err_add_consumer:
>>> +
>>>       return ret;
>>>   }
>>
>

