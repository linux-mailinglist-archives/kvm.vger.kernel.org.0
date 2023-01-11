Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57BE9665752
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 10:23:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231975AbjAKJXn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 04:23:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235676AbjAKJXc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 04:23:32 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C60705F44;
        Wed, 11 Jan 2023 01:23:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673429011; x=1704965011;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=yDKqDdydGWahKrNwF/gDZ9J0gcQm1Uf09tAnJgVwkq8=;
  b=VR7kxL5r73VXKZJcjEsa+W9/AfvopAINoHdXH78tLGdmsu6wDHQs0N/P
   4R9DLhamal7jseMHOmsSF505dHv05AP3pcPtxbZ+kLlhD4mivZW5vZrpy
   7uS3+dLdeF2N2Ddu7jJnSOKCq5FOcQ6audTBtR3XuVjTY9G07NBNEKZkX
   2LEGW7NnObkg2VmtMovhRC6tg5KGAgVPwOTWyWyNOpShAPjZJod/5xSzD
   Q6p2rFmX90iVpp96+TvArxsbvWLWbPoUMeODW5gXOSSefJlc7bFyt65pL
   +DEqtGtt0ZCwc0gRJfzHcx/hbDe3rwCXThijVPa5XVSIa0C6N7iAVg9VO
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="322069935"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="322069935"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2023 01:23:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="687863094"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="687863094"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga008.jf.intel.com with ESMTP; 11 Jan 2023 01:23:30 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 11 Jan 2023 01:23:29 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 11 Jan 2023 01:23:29 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 11 Jan 2023 01:23:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lNvCEeArVzNwVxCf808o6gP0Bcl2YGrrXzJ6FtYStzHMvvQ10KADPZNYmxMPO9wUtRNn/frReeDqkHGbPbV4XEk8jRMvG/pxh1ELvLJaGsPsv45Q0sBMhOypMjxgJz+GEgspD8agGXhKvV0ft69V1K2PQcxNyWGgimIzQadse0ymWAmnedZmP+Z5dgdF7g4iiQh8gE1W+iWyEr+OPqwLM4XuX3QTkg6gIjOSuENH6tOr2+ONBvxOgddxGbGO/i5/gJznmNAYN5rnaeR9GIqNc96PRr4iSJhrZOy/QTEDi/c7oqx6grXwg3reDEVM9AlMl1LJaHGNZRByibRtbH/ipQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yDKqDdydGWahKrNwF/gDZ9J0gcQm1Uf09tAnJgVwkq8=;
 b=Al/kzSVVGzSvcFZmUO3uRt9/z1e5XZ8Ec3DJk4Jtj8LxWcCHv5VlfJNP8Xy4n7UooNOMI3XmXcYvBP4+9UwHjHYpQRCbJ8e8beWBegv/Pjuea/86gNs6fWxaMNN/MyDGu63FQ/NfPaegODmAA6M5ZJTNjkGWPWFyt/Zrb5f6yd1uUhXllGYiDi38LBqtb7z8okaE1JoYFU5vpsNTcKUOI7WtJILXrfHnBfu9kWtPaiZdiJxdysYNbjlS6UJYwN+PG2l2BTG6+TUGY6bakITWcNWF+1TJuVUk/RCHt34b8+mGDbmi/leDv762E7ACOlE5VLMPZ7R7qzKMfp82NBiilw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB5983.namprd11.prod.outlook.com (2603:10b6:510:1e2::13)
 by CH3PR11MB7179.namprd11.prod.outlook.com (2603:10b6:610:142::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Wed, 11 Jan
 2023 09:23:25 +0000
Received: from PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::ed5d:ddf5:d289:3076]) by PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::ed5d:ddf5:d289:3076%9]) with mapi id 15.20.5986.018; Wed, 11 Jan 2023
 09:23:25 +0000
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
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v8 08/16] x86/virt/tdx: Add placeholder to construct TDMRs
 to cover all TDX memory regions
Thread-Topic: [PATCH v8 08/16] x86/virt/tdx: Add placeholder to construct
 TDMRs to cover all TDX memory regions
Thread-Index: AQHZC5gPYUqEVXDsYU2zS2Qoxtth0K6R8eiAgAUPNACAAAIIAIAAGroAgAEZ1YCAAO3QgA==
Date:   Wed, 11 Jan 2023 09:23:24 +0000
Message-ID: <3fb1ee94ed64d0d36db355c77ac154006bf6cafd.camel@intel.com>
References: <cover.1670566861.git.kai.huang@intel.com>
         <ef6fe9247007ee8e15272de01ded1e0a9152be02.1670566861.git.kai.huang@intel.com>
         <c70c30fb-073f-4355-c6a6-052d013a99da@intel.com>
         <81b814f096513e69e3099ab2b54034deadf8d7fd.camel@intel.com>
         <92aba287-c839-8841-a9f7-28a2c0b3097a@intel.com>
         <cba4c7295b157dc5d0d88b73f335899f0aa5a21c.camel@intel.com>
         <56cdb6e6-e25c-aba9-7bb3-323281e65249@intel.com>
In-Reply-To: <56cdb6e6-e25c-aba9-7bb3-323281e65249@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB5983:EE_|CH3PR11MB7179:EE_
x-ms-office365-filtering-correlation-id: 6d9b0b17-ba4d-4f9f-2719-08daf3b57db1
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pAJiY8PgqSpOJKFh3okQIQfbZ1DUXYdh58rJFVkM37Quz6nSIc1uFzo3SWgXeXvRSwdJ+t2CNVnNhlFNNZgsCrpXP/jqG3SW6WobkA2t71lyCAK7/B37D4Mazyc3td/Lc/LSCZEuJvYtf1Ft1ufrT9iffr/sFZO45dQCRoiQOCrec0sy6e+JbwYbvj1/GJ9JMoW8XV6Fh6LQeweBTajPX3c3OhuGXINTUpwFxsof2K/PNsAx7pBvf2z+rJowwMV0AKZ/6udLLKLbHEtZcpnoyYHiFNzTAEwn2/trfAPFQsKkVKxLbn4s1Vr6Wbft0RwqiA/V7V5Q8D1wqAmZlW7T5S1M67VlfI3zSX86pcZ2mKydNIiDeRcKxz8jFbAo8EzojpAMx1MSjl/5vesga3jWsgwAMNcREvjc4WidP+IS0M8Fpecxkgr8sv0I4RRBQ/OxeP09davK5lq9BGlWM1nESKHQyUY2kHDnmKvtxn235hOimx6pnQXe6/0U1Zg8sM9zJL1QiuXRa6oWPkhYMzbGN1iUSHi5QexPfxupOYPzYEQesxGvven8gZCkDSIsEdw6qV5iMwl8+Ea/jkrq2cwu00hKDb3AKTz5n8w/CDudQAjabVLICscY9YGwGUt3NCOUScgiq3lx/Nd76KWyXuR/GYKJZx7v+9lJ7WmQ5jZ1otc2kveJkQ+02zq85NcZ0cIENfQlJAUFo/FK6B1FGNFr4kUesh+7/exhtGmtj7CVMm0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5983.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(396003)(346002)(366004)(39860400002)(451199015)(8676002)(64756008)(76116006)(66946007)(66556008)(66476007)(316002)(4326008)(110136005)(38070700005)(54906003)(2906002)(5660300002)(8936002)(66446008)(71200400001)(41300700001)(7416002)(36756003)(53546011)(966005)(6486002)(478600001)(6506007)(82960400001)(122000001)(38100700002)(2616005)(26005)(6512007)(86362001)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V1VxQitiSDY5R0dtWUdoTDhWczdhSWRFcisrcW5UMkJtSVFMblg3cGFEUFVM?=
 =?utf-8?B?ZC94bHZ3dHBsSG40TkU5eWI0bXBRL052SmZJV1JORWNnb21UV0h5YzlrdTFO?=
 =?utf-8?B?Smd1aEhKUm91Q3BYSUs1b0htYjU3V1FhOC83UVdNNUxtVVVsbmwvRDd6NDV4?=
 =?utf-8?B?OEp1QzQrSGtFZWZIa2M3R05yam9rTGYrU3VVRkNCeDVkUi93NjhXTkdOMGlP?=
 =?utf-8?B?djhzRDBxZW9WRXdZRmtFaUNuS1ZOWDZvZTlqQ2l1czNaR0VUSFhkblZPcmNJ?=
 =?utf-8?B?RDIvM3dsaTA4d0ZoeG92L3F2d1duS1BGa2xRVklVd3ZSN21pL3NnOVZmZ01w?=
 =?utf-8?B?TGcyRVZtTVE4Z1czZjU3Z3A3NnUyWHd6WE56RjVOVmdtWXA0U0cyaHZQWktq?=
 =?utf-8?B?bDh6R1RhTmxDaVZIdTY1WE9HOExUMGZvTFg3N3ZPWjZFQWJDU3YyQVVGMVl2?=
 =?utf-8?B?aEUrNlRtRU15Q1hYRkUzZ1hZdE5nSGl4SEFJNVR4amJ4RitFUmdiVWZpNEJx?=
 =?utf-8?B?VHdhYVFuOXNES2EwOHVTb0N1cWdPNU1wK1ZjeUZUZHJlcHlDNll6MzlpRGox?=
 =?utf-8?B?OHJwcUFSbUYvZEZqSE1HbWNEeE1zK1pyOXJrVzVGZTMweS9zR3ZCVFhocjFW?=
 =?utf-8?B?MEdpaHZGTmIxdStzQi9ia2tLejRLbzBJTEdrZE5xcjBlZE8yVXZhT0wrc0xy?=
 =?utf-8?B?SzdQRXh0Q2RUYzgyWXZSRmk2Y2d4eXhMdkM5c3IxWHNFV3R4Vng5MXNRUlph?=
 =?utf-8?B?cWE5MGNYNWNPUTlQajZTTmNPa2pmY3NWR2Y0YUdmYzFybnpIc0VYRkk5SWZY?=
 =?utf-8?B?U00wK1EyVHZLWi94eVZvVDFoUXVKTno2ZmZnb0p0SXRILzlscE05M0V2eFll?=
 =?utf-8?B?eG1PM0NFSG5oUVNLVytocEVPN2hCb3M3bUhvK0R3cWtDaVByNndjckJTNDRG?=
 =?utf-8?B?MWZQSWdHdW9LdUdNK0g3a2pMSFFzMXN5VUNiSzdZeVArb0VWNXptNDhjVHBP?=
 =?utf-8?B?RjFTc2l2Mzh2czdBdkp1M05oM00xMVdSTW1DZUZJNTV3VSsrY2VaSktFMnRo?=
 =?utf-8?B?bmk4dkNQZlJjSEhiVFh0UktVS0IxdFJLMjV5bjlJSlBNT1ZnSjBRSlRocU1U?=
 =?utf-8?B?Q1Yvd1ZTdGU4WnQ1S0RMWkczWGNlVk5rTlpSRDNvcWg0WnhDbWlUbXVkQzR6?=
 =?utf-8?B?T2lGVllyZDJwSElMdjBqVVg3RXRYcE8yRU1rUnp6T2MvV2lPZXpHK1RyNDRl?=
 =?utf-8?B?NFNIU0llV1I3WTF5SXZCTnF2bW5qSFFic1UxRmRsT3g5d1dJQmNSWnArSzRm?=
 =?utf-8?B?dTljeTVQNmQ1QWFrOXdsUmhZRXVSbEJBbUYwMzdvYmlWVHlPc1J2d2MvZ2tn?=
 =?utf-8?B?YVpKSHBVRGxpTTdPWjdpQkhDT1hxK05WaXgvOE9wVzNNZWJ5di9HVG1sTUlV?=
 =?utf-8?B?VmZXeC9Ub09ZUUZnQmE2aWl4aWdEb3ZEZVBxbXlxNjE3QlkyYnZETndCeFl3?=
 =?utf-8?B?VEtjK1hnQWJTay9iT3IxbHUzRDhqYXRkRlZhWFBOK2kyQ3ozcnNZdkQwbGtU?=
 =?utf-8?B?OXFZZjRKclY1S1JaaXhVbDBNbmxjek01V1FLanNBWUxoOUg1U0FlcXMrOXoy?=
 =?utf-8?B?ZCtsTnJOV1ppbnRkZEJ1WDFlVVNlRTNZeGVHdHpTa2J0K0xVR3cwWStFcjhx?=
 =?utf-8?B?WFJWRDk3cmdRVkEvS2h2WGU2NmYybFZ0a0gzdFRwSVBaZEovK1JmMmpXdlQ2?=
 =?utf-8?B?alpxK2JUcTY2dzVNTlZ6RVI1ZE9lOENqVFJXNjZoa2o4akJyR2V2MVNuSVpE?=
 =?utf-8?B?OGtNQm40Nk40bHlWNVZRV0E5TDZPRHRKZHZKTXVVWEdzTFVHSkY1Z2Fsbngv?=
 =?utf-8?B?eHo4cG91dms1eDJoMS8wODFuQlBhMkFJNGIvcFl6dFFsWGozWk5vZ1VzMUI5?=
 =?utf-8?B?Y3JIdzlWOS9CbG80dUxNeTRJMk85Ui93NWNYOW9tNkdGZExHbFR2REJuYkcx?=
 =?utf-8?B?Wk9mNmhEWmh5RFFsR2hjZSs5YkQ5c1F4dDhBOEVLakR3aVhOTXc2SmdTMHNi?=
 =?utf-8?B?azQ3ZzZybFZJZ3BXTWxFbWtJcjFFNGc5ZjNLbjcxQjBFU0owcjlNQk1tNzVr?=
 =?utf-8?B?cWQ0aVo5VUNaa2hveG1MbitBQmV2NXRuTlRzcEtqSXVyS1BuT1JLQjBuWTZP?=
 =?utf-8?B?cVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FCB124669051D244B76DD53BA75B5C7F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5983.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d9b0b17-ba4d-4f9f-2719-08daf3b57db1
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jan 2023 09:23:24.8979
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eYEK7Y8o0tKXBbejY6Twe0ufU9D/tDI26lbe4AHUaWqGDnR7k87sIJPGnuKecut5UK/yJHOroGavdPg65s06sA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7179
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIzLTAxLTEwIGF0IDExOjEyIC0wODAwLCBIYW5zZW4sIERhdmUgd3JvdGU6DQo+
IE9uIDEvOS8yMyAxODoyMywgSHVhbmcsIEthaSB3cm90ZToNCj4gPiBPbiBNb24sIDIwMjMtMDEt
MDkgYXQgMTY6NDcgLTA4MDAsIERhdmUgSGFuc2VuIHdyb3RlOg0KPiA+ID4gT24gMS85LzIzIDE2
OjQwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+ID4gPiBPbiBGcmksIDIwMjMtMDEtMDYgYXQgMTE6
MjQgLTA4MDAsIERhdmUgSGFuc2VuIHdyb3RlOg0KPiA+ID4gLi4uDQo+ID4gPiA+ID4gQWxzbywg
dGRtcl9zeiBhbmQgbWF4X3RkbXJzIGNhbiBib3RoIGJlIGRlcml2ZWQgZnJvbSAnc3lzaW5mbycu
ICBEbyB0aGV5DQo+ID4gPiA+ID4gcmVhbGx5IG5lZWQgdG8gYmUgc3RvcmVkIGhlcmU/DQo+ID4g
PiA+IA0KPiA+ID4gPiBJdCdzIG5vdCBtYW5kYXRvcnkgdG8ga2VlcCB0aGVtIGhlcmUuICBJIGRp
ZCBpdCBtYWlubHkgYmVjYXVzZSBJIHdhbnQgdG8gYXZvaWQNCj4gPiA+ID4gcGFzc2luZyAnc3lz
aW5mbycgYXMgYXJndW1lbnQgZm9yIGFsbW9zdCBhbGwgZnVuY3Rpb25zIHJlbGF0ZWQgdG8gY29u
c3RydWN0aW5nDQo+ID4gPiA+IFRETVJzLg0KPiA+ID4gDQo+ID4gPiBJIGRvbid0IHRoaW5rIGl0
IGh1cnRzIHJlYWRhYmlsaXR5IHRoYXQgbXVjaC4gIE9uIHRoZSBjb250cmFyeSwgaXQgbWFrZXMN
Cj4gPiA+IGl0IG1vcmUgY2xlYXIgd2hhdCBkYXRhIGlzIG5lZWRlZCBmb3IgaW5pdGlhbGl6YXRp
b24uDQo+ID4gDQo+ID4gU29ycnkgb25lIHRoaW5nIEkgZm9yZ290IHRvIG1lbnRpb24gaXMgaWYg
d2Uga2VlcCAndGRtcl9zeicgaW4gJ3N0cnVjdA0KPiA+IHRkbXJfaW5mb19saXN0JywgaXQgb25s
eSBuZWVkcyB0byBiZSBjYWxjdWxhdGVkIGF0IG9uY2Ugd2hlbiBhbGxvY2F0aW5nIHRoZQ0KPiA+
IGJ1ZmZlci4gIE90aGVyd2lzZSwgd2UgbmVlZCB0byBjYWxjdWxhdGUgaXQgYmFzZWQgb24gc3lz
aW5mby0NCj4gPiBtYXhfcmVzZXJ2ZWRfcGVyX3RkbXIgZWFjaCB0aW1lIHdlIHdhbnQgdG8gZ2V0
IGEgVERNUiBhdCBhIGdpdmVuIGluZGV4Lg0KPiANCj4gV2hhdCdzIHRoZSBwcm9ibGVtIHdpdGgg
cmVjYWxjdWxhdGluZyBpdD8gIEl0IGlzIGNhbGN1bGF0ZWQgbGlrZSB0aGlzOg0KPiANCj4gCXRk
bXJfc3ogPSBBTElHTihjb25zdGFudDEgKyBjb25zdGFudDIgKiB2YXJpYWJsZSk7DQo+IA0KPiBT
bywgd2hhdCdzIHRoZSBwcm9ibGVtPyAgWW91J3JlIGNvbmNlcm5lZCBhYm91dCB0b28gbWFueSBt
dWx0aXBsaWNhdGlvbnM/DQoNCk5vIHByb2JsZW0uICBJIGRvbid0IGhhdmUgY29uY2VybiBhYm91
dCBtdWx0aXBsaWNhdGlvbnMsIGJ1dCBzaW5jZSB0aGV5IGNhbiBiZQ0KYXZvaWRlZCwgSSB0aG91
Z2h0IHBlcmhhcHMgaXQncyBiZXR0ZXIgdG8gYXZvaWQuDQoNClNvIEkgYW0gZmluZSB3aXRoIGVp
dGhlciB3YXksIG5vIHByb2JsZW0uDQoNCj4gDQo+ID4gVG8gbWUgcHV0dGluZyByZWxldmFudCBm
aWVsZHMgKHRkbXJzLCB0ZG1yX3N6LCBtYXhfdGRtcnMsIG5yX2NvbnN1bWVkX3RkbXJzKQ0KPiA+
IHRvZ2V0aGVyIG1ha2VzIGhvdyB0aGUgVERNUiBsaXN0IGlzIG9yZ2FuaXplZCBtb3JlIGNsZWFy
LiAgQnV0IHBsZWFzZSBsZXQgbWUNCj4gPiBrbm93IGlmIHlvdSBwcmVmZXIgcmVtb3ZpbmcgJ3Rk
bXJfc3onIGFuZCAnbWF4X3RkbXJzJy4NCj4gPiANCj4gPiBCdHcsIGlmIHdlIHJlbW92ZSAndGRt
cl9zeicgYW5kICdtYXhfdGRtcnMnLCBldmVuIG5yX2NvbnN1bWVkX3RkbXJzIGlzIG5vdA0KPiA+
IGFic29sdXRlbHkgbmVjZXNzYXJ5IGhlcmUuICBJdCBjYW4gYmUgYSBsb2NhbCB2YXJpYWJsZSBv
ZiBpbml0X3RkeF9tb2R1bGUoKSAoYXMNCj4gPiBzaG93biBpbiB2NyksIGFuZCB0aGUgJ3N0cnVj
dCB0ZG1yX2luZm9fbGlzdCcgd2lsbCBvbmx5IGhhdmUgdGhlICd0ZG1ycycgbWVtYmVyDQo+ID4g
KGFzIHlvdSBjb21tZW50ZWQgaW4gdjcpOg0KPiA+IA0KPiA+IGh0dHBzOi8vbG9yZS5rZXJuZWwu
b3JnL2xpbnV4LW1tL2NjMTk1ZWI2NDk5Y2YwMjFiNGNlMmU5MzcyMDA1NzE5MTViZmU2NmYuY2Ft
ZWxAaW50ZWwuY29tL1QvI21iOTgyNmUyYmNmOGJmNjM5OWMxM2NjNWY5NWE5NDhmZTRiM2E0NmQ5
DQo+ID4gDQo+ID4gUGxlYXNlIGxldCBtZSBrbm93IHdoYXQncyB5b3VyIHByZWZlcmVuY2U/DQo+
IA0KPiBJIGR1bm5vLiAgTXkgZ3V0IHNheXMgdGhhdCBwYXNzaW5nIHN5c2luZm8gYXJvdW5kIGFu
ZCBqdXN0IGRlcml2aW5nIHRoZQ0KPiBzaXplcyB2YWx1ZXMgZnJvbSB0aGF0IHdpdGggaGVscGVy
cyBpcyB0aGUgYmVzdCB3YXkuICAnc3RydWN0DQo+IHRkbXJfaW5mb19saXN0JyBpc24ndCBhIGhv
cnJpYmxlIGlkZWEgaW4gYW5kIG9mIGl0c2VsZiwgYnV0IEkgdGhpbmsgaXQncw0KPiBhIGNvbmZ1
c2luZyBzdHJ1Y3R1cmUgYmVjYXVzZSBpdCdzIG5vdCBjbGVhciBob3cgdGhlIHBpZWNlcyBmaXQg
dG9nZXRoZXINCj4gd2hlbiBoYWxmIG9mIGl0IGlzICpyZXF1aXJlZCogYW5kIHRoZSBvdGhlciBo
YWxmIGlzIGp1c3QgZm9yIHNvbWUga2luZA0KPiBvZiBwZXJjZWl2ZWQgY29udmVuaWVuY2UuDQo+
IA0KDQpTdXJlLiAgTm8gbW9yZSBhcmd1bWVudCBhYm91dCB0aGlzLg0KDQpIb3dldmVyLCBmb3Ig
dGhlIHNha2Ugb2Ygbm90IGFkZGluZyBtb3JlIHJldmlldyBidXJkZW4gdG8geW91LCBob3cgYWJv
dXQga2VlcGluZw0KdGhlICdzdHJ1Y3QgdGRtcl9pbmZvX2xpc3QnIGFzIGlzIHRoaXMgdGltZT8g
IE9mIGNvdXJzZSBJIGFtIHdpbGxpbmcgdG8gcmVtb3ZlDQp0aGUgJ3RkbXJfc3onIGFuZCAnbWF4
X3RkbXJzJyBmcm9tICdzdHJ1Y3QgdGRtcl9pbmZvX2xpc3QnIGJ1dCBvbmx5IGtlZXAgJ3RkbXJz
Jw0KYW5kICducl9jb25zdW1lZF90ZG1ycycgaWYgeW91IGFyZSB3aWxpbmcgb3Igd2FudCB0byBs
b29rIGF0IHdoYXQgd2lsbCB0aGUgbmV3DQpjb2RlIGxvb2sgbGlrZS4NCg0KUGxlYXNlIGxldCBt
ZSBrbm93Pw0K
