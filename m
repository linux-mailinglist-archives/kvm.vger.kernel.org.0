Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7E6A5093AE
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 01:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355667AbiDTXnD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 19:43:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230418AbiDTXmd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 19:42:33 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38D2B3969C
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 16:39:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650497985; x=1682033985;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qM/Pxgj+YsoxY0GU2OfqChdSckT+Fzd+GOQi6BMc0mc=;
  b=L7+Cxkpotma9lULzQ4HddGn7HFLV9W7TI/T9MR/fySazZd3ABvJkdgbd
   mpdliq5JLpCQoi4Ay0YMyguH1oaXqiygd1/rhOsjOrY0ez4IC0iRZ3jUc
   G8mht4hQGmgFrKNyoT88YaNHZYXRUOcrR46yUUDLanbXUrjlktGMoqFDm
   q9nvurriTKj0Ivr8puDgB1sTrigBl3yf93327u/AZPx1d+wcf4lAaLZXZ
   TM4xhSP+FPTrT2yjOUNOKSEeClbXNb1YSVj1sLIQT3YNAoquWtiXrbNPX
   eZoRDt/zPw8x5ToXPbdm0ZGH3ap4/pndqkKJ8imGuQeylwjZBEtRf6ryT
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10323"; a="261781104"
X-IronPort-AV: E=Sophos;i="5.90,277,1643702400"; 
   d="scan'208";a="261781104"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2022 16:39:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,277,1643702400"; 
   d="scan'208";a="555450837"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga007.jf.intel.com with ESMTP; 20 Apr 2022 16:39:44 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 20 Apr 2022 16:39:43 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 20 Apr 2022 16:39:43 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.102)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 20 Apr 2022 16:38:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oO160WWnLB9vlIvVcme7VcGDSrn/ioT/e7A7Niok+7zsS/zmMbCyMi1AtbjjmzMV2/ZXruMRZqmUB0q2hj2MflN88J1JJV01zpWDXwLd6/kAZlLs7WUnAfXv/hbZkGaQ9vlS6t05gM6iwMUOVmb7Ic5hyFdrZdURzdq3sO49y4Odk5M1fMCLfaICMiMbyVGGlJXjNHfx7FnNZWWszbYI1aptyQbxhy6o2Cs67jmwjWwhdShKgkP6BVfmAuwb+9ao/BK652ssu7fU7dGQNKpXsRuJXERp7/STHFaIBPAtH4f98Ht+pc1I/OZK2Sb+WygTvqBemUs3DhFHgcqWVTs/UQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vfOfGmiqrNMfmQQgfmstx3KQ3qzqKg2lNCOXXl/sJus=;
 b=UgQ8fPRaDxJigxbiH3G+g/SHc2IZ3pYLJ2ixVJBxEMFzlTnhAdVJwGVFrZXAMfql+YoIkkSF6rnn8/92s7e0mlsDJ/XE65lVUfYrkdawsFBOV+o+Zq0a9ECCCSl6xuUvO/8E17GgpoRAJnNtdChOqgDXoB9MiXVZjbLHD3tbfjDiX7B1WT36tjvOaNz6/SN+anhMwGuPBSnwEWjTMSSYEPh3y/zeKwOdwrmDe67+7LHxdtm1ujJmuxZ6tCje2z7HM+CPY2gtcj4RFtGCO1dBS6ijUqZIVUa32wg5345xLLGojj1386zJP3yuWRc9RUJ/Z/4N5US6auLMORa7JA2sQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5271.namprd11.prod.outlook.com (2603:10b6:208:31a::21)
 by BN6PR11MB0036.namprd11.prod.outlook.com (2603:10b6:405:68::38) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Wed, 20 Apr
 2022 23:38:55 +0000
Received: from BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::3114:d1ec:335e:d303]) by BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::3114:d1ec:335e:d303%3]) with mapi id 15.20.5186.013; Wed, 20 Apr 2022
 23:38:55 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     Eric Auger <eric.auger@redhat.com>, Christoph Hellwig <hch@lst.de>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: RE: [PATCH v2 3/8] vfio: Change vfio_external_user_iommu_id() to
 vfio_file_iommu_group()
Thread-Topic: [PATCH v2 3/8] vfio: Change vfio_external_user_iommu_id() to
 vfio_file_iommu_group()
Thread-Index: AQHYVOwjUo+VH7T9MUai6UyihVeR9qz5daig
Date:   Wed, 20 Apr 2022 23:38:55 +0000
Message-ID: <BL1PR11MB52712103324BE35F9D08DCCD8CF59@BL1PR11MB5271.namprd11.prod.outlook.com>
References: <0-v2-6a528653a750+1578a-vfio_kvm_no_group_jgg@nvidia.com>
 <3-v2-6a528653a750+1578a-vfio_kvm_no_group_jgg@nvidia.com>
In-Reply-To: <3-v2-6a528653a750+1578a-vfio_kvm_no_group_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c44e636f-ddc2-43ae-43fb-08da2326ef1e
x-ms-traffictypediagnostic: BN6PR11MB0036:EE_
x-microsoft-antispam-prvs: <BN6PR11MB0036A116D6231ADE50FD54BE8CF59@BN6PR11MB0036.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FAkoKGhy/kHt02Z7CJvUOdpx1aepv1SOHL1wkQHVedeuO+CW02P1h11fMC0PKtKOJUWLN555fY8kU9f2pR47NTPZTe+DJWG9BmciZp66zBW2M+zFVBDg3zGtu6hvkQCujfu5AKGuRtoX07zGr2IeCIXgB2CRo/JJWRuOAySOqjowRJPZ4PI0VRTEqHe28ymK0UDR9eSPnmsTiH0vfDFDyXuix7fr3OrnjDCoIkAdhWuiNPqumYCGcnw/2nRuro+ZqkadCeSOb1BunfzaeGw/uIP73pYn3jwyrLotu8bUIxFmXC/t09tmV4sHjj00XGP3hBxASg22grtdcF5Db2U+3WdG4i9FbiuDQWj7D37KtKNQouTGnSpewykWSHuU6sHloMIoozBxicT65xV6zp/VaaSrPtCjC1u9fsRnYh+Ga+DzXGbDJCJoGWxeDXHBFT7qhHd5vlF353SPIQqUqAZgM8iCW75iPbx4YYJiXV7k2OM1LSMZ/oa1nxqni0VtRFgHMoXXbzwanLb9jugNb9iavgM5KAj1aXP4cNSA1R8UVWpmbYT8uc7PILjmTy9inrHl4iq8daK+J2jOBxLGdH85pRMMazDGsaiuWWZgH61G2x4ZeMz6Ffd/LhYa1folJ50WmciJpqmiZjsdrUJcstwGMeTKS1+vY4O3/Arzs0T6qZc6PLeLH2Qw0Re+D2wt74i2a207OZXWqXei+XcdHcPTwQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5271.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(55016003)(86362001)(508600001)(316002)(8936002)(8676002)(38070700005)(26005)(54906003)(9686003)(6506007)(71200400001)(82960400001)(2906002)(7696005)(38100700002)(66446008)(66476007)(52536014)(110136005)(66946007)(76116006)(122000001)(66556008)(33656002)(64756008)(83380400001)(5660300002)(4326008)(107886003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4ixz9u9ylzlW8koTPTZPvs+czt1EPMD0+THyxTL/4GamlekBqLWe1kx8l9rt?=
 =?us-ascii?Q?2uL7QA26XZFeSeRZMzEzRZUl5l8WgvMYozxz84YCCN/AzwExIlRECZxNSey7?=
 =?us-ascii?Q?qBfGyI8fR1V7YWySCKkFdW5GcxQUMjRsVNJ+o4XY/2tnlf3XjhEqXBDQGwe3?=
 =?us-ascii?Q?H2f54NxoYGzHA4QpEaOw22sq2KrlVG/fvEMrIYxRvfoxryqzlyNRpJ1uq1OY?=
 =?us-ascii?Q?obOKNyO/M5ndxIclelWLjqpZaNKYcC9csmKdCeuX2MBAwzSfSX6I6QniWejm?=
 =?us-ascii?Q?n3WOCUraO3OFkMK/xWWZrbocFySi74yufJiQBF76ZEm2kzjtMvMNnFrsVwWA?=
 =?us-ascii?Q?mixg6b6re+9KTS3qeMA3wmceaEPyLDbT6ZWwsJFROYJjYt7TqseCeQbfwkAY?=
 =?us-ascii?Q?D9s5fJUGs6Gpl86FHaFVhAXQmsnzFq29ccARq6zftTLFLvbDhhDGEu2pdG8m?=
 =?us-ascii?Q?MOfD97rz092gkeQCP7O9+o26CguGRMf8/eN2+yYzQotk9nvY0kBLzha5pyTD?=
 =?us-ascii?Q?I7tG6V/tG2DBF2UT+qtQq9cl94E69448A18HV7iFlDE0302TEviixOZ+qzLQ?=
 =?us-ascii?Q?R7uMyUS8yDHXF+N0sM7O2VuXF/1ykG61pvORWrgO4ZSN2jncaqLRoiqa4Qwx?=
 =?us-ascii?Q?TShXHvlPTfEpf30FEjeY41UPY74KN9hy6y27T/smnhT/V2bf0i9RSdaHgQja?=
 =?us-ascii?Q?xs0sIYr4+mfpSBXkmE8MjbWr7a//YZKeIFJ2km9EUUQM3sUFlLmst4ZQsUeL?=
 =?us-ascii?Q?RemAyUFAPDsJnzjkoFfjKS1OMLdrKCqAH6TikRef4LASW5hlccNBf2u3kDgx?=
 =?us-ascii?Q?lOzFW0pnyGDqMZZ1lr4Kx1gEAF8jWOFVT+3NGhiG6EyJPfQroZ3YC6xfFTj5?=
 =?us-ascii?Q?TH6LCmoF44DqB4mAXhX25i9TuLnPuNMMa+OKcNlL2EUIAmrutM5DMe3xcDzf?=
 =?us-ascii?Q?/ktZvX/psYv6fmL2UQ8duDsl1Xse5F5t3oMQ4ySdCibFLUjodygfMKnLLLjS?=
 =?us-ascii?Q?8r29iKYGFEaZvJH3KanH4p+NX2MQttavVGCrprCpGNCercPudISMx5ZBarmJ?=
 =?us-ascii?Q?L/cQGAQDjS8sx/LwwkBf7sKiVdoivW60Hf8RfpoD00ZJBmXkB/HQfmyeAwFX?=
 =?us-ascii?Q?4eow1Mi35hn8Q9xbizU+cGPn5H05XSwFm1PByYsV72xfySXk86Y1RFrcKYRD?=
 =?us-ascii?Q?JMeI6rnaCDDsmRd6VuHLCNJRmA8WEYDsQGpf7+iVcECe7krBHCBFPlIWeXR/?=
 =?us-ascii?Q?6yuPQ+k5Y0Tu1WojM1esttz6ns9QIWf0K7pX21ZnmS5RKPGMrQ3i9FZMg2/j?=
 =?us-ascii?Q?XBQbdw1iVgS25w2MqegcnebFfXffQVLQBtFDV3FaeMBiugifKHADG/OxsB9G?=
 =?us-ascii?Q?MBSFXO0KZH+U+BzXWeRa2TSY7Y0mK0/RrI1fPyf2EQ4SWV/GsUTmGH5V7QNN?=
 =?us-ascii?Q?dRgQCT11vI3UUeiIVQv2mS5KbHcE056DVH3P5PNJqECgRLHp5ve6wghoTidl?=
 =?us-ascii?Q?K2XJDOGVjiO5hDyG+5YHJTwAw7PuQzN0bvsUTtBxbzztaNxaNCTV6vA+Hx/y?=
 =?us-ascii?Q?rcl3bkyYTCFMyu26LWQejxOTgcJ2BNzYg7aRrF+vHBjWxT/RCqk0GpDMDNNF?=
 =?us-ascii?Q?qMy79+Wl46yKJSBx/uULVtIitarlWcIsY2SK38pNyD40sJx41I+iuMvHcU1Z?=
 =?us-ascii?Q?KRTRZ9YGU0kz5oUM+bjwcWTNDv9Hc9nPQpJg7nppbT3LxYP/koWTkBK+di2K?=
 =?us-ascii?Q?Z19egFDvpw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5271.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c44e636f-ddc2-43ae-43fb-08da2326ef1e
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2022 23:38:55.3658
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CwceWUe3QxczoO0Hgg+47ynNZIgA1iWFg/JuLT+kQPA/mvONAZsfvySCY0tg8cVoGJo9Ss0S0eWCXVWHhKdBag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB0036
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, April 21, 2022 3:23 AM
>=20
> The only user wants to get a pointer to the struct iommu_group associated
> with the VFIO group file being used. Instead of returning the group ID
> then searching sysfs for that string just directly return the iommu_group
> pointer already held by the vfio_group struct.
>=20
> It already has a safe lifetime due to the struct file kref, the vfio_grou=
p
> and thus the iommu_group cannot be destroyed while the group file is open=
.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

> ---
>  drivers/vfio/vfio.c  | 21 ++++++++++++++-------
>  include/linux/vfio.h |  2 +-
>  virt/kvm/vfio.c      | 37 ++++++++++++-------------------------
>  3 files changed, 27 insertions(+), 33 deletions(-)
>=20
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index a4555014bd1e72..3444d36714e933 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -1919,10 +1919,7 @@ static const struct file_operations
> vfio_device_fops =3D {
>   * increments the container user counter to prevent
>   * the VFIO group from disposal before KVM exits.
>   *
> - * 3. The external user calls vfio_external_user_iommu_id()
> - * to know an IOMMU ID.
> - *
> - * 4. When the external KVM finishes, it calls
> + * 3. When the external KVM finishes, it calls
>   * vfio_group_put_external_user() to release the VFIO group.
>   * This call decrements the container user counter.
>   */
> @@ -2001,11 +1998,21 @@ bool vfio_external_group_match_file(struct
> vfio_group *test_group,
>  }
>  EXPORT_SYMBOL_GPL(vfio_external_group_match_file);
>=20
> -int vfio_external_user_iommu_id(struct vfio_group *group)
> +/**
> + * vfio_file_iommu_group - Return the struct iommu_group for the vfio
> group file
> + * @file: VFIO group file
> + *
> + * The returned iommu_group is valid as long as a ref is held on the fil=
e.
> + */
> +struct iommu_group *vfio_file_iommu_group(struct file *file)
>  {
> -	return iommu_group_id(group->iommu_group);
> +	struct vfio_group *group =3D file->private_data;
> +
> +	if (file->f_op !=3D &vfio_group_fops)
> +		return NULL;
> +	return group->iommu_group;
>  }
> -EXPORT_SYMBOL_GPL(vfio_external_user_iommu_id);
> +EXPORT_SYMBOL_GPL(vfio_file_iommu_group);
>=20
>  long vfio_external_check_extension(struct vfio_group *group, unsigned lo=
ng
> arg)
>  {
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 66dda06ec42d1b..8b53fd9920d24a 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -144,7 +144,7 @@ extern struct vfio_group
> *vfio_group_get_external_user_from_dev(struct device
>  								*dev);
>  extern bool vfio_external_group_match_file(struct vfio_group *group,
>  					   struct file *filep);
> -extern int vfio_external_user_iommu_id(struct vfio_group *group);
> +extern struct iommu_group *vfio_file_iommu_group(struct file *file);
>  extern long vfio_external_check_extension(struct vfio_group *group,
>  					  unsigned long arg);
>=20
> diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
> index 07ee54a62b560d..1655d3aebd16b4 100644
> --- a/virt/kvm/vfio.c
> +++ b/virt/kvm/vfio.c
> @@ -108,43 +108,31 @@ static bool kvm_vfio_group_is_coherent(struct
> vfio_group *vfio_group)
>  }
>=20
>  #ifdef CONFIG_SPAPR_TCE_IOMMU
> -static int kvm_vfio_external_user_iommu_id(struct vfio_group *vfio_group=
)
> +static struct iommu_group *kvm_vfio_file_iommu_group(struct file *file)
>  {
> -	int (*fn)(struct vfio_group *);
> -	int ret =3D -EINVAL;
> +	struct iommu_group *(*fn)(struct file *file);
> +	struct iommu_group *ret;
>=20
> -	fn =3D symbol_get(vfio_external_user_iommu_id);
> +	fn =3D symbol_get(vfio_file_iommu_group);
>  	if (!fn)
> -		return ret;
> +		return NULL;
>=20
> -	ret =3D fn(vfio_group);
> +	ret =3D fn(file);
>=20
> -	symbol_put(vfio_external_user_iommu_id);
> +	symbol_put(vfio_file_iommu_group);
>=20
>  	return ret;
>  }
>=20
> -static struct iommu_group *kvm_vfio_group_get_iommu_group(
> -		struct vfio_group *group)
> -{
> -	int group_id =3D kvm_vfio_external_user_iommu_id(group);
> -
> -	if (group_id < 0)
> -		return NULL;
> -
> -	return iommu_group_get_by_id(group_id);
> -}
> -
>  static void kvm_spapr_tce_release_vfio_group(struct kvm *kvm,
> -		struct vfio_group *vfio_group)
> +					     struct kvm_vfio_group *kvg)
>  {
> -	struct iommu_group *grp =3D
> kvm_vfio_group_get_iommu_group(vfio_group);
> +	struct iommu_group *grp =3D kvm_vfio_file_iommu_group(kvg->file);
>=20
>  	if (WARN_ON_ONCE(!grp))
>  		return;
>=20
>  	kvm_spapr_tce_release_iommu_group(kvm, grp);
> -	iommu_group_put(grp);
>  }
>  #endif
>=20
> @@ -258,7 +246,7 @@ static int kvm_vfio_group_del(struct kvm_device
> *dev, unsigned int fd)
>  		list_del(&kvg->node);
>  		kvm_arch_end_assignment(dev->kvm);
>  #ifdef CONFIG_SPAPR_TCE_IOMMU
> -		kvm_spapr_tce_release_vfio_group(dev->kvm, kvg-
> >vfio_group);
> +		kvm_spapr_tce_release_vfio_group(dev->kvm, kvg);
>  #endif
>  		kvm_vfio_group_set_kvm(kvg->vfio_group, NULL);
>  		kvm_vfio_group_put_external_user(kvg->vfio_group);
> @@ -304,7 +292,7 @@ static int kvm_vfio_group_set_spapr_tce(struct
> kvm_device *dev,
>  		if (kvg->file !=3D f.file)
>  			continue;
>=20
> -		grp =3D kvm_vfio_group_get_iommu_group(kvg->vfio_group);
> +		grp =3D kvm_vfio_file_iommu_group(kvg->file);
>  		if (WARN_ON_ONCE(!grp)) {
>  			ret =3D -EIO;
>  			goto err_fdput;
> @@ -312,7 +300,6 @@ static int kvm_vfio_group_set_spapr_tce(struct
> kvm_device *dev,
>=20
>  		ret =3D kvm_spapr_tce_attach_iommu_group(dev->kvm,
> param.tablefd,
>  						       grp);
> -		iommu_group_put(grp);
>  		break;
>  	}
>=20
> @@ -386,7 +373,7 @@ static void kvm_vfio_destroy(struct kvm_device *dev)
>=20
>  	list_for_each_entry_safe(kvg, tmp, &kv->group_list, node) {
>  #ifdef CONFIG_SPAPR_TCE_IOMMU
> -		kvm_spapr_tce_release_vfio_group(dev->kvm, kvg-
> >vfio_group);
> +		kvm_spapr_tce_release_vfio_group(dev->kvm, kvg);
>  #endif
>  		kvm_vfio_group_set_kvm(kvg->vfio_group, NULL);
>  		kvm_vfio_group_put_external_user(kvg->vfio_group);
> --
> 2.36.0

