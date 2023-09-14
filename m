Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13CA57A0501
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 15:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238742AbjINNHg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 09:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238671AbjINNH1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 09:07:27 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A3351FD5;
        Thu, 14 Sep 2023 06:07:23 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-401f68602a8so9748265e9.3;
        Thu, 14 Sep 2023 06:07:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694696841; x=1695301641; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Tej9b0LMdUKBSRZxH07jBOdxaJ6MquCE3RokLEVjR7k=;
        b=rjoLWTXLiEKOlMZrYLKwMuRNi4V41FSZiO/Fyr1dsj/eufqx8ATVWylFkkOHpiJPg2
         dCA56AD1LdD5T/VjMMCipoxTSB547oS64J6jxrpjXEtjacwQIN+7Cz6tVqqBVNEbWuEA
         XyIx7qOWHodsnYhrZOckIOErmGbO6eFwhjgGkuojVFZOBvYo0hl9jP2pNsNmKLIw4fkD
         PWR0m++xId7DOEDcbF8XIO9Dgr/ONtE3aMxorWoCjndLyB2QSjooJTaHK5Gc0Ck4OUs7
         tS9xJk5Ecfi47JVvFmsYTRi4nErjrn4dgYz2NA5MA0wWN7BGY1GYyqQo961RsXJSf0/3
         tGgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694696841; x=1695301641;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tej9b0LMdUKBSRZxH07jBOdxaJ6MquCE3RokLEVjR7k=;
        b=EB/k0W3pjh2TTOf/f3FeQM1wZ+nmAtVaXfziggUe3P3xJFmjuJMxItz+zZ4zjXkbyc
         w8X3lhUkvecgWHlsyQ9lyRBc3mw9GIhkbCU4Qihn3rtnwz2VzZNiexnuYRZhmTU3xsvB
         zpNcEMEKF6mNEHYri2CSDYqZmpXzQ4UNPyZ2cDIZfQSN9g4ky3V0HEMVF/jMt1EoH52v
         pcoDNTzpsDOhIoxhTl37qKqXbht4ObGgK3WeSgaIyByweDAEDnKA94EUeEJvyPhnQsCN
         xu6iC8bacjXBRpOmx1dZsaBDME2KAa5V5Zh5FI2UcRedN3V1VMvhJ/krcKLEgvYoaWJL
         tN1Q==
X-Gm-Message-State: AOJu0YyXFuS9vax5HbpopifHZni6uxU39enYvKpWKZeoaEZXn0aEfop5
        nFQInG0OpjdChRljf/dWEPs=
X-Google-Smtp-Source: AGHT+IHUqdikwusaZ197Z7lAgvVUm0b2rKPwxGuDzuK0CfVPCbOiJ1CSjghXQW5EGPQAtAcuiR1wqg==
X-Received: by 2002:a05:600c:2307:b0:402:e6a2:c8c7 with SMTP id 7-20020a05600c230700b00402e6a2c8c7mr4838002wmo.7.1694696841293;
        Thu, 14 Sep 2023 06:07:21 -0700 (PDT)
Received: from [192.168.5.8] (54-240-197-235.amazon.com. [54.240.197.235])
        by smtp.gmail.com with ESMTPSA id u8-20020a5d6ac8000000b0031416362e23sm1759075wrw.3.2023.09.14.06.07.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Sep 2023 06:07:20 -0700 (PDT)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <75b00614-a3a5-44de-5a14-3b7c7c7eceb0@xen.org>
Date:   Thu, 14 Sep 2023 15:07:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Reply-To: paul@xen.org
Subject: Re: [PATCH 2/8] KVM: pfncache: add a mark-dirty helper
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Paul Durrant <pdurrant@amazon.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
References: <20230914084946.200043-1-paul@xen.org>
 <20230914084946.200043-3-paul@xen.org>
 <87b3f6713a7c6aa57adc89b6c47be3e1511f66ca.camel@infradead.org>
 <69b2a8ae-fcae-75b8-4b2a-ca75bbd273f0@xen.org>
 <a689f4847d2272a75d89364723bab7a29508f646.camel@infradead.org>
Organization: Xen Project
In-Reply-To: <a689f4847d2272a75d89364723bab7a29508f646.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/09/2023 13:39, David Woodhouse wrote:
> On Thu, 2023-09-14 at 11:34 +0200, Paul Durrant wrote:
>> On 14/09/2023 10:21, David Woodhouse wrote:
>>> On Thu, 2023-09-14 at 08:49 +0000, Paul Durrant wrote:
>>>> --- a/arch/x86/kvm/xen.c
>>>> +++ b/arch/x86/kvm/xen.c
>>>> @@ -430,14 +430,13 @@ static void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, bool atomic)
>>>>                   smp_wmb();
>>>>           }
>>>>    
>>>> -       if (user_len2)
>>>> +       if (user_len2) {
>>>> +               kvm_gpc_mark_dirty(gpc2);
>>>>                   read_unlock(&gpc2->lock);
>>>> +       }
>>>>    
>>>> +       kvm_gpc_mark_dirty(gpc1);
>>>>           read_unlock_irqrestore(&gpc1->lock, flags);
>>>> -
>>>> -       mark_page_dirty_in_slot(v->kvm, gpc1->memslot, gpc1->gpa >> PAGE_SHIFT);
>>>> -       if (user_len2)
>>>> -               mark_page_dirty_in_slot(v->kvm, gpc2->memslot, gpc2->gpa >> PAGE_SHIFT);
>>>>    }
>>>>    
>>>>    void kvm_xen_update_runstate(struct kvm_vcpu *v, int state)
>>>
>>> ISTR there was a reason why the mark_page_dirty_in_slot() was called
>>> *after* unlocking. Although now I say it, that seems wrong... is that
>>> because the spinlock is only protecting the uHVA→kHVA mapping, while
>>> the memslot/gpa are going to remain valid even after unlock, because
>>> those are protected by sRCU?
>>
>> Without the lock you could see an inconsistent GPA and memslot so I
>> think you could theoretically calculate a bogus rel_gfn and walk off the
>> end of the dirty bitmap. Hence moving the call inside the lock while I
>> was in the neighbourhood seemed like a good idea. I could call it out in
>> the commit comment if you'd like.
> 
> Yeah, I can't see a reason why it needs to be outside the lock, and as
> you note, there really is a reason why it should be *inside*. Whatever
> reason there was, it either disappeared in the revisions of the gpc
> patch set or it was stupidity on my part in the first place.
> 
> So yeah, let it move inside the lock, call that out in the commit
> message (I did note some of the other commits could have used a 'No
> functional change intended' too, FWIW), and

Ack. Will do.

> 
> Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>
> 

Thanks.

   Paul

