Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F09BF8E62
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2019 12:21:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727264AbfKLLVt convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 12 Nov 2019 06:21:49 -0500
Received: from mga02.intel.com ([134.134.136.20]:26653 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725865AbfKLLVn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Nov 2019 06:21:43 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Nov 2019 03:21:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,296,1569308400"; 
   d="scan'208";a="207080391"
Received: from fmsmsx104.amr.corp.intel.com ([10.18.124.202])
  by orsmga003.jf.intel.com with ESMTP; 12 Nov 2019 03:21:42 -0800
Received: from fmsmsx125.amr.corp.intel.com (10.18.125.40) by
 fmsmsx104.amr.corp.intel.com (10.18.124.202) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 12 Nov 2019 03:21:42 -0800
Received: from shsmsx103.ccr.corp.intel.com (10.239.4.69) by
 FMSMSX125.amr.corp.intel.com (10.18.125.40) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 12 Nov 2019 03:21:42 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.127]) by
 SHSMSX103.ccr.corp.intel.com ([169.254.4.60]) with mapi id 14.03.0439.000;
 Tue, 12 Nov 2019 19:21:40 +0800
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
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Lu, Baolu" <baolu.lu@intel.com>, "Wu, Hao" <hao.wu@intel.com>
Subject: RE: [RFC v2 3/3] vfio/type1: bind guest pasid (guest page tables)
 to host
Thread-Topic: [RFC v2 3/3] vfio/type1: bind guest pasid (guest page tables)
 to host
Thread-Index: AQHVimn49qwPncOwpUK3oA3gYR4tBqd/6QGAgAdz7JA=
Date:   Tue, 12 Nov 2019 11:21:40 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A0F6894@SHSMSX104.ccr.corp.intel.com>
References: <1571919983-3231-1-git-send-email-yi.l.liu@intel.com>
        <1571919983-3231-4-git-send-email-yi.l.liu@intel.com>
 <20191107162041.31e620a4@x1.home>
In-Reply-To: <20191107162041.31e620a4@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNmFjZDM1ODEtZjhlNi00ZTQzLThkOWItYzg4ODAxZGI4MDdkIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiNkJPRFhkQjBRYWpiakxjUVZJTUgwNklVOXgzY0pGeEdqaHNSXC84WVRlYW5aR2FoWk1FKzRMcjBnWDY0NDlWQ0wifQ==
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson < alex.williamson@redhat.com >
> Sent: Friday, November 8, 2019 7:21 AM
> To: Liu, Yi L <yi.l.liu@intel.com>
> Subject: Re: [RFC v2 3/3] vfio/type1: bind guest pasid (guest page tables) to host
> 
> On Thu, 24 Oct 2019 08:26:23 -0400
> Liu Yi L <yi.l.liu@intel.com> wrote:
> 
> > This patch adds vfio support to bind guest translation structure
> > to host iommu. VFIO exposes iommu programming capability to user-
> > space. Guest is a user-space application in host under KVM solution.
> > For SVA usage in Virtual Machine, guest owns GVA->GPA translation
> > structure. And this part should be passdown to host to enable nested
> > translation (or say two stage translation). This patch reuses the
> > VFIO_IOMMU_BIND proposal from Jean-Philippe Brucker, and adds new
> > bind type for binding guest owned translation structure to host.
> >
> > *) Add two new ioctls for VFIO containers.
> >
> >   - VFIO_IOMMU_BIND: for bind request from userspace, it could be
> >                    bind a process to a pasid or bind a guest pasid
> >                    to a device, this is indicated by type
> >   - VFIO_IOMMU_UNBIND: for unbind request from userspace, it could be
> >                    unbind a process to a pasid or unbind a guest pasid
> >                    to a device, also indicated by type
> >   - Bind type:
> > 	VFIO_IOMMU_BIND_PROCESS: user-space request to bind a process
> >                    to a device
> > 	VFIO_IOMMU_BIND_GUEST_PASID: bind guest owned translation
> >                    structure to host iommu. e.g. guest page table
> >
> > *) Code logic in vfio_iommu_type1_ioctl() to handle VFIO_IOMMU_BIND/UNBIND
> >
> > Cc: Kevin Tian <kevin.tian@intel.com>
> > Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
> > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > ---
> >  drivers/vfio/vfio_iommu_type1.c | 136
> ++++++++++++++++++++++++++++++++++++++++
> >  include/uapi/linux/vfio.h       |  44 +++++++++++++
> >  2 files changed, 180 insertions(+)
> >
> > diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> > index 3d73a7d..1a27e25 100644
> > --- a/drivers/vfio/vfio_iommu_type1.c
> > +++ b/drivers/vfio/vfio_iommu_type1.c
> > @@ -2325,6 +2325,104 @@ static int vfio_iommu_type1_pasid_free(struct
> vfio_iommu *iommu,
> >  	return ret;
> >  }
> >
> > +static int vfio_bind_gpasid_fn(struct device *dev, void *data)
> > +{
> > +	struct domain_capsule *dc = (struct domain_capsule *)data;
> > +	struct iommu_gpasid_bind_data *ustruct =
> > +		(struct iommu_gpasid_bind_data *) dc->data;
> > +
> > +	return iommu_sva_bind_gpasid(dc->domain, dev, ustruct);
> > +}
> > +
> > +static int vfio_unbind_gpasid_fn(struct device *dev, void *data)
> > +{
> > +	struct domain_capsule *dc = (struct domain_capsule *)data;
> > +	struct iommu_gpasid_bind_data *ustruct =
> > +		(struct iommu_gpasid_bind_data *) dc->data;
> > +
> > +	return iommu_sva_unbind_gpasid(dc->domain, dev,
> > +						ustruct->hpasid);
> > +}
> > +
> > +/*
> > + * unbind specific gpasid, caller of this function requires hold
> > + * vfio_iommu->lock
> > + */
> > +static long vfio_iommu_type1_do_guest_unbind(struct vfio_iommu *iommu,
> > +		  struct iommu_gpasid_bind_data *gbind_data)
> > +{
> > +	return vfio_iommu_lookup_dev(iommu, vfio_unbind_gpasid_fn, gbind_data);
> > +}
> > +
> > +static long vfio_iommu_type1_bind_gpasid(struct vfio_iommu *iommu,
> > +					    void __user *arg,
> > +					    struct vfio_iommu_type1_bind *bind)
> > +{
> > +	struct iommu_gpasid_bind_data gbind_data;
> > +	unsigned long minsz;
> > +	int ret = 0;
> > +
> > +	minsz = sizeof(*bind) + sizeof(gbind_data);
> > +	if (bind->argsz < minsz)
> > +		return -EINVAL;
> > +
> > +	if (copy_from_user(&gbind_data, arg, sizeof(gbind_data)))
> > +		return -EFAULT;
> > +
> > +	mutex_lock(&iommu->lock);
> > +	if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)) {
> > +		ret = -EINVAL;
> > +		goto out_unlock;
> > +	}
> > +
> > +	ret = vfio_iommu_lookup_dev(iommu, vfio_bind_gpasid_fn, &gbind_data);
> > +	/*
> > +	 * If bind failed, it may not be a total failure. Some devices within
> > +	 * the iommu group may have bind successfully. Although we don't enable
> > +	 * pasid capability for non-singletion iommu groups, a unbind operation
> > +	 * would be helpful to ensure no partial binding for an iommu group.
> > +	 */
> > +	if (ret)
> > +		/*
> > +		 * Undo all binds that already succeeded, no need to check the
> > +		 * return value here since some device within the group has no
> > +		 * successful bind when coming to this place switch.
> > +		 */
> > +		vfio_iommu_type1_do_guest_unbind(iommu, &gbind_data);
> > +
> > +out_unlock:
> > +	mutex_unlock(&iommu->lock);
> > +	return ret;
> > +}
> > +
> > +static long vfio_iommu_type1_unbind_gpasid(struct vfio_iommu *iommu,
> > +					    void __user *arg,
> > +					    struct vfio_iommu_type1_bind *bind)
> > +{
> > +	struct iommu_gpasid_bind_data gbind_data;
> > +	unsigned long minsz;
> > +	int ret = 0;
> > +
> > +	minsz = sizeof(*bind) + sizeof(gbind_data);
> > +	if (bind->argsz < minsz)
> > +		return -EINVAL;
> 
> But gbind_data can change size if new vendor specific data is added to
> the union, so kernel updates break existing userspace.  Fail.

yes, we have a version field in struct iommu_gpasid_bind_data. How
about doing sanity check per versions? kernel knows the gbind_data
size of specific versions. Does it make sense? If yes, I'll also apply it
to the other sanity check in this series to avoid userspace fail after
kernel update.

> > +
> > +	if (copy_from_user(&gbind_data, arg, sizeof(gbind_data)))
> > +		return -EFAULT;
> > +
> > +	mutex_lock(&iommu->lock);
> > +	if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)) {
> > +		ret = -EINVAL;
> > +		goto out_unlock;
> > +	}
> > +
> > +	ret = vfio_iommu_type1_do_guest_unbind(iommu, &gbind_data);
> > +
> > +out_unlock:
> > +	mutex_unlock(&iommu->lock);
> > +	return ret;
> > +}
> > +
> >  static long vfio_iommu_type1_ioctl(void *iommu_data,
> >  				   unsigned int cmd, unsigned long arg)
> >  {
> > @@ -2484,6 +2582,44 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
> >  		default:
> >  			return -EINVAL;
> >  		}
> > +
> > +	} else if (cmd == VFIO_IOMMU_BIND) {
> > +		struct vfio_iommu_type1_bind bind;
> > +
> > +		minsz = offsetofend(struct vfio_iommu_type1_bind, bind_type);
> > +
> > +		if (copy_from_user(&bind, (void __user *)arg, minsz))
> > +			return -EFAULT;
> > +
> > +		if (bind.argsz < minsz)
> > +			return -EINVAL;
> > +
> > +		switch (bind.bind_type) {
> > +		case VFIO_IOMMU_BIND_GUEST_PASID:
> > +			return vfio_iommu_type1_bind_gpasid(iommu,
> > +					(void __user *)(arg + minsz), &bind);
> 
> Why are we defining BIND_PROCESS if it's not supported?  How does the
> user learn it's not supported?

I think I should drop it so far since I only add BIND_GUEST_PASID. I think
Jean Philippe may need it in his native SVA enabling patchset. For the way
to let user learn it, may be using VFIO_IOMMU_GET_INFO as you mentioned
below?

> 
> > +		default:
> > +			return -EINVAL;
> > +		}
> > +
> > +	} else if (cmd == VFIO_IOMMU_UNBIND) {
> > +		struct vfio_iommu_type1_bind bind;
> > +
> > +		minsz = offsetofend(struct vfio_iommu_type1_bind, bind_type);
> > +
> > +		if (copy_from_user(&bind, (void __user *)arg, minsz))
> > +			return -EFAULT;
> > +
> > +		if (bind.argsz < minsz)
> > +			return -EINVAL;
> > +
> > +		switch (bind.bind_type) {
> > +		case VFIO_IOMMU_BIND_GUEST_PASID:
> > +			return vfio_iommu_type1_unbind_gpasid(iommu,
> > +					(void __user *)(arg + minsz), &bind);
> > +		default:
> > +			return -EINVAL;
> > +		}
> >  	}
> >
> >  	return -ENOTTY;
> > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > index 04de290..78e8c64 100644
> > --- a/include/uapi/linux/vfio.h
> > +++ b/include/uapi/linux/vfio.h
> > @@ -832,6 +832,50 @@ struct vfio_iommu_type1_pasid_request {
> >   */
> >  #define VFIO_IOMMU_PASID_REQUEST	_IO(VFIO_TYPE, VFIO_BASE + 27)
> >
> > +enum vfio_iommu_bind_type {
> > +	VFIO_IOMMU_BIND_PROCESS,
> > +	VFIO_IOMMU_BIND_GUEST_PASID,
> > +};
> > +
> > +/*
> > + * Supported types:
> > + *	- VFIO_IOMMU_BIND_GUEST_PASID: bind guest pasid, which invoked
> > + *			by guest, it takes iommu_gpasid_bind_data in data.
> > + */
> > +struct vfio_iommu_type1_bind {
> > +	__u32				argsz;
> > +	enum vfio_iommu_bind_type	bind_type;
> > +	__u8				data[];
> > +};
> 
> I don't think enum defines a compiler invariant data size.  We can't
> use it for a kernel/user interface.  Also why no flags field as is
> essentially standard for every vfio ioctl?  Couldn't we specify
> process/guest-pasid with flags?

I remember there is an early comment in community which pointed out
that using flags potentially allows to config multiples types in one IOCTL.
Regards to it, defining explicit emums avoids it. But I agree with you,
it makes variant size. I'll fix it if this matter more.

> For that matter couldn't we specify
> bind/unbind using a single ioctl?  I think that would be more
> consistent with the pasid alloc/free ioctl in the previous patch.

yes, let me make it in next version.

> Why are we appending opaque data to the end of the structure when
> clearly we expect a struct iommu_gpasid_bind_data?

This is due to the intention to support BIND_GUEST_PASID and
BIND_PROCESS with a single IOCTL. Maybe we can use a separate
IOCTL for BIND_PROCESS. what's your opinion here?

> That bind data
> structure expects a format (ex. IOMMU_PASID_FORMAT_INTEL_VTD).  How does
> a user determine what formats are accepted from within the vfio API (or
> even outside of the vfio API)?

The info is provided by vIOMMU emulator (e.g. virtual VT-d). The vSVA patch
from Jacob has a sanity check on it.
https://lkml.org/lkml/2019/10/28/873

> > +
> > +/*
> > + * VFIO_IOMMU_BIND - _IOWR(VFIO_TYPE, VFIO_BASE + 28, struct
> vfio_iommu_bind)
>                             ^
> The semantics appear to just be _IOW, nothing is written back to the
> userspace buffer on return.

will fix it. thanks.

> > + *
> > + * Manage address spaces of devices in this container. Initially a TYPE1
> > + * container can only have one address space, managed with
> > + * VFIO_IOMMU_MAP/UNMAP_DMA.
> > + *
> > + * An IOMMU of type VFIO_TYPE1_NESTING_IOMMU can be managed by both
> MAP/UNMAP
> > + * and BIND ioctls at the same time. MAP/UNMAP acts on the stage-2 (host) page
> > + * tables, and BIND manages the stage-1 (guest) page tables. Other types of
> > + * IOMMU may allow MAP/UNMAP and BIND to coexist, where MAP/UNMAP
> controls
> > + * non-PASID traffic and BIND controls PASID traffic. But this depends on the
> > + * underlying IOMMU architecture and isn't guaranteed.
> > + *
> > + * Availability of this feature depends on the device, its bus, the underlying
> > + * IOMMU and the CPU architecture.
> 
> And the user discovers this is available by...?  There's no probe here,
> are they left only to setup a VM to the point of trying to use this
> before they fail the ioctl?  Could VFIO_IOMMU_GET_INFO fill this gap?
> Thanks,

I think VFIO_IOMMU_GET_INFO could help. let me extend it to fill this gap
if you agree.

> Alex

Thanks,
Yi Liu

> 
> > + *
> > + * returns: 0 on success, -errno on failure.
> > + */
> > +#define VFIO_IOMMU_BIND		_IO(VFIO_TYPE, VFIO_BASE + 28)
> > +
> > +/*
> > + * VFIO_IOMMU_UNBIND - _IOWR(VFIO_TYPE, VFIO_BASE + 29, struct
> vfio_iommu_bind)
> > + *
> > + * Undo what was done by the corresponding VFIO_IOMMU_BIND ioctl.
> > + */
> > +#define VFIO_IOMMU_UNBIND	_IO(VFIO_TYPE, VFIO_BASE + 29)
> > +
> >  /* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU -------- */
> >
> >  /*

