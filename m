Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94B4170BF21
	for <lists+kvm@lfdr.de>; Mon, 22 May 2023 15:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232833AbjEVNGy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 09:06:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbjEVNGw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 09:06:52 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D03EF9E;
        Mon, 22 May 2023 06:06:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684760811; x=1716296811;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=+lb5hxf46U/LZfEgov6AWo9x6RAkf5s48oMedk7xAXM=;
  b=DDBw4hEWsvS6blFQieoVOBBmWDb8VeFNs1Z9vDv85YiUX1Rh08R0y/pL
   m+QtCMVrmrQxQ+ycsAZpl9cqwUbQ7aea17spwwocnhq0bIp5hEfcvyOSP
   GsrjWuNPETW3NCnpWulYe6EQCzOcZvzjqqHCZUNiuEWNVoSypC9m9nCy5
   qnx/aoYD48+bYgDIOikjKHjXCluT6G1z0XVT+pT1uhSasHRC+t7DrcUHn
   04EUyzx+2FMDqCQl8VjNPstyrVwUSPXcJ1dYFB0jLC16o+YjDbmwfqR1n
   tC/2bWiOSpE2+IJsUE1he+BKtyASPNROApt/i5Nk/Ctz/IV8CfkKed9LQ
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10717"; a="337502938"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="337502938"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 06:05:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10717"; a="950076586"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="950076586"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga006.fm.intel.com with ESMTP; 22 May 2023 06:05:54 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 22 May 2023 06:05:54 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 22 May 2023 06:05:54 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 22 May 2023 06:05:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HLpHugfTLRpCXSnQgUJuTzp7T2mII3oJDEhPJpx7vFFtY5f4FqqeKS1xP84hHJBUGAl1x1PrZippYBzScxEWR3/V0+wq79R2JRIUUYWQ9e7Ob7jxAsEtP1G6OK7ZScG+QaFhAshs87leLYC+C8r18NtKoMlCpkP8OMGDB6Cs/wkNGrjrM6ZwDL0wLiwEUzu+fy4pbzzM4Y1ZlZia7QRmRCQKUUkxd5g9+ethFZ6ZFUwXM63wh5CV4rsHwy6tUZQbYDYZhhgt0k82UzibgMkF2Tmmo0heaSqm0Li4T7YLLk1ZmlGOfofFgBLSD8Emtbtsh2Il1YbHGFvhos0goWMiFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+lb5hxf46U/LZfEgov6AWo9x6RAkf5s48oMedk7xAXM=;
 b=JwdValN5Std2rcgSNB2UQAHbOslqdiblnduJJLBfm2UPL14VaaEYRDc8/zZGsXKO6Rcr9nESG8xvh33wVr7HeI2ZuIyCdBZMZ3orQtxKIc49NbNGPaPQbP1PABjapRtbm5ZOpaLkQH2mHasZu6cmwvB2KpRpBbZZnd8/HhKJP4YpWtgiX5lJZho6LJkMDLH348eULYj72hghDwO5Ak9u7KqurvU2pfyBizTGOInccddSly7PWrcnWTRv+q6L4n+riYXUvNbsm42Y8M1EbSosjJMivY0a6hebEI3jVsaecLIVd2dADPYFDiWQN6rmB1gZRe672bAaQ8/KCR6nBNJBDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM4PR11MB5472.namprd11.prod.outlook.com (2603:10b6:5:39e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Mon, 22 May
 2023 13:05:50 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2%5]) with mapi id 15.20.6411.028; Mon, 22 May 2023
 13:05:50 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Gao, Chao" <chao.gao@intel.com>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>
Subject: Re: [PATCH v3 06/18] x86/reboot: Assert that IRQs are disabled when
 turning off virtualization
Thread-Topic: [PATCH v3 06/18] x86/reboot: Assert that IRQs are disabled when
 turning off virtualization
Thread-Index: AQHZhSyVjkzhAyZ3qk+OfywQxA3CUa9mUeaA
Date:   Mon, 22 May 2023 13:05:50 +0000
Message-ID: <a135f18eeab880f002c7748da3aff8ed0c8c63e3.camel@intel.com>
References: <20230512235026.808058-1-seanjc@google.com>
         <20230512235026.808058-7-seanjc@google.com>
In-Reply-To: <20230512235026.808058-7-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.1 (3.48.1-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DM4PR11MB5472:EE_
x-ms-office365-filtering-correlation-id: cde712db-31e0-4a42-a4ff-08db5ac54426
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wTL3dZlA7KA2Whbm9fUt0UayytwsAx8c54sbEjVvbA7Vwky1hrNN9wmfEcHcC3vlWGVtkMJZ47wK3VCWmWwuVQdZqhFmwCFTDEQMmqorP9g45aoWQJLdrMw8aa45a7VHRMbzdgHDhqXfWc8qzCaAzC1Xcel6USvkTY+aDlPhF19HJgmBBWY4wDA4E+oylOHal3zqCzQhXT5oxCKR3wXRaBC9MoYmQUIngDx5Hq4H/vnm7oSPJcNl8jDI1JRkbLvlYhDNq/dJqiMCfQXbYqiTT9ryh73vwVmseZ0O/GMOc60K/ZytqOiEjGjeNc/clzZ5EQdnsJr4DFYzAtPcVo0ZL6+07iso04KGEPf8lmjGJ95j7/XyhR7nZrNGqRBPBHV4Yyyobto5ZYFJzy/mQIRX9Bv5ANk0R9MHp1G99brVdG1prQbQb/CMMJwIk7qADgDzXgUodecsIInZf3q8lyOkDlBG9svPHmIKeRVABfdDhdGTc0vvHxq7dQoAyb1NGdMFZCVhaw0gIteNKreO4CErHc6t0Pm4b1Q1lkkWSLJ/SB40/0dh6mj8SoN7tTfS2YgRSbKTYnovyi7NuqxJk3Xs77rKDpv9E6r9W1dRupjk8TKltFWwuLlM23hYc9xJjaQm
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(396003)(136003)(39860400002)(376002)(451199021)(38100700002)(82960400001)(122000001)(86362001)(38070700005)(36756003)(8676002)(8936002)(5660300002)(6506007)(6512007)(26005)(2616005)(186003)(2906002)(83380400001)(41300700001)(6486002)(316002)(66446008)(66476007)(91956017)(64756008)(66946007)(66556008)(110136005)(54906003)(478600001)(71200400001)(76116006)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?T3BHZERXQ1dwUmJNUDgwVXhiU2h1bHNXOU5seS9ZeEQ5K1hlL05rUHA4QWgw?=
 =?utf-8?B?M1dKbm8vRFUvMHkwWGcxOHFzS2RwNWRNVkVoUWxSZTh1Y3lCWkxTTVJSY2RT?=
 =?utf-8?B?VnAwV3NtRmc1YlFYeXdtZFo0aU5UeCttWXNSWEI3YVRpS3RCSHZkcEhGR2Vh?=
 =?utf-8?B?QkdPVGpINWFtcDRselVRZGJUNENrWm9ZT3hFeWRLc25xNDcra2hBMm4yTGdm?=
 =?utf-8?B?azI0M3ZvSjN1cEJPL1pFNXA2bUJwMkxTTkt3d2xNUjRhTHNjWGQ1cmR2cWNt?=
 =?utf-8?B?R2pjUHZiSzBQQ3VXT05udVlWQ0lYckFhYy9OMURiOTFicGZ6emxyNEtObkxR?=
 =?utf-8?B?ODVZVlFCdFhoU0dJZ0pPSWZlZTFkZXhBM09VeUovSWE2QlV3dXN2RWhWejNP?=
 =?utf-8?B?S2ZSZGxhL0dxSHVKSDE1eHBNaXFCZzFWZ0daOVRkSVA5N1o4Y1FCTndVdStw?=
 =?utf-8?B?TDJZcnl6K0RUb210YU5UMCtpU3lrK0Q1Y1UvaUd1b0N0QkR5dk9PZ3NMS0hQ?=
 =?utf-8?B?TTJuVGpwNFlhRUlMbmZ5Q28rbkYvVzJ3eW0vM0x6T29Ibi9HUmpPZExwdTBI?=
 =?utf-8?B?UUJtN2dWaDYwbHc1RlUxUlN0UE9SZTVWelFBQ0hxOGdoT29Ia1VpSnRELzdV?=
 =?utf-8?B?Z3dkdURZQzR6OWlMTEdpQlJoSDkxU2ZsTFZReVFrV21KZjRBVmZnWnlBamZF?=
 =?utf-8?B?eS9kcmRCeW15Y3NDSC9PZEk0c3ZNWUZqU1FacXQzb1FCdGdwa1FhbFcyWVhC?=
 =?utf-8?B?U1A2WHJMWUpPdThQVzdXaVVDVzQ2NkE1UzlxL3BuQ1NKYWlqMnJQWnpNdGp2?=
 =?utf-8?B?UmRlZVRXb2J6NkM3dGQ5aVU0NFBDMkt3UUtGZ3c4c3pXSldTVlFRV2oxMlRj?=
 =?utf-8?B?Z3lUTVA0bXRMdGpNYjdXRGtiOU1UQi9VZzN4NituU1d4eU9YWjNZcFhobXJW?=
 =?utf-8?B?aC9EUmJaVFdtTnpXVjZPd3lGc2VlOFMyVTd1K3RJbzdaNCt4ajJBU1N4MjBE?=
 =?utf-8?B?UEE2TVdBQWJqa1NTVVRxWnZsY1YyTzVPYjlJMlRmeWlIQlhzSUEvb3Y1VExN?=
 =?utf-8?B?cG03ZFY1dmloWXBVUjlkMzFoMEJwZ1BiZ1JDSmw2c1Bvc3lKeFB4YnFmYjlG?=
 =?utf-8?B?RlBxNUJWVzIzNVNRSTBQSUtTY0ZPamEwOWp4VHVuVjVBUGI2SHdobEh4N0ZF?=
 =?utf-8?B?TFVZRENFY0RHUjhMSTl6OGdhRzVuQjhSSzVQdmtkTFJOMWJDMFF4OUFLVHlH?=
 =?utf-8?B?QXN1aWxKV0ZlcnJ0VW9HOEpnUmRyKy8yR0t3Y0c2M3NjbWhoMU5RY2sxMTVV?=
 =?utf-8?B?Q3NiakNWTGtVcVpYRVJncEwybGd2ZGhmQlFleXVBbW5iWk91QUdlbHJRblJC?=
 =?utf-8?B?U2xROGJFalA5NE40bjZ3TGxZdC81Wmkwa3E3S1pJTkpEZ2x6b1RTQXZKN3RG?=
 =?utf-8?B?d2tHK3hQM2JDQitiN3pwMklPV3AzWkgycXFFMlNWc0J4SFZzZFJKY20wVDI5?=
 =?utf-8?B?dUpmd1B6Y0FKWE5wUGJHYW5wTk15Q3p4WEdoYTVleTB5NW96WVlXc0ZxdU8w?=
 =?utf-8?B?bVE3L3F6djBLS0FXQ2xleXAzakcweEJPZmczWjVUT1l3WEl3aDRYUVRmMUlz?=
 =?utf-8?B?UU9peGR2YzlybXNUQ2h0dHdoQnh5ZFZFd1pyazgvWWxySU9NRXhGd0k5bk1O?=
 =?utf-8?B?YnVjQllhWElscU9wZzVsclNrMGh6RWg1cjQzV1BQMk1vdjNhSHhmdHNxZ1hP?=
 =?utf-8?B?SzVHQy85M1RWZVkxcjBIUkE0K05jRGljazFmM2ZsbVN4MFVSWkhmanlXT2NQ?=
 =?utf-8?B?Z0Zmc2R5SXg1RFIzdHZTODdlWDdwaU1KNXVRRytHNjkyS0JLZ08xd3grYUVX?=
 =?utf-8?B?OUQwbE8xRFR2eG9PUEZhb0E2K2xFR3pmb2EydVVKQjA3VUxHRWlCU2tqTHor?=
 =?utf-8?B?YndxcERZazlVMXdhMzlqdkZIaWdTeUI5VnVoWDk3NkQyQ2RmTUVjMHFoVGx2?=
 =?utf-8?B?WmgyZnZsUm1GdCtZK0JXR2xRaFg0VUhrbHBOdHpVSi9wWlo2ak5TQmxaQnFP?=
 =?utf-8?B?WDJqdmVUdU1vWFVkRVZEMlRwRjdzZkc3VjUvdHdFdEZ4Wk9jWTVndUNUSklK?=
 =?utf-8?B?MXRMdGZxMndTcjkrWGFmVTRyRGhDSUYyUmlXbGFiODFNVExIaldCN1hMVzda?=
 =?utf-8?B?eVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CAED996FD9ADE04F886B52B9C2B69FA0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cde712db-31e0-4a42-a4ff-08db5ac54426
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2023 13:05:50.1010
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aJFB2M1GuheHTyL/JNPvva7nbFL4pGaQHJsnVPPALJsPaiUwJBAD2picbcCzrJhl8lF9M3o9i26xGWZLzfn4DA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5472
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIzLTA1LTEyIGF0IDE2OjUwIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBBc3NlcnQgdGhhdCBJUlFzIGFyZSBkaXNhYmxlZCB3aGVuIHR1cm5pbmcgb2ZmIHZp
cnR1YWxpemF0aW9uIGluIGFuDQo+IGVtZXJnZW5jeS4gIEtWTSBlbmFibGVzIGhhcmR3YXJlIHZp
YSBvbl9lYWNoX2NwdSgpLCBpLmUuIGNvdWxkIHJlLWVuYWJsZQ0KPiBoYXJkd2FyZSBpZiBhIHBl
bmRpbmcgSVBJIHdlcmUgZGVsaXZlcmVkIGFmdGVyIGRpc2FibGluZyB2aXJ0dWFsaXphdGlvbi4N
Cj4gDQo+IFJlbW92ZSBhIG1pc2xlYWRpbmcgY29tbWVudCBmcm9tIGVtZXJnZW5jeV9yZWJvb3Rf
ZGlzYWJsZV92aXJ0dWFsaXphdGlvbigpDQo+IGFib3V0ICJqdXN0IiBuZWVkaW5nIHRvIGd1YXJh
bnRlZSB0aGUgQ1BVIGlzIHN0YWJsZSAoc2VlIGFib3ZlKS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6
IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUuY29tPg0KDQpSZXZpZXdlZC1ieTog
S2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwuY29tPg0KDQo+IC0tLQ0KPiAgYXJjaC94ODYva2Vy
bmVsL3JlYm9vdC5jIHwgOCArKysrKysrLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDcgaW5zZXJ0aW9u
cygrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC9y
ZWJvb3QuYyBiL2FyY2gveDg2L2tlcm5lbC9yZWJvb3QuYw0KPiBpbmRleCAyMGY3YmRhYmM1MmUu
LmZkZGZlYTVmMWQyMCAxMDA2NDQNCj4gLS0tIGEvYXJjaC94ODYva2VybmVsL3JlYm9vdC5jDQo+
ICsrKyBiL2FyY2gveDg2L2tlcm5lbC9yZWJvb3QuYw0KPiBAQCAtNTMxLDcgKzUzMSw2IEBAIHN0
YXRpYyBpbmxpbmUgdm9pZCBubWlfc2hvb3Rkb3duX2NwdXNfb25fcmVzdGFydCh2b2lkKTsNCj4g
IA0KPiAgc3RhdGljIHZvaWQgZW1lcmdlbmN5X3JlYm9vdF9kaXNhYmxlX3ZpcnR1YWxpemF0aW9u
KHZvaWQpDQo+ICB7DQo+IC0JLyogSnVzdCBtYWtlIHN1cmUgd2Ugd29uJ3QgY2hhbmdlIENQVXMg
d2hpbGUgZG9pbmcgdGhpcyAqLw0KPiAgCWxvY2FsX2lycV9kaXNhYmxlKCk7DQo+ICANCj4gIAkv
Kg0KPiBAQCAtODIwLDYgKzgxOSwxMyBAQCB2b2lkIGNwdV9lbWVyZ2VuY3lfZGlzYWJsZV92aXJ0
dWFsaXphdGlvbih2b2lkKQ0KPiAgew0KPiAgCWNwdV9lbWVyZ2VuY3lfdmlydF9jYiAqY2FsbGJh
Y2s7DQo+ICANCj4gKwkvKg0KPiArCSAqIElSUXMgbXVzdCBiZSBkaXNhYmxlZCBhcyBLVk0gZW5h
YmxlcyB2aXJ0dWFsaXphdGlvbiBpbiBoYXJkd2FyZSB2aWENCj4gKwkgKiBmdW5jdGlvbiBjYWxs
IElQSXMsIGkuZS4gSVJRcyBuZWVkIHRvIGJlIGRpc2FibGVkIHRvIGd1YXJhbnRlZQ0KPiArCSAq
IHZpcnR1YWxpemF0aW9uIHN0YXlzIGRpc2FibGVkLg0KPiArCSAqLw0KPiArCWxvY2tkZXBfYXNz
ZXJ0X2lycXNfZGlzYWJsZWQoKTsNCj4gKw0KPiAgCXJjdV9yZWFkX2xvY2soKTsNCj4gIAljYWxs
YmFjayA9IHJjdV9kZXJlZmVyZW5jZShjcHVfZW1lcmdlbmN5X3ZpcnRfY2FsbGJhY2spOw0KPiAg
CWlmIChjYWxsYmFjaykNCj4gLS0gDQo+IDIuNDAuMS42MDYuZ2E0YjFiMTI4ZDYtZ29vZw0KPiAN
Cg0K
