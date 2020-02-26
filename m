Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A150E16F987
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 09:23:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727377AbgBZIXH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Feb 2020 03:23:07 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:33792 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727247AbgBZIXH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Feb 2020 03:23:07 -0500
Received: by mail-lj1-f196.google.com with SMTP id x7so2043449ljc.1
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2020 00:23:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nRyrJ0JXVtXKugLelSGVM5EpQ374/a6s5wZoNbpi0oU=;
        b=rzt7mcbQaAXnc/YOikYn/LG99+3Xutx/j3MoDupiNol9Jz9vqYOUVlzSbnntFveg4C
         hLNFFn+yvSZDoOZNth2vzatr2HWOn0Gh4tkaH86pKH0x/QAhCxKHihqrcEDQ4vBAob8n
         H405O8iCajDEZdqDxOTRRpyc/GTFBhxLNzJPDoy9r1zNVldnWcwKC2nEyr23DOmV0AYO
         7gzGQBE+wNqEJyoXNUopY9euEFxaeAEIoDKc/CeAAg5LyPYjcdXRMgu07GUNh3kRDc7j
         RJoOrJT1fbFmVeo2L2qNiCPANz+qhtbutvSlJ7RxWO1/f10gHAYNJNR2tt/ly3FbZT+G
         NkSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nRyrJ0JXVtXKugLelSGVM5EpQ374/a6s5wZoNbpi0oU=;
        b=mrzJIVsLL6koapjLDeGH89hDi+7/0EPwbuC5AuhfuCAA6L4Tcfjjj7a+7aMgZQcbXk
         rMZ/EJ/bmGxs4qdlsKr874gWXBDXCSdU6T0dDcgWG3pGd93t/fHjJZ4wi6F5t3YPVkwe
         yIspFA/rvinekt1PMk0LnTSKLJKAOWXmpXtA5N2rkuMW//VgHExcYmRfnL5wpSb4rYIJ
         qleYUqp+tcfdl8hX6Is14bZAIUWVqkpNbM30LzDm1uR1/2pRbesHEUN7k8ES8eHGsPg5
         qSlT18euvfX07uDDP/n3tXWilRERMnaK177bxD6c1ks+8KLqtIsayp98lC1hTAKG+w8J
         kauQ==
X-Gm-Message-State: APjAAAVU/eZtBpYeOdgDeJmQF9EXLEFrkunyHN2dajLae8J4/ybJky63
        +iqQajldTtZsrmuDlxZdNM2Knk1ABTtAM2/FVBN3uQ==
X-Google-Smtp-Source: APXvYqyZG7ECRsLYkQgo9u6c7Sg1a9/CJRhVU1QDO7sqSMGVeDZlNXpwqLna0Tno/NNFCaHOj1vAGayVZokey3jkJpk=
X-Received: by 2002:a2e:884c:: with SMTP id z12mr2221324ljj.55.1582705384953;
 Wed, 26 Feb 2020 00:23:04 -0800 (PST)
MIME-Version: 1.0
References: <20200226074427.169684-1-morbo@google.com> <20200226074427.169684-8-morbo@google.com>
 <CAOQ_Qsj-7KB46SR0++iJseOABW=R6WWi4Km-Q0gM5EnSiMMGjw@mail.gmail.com>
In-Reply-To: <CAOQ_Qsj-7KB46SR0++iJseOABW=R6WWi4Km-Q0gM5EnSiMMGjw@mail.gmail.com>
From:   Oliver Upton <oupton@google.com>
Date:   Wed, 26 Feb 2020 00:22:53 -0800
Message-ID: <CAOQ_Qsj+fwkuK=jTfDM00txgwPWKfCMEf9yCuuCMCe94hqtU2Q@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH 7/7] x86: VMX: the "noclone" attribute is gcc-specific
To:     Bill Wendling <morbo@google.com>
Cc:     kvm list <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Blech...

On Wed, Feb 26, 2020 at 12:21 AM Oliver Upton <oupton@google.com> wrote:
>
> On Tue, Feb 25, 2020 at 11:45 PM <morbo@google.com> wrote:
> >
> > From: Bill Wendling <morbo@google.com>
> >
> > Don't use the "noclone" attribute for clang as it's not supported.
> >
> > Signed-off-by: Bill Wendling <morbo@google.com>
> Signed-off-by: Oliver Upton <oupton@google.com>

s/Signed-off-by/Reviewed-by/

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
> >         asm ("vmcall;\n\t"
> >              "out %al, $0x80;\n\t"
> > --
> > 2.25.0.265.gbab2e86ba0-goog
> >
