Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2983C357DE3
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 10:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbhDHIPh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 04:15:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43105 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229602AbhDHIPd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 8 Apr 2021 04:15:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617869721;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ECoTbH7o9LRUh51pR4p9sKZq3aoS5gstK1YCFgpfQSc=;
        b=UdWWkefHb9AGCIDh5nIw4gmipFxTs6nvmXIEjXuE4d1AH2B+YG/uA0HS3po2tDQ5Nz+Z4P
        Umc86BP6njoSotLmkaGGoSCp/iLjCEvIJZvNknZS2Qsm4DMijDpGKokcx2Gjgc6ay4vM+P
        amVRk9YLbCYYqZppfFey5MhAfV1nGT0=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-483-cvJsiF2HP4WV8B2SRtD5lQ-1; Thu, 08 Apr 2021 04:15:20 -0400
X-MC-Unique: cvJsiF2HP4WV8B2SRtD5lQ-1
Received: by mail-ed1-f72.google.com with SMTP id w25so639772eds.16
        for <kvm@vger.kernel.org>; Thu, 08 Apr 2021 01:15:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ECoTbH7o9LRUh51pR4p9sKZq3aoS5gstK1YCFgpfQSc=;
        b=YPzlZBmy+NozvClza1/6LdorEk0CVtSEuYoVOMoSih4AfQmFQ/nXIb9fqEWjiU/FuB
         qez5fLBpE1ZrSgsUJT16t6N7mY0JUJHs6oErEcqNvRydmq5DZo4kXH4Y1CC6u4jZJeei
         6VQwiAvAVOwUUSLcYlZl1JZE/UUl4RaYPwQy96clGK/bsQES2oBo7GpDRCFZXjbF/sFQ
         wChOxNAkD/Pf+J1WaZBOBzP4B7zM/2KjoulYXnmWTl6Srpw8WidNSuT6B1RVfqPXnWDa
         +W35vgsQrDsski0SCxNt/3REad9R7xo8B6QcVI9ITApIdBTIGYd9RAzWRJRpQDksrzc9
         kW4w==
X-Gm-Message-State: AOAM532Qi0L7iYSJUhtGM764l3JdBJapHc82HEPBBTayFMID5+fPDVc7
        qoeqS7XURcrUu5BcEEd+c9bBydkcz5/d7D9VOkO3/CDlE9fDK4+VgZaVZx/BYvPpgyMaFOaZGxO
        9KZEsmUADsecm
X-Received: by 2002:a17:906:3952:: with SMTP id g18mr8795300eje.104.1617869718242;
        Thu, 08 Apr 2021 01:15:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxhyXYMZinDvRVyw5WxA8BlhYx5A8sIWRaAJtUqZGlQ+jt2l1v6VE6WZQNkXJPDdHi4P725KQ==
X-Received: by 2002:a17:906:3952:: with SMTP id g18mr8795285eje.104.1617869718100;
        Thu, 08 Apr 2021 01:15:18 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id mj3sm5262774ejb.3.2021.04.08.01.15.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Apr 2021 01:15:17 -0700 (PDT)
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com, dwmw@amazon.co.uk
References: <20210330165958.3094759-1-pbonzini@redhat.com>
 <20210330165958.3094759-2-pbonzini@redhat.com>
 <20210407174021.GA30046@fuller.cnet>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/2] KVM: x86: reduce pvclock_gtod_sync_lock critical
 sections
Message-ID: <51cae826-8973-5113-7e12-8163eab36cb7@redhat.com>
Date:   Thu, 8 Apr 2021 10:15:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210407174021.GA30046@fuller.cnet>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/04/21 19:40, Marcelo Tosatti wrote:
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index fe806e894212..0a83eff40b43 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -2562,10 +2562,12 @@ static void kvm_gen_update_masterclock(struct kvm *kvm)
>>   
>>   	kvm_hv_invalidate_tsc_page(kvm);
>>   
>> -	spin_lock(&ka->pvclock_gtod_sync_lock);
>>   	kvm_make_mclock_inprogress_request(kvm);
>> +
> Might be good to serialize against two kvm_gen_update_masterclock
> callers? Otherwise one caller could clear KVM_REQ_MCLOCK_INPROGRESS,
> while the other is still at pvclock_update_vm_gtod_copy().

Makes sense, but this stuff has always seemed unnecessarily complicated 
to me.

KVM_REQ_MCLOCK_INPROGRESS is only needed to kick running vCPUs out of 
the execution loop; clearing it in kvm_gen_update_masterclock is 
unnecessary, because KVM_REQ_CLOCK_UPDATE takes pvclock_gtod_sync_lock 
too and thus will already wait for pvclock_update_vm_gtod_copy to end.

I think it's possible to use a seqcount in KVM_REQ_CLOCK_UPDATE instead 
of KVM_REQ_MCLOCK_INPROGRESS.  Both cause the vCPUs to spin. I'll take a 
look.

Paolo

