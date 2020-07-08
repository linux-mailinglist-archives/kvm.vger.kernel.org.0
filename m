Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B257217CF2
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 04:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729056AbgGHCLP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jul 2020 22:11:15 -0400
Received: from mga03.intel.com ([134.134.136.65]:51648 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728479AbgGHCLP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jul 2020 22:11:15 -0400
IronPort-SDR: K/buAHviRZtHQ6RvkQbx2HhKDUMpyJJm+vixiF2d3sAj8Wz8ttjMH5QJUOV8yMaSKzlFjTVraO
 qvs3fp0S7mtg==
X-IronPort-AV: E=McAfee;i="6000,8403,9675"; a="147732655"
X-IronPort-AV: E=Sophos;i="5.75,326,1589266800"; 
   d="asc'?scan'208";a="147732655"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2020 19:11:13 -0700
IronPort-SDR: oSJ6GMCnrQe53OzHcC1l9gU9cl0w0NTalJFSGBfCjez97HhXW0Zxvr/A6v5IYvl5p4AcO6zcl0
 Jz5CpLg66jfg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,326,1589266800"; 
   d="asc'?scan'208";a="357964668"
Received: from zhen-hp.sh.intel.com (HELO zhen-hp) ([10.239.160.147])
  by orsmga001.jf.intel.com with ESMTP; 07 Jul 2020 19:11:10 -0700
Date:   Wed, 8 Jul 2020 09:54:19 +0800
From:   Zhenyu Wang <zhenyuw@linux.intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>
Subject: Re: [PATCH v3 0/2] VFIO mdev aggregated resources handling
Message-ID: <20200708015419.GM27035@zhen-hp.sh.intel.com>
Reply-To: Zhenyu Wang <zhenyuw@linux.intel.com>
References: <20200326054136.2543-1-zhenyuw@linux.intel.com>
 <20200408055824.2378-1-zhenyuw@linux.intel.com>
 <MWHPR11MB1645CC388BF45FD2E6309C3C8C660@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20200707190634.4d9055fe@x1.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="NU0Ex4SbNnrxsi6C"
Content-Disposition: inline
In-Reply-To: <20200707190634.4d9055fe@x1.home>
User-Agent: Mutt/1.10.0 (2018-05-17)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--NU0Ex4SbNnrxsi6C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2020.07.07 19:06:34 -0600, Alex Williamson wrote:
> On Tue, 7 Jul 2020 23:28:39 +0000
> "Tian, Kevin" <kevin.tian@intel.com> wrote:
>=20
> > Hi, Alex,=20
> >=20
> > Gentle ping... Please let us know whether this version looks good.
>=20
> I figured this is entangled with the versioning scheme.  There are
> unanswered questions about how something that assumes a device of a
> given type is software compatible to another device of the same type
> handles aggregation and how the type class would indicate compatibility
> with an aggregated instance.  Thanks,
>=20

+Yan

Alex, If no concern on aggregated resources info for instance that would
be vendor's behavior to determine what type of resources would be aggregate=
d,
then I'll check with Yan to see how to fulfill this during migration.

Thanks

>=20
>=20
> > > From: Zhenyu Wang <zhenyuw@linux.intel.com>
> > > Sent: Wednesday, April 8, 2020 1:58 PM
> > >=20
> > > Hi,
> > >=20
> > > This is a refresh on previous series:
> > > https://patchwork.kernel.org/cover/11208279/
> > > and https://patchwork.freedesktop.org/series/70425/
> > >=20
> > > Current mdev device create interface depends on fixed mdev type, which
> > > get uuid from user to create instance of mdev device. If user wants to
> > > use customized number of resource for mdev device, then only can
> > > create new mdev type for that which may not be flexible. This
> > > requirement comes not only from to be able to allocate flexible
> > > resources for KVMGT, but also from Intel scalable IO virtualization
> > > which would use vfio/mdev to be able to allocate arbitrary resources
> > > on mdev instance. More info on [1] [2] [3].
> > >=20
> > > As we agreed that for current opaque mdev device type, we'd still
> > > explore management interface based on mdev sysfs definition. And this
> > > one tries to follow Alex's previous suggestion to create generic
> > > parameters under 'mdev' directory for each device, so vendor driver
> > > could provide support like as other defined mdev sysfs entries.
> > >=20
> > > For mdev type with aggregation support, files as "aggregated_instance=
s"
> > > and "max_aggregation" should be created under 'mdev' directory. E.g
> > >=20
> > > /sys/devices/pci0000:00/0000:00:02.0/<UUID>/mdev/
> > >    |-- aggregated_instances
> > >    |-- max_aggregation
> > >=20
> > > "aggregated_instances" is used to set or return current number of
> > > instances for aggregation, which can not be larger than "max_aggregat=
ion".
> > >=20
> > > The first patch is to update the document for new mdev parameter dire=
ctory.
> > > The second one is to add aggregation support in GVT driver.
> > >=20
> > > References:
> > > [1] https://software.intel.com/en-us/download/intel-virtualization-
> > > technology-for-directed-io-architecture-specification
> > > [2] https://software.intel.com/en-us/download/intel-scalable-io-
> > > virtualization-technical-specification
> > > [3] https://schd.ws/hosted_files/lc32018/00/LC3-SIOV-final.pdf
> > >=20
> > > Changelog:
> > > v3:
> > > - add more description for sysfs entries
> > > - rebase GVT support
> > > - rename accounting function
> > >=20
> > > Zhenyu Wang (2):
> > >   Documentation/driver-api/vfio-mediated-device.rst: update for
> > >     aggregation support
> > >   drm/i915/gvt: mdev aggregation type
> > >=20
> > >  .../driver-api/vfio-mediated-device.rst       |  22 +++
> > >  drivers/gpu/drm/i915/gvt/aperture_gm.c        |  44 +++--
> > >  drivers/gpu/drm/i915/gvt/gtt.c                |   9 +-
> > >  drivers/gpu/drm/i915/gvt/gvt.c                |   7 +-
> > >  drivers/gpu/drm/i915/gvt/gvt.h                |  42 +++--
> > >  drivers/gpu/drm/i915/gvt/kvmgt.c              | 115 +++++++++++-
> > >  drivers/gpu/drm/i915/gvt/vgpu.c               | 172 ++++++++++++----=
--
> > >  7 files changed, 317 insertions(+), 94 deletions(-)
> > >=20
> > > --
> > > 2.25.1 =20
> >=20
>=20

--=20
Open Source Technology Center, Intel ltd.

$gpg --keyserver wwwkeys.pgp.net --recv-keys 4D781827

--NU0Ex4SbNnrxsi6C
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQTXuabgHDW6LPt9CICxBBozTXgYJwUCXwUnSwAKCRCxBBozTXgY
JziqAJ99JXjKltT9jEujYB5NJEA0r/XGKACfa8m9F4rRwIM0PuY/EWVbnIonoy0=
=3O1U
-----END PGP SIGNATURE-----

--NU0Ex4SbNnrxsi6C--
