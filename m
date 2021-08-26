Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFEB73F814E
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 05:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236708AbhHZDxD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 23:53:03 -0400
Received: from mga12.intel.com ([192.55.52.136]:47597 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229898AbhHZDxC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 23:53:02 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10087"; a="197228774"
X-IronPort-AV: E=Sophos;i="5.84,352,1620716400"; 
   d="scan'208";a="197228774"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2021 20:52:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,352,1620716400"; 
   d="scan'208";a="444410013"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga002.jf.intel.com with ESMTP; 25 Aug 2021 20:52:15 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Wed, 25 Aug 2021 20:52:14 -0700
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Wed, 25 Aug 2021 20:52:14 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Wed, 25 Aug 2021 20:52:14 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.109)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Wed, 25 Aug 2021 20:52:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hhxi2gh2CRvNDcEiSyxiQXuXvrRh/SGqioAWvDw7Dh3s5FoqqPm7HzE8VxUxbimhavPCms8BfiV+yjJ6BB4v25ExU24z9DqlJCIE0BJjjcn2OzjykPIDKBfEzWEDKn4PMfhHQfEgwmO+ensA0+CTwE7wIqE9cCl91mTF+vIkR5AP/Qzr1G5vKIwcJhVIVCXFCfrgIHkxoJq/HgehE/24Yn8gD+G0lz2XRdPN3dDtx0aflrQZMXxrtoG1uYv41VUkqxzYQ5/Ys2qug2UlsErovBkw950NbocDpCM9JAO4VhkR05UuL6HGfxvDcxTFNYUqnUCpz4wH7VSJp/b8bi4U2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1D8NxdYRIPrcs0rmAvrLjZuuBBgTl9FLH2dLK+Kt83k=;
 b=Dsu0PblCNKJ6hICPpwDr6Vl/8rvj+KctqwiRFPIrMLt73XqQsZCsCc4TcFGks7p3fuCv1P9pygt1PXV7UJHZDliG1tRX6itnLX6L6TxLVdlmqtZ8f8CRJmOsyvEvjC6Z/WRXGg2vowdbS6ElHhcTNX2UQuYod3JgFRc28jbVZU4A8tR56KB7ogeeHaPe4w8Qd7pkqBoVH0VjR8D0zkmixcaybgZ8femXLLbyIGm1AU+bJc2XsgD0eKwITJeedEVgYJYmZD+i94PCRNQS53Eglf8rck91IgXHCMSBClfXybDNrAxaFAtM3agTaPVE+VzBbViggU9w7YVc2qFecFPWGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1D8NxdYRIPrcs0rmAvrLjZuuBBgTl9FLH2dLK+Kt83k=;
 b=UFOhYjy1fi6lL09abcrnqZx7Fq2YpDVuAgSedyHayAppPm47l1e0dRfI4wlYM75R0sFJJvpR7Y3/2U2cOHHH/yxmEYcgV6sbe/l6GTibA0yjWaQQisgXA8g2pP2mSW/NTyAb47Gf7VyyljZvB3kAUItiF7GYqbuXpVUbsYpLfQQ=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN6PR11MB4068.namprd11.prod.outlook.com (2603:10b6:405:7c::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Thu, 26 Aug
 2021 03:52:13 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::1508:e154:a267:2cce]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::1508:e154:a267:2cce%5]) with mapi id 15.20.4436.024; Thu, 26 Aug 2021
 03:52:13 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Christoph Hellwig <hch@lst.de>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: RE: [PATCH 12/14] vfio/spapr_tce: reject mediated devices
Thread-Topic: [PATCH 12/14] vfio/spapr_tce: reject mediated devices
Thread-Index: AQHXmc/qwZ8myqC0Xk6vGHCY/MkU8quFJ8lA
Date:   Thu, 26 Aug 2021 03:52:13 +0000
Message-ID: <BN9PR11MB543326B4A45DF7C213715F8B8CC79@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210825161916.50393-1-hch@lst.de>
 <20210825161916.50393-13-hch@lst.de>
In-Reply-To: <20210825161916.50393-13-hch@lst.de>
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
x-ms-office365-filtering-correlation-id: 616aeebb-8d71-44a7-75cf-08d96844e370
x-ms-traffictypediagnostic: BN6PR11MB4068:
x-microsoft-antispam-prvs: <BN6PR11MB406895BA78454DBC635F33728CC79@BN6PR11MB4068.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1060;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TPwusQDBnI14FBqQg68d8FQXr5if7xe3WnDPA6CTjTrq/sv4dcQZ+Qk1U127YNqcEjG5QjlTRSG2g1JlEQe8Vwh4yNfuGVfiZF9Qq/zGkrMF+Gpavu1GeLrQsVFGVvyTZl7qnzO7vDZTILSIcfxAGRRqtLqfduuNdPV98ZYx4ecjHQE4lYEweA0xz7upsmCIRQOojt9WtiHsLstR6h+UHpcJXXk/Owufpt4+YjO4mD24FKFdRflkBpfoNsgoyeFOO1Ri/XTebfhMEvLCdovSwN01/oIYLjskUKBUOgpdvP0JMUI5K0z1ZmVJUTAeqmY5172nkheSXYJzGe3hdmegNv+k6Rou6lkCla6vyNmML9J2xz/GvFCWIYyFFHFfFvJNHHyqIV+YWQQsKLL6BfRUY++aJpSkXLq83dfPapQLhnVS2gc7W30SflZVVUXiKqe28Sv+vpdKBk1BKwqZpkFI+LVlDYllQ9BzKUJR/ob23RfUjujZS0/10vCUPuSitlTT/nvIOrCAOX2NKVJ2lW009ctEvpUps2nQwqbsCZlSaeOPRm8HVinFp9sw9r48GTIYrzUEO7/ENKONTSrT+cwxBGaQzY/tFLddFf5idkShmWZXaKxZJUrc/OPJh4UjJtHvIhhNFu37w50Smu1SQcUuPk/s3ghIWraU3TfgPX54bJfYSqGHK1SF2Y3+sQrJ54pVJMPLwgYx+Q+kKu6tL+LVTQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(136003)(346002)(376002)(39860400002)(52536014)(5660300002)(38070700005)(8676002)(478600001)(38100700002)(83380400001)(2906002)(4326008)(4744005)(186003)(9686003)(7696005)(66476007)(54906003)(66556008)(26005)(6506007)(122000001)(66946007)(110136005)(86362001)(33656002)(76116006)(71200400001)(64756008)(66446008)(8936002)(55016002)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?TiMJ+OBElan3okXHGeqWNIGRuNbbDOyOThJGrs5XkywNzUgygKSnVfER+Fu/?=
 =?us-ascii?Q?wc3ZIYFndD1qNpsr3oOaOOTi8PjPXzZH/Qv0axVBs6L2rZ3O80OTGQapg4Rm?=
 =?us-ascii?Q?+Fx8NeHVsGY9L4NbCRRYYIEd0a1Uoby+hrbMKOMFeQDvAB60HgX8MeuH4pb8?=
 =?us-ascii?Q?879qim5bkoPmUwbV5y6OGbLq4ydT5K8z4h7e8AF7J7RpxjO/fzXNZCZ0CrR1?=
 =?us-ascii?Q?2zQPN2SCkRQMZYoQewyuCZfOS6QjEVjD7ya/tdeWoujlN/nwuubq+guVSr5A?=
 =?us-ascii?Q?OTI98fqb+WChlgHJLphX/kjQhBKStsKljzLs8N8X+tI4djtYE8IMOffmAnRR?=
 =?us-ascii?Q?YHhXa8kS2vcwSloDwSWvE6ViZZU8DNC3AETYGP7lV4+QdAeo8s8CDvnFTKAD?=
 =?us-ascii?Q?u6Et7LW0EbnOuBU4CFa4HrHlQ7h+n7ftFaJp4idVHAQr7JZeIuDov+TvUZWO?=
 =?us-ascii?Q?B3BjFpbPPzuN1FHU/wQ998DAe7tB8s7Ohl6W9xpz+Ri8W4KS88uVHkWhEX+K?=
 =?us-ascii?Q?Zjdi8lz6AJyMsD2+Cfwl4RMUIEBbtWaWHBdI6leBSMHK0SUXDY8AwdUDwWSv?=
 =?us-ascii?Q?hXVU4UHBk+jGSOusZCyM/Vh1ReOJIrckcOyGiN5x00LedhiUgf3p+JUbTqI6?=
 =?us-ascii?Q?rqnFmJv6wewUXQIsyDvU91Mq2f5DnrzPUJcxoN1peX2BSrwxnyXJ6mwdZqtx?=
 =?us-ascii?Q?zrGQDxyOND5u/e5bT47V4Er+aLiisjRwfVZSruAxbfX+Ly4PrCPG9CvuwQg8?=
 =?us-ascii?Q?ExWqHB1TzDIRNQSQpIa/2I5JAPtaHWcCce6m5lTxiXApgy7aZMd2YnsjS1T8?=
 =?us-ascii?Q?1/xe+VlII8A5l+iKzZe0lKCgtpTTfjd3Apvp/tm7jykDpceVso4PnB5lKj0c?=
 =?us-ascii?Q?mbT7jguwXeLa/jlQmAlclPcjdwDKhiPsSc7HSDQP69Ce3Xy6MksOxRu+Jf9J?=
 =?us-ascii?Q?E+vZVMg4M2qDxMP+V1r74U18Yir4XZmDQCOe6KOrSoL95vd7x0nyCDb9OrxZ?=
 =?us-ascii?Q?gCygtZEs+9l1MWozCuTQkJlgEUvKykE1CO3U2WALT9PzcYV1YZdttRH4oFan?=
 =?us-ascii?Q?53rc1V1fR0+nz03uJhE3BG9rbpsrdXD6fJlJpaDA09Hgo2F3cZKWif03rs34?=
 =?us-ascii?Q?D62v21ZyWshh7T/ix5PW9G64yQLFWFEZdXqAZQ/rpxSxxuJPdjtg7HVktAaJ?=
 =?us-ascii?Q?wcBiAev9sIl+EWuxJsEvX1jBj3rSD2AzwMzXKBk94USRE7C1Kwr7WWcCnfaq?=
 =?us-ascii?Q?hQHAIQIVpKeLZrgYzlFA670hk3wX808ozzT3IHe26P80xzxdHii+KWwFTWFa?=
 =?us-ascii?Q?Nx1zHGx+RuVKYnym2+KVNTvy?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 616aeebb-8d71-44a7-75cf-08d96844e370
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2021 03:52:13.1174
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AOkyGuLDMflUQhFeCOrB4tjsJZQUnlTnAvY/TXscav/O/Y63WL/4ZyZgG1zQs/SW5T4Qn6X12HWd/WyKl/81nw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB4068
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Christoph Hellwig <hch@lst.de>
> Sent: Thursday, August 26, 2021 12:19 AM
>=20
> Unlike the the type1 IOMMU backend, the SPAPR one does not contain any
> support for the magic non-IOMMU backed iommu_group used by mediated
> devices, so reject them in ->attach_group.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

> ---
>  drivers/vfio/vfio_iommu_spapr_tce.c | 3 +++
>  1 file changed, 3 insertions(+)
>=20
> diff --git a/drivers/vfio/vfio_iommu_spapr_tce.c
> b/drivers/vfio/vfio_iommu_spapr_tce.c
> index 7567328d347d25..0fbce1bcb6493b 100644
> --- a/drivers/vfio/vfio_iommu_spapr_tce.c
> +++ b/drivers/vfio/vfio_iommu_spapr_tce.c
> @@ -1246,6 +1246,9 @@ static int tce_iommu_attach_group(void
> *iommu_data,
>  	struct iommu_table_group *table_group;
>  	struct tce_iommu_group *tcegrp =3D NULL;
>=20
> +	if (flags & VFIO_EMULATED_IOMMU)
> +		return -EINVAL;
> +
>  	mutex_lock(&container->lock);
>=20
>  	/* pr_debug("tce_vfio: Attaching group #%u to iommu %p\n",
> --
> 2.30.2

