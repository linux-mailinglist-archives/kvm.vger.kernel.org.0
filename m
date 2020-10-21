Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9C229522B
	for <lists+kvm@lfdr.de>; Wed, 21 Oct 2020 20:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504060AbgJUSYs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Oct 2020 14:24:48 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:3527 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438847AbgJUSYr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Oct 2020 14:24:47 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f907ce30000>; Wed, 21 Oct 2020 11:24:35 -0700
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 21 Oct
 2020 18:24:46 +0000
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.46) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 21 Oct 2020 18:24:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rm+V9mype58dG1Zn3Q4vYCV8+Cxb1ZJ2Akx9ftuPjv1hRx1RFYGJqBe2sZ8H7SYfg/8OJRTUIsDSsfBxshzLpw4eEqBVCij5lxHJwYfy/zHkzg263oJsG+qwakMumaovffBoOdGN/YjELH/SSZ8ep1hLR9M9TTFjkpviZkGypA3ASKKcw4Rz/BC97HwPO3iCkxCigUJuw6n7Lf+c/Nlg5dKnBjPOkUwqrIAZSwIE8s+CHfVgPMFmVTAT31CIAw4r8LQiO56FJP5sdtVUn2wN4D4yZ3P79l56LUIvTH6ZNJZhfn9LkFZMiK0FWO3k3Ni1fhDgNmfJ5xVdFEDI4zz8lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0NgPxzLNUZzeKlTpQJekvGEV1+nt/QXlzaHcwUJQt5Y=;
 b=GjfJZ6SJUmFVhiODdyVSwA4hdPb23uJ1Yiei1mJG83BkkUvj0UORM5oXKeW9lLaStg0sLX6NTgG+pfFfDMTBcFlFCTN5bq1+9NcDWl6aA5LEDXzeTBk/On08kAEwJzdj/3SqskRUFMq5IM2qbqLkIgl0yoLLriXK+MQo72wWEAbPp67cvyBIe2sxXB9/dk8akzYd3GSqoeKDUz7mYJBHaBr0yQw+mvXmRPCBRHkbEn2FIWDPNczrHW/NVc4NDf0qFc8/qP3kTc64MVyTaxtMHVCmiMRIeFLg+r3H1EL46wr25SJIFggBXd+GwVTQawKXhxnDdGsqfPAMGKM4Z05YUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB2488.namprd12.prod.outlook.com (2603:10b6:4:b5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.27; Wed, 21 Oct
 2020 18:24:43 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3477.028; Wed, 21 Oct 2020
 18:24:43 +0000
Date:   Wed, 21 Oct 2020 15:24:42 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Raj, Ashok" <ashok.raj@intel.com>
CC:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Wang <jasowang@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Wu, Hao" <hao.wu@intel.com>,
        "stefanha@gmail.com" <stefanha@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "Zhu, Lingshan" <lingshan.zhu@intel.com>
Subject: Re: (proposal) RE: [PATCH v7 00/16] vfio: expose virtual Shared
 Virtual Addressing to VMs
Message-ID: <20201021182442.GU6219@nvidia.com>
References: <20201020140217.GI6219@nvidia.com>
 <20201020162430.GA85321@otc-nc-03> <20201020170336.GK6219@nvidia.com>
 <20201020195146.GA86371@otc-nc-03> <20201020195557.GO6219@nvidia.com>
 <20201020200844.GC86371@otc-nc-03> <20201020201403.GP6219@nvidia.com>
 <20201020202713.GF86371@otc-nc-03> <20201021114829.GR6219@nvidia.com>
 <20201021175146.GA92867@otc-nc-03>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20201021175146.GA92867@otc-nc-03>
X-ClientProxiedBy: MN2PR13CA0026.namprd13.prod.outlook.com
 (2603:10b6:208:160::39) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by MN2PR13CA0026.namprd13.prod.outlook.com (2603:10b6:208:160::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.8 via Frontend Transport; Wed, 21 Oct 2020 18:24:43 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kVImw-003eNU-FQ; Wed, 21 Oct 2020 15:24:42 -0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1603304675; bh=0NgPxzLNUZzeKlTpQJekvGEV1+nt/QXlzaHcwUJQt5Y=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=bdy3zt3UXZqrIG7p7ZaOsWwJgj7Rz3bgeb7w1uBKL6anURiWOqhzAXWNf44TP3U+j
         8vmsREk9wfrTVW0pqV9NRMUnUyn7WL21bO9pgsHpgg0ifGZCm46RR+ogXkQGXbNxeQ
         oJmYDbDLxJJhi41LhZLu70elIlyLtC8CU0wNfcI+eHnUldWFxTwFo51l8CTTLRl0oW
         PUZQAySfiBkCCcJqba2LEEanr2O6F0FlLoOHMiVgFk4+B8XsS2SUL8r5qo0nhF92p8
         ZUGy3C6CqL7EPkHlx2YygPmr1tgCg6u18RkaUI4L8zeBh2K2O7Z7DqgUAfZjYF1HsE
         5/ECpbV+gfrLQ==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 21, 2020 at 10:51:46AM -0700, Raj, Ashok wrote:

> > If they didn't plan to use it, bit of a strawman argument, right?
> 
> This doesn't need to continue like the debates :-) Pun intended :-)
> 
> I don't think it makes any sense to have an abstract strawman argument
> design discussion. Yi is looking into for pasid management alone. Rest 
> of the IOMMU related topics should wait until we have another 
> *real* use requiring consolidation. 

Actually I'm really annoyed right now that the other Intel team wasted
quiet a lot of the rest of our time on arguing about vDPA and vfio
with no actual interest in this technology.

So you'll excuse me if I'm not particularly enamored with this
discussion right now.

> Contrary to your argument, vDPA went with a half blown device only 
> iommu user without considering existing abstractions like containers

VDPA IOMMU was done *for Intel*, as the kind of half-architected thing
you are advocating should be allowed for IDXD here. Not sure why you
think bashing that work is going to help your case here.

I'm saying Intel needs to get its architecture together and stop
ceating this mess across the kernel to support Intel devices.

Jason
