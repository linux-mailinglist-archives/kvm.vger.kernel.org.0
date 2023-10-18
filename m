Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35D6A7CD2A2
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 05:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbjJRDW3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 23:22:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjJRDW1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 23:22:27 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4280FBA;
        Tue, 17 Oct 2023 20:22:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697599345; x=1729135345;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=1h5WKxrRu+VGHzulXEfjVEdcEsuLhEg+pREf72EQ7eQ=;
  b=i3EShie4PDi6koJHgBNxxiH7DLavTMq+nCna5x1HCKvzjg2oyD8+k0Wf
   A0YrrejCfqXUOdaQVnVHSBg70X1YsajbCeBpqm/B31VGLBaMWct/CLPBY
   6P32V8Sbs4nLJC2K5gr8eMqsTYPKV5wL30eJ5ac3m4wD/hD/RTHhIOgjj
   M+psNSNSZr4mEi/vJvK7WTnHi9TutfWIrbZz/kZj6BNdZ1RmFpjLo0xbU
   Ub3zw8V0ibADuyYqMvHTXs75CTa7ANgA9JtpBGJzaqb+PC49ToDlTlqss
   u/jGxa8TNYgisyLkzUr1IdnIHDwisQSzDhm6NqRwJjya74wK5EwyxOYST
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10866"; a="366183876"
X-IronPort-AV: E=Sophos;i="6.03,234,1694761200"; 
   d="scan'208";a="366183876"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2023 20:22:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10866"; a="732974486"
X-IronPort-AV: E=Sophos;i="6.03,234,1694761200"; 
   d="scan'208";a="732974486"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 Oct 2023 20:22:24 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Tue, 17 Oct 2023 20:22:24 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Tue, 17 Oct 2023 20:22:24 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Tue, 17 Oct 2023 20:22:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BVpYi/s/8ypNNqrFt8eXC1Iu3VvDTuIv3VnUJnhmmkSjQ1aSuga4B0vOSlS/aWGvVGml2FoDZ81JQSIYC4z2M9hWhTC/HDreKT+I/8sRz19JjOSw7WVivBfT7IGic7VNGIYR8Zm2ZY006ZLv6MxYSy6j6Z7/tSgnsU+9VV2mV4y8GXtNFfHYNJVROwz5qq3HLZ+GkvaDFXvDy/3McQnTqwEOP+n62fpsmGsIthaVLfSXBvaOva9TKM74LwoWyQq63KjLiLgW+nosKuATL0q4qrYeEP8jNa92MMGYUbRYMCmjVQdDGNsnawnB1LG26FNsOygF9RDgxw49BszosaJAmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1h5WKxrRu+VGHzulXEfjVEdcEsuLhEg+pREf72EQ7eQ=;
 b=Z5CKFnMJHM1vGktZUkbdx4vesuQ++Ws7SR0Gc74spJxZ7ka9cuDHWn1hQflBkgxce6mrAbSdUj+dioekaJPUcJYN665RDVHZO5LVVimC0VpsowTekYt1kHzNyUgo30/ZnSXuFEux3P9Z1r47d7KQv2EnQEF/VElt2WLCWdJ3fFk+PW0M9NdWIIB4+R9ax3qi4HqQenSj23ZX9OkIG8UQHf7ZusOGSrdwW1rK3UlIdO8SPsBFm/JKQNvb+9oeL3vjWCFzTlVHihaWv2C0USEjoJL/Lfro91b2SNnV8mhfKd8B7mWfjtQhvfwuJf3zArHq0p8tcxQNHkxXYvJ5qpFhdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS0PR11MB7959.namprd11.prod.outlook.com (2603:10b6:8:fd::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6886.36; Wed, 18 Oct 2023 03:22:21 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f5cb:a40b:539a:2527]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f5cb:a40b:539a:2527%6]) with mapi id 15.20.6886.034; Wed, 18 Oct 2023
 03:22:20 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "rafael@kernel.org" <rafael@kernel.org>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v14 21/23] x86/virt/tdx: Handle TDX interaction with ACPI
 S3 and deeper states
Thread-Topic: [PATCH v14 21/23] x86/virt/tdx: Handle TDX interaction with ACPI
 S3 and deeper states
Thread-Index: AQHaAOAHZhhRpZBgMkGcIwyiZNScqbBNzo0AgAEURgA=
Date:   Wed, 18 Oct 2023 03:22:20 +0000
Message-ID: <0d5769002692aa5e2ba157b0bd47526dc0b738fb.camel@intel.com>
References: <cover.1697532085.git.kai.huang@intel.com>
         <7daec6d20bf93c2ff87268866d112ee8efd44e01.1697532085.git.kai.huang@intel.com>
         <CAJZ5v0ifJ5G7yOidiADkbwvuttVAVhVx6eSoJqBDeacZiGXZDg@mail.gmail.com>
In-Reply-To: <CAJZ5v0ifJ5G7yOidiADkbwvuttVAVhVx6eSoJqBDeacZiGXZDg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DS0PR11MB7959:EE_
x-ms-office365-filtering-correlation-id: ad5ad6f2-b366-4d0b-ac5e-08dbcf897089
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XDBGkW6vA71KpQqQ67jhfX4wIJKqb6Y3WyOTbJ+NlXF1EvEJSqG389udrGNIE9BMrRy/gHYMaw98Gr66gApnwrgFTHUGeeE6BdOqPn6vdr1Ark3XDxccNclqDVWDWh6NoCsC/KNxxbZoR34J+bo4dshGxIic6Z63QFqrmD7WQc3pVINM7rX6li+mEaBMKfgTkKdeUGOUqt9bO4srq02H8bMaU+2sdCEk8KJi7dZagmqxi2gUgRI0U8BCzz+/TKhuTcHNzhSOT3RCbcploPTXIyaB3V1gSpQLSOdd8pAUgsdBMoPDcwBPEcvp4JcHBxO3o9J13uR7U9FPDPtYBF3Pw6pt2Plm5feoHqLcyY/zky6/8rTNs5kF0ABQTb/7gaLI8Ab2lRFLbzKzp8MuIxER6c9B72NEvOp4xFk06JhEkX6WLXk3iY/epEAxef+ng3gciXjFehGuEUHUyTma98Uod0yixDGKCKsdfNhjJdMLqcJhToHLNUkOmDMb15hv3kY65Dz+boQ8y4TkrY0CoyghPkvmEy4ZGMhdQO8FXO8V2G0/MHk6uaFs0Duf6JfuekdcaTzxNBKUp6oPydxHcBEohwRO5cjZhAn4uuWCyMNDq7LLn60rzhEda30n5BICvTKh
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(39860400002)(136003)(346002)(376002)(366004)(230922051799003)(186009)(64100799003)(1800799009)(451199024)(6512007)(36756003)(66476007)(64756008)(6916009)(66946007)(66556008)(54906003)(66446008)(76116006)(91956017)(38100700002)(86362001)(122000001)(82960400001)(38070700005)(83380400001)(8936002)(2616005)(6506007)(26005)(71200400001)(4326008)(316002)(2906002)(6486002)(478600001)(8676002)(5660300002)(7416002)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VUtGbGdIelpKRFB3V1lKeVJoZzRXdnNGR1BXUzZPYy9tMWRySjhoZHg5b3Jv?=
 =?utf-8?B?ZTJldkdZdS8yR0puRzBsU1V3OFpYRlhhckIvUmZGcXlSWW9qczZ6Rm1FbCth?=
 =?utf-8?B?c1owTEVqUWVzNHlGTk1XSjJ3YndGS29hdHJxbVZ5R2tPeGdmczk0eXg3eGli?=
 =?utf-8?B?T1kzYk5hbDBOUFlMaHVkQ1J1TVkvRUgyWjB2U09FUXNHalZNQ3RjU0hveThm?=
 =?utf-8?B?NFZ3eElPVkRUWDdGRmxwRXRsUGgzSzN0Nm44TnR4RE95ejc3WnBvMk9iY1lY?=
 =?utf-8?B?TGxORE9KQkFjamVvdFNGUzJEUFFlTFBiSmdUTVF2VUhYY3pURStjRVBrV0xt?=
 =?utf-8?B?My9jRkplTE5mZVU4R2NseUZDbGdKNVJpUkN1UmJhNUJmeVdNd3BvRkdORkh5?=
 =?utf-8?B?V0RmUGRoY1EvOHo0WTBzY3BScjhiQjR0OUVLUDVvWWZ4YTROZ1VqeXFFVFg0?=
 =?utf-8?B?ZEZVb0dKQVJTVE1hV3dUNFNCTkErQ2NtWFJCb0QwdVlwNEFySytkUFRzODNq?=
 =?utf-8?B?SXFnTytNVVFVQmxDeXVVK0NuMWZrL1UvMVVianRKZnBpQUFJQWtvRjdvSitB?=
 =?utf-8?B?TEplWTRsanlWanpnbXhPMnJOWk41Uk1xb1BuSnFXaWQwNVdzclJ5T2pYeWZP?=
 =?utf-8?B?ZXRhdXduQUxDTjlWd1FubzBueExpb2RoajNxQXV4anpvR0VVeEJXbmh1akZv?=
 =?utf-8?B?MDg2LzNqbVlyT2t2NXo4YnpoMU9iS0t1WExtT3ZsUHZ1MVdVMDdIcUpNRXo2?=
 =?utf-8?B?cXNXbVczQXZnUG5RcDNDQ25kM0Z4WThFVHEvWmtVdnlRR3FIbE9jREU4MXVl?=
 =?utf-8?B?TEhMVmtUMkZaN3FjSUw4bC85V3V0S2pYQlpGOW9PT2hpbHFMS203ZnVpOHFv?=
 =?utf-8?B?SUozK1ZERHR4cU9qSUhQRVFSVi9SMnY4eGd1akRYSG1OMFViSWNySFhIZ0VL?=
 =?utf-8?B?R2poZ2t3bEZnVG55bnpXT2JuTUtDRkV6bDFIcUZqTlhkTjRQdEVKZmFoZnpk?=
 =?utf-8?B?azZlcTVTZ1ZVazhqT2RWeXQ5YklpTjdGb3BKcVlFZ0VxT0hmN2hHY0kwa0dj?=
 =?utf-8?B?YWVEV1ViQ0hJOXdNM1FXYndxb3F6UzZoUVU5UktoZGhtVEdVTCtqdUR0R1J3?=
 =?utf-8?B?eUVkSHBwdVBqWDM2VnJWWk9oRFlhK1h6WDZRakx2VnE5RVlYdjIxR0NUT1Bt?=
 =?utf-8?B?NENBRHZQOTR6V2hOYXZzbnFnaExmNWNhbjR2Uks5Mzl5ZCs4QWI3WFVRTlVV?=
 =?utf-8?B?a201TE15ZEx2aEgyN2xFRWJuUzdOcW42eGZCdnl3VVFtM2d4T1RiWG9aVmY2?=
 =?utf-8?B?RjRuK2FvTEloRXVoSWVmMzV0ZUgzMjdJUXh0T2lHL1ZEdHZxL3JTZCtRNWNQ?=
 =?utf-8?B?NkVkS2tuS2RuaUNMeE5WYW5VTHQ5MjZuaHM3MXpwUlFncTJFWm02NzQyWDZK?=
 =?utf-8?B?ZSt1b1Nnem9uT2h6YVJrcjlpRmJDSzEvTGcrc2gyT2lScnNzNkJjeVdYSFQx?=
 =?utf-8?B?TWs3d3dxRWJKR211YVFCdEExenh1cG80akgrWnhvQW04VGppUUJid0x2M0Ix?=
 =?utf-8?B?MzJRZ2tocGhPN1ByVVlvZS9tRys3eUYrV3gwRXMzOXB1VkxzOW5QNGVtQkhG?=
 =?utf-8?B?MnN4THFiQlZraWJVckFTZEM1eXc4RzVqMVZ1V3o3bWs5NWJCb3VEY1ZKNEVo?=
 =?utf-8?B?ZXFYZlJ3LzlXRDlkenU4NXIyN0lWSmFJNUZvbDQxdHVRYTdvU0lYT0tuQ0ZW?=
 =?utf-8?B?Znc2OUVBUDBOdkhVT3M0TjNINWFaZzFGVUFUbWRkVUJyTFlTM2Y1b000VjZ0?=
 =?utf-8?B?S1lBRzJpWTVSQmdxVkRFN0kzMEVQT1plS3N1UFVLaDl3a3JaSnZRRVhKaXNE?=
 =?utf-8?B?K24xNnBiYnJKb1Rjd3pzRnRnQm1tM2hFL1BEbmdrUmF6QkZYUHBHTkd3alB0?=
 =?utf-8?B?aEFOL2htc01uUnZyazJCdzNraUg2V2tDUVMwQXJUZkNNc1F4SHpzV2l1QTFz?=
 =?utf-8?B?NzJDbXpSOHRlem1VNkpsYzhCQSt6eTU3OEtkZGZSTmEzWEVtSXFSZHI5VE5q?=
 =?utf-8?B?MzFjZkE3MGJDbm00cUFJN2pEaFR2MUhoclVZWS9aanl6aEJabmtUY1JYZWVn?=
 =?utf-8?B?R0NjY28xT1llOUl3b1Y5cVJUWW5IdFcxbWYyNlMxVTY5SUhucUxzaSswUzRi?=
 =?utf-8?B?Q0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F9D4FC23CCC65245B2E2BF979390A61B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad5ad6f2-b366-4d0b-ac5e-08dbcf897089
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2023 03:22:20.8300
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EXFkfQ3uCWTteww9IpDAc2XsPaLV1YGurcah71foBf2gRFbsulyPPCJD/cTW6QGQHBOh9LPUarM0LRsIzs7IsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7959
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgUmFmYWVsLA0KVGhhbmtzIGZvciBmZWVkYmFjayENCj4gDQoNCg0KPiA+IEBAIC0xNDI3LDYg
KzE0MjksMjIgQEAgc3RhdGljIGludCBfX2luaXQgdGR4X2luaXQodm9pZCkNCj4gPiAgICAgICAg
ICAgICAgICAgcmV0dXJuIC1FTk9ERVY7DQo+ID4gICAgICAgICB9DQo+ID4gDQo+ID4gKyNkZWZp
bmUgSElCRVJOQVRJT05fTVNHICAgICAgICAgICAgICAgIFwNCj4gPiArICAgICAgICJEaXNhYmxl
IFREWCBkdWUgdG8gaGliZXJuYXRpb24gaXMgYXZhaWxhYmxlLiBVc2UgJ25vaGliZXJuYXRlJw0K
Y29tbWFuZCBsaW5lIHRvIGRpc2FibGUgaGliZXJuYXRpb24uIg0KPiANCj4gSSdtIG5vdCBzdXJl
IGlmIHRoaXMgbmV3IHN5bWJvbCBpcyByZWFsbHkgbmVjZXNzYXJ5Lg0KPiANCj4gVGhlIG1lc3Nh
Z2UgY291bGQgYmUgYXMgc2ltcGxlIGFzICJJbml0aWFsaXphdGlvbiBmYWlsZWQ6IEhpYmVybmF0
aW9uDQo+IHN1cHBvcnQgaXMgZW5hYmxlZCIgKGFzc3VtaW5nIGEgcHJvcGVybHkgZGVmaW5lZCBw
cl9mbXQoKSksIGJlY2F1c2UNCj4gdGhhdCBjYXJyaWVzIGVub3VnaCBpbmZvcm1hdGlvbiBhYm91
dCB0aGUgcmVhc29uIGZvciB0aGUgZmFpbHVyZSBJTU8uDQo+IA0KPiBIb3cgdG8gYWRkcmVzcyBp
dCBjYW4gYmUgZG9jdW1lbnRlZCBlbHNld2hlcmUuDQoNCg0KVGhlIGxhc3QgcGF0Y2ggb2YgdGhp
cyBzZXJpZXMgaXMgdGhlIGRvY3VtZW50YXRpb24gcGF0Y2ggdG8gYWRkIFREWCBob3N0LiAgV2UN
CmNhbiBhZGQgYSBzZW50ZW5jZSB0byBzdWdnZXN0IHRoZSB1c2VyIHRvIHVzZSAnbm9oaWJlcm5h
dGUnIGtlcm5lbCBjb21tYW5kIGxpbmUNCndoZW4gb25lIHNlZXMgVERYIGdldHMgZGlzYWJsZWQg
YmVjYXVzZSBvZiBoaWJlcm5hdGlvbiBiZWluZyBhdmFpbGFibGUuDQoNCkJ1dCBpc24ndCBiZXR0
ZXIgdG8ganVzdCBwcm92aWRlIHN1Y2ggaW5mb3JtYXRpb24gdG9nZXRoZXIgaW4gdGhlIGRtZXNn
IHNvIHRoZQ0KdXNlciBjYW4gaW1tZWRpYXRlbHkga25vdyBob3cgdG8gcmVzb2x2ZSB0aGlzIGlz
c3VlP8KgDQoNCklmIHVzZXIgb25seSBzZWVzICIuLi4gZmFpbGVkOiBIaWJlcm5hdGlvbiBzdXBw
b3J0IGlzIGVuYWJsZWQiLCB0aGVuIHRoZSB1c2VyDQp3aWxsIG5lZWQgYWRkaXRpb25hbCBrbm93
bGVkZ2UgdG8ga25vdyB3aGVyZSB0byBsb29rIGZvciB0aGUgc29sdXRpb24gZmlyc3QsIGFuZA0K
b25seSBhZnRlciB0aGF0LCB0aGUgdXNlciBjYW4ga25vdyBob3cgdG8gcmVzb2x2ZSB0aGlzLg0K
DQo+IA0KPiA+ICsgICAgICAgLyoNCj4gPiArICAgICAgICAqIE5vdGUgaGliZXJuYXRpb25fYXZh
aWxhYmxlKCkgY2FuIHZhcnkgd2hlbiBpdCBpcyBjYWxsZWQgYXQNCj4gPiArICAgICAgICAqIHJ1
bnRpbWUgYXMgaXQgY2hlY2tzIHNlY3JldG1lbV9hY3RpdmUoKSBhbmQgY3hsX21lbV9hY3RpdmUo
KQ0KPiA+ICsgICAgICAgICogd2hpY2ggY2FuIGJvdGggdmFyeSBhdCBydW50aW1lLiAgQnV0IGhl
cmUgYXQgZWFybHlfaW5pdCgpIHRoZXkNCj4gPiArICAgICAgICAqIGJvdGggY2Fubm90IHJldHVy
biB0cnVlLCB0aHVzIHdoZW4gaGliZXJuYXRpb25fYXZhaWxhYmxlKCkNCj4gPiArICAgICAgICAq
IHJldHVybnMgZmFsc2UgaGVyZSwgaGliZXJuYXRpb24gaXMgZGlzYWJsZWQgYnkgZWl0aGVyDQo+
ID4gKyAgICAgICAgKiAnbm9oaWJlcm5hdGUnIG9yIExPQ0tET1dOX0hJQkVSTkFUSU9OIHNlY3Vy
aXR5IGxvY2tkb3duLA0KPiA+ICsgICAgICAgICogd2hpY2ggYXJlIGJvdGggcGVybWFuZW50Lg0K
PiA+ICsgICAgICAgICovDQo+IA0KPiBJSVVDLCB0aGUgcm9sZSBvZiB0aGUgY29tbWVudCBpcyB0
byBkb2N1bWVudCB0aGUgZmFjdCB0aGF0IGl0IGlzIE9LIHRvDQo+IHVzZSBoaWJlcmF0aW9uX2F2
YWlsYWJsZSgpIGhlcmUsIGJlY2F1c2UgaXQgY2Fubm90IHJldHVybiAiZmFsc2UiDQo+IGludGVy
bWl0dGVudGx5IGF0IHRoaXMgcG9pbnQsIHNvIEkgd291bGQganVzdCBzYXkgIkF0IHRoaXMgcG9p
bnQsDQo+IGhpYmVybmF0aW9uX2F2YWlsYWJsZSgpIGluZGljYXRlcyB3aGV0aGVyIG9yIG5vdCBo
aWJlcm5hdGlvbiBzdXBwb3J0DQo+IGhhcyBiZWVuIHBlcm1hbmVudGx5IGRpc2FibGVkIiwgd2l0
aG91dCBnb2luZyBpbnRvIGFsbCBvZiB0aGUgZGV0YWlscw0KPiAod2hpY2ggYXJlIGlycmVsZXZh
bnQgSU1PIGFuZCBtYXkgY2hhbmdlIGluIHRoZSBmdXR1cmUpLg0KDQoNCkFncmVlZC4gIFdpbGwg
ZG8uICBUaGFua3MuDQoNCj4gDQo+ID4gKyAgICAgICBpZiAoaGliZXJuYXRpb25fYXZhaWxhYmxl
KCkpIHsNCj4gPiArICAgICAgICAgICAgICAgcHJfZXJyKCJpbml0aWFsaXphdGlvbiBmYWlsZWQ6
ICVzXG4iLCBISUJFUk5BVElPTl9NU0cpOw0KPiA+ICsgICAgICAgICAgICAgICByZXR1cm4gLUVO
T0RFVjsNCj4gPiArICAgICAgIH0NCj4gPiArDQo+ID4gICAgICAgICBlcnIgPSByZWdpc3Rlcl9t
ZW1vcnlfbm90aWZpZXIoJnRkeF9tZW1vcnlfbmIpOw0KPiA+ICAgICAgICAgaWYgKGVycikgew0K
PiA+ICAgICAgICAgICAgICAgICBwcl9lcnIoImluaXRpYWxpemF0aW9uIGZhaWxlZDogcmVnaXN0
ZXJfbWVtb3J5X25vdGlmaWVyKCkNCmZhaWxlZCAoJWQpXG4iLA0KPiA+IEBAIC0xNDQyLDYgKzE0
NjAsMTEgQEAgc3RhdGljIGludCBfX2luaXQgdGR4X2luaXQodm9pZCkNCj4gPiAgICAgICAgICAg
ICAgICAgcmV0dXJuIC1FTk9ERVY7DQo+ID4gICAgICAgICB9DQo+ID4gDQo+ID4gKyNpZmRlZiBD
T05GSUdfQUNQSQ0KPiA+ICsgICAgICAgcHJfaW5mbygiRGlzYWJsZSBBQ1BJIFMzIHN1c3BlbmQu
IFR1cm4gb2ZmIFREWCBpbiB0aGUgQklPUyB0byB1c2UNCkFDUEkgUzMuXG4iKTsNCj4gPiArICAg
ICAgIGFjcGlfc3VzcGVuZF9sb3dsZXZlbCA9IE5VTEw7DQo+ID4gKyNlbmRpZg0KPiANCj4gSXQg
d291bGQgYmUgc29tZXdoYXQgbmljZXIgdG8gaGF2ZSBhIGhlbHBlciBmb3Igc2V0dGluZyB0aGlz
IHBvaW50ZXIuDQo+IA0KDQoNCk9LLiAgQ3VycmVudGx5IFhlbiBQViBkb20wIGFsc28gb3ZlcnJp
ZGVzIHRoZSBhY3BpX3N1c3BlbmRfbG93bGV2ZWwuDQoNCkRvIHlvdSB3YW50IHRoZSBoZWxwZXIg
aW50cm9kdWNlZCBub3cgdG9nZXRoZXIgd2l0aCB0aGlzIHNlcmllcywgb3IgaXQgaXMNCmFjY2Vw
dGFibGUgdG8gaGF2ZSBhIHBhdGNoIGxhdGVyIGFmdGVyIFREWCBnZXRzIG1lcmdlZCB0byBhZGQg
YSBoZWxwZXIgYW5kDQpjaGFuZ2UgYm90aCBYZW4gYW5kIFREWCBjb2RlIHRvIHVzZSB0aGUgaGVs
cGVyPw0KDQpBbnl3YXksIEkgc3VwcG9zZSB5b3UgbWVhbiB3ZSBwcm92aWRlIGEgaGVscGVyIGlu
IHRoZSBBQ1BJIGNvZGUsIGFuZCBjYWxsIHRoYXQNCmhlbHBlciBoZXJlIGluIFREWCBjb2RlLg0K
DQpKdXN0IGluIGNhc2UgeW91IHdhbnQgdGhlIGhlbHBlciBub3csIHRoZW4gSSB0aGluayBpdCdz
IGJldHRlciB0byBoYXZlIHR3bw0KcGF0Y2hlcyB0byBkbyBiZWxvdyA/DQoNCiAxKSBBIHBhdGNo
IHRvIGludHJvZHVjZSB0aGUgaGVscGVyLCBhbmQgY2hhbmdlIHRoZSBYZW4gY29kZSB0byB1c2Ug
aXQuDQogMikgVGhlIGN1cnJlbnQgVERYIHBhdGNoIGhlcmUsIGJ1dCBjaGFuZ2UgdG8gdXNlIHRo
ZSBuZXcgaGVscGVyIHRvIHNldCB0aGUNCiAgICBhY3BpX3N1c3BlbmRfbG93bGV2ZWwNCg0KSSBt
YWRlIHRoZSBpbmNyZW1lbnRhbCBkaWZmIHRvIGNvdmVyIGFib3ZlIGJhc2VkIG9uIHRoaXMgcGF0
Y2ggKHNlZSBiZWxvdywNCmNvbXBpbGUgdGVzdGVkIG9ubHkpLiAgQW5kIHRoZSBURFggcGFydCBj
aGFuZ2Ugd2lsbCBiZSBzcGxpdCBvdXQgYXMgbWVudGlvbmVkDQphYm92ZS4NCg0KRG8geW91IGhh
dmUgYW55IGNvbW1lbnRzPw0KDQpkaWZmIC0tZ2l0IGEvYXJjaC94ODYvaW5jbHVkZS9hc20vYWNw
aS5oIGIvYXJjaC94ODYvaW5jbHVkZS9hc20vYWNwaS5oDQppbmRleCBjOGE3ZmMyM2Y2M2MuLmU3
MWJmZjYwZDY0NyAxMDA2NDQNCi0tLSBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL2FjcGkuaA0KKysr
IGIvYXJjaC94ODYvaW5jbHVkZS9hc20vYWNwaS5oDQpAQCAtNjAsOCArNjAsMTAgQEAgc3RhdGlj
IGlubGluZSB2b2lkIGFjcGlfZGlzYWJsZV9wY2kodm9pZCkNCiAgICAgICAgYWNwaV9ub2lycV9z
ZXQoKTsNCiB9DQogDQotLyogTG93LWxldmVsIHN1c3BlbmQgcm91dGluZS4gKi8NCi1leHRlcm4g
aW50ICgqYWNwaV9zdXNwZW5kX2xvd2xldmVsKSh2b2lkKTsNCit0eXBlZGVmIGludCAoKmFjcGlf
c3VzcGVuZF9sb3dsZXZlbF90KSh2b2lkKTsNCisNCisvKiBTZXQgdXAgbG93LWxldmVsIHN1c3Bl
bmQgcm91dGluZS4gKi8NCit2b2lkIGFjcGlfc2V0X3N1c3BlbmRfbG93bGV2ZWwoYWNwaV9zdXNw
ZW5kX2xvd2xldmVsX3QgZnVuYyk7DQogDQogLyogUGh5c2ljYWwgYWRkcmVzcyB0byByZXN1bWUg
YWZ0ZXIgd2FrZXVwICovDQogdW5zaWduZWQgbG9uZyBhY3BpX2dldF93YWtldXBfYWRkcmVzcyh2
b2lkKTsNCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rZXJuZWwvYWNwaS9ib290LmMgYi9hcmNoL3g4
Ni9rZXJuZWwvYWNwaS9ib290LmMNCmluZGV4IDJhMGVhMzg5NTVkZi4uOTViZTM3MTMwNWM2IDEw
MDY0NA0KLS0tIGEvYXJjaC94ODYva2VybmVsL2FjcGkvYm9vdC5jDQorKysgYi9hcmNoL3g4Ni9r
ZXJuZWwvYWNwaS9ib290LmMNCkBAIC03NzksMTEgKzc3OSwxNyBAQCBpbnQgKCpfX2FjcGlfcmVn
aXN0ZXJfZ3NpKShzdHJ1Y3QgZGV2aWNlICpkZXYsIHUzMiBnc2ksDQogdm9pZCAoKl9fYWNwaV91
bnJlZ2lzdGVyX2dzaSkodTMyIGdzaSkgPSBOVUxMOw0KIA0KICNpZmRlZiBDT05GSUdfQUNQSV9T
TEVFUA0KLWludCAoKmFjcGlfc3VzcGVuZF9sb3dsZXZlbCkodm9pZCkgPSB4ODZfYWNwaV9zdXNw
ZW5kX2xvd2xldmVsOw0KK3N0YXRpYyBpbnQgKCphY3BpX3N1c3BlbmRfbG93bGV2ZWwpKHZvaWQp
ID0geDg2X2FjcGlfc3VzcGVuZF9sb3dsZXZlbDsNCiAjZWxzZQ0KLWludCAoKmFjcGlfc3VzcGVu
ZF9sb3dsZXZlbCkodm9pZCk7DQorc3RhdGljIGludCAoKmFjcGlfc3VzcGVuZF9sb3dsZXZlbCko
dm9pZCk7DQogI2VuZGlmDQogDQorLyogVG8gb3ZlcnJpZGUgdGhlIGRlZmF1bHQgYWNwaV9zdXNw
ZW5kX2xvd2xldmVsICovDQordm9pZCBhY3BpX3NldF9zdXNwZW5kX2xvd2xldmVsKGFjcGlfc3Vz
cGVuZF9sb3dsZXZlbF90IGZ1bmMpDQorew0KKyAgICAgICBhY3BpX3N1c3BlbmRfbG93bGV2ZWwg
PSBmdW5jOw0KK30NCisNCiAvKg0KICAqIHN1Y2Nlc3M6IHJldHVybiBJUlEgbnVtYmVyICg+PTAp
DQogICogZmFpbHVyZTogcmV0dXJuIDwgMA0KZGlmZiAtLWdpdCBhL2FyY2gveDg2L3ZpcnQvdm14
L3RkeC90ZHguYyBiL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYw0KaW5kZXggMzhlYzY4MTVh
NDJhLi5jODU4NmJlZTQ2NTAgMTAwNjQ0DQotLS0gYS9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4
LmMNCisrKyBiL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYw0KQEAgLTE1NjUsNyArMTU2NSw3
IEBAIHN0YXRpYyBpbnQgX19pbml0IHRkeF9pbml0KHZvaWQpDQogDQogI2lmZGVmIENPTkZJR19B
Q1BJDQogICAgICAgIHByX2luZm8oIkRpc2FibGUgQUNQSSBTMyBzdXNwZW5kLiBUdXJuIG9mZiBU
RFggaW4gdGhlIEJJT1MgdG8gdXNlIEFDUEkNClMzLlxuIik7DQotICAgICAgIGFjcGlfc3VzcGVu
ZF9sb3dsZXZlbCA9IE5VTEw7DQorICAgICAgIGFjcGlfc2V0X3N1c3BlbmRfbG93bGV2ZWwoTlVM
TCk7DQogI2VuZGlmDQogDQogICAgICAgIC8qDQpkaWZmIC0tZ2l0IGEvaW5jbHVkZS94ZW4vYWNw
aS5oIGIvaW5jbHVkZS94ZW4vYWNwaS5oDQppbmRleCBiMWUxMTg2MzE0NGQuLjgxYTFiNmVlOGZj
MiAxMDA2NDQNCi0tLSBhL2luY2x1ZGUveGVuL2FjcGkuaA0KKysrIGIvaW5jbHVkZS94ZW4vYWNw
aS5oDQpAQCAtNjQsNyArNjQsNyBAQCBzdGF0aWMgaW5saW5lIHZvaWQgeGVuX2FjcGlfc2xlZXBf
cmVnaXN0ZXIodm9pZCkNCiAgICAgICAgICAgICAgICBhY3BpX29zX3NldF9wcmVwYXJlX2V4dGVu
ZGVkX3NsZWVwKA0KICAgICAgICAgICAgICAgICAgICAgICAgJnhlbl9hY3BpX25vdGlmeV9oeXBl
cnZpc29yX2V4dGVuZGVkX3NsZWVwKTsNCiANCi0gICAgICAgICAgICAgICBhY3BpX3N1c3BlbmRf
bG93bGV2ZWwgPSB4ZW5fYWNwaV9zdXNwZW5kX2xvd2xldmVsOw0KKyAgICAgICAgICAgICAgIGFj
cGlfc2V0X3N1c3BlbmRfbG93bGV2ZWwoeGVuX2FjcGlfc3VzcGVuZF9sb3dsZXZlbCk7DQogICAg
ICAgIH0NCiB9DQogI2Vsc2UNCg0KDQo+IA0K
