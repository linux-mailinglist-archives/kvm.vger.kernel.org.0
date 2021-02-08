Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA3C731381D
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 16:37:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234010AbhBHPgw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 10:36:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54802 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232159AbhBHPel (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Feb 2021 10:34:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612798366;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3j7IDCtCgrVVxbDfUmZhTPgrXKWoZXIAfR3D/XPppB0=;
        b=buSTZGTxbxJ7J9aZOU+R4lF9sl7n+qMonIoVtuW45I1eIn1MVSIRQVoSLfTOJYc9jDqooa
        +I+Tty6CHusr6OiygZYfmdiQCD9btxlSTNXno5eWHKYRTp/vgCXPxStT6DUNRmbQezOlGH
        9tNcLrlTboMhMsDXySveayKnuVYjjO0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-34-rAQJt2l-Mpqc8sr8gdfyLA-1; Mon, 08 Feb 2021 10:32:44 -0500
X-MC-Unique: rAQJt2l-Mpqc8sr8gdfyLA-1
Received: by mail-wr1-f69.google.com with SMTP id c9so2799151wrq.18
        for <kvm@vger.kernel.org>; Mon, 08 Feb 2021 07:32:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3j7IDCtCgrVVxbDfUmZhTPgrXKWoZXIAfR3D/XPppB0=;
        b=rduLsqNtXLp7lMl7Buxj1JR5rnYuywZNDGXgFJZrCs7ejMk77Uho1B1kB2G2DznXs5
         XATtEZWNUrJS6c6P+wkG85KC1PHr94WqbdsAlgjznCgfkCE8pZ2v8J9uFhaPbPNAHr/k
         /kxSsnRMWzxJLJmDNr50N4dN4mYmQMR0w/29frFMrqG1i70dFAW+A2ZMglD4zzKrQJfJ
         i9zdtlvyW1DixOE8UGMVr0eFXLByb7xtRImmI4T0OwBhU1MRpoR2vXD/L+MUhZ/nT0yE
         YJYfR3f5Hve9wc9dalhFMNQtK0bvNSVG7FskqhB7ManSfnVwNRLhe+V1r0+OeAuK8XOO
         pglA==
X-Gm-Message-State: AOAM531ki7/VjchgFy6NLfqN8r03FevWM2nw1SM/9TYS2FsZ3Vt5alVU
        ONjffdQ5oAs+wvXHnG+wlvsYYlL9FUDwLtflZaWrhLiS/JjeQBBSbE+qnJiunMTCeTuZzKdg5eJ
        SgvoRquGGQhGG
X-Received: by 2002:adf:e511:: with SMTP id j17mr2012387wrm.251.1612798363039;
        Mon, 08 Feb 2021 07:32:43 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwNv14P5B4oSXteUpoa8u5FTUNYABwIoLHt5oVH7X2toon9dAx2SPqJd1Tom+2DudYb9uJUSw==
X-Received: by 2002:adf:e511:: with SMTP id j17mr2012357wrm.251.1612798362679;
        Mon, 08 Feb 2021 07:32:42 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id m2sm20417012wml.34.2021.02.08.07.32.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Feb 2021 07:32:41 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH] gitlab-ci.yml: Add new s390x targets to
 run tests with TCG and KVM accel
To:     Thomas Huth <thuth@redhat.com>,
        Marcelo Bandeira Condotta <mbandeir@redhat.com>,
        kvm@vger.kernel.org
Cc:     Marcelo Bandeira Condotta <mcondotta@redhat.com>
References: <20210208150227.178953-1-mbandeir@redhat.com>
 <8f34cddf-84bf-0726-8074-1688974a74d8@redhat.com>
 <6e56bdb9-72b4-369e-acb2-d5715e02ab92@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <344b1b84-8396-9df8-5c43-3f2538e7c89d@redhat.com>
Date:   Mon, 8 Feb 2021 16:32:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <6e56bdb9-72b4-369e-acb2-d5715e02ab92@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/02/21 16:13, Thomas Huth wrote:
> On 08/02/2021 16.07, Paolo Bonzini wrote:
>> On 08/02/21 16:02, Marcelo Bandeira Condotta wrote:
>>> From: Marcelo Bandeira Condotta <mcondotta@redhat.com>
>>>
>>> A new s390x z15 VM provided by IBM Community Cloud will be used to run
>>> the s390x KVM Unit tests natively with both TCG and KVM accel options.
>>>
>>> Signed-off-by: Marcelo Bandeira Condotta <mbandeir@redhat.com>
>>> ---
>>>   .gitlab-ci.yml | 28 ++++++++++++++++++++++++++++
>>>   1 file changed, 28 insertions(+)
>>>
>>> diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
>>> index d97e27e..bc7a115 100644
>>> --- a/.gitlab-ci.yml
>>> +++ b/.gitlab-ci.yml
>>> @@ -155,3 +155,31 @@ cirrus-ci-macos-i386:
>>>   cirrus-ci-macos-x86-64:
>>>    <<: *cirrus_build_job_definition
>>> +
>>> +test-s390x-tcg:
>>> +  stage: test
>>> +  before_script: []
>>> +  tags:
>>> +    - s390x-z15-vm
>>> +  script:
>>> +    - ./configure --arch=s390x
>>> +    - make -j2
>>> +    - ACCEL=tcg ./run_tests.sh
>>> +     selftest-setup intercept emulator sieve skey diag10 diag308 
>>> vector diag288
>>> +     stsi sclp-1g sclp-3g
>>> +     | tee results.txt
>>> +    - if grep -q FAIL results.txt ; then exit 1 ; fi
>>> +
>>> +test-s390x-kvm:
>>> +  stage: test
>>> +  before_script: []
>>> +  tags:
>>> +    - s390x-z15-vm
>>> +  script:
>>> +    - ./configure --arch=s390x
>>> +    - make -j2
>>> +    - ACCEL=kvm ./run_tests.sh
>>> +     selftest-setup intercept emulator sieve skey diag10 diag308 
>>> vector diag288
>>> +     stsi sclp-1g sclp-3g
>>> +     | tee results.txt
>>> +    - if grep -q FAIL results.txt ; then exit 1 ; fi
> 
> Acked-by: Thomas Huth <thuth@redhat.com>
> 
>>
>> So it will have a custom runner?  That's nice!
>>
>> Do you have an example run already?
> 
> I've been in touch with Marcelo during the past days already, and I've 
> already registered the runner that he set up on the s390x machine, so it 
> should theoretically work now once this patch has been merged.

What's the reason to add test-s390x-tcg?  It would really cover only a 
different TCG backend.

Paolo

