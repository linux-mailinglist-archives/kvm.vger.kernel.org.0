Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF4853C176A
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 18:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbhGHQx3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jul 2021 12:53:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48071 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229524AbhGHQx3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 8 Jul 2021 12:53:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625763046;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2OB0zSrc/L137vieSn1bV5IcC6z0P+Q1vkoqM8xpfTo=;
        b=YEQI2B85NKHdFVQI9+sMoi9OQUYYjxYD9xmr1/qK7ZADcxSoiYTbcDrsRho6CcmU7gf8ij
        Skecd1g8ifNnPg4itELRXECm9Zzt6z2Wkg9rYG5rrVlBAxdSFUssSXIYoVSQBjdIUuu0xS
        RxLBq0Egot0aiHI+DjuU5/Dr6N7gRLA=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-379-HKFA6koHMvChzSAazdNX7w-1; Thu, 08 Jul 2021 12:50:45 -0400
X-MC-Unique: HKFA6koHMvChzSAazdNX7w-1
Received: by mail-ej1-f69.google.com with SMTP id ia10-20020a170907a06ab02904baf8000951so2089814ejc.10
        for <kvm@vger.kernel.org>; Thu, 08 Jul 2021 09:50:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2OB0zSrc/L137vieSn1bV5IcC6z0P+Q1vkoqM8xpfTo=;
        b=OQBFlA36AOe5XwlcyMgRWMOjMtAqposuzePhb9TVWQXWpcSI86c3Sd493NnbYMiq99
         QVi7IUpI4fiXjwherCbg6oM0UmM+O12i2dyQiE4PLa6AJV91tMUx1j79+nth5X1jYpR/
         ixwTtHkqI++nBFwsSqUk10+LbpY4ou0W3r80OTZe0xf6P82SBHL0godsbJq5vcNW00I2
         RAbHAxe6ZTZZrphIiUy4N+deNVsk15JE8KpbNpga8ThRmNCQ0BEawgZIbW3IjdVTShdH
         vn//gWKWhSBCpggyWjyYB3xsS+mgMz+3SF2HtvOrfIcfmoqES5HYWS96iPVuylgbBKOr
         tb5A==
X-Gm-Message-State: AOAM533IqczA1Wpfw5hpsUs+/wWevs/9IStQaGlU/iyLbVuGP2GFJMKR
        VmXI0l+BeOYfnMpoVLIPX1Cu+l+ikUvw5rLzXh3w1CG+Wb2Ir8aeVf/ar4LsMxIKCuknocQzkxL
        AxmB3uHiMI64X
X-Received: by 2002:a17:907:d8c:: with SMTP id go12mr19890638ejc.442.1625763044385;
        Thu, 08 Jul 2021 09:50:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzk9fO2BRrb8OTLwrPrz4tYr5MAon9lbPn4sasbXn1PywwYC0XefPHKB81KozyzGnj+G0mQ5Q==
X-Received: by 2002:a17:907:d8c:: with SMTP id go12mr19890610ejc.442.1625763044210;
        Thu, 08 Jul 2021 09:50:44 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id j6sm1618320eds.58.2021.07.08.09.50.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Jul 2021 09:50:43 -0700 (PDT)
Subject: Re: [PATCH 0/5] KVM: x86: Use kernel x86 cpuid utilities in KVM
 selftests
To:     Jim Mattson <jmattson@google.com>,
        Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
References: <20210422005626.564163-1-ricarkol@google.com>
 <c4524e4a-55c7-66f9-25d6-d397f11d25a8@redhat.com>
 <YIm7iWxggvoN9riz@google.com>
 <CALMp9eSfpdWF0OROsOqxohxMoFrrY=Gt7FYfB1_31D7no4JYLw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <16823e91-5caf-f52e-e0dc-28ebb9a87b47@redhat.com>
Date:   Thu, 8 Jul 2021 18:50:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eSfpdWF0OROsOqxohxMoFrrY=Gt7FYfB1_31D7no4JYLw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/06/21 19:28, Jim Mattson wrote:
>> Thanks. I was thinking about kvm-unit-tests, but the issue is that it
>> would also be a copy. And just like with kernel headers, it would be
>> ideal to keep them in-sync. The advantage of the kernel headers is that
>> it's much easier to check and fix diffs with them. On the other hand, as
>> you say, there would not be any #ifdef stuff with kvm=unit-tests. Please
>> let me know what you think.
>
> I think the kvm-unit-tests implementation is superior to the kernel
> implementation, but that's probably because I suggested it. Still, I
> think there's an argument to be made that selftests, unlike
> kvm-unit-tests, are part of the kernel distribution and should be
> consistent with the kernel where possible.
> 
> Paolo?

I also prefer the kvm-unit-tests implementation, for what it's worth... 
Let's see what the code looks like?

Paolo

