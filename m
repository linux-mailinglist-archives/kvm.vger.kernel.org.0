Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF32EC95F
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2019 21:08:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727605AbfKAUIk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Nov 2019 16:08:40 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:46294 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726477AbfKAUIk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Nov 2019 16:08:40 -0400
Received: by mail-io1-f66.google.com with SMTP id c6so12126560ioo.13
        for <kvm@vger.kernel.org>; Fri, 01 Nov 2019 13:08:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MMuSpKjkTI+qLHBAx7jiWHtZy7SBXqBydOpP3zmsAf0=;
        b=iy1M95zv28ds+X7p9Bnf8UORlZ25yKj13mQ5Jrd0O0NdJ5ntb5qElb75VErfm9EjI/
         jSxnioGDdMiDFuQNPUcDa0z4dg6EtNIqy7zogSY9rlNz1Fjc9JKgakgg5BqzQXAR7jay
         +FiH0SFYCnxihNF00z4gOxZoBFa2V99OJdimTbe8T8p2H0e1Ui88GFrpeWfSI5CKMf30
         BfCt5YBhNK6HKCKcKHRxI3juodEIVNhYyxHFncFhItHWdPkEGT0g+9oKdp1b6kgN5zSZ
         VfapLnaLbqg07loMP1BxnUqhctnhNHToTMoqNv0lh5ANrmtvJ+mTY4v+KGiCK33/oElR
         bEmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MMuSpKjkTI+qLHBAx7jiWHtZy7SBXqBydOpP3zmsAf0=;
        b=PgclmiA2VOdDD4DMl5lkoM/e/uaxwbHexZKxVDx33nWdIwpCbJy0QHZvQf8BLXHv2X
         9v/O/fuqdgNrn5m1Im2kmTKEDkloynCWEA9/UQBbV1yWceYr+I6X1kDfsl5GNmr999af
         Yv5vTRgCDQMdqO/PqaGVj11BA/8FF0ygpCmWxJZv/l+64445Ft44w2JoUv2DyFX4KmOE
         Yfxkmbx05GjTDl2m1PFpywrM4VzBBPWlG7G6SYsVU5ueTUaBq9NzPyDck/jt0dVnXPaj
         /t9C+w76QUN14baDJ5lUB/GWd8kfCMv6nef8krdr5OkXsJPyh92muaNh98zRCwmouFDC
         7+Rw==
X-Gm-Message-State: APjAAAVOcot5MyPn7zVZEuHE3yIoVy8k/vjFb6k/jiWEbcQgBMgz3FKe
        1fhNNb2DHB0AuETcAckTVrMm05i2NNUr0TgO1mMSCQ==
X-Google-Smtp-Source: APXvYqykFpXYqsVF1tIAiHqvDdZssgcuaF7exg53Xy1RXqEfNVedVGsxZUH4HCKHmLKIjcLCuewEdEmZiksH7W/L/cs=
X-Received: by 2002:a6b:908a:: with SMTP id s132mr12389079iod.118.1572638918483;
 Fri, 01 Nov 2019 13:08:38 -0700 (PDT)
MIME-Version: 1.0
References: <157262960837.2838.17520432516398899751.stgit@naples-babu.amd.com>
 <157262962352.2838.15656190309312238595.stgit@naples-babu.amd.com>
 <CALMp9eQT=a99YhraQZ+awMKOWK=3tg=m9NppZnsvK0Q1PWxbAw@mail.gmail.com>
 <669031a1-b9a6-8a45-9a05-a6ce5fb7fa8b@amd.com> <CALCETrXdo2arN=s9Bt1LmYkPajcBj1NuTPC8dwuw2mMZqT0tRw@mail.gmail.com>
 <91a05d64-36c0-c4c4-fe49-83a4db1ade10@amd.com>
In-Reply-To: <91a05d64-36c0-c4c4-fe49-83a4db1ade10@amd.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 1 Nov 2019 13:08:27 -0700
Message-ID: <CALMp9eRWjj1b7bPdiJO3ZT2xDCyV=Ypf6GUcQLkXnqr7YrXDRg@mail.gmail.com>
Subject: Re: [PATCH 2/4] kvm: svm: Enable UMIP feature on AMD
To:     "Moger, Babu" <Babu.Moger@amd.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "yamada.masahiro@socionext.com" <yamada.masahiro@socionext.com>,
        "nayna@linux.ibm.com" <nayna@linux.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 1, 2019 at 1:04 PM Moger, Babu <Babu.Moger@amd.com> wrote:
>
>
>
> On 11/1/19 2:24 PM, Andy Lutomirski wrote:
> > On Fri, Nov 1, 2019 at 12:20 PM Moger, Babu <Babu.Moger@amd.com> wrote:
> >>
> >>
> >>
> >> On 11/1/19 1:29 PM, Jim Mattson wrote:
> >>> On Fri, Nov 1, 2019 at 10:33 AM Moger, Babu <Babu.Moger@amd.com> wrote:
> >>>>
> >>>> AMD 2nd generation EPYC processors support UMIP (User-Mode Instruction
> >>>> Prevention) feature. The UMIP feature prevents the execution of certain
> >>>> instructions if the Current Privilege Level (CPL) is greater than 0.
> >>>> If any of these instructions are executed with CPL > 0 and UMIP
> >>>> is enabled, then kernel reports a #GP exception.
> >>>>
> >>>> The idea is taken from articles:
> >>>> https://lwn.net/Articles/738209/
> >>>> https://lwn.net/Articles/694385/
> >>>>
> >>>> Enable the feature if supported on bare metal and emulate instructions
> >>>> to return dummy values for certain cases.
> >>>>
> >>>> Signed-off-by: Babu Moger <babu.moger@amd.com>
> >>>> ---
> >>>>  arch/x86/kvm/svm.c |   21 ++++++++++++++++-----
> >>>>  1 file changed, 16 insertions(+), 5 deletions(-)
> >>>>
> >>>> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> >>>> index 4153ca8cddb7..79abbdeca148 100644
> >>>> --- a/arch/x86/kvm/svm.c
> >>>> +++ b/arch/x86/kvm/svm.c
> >>>> @@ -2533,6 +2533,11 @@ static void svm_decache_cr4_guest_bits(struct kvm_vcpu *vcpu)
> >>>>  {
> >>>>  }
> >>>>
> >>>> +static bool svm_umip_emulated(void)
> >>>> +{
> >>>> +       return boot_cpu_has(X86_FEATURE_UMIP);
> >>>> +}
> >>>
> >>> This makes no sense to me. If the hardware actually supports UMIP,
> >>> then it doesn't have to be emulated.
> >> My understanding..
> >>
> >> If the hardware supports the UMIP, it will generate the #GP fault when
> >> these instructions are executed at CPL > 0. Purpose of the emulation is to
> >> trap the GP and return a dummy value. Seems like this required in certain
> >> legacy OSes running in protected and virtual-8086 modes. In long mode no
> >> need to emulate. Here is the bit explanation https://lwn.net/Articles/738209/
> >>
> >
> > Indeed.  Again, what does this have to do with your patch?
> >
> >>
> >>>
> >>> To the extent that kvm emulates UMIP on Intel CPUs without hardware
> >>> UMIP (i.e. smsw is still allowed at CPL>0), we can always do the same
> >>> emulation on AMD, because SVM has always offered intercepts of sgdt,
> >>> sidt, sldt, and str. So, if you really want to offer this emulation on
> >>> pre-EPYC 2 CPUs, this function should just return true. But, I have to
> >>> ask, "why?"
> >>
> >>
> >> Trying to support UMIP feature only on EPYC 2 hardware. No intention to
> >> support pre-EPYC 2.
> >>
> >
> > I think you need to totally rewrite your changelog to explain what you
> > are doing.
> >
> > As I understand it, there are a couple of things KVM can do:
> >
> > 1. If the underlying hardware supports UMIP, KVM can expose UMIP to
> > the guest.  SEV should be irrelevant here.
> >
> > 2. Regardless of whether the underlying hardware supports UMIP, KVM
> > can try to emulate UMIP in the guest.  This may be impossible if SEV
> > is enabled.
> >
> > Which of these are you doing?
> >
> My intention was to do 1.  Let me go back and think about this again.

(1) already works.
