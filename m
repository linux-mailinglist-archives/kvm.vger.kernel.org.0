Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B330667AEF
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 17:36:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231194AbjALQgv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 11:36:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233379AbjALQer (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 11:34:47 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AC80D44
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 08:31:46 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id az7so18636758wrb.5
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 08:31:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XTo+Yu4n2uxkjD6eK5gYJ7LJgX5rU1MQvheZGSgFJ0I=;
        b=mKIQ7RxnnoB8/0Cxj/NsrkZaZb97zPLamf+wnvrV8h3OCvZfCk7XZaSQGO/XjT0L/9
         8qFQn4z0NBj8vVSqj0pJl9u+N1R83VlRtdWEkVo4fApbkev+kTFS/2BUrcDMmE1OtlXT
         5NQVciC04rGHhWcl7MagydObu2yv+gZWvxSAPkVytaPyrrLEn/qUjMLFrQmOx7LZgwAh
         N/+9cC8sTUo+Wb6rL5IFbSq5NxwAFPxNrMK3DXPTAkPLPza3NnMUqrqtO7/lSXZ0PxCK
         onnTe0tLezvk5JpqIx+Uyuwol17xtjFJull9JtsFju+HNNU0TTIizFqfRt/FtkK8hMV2
         W9uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XTo+Yu4n2uxkjD6eK5gYJ7LJgX5rU1MQvheZGSgFJ0I=;
        b=WQNheafYsHYjZ3FEtmBSGE4owp2B3weR4DvLfymwpKk+tAT/FyW1UkeGMxEBx41nAd
         ebhAnWAP4B9dT1ZRyOp514wd1zLGHk6gvwn6dqxnKgQKjNNY5B1gGxtrxBdBY+EJ3UHt
         ovMvw8/7HsRQU8+J4tLy4v+TiisC5zvH42rtx3hyq6nGzQL7w+ekAM99imA9Y/OKWD8g
         QCdraE5bJZ+5S5DdaN5O7NtJjG9EK5qX2kMAYCZy6BB0vG5za7Bei+ZqthiJRFRHvNEo
         YTUZQmY09Iqduq84hzNi4z2s6WFklphiHTxoAbcTCVngGURaZlWr2ZzDHV3RjzaxhKs9
         eKeQ==
X-Gm-Message-State: AFqh2kpY4LGhbJ/YOuD2pdpcdHMVSNZClRzhp8lQw/80j2k2JeOMCU7C
        yTKVVOFYy+WUaXf8ZvGFfhk=
X-Google-Smtp-Source: AMrXdXv0gLr80LLsIuzGK6/c7GlSwLY7NWEIvA3QDs4WJgbdivGOUxaKH1oZHqAQEuIKRrMXX8tgzQ==
X-Received: by 2002:adf:ebcb:0:b0:2ab:78e2:864e with SMTP id v11-20020adfebcb000000b002ab78e2864emr18651335wrn.19.1673541104690;
        Thu, 12 Jan 2023 08:31:44 -0800 (PST)
Received: from [10.85.34.175] (54-240-197-225.amazon.com. [54.240.197.225])
        by smtp.gmail.com with ESMTPSA id y15-20020adffa4f000000b002bbec19c8acsm11516803wrr.64.2023.01.12.08.31.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Jan 2023 08:31:44 -0800 (PST)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <97dd2d4d-60cb-ce3d-e6a3-1703e2ce0cf7@xen.org>
Date:   Thu, 12 Jan 2023 16:31:42 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Reply-To: paul@xen.org
Subject: Re: [PATCH v2 2/4] KVM: x86/xen: Fix potential deadlock in
 kvm_xen_update_runstate_guest()
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Michal Luczaj <mhal@rbox.co>
References: <20230111180651.14394-1-dwmw2@infradead.org>
 <20230111180651.14394-2-dwmw2@infradead.org>
 <64cf2539-6f78-1ec4-15ad-8fc5ca8353c1@xen.org>
 <e0d7e7c164d06e17e50485ffba4331878005d726.camel@infradead.org>
 <886c13a1-3e37-7103-1caa-a14be2a50406@xen.org>
 <d639d941da26aa787178a7c698f66e6b33fdfd86.camel@infradead.org>
Organization: Xen Project
In-Reply-To: <d639d941da26aa787178a7c698f66e6b33fdfd86.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/01/2023 16:30, David Woodhouse wrote:
> On Thu, 2023-01-12 at 16:28 +0000, Paul Durrant wrote:
>> On 12/01/2023 16:27, David Woodhouse wrote:
>>> On Thu, 2023-01-12 at 16:17 +0000, Paul Durrant wrote:
>>>>>      
>>>>> @@ -309,7 +317,14 @@ static void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, bool atomic)
>>>>>                    * gpc1 lock to make lockdep shut up about it.
>>>>>                    */
>>>>>                   lock_set_subclass(&gpc1->lock.dep_map, 1, _THIS_IP_);
>>>>> -               read_lock(&gpc2->lock);
>>>>> +               if (atomic) {
>>>>> +                       if (!read_trylock(&gpc2->lock)) {
>>>>
>>>> You could avoid the nesting in this case with:
>>>>
>>>> if (atomic && !read_trylock(&gpc2->lock))
>>>>
>>>>> +                               read_unlock_irqrestore(&gpc1->lock, flags);
>>>>> +                               return;
>>>>> +                       }
>>>>> +               } else {
>>>>> +                       read_lock(&gpc2->lock);
>>>>> +               }
>>>
>>> Hm? Wouldn't it take the lock twice then? It'd still take the 'else' branch.
>>
>> Actually, yes... So much for hoping to make it look prettier.
> 
> I suppose we could avoid the extra indentation by making it
> 
> 
> 	if (atomic && !read_trylock(&gpc2->lock)) {
> 		read_unlock_irqrestore(&gpc1->lock, flags);
> 		return;
> 	} else if (!atomic) {
> 		read_lock(&gpc2->lock);
> 	}
> 
> Not sure it's much of an improvement in overall readability?

No. May as well leave it as-is.

   Paul
