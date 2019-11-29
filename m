Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D120110DA1B
	for <lists+kvm@lfdr.de>; Fri, 29 Nov 2019 20:26:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727096AbfK2T0M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Nov 2019 14:26:12 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:38077 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726926AbfK2T0L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Nov 2019 14:26:11 -0500
Received: by mail-io1-f68.google.com with SMTP id u24so31770182iob.5;
        Fri, 29 Nov 2019 11:26:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0wi1DGf1/w4RbfpCoKGiIXoKmj2YRN9qTSNLJ8b+j9A=;
        b=AUlgN/ZgY5290u6RblB7c6Z1xjJFoazskwQxrUBYQ3lFnIOz5JxPm6UpoKUenad0E3
         z/6eRJrcrd0DseAi14lvOyGQWVjTtQ2vc8qg3/ioASaz/PIrHFshXS+26Cz1GhoYNnQh
         dC4+cPSV3SIjNXr4JUqvJ1nsLN7kKxZyzMnr6kf25LI3yMzgNVOoWPqO+fJb4hS3eVly
         rfd3KvD9+ux0B9TTpbLfZPONqKaKqTbE6A+coVwv6K31n3uF8gSqo0ebNRVvcLworXTc
         OJtNZaumdE9X5xFk4TVczWqVYfQcV6c3Z9/qoij2SbKGkIR5tzBQlF6KL3Hxa8S6njJ4
         eDQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0wi1DGf1/w4RbfpCoKGiIXoKmj2YRN9qTSNLJ8b+j9A=;
        b=rEd17QyL4ww4DdFGaCSrRsjpT0CsGqmwX0cwWrFwmloupSukvucdO1PrVL6BZ0oOnH
         usFLaaDP9i4+AzvPexuf1bPO0Wv/4q7OqsAYzRL2n/OOxIb2WEqItF7Fm8zmWxo5q996
         n4kYQa78muBnE8vc4Bnjy+s7kdCV1lZQ/s+IcKpKS0i1mTTemOMFZ1n5VdU+O/cwwoI7
         e8sgWYqQpaIAP+fTifnNLN2XAJX6Bk3uMN8hEsXF72OVUtaoeBy7zUF3GeRY/V+QV7OC
         k/YiTjvLlzi+vafCyw6mnmmBcqGD1mOo+TKHXriTRASmSaHz1wCpaqERbvT9mn+T2vBz
         s/Pw==
X-Gm-Message-State: APjAAAUasWFVO6g99z0KIYuYqG07IMFAgiEoxHKbEB85qx0EBtjhQIOp
        PB9xE2iXpP4L3Mj1CODDdoVD4ediGk0EoSaJ4pU=
X-Google-Smtp-Source: APXvYqw8Sn8urET5gD2wFd/upLZDQLG5v+z8uZXczZRd9PFA1AKXcUNY4ZSqQPaI78bevTsdKO25a801EwSx7xuUAX0=
X-Received: by 2002:a5d:8789:: with SMTP id f9mr47221896ion.237.1575055570835;
 Fri, 29 Nov 2019 11:26:10 -0800 (PST)
MIME-Version: 1.0
References: <20191119214454.24996.66289.stgit@localhost.localdomain>
 <20191119214633.24996.46821.stgit@localhost.localdomain> <20191127152422.GE3016@techsingularity.net>
 <0ec9b67cb45cd30f0ff0b2e9dcbc41602de1c178.camel@linux.intel.com>
 <20191127183524.GF3016@techsingularity.net> <6aae7be8a84e7f0622c1f7fd362e4f213aea383d.camel@linux.intel.com>
 <20191128092231.GH3016@techsingularity.net>
In-Reply-To: <20191128092231.GH3016@techsingularity.net>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 29 Nov 2019 11:25:59 -0800
Message-ID: <CAKgT0Ue_r8WFqjRubWUAdJnOBVwxRTs32P99ksnM0NabHawyvA@mail.gmail.com>
Subject: Re: [PATCH v14 3/6] mm: Introduce Reported pages
To:     Mel Gorman <mgorman@techsingularity.net>
Cc:     Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        kvm list <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Michal Hocko <mhocko@kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Yang Zhang <yang.zhang.wz@gmail.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Hildenbrand <david@redhat.com>,
        Pankaj Gupta <pagupta@redhat.com>,
        Rik van Riel <riel@surriel.com>, lcapitulino@redhat.com,
        Dave Hansen <dave.hansen@intel.com>,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Oscar Salvador <osalvador@suse.de>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 28, 2019 at 1:22 AM Mel Gorman <mgorman@techsingularity.net> wrote:
>
> On Wed, Nov 27, 2019 at 01:55:02PM -0800, Alexander Duyck wrote:

< snip >

> > >
> > > Which in itself could be an optimisation patch. Maybe it'll be enough that
> > > keeping track of the count is not worthwhile. Either way, the separate
> > > patch could have supporting data on how much it improves the speed of
> > > reporting pages so it can be compared to any other optimisation that
> > > may be proposed. Supporting data would also help make the case that any
> > > complexity introduced by the optimisation is worthwhile.
> >
> > I'll see what I can do to break this apart. I'm just not a fan of redoing
> > the work multiple times so that I can have a non-optimized version versus
> > an optimized one.
> >
>
> While I understand that, right now the optimisations are blocking the
> feature itself which is also not a situation you want to be in.

I'll see what I can do. I can probably replace the reference count and
zone flags with an atomic state in the prdev that cycles between
inactive, requested, and active. With that I can at least guarantee
that we shouldn't have any races that result in us missing freed
pages. The only downside is that I have to keep a boolean in the
__free_one_page call so that when we free back the reported pages we
don't retrigger the reporting and cause an infinite loop.
