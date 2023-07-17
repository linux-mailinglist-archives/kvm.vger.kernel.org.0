Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D51C9755BCF
	for <lists+kvm@lfdr.de>; Mon, 17 Jul 2023 08:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbjGQGgz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jul 2023 02:36:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbjGQGgy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jul 2023 02:36:54 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D17D411F;
        Sun, 16 Jul 2023 23:36:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689575812; x=1721111812;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bY18qCPsufMD/SYh8dDUbXyJnhUo8RxDLy8XJ3GM06Q=;
  b=B1QvPGlAq8NtQiuVnBhi5P44nTofdKiW0kJrDMVSwiiBRll+PgY3yRvP
   xWHF2opHvJrMXHcsYoXs1XjI1eC0WC/TOu/xQR86KD6KH5LFiD4dy6bNI
   AXHx16AgjEDsVU+lV9SiHryJiE5pAKfU0+gqKaKKL+B/Lrhau3G/Jbe9u
   QLDTC+xB45geCmY8kTXFakDTeRBRca3rhgqnZGMeI0iM1LOV5vPrVE7ME
   XO3sxAcV5dSd/d5Iv0XoXMvU5u2XQjrRNrPnhPyk3ZvzV2BUV1Ixkan8s
   eyx+1M0D9cy8fgzOZ7+Td/5PBdZEmM51vKIByY+urj2OXHkJE1u3vdSMD
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10773"; a="364730499"
X-IronPort-AV: E=Sophos;i="6.01,211,1684825200"; 
   d="scan'208";a="364730499"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2023 23:36:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10773"; a="793129085"
X-IronPort-AV: E=Sophos;i="6.01,211,1684825200"; 
   d="scan'208";a="793129085"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga004.fm.intel.com with ESMTP; 16 Jul 2023 23:36:22 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Sun, 16 Jul 2023 23:36:22 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Sun, 16 Jul 2023 23:36:22 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.48) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Sun, 16 Jul 2023 23:36:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KyZ+7NfI0fop7qo8FDYvrsjuY9Et414/bYfvUhjh2jvnNmVHai2OP7XhbWKD02emj0DPMz9sLxkb1+akvfJ0wk8ooKMy00V1N2eQMOn/pbt6nnxP+e/19irukOvCUpHlQBJgDYvsGXnUf1GIKldmRCjSanHfj+IadZDE36VNV/h9Ca3MnBzchmjJK/DAEEjarBYxPd+/aUpSyED6vKlz/+UoemYL5AhAP3SmGQ9GmDd2fhmzax6T86oVVHo0SbfioMI/g0sOBWJgBfsQesmaCdpJkz6IYc6S0zgwpElgW9Zd44IxTa9FJvOMiHkBLvTJZExTDxYOEJNExM+Tiqljhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9oejxg9cYJyVw65rNCkKdr7+2tDhOywFUqxPknZ54Rk=;
 b=JpgCw2LtWIubKg8msB9j+0wX+yV8Ya3HQ95r2vqmVoSKLsBcboOl430gFEp6+RU/PjhZ5Z9XXFZYTNAlbbwLfkvxnadwPTagdaVzvsouo5JJ6sQ6RKNtkdME/CKrnUv6pguOGQV9RO9g34PMK344hoDw0jirxpsRhMAYQBf71nI4kXdXPKECZNWPgULC0Pv9qBMluaFn+RCSdrV4zhi8YOa+wQjsfxI9jutCgNs+AjX7nuiBkb22evIQ3QlXCrhHhee+YXh8OYHo/p7LhVrsu79apiOLnzsDjiymzlqvZ90/FYlZn4PpNxBQ9AatZLv7nlkHZmvIC633/OrzeDR6PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CH3PR11MB7676.namprd11.prod.outlook.com (2603:10b6:610:127::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.31; Mon, 17 Jul
 2023 06:36:20 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::806a:6364:af2:1aea]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::806a:6364:af2:1aea%7]) with mapi id 15.20.6588.031; Mon, 17 Jul 2023
 06:36:20 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        "clegoate@redhat.com" <clegoate@redhat.com>
Subject: RE: [PATCH v13 21/22] vfio: Compile vfio_group infrastructure
 optionally
Thread-Topic: [PATCH v13 21/22] vfio: Compile vfio_group infrastructure
 optionally
Thread-Index: AQHZoDagsdh+fCMUvkyHLuzt/JVGpq+9qlBw
Date:   Mon, 17 Jul 2023 06:36:19 +0000
Message-ID: <DS0PR11MB7529C571419F1DB629AB7E92C33BA@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230616093946.68711-1-yi.l.liu@intel.com>
 <20230616093946.68711-22-yi.l.liu@intel.com>
In-Reply-To: <20230616093946.68711-22-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|CH3PR11MB7676:EE_
x-ms-office365-filtering-correlation-id: 4fa999b0-8f61-4fcd-846e-08db8690218d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aXpZidTeW2SpEdo+U+yYRrSNZAX06znUzhOeYJ72F5tMVLtZlvtCuhw/rcibJeRdbAFpYBLYh4hmi5nPCTYGUTOsZBCw5VNfQGy09ePICh7x5KbtjMGjWCti7Ph/fuWtIh7rQGCAnUQeh8WyeDE4dKHJMiesDBawr3UMVMgtvH46Cll+KITnREmqRu3qp0Ie83CqFBlfTDVQIDTUsgcwXKaL4mkHCTO10O+5/V+wXoAT8aMOHNlLwtlxHLlzoI2+zlzJdkLo25nHM2Yr2oyL28YEey+VkG5rx5LWik0ZLCG+IxVb3+DsvMBmrplSeE3IyXSbLXDjvFv8O60UuvRPWNeUlykpb9pP7zWtjLFFOFwiSkHQ+5WjiXdZus1TWOeL4jyN0P87QcsWuHQ6xN9P2I7/BhBJy8MqRj8G1qvOC9wFOq0DtvLPj2XpD3Is0VF/NbAQcrHIXS7RPuEPBd9eO263QlSw3Ur5qC+ZchYsHqvxjgtadlzOCTkQEj08OWvoDjwq8U2fZhoBnUWIWeS7Pr5p7yFvT0AwMwcGVpocGCAt4Qrwpjf2eXzEu0OdXUXVs97ZRr6AZTQdw3kURWLp7Y3MTVYB113n0lgan3CsBLfE/boZpPTNG/75feA4WWcA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(376002)(346002)(396003)(136003)(366004)(451199021)(55016003)(54906003)(110136005)(478600001)(6506007)(26005)(186003)(71200400001)(7696005)(83380400001)(9686003)(5660300002)(86362001)(38100700002)(7416002)(8676002)(52536014)(8936002)(82960400001)(41300700001)(316002)(6636002)(4326008)(2906002)(38070700005)(122000001)(76116006)(66556008)(64756008)(66946007)(33656002)(66476007)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?gBQnRkAwF1T+rDxBLPisJR9NIUXlXzdcntOaRYZvhrAphSnsVVSwPLyiXU71?=
 =?us-ascii?Q?2QzII6Vwl0AqdddewsnOlalvPvSSRnf7bP/dEqUIz+M/b/dNXeuW+dNOplHV?=
 =?us-ascii?Q?nOVxmyn9cxyt8CF829tubml6V40Q7SjUvaPwwkvTiEHOsc8Y2Xr/OGJzOgy9?=
 =?us-ascii?Q?0D/9hJZ3jWWnFAHvoxBCZLTAnc1RVUoznm8VGWKq5VhV6fR6xWg8CFD3kxq7?=
 =?us-ascii?Q?5SY2ILDaZkQdaRBSGKFyGigww7j9jFu4Ka01r/dFB0MtvtCpSyR1Ml7hrMgH?=
 =?us-ascii?Q?tvxNkAoYhR5dheHiNTxQYQScLM+rjnFHD7DdXYSTiHNk1icnfthu8Lt0aj2C?=
 =?us-ascii?Q?gh4Lf+en39EAQ+dijSmk3Hh5A1rNZMuJ5QZ/yg2AllE5hmG3y4kHr+0ORwdy?=
 =?us-ascii?Q?l1PmHkeTCQz+QqChMCsIhjDekcCdtmMwoXWFy2y+eTqOYS/yZNTUphmCnQxE?=
 =?us-ascii?Q?QZ2V4HEMV1maw7KYf+jcM3RjaBZDcPyhvFgRxm7xipAqLVoqwemJznZ2DFDG?=
 =?us-ascii?Q?rR5ueFqkYgQ92SfbHuoaxTUCU37wD5HkeKPNxBXxnh7C+qjjxQPaPdzgPmxN?=
 =?us-ascii?Q?iAHHcBfcmgUbjF/EPLKLwPXyPejegRj1pEVVpMtYwUC1feI0VMxjcqc6eBML?=
 =?us-ascii?Q?Z7p2ikWkfyn2qAEbMIF9B4za/tk2EYGpHrwp181SyWHErhT6mRXEwfZrYNih?=
 =?us-ascii?Q?sAYVF1ccSMZUaEGxmrH/QKDSOkExQQakEUd+5kmun5p1L1CE3I7g2t8sQKkR?=
 =?us-ascii?Q?dlQIStzlunfvd1IUhyjd/w71zBTnL9CLNIFY+eSfNHx4XuYMxfC7XAEZN+gB?=
 =?us-ascii?Q?JGiocDU8+A4g++GufQyVfHsYyaaIttutTGfBalzk31kxNF6Cq3OuxbTBOQnL?=
 =?us-ascii?Q?7oKyPfn3qWY/xu4VkMVZHgfrGMGpwlx2RSf+JFXBQfzhAg3wsqDuCLRWaP54?=
 =?us-ascii?Q?Wg7JayrMVOzZcmbMgfpH4IkGZC8LP0F/y0aPB14tUH0IvTD80Ko23FgKZJry?=
 =?us-ascii?Q?ObJ4BJclDJltLPmmqf00lJZO07EpLioYlztquTVSoK95zlb25BF0j2fkq287?=
 =?us-ascii?Q?TJhGbjwVQqsAyltNGICH3e6Y5T+dyHg5CV8vsRBNVGYFq5Pu1wq9a31+cPvU?=
 =?us-ascii?Q?hFtWefcPBXdqJ6xGsU3kqVDRScSTghzXDQlDVFc/Wtl786W0VANbhxteV/L2?=
 =?us-ascii?Q?t07sB0dLfAo2zsdKZddYa4MGnz3/+fT+aprdVGBP/qfAjXBMpJFrmCggQxvA?=
 =?us-ascii?Q?OwTNsFw9S+hUf0HevAE8Apd/IDQi4zZjq9XGT965Ecrz/+6Vzv754Xjs4Dzh?=
 =?us-ascii?Q?8P2IaWpa6yratTwNfczV3SKcdIcMSi7fSRaUDLdki3EwFpd9Ke8I4aoDAfJB?=
 =?us-ascii?Q?KUs+9b3pNrGd3CwYtyJfCG0f2/BO9rKQmUzy95SIPULGbzi3F9T3B1AjlLdP?=
 =?us-ascii?Q?lK4Eac2sQa3vuP4RCGQULxBYd4KJDICGtvG/yk2CWzU9OLRcxnxDUv06Z7Bz?=
 =?us-ascii?Q?lc8h5E+CTR9FKRAoOTmSCT0iWi9d7uA6qhtoxhwafFMC0fSKdRvX2+6YXd2c?=
 =?us-ascii?Q?xTph0pnVw2qqy6N37fjaVkbDws5maEcfkANkQtXX?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fa999b0-8f61-4fcd-846e-08db8690218d
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jul 2023 06:36:19.9012
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: af4ZHCMsqzj7FWQVsG3LLQ57pavgujOC5xJp2R14Lnw5vDguy1lUgTcfOxrg+0rzku/gmPwq6nrMKHRxrLL3GQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7676
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Friday, June 16, 2023 5:40 PM
>=20
> vfio_group is not needed for vfio device cdev, so with vfio device cdev
> introduced, the vfio_group infrastructures can be compiled out if only
> cdev is needed.
>=20
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
> Tested-by: Yanting Jiang <yanting.jiang@intel.com>
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Tested-by: Terrence Xu <terrence.xu@intel.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/iommu/iommufd/Kconfig |  4 +-
>  drivers/vfio/Kconfig          | 15 ++++++
>  drivers/vfio/Makefile         |  2 +-
>  drivers/vfio/vfio.h           | 89 ++++++++++++++++++++++++++++++++---
>  include/linux/vfio.h          | 25 ++++++++--
>  5 files changed, 123 insertions(+), 12 deletions(-)
>=20
> diff --git a/drivers/iommu/iommufd/Kconfig b/drivers/iommu/iommufd/Kconfi=
g
> index ada693ea51a7..99d4b075df49 100644
> --- a/drivers/iommu/iommufd/Kconfig
> +++ b/drivers/iommu/iommufd/Kconfig
> @@ -14,8 +14,8 @@ config IOMMUFD
>  if IOMMUFD
>  config IOMMUFD_VFIO_CONTAINER
>  	bool "IOMMUFD provides the VFIO container /dev/vfio/vfio"
> -	depends on VFIO && !VFIO_CONTAINER
> -	default VFIO && !VFIO_CONTAINER
> +	depends on VFIO_GROUP && !VFIO_CONTAINER
> +	default VFIO_GROUP && !VFIO_CONTAINER

Hi Alex, Jason,

I found a minor nit on the kconfig. The below configuration is valid.
But user cannot use vfio directly as there is no /dev/vfio/vfio. Although
user can open /dev/iommu instead. This is not good.

CONFIG_IOMMUFD=3Dy
CONFIG_VFIO_DEVICE_CDEv=3Dn
CONFIG_VFIO_GROUP=3Dy
CONFIG_VFIO_CONTAINER=3Dn
CONFIG_IOMMUFD_VFIO_CONTAINER=3Dn

So need to have the below change. I'll incorporate this change in
this series after your ack.

diff --git a/drivers/iommu/iommufd/Kconfig b/drivers/iommu/iommufd/Kconfig
index 99d4b075df49..d675c96c2bbb 100644
--- a/drivers/iommu/iommufd/Kconfig
+++ b/drivers/iommu/iommufd/Kconfig
@@ -14,8 +14,8 @@ config IOMMUFD
 if IOMMUFD
 config IOMMUFD_VFIO_CONTAINER
 	bool "IOMMUFD provides the VFIO container /dev/vfio/vfio"
-	depends on VFIO_GROUP && !VFIO_CONTAINER
-	default VFIO_GROUP && !VFIO_CONTAINER
+	depends on VFIO_GROUP
+	default n
 	help
 	  IOMMUFD will provide /dev/vfio/vfio instead of VFIO. This relies on
 	  IOMMUFD providing compatibility emulation to give the same ioctls.
diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
index 6bda6dbb4878..ee3bbad6beb8 100644
--- a/drivers/vfio/Kconfig
+++ b/drivers/vfio/Kconfig
@@ -6,7 +6,7 @@ menuconfig VFIO
 	select INTERVAL_TREE
 	select VFIO_GROUP if SPAPR_TCE_IOMMU || IOMMUFD=3Dn
 	select VFIO_DEVICE_CDEV if !VFIO_GROUP
-	select VFIO_CONTAINER if IOMMUFD=3Dn
+	select VFIO_CONTAINER if IOMMUFD_VFIO_CONTAINER=3Dn
 	help
 	  VFIO provides a framework for secure userspace device drivers.
 	  See Documentation/driver-api/vfio.rst for more details.

>  	help
>  	  IOMMUFD will provide /dev/vfio/vfio instead of VFIO. This relies on
>  	  IOMMUFD providing compatibility emulation to give the same ioctls.
> diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
> index 1cab8e4729de..35ab8ab87688 100644
> --- a/drivers/vfio/Kconfig
> +++ b/drivers/vfio/Kconfig
> @@ -4,6 +4,8 @@ menuconfig VFIO
>  	select IOMMU_API
>  	depends on IOMMUFD || !IOMMUFD
>  	select INTERVAL_TREE
> +	select VFIO_GROUP if SPAPR_TCE_IOMMU || IOMMUFD=3Dn
> +	select VFIO_DEVICE_CDEV if !VFIO_GROUP
>  	select VFIO_CONTAINER if IOMMUFD=3Dn

This should be " select VFIO_CONTAINER if IOMMUFD_VFIO_CONTAINER=3Dn"

Regards,
Yi Liu

>  	help
>  	  VFIO provides a framework for secure userspace device drivers.
> @@ -15,6 +17,7 @@ if VFIO
>  config VFIO_DEVICE_CDEV
>  	bool "Support for the VFIO cdev /dev/vfio/devices/vfioX"
>  	depends on IOMMUFD
> +	default !VFIO_GROUP
>  	help
>  	  The VFIO device cdev is another way for userspace to get device
>  	  access. Userspace gets device fd by opening device cdev under
> @@ -24,9 +27,20 @@ config VFIO_DEVICE_CDEV
>=20
>  	  If you don't know what to do here, say N.
>=20
> +config VFIO_GROUP
> +	bool "Support for the VFIO group /dev/vfio/$group_id"
> +	default y
> +	help
> +	   VFIO group support provides the traditional model for accessing
> +	   devices through VFIO and is used by the majority of userspace
> +	   applications and drivers making use of VFIO.
> +
> +	   If you don't know what to do here, say Y.
> +
>  config VFIO_CONTAINER
>  	bool "Support for the VFIO container /dev/vfio/vfio"
>  	select VFIO_IOMMU_TYPE1 if MMU && (X86 || S390 || ARM || ARM64)
> +	depends on VFIO_GROUP
>  	default y
>  	help
>  	  The VFIO container is the classic interface to VFIO for establishing
> @@ -48,6 +62,7 @@ endif
>=20
>  config VFIO_NOIOMMU
>  	bool "VFIO No-IOMMU support"
> +	depends on VFIO_GROUP
>  	help
>  	  VFIO is built on the ability to isolate devices using the IOMMU.
>  	  Only with an IOMMU can userspace access to DMA capable devices be
> diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
> index 245394aeb94b..57c3515af606 100644
> --- a/drivers/vfio/Makefile
> +++ b/drivers/vfio/Makefile
> @@ -2,9 +2,9 @@
>  obj-$(CONFIG_VFIO) +=3D vfio.o
>=20
>  vfio-y +=3D vfio_main.o \
> -	  group.o \
>  	  iova_bitmap.o
>  vfio-$(CONFIG_VFIO_DEVICE_CDEV) +=3D device_cdev.o
> +vfio-$(CONFIG_VFIO_GROUP) +=3D group.o
>  vfio-$(CONFIG_IOMMUFD) +=3D iommufd.o
>  vfio-$(CONFIG_VFIO_CONTAINER) +=3D container.o
>  vfio-$(CONFIG_VFIO_VIRQFD) +=3D virqfd.o
> diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> index e7a3fe093362..b27a3915e6c9 100644
> --- a/drivers/vfio/vfio.h
> +++ b/drivers/vfio/vfio.h
> @@ -36,6 +36,12 @@ vfio_allocate_device_file(struct vfio_device *device);
>=20
>  extern const struct file_operations vfio_device_fops;
>=20
> +#ifdef CONFIG_VFIO_NOIOMMU
> +extern bool vfio_noiommu __read_mostly;
> +#else
> +enum { vfio_noiommu =3D false };
> +#endif
> +
>  enum vfio_group_type {
>  	/*
>  	 * Physical device with IOMMU backing.
> @@ -60,6 +66,7 @@ enum vfio_group_type {
>  	VFIO_NO_IOMMU,
>  };
>=20
> +#if IS_ENABLED(CONFIG_VFIO_GROUP)
>  struct vfio_group {
>  	struct device 			dev;
>  	struct cdev			cdev;
> @@ -111,6 +118,82 @@ static inline bool vfio_device_is_noiommu(struct vfi=
o_device
> *vdev)
>  	return IS_ENABLED(CONFIG_VFIO_NOIOMMU) &&
>  	       vdev->group->type =3D=3D VFIO_NO_IOMMU;
>  }
> +#else
> +struct vfio_group;
> +
> +static inline int vfio_device_block_group(struct vfio_device *device)
> +{
> +	return 0;
> +}
> +
> +static inline void vfio_device_unblock_group(struct vfio_device *device)
> +{
> +}
> +
> +static inline int vfio_device_set_group(struct vfio_device *device,
> +					enum vfio_group_type type)
> +{
> +	return 0;
> +}
> +
> +static inline void vfio_device_remove_group(struct vfio_device *device)
> +{
> +}
> +
> +static inline void vfio_device_group_register(struct vfio_device *device=
)
> +{
> +}
> +
> +static inline void vfio_device_group_unregister(struct vfio_device *devi=
ce)
> +{
> +}
> +
> +static inline int vfio_device_group_use_iommu(struct vfio_device *device=
)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
> +static inline void vfio_device_group_unuse_iommu(struct vfio_device *dev=
ice)
> +{
> +}
> +
> +static inline void vfio_df_group_close(struct vfio_device_file *df)
> +{
> +}
> +
> +static inline struct vfio_group *vfio_group_from_file(struct file *file)
> +{
> +	return NULL;
> +}
> +
> +static inline bool vfio_group_enforced_coherent(struct vfio_group *group=
)
> +{
> +	return true;
> +}
> +
> +static inline void vfio_group_set_kvm(struct vfio_group *group, struct k=
vm *kvm)
> +{
> +}
> +
> +static inline bool vfio_device_has_container(struct vfio_device *device)
> +{
> +	return false;
> +}
> +
> +static inline int __init vfio_group_init(void)
> +{
> +	return 0;
> +}
> +
> +static inline void vfio_group_cleanup(void)
> +{
> +}
> +
> +static inline bool vfio_device_is_noiommu(struct vfio_device *vdev)
> +{
> +	return false;
> +}
> +#endif /* CONFIG_VFIO_GROUP */
>=20
>  #if IS_ENABLED(CONFIG_VFIO_CONTAINER)
>  /**
> @@ -362,12 +445,6 @@ static inline void vfio_virqfd_exit(void)
>  }
>  #endif
>=20
> -#ifdef CONFIG_VFIO_NOIOMMU
> -extern bool vfio_noiommu __read_mostly;
> -#else
> -enum { vfio_noiommu =3D false };
> -#endif
> -
>  #ifdef CONFIG_HAVE_KVM
>  void _vfio_device_get_kvm_safe(struct vfio_device *device, struct kvm *k=
vm);
>  void vfio_device_put_kvm(struct vfio_device *device);
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index d6228c839c44..5a1dee983f17 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -43,7 +43,11 @@ struct vfio_device {
>  	 */
>  	const struct vfio_migration_ops *mig_ops;
>  	const struct vfio_log_ops *log_ops;
> +#if IS_ENABLED(CONFIG_VFIO_GROUP)
>  	struct vfio_group *group;
> +	struct list_head group_next;
> +	struct list_head iommu_entry;
> +#endif
>  	struct vfio_device_set *dev_set;
>  	struct list_head dev_set_list;
>  	unsigned int migration_flags;
> @@ -58,8 +62,6 @@ struct vfio_device {
>  	refcount_t refcount;	/* user count on registered device*/
>  	unsigned int open_count;
>  	struct completion comp;
> -	struct list_head group_next;
> -	struct list_head iommu_entry;
>  	struct iommufd_access *iommufd_access;
>  	void (*put_kvm)(struct kvm *kvm);
>  #if IS_ENABLED(CONFIG_IOMMUFD)
> @@ -284,12 +286,29 @@ int vfio_mig_get_next_state(struct vfio_device *dev=
ice,
>  /*
>   * External user API
>   */
> +#if IS_ENABLED(CONFIG_VFIO_GROUP)
>  struct iommu_group *vfio_file_iommu_group(struct file *file);
>  bool vfio_file_is_group(struct file *file);
> +bool vfio_file_has_dev(struct file *file, struct vfio_device *device);
> +#else
> +static inline struct iommu_group *vfio_file_iommu_group(struct file *fil=
e)
> +{
> +	return NULL;
> +}
> +
> +static inline bool vfio_file_is_group(struct file *file)
> +{
> +	return false;
> +}
> +
> +static inline bool vfio_file_has_dev(struct file *file, struct vfio_devi=
ce *device)
> +{
> +	return false;
> +}
> +#endif
>  bool vfio_file_is_valid(struct file *file);
>  bool vfio_file_enforced_coherent(struct file *file);
>  void vfio_file_set_kvm(struct file *file, struct kvm *kvm);
> -bool vfio_file_has_dev(struct file *file, struct vfio_device *device);
>=20
>  #define VFIO_PIN_PAGES_MAX_ENTRIES	(PAGE_SIZE/sizeof(unsigned long))
>=20
> --
> 2.34.1

