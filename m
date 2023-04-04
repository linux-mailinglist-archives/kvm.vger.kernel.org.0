Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56E3D6D564F
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 03:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233026AbjDDBxo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 21:53:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231269AbjDDBxm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 21:53:42 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C71612C
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 18:53:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680573222; x=1712109222;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=VHLR6TppzTAYTxSemP+EGwpkcS4VehwKRSEl5AXI2YU=;
  b=HIOQEMwPHjUAecyxS2cVvGxcpG84MxZqp2oeBbmSBdbRmv0qSRnjVBYG
   8LJZm2b42bjiwFzrULa078XwCOOwq8mLrqHrBVXhJ+Yj9qfYEFIsr3QMo
   WQw/XSpjU3cN10Z+b3VHyqfe3o54uvxVLd/IFMOT0QEtGKhv4NBHDMSYD
   thPj6K2X6JAIn7B6rB7beJ0Wbx0ddqrJoORLltSwmUBydBENOmFhJ2wtv
   uqTnbaatwBk04WkqduAkK+ExSxEHL/kMAr2uV7JecXrzgRTXnvpqDdJPH
   9gchtINJecbojkwOoeAREEecvT1KMcHki3QdzdIr8Xdo9zYUzsryx6tdO
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="369874513"
X-IronPort-AV: E=Sophos;i="5.98,316,1673942400"; 
   d="scan'208";a="369874513"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2023 18:53:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="688707529"
X-IronPort-AV: E=Sophos;i="5.98,316,1673942400"; 
   d="scan'208";a="688707529"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga007.fm.intel.com with ESMTP; 03 Apr 2023 18:53:41 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 3 Apr 2023 18:53:41 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 3 Apr 2023 18:53:41 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 3 Apr 2023 18:53:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n2LuHfqEk5EyJFfyBJqYTjUt5MI5iEDQ58boqRRJezhNvu2244fLCv8gZlMsmorsdJhyRhIdHkg+Fgd8umY8hf3p94p4oCO5qm08kWaBCIP/pb2B9K2WCpsHgMJ9yn5D0k+HXOKN4JdPRBNWmz8bg9YbTquXXExjJmwrSG98t3kaQ3789PU3PAErqY79u+3cbfOR8FASQKBv84KP0wAexDxDMrNOjmuFNPrfYlrBnTRU+NAfB86Mw+Gzw00GFoz+Qh923URI+dP6HxGrxhZMsyJ10C78mA98Ra8qwXvjetmQNkH9aucfyAZC9xY43EkW1L0hiupPzQ3WAZi8dCTUTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VHLR6TppzTAYTxSemP+EGwpkcS4VehwKRSEl5AXI2YU=;
 b=IzIx808e9KWtOI9jA7pP4AsEwK2Be5e/IT0d/FSAmlTOZX9I1KWnbZPvDyJmZAAstzr54NuVGUmHaBjdTM8XlHaNU5Ak/XweEYNe6pqQvuU8VE7sn37NDvmnnJg4jSCXsXaklj/7HdkIaiO/Qvb4InsKgS/F8oBXdjGT5+Dul/VW+ONQp6BbsnwBFAumVp7st3QRMr6HOyJ4m/hpGj+/IWeL7Tm7OKg6Nphn6YvIEVR4HVcr00x+dzS+5dzkvq9/MOF/bQxZV4ou+qkxVHxCBUJnIqemi/zT7VT6tstQLWd+C/7GG/5HyyuKmhBmAT3ewVURxYy7ixfO+VRco/Z6vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA2PR11MB5067.namprd11.prod.outlook.com (2603:10b6:806:111::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.28; Tue, 4 Apr
 2023 01:53:39 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9%5]) with mapi id 15.20.6254.033; Tue, 4 Apr 2023
 01:53:39 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>,
        "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>,
        "Gao, Chao" <chao.gao@intel.com>
Subject: Re: [PATCH v6 2/7] KVM: VMX: Use is_64_bit_mode() to check 64-bit
 mode
Thread-Topic: [PATCH v6 2/7] KVM: VMX: Use is_64_bit_mode() to check 64-bit
 mode
Thread-Index: AQHZWj/xX+6sX0Ji9kGqSs4peyRxha8DnNOAgAIo0ACACyFUgIAAH6+AgAAKWgCAAAFNgIABArSAgABXIQCABpqMAIAAgp4AgADpvYCAAAkBgA==
Date:   Tue, 4 Apr 2023 01:53:39 +0000
Message-ID: <71214e870df7c280e2f7ddcd264c73e3191958d9.camel@intel.com>
References: <20230319084927.29607-1-binbin.wu@linux.intel.com>
         <20230319084927.29607-3-binbin.wu@linux.intel.com>
         <ZBhTa6QSGDp2ZkGU@gao-cwp> <ZBojJgTG/SNFS+3H@google.com>
         <12c4f1d3c99253f364f3945a998fdccb0ddf300f.camel@intel.com>
         <e0442b13-09f4-0985-3eb4-9b6a20d981fb@linux.intel.com>
         <682d01dec42ecdb80c9d3ffa2902dea3b1d576dd.camel@intel.com>
         <b9e9dd1c-2213-81c7-cd45-f5cf7b86610b@linux.intel.com>
         <ZCR2PBx/4lj9X0vD@google.com>
         <657efa6471503ee5c430e5942a14737ff5fbee6e.camel@intel.com>
         <349bd65a-233e-587c-25b2-12b6031b12b6@linux.intel.com>
         <fc92490afc7ee1b9679877878de64ad129853cc0.camel@intel.com>
         <559ebca9-dfb9-e041-3744-5eab36f4f4c5@linux.intel.com>
In-Reply-To: <559ebca9-dfb9-e041-3744-5eab36f4f4c5@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA2PR11MB5067:EE_
x-ms-office365-filtering-correlation-id: 9cd14c6b-fca6-455a-d8b6-08db34af6941
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YIr4ZktNGXSgBWOUhNYQIFI/ClLxIyT2IXLsTuWncRbWJgOTrupYZfTBPOKDPb9qlEJwrRpsR+ZVbNqmOPAyC2C6b2U6FmdCHuVMVvJYwzSrkRKzLVUYjaEcxYJ7G3kzRRtyes2XVn3Ddt2elg5BlwjwQlE78bRh/oI8YuoupfRnRe5C9rMsP+lC91AFVy8r9nxLISSdR3usqi5ZjmlI+V4RcrVwVWRzquv7RJS860dZbjuhzypwdR6ApuIldt10dOmN+qWcVO3D3LWPm+hOkNwetQ9KFSTukm22VLl/tXOKBzPDv1DkroKCNGZhlhCqjetO79yTJn7TBY5/xyinHnMkW0jU1FENmeNKtOQ4gl5h17vwbibj470zwS8TaBSQ8aADoRH9m1biEU2IWU6+k0i47+4sCXgTokAYxvXVe9xR1H2LJ/O1CDxc+0M58xPgCkx6FNGXfSadg2HxoU5/iM1XI4eYFZuPVYvZwiLYdrar5AEhcOa9XoZq/ZyuXIKD4D0U+xtfYL0Wp0C3UNiCMYW5CeDYxCcLU5yuc8i/TsC0dInYjxXVD0KitoGBfGDuJfkbGLentZLEpV3Uk5eLbPR/MS1rB+BnUyxOJ98OMFvCngnVGQJPf14K5Gh0/xtp
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(376002)(396003)(136003)(346002)(451199021)(36756003)(316002)(66476007)(110136005)(91956017)(8676002)(6486002)(64756008)(4326008)(54906003)(76116006)(66556008)(66446008)(66946007)(8936002)(71200400001)(5660300002)(41300700001)(82960400001)(2906002)(4744005)(478600001)(38070700005)(86362001)(122000001)(186003)(2616005)(38100700002)(53546011)(6512007)(26005)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RFZ5OTd1ZEl0dGQyRFQ1VHUvTGlEdDBMWXVUby9DNG02TWE4SVVNVWJFOTJY?=
 =?utf-8?B?SU4rNlgxeUVXWnA0N0NoM2wvS0htY3hUVjFpaGowVlN6c0t0aDBHb2drU1ly?=
 =?utf-8?B?aGFuZG5KMndIT2NQbjdwenc2cUViWWFnQmhLRUdDaDNxUFVldFFIQUc3L0Uv?=
 =?utf-8?B?bmpXRTBKTTB6REg2L2x3MnF1azJ5MEJMSUQ2YXpTLzM1dndjeWVYVVlFOWhz?=
 =?utf-8?B?Z0RKeXJDNVJLZ204eWZhaVVqRjI3UWlyQk5ZTFNqR0NvSTU1aS9UYnVIeVhO?=
 =?utf-8?B?aWYvTTdyTk1ZVmd4U29GdE94SFJldXVqWnpYYTdSNk9QVnQ2a2grK3R3QWJX?=
 =?utf-8?B?WmZOYmYyd2k3dXh5QzNLcTd5V2NrRWVNSDhSTndoL0pGMVk4MkJjVCtoRFp5?=
 =?utf-8?B?SVptaCswajJzb2xqTytJMHMyNmFwRHRHdFduNUNiS2I4M0dsdXdGdmJVV2ww?=
 =?utf-8?B?ZzFUc3pQLy85aGJ6Lzg5cnhHL09EMVp0UWVJWWFQRTRuWXY1ODBtbmt3T3hp?=
 =?utf-8?B?VklpTEs1enRYQlNpS1ZOVzRRVXRSdnlUNWdIYXMvZkJnaXJHRUw4Qk13ZTU4?=
 =?utf-8?B?ZlVDMDBVMWN0eWE3anNUK3JDRncxanU2L3A3c3pKUGlQL2UyUm5haDdnUTlK?=
 =?utf-8?B?RW9HSkQ4dDh3UEtjYXRKVTJUNTMvOTExTmdSYlFjWTlYVXdhZjlTdVhtZ0NM?=
 =?utf-8?B?dWtMaStCYmM2MlRpeVc5NGZVS21HVE1wdWI5RlArc2NSNzNYZE5QcDlLSDRH?=
 =?utf-8?B?WGYydmNya244Y2pNSXJKWWdVMVYyMGhyczAyN3B1a2ZqRENIakFwSnE5ZG9p?=
 =?utf-8?B?RG9FdTdxblM0enFLVmxKV1FUQUpvNnhyN09YVU9abnY2dHNQOFFMSzh4azdS?=
 =?utf-8?B?Umo5TDJTOVhscmFTalY4WmFLakV4ZEx2dDJtV1Y5N2lXK2l1d2ZTQy9iV25V?=
 =?utf-8?B?Q0szbW1haFFBazBpT0xhTHQwZ3lLM2c2NUQxRExHQjYvZmJyVU8yNmt0c3Bq?=
 =?utf-8?B?OWdYclRWbERkYXQvT1IrV2QxLzd4dk1sL0dLNEhVSy9vVHhDWmVCSEF2SUtk?=
 =?utf-8?B?VUtSTVNFMlVlUzVqNm0xN3VMT1lIbTNONXJKcFpYWVVNbkhFcElQeWxXUk81?=
 =?utf-8?B?b2VQeXpWYit5Y0RYUFBRemVxN284VU1zcHZuYTZwWHhkKzFPUkYyVzlreW56?=
 =?utf-8?B?dnlTUXRTcjNMMXlWdVJwVExRbW5qVHJNZGhabjF1RS9FMkxKK3gxYTBrcERr?=
 =?utf-8?B?bzZVRUwvK3J6aFhreFVDdVBnQjJaMFozVGNBMURURVJnOGVrTkFLeDFHVFc1?=
 =?utf-8?B?YUtVVW51ZC8vb2RtNjJBekxFZWtLcUYxWWp0YTRuUjdTdDAzMzcxVUp4NDEr?=
 =?utf-8?B?SkNCVjluY2hSeGJTSHB2b2VHZGZGWVUxM1RteWFhVDA5RzdMUGwyY2Z6aWwz?=
 =?utf-8?B?VE1qQTltdzVsUXdWQmtQTDJjK244VDc1SDhPREh1MTVoUUY4TWt0YzlDbVFV?=
 =?utf-8?B?VTczUzZsL1NiVXA3NTlONHYvbFppZGYvZm5hb1piRGJGNENMeGx2eXlJWXZ6?=
 =?utf-8?B?SDFXN21QckVyWHpha3FWTWVJOWlkTGU2WHdSbytEdUJSRC9NYmFXZ1pDY29S?=
 =?utf-8?B?MHNqSGpRbjNXazlPbVhtYnRhSGNoTXk4NWpYVlZudDRlclVkOXA1RjhvNHAx?=
 =?utf-8?B?Ri9CRWNUU0JUZ1VHbUhVeWt3L2VsREh6cHVLWDNuRnRYZm9SVFpmc2MzZkcw?=
 =?utf-8?B?WlA4MUNEVHhGUE9sMUJHMTdOcUY0Y3IzUXExZFo3MjRvNGJhTnczY0kzL0R6?=
 =?utf-8?B?cGtTQVlGWnVGakorYjBsczY2WkJOY2N3djdIdmRvcWRvZnJYR04xUjVzMTdL?=
 =?utf-8?B?S1FYQk9xOFVzQUVBQUNRK0RtMjZReUZRU1VpY1NhQmZwK3ZpdllNMHZ6N3FU?=
 =?utf-8?B?dDVjTE9jMnNxR09jZGk3N1gwVlh2cXdqeFQ5VnlxK3ZrR0J2dnlBRVRJZDFI?=
 =?utf-8?B?WGVZeC9YVzFCNXpsQWdYbGxjNnp1Ti9VQ3Mza1UrSStwWkZiSElROGpIbTRs?=
 =?utf-8?B?UURGMFpXck1LTlVtRHNCakZuWmRQajBEblBORFBWbWlsa3lFQThHUXhXTlkw?=
 =?utf-8?Q?NmjXzPoAhZQZcqI+8/3CXh8gm?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <05968BB9E5E6184A92ADA0FF0D40AD10@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cd14c6b-fca6-455a-d8b6-08db34af6941
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Apr 2023 01:53:39.2857
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kKBtaRL6PThuqOqqQKj3a6XG2rZNu/MnWkaU8gDvjkR5zJQZzODame+RSB2q35Dvn2HH5SUFC1sVV4eQt2iZWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5067
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIzLTA0LTA0IGF0IDA5OjIxICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+IE9u
IDQvMy8yMDIzIDc6MjQgUE0sIEh1YW5nLCBLYWkgd3JvdGU6DQo+ID4gPiANCj4gPiA+IA0KPiA+
ID4gQW55d2F5LCBJIHdpbGwgc2VwZXJhdGUgdGhpcyBwYXRjaCBmcm9tIHRoZSBMQU0gS1ZNIGVu
YWJsaW5nIHBhdGNoLiBBbmQNCj4gPiA+IHNlbmQgYSBwYXRjaCBzZXBlcmF0ZWx5IGlmDQo+ID4g
PiBuZWVkZWQgbGF0ZXIuDQo+ID4gPiANCj4gPiBJIHRoaW5rIHlvdXIgY2hhbmdlIGZvciBTR1gg
aXMgc3RpbGwgbmVlZGVkIGJhc2VkIG9uIHRoZSBwc2V1ZG8gY29kZSBvZiBFTkNMUy4NCj4gDQo+
IFllcywgSSBtZWFudCBJIHdvdWxkIHNlcGVyYXRlIFZNWCBwYXJ0IHNpbmNlIGl0IGlzIG5vdCBh
IGJ1ZyBhZnRlciBhbGwsIA0KPiBTR1ggd2lsbCBzdGlsbCBiZSBpbiB0aGUgcGF0Y2hzZXQuDQo+
IA0KPiANCg0KU2hvdWxkbid0IFNHWCBwYXJ0IGJlIGFsc28gc3BsaXQgb3V0IGFzIGEgYnVnIGZp
eCBwYXRjaD8NCg0KRG9lcyBpdCBoYXZlIGFueXRoaW5nIHRvIGRvIHdpdGggdGhpcyBMQU0gc3Vw
cG9ydCBzZXJpZXM/DQo=
