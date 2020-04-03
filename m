Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82A8319D6EB
	for <lists+kvm@lfdr.de>; Fri,  3 Apr 2020 14:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390797AbgDCMo4 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 3 Apr 2020 08:44:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:34643 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727965AbgDCMo4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Apr 2020 08:44:56 -0400
IronPort-SDR: RLPhhYI1UXHqWbFud3UOcrlUK/ErWkiqrAU2MJWpezrRXqLlxO2X1SvUlVJrXSwOtEVvgPqr1s
 ImQS9V1DdSzA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2020 05:44:56 -0700
IronPort-SDR: FIByPhSWdOnN913/D0S6XqXWgpwqP9R8Y5o3SECqUjmkpTTNF6mFEYXqyZxYOkHQre5oHzJlEz
 TAdvK2BZqRGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,339,1580803200"; 
   d="scan'208";a="241115423"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by fmsmga007.fm.intel.com with ESMTP; 03 Apr 2020 05:44:56 -0700
Received: from fmsmsx157.amr.corp.intel.com (10.18.116.73) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 3 Apr 2020 05:44:55 -0700
Received: from shsmsx101.ccr.corp.intel.com (10.239.4.153) by
 FMSMSX157.amr.corp.intel.com (10.18.116.73) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 3 Apr 2020 05:44:55 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.225]) by
 SHSMSX101.ccr.corp.intel.com ([169.254.1.129]) with mapi id 14.03.0439.000;
 Fri, 3 Apr 2020 20:44:51 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
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
Subject: RE: [PATCH v1 1/8] vfio: Add VFIO_IOMMU_PASID_REQUEST(alloc/free)
Thread-Topic: [PATCH v1 1/8] vfio: Add VFIO_IOMMU_PASID_REQUEST(alloc/free)
Thread-Index: AQHWAEUbC4GB74LMekup8jIcF6WIFqhlZUwAgAH1tzD//4hGgIAAhuqA
Date:   Fri, 3 Apr 2020 12:44:51 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A220AE4@SHSMSX104.ccr.corp.intel.com>
References: <1584880325-10561-1-git-send-email-yi.l.liu@intel.com>
 <1584880325-10561-2-git-send-email-yi.l.liu@intel.com>
 <20200402135240.GE1176452@myrica>
 <A2975661238FB949B60364EF0F2C25743A2209E3@SHSMSX104.ccr.corp.intel.com>
 <20200403123951.GA1410438@myrica>
In-Reply-To: <20200403123951.GA1410438@myrica>
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
> Sent: Friday, April 3, 2020 8:40 PM
> Subject: Re: [PATCH v1 1/8] vfio: Add VFIO_IOMMU_PASID_REQUEST(alloc/free)
> 
> On Fri, Apr 03, 2020 at 11:56:09AM +0000, Liu, Yi L wrote:
> > > >  /**
> > > > + * VFIO_MM objects - create, release, get, put, search
> > > > + * Caller of the function should have held vfio.vfio_mm_lock.
> > > > + */
> > > > +static struct vfio_mm *vfio_create_mm(struct mm_struct *mm) {
> > > > +	struct vfio_mm *vmm;
> > > > +	struct vfio_mm_token *token;
> > > > +	int ret = 0;
> > > > +
> > > > +	vmm = kzalloc(sizeof(*vmm), GFP_KERNEL);
> > > > +	if (!vmm)
> > > > +		return ERR_PTR(-ENOMEM);
> > > > +
> > > > +	/* Per mm IOASID set used for quota control and group operations */
> > > > +	ret = ioasid_alloc_set((struct ioasid_set *) mm,
> > >
> > > Hmm, either we need to change the token of ioasid_alloc_set() to
> > > "void *", or pass an actual ioasid_set struct, but this cast doesn't
> > > look good :)
> > >
> > > As I commented on the IOASID series, I think we could embed a struct
> > > ioasid_set into vfio_mm, pass that struct to all other ioasid_*
> > > functions, and get rid of ioasid_sid.
> >
> > I think change to "void *" is better as we needs the token to ensure
> > all threads within a single VM share the same ioasid_set.
> 
> Don't they share the same vfio_mm?

that's right. then both works well for me.

Regards,
Yi Liu
