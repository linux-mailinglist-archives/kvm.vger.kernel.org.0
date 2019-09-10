Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE1D9AED77
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2019 16:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393424AbfIJOmz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Sep 2019 10:42:55 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:34360 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732465AbfIJOmz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Sep 2019 10:42:55 -0400
Received: by mail-io1-f68.google.com with SMTP id k13so22848847ioj.1;
        Tue, 10 Sep 2019 07:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qwfqdrsthj6wGMKbVfq9KS+2D4+bl2wd+HAoXgrqGpM=;
        b=mdlhWpzQsILASMQ7+1ikwT0fUSiwI9Yno2A8k95yLHD6P9eV0S05kOW5Jv6prsMvSt
         iBXlVLmgNneBJJPewyY1Iz+eUwtz//m6IWYeMweTFXG1suDqKgsSJ2xCT/kZ1HcGuX4Y
         n5DFuajmtetj/LpA2LEgEC9oiE4MlkG9fH5vD+eWjaUxrS6bT4PmDA2aOayknXG3RXII
         9e0AvcNoE4ZxbCtIxiI/lT91HGh0dhQFb9BVLzxS7z4Bakuzjqvda8OJvgMc4cNBYsKq
         JywENk314egMFnOMmeOVAlHQzPFr5FrWB11JMPxvnyAvp/9VaOr3lB+4BYVwvWI0USRT
         DKkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qwfqdrsthj6wGMKbVfq9KS+2D4+bl2wd+HAoXgrqGpM=;
        b=Z9LPZMhsolBeT8q3jBZpNieT2wYdkoa/4VTmTXMcfGuh2Y6jsWSoYgTaxevanmkA/k
         1Q3SR6D2IVWgmcWBJumyvlN+SD0PWYd0PZeLkHQUVHz5xdwVcsm+IV/cMaowhPw9j14v
         ftQ+3bWVwMvJ/rYd8bR92mNuZRDRTXPA0H0M7394VUrW1HnWrKe1/7C2L2xYZu4jrqGP
         Q5Ehx5hdBngM+1emZFoaN0k/jc7QEeT1nIU0OcJ8kWa949foPkFugkL9uBSngWz3RFcJ
         PPx1kVfzyJh+PqvbHNjGkE+QuHLBqMcAJiPQB6ZYg1BdfcsvMW0bXdFKzhgjEtDAoRWY
         Up0g==
X-Gm-Message-State: APjAAAWbYmT0uoHevvdwytI1PNgAz8HRx7+MufoYxRvNI6BXe/wNl6Dt
        7VGbILc/Y59ylpi6KcXH+rgac/wt/0SFsRstpbQ=
X-Google-Smtp-Source: APXvYqw25PAt3681VzSp2aKtn4HION8cnSVVgIaDxDN4t5As0qF4aUf02XL+Yw/GC74k1NJX1qc/ljlh1hZcV/Ap7TM=
X-Received: by 2002:a02:9f16:: with SMTP id z22mr31770205jal.83.1568126574433;
 Tue, 10 Sep 2019 07:42:54 -0700 (PDT)
MIME-Version: 1.0
References: <20190907172225.10910.34302.stgit@localhost.localdomain> <20190910124209.GY2063@dhcp22.suse.cz>
In-Reply-To: <20190910124209.GY2063@dhcp22.suse.cz>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 10 Sep 2019 07:42:43 -0700
Message-ID: <CAKgT0Udr6nYQFTRzxLbXk41SiJ-pcT_bmN1j1YR4deCwdTOaUQ@mail.gmail.com>
Subject: Re: [PATCH v9 0/8] stg mail -e --version=v9 \
To:     Michal Hocko <mhocko@kernel.org>
Cc:     virtio-dev@lists.oasis-open.org, kvm list <kvm@vger.kernel.org>,
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
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 10, 2019 at 5:42 AM Michal Hocko <mhocko@kernel.org> wrote:
>
> I wanted to review "mm: Introduce Reported pages" just realize that I
> have no clue on what is going on so returned to the cover and it didn't
> really help much. I am completely unfamiliar with virtio so please bear
> with me.
>
> On Sat 07-09-19 10:25:03, Alexander Duyck wrote:
> [...]
> > This series provides an asynchronous means of reporting to a hypervisor
> > that a guest page is no longer in use and can have the data associated
> > with it dropped. To do this I have implemented functionality that allows
> > for what I am referring to as unused page reporting
> >
> > The functionality for this is fairly simple. When enabled it will allocate
> > statistics to track the number of reported pages in a given free area.
> > When the number of free pages exceeds this value plus a high water value,
> > currently 32, it will begin performing page reporting which consists of
> > pulling pages off of free list and placing them into a scatter list. The
> > scatterlist is then given to the page reporting device and it will perform
> > the required action to make the pages "reported", in the case of
> > virtio-balloon this results in the pages being madvised as MADV_DONTNEED
> > and as such they are forced out of the guest. After this they are placed
> > back on the free list,
>
> And here I am reallly lost because "forced out of the guest" makes me
> feel that those pages are no longer usable by the guest. So how come you
> can add them back to the free list. I suspect understanding this part
> will allow me to understand why we have to mark those pages and prevent
> merging.

Basically as the paragraph above mentions "forced out of the guest"
really is just the hypervisor calling MADV_DONTNEED on the page in
question. So the behavior is the same as any userspace application
that calls MADV_DONTNEED where the contents are no longer accessible
from userspace and attempting to access them will result in a fault
and the page being populated with a zero fill on-demand page, or a
copy of the file contents if the memory is file backed.
