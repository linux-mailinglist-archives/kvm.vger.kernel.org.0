Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D63330C502
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 17:11:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236098AbhBBQIv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 11:08:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43861 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235907AbhBBQGk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Feb 2021 11:06:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612281911;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GoHqkcd1GD6lYKRpDHWZ6PFpXaEZ93xMiO7nY5L+AQ8=;
        b=hS7D3dmQ3tw+TPruj+kZh94GIrwyrGQnF5OnglzdroQMi3xy+ZrKH7zVsvRotmhMU5eb83
        aU+NxAAvbJcyV8U9IwGmVihw1Kd9fD2BL1yM40ys+ujcFRQ0WQK7CHmCt4ary4XNtQxI5E
        rb7HLvV9ZSoumlQGLnXkpI3O4li4spc=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-24-DUgBMbeqOs63s-feAYRYpA-1; Tue, 02 Feb 2021 11:05:08 -0500
X-MC-Unique: DUgBMbeqOs63s-feAYRYpA-1
Received: by mail-ed1-f72.google.com with SMTP id t9so9812543edd.3
        for <kvm@vger.kernel.org>; Tue, 02 Feb 2021 08:05:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GoHqkcd1GD6lYKRpDHWZ6PFpXaEZ93xMiO7nY5L+AQ8=;
        b=puCD0mrgYKOZdgZSjg+Hg+vUFjyeV9P77LfD8KFswARWiB0ty15HDOeBKUDhqRYwiV
         eAecbwhLLXkSS3+qsg/hhqhU2DphWat1HMx3lUZn4wW5j7Wi7CV/jGUaaE0zxDd1kMAu
         pZe9ii++ZGs/NmED5MGhGWbLP0ymJ8jbRuOKISbmHcNIhkQMbeTQrXF0PmXnOSBNT15u
         E3P+0fKKRG2dr/FlNgS6gUsn2iHapz/+NqyFNxp+0z0Vz32JyYYw0pnF5eL/SLKf+6my
         rXM2MqLg2aYj2eFE9jNDo4R7pIi/vjYUOAPFfHv1s3oylaV26Rb8thsT/4/utFNRXK+s
         GVFw==
X-Gm-Message-State: AOAM530qbY1wsO8obkrrVeukMSIlc5bNE2CQIMQTAinbEJkONxfmPngT
        m7U4yYOXI20pYbxmM+7Zwk16b71tRo+6qektkQAlW5Kaedv7mLDeVXg4ZHPirlQpbscalpBnDCB
        uLdZqSCwZgkAt
X-Received: by 2002:aa7:d0d4:: with SMTP id u20mr23467795edo.203.1612281906842;
        Tue, 02 Feb 2021 08:05:06 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyPM7p5TyqnwHjGKi0caOD1YfB9dGRpowZ+WQHtxS6E6Y0e0Ymh7IbcVOjUFtqL6dXlAH2MJg==
X-Received: by 2002:aa7:d0d4:: with SMTP id u20mr23467772edo.203.1612281906630;
        Tue, 02 Feb 2021 08:05:06 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id q16sm9657765ejd.39.2021.02.02.08.05.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Feb 2021 08:05:05 -0800 (PST)
Subject: Re: [PATCH v2 1/3] KVM: X86: Rename DR6_INIT to DR6_ACTIVE_LOW
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Chenyi Qiang <chenyi.qiang@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210202090433.13441-1-chenyi.qiang@intel.com>
 <20210202090433.13441-2-chenyi.qiang@intel.com>
 <3db069ba-b4e0-1288-ec79-66ac44938682@redhat.com>
 <6678520f-e69e-6116-88c9-e9d6cd450934@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ea9eaa84-999b-82cb-ef40-66fde361704d@redhat.com>
Date:   Tue, 2 Feb 2021 17:05:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <6678520f-e69e-6116-88c9-e9d6cd450934@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/02/21 16:02, Xiaoyao Li wrote:
> On 2/2/2021 10:49 PM, Paolo Bonzini wrote:
>> On 02/02/21 10:04, Chenyi Qiang wrote:
>>>
>>>  #define DR6_FIXED_1    0xfffe0ff0
>>> -#define DR6_INIT    0xffff0ff0
>>> +/*
>>> + * DR6_ACTIVE_LOW is actual the result of DR6_FIXED_1 | 
>>> ACTIVE_LOW_BITS.
>>> + * We can regard all the current FIXED_1 bits as active_low bits even
>>> + * though in no case they will be turned into 0. But if they are 
>>> defined
>>> + * in the future, it will require no code change.
>>> + * At the same time, it can be served as the init/reset value for DR6.
>>> + */
>>> +#define DR6_ACTIVE_LOW    0xffff0ff0
>>>  #define DR6_VOLATILE    0x0001e00f
>>>
>>
>> Committed with some changes in the wording of the comment.
>>
>> Also, DR6_FIXED_1 is (DR6_ACTIVE_LOW & ~DR6_VOLATILE).
> 
> Maybe we can add BUILD_BUG_ON() to make sure the correctness?

We can even

#define DR_FIXED_1  (DR6_ACTIVE_LOW & ~DR6_VOLATILE)

directly.  I have pushed this patch to kvm/queue, but the other two will 
have to wait for Fenghua's bare metal support.

Paolo

