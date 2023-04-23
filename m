Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7B46EC081
	for <lists+kvm@lfdr.de>; Sun, 23 Apr 2023 16:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbjDWOrh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 Apr 2023 10:47:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbjDWOrf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 23 Apr 2023 10:47:35 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAC9B1700;
        Sun, 23 Apr 2023 07:47:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682261227; x=1713797227;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RQadk50meRbd/EBWcwOPGe+p4oM6SLHr+5eWDVI8CPg=;
  b=eX5vl/2TODx4LQPPgAfMywYqnDnS1OFQN2UZ6oGKK3i8uAbtJz3Fo9J/
   BhY+B0tGaLQYw7d8fx/1+MxN7PO+Yx4/9cfG/T5xd50mrZA1phqCERK49
   H+qPmt84p5qB4jwAwL2gURjlePymtfrORN90DQjBgy8VghqNklEAy2xGB
   eXDkrSinrHoDhudAG9ZmaZsS8zPzsKt+1fIAp/qnGgveHhH82CQQYBlYC
   dOzJNGOTYf3Rnw+Dy02wrWqWRb06/9JZTSgfMmmUYV+t5r/WXTYEi3JwX
   wCSrT30bvIgdlO9Z52blr6t2JX9+1OTLjLdj7VWoqWw9WfV409Kegdrjy
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10689"; a="432564177"
X-IronPort-AV: E=Sophos;i="5.99,220,1677571200"; 
   d="scan'208";a="432564177"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2023 07:47:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10689"; a="670245079"
X-IronPort-AV: E=Sophos;i="5.99,220,1677571200"; 
   d="scan'208";a="670245079"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP; 23 Apr 2023 07:47:01 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 23 Apr 2023 07:47:00 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Sun, 23 Apr 2023 07:47:00 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.44) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sun, 23 Apr 2023 07:47:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LnZJ3EHkW2+rJusYcPOPoHwoA3J0bDtlXd5L/s3YPQWyXZf8hBrWzcolUSEjx/9EhJ7N7kDtdx58W9fEP5i/qzrLmrS1XxrLqTICY7eEjY5cUo8TWzCCtgX9F7qwcUODR9sLzEapPnt5/JTrYZZfB8gTnFW8h9lCjQBhmjFaoRrH4x8XfjbSo4D8/xloHG88IDUQeJI6so2o58Ky9f8CTBycq+mqaj128RuzrCXpsK0F+ntACF242QZNOGPlZ0ZdlGr7OWzvRBvtA0Z+CCzeH9DaUzSygUuYd1SKEDKimVSp/jmk27tf7BgNMtqM/c7A3NkXfpN1Bsu+bwZEgNuJJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xgFMldwJ4ayleQMgd/cK+WaH0rGUsmzrNacXVYKKt3Q=;
 b=INyA0Rt0DbzS28zsc3lK9Rn0glZXTHWXK+Zh7YNkEFg7Fom0Hfw8pJuZXU86waf5mba9ZYKjaZRetUi5dG6noZR1d9vcnm4iOKNZuvAI8krrft+VOkxu0eoARyT8Dzbq+UnwFKjYgTuqac9VpBnvGHP9SJIvtXf3qoqCE2gmKi9QtB8uSeHrJ419+a6U+DxH67mp5CFQuHF8D3TYDuUOEHtmHwPHv9FMm1J/kuU4AUxCNUntKBn7VJ12dfg6BJ8+i89S4AJ6F9lvOYJaaNb8VnclOucz644G6UkqzmWY5D7niZvVps8TW2ZAG0telCyie2n/3pyOguR5vzZn9L2PMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CH0PR11MB5380.namprd11.prod.outlook.com (2603:10b6:610:bb::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Sun, 23 Apr
 2023 14:46:58 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5%5]) with mapi id 15.20.6319.022; Sun, 23 Apr 2023
 14:46:58 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
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
Subject: RE: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Thread-Topic: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Thread-Index: AQHZZKiCMJJkpNrujkKpjX0h05Zqwa8cqG8AgAAcMGCAACibgIAAAyuAgAAEPICAAAjLgIAAGeKAgAAG7oCAAAf9gIAAO30AgACaIeCAAJxQgIAHkI0AgAApuICAABWEgIAAGNKAgAA3aoCAACJEAIABGhiAgAA2uYCAAM6MAIAAOT6AgABpLgCAAPyoAIAAA7kQgACCLICAA9TGQIABATgAgAAIdQCAAAm2AIABGm0AgABffwCAArUGYIAAJAOAgAIgCgCAAp6CAA==
Date:   Sun, 23 Apr 2023 14:46:57 +0000
Message-ID: <DS0PR11MB752986E59E3F13F0E48F8411C3669@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <DS0PR11MB7529B7481AC97261E12AA116C3999@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230414111043.40c15dde.alex.williamson@redhat.com>
 <DS0PR11MB75290A78D6879EC2E31E21AEC39C9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230417130140.1b68082e.alex.williamson@redhat.com>
 <ZD2erN3nKbnyqei9@nvidia.com>
 <20230417140642.650fc165.alex.williamson@redhat.com>
 <ZD6TvA+9oI0v4vC2@nvidia.com>
 <20230418123920.5d92f402.alex.williamson@redhat.com>
 <DS0PR11MB7529C11E11F187D7BD88C18AC3639@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230420080839.652732dc.alex.williamson@redhat.com>
 <ZEMPxoT+fSBh23Nj@nvidia.com>
In-Reply-To: <ZEMPxoT+fSBh23Nj@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|CH0PR11MB5380:EE_
x-ms-office365-filtering-correlation-id: dfade371-7cdc-491d-9c0f-08db4409969e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sv/uqumYRB1K4mG3RCtqaKwB0SGaCzq9sMICStbYrMPDyeyDPsgX7mJu/oRY7K+Rs7IZkZ7thE6/ZoD7AJKwrY7tacJpYuzrnK5e7Og/pQIef2X43+m0+hFUt3QW/eO7vRVdlDVbbomc66dXYq+c02tmrVMQq/t5oQgb5NHMtTUAjjBBgsgm6Qx+aKWvFlEJVXiPeBeUpXNXU9xO30N2qHb2bsQn78IXKWddPy/jSyjfDxVrggsy6krCbhdEzSCjG0afrw2943mvfv9TunfVEcjv7YKakS5QNHTHzBwtCYeVUq7Pn4usyxMbTr8hu91QI50mac2/kOjMIgQ/FwtSEnRz/VnMlF20mkd+sgnn3gwLyLkHJbNG5rSDTiNyNyoDc2fg4g1YO0lIFic4c0pDkP3Tewxk18A/gBer4rlyg1FoEcTxrVOZTqhzJ1Kre5rn7KErMNedtzv9GHvBlU675rVTo4l2PVisdclNaeT6HeOKFsBCqnZ4nq71nSlL+upLU7F/e/wcKTVZB0Xp9tWkA4OIiwSClc3750x6GdXw/n3hwhIfT53nmMTyQoaqPd543jYD49WD0U8YlJO4q1eY0o2+Se14wSApi4ZxuR8Gd45ta/BDrdZ8sWCoKd65iYfec4xMS2gR63rmOR21OQeSgw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(346002)(136003)(376002)(396003)(451199021)(6506007)(9686003)(110136005)(86362001)(186003)(7696005)(71200400001)(55016003)(26005)(54906003)(478600001)(33656002)(38100700002)(8676002)(8936002)(41300700001)(122000001)(38070700005)(2906002)(83380400001)(7416002)(5660300002)(52536014)(66476007)(316002)(66446008)(66556008)(64756008)(82960400001)(4326008)(76116006)(66946007)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?WKDGsyB2pQYUe14D3GZlUJhdIzI8g87SRnre5A4c4Uuz1LEBWDCekeM6UmsM?=
 =?us-ascii?Q?rTbG50WwnNkzOGWjV99gToh/F2ACo64mMmsylWa6kjvuvLLQsh97ATT96icf?=
 =?us-ascii?Q?G9gRrnClmhxTS3Fodmgz4q7WRf4w697ZvLRDn+xETqZo1k/KUnLKofwm30T4?=
 =?us-ascii?Q?uLeWpurocZ2KG8ulMacCQo5U9A4IphNX+6T39H3oAeoGMo8T7qkYaPoC8RGj?=
 =?us-ascii?Q?q2xMBdgMUOtNfgU62gk3cKvxfrnsCPaNVwqz1RPPFZGt3TYS7cTsx+3Y9ezX?=
 =?us-ascii?Q?nyXS6c6w2Wz5+E/pgUi+sRTebePCi/dHNLRStcsBP+YnEYj9epWrxL4+R8k4?=
 =?us-ascii?Q?sggiHTVpjVvJhzrNDRsf9lKzXd0SawnwFNgBy7FLS9CMtFIixTsPLISbx/5b?=
 =?us-ascii?Q?cYMB8+f5InnLXfUoq+X6qxIQHGhD0q20r+Rl0RYncUHoCn6H1L+52NPOD0YT?=
 =?us-ascii?Q?7GTOQHcBDwUKFyNNsKAKuRg+gK6rJ00NTq+YP/MngsqJZjsoyhN8VdrqWyAm?=
 =?us-ascii?Q?qck2t2HbVpVNZbdg9tTlvJMQ+VQQxLA0dLJkgWk5nPFahHlYos/HDRe+XP/j?=
 =?us-ascii?Q?hSo3lpBfEciu7UQJ/04P/t+7+Y7HkWv6sbOP+TEazqfLwVlKxVvlnntwkMss?=
 =?us-ascii?Q?zIdDltBYLRmQJtOmh6E36UHlt9AV6QOrMGNh7trjEd9wGO9unphbyFQ4CsGN?=
 =?us-ascii?Q?fv+Erz7U0YWuGPl6FrEYjiAkqORwaU021L3XCVmR2QotlrsfsxRZX+rC5UwD?=
 =?us-ascii?Q?xoGZUGi6Ac/2MroMd8DpYjVvn6NKUH3tay/lNWQ6uMzb5mjIoT/XU1BAU6AD?=
 =?us-ascii?Q?fm6+WtEfU9oydTdSlIzTfdELZYZh9X+9c+68Z477RboaxBNIxgWVaQyPHydH?=
 =?us-ascii?Q?AogXEb9F8FAHhAvCKolnhxbBNzFOfCbJa2UxuXedMkhLg+bkjsg4bspLwFMI?=
 =?us-ascii?Q?TXACxPJA38Z7Kr/63WECzxDrMKFaTXiOXK/q25FDn7rQ8DP3snwTxa68EnDv?=
 =?us-ascii?Q?0NB3dqOit0FU8XjHFUnMct52ykU6IpVYilqT9BuaF8H2dwvTKNA6VS7nf2Qw?=
 =?us-ascii?Q?/J4bM2tmQotWu4qbxsFaPaobagQirC3o3kLEAK9oebNMgWWMYIJKAao4Xi4I?=
 =?us-ascii?Q?CqotOshz004AJAf0LfocMqlZbWUBjv9xYyFHWtmB3FWnLsgRdgsWGFvk48es?=
 =?us-ascii?Q?YQF1NdbI/5WNr8mQICCOIlc+xFGYelNA7l1OjOreTwkZe151MKaarXjgIK1f?=
 =?us-ascii?Q?7tBWav7Ge6NBgwGYF8OyNnj+PxPXF971+WMTimB6VML7I0hMZIHcSY9SIT3W?=
 =?us-ascii?Q?lt5RAiHfcNJKoJkSOAROtJVLxQshe9ImzrtRvgWPbrXpscsR9GLfN0x5oLU8?=
 =?us-ascii?Q?f6i9GSuYxfGjpC/EkgyjmgYPQC/BmeKrXpFoL8nAUnCd2LYI/UIbRTENwuVD?=
 =?us-ascii?Q?T2vo/FCUWtAuy2dBoiE/JSt1hM7Oa5+3/mtO9wBA5Rmqw06mzOUNoqt496gF?=
 =?us-ascii?Q?IFEwuVhxzlb+O0JiOhobQlG6rMyn7XkvRVYQylxS/bSHdULKfqUSYqfQxxYw?=
 =?us-ascii?Q?jqQEz1ciEALz4tEgA1Y=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfade371-7cdc-491d-9c0f-08db4409969e
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Apr 2023 14:46:57.5407
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ynXZZ39LaxTTA8Fe4p8zoX2b+zDxfpIXD2JM6IUAsrJRARHCtLeJ1jX/PyeGvpTlyx/e+hH9haFmbchumCodiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5380
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Saturday, April 22, 2023 6:36 AM
>=20
> On Thu, Apr 20, 2023 at 08:08:39AM -0600, Alex Williamson wrote:
>=20
> > > Hide this device in the list looks fine to me. But the calling user s=
hould
> > > not do any new device open before finishing hot-reset. Otherwise, use=
r may
> > > miss a device that needs to do pre/post reset. I think this requireme=
nt is
> > > acceptable. Is it?
> >
> > I think Kevin and Jason are leaning towards reporting the entire
> > dev-set.  The INFO ioctl has always been a point-in-time reading, no
> > guarantees are made if the host or user configuration is changed.
> > Nothing changes in that respect.
>=20
> Yeah, I think your point about qemu community formus suggest we should
> err toward having qemu provide some fully detailed debug report.
>=20
> > > > Whereas dev-id < 0
> > > > (=3D=3D -1) is an affected device which prevents hot-reset, ex. an =
un-owned
> > > > device, device configured within a different iommufd_ctx, or device
> > > > opened outside of the vfio cdev API."  Is that about right?  Thanks=
,
> > >
> > > Do you mean to have separate err-code for the three possibilities? As
> > > the devid is generated by iommufd and it is u32. I'm not sure if we c=
an
> > > have such err-code definition without reserving some ids in iommufd.
> >
> > Yes, if we're going to report the full dev-set, I think we need at
> > least two unique error codes or else the user has no way to determine
> > the subset of invalid dev-ids which block the reset.
>=20
> If you think this is important to report we should report 0 and -1,
> and adjust the iommufd xarray allocator to reserve -1

Then the alloc range should be from 1 to 0xffffffff.
=20
>=20
> It depends what you want to show for the debugging.
>=20
> eg if we have debugging where qemu dumps this table:
>=20
>    BDF   In VM   iommu_group   Has VFIO driver   Has Kernel Driver
>=20
> By also doing various sysfs probes based on the BDF, then the admin
> action to remedy the situation is:
>=20
> Make "Has VFIO driver =3D y" or "Has Kernel Driver =3D n" for every row i=
n
> the table to make the reset work.
>=20
> And we don't need the distinction. Adding the 0/-1 lets you make a
> useful table without doing any sysfs work.
>
> > I think Jason is proposing the set of valid dev-ids are >0, a dev-id
> > of zero indicates some form of non-blocking, while <0 (or maybe
> > specifically -1) indicates a blocking device.
>=20
> Yes, 0 and -1 would be fine with those definitions. The only use of
> the data is to add a 'blocking use of reset' colum to the table
> above..

Should -1 and 0 be defined in uapi as well? If yes, this seems not easy
to get a proper naming for them. Or just document it in vfio
uapi header to say -1 (blocking) and 0 (no-devid-but-not-blocking)
blabla.

Regards,
Yi Liu
