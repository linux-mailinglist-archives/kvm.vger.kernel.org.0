Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7A6F69B034
	for <lists+kvm@lfdr.de>; Fri, 17 Feb 2023 17:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbjBQQH5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Feb 2023 11:07:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbjBQQHz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Feb 2023 11:07:55 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4771410DF
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 08:07:48 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id l11so6589906edb.11
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 08:07:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gvz/PlOxVkjn4hsOF5UMdaOD4Obyi55/9qlltRO+pHM=;
        b=Si70hAjsWNOhnugjYEa79ZVyUzplEm9+PndtaS0hoclHL9UnzN0JhxTieUi3fQaHHM
         2FmSh78EiCwUht5Jml77VjH3BO3UmquoeDHd+X4Ggy5ZopD73jbJFZ4V2bGrbSig1lZs
         lN9gHY2SNW8BtSUHxMoHGRXJI/XgJRU2tI4AiUW2LEU2JObnMN2RGfWWV/WulYJmV00d
         UJrwYzhlU8I7x0vsGpjtp5P30bDdKTEwhuGsXRRe6OND0a1DDxUe7s/wfrkO6EujawNj
         UZGa2yQSm9ovwmQ5BLtasTOzl1Gp75nj6ZVXzPxoclSXR9Sac35QhSqVTg0zePL7OBdL
         X2tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gvz/PlOxVkjn4hsOF5UMdaOD4Obyi55/9qlltRO+pHM=;
        b=miNIl6TMouk3bGGwUY029J25w9D76FHhSpwUdCaypmBhWILTRpA+nklXNkkdGGtqOn
         zVQ5FlBvnV6qB0CFBW2FLDM2UG4u0yxkru0vkjf0xK8yDrzB5WtN8UuFWNy8INE6akKb
         J7q+h4nrHbCi2RPpmTCWuwzljVqZWEOODwPu7F3boo5kH5SDNCLjqi0N8gkUdefJycHx
         XW/ngLngOW8FIT4G8aqNHKrbb7PFgIO2nqeuERSmv6ulShSdCEveIH2Xp/nJ/L2yzrWO
         57pkSB3/mvwNsZORXxjd786QaDVAAGUXC0xymDExtiLA2955Sy+nbCSAz4wrbA0QtErP
         dOOg==
X-Gm-Message-State: AO0yUKWGGZrwZ04eK5OfffP9L97RkjJS6cEd1aJqW325eqHrtZlQefeS
        YnFQDhFbB8OM30+9VU06HSZh/A==
X-Google-Smtp-Source: AK7set/JpCwktCs1oTQtJNycSpMSWyMeVI9aRczPjYx1j7tV8jmh58ba2/S6pXuwLlXnHwq5oBZtzQ==
X-Received: by 2002:a17:907:c00b:b0:8af:3739:bdd7 with SMTP id ss11-20020a170907c00b00b008af3739bdd7mr5910406ejc.27.1676650066682;
        Fri, 17 Feb 2023 08:07:46 -0800 (PST)
Received: from ?IPV6:2003:f6:af46:5a00:93e3:335:818b:a454? (p200300f6af465a0093e30335818ba454.dip0.t-ipconnect.de. [2003:f6:af46:5a00:93e3:335:818b:a454])
        by smtp.gmail.com with ESMTPSA id gh15-20020a170906e08f00b008720c458bd4sm2281730ejb.3.2023.02.17.08.07.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Feb 2023 08:07:46 -0800 (PST)
Message-ID: <2c2f77a3-1d77-0d88-991a-60dcdc370ea8@grsecurity.net>
Date:   Fri, 17 Feb 2023 17:07:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH 0/5] KVM: Put struct kvm_vcpu on a diet
Content-Language: en-US, de-DE
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20230213163351.30704-1-minipli@grsecurity.net>
 <Y+pt5MGR+EjLH4qQ@google.com>
 <13deaeb6-dfb2-224c-0aa3-5546ad426f63@grsecurity.net>
 <Y+5okhlB4rkXjKWS@google.com>
From:   Mathias Krause <minipli@grsecurity.net>
In-Reply-To: <Y+5okhlB4rkXjKWS@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16.02.23 18:32, Sean Christopherson wrote:
> On Tue, Feb 14, 2023, Mathias Krause wrote:
>> On 13.02.23 18:05, Sean Christopherson wrote:
>> However, I still remain confident that this makes sense from a uarch point of
>> view. Touching less cache lines should be a win -- even if I'm unable to
>> measure it. By preserving more cachelines during a VMEXIT, guests should be
>> able to resume their work faster (assuming they still need these cachelines).
> 
> Yes, but I'm skeptical that compacting struct kvm_vcpu will actually result in
> fewer cache lines being touched, at least not in a persistent, maintainable way.
> While every VM-Exit accesses a lot of state, it's most definitely still a small
> percentage of kvm_vcpu.  And for the VM-Exits that really benefit from optimized
> handling, a.k.a. the fastpath exits, that percentage is even lower.

Yeah, that's probably true.

> On x86, kvm_vcpu is actually comprised of three "major" structs: kvm_vcpu,
> kvm_vcpu_arch, and vcpu_{vmx,svm}.  The majority of fields accessed on every VM-Exit
> are in the vendor part, vcpu_{vmx,svm}, but there are still high-touch fields in
> the common structures, e.g. registers in kvm_vcpu_arch and things like requests
> in kvm_vcpu.
> 
> Naively compating any of the three (well, four) structures might result in fewer
> cache lines being touched, but mostly by coincidence.  E.g. because compacting
> part of kvm_vcpu_arch happened to better align vcpu_vmx, not because of the
> compaction itself.

Fortunately, kvm_vcpu is embedded as first member in vcpu_{vmx,svm}, so
all three share a common "header." Optimizations done for kvm_vcpu will
therefore benefit the vendor specific structures too. However, you're
right that this will implicitly change the layout for the remainder of
vcpu_{vmx,svm} and might even have a negative impact regarding cacheline
usage. But, as my changes chop off exactly 128 bytes from kvm_vcpu,
that's not the case here. But I can see that this is "coincidence" and
fragile in the long run.

> If we really wanted to optimize cache line usage, our best bet would be to identify
> the fields that are accessed in the fastpath run loop and then pack those fields
> into as few cache lines as possible.  And to do that in a maintainable way, we'd
> probably need something like ASI[*] to allow us to detect changes that result in
> the fastpath handling accessing fields that aren't in the cache-optimized region.
> 

> I'm not necessarily opposed to such aggressive optimization, but the ROI is likely
> very, very low.  For optimized workloads, there simply aren't very many VM-Exits,
> e.g. the majority of exits on a modern CPU are due to timer ticks.  And even those
> will hopefully be eliminiated in the not-too-distant future, e.g. by having hardware
> virtualize the TSC deadline timer, and by moving to a vCPU scheduling scheme that
> allows for a tickless host.

Well, for guests running grsecurity kernels, there's also the CR0.WP
toggling triggering VMEXITs, which happens a lot! -- at least until
something along the lines of [1] gets merged *hint ;)*

[1]
https://lore.kernel.org/all/20230201194604.11135-1-minipli@grsecurity.net/

>  
> https://lore.kernel.org/all/20220223052223.1202152-1-junaids@google.com

Heh, that RFC is from February last year and it looks like it stalled at
that point. But I guess you only meant patch 44 anyway, that splits up
kvm_vcpu_arch:
https://lore.kernel.org/all/20220223052223.1202152-45-junaids@google.com/.
It does that for other purposes, though, which might conflict with the
performance aspect I'm mostly after here. Anyways, I got your point. If
we care about cacheline footprint, we should do a more radical change
and group hot members together instead of simply shrinking the structs
involved.

>>> And as you observed, imperfect struct layouts are highly unlikely to have a
>>> measurable impact on performance.  The types of operations that are involved in
>>> a world switch are just too costly for the layout to matter much.  I do like to
>>> shave cycles in the VM-Enter/VM-Exit paths, but only when a change is inarguably
>>> more performant, doesn't require ongoing mainteance, and/or also improves the code
>>> quality.
>>
>> Any pointers to measure the "more performant" aspect?
> 
> TL;DR: not really.
> 
> What I've done in the past is run a very tight loop in the guest, and then measure
> latency from the host by hacking KVM.  Measuring from the guest works, e.g. we have
> a variety of selftests that do exactly that, but when trying to shave cycles in
> the VM-Exit path, it doesn't take many host IRQs arriving at the "wrong" time to
> skew the measurement.  My quick-and-dirty solution has always been to just hack
> KVM to measure latency with IRQs disabled, but a more maintainable approach would
> be to add smarts somewhere to sanitize the results, e.g. to throw away outliers
> where the guest likely got interrupted.
> 
> I believe we've talked about adding a selftest to measure fastpath latency, e.g.
> by writing MSR_IA32_TSC_DEADLINE in a tight loop.
> 
> However, that's not going to be useful in this case since you are interested in
> measuring the impact of reducing the host's L1D footprint.  If the guest isn't
> cache-constrainted, reducing the host's cache footprint isn't going to impact
> performance since there's no contention.

Yeah, it's hard to find a test case measuring the gains. I looked into
running Linux userland workloads initially, but saw no real impact, as
the sdtdev was already too high. But, as you pointed out, a
micro-benchmark is of no use either, so it's all hand-waving only. :D

> Running a micro benchmark in the guest that aims to measure cache performance might
> work, but presumably those are all userspace tests, i.e. you'd end up measuring
> the impact of the guest kernel too.  And they wouldn't consistently trigger VM-Exits,
> so it would be difficult to prove the validity of the results.

Jepp. It's all just gut feeling, unfortunately.

> I suppose you could write a dedicated selftest or port a micro benchmark to run
> as a selftest (or KVM-unit-test)?
> 
>>  I tried to make use of the vmx_vmcs_shadow_test in kvm-unit-tests, as it's
>>  already counting cycles, but the numbers are too unstable, even if I pin the
>>  test to a given CPU, disable turbo mode, SMT, use the performance cpu
>>  governor, etc.
> 
> Heh, you might have picked quite possibly the worst way to measure VM-Exit
> performance :-)
> 
> The guest code in that test that's measuring latency runs at L2.  For VMREADs
> and VMWRITEs that are "passed-through" all the way to L2, no VM-Exit will occur
> (the access will be handled purely in ucode).  And for accesses that do cause a
> VM-Exit, I'm pretty sure they all result in a nested VM-Exit, which is a _very_
> heavy path (~10k cycles).  Even if the exit is handled by KVM (in L0), it's still
> a relatively slow, heavy path.

I see. I'll have a look at the selftests and see if I can repurpose one
of them. But, as you noted, a microbenchmark might not be what I'm
after. It's more about identifying the usage patterns for hot VMEXIT
paths and optimize these.

>>> I am in favor in cleaning up kvm_mmu_memory_cache as there's no reason to carry
>>> a sub-optimal layouy and the change is arguably warranted even without the change
>>> in size.  Ditto for kvm_pmu, logically I think it makes sense to have the version
>>> at the very top.
>>
>> Yeah, was exactly thinking the same when modifying kvm_pmu.
>>
>>> But I dislike using bitfields instead of bools in kvm_queued_exception, and shuffling
>>> fields in kvm_vcpu, kvm_vcpu_arch, vcpu_vmx, vcpu_svm, etc. unless there's a truly
>>> egregious field(s) just isn't worth the cost in the long term.
>>
>> Heh, just found this gem in vcpu_vmx:
>>
>> struct vcpu_vmx {
>>   [...]
>>   union vmx_exit_reason      exit_reason;
>>
>>   /* XXX 44 bytes hole, try to pack */
>>
>>   /* --- cacheline 123 boundary (7872 bytes) --- */
>>   struct pi_desc             pi_desc __attribute__((__aligned__(64)));
>>   [...]
>>
>> So there are, in fact, some bigger holes left.
> 
> Ya.  Again, I'm definitely ok cleaning up the truly heinous warts and/or doing
> a targeted, deliberate refactor of structures.  What I don't want to do is
> shuffle fields around purely to save a few bytes here and there.

Got it. I'll back out the reshuffling ones and only keep the ones for
kvm_pmu and kvm_mmu_memory_cache, as these are more like straight cleanups.

Thanks,
Mathias
