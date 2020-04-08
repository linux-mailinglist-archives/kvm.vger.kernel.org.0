Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE8E1A19F5
	for <lists+kvm@lfdr.de>; Wed,  8 Apr 2020 04:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726438AbgDHC2i convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 7 Apr 2020 22:28:38 -0400
Received: from mga06.intel.com ([134.134.136.31]:8916 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726416AbgDHC2i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Apr 2020 22:28:38 -0400
IronPort-SDR: 7fQrNsa/yMIku211rrOq35vgTlBEMXetaNCX6whJ0y8sHK7e/3NJlcQ7nD2wIObeMOJhClG/kx
 u6kgvEsDQPVw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2020 19:28:37 -0700
IronPort-SDR: 7bdsC+YycV3wrifP6a1WNE+0FMX+KTHUuOcw78XugcU/wpGfL7e20M/BsmzpfcpwCwkK3eaukR
 AJZGHQf3svMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,357,1580803200"; 
   d="scan'208";a="330400813"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by orsmga001.jf.intel.com with ESMTP; 07 Apr 2020 19:28:36 -0700
Received: from fmsmsx163.amr.corp.intel.com (10.18.125.72) by
 FMSMSX108.amr.corp.intel.com (10.18.124.206) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 7 Apr 2020 19:28:36 -0700
Received: from shsmsx107.ccr.corp.intel.com (10.239.4.96) by
 fmsmsx163.amr.corp.intel.com (10.18.125.72) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 7 Apr 2020 19:28:36 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.225]) by
 SHSMSX107.ccr.corp.intel.com ([169.254.9.191]) with mapi id 14.03.0439.000;
 Wed, 8 Apr 2020 10:28:32 +0800
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
Subject: RE: [PATCH v1 7/8] vfio/type1: Add VFIO_IOMMU_CACHE_INVALIDATE
Thread-Topic: [PATCH v1 7/8] vfio/type1: Add VFIO_IOMMU_CACHE_INVALIDATE
Thread-Index: AQHWAEUdcc1u01skwUmp6uBHREsZ66hl0sQAgACrzQCAAJWLAIAHa6Ag
Date:   Wed, 8 Apr 2020 02:28:32 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A225C45@SHSMSX104.ccr.corp.intel.com>
References: <1584880325-10561-1-git-send-email-yi.l.liu@intel.com>
        <1584880325-10561-8-git-send-email-yi.l.liu@intel.com>
        <20200402142428.2901432e@w520.home>
        <AADFC41AFE54684AB9EE6CBC0274A5D19D807C4A@SHSMSX104.ccr.corp.intel.com>
 <20200403093436.094b1928@w520.home>
In-Reply-To: <20200403093436.094b1928@w520.home>
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
> Sent: Friday, April 3, 2020 11:35 PM
> Subject: Re: [PATCH v1 7/8] vfio/type1: Add VFIO_IOMMU_CACHE_INVALIDATE
> 
> On Fri, 3 Apr 2020 06:39:22 +0000
> "Tian, Kevin" <kevin.tian@intel.com> wrote:
> 
> > > From: Alex Williamson <alex.williamson@redhat.com>
> > > Sent: Friday, April 3, 2020 4:24 AM
> > >
> > > On Sun, 22 Mar 2020 05:32:04 -0700
> > > "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> > >
> > > > From: Liu Yi L <yi.l.liu@linux.intel.com>
> > > >
[...]
> 
> > >
> > > > +
> > > > +		if (copy_from_user(&cache_inv, (void __user *)arg, minsz))
> > > > +			return -EFAULT;
> > > > +
> > > > +		if (cache_inv.argsz < minsz || cache_inv.flags)
> > > > +			return -EINVAL;
> > > > +
> > > > +		/* Get the version of struct iommu_cache_invalidate_info */
> > > > +		if (copy_from_user(&version,
> > > > +			(void __user *) (arg + minsz), sizeof(version)))
> > > > +			return -EFAULT;
> > > > +
> > > > +		info_size = iommu_uapi_get_data_size(
> > > > +					IOMMU_UAPI_CACHE_INVAL,
> > > version);
> > > > +
> > > > +		cache_info = kzalloc(info_size, GFP_KERNEL);
> > > > +		if (!cache_info)
> > > > +			return -ENOMEM;
> > > > +
> > > > +		if (copy_from_user(cache_info,
> > > > +			(void __user *) (arg + minsz), info_size)) {
> > > > +			kfree(cache_info);
> > > > +			return -EFAULT;
> > > > +		}
> > > > +
> > > > +		mutex_lock(&iommu->lock);
> > > > +		ret = vfio_iommu_for_each_dev(iommu, vfio_cache_inv_fn,
> > > > +					    cache_info);
> > >
> > > How does a user respond when their cache invalidate fails?  Isn't this
> > > also another case where our for_each_dev can fail at an arbitrary point
> > > leaving us with no idea whether each device even had the opportunity to
> > > perform the invalidation request.  I don't see how we have any chance
> > > to maintain coherency after this faults.
> >
> > Then can we make it simple to support singleton group only?
> 
> Are you suggesting a single group per container or a single device per
> group? Unless we have both, aren't we always going to have this issue.

Agreed. we need both to avoid the potential for_each_dev() loop issue.
I suppose this is also the most typical and desired config for vSVA
support. I think it makes sense with below items:

a) one group per container
PASID and nested translation gives user-space a chance to attach their
page table (e.g. guest process page table) to host IOMMU, this is vSVA.
If adding multiple groups to a vSVA-capable container, then a SVA bind
on this container means bind it with all groups (devices are included)
within the container. This doesn't make sense with three reasons: for
one the passthru devices are not necessary to be manipulated by same
guest application; for two passthru devices are not surely added in a
single guest group; for three not all passthru devices (either from
different group or same group) are sva capable.
As above, enforce one group per container makes sense to me.

b) one device per group
SVA support is limited to singleton group so far in bare-metal bind
per Jean's series. I think it's be good to follow it in passthru case.
https://patchwork.kernel.org/patch/10213877/
https://lkml.org/lkml/2019/4/10/663
As mentioned in a), group may have both SVA-capable device and non-SVA
-capable device, it would be a problem for VFIO to figure a way to isolate
them.

> OTOH, why should a cache invalidate fail?

there are sanity check done by vendor iommu driver against the invalidate
request from userspace. so it may fail if sanity check failed. But I guess
it may be better to something like abort instead of fail the request. isn't?

> 
> > > > +		mutex_unlock(&iommu->lock);
> > > > +		kfree(cache_info);
> > > > +		return ret;
> > > >  	}
> > > >
> > > >  	return -ENOTTY;
> > > > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > > > index 2235bc6..62ca791 100644
> > > > --- a/include/uapi/linux/vfio.h
> > > > +++ b/include/uapi/linux/vfio.h
> > > > @@ -899,6 +899,28 @@ struct vfio_iommu_type1_bind {
> > > >   */
> > > >  #define VFIO_IOMMU_BIND		_IO(VFIO_TYPE, VFIO_BASE + 23)
> > > >
> > > > +/**
> > > > + * VFIO_IOMMU_CACHE_INVALIDATE - _IOW(VFIO_TYPE, VFIO_BASE + 24,
> > > > + *			struct vfio_iommu_type1_cache_invalidate)
> > > > + *
> > > > + * Propagate guest IOMMU cache invalidation to the host. The cache
> > > > + * invalidation information is conveyed by @cache_info, the content
> > > > + * format would be structures defined in uapi/linux/iommu.h. User
> > > > + * should be aware of that the struct  iommu_cache_invalidate_info
> > > > + * has a @version field, vfio needs to parse this field before getting
> > > > + * data from userspace.
> > > > + *
> > > > + * Availability of this IOCTL is after VFIO_SET_IOMMU.
> > >
> > > Is this a necessary qualifier?  A user can try to call this ioctl at
> > > any point, it only makes sense in certain configurations, but it should
> > > always "do the right thing" relative to the container iommu config.
> > >
> > > Also, I don't see anything in these last few patches testing the
> > > operating IOMMU model, what happens when a user calls them when not
> > > using the nesting IOMMU?
> > >
> > > Is this ioctl and the previous BIND ioctl only valid when configured
> > > for the nesting IOMMU type?
> >
> > I think so. We should add the nesting check in those new ioctls.
> >
> > >
> > > > + *
> > > > + * returns: 0 on success, -errno on failure.
> > > > + */
> > > > +struct vfio_iommu_type1_cache_invalidate {
> > > > +	__u32   argsz;
> > > > +	__u32   flags;
> > > > +	struct	iommu_cache_invalidate_info cache_info;
> > > > +};
> > > > +#define VFIO_IOMMU_CACHE_INVALIDATE      _IO(VFIO_TYPE, VFIO_BASE
> > > + 24)
> > >
> > > The future extension capabilities of this ioctl worry me, I wonder if
> > > we should do another data[] with flag defining that data as CACHE_INFO.
> >
> > Can you elaborate? Does it mean with this way we don't rely on iommu
> > driver to provide version_to_size conversion and instead we just pass
> > data[] to iommu driver for further audit?
> 
> No, my concern is that this ioctl has a single function, strictly tied
> to the iommu uapi.  If we replace cache_info with data[] then we can
> define a flag to specify that data[] is struct
> iommu_cache_invalidate_info, and if we need to, a different flag to
> identify data[] as something else.  For example if we get stuck
> expanding cache_info to meet new demands and develop a new uapi to
> solve that, how would we expand this ioctl to support it rather than
> also create a new ioctl?  There's also a trade-off in making the ioctl
> usage more difficult for the user.  I'd still expect the vfio layer to
> check the flag and interpret data[] as indicated by the flag rather
> than just passing a blob of opaque data to the iommu layer though.

Ok, I think data[] is acceptable. BTW. Do you have any decision on the
uapi version open iin Jacob's thread? I'd like to re-work my patch based
on your decision.

https://lkml.org/lkml/2020/4/2/876

thanks again for your help. :-)

Regards,
Yi Liu
