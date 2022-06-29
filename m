Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F12255F369
	for <lists+kvm@lfdr.de>; Wed, 29 Jun 2022 04:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbiF2Ccu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 22:32:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiF2Ccu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 22:32:50 -0400
Received: from mail-oa1-x2a.google.com (mail-oa1-x2a.google.com [IPv6:2001:4860:4864:20::2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AEC3248EF
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 19:32:49 -0700 (PDT)
Received: by mail-oa1-x2a.google.com with SMTP id 586e51a60fabf-101ab23ff3fso19658330fac.1
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 19:32:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BGM8ETk9R3AnWsXEnehBm/qaTyX0MHE57aKC6QUY6Zw=;
        b=J3xfhWTCaOL9WECQaONqRlcn47jFJuVl/27j1BUe1H0jyiyez5RHIZL8iLV2kehbPU
         ouoCG8tXZ6VtoRt7oCwssDzCwsO54sp69XdYaLlQu9RPrxU5w8LmQvC6HsWVloB+zfdw
         Da0xorvATisQZUYc80MqMjhZFjiXUif7hV4YTp1l9C5MWbN06/vvaxYLBrX0MX6Jr1h+
         ROd4zwn4vM1z0IHys2t5KRWKRPVf+bYmuOeAeuxmIiW0pskhfolFJ3wJZZgRzxSbgHRE
         2hpLeq8F7LlHWpuYh7B0Ej6hwpYDrcgRGRm/yBr/vLVB2JuwEiL/v+gYkfO9K8ySv5xW
         JKiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BGM8ETk9R3AnWsXEnehBm/qaTyX0MHE57aKC6QUY6Zw=;
        b=p1JSSA426D674WnrjFq9fUC5rwb2ZvYuQj7SW1GXK5DKu9KBVsm02uAb9XWj9XR8eP
         Hirb+0GPocrSTyqb2OdWdQ+xwbJ2xZeaCdFKxAGj61Bub8HC2W7Y3Qo0B4E90utYeI3g
         Hi5GrDT4Mtmim/hn2yQ408jWA2xmcCVN8lwTwOWc2ePueZst2BWnJnUcHzTTYFs0VK9I
         yEYo7/zfiTV5PI0wUW6GYSJcJ9lMO1HW6MhLwirNtcBnKhCHq/loGHrQrW06ZQEMh/q+
         ZtKtMWWkradtgcRNKn3OwPG2zWqkslz4F8ZTR+iPIjJ9E5RV45MLTCCPSv7RXfoZq/q9
         MTog==
X-Gm-Message-State: AJIora8N9wUv96flmiehmptVe2yZFQRkbk89lVdWwRUQhYGK4pC45Gei
        zuvKdTlymC5riS4pfnIeJoxcsRwzq8wkQVL6VbUUXYDFJ1I=
X-Google-Smtp-Source: AGRyM1t2xSJylOSv//Y1xLDAD0giTT623ES9bCrAAbwwSs+DvTPoxYcBHzUO6SBfHRI49+9PHDAv1dRxeRmNQS4+tlI=
X-Received: by 2002:a05:6870:d3c7:b0:104:9120:8555 with SMTP id
 l7-20020a056870d3c700b0010491208555mr605703oag.181.1656469968481; Tue, 28 Jun
 2022 19:32:48 -0700 (PDT)
MIME-Version: 1.0
References: <bug-216177-28872@https.bugzilla.kernel.org/> <bug-216177-28872-n8HEVR7IoW@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216177-28872-n8HEVR7IoW@https.bugzilla.kernel.org/>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 28 Jun 2022 19:32:37 -0700
Message-ID: <CALMp9eS5MnFHOtjb8TQstR8n6jJmegahUmMcb2dgbLcb9qPPKA@mail.gmail.com>
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

On Tue, Jun 28, 2022 at 5:22 PM <bugzilla-daemon@kernel.org> wrote:
>
> https://bugzilla.kernel.org/show_bug.cgi?id=216177
>
> --- Comment #11 from Yang Lixiao (lixiao.yang@intel.com) ---
> (In reply to Jim Mattson from comment #10)
> > On Mon, Jun 27, 2022 at 11:32 PM <bugzilla-daemon@kernel.org> wrote:
> > >
> > > https://bugzilla.kernel.org/show_bug.cgi?id=216177
> > >
> > > --- Comment #9 from Yang Lixiao (lixiao.yang@intel.com) ---
> > > (In reply to Jim Mattson from comment #8)
> > > > On Mon, Jun 27, 2022 at 8:54 PM Nadav Amit <nadav.amit@gmail.com> wrote:
> > > >
> > > > > The failure on bare-metal that I experienced hints that this is either
> > a
> > > > test
> > > > > bug or (much less likely) a hardware bug. But I do not think it is
> > likely
> > > > to
> > > > > be
> > > > > a KVM bug.
> > > >
> > > > KVM does not use the VMX-preemption timer to virtualize L1's
> > > > VMX-preemption timer (and that is why KVM is broken). The KVM bug was
> > > > introduced with commit f4124500c2c1 ("KVM: nVMX: Fully emulate
> > > > preemption timer"), which uses an L0 CLOCK_MONOTONIC hrtimer to
> > > > emulate L1's VMX-preemption timer. There are many reasons that this
> > > > cannot possibly work, not the least of which is that the
> > > > CLOCK_MONOTONIC timer is subject to time slew.
> > > >
> > > > Currently, KVM reserves L0's VMX-preemption timer for emulating L1's
> > > > APIC timer. Better would be to determine whether L1's APIC timer or
> > > > L1's VMX-preemption timer is scheduled to fire first, and use L0's
> > > > VMX-preemption timer to trigger a VM-exit on the nearest alarm.
> > > > Alternatively, as Sean noted, one could perhaps arrange for the
> > > > hrtimer to fire early enough that it won't fire late, but I don't
> > > > really think that's a viable solution.
> > > >
> > > > I can't explain the bare-metal failures, but I will note that the test
> > > > assumes the default treatment of SMIs and SMM. The test will likely
> > > > fail with the dual-monitor treatment of SMIs and SMM. Aside from the
> > > > older CPUs with broken VMX-preemption timers, I don't know of any
> > > > relevant errata.
> > > >
> > > > Of course, it is possible that the test itself is buggy. For the
> > > > person who reported bare-metal failures on Ice Lake and Cooper Lake,
> > > > how long was the test in VMX non-root mode past the VMX-preemption
> > > > timer deadline?
> > >
> > > On the first Ice lake:
> > > Test suite: vmx_preemption_timer_expiry_test
> > > FAIL: Last stored guest TSC (28067103426) < TSC deadline (28067086048)
> > >
> > > On the second Ice lake:
> > > Test suite: vmx_preemption_timer_expiry_test
> > > FAIL: Last stored guest TSC (27014488614) < TSC deadline (27014469152)
> > >
> > > On Cooper lake:
> > > Test suite: vmx_preemption_timer_expiry_test
> > > FAIL: Last stored guest TSC (29030585690) < TSC deadline (29030565024)
> >
> > Wow! Those are *huge* overruns. What is the value of MSR 0x9B on these hosts?
>
> All of the values of MSR 0x9B on the three hosts are 0.
>
> --
> You may reply to this email to add a comment.
>
> You are receiving this mail because:
> You are watching the assignee of the bug.
Doh! There is a glaring bug in the test. I'll post a fix soon.
