Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A25D6D611
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2019 22:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727928AbfGRUy2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jul 2019 16:54:28 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:46144 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728014AbfGRUy1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Jul 2019 16:54:27 -0400
Received: by mail-qk1-f194.google.com with SMTP id r4so21552639qkm.13;
        Thu, 18 Jul 2019 13:54:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7emRYoT5fb8r2z6gXsWHsiNYUTpTl/PouMaFyVOjnww=;
        b=UTzC65bgSmS0ZVhgdWSoC3T5DMUpzjrxwzvNfIMglsBH1bv2RR184lr6xU7FEpxEwW
         rGcf8KKjlzepDJvuwOk+V7PacziM1Wa46b0Mda1ESFrVemjZtCu3R+3xko8BvfDtYqlg
         NsDu1s5waBUWJQIa+G4+mxanK2mzuA1uLYeDJ0YmKMpRgfFIDKYzNcRSMbNdAPxdNVly
         NAMdVsTdSkjj0OK4oeOSEVmTagAyQ0jo8t/q6CXLUvBEVqDWnX1rqmORNv6VJpEhAiIj
         sf1FZZBwqUMSvo1ik1WbhMkklOPSy7WXWxxCMV3zSbp8gHG/NRQDvDwKM51n95pq/Bvk
         h9jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7emRYoT5fb8r2z6gXsWHsiNYUTpTl/PouMaFyVOjnww=;
        b=Tz7X3mz7MFPYGv6qr0C5kxt3yOcXtDwqhE2XB5FNjzXGgwIshtPIkvUXfmCiWB0EsQ
         hFE1DJK4gPWPba2DO44YWnx5lA8Ud1MgQ/vwW7zDjv4CbSRtZU9F/WjwuZRQMMkmHtgp
         DNvjpxoFY9SAN8ZKF0loAdwt4UiOB0FuFD8XX8c5zyFiWLC9S4dSJH/Jys/mOeRhXV79
         BCRD6AU5es44SPZvSagkmUurknqeA9I8THdMJTQ/7/pSU+VYxU5kCjxD40xNLpcvKTFh
         hHAfXnSvywWwf4gEFQNFRuWvE8GPnKaw5FLwp3y0WEt5t7yla/9ccbfz05PyiLP60ObN
         4Obw==
X-Gm-Message-State: APjAAAUBGrCS9Ggj8xtaFaFym1bo8CARZe1JEFuYv/kgOvQFg8OrG6QZ
        sjDU9tJsYgOU6CZZd/yAWzjLMbKpJvxBt6SH1sE=
X-Google-Smtp-Source: APXvYqzCbtKw7lABM5d7gtaXQR8QpjKah4ysVH7vLjkBhNJeiCYXH0PXPFpR/DGO1YaYtTEaiy/hYhgQ9cACF4oYkSQ=
X-Received: by 2002:a37:7ec1:: with SMTP id z184mr32664238qkc.491.1563483266795;
 Thu, 18 Jul 2019 13:54:26 -0700 (PDT)
MIME-Version: 1.0
References: <20190716115535-mutt-send-email-mst@kernel.org>
 <CAKgT0Ud47-cWu9VnAAD_Q2Fjia5gaWCz_L9HUF6PBhbugv6tCQ@mail.gmail.com>
 <20190716125845-mutt-send-email-mst@kernel.org> <CAKgT0UfgPdU1H5ZZ7GL7E=_oZNTzTwZN60Q-+2keBxDgQYODfg@mail.gmail.com>
 <20190717055804-mutt-send-email-mst@kernel.org> <CAKgT0Uf4iJxEx+3q_Vo9L1QPuv9PhZUv1=M9UCsn6_qs7rG4aw@mail.gmail.com>
 <20190718003211-mutt-send-email-mst@kernel.org> <CAKgT0UfQ3dtfjjm8wnNxX1+Azav6ws9zemH6KYc7RuyvyFo3fQ@mail.gmail.com>
 <20190718113548-mutt-send-email-mst@kernel.org> <CAKgT0UeRy2eHKnz4CorefBAG8ro+3h4oFX+z1JY2qRm17fcV8w@mail.gmail.com>
 <20190718163325-mutt-send-email-mst@kernel.org>
In-Reply-To: <20190718163325-mutt-send-email-mst@kernel.org>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 18 Jul 2019 13:54:15 -0700
Message-ID: <CAKgT0UcFqYm-b1zh4UT8m=3gi950T0c-gsxjhszeVgANfKQCRA@mail.gmail.com>
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

On Thu, Jul 18, 2019 at 1:37 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Thu, Jul 18, 2019 at 01:29:14PM -0700, Alexander Duyck wrote:
> > So one thing that is still an issue then is that my approach would
> > only work on the first migration. The problem is the logic I have
> > implemented assumes that once we have hinted on a page we don't need
> > to do it again. However in order to support migration you would need
> > to reset the hinting entirely and start over again after doing a
> > migration.
>
> Well with precopy at least it's simple: just clear the
> dirty bit, it won't be sent, and then on destination
> you get a zero page and later COW on first write.
> Right?

Are you talking about adding MADV_DONTNEED functionality to FREE_PAGE_HINTS?

> With precopy it is tricker as destination waits until it gets
> all of memory. I think we could use some trick to
> make source pretend it's a zero page, that is cheap to send.

So I am confused again.

What I was getting at is that if I am not mistaken block->bmap is set
to all 1s for each page in ram_list_init_bitmaps(). After that the
precopy starts and begins moving memory over. We need to be able to go
in and hint away all the free pages from that initial bitmap. To do
that we would need to have the "Hinted" flag I added in the patch set
cleared for all pages, and then go through all free memory and start
over in order to hint on which pages are actually free. Otherwise all
we are doing is hinting on which pages have been freed since the last
round of hints.

Essentially this is another case where being incremental is
problematic for this design. What I would need to do is reset the
"Hinted" flag in all of the free pages after the migration has been
completed.
