Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0A236383C0
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 07:05:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbiKYGFu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Nov 2022 01:05:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbiKYGFt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Nov 2022 01:05:49 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 114B91FF93
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 22:05:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669356348; x=1700892348;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   mime-version:in-reply-to;
  bh=LntrxQAjYXGFSFQlFLFWphTWMXHOtTlqCeEdaSgGGak=;
  b=nmw/cJaBOW5eHuD6OWVNqqTZQkxEPlyOEIhEaY5aUV2rFN2R+JNmjus6
   TnayO3upfRdEoG1vdoFJW7a/1au3UeC2lC5DnJpRDGN33UuYlpy5zg0jy
   Dez8rn0bhyyoZUHN1SkthmaXmFKvWtxmcUo7MTjaBMqlM+L71fdQLbq3g
   t0tIJmQc5mP8Sxv135Rv8JygHOI1vnQlxBlnu4p5POY+w9KxPpK9HBPnj
   FbJAuQKcoCf8UR9/p6PznSymEgTHpA5t6C6OgSbvXOr+H97E2kYs+MOXR
   NshlM7tChl2ntyyp5B35OcHLgNWtgLI9VU8LrnuWLHzDNnXKh1RQw2gAN
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="376560830"
X-IronPort-AV: E=Sophos;i="5.96,192,1665471600"; 
   d="asc'?scan'208";a="376560830"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 22:05:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="644695831"
X-IronPort-AV: E=Sophos;i="5.96,192,1665471600"; 
   d="asc'?scan'208";a="644695831"
Received: from zhen-hp.sh.intel.com (HELO zhen-hp) ([10.239.159.108])
  by fmsmga007.fm.intel.com with ESMTP; 24 Nov 2022 22:05:45 -0800
Date:   Fri, 25 Nov 2022 14:04:42 +0800
From:   Zhenyu Wang <zhenyuw@linux.intel.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>
Subject: Re: [iommufd 1/2] i915/gvt: Move kvmgt_protect_table_init() and
 gvt_cache_init() into init
Message-ID: <20221125060442.GV30028@zhen-hp.sh.intel.com>
Reply-To: Zhenyu Wang <zhenyuw@linux.intel.com>
References: <20221123134832.429589-1-yi.l.liu@intel.com>
 <20221123134832.429589-2-yi.l.liu@intel.com>
 <BN9PR11MB5276413337536E76B2B0DA0E8C0F9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <39bcd0d8-17c1-79d0-ed9e-123dacbd4b63@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="1BKOZKwX7DAU5odC"
Content-Disposition: inline
In-Reply-To: <39bcd0d8-17c1-79d0-ed9e-123dacbd4b63@intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--1BKOZKwX7DAU5odC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2022.11.24 17:15:12 +0800, Yi Liu wrote:
> On 2022/11/24 15:07, Tian, Kevin wrote:
> > > From: Liu, Yi L <yi.l.liu@intel.com>
> > > Sent: Wednesday, November 23, 2022 9:49 PM
> > >=20
> > > vfio_iommufd_bind() creates an access which has an unmap callback, wh=
ich
> > > can be called immediately. So dma_unmap() callback should tolerate the
> > > unmaps that come before the emulated device is opened.
> >=20
> > this should first talk about how it works today and then why iommufd ch=
anges
> > it.
> >=20
> > >=20
> > > To achieve above, move the protect_table_init and gvt_cache_init into=
 the
> > > init op which is supposed to be triggered prior to the open_device() =
op.
> >=20
> > what about below?
> > --
> > vfio container registers .dma_unmap() callback after the device is open=
ed.
> > So it's fine for mdev drivers to initialize internal mapping cache in
> > .open_device(). See vfio_device_container_register().
> >=20
> > Now with iommufd an access ops with an unmap callback is registered
> > when the device is bound to iommufd which is before .open_device()
> > is called. This implies gvt's .dma_unmap() could be called before its
> > internal mapping cache is initialized.
> >=20
> > The fix is moving gvt mapping cache initialization to vGPU creation.
> > While at it also move ptable initialization together.
>=20
> much clearer :-)
>

Current gvt internal cache is handled with .open_device() and .close_device=
() pair,
so those internal cache is now re-initialized for each device session, how =
is that
handled for iommufd? Looks that's missed in this patch..

> > >=20
> > > Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
> > > Cc: Zhi Wang <zhi.a.wang@intel.com>
> > > Cc: Kevin Tian <kevin.tian@intel.com>
> > > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > > ---
> > >   drivers/gpu/drm/i915/gvt/gvt.h   | 2 ++
> > >   drivers/gpu/drm/i915/gvt/kvmgt.c | 7 ++-----
> > >   drivers/gpu/drm/i915/gvt/vgpu.c  | 2 ++
> > >   3 files changed, 6 insertions(+), 5 deletions(-)
> > >=20
> > > diff --git a/drivers/gpu/drm/i915/gvt/gvt.h b/drivers/gpu/drm/i915/gv=
t/gvt.h
> > > index dbf8d7470b2c..a3a7e16078ba 100644
> > > --- a/drivers/gpu/drm/i915/gvt/gvt.h
> > > +++ b/drivers/gpu/drm/i915/gvt/gvt.h
> > > @@ -754,6 +754,8 @@ void intel_gvt_debugfs_remove_vgpu(struct
> > > intel_vgpu *vgpu);
> > >   void intel_gvt_debugfs_init(struct intel_gvt *gvt);
> > >   void intel_gvt_debugfs_clean(struct intel_gvt *gvt);
> > >=20
> > > +void gvt_cache_init(struct intel_vgpu *vgpu);
> > > +void kvmgt_protect_table_init(struct intel_vgpu *info);
> > >   int intel_gvt_page_track_add(struct intel_vgpu *info, u64 gfn);
> > >   int intel_gvt_page_track_remove(struct intel_vgpu *info, u64 gfn);
> > >   int intel_gvt_dma_pin_guest_page(struct intel_vgpu *vgpu, dma_addr_t
> > > dma_addr);
> > > diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c
> > > b/drivers/gpu/drm/i915/gvt/kvmgt.c
> > > index 579b230a0f58..cb21b1ba4162 100644
> > > --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> > > +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> > > @@ -322,7 +322,7 @@ static void gvt_cache_destroy(struct intel_vgpu *=
vgpu)
> > >   	}
> > >   }
> > >=20
> > > -static void gvt_cache_init(struct intel_vgpu *vgpu)
> > > +void gvt_cache_init(struct intel_vgpu *vgpu)
> >=20
> > those are local functions. Just move to vgpu.c.
> >=20
> > or you can remove the function wrap and directly put the internal lines
> > in intel_gvt_create_vgpu()
>=20
> yes. maybe see Zhenyu and Zhi's input. which way is preferred by them.
>=20
> > >   {
> > >   	vgpu->gfn_cache =3D RB_ROOT;
> > >   	vgpu->dma_addr_cache =3D RB_ROOT;
> > > @@ -330,7 +330,7 @@ static void gvt_cache_init(struct intel_vgpu *vgp=
u)
> > >   	mutex_init(&vgpu->cache_lock);
> > >   }
> > >=20
> > > -static void kvmgt_protect_table_init(struct intel_vgpu *info)
> > > +void kvmgt_protect_table_init(struct intel_vgpu *info)
> > >   {
> > >   	hash_init(info->ptable);
> > >   }
> > > @@ -671,9 +671,6 @@ static int intel_vgpu_open_device(struct vfio_dev=
ice
> > > *vfio_dev)
> > >=20
> > >   	vgpu->attached =3D true;
> > >=20
> > > -	kvmgt_protect_table_init(vgpu);
> > > -	gvt_cache_init(vgpu);
> > > -
> > >   	vgpu->track_node.track_write =3D kvmgt_page_track_write;
> > >   	vgpu->track_node.track_flush_slot =3D kvmgt_page_track_flush_slot;
> > >   	kvm_page_track_register_notifier(vgpu->vfio_device.kvm,
> > > diff --git a/drivers/gpu/drm/i915/gvt/vgpu.c
> > > b/drivers/gpu/drm/i915/gvt/vgpu.c
> > > index 56c71474008a..036e1a72a26b 100644
> > > --- a/drivers/gpu/drm/i915/gvt/vgpu.c
> > > +++ b/drivers/gpu/drm/i915/gvt/vgpu.c
> > > @@ -382,6 +382,8 @@ int intel_gvt_create_vgpu(struct intel_vgpu *vgpu,
> > >=20
> > >   	intel_gvt_update_reg_whitelist(vgpu);
> > >   	mutex_unlock(&gvt->lock);
> > > +	kvmgt_protect_table_init(vgpu);
> > > +	gvt_cache_init(vgpu);
> > >   	return 0;
> > >=20
> > >   out_clean_sched_policy:
> > > --
> > > 2.34.1
> >=20
>=20
> --=20
> Regards,
> Yi Liu

--1BKOZKwX7DAU5odC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQTXuabgHDW6LPt9CICxBBozTXgYJwUCY4Ba9QAKCRCxBBozTXgY
J/sSAKCEM2penOPe/GEU5DeSiqZc+2ZTNACfaUHNWLBpzdnAS2XUptjNquIp28Q=
=bht/
-----END PGP SIGNATURE-----

--1BKOZKwX7DAU5odC--
