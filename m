Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54F416C236F
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 22:13:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbjCTVNd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 17:13:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjCTVNc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 17:13:32 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 768369ED0
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 14:13:29 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id u11-20020a05600c19cb00b003edcc414997so3475986wmq.3
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 14:13:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1679346808;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AIDtie/PJVHiXD4ro+NPI/jtwRQJJuL7uqxjFhs5h/k=;
        b=hUdhtlshTVSc5vZnfsIMxnFfZjY60sDhAMKhXS4lgu0BvWV4O8JZC6Tmu7KByOaOO7
         tB3ZTg4eXr/UnRoUvKUHfyIyn5xxh5iElNv0Mnr0q9cx6bZP06iOgP1B/hxRoZZ5caRg
         IRrFbVa7OJ2bKfj3shUDxJqHVFD+yYS7UQKmCOBryWepXSnS57kpZ1fQlgbukDcM7seN
         fq17LL4NE/QVDb3HsGGrcWCmoO0wwxJBhgIlH4A7lh/RI9d7w+7GPtU98MX6vmsVyCOu
         /6QRSvw/AU+KoPIRIt6mCWaNu9IL9pJe1mxuHpZc95+N1XJdnSnkG5lKQsxahmBu7x82
         Ybew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679346808;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AIDtie/PJVHiXD4ro+NPI/jtwRQJJuL7uqxjFhs5h/k=;
        b=oSr2edylRYl6MzkFdOacj4RJH+njkB+qdWy2OQa2KitpSfjnxllhY3wE1AcbzyXTVa
         Ky56cu2QZNMazZ4NC6d4kHTpRYsiLWb30quDSJDFUIYfY4A6PjZ8fkci2VFSZUJW6sFu
         xnyNuar+nPvtgz/v9JV6MPfFq5jMBPQQjmReFuGKHS51zrwtxlO3fBIrKOhUr0wGMX6m
         wN1CHrixTa9xbdtELQzOn3XGJywYIvveHdnS598JgjYSYP7LTyR/quKWajWFemtjp1WU
         /uRinyDZUefuY2FbJRRJnFTeg8xrNrPaehDoNQJ1Jcw705EZw3ZAFUUWi8sI7YEAXKzs
         R+ng==
X-Gm-Message-State: AO0yUKUSMZgykUtcXPz1Mgsin+cLzDf25qKNFxl+5wMfKIKCpP76/xOO
        FhjpKGLsJ49cujtVKyORklv87A==
X-Google-Smtp-Source: AK7set/1dtYtJuXyiQvUl53P5xy6ejU9J8F198zxsWZABww6C6eywFpKAy9awU11FBmz07GTw0uOxw==
X-Received: by 2002:a05:600c:ac5:b0:3ed:1fa2:e25b with SMTP id c5-20020a05600c0ac500b003ed1fa2e25bmr609721wmr.20.1679346807821;
        Mon, 20 Mar 2023 14:13:27 -0700 (PDT)
Received: from ?IPV6:2003:f6:af11:1000:ea7:9b12:7b30:c669? (p200300f6af1110000ea79b127b30c669.dip0.t-ipconnect.de. [2003:f6:af11:1000:ea7:9b12:7b30:c669])
        by smtp.gmail.com with ESMTPSA id c12-20020a05600c0a4c00b003eda357cfc5sm9153085wmq.43.2023.03.20.14.13.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Mar 2023 14:13:27 -0700 (PDT)
Message-ID: <68a1cc73-93ec-77ab-64a5-3d0e1bf829d0@grsecurity.net>
Date:   Mon, 20 Mar 2023 22:13:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v3 3/6] KVM: x86: Do not unload MMU roots when only
 toggling CR0.WP
Content-Language: en-US, de-DE
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20230201194604.11135-1-minipli@grsecurity.net>
 <20230201194604.11135-4-minipli@grsecurity.net> <ZBJCgG5leMwT22o8@google.com>
From:   Mathias Krause <minipli@grsecurity.net>
In-Reply-To: <ZBJCgG5leMwT22o8@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15.03.23 23:11, Sean Christopherson wrote:
> Can you tweak the shortlog to something like this?  I want to make it very clear
> that this applies only to the TDP case (more below).  I did a double take when I
> first read the subject :-)
> 
>   KVM: x86: Do not unload MMU roots when only toggling CR0.WP with TDP enabled

Sure, will do!

> 
> On Wed, Feb 01, 2023, Mathias Krause wrote:
>> There is no need to unload the MMU roots for a direct MMU role when only
>> CR0.WP has changed -- the paging structures are still valid, only the
>> permission bitmap needs to be updated.
>>
>> One heavy user of toggling CR0.WP is grsecurity's KERNEXEC feature to
>> implement kernel W^X.
>>
>> The optimization brings a huge performance gain for this case as the
>> following micro-benchmark running 'ssdd 10 50000' from rt-tests[1] on a
>> grsecurity L1 VM shows (runtime in seconds, lower is better):
>>
>>                        legacy     TDP    shadow
>> kvm.git/queue          11.55s   13.91s    75.2s
>> kvm.git/queue+patch     7.32s    7.31s    74.6s
>>
>> For legacy MMU this is ~36% faster, for TTP MMU even ~47% faster. Also
>> TDP and legacy MMU now both have around the same runtime which vanishes
>> the need to disable TDP MMU for grsecurity.
>>
>> Shadow MMU sees no measurable difference and is still slow, as expected.
>>
>> [1] https://git.kernel.org/pub/scm/utils/rt-tests/rt-tests.git
>>
>> Co-developed-by: Sean Christopherson <seanjc@google.com>
> 
> No need for this, I just threw a snippet at you as part of code review.  And IMO,
> if someone goes through the pain of running benchmarks, they get full credit no
> matter what ;-)

Reviewers (and in your case maintainers) get far too little credit, so
I'd rather keep that tag, if you don't mind that hard ;)

> 
>> Signed-off-by: Mathias Krause <minipli@grsecurity.net>
>> ---
>> v2: handle the CR0.WP case directly in kvm_post_set_cr0() and only for
>> the direct MMU role -- Sean
>>
>> I re-ran the benchmark and it's even faster than with my patch, as the
>> critical path is now the first one handled and is now inline. Thanks a
>> lot for the suggestion, Sean!
>>
>>  arch/x86/kvm/x86.c | 9 +++++++++
>>  1 file changed, 9 insertions(+)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 508074e47bc0..f09bfc0a3cc1 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -902,6 +902,15 @@ EXPORT_SYMBOL_GPL(load_pdptrs);
>>  
>>  void kvm_post_set_cr0(struct kvm_vcpu *vcpu, unsigned long old_cr0, unsigned long cr0)
>>  {
>> +	/*
>> +	 * Toggling just CR0.WP doesn't invalidate page tables per se, only the
>> +	 * permission bits.
>> +	 */
>> +	if (vcpu->arch.mmu->root_role.direct && (cr0 ^ old_cr0) == X86_CR0_WP) {
> 
> Past me was wrong, which is a very good thing in this case.  Per the APM,
> 
>   The host hCR0.WP bit is ignored under nested paging.
> 

See what you did? You even went that far and re-read the manual.
Definitely deserves credit!

> which means that CR0.WP doesn't need to be incorporated into the role.  Ha!  And
> really-past me even wrote a very nice comment to call that out in commit 31e96bc63655
> ("KVM: nSVM: Add a comment to document why nNPT uses vmcb01, not vCPU state").
> 
> Double ha!  That's all moot, because if this code is reached for a nested MMU,
> it means L2 is active and the CR0 being changed is gCR0, not L1's hCR0.
> 
> So more simply, this can be
> 
> 	if (tdp_enabled && (cr0 ^ old_cr0) == X86_CR0_WP)

Looks much simpler, indeed. But might deserve a little comment itself
why it's fine test 'tdp_enabled' only...

> 
> or if we want to exempt non-paging mode for the shadow MMU as well...
> 
> 	if ((cr0 ^ old_cr0) == X86_CR0_WP && (tdp_enabled || !(cr0 & X86_CR0_PG)))
> 
> Actually, if we bother to check CR0.PG, then we might as well get greedy and
> skip _all_ updates when paging is disabled.  E.g. end up with this over two
> patches?  First one exempts the tdp_enabled case, second one completely exempts
> paging disabled.
> 

...and there it is already! :D

> 	/*
> 	 * CR0.WP is incorporated into the MMU role, but only for non-nested,
> 	 * indirect shadow MMUs.  If paging is disabled, no updates are needed
> 	 * as there are no permission bits to emulate.  If TDP is enabled, the
> 	 * MMU's metadata needs to be updated, e.g. so that emulating guest
> 	 * translations does the right thing, but there's no need to unload the
> 	 * root as CR0.WP doesn't affect SPTEs when TDP is enabled.
> 	 */
> 	if ((cr0 ^ old_cr0) == X86_CR0_WP) {
> 		if (!(cr0 & X86_CR0_PG))
> 			return;
> 
> 		if (tdp_enabled) {
> 			kvm_init_mmu(vcpu);
> 			return;
> 		}
> 	}

Thanks, Sean! Sounds all very good to me. I'll cook up these commits, do
some more tests and send a v4 tomorrow, if time allows.
