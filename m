Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 312B325335D
	for <lists+kvm@lfdr.de>; Wed, 26 Aug 2020 17:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728041AbgHZPRi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Aug 2020 11:17:38 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:58773 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726750AbgHZPPk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 Aug 2020 11:15:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598454937;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=U5sNgrzn5FhTxLM1sS1TXXuO7hObBpky+B+k/luMmaw=;
        b=UeiB8mkhlR2jym4z/QqalwwuDQ0FETfHGzLL5Td9bbpbvPy8jym6RmMkuMOAV1XNPdxgRH
        y8MRKvm0P7OU+J/mjd7Mx6fSBcb4eGQSLKJsDw8Skn1bKXRCwkrdCM222HSjjcVKo+d4KK
        H1fGb2/6XkPOUWIuzEpuZR7yHpCh5w8=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-356-hxNwlLznMDeRbvI45TXYtQ-1; Wed, 26 Aug 2020 11:15:24 -0400
X-MC-Unique: hxNwlLznMDeRbvI45TXYtQ-1
Received: by mail-qk1-f198.google.com with SMTP id n128so1934157qke.2
        for <kvm@vger.kernel.org>; Wed, 26 Aug 2020 08:15:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=U5sNgrzn5FhTxLM1sS1TXXuO7hObBpky+B+k/luMmaw=;
        b=nrqbBJNoP4+oTROqMvAcpuwezmgkJWO6X3Qvji/OQo/3YgNbG16B4Cx/Fks5jY1EQe
         RWs1bq81ckf2KINk5fAcWWiKYVXW9VbGtng6NJvIhjB9gEKMSKKFA+FJkfLItcsTpjJg
         hD1uZ4DplG13gksWzU6qyUKweoOcJX/ARc6dVR4lYTs2WjfWHCbXgj2z2KhBDPolLGTF
         gXrg6Q0Le4M3oLGmzdCb7WqM8rxx3gFI3MzsgtFdDSmBAoCrMuUsUxmbzgpKYY0F8agJ
         yqM+6cXnIaejPetO3ZJuQ1uFZlvmd/pseF6GAGF5v/Qo1EN/8N8wIWUuvL32sgFDCBB1
         4kDw==
X-Gm-Message-State: AOAM532PEXRHhT6GFt36TeECycEkH47UcLWecUq0eIBnPwej1sLzgvug
        /ShlITaA88KbZ+k22QnqpZNTGUOMIBpxIqk28KEvWGABb+X7dIVSuyGqjaEak50mbUYscGNbJbO
        naFKrqshkyJrx
X-Received: by 2002:ad4:41c9:: with SMTP id a9mr14376484qvq.171.1598454912565;
        Wed, 26 Aug 2020 08:15:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx8D+KxCEvE3v1gysX35rDUKFgHfo42TjV0oOlLWCA309rI6rx4ComNW4vhIgH0v5SazHqK1Q==
X-Received: by 2002:ad4:41c9:: with SMTP id a9mr14376450qvq.171.1598454912268;
        Wed, 26 Aug 2020 08:15:12 -0700 (PDT)
Received: from xz-x1 (bras-vprn-toroon474qw-lp130-11-70-53-122-15.dsl.bell.ca. [70.53.122.15])
        by smtp.gmail.com with ESMTPSA id g21sm2218058qts.18.2020.08.26.08.15.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 08:15:10 -0700 (PDT)
Date:   Wed, 26 Aug 2020 11:15:09 -0400
From:   Peter Xu <peterx@redhat.com>
To:     "Maoming (maoming, Cloud Infrastructure Service Product Dept.)" 
        <maoming.maoming@huawei.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "Zhoujian (jay)" <jianjay.zhou@huawei.com>,
        "Huangweidong (C)" <weidong.huang@huawei.com>,
        "aarcange@redhat.com" <aarcange@redhat.com>,
        wangyunjian <wangyunjian@huawei.com>
Subject: Re: =?utf-8?B?562U5aSNOiBbUEFUQw==?= =?utf-8?Q?H?= V2] vfio
 dma_map/unmap: optimized for hugetlbfs pages
Message-ID: <20200826151509.GD8235@xz-x1>
References: <20200814023729.2270-1-maoming.maoming@huawei.com>
 <20200825205907.GB8235@xz-x1>
 <8B561EC9A4D13649A62CF60D3A8E8CB28C2D9ABB@dggeml524-mbx.china.huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8B561EC9A4D13649A62CF60D3A8E8CB28C2D9ABB@dggeml524-mbx.china.huawei.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 26, 2020 at 01:56:43PM +0000, Maoming (maoming, Cloud Infrastructure Service Product Dept.) wrote:
> > +	/*
> > +	 * Unlike THP, the splitting should not happen for hugetlb pages.
> > +	 * Since PG_reserved is not relevant for compound pages, and the pfn of
> > +	 * PAGE_SIZE page which in hugetlb pages is valid,
> > +	 * it is not necessary to check rsvd for hugetlb pages.
> > +	 * We do not need to alloc pages because of vaddr and we can finish all
> > +	 * work by a single operation to the head page.
> > +	 */
> > +	atomic_add(contiguous_npage, compound_pincount_ptr(head));
> > +	page_ref_add(head, contiguous_npage);
> > +	mod_node_page_state(page_pgdat(head), NR_FOLL_PIN_ACQUIRED, 
> > +contiguous_npage);
> 
> I think I asked this question in v1, but I didn't get any answer... So I'm trying again...
> 
> Could I ask why manual referencing of pages is done here rather than using
> pin_user_pages_remote() just like what we've done with vaddr_get_pfn(), and let
> try_grab_page() to do the page reference and accountings?
> 
> I feel like this at least is against the FOLL_PIN workflow of gup, because those FOLL_PIN paths were bypassed, afaict.
> 
> 
> Hi,
> My apologies for not answering your question.
> As I understand, pin_user_pages_remote() might spend much time.
> Because all PAGE_SIZE-pages in a hugetlb page are pinned one by one in pin_user_pages_remote() and try_grab_page().
> So I think maybe we can use these simple code to do all work.
> Am I wrong? And is there something else we can use? For example :pin_user_pages_fast()

Yeah I can understand your concern, however so far it's not about the perf but
correctness.  Documentation/core-api/pin_user_pages.rst tells us that we should
always use pin_user_page*() APIs to pin DMA pages (with FOLL_LONGTERM).  That's
something we should follow for now, otherwise the major logic of either
FOLL_PIN or FULL_LONGTERM could be bypassed without being noticed.

I'm not sure whether the perf issue is a big one.  So have you tried the pin
page APIs first and did some measurement?  There is indeed a tight loop in
follow_hugetlb_page() however not sure how much it'll affect VFIO_IOMMU_MAP_DMA
in general.  Even if we want to do something, it seems to be more suitable to
be done inside follow_hugetlb_page() rather than in vfio, imho.

Another comment is about the design of the whole patch - I think Alex commented
on that too on the awkwardness on appending the hugetlbfs logic to the end of
the existing logic.  Considering that current logic of vfio_pin_pages_remote()
is "let's pin some pages as long as continuous", not sure whether we can make
it into:

vfio_pin_pages_remote()
{
  if (PageHuge(first_page))
    vfio_pin_pages_hugetlbfs();
  else
    vfio_pin_pages_normal();
}

The thing is, if the 1st page is normal page, then the follow-up pages
shouldn't normally be hugetlbfs pages so they won't be physically continuous.
Vice versa.  In other words, each call to vfio_pin_pages_remote() should only
handle only one type of page after all.  So maybe we can diverge them at the
beginning of the call directly.

-- 
Peter Xu

