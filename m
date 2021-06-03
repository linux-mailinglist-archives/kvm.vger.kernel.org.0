Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD1A399AE7
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 08:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbhFCGlT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 02:41:19 -0400
Received: from mga07.intel.com ([134.134.136.100]:28567 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229807AbhFCGlT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 02:41:19 -0400
IronPort-SDR: n2Q8vB6DIcc4i0ZjzEX8EDLtmYEpvF81lV2BxIBYcwazPKAAARab2S44URIzquBPCjVfCKM9AM
 0a+i4ZpaMBcw==
X-IronPort-AV: E=McAfee;i="6200,9189,10003"; a="267844507"
X-IronPort-AV: E=Sophos;i="5.83,244,1616482800"; 
   d="scan'208";a="267844507"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2021 23:39:33 -0700
IronPort-SDR: o0Ff778WS2uj2emU0Yl70buSreXa/jHO62RGMtrSHb7dM/1BoeYHWboC4TGIJLjexZU8+j1GHA
 cLB3lJt0N2Tw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,244,1616482800"; 
   d="scan'208";a="417274917"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga002.jf.intel.com with ESMTP; 02 Jun 2021 23:39:33 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Wed, 2 Jun 2021 23:39:33 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Wed, 2 Jun 2021 23:39:33 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Wed, 2 Jun 2021 23:39:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GbIHnE24jpnuPiw2FcuFqS+RcRceYdY8KYm5DCJvGqCyLtoYtMHgK0Dr9qkgzFigQv0pdDBo/76SpHBW+lct6JDyOpl98AR4Tn7K83nrO6SB8n+p65twZZE2LKnGwIAsQFIcEtn0+KCsgmYp+c8VGsJOJpeGEh+iVVegS5/V+idwMR3dQ73bCigvdBOykTv/bWrMMPYsLEjo1Yxh8Lt3zPRCW6INgsQlLdnkAn+Eq9OH20rVPonYVzOYEGsS9gKGS4/5R4LSedHND+4R+ujEeCAAhNyRvTfa62OyB0wEWt3Pp0197g5rwoDUHDUYlVJofAa99rSFYuL3wPjY2ZoHew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1eazfBNubD4mAu+k6Q0T4HXBi+4SWMuEFL5IZ+TTXxs=;
 b=KWb6yvmDPRg9l9Bkdc0ldBXkZvzbYvxwsVP+bBZT+MgzzK1q/RRDHGXYHFXZV3Aguq3P36JKLKIb/gnUrQ7nrNS5l2OhoEUA68HYqQmPFEeLrcWWs4jG43/gmVigg8mOEki9q2Fogg3muUq/+ov0ZX4Sk9NhqofuTDd6184dugg+NI8Qc/QSGKF6b+176DbjUJklGXGTDXOOSLgO9axaiMhMoLLgObt06s08aJ9q4YLaLO/GZGBtSVu0YHKbr/f/S39DTJ493Ud3pniwE18fy5c9IBj4PZpwe+GRqQo0EwCmfDb+tCCeQOvu0UbLzeF59/YlUCafUT0uaTphsg+GiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1eazfBNubD4mAu+k6Q0T4HXBi+4SWMuEFL5IZ+TTXxs=;
 b=p9veejWJeItkNOd6q7zYcJhlEkh18lZB6aJrVhmQKyacThXjMo7GNhimNHvHkqm2AGsaGPKobzF92Dydyqx53TzN83dPauxVDMc6QGxEot4i/ka4hxaxlyJpuQSgbSlAOrZldCJX7kcRsuNz8Qg7RljMzWbrEXRzgul6i6Ru0Ic=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by MWHPR11MB1328.namprd11.prod.outlook.com (2603:10b6:300:2b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Thu, 3 Jun
 2021 06:39:31 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1%12]) with mapi id 15.20.4173.030; Thu, 3 Jun 2021
 06:39:30 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     LKML <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        "Lu Baolu" <baolu.lu@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>, Jason Wang <jasowang@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Robin Murphy" <robin.murphy@arm.com>
Subject: RE: [RFC] /dev/ioasid uAPI proposal
Thread-Topic: [RFC] /dev/ioasid uAPI proposal
Thread-Index: AddSzQ970oLnVHLeQca/ysPD8zMJZwBTUTCAAQiuDaA=
Date:   Thu, 3 Jun 2021 06:39:30 +0000
Message-ID: <MWHPR11MB188621A9D1181A414D5491198C3C9@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210528233649.GB3816344@nvidia.com>
In-Reply-To: <20210528233649.GB3816344@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.142.24]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9692cf9c-063c-48dd-ad7c-08d9265a57b2
x-ms-traffictypediagnostic: MWHPR11MB1328:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB13284BDBF3D18D704BD78CB78C3C9@MWHPR11MB1328.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MIqTertDN2T6MbEbC5elugFdvdjkV5ru29z20Jh1dQiRPD63Cr6qGh7ijoU49evfsLTfFqopILGnAcL+Unayr/UvnR+gcJg59ognTb+qXvAe7JMTjhahty/UrO5g0S3G90csoCfgMGty8rmxR6jJ/GJeQIjRjQMkOE8deeOC9v7FrLlv0zBWYSI2/p8jZ706z5o+qyVU15Gvf6VMQay0VFh/E5+GNqWBWuZUXE9S6WUDmnK90ahDBlmetp8df6Xmz1sqhuKqtmBB3L7L0jB6bhHBXanQcWpj17uyZIjLXOwITU+D077hAmBez6TA05P+PS67FkpVWhRgAaXGrWu99cqzhzYwuMz9Hi3hG5AOmTVDFd5b/hGGskjF7/99VkYOBOH4PiYLM22pd9ps1yCVRAOyPeRbaa4bTSco3IVFhS6zVrSlAAaq2Kuxz4/kJ2XNjTEfslEXNPuZLqP175ybbNI+D7TcKycR/lU0kgncD8UIOZnckf4w+ASg55J3yQxEVHJx1XUdCt1jebNUeABNgb/Iv9zG3vtToO0OMMD6i1/Kz7tY4RK+OQwGPo46lhq2yOB/WHWzfsR0519g+TB6ogTnB61H69esG9fgSFy0kmY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(346002)(376002)(136003)(39860400002)(55016002)(54906003)(9686003)(26005)(2906002)(5660300002)(316002)(6916009)(6506007)(7696005)(186003)(71200400001)(33656002)(83380400001)(64756008)(122000001)(8936002)(38100700002)(478600001)(66446008)(66476007)(8676002)(66556008)(66946007)(86362001)(7416002)(76116006)(30864003)(4326008)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?X350JMla3Z0HqkMIF3Emv1+LRrX4feMuncN5CciPrBwu10tUm7pTDAm5mS2d?=
 =?us-ascii?Q?/zI5euRvUEwmxr+nHEjiU6VKEV/Ml4EK2JHojNIX3XxGcoBJ7BQ/tbhH74nX?=
 =?us-ascii?Q?I6JHy0gKy8sSFeum56LXB0lXnyRBk29wqwEhIKvasC1SpgqGaaqOF/hvww4+?=
 =?us-ascii?Q?L9mMNl+Is+vveTAyHPBOXMszt9Z8ZQGADMlG1T021vfuez3uFg2/JJ2fKf0O?=
 =?us-ascii?Q?NyUVUdyR4NFHNR93kSY8J/17BKPXNglac2IVBm+53FZBPnmSpUNc6JATxFdi?=
 =?us-ascii?Q?RP9r3ZXwX/6jUMmZqjHgYo2pbZlSnkw2n0MFQTZrjst5UJcJvSBxJPcDkEbj?=
 =?us-ascii?Q?FKo7pivUlR4NhEYLf5XBQuemSNhLXux92I8ZgVhriiaeYTbmZ5v2X6slEOb/?=
 =?us-ascii?Q?ByplfzmPVlTz+s74LvNsQtplYuDqf5wxaUbj0oU0gNcdA78nxLqtEt0OPLSN?=
 =?us-ascii?Q?JMldzG2t6P/oMGxkiRVOiKpMFhS8rdcd0bCcXPh9iyUDyl+Gm7HLG9uiOroR?=
 =?us-ascii?Q?AJmQaA7BSU9PamUg8aadJD+VoFSjDCD0VEkQVVGxsDTLBYlQ9i+fO+XDC92L?=
 =?us-ascii?Q?6jNiulMMqzR4hYs6e887X7257bjWGwDJWjQQkvn5F+2tUkfoNfOJD+WOTVcf?=
 =?us-ascii?Q?85GdwzYfti9O9h7Ent6ibvcLE84stoHZgeG/lmzZ8FHUFO+ZrdDc5QmObxUj?=
 =?us-ascii?Q?MxtZfo64DfFZvlo7sfyuJgSXwqTp09dlre1KbSwSDwXNiDV9YRrvgMN9e/Qz?=
 =?us-ascii?Q?DVLcfQk4yKffdUqs8BqgJb4WkMt3PN9aSW4grzj4meaRNwmN2084ktAuqaV5?=
 =?us-ascii?Q?QDfWWEsksiHvx57/ZDKhEBXOkleoEs1BVEU8itpd7+lVj4DUpsBBpD65x4cf?=
 =?us-ascii?Q?CB35sUrqjrbpR0UIX4WWwj8mhuvnp58Vz6AiHojbRd/P3Qz0F8sOYgHWfyEp?=
 =?us-ascii?Q?tZbfXxpPSGroYd5A/2LjXL3EXl06+qr8XP2N5UsfIzJM9l8c9JBP6Qf3Rif1?=
 =?us-ascii?Q?+LH+SvktCsKzaMWFaBBxYLkD1fOX7JWgG5px/rWEG+CGaADdJ+SsscgR2jo0?=
 =?us-ascii?Q?Yo6agvSeKCVVN0sIv5YdgKtTBIE/VzCM+MvuEqyQHzFZS1G5ZFQUhNaQNDj6?=
 =?us-ascii?Q?KuozgCiITmGBUZkaFWTacr1q9kwbxMe8NPE5YzB5Ow9KdCkpT+vPVIl3QK0e?=
 =?us-ascii?Q?AivKWvjtvmTAHpW+/vypGp00Y2FiTpPf48ooztxWbbz8ifhtfan+PVLS9cPN?=
 =?us-ascii?Q?an7DowdcoIU3SfCOXEs22nCuLcBJMHuZqDOMG/iBYmMnVUzg8jJ1D+Y+2CMj?=
 =?us-ascii?Q?TX4Qr3jZKsAXjt4C+FuOZZYk?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9692cf9c-063c-48dd-ad7c-08d9265a57b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2021 06:39:30.7366
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +3m99PA4PTgami3O64gsYxp9ScuzgZjGVruE+O7uZtw0NmelkAHNiRQWHqApsOtgcIUyEFfundyzLqBeU0AFNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1328
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Saturday, May 29, 2021 7:37 AM
>=20
> On Thu, May 27, 2021 at 07:58:12AM +0000, Tian, Kevin wrote:
>=20
> > 2.1. /dev/ioasid uAPI
> > +++++++++++++++++
> >
> > /*
> >   * Check whether an uAPI extension is supported.
> >   *
> >   * This is for FD-level capabilities, such as locked page pre-registra=
tion.
> >   * IOASID-level capabilities are reported through IOASID_GET_INFO.
> >   *
> >   * Return: 0 if not supported, 1 if supported.
> >   */
> > #define IOASID_CHECK_EXTENSION	_IO(IOASID_TYPE, IOASID_BASE + 0)
>=20
>=20
> > /*
> >   * Register user space memory where DMA is allowed.
> >   *
> >   * It pins user pages and does the locked memory accounting so sub-
> >   * sequent IOASID_MAP/UNMAP_DMA calls get faster.
> >   *
> >   * When this ioctl is not used, one user page might be accounted
> >   * multiple times when it is mapped by multiple IOASIDs which are
> >   * not nested together.
> >   *
> >   * Input parameters:
> >   *	- vaddr;
> >   *	- size;
> >   *
> >   * Return: 0 on success, -errno on failure.
> >   */
> > #define IOASID_REGISTER_MEMORY	_IO(IOASID_TYPE, IOASID_BASE + 1)
> > #define IOASID_UNREGISTER_MEMORY	_IO(IOASID_TYPE,
> IOASID_BASE + 2)
>=20
> So VA ranges are pinned and stored in a tree and later references to
> those VA ranges by any other IOASID use the pin cached in the tree?

yes.

>=20
> It seems reasonable and is similar to the ioasid parent/child I
> suggested for PPC.
>=20
> IMHO this should be merged with the all SW IOASID that is required for
> today's mdev drivers. If this can be done while keeping this uAPI then

Agree. Regarding uAPI there is no difference between SW IOASID and
HW IOASID. The main difference is behind /dev/ioasid, that SW IOASID=20
is not linked to the IOMMU.

> great, otherwise I don't think it is so bad to weakly nest a physical
> IOASID under a SW one just to optimize page pinning.
>=20
> Either way this seems like a smart direction
>=20
> > /*
> >   * Allocate an IOASID.
> >   *
> >   * IOASID is the FD-local software handle representing an I/O address
> >   * space. Each IOASID is associated with a single I/O page table. User
> >   * must call this ioctl to get an IOASID for every I/O address space t=
hat is
> >   * intended to be enabled in the IOMMU.
> >   *
> >   * A newly-created IOASID doesn't accept any command before it is
> >   * attached to a device. Once attached, an empty I/O page table is
> >   * bound with the IOMMU then the user could use either DMA mapping
> >   * or pgtable binding commands to manage this I/O page table.
>=20
> Can the IOASID can be populated before being attached?
>=20
> >   * Device attachment is initiated through device driver uAPI (e.g. VFI=
O)
> >   *
> >   * Return: allocated ioasid on success, -errno on failure.
> >   */
> > #define IOASID_ALLOC	_IO(IOASID_TYPE, IOASID_BASE + 3)
> > #define IOASID_FREE	_IO(IOASID_TYPE, IOASID_BASE + 4)
>=20
> I assume alloc will include quite a big structure to satisfy the
> various vendor needs?

I'll skip below /dev/ioasid uAPI comments about alloc/bind. It's already=20
covered in other sub-threads.

[...]
=20
> >
> > 2.2. /dev/vfio uAPI
> > ++++++++++++++++
>=20
> To be clear you mean the 'struct vfio_device' API, these are not
> IOCTLs on the container or group?

Exactly

>=20
> > /*
> >    * Bind a vfio_device to the specified IOASID fd
> >    *
> >    * Multiple vfio devices can be bound to a single ioasid_fd, but a si=
ngle
> >    * vfio device should not be bound to multiple ioasid_fd's.
> >    *
> >    * Input parameters:
> >    *  - ioasid_fd;
> >    *
> >    * Return: 0 on success, -errno on failure.
> >    */
> > #define VFIO_BIND_IOASID_FD           _IO(VFIO_TYPE, VFIO_BASE + 22)
> > #define VFIO_UNBIND_IOASID_FD _IO(VFIO_TYPE, VFIO_BASE + 23)
>=20
> This is where it would make sense to have an output "device id" that
> allows /dev/ioasid to refer to this "device" by number in events and
> other related things.

As chatted earlier, either an input or output "device id" is fine here.

>=20
> >
> > 2.3. KVM uAPI
> > ++++++++++++
> >
> > /*
> >   * Update CPU PASID mapping
> >   *
> >   * This is necessary when ENQCMD will be used in the guest while the
> >   * targeted device doesn't accept the vPASID saved in the CPU MSR.
> >   *
> >   * This command allows user to set/clear the vPASID->pPASID mapping
> >   * in the CPU, by providing the IOASID (and FD) information representi=
ng
> >   * the I/O address space marked by this vPASID.
> >   *
> >   * Input parameters:
> >   *	- user_pasid;
> >   *	- ioasid_fd;
> >   *	- ioasid;
> >   */
> > #define KVM_MAP_PASID	_IO(KVMIO, 0xf0)
> > #define KVM_UNMAP_PASID	_IO(KVMIO, 0xf1)
>=20
> It seems simple enough.. So the physical PASID can only be assigned if
> the user has an IOASID that points at it? Thus it is secure?

Yes. The kernel doesn't trust user to provide a random physical PASID.

>=20
> > 3. Sample structures and helper functions
> >
> > Three helper functions are provided to support VFIO_BIND_IOASID_FD:
> >
> > 	struct ioasid_ctx *ioasid_ctx_fdget(int fd);
> > 	int ioasid_register_device(struct ioasid_ctx *ctx, struct ioasid_dev
> *dev);
> > 	int ioasid_unregister_device(struct ioasid_dev *dev);
> >
> > An ioasid_ctx is created for each fd:
> >
> > 	struct ioasid_ctx {
> > 		// a list of allocated IOASID data's
> > 		struct list_head		ioasid_list;
>=20
> Would expect an xarray
>=20
> > 		// a list of registered devices
> > 		struct list_head		dev_list;
>=20
> xarray of device_id

list of ioasid_dev objects. device_id will be put inside each object.

>=20
> > 		// a list of pre-registered virtual address ranges
> > 		struct list_head		prereg_list;
>=20
> Should re-use the existing SW IOASID table, and be an interval tree.

What is the existing SW IOASID table?

>=20
> > Each registered device is represented by ioasid_dev:
> >
> > 	struct ioasid_dev {
> > 		struct list_head		next;
> > 		struct ioasid_ctx	*ctx;
> > 		// always be the physical device
> > 		struct device 		*device;
> > 		struct kref		kref;
> > 	};
> >
> > Because we assume one vfio_device connected to at most one ioasid_fd,
> > here ioasid_dev could be embedded in vfio_device and then linked to
> > ioasid_ctx->dev_list when registration succeeds. For mdev the struct
> > device should be the pointer to the parent device. PASID marking this
> > mdev is specified later when VFIO_ATTACH_IOASID.
>=20
> Don't embed a struct like this in something with vfio_device - that
> just makes a mess of reference counting by having multiple krefs in
> the same memory block. Keep it as a pointer, the attach operation
> should return a pointer to the above struct.

OK. Also based on the agreement that one device can bind to multiple
fd's, this struct embed approach also doesn't work then.

>=20
> > An ioasid_data is created when IOASID_ALLOC, as the main object
> > describing characteristics about an I/O page table:
> >
> > 	struct ioasid_data {
> > 		// link to ioasid_ctx->ioasid_list
> > 		struct list_head		next;
> >
> > 		// the IOASID number
> > 		u32			ioasid;
> >
> > 		// the handle to convey iommu operations
> > 		// hold the pgd (TBD until discussing iommu api)
> > 		struct iommu_domain *domain;
>=20
> But at least for the first coding draft I would expect to see this API
> presented with no PASID support and a simple 1:1 with iommu_domain.
> How
> PASID gets modeled is the big TBD, right?

yes. As the starting point we will assume 1:1 association. This should
work for PF/VF. But very soon mdev must be considered. I expect=20
we can start conversation on PASID support once this uAPI proposal
is settled down.

>=20
> > ioasid_data and iommu_domain have overlapping roles as both are
> > introduced to represent an I/O address space. It is still a big TBD how
> > the two should be corelated or even merged, and whether new iommu
> > ops are required to handle RID+PASID explicitly.
>=20
> I think it is OK that the uapi and kernel api have different
> structs. The uapi focused one should hold the uapi related data, which
> is what you've shown here, I think.
>=20
> > Two helper functions are provided to support VFIO_ATTACH_IOASID:
> >
> > 	struct attach_info {
> > 		u32	ioasid;
> > 		// If valid, the PASID to be used physically
> > 		u32	pasid;
> > 	};
> > 	int ioasid_device_attach(struct ioasid_dev *dev,
> > 		struct attach_info info);
> > 	int ioasid_device_detach(struct ioasid_dev *dev, u32 ioasid);
>=20
> Honestly, I still prefer this to be highly explicit as this is where
> all device driver authors get invovled:
>=20
> ioasid_pci_device_attach(struct pci_device *pdev, struct ioasid_dev *dev,
> u32 ioasid);
> ioasid_pci_device_pasid_attach(struct pci_device *pdev, u32 *physical_pas=
id,
> struct ioasid_dev *dev, u32 ioasid);

Then better naming it as pci_device_attach_ioasid since the 1st parameter
is struct pci_device?

By keeping physical_pasid as a pointer, you want to remove the last helper
function (ioasid_get_global_pasid) so the global pasid is returned along
with the attach function?

>=20
> And presumably a variant for ARM non-PCI platform (?) devices.
>=20
> This could boil down to a __ioasid_device_attach() as you've shown.
>=20
> > A new object is introduced and linked to ioasid_data->attach_data for
> > each successful attach operation:
> >
> > 	struct ioasid_attach_data {
> > 		struct list_head		next;
> > 		struct ioasid_dev	*dev;
> > 		u32 			pasid;
> > 	}
>=20
> This should be returned as a pointer and detatch should be:
>=20
> int ioasid_device_detach(struct ioasid_attach_data *);

ok

>=20
> > As explained in the design section, there is no explicit group enforcem=
ent
> > in /dev/ioasid uAPI or helper functions. But the ioasid driver does
> > implicit group check - before every device within an iommu group is
> > attached to this IOASID, the previously-attached devices in this group =
are
> > put in ioasid_data->partial_devices. The IOASID rejects any command if
> > the partial_devices list is not empty.
>=20
> It is simple enough. Would be good to design in a diagnostic string so
> userspace can make sense of the failure. Eg return something like
> -EDEADLK and provide an ioctl 'why did EDEADLK happen' ?
>=20

Make sense.

>=20
> > Then is the last helper function:
> > 	u32 ioasid_get_global_pasid(struct ioasid_ctx *ctx,
> > 		u32 ioasid, bool alloc);
> >
> > ioasid_get_global_pasid is necessary in scenarios where multiple device=
s
> > want to share a same PASID value on the attached I/O page table (e.g.
> > when ENQCMD is enabled, as explained in next section). We need a
> > centralized place (ioasid_data->pasid) to hold this value (allocated wh=
en
> > first called with alloc=3Dtrue). vfio device driver calls this function=
 (alloc=3D
> > true) to get the global PASID for an ioasid before calling ioasid_devic=
e_
> > attach. KVM also calls this function (alloc=3Dfalse) to setup PASID tra=
nslation
> > structure when user calls KVM_MAP_PASID.
>=20
> When/why would the VFIO driver do this? isn't this just some varient
> of pasid_attach?
>=20
> ioasid_pci_device_enqcmd_attach(struct pci_device *pdev, u32
> *physical_pasid, struct ioasid_dev *dev, u32 ioasid);
>=20
> ?

will adopt this way.

>=20
> > 4. PASID Virtualization
> >
> > When guest SVA (vSVA) is enabled, multiple GVA address spaces are
> > created on the assigned vfio device. This leads to the concepts of
> > "virtual PASID" (vPASID) vs. "physical PASID" (pPASID). vPASID is assig=
ned
> > by the guest to mark an GVA address space while pPASID is the one
> > selected by the host and actually routed in the wire.
> >
> > vPASID is conveyed to the kernel when user calls VFIO_ATTACH_IOASID.
>=20
> Should the vPASID programmed into the IOASID before calling
> VFIO_ATTACH_IOASID?

No. As explained in earlier reply, when multiple devices are attached
to the same IOASID the guest may link the page table to different
vPASID# cross attached devices. Anyway vPASID is a per-RID thing.

>=20
> > vfio device driver translates vPASID to pPASID before calling ioasid_at=
tach_
> > device, with two factors to be considered:
> >
> > -    Whether vPASID is directly used (vPASID=3D=3DpPASID) in the wire, =
or
> >      should be instead converted to a newly-allocated one (vPASID!=3D
> >      pPASID);
> >
> > -    If vPASID!=3DpPASID, whether pPASID is allocated from per-RID PASI=
D
> >      space or a global PASID space (implying sharing pPASID cross devic=
es,
> >      e.g. when supporting Intel ENQCMD which puts PASID in a CPU MSR
> >      as part of the process context);
>=20
> This whole section is 4 really confusing. I think it would be more
> understandable to focus on the list below and minimize the vPASID
>=20
> > The actual policy depends on pdev vs. mdev, and whether ENQCMD is
> > supported. There are three possible scenarios:
> >
> > (Note: /dev/ioasid uAPI is not affected by underlying PASID virtualizat=
ion
> > policies.)
>=20
> This has become unclear. I think this should start by identifying the
> 6 main type of devices and how they can use pPASID/vPASID:
>=20
> 0) Device is a RID and cannot issue PASID
> 1) Device is a mdev and cannot issue PASID
> 2) Device is a mdev and programs a single fixed PASID during bind,
>    does not accept PASID from the guest

There are no vPASID per se in above 3 types. So this section only
focus on the latter 3 types. But I can include them in next version
if it sets the tone clearer.

>=20
> 3) Device accepts any PASIDs from the guest. No
>    vPASID/pPASID translation is possible. (classic vfio_pci)
> 4) Device accepts any PASID from the guest and has an
>    internal vPASID/pPASID translation (enhanced vfio_pci)

what is enhanced vfio_pci? In my writing this is for mdev
which doesn't support ENQCMD

> 5) Device accepts and PASID from the guest and relys on
>    external vPASID/pPASID translation via ENQCMD (Intel SIOV mdev)
>=20
> 0-2 don't use vPASID at all
>=20
> 3-5 consume a vPASID but handle it differently.
>=20
> I think the 3-5 map into what you are trying to explain in the table
> below, which is the rules for allocating the vPASID depending on which
> of device types 3-5 are present and or mixed.

Exactly

>=20
> For instance device type 3 requires vPASID =3D=3D pPASID because it can't
> do translation at all.
>=20
> This probably all needs to come through clearly in the /dev/ioasid
> interface. Once the attached devices are labled it would make sense to
> have a 'query device' /dev/ioasid IOCTL to report the details based on
> how the device attached and other information.

This is a good point. Another benefit of having a device label.

for 0-2 the device will report no PASID support. Although this may duplicat=
e
with other information (e.g. PCI PASID cap), this provides a vendor-agnosti=
c
way for reporting details around IOASID.

for 3-5 the device will report PASID support. In these cases the user is
expected to always provide a vPASID.=20

for 5 in addition the device will report a requirement on CPU PASID=20
translation. For such device the user should talk to KVM to setup the PASID
mapping. This way the user doesn't need to know whether a device is
pdev or mdev. Just follows what device capability reports.

>=20
> > 2)  mdev: vPASID!=3DpPASID (per-RID if w/o ENQCMD, otherwise global)
> >
> >      PASIDs are also used by kernel to mark the default I/O address spa=
ce
> >      for mdev, thus cannot be delegated to the guest. Instead, the mdev
> >      driver must allocate a new pPASID for each vPASID (thus vPASID!=3D
> >      pPASID) and then use pPASID when attaching this mdev to an ioasid.
>=20
> I don't understand this at all.. What does "PASIDs are also used by
> the kernel" mean?

Just refer to your type-2. Because PASIDs on this device are already used
by the parent driver to mark mdev, we cannot delegate the per-RID space
to the guest.

>=20
> >      The mdev driver needs cache the PASID mapping so in mediation
> >      path vPASID programmed by the guest can be converted to pPASID
> >      before updating the physical MMIO register.
>=20
> This is my scenario #4 above. Device and internally virtualize
> vPASID/pPASID - how that is done is up to the device. But this is all
> just labels, when such a device attaches, it should use some specific
> API:
>=20
> ioasid_pci_device_vpasid_attach(struct pci_device *pdev,
>  u32 *physical_pasid, u32 *virtual_pasid, struct ioasid_dev *dev, u32 ioa=
sid);

yes.

>=20
> And then maintain its internal translation
>=20
> >      In previous thread a PASID range split scheme was discussed to sup=
port
> >      this combination, but we haven't worked out a clean uAPI design ye=
t.
> >      Therefore in this proposal we decide to not support it, implying t=
he
> >      user should have some intelligence to avoid such scenario. It coul=
d be
> >      a TODO task for future.
>=20
> It really just boils down to how to allocate the PASIDs to get around
> the bad viommu interface that assumes all PASIDs are usable by all
> devices.

viommu (e.g. Intel VT-d) has good interface to restrict how many PASIDs
are available to the guest. There is a PASID size filed in the viommu=20
register. Here the puzzle is just about how to design a good uAPI to=20
handle this mixed scenario where vPASID/pPASID are in split range and=20
must be linked to the same I/O page table together.

I'll see whether this can be afforded after addressing other comments
in this section.

>=20
> > In spite of those subtle considerations, the kernel implementation coul=
d
> > start simple, e.g.:
> >
> > -    v=3D=3Dp for pdev;
> > -    v!=3Dp and always use a global PASID pool for all mdev's;
>=20
> Regardless all this mess needs to be hidden from the consuming drivers
> with some simple APIs as above. The driver should indicate what its HW
> can do and the PASID #'s that magically come out of /dev/ioasid should
> be appropriate.
>=20

Yes, I see how it should work now.

Thanks
Kevin
