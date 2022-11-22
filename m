Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2D4633118
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 01:01:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231820AbiKVABe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 19:01:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiKVAB0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 19:01:26 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2FFE1D30E;
        Mon, 21 Nov 2022 16:01:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669075285; x=1700611285;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=KU/CRJB7Vj28ZaeK9I1pB2j2Ru6zyl9zX8tH9IWzeZE=;
  b=XNfRikY9WpToJR9S1SwKkkkoRZQGuEM+O6QVgViSnNHTcejOGRz+PveN
   ohyLnuefgyNEIQVqmot7eam/tFEey1YnQHNw14rr3cmcX5hs0Mbsj7Fbd
   obfRadZ1e1d+ukk7Hx1ULpXGBBRa4TbgNhNZseU6nx+nE/bdqGedVLYH7
   ZpQKeobIgP6AfTq5Wzcojv7sVij+QFz104/B6yySoR0Ctxk+Qm/t1pzPr
   V0OQ+CPIN5hJOuHOmOHqKpEp5MTZqWlFscUE0hv9LrWY2b3vy5YpxkD6R
   EUDI2vj8ZEGnH17ilGnhbK8yQQNhJ1hmoNzoXGjCHVjB/dJQbruTRYflO
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="314839358"
X-IronPort-AV: E=Sophos;i="5.96,182,1665471600"; 
   d="scan'208";a="314839358"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2022 16:01:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="635353758"
X-IronPort-AV: E=Sophos;i="5.96,182,1665471600"; 
   d="scan'208";a="635353758"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga007.jf.intel.com with ESMTP; 21 Nov 2022 16:01:24 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 21 Nov 2022 16:01:24 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 21 Nov 2022 16:01:24 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 21 Nov 2022 16:01:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VW0qOXWF5/4iY7olSvwK4XifbM973ja4kW2Eg1sUHIukRVKQQCkMdSPB0vH2fUiU1lGj8h0/vRZoN9NlazQgehYkZtltzS3M8o5OROElV0PY9Aa2XD0Yl4cz3dJFTjcsC3VlUmIS4I0gbJRLegkKzN4J/8D/yK6SSyd2D53T2wII0VjPgRJRQehbwaOtaLfkiZUEIwbTjvcgmIt1ZEKbRBWBjiWhz6+U3JBM8bIKz2Dnsi+M8DS8zydMMjmcNWjAwzebZ9NzlHglDhvctuT9IULRQfW1wecEh/L0X2uRCjSuZVRMMNFGAn361e0lyVDn6bsV62p3SnrJdaMAhuDE/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KU/CRJB7Vj28ZaeK9I1pB2j2Ru6zyl9zX8tH9IWzeZE=;
 b=IHGn550tfEGQySpCkuqcS6Ae9B2mMDHGJTRxa9WOQ7ubLZScnNijvraZ0AkXKLqxTuzFy4g5vKTHkwtSsiTXhh7orD1VIEqJI4rmSXvc7FbncHxwXQBK1Ain5T+CbMsEOzKNL/9fI185RQSheRtIGdbuMuxQy6OViudcz3LSF42FVHFjcvQjC/r9toBqlx+4Rs1WCeStiog0KpViL07jBMzRjRezXMYCrRRQPpKuz3EbUkkzDHHS1NGjqHeb/1Kx4/NoGQ+OhysAeOfphN1FCwGkCijgCEKjkE/oDi0IFsYiAf9DlMBjI5KRkLXdFgqTQWECoP/ZU2L/xmL8X1k/QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM6PR11MB4593.namprd11.prod.outlook.com (2603:10b6:5:2a3::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Tue, 22 Nov
 2022 00:01:19 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 00:01:19 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v7 01/20] x86/tdx: Define TDX supported page sizes as
 macros
Thread-Topic: [PATCH v7 01/20] x86/tdx: Define TDX supported page sizes as
 macros
Thread-Index: AQHY/T28NJwJCQ29uEGaaLK5clcXr65KDO+AgAADrAA=
Date:   Tue, 22 Nov 2022 00:01:19 +0000
Message-ID: <9e27993791738d37e9aa650e982a7230500b913e.camel@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
         <d6c6e664c445e9ccf1528625f0e21bbb8471d35f.1668988357.git.kai.huang@intel.com>
         <6260c853-3c6c-7302-677e-1910918c69b7@intel.com>
In-Reply-To: <6260c853-3c6c-7302-677e-1910918c69b7@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DM6PR11MB4593:EE_
x-ms-office365-filtering-correlation-id: dc9ad6ab-6d82-4a4a-7eee-08dacc1caf2d
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nGGjlTq8opyjYkyLJYpCxIDx5Y5wK1I04RlzeqCipCbjsHMk+9E2UbBRti/zhCIBbiSFVljow8O+2XxbATg7aH6hIjcEyVcYL53y+jL1s1qtE2JkVr7Lc70gR8tepktPhU+TdYfKmNV93GKUnwU2Gvzt5aH6j3bWxF0gX7v/OiIz5NOMKPc6dcg//QBjuXeSKv0JT4J+m2eUR1X4C0rK7q+XLII7jH5c9D9rfiwGrZUGMTJBwv1gxTGeS20DR9YEUZXjvyuMlfTRJD9jCSonmuGOluTZ9JVzWb3LUSf1qk1mr1gVT0ijTXyIDs0OvSz+tAaOJzOOL+rU6kP6I/WG8g16fzUppXpQahFIUoLt4Y7ZpwrcDg4/XJhHx8lk81JL7wT6DZAzwhP7q1R7f0/NevVGzP/EYlXQ/1JA+Z55HFBLY/5yT/JZwgCOqqa30AKmXVr1sixMTgTawz857ZdVQJYFNQxn8pbDkizDJfUN8XVRXDGdA2jl2UmMHMzWFI3mJgWdbqlD5bnA98YypEjMR0bgVl7piScdHI/4sh7whdSchsXbanZa5p7wVtlesdBhyT+hJYlzD+5o1lyl8NwuhrzGaxOmWVDNatySts4/8jddQCHAwyuS7m4gpwVB6dcVWvrGj7UNjPreaUmDhh7Q4VNaQIB2fA5NVBXpl7TgzuiogldKQF94GHj6z9w2/Hhn1BdDy1aNck0aV7U1e6PM8g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(376002)(396003)(346002)(136003)(451199015)(36756003)(86362001)(38070700005)(64756008)(76116006)(4744005)(5660300002)(7416002)(2906002)(4001150100001)(26005)(2616005)(186003)(6512007)(122000001)(38100700002)(82960400001)(53546011)(91956017)(54906003)(66556008)(6486002)(71200400001)(6506007)(41300700001)(8936002)(66476007)(110136005)(66446008)(66946007)(4326008)(478600001)(8676002)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TUd2bDJMRC9nMjd2WEo0VkVteERINy9aZm0rUE9CbCtMUHlndXY3RXhveWlU?=
 =?utf-8?B?bUl1UndiWDJBMHlsS0VTYlJUUkNQWTJMZ0loMmU1NFJxdjgzUjRxbEFBbWNZ?=
 =?utf-8?B?QmZkR1ZscWxnY28zS3ZLSFhBL21UQnUxT005eUJvczNoZGR0V2l4R2J3MlNP?=
 =?utf-8?B?SXY3a0FSaXBWVVRwQVFqSlhZR0h5ZW1CMEM5OVZwSGJPd1I1R1g1ZTVYek83?=
 =?utf-8?B?bnlaeXQzNjBPUVFuM1ptUEtxM2I3ZnJNN0lzdXplQytGdlNORnlCcUJUdkFK?=
 =?utf-8?B?TzR5WHpvdG5oUmNUUERTLzMyd0RHUFJ6RUVVMTZxNTgyVk42ZGNCbEJhWDV3?=
 =?utf-8?B?eHlYSFFoTjFrY01GT0xXZTNhbkloQXA5UzdJVVpLRjVzTTJQZzFuL2YwZno4?=
 =?utf-8?B?bVF6Tzg1N2xwWWQxRkdwYS9hanhWaXB4NDVPbGFucERneXMyTlhGWDd3Vi90?=
 =?utf-8?B?M0liTWdyamJJcFNvMkRLKy9WazBKbzRaVk9iQzJlSytQbkVBTGQ3VWp0ODFE?=
 =?utf-8?B?QWxILzVlWGQrSVZzYUFEa3dla1l3Mk5XSGZWcW1Pem9kQVNoZklGTlpycmUx?=
 =?utf-8?B?YWdEcHBKOFdCZzRlSHl6aCtFaVQ0Sk0rLzArZFIycVJuUm1PcStaRExkQjRH?=
 =?utf-8?B?NmdZekR2ZEprdElFUzcyczVYQmQ4YWtpdUpWMC92bFZ3MVVsYmFtSVlkcjRl?=
 =?utf-8?B?NHAwaFZkZ0tRcXBGWll4RDh4WEpiQ1ZwSUV0RlFOS0FySGZWbjF6MGJ0Z2ZD?=
 =?utf-8?B?eExoQmFiQWw4VjJGUHlXVklsb1hMd2tmTVhlZHljTFN5ZCtMZFl1K1pqejlJ?=
 =?utf-8?B?QkZNNWNwcjlmN1JNUmU2RmVoUmlJMmR4Zk9rV0xlQlFYVE9MT3dERm45Znha?=
 =?utf-8?B?Unp3OWR5NnZUbW5LSE1qL1RaaGJaUUZvWW9UYXNiREMyYmVjY2RoTUFIcWJm?=
 =?utf-8?B?QkZMZEhUaXpJY0ZjRDAxanVXeUdhb2JWbm9ETW5mMVM0dEw0dWlnRUwyWWZs?=
 =?utf-8?B?Q0ExOUdTSkN5NWVtWXJtNDFHSDgrRjFxUmxGWXlKLzRESEg1RENsbDJRbmZ3?=
 =?utf-8?B?TlJ6ekZrTVZKazEyVE9mbXVtSXYyY3I3dmQrTGVqRE8vMy9ab1AxSHBoZndJ?=
 =?utf-8?B?TExXcU9UMmFLbTBnL2tDQ3hvQkNwRUxsSk1QRDkwKzdmQkh4dzZwbWVoYjkv?=
 =?utf-8?B?eDNkV0hrUjFnNEllUDg2cWpicms1Zkc0T1BJUzlXczU1eTVuOWxFVmhQbkVj?=
 =?utf-8?B?VGwzeUduNEkxZy9CWFVRa2U1b2pyMEt2eFQvZE5DQ0J0WUlzNGRHaVNxc25V?=
 =?utf-8?B?L1Q4dklsYTJjSDgxbjhWNlFrOE52UWs5eVBEQm5qVk1hMWJ4VUJEbkFGQVhM?=
 =?utf-8?B?K25rT3BJMkRvK1ovSDFrTDZWSmN1TGhVS3NucytnWjBNSlVRMFBGSU5YdjNi?=
 =?utf-8?B?a0RvMVV6YzdhT1BNTXBHbVh3QzJBRmhWSXdUQlU3ajkyZnhDNWN6RW4wZFVS?=
 =?utf-8?B?Q282U0pRZC8wQjlRMGNrRERNakpTWHlteko4cTlpZmI0eHBDQTE2YVBKcVFy?=
 =?utf-8?B?bGtZb3BuZFg1TUVHaVFQY0xSUzRINDV2ZmdtT1hKTmRnN0xJdW9MS0pWT2VV?=
 =?utf-8?B?RkwxcHFrcWZtdHZUZ3JabWpKbWpvSDBGcUFKS0ZvRXZFRVlHTVNIUjcxTlVU?=
 =?utf-8?B?K2NUNWxWMk9rNmkwZmJzTjFUeTNtYWlTQVFDeTI1Ym5XVko0S01icGEwdHk2?=
 =?utf-8?B?ZzkyeEV3MGUzZHNIUXRJZ3Jka1NGSzYxaVVtb2J1L2Y0c3l1cE9DcGFWOUhi?=
 =?utf-8?B?MDJ1Zi9Ec3pDZFp2N1pjM0wwd1g3ZHRMTzU4RndDb09Mbm5YcEhIOHlOSHJ3?=
 =?utf-8?B?VzEyN0tSTGkydmg0a2FBTFRNLzBVZGhXWkZtSDIwMFp0cWpXbEljOUYyczJq?=
 =?utf-8?B?MHJLajY2bWc4eEs0T3NzYzdVVTdwcFVvT1hRT05OQmpGcUM0OXpYWU5UL3pj?=
 =?utf-8?B?cG9xWDBTRTdrK09FU2RqNjBoZ3U4MlBNa3g3N09lS0ZoMGhEYTc0STM4c2Na?=
 =?utf-8?B?TFpQSzFYVGI1Y1o5U2Z4aUVWSWxPUGMzcHVoUHhUd25WSWxFLzkyL3c5ZCsx?=
 =?utf-8?B?NW9YMEVwbjhGMzNvR2FFbVM1dC9WT0VUTmF6ZG1pdlRpOUF2T01qTmJXdjJ0?=
 =?utf-8?B?WHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DF26DBDE4D2DBE4E812D0972742C18F8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc9ad6ab-6d82-4a4a-7eee-08dacc1caf2d
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2022 00:01:19.5866
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZU1h8KtGvhuHVtM/sBJSW+pEKncK43lsxYvfIaqSzmMw70uDD/9g5junx82JXDpx2CfxC9jo/aliZDbTi8OLoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4593
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uLCAyMDIyLTExLTIxIGF0IDE1OjQ4IC0wODAwLCBIYW5zZW4sIERhdmUgd3JvdGU6DQo+
IE9uIDExLzIwLzIyIDE2OjI2LCBLYWkgSHVhbmcgd3JvdGU6DQo+ID4gKy8qDQo+ID4gKyAqIFRE
WCBzdXBwb3J0ZWQgcGFnZSBzaXplcyAoNEsvMk0vMUcpLg0KPiA+ICsgKg0KPiA+ICsgKiBUaG9z
ZSB2YWx1ZXMgYXJlIHBhcnQgb2YgdGhlIFREWCBtb2R1bGUgQUJJLiAgRG8gbm90IGNoYW5nZSB0
aGVtLg0KPiA+ICsgKi8NCj4gPiArI2RlZmluZSBURFhfUFNfNEsJMA0KPiA+ICsjZGVmaW5lIFRE
WF9QU18yTQkxDQo+ID4gKyNkZWZpbmUgVERYX1BTXzFHCTINCj4gDQo+IFRoYXQgY29tbWVudCBj
YW4ganVzdCBiZToNCj4gDQo+IC8qIFREWCBzdXBwb3J0ZWQgcGFnZSBzaXplcyBmcm9tIHRoZSBU
RFggbW9kdWxlIEFCSS4gKi8NCj4gDQo+IEkgdGhpbmsgZm9sa3MgdW5kZXJzdGFuZCB0aGF0IHRo
ZSBrZXJuZWwgY2FuJ3Qgd2lsbHkgbmlsbHkgY2hhbmdlIEFCSQ0KPiB2YWx1ZXMuDQoNClRoYW5r
cy4gIFdpbGwgZG8uDQo=
