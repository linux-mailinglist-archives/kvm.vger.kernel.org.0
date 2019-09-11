Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB6D7AFC35
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2019 14:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727744AbfIKMIu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Sep 2019 08:08:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45016 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727342AbfIKMIt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Sep 2019 08:08:49 -0400
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 03C00693FA
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2019 12:08:49 +0000 (UTC)
Received: by mail-qk1-f197.google.com with SMTP id b143so24762237qkg.9
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2019 05:08:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=enh0zIvHZGYnRPPPLW+6aSKLca0Arx8DkKfrIqKoLus=;
        b=BFmfGATgRgo341wvrXCqvarSMWDkF+z8qlM1su3gPhAYhhWisrg2zweMp0i6oz1y/d
         pJ/3k2fw40+zNH5gk/onfkBcrjd6TzQN8QFcLDnZ9okjppVdYf5vV7PwSyAvbAf5DEBr
         jiozmGne0HT/RUphRHSlBXs5uss9cTZMKvP2epy8beDQT2S+qSE1NW5bgMTAZek2FVRT
         Mrx054jGBicKZjBGZp5ckDOsf5wMNdOopDu8kVi+ZIEhibkNLV8K057XUKo5QOsiG6Me
         C2IUhn5oEa8FSZRNGa9ST7p7YB6w12gwnWye6omvhp4rvy8p0Lgs76JuOndOg3FKNO+P
         Rcaw==
X-Gm-Message-State: APjAAAXTh1bzGqmrZzCv9BOA2X35epDqT8KcVwhWFZnknuoHyqUjmuso
        lvsLO6Po/4Ka/jk+s/mmFwry04CTkejU2AHilr4g8mtIvWBSnuGGr5cyIgZ6qSNcb11yd3uCdh6
        5PhK1e4qMHrlK
X-Received: by 2002:ac8:3564:: with SMTP id z33mr18649574qtb.291.1568203728298;
        Wed, 11 Sep 2019 05:08:48 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzeft2UuPFTSdxyb4bOFOk8mjCIC7+wIdafGuW+Aj+RlGHxCc75dN/Ohnmz48toLx7v9uY0nw==
X-Received: by 2002:ac8:3564:: with SMTP id z33mr18649552qtb.291.1568203728135;
        Wed, 11 Sep 2019 05:08:48 -0700 (PDT)
Received: from redhat.com ([80.74.107.118])
        by smtp.gmail.com with ESMTPSA id x12sm8228721qtb.32.2019.09.11.05.08.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Sep 2019 05:08:47 -0700 (PDT)
Date:   Wed, 11 Sep 2019 08:08:38 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Michal Hocko <mhocko@kernel.org>
Cc:     Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        virtio-dev@lists.oasis-open.org, kvm list <kvm@vger.kernel.org>,
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
Subject: Re: [PATCH v9 0/8] stg mail -e --version=v9 \
Message-ID: <20190911080804-mutt-send-email-mst@kernel.org>
References: <20190907172225.10910.34302.stgit@localhost.localdomain>
 <20190910124209.GY2063@dhcp22.suse.cz>
 <CAKgT0Udr6nYQFTRzxLbXk41SiJ-pcT_bmN1j1YR4deCwdTOaUQ@mail.gmail.com>
 <20190910144713.GF2063@dhcp22.suse.cz>
 <CAKgT0UdB4qp3vFGrYEs=FwSXKpBEQ7zo7DV55nJRO2C-KCEOrw@mail.gmail.com>
 <20190910175213.GD4023@dhcp22.suse.cz>
 <1d7de9f9f4074f67c567dbb4cc1497503d739e30.camel@linux.intel.com>
 <20190911113619.GP4023@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190911113619.GP4023@dhcp22.suse.cz>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 11, 2019 at 01:36:19PM +0200, Michal Hocko wrote:
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
> 
> I remember that there was an attempt to report free memory that provided
> a callback mechanism [1], which was much less intrusive to the internals
> of the allocator yet it should provide a similar functionality. Did you
> see that approach? How does this compares to it? Or am I completely off
> when comparing them?
> 
> [1] mostly likely not the latest version of the patchset
> http://lkml.kernel.org/r/1502940416-42944-5-git-send-email-wei.w.wang@intel.com
> 
> -- 
> Michal Hocko
> SUSE Labs

Linus nacked that one. He thinks invoking callbacks with lots of
internal mm locks is too fragile.
