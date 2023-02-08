Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA10F68EC32
	for <lists+kvm@lfdr.de>; Wed,  8 Feb 2023 10:53:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229460AbjBHJxI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Feb 2023 04:53:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230472AbjBHJwv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Feb 2023 04:52:51 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 635372F780
        for <kvm@vger.kernel.org>; Wed,  8 Feb 2023 01:52:50 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id hx15so49702287ejc.11
        for <kvm@vger.kernel.org>; Wed, 08 Feb 2023 01:52:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kBopOcpcFnO8EGG+PF8LjIEPdrxkliis2fcATL22bFo=;
        b=h61lR9XrDchidBHzxhqp+zS8r+or5bIpunH4vZAxCF2hBGPrkgnOO5Hk6g/FmU0BC7
         BTSXC00OB8o1u8idUgHQHlQZANVtTcJrF5IfMEERuZ3hYRzjTIiAG6oGETpzDQvntkEH
         mC2co6seHrZD6rvtvc73RIES55d2stajCu4qzcxrS1IyVuwOBUsRVi4AQQU3zDWP9TIi
         dfY+UcNSIyO9GsrXXF7PDlucfInxnfqMPaUXuMoDVvo4aABPlAg6hxeQBJhb7TAW2I+y
         /rLxWTEpNGflKkDTvDdLmbVFXVprRjduJwDj1h1yBQItoTAYVccB6uUYnI0O+qM9hhdA
         WThw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kBopOcpcFnO8EGG+PF8LjIEPdrxkliis2fcATL22bFo=;
        b=W7+o3eoB5/iLh5Sh6qvQtWCJHdnlkRmoq6w+ZPbyayYGDCWV4WzYfY0lJSuRZiS1+W
         TnxaPXheJhXwtbwMYfKDaWP9Hmf/eBUg/rvXsMkvxYx76Rj6rglYUGrlFU3ZNwAHeFgG
         oJ/SEx8enFNlafPubnlNvCGkHf6h9BmA9Pad1DmwgwRpqIDXXNMjZyL31suKB4CnakKz
         IZ+XUOQUs7dWp2RbL2OilW7N4hSLbMATFzw27F8Ht7cs479qRL5TuxTIIbegeSkfmo3W
         3aPmYkyTbicBAU7dQk4C4VzkyCfbE7uB3bRsU/st4SDXHz3yPcQ24+0xzzwd0I7M5v6i
         HS5Q==
X-Gm-Message-State: AO0yUKVtt84pv7m0F4loYxuleFCJf8D9pnTnbfDsjqPzwTfA3qMG0TCW
        6eYnsA5gRStWA/gXIDwhRn2iPijLGeghNqF1
X-Google-Smtp-Source: AK7set8P0iLo1L5y6iv5jYqFkg3U3pQqOVhlFHayW8Hdb51oGhYLiS706f2tm3AanZtq0vOaDUo8hg==
X-Received: by 2002:a17:906:a102:b0:878:5e84:e1da with SMTP id t2-20020a170906a10200b008785e84e1damr8201181ejy.27.1675849968968;
        Wed, 08 Feb 2023 01:52:48 -0800 (PST)
Received: from ?IPV6:2003:f6:af31:7800:129e:49db:f7a0:83dc? (p200300f6af317800129e49dbf7a083dc.dip0.t-ipconnect.de. [2003:f6:af31:7800:129e:49db:f7a0:83dc])
        by smtp.gmail.com with ESMTPSA id r16-20020a170906a21000b00883ec4c63ddsm8110877ejy.146.2023.02.08.01.52.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Feb 2023 01:52:48 -0800 (PST)
Message-ID: <0ac184a7-4325-a1f7-b533-41a7e590c66c@grsecurity.net>
Date:   Wed, 8 Feb 2023 10:52:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v3 3/6] KVM: x86: Do not unload MMU roots when only
 toggling CR0.WP
Content-Language: en-US, de-DE
To:     Zhi Wang <zhi.wang.linux@gmail.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20230201194604.11135-1-minipli@grsecurity.net>
 <20230201194604.11135-4-minipli@grsecurity.net>
 <20230207153651.000067f8@gmail.com>
From:   Mathias Krause <minipli@grsecurity.net>
In-Reply-To: <20230207153651.000067f8@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07.02.23 14:36, Zhi Wang wrote:
> On Wed,  1 Feb 2023 20:46:01 +0100
> Mathias Krause <minipli@grsecurity.net> wrote:
> 
>> There is no need to unload the MMU roots for a direct MMU role when only
>> CR0.WP has changed -- the paging structures are still valid, only the
>> permission bitmap needs to be updated.
>>
>> One heavy user of toggling CR0.WP is grsecurity's KERNEXEC feature to
>> implement kernel W^X.
>>
> 
> Wouldn't it be better to factor out update_permission_bitmask and
> update_pkru_bitmask in a common function and call it from here? So that
> we can also skip: bunches of if..else..., recalculation of the rsvd mask
> and shadow_zero_bit masks.

Probably, yes. But I dislike the fact that this would imply that we know
about the details how kvm_init_mmu() and, moreover, init_kvm_tdp_mmu()
are implemented and I'd rather like to avoid that to not introduce bugs
or regressions via future code changes in either one of them. By calling
out to kvm_init_mmu() we avoid that implicitly as a future change, for
sure, must check all callers and would find this location. If we instead
simply extract the (as of now) required bits, that might go unnoticed.

That said, I agree that there's still room for improvements.

> I suppose this is a critical path according to the patch comments and
> kvm_init_mmu() is a non-critical path. Is it better to seperate 
> them now for saving the maintanence efforts in future? E.g. something heavier 
> might be introduced into the kvm_init_mmu() path and slows down this path.

I'll look into what can be done about it. But this change is a first
step that can be further optimized via follow up changes.

As you can see from the numbers below, it's already way faster that what
we have right now, so I'd rather land this (imperfect) change sooner
than later and gradually improve on it. This will, however, likely only
bring minor speedups compared to this change, so they're less important,
IMHO.

The question is really what's better from a maintenance point of view:
Keeping the call to the commonly used kvm_init_mmu() function or special
case even further? I fear the latter might regress easier, but YMMV, of
course.

> 
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
>> +		kvm_init_mmu(vcpu);
>> +		return;
>> +	}
>> +
>>  	if ((cr0 ^ old_cr0) & X86_CR0_PG) {
>>  		kvm_clear_async_pf_completion_queue(vcpu);
>>  		kvm_async_pf_hash_reset(vcpu);
> 
