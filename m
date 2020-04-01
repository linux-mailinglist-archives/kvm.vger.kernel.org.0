Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3696019A865
	for <lists+kvm@lfdr.de>; Wed,  1 Apr 2020 11:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731839AbgDAJOV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 1 Apr 2020 05:14:21 -0400
Received: from mga17.intel.com ([192.55.52.151]:41214 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726974AbgDAJOV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Apr 2020 05:14:21 -0400
IronPort-SDR: 0UAu0lKJl+rqqnVCIRq/cjJxPXFKncsYqmzjHKr3ky7go6myhVJV2jWXymvZ5Ipo/6iNiG7V5N
 A812kuGLDPNw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2020 02:14:18 -0700
IronPort-SDR: u8tSBPnK1bjOd51OvaZcyAoPnATINWznx0n5WdEiGirqr/d9Epbfvp7vI935bxQM0afF8Fn2Ji
 CCb3gYJ0/rTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,331,1580803200"; 
   d="scan'208";a="273091002"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by fmsmga004.fm.intel.com with ESMTP; 01 Apr 2020 02:14:18 -0700
Received: from fmsmsx154.amr.corp.intel.com (10.18.116.70) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 1 Apr 2020 02:14:18 -0700
Received: from shsmsx103.ccr.corp.intel.com (10.239.4.69) by
 FMSMSX154.amr.corp.intel.com (10.18.116.70) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 1 Apr 2020 02:14:18 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.225]) by
 SHSMSX103.ccr.corp.intel.com ([169.254.4.146]) with mapi id 14.03.0439.000;
 Wed, 1 Apr 2020 17:13:07 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>
CC:     "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
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
Subject: RE: [PATCH v1 6/8] vfio/type1: Bind guest page tables to host
Thread-Topic: [PATCH v1 6/8] vfio/type1: Bind guest page tables to host
Thread-Index: AQHWAEUdkW8K+/kg/06c7098DvJyv6hgm8wAgANYlCA=
Date:   Wed, 1 Apr 2020 09:13:07 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A21D8C6@SHSMSX104.ccr.corp.intel.com>
References: <1584880325-10561-1-git-send-email-yi.l.liu@intel.com>
 <1584880325-10561-7-git-send-email-yi.l.liu@intel.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D7FF98F@SHSMSX104.ccr.corp.intel.com>
In-Reply-To: <AADFC41AFE54684AB9EE6CBC0274A5D19D7FF98F@SHSMSX104.ccr.corp.intel.com>
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

> From: Tian, Kevin <kevin.tian@intel.com>
> Sent: Monday, March 30, 2020 8:46 PM
> Subject: RE: [PATCH v1 6/8] vfio/type1: Bind guest page tables to host
> 
> > From: Liu, Yi L <yi.l.liu@intel.com>
> > Sent: Sunday, March 22, 2020 8:32 PM
> >
> > From: Liu Yi L <yi.l.liu@intel.com>
> >
> > VFIO_TYPE1_NESTING_IOMMU is an IOMMU type which is backed by hardware
> > IOMMUs that have nesting DMA translation (a.k.a dual stage address
> > translation). For such hardware IOMMUs, there are two stages/levels of
> > address translation, and software may let userspace/VM to own the
> > first-
> > level/stage-1 translation structures. Example of such usage is vSVA (
> > virtual Shared Virtual Addressing). VM owns the first-level/stage-1
> > translation structures and bind the structures to host, then hardware
> > IOMMU would utilize nesting translation when doing DMA translation fo
> > the devices behind such hardware IOMMU.
> >
> > This patch adds vfio support for binding guest translation (a.k.a
> > stage 1) structure to host iommu. And for VFIO_TYPE1_NESTING_IOMMU,
> > not only bind guest page table is needed, it also requires to expose
> > interface to guest for iommu cache invalidation when guest modified
> > the first-level/stage-1 translation structures since hardware needs to
> > be notified to flush stale iotlbs. This would be introduced in next
> > patch.
> >
> > In this patch, guest page table bind and unbind are done by using
> > flags VFIO_IOMMU_BIND_GUEST_PGTBL and
> VFIO_IOMMU_UNBIND_GUEST_PGTBL
> > under IOCTL VFIO_IOMMU_BIND, the bind/unbind data are conveyed by
> > struct iommu_gpasid_bind_data. Before binding guest page table to
> > host, VM should have got a PASID allocated by host via
> > VFIO_IOMMU_PASID_REQUEST.
> >
> > Bind guest translation structures (here is guest page table) to host
> 
> Bind -> Binding
got it.
> > are the first step to setup vSVA (Virtual Shared Virtual Addressing).
> 
> are -> is. and you already explained vSVA earlier.
oh yes, it is.
> >
> > Cc: Kevin Tian <kevin.tian@intel.com>
> > CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > Cc: Alex Williamson <alex.williamson@redhat.com>
> > Cc: Eric Auger <eric.auger@redhat.com>
> > Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
> > Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.com>
> > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > ---
> >  drivers/vfio/vfio_iommu_type1.c | 158
> > ++++++++++++++++++++++++++++++++++++++++
> >  include/uapi/linux/vfio.h       |  46 ++++++++++++
> >  2 files changed, 204 insertions(+)
> >
> > diff --git a/drivers/vfio/vfio_iommu_type1.c
> > b/drivers/vfio/vfio_iommu_type1.c index 82a9e0b..a877747 100644
> > --- a/drivers/vfio/vfio_iommu_type1.c
> > +++ b/drivers/vfio/vfio_iommu_type1.c
> > @@ -130,6 +130,33 @@ struct vfio_regions {
> >  #define IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)	\
> >  					(!list_empty(&iommu->domain_list))
> >
> > +struct domain_capsule {
> > +	struct iommu_domain *domain;
> > +	void *data;
> > +};
> > +
> > +/* iommu->lock must be held */
> > +static int vfio_iommu_for_each_dev(struct vfio_iommu *iommu,
> > +		      int (*fn)(struct device *dev, void *data),
> > +		      void *data)
> > +{
> > +	struct domain_capsule dc = {.data = data};
> > +	struct vfio_domain *d;
> > +	struct vfio_group *g;
> > +	int ret = 0;
> > +
> > +	list_for_each_entry(d, &iommu->domain_list, next) {
> > +		dc.domain = d->domain;
> > +		list_for_each_entry(g, &d->group_list, next) {
> > +			ret = iommu_group_for_each_dev(g->iommu_group,
> > +						       &dc, fn);
> > +			if (ret)
> > +				break;
> > +		}
> > +	}
> > +	return ret;
> > +}
> > +
> >  static int put_pfn(unsigned long pfn, int prot);
> >
> >  /*
> > @@ -2314,6 +2341,88 @@ static int
> > vfio_iommu_info_add_nesting_cap(struct vfio_iommu *iommu,
> >  	return 0;
> >  }
> >
> > +static int vfio_bind_gpasid_fn(struct device *dev, void *data) {
> > +	struct domain_capsule *dc = (struct domain_capsule *)data;
> > +	struct iommu_gpasid_bind_data *gbind_data =
> > +		(struct iommu_gpasid_bind_data *) dc->data;
> > +
> 
> In Jacob's vSVA iommu series, [PATCH 06/11]:
> 
> +		/* REVISIT: upper layer/VFIO can track host process that bind the
> PASID.
> +		 * ioasid_set = mm might be sufficient for vfio to check pasid VMM
> +		 * ownership.
> +		 */
> 
> I asked him who exactly should be responsible for tracking the pasid ownership.
> Although no response yet, I expect vfio/iommu can have a clear policy and also
> documented here to provide consistent message.

yep.

> > +	return iommu_sva_bind_gpasid(dc->domain, dev, gbind_data); }
> > +
> > +static int vfio_unbind_gpasid_fn(struct device *dev, void *data) {
> > +	struct domain_capsule *dc = (struct domain_capsule *)data;
> > +	struct iommu_gpasid_bind_data *gbind_data =
> > +		(struct iommu_gpasid_bind_data *) dc->data;
> > +
> > +	return iommu_sva_unbind_gpasid(dc->domain, dev,
> > +					gbind_data->hpasid);
> 
> curious why we have to share the same bind_data structure between bind and
> unbind, especially when unbind requires only one field? I didn't see a clear reason,
> and just similar to earlier ALLOC/FREE which don't share structure either.
> Current way simply wastes space for unbind operation...

no special reason today. But the gIOVA support over nested translation
is in plan, it may require a flag to indicate it as guest iommu driver
may user a single PASID value(RID2PASID) for all devices in guest side.
Especially if the RID2PASID value used for IOVA the the same with host
side. So adding a flag to indicate the binding is for IOVA is helpful.
For PF/VF, iommu driver just bind with the host side's RID2PASID. While
for ADI (Assignable Device Interface),  vfio layer needs to figure out
the default PASID stored in the aux-domain, and then iommu driver bind
gIOVA table to the default PASID. The potential flag is required in both
bind and unbind path. As such, it would be better to share the structure.

> > +}
> > +
> > +/**
> > + * Unbind specific gpasid, caller of this function requires hold
> > + * vfio_iommu->lock
> > + */
> > +static long vfio_iommu_type1_do_guest_unbind(struct vfio_iommu
> > *iommu,
> > +				struct iommu_gpasid_bind_data *gbind_data) {
> > +	return vfio_iommu_for_each_dev(iommu,
> > +				vfio_unbind_gpasid_fn, gbind_data); }
> > +
> > +static long vfio_iommu_type1_bind_gpasid(struct vfio_iommu *iommu,
> > +				struct iommu_gpasid_bind_data *gbind_data) {
> > +	int ret = 0;
> > +
> > +	mutex_lock(&iommu->lock);
> > +	if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)) {
> > +		ret = -EINVAL;
> > +		goto out_unlock;
> > +	}
> > +
> > +	ret = vfio_iommu_for_each_dev(iommu,
> > +			vfio_bind_gpasid_fn, gbind_data);
> > +	/*
> > +	 * If bind failed, it may not be a total failure. Some devices
> > +	 * within the iommu group may have bind successfully. Although
> > +	 * we don't enable pasid capability for non-singletion iommu
> > +	 * groups, a unbind operation would be helpful to ensure no
> > +	 * partial binding for an iommu group.
> > +	 */
> > +	if (ret)
> > +		/*
> > +		 * Undo all binds that already succeeded, no need to
> 
> binds -> bindings
got it.
> 
> > +		 * check the return value here since some device within
> > +		 * the group has no successful bind when coming to this
> > +		 * place switch.
> > +		 */
> 
> remove 'switch'
oh, yes.

> 
> > +		vfio_iommu_type1_do_guest_unbind(iommu, gbind_data);
> > +
> > +out_unlock:
> > +	mutex_unlock(&iommu->lock);
> > +	return ret;
> > +}
> > +
> > +static long vfio_iommu_type1_unbind_gpasid(struct vfio_iommu *iommu,
> > +				struct iommu_gpasid_bind_data *gbind_data) {
> > +	int ret = 0;
> > +
> > +	mutex_lock(&iommu->lock);
> > +	if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)) {
> > +		ret = -EINVAL;
> > +		goto out_unlock;
> > +	}
> > +
> > +	ret = vfio_iommu_type1_do_guest_unbind(iommu, gbind_data);
> > +
> > +out_unlock:
> > +	mutex_unlock(&iommu->lock);
> > +	return ret;
> > +}
> > +
> >  static long vfio_iommu_type1_ioctl(void *iommu_data,
> >  				   unsigned int cmd, unsigned long arg)  { @@ -
> 2471,6 +2580,55 @@
> > static long vfio_iommu_type1_ioctl(void *iommu_data,
> >  		default:
> >  			return -EINVAL;
> >  		}
> > +
> > +	} else if (cmd == VFIO_IOMMU_BIND) {
> 
> BIND what? VFIO_IOMMU_BIND_PASID sounds clearer to me.

Emm, it's up to the flags to indicate bind what. It was proposed to
cover the three cases below:
a) BIND/UNBIND_GPASID
b) BIND/UNBIND_GPASID_TABLE
c) BIND/UNBIND_PROCESS
<only a) is covered in this patch>
So it's called VFIO_IOMMU_BIND.

> 
> > +		struct vfio_iommu_type1_bind bind;
> > +		u32 version;
> > +		int data_size;
> > +		void *gbind_data;
> > +		int ret;
> > +
> > +		minsz = offsetofend(struct vfio_iommu_type1_bind, flags);
> > +
> > +		if (copy_from_user(&bind, (void __user *)arg, minsz))
> > +			return -EFAULT;
> > +
> > +		if (bind.argsz < minsz)
> > +			return -EINVAL;
> > +
> > +		/* Get the version of struct iommu_gpasid_bind_data */
> > +		if (copy_from_user(&version,
> > +			(void __user *) (arg + minsz),
> > +					sizeof(version)))
> > +			return -EFAULT;
> > +
> > +		data_size = iommu_uapi_get_data_size(
> > +				IOMMU_UAPI_BIND_GPASID, version);
> > +		gbind_data = kzalloc(data_size, GFP_KERNEL);
> > +		if (!gbind_data)
> > +			return -ENOMEM;
> > +
> > +		if (copy_from_user(gbind_data,
> > +			 (void __user *) (arg + minsz), data_size)) {
> > +			kfree(gbind_data);
> > +			return -EFAULT;
> > +		}
> > +
> > +		switch (bind.flags & VFIO_IOMMU_BIND_MASK) {
> > +		case VFIO_IOMMU_BIND_GUEST_PGTBL:
> > +			ret = vfio_iommu_type1_bind_gpasid(iommu,
> > +							   gbind_data);
> > +			break;
> > +		case VFIO_IOMMU_UNBIND_GUEST_PGTBL:
> > +			ret = vfio_iommu_type1_unbind_gpasid(iommu,
> > +							     gbind_data);
> > +			break;
> > +		default:
> > +			ret = -EINVAL;
> > +			break;
> > +		}
> > +		kfree(gbind_data);
> > +		return ret;
> >  	}
> >
> >  	return -ENOTTY;
> > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > index ebeaf3e..2235bc6 100644
> > --- a/include/uapi/linux/vfio.h
> > +++ b/include/uapi/linux/vfio.h
> > @@ -14,6 +14,7 @@
> >
> >  #include <linux/types.h>
> >  #include <linux/ioctl.h>
> > +#include <linux/iommu.h>
> >
> >  #define VFIO_API_VERSION	0
> >
> > @@ -853,6 +854,51 @@ struct vfio_iommu_type1_pasid_request {
> >   */
> >  #define VFIO_IOMMU_PASID_REQUEST	_IO(VFIO_TYPE, VFIO_BASE +
> > 22)
> >
> > +/**
> > + * Supported flags:
> > + *	- VFIO_IOMMU_BIND_GUEST_PGTBL: bind guest page tables to host
> > for
> > + *			nesting type IOMMUs. In @data field It takes struct
> > + *			iommu_gpasid_bind_data.
> > + *	- VFIO_IOMMU_UNBIND_GUEST_PGTBL: undo a bind guest page
> > table operation
> > + *			invoked by VFIO_IOMMU_BIND_GUEST_PGTBL.
> > + *
> > + */
> > +struct vfio_iommu_type1_bind {
> > +	__u32		argsz;
> > +	__u32		flags;
> > +#define VFIO_IOMMU_BIND_GUEST_PGTBL	(1 << 0)
> > +#define VFIO_IOMMU_UNBIND_GUEST_PGTBL	(1 << 1)
> > +	__u8		data[];
> > +};
> > +
> > +#define VFIO_IOMMU_BIND_MASK	(VFIO_IOMMU_BIND_GUEST_PGTBL
> > | \
> > +
> > 	VFIO_IOMMU_UNBIND_GUEST_PGTBL)
> > +
> > +/**
> > + * VFIO_IOMMU_BIND - _IOW(VFIO_TYPE, VFIO_BASE + 23,
> > + *				struct vfio_iommu_type1_bind)
> > + *
> > + * Manage address spaces of devices in this container. Initially a
> > +TYPE1
> > + * container can only have one address space, managed with
> > + * VFIO_IOMMU_MAP/UNMAP_DMA.
> 
> the last sentence seems irrelevant and more suitable in commit msg.

oh, I could remove it.

> > + *
> > + * An IOMMU of type VFIO_TYPE1_NESTING_IOMMU can be managed by
> > both MAP/UNMAP
> > + * and BIND ioctls at the same time. MAP/UNMAP acts on the stage-2
> > + (host)
> > page
> > + * tables, and BIND manages the stage-1 (guest) page tables. Other
> > + types of
> 
> Are "other types" the counterpart to VFIO_TYPE1_NESTING_IOMMU?
> What are those types? I thought only NESTING_IOMMU allows two stage
> translation...

it's a mistake... please ignore this message. would correct it in next version.

> 
> > + * IOMMU may allow MAP/UNMAP and BIND to coexist, where
> 
> The first sentence said the same thing. Then what is the exact difference?

this sentence were added by mistake. will correct it.

> 
> > MAP/UNMAP controls
> > + * the traffics only require single stage translation while BIND
> > + controls the
> > + * traffics require nesting translation. But this depends on the
> > + underlying
> > + * IOMMU architecture and isn't guaranteed. Example of this is the
> > + guest
> > SVA
> > + * traffics, such traffics need nesting translation to gain gVA->gPA
> > + and then
> > + * gPA->hPA translation.
> 
> I'm a bit confused about the content since "other types of". Are they trying to state
> some exceptions/corner cases that this API cannot resolve or explain the desired
> behavior of the API? Especially the last example, which is worded as if the example
> for "isn't guaranteed"
> but isn't guest SVA the main purpose of this API?
> 
I think the description in original patch is bad especially with the "other types"
phrase. How about the below description?

/**
 * VFIO_IOMMU_BIND - _IOW(VFIO_TYPE, VFIO_BASE + 23,
 *				struct vfio_iommu_type1_bind)
 *
 * Manage address spaces of devices in this container when it's an IOMMU
 * of type VFIO_TYPE1_NESTING_IOMMU. Such type IOMMU allows MAP/UNMAP and
 * BIND to coexist, where MAP/UNMAP controls the traffics only require
 * single stage translation while BIND controls the traffics require nesting
 * translation.
 *
 * Availability of this feature depends on the device, its bus, the underlying
 * IOMMU and the CPU architecture.
 *
 * returns: 0 on success, -errno on failure.
 */

Regards,
Yi Liu

