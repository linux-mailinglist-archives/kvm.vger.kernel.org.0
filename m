Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81CC7427462
	for <lists+kvm@lfdr.de>; Sat,  9 Oct 2021 01:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243929AbhJHXw3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 19:52:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243797AbhJHXw2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Oct 2021 19:52:28 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60FBFC061570
        for <kvm@vger.kernel.org>; Fri,  8 Oct 2021 16:50:32 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id l16-20020a9d6a90000000b0053b71f7dc83so13512672otq.7
        for <kvm@vger.kernel.org>; Fri, 08 Oct 2021 16:50:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y/eGintyuS6nbigxubME5ogIZTQpNosmj4Y8JIbk1HM=;
        b=suZMryhgjMIffk8np9rV4R1DL02rbrn3wRhr20+poQSS7Pd5IkBnPuxXIUTjj7OZ+4
         9b4FSVVXrQC08BwVitSgY2rqQ5lE3os/3/UG2kSzpeoQUz+99CxrMKt8d9LerfHcae7+
         dQD8Y9qyzKu70KkMcWl8znLwzTL4l5he7xcKlhDWn6NyQgkTroTkyBILmdSoMSZcYUqa
         mVx6dT59un0ZdgDLGyzMNKPIcVcte46P5OGRyM0mGMxd6QrmKnSmk0fwuL98SxF24iiK
         HrVMaWi9KoZ/wi4Mg/2C/8Kv33Hv+YPPz8h+VnVHomY9k88i+eD4oSdg6R6DdAFgutpH
         /ORQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y/eGintyuS6nbigxubME5ogIZTQpNosmj4Y8JIbk1HM=;
        b=iLWlsPiDdX64EjON0bXAE2D/61qNJIrCW3mK6r6iBSF49hB91iKG/5IynJJdAX+vMy
         8xlg3V7/e2ewoxvO36cCmDE/5k7j3zWGW5vciIpFhP6LAHSVstnepnM+aL7BFc9QN6LO
         14e6+2VoVZoNagQkr2evm3EFhUkxDyq1G+0hILWw5vnl8K5AWZD+Pq4Zy/t3VukEpDIH
         zAx6kpL0RasxEvDHpPIRMzJbrXAat47HJD7H+FmyssJO89ZADak6TdBW9nFZTK/3q46y
         tUo+wloubMhvLeH1SESA2LNPwKvOmmcKlTeMKRlMFu/d0u9wrCD0u+xhh5Orjy3UtaRl
         vpOg==
X-Gm-Message-State: AOAM533xa3RmV4XoTq6x04ujtVQDO4tq30lM0HnBH1dHXT7WyGQQMKrN
        sl7LSypAm+mIutfXZadNYOtvEvA0WUVHys92x4W32A==
X-Google-Smtp-Source: ABdhPJyQPwJufCkqzcWEWyDypLi9aX6vN64zv2WCsazSCOZ45V8eTXtc2+/m7F0sk5+9nsJuuWvFsLvLh23BMhlG81g=
X-Received: by 2002:a9d:7681:: with SMTP id j1mr10950228otl.367.1633737031388;
 Fri, 08 Oct 2021 16:50:31 -0700 (PDT)
MIME-Version: 1.0
References: <20210930003649.4026553-1-jmattson@google.com> <YVUTG0n1i1n/RpL4@google.com>
In-Reply-To: <YVUTG0n1i1n/RpL4@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 8 Oct 2021 16:50:20 -0700
Message-ID: <CALMp9eSo18K6J3tqUvoXMfBnokt+C18A7iLRhAsFrRe7qVb02g@mail.gmail.com>
Subject: Re: [PATCH] KVM: selftests: Fix nested SVM tests when built with clang
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 29, 2021 at 6:30 PM Ricardo Koller <ricarkol@google.com> wrote:
>
> On Wed, Sep 29, 2021 at 05:36:49PM -0700, Jim Mattson wrote:
> > Though gcc conveniently compiles a simple memset to "rep stos," clang
> > prefers to call the libc version of memset. If a test is dynamically
> > linked, the libc memset isn't available in L1 (nor is the PLT or the
> > GOT, for that matter). Even if the test is statically linked, the libc
> > memset may choose to use some CPU features, like AVX, which may not be
> > enabled in L1. Note that __builtin_memset doesn't solve the problem,
> > because (a) the compiler is free to call memset anyway, and (b)
> > __builtin_memset may also choose to use features like AVX, which may
> > not be available in L1.
> >
> > To avoid a myriad of problems, use an explicit "rep stos" to clear the
> > VMCB in generic_svm_setup(), which is called both from L0 and L1.
> >
> > Reported-by: Ricardo Koller <ricarkol@google.com>
> > Signed-off-by: Jim Mattson <jmattson@google.com>
> > Fixes: 20ba262f8631a ("selftests: KVM: AMD Nested test infrastructure")
> > ---
> >  tools/testing/selftests/kvm/lib/x86_64/svm.c | 14 +++++++++++++-
> >  1 file changed, 13 insertions(+), 1 deletion(-)
> >
> > diff --git a/tools/testing/selftests/kvm/lib/x86_64/svm.c b/tools/testing/selftests/kvm/lib/x86_64/svm.c
> > index 2ac98d70d02b..161eba7cd128 100644
> > --- a/tools/testing/selftests/kvm/lib/x86_64/svm.c
> > +++ b/tools/testing/selftests/kvm/lib/x86_64/svm.c
> > @@ -54,6 +54,18 @@ static void vmcb_set_seg(struct vmcb_seg *seg, u16 selector,
> >       seg->base = base;
> >  }
> >
> > +/*
> > + * Avoid using memset to clear the vmcb, since libc may not be
> > + * available in L1 (and, even if it is, features that libc memset may
> > + * want to use, like AVX, may not be enabled).
> > + */
> > +static void clear_vmcb(struct vmcb *vmcb)
> > +{
> > +     int n = sizeof(*vmcb) / sizeof(u32);
> > +
> > +     asm volatile ("rep stosl" : "+c"(n), "+D"(vmcb) : "a"(0) : "memory");
> > +}
> > +
> >  void generic_svm_setup(struct svm_test_data *svm, void *guest_rip, void *guest_rsp)
> >  {
> >       struct vmcb *vmcb = svm->vmcb;
> > @@ -70,7 +82,7 @@ void generic_svm_setup(struct svm_test_data *svm, void *guest_rip, void *guest_r
> >       wrmsr(MSR_EFER, efer | EFER_SVME);
> >       wrmsr(MSR_VM_HSAVE_PA, svm->save_area_gpa);
> >
> > -     memset(vmcb, 0, sizeof(*vmcb));
> > +     clear_vmcb(vmcb);
> >       asm volatile ("vmsave %0\n\t" : : "a" (vmcb_gpa) : "memory");
> >       vmcb_set_seg(&save->es, get_es(), 0, -1U, data_seg_attr);
> >       vmcb_set_seg(&save->cs, get_cs(), 0, -1U, code_seg_attr);
> > --
> > 2.33.0.685.g46640cef36-goog
> >
>
> Reviewed-by: Ricardo Koller <ricarkol@google.com>

Ping!
