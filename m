Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 135086D75EA
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 09:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236950AbjDEHzS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 03:55:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbjDEHzR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 03:55:17 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 078EA30CD;
        Wed,  5 Apr 2023 00:55:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680681315; x=1712217315;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8ct9gJrqhuigbzq80x6Kj6kG1zd/7h6XOLve9fhLWw8=;
  b=I+FZlLKjIMz/ovqMngYdE3EE50V8M3Ne9wgc4ihvHyHa3LgdNN24Zu3a
   +d8idxTnDczMgIgIA9yN4+0pfkTJMlounEFvjKtFqFY3ZHxseOe2sWBAe
   CG/nmA3Isq5fdhVaO8yZwI4tE1eVlY+cTSAME3GbnpHzXJFhMaqBEg7MA
   6c3drK48RQKK3XsKQ3+EN2v3slGBI1lfe8SuxKZXQzr0fXpUcqo2cOP8d
   nAVT/Bd6LebdpJembkJpYL5f+NKc0Ckch0CkCxrSROV2UyJ9xklTJj05D
   R9d3khkhsOnDVAC9t5poH3BDzL+5cmN4zlghcL0GBXThvGi9k/0+H/H4d
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="330994432"
X-IronPort-AV: E=Sophos;i="5.98,319,1673942400"; 
   d="scan'208";a="330994432"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2023 00:55:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="751188450"
X-IronPort-AV: E=Sophos;i="5.98,319,1673942400"; 
   d="scan'208";a="751188450"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga008.fm.intel.com with ESMTP; 05 Apr 2023 00:55:13 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 5 Apr 2023 00:55:13 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 5 Apr 2023 00:55:13 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.103)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 5 Apr 2023 00:55:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HEK4ernLCAYO2Po8Lx8hj3ttGsT0cIk0jU95T2ZzMYyYeulAlCb1NoqkUSdm/Tih8HcSQpcdRxyS5hIiQVd4qQhThPU5r0lSAghMaPV88bQESxGplE28E5HDHlPytdbuSYJAQvFQiz9UEPWa1RsYA/9cH/WxU7OQtsVKpT+BOUaN3LlxB1QJ4CxJauOOATIJQB0b65CyEiGSxJ/hbDGO1fUeGrqO3fBLsf+VyeYaQBmVhwjORSRDJUxOHgJ9Ws5fD7TQ5FyAq+8PiK/JcO7U3E7M63x7n9EoBMPnZZDXT+D+ludiyWvOvgegv2CiphXwPICP8xQzRlCq1/2mgc4MLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M3e1kSK7kKCjzmg6mJzxokfYvwc5uicM8ffQn+RriZc=;
 b=Ex4uLs1E+Scx9OBpV4w5xy+ez3TxG2IDaBvlsIxl/dxVItajzcf+RZYJ/8vxCcx+RY4WL8OkzjTAlkBW4mJltbwF4ZikvGKEedO0TLeB/zFZ3yuIZ1n7Bhc9DM/gN5csIx/O/TAFbh5I5UBpFk0D0XnBVHQo3jj97ABF1xlVXrXXDfAhbZIGRl3xL76dbWSGybqG0ihh8c+c4JQEedzGMk4zU+shyoUlDGL9Fo7YPF5YtqhSZY9uwhBlQ0ZMpFluX6e4OcAvSRm2hikZGBGXXw8RjnHaqYmuYgTGAUH31f4ynU80+FriDOez0yPU/r+5fF84Wk9YfFB8pijVv/Ttuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CH3PR11MB8343.namprd11.prod.outlook.com (2603:10b6:610:180::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Wed, 5 Apr
 2023 07:55:10 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de%5]) with mapi id 15.20.6254.035; Wed, 5 Apr 2023
 07:55:10 +0000
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
        "Jiang, Yanting" <yanting.jiang@intel.com>
Subject: RE: [PATCH v3 05/12] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Topic: [PATCH v3 05/12] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Index: AQHZZKh/F8Y4f47WR0u72nj77BeY3q8bm/YAgAC8rsA=
Date:   Wed, 5 Apr 2023 07:55:10 +0000
Message-ID: <DS0PR11MB752919BC81CCCAB1A13998CAC3909@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230401144429.88673-1-yi.l.liu@intel.com>
        <20230401144429.88673-6-yi.l.liu@intel.com>
 <20230404141838.6a4efdd4.alex.williamson@redhat.com>
In-Reply-To: <20230404141838.6a4efdd4.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|CH3PR11MB8343:EE_
x-ms-office365-filtering-correlation-id: 9df9e1bd-1893-4504-6985-08db35ab14a3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pz+b9QPfabdXWG8w4vKxgjdojd/OUbBEF9SmMehzQantGbDCPR0JEIacWf24Q41D3KB4iPGRV8xnscQVvD8VKDVBel6YgY9LGPyeXFkJZ0IjGwyR0nv3seeot9/eKUhSWTbwgnNUzYaYnkMiHigUmS/WqBLtK7ReesGiA3SiE4yTO53YTanc9osb100TdfcS1mXwz84qd/mDOyoQU9YaRn/iNZnFozG/I4Kb3NfdqRV6cFAX6R6Y05MbIaJXGeiN3ygTt4NyemHelo32fu0GcUBo3KyvOhQ0iJD8gWJEi7zT/keNowHsAEfc99IHeQrud4V57AYiw1sq30g99ak1D1IfaV+zVv5cIoruGR0Et0zGV2wxeWYgT/RA+jvIjCqGXlhWIG0DCjsrxOJ0jhNlSfGgo6TEq2xSOHknzQUOjj0mhLFBzyitTLczyr2WvDkrGNps+3gbde7Fl6d+tdLjjJeY04gVp+iqDf0AOejuPI+Cq1gv/DLJRsVgy6Jz19uFJn+/0HZR+Vzd1nihceIoEA6fST9WPTstDu3nwu2Jex6bDDZwQG+cF++akm9Ps0s2U/MRP04wqQVYFAbm3r6X3/w0iX8V0vpv+SfxflWqnTnkEH1Kodj6uNNjkCEj9+T/bCYHvbrW4RpVPKZvOYoC/Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(136003)(396003)(366004)(346002)(451199021)(83380400001)(26005)(71200400001)(7696005)(186003)(478600001)(316002)(54906003)(9686003)(2906002)(6506007)(5660300002)(52536014)(7416002)(122000001)(33656002)(8676002)(38100700002)(8936002)(66946007)(64756008)(66556008)(66476007)(76116006)(66446008)(4326008)(86362001)(41300700001)(6916009)(82960400001)(55016003)(38070700005)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?zYj1bU0RRxPc4H8g7Jx7b+C650mPgwZSMw3vLkV5XOxnbgp8pvAkNq/GfZNk?=
 =?us-ascii?Q?Vk/B2XrtTlgXl8Vp6GY+oo37zGOz4ifATtHm4fRfbPE9iLv5NYuZJUnX99+u?=
 =?us-ascii?Q?tzti+jeM58HKSqg2upO8+RSyyHTNdnY4vfCIgwZLPQgCJP0Xrrt4I76suYld?=
 =?us-ascii?Q?QQa+vSR+5Xg2z3cr4obGGK1JX8/+cNS1DkHgfMoATVPHbDYY+eWKqDm9mA3i?=
 =?us-ascii?Q?6zWmCVb+qWhTSnm/NcycUZ09hZNfl08dmHKflS4XMOxdm+YJ9+J9VdR2RFPj?=
 =?us-ascii?Q?WKDrzEExNton9GOkpkKKoldnAlMb5yoYUq5EdTV+ISRpaY7EjxZx9woXYfpc?=
 =?us-ascii?Q?Hlgxr9bxSh1PZF+H6vODLMZkfIIntiFMisu97w5u6YM782qyZumHdTKTgrS9?=
 =?us-ascii?Q?cK9VG7WctF8Aw5c64YCXItByMCvYjy1O2hoj6SddOkWkOIWe3TVmVj9YsR1g?=
 =?us-ascii?Q?oWGC97CESI/MBgzbNh/PMpN1cJ83obQ6vI2GhZEPzpctgXxqlarBZF0AZvRY?=
 =?us-ascii?Q?2VotPlxxSExVvPGS0ZndhidaC/od7zdH2wMjNbBnSjTnxisMIfA8T0PRRfT+?=
 =?us-ascii?Q?LuMvBy2UMa61JUnN3YzbVU2MoKf3b1leiisEADlRZvdvsAIjtHsuRXqbwqIU?=
 =?us-ascii?Q?J60K2PbMBEeVl8gHmGA4MVT9pK997bCBiU1cAE07tu3sdmNbxTnp9DQBz4Dj?=
 =?us-ascii?Q?wYzbedI25md0d55eEEcUKY0qph1keSCucNwS/RT65QTFTo7Ka6i3DlJ/Vl5y?=
 =?us-ascii?Q?lEeCtXlZUDPiXVqNe8LmKt2i5Y3nDdGS15YocmhZTk5Xy3f8aZGnxY1k/Tff?=
 =?us-ascii?Q?nEDn6P5+6HdfMgajqvcVAyu9o1+IHpJxMYgpWKCzRdUKu6uy1Wf+4lNcavvi?=
 =?us-ascii?Q?YNS23KwsUdUSeLMh/RG2O34u0v5urgJMJNeCPvJ+PO5LmS3+PCB+KGzCs4gH?=
 =?us-ascii?Q?kcwoGzmq+hjiaqJN9HHBpf85ePYXQLhWSs1mK/yjP0+mrAaxUI9ulfN3A61n?=
 =?us-ascii?Q?gWk0yJMDT7kktnFU1EwXe40jYYY8tlgY2h+PEf2yg0pzZhjClR4g/o6vxm6K?=
 =?us-ascii?Q?FzA9pcBwlpqJiTpLZmepNVPPg5C8xwnhvxxmbD1CCmeTUXPid0F502iQODZz?=
 =?us-ascii?Q?IbQnPXp3LI4N0/3tQGkbupXpZUTlcoQaFtQhgpcuLW7scksVLUwXUekdOxVH?=
 =?us-ascii?Q?IWNfFymxNDLCCWKCP784Q+3kysmM8Nna04FYHCGQ2yRIVaOWZoUXLaWXSHjI?=
 =?us-ascii?Q?aYd3llt1rb7ZXyNzEqZ3M1HtY9gZixD9cJV1CqQSgkb9EBbzPJ/QgcxXP39w?=
 =?us-ascii?Q?OHrCSnLDq+rNd7kastRq0uQQ+LHIl1X4jLmyL2LDXxjQhM/j5A1uTrGV1Umw?=
 =?us-ascii?Q?xpHQglgqxeqVlgJCK1iQlqh6zMJKpp5E9PVoD28ocHtqlH4/eCLT3SQhhn/k?=
 =?us-ascii?Q?RE8fCb3l/g/XpnrHKEB4p652hO2o18Gb/2n6OUgWfqQfUFkGipoCi98e85vj?=
 =?us-ascii?Q?r+I79DGydLd6DE/APAzUqlwTscp+VeaJNSD6FdJSKyvxn33b73ns4u7P2MxD?=
 =?us-ascii?Q?a8HLJbjLTJNgraqILzQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9df9e1bd-1893-4504-6985-08db35ab14a3
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2023 07:55:10.4911
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CgN5tDdaIeFRkGRjvMkn+672cXwCiESGEfn2fBjGjBmi3ke3RVUdiRaX7I3a7ULeDX9RbO6geP+SjlP/MpV/cA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8343
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Wednesday, April 5, 2023 4:19 AM
>=20
> On Sat,  1 Apr 2023 07:44:22 -0700
> Yi Liu <yi.l.liu@intel.com> wrote:
>=20
> > as an alternative method for ownership check when iommufd is used. In
> > this case all opened devices in the affected dev_set are verified to
> > be bound to a same valid iommufd value to allow reset. It's simpler
> > and faster as user does not need to pass a set of fds and kernel no
> > need to search the device within the given fds.
> >
> > a device in noiommu mode doesn't have a valid iommufd, so this method
> > should not be used in a dev_set which contains multiple devices and one
> > of them is in noiommu. The only allowed noiommu scenario is that the
> > calling device is noiommu and it's in a singleton dev_set.
> >
> > Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> > Tested-by: Yanting Jiang <yanting.jiang@intel.com>
> > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > ---
> >  drivers/vfio/pci/vfio_pci_core.c | 42 +++++++++++++++++++++++++++-----
> >  include/uapi/linux/vfio.h        |  9 ++++++-
> >  2 files changed, 44 insertions(+), 7 deletions(-)
> >
> > diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_p=
ci_core.c
> > index 3696b8e58445..b68fcba67a4b 100644
> > --- a/drivers/vfio/pci/vfio_pci_core.c
> > +++ b/drivers/vfio/pci/vfio_pci_core.c
> > @@ -180,7 +180,8 @@ static void vfio_pci_probe_mmaps(struct
> vfio_pci_core_device *vdev)
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
> > @@ -1277,7 +1278,7 @@ vfio_pci_ioctl_pci_hot_reset_groups(struct
> vfio_pci_core_device *vdev,
> >  		return ret;
> >
> >  	/* Somewhere between 1 and count is OK */
> > -	if (!hdr->count || hdr->count > count)
> > +	if (hdr->count > count)
> >  		return -EINVAL;
> >
> >  	group_fds =3D kcalloc(hdr->count, sizeof(*group_fds), GFP_KERNEL);
> > @@ -1326,7 +1327,7 @@ vfio_pci_ioctl_pci_hot_reset_groups(struct
> vfio_pci_core_device *vdev,
> >  	info.count =3D hdr->count;
> >  	info.files =3D files;
> >
> > -	ret =3D vfio_pci_dev_set_hot_reset(vdev->vdev.dev_set, &info);
> > +	ret =3D vfio_pci_dev_set_hot_reset(vdev->vdev.dev_set, &info, NULL);
> >
> >  hot_reset_release:
> >  	for (file_idx--; file_idx >=3D 0; file_idx--)
> > @@ -1341,6 +1342,7 @@ static int vfio_pci_ioctl_pci_hot_reset(struct
> vfio_pci_core_device *vdev,
> >  {
> >  	unsigned long minsz =3D offsetofend(struct vfio_pci_hot_reset, count)=
;
> >  	struct vfio_pci_hot_reset hdr;
> > +	struct iommufd_ctx *iommufd;
> >  	bool slot =3D false;
> >
> >  	if (copy_from_user(&hdr, arg, minsz))
> > @@ -1355,7 +1357,12 @@ static int vfio_pci_ioctl_pci_hot_reset(struct
> vfio_pci_core_device *vdev,
> >  	else if (pci_probe_reset_bus(vdev->pdev->bus))
> >  		return -ENODEV;
> >
> > -	return vfio_pci_ioctl_pci_hot_reset_groups(vdev, &hdr, slot, arg);
> > +	if (hdr.count)
> > +		return vfio_pci_ioctl_pci_hot_reset_groups(vdev, &hdr, slot, arg);
> > +
> > +	iommufd =3D vfio_iommufd_physical_ictx(&vdev->vdev);
> > +
> > +	return vfio_pci_dev_set_hot_reset(vdev->vdev.dev_set, NULL, iommufd);
> >  }
> >
> >  static int vfio_pci_ioctl_ioeventfd(struct vfio_pci_core_device *vdev,
> > @@ -2327,6 +2334,9 @@ static bool vfio_dev_in_groups(struct
> vfio_pci_core_device *vdev,
> >  {
> >  	unsigned int i;
> >
> > +	if (!groups)
> > +		return false;
> > +
> >  	for (i =3D 0; i < groups->count; i++)
> >  		if (vfio_file_has_dev(groups->files[i], &vdev->vdev))
> >  			return true;
> > @@ -2402,13 +2412,25 @@ static int vfio_pci_dev_set_pm_runtime_get(stru=
ct
> vfio_device_set *dev_set)
> >  	return ret;
> >  }
> >
> > +static bool vfio_dev_in_iommufd_ctx(struct vfio_pci_core_device *vdev,
> > +				    struct iommufd_ctx *iommufd_ctx)
> > +{
> > +	struct iommufd_ctx *iommufd =3D vfio_iommufd_physical_ictx(&vdev->vde=
v);
> > +
> > +	if (!iommufd)
> > +		return false;
> > +
> > +	return iommufd =3D=3D iommufd_ctx;
> > +}
> > +
> >  /*
> >   * We need to get memory_lock for each device, but devices can share m=
map_lock,
> >   * therefore we need to zap and hold the vma_lock for each device, and=
 only then
> >   * get each memory_lock.
> >   */
> >  static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
> > -				      struct vfio_pci_group_info *groups)
> > +				      struct vfio_pci_group_info *groups,
> > +				      struct iommufd_ctx *iommufd_ctx)
> >  {
> >  	struct vfio_pci_core_device *cur_mem;
> >  	struct vfio_pci_core_device *cur_vma;
> > @@ -2448,9 +2470,17 @@ static int vfio_pci_dev_set_hot_reset(struct
> vfio_device_set *dev_set,
> >  		 *
> >  		 * Otherwise all opened devices in the dev_set must be
> >  		 * contained by the set of groups provided by the user.
> > +		 *
> > +		 * If user provides a zero-length array, then all the
> > +		 * opened devices must be bound to a same iommufd_ctx.
> > +		 *
> > +		 * If all above checks are failed, reset is allowed only if
> > +		 * the calling device is in a singleton dev_set.
> >  		 */
> >  		if (cur_vma->vdev.open_count &&
> > -		    !vfio_dev_in_groups(cur_vma, groups)) {
> > +		    !vfio_dev_in_groups(cur_vma, groups) &&
> > +		    !vfio_dev_in_iommufd_ctx(cur_vma, iommufd_ctx) &&
> > +		    (dev_set->device_count > 1)) {
>=20
> This last condition looks buggy to me, we need all conditions to be
> true to generate an error here, which means that for a singleton
> dev_set, it doesn't matter what group fds are passed, if any, or whether
> the iommufd context matches.  I think in fact this means that the empty
> array path is equally available for group use cases with a singleton
> dev_set, but we don't enable it for multiple device dev_sets like we do
> iommufd.

you are right. The last condition allows the empty-fd array path to
work for the group use case if the dev_set happens to be a singleton.

>=20
> You pointed out a previous issue with hot-reset info and no-iommu where
> if other affected devices are not bound to vfio-pci the info ioctl
> returns error.  That's handled in the hot-reset ioctl by the fact that
> all affected devices must be in the dev_set and therefore bound to
> vfio-pci drivers.=20

yes, hot-reset ioctl requires all affected devices listed in the dev_set.
So for the case there are devices not bound to vfio yet, hot-reset ioctl
just fails. If all affected devices are in the dev_set, they will have a
fake group allocated by vfio. So the info ioctl won't fail.

> So it seems to me that aside from the spurious error
> because we can't report an iommu group when none exists, and didn't
> spot it to invent an invalid group for debugging, hot-reset otherwise
> works with no-iommu just like it does for iommu backed devices.  We
> don't currently require singleton no-iommu dev_sets afaict.

yes. the requirement for hot-reset is the same between no-iommu and
the iommufd backed devices.

> I'll also note that if the dev_set is singleton, this suggests that
> pci_reset_function() can make use of bus reset, so a hot-reset is
> accessible via VFIO_DEVICE_RESET if the appropriate reset method is
> selected.

yes. so does it mean not necessary to allow singleton dev_set support
in hot-reset ioctl? If user uses hot-reset, it should because of unable to
use VFIO_DEVICE_RESET, is it?

>=20
> Therefore, I think as written, the singleton dev_set hot-reset is
> enabled for iommufd and (unintentionally?) for the group path, while
> also negating a requirement for a group fd or that a provided group fd
> actually matches the device in this latter case.  The null-array
> approach is not however extended to groups for more general use.
> Additionally, limiting no-iommu hot-reset to singleton dev_sets
> provides only a marginal functional difference vs VFIO_DEVICE_RESET.

I think the singletion dev_set hot-reset is for iommufd (or more accurately
for the noiommu case in cdev path).=20

> Thanks,
>=20
> Alex
>=20
> >  			ret =3D -EINVAL;
> >  			goto err_undo;
> >  		}
> > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > index f96e5689cffc..17aa5d09db41 100644
> > --- a/include/uapi/linux/vfio.h
> > +++ b/include/uapi/linux/vfio.h
> > @@ -679,7 +679,14 @@ struct vfio_pci_hot_reset_info {
> >   * the calling user must ensure all affected devices, if opened, are
> >   * owned by itself.
> >   *
> > - * The ownership is proved by an array of group fds.
> > + * The ownership can be proved by:
> > + *   - An array of group fds
> > + *   - A zero-length array
> > + *
> > + * In the last case all affected devices which are opened by this user
> > + * must have been bound to a same iommufd. If the calling device is in
> > + * noiommu mode (no valid iommufd) then it can be reset only if the re=
set
> > + * doesn't affect other devices.
> >   *
> >   * Return: 0 on success, -errno on failure.
> >   */

