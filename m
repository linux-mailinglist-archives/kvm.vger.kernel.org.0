Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA054F4B6F
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2019 13:23:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732371AbfKHMXq convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 8 Nov 2019 07:23:46 -0500
Received: from mga09.intel.com ([134.134.136.24]:61815 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732342AbfKHMXq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Nov 2019 07:23:46 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Nov 2019 04:23:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,281,1569308400"; 
   d="scan'208";a="403057430"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by fmsmga005.fm.intel.com with ESMTP; 08 Nov 2019 04:23:44 -0800
Received: from fmsmsx155.amr.corp.intel.com (10.18.116.71) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 8 Nov 2019 04:23:44 -0800
Received: from shsmsx102.ccr.corp.intel.com (10.239.4.154) by
 FMSMSX155.amr.corp.intel.com (10.18.116.71) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 8 Nov 2019 04:23:44 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.127]) by
 shsmsx102.ccr.corp.intel.com ([169.254.2.108]) with mapi id 14.03.0439.000;
 Fri, 8 Nov 2019 20:23:42 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe.brucker@arm.com" <jean-philippe.brucker@arm.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [RFC v2 2/3] vfio/type1: VFIO_IOMMU_PASID_REQUEST(alloc/free)
Thread-Topic: [RFC v2 2/3] vfio/type1: VFIO_IOMMU_PASID_REQUEST(alloc/free)
Thread-Index: AQHVimn7Rf6XEKLwVUSEQeOMJH4V9ad8yIOAgAFk6nCAAab8gIABawdg
Date:   Fri, 8 Nov 2019 12:23:41 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A0F305A@SHSMSX104.ccr.corp.intel.com>
References: <1571919983-3231-1-git-send-email-yi.l.liu@intel.com>
        <1571919983-3231-3-git-send-email-yi.l.liu@intel.com>
        <20191105163537.1935291c@x1.home>
        <A2975661238FB949B60364EF0F2C25743A0EF41B@SHSMSX104.ccr.corp.intel.com>
 <20191107150659.05fa7548@x1.home>
In-Reply-To: <20191107150659.05fa7548@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMDk0ZjMwM2UtYTQyMS00ZGM1LWFhZmUtOTAxOTkwNTdjYTBiIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiVXR5RTh5Mk1IODduUE92WHFOK2JMWnRkbmgwR3J2RWFlTjM1Sk1cL2h6SmhhNHFtbVZUaEhkVkhmTitFMWg5NmQifQ==
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson [mailto:alex.williamson@redhat.com]
> Sent: Friday, November 8, 2019 6:07 AM
> To: Liu, Yi L <yi.l.liu@intel.com>
> Subject: Re: [RFC v2 2/3] vfio/type1: VFIO_IOMMU_PASID_REQUEST(alloc/free)
> 
> On Wed, 6 Nov 2019 13:27:26 +0000
> "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> 
> > > From: Alex Williamson <alex.williamson@redhat.com>
> > > Sent: Wednesday, November 6, 2019 7:36 AM
> > > To: Liu, Yi L <yi.l.liu@intel.com>
> > > Subject: Re: [RFC v2 2/3] vfio/type1: VFIO_IOMMU_PASID_REQUEST(alloc/free)
> > >
> > > On Thu, 24 Oct 2019 08:26:22 -0400
> > > Liu Yi L <yi.l.liu@intel.com> wrote:
> > >
> > > > This patch adds VFIO_IOMMU_PASID_REQUEST ioctl which aims
> > > > to passdown PASID allocation/free request from the virtual
> > > > iommu. This is required to get PASID managed in system-wide.
> > > >
> > > > Cc: Kevin Tian <kevin.tian@intel.com>
> > > > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > > > Signed-off-by: Yi Sun <yi.y.sun@linux.intel.com>
> > > > Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > > > ---
> > > >  drivers/vfio/vfio_iommu_type1.c | 114
> > > ++++++++++++++++++++++++++++++++++++++++
> > > >  include/uapi/linux/vfio.h       |  25 +++++++++
> > > >  2 files changed, 139 insertions(+)
> > > >
> > > > diff --git a/drivers/vfio/vfio_iommu_type1.c
> b/drivers/vfio/vfio_iommu_type1.c
> > > > index cd8d3a5..3d73a7d 100644
> > > > --- a/drivers/vfio/vfio_iommu_type1.c
> > > > +++ b/drivers/vfio/vfio_iommu_type1.c
> > > > @@ -2248,6 +2248,83 @@ static int vfio_cache_inv_fn(struct device *dev,
> void
> > > *data)
> > > >  	return iommu_cache_invalidate(dc->domain, dev, &ustruct->info);
> > > >  }
> > > >
> > > > +static int vfio_iommu_type1_pasid_alloc(struct vfio_iommu *iommu,
> > > > +					 int min_pasid,
> > > > +					 int max_pasid)
> > > > +{
> > > > +	int ret;
> > > > +	ioasid_t pasid;
> > > > +	struct mm_struct *mm = NULL;
> > > > +
> > > > +	mutex_lock(&iommu->lock);
> > > > +	if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)) {
> > > > +		ret = -EINVAL;
> > > > +		goto out_unlock;
> > > > +	}
> > > > +	mm = get_task_mm(current);
> > > > +	/* Track ioasid allocation owner by mm */
> > > > +	pasid = ioasid_alloc((struct ioasid_set *)mm, min_pasid,
> > > > +				max_pasid, NULL);
> > >
> > > Are we sure we want to tie this to the task mm vs perhaps the
> > > vfio_iommu pointer?
> >
> > Here we want to have a kind of per-VM mark, which can be used to do
> > ownership check on whether a pasid is held by a specific VM. This is
> > very important to prevent across VM affect. vfio_iommu pointer is
> > competent for vfio as vfio is both pasid alloc requester and pasid
> > consumer. e.g. vfio requests pasid alloc from ioasid and also it will
> > invoke bind_gpasid(). vfio can either check ownership before invoking
> > bind_gpasid() or pass vfio_iommu pointer to iommu driver. But in future,
> > there may be other modules which are just consumers of pasid. And they
> > also want to do ownership check for a pasid. Then, it would be hard for
> > them as they are not the pasid alloc requester. So here better to have
> > a system wide structure to perform as the per-VM mark. task mm looks
> > to be much competent.
> 
> Ok, so it's intentional to have a VM-wide token.  Elsewhere in the
> type1 code (vfio_dma_do_map) we record the task_struct per dma mapping
> so that we can get the task mm as needed.  Would the task_struct
> pointer provide any advantage?

I think we may use task_struct pointer to make type1 code consistent.
How do you think?

> Also, an overall question, this provides userspace with pasid alloc and
> free ioctls, (1) what prevents a userspace process from consuming every
> available pasid, and (2) if the process exits or crashes without
> freeing pasids, how are they recovered aside from a reboot?

For question (1), I think we only need to take care about malicious
userspace process. As vfio usage is under privilege mode, so we may
be safe on it so far. However, we may need to introduce a kind of credit
mechanism to protect it. I've thought it, but no good idea yet. Would be
happy to hear from you.

For question (2), I think we need to reclaim the allocated pasids when
the vfio container fd is released just like what vfio does to the domain
mappings. I didn't add it yet. But I can add it in next version if you think
it would make the pasid alloc/free be much sound.

> > > > +	if (pasid == INVALID_IOASID) {
> > > > +		ret = -ENOSPC;
> > > > +		goto out_unlock;
> > > > +	}
> > > > +	ret = pasid;
> > > > +out_unlock:
> > > > +	mutex_unlock(&iommu->lock);
> 
> What does holding this lock protect?  That the vfio_iommu remains
> backed by an iommu during this operation, even though we don't do
> anything to release allocated pasids when that iommu backing is removed?

yes, it is unnecessary to hold the lock here. At least for the operations in
this patch. will remove it. :-)

> > > > +	if (mm)
> > > > +		mmput(mm);
> > > > +	return ret;
> > > > +}
> > > > +
> > > > +static int vfio_iommu_type1_pasid_free(struct vfio_iommu *iommu,
> > > > +				       unsigned int pasid)
> > > > +{
> > > > +	struct mm_struct *mm = NULL;
> > > > +	void *pdata;
> > > > +	int ret = 0;
> > > > +
> > > > +	mutex_lock(&iommu->lock);
> > > > +	if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)) {
> > > > +		ret = -EINVAL;
> > > > +		goto out_unlock;
> > > > +	}
> > > > +
> > > > +	/**
> > > > +	 * REVISIT:
> > > > +	 * There are two cases free could fail:
> > > > +	 * 1. free pasid by non-owner, we use ioasid_set to track mm, if
> > > > +	 * the set does not match, caller is not permitted to free.
> > > > +	 * 2. free before unbind all devices, we can check if ioasid private
> > > > +	 * data, if data != NULL, then fail to free.
> > > > +	 */
> > > > +	mm = get_task_mm(current);
> > > > +	pdata = ioasid_find((struct ioasid_set *)mm, pasid, NULL);
> > > > +	if (IS_ERR(pdata)) {
> > > > +		if (pdata == ERR_PTR(-ENOENT))
> > > > +			pr_err("PASID %u is not allocated\n", pasid);
> > > > +		else if (pdata == ERR_PTR(-EACCES))
> > > > +			pr_err("Free PASID %u by non-owner, denied", pasid);
> > > > +		else
> > > > +			pr_err("Error searching PASID %u\n", pasid);
> > >
> > > This should be removed, errno is sufficient for the user, this just
> > > provides the user with a trivial DoS vector filling logs.
> >
> > sure, will fix it. thanks.
> >
> > > > +		ret = -EPERM;
> > >
> > > But why not return PTR_ERR(pdata)?
> >
> > aha, would do it.
> >
> > > > +		goto out_unlock;
> > > > +	}
> > > > +	if (pdata) {
> > > > +		pr_debug("Cannot free pasid %d with private data\n", pasid);
> > > > +		/* Expect PASID has no private data if not bond */
> > > > +		ret = -EBUSY;
> > > > +		goto out_unlock;
> > > > +	}
> > > > +	ioasid_free(pasid);
> > >
> > > We only ever get here with pasid == NULL?!
> >
> > I guess you meant only when pdata==NULL.
> >
> > > Something is wrong.  Should
> > > that be 'if (!pdata)'?  (which also makes that pr_debug another DoS
> > > vector)
> >
> > Oh, yes, just do it as below:
> >
> > if (!pdata) {
> > 	ioasid_free(pasid);
> > 	ret = SUCCESS;
> > } else
> > 	ret = -EBUSY;
> >
> > Is it what you mean?
> 
> No, I think I was just confusing pdata and pasid, but I am still
> confused about testing pdata.  We call ioasid_alloc() with private =
> NULL, and I don't see any of your patches calling ioasid_set_data() to
> change the private data after allocation, so how could this ever be
> set?  Should this just be a BUG_ON(pdata) as the integrity of the
> system is in question should this state ever occur?  Thanks,

ioasid_set_data() was called  in one patch from Jacob's vSVA patchset.
[PATCH v6 08/10] iommu/vt-d: Add bind guest PASID support
https://lkml.org/lkml/2019/10/22/946

The basic idea is to allocate pasid with private=NULL, and set it when the
pasid is actually bind to a device (bind_gpasid()). Each bind_gpasid() will
increase the ref_cnt in the private data, and each unbind_gpasid() will
decrease the ref_cnt. So if bind/unbind_gpasid() is called in mirror, the
private data should be null when comes to free operation. If not, vfio can
believe that the pasid is still in use.

> Alex

Thanks,
Yi Liu
 
> > > > +
> > > > +out_unlock:
> > > > +	if (mm)
> > > > +		mmput(mm);
> > > > +	mutex_unlock(&iommu->lock);
> > > > +	return ret;
> > > > +}
> > > > +
> > > >  static long vfio_iommu_type1_ioctl(void *iommu_data,
> > > >  				   unsigned int cmd, unsigned long arg)
> > > >  {
> > > > @@ -2370,6 +2447,43 @@ static long vfio_iommu_type1_ioctl(void
> *iommu_data,
> > > >  					    &ustruct);
> > > >  		mutex_unlock(&iommu->lock);
> > > >  		return ret;
> > > > +
> > > > +	} else if (cmd == VFIO_IOMMU_PASID_REQUEST) {
> > > > +		struct vfio_iommu_type1_pasid_request req;
> > > > +		int min_pasid, max_pasid, pasid;
> > > > +
> > > > +		minsz = offsetofend(struct vfio_iommu_type1_pasid_request,
> > > > +				    flag);
> > > > +
> > > > +		if (copy_from_user(&req, (void __user *)arg, minsz))
> > > > +			return -EFAULT;
> > > > +
> > > > +		if (req.argsz < minsz)
> > > > +			return -EINVAL;
> > > > +
> > > > +		switch (req.flag) {
> > >
> > > This works, but it's strange.  Let's make the code a little easier for
> > > the next flag bit that gets used so they don't need to rework this case
> > > statement.  I'd suggest creating a VFIO_IOMMU_PASID_OPS_MASK that is
> > > the OR of the ALLOC/FREE options, test that no bits are set outside of
> > > that mask, then AND that mask as the switch arg with the code below.
> >
> > Got it. Let me fix it in next version.
> >
> > > > +		/**
> > > > +		 * TODO: min_pasid and max_pasid align with
> > > > +		 * typedef unsigned int ioasid_t
> > > > +		 */
> > > > +		case VFIO_IOMMU_PASID_ALLOC:
> > > > +			if (copy_from_user(&min_pasid,
> > > > +				(void __user *)arg + minsz, sizeof(min_pasid)))
> > > > +				return -EFAULT;
> > > > +			if (copy_from_user(&max_pasid,
> > > > +				(void __user *)arg + minsz + sizeof(min_pasid),
> > > > +				sizeof(max_pasid)))
> > > > +				return -EFAULT;
> > > > +			return vfio_iommu_type1_pasid_alloc(iommu,
> > > > +						min_pasid, max_pasid);
> > > > +		case VFIO_IOMMU_PASID_FREE:
> > > > +			if (copy_from_user(&pasid,
> > > > +				(void __user *)arg + minsz, sizeof(pasid)))
> > > > +				return -EFAULT;
> > > > +			return vfio_iommu_type1_pasid_free(iommu, pasid);
> > > > +		default:
> > > > +			return -EINVAL;
> > > > +		}
> > > >  	}
> > > >
> > > >  	return -ENOTTY;
> > > > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > > > index ccf60a2..04de290 100644
> > > > --- a/include/uapi/linux/vfio.h
> > > > +++ b/include/uapi/linux/vfio.h
> > > > @@ -807,6 +807,31 @@ struct vfio_iommu_type1_cache_invalidate {
> > > >  };
> > > >  #define VFIO_IOMMU_CACHE_INVALIDATE      _IO(VFIO_TYPE, VFIO_BASE +
> 24)
> > > >
> > > > +/*
> > > > + * @flag=VFIO_IOMMU_PASID_ALLOC, refer to the @min_pasid and
> > > @max_pasid fields
> > > > + * @flag=VFIO_IOMMU_PASID_FREE, refer to @pasid field
> > > > + */
> > > > +struct vfio_iommu_type1_pasid_request {
> > > > +	__u32	argsz;
> > > > +#define VFIO_IOMMU_PASID_ALLOC	(1 << 0)
> > > > +#define VFIO_IOMMU_PASID_FREE	(1 << 1)
> > > > +	__u32	flag;
> > > > +	union {
> > > > +		struct {
> > > > +			int min_pasid;
> > > > +			int max_pasid;
> > > > +		};
> > > > +		int pasid;
> > >
> > > Perhaps:
> > >
> > > 		struct {
> > > 			u32 min;
> > > 			u32 max;
> > > 		} alloc_pasid;
> > > 		u32 free_pasid;
> > >
> > > (note also the s/int/u32/)
> >
> > got it. will fix it in next version. Thanks.
> >
> > > > +	};
> > > > +};
> > > > +
> > > > +/**
> > > > + * VFIO_IOMMU_PASID_REQUEST - _IOWR(VFIO_TYPE, VFIO_BASE + 27,
> > > > + *				struct vfio_iommu_type1_pasid_request)
> > > > + *
> > > > + */
> > > > +#define VFIO_IOMMU_PASID_REQUEST	_IO(VFIO_TYPE, VFIO_BASE + 27)
> > > > +
> > > >  /* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU -------- */
> > > >
> > > >  /*
> >
> > Regards,
> > Yi Liu

