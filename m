Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1EA2FB3B8
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 16:29:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727945AbfKMP3z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 10:29:55 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:59115 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727640AbfKMP3z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Nov 2019 10:29:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573658992;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VyJermrJkxEukeR5lUS5Ke3xa4p7ZGzEtUjsRzMk60g=;
        b=R6WNYGaxRU5XXHh1Xka7/NN/a4bQspafrTQH5chNx5kkpd0z1tbO6pt2WfHUiU7SWyM0vE
        QH0OWuEvErrlebgOrGdMkiKe2MJQ5VlQjaZzaaUyxNukPkChm3yqLbSya6Q2OBmoY2fef/
        T9MgfZwCxAaLtiEGlxA/uPksS/duEsE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-123-PyzIgGKSP9Ovgsz7NKAzMA-1; Wed, 13 Nov 2019 10:29:51 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 56D41801FD2;
        Wed, 13 Nov 2019 15:29:49 +0000 (UTC)
Received: from x1.home (ovpn-116-138.phx2.redhat.com [10.3.116.138])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 412CE1D0;
        Wed, 13 Nov 2019 15:29:41 +0000 (UTC)
Date:   Wed, 13 Nov 2019 08:29:40 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe.brucker@arm.com" <jean-philippe.brucker@arm.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [RFC v2 2/3] vfio/type1: VFIO_IOMMU_PASID_REQUEST(alloc/free)
Message-ID: <20191113082940.1b415d00@x1.home>
In-Reply-To: <A2975661238FB949B60364EF0F2C25743A0F8CB4@SHSMSX104.ccr.corp.intel.com>
References: <1571919983-3231-1-git-send-email-yi.l.liu@intel.com>
        <1571919983-3231-3-git-send-email-yi.l.liu@intel.com>
        <20191105163537.1935291c@x1.home>
        <A2975661238FB949B60364EF0F2C25743A0EF41B@SHSMSX104.ccr.corp.intel.com>
        <20191107150659.05fa7548@x1.home>
        <A2975661238FB949B60364EF0F2C25743A0F305A@SHSMSX104.ccr.corp.intel.com>
        <20191108081503.29a7a800@x1.home>
        <A2975661238FB949B60364EF0F2C25743A0F8CB4@SHSMSX104.ccr.corp.intel.com>
Organization: Red Hat
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: PyzIgGKSP9Ovgsz7NKAzMA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 13 Nov 2019 11:03:17 +0000
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

> > From: Alex Williamson [mailto:alex.williamson@redhat.com]
> > Sent: Friday, November 8, 2019 11:15 PM
> > To: Liu, Yi L <yi.l.liu@intel.com>
> > Subject: Re: [RFC v2 2/3] vfio/type1: VFIO_IOMMU_PASID_REQUEST(alloc/fr=
ee)
> >=20
> > On Fri, 8 Nov 2019 12:23:41 +0000
> > "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> >  =20
> > > > From: Alex Williamson [mailto:alex.williamson@redhat.com]
> > > > Sent: Friday, November 8, 2019 6:07 AM
> > > > To: Liu, Yi L <yi.l.liu@intel.com>
> > > > Subject: Re: [RFC v2 2/3] vfio/type1: VFIO_IOMMU_PASID_REQUEST(allo=
c/free)
> > > >
> > > > On Wed, 6 Nov 2019 13:27:26 +0000
> > > > "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> > > > =20
> > > > > > From: Alex Williamson <alex.williamson@redhat.com>
> > > > > > Sent: Wednesday, November 6, 2019 7:36 AM
> > > > > > To: Liu, Yi L <yi.l.liu@intel.com>
> > > > > > Subject: Re: [RFC v2 2/3] vfio/type1: =20
> > VFIO_IOMMU_PASID_REQUEST(alloc/free) =20
> > > > > >
> > > > > > On Thu, 24 Oct 2019 08:26:22 -0400
> > > > > > Liu Yi L <yi.l.liu@intel.com> wrote:
> > > > > > =20
> > > > > > > This patch adds VFIO_IOMMU_PASID_REQUEST ioctl which aims
> > > > > > > to passdown PASID allocation/free request from the virtual
> > > > > > > iommu. This is required to get PASID managed in system-wide.
> > > > > > >
> > > > > > > Cc: Kevin Tian <kevin.tian@intel.com>
> > > > > > > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > > > > > > Signed-off-by: Yi Sun <yi.y.sun@linux.intel.com>
> > > > > > > Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > > > > > > ---
> > > > > > >  drivers/vfio/vfio_iommu_type1.c | 114 =20
> > > > > > ++++++++++++++++++++++++++++++++++++++++ =20
> > > > > > >  include/uapi/linux/vfio.h       |  25 +++++++++
> > > > > > >  2 files changed, 139 insertions(+)
> > > > > > >
> > > > > > > diff --git a/drivers/vfio/vfio_iommu_type1.c =20
> > > > b/drivers/vfio/vfio_iommu_type1.c =20
> > > > > > > index cd8d3a5..3d73a7d 100644
> > > > > > > --- a/drivers/vfio/vfio_iommu_type1.c
> > > > > > > +++ b/drivers/vfio/vfio_iommu_type1.c
> > > > > > > @@ -2248,6 +2248,83 @@ static int vfio_cache_inv_fn(struct de=
vice *dev, =20
> > > > void =20
> > > > > > *data) =20
> > > > > > >  =09return iommu_cache_invalidate(dc->domain, dev, &ustruct->=
info);
> > > > > > >  }
> > > > > > >
> > > > > > > +static int vfio_iommu_type1_pasid_alloc(struct vfio_iommu *i=
ommu,
> > > > > > > +=09=09=09=09=09 int min_pasid,
> > > > > > > +=09=09=09=09=09 int max_pasid)
> > > > > > > +{
> > > > > > > +=09int ret;
> > > > > > > +=09ioasid_t pasid;
> > > > > > > +=09struct mm_struct *mm =3D NULL;
> > > > > > > +
> > > > > > > +=09mutex_lock(&iommu->lock);
> > > > > > > +=09if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)) {
> > > > > > > +=09=09ret =3D -EINVAL;
> > > > > > > +=09=09goto out_unlock;
> > > > > > > +=09}
> > > > > > > +=09mm =3D get_task_mm(current);
> > > > > > > +=09/* Track ioasid allocation owner by mm */
> > > > > > > +=09pasid =3D ioasid_alloc((struct ioasid_set *)mm, min_pasid=
,
> > > > > > > +=09=09=09=09max_pasid, NULL); =20
> > > > > >
> > > > > > Are we sure we want to tie this to the task mm vs perhaps the
> > > > > > vfio_iommu pointer? =20
> > > > >
> > > > > Here we want to have a kind of per-VM mark, which can be used to =
do
> > > > > ownership check on whether a pasid is held by a specific VM. This=
 is
> > > > > very important to prevent across VM affect. vfio_iommu pointer is
> > > > > competent for vfio as vfio is both pasid alloc requester and pasi=
d
> > > > > consumer. e.g. vfio requests pasid alloc from ioasid and also it =
will
> > > > > invoke bind_gpasid(). vfio can either check ownership before invo=
king
> > > > > bind_gpasid() or pass vfio_iommu pointer to iommu driver. But in =
future,
> > > > > there may be other modules which are just consumers of pasid. And=
 they
> > > > > also want to do ownership check for a pasid. Then, it would be ha=
rd for
> > > > > them as they are not the pasid alloc requester. So here better to=
 have
> > > > > a system wide structure to perform as the per-VM mark. task mm lo=
oks
> > > > > to be much competent. =20
> > > >
> > > > Ok, so it's intentional to have a VM-wide token.  Elsewhere in the
> > > > type1 code (vfio_dma_do_map) we record the task_struct per dma mapp=
ing
> > > > so that we can get the task mm as needed.  Would the task_struct
> > > > pointer provide any advantage? =20
> > >
> > > I think we may use task_struct pointer to make type1 code consistent.
> > > How do you think? =20
> >=20
> > If it has the same utility, sure. =20
>=20
> thanks, I'll make this change.
>=20
> > > > Also, an overall question, this provides userspace with pasid alloc=
 and
> > > > free ioctls, (1) what prevents a userspace process from consuming e=
very
> > > > available pasid, and (2) if the process exits or crashes without
> > > > freeing pasids, how are they recovered aside from a reboot? =20
> > >
> > > For question (1), I think we only need to take care about malicious
> > > userspace process. As vfio usage is under privilege mode, so we may
> > > be safe on it so far. =20
> >=20
> > No, where else do we ever make this assumption?  vfio requires a
> > privileged entity to configure the system for vfio, bind devices for
> > user use, and grant those devices to the user, but the usage of the
> > device is always assumed to be by an unprivileged user.  It is
> > absolutely not acceptable require a privileged user.  It's vfio's
> > responsibility to protect the system from the user. =20
>=20
> My assumption is not precise here. sorry for it... Maybe to further
> check with you to better understand your point. I think the user (QEMU)
> of vfio needs to have a root permission. Thus it can open the vfio fds.
> At this point, the user is a privileged one. Also I guess that's why vfio
> can grant the user with the usage of VFIO_MAP/UNMAP to config
> mappings into iommu page tables. But I'm not quite sure when will
> the user be an unprivileged one.

QEMU does NOT need to be run as root to use vfio.  This is NOT the
model libvirt follows.  libvirt grants a user access to a device, or
rather a set of one or more devices (ie. the group) via standard file
permission access to the group file (/dev/vfio/$GROUP).  Ownership of a
device allows the user permission to make use of the IOMMU.  The user's
ability to create DMA mappings is restricted by their process locked
memory limits, where libvirt elevates the user limit sufficient for the
size of the VM.  QEMU should never need to be run as root and doing so
is entirely unacceptable from a security perspective.  The only mode of
vfio that requires elevated privilege for use is when making use of
no-iommu, where we have no IOMMU protection or translation.

> > > However, we may need to introduce a kind of credit
> > > mechanism to protect it. I've thought it, but no good idea yet. Would=
 be
> > > happy to hear from you. =20
> >=20
> > It's a limited system resource and it's unclear how many might
> > reasonably used by a user.  I don't have an easy answer. =20
>=20
> How about the below method? based on some offline chat with Jacob.
> a. some reasonable defaults for the initial per VM quota, e.g. 1000 per
> process
> b. IOASID should be able to enforce per ioasid_set (it is kind of per VM
> mark) limit

We support large numbers of assigned devices, how many IOASIDs might be
reasonably used per device?  Is the mm or the task still the correct
"set" in this scenario?  I don't have any better ideas than setting a
limit, but it probably needs a kernel or module tunable, and it needs
to match the scaling we expect to see when multiple devices are
involved.

> > > For question (2), I think we need to reclaim the allocated pasids whe=
n
> > > the vfio container fd is released just like what vfio does to the dom=
ain
> > > mappings. I didn't add it yet. But I can add it in next version if yo=
u think
> > > it would make the pasid alloc/free be much sound. =20
> >=20
> > Consider it required, the interface is susceptible to abuse without it.=
 =20
>=20
> sure, let me add it in next version.
>=20
> > > > > > > +=09if (pasid =3D=3D INVALID_IOASID) {
> > > > > > > +=09=09ret =3D -ENOSPC;
> > > > > > > +=09=09goto out_unlock;
> > > > > > > +=09}
> > > > > > > +=09ret =3D pasid;
> > > > > > > +out_unlock:
> > > > > > > +=09mutex_unlock(&iommu->lock); =20
> > > >
> > > > What does holding this lock protect?  That the vfio_iommu remains
> > > > backed by an iommu during this operation, even though we don't do
> > > > anything to release allocated pasids when that iommu backing is rem=
oved? =20
> > >
> > > yes, it is unnecessary to hold the lock here. At least for the operat=
ions in
> > > this patch. will remove it. :-)
> > > =20
> > > > > > > +=09if (mm)
> > > > > > > +=09=09mmput(mm);
> > > > > > > +=09return ret;
> > > > > > > +}
> > > > > > > +
> > > > > > > +static int vfio_iommu_type1_pasid_free(struct vfio_iommu *io=
mmu,
> > > > > > > +=09=09=09=09       unsigned int pasid)
> > > > > > > +{
> > > > > > > +=09struct mm_struct *mm =3D NULL;
> > > > > > > +=09void *pdata;
> > > > > > > +=09int ret =3D 0;
> > > > > > > +
> > > > > > > +=09mutex_lock(&iommu->lock);
> > > > > > > +=09if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)) {
> > > > > > > +=09=09ret =3D -EINVAL;
> > > > > > > +=09=09goto out_unlock;
> > > > > > > +=09}
> > > > > > > +
> > > > > > > +=09/**
> > > > > > > +=09 * REVISIT:
> > > > > > > +=09 * There are two cases free could fail:
> > > > > > > +=09 * 1. free pasid by non-owner, we use ioasid_set to track=
 mm, if
> > > > > > > +=09 * the set does not match, caller is not permitted to fre=
e.
> > > > > > > +=09 * 2. free before unbind all devices, we can check if ioa=
sid private
> > > > > > > +=09 * data, if data !=3D NULL, then fail to free.
> > > > > > > +=09 */
> > > > > > > +=09mm =3D get_task_mm(current);
> > > > > > > +=09pdata =3D ioasid_find((struct ioasid_set *)mm, pasid, NUL=
L);
> > > > > > > +=09if (IS_ERR(pdata)) {
> > > > > > > +=09=09if (pdata =3D=3D ERR_PTR(-ENOENT))
> > > > > > > +=09=09=09pr_err("PASID %u is not allocated\n", pasid);
> > > > > > > +=09=09else if (pdata =3D=3D ERR_PTR(-EACCES))
> > > > > > > +=09=09=09pr_err("Free PASID %u by non-owner, denied", =20
> > pasid); =20
> > > > > > > +=09=09else
> > > > > > > +=09=09=09pr_err("Error searching PASID %u\n", pasid); =20
> > > > > >
> > > > > > This should be removed, errno is sufficient for the user, this =
just
> > > > > > provides the user with a trivial DoS vector filling logs. =20
> > > > >
> > > > > sure, will fix it. thanks.
> > > > > =20
> > > > > > > +=09=09ret =3D -EPERM; =20
> > > > > >
> > > > > > But why not return PTR_ERR(pdata)? =20
> > > > >
> > > > > aha, would do it.
> > > > > =20
> > > > > > > +=09=09goto out_unlock;
> > > > > > > +=09}
> > > > > > > +=09if (pdata) {
> > > > > > > +=09=09pr_debug("Cannot free pasid %d with private data\n", p=
asid);
> > > > > > > +=09=09/* Expect PASID has no private data if not bond */
> > > > > > > +=09=09ret =3D -EBUSY;
> > > > > > > +=09=09goto out_unlock;
> > > > > > > +=09}
> > > > > > > +=09ioasid_free(pasid); =20
> > > > > >
> > > > > > We only ever get here with pasid =3D=3D NULL?! =20
> > > > >
> > > > > I guess you meant only when pdata=3D=3DNULL.
> > > > > =20
> > > > > > Something is wrong.  Should
> > > > > > that be 'if (!pdata)'?  (which also makes that pr_debug another=
 DoS
> > > > > > vector) =20
> > > > >
> > > > > Oh, yes, just do it as below:
> > > > >
> > > > > if (!pdata) {
> > > > > =09ioasid_free(pasid);
> > > > > =09ret =3D SUCCESS;
> > > > > } else
> > > > > =09ret =3D -EBUSY;
> > > > >
> > > > > Is it what you mean? =20
> > > >
> > > > No, I think I was just confusing pdata and pasid, but I am still
> > > > confused about testing pdata.  We call ioasid_alloc() with private =
=3D
> > > > NULL, and I don't see any of your patches calling ioasid_set_data()=
 to
> > > > change the private data after allocation, so how could this ever be
> > > > set?  Should this just be a BUG_ON(pdata) as the integrity of the
> > > > system is in question should this state ever occur?  Thanks, =20
> > >
> > > ioasid_set_data() was called  in one patch from Jacob's vSVA patchset=
.
> > > [PATCH v6 08/10] iommu/vt-d: Add bind guest PASID support
> > > https://lkml.org/lkml/2019/10/22/946
> > >
> > > The basic idea is to allocate pasid with private=3DNULL, and set it w=
hen the
> > > pasid is actually bind to a device (bind_gpasid()). Each bind_gpasid(=
) will
> > > increase the ref_cnt in the private data, and each unbind_gpasid() wi=
ll
> > > decrease the ref_cnt. So if bind/unbind_gpasid() is called in mirror,=
 the
> > > private data should be null when comes to free operation. If not, vfi=
o can
> > > believe that the pasid is still in use. =20
> >=20
> > So this is another opportunity to leak pasids.  What's a user supposed
> > to do when their attempt to free a pasid fails?  It invites leaks to
> > allow this path to fail.  Thanks, =20
>=20
> Agreed, may no need to fail pasid free as it may leak pasid. How about
> always let free successful? If the ref_cnt is non-zero, notify the remain=
ing
> users to release their reference.

If a user frees an PASID, they've done their due diligence in
indicating it's no longer used.  The kernel should handle reclaiming it
from that point.  Thanks,

Alex

