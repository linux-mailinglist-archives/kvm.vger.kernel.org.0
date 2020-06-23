Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2674204ED4
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 12:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732236AbgFWKJT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 06:09:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732135AbgFWKJT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 06:09:19 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C398C061755
        for <kvm@vger.kernel.org>; Tue, 23 Jun 2020 03:09:19 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id d67so18333960oig.6
        for <kvm@vger.kernel.org>; Tue, 23 Jun 2020 03:09:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rU2hdhGD7fNtW6Y+12AGojPtiGkpRBwEsJIOODw6oSk=;
        b=pCU7BT0tDtwCvaiAm4xPhpb1ZoO7AvlAMIiGWxQqFb9kiDu3fiYmT+Y1yteEWeSc8M
         N1dfj19zTPci8X2KQTYhNOI719d7om5Q3LDRcDayt/Or/0DdPiNQ/Yu2eFHh7B9bQAk/
         yhZILXAelpJfhCF34X76NuMC0NO+V2pFFftCrfwqJ/DNjQ7EzfIAYp21TpEW3BncSE2u
         ADuFCObQQiM6P0oROGxUywcr1Xmu6rKUJ6P/+pTuhSyUWRhVizBeUVr3R7/6w9hGV40t
         t/q9hOcDfwTdpaOkVqoy+jWDDyPuLd1gcisny5nVn5726xXHQfo6b6FjfE1K4dSGIqJ/
         7rUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rU2hdhGD7fNtW6Y+12AGojPtiGkpRBwEsJIOODw6oSk=;
        b=iNIjT2M8pbX2dbpnGi+1OMpgduSkM3bdMAnGBWFQqMq50mEvGEKJBd4C3UdxtjXt0i
         V2mhaw4+Sxr3vULbUnP6f6ubsOfVamhEuAeIouGxfYnPDN3sTpvfy8tL6UhpveyWgVDg
         bp8s0EynIHHYXm6yaLxTXoqd/WAbhX4+9waNSiw+xwJ4wh/zoacDEFqncUBYUFrRm6rj
         inHnaVimklOMY+FL5/LTesssA/VqOidLUbXQlZDmG0j4N6mmX9XBL/ZjPg2x8HX/PB1Q
         TJii9jIi67bDR/AT3k4XVoV9V6uiKAb9LnDRMVyUVRAhNPulCw9imcaayBGT3G6l9mSN
         mJUw==
X-Gm-Message-State: AOAM532fC2/HNE8vD3iitIj/RSNbgEP7jB1wuF0DblZ1YA38BVkuGfQ8
        4Dt6WSDpRV+75w/3eGkqy+K9+ih7hrWUQctW/JpD/g==
X-Google-Smtp-Source: ABdhPJyLbqT3YNW3hb8nC+z6sAupP/viLWv3tDVCgY+urTIUfRq5q9195OLwSA9zcAZDtENjTwGGr82qLFRD3gKojPU=
X-Received: by 2002:aca:530e:: with SMTP id h14mr15692305oib.172.1592906958117;
 Tue, 23 Jun 2020 03:09:18 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000c25ce105a8a8fcd9@google.com> <20200622094923.GP576888@hirez.programming.kicks-ass.net>
 <20200623124413.08b2bd65@canb.auug.org.au> <20200623093230.GD4781@hirez.programming.kicks-ass.net>
In-Reply-To: <20200623093230.GD4781@hirez.programming.kicks-ass.net>
From:   Marco Elver <elver@google.com>
Date:   Tue, 23 Jun 2020 12:09:06 +0200
Message-ID: <CANpmjNOeN=m5i-kEn-no5d3zUdAKv=gLidEENtgQCo5umNTSjw@mail.gmail.com>
Subject: Re: linux-next build error (9)
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        syzbot <syzbot+dbf8cf3717c8ef4a90a0@syzkaller.appspotmail.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jim Mattson <jmattson@google.com>, joro@8bytes.org,
        kvm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        sean.j.christopherson@intel.com,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>, vkuznets@redhat.com,
        wanpengli@tencent.com, "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 23 Jun 2020 at 11:32, Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Tue, Jun 23, 2020 at 12:44:13PM +1000, Stephen Rothwell wrote:
> > Hi Peter,
> >
> > On Mon, 22 Jun 2020 11:49:23 +0200 Peter Zijlstra <peterz@infradead.org> wrote:
>
> > > Hurmph, I though that was cured in GCC >= 8. Marco?
> >
> > So what causes this? Because we got a couple of these in our s390 builds last night as well.
>
> This is KASAN's __no_sanitize_address function attribute. Some GCC
> versions are utterly wrecked when that function attribute is combined
> with inlining. It wants to have matching attributes for the function
> being inlined and function it is inlined into -- hence the function
> attribute mismatch.
>
> > kernel/locking/lockdep.c:805:1: error: inlining failed in call to always_inline 'look_up_lock_class': function attribute mismatch
> > include/linux/debug_locks.h:15:28: error: inlining failed in call to always_inline '__debug_locks_off': function attribute mismatch
> >
> > s390-linux-gcc (GCC) 8.1.0 / GNU ld (GNU Binutils) 2.30
>
> *groan*... So supposedly it was supposed to work on GCC-8 and later, see
> commit 7b861a53e46b6. But now it turns out there's some later versions
> that fail too.
>
> I suppose the next quest is finding a s390 compiler version that works
> and then bumping the version test in the aforementioned commit.

 I'm trying to figure out by inspecting GCC changelogs which version
and which arch is actually good.

Thanks,
-- Marco
