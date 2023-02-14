Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1225696366
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 13:20:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232294AbjBNMUA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 07:20:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232228AbjBNMTl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 07:19:41 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 083AD279B2
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 04:19:15 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id y1so15450038wru.2
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 04:19:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=o+pcbmPUt7ucXTMejkTVCbJMfV8kCxmzBsuK/5V4ikQ=;
        b=DeNi2sWRj0VwoeJ1/pn7CfvmTEnwm347qpAIx0K+ICZPUpykUv0vv0w+vS12lriOxl
         zgkOgtn8RLZG+YnHvCFVpH8vsEMuoaIkdqmL+LgSwWczISLvRxh70DHPs1VjkIzeoJjl
         t+i47n3CrIp+WGyr/tpIiobX4TYROfN1UD/125zu2KcevcWhGjqKWeWWuEMpoWHXba8s
         fKMRtY7jPoPIye2UEfMDCXNNCafryQJIFcgCEmnZxBXO0BeYcIRhAsi5tGOkyMg1nuVT
         LpllOuSMcsxwufJ7IAfraCqn3Elp9Oc5tEjUl5zhXkCxoyPJA+JyFQyQzVOWT1nL7wyV
         PKVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o+pcbmPUt7ucXTMejkTVCbJMfV8kCxmzBsuK/5V4ikQ=;
        b=VQkc1535ADbQIj5beSYnlktDQx4Qeu45tW+k+OtXSTUvKvMaSAJh1B7OciMr4+3rBB
         gLD+FVX6lisRs5MpQ8fUr96Hgjgrdtt1h/NSSRgWw5/uBySpOL3dd1No+L3PUvvv1QQe
         MN0yQn1CtKo/YWu/J6Ivxh+EGhxio/5KBjXBH/SBbHnoGYr8GBAkfu5XFwAIjHtdtdZ5
         XmOeY/KN/TCDr6W8Up0KipM/8N+y5pDObBV+T9ywaMVbie59FenolrMWPWJQ3XgHBSFP
         OOZiHZMuTCQQ43PfA2k8+ekzeRBwIXILb5+wnXJwsTqRWoitEiUoM5F7FHoq63SEfaKk
         WvEQ==
X-Gm-Message-State: AO0yUKWg0rn5H9iSDDObG/9hOVNXn/rFLzJUO+megilFqrqIM3yVZwBx
        UPbWSZcS3Gt8GmX2vDi//xAMbQ==
X-Google-Smtp-Source: AK7set8953co7QYRnUzErsT2Q29KFxYLHPL4gDFOVcuBI2Y6US+eNm5w3mvY7vLmVy4bk4mZL9SW4g==
X-Received: by 2002:adf:fd50:0:b0:2c4:71b1:3160 with SMTP id h16-20020adffd50000000b002c471b13160mr2149046wrs.42.1676377154426;
        Tue, 14 Feb 2023 04:19:14 -0800 (PST)
Received: from ?IPV6:2003:f6:af20:a800:4c1e:9f81:fad8:f3dc? (p200300f6af20a8004c1e9f81fad8f3dc.dip0.t-ipconnect.de. [2003:f6:af20:a800:4c1e:9f81:fad8:f3dc])
        by smtp.gmail.com with ESMTPSA id s8-20020adfecc8000000b002c5509ab3d1sm7935496wro.83.2023.02.14.04.19.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Feb 2023 04:19:14 -0800 (PST)
Message-ID: <13deaeb6-dfb2-224c-0aa3-5546ad426f63@grsecurity.net>
Date:   Tue, 14 Feb 2023 13:19:12 +0100
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
From:   Mathias Krause <minipli@grsecurity.net>
In-Reply-To: <Y+pt5MGR+EjLH4qQ@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13.02.23 18:05, Sean Christopherson wrote:
> On Mon, Feb 13, 2023, Mathias Krause wrote:
>> Relayout members of struct kvm_vcpu and embedded structs to reduce its
>> memory footprint. Not that it makes sense from a memory usage point of
>> view (given how few of such objects get allocated), but this series
>> achieves to make it consume two cachelines less, which should provide a
>> micro-architectural net win. However, I wasn't able to see a noticeable
>> difference running benchmarks within a guest VM -- the VMEXIT costs are
>> likely still high enough to mask any gains.
> 
> ...
> 
>> Below is the high level pahole(1) diff. Most significant is the overall
>> size change from 6688 to 6560 bytes, i.e. -128 bytes.
> 
> While part of me wishes KVM were more careful about struct layouts, IMO fiddling
> with per vCPU or per VM structures isn't worth the ongoing maintenance cost.
> 
> Unless the size of the vCPU allocation (vcpu_vmx or vcpu_svm in x86 land) crosses
> a meaningful boundary, e.g. drops the size from an order-3 to order-2 allocation,
> the memory savings are negligible in the grand scheme.  Assuming the kernel is
> even capable of perfectly packing vCPU allocations, saving even a few hundred bytes
> per vCPU is uninteresting unless the vCPU count gets reaaally high, and at that
> point the host likely has hundreds of GiB of memory, i.e. saving a few KiB is again
> uninteresting.

Fully agree! That's why I said, this change makes no sense from a memory
usage point of view. The overall memory savings are not visible at all,
recognizing that the slab allocator isn't able to put more vCPU objects
in a given slab page. However, I still remain confident that this makes
sense from a uarch point of view. Touching less cache lines should be a
win -- even if I'm unable to measure it. By preserving more cachelines
during a VMEXIT, guests should be able to resume their work faster
(assuming they still need these cachelines).

> And as you observed, imperfect struct layouts are highly unlikely to have a
> measurable impact on performance.  The types of operations that are involved in
> a world switch are just too costly for the layout to matter much.  I do like to
> shave cycles in the VM-Enter/VM-Exit paths, but only when a change is inarguably
> more performant, doesn't require ongoing mainteance, and/or also improves the code
> quality.

Any pointers to measure the "more performant" aspect? I tried to make
use of the vmx_vmcs_shadow_test in kvm-unit-tests, as it's already
counting cycles, but the numbers are too unstable, even if I pin the
test to a given CPU, disable turbo mode, SMT, use the performance cpu
governor, etc.

> I am in favor in cleaning up kvm_mmu_memory_cache as there's no reason to carry
> a sub-optimal layouy and the change is arguably warranted even without the change
> in size.  Ditto for kvm_pmu, logically I think it makes sense to have the version
> at the very top.

Yeah, was exactly thinking the same when modifying kvm_pmu.

> But I dislike using bitfields instead of bools in kvm_queued_exception, and shuffling
> fields in kvm_vcpu, kvm_vcpu_arch, vcpu_vmx, vcpu_svm, etc. unless there's a truly
> egregious field(s) just isn't worth the cost in the long term.

Heh, just found this gem in vcpu_vmx:

struct vcpu_vmx {
  [...]
  union vmx_exit_reason      exit_reason;

  /* XXX 44 bytes hole, try to pack */

  /* --- cacheline 123 boundary (7872 bytes) --- */
  struct pi_desc             pi_desc __attribute__((__aligned__(64)));
  [...]

So there are, in fact, some bigger holes left.

Would be nice if pahole had a --density flag that would output some
ASCII art, visualizing which bytes of a struct are allocated by real
members and which ones are pure padding.
