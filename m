Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 675EE72C30B
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 13:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230486AbjFLLi1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 07:38:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234589AbjFLLiE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 07:38:04 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D473C7DB9;
        Mon, 12 Jun 2023 04:23:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686569003; x=1718105003;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=hRkfFvdvHsvk9GnrMGMBb3enRbB4F3/Cxiy195OaLKM=;
  b=ONy4naVcjIBWXYAKDCNUtNSvCjCySaXvszHR8PIexmiUNFn9w2RCbmqs
   7Q70VHomCeOCVfKXHzC551WPxZG+GMSfHADqfeo7zJa1m/kniq76EmhCC
   l2tZ2YwCTR+Y8vUg3+8PEwmCmsrRNsCCfcf4MTYkts13JbkUcXseFzRSW
   61ED6Q+DKQYBWkJL/bOD14rXt/f5MSBkI6ZUYHFBeTJbR7PpsLXmCtIQ3
   p3JQ72dSgCmzNjKLb9FuVwQ1+//GSsgPBCDUfWJdX4F4yajeLd73C2t1X
   xeQLu3gc0zUQsNYz4/ZAP0zr4BJ3jnbrv7xeF2EvgOnKF9AKYto2YlkYv
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10738"; a="347661838"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="347661838"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2023 04:22:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10738"; a="855584738"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="855584738"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP; 12 Jun 2023 04:22:00 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 12 Jun 2023 04:21:59 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 12 Jun 2023 04:21:59 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.102)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 12 Jun 2023 04:21:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GuY9t4CifR2jHu2Wo2Vqvt0IOoTp9kDhIq6CQVAi86CpYLg1X0mljrmKetDEd37AqMHssRFyvwEGBRlvsQQD/g6oyn7k9eTBNoVuYRWLQJ9X/PvSruqOarkG8/qprW7H/cOQ7uP3mhAbnUiFJmHL5Ub9LZCChvRPFrvlYpDcDE1ETXY5uLJsjOpNr/2hcKDODcvrtjWvCV8+AeeVi5UHJH1WlE/NoWSiFdOZtVqb9nGZtGlLjOgu+TmP5JFmnzkowkpxpQtXjoq+b3JpI8skRCRHvB8QgLASHx7jK6n4Vv/Zizg/jQJilEteTvGahvgue8vcVfmezhduVlVBrodd6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hRkfFvdvHsvk9GnrMGMBb3enRbB4F3/Cxiy195OaLKM=;
 b=fE8eP0NOoSyqA+7FDbDmHcmyGwMUSvhNtGpoRtzLJiJiAHJcejOfIugrSChc5ZpsVPu9fMxqaLFX58xjXfF2by3oo51KOwnDFV/is605WI94dGIhcApQ20gnFMQjvFQoRFmp8441Qb5YJfD3yGMcM/tVThkge3/s9K0K4p8sGusf8A89S6uLodl2RZO7ppI1KmA0yNBml7vsnQ/8MUmvRfKIHjkqwPWtgdFNYXFbLCRBXLRr6XzZAvm7Ei0ICX9H7mWdeefq3A38+kxkZuwcF90ByAUoTaq2/XCQVzwhsiDitvXXokOKbpHnldZnGcIzc+20PzyESQSqoMdNjdk2EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA1PR11MB5873.namprd11.prod.outlook.com (2603:10b6:806:228::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.44; Mon, 12 Jun
 2023 11:21:55 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6455.043; Mon, 12 Jun 2023
 11:21:55 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v11 07/20] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Thread-Topic: [PATCH v11 07/20] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Thread-Index: AQHZlu+wNwpF26yA2UWLC9EXmgAK/K9/eecAgAC1FACAAMGPgIAGIcSA
Date:   Mon, 12 Jun 2023 11:21:55 +0000
Message-ID: <6db6e4fc876442715723b9c2f8f0d374f9343c76.camel@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
         <21b3a45cb73b4e1917c1eba75b7769781a15aa14.1685887183.git.kai.huang@intel.com>
         <e7c21694-d31b-4dbe-f75b-5a7c0127f5c8@intel.com>
         <963deb7f6bcadbf2848ef54540ba1758b43731d6.camel@intel.com>
         <d2b3bc5e-1371-0c50-8ecb-64fc70917d42@intel.com>
In-Reply-To: <d2b3bc5e-1371-0c50-8ecb-64fc70917d42@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA1PR11MB5873:EE_
x-ms-office365-filtering-correlation-id: 3b06ad9e-454b-4a7d-62e7-08db6b373a8d
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZbPbNgK51jl7Hl8IIN97OgSbimc86+YwslcjQhTPOjUgZt1r9jJEqwv4vpdC9on8sIxIUY8CPPfcTtje/WHqQHJtUPjVIcFjJ5KquJf9CE1ULYGqtHfgsYw/okX97n0F1KDpj42gnlqOKoQT2E92KzKrHXQS2ROiMbjxXCSv2bxvyKCa7s5coa81RCc5qB/SSb6GiCiByYFdEvA7j5IYEJZD18AVxyw7u66cvyH7NoPefyBVH4MT1raqpY7d7yH6i8wbS2j1lVeIPDjukYO86uCV3GMYUOb4Z+tCnvPAMlbeZEOd7lmzVJb50NlXxIqjbBGW38P3Z02G2rjPpF/C5M6I2LxZUlV3mhdw1QhsGSVdyk+3vFClAQrxUkKWzxbNR0+X6e9rTGmb8w1R2va1LjHw01WGnmHrOFZhkcPSaQRj5fUmDrShWsjVQtYlgc6iQ8jnp6EeAaAqo1xKc0059twHnibqbq2/Oj7st1VIzLfxguI96qBGOL6N6ghVc0M+l/bLiBOcR/NLBzyvrs8yGdgmkFOanj/UMGGXZIPSTOhwqOo00VjmPIl7nBY70U87GYMcIKyMsxTgS0us0u4VhsCwS4lNXts8GEjTHFjAWJL264HldewnKgOwk2yD+O9/
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(366004)(346002)(136003)(396003)(451199021)(83380400001)(26005)(53546011)(6512007)(6506007)(2616005)(316002)(41300700001)(82960400001)(38100700002)(6486002)(186003)(86362001)(54906003)(110136005)(71200400001)(38070700005)(2906002)(36756003)(5660300002)(8936002)(64756008)(8676002)(66946007)(66556008)(66446008)(122000001)(66476007)(4326008)(76116006)(91956017)(478600001)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VzRZK21IeE5vcTU0RFI2c2twVSt1N2RQSUtmeDJERG1QbDFxTDBzRkRWWDJk?=
 =?utf-8?B?OHU1NGFSOEFOeXU1SDBIVDd3ZlVhS1k0dW1sYmRYb1R2MDAyV2MxRGdXV0tq?=
 =?utf-8?B?ZVp1T0x4Ri9Cb2F2cXR5TXJjSVJHcWhLeDFzNHdxendMSjVEY0p2b25kQVgz?=
 =?utf-8?B?RXRoTkI1YVlIRi9SYThDZmN6UWtoZVZ4NGpVRkVHMGtWZ0svV1g3ZUliVWhZ?=
 =?utf-8?B?NUM4QmdZSjR5Y2JqZER1MW5LWUd4dmQ4M2J6UERrbUNMMWJybzhYUnZTS3VC?=
 =?utf-8?B?dkRROTRTZTljZjdCNCs1RU16dVpOSk9ycDJLcXRWdzlrb3UrNStYUWdlZEVw?=
 =?utf-8?B?UjJMMVdaVHhMOWNvRERLbEUvY0NYeXVldzdTelZUZlpqWHRMaG1PMzZQQWxx?=
 =?utf-8?B?VVM4ci9RWHZIS1p2K3J0Vnd4NWJMQnlxSi8xZFZEWUhabVA2Q3BFaWU0cC9I?=
 =?utf-8?B?MHZyV215Rng3Q0E0OFBXUE91ZHdnbHA5RXc4OW9UUTRvV3BnSVlTWCtNYXlY?=
 =?utf-8?B?MlI4Y2lJS3R2NHBPR2xudWFXNVl2UDZnSHY2VkUrWCtvUlhRNUg4Z3ZnM3Ni?=
 =?utf-8?B?aVFiODFaSFJpVTdQc29JenlNaExRRkJKdlJNOXVqSzNWOTY2Z3lTZHpocXFF?=
 =?utf-8?B?cUNwcXhQelF1UVFEUlVxcForTnBiM2FxN1B6YzVwMStSejl1ek9jUm5rWWsx?=
 =?utf-8?B?UWhpMUQ5dHVyeVNhQXI4ejhGV3RIL3d2b01NN0V2WkVIN2pjSzcvQkppQ2g4?=
 =?utf-8?B?bmNRSENDTE4vaFNwTnYyaWRRT0hnWkM2MHJlV1BwYzZFaXM3c2Jsa2dTcDRP?=
 =?utf-8?B?Z3UyOGx6QUt4T0dXZW5EWncyU0tCR2c2dmk3VURuRXhSYUlJKzhGZm1lSkor?=
 =?utf-8?B?eCtrZGZqaVA5TVBROXJ0RkIxcERQT1FJYjZ6K3JXV3JOaXVHVmd4Qy91SjBD?=
 =?utf-8?B?b2U0cDczQjVMaEZwTkpvaFhMcW54bDNwZEhNT3pqb1V3MCswNXhyQmE2dWRo?=
 =?utf-8?B?b3VDTHVHcXo2dmtiaU9OUDMyOEREVUNEaWtCRkpaRHVRME9iNUtOV1VPOW9a?=
 =?utf-8?B?N21rSnZyY3dwTTA5VXdEdXVhSXJ0RDVSOGtHTVlVMWM1ZExSWE0wTkJ0V215?=
 =?utf-8?B?djNEcHVWK2E4TzlNZGgwdmd6VlBaRmR4RWNNUzBCUzQzL2psSG9mODJxcmQ0?=
 =?utf-8?B?SE1PTnJackRXTnZRMVVQdDBsNmE4Nm5nbTc5K0VPMi9oVTVOUk9CK0k1U3pw?=
 =?utf-8?B?ZjVILzZNUFlSQU9GUDRNZEhCVk05U2VzQzlLWVZDdXFkOTFuaHF5WGRyck9R?=
 =?utf-8?B?bU1SKzlTc3VERlpqeTJOU3h3RWo3dkkwenZZRDlmU1VpTkdtNGVsYWlxaDNM?=
 =?utf-8?B?eDlxZEpDdHA0d3dIM0hSL0p0b3U0clJjSGtsaSswNk81b3VYMFJDMTdaUURL?=
 =?utf-8?B?RUM5YUExWDV5eFc5ZXJpVjlGYWdETnJVMHNKenpOTFYwckM2Mmo1WWhSNzV6?=
 =?utf-8?B?UDF0UlZScEQ4dFltZEFxMVFub3hsZ0hsVEQ0U1lrQ0x1Sy9Heko3eDQ3Nm9W?=
 =?utf-8?B?OXM3MldLeFA3ZDFZVTdHbzVmTUtjR1c1K1NsVDNhNHBWZnRQZGNWeUorNTJE?=
 =?utf-8?B?a1JHM3Z6bC9aZi91cDVzLy92Qmp3YTVHZGRKMkxFZTVSL2Rzd2xhbzVyUkow?=
 =?utf-8?B?ZGpBZ3pJU1FkZXo2bW93OXBaR2JzWjZ3YWl6T2h1NlBwK0hzcnIySFdDYktF?=
 =?utf-8?B?dnZrSWU1Vm45aGpJT0hteUlGUnBMd1ZWN2hhN2llQWh6NWowLzNleDVBWVB3?=
 =?utf-8?B?cnRUUzE4UWlxbkhVYUZ0MC9VUHdKalB3VUM0RE45UWh5SGhodWZCZktobDMw?=
 =?utf-8?B?SVl2STBsUjFLK2JXMEpxZExISWRSSTlXRU9UMWcxcSt3dCtsOHNQN1dkdWhU?=
 =?utf-8?B?enY0cTJwaFRpWnRVb3dGM2l1QThwd3FFZG8xNGxodC9iREhKNTg5UmU0ZUgv?=
 =?utf-8?B?dFhjcDU3eXlOTGR1NEpBN2lhemYyWHIwQm14c1Y2eTFUd2xtT3k1YlhNTzBq?=
 =?utf-8?B?c1FVb1dWQ3pvR21wOXdnMnBUMjFhb0txUk93YzNIMjY3NnBETXlKa3IzeDJN?=
 =?utf-8?B?YUE3cm1qNU9SZFRjcndNNU5seGpqdmt0RXdrRXdkZnM4cWlzUElIY0xrWGZj?=
 =?utf-8?B?Smc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C80C2694C92F994D87E3EC71DC7F5367@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b06ad9e-454b-4a7d-62e7-08db6b373a8d
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2023 11:21:55.2360
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jyTN0V0PQriDqdI3EyCTgcOolBlAAQlanftb75OjaO9rnBNyKuMq3Nrzs1XI4cg+6Btj0MlyWp0VtRkyTgC7hQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5873
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIzLTA2LTA4IGF0IDA2OjQzIC0wNzAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gNi83LzIzIDE5OjEwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+IE9uIFdlZCwgMjAyMy0wNi0w
NyBhdCAwODoyMiAtMDcwMCwgRGF2ZSBIYW5zZW4gd3JvdGU6DQo+ID4gPiBPbiA2LzQvMjMgMDc6
MjcsIEthaSBIdWFuZyB3cm90ZToNCj4gPiA+IC4uLg0KPiA+ID4gPiArc3RhdGljIGludCB0cnlf
aW5pdF9tb2R1bGVfZ2xvYmFsKHZvaWQpDQo+ID4gPiA+ICt7DQo+ID4gPiA+ICsgICB1bnNpZ25l
ZCBsb25nIGZsYWdzOw0KPiA+ID4gPiArICAgaW50IHJldDsNCj4gPiA+ID4gKw0KPiA+ID4gPiAr
ICAgLyoNCj4gPiA+ID4gKyAgICAqIFRoZSBURFggbW9kdWxlIGdsb2JhbCBpbml0aWFsaXphdGlv
biBvbmx5IG5lZWRzIHRvIGJlIGRvbmUNCj4gPiA+ID4gKyAgICAqIG9uY2Ugb24gYW55IGNwdS4N
Cj4gPiA+ID4gKyAgICAqLw0KPiA+ID4gPiArICAgcmF3X3NwaW5fbG9ja19pcnFzYXZlKCZ0ZHhf
Z2xvYmFsX2luaXRfbG9jaywgZmxhZ3MpOw0KPiA+ID4gDQo+ID4gPiBXaHkgaXMgdGhpcyAicmF3
XyI/DQo+ID4gPiANCj4gPiA+IFRoZXJlJ3MgemVybyBtZW50aW9uIG9mIGl0IGFueXdoZXJlLg0K
PiA+IA0KPiA+IElzYWt1IHBvaW50ZWQgb3V0IHRoZSBub3JtYWwgc3BpbmxvY2tfdCBpcyBjb252
ZXJ0ZWQgdG8gc2xlZXBpbmcgbG9jayBmb3INCj4gPiBQUkVFTVBUX1JUIGtlcm5lbC4gIEtWTSBj
YWxscyB0aGlzIHdpdGggSVJRIGRpc2FibGVkLCB0aHVzIHJlcXVpcmVzIGEgbm9uLQ0KPiA+IHNs
ZWVwaW5nIGxvY2suDQo+ID4gDQo+ID4gSG93IGFib3V0IGFkZGluZyBiZWxvdyBjb21tZW50IGhl
cmU/DQo+ID4gDQo+ID4gICAgICAgICAvKg0KPiA+ICAgICAgICAgICogTm9ybWFsIHNwaW5sb2Nr
X3QgaXMgY29udmVydGVkIHRvIHNsZWVwaW5nIGxvY2sgaW4gUFJFRU1QVF9SVA0KPiA+ICAgICAg
ICAgICoga2VybmVsLiAgVXNlIHJhd19zcGlubG9ja190IGluc3RlYWQgc28gdGhpcyBmdW5jdGlv
biBjYW4gYmUgY2FsbGVkDQo+ID4gICAgICAgICAgKiBldmVuIHdoZW4gSVJRIGlzIGRpc2FibGVk
IGluIGFueSBrZXJuZWwgY29uZmlndXJhdGlvbi4NCj4gPiAgICAgICAgICAqLw0KPiANCj4gR28g
bG9vayBhdCAqRVZFUlkqICpPVEhFUiogcmF3X3NwaW5sb2NrX3QgaW4gdGhlIGtlcm5lbC4gIERv
IGFueSBvZiB0aGVtDQo+IHNheSB0aGlzPw0KPiANCj4gQ29tbWVudCB0aGUgZnVuY3Rpb24sIHNh
eSB0aGF0IGl0J3MgYWx3YXlzIGNhbGxlZCB3aXRoIGludGVycnVwdHMgYW5kDQo+IHByZWVtcHQg
ZGlzYWJsZWQuICBMZWF2ZXMgaXQgYXQgdGhhdC4gICpNYXliZSogYWRkIG9uIHRoYXQgaXQgbmVl
ZHMgcmF3DQo+IHNwaW5sb2NrcyBiZWNhdXNlIG9mIGl0LiAgQnV0IGRvbid0ICh0cnkgdG8pIGV4
cGxhaW4gdGhlIGJhY2tncm91bmQgb2YNCj4gdGhlIGxvY2sgdHlwZS4NCj4gDQoNClRoYW5rcy4g
IFdpbGwgZG8sIHdpdGggb25lIG1pbm9yOg0KDQpJJ2QgbGlrZSB0byByZXBsYWNlICJpdCdzIGFs
d2F5cyBjYWxsZWQgd2l0aCBpbnRlcnJ1cHRzIGFuZCBwcmVlbXB0IGRpc2FibGVkIg0Kd2l0aCAi
aXQgY2FuIGJlIGNhbGxlZCB3aXRoIGludGVycnVwdHMgZGlzYWJsZWQiLCBiZWNhdXNlIGluIHRo
ZSBmdXR1cmUgbm9uLUtWTQ0KY29kZSBtYXkgY2FsbCB0aGlzIHdoZW4gaW50ZXJydXB0IGlzIGVu
YWJsZWQgYnV0IHByZWVtcHRpb24gaXMgZGlzYWJsZWQuDQoNClsuLi5dDQoNCj4gPiA+ID4gK0VY
UE9SVF9TWU1CT0xfR1BMKHRkeF9jcHVfZW5hYmxlKTsNCj4gPiA+IA0KPiA+ID4gWW91IGRhbmNl
ZCBhcm91bmQgaXQgaW4gdGhlIGNoYW5nZWxvZywgYnV0IHRoZSByZWFzb24gZm9yIHRoZSBleHBv
cnRzIGlzDQo+ID4gPiBub3QgY2xlYXIuDQo+ID4gDQo+ID4gSSdsbCBhZGQgb25lIHNlbnRlbmNl
IHRvIHRoZSBjaGFuZ2Vsb2cgdG8gZXhwbGFpbjoNCj4gPiANCj4gPiAgICAgICAgIEV4cG9ydCBi
b3RoIHRkeF9jcHVfZW5hYmxlKCkgYW5kIHRkeF9lbmFibGUoKSBhcyBLVk0gd2lsbCBiZSB0aGUg
a2VybmVsDQo+ID4gICAgICAgICBjb21wb25lbnQgdG8gdXNlIFREWC4NCj4gDQo+IEludGVsIGRv
ZXNuJ3QgcGF5IG1lIGJ5IHRoZSB3b3JkLiAgRG8geW91IGdldCBwYWlkIHRoYXQgd2F5PyAgSWYg
bm90LA0KPiBwbGVhc2UganVzdCBzYXk6DQo+IA0KPiAJRXhwb3J0IGJvdGggdGR4X2NwdV9lbmFi
bGUoKSBhbmQgdGR4X2VuYWJsZSgpIGZvciBLVk0gdXNlLg0KDQpUaGFua3MhDQo=
