Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE87173F6B
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2020 19:20:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727003AbgB1SUM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Feb 2020 13:20:12 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:37121 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726527AbgB1SUL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Feb 2020 13:20:11 -0500
Received: by mail-lj1-f196.google.com with SMTP id q23so4382401ljm.4
        for <kvm@vger.kernel.org>; Fri, 28 Feb 2020 10:20:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I72nAam9DDgGz7gh5elDilfqjQph2i1VS//yvI2QrIA=;
        b=uQuqze3oj9J3zIbBOG0wDWYMGOvudZsrGnvJ7GMPSd6mTCc9xFgcYGhHH29x3G4Y+b
         LErKXUYjtOn6fC3IQdNbMtXlPqVqPWO8OijFVB+QClf6Y1yDM1o+SL/RbKeAE/lcN4aN
         1knFl4N+SMm0U1CSniks3NPObcrzscNehaY+jUGnP9ou0/IcHY8M2IRObPexqOABVjIt
         Oj2WeqlOBQTyNB2d8LbV0qknv5e4irUiOgP8YM4BR7HlRqajagFmmg1/2YqgHiPLb7w9
         0XNVEqkQWwOLWpfjkq69hJR7f67aQDhc+BypXC98sMoULffM/chcrgIRwT4x1D9SKLNh
         WpIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I72nAam9DDgGz7gh5elDilfqjQph2i1VS//yvI2QrIA=;
        b=AWMjlXGpmHYoUaAc/2g1PO9E87vwyrNLVh/JSGr5/zfyE84Y5bLYR4GNK/iLkZcwk4
         i9hkb51/eu+z2mDPbN8dwp4pIX8ZRKkxopc12aNZdMuUqKyP2tok/6sHBOrEg//rTW/1
         c9dfL/YIkZR94RZS5hhX5Ef15GYtvf16IjZ0MyBvQZAkrcRfxnw70Wzg7Z5VfXRsP+BA
         czrUzeLruHjLR7S/vxkbh+llZfF51iDiw9lC7qRj3em21hPK2QJ9HI7lr9gm8CO6VmaB
         6BBYrhn1DSapLRxdzGz2HpKG2yQ0ph6Basy5QEpPz5lT63gqVXjvEVg9DtsHRbe0vrZL
         awTw==
X-Gm-Message-State: ANhLgQ3ZXzADuG4MFafxAeiA/xu/J1tmvAkl78YYrPWxICc0nPi0m+8s
        81x09FOmAPfF+Qe9cA7mO97Z1rxuRYhTfxUM+wOS5g==
X-Google-Smtp-Source: ADFU+vtXTtebJJY0x8KzFavUs1fZTw2Bsua+ovPMXoUNU8rT/bpx2LK9YOtKR9jJ6ygSQons7ntHCBvPk7p/FYe4CHM=
X-Received: by 2002:a05:651c:2c8:: with SMTP id f8mr3453479ljo.30.1582914009874;
 Fri, 28 Feb 2020 10:20:09 -0800 (PST)
MIME-Version: 1.0
References: <20200226074427.169684-1-morbo@google.com> <20200226094433.210968-1-morbo@google.com>
 <20200226094433.210968-15-morbo@google.com> <643086be-7251-92cf-c9f5-5a467dd2827d@redhat.com>
In-Reply-To: <643086be-7251-92cf-c9f5-5a467dd2827d@redhat.com>
From:   Oliver Upton <oupton@google.com>
Date:   Fri, 28 Feb 2020 10:19:58 -0800
Message-ID: <CAOQ_QsjZKp3nou31jAxASojspTGbO50ZfMV_yy61rxmAwJYFsQ@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH 7/7] x86: VMX: the "noclone" attribute is gcc-specific
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Bill Wendling <morbo@google.com>, kvm list <kvm@vger.kernel.org>,
        drjones@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 28, 2020 at 3:16 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 26/02/20 10:44, Bill Wendling wrote:
> > Don't use the "noclone" attribute for clang as it's not supported.
> >
> > Signed-off-by: Bill Wendling <morbo@google.com>
> > ---
> >  x86/vmx_tests.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> >
> > diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> > index ad8c002..ec88016 100644
> > --- a/x86/vmx_tests.c
> > +++ b/x86/vmx_tests.c
> > @@ -4976,7 +4976,10 @@ extern unsigned char test_mtf1;
> >  extern unsigned char test_mtf2;
> >  extern unsigned char test_mtf3;
> >
> > -__attribute__((noclone)) static void test_mtf_guest(void)
> > +#ifndef __clang__
> > +__attribute__((noclone))
> > +#endif
> > +static void test_mtf_guest(void)
> >  {
> >       asm ("vmcall;\n\t"
> >            "out %al, $0x80;\n\t"
> >
>
> It's not needed at all, let's drop it.
>
> Paolo
>

If we wanted to be absolutely certain that the extern labels used for
assertions about the guest RIP are correct, we may still want it.
Alternatively, I could rewrite the test such that the guest will
report the instruction boundary where it anticipates MTF whenever it
makes the vmcall to request the host turns on MTF.

--
Thanks,
Oliver
