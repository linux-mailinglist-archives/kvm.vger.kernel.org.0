Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F252A3FCC49
	for <lists+kvm@lfdr.de>; Tue, 31 Aug 2021 19:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234077AbhHaR2X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Aug 2021 13:28:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233345AbhHaR2W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Aug 2021 13:28:22 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9695C061575
        for <kvm@vger.kernel.org>; Tue, 31 Aug 2021 10:27:26 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id z2so427666lft.1
        for <kvm@vger.kernel.org>; Tue, 31 Aug 2021 10:27:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x/2kwviYgFXJZ+ysPYsfXQdOl9RzKKDy4aBFBjxfgE4=;
        b=VwkhjaRpWjGfc35sCBBfJ2nBFysfht4GWKFPN970ClNyEfpQRCYLhXyECxlDNFAZKd
         +jCOueubsQHWs3m2wyAnx0QqQSNXyEH8fPYM1wdYlfp29CuG6Hb+zhYPLZFNARolqmds
         9obvQjGkjPgmpaw46ueU3XfmG9lTI08sr0xnf61J7In8ePIBV0XaOy+1FB1CZOx7acna
         8iVMLL+YguPMKL8sAapEI3T5itvqsXf1i6BmSTBfeJ/7xx6oivzfKHNXjrHgy0SRvYOU
         nNw4r2Na3mjUnWfVT6WockkD25+c0VVWkL5MO6gMTVHQM50+IbpaZrqVhdYTAxweT6Xb
         a1Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x/2kwviYgFXJZ+ysPYsfXQdOl9RzKKDy4aBFBjxfgE4=;
        b=lzsr3PqdGFnqA8/gBOSuVY3DgMhx0mOr/vcYWFaezrIs24nEefdOKj/AfcSI/Q4rCt
         iwOqika0JKWZR9Wk+teHKbW0OS3pgKZAbglMaeOBH+5/CANsuSM3j/h2O11YpAjzmlJN
         yBdX6GLbAov5pJ9mTsXCtb+ucNaz/4278ia3nlKpBwd+mJmO4cS6d8jPaDmLaT19F6hC
         Th+7ApbGT9oL7eYu6zjlp85qHEb/SehzONLhAjoUX0Utyf9qZaRRhFAHaqAVVeUQ6SDa
         gODxtfL0Zq12fR74++rfDAe1U6Yk6+dM5Go3XzzY9+vU0gzf+1lleOeE368eaCsQlcWg
         ZTCw==
X-Gm-Message-State: AOAM5302GHRARGuVD6XbHzplXy9ZS3ttoCSPZLs7DtWOYpIAblXfgLvb
        2garXvcYtLz9s8XAjPnXTTbSVTydwPU3RX9woOZJxQ==
X-Google-Smtp-Source: ABdhPJzway3c96U+c8VS3MU3jnmFfiUx0To4De35gi9UpU3+sxLJgD9+gPnggGJPC1RTOLC6F14Sotz5rRp+IlQtd5k=
X-Received: by 2002:ac2:4e90:: with SMTP id o16mr7839919lfr.473.1630430844961;
 Tue, 31 Aug 2021 10:27:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210827174110.3723076-1-jingzhangos@google.com>
 <20210827174110.3723076-2-jingzhangos@google.com> <YSlHK+ZZFuokMa4S@google.com>
In-Reply-To: <YSlHK+ZZFuokMa4S@google.com>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Tue, 31 Aug 2021 10:27:13 -0700
Message-ID: <CAAdAUtghEvtT_v2wm_JV8M=pUXvuDuJ5JAtSP0zni18PtfhPAQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: stats: Add counters for SVM exit reasons
To:     Sean Christopherson <seanjc@google.com>
Cc:     KVM <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

On Fri, Aug 27, 2021 at 1:12 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Aug 27, 2021, Jing Zhang wrote:
> > Three different exit code ranges are named as low, high and vmgexit,
> > which start from 0x0, 0x400 and 0x80000000.
> >
> > Original-by: Jim Mattson <jmattson@google.com>
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h |  7 +++++++
> >  arch/x86/include/uapi/asm/svm.h |  7 +++++++
> >  arch/x86/kvm/svm/svm.c          | 21 +++++++++++++++++++++
> >  arch/x86/kvm/x86.c              |  9 +++++++++
> >  4 files changed, 44 insertions(+)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index dd2380c9ea96..6e3c11a29afe 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -35,6 +35,7 @@
> >  #include <asm/kvm_vcpu_regs.h>
> >  #include <asm/hyperv-tlfs.h>
> >  #include <asm/vmx.h>
> > +#include <asm/svm.h>
> >
> >  #define __KVM_HAVE_ARCH_VCPU_DEBUGFS
> >
> > @@ -1261,6 +1262,12 @@ struct kvm_vcpu_stat {
> >       u64 vmx_all_exits[EXIT_REASON_NUM];
> >       u64 vmx_l2_exits[EXIT_REASON_NUM];
> >       u64 vmx_nested_exits[EXIT_REASON_NUM];
> > +     u64 svm_exits_low[SVM_EXIT_LOW_END - SVM_EXIT_LOW_START];
> > +     u64 svm_exits_high[SVM_EXIT_HIGH_END - SVM_EXIT_HIGH_START];
> > +     u64 svm_vmgexits[SVM_VMGEXIT_END - SVM_VMGEXIT_START];
>
> This is, for lack of a better word, a very lazy approach.  With a bit more (ok,
> probably a lot more) effort and abstraction, we can have parity between VMX and
> SVM, and eliminate a bunch of dead weight.  Having rough parity would likely be
> quite helpful for the end user, e.g. reduces/eliminates vendor specific userspace
> code.
>
> E.g. this more or less doubles the memory footprint due to tracking VMX and SVM
> separately, SVM has finer granularity than VMX (often too fine),  VMX tracks nested
> exits but SVM does not, etc...
>
> If we use KVM-defined exit reasons, then we can omit the exits that should never
> happen (SVM has quite a few), and consolidate the ones no one should ever care
> about, e.g. DR0..DR4 and DR6 can be collapsed (if I'm remembering my DR aliases
> correctly).  And on the VMX side we can provide better granularity than the raw
> exit reason, e.g. VMX's bundling of NMIs and exceptions is downright gross.
>
>         #define KVM_GUEST_EXIT_READ_CR0
>         #define KVM_GUEST_EXIT_READ_CR3
>         #define KVM_GUEST_EXIT_READ_CR4
>         #define KVM_GUEST_EXIT_READ_CR8
>         #define KVM_GUEST_EXIT_DR_READ
>         #define KVM_GUEST_EXIT_DR_WRITE
>         #define KVM_GUEST_EXIT_DB_EXCEPTION
>         #define KVM_GUEST_EXIT_BP_EXCEPTION
>         #define KVM_GUEST_EXIT_UD_EXCEPTION
>
>         ...
>         #define KVM_NR_GUEST_EXIT_REASONS
>
>         u64 l1_exits[KVM_NR_GUEST_EXIT_REASONS];
>         u64 l2_exits[KVM_NR_GUEST_EXIT_REASONS];
>         u64 nested_exits[KVM_NR_GUEST_EXIT_REASONS];
>
>
> The downside is that it will require KVM-defined exit reasons and will have a
> slightly higher maintenance cost because of it, but I think overall it would be
> a net positive.  Paolo can probably even concoct some clever arithmetic to avoid
> conditionals when massaging SVM exits reasons.  VMX will require a bit more
> manual effort, especially to play nice with nested, but in the end I think we'll
> be happier.
>
Thanks for the suggestions. Will try to generalize the exit reasons
and see how it is going.

Jing
> > +     u64 svm_vmgexit_unsupported_event;
> > +     u64 svm_exit_sw;
> > +     u64 svm_exit_err;
> >  };
