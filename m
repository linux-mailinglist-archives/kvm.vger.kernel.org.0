Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57A08193B0B
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 09:35:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727926AbgCZIep (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Mar 2020 04:34:45 -0400
Received: from mga02.intel.com ([134.134.136.20]:28864 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727922AbgCZIeo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Mar 2020 04:34:44 -0400
IronPort-SDR: Xo5nmRFFvEvMK0w00XpTSB7PfGJDeDU224kf6ifLoYULfqtjqULqvVyglK+2NJb14hVFmce+A3
 1z2XSw2rkzAQ==
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2020 01:34:43 -0700
IronPort-SDR: DPTuwS6jOkC0/6aWao2I6nlJ6YDLEIcTKUni3yoaNL1UJWL0oQPZgYq0Ld+01G5dEW3sDRe3Cx
 BEsfzvi43Rbw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,307,1580803200"; 
   d="asc'?scan'208";a="247471444"
Received: from zhen-hp.sh.intel.com (HELO zhen-hp) ([10.239.160.147])
  by orsmga003.jf.intel.com with ESMTP; 26 Mar 2020 01:34:42 -0700
Date:   Thu, 26 Mar 2020 16:21:42 +0800
From:   Zhenyu Wang <zhenyuw@linux.intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "Jiang, Dave" <dave.jiang@intel.com>
Subject: Re: [PATCH v2 1/2]
 Documentation/driver-api/vfio-mediated-device.rst: update for aggregation
 support
Message-ID: <20200326082142.GC8880@zhen-hp.sh.intel.com>
Reply-To: Zhenyu Wang <zhenyuw@linux.intel.com>
References: <20200326054136.2543-1-zhenyuw@linux.intel.com>
 <20200326054136.2543-2-zhenyuw@linux.intel.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D7EAB69@SHSMSX104.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="75efu8vkn6QcqU9C"
Content-Disposition: inline
In-Reply-To: <AADFC41AFE54684AB9EE6CBC0274A5D19D7EAB69@SHSMSX104.ccr.corp.intel.com>
User-Agent: Mutt/1.10.0 (2018-05-17)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--75efu8vkn6QcqU9C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2020.03.26 08:17:20 +0000, Tian, Kevin wrote:
> > From: Zhenyu Wang <zhenyuw@linux.intel.com>
> > Sent: Thursday, March 26, 2020 1:42 PM
> >=20
> > Update doc for mdev aggregation support. Describe mdev generic
> > parameter directory under mdev device directory.
> >=20
> > Cc: Kevin Tian <kevin.tian@intel.com>
> > Cc: "Jiang, Dave" <dave.jiang@intel.com>
> > Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
> > ---
> >  .../driver-api/vfio-mediated-device.rst       | 19 +++++++++++++++++++
> >  1 file changed, 19 insertions(+)
> >=20
> > diff --git a/Documentation/driver-api/vfio-mediated-device.rst
> > b/Documentation/driver-api/vfio-mediated-device.rst
> > index 25eb7d5b834b..29c29432a847 100644
> > --- a/Documentation/driver-api/vfio-mediated-device.rst
> > +++ b/Documentation/driver-api/vfio-mediated-device.rst
> > @@ -269,6 +269,9 @@ Directories and Files Under the sysfs for Each mdev
> > Device
> >    |--- [$MDEV_UUID]
> >           |--- remove
> >           |--- mdev_type {link to its type}
> > +         |--- mdev [optional]
> > +	     |--- aggregated_instances [optional]
> > +	     |--- max_aggregation [optional]
> >           |--- vendor-specific-attributes [optional]
> >=20
> >  * remove (write only)
> > @@ -281,6 +284,22 @@ Example::
> >=20
> >  	# echo 1 > /sys/bus/mdev/devices/$mdev_UUID/remove
> >=20
> > +* mdev directory (optional)
>=20
> It sounds confusing to me when seeing a 'mdev' directory under a
> mdev instance. How could one tell which attribute should put inside
> or outside of 'mdev'?
>

After mdev create you get uuid directory under normal device path, so
=66rom that point a 'mdev' directory can just tell this is a mdev
device. And it's proposed by Alex before.

Currently only mdev core could create attribute e.g 'remove' under
device dir, vendor specific attrs need to be in attrs group. So 'mdev'
directory here tries to be optional generic interface.

> > +
> > +Vendor driver could create mdev directory to specify extra generic
> > parameters
> > +on mdev device by its type. Currently aggregation parameters are defin=
ed.
> > +Vendor driver should provide both items to support.
> > +
> > +1) aggregated_instances (read/write)
> > +
> > +Set target aggregated instances for device. Reading will show current
> > +count of aggregated instances. Writing value larger than max_aggregati=
on
> > +would fail and return error.
>=20
> Can one write a value multiple-times and at any time?=20
>

yeah, of coz multiple times, but normally won't succeed after open.

> > +
> > +2) max_aggregation (read only)
> > +
> > +Show maxium instances for aggregation.
> > +
>=20
> "show maximum-allowed instances which can be aggregated for this device".=
 is
> this value static or dynamic? if dynamic then the user is expected to rea=
d this
> field before every write. worthy of some clarification here.

yeah, user needs to read this before setting actual number, either static o=
r dynamic
depends on vendor resource type.

Thanks

>=20
> >  Mediated device Hot plug
> >  ------------------------
> >=20
> > --
> > 2.25.1
>=20

--=20
Open Source Technology Center, Intel ltd.

$gpg --keyserver wwwkeys.pgp.net --recv-keys 4D781827

--75efu8vkn6QcqU9C
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQTXuabgHDW6LPt9CICxBBozTXgYJwUCXnxmFgAKCRCxBBozTXgY
J2ycAJ4kv0HYOAz20xgGuSJqbYUPAV47BgCghApMm0sy0DqMUh+1xTgD5neP3eE=
=16cW
-----END PGP SIGNATURE-----

--75efu8vkn6QcqU9C--
