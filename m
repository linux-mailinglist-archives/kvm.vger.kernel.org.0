Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0627F72E5CA
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 16:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242923AbjFMOdI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 10:33:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242557AbjFMOdG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 10:33:06 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4E8210DF;
        Tue, 13 Jun 2023 07:33:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686666784; x=1718202784;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ASN6mNnO97EGSBoRyU08BJWEB45H30rz+1GkTlJSxUs=;
  b=MmMmsFG6PpeXAPc8fFOWNZap6mJQJWIEfdVZisUTYwFqUZd/LEYINRFr
   KYMENwq+0m2QJRRIumxuQnV6y4WjG7hSvk2MjaETFFh5xVlI+IGAI+4z6
   G9X1eynKzmNoRrVBRVeIaCbYGNlE6ZasaSEbk/TgZJvkue97DQ8EDWl+D
   IFTaIhVXCBe4UXmUH4OZf3nMWfoaOVfyRzFUuyFOoC6lEdN1ThXeiNh8N
   MuhVJRN/+++GjNZNzko8D00/XvVuNlvN685UeyX2A1MoMZb4rDeN8hj37
   Rjg5rOqKafajvA6Y998/pSTcgaXza36DdWcWbLapRTNzB5Q3/Dn6uNXtK
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="348004354"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="348004354"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 07:33:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="744712907"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="744712907"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga001.jf.intel.com with ESMTP; 13 Jun 2023 07:33:03 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 13 Jun 2023 07:33:03 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 13 Jun 2023 07:33:03 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 13 Jun 2023 07:33:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=StlHxixXEp7/65NCvcmISxPMoZ1pg8f8thHDUd3N18gXVx97D/skkLbWWcvKvAMJyDo3NvBDugFLE5Hc6RFGT6v+XlThnbNCnr+idc0uwGj//hcq56Y1Ys1sLRBbsAZiFCCLhbum2nFlMl01D18kj+DYkXGFoMVj6NlksqdlR96WmFqdvGLLv7Wi1PuzbDxHpJ11q6VDw0ETDPP/ZUWtzPqb1aAFMtcHyu4rPeLHZbCCZbjwfchSBwdbLtyExXK/HWjwF6pS/kS3MYNi89SCS+Ju7g+pLMdESLoMRzEUa8jLSs+AFYrtoFjQ+TtDdT+PU7Q0G7k6O1JZnKyTj98k1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PfYPQPxXdR6E1GkEZL79AB4ZK5kwYVGxeSglMK6Befo=;
 b=YLh1AcGNkTm/+M55JTJt35/uslMV2zQnvEbEMJVoXKOCY9bPQsLv68XFyk7JDSNdkjqNFIUXdXyBtkg6EgmboWptDhrAj+yKKL2rmKXsVmKXnOoMGGgmmSzUKHypkclkrbhk0e/NdGZ0D9KHelQA/QoP8ObD/IUnPsqlY77Ikiqenf84TuB31FQBIYbMZ9L/XBaF/T9rTSd5VhbRZgbcsxyubxeacZfi3Cyiv9lz3S/09+L/E/xcDm9UxS3NVgy64tApGUKDfWkUSNzANujUXAh6WpclnLCohpubnbhJpvtP9yjLaMjJLoARS6u9S1KfmGAMVKAHt44s4nShcpey0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SA2PR11MB5001.namprd11.prod.outlook.com (2603:10b6:806:118::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.44; Tue, 13 Jun
 2023 14:33:01 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5%3]) with mapi id 15.20.6455.045; Tue, 13 Jun 2023
 14:33:01 +0000
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
Subject: RE: [PATCH v12 21/24] vfio: Determine noiommu device in
 __vfio_register_dev()
Thread-Topic: [PATCH v12 21/24] vfio: Determine noiommu device in
 __vfio_register_dev()
Thread-Index: AQHZlUw5Bdx6t/Ptjk+i/O1PZ4IdNK+H07wAgAB3NRCAAI6EgIAAArTA
Date:   Tue, 13 Jun 2023 14:33:01 +0000
Message-ID: <DS0PR11MB7529EB2903151B3399F636F5C355A@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230602121653.80017-1-yi.l.liu@intel.com>
        <20230602121653.80017-22-yi.l.liu@intel.com>
        <20230612164228.65b500e0.alex.williamson@redhat.com>
        <DS0PR11MB7529AE3701E154BF4C092E57C355A@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230613081913.279dea9e.alex.williamson@redhat.com>
In-Reply-To: <20230613081913.279dea9e.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|SA2PR11MB5001:EE_
x-ms-office365-filtering-correlation-id: b6409e45-2610-4a25-95a0-08db6c1b1759
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QBWaqNtQu4ZL+yWzCPpcHhg2jffzh3oIO4eDvwfvISVax40Cgl2hsQ8EwkawYMX6CMQLCROOnIpTqbucSHsh9YLLizfeNBLctkXq3zg0kq9mYydD47+FOjA/yfB8PO0kEQ2E7oVtTPzsigVcrW4vhmJGjN200G1hz67Vfx+/JJh9WfsRoLxvLsfZ2eCeSreiVZDPoAHWhRjqGdn6yyfR2Rs1Ox5eOWK1U+2JD5O231R/CTaaSoaXOtGupngBeFurZ5GEi2QGNwESkty+n87r4es77E8Lm7N0wORhGaWUTus7spHpt0+zWEiSyHuyq8RhUXR72Wv2T50bVfcXQn23vByBR9qEKwxGrkPGarX8b4iSXVkV4cTTCtx0AQ6g/DKS9+17d0sPUP7FeASqac3faK1tnqZfZkvFBwTXS33HBdn35yXE5rAOUpzNMt4RSOLAidnyBGMVdkri7q8NbdqqLG5EwSGsiU65s7cpjl41HSk47oA3oNrY4S1UsuYYkUBsFzoPOJsbj5mt4o1kegtbt7LEZune1Y0yKfBV6Xc2spR//B2iRZIizYtLwpUDQFF1g7C4YGt0DxwW/9sz82VgRbZopo9l8l1YcBs4BdlRHY/Ep1lOWJR06+lCmZemwZ+4
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(366004)(376002)(39860400002)(396003)(451199021)(66476007)(66556008)(66446008)(64756008)(66946007)(316002)(76116006)(71200400001)(54906003)(6916009)(478600001)(4326008)(38070700005)(86362001)(33656002)(9686003)(6506007)(26005)(83380400001)(186003)(5660300002)(41300700001)(8936002)(8676002)(7416002)(52536014)(2906002)(7696005)(55016003)(82960400001)(38100700002)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?kI3pkimxRYG0/HRA1KKYGkRu8pC7/0+N94SoNIjbM4Em3Gr6YuqZnhX7+0GM?=
 =?us-ascii?Q?DOIAZs81aWpZukogzqrnfXHKzD8AFa54IgQkaoI6KQMPwkvtq4ITuxw0xAnm?=
 =?us-ascii?Q?VoimT6tDVAIgwwdhjfSQQE1w6sRWu6DhlN4NsIKBc8U3tdFwGBEA6+Xcwa+r?=
 =?us-ascii?Q?pfdmX7u/sK73nD4LsK8l8ylMSzWQWBG++R+3lW2ecBAuYZwfUxBmdHqKU0jz?=
 =?us-ascii?Q?z5WYRRPXsnk7aIHFE+5fw8zAqUgs4eQOUJF9RpozcHDPyzJoCgOCRQQngk+/?=
 =?us-ascii?Q?WGRh8mZi5U3/rcbwB4LWRW7v++/6wUDp8f0R5kTsDugLQ0N2APjAgUzPk8Yv?=
 =?us-ascii?Q?5MZGw6MHXztnkpcBuvXIFw4sxoGsVJpqkPD72FQ/8QKyBQQZ3pIxVUZWjjYr?=
 =?us-ascii?Q?9uXq6d0t9QbdkllQXb6fweAkHV7noOHQ59Em+UFNDXph9erZa2Aket1WdpqE?=
 =?us-ascii?Q?FQytrNSMRpWMbImDELKLf8n7zNVzwslz8eDzhMSwjR06jnE6zGKF+NE1R1vM?=
 =?us-ascii?Q?ZPA5xalVyzhPZN2VU/Rm4YHMAGCtpRmrmA6iiYvSd50m/qRKPPcdupN/xV7M?=
 =?us-ascii?Q?eaLkbMAk37GmI3M3RLyjiL0V9Vj6Igxne32pyZd8Q4xe9mpVQPa5UXAVbBLx?=
 =?us-ascii?Q?NCkihzr49yQZMRr+ZZSFyJTwL3ZFZsfd+FyRYN9n2XKSmxZPQtAsa2Hvp6lD?=
 =?us-ascii?Q?8IvCJdyRImWB+dA7ZkBCbNTSoc3MXAsM1BgtbhUbPjoySiqCx8ZwRSidgz+m?=
 =?us-ascii?Q?XwlHnZcawF7ozUawCHcpnOeX/5WszhWCCL79tx7Ms/VzySLw88ahTnTAsxnv?=
 =?us-ascii?Q?aSbrw1TCVVXcl0u7TrMJyGgfn1+qhmm0jLoE3WIw5Tr4/R+jk2CAlcgHVYkF?=
 =?us-ascii?Q?ypJQZZXXmu2nJNmKtXC6dT9AHxqdLWxi6dBvP5qKSoQ2qXqT6QoSXg9lYTzn?=
 =?us-ascii?Q?FsUMJNMZfgIajpPhgjhVYu4iKb088CPkKfdMH2OvBKDKuoFLCSUvSbtvshEE?=
 =?us-ascii?Q?S+0f84RFy4rbd/vuSLPNkWY9QCF+IC2NOvbezSvhrKWHiIYuia0eN2xak9dR?=
 =?us-ascii?Q?D9bglm6Z1b6hELRFKbCWMbWH7hN+8Wwd49LZ924SgHLXgntcOXgP11br8IWM?=
 =?us-ascii?Q?ipsjE9di1nWT3VabFYDjVVbB/gd97S5TP3CFiofE9RSNTup5Z7/llegOHakl?=
 =?us-ascii?Q?yQ9CoirCUuFDjHJDidKq51FKNGRcHJdjGQCy80XoMqgDYC5PcJb/1DmbBiI0?=
 =?us-ascii?Q?YPleESNlsVojCbTcdw/Bnu9sQfhvyrgiA+a4fYHyzL5QxkiajN8r+wMTAdzc?=
 =?us-ascii?Q?YMVRGlV1Me2psv2yBskVgUpCwj6WCR2uMlvOvx8jY095E91S5LE4dqcncIiE?=
 =?us-ascii?Q?RtEQZSf3ZHBs9gOXQK2wlzyO12+ocw1EaDDGOnyO2NUFjAXE4pr1HGpJHf1Q?=
 =?us-ascii?Q?0kzlgqrmbxy5aan1a+3Xtj4A7LixOkzYd2596NcJ1/uyjnv0IXe14eFv9zRL?=
 =?us-ascii?Q?1XxnHlTEkDBgT65pM+Twgm2qO+Hg1tIFWPmE1UUJLA5WDAQm2HaqxivDEC+p?=
 =?us-ascii?Q?QpfQMYhyIB2WvPvvDzdvYHuVIWTcc6CIlQAujwyq?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6409e45-2610-4a25-95a0-08db6c1b1759
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2023 14:33:01.4582
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RLDQoXvRm1qxfCR9a6hjMQN1mxRizumAaUshfVIam5rxP60XcoMDqTwEzZpS0RKm3Oo/N3RnGYqkcPbKQwR2zg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5001
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Tuesday, June 13, 2023 10:19 PM
>=20
> On Tue, 13 Jun 2023 05:53:42 +0000
> "Liu, Yi L" <yi.l.liu@intel.com> wrote:
>=20
> > > From: Alex Williamson <alex.williamson@redhat.com>
> > > Sent: Tuesday, June 13, 2023 6:42 AM
> > >
> > > On Fri,  2 Jun 2023 05:16:50 -0700
> > > Yi Liu <yi.l.liu@intel.com> wrote:
> > >
> > > > This moves the noiommu device determination and noiommu taint out o=
f
> > > > vfio_group_find_or_alloc(). noiommu device is determined in
> > > > __vfio_register_dev() and result is stored in flag vfio_device->noi=
ommu,
> > > > the noiommu taint is added in the end of __vfio_register_dev().
> > > >
> > > > This is also a preparation for compiling out vfio_group infrastruct=
ure
> > > > as it makes the noiommu detection and taint common between the cdev=
 path
> > > > and group path though cdev path does not support noiommu.
> > >
> > > Does this really still make sense?  The motivation for the change is
> > > really not clear without cdev support for noiommu.  Thanks,
> >
> > I think it still makes sense. When CONFIG_VFIO_GROUP=3D=3Dn, the kernel
> > only supports cdev interface. If there is noiommu device, vfio should
> > fail the registration. So, the noiommu determination is still needed. B=
ut
> > I'd admit the taint might still be in the group code.
>=20
> How is there going to be a noiommu device when VFIO_GROUP is unset?

How about booting a kernel with iommu disabled, then all the devices
are not protected by iommu. I suppose they are noiommu devices. If
user wants to bound them to vfio, the kernel should have VFIO_GROUP.
Otherwise, needs to fail.

Regards,
Yi Liu

> Thanks,
>=20
> Alex
>=20
>=20
> > > > Suggested-by: Alex Williamson <alex.williamson@redhat.com>
> > > > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > > > ---
> > > >  drivers/vfio/group.c     | 15 ---------------
> > > >  drivers/vfio/vfio_main.c | 31 ++++++++++++++++++++++++++++++-
> > > >  include/linux/vfio.h     |  1 +
> > > >  3 files changed, 31 insertions(+), 16 deletions(-)
> > > >
> > > > diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
> > > > index 653b62f93474..64cdd0ea8825 100644
> > > > --- a/drivers/vfio/group.c
> > > > +++ b/drivers/vfio/group.c
> > > > @@ -668,21 +668,6 @@ static struct vfio_group *vfio_group_find_or_a=
lloc(struct
> > > device *dev)
> > > >  	struct vfio_group *group;
> > > >
> > > >  	iommu_group =3D iommu_group_get(dev);
> > > > -	if (!iommu_group && vfio_noiommu) {
> > > > -		/*
> > > > -		 * With noiommu enabled, create an IOMMU group for devices that
> > > > -		 * don't already have one, implying no IOMMU hardware/driver
> > > > -		 * exists.  Taint the kernel because we're about to give a DMA
> > > > -		 * capable device to a user without IOMMU protection.
> > > > -		 */
> > > > -		group =3D vfio_noiommu_group_alloc(dev, VFIO_NO_IOMMU);
> > > > -		if (!IS_ERR(group)) {
> > > > -			add_taint(TAINT_USER, LOCKDEP_STILL_OK);
> > > > -			dev_warn(dev, "Adding kernel taint for vfio-noiommu group on
> > > device\n");
> > > > -		}
> > > > -		return group;
> > > > -	}
> > > > -
> > > >  	if (!iommu_group)
> > > >  		return ERR_PTR(-EINVAL);
> > > >
> > > > diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> > > > index 6d8f9b0f3637..00a699b9f76b 100644
> > > > --- a/drivers/vfio/vfio_main.c
> > > > +++ b/drivers/vfio/vfio_main.c
> > > > @@ -265,6 +265,18 @@ static int vfio_init_device(struct vfio_device=
 *device,
> struct
> > > device *dev,
> > > >  	return ret;
> > > >  }
> > > >
> > > > +static int vfio_device_set_noiommu(struct vfio_device *device)
> > > > +{
> > > > +	struct iommu_group *iommu_group =3D iommu_group_get(device->dev);
> > > > +
> > > > +	if (!iommu_group && !vfio_noiommu)
> > > > +		return -EINVAL;
> > > > +
> > > > +	device->noiommu =3D !iommu_group;
> > > > +	iommu_group_put(iommu_group); /* Accepts NULL */
> > > > +	return 0;
> > > > +}
> > > > +
> > > >  static int __vfio_register_dev(struct vfio_device *device,
> > > >  			       enum vfio_group_type type)
> > > >  {
> > > > @@ -277,6 +289,13 @@ static int __vfio_register_dev(struct vfio_dev=
ice *device,
> > > >  		     !device->ops->detach_ioas)))
> > > >  		return -EINVAL;
> > > >
> > > > +	/* Only physical devices can be noiommu device */
> > > > +	if (type =3D=3D VFIO_IOMMU) {
> > > > +		ret =3D vfio_device_set_noiommu(device);
> > > > +		if (ret)
> > > > +			return ret;
> > > > +	}
> > > > +
> > > >  	/*
> > > >  	 * If the driver doesn't specify a set then the device is added t=
o a
> > > >  	 * singleton set just for itself.
> > > > @@ -288,7 +307,8 @@ static int __vfio_register_dev(struct vfio_devi=
ce *device,
> > > >  	if (ret)
> > > >  		return ret;
> > > >
> > > > -	ret =3D vfio_device_set_group(device, type);
> > > > +	ret =3D vfio_device_set_group(device,
> > > > +				    device->noiommu ? VFIO_NO_IOMMU : type);
> > > >  	if (ret)
> > > >  		return ret;
> > > >
> > > > @@ -301,6 +321,15 @@ static int __vfio_register_dev(struct vfio_dev=
ice *device,
> > > >
> > > >  	vfio_device_group_register(device);
> > > >
> > > > +	if (device->noiommu) {
> > > > +		/*
> > > > +		 * noiommu deivces have no IOMMU hardware/driver.  Taint the
> > > > +		 * kernel because we're about to give a DMA capable device to
> > > > +		 * a user without IOMMU protection.
> > > > +		 */
> > > > +		add_taint(TAINT_USER, LOCKDEP_STILL_OK);
> > > > +		dev_warn(device->dev, "Adding kernel taint for vfio-noiommu on
> > > device\n");
> > > > +	}
> > > >  	return 0;
> > > >  err_out:
> > > >  	vfio_device_remove_group(device);
> > > > diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> > > > index e80a8ac86e46..183e620009e7 100644
> > > > --- a/include/linux/vfio.h
> > > > +++ b/include/linux/vfio.h
> > > > @@ -67,6 +67,7 @@ struct vfio_device {
> > > >  	bool iommufd_attached;
> > > >  #endif
> > > >  	bool cdev_opened:1;
> > > > +	bool noiommu:1;
> > > >  };
> > > >
> > > >  /**
> >

