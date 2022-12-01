Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0A2463E850
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 04:26:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbiLAD0w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 22:26:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiLAD0v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 22:26:51 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 964EC8566C;
        Wed, 30 Nov 2022 19:26:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669865210; x=1701401210;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   mime-version:in-reply-to;
  bh=7nbjREN26b8BCZeWqHnldDfC158pG0LFAqEqHseJNco=;
  b=VHrMLjRh6i2APUdEZvZSdGUduSSApXpT5g/zMua5o/4DNOboe+M7Aocx
   tdD/7rNRwWJOVjvLYeABrjdbK9vzVD6e4cg0EQqOtJVQmmysjiXUUhng3
   V7fNJ9EHUsu0n0ig62RGWYSoEbvNXYBQByk8wTSctseq43CeKgKOnJ5h/
   GFLhXjszYuOtQb6gglF55wzxt7D9BwY1w5ukMm4ZilYhd/FfoLTHxJNr4
   Q5ttADSAKznr85+FJsyzUf2MZKjupxbmqHH7XHCoS7Zk/wcWcS6zw5kr3
   Bul48y/ycJdV4P9lWoXnPqZ5mDqZrZtp8rbI9hbotOV8BwaybE6VEMa+j
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="342499514"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="asc'?scan'208";a="342499514"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 19:26:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="707902217"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="asc'?scan'208";a="707902217"
Received: from zhen-hp.sh.intel.com (HELO zhen-hp) ([10.239.159.108])
  by fmsmga008.fm.intel.com with ESMTP; 30 Nov 2022 19:26:47 -0800
Date:   Thu, 1 Dec 2022 11:25:31 +0800
From:   Zhenyu Wang <zhenyuw@linux.intel.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     jgg@nvidia.com, alex.williamson@redhat.com, kevin.tian@intel.com,
        kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        intel-gvt-dev@lists.freedesktop.org, linux-s390@vger.kernel.org,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>
Subject: Re: [[RESEND] iommufd PATCH v2 1/2] i915/gvt: Move gvt mapping cache
 initialization to intel_vgpu_init_dev()
Message-ID: <20221201032531.GY30028@zhen-hp.sh.intel.com>
Reply-To: Zhenyu Wang <zhenyuw@linux.intel.com>
References: <20221129105831.466954-1-yi.l.liu@intel.com>
 <20221129105831.466954-2-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="3sseE1tnmEs+TkKq"
Content-Disposition: inline
In-Reply-To: <20221129105831.466954-2-yi.l.liu@intel.com>
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--3sseE1tnmEs+TkKq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2022.11.29 02:58:30 -0800, Yi Liu wrote:
> vfio container registers .dma_unmap() callback after the device is opened.
> So it's fine for mdev drivers to initialize internal mapping cache in
> .open_device(). See vfio_device_container_register().
>=20
> Now with iommufd an access ops with an unmap callback is registered
> when the device is bound to iommufd which is before .open_device()
> is called. This implies gvt's .dma_unmap() could be called before its
> internal mapping cache is initialized.
>=20
> The fix is moving gvt mapping cache initialization to vGPU init. While
> at it also move ptable initialization together.
>=20
> Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
> Cc: Zhi Wang <zhi.a.wang@intel.com>
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: intel-gvt-dev@lists.freedesktop.org
> Reviewed-by: Zhi Wang <zhi.a.wang@intel.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/gpu/drm/i915/gvt/kvmgt.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/=
kvmgt.c
> index 7a45e5360caf..f563e5dbe66f 100644
> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> @@ -671,9 +671,6 @@ static int intel_vgpu_open_device(struct vfio_device =
*vfio_dev)
> =20
>  	vgpu->attached =3D true;
> =20
> -	kvmgt_protect_table_init(vgpu);
> -	gvt_cache_init(vgpu);
> -
>  	vgpu->track_node.track_write =3D kvmgt_page_track_write;
>  	vgpu->track_node.track_flush_slot =3D kvmgt_page_track_flush_slot;
>  	kvm_page_track_register_notifier(vgpu->vfio_device.kvm,
> @@ -1451,9 +1448,17 @@ static int intel_vgpu_init_dev(struct vfio_device =
*vfio_dev)
>  	struct intel_vgpu *vgpu =3D vfio_dev_to_vgpu(vfio_dev);
>  	struct intel_vgpu_type *type =3D
>  		container_of(mdev->type, struct intel_vgpu_type, type);
> +	int ret;
> =20
>  	vgpu->gvt =3D kdev_to_i915(mdev->type->parent->dev)->gvt;
> -	return intel_gvt_create_vgpu(vgpu, type->conf);
> +	ret =3D intel_gvt_create_vgpu(vgpu, type->conf);
> +	if (ret)
> +		return ret;
> +
> +	kvmgt_protect_table_init(vgpu);
> +	gvt_cache_init(vgpu);
> +
> +	return 0;

I'm fine with this change, but could we add some sanity check at close
time to ensure we clean up any internal cache? Btw, do we need to reset
rbtree root pointer?

>  }
> =20
>  static void intel_vgpu_release_dev(struct vfio_device *vfio_dev)
> --=20
> 2.34.1
>=20

--3sseE1tnmEs+TkKq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQTXuabgHDW6LPt9CICxBBozTXgYJwUCY4gepQAKCRCxBBozTXgY
J+mBAKCbwq9UB5XgOvbpJDgrbYqOsyjctACeKm5g3fFn7aTntBIDdUtyQ26LRmI=
=/q3L
-----END PGP SIGNATURE-----

--3sseE1tnmEs+TkKq--
