Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2F7554444F
	for <lists+kvm@lfdr.de>; Thu,  9 Jun 2022 08:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239077AbiFIGzb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jun 2022 02:55:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238803AbiFIGz3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jun 2022 02:55:29 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5409E19F074;
        Wed,  8 Jun 2022 23:55:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654757728; x=1686293728;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gOdZ1LLVW+E/CSBdvxyAu1YBtgwrcMPboXiDj9lc1iQ=;
  b=VQy6emf8EhePYvPwTgynQzHwDGuGW2MxbH14/SJ9595jUrKdiEgxneO7
   ThhPwuTdO6SAl+IGdsxuKI+0ViHvyZwP/nGZc9476ZVgv6wUvVZqeipVi
   aGDFmmgCybG5nUoe6f9t9RsjSoIkLRyIxY0G/ngko5tMUtfz9k6ZJUaWF
   F1E5Xk6toE+MjeSiJcE3s7Bvnp5ngcm0/fMywsYAL4nadsmb/06FkZXGD
   2YRgjoo5eAhKNr6egIwEGI2hG/8dgE9fetNWFhzhh4LXE+x6FXth639C2
   2zLJ56EGgXRzpkBpr2HNvIYg2A+hYYWGW6aCbg2wNuVj9cb0rKSAN8i6K
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10372"; a="341258204"
X-IronPort-AV: E=Sophos;i="5.91,287,1647327600"; 
   d="scan'208";a="341258204"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2022 23:55:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,287,1647327600"; 
   d="scan'208";a="759876569"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by orsmga005.jf.intel.com with ESMTP; 08 Jun 2022 23:55:27 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 8 Jun 2022 23:55:27 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 8 Jun 2022 23:55:26 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 8 Jun 2022 23:55:26 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.47) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 8 Jun 2022 23:55:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HzwcL3lIZ/ZQ5/yPOUuryJaoAl69g1LBh+ClLW0SuaxalNmP9gG0kH7ZigKiDnfWZmsSOx9p+G0WQfMNgIOi8QqnPT3rU2OQ0f3WsxoBI73YtcG0V4mAHxXxBveTOQNWBQZB5I1n9Q+ZiDzBexaDeq0uEp6j8oRvjWA8tst+LNhX0nihL8BYQ04wfpEYw0RBPhB/rb2wH7WCJhao6fW1AmEP9LFyc+T2CLwcAw6esBA6Sgn81+BD8peuXKBXNPH+N2EceqfxHGYqXSvHlZ86ogfF1+o89P7hjf23Prp0xLG8mbjRjRih4yFr9c98XVPXDAa/WDm63WAJ9XO3pSWSIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AC43vfo0tKtsFyD+fAK2fkBn2V7DIDG0Yv8aOMKvjnY=;
 b=X0AdNU0qe20UDJb19g9jq7qprFe/mRwxresjy4SVQW97bBMfqWgX4YTUgK0PdF+wKUCzdHQ2zG7k29rZlDQp8541xmVDY6AkG4fDTVabT6hFbfV1RAZjTtFhj/wsx27ad9BX1fVcb9xqaQzQBvU7j1H1BluWKM8YzpliOHywGzLns8YAyNNHVUrEBi+TKnjrED20YSJMr2cZnkO+5PFYjvbhYgiHKlHu1oiAN4sx4iMD/pgKOTd8MUcGzR4xOL/6wnbRIrN2LZCi8GNoj3BwTarAsZ4Or90WNUvd3x+i1j9whO5hRppo5OV67JicN9ST7EKAJndgPVBZxTbCPOJjng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM6PR11MB3340.namprd11.prod.outlook.com (2603:10b6:5:56::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.17; Thu, 9 Jun
 2022 06:55:25 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::3583:afc6:2732:74b8]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::3583:afc6:2732:74b8%4]) with mapi id 15.20.5332.013; Thu, 9 Jun 2022
 06:55:25 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Christoph Hellwig <hch@lst.de>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "Alex Williamson" <alex.williamson@redhat.com>
CC:     "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH 4/8] vfio/mdev: remove mdev_{create,remove}_sysfs_files
Thread-Topic: [PATCH 4/8] vfio/mdev: remove mdev_{create,remove}_sysfs_files
Thread-Index: AQHYdxP3EHWIPgfjskeBuSIsQFMXga1GrYLg
Date:   Thu, 9 Jun 2022 06:55:25 +0000
Message-ID: <BN9PR11MB5276CBADC0CDF8DA68B0716C8CA79@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220603063328.3715-1-hch@lst.de>
 <20220603063328.3715-5-hch@lst.de>
In-Reply-To: <20220603063328.3715-5-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 40a29c7c-0f54-4889-2521-08da49e507b4
x-ms-traffictypediagnostic: DM6PR11MB3340:EE_
x-microsoft-antispam-prvs: <DM6PR11MB33401498508E79331E5DCEE08CA79@DM6PR11MB3340.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IqFa1KWH6U5ddDxKa1G450ulPvIOAFdPUV79BpLV4gk5WztLGYlMb/hYFxJg2sjWYO78oeGfUji6L8lktledD7lxR5T/qtYHqszo8mB9c9+qz31mpYWyWt4QIThQQdWWKEUo+RK1aa9lW/nJwtHAptZaZCdMRl2pyWV7GHm6KwPRiO2PDJ8rvTgAWcEIGK244PPBXboDGjnePqkAsvZBe4DsQE1Yl3h8BfAqWikmEobJH9BkSVB4h9VcP+F/OVfG/SFVbxQ8Wb6Rlum6YzFXDik6jaDzHDPMr7/baqXOy5NLrCaZRm8C78zvi7GXEwks9UGzhD+Eij7vZc4k8joh9n21sCk8V8K2LWHGQ6ZnCpBGVfGRdgyRblQGm2scPIuXax6e7m5tGUwou3RUJnb2QRPTypETcGm2gzhBKOmxseGsbnMlNLEimJEScRfwMHCWEIapU13I6Bg8tOmpm8vqZuw3JTuwNMg/+Uid5cQR6+ScW7JW2yIZiudX5hKLxkzxrvGBbiIEm83ovKts77KjmxohtLpb57KJJpRFKBFgVRbJ4UGKiqvxWbNC2quuanrEzrIWdy8KeB447MVOdHjGlzVEGgQgM/2CJRcSu1ZdTU9g0MZe5pjh8XU96aygtdZ7RbA+H/CVtLmhvlbbkHsrQgBuvz8Sj/jEcYscy2wLsIjL1eN1IDZF2Id3j5xGRRmAHxuqX/nSdfGgm7XYnPneb9EWrdEZaj03OOf+8Q7Y4oc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(921005)(38070700005)(8936002)(110136005)(83380400001)(9686003)(186003)(71200400001)(2906002)(316002)(6506007)(33656002)(508600001)(66946007)(122000001)(54906003)(38100700002)(66476007)(66446008)(64756008)(55016003)(76116006)(4326008)(7696005)(8676002)(7416002)(26005)(82960400001)(5660300002)(52536014)(86362001)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?93Tp428fokBaNZqgRrqgEbabYnT46TlgeEPrIgeA+anzVZi4qVozYiTvmnvb?=
 =?us-ascii?Q?9B3p/HWEgyp/v6HVXyodv6AnaxvCSq3QhYL7EUIJ24Q1zXOCJDCGXj2HmYWs?=
 =?us-ascii?Q?zGyOI2jUwGzzhmIydkj6pZE5V3gf04F4H5Z4gfwAlfS+xA+DCTJsYB744eEA?=
 =?us-ascii?Q?Nh2IfJE81j0/1voQmf/mTX6qt7qLilkWTBe27Z9WBivlaoLbSlu7+K9Ubo3z?=
 =?us-ascii?Q?PO19etlKAgViYiHCgB+G0H4qCE52Ne5DMHG60bpRod8xCbWkaG17N1aLRUV0?=
 =?us-ascii?Q?UpJR6fBm0T670m6xFYNAj9rNh2SvJ+yug06Jb1VccWAe1MVcR+n6O3g6Kx+3?=
 =?us-ascii?Q?x2M8EL2nVVeSEyV0VICtYAMLeFnLpBRTDv+pacsT+6ByowckTEhIS8FPwixH?=
 =?us-ascii?Q?0dAyEbU78fTRglWb5RgHUi+7BGvwqTSKdtPZYZtz02kmjykIKpP4R/NVCkvy?=
 =?us-ascii?Q?JtA8RxAfSeldPZh+ZElvmMAPj4Iz6c9Zi6k96oHk7mEucFvvXjiFC85RMTab?=
 =?us-ascii?Q?fhtuyw0dJvQOsgk0XAaC1Px8pDmDbKeuKPn7Fwe7lHRcNkk9Tykw7gtRS5Go?=
 =?us-ascii?Q?sT9Mz792XWtFaNG4uRWmP9vEsVDoRFmq8+xvLoThMw6gn5UPOOn69G0JdeC0?=
 =?us-ascii?Q?TbiNSrTkoEyZ+JS+lyFG9ay1rwDtvvYpZmydcGJrwCbgkYdvloDYXLNv7xA4?=
 =?us-ascii?Q?QRGO+y91ADObBaS6h6gIe8QjcWC4VurJxnTToLs9ILGzL3lev1m6bNteuNWY?=
 =?us-ascii?Q?fcKxs915tsocAibWf7Ju8eF/Miz3E2p0GmxM1C1TfZzRPkf8wD6b/vZ4wjeK?=
 =?us-ascii?Q?Qi9ZbuoP9J/6dWusCquyWPK7cv09Jk8fA7Tw1H5oYPk5O5H3GMUcVe8UUeew?=
 =?us-ascii?Q?idh6HoIdv8JXg1XRE8g8v121CMbvmeAM2128SZ3oRF4OK1jNXzxM++0n6lFF?=
 =?us-ascii?Q?Ar782Yp1lxO4sdGo+QieqkP6bwu8An/3Rf+Gd3Vt2bxBYobiwPlWcFqQdcG5?=
 =?us-ascii?Q?6JLijdjzdW0u/oavP2jF7ZU4RGgkJKtQJbYoQqE8vkXrIi32/qiDuMlMjXMj?=
 =?us-ascii?Q?rFQE2H37Tt9TcK4N3tGuFo5HGj30te/2fKYdNOk9FOOerT7yXO2WUunivEaX?=
 =?us-ascii?Q?BtMYXPk/YjQZk0GDl4KjUOkHgMoMUtrmTHsWuqh+bnjzOdXHNWFUAOAcHxT/?=
 =?us-ascii?Q?IuXMiLrwq2/ix6QbCo9TrDL8vb/Dr5R8OX9G9o4I0+lETYcs/vJOqLPDBDGx?=
 =?us-ascii?Q?khtnLSMQ+1W7sj4m+MmgNiDokfdtTcIVegRSPVqrAJ6U0RQE9dnTQ20ImJEo?=
 =?us-ascii?Q?4wns2vyz7eKyllbHoLmF3+cy57T6AARQ/9jfS+q1TbDryTyvQSYmQGpiT/v/?=
 =?us-ascii?Q?1lX8bM7E2ikFKlPyg7QdmNfZlS106MBUvkvGyOrSGyK5NlxCYq6Vm9QmyrL/?=
 =?us-ascii?Q?MG8Qh11mZ6ypwrfndH/5nmDkMDo2SPhbFXgldkLrVPChp0IYwjMmvO1WN4KF?=
 =?us-ascii?Q?Pfh6djZirHhXCEWXkKh2xQrYTRk0RTFncvT/GVe4rGixBAupxdBinEqb1+JH?=
 =?us-ascii?Q?Zl6bZGG0Mc/Q/LwBnK3no6Egzqhd4UK+sLNECrvHH2g4dW15Alxxs+QrgSS3?=
 =?us-ascii?Q?zOU/5XJjvi1aa/D3C0PpT69bY13sFed4hBwtLRSMEolWwwEVL3jJvL0TmFqb?=
 =?us-ascii?Q?NczOxan8GKbgusqb/AuNyewLH/GBT0MQjeZk2aSQ3rAvCo1TZ6glhE8QK69x?=
 =?us-ascii?Q?JY5Nl3dJ6g=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40a29c7c-0f54-4889-2521-08da49e507b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jun 2022 06:55:25.1619
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4LUH62bahl4oS9Tf0UXQ7evxihUqoPIJJnyEgDHm+7wAntQBGEpb6iaDztvuGlpLFQqVu0ALnGiSn9j/udHbZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3340
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Christoph Hellwig
> Sent: Friday, June 3, 2022 2:33 PM
>=20
> Just fold these two trivial helpers into their only callers.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

> ---
>  drivers/vfio/mdev/mdev_core.c    | 12 ++++++++++--
>  drivers/vfio/mdev/mdev_private.h |  3 ---
>  drivers/vfio/mdev/mdev_sysfs.c   | 28 ----------------------------
>  3 files changed, 10 insertions(+), 33 deletions(-)
>=20
> diff --git a/drivers/vfio/mdev/mdev_core.c
> b/drivers/vfio/mdev/mdev_core.c
> index ff38c9549a55e..34b01d45cfe9f 100644
> --- a/drivers/vfio/mdev/mdev_core.c
> +++ b/drivers/vfio/mdev/mdev_core.c
> @@ -46,7 +46,8 @@ static void mdev_device_remove_common(struct
> mdev_device *mdev)
>  {
>  	struct mdev_parent *parent =3D mdev->type->parent;
>=20
> -	mdev_remove_sysfs_files(mdev);
> +	sysfs_remove_link(&mdev->dev.kobj, "mdev_type");
> +	sysfs_remove_link(mdev->type->devices_kobj, dev_name(&mdev-
> >dev));
>  	device_del(&mdev->dev);
>  	lockdep_assert_held(&parent->unreg_sem);
>  	/* Balances with device_initialize() */
> @@ -193,16 +194,23 @@ int mdev_device_create(struct mdev_type *type,
> const guid_t *uuid)
>  	if (ret)
>  		goto out_del;
>=20
> -	ret =3D mdev_create_sysfs_files(mdev);
> +	ret =3D sysfs_create_link(type->devices_kobj, &mdev->dev.kobj,
> +				dev_name(&mdev->dev));
>  	if (ret)
>  		goto out_del;
>=20
> +	ret =3D sysfs_create_link(&mdev->dev.kobj, &type->kobj, "mdev_type");
> +	if (ret)
> +		goto out_remove_type_link;
> +
>  	mdev->active =3D true;
>  	dev_dbg(&mdev->dev, "MDEV: created\n");
>  	up_read(&parent->unreg_sem);
>=20
>  	return 0;
>=20
> +out_remove_type_link:
> +	sysfs_remove_link(mdev->type->devices_kobj, dev_name(&mdev-
> >dev));
>  out_del:
>  	device_del(&mdev->dev);
>  out_unlock:
> diff --git a/drivers/vfio/mdev/mdev_private.h
> b/drivers/vfio/mdev/mdev_private.h
> index 476cc0379ede0..277819f1ebed8 100644
> --- a/drivers/vfio/mdev/mdev_private.h
> +++ b/drivers/vfio/mdev/mdev_private.h
> @@ -20,9 +20,6 @@ extern const struct attribute_group
> *mdev_device_groups[];
>  #define to_mdev_type(_kobj)		\
>  	container_of(_kobj, struct mdev_type, kobj)
>=20
> -int  mdev_create_sysfs_files(struct mdev_device *mdev);
> -void mdev_remove_sysfs_files(struct mdev_device *mdev);
> -
>  int mdev_device_create(struct mdev_type *kobj, const guid_t *uuid);
>  int  mdev_device_remove(struct mdev_device *dev);
>=20
> diff --git a/drivers/vfio/mdev/mdev_sysfs.c
> b/drivers/vfio/mdev/mdev_sysfs.c
> index fb058755d85b8..b6bc623487f06 100644
> --- a/drivers/vfio/mdev/mdev_sysfs.c
> +++ b/drivers/vfio/mdev/mdev_sysfs.c
> @@ -176,31 +176,3 @@ const struct attribute_group *mdev_device_groups[]
> =3D {
>  	&mdev_device_group,
>  	NULL
>  };
> -
> -int mdev_create_sysfs_files(struct mdev_device *mdev)
> -{
> -	struct mdev_type *type =3D mdev->type;
> -	struct kobject *kobj =3D &mdev->dev.kobj;
> -	int ret;
> -
> -	ret =3D sysfs_create_link(type->devices_kobj, kobj, dev_name(&mdev-
> >dev));
> -	if (ret)
> -		return ret;
> -
> -	ret =3D sysfs_create_link(kobj, &type->kobj, "mdev_type");
> -	if (ret)
> -		goto type_link_failed;
> -	return ret;
> -
> -type_link_failed:
> -	sysfs_remove_link(mdev->type->devices_kobj, dev_name(&mdev-
> >dev));
> -	return ret;
> -}
> -
> -void mdev_remove_sysfs_files(struct mdev_device *mdev)
> -{
> -	struct kobject *kobj =3D &mdev->dev.kobj;
> -
> -	sysfs_remove_link(kobj, "mdev_type");
> -	sysfs_remove_link(mdev->type->devices_kobj, dev_name(&mdev-
> >dev));
> -}
> --
> 2.30.2

