Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E89A62BD6C
	for <lists+kvm@lfdr.de>; Tue, 28 May 2019 04:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727765AbfE1Cwp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 May 2019 22:52:45 -0400
Received: from mga17.intel.com ([192.55.52.151]:9222 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727507AbfE1Cwp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 May 2019 22:52:45 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 May 2019 19:52:44 -0700
X-ExtLoop1: 1
Received: from zhen-hp.sh.intel.com (HELO zhen-hp) ([10.239.13.116])
  by orsmga002.jf.intel.com with ESMTP; 27 May 2019 19:52:42 -0700
Date:   Tue, 28 May 2019 10:51:27 +0800
From:   Zhenyu Wang <zhenyuw@linux.intel.com>
To:     Gerd Hoffmann <kraxel@redhat.com>
Cc:     Tina Zhang <tina.zhang@intel.com>,
        intel-gvt-dev@lists.freedesktop.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, alex.williamson@redhat.com,
        hang.yuan@intel.com, zhiyuan.lv@intel.com
Subject: Re: [PATCH 1/2] vfio: ABI for setting mdev display flip eventfd
Message-ID: <20190528025127.GI29553@zhen-hp.sh.intel.com>
Reply-To: Zhenyu Wang <zhenyuw@linux.intel.com>
References: <20190527084312.8872-1-tina.zhang@intel.com>
 <20190527084312.8872-2-tina.zhang@intel.com>
 <20190527090741.GE29553@zhen-hp.sh.intel.com>
 <20190527122237.uhd7qm62h6wfv5w7@sirius.home.kraxel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="z9ECzHErBrwFF8sy"
Content-Disposition: inline
In-Reply-To: <20190527122237.uhd7qm62h6wfv5w7@sirius.home.kraxel.org>
User-Agent: Mutt/1.10.0 (2018-05-17)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--z9ECzHErBrwFF8sy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019.05.27 14:22:37 +0200, Gerd Hoffmann wrote:
> On Mon, May 27, 2019 at 05:07:41PM +0800, Zhenyu Wang wrote:
> > On 2019.05.27 16:43:11 +0800, Tina Zhang wrote:
> > > Add VFIO_DEVICE_SET_GFX_FLIP_EVENTFD ioctl command to set eventfd
> > > based signaling mechanism to deliver vGPU framebuffer page flip
> > > event to userspace.
> >=20
> > Should we add probe to see if driver can support gfx flip event?
>=20
> Userspace can simply call VFIO_DEVICE_SET_GFX_FLIP_EVENTFD and see if it
> worked.  If so -> use the eventfd.  Otherwise take the fallback path
> (timer based polling).  I can't see any advantage a separate feature
> probe steps adds.
>=20

Then we need to define error return which means driver doesn't support
e.g -ENOTTY, and driver shouldn't return that for other possible
failure, so user space won't get confused.

I think if we can define this as generic display event notification?
Not necessarily just for flip, just a display change notification to
let user space query current state.

--=20
Open Source Technology Center, Intel ltd.

$gpg --keyserver wwwkeys.pgp.net --recv-keys 4D781827

--z9ECzHErBrwFF8sy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQTXuabgHDW6LPt9CICxBBozTXgYJwUCXOyiLwAKCRCxBBozTXgY
Jy7ZAJ9IHhuCGPDYDK9ZUsQm0JS1aSlYrQCfZ2G/aRCELpKd+cSxiSFDvUAuhnM=
=AbnB
-----END PGP SIGNATURE-----

--z9ECzHErBrwFF8sy--
