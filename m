Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9A3AAF416
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2019 03:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbfIKBmX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Sep 2019 21:42:23 -0400
Received: from mail-vk1-f196.google.com ([209.85.221.196]:35101 "EHLO
        mail-vk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726245AbfIKBmX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Sep 2019 21:42:23 -0400
Received: by mail-vk1-f196.google.com with SMTP id d66so4015390vka.2
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2019 18:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=750Rb175/c6zbUjfPT8KwrDDZd6pHNy6vpgdr/FmZA8=;
        b=N8F31FmWi1yQGHxZGPbTmGhMXS5R8mA3mHh6F/zkkduBaJdNmo+xYxdMMmhkZ5kD/e
         jnGea9vprPJiODg8mABuFn0be2pSXouxWQ4Ae/TFF7bIC5Bzsgz0Wl+HUHS0RZYnLueS
         u8aS+SnCFjR7LwI2oEDLqUtCFyISrgfyRzR/kbUuLuRtvWrrAjFJIm6psMFOXEXJyabl
         R9FLkTZOefPyTnkZTu3ZWCPPGEe5aUZTkCzcEgSrxaN9Ot3s3YBoUoRyqgQsxKcfr0bQ
         35bYzUVXXJUDaTCuwonfQjBMhn/u9rdFsXeKUyPuLTuNuTUQY1gT3xg1GFDBXyVJeHh4
         61og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=750Rb175/c6zbUjfPT8KwrDDZd6pHNy6vpgdr/FmZA8=;
        b=rwkvdzGJ4IifrNULj0vYCHXr91hrHqRN52HUt+9REJEuBV6p0L+nBjZntQ2SNtF67f
         hTsU7+srdqU5xrHXndAK48ESZ/I+AfYMxBVn8c7k/jwG2RmsAATYYlYmSf3AHko/OTcl
         k2eAdT1Fhs0QSZh7VC4H9GbjUZVd6a7J75hKYn3tiqnf2qE71h5P6B7eXDPASkHyzExs
         5tv3aJcWr2zOzycFUQbsqVZgsHsyHGQ2R9LjESrrShekUZ4CL+7ODw00AYKisGJnLIfD
         5pAKYMKh/7ByhgT+AcScT7EHIiqeTkh9KYN9Vxq+g57wIpc6g/FjzRjlb0bT2m62+PJm
         ASKA==
X-Gm-Message-State: APjAAAVzAKW/GfWQBhKg1byXxGr3bdpWLOcKGOEtBHXAGJlkuWElEz8D
        omZ2K62HuJBtKOlOSEXR5Cbeo60Msi2mzhmY42Q9
X-Google-Smtp-Source: APXvYqyiItWoHRDfutR/0jQD4JlhUnrf2kFdKRRSBTW0TZ5SGKtqtlwZLzu4PCIRHC5F1Y79ez4UmPQvhjfFs/U4UUA=
X-Received: by 2002:a1f:5243:: with SMTP id g64mr179370vkb.26.1568166141225;
 Tue, 10 Sep 2019 18:42:21 -0700 (PDT)
MIME-Version: 1.0
References: <CAGG=3QWNQKejpwhbgDy-WSV1C2sw9Ms0TUGwVk8fgEbg9n0ryg@mail.gmail.com>
 <CALMp9eSWpCWDSCgownxsMVTmJNjMvYMiH0K2ybD6yzGqJNiZrg@mail.gmail.com> <20190910175924.GA11151@linux.intel.com>
In-Reply-To: <20190910175924.GA11151@linux.intel.com>
From:   Bill Wendling <morbo@google.com>
Date:   Tue, 10 Sep 2019 20:42:09 -0500
Message-ID: <CAGG=3QVzO_Cu-TqyddbXZ5CrtPkqxsUHUVdCPHwFTm1BfLgQ0g@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] x86: setjmp: ignore clang's
 "-Wsomtimes-uninitialized" flag
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 10, 2019 at 12:59 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Tue, Sep 10, 2019 at 09:46:36AM -0700, Jim Mattson wrote:
> > On Mon, Sep 9, 2019 at 2:10 PM Bill Wendling <morbo@google.com> wrote:
> > >
> > > Clang complains that "i" might be uninitialized in the "printf"
> > > statement. This is a false negative, because it's set in the "if"
> > > statement and then incremented in the loop created by the "longjmp".
> > >
> > > Signed-off-by: Bill Wendling <morbo@google.com>
> > > ---
> > >  x86/setjmp.c | 4 ++++
> > >  1 file changed, 4 insertions(+)
> > >
> > > diff --git a/x86/setjmp.c b/x86/setjmp.c
> > > index 976a632..cf9adcb 100644
> > > --- a/x86/setjmp.c
> > > +++ b/x86/setjmp.c
> > > @@ -1,6 +1,10 @@
> > >  #include "libcflat.h"
> > >  #include "setjmp.h"
> > >
> > > +#ifdef __clang__
> > > +#pragma clang diagnostic ignored "-Wsometimes-uninitialized"
> > > +#endif
> > > +
> > >  int main(void)
> > >  {
> > >      volatile int i;
> >
> > Can we just add an initializer here instead?
>
> Doing so would also be a good opportunity to actually report on the
> expected vs. actual value of 'i' instead of printing numbers that are
> meaningless without diving into the code.

My initial thought about adding an initializer was that the original
test wanted to ensure that "i" was initialized after the "setjmp"
call. But if we report the expected/actual value instead it wouldn't
be an issue as we can set it to something not expected, etc... I'll
create a patch.

-bw
