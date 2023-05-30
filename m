Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D413A715479
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 06:23:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbjE3EXV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 00:23:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbjE3EXT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 00:23:19 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 377A9E3;
        Mon, 29 May 2023 21:23:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685420597; x=1716956597;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KTPgaUhwLO8wQ65Q+ZSx6GhOQ6/1KOumpVp/VaK/86w=;
  b=iyExcE/RYV120Xpo7uUaPwAOaBPS6tcuh8zaqsghb5f3MnHe8CE+VsXL
   9yKlibAkIIHEKuXX5fFlG1QhgrIRhCOAUjUKzUQKu/1k25OOOn5qRdvAb
   amWu/CT88M0yHsyGOcZ7+D5rllakrC/fTWy8PCopZxxsrsbbXyarTHhZZ
   fsg1Dbte8ou0IdqIIr17ruIz1etewL1fnEy0Vdft+Z9OPaOLnBZJqjoPt
   MDiFCeJa+p9qJ9F8rq02+Oh4bPUb8Ebzteqas5u/WmpfL6qPHuEF88Khp
   eH+VPTtccSjeckoNUJkANu9vJ36DtvBH1/fJCt6LtcwOsWd0w+Axr019L
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10725"; a="354827507"
X-IronPort-AV: E=Sophos;i="6.00,203,1681196400"; 
   d="scan'208";a="354827507"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2023 21:23:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10725"; a="706264121"
X-IronPort-AV: E=Sophos;i="6.00,203,1681196400"; 
   d="scan'208";a="706264121"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga002.jf.intel.com with ESMTP; 29 May 2023 21:23:14 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 29 May 2023 21:23:16 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 29 May 2023 21:23:16 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.106)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 29 May 2023 21:23:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FxRTx6fIOgQy6YC9EtcthyoY9USqMTn45c0SxQrR2RY19lDehYjhLYW8/AzWvWPHclEXAeNz+yWIDvNcyIsreavED4r5D97eGqO6nsVnpvPBAQmxvAWqgpwnOrcQm5swyEbjQuOfDUGwVDjCF77PcViyDpBC98AU+q/trhArnDpKE8X2adyUUWUeaS7rzkJh/qzBgFHRmZqsN9hXxlWlmhDw09W570vXgaHfme+DJQjmNU09x28GJDK5pzo6lTtyAYyPVlZzFL3+/sxhBrEvnjQBi1vseR5X8Uj4vOOfdtmMY+yUk5aB7IKXvSsj95/O1V2tpdl2+QIRCG2Ck1P4Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=saHM3s6+sU/ZaeQlzRmDMVMgRONL9il4nHFVsVEhJoc=;
 b=HjX/gyl/b6KS5TjA8W3DWMzZBUvgfkl04E3OcEWAL5g+GE63PsbbuWLzP40XhvOv/uUE4efaODE/FUvsFOUNI2KRAnp1k4gMz2eQKs466oNi3jgF6oqL2ZtJTLQci8H2d1ZgxWlaT75trvmtL0mad4VNtcbsuC7Q9cihGFuszjeHvWom/YXaRWYFs+JY2vTBS6V99wcDBFqAXrG+uevxiB2j6p7XIdCzEUg4BuJKia9WjPcfO8NE01gCLuYNnSnLWazvYuoEjFOD3+ulfupHiYu3lL54iRDHU8v4bmaZ903W/H7lWr/fDXu9OBjMk16mt30T23q7DkaS8b03fVpx1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SA1PR11MB8253.namprd11.prod.outlook.com (2603:10b6:806:250::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.21; Tue, 30 May
 2023 04:23:14 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5%3]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 04:23:13 +0000
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
Subject: RE: [PATCH v6 10/10] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Topic: [PATCH v6 10/10] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Index: AQHZjKSt5YzaYa3rmk2neLlrrfQXoq9p4OwAgAhcP0A=
Date:   Tue, 30 May 2023 04:23:12 +0000
Message-ID: <DS0PR11MB75298C069D298D29D9B7B459C34B9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230522115751.326947-1-yi.l.liu@intel.com>
        <20230522115751.326947-11-yi.l.liu@intel.com>
 <20230524141956.3655fab5.alex.williamson@redhat.com>
In-Reply-To: <20230524141956.3655fab5.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|SA1PR11MB8253:EE_
x-ms-office365-filtering-correlation-id: 3b69a960-3df2-4b71-4aa4-08db60c59517
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9HM+Eaq7xqIYkmNzYIFFZ5ZhVy/PFAdBD3uR2TqChYueDTg54gXajlCkIiHLTPwCGvbGco+BFUzes+OJ0mwUMFJ5nrhng6an93Kh2mrXhF5EHw8QFPGZYWyltz7Cv0aSScZVTB3XwajaucAYVVrqBQoda4qekbqHcWtcoZoOKTgYfMrISKs8HPVTS1QKZzp0O1UjFBCf/8z3Ntl+opywgpx86H6CJuC8kQuCqT6YfVxnUVOcye7uSywhTxr/wVKcFOsDvuhAPtn4LfiqZovRDVKytAIbxQgIE4yqkfUR9jHig6GzYOceqyS96PJeJ08WKSwmONOUGIP8MpiTv04FmgK7LZU3dP2R6ZHVQPOQLl+deFH5DZJwkFR47E8COEpSG2sh716bwZfsaqWkkmNqD/nfdvdb3F+4tAsRQ5PrLO6DMHonqB51y5W69ggBYK76PAEVmCMRhQgF+r74AeS94xvGe8GP3GwH7Sfb7OGhb4iDsEjmCY6Yl+cls1xA5H2gDG30lWMul6Zy9ROFUvnyz786vbYWBvaE08PIJwzOY2mACh8EBR43d3hyk/eRkgHgZSosgL1vA5qv+VW0FfdjS1C8wG96yVq6mDU9atqI4UZobiau5xUwbvYHq+5bTuLrvEvq4RbFY8BSikfNyv3/oWTfytOPAVPOV/+HQrsznnU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(39860400002)(136003)(376002)(346002)(451199021)(38070700005)(6506007)(9686003)(186003)(2906002)(54906003)(478600001)(26005)(83380400001)(86362001)(45080400002)(7696005)(122000001)(41300700001)(8676002)(38100700002)(82960400001)(966005)(8936002)(55016003)(66946007)(64756008)(76116006)(5660300002)(66446008)(66556008)(66476007)(316002)(33656002)(71200400001)(52536014)(7416002)(6916009)(4326008)(13296009)(309714004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?KoUqgAuwTfAauTWJSx+INBE5ofxnJaEs89b73hFkRdSaw4cRRVXIiOrWRoth?=
 =?us-ascii?Q?aqS9MtnzQ8U/LzEbEcU2ieTovYdlVLS8mYmAPJRklLgHq5ztpEIrQHSxRPZZ?=
 =?us-ascii?Q?fcDKVVXwHeUbn15NSrPL0IRdCkMq78q7Es7t0rzDcsGWPl9elbJTOCdVCoYg?=
 =?us-ascii?Q?LHkb2jxvGIdBw9j9PC/YRlDf1HIALP09k6dM4RpWhbhcflDE2NKtHxsZDV02?=
 =?us-ascii?Q?fKHAtl5s4VE0uw2TAfqOxkPtWr3gsgenSyhhxerPK1NFJnoTn6iNWe0FHAbN?=
 =?us-ascii?Q?MVPpm+ne6iEHanfH8NOmn8KGRcBxz/K5gH1jLRmAITjXi8XUqORkTkXOue8i?=
 =?us-ascii?Q?fVYxu9stL/bkNv6bNV3cIe6K64sSEa0aj4iEgDUrDR/z5Ish2DTThc9I+xbe?=
 =?us-ascii?Q?PVLUf2dq6btat9SK8EbAdsxb3eWHS+IvuJalsWEUPZ66PyUjkLhQVws10QWd?=
 =?us-ascii?Q?7zbwhAuGDs2coPDVx4y5osvEHWN4/P4d6/hhbbFLv8BekjN3dEgso9CJdjVM?=
 =?us-ascii?Q?1o2g+i8H1vZLOY5gFisfGxrcI8BIKoJx4OmN+yhFuVvER8kRpNQWE9QBTcTQ?=
 =?us-ascii?Q?zUHlfgE8G7PfdG/DtkF+YP27oRtQIBvh6LCCApv4b9OgeyBof3COhFLi2ezj?=
 =?us-ascii?Q?fTz6EHy5Q1MaGFEF8FVSMAYiaMHSrcIpYxg4CezKP4l8P2BEgRwV/6BQmbIv?=
 =?us-ascii?Q?V6BffxviTizUjjHw9ImVFkEeQOGPdsBctfbq2KElDmM79TllojqK1xJC45H8?=
 =?us-ascii?Q?f8aIYDtdSEa9HDne91L/EU65EAHO1bO4xnsRv9dKRcMcSilzKoC8jqAWd3Yi?=
 =?us-ascii?Q?42/X9dGFwscsZTKzLAhIG3EoaBLo1hrZDVLCl/qR3ImuMsy+rSI1cqd6x8R9?=
 =?us-ascii?Q?1tiYPBUs18ey4DKEUlBNxhmo0r6zITF6jr1pQ95tPfi/QxbhX9pvQfpoI+5Q?=
 =?us-ascii?Q?3bm0WRK5Ie+OKwOJB55+f/5Cxy4Xu3nY5CuyrM7jGKudz5EqL52TG6GKBDIh?=
 =?us-ascii?Q?kb1QsNAjQAaDOH8w+Ak2KWPW3H+76J7M4i0Uheq9JPRX5P3/GW7UYaL03Uv6?=
 =?us-ascii?Q?DO2va+rbrIbFKh8yBOeGAqmlZQTfwXSI3OEiQzC1CLtar56dq0tbwJLe69qo?=
 =?us-ascii?Q?EKLv16r3HVmdXl2fQfRIGJBaUulvs1HHbEZtBZJV9OOGongXxs4vOtRLYCLP?=
 =?us-ascii?Q?Hh5xfXd6+HGP5KKO4YpKEaHs0R/Dlk8tWSgl8WcqXKC9cvlT84lMx3u/Yvkv?=
 =?us-ascii?Q?oLex+h6sshBsfpqwiTW0eKqmDfGwiotkNoyc5oPVlFo1uc86vOX2oT8xJsPe?=
 =?us-ascii?Q?Y2i6ixpVMURi3GB6GfDBfdn4Sp6s0T2F8iVtt09mEyesRb9Z6Fkki3UbxhBP?=
 =?us-ascii?Q?eX2VAlyvlK+vGKodxMKtLvJonN6POo6oAzTzq3vywZ5GOsh1yLoaMr0YB1vH?=
 =?us-ascii?Q?28gsnjnVd9BCLFyqAB7coqvKHSSaHVAmvUVUzKbax1njMPcWtcZMXeQqL99S?=
 =?us-ascii?Q?Ym16VS0Wn6K3sj7J0x37DLC3MtEmknNRPgF76FwN83b91PRw6efsoYuM9LVu?=
 =?us-ascii?Q?wkAzolbWfWvCTuOZdwGDo10zA3Y0mUh7aduMWRKI?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b69a960-3df2-4b71-4aa4-08db60c59517
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2023 04:23:12.9204
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kV/xwuGPq3KlfRvjQMLGtvnulXb3qc13SlcVDE2eB8Q9yvzQyosIFBrfJXTo0P9p1ojgqweiDCmsnmaBV0j0FA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8253
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Thursday, May 25, 2023 4:20 AM
>=20
> On Mon, 22 May 2023 04:57:51 -0700
> Yi Liu <yi.l.liu@intel.com> wrote:
>=20
> > This is the way user to invoke hot-reset for the devices opened by cdev
> > interface. User should check the flag VFIO_PCI_HOT_RESET_FLAG_DEV_ID_OW=
NED
> > in the output of VFIO_DEVICE_GET_PCI_HOT_RESET_INFO ioctl before doing
> > hot-reset for cdev devices.
> >
> > Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> > Tested-by: Yanting Jiang <yanting.jiang@intel.com>
> > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > ---
> >  drivers/vfio/pci/vfio_pci_core.c | 56 +++++++++++++++++++++++++-------
> >  include/uapi/linux/vfio.h        | 14 ++++++++
> >  2 files changed, 59 insertions(+), 11 deletions(-)
> >
> > diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_p=
ci_core.c
> > index 890065f846e4..67f1cb426505 100644
> > --- a/drivers/vfio/pci/vfio_pci_core.c
> > +++ b/drivers/vfio/pci/vfio_pci_core.c
> > @@ -181,7 +181,8 @@ static void vfio_pci_probe_mmaps(struct vfio_pci_co=
re_device
> *vdev)
> >  struct vfio_pci_group_info;
> >  static void vfio_pci_dev_set_try_reset(struct vfio_device_set *dev_set=
);
> >  static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
> > -				      struct vfio_pci_group_info *groups);
> > +				      struct vfio_pci_group_info *groups,
> > +				      struct iommufd_ctx *iommufd_ctx);
> >
> >  /*
> >   * INTx masking requires the ability to disable INTx signaling via PCI=
_COMMAND
> > @@ -1301,8 +1302,7 @@ vfio_pci_ioctl_pci_hot_reset_groups(struct
> vfio_pci_core_device *vdev,
> >  	if (ret)
> >  		return ret;
> >
> > -	/* Somewhere between 1 and count is OK */
> > -	if (!array_count || array_count > count)
> > +	if (array_count > count || vfio_device_cdev_opened(&vdev->vdev))
> >  		return -EINVAL;
> >
> >  	group_fds =3D kcalloc(array_count, sizeof(*group_fds), GFP_KERNEL);
> > @@ -1351,7 +1351,7 @@ vfio_pci_ioctl_pci_hot_reset_groups(struct
> vfio_pci_core_device *vdev,
> >  	info.count =3D array_count;
> >  	info.files =3D files;
> >
> > -	ret =3D vfio_pci_dev_set_hot_reset(vdev->vdev.dev_set, &info);
> > +	ret =3D vfio_pci_dev_set_hot_reset(vdev->vdev.dev_set, &info, NULL);
> >
> >  hot_reset_release:
> >  	for (file_idx--; file_idx >=3D 0; file_idx--)
> > @@ -1380,7 +1380,11 @@ static int vfio_pci_ioctl_pci_hot_reset(struct
> vfio_pci_core_device *vdev,
> >  	else if (pci_probe_reset_bus(vdev->pdev->bus))
> >  		return -ENODEV;
> >
> > -	return vfio_pci_ioctl_pci_hot_reset_groups(vdev, hdr.count, slot, arg=
);
> > +	if (hdr.count)
> > +		return vfio_pci_ioctl_pci_hot_reset_groups(vdev, hdr.count, slot, ar=
g);
> > +
> > +	return vfio_pci_dev_set_hot_reset(vdev->vdev.dev_set, NULL,
> > +					  vfio_iommufd_device_ictx(&vdev->vdev));
> >  }
> >
> >  static int vfio_pci_ioctl_ioeventfd(struct vfio_pci_core_device *vdev,
> > @@ -2347,13 +2351,16 @@ const struct pci_error_handlers
> vfio_pci_core_err_handlers =3D {
> >  };
> >  EXPORT_SYMBOL_GPL(vfio_pci_core_err_handlers);
> >
> > -static bool vfio_dev_in_groups(struct vfio_pci_core_device *vdev,
> > +static bool vfio_dev_in_groups(struct vfio_device *vdev,
> >  			       struct vfio_pci_group_info *groups)
> >  {
> >  	unsigned int i;
> >
> > +	if (!groups)
> > +		return false;
> > +
> >  	for (i =3D 0; i < groups->count; i++)
> > -		if (vfio_file_has_dev(groups->files[i], &vdev->vdev))
> > +		if (vfio_file_has_dev(groups->files[i], vdev))
> >  			return true;
> >  	return false;
> >  }
> > @@ -2429,7 +2436,8 @@ static int vfio_pci_dev_set_pm_runtime_get(struct
> vfio_device_set *dev_set)
> >   * get each memory_lock.
> >   */
> >  static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
> > -				      struct vfio_pci_group_info *groups)
> > +				      struct vfio_pci_group_info *groups,
> > +				      struct iommufd_ctx *iommufd_ctx)
> >  {
> >  	struct vfio_pci_core_device *cur_mem;
> >  	struct vfio_pci_core_device *cur_vma;
> > @@ -2459,11 +2467,37 @@ static int vfio_pci_dev_set_hot_reset(struct
> vfio_device_set *dev_set,
> >  		goto err_unlock;
> >
> >  	list_for_each_entry(cur_vma, &dev_set->device_list, vdev.dev_set_list=
) {
> > +		bool owned;
> > +
> >  		/*
> > -		 * Test whether all the affected devices are contained by the
> > -		 * set of groups provided by the user.
> > +		 * Test whether all the affected devices can be reset by the
> > +		 * user.
> > +		 *
> > +		 * If the user provides a set of groups, all the devices
> > +		 * in the dev_set should be contained by the set of groups
> > +		 * provided by the user.
>=20
> "If called from a group opened device and the user provides a set of
> groups,..."
>=20
> > +		 *
> > +		 * If the user provides a zero-length group fd array, then
>=20
> "If called from a cdev opened device and the user provides a
> zero-length array,..."
>=20
>=20
> > +		 * all the devices in the dev_set must be bound to the same
> > +		 * iommufd_ctx as the input iommufd_ctx.  If there is any
> > +		 * device that has not been bound to iommufd_ctx yet, check
> > +		 * if its iommu_group has any device bound to the input
> > +		 * iommufd_ctx Such devices can be considered owned by
>=20
> "."...........................^

Thanks, above comments well received.

> > +		 * the input iommufd_ctx as the device cannot be owned
> > +		 * by another iommufd_ctx when its iommu_group is owned.
> > +		 *
> > +		 * Otherwise, reset is not allowed.
>=20
>=20
> In the case where a non-null array is provided,
> vfio_pci_ioctl_pci_hot_reset_groups() explicitly tests
> vfio_device_cdev_opened(), so we exclude cdev devices from providing a
> group list.=20

Yes.

> However, what prevents a compat opened group device from
> providing a null array?

I think I've asked this question before. What I got is seems no need
to prevent it[1].

[1] https://lore.kernel.org/kvm/BN9PR11MB5276ABE919C04E06A0326E8E8CBC9@BN9P=
R11MB5276.namprd11.prod.outlook.com/

Now, I intend to disallow it. If compat mode user binds the devices
to different containers, it shall be able to do hot reset as it can use
group fd to prove ownership. But if using the zero-length array, it
would be failed. So we may add below logic and remove the
vfio_device_cdev_opened() in vfio_pci_ioctl_pci_hot_reset_groups().

vfio_pci_ioctl_pci_hot_reset()
{
...
	if (!!hdr.count =3D=3D !!vfio_device_cdev_opened(&vdev->vdev))
		return -EINVAL;
	if (hdr.count)
		vfio_pci_ioctl_pci_hot_reset_groups(vdev, hdr.count, slot, arg);
	return vfio_pci_dev_set_hot_reset(vdev->vdev.dev_set, NULL,
					     vfio_iommufd_device_ictx(&vdev->vdev));
}

>=20
> I thought it would be that this function is called with groups =3D=3D NUL=
L
> and therefore the vfio_dev_in_groups() test below fails, but I don't
> think that's true for a compat opened device.  Thanks,

How about above logic?

Regards,
Yi Liu

>=20
> >  		 */
> > -		if (!vfio_dev_in_groups(cur_vma, groups)) {
> > +		if (iommufd_ctx) {
> > +			int devid =3D vfio_iommufd_device_hot_reset_devid(&cur_vma-
> >vdev,
> > +									iommufd_ctx);
> > +
> > +			owned =3D (devid !=3D VFIO_PCI_DEVID_NOT_OWNED);
> > +		} else {
> > +			owned =3D vfio_dev_in_groups(&cur_vma->vdev, groups);
> > +		}
> > +
> > +		if (!owned) {
> >  			ret =3D -EINVAL;
> >  			goto err_undo;
> >  		}
> > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > index 01203215251a..24858b650562 100644
> > --- a/include/uapi/linux/vfio.h
> > +++ b/include/uapi/linux/vfio.h
> > @@ -686,6 +686,9 @@ enum {
> >   *	  Flag VFIO_PCI_HOT_RESET_FLAG_DEV_ID_OWNED would be set when all t=
he
> >   *	  affected devices are owned by the user.  This flag is available o=
nly
> >   *	  when VFIO_PCI_HOT_RESET_FLAG_DEV_ID is set, otherwise reserved.
> > + *	  When set, user could invoke VFIO_DEVICE_PCI_HOT_RESET with a zero
> > + *	  length fd array on the calling device as the ownership is validat=
ed
> > + *	  by iommufd_ctx.
> >   *
> >   * Return: 0 on success, -errno on failure:
> >   *	-enospc =3D insufficient buffer, -enodev =3D unsupported for device=
.
> > @@ -717,6 +720,17 @@ struct vfio_pci_hot_reset_info {
> >   * VFIO_DEVICE_PCI_HOT_RESET - _IOW(VFIO_TYPE, VFIO_BASE + 13,
> >   *				    struct vfio_pci_hot_reset)
> >   *
> > + * Userspace requests hot reset for the devices it operates.  Due to t=
he
> > + * underlying topology, multiple devices can be affected in the reset
> > + * while some might be opened by another user.  To avoid interference
> > + * the calling user must ensure all affected devices are owned by itse=
lf.
> > + *
> > + * As the ownership described by VFIO_DEVICE_GET_PCI_HOT_RESET_INFO, t=
he
> > + * cdev opened devices must exclusively provide a zero-length fd array=
 and
> > + * the group opened devices must exclusively use an array of group fds=
 for
> > + * proof of ownership.  Mixed access to devices between cdev and legac=
y
> > + * groups are not supported by this interface.
> > + *
> >   * Return: 0 on success, -errno on failure.
> >   */
> >  struct vfio_pci_hot_reset {

