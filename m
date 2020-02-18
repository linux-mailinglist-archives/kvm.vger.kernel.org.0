Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE72E163520
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2020 22:34:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbgBRVek (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 16:34:40 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:44292 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726481AbgBRVek (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 16:34:40 -0500
Received: by mail-pf1-f196.google.com with SMTP id y5so11303784pfb.11
        for <kvm@vger.kernel.org>; Tue, 18 Feb 2020 13:34:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=SBOJ8T4utDvYPiE0OTTO7CUK+naC2X4suhjjDEv6LL4=;
        b=dExiKNGZlBtDf7hUSf4rVsh13WCjcG9t5Bdulzb35GTIcoXedUySK8h3kR2YQDpMQs
         r1zoMxQ4ehTg2SG/32PPtbflzF22b1r/E/wP1PXtxF/KCbBq9Qys1TiuXgQ5krT4zz7Z
         6zosWvFLDPeJx9J+e6M2/6o/6ttomwCwZNEE1kJ+pq/OqVRi1D7soZe3u1ZfIWnOtbkJ
         PUSLxyZXGMJxHiDQl8/1w4zFjBUowijDyigDoWBJF/NGjQvZSZFrtZAml7Lc7suaQHW+
         9WkYKZEe3WA27iK/26JzwY7Q0p+/R38m+XdX+XGDWkLIiC7CY0/Sb79dTfUKCyI4s2Ck
         tFew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=SBOJ8T4utDvYPiE0OTTO7CUK+naC2X4suhjjDEv6LL4=;
        b=J8f9UO+aTw+ez920cUWopPsNA1kMs7O/BpB68i9Nu79ifSU5AZSGRknUrkOeRfrwue
         CTtYGHYe82AYRlVKM5UuRSFKvD7xtr6slIlWKEh2dWY2CEOJUn9MHfoqFBsv6bSIVG4I
         kQ6T/OcR5Cp5vXm9SxQwZYXYjXN4AswPBQXuTrFwEvI7PON4Z1wPkScUNWA1Pd2RZD84
         hGaGhNoSK5991XiW+mc4Pwc6Anw4dGsax3QLLN2Iwdah04z6oHMthpR82kXpmDA362p0
         lb7w0uGJTIsN/Kl4hxnGj7WwCtgseEFoxFbtA0aPN4ZfXIiYMtBSuJmlPMTUTUWCYt6y
         MWxg==
X-Gm-Message-State: APjAAAVKHx3Ux2928CZgkpQpT7VUmx7/Ttyu7lqvWEBg8usc6jCpyp0L
        ZNLyKSNjKTZ5Ng/639eOE66aow==
X-Google-Smtp-Source: APXvYqwNHrRjMtaB9u+Ff4cPws+OQoqOgz3l3RZiwtoYTFRXw1d4mjdChuyHSGVwSsvHA6eW6twvcw==
X-Received: by 2002:a63:6c09:: with SMTP id h9mr24176790pgc.34.1582061677879;
        Tue, 18 Feb 2020 13:34:37 -0800 (PST)
Received: from google.com ([2620:15c:100:202:d78:d09d:ec00:5fa7])
        by smtp.gmail.com with ESMTPSA id g24sm5234048pfk.92.2020.02.18.13.34.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2020 13:34:37 -0800 (PST)
Date:   Tue, 18 Feb 2020 13:34:33 -0800
From:   Oliver Upton <oupton@google.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: Suppress warning in __kvm_gfn_to_hva_cache_init
Message-ID: <20200218213433.GA164161@google.com>
References: <20200218184756.242904-1-oupton@google.com>
 <20200218190729.GD28156@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200218190729.GD28156@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hey Sean,

On Tue, Feb 18, 2020 at 11:07:29AM -0800, Sean Christopherson wrote:
> On Tue, Feb 18, 2020 at 10:47:56AM -0800, Oliver Upton wrote:
> > Particularly draconian compilers warn of a possible uninitialized use of
> > the nr_pages_avail variable. Silence this warning by initializing it to
> > zero.
> 
> Can you check if the warning still exists with commit 6ad1e29fe0ab ("KVM:
> Clean up __kvm_gfn_to_hva_cache_init() and its callers")?  I'm guessing
> (hoping?) the suppression is no longer necessary.

Hmm. I rebased this patch right before sending out + it seems that it is
required (at least for me) to silence the compiler warning. For good
measure, I ran git branch --contains to ensure I had your change. Looks
like my topic branch did in fact have your fix.

--
Oliver

> commit 6ad1e29fe0aba843dfffc714fced0ef6a2e19502
> Author: Sean Christopherson <sean.j.christopherson@intel.com>
> Date:   Thu Jan 9 14:58:55 2020 -0500
> 
>     KVM: Clean up __kvm_gfn_to_hva_cache_init() and its callers
> 
>     Barret reported a (technically benign) bug where nr_pages_avail can be
>     accessed without being initialized if gfn_to_hva_many() fails.
> 
>       virt/kvm/kvm_main.c:2193:13: warning: 'nr_pages_avail' may be
>       used uninitialized in this function [-Wmaybe-uninitialized]
> 
>     Rather than simply squashing the warning by initializing nr_pages_avail,
>     fix the underlying issues by reworking __kvm_gfn_to_hva_cache_init() to
>     return immediately instead of continuing on.  Now that all callers check
>     the result and/or bail immediately on a bad hva, there's no need to
>     explicitly nullify the memslot on error.
> 
>     Reported-by: Barret Rhoden <brho@google.com>
>     Fixes: f1b9dd5eb86c ("kvm: Disallow wraparound in kvm_gfn_to_hva_cache_init")
>     Cc: Jim Mattson <jmattson@google.com>
>     Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>     Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> 
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > ---
> >  virt/kvm/kvm_main.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 70f03ce0e5c1..dc8a67ad082d 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -2219,7 +2219,7 @@ static int __kvm_gfn_to_hva_cache_init(struct kvm_memslots *slots,
> >  	gfn_t start_gfn = gpa >> PAGE_SHIFT;
> >  	gfn_t end_gfn = (gpa + len - 1) >> PAGE_SHIFT;
> >  	gfn_t nr_pages_needed = end_gfn - start_gfn + 1;
> > -	gfn_t nr_pages_avail;
> > +	gfn_t nr_pages_avail = 0;
> >  
> >  	/* Update ghc->generation before performing any error checks. */
> >  	ghc->generation = slots->generation;
> > -- 
> > 2.25.0.265.gbab2e86ba0-goog
> > 
