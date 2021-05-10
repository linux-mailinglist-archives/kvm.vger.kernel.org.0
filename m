Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A82A3790D9
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 16:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236391AbhEJOdB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 10:33:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20598 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230152AbhEJOav (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 May 2021 10:30:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620656985;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PVhwAQco9R41v3dWo8fAy6CH45dQj+RWz+P+aZRwNAE=;
        b=dUzbL/mhDIGPFBVg4BM2UOwVElUybYUjbwQ9EAEni99wynQ75RepM891TdCHL1w5ThBIcB
        BeHspRxFjbFhsKCwhD6zNybIHtPB2d+85hIjuYHMxANXocggRyjkgL766Z2YQvZz7OciWn
        TPV8bb9Okax6DPFIxXkkQoeEj7kM09I=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-603-tsKbTQM8Mk6ml_QSrtDY9w-1; Mon, 10 May 2021 10:29:44 -0400
X-MC-Unique: tsKbTQM8Mk6ml_QSrtDY9w-1
Received: by mail-wm1-f71.google.com with SMTP id w21-20020a7bc1150000b029014a850581efso3566157wmi.6
        for <kvm@vger.kernel.org>; Mon, 10 May 2021 07:29:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PVhwAQco9R41v3dWo8fAy6CH45dQj+RWz+P+aZRwNAE=;
        b=DO58bl/coUaIAfdttCRYm/ou1V1Pzsc/EQOJnRmZGj5XVIr3TZ5sYlzfOUzJmpputj
         s+7tUhJd0d16bRoFylvnmco0xYaNOe+Z2+7crYmqhZ2CTDjLYD/klCDUEFvFfN4yBtTS
         egwCxB8NFBAFGrOWNHWUXY8JLZjco0o738Qi0/OBmx3wMnR7Sgz2gJ5SL5dSOivT/SSv
         4mbY5/y0QDN+6q7Y0fq035Xzart1xmwGNnXHfDM8yAECA15evmjHCiya6edoGKIX+wom
         lrPoNJaoEgJ1CYp/KzlTBbu5wHJSdbFHJ6PG9nhoCrtY/MxykzeNNGrnG0r6rmcHeyyD
         QA6w==
X-Gm-Message-State: AOAM530IfnSBkfWdChPEf08tfFT1PSrflEfjkk13aXCYP/wjTRC7ufrX
        HooxM86mf+yd1i1++6ORw8dhRZvrJaW23rgXzJO6d32XowURFzOx40oGRj8ALBoHJFdDaIyYlni
        YOMT2xEuWrQFA
X-Received: by 2002:adf:f3c1:: with SMTP id g1mr31915395wrp.242.1620656982882;
        Mon, 10 May 2021 07:29:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz7qp62uiPj2YNFPbBBrBkzA+qnxLBcXElgNK1+YlCIqKhpmM2uMbsoAdz/OsjHjBtWRhUt6Q==
X-Received: by 2002:adf:f3c1:: with SMTP id g1mr31915376wrp.242.1620656982739;
        Mon, 10 May 2021 07:29:42 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id s18sm23509169wro.95.2021.05.10.07.29.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 May 2021 07:29:42 -0700 (PDT)
To:     Jim Mattson <jmattson@google.com>, ilstam@mailbox.org
Cc:     kvm list <kvm@vger.kernel.org>, ilstam@amazon.com,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Haozhong Zhang <haozhong.zhang@intel.com>, zamsden@gmail.com,
        mtosatti@redhat.com, Denis Plotnikov <dplotnikov@virtuozzo.com>,
        David Woodhouse <dwmw@amazon.co.uk>
References: <20210506103228.67864-1-ilstam@mailbox.org>
 <CALMp9eSNHf=vmqeer+ZkRa3NhJoLMbEO+OZJaG9qf+2+TQ2grA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 0/8] KVM: VMX: Implement nested TSC scaling
Message-ID: <bdfb8be8-7584-c60b-635e-3595fe481a60@redhat.com>
Date:   Mon, 10 May 2021 16:29:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CALMp9eSNHf=vmqeer+ZkRa3NhJoLMbEO+OZJaG9qf+2+TQ2grA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/05/21 19:16, Jim Mattson wrote:
> On Thu, May 6, 2021 at 3:34 AM <ilstam@mailbox.org> wrote:
>>
>> From: Ilias Stamatis <ilstam@amazon.com>
>>
>> KVM currently supports hardware-assisted TSC scaling but only for L1 and it
>> doesn't expose the feature to nested guests. This patch series adds support for
>> nested TSC scaling and allows both L1 and L2 to be scaled with different
>> scaling factors.
>>
>> When scaling and offsetting is applied, the TSC for the guest is calculated as:
>>
>> (TSC * multiplier >> 48) + offset
>>
>> With nested scaling the values in VMCS01 and VMCS12 need to be merged
>> together and stored in VMCS02.
>>
>> The VMCS02 values are calculated as follows:
>>
>> offset_02 = ((offset_01 * mult_12) >> 48) + offset_12
>> mult_02 = (mult_01 * mult_12) >> 48
>>
>> The last patch of the series adds a KVM selftest.
> 
> Will you be doing the same for SVM? The last time I tried to add a
> nested virtualization feature for Intel only, Paolo rapped my knuckles
> with a ruler.

For bugfixes definitely, for features it is definitely nice.

And these days we even have similar-enough code between nVMX and nSVM 
code, that in many cases there's really no good excuse not to do it.

Paolo

