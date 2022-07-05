Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 828FA5664F1
	for <lists+kvm@lfdr.de>; Tue,  5 Jul 2022 10:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbiGEIW4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jul 2022 04:22:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiGEIWz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jul 2022 04:22:55 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7234CC0;
        Tue,  5 Jul 2022 01:22:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657009373; x=1688545373;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   mime-version:in-reply-to;
  bh=pLJPE5amW45t7KjytqYMCkNNUb0/DrBWhuPvz3hukcw=;
  b=LHAMSBjymqSCQZDSLsMAGdK1n1w7awkzHoZR5BY9vtCzULPZjcWeDMqH
   RW0SAvzwEg6EYJKSYLzJoLYqeEqLG/ATbrVNzB89kFVDBBhNwGQsrLYBn
   shqQuO3xAsUWSC6Lox/mpOKNExyDWd+sWXB9MTHamKa9QDSkGsFJCHZxr
   vLoJNr9yzvi7i24tfVnzQDe8N3Qwg2Db+mr9iRZfuLkDJzGkSHMV1ckDp
   r6tnXkRseH+RQiwfxz0RFOfAAk40ygAuW8MUEjDGb7YU9GrK0EwAEeChn
   noSoXS+pDKECUxcrOChC4T4lPhN1+DCyVaCKU9Dkjpcy1XhcPF0FN/Swj
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10398"; a="282046677"
X-IronPort-AV: E=Sophos;i="5.92,245,1650956400"; 
   d="asc'?scan'208";a="282046677"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2022 01:22:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,245,1650956400"; 
   d="asc'?scan'208";a="619724208"
Received: from zhen-hp.sh.intel.com (HELO zhen-hp) ([10.239.159.108])
  by orsmga008.jf.intel.com with ESMTP; 05 Jul 2022 01:22:49 -0700
Date:   Tue, 5 Jul 2022 15:59:38 +0800
From:   Zhenyu Wang <zhenyuw@linux.intel.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org
Subject: Re: [PATCH 02/14] drm/i915/gvt: simplify vgpu configuration
 management
Message-ID: <20220705075938.GW1089@zhen-hp.sh.intel.com>
Reply-To: Zhenyu Wang <zhenyuw@linux.intel.com>
References: <20220704125144.157288-1-hch@lst.de>
 <20220704125144.157288-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="3gk1bTGVZuaU9V5/"
Content-Disposition: inline
In-Reply-To: <20220704125144.157288-3-hch@lst.de>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--3gk1bTGVZuaU9V5/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2022.07.04 14:51:32 +0200, Christoph Hellwig wrote:
> Instead of copying the information from the vgpu_types arrays into each
> intel_vgpu_type structure, just reference this constant information
> with a pointer to the already existing data structure, and pass it into
> the low-level VGPU creation helpers intead of copying the data into yet
> anothe params data structure.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Looks fine to me. We still carry some legacy codes like vgpu create param
originally used for other hypervisor. Thanks for cleaning this up!

Reviewed-by: Zhenyu Wang <zhenyuw@linux.intel.com>

>  drivers/gpu/drm/i915/gvt/aperture_gm.c |  20 +--
>  drivers/gpu/drm/i915/gvt/gvt.h         |  36 +++---
>  drivers/gpu/drm/i915/gvt/kvmgt.c       |  10 +-
>  drivers/gpu/drm/i915/gvt/vgpu.c        | 172 +++++++++----------------
>  4 files changed, 91 insertions(+), 147 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/i915/gvt/aperture_gm.c b/drivers/gpu/drm/i91=
5/gvt/aperture_gm.c
> index 557f3314291a8..7dd8163f8a569 100644
> --- a/drivers/gpu/drm/i915/gvt/aperture_gm.c
> +++ b/drivers/gpu/drm/i915/gvt/aperture_gm.c
> @@ -240,13 +240,13 @@ static void free_resource(struct intel_vgpu *vgpu)
>  }
> =20
>  static int alloc_resource(struct intel_vgpu *vgpu,
> -		struct intel_vgpu_creation_params *param)
> +		const struct intel_vgpu_config *conf)
>  {
>  	struct intel_gvt *gvt =3D vgpu->gvt;
>  	unsigned long request, avail, max, taken;
>  	const char *item;
> =20
> -	if (!param->low_gm_sz || !param->high_gm_sz || !param->fence_sz) {
> +	if (!conf->low_mm || !conf->high_mm || !conf->fence) {
>  		gvt_vgpu_err("Invalid vGPU creation params\n");
>  		return -EINVAL;
>  	}
> @@ -255,7 +255,7 @@ static int alloc_resource(struct intel_vgpu *vgpu,
>  	max =3D gvt_aperture_sz(gvt) - HOST_LOW_GM_SIZE;
>  	taken =3D gvt->gm.vgpu_allocated_low_gm_size;
>  	avail =3D max - taken;
> -	request =3D MB_TO_BYTES(param->low_gm_sz);
> +	request =3D conf->low_mm;
> =20
>  	if (request > avail)
>  		goto no_enough_resource;
> @@ -266,7 +266,7 @@ static int alloc_resource(struct intel_vgpu *vgpu,
>  	max =3D gvt_hidden_sz(gvt) - HOST_HIGH_GM_SIZE;
>  	taken =3D gvt->gm.vgpu_allocated_high_gm_size;
>  	avail =3D max - taken;
> -	request =3D MB_TO_BYTES(param->high_gm_sz);
> +	request =3D conf->high_mm;
> =20
>  	if (request > avail)
>  		goto no_enough_resource;
> @@ -277,16 +277,16 @@ static int alloc_resource(struct intel_vgpu *vgpu,
>  	max =3D gvt_fence_sz(gvt) - HOST_FENCE;
>  	taken =3D gvt->fence.vgpu_allocated_fence_num;
>  	avail =3D max - taken;
> -	request =3D param->fence_sz;
> +	request =3D conf->fence;
> =20
>  	if (request > avail)
>  		goto no_enough_resource;
> =20
>  	vgpu_fence_sz(vgpu) =3D request;
> =20
> -	gvt->gm.vgpu_allocated_low_gm_size +=3D MB_TO_BYTES(param->low_gm_sz);
> -	gvt->gm.vgpu_allocated_high_gm_size +=3D MB_TO_BYTES(param->high_gm_sz);
> -	gvt->fence.vgpu_allocated_fence_num +=3D param->fence_sz;
> +	gvt->gm.vgpu_allocated_low_gm_size +=3D conf->low_mm;
> +	gvt->gm.vgpu_allocated_high_gm_size +=3D conf->high_mm;
> +	gvt->fence.vgpu_allocated_fence_num +=3D conf->fence;
>  	return 0;
> =20
>  no_enough_resource:
> @@ -340,11 +340,11 @@ void intel_vgpu_reset_resource(struct intel_vgpu *v=
gpu)
>   *
>   */
>  int intel_vgpu_alloc_resource(struct intel_vgpu *vgpu,
> -		struct intel_vgpu_creation_params *param)
> +		const struct intel_vgpu_config *conf)
>  {
>  	int ret;
> =20
> -	ret =3D alloc_resource(vgpu, param);
> +	ret =3D alloc_resource(vgpu, conf);
>  	if (ret)
>  		return ret;
> =20
> diff --git a/drivers/gpu/drm/i915/gvt/gvt.h b/drivers/gpu/drm/i915/gvt/gv=
t.h
> index aee1a45da74bc..392c2ad49d376 100644
> --- a/drivers/gpu/drm/i915/gvt/gvt.h
> +++ b/drivers/gpu/drm/i915/gvt/gvt.h
> @@ -295,15 +295,26 @@ struct intel_gvt_firmware {
>  	bool firmware_loaded;
>  };
> =20
> +struct intel_vgpu_config {
> +	unsigned int low_mm;
> +	unsigned int high_mm;
> +	unsigned int fence;
> +
> +	/*
> +	 * A vGPU with a weight of 8 will get twice as much GPU as a vGPU with
> +	 * a weight of 4 on a contended host, different vGPU type has different
> +	 * weight set. Legal weights range from 1 to 16.
> +	 */
> +	unsigned int weight;
> +	enum intel_vgpu_edid edid;
> +	const char *name;
> +};
> +
>  #define NR_MAX_INTEL_VGPU_TYPES 20
>  struct intel_vgpu_type {
>  	char name[16];
> +	const struct intel_vgpu_config *conf;
>  	unsigned int avail_instance;
> -	unsigned int low_gm_size;
> -	unsigned int high_gm_size;
> -	unsigned int fence;
> -	unsigned int weight;
> -	enum intel_vgpu_edid resolution;
>  };
> =20
>  struct intel_gvt {
> @@ -437,19 +448,8 @@ int intel_gvt_load_firmware(struct intel_gvt *gvt);
>  /* ring context size i.e. the first 0x50 dwords*/
>  #define RING_CTX_SIZE 320
> =20
> -struct intel_vgpu_creation_params {
> -	__u64 low_gm_sz;  /* in MB */
> -	__u64 high_gm_sz; /* in MB */
> -	__u64 fence_sz;
> -	__u64 resolution;
> -	__s32 primary;
> -	__u64 vgpu_id;
> -
> -	__u32 weight;
> -};
> -
>  int intel_vgpu_alloc_resource(struct intel_vgpu *vgpu,
> -			      struct intel_vgpu_creation_params *param);
> +			      const struct intel_vgpu_config *conf);
>  void intel_vgpu_reset_resource(struct intel_vgpu *vgpu);
>  void intel_vgpu_free_resource(struct intel_vgpu *vgpu);
>  void intel_vgpu_write_fence(struct intel_vgpu *vgpu,
> @@ -496,7 +496,7 @@ void intel_gvt_clean_vgpu_types(struct intel_gvt *gvt=
);
>  struct intel_vgpu *intel_gvt_create_idle_vgpu(struct intel_gvt *gvt);
>  void intel_gvt_destroy_idle_vgpu(struct intel_vgpu *vgpu);
>  struct intel_vgpu *intel_gvt_create_vgpu(struct intel_gvt *gvt,
> -					 struct intel_vgpu_type *type);
> +		const struct intel_vgpu_config *conf);
>  void intel_gvt_destroy_vgpu(struct intel_vgpu *vgpu);
>  void intel_gvt_release_vgpu(struct intel_vgpu *vgpu);
>  void intel_gvt_reset_vgpu_locked(struct intel_vgpu *vgpu, bool dmlr,
> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/=
kvmgt.c
> index e2f6c56ab3420..7b060c0e66ae7 100644
> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> @@ -151,10 +151,10 @@ static ssize_t description_show(struct mdev_type *m=
type,
>  	return sprintf(buf, "low_gm_size: %dMB\nhigh_gm_size: %dMB\n"
>  		       "fence: %d\nresolution: %s\n"
>  		       "weight: %d\n",
> -		       BYTES_TO_MB(type->low_gm_size),
> -		       BYTES_TO_MB(type->high_gm_size),
> -		       type->fence, vgpu_edid_str(type->resolution),
> -		       type->weight);
> +		       BYTES_TO_MB(type->conf->low_mm),
> +		       BYTES_TO_MB(type->conf->high_mm),
> +		       type->conf->fence, vgpu_edid_str(type->conf->edid),
> +		       type->conf->weight);
>  }
> =20
>  static ssize_t name_show(struct mdev_type *mtype,
> @@ -1624,7 +1624,7 @@ static int intel_vgpu_probe(struct mdev_device *mde=
v)
>  	if (!type)
>  		return -EINVAL;
> =20
> -	vgpu =3D intel_gvt_create_vgpu(gvt, type);
> +	vgpu =3D intel_gvt_create_vgpu(gvt, type->conf);
>  	if (IS_ERR(vgpu)) {
>  		gvt_err("failed to create intel vgpu: %ld\n", PTR_ERR(vgpu));
>  		return PTR_ERR(vgpu);
> diff --git a/drivers/gpu/drm/i915/gvt/vgpu.c b/drivers/gpu/drm/i915/gvt/v=
gpu.c
> index 5c828556cefd7..8e136dcc70112 100644
> --- a/drivers/gpu/drm/i915/gvt/vgpu.c
> +++ b/drivers/gpu/drm/i915/gvt/vgpu.c
> @@ -73,24 +73,21 @@ void populate_pvinfo_page(struct intel_vgpu *vgpu)
>  	drm_WARN_ON(&i915->drm, sizeof(struct vgt_if) !=3D VGT_PVINFO_SIZE);
>  }
> =20
> +/*
> + * vGPU type name is defined as GVTg_Vx_y which contains the physical GPU
> + * generation type (e.g V4 as BDW server, V5 as SKL server).
> + *
> + * Depening on the physical SKU resource, we might see vGPU types like
> + * GVTg_V4_8, GVTg_V4_4, GVTg_V4_2, etc. We can create different types of
> + * vGPU on same physical GPU depending on available resource. Each vGPU
> + * type will have a different number of avail_instance to indicate how
> + * many vGPU instance can be created for this type.
> + */
>  #define VGPU_MAX_WEIGHT 16
>  #define VGPU_WEIGHT(vgpu_num)	\
>  	(VGPU_MAX_WEIGHT / (vgpu_num))
> =20
> -static const struct {
> -	unsigned int low_mm;
> -	unsigned int high_mm;
> -	unsigned int fence;
> -
> -	/* A vGPU with a weight of 8 will get twice as much GPU as a vGPU
> -	 * with a weight of 4 on a contended host, different vGPU type has
> -	 * different weight set. Legal weights range from 1 to 16.
> -	 */
> -	unsigned int weight;
> -	enum intel_vgpu_edid edid;
> -	const char *name;
> -} vgpu_types[] =3D {
> -/* Fixed vGPU type table */
> +static const struct intel_vgpu_config intel_vgpu_configs[] =3D {
>  	{ MB_TO_BYTES(64), MB_TO_BYTES(384), 4, VGPU_WEIGHT(8), GVT_EDID_1024_7=
68, "8" },
>  	{ MB_TO_BYTES(128), MB_TO_BYTES(512), 4, VGPU_WEIGHT(4), GVT_EDID_1920_=
1200, "4" },
>  	{ MB_TO_BYTES(256), MB_TO_BYTES(1024), 4, VGPU_WEIGHT(2), GVT_EDID_1920=
_1200, "2" },
> @@ -106,63 +103,34 @@ static const struct {
>   */
>  int intel_gvt_init_vgpu_types(struct intel_gvt *gvt)
>  {
> -	unsigned int num_types;
> -	unsigned int i, low_avail, high_avail;
> -	unsigned int min_low;
> -
> -	/* vGPU type name is defined as GVTg_Vx_y which contains
> -	 * physical GPU generation type (e.g V4 as BDW server, V5 as
> -	 * SKL server).
> -	 *
> -	 * Depend on physical SKU resource, might see vGPU types like
> -	 * GVTg_V4_8, GVTg_V4_4, GVTg_V4_2, etc. We can create
> -	 * different types of vGPU on same physical GPU depending on
> -	 * available resource. Each vGPU type will have "avail_instance"
> -	 * to indicate how many vGPU instance can be created for this
> -	 * type.
> -	 *
> -	 */
> -	low_avail =3D gvt_aperture_sz(gvt) - HOST_LOW_GM_SIZE;
> -	high_avail =3D gvt_hidden_sz(gvt) - HOST_HIGH_GM_SIZE;
> -	num_types =3D ARRAY_SIZE(vgpu_types);
> +	unsigned int low_avail =3D gvt_aperture_sz(gvt) - HOST_LOW_GM_SIZE;
> +	unsigned int high_avail =3D gvt_hidden_sz(gvt) - HOST_HIGH_GM_SIZE;
> +	unsigned int num_types =3D ARRAY_SIZE(intel_vgpu_configs);
> +	unsigned int i;
> =20
>  	gvt->types =3D kcalloc(num_types, sizeof(struct intel_vgpu_type),
>  			     GFP_KERNEL);
>  	if (!gvt->types)
>  		return -ENOMEM;
> =20
> -	min_low =3D MB_TO_BYTES(32);
>  	for (i =3D 0; i < num_types; ++i) {
> -		if (low_avail / vgpu_types[i].low_mm =3D=3D 0)
> -			break;
> -
> -		gvt->types[i].low_gm_size =3D vgpu_types[i].low_mm;
> -		gvt->types[i].high_gm_size =3D vgpu_types[i].high_mm;
> -		gvt->types[i].fence =3D vgpu_types[i].fence;
> +		const struct intel_vgpu_config *conf =3D &intel_vgpu_configs[i];
> =20
> -		if (vgpu_types[i].weight < 1 ||
> -					vgpu_types[i].weight > VGPU_MAX_WEIGHT)
> +		if (low_avail / conf->low_mm =3D=3D 0)
> +			break;
> +		if (conf->weight < 1 || conf->weight > VGPU_MAX_WEIGHT)
>  			goto out_free_types;
> =20
> -		gvt->types[i].weight =3D vgpu_types[i].weight;
> -		gvt->types[i].resolution =3D vgpu_types[i].edid;
> -		gvt->types[i].avail_instance =3D min(low_avail / vgpu_types[i].low_mm,
> -						   high_avail / vgpu_types[i].high_mm);
> -
> -		if (GRAPHICS_VER(gvt->gt->i915) =3D=3D 8)
> -			sprintf(gvt->types[i].name, "GVTg_V4_%s",
> -				vgpu_types[i].name);
> -		else if (GRAPHICS_VER(gvt->gt->i915) =3D=3D 9)
> -			sprintf(gvt->types[i].name, "GVTg_V5_%s",
> -				vgpu_types[i].name);
> +		sprintf(gvt->types[i].name, "GVTg_V%u_%s",
> +			GRAPHICS_VER(gvt->gt->i915) =3D=3D 8 ? 4 : 5, conf->name);
> +		gvt->types->conf =3D conf;
> +		gvt->types[i].avail_instance =3D min(low_avail / conf->low_mm,
> +						   high_avail / conf->high_mm);
> =20
>  		gvt_dbg_core("type[%d]: %s avail %u low %u high %u fence %u weight %u =
res %s\n",
> -			     i, gvt->types[i].name,
> -			     gvt->types[i].avail_instance,
> -			     gvt->types[i].low_gm_size,
> -			     gvt->types[i].high_gm_size, gvt->types[i].fence,
> -			     gvt->types[i].weight,
> -			     vgpu_edid_str(gvt->types[i].resolution));
> +			     i, gvt->types[i].name, gvt->types[i].avail_instance,
> +			     conf->low_mm, conf->high_mm, conf->fence,
> +			     conf->weight, vgpu_edid_str(conf->edid));
>  	}
> =20
>  	gvt->num_types =3D i;
> @@ -195,16 +163,16 @@ static void intel_gvt_update_vgpu_types(struct inte=
l_gvt *gvt)
>  		gvt->fence.vgpu_allocated_fence_num;
> =20
>  	for (i =3D 0; i < gvt->num_types; i++) {
> -		low_gm_min =3D low_gm_avail / gvt->types[i].low_gm_size;
> -		high_gm_min =3D high_gm_avail / gvt->types[i].high_gm_size;
> -		fence_min =3D fence_avail / gvt->types[i].fence;
> +		low_gm_min =3D low_gm_avail / gvt->types[i].conf->low_mm;
> +		high_gm_min =3D high_gm_avail / gvt->types[i].conf->high_mm;
> +		fence_min =3D fence_avail / gvt->types[i].conf->fence;
>  		gvt->types[i].avail_instance =3D min(min(low_gm_min, high_gm_min),
>  						   fence_min);
> =20
>  		gvt_dbg_core("update type[%d]: %s avail %u low %u high %u fence %u\n",
>  		       i, gvt->types[i].name,
> -		       gvt->types[i].avail_instance, gvt->types[i].low_gm_size,
> -		       gvt->types[i].high_gm_size, gvt->types[i].fence);
> +		       gvt->types[i].avail_instance, gvt->types[i].conf->low_mm,
> +		       gvt->types[i].conf->high_mm, gvt->types[i].conf->fence);
>  	}
>  }
> =20
> @@ -367,42 +335,53 @@ void intel_gvt_destroy_idle_vgpu(struct intel_vgpu =
*vgpu)
>  	vfree(vgpu);
>  }
> =20
> -static struct intel_vgpu *__intel_gvt_create_vgpu(struct intel_gvt *gvt,
> -		struct intel_vgpu_creation_params *param)
> +/**
> + * intel_gvt_create_vgpu - create a virtual GPU
> + * @gvt: GVT device
> + * @conf: type of the vGPU to create
> + *
> + * This function is called when user wants to create a virtual GPU.
> + *
> + * Returns:
> + * pointer to intel_vgpu, error pointer if failed.
> + */
> +struct intel_vgpu *intel_gvt_create_vgpu(struct intel_gvt *gvt,
> +		const struct intel_vgpu_config *conf)
>  {
>  	struct drm_i915_private *dev_priv =3D gvt->gt->i915;
>  	struct intel_vgpu *vgpu;
>  	int ret;
> =20
> -	gvt_dbg_core("low %llu MB high %llu MB fence %llu\n",
> -			param->low_gm_sz, param->high_gm_sz,
> -			param->fence_sz);
> +	gvt_dbg_core("low %u MB high %u MB fence %u\n",
> +			BYTES_TO_MB(conf->low_mm), BYTES_TO_MB(conf->high_mm),
> +			conf->fence);
> =20
>  	vgpu =3D vzalloc(sizeof(*vgpu));
>  	if (!vgpu)
>  		return ERR_PTR(-ENOMEM);
> =20
> +	mutex_lock(&gvt->lock);
>  	ret =3D idr_alloc(&gvt->vgpu_idr, vgpu, IDLE_VGPU_IDR + 1, GVT_MAX_VGPU,
>  		GFP_KERNEL);
>  	if (ret < 0)
> -		goto out_free_vgpu;
> +		goto out_unlock;;
> =20
>  	vgpu->id =3D ret;
>  	vgpu->gvt =3D gvt;
> -	vgpu->sched_ctl.weight =3D param->weight;
> +	vgpu->sched_ctl.weight =3D conf->weight;
>  	mutex_init(&vgpu->vgpu_lock);
>  	mutex_init(&vgpu->dmabuf_lock);
>  	INIT_LIST_HEAD(&vgpu->dmabuf_obj_list_head);
>  	INIT_RADIX_TREE(&vgpu->page_track_tree, GFP_KERNEL);
>  	idr_init_base(&vgpu->object_idr, 1);
> -	intel_vgpu_init_cfg_space(vgpu, param->primary);
> +	intel_vgpu_init_cfg_space(vgpu, 1);
>  	vgpu->d3_entered =3D false;
> =20
>  	ret =3D intel_vgpu_init_mmio(vgpu);
>  	if (ret)
>  		goto out_clean_idr;
> =20
> -	ret =3D intel_vgpu_alloc_resource(vgpu, param);
> +	ret =3D intel_vgpu_alloc_resource(vgpu, conf);
>  	if (ret)
>  		goto out_clean_vgpu_mmio;
> =20
> @@ -416,7 +395,7 @@ static struct intel_vgpu *__intel_gvt_create_vgpu(str=
uct intel_gvt *gvt,
>  	if (ret)
>  		goto out_clean_gtt;
> =20
> -	ret =3D intel_vgpu_init_display(vgpu, param->resolution);
> +	ret =3D intel_vgpu_init_display(vgpu, conf->edid);
>  	if (ret)
>  		goto out_clean_opregion;
> =20
> @@ -441,6 +420,9 @@ static struct intel_vgpu *__intel_gvt_create_vgpu(str=
uct intel_gvt *gvt,
>  	if (ret)
>  		goto out_clean_sched_policy;
> =20
> +	intel_gvt_update_vgpu_types(gvt);
> +	intel_gvt_update_reg_whitelist(vgpu);
> +	mutex_unlock(&gvt->lock);
>  	return vgpu;
> =20
>  out_clean_sched_policy:
> @@ -459,50 +441,12 @@ static struct intel_vgpu *__intel_gvt_create_vgpu(s=
truct intel_gvt *gvt,
>  	intel_vgpu_clean_mmio(vgpu);
>  out_clean_idr:
>  	idr_remove(&gvt->vgpu_idr, vgpu->id);
> -out_free_vgpu:
> +out_unlock:
> +	mutex_unlock(&gvt->lock);
>  	vfree(vgpu);
>  	return ERR_PTR(ret);
>  }
> =20
> -/**
> - * intel_gvt_create_vgpu - create a virtual GPU
> - * @gvt: GVT device
> - * @type: type of the vGPU to create
> - *
> - * This function is called when user wants to create a virtual GPU.
> - *
> - * Returns:
> - * pointer to intel_vgpu, error pointer if failed.
> - */
> -struct intel_vgpu *intel_gvt_create_vgpu(struct intel_gvt *gvt,
> -				struct intel_vgpu_type *type)
> -{
> -	struct intel_vgpu_creation_params param;
> -	struct intel_vgpu *vgpu;
> -
> -	param.primary =3D 1;
> -	param.low_gm_sz =3D type->low_gm_size;
> -	param.high_gm_sz =3D type->high_gm_size;
> -	param.fence_sz =3D type->fence;
> -	param.weight =3D type->weight;
> -	param.resolution =3D type->resolution;
> -
> -	/* XXX current param based on MB */
> -	param.low_gm_sz =3D BYTES_TO_MB(param.low_gm_sz);
> -	param.high_gm_sz =3D BYTES_TO_MB(param.high_gm_sz);
> -
> -	mutex_lock(&gvt->lock);
> -	vgpu =3D __intel_gvt_create_vgpu(gvt, &param);
> -	if (!IS_ERR(vgpu)) {
> -		/* calculate left instance change for types */
> -		intel_gvt_update_vgpu_types(gvt);
> -		intel_gvt_update_reg_whitelist(vgpu);
> -	}
> -	mutex_unlock(&gvt->lock);
> -
> -	return vgpu;
> -}
> -
>  /**
>   * intel_gvt_reset_vgpu_locked - reset a virtual GPU by DMLR or GT reset
>   * @vgpu: virtual GPU
> --=20
> 2.30.2
>=20

--3gk1bTGVZuaU9V5/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQTXuabgHDW6LPt9CICxBBozTXgYJwUCYsPvZAAKCRCxBBozTXgY
J7N0AJ9sb59B6vyQwYf18zlZJvih4Icy/gCgnBn2KjzU8mI0MmzQEK+qtl2lr8c=
=GsJr
-----END PGP SIGNATURE-----

--3gk1bTGVZuaU9V5/--
