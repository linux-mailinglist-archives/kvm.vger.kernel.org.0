Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 073FF7ADB4C
	for <lists+kvm@lfdr.de>; Mon, 25 Sep 2023 17:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232848AbjIYPYX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 11:24:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232819AbjIYPYV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 11:24:21 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 153D7124;
        Mon, 25 Sep 2023 08:24:11 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id 41be03b00d2f7-564b6276941so4804296a12.3;
        Mon, 25 Sep 2023 08:24:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695655450; x=1696260250; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T5ybRVZT1cW4nXmDPTqgLs+kI1T5x0D6yue8JAAazx0=;
        b=GlEJvuYidUIowHYkxFnZf3aVnId8iBj1SiIu2INuRIvbRuewcgxUiqatWFAG/Dsnk2
         Wu3YG5SnuDGxqj8OsJVGWvsTlsbzjDsjGM+aNZXmBe8l37xYrWfAu8tRuNb/ElzMfmyD
         28DNZjHAgldYyxNmsnQB5icLLYkOA77GVurvrxHKAkxvVj9C6dRGx9A69Wb2EJgf8+92
         Xpk3TCNRSWklb7GTz1ktjJvFNhXAQ+hlZr2r5Y7cZuKIxHb6N7T5lUXuSNoJRQJsnfDG
         LvUvHoc3tCGwQBeSQ+X4Z8SAIiwvM2C9y9Dd/50+wD54uN6UCZkLRgX+9zT06hvUi4dB
         3gVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695655450; x=1696260250;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=T5ybRVZT1cW4nXmDPTqgLs+kI1T5x0D6yue8JAAazx0=;
        b=EhvI8sRyKP14ld9VNUvGrD/ASRreQWXal8GlyOlGaoUP+Evv9H911wkGaRYx3TfMOl
         fK/kPA/su0kGBXAZzDYGWP8+cZHV6aF67gw7d1dYdoE/Rsud5lmyN3vEDSlxCr5rti1K
         QakQlOfUQTofnrZNjAoUsRJNIIqeCZ56Fgg1gXnrUzOS+iWXgCBn2J33Nq0thSPBMyUV
         x2FgNkLOVbodmy+R96VZjfDNvet8nMplltcUr8ONM+ZV+cajiMi9/OQnzIUXNfcL5Mmw
         qFZ7sjaQfHA6a48DgC3Q3aXAXohfF+RRz7nbAPXU1gyhlmbssAumty9Ah0vPUFBl+RjM
         S5vg==
X-Gm-Message-State: AOJu0YzDOUdb1Y7F3XeOGcd7LHJEVRjsxj08GnPPnsHEMJemWm8ARkMO
        kMv+g2CvG0E/3EUXID3O+i7H0qRD/yYwavQy
X-Google-Smtp-Source: AGHT+IGOAHinrrHklUFxRe2JSCVRJhN2lCgcrlmD+JUUOU2GLf1STbT0IVyftZCkx5guJVAvsv32wA==
X-Received: by 2002:a17:902:f682:b0:1c6:25b2:b71a with SMTP id l2-20020a170902f68200b001c625b2b71amr1289541plg.2.1695655450150;
        Mon, 25 Sep 2023 08:24:10 -0700 (PDT)
Received: from [192.168.255.10] ([101.80.250.8])
        by smtp.gmail.com with ESMTPSA id jh13-20020a170903328d00b001bc2831e1a8sm9017480plb.80.2023.09.25.08.24.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Sep 2023 08:24:09 -0700 (PDT)
Message-ID: <281006fa-2db6-123e-3fb8-f99acaab2fcb@gmail.com>
Date:   Mon, 25 Sep 2023 23:24:02 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.13.0
Subject: Re: [PATCH v2 2/2] KVM: irqbypass: Convert producers/consumers single
 linked list to XArray
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20230802051700.52321-1-likexu@tencent.com>
 <20230802051700.52321-3-likexu@tencent.com>
 <20230802123017.5695fe0a.alex.williamson@redhat.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20230802123017.5695fe0a.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/8/3 02:30, Alex Williamson wrote:
> On Wed,  2 Aug 2023 13:17:00 +0800
> Like Xu <like.xu.linux@gmail.com> wrote:
> 
>> From: Like Xu <likexu@tencent.com>
>>
>> Replace producers/consumers linked list with XArray. There are no changes
>> in functionality, but lookup performance has been improved.
>>
>> The producers and consumers in current IRQ bypass manager are stored in
>> simple linked lists, and a single mutex is held while traversing the lists
>> and connecting a consumer to a producer (and vice versa). With this design
>> and implementation, if there are a large number of KVM agents concurrently
>> creating irqfds and all requesting to register their irqfds in the global
>> consumers list, the global mutex contention will exponentially increase
>> the avg wait latency, which is no longer tolerable in modern systems with
>> a large number of CPU cores. For example:
>>
>> the wait time latency to acquire the mutex in a stress test where 174000
>> irqfds were created concurrently on an 2.70GHz ICX w/ 144 cores:
>>
>> - avg = 117.855314 ms
>> - min = 20 ns
>> - max = 11428.340858 ms
>>
>> To reduce latency introduced by the irq_bypass_register_consumer() in
>> the above usage scenario, the data structure XArray and its normal API
>> is applied to track the producers and consumers so that lookups don't
>> require a linear walk since the "tokens" used to match producers and
>> consumers are just kernel pointers.
>>
>> Thanks to the nature of XArray (more memory-efficient, parallelisable
>> and cache friendly), the latecny is significantly reduced (compared to
>> list and hlist proposal) under the same environment and testing:
>>
>> - avg = 314 ns
>> - min = 124 ns
>> - max = 47637 ns
>>
>> In this conversion, the non-NULL opaque token to match between producer
>> and consumer () is used as the XArray index. The list_for_each_entry() is
>> replaced by xa_load(), and list_add/del() is replaced by xa_store/erase().
>> The list_head member for linked list is removed, along with comments.
>>
>> Cc: Alex Williamson <alex.williamson@redhat.com>
>> Reported-by: Yong He <alexyonghe@tencent.com>
>> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217379
>> Suggested-by: Sean Christopherson <seanjc@google.com>
>> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
>> Signed-off-by: Like Xu <likexu@tencent.com>
>> ---
>>   include/linux/irqbypass.h |   8 +--
>>   virt/lib/irqbypass.c      | 127 +++++++++++++++++++-------------------
>>   2 files changed, 63 insertions(+), 72 deletions(-)
>>
>> diff --git a/include/linux/irqbypass.h b/include/linux/irqbypass.h
>> index 9bdb2a781841..dbcc1b4d0ccf 100644
>> --- a/include/linux/irqbypass.h
>> +++ b/include/linux/irqbypass.h
>> @@ -8,14 +8,12 @@
>>   #ifndef IRQBYPASS_H
>>   #define IRQBYPASS_H
>>   
>> -#include <linux/list.h>
>> -
>>   struct irq_bypass_consumer;
>>   
>>   /*
>>    * Theory of operation
>>    *
>> - * The IRQ bypass manager is a simple set of lists and callbacks that allows
>> + * The IRQ bypass manager is a simple set of xarrays and callbacks that allows
>>    * IRQ producers (ex. physical interrupt sources) to be matched to IRQ
>>    * consumers (ex. virtualization hardware that allows IRQ bypass or offload)
>>    * via a shared token (ex. eventfd_ctx).  Producers and consumers register
>> @@ -30,7 +28,6 @@ struct irq_bypass_consumer;
>>   
>>   /**
>>    * struct irq_bypass_producer - IRQ bypass producer definition
>> - * @node: IRQ bypass manager private list management
>>    * @token: opaque token to match between producer and consumer (non-NULL)
>>    * @irq: Linux IRQ number for the producer device
>>    * @add_consumer: Connect the IRQ producer to an IRQ consumer (optional)
>> @@ -43,7 +40,6 @@ struct irq_bypass_consumer;
>>    * for a physical device assigned to a VM.
>>    */
>>   struct irq_bypass_producer {
>> -	struct list_head node;
>>   	void *token;
>>   	int irq;
>>   	int (*add_consumer)(struct irq_bypass_producer *,
>> @@ -56,7 +52,6 @@ struct irq_bypass_producer {
>>   
>>   /**
>>    * struct irq_bypass_consumer - IRQ bypass consumer definition
>> - * @node: IRQ bypass manager private list management
>>    * @token: opaque token to match between producer and consumer (non-NULL)
>>    * @add_producer: Connect the IRQ consumer to an IRQ producer
>>    * @del_producer: Disconnect the IRQ consumer from an IRQ producer
>> @@ -69,7 +64,6 @@ struct irq_bypass_producer {
>>    * portions of the interrupt handling to the VM.
>>    */
>>   struct irq_bypass_consumer {
>> -	struct list_head node;
>>   	void *token;
>>   	int (*add_producer)(struct irq_bypass_consumer *,
>>   			    struct irq_bypass_producer *);
>> diff --git a/virt/lib/irqbypass.c b/virt/lib/irqbypass.c
>> index e0aabbbf27ec..3f8736951e92 100644
>> --- a/virt/lib/irqbypass.c
>> +++ b/virt/lib/irqbypass.c
>> @@ -15,15 +15,15 @@
>>    */
>>   
>>   #include <linux/irqbypass.h>
>> -#include <linux/list.h>
>>   #include <linux/module.h>
>>   #include <linux/mutex.h>
>> +#include <linux/xarray.h>
>>   
>>   MODULE_LICENSE("GPL v2");
>>   MODULE_DESCRIPTION("IRQ bypass manager utility module");
>>   
>> -static LIST_HEAD(producers);
>> -static LIST_HEAD(consumers);
>> +static DEFINE_XARRAY(producers);
>> +static DEFINE_XARRAY(consumers);
>>   static DEFINE_MUTEX(lock);
>>   
>>   /* @lock must be held when calling connect */
>> @@ -78,11 +78,12 @@ static void __disconnect(struct irq_bypass_producer *prod,
>>    * irq_bypass_register_producer - register IRQ bypass producer
>>    * @producer: pointer to producer structure
>>    *
>> - * Add the provided IRQ producer to the list of producers and connect
>> - * with any matching token found on the IRQ consumers list.
>> + * Add the provided IRQ producer to the xarray of producers and connect
>> + * with any matching token found on the IRQ consumers xarray.
>>    */
>>   int irq_bypass_register_producer(struct irq_bypass_producer *producer)
>>   {
>> +	unsigned long token = (unsigned long)producer->token;
>>   	struct irq_bypass_producer *tmp;
>>   	struct irq_bypass_consumer *consumer;
>>   	int ret;
>> @@ -97,24 +98,23 @@ int irq_bypass_register_producer(struct irq_bypass_producer *producer)
>>   
>>   	mutex_lock(&lock);
>>   
>> -	list_for_each_entry(tmp, &producers, node) {
>> -		if (tmp->token == producer->token || tmp == producer) {
>> -			ret = -EBUSY;
>> +	tmp = xa_load(&producers, token);
>> +	if (tmp || tmp == producer) {
>> +		ret = -EBUSY;
>> +		goto out_err;
>> +	}
>> +
>> +	ret = xa_err(xa_store(&producers, token, producer, GFP_KERNEL));
>> +	if (ret)
>> +		goto out_err;
>> +
>> +	consumer = xa_load(&consumers, token);
>> +	if (consumer) {
>> +		ret = __connect(producer, consumer);
>> +		if (ret)
>>   			goto out_err;
> 
> This doesn't match previous behavior, the producer is registered to the
> xarray regardless of the result of the connect operation and the caller
> cannot distinguish between failures.  The module reference is released
> regardless of xarray item.  Nak.

Hi Alex,

Thanks for your comments and indeed, the additional error throwing logic
breaks the caller's expectations as you said.

What if we use LIST as a fallback option for XARRAY? Specifically, when
xa_err(xa_store()) is true, then fallback to use LIST to check for
producers/consumers, and in most cases it still takes the XARRAY path:

     static DEFINE_XARRAY(xproducers);
     ...
     if (xa_err(xa_store(&xproducers, (unsigned long)producer->token,
			    producer, GFP_KERNEL)))
		list_add(&producer->node, &producers);
     ...

There will also be a LIST option on the lookup path.

The rough code already works, could we move in this direction (combining
XARRAY with LIST to hidden the memory allocation error from xa_store) ?

> 
>> -		}
>>   	}
>>   
>> -	list_for_each_entry(consumer, &consumers, node) {
>> -		if (consumer->token == producer->token) {
>> -			ret = __connect(producer, consumer);
>> -			if (ret)
>> -				goto out_err;
>> -			break;
>> -		}
>> -	}
>> -
>> -	list_add(&producer->node, &producers);
>> -
>>   	mutex_unlock(&lock);
>>   
>>   	return 0;
>> @@ -129,11 +129,12 @@ EXPORT_SYMBOL_GPL(irq_bypass_register_producer);
>>    * irq_bypass_unregister_producer - unregister IRQ bypass producer
>>    * @producer: pointer to producer structure
>>    *
>> - * Remove a previously registered IRQ producer from the list of producers
>> + * Remove a previously registered IRQ producer from the xarray of producers
>>    * and disconnect it from any connected IRQ consumer.
>>    */
>>   void irq_bypass_unregister_producer(struct irq_bypass_producer *producer)
>>   {
>> +	unsigned long token = (unsigned long)producer->token;
>>   	struct irq_bypass_producer *tmp;
>>   	struct irq_bypass_consumer *consumer;
>>   
>> @@ -143,24 +144,18 @@ void irq_bypass_unregister_producer(struct irq_bypass_producer *producer)
>>   	might_sleep();
>>   
>>   	if (!try_module_get(THIS_MODULE))
>> -		return; /* nothing in the list anyway */
>> +		return; /* nothing in the xarray anyway */
>>   
>>   	mutex_lock(&lock);
>>   
>> -	list_for_each_entry(tmp, &producers, node) {
>> -		if (tmp != producer)
>> -			continue;
>> +	tmp = xa_load(&producers, token);
>> +	if (tmp == producer) {
>> +		consumer = xa_load(&consumers, token);
>> +		if (consumer)
>> +			__disconnect(producer, consumer);
>>   
>> -		list_for_each_entry(consumer, &consumers, node) {
>> -			if (consumer->token == producer->token) {
>> -				__disconnect(producer, consumer);
>> -				break;
>> -			}
>> -		}
>> -
>> -		list_del(&producer->node);
>> +		xa_erase(&producers, token);
>>   		module_put(THIS_MODULE);
>> -		break;
>>   	}
>>   
>>   	mutex_unlock(&lock);
>> @@ -173,11 +168,12 @@ EXPORT_SYMBOL_GPL(irq_bypass_unregister_producer);
>>    * irq_bypass_register_consumer - register IRQ bypass consumer
>>    * @consumer: pointer to consumer structure
>>    *
>> - * Add the provided IRQ consumer to the list of consumers and connect
>> - * with any matching token found on the IRQ producer list.
>> + * Add the provided IRQ consumer to the xarray of consumers and connect
>> + * with any matching token found on the IRQ producer xarray.
>>    */
>>   int irq_bypass_register_consumer(struct irq_bypass_consumer *consumer)
>>   {
>> +	unsigned long token = (unsigned long)consumer->token;
>>   	struct irq_bypass_consumer *tmp;
>>   	struct irq_bypass_producer *producer;
>>   	int ret;
>> @@ -193,24 +189,23 @@ int irq_bypass_register_consumer(struct irq_bypass_consumer *consumer)
>>   
>>   	mutex_lock(&lock);
>>   
>> -	list_for_each_entry(tmp, &consumers, node) {
>> -		if (tmp->token == consumer->token || tmp == consumer) {
>> -			ret = -EBUSY;
>> +	tmp = xa_load(&consumers, token);
>> +	if (tmp || tmp == consumer) {
>> +		ret = -EBUSY;
>> +		goto out_err;
>> +	}
>> +
>> +	ret = xa_err(xa_store(&consumers, token, consumer, GFP_KERNEL));
>> +	if (ret)
>> +		goto out_err;
>> +
>> +	producer = xa_load(&producers, token);
>> +	if (producer) {
>> +		ret = __connect(producer, consumer);
>> +		if (ret)
>>   			goto out_err;
> 
> Same.  Thanks,
> 
> Alex
> 
>> -		}
>>   	}
>>   
>> -	list_for_each_entry(producer, &producers, node) {
>> -		if (producer->token == consumer->token) {
>> -			ret = __connect(producer, consumer);
>> -			if (ret)
>> -				goto out_err;
>> -			break;
>> -		}
>> -	}
>> -
>> -	list_add(&consumer->node, &consumers);
>> -
>>   	mutex_unlock(&lock);
>>   
>>   	return 0;
>> @@ -225,11 +220,12 @@ EXPORT_SYMBOL_GPL(irq_bypass_register_consumer);
>>    * irq_bypass_unregister_consumer - unregister IRQ bypass consumer
>>    * @consumer: pointer to consumer structure
>>    *
>> - * Remove a previously registered IRQ consumer from the list of consumers
>> + * Remove a previously registered IRQ consumer from the xarray of consumers
>>    * and disconnect it from any connected IRQ producer.
>>    */
>>   void irq_bypass_unregister_consumer(struct irq_bypass_consumer *consumer)
>>   {
>> +	unsigned long token = (unsigned long)consumer->token;
>>   	struct irq_bypass_consumer *tmp;
>>   	struct irq_bypass_producer *producer;
>>   
>> @@ -239,24 +235,18 @@ void irq_bypass_unregister_consumer(struct irq_bypass_consumer *consumer)
>>   	might_sleep();
>>   
>>   	if (!try_module_get(THIS_MODULE))
>> -		return; /* nothing in the list anyway */
>> +		return; /* nothing in the xarray anyway */
>>   
>>   	mutex_lock(&lock);
>>   
>> -	list_for_each_entry(tmp, &consumers, node) {
>> -		if (tmp != consumer)
>> -			continue;
>> +	tmp = xa_load(&consumers, token);
>> +	if (tmp == consumer) {
>> +		producer = xa_load(&producers, token);
>> +		if (producer)
>> +			__disconnect(producer, consumer);
>>   
>> -		list_for_each_entry(producer, &producers, node) {
>> -			if (producer->token == consumer->token) {
>> -				__disconnect(producer, consumer);
>> -				break;
>> -			}
>> -		}
>> -
>> -		list_del(&consumer->node);
>> +		xa_erase(&consumers, token);
>>   		module_put(THIS_MODULE);
>> -		break;
>>   	}
>>   
>>   	mutex_unlock(&lock);
>> @@ -264,3 +254,10 @@ void irq_bypass_unregister_consumer(struct irq_bypass_consumer *consumer)
>>   	module_put(THIS_MODULE);
>>   }
>>   EXPORT_SYMBOL_GPL(irq_bypass_unregister_consumer);
>> +
>> +static void __exit irqbypass_exit(void)
>> +{
>> +	xa_destroy(&producers);
>> +	xa_destroy(&consumers);
>> +}
>> +module_exit(irqbypass_exit);
> 
