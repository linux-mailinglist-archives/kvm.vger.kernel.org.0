Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF435FBA22
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 20:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbiJKSLo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Oct 2022 14:11:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbiJKSLl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Oct 2022 14:11:41 -0400
Received: from mail-oo1-xc49.google.com (mail-oo1-xc49.google.com [IPv6:2607:f8b0:4864:20::c49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D45B61D71
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 11:11:40 -0700 (PDT)
Received: by mail-oo1-xc49.google.com with SMTP id n27-20020a4a611b000000b0048067b2a6f7so4415885ooc.6
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 11:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=W3JMUwu6ziuvpjpq9F0zq68QvyahiwJaOE4mHzUkx+4=;
        b=ZMGnlBVUaauNbXvukBXR8oMKUClj1sHHGWGTsw9UJp8iSfZSk1RYcT8jLH3x6COlU9
         +xga1da7BBwGvuR6T3h4ZWjYMdhbKHs2eIhal2HEyHSN5vKR5Y8gQ7+NcK+c/BenF4nI
         5o8nY0SIfkNBE2zhtZcvWd+jtTkbwcil9Lvv3GZk/B8hQLy877L00jDV3R4ByQISRL7p
         Rust1Sl4fFuby0VTYrJKrmMDqYAAJKyWAL71RG7LFxTWZLtvQ5L9D0qlwJiKBABa3HQG
         vF6NTOabTPnavz6IXI14BCrphpxW98R44XJckMOsdgmL/dPjNGaP5jjB7Z2lYpJ1NJkD
         Fl4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W3JMUwu6ziuvpjpq9F0zq68QvyahiwJaOE4mHzUkx+4=;
        b=GTCahfHEdi01AJVkUB1j1ZDhps5cBAIJTjivqxut/tu0CroJ5D2rE2X8CwlVY010V3
         uWLcPUmyXkRG9GF/mQRdGNXAmxyNb6RF6tk4k8/+VXSlgDCII09yeTyfIIGQd5aLU7kL
         Jd6Op6sbY+zbWCcIU0rzyx9h+4fKQfFhhUWzjWg7QmdTh6HbFZwr2x7cprpOpZY9gM0L
         DshKbKGqkPEca3GGSg6hBM4xTBC8N9Zb616HAPQPCIBzCoW6fWpMZrS9bYka7nMrFaih
         bAb78QDYUpblTbHh/YWmx6EvSOkBASSgOy1OZtitp5DXCOeLlkwnM+aU45lCiNK9Ub/Q
         dy1g==
X-Gm-Message-State: ACrzQf3wrlEtxDxNN8mYPurxKu4ZPNA20jugskIr4Q68hDZJBfYCRBli
        X9OpRVBbOIyYkFLQ07HKISEu80hBWc/JbzsxFA==
X-Google-Smtp-Source: AMsMyM6abr17LtJPwWObF4Wp/uVgpO4vq2OMkAwcPfXyNUFoHSbErTE6vbPoRoSz1ineZbD7lUMYWQ3IfLwoiWMsvA==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:aca:4b45:0:b0:354:461c:5b58 with SMTP
 id y66-20020aca4b45000000b00354461c5b58mr192753oia.131.1665511899904; Tue, 11
 Oct 2022 11:11:39 -0700 (PDT)
Date:   Tue, 11 Oct 2022 18:11:38 +0000
In-Reply-To: <Y0CO+5m8hJyok/oG@google.com> (message from Sean Christopherson
 on Fri, 7 Oct 2022 20:41:31 +0000)
Mime-Version: 1.0
Message-ID: <gsntfsfu2pt1.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v6 1/3] KVM: selftests: implement random number generation
 for guest code
From:   Colton Lewis <coltonlewis@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        dmatlack@google.com, oupton@google.com, ricarkol@google.com,
        andrew.jones@linux.dev
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Mon, Sep 12, 2022, Colton Lewis wrote:
>> diff --git a/tools/testing/selftests/kvm/include/test_util.h  
>> b/tools/testing/selftests/kvm/include/test_util.h
>> index 99e0dcdc923f..2dd286bcf46f 100644
>> --- a/tools/testing/selftests/kvm/include/test_util.h
>> +++ b/tools/testing/selftests/kvm/include/test_util.h
>> @@ -143,4 +143,6 @@ static inline void *align_ptr_up(void *x, size_t  
>> size)
>>   	return (void *)align_up((unsigned long)x, size);
>>   }

>> +void guest_random(uint32_t *seed);

> This is a weird and unintuitive API.  The in/out param exposes the gory  
> details
> of the pseudo-RNG to the caller, and makes it cumbersome to use, e.g. to  
> create
> a 64-bit number or to consume the result in a conditional.


To explain my reasoning:

It's simple because there is exactly one way to use it and it's short so
anyone can understand how the function works at a glance. It's similar
to the API used by other thread-safe RNGs like rand_r and random_r. They
also use in/out parameters. That's the only way to buy thread
safety. Callers would also have to manage their own state in your
example with an in/out parameter if they want thread safety.

I disagree the details are gory. You put in a number and get a new
number. It's common knowledge PRNGs work this way. I understand you are
thinking about ease of future extensions, but this strikes me as
premature abstraction. Additional APIs can always be added later for the
fancy stuff without modifying the callers that don't need it.

I agree returning the value could make it easier to use as part of
expressions, but is it that important?

> It's also not inherently guest-specific, or even KVM specific.  We should  
> consider
> landing this in common selftests code so that others can use it and even  
> expand on
> it.  E.g. in a previous life, I worked with a tool that implemented all  
> sorts of
> random number magic that provided APIs to get random bools with 1->99  
> probabilty,
> random numbers along Guassian curves, bounded numbers, etc.


People who need random numbers outside the guest should use stdlib.h. No
need to reimplement a full random library. The point of this
implementation was to do the simplest thing that could provide random
numbers to the guest.
