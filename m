Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2429D72B55B
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 04:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233373AbjFLCV7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 11 Jun 2023 22:21:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjFLCV5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 11 Jun 2023 22:21:57 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C9E819A;
        Sun, 11 Jun 2023 19:21:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686536516; x=1718072516;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=6Otc9RRtdwn8yRdSXryGUABsFPnaN9IWCInNwn+n1vE=;
  b=imgxfdrgaQMLYEa5QrJoDn/0KodDdTOaMJqjDhqeVvf9cw6fozihF9I0
   H9ZNY83ZGCVBmnHtIIs4ORkuslZ9FoMOyY2q/Q/pU1K4bRonin1fBpSzo
   0o3CfA/svL1pF6dMCZtQJdbQ4ebYRil414IWT3IdotZ02q5NXRf/il1w2
   k2spOPJQnQ5FWlTncxZqXCp1TrKIYY8GBBGrE8ZXs8slbAahB4nwlPufZ
   homoIe1oNEbdEy90InhfKBaO+ibiGna/8VvijBXDffPUspOyHE6Q6OIpl
   9qNld/0fw7hxMBfZfdzQQjFxbxbp/5fAeEQd7ba2vEkcz4Oz6zvFFgNEN
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10738"; a="355423049"
X-IronPort-AV: E=Sophos;i="6.00,235,1681196400"; 
   d="scan'208";a="355423049"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2023 19:21:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10738"; a="705206683"
X-IronPort-AV: E=Sophos;i="6.00,235,1681196400"; 
   d="scan'208";a="705206683"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga007.jf.intel.com with ESMTP; 11 Jun 2023 19:21:55 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 11 Jun 2023 19:21:55 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Sun, 11 Jun 2023 19:21:55 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sun, 11 Jun 2023 19:21:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GONu5Lec7vekQKtSgaWh/Ri6vPvcQv2Y6Je45vnIfvLwRHQuGHaJ9nsY3M4teVtdgwa/k3cEzi9G9vSj4OZlRhoWHX56GzGAe4SGVjzql7AxIP08Dj0nl9tuyTUHWWCZdZ4/tSvrnh8e2N5DRC6hoDOUVpWmCnLeCV+z+EVVOZ04IOBWJYKBAHDEczO0uxrhvxFJi0yzgdGAHwvwQuVozwzOp5jlOLXefoeGzE93LpwAawSInVnMWBeZdcIxTZJRsEVlTIyk77qi4a30tcqNwkaX2A4yj8dstu+OMoh8PUDDyvD89ETJfvpQBfKJ+MzrMs2foxIhRx5HKB4tcLivow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6Otc9RRtdwn8yRdSXryGUABsFPnaN9IWCInNwn+n1vE=;
 b=ILCegt6vibhAHv86+O1nahVRxM3yCvTGTWExL/BaG1XZflW4Ar0dmwwQpBFklhXebwX3mBR0vRmX+zhjSndc7wkEf0hF2edS6sRR4+BbSJ0VHfZyIMhS9DY0P+zPIxrgg7fkI6UXEcKYqkOdq+h9WF4m8V98PL3nLlRTWab7y/JwYZH8Uwzx/YAMCHw8yHAXg+xi4mjutfIzQB4b7xumG24/N1avwY8s/fz/R/StWOKHgE6b+9mBSOOaOf3c50Acw7Jw66/dJOGQq5Ag2g+6j+sY/eEWHJ9xfDBLElPH0/+UCxkKbPalcyHgGhSIV46AJ/4OHFS4yfow2A/Zw7nJjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB8276.namprd11.prod.outlook.com (2603:10b6:510:1af::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.39; Mon, 12 Jun
 2023 02:21:51 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6455.043; Mon, 12 Jun 2023
 02:21:51 +0000
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
Subject: Re: [PATCH v11 10/20] x86/virt/tdx: Add placeholder to construct
 TDMRs to cover all TDX memory regions
Thread-Topic: [PATCH v11 10/20] x86/virt/tdx: Add placeholder to construct
 TDMRs to cover all TDX memory regions
Thread-Index: AQHZlu+vTSZjsOivnkuvoCjDNNbnmq+BigGAgATxZoA=
Date:   Mon, 12 Jun 2023 02:21:51 +0000
Message-ID: <2ae5cfb17ed0a6caa235e49086ac233972400ddc.camel@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
         <f9148e67e968d7aed4707b67ea9b1aa761401255.1685887183.git.kai.huang@intel.com>
         <20230608225245.rvygi5zkr2niolsj@box>
In-Reply-To: <20230608225245.rvygi5zkr2niolsj@box>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH7PR11MB8276:EE_
x-ms-office365-filtering-correlation-id: c40bb952-bee8-44e0-7bfb-08db6aebc84c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: y04rmmHmm0xmdvXgwVtEFTjkbgXiN6cLrGk9z40nql/69KXYfk1vCyV5Ww+5rAaAPR7blpP5RIhCyRr+YjZV9QU1DH45GxHh9Z5vwXLbvkRe9FxX+yKIhDXOKBn3V7/vmF/9sGwpSAKEyxY/F4XCR4IGD4p1hyuEOKwfFKLsWs1gyQ5K2ZU1DvDlt/vmZMWFPbF+N3znga2QlVhjnAnA3qJttY2EF1pDBNqg5uUTwK564SjHb0SgPBq4/xZSa4Pzw5+x/KnfHCojwdpJAstbvY/yAloMfwScCcKwsHWdydtkqD8tvPi8EcQTx6mXo8eTJEOu4ehMqxlsskakT2ZAHH1XXXh5kkACqhApxleTp4zFSck9cmB+3V9rdtEtrI315YcvKq18qCci0xqQzSxqsBmcCnsFzJkezmFdAQ/oAqJnmxGkShHfn4R0mdsFFgW1782I3z2T8rNUnjKABkOwZ/whaetlImUZPdXgPLuAo1b2oeDs6LlbQdS0/rJbygAFaLc4LH34KKo/uanG56paqhDV6H/J9YqFPI6lIKfRYxPmx1XvWUBbHkVROJ9pC5VnWFiXs6C7mM17JO76DTbi+vLQph9XAgekDAYSRNG7L+4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(346002)(376002)(136003)(396003)(451199021)(966005)(83380400001)(7416002)(82960400001)(478600001)(8676002)(8936002)(316002)(54906003)(38070700005)(41300700001)(4326008)(86362001)(66946007)(76116006)(66556008)(66446008)(91956017)(122000001)(64756008)(6916009)(38100700002)(5660300002)(66476007)(36756003)(71200400001)(6486002)(2906002)(186003)(6506007)(2616005)(26005)(6512007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SHNWei9XSy9JQlVRSUlJcnVkNTdZSkg3K2dHSDAwb0xXM0ovTWRnRm9kK3hV?=
 =?utf-8?B?dTcwdThoc0pZTjc4NDBvOEdUOVZ6aVkxUCs4bi9PcFgzOU0xNnphUlBySDZp?=
 =?utf-8?B?MkZ4eStaMW1ON2VhUFR2Z1EyY1BuWXdzby9wUWxDeVpKNEF6VmFyQS93WENF?=
 =?utf-8?B?K01Zd2tvSDE1RWN4b2VOMk1VQjlSK2JZVXFFVW9Dd0Q3emdlZXEzdmhsWGdu?=
 =?utf-8?B?a2NJN3RJVk1kTFFicmxNZ1dDYlJndTlWdWo0MzJ0cVlLWThaWElzYTRVRkY3?=
 =?utf-8?B?aklBMU5aWjQ4dW16Zng4WnBTdlk3elhHSnUvRmExY3lydTFpSW4reEkrckVa?=
 =?utf-8?B?M3pCcDhvYWZXQkxDKy84RWRjaXhTd1RJTGg2T2taOThhRU1tUGs3K3RBKy80?=
 =?utf-8?B?US9CT1BWdFpJdFJiTE1QUEhFZG1Uc09DL0xPZ1RMeVRrQVo0cFJNbGZuN0Y0?=
 =?utf-8?B?MEx4T3RGMlloMUtYZFFNQkdwZ2NpeFR6RjhzTmc5Z2Q3bVRYbHBLWnJxNDN5?=
 =?utf-8?B?NXZxbDNHc0JnU3FQQmhPQk5wODNtMTE0NzA3Z3ZMdEdwNTdDVHQ0T2ZtNG5u?=
 =?utf-8?B?dnRzWm5VM3NlV0p4UXA1Wk5PL3FVcGlUd1JNaXpPMnpLMm5jTm9UcjR3OHlU?=
 =?utf-8?B?bGlOVndsZ2RaOVB1WFpYREMybytSUGJkd3NhRG15a3VNK3c4bmY3M3NGa1FF?=
 =?utf-8?B?TEtibmE4L0RWVWVjZGlIMUFjSWNRSTRWdFFtY21WdUh0TGs3RGJ6WDZaRVFT?=
 =?utf-8?B?aGFMU0EzSGVsQ1cvaUlGamE5c0hiYTNHUDFGaGRQdlQvUGVvY25ZZHdCRkhG?=
 =?utf-8?B?WEUzYVcraGJDRXROa3VIMXNmYlBmUloyNm9EK2c3SHpja3NnOFY3WWdubVdW?=
 =?utf-8?B?YWtsTERBQjF1alFWV1MzUmxwNDF6ZnRkTGFLUTRlLzRSd3huelZvU3dRMXBZ?=
 =?utf-8?B?d0tIVmpxUU9rWDNwbVhpd1lLNVAzNm0wWVZMd0NUMGNhSU9NandLMk50QkRJ?=
 =?utf-8?B?YmtQNEFFeXRkcXphRXR0UDNUZEVRZllnQUlpbGJCUkhZeXpFWkxUQ1lCRXU3?=
 =?utf-8?B?MEp2dTBRT00zaTBPQ2Fkby9TQnRtMHNsVnRORWh2TWZYeXBOMW4rZDdWMzl4?=
 =?utf-8?B?azJKTkxuVm9RNUZWbUp0NW1xV0RRZU01aUh2dnVUaVg4WTV3U29MSmdzcjBD?=
 =?utf-8?B?amNmZXhMbGFlTzRoUUtNcUl1Q3lnVlJ2UFV1YjVBa3F6R1NMak11akdISXZ4?=
 =?utf-8?B?YVVuM2ZHa2R3TTJPREpEbW8vdjBiaUs0ci9RYWRvdlViRlY4LytEZnUyY0Fy?=
 =?utf-8?B?UUEzNWhxMWFDRmZ5MmFuL0kzZm03aFNNTGMxUEp3c3FaYzRxeFg0UGk2Zmoy?=
 =?utf-8?B?OTBVdVNIZE8waHBuNUpUZ2JCVDRzc0N4VDVDT1NxQWVkNExVczdsMm8rZlls?=
 =?utf-8?B?VkcxMFliNklTS2xEZGV3ajlhSWYwTy9SWDM0V2M4QlFyUFlGZ2k0VldaUkIv?=
 =?utf-8?B?dm05emE2OUhQSXR3cjhuNEc0ckVHdDlRYlBCZ0dJWVFQZDhnb2JOQ2dDTGgx?=
 =?utf-8?B?YllDaGpid3JKQ3BiSWNock51V0Zhd0UxK1VSVWl1UWttM3lmMlM1WW82MmMv?=
 =?utf-8?B?WnlMN3FZaFRnV09tOTBTYzBKajZGdjNuamRqeWJLT0J3Y0Y2WFNJNzBvd2NX?=
 =?utf-8?B?ZTBxdys0bkhOTG0vRHJOb1NybDVJa1c2V215YThNOG0yd0dxQWdCZmUwMGox?=
 =?utf-8?B?cFdjTVI2T09Ba2NiWGNtNGk3eWprdjZLZk1BT3NaUENRaHp3emdwWXRqd1M4?=
 =?utf-8?B?RmFOdHYyWTRkQitCRjc4MUhBcXVVMCtZTUxQcWhRa2FteGVMT1BqZWRQT0RK?=
 =?utf-8?B?MkNlN1VoaFRRUUtjL2JnMDJBSlV5UkI2UXJVMnpsVURMMGsvSFZldVBzRUdh?=
 =?utf-8?B?cXJ3MWRvQ1BadEhJL1ZLRDdGWjJJb2UvOTdMUEtTNHpwM3lZRFVkSStxWHdL?=
 =?utf-8?B?cnpibk1KSjFiU0ljM3VEVHFYMWVRazdzL0lMTUxFVmJrNTg3TVYrNE1RUHJh?=
 =?utf-8?B?RDl6TmwwTGdyOXpYK2M4dU5PRWhncGxGSHlQbTJNQTgxY0tJUHhnclUwZWk0?=
 =?utf-8?Q?+llVMMeBDSQALcwZCudrm+hLD?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5ABD715D51E2E044AD2C946E8E664B0D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c40bb952-bee8-44e0-7bfb-08db6aebc84c
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2023 02:21:51.2832
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dMwgSLX6n3SchLRQM8ZQkcF6SMSY7rA3MxdvNoaHdzsq5peiMj7TIP19BNC5wd3FPSJ5fV4sJxdGuhYw2q/x8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8276
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIzLTA2LTA5IGF0IDAxOjUyICswMzAwLCBraXJpbGwuc2h1dGVtb3ZAbGludXgu
aW50ZWwuY29tIHdyb3RlOg0KPiBPbiBNb24sIEp1biAwNSwgMjAyMyBhdCAwMjoyNzoyM0FNICsx
MjAwLCBLYWkgSHVhbmcgd3JvdGU6DQo+ID4gQEAgLTUwLDYgKzUxLDggQEAgc3RhdGljIERFRklO
RV9NVVRFWCh0ZHhfbW9kdWxlX2xvY2spOw0KPiA+ICAvKiBBbGwgVERYLXVzYWJsZSBtZW1vcnkg
cmVnaW9ucy4gIFByb3RlY3RlZCBieSBtZW1faG90cGx1Z19sb2NrLiAqLw0KPiA+ICBzdGF0aWMg
TElTVF9IRUFEKHRkeF9tZW1saXN0KTsNCj4gPiAgDQo+ID4gK3N0YXRpYyBzdHJ1Y3QgdGRtcl9p
bmZvX2xpc3QgdGR4X3RkbXJfbGlzdDsNCj4gPiArDQo+ID4gIC8qDQo+ID4gICAqIFdyYXBwZXIg
b2YgX19zZWFtY2FsbCgpIHRvIGNvbnZlcnQgU0VBTUNBTEwgbGVhZiBmdW5jdGlvbiBlcnJvciBj
b2RlDQo+ID4gICAqIHRvIGtlcm5lbCBlcnJvciBjb2RlLiAgQHNlYW1jYWxsX3JldCBhbmQgQG91
dCBjb250YWluIHRoZSBTRUFNQ0FMTA0KPiANCj4gVGhlIG5hbWUgaXMgbWlzbGVhZGluZy4gSXQg
aXMgbm90IGxpc3QsIGl0IGlzIGFuIGFycmF5Lg0KDQpJIGZvbGxvd2VkIERhdmUncyBzdWdnZXN0
aW9uIGluIHY3Og0KDQpodHRwczovL2xvcmUua2VybmVsLm9yZy9sa21sL2Q4NGFkMWQyLTgzZjkt
ZGFiNS01NjM5LThkNzFmMzgyZTNmZkBpbnRlbC5jb20vDQoNClF1b3RlIHRoZSByZWxldmFudCBw
YXJ0IGhlcmU6DQoNCiINCj4gK3N0YXRpYyBzdHJ1Y3QgdGRtcl9pbmZvICp0ZG1yX2FycmF5X2Vu
dHJ5KHN0cnVjdCB0ZG1yX2luZm8gKnRkbXJfYXJyYXksDQo+ICsJCQkJCSAgaW50IGlkeCkNCj4g
K3sNCj4gKwlyZXR1cm4gKHN0cnVjdCB0ZG1yX2luZm8gKikoKHVuc2lnbmVkIGxvbmcpdGRtcl9h
cnJheSArDQo+ICsJCQljYWxfdGRtcl9zaXplKCkgKiBpZHgpOw0KPiArfQ0KDQpGV0lXLCBJIHRo
aW5rIGl0J3MgcHJvYmFibHkgYSBiYWQgaWRlYSB0byBoYXZlICdzdHJ1Y3QgdGRtcl9pbmZvICon
DQp0eXBlcyBmbG9hdGluZyBhcm91bmQgc2luY2U6DQoNCgl0bWRyX2luZm9fYXJyYXlbMF0NCg0K
d29ya3MsIGJ1dDoNCg0KCXRtZHJfaW5mb19hcnJheVsxXQ0KDQp3aWxsIGJsb3cgdXAgaW4geW91
ciBmYWNlLiAgSXQgd291bGQgYWxtb3N0IG1ha2Ugc2Vuc2UgdG8gaGF2ZQ0KDQpzdHJ1Y3QgdGRt
cl9pbmZvX2xpc3Qgew0KCXN0cnVjdCB0ZG1yX2luZm8gKmZpcnN0X3RkbXI7DQp9DQoNCmFuZCB0
aGVuIHBhc3MgYXJvdW5kIHBvaW50ZXJzIHRvIHRoZSAnc3RydWN0IHRkbXJfaW5mb19saXN0Jy4g
IE1heWJlDQp0aGF0J3Mgb3ZlcmtpbGwsIGJ1dCBpdCBpcyBraW5kYSBzaWxseSB0byBjYWxsIHNv
bWV0aGluZyBhbiBhcnJheSBpZiBbXQ0KZG9lc24ndCB3b3JrIG9uIGl0Lg0KIg0KDQpQZXJzb25h
bGx5IEkgdGhpbmsgaXQncyBhbHNvIGZpbmUgdG8gdXNlICdsaXN0JyAoZS5nLiwgd2UgY2FuIGFs
c28gaW50ZXJwcmV0IHRoZQ0KbmFtZSBmcm9tICJFbmdsaXNoIGxhbmd1YWdlIidzIHBlcnNwZWN0
aXZlKS4NCg0KSGkgRGF2ZSwNCg0KU2hvdWxkIEkgY2hhbmdlIHRoZSBuYW1lIHRvICJ0ZG1yX2lu
Zm9fYXJyYXkiPw0KDQoNCj4gDQo+IA0KPiAuLi4NCj4gDQo+ID4gQEAgLTExMiw2ICsxMzUsMTUg
QEAgc3RydWN0IHRkeF9tZW1ibG9jayB7DQo+ID4gIAl1bnNpZ25lZCBsb25nIGVuZF9wZm47DQo+
ID4gIH07DQo+ID4gIA0KPiA+ICtzdHJ1Y3QgdGRtcl9pbmZvX2xpc3Qgew0KPiA+ICsJdm9pZCAq
dGRtcnM7CS8qIEZsZXhpYmxlIGFycmF5IHRvIGhvbGQgJ3RkbXJfaW5mbydzICovDQo+ID4gKwlp
bnQgbnJfY29uc3VtZWRfdGRtcnM7CS8qIEhvdyBtYW55ICd0ZG1yX2luZm8ncyBhcmUgaW4gdXNl
ICovDQo+ID4gKw0KPiA+ICsJLyogTWV0YWRhdGEgZm9yIGZpbmRpbmcgdGFyZ2V0ICd0ZG1yX2lu
Zm8nIGFuZCBmcmVlaW5nIEB0ZG1ycyAqLw0KPiA+ICsJaW50IHRkbXJfc3o7CS8qIFNpemUgb2Yg
b25lICd0ZG1yX2luZm8nICovDQo+ID4gKwlpbnQgbWF4X3RkbXJzOwkvKiBIb3cgbWFueSAndGRt
cl9pbmZvJ3MgYXJlIGFsbG9jYXRlZCAqLw0KPiA+ICt9Ow0KPiA+ICsNCj4gPiAgc3RydWN0IHRk
eF9tb2R1bGVfb3V0cHV0Ow0KPiA+ICB1NjQgX19zZWFtY2FsbCh1NjQgZm4sIHU2NCByY3gsIHU2
NCByZHgsIHU2NCByOCwgdTY0IHI5LA0KPiA+ICAJICAgICAgIHN0cnVjdCB0ZHhfbW9kdWxlX291
dHB1dCAqb3V0KTsNCj4gDQo+IE90aGVyd2lzZSwgbG9va3Mgb2theS4NCj4gDQo+IFJldmlld2Vk
LWJ5OiBLaXJpbGwgQS4gU2h1dGVtb3YgPGtpcmlsbC5zaHV0ZW1vdkBsaW51eC5pbnRlbC5jb20+
DQo+IA0KDQoNCg==
