Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24149259DA6
	for <lists+kvm@lfdr.de>; Tue,  1 Sep 2020 19:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbgIARwE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Sep 2020 13:52:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbgIARwB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Sep 2020 13:52:01 -0400
Received: from mail-ua1-x944.google.com (mail-ua1-x944.google.com [IPv6:2607:f8b0:4864:20::944])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31482C061244
        for <kvm@vger.kernel.org>; Tue,  1 Sep 2020 10:52:01 -0700 (PDT)
Received: by mail-ua1-x944.google.com with SMTP id z12so694778uam.12
        for <kvm@vger.kernel.org>; Tue, 01 Sep 2020 10:52:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=LM/90lickBJaNMACbOvycyEGn6a9FzKJ0U/uO72EduU=;
        b=hju9hXEyZJ9W7EcArFXRkj//GhdBJx9t9WVyBsS5qVUMOPxI0SZi60FdZXd9DNc3/C
         S273aVy9mrHuTApmUBWlWClB5O1A52+eO4vMMVNKleLtw+3LtnOSi1YNNS56WBHf3VYe
         QDLb3WmoD2qGaP6w2RMuhDS75IjOokRPl9kWzfiKW2LoVixLj52+4FtQDVBupYZw3rp+
         tctiPNIlTvR1Y+MbRfmljBqzIEFH/K0tjpopvEbxUiWQq1Fyw0dCDOEwp5hKgYfW8aPy
         qUc22zx7ZSF3D4RlmvRYnFUgbqPz0l9KEmQoOSD7Ol59hMYh9qdzbEtk6EmTxiEnKoNa
         L4nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=LM/90lickBJaNMACbOvycyEGn6a9FzKJ0U/uO72EduU=;
        b=BMTkwFnEZrJ7vyXLSqY7TpwUGJBWGBQ9g5iEoBkIm5s0PB0Cj8R/mt09c3C3g5rkWt
         9XOQCtf0YShzg3p3XEIN5AN3k7jwjaPEdAFo9VM93+bnlgcbe8qqGW9i7y42Zrr0Ummo
         WCWrlN0+Zthm83itVdu62D3+15i0ma/nxiPyeEW8CMtnivg1MOnqcBBX4/iUk/WB+ZPu
         BGpCUVGQnepv8L9KqsmVQIcgjYKOEibUlz41vI4/zXWUZVuboCCo/rvt1pgYBmgKwgIS
         xUaoDtVkR/PIM38w/MgVvJw54LmL1dpOqddJT5h3lTB6mjjkOmngQ40h0bb4vIBZPYR1
         jyuA==
X-Gm-Message-State: AOAM533HqZ77PPY/V0zAJEG/IkdtGb78JCDLrLc1hjaZJS0BqikhI19Z
        vuvve1RtayEOnDY+yhOz+PSkwA==
X-Google-Smtp-Source: ABdhPJwd4yAWigNFFp7I++YzQSE/wwvwyWSL4EWTSXtuXfgpD4jtXuOK2Hg4izfmGGMu0At/61qMYw==
X-Received: by 2002:ab0:754d:: with SMTP id k13mr2444657uaq.75.1598982720150;
        Tue, 01 Sep 2020 10:52:00 -0700 (PDT)
Received: from eggly.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 67sm242644vsl.13.2020.09.01.10.51.57
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Tue, 01 Sep 2020 10:51:59 -0700 (PDT)
Date:   Tue, 1 Sep 2020 10:51:55 -0700 (PDT)
From:   Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To:     "Maoming (maoming, Cloud Infrastructure Service Product Dept.)" 
        <maoming.maoming@huawei.com>
cc:     Hugh Dickins <hughd@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "Zhoujian (jay)" <jianjay.zhou@huawei.com>,
        "Huangweidong (C)" <weidong.huang@huawei.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "aarcange@redhat.com" <aarcange@redhat.com>,
        wangyunjian <wangyunjian@huawei.com>
Subject: =?UTF-8?Q?Re=3A_=E7=AD=94=E5=A4=8D=3A_=5BPATCH_V3=5D_vfio_dma=5Fmap=2Funmap=3A_optimized_for_hugetlbfs_pages?=
In-Reply-To: <8B561EC9A4D13649A62CF60D3A8E8CB28C2DC466@dggeml524-mbx.china.huawei.com>
Message-ID: <alpine.LSU.2.11.2009011040560.2984@eggly.anvils>
References: <20200828092649.853-1-maoming.maoming@huawei.com> <alpine.LSU.2.11.2008302332330.2382@eggly.anvils> <8B561EC9A4D13649A62CF60D3A8E8CB28C2DC466@dggeml524-mbx.china.huawei.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 1 Sep 2020, Maoming (maoming, Cloud Infrastructure Service Product Dept.) wrote:
> > 
> > > In the original process of dma_map/unmap pages for VFIO-devices, to
> > > make sure the pages are contiguous, we have to check them one by one.
> > > As a result, dma_map/unmap could spend a long time.
> > > Using the hugetlb pages, we can avoid this problem.
> > > All pages in hugetlb pages are contiguous.And the hugetlb page should
> > > not be split.So we can delete the for loops.
> > 
> > I know nothing about VFIO, but I'm surprised that you're paying such attention
> > to PageHuge hugetlbfs pages, rather than to PageCompound
> > pages: which would also include Transparent Huge Pages, of the traditional
> > anonymous kind, or the huge tmpfs kind, or the more general (not necessarily
> > pmd-sized) kind that Matthew Wilcox is currently working on.
> > 
> > It's true that hugetlbfs is peculiar enough that whatever you write for it may
> > need some tweaks to cover the THP case too, or vice versa; but wouldn't your
> > patch be a lot better for covering all cases?
> > 
> > You mention above that "the hugetlb page should not be split":
> > perhaps you have been worried that a THP could be split beneath you?
> > That used to be a possibility some years ago, but nowadays a THP cannot be
> > split while anyone is pinning it with an extra reference.
> > 
> > Hugh
> > 
> 
> 
> Thanks for your suggestions.
> You mention that a THP cannot be split while anyone is pinning it.
> Do you mean the check of can_split_huge_page()(in split_huge_page_to_list())?

Partly, yes: but that's just a racy check to avoid doing wasted work in
common cases; the more important check comes later in page_ref_freeze(),
which either fails, or prevents anyone else taking a new reference to
the THP (head or tails) while all the work on splitting is being done.

> When we want to pin pages, vfio_pin_pages_remote() always gets a normal page first.
> In this case, a THP cannot be split because of the increased reference.
> Is this right?

Yes.

> 
> Maybe I can optimize for hugetlb pages as a first step,
> and then cover all compound pages.

Okay.  That's definitely a good way to start out - but you may find
that the second step leads you to rewrite every line you wrote before!

Hugh
