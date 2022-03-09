Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C9D74D2CDD
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 11:12:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbiCIKNr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 05:13:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiCIKNo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 05:13:44 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F29ED986FB;
        Wed,  9 Mar 2022 02:12:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646820765; x=1678356765;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fxuqVRO0YSwC8YMZ5dalA82+7/daobBVaWleN2bXAto=;
  b=B49d0G9RdheNZuwMOCwkVhoZrieLiwa7ivzvQFg17lZYD2vQsv0NSQ1J
   rug1aTDyDdiOZnOEDc6Dy4uwPDe9bcKKZ4KWQ5dVjwlzogQnJIw0O7k6b
   cdS+g0vifAdIxDE4GqXbLerVyMfupMbn5dxeVFu/JgQYpHcuaAUOflrgP
   JK/bd49nexKjzue54AUy1ZbgeGiFpSm5ca6sV1FUrvcmNqqTZrC/KpawU
   5nKn5C+ZG9UZxlOu4o7a55i7BvWA+IpozbNQSeuZ7VA2kDDxZ4wO3Rs6e
   rprMhof/Usa9rKvekDtcP+L9fLXl1u7rRszEXNr6qyQ86XlJB5UgR2mY6
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10280"; a="234891265"
X-IronPort-AV: E=Sophos;i="5.90,167,1643702400"; 
   d="scan'208";a="234891265"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2022 02:12:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,167,1643702400"; 
   d="scan'208";a="596222396"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga008.fm.intel.com with ESMTP; 09 Mar 2022 02:12:43 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 9 Mar 2022 02:12:42 -0800
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 9 Mar 2022 02:12:42 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Wed, 9 Mar 2022 02:12:42 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Wed, 9 Mar 2022 02:12:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZBMj6Bn/4hhJ+qpQJfJ5wPsFM36DtmgGMAgSoTagxGWPmuWXrGCT75z5x7qAx/OMXJPbcjqGjnPCUN9FKcpI7pEk4+XY9BNHeBfxMSqQadkzrDrQU+EZMElZlbROtBUZEAOpAo3aMeasduX9kn30vSpBDzHBYQRTjs/Ht7jqlrpAx2gJS1d3DjscW/M2JGs19CG8iRGf7/Sh1m4wFm4MWdARSs22e2Wl5trm6v53EhBJxLy9SciYp6FXWlKBFvHHQMdqI6SYUDYMm8sL/tWNnd+GiNgTpHCbhlN9VEMMEeaXyYu577K3QI6rUat8E5B0xRi2+POLStAB/fjdVdXd4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2AHYcOvNjbjgWP7XZ+K2SiQsWqCDTV8xMk0OuOFgceU=;
 b=XdNjKBMkOuXQ3rU8DPqbJdvyb+eQcaPK3L6ZJnxL3ZroEMSBetigpBATASRINy0TjWByGiX7fbLsmvKbRHDJIc/BumVWDhGJ8q7ptJsLILBBqe6eijEUePQDhQFZyhMVxExN+PHSCJEe8Kkrm6WTGbDETsM3xA1AzhNyq5g683KwCwt9cEzLbZbAL1RKV1kfIFaqpJT3H5eeLi0TdIoWV4YUGSO8AEHqcK8/09x/pT1BTDRlieOxX4FkjLp9s6PLf3d1JxmK/JeFX1Je44oJMpIy96pGnEbJ0tKB19RJNTnc6qnYwNmU3DerhxGqJVeiGtVUgWn+amFrA+weeZeCxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BYAPR11MB2616.namprd11.prod.outlook.com (2603:10b6:a02:c6::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.15; Wed, 9 Mar
 2022 10:12:39 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c8aa:b5b2:dc34:e893]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c8aa:b5b2:dc34:e893%6]) with mapi id 15.20.5038.027; Wed, 9 Mar 2022
 10:12:39 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>,
        "liulongfang@huawei.com" <liulongfang@huawei.com>,
        "prime.zeng@hisilicon.com" <prime.zeng@hisilicon.com>,
        "jonathan.cameron@huawei.com" <jonathan.cameron@huawei.com>,
        "wangzhou1@hisilicon.com" <wangzhou1@hisilicon.com>
Subject: RE: [PATCH v9 4/9] hisi_acc_vfio_pci: add new vfio_pci driver for
 HiSilicon ACC devices
Thread-Topic: [PATCH v9 4/9] hisi_acc_vfio_pci: add new vfio_pci driver for
 HiSilicon ACC devices
Thread-Index: AQHYMx1qCSwJYkKdsEOsVIokW2RKQay21hmw
Date:   Wed, 9 Mar 2022 10:12:39 +0000
Message-ID: <BN9PR11MB527659F9CB377131FC24FABF8C0A9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220308184902.2242-1-shameerali.kolothum.thodi@huawei.com>
 <20220308184902.2242-5-shameerali.kolothum.thodi@huawei.com>
In-Reply-To: <20220308184902.2242-5-shameerali.kolothum.thodi@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5d6af461-16d9-46b5-741f-08da01b55766
x-ms-traffictypediagnostic: BYAPR11MB2616:EE_
x-microsoft-antispam-prvs: <BYAPR11MB2616292A908CCD5F08ABFEA68C0A9@BYAPR11MB2616.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jQhxSaZxYrvI0p+93HqXQM8C7owAUoZBnEQD1TwmUktMsX0cRBth+BzMaq8B6gB/azpziM/ks+Qn/XEQUb7uYqdAOMmmoAIRXKfO8zcO6PqWFN1EjBXGGJGMMWslE5odIcKZ9kVDCyLLKta7CISxWNC013CKv3pJjxruYptD4aZFv+9QIRQxfI16R88W7P/ZJ3o1+ROSkW4XzLBUZ3EG1SiMN7tpekaPqNBvPqwqme93uiBWHUtmwFgn/OCM+y2sOjhtv/Hz92U/l3mKi0NRLTBgI+1T5wCsNrVizj277KMNtG0KmaYZByHVVaI8pTlV9bbRSSBgo3TyUUxR4p+T4lswgsWFWGf8zDHrdKTXVRzQ/9zCSz4DJPwVgzhn4Og2qNQdOELgFO2mCjusFP8g6tUDcSCiVRrunBGlWLJEoSCcjVuY15Z234SglDbNEnGLEjfYfaWVqy92huLMurAXUCLBHZ0KzSmGTt3CuTrCInpIw1CRFIKryOCt2Vc4WrKeKMj4rhEJCKEuO40EaVIXWAI10Lb6eR4Ce++AR2wI7ULmeHkNdS5TYY2+MpT31O0oGNiZNMY8ho2SEkqNU7S8YWo1OZ94GSY2IAzRfoueIEjmKhPDFodUO3o/BBPqRdSr7PNXxkUwxouncdjO8cA4tUL/jIDyvY6a1OmUz+cgrFqpswDCJp/mMFunP1VbTXwzO3b1K6U2D1T14CsgE15rbw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(6029001)(366004)(83380400001)(6506007)(7696005)(508600001)(55016003)(54906003)(38070700005)(71200400001)(33656002)(38100700002)(110136005)(316002)(86362001)(7416002)(2906002)(5660300002)(82960400001)(9686003)(64756008)(66556008)(66446008)(66946007)(52536014)(122000001)(66476007)(4326008)(8676002)(186003)(8936002)(76116006)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8d/EnxJAIM973bLLUx6dSOkdFoUexicaijmaeDADdn5k2HuZdifNwc/HCQo5?=
 =?us-ascii?Q?jgYMZSZLilDYOnzv047mPrJNbr+3xMvYVoPtqt5T4wOo/R84AxVND4mr9Tgw?=
 =?us-ascii?Q?DTT94vDIc7POsrvkiH5hY2SmPiPg8UmHRWUCjQJsKJ5PQ8dNtVqsasBvUfL6?=
 =?us-ascii?Q?sN+JBKzF2JqIN40DXsiYN7ZPKukk3RMe2+qbMn73aDpDUneLqZmZrILP+OAy?=
 =?us-ascii?Q?589u7rVffQGkD1ZHhvt/0JzvQhViB8AHxV5zdk+JvskBVaNBTp0SNisF9n84?=
 =?us-ascii?Q?DLrudmgaoOZ6QiJq0wsIcqrxOfeLx/TTdzYioEVPMABiXq30Iw4vwYivYuxe?=
 =?us-ascii?Q?pgjxHO8VzrqmuGG/VhHH25L7TfkOjesDyOqXJX18yKrcdwBGvxzVXJPagszM?=
 =?us-ascii?Q?NOUUEO4iSwoQWBwl3lHoMlh+pvqs+zfNqAZxAmb4pF+JbxE0yF1P2Aa3e43M?=
 =?us-ascii?Q?ZG2RoYxyc+MhdL7i7GiGtf+ewTdb1gzD8/OEwEisLsGq6yNnGOZjTq3QYtwC?=
 =?us-ascii?Q?weLv4L6lQ+oA8Yr46LUnwcwrTVseS+7NtNSAWlgRGeHRdsoESZiMp24E+USx?=
 =?us-ascii?Q?R7IjrvqsutTGfCZKDdnV+kjIsOhOOKzOEiuwO976ELcTbiAKI3B8iTkgSLCA?=
 =?us-ascii?Q?QUP0gA1mFuHjmONTsT1tQrNRBmlzNKp3bT/mlDKJ4mzp7Mk06g8cS1VtrALM?=
 =?us-ascii?Q?nZQhm83AGsu5ilXuKvYr8KhOaAHXnZaYKww8ZO2T5NBzMBUT1bsJZtAIwXYi?=
 =?us-ascii?Q?S/VS/56GG9ZFIW1qC8wY7Iv/o0qg9e6MJbkfxE0lRUOHetxwUHBFC18+//qE?=
 =?us-ascii?Q?FWTZ1kOUeb9rF+rWxxepkzVB1lWiyXYvIb6khfIS7rd0KF5ktKLMZfr5n9XH?=
 =?us-ascii?Q?fieanoSqZOyebLNPeqqHtBG7WxQbJk0XYxETCq4Yg5SY0NxegVluXpKV5dYg?=
 =?us-ascii?Q?cJP3YGDGqIm3yB1lzalQydF8k91AdJqq9bd+YNgq9+onutcEb54IYYouwaYd?=
 =?us-ascii?Q?Soqyj7s+Tz3flpc6L9oIoWLYpAZHA8zeC42e55Iy52t7Ml9ntl/Ouh2WsAK4?=
 =?us-ascii?Q?l9NKk9BgZPDJpplpk5OYlhwA1R5lQ6bfIzIMC5Idn7QKIfOQco/9yHSI29PE?=
 =?us-ascii?Q?nXttWK2PkYWXHoBh4wyfE+gYvHpOS7Vd9Zde1bZOVoiF2g8TF5W57hsqkQCc?=
 =?us-ascii?Q?LlhxYRcZJ5N3B20Tko+NvYE02eX+y6LfCMgSD4deTCtBjFsi7hepk3TJ92Di?=
 =?us-ascii?Q?2Sgy3Qavswx0pI9IOI9FFeJVhLbnqzc6wZqNPJ8agMbjq6gif9IhC4C0+yzo?=
 =?us-ascii?Q?tq+y9LRAlCm1HYXWl1jYB0ysDXrnpWx6QghfgwWoIL+UaT88uKq93z9aCuTB?=
 =?us-ascii?Q?644yijffumIs1JlHyIYyUzv4wfFkOnAXyoHvN1tV9IgM3cSLpbbdQyBHF1HJ?=
 =?us-ascii?Q?v9cgaJxEivMTdv7YWGmjd3Xjr3qfqL1samDlOIc8i3Edi/73Ba8olLfFyeR4?=
 =?us-ascii?Q?gxmDiHfz2l0ObtgrEbcEh9CkGtdbzBXqbvFVaWgduRiEwbM9wtpnRCQXXWHi?=
 =?us-ascii?Q?t0+R2R57bG+P7vde9u74NLIaMmFLWBfZpPkBtcqMXDS23OLlf0DjjjI/sgnD?=
 =?us-ascii?Q?H/uR1gzW2Can6GmFnEGMJlA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d6af461-16d9-46b5-741f-08da01b55766
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2022 10:12:39.2293
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lzRXW46PzGjf74f/OTGgGSbn7jgWWghaaAONLy1ciFhBJlLdg4olmx/h/ZLIpc6Z+GuBDk4wqtkk+ZKj+dXleg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2616
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Sent: Wednesday, March 9, 2022 2:49 AM
>=20
> Add a vendor-specific vfio_pci driver for HiSilicon ACC devices.
> This will be extended in subsequent patches to add support for VFIO
> live migration feature.
>=20
> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

> ---
>  MAINTAINERS                                   |   7 ++
>  drivers/vfio/pci/Kconfig                      |   2 +
>  drivers/vfio/pci/Makefile                     |   2 +
>  drivers/vfio/pci/hisilicon/Kconfig            |  10 ++
>  drivers/vfio/pci/hisilicon/Makefile           |   4 +
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 100 ++++++++++++++++++
>  6 files changed, 125 insertions(+)
>  create mode 100644 drivers/vfio/pci/hisilicon/Kconfig
>  create mode 100644 drivers/vfio/pci/hisilicon/Makefile
>  create mode 100644 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 4322b5321891..48e09ca666c2 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -20305,6 +20305,13 @@ L:	kvm@vger.kernel.org
>  S:	Maintained
>  F:	drivers/vfio/fsl-mc/
>=20
> +VFIO HISILICON PCI DRIVER
> +M:	Longfang Liu <liulongfang@huawei.com>
> +M:	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> +L:	kvm@vger.kernel.org
> +S:	Maintained
> +F:	drivers/vfio/pci/hisilicon/
> +
>  VFIO MEDIATED DEVICE DRIVERS
>  M:	Kirti Wankhede <kwankhede@nvidia.com>
>  L:	kvm@vger.kernel.org
> diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
> index 187b9c259944..4da1914425e1 100644
> --- a/drivers/vfio/pci/Kconfig
> +++ b/drivers/vfio/pci/Kconfig
> @@ -46,4 +46,6 @@ endif
>=20
>  source "drivers/vfio/pci/mlx5/Kconfig"
>=20
> +source "drivers/vfio/pci/hisilicon/Kconfig"
> +
>  endif
> diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
> index ed9d6f2e0555..7052ebd893e0 100644
> --- a/drivers/vfio/pci/Makefile
> +++ b/drivers/vfio/pci/Makefile
> @@ -9,3 +9,5 @@ vfio-pci-$(CONFIG_VFIO_PCI_IGD) +=3D vfio_pci_igd.o
>  obj-$(CONFIG_VFIO_PCI) +=3D vfio-pci.o
>=20
>  obj-$(CONFIG_MLX5_VFIO_PCI)           +=3D mlx5/
> +
> +obj-$(CONFIG_HISI_ACC_VFIO_PCI) +=3D hisilicon/
> diff --git a/drivers/vfio/pci/hisilicon/Kconfig
> b/drivers/vfio/pci/hisilicon/Kconfig
> new file mode 100644
> index 000000000000..dc723bad05c2
> --- /dev/null
> +++ b/drivers/vfio/pci/hisilicon/Kconfig
> @@ -0,0 +1,10 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +config HISI_ACC_VFIO_PCI
> +	tristate "VFIO PCI support for HiSilicon ACC devices"
> +	depends on ARM64 || (COMPILE_TEST && 64BIT)
> +	depends on VFIO_PCI_CORE
> +	help
> +	  This provides generic PCI support for HiSilicon ACC devices
> +	  using the VFIO framework.
> +
> +	  If you don't know what to do here, say N.
> diff --git a/drivers/vfio/pci/hisilicon/Makefile
> b/drivers/vfio/pci/hisilicon/Makefile
> new file mode 100644
> index 000000000000..c66b3783f2f9
> --- /dev/null
> +++ b/drivers/vfio/pci/hisilicon/Makefile
> @@ -0,0 +1,4 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +obj-$(CONFIG_HISI_ACC_VFIO_PCI) +=3D hisi-acc-vfio-pci.o
> +hisi-acc-vfio-pci-y :=3D hisi_acc_vfio_pci.o
> +
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> new file mode 100644
> index 000000000000..8129c3457b3b
> --- /dev/null
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> @@ -0,0 +1,100 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (c) 2021, HiSilicon Ltd.
> + */
> +
> +#include <linux/device.h>
> +#include <linux/eventfd.h>
> +#include <linux/file.h>
> +#include <linux/hisi_acc_qm.h>
> +#include <linux/interrupt.h>
> +#include <linux/module.h>
> +#include <linux/pci.h>
> +#include <linux/vfio.h>
> +#include <linux/vfio_pci_core.h>
> +
> +static int hisi_acc_vfio_pci_open_device(struct vfio_device *core_vdev)
> +{
> +	struct vfio_pci_core_device *vdev =3D
> +		container_of(core_vdev, struct vfio_pci_core_device, vdev);
> +	int ret;
> +
> +	ret =3D vfio_pci_core_enable(vdev);
> +	if (ret)
> +		return ret;
> +
> +	vfio_pci_core_finish_enable(vdev);
> +
> +	return 0;
> +}
> +
> +static const struct vfio_device_ops hisi_acc_vfio_pci_ops =3D {
> +	.name =3D "hisi-acc-vfio-pci",
> +	.open_device =3D hisi_acc_vfio_pci_open_device,
> +	.close_device =3D vfio_pci_core_close_device,
> +	.ioctl =3D vfio_pci_core_ioctl,
> +	.device_feature =3D vfio_pci_core_ioctl_feature,
> +	.read =3D vfio_pci_core_read,
> +	.write =3D vfio_pci_core_write,
> +	.mmap =3D vfio_pci_core_mmap,
> +	.request =3D vfio_pci_core_request,
> +	.match =3D vfio_pci_core_match,
> +};
> +
> +static int hisi_acc_vfio_pci_probe(struct pci_dev *pdev, const struct
> pci_device_id *id)
> +{
> +	struct vfio_pci_core_device *vdev;
> +	int ret;
> +
> +	vdev =3D kzalloc(sizeof(*vdev), GFP_KERNEL);
> +	if (!vdev)
> +		return -ENOMEM;
> +
> +	vfio_pci_core_init_device(vdev, pdev, &hisi_acc_vfio_pci_ops);
> +
> +	ret =3D vfio_pci_core_register_device(vdev);
> +	if (ret)
> +		goto out_free;
> +
> +	dev_set_drvdata(&pdev->dev, vdev);
> +
> +	return 0;
> +
> +out_free:
> +	vfio_pci_core_uninit_device(vdev);
> +	kfree(vdev);
> +	return ret;
> +}
> +
> +static void hisi_acc_vfio_pci_remove(struct pci_dev *pdev)
> +{
> +	struct vfio_pci_core_device *vdev =3D dev_get_drvdata(&pdev->dev);
> +
> +	vfio_pci_core_unregister_device(vdev);
> +	vfio_pci_core_uninit_device(vdev);
> +	kfree(vdev);
> +}
> +
> +static const struct pci_device_id hisi_acc_vfio_pci_table[] =3D {
> +	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_HUAWEI,
> PCI_DEVICE_ID_HUAWEI_SEC_VF) },
> +	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_HUAWEI,
> PCI_DEVICE_ID_HUAWEI_HPRE_VF) },
> +	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_HUAWEI,
> PCI_DEVICE_ID_HUAWEI_ZIP_VF) },
> +	{ }
> +};
> +
> +MODULE_DEVICE_TABLE(pci, hisi_acc_vfio_pci_table);
> +
> +static struct pci_driver hisi_acc_vfio_pci_driver =3D {
> +	.name =3D KBUILD_MODNAME,
> +	.id_table =3D hisi_acc_vfio_pci_table,
> +	.probe =3D hisi_acc_vfio_pci_probe,
> +	.remove =3D hisi_acc_vfio_pci_remove,
> +	.err_handler =3D &vfio_pci_core_err_handlers,
> +};
> +
> +module_pci_driver(hisi_acc_vfio_pci_driver);
> +
> +MODULE_LICENSE("GPL v2");
> +MODULE_AUTHOR("Liu Longfang <liulongfang@huawei.com>");
> +MODULE_AUTHOR("Shameer Kolothum
> <shameerali.kolothum.thodi@huawei.com>");
> +MODULE_DESCRIPTION("HiSilicon VFIO PCI - Generic VFIO PCI driver for
> HiSilicon ACC device family");
> --
> 2.25.1

