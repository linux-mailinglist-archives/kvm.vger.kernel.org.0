Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74E302943BF
	for <lists+kvm@lfdr.de>; Tue, 20 Oct 2020 22:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391626AbgJTUOK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 16:14:10 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:17805 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391350AbgJTUOJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Oct 2020 16:14:09 -0400
Received: from HKMAIL104.nvidia.com (Not Verified[10.18.92.77]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f8f450f0000>; Wed, 21 Oct 2020 04:14:07 +0800
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HKMAIL104.nvidia.com
 (10.18.16.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 20 Oct
 2020 20:14:07 +0000
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (104.47.45.58) by
 HKMAIL104.nvidia.com (10.18.16.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 20 Oct 2020 20:14:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e3EO8F0CcDqjBwQQBd+1aLM1gpj7MK5+kF4qFt2JA1YsNUgWHhosV/XKgXO7pSuuRKdONDK7WOsgExZ19Wz6KQgMNDidHY3j/T3IaznU6A0bC/aDaY9i3iyru4XPi3gRWBUxn8e4Mr5tVsPT76XSrJDXvU2So2gHFkH1aQYXQN9+57R4VmY9YJzgGC3IZjV9xQsTQw0lR0u9U5pGx2lAyHOJwtLByvqiWn1BT+lGtqQb0+ini/L347yid3hU/NzWIv/7zKCIoidvK+PbuZoKYul1HjyUrI8EGnlaKRgxrhoamxn1LBfzh9OLNGd6RPsUgITpje8qU6Kszf1Y8a2Emw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p5Ba6dg+i1RCKO5FPV8FqnHKDVsrkcmDOGp/cxLR0tY=;
 b=OgnjWnxIbyoE0ViV5J2kpP3cFZqToT5SLbURoGJLo3HBI/vy2Ym84HCj9WLjtoi6PJzzPfwESagt0WbL8uG15Bk4RCUH+16vDDYSoHwMEYPupLpOTyFY3GplXbKoinE8uXUPYk15gWJ59Yxm5oG8wlxoLrdybJnGW1T1f+n7O0KLFqKqU6+ZgLMdDTQb2QLhJwrisn3MA178+Jffs/lQTUXG4ov3VkJW7nL1I92yQXQiWHiyQcI6SeMGwRtGG/GS4oeR6lapnrQe6UfpVxAnfRXSzkyWU4wfEprFLoOqA0k8NAhr8r/Dc7noaqRUkaTezMcb/WepZ6xu+g0daTQcSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB2582.namprd12.prod.outlook.com (2603:10b6:4:b5::37) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.28; Tue, 20 Oct
 2020 20:14:04 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3477.028; Tue, 20 Oct 2020
 20:14:04 +0000
Date:   Tue, 20 Oct 2020 17:14:03 -0300
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
Message-ID: <20201020201403.GP6219@nvidia.com>
References: <20201016153632.GM6219@nvidia.com>
 <DM5PR11MB1435A3AEC0637C4531F2FE92C31E0@DM5PR11MB1435.namprd11.prod.outlook.com>
 <20201019142526.GJ6219@nvidia.com>
 <DM5PR11MB14354A8A126E686A5F20FEC2C31F0@DM5PR11MB1435.namprd11.prod.outlook.com>
 <20201020140217.GI6219@nvidia.com> <20201020162430.GA85321@otc-nc-03>
 <20201020170336.GK6219@nvidia.com> <20201020195146.GA86371@otc-nc-03>
 <20201020195557.GO6219@nvidia.com> <20201020200844.GC86371@otc-nc-03>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20201020200844.GC86371@otc-nc-03>
X-ClientProxiedBy: MN2PR19CA0002.namprd19.prod.outlook.com
 (2603:10b6:208:178::15) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by MN2PR19CA0002.namprd19.prod.outlook.com (2603:10b6:208:178::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Tue, 20 Oct 2020 20:14:04 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kUy1D-00385i-4W; Tue, 20 Oct 2020 17:14:03 -0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1603224847; bh=p5Ba6dg+i1RCKO5FPV8FqnHKDVsrkcmDOGp/cxLR0tY=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=BHzdHWkEYXKVk+mjkQpgYQBuv7JMnpMQsDTz0Do82+7jaBP7ATFQug7YFBpzMG0ny
         Ce9XSbX7OlgNDurktyXei/5kIVPvS3dqlmDcf43+4TwOcZL4/DmpDmP52gN6wG70jG
         KGZYPJi54qKwBJ4PXA29/7oqPO2CJ/eQzKH/wVrML0/oCZzunYFBjWZ4aVvDXCO5zq
         0WM1ky8YP4Tt6But+Zl7FMjidvdLpojHbDeAeKzBhus6H/i/0NbXaFf+umWskQBgrF
         dvuaY+vJDORQs44wx52d8Qct8FH5KA9AmwmXA1BqlqIqOsnu94WC7y8jFJ5qdL+FKa
         ZHCdY9WzqAW2A==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 20, 2020 at 01:08:44PM -0700, Raj, Ashok wrote:
> On Tue, Oct 20, 2020 at 04:55:57PM -0300, Jason Gunthorpe wrote:
> > On Tue, Oct 20, 2020 at 12:51:46PM -0700, Raj, Ashok wrote:
> > > I think we agreed (or agree to disagree and commit) for device types that 
> > > we have for SIOV, VFIO based approach works well without having to re-invent 
> > > another way to do the same things. Not looking for a shortcut by any means, 
> > > but we need to plan around existing hardware though. Looks like vDPA took 
> > > some shortcuts then to not abstract iommu uAPI instead :-)? When all
> > > necessary hardware was available.. This would be a solved puzzle. 
> > 
> > I think it is the opposite, vIOMMU and related has outgrown VFIO as
> > the "home" and needs to stand alone.
> > 
> > Apparently the HW that will need PASID for vDPA is Intel HW, so if
> 
> So just to make this clear, I did check internally if there are any plans
> for vDPA + SVM. There are none at the moment. 

Not SVM, SIOV.

Jason
