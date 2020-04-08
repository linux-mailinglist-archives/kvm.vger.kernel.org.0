Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35FD41A1958
	for <lists+kvm@lfdr.de>; Wed,  8 Apr 2020 02:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726527AbgDHAwv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 7 Apr 2020 20:52:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:36341 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726428AbgDHAwu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Apr 2020 20:52:50 -0400
IronPort-SDR: 6KuYhBtALBpDaWo1mLmaluImeW0Z7Y8pXwRuRpsk64O0gdvN32rhaixGFLWqwozyDwZ1lTvX7A
 /eCJpXd+3OAQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2020 17:52:50 -0700
IronPort-SDR: G67qDOZKuI/83JH0ScQGkQc6hUuOr7cuVFOpZqC7524k9bmWiG6T5E7YXwnpgnIxrhfspIM2Fz
 rBHzVQ8kzxrg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,357,1580803200"; 
   d="scan'208";a="297096372"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by FMSMGA003.fm.intel.com with ESMTP; 07 Apr 2020 17:52:50 -0700
Received: from fmsmsx154.amr.corp.intel.com (10.18.116.70) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 7 Apr 2020 17:52:49 -0700
Received: from shsmsx106.ccr.corp.intel.com (10.239.4.159) by
 FMSMSX154.amr.corp.intel.com (10.18.116.70) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 7 Apr 2020 17:52:49 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.225]) by
 SHSMSX106.ccr.corp.intel.com ([169.254.10.89]) with mapi id 14.03.0439.000;
 Wed, 8 Apr 2020 08:52:46 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
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
Subject: RE: [PATCH v1 1/8] vfio: Add VFIO_IOMMU_PASID_REQUEST(alloc/free)
Thread-Topic: [PATCH v1 1/8] vfio: Add VFIO_IOMMU_PASID_REQUEST(alloc/free)
Thread-Index: AQHWAEUbC4GB74LMekup8jIcF6WIFqhlp7CAgAGFhmCAAAzHgIAFwXRA
Date:   Wed, 8 Apr 2020 00:52:46 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A225A3C@SHSMSX104.ccr.corp.intel.com>
References: <1584880325-10561-1-git-send-email-yi.l.liu@intel.com>
        <1584880325-10561-2-git-send-email-yi.l.liu@intel.com>
        <20200402115017.0a0f55e2@w520.home>
        <A2975661238FB949B60364EF0F2C25743A220B62@SHSMSX104.ccr.corp.intel.com>
 <20200403115011.4aba8ff3@w520.home>
In-Reply-To: <20200403115011.4aba8ff3@w520.home>
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

Hi Alex,
> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Saturday, April 4, 2020 1:50 AM
> Subject: Re: [PATCH v1 1/8] vfio: Add VFIO_IOMMU_PASID_REQUEST(alloc/free)
> 
> On Fri, 3 Apr 2020 13:12:50 +0000
> "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> 
> > Hi Alex,
> >
> > > From: Alex Williamson <alex.williamson@redhat.com>
> > > Sent: Friday, April 3, 2020 1:50 AM
> > > Subject: Re: [PATCH v1 1/8] vfio: Add VFIO_IOMMU_PASID_REQUEST(alloc/free)
> > >
> > > On Sun, 22 Mar 2020 05:31:58 -0700
> > > "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> > >
> > > > From: Liu Yi L <yi.l.liu@intel.com>
> > > >
[...]
> > > >  static long vfio_iommu_type1_ioctl(void *iommu_data,
> > > >  				   unsigned int cmd, unsigned long arg)
> > > >  {
> > > > @@ -2276,6 +2333,53 @@ static long vfio_iommu_type1_ioctl(void
> > > *iommu_data,
> > > >
> > > >  		return copy_to_user((void __user *)arg, &unmap, minsz) ?
> > > >  			-EFAULT : 0;
> > > > +
> > > > +	} else if (cmd == VFIO_IOMMU_PASID_REQUEST) {
> > > > +		struct vfio_iommu_type1_pasid_request req;
> > > > +		unsigned long offset;
> > > > +
> > > > +		minsz = offsetofend(struct vfio_iommu_type1_pasid_request,
> > > > +				    flags);
> > > > +
> > > > +		if (copy_from_user(&req, (void __user *)arg, minsz))
> > > > +			return -EFAULT;
> > > > +
> > > > +		if (req.argsz < minsz ||
> > > > +		    !vfio_iommu_type1_pasid_req_valid(req.flags))
> > > > +			return -EINVAL;
> > > > +
> > > > +		if (copy_from_user((void *)&req + minsz,
> > > > +				   (void __user *)arg + minsz,
> > > > +				   sizeof(req) - minsz))
> > > > +			return -EFAULT;
> > >
> > > Huh?  Why do we have argsz if we're going to assume this is here?
> >
> > do you mean replacing sizeof(req) with argsz? if yes, I can do that.
> 
> No, I mean the user tells us how much data they've provided via argsz.
> We create minsz the the end of flags and verify argsz includes flags.
> Then we proceed to ignore argsz to see if the user has provided the
> remainder of the structure.

I think I should avoid using sizeof(req) as it may be variable
new flag is added. I think better to make a data[] field in struct
vfio_iommu_type1_pasid_request and copy data[] per flag. I'll
make this change in new version.

> > > > +
> > > > +		switch (req.flags & VFIO_PASID_REQUEST_MASK) {
> > > > +		case VFIO_IOMMU_PASID_ALLOC:
> > > > +		{
> > > > +			int ret = 0, result;
> > > > +
> > > > +			result = vfio_iommu_type1_pasid_alloc(iommu,
> > > > +							req.alloc_pasid.min,
> > > > +							req.alloc_pasid.max);
> > > > +			if (result > 0) {
> > > > +				offset = offsetof(
> > > > +					struct vfio_iommu_type1_pasid_request,
> > > > +					alloc_pasid.result);
> > > > +				ret = copy_to_user(
> > > > +					      (void __user *) (arg + offset),
> > > > +					      &result, sizeof(result));
> > >
> > > Again assuming argsz supports this.
> >
> > same as above.
> >
> > >
> > > > +			} else {
> > > > +				pr_debug("%s: PASID alloc failed\n", __func__);
> > >
> > > rate limit?
> >
> > not quite get. could you give more hints?
> 
> A user can spam the host logs simply by allocating their quota of
> PASIDs and then trying to allocate more, or by specifying min/max such
> that they cannot allocate the requested PASID.  If this logging is
> necessary for debugging, it should be ratelimited to avoid a DoS on the
> host.

got it. thanks for the coaching. will use pr_debug_ratelimited().

Regards,
Yi Liu
