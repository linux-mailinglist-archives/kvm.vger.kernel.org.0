Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08E055B6559
	for <lists+kvm@lfdr.de>; Tue, 13 Sep 2022 04:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbiIMCF0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Sep 2022 22:05:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbiIMCFZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Sep 2022 22:05:25 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4E9B24F33
        for <kvm@vger.kernel.org>; Mon, 12 Sep 2022 19:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663034723; x=1694570723;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=isA6wPjpFT7Dq9DTOv9nIjufsUm0mSNpXm6HgS14tNE=;
  b=RgI8N52f7tCqTTohFWpzzZQdX3fbe8gZrTMS51MpF9tJS16wImtcL6wj
   DLHKlzJidk3HChPM8bT1/wLnifG0vob9VVG6HPNXAJglA0zdDSo7J82OI
   KXv4Zi1bASMvHqpD1/0/FRdz6jsnk77h+Km998MWUMLAzMh5XReW8pu6C
   hp0j4QWE3mVEoCwQtyeGPSOBOvi+YdjXFARNNh5nuJOXxe9wf2FPoPwON
   3ggPOW2TX5XgwkCVqkNGaT4c898X654vEA3/zhsF9sBUjSigP0YI808qT
   Xmc9SGYO7GOaeCDmTad7xlkan9r9NxEOI4ZljBExK/yWkJ0xTRMAg7MaT
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10468"; a="298017480"
X-IronPort-AV: E=Sophos;i="5.93,311,1654585200"; 
   d="scan'208";a="298017480"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2022 19:05:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,311,1654585200"; 
   d="scan'208";a="649473829"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP; 12 Sep 2022 19:05:22 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 12 Sep 2022 19:05:22 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 12 Sep 2022 19:05:21 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 12 Sep 2022 19:05:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FvSN/lUhQYb8Yfzz2IUrXOiLEaUr1n7vIgJb9bG+xXE3JqmrTlYkFbnLFs3NutBiU2AQUPkOtLTgKjhjvBKZksFAlWhyYddA5ct40mkNHu/RoZ8y0ic+31MAArUGNxnjgdIWZTuZUQSW1akqH1dk6cO2TFR0DNf8oxYekm5s7Q6CIkhOuPhFf9ZPz8t1NUIg9DfIF43etgNoAbwWqYeJ8Gdq2vOX2WiNkta/0b2f33JC9yTNSdOaQu38hRSLLzDlE+dSHXCo0cB5GDIvH5YYjI96IEaq40qN3ZufBjOy9n0DHD9JKaRGBV406ZNWHkafSced7VXnUenb2SkUjT/nNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jupKtgXccEfYpJRnfAk/86wKXqv3EVgf/iks+bgCtfA=;
 b=fIgfygmJyJfW8bxCz4SWuxphJMA0+XUV0RIMUFgMKGDenOqjXvXXwaTVfcqjx+zl0qRsso6H1PuUVXecKOszrys1sVqN5IP7gfpNDcVCMl0bxmtQYCm4H7EPm9iuSwPXfNpkoX/wOVDgYhjp5U8ZkURebKPOVVzttBqf5KreaLdxi8oiZfdsqGGFcKbQG4rLdF564066RDYzJ4b3fmSV/nV3uZdXRnnmymg5qzXKO/Dbmvt0CzkQ+kGKID/L+qHVBVqADMiMWmB2KPgl59tF75GPUMe1z3qDpA8PIOnTc4Kj1e0pfL1W+DlHWBtEYS3Ban8H4LXsSlwlHEt2HIE+Bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.12; Tue, 13 Sep
 2022 02:05:13 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a435:3eff:aa83:73d7]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a435:3eff:aa83:73d7%5]) with mapi id 15.20.5612.022; Tue, 13 Sep 2022
 02:05:13 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Rodel, Jorg" <jroedel@suse.de>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        "Niklas Schnelle" <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
Subject: RE: [PATCH RFC v2 00/13] IOMMUFD Generic interface
Thread-Topic: [PATCH RFC v2 00/13] IOMMUFD Generic interface
Thread-Index: AQHYvwaitkEm6TEO00KJwkFy6AT+ga3cqchw
Date:   Tue, 13 Sep 2022 02:05:13 +0000
Message-ID: <BN9PR11MB527620E859FF60250E7F08A98C479@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v2-f9436d0bde78+4bb-iommufd_jgg@nvidia.com>
In-Reply-To: <0-v2-f9436d0bde78+4bb-iommufd_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MN0PR11MB5963:EE_
x-ms-office365-filtering-correlation-id: c067269c-6174-4b57-caed-08da952c64f1
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: =?us-ascii?Q?9xBNmiswUG5w0l8HbEg3b4Xo1vqmx46EkLPPlvNnB4Ppr3Eom2RT5yUYfq6N?=
 =?us-ascii?Q?uGaPnCdV449VjCBFxrw5j1DZCKIozoAEoi4wS8kpNNFFq7Ihp0ESM0BsQgi/?=
 =?us-ascii?Q?gaFCyTg+X3kRfr+UjIKct0NRm9yW3hYljqYyGK5KzJtrWD/rd6AZxjXPmry+?=
 =?us-ascii?Q?LcANU6lA3D0oxomDHvZMKUSzgiwQ8XH2A53yi3rKeOW3QSOQQu20cz6v2IXH?=
 =?us-ascii?Q?nDFt0WTuTyD5XNYPsJ6ythZ21bXtQugC8j9NkGx4D0eP9E3EnHA5nYRauGEV?=
 =?us-ascii?Q?8ZrCsN6yf+w/xFVAEpl42vhyuAbR3viQ2WdEIn3VlVxIY0SO35XZgNJDt3L6?=
 =?us-ascii?Q?10btaEOAmHKYoHJb1pxIh9+I6ux5+DMf9CEZirdwkZfri4iIerd5TH36iyfx?=
 =?us-ascii?Q?Niz6EsPFa4FQtrL2HxqBbjoLqHZtVytz7P12EtMW1/Lj+y7M8zxX0q8fBBbE?=
 =?us-ascii?Q?XepMmYslfK1Na1Hs7QALjbBFaMLo+5lMHXUG0NZ8CkNxDxMGoD6lyDaj7D3X?=
 =?us-ascii?Q?4qHs/GYl/aIOSfsPHJMeCBMSWgF0DtPcOHaGXA9Y6mpPAsZafQ5YEj56oqFI?=
 =?us-ascii?Q?fVzrmsfcQfzQ1ORin1chp7iGfCXTjiT6wxhMA1xX8B+2IvcbRlCfDXofQimH?=
 =?us-ascii?Q?P1dWpsXzgURBPaxrc9z/i5YskenH4+GIuXhewU/u7zSkHlLlhYg2nnzWhx7u?=
 =?us-ascii?Q?JES3MIjeKVEvHujrttBG+irwqK0M+ZUN3XKVNdsWIFfZoGobJKOu63FQvufE?=
 =?us-ascii?Q?P4ddschsjrhC6apqE5pEEaYSK6FCNL0ow73nI/OUHW79+ydkem0QUCegGvvF?=
 =?us-ascii?Q?3KlY/wVu+VzOH4eE/uZ2MtHmnWonPaHlVhLRnYUfp3r3p3lLKocwYrZfhBNv?=
 =?us-ascii?Q?pvlp0HhMdtlA6pAsoh5MtIg4me2mKQ/SntUk9bBwqOKtb9VZlf2VzUO9cfCh?=
 =?us-ascii?Q?SNyUtd2IKq7cUxlC+9RSl0NCWW5a1Bji6s0ijQtuqFX3CeqhYSlG5UGk0VcC?=
 =?us-ascii?Q?5i072fOLq1CVXgozRd1qOpRdG0zSXFsQqOguuw2f/Qxt8apUFKvjT4qrYH/u?=
 =?us-ascii?Q?AHiLOUY8BVsP8dHHfk0hDhmZfFj3soRvArUE2RiNwAij/j9X/z2L9aT6qZxc?=
 =?us-ascii?Q?szAyYvldS3RX2Wfvl8yM64exrYRjgBt3LpHeJsvV0Z975uHhpyDRvqT01myX?=
 =?us-ascii?Q?gTM5BZ8MAHLfMJ1aSBv43fNwSUj1InmmQQ5jt8rnJeA7Q3K0LmtehwzbRb3d?=
 =?us-ascii?Q?HGY0xlnUKqOZjaX511H7zPP5hwOCosZjnHjwm1CqellTphTtim6nVzlykBJm?=
 =?us-ascii?Q?MC2m69tJ3I6R/TJENX+VdAvLBnq8DzF/7NSKpZk6VqkHT2eSJEdWsxvJyYmG?=
 =?us-ascii?Q?a1Nepby/ddfIuPWIfICEx+35zJKCVc+EWasmphh2uHXmdJ01O43KJFeGmGNP?=
 =?us-ascii?Q?pUbVT7n5mddZXYQqGC1If8He3yzZA7Mz?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:9;SRV:;IPV:NLI;SFV:SPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:OSPM;SFS:(13230022)(396003)(39860400002)(376002)(346002)(366004)(136003)(451199015)(86362001)(8676002)(83380400001)(66556008)(64756008)(7416002)(316002)(6506007)(122000001)(30864003)(52536014)(26005)(38100700002)(66476007)(76116006)(2906002)(66446008)(7696005)(33656002)(478600001)(966005)(71200400001)(55016003)(4326008)(5660300002)(38070700005)(41300700001)(186003)(9686003)(54906003)(110136005)(66946007)(8936002)(82960400001)(41533002);DIR:OUT;SFP:1501;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?YuyHD3+j/6s6rm+kRW98dWkE4WKDhcdTLMJ1cbpWAaLNH3PbyW+ckP7mI/SE?=
 =?us-ascii?Q?Ol6/FlRQfwKLGGZaMKKn7Nn14/Ji0BoDcfEoeUl1FEemBI3iC+i7LvqgV1wI?=
 =?us-ascii?Q?d1kOIZfvJuoQMW6dUXPYtk0hFNkEkp7BVZAPcekDp7XH1zPuzSKPHjYYtaIT?=
 =?us-ascii?Q?m1+MhXqWzGs7nAx8aCeVVmNIsrawhG0u8aEymx2hR8UQ8HAj/7/ZbXrU7sMw?=
 =?us-ascii?Q?4Kem3Myy8EmqLaNzRoHmNYNBWhy0zqBVdtI+aGqTbW8ZXqymLkQCQXmHvIYr?=
 =?us-ascii?Q?g0PiqQ4nxSKa2suoy85SFquQlt21UtU0jZxVgNPLzH8Nf3r4oVL3k+5Vqw4m?=
 =?us-ascii?Q?9tOEQRbt/j0SnbGoQSF7o6qsQ/pigz/udTJx94UvVM0X4joq6mgvoH9bzkhm?=
 =?us-ascii?Q?RSGu1MudBP4ncV0X5eqBX3gwn8ATSB6A+EKgLfIVE8rSqZOvCbU9x/87haE3?=
 =?us-ascii?Q?15s6hVsyoSaxFnuEEDlsl8izoA2RPhhBTOyxLe4cM7tndkP7gDiE8fAvOM0W?=
 =?us-ascii?Q?3E0m0KuMl0EWfE4Lp1uJzKTz0KQbP3y4Bu+SF6KND91fRvALB3inW+6MRARS?=
 =?us-ascii?Q?eF6p/pM+mdQaxt2TUOmZIS+Il1ofZVjYYG7u4tMAsR8mKOrJpY0AxYuuCUcs?=
 =?us-ascii?Q?Ts8Fv7RRExeffLuzw3Sm6Y+lZBM2KszwLGNfWnHkiqTiVvjMbY5sUGhrH/HC?=
 =?us-ascii?Q?71jSMuRu8lMhnXPx2hgeg2D2Z1bfvX49U5WmCsWK/FvjFGeScchpTU+zdu8z?=
 =?us-ascii?Q?CtYSwtT7Zp3BLCMjJG+axnz9CaiLHzJI0Nn09B/5TbEDZ1b+i6buIoDZgI6L?=
 =?us-ascii?Q?91NPJuMv/fK5Rjfx5BaytlWrfgE3iPOnwIROXsI1OSbfUPGdLBdqCSWqS/jK?=
 =?us-ascii?Q?dwiY4xTRJwk40Xw4DrEKgGatuX650q4LtZNIUGKYrqBs+4vuFYzDD/36lJmZ?=
 =?us-ascii?Q?E9MyGnrRkOxdFM0eonbjxNxep+h4gWTH1Ko2Tn/fjMJ0pSkE5aI7/MT9jG2k?=
 =?us-ascii?Q?MMP7gvhX9mEPslsN6ZH2c0GcE0AicTI2A8f+euXyBK7sPHpBabbpJGtzYXOa?=
 =?us-ascii?Q?+ybOVcL3HEHDsK4W99UhHigJrkK3DX7pQTTs2aPLgGsg74eo0azQRCvHPb0G?=
 =?us-ascii?Q?CrYK1Ljovk1nPALFPRlOqQ+kG8slTtGCB7Go6/APoXvrY6VF8FG60JNbNPR4?=
 =?us-ascii?Q?aSFvTpGhtxCL2fvTJhTQdSKO+ZpJYHZlyNv24VWyCBorasyCB0JhoZtUh9wi?=
 =?us-ascii?Q?NkBFZxazlOo5RqgDTdbImNokL4bs/y+rAFXT/MhCSlsbA6BLmZb8Ev77ljXd?=
 =?us-ascii?Q?XYPEmckcGunpgYJet9GjwKX1o7CwXhJpM5mZPiS+GPtFW+T6V0k/mY9fVbiy?=
 =?us-ascii?Q?L/xuZtEFZGsJh3H+ejNeZiPpfKBdyc3ZT5LoMYIp5FwKNrKU4sx+f4wHo+O0?=
 =?us-ascii?Q?b4vmlC9Q+NLOPUmM/FE4n9ezB0m19CAP2vza0IPCom1sNSOqHm9+lqX+9pSy?=
 =?us-ascii?Q?o934TDmEtrpYVRzIZs3Ed5qxmgWgsVkvvgAPF5jaXM5p+GxIVHP7ncAgFsxe?=
 =?us-ascii?Q?0qUJob/h4vJqCnHLEVpJMkBScIbIr3e93TIARPTj?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c067269c-6174-4b57-caed-08da952c64f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2022 02:05:13.0857
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jYFJRrwTMmlN/GhmJ/l7yBFO8lKKK8l1D4EvMjroUnePQ6W6Y+YRDP2xNtproAUmVTTG+K8B0Cnbe9yQECeh/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB5963
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-3.9 required=5.0 tests=AXB_X_FF_SEZ_S,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A side open is about the maintenance model of iommufd.

This series proposes to put its files under drivers/iommu/, while the
logic is relatively self-contained compared to other files in that director=
y.

Joerg, do you plan to do same level of review on this series as you did
for other iommu patches or prefer to a lighter model with trust on the
existing reviewers in this area (mostly VFIO folks, moving forward also
include vdpa, uacces, etc.)?

Thanks
Kevin

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Saturday, September 3, 2022 3:59 AM
>=20
> iommufd is the user API to control the IOMMU subsystem as it relates to
> managing IO page tables that point at user space memory.
>=20
> It takes over from drivers/vfio/vfio_iommu_type1.c (aka the VFIO
> container) which is the VFIO specific interface for a similar idea.
>=20
> We see a broad need for extended features, some being highly IOMMU
> device
> specific:
>  - Binding iommu_domain's to PASID/SSID
>  - Userspace page tables, for ARM, x86 and S390
>  - Kernel bypass'd invalidation of user page tables
>  - Re-use of the KVM page table in the IOMMU
>  - Dirty page tracking in the IOMMU
>  - Runtime Increase/Decrease of IOPTE size
>  - PRI support with faults resolved in userspace
>=20
> As well as a need to access these features beyond just VFIO, from VDPA fo=
r
> instance. Other classes of accelerator HW are touching on these areas now
> too.
>=20
> The pre-v1 series proposed re-using the VFIO type 1 data structure,
> however it was suggested that if we are doing this big update then we
> should also come with an improved data structure that solves the
> limitations that VFIO type1 has. Notably this addresses:
>=20
>  - Multiple IOAS/'containers' and multiple domains inside a single FD
>=20
>  - Single-pin operation no matter how many domains and containers use
>    a page
>=20
>  - A fine grained locking scheme supporting user managed concurrency for
>    multi-threaded map/unmap
>=20
>  - A pre-registration mechanism to optimize vIOMMU use cases by
>    pre-pinning pages
>=20
>  - Extended ioctl API that can manage these new objects and exposes
>    domains directly to user space
>=20
>  - domains are sharable between subsystems, eg VFIO and VDPA
>=20
> The bulk of this code is a new data structure design to track how the
> IOVAs are mapped to PFNs.
>=20
> iommufd intends to be general and consumable by any driver that wants to
> DMA to userspace. From a driver perspective it can largely be dropped in
> in-place of iommu_attach_device() and provides a uniform full feature set
> to all consumers.
>=20
> As this is a larger project this series is the first step. This series
> provides the iommfd "generic interface" which is designed to be suitable
> for applications like DPDK and VMM flows that are not optimized to
> specific HW scenarios. It is close to being a drop in replacement for the
> existing VFIO type 1.
>=20
> Several follow-on series are being prepared:
>=20
> - Patches integrating with qemu in native mode:
>   https://github.com/yiliu1765/qemu/commits/qemu-iommufd-6.0-rc2
>=20
> - A completed integration with VFIO now exists that covers "emulated" mde=
v
>   use cases now, and can pass testing with qemu/etc in compatability mode=
:
>   https://github.com/jgunthorpe/linux/commits/vfio_iommufd
>=20
> - A draft providing system iommu dirty tracking on top of iommufd,
>   including iommu driver implementations:
>   https://github.com/jpemartins/linux/commits/x86-iommufd
>=20
>   This pairs with patches for providing a similar API to support VFIO-dev=
ice
>   tracking to give a complete vfio solution:
>   https://lore.kernel.org/kvm/20220901093853.60194-1-yishaih@nvidia.com/
>=20
> - Userspace page tables aka 'nested translation' for ARM and Intel iommu
>   drivers:
>   https://github.com/nicolinc/iommufd/commits/iommufd_nesting
>=20
> - "device centric" vfio series to expose the vfio_device FD directly as a
>   normal cdev, and provide an extended API allowing dynamically changing
>   the IOAS binding:
>   https://github.com/yiliu1765/iommufd/commits/iommufd-v6.0-rc2-
> nesting-0901
>=20
> - Drafts for PASID and PRI interfaces are included above as well
>=20
> Overall enough work is done now to show the merit of the new API design
> and at least draft solutions to many of the main problems.
>=20
> Several people have contributed directly to this work: Eric Auger, Joao
> Martins, Kevin Tian, Lu Baolu, Nicolin Chen, Yi L Liu. Many more have
> participated in the discussions that lead here, and provided ideas. Thank=
s
> to all!
>=20
> The v1 iommufd series has been used to guide a large amount of preparator=
y
> work that has now been merged. The general theme is to organize things in
> a way that makes injecting iommufd natural:
>=20
>  - VFIO live migration support with mlx5 and hisi_acc drivers.
>    These series need a dirty tracking solution to be really usable.
>    https://lore.kernel.org/kvm/20220224142024.147653-1-
> yishaih@nvidia.com/
>    https://lore.kernel.org/kvm/20220308184902.2242-1-
> shameerali.kolothum.thodi@huawei.com/
>=20
>  - Significantly rework the VFIO gvt mdev and remove struct
>    mdev_parent_ops
>    https://lore.kernel.org/lkml/20220411141403.86980-1-hch@lst.de/
>=20
>  - Rework how PCIe no-snoop blocking works
>    https://lore.kernel.org/kvm/0-v3-2cf356649677+a32-
> intel_no_snoop_jgg@nvidia.com/
>=20
>  - Consolidate dma ownership into the iommu core code
>    https://lore.kernel.org/linux-iommu/20220418005000.897664-1-
> baolu.lu@linux.intel.com/
>=20
>  - Make all vfio driver interfaces use struct vfio_device consistently
>    https://lore.kernel.org/kvm/0-v4-8045e76bf00b+13d-
> vfio_mdev_no_group_jgg@nvidia.com/
>=20
>  - Remove the vfio_group from the kvm/vfio interface
>    https://lore.kernel.org/kvm/0-v3-f7729924a7ea+25e33-
> vfio_kvm_no_group_jgg@nvidia.com/
>=20
>  - Simplify locking in vfio
>    https://lore.kernel.org/kvm/0-v2-d035a1842d81+1bf-
> vfio_group_locking_jgg@nvidia.com/
>=20
>  - Remove the vfio notifiter scheme that faces drivers
>    https://lore.kernel.org/kvm/0-v4-681e038e30fd+78-
> vfio_unmap_notif_jgg@nvidia.com/
>=20
>  - Improve the driver facing API for vfio pin/unpin pages to make the
>    presence of struct page clear
>    https://lore.kernel.org/kvm/20220723020256.30081-1-
> nicolinc@nvidia.com/
>=20
>  - Clean up in the Intel IOMMU driver
>    https://lore.kernel.org/linux-iommu/20220301020159.633356-1-
> baolu.lu@linux.intel.com/
>    https://lore.kernel.org/linux-iommu/20220510023407.2759143-1-
> baolu.lu@linux.intel.com/
>    https://lore.kernel.org/linux-iommu/20220514014322.2927339-1-
> baolu.lu@linux.intel.com/
>    https://lore.kernel.org/linux-iommu/20220706025524.2904370-1-
> baolu.lu@linux.intel.com/
>    https://lore.kernel.org/linux-iommu/20220702015610.2849494-1-
> baolu.lu@linux.intel.com/
>=20
>  - Rework s390 vfio drivers
>    https://lore.kernel.org/kvm/20220707135737.720765-1-
> farman@linux.ibm.com/
>=20
>  - Normalize vfio ioctl handling
>    https://lore.kernel.org/kvm/0-v2-0f9e632d54fb+d6-
> vfio_ioctl_split_jgg@nvidia.com/
>=20
> This is about 168 patches applied since March, thank you to everyone
> involved in all this work!
>=20
> Currently there are a number of supporting series still in progress:
>  - Simplify and consolidate iommu_domain/device compatability checking
>    https://lore.kernel.org/linux-iommu/20220815181437.28127-1-
> nicolinc@nvidia.com/
>=20
>  - Align iommu SVA support with the domain-centric model
>    https://lore.kernel.org/linux-iommu/20220826121141.50743-1-
> baolu.lu@linux.intel.com/
>=20
>  - VFIO API for dirty tracking (aka dma logging) managed inside a PCI
>    device, with mlx5 implementation
>    https://lore.kernel.org/kvm/20220901093853.60194-1-yishaih@nvidia.com
>=20
>  - Introduce a struct device sysfs presence for struct vfio_device
>    https://lore.kernel.org/kvm/20220901143747.32858-1-
> kevin.tian@intel.com/
>=20
>  - Complete restructuring the vfio mdev model
>    https://lore.kernel.org/kvm/20220822062208.152745-1-hch@lst.de/
>=20
>  - DMABUF exporter support for VFIO to allow PCI P2P with VFIO
>    https://lore.kernel.org/r/0-v2-472615b3877e+28f7-
> vfio_dma_buf_jgg@nvidia.com
>=20
>  - Isolate VFIO container code in preperation for iommufd to provide an
>    alternative implementation of it all
>    https://lore.kernel.org/kvm/0-v1-a805b607f1fb+17b-
> vfio_container_split_jgg@nvidia.com
>=20
>  - Start to provide iommu_domain ops for power
>    https://lore.kernel.org/all/20220714081822.3717693-1-aik@ozlabs.ru/
>=20
> Right now there is no more preperatory work sketched out, so this is the
> last of it.
>=20
> This series remains RFC as there are still several important FIXME's to
> deal with first, but things are on track for non-RFC in the near future.
>=20
> This is on github: https://github.com/jgunthorpe/linux/commits/iommufd
>=20
> v2:
>  - Rebase to v6.0-rc3
>  - Improve comments
>  - Change to an iterative destruction approach to avoid cycles
>  - Near rewrite of the vfio facing implementation, supported by a complet=
e
>    implementation on the vfio side
>  - New IOMMU_IOAS_ALLOW_IOVAS API as discussed. Allows userspace to
>    assert that ranges of IOVA must always be mappable. To be used by a
> VMM
>    that has promised a guest a certain availability of IOVA. May help
>    guide PPC's multi-window implementation.
>  - Rework how unmap_iova works, user can unmap the whole ioas now
>  - The no-snoop / wbinvd support is implemented
>  - Bug fixes
>  - Test suite improvements
>  - Lots of smaller changes (the interdiff is 3k lines)
> v1: https://lore.kernel.org/r/0-v1-e79cd8d168e8+6-
> iommufd_jgg@nvidia.com
>=20
> # S390 in-kernel page table walker
> Cc: Niklas Schnelle <schnelle@linux.ibm.com>
> Cc: Matthew Rosato <mjrosato@linux.ibm.com>
> # AMD Dirty page tracking
> Cc: Joao Martins <joao.m.martins@oracle.com>
> # ARM SMMU Dirty page tracking
> Cc: Keqian Zhu <zhukeqian1@huawei.com>
> Cc: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> # ARM SMMU nesting
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
> # Map/unmap performance
> Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
> # VDPA
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Jason Wang <jasowang@redhat.com>
> # Power
> Cc: David Gibson <david@gibson.dropbear.id.au>
> # vfio
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Cornelia Huck <cohuck@redhat.com>
> Cc: kvm@vger.kernel.org
> # iommu
> Cc: iommu@lists.linux.dev
> # Collaborators
> Cc: "Chaitanya Kulkarni" <chaitanyak@nvidia.com>
> Cc: Nicolin Chen <nicolinc@nvidia.com>
> Cc: Lu Baolu <baolu.lu@linux.intel.com>
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: Yi Liu <yi.l.liu@intel.com>
> # s390
> Cc: Eric Farman <farman@linux.ibm.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>=20
> Jason Gunthorpe (12):
>   interval-tree: Add a utility to iterate over spans in an interval tree
>   iommufd: File descriptor, context, kconfig and makefiles
>   kernel/user: Allow user::locked_vm to be usable for iommufd
>   iommufd: PFN handling for iopt_pages
>   iommufd: Algorithms for PFN storage
>   iommufd: Data structure to provide IOVA to PFN mapping
>   iommufd: IOCTLs for the io_pagetable
>   iommufd: Add a HW pagetable object
>   iommufd: Add kAPI toward external drivers for physical devices
>   iommufd: Add kAPI toward external drivers for kernel access
>   iommufd: vfio container FD ioctl compatibility
>   iommufd: Add a selftest
>=20
> Kevin Tian (1):
>   iommufd: Overview documentation
>=20
>  .clang-format                                 |    1 +
>  Documentation/userspace-api/index.rst         |    1 +
>  .../userspace-api/ioctl/ioctl-number.rst      |    1 +
>  Documentation/userspace-api/iommufd.rst       |  224 +++
>  MAINTAINERS                                   |   10 +
>  drivers/iommu/Kconfig                         |    1 +
>  drivers/iommu/Makefile                        |    2 +-
>  drivers/iommu/iommufd/Kconfig                 |   22 +
>  drivers/iommu/iommufd/Makefile                |   13 +
>  drivers/iommu/iommufd/device.c                |  580 +++++++
>  drivers/iommu/iommufd/hw_pagetable.c          |   68 +
>  drivers/iommu/iommufd/io_pagetable.c          |  984 ++++++++++++
>  drivers/iommu/iommufd/io_pagetable.h          |  186 +++
>  drivers/iommu/iommufd/ioas.c                  |  338 ++++
>  drivers/iommu/iommufd/iommufd_private.h       |  266 ++++
>  drivers/iommu/iommufd/iommufd_test.h          |   74 +
>  drivers/iommu/iommufd/main.c                  |  392 +++++
>  drivers/iommu/iommufd/pages.c                 | 1301 +++++++++++++++
>  drivers/iommu/iommufd/selftest.c              |  626 ++++++++
>  drivers/iommu/iommufd/vfio_compat.c           |  423 +++++
>  include/linux/interval_tree.h                 |   47 +
>  include/linux/iommufd.h                       |  101 ++
>  include/linux/sched/user.h                    |    2 +-
>  include/uapi/linux/iommufd.h                  |  279 ++++
>  kernel/user.c                                 |    1 +
>  lib/interval_tree.c                           |   98 ++
>  tools/testing/selftests/Makefile              |    1 +
>  tools/testing/selftests/iommu/.gitignore      |    2 +
>  tools/testing/selftests/iommu/Makefile        |   11 +
>  tools/testing/selftests/iommu/config          |    2 +
>  tools/testing/selftests/iommu/iommufd.c       | 1396 +++++++++++++++++
>  31 files changed, 7451 insertions(+), 2 deletions(-)
>  create mode 100644 Documentation/userspace-api/iommufd.rst
>  create mode 100644 drivers/iommu/iommufd/Kconfig
>  create mode 100644 drivers/iommu/iommufd/Makefile
>  create mode 100644 drivers/iommu/iommufd/device.c
>  create mode 100644 drivers/iommu/iommufd/hw_pagetable.c
>  create mode 100644 drivers/iommu/iommufd/io_pagetable.c
>  create mode 100644 drivers/iommu/iommufd/io_pagetable.h
>  create mode 100644 drivers/iommu/iommufd/ioas.c
>  create mode 100644 drivers/iommu/iommufd/iommufd_private.h
>  create mode 100644 drivers/iommu/iommufd/iommufd_test.h
>  create mode 100644 drivers/iommu/iommufd/main.c
>  create mode 100644 drivers/iommu/iommufd/pages.c
>  create mode 100644 drivers/iommu/iommufd/selftest.c
>  create mode 100644 drivers/iommu/iommufd/vfio_compat.c
>  create mode 100644 include/linux/iommufd.h
>  create mode 100644 include/uapi/linux/iommufd.h
>  create mode 100644 tools/testing/selftests/iommu/.gitignore
>  create mode 100644 tools/testing/selftests/iommu/Makefile
>  create mode 100644 tools/testing/selftests/iommu/config
>  create mode 100644 tools/testing/selftests/iommu/iommufd.c
>=20
>=20
> base-commit: b90cb1053190353cc30f0fef0ef1f378ccc063c5
> --
> 2.37.3

