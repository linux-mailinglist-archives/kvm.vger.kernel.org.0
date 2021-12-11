Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E144047112D
	for <lists+kvm@lfdr.de>; Sat, 11 Dec 2021 04:23:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244548AbhLKD1D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 22:27:03 -0500
Received: from mga06.intel.com ([134.134.136.31]:50106 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244455AbhLKD1C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 22:27:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639193006; x=1670729006;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JwYdOhYZsxWhZAUsgCp36qDhv2bQ5Nq7cwKsW5e/UKs=;
  b=RtflJK6f/zJ732ow21lCo//Z9pBX/ORs7biRECahgZoGlqOtzfx2Ev04
   3i3iU+rHFm1jlV8D75R8z7O/lA5Q7PEifrghsxF7fcQCYK5tq2b7SeWLY
   YtZgo5Tn09yZm28hPWeVPQx9a9VSZ/esms1Yt7WODh2+xCSZlJfGUgNAI
   3DQeLbUmcyNJ2hHxHLuCfUIGQSTL10zadDIJdZV4KSdk4Q2yzyHjLBDni
   GprpQtCpUahubQDHdaBarGsuRIwWQL/28AFWRAIQM6ZDW0+PCvazk7W+0
   s8GnAVGdDO21Dyw302+QBN3iVC13A+W8CsFovsSONQ/3bQZ+nseenXdtt
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10194"; a="299289049"
X-IronPort-AV: E=Sophos;i="5.88,197,1635231600"; 
   d="scan'208";a="299289049"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2021 19:23:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,197,1635231600"; 
   d="scan'208";a="504196937"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga007.jf.intel.com with ESMTP; 10 Dec 2021 19:23:26 -0800
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 10 Dec 2021 19:23:25 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Fri, 10 Dec 2021 19:23:25 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.106)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Fri, 10 Dec 2021 19:23:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tjh5nitDNLzUxPczAXkjDOoF7ambl7AQcchQvsChc1MyqLX4ot0WjZzcZvsdGrFm1xKFogySBGbdIfQ5v5coLo3ESmf9kplCh5ZgejrKJfEykIQ94XY7S1LFro36zoqpTeKfH+SEG1xuBKDZV8LswYBGhoe35TggzLiXFuOkHDv6KtwjTdhE5fbkc53V5CUUwThU36vi/NuV0txvNhZTQHRLdeUjGkCry2nV8ocnVm3DaOGFsdqbfFVz9hGpx0mV3Fh7yST4wg2Q2Ds0m1Oi3+ViHqhRRHU6nrMC79rcxmjSC4wzpQfsdL93jZ9g4tF9CTzfSYSwl9EynrheJW6veQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JwYdOhYZsxWhZAUsgCp36qDhv2bQ5Nq7cwKsW5e/UKs=;
 b=SN7l8AZbnGH2MTEqO1gZIA379If7+k/agD92J8oxmZALFWaRuzXL4ey2y5d/6zbQjpkMAWKX8+tCF+FwhqxLxC+oaFWEUE3PYvVRXaobvSM+cdc/t0Q7L02HrBC67cAEmL1giANu4lVkm7yYZ7inMtH8bkE8syeg4nh9Sd6jzqV9lQEKOOIiPEakbZr2spSycuupkAcKYecvv+PKZGo/xPaDwaK7oOJMyq0Tc/qw+MZ0zN9yMTZktK6jdQyX6hBEAzT752wHTAGQQxue007N/zYLCW0/AWZ6Q6BfKPPYdCy1xD8uW1Gz5IoX2LGl/iJReecp9BKua6gh518r4yapyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JwYdOhYZsxWhZAUsgCp36qDhv2bQ5Nq7cwKsW5e/UKs=;
 b=vKIlB/xIH66PmgJGT9kz0woEgWu4f2h6rEvBaR9wCjiWhN9qlrYAfc7AIT8tdOqSwOe4kCiz3NP/xs+8LzaaSvkuDBKCm+a39j6VbiUjUjyXhkk5xUhpbsmjYYDMRTH7ROu+Ps/lG4EXmLJXs4+5gSiYGlvMBw0WA+7W5yHv+4A=
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN9PR11MB5484.namprd11.prod.outlook.com (2603:10b6:408:105::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.22; Sat, 11 Dec
 2021 03:23:23 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04%2]) with mapi id 15.20.4755.016; Sat, 11 Dec 2021
 03:23:23 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Zhong, Yang" <yang.zhong@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
CC:     "seanjc@google.com" <seanjc@google.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "jing2.liu@linux.intel.com" <jing2.liu@linux.intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>
Subject: RE: [PATCH 15/19] kvm: x86: Save and restore guest XFD_ERR properly
Thread-Topic: [PATCH 15/19] kvm: x86: Save and restore guest XFD_ERR properly
Thread-Index: AQHX63yRVs4GDusAIkqrgl6cVTrHdawscB6AgAAWnACAABrZUA==
Date:   Sat, 11 Dec 2021 03:23:23 +0000
Message-ID: <BN9PR11MB52764C77E9BF0E44C27265838C729@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20211208000359.2853257-1-yang.zhong@intel.com>
 <20211208000359.2853257-16-yang.zhong@intel.com> <87pmq4vw54.ffs@tglx>
 <87c26050-9242-e6fb-3fce-b6bde815f76a@redhat.com>
In-Reply-To: <87c26050-9242-e6fb-3fce-b6bde815f76a@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 68308d6e-e99f-4625-dfb4-08d9bc5596b1
x-ms-traffictypediagnostic: BN9PR11MB5484:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BN9PR11MB548422B096650E5C985CD5338C729@BN9PR11MB5484.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PZdsRKK2CN/BfhkzjlvlyHtK0sahxYQPxZM6PdBQt4E9HPPUx2pZtnoCL+Lr75AsMhLW32EPlu3PtttwRMPTWMSNvWDLPri82NKbIYFheIu79LTAGa3SABAdg/yhtMEqLYmReP9/ePC/ik+ba3N0yqV+ieNL5Zw9P+EJ2gIXhmy2/mOrwaAAjoTBMkPLAwwlSpfSAM8wbrcErM5wqhsnnRMcmvZGHump2h2x21/ytu2kwAxLk+Nn7FcNKmJCDSI9bgkyF1pzl7kLBoKtPz92KIjfLCyU9GkDZvR6W5DGqo7oin6oMfIMtw1eRNhF4Zlef/BTV/UaE4x20Bsn3tNRJ3k2kaRPj9aOtMkAbnC+0NJjR1hA9U2b+r4RniKb0Sz1jpTg+d26hhy6IZjzL9Y5gk9SEUlAdD3z/SaBc56N7t9Gagl2JAYXA9gd1BaWilD7P8T/uNhXBQ6vurl8Tl7s7xJwYhDUfMxhPB6xVYB4qpdQV/ZhGWI4DAgkaTor1wuSDlonPSVc+l7x6dNVAs0h4hdfWXTztPEjwiqdzVKqX5epjba8Rk7oQqy97mV1h9Jb6w5MktmOhfJwjBxhRI1E7Xdddw/pXGF9lUF3eDMOyk/CqnVozUnmwOoumVP0U0/gz4q5gw7Yxi57Hn5MIV3M2+IULf7NXQdQsrMIIRAvDI6GUjlJWccOCQl3vDF6fu2xNqg8RScokUKIfsJJOBaEC+Yxc+rP/qbd+km4IUNrrbE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(55016003)(83380400001)(66556008)(64756008)(54906003)(9686003)(66476007)(2906002)(508600001)(82960400001)(66446008)(7416002)(38100700002)(186003)(122000001)(38070700005)(7696005)(52536014)(316002)(5660300002)(76116006)(921005)(8936002)(8676002)(26005)(71200400001)(33656002)(53546011)(86362001)(66946007)(6506007)(110136005)(4744005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?anEvUmhjcjhpTG4yQ0VnOTVPbzVYaTF4VDlWY3ZPOEZaT1hWNzFrM2NhWi9M?=
 =?utf-8?B?RXlYaG1iQjl3MitQZVJLWDE1K01uUWc2RFZoY29WTS9NeVg3amFYbVlQc3Nl?=
 =?utf-8?B?MGJwMFVQYlZWTVJ1K2pDSjh3SlUzc0ZMWXNCQ0dLWkZRaFp3b3VpZXYxS3cr?=
 =?utf-8?B?TzRVNFVtc1d3QXBUYVRIZDRvZ3BiQzEybjVZeWdhTnV4d05Xb1lqSzhmV1pr?=
 =?utf-8?B?Q0ZQbkl2QmNSbjErUTUvUUhHK2NTL2lVckpKU29aQWozODZ1ZXUvNGhKRDJ3?=
 =?utf-8?B?cXlmYlRaVFRjcC96QUtLWmJWa2dtTXpicTBmcElIM1ZBRXBXZGhLUDhPRnRO?=
 =?utf-8?B?VzBxL2tRazRxU2V3RW05b0tUZ1pwOVV3anczZFZ4WjhTR0lySGdUTDBFRU4x?=
 =?utf-8?B?Q294aEpNVlVtWEVvMFZEYmxTV3ZsWWJuQVlLVWkrUzFRaWRHVDQvNDhpeFg5?=
 =?utf-8?B?TjJtblhka1BuRTFPV2xwZGR0ZlFzY1N3VU9TM0p2SExweDlBMkh1Q0pvc0t0?=
 =?utf-8?B?WCtobmtWUEd1KzdMOUd3Q1g4WDdTZ2ZHc2ZFTm1lL2w5M29NQkdRUkg0QVFI?=
 =?utf-8?B?ZzkvM2FWQmRHTUw1dTJ6ZCtDbzMxNmZEUmRWdVhrM0RCSWpsSStmT2lGUG43?=
 =?utf-8?B?YjV0ZTVlRjNtWGtjMFo2Sy9IbUpISHcydGVVYzcvWng0SXE1MGFxZ0piNk56?=
 =?utf-8?B?ZUFuWkpjTzFIak9lQXlrUDM3WG44RFFiL1ZSbWNjMEJsMW9QY2VZVDFzUEJB?=
 =?utf-8?B?dTZuV0FHV3lwelNZM1VmeHFSSDNwR0xaL2luQkFWNXJzekNkM0tKMmJrZXd1?=
 =?utf-8?B?N0JQSG9Hbm1CWkJHOWM2T1NqcWlnQ0RKM1dUUnlZVm1qZFl1TlAxMmtDRG9M?=
 =?utf-8?B?N2pMSVJYU21GUWdWR0dTY3N2ZEJVVnBaMldGQlgvN0Qxc0FUME50dnV3T3I4?=
 =?utf-8?B?c01XcFpBcU1sWHR5cU51UUk4M0ZtM0JtSHBibjRWVDJwWHEvQ1AzRHJvbU1I?=
 =?utf-8?B?OXpkRFA3Z0dNczFhMEoyTlorT2ZmSUxlSjR1cXptMkVnUFVKd1d2NzRhd05P?=
 =?utf-8?B?ZkdIRFMvZUxqK0VCOG9pUTMwcUsreVdZYXNuNnAyeGhVdDl5NHo5Y2wzeVJy?=
 =?utf-8?B?ZUNsMkdGeGFMamgzYnlyc0JvUXhqRWc5Yyt0bWp2UTlLQ0hBakxmeTI3OG45?=
 =?utf-8?B?NjQyQy92bVk3UFp3L0RnS293RTh3YmVtd0dadGxvZW1zbHpGK0Z0QmtvVCt4?=
 =?utf-8?B?VVY3M1A2djZwaUdwalhFWUN2K1VRYWhoYlliRkI4S1JiNWQxbUVINzc1UERK?=
 =?utf-8?B?V0RlWjE2THo3Rml0WG5nUWNsbitoYk9mbnBMQ1pGRlpXMnh5RFJqaWdBRmZC?=
 =?utf-8?B?UmlTM3RmRlhGY3ZkeFFPVVJXcXhHeWkyVGc3a0ZnaDhUM3FFNzBJTXJZSUJ4?=
 =?utf-8?B?V2kvYXFRUlFGM1BIMC9hRXowc1FCRkpzVUlndmczTENEaWNwRjh3UnBGdGRY?=
 =?utf-8?B?N3ZVdWI5YVZsTUpnazRTQ1dFUzVtOGkrVytIMWtQckd0VXVSek5XUXJPWXl0?=
 =?utf-8?B?L2dDQnZ5L1A1NWhJQjUrcGJuRjZJRFJWTS9UekIrYmlUay9HRmt6aDRMTFpF?=
 =?utf-8?B?T1pBZXhFd1BlaVAzWjNHdElsQUtTcnhKMDZZK2xCejRGeU91SWZRUmhHK2pI?=
 =?utf-8?B?UFNwYlppcGhoc1A4VFRLWXFqMnVEbld4d1ZkbXhtUUlWcHVjNllzSDdHc3FQ?=
 =?utf-8?B?TVRiVFhSak1Ya2pEWitOd3FZUDNKK1BjdWhEeFBVNXMwUVZDdGJmRS9vQWc2?=
 =?utf-8?B?a3I0eis4c1BWc1JEUlIrRzFHdWZpelJyUXBVaEloeTI2RXlLT1NlOEV5eDBx?=
 =?utf-8?B?MUJIOExHbXM2YzNYUWd5WHkyNHMrZm5KZG5XZis4QWxuZXBoNUl3TXJGa2Fv?=
 =?utf-8?B?d2UrUVdRVFBwUG14SVIxRlpjK2lsbHFNbHMrNzZEQ0RQbEgxQ3A5MzJSNEt4?=
 =?utf-8?B?SUxmelJqNGNlOVdtSDNJTms0UjJSK2kwL1hWek1zYnNIUUdBWCtPNmpQZlp4?=
 =?utf-8?B?N0daSzRia282dU1XN2oxNzN6eFB1czljWUs0eFJZaE0xMDRBVDZZTUVJWnpL?=
 =?utf-8?B?V2NZbW1jckwrVmdpeWFJQ0tWKytlZm11enoyckxiSFhzRyswYW5SSWludUlk?=
 =?utf-8?B?U1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68308d6e-e99f-4625-dfb4-08d9bc5596b1
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Dec 2021 03:23:23.4255
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bUvry1jYnJh0gX8XqaPXB4ogaXg4SeVCwLqzB0aqEV6/Kylx8AiOEE6z8ymIr+gF0yuLX230UH2+P7akVbmlLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5484
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBQYW9sbyBCb256aW5pDQo+IFNlbnQ6IFNhdHVyZGF5LCBEZWNlbWJlciAxMSwgMjAy
MSA5OjMyIEFNDQo+IA0KPiBPbiAxMi8xMS8yMSAwMToxMCwgVGhvbWFzIEdsZWl4bmVyIHdyb3Rl
Og0KPiA+ICAgICAgMikgV2hlbiB0aGUgZ3Vlc3QgdHJpZ2dlcnMgI05NIGlzIHRha2VzIGFuIFZN
RVhJVCBhbmQgdGhlIGhvc3QNCj4gPiAgICAgICAgIGRvZXM6DQo+ID4NCj4gPiAgICAgICAgICAg
ICAgICAgIHJkbXNybChNU1JfWEZEX0VSUiwgdmNwdS0+YXJjaC5ndWVzdF9mcHUueGZkX2Vycik7
DQo+ID4NCj4gPiAgICAgICAgIGluamVjdHMgdGhlICNOTSBhbmQgZ29lcyBvbi4NCj4gPg0KPiA+
ICAgICAgMykgV2hlbiB0aGUgZ3Vlc3Qgd3JpdGVzIHRvIE1TUl9YRkRfRVJSIGl0IHRha2VzIGFu
IFZNRVhJVCBhbmQNCj4gPiAgICAgICAgIHRoZSBob3N0IGRvZXM6DQo+ID4NCj4gPiAgICAgICAg
ICAgICB2Y3B1LT5hcmNoLmd1ZXN0X2ZwdS54ZmRfZXJyID0gbXNydmFsOw0KPiA+ICAgICAgICAg
ICAgIHdybXNybChNU1JfWEZEX0VSUiwgbXNydmFsKTsNCj4gDQo+IE5vIHdybXNybCBoZXJlIEkg
dGhpbmssIHRoZSBob3N0IHZhbHVlIGlzIDAgYW5kIHNob3VsZCBzdGF5IHNvLiAgSW5zdGVhZA0K
PiB0aGUgd3Jtc3JsIHdpbGwgaGFwcGVuIHRoZSBuZXh0IHRpbWUgdGhlIFZDUFUgbG9vcCBpcyBl
bnRyZWQuDQo+IA0KDQpUbyBlbGFib3JhdGUgSSBndWVzcyB0aGUgcmVhc29uIGlzIGJlY2F1c2Ug
TVNSX1hGRF9FUlIgc2hvdWxkIA0KYWx3YXlzIGNvbnRhaW4gaG9zdCB2YWx1ZSAwIGFmdGVyIHBy
ZWVtcHRpb24gaXMgZW5hYmxlZCwgd2hpbGUgDQpXUk1TUiBlbXVsYXRpb24gaXMgY2FsbGVkIHdp
dGggcHJlZW1wdGlvbiBlbmFibGVkLiBUaGVuIHdlIA0KanVzdCBuZWVkIHdhaXQgZm9yIHRoZSBu
ZXh0IHRpbWUgdGhlIHZjcHUgbG9vcCBpcyBlbnRlcmVkIHRvIA0KcmVzdG9yZSB0aGUgZ3Vlc3Qg
dmFsdWUgYWZ0ZXIgcHJlZW1wdGlvbiBpcyBkaXNhYmxlZC4g8J+Yig0KDQpUaGFua3MNCktldmlu
DQo=
