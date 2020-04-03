Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5AD19D1EB
	for <lists+kvm@lfdr.de>; Fri,  3 Apr 2020 10:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390403AbgDCIPK convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 3 Apr 2020 04:15:10 -0400
Received: from mga05.intel.com ([192.55.52.43]:8816 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727431AbgDCIPJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Apr 2020 04:15:09 -0400
IronPort-SDR: BbZyCd09IciS7GbOn69Ia49eZWuZDzckUXR7V7eivnev4F1LKIjODVd5mRFHISYmjbP4Sa9zQN
 EFjZZNCObhJg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2020 01:15:08 -0700
IronPort-SDR: HsdVkeowDfWXQccLSa0G2B6f3OYgoxOUVpkduskzeCFDpjU4wTPOSyCchqgYvKXgmRyVcozmpA
 +KcLc1WWlBOQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,339,1580803200"; 
   d="scan'208";a="268288335"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by orsmga002.jf.intel.com with ESMTP; 03 Apr 2020 01:15:08 -0700
Received: from FMSMSX109.amr.corp.intel.com (10.18.116.9) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 3 Apr 2020 01:15:07 -0700
Received: from shsmsx153.ccr.corp.intel.com (10.239.6.53) by
 fmsmsx109.amr.corp.intel.com (10.18.116.9) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 3 Apr 2020 01:15:07 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.225]) by
 SHSMSX153.ccr.corp.intel.com ([169.254.12.89]) with mapi id 14.03.0439.000;
 Fri, 3 Apr 2020 16:15:03 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
CC:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wu, Hao" <hao.wu@intel.com>
Subject: RE: [PATCH v1 2/8] vfio/type1: Add vfio_iommu_type1 parameter for
 quota tuning
Thread-Topic: [PATCH v1 2/8] vfio/type1: Add vfio_iommu_type1 parameter for
 quota tuning
Thread-Index: AQHWAEUbHl/tnnhWl0eaKvrwJMb1AqhgVzOAgACGb+D//4RdgIAAh3wg//+g6QCABR+ZgIABdR7Q
Date:   Fri, 3 Apr 2020 08:15:02 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A22062E@SHSMSX104.ccr.corp.intel.com>
References: <1584880325-10561-1-git-send-email-yi.l.liu@intel.com>
        <1584880325-10561-3-git-send-email-yi.l.liu@intel.com>
        <AADFC41AFE54684AB9EE6CBC0274A5D19D7FF3C5@SHSMSX104.ccr.corp.intel.com>
        <A2975661238FB949B60364EF0F2C25743A217C68@SHSMSX104.ccr.corp.intel.com>
        <AADFC41AFE54684AB9EE6CBC0274A5D19D7FF46F@SHSMSX104.ccr.corp.intel.com>
        <A2975661238FB949B60364EF0F2C25743A217D97@SHSMSX104.ccr.corp.intel.com>
        <AADFC41AFE54684AB9EE6CBC0274A5D19D7FF888@SHSMSX104.ccr.corp.intel.com>
 <20200402115831.22e31611@w520.home>
In-Reply-To: <20200402115831.22e31611@w520.home>
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

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Friday, April 3, 2020 1:59 AM
> To: Tian, Kevin <kevin.tian@intel.com>
> Subject: Re: [PATCH v1 2/8] vfio/type1: Add vfio_iommu_type1 parameter for quota
> tuning
> 
> On Mon, 30 Mar 2020 11:44:08 +0000
> "Tian, Kevin" <kevin.tian@intel.com> wrote:
> 
> > > From: Liu, Yi L <yi.l.liu@intel.com>
> > > Sent: Monday, March 30, 2020 5:27 PM
> > >
> > > > From: Tian, Kevin <kevin.tian@intel.com>
> > > > Sent: Monday, March 30, 2020 5:20 PM
> > > > To: Liu, Yi L <yi.l.liu@intel.com>; alex.williamson@redhat.com;
> > > > Subject: RE: [PATCH v1 2/8] vfio/type1: Add vfio_iommu_type1 parameter
> > > for quota
> > > > tuning
> > > >
> > > > > From: Liu, Yi L <yi.l.liu@intel.com>
> > > > > Sent: Monday, March 30, 2020 4:53 PM
> > > > >
> > > > > > From: Tian, Kevin <kevin.tian@intel.com>
> > > > > > Sent: Monday, March 30, 2020 4:41 PM
> > > > > > To: Liu, Yi L <yi.l.liu@intel.com>; alex.williamson@redhat.com;
> > > > > > Subject: RE: [PATCH v1 2/8] vfio/type1: Add vfio_iommu_type1
> > > > > > parameter
> > > > > for quota
> > > > > > tuning
> > > > > >
> > > > > > > From: Liu, Yi L <yi.l.liu@intel.com>
> > > > > > > Sent: Sunday, March 22, 2020 8:32 PM
> > > > > > >
> > > > > > > From: Liu Yi L <yi.l.liu@intel.com>
> > > > > > >
> > > > > > > This patch adds a module option to make the PASID quota tunable by
> > > > > > > administrator.
> > > > > > >
> > > > > > > TODO: needs to think more on how to  make the tuning to be per-
> > > process.
> > > > > > >
> > > > > > > Previous discussions:
> > > > > > > https://patchwork.kernel.org/patch/11209429/
> > > > > > >
> > > > > > > Cc: Kevin Tian <kevin.tian@intel.com>
> > > > > > > CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > > > > > > Cc: Alex Williamson <alex.williamson@redhat.com>
> > > > > > > Cc: Eric Auger <eric.auger@redhat.com>
> > > > > > > Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
> > > > > > > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > > > > > > ---
> > > > > > >  drivers/vfio/vfio.c             | 8 +++++++-
> > > > > > >  drivers/vfio/vfio_iommu_type1.c | 7 ++++++-
> > > > > > >  include/linux/vfio.h            | 3 ++-
> > > > > > >  3 files changed, 15 insertions(+), 3 deletions(-)
> > > > > > >
> > > > > > > diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c index
> > > > > > > d13b483..020a792 100644
> > > > > > > --- a/drivers/vfio/vfio.c
> > > > > > > +++ b/drivers/vfio/vfio.c
> > > > > > > @@ -2217,13 +2217,19 @@ struct vfio_mm
> > > > > *vfio_mm_get_from_task(struct
> > > > > > > task_struct *task)
> > > > > > >  }
> > > > > > >  EXPORT_SYMBOL_GPL(vfio_mm_get_from_task);
> > > > > > >
> > > > > > > -int vfio_mm_pasid_alloc(struct vfio_mm *vmm, int min, int max)
> > > > > > > +int vfio_mm_pasid_alloc(struct vfio_mm *vmm, int quota, int min,
> > > > > > > +int
> > > > > max)
> > > > > > >  {
> > > > > > >  	ioasid_t pasid;
> > > > > > >  	int ret = -ENOSPC;
> > > > > > >
> > > > > > >  	mutex_lock(&vmm->pasid_lock);
> > > > > > >
> > > > > > > +	/* update quota as it is tunable by admin */
> > > > > > > +	if (vmm->pasid_quota != quota) {
> > > > > > > +		vmm->pasid_quota = quota;
> > > > > > > +		ioasid_adjust_set(vmm->ioasid_sid, quota);
> > > > > > > +	}
> > > > > > > +
> > > > > >
> > > > > > It's a bit weird to have quota adjusted in the alloc path, since the
> > > > > > latter
> > > > > might
> > > > > > be initiated by non-privileged users. Why not doing the simple math
> > > > > > in
> > > > > vfio_
> > > > > > create_mm to set the quota when the ioasid set is created? even in
> > > > > > the
> > > > > future
> > > > > > you may allow per-process quota setting, that should come from
> > > > > > separate privileged path instead of thru alloc..
> > > > >
> > > > > The reason is the kernel parameter modification has no event which can
> > > > > be used to adjust the quota. So I chose to adjust it in pasid_alloc
> > > > > path. If it's not good, how about adding one more IOCTL to let user-
> > > > > space trigger a quota adjustment event? Then even non-privileged user
> > > > > could trigger quota adjustment, the quota is actually controlled by
> > > > > privileged user. How about your opinion?
> > > > >
> > > >
> > > > why do you need an event to adjust? As I said, you can set the quota when
> > > the set is
> > > > created in vfio_create_mm...
> > >
> > > oh, it's to support runtime adjustments. I guess it may be helpful to let
> > > per-VM quota tunable even the VM is running. If just set the quota in
> > > vfio_create_mm(), it is not able to adjust at runtime.
> > >
> >
> > ok, I didn't note the module parameter was granted with a write permission.
> > However there is a further problem. We cannot support PASID reclaim now.
> > What about the admin sets a quota smaller than previous value while some
> > IOASID sets already exceed the new quota? I'm not sure how to fail a runtime
> > module parameter change due to that situation. possibly a normal sysfs
> > node better suites the runtime change requirement...
> 
> Yep, making this runtime adjustable seems a bit unpredictable and racy,
> and it's not clear to me how a user is going to jump in at just the
> right time for a user and adjust the limit.  I'd probably go for a
> simple non-runtime adjustable module option.  It's a safety net at this
> point anyway afaict.  Thanks,

thanks, I can do the changes.

Regards,
Yi Liu
