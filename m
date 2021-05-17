Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8152C383A12
	for <lists+kvm@lfdr.de>; Mon, 17 May 2021 18:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242589AbhEQQhY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 May 2021 12:37:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241086AbhEQQhD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 May 2021 12:37:03 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49C67C05BD09
        for <kvm@vger.kernel.org>; Mon, 17 May 2021 08:35:14 -0700 (PDT)
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 1A3C23A4; Mon, 17 May 2021 17:35:12 +0200 (CEST)
Date:   Mon, 17 May 2021 17:35:10 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Will Deacon <will@kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH 3/6] vfio: remove the unused mdev iommu hook
Message-ID: <YKKNLrdQ4QjhLrKX@8bytes.org>
References: <MWHPR11MB1886E02BF7DE371E9665AA328C519@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210513120058.GG1096940@ziepe.ca>
 <MWHPR11MB1886B92507ED9015831A0CEA8C509@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210514121925.GI1096940@ziepe.ca>
 <MWHPR11MB18866205125E566FE05867A78C509@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210514133143.GK1096940@ziepe.ca>
 <YKJf7mphTHZoi7Qr@8bytes.org>
 <20210517123010.GO1096940@ziepe.ca>
 <YKJnPGonR+d8rbu/@8bytes.org>
 <20210517133500.GP1096940@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210517133500.GP1096940@ziepe.ca>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 17, 2021 at 10:35:00AM -0300, Jason Gunthorpe wrote:
> Well, I'm sorry, but there is a huge other thread talking about the
> IOASID design in great detail and why this is all needed. Jumping into
> this thread without context and basically rejecting all the
> conclusions that were reached over the last several weeks is really
> not helpful - especially since your objection is not technical.
> 
> I think you should wait for Intel to put together the /dev/ioasid uAPI
> proposal and the example use cases it should address then you can give
> feedback there, with proper context.

Yes, I think the next step is that someone who read the whole thread
writes up the conclusions and a rough /dev/ioasid API proposal, also
mentioning the use-cases it addresses. Based on that we can discuss the
implications this needs to have for IOMMU-API and code.

From the use-cases I know the mdev concept is just fine. But if there is
a more generic one we can talk about it.

Regards,

	Joerg

