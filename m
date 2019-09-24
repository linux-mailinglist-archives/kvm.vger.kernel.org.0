Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67C51BD396
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 22:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390610AbfIXUaS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Sep 2019 16:30:18 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:42653 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726156AbfIXUaR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Sep 2019 16:30:17 -0400
Received: by mail-io1-f68.google.com with SMTP id n197so7730722iod.9
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2019 13:30:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q/tE8tQBNgGXSZjGMNRLTLzka8XZPpMRkFAr48fqCuc=;
        b=srdGacfqGchMVqr2Ycjt05/MeArW/dk7GVC64JReRIRI1buBpIcKJ5lnfY0CXOesvn
         Z+4SjFy6JC+RFjtyJIAcAv1iDMa6Pi4jmfK0MzYb+4FKKMPzL/97T4WXjkADrz/NBxwd
         ggxo+lddgj4bf12Ly9wVkMchXYgXdUDauJttDnUjmJEXCiXD/AMMP9GYRblbui3+dvB7
         oTlqh5PfH9xlnada6Vc6g7r1hJuEfgzxCWJs2mmgMHLR+OuDlrgYYoaJzKx68/gdF09q
         Oy/cmgN9byFYDAze9fpzGB9euHRzka8GLTZEeoEHssFxomRk4PkSMqGGmoKKK7SmRrdv
         KAcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q/tE8tQBNgGXSZjGMNRLTLzka8XZPpMRkFAr48fqCuc=;
        b=oyRQf0seE4+Zw2ENgsr4B0xoDVDJkrQ4OBhv8sZ4xwNyAhifYjpV2UHt3N7q4fzS/b
         wnTgCcIIrLcLdreXm2A4ZR2JVv8Ej2dKbRzfSWHNtKJisUmn8FgVBq05f5dEU+zQjjXD
         CBYSYHoHV3g8nYX1fXathBtf7zubJl5Ebp1124a0S6BYwKc5n04JCX3T3kqOI1j1s37T
         aS21H8RKVgIaGugKPc6J5WnQHk6FzU1O9SHHQE4jrPv3Xk5U5IjHDo4Sjx6DFM32WMk+
         rJeowmPxxDcsXqiE9Ia6iJoiB1pCoIHkyVGfouxdnjqLIH6N/qgNCI50ANwsqSQFY7/W
         o4ZA==
X-Gm-Message-State: APjAAAVsZh5Lo/q/48NgfmY4Rnd8rsTb55pu5HhfObq0Oz9eyy4p0m1S
        emCId+zOM3HepeLUl+tRBDQJ7G5SiK7b+Fk2ig2q3A==
X-Google-Smtp-Source: APXvYqwQ7vJ0jzX5Yi5gI8A0khFqu1tBiFKSdO1j5LJKjDKRDcMU7hjyn263XZiWOTZLcllxRaAIP/czse9gEocsKQA=
X-Received: by 2002:a02:b782:: with SMTP id f2mr862447jam.48.1569357015907;
 Tue, 24 Sep 2019 13:30:15 -0700 (PDT)
MIME-Version: 1.0
References: <1545227503-214403-1-git-send-email-robert.hu@linux.intel.com>
 <CALMp9eRZCoZbeyttZdvaCUpOFKygTNVF_x7+TWh6MktmF-ZK9A@mail.gmail.com> <263d31d9-b21e-ceb9-b47c-008e30bbd94f@redhat.com>
In-Reply-To: <263d31d9-b21e-ceb9-b47c-008e30bbd94f@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 24 Sep 2019 13:30:04 -0700
Message-ID: <CALMp9eRFWq+F1Dwb8NcBd-Bo-YbT6KMOLo8DoinQQfK9hEi5Qg@mail.gmail.com>
Subject: Re: [PATCH] x86: Add CPUID KVM support for new instruction WBNOINVD
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Robert Hoo <robert.hu@linux.intel.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        kvm list <kvm@vger.kernel.org>, Robert Hu <robert.hu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 19, 2018 at 1:02 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 19/12/18 18:39, Jim Mattson wrote:
> > Is this an instruction that kvm has to be able to emulate before it
> > can enumerate its existence?
>
> It doesn't have any operands, so no.
>
> Paolo
>
> > On Wed, Dec 19, 2018 at 5:51 AM Robert Hoo <robert.hu@linux.intel.com> wrote:
> >>
> >> Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
> >> ---
> >>  arch/x86/include/asm/cpufeatures.h | 1 +
> >>  arch/x86/kvm/cpuid.c               | 2 +-
> >>  2 files changed, 2 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> >> index 28c4a50..932b19f 100644
> >> --- a/arch/x86/include/asm/cpufeatures.h
> >> +++ b/arch/x86/include/asm/cpufeatures.h
> >> @@ -280,6 +280,7 @@
> >>  /* AMD-defined CPU features, CPUID level 0x80000008 (EBX), word 13 */
> >>  #define X86_FEATURE_CLZERO             (13*32+ 0) /* CLZERO instruction */
> >>  #define X86_FEATURE_IRPERF             (13*32+ 1) /* Instructions Retired Count */
> >> +#define X86_FEATURE_WBNOINVD           (13*32+ 9) /* Writeback and Don't invalid cache */
> >>  #define X86_FEATURE_XSAVEERPTR         (13*32+ 2) /* Always save/restore FP error pointers */
> >>  #define X86_FEATURE_AMD_IBPB           (13*32+12) /* "" Indirect Branch Prediction Barrier */
> >>  #define X86_FEATURE_AMD_IBRS           (13*32+14) /* "" Indirect Branch Restricted Speculation */
> >> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> >> index cc6dd65..763e115 100644
> >> --- a/arch/x86/kvm/cpuid.c
> >> +++ b/arch/x86/kvm/cpuid.c
> >> @@ -380,7 +380,7 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
> >>
> >>         /* cpuid 0x80000008.ebx */
> >>         const u32 kvm_cpuid_8000_0008_ebx_x86_features =
> >> -               F(AMD_IBPB) | F(AMD_IBRS) | F(AMD_SSBD) | F(VIRT_SSBD) |
> >> +               F(WBNOINVD) | F(AMD_IBPB) | F(AMD_IBRS) | F(AMD_SSBD) | F(VIRT_SSBD) |
> >>                 F(AMD_SSB_NO) | F(AMD_STIBP);
> >>
> >>         /* cpuid 0xC0000001.edx */
> >> --
> >> 1.8.3.1
> >>

What is the point of enumerating support for WBNOINVD if kvm is going
to implement it as WBINVD?
