Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A824479DF25
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 06:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238261AbjIMEZg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 00:25:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230208AbjIMEZf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 00:25:35 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F9EEA0
        for <kvm@vger.kernel.org>; Tue, 12 Sep 2023 21:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694579131; x=1726115131;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gHbv7FUCAphiHMjr4AzV5F0OakS2dIJ5R7atmEBgOjY=;
  b=WOxfKVDiyEahgeKwVsGVS+8E0cIJyWq4AicKRi6QkFWtw/VYZbBjYWSs
   OYPURc390LAP0JojYQ4z7McVm3L7QZtmFMVi1CV2uYNLDoY22zsStveGs
   3yI8ydypz10FZu6Qlu/bbx+CYakhzOAL4rzEr311YPQAxSBn/9KleqYJb
   MD3WzONUJzS5N7/qIci9JDOAjFoz5ktHhSwluUkkXPJgwvsw4Fdl6b4Gk
   TgdKZRIZKzzWBkUYBzZeAWzXKm5jXihlZFGwzzEoeORwo3MBJ1Fkl0LI2
   AbtMrQTF3EAfuastaR1i3x9wZhgAnSdH6FR716qFacPTlasm9I0VLzyBi
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10831"; a="382368510"
X-IronPort-AV: E=Sophos;i="6.02,142,1688454000"; 
   d="scan'208";a="382368510"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2023 21:25:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10831"; a="743969668"
X-IronPort-AV: E=Sophos;i="6.02,142,1688454000"; 
   d="scan'208";a="743969668"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Sep 2023 21:25:26 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Tue, 12 Sep 2023 21:25:26 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Tue, 12 Sep 2023 21:25:26 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.43) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Tue, 12 Sep 2023 21:25:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kMciPjuK+BJ9Aqxi8T/w9b+MkFVmuncjAfuPJnkjFmCFA8Nv6ojQUZuvUivjK/uKedirglr1oqM3j4ZjDtyu7Vq/xKTU6f9FK92wCGVOUn3VCRMD4GOXcTJ1GwRTfhcutj4fDgRzOO8K00vtVr2ovTbs9HmEogm9LQmJM76knyCoxp1N72DypDtlIDhp93Wu2BAo042WtwJ2JSy+2OifYjIlC2fq7jfLHKE8ll71VbUBil4rX4qHeyt+mQ+SFjmwTKkcEuTKxEk/fI3EJ8HS9fkR9cWrUX8KECUGB3VhiC3JLuIx5UfPoGbD3hYdFwQuPncBdjnNzoAVEUOoc+xWrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gHbv7FUCAphiHMjr4AzV5F0OakS2dIJ5R7atmEBgOjY=;
 b=MUX4LMdVdeUwyh0DbyP5HPzMjo7JFhhuHowwiVMvKimnZRaF/TKEUyW7iDU2dgYXdcFK5+0ar2IuCwdr4EcWbC53gNpihu1zPZ1hmo68LDlM0abksMbf0e8soYD+m4L58jKxab268SJ3C0JT6oVXTWqMNaoI7pps16qrk6f0bIYF9cI14esqT/CrYSx2ETzKjlhYxPF9yfu91G9zdexJ3XAjDWkpwQAnqy+pNVCaHHjqbJXJ6YWpm4laT3bXM++hvdAMcTo6mKoHQqwzkQ6la7yEdPs2jNf6JxVeIBpzxTXtG7sx8ZSA/xFeaou9oqyEAVaulK4IbOr2pFNQMuR7Lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5824.namprd11.prod.outlook.com (2603:10b6:303:187::19)
 by MW4PR11MB6810.namprd11.prod.outlook.com (2603:10b6:303:207::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.30; Wed, 13 Sep
 2023 04:25:22 +0000
Received: from MW4PR11MB5824.namprd11.prod.outlook.com
 ([fe80::c8f6:72a0:67fa:5032]) by MW4PR11MB5824.namprd11.prod.outlook.com
 ([fe80::c8f6:72a0:67fa:5032%7]) with mapi id 15.20.6768.029; Wed, 13 Sep 2023
 04:25:22 +0000
From:   "Zhang, Xiong Y" <xiong.y.zhang@intel.com>
To:     Like Xu <like.xu.linux@gmail.com>
CC:     "Christopherson,, Sean" <seanjc@google.com>,
        "Lv, Zhiyuan" <zhiyuan.lv@intel.com>,
        "Wang, Zhenyu Z" <zhenyu.z.wang@intel.com>,
        "Liang, Kan" <kan.liang@intel.com>,
        "dapeng1.mi@linux.intel.com" <dapeng1.mi@linux.intel.com>,
        kvm list <kvm@vger.kernel.org>
Subject: RE: [PATCH 5/9] KVM: x86/pmu: Check CPUID.0AH.ECX consistency
Thread-Topic: [PATCH 5/9] KVM: x86/pmu: Check CPUID.0AH.ECX consistency
Thread-Index: AQHZ3KYWq0UgcnuPOk+AuGokoy2lbLAXIBkAgAEa/FA=
Date:   Wed, 13 Sep 2023 04:25:22 +0000
Message-ID: <MW4PR11MB58248D69A66BCCC48DA3207FBBF0A@MW4PR11MB5824.namprd11.prod.outlook.com>
References: <20230901072809.640175-1-xiong.y.zhang@intel.com>
 <20230901072809.640175-6-xiong.y.zhang@intel.com>
 <a6ee4f4f-63a6-4d7d-7986-6dd0e1255e92@gmail.com>
In-Reply-To: <a6ee4f4f-63a6-4d7d-7986-6dd0e1255e92@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB5824:EE_|MW4PR11MB6810:EE_
x-ms-office365-filtering-correlation-id: 25425ce3-faa4-4284-ac30-08dbb41171d9
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1VGl98C1P3dYDQTvFT2N89OQDqPL16he3rnwdDF27CPA0Ebw2h2TSvLHEJxni+hxzmjEl2BplY04OJTgyCRqCfb7Zvd4foqEP181SBQYd9s2fEezNr5wCBitQC7qOOMovV05+QewJtFCYfs/V/MiQiHQkDw/xv44sp/RkZtM4lOB9ZfdrVFrbCE5/1Sbzr/AR3u4Gg6AFihgl/D8zsiQY4DkGVHp3bVIFR7N9fkbgC/zb4vYMZE92uWkjTFpdQRvRbVwNM/9ukx+isrccUz2VTuywQIj4o6iFfKD+XvAJDfmumbe3hUkcd7HreTIsmloZUN1KOud6ZJ0NgvarXfX9Ge4G/OVweTUBnfZi6xYQ+WnoR54syYiNnEHiSTgUjp1SQDBcCkrBmuMxu/GdS408TnF/ab4ktsx/JR9eyUaiOtO8qo+hPhsuiHAYwWP2QJOLzkPhm/45xCUERHxC4/45udezL4KbfQ95ia1hkQfezAoHxSelWpKO0Z4B7bp+yA5qtC9Uk6QOCcIvra3KiYwpmwgLkYl/xYqls/sY3WKdsV6nELcwrmP5JrWlmQsRPKq4pGtz5PIdecHaKArwWmlL3i15eKFeJkSChzsQJ6x6UWGDbseUf1kCLj2WYYy+6Ka
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5824.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(396003)(366004)(39860400002)(136003)(376002)(1800799009)(451199024)(186009)(316002)(66446008)(66556008)(53546011)(76116006)(66476007)(64756008)(66946007)(6916009)(54906003)(71200400001)(33656002)(8936002)(8676002)(52536014)(4326008)(6506007)(41300700001)(5660300002)(7696005)(9686003)(26005)(478600001)(86362001)(38100700002)(82960400001)(38070700005)(55016003)(4744005)(2906002)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RzhVME04NTRoeXZZdy8zMVdTZ09qaFdEWHd6aCt5S2JtWmhKYXJVcVkzSWo0?=
 =?utf-8?B?VCtXNmZKNVMwdHRHYTFtLyttQ3dnNThjRW5QWlorUXd5OHh2ckd6MVZxWU9m?=
 =?utf-8?B?VWc2U0NDT2hlcUIzYllKcnRFOTZzeEtITEk3M3o5MzZWNWU2Z25kQ3VwcGhZ?=
 =?utf-8?B?SUpkTkNZU1A2anVGWHVHZXhFbVJOc0x6R0Z0SnVlSDhzV2xIUG5KM0JZeVZO?=
 =?utf-8?B?MnRUWlczNVBuQUxqbURYcjE5aTlsdVd0ZW8wQUMzUllDN0MwUU1keGc5UUtH?=
 =?utf-8?B?ajJFdmlmSXk3Z1pTR21NZHNYK3orazZ6U2dtcjZJbXc4Wm1ERTUwbnowUkZS?=
 =?utf-8?B?NGxxRHkwNkREbTBFTS93WDQ2TjVid1FSMFBFNU9qRlkyQzRlS0tPV2NBV0F6?=
 =?utf-8?B?KzZ5Yzh3TER6WHlDZCtWa0NBQURhWlJTVkVmQ2prbjJtZ2Z1UXRNdGt0WElm?=
 =?utf-8?B?M1V6SCtFZHRNRW94VXp0RnQ2dHQxT0hja3docWpwbkloUVZrVll1bXdmWXl5?=
 =?utf-8?B?T05tRHlSaWJmckhTNkh2Vnc4a2N5Z1NTbktwc1g3czdpaytWOS9oVEZLNG9X?=
 =?utf-8?B?RWFFM1hIeWg0VUJ3N0VsVEdKYm93dEIxL1RCejl1cmliZml2OVRITThVWnNK?=
 =?utf-8?B?MkN4aDBoRElsSEJpUTlrL1pISjR5azBQWDdVS2l4dlhpV0MyVUlPcjZ1NUhC?=
 =?utf-8?B?ME8xMWZUWVh2dFpzN0trckFPMHpvVEpKZzUvN25LSWJDK3F5bXBsWlR0STFm?=
 =?utf-8?B?cWRJdnVYa0dDVFVsYjgybWVWMHBHbGxaL2tNcVQ2OHptMU1tTDFkSjE3M3E1?=
 =?utf-8?B?Y3FDQmZQRWVXSDJMMkZwVlJORkhJNnRQaWVvQUduMlErUHRzWXpkbVRINi9i?=
 =?utf-8?B?Z2lZK2NQN1MxOVk4aEo2cFltNUJNQ3QxaTJFRnVLSDBXYU0rOGNJRGs1amgx?=
 =?utf-8?B?UGZvd2RJcTFUT3Z0QzV0Um40d1VPbUJBNjFYeUdBbXN6QzhaTUlGYVc5S0lK?=
 =?utf-8?B?MHozdDExMWlUNHAva0R3TWVtUkwvNXRXQldYanh6aTA1ZzZoNmZKbG02Rjk2?=
 =?utf-8?B?cm9IbzZjUkI3aUxneGYyOXdtTEhaLyttd3JGd1ZMbGMreGV2NGJIV0ZZaDBE?=
 =?utf-8?B?d2Q3a2I0ekEyU2NLRmtUMThPd3kvR21kVWY3dzBWSlc2bDBQS01aOVpLSktV?=
 =?utf-8?B?RHJiYlRnWkpKbTQwRHZIenVmM0U4SFBtQTVjeDdzYUFlSjFCUm4wTGFMZ2dI?=
 =?utf-8?B?VUJiK3FrVzRnTGt0a3FRYUV4eVhvMDAvU3JYakppUmhhVkNvbVpKMW5UUmJ0?=
 =?utf-8?B?ZmFXWGFtbzR0ZjRwN1NGYUE2SzJ4SEEzeXNIcXROUi9HWFJzeGxnU2dGdkx5?=
 =?utf-8?B?WWExVGlWVUpJMWVkQS9wSmZNK3haU2EveUFnUUVaQ2ZNWmNKUjBwQzNZTmV5?=
 =?utf-8?B?OTNLMkVJcXhKa3VPLzVWWW8xZXpBZGFGVkszazNXTit5dnRTVTN1QmhKdkFE?=
 =?utf-8?B?QVZMNHRZZFNKQmIyWlpiQTdIY01HelM5V0dCT3lUd0VUQnlDV1pxL1lCWWw3?=
 =?utf-8?B?clIzRHdpbEk0VmEza3Z5SjZDQm5sKzN0elRYanRNK3FnZEdqYWd2a05MUHk4?=
 =?utf-8?B?MHUzajlBYlljVEtCcTRJaDlGaXBVOTR0alFBRTIwajZ3ZzJ4cExSZk1YZEVK?=
 =?utf-8?B?QjZyZTJHcllxaFcvWHdVNGZZd3I3bVVlT2FxU0FReWZ1bUJmWFd4OGRwWU1z?=
 =?utf-8?B?ZklVUmdQMDhzNDFVQ2toNGk3UldzVGtCYWVPZzlUSjVXQkhKSzZLNUdTZlhq?=
 =?utf-8?B?VVdhZEhhTkk2dzg5NVljSXFJK05vd2hEQUNDNjcrUkNTeEloMEpIMGJ3ckVj?=
 =?utf-8?B?QTNtcVpUUWsrOFQ5RlpRdGdEanc0d1F4Sm5URy94MGhobS9WT2s2Mks5WXAr?=
 =?utf-8?B?NGw5cHExQTlGZVZIV3Y5N1NxUmpWQnhXRk5yU0tSKzV6Zmp2NGdTR2RzTWZR?=
 =?utf-8?B?dU9OWkJWTVRncVV2bkc4blFSUUhNZWFzZlNIcmR1SzFMcDZ6U0d6ditFUG9O?=
 =?utf-8?B?TTljdHlsVU4zR2c3MVhwM3JvTlNnS2w1YjlZdVozeHRXTytFN3BoSWc2Mk1T?=
 =?utf-8?Q?7PXoa5ogTl8chg/lvVTcwJcg6?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5824.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25425ce3-faa4-4284-ac30-08dbb41171d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2023 04:25:22.0201
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kyA1/6WcFMAVY4g/Xg9gE6XemTc0st8ZxYNkN0R6W2cwhq+AFO1lzGsQ5Hjj+j6/qEJKnPRaiIcvF4oD22n+bQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6810
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBPbiAxLzkvMjAyMyAzOjI4IHBtLCBYaW9uZyBaaGFuZyB3cm90ZToNCj4gPiBPbmNlIHVzZXIg
c3BlY2lmaWVzIGFuIHVuLWNvbnNpc3RlbmN5IHZhbHVlLCBLVk0gY2FuIHJldHVybiBhbiBlcnJv
cg0KPiA+IHRvIHVzZXIgYW5kIGRyb3AgdXNlciBzZXR0aW5nLCBvciBjb3JyZWN0IHRoZSB1bi1j
b25zaXN0ZW5jeSBkYXRhIGFuZA0KPiA+IGFjY2VwdCB0aGUgY29ycmVjdGVkIGRhdGEsIHRoaXMg
Y29tbWl0IGNob29zZXMgdG8gcmV0dXJuIGFuIGVycm9yIHRvDQo+ID4gdXNlci4NCj4gDQo+IERv
aW5nIHNvIGlzIGluY29uc2lzdGVudCB3aXRoIG90aGVyIHZQTVUgQ1BVSUQgY29uZmlndXJhdGlv
bnMuDQo+IA0KPiBUaGlzIGlzc3VlIGlzIGdlbmVyaWMgYW5kIG5vdCBqdXN0IGZvciB0aGlzIFBN
VSBDUFVJRCBsZWFmLg0KPiBNYWtlIHN1cmUgdGhpcyBwYXJ0IG9mIHRoZSBkZXNpZ24gaXMgY292
ZXJlZCBpbiB0aGUgdlBNVSBkb2N1bWVudGF0aW9uLg0KU28gSSB3aWxsIGRyb3AgdGhpcyBjb21t
aXQuDQp0aGFua3MNCg==
