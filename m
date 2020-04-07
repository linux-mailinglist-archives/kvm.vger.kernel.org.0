Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E9641A0BFF
	for <lists+kvm@lfdr.de>; Tue,  7 Apr 2020 12:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728274AbgDGKda convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 7 Apr 2020 06:33:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:13947 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726399AbgDGKd3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Apr 2020 06:33:29 -0400
IronPort-SDR: FPFM3prjgIG1IJDrOPG1N/h4i3Na8ugc+3Gdw15sfP7Cd23WgOWP+b3ndHprKZp3Dfm/FB/LH9
 Qh665Az/REQA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2020 03:33:29 -0700
IronPort-SDR: XpZt+O2iUSCoEK9yUeNSh7sumO7vG9vjSw8ex36zPLiZlE9N5cc8i5pG7TOakd9BQpVM6bly1l
 me/a5kPTscGw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,353,1580803200"; 
   d="scan'208";a="361496130"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by fmsmga001.fm.intel.com with ESMTP; 07 Apr 2020 03:33:29 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 7 Apr 2020 03:33:28 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 7 Apr 2020 03:33:28 -0700
Received: from shsmsx108.ccr.corp.intel.com (10.239.4.97) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 7 Apr 2020 03:33:28 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.225]) by
 SHSMSX108.ccr.corp.intel.com ([169.254.8.7]) with mapi id 14.03.0439.000;
 Tue, 7 Apr 2020 18:33:25 +0800
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
Thread-Index: AQHWAEUdkW8K+/kg/06c7098DvJyv6hgm8wAgANYlCCAAK00AIAA6IawgAEUvACABu4SMA==
Date:   Tue, 7 Apr 2020 10:33:25 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A224C8F@SHSMSX104.ccr.corp.intel.com>
References: <1584880325-10561-1-git-send-email-yi.l.liu@intel.com>
 <1584880325-10561-7-git-send-email-yi.l.liu@intel.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D7FF98F@SHSMSX104.ccr.corp.intel.com>
 <A2975661238FB949B60364EF0F2C25743A21D8C6@SHSMSX104.ccr.corp.intel.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D805F75@SHSMSX104.ccr.corp.intel.com>
 <A2975661238FB949B60364EF0F2C25743A21ED01@SHSMSX104.ccr.corp.intel.com>
 <20200403083407.GB1269501@myrica>
In-Reply-To: <20200403083407.GB1269501@myrica>
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

Hi Jean,

> From: Jean-Philippe Brucker < jean-philippe@linaro.org >
> Sent: Friday, April 3, 2020 4:35 PM
> Subject: Re: [PATCH v1 6/8] vfio/type1: Bind guest page tables to host
> 
> On Thu, Apr 02, 2020 at 08:05:29AM +0000, Liu, Yi L wrote:
> > > > > > static long vfio_iommu_type1_ioctl(void *iommu_data,
> > > > > >  		default:
> > > > > >  			return -EINVAL;
> > > > > >  		}
> > > > > > +
> > > > > > +	} else if (cmd == VFIO_IOMMU_BIND) {
> > > > >
> > > > > BIND what? VFIO_IOMMU_BIND_PASID sounds clearer to me.
> > > >
> > > > Emm, it's up to the flags to indicate bind what. It was proposed to
> > > > cover the three cases below:
> > > > a) BIND/UNBIND_GPASID
> > > > b) BIND/UNBIND_GPASID_TABLE
> > > > c) BIND/UNBIND_PROCESS
> > > > <only a) is covered in this patch>
> > > > So it's called VFIO_IOMMU_BIND.
> > >
> > > but aren't they all about PASID related binding?
> >
> > yeah, I can rename it. :-)
> 
> I don't know if anyone intends to implement it, but SMMUv2 supports
> nesting translation without any PASID support. For that case the name
> VFIO_IOMMU_BIND_GUEST_PGTBL without "PASID" anywhere makes more sense.
> Ideally we'd also use a neutral name for the IOMMU API instead of
> bind_gpasid(), but that's easier to change later.

I agree VFIO_IOMMU_BIND is somehow not straight-forward. Especially, it may
cause confusion when thinking about VFIO_SET_IOMMU. How about using
VFIO_NESTING_IOMMU_BIND_STAGE1 to cover a) and b)? And has another
VFIO_BIND_PROCESS in future for the SVA bind case.

Regards,
Yi Liu

