Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5390B642161
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 03:08:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbiLECIr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Dec 2022 21:08:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbiLECIp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 4 Dec 2022 21:08:45 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8FD71263E;
        Sun,  4 Dec 2022 18:08:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670206124; x=1701742124;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   mime-version:in-reply-to;
  bh=Uwb0j0vOSLTTI1yh+/S8G5w86vEZ102AbpppaI2wcK8=;
  b=Q5pMd1DyjTQg+tjoqnIluCjVH/XQDK4IfVdxI2+6CIZi6vhL+onXFV5S
   aPfC3159xUTGNwP+m/eoItS5xv2rFjmG1e00tnQIztgFnRi9DF7e1xFyU
   RVnF7XsX8mw/JkCzlYxlBdx3BUep1V/H9Cfx43/OEodzdVJAU+Y/bu3/+
   +brtgexhcpPIdT2lgZHimTGUIS/StwvbABGofBRZqc1D5cZQcwXajFLVZ
   n3YDABmUKkJsCIPFzd0nlbHn6r3LRIToWg8iKCFDE4UD6RebXFIk4dmLV
   f72UYGqNrxEBhipOqmAZ+bOGyZQAZIYf2Sbi2oGR0DteVvbCtgNwudnh6
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10551"; a="343232989"
X-IronPort-AV: E=Sophos;i="5.96,218,1665471600"; 
   d="asc'?scan'208";a="343232989"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2022 18:08:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10551"; a="596028083"
X-IronPort-AV: E=Sophos;i="5.96,218,1665471600"; 
   d="asc'?scan'208";a="596028083"
Received: from zhen-hp.sh.intel.com (HELO zhen-hp) ([10.239.159.108])
  by orsmga003.jf.intel.com with ESMTP; 04 Dec 2022 18:08:32 -0800
Date:   Mon, 5 Dec 2022 10:07:08 +0800
From:   Zhenyu Wang <zhenyuw@linux.intel.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     jgg@nvidia.com, alex.williamson@redhat.com, kevin.tian@intel.com,
        kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        intel-gvt-dev@lists.freedesktop.org, linux-s390@vger.kernel.org,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>
Subject: Re: [[iommufd] PATCH v3 1/2] i915/gvt: Move gvt mapping cache
 initialization to intel_vgpu_init_dev()
Message-ID: <20221205020708.GA30028@zhen-hp.sh.intel.com>
Reply-To: Zhenyu Wang <zhenyuw@linux.intel.com>
References: <20221202135402.756470-1-yi.l.liu@intel.com>
 <20221202135402.756470-2-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="f6M9UaX53EEZorp0"
Content-Disposition: inline
In-Reply-To: <20221202135402.756470-2-yi.l.liu@intel.com>
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--f6M9UaX53EEZorp0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2022.12.02 05:54:01 -0800, Yi Liu wrote:
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
>  drivers/gpu/drm/i915/gvt/kvmgt.c | 18 ++++++++++++++----
>  1 file changed, 14 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/=
kvmgt.c
> index 7a45e5360caf..aaf0d9e8da95 100644
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
> @@ -718,6 +715,11 @@ static void intel_vgpu_close_device(struct vfio_devi=
ce *vfio_dev)
>  	kvmgt_protect_table_destroy(vgpu);
>  	gvt_cache_destroy(vgpu);
> =20
> +	WARN_ON(vgpu->nr_cache_entries);
> +
> +	vgpu->gfn_cache =3D RB_ROOT;
> +	vgpu->dma_addr_cache =3D RB_ROOT;
> +
>  	intel_vgpu_release_msi_eventfd_ctx(vgpu);
> =20
>  	vgpu->attached =3D false;
> @@ -1451,9 +1453,17 @@ static int intel_vgpu_init_dev(struct vfio_device =
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
>  }
> =20
>  static void intel_vgpu_release_dev(struct vfio_device *vfio_dev)
> --=20

Reviewed-by: Zhenyu Wang <zhenyuw@linux.intel.com>

thanks!

--f6M9UaX53EEZorp0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQTXuabgHDW6LPt9CICxBBozTXgYJwUCY41SRgAKCRCxBBozTXgY
Jz/rAKCf2XCkaQP0WhdwmGPDUwLtuGdwAgCfekY0SY9P43VoLP1yapxS6J6QSro=
=Ndmv
-----END PGP SIGNATURE-----

--f6M9UaX53EEZorp0--
