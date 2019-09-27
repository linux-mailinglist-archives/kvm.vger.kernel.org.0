Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27862C0A7D
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 19:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727447AbfI0Rg2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 13:36:28 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:54059 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726394AbfI0Rg2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 13:36:28 -0400
Received: by mail-wm1-f66.google.com with SMTP id i16so6874497wmd.3
        for <kvm@vger.kernel.org>; Fri, 27 Sep 2019 10:36:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hQ8bBN9sY10HJWUcBusddJhcV108Kl/29ak1bzSIfGE=;
        b=WwLzV+0jJlc02G+lqP1AMK3GR3dX+3hB2e/ghGNKTs4cB0X2BFV37tc7k3P6yvAXxi
         TyH8WHGJAvwcwxk/5V6QrVwUsVwIu3hg9eMF/pIpMnegwbGp+DKuoRJ8ogxhWopU0+gK
         zESZOMsMlXtuB+R0pO8r0TADjJE5FfS0i1IpcWxSCwAvkLX6pd+JXzmNmO922BVYtAzF
         ZzQR8d0MG+aBO3BbFMVHapAezpEkvPdfzDMT6gvZbUZISqtb7+ATtWq+bfXfD7uanmcR
         Vm3j+EnqzZDGxZrGmDfhzc6l4/bTAU1N75/7ckSbD7InHDNwM6ZJEbquG47rNfSaS8oO
         PTgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hQ8bBN9sY10HJWUcBusddJhcV108Kl/29ak1bzSIfGE=;
        b=e6qA7UJD0Afcm/p85OI9fUVwwc3GTUyVQtDqROWaFdnXQXdvHrTv/aJm0v1eormz5n
         5OYKB75k93cokD+w6m4gDNMWlhbpRfyb+1ShOVJOa6BJAfOZAd7mzbIY9lCoAPdPlHAZ
         jPq6I92ttHCMxQ7JYAlHDSLQhcvJFEAuG6nKS1Co7qSFAJRQ3JhhVOjvaAhrBVHRN1Be
         icSfACmFzZ/P/DH1a1Hxu8l4NLTM54QUYjsztd5e5EBvSTUHJV5syK37zHUqsUJ7mIr1
         +Ybpx8EAfY++k0Xl8gs10zr6J1RR+kpgbSIzGkbJcxivxVQKH15NZfYbfjgnC5Nr+94K
         5jUA==
X-Gm-Message-State: APjAAAU+NB3W+uKwwMZx9PLrlOLGmULC9mYf+4iugol4caQfT0Lesl6E
        gXBFUmPqBt7C3vM8u/2sIWwrAipSzdrt8mqnox3T0g==
X-Google-Smtp-Source: APXvYqwlTY7qJ/xBJVklheJ7WaEHNxAQbsDvN/q9G7W8B5rVv7Lme0qc67stcl0nxChEB1fBmefqshrNKkXs1nz0MN4=
X-Received: by 2002:a7b:ce0a:: with SMTP id m10mr8097798wmc.121.1569605785848;
 Fri, 27 Sep 2019 10:36:25 -0700 (PDT)
MIME-Version: 1.0
References: <20190821182004.102768-1-jmattson@google.com> <CALMp9eTtA5ZXJyWcOpe-pQ66X3sTgCR4-BHec_R3e1-j1FZyZw@mail.gmail.com>
 <8907173e-9f27-6769-09fc-0b82c22d6352@oracle.com> <CALMp9eSkognb2hJSuENK+5PSgE8sYzQP=4ioERge6ZaFg1=PEA@mail.gmail.com>
 <cb7c570c-389c-2e96-ba46-555218ba60ed@oracle.com> <CALMp9eQULvr5wKt1Aw3MR+tbeNgvA_4p__6n1YTkWjMHCaEmLw@mail.gmail.com>
 <CALMp9eS1fUVcnVHhty60fUgk3-NuvELMOUFqQmqPLE-Nqy0dFQ@mail.gmail.com>
 <56e7fad0-d577-41db-0b81-363975dc2ca7@redhat.com> <87ftkh6e19.fsf@vitty.brq.redhat.com>
 <6e6f46fe-6e11-c5e3-d80c-327f77b91907@redhat.com> <87d0fl6bv4.fsf@vitty.brq.redhat.com>
 <19db28c0-375a-7bc0-7151-db566ae85de6@redhat.com>
In-Reply-To: <19db28c0-375a-7bc0-7151-db566ae85de6@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 27 Sep 2019 10:36:14 -0700
Message-ID: <CALMp9eSDrXLU2jHXAUYoDqVWnV5gPbT5DUmrhKVbtc6vW+sogA@mail.gmail.com>
Subject: Re: [PATCH] kvm: x86: Add Intel PMU MSRs to msrs_to_save[]
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Eric Hankland <ehankland@google.com>,
        Peter Shier <pshier@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 27, 2019 at 8:19 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 27/09/19 16:40, Vitaly Kuznetsov wrote:
> > Paolo Bonzini <pbonzini@redhat.com> writes:
> >
> >> On 27/09/19 15:53, Vitaly Kuznetsov wrote:
> >>> Paolo Bonzini <pbonzini@redhat.com> writes:
> >>>
> >>>> Queued, thanks.
> >>>
> >>> I'm sorry for late feedback but this commit seems to be causing
> >>> selftests failures for me, e.g.:
> >>>
> >>> # ./x86_64/state_test
> >>> Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
> >>> Guest physical address width detected: 46
> >>> ==== Test Assertion Failure ====
> >>>   lib/x86_64/processor.c:1089: r == nmsrs
> >>>   pid=14431 tid=14431 - Argument list too long
> >>>      1      0x000000000040a55f: vcpu_save_state at processor.c:1088 (discriminator 3)
> >>>      2      0x00000000004010e3: main at state_test.c:171 (discriminator 4)
> >>>      3      0x00007f881eb453d4: ?? ??:0
> >>>      4      0x0000000000401287: _start at ??:?
> >>>   Unexpected result from KVM_GET_MSRS, r: 36 (failed at 194)
> >>>
> >>> Is this something known already or should I investigate?
> >>
> >> No, I didn't know about it, it works here.
> >>
> >
> > Ok, this is a bit weird :-) '194' is 'MSR_ARCH_PERFMON_EVENTSEL0 +
> > 14'. In intel_pmu_refresh() nr_arch_gp_counters is set to '8', however,
> > rdmsr_safe() for this MSR passes in kvm_init_msr_list() (but it fails
> > for 0x18e..0x193!) so it stay in the list. get_gp_pmc(), however, checks
> > it against nr_arch_gp_counters and returns a failure.
>
> Huh, 194h apparently is a "FLEX_RATIO" MSR.  I agree that PMU MSRs need
> to be checked against CPUID before allowing them.

According to the SDM, volume 4, table 2-2, IA-32 Architectural MSRs,
194H is reserved. Sounds like your CPU is mis-architected. :-)

> Paolo
>
> > Oh, btw, this is Intel(R) Xeon(R) CPU E5-2603 v3
> >
> > So apparently rdmsr_safe() check in kvm_init_msr_list() is not enough,
> > for PMU MSRs we need to do extra.
>
>
>
