Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 074141A319D
	for <lists+kvm@lfdr.de>; Thu,  9 Apr 2020 11:15:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbgDIJPg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 9 Apr 2020 05:15:36 -0400
Received: from mga05.intel.com ([192.55.52.43]:2570 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725783AbgDIJPg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Apr 2020 05:15:36 -0400
IronPort-SDR: YE+BXvrsLWuYVgaf4Gu4roxVU1q/OOKvm/V9Af2Q/X3Cln6wMKJQSr34u2D9dUBz8+2X1/hUff
 wcPAacJBbuNg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2020 02:15:35 -0700
IronPort-SDR: LKI2mMlF5gRpfCpUQKmtzZ9HxbE2ZCqbs8lOz4VEi0+4c9z2xO8vzNilg/v2NJuYCA6ZkGE25f
 Tbc1DvUcnVCA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,362,1580803200"; 
   d="scan'208";a="270024062"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by orsmga002.jf.intel.com with ESMTP; 09 Apr 2020 02:15:35 -0700
Received: from fmsmsx111.amr.corp.intel.com (10.18.116.5) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 9 Apr 2020 02:15:34 -0700
Received: from shsmsx107.ccr.corp.intel.com (10.239.4.96) by
 fmsmsx111.amr.corp.intel.com (10.18.116.5) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 9 Apr 2020 02:15:33 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.225]) by
 SHSMSX107.ccr.corp.intel.com ([169.254.9.191]) with mapi id 14.03.0439.000;
 Thu, 9 Apr 2020 17:15:30 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wu, Hao" <hao.wu@intel.com>
Subject: RE: [PATCH v1 6/8] vfio/type1: Bind guest page tables to host
Thread-Topic: [PATCH v1 6/8] vfio/type1: Bind guest page tables to host
Thread-Index: AQHWAEUdkW8K+/kg/06c7098DvJyv6hgm8wAgANYlCCAAK00AIAA6IawgAEUvACABu4SMIACfjcAgACRzFA=
Date:   Thu, 9 Apr 2020 09:15:29 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A228CCA@SHSMSX104.ccr.corp.intel.com>
References: <1584880325-10561-1-git-send-email-yi.l.liu@intel.com>
 <1584880325-10561-7-git-send-email-yi.l.liu@intel.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D7FF98F@SHSMSX104.ccr.corp.intel.com>
 <A2975661238FB949B60364EF0F2C25743A21D8C6@SHSMSX104.ccr.corp.intel.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D805F75@SHSMSX104.ccr.corp.intel.com>
 <A2975661238FB949B60364EF0F2C25743A21ED01@SHSMSX104.ccr.corp.intel.com>
 <20200403083407.GB1269501@myrica>
 <A2975661238FB949B60364EF0F2C25743A224C8F@SHSMSX104.ccr.corp.intel.com>
 <20200409082846.GE2435@myrica>
In-Reply-To: <20200409082846.GE2435@myrica>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Sent: Thursday, April 9, 2020 4:29 PM
> To: Liu, Yi L <yi.l.liu@intel.com>
> 
> On Tue, Apr 07, 2020 at 10:33:25AM +0000, Liu, Yi L wrote:
> > Hi Jean,
> >
> > > From: Jean-Philippe Brucker < jean-philippe@linaro.org >
> > > Sent: Friday, April 3, 2020 4:35 PM
> > > Subject: Re: [PATCH v1 6/8] vfio/type1: Bind guest page tables to host
> > >
> > > On Thu, Apr 02, 2020 at 08:05:29AM +0000, Liu, Yi L wrote:
> > > > > > > > static long vfio_iommu_type1_ioctl(void *iommu_data,
> > > > > > > >  		default:
> > > > > > > >  			return -EINVAL;
> > > > > > > >  		}
> > > > > > > > +
> > > > > > > > +	} else if (cmd == VFIO_IOMMU_BIND) {
> > > > > > >
> > > > > > > BIND what? VFIO_IOMMU_BIND_PASID sounds clearer to me.
> > > > > >
> > > > > > Emm, it's up to the flags to indicate bind what. It was proposed to
> > > > > > cover the three cases below:
> > > > > > a) BIND/UNBIND_GPASID
> > > > > > b) BIND/UNBIND_GPASID_TABLE
> > > > > > c) BIND/UNBIND_PROCESS
> > > > > > <only a) is covered in this patch>
> > > > > > So it's called VFIO_IOMMU_BIND.
> > > > >
> > > > > but aren't they all about PASID related binding?
> > > >
> > > > yeah, I can rename it. :-)
> > >
> > > I don't know if anyone intends to implement it, but SMMUv2 supports
> > > nesting translation without any PASID support. For that case the name
> > > VFIO_IOMMU_BIND_GUEST_PGTBL without "PASID" anywhere makes more
> sense.
> > > Ideally we'd also use a neutral name for the IOMMU API instead of
> > > bind_gpasid(), but that's easier to change later.
> >
> > I agree VFIO_IOMMU_BIND is somehow not straight-forward. Especially, it may
> > cause confusion when thinking about VFIO_SET_IOMMU. How about using
> > VFIO_NESTING_IOMMU_BIND_STAGE1 to cover a) and b)? And has another
> > VFIO_BIND_PROCESS in future for the SVA bind case.
> 
> I think minimizing the number of ioctls is more important than finding the
> ideal name. VFIO_IOMMU_BIND was fine to me, but if it's too vague then
> rename it to VFIO_IOMMU_BIND_PASID and we'll just piggy-back on it for
> non-PASID things (they should be rare enough).
maybe we can start with VFIO_IOMMU_BIND_PASID. Actually, there is
also a discussion on reusing the same ioctl and vfio structure for
pasid_alloc/free, bind/unbind_gpasid. and cache_inv. how about your
opinion?

https://lkml.org/lkml/2020/4/3/833

Regards,
Yi Liu



