Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50D0C2CD270
	for <lists+kvm@lfdr.de>; Thu,  3 Dec 2020 10:23:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730102AbgLCJVv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 04:21:51 -0500
Received: from mga03.intel.com ([134.134.136.65]:1076 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726003AbgLCJVr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Dec 2020 04:21:47 -0500
IronPort-SDR: 3tbatk+ZWtW+DCCqd3cK+w99TP9PK4A9zAYBTBkct+IZ1ccaIjpDdUP1W8GmoT9mgJ6nA6hpEA
 6556se3Mf+Vw==
X-IronPort-AV: E=McAfee;i="6000,8403,9823"; a="173257626"
X-IronPort-AV: E=Sophos;i="5.78,389,1599548400"; 
   d="scan'208";a="173257626"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2020 01:21:07 -0800
IronPort-SDR: ZrPX0tRCN8A7EbAuaMmJXreb9vj5XxcyhwMKsNtUZLz4kyyk35mSgWj0cTf80I2wgYGXr1tcth
 QW0ZXEZDEJ9g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,389,1599548400"; 
   d="scan'208";a="365672931"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga004.fm.intel.com with ESMTP; 03 Dec 2020 01:21:05 -0800
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 3 Dec 2020 01:21:05 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 3 Dec 2020 01:21:05 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Thu, 3 Dec 2020 01:21:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RYcb5/Q3GoF3ZhiYEQ7JlYLq4zle/de9iGTNTu1MrMSSBfEWyciLUxtDnEuFrEZhBU3qI9WLFbNCMGMBtWjB8gIuuJ+A1bPf0KRxxgdfcu3UhloOFrIhXTnOTXCAzIdOCaQpKm77fJpBKtLvz0SHA0DqKB10dSfirFVDxR4RHeyQ2Beb//FcDLItTKv/oqWs47DD3DO8gL9ShFIhI9vYneEgsRH3dPE71mDmeLjLaqMSerF7kzpEvgPpV6yzPwjmxQGdUplFa517liPo29o+RT09qyiyBmA6fUSWPjha4fOpzRDzaJKGLCF6Q4rMk4qga4IHpdIUSGZ/eAaIl6RI4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ik2u3hc5fditHZ8h8/aG0CkvAwS8HQTm8NDpIkqAKA8=;
 b=hiutFdRzP7keevzOxdE7W8BPchMMZk6lR6CJ+o5r2qNFJ3hbXFkoCeev/hfxtjQCEn9Ba9c2L4ZOt0s/rz7OHm+EIrQnM5Y1WvMf0Xdw332QHWKDxtjGmZXfztioLZmtY+hZuErLazMcoZqcIRmvWup4/CegqhIfm0ZhJSHx7LIz1LS/okq26t+wZsylCnaid3uwDMxnSEg9su/2YD7fhzOklgmChePttQP3BC+yvXJ2fv1tcp4rQSEDdpGj9uXHZ0iLeXPl/AFLGyLHU2jILwGSbY1ID0HAL25XDQJ2i4gLH2Pq590FNIvBVFyzryD4k0HSWBa46RSEjQyUwQDkfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ik2u3hc5fditHZ8h8/aG0CkvAwS8HQTm8NDpIkqAKA8=;
 b=ldOPd3pLyT7DtyX1+lNsdG/WIWwTk49wqawtssSNMROHGj/+E4dUquZVba8d0JhFtIqtmG8ejEwq+FJynhB5MKua03vkkRziktL1MinWaMU1W/CuLmVTy7SCgXhJnYgCgchhGIoUXYFBGDGoE/RH1MtGN1udZPxqkKIC0ZsmxU4=
Received: from DM5PR11MB1643.namprd11.prod.outlook.com (2603:10b6:4:b::16) by
 DM5PR11MB1644.namprd11.prod.outlook.com (2603:10b6:4:c::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3632.18; Thu, 3 Dec 2020 09:21:03 +0000
Received: from DM5PR11MB1643.namprd11.prod.outlook.com
 ([fe80::f991:b840:a505:808e]) by DM5PR11MB1643.namprd11.prod.outlook.com
 ([fe80::f991:b840:a505:808e%12]) with mapi id 15.20.3611.031; Thu, 3 Dec 2020
 09:21:03 +0000
From:   "Gao, Fred" <fred.gao@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "Zhenyu Wang" <zhenyuw@linux.intel.com>,
        "Fonn, Swee Yee" <swee.yee.fonn@intel.com>
Subject: RE: [PATCH v1] vfio/pci: Add support for opregion v2.0+
Thread-Topic: [PATCH v1] vfio/pci: Add support for opregion v2.0+
Thread-Index: AQHWyIv3TnNNa/sYxUS4xK4Y4ZBPN6nkKNeAgADO78A=
Date:   Thu, 3 Dec 2020 09:21:03 +0000
Message-ID: <DM5PR11MB16436AACB3AE89CC8C4ED4199DF20@DM5PR11MB1643.namprd11.prod.outlook.com>
References: <20201202171249.17083-1-fred.gao@intel.com>
 <20201202115723.27df527b@w520.home>
In-Reply-To: <20201202115723.27df527b@w520.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.202]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ff34c502-9b0e-4a70-cae7-08d8976cc1d7
x-ms-traffictypediagnostic: DM5PR11MB1644:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR11MB1644CF810B09AE4E91E8EF569DF20@DM5PR11MB1644.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rWhT/GaUvqG20sq68tG5R8pWFN4fWgSmPQhH6aJUzJEXKzF/QxwDOfVijjcHUmKQCBe3SbzG2n4siyQzM7EfmvwIwx0bAWSxauj7tYdPSudSI/fIrYYsnNgrBElOOY1q8F6yPXvjLhXIgWPalGpeuZovT4KIZCfAGdyTnYUCXAJo1LZLg6fhcxaNr+Im+qqVk1zKU1tQalXKKtcCmYIqOQ0haEmPt932UmK9FQbNCxsSfUMlzIedbiQkq5gfVY/hlFfASiXVGY4MwNWgZvA6KrGea1p3Z7A1wTJkZcPVReF1RZpE0xcIh9yYvWB4bC0+JqCnrVD3KzcmCNRgZIChPw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1643.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(346002)(366004)(39860400002)(396003)(316002)(8936002)(7696005)(53546011)(76116006)(83380400001)(9686003)(26005)(52536014)(55016002)(2906002)(66556008)(64756008)(6506007)(66946007)(66446008)(66476007)(186003)(5660300002)(478600001)(8676002)(4326008)(6916009)(54906003)(33656002)(71200400001)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?ijRDXstCdXVZjbs70StUankBmk1/Mezb/L2g4I3zlBNeI4TOgJDlIElskPTZ?=
 =?us-ascii?Q?5ewknkoD5bsqX9Aznj1qQKHcIrJXF32J9cstJD/DxylZVcuKWqOxSgZZtSuM?=
 =?us-ascii?Q?qn1coXgBLWsZOHO27Of1Af3Nr9YH9csd5oogTmO5jTgw1mUdhryz1RXv91VK?=
 =?us-ascii?Q?jfiexLt9kdGNV22ML4qBGRQT7yqd6P/wIMNuTP2nYnNtUBiuTve01k2lBUwM?=
 =?us-ascii?Q?Rkp4FSggEgjbmuyIPbKY9XDZ7UgvVWJ+eTiIzSOlhpJihO+KidwGOYgsy3BC?=
 =?us-ascii?Q?C2ABpvLHPWjjpGj+F2KiiqKVzXsW3zH/kIoUABK7gAFsMXuag0crvFApwXl6?=
 =?us-ascii?Q?o9PvfMtcxKJb/qucuivEIo9QtL5wW6oTMipvmC+Aa4TYW+APluLJtkmm/Mll?=
 =?us-ascii?Q?RxE5eCm4+oAhZAbFWAnSd6XZSqm+SXThk3iDrvKIfEJcJIwESf9YNDbkZquX?=
 =?us-ascii?Q?ED20gbyj19xSRoOivg64Sm/io+0QliS9ZqikqCSYTuJED9/d/o9NKONMQvr4?=
 =?us-ascii?Q?ZKLw4kuQJvvlAJoE5swVmlTvg1XOuXTtxIPy6OZH9WJKnsu7PkgzZOSPO34N?=
 =?us-ascii?Q?3dkrzLvkKLb9NbfuvjHctZ9M4WRBx5BCAdUtqTgRj8IhXabIn8nCv+voQVtU?=
 =?us-ascii?Q?l6XZxNVg+pspnV3BuIEYC8FFwJPMETxYvkI+i9St7+AreSU8aKmGwHNtWS5G?=
 =?us-ascii?Q?dQibpimfLkSBtTdSgvjBbCM6Ez+Tz69ERxdEgJy08WVjNtQzDXS7x+Zwh5Hy?=
 =?us-ascii?Q?SUTDbkGJaeWpIOTDYnX3c9ESGoSUpcti1NU1/Mt1hM7GLzrS3YAiMueEZqEo?=
 =?us-ascii?Q?EaKzWHs7N0XLxeoQ+BJ8a3I5Yzb5+6Hk2wCl7cMa98voEhDfR++tkLpspiSa?=
 =?us-ascii?Q?mx08QcTWeWc5Pex+GR/VqPjAbgtj8A/G6kiMq2eTjYD5oWZAI89Yw7G/FYlM?=
 =?us-ascii?Q?Y0yULDeBaO/ItucVmX2sKTcLCPw13nrFDZCoMXIPdlg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1643.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff34c502-9b0e-4a70-cae7-08d8976cc1d7
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Dec 2020 09:21:03.6442
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KPaZxPJqVcdqoXvvBRvgl2fz32v9BHHBfdQ8szgPSTOI8VUx4KtLzyNusi0lHth1Vo7kwZFOA5q2Qj905n4oTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1644
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thanks Alex for the timely review.

> -----Original Message-----
> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Thursday, December 3, 2020 2:57 AM
> To: Gao, Fred <fred.gao@intel.com>
> Cc: kvm@vger.kernel.org; intel-gfx@lists.freedesktop.org; Zhenyu Wang
> <zhenyuw@linux.intel.com>; Fonn, Swee Yee <swee.yee.fonn@intel.com>
> Subject: Re: [PATCH v1] vfio/pci: Add support for opregion v2.0+
>=20
> On Thu,  3 Dec 2020 01:12:49 +0800
> Fred Gao <fred.gao@intel.com> wrote:
>=20
> > When VBT data exceeds 6KB size and cannot be within mailbox #4
> > starting from opregion v2.0+, Extended VBT region, next to opregion,
> > is used to hold the VBT data, so the total size will be opregion size
> > plus extended VBT region size.
> >
> > For opregion 2.1+: since rvda is relative offset from opregion base,
> > rvda as extended VBT start offset should be same as opregion size.
> >
> > For opregion 2.0: the only difference between opregion 2.0 and 2.1 is
> > rvda addressing mode besides the version. since rvda is physical host
> > VBT address and cannot be directly used in guest, it is faked into
> > opregion 2.1's relative offset.
> >
> > Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
> > Signed-off-by: Swee Yee Fonn <swee.yee.fonn@intel.com>
> > Signed-off-by: Fred Gao <fred.gao@intel.com>
> > ---
> >  drivers/vfio/pci/vfio_pci_igd.c | 44
> > +++++++++++++++++++++++++++++++++
> >  1 file changed, 44 insertions(+)
> >
> > diff --git a/drivers/vfio/pci/vfio_pci_igd.c
> > b/drivers/vfio/pci/vfio_pci_igd.c index 53d97f459252..78919a289914
> > 100644
> > --- a/drivers/vfio/pci/vfio_pci_igd.c
> > +++ b/drivers/vfio/pci/vfio_pci_igd.c
> > @@ -21,6 +21,17 @@
> >  #define OPREGION_SIZE		(8 * 1024)
> >  #define OPREGION_PCI_ADDR	0xfc
> >
> > +/*
> > + * opregion 2.0: rvda is the physical VBT address.
>=20
> What's rvda?  What's VBT?
Rvda is a struct member in opregion mailbox 3 ,
 same definition in i915's struct opregion_asle.
  I,e  Physical address of raw VBT data (v2.0) or=20
Relative address from opregion (v2.1).

VBT: video bios table ,
        the data is  stored in  opregion mailbox 4 before opregion v2.0.
        After opregion v2.0+ , VBT data is larger than mailbox 4,=20
        so Extended VBT region, next to opregion  is used to hold the data.
> > + *
> > + * opregion 2.1+: rvda is unsigned, relative offset from
> > + * opregion base, and should never point within opregion.
> > + */
> > +#define OPREGION_RDVA		0x3ba
> > +#define OPREGION_RDVS		0x3c2
> > +#define OPREGION_VERSION	22
>=20
> Why is this specified as decimal and the others in hex?  This makes it se=
em
> like the actual version rather than the offset of a version register.

Yes, it is an offset, will redefine the opregion version offset in hex.=20
> > +
> > +
> >  static size_t vfio_pci_igd_rw(struct vfio_pci_device *vdev, char __use=
r
> *buf,
> >  			      size_t count, loff_t *ppos, bool iswrite)  { @@ -
> 58,6 +69,7
> > @@ static int vfio_pci_igd_opregion_init(struct vfio_pci_device *vdev)
> >  	u32 addr, size;
> >  	void *base;
> >  	int ret;
> > +	u16 version;
> >
> >  	ret =3D pci_read_config_dword(vdev->pdev, OPREGION_PCI_ADDR,
> &addr);
> >  	if (ret)
> > @@ -83,6 +95,38 @@ static int vfio_pci_igd_opregion_init(struct
> > vfio_pci_device *vdev)
> >
> >  	size *=3D 1024; /* In KB */
> >
> > +	/* Support opregion v2.0+ */
> > +	version =3D le16_to_cpu(*(__le16 *)(base + OPREGION_VERSION));
> > +	if (version >=3D 0x0200) {
> > +		u64 rvda;
> > +		u32 rvds;
> > +
> > +		rvda =3D le64_to_cpu(*(__le64 *)(base + OPREGION_RDVA));
> > +		rvds =3D le32_to_cpu(*(__le32 *)(base + OPREGION_RDVS));
> > +		if (rvda && rvds) {
> > +			u32 offset;
> > +
> > +			if (version =3D=3D 0x0200)
> > +				offset =3D (rvda - (u64)addr);
>=20
> Unnecessary outer ()
Thx, will remove in new patch.
> > +			else
> > +				offset =3D rvda;
> > +
> > +			pci_WARN(vdev->pdev, offset !=3D size,
> > +				"Extended VBT does not follow opregion !\n"
> > +				"opregion version 0x%x:offset 0x%x\n",
> version, offset);
> > +
> > +			if (version =3D=3D 0x0200) {
> > +				/* opregion version v2.0 faked to v2.1 */
> > +				*(__le16 *)(base + OPREGION_VERSION) =3D
> > +					cpu_to_le16(0x0201);
> > +				/* rvda faked to relative offset */
> > +				(*(__le64 *)(base + OPREGION_RDVA)) =3D
> > +					cpu_to_le64((rvda - (u64)addr));
>=20
> We're writing to the OpRegion and affecting all future use of it, seems
> dangerous.

  from the opregion v2.0+ specification=20
since there is only RVDA difference between opregion v2.0 and v2.1 besides =
the version
  It is the simplest solution and should not impact the future use.
> > +			}
> > +			size =3D offset + rvds;
>=20
>=20
> We warn about VBT (whatever that is) not immediately following the
> OpRegion, but then we go ahead and size the thing that we expose to
> userspace to allow read access to everything between the OpRegion and
> VBT??
From the specification , there should no hole between opregion and VBT.
But I am not sure if some vendor BIOS will make the hole.
Can we return the error if this abnormal thing happens ?

> > +		}
> > +	}
> > +
> >  	if (size !=3D OPREGION_SIZE) {
> >  		memunmap(base);
> >  		base =3D memremap(addr, size, MEMREMAP_WB);

