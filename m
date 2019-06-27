Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAA9F5754F
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2019 02:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbfF0AOh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jun 2019 20:14:37 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42861 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726674AbfF0AOh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jun 2019 20:14:37 -0400
Received: by mail-wr1-f68.google.com with SMTP id x17so315916wrl.9
        for <kvm@vger.kernel.org>; Wed, 26 Jun 2019 17:14:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1Xpp3FrB0v5vX+AlQQqeEPPdsnSW5a1MR9EntNXqzJM=;
        b=pj4iJhFEFcX9/TIMZHBPh4iOCaKAIsF86dNpX5xQ2AkniSVpydEb/Flg1fmyY5CczG
         l+HeWT0kuQUK8WN6FpMk2BrAUidDoLBqZ8M2FdORirfp4eCvcrmxBf9JF21g6o4kkKoX
         3JgpbZ4I+7Mr6/tlpGjJSulCtRMhMjFb1rN0r1xvaKM3Ma2gtcyqv+pe3cb3v7hTihy3
         AxucXb+fPFfgN8iffic2H/+E6ePuSR7KJG/JjJazT1k53GrdyKQJjHImqpreXqUEhvGN
         1pBxCvKdM2Ju4NkPA6PV/Y06g+ZmuxmYkC4AzCSR3h3XGok5DkBphKVC8co3H26048Nx
         vH+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1Xpp3FrB0v5vX+AlQQqeEPPdsnSW5a1MR9EntNXqzJM=;
        b=LCdZDre4sx42E49t8Qhv8HJs1H0ZpAWZT8999QTwllYPjPyTj1XRVwUhu7p0Fl7dPx
         bevHDKM2in3FLCrUoWljDhxGKAYNhIXtDmBgB9bX2PQ8kdbH10Fvtut7HWNRVjCvyTme
         fQoIaMyaZxIQ/3OjtsBobDV43rMe1aTKC0ytFy+ozsNNfGlux4xuclL1hkTco4bf5hZg
         MUn1kVG3hsyUUvJrdqnKEoa4TGl4sil0jNBvvhzA0wXsLAq8qD94wD741TzenwP5VYzu
         Aq/0M1VbWlG1X1HeT+j+AvthgLOSld3aQ8zf9TKslb+mnWAUaI7M2YyCJwyf5s07d1CN
         KezA==
X-Gm-Message-State: APjAAAWPDSPs9agKvFPU8GM8F/61eO98Qs3scttpyWH0mXan59N3i2jx
        60oSL2oZmEgtcCqkbfKLqhpUK/nsLnO4dLpUP55mWQ==
X-Google-Smtp-Source: APXvYqzatxsCgB15TSTl+Muehbae/0RuXVL9Y+wVdTFdadgYv9ElChbvbFoVuXoyM8kfJXMbm7PM4jNUddVnE09mbV4=
X-Received: by 2002:a5d:528d:: with SMTP id c13mr298595wrv.247.1561594475051;
 Wed, 26 Jun 2019 17:14:35 -0700 (PDT)
MIME-Version: 1.0
References: <20190625120627.8705-1-nadav.amit@gmail.com> <367500e0-c8f8-f7ca-7f07-5424a05eea80@oracle.com>
In-Reply-To: <367500e0-c8f8-f7ca-7f07-5424a05eea80@oracle.com>
From:   Marc Orr <marcorr@google.com>
Date:   Wed, 26 Jun 2019 17:14:24 -0700
Message-ID: <CAA03e5G7kn3UYjZzRUsJScDJ=cBmqO-pdDm5Ri180vyi-vRa2A@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] x86: Mark APR as reserved in x2APIC
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     Nadav Amit <nadav.amit@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 26, 2019 at 3:32 PM Krish Sadhukhan
<krish.sadhukhan@oracle.com> wrote:
>
>
> On 6/25/19 5:06 AM, Nadav Amit wrote:
> > Cc: Marc Orr <marcorr@google.com>
> > Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
> > ---
> >   lib/x86/apic.h | 1 +
> >   1 file changed, 1 insertion(+)
> >
> > diff --git a/lib/x86/apic.h b/lib/x86/apic.h
> > index 537fdfb..b5bf208 100644
> > --- a/lib/x86/apic.h
> > +++ b/lib/x86/apic.h
> > @@ -75,6 +75,7 @@ static inline bool x2apic_reg_reserved(u32 reg)
> >       switch (reg) {
> >       case 0x000 ... 0x010:
> >       case 0x040 ... 0x070:
> > +     case 0x090:
> >       case 0x0c0:
> >       case 0x0e0:
> >       case 0x290 ... 0x2e0:
>
>
>   0x02f0 which is also reserved, is missing from the above list.

0x02f0 is "LVT CMCI register", right?
