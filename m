Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA7EF778670
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 06:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232178AbjHKERj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Aug 2023 00:17:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbjHKERh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Aug 2023 00:17:37 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B184F9F;
        Thu, 10 Aug 2023 21:17:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691727456; x=1723263456;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=u2Sv6vQ92njr1cs1tyqwkK9evse9UVX3xbgaDWFkwvw=;
  b=Ws5RFWsF1jW+zQFSIf5x9Z8KYxDFSmbqv5KNh+Wn0l2eqSYdcuAEimZ+
   0/lxct9RyW/ni0CcD1CixhqSz5ZdFyXk8CSpEN1MmF3YNipuWbtK6K0pR
   1tjDiOkA9nKqPb7Fr6baaqRBWjH4VgdT97BGZA9n2KdKsMajR2iGP2eeC
   JQQWHeQXYe9dvaC8mOBtOu6YKGwTWengKqn97kXa2zR32k0dt2fmPyw4g
   kFszhEkTt+ID8s8PMSH+MT62Xoy6EMsuUj9hs6pnU6qBQR3VrzQX6dqAv
   QXuvZiZtKV5UJ7ZJNxsXal+KVIPIXNKIC8VduIUjRCf3Xns7fb+erYOq3
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10798"; a="375301261"
X-IronPort-AV: E=Sophos;i="6.01,164,1684825200"; 
   d="scan'208";a="375301261"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2023 21:17:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10798"; a="762052644"
X-IronPort-AV: E=Sophos;i="6.01,164,1684825200"; 
   d="scan'208";a="762052644"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 10 Aug 2023 21:17:35 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 10 Aug 2023 21:17:34 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 10 Aug 2023 21:17:34 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.43) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 10 Aug 2023 21:17:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hWiyWudi60wMdElWpfpGn2b0JsMSP+rb21tohfm5wMG1R5ltgHWiZy4NH47hyfFuOTkrdLzeeX8C2bmoYnssHnk9Qdoz9L7IIqRDwOsAfV8jRof209kZEx1aBSUR8N1vfkkM9u6Oi/QxQxVA3xgrLhmJxuisrNhNKg9ZJb9cC9Ix04SJv9JqFcZQxSArjduZtuiSfFfg9jFFa0grklzKhzLGCMQrSW2NG/I9C+N+U4mCFTlIr0WxH+D2RsMskZcl18V9NBI6RcYKH4Z2xD6lPG8HA3pxPgKgeely5hPoq5t1dOzPvVQxuuQ3e+4Iu2a10F+35IHDw5wXvLAJy6HHyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u2Sv6vQ92njr1cs1tyqwkK9evse9UVX3xbgaDWFkwvw=;
 b=iG9NX1wHCY+D2RoA/qVUQVKqa2ZBXAXQKPMNnAqSBUPQxGaXhBlYZsynseDYUuVYuG001km8DBA/U2J4UDaebsVYKsW4OMRn5gPBb0Z2+rxUbRKvXGTnrTgCHsn+UOTabj3+2HwCIbqYMkf6lVnEJmvqZMaUKPgQ/da1TpqjzZZiIYNvmmOD8E5fuuQPvg9dRqTtEMs4fAu83xR8Ft+mwN4QnJwY3L1OlqFjc35OvN2mBz0VMtRecd7Ngskxq4pOVa4SO4SQ6keZAecPZL7RsfMKRn1qLld6VkfB1xT8iHITc9H4COgERp/UBTWEzf1w+LjvjB4ZBlOn8wah+HGUbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH7PR11MB7074.namprd11.prod.outlook.com (2603:10b6:510:20d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.30; Fri, 11 Aug
 2023 04:17:27 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed%4]) with mapi id 15.20.6652.029; Fri, 11 Aug 2023
 04:17:27 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Baolu Lu <baolu.lu@linux.intel.com>, Jason Gunthorpe <jgg@ziepe.ca>
CC:     Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        "Robin Murphy" <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 03/12] iommu: Remove unrecoverable fault data
Thread-Topic: [PATCH v2 03/12] iommu: Remove unrecoverable fault data
Thread-Index: AQHZwE5XwmTCizFL9kGoEloX5eLFx6/iRSsAgACemYCAAPAFgIAAjk4AgAAsbkA=
Date:   Fri, 11 Aug 2023 04:17:26 +0000
Message-ID: <BN9PR11MB527652616F6490FA46117D1A8C10A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230727054837.147050-1-baolu.lu@linux.intel.com>
 <20230727054837.147050-4-baolu.lu@linux.intel.com>
 <ZNPF/nA2JdqHMM10@ziepe.ca>
 <28d86414-d684-b468-d0a9-5c429260e081@linux.intel.com>
 <ZNUUYR9WGf475Q4L@ziepe.ca>
 <7694a4ea-4a08-2296-cd3a-593004de8718@linux.intel.com>
In-Reply-To: <7694a4ea-4a08-2296-cd3a-593004de8718@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH7PR11MB7074:EE_
x-ms-office365-filtering-correlation-id: 65ff79e2-fcfb-433f-4b51-08db9a21df17
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XzJnG3XjAQGsEBuGHy0wTMSgzdIRvZBjZoNAajkHQ1pLZbQ14u+kEy8r96Cppxmcy/HkY2/jOCsHDPBKwg4p6T2ZVHYAIAg6Pa5BABFgnMeRIqkcoFWUM2wyqT77VHArrfaoNwam1n+cP1jEZN0sYAf6hpGhmRXa77ghxBqIdXrK0e8Udk/pZGXq/0uMy9kHeRX6GeL/nIGZs3kv4qAimiXObdR1bINwtsryS7LZQy217MMSIg8E7pAQ+VH4xrcjLIShRLPZT7udJKWWisbRLkg51tEXWwtDkj40zKcRgNRuDT+eyEPxVwMxu3odTx5wznxxUIM1lv+QkrZiLyaZqbTldHwy1PRKwoSKdq67Ywt1Z4+00dSX8UJGNsbFSCtqIUhSuP3yEDHRgsx5X0HZslsAXWqWqgTGyHKTss0Amsq8O6Vip1L55ECLOIKucZcmp8oLPIPT7drZxyg+zSFiNvuC09qrEVloF+7wvdGv3jm47p3JkXfICycag564AtT4/KoTQfH7zgV6lpYawvwd841GUoLN5U0I7WTL+3Crvc4LxGDph6n1wi/r7XJ+0ryMP4Sg/AX2ZjnBXj2YaQC4jyrFzsZrQGxLPMyAfG0BZVgzw5tYUDg4KFi9saiDvWhM
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(39860400002)(136003)(366004)(346002)(376002)(451199021)(1800799006)(186006)(478600001)(54906003)(110136005)(38070700005)(6506007)(83380400001)(33656002)(26005)(53546011)(86362001)(82960400001)(38100700002)(122000001)(55016003)(2906002)(9686003)(7696005)(71200400001)(5660300002)(52536014)(64756008)(66556008)(4326008)(66446008)(66476007)(76116006)(66946007)(7416002)(41300700001)(316002)(8676002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VldYU2ZlWE5DUmJhbEVHNGFtN2ZkQlZJcWx6ZU5iaERNcmdWdHZuWW1jRkt4?=
 =?utf-8?B?T3dNNStjV2ZDV3VnNkNwWnNlekt1aUtUUjdrSjdWdDlKMi8zUTE5R3YxNnN1?=
 =?utf-8?B?emlvMmpCc3VKZVFteis3T0FWUHI1RTlPeVN4dUthZ3FsSmZMN2lmM0RrZ3VC?=
 =?utf-8?B?MWJWWlNMM081VGY0LytiNmRWRDNDOUV5SjkzOE9ISnA5Q3BKOHRiaUsrMXFQ?=
 =?utf-8?B?aFhqRE41NlZhdkw5b2lXMHR6QUs1aFNXeDBEYUZIVVpBNW01YTNWeHRLQkxh?=
 =?utf-8?B?OTlESVFsajRJMVN4Z2dBYUhLcWZEYVV2RWtoc0dlNkJoKy9saUNPK1pwQUU3?=
 =?utf-8?B?bmlpOU1ZRCtoMzh1V3IzK2lBU1FKRGpZVUJKTGJZOUh2bEtwclRJQ0RCbjFz?=
 =?utf-8?B?bnpycFAzekZIWEtBTWYwZnRlT2UrQWZtQUZZZWVyVG9HV2hVS1k5VHlOcTBF?=
 =?utf-8?B?UzJTNGpyNGh0STZVcXhKYklYUUhsa2dDTEVQV3J5NE5YYktWdjBWbTRma1JY?=
 =?utf-8?B?WEJBNi84RUEvNDJJa00wTUFYSWh3dEZFdFlsSmZiMVNqbzhKRVN5bDE4L2kx?=
 =?utf-8?B?Ymg0ditIZlZoaTM1enhwY1licHlxaGpwejdvZkxRVGxFME5oSWRlZFFzSnNO?=
 =?utf-8?B?N1ptZ1RpSEhmSWpxY1kvQVA4Z21mUkN1VVVCSkNyUno2MklKZ3I0M3N5QlZz?=
 =?utf-8?B?d082WnhvNmZVeXVjd3NTQy9ENnlzQ3B0ZnJxcTkwQWNGVHM1MFdXK21aaGpt?=
 =?utf-8?B?Y0VleEM0Y1Nwa0VvMjJJZE9zVFREWjJmd0JmN3Vsb2NXcjIrOEQ5eGMwUUl1?=
 =?utf-8?B?TEIrZzIyMUVQbUc1Y3BCSzBvVmRYUnpjYUhzMmpyWDVFUmZJZW1nMGk4NTZl?=
 =?utf-8?B?VkR0L3J2eWxTK3hpdGNWWDRxVzB1TWNic3NwQ2RwRkVReFZSL1RLOElmL05J?=
 =?utf-8?B?UDRRb1Y2QVJTTm9TQkw4OEkrd1VQTjZtSDNoWk51VTJNKy9LbUNiTy81TThP?=
 =?utf-8?B?c3pEcE93L2xZNHRTZVlmSlJ3TnF5V2FISGhGV0wxaUNkNTN6VmluMmFhN2VP?=
 =?utf-8?B?WktmR2s0bU9HNzBFRlUvK0liUjNMcDZDR3l0QjlGNVJZYS9RSmxKai9nREVD?=
 =?utf-8?B?Q3h2VDVuelpma0svMnN1VGlGU3ZIL0RaQUlDM3pjYUVEL1hzTkhVOWNpa3pr?=
 =?utf-8?B?czJSY2lsRFB3bnozT1AwL0J2RXRVRlZudDNJanJnQloxMkxpZFVsWENwNEFy?=
 =?utf-8?B?Sm5NWmV5bXkrUmJtYTI4cWoreXRxVUVKSjFlcmRtb2lVR0xkYjhGOE1wN3gz?=
 =?utf-8?B?MlZMajJHSDhObDZ6UmkxQ0pHNVV5SkxBN0pGVkNxTmRiblFGTElWTXhPQ29I?=
 =?utf-8?B?dEZLMjJ0YkQ3Z1MxaVJldzFONDdEM0dnZXFEbGhLWEFaR1V1RDlSdTBwVXM4?=
 =?utf-8?B?cEVQVDNlSUxHOXdPUjJTRFphM0VZbnBWZUczYlRRVnc0RzlPeUJBK2IyM2FW?=
 =?utf-8?B?M0c3V0wxTzZZYVRlYTkvM2tEK2pReDR0aWlZeEdiMlAwcUpPVDg0bU5vYncx?=
 =?utf-8?B?UnE2Vys4UGxRN01oSmxZdU90UDhUSFJTdTRlRDJac1VNSEhDdE1UK0M5TjQ3?=
 =?utf-8?B?TU5qaVE4M3ZiMk1OeVpJQXMvWDF5MFhtakV0MitTZUsxMnF4dU1VVDZLL0g5?=
 =?utf-8?B?TGhrOEoreHdQMk54L2gzKzVpeXhVU2ZKWWo1TFJwd0hZcDhSMEdJMUtnc1g0?=
 =?utf-8?B?d0tJT3pQVkJkdjZwckpaaER1MTM3V3g3QUt0S1VHNlhjL2RpTUNpS1A4MFdK?=
 =?utf-8?B?RFdsdS9iNytZd29nQUJaV2ZGdUNvN090Q3ZYeDR3MEhDQS9DWTFuT1ROb0lv?=
 =?utf-8?B?OGdneFRlRHhBL201ZmcxYkV2N00rT0hzbXQ2NW1mYndKaTh2Qm1tMHdTRGxx?=
 =?utf-8?B?RUxtNDRNeVE4TDJoKzJvWDR5RGF5d1Q2dGxOaTE1aGp1QzFpUGhWQjIrUEs5?=
 =?utf-8?B?aG9Jb1UvaHNtRWwrSG5tdkhLbkFIdGV5Z1g5RkhBVlI4OUJrTHl0SU9UeFpI?=
 =?utf-8?B?d0NnbXVwaUpYbnVoUmZWMDZ5QXdqOXNqRUUzVkdkQy9BTVFGbFh2Zi9WdU8z?=
 =?utf-8?Q?4ifHHiq7yCT0UzbbhswaBcEa5?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65ff79e2-fcfb-433f-4b51-08db9a21df17
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Aug 2023 04:17:27.0086
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TxbgOw6JksUC9m0QBVLA5nvqNO3nS+gxCaZ6obkwPIF7aK4sIqXltg6x/SPn/YBzc7KzxPhXqa02xWpdfHdWLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7074
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

PiBGcm9tOiBCYW9sdSBMdSA8YmFvbHUubHVAbGludXguaW50ZWwuY29tPg0KPiBTZW50OiBGcmlk
YXksIEF1Z3VzdCAxMSwgMjAyMyA5OjE2IEFNDQo+IA0KPiBPbiAyMDIzLzgvMTEgMDo0NiwgSmFz
b24gR3VudGhvcnBlIHdyb3RlOg0KPiA+IE9uIFRodSwgQXVnIDEwLCAyMDIzIGF0IDEwOjI3OjIx
QU0gKzA4MDAsIEJhb2x1IEx1IHdyb3RlOg0KPiA+PiBPbiAyMDIzLzgvMTAgMDo1OSwgSmFzb24g
R3VudGhvcnBlIHdyb3RlOg0KPiA+Pj4gT24gVGh1LCBKdWwgMjcsIDIwMjMgYXQgMDE6NDg6MjhQ
TSArMDgwMCwgTHUgQmFvbHUgd3JvdGU6DQo+ID4+Pj4gVGhlIHVucmVjb3ZlcmFibGUgZmF1bHQg
ZGF0YSBpcyBub3QgdXNlZCBhbnl3aGVyZS4gUmVtb3ZlIGl0IHRvIGF2b2lkDQo+ID4+Pj4gZGVh
ZCBjb2RlLg0KPiA+Pj4+DQo+ID4+Pj4gU3VnZ2VzdGVkLWJ5OiBLZXZpbiBUaWFuPGtldmluLnRp
YW5AaW50ZWwuY29tPg0KPiA+Pj4+IFNpZ25lZC1vZmYtYnk6IEx1IEJhb2x1PGJhb2x1Lmx1QGxp
bnV4LmludGVsLmNvbT4NCj4gPj4+PiAtLS0NCj4gPj4+PiAgICBpbmNsdWRlL2xpbnV4L2lvbW11
LmggfCA3MCArLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+ID4+
Pj4gICAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCA2OSBkZWxldGlvbnMoLSkNCj4g
Pj4+IERvIHdlIHBsYW4gdG8gYnJpbmcgdGhpcyBiYWNrIGluIHNvbWUgZm9ybT8gQSBkcml2ZXIg
c3BlY2lmaWMgZmF1bHQNCj4gPj4+IHJlcG9ydCB2aWEgaW9tbXVmZD8NCj4gPj4gSSBjYW4gaGFy
ZGx5IHNlZSB0aGUgcG9zc2liaWxpdHkuDQo+ID4+DQo+ID4+IFRoZSBvbmx5IG5lY2Vzc2FyeSBk
bWEgZmF1bHQgbWVzc2FnZXMgYXJlIHRoZSBvZmZlbmRpbmcgYWRkcmVzcyBhbmQgdGhlDQo+ID4+
IHBlcm1pc3Npb25zLiBXaXRoIHRoZXNlLCB0aGUgdXNlciBzcGFjZSBkZXZpY2UgbW9kZWwgc29m
dHdhcmUga25vd3MNCj4gdGhhdA0KPiA+PiAiYSBETUEgZmF1bHQgd2FzIGdlbmVyYXRlZCB3aGVu
IHRoZSBJT01NVSBoYXJkd2FyZSB0cmllZCB0byB0cmFuc2xhdGUNCj4gPj4gdGhlIG9mZmVuZGlu
ZyBhZGRyZXNzIHdpdGggdGhlIGdpdmVuIHBlcm1pc3Npb25zIi4NCj4gPj4NCj4gPj4gQW5kIHRo
ZW4sIHRoZSBkZXZpY2UgbW9kZWwgc29mdHdhcmUgd2lsbCB3YWxrIHRoZSBwYWdlIHRhYmxlIGFu
ZCBmaWd1cmUNCj4gPj4gb3V0IHdoYXQgaXMgbWlzc2VkIGJlZm9yZSBpbmplY3RpbmcgdGhlIHZl
bmRvci1zcGVjaWZpYyBmYXVsdCBtZXNzYWdlcw0KPiA+PiB0byB0aGUgVk0gZ3Vlc3QuDQo+ID4g
QXZvaWRpbmcgd2Fsa2luZyB0aGUgcGFnZSB0YWJsZSBzb3VuZHMgbGlrZSBhIHByZXR0eSBiaWcg
d2luIGlmIHdlDQo+ID4gY291bGQgbWFuYWdlIGl0IGJ5IGZvcndhcmRpbmcgbW9yZSBldmVudCBk
YXRhLi4NCj4gDQo+IEZhaXIgZW5vdWdoLiBXZSBjYW4gZGlzY3VzcyB3aGF0IGtpbmQgb2YgZXh0
cmEgZXZlbnQgZGF0YSBjb3VsZCBiZQ0KPiBpbmNsdWRlZCBsYXRlciB3aGVuIHdlIGhhdmUgcmVh
bCBjb2RlIGZvciBkbWEgZmF1bHQgZm9yd2FyZGluZyBzdXBwb3J0DQo+IGluIGlvbW11ZmQuDQo+
IA0KDQpJJ20gYWZyYWlkIHRoZXJlIG1pZ2h0IGJlIGNhc2VzIHdoZXJlIFZNTSBjYW5ub3QgcmVs
eSBvbiB0aGUgaHcgZXZlbnQNCmRhdGEuIGUuZy4gaWYgdGhlcmUgaXMgYSBtaXNjb25maWd1YXRp
b24gaW4gdmlydHVhbCBjb250ZXh0IGVudHJ5IG9yIHN0ZSB0aGVuDQp2SU9NTVUgbWF5IGRlY2lk
ZSB0byB1bm1hcCBhbmQgbGVhdmUgSU9BUyBlbXB0eSB0byB0cmlnZ2VyDQp1bnJlY292ZXJhYmxl
IGZhdWx0IHdoZW4gYW55IERNQSBjb21lcy4gVGhlbiB1cG9uIG5vdGlmaWNhdGlvbiB2SU9NTVUN
Cm5lZWRzIHRvIGNoZWNrIHZpcnR1YWwgY29udGV4dCBlbnRyeS9zdGUgdG8gZGVjaWRlIHRoZSBy
aWdodCBlcnJvciBjb2RlIHdoZW4NCmluamVjdGluZyB1bnJlY292ZXJhYmxlIGZhdWx0IGludG8g
dGhlIGd1ZXN0LiBIZXJlIHRoZSBodyBldmVudCBkYXRhIHdpbGwgYmUNCmFib3V0IG1pc3Npbmcg
c3RhZ2UtMiBtYXBwaW5nIGhlbmNlIGluY29ycmVjdC4NCg0KYW5kIHRoaXMgaXMgbm90IGEgcGVy
Zm9ybWFuY2UgY3JpdGljYWwgcGF0aC4g8J+Yig0KDQo=
