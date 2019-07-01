Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD9D5B306
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2019 05:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727193AbfGADMD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 30 Jun 2019 23:12:03 -0400
Received: from mga02.intel.com ([134.134.136.20]:4272 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727135AbfGADMD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 30 Jun 2019 23:12:03 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Jun 2019 20:12:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,437,1557212400"; 
   d="asc'?scan'208";a="165682225"
Received: from zhen-hp.sh.intel.com (HELO zhen-hp) ([10.239.13.116])
  by orsmga003.jf.intel.com with ESMTP; 30 Jun 2019 20:11:52 -0700
Date:   Mon, 1 Jul 2019 11:09:19 +0800
From:   Zhenyu Wang <zhenyuw@linux.intel.com>
To:     "Zhang, Tina" <tina.zhang@intel.com>
Cc:     Gerd Hoffmann <kraxel@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Lv, Zhiyuan" <zhiyuan.lv@intel.com>,
        "Yuan, Hang" <hang.yuan@intel.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>
Subject: Re: [RFC PATCH v3 0/4] Deliver vGPU display vblank event to userspace
Message-ID: <20190701030919.GJ9684@zhen-hp.sh.intel.com>
Reply-To: Zhenyu Wang <zhenyuw@linux.intel.com>
References: <20190627033802.1663-1-tina.zhang@intel.com>
 <20190627062231.57tywityo6uyhmyd@sirius.home.kraxel.org>
 <237F54289DF84E4997F34151298ABEBC876835E5@SHSMSX101.ccr.corp.intel.com>
 <20190627103133.6ekdwazggi5j5lcl@sirius.home.kraxel.org>
 <20190628032149.GD9684@zhen-hp.sh.intel.com>
 <20190628054346.3uc3k4c4cffrqcy3@sirius.home.kraxel.org>
 <237F54289DF84E4997F34151298ABEBC87685825@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="9IEn5YSSuHr7pCxV"
Content-Disposition: inline
In-Reply-To: <237F54289DF84E4997F34151298ABEBC87685825@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.10.0 (2018-05-17)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--9IEn5YSSuHr7pCxV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019.06.28 12:43:47 +0000, Zhang, Tina wrote:
> Hi,
>=20
> How about GVT-g supports both vblank and page flip events. Then QEMU UI c=
an mask/unmask the events to decide which kind of event is expected.
> For DRM UI, it can decide to mask vblank event and use page flip events. =
We tried DRM UI with page flip events, the performance is great, even in th=
e case of front buffer rendering. For the UI like GTK, vblank event is bett=
er.=20
>=20
> Besides, with the irq mask/unmask mechanism, userspace can dynamically ch=
oose between the UI timer and the events.=20
>=20

The idea is to deliver an event to tell userspace that "guest has
display update, you need to refresh your UI". How driver
implementation uses either vblank or page flip to determine that is
driver specific, as same routine of vfio gfx interface will be used to
refresh on guest display.

If userspace doesn't set irq for vfio gfx display, it would just use
own timer.

>=20
> > -----Original Message-----
> > From: Zhang, Tina
> > Sent: Friday, June 28, 2019 4:45 PM
> > To: 'Gerd Hoffmann' <kraxel@redhat.com>; Zhenyu Wang
> > <zhenyuw@linux.intel.com>
> > Cc: Tian, Kevin <kevin.tian@intel.com>; kvm@vger.kernel.org; linux-
> > kernel@vger.kernel.org; alex.williamson@redhat.com; Lv, Zhiyuan
> > <zhiyuan.lv@intel.com>; Yuan, Hang <hang.yuan@intel.com>; intel-gvt-
> > dev@lists.freedesktop.org; Wang, Zhi A <zhi.a.wang@intel.com>
> > Subject: RE: [RFC PATCH v3 0/4] Deliver vGPU display vblank event to
> > userspace
> >=20
> >=20
> >=20
> > > -----Original Message-----
> > > From: intel-gvt-dev
> > > [mailto:intel-gvt-dev-bounces@lists.freedesktop.org] On Behalf Of Gerd
> > > Hoffmann
> > > Sent: Friday, June 28, 2019 1:44 PM
> > > To: Zhenyu Wang <zhenyuw@linux.intel.com>
> > > Cc: Tian, Kevin <kevin.tian@intel.com>; kvm@vger.kernel.org; linux-
> > > kernel@vger.kernel.org; Zhang, Tina <tina.zhang@intel.com>;
> > > alex.williamson@redhat.com; Lv, Zhiyuan <zhiyuan.lv@intel.com>; Yuan,
> > > Hang <hang.yuan@intel.com>; intel-gvt-dev@lists.freedesktop.org; Wang,
> > > Zhi A <zhi.a.wang@intel.com>
> > > Subject: Re: [RFC PATCH v3 0/4] Deliver vGPU display vblank event to
> > > userspace
> > >
> > > On Fri, Jun 28, 2019 at 11:21:49AM +0800, Zhenyu Wang wrote:
> > > > On 2019.06.27 12:31:33 +0200, Gerd Hoffmann wrote:
> > > > > > >   Hi,
> > > > > > >
> > > > > > > > Instead of delivering page flip events, we choose to post
> > > > > > > > display vblank event. Handling page flip events for both
> > > > > > > > primary plane and cursor plane may make user space quite
> > > > > > > > busy, although we have the mask/unmask mechansim for
> > mitigation.
> > > > > > > > Besides, there are some cases that guest app only uses one
> > > framebuffer for both drawing and display.
> > > > > > > > In such case, guest OS won't do the plane page flip when the
> > > > > > > > framebuffer is updated, thus the user land won't be notified
> > > > > > > > about the
> > > > > > > updated framebuffer.
> > > > > > >
> > > > > > > What happens when the guest is idle and doesn't draw anything
> > > > > > > to the framebuffer?
> > > > > > The vblank event will be delivered to userspace as well, unless
> > > > > > guest OS
> > > disable the pipe.
> > > > > > Does it make sense to vfio/display?
> > > > >
> > > > > Getting notified only in case there are actual display updates
> > > > > would be a nice optimization, assuming the hardware is able to do=
 that.
> > > > > If the guest pageflips this is obviously trivial.  Not sure this
> > > > > is possible in case the guest renders directly to the frontbuffer.
> > > > >
> > > > > What exactly happens when the guest OS disables the pipe?  Is a
> > > > > vblank event delivered at least once?  That would be very useful
> > > > > because it will be possible for userspace to stop polling
> > > > > altogether without missing the "guest disabled pipe" event.
> > > > >
> > > >
> > > > It looks like purpose to use vblank here is to replace user space
> > > > polling totally by kernel event? Which just act as display update
> > > > event to replace user space timer to make it query and update plane=
s?
> > >
> > > I think it makes sense to design it that way, so userspace will either
> > > use the events (when supported by the driver) or a timer (fallback if
> > > not) but not both.
> > >
> > > > Although in theory vblank is not appropriate for this which doesn't
> > > > align with plane update or possible front buffer rendering at all,
> > > > but looks it's just a compromise e.g not sending event for every
> > > > cursor position change, etc.
> > > >
> > > > I think we need to define semantics for this event properly, e.g
> > > > user space purely depends on this event for display update, the
> > > > opportunity for issuing this event is controlled by driver when it's
> > > > necessary for update, etc. Definitely not named as vblank event or
> > > > only issue at vblank, that need to happen for other plane change to=
o.
> > >
> > > I think it should be "display update notification", i.e. userspace
> > > should check for plane changes and update the display.
> > >
> > > Most events will probably come from vblank (typically plane update are
> > > actually committed at vblank time to avoid tearing, right?).  That is
> > > an
> > Yes.
> > > implementation detail though.
> >=20
> > We have two WIP branches: one is for vblank event delivery and the other
> > one is for page flip event delivery.
> > Repo:
> > - QEMU: https://github.com/intel/Igvtg-qemu.git
> > - Kernel: https://github.com/intel/gvt-linux.git
> > Two branches: topic/userspace_direct_flip_page_event and
> > topic/userspace_direct_flip_vblank_event
> >=20
> > With GTK UI, the user experience is bad on branch
> > topic/userspace_direct_flip_page_event, as most of the CPU efforts are
> > spent on event handling in user space.
> > However, with the DRM UI both of the two branches have good user
> > experience, as the event handling in DRM UI is pretty simple.
> >=20
> > Thanks.
> >=20
> > BR,
> > Tina
> >=20
> > >
> > > cheers,
> > >   Gerd
> > >
> > > _______________________________________________
> > > intel-gvt-dev mailing list
> > > intel-gvt-dev@lists.freedesktop.org
> > > https://lists.freedesktop.org/mailman/listinfo/intel-gvt-dev

--=20
Open Source Technology Center, Intel ltd.

$gpg --keyserver wwwkeys.pgp.net --recv-keys 4D781827

--9IEn5YSSuHr7pCxV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQTXuabgHDW6LPt9CICxBBozTXgYJwUCXRl5XwAKCRCxBBozTXgY
J9iDAJwLOF/qLoZefonm1vaszR45i7E0cQCeO96Kx6L0VBRYU3c2bL4z8GwinMc=
=SmFJ
-----END PGP SIGNATURE-----

--9IEn5YSSuHr7pCxV--
