Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67E396FB427
	for <lists+kvm@lfdr.de>; Mon,  8 May 2023 17:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234588AbjEHPqp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 May 2023 11:46:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234541AbjEHPqb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 May 2023 11:46:31 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE184A274;
        Mon,  8 May 2023 08:46:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683560775; x=1715096775;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LQdwDtct/OOb07SxL1kJFh54MuvVwaNndWDXneYQSYM=;
  b=Zm1KmBZVQDIUpT6M3jjGUd/r/XnuHcINBeGKGYGng/XB2ZI8tArmhZTb
   PMTA71ZCAWXggM+UhOYumeF4O3cxsdt7t3Nb+uNjnJgdG3UuskHd3ghZI
   2cTZes6sJZ/yzhw3NM2gEyM+wu38tyNyUXbROMp3yFW1XO9zHBZ9Yq6+s
   wq+CuicK603Kcx3n6k/K8jgqV1ki6qrLpY82Xe31wrSS/H5ctlG1QZu71
   oaJPHnbRR2CxAEgefe3wF2BqzuHeGNlG9xx7eeY0hslaKf9Vi+uAZs/SE
   tiZrwUH0a+6dRyxL12vGI3PjjPwdCptPtQlXV9FITTRbdxr04wO9NsrbE
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10704"; a="347148530"
X-IronPort-AV: E=Sophos;i="5.99,259,1677571200"; 
   d="scan'208";a="347148530"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2023 08:46:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10704"; a="701456689"
X-IronPort-AV: E=Sophos;i="5.99,259,1677571200"; 
   d="scan'208";a="701456689"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga007.fm.intel.com with ESMTP; 08 May 2023 08:46:15 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 8 May 2023 08:46:14 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 8 May 2023 08:46:14 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.173)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 8 May 2023 08:46:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k+KgorIUce1BQHEIinKyRS0m2jiDWRvIeqAl6oH9y5RmU55fiWRjEdqbqv4jiqHWnNJhHLWRuIoiw84q5qHuKmKZd4CMBTv4G2yrDIAknv+gr+u1TEiQEcfA95fUKyDHrq5V0N8PYcBb8k9a43xahRBZKjkENvr9pdbCiQavlhe/KYbog0o4J98q7imoHvKUfp3g8cah6skonzGTH17sxAe4V88rRJnS99CFYiZ/3Q+6tqTv0F3rU/DtV0pwlf81oLFb+JJU4L9x9yGLh5GJU+Nw8flppV7Hean71F1I40+nLAfVbXlz+ibabVlySrotxSx+TwYPP1mhtwzY7px3rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LQdwDtct/OOb07SxL1kJFh54MuvVwaNndWDXneYQSYM=;
 b=N+W9x/RYUfMR9/DTYcFIunqENqxoK/2XCV9/+dbyts+MpHFJp6clFwEKC5TmXHXnQ97af9IfUdot4EURbU3YrWK3Lh3nMKbQlFuA7lmYc4VwZcBHmIOewiQWiX2ozmT3eXwMGFej1IDty9JIexq0NlKO+RzLlzMhYbHD9kTNf7AjfkVSI7fuPVBkZVbeVXSlSMbsfO48COOJHQRHBGndP76VTRTa6fxr1dGZhxGv8emJwgWTKiZqRb/EcfTMHaM2XM5cb1zLDD4Ld7PXu3fF35Kwwks75jQcPiO5J1nPkNedt8FyZdko2kCGDkjd/HPvjc7cfNcuvlBoZCtuQ9QmDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SA3PR11MB7626.namprd11.prod.outlook.com (2603:10b6:806:307::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.31; Mon, 8 May
 2023 15:46:12 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5%3]) with mapi id 15.20.6363.032; Mon, 8 May 2023
 15:46:12 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>, Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
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
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
Subject: RE: [PATCH v4 2/9] vfio-iommufd: Create iommufd_access for noiommu
 devices
Thread-Topic: [PATCH v4 2/9] vfio-iommufd: Create iommufd_access for noiommu
 devices
Thread-Index: AQHZeE8IlpbqU+0d80ea2xcAM3D0DK8+tVeAgAAAlECAAMaWgIAAxjMAgABgzICAAELrAIAGbDOAgAD/bECACEKWAA==
Date:   Mon, 8 May 2023 15:46:12 +0000
Message-ID: <DS0PR11MB752951B3AA041B9EA2DABA0EC3719@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230426145419.450922-1-yi.l.liu@intel.com>
 <20230426145419.450922-3-yi.l.liu@intel.com>
 <BN9PR11MB52768AF474FAB2AF36AC00508C6A9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DS0PR11MB752972AC1A6030CB442ACF3FC36A9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230427123203.22307c4f.alex.williamson@redhat.com>
 <a6b77884-1678-b17c-f6a4-28d56e6c366b@intel.com>
 <ZEu3Ga9cIQAykBGf@nvidia.com>
 <3b83d829-048b-174f-a21d-b28ad0b7b49e@intel.com>
 <ZFFSff0cV/eC7IZ2@nvidia.com>
 <DS0PR11MB7529DCEF617AD24D62E33C2DC36C9@DS0PR11MB7529.namprd11.prod.outlook.com>
In-Reply-To: <DS0PR11MB7529DCEF617AD24D62E33C2DC36C9@DS0PR11MB7529.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|SA3PR11MB7626:EE_
x-ms-office365-filtering-correlation-id: d2b4e2ff-c7b7-44f6-e023-08db4fdb59a2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4VbaonG7EHNXfl0D0AE36Wn2/zjkPILC+HgS4Ony253bpkZIP+kfHtRBTsmTJwM6/KvJljfO6t4i+gPTZyFjlOULnsX2O2eOVDCLyExVsxgcy6NB0YzxB6R++B0r9qV9yRpNRTnlqGLNS/UmD7Pg4kGrk8hHgdrVeIJV1YlsK7kMFrZgOj7kZXfHZLjqu3jKeIJLcKvNn3z1PvoAIPYBKfQQF3z6UqyHzj1eGzSxC8ICb8/INEXlAoPSAJ7rkckykkPetF4sOCiXlkbWT7foCg5PVkFpSvIuO9ffYemefhlTZslzsFOJ1chYfwaGROK3jvsLWFtoaREYDcIzwkI6PWZ1aL1ckFsmRCzz9ew2ii7tSYySWgeSaocRQuAwHlMaOQnMfURWYl59hh1wXFEEx26VLuOpempwrj/M7Q7jkOgpOZ3GPLytUZtmGJ7bX9oXvvWBqnCoQzmT8fF4uosH4qEjSg39YWcQZkBSOv9M/hE2RzQ6DX4cldbuFbvwGRexnEMn/jkcdbLbuFUgOpOJE9yARFi21aOBlL1QJZfSuagwgNdQzU6N0A2kCguJ/sFtZseRet2Ob3DasT1SvX+XDuvMdosRJGzIwe2Th4RN2D9/QG9EgcSlDdRvFKem1rwr
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(346002)(396003)(39860400002)(376002)(136003)(451199021)(122000001)(38100700002)(9686003)(8676002)(186003)(38070700005)(26005)(82960400001)(71200400001)(83380400001)(6506007)(2906002)(7416002)(8936002)(52536014)(86362001)(110136005)(478600001)(54906003)(5660300002)(7696005)(316002)(4326008)(66556008)(64756008)(66446008)(33656002)(76116006)(66946007)(41300700001)(66476007)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a0xhZjdhS29SMXZGUHZCaDlJeWdKOWdmVVUrbGtmeVYxWERBQ25PaGpSc2FQ?=
 =?utf-8?B?c2tWVlZRZHRkVGxqYzA2M0NHRHFoRXBseFkvNDczYWFiaGFEc0oyZ253UjRw?=
 =?utf-8?B?QWIrUUE3UXhOTnozeThTNWdFcXYzcHJsVmhNWnlta0VuOUxLR2VvYzBtbytl?=
 =?utf-8?B?NEhIa1FRLzhBTVgxSkFHSlZ6a25WVWFxUzAxczlWZVZDbW1HMDVJNUM5dmor?=
 =?utf-8?B?WnBTWlpHMDNLYWN5SjlpVzR3V0JFYkswTHZCWnJHRXFka25KR0k3bHBIa0Q3?=
 =?utf-8?B?OGNUQ1I0RUVCclJSME0rZ1Zjd2p6UDYxc0VZbWEwMDJnMVZTL2w5U0k5UHZn?=
 =?utf-8?B?b3c0TzhrTnJOcDRaZ0R3UU95dHE4Wnd4L2RYQ1VDeHRJcGRmbVBBZmdyK3Ru?=
 =?utf-8?B?c2x5TDErZHQvV3lJd0k1WVpMNWs4S09KYWRpZStzWVBTOVZyUVhqMGZxZDZY?=
 =?utf-8?B?RHlCeDFDNnFnWmp1bHdWa3N3REszZlR5SGRoeG05ZzdPeTlZVG1zYktRWEFO?=
 =?utf-8?B?MysrdTF4Y3ZRU2VxWkk3WmNlblFycDBBeStJaWRzVnRibk9UT1EyVlpETm1t?=
 =?utf-8?B?NXY0K2wwOXp1aTJ2Z2g2MkFZZURTV0J3WFl6ZjBzamxiaCtlWnREMWtaWjIv?=
 =?utf-8?B?WWV3dWRnZ3RuRUQzZnVBTllyYnZqcWZoeWJ3ckh3RHZ5NW1TUWljSGo2Qmtv?=
 =?utf-8?B?aDBPbkNFcGFnK1JRR2Jjei81aU8zbThGZkVEdVVGVExhL01FMnBKNW5jb2Zq?=
 =?utf-8?B?ZldPT29xaXRvRGhKMFlweEJQODMvcUtsdU1NM1gzMStiQTJIQlNGQmF2M1d4?=
 =?utf-8?B?MHFPeDBwZFdLcEJ6endxekZPMEZUTGZhVTlNUU00TTM0T0d5bFZuTklGT29D?=
 =?utf-8?B?T1dabG5mWjVMMzNHSzN0QkE4UXpQNG1jaWxNNm9XWkZkL1pFTXBtTVUzQnlX?=
 =?utf-8?B?aVZrMjJNQjhJQVNHUmxtZ1FTSmxaZUNBcnY2N2pzb3RCOEVyWTFGTEkxekhC?=
 =?utf-8?B?VjRQTzYrUUVFRlhad2IyMXlKVEttdk1ZTS83SzI1UVJGNzNncjlBa1pPR0Jh?=
 =?utf-8?B?cDhpRnU1MngrYytaak14cWxSa3AwdnExbG9rTUtnblNQWTN0b2pMNGMzcGVD?=
 =?utf-8?B?bHRVd3MwTzkxdmU5bW1HalVSQ2h6UTdoajVoOU9USktHb1lWci9wNm50WG9Z?=
 =?utf-8?B?L2xDenE2NTdDdXRqWksrN1dHZ1BuRW5aQzcyMjVUb2dGYXhDYWF6N1lpazd0?=
 =?utf-8?B?MG9pTjJiNnFYVmlvdWlGcWprS2Q0bWF0dFF0UHdvTlo0bGNpajR4Z3NZR0ZS?=
 =?utf-8?B?SXo5dytJclRvTmRwSDJHRkYrL3NLRzFpQXRSTnpTTG5GQ293SWphVll4S2xk?=
 =?utf-8?B?Qlo1UXI3c3BETE5KZlZPalpwc0FFSUEzYm1ZdzZoZWY3YTRNU29IWWY4WkdI?=
 =?utf-8?B?VjhDaDBBcFhOdWh1NGlmZWJ2MEFZSVlxSVUyQVBlN1lUenlWSXpmTVo5bWxm?=
 =?utf-8?B?cHA0aUpleURFODVKNVBJUlIxOTU0dnlXME8xUDMrdWRUTjVvY2lYRlJ5Mkty?=
 =?utf-8?B?dCsvSUQrMi8vdDhWWjlOdlRTUXNtdjBMbXFXN1p0YUJ1RjlQMDc0c1hnNE9i?=
 =?utf-8?B?b1dwU0JBQnVsT0I2NmJIdzYvQWR0TjBQbGJkUVo2MmlySmhVZEFtQTN4aVpl?=
 =?utf-8?B?ODNHRlFadDFQRHRYRkVmUVlDV2hnc1ZuN2syNTRJSlNXLzlkcGxxSFVwMWtL?=
 =?utf-8?B?L0VGRkwvQ0R0cWF0SkNPUGZ3R0lHV3FTRGtPdjUvNG9Pc0dhQ1M5MHh0Wndk?=
 =?utf-8?B?bFg3cmRRQkFrSFhnbDJxL0R0bjU2c1BmUitDZWc5by82SSthNnZ0Z1RyNzNn?=
 =?utf-8?B?NC9YMDRETnZyUXhCQmlGcFNScGdWNVdyZmZxcXBMM29XMGdjTEFpdTJhYlRl?=
 =?utf-8?B?QUJ2VE9tTytVOXJDTG5wZFRJQkxDT3JWQnI0RDY4Q09kSktHNlloVVV2Nm5i?=
 =?utf-8?B?NXVra0VXOHVWaHVkY0NWL2hpZCtCQ1dzQ3A1TitZQ3V4NFk4UkZXTFArd0Qx?=
 =?utf-8?B?ZnBkQnlwY1M1emNPMkQ0NFlEYzR3WW9LUlRMVzNBK2xsQ1liVVNyTTFSK3ov?=
 =?utf-8?Q?YExaFi3jxpbSp+jNqpK8hWLqH?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2b4e2ff-c7b7-44f6-e023-08db4fdb59a2
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 May 2023 15:46:12.3192
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5B7EElKkNkEYEPTeG3zHzMoo+PBWWHjsJ/WXXkFfqx3b5i4bCeq8M1bXOO/ufk0sgZQUrLVoMGuVAcZ2FWkq2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7626
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBMaXUsIFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gU2VudDogV2VkbmVzZGF5
LCBNYXkgMywgMjAyMyA1OjQ5IFBNDQo+IA0KPiA+IEZyb206IEphc29uIEd1bnRob3JwZSA8amdn
QG52aWRpYS5jb20+DQo+ID4gU2VudDogV2VkbmVzZGF5LCBNYXkgMywgMjAyMyAyOjEyIEFNDQo+
ID4NCj4gPiBPbiBTYXQsIEFwciAyOSwgMjAyMyBhdCAxMjowNzoyNEFNICswODAwLCBZaSBMaXUg
d3JvdGU6DQo+ID4gPiA+IFRoZSBlbXVsYXRlZCBzdHVmZiBpcyBmb3IgbWRldiBvbmx5LCBpdCBz
aG91bGQgbm90IGJlIGNvbmZ1c2VkIHdpdGgNCj4gPiA+ID4gbm8taW9tbXUNCj4gPiA+DQo+ID4g
PiBobW1tLiBJIGd1ZXNzIHRoZSBjb25mdXNpb24gaXMgZHVlIHRvIHRoZSByZXVzZSBvZg0KPiA+
ID4gdmZpb19pb21tdWZkX2VtdWxhdGVkX2JpbmQoKS4NCj4gPg0KPiA+IFRoaXMgaXMgcHJvYmFi
bCB5IG5vdCBhIGdvb2QgZGlyZWN0aW9uDQo+IA0KPiBJIHNlZS4gQnV0IGlmIG5vdCByZXVzaW5n
LCB0aGVuIHRoZXJlIG1heSBiZSBhIGZldyBjb2RlIGR1cGxpY2F0aW9ucy4NCj4gSSdtIGZpbmUg
dG8gYWRkIHNlcGFyYXRlIF9iaW5kL3VuYmluZCgpIGZ1bmN0aW9ucyBmb3Igbm9pb21tdSBkZXZp
Y2VzDQo+IGlmIEFsZXggYW5kIHlvdSBwcmVmZXIgaXQuDQo+IA0KPiA+ID4gPiBFZyBpZiB5b3Ug
aGFkIGEgbm9faW9tbXVfYWNjZXNzIHZhbHVlIHRvIHN0b3JlIHRoZSBhY2Nlc3MgaXQgd291bGQg
YmUNCj4gPiA+ID4gZmluZSBhbmQgY291bGQgc2VydmUgYXMgdGhlICd0aGlzIGlzIG5vX2lvbW11
JyBmbGFnDQo+ID4gPg0KPiA+ID4gU28gdGhpcyBub19pb21tdV9hY2Nlc3Mgc2hhbGwgYmUgY3Jl
YXRlZCBwZXIgaW9tbXVmZCBiaW5kLCBhbmQgY2FsbCB0aGUNCj4gPiA+IGlvbW11ZmRfYWNjZXNz
X2NyZWF0ZSgpIHdpdGggaW9tbXVmZF9hY2Nlc3Nfb3BzLiBpcyBpdD8gSWYgc28sIHRoaXMgaXMN
Cj4gPiA+IG5vdCAxMDAlIHRoZSBzYW1lIHdpdGggbm9faW9tbXUgZmxhZyBhcyB0aGlzIGZsYWcg
aXMgc3RhdGljIGFmdGVyIGRldmljZQ0KPiA+ID4gcmVnaXN0cmF0aW9uLg0KPiA+DQo+ID4gU29t
ZXRoaW5nIGxpa2UgdGhhdCwgeWVzDQo+ID4NCj4gPiBJIGRvbid0IHRoaW5rIGl0IGlzIGFueSBy
ZWFsIGRpZmZlcmVuY2Ugd2l0aCB0aGUgY3VycmVudCBmbGFnLCBib3RoDQo+ID4gYXJlIGRldGVy
bWluZWQgYXQgdGhlIGZpcnN0IGlvY3RsIHdoZW4gdGhlIGlvbW11ZmQgaXMgcHJlc2VudGVkIGFu
ZA0KPiA+IGJvdGggd291bGQgc3RhdGUgcGVybWFuZW50bHkgdW50aWwgdGhlIGZkIGNsb3NlDQo+
IA0KPiBXZWxsLCBub2lvbW11IGZsYWcgd291bGQgYmUgc3RhdGljIGZyb20gcmVnaXN0cmF0aW9u
IHRpbGwgdW5yZWdpc3RyYXRpb24uOi0pDQo+IFdoaWxlIG5vX2lvbW11X2FjY2VzcydzIGxpZmUg
Y2lyY2xlIGlzIGJldHdlZW4gdGhlIGJpbmQgYW5kIGZkIGNsb3NlLiBCdXQNCj4gZ2l2ZW4gdGhh
dCB0aGUgbWFqb3IgdXNhZ2Ugb2YgaXQgaXMgZHVyaW5nIHRoZSBkdXJhdGlvbiBiZXR3ZWVuIGZk
IGlzIGJvdW5kDQo+IHRvIGlvbW11ZmQgYW5kIGNsb3NlZCwgc28gaXQncyBzdGlsbCBwb3NzaWJs
ZSB0byBsZXQgbm9faW9tbXVfYWNjZXNzIHNlcnZlDQo+IGFzIG5vaW9tbXUgZmxhZy4g8J+Yig0K
DQpIaSBKYXNvbiwNCg0KSSBmb3VuZCBhbm90aGVyIHJlYXNvbiB0byB1c2Ugbm9pb21tdSBmbGFn
IGhlcmUuDQoNCkV4aXN0aW5nIHZmaW8gd2lsbCBmYWlsIHRoZSB2ZmlvX2RldmljZSByZWdpc3Ry
YXRpb24gaWYgdGhlcmUgaXMgbm8gaW9tbXVfZ3JvdXANCmFuZCBuZWl0aGVyIENPTkZJR19WRklP
X05PSU9NTVUgYW5kIHZmaW9fbm9pb21tdSBpcyBzZXQuIEJ1dCBzdWNoDQpsb2dpYyBpcyBjb21w
aWxlZCBvdXQgd2hlbiAhQ09ORklHX1ZGSU9fR1JPVVAuDQoNClNvIGNkZXYgcGF0aCBuZWVkcyB0
byBjaGVjayBub2lvbW11IGV4cGxpY2l0bHkuIEp1c3QgbGlrZSBiZWxvdyBjb2RlLg0KSXQgaXMg
Y2FsbGVkIGJ5IHZmaW9fZGV2aWNlIHJlZ2lzdHJhdGlvbi4gSWYgaW9tbXVfZ3JvdXAgaXMgbnVs
bCwgYW5kDQpub2lvbW11IGlzIG5vdCBlbmFibGVkLCB0aGVuIGl0IGZhaWxlZCwgaGVuY2UgdmZp
b19kZXZpY2UgcmVnaXN0cmF0aW9uDQpmYWlsZWQuIEFzIHdlIGhhdmUgc3VjaCBhIGNoZWNrIGZv
ciBub2lvbW11IGF0IHJlZ2lzdHJhdGlvbiwgc28gaXQgc2VlbXMNCm1vcmUgcmVhc29uYWJsZSB0
byByZWNvcmQgdGhpcyByZXN1bHQgaW4gYSBmbGFnIGluc3RlYWQgb2YgdXNpbmcNCm5vX2lvbW11
X2FjY2Vzcy4gSXMgaXQ/DQoNCitzdGF0aWMgaW5saW5lIGludCB2ZmlvX2RldmljZV9zZXRfbm9p
b21tdShzdHJ1Y3QgdmZpb19kZXZpY2UgKmRldmljZSkNCit7DQorCXN0cnVjdCBpb21tdV9ncm91
cCAqaW9tbXVfZ3JvdXA7DQorDQorCWRldmljZS0+bm9pb21tdSA9IGZhbHNlOw0KKw0KKwlpb21t
dV9ncm91cCA9IGlvbW11X2dyb3VwX2dldChkZXZpY2UtPmRldik7DQorCWlmICghaW9tbXVfZ3Jv
dXApIHsNCisJCWlmICghSVNfRU5BQkxFRChDT05GSUdfVkZJT19OT0lPTU1VKSB8fCAhdmZpb19u
b2lvbW11KQ0KKwkJCXJldHVybiAtRUlOVkFMOw0KKwkJZGV2aWNlLT5ub2lvbW11ID0gdHJ1ZTsN
CisJfSBlbHNlIHsNCisJCWlvbW11X2dyb3VwX3B1dChpb21tdV9ncm91cCk7DQorCX0NCisNCisJ
cmV0dXJuIDA7DQorfQ0KDQpSZWdhcmRzLA0KWWkgTGl1DQo=
