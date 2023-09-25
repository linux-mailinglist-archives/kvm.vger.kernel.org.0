Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 648597AD28C
	for <lists+kvm@lfdr.de>; Mon, 25 Sep 2023 09:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232565AbjIYH76 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 03:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232560AbjIYH7y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 03:59:54 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E20ED3;
        Mon, 25 Sep 2023 00:59:48 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-690d2441b95so4309504b3a.1;
        Mon, 25 Sep 2023 00:59:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695628787; x=1696233587; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3SOX1sUAjrW5/F0GPz8qWm4h1iURYcsVmq2K+RtdMls=;
        b=UktWqUJIZF7NCG5qgnZX9pzpTBm/pRAcf2tWVVfzQz6r5ogKO1r47p6eRcACIRqmfu
         qBhogYLilnnMTfHjLZFc3qvPzNUb9NyarvOTsxuKvW99LChry84ZAUBCV2PFkdJrBAbs
         gumNjGVSjuGtEewRMUTdsPEP9sAbkn1ZEXTjkUZ66hE8z4WESfEysxJV8tRDkOtC23Y+
         C70bIZKfTcHeDR+SnKrNkWW3LHBGW+iKNaytJOZghE5r+lTwKkswCTfD2LxIBfn9JMTw
         hArckVaOnRAjCNki7JR3dxPpprKovzNsAon4ZpKf/HYZZj/DnssjFy4KgAYXG8wH/584
         ENFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695628787; x=1696233587;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3SOX1sUAjrW5/F0GPz8qWm4h1iURYcsVmq2K+RtdMls=;
        b=i2p+FvDVgLG6JKrqNBdkKbrtZ4IRRTSKlQ/O6QxYi6Q//Y2X7EyU+KSna+9AGZJm8o
         GyebVHdjK5PoRA6dhoqUtznTwz1qHRGMdMsx7FzwRZLb02L6T8981m4BF3B730piAygH
         W21FF+2Hg6dlNYpztm+13a6MBAuHaDWYqW8wgyc/OVqZIq/S6O0YgMgCzLOgUrJ+brT6
         1U6SNpA/FFqYZQrJsM3tf7irCp035ObXp100AuKOhtqNXiZbxB7aNR+KlA+vSb1rWzrR
         0pIRTQt6CNXZRaFbqmhn0PXqKNydB4hmRBxOkMhbjqpdyYB18Iexwa0F2Romquk9izxW
         H3BA==
X-Gm-Message-State: AOJu0YzDyv7ci9tjmv+MPg0bMs5L/6RoMbUpR6jCGPeU2jXNczlUy7Bq
        2b56cDHRCmtCzI0pFIT1WIGNFm0xESvuFw==
X-Google-Smtp-Source: AGHT+IHiiJtXf62jyqVrSAoePbXVSHPYxOp2sL8v+5R8QIiO3ljI3O9aVrHY0Q0gdKELtvZqetOYtA==
X-Received: by 2002:a05:6a20:431a:b0:15c:8555:a21c with SMTP id h26-20020a056a20431a00b0015c8555a21cmr9019477pzk.8.1695628787450;
        Mon, 25 Sep 2023 00:59:47 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id i14-20020aa787ce000000b006900cb919b8sm7438827pfo.53.2023.09.25.00.59.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Sep 2023 00:59:47 -0700 (PDT)
Message-ID: <74dc2c4a-077d-a538-4c4d-9f2141702ada@gmail.com>
Date:   Mon, 25 Sep 2023 15:59:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH v2 1/2] KVM: eventfd: Fix NULL deref irqbypass producer
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20230802051700.52321-1-likexu@tencent.com>
 <20230802051700.52321-2-likexu@tencent.com> <ZN0XXKezcXjv1GWH@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <ZN0XXKezcXjv1GWH@google.com>
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

Hi Alex, what do you think of Sean's proposal diff below ?

By the way, could anyone to accept patch 1/2, thanks.

On 17/8/2023 2:37 am, Sean Christopherson wrote:
> On Wed, Aug 02, 2023, Like Xu wrote:
>> From: Like Xu <likexu@tencent.com>
>>
>> Adding guard logic to make irq_bypass_register/unregister_producer()
>> looks for the producer entry based on producer pointer itself instead
>> of pure token matching.
>>
>> As was attempted commit 4f3dbdf47e15 ("KVM: eventfd: fix NULL deref
>> irqbypass consumer"), two different producers may occasionally have two
>> identical eventfd's. In this case, the later producer may unregister
>> the previous one after the registration fails (since they share the same
>> token), then NULL deref incurres in the path of deleting producer from
>> the producers list.
>>
>> Registration should also fail if a registered producer changes its
>> token and registers again via the same producer pointer.
>>
>> Cc: Alex Williamson <alex.williamson@redhat.com>
>> Signed-off-by: Like Xu <likexu@tencent.com>
>> Reviewed-by: Alex Williamson <alex.williamson@redhat.com>
>> ---
>>   virt/lib/irqbypass.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/virt/lib/irqbypass.c b/virt/lib/irqbypass.c
>> index 28fda42e471b..e0aabbbf27ec 100644
>> --- a/virt/lib/irqbypass.c
>> +++ b/virt/lib/irqbypass.c
>> @@ -98,7 +98,7 @@ int irq_bypass_register_producer(struct irq_bypass_producer *producer)
>>   	mutex_lock(&lock);
>>   
>>   	list_for_each_entry(tmp, &producers, node) {
>> -		if (tmp->token == producer->token) {
>> +		if (tmp->token == producer->token || tmp == producer) {
>>   			ret = -EBUSY;
>>   			goto out_err;
>>   		}
>> @@ -148,7 +148,7 @@ void irq_bypass_unregister_producer(struct irq_bypass_producer *producer)
>>   	mutex_lock(&lock);
>>   
>>   	list_for_each_entry(tmp, &producers, node) {
>> -		if (tmp->token != producer->token)
>> +		if (tmp != producer)
> 
> What are the rules for using these APIs?  E.g. is doing unregister without
> first doing a register actually allowed?  Ditto for having multiple in-flight
> calls to (un)register the exact same producer or consumer.
> 
> E.g. can we do something like the below, and then remove the list iteration to
> find the passed in pointer (which is super odd IMO).  Obviously not a blocker
> for this patch, but it seems like we could achieve a simpler and more performant
> implementation if we first sanitize the rules and the usage.
> 
> diff --git a/virt/lib/irqbypass.c b/virt/lib/irqbypass.c
> index 28fda42e471b..be0ba4224a23 100644
> --- a/virt/lib/irqbypass.c
> +++ b/virt/lib/irqbypass.c
> @@ -90,6 +90,9 @@ int irq_bypass_register_producer(struct irq_bypass_producer *producer)
>          if (!producer->token)
>                  return -EINVAL;
>   
> +       if (WARN_ON_ONCE(producer->node.prev && !list_empty(&producer->node)))
> +               return -EINVAL;
> +
>          might_sleep();
>   
>          if (!try_module_get(THIS_MODULE))
> @@ -140,6 +143,9 @@ void irq_bypass_unregister_producer(struct irq_bypass_producer *producer)
>          if (!producer->token)
>                  return;
>   
> +       if (WARN_ON_ONCE(!producer->node.prev || list_empty(&producer->node)))
> +               return;
> +
>          might_sleep();
>   
>          if (!try_module_get(THIS_MODULE))
> 
