Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DA507AE8C5
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 11:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234116AbjIZJSk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 05:18:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234030AbjIZJSj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 05:18:39 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AF1EE6;
        Tue, 26 Sep 2023 02:18:32 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1c61bde0b4bso30526405ad.3;
        Tue, 26 Sep 2023 02:18:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695719911; x=1696324711; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=f0hzL6Zy5n9QFfiT16VCPG8PZSz7n29TeCBk1lR8NhQ=;
        b=VbV/1ZBCDQHoE6gyQPPr1DQwm5sCSxS3HiPMTS0SwuQgLtou2nI1VaPLD1AepyQ9lw
         6Z9HGJodvk6z4Icpe8S3nyBdJdSACjUGGr/VF4kYfy11FOMpWlCoQNn6O5ffjoSvzarp
         cuCqUFqG5WsdNi7CHKYde1dA2JT5FZZ0zLg1gLFNP9yUobmoneRBkGDWgDp3ChDrWN0o
         bCyUOD2WuKyx/+dGictCt4cnCKjboxruW8RZBw9KnyU2kjucrbw/AzqdhptSjOSNkNiL
         WW5VDFO8PolxfLspW1AtEkoogqWSY7PdUSUVMlRUgiSxD73GYnYla5b6rUHniT8oEYfn
         8tgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695719911; x=1696324711;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f0hzL6Zy5n9QFfiT16VCPG8PZSz7n29TeCBk1lR8NhQ=;
        b=bSeP5B/OZv/HnJtKpio+l/hC6e6bUqxpJ4RXpXQUnq8Ch2RHPBaTteXwQGONvAva/q
         7VEu1dmTFhSBe2t/hl5XUug46+FqS5QzupYdFBOcKH7Mc5COLgzrRP+bpf5drc/WApUL
         t97zYeBVW6Dj9/7gxYRwkruX9zTkRw/d+UxeStuOezL33DKHqc6hZfvoxsdO0x39gckn
         d9PLSVeuW6VUEo5gRtlfTb014Xh7VHgewRVi2uvCXVGR5/jSh1qSrtXw63IWt70jGTRw
         4lqjmcs3W/9FKIwyfU+ewJCcZnvMGIVDkdl009xcbr46NgJuZQ6UtQeDDrTitTxGbz2I
         OlKA==
X-Gm-Message-State: AOJu0Yzcgxx+nTFfWME5hLasPZbznYuDdVC9athyK0Xa4/uxYF1TKsBz
        oqm1kk0cm2cg4Iku4cuNp0E=
X-Google-Smtp-Source: AGHT+IGUMWA3khfXJLe1ZUSZnRXX+YsdEtkxhUqu5kNXfMHR0XZRokyrrZoQ6rd6SRCRgKpFhfGahA==
X-Received: by 2002:a17:903:2784:b0:1c6:19db:7b69 with SMTP id jw4-20020a170903278400b001c619db7b69mr4803321plb.66.1695719911541;
        Tue, 26 Sep 2023 02:18:31 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id a5-20020a170902ee8500b001c62d63b817sm1244142pld.179.2023.09.26.02.18.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Sep 2023 02:18:30 -0700 (PDT)
Message-ID: <2b86e5d5-0861-9074-ab40-df111f54c7f0@gmail.com>
Date:   Tue, 26 Sep 2023 17:18:24 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH v2 2/2] KVM: irqbypass: Convert producers/consumers single
 linked list to XArray
Content-Language: en-US
From:   Like Xu <like.xu.linux@gmail.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
References: <20230802051700.52321-1-likexu@tencent.com>
 <20230802051700.52321-3-likexu@tencent.com>
 <20230802123017.5695fe0a.alex.williamson@redhat.com>
 <281006fa-2db6-123e-3fb8-f99acaab2fcb@gmail.com>
In-Reply-To: <281006fa-2db6-123e-3fb8-f99acaab2fcb@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/9/2023 11:24 pm, Like Xu wrote:
>>> @@ -97,24 +98,23 @@ int irq_bypass_register_producer(struct 
>>> irq_bypass_producer *producer)
>>>       mutex_lock(&lock);
>>> -    list_for_each_entry(tmp, &producers, node) {
>>> -        if (tmp->token == producer->token || tmp == producer) {
>>> -            ret = -EBUSY;
>>> +    tmp = xa_load(&producers, token);
>>> +    if (tmp || tmp == producer) {
>>> +        ret = -EBUSY;
>>> +        goto out_err;
>>> +    }
>>> +
>>> +    ret = xa_err(xa_store(&producers, token, producer, GFP_KERNEL));
>>> +    if (ret)
>>> +        goto out_err;
>>> +
>>> +    consumer = xa_load(&consumers, token);
>>> +    if (consumer) {
>>> +        ret = __connect(producer, consumer);
>>> +        if (ret)
>>>               goto out_err;
>>
>> This doesn't match previous behavior, the producer is registered to the
>> xarray regardless of the result of the connect operation and the caller
>> cannot distinguish between failures.  The module reference is released
>> regardless of xarray item.  Nak.
> 
> Hi Alex,
> 
> Thanks for your comments and indeed, the additional error throwing logic
> breaks the caller's expectations as you said.
> 
> What if we use LIST as a fallback option for XARRAY? Specifically, when
> xa_err(xa_store()) is true, then fallback to use LIST to check for
> producers/consumers, and in most cases it still takes the XARRAY path:
> 
>      static DEFINE_XARRAY(xproducers);
>      ...
>      if (xa_err(xa_store(&xproducers, (unsigned long)producer->token,
>                  producer, GFP_KERNEL)))
>          list_add(&producer->node, &producers);
>      ...
> 
> There will also be a LIST option on the lookup path.
> 
> The rough code already works, could we move in this direction (combining
> XARRAY with LIST to hidden the memory allocation error from xa_store) ?

For better discussion and further improvement, here's the draft code combining
xarray and list, using both xarray and list to store producers and consumers,
but with xarray preferred for queries:

diff --git a/virt/lib/irqbypass.c b/virt/lib/irqbypass.c
index e0aabbbf27ec..7cc30d699ece 100644
--- a/virt/lib/irqbypass.c
+++ b/virt/lib/irqbypass.c
@@ -18,12 +18,15 @@
  #include <linux/list.h>
  #include <linux/module.h>
  #include <linux/mutex.h>
+#include <linux/xarray.h>

  MODULE_LICENSE("GPL v2");
  MODULE_DESCRIPTION("IRQ bypass manager utility module");

  static LIST_HEAD(producers);
  static LIST_HEAD(consumers);
+static DEFINE_XARRAY(xproducers);
+static DEFINE_XARRAY(xconsumers);
  static DEFINE_MUTEX(lock);

  /* @lock must be held when calling connect */
@@ -74,6 +77,117 @@ static void __disconnect(struct irq_bypass_producer *prod,
  		prod->start(prod);
  }

+#define CHECK_TOKEN	BIT_ULL(0)
+#define CHECK_POINTER	BIT_ULL(1)
+
+static inline bool
+producer_already_exist(struct irq_bypass_producer *producer, u64 flags)
+{
+	struct irq_bypass_producer *tmp;
+
+	if (((flags & CHECK_POINTER) && xa_load(&xproducers,
+						(unsigned long)producer)) ||
+	    ((flags & CHECK_TOKEN) && xa_load(&xproducers,
+					      (unsigned long)producer->token)))
+		return true;
+
+	list_for_each_entry(tmp, &producers, node) {
+		if (((flags & CHECK_POINTER) && tmp == producer) ||
+		    ((flags & CHECK_TOKEN) && tmp->token == producer->token))
+			return true;
+	}
+
+	return false;
+}
+
+static inline bool
+consumer_already_exist(struct irq_bypass_consumer *consumer, u64 flags)
+{
+	struct irq_bypass_consumer *tmp;
+
+	if (((flags & CHECK_POINTER) && xa_load(&xconsumers,
+						(unsigned long)consumer)) ||
+	    ((flags & CHECK_TOKEN) && xa_load(&xconsumers,
+					      (unsigned long)consumer->token)))
+		return true;
+
+	list_for_each_entry(tmp, &consumers, node) {
+		if (((flags & CHECK_POINTER) && tmp == consumer) ||
+		    ((flags & CHECK_TOKEN) && tmp->token == consumer->token))
+			return true;
+	}
+
+	return false;
+}
+
+static inline struct irq_bypass_producer *get_producer_by_token(void *token)
+{
+	struct irq_bypass_producer *tmp;
+
+	tmp = xa_load(&xproducers, (unsigned long)token);
+	if (tmp)
+		return tmp;
+
+	list_for_each_entry(tmp, &producers, node) {
+		if (tmp->token == token)
+			return tmp;
+	}
+
+	return NULL;
+}
+
+static inline struct irq_bypass_consumer *get_consumer_by_token(void *token)
+{
+	struct irq_bypass_consumer *tmp;
+
+	tmp = xa_load(&xconsumers, (unsigned long)token);
+	if (tmp)
+		return tmp;
+
+	list_for_each_entry(tmp, &consumers, node) {
+		if (tmp->token == token)
+			return tmp;
+	}
+
+	return NULL;
+}
+
+static inline void add_irq_bypass_producer(struct irq_bypass_producer *producer)
+{
+	xa_store(&xproducers, (unsigned long)producer->token,
+		 producer, GFP_KERNEL);
+	xa_store(&xproducers, (unsigned long)producer,
+		 producer, GFP_KERNEL);
+
+	list_add(&producer->node, &producers);
+}
+
+static inline void del_irq_bypass_producer(struct irq_bypass_producer *producer)
+{
+	xa_erase(&xproducers, (unsigned long)producer->token);
+	xa_erase(&xproducers, (unsigned long)producer);
+
+	list_del(&producer->node);
+}
+
+static inline void add_irq_bypass_consumer(struct irq_bypass_consumer *consumer)
+{
+	xa_store(&xconsumers, (unsigned long)consumer->token,
+		 consumer, GFP_KERNEL);
+	xa_store(&xconsumers, (unsigned long)consumer,
+		 consumer, GFP_KERNEL);
+
+	list_add(&consumer->node, &consumers);
+}
+
+static inline void del_irq_bypass_consumer(struct irq_bypass_consumer *consumer)
+{
+	xa_erase(&xconsumers, (unsigned long)consumer->token);
+	xa_erase(&xconsumers, (unsigned long)consumer);
+
+	list_del(&consumer->node);
+}
+
  /**
   * irq_bypass_register_producer - register IRQ bypass producer
   * @producer: pointer to producer structure
@@ -83,7 +197,6 @@ static void __disconnect(struct irq_bypass_producer *prod,
   */
  int irq_bypass_register_producer(struct irq_bypass_producer *producer)
  {
-	struct irq_bypass_producer *tmp;
  	struct irq_bypass_consumer *consumer;
  	int ret;

@@ -97,23 +210,19 @@ int irq_bypass_register_producer(struct irq_bypass_producer 
*producer)

  	mutex_lock(&lock);

-	list_for_each_entry(tmp, &producers, node) {
-		if (tmp->token == producer->token || tmp == producer) {
-			ret = -EBUSY;
+	if (producer_already_exist(producer, CHECK_TOKEN | CHECK_POINTER)) {
+		ret = -EBUSY;
+		goto out_err;
+	}
+
+	consumer = get_consumer_by_token(producer->token);
+	if (consumer) {
+		ret = __connect(producer, consumer);
+		if (ret)
  			goto out_err;
-		}
  	}

-	list_for_each_entry(consumer, &consumers, node) {
-		if (consumer->token == producer->token) {
-			ret = __connect(producer, consumer);
-			if (ret)
-				goto out_err;
-			break;
-		}
-	}
-
-	list_add(&producer->node, &producers);
+	add_irq_bypass_producer(producer);

  	mutex_unlock(&lock);

@@ -134,7 +243,6 @@ EXPORT_SYMBOL_GPL(irq_bypass_register_producer);
   */
  void irq_bypass_unregister_producer(struct irq_bypass_producer *producer)
  {
-	struct irq_bypass_producer *tmp;
  	struct irq_bypass_consumer *consumer;

  	if (!producer->token)
@@ -147,20 +255,13 @@ void irq_bypass_unregister_producer(struct 
irq_bypass_producer *producer)

  	mutex_lock(&lock);

-	list_for_each_entry(tmp, &producers, node) {
-		if (tmp != producer)
-			continue;
+	if (producer_already_exist(producer, CHECK_POINTER)) {
+		consumer = get_consumer_by_token(producer->token);
+		if (consumer)
+			__disconnect(producer, consumer);

-		list_for_each_entry(consumer, &consumers, node) {
-			if (consumer->token == producer->token) {
-				__disconnect(producer, consumer);
-				break;
-			}
-		}
-
-		list_del(&producer->node);
+		del_irq_bypass_producer(producer);
  		module_put(THIS_MODULE);
-		break;
  	}

  	mutex_unlock(&lock);
@@ -178,7 +279,6 @@ EXPORT_SYMBOL_GPL(irq_bypass_unregister_producer);
   */
  int irq_bypass_register_consumer(struct irq_bypass_consumer *consumer)
  {
-	struct irq_bypass_consumer *tmp;
  	struct irq_bypass_producer *producer;
  	int ret;

@@ -193,23 +293,19 @@ int irq_bypass_register_consumer(struct 
irq_bypass_consumer *consumer)

  	mutex_lock(&lock);

-	list_for_each_entry(tmp, &consumers, node) {
-		if (tmp->token == consumer->token || tmp == consumer) {
-			ret = -EBUSY;
+	if (consumer_already_exist(consumer, CHECK_TOKEN | CHECK_POINTER)) {
+		ret = -EBUSY;
+		goto out_err;
+	}
+
+	producer = get_producer_by_token(consumer->token);
+	if (producer) {
+		ret = __connect(producer, consumer);
+		if (ret)
  			goto out_err;
-		}
  	}

-	list_for_each_entry(producer, &producers, node) {
-		if (producer->token == consumer->token) {
-			ret = __connect(producer, consumer);
-			if (ret)
-				goto out_err;
-			break;
-		}
-	}
-
-	list_add(&consumer->node, &consumers);
+	add_irq_bypass_consumer(consumer);

  	mutex_unlock(&lock);

@@ -230,7 +326,6 @@ EXPORT_SYMBOL_GPL(irq_bypass_register_consumer);
   */
  void irq_bypass_unregister_consumer(struct irq_bypass_consumer *consumer)
  {
-	struct irq_bypass_consumer *tmp;
  	struct irq_bypass_producer *producer;

  	if (!consumer->token)
@@ -243,20 +338,13 @@ void irq_bypass_unregister_consumer(struct 
irq_bypass_consumer *consumer)

  	mutex_lock(&lock);

-	list_for_each_entry(tmp, &consumers, node) {
-		if (tmp != consumer)
-			continue;
+	if (consumer_already_exist(consumer, CHECK_POINTER)) {
+		producer = get_producer_by_token(consumer->token);
+		if (producer)
+			__disconnect(producer, consumer);

-		list_for_each_entry(producer, &producers, node) {
-			if (producer->token == consumer->token) {
-				__disconnect(producer, consumer);
-				break;
-			}
-		}
-
-		list_del(&consumer->node);
+		del_irq_bypass_consumer(consumer);
  		module_put(THIS_MODULE);
-		break;
  	}

  	mutex_unlock(&lock);
@@ -264,3 +352,10 @@ void irq_bypass_unregister_consumer(struct 
irq_bypass_consumer *consumer)
  	module_put(THIS_MODULE);
  }
  EXPORT_SYMBOL_GPL(irq_bypass_unregister_consumer);
+
+static void __exit irqbypass_exit(void)
+{
+	xa_destroy(&xproducers);
+	xa_destroy(&xconsumers);
+}
+module_exit(irqbypass_exit);
-- 
2.42.0

