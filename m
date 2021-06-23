Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25BD73B2409
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 01:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbhFWXnb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 19:43:31 -0400
Received: from mga18.intel.com ([134.134.136.126]:44431 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229755AbhFWXna (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Jun 2021 19:43:30 -0400
IronPort-SDR: n7ldQHDoanCFoBsmpybmt/jlNvtG0O9nd2rFJr76c/8zpY/L3GWJjEDLk3fGduOjYWwLqvh+Yt
 Kh4aBzSyZehw==
X-IronPort-AV: E=McAfee;i="6200,9189,10024"; a="194666792"
X-IronPort-AV: E=Sophos;i="5.83,295,1616482800"; 
   d="scan'208";a="194666792"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2021 16:41:12 -0700
IronPort-SDR: IR+qu0Q4QcWy1+J31thSeCmmzqnIRzFdJ7FlONM87ZPg0biFHeJ/YnNig7sY11FRUwM5yLwyaB
 3nY7mpmkRAdg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,295,1616482800"; 
   d="scan'208";a="490898217"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga002.fm.intel.com with ESMTP; 23 Jun 2021 16:41:12 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Wed, 23 Jun 2021 16:41:11 -0700
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Wed, 23 Jun 2021 16:41:11 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Wed, 23 Jun 2021 16:41:11 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.105)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Wed, 23 Jun 2021 16:41:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OoB1cbyw+qwYOa5C+NYQlnVkhPaAihl09vDQqMsvvXzU3FcgIp/raVcz9F4DwZbbCgmMh81jMmsRK+HXNhT6ZUNDZ+5pAi2qYBgq2OPR0E10iDjC/Y6X2/R10hg6qgD3+TKjmGlPPRASGxFUn3QEYxT6cxM/T1lossyYuyeOL7lGwk7zWkliTbIMzfeqhAKRnJKlS1t8ZW8wCBQktEd1a3p3ySYkF8tG1R1dVlFZP9psry4vYW4g+V1FDoqoXCIyOgdcqho80m4II4+zW/KaTaGHeqkTRmA9L9JV41i0yfo/12pEaDQFlfhCapp3BU1YEuAPLZW1Vxq6Gtmiplu+lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a+PKy3KH3v8RBMkiPZFTn3sZUKj1uALSqOA0guyjYS0=;
 b=Q7/AvKxr9JFQFInEbSN/E7LE6c7CtQIjik4yOPAIIRbi9xU3YOn7yY+iv8SuxgrFOdcqd3wPgMvd+K/1DQQZUMpphf+KKsZjWzg5kpO5kI3+imKfxO/7Epkb9wJ6U+DVbN59zefj689IBxqBAOwp2NjyB5ZA5IEWpKlyn0cU/n8sBZ9vAAshcbcotI+Sw04R5QkpkA5FWL9Mh3e8bi5tqR6R6mS9V09A5061/l/fi5Mr1n5lOe5bx/48eGjCImp/HMi41yko4mdCdfbYbZA/ThPQh+GcuJuaag7dXtMlAf7R5pNcPsAic5PWxIkeQK+5PwxuwNm6hh34qt8zOA5TJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a+PKy3KH3v8RBMkiPZFTn3sZUKj1uALSqOA0guyjYS0=;
 b=j4+hKqO2IfwjOrL9MLjV4j5QzhSZdqjoilD9KqNzSdfeFz1qYNwln707kjd6KLI1nEV3zRuc9Yafmu8HFUx91q0qznxoPgXmbVVTsLKKWhPJVvh4Cx0PO1Zj+TUDptnLC7Wz5rYXDHoKIPWXj1FIcaEk3ipmtx07u6l22J6v01U=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by MWHPR11MB1696.namprd11.prod.outlook.com (2603:10b6:300:23::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.19; Wed, 23 Jun
 2021 23:41:09 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1%12]) with mapi id 15.20.4242.024; Wed, 23 Jun
 2021 23:41:09 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        "Dey, Megha" <megha.dey@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        "Bjorn Helgaas" <helgaas@kernel.org>
Subject: RE: Virtualizing MSI-X on IMS via VFIO
Thread-Topic: Virtualizing MSI-X on IMS via VFIO
Thread-Index: AddnMs7+4GfLhTceT8q8tdV8716lmQAZ7UiAAAoHBgAACsXtAAAX4LwAAABVr4AADozDgA==
Date:   Wed, 23 Jun 2021 23:41:09 +0000
Message-ID: <MWHPR11MB188642E26DB4D5C541E5DCF18C089@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <20210622131217.76b28f6f.alex.williamson@redhat.com>
 <87o8bxcuxv.ffs@nanos.tec.linutronix.de>
 <MWHPR11MB1886811339F7873A8E34549A8C089@MWHPR11MB1886.namprd11.prod.outlook.com>
 <87bl7wczkp.ffs@nanos.tec.linutronix.de>
 <20210623164109.GL2371267@nvidia.com>
In-Reply-To: <20210623164109.GL2371267@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.142.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b26ddc81-d6b8-4608-2cd2-08d936a060aa
x-ms-traffictypediagnostic: MWHPR11MB1696:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB1696E36F109C5ED6093CE3DE8C089@MWHPR11MB1696.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GcONv4nxkHdImTyxUXTAuIymMPYIN2Y4hSqzHODMWy7IldJ14q4QOsZJnsA7vbHoqLdw1goLNISSNFy1pC/Ms6OG3sgQ1x74fyrNCAYatddekp5Dmv4HhIWTG8D6Wp4bLoY6Mvo1bpmX7TQc53T3i31Xfew0GWTTOnb4oN/mAjfDIceXrYdsTfuWtJt5wiUlU24hjMk2SQxiKJYGRVYXN5dMHVEyBWtBapieKSqlRk+uoYG5fEYwLisW6DiWBt6S/B23+nZzT68sWlWMeJx0ZJQT+kzdB8WfHGKWyJaFiTgvBbaFU4wgX492f7JcdVCJXoHXi1AF12akBZXY2MG6ZcxQ8UoZb/4+oN0MB8s8iBIEB+MWRI1oA358EYchmHdQMcQd1vtaHYkMYzOFm3dEw4jVH0fpwJaSIlFzsZUwCrtEkGvFVEKb8wlIk7j2qeVJg8P9cspIHdgEo6qLqhRKXhs0AA/qTFVedfyJRBeazGVDQfdcOJ7eMtFKDEiYpglOxVjleVmUNvtwAZa//rA3ydDDai+r5RTYF2KMK21viJgCGVP/dx1e+ehrukIITIxfUOAMfShXQ4jAlOvs6P+qMXuGbaUqsB4odd+z/nRs9vs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(376002)(136003)(39860400002)(396003)(7416002)(86362001)(52536014)(122000001)(5660300002)(38100700002)(316002)(9686003)(55016002)(26005)(4326008)(8676002)(7696005)(186003)(71200400001)(2906002)(33656002)(6506007)(8936002)(66946007)(76116006)(54906003)(478600001)(66556008)(64756008)(66446008)(66476007)(110136005)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?FhOBc757L0+06lpEF8nsrKnvZNqczOMzrXFb1I2DYz7XdrC0bXEG5QpC8wIS?=
 =?us-ascii?Q?vSTapUaA7K13XGm6AL1lZPALPnvkyeI+2BG276eLTOFyHgIy0IBaUwD3XA84?=
 =?us-ascii?Q?4gWTd6ALYeFq7D9C5lxBefzhJLDZudwy1iC2wXOZrZPU7fj3M370vbSk/7Xv?=
 =?us-ascii?Q?R/IHursGISe8fSUbl7CBshIVgTBKoHtAPSwGoqEC3cnNBJw07RlaQ4my1MU0?=
 =?us-ascii?Q?aZUs2bNlD9sg4oeOqRIwM8TwKAEI/nUeWQrTAEjGLO/0WLbjMz0xPIyybgwS?=
 =?us-ascii?Q?AfDsptXnj3bX0qRIh9zIK+A4vg3YlevfdBU3l7JawEqoTPzgDGrNgMbG8Qwa?=
 =?us-ascii?Q?YaMgQCeUsm5czXr7jJ1n6ABLFz5efC2f44baV2whqV+hGhi1VVIR+rfwk9/N?=
 =?us-ascii?Q?m8q8gBe9MNXsEZ7Q0SCE8x2tgq5cDq80Wn526fSeLboUMDr1QbMnyVhttu7s?=
 =?us-ascii?Q?5mdHFhReh+qqko8e28+jMP0Ab77+rsrdDDtN7sb4Oek+AfJizZseaLn8VmoV?=
 =?us-ascii?Q?BGuCn+x3a3TB08TIQygxsKCxTy3g/Hl5REFq5RZp37gvCmvR7K34JGS87qV0?=
 =?us-ascii?Q?xDCVADYlgnth53DyJqwCmjPa+l04SYFFExSCjyXGOVxtuA+M4Cqlge1IrjuQ?=
 =?us-ascii?Q?DaSOAqDlaaVnHLfcCBUXhwv6UUQPXZ8qhTolpRYQFy/tYQf8EfiwdV8k6/7b?=
 =?us-ascii?Q?iBgsepr9aso4ryJpbz2zyC6dej6GVglHEbGYCWRhRkiW+rh0Vna4CkCQJsUv?=
 =?us-ascii?Q?ELG+xE6Jehx3nBQC+5zVo6SBKza7dC7iP5/Dwip36dQUGHSHVNU2WvL6Jdzt?=
 =?us-ascii?Q?ZypaWVL4cf/pMp0+kJ7Kypv4ijO54OWyB7RhxJTNLUXMt0cJPXOnuYnzElPt?=
 =?us-ascii?Q?ZJEVlmKAaR61ltBCBprcH65ZEmR3dM4J4Ztnz+YYAe9hACSzZOIcGWE0HZjh?=
 =?us-ascii?Q?DPSr80YS+TRuevSOs+YxtmRrjGpMXQ0w9G7zQOcqExjkTy7hQFea5Gl/XFHz?=
 =?us-ascii?Q?mf+vQCjZFm94VxVq6Ixu27+/i5ZUwEApZPP4e67xOh6bNpvtpgO/p0NniN+5?=
 =?us-ascii?Q?QN8KEiX0uEMnrjq/y6RJmkW3jLEq3LIERPqMZtwgjNYcuSFbVvd8arT9AUbS?=
 =?us-ascii?Q?bL7DPTaxibGbJxxUQu/ZQu8P1zfkWWqyfEObLwqTELp2ERupo3CaCqf+Bmbs?=
 =?us-ascii?Q?6kbBJkoSEOh3Rs5alfv0GgveJG2t8QiWJmhcc8WqoUf8JVwy0VNNyClcORWN?=
 =?us-ascii?Q?K/C2hUxtsJcd6KV1vvj2Ai9gladHn2KnmkTTuNQGPbU+LDn4kMmN9CXZywET?=
 =?us-ascii?Q?B+fe2BRJ8j50kNZhpIYCVn2p?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b26ddc81-d6b8-4608-2cd2-08d936a060aa
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2021 23:41:09.2179
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sHZAZI+uwCB0Mge7/+TIamQEPh+UBqDtf5IGzb/aOessM9SgQHkUKvc8kNEoHRD3lnUTRM/1U3pcH2/RnyFdgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1696
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, June 24, 2021 12:41 AM
>=20
> On Wed, Jun 23, 2021 at 06:31:34PM +0200, Thomas Gleixner wrote:
>=20
> > So IMO creating a proper paravirt interface is the right approach.  It
> > avoids _all_ of the trouble and will be necessary anyway once you want
> > to support devices which store the message/pasid in system memory and
> > not in on-device memory.
>=20
> I think this is basically where we got to in the other earlier
> discussion with using IMS natively in VMs - it can't be done
> generically without a new paravirt interface.
>=20
> The guest needs a paravirt interface to program the IOMMU to route MSI
> vectors to the guest's vAPIC and then the guest itself can deliver an
> addr/data pair directly to the HW.
>=20
> In this mode qemu would not emulate MSI at all so will avoid all the
> problems you identified.

No emulation for PF/VF.

But emulation might be required for mdev for two reasons:

1)   the ims entries for mdevs are collapsed together;
2)   there are other fields in ims entry which cannot allow guest to
      control, e.g. PASID;

>=20
> How to build that and provide backwards compat is an open
> question. Instead that thread went into blocking IMS on VM situations..
>=20
> Jason
