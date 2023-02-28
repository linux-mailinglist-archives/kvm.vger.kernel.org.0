Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF40A6A5DCF
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 17:58:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjB1Q6f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 11:58:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjB1Q6d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 11:58:33 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37B891421E;
        Tue, 28 Feb 2023 08:58:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677603494; x=1709139494;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=n7XhSkVKOl+rghhvtM8rM+PbDFEH4mrJ/BW4Jh7VyH4=;
  b=giLBnOmpvrBFaiyna5XxzoaL/kZId0l/JQrWa+aFtdxK3aPvawaNKuvv
   WHIajBwvODYKf5FR8D0zlD77H6BqhOZNkAzoX7yCNPQ7EBn/ihqXD1aYt
   ZZ5Youkv9MR6Y8R892IaHdHB/MHscDlr76YUAcCO3vkT1IfK3nAITWI+b
   +bsKoPmzyp6IV5Sq3ySBd6FwmP1dePAvZG5vrP2ZypNBKw3gASqLQYZWP
   zNizuu6vzS5oXsQ6JFzWLMibM7NSX68CvMIZnYCBCgIve+3/RV1dxuhNg
   uH5gQ3LcorEodxIUc217uj9Xm/wkXMtWkMik1rmKeugrfo4c9KAJlqH1u
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10635"; a="317989315"
X-IronPort-AV: E=Sophos;i="5.98,222,1673942400"; 
   d="scan'208";a="317989315"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2023 08:58:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10635"; a="624108894"
X-IronPort-AV: E=Sophos;i="5.98,222,1673942400"; 
   d="scan'208";a="624108894"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga003.jf.intel.com with ESMTP; 28 Feb 2023 08:58:10 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 28 Feb 2023 08:58:09 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 28 Feb 2023 08:58:09 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 28 Feb 2023 08:58:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G79BN9o9gikoG2G6sQYN8FciAe+z12x2TRYXlR3ZNj8RK4y/XwiSsXVmY495RQ8vLpmZHrUTeh+1pm1R6Nfz8+sfygxIAVuEqKZopB0w6hXmtbN+nHpDaYN0CKeu6/Ey8lX/LBuM6cip5aAFYBGGNCF63JK9UWL5vOYynyulOQiRe+p72lJ9JhQituKdum8EYUJL6/TXUFwanozxTkPupL6j41dPTvJil0GaztVfUF2APstsfTaQ6HnTWiQ2rlIy3SuRg8j/DGasRLwYHKypHM/SDnTvC7AZISlNajwywbjJBfTSWY7p6H6CvwLVWQXz25h3YRNRiHjpaabv84XLnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n7XhSkVKOl+rghhvtM8rM+PbDFEH4mrJ/BW4Jh7VyH4=;
 b=jc3FnWtyR38AhMx/UrNkLoSK2hMG75T2uq1BbfYvfxQI5QIP9WgRvN04ojS4Pc+oSKgl8Zu8tgBHuLTvxjoLFZybIlU+YXPKnCtuj74cx79ZWMFkqKXegnQYuNHxY7Jq2X+BvzFX/GdRogkmUigf90QkV1bP5/cOl8ZwiE0Re1OAGy2MpBQtwpyMBjysntRGcE5IRUF4CoFc2QVuZdfcFpDGmMh9KPPOk1sFkL5lg7Z5CewcEr6EXh6a710q5xFZ4rGRdFzl+gWICOmgq0J9YKVn/NcgxLL5v1wh2lhyqNTLLOEVZThqQEs9GHy2dytwflaOydjiwVmxDZdRU82p9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB5873.namprd11.prod.outlook.com (2603:10b6:806:228::11)
 by PH0PR11MB7660.namprd11.prod.outlook.com (2603:10b6:510:26f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.30; Tue, 28 Feb
 2023 16:58:06 +0000
Received: from SA1PR11MB5873.namprd11.prod.outlook.com
 ([fe80::cbfc:be3d:db03:30ab]) by SA1PR11MB5873.namprd11.prod.outlook.com
 ([fe80::cbfc:be3d:db03:30ab%5]) with mapi id 15.20.6134.026; Tue, 28 Feb 2023
 16:58:06 +0000
From:   "Xu, Terrence" <terrence.xu@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>, Jason Gunthorpe <jgg@nvidia.com>
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
        "Zhao, Yan Y" <yan.y.zhao@intel.com>
Subject: RE: [PATCH v5 00/19] Add vfio_device cdev for iommufd support
Thread-Topic: [PATCH v5 00/19] Add vfio_device cdev for iommufd support
Thread-Index: AQHZSpxJm675zsJ9I02sNNK/lebui67jLB2AgACBDoCAAOVfoA==
Date:   Tue, 28 Feb 2023 16:58:06 +0000
Message-ID: <SA1PR11MB5873479F73CFBAA170717624F0AC9@SA1PR11MB5873.namprd11.prod.outlook.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <Y/0Cr/tcNCzzIAhi@nvidia.com>
 <DS0PR11MB7529A422D4361B39CCA3D248C3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
In-Reply-To: <DS0PR11MB7529A422D4361B39CCA3D248C3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB5873:EE_|PH0PR11MB7660:EE_
x-ms-office365-filtering-correlation-id: 3d6a3b51-b92c-41bd-f62f-08db19acf650
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: shtdtv0nb27QAjoFiKs57/gIKi3IegrHAu5+SuULz176Oi9Iv61xvV50xT3DujsJ2n0muq/4FJ4F+zp23gFqtqZwD1e3dw8tomsLY+nSENSs044u1piocfgA8E76jX5/YNG4IV6eHw2uIl18SFVoWYeM9vc1NhznSphy+l9xJt4Sd3DXxNI3bADlBIqmZX47m5z4gnVWSDmzglIkMQBB9AF92E7X09n5pUzpuU4g32tAbV2NmfTkmzxk3MWHRpuIFwCka82PRLKCiOpAVM4y0KyCbMM64WyK7nLv1595wNrbWaRJbWwrpCx6h9YQsrGUBAeztahdxxTfQIyjLZnCE2reU94Z7xeKqzyhvgM0kvnbyHtPaXl2dCoJ9C0gpzx/BCWj+dGqXt3Zd4y7XjiExiX1AGC8nKjhdl07CHOMUO0Wz65TcDiWdk+eNDa5YSUkGMXnClEqJPi8jPJ1qeUoI3Ngf8sCSytA7Oe9q4rrDbU/xW61zdC5sAo6OJja8uFNYrN7RoUVK+/5Gx5gw7oEmSgBLDBszb6VI5NAb4HO1xKfSdOqZXhj98/Bmlm1cgrpfqHqZ8TX4dRxkBUtTlaoqqwFGWneoeahIlQccOpK0cUg8+Nu29poENjTNWHz6fTo14H86J0ybu3rzkHkTsJekMqopF4PlhPCW+Uk2vumwFQU/bCbmu8/s1JpNRmbDgPo
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB5873.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(136003)(346002)(366004)(376002)(396003)(451199018)(33656002)(83380400001)(54906003)(110136005)(6506007)(71200400001)(7696005)(41300700001)(9686003)(186003)(26005)(66946007)(2906002)(52536014)(76116006)(4326008)(66446008)(8676002)(64756008)(8936002)(66476007)(66556008)(55016003)(86362001)(7416002)(5660300002)(38100700002)(478600001)(82960400001)(966005)(38070700005)(122000001)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?lslTwXqqzZzeHOpRzcyA2nu3znIcIyymuyMqSA1oFw+ffZ3CFHb0fkeE2glB?=
 =?us-ascii?Q?xVpMoXeX9XMdme0w+GDEMA1K6BYyfm/BEwmWy7Ft6+FbMes8LzKVsf1Fonq3?=
 =?us-ascii?Q?FkfTfVYMwIANabLvDk/kQf0endLh0Y3/LN+3NfwQwRGDiEzX6N+30A3h+5iG?=
 =?us-ascii?Q?lzbVxlO0uZ/dgEquVP3jonYo91ZmzrkPingqt1jFltzJBJ+e17Y8OWqvGTzQ?=
 =?us-ascii?Q?/8iiP4SgxJfieOLQP0rfHxvlHD4cwTqYTxOuy0JHqWuo4DZ2uOkXatq/lpzw?=
 =?us-ascii?Q?3SDj2sTane7UfBSqVLycsKChklB4L6SbqzbwZ8d11NFwUHi9kINZfFU8AVRv?=
 =?us-ascii?Q?Vtt1c7uQcUqLkwSrnS76uKIChJylpqqbNxn35f5NoCGVVyr0Z8p/WTKypd5r?=
 =?us-ascii?Q?VskPAKhmeEJEbkWlgnrEkySxL6W3uda4LATEvdQPpUDO/UDqDxL0eyoNaw4i?=
 =?us-ascii?Q?rSpZ+hvxILLEmjaGGLjsnO5LROpc8BwJHjnj17cOqyY7if58gtGuwpkSWtbh?=
 =?us-ascii?Q?wmcI53TCyjo/9gvw0DiUT3eepf2fwTJCDYm+dD54RDmrvBMP5KtZnkD++zPP?=
 =?us-ascii?Q?fNdyCJ6wURz8kP8dNkMjtma3NwwZE35huU9oVi9Qn2jQ/fypIMAuSEh1fqzP?=
 =?us-ascii?Q?rSFrFqvcK28gGv2Zif2fkcTjysF4c01EJ7Bam4Cnnm1yNc+4mUlYBt8s5woX?=
 =?us-ascii?Q?eOO6geLjLqbkI341E1wGn0f36ikipTm2bwPD4xRpC7+3vOYm/HVQuKaahVzd?=
 =?us-ascii?Q?0uL5DTrczJmDwzfzacazIgRbpyDPIrk4TDmpW2yQAiBo44f5YMPriDGFtw85?=
 =?us-ascii?Q?DfeY8gzO5q+p6+BjPJdessmqg+om7D3z85KLo4lw1IGfoRxPWTuLG/+uyoF6?=
 =?us-ascii?Q?APddlfLx99+LP1o5PxnPIOmhVwmtffzIlE/Qv1kGEy6krI59+pdZAHIj3Q5X?=
 =?us-ascii?Q?QO99LFPllAsD7FRCOkqnVgcM1HCgKv5pDru4sDGPcu+Ql89gFwF2uqyDqATG?=
 =?us-ascii?Q?+dss88Vnr91OA5HGOoHRciHBQK98dDhrXrL2u7nscciq6Twb5E/vNGaTQNwL?=
 =?us-ascii?Q?mbFnfa43VeE2fQn1gl49/NcAgLrfW0DyI2f+ZN/0Dp256hny6uQaEa7qF0lY?=
 =?us-ascii?Q?FWBspc89gyeBcBTOMfdY/0GWZ0lrt85r9DYD+Sa8HAw8OH1bhic9cBjAfTcj?=
 =?us-ascii?Q?yVqRN9B4B8YpLrVP6hvyJlijRIkvzTfa/1zDyhvpHo6UDbtuNBHQeq1pT9xX?=
 =?us-ascii?Q?NvCEHQj0HZ2QpVAkzezFNeRm1DTgp49fRWonFKcGkdtR03rBPn8i959RP8pK?=
 =?us-ascii?Q?K0Cq5alRgWutdX9TO56q73ehC5dBbni0cw8hHkJI/fHQy6hk67iBrsaqa6Lt?=
 =?us-ascii?Q?cnptkjr1FFZAwAGb+uBznjjUKkjhd5ya7RGbaSVCTWy82mawuywI2Gy+aFZ7?=
 =?us-ascii?Q?LUDJzKa4YdcxXEuCIEQjmNJBmqmtT3TCg1CdOpCWqWktKKPDHZlSkxcp40hd?=
 =?us-ascii?Q?PcnkJcynwTXpSTu4BGvQVkJbotTvCLV5Ki+Duqu4s+U7S3dgwGu1AgmmutNp?=
 =?us-ascii?Q?Qjxj1UqXM3gRsZw35yh2Z0k8FVXDQ7G/ln8dJI34?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB5873.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d6a3b51-b92c-41bd-f62f-08db19acf650
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2023 16:58:06.0471
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: E7+NlHYgIUMddvT3dBakrd3rT/TiuNRf8UaA74gdXxKQG8T3BLf4WBmH+mXyxGOxx3vjMrxJ5eUjxFnKCSTlSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7660
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Tuesday, February 28, 2023 11:03 AM
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Tuesday, February 28, 2023 3:21 AM
> >
> > On Mon, Feb 27, 2023 at 03:11:16AM -0800, Yi Liu wrote:
> > > Existing VFIO provides group-centric user APIs for userspace.
> > > Userspace opens the /dev/vfio/$group_id first before getting device
> > > fd and hence getting access to device. This is not the desired model
> > > for iommufd. Per the conclusion of community discussion[1], iommufd
> > > provides device-
> > centric
> > > kAPIs and requires its consumer (like VFIO) to be device-centric
> > > user APIs. Such user APIs are used to associate device with iommufd
> > > and also the I/O address spaces managed by the iommufd.
> > >
> > > This series first introduces a per device file structure to be
> > > prepared for further enhancement and refactors the kvm-vfio code to
> > > be prepared for accepting device file from userspace. Then refactors
> > > the vfio to be able to handle iommufd binding. This refactor
> > > includes the mechanism of blocking device access before iommufd
> > > bind, making the device_open
> > exclusive.
> > > between the group path and the cdev path. Eventually, adds the cdev
> > support
> > > for vfio device, and makes group infrastructure optional as it is
> > > not needed when vfio device cdev is compiled.
> > >
> > > This is also a prerequisite for iommu nesting for vfio device[2].
> > >
> > > The complete code can be found in below branch, simple test done
> > > with
> > the
> > > legacy group path and the cdev path. Draft QEMU branch can be found
> > at[3]
> > >
> > > https://github.com/yiliu1765/iommufd/tree/vfio_device_cdev_v5
> > > (config CONFIG_IOMMUFD=3Dy CONFIG_VFIO_DEVICE_CDEV=3Dy)
> > >
> > > base-commit: 63777bd2daa3625da6eada88bd9081f047664dad
> >
> > This needs to be rebased onto a clean v6.3-rc1 when it comes out
>=20
> Yes, I'll send rebase and send one more version when v6.3-rc1 comes. Here
> just try to be near to the vfio code in Alex's next branch.
>=20
> Regards,
> Yi Liu

Verified this series by "Intel GVT-g GPU device mediated passthrough" and "=
Intel GVT-d GPU device direct passthrough" technologies.
Both passed VFIO legacy mode / compat mode / cdev mode, including negative =
tests.

Tested-by: Terrence Xu <terrence.xu@intel.com>
