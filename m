Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38C076D057A
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 14:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231645AbjC3M4w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 08:56:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbjC3M4v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 08:56:51 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABEF813E;
        Thu, 30 Mar 2023 05:56:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680181010; x=1711717010;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YlCJTVkAKjNv1liq7cshXt9RdbSXYWdiR9Y7PgM9NI0=;
  b=TKM53w2LZRi4a4aZFakN4JeuyUF0MgY6iueg5pvkJxjk+/BPmJwKjIZ1
   Wrvtj0lDbtQyRZdb1Aptcvaik2udQNxasALCymK61a9M9anp6eeoGAqyn
   Z5OotvqBh3DCzMWxsC06CJ/3JTce6/z/t4PIWg2rj7Qed2PhvgcUD8sWe
   /EmiHU7jbw53SKTgxjaviib9uSaiONQOfmKpRPti0ZKZ/jzWJmgYvl8oa
   e3cp9AO/rSE5QV0K/xVOvIvgdHSG2IvjadjIACBzOMgo2ffF8RKnBpcpG
   9/hy2KTQpDXIkxZQFyXAI6A3x6BwkYlJKN2w/2egov6nuawpoDB/s1ZrS
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="338657957"
X-IronPort-AV: E=Sophos;i="5.98,303,1673942400"; 
   d="scan'208";a="338657957"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2023 05:56:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="753986961"
X-IronPort-AV: E=Sophos;i="5.98,303,1673942400"; 
   d="scan'208";a="753986961"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga004.fm.intel.com with ESMTP; 30 Mar 2023 05:56:05 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 30 Mar 2023 05:56:04 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 30 Mar 2023 05:56:04 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.175)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 30 Mar 2023 05:56:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hm/m/lVQBsALezr2KIzDDnhxfuM0QUAex/c8KNIPJAzempPPbrS8dh4Y+DPtyxD+ek/9lYHwZGTyDXBJG8nhtRbcwl/m8+4ThNtk7lBigOwY7p2pG+lrxMuatjd51jlwwlD9Tnq1T41cQ3T/+odWoOzAjrTClftALfqeIQ4w1EzPW0mdvIEON0PAzkzi6FqcZEYuyAiRtxISJMqlA2Uw4Uc1dOh1HoRvAaeyHn29JxYU4jW4J4VolT/Z1inchO3B5/HH16p+3aEuAG8rs4Ua1CmNEdQ0sbCQF+wEfw/XinD81edjececX64duZePIecJBg5e0EBNK6hAKulbyv77iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=785uFOQX5KNx8N1z9xvQ+b2BI5/LpC5C+HbNE16y2LE=;
 b=ZCgUafmsM97Pc8kuS3tfl4ONXerOo1yByRLA1cvmseqnat5ks61UPk59Rmz+6yjqVhHI/+lcADLvVKKyr56JUDHtQooiKvN3S+odbHYJDwaZd/JufUDzl37mIiXj7/03Xt2ia1Ua+5+f6oJaqJuapCUOW+yOzEVXfl9RWBDACUc0EoGnUhf3hfxxmF0WP0y2KEMbJb5EepsZyTsGRPQ9k6UPSc+YXL5eK+a3fk6RzXvyliFgbPbAJF8KGkiCDfAH1jEc4jg12lLhSNv8NnfZNThXgxwIrLEBQd0JODSh7BrMrKHS5KjuHR0jZrEfe3Iyz2xOTZs0pRvUlHjR93Cs9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by IA1PR11MB6345.namprd11.prod.outlook.com (2603:10b6:208:38b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Thu, 30 Mar
 2023 12:56:02 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de%4]) with mapi id 15.20.6254.020; Thu, 30 Mar 2023
 12:56:02 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
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
        "Jiang, Yanting" <yanting.jiang@intel.com>
Subject: RE: [PATCH v2 10/10] vfio/pci: Add
 VFIO_DEVICE_GET_PCI_HOT_RESET_GROUP_INFO
Thread-Topic: [PATCH v2 10/10] vfio/pci: Add
 VFIO_DEVICE_GET_PCI_HOT_RESET_GROUP_INFO
Thread-Index: AQHZYI92Dc+A7iEOnEaMeK3O2ipWfK8PAuSAgACBxlCAADScAIAAh+4AgAABaZCAAARdAIAAAahggAAHN4CAAAKPcIAACUyAgAC3rPCAAHDDAIAAZucAgAFd2ICAAANdgA==
Date:   Thu, 30 Mar 2023 12:56:02 +0000
Message-ID: <DS0PR11MB7529EF6CE101CBC90CB5DE7FC38E9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230327093458.44939-1-yi.l.liu@intel.com>
        <20230327093458.44939-11-yi.l.liu@intel.com>
        <20230327132619.5ab15440.alex.williamson@redhat.com>
        <DS0PR11MB7529E969C27995D535A24EC0C3889@DS0PR11MB7529.namprd11.prod.outlook.com>
        <BL1PR11MB52717FB9E6D5C10BF4B7DA0A8C889@BL1PR11MB5271.namprd11.prod.outlook.com>
        <20230328082536.5400da67.alex.williamson@redhat.com>
        <DS0PR11MB7529B6782565BE8489D922F9C3889@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230328084616.3361a293.alex.williamson@redhat.com>
        <DS0PR11MB75290B84D334FC726A8BBA95C3889@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230328091801.13de042a.alex.williamson@redhat.com>
        <DS0PR11MB752903CE3D5906FE21146364C3889@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230328100027.3b843b91.alex.williamson@redhat.com>
        <DS0PR11MB7529C12E086DAB619FF9AFF0C3899@DS0PR11MB7529.namprd11.prod.outlook.com>
        <BN9PR11MB52762E789B9C1D8021F54ECC8C899@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230329094944.50abde4e.alex.williamson@redhat.com>
 <DS0PR11MB75298AF9A9ACAEBDD5D445ECC38E9@DS0PR11MB7529.namprd11.prod.outlook.com>
In-Reply-To: <DS0PR11MB75298AF9A9ACAEBDD5D445ECC38E9@DS0PR11MB7529.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|IA1PR11MB6345:EE_
x-ms-office365-filtering-correlation-id: 4df09048-bcf2-42db-24de-08db311e1de7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jk+KPBmfQp28p3A8q9EkiDvfCkysTe5wo0uICOvwotAy+/+/SockpHgvB+Ge0DDFWSswlV4aRVi+ci4vusPZ2plOTjgBSomS9V2QXz22n+nNTQZq51LvrtrZ5y8VlU4UjVEuZBcnFPvXnwZP1mckAB/pZZqrR7JVqw56Q6kJvJkMdU4WaciWBh5fhLozDqglZThpyi5iiQfrT+bB/OYsu/ZdqFlyD7w602xdPsGhqHTEfUzMYOylRqO0vpQJAAjNOtFVcDwxiV9pdLyWGOzH3fHXrXjRwQWy/Sszn/Tlk0SU9DMH3579gmxUV6keeTZU/5eHCKZiAqUlAeHME312BoSIZNe6DPDqMTo5V2lKFKSSvSlet1tugr3kKjVcu0bp0tBz22DQ7/WakLrYBDnECngkCO9wCd7kV4AqdZd0iNS2Ida5XAgFPLPKS6fI9Qgzx/CLWN+SIMonpHqm3w42obimrvepNQxh2G/PCA8X6qINOtDJ3ZcnzF6O5zek/IksKiHJlRx7UKwgSWqAsZblOLDGxbjAyb2labbSxCPJW6mulw0jW+kUPz6DR+jOdRhCtTsUcMoxsTJqDMG8CBxjiWXNuF/LRxMBpvMCRiBWk0LgEAEa9T7ZTKwrmgbu1q/Q
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(376002)(39860400002)(346002)(136003)(451199021)(7696005)(55016003)(71200400001)(4326008)(41300700001)(76116006)(316002)(110136005)(66446008)(66556008)(8676002)(478600001)(64756008)(66476007)(38100700002)(66946007)(54906003)(6636002)(186003)(5660300002)(2940100002)(33656002)(86362001)(38070700005)(9686003)(7416002)(6506007)(2906002)(52536014)(122000001)(82960400001)(26005)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?WeRj9TzdcVmR7aFFkuQJ9c28vADaxp/P//SJzBUdH07jJzgdnrWAtd7XP7N6?=
 =?us-ascii?Q?Sn2TGCe1pwJp8qU4L6d+FCdnbVBGaqjiYGa+MFNQqcX2L8oAvygKKOtpCOMF?=
 =?us-ascii?Q?APqXiGzQ5CSb+/ddVBWQ7WIuWDy1QPhT9aa1ftnALTgIxfY9kZDX+KKqUcBi?=
 =?us-ascii?Q?mld65HUVB1E0LDnrMGrBpj3O/Nb5069aD3fT7wiNXTKQcl3khiT/iiu1Dxj6?=
 =?us-ascii?Q?zThoImWnvnYffiXrv3795GkXH9+jB3Nb9AgWg9YyMF3G+sag1R7FUwvgToZZ?=
 =?us-ascii?Q?Qm3uCAp7MV2MTA9bDzxCjb0Auy9yUlGneZTXnZvnAopRk4GutZ++w/XrrI9I?=
 =?us-ascii?Q?T38jWboWLlqzI6r5NRPdjqlqUcpQGu2UD9XaQgpKbSMyT4bYcRTEPthtDN7M?=
 =?us-ascii?Q?2DAnUchC/hDROw+4KUsqggrt3aRA6QuB5K5M9ILmEABq82XMXwMqfwVH6ap1?=
 =?us-ascii?Q?Ku94LpSsv3MC10jJDI7BLJY/e2V4DZHQSPIxZa0MabMtGsLP9Qn854p47mQu?=
 =?us-ascii?Q?mwQgn2lKRHSF3+bDR2APR5XYjbP924HbWAu9UkbgDgJh+zWwNdSuIHW/TZaQ?=
 =?us-ascii?Q?ABagDdUu99waEvzen5qjBkNPwte1AcEGrPDQn4M98L2cI13K+I72LrxEpzcc?=
 =?us-ascii?Q?0y680Tz7GXMGRIjlASbRZpRww4K90Ace97xddc4IZFhAb1umIOOb4TjgnAxP?=
 =?us-ascii?Q?Gd15uoLU3GeCRNt2nrsS69eycF2q2Su7Yo5EkU4gLCIxUI7gpfWmbG6YhqxX?=
 =?us-ascii?Q?a3vtYhpV6MLmJBoQm17g+qaPBZdlJBoylbmcMSsyDh332gVka5zFSEPl36MO?=
 =?us-ascii?Q?+PL+BwOd3knt69KAjKx+taCbqkkd+J0P2z9FmLLxcJNURD8DQ5w1jXgNqP0H?=
 =?us-ascii?Q?AKf66mC5U2wAEmNF46/dpDZmDYDWVCBdFvG2m6iw30hxEO10Pk0xiZnKKsKK?=
 =?us-ascii?Q?1rmVQCg0uqQy4Y6S6+vtvBsTugPrsINg/QXVUytCSexAoiHKzq7qO/69MS5F?=
 =?us-ascii?Q?bjXzy0aSbEbrvR1khtUsJcH7n6KdJcOp0dkAlxNGYWncrmMcyx9oglOvszcL?=
 =?us-ascii?Q?b+7szc114ZEAoxLquSl4cfRt1Nmw164yyi+LX2JJQijFsSwBFvRz9pXj7SvN?=
 =?us-ascii?Q?dF7ABV7ZIvWBOBO0EWfmfTpTKqJC342pI8OkTmZlJ5WjON3/R5m8fObkLb/v?=
 =?us-ascii?Q?Vzawy5tCftmem2gfu0k6iYODZdyBhQw5xtHASXyVv1e3niaVwAE2SGyzhfez?=
 =?us-ascii?Q?omsSZRLgp0zTB67jfmfX8njznbwWKslHffYLph3wfBrNzFwHAuTPfG1Lx9/r?=
 =?us-ascii?Q?KeNPJ5c778MzAfyUfhRji2xx73OqVg7H9mSg2IInBu+NpTkOnv0YXFQKNTc9?=
 =?us-ascii?Q?1QJRFP7ljFNrNp8kCkcs42n93reKJVv8wp+vzsnRFEtnx+5houzFwJKRPDLh?=
 =?us-ascii?Q?jGvj8h84LSgiLHmb6ctGldG0Rs3l+kckjbHyK0VrLaulGvhI9DnKueFTDTgk?=
 =?us-ascii?Q?XO+FvaEt22ppCrMy8oKM2vvr9tT+9PabCZcZGRmMc2b3XQG93sEezX4qbwVu?=
 =?us-ascii?Q?WPSA1aBYWK1zNPwnrszLXBjx7ZX1UBcNPGb3oFmJ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4df09048-bcf2-42db-24de-08db311e1de7
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2023 12:56:02.3038
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B9m97yO7kqkOopxDKxhte2fcQmYx0nJM1k1SMLg5POH/jnkQeJtaspan80rGs/BDm9X9hD1QkJuGTdvTHm7zUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6345
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Thursday, March 30, 2023 8:48 PM

>  	if (fill->cur =3D=3D fill->max)
>  		return -EAGAIN; /* Something changed, try again */
> @@ -791,7 +812,24 @@ static int vfio_pci_fill_devs(struct pci_dev *pdev, =
void *data)
>  	if (!iommu_group)
>  		return -EPERM; /* Cannot reset non-isolated devices */
>=20
> -	fill->devices[fill->cur].group_id =3D iommu_group_id(iommu_group);
> +	/*
> +	 * If dev_id is needed, fill in the dev_id field, otherwise
> +	 * fill in group_id.
> +	 */
> +	if (fill->require_devid) {
> +		/*
> +		 * Report the devices that are opened as cdev and have
> +		 * the same iommufd with the fill->iommufd.  Otherwise,
> +		 * just fill in an IOMMUFD_INVALID_ID.
> +		 */
> +		vdev =3D vfio_pci_find_device_in_devset(dev_set, pdev);
> +		if (vdev && !vfio_device_cdev_opened(vdev) &&

a typo..it should be
		if (vdev && vfio_device_cdev_opened(vdev) &&

> +		    fill->iommufd =3D=3D vfio_iommufd_physical_ictx(vdev))
> +			vfio_iommufd_physical_devid(vdev, &fill->devices[fill-
> >cur].dev_id);
> +		fill->devices[fill->cur].dev_id =3D IOMMUFD_INVALID_ID;
> +	} else {
> +		fill->devices[fill->cur].group_id =3D iommu_group_id(iommu_group);
> +	}
>  	fill->devices[fill->cur].segment =3D pci_domain_nr(pdev->bus);
>  	fill->devices[fill->cur].bus =3D pdev->bus->number;
>  	fill->devices[fill->cur].devfn =3D pdev->devfn;

Regards,
Yi Liu
