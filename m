Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37D5354C1F9
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 08:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354401AbiFOGen (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 02:34:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354276AbiFOGe1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 02:34:27 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E08042ED1;
        Tue, 14 Jun 2022 23:34:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655274866; x=1686810866;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   mime-version:in-reply-to;
  bh=MbHPNnGlDxuDessM8Cx675Vo8Ix4YcS8iHifZIiU9+4=;
  b=PivJC5io1aTRIEsYT5Eizoj0LHnGA5S2Hw0IdiuQ8E/r3ed2LYbrDuc2
   ZXDoGCMONTl/m/Y88wRNA+rKP8O/8wGTsOURlZQA9qrDvrqdcKXegDiH3
   VseaFQ6o2VvVINihGc7pyvvthgqzCzxrt9dTbJkzNPaayIYPMBcheDQP+
   AWxTa0Ez/AHgOoRcP4KX9/pggYt81YILpKJ+idLYYN7Yvj+IHTyBmmtt+
   AFp2exUfxNbqNUrbmzeVl0sfNEfXRZhfpuysQGjZlQcnPqqWGTEza+Z1j
   cAl9FVZ7OkqNvknIPGXXRpUOi924I9T5+DbzkK9zOoQ5hAgyHJtF4UuiX
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10378"; a="259315022"
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="asc'?scan'208";a="259315022"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2022 23:34:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="asc'?scan'208";a="911456112"
Received: from zhen-hp.sh.intel.com (HELO zhen-hp) ([10.239.159.108])
  by fmsmga005.fm.intel.com with ESMTP; 14 Jun 2022 23:34:23 -0700
Date:   Wed, 15 Jun 2022 14:11:56 +0800
From:   Zhenyu Wang <zhenyuw@linux.intel.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH 03/13] vfio/mdev: simplify mdev_type handling
Message-ID: <20220615061156.GU1089@zhen-hp.sh.intel.com>
Reply-To: Zhenyu Wang <zhenyuw@linux.intel.com>
References: <20220614045428.278494-1-hch@lst.de>
 <20220614045428.278494-4-hch@lst.de>
 <BN9PR11MB5276A3DCE429292860FD85F58CAA9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220615062840.GB22728@lst.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="dJyWBSYfjLochwFK"
Content-Disposition: inline
In-Reply-To: <20220615062840.GB22728@lst.de>
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--dJyWBSYfjLochwFK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2022.06.15 08:28:40 +0200, Christoph Hellwig wrote:
> On Tue, Jun 14, 2022 at 10:06:16AM +0000, Tian, Kevin wrote:
> > > +	gvt->mdev_types =3D kcalloc(num_types, sizeof(*gvt->mdev_types),
> > > +			     GFP_KERNEL);
> > > +	if (!gvt->mdev_types) {
> > > +		kfree(gvt->types);
> > > +		return -ENOMEM;
> > > +	}
> > > +
> > >  	min_low =3D MB_TO_BYTES(32);
> > >  	for (i =3D 0; i < num_types; ++i) {
> > >  		if (low_avail / vgpu_types[i].low_mm =3D=3D 0)
> > > @@ -150,19 +157,21 @@ int intel_gvt_init_vgpu_types(struct intel_gvt =
*gvt)
> > >  						   high_avail /
> > > vgpu_types[i].high_mm);
> >=20
> > there is a memory leak a few lines above:
> >=20
> > if (vgpu_types[i].weight < 1 ||
> > 	vgpu_types[i].weight > VGPU_MAX_WEIGHT)
> > 	return -EINVAL;
> >=20
> > both old code and this patch forgot to free the buffers upon error.

Sorry about that! It should be my original fault...

>=20
> Yeah.  I'll add a patch to the beginning of the series to fix the
> existing leak and will then make sure to not leak the new allocation
> either.

Thanks a lot!

--dJyWBSYfjLochwFK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQTXuabgHDW6LPt9CICxBBozTXgYJwUCYql4JQAKCRCxBBozTXgY
JyXDAKCKZtJH0+Er/ocmCAzJewO/46Bj1gCfaTZHC9zqGahEkP/COKdZH5NCzrQ=
=m2Vj
-----END PGP SIGNATURE-----

--dJyWBSYfjLochwFK--
