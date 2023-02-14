Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67DB9695DA4
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 09:53:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232194AbjBNIxp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 03:53:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232192AbjBNIxm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 03:53:42 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E7A230CD;
        Tue, 14 Feb 2023 00:53:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676364813; x=1707900813;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=nO43Hql+00o+yPn7gw0YgWdB3qg64nGYE8/+ZH5G+RA=;
  b=leQ+7Ur31ocnsH16iv2hlS6DNtuu1M+1KMpNlJzIfut4NIgM9gYfqIVZ
   Y/Qa9w8DsFCJ76qGPrS3iiHtWGFzLE3gxdv5p8I2nVvC2Iax/+7e3s4Tf
   KJBTSBXCEdjTOorxKtoD/wAR9ZU2EOE5Q7r0MK0L8PnDqURxVohz0WfPZ
   1me0Lgw0kBPlT1Y+ewS7GTPYuDlVeH+u8aDSfmdO/Gpckv1jDiBH96LmE
   nP3Gsio0ph2G4ZHOW25Yfgu80pa7KyWatneVGXPF0sb2wQsR9eCwcn5Jk
   GmmyDoKvIEdt4BzCU8DoAcCWMy6FuLW2OHm+wfdaFjaY+oLldiCWcjT4w
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="329740436"
X-IronPort-AV: E=Sophos;i="5.97,296,1669104000"; 
   d="scan'208";a="329740436"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 00:53:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="914670301"
X-IronPort-AV: E=Sophos;i="5.97,296,1669104000"; 
   d="scan'208";a="914670301"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga006.fm.intel.com with ESMTP; 14 Feb 2023 00:53:32 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 00:53:32 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 14 Feb 2023 00:53:32 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.108)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 14 Feb 2023 00:53:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=biTao4dMqgy6JQ9aJrBgDMOw8T9MgZkDZxlmeVxOl2R8M354A9PZCIhhG85gbl+7EOOYH0LyT/turPxePx1OLofgIGZtIHI7Dim3LdVQgGFch/5OXzxIKNn6eyGmRRvI0UBtGtS9pV914t4wIJYv+BCaQSoVXj438HpvNSSVbw1HFb+Nm4GpqH9E0pnEYzueb40DsRoyzMd0FTsHuQnj6KiAtkBz8PE30+znoFM641Kl/KqXbhFrSZSNudWH6zz9xw0ofl3kSzdviT3TKztNVKnGMiulYxoECsPaq4wBfygI3Nz+SVoZZ0TdnFKRDR38673IcOQ79Z45frIkA0t0oA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NBKwjMmz8+JkrqEwg4+ANkH5an4wzxbYk3L3Jbzf70U=;
 b=BkqtX7NXNH9OnTkHtJqyG3NAZVW6tzcKU3NiRiVHV9cWGaZuWZIXpZHP5WGjWPPPlAJ7tQvkNfKzDYzJhouJK/76ZCh2Fwuy9r7iT0igcytJ7Lq6nBOvw4XyAQLiFEBqkEsgcx/k1fCsgf/XMbewEpysfknSSPyE8PCFyAz9JFZaET6W261/3WUUdJN3WKUrPwZXgr82AwxF3/Obu1GfB8vThBAA3o0hVqmnFpkFwGfxvqWMxQhm5r+qgHz3cqJcX3Zgpow1qk6QwKaAyejAiLvhNxAb9HrXSPaT/+wTiNTzxjgovTfa/m9877UBZ7ZuXxcs17lKQqx8vMjaFyAhDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DS0PR11MB7957.namprd11.prod.outlook.com (2603:10b6:8:f8::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.24; Tue, 14 Feb 2023 08:53:28 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%9]) with mapi id 15.20.6086.026; Tue, 14 Feb 2023
 08:53:28 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
CC:     "cohuck@redhat.com" <cohuck@redhat.com>,
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
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>
Subject: RE: [PATCH v3 14/15] vfio: Add ioctls for device cdev using iommufd
Thread-Topic: [PATCH v3 14/15] vfio: Add ioctls for device cdev using iommufd
Thread-Index: AQHZP73TvQpA9MeASkiSDIZ0QSeJSq7OIiZg
Date:   Tue, 14 Feb 2023 08:53:27 +0000
Message-ID: <BN9PR11MB527629B0CA6E04C75F42F3D58CA29@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230213151348.56451-1-yi.l.liu@intel.com>
 <20230213151348.56451-15-yi.l.liu@intel.com>
In-Reply-To: <20230213151348.56451-15-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DS0PR11MB7957:EE_
x-ms-office365-filtering-correlation-id: 1fd6c26a-ae87-4f04-8ed0-08db0e68f0a8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: B+6IAeX8ZhNDgb1XVy2/SI6V+xS47w4CdNzC2g8448Iu2Hv1yItN5WpHIBYEYM+farUCicSpVbsGGRIJ1oH9zqbx2o+yEeTPcZ729vbdNEUfa28CwKX67++mwdbeUTkkpNj8Q4s0ZO6McwzeXja2zZ6NG6x4mvdtmnSNYv9/pn3lCcYoxCSMAXaM4C9Ux7YQ8hkhq6gbfDWoppWwEUfYmdLQ5/iR42jH2E6bq5nmB9XO77Rc/YUzAQnlW+iFYoa78kcpcnpIxKdukrVblFxhQaZZracYYHOXLTrJ0/n+dN4GsRnUmgU11YrpFjLjVIHLUFicTiPj5a65s7qOsFBMVNY/Ll7kK+luIgSxW0aDyeY9jcnA5KNv1YPi11JU5IzzgVZqFONR+S7x0yOepRZ9F6MEfXbathBAyVtFzc6+z1Gx8sHnmEK6rt6zuV2UN4j6+As7yxyLIhuVh9jt4H75vCDDHZaVHtFtgUhmJC6fFjfMA7NNvu1/KzSUDNwYcWKerqZdAUlP+2f0QlqQK2tv/1HnbjUohBWzQzkuQoi7g6l8lO908Zvde0PvDDmECEVbimhyPruXZwv/jj0hxR1kbjCfSBOYZXAe8KsG3Xdklr4Uw4GxFqjCh/I4anc3lhv19mYvsb56lsWydP9VYO9rCS7bL4NndHXnAlG3OJVPFGIx4JEEuZ09XGLPZTJEs/PZ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(396003)(39860400002)(376002)(136003)(366004)(451199018)(2906002)(33656002)(71200400001)(83380400001)(7696005)(6506007)(55016003)(186003)(478600001)(9686003)(26005)(66476007)(66946007)(64756008)(66556008)(8676002)(66446008)(4326008)(86362001)(41300700001)(76116006)(8936002)(52536014)(7416002)(5660300002)(122000001)(110136005)(54906003)(316002)(82960400001)(38070700005)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?frqMwB18JLlxsZqwzE6VODIQ5x7qhquzNhe8jmnP0ZKsADz1L14U1gboAvRT?=
 =?us-ascii?Q?SlI3fsMcM1fpYSIzZRfS0HXQm79Spc0RJQITiGCzxQdL1p9yybfdyIwaXRO3?=
 =?us-ascii?Q?8nARV3bYyUCWF0dh4G/xvk0zleX0TtCZWEgunko1rpXsEW0X66aH41a7SWf7?=
 =?us-ascii?Q?rf8bVYKWTpqA+1XT4A3hGskbwRgMbJH7s1kOM7RNt6imLPvNh5yqafGXXwkS?=
 =?us-ascii?Q?0evKJwpsuaK2rhU9brQ3voyiL1osVZFmrhtUH/rTBbrpsqa8xfRbDXdPiZWL?=
 =?us-ascii?Q?z62BnpcbvwRqFn4WuYUgvTHK6+dBLc9h5CBqQD2DMDnhastLaeknkVPgDyNo?=
 =?us-ascii?Q?EuloK9XLSlcj5HnJ+dJvW9qMLncBo5KZ9OEqK9kGU6vDIiriJNWFScMfSdT8?=
 =?us-ascii?Q?S008X/xBvxLEzSFpAgQ5h/KeAS4T4UvCsZpyoluJz1mCULlnyW8cYzvD8iMY?=
 =?us-ascii?Q?JHkJY5T/Y/WOBjk9Pv6D1cM54Lq4Vtub0L5Ks+iCrEVUIiOHCj8uS8pEoETO?=
 =?us-ascii?Q?/jlZTt+doaESSr1MXPbG8BjYrZryBmPs9j8X3UKhAJAGi7e7P4hWZrVP+Rr/?=
 =?us-ascii?Q?+UGha4/wIcJoTegBPvNZXPMJgAEykFsQXcrsI8GrWW+y/MheMbDe7+cGYZe/?=
 =?us-ascii?Q?odjmnmOaD6Cba15UuPWZPRm9tzUh8OrdPd8xXnk0tPyrOpNL9HwuPorAYRh6?=
 =?us-ascii?Q?RgzywP41JklHGOMrUv84MbDSN9uxdT10mkPoz1Je4CfXkmX9YN+qDgMULdVg?=
 =?us-ascii?Q?hdyvZ61AvxZOqX5ojcwytJ1OChMzqS/OazrAMP0XmXhppYGfSktB1G2h226r?=
 =?us-ascii?Q?wpfW2pkS6TuyBNaz10K4Q6lYNWhJWfqG8EE5UxL2AJuUFUhsCQmdcdGoZCh2?=
 =?us-ascii?Q?Y/Xu8uKVddqyDMEt8if3dPsHEU7aawYpcIqpukmtJMoZp0nHDoEHywbdcrQA?=
 =?us-ascii?Q?oT+0dVvyRMUBCIJBcojp1/QdmToXYRtvFa7ENbefGXeWo4ymLE538NzT2mom?=
 =?us-ascii?Q?rowIaG7JQw5tuFXLHzlX4gqPcFobESwBW9ANzigc+H92kgx22Jbj+ruo5nTu?=
 =?us-ascii?Q?LR35JE+0RPKyS1GVg3wH/JcUHhvC2Lu1CZwc7LKf+3mxFb3mFn5d6nySFBBN?=
 =?us-ascii?Q?xcaqvlnsYi9MJIOEcM6lw+QVDQ/DPS9mU/DEcMSRmtos9y85CQ8aIgSX6mto?=
 =?us-ascii?Q?6h4GeF7aJHWCazJq4osrMHCF5vPaYmdoBGUDjYwL3mvjwxA281+X9kyvX/kW?=
 =?us-ascii?Q?ysjAOkXPU97kHblf7ttgkM9Rdhwuqbxq4qGsk4/C9OX4fKTO8Rt8kZe/MBBe?=
 =?us-ascii?Q?BWbneKVl3eu+JLQEttg99B9MBwkapigEKB1xTMr3FN/NV5DW7VdZ6JzyRS/W?=
 =?us-ascii?Q?I9XR1l3YCd9d3Z6oeE1JQn+9Q/8670333CvZcVmIhzZV/a3SBsKcsDZBVILF?=
 =?us-ascii?Q?rrw7bxX751aqXb+RyV0vmXAyHgRCiA/vgPY2EaDcUQ39hjaoOo36Pg8O5kuc?=
 =?us-ascii?Q?F/Eabt5lho4TQvSKTtvMbdbqrimyDB8a+y1olfivuqI4cktqvpYN504R0WwT?=
 =?us-ascii?Q?MBuk6GMf9Yx9ctmp0mBmlFpk+GM201M6loT3xdG8?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fd6c26a-ae87-4f04-8ed0-08db0e68f0a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2023 08:53:27.9710
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: c/Tcxb+Nh8VbCvotxwPfA/+bVaS5q8QCqaLl2iwzebzRe0RZ8ZiXv0DMaohPUu16j6Wt8DpQgTc3AtQkF7tp4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7957
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Monday, February 13, 2023 11:14 PM
>=20
> This adds three vfio device ioctls for userspace using iommufd to set up
> secure DMA context for device access.
>=20
>     VFIO_DEVICE_BIND_IOMMUFD: bind device to an iommufd, hence gain
> DMA
> 			      control provided by the iommufd. open_device
> 			      op is called after bind_iommufd op.
> 			      VFIO no iommu mode is indicated by passing
> 			      a negative iommufd value.
>     VFIO_DEVICE_ATTACH_IOMMUFD_PT: attach device to IOAS,
> hw_pagetable
> 				   managed by iommufd. Attach can be
> 				   undo by
> VFIO_DEVICE_DETACH_IOMMUFD_PT
> 				   or device fd close.
>     VFIO_DEVICE_DETACH_IOMMUFD_PT: detach device from the current
> attached
> 				   IOAS or hw_pagetable managed by
> iommufd.

let's split into two patches: bind and attach/detach.

>=20
> +int vfio_device_claim_group(struct vfio_device *device)
> +void vfio_device_release_group(struct vfio_device *device)

vfio_device_block_group()
vfio_device_unblock_group()

>=20
> +	/*
> +	 * For group/container path, iommufd pointer is NULL when comes
> +	 * into this helper. Its noiommu support is in container.c.

"Its noiommu support is handled by vfio_device_group_use_iommu()"

> +	 *
> +	 * For iommufd compat mode, iommufd pointer here is a valid value.
> +	 * Its noiommu support is in vfio_iommufd_bind().
> +	 *
> +	 * For device cdev path, iommufd pointer here is a valid value for
> +	 * normal cases, but it is NULL if it's noiommu. To differentiate
> +	 * the noiommu from the group/container path which also passes
> NULL
> +	 * iommufd pointer in, check df->noiommu which is set only in the
> +	 * cdev path.

"Check df->noiommu to differentiate cdev noiommu from the group/
container path which also passes NULL iommufd pointer in. If set
then do nothing."

