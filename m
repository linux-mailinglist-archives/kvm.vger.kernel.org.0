Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 506B838927E
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 17:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346674AbhESPYy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 11:24:54 -0400
Received: from foss.arm.com ([217.140.110.172]:44984 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354730AbhESPYt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 May 2021 11:24:49 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 34EF511D4;
        Wed, 19 May 2021 08:23:29 -0700 (PDT)
Received: from [10.57.66.179] (unknown [10.57.66.179])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7E1C63F73D;
        Wed, 19 May 2021 08:23:27 -0700 (PDT)
Subject: Re: [PATCH 3/6] vfio: remove the unused mdev iommu hook
To:     Joerg Roedel <joro@8bytes.org>, Jason Gunthorpe <jgg@ziepe.ca>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Will Deacon <will@kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Christoph Hellwig <hch@lst.de>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
References: <MWHPR11MB1886E02BF7DE371E9665AA328C519@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210513120058.GG1096940@ziepe.ca>
 <MWHPR11MB1886B92507ED9015831A0CEA8C509@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210514121925.GI1096940@ziepe.ca>
 <MWHPR11MB18866205125E566FE05867A78C509@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210514133143.GK1096940@ziepe.ca> <YKJf7mphTHZoi7Qr@8bytes.org>
 <20210517123010.GO1096940@ziepe.ca> <YKJnPGonR+d8rbu/@8bytes.org>
 <20210517133500.GP1096940@ziepe.ca> <YKKNLrdQ4QjhLrKX@8bytes.org>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <131327e3-5066-7a88-5b3c-07013585eb01@arm.com>
Date:   Wed, 19 May 2021 16:23:21 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YKKNLrdQ4QjhLrKX@8bytes.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021-05-17 16:35, Joerg Roedel wrote:
> On Mon, May 17, 2021 at 10:35:00AM -0300, Jason Gunthorpe wrote:
>> Well, I'm sorry, but there is a huge other thread talking about the
>> IOASID design in great detail and why this is all needed. Jumping into
>> this thread without context and basically rejecting all the
>> conclusions that were reached over the last several weeks is really
>> not helpful - especially since your objection is not technical.
>>
>> I think you should wait for Intel to put together the /dev/ioasid uAPI
>> proposal and the example use cases it should address then you can give
>> feedback there, with proper context.
> 
> Yes, I think the next step is that someone who read the whole thread
> writes up the conclusions and a rough /dev/ioasid API proposal, also
> mentioning the use-cases it addresses. Based on that we can discuss the
> implications this needs to have for IOMMU-API and code.
> 
>  From the use-cases I know the mdev concept is just fine. But if there is
> a more generic one we can talk about it.

Just to add another voice here, I have some colleagues working on 
drivers where they want to use SMMU Substream IDs for a single hardware 
block to operate on multiple iommu_domains managed entirely within the 
kernel. Using an mdev-like approach with aux domains is pretty much the 
ideal fit for this use-case, while all the IOASID discussion appears 
centred on SVA and userspace interfaces, and as such barely relevant if 
at all.

I seem to recall a non-trivial amount of effort going into the aux 
domain design too, so the promise of replacing it with "a big TBD" just 
because vfio-mdev turned out to be awful hardly fills me with enthusiasm 
either :/

Robin.
