Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1B7C20BF
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2019 14:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730958AbfI3MlG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 30 Sep 2019 08:41:06 -0400
Received: from mga05.intel.com ([192.55.52.43]:13543 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730949AbfI3MlG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Sep 2019 08:41:06 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Sep 2019 05:41:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,567,1559545200"; 
   d="scan'208";a="220638355"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by fmsmga002.fm.intel.com with ESMTP; 30 Sep 2019 05:41:05 -0700
Received: from fmsmsx102.amr.corp.intel.com (10.18.124.200) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 30 Sep 2019 05:41:06 -0700
Received: from shsmsx102.ccr.corp.intel.com (10.239.4.154) by
 FMSMSX102.amr.corp.intel.com (10.18.124.200) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 30 Sep 2019 05:41:05 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.166]) by
 shsmsx102.ccr.corp.intel.com ([169.254.2.176]) with mapi id 14.03.0439.000;
 Mon, 30 Sep 2019 20:41:03 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "He, Shaopeng" <shaopeng.he@intel.com>,
        "Xia, Chenbo" <chenbo.xia@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>
Subject: RE: [PATCH v2 13/13] vfio/type1: track iommu backed group attach
Thread-Topic: [PATCH v2 13/13] vfio/type1: track iommu backed group attach
Thread-Index: AQHVZIzPA7thwYsEk0Wo3xzd3+jDRac813CAgAcOD0A=
Date:   Mon, 30 Sep 2019 12:41:03 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A0B560E@SHSMSX104.ccr.corp.intel.com>
References: <1567670923-4599-1-git-send-email-yi.l.liu@intel.com>
 <20190925203723.044d3bf0@x1.home>
In-Reply-To: <20190925203723.044d3bf0@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiOTY2MGQ1MjktNjIxNy00MzAzLTk2NWMtYzg3OTllOWE1MjBmIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiT2VsM0piMlRORENUZkdCTE54bVBIRDdkSm4ybVBwTldZZzRMWU52WFU3eEU0SFwvMlFaM2gxWWt1TXdcL3JtMEd2In0=
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

> From: Alex Williamson [mailto:alex.williamson@redhat.com]
> Sent: Thursday, September 26, 2019 10:37 AM
> To: Liu, Yi L <yi.l.liu@intel.com>
> Subject: Re: [PATCH v2 13/13] vfio/type1: track iommu backed group attach
> 
> On Thu,  5 Sep 2019 16:08:43 +0800
> Liu Yi L <yi.l.liu@intel.com> wrote:
> 
> > With the introduction of iommu aware mdev group, user may wrap a PF/VF
> > as a mdev. Such mdevs will be called as wrapped PF/VF mdevs in following
> > statements. If it's applied on a non-singleton iommu group, there would
> > be multiple domain attach on an iommu_device group (equal to iommu backed
> > group). Reason is that mdev group attaches is finally an iommu_device
> > group attach in the end. And existing vfio_domain.gorup_list has no idea
> > about it. Thus multiple attach would happen.
> >
> > What's more, under default domain policy, group attach is allowed only
> > when its in-use domain is equal to its default domain as the code below:
> >
> > static int __iommu_attach_group(struct iommu_domain *domain, ..)
> > {
> > 	..
> > 	if (group->default_domain && group->domain != group->default_domain)
> > 		return -EBUSY;
> > 	...
> > }
> >
> > So for the above scenario, only the first group attach on the
> > non-singleton iommu group will be successful. Subsequent group
> > attaches will be failed. However, this is a fairly valid usage case
> > if the wrapped PF/VF mdevs and other devices are assigned to a single
> > VM. We may want to prevent it. In other words, the subsequent group
> > attaches should return success before going to __iommu_attach_group().
> >
> > However, if user tries to assign the wrapped PF/VF mdevs and other
> > devices to different VMs, the subsequent group attaches on a single
> > iommu_device group should be failed. This means the subsequent group
> > attach should finally calls into __iommu_attach_group() and be failed.
> >
> > To meet the above requirements, this patch introduces vfio_group_object
> > structure to track the group attach of an iommu_device group (a.ka.
> > iommu backed group). Each vfio_domain will have a group_obj_list to
> > record the vfio_group_objects. The search of the group_obj_list should
> > use iommu_device group if a group is mdev group.
> >
> > 	struct vfio_group_object {
> > 		atomic_t		count;
> > 		struct iommu_group	*iommu_group;
> > 		struct vfio_domain	*domain;
> > 		struct list_head	next;
> > 	};
> >
> > Each time, a successful group attach should either have a new
> > vfio_group_object created or count increasing of an existing
> > vfio_group_object instance. Details can be found in
> > vfio_domain_attach_group_object().
> >
> > For group detach, should have count decreasing. Please check
> > vfio_domain_detach_group_object().
> >
> > As the vfio_domain.group_obj_list is within vfio container(vfio_iommu)
> > scope, if user wants to passthru a non-singleton to multiple VMs, it
> > will be failed as VMs will have separate vfio containers. Also, if
> > vIOMMU is exposed, it will also fail the attempts of assigning multiple
> > devices (via vfio-pci or PF/VF wrapped mdev) to a single VM. This is
> > aligned with current vfio passthru rules.
> >
> > Cc: Kevin Tian <kevin.tian@intel.com>
> > Cc: Lu Baolu <baolu.lu@linux.intel.com>
> > Suggested-by: Alex Williamson <alex.williamson@redhat.com>
> > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > ---
> >  drivers/vfio/vfio_iommu_type1.c | 167
> ++++++++++++++++++++++++++++++++++++----
> >  1 file changed, 154 insertions(+), 13 deletions(-)
> >
> > diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> > index 317430d..6a67bd6 100644
> > --- a/drivers/vfio/vfio_iommu_type1.c
> > +++ b/drivers/vfio/vfio_iommu_type1.c
> > @@ -75,6 +75,7 @@ struct vfio_domain {
> >  	struct iommu_domain	*domain;
> >  	struct list_head	next;
> >  	struct list_head	group_list;
> > +	struct list_head	group_obj_list;
> >  	int			prot;		/* IOMMU_CACHE */
> >  	bool			fgsp;		/* Fine-grained super pages */
> >  };
> > @@ -97,6 +98,13 @@ struct vfio_group {
> >  	bool			mdev_group;	/* An mdev group */
> >  };
> >
> > +struct vfio_group_object {
> > +	atomic_t		count;
> > +	struct iommu_group	*iommu_group;
> > +	struct vfio_domain	*domain;
> > +	struct list_head	next;
> > +};
> > +
> 
> So vfio_domain already has a group_list for all the groups attached to
> that iommu domain.  We add a vfio_group_object list, which is also
> effectively a list of groups attached to the domain, but we're tracking
> something different with it.  All groups seem to get added as a
> vfio_group_object, so why do we need both lists?

yeah. It's functional workable. But looks ugly. The key purpose of this
patch is to prevent duplicate domain attach for a single iommu group.
Got another idea, see if it matches what we expect. Let me explain.

Existing group_list tracks iommu group attachment regardless of group
type (mdev iommu group and iommu backed iommu group). For mdev
iommu group, we actually have two sub-types. mdev iommu groups with
iommu_device and groups w/o iommu_device. My idea here is to do a
slight change against mdev iommu groups with iommu_device since it is
the case we are handling. For such iommu groups, we can detect it and
use its iommu_device group to do check in the domain->group_list. e.g.
for such a group,
     *) if found its iommu_device group has been attached, then return.
     *) if failed to find a matched attach, we create a vfio_group and
          finish the rest of the domain attach
With this proposal, mdev iommu groups with iommu_device will not have
vfio_group added in the domain->group_list. It will be tracked by its
iommu_device group. For normal mdev iommu groups, it will still have its
own vfio_group added in the domain->group_list.

To achieve it, we need to detect iommu_group type at the beginning of
vfio_iommu_type1_attach_group (), which means to move the bus_type
check to the beginning. I guess it may have simpler change. Thoughts?

> As I suspected when
> we discussed this last, this adds complexity for something that's
> currently being proposed as a sample driver.

yeah, I was also hesitated to do it. However, if a user wants to wrap its
PCI device as a mdev, it will more or less face the usage on non-singleton
groups. If the new proposal is not that complex, I guess we can try to
make it happen.

> 
> >  /*
> >   * Guest RAM pinning working set or DMA target
> >   */
> > @@ -1263,6 +1271,85 @@ static struct vfio_group *find_iommu_group(struct
> vfio_domain *domain,
> >  	return NULL;
> >  }
> >
> > +static struct vfio_group_object *find_iommu_group_object(
> > +		struct vfio_domain *domain, struct iommu_group *iommu_group)
> > +{
> > +	struct vfio_group_object *g;
> > +
> > +	list_for_each_entry(g, &domain->group_obj_list, next) {
> > +		if (g->iommu_group == iommu_group)
> > +			return g;
> > +	}
> > +
> > +	return NULL;
> > +}
> > +
> > +static void vfio_init_iommu_group_object(struct vfio_group_object *group_obj,
> > +		struct vfio_domain *domain, struct iommu_group *iommu_group)
> > +{
> > +	if (!group_obj || !domain || !iommu_group) {
> > +		WARN_ON(1);
> > +		return;
> > +	}
> 
> This is poor error handling, either this should never happen or we
> should have an error path for it.

Good lesson for me. Thanks~

> > +	atomic_set(&group_obj->count, 1);
> > +	group_obj->iommu_group = iommu_group;
> > +	group_obj->domain = domain;
> > +	list_add(&group_obj->next, &domain->group_obj_list);
> > +}
> > +
> > +static int vfio_domain_attach_group_object(
> > +		struct vfio_domain *domain, struct iommu_group *iommu_group)
> > +{
> > +	struct vfio_group_object *group_obj;
> > +
> > +	group_obj = find_iommu_group_object(domain, iommu_group);
> > +	if (group_obj) {
> > +		atomic_inc(&group_obj->count);
> > +		return 0;
> > +	}
> > +	group_obj = kzalloc(sizeof(*group_obj), GFP_KERNEL);
> 
> The group_obj test should be here, where we can return an error.

yep. thanks.

> > +	vfio_init_iommu_group_object(group_obj, domain, iommu_group);
> > +	return iommu_attach_group(domain->domain, iommu_group);
> > +}
> > +
> > +static int vfio_domain_detach_group_object(
> > +		struct vfio_domain *domain, struct iommu_group *iommu_group)
> 
> A detach should generally return void, it cannot fail.

Oops, yes it is.

> > +{
> > +	struct vfio_group_object *group_obj;
> > +
> > +	group_obj = find_iommu_group_object(domain, iommu_group);
> > +	if (!group_obj) {
> > +		WARN_ON(1);
> > +		return -EINVAL;
> 
> The WARN is probably appropriate here since this is an internal
> consistency failure.

Got it. thanks.

> > +	}
> > +	if (atomic_dec_if_positive(&group_obj->count) == 0) {
> > +		list_del(&group_obj->next);
> > +		kfree(group_obj);
> > +	}
> 
> Like in the previous patch, I don't think this atomic is doing
> everything you're intending it to do, the iommu->lock seems more like
> it might be the one protecting us here.  If that's true, then we don't
> need this to be an atomic.
> 
> > +	iommu_detach_group(domain->domain, iommu_group);
> 
> How do we get away with detaching the group regardless of the reference
> count?!

how poor am I. got it. ^_^

> > +	return 0;
> > +}
> > +
> > +/*
> > + * Check if an iommu backed group has been attached to a domain within
> > + * a specific container (vfio_iommu). If yes, return the vfio_group_object
> > + * which tracks the previous domain attach for this group. Caller of this
> > + * function should hold vfio_iommu->lock.
> > + */
> > +static struct vfio_group_object *vfio_iommu_group_object_check(
> > +		struct vfio_iommu *iommu, struct iommu_group *iommu_group)
> 
> So vfio_iommu_group_object_check() finds a vfio_group_object anywhere
> in the vfio_iommu while find_iommu_group_object() only finds it within
> a vfio_domain.  Maybe find_iommu_group_obj_in_domain() vs
> find_iommu_group_obj_in_iommu()?

yes, better than mine.

> > +{
> > +	struct vfio_domain *d;
> > +	struct vfio_group_object *group_obj;
> > +
> > +	list_for_each_entry(d, &iommu->domain_list, next) {
> > +		group_obj = find_iommu_group_object(d, iommu_group);
> > +		if (group_obj)
> > +			return group_obj;
> > +	}
> > +	return NULL;
> > +}
> > +
> >  static bool vfio_iommu_has_sw_msi(struct iommu_group *group, phys_addr_t
> *base)
> >  {
> >  	struct list_head group_resv_regions;
> > @@ -1310,21 +1397,23 @@ static struct device
> *vfio_mdev_get_iommu_device(struct device *dev)
> >
> >  static int vfio_mdev_attach_domain(struct device *dev, void *data)
> >  {
> > -	struct iommu_domain *domain = data;
> > +	struct vfio_domain *domain = data;
> >  	struct device *iommu_device;
> >  	struct iommu_group *group;
> >
> >  	iommu_device = vfio_mdev_get_iommu_device(dev);
> >  	if (iommu_device) {
> >  		if (iommu_dev_feature_enabled(iommu_device,
> IOMMU_DEV_FEAT_AUX))
> > -			return iommu_aux_attach_device(domain, iommu_device);
> > +			return iommu_aux_attach_device(domain->domain,
> > +							iommu_device);
> >  		else {
> >  			group = iommu_group_get(iommu_device);
> >  			if (!group) {
> >  				WARN_ON(1);
> >  				return -EINVAL;
> >  			}
> > -			return iommu_attach_group(domain, group);
> > +			return vfio_domain_attach_group_object(
> > +							domain, group);
> >  		}
> >  	}
> >
> > @@ -1333,21 +1422,22 @@ static int vfio_mdev_attach_domain(struct device
> *dev, void *data)
> >
> >  static int vfio_mdev_detach_domain(struct device *dev, void *data)
> >  {
> > -	struct iommu_domain *domain = data;
> > +	struct vfio_domain *domain = data;
> >  	struct device *iommu_device;
> >  	struct iommu_group *group;
> >
> >  	iommu_device = vfio_mdev_get_iommu_device(dev);
> >  	if (iommu_device) {
> >  		if (iommu_dev_feature_enabled(iommu_device,
> IOMMU_DEV_FEAT_AUX))
> > -			iommu_aux_detach_device(domain, iommu_device);
> > +			iommu_aux_detach_device(domain->domain,
> iommu_device);
> >  		else {
> >  			group = iommu_group_get(iommu_device);
> >  			if (!group) {
> >  				WARN_ON(1);
> >  				return -EINVAL;
> >  			}
> > -			iommu_detach_group(domain, group);
> > +			return vfio_domain_detach_group_object(
> > +							domain, group);
> >  		}
> >  	}
> >
> > @@ -1359,20 +1449,27 @@ static int vfio_iommu_attach_group(struct
> vfio_domain *domain,
> >  {
> >  	if (group->mdev_group)
> >  		return iommu_group_for_each_dev(group->iommu_group,
> > -						domain->domain,
> > +						domain,
> >  						vfio_mdev_attach_domain);
> >  	else
> > -		return iommu_attach_group(domain->domain, group-
> >iommu_group);
> > +		return vfio_domain_attach_group_object(domain,
> > +							group->iommu_group);
> >  }
> >
> >  static void vfio_iommu_detach_group(struct vfio_domain *domain,
> >  				    struct vfio_group *group)
> >  {
> > +	int ret;
> > +
> >  	if (group->mdev_group)
> > -		iommu_group_for_each_dev(group->iommu_group, domain-
> >domain,
> > +		iommu_group_for_each_dev(group->iommu_group, domain,
> >  					 vfio_mdev_detach_domain);
> > -	else
> > -		iommu_detach_group(domain->domain, group->iommu_group);
> > +	else {
> > +		ret = vfio_domain_detach_group_object(
> > +						domain, group->iommu_group);
> > +		if (ret)
> > +			pr_warn("%s, deatch failed!! ret: %d", __func__, ret);
> 
> Detach cannot fail.

yep. let me fix it.
 
> > +	}
> >  }
> >
> >  static bool vfio_bus_is_mdev(struct bus_type *bus)
> > @@ -1412,6 +1509,10 @@ static int vfio_iommu_type1_attach_group(void
> *iommu_data,
> >  	int ret;
> >  	bool resv_msi, msi_remap;
> >  	phys_addr_t resv_msi_base;
> > +	struct vfio_group_object *group_obj = NULL;
> > +	struct device *iommu_device = NULL;
> > +	struct iommu_group *iommu_device_group;
> > +
> >
> >  	mutex_lock(&iommu->lock);
> >
> > @@ -1438,14 +1539,20 @@ static int vfio_iommu_type1_attach_group(void
> *iommu_data,
> >
> >  	group->iommu_group = iommu_group;
> >
> > +	group_obj = vfio_iommu_group_object_check(iommu, group-
> >iommu_group);
> > +	if (group_obj) {
> > +		atomic_inc(&group_obj->count);
> > +		list_add(&group->next, &group_obj->domain->group_list);
> > +		mutex_unlock(&iommu->lock);
> > +		return 0;
> 
> domain is leaked.

yep. should be fixed in next version, if we follow this proposal.

> > +	}
> > +
> >  	/* Determine bus_type in order to allocate a domain */
> >  	ret = iommu_group_for_each_dev(iommu_group, &bus, vfio_bus_type);
> >  	if (ret)
> >  		goto out_free;
> >
> >  	if (vfio_bus_is_mdev(bus)) {
> > -		struct device *iommu_device = NULL;
> > -
> >  		group->mdev_group = true;
> >
> >  		/* Determine the isolation type */
> > @@ -1469,6 +1576,39 @@ static int vfio_iommu_type1_attach_group(void
> *iommu_data,
> >  		bus = iommu_device->bus;
> >  	}
> >
> > +	/*
> > +	 * Check if iommu backed group attached to a domain within current
> > +	 * container. If yes, increase the count; If no, go ahead with a
> > +	 * new domain attach process.
> > +	 */
> > +	group_obj = NULL;
> 
> How could it be otherwise?

Oops, this comment should be better described. My point is if group_obj
is not found, then this vfio_iommu_type1_attach_group() call should go
with normal domain attach. And this means the codes behind below comment
should be finished before return.

+	/*
+	 * Now we are sure we want to initialize a new vfio_domain.
+	 * First step is to alloc an iommu_domain from iommu abstract
+	 * layer.
+	 */

> > +	if (iommu_device) {
> > +		iommu_device_group = iommu_group_get(iommu_device);
> > +		if (!iommu_device_group) {
> > +			WARN_ON(1);
> 
> No WARN please.

yep, no need here.

> group is leaked.

poor leak. let me keep it mind.

> > +			kfree(domain);
> > +			mutex_unlock(&iommu->lock);
> > +			return -EINVAL;
> > +		}
> > +		group_obj = vfio_iommu_group_object_check(iommu,
> > +							iommu_device_group);
> 
> iommu_device_group reference is elevated.  Thanks,

yes, a leak here. would be carful on it in future. :-)

> Alex

Thanks a lot Alex, good lessons in the above comments. I'll address them if
we go on with the proposal in this patch. or if you prefer the new proposal
in the first response, I would be pleased to get it implemented.

Thanks,
Yi Liu

> > +	} else
> > +		group_obj = vfio_iommu_group_object_check(iommu,
> > +							group->iommu_group);
> > +
> > +	if (group_obj) {
> > +		atomic_inc(&group_obj->count);
> > +		list_add(&group->next, &group_obj->domain->group_list);
> > +		kfree(domain);
> > +		mutex_unlock(&iommu->lock);
> > +		return 0;
> > +	}
> > +
> > +	/*
> > +	 * Now we are sure we want to initialize a new vfio_domain.
> > +	 * First step is to alloc an iommu_domain from iommu abstract
> > +	 * layer.
> > +	 */
> >  	domain->domain = iommu_domain_alloc(bus);
> >  	if (!domain->domain) {
> >  		ret = -EIO;
> > @@ -1484,6 +1624,7 @@ static int vfio_iommu_type1_attach_group(void
> *iommu_data,
> >  			goto out_domain;
> >  	}
> >
> > +	INIT_LIST_HEAD(&domain->group_obj_list);
> >  	ret = vfio_iommu_attach_group(domain, group);
> >  	if (ret)
> >  		goto out_domain;

