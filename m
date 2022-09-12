Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC28C5B6189
	for <lists+kvm@lfdr.de>; Mon, 12 Sep 2022 21:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbiILTOi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Sep 2022 15:14:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230342AbiILTOf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Sep 2022 15:14:35 -0400
Received: from mail-io1-xd4a.google.com (mail-io1-xd4a.google.com [IPv6:2607:f8b0:4864:20::d4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B9542BF9
        for <kvm@vger.kernel.org>; Mon, 12 Sep 2022 12:14:32 -0700 (PDT)
Received: by mail-io1-xd4a.google.com with SMTP id u9-20020a5edd49000000b006a0f03934e9so3596032iop.4
        for <kvm@vger.kernel.org>; Mon, 12 Sep 2022 12:14:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date;
        bh=oQbJqfr/YitJdbulIUuGCDwyPFxkW5qVyrqlQnIQoMM=;
        b=C52avh2Q7pAsCG4bYBK+3XK+cb9QUotZKF3b1l104rLu4RLSwXR6ZF0ZIZME2sks2e
         0+vLvA65pHy0weiVrZU1BBmnT263MoYVKwAGceEJHpFlm2Yf6wgURGGSDSDzH+NyVoKH
         5xhdwb5uhQoXdd/sadZ9dtFZf9WM0yAPKCgvmHmJxqq9KPWlvXyWWQBoaBZi3vw7UA4e
         nyjN6Hu7CHWnFDaOJ3/kjyQhBSA2ZDfhfxB3k95HXlHJ9ok9sQO6dqI1TOr0n2Vjf2r9
         /tp4WB38nt2ymY1uWaCqaIb7lGnmDtA47dYSIybisuTTlCe36LtOGdgoDCWpNY4PcspU
         07kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=oQbJqfr/YitJdbulIUuGCDwyPFxkW5qVyrqlQnIQoMM=;
        b=AOObAAHrcLxB/UBHI/tzLnanyuFDvfR6rgE6E5XF8TK+gwaG9Kn50cNsB9YV7JnUbk
         ArCCjS0KBRaounV6sHrZDb+N/t5P/CM9LqtEMZafAnkq8tIF4kBOPWWDmRmC/LRJbXcb
         A1dMSQaM/4FZrETQceh3igVAvmKtCWUwyyY2zLJmu9W1Xsi3UwIe0m4RM9mO5FsNcnia
         0Fwn2UvvRbI2/wkyhBxEh3IVsCQbvM/3ovUbwVmvLjdN/UdVLTz+FGCJ9oFQ0rUdinlE
         TK1LygCTLqimq8k1zO/xD0pmm7k2D7NSR+NduJ/r1skFxXoEtDgQ/XP1VL18yZ24udJh
         njig==
X-Gm-Message-State: ACgBeo0D0cJe/hsM1sI2WJSBcC0P42QABdsc2lb94cYLlxiRJ57Qsv2s
        CMNwYP3Av8EY5QzW+KSggjMEfKGXuFL04cgU9g==
X-Google-Smtp-Source: AA6agR45TieSkLZT2K6qSzgDnJfeWFs56Q5y+F9IKrCLGZ8Eqvx/0C6s04TeS0rCrFwt7DpmLEN6adAFwd32rIxaKw==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6602:1352:b0:69d:e793:abd with
 SMTP id i18-20020a056602135200b0069de7930abdmr10128721iov.172.1663010071726;
 Mon, 12 Sep 2022 12:14:31 -0700 (PDT)
Date:   Mon, 12 Sep 2022 19:14:30 +0000
In-Reply-To: <CALzav=dsZAFpA7pDHaMJw6BnZMKw5B1T9nWDsTHU-vBLhf-GNA@mail.gmail.com>
 (message from David Matlack on Fri, 9 Sep 2022 10:41:01 -0700)
Mime-Version: 1.0
Message-ID: <gsntedwgpfqh.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v5 3/3] KVM: selftests: randomize page access order
From:   Colton Lewis <coltonlewis@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     ricarkol@google.com, kvm@vger.kernel.org, pbonzini@redhat.com,
        maz@kernel.org, seanjc@google.com, oupton@google.com,
        andrew.jones@linux.dev
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

David Matlack <dmatlack@google.com> writes:

> On Fri, Sep 9, 2022 at 10:31 AM Ricardo Koller <ricarkol@google.com>  
> wrote:

>> On Fri, Sep 09, 2022 at 10:26:10AM -0700, David Matlack wrote:
>> > On Fri, Sep 09, 2022 at 12:43:00PM +0000, Colton Lewis wrote:
>> > > Create the ability to randomize page access order with the -a
>> > > argument, including the possibility that the same pages may be hit
>> > > multiple times during an iteration or not at all.
>> > >
>> > > Population sets random access to false.
>> >
>> > Please make sure to also explain the why in addition to the what.
>> >

Will do.

>> > > @@ -57,7 +58,13 @@ void perf_test_guest_code(uint32_t vcpu_id)
>> > >
>> > >     while (true) {
>> > >             for (i = 0; i < pages; i++) {
>> > > -                   uint64_t addr = gva + (i * pta->guest_page_size);
>> > > +                   guest_random(&rand);
>> > > +
>> > > +                   if (pta->random_access)
>> > > +                           addr = gva + ((rand % pages) *  
>> pta->guest_page_size);
>> > > +                   else
>> > > +                           addr = gva + (i * pta->guest_page_size);
>> > > +
>> > >                     guest_random(&rand);
>> >
>> > Is it on purpose use a separate random number for access offset and
>> > read/write?
>> >

>> It's because of the following, from  
>> https://lore.kernel.org/kvm/YxDvVyFpMC9U3O25@google.com/

>>          I think addr and write_percent need two different random numbers.
>>          Otherwise, you will end up with a situation where all addresses  
>> where
>>          (rnd_arr[i] % 100 < pta->write_percent) will get a write  
>> (always).
>>          Something like this:

>>                  012345678    <= address
>>                  wwwrrrwww
>>                  837561249    <= access order

>>          I think the best way to fix this is to abstract the random number
>>          reading into something like get_next_rand(), and use it twice per
>>          iteration.

> Makes sense. Depending on how many bits of randomness we need (e.g.
> read/write only needs 7) we could still use one random number. But the
> bit manipulation would probably more complex than just generating
> another random number (which looks like a fairly cheap calculation).

> Colton can you add a comment here to explain the subtlety?


Will do.
