Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 380097C51F4
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 13:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345956AbjJKLYy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 07:24:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231264AbjJKLYx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 07:24:53 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C25C9D;
        Wed, 11 Oct 2023 04:24:51 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id 98e67ed59e1d1-2792d70ae25so4528736a91.0;
        Wed, 11 Oct 2023 04:24:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697023491; x=1697628291; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=UrMtZvEsIM+qKqq1v34BDDfsjEsf34YJyrr2R+6FsmM=;
        b=Cr3jM2VfD5SQzp+IN1eRzbV4Z/5uwVQvoK+vqnaMgYi6K1aIMpV387rP2iohqlYI5w
         YI8Ga9Ex1ZOGAkck6EHzGP6hxhQ4HoqpxbGRn4X0dIPIj8eE2+QZH2LnTZkw+Fe8y7h8
         BFg5nFbyZvrxETNXhx9Ottp/88aEafjM5hpyr6PZvqv9725suU/YikOo81zHZv7zJFkG
         WB5glqqPu74Rx9qHJci/+ny2d+hpumFgqTxQwJOqTtl6UdHgrNIRjGgvAdkPnjA0POIp
         gjs+7P/yqSaR3/qk6l1hRn2T6Y8xQQaLkMb/vlGPbC/NE/AMy8i8xyQf64aprPLsGMfj
         hEUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697023491; x=1697628291;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UrMtZvEsIM+qKqq1v34BDDfsjEsf34YJyrr2R+6FsmM=;
        b=xEm2+ur7tvzgrcpgEb3Mify9k6VRlmXnuGbRDONVnGKz1wbIXXsmF2cXDgn+4WZ9Tb
         OpU1DEDSNMXGXofODNAvUiip45kVysjDVgJdqe6QIBp9XhzZOlhaghYws/OtPQDPi8+f
         yz2dHcufvVhTxxA2VTAwePhvujI/nn9yjZGmVPnmFj09XP+ntmqKmRCMVW+HQkl+6e7r
         r1aHcr2OLVxx/xkBBCxyyNbI8k2yibEyK2BOlPHMh+vh7jna1CixbHH7mAfp3XoxYvTs
         FVw7eRcki3t74dVRMiHDtZRJXodPmBGZona03N6e8iJGXjH+snqYhZKHYNSF7kUCnpRd
         PhcQ==
X-Gm-Message-State: AOJu0Yz//jJvkjdpPE24C1FH53zQxDGdB7qGsLGBS+PUXVYF77OVcgw3
        MrSxWqA9qR79ofizRe7p+EI=
X-Google-Smtp-Source: AGHT+IHC6XfX60I13FofBvy8p/fbIs7X1SxXCLME7BIlHne/6/vkcQ7kCGv7Si8nefTBCoTtP2AvDA==
X-Received: by 2002:a17:90b:38cb:b0:268:1745:b61 with SMTP id nn11-20020a17090b38cb00b0026817450b61mr17286766pjb.34.1697023490505;
        Wed, 11 Oct 2023 04:24:50 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id 30-20020a17090a195e00b002635db431a0sm12727573pjh.45.2023.10.11.04.24.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Oct 2023 04:24:49 -0700 (PDT)
Message-ID: <ce19d884-050c-6874-600d-837da7b69f0f@gmail.com>
Date:   Wed, 11 Oct 2023 19:24:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH v2 2/2] KVM: irqbypass: Convert producers/consumers single
 linked list to XArray
From:   Like Xu <like.xu.linux@gmail.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
References: <20230802051700.52321-1-likexu@tencent.com>
 <20230802051700.52321-3-likexu@tencent.com>
 <20230802123017.5695fe0a.alex.williamson@redhat.com>
 <281006fa-2db6-123e-3fb8-f99acaab2fcb@gmail.com>
 <2b86e5d5-0861-9074-ab40-df111f54c7f0@gmail.com>
Content-Language: en-US
In-Reply-To: <2b86e5d5-0861-9074-ab40-df111f54c7f0@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all, do we have any negative comments on this issue ?
This register path could be a performance bottleneck in serverless scenarios.
Your comments are much appreciated, thanks!

On 26/9/2023 5:18 pm, Like Xu wrote:
> On 25/9/2023 11:24 pm, Like Xu wrote:
>>>> @@ -97,24 +98,23 @@ int irq_bypass_register_producer(struct 
>>>> irq_bypass_producer *producer)
>>>>       mutex_lock(&lock);
>>>> -    list_for_each_entry(tmp, &producers, node) {
>>>> -        if (tmp->token == producer->token || tmp == producer) {
>>>> -            ret = -EBUSY;
>>>> +    tmp = xa_load(&producers, token);
>>>> +    if (tmp || tmp == producer) {
>>>> +        ret = -EBUSY;
>>>> +        goto out_err;
>>>> +    }
>>>> +
>>>> +    ret = xa_err(xa_store(&producers, token, producer, GFP_KERNEL));
>>>> +    if (ret)
>>>> +        goto out_err;
>>>> +
>>>> +    consumer = xa_load(&consumers, token);
>>>> +    if (consumer) {
>>>> +        ret = __connect(producer, consumer);
>>>> +        if (ret)
>>>>               goto out_err;
>>>
>>> This doesn't match previous behavior, the producer is registered to the
>>> xarray regardless of the result of the connect operation and the caller
>>> cannot distinguish between failures.  The module reference is released
>>> regardless of xarray item.  Nak.
>>
>> Hi Alex,
>>
>> Thanks for your comments and indeed, the additional error throwing logic
>> breaks the caller's expectations as you said.
>>
>> What if we use LIST as a fallback option for XARRAY? Specifically, when
>> xa_err(xa_store()) is true, then fallback to use LIST to check for
>> producers/consumers, and in most cases it still takes the XARRAY path:
>>
>>      static DEFINE_XARRAY(xproducers);
>>      ...
>>      if (xa_err(xa_store(&xproducers, (unsigned long)producer->token,
>>                  producer, GFP_KERNEL)))
>>          list_add(&producer->node, &producers);
>>      ...
>>
>> There will also be a LIST option on the lookup path.
>>
>> The rough code already works, could we move in this direction (combining
>> XARRAY with LIST to hidden the memory allocation error from xa_store) ?
> 
> For better discussion and further improvement, here's the draft code combining
> xarray and list, using both xarray and list to store producers and consumers,
> but with xarray preferred for queries:
> 
> diff --git a/virt/lib/irqbypass.c b/virt/lib/irqbypass.c
> index e0aabbbf27ec..7cc30d699ece 100644
> --- a/virt/lib/irqbypass.c
> +++ b/virt/lib/irqbypass.c
> @@ -18,12 +18,15 @@
>   #include <linux/list.h>
>   #include <linux/module.h>
>   #include <linux/mutex.h>
> +#include <linux/xarray.h>
> 
>   MODULE_LICENSE("GPL v2");
>   MODULE_DESCRIPTION("IRQ bypass manager utility module");
> 
>   static LIST_HEAD(producers);
>   static LIST_HEAD(consumers);
> +static DEFINE_XARRAY(xproducers);
> +static DEFINE_XARRAY(xconsumers);
>   static DEFINE_MUTEX(lock);
> 
>   /* @lock must be held when calling connect */
> @@ -74,6 +77,117 @@ static void __disconnect(struct irq_bypass_producer *prod,
>           prod->start(prod);
>   }
> 
> +#define CHECK_TOKEN    BIT_ULL(0)
> +#define CHECK_POINTER    BIT_ULL(1)
> +
> +static inline bool
> +producer_already_exist(struct irq_bypass_producer *producer, u64 flags)
> +{
> +    struct irq_bypass_producer *tmp;
> +
> +    if (((flags & CHECK_POINTER) && xa_load(&xproducers,
> +                        (unsigned long)producer)) ||
> +        ((flags & CHECK_TOKEN) && xa_load(&xproducers,
> +                          (unsigned long)producer->token)))
> +        return true;
> +
> +    list_for_each_entry(tmp, &producers, node) {
> +        if (((flags & CHECK_POINTER) && tmp == producer) ||
> +            ((flags & CHECK_TOKEN) && tmp->token == producer->token))
> +            return true;
> +    }
> +
> +    return false;
> +}
> +
> +static inline bool
> +consumer_already_exist(struct irq_bypass_consumer *consumer, u64 flags)
> +{
> +    struct irq_bypass_consumer *tmp;
> +
> +    if (((flags & CHECK_POINTER) && xa_load(&xconsumers,
> +                        (unsigned long)consumer)) ||
> +        ((flags & CHECK_TOKEN) && xa_load(&xconsumers,
> +                          (unsigned long)consumer->token)))
> +        return true;
> +
> +    list_for_each_entry(tmp, &consumers, node) {
> +        if (((flags & CHECK_POINTER) && tmp == consumer) ||
> +            ((flags & CHECK_TOKEN) && tmp->token == consumer->token))
> +            return true;
> +    }
> +
> +    return false;
> +}
> +
> +static inline struct irq_bypass_producer *get_producer_by_token(void *token)
> +{
> +    struct irq_bypass_producer *tmp;
> +
> +    tmp = xa_load(&xproducers, (unsigned long)token);
> +    if (tmp)
> +        return tmp;
> +
> +    list_for_each_entry(tmp, &producers, node) {
> +        if (tmp->token == token)
> +            return tmp;
> +    }
> +
> +    return NULL;
> +}
> +
> +static inline struct irq_bypass_consumer *get_consumer_by_token(void *token)
> +{
> +    struct irq_bypass_consumer *tmp;
> +
> +    tmp = xa_load(&xconsumers, (unsigned long)token);
> +    if (tmp)
> +        return tmp;
> +
> +    list_for_each_entry(tmp, &consumers, node) {
> +        if (tmp->token == token)
> +            return tmp;
> +    }
> +
> +    return NULL;
> +}
> +
> +static inline void add_irq_bypass_producer(struct irq_bypass_producer *producer)
> +{
> +    xa_store(&xproducers, (unsigned long)producer->token,
> +         producer, GFP_KERNEL);
> +    xa_store(&xproducers, (unsigned long)producer,
> +         producer, GFP_KERNEL);
> +
> +    list_add(&producer->node, &producers);
> +}
> +
> +static inline void del_irq_bypass_producer(struct irq_bypass_producer *producer)
> +{
> +    xa_erase(&xproducers, (unsigned long)producer->token);
> +    xa_erase(&xproducers, (unsigned long)producer);
> +
> +    list_del(&producer->node);
> +}
> +
> +static inline void add_irq_bypass_consumer(struct irq_bypass_consumer *consumer)
> +{
> +    xa_store(&xconsumers, (unsigned long)consumer->token,
> +         consumer, GFP_KERNEL);
> +    xa_store(&xconsumers, (unsigned long)consumer,
> +         consumer, GFP_KERNEL);
> +
> +    list_add(&consumer->node, &consumers);
> +}
> +
> +static inline void del_irq_bypass_consumer(struct irq_bypass_consumer *consumer)
> +{
> +    xa_erase(&xconsumers, (unsigned long)consumer->token);
> +    xa_erase(&xconsumers, (unsigned long)consumer);
> +
> +    list_del(&consumer->node);
> +}
> +
>   /**
>    * irq_bypass_register_producer - register IRQ bypass producer
>    * @producer: pointer to producer structure
> @@ -83,7 +197,6 @@ static void __disconnect(struct irq_bypass_producer *prod,
>    */
>   int irq_bypass_register_producer(struct irq_bypass_producer *producer)
>   {
> -    struct irq_bypass_producer *tmp;
>       struct irq_bypass_consumer *consumer;
>       int ret;
> 
> @@ -97,23 +210,19 @@ int irq_bypass_register_producer(struct irq_bypass_producer 
> *producer)
> 
>       mutex_lock(&lock);
> 
> -    list_for_each_entry(tmp, &producers, node) {
> -        if (tmp->token == producer->token || tmp == producer) {
> -            ret = -EBUSY;
> +    if (producer_already_exist(producer, CHECK_TOKEN | CHECK_POINTER)) {
> +        ret = -EBUSY;
> +        goto out_err;
> +    }
> +
> +    consumer = get_consumer_by_token(producer->token);
> +    if (consumer) {
> +        ret = __connect(producer, consumer);
> +        if (ret)
>               goto out_err;
> -        }
>       }
> 
> -    list_for_each_entry(consumer, &consumers, node) {
> -        if (consumer->token == producer->token) {
> -            ret = __connect(producer, consumer);
> -            if (ret)
> -                goto out_err;
> -            break;
> -        }
> -    }
> -
> -    list_add(&producer->node, &producers);
> +    add_irq_bypass_producer(producer);
> 
>       mutex_unlock(&lock);
> 
> @@ -134,7 +243,6 @@ EXPORT_SYMBOL_GPL(irq_bypass_register_producer);
>    */
>   void irq_bypass_unregister_producer(struct irq_bypass_producer *producer)
>   {
> -    struct irq_bypass_producer *tmp;
>       struct irq_bypass_consumer *consumer;
> 
>       if (!producer->token)
> @@ -147,20 +255,13 @@ void irq_bypass_unregister_producer(struct 
> irq_bypass_producer *producer)
> 
>       mutex_lock(&lock);
> 
> -    list_for_each_entry(tmp, &producers, node) {
> -        if (tmp != producer)
> -            continue;
> +    if (producer_already_exist(producer, CHECK_POINTER)) {
> +        consumer = get_consumer_by_token(producer->token);
> +        if (consumer)
> +            __disconnect(producer, consumer);
> 
> -        list_for_each_entry(consumer, &consumers, node) {
> -            if (consumer->token == producer->token) {
> -                __disconnect(producer, consumer);
> -                break;
> -            }
> -        }
> -
> -        list_del(&producer->node);
> +        del_irq_bypass_producer(producer);
>           module_put(THIS_MODULE);
> -        break;
>       }
> 
>       mutex_unlock(&lock);
> @@ -178,7 +279,6 @@ EXPORT_SYMBOL_GPL(irq_bypass_unregister_producer);
>    */
>   int irq_bypass_register_consumer(struct irq_bypass_consumer *consumer)
>   {
> -    struct irq_bypass_consumer *tmp;
>       struct irq_bypass_producer *producer;
>       int ret;
> 
> @@ -193,23 +293,19 @@ int irq_bypass_register_consumer(struct 
> irq_bypass_consumer *consumer)
> 
>       mutex_lock(&lock);
> 
> -    list_for_each_entry(tmp, &consumers, node) {
> -        if (tmp->token == consumer->token || tmp == consumer) {
> -            ret = -EBUSY;
> +    if (consumer_already_exist(consumer, CHECK_TOKEN | CHECK_POINTER)) {
> +        ret = -EBUSY;
> +        goto out_err;
> +    }
> +
> +    producer = get_producer_by_token(consumer->token);
> +    if (producer) {
> +        ret = __connect(producer, consumer);
> +        if (ret)
>               goto out_err;
> -        }
>       }
> 
> -    list_for_each_entry(producer, &producers, node) {
> -        if (producer->token == consumer->token) {
> -            ret = __connect(producer, consumer);
> -            if (ret)
> -                goto out_err;
> -            break;
> -        }
> -    }
> -
> -    list_add(&consumer->node, &consumers);
> +    add_irq_bypass_consumer(consumer);
> 
>       mutex_unlock(&lock);
> 
> @@ -230,7 +326,6 @@ EXPORT_SYMBOL_GPL(irq_bypass_register_consumer);
>    */
>   void irq_bypass_unregister_consumer(struct irq_bypass_consumer *consumer)
>   {
> -    struct irq_bypass_consumer *tmp;
>       struct irq_bypass_producer *producer;
> 
>       if (!consumer->token)
> @@ -243,20 +338,13 @@ void irq_bypass_unregister_consumer(struct 
> irq_bypass_consumer *consumer)
> 
>       mutex_lock(&lock);
> 
> -    list_for_each_entry(tmp, &consumers, node) {
> -        if (tmp != consumer)
> -            continue;
> +    if (consumer_already_exist(consumer, CHECK_POINTER)) {
> +        producer = get_producer_by_token(consumer->token);
> +        if (producer)
> +            __disconnect(producer, consumer);
> 
> -        list_for_each_entry(producer, &producers, node) {
> -            if (producer->token == consumer->token) {
> -                __disconnect(producer, consumer);
> -                break;
> -            }
> -        }
> -
> -        list_del(&consumer->node);
> +        del_irq_bypass_consumer(consumer);
>           module_put(THIS_MODULE);
> -        break;
>       }
> 
>       mutex_unlock(&lock);
> @@ -264,3 +352,10 @@ void irq_bypass_unregister_consumer(struct 
> irq_bypass_consumer *consumer)
>       module_put(THIS_MODULE);
>   }
>   EXPORT_SYMBOL_GPL(irq_bypass_unregister_consumer);
> +
> +static void __exit irqbypass_exit(void)
> +{
> +    xa_destroy(&xproducers);
> +    xa_destroy(&xconsumers);
> +}
> +module_exit(irqbypass_exit);
