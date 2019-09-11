Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB0BAF447
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2019 04:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726688AbfIKCdF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Sep 2019 22:33:05 -0400
Received: from mail-ua1-f65.google.com ([209.85.222.65]:35694 "EHLO
        mail-ua1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726683AbfIKCdF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Sep 2019 22:33:05 -0400
Received: by mail-ua1-f65.google.com with SMTP id u18so6290289uap.2
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2019 19:33:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UMm4BNyKL9mvvX8cPDgxn7AcfK1yL1pzXD8Ix6xouBQ=;
        b=ATuXBFYQ0GBhDGJG0IiEXCk+MM3nBsJBm65qQbKisCwcqaaJly6E5QAzKVlaVdDCzV
         HRebZbb7eDQhLVPLMoKBsCdeq5f37quksQzC+sH6w2NUkkJ4pgaYp6zCkMrqaDG0+reD
         IlHtQ9OEkD7GRRirhEr4rft7XbUsxxkimHpyihZ9akltOIeNIs1EjEA4e3/cuMlEJcFS
         nptS5elrjH1OwUvmzheVPrmVmyOn71//z7Uhs0iklIBrmKcr9mPxJWtco883UyuEHAwX
         ta7NnGnBll/5sPXeRozOFMwypt5Jh49Vqn+WxNOoiPtAFzdcBheUwKZ/D/8KcRAqYQi3
         XeZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UMm4BNyKL9mvvX8cPDgxn7AcfK1yL1pzXD8Ix6xouBQ=;
        b=IiU7HXC2rJlt1eW5K9fJhngh/lyVw2d8yqKidnTh6bkypIcIC0Otr7SJiIRMuNfdzQ
         E0tHlGqi0wMrR8woup0/UPKDczwC1yNQeb54cUerG6/hhNEsHHsaOjGvbcahop1/eOFU
         QBxnq2VnrJfjG+BJYyvq2RnZ3htNFKMVnemgl7rgD8nofJUeKQZbxLNcwQrcqPB0HDhE
         93i6S0RRv0kr8NFh+NyzCl3vN2tW+2d1o1eCawYypVWEESnWKa8Skw51DDtmJ2lBR2Ww
         4P7R2PjDA84KiQnhoPiozProqukt7zfd7gjuy2XljcSk0CGOOF/O3myJKflBnOKSoA7U
         iZ+A==
X-Gm-Message-State: APjAAAXAAKuYYHwo+ljXigLFFaP/+2sxxkY+vrnc5mLbK+6dWKnvNgB5
        qZmO9tMLuMBKmGjF3pUORTg1JfeLptvEWvhLZ08n
X-Google-Smtp-Source: APXvYqyh6GyYAOpMagU/R5wETt8R/gR2fD+2d4kp/P6Au0PZ5VtIprufcxe4GE/qQx0EgEv+Vi/J56kYh/i4CnRyTyU=
X-Received: by 2002:ab0:4261:: with SMTP id i88mr16207691uai.95.1568169182268;
 Tue, 10 Sep 2019 19:33:02 -0700 (PDT)
MIME-Version: 1.0
References: <CAGG=3QWNQKejpwhbgDy-WSV1C2sw9Ms0TUGwVk8fgEbg9n0ryg@mail.gmail.com>
 <CALMp9eSWpCWDSCgownxsMVTmJNjMvYMiH0K2ybD6yzGqJNiZrg@mail.gmail.com>
 <20190910175924.GA11151@linux.intel.com> <CAGG=3QVzO_Cu-TqyddbXZ5CrtPkqxsUHUVdCPHwFTm1BfLgQ0g@mail.gmail.com>
In-Reply-To: <CAGG=3QVzO_Cu-TqyddbXZ5CrtPkqxsUHUVdCPHwFTm1BfLgQ0g@mail.gmail.com>
From:   Bill Wendling <morbo@google.com>
Date:   Tue, 10 Sep 2019 21:32:51 -0500
Message-ID: <CAGG=3QUdb6PsB-pDEvCCEkapnZn0kop-=S1orRrCy5s-BcDm2A@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] x86: setjmp: ignore clang's
 "-Wsomtimes-uninitialized" flag
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I sent out a separate patch. PTAL. :-)

On Tue, Sep 10, 2019 at 8:42 PM Bill Wendling <morbo@google.com> wrote:
>
> On Tue, Sep 10, 2019 at 12:59 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > On Tue, Sep 10, 2019 at 09:46:36AM -0700, Jim Mattson wrote:
> > > On Mon, Sep 9, 2019 at 2:10 PM Bill Wendling <morbo@google.com> wrote:
> > > >
> > > > Clang complains that "i" might be uninitialized in the "printf"
> > > > statement. This is a false negative, because it's set in the "if"
> > > > statement and then incremented in the loop created by the "longjmp".
> > > >
> > > > Signed-off-by: Bill Wendling <morbo@google.com>
> > > > ---
> > > >  x86/setjmp.c | 4 ++++
> > > >  1 file changed, 4 insertions(+)
> > > >
> > > > diff --git a/x86/setjmp.c b/x86/setjmp.c
> > > > index 976a632..cf9adcb 100644
> > > > --- a/x86/setjmp.c
> > > > +++ b/x86/setjmp.c
> > > > @@ -1,6 +1,10 @@
> > > >  #include "libcflat.h"
> > > >  #include "setjmp.h"
> > > >
> > > > +#ifdef __clang__
> > > > +#pragma clang diagnostic ignored "-Wsometimes-uninitialized"
> > > > +#endif
> > > > +
> > > >  int main(void)
> > > >  {
> > > >      volatile int i;
> > >
> > > Can we just add an initializer here instead?
> >
> > Doing so would also be a good opportunity to actually report on the
> > expected vs. actual value of 'i' instead of printing numbers that are
> > meaningless without diving into the code.
>
> My initial thought about adding an initializer was that the original
> test wanted to ensure that "i" was initialized after the "setjmp"
> call. But if we report the expected/actual value instead it wouldn't
> be an issue as we can set it to something not expected, etc... I'll
> create a patch.
>
> -bw
