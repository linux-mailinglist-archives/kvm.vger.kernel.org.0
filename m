Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A64695FCD5C
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 23:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbiJLViA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Oct 2022 17:38:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiJLVh6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Oct 2022 17:37:58 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20A96D73C0;
        Wed, 12 Oct 2022 14:37:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665610678; x=1697146678;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=U7Q+W/8MRzD6TPEhDoJd5qZqna5e55xD0PwlR7huhnU=;
  b=U4GamtzBMpb77aBpszEpsZL9YhEdQa2sBOx17YGCBJVXSJPWLP+jgCum
   uy01w8WDtRgyyVs3AzmZo7xCRY4wHrP8ija+c1akePaN8eLP8Py0D22Ro
   xtxCCXHnTQfzxqIq8nrp5MRLXS7nYCECfXoSQC5sYTRNGQyAlor/HVM4p
   9LP4b2mDkQPQyqSa2XD+gTYxAOQm8r//nksQW1jc3PDBP6NukFCm+mX8X
   OY2/HZy7zAWiyfy6wDFnIAq9raO1GaJk/tqTv2W8aXmZSlLkX7KmQVAyf
   5ePoaR4zrjBzc2cavdnO1ImGABOnQEoaHgpoi8XCzass/siyU7NuSJcZY
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10498"; a="306545715"
X-IronPort-AV: E=Sophos;i="5.95,180,1661842800"; 
   d="scan'208";a="306545715"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2022 14:37:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10498"; a="955914539"
X-IronPort-AV: E=Sophos;i="5.95,180,1661842800"; 
   d="scan'208";a="955914539"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 12 Oct 2022 14:37:57 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 12 Oct 2022 14:37:56 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 12 Oct 2022 14:37:56 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 12 Oct 2022 14:37:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nO6mix/DDxHKY19CfjvzB411CnFvf0WP4TxiYxTq7tfVyx+AXgiFPSv+Nej/pkIgehisMtl/uCT/hqMfQyX26Afk7w/+9J2+wUoUI7HTaGJQaqzt+DzGxPQIYJE4SVCrG90gDHmCw3J9lRxs/OXzivErlJ4nvlsYuR1Bk1Vm/v8gYQv12nKss9YNecDeZW8QpR9YLxYp0iMtMrVWB7RZBL2YHVeTt9WtYWir3FeruzlVoAn8QJNcBQLxiD3lqjOxcOpZ/wvuiKCyk9PrGyW0d7CKiI9HXjBOVsBU0qDf/pWlbtAhaLDb9L8cCi51CjebBBwDswqtlFdLKRDx6z+hQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U7Q+W/8MRzD6TPEhDoJd5qZqna5e55xD0PwlR7huhnU=;
 b=HS3U+uJZltn62lroZ4urT/GTYgu8+O0kVhFdRhSFCkY3OyJgUKQeWBXbIuJdY744s1FteUKENUYKUM2BRkHQk0lRn+h1sRKIf4JgjB4fxojLQ+Ozi1p1LM1ZN7+q3RJFyubDVpvvj8f2tUCqjuEudNFord1gpDjuldK9nds+l+x2nR3VQZ52M0HEFFQ0bF8sGWzXyKX4tdFE592d+vcbAbhnOl61B5Mn5BwYXKep2IzKbeWBCuwQZD8RLWyGk/ZJYzCav2l9oQU2P3TGALt4HM/+jikKkcFDW9KXGq7DwHfgYDu4zSnScI3D0GKnUthhnDaGO9P21TqsTZdzUMQyYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA1PR11MB6822.namprd11.prod.outlook.com (2603:10b6:806:29f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.20; Wed, 12 Oct
 2022 21:37:54 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b%3]) with mapi id 15.20.5676.032; Wed, 12 Oct 2022
 21:37:54 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v4 01/11] KVM: x86/mmu: Change tdp_mmu to a read-only
 parameter
Thread-Topic: [PATCH v4 01/11] KVM: x86/mmu: Change tdp_mmu to a read-only
 parameter
Thread-Index: AQHY3mb+7H0BvXpBk0qvbRW4Chi/sK4LSPaA
Date:   Wed, 12 Oct 2022 21:37:54 +0000
Message-ID: <0dead0fb06a604593cc686ebd298a6f6493afe83.camel@intel.com>
References: <20221012181702.3663607-1-seanjc@google.com>
         <20221012181702.3663607-2-seanjc@google.com>
In-Reply-To: <20221012181702.3663607-2-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA1PR11MB6822:EE_
x-ms-office365-filtering-correlation-id: 569b0abc-3b69-4012-a8e7-08daac9a0594
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +IcfuHxGRRdVGIScJma4QRuhn27NrLdIpjZrZMmq8NBxUDp53YHRkL69tD5mF+LGou+Glwq2bA9QdK6fD5BpEltIpjM9jPChTiq0gzKXMgc73TV8TLAJB706BzCab1z5NnOobsXpMa/AhD/wGH6bo8//VtUMoVGDOUEq+WX9Z0KMihauC2CTl96BYkFaS8sGMYeaY8KnP5oylwN9bT+2Y6rS8p3PDB2LSK+jxdSQVncXe+1dM8fVNLFaK6pizRnzZIMnVvjADsBbMYw8mpM+z1MWgBZq+AnAzWXu87QobsGtY+4DAy70uOujGEfbWUDUo5V8g9kQHbF1/YUWbIENHYhPaKVx6LTw+QcDAO7bch98zlHKDtikUreCbrnfBTJWeJWnPe/2rIXqDgHHPVmBdq7Btfee2fU/0kVBVwJ5VhlYQAi/b9rw4VzTvPgv7rS/PFFtDET7+eh7CqhsuDJTjhJGVg7H2T1JAGq7bYXVxYcuUTDhiVD9p73r1p+TK96kSI/ICiBWAsOFFwIuq000mESL9mCmrgOGFLOZg0BP8PChJwcQzNAozuXp+Hc6NWJUb9iIajkM1T9bQoHCc2cWc1rJ1F4Haa842PmSa6NtaTSBb4DpxUzOO5N8oMR3w+A3zeP4p7Awrpkywo5lLU+Tpebnd2c+EeLw6AqTgOMBHRKiLrNVv74jO8PJDXrkU1IpxI5pJLwzyx4X/OlT2CRBJARxDfbj6TiW1IDKJBHa1mcKiET2vnKwFFl6ZJYLwZgw+pzrwMdmoPJDWhgZXFZsug==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(136003)(39860400002)(366004)(346002)(451199015)(5660300002)(91956017)(316002)(36756003)(107886003)(6506007)(8676002)(66556008)(66946007)(76116006)(4326008)(66476007)(41300700001)(66446008)(8936002)(26005)(6512007)(38070700005)(38100700002)(82960400001)(122000001)(2906002)(2616005)(186003)(4001150100001)(86362001)(64756008)(6486002)(478600001)(71200400001)(110136005)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RG9MbXhrWVJoa0RDckNVTmhoTytKRnhFc1I2UlpLRzBJa3M0LzlIZnd3UzE0?=
 =?utf-8?B?eUlvMGJaUUMxaCtoTXAydUV4MGlQbFRVZDRaSFdBVVkzaWZGUWVWcWpBY05J?=
 =?utf-8?B?ZFZxYi9DNFVuRkF6ZkhDQzNLYWZBMkVDbWZSemthdmw1R0RwYU80NFhoTUZ5?=
 =?utf-8?B?cHBxMnV2WDk2RXFWUEtyM2NWOUxac2piT016ZWlBWDhNVXdTR2tFbnl4ZEgv?=
 =?utf-8?B?YTdza3NuK2FCUEkzaG0vRUxlVUpEamF6ZTRtVlZaNDBLTlhodjA2cStva28x?=
 =?utf-8?B?ZjFkVHJoMVBIRGlRZ2xIN1J6dEZ6emtXSitaNVNLcnZHOFpYZHdraktTSzlR?=
 =?utf-8?B?RkZGRlJ5azZIcEZpNDR2OXNYMDlqTGMxdjM4ZERZSk1wZDBzQWgxalZ3Ritu?=
 =?utf-8?B?aHQyeXlGRVhLWVpZaGhTY2xRd2Y1Z0xWSUxId1Fxbk9xaENhNVRqek9WUktB?=
 =?utf-8?B?OWc0OHU1KzdCNWphMDNmZnhnYnJlRFpEZDdKTUlZWHpNSmt4ODl4VkZFdk1M?=
 =?utf-8?B?ak5uZVlxN0tibkd6aHhpNC8rYTVJMlJUYnVSaE1TNSs0NXA3QnREYy80TVVF?=
 =?utf-8?B?VVkrOG9TZDAyZzc2eUtMbTc5TG9JWTVDT2hXY2pNNjhYZEVWMFlVMGtmcW5I?=
 =?utf-8?B?LzRNdGwzWVZCRWl2eVhDQkxxcWhwS3FyWlhpV3RhRHhlenJ0VWlwdzkzdVJ2?=
 =?utf-8?B?bTBZbjY3ZU4xRDV6b0h4UDEraFJtMUhVOVdYSmRNRUlRdWVIaEN2QXYxOHFi?=
 =?utf-8?B?VEh2VlRUVXFTSkxhb2IyRlNDU0toVW8wcUkrQkVlYTFpZkRSdUtHdGIvNEU3?=
 =?utf-8?B?cnNJSzlCdVhPbGtKeStWSk9FbWxqWFJTL0txV1B6WEthcDBSWlUwWDdXVkxF?=
 =?utf-8?B?WGI5TUZUMUhoaFZsT2g3K1lYdDh3V3Bkak1PRWlhSllOYmNxOUw2SVFMWkdk?=
 =?utf-8?B?dEl3ZlBiWE1MR2hEdk83bi9JRkt4dDA3dzRKbldwL05ieXo3bis5Q2Z1dE9U?=
 =?utf-8?B?bSt2T0swZi9iZFpOMHAvQjY0UUQ1WEtSeFFxSzdZS2VqYlFyY3p3TW8yZ1Zl?=
 =?utf-8?B?RWRHQ3Q3dnB2clBDSyttK3ZNWERWb1UzRnZwTEhLbFhQMkxZajFlY2hYdFN6?=
 =?utf-8?B?cjNZZGtzTjRWeHJEbFl4dU9oUHZhVDZVdm5Hb2V5Q3J4QVVIdUx3Ty9TZkty?=
 =?utf-8?B?UjNsbjZOVVNmaTVEUTVWWjlMWEVybHV0eFNkWVdBK3N3WVFqa0dKbk5POWF5?=
 =?utf-8?B?bmZ2Qmc2cXpOWC8xRlp0dERoR2RyS2toS0xuTmJJYU5WUk1WLzc4Q0F6a1VD?=
 =?utf-8?B?K2VsK0o5Y1VzZ0UxRHQ1RlRYV3pxNkxpN1dGYkk5NmN0b014S0N0aE1xRllG?=
 =?utf-8?B?QmgxU0JFeFhKS3pUbFlRTnVmcElaeERqcWhYd05Zc2wwbXJ2RSs2OTVaS0Z1?=
 =?utf-8?B?VmlZand6N0V3UVUwTXBLeE9kTzlORzJOdzdEOUwvK3VjZmpiZ1EzYmQrREhr?=
 =?utf-8?B?Y0xZZU1wVVpVRHJEWW5LdVNTcGhjME03c1JtaEJDRlU1eFhmSXNGSFpPTWRQ?=
 =?utf-8?B?aXNBSGlPaERDdVgzT1E0SUt4bnRqdTExbkRHZGtONXdHUUZBSktTd1Y4cHR3?=
 =?utf-8?B?bUwvV0F1ZXhaNlY2NytwRDg4NDVMbllsNGZlWFlwa05kRkdHRGVYTjRCZ3FB?=
 =?utf-8?B?b3diaVQwN04rQTJzalRLWGpGd09pZnd0bnpKNDZyR1JHVmdyZEhXMGR5emlz?=
 =?utf-8?B?dzB6dE1jQlFSUGxGdXpaU0V6aExhakI3TnE4dlEzcVdEME9oeUt4NjJLaDBI?=
 =?utf-8?B?NUh0UWhjUWU5b0IyRC9RanJOMzJZRzVZSkc4RHVOMnFEb3N4VDR5anQrVWdC?=
 =?utf-8?B?cFc2dHhuZ3gvYW44bGNQdFQ4Wml5OG8wdHE0S0t6SzJkcHF1dlNoVU5DUkc3?=
 =?utf-8?B?TzJUOFo5b251STB0c0FjUzFFUzEwRjNSdFA4UXZBbE1KdjgvZTNJSFJRWENM?=
 =?utf-8?B?NjB4aXR4WUxZMWJ2T1dINlFwYmJNZE5hTDVDN3RORkpKYWQ1NmpSMVM1SHNN?=
 =?utf-8?B?RWRlcHNQcWtid0YxUE5uSVRiRUNlQXljOEducFJCbm4vVjNPV0ZjeEkwTFdu?=
 =?utf-8?B?azBmcUFqM0ZKWUhrL3ZkclhDLzZ0V05GenJLeUIvckpvdHpwb3dBcGV3V0Qr?=
 =?utf-8?B?VUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <603B568619A96E418F0D00B275F32EBC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 569b0abc-3b69-4012-a8e7-08daac9a0594
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Oct 2022 21:37:54.4759
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pDkG9XzPYc4KIFtajzctXjb3BHC+mNhorGnXp3n74zhakrPPojcGy3yOtHg7WXqpbZsZMns/FjYIRDG9QkHShQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6822
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIyLTEwLTEyIGF0IDE4OjE2ICswMDAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBGcm9tOiBEYXZpZCBNYXRsYWNrIDxkbWF0bGFja0Bnb29nbGUuY29tPg0KPiANCj4g
Q2hhbmdlIHRkcF9tbXUgdG8gYSByZWFkLW9ubHkgcGFyYW1ldGVyIGFuZCBkcm9wIHRoZSBwZXIt
dm0NCj4gdGRwX21tdV9lbmFibGVkLsKgIEtlZXAgdGhlIGlzX3RkcF9tbXVfZW5hYmxlZCgpIGhl
bHBlciBpbnN0ZWFkIG9mDQo+IHJlZmVyZW5jaW5nIHRkcF9tbXVfZW5hYmxlZCBkaXJlY3RseSB0
byBhbGxvdyBmb3IgZnV0dXJlIG9wdGltaXphdGlvbnMNCj4gd2l0aG91dCBuZWVkaW5nIHRvIGNo
dXJuIGEgbG90IG9mIGNvZGUsIGUuZy4gS1ZNIGNhbiB1c2UgYSBzdGF0aWMga2V5DQo+IGZvciBu
b3cgdGhhdCB0aGUga25vYiBpcyByZWFkLW9ubHkgYWZ0ZXIgdGhlIHZlbmRvciBtb2R1bGUgaXMg
bG9hZGVkLg0KPiANCj4gVGhlIFREUCBNTVUgd2FzIGludHJvZHVjZWQgaW4gNS4xMCBhbmQgaGFz
IGJlZW4gZW5hYmxlZCBieSBkZWZhdWx0IHNpbmNlDQo+IDUuMTUuIEF0IHRoaXMgcG9pbnQgdGhl
cmUgYXJlIG5vIGtub3duIGZ1bmN0aW9uYWxpdHkgZ2FwcyBiZXR3ZWVuIHRoZQ0KPiBURFAgTU1V
IGFuZCB0aGUgc2hhZG93IE1NVSwgYW5kIHRoZSBURFAgTU1VIHVzZXMgbGVzcyBtZW1vcnkgYW5k
IHNjYWxlcw0KPiBiZXR0ZXIgd2l0aCB0aGUgbnVtYmVyIG9mIHZDUFVzLiBJbiBvdGhlciB3b3Jk
cywgdGhlcmUgaXMgbm8gZ29vZCByZWFzb24NCj4gdG8gZGlzYWJsZSB0aGUgVERQIE1NVSBvbiBh
IGxpdmUgc3lzdGVtLg0KPiANCj4gUHVycG9zZWx5IGRvIG5vdCBkcm9wIHRkcF9tbXU9TiBzdXBw
b3J0IChpLmUuIGRvIG5vdCBmb3JjZSA2NC1iaXQgS1ZNIHRvDQo+IGFsd2F5cyB1c2UgdGhlIFRE
UCBNTVUpIHNpbmNlIHRkcF9tbXU9TiBpcyBzdGlsbCB1c2VkIHRvIGdldCB0ZXN0DQo+IGNvdmVy
YWdlIG9mIEtWTSdzIHNoYWRvdyBNTVUgVERQIHN1cHBvcnQsIHdoaWNoIGlzIHVzZWQgaW4gMzIt
Yml0IEtWTS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IERhdmlkIE1hdGxhY2sgPGRtYXRsYWNrQGdv
b2dsZS5jb20+DQo+IFtzZWFuOiBrZWVwIGlzX3RkcF9tbXVfZW5hYmxlZCgpXQ0KPiBTaWduZWQt
b2ZmLWJ5OiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT4NCg0KUmV2aWV3
ZWQtYnk6IEthaSBIdWFuZyA8a2FpLmh1YW5nQGludGVsLmNvbT4NCg0K
