Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAAA21952BF
	for <lists+kvm@lfdr.de>; Fri, 27 Mar 2020 09:25:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726217AbgC0IZV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Mar 2020 04:25:21 -0400
Received: from mga17.intel.com ([192.55.52.151]:22986 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726096AbgC0IZV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Mar 2020 04:25:21 -0400
IronPort-SDR: e/sIivhkuDEgQ5Femlwc130dh68Zhl9hq0azEViaPLUP+uZiuZg6eVkX1TyYRfkk4Y55LZykAy
 McBWYv08cZww==
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2020 01:25:18 -0700
IronPort-SDR: R+3F9JBTLIBDgVWx3CXL/wqC7TbAuRYlNSHFNanRVshVICdEccnbOs3WC+r8f59MbMNUk6cUMz
 QIfSJBRPIlaw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,311,1580803200"; 
   d="asc'?scan'208";a="247816126"
Received: from zhen-hp.sh.intel.com (HELO zhen-hp) ([10.239.160.147])
  by orsmga003.jf.intel.com with ESMTP; 27 Mar 2020 01:25:17 -0700
Date:   Fri, 27 Mar 2020 16:12:15 +0800
From:   Zhenyu Wang <zhenyuw@linux.intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Yuan, Hang" <hang.yuan@intel.com>
Subject: Re: [PATCH v2 2/2] drm/i915/gvt: mdev aggregation type
Message-ID: <20200327081215.GJ8880@zhen-hp.sh.intel.com>
Reply-To: Zhenyu Wang <zhenyuw@linux.intel.com>
References: <20200326054136.2543-1-zhenyuw@linux.intel.com>
 <20200326054136.2543-3-zhenyuw@linux.intel.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D7ED10B@SHSMSX104.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="E6NCJjdg6OUEG/ZU"
Content-Disposition: inline
In-Reply-To: <AADFC41AFE54684AB9EE6CBC0274A5D19D7ED10B@SHSMSX104.ccr.corp.intel.com>
User-Agent: Mutt/1.10.0 (2018-05-17)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--E6NCJjdg6OUEG/ZU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2020.03.27 07:48:14 +0000, Tian, Kevin wrote:
> > From: Zhenyu Wang <zhenyuw@linux.intel.com>
> > Sent: Thursday, March 26, 2020 1:42 PM
> >=20
> > To increase the flexibility for resource allocation on mdev types,f
>=20
> remove trailing ',f'

oops, typo

>=20
> > this trys to add aggregation attribute for mdev type that can
> > aggregate gfx memory resources in GVT case.
> >=20
> > Use sysfs method for this attribute, the most difference for GVT is
> > that the gfx resource allocation will be delayed until mdev open
> > instead of mdev create to allow aggregation setting before VM
> > start. But gfx resource accouting would still handle left resource for
> > target vGPU or other types.
>=20
> the last sentence is not very clear. I suppose although the resource
> (#aggregated_instances) is not allocated but it is already reserved
> and accounted before mdev open?

yeah, that means to handle resource accounting before mdev open.

>=20
> >=20
> > "max_aggregation" would show maxium instances for aggregation on
> > target vGPU type. "aggregated_instances" shows current count of aggrega=
ted
>=20
> "target vGPU type" or "target vGPU instance"?

yeah, for target instance.

>=20
> > instances. "max_aggregation" is read-only and user sets needed account
>=20
> account->count

ok.

>=20
> > by write to "aggregated_instances".
> >=20
> > Cc: Kevin Tian <kevin.tian@intel.com>
> > Cc: "Jiang, Dave" <dave.jiang@intel.com>
> > Cc: "Yuan, Hang" <hang.yuan@intel.com>
> > Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
> > ---
> >  drivers/gpu/drm/i915/gvt/aperture_gm.c |  44 +++++--
> >  drivers/gpu/drm/i915/gvt/gtt.c         |   9 +-
> >  drivers/gpu/drm/i915/gvt/gvt.c         |   7 +-
> >  drivers/gpu/drm/i915/gvt/gvt.h         |  42 ++++--
> >  drivers/gpu/drm/i915/gvt/kvmgt.c       | 115 ++++++++++++++++-
> >  drivers/gpu/drm/i915/gvt/vgpu.c        | 172 +++++++++++++++++--------
> >  6 files changed, 295 insertions(+), 94 deletions(-)
> >=20
> > diff --git a/drivers/gpu/drm/i915/gvt/aperture_gm.c
> > b/drivers/gpu/drm/i915/gvt/aperture_gm.c
> > index 0d6d59871308..9ee3083b37ae 100644
> > --- a/drivers/gpu/drm/i915/gvt/aperture_gm.c
> > +++ b/drivers/gpu/drm/i915/gvt/aperture_gm.c
> > @@ -238,10 +238,10 @@ static void free_resource(struct intel_vgpu *vgpu)
> >  	gvt->fence.vgpu_allocated_fence_num -=3D vgpu_fence_sz(vgpu);
> >  }
> >=20
> > -static int alloc_resource(struct intel_vgpu *vgpu,
> > -		struct intel_vgpu_creation_params *param)
> > +static int alloc_resource(struct intel_vgpu *vgpu)
> >  {
> >  	struct intel_gvt *gvt =3D vgpu->gvt;
> > +	struct intel_vgpu_creation_params *param =3D &vgpu->param;
> >  	unsigned long request, avail, max, taken;
> >  	const char *item;
> >=20
> > @@ -254,7 +254,7 @@ static int alloc_resource(struct intel_vgpu *vgpu,
> >  	max =3D gvt_aperture_sz(gvt) - HOST_LOW_GM_SIZE;
> >  	taken =3D gvt->gm.vgpu_allocated_low_gm_size;
> >  	avail =3D max - taken;
> > -	request =3D MB_TO_BYTES(param->low_gm_sz);
> > +	request =3D param->low_gm_sz * param->aggregation;
> >=20
> >  	if (request > avail)
> >  		goto no_enough_resource;
> > @@ -265,7 +265,7 @@ static int alloc_resource(struct intel_vgpu *vgpu,
> >  	max =3D gvt_hidden_sz(gvt) - HOST_HIGH_GM_SIZE;
> >  	taken =3D gvt->gm.vgpu_allocated_high_gm_size;
> >  	avail =3D max - taken;
> > -	request =3D MB_TO_BYTES(param->high_gm_sz);
> > +	request =3D param->high_gm_sz * param->aggregation;
> >=20
> >  	if (request > avail)
> >  		goto no_enough_resource;
> > @@ -283,8 +283,8 @@ static int alloc_resource(struct intel_vgpu *vgpu,
> >=20
> >  	vgpu_fence_sz(vgpu) =3D request;
> >=20
> > -	gvt->gm.vgpu_allocated_low_gm_size +=3D MB_TO_BYTES(param-
> > >low_gm_sz);
> > -	gvt->gm.vgpu_allocated_high_gm_size +=3D MB_TO_BYTES(param-
> > >high_gm_sz);
> > +	gvt->gm.vgpu_allocated_low_gm_size +=3D param->low_gm_sz *
> > param->aggregation;
> > +	gvt->gm.vgpu_allocated_high_gm_size +=3D param->high_gm_sz *
> > param->aggregation;
> >  	gvt->fence.vgpu_allocated_fence_num +=3D param->fence_sz;
> >  	return 0;
> >=20
> > @@ -307,9 +307,34 @@ void intel_vgpu_free_resource(struct intel_vgpu
> > *vgpu)
> >  {
> >  	free_vgpu_gm(vgpu);
> >  	free_vgpu_fence(vgpu);
> > +}
> > +
> > +void intel_vgpu_free_resource_count(struct intel_vgpu *vgpu)
> > +{
> >  	free_resource(vgpu);
> >  }
> >=20
> > +int intel_vgpu_alloc_resource_count(struct intel_vgpu *vgpu)
> > +{
> > +	return alloc_resource(vgpu);
> > +}
> > +
> > +int intel_vgpu_adjust_resource_count(struct intel_vgpu *vgpu)
> > +{
> > +	if ((vgpu_aperture_sz(vgpu) !=3D vgpu->param.low_gm_sz *
> > +	     vgpu->param.aggregation) ||
> > +	    (vgpu_hidden_sz(vgpu) !=3D vgpu->param.high_gm_sz *
> > +	     vgpu->param.aggregation)) {
> > +		/* handle aggregation change */
> > +		intel_vgpu_free_resource_count(vgpu);
> > +		intel_vgpu_alloc_resource_count(vgpu);
>=20
> this logic sounds like different from the commit msg. Earlier you
> said the resource is not allocated until mdev open, while the
> aggregated_interfaces is only allowed to be written before
> mdev open. In such case, why would it required to handle the
> case where a vgpu already has resource allocated then coming
> a new request to adjust the number of instances?

This is to handle resource accounting before mdev open by aggregation
setting change. When vgpu create from mdev type, default resource
count according to type is set for vgpu. So this function is just to
change resource count by aggregation.

>=20
> > +		mutex_lock(&vgpu->gvt->lock);
> > +		intel_gvt_update_vgpu_types(vgpu->gvt);
> > +		mutex_unlock(&vgpu->gvt->lock);
> > +	}
> > +	return 0;
> > +}
> > +
> >  /**
> >   * intel_vgpu_reset_resource - reset resource state owned by a vGPU
> >   * @vgpu: a vGPU
> > @@ -338,15 +363,10 @@ void intel_vgpu_reset_resource(struct intel_vgpu
> > *vgpu)
> >   * zero on success, negative error code if failed.
> >   *
> >   */
> > -int intel_vgpu_alloc_resource(struct intel_vgpu *vgpu,
> > -		struct intel_vgpu_creation_params *param)
> > +int intel_vgpu_alloc_resource(struct intel_vgpu *vgpu)
> >  {
> >  	int ret;
> >=20
> > -	ret =3D alloc_resource(vgpu, param);
> > -	if (ret)
> > -		return ret;
> > -
> >  	ret =3D alloc_vgpu_gm(vgpu);
> >  	if (ret)
> >  		goto out_free_resource;
> > diff --git a/drivers/gpu/drm/i915/gvt/gtt.c b/drivers/gpu/drm/i915/gvt/=
gtt.c
> > index 2a4b23f8aa74..60f455134ed0 100644
> > --- a/drivers/gpu/drm/i915/gvt/gtt.c
> > +++ b/drivers/gpu/drm/i915/gvt/gtt.c
> > @@ -2466,12 +2466,6 @@ int intel_vgpu_init_gtt(struct intel_vgpu *vgpu)
> >  {
> >  	struct intel_vgpu_gtt *gtt =3D &vgpu->gtt;
> >=20
> > -	INIT_RADIX_TREE(&gtt->spt_tree, GFP_KERNEL);
> > -
> > -	INIT_LIST_HEAD(&gtt->ppgtt_mm_list_head);
> > -	INIT_LIST_HEAD(&gtt->oos_page_list_head);
> > -	INIT_LIST_HEAD(&gtt->post_shadow_list_head);
> > -
> >  	gtt->ggtt_mm =3D intel_vgpu_create_ggtt_mm(vgpu);
> >  	if (IS_ERR(gtt->ggtt_mm)) {
> >  		gvt_vgpu_err("fail to create mm for ggtt.\n");
> > @@ -2508,6 +2502,9 @@ static void intel_vgpu_destroy_ggtt_mm(struct
> > intel_vgpu *vgpu)
> >  {
> >  	struct intel_gvt_partial_pte *pos, *next;
> >=20
> > +	if (!vgpu->gtt.ggtt_mm)
> > +		return;
> > +
> >  	list_for_each_entry_safe(pos, next,
> >  				 &vgpu->gtt.ggtt_mm-
> > >ggtt_mm.partial_pte_list,
> >  				 list) {
> > diff --git a/drivers/gpu/drm/i915/gvt/gvt.c b/drivers/gpu/drm/i915/gvt/=
gvt.c
> > index 9e1787867894..bbd77cba239e 100644
> > --- a/drivers/gpu/drm/i915/gvt/gvt.c
> > +++ b/drivers/gpu/drm/i915/gvt/gvt.c
> > @@ -99,11 +99,11 @@ static ssize_t description_show(struct kobject *kob=
j,
> > struct device *dev,
> >=20
> >  	return sprintf(buf, "low_gm_size: %dMB\nhigh_gm_size: %dMB\n"
> >  		       "fence: %d\nresolution: %s\n"
> > -		       "weight: %d\n",
> > +		       "weight: %d\naggregation: %s\n",
> >  		       BYTES_TO_MB(type->low_gm_size),
> >  		       BYTES_TO_MB(type->high_gm_size),
> >  		       type->fence, vgpu_edid_str(type->resolution),
> > -		       type->weight);
> > +		       type->weight, type->aggregation ? "yes" : "no");
> >  }
> >=20
> >  static MDEV_TYPE_ATTR_RO(available_instances);
> > @@ -185,6 +185,9 @@ static const struct intel_gvt_ops intel_gvt_ops =3D=
 {
> >  	.vgpu_get_dmabuf =3D intel_vgpu_get_dmabuf,
> >  	.write_protect_handler =3D intel_vgpu_page_track_handler,
> >  	.emulate_hotplug =3D intel_vgpu_emulate_hotplug,
> > +	.vgpu_delayed_alloc =3D intel_vgpu_delayed_alloc,
> > +	.vgpu_res_free =3D intel_vgpu_res_free,
> > +	.vgpu_res_change =3D intel_vgpu_adjust_resource_count,
> >  };
> >=20
> >  static void init_device_info(struct intel_gvt *gvt)
> > diff --git a/drivers/gpu/drm/i915/gvt/gvt.h b/drivers/gpu/drm/i915/gvt/=
gvt.h
> > index 58c2c7932e3f..bb8f16d468f4 100644
> > --- a/drivers/gpu/drm/i915/gvt/gvt.h
> > +++ b/drivers/gpu/drm/i915/gvt/gvt.h
> > @@ -165,15 +165,30 @@ struct intel_vgpu_submission {
> >  	bool active;
> >  };
> >=20
> > +struct intel_vgpu_creation_params {
> > +	__u64 handle;
> > +	__u64 low_gm_sz;
> > +	__u64 high_gm_sz;
> > +	__u64 fence_sz;
> > +	__u64 resolution;
> > +	__s32 primary;
> > +	__u64 vgpu_id;
> > +	__u32 weight;
> > +	__u32 aggregation; /* requested aggregation number if type
> > supports */
> > +};
> > +
> >  struct intel_vgpu {
> >  	struct intel_gvt *gvt;
> >  	struct mutex vgpu_lock;
> >  	int id;
> >  	unsigned long handle; /* vGPU handle used by hypervisor MPT
> > modules */
> >  	bool active;
> > +	bool res_initialized;
> >  	bool pv_notified;
> >  	bool failsafe;
> >  	unsigned int resetting_eng;
> > +	struct intel_vgpu_creation_params param;
> > +	struct intel_vgpu_type *type;
> >=20
> >  	/* Both sched_data and sched_ctl can be seen a part of the global gvt
> >  	 * scheduler structure. So below 2 vgpu data are protected
> > @@ -276,6 +291,7 @@ struct intel_vgpu_type {
> >  	unsigned int fence;
> >  	unsigned int weight;
> >  	enum intel_vgpu_edid resolution;
> > +	bool aggregation;
> >  };
> >=20
> >  struct intel_gvt {
> > @@ -402,22 +418,12 @@ int intel_gvt_load_firmware(struct intel_gvt *gvt=
);
> >  #define vgpu_fence_base(vgpu) (vgpu->fence.base)
> >  #define vgpu_fence_sz(vgpu) (vgpu->fence.size)
> >=20
> > -struct intel_vgpu_creation_params {
> > -	__u64 handle;
> > -	__u64 low_gm_sz;  /* in MB */
> > -	__u64 high_gm_sz; /* in MB */
> > -	__u64 fence_sz;
> > -	__u64 resolution;
> > -	__s32 primary;
> > -	__u64 vgpu_id;
> > -
> > -	__u32 weight;
> > -};
> > -
> > -int intel_vgpu_alloc_resource(struct intel_vgpu *vgpu,
> > -			      struct intel_vgpu_creation_params *param);
> > +int intel_vgpu_alloc_resource(struct intel_vgpu *vgpu);
> >  void intel_vgpu_reset_resource(struct intel_vgpu *vgpu);
> >  void intel_vgpu_free_resource(struct intel_vgpu *vgpu);
> > +int intel_vgpu_alloc_resource_count(struct intel_vgpu *vgpu);
> > +void intel_vgpu_free_resource_count(struct intel_vgpu *vgpu);
> > +int intel_vgpu_adjust_resource_count(struct intel_vgpu *vgpu);
> >  void intel_vgpu_write_fence(struct intel_vgpu *vgpu,
> >  	u32 fence, u64 value);
> >=20
> > @@ -458,11 +464,13 @@ static inline void intel_vgpu_write_pci_bar(struct
> > intel_vgpu *vgpu,
> >=20
> >  int intel_gvt_init_vgpu_types(struct intel_gvt *gvt);
> >  void intel_gvt_clean_vgpu_types(struct intel_gvt *gvt);
> > +void intel_gvt_update_vgpu_types(struct intel_gvt *gvt);
> >=20
> >  struct intel_vgpu *intel_gvt_create_idle_vgpu(struct intel_gvt *gvt);
> >  void intel_gvt_destroy_idle_vgpu(struct intel_vgpu *vgpu);
> >  struct intel_vgpu *intel_gvt_create_vgpu(struct intel_gvt *gvt,
> >  					 struct intel_vgpu_type *type);
> > +int intel_vgpu_delayed_alloc(struct intel_vgpu *vgpu);
> >  void intel_gvt_destroy_vgpu(struct intel_vgpu *vgpu);
> >  void intel_gvt_release_vgpu(struct intel_vgpu *vgpu);
> >  void intel_gvt_reset_vgpu_locked(struct intel_vgpu *vgpu, bool dmlr,
> > @@ -523,6 +531,9 @@ static inline u64 intel_vgpu_get_bar_gpa(struct
> > intel_vgpu *vgpu, int bar)
> >  			PCI_BASE_ADDRESS_MEM_MASK;
> >  }
> >=20
> > +int intel_vgpu_res_alloc(struct intel_vgpu *vgpu);
> > +void intel_vgpu_res_free(struct intel_vgpu *vgpu);
> > +
> >  void intel_vgpu_clean_opregion(struct intel_vgpu *vgpu);
> >  int intel_vgpu_init_opregion(struct intel_vgpu *vgpu);
> >  int intel_vgpu_opregion_base_write_handler(struct intel_vgpu *vgpu, u32
> > gpa);
> > @@ -557,6 +568,9 @@ struct intel_gvt_ops {
> >  	int (*write_protect_handler)(struct intel_vgpu *, u64, void *,
> >  				     unsigned int);
> >  	void (*emulate_hotplug)(struct intel_vgpu *vgpu, bool connected);
> > +	int (*vgpu_delayed_alloc)(struct intel_vgpu *vgpu);
> > +	void (*vgpu_res_free)(struct intel_vgpu *vgpu);
> > +	int (*vgpu_res_change)(struct intel_vgpu *vgpu);
> >  };
> >=20
> >=20
> > diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c
> > b/drivers/gpu/drm/i915/gvt/kvmgt.c
> > index 074c4efb58eb..b1a4096c6c50 100644
> > --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> > +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> > @@ -711,6 +711,7 @@ static int intel_vgpu_create(struct kobject *kobj,
> > struct mdev_device *mdev)
> >  		gvt_err("failed to create intel vgpu: %d\n", ret);
> >  		goto out;
> >  	}
> > +	vgpu->type =3D type;
> >=20
> >  	INIT_WORK(&kvmgt_vdev(vgpu)->release_work,
> > intel_vgpu_release_work);
> >=20
> > @@ -793,6 +794,8 @@ static int intel_vgpu_open(struct mdev_device *mdev)
> >  	unsigned long events;
> >  	int ret;
> >=20
> > +	mutex_lock(&vgpu->vgpu_lock);
> > +
> >  	vdev->iommu_notifier.notifier_call =3D intel_vgpu_iommu_notifier;
> >  	vdev->group_notifier.notifier_call =3D intel_vgpu_group_notifier;
> >=20
> > @@ -814,21 +817,32 @@ static int intel_vgpu_open(struct mdev_device
> > *mdev)
> >  		goto undo_iommu;
> >  	}
> >=20
> > +	if (vgpu->type->aggregation && vgpu->param.aggregation) {
> > +		ret =3D intel_gvt_ops->vgpu_delayed_alloc(vgpu);
> > +		if (ret)
> > +			goto undo_group;
> > +	}
> > +
> >  	/* Take a module reference as mdev core doesn't take
> >  	 * a reference for vendor driver.
> >  	 */
> >  	if (!try_module_get(THIS_MODULE))
> > -		goto undo_group;
> > +		goto free_res;
> >=20
> >  	ret =3D kvmgt_guest_init(mdev);
> > -	if (ret)
> > -		goto undo_group;
> > +	if (ret) {
> > +		module_put(THIS_MODULE);
> > +		goto free_res;
> > +	}
> >=20
> >  	intel_gvt_ops->vgpu_activate(vgpu);
> >=20
> >  	atomic_set(&vdev->released, 0);
> > -	return ret;
> > +	goto out;
> >=20
> > +free_res:
> > +	if (vgpu->type->aggregation && vgpu->param.aggregation)
> > +		intel_gvt_ops->vgpu_res_free(vgpu);
> >  undo_group:
> >  	vfio_unregister_notifier(mdev_dev(mdev), VFIO_GROUP_NOTIFY,
> >  					&vdev->group_notifier);
> > @@ -837,6 +851,7 @@ static int intel_vgpu_open(struct mdev_device *mdev)
> >  	vfio_unregister_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY,
> >  					&vdev->iommu_notifier);
> >  out:
> > +	mutex_unlock(&vgpu->vgpu_lock);
> >  	return ret;
> >  }
> >=20
> > @@ -1628,8 +1643,100 @@ static const struct attribute_group
> > intel_vgpu_group =3D {
> >  	.attrs =3D intel_vgpu_attrs,
> >  };
> >=20
> > +/*
> > + * "max_aggregation" display maxium instances for aggregation,
> > + * if type doesn't support aggregation, it displays 0
> > + */
> > +static ssize_t
> > +max_aggregation_show(struct device *dev, struct device_attribute *attr,
> > +		     char *buf)
> > +{
> > +	struct mdev_device *mdev =3D mdev_from_dev(dev);
> > +
> > +	if (mdev) {
> > +		struct intel_vgpu *vgpu =3D (struct intel_vgpu *)
> > +			mdev_get_drvdata(mdev);
> > +		struct intel_vgpu_type *type =3D vgpu->type;
> > +		/* return left avail + current allocated as maxium */
> > +		unsigned int m =3D type->avail_instance +
> > +			vgpu->param.aggregation;
> > +		if (type->aggregation)
> > +			return sprintf(buf, "%u\n", m);
> > +	}
> > +	return sprintf(buf, "0\n");
> > +}
> > +static DEVICE_ATTR_RO(max_aggregation);
> > +
> > +static ssize_t
> > +aggregated_instances_store(struct device *dev, struct device_attribute=
 *attr,
> > +			   const char *buf, size_t count)
> > +{
> > +	struct mdev_device *mdev =3D mdev_from_dev(dev);
> > +	unsigned long val;
> > +	ssize_t ret =3D -EINVAL;
> > +
> > +	if (kstrtoul(buf, 0, &val) < 0)
> > +		return ret;
> > +
> > +	if (val > 0 && mdev) {
> > +		struct intel_vgpu *vgpu =3D (struct intel_vgpu *)
> > +			mdev_get_drvdata(mdev);
> > +		struct intel_vgpu_type *type =3D vgpu->type;
> > +
> > +		if (val =3D=3D vgpu->param.aggregation)
> > +			return count;
> > +
> > +		mutex_lock(&vgpu->vgpu_lock);
> > +		if (vgpu->active) {
> > +			mutex_unlock(&vgpu->vgpu_lock);
> > +			return ret;
> > +		}
> > +		/*
> > +		 * value should be less than maxium aggregation
> > +		 * instance number.
> > +		 */
> > +		if (type->aggregation &&
> > +		    val <=3D (vgpu->param.aggregation + type->avail_instance)) {
> > +			vgpu->param.aggregation =3D val;
> > +			intel_gvt_ops->vgpu_res_change(vgpu);
> > +			ret =3D count;
> > +		}
> > +		mutex_unlock(&vgpu->vgpu_lock);
> > +	}
> > +	return ret;
> > +}
> > +
> > +static ssize_t
> > +aggregated_instances_show(struct device *dev, struct device_attribute =
*attr,
> > +		 char *buf)
> > +{
> > +	struct mdev_device *mdev =3D mdev_from_dev(dev);
> > +
> > +	if (mdev) {
> > +		struct intel_vgpu *vgpu =3D (struct intel_vgpu *)
> > +			mdev_get_drvdata(mdev);
> > +		struct intel_vgpu_type *type =3D vgpu->type;
> > +		if (type->aggregation)
> > +			return sprintf(buf, "%u\n", vgpu-
> > >param.aggregation);
> > +	}
> > +	return sprintf(buf, "0\n");
> > +}
> > +static DEVICE_ATTR_RW(aggregated_instances);
> > +
> > +static struct attribute *mdev_attrs[] =3D {
> > +	&dev_attr_max_aggregation.attr,
> > +	&dev_attr_aggregated_instances.attr,
> > +	NULL
> > +};
> > +
> > +static const struct attribute_group mdev_group =3D {
> > +	.name =3D "mdev",
> > +	.attrs =3D mdev_attrs,
> > +};
> > +
> >  static const struct attribute_group *intel_vgpu_groups[] =3D {
> >  	&intel_vgpu_group,
> > +	&mdev_group,
> >  	NULL,
> >  };
> >=20
> > diff --git a/drivers/gpu/drm/i915/gvt/vgpu.c
> > b/drivers/gpu/drm/i915/gvt/vgpu.c
> > index 1d5ff88078bd..08a1b164e9a8 100644
> > --- a/drivers/gpu/drm/i915/gvt/vgpu.c
> > +++ b/drivers/gpu/drm/i915/gvt/vgpu.c
> > @@ -89,12 +89,13 @@ static struct {
> >  	unsigned int weight;
> >  	enum intel_vgpu_edid edid;
> >  	char *name;
> > +	bool aggregation;
> >  } vgpu_types[] =3D {
> >  /* Fixed vGPU type table */
> > -	{ MB_TO_BYTES(64), MB_TO_BYTES(384), 4, VGPU_WEIGHT(8),
> > GVT_EDID_1024_768, "8" },
> > -	{ MB_TO_BYTES(128), MB_TO_BYTES(512), 4, VGPU_WEIGHT(4),
> > GVT_EDID_1920_1200, "4" },
> > -	{ MB_TO_BYTES(256), MB_TO_BYTES(1024), 4, VGPU_WEIGHT(2),
> > GVT_EDID_1920_1200, "2" },
> > -	{ MB_TO_BYTES(512), MB_TO_BYTES(2048), 4, VGPU_WEIGHT(1),
> > GVT_EDID_1920_1200, "1" },
> > +	{ MB_TO_BYTES(64), MB_TO_BYTES(384), 4, VGPU_WEIGHT(8),
> > GVT_EDID_1024_768, "8", true },
> > +	{ MB_TO_BYTES(128), MB_TO_BYTES(512), 4, VGPU_WEIGHT(4),
> > GVT_EDID_1920_1200, "4", false },
> > +	{ MB_TO_BYTES(256), MB_TO_BYTES(1024), 4, VGPU_WEIGHT(2),
> > GVT_EDID_1920_1200, "2", false },
> > +	{ MB_TO_BYTES(512), MB_TO_BYTES(2048), 4, VGPU_WEIGHT(1),
> > GVT_EDID_1920_1200, "1", false },
> >  };
> >=20
> >  /**
> > @@ -148,6 +149,7 @@ int intel_gvt_init_vgpu_types(struct intel_gvt *gvt)
> >  		gvt->types[i].resolution =3D vgpu_types[i].edid;
> >  		gvt->types[i].avail_instance =3D min(low_avail /
> > vgpu_types[i].low_mm,
> >  						   high_avail /
> > vgpu_types[i].high_mm);
> > +		gvt->types[i].aggregation =3D vgpu_types[i].aggregation;
> >=20
> >  		if (IS_GEN(gvt->gt->i915, 8))
> >  			sprintf(gvt->types[i].name, "GVTg_V4_%s",
> > @@ -174,7 +176,7 @@ void intel_gvt_clean_vgpu_types(struct intel_gvt *g=
vt)
> >  	kfree(gvt->types);
> >  }
> >=20
> > -static void intel_gvt_update_vgpu_types(struct intel_gvt *gvt)
> > +void intel_gvt_update_vgpu_types(struct intel_gvt *gvt)
> >  {
> >  	int i;
> >  	unsigned int low_gm_avail, high_gm_avail, fence_avail;
> > @@ -213,9 +215,7 @@ static void intel_gvt_update_vgpu_types(struct
> > intel_gvt *gvt)
> >   */
> >  void intel_gvt_activate_vgpu(struct intel_vgpu *vgpu)
> >  {
> > -	mutex_lock(&vgpu->vgpu_lock);
> >  	vgpu->active =3D true;
> > -	mutex_unlock(&vgpu->vgpu_lock);
> >  }
> >=20
> >  /**
> > @@ -259,6 +259,8 @@ void intel_gvt_release_vgpu(struct intel_vgpu *vgpu)
> >  	mutex_lock(&vgpu->vgpu_lock);
> >  	intel_vgpu_clean_workloads(vgpu, ALL_ENGINES);
> >  	intel_vgpu_dmabuf_cleanup(vgpu);
> > +	if (vgpu->type->aggregation)
> > +		intel_vgpu_res_free(vgpu);
> >  	mutex_unlock(&vgpu->vgpu_lock);
> >  }
> >=20
> > @@ -290,10 +292,13 @@ void intel_gvt_destroy_vgpu(struct intel_vgpu
> > *vgpu)
> >  	intel_vgpu_clean_submission(vgpu);
> >  	intel_vgpu_clean_display(vgpu);
> >  	intel_vgpu_clean_opregion(vgpu);
> > -	intel_vgpu_reset_ggtt(vgpu, true);
> > -	intel_vgpu_clean_gtt(vgpu);
> > +	if (vgpu->res_initialized) {
> > +		intel_vgpu_reset_ggtt(vgpu, true);
> > +		intel_vgpu_clean_gtt(vgpu);
> > +		intel_vgpu_free_resource(vgpu);
> > +	}
> > +	intel_vgpu_free_resource_count(vgpu);
> >  	intel_gvt_hypervisor_detach_vgpu(vgpu);
> > -	intel_vgpu_free_resource(vgpu);
> >  	intel_vgpu_clean_mmio(vgpu);
> >  	intel_vgpu_dmabuf_cleanup(vgpu);
> >  	mutex_unlock(&vgpu->vgpu_lock);
> > @@ -364,59 +369,85 @@ void intel_gvt_destroy_idle_vgpu(struct intel_vgpu
> > *vgpu)
> >  	vfree(vgpu);
> >  }
> >=20
> > -static struct intel_vgpu *__intel_gvt_create_vgpu(struct intel_gvt *gv=
t,
> > -		struct intel_vgpu_creation_params *param)
> > +int intel_vgpu_res_alloc(struct intel_vgpu *vgpu)
> >  {
> > -	struct intel_vgpu *vgpu;
> >  	int ret;
> >=20
> > -	gvt_dbg_core("handle %llu low %llu MB high %llu MB fence %llu\n",
> > -			param->handle, param->low_gm_sz, param-
> > >high_gm_sz,
> > -			param->fence_sz);
> > +	ret =3D intel_vgpu_alloc_resource(vgpu);
> > +	if (ret)
> > +		return ret;
> >=20
> > -	vgpu =3D vzalloc(sizeof(*vgpu));
> > -	if (!vgpu)
> > -		return ERR_PTR(-ENOMEM);
> > +	populate_pvinfo_page(vgpu);
> > +
> > +	ret =3D intel_vgpu_init_gtt(vgpu);
> > +	if (ret) {
> > +		intel_vgpu_free_resource(vgpu);
> > +		return ret;
> > +	}
> > +	vgpu->res_initialized =3D true;
> > +	return 0;
> > +}
> > +
> > +void intel_vgpu_res_free(struct intel_vgpu *vgpu)
> > +{
> > +	intel_vgpu_reset_ggtt(vgpu, true);
> > +	intel_vgpu_clean_gtt(vgpu);
> > +	intel_vgpu_free_resource(vgpu);
> > +	vgpu->res_initialized =3D false;
> > +	mutex_lock(&vgpu->gvt->lock);
> > +	intel_gvt_update_vgpu_types(vgpu->gvt);
> > +	mutex_unlock(&vgpu->gvt->lock);
> > +}
> > +
> > +static int
> > +__intel_gvt_create_vgpu(struct intel_vgpu *vgpu,
> > +			bool delay_res_alloc)
> > +{
> > +	struct intel_gvt *gvt =3D vgpu->gvt;
> > +	struct intel_vgpu_gtt *gtt =3D &vgpu->gtt;
> > +	int ret;
> >=20
> >  	ret =3D idr_alloc(&gvt->vgpu_idr, vgpu, IDLE_VGPU_IDR + 1,
> > GVT_MAX_VGPU,
> > -		GFP_KERNEL);
> > +			GFP_KERNEL);
> >  	if (ret < 0)
> > -		goto out_free_vgpu;
> > -
> > +		return ret;
> >  	vgpu->id =3D ret;
> > -	vgpu->handle =3D param->handle;
> > -	vgpu->gvt =3D gvt;
> > -	vgpu->sched_ctl.weight =3D param->weight;
> > +
> >  	mutex_init(&vgpu->vgpu_lock);
> >  	mutex_init(&vgpu->dmabuf_lock);
> >  	INIT_LIST_HEAD(&vgpu->dmabuf_obj_list_head);
> >  	INIT_RADIX_TREE(&vgpu->page_track_tree, GFP_KERNEL);
> >  	idr_init(&vgpu->object_idr);
> > -	intel_vgpu_init_cfg_space(vgpu, param->primary);
> > +	INIT_RADIX_TREE(&gtt->spt_tree, GFP_KERNEL);
> > +	INIT_LIST_HEAD(&gtt->ppgtt_mm_list_head);
> > +	INIT_LIST_HEAD(&gtt->oos_page_list_head);
> > +	INIT_LIST_HEAD(&gtt->post_shadow_list_head);
> > +
> > +	intel_vgpu_init_cfg_space(vgpu, vgpu->param.primary);
> >=20
> >  	ret =3D intel_vgpu_init_mmio(vgpu);
> >  	if (ret)
> >  		goto out_clean_idr;
> >=20
> > -	ret =3D intel_vgpu_alloc_resource(vgpu, param);
> > +	ret =3D intel_vgpu_alloc_resource_count(vgpu);
> >  	if (ret)
> >  		goto out_clean_vgpu_mmio;
> >=20
> > -	populate_pvinfo_page(vgpu);
> > +	if (!delay_res_alloc) {
> > +		ret =3D intel_vgpu_res_alloc(vgpu);
> > +		if (ret)
> > +			goto out_clean_vgpu_mmio;
> > +	}
>=20
> If delayed resource allocation works correctly, why do we still
> need support non-delayed flavor? Even a type doesn't support
> aggregation, it doesn't hurt to do allocation until mdev open...
>

The difference is user expectation I think, if there's really
awareness of this. As original way is to allocate at creat time, so
once created success, resource is guaranteed. But for aggregation type
which could be changed before open, alloc happens at that time which
may have different scenario, e.g might fail caused by other instance
or host. So original idea is to keep old behavior but only change for
aggregation type.

If we think this user expectation is not important, delayed alloc
could help to create vgpu quickly but may have more chance to fail
later..

> >=20
> >  	ret =3D intel_gvt_hypervisor_attach_vgpu(vgpu);
> >  	if (ret)
> >  		goto out_clean_vgpu_resource;
> >=20
> > -	ret =3D intel_vgpu_init_gtt(vgpu);
> > -	if (ret)
> > -		goto out_detach_hypervisor_vgpu;
> > -
> >  	ret =3D intel_vgpu_init_opregion(vgpu);
> >  	if (ret)
> > -		goto out_clean_gtt;
> > +		goto out_detach_hypervisor_vgpu;
> >=20
> > -	ret =3D intel_vgpu_init_display(vgpu, param->resolution);
> > +	ret =3D intel_vgpu_init_display(vgpu, vgpu->param.resolution);
> >  	if (ret)
> >  		goto out_clean_opregion;
> >=20
> > @@ -438,7 +469,7 @@ static struct intel_vgpu
> > *__intel_gvt_create_vgpu(struct intel_gvt *gvt,
> >  	if (ret)
> >  		goto out_clean_sched_policy;
> >=20
> > -	return vgpu;
> > +	return 0;
> >=20
> >  out_clean_sched_policy:
> >  	intel_vgpu_clean_sched_policy(vgpu);
> > @@ -448,19 +479,17 @@ static struct intel_vgpu
> > *__intel_gvt_create_vgpu(struct intel_gvt *gvt,
> >  	intel_vgpu_clean_display(vgpu);
> >  out_clean_opregion:
> >  	intel_vgpu_clean_opregion(vgpu);
> > -out_clean_gtt:
> > -	intel_vgpu_clean_gtt(vgpu);
> >  out_detach_hypervisor_vgpu:
> >  	intel_gvt_hypervisor_detach_vgpu(vgpu);
> >  out_clean_vgpu_resource:
> > +	intel_vgpu_clean_gtt(vgpu);
> >  	intel_vgpu_free_resource(vgpu);
> > +	intel_gvt_update_vgpu_types(vgpu->gvt);
> >  out_clean_vgpu_mmio:
> >  	intel_vgpu_clean_mmio(vgpu);
> >  out_clean_idr:
> >  	idr_remove(&gvt->vgpu_idr, vgpu->id);
> > -out_free_vgpu:
> > -	vfree(vgpu);
> > -	return ERR_PTR(ret);
> > +	return ret;
> >  }
> >=20
> >  /**
> > @@ -474,33 +503,64 @@ static struct intel_vgpu
> > *__intel_gvt_create_vgpu(struct intel_gvt *gvt,
> >   * pointer to intel_vgpu, error pointer if failed.
> >   */
> >  struct intel_vgpu *intel_gvt_create_vgpu(struct intel_gvt *gvt,
> > -				struct intel_vgpu_type *type)
> > +					 struct intel_vgpu_type *type)
> >  {
> > -	struct intel_vgpu_creation_params param;
> >  	struct intel_vgpu *vgpu;
> > +	struct intel_vgpu_creation_params *param;
> > +	int ret;
> > +
> > +	vgpu =3D vzalloc(sizeof(*vgpu));
> > +	if (!vgpu)
> > +		return ERR_PTR(-ENOMEM);
> >=20
> > -	param.handle =3D 0;
> > -	param.primary =3D 1;
> > -	param.low_gm_sz =3D type->low_gm_size;
> > -	param.high_gm_sz =3D type->high_gm_size;
> > -	param.fence_sz =3D type->fence;
> > -	param.weight =3D type->weight;
> > -	param.resolution =3D type->resolution;
> > +	param =3D &vgpu->param;
> > +	param->handle =3D 0;
> > +	param->primary =3D 1;
> > +	param->low_gm_sz =3D type->low_gm_size;
> > +	param->high_gm_sz =3D type->high_gm_size;
> > +	param->fence_sz =3D type->fence;
> > +	param->weight =3D type->weight;
> > +	param->resolution =3D type->resolution;
> >=20
> > -	/* XXX current param based on MB */
> > -	param.low_gm_sz =3D BYTES_TO_MB(param.low_gm_sz);
> > -	param.high_gm_sz =3D BYTES_TO_MB(param.high_gm_sz);
> > +	gvt_dbg_core("handle %llu low %llu MB high %llu MB fence %llu\n",
> > +		     param->handle, BYTES_TO_MB(param->low_gm_sz),
> > +		     BYTES_TO_MB(param->high_gm_sz),
> > +		     param->fence_sz);
> > +
> > +	vgpu->handle =3D param->handle;
> > +	vgpu->gvt =3D gvt;
> > +	vgpu->sched_ctl.weight =3D param->weight;
> > +	param->aggregation =3D 1;
> >=20
> >  	mutex_lock(&gvt->lock);
> > -	vgpu =3D __intel_gvt_create_vgpu(gvt, &param);
> > -	if (!IS_ERR(vgpu))
> > -		/* calculate left instance change for types */
> > -		intel_gvt_update_vgpu_types(gvt);
> > +	ret =3D __intel_gvt_create_vgpu(vgpu, type->aggregation ? true : fals=
e);
> > +	if (ret) {
> > +		mutex_unlock(&gvt->lock);
> > +		vfree(vgpu);
> > +		return ERR_PTR(ret);
> > +	}
> > +	/* calculate left instance change for types */
> > +	intel_gvt_update_vgpu_types(vgpu->gvt);
> >  	mutex_unlock(&gvt->lock);
> >=20
> >  	return vgpu;
> >  }
> >=20
> > +int intel_vgpu_delayed_alloc(struct intel_vgpu *vgpu)
> > +{
> > +	int ret;
> > +
> > +	intel_vgpu_adjust_resource_count(vgpu);
> > +	ret =3D intel_vgpu_res_alloc(vgpu);
> > +	if (ret)
> > +		return -EINVAL;
> > +
> > +	mutex_lock(&vgpu->gvt->lock);
> > +	intel_gvt_update_vgpu_types(vgpu->gvt);
> > +	mutex_unlock(&vgpu->gvt->lock);
> > +	return 0;
> > +}
> > +
> >  /**
> >   * intel_gvt_reset_vgpu_locked - reset a virtual GPU by DMLR or GT res=
et
> >   * @vgpu: virtual GPU
> > --
> > 2.25.1
>=20

--=20
Open Source Technology Center, Intel ltd.

$gpg --keyserver wwwkeys.pgp.net --recv-keys 4D781827

--E6NCJjdg6OUEG/ZU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQTXuabgHDW6LPt9CICxBBozTXgYJwUCXn21XwAKCRCxBBozTXgY
J+u4AKCDUnPhkEmMMxw6WElp2v7gc2I2HgCeLGdQP3Atckn0BCLBbZ9qXsBelMo=
=HuyN
-----END PGP SIGNATURE-----

--E6NCJjdg6OUEG/ZU--
