Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E9233F80DC
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 05:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231530AbhHZDMv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 23:12:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:27166 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229533AbhHZDMs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 23:12:48 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10087"; a="217658755"
X-IronPort-AV: E=Sophos;i="5.84,352,1620716400"; 
   d="scan'208";a="217658755"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2021 20:12:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,352,1620716400"; 
   d="scan'208";a="686769106"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by fmsmga005.fm.intel.com with ESMTP; 25 Aug 2021 20:12:01 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Wed, 25 Aug 2021 20:12:00 -0700
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Wed, 25 Aug 2021 20:12:00 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Wed, 25 Aug 2021 20:12:00 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Wed, 25 Aug 2021 20:11:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PD0paexytEEcXOjzG/EpmVtJnL1U5nkVYX1wrs1Lr3gRBZ/PPVWyGyDp56ull43Tuuc05S3dlI1kLiEV42zVfAQUjwFLA+b8/Z0XE0osugY/IZE7IuVHkUaWoJpeYNmMT4qZOt1ha/ZNH5hLWeI8ZLuC5c9x3Gm3nxgyGo6O1UxuOp2VjArDlwvQvK1K6bq4gPXak+dZcxu5n0X3EWqJ19RDLMKLhHz1ezRETL2ExPJQtQJn+JgIjUU4335LKfeyo5r1XANACPKUjqGoAEMvFpaSKpDkR4ttAhmkt6Nv1HyWQ7jTLvlTergVsnnw1FmNEqnzVpSG9GjRZ9ifYLHMHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dsm3azaliRYLGrtfAqZ8JP/Q8A79q1pdCX2AAuRgcd4=;
 b=nqs2PPRWf8vO1sz2ruSaDwEin9Qwj/5d6lpWq4beZtTRBgVrRkJU3BLs8j8l905CfdD4vfkvZkVCXlqrzzrR2mmS5/Gw1KSMOG3m+qLDaRad2HYh8G5xHHCUDv2M0y3bc1gjw25Lo7acSVU/8b6XeCYCaXt8LvwsaTwm4aTwryvWNRBDWqQuQAf4CoWeh0V4EwvOxoWHQNvwbDbgqhrrS8eCa6hoER6tuw54FaEbuYtaQI9V9omTEYFXXdXYxgf5uCrwXusNWNBgQ1U12y/zmKbijMHzrBjq7RwU3SdVaDI/PMQ/qxi68SbJNeXvdpPudvb/F6c923Pn0odhre8pXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dsm3azaliRYLGrtfAqZ8JP/Q8A79q1pdCX2AAuRgcd4=;
 b=s29HbtllnrvgIW/uAtUaFMv4jli18J4ngrasXcnRWTs8KeOik76JXG/MlpTmQqoBLDb9BZMBtb84isMvWdjTyDXSy4F7LuzWgGHTCJglifljfBH2aC8NKphIGBvlYzAqm91lsBd7hlHRtiBlsamV7yB0j/IWFuzreA7wyFVvjB8=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN0PR11MB5709.namprd11.prod.outlook.com (2603:10b6:408:148::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17; Thu, 26 Aug
 2021 03:11:58 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::1508:e154:a267:2cce]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::1508:e154:a267:2cce%5]) with mapi id 15.20.4436.024; Thu, 26 Aug 2021
 03:11:58 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Christoph Hellwig <hch@lst.de>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: RE: [PATCH 08/14] vfio: remove unused method from
 vfio_iommu_driver_ops
Thread-Topic: [PATCH 08/14] vfio: remove unused method from
 vfio_iommu_driver_ops
Thread-Index: AQHXmc7If1iu1TUDdUK8q0Wmh7V42KuFHD1g
Date:   Thu, 26 Aug 2021 03:11:58 +0000
Message-ID: <BN9PR11MB5433556BAA255D41E7966B2F8CC79@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210825161916.50393-1-hch@lst.de>
 <20210825161916.50393-9-hch@lst.de>
In-Reply-To: <20210825161916.50393-9-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ce0c09ac-d169-40a8-1953-08d9683f43ee
x-ms-traffictypediagnostic: BN0PR11MB5709:
x-microsoft-antispam-prvs: <BN0PR11MB57090B029E4E86E9C30DE3FA8CC79@BN0PR11MB5709.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:489;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wtK9bpy5GAKVIIfw4BvXbpZpieFlEHqIypiD7j/DQMFuyjP9t811zsFeZgyCDIjIRvWfiq8j+PDnafBXTJSj6xgtGBQM95woBSPys+Hea8cnSj0GOWX0XF1SnkTN1RjQAwiq8ePw+7kRJoFX95UrhEdyZ+WgjwmTPOdwNc13Xpq78rKM/7i0SHRwHz6h4FKcB0O+h3clruJdQiyPfeKUdv2JhJaAtwlmtBRVuWkyTDSgUrmjfYUiRd81rTHcemEzEVc/8jXibb4bk72jvFLGKi9PytFXbDDfzSVJnC8CMh6IbJxnsl568Oijg2MCge1vxVripsqZzeQedfHKQwT7G3ZZ+g91Bz5TazbVHyLKSgWwb01ppOjz56tSltQ65FNjvEtRCoZ2BptzXQ9wd4gJ0aJuKb74iSSW9r/85uJobyRbUOdXFqOzjjf850Hzxz5vCFVlJuz07bz1wFJesVJ0QhTXENwecOHiZTIQRB8txSEpU84iWST5HvK9gul4XfWD3r9XPl6XIXtm+9o8O7Sj6+WiCzFr8tbycIrZEQeOA7vCfrLOvqV9eh3GfOAi1YcI/XmqbQdtVhV/FIlk8wrGPs964unlNrcss6R5GS/q76trYSVErwHsJfFK99J7i968mqLhVQlAyA5tL+sWfsHLmY1g87NWblP1I8OmFHFiI9h6YB+hDutEwpPRSGslp/nKQOMdOEg1rIv1BOsTKj48HA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(346002)(396003)(376002)(39860400002)(8676002)(76116006)(33656002)(26005)(66946007)(8936002)(86362001)(110136005)(316002)(83380400001)(54906003)(186003)(6506007)(7696005)(55016002)(9686003)(2906002)(4326008)(122000001)(38100700002)(478600001)(66446008)(66476007)(5660300002)(52536014)(64756008)(71200400001)(38070700005)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?mK7JQEM6nWE+TLfi6RRcJdVYSiXiIzcvO97Rw3Pl+sDZYppBDjSgR5ujVjC6?=
 =?us-ascii?Q?OBGqWA4mDZ8s5cuDjZSG9IUYOFhSRc1KYgx8VSLMh3G17trtyyN1KLD9T2jr?=
 =?us-ascii?Q?x+Ni2vR4JRJ0X7M+gtSEPHl5rQHSxnSDQURs00ObeaO5jWvKMwtCAQA3/eB7?=
 =?us-ascii?Q?nKUXinorpglxa3CFaLPk0XgQLiSf4Uj04owm8YkySxA6jgD9ZBJQfJsYP5pa?=
 =?us-ascii?Q?xSW8h3+uHUn48VP0ySo4uxBOL1yfFA5URukBOOxI6pUBg4GL3q8911iOtkKI?=
 =?us-ascii?Q?bi9OWCpQ5/ucWmTx32s8rF7qMZ8vE50v80n6tHTrtHcIHG8sVzqBpf9rxTbZ?=
 =?us-ascii?Q?wG1Oq6jwd0E02SBXqqa576FW3pOeTMx9nFWnliBxwiEL16INNyqUpy0lE02Y?=
 =?us-ascii?Q?cPOfhQxOUMaee8ZAZXDr6ikSczjfWQNyRSdxkv2oexFhBmKZPqFdENRQi5jr?=
 =?us-ascii?Q?5QUQfizFH2DeqHoplOmk/LONMlGMlYjfKzNKxSgj9wD7lUQc26Za8Gjkp+sj?=
 =?us-ascii?Q?NoxwqONBBJJvNTiPwevic0XHAdqkOf9n3lr7MX/UUZqvNeeODkUmaSRo7LxM?=
 =?us-ascii?Q?HoZWF9Mo4zorB9qT87hUIIZoQeAJpDdv+ROKO+7eW9eBXzPGMuO1nds5aYtQ?=
 =?us-ascii?Q?hNGLBbHaB15QQghy9Xu7kuTPbMb/Jn7VYa1fzURjhlaonUKpiKe7LC+DrtmB?=
 =?us-ascii?Q?X3ytP8+ux8P79BfmxP/y/V2Lk4O71R2UVj3gsWRlQkvTU6bQay/PT1yU1AZn?=
 =?us-ascii?Q?KvYZPoU9QrXFXTBG3XRm5OBDKsmjTNAkXxPHWgp0i9GTyf5EblHdm7MjrNFK?=
 =?us-ascii?Q?XSZjl0t2VqoqoQlh2NoKaOxpf/S8hHuVvBRh73FxlabFG3PHt/rU18+GlFcQ?=
 =?us-ascii?Q?gdYcDkBFg4tXm/0XTaCdCz950BAMnmSa3C+/S3wj0S9Uq9z1xo9uDk1ZO+SU?=
 =?us-ascii?Q?WursMPRLJ/lq0qiXTuiyEsvlvWLNhpJCgrH9qwpEMRGhfMR6Tem5XApWh9nO?=
 =?us-ascii?Q?drWsOjuNoCYQEePwNUCuwpwq+pzVuTJKZz23Wb0/6EJ24JnqamZgg0ylaVwN?=
 =?us-ascii?Q?D27+c04qbTOTObA9YHxX4WeFwz6prvFZWKj+8A1148+CBKruAiZTkgSyUiF6?=
 =?us-ascii?Q?PVM+sPp4VBbHBXuG613F7wjnYUa93LFHKS6dtLC7izfP4kNmFUWRGmtoREFx?=
 =?us-ascii?Q?eLUuy1K4TQE1LCeN66Tm0vsN6lXSrerTPGk77CgPeCQADceR8OX2yGTcIUl7?=
 =?us-ascii?Q?PDcIAYIDkdI5/AKRUGEf17lKGQwcp7M+oHhhW4tI05n8uKI7Z2itLQmvjWOi?=
 =?us-ascii?Q?7kR7Jp/MICONX7FKkoHp+ym1?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce0c09ac-d169-40a8-1953-08d9683f43ee
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2021 03:11:58.0854
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 66gojCGqoOjkIjEZZURztj1p9wmAop3gxnPkmrqHU4rclZrHqHhNgR+YhpgVBfd7ZcsqBRLZKf8XBS1xzWEYxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR11MB5709
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Christoph Hellwig <hch@lst.de>
> Sent: Thursday, August 26, 2021 12:19 AM
>=20
> The read, write and mmap methods are never implemented, so remove
> them.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

> ---
>  drivers/vfio/vfio.c  | 50 --------------------------------------------
>  include/linux/vfio.h |  5 -----
>  2 files changed, 55 deletions(-)
>=20
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 6bdfcb9264458c..7b9629cbbf0e80 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -1252,62 +1252,12 @@ static int vfio_fops_release(struct inode *inode,
> struct file *filep)
>  	return 0;
>  }
>=20
> -/*
> - * Once an iommu driver is set, we optionally pass read/write/mmap
> - * on to the driver, allowing management interfaces beyond ioctl.
> - */
> -static ssize_t vfio_fops_read(struct file *filep, char __user *buf,
> -			      size_t count, loff_t *ppos)
> -{
> -	struct vfio_container *container =3D filep->private_data;
> -	struct vfio_iommu_driver *driver;
> -	ssize_t ret =3D -EINVAL;
> -
> -	driver =3D container->iommu_driver;
> -	if (likely(driver && driver->ops->read))
> -		ret =3D driver->ops->read(container->iommu_data,
> -					buf, count, ppos);
> -
> -	return ret;
> -}
> -
> -static ssize_t vfio_fops_write(struct file *filep, const char __user *bu=
f,
> -			       size_t count, loff_t *ppos)
> -{
> -	struct vfio_container *container =3D filep->private_data;
> -	struct vfio_iommu_driver *driver;
> -	ssize_t ret =3D -EINVAL;
> -
> -	driver =3D container->iommu_driver;
> -	if (likely(driver && driver->ops->write))
> -		ret =3D driver->ops->write(container->iommu_data,
> -					 buf, count, ppos);
> -
> -	return ret;
> -}
> -
> -static int vfio_fops_mmap(struct file *filep, struct vm_area_struct *vma=
)
> -{
> -	struct vfio_container *container =3D filep->private_data;
> -	struct vfio_iommu_driver *driver;
> -	int ret =3D -EINVAL;
> -
> -	driver =3D container->iommu_driver;
> -	if (likely(driver && driver->ops->mmap))
> -		ret =3D driver->ops->mmap(container->iommu_data, vma);
> -
> -	return ret;
> -}
> -
>  static const struct file_operations vfio_fops =3D {
>  	.owner		=3D THIS_MODULE,
>  	.open		=3D vfio_fops_open,
>  	.release	=3D vfio_fops_release,
> -	.read		=3D vfio_fops_read,
> -	.write		=3D vfio_fops_write,
>  	.unlocked_ioctl	=3D vfio_fops_unl_ioctl,
>  	.compat_ioctl	=3D compat_ptr_ioctl,
> -	.mmap		=3D vfio_fops_mmap,
>  };
>=20
>  /**
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index bbe29300862649..7a57a0077f9637 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -95,13 +95,8 @@ struct vfio_iommu_driver_ops {
>  	struct module	*owner;
>  	void		*(*open)(unsigned long arg);
>  	void		(*release)(void *iommu_data);
> -	ssize_t		(*read)(void *iommu_data, char __user *buf,
> -				size_t count, loff_t *ppos);
> -	ssize_t		(*write)(void *iommu_data, const char __user *buf,
> -				 size_t count, loff_t *size);
>  	long		(*ioctl)(void *iommu_data, unsigned int cmd,
>  				 unsigned long arg);
> -	int		(*mmap)(void *iommu_data, struct vm_area_struct
> *vma);
>  	int		(*attach_group)(void *iommu_data,
>  					struct iommu_group *group);
>  	void		(*detach_group)(void *iommu_data,
> --
> 2.30.2

