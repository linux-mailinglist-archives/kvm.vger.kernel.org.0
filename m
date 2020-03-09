Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92EB017E3B3
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 16:35:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbgCIPfk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 11:35:40 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:46013 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726825AbgCIPfk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Mar 2020 11:35:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583768137;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pr2nu3l1t8w+2D2OLv5t75+noyoBHQXcwENYqSCuw60=;
        b=SiYzKsgNWMUEu7IukOla7cXq2ZUX0BW7hK/kiXVNYKwV3o8ET5CLMEmXRdAZe1aRUP/ZkG
        M+p+hBd5eS5d+nSpzOzSRlUtwAxZVw+UA4iuBmBoGN/c+YmjbzuW9SvgXukgiHm7pbOn3F
        gCdO21Nx02DQ9bb+xBHvrXH4MbufORA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-294-to3D8B45PK-F9g12GRfXmg-1; Mon, 09 Mar 2020 11:35:33 -0400
X-MC-Unique: to3D8B45PK-F9g12GRfXmg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ACEC98017DF;
        Mon,  9 Mar 2020 15:35:31 +0000 (UTC)
Received: from w520.home (ovpn-116-28.phx2.redhat.com [10.3.116.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B8A185C28E;
        Mon,  9 Mar 2020 15:35:30 +0000 (UTC)
Date:   Mon, 9 Mar 2020 09:35:30 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dev@dpdk.org" <dev@dpdk.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "thomas@monjalon.net" <thomas@monjalon.net>,
        "bluca@debian.org" <bluca@debian.org>,
        "jerinjacobk@gmail.com" <jerinjacobk@gmail.com>,
        "Richardson, Bruce" <bruce.richardson@intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>
Subject: Re: [PATCH v2 3/7] vfio/pci: Introduce VF token
Message-ID: <20200309093530.34a3f0e1@w520.home>
In-Reply-To: <AADFC41AFE54684AB9EE6CBC0274A5D19D7C367D@SHSMSX104.ccr.corp.intel.com>
References: <158213716959.17090.8399427017403507114.stgit@gimli.home>
        <158213845243.17090.15563257812711358228.stgit@gimli.home>
        <AADFC41AFE54684AB9EE6CBC0274A5D19D79A904@SHSMSX104.ccr.corp.intel.com>
        <20200305111734.4025ce2f@w520.home>
        <AADFC41AFE54684AB9EE6CBC0274A5D19D7C084D@SHSMSX104.ccr.corp.intel.com>
        <20200306083906.13c9a762@x1.home>
        <AADFC41AFE54684AB9EE6CBC0274A5D19D7C2018@SHSMSX104.ccr.corp.intel.com>
        <20200308184606.3a670ab5@x1.home>
        <AADFC41AFE54684AB9EE6CBC0274A5D19D7C367D@SHSMSX104.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 9 Mar 2020 01:33:48 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> > From: Tian, Kevin
> > Sent: Monday, March 9, 2020 9:22 AM
> >  =20
> > > From: Alex Williamson <alex.williamson@redhat.com>
> > > Sent: Monday, March 9, 2020 8:46 AM
> > >
> > > On Sat, 7 Mar 2020 01:04:41 +0000
> > > "Tian, Kevin" <kevin.tian@intel.com> wrote:
> > > =20
> > > > > From: Alex Williamson <alex.williamson@redhat.com>
> > > > > Sent: Friday, March 6, 2020 11:39 PM
> > > > >
> > > > > On Fri, 6 Mar 2020 08:32:40 +0000
> > > > > "Tian, Kevin" <kevin.tian@intel.com> wrote:
> > > > > =20
> > > > > > > From: Alex Williamson <alex.williamson@redhat.com>
> > > > > > > Sent: Friday, March 6, 2020 2:18 AM
> > > > > > >
> > > > > > > On Tue, 25 Feb 2020 02:59:37 +0000
> > > > > > > "Tian, Kevin" <kevin.tian@intel.com> wrote:
> > > > > > > =20
> > > > > > > > > From: Alex Williamson
> > > > > > > > > Sent: Thursday, February 20, 2020 2:54 AM
> > > > > > > > >
> > > > > > > > > If we enable SR-IOV on a vfio-pci owned PF, the resulting=
 VFs are =20
> > > not =20
> > > > > > > > > fully isolated from the PF.  The PF can always cause a de=
nial of =20
> > > service =20
> > > > > > > > > to the VF, even if by simply resetting itself.  The degre=
e to which =20
> > a =20
> > > PF =20
> > > > > > > > > can access the data passed through a VF or interfere with=
 its =20
> > > > > operation =20
> > > > > > > > > is dependent on a given SR-IOV implementation.  Therefore=
 we =20
> > > want =20
> > > > > to =20
> > > > > > > > > avoid a scenario where an existing vfio-pci based userspa=
ce =20
> > driver =20
> > > > > might =20
> > > > > > > > > assume the PF driver is trusted, for example assigning a =
PF to =20
> > one =20
> > > VM =20
> > > > > > > > > and VF to another with some expectation of isolation.  IO=
MMU =20
> > > > > grouping =20
> > > > > > > > > could be a solution to this, but imposes an unnecessarily=
 strong
> > > > > > > > > relationship between PF and VF drivers if they need to op=
erate =20
> > > with =20
> > > > > the =20
> > > > > > > > > same IOMMU context.  Instead we introduce a "VF token", w=
hich =20
> > > is =20
> > > > > > > > > essentially just a shared secret between PF and VF driver=
s, =20
> > > > > implemented =20
> > > > > > > > > as a UUID.
> > > > > > > > >
> > > > > > > > > The VF token can be set by a vfio-pci based PF driver and=
 must =20
> > be =20
> > > > > known =20
> > > > > > > > > by the vfio-pci based VF driver in order to gain access t=
o the =20
> > device. =20
> > > > > > > > > This allows the degree to which this VF token is consider=
ed =20
> > secret =20
> > > to =20
> > > > > be =20
> > > > > > > > > determined by the applications and environment.  For exam=
ple a =20
> > > VM =20
> > > > > > > might =20
> > > > > > > > > generate a random UUID known only internally to the hyper=
visor =20
> > > > > while a =20
> > > > > > > > > userspace networking appliance might use a shared, or eve=
n well =20
> > > > > know, =20
> > > > > > > > > UUID among the application drivers.
> > > > > > > > >
> > > > > > > > > To incorporate this VF token, the VFIO_GROUP_GET_DEVICE_F=
D =20
> > > > > interface =20
> > > > > > > is =20
> > > > > > > > > extended to accept key=3Dvalue pairs in addition to the d=
evice =20
> > name. =20
> > > > > This =20
> > > > > > > > > allows us to most easily deny user access to the device w=
ithout =20
> > risk =20
> > > > > > > > > that existing userspace drivers assume region offsets, IR=
Qs, and =20
> > > other =20
> > > > > > > > > device features, leading to more elaborate error paths.  =
The =20
> > > format of =20
> > > > > > > > > these options are expected to take the form:
> > > > > > > > >
> > > > > > > > > "$DEVICE_NAME $OPTION1=3D$VALUE1 $OPTION2=3D$VALUE2"
> > > > > > > > >
> > > > > > > > > Where the device name is always provided first for compat=
ibility =20
> > > and =20
> > > > > > > > > additional options are specified in a space separated lis=
t.  The
> > > > > > > > > relation between and requirements for the additional opti=
ons =20
> > will =20
> > > be =20
> > > > > > > > > vfio bus driver dependent, however unknown or unused opti=
on =20
> > > > > within =20
> > > > > > > this =20
> > > > > > > > > schema should return error.  This allow for future use of=
 =20
> > unknown =20
> > > > > > > > > options as well as a positive indication to the user that=
 an option =20
> > is =20
> > > > > > > > > used.
> > > > > > > > >
> > > > > > > > > An example VF token option would take this form:
> > > > > > > > >
> > > > > > > > > "0000:03:00.0 vf_token=3D2ab74924-c335-45f4-9b16- =20
> > 8569e5b08258" =20
> > > > > > > > >
> > > > > > > > > When accessing a VF where the PF is making use of vfio-pc=
i, the =20
> > > user =20
> > > > > > > > > MUST provide the current vf_token.  When accessing a PF, =
the =20
> > > user =20
> > > > > MUST =20
> > > > > > > > > provide the current vf_token IF there are active VF users=
 or MAY =20
> > > > > provide =20
> > > > > > > > > a vf_token in order to set the current VF token when no V=
F users =20
> > > are =20
> > > > > > > > > active.  The former requirement assures VF users that an =
=20
> > > > > unassociated =20
> > > > > > > > > driver cannot usurp the PF device.  These semantics also =
imply =20
> > that =20
> > > a =20
> > > > > > > > > VF token MUST be set by a PF driver before VF drivers can=
 access =20
> > > their =20
> > > > > > > > > device, the default token is random and mechanisms to rea=
d the =20
> > > > > token =20
> > > > > > > are =20
> > > > > > > > > not provided in order to protect the VF token of previous=
 users. =20
> > > Use =20
> > > > > of =20
> > > > > > > > > the vf_token option outside of these cases will return an=
 error, =20
> > as =20
> > > > > > > > > discussed above.
> > > > > > > > >
> > > > > > > > > Signed-off-by: Alex Williamson <alex.williamson@redhat.co=
m>
> > > > > > > > > ---
> > > > > > > > >  drivers/vfio/pci/vfio_pci.c         |  198
> > > > > > > > > +++++++++++++++++++++++++++++++++++
> > > > > > > > >  drivers/vfio/pci/vfio_pci_private.h |    8 +
> > > > > > > > >  2 files changed, 205 insertions(+), 1 deletion(-)
> > > > > > > > >
> > > > > > > > > diff --git a/drivers/vfio/pci/vfio_pci.c =20
> > b/drivers/vfio/pci/vfio_pci.c =20
> > > > > > > > > index 2ec6c31d0ab0..8dd6ef9543ca 100644
> > > > > > > > > --- a/drivers/vfio/pci/vfio_pci.c
> > > > > > > > > +++ b/drivers/vfio/pci/vfio_pci.c
> > > > > > > > > @@ -466,6 +466,44 @@ static void vfio_pci_disable(struct =
=20
> > > > > > > vfio_pci_device =20
> > > > > > > > > *vdev)
> > > > > > > > >  		vfio_pci_set_power_state(vdev, PCI_D3hot);
> > > > > > > > >  }
> > > > > > > > >
> > > > > > > > > +static struct pci_driver vfio_pci_driver;
> > > > > > > > > +
> > > > > > > > > +static struct vfio_pci_device *get_pf_vdev(struct vfio_p=
ci_device =20
> > > > > *vdev, =20
> > > > > > > > > +					   struct vfio_device **pf_dev)
> > > > > > > > > +{
> > > > > > > > > +	struct pci_dev *physfn =3D pci_physfn(vdev->pdev);
> > > > > > > > > +
> > > > > > > > > +	if (!vdev->pdev->is_virtfn)
> > > > > > > > > +		return NULL;
> > > > > > > > > +
> > > > > > > > > +	*pf_dev =3D vfio_device_get_from_dev(&physfn->dev);
> > > > > > > > > +	if (!*pf_dev)
> > > > > > > > > +		return NULL;
> > > > > > > > > +
> > > > > > > > > +	if (pci_dev_driver(physfn) !=3D &vfio_pci_driver) {
> > > > > > > > > +		vfio_device_put(*pf_dev);
> > > > > > > > > +		return NULL;
> > > > > > > > > +	}
> > > > > > > > > +
> > > > > > > > > +	return vfio_device_data(*pf_dev);
> > > > > > > > > +}
> > > > > > > > > +
> > > > > > > > > +static void vfio_pci_vf_token_user_add(struct vfio_pci_d=
evice =20
> > > *vdev, =20
> > > > > int =20
> > > > > > > val) =20
> > > > > > > > > +{
> > > > > > > > > +	struct vfio_device *pf_dev;
> > > > > > > > > +	struct vfio_pci_device *pf_vdev =3D get_pf_vdev(vdev, =
=20
> > > > > &pf_dev); =20
> > > > > > > > > +
> > > > > > > > > +	if (!pf_vdev)
> > > > > > > > > +		return;
> > > > > > > > > +
> > > > > > > > > +	mutex_lock(&pf_vdev->vf_token->lock);
> > > > > > > > > +	pf_vdev->vf_token->users +=3D val;
> > > > > > > > > +	WARN_ON(pf_vdev->vf_token->users < 0);
> > > > > > > > > +	mutex_unlock(&pf_vdev->vf_token->lock);
> > > > > > > > > +
> > > > > > > > > +	vfio_device_put(pf_dev);
> > > > > > > > > +}
> > > > > > > > > +
> > > > > > > > >  static void vfio_pci_release(void *device_data)
> > > > > > > > >  {
> > > > > > > > >  	struct vfio_pci_device *vdev =3D device_data;
> > > > > > > > > @@ -473,6 +511,7 @@ static void vfio_pci_release(void =20
> > > *device_data) =20
> > > > > > > > >  	mutex_lock(&vdev->reflck->lock);
> > > > > > > > >
> > > > > > > > >  	if (!(--vdev->refcnt)) {
> > > > > > > > > +		vfio_pci_vf_token_user_add(vdev, -1);
> > > > > > > > >  		vfio_spapr_pci_eeh_release(vdev->pdev);
> > > > > > > > >  		vfio_pci_disable(vdev);
> > > > > > > > >  	}
> > > > > > > > > @@ -498,6 +537,7 @@ static int vfio_pci_open(void =20
> > *device_data) =20
> > > > > > > > >  			goto error;
> > > > > > > > >
> > > > > > > > >  		vfio_spapr_pci_eeh_open(vdev->pdev);
> > > > > > > > > +		vfio_pci_vf_token_user_add(vdev, 1);
> > > > > > > > >  	}
> > > > > > > > >  	vdev->refcnt++;
> > > > > > > > >  error:
> > > > > > > > > @@ -1278,11 +1318,148 @@ static void vfio_pci_request(voi=
d =20
> > > > > > > *device_data, =20
> > > > > > > > > unsigned int count)
> > > > > > > > >  	mutex_unlock(&vdev->igate);
> > > > > > > > >  }
> > > > > > > > >
> > > > > > > > > +static int vfio_pci_validate_vf_token(struct vfio_pci_de=
vice =20
> > *vdev, =20
> > > > > > > > > +				      bool vf_token, uuid_t *uuid)
> > > > > > > > > +{
> > > > > > > > > +	/*
> > > > > > > > > +	 * There's always some degree of trust or collaboration=
 =20
> > > > > between SR- =20
> > > > > > > > > IOV
> > > > > > > > > +	 * PF and VFs, even if just that the PF hosts the SR-IO=
V =20
> > > > > capability and =20
> > > > > > > > > +	 * can disrupt VFs with a reset, but often the PF has m=
ore =20
> > > > > explicit =20
> > > > > > > > > +	 * access to deny service to the VF or access data pass=
ed =20
> > > > > through the =20
> > > > > > > > > +	 * VF.  We therefore require an opt-in via a shared VF =
token =20
> > > > > (UUID) =20
> > > > > > > > > to
> > > > > > > > > +	 * represent this trust.  This both prevents that a VF =
driver =20
> > > > > might =20
> > > > > > > > > +	 * assume the PF driver is a trusted, in-kernel driver,=
 and also =20
> > > > > that =20
> > > > > > > > > +	 * a PF driver might be replaced with a rogue driver, u=
nknown =20
> > > > > to in- =20
> > > > > > > > > use
> > > > > > > > > +	 * VF drivers.
> > > > > > > > > +	 *
> > > > > > > > > +	 * Therefore when presented with a VF, if the PF is a v=
fio =20
> > > > > device and =20
> > > > > > > > > +	 * it is bound to the vfio-pci driver, the user needs t=
o provide =20
> > > > > a VF =20
> > > > > > > > > +	 * token to access the device, in the form of appending=
 a =20
> > > > > vf_token to =20
> > > > > > > > > +	 * the device name, for example:
> > > > > > > > > +	 *
> > > > > > > > > +	 * "0000:04:10.0 vf_token=3Dbd8d9d2b-5a5f-4f5a-a211- =20
> > > > > f591514ba1f3" =20
> > > > > > > > > +	 *
> > > > > > > > > +	 * When presented with a PF which has VFs in use, the u=
ser =20
> > > > > must also =20
> > > > > > > > > +	 * provide the current VF token to prove collaboration =
with =20
> > > > > existing =20
> > > > > > > > > +	 * VF users.  If VFs are not in use, the VF token provi=
ded for =20
> > > > > the PF =20
> > > > > > > > > +	 * device will act to set the VF token.
> > > > > > > > > +	 *
> > > > > > > > > +	 * If the VF token is provided but unused, a fault is g=
enerated. =20
> > > > > > > >
> > > > > > > > fault->error, otherwise it is easy to consider a CPU fault.=
 =F0=9F=98=8A =20
> > > > > > >
> > > > > > > Ok, I can make that change, but I think you might have a uniq=
ue
> > > > > > > background to make a leap that a userspace ioctl can trigger =
a CPU
> > > > > > > fault ;)
> > > > > > > =20
> > > > > > > > > +	 */
> > > > > > > > > +	if (!vdev->pdev->is_virtfn && !vdev->vf_token && !vf_to=
ken)
> > > > > > > > > +		return 0; /* No VF token provided or required */
> > > > > > > > > +
> > > > > > > > > +	if (vdev->pdev->is_virtfn) {
> > > > > > > > > +		struct vfio_device *pf_dev;
> > > > > > > > > +		struct vfio_pci_device *pf_vdev =3D get_pf_vdev(vdev,
> > > > > > > > > &pf_dev);
> > > > > > > > > +		bool match;
> > > > > > > > > +
> > > > > > > > > +		if (!pf_vdev) {
> > > > > > > > > +			if (!vf_token)
> > > > > > > > > +				return 0; /* PF is not vfio-pci, no VF =20
> > > > > token */ =20
> > > > > > > > > +
> > > > > > > > > +			pci_info_ratelimited(vdev->pdev,
> > > > > > > > > +				"VF token incorrectly provided, PF not =20
> > > > > bound =20
> > > > > > > > > to vfio-pci\n");
> > > > > > > > > +			return -EINVAL;
> > > > > > > > > +		}
> > > > > > > > > +
> > > > > > > > > +		if (!vf_token) {
> > > > > > > > > +			vfio_device_put(pf_dev);
> > > > > > > > > +			pci_info_ratelimited(vdev->pdev,
> > > > > > > > > +				"VF token required to access =20
> > > > > device\n"); =20
> > > > > > > > > +			return -EACCES;
> > > > > > > > > +		}
> > > > > > > > > +
> > > > > > > > > +		mutex_lock(&pf_vdev->vf_token->lock);
> > > > > > > > > +		match =3D uuid_equal(uuid, &pf_vdev->vf_token- =20
> > > > > >uuid); =20
> > > > > > > > > +		mutex_unlock(&pf_vdev->vf_token->lock);
> > > > > > > > > +
> > > > > > > > > +		vfio_device_put(pf_dev);
> > > > > > > > > +
> > > > > > > > > +		if (!match) {
> > > > > > > > > +			pci_info_ratelimited(vdev->pdev,
> > > > > > > > > +				"Incorrect VF token provided for =20
> > > > > device\n"); =20
> > > > > > > > > +			return -EACCES;
> > > > > > > > > +		}
> > > > > > > > > +	} else if (vdev->vf_token) {
> > > > > > > > > +		mutex_lock(&vdev->vf_token->lock);
> > > > > > > > > +		if (vdev->vf_token->users) {
> > > > > > > > > +			if (!vf_token) {
> > > > > > > > > +				mutex_unlock(&vdev->vf_token- =20
> > > > > >lock); =20
> > > > > > > > > +				pci_info_ratelimited(vdev->pdev,
> > > > > > > > > +					"VF token required to access
> > > > > > > > > device\n");
> > > > > > > > > +				return -EACCES;
> > > > > > > > > +			}
> > > > > > > > > +
> > > > > > > > > +			if (!uuid_equal(uuid, &vdev->vf_token->uuid)) =20
> > > > > { =20
> > > > > > > > > +				mutex_unlock(&vdev->vf_token- =20
> > > > > >lock); =20
> > > > > > > > > +				pci_info_ratelimited(vdev->pdev,
> > > > > > > > > +					"Incorrect VF token provided =20
> > > > > for =20
> > > > > > > > > device\n");
> > > > > > > > > +				return -EACCES;
> > > > > > > > > +			}
> > > > > > > > > +		} else if (vf_token) {
> > > > > > > > > +			uuid_copy(&vdev->vf_token->uuid, uuid);
> > > > > > > > > +		} =20
> > > > > > > >
> > > > > > > > It implies that we allow PF to be accessed w/o providing a =
VF token,
> > > > > > > > as long as no VF is currently in-use, which further means n=
o VF can
> > > > > > > > be further assigned since no one knows the random uuid allo=
cated
> > > > > > > > by vfio. Just want to confirm whether it is the desired fla=
vor. If an
> > > > > > > > user really wants to use PF-only, possibly he should disabl=
e SR-IOV
> > > > > > > > instead... =20
> > > > > > >
> > > > > > > Yes, this is the behavior I'm intending.  Are you suggesting =
that we
> > > > > > > should require a VF token in order to access a PF that has SR=
-IOV
> > > > > > > already enabled?  This introduces an inconsistency that SR-IO=
V can =20
> > be =20
> > > > > >
> > > > > > yes. I felt that it's meaningless otherwise if an user has no a=
ttempt to
> > > > > > manage SR-IOV but still leaving it enabled. In many cases, enab=
ling of
> > > > > > SR-IOV may reserve some resource in the hardware, thus simply =
=20
> > hurting =20
> > > > > > PF performance. =20
> > > > >
> > > > > But a user needs to be granted access to a device by a privileged
> > > > > entity and the privileged entity may also enable SR-IOV, so it se=
ems
> > > > > you're assuming the privileged entity is operating independently =
and
> > > > > not in the best interest of enabling the specific user case. =20
> > > >
> > > > what about throwing out a warning for such situation? so the usersp=
ace
> > > > knows some collaboration is missing before its access to the device=
. =20
> > >
> > > This seems arbitrary.  pci-pf-stub proves to us that there are devices
> > > that need no special setup for SR-IOV, we don't know that we don't ha=
ve
> > > such a device.  Enabling SR-IOV after the user opens the device also =
=20
>=20
> btw no special setup doesn't mean that a PF driver cannot do bad thing to=
=20
> VFs. In such case, I think the whole token idea should be still applied.

pci-pf-stub is a native host driver that does not provide access to the
device to userspace.  We trust native host drivers, whether they be
pci-pf-stub, igb, ixgbe, i40e, etc.  We don't require a token to attach
a userspace driver to a VF of one of these PF drivers because we trust
them.  The VF token idea is exclusively for cases where the PF driver
is an untrusted userspace driver.

> > > doesn't indicate there's necessarily collaboration between the two, so
> > > if we generate a warning on one, how do we assume the other is ok?  I
> > > don't really understand why this is generating such concern.  Thanks,=
 =20
>=20
> specifically I feel we should warn both:
>=20
> 1) userspace driver GET_DEVICE_FD w/o providing a token on a PF
> which has SR-IOV already enabled
> 2) admin writes non-zero numvfs to a PF which has already bound to
> userspace driver which doesn't provide a token
>=20
> in both cases VFs are enabled but cannot be used (if you agree that
> the token idea should be also applied to 'no special setup' case)

Both of these seem to be imposing an ordering requirement simply for the
sake of generating a warning.  Nothing else requires that ordering.  In
case 1), it's just as legitimate for the user to call
VFIO_DEVICE_FEATURE to set the token after they've opened the device.
Perhaps the user would even look at config space via the vfio-pci API
in order to determine that SR-IOV is enabled and set a token.  In case
2), the user driver may choose not to set a token until VFs have been
successfully created.

> > I meant to warn the suboptimal case where the userspace driver doesn't
> > provide a token when accessing a PF which has SR-IOV already enabled.
> > I don't think a sane configuration/coordination should do this since all
> > VFs are simply wasted and instead may hurt the PF performance...

*May* hurt performance, but we don't know.  Some designs might have
resources dedicated to VFs that aren't used by the PF at all.  As I've
experimented with this patch series, I find that an igb PF with SR-IOV
enabled assigned to a VM doesn't work at all, it's not simply a
performance issue.  I suspect that's going to be a clue to the user
that their configuration is invalid.  I'm sure we'll take some support
overhead as a result of that, but I don't see that we can generate an
arbitrary advisement warning when it very well might be supported on
other devices.  This is the nature of a meta driver that supports any
device bound to it.  Thanks,

Alex

