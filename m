Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8DBC368D73
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 08:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240729AbhDWG6L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 02:58:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55573 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229478AbhDWG6G (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Apr 2021 02:58:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619161050;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B/yFE/YbQPPIC7sC0RtawzeRUN3wStQ0hYY/jxDpEZM=;
        b=NP1fQxkgdgty4By9TIkTmQ8XXwcC+uM/XSh92BduJVYD0SaPCtGEoSKt9aabi4vf5risNR
        cveBCgj/XRfJxYeISC7I656KF0a5xVnxukH/iBy3q49gZkxJhSg8pylrURRqWBMynkqddn
        PmYRLvKwBp+ZbrPG+qHYzwRYuAm46Q4=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-7-ZBjj-95XNHu1wbqhmAW7XA-1; Fri, 23 Apr 2021 02:57:28 -0400
X-MC-Unique: ZBjj-95XNHu1wbqhmAW7XA-1
Received: by mail-ej1-f69.google.com with SMTP id d16-20020a1709066410b0290373cd3ce7e6so8015212ejm.14
        for <kvm@vger.kernel.org>; Thu, 22 Apr 2021 23:57:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=B/yFE/YbQPPIC7sC0RtawzeRUN3wStQ0hYY/jxDpEZM=;
        b=CLXKqYXVWcIu+HbD2Bh9gN9iuvoFdPCDT1nrerdWj5jlw2bckXwqMEb+D2Zj1L64Hv
         v66SLBxTvS75eaGPKl0mREKXH4OmXydnL68tgA/3wD0gXUvrMwtoBFvPE3/qfCzg0Srx
         tzGm6bBTGqI3+uzZSB7VF5rHCoRzrTh/oAmyVL8C+YxuGOfLO4M5f5mE49WnbeTnIATr
         JsSU4dwxArOSrnFy6XjVxMwxDqsaEj0ceEDe8r/FvpktNCH9CRQ+cknAUlHqSIfP0Pfs
         70rlFEG0jSD0D6kdoEPGb7vzCqEAFqLPHrntYPSLj4zqE52ahS9UFTLlTPZIDU7oB2fm
         8hdw==
X-Gm-Message-State: AOAM532ox+6uFwZGXjx791XqrUqOfuk1X/Jhm1Ak+j4xZRMaEhihig7A
        LHDqqCgvU6ucD+LY99V7LR6iMiOWtmzhW0LU3YESbopv1c/PeU5RKs3T5ZGv4m01iCujpDpjgPt
        KDrk+WU04jx9DglJKeaEGXtCj4wqI3/K4+5wTi6uX/gy8CUbB67IZs51IcLgxET4j
X-Received: by 2002:aa7:c952:: with SMTP id h18mr2708801edt.269.1619161046620;
        Thu, 22 Apr 2021 23:57:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwGLdt7sTO1/ECb/7IecqVG9bnYxFBwv4B3Px0aNGLmHd0ieEtbBYpV+xqap4gi4JBDRdL9FA==
X-Received: by 2002:aa7:c952:: with SMTP id h18mr2708786edt.269.1619161046360;
        Thu, 22 Apr 2021 23:57:26 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id kt22sm3284610ejb.7.2021.04.22.23.57.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Apr 2021 23:57:25 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 01/14] x86/cstart: Don't use MSR_GS_BASE in
 32-bit boot code
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
References: <20210422030504.3488253-1-seanjc@google.com>
 <20210422030504.3488253-2-seanjc@google.com>
 <24a92fa2-6d31-f1c2-6661-8b6f3f41766c@redhat.com>
 <YIG4+0WW7K9zw/f+@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4d2d6c5f-8dd2-12a7-6edb-a0a3c76c9b1b@redhat.com>
Date:   Fri, 23 Apr 2021 08:57:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YIG4+0WW7K9zw/f+@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/04/21 19:57, Sean Christopherson wrote:
> On Thu, Apr 22, 2021, Paolo Bonzini wrote:
>> On 22/04/21 05:04, Sean Christopherson wrote:
>>> Load the per-cpu GS.base for 32-bit build by building a temporary GDT
>>> and loading a "real" segment.  Using MSR_GS_BASE is wrong and broken,
>>> it's a 64-bit only MSR and does not exist on 32-bit CPUs.  The current
>>> code works only because 32-bit KVM VMX incorrectly disables interception
>>> of MSR_GS_BASE, and no one runs KVM on an actual 32-bit physical CPU,
>>> i.e. the MSR exists in hardware and so everything "works".
>>>
>>> 32-bit KVM SVM is not buggy and correctly injects #GP on the WRMSR, i.e.
>>> the tests have never worked on 32-bit SVM.
>>
>> Hmm, this breaks task switch.  But setting up separate descriptors is
>> not hard:
> 
> Much better.
> 
> Using %ebx crushes the mbi_bootinfo pointer.  The easiest fix is to use %edx or
> %ecx.
> 
>> +	mov (%ebx), %ebx
> 
> No need to load the address into a reg, just drop the "$" above and encode
> "mov [imm32], <reg>".

Yep, I had already fixed more or less the same things (plus the task 
gate TSS setup, which must not hardcode GS to 0x10; no idea how it 
worked before) before seeing your mail.  I sent the result to the 
mailing list.

Paolo

