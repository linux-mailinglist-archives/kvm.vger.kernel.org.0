Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DAB9204A1B
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 08:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730793AbgFWGoA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 02:44:00 -0400
Received: from mga18.intel.com ([134.134.136.126]:26234 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730635AbgFWGn7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 02:43:59 -0400
IronPort-SDR: 0HgRcXXQBRSCRLQacXHLqbK0aCxjjEq16lFIWOzLBhJBN7Oe3vH/fNjEDMawN2FNrc8zOhAh/C
 LnwmqsMzzsPw==
X-IronPort-AV: E=McAfee;i="6000,8403,9660"; a="131392280"
X-IronPort-AV: E=Sophos;i="5.75,270,1589266800"; 
   d="scan'208";a="131392280"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2020 23:43:57 -0700
IronPort-SDR: gRyOhPTSYh3q8zWeBbY+U921fRQR9fqVt4htZy6NbsKmJMCeRQ7Nhoy5UNQYLHmF/0gtiKjSLR
 dJXNQjnUJ1Yg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,270,1589266800"; 
   d="scan'208";a="452112000"
Received: from orsmsx106.amr.corp.intel.com ([10.22.225.133])
  by orsmga005.jf.intel.com with ESMTP; 22 Jun 2020 23:43:57 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX106.amr.corp.intel.com (10.22.225.133) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 22 Jun 2020 23:43:57 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 22 Jun 2020 23:43:57 -0700
Received: from ORSEDG002.ED.cps.intel.com (10.7.248.5) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 22 Jun 2020 23:43:57 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (134.134.137.101) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 22 Jun 2020 23:43:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nP8TBDz1Uu6ygKRNFv/0qLfLsHYj9Nxi/CCwp+GbEYfC7m0xWSFPFvt3FEVGtDWUzo2z3s8FNFjQWPHM8xL5S042TAYerZqzuw4Phy8H7QnEiY0PBl3BSoiKR50WC8Ve5S2fglfBHwt51Qmb9RxrRvhsHhB4jLzsmgBgALq0Xhz6GmbbRnKzwDAQDhU7ZpozkWkX+zGAvUkNGAAlyDpakRb19z7Q95+ssT7VoudWKpuWur/3rXlIeqbS3aQHZHrwKq4WzmEuj2PRP+N6+S9sjyZO1/PdCNZ/UoeVfYNVvrV1a/I00I0cR/wRgJ7qPLTXZaISwH54wDTYSMWQRAqO8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GZed6e6lLPqftRY0AmBrf0V0x+yCfEMnEYvTMTsNQ40=;
 b=NrXOgFhMBGLzyFp+vqTeRXqa0TY2b8Z7ZnGto8Ufb9t1uwPRW9a5Z/89uLCHUbmiEcfhNfDbk+OiUsMsoAs6Oku/dsPwDY3paQOJBTfY/Ugd94Z6mIyJ7G8Pq0PVqWOGKvqAO632njMwB3ssfm3NpQxBeGa6tz8VlnJcLgpuSFAR8QWzOcethm8wHE3DwqPFMSI5e61MgUr5l6ejV3buhrqz5H0HU//1FbD1uWEjqTxruatymHPreOvL+S3zgtjmPMzfsEx9qtPAQocCAKrKSZWps6/SO/mkr64XCAwIeFzIJeLEW8ZZvKm7CTEoMNHESA+Z2STue/vH6a+DTFYBCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GZed6e6lLPqftRY0AmBrf0V0x+yCfEMnEYvTMTsNQ40=;
 b=UVJ9/QPkWpz5r14PzASX+h1OhQ7nebc36PwNBxKCSB/HF/vet0P4e8jW98YDDoEYSd8XWY1pFK47e16dv4srINGBN3hdiDxjKxK9htHm/YozXbiCcCkKdznnjfzSYs6i4pkkphTB7YT3d/QZ+nAs2XrefEfxwxDgrSadVt3NxHE=
Received: from DM5PR11MB1435.namprd11.prod.outlook.com (2603:10b6:4:7::18) by
 DM5PR1101MB2265.namprd11.prod.outlook.com (2603:10b6:4:50::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3109.22; Tue, 23 Jun 2020 06:43:55 +0000
Received: from DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::2c3d:98d9:4e81:c86c]) by DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::2c3d:98d9:4e81:c86c%6]) with mapi id 15.20.3109.027; Tue, 23 Jun 2020
 06:43:55 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Stefan Hajnoczi <stefanha@gmail.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Wu, Hao" <hao.wu@intel.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 14/15] vfio: Document dual stage control
Thread-Topic: [PATCH v2 14/15] vfio: Document dual stage control
Thread-Index: AQHWP+klJ2WDrhzcJUGl5z7dUgTydqjZcnYAgALkw9CACFCUAIABK3hA
Date:   Tue, 23 Jun 2020 06:43:54 +0000
Message-ID: <DM5PR11MB1435B5A1D25A245AD5E3B6D3C3940@DM5PR11MB1435.namprd11.prod.outlook.com>
References: <1591877734-66527-1-git-send-email-yi.l.liu@intel.com>
 <1591877734-66527-15-git-send-email-yi.l.liu@intel.com>
 <20200615094128.GB1491454@stefanha-x1.localdomain>
 <DM5PR11MB1435C484283BDCD75F19EDB5C39A0@DM5PR11MB1435.namprd11.prod.outlook.com>
 <20200622125114.GC15683@stefanha-x1.localdomain>
In-Reply-To: <20200622125114.GC15683@stefanha-x1.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.218]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7eb49aa1-328b-4a79-10a3-08d81740cca7
x-ms-traffictypediagnostic: DM5PR1101MB2265:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR1101MB2265B1C1335A17691D2A8F39C3940@DM5PR1101MB2265.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2449;
x-forefront-prvs: 04433051BF
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: p5zwf0+TCX1gLLQ45aLgZPtOgWPTnSWV9P8MeU6DjYH5E45azjBgqoF37yjhaNFv/I00xcNY94CPSHO+hvsMYWT/lDJWtBDCgGYa2MJ+qNOyKgVJqzFxycgWyDYt1v/mlMTY1lK6Q6shZ9U272NLwZhe/LnhH0adgxyvQklIbe94i1eq8ZVZVBGtVPE41yWKjE7E5mej7bU13yH08NJKpnIuLq9uR7J+oY+TQ4jCtbgXYlViJ8wF5dAlsjTT7GvdksOOECGUCbLd8evkwV+ighFlS9v3xIEnPSRFWt8FalXAqHPr/XnCfiJ8CMqRA34NIUf439cl6/JfwRrzBINHCl8Q8yBYAW9BVE4mcI+cbJ/3Trbe/9fmdjsojIX4J4H9sZBJHaolcvs88xiwdiLHqg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1435.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39860400002)(346002)(366004)(376002)(136003)(83380400001)(2906002)(6916009)(8676002)(52536014)(478600001)(5660300002)(71200400001)(966005)(7696005)(6506007)(76116006)(64756008)(7416002)(26005)(66556008)(66476007)(66946007)(54906003)(186003)(316002)(33656002)(4326008)(8936002)(86362001)(55016002)(66446008)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: cCfq0L/wGTLlCgiraBieapfe2xZMMFs6RhpN9u3GNmdscIbzn2eKih6U+7pBra1oOF9TERgKQF5Z28x2aZ1wH/s0CiCM6XFU8Mirt0emExY+5PX2AXTy/QZj8AE1DkQpmQLA6bFrEE6LfhSNpVWO5qF5c/U5l31JcGM1tEdyre/qsVi/5nv3G4Sfwsy0aB8lDhyKdbv3SWQuUgtPT9EiO3Ou4rNEcX9eGFITx/tZaeR9QOeSZXVLzMFAKLv73G8d/owYvAseuN9Id48gjEbd06r6vSty68mGe9+yUw6g+kmUqEfnITdjhW2AodyWFvqsrDPg3rzuZ2x0feD4c2PStw/JhyfYFDylItU3oNMKqJ5JKr73MbBayMzUBNeFRYPJmiwvU45cvcPbK82Pi52P9e7nLlLUQkKG0pDSCFY6WzswuAtguUBRT/1aNUqG46VMYgHJozGmdsJB1YVfA8f6v0yOt/kJIxTZ0NpZPjpdxun4c85iPN76ddCCDHBZ77uL
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 7eb49aa1-328b-4a79-10a3-08d81740cca7
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2020 06:43:55.0412
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Gn1TSR9n1QJ8Qh/eXK1wZOryIg5NuBqgjS3SJXj7QKRwv0D37Y7RL9utydwHDtf39xo01oF3/tju2ivvkI9M8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1101MB2265
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Stefan Hajnoczi <stefanha@gmail.com>
> Sent: Monday, June 22, 2020 8:51 PM
>=20
> On Wed, Jun 17, 2020 at 06:27:27AM +0000, Liu, Yi L wrote:
> > > From: Stefan Hajnoczi <stefanha@gmail.com>
> > > Sent: Monday, June 15, 2020 5:41 PM
> > > On Thu, Jun 11, 2020 at 05:15:33AM -0700, Liu Yi L wrote:
> > >
> > > > From: Eric Auger <eric.auger@redhat.com>
> > > >
> > > > The VFIO API was enhanced to support nested stage control: a bunch =
of
> > > > new iotcls and usage guideline.
> > > >
> > > > Let's document the process to follow to set up nested mode.
> > > >
> > > > Cc: Kevin Tian <kevin.tian@intel.com>
> > > > CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > > > Cc: Alex Williamson <alex.williamson@redhat.com>
> > > > Cc: Eric Auger <eric.auger@redhat.com>
> > > > Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
> > > > Cc: Joerg Roedel <joro@8bytes.org>
> > > > Cc: Lu Baolu <baolu.lu@linux.intel.com>
> > > > Signed-off-by: Eric Auger <eric.auger@redhat.com>
> > > > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > > > ---
> > > > v1 -> v2:
> > > > *) new in v2, compared with Eric's original version, pasid table bi=
nd
> > > >    and fault reporting is removed as this series doesn't cover them=
.
> > > >    Original version from Eric.
> > > >    https://lkml.org/lkml/2020/3/20/700
> > > >
> > > >  Documentation/driver-api/vfio.rst | 64
> > > > +++++++++++++++++++++++++++++++++++++++
> > > >  1 file changed, 64 insertions(+)
> > > >
> > > > diff --git a/Documentation/driver-api/vfio.rst
> > > > b/Documentation/driver-api/vfio.rst
> > > > index f1a4d3c..06224bd 100644
> > > > --- a/Documentation/driver-api/vfio.rst
> > > > +++ b/Documentation/driver-api/vfio.rst
> > > > @@ -239,6 +239,70 @@ group and can access them as follows::
> > > >  	/* Gratuitous device reset and go... */
> > > >  	ioctl(device, VFIO_DEVICE_RESET);
> > > >
> > > > +IOMMU Dual Stage Control
> > > > +------------------------
> > > > +
> > > > +Some IOMMUs support 2 stages/levels of translation. Stage correspo=
nds
> > > > +to the ARM terminology while level corresponds to Intel's VTD term=
inology.
> > > > +In the following text we use either without distinction.
> > > > +
> > > > +This is useful when the guest is exposed with a virtual IOMMU and
> > > > +some devices are assigned to the guest through VFIO. Then the gues=
t
> > > > +OS can use stage 1 (GIOVA -> GPA or GVA->GPA), while the hyperviso=
r
> > > > +uses stage 2 for VM isolation (GPA -> HPA).
> > > > +
> > > > +Under dual stage translation, the guest gets ownership of the stag=
e 1
> > > > +page tables and also owns stage 1 configuration structures. The
> > > > +hypervisor owns the root configuration structure (for security
> > > > +reason), including stage 2 configuration. This works as long
> > > > +configuration structures and page table
> > >
> > > s/as long configuration/as long as configuration/
> >
> > got it.
> >
> > >
> > > > +format are compatible between the virtual IOMMU and the physical I=
OMMU.
> > >
> > > s/format/formats/
> >
> > I see.
> >
> > > > +
> > > > +Assuming the HW supports it, this nested mode is selected by choos=
ing
> > > > +the VFIO_TYPE1_NESTING_IOMMU type through:
> > > > +
> > > > +    ioctl(container, VFIO_SET_IOMMU, VFIO_TYPE1_NESTING_IOMMU);
> > > > +
> > > > +This forces the hypervisor to use the stage 2, leaving stage 1
> > > > +available for guest usage. The guest stage 1 format depends on IOM=
MU
> > > > +vendor, and it is the same with the nesting configuration method.
> > > > +User space should check the format and configuration method after
> > > > +setting nesting type by
> > > > +using:
> > > > +
> > > > +    ioctl(container->fd, VFIO_IOMMU_GET_INFO, &nesting_info);
> > > > +
> > > > +Details can be found in Documentation/userspace-api/iommu.rst. For
> > > > +Intel VT-d, each stage 1 page table is bound to host by:
> > > > +
> > > > +    nesting_op->flags =3D VFIO_IOMMU_NESTING_OP_BIND_PGTBL;
> > > > +    memcpy(&nesting_op->data, &bind_data, sizeof(bind_data));
> > > > +    ioctl(container->fd, VFIO_IOMMU_NESTING_OP, nesting_op);
> > > > +
> > > > +As mentioned above, guest OS may use stage 1 for GIOVA->GPA or GVA=
->GPA.
> > > > +GVA->GPA page tables are available when PASID (Process Address Spa=
ce
> > > > +GVA->ID)
> > > > +is exposed to guest. e.g. guest with PASID-capable devices assigne=
d.
> > > > +For such page table binding, the bind_data should include PASID in=
fo,
> > > > +which is allocated by guest itself or by host. This depends on
> > > > +hardware vendor e.g. Intel VT-d requires to allocate PASID from ho=
st.
> > > > +This requirement is available by VFIO_IOMMU_GET_INFO. User space
> > > > +could allocate PASID from host by:
> > > > +
> > > > +    req.flags =3D VFIO_IOMMU_ALLOC_PASID;
> > > > +    ioctl(container, VFIO_IOMMU_PASID_REQUEST, &req);
> > >
> > > It is not clear how the userspace application determines whether PASI=
Ds must be
> > > allocated from the host via VFIO_IOMMU_PASID_REQUEST or if the guest =
itself
> can
> > > allocate PASIDs. The text mentions VFIO_IOMMU_GET_INFO but what exact=
ly
> > > should the userspace application check?
> >
> > For VT-d, spec 3.0 introduced Virtual Cmd interface for PASID allocatio=
n,
> > guest request PASID from host if it detects the interface. Application
> > should check the IOMMU_NESTING_FEAT_SYSWIDE_PASID setting in the below
> > info reported by VFIO_IOMMU_GET_INFO. And virtual VT-d should not repor=
t
> > SVA related capabilities to guest if  SYSWIDE_PASID is not supported by
> > kernel.
> >
> > +struct iommu_nesting_info {
> > +	__u32	size;
> > +	__u32	format;
> > +	__u32	features;
> > +#define IOMMU_NESTING_FEAT_SYSWIDE_PASID	(1 << 0)
> > +#define IOMMU_NESTING_FEAT_BIND_PGTBL		(1 << 1)
> > +#define IOMMU_NESTING_FEAT_CACHE_INVLD		(1 << 2)
> > +	__u32	flags;
> > +	__u8	data[];
> > +};
> > https://lore.kernel.org/linux-iommu/1591877734-66527-3-git-send-email-
> yi.l.liu@intel.com/
>=20
> I see. Is it possible to add this information into this patch or at
> least a reference so readers know where to find out exactly how to do
> this?

oh, yes. this would help a lot. will add it.

Regards,
Yi Liu
> Stefan
