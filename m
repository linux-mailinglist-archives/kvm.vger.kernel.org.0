Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E53814A61D
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2020 15:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729182AbgA0OaZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jan 2020 09:30:25 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:35082 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbgA0OaZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jan 2020 09:30:25 -0500
Received: by mail-ed1-f67.google.com with SMTP id f8so10991769edv.2
        for <kvm@vger.kernel.org>; Mon, 27 Jan 2020 06:30:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6n2FVnJSrtqOR/mD8fQNayBm0ZsvU1cvMkwwhNiZ1es=;
        b=CY/B7kCgSEayoIN8UYccu1TxhFtfLxfxYAEltI7kKfNJQwuh8wqSrsllC3HGJzdT3t
         QAMUjKlLnE3pbAByQeY62G2gQ9m8X54h7dqEnKqkxtwFumx40aqMeamaPBvedSlBBZy1
         hDt7FK0f4I6mKrzktyGJm4ElOjUfnH0nyQ2G6z5uT3ys2iWIK+uQqch6zoq324eznrK5
         2hPzAdMrlzrfEFAkSTBL7miTL7m3XnOcMT9z+uU7a0G9UWDVyU9U7XnPNfh2j4dfJMbv
         im4rGDIGKUhV5Sm9RVaxXR3X5xkMKQdyeVagSKNJQnyia7C9R9oZDs/Rzqk6vVvVjGAE
         XJFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6n2FVnJSrtqOR/mD8fQNayBm0ZsvU1cvMkwwhNiZ1es=;
        b=kxmsGObxe16FzcTCn3H754R3HYuUqQIBQM/gedGOoobrv41s//GFgx1eMdPxkPI0xe
         L7To/J/qbWomkPboC8+cSWzE6jWPOD4FrTaDDCuJ842qFl85SYgRlCT8ETKQQuAfgXm7
         nFA4j712eDJMc/tVTSJErzqevSGQKGNT33kAbYAN7QpWplclRW1IAZxLYPDhTyhlp035
         xUOxppfck9PPLiYqrjG4Hi1wF8PzWVpQDLb8V2w4bt15t0CFyW4oNA8PwFV0qBiJK/yq
         osn3mEM9Hfp7RRfITbkmrDP++6G1Wy3b9SDIXmbWd0ux1myB777rMYHAwm5t0IKqpZ+I
         EokA==
X-Gm-Message-State: APjAAAWDdANIP+MYgbNTTXQhfvC9eAT5DeR9H7k8sqII2O7q72NGzLYf
        dwAmBcnGJnftm0UgqyBAT98SYktmuRy6qY/tUPyuug==
X-Google-Smtp-Source: APXvYqxMeuUsAnCmf+avVRPtdQmVPrt5z58pk6xDNeK6XlB8NYS9HpEeXny9hy9QJb/7xkVLZPMrLyQAjBTiQj+8GxU=
X-Received: by 2002:a17:906:3746:: with SMTP id e6mr8271145ejc.165.1580135422726;
 Mon, 27 Jan 2020 06:30:22 -0800 (PST)
MIME-Version: 1.0
References: <20200124234608.10754-1-sean.j.christopherson@intel.com> <705151e0-6a8b-1e15-934d-dd96f419dcd8@oracle.com>
In-Reply-To: <705151e0-6a8b-1e15-934d-dd96f419dcd8@oracle.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Mon, 27 Jan 2020 06:30:11 -0800
Message-ID: <CAAAPnDEA4u0YRLtW7OsWtL-Uy=5paDmrxx7EScDFsH5aqG6QJA@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] x86: nVMX: Print more (accurate) info if
 RDTSC diff test fails
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Nadav Amit <nadav.amit@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jan 25, 2020 at 11:16 PM Krish Sadhukhan
<krish.sadhukhan@oracle.com> wrote:
>
>
> On 1/24/20 3:46 PM, Sean Christopherson wrote:
> > Snapshot the delta of the last run and display it in the report if the
> > test fails.  Abort the run loop as soon as the threshold is reached so
> > that the displayed delta is guaranteed to a failed delta.  Displaying
> > the delta helps triage failures, e.g. is my system completely broken or
> > did I get unlucky, and aborting the loop early saves 99900 runs when
> > the system is indeed broken.
> >
> > Cc: Nadav Amit <nadav.amit@gmail.com>
> > Cc: Aaron Lewis <aaronlewis@google.com>
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> >   x86/vmx_tests.c | 11 ++++++-----
> >   1 file changed, 6 insertions(+), 5 deletions(-)
> >
> > diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> > index b31c360..4049dec 100644
> > --- a/x86/vmx_tests.c
> > +++ b/x86/vmx_tests.c
> > @@ -9204,6 +9204,7 @@ static unsigned long long rdtsc_vmexit_diff_test_iteration(void)
> >
> >   static void rdtsc_vmexit_diff_test(void)
> >   {
> > +     unsigned long long delta;
> >       int fail = 0;
> >       int i;
> >
> > @@ -9226,17 +9227,17 @@ static void rdtsc_vmexit_diff_test(void)
> >       vmcs_write(EXI_MSR_ST_CNT, 1);
> >       vmcs_write(EXIT_MSR_ST_ADDR, virt_to_phys(exit_msr_store));
> >
> > -     for (i = 0; i < RDTSC_DIFF_ITERS; i++) {
> > -             if (rdtsc_vmexit_diff_test_iteration() >=
> > -                 HOST_CAPTURED_GUEST_TSC_DIFF_THRESHOLD)
> > +     for (i = 0; i < RDTSC_DIFF_ITERS && fail < RDTSC_DIFF_FAILS; i++) {
> > +             delta = rdtsc_vmexit_diff_test_iteration();
> > +             if (delta >= HOST_CAPTURED_GUEST_TSC_DIFF_THRESHOLD)
> >                       fail++;
> >       }
> >
> >       enter_guest();
> >
> >       report(fail < RDTSC_DIFF_FAILS,
> > -            "RDTSC to VM-exit delta too high in %d of %d iterations",
> > -            fail, RDTSC_DIFF_ITERS);
> > +            "RDTSC to VM-exit delta too high in %d of %d iterations, last = %llu",
> > +            fail, i, delta);
> >   }
> >
> >   static int invalid_msr_init(struct vmcs *vmcs)
> Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>

Reviewed-by: Aaron Lewis <aaronlewis@google.com>
