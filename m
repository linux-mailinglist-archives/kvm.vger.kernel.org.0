Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23B67397E06
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 03:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbhFBB05 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 21:26:57 -0400
Received: from mga11.intel.com ([192.55.52.93]:63512 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229947AbhFBB04 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Jun 2021 21:26:56 -0400
IronPort-SDR: j0cJDtR6aW2fUBhXmHMogwN197C6P9rT27I5CgLK7szjSov0G9fCtzGe9IoemjGIpJfthmedSn
 XCBYjrp87Uug==
X-IronPort-AV: E=McAfee;i="6200,9189,10002"; a="200667134"
X-IronPort-AV: E=Sophos;i="5.83,241,1616482800"; 
   d="scan'208";a="200667134"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2021 18:25:11 -0700
IronPort-SDR: pplV3t5wL9jwG0yezF/vcL//JCkT2VzUHbQp4GOU+5+vcT6ISxfpIvC706P7wkS+MhMeFQGHtH
 RrPojtCK0EkA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,241,1616482800"; 
   d="scan'208";a="549947510"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga001.fm.intel.com with ESMTP; 01 Jun 2021 18:25:09 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Tue, 1 Jun 2021 18:25:04 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Tue, 1 Jun 2021 18:25:04 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Tue, 1 Jun 2021 18:25:04 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.173)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Tue, 1 Jun 2021 18:25:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YLQzgiXXnnHbDnQcwMg0VN7gXkpFTWaUUBEU5V84n9CDPOEPUHvP2YZV759U/LptzX90gdAJZRdusjPF0pfK3o6ul/X3/UX+ELru9MlnELm151k0V9RvnZC+Ro3OtSIWE+0SklUcmbfB1NEUNthzFodVY+B/NLmI8V/9q5aqaxFTovT69aBXUIRy/DCdc9slchgJDgrvbwH8oUmzzprvm33fhZJWrEtmkZVobQHWh0Kr/NG8Abr+wVCrulEK0VU692EQoUB5W6t40YPwv0f3uRcOPYlfuxRyVxivx4QR+yN7MgK4CsM5cTJyh5AzWItfd8NUp0+eBD2X8AT5EROZng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mHUD+r2zSTqScvGQTNZZZ1N+azdwv1XgrW05HcJji5U=;
 b=WQwZQ6CyomAaijTMspV+Lu+st/tOuEEy5Lchb23xjUUL21bJw5meKWlo9FGjsriDFj462pxIC/wZ9q/OJfyhWv2SN0B21jimoKo7W/fBzx6zbcIbUYzRC8kH13WCYPoBbbenQqT8PsjVIVkOrtTDvIZtbBYa73mviyi3VrgS9aG/qhJs3HHeS1LjS7F4aBrXlHkGEryF5InnPzl4TVC9vhMr6hODIWc5XDfH5np8j8kxpEQWQ/98GyHgttNKk9cDC9FeGENM5LtrEjosu2OYWVTF/LGLQiP4Y27kbt6qbF/c9lId/QfEMD0MIDrzG//PspsQs5tnk06S8i9qWHc2lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mHUD+r2zSTqScvGQTNZZZ1N+azdwv1XgrW05HcJji5U=;
 b=AJSPYqjU8UkXSLU6Cm/sClUbZBkPGZyjlFuZEYoDXukO5i3rlFQ2Ofq9Cp7TkvgzQ9FsOlNPgH9WGT+0xHWItGAUVnEpa8CvR+SRNbUL1S0JStgezy1aGoe3HZExKlfTSxQcamBW4xTzMnGdWJtvDJFvfHDlqknbnraf+SLFopM=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by MW3PR11MB4634.namprd11.prod.outlook.com (2603:10b6:303:54::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.24; Wed, 2 Jun
 2021 01:25:01 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1%12]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 01:25:00 +0000
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
Thread-Index: AddSzQ970oLnVHLeQca/ysPD8zMJZwBL2ymAAKTbxpAAJTGVAAAJnz8Q
Date:   Wed, 2 Jun 2021 01:25:00 +0000
Message-ID: <MWHPR11MB1886172080807517E92A8EF68C3D9@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210528200311.GP1002214@nvidia.com>
 <MWHPR11MB188685D57653827B566BF9B38C3E9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210601202834.GR1002214@nvidia.com>
In-Reply-To: <20210601202834.GR1002214@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.143.24]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d4b83098-0fdf-4386-b44a-08d925653dce
x-ms-traffictypediagnostic: MW3PR11MB4634:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR11MB46348FFFC3230B992988B7C78C3D9@MW3PR11MB4634.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: O7+Nec1xtVTG/9jK+UNN3L1LrBVA600g6iJcKo4bAhGycZyhx6VtR65TJWJAQQuloNRI9eZNjlTsFKpsKHW0F4WOS7VFUw15lG+wjoZM7ZXPPzdo6NosDpffPcvHhihOsnFT7ACEowe1IgDy47iMhNhT8s6InrPnRaf1L9J0XuH6b1LW/iO19vwOwbfGE8S+HzJtFezkCBKgUmU/uqbwZiUZHkOtdtpEYTTmuZY+0fv5xB2USNZl2zdyFNq/g9jY9emCanwMxX5fIoyAHBoGIJSzYo8wxstcD9kfLgu8MlK/P5eho0Lm5MTkU7LgN5lLppoBGdTpnwAv0xxSW1oDrjyfSgxLCFyLAhTI8MCQ0V2ylu/CJSi6jsi+OQgPXh1mDMmgsSdqIdEfwTitWHHSwVo/TsXVS6ISfjtDh/QFzwTtR0SmoLefQx7IwAzvcq2c9r+XEpbi9odgc6y3dgFPS9YJzHFE4aJ5aznkrXL5ygsm4yKRa07tPkJMreTTFMIg4sQP4GOxww0jYbxw5pRmWqCURJfSYj189D4AukDVuY7gyW1x1wO9xWvyy1KXn9d3p1wZ5V0vp5eR3pl9Bg2IKMmVV0cl5vlrHMCHcC5xaF4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(136003)(346002)(376002)(366004)(5660300002)(76116006)(83380400001)(4326008)(66556008)(38100700002)(66476007)(33656002)(66946007)(64756008)(86362001)(7696005)(66446008)(186003)(8936002)(26005)(478600001)(8676002)(9686003)(316002)(71200400001)(54906003)(52536014)(6506007)(122000001)(7416002)(6916009)(2906002)(55016002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?JwZnXO0ntmWvLICSZE42jypmtFy9GxHzZzegOfutWS+28EzcruxD6OwN22bl?=
 =?us-ascii?Q?/l2hk1Q9i25b6JXpDMcYmSjroylOR1p8Octfa5JELAWmUQ/NtqKYXC13HvrT?=
 =?us-ascii?Q?AkAw3a/Wpcro1+hNEiWaTcR9vp5JnPYNjvyILI16Cjuxi1Z8ZM8lcPj4RQ+2?=
 =?us-ascii?Q?lwmVxIujROcwpJGDFZGYtmofohUQ7+383B3ahqOKNDBuTC97ggd4Xs2LdWN0?=
 =?us-ascii?Q?y2paeT/Z9jtnD8OOMs5lRpm46EtZ4SUQSiBFfQYKZKoVVZjgiMf9BfiTStMh?=
 =?us-ascii?Q?0uIbiercfDq793DgHW1q8zZBTW5FIV4CT5jpuZNrkd3aLw+/PAfJVdWI6d6U?=
 =?us-ascii?Q?T+0tqM99esyeX0E6dayZ5qdryLAHl4zzN3GP03RHz7eQMfsZysTmheaTaX/C?=
 =?us-ascii?Q?xzI1mLaJp+OlfqOlgB+YAlNTJ3FWrLkP2QIeaYK0U6hC+RbnRGFYRdK9Dtev?=
 =?us-ascii?Q?EKLNXC7U48L7zCGR3KJwzX/Rs3y0YJ7tJNWiPvMga218okVasAb+OyQ1i/U+?=
 =?us-ascii?Q?stH6PMEv8/eV1KWaMmVi7sLR+z5QOJaCyjyhCNaaKFt2wTpbTcXn4yqU7ES7?=
 =?us-ascii?Q?g+v6/u2eO6Xgsj4rRCrTufte3m/fxbwsD2T9GdB7MEXadG74X9YQDuAjT6W1?=
 =?us-ascii?Q?SJ5lgJ8zq9OFGOWSsmrza2PFIusQkFXJCVSmb97bjpQw4qUkwVHSjEwCr7LR?=
 =?us-ascii?Q?s3tfjmMMSCB5i2n/XPLwSZxSuo9UzEoAnqdylNKQ1jNRoFqJ8cVupGVPD6Gf?=
 =?us-ascii?Q?aWxIVNXGmqR7+EOCBDsCL9elGw8ES0hQfzMkQ0fVGtE1yTayJ5ODCu0/H+0q?=
 =?us-ascii?Q?33ZvHRjE0EtAVQcEP2GJ29rbHKvIFAhn8/NsaFbO84bFHximnru7E24A3umG?=
 =?us-ascii?Q?773lNLE41ZnfRexijqbSW+jEeKqIO7i33mcCwhcJu8UQjVjCjmelZOwMbUSm?=
 =?us-ascii?Q?pNDkADPUA0Jz2F64uaEOON0Wq5/dj+y0bOyz7WRphOUL2XRUZSU5iys5kPmN?=
 =?us-ascii?Q?9BNaOR1/L/8Zui8L3VnwSUdtbCKikco4n7boPnYbATMUzTJZsKoo42dmpNWu?=
 =?us-ascii?Q?Rm/Pp4W9HfZwK6SYjC9Mzxi08Vz8FcdvV+2UrNNMX2HGLKgMB93pDrlnjJ+u?=
 =?us-ascii?Q?kD4Jfs3K7F5glu/mfe7zCRgw5NnJum8BQVOgOzOofX3PsJTPp8Uf854hOFv1?=
 =?us-ascii?Q?+f9jnRzwJZiPEP8SRRe5dIEw6GZMZdj2YCP8iHrT3NxsGebARE/mtJQBzQD1?=
 =?us-ascii?Q?XJHVKpVtFeSsMK5d3SV1juTfhcEtCg1HSdVVkZQxic4R/6Eafr7qqH3HQKi1?=
 =?us-ascii?Q?pb0bZBlEVywikY2MVO0EWJ2R?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4b83098-0fdf-4386-b44a-08d925653dce
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jun 2021 01:25:00.3209
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KLAsY1BXlQXuJpSrT0T2GxOMt+NPp2IJZzVoVUjC3u01nX81tv+dDszPKVFPp/VT7AEg2whOBG+OKe4jwLwgtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4634
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, June 2, 2021 4:29 AM
>=20
> On Tue, Jun 01, 2021 at 07:01:57AM +0000, Tian, Kevin wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Saturday, May 29, 2021 4:03 AM
> > >
> > > On Thu, May 27, 2021 at 07:58:12AM +0000, Tian, Kevin wrote:
> > > > /dev/ioasid provides an unified interface for managing I/O page tab=
les
> for
> > > > devices assigned to userspace. Device passthrough frameworks (VFIO,
> > > vDPA,
> > > > etc.) are expected to use this interface instead of creating their =
own
> logic to
> > > > isolate untrusted device DMAs initiated by userspace.
> > >
> > > It is very long, but I think this has turned out quite well. It
> > > certainly matches the basic sketch I had in my head when we were
> > > talking about how to create vDPA devices a few years ago.
> > >
> > > When you get down to the operations they all seem pretty common
> sense
> > > and straightfoward. Create an IOASID. Connect to a device. Fill the
> > > IOASID with pages somehow. Worry about PASID labeling.
> > >
> > > It really is critical to get all the vendor IOMMU people to go over i=
t
> > > and see how their HW features map into this.
> > >
> >
> > Agree. btw I feel it might be good to have several design opens
> > centrally discussed after going through all the comments. Otherwise
> > they may be buried in different sub-threads and potentially with
> > insufficient care (especially for people who haven't completed the
> > reading).
> >
> > I summarized five opens here, about:
> >
> > 1)  Finalizing the name to replace /dev/ioasid;
> > 2)  Whether one device is allowed to bind to multiple IOASID fd's;
> > 3)  Carry device information in invalidation/fault reporting uAPI;
> > 4)  What should/could be specified when allocating an IOASID;
> > 5)  The protocol between vfio group and kvm;
> >
> > For 1), two alternative names are mentioned: /dev/iommu and
> > /dev/ioas. I don't have a strong preference and would like to hear
> > votes from all stakeholders. /dev/iommu is slightly better imho for
> > two reasons. First, per AMD's presentation in last KVM forum they
> > implement vIOMMU in hardware thus need to support user-managed
> > domains. An iommu uAPI notation might make more sense moving
> > forward. Second, it makes later uAPI naming easier as 'IOASID' can
> > be always put as an object, e.g. IOMMU_ALLOC_IOASID instead of
> > IOASID_ALLOC_IOASID. :)
>=20
> I think two years ago I suggested /dev/iommu and it didn't go very far
> at the time. We've also talked about this as /dev/sva for a while and
> now /dev/ioasid
>=20
> I think /dev/iommu is fine, and call the things inside them IOAS
> objects.
>=20
> Then we don't have naming aliasing with kernel constructs.
>=20
> > For 2), Jason prefers to not blocking it if no kernel design reason. If
> > one device is allowed to bind multiple IOASID fd's, the main problem
> > is about cross-fd IOASID nesting, e.g. having gpa_ioasid created in fd1
> > and giova_ioasid created in fd2 and then nesting them together (and
>=20
> Huh? This can't happen
>=20
> Creating an IOASID is an operation on on the /dev/ioasid FD. We won't
> provide APIs to create a tree of IOASID's outside a single FD container.
>=20
> If a device can consume multiple IOASID's it doesn't care how many or
> what /dev/ioasid FDs they come from.

OK, this implies that if one user inadvertently creates intended parent/
child via different fd's then the operation will simply fail. More specific=
ally
taking ARM's case for example. There is only a single 2nd-level I/O page
table per device (nested by multiple 1st-level tables). Say the user alread=
y=20
creates a gpa_ioasid for a device via fd1. Now he binds the device to fd2,=
=20
intending to enable vSVA which requires nested translation thus needs=20
create a parent via fd2. This parent creation will simply fail by the IOMMU=
=20
layer because the 2nd-level (via fd1) is already installed for this device.

>=20
> > To the other end there was also thought whether we should make
> > a single I/O address space per IOASID fd. This was discussed in previou=
s
> > thread that #fd's are insufficient to afford theoretical 1M's address
> > spaces per device. But let's have another revisit and draw a clear
> > conclusion whether this option is viable.
>=20
> I had remarks on this, I think per-fd doesn't work
>=20
> > This implies that VFIO_BOUND_IOASID will be extended to allow user
> > specify a device label. This label will be recorded in /dev/iommu to
> > serve per-device invalidation request from and report per-device
> > fault data to the user.
>=20
> I wonder which of the user providing a 64 bit cookie or the kernel
> returning a small IDA is the best choice here? Both have merits
> depending on what qemu needs..

Yes, either way can work. I don't have a strong preference. Jean?

>=20
> > In addition, vPASID (if provided by user) will
> > be also recorded in /dev/iommu so vPASID<->pPASID conversion
> > is conducted properly. e.g. invalidation request from user carries
> > a vPASID which must be converted into pPASID before calling iommu
> > driver. Vice versa for raw fault data which carries pPASID while the
> > user expects a vPASID.
>=20
> I don't think the PASID should be returned at all. It should return
> the IOASID number in the FD and/or a u64 cookie associated with that
> IOASID. Userspace should figure out what the IOASID & device
> combination means.

This is true for Intel. But what about ARM which has only one IOASID
(pasid table) per device to represent all guest I/O page tables?

>=20
> > Seems to close this design open we have to touch the kAPI design. and
> > Joerg's input is highly appreciated here.
>=20
> uAPI is forever, the kAPI is constantly changing. I always dislike
> warping the uAPI based on the current kAPI situation.
>=20

I got this point. My point was that I didn't see significant gain from eith=
er=20
option thus to better compare the two uAPI options we might want to=20
further consider the involved kAPI effort as another factor.

Thanks
Kevin
