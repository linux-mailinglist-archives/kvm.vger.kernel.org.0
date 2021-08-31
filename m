Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C83E23FCAC4
	for <lists+kvm@lfdr.de>; Tue, 31 Aug 2021 17:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239067AbhHaP1l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Aug 2021 11:27:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:44900 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234356AbhHaP1h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Aug 2021 11:27:37 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10093"; a="240753008"
X-IronPort-AV: E=Sophos;i="5.84,366,1620716400"; 
   d="scan'208";a="240753008"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2021 08:26:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,366,1620716400"; 
   d="scan'208";a="687772144"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga006.fm.intel.com with ESMTP; 31 Aug 2021 08:26:42 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 31 Aug 2021 08:26:42 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Tue, 31 Aug 2021 08:26:41 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Tue, 31 Aug 2021 08:26:41 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.42) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Tue, 31 Aug 2021 08:26:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f52DbUB3eVNfmg71s7jthQ0xZ86hMLv0dWdsSywgeUgkmssnMLJiBfJQZGn7mD4WCj/vGIJIslAu58g+Hs+n8j1zaBaoJHCzkJIcVpX3uSbhonlEvQz3LbO8KWhInrXI96AzM4n/Ix153I3D7NfI0pYqP52IJUk5vfEQBU3WpyxVfdu5zol4d9c3CYNe9pa3u2emZQ5qRiG6E31CxAqojYP071vhvjFJNHwu1y3jJt/KJVbkip7e0MetDO8kW7KdPh037tNt/WdxQIhoXHfcOVqgeSay89mHwZKsJbTSZZCX7x9SBwPJmpLyxClr3P0gn/vt8WC7OXfFrxM4BfBziA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=rnEyex/wUpfi+wwwD0uIie7JpkscFSCJZg0JjNflRgM=;
 b=Qw9BSgkjQ+Gi+8ChV8mxKQ0g8Slu/5B5qMrbCRCuHE0PEdFlZU+v4wU8TJye9GtRm/5ucod+LTEIWMaXJxVsy5HHNG3Ckufv+CnHh9mtFRuq1snAoLovJvjuIPQD8A0GOU5OXXCFploy0pfsJlpAeQ72J+SRPmIV1DyG42No1HUOlonh28bk++y+SOlkOGn4gPNc8zHOwnT2doFJKdjkuuJDA3U2fxt7ZVkaBTaqgDKE2yqL1eFmNwvkOe//d17ELC8M8Yq7EkcK8ejA2og7jYDrsbsPS72tXT+GG/YWsC0q/tma4W2ryfMi03fQT5+U9oAs3nhmpPkQyxFmlH53Ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rnEyex/wUpfi+wwwD0uIie7JpkscFSCJZg0JjNflRgM=;
 b=qV7g60lE42+5US9spIe8fT5uMoENV8Cabdb/Z9skDwzmgeodlqocCBOpd8a3QY2fkiz9OO95yCfb7DRCYkWUVVUC641JXRjCUACxTpOngEKLaQ0+T8UKyf/65pWE0/Vy/4nT4ABvmdfHTdnGq0TdxAQf8FfE0u58PVF0nu1YWTg=
Received: from DM6PR11MB3177.namprd11.prod.outlook.com (2603:10b6:5:c::28) by
 DM6PR11MB4691.namprd11.prod.outlook.com (2603:10b6:5:2a6::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4478.19; Tue, 31 Aug 2021 15:26:39 +0000
Received: from DM6PR11MB3177.namprd11.prod.outlook.com
 ([fe80::1801:b765:5ffd:d121]) by DM6PR11MB3177.namprd11.prod.outlook.com
 ([fe80::1801:b765:5ffd:d121%3]) with mapi id 15.20.4457.024; Tue, 31 Aug 2021
 15:26:39 +0000
From:   "Xu, Terrence" <terrence.xu@intel.com>
To:     Christoph Hellwig <hch@lst.de>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: RE: cleanup vfio iommu_group creation v4
Thread-Topic: cleanup vfio iommu_group creation v4
Thread-Index: AQHXmn9moZsDdebiT02j6t/c9iMEO6uNwvVg
Date:   Tue, 31 Aug 2021 15:26:39 +0000
Message-ID: <DM6PR11MB317712989F22416D54C9641BF0CC9@DM6PR11MB3177.namprd11.prod.outlook.com>
References: <20210826133424.3362-1-hch@lst.de>
In-Reply-To: <20210826133424.3362-1-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3c540eec-0c02-487f-14aa-08d96c93babf
x-ms-traffictypediagnostic: DM6PR11MB4691:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB46919E80612CD23A5565CAF9F0CC9@DM6PR11MB4691.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ws1xkh+8eMM++uMtd5XWACpyCQBYMkRfB+srpp1aaLXknmmh/LxKXqeDgN49DhYbFeW7LksxzHLRfsZVOpC9k/i/NUClht6AlhObcl7TA5u14FKlY1OG9qg+v2OIzYAL7oBrY8MKjqeTb/2nIfBxkT3MVvJLl++lfzqhJek1Za68klrNb0+fUVo7ewPZ9ZNkACxngThmxXZVbd7alSFHNlEAc9Nd0ZC5CDC5OsBtB0sfQPpfZE6ynK0YjFDiiGcsAy+6lnXt/IDv+BQWUnVHce2hZ1sS8go31pc8CLl+/pLNUY3wDTBwuaaqoLBpKlLDMlowNlpaXZDDgI4keVv/XTS9+bKl3x3ImlIc8UueD8BE/V3l2NYzDq4ksdDC8nXqCje+coOuwAZFlk/I9SMm0qU9FzVtRgD6ifvXYHX3wnOBkSlJXIbbNOqO/Yo9piJv2twlJ2ZziKV1E30gFOLmJEGRf8I6zHbn1M4WZhoY5sGQN7sH8iXcFyKkZ3KZkgaaTnZIYLz3ruyfpI0qi7iS8GaV/NKd/pX96hxeuvPukih/1QyYkGKFDMg+0XhFSk3aT9J7+Li1neLnxXa2u0wdVyJrM118nXkCEE+uB1HdGhNYyB8x++xyje9wzBV/01pqGmkwjUye/bXXuOEIJLjDxrrwMf9W8dfooxcr5C0yZ/VLaISooDKNfoKYPv3DztDqsl/71wcy2Nrh/V/wddGS3w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3177.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(39860400002)(366004)(396003)(376002)(107886003)(8676002)(7696005)(186003)(66556008)(66476007)(4326008)(26005)(76116006)(64756008)(8936002)(38100700002)(6506007)(33656002)(122000001)(38070700005)(66946007)(2906002)(478600001)(66446008)(5660300002)(71200400001)(83380400001)(86362001)(54906003)(55016002)(9686003)(110136005)(52536014)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?My3mzmNzgiZA3Oh1UE6L320+Ff9ifaGrarg7GY0ocI0IwgYFgs82kuTChxD5?=
 =?us-ascii?Q?wMK0dfPjbU82vY18lzu4hWg6xVFwxylkF7dP92rgq3v2/AZGJm3vZzGL8GsU?=
 =?us-ascii?Q?P7k8szaObwCRuW6fMii1EZEqG6SHEQz2QlWHUxXkqBrjwXF06KonyPUIQ4gE?=
 =?us-ascii?Q?Y8bUKwLVK0WwQSAXgj3uX15pljaN5y7SRQV41bCzkBzdNuDBeoV84E13+kzq?=
 =?us-ascii?Q?41eVTwfnR6N3LMsAyprtLsluCG03NsSR8xsn2URlTQEPMyhLd8Y66iz9y/Rm?=
 =?us-ascii?Q?UITLfadqtGb9UYXZue2rjScISrfgTRyqAiTbA99e8QLrxYdTBgBbbNcoQxio?=
 =?us-ascii?Q?+qD2jROCDPhnH796NJKuTdQuIPrxUUlP+DX9Hu2k6Mq6EbogALjR+61X9cI/?=
 =?us-ascii?Q?ThjgGJaCiFqRHc0r8KwTSOUxjM2VBmisarnJVFD/R/1XwiDJgu/1OGdpGD9T?=
 =?us-ascii?Q?iImXbhX+N7czwdrURaRyr3k68lFGNybU+xBCTzZ9M7pEAIRk6rSV3zwYWM6H?=
 =?us-ascii?Q?ib6Xfi3nipacVJl3aSiPOyhfCE6eV1zDajI3Vs0F9V9w8oUV6hNIqriAUxHJ?=
 =?us-ascii?Q?1GntveO+Hbr3AkHlBNf38KGoE067MJH30m/Ipo7l9s0OymiiTIQcm1mSEVxJ?=
 =?us-ascii?Q?LtwnLm7yC8HQloQdEHM+I30hMZUl4mo3wyzUoW5sGvXR64Sm9L9RxisQw537?=
 =?us-ascii?Q?tZjMnax5hCVM83cOOxA6jgmGS3tyJrZrIJo73YMaoJmaiaPIIDTFZMgTkOLl?=
 =?us-ascii?Q?aR0eqHUXCqvf+m+kuvNwiTzof3d6WabbXne7L02SoUpdZ6YwOxTfs4TMwNYQ?=
 =?us-ascii?Q?xRWt2Mwv2pBaspx8R9sUbL/EDh0MvUE31apewR6ouTSVsRMKbyarFateEdF2?=
 =?us-ascii?Q?psOZBvvsiN3ywW2uvEimKTDn0CcoLTxmLUgTYu8suQDbUZVpFhTmbSJXCFfJ?=
 =?us-ascii?Q?J37HYMiV+HpPYD4wL4lUoqApgdWOu2vwcNQ8d5GOqHv4xQAcPsDS0cEzRgIO?=
 =?us-ascii?Q?pR0XZi3LM8VWwDMus7MeQ6yoFC2nQHcAoZHuB6SrKjc1OWYP2d1LLSSrdjfZ?=
 =?us-ascii?Q?s3sNzdM40qS1oD/0bMcWCIIYWqT0T5CaBVGUvdQPozkkCgB206Si8RgIRZnp?=
 =?us-ascii?Q?Nfh90KqIUxlOZzcX7GOZ19aeZ7lm6lOcZqpUnqA51rMq3tTwqp75GEuD850Z?=
 =?us-ascii?Q?1wbxaTAMsBRpQ7ioZvcHxTBETiJSOdTUio6T/0qRIEyic5KtbDzL5EXZsfNC?=
 =?us-ascii?Q?BnWwQJ6a4YSBUK+uMChoD1mQOdYOqYf4F6k3HS9tFGQR5Qv3uySRlMT+qKm3?=
 =?us-ascii?Q?9tUAEkRcnUETfpa4m7mGGgYG?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3177.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c540eec-0c02-487f-14aa-08d96c93babf
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Aug 2021 15:26:39.7853
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: w4fbRdt4N8xb5XK/V0IXOD2YwU5NRcHdL5uc4oV/UeRZvmBHeVJv2X0WrhJP46kSacped5CKOSfYJZ7JbCRaCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4691
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> -----Original Message-----
> From: Christoph Hellwig <hch@lst.de>
> Sent: Thursday, August 26, 2021 9:34 PM
>=20
> Hi Alex,
>=20
> this series cleans up how iommu group are created in VFIO as well as vari=
ous
> other lose ends around that.  It sits on top of the
>=20
>     "Introduce vfio_pci_core subsystem"
>=20
> series from Yishai
>=20
> Changes since v3:
>  - restore the attribution to Jason for patch 1, which git-rebase lost
>  - fix a vfio vs iommu group counting issue that I added over Jasons
>    original patch
>  - add comments describing the VFIO_EMULATED_IOMMU and
> VFIO_NO_IOMMU
>    flags
>  - use the emulated iommu naming consistently in comments
>  - a spelling fix
>=20
> Changes since v2:
>  - cosmetic changes to the code flow in vfio_group_find_or_alloc
>  - replace "mediated" with "emulated iommu"
>  - add a comment describing vfio_register_emulated_iommu_dev
>  - rebased on top of the "Introduce vfio_pci_core subsystem" series
>=20
> Changes since v1:
>  - only taint if a noiommu group was successfully created
>=20
> Diffstat:
>  drivers/vfio/fsl-mc/vfio_fsl_mc.c            |   17 -
>  drivers/vfio/mdev/mdev_driver.c              |   46 ----
>  drivers/vfio/mdev/vfio_mdev.c                |    2
>  drivers/vfio/pci/vfio_pci_core.c             |   13 -
>  drivers/vfio/platform/vfio_platform_common.c |   13 -
>  drivers/vfio/vfio.c                          |  306 ++++++++++++--------=
-------
>  drivers/vfio/vfio.h                          |   63 +++++
>  drivers/vfio/vfio_iommu_spapr_tce.c          |    6
>  drivers/vfio/vfio_iommu_type1.c              |  255 ++++++--------------=
--
>  include/linux/mdev.h                         |   20 -
>  include/linux/vfio.h                         |   53 ----
>  samples/vfio-mdev/mbochs.c                   |    2
>  samples/vfio-mdev/mdpy.c                     |    2
>  samples/vfio-mdev/mtty.c                     |    2
>  14 files changed, 292 insertions(+), 508 deletions(-)
We verified the Intel KVMGT feature, no regression be introduced by these p=
atch series.
Tested-by: Terrence Xu <terrence.xu@intel.com>

Thanks
Terrence
