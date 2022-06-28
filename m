Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 847CE55EC8C
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 20:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235383AbiF1SYk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 14:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233337AbiF1SYh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 14:24:37 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFE2F20F74
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 11:24:36 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id s124so18415293oia.0
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 11:24:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4bunQJpmmAb3BdZdmn9RMq2ZoxsILJiBFu8enbhi+hE=;
        b=GjYWvZ78fsIJ8M7VOwUl+yKS9FowIgitb9yk/Puc0kk2B+dC34jo+OjsivVywMekEj
         MSxh4q0bIUw4jZpkDwevrWN1vu/YgMKvhVplDsJ/5BeQh25dPYZMZtDRXrfqoLDzMBnK
         78QCd5Uha9XmsQxguc+Xrnj4OifgAXSGWI6E0/dB+7NK7qs2uWmW7sTsEqAiiUY1+IGo
         VBL/A7pKIts77vUMUsV7lTqt3sOm41Dvzgdct4PTHmsLJFRRO9xPpAq5Kvt2+WKbK9Be
         d72rYnlKiSpr1vY7GnuIK69P2BiXfEzpe+tErPNnDYY/r+CHbW1VBt/AsUroHe6AZRxD
         K5Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4bunQJpmmAb3BdZdmn9RMq2ZoxsILJiBFu8enbhi+hE=;
        b=sinjvZuxX+JYMRgnYIH0JF5NuDRIF9fsPym998qt6pxJvDi85unU1/HWebC22zBckK
         OPWwaewcLDcLlRKlo0sOO32jPvtlw/mnfY56TReA/gdANq90tA0ADC5BYvg0GIc6SVdy
         8DB4fg3jK2rhGaI+/vPuXCZyBgXMmHPDajHOjS0oE1UqvJa6LN1GuRUK/3IBEsyxUOYM
         8Yov9fhjdhV5T42P9F1ALAUapOun30wY9vzE1/tagGL7Xlvftqv4O22w3C9HUv4BRU2W
         Gb8F244vzpkF9s0Q445v5N565I0TBUqaOqLl7ydYrzgYPEeO4aqWA85cGUEq+w5PstQs
         EBOw==
X-Gm-Message-State: AJIora9C0ITXW2S+KxwcQs3rijpbbAUMkk3B04sNIvu2L4jSNnYtJQK7
        HJUUs4c09vu45i/w2kB4xe2JqU5oyRuPRKIupt3b+8PyDtQ=
X-Google-Smtp-Source: AGRyM1u30ReR6a3qW6TgLvykCnyjaPF0D28UW1wlEV3pOdIezVJ78p8+G73jRjCvNFIP5cS9qfqxMDw40N906gEazBc=
X-Received: by 2002:a05:6808:2124:b0:335:7483:f62d with SMTP id
 r36-20020a056808212400b003357483f62dmr653929oiw.112.1656440676037; Tue, 28
 Jun 2022 11:24:36 -0700 (PDT)
MIME-Version: 1.0
References: <bug-216177-28872@https.bugzilla.kernel.org/> <bug-216177-28872-0chfaxaqsi@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216177-28872-0chfaxaqsi@https.bugzilla.kernel.org/>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 28 Jun 2022 11:24:25 -0700
Message-ID: <CALMp9eQch3QTEKGth5LUvMc4gpphseto3mtakvYFnWWdQZoiEg@mail.gmail.com>
Subject: Re: [Bug 216177] kvm-unit-tests vmx has about 60% of failure chance
To:     bugzilla-daemon@kernel.org
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 27, 2022 at 11:32 PM <bugzilla-daemon@kernel.org> wrote:
>
> https://bugzilla.kernel.org/show_bug.cgi?id=216177
>
> --- Comment #9 from Yang Lixiao (lixiao.yang@intel.com) ---
> (In reply to Jim Mattson from comment #8)
> > On Mon, Jun 27, 2022 at 8:54 PM Nadav Amit <nadav.amit@gmail.com> wrote:
> >
> > > The failure on bare-metal that I experienced hints that this is either a
> > test
> > > bug or (much less likely) a hardware bug. But I do not think it is likely
> > to
> > > be
> > > a KVM bug.
> >
> > KVM does not use the VMX-preemption timer to virtualize L1's
> > VMX-preemption timer (and that is why KVM is broken). The KVM bug was
> > introduced with commit f4124500c2c1 ("KVM: nVMX: Fully emulate
> > preemption timer"), which uses an L0 CLOCK_MONOTONIC hrtimer to
> > emulate L1's VMX-preemption timer. There are many reasons that this
> > cannot possibly work, not the least of which is that the
> > CLOCK_MONOTONIC timer is subject to time slew.
> >
> > Currently, KVM reserves L0's VMX-preemption timer for emulating L1's
> > APIC timer. Better would be to determine whether L1's APIC timer or
> > L1's VMX-preemption timer is scheduled to fire first, and use L0's
> > VMX-preemption timer to trigger a VM-exit on the nearest alarm.
> > Alternatively, as Sean noted, one could perhaps arrange for the
> > hrtimer to fire early enough that it won't fire late, but I don't
> > really think that's a viable solution.
> >
> > I can't explain the bare-metal failures, but I will note that the test
> > assumes the default treatment of SMIs and SMM. The test will likely
> > fail with the dual-monitor treatment of SMIs and SMM. Aside from the
> > older CPUs with broken VMX-preemption timers, I don't know of any
> > relevant errata.
> >
> > Of course, it is possible that the test itself is buggy. For the
> > person who reported bare-metal failures on Ice Lake and Cooper Lake,
> > how long was the test in VMX non-root mode past the VMX-preemption
> > timer deadline?
>
> On the first Ice lake:
> Test suite: vmx_preemption_timer_expiry_test
> FAIL: Last stored guest TSC (28067103426) < TSC deadline (28067086048)
>
> On the second Ice lake:
> Test suite: vmx_preemption_timer_expiry_test
> FAIL: Last stored guest TSC (27014488614) < TSC deadline (27014469152)
>
> On Cooper lake:
> Test suite: vmx_preemption_timer_expiry_test
> FAIL: Last stored guest TSC (29030585690) < TSC deadline (29030565024)

Wow! Those are *huge* overruns. What is the value of MSR 0x9B on these hosts?
