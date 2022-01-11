Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF76948A549
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 02:46:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346331AbiAKBqo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 20:46:44 -0500
Received: from mga12.intel.com ([192.55.52.136]:22854 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243903AbiAKBqn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jan 2022 20:46:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641865603; x=1673401603;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=MHx77Yu2WYG3KrQIxJCOvwQz14nQgTzWSGzfznv4fMA=;
  b=fPwxvJ72byo9wzREjY+hGcM70YZn7ZGpszr7eYDsndIoQzGpKhOQdcRl
   sbjY2EF7udntRcad3Pig9OxEVu+dzV9qgBu3IxrvjjLH6B2z1yMD6crVH
   Tu2Ij/FGetNGz+Q9nMHSFr5PZIj8QXtcTvoqjnlIH6YnDHHkt75LoBgMM
   /YfUuPCn4LdCD+PQ867YjcRDXxZSTmxAx3O8djO+Ia2U77xksEhA6w10l
   8qbOvrVBzF95I5ALFf+aiZxx2ARwFSbOKbaMB/LAyNY3ZwRNgctqiXCHu
   zu8gHDqZpGXqvDVcPnPdqHyZNTYOOmQebLUqKY53ookWy9LQS5qserpoG
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10223"; a="223361737"
X-IronPort-AV: E=Sophos;i="5.88,278,1635231600"; 
   d="scan'208";a="223361737"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2022 17:46:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,278,1635231600"; 
   d="scan'208";a="619648243"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga002.fm.intel.com with ESMTP; 10 Jan 2022 17:46:43 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 10 Jan 2022 17:46:42 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Mon, 10 Jan 2022 17:46:42 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.108)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Mon, 10 Jan 2022 17:46:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U6N72KiLfNEcu0eW9OPymQ2+smFUySfnpyyU67CATQN6GbEBCyVhU0nWqt2Lw2lkmoO0qdlHkGlT4C/SPGsVz5eIQ9lIOWSRoPav0SNilBiNlWTWgVuKvR1FuUP8LneUB0o/EDIYrLjQMFqLfVfPnHblm8JxH6bP2mya+SA+JYjIOnyM6nTtR+s7hsIOba7F0lPSHdzDDJnyBqvj6OJss4MDF0QbABbEEKgXJUON4rRizN+pQqIam+rsvZNxuDtvyuqxg6r+QRU4Busevgy9nz/uO5lofH99OxaZI2f9jtri7penjfcCpz/NQ6MuZFnJFHFovcp/0x4oejOoqLDDfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MHx77Yu2WYG3KrQIxJCOvwQz14nQgTzWSGzfznv4fMA=;
 b=HRlrf9xhBL8tzX7JYQhNOEwsr2Izd9xgupICBqnLPreTEoVGerEH9aZ7271546P2HRLtvTrYt4XHITObY3Q6ZnGTxvkXyvlH9S+mqiDh15RJJ+7NWy1zI4O0Lz8aQBLi/VVEFLiufOhyO38NlsbYqAgLyu7TvMt9JKxcSFrLjgKIz1pdyB2ojnEyrU6riMT653CsnX56rXgYETCvRUS+2YHP11SCD2WB9qOJF2mWdCxoPKxOcvzdYHA16Is5k1NBzoYpj8jxcS9pPcdG8DD+7YJpGTr/FoGX9HnJkC2Xa13xU/wCE1Vbpbh0pTB4GIeMaeHgChC+8hOb4nSvlzwrzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN6PR11MB1745.namprd11.prod.outlook.com (2603:10b6:404:103::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Tue, 11 Jan
 2022 01:45:47 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04%2]) with mapi id 15.20.4867.012; Tue, 11 Jan 2022
 01:45:47 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Borislav Petkov <bp@alien8.de>, Paolo Bonzini <pbonzini@redhat.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Zeng, Guang" <guang.zeng@intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        "Zhong, Yang" <yang.zhong@intel.com>
Subject: RE: [PATCH v6 05/21] x86/fpu: Make XFD initialization in
 __fpstate_reset() a function argument
Thread-Topic: [PATCH v6 05/21] x86/fpu: Make XFD initialization in
 __fpstate_reset() a function argument
Thread-Index: AQHYA/gpzyW8+ydO5UO/RNIfEDi71KxX9ceAgAO5JdCAAEf1AIAAWwwAgAASngCAAAhegIAAKC2AgAB3BLA=
Date:   Tue, 11 Jan 2022 01:45:47 +0000
Message-ID: <BN9PR11MB5276F6F3325A20E78E8DC0D58C519@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220107185512.25321-1-pbonzini@redhat.com>
 <20220107185512.25321-6-pbonzini@redhat.com> <YdiX5y4KxQ7GY7xn@zn.tnic>
 <BN9PR11MB527688406C0BDCF093C718858C509@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Ydvz0g+Bdys5JyS9@zn.tnic> <761a554a-d13f-f1fb-4faf-ca7ed28d4d3a@redhat.com>
 <YdxP0FVWEJa/vrPk@zn.tnic> <7994877a-0c46-07a5-eab0-0a8dd6244e9a@redhat.com>
 <Ydx4icAIOY6MFhLj@zn.tnic>
In-Reply-To: <Ydx4icAIOY6MFhLj@zn.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5279ff2f-8c28-4f61-66b6-08d9d4a416ef
x-ms-traffictypediagnostic: BN6PR11MB1745:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BN6PR11MB174523645A5CF073BAA5DB748C519@BN6PR11MB1745.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nprRRlRXH4tTcTDothWYkS1ozf11BsGy1WwmRi0hc+iiMPLTcRPHS/5ebtsT3iqHbbu7LIofkzGOiQwB1joPlouWnqsrgS7zGKRBgXXiaZXi0Bd3o8R/eJF4uBvGbMl3SYgnPDoPey12dmujkUZMWWvBcyWG8V9Hqs2dtME8G+xUlTnmJ+jmi6FFptIZ91776IndsNwliw5D9MGBeA4q1Ud26Bi/lhWBECW8e7ujOxL5r+dz63551OMhOrMC6OKZ4AbaDISYsE6hFI+YaKk4BsRAaWzMuLdYg2oA6uAh+E6bQhSSXS5ZXaqAKscVogUAagyK6gtXx4KzjyTAJ9S6b4eO1ZPN7nVJ7T9Bkd9DrBHLtTsGhwyVJkCK6RGVMmSTw0Yh6WAO9ejrMJIKz/QUd4+cTkvhY6y5mGDorDGC5MOtZDs6/v/wiIe1Y7QlKhVk0T8/QC+XQEk7cSqA/lGZuM4KxvoYp/pkLikUsAVJ6/DwDBP4qhT1lLGFrpCdIJptDdBwtxaEj0mZ2qA0zcJAuymPAcm1eWJSAJWTlWAIXccbwX2fNNGtbL4nCvBoS7Zb+ejD1086AQiDkeFRWe1/QEooyqqoCk624vQA0gjAn4nWTGwstmrDMCAyPQSQ60IIh6nSxeyeXhQeF7fK8Y6SioKDhWtHCnY3sVCOWJJQ1cbe/9eG1r/q2TWUIK0mZ7mNUUrru0NBugrjQZU9q4tELw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(52536014)(38100700002)(316002)(71200400001)(86362001)(8676002)(7696005)(6506007)(82960400001)(33656002)(107886003)(26005)(66946007)(2906002)(186003)(8936002)(110136005)(76116006)(54906003)(66446008)(66556008)(38070700005)(64756008)(55016003)(4326008)(9686003)(66476007)(122000001)(508600001)(5660300002)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TVNXb2IzY3JZK0VMallFNk1TVjh1UWcrWk5sRkdqVzZJQ1UvMVlULzhtRWQ3?=
 =?utf-8?B?ang3NWNpY0FkU0xCNGQ5MTM2SGw0UGt5MHJnaFZyYjU5SHdqQVJSRkNWVXFn?=
 =?utf-8?B?eGd4S05rSm1iWkJ4bDF4TG1XSHFGZWtrQm9JN2NJZ2xxUnhWQ1JRRGE2Q29q?=
 =?utf-8?B?ak4zOE1BSi80dmZoWUlrRHRCYitJUWJZa2RBdlB3OUVQNTRiVHF0MHFFU3RE?=
 =?utf-8?B?ZGQzb0JVWEk2M3RJNHROajZGdXJCVjl2ZUdtZmZiVjRjaFdOcGZnWGhxdDhW?=
 =?utf-8?B?ZzVNejc5Rm4yVGdDYlgxMlZob1ZaZzBscVRYdzZ0MWtQejZqcUg1eEtleUpD?=
 =?utf-8?B?K29GeVNGVlR1UUtrSnFkQkptYUlNeUlMZEF5SGJrMlNaSy9hVTlYeHBrU21n?=
 =?utf-8?B?YzRSWWE1RG1pR051MVhVUkVjSG1mcmN2VmJ0YXVIeXdmVzVFQ1JlcVNINHBJ?=
 =?utf-8?B?eVhXU3R3TEJac0dJd1FOdzFtbUQwUHdaWVFESVc4SjhiUXlCUDc5MjM5eklJ?=
 =?utf-8?B?Tm1ibTVRRWJvNk5OeEx4c3VPZ1dpMTFSOVFlSGZDcXA3VlBxVVU4RXZISVNn?=
 =?utf-8?B?Y2NMdVRoRmVTRExwMXRrZmpubmFaTWVMU2NFRmpzNUxhMHQwMjNKUExGVTdL?=
 =?utf-8?B?YVA2UFlrUFBZNnc2WDJLOXhEeU54RTVwdjBSSDRySU9EWE5QSVVOVDhNNUxI?=
 =?utf-8?B?cVpab2g5a1NtdStsUXVYSTU0WWgrbTI4UTBuNTVaNldNcW51eVpMV2pOWlZz?=
 =?utf-8?B?ZW5VVW92eGJZWjFLU1dRRVdPQTdvREFCZEd1UEJCUmx6NlNrbXo4cC9JT0dN?=
 =?utf-8?B?SjFjTDF5MDBlQ1RLTDZhbUlDOWlGQTZrTWZrbFFPVHM3SHFnZ2RoZnRSUFVC?=
 =?utf-8?B?aTgvYTVDaVBXUXZHckZJOFRla0t2RUx2YmhyYTZpUHA2KzBHcjlaQWgvczdT?=
 =?utf-8?B?dDI1MmNMa1EwOWtzd0R2aU0wRlNwblYwalpzc05DUVVPYmtCVWdTOG5LUVNC?=
 =?utf-8?B?Y1pFQk1yRFNYNFg2VzdyM3diczg3RitRRy9EQlNvMEdEL29EQll4MFE1VUc1?=
 =?utf-8?B?cE1TVUl5czZVK01lWXplYVVkZXU2b3UwOXFGVTluM0pvdVNRNmRtSndaQW92?=
 =?utf-8?B?a0ZUQkdlZUJ0MWZrWEg2OVJvZTFMQjRCTEJLbjBhbE5OM242Q2pKMmZGYjNa?=
 =?utf-8?B?OXVROE5NUVpsS0FLL21CQWJKQXh5bkd4VFlSeXNTWjVKWHM3Wms0eERxaGtV?=
 =?utf-8?B?MmhRMm1iUHo0Z1pvWGVrR2M3bnYyTVQxaUFwWFB2N0tUVHdqdGxJMzhQU2FP?=
 =?utf-8?B?MGtGVzVPcmV0UEMwcHoyOW5KVDZlZ29TcE1uclEyb3JpRmdCbUFIMU1Ebk4z?=
 =?utf-8?B?MHZsWTB4dmJtM21JYUFhRmRUM1NlWndjbEtEQTgwRUNLS3JLdVE3ZGl4R3Y1?=
 =?utf-8?B?WGR4WGJOZjlpd1JUUUhDenU5U09IZFI1ZFl4aXJadWpZT0pWdFRrM0NQc1Ni?=
 =?utf-8?B?dkRyNFdTRXBicGVjLzRpM0dveHZxVTIwOHdqNDE0ZWY1Q3A5ekRNS0VYbmRt?=
 =?utf-8?B?Y2FWcVdISHF4NTdaWmZ3YkRuazhSS0M3VzFlcS9YVlNhNWVHWTJJSFdPbG0x?=
 =?utf-8?B?d2Jud1NnSlVPZXl5bTBuSlNvSlp3ODV3NHZ2dFIrVzJXaVdsK0RrVUpqWW82?=
 =?utf-8?B?V0JRWVlXN1BaQzVrSmZzZ1o5elFhK0I1dFJkWTlrRFZJSmJnNEpXWURDVkp0?=
 =?utf-8?B?R2ZBUWYrZ2hwMXlmTVNTalozZ1VscUVOOWIzeXlzWHBiZFM4MmZEMStTelpB?=
 =?utf-8?B?aFF4N2hDdU1lNFlKZ3B4U0RqQy9oMnh6YTh1YzVEMFZFSUVud1VGamNLNk9Y?=
 =?utf-8?B?SWhLcS9NbzI4M0IzazFZTlEvT1ZHUGx2QzNSYjc4cHl4bTF2TlpUZTFWKzhy?=
 =?utf-8?B?ZnFKYUhSVXBTRHo5amFzSWNUUmxwYkhLNGtkR0VJcElOODBEUStjU1ExSStp?=
 =?utf-8?B?UCtOeEtmRjVQWDZJQ3dId3h2Ukthci9ibTZ6bTFTTUtkSGZqdnZyOGZ2YjJ0?=
 =?utf-8?B?V3RiMW9HNkZoanRrSVJFNXFaelROd1paYVJtSklUUm5XNHB5MTBjMENlYW9j?=
 =?utf-8?B?SWdhUnJ3L1VhcFBPZjlMRFlXbnAyREJiaG1YVmJ2OTZvRU9aR2h0VkJrbXFh?=
 =?utf-8?Q?lV74BfX+h6GtjQ24IbN2yKc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5279ff2f-8c28-4f61-66b6-08d9d4a416ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jan 2022 01:45:47.2048
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /kBAK36/10rXEkyULOJDjkN5iRBIhNo+OUNmcxVNtaxgXnqP4+Ugp6bAD+vONcxYmYpENDQ5L3yW1vZdpuY3Xw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1745
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBCb3Jpc2xhdiBQZXRrb3YgPGJwQGFsaWVuOC5kZT4NCj4gU2VudDogVHVlc2RheSwg
SmFudWFyeSAxMSwgMjAyMiAyOjE5IEFNDQo+IA0KPiBPbiBNb24sIEphbiAxMCwgMjAyMiBhdCAw
NDo1NTowMVBNICswMTAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0KPiA+IFNvIHRoaXMgbWVhbnMg
dGhhdCAidGhlIGF1dGhvciBtdXN0IGJlIHRoZSBmaXJzdCBTb0IiIGlzIG5vdCBhbiBhYnNvbHV0
ZQ0KPiA+IHJ1bGUuICBJbiB0aGUgY2FzZSBvZiB0aGlzIHBhdGNoIHdlIGhhZDoNCj4gPg0KPiA+
IEZyb206IEppbmcgTGl1IDxqaW5nMi5saXVAaW50ZWwuY29tPg0KPiA+IC4uLg0KPiA+IFNpZ25l
ZC1vZmYtYnk6IFRob21hcyBHbGVpeG5lciA8dGdseEBsaW51dHJvbml4LmRlPg0KPiA+IFNpZ25l
ZC1vZmYtYnk6IEppbmcgTGl1IDxqaW5nMi5saXVAaW50ZWwuY29tPg0KPiA+IFNpZ25lZC1vZmYt
Ynk6IFlhbmcgWmhvbmcgPHlhbmcuemhvbmdAaW50ZWwuY29tPg0KPiANCj4gTG9va2luZyBhdCBL
ZXZpbidzIGV4cGxhbmF0aW9uLCB0aGF0IHNob3VsZCBiZToNCj4gDQo+IFNpZ25lZC1vZmYtYnk6
IEppbmcgTGl1IDxqaW5nMi5saXVAaW50ZWwuY29tPgkJIyBhdXRob3INCj4gU2lnbmVkLW9mZi1i
eTogWWFuZyBaaG9uZyA8eWFuZy56aG9uZ0BpbnRlbC5jb20+CSMgdjEgc3VibWl0dGVyDQo+IFNp
Z25lZC1vZmYtYnk6IFRob21hcyBHbGVpeG5lciA8dGdseEBsaW51dHJvbml4LmRlPgkjIGhhbmRs
ZXIvcmV2aWV3ZXINCj4gU2lnbmVkLW9mZi1ieTogSmluZyBMaXUgPGppbmcyLmxpdUBpbnRlbC5j
b20+CQkjIHYyLXYzIHN1Ym1pdHRlcg0KPiBTaWduZWQtb2ZmLWJ5OiBZYW5nIFpob25nIDx5YW5n
Lnpob25nQGludGVsLmNvbT4JIyB2NC12NSBzdWJtaXR0ZXINCj4gDQo+ID4gYW5kIHRoZSBwb3Nz
aWJpbGl0aWVzIGNvdWxkIGJlOg0KPiA+DQo+ID4gMSkgaGF2ZSB0d28gU29CIGxpbmVzIGZvciBK
aW5nIChiZWZvcmUgYW5kIGFmdGVyIFRob21hcykNCj4gPg0KPiA+IDIpIGFkZCBhIENvLWRldmVs
b3BlZC1ieSBmb3IgVGhvbWFzIGFzIHRoZSBmaXJzdCBsaW5lDQo+IA0KPiBJZiBUaG9tYXMgd291
bGQgcHJlZmVyLiBCdXQgdGhlbiBpdCBiZWNvbWVzOg0KPiANCj4gU2lnbmVkLW9mZi1ieTogSmlu
ZyBMaXUgPGppbmcyLmxpdUBpbnRlbC5jb20+ICAgICAgICAgICAjIGF1dGhvcg0KPiBTaWduZWQt
b2ZmLWJ5OiBZYW5nIFpob25nIDx5YW5nLnpob25nQGludGVsLmNvbT4gICAgICAgICMgdjEgc3Vi
bWl0dGVyDQo+IENvLWRldmVsb3BlZC1ieTogVGhvbWFzIEdsZWl4bmVyIDx0Z2x4QGxpbnV0cm9u
aXguZGU+CSMgY28tYXV0aG9yDQo+IFNpZ25lZC1vZmYtYnk6IFRob21hcyBHbGVpeG5lciA8dGds
eEBsaW51dHJvbml4LmRlPiAgICAgIyBoYW5kbGVyL3Jldmlld2VyDQo+IFNpZ25lZC1vZmYtYnk6
IEppbmcgTGl1IDxqaW5nMi5saXVAaW50ZWwuY29tPiAgICAgICAgICAgIyB2Mi12MyBzdWJtaXR0
ZXINCj4gU2lnbmVkLW9mZi1ieTogWWFuZyBaaG9uZyA8eWFuZy56aG9uZ0BpbnRlbC5jb20+ICAg
ICAgICAjIHY0LXY1IHN1Ym1pdHRlcg0KPiANCj4gYW5kIHRoYXQgbWVhbnMsIFRob21hcyB3b3Jr
ZWQgb24gdGhhdCBwYXRjaCAqYWZ0ZXIqIFlhbmcgc3VibWl0dGVkIHYxLg0KPiBXaGljaCBpcyB0
aGUgZXhhY3QgY2hyb25vbG9naWNhbCBvcmRlciwgYXMgS2V2aW4gd3JpdGVzLg0KPiANCj4gPiAz
KSBkbyBleGFjdGx5IHdoYXQgdGhlIGdhbmcgZGlkICgicmVtYWluIHByYWN0aWNhbCBhbmQgZG8g
b25seSBhbiBTT0INCj4gPiBjaGFpbiIpDQo+IA0KPiBZZXMsIGJ1dCBub3QgY2hhbmdlIHRoZSBT
T0Igb3JkZXIuDQo+IA0KPiBCZWNhdXNlIGlmIHlvdSBkbyB0aGF0LCB0aGVuIGl0IGRvZXNuJ3Qg
c3RhdGUgd2hhdCB0aGUgZXhhY3QgcGF0aCB3YXMNCj4gdGhlIHBhdGNoIHRvb2sgYW5kIGhvdyBp
dCBlbmRlZCB1cCB1cHN0cmVhbS4gQW5kIGR1ZSB0byBwYXN0IGZ1biBzdG9yaWVzDQo+IHdpdGgg
U0NPLCB3ZSB3YW50IHRvIHRyYWNrIGV4YWN0bHkgaG93IGEgcGF0Y2ggZW5kZWQgdXAgdXBzdHJl
YW0uIEFuZCBJDQo+IHRoaW5rIHRoaXMgaXMgdGhlIG1vc3QgaW1wb3J0YW50IGFzcGVjdCBvZiB0
aG9zZSBTT0IgY2hhaW5zLg0KPiANCg0KVGhpcyBpcyBleGFjdGx5IHdoYXQgd2UnZCBsaWtlIHRv
IGdldCBjbGFyaWZpZWQgaW4gdGhpcyB2ZXJ5IHNwZWNpYWwgY2FzZS4NCg0KU2luY2UgVGhvbWFz
IGRpZG4ndCBwdXQgYSBDby1kZXZlbG9wZWQtYnkgaW4gdGhlIGZpcnN0IHBsYWNlLCBJIHByZWZl
ciB0bw0KcmVzcGVjdGluZyBoaXMgY2hvaWNlIGkuZS46DQoNCglGcm9tOiBKaW5nIExpdSA8amlu
ZzIubGl1QGludGVsLmNvbT4NCg0KCVNpZ25lZC1vZmYtYnk6IEppbmcgTGl1IDxqaW5nMi5saXVA
aW50ZWwuY29tPg0KCVNpZ25lZC1vZmYtYnk6IFlhbmcgWmhvbmcgPHlhbmcuemhvbmdAaW50ZWwu
Y29tPg0KCVNpZ25lZC1vZmYtYnk6IFRob21hcyBHbGVpeG5lciA8dGdseEBsaW51dHJvbml4LmRl
Pg0KCVNpZ25lZC1vZmYtYnk6IEppbmcgTGl1IDxqaW5nMi5saXVAaW50ZWwuY29tPg0KCVNpZ25l
ZC1vZmYtYnk6IFlhbmcgWmhvbmcgPHlhbmcuemhvbmdAaW50ZWwuY29tPg0KDQpGb2xsb3dpbmcg
dGhpcyBydWxlIHRoZW4gdGhlIFNvQiBvcmRlciBpbiBhbGwgb3RoZXIgcGF0Y2hlcyBhbHNvIG5l
ZWQNCmJlIGZpeGVkLCBlLmcuIGJvdGggSmluZydzIG5hbWUgYW5kIFlhbmcncyBuYW1lIHdpbGwg
b2NjdXIgdHdpY2UNCnRvIHJlZmxlY3QgdGhlIGNocm9ub2xvZ2ljYWwgb3JkZXIgaW4gbW9zdCBw
YXRjaGVzLiBCdXQgSSdtIG5vdCBzdXJlIA0Kd2hhdCdzIHRoZSBiZXN0IHdheSB0byBoYW5kbGUg
aXQgc2luY2UgUGFvbG8gYWxyZWFkeSBwdXRzIHRoZSBlbnRpcmUgDQpzZXJpZXMgaW4gaGlzIHRp
cC4gDQoNCkNhbiB0aGlzIHNlcmllcyBnZXRzIGFuIGV4ZW1wdCBnaXZlbiBhbGwgcGFydGljaXBh
dGVkIG5hbWVzIGFscmVhZHkNCmhhdmUgdGhlaXIgU29CIGluIHRoaXMgc3BlY2lhbCBjYXNlPw0K
DQpJZiBtdXN0IGJlIGZpeGVkIHdlIGNhbiBjZXJ0YWlubHkgcHJvdmlkZSB1cGRhdGVkIFNvQiBo
aXN0b3J5IGZvcg0KZXZlcnkgcGF0Y2guIFRoZSBidXJkZW4gbWlnaHQgYmUgb24gUGFvbG8ncyBz
aWRlIGFuZCBpZiBpdCBkb2VzIGhhcHBlbg0KSSByZWFsbHkgd2FudCB0byBzYXkgc29ycnkgaGVy
ZSBmb3Igbm90IGdldHRpbmcgdGhpcyBvcGVuIGNsYXJpZmllZCBlYXJsaWVyLi4uDQoNClRoYW5r
cw0KS2V2aW4NCg==
