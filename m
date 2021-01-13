Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58F722F4B1D
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 13:20:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726938AbhAMMPX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 07:15:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43621 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726935AbhAMMPX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Jan 2021 07:15:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610540036;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pa6oTq1DWmWoY5iW6Ce52RcsvRqVINx2r3W/w5rpK8U=;
        b=eIBOfxE7WwjQBIYm/LofczKvn8mIrGpxxb+vlD7lY46VGTM7z2nDLMhCELJibO41crnkBy
        KQhs3x6WX4Oh2doSkMQDQ+8jgjQb0JGqFpHs6z5ZB6ZplAG7RjDhpcAXzUHEMKPyVPiwjB
        2I60H2SqmEFcpqNprWxOM4WrklTKWj8=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-307-QeAjOxRcMH6LHjCdG8MBBg-1; Wed, 13 Jan 2021 07:13:54 -0500
X-MC-Unique: QeAjOxRcMH6LHjCdG8MBBg-1
Received: by mail-ej1-f72.google.com with SMTP id h4so801189eja.12
        for <kvm@vger.kernel.org>; Wed, 13 Jan 2021 04:13:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pa6oTq1DWmWoY5iW6Ce52RcsvRqVINx2r3W/w5rpK8U=;
        b=Tg/v3jSHlOOm0Tflwp99yLJ0/3GkHPBeU80fkcPrKlWiIgdAspQgPFoYPLM6p4zQqA
         opI7319klhd744lcaBDFNnFAJtqosQ9f/5QQsLvVCZTsw1X5ugIrl3SojxRsNCgEsKrr
         eB3wDWFT49F5YbbJ2Qzqv3/dRnvxx1x09iWqr3qfnF9ocLRtEU5fgpgB2p39DiBZqRl6
         8czpu+1RXIQhGQepVPDt2Suqku87vcpFJX8aS8I6HYVghkTOw/g5xj9OaKXibKAuZjRi
         1B6XOxanWLgvGZz9zOy8d1UatGO6wofUe2XaUt7XEfJNbgJmVG+pC5M7tyN83JOry1ue
         uLkA==
X-Gm-Message-State: AOAM533+EvvRgkVS8uKoR47uH+wiVo+qchyxWoqWV9fTvIDQYkWa/fD4
        W+/DrPUB0m+fGdl9QfuFmHSNpkhEwUl+Ie7rLswEXc4RJdhQC4sxLcqm5/+9HlrF+R0lJxYabF5
        otbJaVi6LfrrS
X-Received: by 2002:a50:b746:: with SMTP id g64mr1552509ede.33.1610540033675;
        Wed, 13 Jan 2021 04:13:53 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyxf/TAQFbbRBei+6F1Tplh7+VcxznLht/kvHUyJUvfntL3WN05iXPUN1vAVgAvXb7g0JnFDg==
X-Received: by 2002:a50:b746:: with SMTP id g64mr1552497ede.33.1610540033518;
        Wed, 13 Jan 2021 04:13:53 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id m7sm657212eji.118.2021.01.13.04.13.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Jan 2021 04:13:52 -0800 (PST)
Subject: Re: [RFC PATCH kvm-unit-tests 0/4] add generic stress test
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, mlevitsk@redhat.com
References: <20201223010850.111882-1-pbonzini@redhat.com>
 <X+pbZ061gTIbM2Ef@google.com>
 <d9a81441-9f15-45c2-69c5-6295f2891874@redhat.com>
 <X/4igkJA1ZY5rCk7@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e94c0b18-6067-a62b-44a2-c1eef9c7b3ff@redhat.com>
Date:   Wed, 13 Jan 2021 13:13:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <X/4igkJA1ZY5rCk7@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/01/21 23:28, Sean Christopherson wrote:
>>> What's the motivation for this type of test?  What class of bugs can it find
>>> that won't be found by existing kvm-unit-tests or simple boot tests?
>>
>> Mostly live migration tests.  For example, Maxim found a corner case in
>> KVM_GET_VCPU_EVENTS that affects both nVMX and nSVM live migration (patches
>> coming), and it is quite hard to turn it into a selftest because it requires
>> the ioctl to be invoked exactly when nested_run_pending==1.  Such a test
>> would allow stress-testing live migration without having to set up L1 and L2
>> virtual machine images.
> 
> Ah, so you run the stress test in L1 and then migrate L1?

Yes.  I can't exclude that it would find bugs without migration, but I 
hope we'd have stomped them by now.

> What's the biggest hurdle for doing this completely within the unit test
> framework?  Is teaching the framework to migrate a unit test the biggest pain?

Yes, pretty much.  The shell script framework would show its limits.

That said, I've always treated run_tests.sh as a utility more than an 
integral part of kvm-unit-tests.  There's nothing that prevents a more 
capable framework from parsing unittests.cfg.

Paolo

