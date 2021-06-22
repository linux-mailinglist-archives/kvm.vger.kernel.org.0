Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B45CB3AFE3A
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 09:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbhFVHsj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 03:48:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48278 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229853AbhFVHsi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Jun 2021 03:48:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624347982;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zdjETLWkSvHACmbeGDp6CeV86yBVSR0D+qi5o0JktrI=;
        b=a5cAsDqLh4KWniTTI2g3LdvD0xiCG2fVQmJ7fwJgrzpOAYNX1VDfuVwLrbWcOLyRna80lL
        b36zWz0/D+9AEGm71PMJjnZemfDuHeHM2IRbQTS5bqAMvo9QhnATBNgTXQnv8kMkXcjlkk
        A9WZkMjgD4yDboEercw9KW2wsbJCGAE=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-595-fs6rf4trM8SQCVyusaFsIw-1; Tue, 22 Jun 2021 03:46:20 -0400
X-MC-Unique: fs6rf4trM8SQCVyusaFsIw-1
Received: by mail-wr1-f70.google.com with SMTP id j2-20020a5d61820000b029011a6a8149b5so8947507wru.14
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 00:46:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zdjETLWkSvHACmbeGDp6CeV86yBVSR0D+qi5o0JktrI=;
        b=Ydn+Xjv3fLdXYm8VPkGdV3UsT7GOxOK4s2VNkO1xW9CV5YV86VWLXP9FUiEc9R6iVh
         JJbHQ7WTIHQAeuUNHVPxGkAcQFf8qJHEoBXowWyCT+JVVCGO32CDWQPXP3AeszY1XbZj
         rgWkDpTpdFFOfQbrkNGY8gkpVZY5V1319B9nAD2lf/sj4Hxf5dtUO62B3s9jTAVO3oXv
         QIwfeprhK9xCOuVOXF4luRK3tjbnL2S5h6w4+DMQMJJzmFZ9WBXPifUNiHQ5rhvT/8g/
         oXKYN76TFcANp1zLg1CqSt/ud3MEygOkwXCKeU1D6CrtLil6aaZthp1YMrtByvPHKT+A
         tyvQ==
X-Gm-Message-State: AOAM531xcYPIO0b/1f1DMZ4A0CSslMA63Cay2caEvT7nXggUTYKA7xjh
        YePlsbJOlOqRLg4uBeyFNn64YxxpMfNSZRTT5zWAr+x4iQW8ySPFrMMOPqlLZKhObbC9Zcd1xJY
        EW7GdFZEhOsT4
X-Received: by 2002:adf:df88:: with SMTP id z8mr3068981wrl.330.1624347979795;
        Tue, 22 Jun 2021 00:46:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz/4/G2PxtiD/pGBQ55k66zKhlU49Oijo/ZQjvEF9XdqD9q69xzWzjBdHStOlC86RQEXONIpQ==
X-Received: by 2002:adf:df88:: with SMTP id z8mr3068964wrl.330.1624347979649;
        Tue, 22 Jun 2021 00:46:19 -0700 (PDT)
Received: from thuth.remote.csb (pd9575f2f.dip0.t-ipconnect.de. [217.87.95.47])
        by smtp.gmail.com with ESMTPSA id w2sm17487101wrp.14.2021.06.22.00.46.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jun 2021 00:46:19 -0700 (PDT)
Subject: Re: [PATCH] KVM: s390: get rid of register asm usage
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20210621140356.1210771-1-hca@linux.ibm.com>
 <7edaf85c-810b-e0f9-5977-6e89270f0709@redhat.com>
 <ef34e1df-b56d-8123-60c7-e56d00cd01ca@de.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <67653df1-1a9e-c406-c45c-f30b69a2ee8a@redhat.com>
Date:   Tue, 22 Jun 2021 09:46:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <ef34e1df-b56d-8123-60c7-e56d00cd01ca@de.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/06/2021 09.43, Christian Borntraeger wrote:
> 
> 
> On 22.06.21 09:36, Thomas Huth wrote:
>> On 21/06/2021 16.03, Heiko Carstens wrote:
>>> Using register asm statements has been proven to be very error prone,
>>> especially when using code instrumentation where gcc may add function
>>> calls, which clobbers register contents in an unexpected way.
>>>
>>> Therefore get rid of register asm statements in kvm code, even though
>>> there is currently nothing wrong with them. This way we know for sure
>>> that this bug class won't be introduced here.
>>>
>>> Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
>>> Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
>>> ---
>>>   arch/s390/kvm/kvm-s390.c | 18 +++++++++---------
>>>   1 file changed, 9 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>>> index 1296fc10f80c..4b7b24f07790 100644
>>> --- a/arch/s390/kvm/kvm-s390.c
>>> +++ b/arch/s390/kvm/kvm-s390.c
>>> @@ -329,31 +329,31 @@ static void allow_cpu_feat(unsigned long nr)
>>>   static inline int plo_test_bit(unsigned char nr)
>>>   {
>>> -    register unsigned long r0 asm("0") = (unsigned long) nr | 0x100;
>>> +    unsigned long function = (unsigned long) nr | 0x100;
>>>       int cc;
>>>       asm volatile(
>>> +        "    lgr    0,%[function]\n"
>>>           /* Parameter registers are ignored for "test bit" */
>>>           "    plo    0,0,0,0(0)\n"
>>>           "    ipm    %0\n"
>>>           "    srl    %0,28\n"
>>>           : "=d" (cc)
>>> -        : "d" (r0)
>>> -        : "cc");
>>> +        : [function] "d" (function)
>>> +        : "cc", "0");
>>>       return cc == 0;
>>>   }
>>>   static __always_inline void __insn32_query(unsigned int opcode, u8 *query)
>>>   {
>>> -    register unsigned long r0 asm("0") = 0;    /* query function */
>>> -    register unsigned long r1 asm("1") = (unsigned long) query;
>>> -
>>>       asm volatile(
>>> -        /* Parameter regs are ignored */
>>> +        "    lghi    0,0\n"
>>> +        "    lgr    1,%[query]\n"
>>> +        /* Parameter registers are ignored */
>>>           "    .insn    rrf,%[opc] << 16,2,4,6,0\n"
>>>           :
>>> -        : "d" (r0), "a" (r1), [opc] "i" (opcode)
>>> -        : "cc", "memory");
>>> +        : [query] "d" ((unsigned long)query), [opc] "i" (opcode)
>>
>> Wouldn't it be better to keep the "a" constraint instead of "d" to avoid 
>> that the compiler ever passes the "query" value in r0 ?
>> Otherwise the query value might get trashed if it is passed in r0...
> 
> I first thought the same, but if you look closely the value is only used by 
> the lgr, to load
> the value finally into r1. So d is correct as lgr can take all registers.

But what about the "lghi    0,0" right in front of it? ... I've got the 
feeling that I'm missing something here...
Heiko, maybe you could at least swap the initialization of r0 and r1, then 
I'd feel a little bit better...

  Thomas

