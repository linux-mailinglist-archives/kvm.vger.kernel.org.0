Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC17452E205
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 03:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344520AbiETBeI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 21:34:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232853AbiETBeF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 21:34:05 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08B4B9B190
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 18:34:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653010444; x=1684546444;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=npMZN21YdHup+eH2OOCt4lDHMMDy6hSm+/BBMoZQUg4=;
  b=cjK6+z0oAzxG9gsm82rloNMnSJVcLHIug9pbkvb81yeFgFDhm3hUkLOx
   yCSDEkjcOziZ7G1nqJAcowTXWy7oMkNVzTgzJpUbJrUTZSc/rypwBzjvn
   y9ZhUGBH1Ys7G5vBRQhA5UXHjT2b/daZ/kgivuv1zTiDo57Mr6btf2Lex
   M+OcmSF7eZc5LIx1KVx0AFgor5hXGguUIEaqxmRKBi2VfEPgVLfR9ugTJ
   Z7WIi3Iq03YcwXvWLxiqMhvYvbDoPB/ASA/PggpNd/yQyGEAkXEP7aFoo
   sxva+fnfRHmZMBELJJtXYQq5+ejZeBKxNqzmXGdhEEEWsXhF0w3Le8L1p
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10352"; a="272411346"
X-IronPort-AV: E=Sophos;i="5.91,238,1647327600"; 
   d="scan'208";a="272411346"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2022 18:34:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,238,1647327600"; 
   d="scan'208";a="715284479"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga001.fm.intel.com with ESMTP; 19 May 2022 18:34:03 -0700
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 19 May 2022 18:34:02 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 19 May 2022 18:34:02 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.106)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 19 May 2022 18:34:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gg2olVuSV0PH3GK4toMKXydyDSR8LW9gwWU2SCTaq7ULfVDK1MZV6VfC/Fuo9bpYZpt6Imq3hLRncJsRlLO0PPubeLsBhN4Z3CaXkg/MdTVvXwarCdwdv0uO7p41YdWwWwA6+zKEX3OgO11zdRNCgFNNgUHxrObEzI3VmseTHAoqcfBcm94JxkAVVdn6Q05JuXflcrEdZRJEKfWJ+ZJeBPoAwzmuBmqMlF1zjNuZtJxm9pPZ2MmLxKrQ3v0PoTlL6r6tImpNm0wPqqK+y9CZWkZgoUvpRd5gkL05y2uTkVU7XHX2cofe9LhKvInrkFlysJqWRR0TUUM16qmFAnhoEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8qnWpchhoQAfbuqKj1kMH7E0/IuXqgccSZZTaAk+6CY=;
 b=lqp1gZxJ4Uqv0DAQ3kAYUgGsuIlqnwlj7QUijw8GTffCLa2M/KIzNQBQG84p+9X8ZCKGy4trbhpu53Dq0UEH4TvmkA/yzHPVxIOhtUer6cZ6DkKyl5XrLc/KmuvXOqKFMTtChnOKwUeuER98vUnMZjFcMteZcftB7BW4nC5/eHIQpqPhe5Ld+W+gkLSRyoDUo/NZudXBecql1QUK/XN+rrDTy0bQ2Pl/Z4VttM1ObYJR1maydJtkDhxYQmRX41UpNk1A4ZdeqjywUb1YgIE3InXvZPZGU9TM5hehtIrPpvtBQP4b4bldVvoVv5xiqdry+9FUFD0rzRMbzyLH2UdKRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BL0PR11MB2883.namprd11.prod.outlook.com (2603:10b6:208:7b::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.17; Fri, 20 May
 2022 01:34:00 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::24dd:37c2:3778:1adb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::24dd:37c2:3778:1adb%2]) with mapi id 15.20.5273.017; Fri, 20 May 2022
 01:34:00 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Longfang Liu <liulongfang@huawei.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        "Rodel, Jorg" <jroedel@suse.de>, Yishai Hadas <yishaih@nvidia.com>
Subject: RE: [PATCH] vfio/pci: Add driver_managed_dma to the new vfio_pci
 drivers
Thread-Topic: [PATCH] vfio/pci: Add driver_managed_dma to the new vfio_pci
 drivers
Thread-Index: AQHYa9Yl7i7k7OhXikyt7SW0iYAxQK0m+tYg
Date:   Fri, 20 May 2022 01:34:00 +0000
Message-ID: <BN9PR11MB5276976E9874FC37AF7E4EAA8CD39@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-f9dfa642fab0+2b3-vfio_managed_dma_jgg@nvidia.com>
In-Reply-To: <0-v1-f9dfa642fab0+2b3-vfio_managed_dma_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b1f6b8ce-52d6-4af8-687d-08da3a00d111
x-ms-traffictypediagnostic: BL0PR11MB2883:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BL0PR11MB2883E132F3713FCE0D8A90E58CD39@BL0PR11MB2883.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fnghvxdGNm3ko17svtxCc9IZNtz/4pSOxpe9zPZiv0LQvP9mN63nzbcxQ9XiD5rVH5mhL1W7cTO4oO3VRPFyGTtyOu+7DmFNM5wDq0FNObsN546RdWNq+VaWiUnQNseXHd8KYXGFPz1i4KnlLer3ZDFDYwyykAmh4GRZU1njv5zCqiHG3i/ab1Vuzk6S5g7uarhh/hSzwLF9D/AjGiRSUoYYqUbR0N5vV9JGROsyrMgXI0w0LoOq+lEJJ7km0qAfEt3hFijF7ffVOreC9PdTD69ywSycrVnNnVAjgs5G9WUP9Pnso1WORGBNeRwa/ti4yQNs4SxxBfDTjeeZpuvY6EZvl5xgE1Qa2FmvOrKnw8NCnwCDDx8ijlFaeD44qJIIXt7vqfIA/y3stbgGiSCdGi5IgfJye51FUEpIoXaJ23kjSsfZhErDAf4HQD9yskhuBopxIFF11qBN09OcuOl5liN6PY976QuZBkTn7UM4+rrbkvoz5PDUUf09xY4q5IumSnoVtSevQ2GomzI+pC58B+IBDva/OVjWzTBn0SLaKFPcjrCa5FCU+jw3gq/LlS5TljNEYuwpMayUlbTf2i0pcE9RdbEXaaAsvv0+NJfuq9noD9vNvAn5AFT20cRVyCjm5LptqHzd670Cn0AF+T+qALYQrmGORMKjGL6Q851OppsM4dZJ/HswtoNCnXxjGkCpkYqgJVi3DCWznRttvHbJRw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(83380400001)(82960400001)(38070700005)(55016003)(122000001)(38100700002)(7696005)(6506007)(66446008)(66476007)(9686003)(66556008)(64756008)(110136005)(54906003)(71200400001)(76116006)(66946007)(508600001)(316002)(2906002)(5660300002)(8676002)(26005)(8936002)(52536014)(86362001)(4326008)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Bg6qv+7HcOpQiS4ko6W7wz343DfgCKh0l37p0BtXusKnVlSw/pLFbDSJwuqU?=
 =?us-ascii?Q?3dO/k/0YAvKocYzRCPGRDTkgmzsjKHc3srG/ug9stOgW8MCSAM3Qnf1Jw4FX?=
 =?us-ascii?Q?+WkQ+kaXx34B5pYzuWvrsyZTRJmvLQBnt5DU8VOQOd9rZWIoPGJNZyWAnF1H?=
 =?us-ascii?Q?npDIx76aXM3v357UaV7pcyLXyMfHwBIslz58KdByQv9LIiVU6R7rFmrcD9hH?=
 =?us-ascii?Q?DEd72ihGhLwWYvv0fgKIMmH+fY10crk/wehTHMDvagOAzk3Rzdt52obR9GLh?=
 =?us-ascii?Q?Ctl1OruAzIUve17H+ytvFAGzblkBF9svdKJlHUdq777OLrvfzGPfUttmDkYs?=
 =?us-ascii?Q?/OtVmzH5c3ztep1wJtM68dcsSCU5poZiV6pZesJf5qNnMkinpaDOPT4CN/bn?=
 =?us-ascii?Q?0Tfz8zU7ltl/px9PjtsJ+wGlA3QiGlMzGSQ6saXl835WOcRjESyr/F16CGax?=
 =?us-ascii?Q?CtkRzxaN/GW3w/ZgtjDLbK9nqxqaVMBuIRvfg/rKa5t6xYwNP421WcW6+u0U?=
 =?us-ascii?Q?Sa7IST39e1J7b9VxJp3JsZE8fu7nWcUKp3ZYsNHyxjSBqU/OaoPUYmiPxhal?=
 =?us-ascii?Q?QWXD+vs3I/iPl+sZ73BaHbxZEHIW3eyt2ZXaW4mrYCXSXu7AFQXLsWkJOqUT?=
 =?us-ascii?Q?ThwyPeGT7sQcWklDNPFLwlYzJ6hX0GJkgF0XzO2Ali09F9r2v387DCg1Ac5p?=
 =?us-ascii?Q?P3RS7ZxnNAvCbzcWAfFi1+pv11+uX+++8wq1e8JncQrdZRiPwZ+Oc6OyUl5B?=
 =?us-ascii?Q?ki+w+DZzAG42oepquGbyDaMHv657/ysBaA7jBsiL0gs46mtJjJgiROV2e5fJ?=
 =?us-ascii?Q?FmlC6pkt+P98tCuX5lnZyWshX/rPtm/g/47FXa3ZqNrFU/0d/Z5y3hGWT+g9?=
 =?us-ascii?Q?hXroXKLhEbqk+WCXSvauDAotdpBZyGHEC8PsB2N0TNpwtYe5BglflE3o+6XD?=
 =?us-ascii?Q?sKRsxoQl95ENtaCZ7PIsUT4nEUSIdJ4E6skujIU1GWvw6SXilrLiwX7AaCc/?=
 =?us-ascii?Q?euw10/6GnIsUIAOwERUGJbTvlqEZHQTHxvhLt2GsKwcMEN03D2nd/tikjgT2?=
 =?us-ascii?Q?MJdLPKLbpMhGtQcLyAv38Gj+wXrtjw1udPJY7gmAQE3It6+TshWeL1svV3XX?=
 =?us-ascii?Q?8mBJBSqTUGKO51Qw92rWQiwD6RG2MWm1NPWsNMGvTA0uaGHu0NWO8EdYnc3i?=
 =?us-ascii?Q?Ty/JVMVdKWBMsJDYF/8Z75/YH6q4B9p+cM9zyHAwzRsYE7Jz/mOMjOnolh68?=
 =?us-ascii?Q?Q6Cgd4WtxoQS+5Q35BSp28kmcBQnwcg5hAQmm1FyRkRQtfU3w/OSwCtihTUv?=
 =?us-ascii?Q?FGy1ON7QSBfrgedN2MXv3aiJs1gwCsLhgKe+btKHX1+Yw09MWPwmD275DDa3?=
 =?us-ascii?Q?4fwna7ny2ylmv3louA8ikKdntwO0huU/1NLyG+JyMT5cWmT2rhT8N5rp00KB?=
 =?us-ascii?Q?Eoa2xZIKAyqVoCF8ZVviv8gPrXG43TA9qdJgBTdQOHymnzR3VGHcJhzleIDm?=
 =?us-ascii?Q?23k55i2SG6pjnCnNhbUXD8Op1MJf6/w1+2q0+6tYvv4eCoQTOqGYb8iyu8Xe?=
 =?us-ascii?Q?RBGMoRPNT8JROs/2yFim+izokfKxemH0m58GQcAuBQcAD1LAsVwyzxEgvf+7?=
 =?us-ascii?Q?vMAJ3aBTJM5wycplZeEr4Ij6WsBnWfzs+jlyXjGezgfOpzXbBruqv47LW3Ft?=
 =?us-ascii?Q?thq5kXv2bl/Z121oQXHINNHpm9qcIAQwyFSa1ltwddRkWhO3irOjGuKOu0gf?=
 =?us-ascii?Q?Tuev+PQr8Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1f6b8ce-52d6-4af8-687d-08da3a00d111
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2022 01:34:00.7711
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IUhJ29KSWtkzEaX+cCfA7qn+3qIwuE+TkTtnm9px71nJobl2gQkb7XCqMRs1LMGQpeZdT6f7qez2vbeSoDycow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR11MB2883
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Friday, May 20, 2022 7:14 AM
>=20
> When the iommu series adding driver_managed_dma was rebased it missed
> that
> new VFIO drivers were added and did not update them too.
>=20
> Without this vfio will claim the groups are not viable.
>=20
> Add driver_managed_dma to mlx5 and hisi.
>=20
> Fixes: 70693f470848 ("vfio: Set DMA ownership for VFIO devices")
> Reported-by: Yishai Hadas <yishaih@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

> ---
>  drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 1 +
>  drivers/vfio/pci/mlx5/main.c                   | 1 +
>  2 files changed, 2 insertions(+)
>=20
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> index e92376837b29e6..4def43f5f7b619 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> @@ -1323,6 +1323,7 @@ static struct pci_driver hisi_acc_vfio_pci_driver =
=3D {
>  	.probe =3D hisi_acc_vfio_pci_probe,
>  	.remove =3D hisi_acc_vfio_pci_remove,
>  	.err_handler =3D &hisi_acc_vf_err_handlers,
> +	.driver_managed_dma =3D true,
>  };
>=20
>  module_pci_driver(hisi_acc_vfio_pci_driver);
> diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
> index dd1009b5ff9c82..0558d0649ddb8c 100644
> --- a/drivers/vfio/pci/mlx5/main.c
> +++ b/drivers/vfio/pci/mlx5/main.c
> @@ -641,6 +641,7 @@ static struct pci_driver mlx5vf_pci_driver =3D {
>  	.probe =3D mlx5vf_pci_probe,
>  	.remove =3D mlx5vf_pci_remove,
>  	.err_handler =3D &mlx5vf_err_handlers,
> +	.driver_managed_dma =3D true,
>  };
>=20
>  static void __exit mlx5vf_pci_cleanup(void)
>=20
> base-commit: 9cfc47edbcd46edc6fb65ba00e7f12bacb1aab9c
> --
> 2.36.0

