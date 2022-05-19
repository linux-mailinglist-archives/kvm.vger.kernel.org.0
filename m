Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B267852CC1A
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 08:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233532AbiESGnO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 02:43:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbiESGnK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 02:43:10 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 660B6E0C;
        Wed, 18 May 2022 23:43:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652942589; x=1684478589;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=O24QuR7DMSREZnoPmlvHOx/dsL4ODgCSR3esc/0k8yI=;
  b=UmXuEPvyTmg/zSVFLUw4CyyVKPV9NSOkpGwbKU0lJB6ch1A8JLwXJ+ek
   FEdgFbj9c3IoqXnoztRvQNcP7i+aQoim6TKFozc8p4WutIgkssAwFu981
   av7/hZYVfaLFZMIGL95UI/hqUtiBW8RjP/NWEWqYRpFyksNFKG3D2bQNL
   29JGgjWiQ3a5KAvvfCHZ+sKwtNZ9FfURU3zfWMAYlJd4i004pzu5oMPyL
   DU5byx3B/3mdY0Z4xvJKMF+AOWJmr8KgbAJ6i7j7gcZPZ0m28BNY4mcte
   y5iMmwDjN4xMmlrmsDiOsUZLSKrcL8YWBULrUtVQe9E80rKcp8JAhpU6z
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10351"; a="272180955"
X-IronPort-AV: E=Sophos;i="5.91,236,1647327600"; 
   d="scan'208";a="272180955"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2022 23:43:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,236,1647327600"; 
   d="scan'208";a="598361186"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga008.jf.intel.com with ESMTP; 18 May 2022 23:43:08 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 18 May 2022 23:43:08 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 18 May 2022 23:43:08 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 18 May 2022 23:43:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lSOrriQWIxdmBk/X38q0rVjK2nn0MGaSJsguCRBbf98ZdmLA/cnMozrVaxmVbnRwxN9Nj5N1TX8Co7CpiIXcj/MvHTCyL6+m6r2YPuoU2tLnOs8ms1AXsCRfXVQU9oKG2YZRFph4sNAeHJYNUfUW0x/mb5MCSnN64Ig8gPOVa6TAG4Hia3S0VUdRxaP+lmTdNh7SCBPOmNuJzmADax/72CYH8kdxkzJ2GElsyIeSoBAq5WBmCiwI2peTtZjzFoLLYvODmU89ObPCOwQg2SLjkNHB+GVBSu+i+yPBljZJkFwEKcQu9z2Rzb2M/WXW7h6eSh42xPG/8sjtN1gVTcZvJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PvvaOBgjYiUlEBKH00dk+xbGwqpy8/JMav/ZBRNvj1g=;
 b=dIRoiLmR/pFQl0aB5/pqrzMi80WlnsCwjgt08jbaYHMWq1Qn+quQoUfJURllJ21x17RlZYb0YnprsPCJeey5zpyOTzFQnf2JfRVaXYm3aNk1saXXzIbPv5ZCCfd6Dz+N7r9rQWh9D8ML8Ks/+2mZ3R/n7IK1Cj1jNOZSnZwhFGTfGM8z0461sxKRlhvz0sy2Gd5FPdTpp9oJQNfVu8jBfaTnIHI30l7kURxJcIybfPEZFlowdjleAglCto+4Hqb7czB6nU9IvGviPtEkNIzJHdq9KMr4WLDMjvIVGwIOGrBUGfXPlgLHaVPABWxgEsAJnu/Wx4vt7gpL7sOmco97PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DS7PR11MB6077.namprd11.prod.outlook.com (2603:10b6:8:87::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Thu, 19 May
 2022 06:43:06 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::24dd:37c2:3778:1adb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::24dd:37c2:3778:1adb%2]) with mapi id 15.20.5273.014; Thu, 19 May 2022
 06:43:06 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>
CC:     "jjherne@linux.ibm.com" <jjherne@linux.ibm.com>,
        "akrowiak@linux.ibm.com" <akrowiak@linux.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>
Subject: RE: [PATCH v2 1/1] vfio: remove VFIO_GROUP_NOTIFY_SET_KVM
Thread-Topic: [PATCH v2 1/1] vfio: remove VFIO_GROUP_NOTIFY_SET_KVM
Thread-Index: AQHYav38r+LwcdssakyG6t/K4P4DTq0luTjQ
Date:   Thu, 19 May 2022 06:43:06 +0000
Message-ID: <BN9PR11MB527684F9BD1B906B930E4A468CD09@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220518212607.467538-1-mjrosato@linux.ibm.com>
 <20220518212607.467538-2-mjrosato@linux.ibm.com>
In-Reply-To: <20220518212607.467538-2-mjrosato@linux.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.401.20
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2c6badf4-0a05-4efb-43e4-08da3962d4f6
x-ms-traffictypediagnostic: DS7PR11MB6077:EE_
x-microsoft-antispam-prvs: <DS7PR11MB60775FCF04760B45EE85248E8CD09@DS7PR11MB6077.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mjoFjxS+zQ2lvcZVl/4jyge0u4DDxjqJBjcf1sNlD96GyyqO0BAWcLyLJnzNSOjxDWtCxrGEV5619bFfbu7mw4lcnw49gGLo7qlBXSJ+jCglZiXIXsirrYbCLpQ+pPFOqLf+Tzi6waUcq2V9GE22kPH+1OS2F/8xMiEtXOzNFASv/qzwR7kNqCRZpGBOMmxAPjcuqOyJ0tWpvGj8J2J45vswKOCJ2jM0bJNVcs6TMBCieh0QT2hXzOhlHCf7QC0hiBtjD6V9HoRoEhG/SMHle30wsQd9vhndz+mRoK+Muhp5MeR2qOmJ/OFFYpHFMdsplknP3vEK/fHHGEHISEENUpEzQKGcNFDvLMr7ZOU5Ya6iV9sOs8MhxMHYdBfX4hC86SDEiC+hNiBhmsVes5EyldNGVeS5E2HaB2BwktLKHVkWVg6rX+jmxSC58GDe1sUSx4YtORaLnbEejbcpX34ucDNSvkq5CN+AYAp/e4qd1IMloQ7N0uf019uiRBiHWf76GCB0NPO8hfv2O0Htyot0/2zv/Mlpd2cvtrjIaBlkd1mNDSPewjc1/A9HSXxO2TfnJTlkZw0049MUnB4Zjg8toOijDoLnnBc8GqTgWTsM5mD95NxOcdBEba6hAVpCA2mEZw8cztLKg3cDRaNQDcZ8VtHs4xM13xURfkLr4AhbZ1UXqNHD+EH5mu1KYB3SuYfqz+4vCKR+YtlwMGyPT9CzuA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(33656002)(38100700002)(38070700005)(54906003)(52536014)(9686003)(86362001)(508600001)(110136005)(55016003)(5660300002)(82960400001)(76116006)(186003)(64756008)(7696005)(66476007)(316002)(66446008)(66946007)(122000001)(71200400001)(2906002)(83380400001)(8676002)(26005)(7416002)(8936002)(4326008)(66556008)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?oD5w9SZfUYp3UvNLWH2HoXpQWU3WUKdCrquJ9Cmhjj1KJ+/HurHGVJBEnkUr?=
 =?us-ascii?Q?nTbJT5OmEJrNS96oER/gfC7/5FJ6OCVGCjJYx3r9kCuxrDobkHJhpFY9u6jo?=
 =?us-ascii?Q?1/f4kmXjCUS2NRBX3YG7Sdv5o72X8UKJxU9yiKJopEy20+578aP6GMVwFK+s?=
 =?us-ascii?Q?VZcf8EIn3gyd0bYC/5Kw+ZbNDyUN7EU1I4TXw0hTMvdDx495cE20nNOLbJYb?=
 =?us-ascii?Q?RDz4PDFIKNyT3CS8EirNEZhdTY3x+2G958/dXvoqIWgdhatOoYbIW4yju1qK?=
 =?us-ascii?Q?vfjhPACyKx5mAAhJYcPzmsaqz48QTNmWlTRiIu8MSkilKS70JDlQ4h1pBr6k?=
 =?us-ascii?Q?4r/qLEZt3b8RGQUjdWJBho88Kf2qrdinViGcV7fR2W0t7QOpwxykPcz6A7r+?=
 =?us-ascii?Q?Fv2+n9pAleKZIoztFcyqFKTrN0tpzf+Rq/d8zQDgRnWXrfllPNoDxyeWAaK1?=
 =?us-ascii?Q?3eFLpZ4WgAnAJbo1DRv/8UfsmH7FYohVi6ZKxyC1h38XrFTXsRG/Szd3w4uE?=
 =?us-ascii?Q?sdMdQl0Q3KMNS1GrVfyRmPRUofZOmohpAoQSu0F1ZX3uICGqMe11pteBZD9J?=
 =?us-ascii?Q?Di2GDPtxCgBqOtCw8sxyWlBFPSzb5IcIWfr/v7a9A6ta5+9/jvUvNUM2PydX?=
 =?us-ascii?Q?VjdGCcwiJu2OJfrl7iqD/hYW5CPeB/3qHOOyheNKWrCn3d6CHcd8PSN7sBl6?=
 =?us-ascii?Q?Uf9nuS9lYMNzmSuekklB0iTnsQTyWs6PIKGIIv9+9BSG3u6mM6EjrYfIo/zt?=
 =?us-ascii?Q?8orwHo/MlUB/UEoc+hwNyLMabPOdO1Oc9qIrV55JvX6jaZDTozKXrUodTqBB?=
 =?us-ascii?Q?SEMzBPKUJW78CyfZJoWVmsjKq+HaN4Wbrk8gmEqvyg4gRccF7ta94bz0H+8l?=
 =?us-ascii?Q?1TopTPHJeCm1Lis1ScXVqekjLEcWD3nUz6rjmLPYUZA2lLyx9Htlo7tG7HnL?=
 =?us-ascii?Q?TmpWkpw6oTFjz78oMiRSc1PLefXBwxDqxGMSt5bFda7tHxpLvwbmZMlPI5SR?=
 =?us-ascii?Q?6N9uUe6Sb1JiLqu8YYF6cxK0jsY7nqxY+bmbLBOaWzBgR7N2psQWliWyoIdR?=
 =?us-ascii?Q?lzA9z64x+fW31kdIhN5GLBx+hUv8Jsk48HSbrWrf/eNam5OJ3D5OOa6BWw5Z?=
 =?us-ascii?Q?BYbpRS4ddvnz6mX9ONQa6erR54JpuVUOz4Lmr0y0vDpNteQPyZVg9ehivOYg?=
 =?us-ascii?Q?i90opsiqBNGomsRYR9o7jrmk9KRRCPtiktv9lnEozJQqEvEXJBlYgks6mz35?=
 =?us-ascii?Q?+7HgWZqTiGSnaPkTMJMDe2Qrsf3yldDeQaQjAjROWDekuDP9uE074igukURl?=
 =?us-ascii?Q?B1mxmQCcipGX51kwclxyH1hGfdrdxepd7+PnO21l5hQvaM79HEYiZzpPs9BI?=
 =?us-ascii?Q?LnBad9pwgV5e7V4rQU2R+3hdg8OBs8FJ0+6SjzhP1pw0WPsLH7Iw/hU9ZEUr?=
 =?us-ascii?Q?pXLY8z8pukuaz58ZHRU0qux1Hle1fSsalfenTf6zNRamFLCfM3yh7vwG3axD?=
 =?us-ascii?Q?fg3793DL3IQ3T/M1UzUrYqlmZg5utP+Yv5bExQ41YGO/Y2xzymtYYUDbDgF2?=
 =?us-ascii?Q?KXe+2fCwH9giL2CcbtPKLdKXhKGfDnKNaTnyFmclcM+klUdDBd2StQ2VhWI6?=
 =?us-ascii?Q?pnLIZpxxtoHPXP2eAIphI7506R64euJioEvFfGpsSySd2ajrmJDOcvxSW9S9?=
 =?us-ascii?Q?1GLhJNVrEwYSHCP4YpkvB4J6AcMOt8rAf6UJUgPycjPITKTZ9ghZPgH7O/0d?=
 =?us-ascii?Q?LnbZsv1krg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c6badf4-0a05-4efb-43e4-08da3962d4f6
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2022 06:43:06.8521
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0i+NI+SvyXMtZpOd+b99HN2s1BkF8LFH3II0Jwga7NzFyLwi9ThgrTfLznMPjVlmxpbymJzycp3Ji6CGxHs6PQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6077
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Matthew Rosato
> Sent: Thursday, May 19, 2022 5:26 AM
>=20
> Rather than relying on a notifier for associating the KVM with
> the group, let's assume that the association has already been
> made prior to device_open.  The first time a device is opened
> associate the group KVM with the device.
>=20
> This fixes a user-triggerable oops in GVT.

No changelog.

>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>

Not sure whether Christoph wants a s-o-b here when he wrote
the snippet to remove the release work of gvt...

> @@ -1083,11 +1083,22 @@ static struct file *vfio_device_open(struct
> vfio_device *device)
>=20
>  	mutex_lock(&device->dev_set->lock);
>  	device->open_count++;
> +	down_read(&device->group->group_rwsem);
> +	if (device->open_count =3D=3D 1 && device->group->kvm) {
> +		/*
> +		 * Here we pass the KVM pointer with the group under the
> read
> +		 * lock.  If the device driver will use it, it must obtain a
> +		 * reference and release it during close_device.
> +		 */
> +		device->kvm =3D device->group->kvm;
> +	}
> +
>  	if (device->open_count =3D=3D 1 && device->ops->open_device) {

Merge the two branches so both are under if (device->open_count =3D=3D 1) {=
}
(and group_rwsem can be also moved inside)

> @@ -1315,9 +1330,13 @@ static int vfio_device_fops_release(struct inode
> *inode, struct file *filep)
>=20
>  	mutex_lock(&device->dev_set->lock);
>  	vfio_assert_device_open(device);
> +	down_read(&device->group->group_rwsem);
>  	if (device->open_count =3D=3D 1 && device->ops->close_device)
>  		device->ops->close_device(device);
>  	device->open_count--;
> +	if (device->open_count =3D=3D 0 && device->kvm)
> +		device->kvm =3D NULL;

This can be moved out of group_rwsem as there is no reference to
vfio_group.

> +	up_read(&device->group->group_rwsem);

otherwise,

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

Thanks
Kevin
