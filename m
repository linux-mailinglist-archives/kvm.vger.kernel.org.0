Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 025093F80DA
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 05:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235469AbhHZDLT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 23:11:19 -0400
Received: from mga12.intel.com ([192.55.52.136]:45118 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229533AbhHZDLQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 23:11:16 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10087"; a="197224297"
X-IronPort-AV: E=Sophos;i="5.84,352,1620716400"; 
   d="scan'208";a="197224297"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2021 20:10:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,352,1620716400"; 
   d="scan'208";a="516316103"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga004.fm.intel.com with ESMTP; 25 Aug 2021 20:10:28 -0700
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Wed, 25 Aug 2021 20:10:28 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Wed, 25 Aug 2021 20:10:28 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.44) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Wed, 25 Aug 2021 20:10:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VanmSQUV07F5eWEhX5oi7hLXYEIAqR4AA21vzb65sYvQrBZxWbKddsfuAwBhxit4UOE1a1GeFDiEUJwxfNUPVkoQF0liXMXDLXvMAtlAz7XiruGa4j1tee/uxlzHPwtZ2R2+ZiPC3BUTWuGcVspy/wlZz5sqPGIeX9qQCOLGP+afLp/iAkOQw4PJgQYwsjd+STsUagT75xbHjyrBQAGlVzwaB+sXWY8CEPePUNVuGmHb/h53pv7OWaE5UUADK8Y7sWQ2DLKD7vp30ww0nzXrrkeAWyZzl8jo8vlZeGoTmCVddtfb0lSG8mfQ0/LnFsw3qdxvv8qT0NLpwG7CCSwqCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uBBkaKBbqvPNCwWg1+aWH4zBhdlQGMCj2WtTtUVPnrg=;
 b=BJxhxmvYS6iycgt48sw2/89MGyeXvXe0EcZVQysNYMWjNM1Soz8dZ4o+VJ7mwRZVqdzJ7mDOgpCGLOOPuF8X9oZMRqCiVg+8/ZYXblGl7LnrR/geP5VFjmvZaqjzgOe7UO7GNvVZljQAU9Rgqq3iPMOlM2YonnC3IlkGzgEmIfo6WwNa5utyVhP5Xc696g1fyFzaeD5kEDi3BnNCYcRs054IOAZl18RZuL/SHFaB7p9P0w3za1n2Jz8z+cAbVxEycMljZpS0QH+ivcghH7M7QYd0rnCVmINDNXkwVI5TUtrTwWMKYFLgo4uKecEd80bKIVfBQTDJLdyC4xNSimHozw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uBBkaKBbqvPNCwWg1+aWH4zBhdlQGMCj2WtTtUVPnrg=;
 b=ZHN1Xa6kP/FBU/UdghlrRv+mW1J20whB3AG9ELzFMq4a7MPI5DCUKuLapZZk3VSjDMiy5YCA9wswzsoR/gCyDV7+WzTasby+YVQhQb3fjSzFZHl4XT1VUVbh38w6WlCB92g53FrUBb+AEwjzpQwwx3Kwov3B8cZs5tGCDF5cNho=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN0PR11MB5709.namprd11.prod.outlook.com (2603:10b6:408:148::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17; Thu, 26 Aug
 2021 03:10:27 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::1508:e154:a267:2cce]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::1508:e154:a267:2cce%5]) with mapi id 15.20.4436.024; Thu, 26 Aug 2021
 03:10:27 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Christoph Hellwig <hch@lst.de>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH 07/14] vfio: simplify iommu group allocation for mediated
 devices
Thread-Topic: [PATCH 07/14] vfio: simplify iommu group allocation for mediated
 devices
Thread-Index: AQHXmc6f69Zs2Ntqa0GViPaMdD5BrquFEH/A
Date:   Thu, 26 Aug 2021 03:10:27 +0000
Message-ID: <BN9PR11MB5433EAD76B636CD7148F06628CC79@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210825161916.50393-1-hch@lst.de>
 <20210825161916.50393-8-hch@lst.de>
In-Reply-To: <20210825161916.50393-8-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f7ae2015-21e6-4cae-4d8f-08d9683f0dad
x-ms-traffictypediagnostic: BN0PR11MB5709:
x-microsoft-antispam-prvs: <BN0PR11MB5709ACDCABF29F3AA9482F678CC79@BN0PR11MB5709.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:341;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6wZNUUelACJwmvXmkPEwEBBhiDe7xeruFtqyAXPB/p4AtT21BoQwK/GpGwANM1xOlSbQ/Vz8M+NG2B5gNaeGxE4mhc+GopZhx9i4EN3Km2/2IvvCsIKJGuBJ18iWkvQiYHj+U9JCbLfhnRfXpqmLW3OhQkcYHu15zrencPtbKxuzQEe9WA63Cd/6lHfweLm/duyOukaxNcGGrvKjaYWI934M7huAj0+bgCGWvWt0CYOF5ATNTNuJ/ligl9k0xiwYdctXOQOIXbPOcMj3Z5mebiuZWhkJte+AT5hu4LEO/syvR19j3oMKAswebStHNv2ThhB0YxwhKr+TY41WO9nxgo2IAVOdXwA5czbZWt3fQBrlrB0pnUtIg1VC2zHKEATADQzNgYg/E5b8Oc0E9DrEX2SxB8W8xuWjHQcUAcevfRHEDeFMLTs13N00TS36D5KmCUkXL51gfW38nQWEoxAuyWWp9AKrjuhTLKl3BDQp1qtv/zVa9zCTpVKY6YjrXb/peABqbXRUc2wBCWX/B9mE23w5CTwMulTwzha83RJANcc9vSZ6/ZDIZWd4V64BXXLRNFr9aVC4Y3isSv+hvvmdPOGRy0OLlmYXjT5Ve+/uOW3LBq3GGAyxfag5KFOxLtHT3UYKFTwLHG8Nod/Fxmorx6M6kwJUwtGPkaavuKQATB6u8KCfWU+Pm17bZexRXLNrpC8o6rmldNQCayIToIK2Zg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(366004)(396003)(346002)(136003)(4326008)(38100700002)(122000001)(55016002)(9686003)(2906002)(71200400001)(38070700005)(66556008)(5660300002)(64756008)(52536014)(66446008)(66476007)(478600001)(33656002)(66946007)(26005)(8676002)(76116006)(7696005)(6506007)(86362001)(110136005)(316002)(8936002)(54906003)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?YFGemRRVQtAGIqhaHt4mSbbq+ht6zW6grffmhA/xSroB1xn6RHRH+kmBM/cq?=
 =?us-ascii?Q?n8X4IHcsZRFYXFY8K3d4ukPmAoHtjD0hTtuiiniyLHR4AsCGHiltAbmPg+kC?=
 =?us-ascii?Q?zCbNYtLMQc9x3EllJ9jDWwVll+tpmdAwJUBs/1xSP+VzMwhy67I4hAVD5Dir?=
 =?us-ascii?Q?Tfz8g8Xdf6b//fcUx/l7psrlyl+KSjdLFsWvE8Bwx+6Ow12ActUL9zg88pME?=
 =?us-ascii?Q?OcwC1npaDrjL7+I+Gn1Mg0wlRcKOMHT4nddwh0ZuHOhEUw7HqhXeOokJfS/r?=
 =?us-ascii?Q?ps9tc0f4//nQvWTbzQ24JHIyAyuRAMWkVHDm9V1533J1/VOkjZVRyWOcs1p8?=
 =?us-ascii?Q?O06xReXm28nB1dq1M/421YjsFxHsFytj3DTDsCVsSTiBmHUd5b3XPTFisSFv?=
 =?us-ascii?Q?wK+1rwThDjrmzcxj7NfdkzAQTpxn5AmUlO2xtvqrz2bQA3DnhqYhZgWCWkre?=
 =?us-ascii?Q?6urPpivqnHqtpLtIhCbqH2lfz64r/EAMifFl6AQYH4QD8XpE+NylG9JucO/y?=
 =?us-ascii?Q?/HOytA7a604TuukMNO5cihZ3KK2hqUgt8B6LBN4+p1dIAAN05fViO8ZWlm8K?=
 =?us-ascii?Q?dTcnBMvsEvw6sXdWJsLFlAS7j0eijJc1dlsoyKEzjy0ADsT5cpn3Rw3PviE8?=
 =?us-ascii?Q?d13mcj5I/33Ff2hYE5/ht2anFyJu14QU7JJPftGg1/JzKukwCkBaGKzuU07R?=
 =?us-ascii?Q?60mSG4s0r1X1OGJlHSgX4Ul/sWk7LQEsrdWa8a4erKPLVyhVfzXK+rkf9WJm?=
 =?us-ascii?Q?uFx39vqC4zHOmkwCgcgjlYkDbPZoHCUsBIloZoHakQ6QDuZS58BHEsxJWkrn?=
 =?us-ascii?Q?juStjrSMsb22ldpysUlph9D+RbkPhKkEH5QCXnwSaOCHo6b2OmO+VxlaIrjy?=
 =?us-ascii?Q?3AueKSUP4VghhxZja6A+ck0hNvmEKuscb4tc+/+NTeQSIfLN0815ZtDILGdn?=
 =?us-ascii?Q?yAQeINWcmwJ698GV053bQAYJCwoym+UVJJBWBY+P7doKotA4KqnyCxHD7rcQ?=
 =?us-ascii?Q?c7OnwQ3fXVdFemY3LRtLmIye8OJvkLQUeJ6PBet/YFk7cRDQbRZv0mjxVOQm?=
 =?us-ascii?Q?2RqVkD3GtT/D49LrXdd20hLxQBuKqeERi37xfm4Ye7A87/od96XQlyakeMMg?=
 =?us-ascii?Q?8/BPFOLZmCmFmPClWJCnnCy4teD4vmU1oL4VApimm0JQX89nSYsEF5YMmg8G?=
 =?us-ascii?Q?anYEUGA0nI5Fkxe2VrU7TtZD7cOodGJXJVLuNWtQRrRjfVZEgQz6V1B//zfd?=
 =?us-ascii?Q?zQp8rQCXBYFoY7yzvGF3N4ODQ72nrqqHgZk7/Y/IiUEN3q5Nf+KxmcCKaAT6?=
 =?us-ascii?Q?rk05tvz3+Mb0mTZHBZ9bYzIJ?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7ae2015-21e6-4cae-4d8f-08d9683f0dad
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2021 03:10:27.0449
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fCCqxM+S+kkA4XgDjsRwkwh8ABvU9GVrQAJWi+6g1/9HStPdorcCvGuHnqBNyv2W9KZKI8XguGDHKeXUiGZkvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR11MB5709
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Christoph Hellwig <hch@lst.de>
> Sent: Thursday, August 26, 2021 12:19 AM
>=20
[...]
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 71e0d3c4f1ac08..6bdfcb9264458c 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -67,6 +67,9 @@ struct vfio_unbound_dev {
>  	struct list_head		unbound_next;
>  };
>=20
> +#define VFIO_EMULATED_IOMMU	(1 << 0)
> +#define VFIO_NO_IOMMU		(1 << 1)

it'd be helpful to have some comment here, as emulated iommu
is easy to be mixed with virtual iommu. At least here so-called iommu
doesn't refer to the exact iommu hardware. It's more about the
capability of DMA isolation and how it is implemented.

[...]
> @@ -391,8 +394,8 @@ static struct vfio_group *vfio_create_group(struct
> iommu_group *iommu_group,
>  	}
>=20
>  	dev =3D device_create(vfio.class, NULL,
> -			    MKDEV(MAJOR(vfio.group_devt), minor),
> -			    group, "%s%d", group->noiommu ? "noiommu-" :
> "",
> +			    MKDEV(MAJOR(vfio.group_devt), minor), group,
> "%s%d",
> +			    (group->flags & VFIO_NO_IOMMU) ? "noiommu-" :
> "",

what about introducing a group_no_iommu(group), given many duplicated
checks in this patch?

Thanks
Kevin
