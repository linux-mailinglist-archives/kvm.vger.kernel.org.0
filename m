Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 025CD476734
	for <lists+kvm@lfdr.de>; Thu, 16 Dec 2021 02:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbhLPBEI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Dec 2021 20:04:08 -0500
Received: from mga09.intel.com ([134.134.136.24]:35080 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229441AbhLPBEH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Dec 2021 20:04:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639616647; x=1671152647;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=k1kDqPe20JpgHfKa3ChpGbdgvDMUkzh/PRPbkZfY/2w=;
  b=l9wC1U7oIeZ5Faum7jogNACt2a63CIg1fX3ZPFpsic/qeua8/hYab5Dz
   tm42St85A4XItiRtA+fnxZmA1Nt/vnF8QxnJX6foJrsDoDsO6W8HoaSba
   +w35kBBBjAsyiHa7pwvHpFN8iOkAE1sJc5CmC5mNlIkslD2SDIF+C+Ojp
   2Z0j76ZBZ4mQaAL9cYAvWYA4hyfrfZT6cU+g+93T5y3x/mIZWhvotNLJH
   Il87Nhec7kzTai77dxD2Rx1TA5fE8QqNb2guXaRxfTqGo3rJwbJ6pdreT
   bxtmudoYHFhaT8nzGjtO+7hk2viyRZRwOB5/5HnHEHOSzFv8UCt8d+WHy
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10199"; a="239185079"
X-IronPort-AV: E=Sophos;i="5.88,210,1635231600"; 
   d="scan'208";a="239185079"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2021 17:04:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,210,1635231600"; 
   d="scan'208";a="482626593"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga002.jf.intel.com with ESMTP; 15 Dec 2021 17:04:07 -0800
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 15 Dec 2021 17:04:06 -0800
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 15 Dec 2021 17:04:06 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Wed, 15 Dec 2021 17:04:06 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Wed, 15 Dec 2021 17:04:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YWK5Di6CnEMbV+ilAiGAWYuJul5zP/lwRuq+YLI3yENS/4TVKy1wbZNVu1mn7MGHaydgPi7wvC1TkBQKbDaYW+E8U0I/RcrGtx/1oLDC2ltK4jxT7dmRW2XhYQJig7DvN5iaSHYAy6KiOTGshqymWhMX1lQ8Axhb/h8v1w6y0tefaQTLu0fvcaa0H7Ky1HpZpKpYwlQz2MNEpMFtM24uBW7XmAbw0hXvwyK+N3G3NzppFoaGWO1vHv+HK0HQ3fS4eXfLzZcshs3glpYhqhb7p6zhDFGyAz76ouLhAfMcR2T9TwuRehFrwQPxZbbuAmtrYjezC7msgK6nzELzJiJCcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k1kDqPe20JpgHfKa3ChpGbdgvDMUkzh/PRPbkZfY/2w=;
 b=iPUsa1yS951Ef5j/qNru+35zAYNasGcMmhJEKFpA047bc92xmzAByMyi2wDvd+a2uL+lDtBBPf/NXE9T1ea/GALp+W8AvVT8BkcPA72pIbfySF4wjKBZ5tUa7Wl7EdZLXQ/X8DM9Rd7UsB9L98u5oWj2TbvahWpQZRTTWKOOarsJjUBSLyYuby8xJKrugV6egwBqODFIgPo8ttmX4GZqaCZVw7wHCrlo2GfvQ1kmq4BMeZ33QsSiRyoJ+FShkFct/iNO2cp7LTVwH5Tu7JJcMbULdKl1MPcZVeYNE9JEtJykqTPHdgoUpoVEFCSlFBxXjdbqi5DnG+RThpr9dMte7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN6PR11MB3937.namprd11.prod.outlook.com (2603:10b6:405:77::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Thu, 16 Dec
 2021 01:04:01 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04%3]) with mapi id 15.20.4778.018; Thu, 16 Dec 2021
 01:04:01 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        "quintela@redhat.com" <quintela@redhat.com>
CC:     LKML <linux-kernel@vger.kernel.org>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Jing Liu <jing2.liu@linux.intel.com>,
        "Zhong, Yang" <yang.zhong@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "Zeng, Guang" <guang.zeng@intel.com>
Subject: RE: [patch 5/6] x86/fpu: Provide fpu_update_guest_xcr0/xfd()
Thread-Topic: [patch 5/6] x86/fpu: Provide fpu_update_guest_xcr0/xfd()
Thread-Index: AQHX8JViV3rUbi5iYUCgo3JeBUJUo6wyGCEAgAAIi4CAAAi/gIAAH5YAgAAT0FyAABRSAIAAEuhSgABOroCAAIPaAIAABQ6AgADz3EA=
Date:   Thu, 16 Dec 2021 01:04:01 +0000
Message-ID: <BN9PR11MB5276E2165EB86520520D54FD8C779@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20211214022825.563892248@linutronix.de>
 <20211214024948.048572883@linutronix.de>
 <854480525e7f4f3baeba09ec6a864b80@intel.com> <87zgp3ry8i.ffs@tglx>
 <b3ac7ba45c984cf39783e33e0c25274d@intel.com> <87r1afrrjx.ffs@tglx>
 <87k0g7qa3t.fsf@secure.mitica> <87k0g7rkwj.ffs@tglx>
 <878rwm7tu8.fsf@secure.mitica> <afeba57f71f742b88aac3f01800086f9@intel.com>
 <878rwmrxgb.ffs@tglx> <a4fbf9f8-8876-f58c-d2b6-15add35bedd0@redhat.com>
In-Reply-To: <a4fbf9f8-8876-f58c-d2b6-15add35bedd0@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0bc1b04e-457a-4ceb-b8ff-08d9c02ff272
x-ms-traffictypediagnostic: BN6PR11MB3937:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BN6PR11MB3937EAF151DEBB8CAB1CE8DF8C779@BN6PR11MB3937.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: D2hfaCm0Z5xVsYeivJxpwgcdw59Dbpw3bPHYXhkatZqsar5Flzyj9LvG4SGo8r+oL7KNM4zyF9pk3+Dlt6BwF3YBqILEJ8yGxgrOpE7+4ZSeyXddNtPlPFIdL24VlL5IAxnF7sPoVmjg7o2aidra06Q+YBojY8NrVLnrvsessjVGm9PbSTuY2wLXkSW8vMPOj+vVYfvTjnl6IJUy8w+r8GbgNYmVAC/a3Yydrz1Nu4druO10jFnvRi1TF6p73mwq7FD5TSZxO3MYGiJrOw8Uu456VWGBk9ehlF4+wkkWjQBe7lQEudTcxrKSh/ka+/AM6tzBjWfYY0K8NlkuS0elfKJu5F6WedGstV6SnTZcV17Nn/CazwaIKTtgocANx/n7w2skiQ8LhDBRbhv0RsTV0TXmE2vOrLYVHgCgDVd4bRY1ppwp9lX2rad8TcNTx7BTQ0+tGU2YYzhWrMJfMyE54+7l5JMf15IEqi+JemR8IYeTsaKCbeO/QOfDUVgeNSbAq0P2IdtSTpsz5W0N8P7VMPMi2LllLxyCAghiYFLRfAyrS+WjpGjessxMlnK/Q0vPMihxHUOhsKwEAdG1Eem6F2mAuYTlC0kXa0E6IysfbLNcOYeRw693vL9cCN9LNo4dAE+jplE6l0Gqw4iwfQPTUsUPKUhGYym4QTfZPq/mfRG8H3JZmsa+1JbVPTvE0qjYEykqAH0rth384C21ylmyCA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66556008)(8676002)(71200400001)(38070700005)(33656002)(54906003)(83380400001)(8936002)(4326008)(66476007)(66946007)(508600001)(76116006)(64756008)(55016003)(66446008)(38100700002)(26005)(6506007)(53546011)(122000001)(82960400001)(7696005)(2906002)(186003)(9686003)(86362001)(52536014)(316002)(110136005)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TnpmSDhGMGNnVUVQcDY1aldWQzVXTVdnNFhld29iUnZERGxtZnhPenU4YVJD?=
 =?utf-8?B?SnFieldUdDJ3K1UwNXpMYlBKRDFyUklYcUF6dnlheFFvekpzZFk5UlR0Vmh0?=
 =?utf-8?B?cDdPd3p2WDRjakxkUUlhajFSd3BCYjQ3c3djczVqVk5rK1VxWkdERExkOXFW?=
 =?utf-8?B?TEdPblRDaE4vR2o1SWgzcExvTlloUDBsNlVCdTdqemxuRHJQSlAzNWIydFVw?=
 =?utf-8?B?MXRvaVY2ejE1TG1EMXRPdzRNT0U5cHRGZzdCOEYzYThRV29kaCtOVkVqMzIz?=
 =?utf-8?B?elZ1dFFWV3hJanZNK2JLLzkwZUZ0VGplL05NZG4xbWlFMXFIL2c2NVFiVjVF?=
 =?utf-8?B?RlgrcTVtWVR5RGwvK3pYQlgrZk4wMWVKZDRzOWhkL2RUK2JSUjRWWGVwZEJN?=
 =?utf-8?B?NnlMbStOd3hiN1JRZHU2dDNiMlFNOWl3YnRBVGdqUmlKZy9ER1RpOFhFTTVy?=
 =?utf-8?B?V0d4TzBNd28xK3VmY21Vb2Y5VGpiL2lGT3MyR2RZbVZLcElTQktIazBpMVJq?=
 =?utf-8?B?ZWNURC83TEdhKzBmRjhmeWM1Y0ZtOThqRURXNEZCbGI2aFIzSTdLYU5UeHVr?=
 =?utf-8?B?aGRRRkFsK1VXYjIzWW11Y0s5d09tRjV4VnhyUjJtdUV5dHN2SzVUNVlZOHJX?=
 =?utf-8?B?RnJabk9SK080aXpqbmtpTE1xOHlLOWYycjlCL2JxUzcxemJybVVwZW0wUnZu?=
 =?utf-8?B?UFhQUWl6b3ErNWRMc2c2WXp5U0FjOVhOY3FLekRPYityWHAxRGF5NXI3eFVr?=
 =?utf-8?B?UThUSENvYWwyTnVyRk5Dd3RTT0dibStSWE01Zy9ydW9wS2lJRmpHSXpnaExp?=
 =?utf-8?B?emk1eUFjbU1TenRNdTcwMTNIR1pLVnFPdlE4WjZvSXR6eDhDZzVGQXUzNks0?=
 =?utf-8?B?QkMxdk1GNmhZQ3BZUFBCZ0dyODhxaWRwUkhiVjd5VGFOWDZOQldabE5zSWE2?=
 =?utf-8?B?aTNYSjRLNU9zZzV2cld5cDFQazZHMWpJUS9vMWQ2eEwwb0VLVGZBMEkxZDRW?=
 =?utf-8?B?VmVPL2tRZ2w5ZjEyOEdDWm5KMzUwUkp4Z1MrdG1QRVhFRXh2bjJrcE1FdXAv?=
 =?utf-8?B?cGpUazUyVDhXSjZ3WnlBSFlzTXZVdW9hTFZHQjQvU0ZCTmx0Sjh5ZW1QUkxH?=
 =?utf-8?B?NlY0UmR3cXlkenhYWWNHOGp0ck9kNzZnOEFlK1pmdW15VDNJeGRDenprWFVx?=
 =?utf-8?B?eUFOd1pMUVVyTGxUaVl5WFpoV1IyenZMUW1CVjcyNEwzcGVqRGROSTlZUE5R?=
 =?utf-8?B?bWR3Q3NMTHU5NGJXZFpXYmZpd2FlUW9GeEpjYkFTSzd6S21kM1NaWTErZXRD?=
 =?utf-8?B?cjNxVTZOQWdOR2llZ0pwU09pNWN4RW00bWMzWko3cThYUnQ5TGk1aWxVeC8r?=
 =?utf-8?B?V1pydnFvQ0JnT3dtVXFGb0l6c3lQeW1JNm9CbFE4RXhpMHRwVWYxeVlSTE14?=
 =?utf-8?B?MHR5Y29YMVFDNTY5UU9Ud000V2lnZTBET3BxOGx1TFBoV3ppK0NXN0wvV0pn?=
 =?utf-8?B?NzZ6UEErYWl0bW9ST1pTK3BDZVpCNUw5WExyT0Z5Q3BueXd5YTljRk05QStL?=
 =?utf-8?B?dml5TTVFQzRlbGJ5US9POVBlT3dvY3FWTVJuS1QyMTdRWjYvK1FnUGZqdmpw?=
 =?utf-8?B?Q2l5MEUvcDUvTXh3d0NaT2x0ZkhKdHUyYW5MbmdDTzlWN2hmVzF1M2Y3TlY4?=
 =?utf-8?B?czN4aCt1V2tUMTJFc3VuV2pBT1JXQmw0dElLdmZtQjVKTGdOZFRITUhvTnhQ?=
 =?utf-8?B?bk5ZY2NXakY0Mng0ODVieDMxUU9MdmFhb1lqRlJuekFSZ2dwcXc1M05Wd2cx?=
 =?utf-8?B?TVpaZDNhelJ1UlBCWWpOSUVpT0pFU1c3NmYrVHdrdUNUaU1QNmJlTUduK2Rk?=
 =?utf-8?B?MkVBMkJ5eHJWcEJ1SmRJYlVZU2xmTVpmUWo5UEZmTjVZQ2xNeHowc1JNZXlJ?=
 =?utf-8?B?eVFtRDFwY2tQanh3azZwRU5TUHp1YkU3SzZ3V1FtVDFPaHVrRWpDZ0hSS2Vh?=
 =?utf-8?B?S3NwMkgvTUVvU2tVU2gwOXBla0o1c3BjL3dDYWRRNmRQcDJuOUpCYkxha0xx?=
 =?utf-8?B?dWdPajlKYWI4OVdLV3F5bVBEWGZvZDEzaml4UzFlVlFhY01na3dvU1VTYWpi?=
 =?utf-8?B?Wks1YXgvVGtYczB0WTllbytzUFMvQUpzT3h3bnU5bm8yeTkyVE5hcm9OUm9W?=
 =?utf-8?Q?BBMYisOQT5QAbu223/pIYdk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bc1b04e-457a-4ceb-b8ff-08d9c02ff272
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2021 01:04:01.1135
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: acby78ZgI4YD3c3Ar/gFSnyrWTtouiZ69b6qSFKTrzjYBQ4bn9E1JxImB7ZkdPgeOxG5BPMU4TElCJIVvlyUlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB3937
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBQYW9sbyBCb256aW5pIDxwYW9sby5ib256aW5pQGdtYWlsLmNvbT4gT24gQmVoYWxm
IE9mIFBhb2xvIEJvbnppbmkNCj4gU2VudDogV2VkbmVzZGF5LCBEZWNlbWJlciAxNSwgMjAyMSA2
OjI4IFBNDQo+IA0KPiBPbiAxMi8xNS8yMSAxMTowOSwgVGhvbWFzIEdsZWl4bmVyIHdyb3RlOg0K
PiA+IExldHMgYXNzdW1lIHRoZSByZXN0b3JlIG9yZGVyIGlzIFhTVEFURSwgWENSMCwgWEZEOg0K
PiA+DQo+ID4gICAgICAgWFNUQVRFIGhhcyBldmVyeXRoaW5nIGluIGluaXQgc3RhdGUsIHdoaWNo
IG1lYW5zIHRoZSBkZWZhdWx0DQo+ID4gICAgICAgYnVmZmVyIGlzIGdvb2QgZW5vdWdoDQo+ID4N
Cj4gPiAgICAgICBYQ1IwIGhhcyBldmVyeXRoaW5nIGVuYWJsZWQgaW5jbHVkaW5nIEFNWCwgc28g
dGhlIGJ1ZmZlciBpcw0KPiA+ICAgICAgIGV4cGFuZGVkDQo+ID4NCj4gPiAgICAgICBYRkQgaGFz
IEFNWCBkaXNhYmxlIHNldCwgd2hpY2ggbWVhbnMgdGhlIGJ1ZmZlciBleHBhbnNpb24gd2FzDQo+
ID4gICAgICAgcG9pbnRsZXNzDQo+ID4NCj4gPiBJZiB3ZSBnbyB0aGVyZSwgdGhlbiB3ZSBjYW4g
anVzdCB1c2UgYSBmdWxsIGV4cGFuZGVkIGJ1ZmZlciBmb3IgS1ZNDQo+ID4gdW5jb25kaXRpb25h
bGx5IGFuZCBiZSBkb25lIHdpdGggaXQuIFRoYXQgc3BhcmVzIGEgbG90IG9mIGNvZGUuDQo+IA0K
PiBJZiB3ZSBkZWNpZGUgdG8gdXNlIGEgZnVsbCBleHBhbmRlZCBidWZmZXIgYXMgc29vbiBhcyBL
Vk1fU0VUX0NQVUlEMiBpcw0KPiBkb25lLCB0aGF0IHdvdWxkIHdvcmsgZm9yIG1lLiAgQmFzaWNh
bGx5IEtWTV9TRVRfQ1BVSUQyIHdvdWxkOg0KPiANCj4gLSBjaGVjayBiaXRzIGZyb20gQ1BVSURb
MHhEXSBhZ2FpbnN0IHRoZSBwcmN0bCByZXF1ZXN0ZWQgd2l0aCBHVUVTVF9QRVJNDQo+IA0KPiAt
IHJldHVybiB3aXRoIC1FTlhJTyBvciB3aGF0ZXZlciBpZiBhbnkgZHluYW1pYyBiaXRzIHdlcmUg
bm90IHJlcXVlc3RlZA0KPiANCj4gLSBvdGhlcndpc2UgY2FsbCBmcHN0YXRlX3JlYWxsb2MgaWYg
dGhlcmUgYXJlIGFueSBkeW5hbWljIGJpdHMgcmVxdWVzdGVkDQo+IA0KPiBDb25zaWRlcmluZyB0
aGF0IGluIHByYWN0aWNlIGFsbCBMaW51eCBndWVzdHMgd2l0aCBBTVggd291bGQgaGF2ZSBYRkQN
Cj4gcGFzc3Rocm91Z2ggKGJlY2F1c2UgaWYgdGhlcmUncyBubyBwcmN0bCwgTGludXgga2VlcHMg
QU1YIGRpc2FibGVkIGluDQo+IFhGRCksIHRoaXMgcmVtb3ZlcyB0aGUgbmVlZCB0byBkbyBhbGwg
dGhlICNOTSBoYW5kbGluZyB0b28uICBKdXN0IG1ha2UNCg0KI05NIHRyYXAgaXMgZm9yIFhGRF9F
UlIgdGh1cyBzdGlsbCByZXF1aXJlZC4NCg0KPiBYRkQgcGFzc3Rocm91Z2ggaWYgaXQgY2FuIGV2
ZXIgYmUgc2V0IHRvIGEgbm9uemVybyB2YWx1ZS4gIFRoaXMgY29zdHMgYW4NCj4gUkRNU1IgcGVy
IHZtZXhpdCBldmVuIGlmIG5laXRoZXIgdGhlIGhvc3Qgbm9yIHRoZSBndWVzdCBldmVyIHVzZSBB
TVguDQoNCldlbGwsIHdlIGNhbiBzdGlsbCB0cmFwIFdSTVNSKFhGRCkgaW4gdGhlIHN0YXJ0IGFu
ZCB0aGVuIGRpc2FibGUgaW50ZXJjZXB0aW9uDQphZnRlciB0aGUgMXN0IHRyYXAuDQoNClRoYW5r
cw0KS2V2aW4NCg==
