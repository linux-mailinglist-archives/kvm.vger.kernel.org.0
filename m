Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9884E545A85
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 05:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235229AbiFJDcx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jun 2022 23:32:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbiFJDcu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jun 2022 23:32:50 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC49325EB1
        for <kvm@vger.kernel.org>; Thu,  9 Jun 2022 20:32:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654831969; x=1686367969;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Bp47TUOyFdqLyiAZisjViTYOHby4fzftcHKWzocQ6vw=;
  b=WNXnne9fbcMi46J07HSCYVNDiV0eN5VKJ+XmaFylaIkux3NA1QtuavMN
   VZowuxXBm1mXIxViOeAQ789GffL8f+CwJ41hovm5+uUtPy5XKL8cextHA
   hhEgMg3p/tg5DqJ/VaxH/TGMWl0+ZeOGzMugA82MuZRJiAw0Xp1hY9Zmf
   vllP707nKtVRELs28/+TZD7iG2vZ274jAfVxJNOt3lKEVMOfl3u3nRRkq
   KxfNmKHCvYCvmfXEyR9I6fV8N0ywrlmE3bz8rEReBXT4zhlOK3EzyS0M1
   8nmU8E+kUxcFebbTFU8D6xNiZTnnVzWoIr4tKl7v+5BXYa8WJXzsFtKSk
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10373"; a="363826274"
X-IronPort-AV: E=Sophos;i="5.91,288,1647327600"; 
   d="scan'208";a="363826274"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2022 20:32:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,288,1647327600"; 
   d="scan'208";a="637894484"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga008.fm.intel.com with ESMTP; 09 Jun 2022 20:32:49 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 9 Jun 2022 20:32:49 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 9 Jun 2022 20:32:48 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.104)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 9 Jun 2022 20:32:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lLHwGAdMc7PWAnbJfMIPvNym33rLUNu3AGnqfQMhZKg51nrLFbZ//HBcYTEv5YRwxmfzYCXtU4ZsX9/CK810txZtK0OIYKxQCnzSH5bpsH0Tt+lzEi2L3digdviP67QaSOpRbef0zVb+x/N1ZbXfdPMC7kP/UWLzI7bholFjxY3FQ/b3XtH23q5dZrCijajKoq/tjHRVMuVBvUSSTzeHd9ww1ovkDyBCrQ1xD7CIp7HwUMEEzWlfHa6AZgx9OVY3I+uIHfrpzN16UMjBDKIWMbxUbiolvnyE3sHqYF3R0MO9AMfTwkuHBRkkPR+8fMEZNEU9DoY885MpaSH0+RqI8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JhQ3x6bnkUlke7aAwu50s+kbORDibtZ/PoMpSyKjhZI=;
 b=J4GpymL6BK3z/UTpr7jo4ixrrJYPBwwwA9Z9MA8RytocfvnU2Fgzf0aeUBvzxHNXmdndybldYtAAf2lzxxybJGir4i/dQazybfj5hj1e0uZOUaOqYc4q81zYEs8emSDVzfcn4zwESf3W/awNbxpr+c7CAiqT40PJ1E7UXDZmR2ire2b+4x1k6N0cgfZ456XB1kxJAYQnswHEKlkZHV7ra2ccsNbpbeF3kyR5Nz70whxM/sGkbkejBzhcdYn624bGTLQ55BzW8tlCfiU1sCJSklD0iVI8mecEuYgHe2lav0DIYrNirFgl6uFEoPMBDCrkG2zRanVBP2XgP6Pbaow3bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BYAPR11MB2709.namprd11.prod.outlook.com (2603:10b6:a02:be::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.17; Fri, 10 Jun
 2022 03:32:47 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::3583:afc6:2732:74b8]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::3583:afc6:2732:74b8%4]) with mapi id 15.20.5332.013; Fri, 10 Jun 2022
 03:32:47 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Yishai Hadas <yishaih@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "maorg@nvidia.com" <maorg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "liulongfang@huawei.com" <liulongfang@huawei.com>
Subject: RE: [PATCH vfio 2/2] vfio: Split migration ops from main device ops
Thread-Topic: [PATCH vfio 2/2] vfio: Split migration ops from main device ops
Thread-Index: AQHYeYOPTfntv5YgX0aKO1lwAOJE4K1IAOQg
Date:   Fri, 10 Jun 2022 03:32:47 +0000
Message-ID: <BN9PR11MB5276F5548A4448B506A8F66A8CA69@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220606085619.7757-1-yishaih@nvidia.com>
 <20220606085619.7757-3-yishaih@nvidia.com>
In-Reply-To: <20220606085619.7757-3-yishaih@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 52e36591-f685-4e1c-3fa5-08da4a91e34c
x-ms-traffictypediagnostic: BYAPR11MB2709:EE_
x-microsoft-antispam-prvs: <BYAPR11MB270948D10B22AD1C9CF567EF8CA69@BYAPR11MB2709.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YOyT73oxCtKklwkU5leTb5sr57uJgboABUwcYTNlFjWZumypIjJcttUngM5x60S5vl20+pjGMACGr2dRVD7bSjRuM9UHTI2m5CoVxvuQoA34fgJ+20cbgh0zJg2/OXMj55a7wZfasKSPCbcKhr69sQzo7TwpVhBbhN+/UWoGFs2XO5MqMfc8rB+l3+ZI97QQwlGIol+/eTbfuRrldpNfc0z2jl542cERRBkUXtPoUOwbl4QyTS5KZjUtF7gCqqzxv/9Jvb387ljcamYkLjxLe2WizxnF0eX71Vj8bQ6C4Hpr97Iz9qdDmyuEcLgWQQ/YyK00yb1nuGIt3YAo4ezT2KNp9bDV9dJhZezUAsLHzyGZxyOBEqFMA+bSxHBO5FuS6hQErqu0Jckbs5EHzDMXYx67nKsOLHE0nRmtCnWW42XI2dTZbFFj1CBLzx6L8Rz4ZGapvHGFkoeCqpLsUxUzEd0HMTnznL2zQchrd9VwP7jx66X5UZkkW1iwbiT6KJrTW+02tN5tnHbB6URLGkQYf0Y+JlK9TiENvaQCwg9HSrdMxwFAbyAyZc6fnVYRxqiqQGoR7zEDejl3XErRTrHO+wek5OMvs//QGcKk1IqwbMcoy2MG9HF0a4tZRJ/IIerJZy9kYo6jbVdG1GstsfkvklDZopV+7ioenDgR23jdv6m79yJa+Y8EW5zujX0qIjmr/ZtczN9t6wk4GXV2t5E2Jw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(55016003)(71200400001)(122000001)(38100700002)(26005)(7696005)(6506007)(316002)(33656002)(38070700005)(9686003)(2906002)(66476007)(508600001)(110136005)(8936002)(52536014)(82960400001)(4326008)(76116006)(66556008)(66946007)(186003)(86362001)(8676002)(66446008)(5660300002)(64756008)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?c789kASVzPECqxZzVcUymqeiMHkMpbj2t2IoR+ocMDDQr4WxxvB0/X1SJBnm?=
 =?us-ascii?Q?N/Zdqch/xmVoFljWLfkq/1qZTirW7EZ7X91e74h9Sqlzc9LA4rfd4k0oDma0?=
 =?us-ascii?Q?lBnCBYRYvW4auxE0o3bLllXUxVcA0BB5QqVp79mJNzn0Xn4IlZDjx8Gidl5c?=
 =?us-ascii?Q?niN/pj+fOKjS/s/5reBDOmKyq+CKWUg1t8D/j8mjxEQYdv9ai/RNTmCkdS3P?=
 =?us-ascii?Q?TMBLSF/kJB4fseJ8X1nRPa6MZVlzt5QSA6h4hRw0rKrfkhTU7B6n7TXmKsTZ?=
 =?us-ascii?Q?Cy8QZsMgBVUk6IZ0nBzL3YIjwC0kK31QyXRdghgQ5aS65lWryM0tQbyP80sF?=
 =?us-ascii?Q?9EX0KwLXefK6nyjuiKfC+OBi0pAZxoTcs6X5e8qNUJH7het/ukPN+RsPG2Wz?=
 =?us-ascii?Q?u+QixKv1Z5cpxKpigmsItAwH1S363LHTNJLQ/ViA4Oz0ZdF3OjtsMOOcVWfU?=
 =?us-ascii?Q?KJ7vbIn9p6438SQvy7az5N2Umw+8GnlhsJuXRhv+vAbizJzJBQ+JZbMl44tP?=
 =?us-ascii?Q?AquXFU+CaxqKB2BwsxpXYoXLffL453OWhRbgfLvirJdsnC+lI6Rv3OiQvcLN?=
 =?us-ascii?Q?PmmANt5+6s0DUJ7fys/VZtBnP03vzZ4DLSy/24z5ll96wabr3dfsSNosC7t9?=
 =?us-ascii?Q?MRyjBYJcwHgLoZLERjsfShFO5mVZCnQu7qiqXeH+LNwJMKQRCjvyzxXttS0D?=
 =?us-ascii?Q?wSDxiWKJ3sbOekLJUERouVdOOJe0v91pVPOnFvjMG/o+7oZTbCmI0lV6rokV?=
 =?us-ascii?Q?yWz1p4KfSmq5S9zULTdAOBKxxNCwAgeEbYC5BlHMG7eir9yp78u96PeMYAsV?=
 =?us-ascii?Q?/qoqtNIbHDyAc1iRtJgwQ7nAR39H6E820eQpBULHGQICyRx+i3jWb0prgHTs?=
 =?us-ascii?Q?suGZxyoeIJCt9tySOh9I9hcG3oGEAsNQAIsripGJSLhOCHifn8m5M9ZvdXCc?=
 =?us-ascii?Q?oV9LVgVf+Ji3km7BkgiqQya82kYQl1FlwJ2k2Xn6fbOtwVI8ekFohOPe1TQ2?=
 =?us-ascii?Q?2nHwOn0thRY4BzK7s5EexXXEfHgaXG+oagQT28aPqDkNx06QlF7qL3jV4TT7?=
 =?us-ascii?Q?IFnHOXsAfKqePVpAsA/fvw7I3DnJBMDrlz0pzAkrRHaFLv9bBiI+znCtjryK?=
 =?us-ascii?Q?a2yPnj9wB3ViBrGEY7qK5lPpzLMGLTC8NRB5qTpSKbnyDwAK4+RnzMNHnSWz?=
 =?us-ascii?Q?LoOiShU3QM2ViYeP8z4HzVjb2P+IoM3yFS6Jz7Jrk7QEFgMK2cPwgDN/nOkf?=
 =?us-ascii?Q?7GWIuWAcY4DMkYi0Gu5Xl2k3Fa4DbIybtGACp9F9GOWowMtgTCHU/oVXs8Vd?=
 =?us-ascii?Q?uhLVBNg0xqNl2y+AaOkurDKws0eK4bUqejstwQ7bOJty1RzEZc0Vg+pbL36j?=
 =?us-ascii?Q?5j22jM5wyLJNTSHtq9aaMLjcqOrFYdaXAh7Hd51UaV6HxbgCPA60cOR25Tug?=
 =?us-ascii?Q?groazt3UVGK7SsK2YDt4l2CVestwnSD40L+0kJLp3LebJbkn3y08Ns7IZclS?=
 =?us-ascii?Q?p/uel7pBOoEOtYg6MiNsSiTW8GeP82Eh26WjWQfQNpkK8e6wbu5Rqfn/qg3E?=
 =?us-ascii?Q?hZii9A9FgWnUSE7STXvlZ4AgxLc3lfQNyiRwjEQXK35ECce7JMoWDNaEqHTz?=
 =?us-ascii?Q?CsJ3Pf3J7+PAeQokDRF5BYO8SMxZzpK9ILzeKOrxsC3i0u3QY+XKNlCUCvdq?=
 =?us-ascii?Q?KMdl0zW3RR+8LTC2cmN5tP3K/1+GWTPkGXHdzh7fD9TdFQDJweIh4D3/BnDc?=
 =?us-ascii?Q?h7iBwqCijg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52e36591-f685-4e1c-3fa5-08da4a91e34c
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2022 03:32:47.0172
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 45+v4bnYt66dnsd9c8RSmoM0HgvwebZ106jAl/ds4oo8lkx2YP/Auhnj1QhGr3+o5cfh4o9x8Q5bd61pXxQDgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2709
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

> From: Yishai Hadas <yishaih@nvidia.com>
> Sent: Monday, June 6, 2022 4:56 PM
>=20
> vfio core checks whether the driver sets some migration op (e.g.
> set_state/get_state) and accordingly calls its op.
>=20
> However, currently mlx5 driver sets the above ops without regards to its
> migration caps.
>=20
> This might lead to unexpected usage/Oops if user space may call to the
> above ops even if the driver doesn't support migration. As for example,
> the migration state_mutex is not initialized in that case.
>=20
> The cleanest way to manage that seems to split the migration ops from
> the main device ops, this will let the driver setting them separately
> from the main ops when it's applicable.
>=20
> As part of that, changed HISI driver to match this scheme.
>=20
> This scheme may enable down the road to come with some extra group of
> ops (e.g. DMA log) that can be set without regards to the other options
> based on driver caps.
>=20
> Fixes: 6fadb021266d ("vfio/mlx5: Implement vfio_pci driver for mlx5 devic=
es")
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>, with one nit:

> @@ -1534,8 +1534,8 @@ vfio_ioctl_device_feature_mig_device_state(struct
> vfio_device *device,
>  	struct file *filp =3D NULL;
>  	int ret;
>=20
> -	if (!device->ops->migration_set_state ||
> -	    !device->ops->migration_get_state)
> +	if (!device->mig_ops->migration_set_state ||
> +	    !device->mig_ops->migration_get_state)
>  		return -ENOTTY;

...

> @@ -1582,8 +1583,8 @@ static int
> vfio_ioctl_device_feature_migration(struct vfio_device *device,
>  	};
>  	int ret;
>=20
> -	if (!device->ops->migration_set_state ||
> -	    !device->ops->migration_get_state)
> +	if (!device->mig_ops->migration_set_state ||
> +	    !device->mig_ops->migration_get_state)
>  		return -ENOTTY;
>=20

Above checks can be done once when the device is registered then
here replaced with a single check on device->mig_ops.=20

