Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A906142ED6C
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 11:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237224AbhJOJU3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 05:20:29 -0400
Received: from mga07.intel.com ([134.134.136.100]:1896 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234769AbhJOJU2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Oct 2021 05:20:28 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10137"; a="291365315"
X-IronPort-AV: E=Sophos;i="5.85,375,1624345200"; 
   d="scan'208";a="291365315"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2021 02:18:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,375,1624345200"; 
   d="scan'208";a="564236847"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by FMSMGA003.fm.intel.com with ESMTP; 15 Oct 2021 02:18:09 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Fri, 15 Oct 2021 02:18:09 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Fri, 15 Oct 2021 02:18:08 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Fri, 15 Oct 2021 02:18:08 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Fri, 15 Oct 2021 02:18:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J/UFdrjVpk54LvvFXBiSiTyLw7q1ICjqebF+x0js9f9/VkY5MHvK4NwIHXUTX26YUTrrqbSjOxmWB/RranlozRo6yXB/b+X3KHPELLogpMg3WU7pFWl7PalLoUPMULRLow/rfgrFjfnAQfjfoCdorb1hUqWzvns4MVj2DNUHps8a/QdhfvJvDWj/fIlEn2ZB2ffQFWW8WTZop5uxCnUIEwdEfl52bOJN8WfxzepSfubxE6XEfUVBFGpCNctMaUgiKbj6nsmvCvq6Vskn8JZrk8Jgf7IFczA/5xGrq0kDl+aCVzhuG4V1aAKp17OnS64r6iJB+lsbpDyw+bSgfszKEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n6tfIUS87jrFaBaXHPyR2rzcQmOiY2kxb+rkNlyK+hg=;
 b=gPSG1D2RFNGp/1YIod3ehfb/zbuaw/skKw9EQUzlbO3HUiPjsSeTJMAbAVaUubDr78WDX94wvtkXg2n1luCTYw6c9EXgSw4Uru6HTETSzB+EjzBmSo/WLqE9DwXhny89OBaOCsyKcOVqQgYRXSYJp4EpkeuDQ9zmux+ssr4Ii0rqCz2D8n/7yYPAnbbK43FI1MsfdnB7LC4qdOaByVdih9fN/yYR/pGgg4W6Jv+CPR0YG1RtwugMckxgifRJIsL0IZqVZPj0ytGkuerJexf0FiDCgE7Ql5W5A848kMX1jTK9sv116SQ421lnQ6InrLWbNxsMq8ACSnC2BpL/gHUTSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n6tfIUS87jrFaBaXHPyR2rzcQmOiY2kxb+rkNlyK+hg=;
 b=mw9hWt1FX/fDVBFMKXhak/KfAwgojXYaoejGYtNql36cCPY237qDU+/K1gXXDihRd/QLEXaPQWLMsmIGizhu3rEmq/wNOpI2wSxuu5yFib5BtiwsQ2utbLqKzRVb88LFsZrgFMK/EZlhkKOuh4K72hpZMsoGOGoT9mAZWFNXdhE=
Received: from PH0PR11MB5658.namprd11.prod.outlook.com (2603:10b6:510:e2::23)
 by PH0PR11MB5594.namprd11.prod.outlook.com (2603:10b6:510:e4::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17; Fri, 15 Oct
 2021 09:18:06 +0000
Received: from PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::5009:9c8c:4cb4:e119]) by PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::5009:9c8c:4cb4:e119%6]) with mapi id 15.20.4587.026; Fri, 15 Oct 2021
 09:18:06 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "hch@lst.de" <hch@lst.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
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
Subject: RE: [RFC 01/20] iommu/iommufd: Add /dev/iommu core
Thread-Topic: [RFC 01/20] iommu/iommufd: Add /dev/iommu core
Thread-Index: AQHXrSFn+yRWuHvsGk21Z769W7oSJKuupBEAgCVKaUA=
Date:   Fri, 15 Oct 2021 09:18:06 +0000
Message-ID: <PH0PR11MB56583356619B3ECC23AB1BA8C3B99@PH0PR11MB5658.namprd11.prod.outlook.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-2-yi.l.liu@intel.com>
 <20210921154138.GM327412@nvidia.com>
In-Reply-To: <20210921154138.GM327412@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8e585235-ea31-478e-8d21-08d98fbcb2c1
x-ms-traffictypediagnostic: PH0PR11MB5594:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR11MB5594A95F5A5D35EABFAFFBE2C3B99@PH0PR11MB5594.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: U21VXXSkmb4BfaayaTeQ2kl0rlTCUqJq3qCvSscd82sjc0xpxr+3aLGvY+c+kXk+DZd1e1uJX6gf3qD8oTvhkCV/+HMc+eDYaF6gxv9/dxHneBSrMk+LikVeH2lTXH2mk+6EirlvqeRyMz0iPHKDw3Z3mJLJVBmSSZnYHrdyI7LXDNVcgfFPeMWbk0VifLBGGqVLH0kT25cSluMaYVJMOXMWPb1BovT0jz/ymQdThpoLEI9wSwBlfLGG7zymyKpU8vqC9AbHbNUoQiVUIKTE1gtJrORqV69sW0QQL/H9mwTx75AsCIXWflbW5aqZHAV7/ENtYCBj+tmCHvcX4rR19WQ5AmeR6RJcGl/TiStwjgRckBue13aUgkIH+NQaOrnNjgEKBzbwKfYKjL4w0a+ii+2xa1OZLZc1nU9NvRzahhb9SpkDZKl6nVrFTeQ1/ziNELZdIjlmjBPF35PX613DysPStkiOtQrDfvjYd9k21vapo+5XzB0fbG5Mhbgrcv/wChaWkWmwDKeV72yzukUSWqr/HsJOXZmozIyzXoj2XcOyCOHJ9+3xx4Ur/ciMpv1xJQwn63XJeUkYqFvVvRExZ66YQp6BxoESVYRC7Fy0paEACcjvv5we43zqdf7RxYEB5ZfrTkAlIj9VIAGap6O6GxFHDMLauLu45ck2MAnFwYjwJvzgqnqF93CHRjqhwCm7Mww9B6LgfKuOPtpJvZI0n+uOh1KXIvtZ7h/vnwOh+kQiM74UDQ4jL1JY25FctaB1E8OH/viOhbiNAstlg33NeIID90exGfcQK3E8C5y83yU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5658.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(71200400001)(83380400001)(9686003)(7416002)(38070700005)(55016002)(38100700002)(122000001)(82960400001)(4326008)(2906002)(316002)(508600001)(86362001)(76116006)(54906003)(6916009)(966005)(66446008)(64756008)(66476007)(66556008)(66946007)(186003)(33656002)(26005)(5660300002)(6506007)(7696005)(8936002)(8676002)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?KfsUYGjM/43xRoLINfvfiUQ9xKs1B5dHjGZMzap6H6eH22JoU0/P8I2Li8Il?=
 =?us-ascii?Q?cbi/fWnefW1GyMM29taxW79zwwyecrziAXZsPSEtg8ApK94RqIRWeggiUR6W?=
 =?us-ascii?Q?Vp8Z9/CwK1vZjV+FFm6RLfuhWNR2A7BOmQu+JLTcNmvgy7cuaJ9JMn2N6vIm?=
 =?us-ascii?Q?z2kNBrKenOEroYNTCNmN1Qn+PDoADWU4j5aLR7+1Ab8dcuQ6bxARTKsecFFF?=
 =?us-ascii?Q?vy5Ea4SxJW4KqMFyPlzehxi8NoJOIjCrdCkpLv2ESO7KCNd/gIgVYCp1TxNp?=
 =?us-ascii?Q?XLYT56iS8TSuBWqlUmFaemr5u8M0PDNoXtXgeo3NzSwh38hp0nduGWqpfPtJ?=
 =?us-ascii?Q?oILd0Wje8bOynglzd7/YGuTHqaQ9/uebLw70zu11C29IrHtT6aztR7DCblb4?=
 =?us-ascii?Q?/TJIhs9nd1jKOJMJosA8//h1rrgoPbZUOS8bh83IOSQ1O/XVc5cZqyCFzmop?=
 =?us-ascii?Q?VskTVJFblSB2Zm61tG8bZukf2XOwTTY9c+1mf+gz51+6ugpm+4u8r7fS2YxT?=
 =?us-ascii?Q?IpH36nu471k64+DxmK8SoH2mxav21zyb7NdFY0V/aDBTC4cO0COVbKpRhqJE?=
 =?us-ascii?Q?r0hwT/roCVh5ueMYk6qTaoDRE12mHB6mxYMT/v95F9spx8GtrzU0Zt8f8+3H?=
 =?us-ascii?Q?pY7xXLHwvfIGbT+FFtQ8n1CYm9uHj1Y/0JYsAspf/yZ5iFXf9vOvxqRfhLmZ?=
 =?us-ascii?Q?1n2srO+gHEVWkNASH9ny9K8ZR99Bwgbw3hm1Et+k3vd5X/eSkFDzO3vy2Oaf?=
 =?us-ascii?Q?gDXnmSkWCQNGtjX3kSqW7J7ybyyKPwZRgNHl+JMhrXbVD25NN8OjtAsJZiy9?=
 =?us-ascii?Q?/BrZXDwYQu1tFoHWwnQUyulsoPnIjYdTpAZFzz9+lS+52+jnHzlcehGMUivV?=
 =?us-ascii?Q?zE/SaWfAyzUbYIrxO7uW/ATyzT7vr9gkMcTpTZrMp93rCM2wrrwiWjDCcuK6?=
 =?us-ascii?Q?0SCdZaTRJ/QpOmzOahRKNTPKgpJQPO77M57pukNSVgiOfaAYP0G89zrgM/OU?=
 =?us-ascii?Q?nYSRQmGvzxcEShlDUEs0XGHrVjgFXQarwwpR+ymRy5rB5QZHDN9Os+n31sk9?=
 =?us-ascii?Q?MTATZjNNRK9YHGI2ln8O7ujGdXoSUGhs7BnpadHM39mQMpP/yTS5kIpSopCg?=
 =?us-ascii?Q?Ju+GT+VrAnbgz3EC2ArKgDTYeGQsubKBP5J65sISjwxhjK7BPOuPUYeEYDuZ?=
 =?us-ascii?Q?0ZYlIWKEWmxvXjkDVCyj6zjfzGYNhNGYXhdHqI34WwEf+vXSsVT8ea6z1ssx?=
 =?us-ascii?Q?awANI7b2nvO+wj+fIaK3UduvbN/eAS2wAO0m9h5a5mEdmltTqiyQEtpE52++?=
 =?us-ascii?Q?8MgDjL8xu2pqQaWkEet0BDoI?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5658.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e585235-ea31-478e-8d21-08d98fbcb2c1
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2021 09:18:06.3396
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vvvOzr8tONey2LxZaSecR+P8yDSdjfZGSn1YoMNNJvd7ukC4gUaWb5Z1T4gtfJemtQPfl7qP/lJrXWA1q2MHEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5594
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, September 21, 2021 11:42 PM
>=20
> On Sun, Sep 19, 2021 at 02:38:29PM +0800, Liu Yi L wrote:
> > /dev/iommu aims to provide a unified interface for managing I/O address
> > spaces for devices assigned to userspace. This patch adds the initial
> > framework to create a /dev/iommu node. Each open of this node returns a=
n
> > iommufd. And this fd is the handle for userspace to initiate its I/O
> > address space management.
> >
> > One open:
> > - We call this feature as IOMMUFD in Kconfig in this RFC. However this
> >   name is not clear enough to indicate its purpose to user. Back to 201=
0
> >   vfio even introduced a /dev/uiommu [1] as the predecessor of its
> >   container concept. Is that a better name? Appreciate opinions here.
> >
> > [1]
> https://lore.kernel.org/kvm/4c0eb470.1HMjondO00NIvFM6%25pugs@cisco.co
> m/
> >
> > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> >  drivers/iommu/Kconfig           |   1 +
> >  drivers/iommu/Makefile          |   1 +
> >  drivers/iommu/iommufd/Kconfig   |  11 ++++
> >  drivers/iommu/iommufd/Makefile  |   2 +
> >  drivers/iommu/iommufd/iommufd.c | 112
> ++++++++++++++++++++++++++++++++
> >  5 files changed, 127 insertions(+)
> >  create mode 100644 drivers/iommu/iommufd/Kconfig
> >  create mode 100644 drivers/iommu/iommufd/Makefile
> >  create mode 100644 drivers/iommu/iommufd/iommufd.c
> >
> > diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
> > index 07b7c25cbed8..a83ce0acd09d 100644
> > +++ b/drivers/iommu/Kconfig
> > @@ -136,6 +136,7 @@ config MSM_IOMMU
> >
> >  source "drivers/iommu/amd/Kconfig"
> >  source "drivers/iommu/intel/Kconfig"
> > +source "drivers/iommu/iommufd/Kconfig"
> >
> >  config IRQ_REMAP
> >  	bool "Support for Interrupt Remapping"
> > diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
> > index c0fb0ba88143..719c799f23ad 100644
> > +++ b/drivers/iommu/Makefile
> > @@ -29,3 +29,4 @@ obj-$(CONFIG_HYPERV_IOMMU) +=3D hyperv-iommu.o
> >  obj-$(CONFIG_VIRTIO_IOMMU) +=3D virtio-iommu.o
> >  obj-$(CONFIG_IOMMU_SVA_LIB) +=3D iommu-sva-lib.o io-pgfault.o
> >  obj-$(CONFIG_SPRD_IOMMU) +=3D sprd-iommu.o
> > +obj-$(CONFIG_IOMMUFD) +=3D iommufd/
> > diff --git a/drivers/iommu/iommufd/Kconfig
> b/drivers/iommu/iommufd/Kconfig
> > new file mode 100644
> > index 000000000000..9fb7769a815d
> > +++ b/drivers/iommu/iommufd/Kconfig
> > @@ -0,0 +1,11 @@
> > +# SPDX-License-Identifier: GPL-2.0-only
> > +config IOMMUFD
> > +	tristate "I/O Address Space management framework for passthrough
> devices"
> > +	select IOMMU_API
> > +	default n
> > +	help
> > +	  provides unified I/O address space management framework for
> > +	  isolating untrusted DMAs via devices which are passed through
> > +	  to userspace drivers.
> > +
> > +	  If you don't know what to do here, say N.
> > diff --git a/drivers/iommu/iommufd/Makefile
> b/drivers/iommu/iommufd/Makefile
> > new file mode 100644
> > index 000000000000..54381a01d003
> > +++ b/drivers/iommu/iommufd/Makefile
> > @@ -0,0 +1,2 @@
> > +# SPDX-License-Identifier: GPL-2.0-only
> > +obj-$(CONFIG_IOMMUFD) +=3D iommufd.o
> > diff --git a/drivers/iommu/iommufd/iommufd.c
> b/drivers/iommu/iommufd/iommufd.c
> > new file mode 100644
> > index 000000000000..710b7e62988b
> > +++ b/drivers/iommu/iommufd/iommufd.c
> > @@ -0,0 +1,112 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/*
> > + * I/O Address Space Management for passthrough devices
> > + *
> > + * Copyright (C) 2021 Intel Corporation
> > + *
> > + * Author: Liu Yi L <yi.l.liu@intel.com>
> > + */
> > +
> > +#define pr_fmt(fmt)    "iommufd: " fmt
> > +
> > +#include <linux/file.h>
> > +#include <linux/fs.h>
> > +#include <linux/module.h>
> > +#include <linux/slab.h>
> > +#include <linux/miscdevice.h>
> > +#include <linux/mutex.h>
> > +#include <linux/iommu.h>
> > +
> > +/* Per iommufd */
> > +struct iommufd_ctx {
> > +	refcount_t refs;
> > +};
>=20
> A private_data of a struct file should avoid having a refcount (and
> this should have been a kref anyhow)
>=20
> Use the refcount on the struct file instead.
>=20
> In general the lifetime models look overly convoluted to me with
> refcounts being used as locks and going in all manner of directions.
>=20
> - No refcount on iommufd_ctx, this should use the fget on the fd.
>   The driver facing version of the API has the driver holds a fget
>   inside the iommufd_device.
>=20
> - Put a rwlock inside the iommufd_ioas that is a
>   'destroying_lock'. The rwlock starts out unlocked.
>=20
>   Acquire from the xarray is
>    rcu_lock()
>    ioas =3D xa_load()
>    if (ioas)
>       if (down_read_trylock(&ioas->destroying_lock))

all good suggestions, will refine accordingly. Here destroying_lock is a
rw_semaphore. right? Since down_read_trylock() accepts a rwsem.

Thanks,
Yi Liu

>            // success
>   Unacquire is just up_read()
>=20
>   Do down_write when the ioas is to be destroyed, do not return ebusy.
>=20
>  - Delete the iommufd_ctx->lock. Use RCU to protect load, erase/alloc doe=
s
>    not need locking (order it properly too, it is in the wrong order), an=
d
>    don't check for duplicate devices or dev_cookie duplication, that
>    is user error and is harmless to the kernel.
>
> > +static int iommufd_fops_release(struct inode *inode, struct file *file=
p)
> > +{
> > +	struct iommufd_ctx *ictx =3D filep->private_data;
> > +
> > +	filep->private_data =3D NULL;
>=20
> unnecessary
>=20
> > +	iommufd_ctx_put(ictx);
> > +
> > +	return 0;
> > +}
> > +
> > +static long iommufd_fops_unl_ioctl(struct file *filep,
> > +				   unsigned int cmd, unsigned long arg)
> > +{
> > +	struct iommufd_ctx *ictx =3D filep->private_data;
> > +	long ret =3D -EINVAL;
> > +
> > +	if (!ictx)
> > +		return ret;
>=20
> impossible
>=20
> > +
> > +	switch (cmd) {
> > +	default:
> > +		pr_err_ratelimited("unsupported cmd %u\n", cmd);
>=20
> don't log user triggerable events
>=20
> Jason
