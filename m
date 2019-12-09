Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2510F1172FC
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2019 18:42:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbfLIRmJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Dec 2019 12:42:09 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:59204 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725904AbfLIRmJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Dec 2019 12:42:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575913327;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZZ+utv+eyb/YduaK/Yzcwn4a/XIs4Arw3SxRhufEh5A=;
        b=b27U1fCxoSXVWjXCZS1UXFHit+Ien8cAsDjsZnWkyRWctHWqvL0k86xAQg4hiyhbJa4d4y
        tG43kGlR4Pov5qButUymrvsUKZ8rouFwoBfA+eQgH/SkvLtJ/9P27g+lkKhG18EBK4yRGs
        81cK2enhtP+r1ya782jfg8Pz8wa+Ccw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-378-3XSWhK3TNRWPmR2Oz3bVaQ-1; Mon, 09 Dec 2019 12:42:06 -0500
Received: by mail-wm1-f72.google.com with SMTP id 7so49192wmf.9
        for <kvm@vger.kernel.org>; Mon, 09 Dec 2019 09:42:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZZ+utv+eyb/YduaK/Yzcwn4a/XIs4Arw3SxRhufEh5A=;
        b=POeJLBL87MlLp/9mRB2fvV11HayLx+W7cL6fDSGlD16kMK1jNpCKG2HykHOaCff2fX
         G8ix1vLGgyYUc4MbaXRaXj4ILMLGRFmU7x5E08dQ7I35prhzs072e+Nz3HL7y327wjVB
         lYfPUJlrKEy8Iwi1vBJHgAjWgsM/ge/Jrd0GoBaTYRr++zU5Km5HK5m68n/4Yliqvphw
         ucUR7+Y5w1O8GtAP0veB+p/oDFh8e4rSgxzME2tPJJm2zdCLINDjIhnFKzlmUSd3mpnf
         MtGnCZa10XvxGmjcEvcjLTF4TAj4qdIruyiRR1aSqUOL5hZ3EkiZNyGVFJKUHXSvtJvL
         EA+g==
X-Gm-Message-State: APjAAAXjM7mtFGYrxzb+UcFW1H/YHEYquJLfJ1ANkVHeLZwVUGmk+Sxn
        hNYAHt8QPMkL9bUBe0LQtGmpj2mc+xt7WuQ3cIG5Aba46GW91jrDI4SNZ7lq9xUWAZjNlVG6ywM
        stcJPSGJZMoOK
X-Received: by 2002:a05:600c:507:: with SMTP id i7mr176929wmc.135.1575913325157;
        Mon, 09 Dec 2019 09:42:05 -0800 (PST)
X-Google-Smtp-Source: APXvYqx5mNiLKcR7928omJZFOdrxdJQtaIbN4yfFKPJBty8beciwsldIewdrA4+gu4tXERcfWkEHTA==
X-Received: by 2002:a05:600c:507:: with SMTP id i7mr176909wmc.135.1575913324867;
        Mon, 09 Dec 2019 09:42:04 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9? ([2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9])
        by smtp.gmail.com with ESMTPSA id u8sm89227wmm.15.2019.12.09.09.42.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Dec 2019 09:42:04 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH] travis.yml: Run 32-bit tests with KVM, too
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
References: <20191205170439.11607-1-thuth@redhat.com>
 <699a350a-3956-5757-758c-0e246d698a7d@redhat.com>
 <e319993e-4732-d3ed-bca6-054c78103a61@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <75b0e3d3-4d74-de4b-822f-e125711dbf56@redhat.com>
Date:   Mon, 9 Dec 2019 18:42:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <e319993e-4732-d3ed-bca6-054c78103a61@redhat.com>
Content-Language: en-US
X-MC-Unique: 3XSWhK3TNRWPmR2Oz3bVaQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/12/19 18:14, Thomas Huth wrote:
> On 09/12/2019 18.07, Paolo Bonzini wrote:
>> On 05/12/19 18:04, Thomas Huth wrote:
>>> KVM works on Travis in 32-bit, too, so we can enable more tests there.
>>>
>>> Signed-off-by: Thomas Huth <thuth@redhat.com>
>>> ---
>>>  .travis.yml | 10 +++++++---
>>>  1 file changed, 7 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/.travis.yml b/.travis.yml
>>> index 4162366..75bcf08 100644
>>> --- a/.travis.yml
>>> +++ b/.travis.yml
>>> @@ -34,15 +34,19 @@ matrix:
>>>        env:
>>>        - CONFIG="--arch=i386"
>>>        - BUILD_DIR="."
>>> -      - TESTS="eventinj port80 sieve tsc taskswitch umip vmexit_ple_round_robin"
>>> +      - TESTS="asyncpf hyperv_stimer hyperv_synic kvmclock_test msr pmu realmode
>>> +               s3 sieve smap smptest smptest3 taskswitch taskswitch2 tsc_adjust"
> 
> taskswitch and taskswitch2 are here ----------------^

You're right, but I'm confused: what are the two separate configurations
for?  Worth a comment?

>>> +      - ACCEL="kvm"
>>>  
>>>      - addons:
>>>          apt_packages: gcc gcc-multilib qemu-system-x86
>>>        env:
>>>        - CONFIG="--arch=i386"
>>>        - BUILD_DIR="i386-builddir"
>>> -      - TESTS="vmexit_mov_from_cr8 vmexit_ipi vmexit_ipi_halt vmexit_mov_to_cr8
>>> -               vmexit_cpuid vmexit_tscdeadline vmexit_tscdeadline_immed"
>>> +      - TESTS="tsx-ctrl umip vmexit_cpuid vmexit_ipi vmexit_ipi_halt
>>> +               vmexit_mov_from_cr8 vmexit_mov_to_cr8 vmexit_ple_round_robin
>>> +               vmexit_tscdeadline vmexit_tscdeadline_immed vmexit_vmcall"
>>> +      - ACCEL="kvm"
>>>  
>>>      - addons:
>>>          apt_packages: gcc-arm-linux-gnueabihf qemu-system-arm
>>>
>>
>> Applied, thanks.  But there are also some 32-bit specific tests
>> (taskswitch, taskswitch2, cmpxchg8b) that we may want to add.
> 
> cmpxchg8b seems to be missing in x86/unittests.cfg ... so I think it
> should be added there first?

Good idea.

