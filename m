Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9065A6BB074
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 13:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231990AbjCOMST (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 08:18:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231942AbjCOMSI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 08:18:08 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E46DF93E03;
        Wed, 15 Mar 2023 05:18:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678882684; x=1710418684;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9FGcprbxJm76LiS5RpEYd0o35h5N5Fsl1jau8eT56Fo=;
  b=iZSoObI4EXKXMMt4QIvlNxczAqlrMMgy7xBj/QrXGbRVx0OjJ90A14Zc
   OGn4u8HblmriJHBecGQx84bpn8s5lkPzj0GAZROL03qLEWnO6etLc2zGJ
   Slvl9klfWT5gIzA9ELjoJFedg7c7tT4WxGgZOTs6pJYCti8wPkRWRxM4E
   cgDhF6qfcD3Px6lCErIErbflbZgMlAiCmeI/oJgd688q7jbSUl5EIuUO+
   swxZEEKY4I0/uPHCZaE9IycHxPEIA8LrZNRhGriXkjN60X7uq8osbC52E
   FGHwx8j1Bkjnt+M7V19eciyB0I+FYCrwnWdMBOxWKwiQ3KO2/mRH+P9fH
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="337706138"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="337706138"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 05:18:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="803265884"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="803265884"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga004.jf.intel.com with ESMTP; 15 Mar 2023 05:18:03 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 05:18:03 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 15 Mar 2023 05:18:03 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 15 Mar 2023 05:18:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ciJ0lGKsSOJubUNSHUTMlliONsvoMNkC/8wfHAXWwerMXh/HRTZkA0yRy5NshY+z5lFsLOo3cvZB8nAiyBi2+QHT1KdQlSIteAyBf625QbC7+awnXlMb6uLpKpcCHlFEw5ESL0oHCJOlXwhxHav9xztttKk9uBvcfNjZLIrSwFYPEoLXlmPxGpUoKt9Lr7VcJRxpsQAw2ZpQDTxsGZFOffEGPcyeNU9gY7h34qEt4zWCvPHQ4iN1Gw+WdFg41wQj14Vw4wBhvzS43uaHLg7OGx3nwCNYr+qftXakWNDJbTlgrhLB4PX40XqFS/l5wlMWpasMXyNcULJD/4+LLNr1GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9FGcprbxJm76LiS5RpEYd0o35h5N5Fsl1jau8eT56Fo=;
 b=SfA/Fe4N+MqVOymysosoKZsV4ncClTUAFUMCBFGpr/W4gkDP+Z74wTCBgmhEsBVMi+4+ExG9iDnimFllZvn0uKZcccd9dHfYElqRJl8bV7bBR6vs+0rGLedhMQRBhICsXH0Cb+lESigC3r31AlpoFJhcIu57ctrhETQPCKRhi9NAWc/tLNapwwVuJNPTcsV8zuwm6Q2j6HlnxLRde4ZL4lUeLTXX2sLHCXweIZ3PJX7+Mps/Dxn8llMtMa0tQE1KHlVk22liiP3xBID8Qfal7+EFEjRiC+0dZBYnS5nPvFPwHypwCBNocVstbMKyRiiDndJpMxSAf5yR4dzpAe963g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH0PR11MB5673.namprd11.prod.outlook.com (2603:10b6:510:d6::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Wed, 15 Mar
 2023 12:18:01 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%8]) with mapi id 15.20.6178.026; Wed, 15 Mar 2023
 12:18:01 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Nicolin Chen <nicolinc@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
CC:     "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Subject: RE: [PATCH v1 1/5] iommufd: Create access in
 vfio_iommufd_emulated_bind()
Thread-Topic: [PATCH v1 1/5] iommufd: Create access in
 vfio_iommufd_emulated_bind()
Thread-Index: AQHZUb/VywVS1tWF6Uet+ZnBHpWUv670SikAgAWuFwCAAReSgIAAV7uAgAAE04CAAAUYgIAAJPWAgAA13GA=
Date:   Wed, 15 Mar 2023 12:18:01 +0000
Message-ID: <DS0PR11MB752992285621A36585AEAB2BC3BF9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230308131340.459224-1-yi.l.liu@intel.com>
 <20230308131340.459224-2-yi.l.liu@intel.com> <ZAtqlnCk7uccR5E7@nvidia.com>
 <ZBAuXo166M+z8b3z@Asurada-Nvidia> <ZBEY49XtiFUImfe4@Asurada-Nvidia>
 <BN9PR11MB5276738DC59AC1B4A66AB3C38CBF9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZBFmh2iAqGGb8CjK@Asurada-Nvidia>
 <BN9PR11MB52765D7977F987960072482E8CBF9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZBGJzefTm4p/ReIu@Asurada-Nvidia>
In-Reply-To: <ZBGJzefTm4p/ReIu@Asurada-Nvidia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|PH0PR11MB5673:EE_
x-ms-office365-filtering-correlation-id: 5e67c0b7-983e-4139-9b37-08db254f522a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 81PVaflsY1Sy8iZ/1OR1btAA2qfR1aElajqRvixbZC+AZAXMeRvEXUhi7BPyxdRaPopFor3d/G31NMWp3Fd8W8lJpUGOVgYhQ1fnE6xWrrwAnHWR5G2EmtdvrtQmk5TJAVRJgCFbhkwJmX/AFxhrLsKoxKNm+RnCpBMoao6WL0w0YVtzvVgj3x39EdswsY1I45wavWh0jydlM4i33Dby/qnJpoDPb/cMuD/YJiFftWBeykTwDLC/s8xWd/Wu+RDz6Rgt0PsZGALrb9GI5CPHp+An0urfa6ip1t6T+Jv0/Nam3Xouyl5MipKy+2StSNMrsK0LaqwtYWtgmRX5RxjpJuQo4RoWnenJkeYtaQgbTqAOIyM7sH8M25g5r6gCnlPKCnyo0KQXBj8A4bUR7X54FKM2D9F3l9PlX5Lm9FVwnfEOdrWlHOBWuwTmVMEpJCGSRjyeU13i23GkA10QD8o6LZwJFSoT8skiSDEdaeTOaCZBVvcwHTmwtXzv8MuxsiqWfmE+xdszCDUVhSkecoDYjtI+0AzGTSUay6lBxpvYDIyY+Cav0Uvn+39QDp590ceKpzD26QwEqeMj85ZuBZ7M0/tel8+rnhH6woZNkj8KxPkFV4KtfoAhUFWKU24q9xnuF0EMIBtCORISq7xsJKvIIwy9vY31Kb7hEC8A/GZnIUEyYD6lI+hx/qWjNstKi5XrzkrOaGiOoB1PSi/GdN/OMb4jhGHQZ/dqFvv1VHBzla4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(39860400002)(136003)(366004)(396003)(376002)(451199018)(8936002)(7416002)(5660300002)(41300700001)(4326008)(8676002)(52536014)(55016003)(33656002)(86362001)(38070700005)(122000001)(38100700002)(82960400001)(2906002)(6506007)(9686003)(186003)(478600001)(83380400001)(966005)(71200400001)(26005)(7696005)(64756008)(66446008)(76116006)(66556008)(66946007)(66476007)(54906003)(6636002)(110136005)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZGZhNEFYTGpUWnNnS0loWm92WXF6RjA2Rmt0b0UwR2FkbGVOcWNtbkJNZDVE?=
 =?utf-8?B?NHg0WXBBVTZHTURtbE41NlNrRU10WVoydzVWSW42UEwxSVlXbjJ5Wmo2MEFZ?=
 =?utf-8?B?NDNUWU1NQnMxdzJ1dVBSTW9heUEzT1NDejBjdmNVUXRiZ3BOMHBERmoraFBV?=
 =?utf-8?B?SDNCTnBVanhSS2hMV0s0d0FaSS9LcDVkclpHdVp0N2MwbGhRRHFkcTFYNDg1?=
 =?utf-8?B?cCtlQ2N2dUxINTdRS21ldEUvYWtxN0E1b3h4bTdoSHZXUmpXODdhUGRuWUhQ?=
 =?utf-8?B?V2JtejRTczF0YUZaV1U3ZzZLaFl1ZmRWVGhGRlpMaW1RS1VjRHI2am96clk2?=
 =?utf-8?B?ZHNBV1R1aExUOGc5aU5oRXBVTGd4M3FJc3Zqa2ZPUHdONUNCTEVKejE5TXEx?=
 =?utf-8?B?WEo0MHFlUUc4eDJOaWhiYlVab1RuN2lJRUlONkVwcTBlUmhPTzM1WTFpK2hM?=
 =?utf-8?B?WDdLUk5qT3ZWM0o4blptN3lxaVNUN1F4YlUwTFBBcXRrSWFRb3dKSURkUGYy?=
 =?utf-8?B?aVVmdGU5N1F4SWRJZGJJVUM3OFJjNWN1U3h1Vkh1cDIwcVdXVE5mWDNDNHdX?=
 =?utf-8?B?VTdtT2t4MkE5SFJKS0xLVTIvUnRRV2RWVTNzY3NYTWZhUFFvcHFuQUFrVXZS?=
 =?utf-8?B?UWJSLzVVTjl2WSttU3FiLzgrL21lcHBwVCt0RGYyN0l3VUd6TW9mTkhFOVFY?=
 =?utf-8?B?ejJxTjgzRmY4UDZCcnhNRk1KNDNsbThYak14OFdBYWNwRlNuSnpNQlh2T2pN?=
 =?utf-8?B?ZmFLWEtXcXRwZjdmK2VOZm53NUF3RHc1ZU1iTkdEc2QzUWJEdzdESTZXS2pt?=
 =?utf-8?B?U3poL0c5YzVQbEVGdzVRS2xEbnhjU2gxSTJoQVNvQnhxSVpXOGI4V0tBUjh1?=
 =?utf-8?B?M01HMzFtM2V3T3ZMb1BRcXA1S1ZBMGVlZEljMnEycFZCRm9Cczg1YXZ2L0tk?=
 =?utf-8?B?WFRRTi9CZlhSNEdDTGtFYkxTQ2lGOFY4WDcyZWhQeFdmWUtJcGhvclRGeXRE?=
 =?utf-8?B?ZjdaRVVrNDkyajdIak96ZVUxa0Y0aFlnSSsrcXNBK0pxYjc1c0ZkdEpuRFlC?=
 =?utf-8?B?Zkd1Q1k4UGtkYXBkTytQZGtBdmJiVzRrWTV4MUR4dUI5bXlSdzIrLzR0TWNO?=
 =?utf-8?B?L1hoZlBPQTk3aGY0V3JPWjFpZVZPS3JmZENMQmFHdlRSeXFZZW5oeW1kcDli?=
 =?utf-8?B?LzBubzZ4Vzl1c0VBUFVjdktPa3hyRkdMcE1FNnhJL1FOU1pqVzhLM09RVlU5?=
 =?utf-8?B?dEFCU1RwR28yNTYrWHdETE1mN3V5TmpWN0t6d2U5bkp1eVlEY3dzdElOT3h4?=
 =?utf-8?B?T1dSQ1YzcVE5UktnTFF5RnhCMk04ZWFLK3ExWEd1YTNIa3dVT1I5dG5MZ2Fh?=
 =?utf-8?B?MDlOYk5BVW56SnJxOU5CSmUxNEJQb0FVaDVpRGtyRFN4ampwcEY0MU9MK1FT?=
 =?utf-8?B?bW5YWDFOVlE2eGVlSEdlV0x0NEkzV3JUdVd6UkcvSmJ2N0luVFdPOHBlNExV?=
 =?utf-8?B?QXRwOXdoRVpIRE91dDk1Yzd5TUxRdmVqT0svSHNtR01Kdy84WWxFaGNYdjM3?=
 =?utf-8?B?Z3I3S2xXaHhIMmtFTURta0pSdVpCb2xEeGZOY29pZE5XLzk0MXRWelpIbXVH?=
 =?utf-8?B?ZExWNms2UWxvY0NQeHVoYTNxN0JLVzlidVFrN0R3RFlyMWdsNFcvazJvNlBR?=
 =?utf-8?B?ODJmakdCZ2lGYng3S0NpbE5qa2pmMC9aYkdPVmdkSlhOMDFZeDd6ckg3NVJs?=
 =?utf-8?B?OWovTHJCdUlPRU1WTHN4Q3JjUjBwNFR6RUFtN3pHWHQ2WVo5VC9IajREc3pq?=
 =?utf-8?B?b3kzSGRCbzlZelNLS2ZQUnBYaGpzOVJxVGN5TDMrMVhwQ20vMEd4UEU0RTly?=
 =?utf-8?B?bUY1SElzV2E5V3dKaDNMSWQvY0lOTlN5WkJodzNNdGYyazRObTQxK3AzYll2?=
 =?utf-8?B?MnRVcWVsbmZsNTRPV0YwRnp1azFGcy82MUNJVXpVYjVZVXFPdEI0NlJtb2JN?=
 =?utf-8?B?dHUxcjdaV1l5Sjd6ck1HamlSQm01QnRkZGtyMk1BYTlsSlFzMGxJc2FTYkcz?=
 =?utf-8?B?UjByWnZhaE1ZSHQxSnRkUlpYWVlXMjNkNzlHL2VqNGowTm5FVHdYa2NtZ1NT?=
 =?utf-8?Q?/kFxcOB+AOIpZ+CxUcRSjkz8s?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e67c0b7-983e-4139-9b37-08db254f522a
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2023 12:18:01.3912
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ThoD30Sedkk3Qm9ja+3E60yynqU72+TMe2P/s7FmmZMNur/n7xxR0h849M4H6msqWUAQS7yy++G2z9882q7Kqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5673
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBOaWNvbGluIENoZW4gPG5pY29saW5jQG52aWRpYS5jb20+DQo+IFNlbnQ6IFdlZG5l
c2RheSwgTWFyY2ggMTUsIDIwMjMgNTowMyBQTQ0KPiANCj4gSGksDQo+IA0KPiBPbiBXZWQsIE1h
ciAxNSwgMjAyMyBhdCAwNjo1MDo1M0FNICswMDAwLCBUaWFuLCBLZXZpbiB3cm90ZToNCj4gDQo+
ID4gPiBTbywgdGhpcyBwcmVwYXJhdG9yeSBzZXJpZXMgd2lsbCBhZGQgYSBwYWlyIG9mIHNpbXBs
ZSBhdHRhY2goKQ0KPiA+ID4gYW5kIGRldGFjaCgpIEFQSXMuIFRoZW4gdGhlIGNkZXYgc2VyaWVz
IHdpbGwgYWRkIHRoZSBsb2NraW5nDQo+ID4gPiBhbmQgdGhlIGlvYXNfdW5waW4gc3R1ZmYgYXMg
YSByZXdvcmsgb2YgdGhlIGRldGFjaCgpIEFQSS4NCj4gDQo+ID4gPiBJIHRoaW5rIHRoZXkgY2Fu
IGJlIHNvbWV0aGluZyBtaW5nbGVkLi4uIHRoZSBzYW1wbGUgY29kZSB0aGF0DQo+ID4gPiBJIHNl
bnQgcHJldmlvdXNseSBjb3VsZCB0YWtlIGNhcmUgb2YgdGhvc2UgY29uZGl0aW9ucy4gQnV0LCBJ
DQo+ID4gPiBhbSBhbHNvIHRoaW5raW5nIGEgYml0IHRoYXQgbWF5YmUgYXR0YWNoKCkgZG9lcyBu
b3QgbmVlZCB0aGUNCj4gPiA+IGxvY2tpbmc/IEkgY2FuIGRvIGEgc2VwYXJhdGUgcmVwbGFjZSgp
IGZ1bmN0aW9uIGluIHRoaXMgY2FzZS4NCj4gPiA+DQo+ID4NCj4gPiB3L28gbG9ja2luZyB0aGVu
IHlvdSBuZWVkIHNtcF9zdG9yZV9yZWxlYXNlKCkgYW5kIGl0cyBwYWlyLg0KPiA+DQo+ID4gYW55
d2F5IGl0J3Mgbm90IGluIHBlcmYgY3JpdGljYWwgcGF0aC4gS2VlcGluZyBsb2NrIGZvciBhdHRh
Y2gNCj4gPiBpcyBzaW1wbGVyIGFuZCBzYWZlLg0KPiANCj4gT0suIEJhc2ljYWxseSBJIGZvbGxv
d2VkIHdoYXQgSmFzb24gc3VnZ2VzdGVkIGJ5IGhhdmluZyB0aHJlZQ0KPiBBUElzIGFuZCBjb21i
aW5lZCBLZXZpbidzIGlucHV0cyBhYm91dCB0aGUgZGlmZmVyZW5jZSBiZXR3ZWVuDQo+IHRoZSBh
dHRhY2gvcmVwbGFjZSgpLiBJIGFsc28gdXBkYXRlZCB0aGUgcmVwbGFjZSBjaGFuZ2VzLCBhbmQN
Cj4gcmViYXNlZCBhbGwgbmVzdGluZyAoaW5mcmFzdHJ1Y3R1cmUsIFZULWQgYW5kIFNNTVUpOg0K
PiBodHRwczovL2dpdGh1Yi5jb20vbmljb2xpbmMvaW9tbXVmZC9jb21taXRzL3dpcC9pb21tdWZk
X25lc3RpbmctMDMxNDIwMjMNCj4gDQo+IFRoZSBtYWpvciB0aHJlZSBjaGFuZ2VzIGZvciB0aG9z
ZSBBUElzOg0KPiBbMV0gVGhpcyBhZGRzIGlvbW11ZmRfYWNjZXNzX2F0dGFjaCgpIGluIHRoaXMg
c2VyaWVzOg0KPiAgICAgImlvbW11ZmQ6IENyZWF0ZSBhY2Nlc3MgaW4gdmZpb19pb21tdWZkX2Vt
dWxhdGVkX2JpbmQoKSINCj4gDQo+IGh0dHBzOi8vZ2l0aHViLmNvbS9uaWNvbGluYy9pb21tdWZk
L2NvbW1pdC8zNGZiYTc1MDk0MjkzODBmODI4ZmIyM2RjDQo+IGNhNWNlYWViNDBlMjJiNQ0KPiBb
Ml0gVGhpcyBhZGRzIGlvbW11ZmRfYWNjZXNzX2RldGFjaCgpIGluIHRoZSBjZGV2IHNlcmllczoN
Cj4gICAgICJpb21tdWZkL2RldmljZTogQWRkIGlvbW11ZmRfYWNjZXNzX2RldGFjaCgpIEFQSSIN
Cj4gDQo+IGh0dHBzOi8vZ2l0aHViLmNvbS9uaWNvbGluYy9pb21tdWZkL2NvbW1pdC80MTEwNTIy
MTQ2Y2ExZmMwZDUzMjFjMDRhDQo+IDA5N2UyYzlkOWUyNmFmNA0KPiBbM10gVGhpcyBhZGRzIGlv
bW11ZmRfYWNjZXNzX3JlcGxhY2UoKSBpbiB0aGUgcmVwbGFjZSBzZXJpZXM6DQo+ICAgICAiaW9t
bXVmZDogQWRkIGlvbW11ZmRfYWNjZXNzX3JlcGxhY2UoKSBBUEkiDQo+IA0KPiBodHRwczovL2dp
dGh1Yi5jb20vbmljb2xpbmMvaW9tbXVmZC9jb21taXQvMzY1MDdmYTlmMGY0MmNmMWE1YmViZTdj
OQ0KPiBiYzJiZjMxOWI3NjU0YTgNCj4gDQo+IFBsZWFzZSBjaGVjayBpZiB0aGV5IGxvb2sgb2th
eSwgc28gdGhhdCBZaSBjYW4gaW50ZWdyYXRlIHRoZW0NCj4gYWNjb3JkaW5nbHkgdG8gdGhlIGVt
dWxhdGVkL2NkZXYgc2VyaWVzLg0KDQpUaGFua3MuIEknbGwgc3RhcnQgdG8gaW50ZWdyYXRlIGFm
dGVyIGFjayBmcm9tIEtldmluIG9yIEphc29uLiBidHcuDQpCZWxvdyBpcyBteSBsYXRlc3QgY29k
ZSAocmViYXNlZCBvbiB0b3Agb2YgcmMtMikuIPCfmIoNCg0KaHR0cHM6Ly9naXRodWIuY29tL3lp
bGl1MTc2NS9pb21tdWZkL3RyZWUvd2lwL3ZmaW9fZGV2aWNlX2NkZXZfdjdfY2FuZGlkYXRlDQoN
Cj4gDQo+IFsqXSBUaGlzIGlzIHRoZSBwYXRjaCB0aGF0IEkgcG9zdGVkIGluIHRoZSBvdGhlciBt
YWlsIGFkZHJlc3NpbmcNCj4gICAgIEtldmluJ3MgY29tbWVudHMgb24gaW9tbXVmZF9jdHhfZ2V0
KCk6DQo+ICAgICAiaW9tbXVmZC9kZXZpY2U6IERvIGlvbW11ZmRfY3R4X2dldCgpIGF0IHRoZSB0
b3Agb2YNCj4gaW9tbXVmZF9hY2Nlc3NfY3JlYXRlKCkiDQo+IA0KPiBodHRwczovL2dpdGh1Yi5j
b20vbmljb2xpbmMvaW9tbXVmZC9jb21taXQvMDc3YjA5YmI4MzMyOWRjMDQ2NzUzZjRlZg0KPiA2
NzJmNWJmNjM4Njc1NWMNCj4gICAgIChJIGp1c3Qgc2F3IFlpJ3MgcmVwbHkgY29uY2VybmluZyBp
dHMgbmVjZXNzaXR5LiBGZWVsIGZyZWUNCj4gICAgICB0byBkcm9wIGluIHRoYXQgY2FzZS4pDQoN
ClllYWgsIGxldCdzIHNlZSBLZXZpbidzIGZlZWRiYWNrLg0KDQo+IA0KPiBUaGFua3MNCj4gTmlj
b2xpbg0KPiANCj4gUC5TLiBBdHRhY2hpbmcgdGhlIGxpc3Qgb2YgY2hhbmdlcyB3aXRoIHRoZWly
IGxvY2F0aW9uczoNCj4gMzc5MWRlZGY5OGU4IGNvdmVyLWxldHRlcjogQWRkIElPIHBhZ2UgdGFi
bGUgcmVwbGFjZW1lbnQgc3VwcG9ydA0KPiBjOGViZjUxYzNjOWIgdmZpbzogU3VwcG9ydCBJTyBw
YWdlIHRhYmxlIHJlcGxhY2VtZW50DQo+IGM1NzEwZjIzZThmNiBpb21tdWZkL3NlbGZ0ZXN0OiBB
ZGQNCj4gSU9NTVVfVEVTVF9PUF9BQ0NFU1NfUkVQTEFDRV9JT0FTIGNvdmVyYWdlDQo+IFszXSAz
NjUwN2ZhOWYwZjQgaW9tbXVmZDogQWRkIGlvbW11ZmRfYWNjZXNzX3JlcGxhY2UoKSBBUEkNCj4g
MDI2Mzg1NWQxZThiIHZmaW86IERvIG5vdCBhbGxvdyAhb3BzLT5kbWFfdW5tYXAgaW4NCj4gdmZp
b19waW4vdW5waW5fcGFnZXMoKQ0KPiBlMzllZDU1ZTc3YTAgY292ZXItbGV0dGVyOiBBZGQgdmZp
b19kZXZpY2UgY2RldiBmb3IgaW9tbXVmZCBzdXBwb3J0DQo+IDI2ZmQ3ZmNjYWVmMyBkb2NzOiB2
ZmlvOiBBZGQgdmZpbyBkZXZpY2UgY2RldiBkZXNjcmlwdGlvbg0KPiBmMTBmM2UzMTYyYmIgdmZp
bzogQ29tcGlsZSBncm91cCBvcHRpb25hbGx5DQo+IDk1ODhhZTRjNDA0OSB2ZmlvOiBBZGQgVkZJ
T19ERVZJQ0VfQVRbREVdVEFDSF9JT01NVUZEX1BUDQo+IDNlNTcxMDhlYWM2NCB2ZmlvOiBBZGQg
VkZJT19ERVZJQ0VfQklORF9JT01NVUZEDQo+IGI5MjU3MTZkZDIyNiB2ZmlvOiBBZGQgY2RldiBm
b3IgdmZpb19kZXZpY2UNCj4gZGIzMDk0NjNhYjkyIHZmaW8taW9tbXVmZDogQWRkIGRldGFjaF9p
b2FzIHN1cHBvcnQgZm9yIGVtdWxhdGVkIFZGSU8NCj4gZGV2aWNlcw0KPiBbMl0gNDExMDUyMjE0
NmNhIGlvbW11ZmQvZGV2aWNlOiBBZGQgaW9tbXVmZF9hY2Nlc3NfZGV0YWNoKCkgQVBJDQo+IGFi
Y2E3ZTFlMDYzYSB2ZmlvLWlvbW11ZmQ6IEFkZCBkZXRhY2hfaW9hcyBzdXBwb3J0IGZvciBwaHlz
aWNhbCBWRklPDQo+IGRldmljZXMNCj4gOWQzNjhmNzI0N2M3IHZmaW86IFJlY29yZCBkZXZpZCBp
biB2ZmlvX2RldmljZV9maWxlDQo+IDY4M2FmMGE0NzFlMSB2ZmlvLWlvbW11ZmQ6IFNwbGl0IHRo
ZSBjb21wYXRfaW9hcyBhdHRhY2ggb3V0IGZyb20NCj4gdmZpb19pb21tdWZkX2JpbmQoKQ0KPiAz
MmEyZTdkZTFkNTMgdmZpby1pb21tdWZkOiBTcGxpdCB0aGUgbm8taW9tbXUgc3VwcG9ydCBvdXQg
ZnJvbQ0KPiB2ZmlvX2lvbW11ZmRfYmluZCgpDQo+IDhhMWMwNDIzNzlmNSB2ZmlvOiBNYWtlIHZm
aW9fZGV2aWNlX2ZpcnN0X29wZW4oKSB0byBhY2NlcHQgTlVMTCBpb21tdWZkDQo+IGZvciBub2lv
bW11DQo+IGZjNmUwZWQyYWE0NCB2ZmlvOiBNYWtlIHZmaW9fZGV2aWNlX29wZW4oKSBzaW5nbGUg
b3BlbiBmb3IgZGV2aWNlIGNkZXYNCj4gcGF0aA0KPiAzZjY4MjFkNTA3YTQgdmZpbzogQWRkIGNk
ZXZfZGV2aWNlX29wZW5fY250IHRvIHZmaW9fZ3JvdXANCj4gODk2Y2RlNDBhMDE2IHZmaW86IEJs
b2NrIGRldmljZSBhY2Nlc3MgdmlhIGRldmljZSBmZCB1bnRpbCBkZXZpY2UgaXMgb3BlbmVkDQo+
IGY0MjJjNDIxNmExOSB2ZmlvOiBQYXNzIHN0cnVjdCB2ZmlvX2RldmljZV9maWxlICogdG8gdmZp
b19kZXZpY2Vfb3Blbi9jbG9zZSgpDQo+IGIxODdmOTk4MGZlZCBrdm0vdmZpbzogQWNjZXB0IHZm
aW8gZGV2aWNlIGZpbGUgZnJvbSB1c2Vyc3BhY2UNCj4gNzIxZTJlNjBmZjU0IGt2bS92ZmlvOiBS
ZW5hbWUga3ZtX3ZmaW9fZ3JvdXAgdG8gcHJlcGFyZSBmb3IgYWNjZXB0aW5nDQo+IHZmaW8gZGV2
aWNlIGZkDQo+IDg5OTNjNGM3NWMyMCB2ZmlvOiBBY2NlcHQgdmZpbyBkZXZpY2UgZmlsZSBpbiB0
aGUgS1ZNIGZhY2luZyBrQVBJDQo+IGE5MmM0NWFlMGNlNiB2ZmlvOiBSZW1vdmUgdmZpb19maWxl
X2lzX2dyb3VwKCkNCj4gZmI1ODZmNzgzOTM0IHZmaW86IFJlZmluZSB2ZmlvIGZpbGUga0FQSXMg
Zm9yIEtWTQ0KPiA1MDY5NGFmNmYzYzAgdmZpbzogQWxsb2NhdGUgcGVyIGRldmljZSBmaWxlIHN0
cnVjdHVyZQ0KPiBkZjIxYzA3MzdlZWYgY292ZXItbGV0dGVyOiBNYWtlIHZmaW8tcGNpIGhvdCBy
ZXNldCBwcmVwYXJlZCBmb3IgdmZpbyBkZXZpY2UNCj4gY2Rldg0KPiA1YzI1Yzg3NGQ3ZTAgdmZp
by9wY2k6IEFjY2VwdCBkZXZpY2UgZmQgaW4gVkZJT19ERVZJQ0VfUENJX0hPVF9SRVNFVA0KPiBp
b2N0bA0KPiA3YzMwY2U4YjU0ZGIgdmZpbzogQWNjcGV0IGRldmljZSBmaWxlIGZyb20gdmZpbyBQ
Q0kgaG90IHJlc2V0IHBhdGgNCj4gZTMyMDkzNDJkYjQ0IHZmaW86IFJlZmluZSB2ZmlvIGZpbGUg
a0FQSXMgZm9yIHZmaW8gUENJIGhvdCByZXNldA0KPiA4MzU0ZmQ3OTk0NGUgdmZpby9wY2k6IFJl
bmFtZSB0aGUgaGVscGVycyBhbmQgZGF0YSBpbiBob3QgcmVzZXQgcGF0aCB0bw0KPiBhY2NlcHQg
ZGV2aWNlIGZkDQo+IDU0Mzg3ZWZiODU4YyB2ZmlvL3BjaTogQWxsb3cgcGFzc2luZyB6ZXJvLWxl
bmd0aCBmZCBhcnJheSBpbg0KPiBWRklPX0RFVklDRV9QQ0lfSE9UX1JFU0VUDQo+IGNkOTNmZmI2
MmM1MSB2ZmlvL3BjaTogT25seSBuZWVkIHRvIGNoZWNrIG9wZW5lZCBkZXZpY2VzIGluIHRoZSBk
ZXZfc2V0DQo+IGZvciBob3QgcmVzZXQNCj4gMmE2ZmQ3MjMxY2JmIHZmaW8vcGNpOiBVcGRhdGUg
Y29tbWVudCBhcm91bmQgZ3JvdXBfZmQgZ2V0IGluDQo+IHZmaW9fcGNpX2lvY3RsX3BjaV9ob3Rf
cmVzZXQoKQ0KPiA0ODBhYmVhNTk2MWUgY292ZXItbGV0dGVyOiB2ZmlvOiBNYWtlIGVtdWxhdGVk
IGRldmljZXMgcHJlcGFyZWQgZm9yIHZmaW8NCj4gZGV2aWNlIGNkZXYNCj4gNDZiNmQxYWUxNzU0
IHZmaW86IENoZWNrIHRoZSBwcmVzZW5jZSBmb3IgaW9tbXVmZCBjYWxsYmFja3MgaW4NCj4gX192
ZmlvX3JlZ2lzdGVyX2RldigpDQo+IDYwNjRiOWY4MTgxNyBTYW1wbGVzL21kZXY6IFVzZXMgdGhl
IHZmaW8gZW11bGF0ZWQgaW9tbXVmZCBvcHMgc2V0IGluDQo+IHRoZSBtZGV2IHNhbXBsZSBkcml2
ZXJzDQo+IGMyMDg1MmFmNzI5MSB2ZmlvLWlvbW11ZmQ6IE1ha2UgdmZpb19pb21tdWZkX2VtdWxh
dGVkX2JpbmQoKSByZXR1cm4NCj4gaW9tbXVmZF9hY2Nlc3MgSUQNCj4gMzQwNTg2NWIwYjNmIHZm
aW8taW9tbXVmZDogTm8gbmVlZCB0byByZWNvcmQgaW9tbXVmZF9jdHggaW4gdmZpb19kZXZpY2UN
Cj4gWypdIDA3N2IwOWJiODMzMiBpb21tdWZkL2RldmljZTogRG8gaW9tbXVmZF9jdHhfZ2V0KCkg
YXQgdGhlIHRvcCBvZg0KPiBpb21tdWZkX2FjY2Vzc19jcmVhdGUoKQ0KPiBbMV0gMzRmYmE3NTA5
NDI5IGlvbW11ZmQ6IENyZWF0ZSBhY2Nlc3MgaW4gdmZpb19pb21tdWZkX2VtdWxhdGVkX2JpbmQo
KQ0KPiBhNWQ4YWM0NzU1NGYgZG9jczoga3ZtOiB2ZmlvOiBSZXF1aXJlIGNhbGwgS1ZNX0RFVl9W
RklPX0dST1VQX0FERA0KPiBiZWZvcmUgVkZJT19HUk9VUF9HRVRfREVWSUNFX0ZEDQo=
