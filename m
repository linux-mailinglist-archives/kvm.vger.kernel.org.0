Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D191BB97EF
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2019 21:44:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729678AbfITTol (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Sep 2019 15:44:41 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:37260 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726930AbfITTol (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Sep 2019 15:44:41 -0400
Received: by mail-io1-f66.google.com with SMTP id b19so18871390iob.4
        for <kvm@vger.kernel.org>; Fri, 20 Sep 2019 12:44:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZlBdskM/oyigGv36pCP1d3rXIwnuNYwHKau9U5XfAsI=;
        b=vbPBh2+F1b+Ad2OhZEAMkGmA/ufpQujvOGRrnr0G1bQHlGC//MRJzfZVqpe83sXsOW
         X4m4/JCCHfXOWJkPfFj0MDZZhnOWUUXU7YrsaXsSOzbrWL41CpWlrrg0czIGmquosmCe
         N5ro9zZrRVBA0X8ZK5engqBYpckYo/kcC5T+ku5+NhA2voYuSVAQSzY1BuJs6Blg/3Q5
         veDEHXllVH1nTm9mWJDXf50qAA7VUjMlATYqprERlaCj/iYeLqAhV2+2cetSebH3AXUc
         7Yu8+XfRj7v80oMce7ZXxggzht6olTWt6e086XCc8JsZ5Xg5QI3YhkiS7lo3ub784y8i
         vlAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZlBdskM/oyigGv36pCP1d3rXIwnuNYwHKau9U5XfAsI=;
        b=YEoBEoeH8E9T3/ZtMPmVUOSvwQUehkoP69ZucREICiYUmvarZrp4Gtyu+BlaFsBZxh
         1QMVvC4FEuMUXWaGXYo0UsAHT/Nsfs5ETcU99dLBEoHpDpIgiMtPzLu8G0cjL4CdUkob
         5yL86sX2FfjNpnJntE0wQ8R0H80Q1psYGeKznhjgHzXHnyTOqGXHnx5uff7tb0GtaEnU
         qdlNDkUguhvarxAnG+ir8r61fuKmC4fz2qhNvzCc+gXa4C0w9znL4OMxQKzknt9YyvGM
         jXNkgjLkiKwJS3GozZjnQFEPG69MkB5uoFlTFMbWO0bo/+igtgxgNM60feqb49OAJ6wE
         YBwA==
X-Gm-Message-State: APjAAAUcCpTVQ9Ps20sNy0tQ3hYmr6YcCfyAd6vu1vfoDXmrum5aJRoI
        O9S8LFGlSLFHYofCm3Dfy8ZQgLYe4pbnAsIH7+fXKA==
X-Google-Smtp-Source: APXvYqzE0uzpAH//jkulS8h33gy3H9aEjGstfzF2cR5vwkMq3WMQcb7eqkE4lh/fr/tC6qDcnQVDgS/wE0DsXmRgTGI=
X-Received: by 2002:a6b:9085:: with SMTP id s127mr16540373iod.26.1569008680082;
 Fri, 20 Sep 2019 12:44:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190919230225.37796-1-jmattson@google.com> <368a94f2-3614-a9ea-3f72-d53d36a81f68@oracle.com>
In-Reply-To: <368a94f2-3614-a9ea-3f72-d53d36a81f68@oracle.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 20 Sep 2019 12:44:28 -0700
Message-ID: <CALMp9eQh445HEfw0rbUaJQhb7TeFszQX1KXe8YY-18FyMd6+tA@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] kvm-unit-test: x86: Add RDPRU test
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm list <kvm@vger.kernel.org>, Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 20, 2019 at 12:36 PM Krish Sadhukhan
<krish.sadhukhan@oracle.com> wrote:
>
>
> On 9/19/19 4:02 PM, Jim Mattson wrote:
> > Ensure that support for RDPRU is not enumerated in the guest's CPUID
> > and that the RDPRU instruction raises #UD.
>
>
> The AMD spec says,
>
>          "When the CPL>0 with CR4.TSD=1, the RDPRUinstruction will
> generate a #UD fault."
>
> So we don't need to check the CR4.TSD value here ?

KVM should set CPUID Fn8000_0008_EBX[RDPRU] to 0.

However, I should modify the test so it passes (or skips) on hardware. :-)

>
> >
> > Signed-off-by: Jim Mattson <jmattson@google.com>
> > Reviewed-by: Peter Shier <pshier@google.com>
> > ---
> >   lib/x86/processor.h |  1 +
> >   x86/Makefile.x86_64 |  1 +
> >   x86/rdpru.c         | 23 +++++++++++++++++++++++
> >   x86/unittests.cfg   |  5 +++++
> >   4 files changed, 30 insertions(+)
> >   create mode 100644 x86/rdpru.c
> >
> > diff --git a/lib/x86/processor.h b/lib/x86/processor.h
> > index b1c579b..121f19c 100644
> > --- a/lib/x86/processor.h
> > +++ b/lib/x86/processor.h
> > @@ -150,6 +150,7 @@ static inline u8 cpuid_maxphyaddr(void)
> >   #define     X86_FEATURE_RDPID               (CPUID(0x7, 0, ECX, 22))
> >   #define     X86_FEATURE_SPEC_CTRL           (CPUID(0x7, 0, EDX, 26))
> >   #define     X86_FEATURE_NX                  (CPUID(0x80000001, 0, EDX, 20))
> > +#define      X86_FEATURE_RDPRU               (CPUID(0x80000008, 0, EBX, 4))
> >
> >   /*
> >    * AMD CPUID features
> > diff --git a/x86/Makefile.x86_64 b/x86/Makefile.x86_64
> > index 51f9b80..010102b 100644
> > --- a/x86/Makefile.x86_64
> > +++ b/x86/Makefile.x86_64
> > @@ -19,6 +19,7 @@ tests += $(TEST_DIR)/vmx.flat
> >   tests += $(TEST_DIR)/tscdeadline_latency.flat
> >   tests += $(TEST_DIR)/intel-iommu.flat
> >   tests += $(TEST_DIR)/vmware_backdoors.flat
> > +tests += $(TEST_DIR)/rdpru.flat
> >
> >   include $(SRCDIR)/$(TEST_DIR)/Makefile.common
> >
> > diff --git a/x86/rdpru.c b/x86/rdpru.c
> > new file mode 100644
> > index 0000000..a298960
> > --- /dev/null
> > +++ b/x86/rdpru.c
> > @@ -0,0 +1,23 @@
> > +/* RDPRU test */
> > +
> > +#include "libcflat.h"
> > +#include "processor.h"
> > +#include "desc.h"
> > +
> > +static int rdpru_checking(void)
> > +{
> > +     asm volatile (ASM_TRY("1f")
> > +                   ".byte 0x0f,0x01,0xfd \n\t" /* rdpru */
> > +                   "1:" : : "c" (0) : "eax", "edx");
> > +     return exception_vector();
> > +}
> > +
> > +int main(int ac, char **av)
> > +{
> > +     setup_idt();
> > +
> > +     report("RDPRU not supported", !this_cpu_has(X86_FEATURE_RDPRU));
> > +     report("RDPRU raises #UD", rdpru_checking() == UD_VECTOR);
> > +
> > +     return report_summary();
> > +}
> > diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> > index 694ee3d..9764e18 100644
> > --- a/x86/unittests.cfg
> > +++ b/x86/unittests.cfg
> > @@ -221,6 +221,11 @@ file = pcid.flat
> >   extra_params = -cpu qemu64,+pcid
> >   arch = x86_64
> >
> > +[rdpru]
> > +file = rdpru.flat
> > +extra_params = -cpu host
> > +arch = x86_64
> > +
> >   [umip]
> >   file = umip.flat
> >   extra_params = -cpu qemu64,+umip
