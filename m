Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 361006D9638
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 13:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238258AbjDFLrs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 07:47:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238845AbjDFLr3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 07:47:29 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D51CBDE9
        for <kvm@vger.kernel.org>; Thu,  6 Apr 2023 04:43:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680781412; x=1712317412;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=TzsX7ZfSZ0KK86BryCGY7GY+goiW78Efm1RBbSbV8qc=;
  b=VzTXmhQw3EVDipj5zLHsnW9FQFzom+h7wIJ6iHB4HAo6pIYw/4bqfOtf
   yPtzzma646+iwMKOX0Z/gAayRxHTRvxjzMh92iMl7tTnlkej/qu3YqZSG
   cCXPiLNFj4BtIZWaU6PNhupY3MoyQob/Y+dJrTB2xgGNSjgBQeDpqJApy
   ml0uLsfzNBOnDlWcKPIL+SPqWotQ5tCxFbTCpGZ3g0i1rUdX4b4LKFJWR
   AwbLxJUoH5yTN5HktwhzW00k3TgNWcYUgSc0hhV1m75c5kJ54WyfNS2Hu
   tqx4qTQGtEoj4Pv2jmEagzZqRczlClVAXs6Tod3w8mrkBg6DiaYsA5eBV
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="340203154"
X-IronPort-AV: E=Sophos;i="5.98,323,1673942400"; 
   d="scan'208";a="340203154"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2023 04:40:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="637249494"
X-IronPort-AV: E=Sophos;i="5.98,323,1673942400"; 
   d="scan'208";a="637249494"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga003.jf.intel.com with ESMTP; 06 Apr 2023 04:40:08 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 6 Apr 2023 04:40:08 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 6 Apr 2023 04:40:08 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.109)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 6 Apr 2023 04:40:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cRMYEP2OM3//x0fmRLiHhULaRYnWq5gSXqfiXpIOxcVtHZs/xvMHBNiwp2HCqiKSSLJwrxAyBgBjNKu+/CUo1QCaZo2TvRUvZ89Wcy8IcVlDqRLxejuVpo1GnY0cLMP69SID/J7YuJUPbukvoyMxnfFnXk/nNtpMAIrgIQB33THdeJa5ihnxfkaGmukU/KcPek76EfvSEkwbEgwUA5mrnUuICrncEy1zAiSFbZRzFiXcWXUiOf8iAB3OGsVDcfnNxrKO8QQrGlcaI/oaY6su9P/PI9I4MPM2sVWgRzIiKgAvPv1ghq3zS5Z36Vy9Kq6sdyaZuvyl1wXCFzqJFzlzcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TzsX7ZfSZ0KK86BryCGY7GY+goiW78Efm1RBbSbV8qc=;
 b=YKBKyyxqIP5ETw8CZujKXf7Jcf21JDg8kXbfM6VOZoNZwlVjZQvZLx5zNhCRwyFE3f/gPnZogxQ1DsxXpUyvVTxRHVEOEikM6Cf6fVcnP2ze8m/iP+bSs3ur2RZEZLy36uVcjlTk2dUZKD37EK2sPZtmp3nSS4dNTaNs+qDXVprl42/NNBEkX9dbrmW7LRmd8rV27+7lxG8kP5XNFk9YlGVOiQ4LUsAuEVkSHqUXFddO2hAgkWLCMuu1uXksPlpm8gX9YsC+nQYrw6E5OQQLh9JP0ibueQsrnapPndtu+KU77NWtyAmGFZAo65yJ7b7IH+WSzYMjMM8kMq81MO50Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH3PR11MB8187.namprd11.prod.outlook.com (2603:10b6:610:160::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.24; Thu, 6 Apr
 2023 11:39:59 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9%5]) with mapi id 15.20.6254.033; Thu, 6 Apr 2023
 11:39:59 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
CC:     "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>,
        "Gao, Chao" <chao.gao@intel.com>
Subject: Re: [PATCH v2 0/4] x86: Add test cases for LAM
Thread-Topic: [PATCH v2 0/4] x86: Add test cases for LAM
Thread-Index: AQHZWjwDnb8S+br+10efEcD0ZHwVAq8eRI0A
Date:   Thu, 6 Apr 2023 11:39:59 +0000
Message-ID: <9896a0bf26e48dab853049f40733df5bb0e287a1.camel@intel.com>
References: <20230319082225.14302-1-binbin.wu@linux.intel.com>
In-Reply-To: <20230319082225.14302-1-binbin.wu@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CH3PR11MB8187:EE_
x-ms-office365-filtering-correlation-id: 0f294501-0d6b-4e9d-0fce-08db3693a6f5
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eFDeTJ6daqs9Glab0PE1fAYqc+avzyVxSUXENjivH9/3/4pQCQI/pnTg/uo91e9HVpgm6Wq7rDP2V3yrGK7IiSlz6pwoh5t1w6SDKUZZhrw1xDnXv+B8egK9LePAzL4pjEQeB2WpPTqNq2CmwIIrGgkc2fcN9uN0kOALQN2Kg83ZdaZZJo4z+uTCVa7x5tuP6oMLlE8GGE9Wv23tiBrB1casRF3ZVMKdW1RNEizbwYPlC7qDunKoKu25d1Dr17XSBylMlypVNdj1wi7Ydbw04si8HqcuvavIWvnmKlaJ6gjg6F59Q5RjWrqb8cGYlwDhy5ykgoVsgVG1h/jlp0gNAb22kBwgyVGCUKa8LMeIgL+al6Jmowyx78DCvN2Cgc1+MJAUTwT21y2cG4C5AnhhwFXVGwiJTofo+gZfn3oBY0nZq8srgeeEVxv6RqvCDyecHLFvOvH3W61REY338kY1hpzpOUzQX7CWp3aoQJtsg6FgbLRkpnQIR0BDIbZffzgdiXwoLtjfMi9ZwQ1tqAU3YwEU0f8VnVVKPdmobp+jO9Svue4Al/0gLqHgldzdi47z6Hf9KstGqG0qmi7miKcz1wekD2UGwb67xQK3ETjTSSYBIfBRzv/hXTP+hid8ewY4
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(346002)(376002)(136003)(39860400002)(451199021)(36756003)(26005)(54906003)(66476007)(91956017)(64756008)(8676002)(110136005)(66946007)(4326008)(316002)(66556008)(66446008)(6506007)(86362001)(186003)(5660300002)(478600001)(76116006)(4744005)(2906002)(82960400001)(8936002)(71200400001)(38070700005)(38100700002)(122000001)(2616005)(41300700001)(6486002)(6512007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UWZMaWx0YlFxdEpzUDdXQmNOYkFpK3l2VU9JODQ4SjhpR29rM3o5eXpud2VY?=
 =?utf-8?B?bUVJL2pvZng3RW8yUVpnQVBJc2piWmtYdU40RFVmS3R4SXlFL2VWY015VGFT?=
 =?utf-8?B?VTYveHkzZnRSR2VlVXFBT2dtOEdUbVByNnZMOVNwK3JQZW8zcml6ejB2SnJK?=
 =?utf-8?B?NkJWVlRrWlFtN0RDVFl6bWJMWjFudVcwOWVNNUl6WVA0cFkvcUhuUk93ZFZp?=
 =?utf-8?B?RU4zRFFFc0pmalFXS2MwQ0d2OFFLZFo2MGVWY1BYNW5QZUhHcHdHclVSdU1C?=
 =?utf-8?B?YmZQWkpPMEFRNnUza2dtNzAwbUw0ZHpXN2FJOE5aWHFTSFFTeWkwMkRib2pt?=
 =?utf-8?B?NmVsYjNpbTF5Q2NLblZtR1BqcFpGMTNuWWVMa0tNSjRGWkFsZENGb1RsUW12?=
 =?utf-8?B?aU9kN2p4SzJZR1U3V01jU3lrSlErRWIzWUhCK3Q1eFhpNjV5V1kybDNMbDc0?=
 =?utf-8?B?WDdGN3F4aFFnbjFkZVJyVlFqWS9aek14d0JONFJuUjRNbWhQVTllakpzTkdl?=
 =?utf-8?B?MThwRnFtV0JtNlZxN0YrV2g3cGgwUnBjTFlrUzZhUm1QR2JqaHAycGJMTUFD?=
 =?utf-8?B?OFVoY2RKRDM0NXBUY3VmMEU3bm5hUFM5bmZvQVNaQ3c5Y09KYjNWckVTaEtD?=
 =?utf-8?B?QjZlK1JKOHdwdUgxMEhhckFGMHY3WVlBZ3dyV29XdnBVczd4OFhSZzZ5TXNG?=
 =?utf-8?B?NEJ4ZU5nWTZIc0lmMHMxVmJXQWJ3Y05JTUFJNHZGclNvRlNPRFVMUzRkODNj?=
 =?utf-8?B?dFFMN0pSYURDckI5WS8vUmtpa2JNUTRtS1ptVHBvOW96cHcyRGZjL3BwRWJH?=
 =?utf-8?B?VGxIZU1DYUFnUUF4bGJUZmdSOGJ6UEh1NHpWTTgxYjc2czB1Q3UzNTlERUtD?=
 =?utf-8?B?dWJjaUhubEc4M3ZNaGdqWVpOM1NhZjNqN29JK2FvMWVKS3B0ajFOZnBxS3Br?=
 =?utf-8?B?dEtPbHA5dTA3WGFmZUJYekRLYlB5dGV6WW9GWFZRdXZqcC9VRFdGUkl4UFAw?=
 =?utf-8?B?SVFJZkJBMnkvNURRclg3WTh4cW11VHFXNmpRVnhjNFRESE5jd1NmaFNZTEJl?=
 =?utf-8?B?bkdFZ092VVAreUI0S3pKRDNSMFFBOEVIcFNXTmdyMi8vOGxYeEhtMGIxVzhQ?=
 =?utf-8?B?ZTFtSVhpWGdQV25lTGJZRnROSWxjZVhJRHRhR1JvVXlTV0RNYlB5WTdwZjJK?=
 =?utf-8?B?emllSWdIYWdNUlJvUVpsdUVsQTZDV3RERGxzUjM1MGJrdXVmY28xUURETzZH?=
 =?utf-8?B?R2FtdG5YMG9kWGpNcFBZbnFQcXJnYnprcUJNOXE3TEp6c1VzYnZZdEVTMmQ1?=
 =?utf-8?B?b01EdERCRGJyY0xDcGlMamZFVnZNV1d6MHRNaWk1WDJrMm9xT0R0eitzTUwr?=
 =?utf-8?B?TGQxdC9LaVdBYU9OVXNod3BkVEQzbXpYQTJrblVSM0tFWUgyZkFmUjJwY0tq?=
 =?utf-8?B?UlR1dHk1S3ZxMG9iZ0lkY0JieFlyeGNOYXVTTnVNV0d4Tmd0aHNYVm8zaS9k?=
 =?utf-8?B?VkdoR1pia2R6bGJqUkNKck9BbDRsMStKQVlnaWIybXdTR0g0TC9jb0dqVFl6?=
 =?utf-8?B?Y0Z5K2R5Q1lNalBXNXo3RjZIVUV5OWJqWjVudHJyUXlFSVdlZnJZOU0vT0g3?=
 =?utf-8?B?NU4vRFkzeGRNMUxEMzNycDlQYmRyV2FiWW93Sms0WUxGWElvZGRYdUgvSTZC?=
 =?utf-8?B?RmJyZ0c5MHVQTkNCMUttVTBrVG9kVjBGWGVERFR6Um1qd0lQSWttN1dEWDRY?=
 =?utf-8?B?NlZjUjhkNXROU012YU5ad1JJTkFQZ0JNL0E0SGJZNUgzV2tBb3NzbTR3WXVi?=
 =?utf-8?B?djJHc2FQc0lKd21FeWg5WjJteUx0Z3AyUnk1NTVyd2hqR3ZXRWdINzlNR1ZL?=
 =?utf-8?B?anhrQmdhTDkwdHREYkVkeTYvMWM0MmRqWG9oTWVFdGhqODVSUkJ6b1RIRCtI?=
 =?utf-8?B?blU0SjlZaTRvREg0NmJ5SXYwcnM3OFdZTE5naTFVUmpvUTlzZytndkhzRWdi?=
 =?utf-8?B?OVAydFBlR1JOZEdCM3dyMzNqM3dRZFQ4bEtBaUlZY2lXRHh2WDB5WDlQYjRv?=
 =?utf-8?B?R0s2NVEyZ0t2dWJtdlU4YmN0eWh4d0V2elVSa3dqZ1ZsQkFmTWk2TU9DVnNM?=
 =?utf-8?B?Zm1EaWxrT1RQMktYY001dW8reUZ2NW0xNk9yQkQ5bWtPWWJudldYWHZ6N1Z4?=
 =?utf-8?B?K1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <41776FBF169DC549979D1B6F391BE8EC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f294501-0d6b-4e9d-0fce-08db3693a6f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Apr 2023 11:39:59.2169
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 940uVwkU9jUQnoWG4mlw9SSDdirb0NksszWpqHZJjihwxL73AP/nH09w9Me94BHaj3rqJpJD7PJX5ojhgnrdPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8187
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gU3VuLCAyMDIzLTAzLTE5IGF0IDE2OjIyICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+IElu
dGVsIExpbmVhci1hZGRyZXNzIG1hc2tpbmcgKExBTSkgWzFdLCBtb2RpZmllcyB0aGUgY2hlY2tp
bmcgdGhhdCBpcyBhcHBsaWVkIHRvDQo+ICo2NC1iaXQqIGxpbmVhciBhZGRyZXNzZXMsIGFsbG93
aW5nIHNvZnR3YXJlIHRvIHVzZSBvZiB0aGUgdW50cmFuc2xhdGVkIGFkZHJlc3MNCj4gYml0cyBm
b3IgbWV0YWRhdGEuDQo+IA0KPiBUaGUgcGF0Y2ggc2VyaWVzIGFkZCB0ZXN0IGNhc2VzIGZvciBM
QU06DQo+IA0KDQpJIHRoaW5rIHlvdSBzaG91bGQganVzdCBtZXJnZSB0aGlzIHNlcmllcyB0byB0
aGUgcGF0Y2hzZXQgd2hpY2ggZW5hYmxlcyBMQU0NCmZlYXR1cmU/DQoNCg==
