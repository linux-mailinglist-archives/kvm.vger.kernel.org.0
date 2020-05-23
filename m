Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A30431DFAB1
	for <lists+kvm@lfdr.de>; Sat, 23 May 2020 21:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387587AbgEWT10 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 23 May 2020 15:27:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726790AbgEWT10 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 23 May 2020 15:27:26 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6887C061A0E;
        Sat, 23 May 2020 12:27:25 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id c11so14447420ljn.2;
        Sat, 23 May 2020 12:27:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4zh7dLGu7lIkgyTn7FvmIN1ENGY6DqOeI+3TT5hxCt0=;
        b=SDwq+vPLA0VttbVnCIyh849cyujPiB4Sr5VE3OMr00ndVG07fQzr9R15FPIx1iqUtW
         P77gdjZKGBER/wOo6ZfKLZ/MnwEYUsOS6LA6V/sWnAI3xblDIvlXaLbXny+B/Ku6NhEC
         PyMTCg7+1GU1lZL8KcMSVdNbebuXR0Nv3iNLHgWmvgfoOqq9fe2DbeGW8rHwd/rLn3Hc
         6p7pWKUCNCOwYj7fdyTkYx7ypzcitzJAhMGkoXfv8S8zUTNoaJQAnuWwIa4TQjSyu8R9
         aULDf1WC3dkaxWC6o9AnAWGp4HZdj6nTR+qk+RmpStevnJIqDgbfmmrMOwbA1RLcLBRk
         fOJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4zh7dLGu7lIkgyTn7FvmIN1ENGY6DqOeI+3TT5hxCt0=;
        b=qRaM4buyrPdeuPQpk0hAv0az1RRQTGg4jwC9eN0YjNU4Div8THs+GZeMbm9rWeWIOX
         5mdgqofH+C19gLntyR/HaAtjPxLBevnZMXbCjfGmOp3552FdfapR/Foiu/seFA8QWY0B
         9yJyFIJgdlbhFx3bTFbaRxYTKTlNIV09m8WSG0tI1GcDKeVMJQrloD+nYvgV5vWUlzNz
         nrl6H+YRrb91ny9TVamKy6TMWvYwQiGc21r++UC0EWMx9KSWtbAkVskI9+GkdpV9EVSR
         ZX03A6bSwq2UL/i3Ub6ZPCnbeIw7aumQTdjZE5K7b+uI0zGmaXtmJ0IYjHhfFEh586BW
         SKFA==
X-Gm-Message-State: AOAM5336erzi3M+Y0UrINFxUK8sIqEMScGsx1ENpRxNEPfPA/iTr0PlN
        /HTmSju3m1Piqt+Fpy555Y6CmSCJ+p9H4CMks8Q=
X-Google-Smtp-Source: ABdhPJx/aePhkdk7Qd1gPorTLl+bFXIeiWFXCUwHcB1sqn3tOPAQvRYi6F02pl0bBHDR2PIWoOrdqQ4l/KajgyWOA64=
X-Received: by 2002:a2e:99cd:: with SMTP id l13mr10155778ljj.257.1590262043781;
 Sat, 23 May 2020 12:27:23 -0700 (PDT)
MIME-Version: 1.0
References: <1590252072-2793-1-git-send-email-jrdr.linux@gmail.com> <20200523172519.GA17206@bombadil.infradead.org>
In-Reply-To: <20200523172519.GA17206@bombadil.infradead.org>
From:   Souptick Joarder <jrdr.linux@gmail.com>
Date:   Sun, 24 May 2020 01:05:28 +0530
Message-ID: <CAFqt6zZfrdRB5pbHo5nu668yQUaTV9DbV3ZTeFq-UEKjs0X8XQ@mail.gmail.com>
Subject: Re: [linux-next RFC] mm/gup.c: Convert to use get_user_pages_fast_only()
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, acme@kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        namhyung@kernel.org, pbonzini@redhat.com,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Mike Rapoport <rppt@linux.ibm.com>, msuchanek@suse.de,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Linux-MM <linux-mm@kvack.org>,
        kvm@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, May 23, 2020 at 10:55 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Sat, May 23, 2020 at 10:11:12PM +0530, Souptick Joarder wrote:
> > Renaming the API __get_user_pages_fast() to get_user_pages_
> > fast_only() to align with pin_user_pages_fast_only().
>
> Please don't split a function name across lines.  That messes
> up people who are grepping for the function name in the changelog.

Ok.

>
> > As part of this we will get rid of write parameter.
> > Instead caller will pass FOLL_WRITE to get_user_pages_fast_only().
> > This will not change any existing functionality of the API.
> >
> > All the callers are changed to pass FOLL_WRITE.
> >
> > Updated the documentation of the API.
>
> Everything you have done here is an improvement, and I'd be happy to
> see it go in (after fixing the bug I note below).
>
> But in reading through it, I noticed almost every user ...
>
> > -     if (__get_user_pages_fast(hva, 1, 1, &page) == 1) {
> > +     if (get_user_pages_fast_only(hva, 1, FOLL_WRITE, &page) == 1) {
>
> passes '1' as the second parameter.  So do we want to add:
>
> static inline bool get_user_page_fast_only(unsigned long addr,
>                 unsigned int gup_flags, struct page **pagep)
> {
>         return get_user_pages_fast_only(addr, 1, gup_flags, pagep) == 1;
> }
>
Yes, this can be added. Does get_user_page_fast_only() naming is fine ?


> > @@ -2797,10 +2803,7 @@ int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
> >        * FOLL_FAST_ONLY is required in order to match the API description of
> >        * this routine: no fall back to regular ("slow") GUP.
> >        */
> > -     unsigned int gup_flags = FOLL_GET | FOLL_FAST_ONLY;
> > -
> > -     if (write)
> > -             gup_flags |= FOLL_WRITE;
> > +     gup_flags = FOLL_GET | FOLL_FAST_ONLY;
>
> Er ... gup_flags |=, surely?

Poor mistake.


@@ -1998,7 +1998,7 @@ int gfn_to_page_many_atomic(struct
kvm_memory_slot *slot, gfn_t gfn,
        if (entry < nr_pages)
                return 0;

-       return __get_user_pages_fast(addr, nr_pages, 1, pages);
+       return get_user_pages_fast(addr, nr_pages, FOLL_WRITE, pages);

Also this needs to be corrected.
