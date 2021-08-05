Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20CDB3E1EFF
	for <lists+kvm@lfdr.de>; Fri,  6 Aug 2021 00:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232925AbhHEWoj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Aug 2021 18:44:39 -0400
Received: from mga05.intel.com ([192.55.52.43]:55888 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240914AbhHEWoi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Aug 2021 18:44:38 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10067"; a="299856829"
X-IronPort-AV: E=Sophos;i="5.84,296,1620716400"; 
   d="scan'208";a="299856829"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2021 15:44:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,296,1620716400"; 
   d="scan'208";a="569568038"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga004.jf.intel.com with ESMTP; 05 Aug 2021 15:44:22 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Thu, 5 Aug 2021 15:44:22 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Thu, 5 Aug 2021 15:44:21 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Thu, 5 Aug 2021 15:44:21 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.177)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Thu, 5 Aug 2021 15:44:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UgdjY5LP6wqcNd8rvhYXIOUc2wQD3XR8p4Qp9gmvGqg1CgN5dUB5DumdwlOTwSX5t7O+oe24Yv/rDkeR11kwaEP9WkwHneUGshBga+ZwTjNpx8dw2wG1ZADLycTUNIUWhTmXnox5HeOqMwFsAiFZ0Ct6QZR/HL+q8aXlPvcXKPTkN8mBDAyCrdLIsWsu+f5SoM85NJbEKqdT/TNn6/d2ocQ3PHAXDDnnMAOv1OWvnKIsl6VIcwixOnIcxIU7hjbGXGKqBm8TdBVXwfm+nxc0Wo4o8HAdBVANjOmkpGM1Nf5LSunj/SUXrAtakTOKcPaOoUu1wAPK6uikd+84Gn1bQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZYASHP94jfWBRq9XaMrF2YvSaEy7r0bebW4znO5RHag=;
 b=OGFA6BuPWdRrTEZ4i84XEq5U6d1RVwRWX42Y9j7JeX1kL6hh979UFqzP4xvE7FAY2XvlJBw2UMQCjr/4WhZ0Mu7qJfPHjg7HmrlHldNn3jHx7pygOR8JEzXnxMsl5W+AXEJG81ypgzNbrSY7W6KLzj71ZaiXrT6hsBJANtxg2I5EVZScevEdRIdl1mkYQ0tA+YDDkFf9t2/arfNZjwbJhoUh0Q1+G4bsdm6faw2Ya03mxdFNFiaTf0mojuW0LJYP9+ceyv/gTgG4k8yCaYfDbaiNb+R1/3IYP2qWDTRXB+ZDmbt4jtp9jADG3wxzjLjEhjJP4Oa2YdDeKcTlUNtAew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZYASHP94jfWBRq9XaMrF2YvSaEy7r0bebW4znO5RHag=;
 b=P9zIo4lrAMlGxmHjgPYnMRijh+PtcjV//j3o6NVjiqE14YL1qI709w8jle2KgvWXNgX1kgeuES6iJql23qwlXeMp/d8Qn2cGRJQ/OolHLWzoFxAEHQK7o2alGIXs9TLj0wRhk97b9jP36depeLwdX1HijHfQHSIaZhGDX6QsqT0=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN6PR11MB1762.namprd11.prod.outlook.com (2603:10b6:404:100::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21; Thu, 5 Aug
 2021 22:44:19 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::fd4b:cdde:6790:134]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::fd4b:cdde:6790:134%8]) with mapi id 15.20.4373.026; Thu, 5 Aug 2021
 22:44:19 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     David Gibson <david@gibson.dropbear.id.au>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>,
        "Jean-Philippe Brucker" <jean-philippe@linaro.org>,
        Jason Wang <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shenming Lu <lushenming@huawei.com>,
        Joerg Roedel <joro@8bytes.org>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Robin Murphy" <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "David Woodhouse" <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lu Baolu" <baolu.lu@linux.intel.com>
Subject: RE: [RFC v2] /dev/iommu uAPI proposal
Thread-Topic: [RFC v2] /dev/iommu uAPI proposal
Thread-Index: Add0lrMH87IsTsl5Rp6WN1oQU6kGMQNQxoYAAN4kDIAAfDtbgAB9mQaAABKIGhAAGkG/gAAXZR2A
Date:   Thu, 5 Aug 2021 22:44:19 +0000
Message-ID: <BN9PR11MB543328F0734D5FBE7D627FA38CF29@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <BN9PR11MB5433B1E4AE5B0480369F97178C189@BN9PR11MB5433.namprd11.prod.outlook.com>
 <YP4/KJoYfbaf5U94@yekko> <20210730145123.GW1721383@nvidia.com>
 <BN9PR11MB5433C34222B3E727B3D0E5638CEF9@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210804140447.GH1721383@nvidia.com>
 <BN9PR11MB54330D97D0935F1C1E0E346C8CF19@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210805112713.GN1721383@nvidia.com>
In-Reply-To: <20210805112713.GN1721383@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b40bef67-1a30-45de-8194-08d958629000
x-ms-traffictypediagnostic: BN6PR11MB1762:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR11MB17625BDFE29CAED756C277458CF29@BN6PR11MB1762.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AAKAKdOgb6ZYd+9qNh1iiy8EkU08hakpIvBTm47rUvcXdvnRRtaq7jL97IrjfRDmIdcZayRf8n4FUof4HgWSvlqXpREjsnMLtmF2XWyvVXOCa7KGzq3t72dq3zOT4yL8t3vO9VtCKlEeyGQqyDn7a7KSS1xNAqIru75rid9vKmn62WLsUAJLFWrvLNXLJ3yavExdMaZGsQFJN9QLM9tbn3PTxSiURxJvsY/VPWtlCmD/ItE++6V+qKw8k+Yup1Ok7wNlsdvuSMt4pIHsaHbcUdBQLocV6v5KRCnaE+bIMl/MApbVUUbS/hlCBdpj8IZ22xnQ7Yhq2dVRm+JpNjEpegfLO/v7X9CQ7UmcdGgMUct+U8u1k4VKtudt2y1CL7ew2iRAsTV0muAlZhdWQio1glxTYRgcJ97QnamfpqCtjR0XDSWvD7CEmzI4ajEIVn1UjywPu8oCuMT0cEqFZB51wLCFN0GepMKP9Fy33Rcn0lg/W/KmXEZ8tUFjCa+ST92v8YgymlwADjXGkHDM/qlJZhrfQrOmZVw2Iw1tEUF3CsSf4M1vlo2W2if5tKsDfUYrIHYJgqoOzj5m1N8hk6AWRsTKHnG0AB47KSVA4m8Wgp840t7iHgsMALk1vuZuGzHPmB/ap/hwgxvRX3v2d4mCSfeZ1dKhVn/YgINjSIyA4qJ7Joip2rBg2McVWFrdhWlBzqvTzqIMwn26EusdZgQtSw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(396003)(136003)(366004)(346002)(6916009)(66476007)(26005)(6506007)(76116006)(38100700002)(54906003)(66556008)(7696005)(122000001)(66446008)(8676002)(66946007)(8936002)(38070700005)(5660300002)(64756008)(55016002)(9686003)(71200400001)(2906002)(316002)(478600001)(52536014)(186003)(33656002)(86362001)(4326008)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?h2Klkd0ETWl5mzBWB7Pmef7rJTSB7MCILLnwlsR+6kQSxfcZZOkTNAlsH5QP?=
 =?us-ascii?Q?3OK5Op0XSwEdGdkCxCRHyh+pina3NNSmovvHH/mhrwz/xLpaTIHun3mE3Tkh?=
 =?us-ascii?Q?Vo1Lwm9kV0wrIST/75Z9WzluRHArHDzHRoY0lxUmKtLFB0XqbaccJ0k8vFg4?=
 =?us-ascii?Q?ksnDQQ/ioq8w5hzMXq2I7RA9mbCZiORSav4Q7Q1ISJ+PjHamNFGSCwN2NVK6?=
 =?us-ascii?Q?CBU3EuyNcIWNYyreMOBNb6qkb4sQm4xHYfdoBcp30KSnwzWgz70/n2V71xwr?=
 =?us-ascii?Q?fKKq4kHjph2hmbU0QvSi7aEGeQIFf03bhWjgJOOJVKtQgj4AVb59tDVwMFMT?=
 =?us-ascii?Q?LynFQjQpCdrTHKnHTGWYF+eh+HmNcGEXRdQ7AugwMdUNvyJaKuvgVepQtRdt?=
 =?us-ascii?Q?McA6QEh7GOBfx4ECgtS5Nwq02zdunYc08VJEBBT+HvLJg58OekVEUPynN1MT?=
 =?us-ascii?Q?lI4cbvRpjYt2qXgjk51yWppzQAQ2W3QL8lER5vxD52RL8a5WZ+o+YieQlmRu?=
 =?us-ascii?Q?dfJhDtERq+Gcp0PoTYAnKrdmx7BCCFpEnP3oSCLaKUpB1yw4aGdcWRBwoEQJ?=
 =?us-ascii?Q?7c7wla0xGELugl2n7bQ8uLi8pWLbJ8alhYZfLTkTz0oHTb74RWOnRLrBPykW?=
 =?us-ascii?Q?PMmNY6XpxnEm8K6G2fAZM/2QwuRpaxyneU0FjL13HyxxUlkp9ZFwGYI8Tx6l?=
 =?us-ascii?Q?2cmrpaZyWgeeFfB5slGF8rPq9Cf2taYdCsToZUhT2u5t4T879COFJU1BS5Hx?=
 =?us-ascii?Q?P5kOFi2XkEtUVRzJiiTeGyGL7MIk25Jhbiex6Z8elJFSI3gK5K85kGd7YmVH?=
 =?us-ascii?Q?IzO/4GAxhuOYhLvxfDDHdCEQ1Csz5kR0n6oa8tcWP3+/Zg6rdf1jZPmh10y6?=
 =?us-ascii?Q?YABcR5VNj0QCWEXGvUd3nzLN7x39v/Gq/T/5i/kvSKiQMTKTJGquAqusmtzD?=
 =?us-ascii?Q?rCb0rTW7Jp/3sY4p2skAaW+5ppgTYdrEPXW/rEn0W+vulTD2QnvlPES1He2A?=
 =?us-ascii?Q?VfWTAMkwtC9bzbj/XCCOaIYZfWwXeezagsJ5NTDWt8GZZHv2FuMIi7fCXDgd?=
 =?us-ascii?Q?vCYcvqTm0zuA4dbKnoZiKYa3e0YUimpfkKrZjH0KahFB8nrjNCCF89lAdkhq?=
 =?us-ascii?Q?LR/5wkC0xZgoPCVWygUEEyJa36L9PxqMMDXmHsZRXTvzwuFEMsKEXmQTyKZn?=
 =?us-ascii?Q?qdFTVP8767tioBVa5bXelXpXkQLBdUydhlP+1x0aVozM6xgse70KX/UqhC45?=
 =?us-ascii?Q?ade8Tqu+M0am5O0LzJVtVsn57OZayT1S15g8N3mVeeVvmgNARFAilKAxa+fj?=
 =?us-ascii?Q?LdLt9knKAsC5AEBB8XA6JVYM?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b40bef67-1a30-45de-8194-08d958629000
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2021 22:44:19.3676
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rIGThFV5UB0+wHLuWLGXOTOoP0VnnkY1ObizsHWnuMwp6dE66h0suEIC4El3WP2iYVGCm0jydVxYDGgB9mYPBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1762
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, August 5, 2021 7:27 PM
>=20
> On Wed, Aug 04, 2021 at 10:59:21PM +0000, Tian, Kevin wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Wednesday, August 4, 2021 10:05 PM
> > >
> > > On Mon, Aug 02, 2021 at 02:49:44AM +0000, Tian, Kevin wrote:
> > >
> > > > Can you elaborate? IMO the user only cares about the label (device
> cookie
> > > > plus optional vPASID) which is generated by itself when doing the
> attaching
> > > > call, and expects this virtual label being used in various spots
> (invalidation,
> > > > page fault, etc.). How the system labels the traffic (the physical =
RID or
> RID+
> > > > PASID) should be completely invisible to userspace.
> > >
> > > I don't think that is true if the vIOMMU driver is also emulating
> > > PASID. Presumably the same is true for other PASID-like schemes.
> > >
> >
> > I'm getting even more confused with this comment. Isn't it the
> > consensus from day one that physical PASID should not be exposed
> > to userspace as doing so breaks live migration?
>=20
> Uh, no?
>=20
> > with PASID emulation vIOMMU only cares about vPASID instead of
> > pPASID, and the uAPI only requires user to register vPASID instead
> > of reporting pPASID back to userspace...
>=20
> vPASID is only a feature of one device in existance, so we can't make
> vPASID mandatory.
>=20

sure. my point is just that if vPASID is being emulated there is no need
of exposing pPASID to user space. Can you give a concrete example
where pPASID must be exposed and how the user wants to use this
information?=20

Thanks
Kevin

