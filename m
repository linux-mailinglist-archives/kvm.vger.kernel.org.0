Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20E706CCC46
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 23:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbjC1VwD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 17:52:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbjC1VwC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 17:52:02 -0400
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C5611B8
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 14:52:01 -0700 (PDT)
Received: by mail-il1-x14a.google.com with SMTP id i7-20020a056e021b0700b0031dc4cdc47cso9113264ilv.23
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 14:52:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680040320;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=jrbWmy/msHACqyJzbLS8J8+RsCE+wwj3fQmHMdANKeY=;
        b=NzO8572j47xPn5O6aTU0ZQz8JchtdQS+nLjMBafy3OMUCJaJR7kKzK21M9+zw5dZ/2
         muAnT0quOlPpikhoWxpUL9oSVqaXu+g13/Jv4/Yl/MYZHFnX0JjwitNFolUFLJvoJBWD
         z2vmPEUivpkkVf5HEyCu4jEN8IdxDB0Bs69q+hY6Mi576WJvL5JTAs+K6O2HQ3Uwgdtp
         BLoqIM8zSBctMINsDXTTB/BVmEwjFpaVEpgsTyYOnbcvAiDOSy9pfQ8VyKYSmKKlDmdW
         hoB1eWcnJWZYTAk71JVdrWyuBUSWxw+Zinw9npyZhWkbs+o+x0GG7cKukPEjhuXx2Ph5
         J9xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680040320;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jrbWmy/msHACqyJzbLS8J8+RsCE+wwj3fQmHMdANKeY=;
        b=bt6AECgae45GPDhAFtnnG2abb41Ax0Y8RT5gFeF4OjXwLG7YG89OcPYT/1GQIot7Fz
         yONEYuOkFaVDrLHcnBO2oyI93XhF7OdwZ2msTXGvncPg+4N/+WMrgxItHdlCnisZ6QVd
         /wlbI1P5yL/dzqYmyQBegVxVWK2lkBVSwMwTeD6+EBxv6noqL8EPwsv8LDFSkdJVC4Eu
         qwGnsHt+JlprdkluCdys4UWjC2D1TioFmtIrItV9d74FPH9Gm4yisw3gpFddF+7TMNvO
         j7rOchsQreq7ZLetO/puH+BDKgCThRvFzJniAE+vErHHv4OO+zEu58k9iMO5XwmsQMyP
         3++Q==
X-Gm-Message-State: AAQBX9dAsGzhwR5m2SJpQoRgbio/6+CgkVksXF+OWhFTsO2oyKH10CFO
        wkzwZAaiI4FdvrXvbxXOlbzpAEM3+Bs8HfIx1w==
X-Google-Smtp-Source: AKy350ZFlypjqnliV0Pvj2Z9cIceg05qrxb5IgsSVvQ1rtktmRC84gwdefyuY2gRbeGCiwSolvjBuU8LCfYp9bHk4A==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a02:95c3:0:b0:3eb:3166:9da4 with SMTP
 id b61-20020a0295c3000000b003eb31669da4mr61886jai.2.1680040320519; Tue, 28
 Mar 2023 14:52:00 -0700 (PDT)
Date:   Tue, 28 Mar 2023 21:51:59 +0000
In-Reply-To: <86r0t9w5jp.wl-maz@kernel.org> (message from Marc Zyngier on Tue,
 28 Mar 2023 11:09:46 +0100)
Mime-Version: 1.0
Message-ID: <gsntcz4s7dds.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v2 1/2] KVM: selftests: Provide generic way to read system counter
From:   Colton Lewis <coltonlewis@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     pbonzini@redhat.com, shuah@kernel.org, seanjc@google.com,
        dmatlack@google.com, vipinsh@google.com, andrew.jones@linux.dev,
        bgardon@google.com, ricarkol@google.com, oliver.upton@linux.dev,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Marc Zyngier <maz@kernel.org> writes:

> On Tue, 21 Mar 2023 19:10:04 +0000,
> Colton Lewis <coltonlewis@google.com> wrote:

>> Marc Zyngier <maz@kernel.org> writes:

>> >> +#define MEASURE_CYCLES(x)			\
>> >> +	({					\
>> >> +		uint64_t start;			\
>> >> +		start = cycles_read();		\
>> >> +		x;				\

>> > You insert memory accesses inside a sequence that has no dependency
>> > with it. On a weakly ordered memory system, there is absolutely no
>> > reason why the memory access shouldn't be moved around. What do you
>> > exactly measure in that case?

>> cycles_read is built on another function timer_get_cntct which includes
>> its own barriers. Stripped of some abstraction, the sequence is:

>> timer_get_cntct (isb+read timer)
>> whatever is being measured
>> timer_get_cntct

>> I hadn't looked at it too closely before but on review of the manual
>> I think you are correct. Borrowing from example D7-2 in the manual, it
>> should be:

>> timer_get_cntct
>> isb
>> whatever is being measured
>> dsb
>> timer_get_cntct

> That's better, but also very heavy handed. You'd be better off
> constructing an address dependency from the timer value, and feed that
> into a load-acquire/store-release pair wrapping your payload.

I can do something like that.


>> >> +		cycles_read() - start;		\

>> > I also question the usefulness of this exercise. You're comparing the
>> > time it takes for a multi-GHz system to put a write in a store buffer
>> > (assuming it didn't miss in the TLBs) vs a counter that gets updated
>> > at a frequency of a few tens of MHz.

>> > My guts feeling is that this results in a big fat zero most of the
>> > time, but I'm happy to be explained otherwise.


>> In context, I'm trying to measure the time it takes to write to a buffer
>> *with dirty memory logging enabled*. What do you mean by zero? I can
>> confirm from running this code I am not measuring zero time.

> See my earlier point: the counter tick is a few MHz, and the CPU
> multiple GHz. So unless "whatever" is something that takes a
> significant time (several thousands of CPU cycles), you'll measure
> nothing using the counter. Page faults will probably show, but not a
> normal access.

> The right tool for this job is to use PMU events, as they count at the
> CPU frequency.

Thanks. I understand you clearly now. I think it works out to tens of
cpu cycles, not thousands to observe a timer tick in the usual case
(2 GHz / 25 MHz = 80, of course slower timers exist), but I agree with
you a more precise tool is called for.
