Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15019C086B
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 17:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727517AbfI0PT3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 11:19:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39496 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727076AbfI0PT3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 11:19:29 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F19767FDFF
        for <kvm@vger.kernel.org>; Fri, 27 Sep 2019 15:19:28 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id t11so1204960wrq.19
        for <kvm@vger.kernel.org>; Fri, 27 Sep 2019 08:19:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sdnXuMgVCkSQptdkOcAALAp2a/GdXCNohkF//CTeXXc=;
        b=r/IeX24Kl0uVH8lwDmndtLcWf4nhmbTRhhkyjQ2bkqYouUBURbraUwFT3/M22WvlF9
         Y3ouD38i5zY8yDLCVZHbRdgGQVawZu3ms9H7PhRVeZxVKHBFWlYEPpPIBJbZmPIO6/0b
         afzuHglMDUrNacSdIrp0oZu6cL4ZbLF25mga+mZpR37AcE/fao2SQZeS9Jg6JgWM+LGt
         mLSe60p/wyTxvA02Ihei7c5j2rEx/dpWDy4Sc7ACbu62zcSrNh6Cs96Ihf8pPxh6cpyf
         a2i8rGjlJNMyCEL2lZQZaBLndCTlanBZWIpWORG8ufmGPfhuAWPpzb+HdayWXlccCAtH
         V/UA==
X-Gm-Message-State: APjAAAWC7VLSMmg0k4QXSReTh++sa06YQslIzbEsIb7h7jVF/U2YxjWx
        NWrm8/7tm+EJFbcAJdtK6qyEhI4Ye/VVcyBZc6rCPmxlDNxv/OVRIngEckdJV5QZH3yjxbgCtcJ
        mi1VBpQDzXitX
X-Received: by 2002:a1c:a8d8:: with SMTP id r207mr7363853wme.135.1569597567586;
        Fri, 27 Sep 2019 08:19:27 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxqPCNQ+D4SGupNg0RToIys4KdbhXv7CwXCoQHSs6eYcWy5AoelG7BoIvr5WDilwZ8IwvR+Iw==
X-Received: by 2002:a1c:a8d8:: with SMTP id r207mr7363829wme.135.1569597567250;
        Fri, 27 Sep 2019 08:19:27 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9520:22e6:6416:5c36? ([2001:b07:6468:f312:9520:22e6:6416:5c36])
        by smtp.gmail.com with ESMTPSA id c4sm2928725wru.31.2019.09.27.08.19.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Sep 2019 08:19:26 -0700 (PDT)
Subject: Re: [PATCH] kvm: x86: Add Intel PMU MSRs to msrs_to_save[]
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Eric Hankland <ehankland@google.com>,
        Peter Shier <pshier@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
References: <20190821182004.102768-1-jmattson@google.com>
 <CALMp9eTtA5ZXJyWcOpe-pQ66X3sTgCR4-BHec_R3e1-j1FZyZw@mail.gmail.com>
 <8907173e-9f27-6769-09fc-0b82c22d6352@oracle.com>
 <CALMp9eSkognb2hJSuENK+5PSgE8sYzQP=4ioERge6ZaFg1=PEA@mail.gmail.com>
 <cb7c570c-389c-2e96-ba46-555218ba60ed@oracle.com>
 <CALMp9eQULvr5wKt1Aw3MR+tbeNgvA_4p__6n1YTkWjMHCaEmLw@mail.gmail.com>
 <CALMp9eS1fUVcnVHhty60fUgk3-NuvELMOUFqQmqPLE-Nqy0dFQ@mail.gmail.com>
 <56e7fad0-d577-41db-0b81-363975dc2ca7@redhat.com>
 <87ftkh6e19.fsf@vitty.brq.redhat.com>
 <6e6f46fe-6e11-c5e3-d80c-327f77b91907@redhat.com>
 <87d0fl6bv4.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <19db28c0-375a-7bc0-7151-db566ae85de6@redhat.com>
Date:   Fri, 27 Sep 2019 17:19:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <87d0fl6bv4.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/09/19 16:40, Vitaly Kuznetsov wrote:
> Paolo Bonzini <pbonzini@redhat.com> writes:
> 
>> On 27/09/19 15:53, Vitaly Kuznetsov wrote:
>>> Paolo Bonzini <pbonzini@redhat.com> writes:
>>>
>>>> Queued, thanks.
>>>
>>> I'm sorry for late feedback but this commit seems to be causing
>>> selftests failures for me, e.g.:
>>>
>>> # ./x86_64/state_test 
>>> Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
>>> Guest physical address width detected: 46
>>> ==== Test Assertion Failure ====
>>>   lib/x86_64/processor.c:1089: r == nmsrs
>>>   pid=14431 tid=14431 - Argument list too long
>>>      1	0x000000000040a55f: vcpu_save_state at processor.c:1088 (discriminator 3)
>>>      2	0x00000000004010e3: main at state_test.c:171 (discriminator 4)
>>>      3	0x00007f881eb453d4: ?? ??:0
>>>      4	0x0000000000401287: _start at ??:?
>>>   Unexpected result from KVM_GET_MSRS, r: 36 (failed at 194)
>>>
>>> Is this something known already or should I investigate?
>>
>> No, I didn't know about it, it works here.
>>
> 
> Ok, this is a bit weird :-) '194' is 'MSR_ARCH_PERFMON_EVENTSEL0 +
> 14'. In intel_pmu_refresh() nr_arch_gp_counters is set to '8', however,
> rdmsr_safe() for this MSR passes in kvm_init_msr_list() (but it fails
> for 0x18e..0x193!) so it stay in the list. get_gp_pmc(), however, checks
> it against nr_arch_gp_counters and returns a failure.

Huh, 194h apparently is a "FLEX_RATIO" MSR.  I agree that PMU MSRs need
to be checked against CPUID before allowing them.

Paolo

> Oh, btw, this is Intel(R) Xeon(R) CPU E5-2603 v3
> 
> So apparently rdmsr_safe() check in kvm_init_msr_list() is not enough,
> for PMU MSRs we need to do extra.



