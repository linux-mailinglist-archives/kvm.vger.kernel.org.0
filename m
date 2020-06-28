Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8D820C5B4
	for <lists+kvm@lfdr.de>; Sun, 28 Jun 2020 06:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726042AbgF1EWu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 28 Jun 2020 00:22:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:31778 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725965AbgF1EWt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 28 Jun 2020 00:22:49 -0400
IronPort-SDR: wh6vsxY6pasuiMjCPqayP3Wu0heqvWs/6dPmd5k5DAsUtywQDB0vFiSQLwvM6YgMQUI4Sg1jic
 NZkAeL8/GvmA==
X-IronPort-AV: E=McAfee;i="6000,8403,9665"; a="134085535"
X-IronPort-AV: E=Sophos;i="5.75,290,1589266800"; 
   d="scan'208";a="134085535"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2020 21:22:48 -0700
IronPort-SDR: +KPFkKeH2aWFV7wYMgIPp/ALvsPKkhm5ksRdVG5D1QepdcDTGQ4XogEQyf4vNmjsO79s620F9o
 yOkF4m+jGKMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,290,1589266800"; 
   d="scan'208";a="386103928"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by fmsmga001.fm.intel.com with ESMTP; 27 Jun 2020 21:22:48 -0700
Received: from fmsmsx102.amr.corp.intel.com (10.18.124.200) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sat, 27 Jun 2020 21:22:46 -0700
Received: from FMSEDG002.ED.cps.intel.com (10.1.192.134) by
 FMSMSX102.amr.corp.intel.com (10.18.124.200) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sat, 27 Jun 2020 21:22:46 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (104.47.38.55) by
 edgegateway.intel.com (192.55.55.69) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Sat, 27 Jun 2020 21:22:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cxf3BeuLImgF2T5t9Qm4SYzYMcwH37q/5JRh5aL7CEE7cFBAX1kqyaFXixHsPMnqmBYhzxTVdDoq7Suk74dwJdpuW/4omlnrptyrA1rtEF8d0mQiNeTQs1PjZ7u4zvXv3OP0r/GwPsivA5k/JIW755/4F5IHfkgIe4L3ZF0+GntRPMXcGVDqs7Ju4m0WalSCZGUaZtWGyqQoezF0XPwii23EXVkd8joz1yvqVqjFqHyaM/+iIwnL+3tWv85BrF0+FV0fSOuqmDLJHefl9y4LFpmSc3QjLwlurFIlqh685ncaevS0sqar6S7HjEwqBqfTZp4AMXmzThX1qiM4LXBczA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hw97KHXF+pBs1Ea1eTMsylJHvVQwlRE0teDIOOw0Zu8=;
 b=TjPOk07zpOn54IiD2wSEwaRgYaw5jfTiWJ+Tfgz+VToDQOiFfLIdwE2ZP/Gu0Trfqg0KkJLVzRsnHqCPmq2d3eHP38K7EhIuTdf2uZ63E3Sx+XDDIgIaGOyjW0Sk5zbMt20aU+g2NjOTETvygDRG8W2AGC3t8HFAm0e1OqjSlc9N0hhen3vrn/Jo9lXS7ASi3ifoH/SVRmOyoFDk4djRuuh5RcrHRAtwEkn9Cbd5f98xmnJLdnqSoONb3UlX7jUqc8zVjVrAm4+v92NA87/iU6xF9FQISvUyI32epptDiKVe31ymo7PW+niEEHl7ljc0WkUCZfftB7VRMQb+LrW8Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hw97KHXF+pBs1Ea1eTMsylJHvVQwlRE0teDIOOw0Zu8=;
 b=c5gAf5wqzxG5p/iW7XjTaST3W1KUxkVa5svOKYowWP2hWBF7KC4ySPxHjTNpBxM0baDo+M2Wc8hViY5b1noP6iJ9HVq/4GC9lUaOrnzAEcZ7/BsyfyR+QixKoALIiW0Lvp7OtBKU+EtpXYSNbUirEgLBd9+oR3JLzKTSKCBFfmo=
Received: from BN8PR11MB3795.namprd11.prod.outlook.com (2603:10b6:408:82::31)
 by BN8PR11MB3634.namprd11.prod.outlook.com (2603:10b6:408:88::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.25; Sun, 28 Jun
 2020 04:22:23 +0000
Received: from BN8PR11MB3795.namprd11.prod.outlook.com
 ([fe80::c96e:e522:e0dc:490c]) by BN8PR11MB3795.namprd11.prod.outlook.com
 ([fe80::c96e:e522:e0dc:490c%7]) with mapi id 15.20.3131.026; Sun, 28 Jun 2020
 04:22:23 +0000
From:   "Wang, Haiyue" <haiyue.wang@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "maxime.coquelin@redhat.com" <maxime.coquelin@redhat.com>,
        David Marchand <david.marchand@redhat.com>,
        Kevin Traynor <ktraynor@redhat.com>
Subject: RE: [PATCH] vfio/pci: Fix SR-IOV VF handling with MMIO blocking
Thread-Topic: [PATCH] vfio/pci: Fix SR-IOV VF handling with MMIO blocking
Thread-Index: AQHWSxHG3MhsyYc5LU2HHyb99u21najtWeJwgAATpACAAACcoA==
Date:   Sun, 28 Jun 2020 04:22:23 +0000
Message-ID: <BN8PR11MB379514FADAAA03FC8A63F3FDF7910@BN8PR11MB3795.namprd11.prod.outlook.com>
References: <159310421505.27590.16617666489295503039.stgit@gimli.home>
        <BN8PR11MB3795C3338B3C7F67A6EDB43AF7910@BN8PR11MB3795.namprd11.prod.outlook.com>
 <20200627220852.13b3fa7f@x1.home>
In-Reply-To: <20200627220852.13b3fa7f@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.196]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6b4d6ae7-708e-4e47-3989-08d81b1adb57
x-ms-traffictypediagnostic: BN8PR11MB3634:
x-microsoft-antispam-prvs: <BN8PR11MB3634781946FC9EFF83AE7135F7910@BN8PR11MB3634.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0448A97BF2
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7l2LSwjl3z2i7LmHp7XdV/E+1+WSPoUBdmBmrGPL6nHIhmEfIvdaBai6blyDJZsaJ7fM+HG5B6uoiJELUC9ikTzfa13xeYUm996slQeqv2i4X7fffP4gGjo+g+cFsz+3a8Su7D82rpjaoFPyT2qjRoqriKe/UwAKVfjDqTJJN2KFBoC6bCAp3cy9AR3+u9H4qbFICNca8zL76FHhQnk5ceN4r/JLrKKVFoxqytGt4akIaY+oJ2hi7CSHkHzusIjqmSM4F2+L6bCa7Dca+cioeKfqDcap85sC9ZBtRjAuHrcbNR2DalO5BXMymfgu5uPbYX9FAFNbXik3Z9tEg5OdQeyC7A9O/+beceMguE+I9GXvTIlYYyYWifCTNd5emPtvwPfSArtGuBSdatQWpway6Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR11MB3795.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(366004)(39860400002)(346002)(376002)(478600001)(53546011)(8676002)(71200400001)(66946007)(64756008)(4326008)(83380400001)(8936002)(66476007)(66556008)(66446008)(52536014)(5660300002)(26005)(966005)(76116006)(7696005)(6506007)(55016002)(186003)(86362001)(6916009)(2906002)(316002)(54906003)(9686003)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 3zchJ6DG/8U259rlWw3hT5kgZHfR8eo8MKlhXyrtBbprb1J3MY61g4TZxVmzuiTwD8rHeXK2lXGXdROhPLHlvvIbxyv/VqdQqOEmN1zY2X0lvb8dAxl4XupPJLEspKNeoJwAs1gC7Etuhpsn+dXpWazqNUAlWjOgcgplWDwL50Rks1ucCf+piCmAylctSfiLBN74wH5NuHwaSfOXT12NFW4Qc6EUi3M1t16Y8TwJQDWdNPTYieT++jfjoi46lMMCp0r/c1MeNWia+Dy3nVoYonEZKpK/ROpFAZhQ5IjBz+Gyb4a6K05DTd3wyLTb2+47zLFDK7Gg9g/lGwmWQQpLAP/D+T9lr7nHVxOTYZ2u0jbdyjdOacpfp2oKNWLZISItFjkWyKwGmLRPzYqQmQ8WyjyOaA9Osfz1SBRtKjVubvjuNTuTL3slNzFAtX6PdCY+1IacLKyGqJ9CBMqdy0bCVgH+nIc1GgPnm8NBU0y9DW2j4OPcHfqqHGveUGnAP5z3
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN8PR11MB3795.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b4d6ae7-708e-4e47-3989-08d81b1adb57
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2020 04:22:23.5311
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PkP8mACLFPR6XJORe/vD+yswvv1NnE41K7ipFYtDlonQaHLn8UtbQqmVznd1G4RQnUgLJFZR+HEz6vqfe/lu4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3634
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> -----Original Message-----
> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Sunday, June 28, 2020 12:09
> To: Wang, Haiyue <haiyue.wang@intel.com>
> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org; maxime.coquelin@re=
dhat.com; David Marchand
> <david.marchand@redhat.com>; Kevin Traynor <ktraynor@redhat.com>
> Subject: Re: [PATCH] vfio/pci: Fix SR-IOV VF handling with MMIO blocking
>=20
> On Sun, 28 Jun 2020 03:12:12 +0000
> "Wang, Haiyue" <haiyue.wang@intel.com> wrote:
>=20
> > > -----Original Message-----
> > > From: kvm-owner@vger.kernel.org <kvm-owner@vger.kernel.org> On Behalf=
 Of Alex Williamson
> > > Sent: Friday, June 26, 2020 00:57
> > > To: alex.williamson@redhat.com
> > > Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org; maxime.coqueli=
n@redhat.com
> > > Subject: [PATCH] vfio/pci: Fix SR-IOV VF handling with MMIO blocking
> > >
> > > SR-IOV VFs do not implement the memory enable bit of the command
> > > register, therefore this bit is not set in config space after
> > > pci_enable_device().  This leads to an unintended difference
> > > between PF and VF in hand-off state to the user.  We can correct
> > > this by setting the initial value of the memory enable bit in our
> > > virtualized config space.  There's really no need however to
> > > ever fault a user on a VF though as this would only indicate an
> > > error in the user's management of the enable bit, versus a PF
> > > where the same access could trigger hardware faults.
> > >
> > > Fixes: abafbc551fdd ("vfio-pci: Invalidate mmaps and block MMIO acces=
s on disabled memory")
> > > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > > ---
> > >  drivers/vfio/pci/vfio_pci_config.c |   17 ++++++++++++++++-
> > >  1 file changed, 16 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vf=
io_pci_config.c
> > > index 8746c943247a..d98843feddce 100644
> > > --- a/drivers/vfio/pci/vfio_pci_config.c
> > > +++ b/drivers/vfio/pci/vfio_pci_config.c
> > > @@ -398,9 +398,15 @@ static inline void p_setd(struct perm_bits *p, i=
nt off, u32 virt, u32 write)
> > >  /* Caller should hold memory_lock semaphore */
> > >  bool __vfio_pci_memory_enabled(struct vfio_pci_device *vdev)
> > >  {
> > > +	struct pci_dev *pdev =3D vdev->pdev;
> > >  	u16 cmd =3D le16_to_cpu(*(__le16 *)&vdev->vconfig[PCI_COMMAND]);
> > >
> > > -	return cmd & PCI_COMMAND_MEMORY;
> > > +	/*
> > > +	 * SR-IOV VF memory enable is handled by the MSE bit in the
> > > +	 * PF SR-IOV capability, there's therefore no need to trigger
> > > +	 * faults based on the virtual value.
> > > +	 */
> > > +	return pdev->is_virtfn || (cmd & PCI_COMMAND_MEMORY);
> >
> > Hi Alex,
> >
> > After set up the initial copy of config space for memory enable bit for=
 VF, is it worth
> > to trigger SIGBUS into the bad user space process which intentionally t=
ry to disable the
> > memory access command (even it is VF) then access the memory to trigger=
 CVE-2020-12888 ?
>=20
> We're essentially only trying to catch the user in mismanaging the
> enable bit if we trigger a fault based on the virtualized enabled bit,
> right?  There's no risk that the VF would trigger a UR based on the
> state of our virtual enable bit.  So is it worth triggering a user
> fault when, for instance, the user might be aware that the device is a
> VF and know that the memory enable bit is not relative to the physical

Emm .. I read the CVE attack description from: https://bugzilla.redhat.com/=
show_bug.cgi?id=3D1836244,
I thought it should also prevent the bad Guest VM, thanks for sharing the b=
ackground more.

BR,
Haiyue

> device?  Thanks,
>=20
> Alex
>=20
> > >  }
> > >
> > >  /*
> > > @@ -1728,6 +1734,15 @@ int vfio_config_init(struct vfio_pci_device *v=
dev)
> > >  				 vconfig[PCI_INTERRUPT_PIN]);
> > >
> > >  		vconfig[PCI_INTERRUPT_PIN] =3D 0; /* Gratuitous for good VFs */
> > > +
> > > +		/*
> > > +		 * VFs do no implement the memory enable bit of the COMMAND
> > > +		 * register therefore we'll not have it set in our initial
> > > +		 * copy of config space after pci_enable_device().  For
> > > +		 * consistency with PFs, set the virtual enable bit here.
> > > +		 */
> > > +		*(__le16 *)&vconfig[PCI_COMMAND] |=3D
> > > +					cpu_to_le16(PCI_COMMAND_MEMORY);
> > >  	}
> > >
> > >  	if (!IS_ENABLED(CONFIG_VFIO_PCI_INTX) || vdev->nointx)
> >

