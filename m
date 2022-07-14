Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81F39575818
	for <lists+kvm@lfdr.de>; Fri, 15 Jul 2022 01:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232604AbiGNXhN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 19:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232455AbiGNXhL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 19:37:11 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F287167CB4
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 16:37:10 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id g19-20020a9d1293000000b0061c7bfda5dfso2023324otg.1
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 16:37:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WUad+Xw6PKcQuVvg0NVjHjZrXjvIwRxx7gYLjE8eWlc=;
        b=Jm7C2LQZsxxWNagj8GABg7+kKx3vxX4cfGi8JP0PEmKJnaWG80wpBD0RfgEHAy99J/
         PX/JxovHwJGAE8KF5hXaLLZ7WAISNUTcDONyADJzadN8H7pvhuKxj4Mx5uVfFDlGiDZG
         +sLN0+Wf9UMEsTLxdFxa/Y3KtZMGQQcfOt4vWnSwuBDyfzXCKrk6moO1kYon0HCBBAKU
         uSbf0EJn6e4rU89jyAnOQ3H8oS9/5Dj1lm8gwvqx5vEpym8X2BNKZtYb33MpRuCsJlwF
         ygtVw1fLLIzyrhcjfGAyU81UMZnuBXYLrqvvZL0oeEtD8gYdyELZk+B8DMwj4pn//G07
         ouvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WUad+Xw6PKcQuVvg0NVjHjZrXjvIwRxx7gYLjE8eWlc=;
        b=jHn9SugoYdXA7lukeDcNTXC9/DrKuHWksJSTgpC1OOZAeg4HI+ONfQaW/wHJ8WvF9U
         GmkP6xMDoKVLe/drJXfUs1fgKo9XlqNsw1pODKDUY5qA1YhQ4Qnk5Fvx2epZb/kJvxu8
         kvwDYodJUyvs98pbsrogp9vBLsM51Le5xzeRFA3gjFeTxT9QoqLl9pjyIsXfqgd12MQ0
         0R2OHo1jHhWspeh9yD2Df77Zx+oQBc+FDUk1U1bCGyK51LcFUtrvbZWW7BS6jerk06Uz
         uuWn8zh0VI4iG6a7wA5p4LvuL1tY7xWVCBWIfBdy/U3/KAmT+pZOy4FVgxbu84CSx9em
         iiIQ==
X-Gm-Message-State: AJIora+Be6EBuW9DBLz/eRGW67TgJJluUwUXRwvUAq7u/evlxFfNucsS
        Z2CsiNfnwXKC5kI4Tx3XmS9RgA2Gwu1lFD7LY+dIWQ==
X-Google-Smtp-Source: AGRyM1sUROAf9QyU+AFTIJCy6BluDnqfq3lABw9U4DwUPLxmEQKBocONTlXWtlJxc7cu/XPd+ot8oXrqSV43LUWx7Yo=
X-Received: by 2002:a05:6830:2331:b0:61c:2c18:555 with SMTP id
 q17-20020a056830233100b0061c2c180555mr4590577otg.367.1657841830085; Thu, 14
 Jul 2022 16:37:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220714124453.188655-1-mlevitsk@redhat.com> <52d44630-21ad-1291-4185-40d5728eaea6@maciej.szmigiero.name>
 <034401953bc935d997c143153938edb1034b52cd.camel@redhat.com>
 <84646f56-dcb0-b0f8-f485-eb0d69a84c9c@maciej.szmigiero.name> <YtClmOgBV8j3eDkG@google.com>
In-Reply-To: <YtClmOgBV8j3eDkG@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 14 Jul 2022 16:36:59 -0700
Message-ID: <CALMp9eTZKyFM4oFNJbDDe69xfqtSmj5jZnPbe0aQaxxCvqdFTA@mail.gmail.com>
Subject: Re: [PATCH] KVM: SVM: fix task switch emulation on INTn instruction.
To:     Sean Christopherson <seanjc@google.com>
Cc:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 14, 2022 at 4:24 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Jul 15, 2022, Maciej S. Szmigiero wrote:
> > On 14.07.2022 15:57, Maxim Levitsky wrote:
> > > On Thu, 2022-07-14 at 15:50 +0200, Maciej S. Szmigiero wrote:
> > > > On 14.07.2022 14:44, Maxim Levitsky wrote:
> > > > > Recently KVM's SVM code switched to re-injecting software interrupt events,
> > > > > if something prevented their delivery.
> > > > >
> > > > > Task switch due to task gate in the IDT, however is an exception
> > > > > to this rule, because in this case, INTn instruction causes
> > > > > a task switch intercept and its emulation completes the INTn
> > > > > emulation as well.
> > > > >
> > > > > Add a missing case to task_switch_interception for that.
> > > > >
> > > > > This fixes 32 bit kvm unit test taskswitch2.
> > > > >
> > > > > Fixes: 7e5b5ef8dca322 ("KVM: SVM: Re-inject INTn instead of retrying the insn on "failure"")
> > > > >
> > > > > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > > > > ---
> > > >
> > > > That's a good catch, your patch looks totally sensible to me.
> > > > People running Win 3.x or OS/2 on top of KVM will surely be grateful for it :)
> > >
> > > Yes and also people who run 32 bit kvm unit tests :)
> >
> > It looks like more people need to do this regularly :)
>
> I do run KUT on 32-bit KVM, but until I hadn't done so on AMD for a long time and
> so didn't realize the taskswitch2 failure was a regression.  My goal/hope is to
> we'll get to a state where we're able to run the full gamut of tests before things
> hit kvm/queue, but the number of permutations of configs and module params means
> that's easier said than done.
>
> Honestly, it'd be a waste of people's time to expect anyone else beyond us few
> (and CI if we can get there) to test 32-bit KVM.  We do want to keep it healthy
> for a variety of reasons, but I'm quite convinced that outside of us developers,
> there's literally no one running 32-bit KVM.

It shouldn't be necessary to run 32-bit KVM to run 32-bit guests! Or
am I not understanding the issue that was fixed here?
