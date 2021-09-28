Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAE1041A970
	for <lists+kvm@lfdr.de>; Tue, 28 Sep 2021 09:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239066AbhI1HPM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 03:15:12 -0400
Received: from mga17.intel.com ([192.55.52.151]:47056 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239057AbhI1HPF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Sep 2021 03:15:05 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10120"; a="204786806"
X-IronPort-AV: E=Sophos;i="5.85,328,1624345200"; 
   d="scan'208";a="204786806"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2021 00:13:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,328,1624345200"; 
   d="scan'208";a="518891467"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP; 28 Sep 2021 00:13:21 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 28 Sep 2021 00:13:03 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 28 Sep 2021 00:13:03 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Tue, 28 Sep 2021 00:13:03 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.102)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Tue, 28 Sep 2021 00:13:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QwGay+f38QXZ32Iac/S8YPdi8id/8ZaB/2lJg/RLwfUntQ9cy6okjEb4tnFNM0goLB3vu6NrX/5rNSBP8Y4ykO3F/Ki0xVrFAvOveXH8Q5zhJilWizpNAE/epOC8S8bNBf/z+7TtLPgkX2KtOag64AKHS/7mkRIDbIWOQQKsr95MPhPg0iupB00553eToPGjD3oU7rgHckmQ1S6hQyAZM3xyBEi+aK/+r1W5TrbpqYjDwnkU/nJTXGNkHAzCHDAw9J7ZLFu9/j86qezWdhJrQzG2fnZUtPamiKo8v+6qZZavjuX8vsuLs+Co0beqwZRurI7v3WdB9z6LcsIEf3EVRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=bK0N+1kmFnqFIItex4H0o9WyJyuVlWo/N0ektGTiZkQ=;
 b=bJMpprg+UQ7VM1NFKQkFJ4pk2azzvX34CSt/L7X+KkurN7et11Rn5ta1eyFm1FhxcH3308V9g5G1XDmZFSciz8Azk3iLMXjwsKSPMTO3eI+pkiFfyWqGhjVucio0h9xxi6QgYzlMqqUXojAYtIC4pvbdJC3HCEcD+/fQcL54erv5sJ4U8Kayn0yzRbKc+knrd20/JSFe9Bk8+HPlvstCYsx2LVEruH4SySagfu3TpvwDsuMr5E2au3+h3y8EExjhiDPDNJQNC1DOA81l+JeJHkfME3oKTcEVGMp6jBM14fPHCQfUG977u3oDScjcbquJn+LAPJZlJzhuV1juZ6mS+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bK0N+1kmFnqFIItex4H0o9WyJyuVlWo/N0ektGTiZkQ=;
 b=OC88U1rVCJ+X5p5q4BZhqoIs+BVKuuhsiz8Xdt42sq4zCiUajNM9SbWipU/9e1Yp8tTbog50GxwStNm8NpSdA7wa3Q66nAMnJqzKuQkYDCS6zZ6N5aXzuHzItr9hHyYHr9CHFsXGdg2OR4UfG6EY1hRCADLz6mmUvKnGrFXWQhI=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN6PR11MB1716.namprd11.prod.outlook.com (2603:10b6:404:4a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Tue, 28 Sep
 2021 07:13:01 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%8]) with mapi id 15.20.4544.021; Tue, 28 Sep 2021
 07:13:01 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "hch@lst.de" <hch@lst.de>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "lkml@metux.net" <lkml@metux.net>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Subject: RE: [RFC 06/20] iommu: Add iommu_device_init[exit]_user_dma
 interfaces
Thread-Topic: [RFC 06/20] iommu: Add iommu_device_init[exit]_user_dma
 interfaces
Thread-Index: AQHXrSF9WDj+Z+DU+UqMJ7tQK2EdmauuvK2AgACKnbCAALw6gIAHYVYAgABthQCAABACQIAABTKAgAAAdqCAABi9gIABEGXA
Date:   Tue, 28 Sep 2021 07:13:01 +0000
Message-ID: <BN9PR11MB5433CE9B63FD6E784F0196B68CA89@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-7-yi.l.liu@intel.com>
 <20210921170943.GS327412@nvidia.com>
 <BN9PR11MB5433DA330D4583387B59AA7F8CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210922123931.GI327412@nvidia.com>
 <BN9PR11MB5433CE19425E85E7F52093278CA79@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210927115342.GW964074@nvidia.com>
 <BN9PR11MB5433502FEF11940984774F278CA79@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210927130935.GZ964074@nvidia.com>
 <BN9PR11MB543327D25DCE242919F7909A8CA79@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210927143947.GA964074@nvidia.com>
In-Reply-To: <20210927143947.GA964074@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b14c0bad-034d-4071-14d4-08d9824f688c
x-ms-traffictypediagnostic: BN6PR11MB1716:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR11MB1716F3E13D78E1359FFBD2198CA89@BN6PR11MB1716.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZdM+TW/VKF6glyPoVw7xizR9U8sCFfpKoQb4isdY/vnY2/NQP7+FoBK+iI6b6snJc8QQjmdppPJtabw4gshulhIpZNmNJ4oK/J1U2/1Zky3QDQIOl0XwSLSGTSAkWTOq0H73j9QZcWEiPTYhVwp7i/KGzhzhwLthpJtOXFQTdt7equ2VZCj55JQDdIl5Kk9bDrxdZD7fzVcirZfVGnzo1gCRV5W6QOjzx2PsabLlnqBT0bGPzGoBlts2e4/boTASJaWDj24SJQz32HukNIRgWdsl2ZzXolNN2jAxUEORP+U0QHkHaR0/EBKgHpKQAzR+vAwAQsst4Nvt91BDkqerBImhT/C5CwyKtJJ5Hi/mPdkA74iB5l9+j5/CVHFSMkGLDkeF3I6BSZj1BvRUQ4ScqMydeyO8nfRF2EFr0Ul1dbThC+W+9LTqp40F9ON0OzU5/ZSoxwZM34eA4iQW2AgxWM/CBffrebLODgNyOIZ/eJ7XK2WGvkugyXb8fWW4OUm7ukauslowdi7A0LmzeVx7y7ExJoHxpEVjbVgFQt9mzjS6R/r7fMDid+UMKn8p3Av7XawhwbIBowkGXcBX7gmj/qbVtGNOkugLXy+ZZ32eeSXnqJkQOXy1LGGbBfwnb+kzaiOtTHz59y2ga9qWs/2/0Ub1LTxJrCKcCnl0EN/46SbchWf7nD0jSzAhrzhcS+JPYxAKHAQdmLzLrwpwWfhigQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66446008)(66476007)(66556008)(64756008)(7416002)(38100700002)(2906002)(5660300002)(7696005)(6916009)(122000001)(52536014)(508600001)(38070700005)(55016002)(26005)(33656002)(9686003)(66946007)(4326008)(86362001)(8676002)(8936002)(6506007)(71200400001)(83380400001)(76116006)(54906003)(316002)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?A5lIZkw6x0K3tov+m3oQqbM99jG5vOrskUUHuelSUxsN3+SCjHS91gj01a5D?=
 =?us-ascii?Q?knoGiTjnknsxz/IRDZ3HCbB5qMCapl0YpAzfwkQ77gM9rsUqdD82a+UtBXDW?=
 =?us-ascii?Q?aP/36Ujep1DdfppaS4UE8DFi0yrV8OH8An2L4sACFM9/iocpIwdRhX54Til2?=
 =?us-ascii?Q?p8ScmUfwhzJLS5Tik5Bd9U9UR5l81tJGyW7rtkhJwgTmG9Psipzw/fzxOLub?=
 =?us-ascii?Q?hEtdKnzO269fSjpFw8TgHeRzcZEMvsMewvbq5EfmGXSHlvC4cXbPqEG0zpiZ?=
 =?us-ascii?Q?R6QOFCyMt3IDvgpor9sGjyy7FldMFNnWu2ODlF9b3+DktI2QIU3lTXYTZnp3?=
 =?us-ascii?Q?ABM2IEeRD/uyKL2JJLkticiEorhvODiKvHYkbJ4l1EyuLAA/ZIOzRVJMhR60?=
 =?us-ascii?Q?xaaFQhflPwYBqIVsyx3SqhoWxYDXQmEmOOxH/JmW0DNmgrGiueGlGOg/FjmG?=
 =?us-ascii?Q?DMEDxcsE0yoUrJYG8Nk815B1WLc2yUy0q9FFJWxqvJd8o2WtXhB8QN2SZg8R?=
 =?us-ascii?Q?zXpMZuAuhw9qMXiePv0QLVZt0Sizm2Lc9nMcSPu/6ce+alfzCRPvl/y90hrg?=
 =?us-ascii?Q?b7bQe91aTieK9BZ5IB9EekuzHnyGL2KwfyclVNx7L//o5yiNfbsEf81kzZ1+?=
 =?us-ascii?Q?3uBCyW2FFTA5GYMgZoDXCj6xcQK8SkRLVlql88J9l7YgwTlDoHAQ8ol5PvgT?=
 =?us-ascii?Q?U7epM74ek/qp1K3l46Y26J6TBKtoQjoNoeHSX568yVSdbdO8llB9bIXnLlaZ?=
 =?us-ascii?Q?6cfCyESyKT0YFB403WndXI1QXi1LOY4IyPV27dtg3vmRA7KS/TwoUrnFjp89?=
 =?us-ascii?Q?xzVYetiaHbpTN9U6U1XM9SFZQs2OU+tvMHmdDHz83AHTIxrfPMs9BMJY6+Sc?=
 =?us-ascii?Q?bPulwJLGXMF7qrUwjuf6YN9SFSv0ETSNGK69cBwWYwRf0MXBJTSpaOQH/b9c?=
 =?us-ascii?Q?GHkiokomUcJG3IN8KAjetOFrwcw7kkgKPs34yf9E4xdOWlrN1+BJBK+RumxG?=
 =?us-ascii?Q?MwD2tieMSVbtIF+9PxLkhpXSpEtIrxcYVdGA4htUqfjvoiPzuPD7vd1ICIkd?=
 =?us-ascii?Q?5Ti+75SPmUK/RGpnQ/w+7snHoCSsT32JajdGnq+XoFz1iYYRTiKPUmJ9wxlT?=
 =?us-ascii?Q?Zx3zxYiKSAgCluvLmnKAFFwH6V6OAbbvyPHQdF+ZX6Okxjl1JG0TCu80xFbi?=
 =?us-ascii?Q?xVXIOMP4g15pUtb06bCwOoI/40mV+leVsWei5zI5uM8Uv9Kc2QQKO+AryOGj?=
 =?us-ascii?Q?LymmCmUcMbHC/sxLMQiLvRMG3RdtIUsWaKOTH83IxLUs8rJNJ2G4/Uv0QdfO?=
 =?us-ascii?Q?lYn/kbYNVKQ6iUaPQYI2oFYD?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b14c0bad-034d-4071-14d4-08d9824f688c
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2021 07:13:01.6170
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZgTuqLngKUcvXNpnxNQCvb/I0E3HW66kyCBB97/bIgJItAxtKymbiIYs9HnbuAyn5FhqcdLPQZjc3Rzd4H0A3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1716
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Monday, September 27, 2021 10:40 PM
>=20
> On Mon, Sep 27, 2021 at 01:32:34PM +0000, Tian, Kevin wrote:
>=20
> > but I'm little worried that even vfio-pci itself cannot be bound now,
> > which implies that all devices in a group which are intended to be
> > used by the user must be bound to vfio-pci in a breath before the
> > user attempts to open any of them, i.e. late-binding and device-
> > hotplug is disallowed after the initial open. I'm not sure how
> > important such an usage would be, but it does cause user-tangible
> > semantics change.
>=20
> Oh, that's bad..
>=20
> I guess your approach is the only way forward, it will have to be
> extensively justified in the commit message for Greg et al.
>=20

Just thought about another alternative. What about having driver
core to call iommu after call_driver_probe()?

call_driver_probe()
	pci_stub_probe()
		iommu_set_dma_mode(dev, DMA_NONE);
iommu_check_dma_mode(dev);

The default dma mode is DMA_KERNEL. Above allows driver to opt
for DMA_NONE or DMA_USER w/o changing the device_driver
structure. Right after probe() is completed, we check whether dma=20
mode of this device is allowed by the iommu core (based on recorded=20
dma mode info of sibling devices in the same group). If not, then fail=20
the binding.

Thanks
Kevin
