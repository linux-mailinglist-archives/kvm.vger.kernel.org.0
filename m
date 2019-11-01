Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5D8BEC901
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2019 20:25:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbfKATY7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Nov 2019 15:24:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:41534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727412AbfKATY7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Nov 2019 15:24:59 -0400
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 811A221D80
        for <kvm@vger.kernel.org>; Fri,  1 Nov 2019 19:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572636298;
        bh=dOxETrrx9e62OuVNxLdqpWdtW436erq1Fp0byfEZcow=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=UiH3+TX53xDLOWupQDLxho31QSei6aWT//MnPJdr+9M6HGoyhNYrmwgI8tfUlGvZq
         mRvjd7CK36qa44Q6wG98AzvO/oINih7ImEeYxCO04X+iavop/qPFbpdr+1X1yul6GP
         aO2Ltp90viUC0jyqrYYpOhwqu7WGHsPItFV8F08s=
Received: by mail-wr1-f45.google.com with SMTP id l10so10646060wrb.2
        for <kvm@vger.kernel.org>; Fri, 01 Nov 2019 12:24:58 -0700 (PDT)
X-Gm-Message-State: APjAAAWzQrcFpwHWKFNnjqr2mfxXaZIyaDwAWW7j+llZPxgcktjtei/p
        hMjrz845oaqR+1JAw3kczWbpzvrs1DWL18gHQxw/8w==
X-Google-Smtp-Source: APXvYqztRuGYdGSrXFGiZvNo5ReaB6pDXKbqd8BUA1v5glF47Wm2wgWyf4VvXKP4u5dgqsy951b8SvEzfrSpHOqYlDw=
X-Received: by 2002:a5d:51c2:: with SMTP id n2mr11780810wrv.149.1572636296663;
 Fri, 01 Nov 2019 12:24:56 -0700 (PDT)
MIME-Version: 1.0
References: <157262960837.2838.17520432516398899751.stgit@naples-babu.amd.com>
 <157262962352.2838.15656190309312238595.stgit@naples-babu.amd.com>
 <CALMp9eQT=a99YhraQZ+awMKOWK=3tg=m9NppZnsvK0Q1PWxbAw@mail.gmail.com> <669031a1-b9a6-8a45-9a05-a6ce5fb7fa8b@amd.com>
In-Reply-To: <669031a1-b9a6-8a45-9a05-a6ce5fb7fa8b@amd.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Fri, 1 Nov 2019 12:24:45 -0700
X-Gmail-Original-Message-ID: <CALCETrXdo2arN=s9Bt1LmYkPajcBj1NuTPC8dwuw2mMZqT0tRw@mail.gmail.com>
Message-ID: <CALCETrXdo2arN=s9Bt1LmYkPajcBj1NuTPC8dwuw2mMZqT0tRw@mail.gmail.com>
Subject: Re: [PATCH 2/4] kvm: svm: Enable UMIP feature on AMD
To:     "Moger, Babu" <Babu.Moger@amd.com>
Cc:     Jim Mattson <jmattson@google.com>,
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
        "luto@kernel.org" <luto@kernel.org>,
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

On Fri, Nov 1, 2019 at 12:20 PM Moger, Babu <Babu.Moger@amd.com> wrote:
>
>
>
> On 11/1/19 1:29 PM, Jim Mattson wrote:
> > On Fri, Nov 1, 2019 at 10:33 AM Moger, Babu <Babu.Moger@amd.com> wrote:
> >>
> >> AMD 2nd generation EPYC processors support UMIP (User-Mode Instruction
> >> Prevention) feature. The UMIP feature prevents the execution of certain
> >> instructions if the Current Privilege Level (CPL) is greater than 0.
> >> If any of these instructions are executed with CPL > 0 and UMIP
> >> is enabled, then kernel reports a #GP exception.
> >>
> >> The idea is taken from articles:
> >> https://lwn.net/Articles/738209/
> >> https://lwn.net/Articles/694385/
> >>
> >> Enable the feature if supported on bare metal and emulate instructions
> >> to return dummy values for certain cases.
> >>
> >> Signed-off-by: Babu Moger <babu.moger@amd.com>
> >> ---
> >>  arch/x86/kvm/svm.c |   21 ++++++++++++++++-----
> >>  1 file changed, 16 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> >> index 4153ca8cddb7..79abbdeca148 100644
> >> --- a/arch/x86/kvm/svm.c
> >> +++ b/arch/x86/kvm/svm.c
> >> @@ -2533,6 +2533,11 @@ static void svm_decache_cr4_guest_bits(struct kvm_vcpu *vcpu)
> >>  {
> >>  }
> >>
> >> +static bool svm_umip_emulated(void)
> >> +{
> >> +       return boot_cpu_has(X86_FEATURE_UMIP);
> >> +}
> >
> > This makes no sense to me. If the hardware actually supports UMIP,
> > then it doesn't have to be emulated.
> My understanding..
>
> If the hardware supports the UMIP, it will generate the #GP fault when
> these instructions are executed at CPL > 0. Purpose of the emulation is to
> trap the GP and return a dummy value. Seems like this required in certain
> legacy OSes running in protected and virtual-8086 modes. In long mode no
> need to emulate. Here is the bit explanation https://lwn.net/Articles/738209/
>

Indeed.  Again, what does this have to do with your patch?

>
> >
> > To the extent that kvm emulates UMIP on Intel CPUs without hardware
> > UMIP (i.e. smsw is still allowed at CPL>0), we can always do the same
> > emulation on AMD, because SVM has always offered intercepts of sgdt,
> > sidt, sldt, and str. So, if you really want to offer this emulation on
> > pre-EPYC 2 CPUs, this function should just return true. But, I have to
> > ask, "why?"
>
>
> Trying to support UMIP feature only on EPYC 2 hardware. No intention to
> support pre-EPYC 2.
>

I think you need to totally rewrite your changelog to explain what you
are doing.

As I understand it, there are a couple of things KVM can do:

1. If the underlying hardware supports UMIP, KVM can expose UMIP to
the guest.  SEV should be irrelevant here.

2. Regardless of whether the underlying hardware supports UMIP, KVM
can try to emulate UMIP in the guest.  This may be impossible if SEV
is enabled.

Which of these are you doing?
