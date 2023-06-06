Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F6DB723625
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 06:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233408AbjFFETk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 00:19:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbjFFETi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 00:19:38 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4303EFD;
        Mon,  5 Jun 2023 21:19:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686025177; x=1717561177;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=3un43iHWsKeiMn3u1XDBT4C0IkOetLnVF1L8e9fbFo8=;
  b=PH0h31OxqvBXvg2mxNBZoo82pvYlKl4fSV4FRj9+Wvm+A95OpTjtUhhK
   MqprXZv0dWwkzaluiSIDBV1KumABMvBLLLAzqY9kHhpI3DunR22oOyWaZ
   raXhnJtxYBxSqrHSZGpZIHqnynij0n4CjV30MD4pYZuFvsi4nCS+HVbIE
   xh7ftXxyD2ADyRwSZsj0Fmpu2v3qA9U+yPISr22aOZ0wafb1r90Zp6yTM
   FgsFSwJrQYTHGlYvJN8/K7Vg0GCqrmhrnp/5b4p/15ZI7ts+W3oF+qO32
   LbECiycKWXa2ZF6EIwsFcHjAwDsYacwc0zd6o4upjMnmzImOUZZjJWLEG
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="442935831"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="442935831"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 21:19:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="712047921"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="712047921"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP; 05 Jun 2023 21:19:36 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 5 Jun 2023 21:19:36 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 5 Jun 2023 21:19:36 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 5 Jun 2023 21:19:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EPbBvadDsPhDY8L7DbbYbRZ+BTkkmwmosOyz5ul99wX/5EDMjkZ3zUAg+SH6BBDw8FBzbxN8yJLx+QLH0ahB6bKbgJlciYgoozCLHIj9a1sgJlu0mJ+O0XFqtVBZk8tMPc55bkvzbb9gHOkDdiX8Xg/pMldd3sq6otAmyzA8JKcm5s4PWiZfqEJjlpsWWrJ4+BS7/XoEn3DV9y4+SneantOJHiVVxKpx5Dn9O3rxtJEk5EI74U9Z6d01vPZKxyeIHMjokwo2xkvnMRPJUWvu+/fJWiqIbwprVs5JA7xdEe1KK2lK5wu0BWrT1szReF4JgHWIwhdqHXU9TAeE7rDZdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3un43iHWsKeiMn3u1XDBT4C0IkOetLnVF1L8e9fbFo8=;
 b=TPkP/OFx5wCuKoJhMqVrouccGEC2l3jVwGimxEscyOAtsQl5geHdHKYND/b0tffbmKBxGFtt1+1C/NYVs3o0I8uCDSsNeAGyQ7GyY66gEOhvrHNNYK4FJaEz/CXTvXRPFiNPb5zc4IrvKbIK7tzcfS/mqrsVDXuHGOGLqdfz/VyHLwFEyn8LiMb9g7AvOgu+PFJJNMfsL9rG0VS+qQifbOXqio4cE6SymKZcwd0NDL897a2Zci3a3viMuX+M4fS98QBrRBio6i1oPjlyM8BF4f+Kuy1hwVab17o6GE2KB5PoOM+E04a7lidbwstGDhDXCGTLBpi48obo/NMguQEBJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB5983.namprd11.prod.outlook.com (2603:10b6:510:1e2::13)
 by DS0PR11MB8232.namprd11.prod.outlook.com (2603:10b6:8:15d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Tue, 6 Jun
 2023 04:19:33 +0000
Received: from PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::b429:a482:736e:e1ff]) by PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::b429:a482:736e:e1ff%5]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 04:19:33 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC:     "Christopherson,, Sean" <seanjc@google.com>,
        "Chen, Bo2" <chen.bo@intel.com>, "Shahar, Sagi" <sagis@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "zhi.wang.linux@gmail.com" <zhi.wang.linux@gmail.com>
Subject: Re: [PATCH v14 004/113] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Thread-Topic: [PATCH v14 004/113] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Thread-Index: AQHZkeT0wH2MEOTseU2fipMRPmQQrK99OF2A
Date:   Tue, 6 Jun 2023 04:19:33 +0000
Message-ID: <3d8355ae582119486ac7ec129c4ba18d2cdf3ccb.camel@intel.com>
References: <cover.1685333727.git.isaku.yamahata@intel.com>
         <e628e2d235d9b6c00b9bd5d81bb69136b77d13c4.1685333727.git.isaku.yamahata@intel.com>
In-Reply-To: <e628e2d235d9b6c00b9bd5d81bb69136b77d13c4.1685333727.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB5983:EE_|DS0PR11MB8232:EE_
x-ms-office365-filtering-correlation-id: 4f44f129-6695-4bcc-5212-08db66453b41
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 07Qnq68jWTE4/v1bRcV2L73MZk771tZw+9yh9wbk9xAQKekQV284yR0hsiDYeB1w+Cd1TW/bVPB2oNmCyG62BQzmei/womo1BqGQd9zW70hN6O1EK623UqkfFTF55gm+xWWmkaE4OtBA/rYpwbH0wCIcKBKj/rrlOAa+VnTdsGUcheSTrZ8Ht2GEdAsoKdAIcfoJDNcJdsGhCnGQwip9uhNPUrdUJCpgooPH0QtQdFztOmp1VX07GpGkv1fPBLnXHdm28h/UnN2cHxcV7Pz9t38uD2/oj2rj5+vuQ/5RYQLnnnE4PBLvKAnU4OPhvXhb0UXNbqGdRTYan0hgoTHw4iZyADS93ZeiuTDj+hLrOwTcnNHLJ8cquN5wIu2SpjnDGgyPXNy3xsKbFS1sz8QVCuneY/BVjwqHvs+blqtefeFDeXk6n/XxwYDoW+DPxamPlfsZ6asmtwKX5JYO/6Cx0e5a3gWoZDewmf1N9yf5BKzTjuglh5LVn7u9wOTrqrXSQj6nxe6t1AUzBwZHCSd27WAEpl2TJMmI0D8vRfOdAo8BHjpgBiKHj7WoUQloyADeysF95GMymupvc4esaT4VgKxvLNMmwEq4M6PMzNxUVAV+CVvEdTn+GHh6IoQGA9IU
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5983.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(366004)(376002)(396003)(39860400002)(451199021)(54906003)(110136005)(71200400001)(478600001)(82960400001)(8936002)(5660300002)(8676002)(36756003)(38070700005)(2906002)(86362001)(4326008)(66476007)(64756008)(6636002)(66446008)(66556008)(91956017)(76116006)(316002)(66946007)(122000001)(6506007)(38100700002)(41300700001)(2616005)(6512007)(186003)(26005)(83380400001)(6486002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VWNGa3pJdFVpRlIzRU1LUjJpTUEwTGdEUGFuRUtUK2UvMmpucGJlTjhiQit3?=
 =?utf-8?B?WEpjLytJQnV3cXZqRTQ5dTBhNTJJd0FoS0JRR2d3UUIySWF3eGFCL2l4Qlp3?=
 =?utf-8?B?RFZTeWpJNUQ0elc2UEd3OXJkako0RDJ1b29EcTZvb2t2Ky9sVW5ZSEhyamtj?=
 =?utf-8?B?bEV2UERaMVc0UnZCcGNENmhMVDBONjVRSk42Q0Y2eXNrQ0FkZnNIZ3pCNlha?=
 =?utf-8?B?dU1hTUF2NERGUFZ1MncxTmtXeU9uMXdNcjhsT3VzMW1BWnNUR2c1RGhvc3Z0?=
 =?utf-8?B?b1JYWlVHQnNGNDJSd3lROWRUTTdObXR4aStoM05uVHJTY2k3cXdjSWpNUDRI?=
 =?utf-8?B?L0lSVDVmVE5XN1hxSmNveXVyNGtUbC9ZTDYyUHRzc2JIL0dYRG1pa00zeDBJ?=
 =?utf-8?B?aVBYemVqVnFPaFptYnFWS3dlRjFpMVprclRmRHVFamN0ZTJ0eWJkelp4Lyth?=
 =?utf-8?B?bEdQbTdMbHFheGpaR2hBcTJOOWRldUFNREY3eHJlTHdVejNpMHBmaGhzaEVv?=
 =?utf-8?B?bWtBZEZSdk8vVlZJUlFFZndoQ2kwbU5LWVdaRERpZTFxcFNtc3UvSTB6aEVR?=
 =?utf-8?B?YUVrWE1nYzZoaVVrUjA4b2ZVWTcrajBKYk51VXBvVnhUcEVPYTVBK3ZJY1h1?=
 =?utf-8?B?L212bWZzMW8zeVBMR3A3NFUxZXZnME5kRzFyOVY5U1dJWVF1M00zY3prZnRj?=
 =?utf-8?B?Y0o3Z1VBc1hXdzZGSGdKbGg4VTh0R0RCMnJ4NUtPS0FXZUZYYURsOS9LT0hn?=
 =?utf-8?B?Sks4bWNHbktRN0dqaUk5MEhhVG95SUZ3VXRFTEE0VHlUenRLVGI4TTJBSUYz?=
 =?utf-8?B?U3M2Y1JIeXhaSW9ZakxHKzBMOVpsRUZxS0l0NUZrVkdIc0dOZElkZWZuekZu?=
 =?utf-8?B?T096WURqbVd6c20rRk1oOHNCaU1QdDY5eitldTdQMWdTaDRJVTVtWW1UMG43?=
 =?utf-8?B?OTBwa2M2ejQ5YlZESXZvcWp1R01XS0FLUkxMUkt1Tm9naVVDY3J6bGhrMEVH?=
 =?utf-8?B?ZWZmUldwVVRLVHNWZ01uSzN2UWNRZGptSk1lMTMxSFczOVNtNng3OUFQZ2hM?=
 =?utf-8?B?VEpIeDIwRzM5Q2FBWllnaXoxcG0vRVpYOWpjR2R4UkVObVJHSWJHOFpuY28y?=
 =?utf-8?B?V1V5a0puRWJ4LzRQNzI1WWhwZVE4a05xL1h4dll1M1dQak1IVTNmS1hySDN0?=
 =?utf-8?B?KzNXZE8xcTA3SzFZVnJkTnFXQ2c3VjE4VXpERnJOUkVjbUtMbEhwTW1OUkJq?=
 =?utf-8?B?RkQ0OTdVUUhNeFlYSDFGMkxjM0NoNTVDS1FYOU9VaHhUMWdyRWE5QzVqRTdx?=
 =?utf-8?B?RFMwYTJzYkFaekZyR0ZpY1E2cXpYdDZnU2FFc0VaOE1pYVRybk1RTU1MMmJD?=
 =?utf-8?B?dnlWMHNCRVdITGFmUXlmcStaMjlVNGpOZVNpaXJET0NNWDBIcWo5cGoyTmEz?=
 =?utf-8?B?Uk9OVjJyVUI0L0VqVG4vdVA4TmtZck9ubnp1Vks0dzUyZmhhYlU1bWY1T25Z?=
 =?utf-8?B?MnljSXhQUWFGVCtHb0g0bWwvOFVBTWM5Ulg1eUMvWWJDRXRrL1VNOWJOekxq?=
 =?utf-8?B?cFA1R1A1TUpIbVVkZXBGNksxSWFZNnB1Z0tTRVp6Q0FibkZ2NFE4VC95bVRn?=
 =?utf-8?B?NWhlUGp2ZDlMbjh0aTYzV0xVRmRGL1NIUGNUVHcrc2ppYVFvdXlEZlFwYTZ1?=
 =?utf-8?B?OThMdzQzd1BkaE9YeDhrbHlydWM2QThxd24wc2xDUENaVFlXaUZLR1F5MVRY?=
 =?utf-8?B?OHpraW9tMXprY3pETGVucGE0QVA5cVQ4RHhQWXRyalhJMDd0SWtKUmpYcXk4?=
 =?utf-8?B?cUtwK0pMWTlua0ErcXZwSDY0QTVpVGJWbFJocnhoTWdnWmZIcnI1d2h1ZXAz?=
 =?utf-8?B?VkcrNFZXSEJWWXVrMXU2Y3Fha1RQd3J6Z1Nzc3htSDdFdTczQ2UvUitETDQ5?=
 =?utf-8?B?UnhsQkpORThjamRSK3ZsaUxHcXVtNGVvZ3JwQ2ZjUTZNcWt5OVZRYlVPcTFR?=
 =?utf-8?B?a0YzY2k5bEZNL2FoS0JqVzBWemN6WVJBMURURUVBdk95MVdvV0llMGM3OGJu?=
 =?utf-8?B?aFRHRnZOaEZmamliY3pHVG1pSUI1NTErUnVITkVpVmYycmdGOU5nV25iVmZT?=
 =?utf-8?Q?5qtU7KXTY/UH5v70xsYOH5/ex?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8A67BD95BFE09C4397C3DED58CA320D9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5983.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f44f129-6695-4bcc-5212-08db66453b41
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2023 04:19:33.5443
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EL3jqDYFznU5kVebybAs0LGcbryh9rlAzhWT5M5UDtRC5n9rEthZfK7K1FkLR/Lz/G99SVrpG9OcsFCT24PELQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8232
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gU3VuLCAyMDIzLTA1LTI4IGF0IDIxOjE4IC0wNzAwLCBZYW1haGF0YSwgSXNha3Ugd3JvdGU6
DQo+ICtzdGF0aWMgdm9pZCBfX2luaXQgdm14X3RkeF9vbih2b2lkICppbmZvKQ0KPiArew0KPiAr
wqDCoMKgwqDCoMKgIGF0b21pY190ICplcnIgPSBpbmZvOw0KPiArwqDCoMKgwqDCoMKgIGludCBy
Ow0KPiArDQo+ICvCoMKgwqDCoMKgwqAgciA9IHZteF9oYXJkd2FyZV9lbmFibGUoKTsNCj4gK8Kg
wqDCoMKgwqDCoCBpZiAoIXIpDQo+ICsJwqDCoMKgwqDCoMKgIHIgPSB0ZHhfY3B1X2VuYWJsZSgp
Ow0KPiArwqDCoMKgwqDCoMKgIGlmIChyKQ0KPiArCcKgwqDCoMKgwqDCoCBhdG9taWNfc2V0KGVy
ciwgcik7DQo+ICt9DQo+ICsNCj4gK3N0YXRpYyB2b2lkIF9faW5pdCB2bXhfb2ZmKHZvaWQgKnVu
dXNlZCkNCj4gK3sNCj4gK8KgwqDCoMKgwqDCoCB2bXhfaGFyZHdhcmVfZGlzYWJsZSgpOw0KPiAr
fQ0KPiArDQo+ICtpbnQgX19pbml0IHRkeF9oYXJkd2FyZV9zZXR1cChzdHJ1Y3Qga3ZtX3g4Nl9v
cHMgKng4Nl9vcHMpDQo+ICt7DQo+ICsJYXRvbWljX3QgZXJyID0gQVRPTUlDX0lOSVQoMCk7DQo+
ICsJaW50IHIgPSAwOw0KPiArDQo+ICsJaWYgKCFlbmFibGVfZXB0KSB7DQo+ICsJCXByX3dhcm4o
IkNhbm5vdCBlbmFibGUgVERYIHdpdGggRVBUIGRpc2FibGVkXG4iKTsNCj4gKwkJcmV0dXJuIC1F
SU5WQUw7DQo+ICsJfQ0KPiArDQo+ICsJLyogdGR4X2VuYWJsZSgpIGluIHRkeF9tb2R1bGVfc2V0
dXAoKSByZXF1aXJlcyBjcHVzIGxvY2suICovDQo+ICsJY3B1c19yZWFkX2xvY2soKTsNCj4gKwlv
bl9lYWNoX2NwdSh2bXhfdGR4X29uLCAmZXJyLCB0cnVlKTsJLyogVERYIHJlcXVpcmVzIHZteG9u
LiAqLw0KPiArCXIgPSBhdG9taWNfcmVhZCgmZXJyKTsNCj4gKwlpZiAoIXIpDQo+ICsJCXIgPSB0
ZHhfbW9kdWxlX3NldHVwKCk7DQo+ICsJb25fZWFjaF9jcHUodm14X29mZiwgTlVMTCwgdHJ1ZSk7
DQo+ICsJY3B1c19yZWFkX3VubG9jaygpOw0KPiArDQo+ICsJcmV0dXJuIHI7DQo+ICt9DQoNCkFz
IHdlIGRpc2N1c3NlZCBpbiB2MTMsIHRoaXMgY29kZSBkb2Vzbid0IHRyYWNrIHdoaWNoIENQVXMg
aGF2ZSBydW4NCnZteF9oYXJkd2FyZV9lbmFibGUoKSBzdWNjZXNzZnVsbHkuICBUaHVzIGlmIC4u
Lg0KDQoJb25fZWFjaF9jcHUodm14X3RkeF9vbiwgJmVyciwgdHJ1ZSk7CS8qIFREWCByZXF1aXJl
cyB2bXhvbi4gKi8NCg0KLi4uIGZhaWxzIG9uIHNvbWUgY3B1IGR1ZSB0byB3aGF0ZXZlciByZWFz
b24sIGluIC4uLg0KCQ0KCW9uX2VhY2hfY3B1KHZteF9vZmYsIE5VTEwsIHRydWUpOw0KDQouLi4g
dm14X2hhcmR3YXJlX2Rpc2FibGUoKSB3aWxsIGZhaWwgdG8gZG8gVk1YT0ZGIGZvciB0aG9zZSBj
cHVzIHRoYXQgaGF2ZW4ndA0KZG9uZSBWTVhPTiBzdWNjZXNzZnVsbHkgeWV0LCByZXN1bHRpbmcg
aW4gQlVHX09OKCFrdm1fcmVib290aW5nKSBiZWluZyB0cmlnZ2VyZWQNCmluIGt2bV9zcHVyaW91
c19mYXVsdCgpLg0KDQpXZSBuZWVkIGEgcGVyLWNwdSBmbGFnIHRvIHRyYWNrIHdoZXRoZXIgY3B1
IGhhcyBkb25lIFZNWE9OIHN1Y2Nlc3NmdWxseS4NCg==
