Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1DAF415DD6
	for <lists+kvm@lfdr.de>; Thu, 23 Sep 2021 14:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240825AbhIWMHW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 08:07:22 -0400
Received: from mga07.intel.com ([134.134.136.100]:48575 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240678AbhIWMHK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Sep 2021 08:07:10 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10115"; a="287495324"
X-IronPort-AV: E=Sophos;i="5.85,316,1624345200"; 
   d="scan'208";a="287495324"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2021 05:05:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,316,1624345200"; 
   d="scan'208";a="474829936"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga007.jf.intel.com with ESMTP; 23 Sep 2021 05:05:36 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 23 Sep 2021 05:05:35 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Thu, 23 Sep 2021 05:05:35 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.105)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Thu, 23 Sep 2021 05:05:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NN+zVZA61Kdv6SlK1t4AH8yWg/kkJ3J660/0j2LIyDsrl6Zkb827LezkjkaC/s7cDW8cTJ4m86SN2nG9ujouLsjymPV+TJ5EykiWeURGRXfkVcKJXo9hOlPtzWEQeEiBXY/AQnq6pwY95BWEk7NkUtMm2zHNBN7LjYW8hYQWBdQErVFsyH1xduqU/74o0/UGnRKnyGfhvUnOHd0yhEuQgvRvnoD9FyslQLrx4nQaw9WCSYSUFut/JW/pZi1gGs5ywB9WLkqnxW3WfpXx1aHsFnJjwsLT4s3hMEEaoTbC5eP0SNjrEUITJydsjl357YrfApc/J4updw/cQpYfyDY7pQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=HDjZhx6SYnYjkuo1eijZLCssM9da8TJxUDb4l7JFoO4=;
 b=YIs7j7cQydfx/BOdIFSTPRsFSsRcjbL+NjKF2o4twROwP7WSPbVM0Eg9fHAfWFgDeswg6QO7cBOc19P+3mE2bfidPjn0KSBjnubHjuAhiLVU96mW/MnDhrIMQPFOGhyakcQvagfPyyC6wBalfPjS7USZ9lRQV4C2UY/ydb7iH3R3qOF+iD/5nGrwP5LEVGuWU0++U343INP+ebStLTlXteQDN+gCB8I/kOgpmNP86kcSo/0OhG3MyBW3s1v6ab2LklazDr4EtWAbWk9O53p3G9R8lLnC1cKRIEG3eTNTCoj6gRwDbMDeuE8PLT88ykEl/gVgNL/kkvqESd3KMJ5nAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HDjZhx6SYnYjkuo1eijZLCssM9da8TJxUDb4l7JFoO4=;
 b=aXNgJ5J4KsGz/5mmX6tpaLuMt7Y97erwfjfeeyY0NUUJyXXRS6qgl02pDxZ00n+j4LDMMS15YFetzM9dmCE98e/SfjNfDYk7hLgpKecfxUQxQlMPI0NuISIM5v7tCqK2Xw/2GA0h0ifEHlP9D+HQfSjgetL9JQ055W16j+4fIk0=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN7PR11MB2595.namprd11.prod.outlook.com (2603:10b6:406:b1::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.18; Thu, 23 Sep
 2021 12:05:29 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%8]) with mapi id 15.20.4544.015; Thu, 23 Sep 2021
 12:05:29 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "hch@lst.de" <hch@lst.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "lkml@metux.net" <lkml@metux.net>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "yi.l.liu@linux.intel.com" <yi.l.liu@linux.intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>
Subject: RE: [RFC 10/20] iommu/iommufd: Add IOMMU_DEVICE_GET_INFO
Thread-Topic: [RFC 10/20] iommu/iommufd: Add IOMMU_DEVICE_GET_INFO
Thread-Index: AQHXrSGNbNtRgavabUSKJjvt8l12BauwlhaAgAAouwCAACufAIAAgyUAgAAUFACAAAdkgA==
Date:   Thu, 23 Sep 2021 12:05:29 +0000
Message-ID: <BN9PR11MB5433BCFCF3B0CB657E9BFE898CA39@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-11-yi.l.liu@intel.com>
 <20210922152407.1bfa6ff7.alex.williamson@redhat.com>
 <20210922234954.GB964074@nvidia.com>
 <BN9PR11MB543333AD3C81312115686AAA8CA39@BN9PR11MB5433.namprd11.prod.outlook.com>
 <YUxTvCt1mYDntO8z@myrica> <20210923112716.GE964074@nvidia.com>
In-Reply-To: <20210923112716.GE964074@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5e57bd55-ef5f-4acf-a315-08d97e8a6fe9
x-ms-traffictypediagnostic: BN7PR11MB2595:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN7PR11MB2595B5C126C5D660F950F1B08CA39@BN7PR11MB2595.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2331;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: s5BgFWcYDKUfY9iEx+OjMkkiHp1QWs9v3+CjNWSCL4nbqMHOsgTj7msiVqBotmd2VBRroslRkl5pFUULW0OjWHM2CmvLNVjx18Ln4YXjJ1Q9SbjlFwDVLk5CgXjiUsc7eIbv0RwhkD/+OLgMPscqKwJ5aHcVcCglDl0GJMDamymbqISGjYYDYHJRMyrnJGrAEW0JXGu/0Tyc6bUWa7bzGszi9PLIqugqFIxjkYfb+aP87xo9y4EzQpGFfG22v6urh3wzbaoQBwMkHqs1G7xuu16SfGwmkP1m0sOQOm0ZapIBb2NfgoQVT60ZFrSJ8e4FJjrmkqoarxSBksZ1p4JpThFXPiBwqSZDKvt1cZzVQOoMZGym+ciOMmAk8izEfS/xx81TsG96oDklQjahjshrwfRvFU6s19CaaAbBS6Cv+KPrrzbVi8a8+mRiDMMoLr++QgL7KN58j9NgwoXeyPi9O14Xtl/yMXj+K2xpJSXhtE+3OmH//6sJa+K0H2jAVvJfNitGBLLjPIFXZ7GTYps3jRA8XG90roBv5WgNcSIvNG2B9ANjgM0LqenfaVPC0piQV50BswqbrksqfA/laUD1R2cfjuOxQHFPx4qP+/NVBvB8iMrPzQWzkOXYt0Zllq9lZp5b0qa64zfJDFPk551rjIwxxqWLfYW7iM9GzLgfiwCeuLPcfOqu+CWpCfRLuxZ6m6rOHFuHc7oTRw0MHSrLQA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7696005)(55016002)(9686003)(6506007)(122000001)(186003)(71200400001)(7416002)(26005)(2906002)(86362001)(54906003)(110136005)(316002)(33656002)(38070700005)(38100700002)(83380400001)(76116006)(66446008)(52536014)(8936002)(66556008)(66476007)(4326008)(66946007)(8676002)(508600001)(5660300002)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?DJcUO2xxmfYetE8r7jy81D3ZzgH7Fk9AU3gEX/ArMT5lADqYpjvkN+SeLvGg?=
 =?us-ascii?Q?sg64t+lphg5v/BKb2WDcpd0HvEKgFiCHTVRgoh6LapKb0WPGthGn3eK9UqzC?=
 =?us-ascii?Q?MDia8+t/n0LIKzZ9u3CCyYecwIblG6pgIcTqtqgkBlWcRBRYp8c4B05B1u9E?=
 =?us-ascii?Q?/8mLgPNW56jp+FAcbNjxJkVbmUMtl2UWmxpTLQB26cNOEjOsmsUmLZJhK2d3?=
 =?us-ascii?Q?x75nCEV/3/I14dnMnyd4mvoIaBTdG6G5iPgPUN0fdHN54RCJpw2Zo/7Enl3k?=
 =?us-ascii?Q?qAYduCt3B5YzMwo9wo8cqncvVtmqyF42XW8rc0/a1PxbADnRlgClitMiESN/?=
 =?us-ascii?Q?DuMpkJJi0b/7Xxd9Yyg0uNy9DFnl7CR6Y+nrtakObnbquwDQ3SySqGKr+KJA?=
 =?us-ascii?Q?8xTuqUH8vA1WaeJTVxEseg3MzT4jvw49APLSJ+OXcsmHs15TwZ1wJqtyuue5?=
 =?us-ascii?Q?6+LJU1r4LRtRfeCbsY9HNXNxQcxg2zA7mB8uW1Os58Edq88tFaw0omZFp+XU?=
 =?us-ascii?Q?yk7BOPvABqq2ZbCmI0x0IawRlXjOfV/RCqYjYo9j+/PrpOPk63VEZHz/di9e?=
 =?us-ascii?Q?5KvD8KjsuR3yMwyvyxU1uxV+L1evGZ6QvOCj1YjZBFJTKIEdsDMFkvrF2heu?=
 =?us-ascii?Q?AdF886szsGYAXRN9ihHP+jCHfd8am3G61FT6X+x0k05nvob5owzzojdp9fhP?=
 =?us-ascii?Q?ZAuODdGuPo9wEma/JjQ15ljK1QVitD7NhkkJC2TcYkCbYnsTvvonD62FUyJq?=
 =?us-ascii?Q?FSqUvXMM3anzmG/WmNI7NFh55DEgUfnVpzEyM+KiOBButrtHsBap/JSvGkO7?=
 =?us-ascii?Q?ug4pS8xbc+UOO0SaeMySUE0O7+DVU83V0pjcQcHAvb4CHlzMG2XgiAy1hJoE?=
 =?us-ascii?Q?9rWFkDOouVp52WjlWUOuGNiVpA6AGg3YcDurhbEk3F4gJaIGL3baEHKU5d8d?=
 =?us-ascii?Q?td5o69ArHsGKjeGHE+00gcPZuQqSnyJBgQaOVrOq0HDq9QXtAPwGwNpwBq2X?=
 =?us-ascii?Q?ODqjVWZFPozbPfSwcl5jHEDySqXaaVntWJegpnOkPL+JitZ65HU13U8Az24B?=
 =?us-ascii?Q?FWnyxH2oXRQcLQmBa5f9sbrzETsSa4SkEXqS0710YUFO67DlexvCEzNcpabk?=
 =?us-ascii?Q?rSCWOI4PLuosEvwoXAyx2bmdXGXFiBe7t+CnMcCaSBE5/RKlUBdxB3shQnV0?=
 =?us-ascii?Q?6Pjr/pnrzM0J/sxrAZg0WIBdYxIeikruhnfqN87OfTAinUX5bH5nF3/4aJBy?=
 =?us-ascii?Q?5s0aIVOBrlIAl5GfoM6XSBDQ6ZxMQvaJeNsdim5XyqzI5CRKF0xkxK7mxRNG?=
 =?us-ascii?Q?pFtyAcnOisMno+84Cg/QTu/f?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e57bd55-ef5f-4acf-a315-08d97e8a6fe9
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2021 12:05:29.6212
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ewJC8j3gCaD6GlJPggzbbCk+p4pxK0/j+1GdWqKAtpJTbR+0w97HDNuyyBGaWKHhiN0IvOarW6ops+ncPsfUuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR11MB2595
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, September 23, 2021 7:27 PM
>=20
> On Thu, Sep 23, 2021 at 11:15:24AM +0100, Jean-Philippe Brucker wrote:
>=20
> > So we can only tell userspace "No_snoop is not supported" (provided we
> > even want to allow them to enable No_snoop). Users in control of stage-=
1
> > tables can create non-cacheable mappings through MAIR attributes.
>=20
> My point is that ARM is using IOMMU_CACHE to control the overall
> cachability of the DMA
>=20
> ie not specifying IOMMU_CACHE requires using the arch specific DMA
> cache flushers.
>=20
> Intel never uses arch specifc DMA cache flushers, and instead is
> abusing IOMMU_CACHE to mean IOMMU_BLOCK_NO_SNOOP on DMA that
> is always
> cachable.

it uses IOMMU_CACHE to force all DMAs to snoop, including those which
has non_snoop flag and wouldn't snoop cache if iommu is disabled. Nothing
is blocked.

but why do you call it abuse? IOMMU_CACHE was first introduced for
Intel platform:

commit 9cf0669746be19a4906a6c48920060bcf54c708b
Author: Sheng Yang <sheng@linux.intel.com>
Date:   Wed Mar 18 15:33:07 2009 +0800

    intel-iommu: VT-d page table to support snooping control bit

    The user can request to enable snooping control through VT-d page table=
.

    Signed-off-by: Sheng Yang <sheng@linux.intel.com>
    Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>

>=20
> These are different things and need different bits. Since the ARM path
> has a lot more code supporting it, I'd suggest Intel should change
> their code to use IOMMU_BLOCK_NO_SNOOP and abandon IOMMU_CACHE.

I didn't fully get this point. The end result is same, i.e. making the DMA
cache-coherent when IOMMU_CACHE is set. Or if you help define the
behavior of IOMMU_CACHE, what will you define now?

>=20
> Which clarifies what to do here as uAPI - these things need to have
> different bits and Intel's should still have NO SNOOP in the
> name. What the no-snoop bit is called on other busses can be clarified
> in comments if that case ever arises.
>=20
> Jason
