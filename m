Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 597485FBDE0
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 00:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbiJKWdG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Oct 2022 18:33:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiJKWdF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Oct 2022 18:33:05 -0400
Received: from mail-il1-x149.google.com (mail-il1-x149.google.com [IPv6:2607:f8b0:4864:20::149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AC2613D2C
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 15:33:04 -0700 (PDT)
Received: by mail-il1-x149.google.com with SMTP id z4-20020a921a44000000b002f8da436b83so11989432ill.19
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 15:33:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=TH9rm5DUnc3yh5L7FpVBiMQlb9WPPPK53Xel1Q6B1Vs=;
        b=nA3svbcm2LJc7eEAOQ0JFZW45OZKE/zTAtWmwTtCG9xxuCb2foH2Z/87Ld9ILzstRB
         AyHZSWz4cY7i7DU66Sa2sJDWNEkjat/FWdeJ1J3Jmzpq/9WzjTFCYJB4QDzS1a7hQeDk
         zsdKlSKfrtde2/Yq/Vni9x/QEIzNZEeTnuIGGcMx4UF7/UCvbst/XI6ipabO0EhPMnl5
         lmA1Zi/z+7hsDOQjcHGPkSYAw3Bd3pcVPhRtZ9OZWAknuQhihvT/bXCiPzvF0yEhQ6he
         FkELsGnQ37nER6WlPj2WYE78SpAv2ax0W841f5BJGKaW+Khau0mtS/h9yOQJ9pAAkPvN
         pPDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TH9rm5DUnc3yh5L7FpVBiMQlb9WPPPK53Xel1Q6B1Vs=;
        b=RLw87HsWgQs7CDF1DrttnbNvfJFicGe29r+Fnufwd/nSI7VKRrPPx2n+QiJNe+gWV2
         TgPktbhv/yt/MoaDnx5i8tQQcoVovjZAXGp7kalenrXcaauZPG5q9NwUhCLuE8RhJs98
         ppm9cgSO83RGaswy3fC0csm1IuUtbI7spm6x1WnIHgyO5C1Kv8e7F/8kkhTjj1wPFpDy
         5uJthkYz5/u0s48mhpkNGZSkmw6OZKXchNZNGRwzFKOm4Hx7qWY2Y4uANpA0+1h3awcl
         mLBs0xEgv14y8jqMoma64rI4g6TEORUxbd50zSr3XtJPaCdHjL6HEqs1BBd6QVCQu9Jh
         zzFA==
X-Gm-Message-State: ACrzQf30+mW+d8juah8EZdV0wWLWiBGDTxt5eUhmAXCORVARNX4exC1j
        DbB+eKUHHlQ75vYWbeKNvDYAWa/naunHnYV7yQ==
X-Google-Smtp-Source: AMsMyM5Z4dk9HazMyOEJyzH+X1w/y7GTO4Re6seW2BQh2dggvlrq6gw0b///osq3wbm3IKQjUoTB+wzNK+5bUKzcPA==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6638:2385:b0:35a:623b:b2ca with
 SMTP id q5-20020a056638238500b0035a623bb2camr13860354jat.24.1665527583841;
 Tue, 11 Oct 2022 15:33:03 -0700 (PDT)
Date:   Tue, 11 Oct 2022 22:33:02 +0000
In-Reply-To: <Y0W1cABIcI1FpDkc@google.com> (message from Sean Christopherson
 on Tue, 11 Oct 2022 18:26:56 +0000)
Mime-Version: 1.0
Message-ID: <gsnt4jwa2dpd.fsf@coltonlewis-kvm.c.googlers.com>
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

> On Tue, Oct 11, 2022, Colton Lewis wrote:
>> Sean Christopherson <seanjc@google.com> writes:

>> > On Mon, Sep 12, 2022, Colton Lewis wrote:
>> > > Implement random number generation for guest code to randomize parts
>> > > of the test, making it less predictable and a more accurate  
>> reflection
>> > > of reality.

>> > > Create a -r argument to specify a random seed. If no argument is
>> > > provided, the seed defaults to 0. The random seed is set with
>> > > perf_test_set_random_seed() and must be set before guest_code runs to
>> > > apply.

>> > > The random number generator chosen is the Park-Miller Linear
>> > > Congruential Generator, a fancy name for a basic and well-understood
>> > > random number generator entirely sufficient for this purpose. Each
>> > > vCPU calculates its own seed by adding its index to the seed  
>> provided.

>> > Why not grab the kernel's pseudo-RNG from prandom_seed_state() +
>> > prandom_u32_state()?

>> The guest is effectively a minimal kernel running in a VM that doesn't
>> have access to this, correct?

> Oh, I didn't mean link to the kernel code, I meant "why not copy+paste  
> the kernel
> code?".  In other words, why select a different RNG implementation than  
> what the
> kernel uses?  In general, selftests and tools try to follow the kernel  
> code, even
> when copy+pasting, as that avoids questions like "why does the kernel do  
> X but
> selftests do Y?".  The copy+paste does sometimes lead to maintenance  
> pain, e.g. if
> the copied code has a bug that the kernel then fixes, but that seems  
> unlikely to
> happen in this case.

The real answer is I didn't know about it at the time. But I do think
the prandom_32_state seems like overkill for this application.
