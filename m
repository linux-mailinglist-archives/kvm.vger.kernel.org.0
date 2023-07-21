Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA7975BCA4
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 05:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbjGUDIA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jul 2023 23:08:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbjGUDH4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jul 2023 23:07:56 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B3D42690;
        Thu, 20 Jul 2023 20:07:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689908873; x=1721444873;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9AnSqjAMxdmSBe2lVM+ejiZT+5x6iLNCdv9XP3XGYqg=;
  b=OCkcIiA43AA6MGVm1KDjvrm6v/DxpF2FChAdGOUrJKeo6V1rC4yJ9eBK
   w10B4B8/oM5jjWvmJcjWul5ur8vOWZHuCeDhj5RQDlaM4iPS5f9YnBvm7
   +oeQBH9YnGD6Yr15M4hV+DcH+R2XIXw5zA4h6xBIqGcJM8gwx/l6I+Aqp
   Koj2EVrrjs+Vu59Szg68jg3pTRUNJzmp4u/3BgvBH/Tm/tLlvrbksiGMG
   I5xTR2C7fiNwCvQQ0QN5atc44IykeaBhn+M81ek4nbtG+0J3CiahNrmQk
   RD70aSsUi3kscJtLV42sTxloENL+4TuHvLapKsqQ9etJaCsWrE7fR4Ars
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="369594518"
X-IronPort-AV: E=Sophos;i="6.01,220,1684825200"; 
   d="scan'208";a="369594518"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2023 20:07:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="971273272"
X-IronPort-AV: E=Sophos;i="6.01,220,1684825200"; 
   d="scan'208";a="971273272"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga006.fm.intel.com with ESMTP; 20 Jul 2023 20:07:51 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 20 Jul 2023 20:07:51 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 20 Jul 2023 20:07:51 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 20 Jul 2023 20:07:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BYu8dBal93eslFo7iuLmMdhm9mAcImv0YUkxQgWHuYia+A5IA+Gl5SSHF0bWnu8u0mYDMGB8qDtG4TmA1jvjtQkwNQP0o/k+wmsgXpxrYa8VSy5VqTy/1+FFtI2lN+MbJwabEia0JdmQ1cb50ivvhhcA+vD6fJ6E//ip78Qa1KyUlR2UcoN//fcO3JEAUR4nJWVyGlkiGrJuM40ArkqYrbneFi0Ydne1BrBXJZ0w0h06vkq8VPVWvHvF1E+3X054m1ZVGr0mVl0EokT6noFNc62TIE+gpQnfj1c0oiL8o/JeoyI0v2ufjHkFoGXsu7b57G9nXoeeG94t8npdduUMKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tVPHiKhMXk75xPQAC8wjhxwQ94+LyfQu91Rll/wR8vg=;
 b=FLTLwo6k6arqWp+Kp/Tpe5Mz8Kf4jT+efx7Rt2nhiK6K7FlH3Ut0kfCVDzWf1TmXQ0TMNSZhJIIyhiF3dS1hH5kXs2pUU9Q78aDyYA4HdK3+T89IG5G7VPp6dY4upLFNqufTnJfcLTPJhVi2qG8Q7dyQDBzByNtKfwI3rEHncEbotA7+wy4g1VHPQaPfBJS6H54MFCLvEAmA7YGI47JtpeQ3P+G7IiDoaQcnzJfpRywP4/c/4BVEV2sM8coe15sOMFGgJiSj3vuxQCeCs9z0lbR7NyDWX7A2nhNN/OxUL5ByXfc1vV6R1n1SbiMsUrOjcyU0S24Ml5845k5wliY3Nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CO1PR11MB4963.namprd11.prod.outlook.com (2603:10b6:303:91::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.24; Fri, 21 Jul
 2023 03:07:48 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::137b:ec82:a88c:8159]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::137b:ec82:a88c:8159%4]) with mapi id 15.20.6609.026; Fri, 21 Jul 2023
 03:07:48 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, Joerg Roedel <joro@8bytes.org>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>
CC:     "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: RE: [PATCH v2 1/2] iommu: Prevent RESV_DIRECT devices from blocking
 domains
Thread-Topic: [PATCH v2 1/2] iommu: Prevent RESV_DIRECT devices from blocking
 domains
Thread-Index: AQHZtUNfAivNXia3ZE+yVYj94mwJ4K/DlO/g
Date:   Fri, 21 Jul 2023 03:07:47 +0000
Message-ID: <BN9PR11MB52768040BD1C88E4EB8001878C3FA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230713043248.41315-1-baolu.lu@linux.intel.com>
 <20230713043248.41315-2-baolu.lu@linux.intel.com>
In-Reply-To: <20230713043248.41315-2-baolu.lu@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CO1PR11MB4963:EE_
x-ms-office365-filtering-correlation-id: e1922c72-75bc-4089-f085-08db8997a964
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5n8cC+bpTm3TLzWXOer1DpC0EtO3LK0P8XbGbuNqm19T3l/qBkpNtIUzLxZy8wOorMAuJ8jRgBP4eUa2zR99hKnBgE0wu5XKfT6Hp414yocfRHydeWUqErKuHXaUSBrvczkgDRMFkXgrNO14e65ZCFbttGDiA5vxa22xWQvO2zyt7l1wjaCDsVb0xa4mlK8F49QP9g1cmL+nmgm7SW+MKqoGJgr84xG+z4xH8V4DOR/o2VYF2qU22QuRo+iYgYOsIluv15vLdobUL1kTo238Jp0qL3a2cQB/kpk6QgvSP+czPh/tmz0u+gM5eouzWKvfFccdZHxBKcc0lG9YLcV7RVl8qXlkBvwq2gjUv7qT4UcQwvuIrpTmpvFEee0hD/dHMOk2Rj5GsLEUIOhm1zOKBROAcNHHU9qaWKqDsRMoRNPi/rhc3NFI4LxOpHPOetvCUMh8AY/DzBKGdKnm6jPP/jwsXL1R5z7wcTbBjoWPnxAD+OsjjNTiV31GCFfkylxAW55dyJX+LJNbnMyPL+Xmjxpne6l+gQ1xkT2UAV/NQWey43BXrAzTku0KeZ+A8DdjbUWqEKU5ef1a+q8iI4krx+OlTCa7oxd6t265B2+isip4FVQvnK6TUzow4OOjRyGw
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(396003)(39860400002)(346002)(376002)(451199021)(55016003)(26005)(186003)(6506007)(83380400001)(4326008)(71200400001)(5660300002)(52536014)(8676002)(8936002)(66946007)(316002)(66476007)(64756008)(76116006)(7416002)(66446008)(54906003)(66556008)(41300700001)(110136005)(9686003)(2906002)(478600001)(7696005)(122000001)(33656002)(82960400001)(38070700005)(86362001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XFu0UO9Mx5yl9Q8OJyinCOLUZTsq6m8y9yVkHcdSaI9m4Prww7qm7sSFxIcg?=
 =?us-ascii?Q?okXVyAIEMTkPLU1nFZ5rD6UWx6bgULvu6KpIFGjJpeo1ck5HEO+weWXRKE74?=
 =?us-ascii?Q?9gX+3ex28McSJ6EDYcp9bPHbcmXwcsVPvJnvhDjLzOWo+rswFDymKx+BDRS1?=
 =?us-ascii?Q?0UQxW0kUhz6s5ALQ7Xpw+I5I9D6ELsqfybv4gxYZlD+8HRBbV4NkAPHn7LvY?=
 =?us-ascii?Q?vuYa2K4ah45MmrhB9OXtko+0iERVKLHqGiW/y4OmyYf2zveU8/ZUyMeKynod?=
 =?us-ascii?Q?KLo+BGoeLc2e0n5iTQwGFsDibQmpQRUd0QbmNBAVDkiHtMUgD5CW80weBCFe?=
 =?us-ascii?Q?aHErc3rlZ3P2ErZ+2eqLl/Q3YzKX7b10kapikkIvvpBiJwR+MJdYvdLwXhcX?=
 =?us-ascii?Q?SdErnJkgRJHX7ECRYf75EvuL1nn1qiAHWzfPJkheWkc5C/gKevaLOOGLPeZr?=
 =?us-ascii?Q?0bv2uDOrvjAcyuCyTq+WOfuR1dsiZN7I2C5zx8Qj+Y7L8uv73EAvH+9D73OE?=
 =?us-ascii?Q?tHIUsEzmaSKb6EiI/nzvb5FBOQEWao5niXW52AqQNfIMf+F+4rAsWdo3Hex9?=
 =?us-ascii?Q?MpDBMEW6KPdwr/9NoLPJDidMmG0TtcvSOeStbI7Z6wIZXEVBavDDjDC3oLZZ?=
 =?us-ascii?Q?wNIROlLLEwEGRUHtIGp/T0QWvYOvCdeNh+AUaZuRhtGE98Kr34zYsQOq1jJU?=
 =?us-ascii?Q?b0YInIss/MnvfCfywjFey+8ZxS3WMEOFK7LNj7plhvRLz3OUb57XZp27VuGc?=
 =?us-ascii?Q?1bYECVaZZDHJxMJLXxKxK/jilqsHs7/KnzjDKpvkZE0Ohk80OPkT0qsIqkcO?=
 =?us-ascii?Q?ymZo6h9Zhp9IcBVhT0XwyrhtwWbUbhAlI/BaBsgkseGkQIz8VLvJTNkzqqE4?=
 =?us-ascii?Q?y0N9v2Qj+XsVfLmIQ2y6AUpUkG4b4aiKyX9s4h5fpHPet9uONsTpKlwuxBDv?=
 =?us-ascii?Q?BFFXNNEUiSwA+p4/S3Yt/Sr5pF/NaSwUUmvpOxBq1M27DNT+ACHUR2HXbBhc?=
 =?us-ascii?Q?/Xa/hnxgdDjtE67lLf17iYacNocEn8FDjUXaeaudV3Uv950zhUQ8IWTYyQnO?=
 =?us-ascii?Q?TkB/hhTuTRov9wysCCnV44QNTplJIB2PozsxRknp4fevWd6YtNlZNxpyZiPs?=
 =?us-ascii?Q?DUHH+sCgrl1+EA9qYsPmGqula/mMPxOOlAOdk2rCh9MZPWE8IrO9w62gdEX2?=
 =?us-ascii?Q?kHOZsG8ttXbzNH0/1eUH0V7D1FXzkZ1Rm9n6qVzP1VDhW5LKTQO7W7vXoMxl?=
 =?us-ascii?Q?epe+JMH7RLQHscPVKp5pAMMmCG2Cox3nAcGjfuVfkD4Dstnwo4XsT1Lhro85?=
 =?us-ascii?Q?jhJJQ4BcVnSX6/23IJdrU7pYisrhyjDrbet1QoXVVA5KXcWFTTOMED8+jNhS?=
 =?us-ascii?Q?hu7HiiPMk1W9K6UYk2a4Qy7lANjdnkgBIIAyVPfMl6WYJqGM1dy61ROMhBEt?=
 =?us-ascii?Q?mP9I/sYY6qs25Zg8g5kDo4CB6FHe2hZjcIWsBOEotJ0BGw8vOIm6c70f9+Oo?=
 =?us-ascii?Q?3NCmcBCKeeJRh93uRR7nI+mv9Tc0GcumZ7LOVTOrS45v3BKJyg5/95Dn0qZK?=
 =?us-ascii?Q?WeeJTIRXDAajQRbWPUok85KE+Rw0L/JAHWUkAF9U?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1922c72-75bc-4089-f085-08db8997a964
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2023 03:07:47.7528
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FRn/m2OrRigMbgcNnREuIk5i1e5me8yQ+rA8ucxD88Y59E50oMdKRFXIRoYG9qGi9A5AKKAVhiFrxChQ8laD3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4963
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Lu Baolu <baolu.lu@linux.intel.com>
> Sent: Thursday, July 13, 2023 12:33 PM
>=20
> @@ -409,6 +409,7 @@ struct iommu_fault_param {
>   * @priv:	 IOMMU Driver private data
>   * @max_pasids:  number of PASIDs this device can consume
>   * @attach_deferred: the dma domain attachment is deferred
> + * @requires_direct: The driver requested IOMMU_RESV_DIRECT

it's not accurate to say "driver requested" as it's a device attribute.

s/requires_direct/require_direct/

what about "has_resv_direct"?

> @@ -959,14 +959,12 @@ static int
> iommu_create_device_direct_mappings(struct iommu_domain *domain,
>  	unsigned long pg_size;
>  	int ret =3D 0;
>=20
> -	if (!iommu_is_dma_domain(domain))
> -		return 0;
> -
> -	BUG_ON(!domain->pgsize_bitmap);
> -
> -	pg_size =3D 1UL << __ffs(domain->pgsize_bitmap);
> +	pg_size =3D domain->pgsize_bitmap ? 1UL << __ffs(domain-
> >pgsize_bitmap) : 0;
>  	INIT_LIST_HEAD(&mappings);
>=20
> +	if (WARN_ON_ONCE(iommu_is_dma_domain(domain) && !pg_size))
> +		return -EINVAL;
> +
>  	iommu_get_resv_regions(dev, &mappings);
>=20
>  	/* We need to consider overlapping regions for different devices */
> @@ -974,13 +972,17 @@ static int
> iommu_create_device_direct_mappings(struct iommu_domain *domain,
>  		dma_addr_t start, end, addr;
>  		size_t map_size =3D 0;
>=20
> +		if (entry->type =3D=3D IOMMU_RESV_DIRECT)
> +			dev->iommu->requires_direct =3D 1;
> +
> +		if ((entry->type !=3D IOMMU_RESV_DIRECT &&
> +		     entry->type !=3D IOMMU_RESV_DIRECT_RELAXABLE) ||
> +		    !iommu_is_dma_domain(domain))
> +			continue;
> +
>  		start =3D ALIGN(entry->start, pg_size);
>  		end   =3D ALIGN(entry->start + entry->length, pg_size);
>=20
> -		if (entry->type !=3D IOMMU_RESV_DIRECT &&
> -		    entry->type !=3D IOMMU_RESV_DIRECT_RELAXABLE)
> -			continue;
> -
>  		for (addr =3D start; addr <=3D end; addr +=3D pg_size) {
>  			phys_addr_t phys_addr;
>=20

piggybacking a device attribute detection in a function which tries to
populate domain mappings is a bit confusing.

Does it work better to introduce a new function to detect this attribute
and has it directly called in the probe path?=20

> @@ -2121,6 +2123,21 @@ static int __iommu_device_set_domain(struct
> iommu_group *group,
>  {
>  	int ret;
>=20
> +	/*
> +	 * If the driver has requested IOMMU_RESV_DIRECT then we cannot

ditto. It's not requested by the driver.

> allow
> +	 * the blocking domain to be attached as it does not contain the
> +	 * required 1:1 mapping. This test effectively exclusive the device

s/exclusive/excludes/

