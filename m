Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22060339A63
	for <lists+kvm@lfdr.de>; Sat, 13 Mar 2021 01:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232602AbhCMARm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 19:17:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231392AbhCMARZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Mar 2021 19:17:25 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29E81C061574
        for <kvm@vger.kernel.org>; Fri, 12 Mar 2021 16:17:25 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id n17so9115541plc.7
        for <kvm@vger.kernel.org>; Fri, 12 Mar 2021 16:17:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bNw8Nj4KXoR/ziuf+ULxcnou2kfkLDqlHRj4OHo0dSM=;
        b=ErMS8H6GO5f8z+jriPNWifU7B3tvasc2pwvwNhvcfmGpFIWFmmD8naAHUtK2nh6TcL
         mTMt/31FihG0jJqlunc/BmR4Wx1BL0AQm7acdBOX6ar1uIo1xlN5rdG1k2S09QBPnlkR
         paK6cSlOHcqPsdUT14Hv/qDAVqhw0JMKAE7QueBXxs4aWFTOz/AcHHGVCoMzMBN+qs07
         lIbIzSoM+wy+MnpyFGAWhP3TdJ3sUElTmAtzlnaeCRNhTrDMKusK4qq575oHQkkpgrmK
         3nEVElcLzujixeu3/pDVxqCwY5noCV/2VlyyLc6YPxSHNz30f2yhn8U9FC1gMdyP54vB
         WYTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bNw8Nj4KXoR/ziuf+ULxcnou2kfkLDqlHRj4OHo0dSM=;
        b=JM4ixAU9B3dOQzotmCfUD7qa+9vXJ0X+dvvpH2vU0+HlgS2BMd/2tNmxa0RNRkIwLD
         +agU6hB6SQlfEBZ+Wc7fRPURU1Jt27zFqFCGLAygPYHzkAIi1aO+f1ws7hDDblWuWiqR
         r7C2Bx7UsosN6lx1RPKcwdHMeGXgS/ERXc1Y1wCQ86Nban1g/FDfBHVL3cJr8ncxF2G6
         RFCN2ABeyQ7zBysX2N2xONoEU9YMiwyse5Gd2bBEAYlhi1uR+/vI4eAjWlT0haQUy7Wj
         l89PUyCmLNysT5upiWyKSLXpF0oS8XvG6SPM0QDwDchMVQKvpAeH5qbaFCGSvmvUN2Ks
         hBTQ==
X-Gm-Message-State: AOAM533O/JaLv2trsTeXzr9hv5n53pGHTrLfJ4yxCTD0XyJ8MTNST5H2
        Q0Q2HhKbQzdJbLNDwhgxhiAXbw==
X-Google-Smtp-Source: ABdhPJw8zx2Vm18vPZwVhmoiKZBNiELL5UQWGkGDZQyzPEStGzVWqCNcQ2H+h6SC2lG2S7AL1yqttw==
X-Received: by 2002:a17:90a:9f48:: with SMTP id q8mr843558pjv.53.1615594644508;
        Fri, 12 Mar 2021 16:17:24 -0800 (PST)
Received: from google.com ([2620:15c:f:10:e1a6:2eeb:4e45:756])
        by smtp.gmail.com with ESMTPSA id jt21sm3177316pjb.51.2021.03.12.16.17.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 16:17:23 -0800 (PST)
Date:   Fri, 12 Mar 2021 16:17:17 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     "wangyanan (Y)" <wangyanan55@huawei.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>
Subject: Re: [PATCH 03/15] KVM: selftests: Align HVA for HugeTLB-backed
 memslots
Message-ID: <YEwEjQZZJXvNWYna@google.com>
References: <20210210230625.550939-1-seanjc@google.com>
 <20210210230625.550939-4-seanjc@google.com>
 <eac3f8b1-0e5b-395f-7fd7-75409554bffc@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eac3f8b1-0e5b-395f-7fd7-75409554bffc@huawei.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 25, 2021, wangyanan (Y) wrote:
> Hi Sean,
> 
> On 2021/2/11 7:06, Sean Christopherson wrote:
> > Align the HVA for HugeTLB memslots, not just THP memslots.  Add an
> > assert so any future backing types are forced to assess whether or not
> > they need to be aligned.
> > 
> > Cc: Ben Gardon <bgardon@google.com>
> > Cc: Yanan Wang <wangyanan55@huawei.com>
> > Cc: Andrew Jones <drjones@redhat.com>
> > Cc: Peter Xu <peterx@redhat.com>
> > Cc: Aaron Lewis <aaronlewis@google.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >   tools/testing/selftests/kvm/lib/kvm_util.c | 5 ++++-
> >   1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> > index 584167c6dbc7..deaeb47b5a6d 100644
> > --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> > +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> > @@ -731,8 +731,11 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
> >   	alignment = 1;
> >   #endif
> > -	if (src_type == VM_MEM_SRC_ANONYMOUS_THP)
> > +	if (src_type == VM_MEM_SRC_ANONYMOUS_THP ||
> > +	    src_type == VM_MEM_SRC_ANONYMOUS_HUGETLB)
> Sorry for the late reply, I just returned from vacation.

At least you had an excuse :-)

> I am not sure HVA alignment is really necessary here for hugetlb pages.
> Different from hugetlb pages, the THP pages are dynamically allocated by
> later madvise(), so the value of HVA returned from mmap() is host page size
> aligned but not THP page size aligned, so we indeed have to perform
> alignment.  But hugetlb pages are pre-allocated on systems. The following
> test results also indicate that, with MAP_HUGETLB flag, the HVA returned from
> mmap() is already aligned to the corresponding hugetlb page size. So maybe
> HVAs of each hugetlb pages are aligned during allocation of them or in mmap()?

Yep, I verified the generic and arch version of hugetlb_get_unmapped_area() that
KVM supports all align the address.  PARISC64 is the only one that looks suspect,
but it doesn't support KVM.

> If so, I think we better not do this again here, because the later
> *region->mmap_size += alignment* will cause one more hugetlb page mapped but
> will not be used.

Agreed.  I think I'll still add the assert, along with a comment calling out
that HugetlB automatically handles alignment.

Nice catch, thanks!
