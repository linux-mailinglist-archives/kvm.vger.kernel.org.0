Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F37472B545
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 04:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbjFLCBb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 11 Jun 2023 22:01:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbjFLCB3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 11 Jun 2023 22:01:29 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 213E4E6D;
        Sun, 11 Jun 2023 19:01:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686535269; x=1718071269;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=nYRB9aGA+DUcAQNyw8b+rBb7Skqf+k3ay84Giiy5H8g=;
  b=DEo7/7ojJtZjCrjuNQ7vCCuWP4ib3fj0WNmnn67hE0rD2Y/OSRta3MdA
   1ZcKXdWX/Ht39xiwo+FZfJ9czXYw/jzW9i9RYLNDX0X23j2pLMWsjhBZB
   3LTnZBOOKeAbQZTmjWZpC1uILha0I8wISyRH/3VL04pUtQncbiW8xVhko
   YELvsVT42oDc31i+FZ7zinWYczjG/QrU4j0rf8gAokiszcx0QhEp+3QW9
   YfRPGa4d9RW+u7rfYdV7BqTrmFTZ4DdvWjzx8uj55/C+xO78FDE06D5nm
   y+o89ruNucCfa04EY+w6cMdy8ahDIlPoXaKOYMsaip9JmMoHrNQBiUp+q
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10738"; a="347569843"
X-IronPort-AV: E=Sophos;i="6.00,235,1681196400"; 
   d="scan'208";a="347569843"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2023 19:00:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10738"; a="957824572"
X-IronPort-AV: E=Sophos;i="6.00,235,1681196400"; 
   d="scan'208";a="957824572"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga006.fm.intel.com with ESMTP; 11 Jun 2023 19:00:56 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 11 Jun 2023 19:00:56 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Sun, 11 Jun 2023 19:00:56 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.40) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sun, 11 Jun 2023 19:00:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cWP520SAVCwvIvCHhcvtCDOil7si7BFUOQWsqI3wW51A1rjBtKYKBr6VH+p2PLP2BqlWBKhzNPHlnRJ54LW7uxoRGjTF0oIHraqzkW/CEkPH5daqyM2Qrysq/IvvpjfNJLkA2WXOuUVUMlOtib375Ca4KFKwWL3g6OOLwWThuFhT1S4eBb783M+j+780O6K+CSZfDmKjTDeyUL3GkMkJvrSJ5PEw8V5tPJ7LYclEY7t61qqcdYimMi6R+0g5gJBe5e2z4DrXF40AT+awQ1GxBD+7oxEuARp0QOY3Sj16EaD+bbenErqpSZPYqK+RJlNKKAngraaGBGgA/rb3DWbRAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nYRB9aGA+DUcAQNyw8b+rBb7Skqf+k3ay84Giiy5H8g=;
 b=i8QJFtEakFtSgoyqM8pyj/a2O57HxIl4opihN9FIx2WSc9ebDGe5Jvm2OPEz2/3wMoM3rdGxSk87T6wVYWBLeuyHKwUDMEqOaJLOZpbLI0dBdw6a2n293f7ydKDzGxowudubcdDdbLBQgu5gy5iCVyG5BFxE6QCg4jExr8DZNxwyVEDHo5BoqYBSVF4YboR9lMcJJcJu5zMGIpmnObASXzgAYQdcfAf4/K/Ut1mbpO2ZnhFfzO9VUGtwcPThcRMBgZBasF8q68dw+4XMdNhhjezUspdfiQ94MMsdnC5ekteMXSH2sDaK+eeJCx7gXanobkrqV/TOf7JqCUYJeciS9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH0PR11MB5063.namprd11.prod.outlook.com (2603:10b6:510:3d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.44; Mon, 12 Jun
 2023 02:00:53 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6455.043; Mon, 12 Jun 2023
 02:00:53 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v11 08/20] x86/virt/tdx: Get information about TDX module
 and TDX-capable memory
Thread-Topic: [PATCH v11 08/20] x86/virt/tdx: Get information about TDX module
 and TDX-capable memory
Thread-Index: AQHZlu+wT+VnAmvfKka8EfWTldC51a+CRQGAgAQwiwA=
Date:   Mon, 12 Jun 2023 02:00:53 +0000
Message-ID: <5f2b52d393cdfa0bc71ca30d8029e23048855775.camel@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
         <50386eddbb8046b0b222d385e56e8115ed566526.1685887183.git.kai.huang@intel.com>
         <20230609100203.uabyy5clg2l4wegi@box>
In-Reply-To: <20230609100203.uabyy5clg2l4wegi@box>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH0PR11MB5063:EE_
x-ms-office365-filtering-correlation-id: 95451b2a-96eb-4e13-2691-08db6ae8da55
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 258oMHVPjvJ/1ATnFsZJtc5HTIFdkhQieXMbI1+6j+BxdFyohZgV1qA2wNWz/oXqQYkTFGwdSv13tsyKwCUXSrHwAvjqreEXwBGd0VaHlVF81sqdaMpGsihftHpH53A0XS0f6YJ+qzFcjTgXgeldjF65EIADiPbtjV5TSi3korlqbL1BWdH3aed/bBOE7Ba6CN1ntdEYbZmU6TXpGysXYHnym2AluioYhZB8klTz/lWwz7F3QwWhKGs9B/2H5D/tLbrRpZWukMsPzgjrVSJTHK18OlKplEboYpD9pT4bpVRxdgqKKApaVeCFxf/5Si90C8LPInBvzSLlK8LrbcsHobNoQV4U49L4ivmuzbndHLWIail6k7t4lxgBic5o26J0CAxC8L9OxOYCiOEX4AncOzWzO6yWIwQB/J8L6URY1iEOAHDnA2yUHFBBcRD73kSvKFTFfcYFlHXAv+ZMVN4b7CMNvum/vaozAdUH5QQw6OFi8R6WAMY1RXVjPcpz2vyPOaGT4CHBBByZ613swXPJ6zD31vCf5BbvzBM4UpcCa/ZoenzE+9k1mbu7aYgjufNL5pdqifHTFwRBVF3Ob3axJ/Ka5oadcenb+2z8nXL3YNmDeFp05nMKpS9E9pt2Pc+O
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(376002)(396003)(366004)(39860400002)(136003)(451199021)(316002)(6486002)(41300700001)(83380400001)(2616005)(86362001)(38070700005)(6512007)(6506007)(26005)(186003)(7416002)(2906002)(558084003)(122000001)(82960400001)(38100700002)(8676002)(36756003)(5660300002)(8936002)(76116006)(66556008)(66476007)(66946007)(91956017)(478600001)(54906003)(4326008)(71200400001)(6916009)(66446008)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UGRhOXg5S3V3VzV1dThtQnFscjZpamc2aW50TldmcXhTSFpkOVM3bWtrcmNL?=
 =?utf-8?B?R0xWYnFnWnRVR3JmR1FQNUNGdVNNZTNWcmh4R2VLM2YvQWtCNVJUZXZlQXNa?=
 =?utf-8?B?RHE0M0FmU3M3akhBVGhGL3JvbXBMbkhPMm5ZKzgvK1pzSGZlVzJjUUJSWFFt?=
 =?utf-8?B?RHRCZnZmN0pxYWJ6Z2hFNGczSWsyeXZVeklBeWtCN0xjMnpldXRtdDZ3NWQ0?=
 =?utf-8?B?Y05rd0xlbTJXTE1hQ2ppWU4vbTd4TWdZdHgwRE9GK1lnaE5vTkhaeEFqVmFw?=
 =?utf-8?B?U3hSTWwxQXdrVG9WZzVpQ2owQzBHemtHTlpoSXJIclNPbGU4ZzgwN0M5dVlP?=
 =?utf-8?B?SkdSZk1ob250Q1V0Z1JCTnY2Y1hodGRiQ0JDL294Yml3SFNSWTQ3SWs2MWJz?=
 =?utf-8?B?eHRPbG9rZDNhdUpJaUhpQ0lkZnczd0p4ZERuMlZpTEJCMis0YnI4amE5WHR4?=
 =?utf-8?B?WE9mNCtmN05TRCtlcFB2MytjaUN2SkFRY3ppQ2VxWTFMdU9mNzdkd0lMUXZL?=
 =?utf-8?B?K3U4THhETWhHbFRDYXNwUXR2bDlTM2dPZytxU2hGbWxqUDhDWi83MzBWZlZG?=
 =?utf-8?B?bUxHT2xpNTFYdXVPMGJxT1RIdlFXODJOeUJVQ09sTFRUeElFMTJxczJYeGNu?=
 =?utf-8?B?UEdjcTlhVExaakhSMDNqOUVOMEFUT0paV2M4RDBoWnhDSHk1K0JRNWZJU09i?=
 =?utf-8?B?dFArZDJQdnpqV3M2b0N5R3c1akh3Z25MWllBWHBuc1N3MkoyNlF4RmtlTHpG?=
 =?utf-8?B?dkZvK3F0MnFBOXZFOUxDeUdLUnJRQ3VYRllMNGt6RWZ3VEJWZVk1bitkRnBF?=
 =?utf-8?B?ZStxRW91bjlwNFI1VG5mM2lQWUtDdDRCckw3TE0vK1Bja3ZYKzZWRHYvajlX?=
 =?utf-8?B?bW1Rdmp6ZkRMVHU1OFlheU5jQkl5aWdxbW83WWhrSDZCQXNGOXlYdURHdk1M?=
 =?utf-8?B?K0dXRGRhVlEwRkhGQzVFQnZBMjdycHZ6anE5NE1HZTVkdE1kQmxaeHVkcFpn?=
 =?utf-8?B?dDU2NzF3dVFsTWc5WGtuZDVuV2lyNm96ZEJwV0FQaGlOQnhUVTR6Mkk4T0Na?=
 =?utf-8?B?YTJLc3pWUjYxZHdHM3NaK1VncnBsS0crbHlpNDJLR2luTFhDZytGZENpNXZ3?=
 =?utf-8?B?UnZkMzJUU3ZsNG5mbDhoUzdERmJJTW9ZWkhCTjhBN1E3WGtHVVh4bmxySGxI?=
 =?utf-8?B?UXIzb3BuQ0dlOENHMlN4eGtXNFlMTTBrTXJjcFc4K2tPK2NIQWpEZHBXSlJE?=
 =?utf-8?B?dkJ4VlFsVnJrOEhjWXBhakhtajB3MTJVZ0grMzBFK3g4RFZSTThzdGhQVlo0?=
 =?utf-8?B?WFQ3VVNYVnBDRkJPMFhJUFdybVVDUEk2S0RxY3Ewd0t0KzRVSE5TNHgzV0hl?=
 =?utf-8?B?UHRxRU9RUTJMV2RKUDg5YU5rR3RFSUc0Qzgrcncrby9wR3ZRb0dyQ1Z6M2pj?=
 =?utf-8?B?Y3hMSnF6QVJOSHVmQ2dKWjJvams3T3cxeWN4Q2djTVZNQ2VSQk9zYTYvQzE2?=
 =?utf-8?B?WDRqMXJkMlFvN2NwVjkrdFRXMEU3Q2wyZnRhUEVJeGVodmZJRFZWVlRFWi95?=
 =?utf-8?B?aU0wOVlZeW1pQkh0RGs5VTNOc2NBdHh2VlZOSFV0c0RxNXpCNFdiZ0RiUllK?=
 =?utf-8?B?THMrZHoyTGxYVW1iUW0vN0MxYi9OajlocXpSU01CSkdPSVVmOWFMVzV1QVVX?=
 =?utf-8?B?ekZYK1FjbFpDcTcxRGdQZlBpcmgvUk5wLzE2NnlEMndYY3hMdnBNbFd2NmdF?=
 =?utf-8?B?a3ZFNCt4UUdyNktsS2tneE82RzVGRW1HZ0FXQTdVSnZqeEZZdlJxQWZLY3Ay?=
 =?utf-8?B?b2xVM0c0WldHZFFsVnRwYnUzREtrRVNiZ3g4RVdxWjNCYWtGaEU0cnV5bkpD?=
 =?utf-8?B?c2dWNFBHaFhaTDNxUG1HazdRcStaWHZMVlhwV3ovMXNVNkVaSXVjTGtxNi9T?=
 =?utf-8?B?ZXpRR0QwSndQRlVOMjFBcTlLampzbDFlbGMvcGUyQnU1aFVMaEozdklGUlh5?=
 =?utf-8?B?SkwxcXEyR2ViL1ViM05UQkw0WjVGZjNsTm03M1UvWjJOekhSQ2dVYmpmQ0pT?=
 =?utf-8?B?TStsMGdhbEtuQ1gvNktnNXhIN3A0M2RrYjF4Uko2MWZ0VEUvQjJqNHFSRkQw?=
 =?utf-8?Q?PTO2DiY1HW/UmxDlHc6mrred6?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4F00A21ECF7145428C16BFBA44AA2098@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95451b2a-96eb-4e13-2691-08db6ae8da55
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2023 02:00:53.0490
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: K4UVrIDggeEUn86BfxgHbqt8FaisSNXfej+22XsL6P13/FNB4d3Jo6TFdzptxctkNd+ornlthI94aq+3hmbsaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5063
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

T24gRnJpLCAyMDIzLTA2LTA5IGF0IDEzOjAyICswMzAwLCBraXJpbGwuc2h1dGVtb3ZAbGludXgu
aW50ZWwuY29tIHdyb3RlOg0KPiA+IEBAIC0yMSw2ICsyMyw3NiBAQA0KPiA+IMKgwqAqLw0KPiA+
IMKgI2RlZmluZSBUREhfU1lTX0lOSVQJCTMzDQo+ID4gwqAjZGVmaW5lIFRESF9TWVNfTFBfSU5J
VAkJMzUNCj4gPiArI2RlZmluZSBUREhfU1lTX0lORk8JCTMyDQo+IA0KPiBDb3VsZCB5b3Uga2Vl
cCB0aGVzZSBkZWZpbmVzIG9yZGVyZWQ/IEhlcmUgYW5kIGFsbCBmb2xsb3dpbmcgcGF0Y2hlcy4N
Cj4gDQoNClN1cmUgd2lsbCBkby4gIFRoYW5rcy4NCg==
