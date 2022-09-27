Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7AE15ECF23
	for <lists+kvm@lfdr.de>; Tue, 27 Sep 2022 23:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231587AbiI0VLM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Sep 2022 17:11:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231854AbiI0VLH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Sep 2022 17:11:07 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E55ED1DADEA
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 14:11:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664313062; x=1695849062;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=+YXys8KT3gnol153sjQYMPNhO8B30aGCm5LK39kumH8=;
  b=Dn5ekNq7IhijF/7VE/8XrVnBisnQ0TeMk4QO9sDusm7TcS9Ouo6Lazdr
   59vTDz63fdcc0Y5FOnb7TvzJxVKqT+XZzIrh7FPnNrTrzX/SI5x7NfMjg
   a4XXOdwPQabs+pAmiMc5XIAnmpaxt0WDGz3hYxXNBYjW7BzIW+Jkofwtf
   PuN73vMR9rSM0E7yEX9ahOL9fZFi6wXjKwaWj3XhNSZrtLOTAGuNAMIil
   ZUIDFHKDVVySLykZ7RmOoehQoCYbuP5qbJ3xPFgIZY89H0CZ6jJ2LN+CM
   rSrWF0Tu8SHkkv9uWsQLqanumrWyzFO+6YB2oQq4o4rjryop3fLnl8Q0R
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10483"; a="327795317"
X-IronPort-AV: E=Sophos;i="5.93,350,1654585200"; 
   d="scan'208";a="327795317"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2022 14:10:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10483"; a="747187358"
X-IronPort-AV: E=Sophos;i="5.93,350,1654585200"; 
   d="scan'208";a="747187358"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga004.jf.intel.com with ESMTP; 27 Sep 2022 14:10:47 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 27 Sep 2022 14:10:47 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 27 Sep 2022 14:10:47 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 27 Sep 2022 14:10:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W6gy9IV7R2OpJHq/BK9WNbqGPb9N6+4wJyQ61nsd2TKY7vdJyYGfH8byM9wfkHraoz1Uduuwi3rYGsgrb5HoKWqNGgBqZpvy298F8fCrhlI7HhaugLwhvB9YAyVdi/ZHhRPzl6oRzIfDQqg34w4Sz5V/e62pSrgQ2sq+iuQL7HUSPTpSLIzyrnAqJLw2WKBoo0cwQGb7Qxo9th8GzsRVEI/Exb5Pd15Rxm4Me0IVfemzzJb4EgSVP+HOxFxqrbxU5H4gWkm6zyf2i83OxIXQpCoK+3w4n/aV9mYZ3vtBGQQOsPSgQCO7uAVnTUMFRZxjqcez+KXx7NuU0K6jMGANkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+YXys8KT3gnol153sjQYMPNhO8B30aGCm5LK39kumH8=;
 b=Y2is3yOIzbdNLWrYPEDniyGhvszcLN5r8p0kLiP8NtnAbzgHr/+/kdXMXA3Aug3gudFmF7Lok64NKKezSWE7nMT7xQjdJUTt0fMowsA9eajP0cYv0ExYsWqhXjjSnnEU5p9i/WAKCnvuk9lqWAyjHoCuEOQsI5n10bn9VD1vbRnnSwCaqyTZSOhjei/IaWoJsNWAd9THG8+kbb+tJ232nXaQhVaC5/HLAl12qe8f2RDV2GcVgutTXsQmtl5T8jhuzhIdBGpKvfDZHwbj+zneQLPY+Iv0+1o2sc6ITXsoMmC/j/fTKRvRf/dReJn6+vtE3JG0hDi4LU6Ri/6qev99qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by BN9PR11MB5452.namprd11.prod.outlook.com (2603:10b6:408:101::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.26; Tue, 27 Sep
 2022 21:10:43 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b%3]) with mapi id 15.20.5654.025; Tue, 27 Sep 2022
 21:10:43 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "dmatlack@google.com" <dmatlack@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
Subject: Re: [PATCH v3 01/10] KVM: x86/mmu: Change tdp_mmu to a read-only
 parameter
Thread-Topic: [PATCH v3 01/10] KVM: x86/mmu: Change tdp_mmu to a read-only
 parameter
Thread-Index: AQHYzeClAoVSdFoVkE6IUn79IeyfMa3zCMQAgABz3YCAAFLRAA==
Date:   Tue, 27 Sep 2022 21:10:43 +0000
Message-ID: <fde43a93b5139137c4783d1efe03a1c50311abc1.camel@intel.com>
References: <20220921173546.2674386-1-dmatlack@google.com>
         <20220921173546.2674386-2-dmatlack@google.com>
         <1c5a14aa61d31178071565896c4f394018e83aaa.camel@intel.com>
         <CALzav=d1wheG3bCKvjZ--HRipaehtaGPqJsDz031aohFjpcmjA@mail.gmail.com>
In-Reply-To: <CALzav=d1wheG3bCKvjZ--HRipaehtaGPqJsDz031aohFjpcmjA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-1.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|BN9PR11MB5452:EE_
x-ms-office365-filtering-correlation-id: bc78e744-9971-403d-14e7-08daa0ccbd5f
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qkL2bb5BRPyVrXvE9UcI8TZ88wJE+h6teLjmSsDcmklG6phiBQB4vZ8KRS0FNQYGSKPLard+W/94wvfY6cl3uasPXvmi01MknjByZsPV9G6lHNiT6U/7/upROWyHRNYbUMvasDsUJZCkKx7UklLdABSXqCYz5+jCiQ4uQ/W4Fz+SamCldVCDBAo8AqEHj4hKhvGzo+Y+4TuYHh7itxP8QXLMX+xlPYy1gof4hIdUlTeloEv8mD33qUWHSTd/F377vK7fP2Uop6EETOb06uKLoFsypmuzWpXt5uG9lYNOb0+azZ0NqLC1TnD0rZQl3mVjqX8woiWdkH3UsPGvZFeDfOIauUG49xdERKbovl5x3TM1dyBPwuGYsJ/rc9rrnYyaJ8i5iViGsgNDooAPfXG0SPNuNndtHmjtpWi9S6qvQaE9kgVdZ+RyFSc2oiehvvg5Ozyg8J0N1V/Uxl9jD1RPTagG0lpx1YYJFHMgkfIwlvNmLvgCElaf42vMgHDtZL35DXOfqmfyuT7E2nIpnkkASd/SDnA//fTjg8exjSB+HjPqqOujh4drriJq9SRDw9QPVrsLzhgLxIjcMlyCk1gwF0uNEz649iE74gbNyVJONA8hn18j3z2bn5NeNpRCQYk2Hx61GMZ8tkrnJa+OUqba5ANOKus/HvxqiIStiKTiDtr9caUMTkWS3hWugI17mEAuCzj/HuvGBxQXRHMdDESr/Rwl6Wd8vgdRgYYIdQmK2hwIDy3JZk0aAV+BsFJg+kpGmpkNY/04mVEDtU5BEM4isg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(346002)(366004)(39860400002)(396003)(451199015)(2906002)(36756003)(86362001)(186003)(53546011)(6506007)(8936002)(6512007)(5660300002)(41300700001)(2616005)(38100700002)(82960400001)(38070700005)(122000001)(83380400001)(26005)(66946007)(54906003)(6916009)(316002)(478600001)(71200400001)(6486002)(91956017)(66556008)(66476007)(66446008)(76116006)(8676002)(64756008)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dkdhYmlFbTc2ajdQZjdQN3Jpa082ZmxhV1JTQlN5MnMxZzdGN2pqajYwb0VN?=
 =?utf-8?B?WXZUQlFBYWpXb1loeDlSYjdyWnVXQTRMRlJ2NzUwRkx3RzZGYTNlVnk3U3k1?=
 =?utf-8?B?SUNYYmZwSUFhQWhzRDhsSmtCNVN5VDBvSWVKTjl2NmJIeDNVa1A0cUUwRnho?=
 =?utf-8?B?c0hwTVRSMmJRTDJKSVpvWXBxdkdtMURQa2JRanppaDFtTXNWNEtBY1IrZzAr?=
 =?utf-8?B?MnphRTQvWU1tNXJDVWc2T3VDSVpiY3g3U0ZMTFNpaDd3WGhTWk9vL1lTUVFZ?=
 =?utf-8?B?NjlTUnkrTUdOTlEweVlkWmhVT05YcDdqZkh1eFBQaTExT0Y4dnRETTg5NExZ?=
 =?utf-8?B?U09tc2k3WjZ3ZTNpN0E4S2VWa09iYm1MUGlxVlRZdWdFbTBPd0pqczZiblBM?=
 =?utf-8?B?NytXQ2I3c2t2NUdlYmh3VGUrSE4xVUhtYkJTd29tTjFMTUJYNFhOK1BxN3Vm?=
 =?utf-8?B?bGZERGtVVXpQSDBQaHZXL3ZKOVdaQVlaWHJnTjNNbHd6YVg2L3IzbjBwRHFj?=
 =?utf-8?B?VFVkRXRZOFkwQlNiWFUxYXpJOVFpQ0llcjBxMjVaS2JadzhuanRvZ1lFWFdL?=
 =?utf-8?B?UTRhMmRlOExYeDJLc1R5eFlkTmhMMUR0bXF1NUF4ZmowM3N5Vm85UHJ5N292?=
 =?utf-8?B?bWZ4ZndRM0xxNXRLWjBFckNNR090NjdHSEhUY3FMdEFnY092amRuWWQvQjZq?=
 =?utf-8?B?VkhST0VVbCs1N1RPbkowSnRxTU04U0NZTUE0MTNxSHRWRlRxRmk0dGNub0NL?=
 =?utf-8?B?UjJRS2NWOU1nVnNWa0JrRWRUdWFUL1BkS2ZJQWY5OWVEYlFFTVVUZnhmZjlC?=
 =?utf-8?B?TFhvZ3U4dzBSa3cydzZGZUV0UThTcTR1NlVMbmdpNXYyMUJRdys3V1BwMkFo?=
 =?utf-8?B?bHRQUWxhQWwwNC9QVWlRTEpqRERPUnJTN2tLZGNCaE9OYXQzTmMrUjVENC9R?=
 =?utf-8?B?MmpwOEJKTVJkazc3eklyN0RyM1hEWm15RGplQzRDM3Y3bnhWMURvdmxpbFhj?=
 =?utf-8?B?ZW11VituYlEwVTZRbWZ6RVdxbGlORlpxL2U4bHZxdGRyVFc5UkJTWkdVYTJ1?=
 =?utf-8?B?U1NLZFY5YXovMzA3NFNzbFdyK1VCejBKaHdVYk9zVjRHNzdnWUdLbTlrN2Ru?=
 =?utf-8?B?REZaS2JyU1Yzd3pvU2Q2SFhieUdXVEw3VGhmaFBRTGlhTUdYRWRwMmZDQzdp?=
 =?utf-8?B?cnlJVDF2YUFmaUNlSFZ1RlpwbEhtdVU2aFhBZkIxVzR0ZnFudFR2eGl4cVNL?=
 =?utf-8?B?Mkk2bzBneGIzSzVyTUZpMTUrVkx6WDVZYjNlMkNFRUVRUGVrVHMxSU1USUxW?=
 =?utf-8?B?SndBUjlPclh5Y0w3VHJKaC9VYXUzZXhoTUd3UzNUM05aMnFyUXNuckVKTXA2?=
 =?utf-8?B?UExxUmNYNnR2TDNBRFVPcFdFSXpYc3AvTWF4MlQ3ek1OSUxMMVJRR3BpV3Ro?=
 =?utf-8?B?cHphbE9Fd09BTjdoSHVHakVHaTJtUGc2QUduOEtsN2lhd3FhelN0bEhtNEtV?=
 =?utf-8?B?ZG5QLzBob1NvS3pOaEV2U2RNR1NCZGh5MzZWell2eVkxTmtzaTZRMmUyNDlL?=
 =?utf-8?B?VG93MTNDYkNVbXFYeXl0Zjh3TGJBcktFR1MwaEdLNk12OVZIZ3lHVHB0azBF?=
 =?utf-8?B?YXFrRENMSWR3K2ZXbllQNTdFVFliYzJuTUNqVWVobTJZNjV5RjJ0bnhiYTg5?=
 =?utf-8?B?a2hSSGNLNmJyMklsWWFsM3lZYTZoY0VWcmIxa2dXTHVlODMxM044YUt6dDR3?=
 =?utf-8?B?VnVXWjd2TnpIaTI1ZHlBc0JhcDlJWDc1ZUpoTHJiaXV1S0NUWDVtcGgvakhs?=
 =?utf-8?B?TEd1Q0pIR0lhZFg2YU1UWHZYSDFqRWxlSWs3R1lLWDFEWTNwMnpyVWhXc0ZP?=
 =?utf-8?B?UU1Razg3Yk9XTG9ZTGpDeXZnTUxlZmV2QlR4VHBGV2h0SldObFJBWjZCTW9n?=
 =?utf-8?B?R3JXWXNNMWNXd1FYSTMrZm12aTlKZnJjYXQxNGt5cmc3ZEJwM2UyQ2VEZ2ND?=
 =?utf-8?B?NjlVRFpRN2ZjR3lBbjVBbFp1NStvTTlONHE2NmhNMXpBbS93UjZZVmZsRXBh?=
 =?utf-8?B?YVlla0RMYWwyK0lpODRQamhnTllBRkdmMlc4L2lDOXlVSVNLeS9pUW8xSVpL?=
 =?utf-8?B?TlQ0Y3J2b3llMFZlSkpyNExmK21NRW1BcEZRcW02ZEpsVlR5Y3Q5Tko1dk05?=
 =?utf-8?B?Y2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3427DE238CA76544832EEBEF98568693@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc78e744-9971-403d-14e7-08daa0ccbd5f
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2022 21:10:43.6931
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KXtuqP5nnvOCNKOc4NxRRGzheFCknvCmklKqn62rXTjcuNheyIWgEXwS26wuwK4bgFU3+/0FGTj84/WrvW5ddw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5452
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIyLTA5LTI3IGF0IDA5OjE0IC0wNzAwLCBEYXZpZCBNYXRsYWNrIHdyb3RlOg0K
PiBPbiBUdWUsIFNlcCAyNywgMjAyMiBhdCAyOjE5IEFNIEh1YW5nLCBLYWkgPGthaS5odWFuZ0Bp
bnRlbC5jb20+IHdyb3RlOg0KPiA+IA0KPiA+IA0KPiA+ID4gDQo+ID4gPiArYm9vbCBfX3JvX2Fm
dGVyX2luaXQgdGRwX21tdV9hbGxvd2VkOw0KPiA+ID4gKw0KPiA+IA0KPiA+IFsuLi5dDQo+ID4g
DQo+ID4gPiBAQCAtNTY2Miw2ICs1NjY5LDkgQEAgdm9pZCBrdm1fY29uZmlndXJlX21tdShib29s
IGVuYWJsZV90ZHAsIGludCB0ZHBfZm9yY2VkX3Jvb3RfbGV2ZWwsDQo+ID4gPiAgICAgICB0ZHBf
cm9vdF9sZXZlbCA9IHRkcF9mb3JjZWRfcm9vdF9sZXZlbDsNCj4gPiA+ICAgICAgIG1heF90ZHBf
bGV2ZWwgPSB0ZHBfbWF4X3Jvb3RfbGV2ZWw7DQo+ID4gPiANCj4gPiA+ICsjaWZkZWYgQ09ORklH
X1g4Nl82NA0KPiA+ID4gKyAgICAgdGRwX21tdV9lbmFibGVkID0gdGRwX21tdV9hbGxvd2VkICYm
IHRkcF9lbmFibGVkOw0KPiA+ID4gKyNlbmRpZg0KPiA+ID4gDQo+ID4gDQo+ID4gWy4uLl0NCj4g
PiANCj4gPiA+IEBAIC02NjYxLDYgKzY2NzEsMTMgQEAgdm9pZCBfX2luaXQga3ZtX21tdV94ODZf
bW9kdWxlX2luaXQodm9pZCkNCj4gPiA+ICAgICAgIGlmIChueF9odWdlX3BhZ2VzID09IC0xKQ0K
PiA+ID4gICAgICAgICAgICAgICBfX3NldF9ueF9odWdlX3BhZ2VzKGdldF9ueF9hdXRvX21vZGUo
KSk7DQo+ID4gPiANCj4gPiA+ICsgICAgIC8qDQo+ID4gPiArICAgICAgKiBTbmFwc2hvdCB1c2Vy
c3BhY2UncyBkZXNpcmUgdG8gZW5hYmxlIHRoZSBURFAgTU1VLiBXaGV0aGVyIG9yIG5vdCB0aGUN
Cj4gPiA+ICsgICAgICAqIFREUCBNTVUgaXMgYWN0dWFsbHkgZW5hYmxlZCBpcyBkZXRlcm1pbmVk
IGluIGt2bV9jb25maWd1cmVfbW11KCkNCj4gPiA+ICsgICAgICAqIHdoZW4gdGhlIHZlbmRvciBt
b2R1bGUgaXMgbG9hZGVkLg0KPiA+ID4gKyAgICAgICovDQo+ID4gPiArICAgICB0ZHBfbW11X2Fs
bG93ZWQgPSB0ZHBfbW11X2VuYWJsZWQ7DQo+ID4gPiArDQo+ID4gPiAgICAgICBrdm1fbW11X3Nw
dGVfbW9kdWxlX2luaXQoKTsNCj4gPiA+ICB9DQo+ID4gPiANCj4gPiANCj4gPiBTb3JyeSBsYXN0
IHRpbWUgSSBkaWRuJ3QgcmV2aWV3IGRlZXBseSwgYnV0IEkgYW0gd29uZGVyaW5nIHdoeSBkbyB3
ZSBuZWVkDQo+ID4gJ3RkcF9tbXVfYWxsb3dlZCcgYXQgYWxsPyAgVGhlIHB1cnBvc2Ugb2YgaGF2
aW5nICdhbGxvd19tbWlvX2NhY2hpbmcnIGlzIGJlY2F1c2UNCj4gPiBrdm1fbW11X3NldF9tbWlv
X3NwdGVfbWFzaygpIGlzIGNhbGxlZCB0d2ljZSwgYW5kICdlbmFibGVfbW1pb19jYWNoaW5nJyBj
YW4gYmUNCj4gPiBkaXNhYmxlZCBpbiB0aGUgZmlyc3QgY2FsbCwgc28gaXQgY2FuIGJlIGFnYWlu
c3QgdXNlcidzIGRlc2lyZSBpbiB0aGUgc2Vjb25kDQo+ID4gY2FsbC4gIEhvd2V2ZXIgaXQgYXBw
ZWFycyBmb3IgJ3RkcF9tbXVfZW5hYmxlZCcgd2UgZG9uJ3QgbmVlZCAndGRwX21tdV9hbGxvd2Vk
JywNCj4gPiBhcyBrdm1fY29uZmlndXJlX21tdSgpIGlzIG9ubHkgY2FsbGVkIG9uY2UgYnkgVk1Y
IG9yIFNWTSwgaWYgSSByZWFkIGNvcnJlY3RseS4NCj4gDQo+IHRkcF9tbXVfYWxsb3dlZCBpcyBu
ZWVkZWQgYmVjYXVzZSBrdm1faW50ZWwgYW5kIGt2bV9hbWQgYXJlIHNlcGFyYXRlDQo+IG1vZHVs
ZXMgZnJvbSBrdm0uIFNvIGt2bV9jb25maWd1cmVfbW11KCkgY2FuIGJlIGNhbGxlZCBtdWx0aXBs
ZSB0aW1lcw0KPiAoZWFjaCB0aW1lIGt2bV9pbnRlbCBvciBrdm1fYW1kIGlzIGxvYWRlZCkuDQo+
IA0KPiANCg0KSW5kZWVkLiA6KQ0KDQpSZXZpZXdlZC1ieTogS2FpIEh1YW5nIDxrYWkuaHVhbmdA
aW50ZWwuY29tPg0KDQo=
