Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7769F6374C5
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 10:06:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbiKXJGg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 04:06:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbiKXJGN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 04:06:13 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8BED115D25;
        Thu, 24 Nov 2022 01:06:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669280772; x=1700816772;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=DaG61x5sm8/cvzqhRANRW8qPkTIz4/AujwUpRtWvjdM=;
  b=kggr0vKOxIv9AkxH+hLLIz4lLYM+dKktEL47u8rCIau4ScQadT3m3CBj
   LmTfbTX9M+8FB8osSpID7NFooa6u8rCg0MmPxpv35+4uif4iJm7FH7gYy
   SnEmEabzSqjtcGS55wZSLDUXrTsBFqs6znIz7Kr87HtUxF/4AJzX3E5pD
   3CP6V7V2mFwZ5ydBxUNEQYx2nmErc1jWWEzfbNQ0H3C5zWsXpWFy2pS7f
   K2hkEmEesYXmw25Qx8VsMqBziu3eF8eK28xH0undyNMb8SpwGOnmSnXsO
   n3s6vK4cjOT2YpTU18HbiYpYZKoUVd5sRRqF13UHOJeKasO/49W9kDDm2
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="316078279"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="316078279"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 01:06:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="731074487"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="731074487"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by FMSMGA003.fm.intel.com with ESMTP; 24 Nov 2022 01:06:11 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 24 Nov 2022 01:06:11 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 24 Nov 2022 01:06:11 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.104)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 24 Nov 2022 01:06:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S608AU2V/sojKTmp9SsGy0srTs243HqhjanovVigcNDB0eAnH3tuwxpdOoYeCuCLuO/oJNORM1XZ/JPg7nhbu6qxDCdGX7xxN8NGKSFdk4CMijNL02MgkZc/ADc9hjirTUYel8feJ++EZEF+Yhx3gc7rKHA+uYHhJDPGG0V99htaRtxyBQT3pKAU7AkeJ8NP6MjgUF6SKrSUNumZS6r9zEDmUhyEteZ+pg7izTds6klvMR2731bDzZYj6+s4PBMw4cwE63eTG44RR914XgND29rYDv/Cx1WyezUJjQsw6yuZT2ODLMYlqkTLsb/LCqcZLaEGXGUl5Wa8vCHDwKge9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DaG61x5sm8/cvzqhRANRW8qPkTIz4/AujwUpRtWvjdM=;
 b=M+UcizG4Vqc+aAZuk67f1mrwkpsPVssytV7Ohxh3HouNcwAQKKF2VA8rcWMCgxfRkW2gocDbREVo7BFBlAtL3W5xDhcPPbhftDbhiC8MQ+aJbvQdG+QZl2XDwBfqEFJOztXrvwZ7Mrd+affUEQgj1QBD+7AY1rPHDLGsil78rzMyXhEDit/r6ECJyPG/L+mHRRZA//MAm05nsNvmNETjGCzKUb18ot10EgolI2ACkWh5TJ9idj24UyOKVT9IGHD4Mw2E171SbNXF5jBslRe8e5WtYOddcTPm1cc+R4Lh2Cjvb7NT5GAbkNZH3Z++roQoH9zhqB8ORRnXZSHdTmWhVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by BL1PR11MB5334.namprd11.prod.outlook.com (2603:10b6:208:312::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Thu, 24 Nov
 2022 09:06:05 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5834.015; Thu, 24 Nov 2022
 09:06:05 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Williams, Dan J" <dan.j.williams@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Hansen, Dave" <dave.hansen@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
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
        "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH v7 10/20] x86/virt/tdx: Use all system memory when
 initializing TDX module as TDX memory
Thread-Topic: [PATCH v7 10/20] x86/virt/tdx: Use all system memory when
 initializing TDX module as TDX memory
Thread-Index: AQHY/T3KCI/2IUKL7kSgXbHXnV3Az65NU9CAgAB5pwA=
Date:   Thu, 24 Nov 2022 09:06:04 +0000
Message-ID: <8e8f72ad5d7a3d09be32bee54e4ebb9c280610a2.camel@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
         <9b545148275b14a8c7edef1157f8ec44dc8116ee.1668988357.git.kai.huang@intel.com>
         <637ecded7b0f9_160eb329418@dwillia2-xfh.jf.intel.com.notmuch>
In-Reply-To: <637ecded7b0f9_160eb329418@dwillia2-xfh.jf.intel.com.notmuch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|BL1PR11MB5334:EE_
x-ms-office365-filtering-correlation-id: 190e4a00-8fe5-4229-d29a-08dacdfb1df7
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fY+INOaqZZ0SSDho3Q30mjtJUGAxgY9lF1cazlUh6XWh1AdS4X6NDmEBCqHV3R4nVTRAFLtVneo7HQvj1+te6eG+GMOfNDxlmU3lfc3JFOvOOjS8qE+wUvEepL5frhW8HFiYBqz/pYNWQ3tJGGXbOBzb4ngKHpskMVHM11kUXUlJBKf/9lPHrv1ttoKrjt0V3rPxC1ZiU7Z/u3/OPGynj544fPQw1e3Q/bjUC7jLXwa0ZeBfYQjn/0TGdWbSm2Ctsf6yqp5+U3bsUw3ABrAqEAdnbmkjs8W35ZAUuImZ+KgRLcuqyLkkT0iQzX9oedz/E+lUZ2naNHc+TMse8XExYBjMe6vhRm9pJ6DAPGSQ921v7QXHXUkJyrUkefTWkL4NRUJ1auU1vIX0IW0T6ojKZMlUk2+1Q8VJDf6uCxhxcFKy1Nxb49j1uKkfDiRq8Zy13/w5RrfXLWIgU/0ZzAJUMZ3mEHm+6r+jXaaQB6IVT/q+FNgU1aIxfjlEmt3vgCBqFqivKPbTBG0r/4lH+ykcagavesW+7httkHtNycIimwSf56AZ3FHrD5jgcm4pDCsLp4nxP/thjMu5OhC3HPY28Kvs5psowauHYyOVXOJXcbBSXCpINvPoB6sRb4TtAiPQ/AO1e/d3By+1lOISRx43iwNaEKUr8+YrgV0kV176MnLmw6746lrMntD8bdK/w+t/Ks/I2riJLES1UGpcsk+r4A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(346002)(39860400002)(376002)(396003)(451199015)(86362001)(82960400001)(38100700002)(38070700005)(41300700001)(4326008)(8676002)(76116006)(64756008)(66476007)(91956017)(66556008)(66946007)(66446008)(110136005)(54906003)(316002)(7416002)(5660300002)(8936002)(2906002)(6486002)(4001150100001)(83380400001)(122000001)(71200400001)(6506007)(478600001)(2616005)(186003)(26005)(6512007)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cjM0QitDRThTdDFjd1doS2c5Q3loYmtSaytWOVRaNUZ2amdsODhCZnl3bWlB?=
 =?utf-8?B?a3E3Ymk1OHMyRFNtN1dZVnd3V2JJRVU5ajR6SW1PZWxRaFh5bjFGaTZ0Wi84?=
 =?utf-8?B?eWhLcFlMZ0QxMldhVmZtZk9yT3VtVHV3TVlzVGZickFQYUYyZnZwVjR1Wkti?=
 =?utf-8?B?M0RCTDVVY29QV2lSaXNLRnhMSWlVeVVJbWhYeVM1VWlBNXdyeVlSRXFwamNL?=
 =?utf-8?B?RWZMWHgweW9TNmlOL2ZzVDk4bzBvcUJFdVZkUllvZ0NqbUpHcDNhVDJMdGZJ?=
 =?utf-8?B?R3AyWjFYRkVnYzlmQUpORFJkTDBwaHNES2prWTNqWUJHcnRhblZpa2FkY2Zh?=
 =?utf-8?B?azA2eUt3ZlFyZDFSaEw2bnVmbkFXa050bGVQcWRublN1YlprR3Vmd3g0ODVM?=
 =?utf-8?B?bERneVgrUkJoVFVtQnMyVEg2WDN1UjQ1bitMUUtqWXlVR3VIVG9FR25lVE8z?=
 =?utf-8?B?N0s1cGNhL1RzN0hXR1RRODByU2tqcHZMY3ZTSnJsandHRGNRYUk4NlZkYUlK?=
 =?utf-8?B?c0lJdVoxczFTMmhnd2lKT2NkeDJ6czFJVFVycGp1d0UyQWZRclczRjNkaXNn?=
 =?utf-8?B?ck5mVlhaOHNGQUdtVENhcnZ6QmIxRHJPeHFkWHc5N2tBaGRSak9pZ1Jjd2cy?=
 =?utf-8?B?UDNoMEEvZlFVclVWV05LaGxaeVJJU3ZSUGVGdDMwRXNMcUlvcnpNeGJzeUNu?=
 =?utf-8?B?c2dYTmdoTm1wZzVtYXl0NWJLZWVTWS9CVWVpQTZBdjArUDBXd1F1Rk9LRlJX?=
 =?utf-8?B?dXBGRmtNVUU1SnFlZWs3WlFPUnFNczArMEJDK0VreUlXNTJZY21rV2dMOFdn?=
 =?utf-8?B?ZDRRNFdqSmdwU2hVSXZ1bGRGeDdKVlpsU0F0ZzlLby8vL0JMOFlDb1NFdW5J?=
 =?utf-8?B?cS8rQU0weUJFU1RLb0pGQVdMQmhCZVQ0RCtmaUFxZmxYQWxicnFIcTNoL3gr?=
 =?utf-8?B?MXZuNjg5dEg0NnVSOE9hMko0WW9zR3V2bktYMkt0bDhPcUovV1dIRmpmWkl1?=
 =?utf-8?B?c0xxSFByVGdLcWtyME1HMFVkUHFOaFlMb3huTUJOREZwVWpBMGk3YXVSVWJ6?=
 =?utf-8?B?MTFlK3VRaDBhK0hjOFc4TW5OSTRraloyaGs0cGtlc0tYMGdrWnN4U3dTS1ZQ?=
 =?utf-8?B?TjZIaTdJaU5OUGY2TWpMUkdSTXVDS3I0cVZTQ3hCSXNhS3cvZzREZGxIaW13?=
 =?utf-8?B?YllIMzJkNGNOR1NOU2xYVlR2cXZDZTF4V2NiWkxvZ1M2N05iZFJYU2txMTA5?=
 =?utf-8?B?RGl6bk9zRDdhSktKT2g3Q0dadENNTkU0N1Y1VHZWcjA0V09PVFJmRHBEWkg5?=
 =?utf-8?B?bzRNUmY4YjM3U21rYW50VUwrU0JYVmFDRHcxSUxrc002WEZ0YzljQlpRU2d5?=
 =?utf-8?B?MmNjNk80T1g1cjJicHdLTkhRYVBERVBVWFdqV3dhVExZNVJ3UVdJK21QTmgv?=
 =?utf-8?B?TXN4THhCTVlrcXpkcFkxamlVUHk3KzlsVTNOaCtpOFB6NkpXRDB4RHhjZGl5?=
 =?utf-8?B?RUZ2WEwxZWJsT3FGOGcrUi9sU0NHalVLVkg4R0FUakRCQ1p5eHpKZm90RzUx?=
 =?utf-8?B?WC9jeWlRUE56ZW13WW1oM1NQc1R0ZjZUTDQ4UGRCbXozVy81RFo3RGpTNlhl?=
 =?utf-8?B?a2J3c2dtdy81K3JkOFRWdWR4SUcwMXJvb2x4TTF2UzhZQWtueEQyU0V3R1hT?=
 =?utf-8?B?ZkxPbVkrSlpMTGtJS1NMdVBlR3RMQ29ZTVVrbnlmank0d25KekRaNDlXeFdw?=
 =?utf-8?B?aVNlUm1Cc2J5cmFzc05obVYrZkk1Wm8zTDA3QmlySTVFOU5HOUh5RjF0dVFK?=
 =?utf-8?B?M0p3Wk96UlpUVmlpWktCZXZiaVpEVDFmZlR2WTIxS0k0ZkNmWWQ5MkxLTXNx?=
 =?utf-8?B?K1hqakxCbjVpM1VYU1V4OXJidkUzMi9lZTY3V0NUOWRoek9xeWVTOEJ5Zi9i?=
 =?utf-8?B?YVNXTkx6b1NONWlhMDdySkllSzk0RFpndHdJWi96Sk5vb0k5bmpKQ0lQUDZ5?=
 =?utf-8?B?NzY1eUN6Sk96aTc2N2ZOcWFaS291Z2ZOcWl2VmpJOVhmUnJpQ3h5R045R3dz?=
 =?utf-8?B?Zktlbjh6UkJ0VjBhZ2I5TWo4TDRpcHBKTnJ6TU1TK25IcDhxMzg4aFlxTzFq?=
 =?utf-8?B?VmdiUXlpdjJBeEFzM1RwTWVUSWFwRE5FdWo4NSsra2xqWnZKN2FucHdpMU9I?=
 =?utf-8?B?Mnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CCA87B3405E1634A977E98E911BF2507@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 190e4a00-8fe5-4229-d29a-08dacdfb1df7
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2022 09:06:04.8987
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: i1E+D7L4ksAQ3dJffqwXT4YmWLwcQnoYdt9i/Pemcio7Mn+F08bPokw+xjLS/6Lni3cMedeiLPU0oSFxkbM96Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5334
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIyLTExLTIzIGF0IDE3OjUwIC0wODAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
ID4gwqAgDQo+ID4gQEAgLTk2OCw2ICs5NjksMTUgQEAgaW50IGFyY2hfYWRkX21lbW9yeShpbnQg
bmlkLCB1NjQgc3RhcnQsIHU2NCBzaXplLA0KPiA+IMKgwqAJdW5zaWduZWQgbG9uZyBzdGFydF9w
Zm4gPSBzdGFydCA+PiBQQUdFX1NISUZUOw0KPiA+IMKgwqAJdW5zaWduZWQgbG9uZyBucl9wYWdl
cyA9IHNpemUgPj4gUEFHRV9TSElGVDsNCj4gPiDCoCANCj4gPiArCS8qDQo+ID4gKwkgKiBGb3Ig
bm93IGlmIFREWCBpcyBlbmFibGVkLCBhbGwgcGFnZXMgaW4gdGhlIHBhZ2UgYWxsb2NhdG9yDQo+
ID4gKwkgKiBtdXN0IGJlIFREWCBtZW1vcnksIHdoaWNoIGlzIGEgZml4ZWQgc2V0IG9mIG1lbW9y
eSByZWdpb25zDQo+ID4gKwkgKiB0aGF0IGFyZSBwYXNzZWQgdG8gdGhlIFREWCBtb2R1bGUuwqAg
UmVqZWN0IHRoZSBuZXcgcmVnaW9uDQo+ID4gKwkgKiBpZiBpdCBpcyBub3QgVERYIG1lbW9yeSB0
byBndWFyYW50ZWUgYWJvdmUgaXMgdHJ1ZS4NCj4gPiArCSAqLw0KPiA+ICsJaWYgKCF0ZHhfY2Nf
bWVtb3J5X2NvbXBhdGlibGUoc3RhcnRfcGZuLCBzdGFydF9wZm4gKyBucl9wYWdlcykpDQo+ID4g
KwkJcmV0dXJuIC1FSU5WQUw7DQo+IA0KPiBhcmNoX2FkZF9tZW1vcnkoKSBkb2VzIG5vdCBhZGQg
bWVtb3J5IHRvIHRoZSBwYWdlIGFsbG9jYXRvci7CoCBGb3INCj4gZXhhbXBsZSwgbWVtcmVtYXBf
cGFnZXMoKSB1c2VzIGFyY2hfYWRkX21lbW9yeSgpIGFuZCBleHBsaWNpdGx5IGRvZXMgbm90DQo+
IHJlbGVhc2UgdGhlIG1lbW9yeSB0byB0aGUgcGFnZSBhbGxvY2F0b3IuwqANCg0KSW5kZWVkLiAg
U29ycnkgSSBtaXNzZWQgdGhpcy4NCg0KPiBUaGlzIGNoZWNrIGJlbG9uZ3MgaW4NCj4gYWRkX21l
bW9yeV9yZXNvdXJjZSgpIHRvIHByZXZlbnQgbmV3IG1lbW9yeSB0aGF0IHZpb2xhdGVzIFREWCBm
cm9tIGJlaW5nDQo+IG9ubGluZWQuwqANCg0KVGhpcyB3b3VsZCByZXF1aXJlIGFkZGluZyBhbm90
aGVyICdhcmNoX2NjX21lbW9yeV9jb21wYXRpYmxlKCknIHRvIHRoZSBjb21tb24NCmFkZF9tZW1v
cnlfcmVzb3VyY2UoKSAoSSBhY3R1YWxseSBsb25nIHRpbWUgYWdvIGhhZCBzdWNoIHBhdGNoIHRv
IHdvcmsgd2l0aCB0aGUNCm1lbXJlbWFwX3BhZ2VzKCkgeW91IG1lbnRpb25lZCBhYm92ZSkuDQoN
CkhvdyBhYm91dCBhZGRpbmcgYSBtZW1vcnlfbm90aWZpZXIgdG8gdGhlIFREWCBjb2RlLCBhbmQg
cmVqZWN0IG9ubGluZSBvZiBURFgNCmluY29tcGF0aWJsZSBtZW1vcnkgKHNvbWV0aGluZyBsaWtl
IGJlbG93KT8gIFRoZSBiZW5lZml0IGlzIHRoaXMgaXMgVERYIGNvZGUNCnNlbGYgY29udGFpbmVk
IGFuZCB3b24ndCBwb2xsdXRlIHRoZSBjb21tb24gbW0gY29kZToNCg0KK3N0YXRpYyBpbnQgdGR4
X21lbW9yeV9ub3RpZmllcihzdHJ1Y3Qgbm90aWZpZXJfYmxvY2sgKm5iLA0KKyAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIHVuc2lnbmVkIGxvbmcgYWN0aW9uLCB2b2lkICp2KQ0KK3sNCisg
ICAgICAgc3RydWN0IG1lbW9yeV9ub3RpZnkgKm1uID0gdjsNCisNCisgICAgICAgaWYgKGFjdGlv
biAhPSBNRU1fR09JTkdfT05MSU5FKQ0KKyAgICAgICAgICAgICAgIHJldHVybiBOT1RJRllfT0s7
DQorDQorICAgICAgIC8qDQorICAgICAgICAqIE5vdCBhbGwgbWVtb3J5IGlzIGNvbXBhdGlibGUg
d2l0aCBURFguICBSZWplY3QNCisgICAgICAgICogb25saW5lIG9mIGFueSBpbmNvbXBhdGlibGUg
bWVtb3J5Lg0KKyAgICAgICAgKi8NCisgICAgICAgcmV0dXJuIHRkeF9jY19tZW1vcnlfY29tcGF0
aWJsZShtbi0+c3RhcnRfcGZuLA0KKyAgICAgICAgICAgICAgICAgICAgICAgbW4tPnN0YXJ0X3Bm
biArIG1uLT5ucl9wYWdlcykgPyBOT1RJRllfT0sgOiBOT1RJRllfQkFEOw0KK30NCisNCitzdGF0
aWMgc3RydWN0IG5vdGlmaWVyX2Jsb2NrIHRkeF9tZW1vcnlfbmIgPSB7DQorICAgICAgIC5ub3Rp
Zmllcl9jYWxsID0gdGR4X21lbW9yeV9ub3RpZmllciwNCit9Ow0KDQo+IEhvcGVmdWxseSB0aGVy
ZSBpcyBhbHNvIGFuIG9wdGlvbiB0byBkaXNhYmxlIFREWCBmcm9tIHRoZQ0KPiBrZXJuZWwgYm9v
dCBjb21tYW5kIGxpbmUgdG8gcmVjb3ZlciBtZW1vcnktaG90cGx1ZyB3aXRob3V0IG5lZWRpbmcg
dG8NCj4gYm9vdCBpbnRvIHRoZSBCSU9TIHRvIHRvZ2dsZSBURFguDQoNCkkgYW0gZmluZS4NCg0K
SGkgRGF2ZSwgaXMgaXQgT0sgdG8gaW5jbHVkZSBzdWNoIGNvbW1hbmQgbGluZSB0byB0aGlzIGlu
aXRpYWwgVERYIHN1Ym1pc3Npb24/DQoNCg==
