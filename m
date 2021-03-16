Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9BC133CF40
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 09:06:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232412AbhCPIFd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 04:05:33 -0400
Received: from mga17.intel.com ([192.55.52.151]:57420 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230435AbhCPIFA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Mar 2021 04:05:00 -0400
IronPort-SDR: KiTcuw0ZjkRdMcUZtUPcM3rUcCmqB7cVa7B44aYxtQkWHk0jIFTNpWMdKk9d8aUh1yyoONscJk
 aAfKBNq2ZmOg==
X-IronPort-AV: E=McAfee;i="6000,8403,9924"; a="169135866"
X-IronPort-AV: E=Sophos;i="5.81,251,1610438400"; 
   d="scan'208";a="169135866"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2021 01:04:59 -0700
IronPort-SDR: 1iLdc7IarRWxQJguj/yHAOrF7M9einclgBSjXKKpvuBSBiu1YMKmmivVAvefRSbDLwYnV/EJfW
 vnmtYIzse1JA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,251,1610438400"; 
   d="scan'208";a="371901277"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga003.jf.intel.com with ESMTP; 16 Mar 2021 01:04:58 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 16 Mar 2021 01:04:58 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Tue, 16 Mar 2021 01:04:58 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Tue, 16 Mar 2021 01:04:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZgiLrR6vWKk9920G/PyjJfnx3PPDoX1nYlHZqq1QKDIOHmRjOecwDzlWi3BXos8aVdu3QE7nYqQ0XN4MEs3eH9Y8zCj1WaroHCMPyag7lsS6s50HiRRXqCtqiwzlIdFkws73scv/KH4Lq5UEUhsEusR23cA4YSWuJdp3iiepixtmpiYcKenjqO9Ld2W8fuH9oEK5ustWugXbY7ILZI9Wr8TFEf2kBUGvYwd3PTi2AVTB2zn7IcdlqgIhVfB/ECgzEtzEN6inrg2YxNABkzmVvuj8eqCDPvMbbRqbsIdQ+WunE+ah0yTyuPkPwwRjkqG5mTvTV6Tc+Ngfahm1Z7LIeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3iYTds+9TxRmZkscAFT+xyO6ZhlFRDQdhjWTlbWz7gY=;
 b=DuqxbY21VA5fWTzmvC/BpLb6GNEm8KjHCJLIhjhEsO2QbCkYHpIvZha5Qd2l000PRU3V3bHM/AyM8lC0T7xl7l5f+fxcQ9ZYoZo08iYvjQNX5uNW9gXdSkiRjlBXXgU6TOmknvaKWhRy+PXPOnb+o0y8piPllMXg2jdEUFQO6ex7N9LQwF2W9R0thBmmHKCbBKUo6cLa5zted7K4lGJ4etUvFyW4eOdmGQgdLIBy0sPQlc8HeW3TKJPwL8nROQ74gjRknESDyniltceKdnua4Jm4B+0ZbrSd71pqMmjiwc0xBhMKDu5xX8YD8J/afJQuOeGXG3VG2kfRZVZtCZHopA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3iYTds+9TxRmZkscAFT+xyO6ZhlFRDQdhjWTlbWz7gY=;
 b=TNjjx65Lm48v5OBsafP3LULcGsPsmYguvT80qOTeqTqpCH5tiNj1DPztY/3T1yAiLRRtem2s0TB1pqcTWhw8cpNN4MTYdaJ3GfEhpSksHfA1+3CTax84HCVxAFg2GGtbB0fhLYI0OMfi0sUjSz0UJ1HWHzjTSdYXiIboPglw5fA=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by MWHPR11MB1664.namprd11.prod.outlook.com (2603:10b6:301:c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Tue, 16 Mar
 2021 08:04:55 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::75b0:a8e9:60cb:7a29]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::75b0:a8e9:60cb:7a29%9]) with mapi id 15.20.3933.032; Tue, 16 Mar 2021
 08:04:55 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Christian Ehrhardt <christian.ehrhardt@canonical.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Eric Auger <eric.auger@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: RE: [PATCH v2 08/14] vfio/pci: Re-order vfio_pci_probe()
Thread-Topic: [PATCH v2 08/14] vfio/pci: Re-order vfio_pci_probe()
Thread-Index: AQHXF6OyKRGb0hKB6UOc45JJMJQlBKqGRKjQ
Date:   Tue, 16 Mar 2021 08:04:55 +0000
Message-ID: <MWHPR11MB1886D4C304FD9C599FD7A8848C6B9@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <0-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
 <8-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
In-Reply-To: <8-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.218]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6b737baf-b24c-4a0b-0478-08d8e8522fc6
x-ms-traffictypediagnostic: MWHPR11MB1664:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB1664F274A5E464278A71FB838C6B9@MWHPR11MB1664.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XefqeX+L5iEJ484xD8rvDbIo+MHQ62yaA6opNyRAuAbwh71BejUI2/LxXDni76dawsFQRwyb4gXc+ec+zPUjIbEY8FeJFQtozgQxedE3cVFVEkk3RNBgZty1+cxslsXpD/EEhBJRj/r4EDWG/z00sUbJURL8WyPoJUtik6gKQqWSaaizjbR50o72UDQ/1Wbx5hSuoQJdSsOqwvJEMeFhdiEH67WfhiWdj7zxGIuevZIhH9RXR41rW64cw/bny2YvYEosq/SN6IczV9xgMemUtkh0jN0gDoDtd1V5BZW7+Qty00HOtSfqxLyvw9uBOUc07SJ5RURKxRp4moN3SkjrSqbph6raHsX02keKTGCOC0IItGIkAoff1aE90GvTmepT+VLMsJzl9/vXxrhMISM2XzSwpGpgDUh/Bw165/md9mtQEIg7IF4io7bXAlv2AM0gOwOa7XPLv1zWG0arbXQw+DCd4pwMpexzpbZaFq09qfc1nNfBkloEQQnv86+TFvt2x8PVH7NHyqTdxdgpqtEA9NG5YxYaWUXe/IUyLMJBar/R9KFZcWHrCdrGVu+58ncEdEwhCELUQz/3F+n3r6vYO2kLoxHsRmnseH2ne9QYw653Z5tPjb4DZbBKwBhCSGOo
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(39860400002)(346002)(396003)(376002)(66556008)(110136005)(7416002)(478600001)(2906002)(66476007)(71200400001)(54906003)(8676002)(316002)(76116006)(186003)(64756008)(86362001)(6506007)(66946007)(5660300002)(52536014)(83380400001)(4326008)(55016002)(26005)(33656002)(7696005)(9686003)(8936002)(66446008)(169823001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?DnCV96YYKG9XtON+UFJswVP7slycH8qksPYg1Dbjub61VyIEJuq/7+KaBJD0?=
 =?us-ascii?Q?bIKYt+ggx9YbCtA1MPLqZN9r0ZVf7u1x4ICS4FekMUdtaOjBvvXh0RUwHAJx?=
 =?us-ascii?Q?ec7RUfhxKfNYxzwE5ToIFdfbh5z2mxzZgB9FlEsDrIxrT5JrWPDCY3/znVCl?=
 =?us-ascii?Q?FR0XaLJwEh+nGO+76NvzObZzjAo20sC7SAYEyKrLEGwQhaXDoK2lXWA8tfwu?=
 =?us-ascii?Q?r1W+CiNAQL4p/MEueFuNlzYmEk15+QS4AlXQJWfGTFdBRnyLmRyUqhQm1EUZ?=
 =?us-ascii?Q?YtyyADcBq3cehsHPxydEM0ayWJHFWbQiwYj90U9zRqXn2oPMf+Cd17DTnbfO?=
 =?us-ascii?Q?6or6xIe0xGQ+ydpcDbpFbH/EX+N/7EH6UQ9YjU6yYlXepjdELV7aLBATTKUK?=
 =?us-ascii?Q?P5xBqdA5gUwxiOekbqXBoK1cH9CqskMwV0+60Mfjvorr9QfAa3L8z2h6pWsl?=
 =?us-ascii?Q?lZt5HkPLo+87DU12VAxEuRbmY0D9069ywCVEYhEr2JVHvWpK9CX8aMXhphja?=
 =?us-ascii?Q?l88WvYNTTph2ALsbYrXYErrWI+F4nCGPPs2/3bbWYtI8EVMqAyuj9Edg2CYQ?=
 =?us-ascii?Q?D4lBbsHvxjKTJzVn+mwVBbYCWkAdBs8r0GPM6Cvt4zMk7m8Phvl8iSVhUikY?=
 =?us-ascii?Q?iB2U4mqT3f4A/RJzgmnOsXR6pmdo7TDPYqCAObFK61HU5IdWQf75i5HwwTAJ?=
 =?us-ascii?Q?htNvvBe7S1gqzDnaqZjcsxY7yP3B6VEXNP004tdWf85BBsxbMSAWuqGHOlhW?=
 =?us-ascii?Q?c1xcEN5tBJ1GwXwbsRQZ+eNkcHPlzgZjsCaCZO/ZG95wAvvcQYprS0f9NLN1?=
 =?us-ascii?Q?z8IviSar9PjvOwjf+NklOqiKh8r8YYkgWCodorbG1RIeTqbbjpRdOK1kUSU6?=
 =?us-ascii?Q?4sZ+NrAwQkaC5yE8c6Shj6IJYnmTrblhSGf2Ga+KwWw86Kiw3DVD56pZ1Egw?=
 =?us-ascii?Q?gu68lJKjCV/wJHNVOvsqwdGjSQD3z4A1m1YgjOiKUryEwsMEsBUGseZ4QeY9?=
 =?us-ascii?Q?CHjGElES0PGfJAI9H6S38p0uydrfb/apWNT+7yENqBJ9O/DLbVEuKL0TMBbM?=
 =?us-ascii?Q?El0MiquWhaEIV8zNM90MTEZkwMFr63OF8fXNO+J36SKKoveXJWbrUxGgc+E1?=
 =?us-ascii?Q?GNQN5X4KK8oTHyUPbcV92Z5n5t7f+EI6G/KiHOJQ9R+M/OxbJ6PVcH2moof/?=
 =?us-ascii?Q?P8qGSUYJI1JuccSaG+z6RlBvz+5rHErm+CppWm12do0tC9MYttoZUUfgrn6M?=
 =?us-ascii?Q?6kKk2doNYciFJd3HrnuJlv0GsJ/yVq+4C0IZDapxgVb/LIUbmjDr5qI26XU9?=
 =?us-ascii?Q?EBN8RaMQf7Z1mRIafcB/5rN4?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b737baf-b24c-4a0b-0478-08d8e8522fc6
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2021 08:04:55.8194
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tJlxNNw7RkRgW8aAMm2uMsu680tU8mSrGdTsJG93YkcQoBHX4B6/Or7z21KDHNmCs9/r/1jtVbFgn+kHUKv4dA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1664
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Saturday, March 13, 2021 8:56 AM
>=20
> vfio_add_group_dev() must be called only after all of the private data in
> vdev is fully setup and ready, otherwise there could be races with user
> space instantiating a device file descriptor and starting to call ops.
>=20
> For instance vfio_pci_reflck_attach() sets vdev->reflck and
> vfio_pci_open(), called by fops open, unconditionally derefs it, which
> will crash if things get out of order.
>=20
> Fixes: cc20d7999000 ("vfio/pci: Introduce VF token")
> Fixes: e309df5b0c9e ("vfio/pci: Parallelize device open and release")
> Fixes: 6eb7018705de ("vfio-pci: Move idle devices to D3hot power state")
> Fixes: ecaa1f6a0154 ("vfio-pci: Add VGA arbiter client")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_pci.c | 17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index f95b58376156a0..0e7682e7a0b478 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -2030,13 +2030,9 @@ static int vfio_pci_probe(struct pci_dev *pdev,
> const struct pci_device_id *id)
>  	INIT_LIST_HEAD(&vdev->vma_list);
>  	init_rwsem(&vdev->memory_lock);
>=20
> -	ret =3D vfio_add_group_dev(&pdev->dev, &vfio_pci_ops, vdev);
> -	if (ret)
> -		goto out_free;
> -
>  	ret =3D vfio_pci_reflck_attach(vdev);
>  	if (ret)
> -		goto out_del_group_dev;
> +		goto out_free;
>  	ret =3D vfio_pci_vf_init(vdev);
>  	if (ret)
>  		goto out_reflck;
> @@ -2060,15 +2056,20 @@ static int vfio_pci_probe(struct pci_dev *pdev,
> const struct pci_device_id *id)
>  		vfio_pci_set_power_state(vdev, PCI_D3hot);
>  	}
>=20
> -	return ret;
> +	ret =3D vfio_add_group_dev(&pdev->dev, &vfio_pci_ops, vdev);
> +	if (ret)
> +		goto out_power;
> +	return 0;
>=20
> +out_power:
> +	if (!disable_idle_d3)
> +		vfio_pci_set_power_state(vdev, PCI_D0);

Just curious whether the power state must be recovered upon failure here.
From the comment several lines above, the power state is set to an unknown
state before doing D3 transaction. From this point it looks fine if leaving=
 the
device in D3 since there is no expected state to be recovered?

>  out_vf:
>  	vfio_pci_vf_uninit(vdev);
>  out_reflck:
>  	vfio_pci_reflck_put(vdev->reflck);
> -out_del_group_dev:
> -	vfio_del_group_dev(&pdev->dev);
>  out_free:
> +	kfree(vdev->pm_save);
>  	kfree(vdev);
>  out_group_put:
>  	vfio_iommu_group_put(group, &pdev->dev);
> --
> 2.30.2

