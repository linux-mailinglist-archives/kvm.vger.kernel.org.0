Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5973BAFFB0
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2019 17:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728438AbfIKPMQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Sep 2019 11:12:16 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:34654 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728327AbfIKPMQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Sep 2019 11:12:16 -0400
Received: by mail-io1-f67.google.com with SMTP id k13so31426722ioj.1;
        Wed, 11 Sep 2019 08:12:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hO/NYETIaCmxDsOv4YSewpLm6NfP264tWt7Tht5PRVc=;
        b=lephetGiRU0WJPYILZnpGeGY8fb67wSei8lpY0AzUmFYLYYZLCPr2QCdLVrZ3t9KqF
         VYRvj37vfpGu+yiAbV118YM/11MJeQt43ZHMr3XUooHwIgnEZAXkXmpwJZe97JfITjzm
         gMkhtrmUNbgtvpotn3Ps3YURVWTZw7d5jQoeB8ZqiFHPBQqOwktFsJKGPVQ2MvFqy7XC
         5wf7Cu3g32jyh6iKTGq2us71dxbfV5t0Qws2k9A6k0wStA2mODqcmOUdxF/R5Li9wADS
         PvwkDiEhtOuMIXiFo6eXN/M7r0UwnDWyHgSEi7TkB+U4O5S/iRH2R5EaQb7C+0VOL4OT
         CYnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hO/NYETIaCmxDsOv4YSewpLm6NfP264tWt7Tht5PRVc=;
        b=K7rEUyML1FcIQ4ZO2COL6Cc8tDol8nOt5wYgCrmiGaURMS1dVgtRUWxl6Z94bWrRS0
         oq/Z1mmjodFHoE4L3zauGMFPLjLLRh30pQob6Bc8f3baEloLqj5kw/9B3M+XhE6w7joR
         aD48csyOGQRJrBpBh6ZBVsd7BbO4QfYut0f1SbUzeY5pktD/T0Yv6fqj9Vz7h8/X1SI4
         Zwbdf45J/gtIwQnLWydHbXLo/YZfQBdsimAB8mnJd+VeuP+4rY4BR+wtpBK9V9gkiHqL
         YCWwl52Eo4IY1BelS34C7EbscDW7TN/n1HVvcJGkZiiIsobWLfDL3A6BGwgbG0M2jx0n
         jOMg==
X-Gm-Message-State: APjAAAVZtDaJywkfz8P8scYchtNPURM+ssF668Y2YIYMPU4KqFvag94x
        S+0IT8jeNtyv71nFbtZIwghOlca81YRiTnpgmFQ=
X-Google-Smtp-Source: APXvYqywFmqrX2zinHSJDKlW9JocoMGeJEpO0ksqi5JSiUqBmD89WL+vrXm3nKABzAcwsgWbhHFEtI94/Tj9EgUXE88=
X-Received: by 2002:a5d:8b47:: with SMTP id c7mr28072146iot.42.1568214734894;
 Wed, 11 Sep 2019 08:12:14 -0700 (PDT)
MIME-Version: 1.0
References: <20190907172225.10910.34302.stgit@localhost.localdomain>
 <20190910124209.GY2063@dhcp22.suse.cz> <CAKgT0Udr6nYQFTRzxLbXk41SiJ-pcT_bmN1j1YR4deCwdTOaUQ@mail.gmail.com>
 <20190910144713.GF2063@dhcp22.suse.cz> <CAKgT0UdB4qp3vFGrYEs=FwSXKpBEQ7zo7DV55nJRO2C-KCEOrw@mail.gmail.com>
 <20190910175213.GD4023@dhcp22.suse.cz> <1d7de9f9f4074f67c567dbb4cc1497503d739e30.camel@linux.intel.com>
 <20190911113619.GP4023@dhcp22.suse.cz>
In-Reply-To: <20190911113619.GP4023@dhcp22.suse.cz>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Wed, 11 Sep 2019 08:12:03 -0700
Message-ID: <CAKgT0UfOp1c+ov=3pBD72EkSB9Vm7mG5G6zJj4=j=UH7zCgg2Q@mail.gmail.com>
Subject: Re: [PATCH v9 0/8] stg mail -e --version=v9 \
To:     Michal Hocko <mhocko@kernel.org>
Cc:     Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        virtio-dev@lists.oasis-open.org, kvm list <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Oscar Salvador <osalvador@suse.de>,
        Yang Zhang <yang.zhang.wz@gmail.com>,
        Pankaj Gupta <pagupta@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        Rik van Riel <riel@surriel.com>, lcapitulino@redhat.com,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>, ying.huang@intel.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 11, 2019 at 4:36 AM Michal Hocko <mhocko@kernel.org> wrote:
>
> On Tue 10-09-19 14:23:40, Alexander Duyck wrote:
> [...]
> > We don't put any limitations on the allocator other then that it needs to
> > clean up the metadata on allocation, and that it cannot allocate a page
> > that is in the process of being reported since we pulled it from the
> > free_list. If the page is a "Reported" page then it decrements the
> > reported_pages count for the free_area and makes sure the page doesn't
> > exist in the "Boundary" array pointer value, if it does it moves the
> > "Boundary" since it is pulling the page.
>
> This is still a non-trivial limitation on the page allocation from an
> external code IMHO. I cannot give any explicit reason why an ordering on
> the free list might matter (well except for page shuffling which uses it
> to make physical memory pattern allocation more random) but the
> architecture seems hacky and dubious to be honest. It shoulds like the
> whole interface has been developed around a very particular and single
> purpose optimization.

How is this any different then the code that moves a page that will
likely be merged to the tail though?

In our case the "Reported" page is likely going to be much more
expensive to allocate and use then a standard page because it will be
faulted back in. In such a case wouldn't it make sense for us to want
to keep the pages that don't require faults ahead of those pages in
the free_list so that they are more likely to be allocated? All we are
doing with the boundary list is preventing still resident pages from
being deferred behind pages that would require a page fault to get
access to.

> I remember that there was an attempt to report free memory that provided
> a callback mechanism [1], which was much less intrusive to the internals
> of the allocator yet it should provide a similar functionality. Did you
> see that approach? How does this compares to it? Or am I completely off
> when comparing them?
>
> [1] mostly likely not the latest version of the patchset
> http://lkml.kernel.org/r/1502940416-42944-5-git-send-email-wei.w.wang@intel.com

There have been a few comparisons between this patch set and the ones
from Wei Wang. In regards to the one you are pointing to the main
difference is that I am not permanently locking memory. Basically what
happens is that the iterator will take the lock, pull a few pages,
release the lock while reporting them, and then take the lock to
return those pages, grab some more, and repeat.

I was actually influenced somewhat by the suggestions that patchset
received, specifically I believe it resembles something like what was
suggested by Linus in response to v35 of that patch set:
https://lore.kernel.org/linux-mm/CA+55aFzqj8wxXnHAdUTiOomipgFONVbqKMjL_tfk7e5ar1FziQ@mail.gmail.com/

Basically where the feature Wei Wang was working on differs from this
patch set is that I need this to run continually, his only needed to
run periodically as he was just trying to identify free pages at a
fixed point in time. My goal is to identify pages that have been freed
since the last time I reported them. To do that I need a flag in the
page to identify those pages, and an iterator in the form of a
boundary pointer so that I can incrementally walk through the list
without losing track of freed pages.
