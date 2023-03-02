Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEE7C6A7A01
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 04:25:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbjCBDZB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 22:25:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjCBDZA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 22:25:00 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25DF64E5DF;
        Wed,  1 Mar 2023 19:24:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677727499; x=1709263499;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fLERleDpS2CAX2MAWMeWf+02U1riTQRldvwZb39MZMg=;
  b=U+0XAnaSn6agYnFu8byD+auiE43sKRLA5u3UsJswljfYnmXUmXkJdTn0
   5CAtqUCah/FgbxsL/npB3tSjU8ueQEsG03gNgIoltDm4iGtrDvElQ7RxN
   0/totj7GZ2bDwPyHRTm1wPpiSTXjnciaBhanXMSiYrxNseCoDkYdh1QDw
   8DHPzoznECgBkjVe4DEmDRLrjDw0XNklcPSMR3SPq0kdAYECOgtGvauO3
   7nYuLa5CF4XRAjHz8SrTGOQg3a2wFfxUJPx7Y5foNb/FnigyAJJy+7lHU
   zfpTbQxjVA+86unkumdxxQHOLDMiALRkdxYbIPp0k573lWIfYvfslpxu2
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="420865055"
X-IronPort-AV: E=Sophos;i="5.98,226,1673942400"; 
   d="scan'208";a="420865055"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2023 19:24:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="677021446"
X-IronPort-AV: E=Sophos;i="5.98,226,1673942400"; 
   d="scan'208";a="677021446"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga007.fm.intel.com with ESMTP; 01 Mar 2023 19:24:50 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 1 Mar 2023 19:24:49 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 1 Mar 2023 19:24:49 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 1 Mar 2023 19:24:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LgmCpbn6RTOmFwbDoRbJE4A6bDlKx+Q+n20s7rCnTp31r40QTGDUkg3xEmU2ROW7dcyxQzq/Sog6QnqM5B+BEynscbHzdExVkAP1O2AoZmWsRUhkwtw6JlBAo+EL8pR1cYL+NaTQYHJ1a/kPmRCm1lNjm/+HNb0ISD9nGLVANtgd6nMitqaUCl/siPIM/qAglHucKtDpIqa5uU4zqT8cm6EX+0gxje9hIFvloUUpNt+ek5QoHg6uhRMqKMym8GzMIwtmlq/cjJ+SX3puo4ICCPS2k2FuItHJOS2DbpMXmPoho/XE41nkyLiE8WXbTvYEKL6D+KrRtrWBX7Rb7DKTkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lxbOl/FWZEeqWXSfgwnRJbDj5cuGTaRxJdACo+l8/G8=;
 b=fDHJCYY0EloQS8w92Pgi4kIgOniKS/vIdO5FNDKPkB+EFzP+BFzf6CNBHKCTIP1Ker6A+AUQQKCTsfgAqD3S0WgujewsRmZzHVGfc1KvonI0I+DbT0ySjEDPjnEWprMGnG55n3zenWSA3HdrP94f8CJmjHxd0EcrYzrW6Mou9plrPo0sJMTm3hJYvXt393L6oLS9nNlb+QPMAlnL6KKN/BGP4z4vELoejkSiMlCgkHA8klcD03pfYTcJYpdLbayaEGItpjI2McSOlx5KQYlzM53b84uuMTE1pF4Rtb3usog0M/6maL+2nJxA54A64lPDvCHto1MsApruoPL/35dDbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DM4PR11MB5343.namprd11.prod.outlook.com (2603:10b6:5:392::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.18; Thu, 2 Mar
 2023 03:24:46 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%8]) with mapi id 15.20.6134.030; Thu, 2 Mar 2023
 03:24:46 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
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
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: RE: [PATCH v5 17/19] vfio: Add VFIO_DEVICE_AT[DE]TACH_IOMMUFD_PT
Thread-Topic: [PATCH v5 17/19] vfio: Add VFIO_DEVICE_AT[DE]TACH_IOMMUFD_PT
Thread-Index: AQHZSpxNXWm9KiWJ2Ee0gC65QSF3Ja7jIF2AgACHHYCAAKSqAIAAATZAgAAE3oCAAAG0UIAABx8AgAAA9gCAAAQbAIAAAylwgAAMGYCAAYeq8IAAQA+AgACctxA=
Date:   Thu, 2 Mar 2023 03:24:45 +0000
Message-ID: <DS0PR11MB7529CCCF483210F5EE027939C3B29@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <Y/30TEk3t7q/D0Ho@nvidia.com>
 <DS0PR11MB752931AD2B92DE9A1A574375C3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y/35ZTi69p9cCuPn@nvidia.com>
 <DS0PR11MB7529B6647B5F4B7691FFFBEBC3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y/4AzJbjeR4R2rcO@nvidia.com>
 <DS0PR11MB7529175CF279A820C5E5E091C3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y/4FDP8H1qRdgVrL@nvidia.com>
 <DS0PR11MB75293E34AB7C53F7ABFC0E36C3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y/4R2SRFKoRFg4qK@nvidia.com>
 <DS0PR11MB7529E456C277723146A09E2FC3AD9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y/+QIz3VT7iD0jZ5@nvidia.com>
In-Reply-To: <Y/+QIz3VT7iD0jZ5@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|DM4PR11MB5343:EE_
x-ms-office365-filtering-correlation-id: a3bed730-1617-4723-260c-08db1acdabfe
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qlFhEuzyz79HOLblztTHG/kbkw5YP2sQxuyH6V0kKiQ0mGugAYhfKhXw81X2YePPhgkkzo8N1UEdyThP70U1ro7bEiz8qRIDa2XsapgHWD0VvPh5YarPQ7JV14/+F3O1B+xTEXlXezLXhkUN3UfPSbyY5zovEyEo979r0jDrHCHuIre4lyMQrRcABaSlyn8pUYPOQuyLK8r+izZsOPvzPHz1kWbQvJttXD4O67iy5+qQfgjpwAkBWOGDcizHJGtnE0rAjIpxtc/9eFycpo3gjeRfqRwPhG/3T4r7LvLnSLD42/qua/N3IRmUf2zvLNjslnGkp8idStDV/jVHJC/0T3FbgsKf+vKus+0wpI1kGGMElGDPPZZOSTQXovMIY/+TRmhZAQZ2bdp/0nsYji5UmfT+sr63qshFaYfj08aOap/2pSJlfmGzZpUXTItxx61WIdAvBpomRz5+kTfPmFDMC1uIlojOFGjN2ufysz0t5wLKkbeCIHs/mcVYRMWwCEATEjxQRk1iwu+K71Rn1PiFo9FLYtC2QexFoyd3wXrZI1zMMp+ZIhc8i7jOK9vQCgVOtKqukP1kmUNnY+DO49MBX2J48nWopLIeLCYtTHVrv4XEOAh+3Keu3W9qDG1y4o9EXErUNAiGM3jnU8hQuOjrIzeShMmQqh7DW5/G/oEGQdacfwfvkrPaB2nRDqOFLTdL
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(346002)(376002)(39860400002)(136003)(396003)(451199018)(83380400001)(478600001)(54906003)(316002)(33656002)(4326008)(122000001)(82960400001)(64756008)(66446008)(8676002)(55016003)(38100700002)(6916009)(76116006)(66476007)(6506007)(9686003)(186003)(26005)(7696005)(71200400001)(7416002)(66556008)(5660300002)(66946007)(52536014)(86362001)(8936002)(2906002)(41300700001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?O+Ifhox0qFsqZKa1IAlroemirPIoiOprpgQX52w/1kyM8SI18bEk3NQdJJsG?=
 =?us-ascii?Q?6On7iAbv1/zUoYqDfIkagKFXqwWljpEyVdFUKjQOnZDHVe6RRNRaMPNONp1e?=
 =?us-ascii?Q?e70DB5ZJ+SRD4gxtQWsPE4jLlMGLhA4U291+TOGYGkzvOx7lucoC31qeSCJp?=
 =?us-ascii?Q?d6/RTQPkHOEJXLLsa32Zw4Ix60la5f5a/LyFlcw7Wu098CjbBdX5ZghZQ3+P?=
 =?us-ascii?Q?YQDlegECcTd9IRZtKzR4Idw54fC9yueNXO5IDkg9LJAikiHJ0SXb10ANxnwO?=
 =?us-ascii?Q?FTfiX0EnzVkQSW9D0ruN/YyIpOvKQs3Z0Sbxnay8Nq7SXMQYCPXrDDAsxTJQ?=
 =?us-ascii?Q?oTCcyK4s1QFeMZH9gWEJ+JBzleU9wKWOyVHLMxZUtUBITlhCRDD6UZK/aQbB?=
 =?us-ascii?Q?96vBHOgGoZqArZzdW17MpKsGUTIzlhnRge9/k1b0FD/axw4xTyr8LTYMwXrc?=
 =?us-ascii?Q?8LLAfHXpUpJQ6R+eVS+EDzqWJMZTVEeqnn7JouCtOvXMeojohUu0Z2ntsSjp?=
 =?us-ascii?Q?Bi+ERE1Vqll7HQR8g4BSx8gy8erQCXVDIBDjDP+tHhqwFVXWr1lISE1BlGMa?=
 =?us-ascii?Q?qpJAp38Sgfw5Grk7EtKfO55jb3A/tAQKMrcIie5BZVvN6lmILhDS5vsr1x5H?=
 =?us-ascii?Q?BBy5mD5r60/uJGyFwnj14n8WBga+qVuPxAPQOZsfUFlPfWTyPpzFQQdDsR96?=
 =?us-ascii?Q?LcePEj6hOKk4zUxavwOBN1r5FUON+ojcUed6CGPXW+yeeLDgzeUOKYRwL+6i?=
 =?us-ascii?Q?AyGNQmlHw96Wcy4zRpqxtCoRbH1CgVnK+BbEj+f4dDrl9RtrxFYFNzWqCRoA?=
 =?us-ascii?Q?bAsvpMntJghjOGVyxMfpHEjxhbCnjU2gzGR3oGzEDP/va3bdpbFd/OPcJhz9?=
 =?us-ascii?Q?0o2/qwtvCbimQOamPHKsUzViW+nrTjna3xAlGoso6AZghOuIgmXLVCqXMOKb?=
 =?us-ascii?Q?vZk7zfGnXqtzoJxBFS3Li9owLCXJVooZhkaVi1FlKD/MSNQXWtdk/myB6gXz?=
 =?us-ascii?Q?5Azm5NadfCv3JBVS8qcyWoIXja9a4QqGRySwjj6MRbo82JxgeFHSryqaEYAF?=
 =?us-ascii?Q?Fx7my0WUheEqEgHnV9lbCFpEKzwb//JeNk4omtehHiZGcbBCs8F0xR8TcqIt?=
 =?us-ascii?Q?CWAcR71nFuKP5S38BJrgKdKGZhmDPyZBOSNwTBZIM5/xo8iNqkPetFzgPBZ5?=
 =?us-ascii?Q?TwbfCJHLChj1kbNg9TiCssLfVDbUo5rvpHEX9Tg4/Ei7L0BH5haqz4DxZsr4?=
 =?us-ascii?Q?ir/j4MPqMRgGcfsZh5Dl7eFE7fyU3K1Vbf1WNsNL95yT/XYKdDxnfIY4ccL2?=
 =?us-ascii?Q?qFFi0nS/rD8xy/ZolkeL+k33vPTgBZnnb6POA3+4DlHAkQKQy43q+hAFEFOE?=
 =?us-ascii?Q?X8F79vKieFyX1/pUgbBg0z0pIswFPh5thoY/S+hjmEL5JbWZoh1Ql+Hdo5E9?=
 =?us-ascii?Q?AQZZndC98fl/kLy6ZhinMgkpfL+33FACSax24IssxsP4GpQtphQdLk/NIl8N?=
 =?us-ascii?Q?DdjPbaSQ5JXZzvKZ8jXBOyq0zt+hDqhySTXMstqwSYwh0X6vx2vGPUJt/l4M?=
 =?us-ascii?Q?VbCuBiM0O3JkT4i+5bPxzPp51VkcnGCdtJqoMpPl?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3bed730-1617-4723-260c-08db1acdabfe
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Mar 2023 03:24:45.9078
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cgb+lu5gM6AHq4cw26FdOOyPAGA8lrGEYgFraU3YFYMP+Qg4iIsdOjcBx+LjoLvCRrlIPwk9YfMMucrTAw1aIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5343
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, March 2, 2023 1:49 AM
>=20
> On Wed, Mar 01, 2023 at 02:04:00PM +0000, Liu, Yi L wrote:
> > diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
> > index 2a13442add43..ed3ffe7ceb3f 100644
> > --- a/drivers/vfio/group.c
> > +++ b/drivers/vfio/group.c
> > @@ -777,6 +777,11 @@ void vfio_device_group_unregister(struct
> vfio_device *device)
> >  	mutex_unlock(&device->group->device_lock);
> >  }
> >
> > +bool vfio_device_group_uses_container(struct vfio_device *device)
> > +{
> > +	return READ_ONCE(device->group->container);
> > +}
>=20
> As I said this should take in the vfio_device_file because as long as
> a vfio_device_file exists then group->contianer is required to be stable.

Ok, let me store vfio_group in vfio_devcie_file instead of reach
it by df->device->group.

btw. With vfio_group stored in vfio_device_file, it looks like
the is_cdev_device flag (introduced in patch 14) is not necessary
now, we can always define the group pointer in vfio_device_file
even group code is compiled out, then we can use this group
pointer to check if the vfio_device_file is used in the group path
or the cdev path. Is it?

> > diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> > index 121a75fadceb..4b5b17e8aaa1 100644
> > --- a/drivers/vfio/vfio_main.c
> > +++ b/drivers/vfio/vfio_main.c
> > @@ -422,9 +422,22 @@ static int vfio_device_first_open(struct
> vfio_device_file *df)
> >  	if (!try_module_get(device->dev->driver->owner))
> >  		return -ENODEV;
> >
> > +	/*
> > +	 * The handling here depends on what the user is using.
> > +	 *
> > +	 * If user uses iommufd in the group compat mode or the
> > +	 * cdev path, call vfio_iommufd_bind().
> > +	 *
> > +	 * If user uses container in the group legacy mode, call
> > +	 * vfio_device_group_use_iommu().
> > +	 *
> > +	 * If user doesn't use iommufd nor container, this is
> > +	 * the noiommufd mode in the cdev path, nothing needs
> > +	 * to be done here just go ahead to open device.
> > +	 */
> >  	if (iommufd)
> >  		ret =3D vfio_iommufd_bind(device, iommufd);
> > -	else
> > +	else if (vfio_device_group_uses_container(device))
> >  		ret =3D vfio_device_group_use_iommu(device);
>=20
> But yes, this makes alot more sense..
>=20
> Jason

Regards,
Yi Liu
