Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 768B57423A3
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 12:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232183AbjF2KDn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jun 2023 06:03:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232454AbjF2KBk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jun 2023 06:01:40 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ACDD30F8;
        Thu, 29 Jun 2023 03:00:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688032821; x=1719568821;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=kCs//HOvbZmscJBeQzi6cS51sJxNLf3McogULppLe/k=;
  b=i8/uFzwPPjqpZ1BsEngFnZh1k8vShM1aKnqOCSN1xwEPnLS6HAXKb4Ma
   r18g1D8Jy27nqcwVHMvwa3M1f0XcR2BVLwtWFO8jMNe4RYLTg41EcSafk
   hKcF+rwD0KhtmHfpAJW8aj5ZAxSbbAYvqQOF45GnpDE3Ur1fQcgKKI++/
   GZYPY+0XfqFyL0nSCcRSxhvDmBIDNM/qguSNvc2kbPwYnhJI7x4wH+hiD
   kxgItN3Hs7vTacSip6nNJxOFCOajzu8GewYCjZsBR5b6BJwU23u7z5TyP
   IT6uxd7PATERSVCPDXtUq6STUrWGxhLBFyGYhKIx8P25ab1YVKbZKIZQf
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="362107983"
X-IronPort-AV: E=Sophos;i="6.01,168,1684825200"; 
   d="scan'208";a="362107983"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2023 03:00:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="807251778"
X-IronPort-AV: E=Sophos;i="6.01,168,1684825200"; 
   d="scan'208";a="807251778"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by FMSMGA003.fm.intel.com with ESMTP; 29 Jun 2023 03:00:20 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 29 Jun 2023 03:00:19 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 29 Jun 2023 03:00:19 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 29 Jun 2023 03:00:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D4LPA8/GoM+eU6V3kxrLYfsgHUYK431e18uAbuthkENWeOXeHyOToOtEmWwDqY7YvLwIbgcbBFk8qIFXf0YszDGuD5KByuQhbV251ByEh/jimVknCPGbtQfmvNr0NCoLoHVl8d6Swq7nWtFlnXOf+9CQ4P9g3BKN1TuLaZL1HgBIxP62Q3Uk/8P2IE8lTzA1M4pZNSU1DvNu9yR4K8V64g8aKfdsl0eLQvZRN5TszcDEYcIymLTjIlhKRRtHVtHWEd8Vff4MHIUbFDee5JJ8PWW+mDK1rjfGtNHVkA9JQUIrME1fZWRA/LjGi/vqWrFu8sOqLCErIPflUD5oDmECWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kCs//HOvbZmscJBeQzi6cS51sJxNLf3McogULppLe/k=;
 b=VihqLLemOSx9c+LTulp6ommuMuzrpYhPUqsC0Sy1YUfGURvXnveZxLL0bN+OjYtc1vlYV+h8ZvitpLL+PjHwWw/ZE18SxiWWcPBL5SCYIg3YtlM2/KQlliExJDeRmBX9d3qc9/A+rcruoAPtvh6sd61tP6YZ7bt5vIyLSqShhvVtv6Xb7HH+42tfPvGaKONI9n6p1XUhah9AWFfmw7FC83ewiIlSNDoHkX/pi6lIpC3/33dZJv+qRfSDFkFMgAxu0GX6lVEJGXARuDk64REHZ1hKj0i9Vp/lGk4kqmSgY8B/Lh5Re/cXUgi8CnxhS00hX/UhLprkJQSDXt8SzvH7wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH0PR11MB4919.namprd11.prod.outlook.com (2603:10b6:510:34::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.26; Thu, 29 Jun
 2023 10:00:12 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6521.026; Thu, 29 Jun 2023
 10:00:12 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "peterz@infradead.org" <peterz@infradead.org>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "hpa@zytor.com" <hpa@zytor.com>, "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v12 20/22] x86/virt/tdx: Allow SEAMCALL to handle #UD and
 #GP
Thread-Topic: [PATCH v12 20/22] x86/virt/tdx: Allow SEAMCALL to handle #UD and
 #GP
Thread-Index: AQHZqDW2iSvVOZI03kGK/IB0Vnjb6a+gWhoAgAE2dIA=
Date:   Thu, 29 Jun 2023 10:00:11 +0000
Message-ID: <787ed0fe5411d6bb7ae7aa459abe7a0ef8256f8b.camel@intel.com>
References: <cover.1687784645.git.kai.huang@intel.com>
         <c124550719716f1f7759c2bdea70f4722d8e0167.1687784645.git.kai.huang@intel.com>
         <20230628152900.GI2438817@hirez.programming.kicks-ass.net>
In-Reply-To: <20230628152900.GI2438817@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH0PR11MB4919:EE_
x-ms-office365-filtering-correlation-id: 062c8a49-3e54-4a0c-928a-08db7887a0da
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DpCNzlU8zaWEPdWq5MXkm+XuKJDBugiO2Y67mTOPx7bFmfJGiiaCD8edvYYAc3rCiq3n3tGXyTOVU1t3OVvtH/W+aFUztJrVpXwNsjePjP6N+YzWUiCzhbI8ZVZtxkNsXBFld5aVm93WqU3AURL3G8tQE8f1ir9XZeKUId7ryp429PnDtnnliUv006jIgl2aG6c4KI2HJhAXnSMj1As6N0FgpKyZMxSYMiYrMf9m84s5Wk0EGuDkdaLzwNQTDmNKmI+wis/UYUuwae2cvC7mm+EJHaztjlxsZbuzM6K+ZTt1e3qe4/6eOXgFriYPXFn6WNZgbFsL0z9VTCgf+hDH3mfLXKY5HBziS+Faf7SgA2X22dZiL+B6aQ6/RZ0XVhz9KQgywMI9+gCmmgPO+W8Ji27UeeV6ssQ6yaFZRePE0b1UC0ctuLR/HKzfUlBzuojO+7NngeuKgwybFygM7VMa74Xttg/MQvRRN39VAl3FLAB8dJMhkn5Dl4QlthQqfEoCToZ+Ut1P7BHhHxSXDNrcB5/QQgd413OQG/2NyNEPTilzG0IrNqqIKOOFZhJiHbVNDQQrIChtngyLdLazOU2phVNDdLvzDalc9hJs1TueLrM13ktWyWzSCuAdTXvAfw2X
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(376002)(366004)(396003)(39860400002)(451199021)(186003)(38100700002)(2906002)(71200400001)(6486002)(82960400001)(2616005)(122000001)(6512007)(6506007)(26005)(54906003)(38070700005)(41300700001)(86362001)(6916009)(91956017)(478600001)(36756003)(316002)(66946007)(66446008)(64756008)(66556008)(66476007)(4326008)(76116006)(7416002)(5660300002)(8676002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZERJZ25BanRMKzNYZmZKbDBCWFNUbFhUbGRjNTB5cVRqMVZ0cUxiaU1oSmwx?=
 =?utf-8?B?NlpkQzZOTGVWMDRJQnhaRTdXNmhnQ2tZVnA3ZWhvSjRuRDFGMUpSYUpuUVBE?=
 =?utf-8?B?Sy94bEhSWVNNQ0laeDZ1UVZBSWZiMGM4dENkRnBSSSthSk5HeWhjakFsbEVs?=
 =?utf-8?B?YktQSzRsNC9HaEF4RmltcUdHaEdtYjZ0MVJJcEJtQkpJU2FLRlIraXQyY3Yv?=
 =?utf-8?B?YmVha1RSSWxxSUs2K0MyTmxtZHpNVVh4N1JKRUtVVVVFUU9YR3NXTWNnSGhm?=
 =?utf-8?B?WnM2OFdXRGJFRGM1L1NsbkJkYVY5bnVwdjZTTE1GbS8xMEhLQ2tJWkhuZi9D?=
 =?utf-8?B?bEpwMTE5ci9tVm5UelQzdkROTWFuVVRHcitkeFloTld6TlZucHlzR2paOE5T?=
 =?utf-8?B?enRJcDRodlRhcFN0Q0pyKzZOU1ptQnUwSk1UQ2dBUW8yN0x6QU5TZnhJWU5S?=
 =?utf-8?B?bk1YWVM0UURueWQvWnkrK0wyZnBJczdleEhUbXR4QjRtczJ6a1FUdy9PR3Q0?=
 =?utf-8?B?TldQQkRyL2Y0ZG1wM2tDZkRLZmZoTnF2dXByNXU5K0EwaUxPM1I5UFN0aThY?=
 =?utf-8?B?cDRFMHk1SE42ME9uSHkzLzFQY1p5aFg1OE4zL1dBd3JuS2NReE5tNHlXQzVo?=
 =?utf-8?B?bGduOElSd1JSc3NscEwxcHMzbVovU1RXUW03K2xickhEcWo0VVp4U1A3STBx?=
 =?utf-8?B?TFhhMGFOd2pIUTBFQU8rMUFsVUdTb1hoMHNtOFhQdXRVWjJvQXZkdmlVdHRu?=
 =?utf-8?B?cmRORDlNcVZKQXllM2NJdnBmSW9hL1pkaGxCWXpRN2pRdG5EN0dnbG5PSWQx?=
 =?utf-8?B?d2pIM3NPVnNzZ3Zvb1NSbTRjM2tzZFljejRobWhMcVFVanZ5UHcvNkRCUXZK?=
 =?utf-8?B?cE1KLzlTalIyRGtQSEdTZFdnRlF1UFVGRWR5ODVsMVY3QldHRkFnbkNadmVu?=
 =?utf-8?B?VTQ1K3VQdGhFcUZMenUwM0w0VVROZEVjcDJyeVFtYW5BZCtvZHk2YU0zYnBD?=
 =?utf-8?B?eFRsSlB6U1psNGlkR1RuSFUvTFFMUEl5TkhKODFuUm5LTmk4N09QWHIwOGVS?=
 =?utf-8?B?clhSRUI5UjJRMGRsd1JCNXlsd1JDbmtYa2tTbWpaTUZPZmtwWHdyQ2o3L1o1?=
 =?utf-8?B?SDNVeVZ2Z1JmRHUvU0hBTXhQTXBpdklaQUlTeDVyR244WklZUjkrdVZPTnZO?=
 =?utf-8?B?WkpGS1ZHdGRzVnZqN3N5cWcyMjArOUI0eVo0M3drUEpVYkU2ZWwra3VmVmdz?=
 =?utf-8?B?aE1XN2ZLTWRhTmdDYWlGRTdlNUwvU1dPWFNEakxlR2h6a1J3WDlpNkk3ZFox?=
 =?utf-8?B?akszZG8ycWplUUlyT0tOU3dmWjl5VWNKN2Z0Rmd0M0Q2YTQzUnFwWE5mRlp0?=
 =?utf-8?B?ZHFmQ0tSY1YrU1p0WURFazkrMXM5MEtLRXdlb0dDOWliN2RBaG83dWQ1VzZK?=
 =?utf-8?B?eXNRN0UxWmhKc0JwWjl1blRBNDE5VXFUeWNXcTNYZi9mWlBqckJoa3kxM1gz?=
 =?utf-8?B?VmFqTXNGMEQ2c2dZZ2JOd1k4bmlvNksvZEhUbkc5KzZOdVVOWG91UFhpbXd0?=
 =?utf-8?B?QnpmYjY1WGk0aUY4b3lZejdGcTlXbHkwUWEvd3IzTXFwcnVPUUhSUkdLTm9V?=
 =?utf-8?B?V2d0OC9ja21qbWxYNHIwQzNlWnU5WUxyOWVpdkN1TDZVS1VmWGJFQlBJSklu?=
 =?utf-8?B?QTNWSkxiSE1MRW9qc1F5STk5WjRQZGx1ajUyMW5vODRFVmx0Qm5neERqRVRo?=
 =?utf-8?B?cHIwYmdvcUZWcForTUVxWXZzdHlFaXlsSnp2azN4K21FYmFkd1V5dS9BQmF6?=
 =?utf-8?B?U2dCMWhqK0tNa0JHQjRZTHFmNW93eFJCY1NOaGpjTkpuQnNSTmtURXZkdFoz?=
 =?utf-8?B?b3FvTWJROEdOZmRnYm5KMjhaOWQ2SXlqRXZ0R1Vncmt1RUVpVDg5Nk92cTlT?=
 =?utf-8?B?WUxEbzBBVkhVN3F0YlJxcWFYbEpzLyswWHlrbHNqS3AyeU8yN2p5WlFMc0Yv?=
 =?utf-8?B?ZnZVRThBUXh3WkUyTG5QSHI2bUg4OHVhWjdEOHNJR0JvSFhWbGdiSGJlM1pI?=
 =?utf-8?B?bDVUSU5IRWxrZFdiNUdKcTdRTmsxeTMxbUdwc0NFRGI2SUU2ZVhHNGc4RG9q?=
 =?utf-8?B?aE5GWlFxODdxWU9KempWSWJkazdjQ3UraG9aVW9NZnUxaGEvRExCRlNqUmF2?=
 =?utf-8?B?bkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F32113259E17DF408FB5615CA7B803E6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 062c8a49-3e54-4a0c-928a-08db7887a0da
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2023 10:00:11.7123
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oh14ufNKqzNlytMyOgYhDSqajB38qA6q2mzl2n9eBmG3HcrfWeTT3QKzmn9pwKPGBDVwuo8bDug7jSKuir7gOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4919
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

T24gV2VkLCAyMDIzLTA2LTI4IGF0IDE3OjI5ICswMjAwLCBQZXRlciBaaWpsc3RyYSB3cm90ZToN
Cj4gT24gVHVlLCBKdW4gMjcsIDIwMjMgYXQgMDI6MTI6NTBBTSArMTIwMCwgS2FpIEh1YW5nIHdy
b3RlOg0KPiA+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4Y2FsbC5TIGIv
YXJjaC94ODYvdmlydC92bXgvdGR4L3RkeGNhbGwuUw0KPiA+IGluZGV4IDQ5YTU0MzU2YWU5OS4u
NzU3YjBjMzRiZTEwIDEwMDY0NA0KPiA+IC0tLSBhL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHhj
YWxsLlMNCj4gPiArKysgYi9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4Y2FsbC5TDQo+ID4gQEAg
LTEsNiArMSw3IEBADQo+ID4gIC8qIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wICov
DQo+ID4gICNpbmNsdWRlIDxhc20vYXNtLW9mZnNldHMuaD4NCj4gPiAgI2luY2x1ZGUgPGFzbS90
ZHguaD4NCj4gPiArI2luY2x1ZGUgPGFzbS9hc20uaD4NCj4gPiAgDQo+ID4gIC8qDQo+ID4gICAq
IFREQ0FMTCBhbmQgU0VBTUNBTEwgYXJlIHN1cHBvcnRlZCBpbiBCaW51dGlscyA+PSAyLjM2Lg0K
PiA+IEBAIC00NSw2ICs0Niw3IEBADQo+ID4gIAkvKiBMZWF2ZSBpbnB1dCBwYXJhbSAyIGluIFJE
WCAqLw0KPiA+ICANCj4gPiAgCS5pZiBcaG9zdA0KPiA+ICsxOg0KPiA+ICAJc2VhbWNhbGwNCj4g
DQo+IFNvIHdoYXQgcmVnaXN0ZXJzIGFyZSBhY3R1YWxseSBjbG9iYmVyZWQgYnkgU0VBTUNBTEwg
PyBUaGVyZSdzIGENCj4gZGlzdGluY3QgbGFjayBvZiBpdCBpbiBTRE0gVm9sLjIgaW5zdHJ1Y3Rp
b24gbGlzdCA6LSgNCj4gDQo+ID4gIAkvKg0KPiA+ICAJICogU0VBTUNBTEwgaW5zdHJ1Y3Rpb24g
aXMgZXNzZW50aWFsbHkgYSBWTUV4aXQgZnJvbSBWTVggcm9vdA0KPiA+IEBAIC01NywxMCArNTks
MjMgQEANCj4gPiAgCSAqIFRoaXMgdmFsdWUgd2lsbCBuZXZlciBiZSB1c2VkIGFzIGFjdHVhbCBT
RUFNQ0FMTCBlcnJvciBjb2RlIGFzDQo+ID4gIAkgKiBpdCBpcyBmcm9tIHRoZSBSZXNlcnZlZCBz
dGF0dXMgY29kZSBjbGFzcy4NCj4gPiAgCSAqLw0KPiA+IC0Jam5jIC5Mbm9fdm1mYWlsaW52YWxp
ZA0KPiA+ICsJam5jIC5Mc2VhbWNhbGxfb3V0DQo+ID4gIAltb3YgJFREWF9TRUFNQ0FMTF9WTUZB
SUxJTlZBTElELCAlcmF4DQo+ID4gLS5Mbm9fdm1mYWlsaW52YWxpZDoNCj4gPiArCWptcCAuTHNl
YW1jYWxsX291dA0KPiA+ICsyOg0KPiA+ICsJLyoNCj4gPiArCSAqIFNFQU1DQUxMIGNhdXNlZCAj
R1Agb3IgI1VELiAgQnkgcmVhY2hpbmcgaGVyZSAlZWF4IGNvbnRhaW5zDQo+ID4gKwkgKiB0aGUg
dHJhcCBudW1iZXIuICBDb252ZXJ0IHRoZSB0cmFwIG51bWJlciB0byB0aGUgVERYIGVycm9yDQo+
ID4gKwkgKiBjb2RlIGJ5IHNldHRpbmcgVERYX1NXX0VSUk9SIHRvIHRoZSBoaWdoIDMyLWJpdHMg
b2YgJXJheC4NCj4gPiArCSAqDQo+ID4gKwkgKiBOb3RlIGNhbm5vdCBPUiBURFhfU1dfRVJST1Ig
ZGlyZWN0bHkgdG8gJXJheCBhcyBPUiBpbnN0cnVjdGlvbg0KPiA+ICsJICogb25seSBhY2NlcHRz
IDMyLWJpdCBpbW1lZGlhdGUgYXQgbW9zdC4NCj4gPiArCSAqLw0KPiA+ICsJbW92ICRURFhfU1df
RVJST1IsICVyMTINCj4gPiArCW9ycSAlcjEyLCAlcmF4DQo+ID4gIA0KPiA+ICsJX0FTTV9FWFRB
QkxFX0ZBVUxUKDFiLCAyYikNCj4gPiArLkxzZWFtY2FsbF9vdXQ6DQo+IA0KPiBUaGlzIGlzIGFs
bCBwcmV0dHkgYXRyb2Npb3VzIGNvZGUgZmxvdy4uLiB3b3VsZCBpdCBhdCBhbGwgYmUgcG9zc2li
bGUgdG8NCj4gd3JpdGUgaXQgbGlrZToNCj4gDQo+IFNZTV9GVU5DX1NUQVJUKC4uLikNCj4gDQo+
IC5pZiBcaG9zdA0KPiAxOglzZWFtY2FsbA0KPiAJY21vdmMJJXNwYXJlLCAlcmF4DQoNCkxvb2tz
IHVzaW5nIGNtb3ZjIGNhbiByZW1vdmUgdGhlIHVzaW5nIG9mIG9uZSBhZGRpdGlvbmFsIGxhYmVs
Lg0KDQpJIGd1ZXNzIGl0IGNhbiBiZSBkb25lIGluIGEgc2VwYXJhdGUgcGF0Y2guDQoNCj4gMjoN
Cj4gLmVsc2UNCj4gCXRkY2FsbA0KPiAuZW5kaWYNCj4gDQo+IAkuLi4uLg0KPiAJUkVUDQo+IA0K
PiANCj4gMzoNCj4gCW1vdiAkVERYX1NXX0VSUk9SLCAlcjEyDQo+IAlvcnEgJXIxMiwgJXJheA0K
PiAJam1wIDJiDQo+IA0KPiAJX0FTTV9FWFRBQkxFX0ZBVUxUKDFiLCAzYikNCj4gDQo+IFNZTV9G
VU5DX0VORCgpDQo+IA0KPiBUaGF0IGlzLCBoYXZpbmcgYWxsIHRoYXQgaW5saW5lIGluIHRoZSBo
b3RwYXRoIGlzIHF1aXRlIGhvcnJpZmljLg0KPiANCg0KVGhlIF9fdGR4X21vZHVsZV9jYWxsKCkg
YW5kIF9fc2VhbWNhbGwoKSBib3RoIGhhcyBhICJSRVQiIGF0IHRoZSBlbmQgb2YgdGhpcw0KbWFj
cm86DQoNClNZTV9GVU5DX1NUQVJUKF9fdGR4X21vZHVsZV9jYWxsKSAgICAgICANCiAgICAgICAg
RlJBTUVfQkVHSU4NCiAgICAgICAgVERYX01PRFVMRV9DQUxMIGhvc3Q9MA0KICAgICAgICBGUkFN
RV9FTkQNCiAgICAgICAgUkVUICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIA0KU1lNX0ZVTkNfRU5EKF9fdGR4X21vZHVsZV9jYWxsKSAgICAgICAN
Cg0KSW4gdGhpcyBjYXNlLCBJIHRoaW5rIHdlIG5lZWQgdG8gcmVtb3ZlIHRoZSAiUkVUIiB0aGVy
ZS4NCg0KSSBkaWRuJ3QgdGhpbmsgSSB3b3VsZCBtb2RpZnkgX190ZHhfbW9kdWxlX2NhbGwoKSBh
bmQgX19zZWFtY2FsbCgpIGluIHRoaXMNCnBhdGNoLg0KDQo=
