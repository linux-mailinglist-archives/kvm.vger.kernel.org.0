Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 252741E069F
	for <lists+kvm@lfdr.de>; Mon, 25 May 2020 08:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388655AbgEYGFG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 May 2020 02:05:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbgEYGFF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 May 2020 02:05:05 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 394D2C061A0E;
        Sun, 24 May 2020 23:05:05 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id z6so19396299ljm.13;
        Sun, 24 May 2020 23:05:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yBEIyGoELaaD+alubGuUtHR8SFOTBJNSGDV1DmXECiU=;
        b=ehQSl2w9nY5dfRV6wriDcpTZGCg4P5IKERzl8jgDRtg3uhpkzAwd3ER92Qp5OiHoL/
         +MhqCnu8zW56GE60KkTpJ3oxdAr6etM08OheP4CCIkAn/xtpCdIWN8MBUnqveJ5A4gLK
         RxkTpS7YVbBXUhcNkQ0TNE9KA9K4ocnXhAr9Xa3XG9LmJrZ/GQj5cA/ExPP8Fd98XPTh
         m6maZFzKLWQYjHH2rRA/tj3ZfnY7463WV62NMrjiV1kJ8DIfE1/EJlw3GwWSPvhUcvDT
         16JRko4weBL9UUlbBUdoncQNMaTcFehwoljIqIq6/MYZcwy7q9UKtzsmUWudXb5uw850
         eMlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yBEIyGoELaaD+alubGuUtHR8SFOTBJNSGDV1DmXECiU=;
        b=ktLFfoAc6yMYdGLzsrg8b9uilvovr858YLIqiA4ZbM8uPgo+wy1es/uVaE4QS5rN6O
         lDyQwl74oP+WA/gt3W/+JjqRhR/DJy7PJm3zTLInnMSJ0BaIK0kNkx2N4m0jeUUstkN8
         WMXWrbxjmE/4ExT3xJirnQhKKSmA6ZoBQVmhvysiNRpB/LtfdXILoAOkgotg1W12zn8o
         Y+V6YbpRFL5wTpYkthOsIPduf3qmE0rZ5eeC1BmzML/70kU3xZHa08qBIKWV7hDUXY1/
         WP3WfT5yEgRkBAjmbPgWk2+0OTJkpyKEg9nd3T8iDMQIT0GNnUXejlZ+rhQ5XyvthK7N
         S89g==
X-Gm-Message-State: AOAM532quZ4dO2BJzYLDx6TyI5rNP/0YfIOiA2dK6u75dBhnwpIYgP4H
        1JC15i0ih2oWB2Kg/cByqfvqWI+xJu9WYYO3D48=
X-Google-Smtp-Source: ABdhPJwOO/TJa9JhhYdJXPau2E/wFjjcMVGycTDzEnfXyjgQyMTqifURPEuLOUykpugkn4KaOaj319Yr0zMyHaEJvV8=
X-Received: by 2002:a2e:b16e:: with SMTP id a14mr12277083ljm.70.1590386703464;
 Sun, 24 May 2020 23:05:03 -0700 (PDT)
MIME-Version: 1.0
References: <1590294434-19125-1-git-send-email-jrdr.linux@gmail.com> <c70dc7fa-352d-9f61-abb9-d578072978c9@nvidia.com>
In-Reply-To: <c70dc7fa-352d-9f61-abb9-d578072978c9@nvidia.com>
From:   Souptick Joarder <jrdr.linux@gmail.com>
Date:   Mon, 25 May 2020 11:43:08 +0530
Message-ID: <CAFqt6zbYbnbc9VHsOJu8J5QFGqSksHVyWF+bD3JqHhxaFeG2Tg@mail.gmail.com>
Subject: Re: [linux-next RFC v2] mm/gup.c: Convert to use get_user_{page|pages}_fast_only()
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, acme@kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        jolsa@redhat.com, namhyung@kernel.org, pbonzini@redhat.com,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Mike Rapoport <rppt@linux.ibm.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>, msuchanek@suse.de,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Linux-MM <linux-mm@kvack.org>,
        kvm@vger.kernel.org, Matthew Wilcox <willy@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 25, 2020 at 6:36 AM John Hubbard <jhubbard@nvidia.com> wrote:
>
> On 2020-05-23 21:27, Souptick Joarder wrote:
> > API __get_user_pages_fast() renamed to get_user_pages_fast_only()
> > to align with pin_user_pages_fast_only().
> >
> > As part of this we will get rid of write parameter. Instead caller
> > will pass FOLL_WRITE to get_user_pages_fast_only(). This will not
> > change any existing functionality of the API.
> >
> > All the callers are changed to pass FOLL_WRITE.
>
> This looks good. A few nits below, but with those fixed, feel free to
> add:
>
>      Reviewed-by: John Hubbard <jhubbard@nvidia.com>
>
> >
> > There are few places where 1 is passed to 2nd parameter of
> > __get_user_pages_fast() and return value is checked for 1
> > like [1]. Those are replaced with new inline
> > get_user_page_fast_only().
> >
> > [1] if (__get_user_pages_fast(hva, 1, 1, &page) == 1)
> >
>
> We try to avoid talking *too* much about the previous version of
> the code. Just enough. So, instead of the above two paragraphs,
> I'd compress it down to:
>
> Also: introduce get_user_page_fast_only(), and use it in a few
> places that hard-code nr_pages to 1.
>
> ...
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 93d93bd..8d4597f 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -1817,10 +1817,16 @@ extern int mprotect_fixup(struct vm_area_struct *vma,
> >   /*
> >    * doesn't attempt to fault and will return short.
> >    */
> > -int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
> > -                       struct page **pages);
> > +int get_user_pages_fast_only(unsigned long start, int nr_pages,
> > +                     unsigned int gup_flags, struct page **pages);
>
> Silly nit:
>
> Can you please leave the original indentation in place? I don't normally
> comment about this, but I like the original indentation better, and it matches
> the pin_user_pages_fast() below, too.
>
> ...
> > @@ -2786,8 +2792,8 @@ static int internal_get_user_pages_fast(unsigned long start, int nr_pages,
> >    * If the architecture does not support this function, simply return with no
> >    * pages pinned.
> >    */
> > -int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
> > -                       struct page **pages)
> > +int get_user_pages_fast_only(unsigned long start, int nr_pages,
> > +                     unsigned int gup_flags, struct page **pages)
>
>
> Same thing here: you've changed the original indentation, which was (arguably, but
> to my mind anyway) more readable, and for no reason. It still would have fit within
> 80 cols.
>
> I'm sure it's a perfect 50/50 mix of people who prefer either indentation style, and
> so for brand new code, I'll remain silent, as long as it is consistent with either
> itself and/or the surrounding code. But changing it back and forth is a bit
> aggravating, and best avoided. :)

Ok, along with these changes I will remove the *RFC* tag and repost it.
