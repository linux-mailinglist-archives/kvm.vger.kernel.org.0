Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72BED5A57F
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2019 21:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbfF1Tzd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jun 2019 15:55:33 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:37337 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726762AbfF1Tzd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jun 2019 15:55:33 -0400
Received: by mail-io1-f65.google.com with SMTP id e5so15031273iok.4;
        Fri, 28 Jun 2019 12:55:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f2yLYBZUi8BM/4wZmIBqHDnSCICFDY3sNbGxuLsfM0k=;
        b=LbcNP/NpYTiLzuG8hu83xxWym0DcCioXNOxYN4/h+QJ/lY70UIce05xClprRUb3M5H
         Kb5diR2YwHMOhaQmb74WhvzthU3Ow8ao+LLv5dKAFH25WUoGyzO0yrr3bbV1JHSTcY3z
         +FpAlFco+H2c4S/AawTfTaqbKTbcoYMb1q7P3gbGfcKTJ8gXRwkOUm2mwRr7YaHluPni
         IObuKWcBf9XhDGZmUlYG+8ULHLTZ4T3ZEgBBaiviHizyEuu+CqlKYnBwR4serz04dKZp
         kMVH8L1/zuf9P0GaHpJ6mTm0s7InpNwiF8ZbulhJdvBKZAoCC30bCwPrtEz1ptajyizj
         mLRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f2yLYBZUi8BM/4wZmIBqHDnSCICFDY3sNbGxuLsfM0k=;
        b=k4ii12X3o90Jco04vV6T4x1vCgGqBnOPZpcAWjohahyoDb9t3A9lXlDNFwO+8e4MhQ
         1eXGvpezN675+FNsiEIU6LpT+Brrb3qJPRhII46zieGLQW5/ab/vkpFDB1373nd3t/lr
         s9CwoG8sb7es1Y1wdMcH8zRWSY/ut3rjpjx9Dctw4+5DykTM+VOuoRbTEsTEZqp0vuWH
         +Xc/HTuecNLztyb7Z/K1ow18Hfz6Yo+4dxCLVZluiC8Ax9I3LNnRTWC6fugbfwjBwlVc
         ypt0t03lLg4ZI5LcxJ9QM1dzhtML0zNQIxwqBXqvjCidmgWdVOv4bl/gbOtVk6Iuqgtv
         EjFQ==
X-Gm-Message-State: APjAAAUAg2RPiUu+LQgoFA6jc69i15BWm/bkEdH8JYC0CJWOqDkxUOsP
        VpLFo1m0m0iGjod45vCiobUZ00IXr7LL6wbeHYtbgA==
X-Google-Smtp-Source: APXvYqy6jPwUSYsREJwQF0076GQ3zmexyIsNehD14G3SWw4LW7DT42vQGbWcnDIisCJFt4I207HSbpWwNYm7IFe9tZA=
X-Received: by 2002:a5d:9dc7:: with SMTP id 7mr13024297ioo.237.1561751732065;
 Fri, 28 Jun 2019 12:55:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190619222922.1231.27432.stgit@localhost.localdomain>
 <20190619223309.1231.16506.stgit@localhost.localdomain> <68ed3507-16dd-2ea3-4a12-09d04a8dd028@intel.com>
In-Reply-To: <68ed3507-16dd-2ea3-4a12-09d04a8dd028@intel.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 28 Jun 2019 12:55:21 -0700
Message-ID: <CAKgT0UcpbU2=RZxam1n84L3XnTqzuBO=S+bkg9R1PQeYUxFYcw@mail.gmail.com>
Subject: Re: [PATCH v1 2/6] mm: Move set/get_pcppage_migratetype to mmzone.h
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        David Hildenbrand <david@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
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

On Tue, Jun 25, 2019 at 11:28 AM Dave Hansen <dave.hansen@intel.com> wrote:
>
> On 6/19/19 3:33 PM, Alexander Duyck wrote:
> > In order to support page aeration it will be necessary to store and
> > retrieve the migratetype of a page. To enable that I am moving the set and
> > get operations for pcppage_migratetype into the mmzone header so that they
> > can be used when adding or removing pages from the free lists.
> ...
> > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> > index 4c07af2cfc2f..6f8fd5c1a286 100644
> > --- a/include/linux/mmzone.h
> > +++ b/include/linux/mmzone.h
>
> Not mm/internal.h?

Yeah, I can probably move those to there. I just need to pull the call
to set_pcpage_migratetype out of set_page_aerated and place it in
aerator_add_to_boundary.
