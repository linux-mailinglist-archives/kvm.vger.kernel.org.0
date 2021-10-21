Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17CCA435B86
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 09:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbhJUHUI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 03:20:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25138 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229499AbhJUHUH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Oct 2021 03:20:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634800671;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=txStZY5R35mDYJwNjdQJx3UhhPXaKkP2XNluWEBvJcM=;
        b=BdN/mn+K6qGH8So67rZUrrOFmuoqcJhWjdC7HsJbto19SlNki7uXAvvVJZ3kOeardnaocP
        rP31dnyaFREaYF7og28tH6weo365UfcVuSE5rad1sBOM+Ge7AudzL3oAiZ3wn0FUmgo5Nb
        SCtBmtB5Uw/yS3LizDwATUT6548owZM=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-243-1dyKZFEmOHGz2eS934hEEQ-1; Thu, 21 Oct 2021 03:17:50 -0400
X-MC-Unique: 1dyKZFEmOHGz2eS934hEEQ-1
Received: by mail-ed1-f69.google.com with SMTP id u17-20020a50d511000000b003daa3828c13so23382607edi.12
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 00:17:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=txStZY5R35mDYJwNjdQJx3UhhPXaKkP2XNluWEBvJcM=;
        b=2nd89tZF1eE6YaniSCFPZuMy4HKmAPCXENK4EsFapv0HDvB6T6nUFguaWKEeWqelLX
         3YwemHwQdvI0pi6Mg225q2VuGr2pkFZ7lcNR6PKAikQSDdLQb2BsLidUvqmLLzZuigjD
         WKu3bmrm1Vp/tsyw3SBUNj3wQfwlKiw4K/Y3F9OcNSP1K3RtMMleOOnn4ec3BvKHqmPc
         AuEdubyFWchfyAidZCo2v4YptbIgTJYZpa+lq+wipRVPbXHhensRBd9QigrlbjJWuk44
         CeGIjnsvuJRfyRBpK18xfqIMAg87J/mHtEc6Es34j05kSYz0Bvmj3a+4pAjae6BrJt2T
         iAcg==
X-Gm-Message-State: AOAM530HSRb/oKlqOLeXTNtF/aISQNl2hEzQOvZVO3IWU6ZHto4lCWRy
        SwVrIW2f51Qzgsn6Ax6l4E2WjecIYk3qfJ44bb7Xgkm0x8manXBuEfgDib5AhqFU+akygaIJmPq
        uGad2F0tip207
X-Received: by 2002:a17:907:c27:: with SMTP id ga39mr5088582ejc.217.1634800669194;
        Thu, 21 Oct 2021 00:17:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwhmrCoC411wTu+aNZbQ18sWJwSgiHLabfxAnPEOAEwTPG+TU4N52Ah8B5Y3aDzzzJ30qjZdw==
X-Received: by 2002:a17:907:c27:: with SMTP id ga39mr5088563ejc.217.1634800668965;
        Thu, 21 Oct 2021 00:17:48 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id x16sm2074561ejj.8.2021.10.21.00.17.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Oct 2021 00:17:48 -0700 (PDT)
Message-ID: <62e5dd2a-929d-935d-829b-e2726d0d4f72@redhat.com>
Date:   Thu, 21 Oct 2021 09:17:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v2 kvm-unit-tests 2/2] replace tss_descr global with a
 function
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, zxwang42@gmail.com, marcorr@google.com,
        seanjc@google.com, jroedel@suse.de, varad.gautam@suse.com
References: <20211020192732.960782-1-pbonzini@redhat.com>
 <20211020192732.960782-3-pbonzini@redhat.com>
 <CALMp9eTbehPFGb2UTDiV8Q7zo6O9_Dq39=V_DdcQKG3-ev1_8w@mail.gmail.com>
 <0a87132a-f7ea-5483-dd9d-cb8c377af535@redhat.com>
 <CALMp9eRY_YYozTv0EZb5rbr27TJihaW3SpxV-Be=JJt2HYaTYQ@mail.gmail.com>
 <9f5e4bae-1400-3c49-d889-66de805bc1c2@redhat.com>
 <CALMp9eTjE1zbrun-bMSZTTodo1AnUpPvfhYgMoTkbfdAQz7mZg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CALMp9eTjE1zbrun-bMSZTTodo1AnUpPvfhYgMoTkbfdAQz7mZg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/10/21 00:01, Jim Mattson wrote:
> On Wed, Oct 20, 2021 at 2:31 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 20/10/21 23:18, Jim Mattson wrote:
>>>>>> -       vmcs_write(GUEST_LIMIT_TR, tss_descr.limit);
>>>>>> +       vmcs_write(GUEST_LIMIT_TR, 0x67);
>>>>> Isn't the limit still set to 0xFFFF in {cstart,cstart64}.S? And
>>>>> doesn't the VMware backdoor test assume there's room for an I/O
>>>>> permission bitmap?
>>>>>
>>>> Yes, but this is just for L2.  The host TR limit is restored to 0x67 on
>>>> every vmexit, and it seemed weird to run L1 and L2 with different limits.
>>> Perhaps you could change the limits in the GDT entries to match?
>>
>> So keep it 0x67 and adjust it to the size of the IOPM in the VMware
>> backdoor test?
> 
> Right. That would seem to achieve the greatest consistency.
> 

Let's just add a get_gdt_entry_limit that takes into account the G bit too.

Paolo

