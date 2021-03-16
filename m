Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0832A33CF07
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 08:58:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233524AbhCPH6C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 03:58:02 -0400
Received: from mga09.intel.com ([134.134.136.24]:39633 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233655AbhCPH5b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Mar 2021 03:57:31 -0400
IronPort-SDR: wBooWHQdqAv8dCLr/We7KX2w1sr5LE8CjAwGqFLd5Nz31+RlAa2KGlUvbt+0E8h5sm2jYYDOs3
 rYlSm7PnyyZA==
X-IronPort-AV: E=McAfee;i="6000,8403,9924"; a="189309746"
X-IronPort-AV: E=Sophos;i="5.81,251,1610438400"; 
   d="scan'208";a="189309746"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2021 00:57:30 -0700
IronPort-SDR: UslB5men8gBesWKBcphiuufgxYwiO/8d5SohzJ820q0Fsw3HVyPX03RwsVrnB7XckjVTRxAjKF
 p1nqWeLVbvoA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,251,1610438400"; 
   d="scan'208";a="373710177"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga006.jf.intel.com with ESMTP; 16 Mar 2021 00:57:27 -0700
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 16 Mar 2021 00:57:25 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Tue, 16 Mar 2021 00:57:25 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Tue, 16 Mar 2021 00:57:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SuxMVxc4lqQCHysH7UVo6lEx6C9xdeI8cqlWiLgA7xoPrJDnzwau3zSUwWOp5OpQgtis2uLEmfJ0Im2fW4Y3zldKGOXdnV5iOHvCl3MCfhnGtXQFfgjs3HGioCVtx5j2S1hgdi2WKGk1Oi0a2PXgwRNfrvd/6SVGPwRpu9l81qz3Pr95iMu5OUA+6Xi4NTfyCQ2OD9K3rgRi2p3jm8DpzEeIMgBr7QLUkNLLKKEG7MeeSj7e9i5OKE8z8dgleyH+Z6KuW+Ob+yH4ErBsmpMLqtxD+830DqbcecT8KrUuWlCxqroQRJVevB1XGYFcbG9GgZcBNLujuyrWnvBPqunnfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gD0Gt6g79OqECASK5tFiZcDCGTUHGTfp9q4rJX6VRhk=;
 b=JfT3hdEtrTdNvYKILW4u/q6XZ/z2DW/rSd5hHBAiZyY6ViCiGtCDx0Fk+Bilvm4rJqnGQs3c1QZ6fzD5wibPBz2SDVa3qTeGRT12snDiwZzjscB8VzijXcIV89/nSrw+KYMnj+QijzhFK3yGQ3jqClncKh4aaCgoKSE8T5eOGHFaFtF+n3UiD7LMPPOeSTmql10VmEdeH6ILMKtrWTONdKn08sMXoUo8ueJ0eNDaCWsNhWufSnVsPv8+X5yHmOzoPFLBBZc/t7qutx3LOyHvreh9HagZ6iX+kVFmS696O7cuZPojnnxGsUf0XtpUlJzzbrrKTlT6D8T/vj+0lxo1vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gD0Gt6g79OqECASK5tFiZcDCGTUHGTfp9q4rJX6VRhk=;
 b=nzxmMeeJbCzOuug2MNCs3hCKdjeYNYZ3oUCc6wuyRNf0czNPM1JNWeHY4yY2ehfK9UryVCspRQYXZFIX8faj5coWbO1QgZQ7GSZAOz4zY2e6/gcBCSolg2uYEUFjebU4olgku8+2e1b9J3Ydluv/JNCl7yNKyBMOLnzk3+nyCug=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by CO1PR11MB5154.namprd11.prod.outlook.com (2603:10b6:303:95::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Tue, 16 Mar
 2021 07:57:03 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::75b0:a8e9:60cb:7a29]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::75b0:a8e9:60cb:7a29%9]) with mapi id 15.20.3933.032; Tue, 16 Mar 2021
 07:57:03 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Daniel Vetter" <daniel@ffwll.ch>, Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: RE: [PATCH v2 07/14] vfio/pci: Move VGA and VF initialization to
 functions
Thread-Topic: [PATCH v2 07/14] vfio/pci: Move VGA and VF initialization to
 functions
Thread-Index: AQHXF6THCnMzZdTZwkOXUwvt9d57PaqGRH5g
Date:   Tue, 16 Mar 2021 07:57:03 +0000
Message-ID: <MWHPR11MB18861C364538C47085E26B858C6B9@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <0-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
 <7-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
In-Reply-To: <7-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
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
x-ms-office365-filtering-correlation-id: bb0b1748-2b1a-4db8-c8b0-08d8e8511628
x-ms-traffictypediagnostic: CO1PR11MB5154:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO1PR11MB5154543FBAAB86684AEEF2FE8C6B9@CO1PR11MB5154.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2guFjZOqDNz3sMuR2+jyxKgnYzFoy8VtCah25p8ofWL7IyB8GUGMUlu10cjRDkaop2VjtnAKFx+ihtpTD+2Mu1+CAlkK+leW2WwfJHGHP4T4FMLTZ1SRf0/B/Tbx5+elMaHjonUuNgyJc3ApAwaVzG+MoOB9v5h67r7OFaCCtkfe+Glv/Wl3xpqKCgBlX4trywjMd11rfHpKwCtUvp7IOKET47NAQYoJ1uhbR8bpQ/SgHeLXH5FuKlSoaSirIzRi7cjj/4cz2IoqtvPM5re5qHPn/RY9oV4/KUJJIcdvQeM8h7MwIFMHKA0teiGi/t7NPVkCW6OOtvElwK3q1FzSVivYjPwRWGrGjDEZMytf25auMNRruTdr7b1CatY8xeN0wmwiN6YpnNeM/c97EsLt5QN6HRw+t8EJi7TOD5sP7ZhTCz2zOuO+XFyeNY7LceXPLMOY/x1rnGWJH9pr1GLKMzkMqLa8+Dd9FWoiKXUL/HO8wy2CLxEBkhGp95QpdmYrKbAxgvtHoIhLl3icsNJ5KYOHeL1KA4tmajXqoVrUwwxrco1VZ75R2WAFx9JrdDAh
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(366004)(396003)(346002)(376002)(6506007)(5660300002)(2906002)(26005)(186003)(64756008)(7696005)(54906003)(7416002)(71200400001)(66446008)(55016002)(76116006)(4326008)(83380400001)(9686003)(86362001)(478600001)(110136005)(66476007)(66556008)(8676002)(52536014)(66946007)(33656002)(8936002)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?PfIjjVq7riwCCivuRr/fm9j9tflvc5VRkHfEyHkz6k87U35aCkcRxIU9LBXN?=
 =?us-ascii?Q?0Jc1+asu0d1iIuLaLsHRLvzv9MC5E91mJJppVR/Nh/F40d68VJLpIqC+0hFB?=
 =?us-ascii?Q?OaKGMdTccGuznU8QwdUbHNaDuDiiSXB/jGMpgJYwX19kRH7/5Z5UwfCSAVH4?=
 =?us-ascii?Q?C7HU1Jqe16jW/8K2EXgZgRxGmVFCvWy3pO1ni33hBylF7PSVFxei5mj+XOA3?=
 =?us-ascii?Q?QT+iQYB7AuFW1+QlfezLOkxx4kv+ND2XsU9oX2vVZd1GCcCrOM0lUai1pP9c?=
 =?us-ascii?Q?8sdGwbuJaEHRLKGZHO67wMUrbKMfwulyWfp2na3px6FTIO/228+ft10wyyxO?=
 =?us-ascii?Q?oxAfLn84XytPWUu0oFyWwJBpsta4AIgLL2W/bv0rhpYNM7x2gVnGkrT0W18G?=
 =?us-ascii?Q?Ryg/S0nNd6kVbqUpF6URlAo9pFDU9neBeGX5fDMf2XYGwEZtKiP5vSClLLkG?=
 =?us-ascii?Q?5Ud1e2C3IMdvmf2idfBm3WyrhrgVWv+KAFTtDG5H7rkBJRGrW5bojqu3h2sQ?=
 =?us-ascii?Q?hEIc5kBPzHwZQptTpiXdsK65OLiSZ679ij5tQtlwxh6bTntZjTd8nncJkF5u?=
 =?us-ascii?Q?RZriMzdpbYueDSVKe9u4mqj0rlnMaMf5kjYNCVD46Hd2Ncxro9sfd5z/rn1U?=
 =?us-ascii?Q?iZUCFwV0vRl47xztzpEH3Ta0GsObGqN/EyfuKdWtkRg1tyW5jDYXnotfW411?=
 =?us-ascii?Q?H2VVQcBRG5KHLQOp/1jJT7L3jZMqWLBacP8zrX6nYQ9lJVyiGnBjTpzJoMM+?=
 =?us-ascii?Q?xA6Wf8nVnQ+HJSDU/XepHQ6X5mcEyYAsLu/1+DE7n9rdXwUCh/cFouiGYcvb?=
 =?us-ascii?Q?49jzZZHARa0vJn5pvSSHdjxkrBjS1igxrvma+m03xT/ovXxsPO9e4gIIER89?=
 =?us-ascii?Q?4+4zcOqy6klnF+8jRexcUsJYtjNUuFHhQg1Ul+7ziMlQE5n5qSwgwYNFnP+I?=
 =?us-ascii?Q?45EtIugUDnd1EZhqt48HIMYg+eQWuU5qJBoib6bl45dQc6BllhVQDVZCYyBF?=
 =?us-ascii?Q?mENN+z9cJ4qNz1gAvbMuOizdytyUM2PJ3EFb/3a+et0MCI9ggRcICaPdlcek?=
 =?us-ascii?Q?RvXWBbzjkdXkfca3g9jXqagqcrJNBslLC87cJx4k8iflr7Sr5l4tYxxEMxjR?=
 =?us-ascii?Q?wXN82kEC937iF9xqpV+Zzd2dKQ5ZCexgzJdILn7m7E5ak+dzg4GfVreKkF4D?=
 =?us-ascii?Q?ccdnDA82doWjuJZPfh7C0DykWWM8R8eTJIk9kcel5LzMoiM4/g521Oyg66ww?=
 =?us-ascii?Q?+JJWDWA84SSoaTndYN1wplNmEi2FYbIPu//h1DVwaLpxQF7njm5xpn71zv6Y?=
 =?us-ascii?Q?NqI2IIn7+wP1x2hd5XQ9NPp6?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb0b1748-2b1a-4db8-c8b0-08d8e8511628
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2021 07:57:03.3302
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2D3wwbpViO21QoLKZ6mcVXd1ClpzhKwSg9FhFNVy9l+Ya8i2+06Oq5IFwjm3tUbNzD1OVjSTK8MgXi27E6yndw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5154
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Saturday, March 13, 2021 8:56 AM
>=20
> vfio_pci_probe() is quite complicated, with optional VF and VGA sub
> components. Move these into clear init/uninit functions and have a linear
> flow in probe/remove.
>=20
> This fixes a few little buglets:
>  - vfio_pci_remove() is in the wrong order, vga_client_register() removes
>    a notifier and is after kfree(vdev), but the notifier refers to vdev,
>    so it can use after free in a race.
>  - vga_client_register() can fail but was ignored
>=20
> Organize things so destruction order is the reverse of creation order.
>=20
> Fixes: ecaa1f6a0154 ("vfio-pci: Add VGA arbiter client")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

> ---
>  drivers/vfio/pci/vfio_pci.c | 116 +++++++++++++++++++++++-------------
>  1 file changed, 74 insertions(+), 42 deletions(-)
>=20
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index 65e7e6b44578c2..f95b58376156a0 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -1922,6 +1922,68 @@ static int vfio_pci_bus_notifier(struct
> notifier_block *nb,
>  	return 0;
>  }
>=20
> +static int vfio_pci_vf_init(struct vfio_pci_device *vdev)
> +{
> +	struct pci_dev *pdev =3D vdev->pdev;
> +	int ret;
> +
> +	if (!pdev->is_physfn)
> +		return 0;
> +
> +	vdev->vf_token =3D kzalloc(sizeof(*vdev->vf_token), GFP_KERNEL);
> +	if (!vdev->vf_token)
> +		return -ENOMEM;
> +
> +	mutex_init(&vdev->vf_token->lock);
> +	uuid_gen(&vdev->vf_token->uuid);
> +
> +	vdev->nb.notifier_call =3D vfio_pci_bus_notifier;
> +	ret =3D bus_register_notifier(&pci_bus_type, &vdev->nb);
> +	if (ret) {
> +		kfree(vdev->vf_token);
> +		return ret;
> +	}
> +	return 0;
> +}
> +
> +static void vfio_pci_vf_uninit(struct vfio_pci_device *vdev)
> +{
> +	if (!vdev->vf_token)
> +		return;
> +
> +	bus_unregister_notifier(&pci_bus_type, &vdev->nb);
> +	WARN_ON(vdev->vf_token->users);
> +	mutex_destroy(&vdev->vf_token->lock);
> +	kfree(vdev->vf_token);
> +}
> +
> +static int vfio_pci_vga_init(struct vfio_pci_device *vdev)
> +{
> +	struct pci_dev *pdev =3D vdev->pdev;
> +	int ret;
> +
> +	if (!vfio_pci_is_vga(pdev))
> +		return 0;
> +
> +	ret =3D vga_client_register(pdev, vdev, NULL, vfio_pci_set_vga_decode);
> +	if (ret)
> +		return ret;
> +	vga_set_legacy_decoding(pdev, vfio_pci_set_vga_decode(vdev,
> false));
> +	return 0;
> +}
> +
> +static void vfio_pci_vga_uninit(struct vfio_pci_device *vdev)
> +{
> +	struct pci_dev *pdev =3D vdev->pdev;
> +
> +	if (!vfio_pci_is_vga(pdev))
> +		return;
> +	vga_client_register(pdev, NULL, NULL, NULL);
> +	vga_set_legacy_decoding(pdev, VGA_RSRC_NORMAL_IO |
> VGA_RSRC_NORMAL_MEM |
> +					      VGA_RSRC_LEGACY_IO |
> +					      VGA_RSRC_LEGACY_MEM);
> +}
> +
>  static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_=
id *id)
>  {
>  	struct vfio_pci_device *vdev;
> @@ -1975,28 +2037,12 @@ static int vfio_pci_probe(struct pci_dev *pdev,
> const struct pci_device_id *id)
>  	ret =3D vfio_pci_reflck_attach(vdev);
>  	if (ret)
>  		goto out_del_group_dev;
> -
> -	if (pdev->is_physfn) {
> -		vdev->vf_token =3D kzalloc(sizeof(*vdev->vf_token),
> GFP_KERNEL);
> -		if (!vdev->vf_token) {
> -			ret =3D -ENOMEM;
> -			goto out_reflck;
> -		}
> -
> -		mutex_init(&vdev->vf_token->lock);
> -		uuid_gen(&vdev->vf_token->uuid);
> -
> -		vdev->nb.notifier_call =3D vfio_pci_bus_notifier;
> -		ret =3D bus_register_notifier(&pci_bus_type, &vdev->nb);
> -		if (ret)
> -			goto out_vf_token;
> -	}
> -
> -	if (vfio_pci_is_vga(pdev)) {
> -		vga_client_register(pdev, vdev, NULL,
> vfio_pci_set_vga_decode);
> -		vga_set_legacy_decoding(pdev,
> -					vfio_pci_set_vga_decode(vdev,
> false));
> -	}
> +	ret =3D vfio_pci_vf_init(vdev);
> +	if (ret)
> +		goto out_reflck;
> +	ret =3D vfio_pci_vga_init(vdev);
> +	if (ret)
> +		goto out_vf;
>=20
>  	vfio_pci_probe_power_state(vdev);
>=20
> @@ -2016,8 +2062,8 @@ static int vfio_pci_probe(struct pci_dev *pdev,
> const struct pci_device_id *id)
>=20
>  	return ret;
>=20
> -out_vf_token:
> -	kfree(vdev->vf_token);
> +out_vf:
> +	vfio_pci_vf_uninit(vdev);
>  out_reflck:
>  	vfio_pci_reflck_put(vdev->reflck);
>  out_del_group_dev:
> @@ -2039,33 +2085,19 @@ static void vfio_pci_remove(struct pci_dev
> *pdev)
>  	if (!vdev)
>  		return;
>=20
> -	if (vdev->vf_token) {
> -		WARN_ON(vdev->vf_token->users);
> -		mutex_destroy(&vdev->vf_token->lock);
> -		kfree(vdev->vf_token);
> -	}
> -
> -	if (vdev->nb.notifier_call)
> -		bus_unregister_notifier(&pci_bus_type, &vdev->nb);
> -
> +	vfio_pci_vf_uninit(vdev);
>  	vfio_pci_reflck_put(vdev->reflck);
> +	vfio_pci_vga_uninit(vdev);
>=20
>  	vfio_iommu_group_put(pdev->dev.iommu_group, &pdev->dev);
> -	kfree(vdev->region);
> -	mutex_destroy(&vdev->ioeventfds_lock);
>=20
>  	if (!disable_idle_d3)
>  		vfio_pci_set_power_state(vdev, PCI_D0);
>=20
> +	mutex_destroy(&vdev->ioeventfds_lock);
> +	kfree(vdev->region);
>  	kfree(vdev->pm_save);
>  	kfree(vdev);
> -
> -	if (vfio_pci_is_vga(pdev)) {
> -		vga_client_register(pdev, NULL, NULL, NULL);
> -		vga_set_legacy_decoding(pdev,
> -				VGA_RSRC_NORMAL_IO |
> VGA_RSRC_NORMAL_MEM |
> -				VGA_RSRC_LEGACY_IO |
> VGA_RSRC_LEGACY_MEM);
> -	}
>  }
>=20
>  static pci_ers_result_t vfio_pci_aer_err_detected(struct pci_dev *pdev,
> --
> 2.30.2

