Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 684EA55D78E
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343972AbiF1Ikv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 04:40:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343976AbiF1Ikt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 04:40:49 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E96F02C640;
        Tue, 28 Jun 2022 01:40:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656405648; x=1687941648;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   mime-version:in-reply-to;
  bh=1Tgdz4FPq/Kbs1ys+mOYQECaWJi1Szc24CrwfxeyUAY=;
  b=AJG6UIJi7GwdFWUit4yg/KFyroYVpEToZNcNk5xJ/moAYtP3ERgpuTwu
   7Nmx9zXYrj7zPYY7pkCo7vaDVlEBJpNoUnUzRAvJZAicpy/RooiKQbA/b
   yfIrcOlf3sbUMX7H/S3uFPbXCZ3nWM7VQNHAiAncr5VKWTRiWnfRz/9D+
   ocaLpbzm8Pdl0NgNoik/biH9pOeZaP7xsCFGTx6h7W6fOmTabsRhNI5CI
   Bo3LXU0l2+U0tWvtrmryd89+CWxG8HvP2mfx2nf4zpBHpewUED1dJNI/I
   H4r4AvQTZrwfoM6tDay9Ip1JvOYYUcQc4nAp9MLw5oQoQH2Liod7+x+9n
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="345674667"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="asc'?scan'208";a="345674667"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 01:40:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="asc'?scan'208";a="646820987"
Received: from zhen-hp.sh.intel.com (HELO zhen-hp) ([10.239.159.108])
  by fmsmga008.fm.intel.com with ESMTP; 28 Jun 2022 01:40:45 -0700
Date:   Tue, 28 Jun 2022 16:17:49 +0800
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
        linux-s390@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
        Kevin Tian <kevin.tian@intel.com>
Subject: Re: [PATCH 01/13] drm/i915/gvt: fix a memory leak in
 intel_gvt_init_vgpu_types
Message-ID: <20220628081749.GJ1089@zhen-hp.sh.intel.com>
Reply-To: Zhenyu Wang <zhenyuw@linux.intel.com>
References: <20220628051435.695540-1-hch@lst.de>
 <20220628051435.695540-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="YzdYn+D7cUqe+VA3"
Content-Disposition: inline
In-Reply-To: <20220628051435.695540-2-hch@lst.de>
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--YzdYn+D7cUqe+VA3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2022.06.28 07:14:23 +0200, Christoph Hellwig wrote:
> gvt->types needs to be freed on error.
>=20
> Reported-by: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/gpu/drm/i915/gvt/vgpu.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/gpu/drm/i915/gvt/vgpu.c b/drivers/gpu/drm/i915/gvt/v=
gpu.c
> index 46da19b3225d2..5c828556cefd7 100644
> --- a/drivers/gpu/drm/i915/gvt/vgpu.c
> +++ b/drivers/gpu/drm/i915/gvt/vgpu.c
> @@ -142,7 +142,7 @@ int intel_gvt_init_vgpu_types(struct intel_gvt *gvt)
> =20
>  		if (vgpu_types[i].weight < 1 ||
>  					vgpu_types[i].weight > VGPU_MAX_WEIGHT)
> -			return -EINVAL;
> +			goto out_free_types;
> =20
>  		gvt->types[i].weight =3D vgpu_types[i].weight;
>  		gvt->types[i].resolution =3D vgpu_types[i].edid;
> @@ -167,6 +167,10 @@ int intel_gvt_init_vgpu_types(struct intel_gvt *gvt)
> =20
>  	gvt->num_types =3D i;
>  	return 0;
> +
> +out_free_types:
> +	kfree(gvt->types);
> +	return -EINVAL;
>  }
> =20
>  void intel_gvt_clean_vgpu_types(struct intel_gvt *gvt)
> --=20

Reviewed-by: Zhenyu Wang <zhenyuw@linux.intel.com>

Thanks!

--YzdYn+D7cUqe+VA3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQTXuabgHDW6LPt9CICxBBozTXgYJwUCYrq5IQAKCRCxBBozTXgY
J6+gAKCTyEVOxYue24PgMxjCL5YjuTa+dQCffMU/QCouKpn91rIuZuHx0f1TU9M=
=vk2C
-----END PGP SIGNATURE-----

--YzdYn+D7cUqe+VA3--
