Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72FE170CFE2
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 02:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234626AbjEWAzS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 20:55:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235274AbjEWAy4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 20:54:56 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA3A53A8B;
        Mon, 22 May 2023 17:49:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684802968; x=1716338968;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eUiP3zElkuMbWt0HYsPy49TzNZKhCTsPySMUrw/RHig=;
  b=hgu0bqP8a44VkY5hlfJ3PUz7kvorCYzCQ7xwTMvtdF/e7pqz0121idv9
   Mhn0ahvAF+h4gLmpAEPD5fkQGGHjhzpBGlXO31Ia9NO7HRyAcB/TYNkgG
   KXLsZV531FUHQNTyx0XaYVBN+JDIBsY168vEB77yD2RVt3aRzG8PuFc6c
   IO1pSZCqfLKAtGs032IZNN9tKCSca1ZmNJqMIyGCoYe6vqzdVXu+6K7oY
   vjIRgVJR+LDKUNyGriVe7Q2iD9IH5yqxGlGZBzBsDDqmAqwae+MXgwjLt
   dPaxKRfqOWDVMQARZm0AJy5S/OkKHyTDBUsMprvf+t1yl/KqWz3xJn5NA
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="416548890"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="416548890"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 17:46:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="1033841811"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="1033841811"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 22 May 2023 17:46:08 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 22 May 2023 17:46:07 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 22 May 2023 17:46:07 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.49) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 22 May 2023 17:46:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IIHHi4cCQl2CbXaRoLWCtddMGsgwTik6VtqN7nQlt+Ha4dq1+QnmpSQKimXdCAZSKN96NJR+u4hfUcQFRsQeG1UYbwXMjh1uosu5MlMDQN7MytLvHXKpVOXSNLoa4Xb7iffFe2m6CSDv7rdMFBWdRz7ykEfke+NFhYJKn4fAHGd8r6C/KxY0Xp0hzXvJW4cEiSkmvEWHeQLwwUbYZ7/MhfNup6HgXBjFrFA6v8LBfOfJoA4kkhbWs9ZtlAXXGUxXiiJBA057KoU+B6jK3MEDnLpKehQ1CSa2OkPAH8kE/e70qjqTvs4vF2P+r4n816eabWJcSGQ2/rQkE1D/BbEDEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sIuo1e6s+6OuD7TuiM2/hTQg5jV8a+ErKs49xRUC1rw=;
 b=kKciCVwDmFt9ByYNx5skhHk/AQubo+7twqGDoDGDw8WJn+R+1dM/T570VSlyLDvDP8qAuqR+aJFYBs2KNbST1NpzATApPDmwWqQ8Aqmpwy1DFnB8mm3WwsInGLJlucj++SQDF2XimLx32WAmS3UyTv2uhpaplFqaGp0wVvn7X0dMHedQAkCMy04ZpJ/Xl8253i5tT+fFDNcjkwhDk3ar+T09mdjfYAsHAkOjZWD2UKz7is7jPAR/1z+CqJnJpy+o3JrddwG+LMKtQSOEkILJSFHxZjnRQD16JBRwAANte+8WTARmTRrso2bhJCFeXmpzq3uH5ov2QWY5OqCv19YDNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by BL1PR11MB5400.namprd11.prod.outlook.com (2603:10b6:208:311::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Tue, 23 May
 2023 00:45:59 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5%3]) with mapi id 15.20.6411.028; Tue, 23 May 2023
 00:45:59 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
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
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        "clegoate@redhat.com" <clegoate@redhat.com>
Subject: RE: [PATCH v11 10/23] vfio-iommufd: Move noiommu compat probe out of
 vfio_iommufd_bind()
Thread-Topic: [PATCH v11 10/23] vfio-iommufd: Move noiommu compat probe out of
 vfio_iommufd_bind()
Thread-Index: AQHZhZ7gCv40hP+VNUW/X577iiRDkq9my5uAgABHyvA=
Date:   Tue, 23 May 2023 00:45:58 +0000
Message-ID: <DS0PR11MB75298D1BBAC5DEDDACE64E94C3409@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230513132827.39066-1-yi.l.liu@intel.com>
        <20230513132827.39066-11-yi.l.liu@intel.com>
 <20230522142435.298ea794.alex.williamson@redhat.com>
In-Reply-To: <20230522142435.298ea794.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|BL1PR11MB5400:EE_
x-ms-office365-filtering-correlation-id: cac66a53-de7b-456e-7870-08db5b27135a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GAfB0mfk6npG3eBzzsEjM+qs4M67JlH+f8uvE9khGpaAZB/YVtIU7leSosBSea/rvOrWNA4jHf4AwNm/beLiqMRqM5TIbcMy/7Del2vaPVkCXjVF0xQGmXrGDHAJRGN5mQKz/pAmhTPwgFYatASrMWIsjLsoKSsdXsUYEZfQwkXrH2TrUdcEIRmEBC5BDKTxXrAMdFnwxZa8ANrLz5gZYFz7s+55Gp2vpaMDmK7cmhwadz1FmweDGlQKMJVb6wr+fkD+QGNbQyp5arKuzGoL3wgTcoJuWAfcNUftyxRQ1qHonGQdMDJGjciQnR7TSIZvTiNu4RYeeKO4hHlQWN5NNDvWTEtnoAWhNrjsa7b7p3uqj+6+EFgnuPmoMM8N7aNUsPVMA08ZNhXRsJkAUCorkPzpn4ScFDqQr0QiZgSG0+BMTLpP8DJ6/rDPed9C7dytOM+7sdVGu4CRA8eFYZiNXufee0BDkgvngBReQPRhFCaeLoXElaXIBR7yOYBsabz2qxg6zcpqKpl3gfGjhH37M37ym4/xTCmRmI61ptPxTN/NmOGyxXjxiAG06Oz/mdOckWJ4bEbTAqeMXMCZ+NawkupSge3RAy5OuZZlj2L1FV46WhVOkR/2HQRVQrXdCD1+2b+CWF1G+51FEoQdw93Glg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(346002)(376002)(396003)(136003)(451199021)(2906002)(7416002)(5660300002)(52536014)(83380400001)(8936002)(8676002)(76116006)(55016003)(66946007)(64756008)(66556008)(66476007)(4326008)(6916009)(54906003)(316002)(7696005)(478600001)(41300700001)(71200400001)(66446008)(33656002)(86362001)(122000001)(82960400001)(26005)(6506007)(186003)(9686003)(38070700005)(38100700002)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?CXuHKru43XwRQDd+wk0QFtVqBDewzjpU/X9IbsmoI721Ewxe+jxa3JpHPD7J?=
 =?us-ascii?Q?4z2lbaFZv2s7kVvbq/1ZtAdHIVHqXEemqpSNlMWmkv26wLPQRayckbnPNkbN?=
 =?us-ascii?Q?swS2p0zMeymUwTNQbZU87zuHBj2THBnZRcG9FCfYh2TSTo89Ya0M3e9O5ZOX?=
 =?us-ascii?Q?nrvkmmVyLEfa/XZGBnNmcFWTetL7ABOcNW+j+PEmZPZ/IEdO9ezkppijE+zl?=
 =?us-ascii?Q?7njb8bEx/6P6Mm/Rf1kbtEd1mAnGjTy2WQjVrjxVPZW4E42cRzC2m4C+t4P4?=
 =?us-ascii?Q?yylrKmX+oJdO9FoLCzCO+G5H/mJzdA6uuFq++AKASyWyu6THLDg6Y4XYoCI0?=
 =?us-ascii?Q?gMfJyGO8KM6Dltr1toldwlzjuikGa+H08gI1lyuhYNI0xB2VtGTmL4a5unMH?=
 =?us-ascii?Q?78JzJ7GoINBc74W0Q/fH6xsTqeMP6Rswg4quhOawk3Ne/1Crl1oFVLQE4Q+P?=
 =?us-ascii?Q?lOs2XGkbsZDFUQIqHhxS1CEj2BP+MptLp2q/z0GUaIXnTqCrduHIjUBlCoiB?=
 =?us-ascii?Q?iFOcwNd2A0QHj93AtevdCX79I1O8pC5/CQOD6LsQJSSJKI7EqpbFKbytuxnv?=
 =?us-ascii?Q?8mTty1LuDR4r4h8/Ftkb9O658lp1m9wSutjzPVUOgoxSKDBCDD9zWpmgqds3?=
 =?us-ascii?Q?PRWGFNzXf+3sHvdjsbvdu454pHWldbzvVwGxA/aN2SvF3DxphK3yqSZA8cZi?=
 =?us-ascii?Q?0H75pbRZna684zbUsE4YhCKJTZvB3Nadh/XRJeX4Be4hyShaRdOTtWjOf1CW?=
 =?us-ascii?Q?MEENhJlJ/HSIrvKJYlKoEXbTMjfFqF56S4pLopexwQAtwCextmQDbvZTTJmg?=
 =?us-ascii?Q?vHux8KVuhDPpFu+oEFOIGI7K99rWVVQETIL9iVAr3M2ftTnDBUteZj9PLQwP?=
 =?us-ascii?Q?oF+BTmGhYWigLQF8PBHnSXvdlVKqVXaq3EQI/oZPzTV8WjTaRLtFJDQSrVgp?=
 =?us-ascii?Q?OM9yj/jxDSFEA0EKeoerITJ69XqdfIjdYO7pbqmWUjMFYwh0Lg9RyyH6ihoX?=
 =?us-ascii?Q?W1JrvX4tb+8EbHYjDe0OMWPZWPle4HrZXuoDfQwsXMkgpBNp8DYNQS/FioLh?=
 =?us-ascii?Q?WKLg0+j0ItXvmTiBlQd5fi+EoF7hE+iqufZn51oWss5cCzt9yMFuZbv3y3FV?=
 =?us-ascii?Q?K3Ia7RMPmun+JkHccoPC+dFt4wLLgNtEvuDOBvbjoJ9MDuZq/Yqzx0ZUokyF?=
 =?us-ascii?Q?EHF1+hRv+ziQlJkEoMo+fUlJMkv1jQVm+7wMlGchH4v/m8sE3O3sYf/6Leja?=
 =?us-ascii?Q?qIYvAkzFNoS6ICQmnqTKPWd+G6G5+ScAcYH4FEJMZPAvv8OokAZr67mSb1qD?=
 =?us-ascii?Q?mhfVhKBGmixTFB0943iC/pSpLEwo5jkv90IC5eP35Y8rEuBSVv8M2crP+Uxw?=
 =?us-ascii?Q?jVElGX/LEUO3MoJJB65zGTRXyxUrAze+Y34vHC/nBzRhUyl21OFQ/Bbo0XOb?=
 =?us-ascii?Q?2vauci9rfSDO1qKC4H9UblxWYPp/uxCLydOhhqqBRmsPdAsUWUqYkhIgK6xu?=
 =?us-ascii?Q?Q1YWmlZm+D7kIBdqgBgY6pRiz2Ag7eENVaZkr/0/w0mBDt6KygUP4ZaLCQC3?=
 =?us-ascii?Q?rAkXmLxQiVi21nWND/Dkqc1fr7Bxcr40L7BRnY/B?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cac66a53-de7b-456e-7870-08db5b27135a
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2023 00:45:58.9495
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vu3OiOKKHSErbzxo0StBVLlvGBC2HgLjQZsNKAe3nGoRTVBfqSDSyuwfDmOqclXRupOy+j2ClDWxtqepgwoPKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5400
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Tuesday, May 23, 2023 4:25 AM
>=20
> On Sat, 13 May 2023 06:28:14 -0700
> Yi Liu <yi.l.liu@intel.com> wrote:
>=20
> > into vfio_device_group_open(). This is more consistent with what will
> > be done in vfio device cdev path.
>=20
> Same comment regarding flowing commit subject into body on this series.

Yes, I've modified the commit message in my local branch.:-)

> >
> > Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> > Tested-by: Terrence Xu <terrence.xu@intel.com>
> > Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> > Tested-by: Yanting Jiang <yanting.jiang@intel.com>
> > Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > ---
> >  drivers/vfio/group.c   |  6 ++++++
> >  drivers/vfio/iommufd.c | 32 +++++++++++++++++++-------------
> >  drivers/vfio/vfio.h    |  9 +++++++++
> >  3 files changed, 34 insertions(+), 13 deletions(-)
> >
> > diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
> > index a17584e8be15..cfd0b9254bbc 100644
> > --- a/drivers/vfio/group.c
> > +++ b/drivers/vfio/group.c
> > @@ -192,6 +192,12 @@ static int vfio_device_group_open(struct vfio_devi=
ce_file *df)
> >  		vfio_device_group_get_kvm_safe(device);
> >
> >  	df->iommufd =3D device->group->iommufd;
> > +	if (df->iommufd && vfio_device_is_noiommu(device) && device->open_cou=
nt
> =3D=3D 0) {
> > +		ret =3D vfio_iommufd_compat_probe_noiommu(device,
> > +							df->iommufd);
> > +		if (ret)
> > +			goto out_put_kvm;
> > +	}
> >
> >  	ret =3D vfio_device_open(df);
> >  	if (ret) {
> > diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
> > index a18e920be164..7a654a1437f0 100644
> > --- a/drivers/vfio/iommufd.c
> > +++ b/drivers/vfio/iommufd.c
> > @@ -46,6 +46,24 @@ static void vfio_iommufd_noiommu_unbind(struct vfio_=
device
> *vdev)
> >  	}
> >  }
> >
> > +int vfio_iommufd_compat_probe_noiommu(struct vfio_device *device,
> > +				      struct iommufd_ctx *ictx)
> > +{
> > +	u32 ioas_id;
> > +
> > +	if (!capable(CAP_SYS_RAWIO))
> > +		return -EPERM;
> > +
> > +	/*
> > +	 * Require no compat ioas to be assigned to proceed.  The basic
> > +	 * statement is that the user cannot have done something that
> > +	 * implies they expected translation to exist
> > +	 */
> > +	if (!iommufd_vfio_compat_ioas_get_id(ictx, &ioas_id))
> > +		return -EPERM;
> > +	return 0;
> > +}
>=20
> I think the purpose of this function is to keep the iommufd namespace
> out of the group,

Yes.

> but we're muddying it as a general grab bag of
> noiommu validation.  What if the caller retained the RAWIO test and
> comment, and this function simply became a wrapper around the iommufd
> function, ex:
>=20
> bool vfio_iommufd_device_has_compat_ioas(struct vfio_device *device,
> 					 struct iommufd_ctx *ictx)
> {
> 	u32 ioas_id;
>=20
> 	return !iommufd_vfio_compat_ioas_get_id(ictx, &ioas_id));
> }

Sure. This looks better.

Regards,
Yi Liu
=20
> Thanks,
> Alex
>=20
> > +
> >  int vfio_iommufd_bind(struct vfio_device *vdev, struct iommufd_ctx *ic=
tx)
> >  {
> >  	u32 ioas_id;
> > @@ -54,20 +72,8 @@ int vfio_iommufd_bind(struct vfio_device *vdev, stru=
ct
> iommufd_ctx *ictx)
> >
> >  	lockdep_assert_held(&vdev->dev_set->lock);
> >
> > -	if (vfio_device_is_noiommu(vdev)) {
> > -		if (!capable(CAP_SYS_RAWIO))
> > -			return -EPERM;
> > -
> > -		/*
> > -		 * Require no compat ioas to be assigned to proceed. The basic
> > -		 * statement is that the user cannot have done something that
> > -		 * implies they expected translation to exist
> > -		 */
> > -		if (!iommufd_vfio_compat_ioas_get_id(ictx, &ioas_id))
> > -			return -EPERM;
> > -
> > +	if (vfio_device_is_noiommu(vdev))
> >  		return vfio_iommufd_noiommu_bind(vdev, ictx, &device_id);
> > -	}
> >
> >  	ret =3D vdev->ops->bind_iommufd(vdev, ictx, &device_id);
> >  	if (ret)
> > diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> > index 785afc40ece8..8884b557fb26 100644
> > --- a/drivers/vfio/vfio.h
> > +++ b/drivers/vfio/vfio.h
> > @@ -234,9 +234,18 @@ static inline void vfio_container_cleanup(void)
> >  #endif
> >
> >  #if IS_ENABLED(CONFIG_IOMMUFD)
> > +int vfio_iommufd_compat_probe_noiommu(struct vfio_device *device,
> > +				      struct iommufd_ctx *ictx);
> >  int vfio_iommufd_bind(struct vfio_device *device, struct iommufd_ctx *=
ictx);
> >  void vfio_iommufd_unbind(struct vfio_device *device);
> >  #else
> > +static inline int
> > +vfio_iommufd_compat_probe_noiommu(struct vfio_device *device,
> > +				  struct iommufd_ctx *ictx)
> > +{
> > +	return -EOPNOTSUPP;
> > +}
> > +
> >  static inline int vfio_iommufd_bind(struct vfio_device *device,
> >  				    struct iommufd_ctx *ictx)
> >  {

