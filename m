Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2647142A071
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 10:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235256AbhJLI7a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 04:59:30 -0400
Received: from mga12.intel.com ([192.55.52.136]:35807 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235067AbhJLI73 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 04:59:29 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10134"; a="207202301"
X-IronPort-AV: E=Sophos;i="5.85,367,1624345200"; 
   d="scan'208";a="207202301"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2021 01:57:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,367,1624345200"; 
   d="scan'208";a="441786039"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga003.jf.intel.com with ESMTP; 12 Oct 2021 01:57:25 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 12 Oct 2021 01:57:24 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 12 Oct 2021 01:57:24 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Tue, 12 Oct 2021 01:57:24 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.172)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Tue, 12 Oct 2021 01:57:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DvVu1lIVJ69fxBolZQrMcJ09NzIm5oZLcK4LggPhxkADkkmWMTQjOphkZkW2+IQ88WSQQCfq88xIh1G48EA03AQrfnrdj40KvOhHNvmccFdrNCDrjVfcUoxuDFwDTdAH+dy4DRMVRn65n4aH+DzOxijpQ00RkkV7ZWeVbalKeE/PgZx8XEXP96RvH8v2MVmP8kvvK4Av5h+dixcB2yJ4JDGDM6mjK+JECLVTA9OV0bVQvJgcayKnpJT+MDLYAfUkLGfCMO9MyPjpRbc37KVLvuIH8uQjAUiuSXCOqf/IqRSkjFA/T0JbeP+t1Oas2+L6MKkVJ4Xm5ps03OKsetP6iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KVWEqQhrGmz4HbalcrvEY3/jVbTR5KQsH8AGmAhdOjM=;
 b=OmmJQNB4hu/eXEvpfMjbXPwoF8mdEGrK//oSw6+7a1OxkCrx5NgiWR2UazvfSxbAhKwlDvl0cuFWjMmLOsEZYnmW4UVi/Loe2go1llYA/Tp0wghD2A5O+R8kRaCStX9JJrdc8VRDIiEBYXIidpY8DQmWqdnnbDdTfYd62zw2kTMHr4AHOgK8cNRunhKJOWzwSJ5zfnP9InrHod3kWQ3VDMgrnFU4LQkiR/ytiv01Cv6LRXkJsFt94Dqc2cvFYz1BbIV2Yg63PyMfs8z7K9Hl/+Ddb9tWbPKdZ5IKn67nYY3ltnCSDjPiAqg5yuFTtpSIXk5lnh4vNBefF8pnP+QCxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KVWEqQhrGmz4HbalcrvEY3/jVbTR5KQsH8AGmAhdOjM=;
 b=rsGByj7xGCIBP+Id6TMQu+9A8FMGvq1nwrgeuD+MV9Zts1eDflsm2ZRQaoiatAmxo3jpClEcm++HP7IIIJkMnqKwUUC9V7s/gmKZGHMJV9WVnA5Ty2GvRRmgriotQGfKaGIQ7s4WNuifhLMQn+m39OaJWMP7p6nx/wLGsjKf7R0=
Received: from PH0PR11MB5658.namprd11.prod.outlook.com (2603:10b6:510:e2::23)
 by PH0PR11MB5659.namprd11.prod.outlook.com (2603:10b6:510:ea::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.20; Tue, 12 Oct
 2021 08:57:22 +0000
Received: from PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::5009:9c8c:4cb4:e119]) by PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::5009:9c8c:4cb4:e119%6]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 08:57:22 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: RE: [PATCH 5/5] vfio: Use cdev_device_add() instead of
 device_create()
Thread-Topic: [PATCH 5/5] vfio: Use cdev_device_add() instead of
 device_create()
Thread-Index: AQHXtxtaSyERD8vZ0EK3Th0ISTa6e6vPHdkg
Date:   Tue, 12 Oct 2021 08:57:22 +0000
Message-ID: <PH0PR11MB56589648466D3F7F899F9F5FC3B69@PH0PR11MB5658.namprd11.prod.outlook.com>
References: <0-v1-fba989159158+2f9b-vfio_group_cdev_jgg@nvidia.com>
 <5-v1-fba989159158+2f9b-vfio_group_cdev_jgg@nvidia.com>
In-Reply-To: <5-v1-fba989159158+2f9b-vfio_group_cdev_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 44527452-1ef3-4f3a-2074-08d98d5e4e09
x-ms-traffictypediagnostic: PH0PR11MB5659:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR11MB56598074E9784D6C120CD605C3B69@PH0PR11MB5659.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:556;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: H8wuhHVmDmjSmjVFmh1xQZhyGe8CFbV4HZSDGfztNapMPYN7lUMuEi5MqcBILM/AlKUifJKh7HaBWM/zUelndI6kWRU78pW1UJHPbbmJhC5IYkLoMvZYmPGKoPnP0L/I6fssLceApHgD5Sz8FdGkcPLoIRj8wt7syOX4X/9Qy453cvsbEb6USLQUfHZJ2d2TiJ5emWiaJih9m5STU998G2DiMYN0pEQai9IPbzoUTUlZn6ZmVa261j1yCDJBYNchd2dDrhhHlHJ8oCld3VTmsfxgNOO3tFEJON42cdIfOyQvGfrMwiW0KyDMrR8euuqlTd441/ppt0kCXkR5MpDfi0GDFkvF2e21KAJkpk2xD6qGfF8G6adaCZxy4ZkX24SgFxI3qzlukoQ9GJujzdqDHorbZkrZyTlIVOxbYAodUDmh22nWyTMC/5wZr3XmarC+O2K4LMOXmOvT2UO3OXPcJt9GI2g+CiQsEUijgHAmXmshz3q0nQZZwLglLl38GrxMxcX7X9pdsdq18kBilveZNKE2DveC0k9JmGFqsAzp3k39T1W8OGuzAL9G0ZFsHUU4bd8csp3iG6aX+FwcYA6qlMHI7raPap2FLqmu9ILVL1vTqhksN9vtknip3zpRGS6HGT2uGtebVsitRIisSbf5XjDU8PuC3JUXjhsbTReSW8q2WdZLmo8NfKo3+XSXGGf3QDXnVbY8nXhvlVxusBbo5w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5658.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(66446008)(52536014)(71200400001)(5660300002)(107886003)(186003)(508600001)(7696005)(30864003)(66946007)(2906002)(6506007)(76116006)(66476007)(8936002)(316002)(64756008)(66556008)(33656002)(9686003)(4326008)(83380400001)(110136005)(55016002)(26005)(54906003)(38070700005)(122000001)(38100700002)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?i2Mtu8GWAdS4lO4p0fWegkHoH7vWx12xoELSFOc8r6YXpBXTPYxTEQynzLbx?=
 =?us-ascii?Q?r9x+vIQrU8etJW3ySriRU1QPRyGAxfyy73FeTNuy7S7D2WSeGkI91xbgvDrl?=
 =?us-ascii?Q?hLdQ9IOLhLvSKW/DSSR5LJPRUtw2nbPfcTVE8+AzpxBiPnDyCJULHfIytT7g?=
 =?us-ascii?Q?iZEDx/yWUIWasEDzyLMQJ1gdtZ1Am0S6zBRiSQnYKQ7eqH0YaJxdLIa7qdUo?=
 =?us-ascii?Q?Q0q2ZVSDF9wE8ijZ0YL9j+c4FJHhs3IPowvXj6/qi6wvI3M99KkJijnrg/8L?=
 =?us-ascii?Q?wcipZbbnmOWvML0aJgYbQPy6k/nxVwqk32Ge5ittz/L+xo4+ICNHq78xrJ0V?=
 =?us-ascii?Q?OsDScytYonz5+t+CoCIY04CK4OwSs2f4jYTfEoIgnKUS+TwEIcpJlGvEyYko?=
 =?us-ascii?Q?WnZGIXdJY5MfB8x1yQJ4c0/1gKv+l1v4up/3wACtTP++XzCETDg2FQ2mbQu5?=
 =?us-ascii?Q?mfDe38PFatsCsf+6U6tMQCNWR2Bpo0kuVoTMnU0hXz2UCkDTUkoTXoScfXvU?=
 =?us-ascii?Q?5qZqBJxK8t5zaJkSF1b25tBz2AulpXKMs1Ah1o2zL9sYgVpQt1jSLu314TY+?=
 =?us-ascii?Q?voJrDHa5XB/hmTDJkJt4jDFKxyiSZu4qcZjpwRzaU+6XY7G9BJlGS2FknQMp?=
 =?us-ascii?Q?/73nX8qmhHqdrBS6tihMj7MvVMfvw2P2ViCC63CEPc75kF51Ich7fjUApBc3?=
 =?us-ascii?Q?qU92OGb8xfNnDxCSdagQPOKQ67JXuWAquPCpqYP9a/5kggtBrkKLcI2WTlL4?=
 =?us-ascii?Q?2n6y7hgoxxPRL6wc9up2JLs+ENHoJmcutAru7kXyaLUE44stCLGqsD+1opSt?=
 =?us-ascii?Q?SzexSb3GGCfP/PKiD72+eG65Q1++H4sXOIuRHu+JAr/WzHXTHoMYm+8ctGZ0?=
 =?us-ascii?Q?abZ6UQHP7GUzlL8q03RQOG1As2kj/vvbPtIXU/tpJDnzfXGnfjIqZffyP9qw?=
 =?us-ascii?Q?+jv0jqnSD+zKAOVK7wA2/knnzprgfac35K/L+mQHXRWsxhrRwAdcj+wXAI4Q?=
 =?us-ascii?Q?nla9GzXfT8HePopzHByUOiB9ZzyiwgZHZmepj36J4SHlvT/UAgS8i0eLSqBZ?=
 =?us-ascii?Q?hZyB2G7Z0bU1wnWLAcN+wj3dWtF//dq002xNmNixCfzTjanjcQAVcGzQYTc+?=
 =?us-ascii?Q?E+3R2bFf3UGE2I1JtoRejZgZLTvW3fPEtU4H6nCW5PYSDb7OBdE63XnISj2g?=
 =?us-ascii?Q?LyPbDrZYfFXfRSaLkC5kSLGE+sOvxE0bv907EIKEmfhSgchT2VZv7hv9uuh1?=
 =?us-ascii?Q?WyWHatl8lh49efZv01HqQcOyY2owQTxd9WeSHC/t0y+9l7PaQawQPndEa9Tc?=
 =?us-ascii?Q?hRxhCTvK7EgKW1VkMScA/SE6?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5658.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44527452-1ef3-4f3a-2074-08d98d5e4e09
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Oct 2021 08:57:22.4014
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oXiFJclm+rA5vN9KPWlYsMxiKpOQhWUPID4QruOEHC9KUQ+6ERdOTJBXmaETTYDdptUbqepiNQjGtKq02Co2ag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5659
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Saturday, October 2, 2021 7:22 AM
>=20
> Modernize how vfio is creating the group char dev and sysfs presence.
>=20
> These days drivers with state should use cdev_device_add() and
> cdev_device_del() to manage the cdev and sysfs lifetime.
>=20
> This API requires the driver to put the struct device and struct cdev
> inside its state struct (vfio_group), and then use the usual
> device_initialize()/cdev_device_add()/cdev_device_del() sequence.
>=20
> Split the code to make this possible:
>=20
>  - vfio_group_alloc()/vfio_group_release() are pair'd functions to
>    alloc/free the vfio_group. release is done under the struct device
>    kref.
>=20
>  - vfio_create_group()/vfio_group_put() are pairs that manage the
>    sysfs/cdev lifetime. Once the uses count is zero the vfio group's
>    userspace presence is destroyed.
>=20
>  - The IDR is replaced with an IDA. container_of(inode->i_cdev)
>    is used to get back to the vfio_group during fops open. The IDA
>    assigns unique minor numbers.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/vfio.c | 200 +++++++++++++++++++++-----------------------
>  1 file changed, 94 insertions(+), 106 deletions(-)
>=20
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index dbe7edd88ce35c..01e04947250f40 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -43,9 +43,8 @@ static struct vfio {
>  	struct list_head		iommu_drivers_list;
>  	struct mutex			iommu_drivers_lock;
>  	struct list_head		group_list;
> -	struct idr			group_idr;
> -	struct mutex			group_lock;
> -	struct cdev			group_cdev;
> +	struct mutex			group_lock; /* locks group_list */
> +	struct ida			group_ida;
>  	dev_t				group_devt;
>  } vfio;
>=20
> @@ -69,14 +68,14 @@ struct vfio_unbound_dev {
>  };
>=20
>  struct vfio_group {
> +	struct device dev;
> +	struct cdev cdev;
>  	refcount_t users;
> -	int				minor;
>  	atomic_t			container_users;
>  	struct iommu_group		*iommu_group;
>  	struct vfio_container		*container;
>  	struct list_head		device_list;
>  	struct mutex			device_lock;
> -	struct device			*dev;
>  	struct notifier_block		nb;
>  	struct list_head		vfio_next;
>  	struct list_head		container_next;
> @@ -98,6 +97,7 @@ MODULE_PARM_DESC(enable_unsafe_noiommu_mode,
> "Enable UNSAFE, no-IOMMU mode.  Thi
>  #endif
>=20
>  static DEFINE_XARRAY(vfio_device_set_xa);
> +static const struct file_operations vfio_group_fops;
>=20
>  int vfio_assign_device_set(struct vfio_device *device, void *set_id)
>  {
> @@ -281,19 +281,6 @@ void vfio_unregister_iommu_driver(const struct
> vfio_iommu_driver_ops *ops)
>  }
>  EXPORT_SYMBOL_GPL(vfio_unregister_iommu_driver);
>=20
> -/**
> - * Group minor allocation/free - both called with vfio.group_lock held
> - */
> -static int vfio_alloc_group_minor(struct vfio_group *group)
> -{
> -	return idr_alloc(&vfio.group_idr, group, 0, MINORMASK + 1,
> GFP_KERNEL);
> -}
> -
> -static void vfio_free_group_minor(int minor)
> -{
> -	idr_remove(&vfio.group_idr, minor);
> -}
> -
>  static int vfio_iommu_group_notifier(struct notifier_block *nb,
>  				     unsigned long action, void *data);
>  static void vfio_group_get(struct vfio_group *group);
> @@ -322,26 +309,6 @@ static void vfio_container_put(struct vfio_container
> *container)
>  	kref_put(&container->kref, vfio_container_release);
>  }
>=20
> -static void vfio_group_unlock_and_free(struct vfio_group *group)
> -{
> -	struct vfio_unbound_dev *unbound, *tmp;
> -
> -	mutex_unlock(&vfio.group_lock);
> -	/*
> -	 * Unregister outside of lock.  A spurious callback is harmless now
> -	 * that the group is no longer in vfio.group_list.
> -	 */
> -	iommu_group_unregister_notifier(group->iommu_group, &group->nb);
> -
> -	list_for_each_entry_safe(unbound, tmp,
> -				 &group->unbound_list, unbound_next) {
> -		list_del(&unbound->unbound_next);
> -		kfree(unbound);
> -	}
> -	iommu_group_put(group->iommu_group);
> -	kfree(group);
> -}
> -
>  /**
>   * Group objects - create, release, get, put, search
>   */
> @@ -370,75 +337,112 @@ vfio_group_get_from_iommu(struct iommu_group
> *iommu_group)
>  	return group;
>  }
>=20
> -static struct vfio_group *vfio_create_group(struct iommu_group
> *iommu_group,
> -		enum vfio_group_type type)
> +static void vfio_group_release(struct device *dev)
>  {
> -	struct vfio_group *group, *existing_group;
> -	struct device *dev;
> -	int ret, minor;
> +	struct vfio_group *group =3D container_of(dev, struct vfio_group, dev);
> +	struct vfio_unbound_dev *unbound, *tmp;
> +
> +	list_for_each_entry_safe(unbound, tmp,
> +				 &group->unbound_list, unbound_next) {
> +		list_del(&unbound->unbound_next);
> +		kfree(unbound);
> +	}
> +
> +	mutex_destroy(&group->device_lock);
> +	mutex_destroy(&group->unbound_lock);
> +	iommu_group_put(group->iommu_group);
> +	ida_free(&vfio.group_ida, MINOR(group->dev.devt));
> +	kfree(group);
> +}
> +
> +static struct vfio_group *vfio_group_alloc(struct iommu_group
> *iommu_group,
> +					   enum vfio_group_type type)
> +{
> +	struct vfio_group *group;
> +	int minor;
>=20
>  	group =3D kzalloc(sizeof(*group), GFP_KERNEL);
>  	if (!group)
>  		return ERR_PTR(-ENOMEM);
>=20
> +	minor =3D ida_alloc_max(&vfio.group_ida, MINORMASK, GFP_KERNEL);
> +	if (minor < 0) {
> +		kfree(group);
> +		return ERR_PTR(minor);
> +	}
> +
> +	device_initialize(&group->dev);
> +	group->dev.devt =3D MKDEV(MAJOR(vfio.group_devt), minor);
> +	group->dev.class =3D vfio.class;
> +	group->dev.release =3D vfio_group_release;
> +	cdev_init(&group->cdev, &vfio_group_fops);
> +	group->cdev.owner =3D THIS_MODULE;
> +
>  	refcount_set(&group->users, 1);
>  	INIT_LIST_HEAD(&group->device_list);
>  	mutex_init(&group->device_lock);
>  	INIT_LIST_HEAD(&group->unbound_list);
>  	mutex_init(&group->unbound_lock);
> -	atomic_set(&group->container_users, 0);
> -	atomic_set(&group->opened, 0);
>  	init_waitqueue_head(&group->container_q);
>  	group->iommu_group =3D iommu_group;
> -	/* put in vfio_group_unlock_and_free() */
> +	/* put in vfio_group_release() */
>  	iommu_group_ref_get(iommu_group);
>  	group->type =3D type;
>  	BLOCKING_INIT_NOTIFIER_HEAD(&group->notifier);
>=20
> -	group->nb.notifier_call =3D vfio_iommu_group_notifier;
> +	return group;
> +}
>=20
> -	ret =3D iommu_group_register_notifier(iommu_group, &group->nb);
> -	if (ret) {
> -		group =3D ERR_PTR(ret);
> -		goto err_put_group;
> +static struct vfio_group *vfio_create_group(struct iommu_group
> *iommu_group,
> +		enum vfio_group_type type)
> +{
> +	struct vfio_group *group;
> +	struct vfio_group *ret;
> +	int err;
> +
> +	group =3D vfio_group_alloc(iommu_group, type);
> +	if (IS_ERR(group))
> +		return group;
> +
> +	err =3D dev_set_name(&group->dev, "%s%d",
> +			   group->type =3D=3D VFIO_NO_IOMMU ? "noiommu-" : "",
> +			   iommu_group_id(iommu_group));
> +	if (err) {
> +		ret =3D ERR_PTR(err);
> +		goto err_put;
> +	}
> +
> +	group->nb.notifier_call =3D vfio_iommu_group_notifier;
> +	err =3D iommu_group_register_notifier(iommu_group, &group->nb);
> +	if (err) {
> +		ret =3D ERR_PTR(err);
> +		goto err_put;
>  	}
>=20
>  	mutex_lock(&vfio.group_lock);
>=20
>  	/* Did we race creating this group? */
> -	existing_group =3D __vfio_group_get_from_iommu(iommu_group);
> -	if (existing_group) {
> -		vfio_group_unlock_and_free(group);
> -		return existing_group;
> -	}
> +	ret =3D __vfio_group_get_from_iommu(iommu_group);
> +	if (ret)
> +		goto err_unlock;
>=20
> -	minor =3D vfio_alloc_group_minor(group);
> -	if (minor < 0) {
> -		vfio_group_unlock_and_free(group);
> -		return ERR_PTR(minor);
> +	err =3D cdev_device_add(&group->cdev, &group->dev);
> +	if (err) {
> +		ret =3D ERR_PTR(err);
> +		goto err_unlock;

should this err branch put the vfio_group reference acquired
in above __vfio_group_get_from_iommu(iommu_group);?

Regards,
Yi Liu

>  	}
>=20
> -	dev =3D device_create(vfio.class, NULL,
> -			    MKDEV(MAJOR(vfio.group_devt), minor), group,
> "%s%d",
> -			    group->type =3D=3D VFIO_NO_IOMMU ? "noiommu-" :
> "",
> -			    iommu_group_id(iommu_group));
> -	if (IS_ERR(dev)) {
> -		vfio_free_group_minor(minor);
> -		vfio_group_unlock_and_free(group);
> -		return ERR_CAST(dev);
> -	}
> -
> -	group->minor =3D minor;
> -	group->dev =3D dev;
> -
>  	list_add(&group->vfio_next, &vfio.group_list);
>=20
>  	mutex_unlock(&vfio.group_lock);
> -
> -err_put_group:
> -	iommu_group_put(iommu_group);
> -	kfree(group);
>  	return group;
> +
> +err_unlock:
> +	mutex_unlock(&vfio.group_lock);
> +	iommu_group_unregister_notifier(group->iommu_group, &group->nb);
> +err_put:
> +	put_device(&group->dev);
> +	return ret;
>  }
>=20
>  static void vfio_group_put(struct vfio_group *group)
> @@ -450,10 +454,12 @@ static void vfio_group_put(struct vfio_group *group=
)
>  	WARN_ON(atomic_read(&group->container_users));
>  	WARN_ON(group->notifier.head);
>=20
> -	device_destroy(vfio.class, MKDEV(MAJOR(vfio.group_devt), group-
> >minor));
>  	list_del(&group->vfio_next);
> -	vfio_free_group_minor(group->minor);
> -	vfio_group_unlock_and_free(group);
> +	cdev_device_del(&group->cdev, &group->dev);
> +	mutex_unlock(&vfio.group_lock);
> +
> +	iommu_group_unregister_notifier(group->iommu_group, &group->nb);
> +	put_device(&group->dev);
>  }
>=20
>  static void vfio_group_get(struct vfio_group *group)
> @@ -461,20 +467,10 @@ static void vfio_group_get(struct vfio_group *group=
)
>  	refcount_inc(&group->users);
>  }
>=20
> -static struct vfio_group *vfio_group_get_from_minor(int minor)
> +/* returns true if the get was obtained */
> +static bool vfio_group_try_get(struct vfio_group *group)
>  {
> -	struct vfio_group *group;
> -
> -	mutex_lock(&vfio.group_lock);
> -	group =3D idr_find(&vfio.group_idr, minor);
> -	if (!group) {
> -		mutex_unlock(&vfio.group_lock);
> -		return NULL;
> -	}
> -	vfio_group_get(group);
> -	mutex_unlock(&vfio.group_lock);
> -
> -	return group;
> +	return refcount_inc_not_zero(&group->users);
>  }
>=20
>  static struct vfio_group *vfio_group_get_from_dev(struct device *dev)
> @@ -1484,11 +1480,11 @@ static long vfio_group_fops_unl_ioctl(struct file
> *filep,
>=20
>  static int vfio_group_fops_open(struct inode *inode, struct file *filep)
>  {
> -	struct vfio_group *group;
> +	struct vfio_group *group =3D
> +		container_of(inode->i_cdev, struct vfio_group, cdev);
>  	int opened;
>=20
> -	group =3D vfio_group_get_from_minor(iminor(inode));
> -	if (!group)
> +	if (!vfio_group_try_get(group))
>  		return -ENODEV;
>=20
>  	if (group->type =3D=3D VFIO_NO_IOMMU && !capable(CAP_SYS_RAWIO)) {
> @@ -2296,7 +2292,7 @@ static int __init vfio_init(void)
>  {
>  	int ret;
>=20
> -	idr_init(&vfio.group_idr);
> +	ida_init(&vfio.group_ida);
>  	mutex_init(&vfio.group_lock);
>  	mutex_init(&vfio.iommu_drivers_lock);
>  	INIT_LIST_HEAD(&vfio.group_list);
> @@ -2321,11 +2317,6 @@ static int __init vfio_init(void)
>  	if (ret)
>  		goto err_alloc_chrdev;
>=20
> -	cdev_init(&vfio.group_cdev, &vfio_group_fops);
> -	ret =3D cdev_add(&vfio.group_cdev, vfio.group_devt, MINORMASK + 1);
> -	if (ret)
> -		goto err_cdev_add;
> -
>  	pr_info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
>=20
>  #ifdef CONFIG_VFIO_NOIOMMU
> @@ -2333,8 +2324,6 @@ static int __init vfio_init(void)
>  #endif
>  	return 0;
>=20
> -err_cdev_add:
> -	unregister_chrdev_region(vfio.group_devt, MINORMASK + 1);
>  err_alloc_chrdev:
>  	class_destroy(vfio.class);
>  	vfio.class =3D NULL;
> @@ -2350,8 +2339,7 @@ static void __exit vfio_cleanup(void)
>  #ifdef CONFIG_VFIO_NOIOMMU
>  	vfio_unregister_iommu_driver(&vfio_noiommu_ops);
>  #endif
> -	idr_destroy(&vfio.group_idr);
> -	cdev_del(&vfio.group_cdev);
> +	ida_destroy(&vfio.group_ida);
>  	unregister_chrdev_region(vfio.group_devt, MINORMASK + 1);
>  	class_destroy(vfio.class);
>  	vfio.class =3D NULL;
> --
> 2.33.0

