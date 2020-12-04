Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 106B82CEC19
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 11:23:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729835AbgLDKW7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 4 Dec 2020 05:22:59 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:2518 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729763AbgLDKW7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Dec 2020 05:22:59 -0500
Received: from DGGEMM405-HUB.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4CnTJv5JjDzQndf;
        Fri,  4 Dec 2020 18:21:51 +0800 (CST)
Received: from dggemi753-chm.china.huawei.com (10.1.198.139) by
 DGGEMM405-HUB.china.huawei.com (10.3.20.213) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Fri, 4 Dec 2020 18:20:30 +0800
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 dggemi753-chm.china.huawei.com (10.1.198.139) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Fri, 4 Dec 2020 18:20:29 +0800
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.1913.007; Fri, 4 Dec 2020 10:20:27 +0000
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
CC:     Auger Eric <eric.auger@redhat.com>,
        wangxingang <wangxingang5@huawei.com>,
        Xieyingtai <xieyingtai@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "will@kernel.org" <will@kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vivek.gautam@arm.com" <vivek.gautam@arm.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "zhangfei.gao@linaro.org" <zhangfei.gao@linaro.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        qubingbing <qubingbing@hisilicon.com>
Subject: RE: [PATCH v13 07/15] iommu/smmuv3: Allow stage 1 invalidation with
 unmanaged ASIDs
Thread-Topic: [PATCH v13 07/15] iommu/smmuv3: Allow stage 1 invalidation with
 unmanaged ASIDs
Thread-Index: AQHWvZ36CODK3kmCyk2T9hmchYhCqqniWTe/gANqCPCAAQgyAIAABi8Q
Date:   Fri, 4 Dec 2020 10:20:26 +0000
Message-ID: <2de03a797517452cbfeab022e12612b7@huawei.com>
References: <20201118112151.25412-8-eric.auger@redhat.com>
 <1606829590-25924-1-git-send-email-wangxingang5@huawei.com>
 <2e69adf5-8207-64f7-fa8e-9f2bd3a3c4e3@redhat.com>
 <e10ad90dc5144c0d9df98a9a078091af@huawei.com>
 <20201204095338.GA1912466@myrica>
In-Reply-To: <20201204095338.GA1912466@myrica>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.200.67.145]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jean,

> -----Original Message-----
> From: Jean-Philippe Brucker [mailto:jean-philippe@linaro.org]
> Sent: 04 December 2020 09:54
> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Cc: Auger Eric <eric.auger@redhat.com>; wangxingang
> <wangxingang5@huawei.com>; Xieyingtai <xieyingtai@huawei.com>;
> kvm@vger.kernel.org; maz@kernel.org; joro@8bytes.org; will@kernel.org;
> iommu@lists.linux-foundation.org; linux-kernel@vger.kernel.org;
> vivek.gautam@arm.com; alex.williamson@redhat.com;
> zhangfei.gao@linaro.org; robin.murphy@arm.com;
> kvmarm@lists.cs.columbia.edu; eric.auger.pro@gmail.com; Zengtao (B)
> <prime.zeng@hisilicon.com>; qubingbing <qubingbing@hisilicon.com>
> Subject: Re: [PATCH v13 07/15] iommu/smmuv3: Allow stage 1 invalidation with
> unmanaged ASIDs
> 
> Hi Shameer,
> 
> On Thu, Dec 03, 2020 at 06:42:57PM +0000, Shameerali Kolothum Thodi wrote:
> > Hi Jean/zhangfei,
> > Is it possible to have a branch with minimum required SVA/UACCE related
> patches
> > that are already public and can be a "stable" candidate for future respin of
> Eric's series?
> > Please share your thoughts.
> 
> By "stable" you mean a fixed branch with the latest SVA/UACCE patches
> based on mainline? 

Yes. 

 The uacce-devel branches from
> https://github.com/Linaro/linux-kernel-uadk do provide this at the moment
> (they track the latest sva/zip-devel branch
> https://jpbrucker.net/git/linux/ which is roughly based on mainline.)

Thanks. 

Hi Eric,

Could you please take a look at the above branches and see whether it make sense
to rebase on top of either of those?

From vSVA point of view, it will be less rebase hassle if we can do that.

Thanks,
Shameer

> Thanks,
> Jean

