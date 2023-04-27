Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B621A6F00E4
	for <lists+kvm@lfdr.de>; Thu, 27 Apr 2023 08:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242909AbjD0GjT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Apr 2023 02:39:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233120AbjD0GjS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Apr 2023 02:39:18 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5687DED;
        Wed, 26 Apr 2023 23:39:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682577557; x=1714113557;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ORZ5A0yiBUpvZecWZZA4GU5VGxzMMkI0NjrM1uudSas=;
  b=Y1mneuAGdo3VXgqIjIFaFX59NCV6u2xCCk2vLjCUk37fO/4IlJ11BQiJ
   sb1NXKoQaDdZ9fEnZAFSJ9GNuOo9VgYVKJciy4vwBRdNohdyNNR0whrLT
   6ZpelerekP2PK7y218U0w1nZGGXZCx57Yq+j2QD/E0j+LAPz4RPloi91y
   rteuy7vL7zeSJ8G7rEt+cLpX1rfUuNQ7jREn6Kuu2/ijLZwIjA7vwC3LV
   6xEFmx4jgywaLo8AEVahdvBIQY/kOuW4VluDEp2EaVBKfGfM7fZTe9RKw
   pPt92DZkA6gA8/xPDsJ48Em+9cOMqdUImFEekS8/YQIYoOjQlny7/zlet
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="331595172"
X-IronPort-AV: E=Sophos;i="5.99,230,1677571200"; 
   d="scan'208";a="331595172"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2023 23:39:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="644564791"
X-IronPort-AV: E=Sophos;i="5.99,230,1677571200"; 
   d="scan'208";a="644564791"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga003.jf.intel.com with ESMTP; 26 Apr 2023 23:39:16 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 26 Apr 2023 23:39:15 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 26 Apr 2023 23:39:15 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 26 Apr 2023 23:39:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=REqKhQfKVExQG9GKH+Z8CI2Ivi6BSxNmZBbtgvBoqV9I3CohCLuWwUUpL0Hxo1/NsFzhqRgeeTZlNN+qSMpbxtzWla062fsg5GYJdd7sBMn6To6xPU4rDNH0Oh3nN6F8CEWZ2wjDUGRKMEhhYNZSrFARbpx1QvRfra+cUdM1O0KkFPKoVGUfEwnD2kA1yP8eLU0TnDjTGEmYKqlJZzslC34QuyRwe5XZCw02ye5TlBmqH9vw81isG3KmsBH5fSv0VIYOCVz35ri0W5n4BlRMY4o1CUtZYFCM2/SsPegSXVxAAGKYg8/sylptT1qe6K0d2rbuahwFiJkkWq8TbJRchA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KhdPLaaIphoPo8TIAdHCOXDB7UgVTGBgrCCgKKWdRQQ=;
 b=Gh7nDtJ8bCND9iCXWC7tlpmzNPgJJWkzELDoYxL2NKz9qC5b2/5kXKWeoPudAhV1yZVl882wIPiqwTERKRTTFH+fis2dMFr+JNgu7nPkUs3/OC5/zQa8SbB8EKfYzCH4v8zjDyfIGGuyELzfKhqhJcOGDFjLYW9rszzQQpnObnmj72PJNoRYbI8/DxvnGB61H/OVpRvW0ILhui9eZSMsu1F29wNORRokletvaCIrPmAnAsqknqyLiCNSXlmHMoOOZKngkbpknmFWsRjVViyeRNo6kCciZ/dPTUfF7/7H5pLtdanUC1OL+vT9HxN1L8dWDzuzu7OBfq7Ys3sBRGSB0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ0PR11MB5615.namprd11.prod.outlook.com (2603:10b6:a03:305::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.22; Thu, 27 Apr
 2023 06:39:14 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174%6]) with mapi id 15.20.6340.022; Thu, 27 Apr 2023
 06:39:14 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
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
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
Subject: RE: [PATCH v4 2/9] vfio-iommufd: Create iommufd_access for noiommu
 devices
Thread-Topic: [PATCH v4 2/9] vfio-iommufd: Create iommufd_access for noiommu
 devices
Thread-Index: AQHZeE8IJJf3ZFXia06J+R1rLA70za8+tH4g
Date:   Thu, 27 Apr 2023 06:39:13 +0000
Message-ID: <BN9PR11MB52768AF474FAB2AF36AC00508C6A9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230426145419.450922-1-yi.l.liu@intel.com>
 <20230426145419.450922-3-yi.l.liu@intel.com>
In-Reply-To: <20230426145419.450922-3-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ0PR11MB5615:EE_
x-ms-office365-filtering-correlation-id: 6a2a18b2-88d5-4a60-3819-08db46ea1d6a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XAqOUFMGU+KIg0cdYQLWh0ljvCw6u9u7cZtf0CUv3fhnMU/agJiUSb50++AfJT2sFvtTHAw/xHrckS/dYmb2yDhUChgiNDcOE9We7Llwm1CeWo1uSdEz9TGfL6W7EC9d+ac69XXGbUm+cdd7hREIXMtmgqQRaVy3S4lSXHrpJnjxIi45GL1eJpuFFaxvn3vOn0sqkOptdm3pyT5iahbdpRHTIQBrrMBxagN9wLBjrQ2txmucQ8xHGpXreFMz1qZRjgClL8xR3b5WMhTD1DiXHj7IZ8bf/EZGLjOw+hX38TE5D3jt7Obpj+bgXH3HsxVasWUru+ZLlTXyELYKFovJbYlWqAR08ybyASCEJXR7pDuhZ7x51NPgqG59SqopDt7m2nN2FXsJJNBsh3oSuzdlxW18s8M03D4MG30pWnUiona+vJ3TmMNYVAqS/qw3yglpyafVR4OfiGBWDHx363Gmo8oyb9RGr6SlmxkkCO7GitaEP57gBvagU6VrcNXCp4a2mZvakA9NMkQAFktKmY9plBQwg3NAGinnWb6rX2ew5JZ1T5hTHybeH/bovINys9vFyWqhYvfBnQK2px56GJdGCdNENp9wrlS3Hs4A8JiKNhibo5Y33iDvwOeAS9JL5lH0
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(346002)(136003)(396003)(39860400002)(451199021)(82960400001)(71200400001)(478600001)(54906003)(7696005)(110136005)(186003)(38100700002)(66946007)(76116006)(66556008)(66476007)(316002)(4326008)(66446008)(64756008)(41300700001)(6506007)(26005)(9686003)(86362001)(8676002)(8936002)(33656002)(122000001)(7416002)(38070700005)(55016003)(2906002)(4744005)(5660300002)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?dHDAVYd/qIlhgg2OfEqY3TDEa0NZyyDMZeh1FQ4qri/vlafJ9Us0k2on7ntr?=
 =?us-ascii?Q?U61dsKZwCz7gVL3bJolIVS+9KHcctp7xJCB6uaRrfIYwDrR3JouM9qNBwAFW?=
 =?us-ascii?Q?NJrfVoQ+TTI4S3Mt+FXUDsuhc7aSmDSHpGCMl1r0hGXjFl7qVL1jdytIJtir?=
 =?us-ascii?Q?WfCxB3oxXGpkbjQtoBwMH4m7pefzqPetRmNXCNaMaDxh5TbJ1s1VBUIB3f1G?=
 =?us-ascii?Q?7l+a00zJ978SW5eutvto9raF4K9qbNl5sU5VgCZAogdMfS6+Piof0T8eNea3?=
 =?us-ascii?Q?R88W0IMVapsbhdc4P4DUxzA6h0J3RDDKGzSHwdMQ2vVbdnymnyYmrTsEkpGr?=
 =?us-ascii?Q?Tq4wMmton+50W3Je3ve5yhlqCchKcZDYO0R8PMSD9lY3HA+WH8BIxqz08Tiy?=
 =?us-ascii?Q?rjdKjGsY6NgpCY14A3+j7wTjFdNv/J874TgpNVK/OWKCXemNj/d60fXJwPj7?=
 =?us-ascii?Q?x/ZTQ0XVpWv3EqfwbiqEy/iAGOht9puh9oioed8jHVHjCr8Cyp1vF5RSqcn3?=
 =?us-ascii?Q?BMltQwa+NuLfCh1EW5a1xccRTLUa/GU0ET6PlFwT0LIiLmqza8+z6o3JBbKa?=
 =?us-ascii?Q?3W2GPpFd1Tg2zwd9QL0peqoMYBBJuACiRf4NQFdtC953UVk0nJ6L/8gkzFJf?=
 =?us-ascii?Q?vVPPr2xrXcbOVr8v9ycVnA/prOhm+sG5sz8jhYyFc4tEGjUgQwFkbzMSq5aV?=
 =?us-ascii?Q?RmOxLA54+nB7ZM/quX7i6dokEGzDaSc/9+c5pQEjFfvqScXnn1ryv20ghu+4?=
 =?us-ascii?Q?Zc0rHFM6zWACRPT8TpCRBDspoaBnO7x4gEj99JCVGB2LP5c3EQBW1Jvo5Uot?=
 =?us-ascii?Q?vbHesKl80vEboGd67kKv/pahKzU1sus/20Oz6cqs+06Wp4U2iuoYu0l30qLh?=
 =?us-ascii?Q?lbDMmJaaXIogO86XIgjN4cAj5y+8M0UNMdHdv0va0CRDUAzfjyihJI4/b4YK?=
 =?us-ascii?Q?/i8RPvpwF6AlBlEkPjCPCbfkERlsP66XJPtI9TKZje8FW8KQEZJHVG0CONcs?=
 =?us-ascii?Q?b8MJRcEYDPicChk9UH770xIKIbySW05r2+MOMmbhkHBWJY89lJzRJ+cLk1ul?=
 =?us-ascii?Q?07/dDuQmbz3NEfJtHXKqCYbTPkjQnRCJAHiQ8/Nsm2hMIxsjbtfUYFmqxYGO?=
 =?us-ascii?Q?dvW0SWBeJgnu/h+I5ow2Uqsud87V28nj0BkGbK1HE9eL51DTOuxn/ZOrlIJk?=
 =?us-ascii?Q?W7z6acFm4E6XPJrFKONdF7W1f3x+LcSXkx8sXxsaBcJ8ts3nmxTi0AxOWFG4?=
 =?us-ascii?Q?ny0IKDHGGvbhW9LVyMHLAWmM5tnO8gimTLAmfqp45E4OBN11dS4YUy8jQzlP?=
 =?us-ascii?Q?La7VdOa9u9nKGNnaUJ9RpWTJPQrDp+XXQJlKajELABRsqudfBaWZQkiml+eU?=
 =?us-ascii?Q?yFZwcbL6WWoRqB8OYq5TRZ1dhCRr9vP34Y83u52JIEaSRLjedpVb/51GSV/t?=
 =?us-ascii?Q?3SMp836i+alImRd/zx4RXcQn9OvRzBy8TRFcl9H+LiFI/ipkJh+IIdSQrOml?=
 =?us-ascii?Q?vbq1x+T0JlfsEy02agI9KoaSa4s0pQsPHm1+S7/qE/ph50IhBtAglnETMk7Z?=
 =?us-ascii?Q?AG1eEqx2QnXnUxstrwVAZkJ9hhVJPhrFIX3rJ5cR?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a2a18b2-88d5-4a60-3819-08db46ea1d6a
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Apr 2023 06:39:13.2730
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NJa7CALchOHfPE1574+u1kkOoAisTG6GyXqV1JFLDD2KGKESKzvMS45LqSHfBZlW6I70FafiTMFxLEj/SRSoJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5615
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Wednesday, April 26, 2023 10:54 PM
> @@ -121,7 +128,8 @@ static void vfio_emulated_unmap(void *data,
> unsigned long iova,
>  {
>  	struct vfio_device *vdev =3D data;
>=20
> -	if (vdev->ops->dma_unmap)
> +	/* noiommu devices cannot do map/unmap */
> +	if (vdev->noiommu && vdev->ops->dma_unmap)
>  		vdev->ops->dma_unmap(vdev, iova, length);

Is it necessary? All mdev devices implementing @dma_unmap won't
set noiommu flag.

Instead in the future if we allow noiommu userspace to pin pages
we'd need similar logic too.
