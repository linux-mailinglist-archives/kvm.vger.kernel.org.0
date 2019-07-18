Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B88AF6D5C6
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2019 22:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391655AbfGRU31 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jul 2019 16:29:27 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:43531 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727687AbfGRU31 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Jul 2019 16:29:27 -0400
Received: by mail-qt1-f195.google.com with SMTP id w17so28629901qto.10;
        Thu, 18 Jul 2019 13:29:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JUUHjmg0ZJlEMX+5AtmRzyp8ZylGGNhXn5v6WzeqTo0=;
        b=Y/qJ3wC7lCk9kEZssbkBI/gkQdhuwiy4ifGVRGGiJNvAFxFoCzoCRiVh2OqmkH3nj4
         TjO+9Grh7N49eh/cS4HANTtHCHTBvPydFBIxFWF/UCXTmseqaCEPkadsRMS1lvMwpuKR
         fKfL+c6zkn5Da3l8N/CT17I7zjp8C3+fHViFGjExp8txHDlaq8WaMh3Zw/RvLltA1DNy
         TrfIsCYu/LMC9GO8tvwUbbbrwM1riNmyY0hrBPZYor2C6MBFCZeSb9OPRIe1OS+1zzmv
         GCS80WZE8idvO30m5HjU+OFSnWdyMWVrfYjuCvhqSfSqRPS+HZwa3l6eFd1Ish2WBU5H
         iscg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JUUHjmg0ZJlEMX+5AtmRzyp8ZylGGNhXn5v6WzeqTo0=;
        b=K5XrYbtuUO99wEtpNdh/SzDS15ZDknKgAq9MT+PS6S8C9QFJqJTgLxE9Rbota8Xga1
         5Gt3E4DOH2o2qST/LPgPwroh8VKXwcZiRkoGh1dFwv/l5Jx8JMpw8DttUG4yS+HGeqk4
         gukPVdx/26ta4KW1sUbydT40vF5okhG+Z0DjAMF6zTMPLcYPuBwT2FV8ax05KeW2xfTR
         TNv2T+CtZ5yyAKeyMLBTYyexFP2rhbyk9Bzcgae49WlePIomhUuW0rbShmzuIn+woNpH
         +b2mTw2zLF89waztpJViQBX/d5+vmIM5ZrzIGJtz1/n3W/547248AhUiFPmZiTNisGRj
         3kxw==
X-Gm-Message-State: APjAAAWF8+mxaVmOLMOKYqAcDcP3SrqGYW9YQT2Id1hz3zuepxvGrKnR
        ekknnJwRWRBEy5pdArsYsLUSt9GobieWWhpSF84=
X-Google-Smtp-Source: APXvYqwl+bEO1h8j2u/h/gYaq6zlsr1eertU95oqDRxjqkM7ku54EZON6JrY0jQ1geCz48TkU7laYiYzVhvnq8OjPuQ=
X-Received: by 2002:ac8:2f43:: with SMTP id k3mr34539909qta.179.1563481766276;
 Thu, 18 Jul 2019 13:29:26 -0700 (PDT)
MIME-Version: 1.0
References: <20190716055017-mutt-send-email-mst@kernel.org>
 <CAKgT0Uc-2k9o7pjtf-GFAgr83c7RM-RTJ8-OrEzFv92uz+MTDw@mail.gmail.com>
 <20190716115535-mutt-send-email-mst@kernel.org> <CAKgT0Ud47-cWu9VnAAD_Q2Fjia5gaWCz_L9HUF6PBhbugv6tCQ@mail.gmail.com>
 <20190716125845-mutt-send-email-mst@kernel.org> <CAKgT0UfgPdU1H5ZZ7GL7E=_oZNTzTwZN60Q-+2keBxDgQYODfg@mail.gmail.com>
 <20190717055804-mutt-send-email-mst@kernel.org> <CAKgT0Uf4iJxEx+3q_Vo9L1QPuv9PhZUv1=M9UCsn6_qs7rG4aw@mail.gmail.com>
 <20190718003211-mutt-send-email-mst@kernel.org> <CAKgT0UfQ3dtfjjm8wnNxX1+Azav6ws9zemH6KYc7RuyvyFo3fQ@mail.gmail.com>
 <20190718113548-mutt-send-email-mst@kernel.org>
In-Reply-To: <20190718113548-mutt-send-email-mst@kernel.org>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 18 Jul 2019 13:29:14 -0700
Message-ID: <CAKgT0UeRy2eHKnz4CorefBAG8ro+3h4oFX+z1JY2qRm17fcV8w@mail.gmail.com>
Subject: Re: [PATCH v1 6/6] virtio-balloon: Add support for aerating memory
 via hinting
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        David Hildenbrand <david@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yang Zhang <yang.zhang.wz@gmail.com>, pagupta@redhat.com,
        Rik van Riel <riel@surriel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        lcapitulino@redhat.com, wei.w.wang@intel.com,
        Andrea Arcangeli <aarcange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, dan.j.williams@intel.com,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 18, 2019 at 9:07 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Thu, Jul 18, 2019 at 08:34:37AM -0700, Alexander Duyck wrote:
> > On Wed, Jul 17, 2019 at 10:14 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > >
> > > On Wed, Jul 17, 2019 at 09:43:52AM -0700, Alexander Duyck wrote:
> > > > On Wed, Jul 17, 2019 at 3:28 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > >
> > > > > On Tue, Jul 16, 2019 at 02:06:59PM -0700, Alexander Duyck wrote:
> > > > > > On Tue, Jul 16, 2019 at 10:41 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > >
> > > > > > <snip>
> > > > > >
> > > > > > > > > This is what I am saying. Having watched that patchset being developed,
> > > > > > > > > I think that's simply because processing blocks required mm core
> > > > > > > > > changes, which Wei was not up to pushing through.
> > > > > > > > >
> > > > > > > > >
> > > > > > > > > If we did
> > > > > > > > >
> > > > > > > > >         while (1) {
> > > > > > > > >                 alloc_pages
> > > > > > > > >                 add_buf
> > > > > > > > >                 get_buf
> > > > > > > > >                 free_pages
> > > > > > > > >         }
> > > > > > > > >
> > > > > > > > > We'd end up passing the same page to balloon again and again.
> > > > > > > > >
> > > > > > > > > So we end up reserving lots of memory with alloc_pages instead.
> > > > > > > > >
> > > > > > > > > What I am saying is that now that you are developing
> > > > > > > > > infrastructure to iterate over free pages,
> > > > > > > > > FREE_PAGE_HINT should be able to use it too.
> > > > > > > > > Whether that's possible might be a good indication of
> > > > > > > > > whether the new mm APIs make sense.
> > > > > > > >
> > > > > > > > The problem is the infrastructure as implemented isn't designed to do
> > > > > > > > that. I am pretty certain this interface will have issues with being
> > > > > > > > given small blocks to process at a time.
> > > > > > > >
> > > > > > > > Basically the design for the FREE_PAGE_HINT feature doesn't really
> > > > > > > > have the concept of doing things a bit at a time. It is either
> > > > > > > > filling, stopped, or done. From what I can tell it requires a
> > > > > > > > configuration change for the virtio balloon interface to toggle
> > > > > > > > between those states.
> > > > > > >
> > > > > > > Maybe I misunderstand what you are saying.
> > > > > > >
> > > > > > > Filling state can definitely report things
> > > > > > > a bit at a time. It does not assume that
> > > > > > > all of guest free memory can fit in a VQ.
> > > > > >
> > > > > > I think where you and I may differ is that you are okay with just
> > > > > > pulling pages until you hit OOM, or allocation failures. Do I have
> > > > > > that right?
> > > > >
> > > > > This is exactly what the current code does. But that's an implementation
> > > > > detail which came about because we failed to find any other way to
> > > > > iterate over free blocks.
> > > >
> > > > I get that. However my concern is that permeated other areas of the
> > > > implementation that make taking another approach much more difficult
> > > > than it needs to be.
> > >
> > > Implementation would have to change to use an iterator obviously. But I don't see
> > > that it leaked out to a hypervisor interface.
> > >
> > > In fact take a look at virtio_balloon_shrinker_scan
> > > and you will see that it calls shrink_free_pages
> > > without waiting for the device at all.
> >
> > Yes, and in case you missed it earlier I am pretty sure that leads to
> > possible memory corruption. I don't think it was tested enough to be
> > able to say that is safe.
>
> More testing would be good, for sure.
>
> > Specifically we cannot be clearing the dirty flag on pages that are in
> > use. We should only be clearing that flag for pages that are
> > guaranteed to not be in use.
>
> I think that clearing the dirty flag is safe if the flag was originally
> set and the page has been
> write-protected before reporting was requested.
> In that case we know that page has not been changed.
> Right?

I am just going to drop the rest of this thread as I agree we have
been running ourselves around in circles. The part I had missed was
the part where there are 2 bitmaps and that you are are using
migration_bitmap_sync_precopy() to align the two.

This is just running at the same time as the precopy code and is only
really meant to try and clear the bit before the precopy gets to it
from what I can tell.

So one thing that is still an issue then is that my approach would
only work on the first migration. The problem is the logic I have
implemented assumes that once we have hinted on a page we don't need
to do it again. However in order to support migration you would need
to reset the hinting entirely and start over again after doing a
migration.
