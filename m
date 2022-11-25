Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 479F9638A5C
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 13:42:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbiKYMmP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Nov 2022 07:42:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbiKYMmO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Nov 2022 07:42:14 -0500
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F7091086
        for <kvm@vger.kernel.org>; Fri, 25 Nov 2022 04:42:12 -0800 (PST)
Received: by mail-qk1-x735.google.com with SMTP id p18so2559672qkg.2
        for <kvm@vger.kernel.org>; Fri, 25 Nov 2022 04:42:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AXnQVTJbjL0K8bweNYfJIDhmo5mKhRKv6UCn43ckNoA=;
        b=hFA5mhB4gYkZ6dvymO+yCPpHJr4wYTRpVwdug8QvW7UnFNDL6rM0WQidk6U/8qnTmS
         rui6AG08HaVf6nQmnTnBdlEE9Z1O0PNZ5Zf4hPjr7y7FUZbubqO+E1MYLLblaUSPcf+u
         WgAZKKDew/hQed/WOMYr/z57cAUZ7E7xyousQrLXF5xvNJTBeIl6pqcNeGz3aI2GAfms
         uyXHDGwBFg9vDswitm+ryD8XHSdIWIfsOJS+h7VsGtYRKk+x38imYZVeiOsQgZ6Rggyh
         EmU5kc3SXe4hExSA0Pcs1Eu4bdDXbeKHwoR91q37q0Xbl1gqIVgOrmv9BA8rOAc6DDl4
         H+eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AXnQVTJbjL0K8bweNYfJIDhmo5mKhRKv6UCn43ckNoA=;
        b=3bUpnr6I7/TJSZpLAW1vNCrf4gIVTgCg6j1q8TK1m+ID18DHq+k94Ph62paxtVOEjn
         T3q23G0log1ggB9GMpmAhc4jF3pq5KsNVvi76dKsLdPI7Shhi6cl+WKiccuUpl9FaoNI
         0JIXH2M2TdfVx2NDljJnZIFRIihCbV4k/A02tmYkPlFKv/nAZU18DPPPMmHGx8C8QBxr
         zn4KtbEAUbx/T/0efQRuaHfo384Q5V219DkGhCbtc4SCkfKCtQ2f87HSYnI8jgf/QwOS
         y8GehM//7B62VgmKOjVCGASYSx6L0CpXiZ+txk8hkyZrDp/qvc6myytcfbV4a4ud2Gjq
         aNPw==
X-Gm-Message-State: ANoB5plAxb6BI8QIUnP1CLZReHvP07s6f9AmEA2N/IfD77cIWd7bWNFA
        R3s56wcIbFa9Sbm3rNRjAdixcQ==
X-Google-Smtp-Source: AA0mqf7H2Z6S0Nl+QLspuujn/xhlSfOTbB1s2HR1GB3WNdjaKzOBGpuvEhnFpKyZCppyd1c8z5EM2w==
X-Received: by 2002:ae9:f404:0:b0:6fa:22a2:6d80 with SMTP id y4-20020ae9f404000000b006fa22a26d80mr32718830qkl.210.1669380131577;
        Fri, 25 Nov 2022 04:42:11 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-122-23.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.122.23])
        by smtp.gmail.com with ESMTPSA id l4-20020ac84a84000000b003a57a317c17sm2162966qtq.74.2022.11.25.04.42.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Nov 2022 04:42:10 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1oyY1x-00DRrF-O5;
        Fri, 25 Nov 2022 08:42:09 -0400
Date:   Fri, 25 Nov 2022 08:42:09 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     kvm@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Avihai Horon <avihaih@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH v1 2/2] vfio/iova_bitmap: Fix PAGE_SIZE unaligned bitmaps
Message-ID: <Y4C4ITz7oCFBmjWi@ziepe.ca>
References: <20221025193114.58695-1-joao.m.martins@oracle.com>
 <20221025193114.58695-3-joao.m.martins@oracle.com>
 <Y3+1/a25zcxNT3He@ziepe.ca>
 <8914ef49-aad4-1461-1176-6d46190d5cd8@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8914ef49-aad4-1461-1176-6d46190d5cd8@oracle.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 25, 2022 at 10:37:39AM +0000, Joao Martins wrote:

> > Yes, when we move this to iommufd the test suite should be included,
> > either as integrated using the mock domain and the selftests or
> > otherwise.
>
> So in iommufd counterpart I have already tests which exercise this. But not as
> extensive.

We are getting to the point where we should start posting the iommufd
dirty tracking stuff. Do you have time to work on it for the next
cycle? Meaning get it largely sorted out in the next 3 weeks for review?

> > void iova_bitmap_set(struct iova_bitmap *bitmap,
> > 		     unsigned long iova, size_t length)
> > {
> > 	struct iova_bitmap_map *mapped = &bitmap->mapped;
> > 	unsigned cur_bit =
> > 		((iova - mapped->iova) >> mapped->pgshift) + mapped->pgoff * 8;
> > 	unsigned long last_bit =
> > 		(((iova + length - 1) - mapped->iova) >> mapped->pgshift) +
> > 		mapped->pgoff * 8;
> > 
> > 	do {
> > 		unsigned int page_idx = cur_bit / BITS_PER_PAGE;
> > 		unsigned int nbits =
> > 			min(BITS_PER_PAGE - cur_bit, last_bit - cur_bit + 1);

min(BITS_PER_PAGE - (cur_bit % BITS_PER_PAGE), ...)

> Not sure if the vfio tree is a rebasing tree (or not?) and can just send a new
> version, 

It isn't, you should just post a new patch on top of Alex's current
tree "rework iova_bitmap_et to handle all page crossings" and along
the way revert the first bit

Jason
