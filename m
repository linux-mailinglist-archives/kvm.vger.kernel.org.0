Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92A3956653C
	for <lists+kvm@lfdr.de>; Tue,  5 Jul 2022 10:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbiGEIla (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jul 2022 04:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbiGEIl3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jul 2022 04:41:29 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18A806459;
        Tue,  5 Jul 2022 01:41:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657010489; x=1688546489;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   mime-version:in-reply-to;
  bh=10zTO6cjRHm5YSu4wYIH1EEbhmOcJUB5ss5nZC1yDkY=;
  b=It/cjqKrB43vf9N7h0xEMH4ALrACWaXp+dtx4xaZEHOwhRtsd4Ze9Gsg
   DJMpy9FazwPmyzl+AX2MPlDG/Wp5OZ5Y835nh8tG8GeDnyzEOacrG7GWK
   luKAZfvubbxih/W649SC2d/td4ItBo808QWG4Imqm6axb1T5inl2pc5CP
   7moPy3CkXuVJwN6dk5uwioHo5MT8S27gx/X6/deeI+yxXvheFdffhLuiT
   TIxgh/wMjF/HDe75YE3EIbZQADCLz/FFcpCaabxk19yWAjdXU8s1OHcgp
   6wpGH2cwWRzKA3SsDiOL/SaVMuv5Xxqg77xuveQgpiQBSa+Km5Cqxkl3u
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10398"; a="272070197"
X-IronPort-AV: E=Sophos;i="5.92,245,1650956400"; 
   d="asc'?scan'208";a="272070197"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2022 01:41:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,245,1650956400"; 
   d="asc'?scan'208";a="650015050"
Received: from zhen-hp.sh.intel.com (HELO zhen-hp) ([10.239.159.108])
  by fmsmga008.fm.intel.com with ESMTP; 05 Jul 2022 01:41:25 -0700
Date:   Tue, 5 Jul 2022 16:18:14 +0800
From:   Zhenyu Wang <zhenyuw@linux.intel.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org
Subject: Re: [PATCH 02/14] drm/i915/gvt: simplify vgpu configuration
 management
Message-ID: <20220705081814.GX1089@zhen-hp.sh.intel.com>
Reply-To: Zhenyu Wang <zhenyuw@linux.intel.com>
References: <20220704125144.157288-1-hch@lst.de>
 <20220704125144.157288-3-hch@lst.de>
 <20220705075938.GW1089@zhen-hp.sh.intel.com>
 <20220705082559.GA18584@lst.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="f0Ums9VvOMUG7syy"
Content-Disposition: inline
In-Reply-To: <20220705082559.GA18584@lst.de>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--f0Ums9VvOMUG7syy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2022.07.05 10:25:59 +0200, Christoph Hellwig wrote:
> On Tue, Jul 05, 2022 at 03:59:38PM +0800, Zhenyu Wang wrote:
> > On 2022.07.04 14:51:32 +0200, Christoph Hellwig wrote:
> > > Instead of copying the information from the vgpu_types arrays into ea=
ch
> > > intel_vgpu_type structure, just reference this constant information
> > > with a pointer to the already existing data structure, and pass it in=
to
> > > the low-level VGPU creation helpers intead of copying the data into y=
et
> > > anothe params data structure.
> > >=20
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > ---
> >=20
> > Looks fine to me. We still carry some legacy codes like vgpu create par=
am
> > originally used for other hypervisor. Thanks for cleaning this up!
>=20
> Note that even there I think this structure makes more sense:
>=20
> The generic config structure that has not vfio-related bits as the
> lowest layer.  vfio/kvm specific structures then carry a pointer to
> it can can pass it to lower layers.

yes, I'm also fine with that part which makes it more straight forward
to link between mdev type and lower level info.

Thanks

--f0Ums9VvOMUG7syy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQTXuabgHDW6LPt9CICxBBozTXgYJwUCYsPzwAAKCRCxBBozTXgY
J6CtAJ9Q3QqM6rUZuDmkhYaWgL6vVPQ0twCfY2mwPeSPyzVbdH9M+sIWLy4kObA=
=f7tM
-----END PGP SIGNATURE-----

--f0Ums9VvOMUG7syy--
