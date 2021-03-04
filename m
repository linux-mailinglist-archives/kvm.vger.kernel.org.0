Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB2E32CD7D
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 08:22:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236182AbhCDHVf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 02:21:35 -0500
Received: from mga09.intel.com ([134.134.136.24]:51260 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236199AbhCDHVH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Mar 2021 02:21:07 -0500
IronPort-SDR: s7wXX5FycnolHxTxfkW36cGPpPM6LLFpJfoAoZJMoC2wjCwHsqtwkREfoRpEiD86s71XTZBXhW
 a+bIDyoJoHnw==
X-IronPort-AV: E=McAfee;i="6000,8403,9912"; a="187471623"
X-IronPort-AV: E=Sophos;i="5.81,222,1610438400"; 
   d="scan'208";a="187471623"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2021 23:20:27 -0800
IronPort-SDR: oww1WiYP4qwvVkq51tniETF3SCAvC5NfLvnXNISC2HgfhgpSgMGG6IlS8btQi39Sdl+9BKV45D
 wrgvNrcKbU1A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,222,1610438400"; 
   d="scan'208";a="369654221"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga006.jf.intel.com with ESMTP; 03 Mar 2021 23:20:27 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 3 Mar 2021 23:20:26 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 3 Mar 2021 23:20:26 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Wed, 3 Mar 2021 23:20:26 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Wed, 3 Mar 2021 23:20:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GdxErzO867sg/GVCPCamURwcmdL/CkTkvVOgd0iwlvCiDpP9QDcuJjO74xE3+XAQ/TH59+O0eeM0kGTaS5fMQ2+o05exGi/wyGnf2KhJJ9921QCH+CMR61mF+f0ln1SnpyD/vwtc9B+g9IpTl+N34D9dcCNOmrp7ZhYUHCsxpzpcrTdDSz0HwHFRP/37nmEOaxme2WGNx/f4Tmbdg2nWDsisgPzXmzMLYH8xU8j6MJ7GwIjgOLMax+REkR9qzrfN6Glpr2WeqwnyjT7Pwi6H0NQ9hlaVeD53bGsad2mYCJhTCkpDNFzyLw0atrTYafHESGWHWGJ4WbHnIZNJMry54w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ibnv5LHIF3NZNlviCpcvTt5TC1S0fR9q1oZPmP8aICQ=;
 b=SgXdR6aRv3UHAN/6o1rLem6oH2xk049aj66NPJdVbcIaKg+UzwZaxuMDHnrd/LfxDjaG8OY8aACixujgattH6eFpTbUNfnSEIyk31SiaT+szonfLUWv8TS67Xv91mCvxrOPKjoyP43XvTlIQ7DE7FlNg5srYdNkPSOPzMp/khj5N2RXHkK9HiFVnKSZO+lzXlh5vUxgi6gfSkyATaWWw3bpdAx1qm60IGp4gQ9dYehHWGRwm7/Rq/+7hYPUO187Jmyg/QgaIvjJxPWxtnQ8PxKBOE0h9a6Jphz2vu8WWORFZnN95ydXg5FLSfXu+lAYSJ2/Cst4kjQBa1HIypFFuqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ibnv5LHIF3NZNlviCpcvTt5TC1S0fR9q1oZPmP8aICQ=;
 b=ADj7Kv5cgJYHlRlIkNDB9aaY2zhccV6To/neOB1/PEhWJx5nhNkuK2WeXx9WoSFUCVpAT4NKgisydWyUz3QBEmi+lU4T1qh5Cnor3E5zAGV/Xv+fJg5ikDF94wrxDqEQFatEW8kVq1o4/8q4F0eM5fld41yevCoVIXRS+ZS5kiM=
Received: from BN6PR11MB4068.namprd11.prod.outlook.com (2603:10b6:405:7c::31)
 by BN6PR11MB1793.namprd11.prod.outlook.com (2603:10b6:404:102::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Thu, 4 Mar
 2021 07:20:24 +0000
Received: from BN6PR11MB4068.namprd11.prod.outlook.com
 ([fe80::5404:7a7d:4c2a:1c1d]) by BN6PR11MB4068.namprd11.prod.outlook.com
 ([fe80::5404:7a7d:4c2a:1c1d%3]) with mapi id 15.20.3912.021; Thu, 4 Mar 2021
 07:20:23 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "Wu, Hao" <hao.wu@intel.com>,
        "stefanha@gmail.com" <stefanha@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        "vivek.gautam@arm.com" <vivek.gautam@arm.com>
Subject: RE: [Patch v8 04/10] vfio/type1: Support binding guest page tables to
 PASID
Thread-Topic: [Patch v8 04/10] vfio/type1: Support binding guest page tables
 to PASID
Thread-Index: AQHXD2DTqHwsu8SEs0ulXYEOOzE5O6pwqCkAgABHw4CAAAC2gIABuzgAgAAA5ICAALYpYA==
Date:   Thu, 4 Mar 2021 07:20:22 +0000
Message-ID: <BN6PR11MB4068D05B70842124234A7AF4C3979@BN6PR11MB4068.namprd11.prod.outlook.com>
References: <20210302203545.436623-1-yi.l.liu@intel.com>
 <20210302203545.436623-5-yi.l.liu@intel.com>
 <20210302125628.GI4247@nvidia.com> <20210302091319.1446a47b@jacob-builder>
 <20210302171551.GK4247@nvidia.com> <20210303114212.1cd86579@jacob-builder>
 <20210303194523.GX4247@nvidia.com>
In-Reply-To: <20210303194523.GX4247@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.221]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9f1a62ad-089f-464c-1d7e-08d8deddfa07
x-ms-traffictypediagnostic: BN6PR11MB1793:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR11MB17931CF0CAEC836BE1BBA3D8C3979@BN6PR11MB1793.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fVP9S8VszTY+vDthyo+I6/ua5IQvmfaL70Iz/hocMDMGdlqFrgIjxhUH/5Fr4AegMSgV5at8Sz3jVGwuTr1E10LRYqBmuloTJJR+AqgqtlGre5vVjzrbWK0pqFH27ArFrhwZcKV8gOwC4OC/mA7A5ppfV5Q0UkLdQp5WKw4Zl4WQDAi6TqvOnXAUDVFySadOAQrV7Dpi/t9sqSy2nfPmKBjUiVcW0ntNdh9tWILmFsl8Aay2fDo2dwUWEX1wrMiPRNqv4XAMb7J04fU8RzDPPPElmmcSOexU7MfiUDWIzL2Aejr2AE5UfYpPcb6UHS0Stij7ZFZ4AH6ZXf8gzV97T20sCegcf1QBGaboKaVcDfXU3n0yXbUCboTn9ded/021mfMENbGvMMWgzsK9SrfTRIDI2l+CVx0wH8n5CBGuFwwPFGfa7YlIHOhqVliMbcp0WtSvidKT7PYtWiyEWjsm70tNopAEM3h35O1ZpT8bU1sTZELjlLaKgPRpTKIvhPEcvMXJTYBJnzO5yiowAWN4pw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB4068.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(366004)(346002)(136003)(396003)(26005)(9686003)(54906003)(33656002)(2906002)(8676002)(316002)(110136005)(478600001)(71200400001)(7416002)(66556008)(76116006)(186003)(64756008)(5660300002)(66946007)(66476007)(7696005)(86362001)(8936002)(55016002)(52536014)(6506007)(66446008)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?SVIQvrlk9TNHkrtxCO1XL/kzqGwOq1mt0MqyzrFD0A/JD/fCi+ibrMyhRF6X?=
 =?us-ascii?Q?TKsqZ8qQRl6cMzbQFJdiIW3iBNx9pKC7YDKZjXhMA0BPawn9aTuW0IpIWuBr?=
 =?us-ascii?Q?LhSkHtYMpvCJ4FuwTfQg9UIbeCZcBbCCD1Jnm8LESrju6nB8qKoZITCE4vvX?=
 =?us-ascii?Q?1lXUEbaHf9VBvgbPP0YRmlJpH+VYBIVKFTwHqsOEOmGEK+AxBLjAyRMnJi6C?=
 =?us-ascii?Q?T+JTHbsWOHaiKdTXKuePW9SDEEJVsu7w/h7n06r1W5omLalKRZi+xez4Y4Yp?=
 =?us-ascii?Q?kPqVqkJVzuep22ELFF4L9r9bdf9pRhm4nilp1b+eWX7ww0ZoeyDJG5L4FcTN?=
 =?us-ascii?Q?GPFlEvUzC3J8PSGTI+NzPHvfFLz01dNgeUPtLYXe6wCi9X/Hc1YHHqcvDtSB?=
 =?us-ascii?Q?eb5PeCSyvuMPPo32vRgdzohSQW+06GJMWbAPVlOjC1K8N3C/1IjFPlAJ0iM/?=
 =?us-ascii?Q?g8rEewFtQLtLJwiY9Jy0wM3Y3d652NYGEt1MIntXNQlMku5EwU5F05BH3C5x?=
 =?us-ascii?Q?fS2Wj5BwTdq5Bxr/5p4dL2ezTJSIg+24QiWUXMLrvvwD26sDefaAqqFtQWWR?=
 =?us-ascii?Q?wwEm/hT8TYRV8IYabwLZsdSbCR/2KB2PzeQYGMXRjYMeoU1WD2KieihBtdwz?=
 =?us-ascii?Q?OFS8RJ6SZXG4844/sZXnpBdisirB/cLkI8C89U3XVg7QviwPL0BhmT+jumby?=
 =?us-ascii?Q?25ADjnY44ne3nVrQtUv4RuszmakQoOgyWpGz2d/2MD7cuEOs8hAYdzYuCJL0?=
 =?us-ascii?Q?dm6h9cy56a7S5mN/vsWU2COv4FuYdziExzal4083TrG959HuI+unkLFksCqQ?=
 =?us-ascii?Q?3o2pgQQqGJDJVYSLU4fCqZi7caHbZHSi9ccsqtj+NOhYOHHUtRCKCWYL9DFq?=
 =?us-ascii?Q?td3IEuSj6pDbPQqIoJ7NVObSULLOVcwcsgSrKRlKg2ogWiiNHqFqTE3I+G+O?=
 =?us-ascii?Q?E9akGNhbPwV4VQ+Q9TF7ZZZVr564VozRmmj6kuSCA/hEJxwwV+sZIj4lr0E5?=
 =?us-ascii?Q?USSBiGMyRuPEmd06VX/dev9EnyJUeQsYyx9j702F12kBHAQbANWHw+2ayQbR?=
 =?us-ascii?Q?dxaUgGPivkVEp3/ictVCly0CT/8szGBheEGhgUlClFhZ4l4ekgyrAZI2O2Ik?=
 =?us-ascii?Q?cmA72fbb3nqF8hYDx4mxa4NYIyIGPtyygS8pst2r1YQR8PWsl9/YoZLtzzCr?=
 =?us-ascii?Q?Pff0DK/VEe/2Bi86jJVIEN9e0ssmIuXYNqIhA/sEqpNRNDw6f/Y+OQVLZFOs?=
 =?us-ascii?Q?VlYSGSVI/eSGGtbtrzTs0K9/ot9JloF3s7bBh/4wZ/fG4+Hn8D/9/raGMj3E?=
 =?us-ascii?Q?mDfm1Fv1sBB/i/9xxV3qR64x?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB4068.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f1a62ad-089f-464c-1d7e-08d8deddfa07
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2021 07:20:23.0238
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H+XbNzZXwETTL0IrELMk/voetBJoTeVo3Y+3ITJmtBK2BtiMr6xw6/EYErTE7qu9nGVp3aeiGSveAQHwKiKN4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1793
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason,

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, March 4, 2021 3:45 AM
>=20
> On Wed, Mar 03, 2021 at 11:42:12AM -0800, Jacob Pan wrote:
> > Hi Jason,
> >
> > On Tue, 2 Mar 2021 13:15:51 -0400, Jason Gunthorpe <jgg@nvidia.com>
> wrote:
> >
> > > On Tue, Mar 02, 2021 at 09:13:19AM -0800, Jacob Pan wrote:
> > > > Hi Jason,
> > > >
> > > > On Tue, 2 Mar 2021 08:56:28 -0400, Jason Gunthorpe <jgg@nvidia.com>
> > > > wrote:
> > > > > On Wed, Mar 03, 2021 at 04:35:39AM +0800, Liu Yi L wrote:
> > > > > >
> > > > > > +static int vfio_dev_bind_gpasid_fn(struct device *dev, void *d=
ata)
> > > > > > +{
> > > > > > +	struct domain_capsule *dc =3D (struct domain_capsule *)data;
> > > > > > +	unsigned long arg =3D *(unsigned long *)dc->data;
> > > > > > +
> > > > > > +	return iommu_uapi_sva_bind_gpasid(dc->domain, dev,
> > > > > > +					  (void __user *)arg);
> > > > >
> > > > > This arg buisness is really tortured. The type should be set at t=
he
> > > > > ioctl, not constantly passed down as unsigned long or worse void =
*.
> > > > >
> > > > > And why is this passing a __user pointer deep into an iommu_* API=
??
> > > > >
> > > > The idea was that IOMMU UAPI (not API) is independent of VFIO or
> other
> > > > user driver frameworks. The design is documented here:
> > > > Documentation/userspace-api/iommu.rst
> > > > IOMMU UAPI handles the type and sanitation of user provided data.
> > >
> > > Why? If it is uapi it has defined types and those types should be
> > > completely clear from the C code, not obfuscated.
> > >
> > From the user's p.o.v., it is plain c code nothing obfuscated. As for
> > kernel handling of the data types, it has to be answered by the bigger
> > question of how we deal with sharing IOMMU among multiple
> subsystems with
> > UAPIs.
>=20
> As I said, don't obfuscate types like this in the kernel. It is not
> good style.
>=20
> > However, IOMMU is a system device which has little value to be exposed
> to
> > the userspace. Not to mention the device-IOMMU affinity/topology. VFIO
> > nicely abstracts IOMMU from the userspace, why do we want to reverse
> that?
>=20
> The other patch was talking about a /dev/ioasid - why can't this stuff
> be run over that?

The stuff in this patch are actually iommu domain operations, which are
finally supported by iommu domain ops. While /dev/ioasid in another patch
is created for IOASID allocation/free to fit the PASID allocation requireme=
nt
from both vSVA and vDPA. It has no idea about iommu domain and neither the
device information. Without such info, /dev/ioasid is unable to run this
stuff.

Thanks,
Yi Liu
