Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF20E3E1A00
	for <lists+kvm@lfdr.de>; Thu,  5 Aug 2021 19:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236990AbhHERHb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Aug 2021 13:07:31 -0400
Received: from mga11.intel.com ([192.55.52.93]:45341 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236937AbhHERHa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Aug 2021 13:07:30 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10067"; a="211102362"
X-IronPort-AV: E=Sophos;i="5.84,296,1620716400"; 
   d="scan'208";a="211102362"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2021 10:07:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,296,1620716400"; 
   d="scan'208";a="501707669"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga001.jf.intel.com with ESMTP; 05 Aug 2021 10:07:15 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Thu, 5 Aug 2021 10:07:14 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Thu, 5 Aug 2021 10:07:14 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Thu, 5 Aug 2021 10:07:14 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Thu, 5 Aug 2021 10:07:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HD81esg6DOdM5RpOqA9QjIlBUko0D0bZvPa4JHy/iOzm3FaCjUKU8GyciRdFPa4pih812u6GU38sZDw3ph3Kddl3GfhqYcS4HXs/8CjI/ig66VrkexQJ8ZSxZIO2/ygcqhG/TOlrVxiwj0Fnx0PzO31BLtpFF6tJZgieFQYoTKPT1NHEzmJP29WIz7lvRJuO96AuY59iB0YdOvUFOkXRWWwZih2Nu69whPsAaSSBBI6dtcHUeRE++B9w8vg1/HdvH8a2mfx1R1q/MHLCGZ3VB9uxdTwAzxencwt5Dd+eJtl8KsLh1jIbqKVQkIFh3oYTR089wlzPQ0XPJlDVnCP/Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eY9wxi8QBBwxiH5bcDfLjyE5WIwdHdvipP+GD5nOmZ0=;
 b=N2QiNh+btZdQLLuCiNMjy+4YChLgRuSmb3jyObH4FTo+936qyrHYxWFci5FMw1FgejFR4nYZdqKCs1GmPbdQGTCevUCdqXQhkDgtqGJ266JjWLQNWzhAwDlrHpGDIy9qcls5njV8i3yaOQdXmKmW/8XqdIeKZ+7RWba2eSELzC2EDyKFXHctMRtvrivUG/xbgXTFrnHeaDqH4DpFdFU3puG0vN1aGUCRzA6t5a6V5KXD5sGWXZx97sQ9jB0nx+Zi3ILGXRtKzKDXIQtaH60z0W+cBArScF3ZqqcXZ8qxNltQgBXX2iiopLWbyaEqoiR6X276Xh1yj8XilM+Chgr6jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eY9wxi8QBBwxiH5bcDfLjyE5WIwdHdvipP+GD5nOmZ0=;
 b=W09bJF22sZ7eq57GibGME5tk83UST7t+U1tvZaTo6NATWmRjnW+w5vKjA9GZTlwjNk+BQgfoFtVrx6gWw33azAgWBUOb1nqvafuc+hEdT7PyWSsd5ppUK5myvqWGOutQVuRVgs5GWWRM/+30HXVyuixa7NgXLPXhnX6MMtAIFU4=
Received: from SN6PR11MB3184.namprd11.prod.outlook.com (2603:10b6:805:bd::17)
 by SN6PR11MB3133.namprd11.prod.outlook.com (2603:10b6:805:d2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Thu, 5 Aug
 2021 17:07:12 +0000
Received: from SN6PR11MB3184.namprd11.prod.outlook.com
 ([fe80::4046:c957:f6a9:27db]) by SN6PR11MB3184.namprd11.prod.outlook.com
 ([fe80::4046:c957:f6a9:27db%5]) with mapi id 15.20.4394.017; Thu, 5 Aug 2021
 17:07:12 +0000
From:   "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To:     "seanjc@google.com" <seanjc@google.com>,
        "Huang, Kai" <kai.huang@intel.com>
CC:     "erdemaktas@google.com" <erdemaktas@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jmattson@google.com" <jmattson@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "ckuehl@redhat.com" <ckuehl@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>
Subject: Re: [RFC PATCH v2 41/69] KVM: x86: Add infrastructure for stolen GPA
 bits
Thread-Topic: [RFC PATCH v2 41/69] KVM: x86: Add infrastructure for stolen GPA
 bits
Thread-Index: AQHXb45iOjTe58868U2SNstYrdIG9qtk/1wAgABJSICAABDngA==
Date:   Thu, 5 Aug 2021 17:07:12 +0000
Message-ID: <78b802bbcf72a087bcf118340eae89f97024d09c.camel@intel.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
         <c958a131ded780808a687b0f25c02127ca14418a.1625186503.git.isaku.yamahata@intel.com>
         <20210805234424.d14386b79413845b990a18ac@intel.com>
         <YQwMkbBFUuNGnGFw@google.com>
In-Reply-To: <YQwMkbBFUuNGnGFw@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8d3964b0-8b06-43bc-4553-08d9583377af
x-ms-traffictypediagnostic: SN6PR11MB3133:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB313381112E831DBEDCF14D75C9F29@SN6PR11MB3133.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WuHqlPk72QydG0J4o1JWCEzI2IpAHTqvtspOP+komEbQZZGhLcq2/0/LMu6gDjSEZx10nKpjKnE8K/a37DLwoNX/Fhtgi9f+a/B9wmPgFMysIbdyYSKTIkK6xM3BIjDZmNOu5mk/tpgiqywhNBTZOHzKjdN90ViNUYudj8HqBQx3+3I5kQb7bDXlR4nQmzI4cCnaV+ZGklklqOVoLIsXQDM/FQHF2KFvjzqTGK7rgwKv0eR68fBloR8OO+8vU3VO2HpZiZ2hXIGx5ODxXB0EWVRtJGZNG2T6T2UBcUsdo8p9OHUaP6pDDNOUe9gbxNB3u8DrNkqeT9MinVamK3racvn8L+6AShbM+x9zYsYC6eI+IrHgViznf7KAcwwlTZYkaWLmqJCNm4brQdvSpjNlUUMBdTQ95bcatHJu0ZPjP8P1CF9ynONq31kMOQFNXFPKY4JdB29qQMrQKELhT3xMSkUIRxniFmuwLDVY0+HLhCIKt2uj7NMuitEcO7DnlEU7fbGfAIX2SuPYiEZQ1eJsitjnUxzZ6lUxcPZkfKXnepdhXGrYBcxcMp5PwyWfaOPkTf9PuH1kecwxvrqMMWehhlR9Xn/A4eBW6zas65+De6xiPhRTAOyaQEsUNvA5frN9jBAeLmU2m+/P4e4PqMxmNnbNkb+07Lyo45N6LjREZJgUuqs0VVp0ud87t3JVzg+PeDbsEm2CbnuSEy9XiML75YNrAEWdaLQMz9AgW8w6iG8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3184.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6512007)(54906003)(38100700002)(110136005)(122000001)(36756003)(2616005)(8936002)(26005)(86362001)(5660300002)(66446008)(38070700005)(83380400001)(64756008)(6506007)(71200400001)(66556008)(2906002)(66476007)(316002)(7416002)(66946007)(508600001)(6486002)(8676002)(76116006)(186003)(91956017)(4326008)(6636002)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RG9qNUdVOU5MYU5nM1FqQ05FMGwwei8zcjREUkRGeFZ5RkIrMmRlM1NRNkZm?=
 =?utf-8?B?Zks2YitaSTR2c1VFdjZRRUs1SHRwL3A2N3NxeXl2N2lNZExaTG4wQ3dpRjJ4?=
 =?utf-8?B?WXBLQ1BqWDN4eDkyUFgydjc2cW80MW5SQnVHRitDYWZuRllrdWQ3NGJFSkRP?=
 =?utf-8?B?Y095UTJQVnhTcWgzM2JmQ1FERlN5RmowV1BsY2YvUDNiMHhwTnlKbDM4OHl5?=
 =?utf-8?B?RFV4V1U3V21FYjF3elV2VEF3amtjMGxzSi9CS3loeHRQSm9CZ2VxWUp5U2xm?=
 =?utf-8?B?R21tNThWYUtmRGgzY21oZFRQZmFOd2JnRW9kam5kSEsyQytORnJRSzZoU2kz?=
 =?utf-8?B?cWhGNDlrcDhQUnBqM1ZqNkRoODFPZm5WTEdteXU5a1l3MjJpdk9lWUJIS3ZF?=
 =?utf-8?B?clY0aU9YOFl2UGlrczA3S3phWHZudEZ0cm5JSmdoYVAwNWwybE1sRm8zZkdw?=
 =?utf-8?B?TTZ6ZW13UEFKQm51UmdTSHRyRjFQcXFKcU5mVmlyRUtVbXJqei9FTUhqcFp5?=
 =?utf-8?B?eGpRbXFzb21RWHhNZ1ArUnF5U3VRVjBPdzAvV0p3VUs0M3JIR0ZiRmZRYkdW?=
 =?utf-8?B?NDlGZytVOEhFZHUvNVI3bjQrYS9tSVFXVm9YOU5kMitpYjRucUg4dzdKVVNx?=
 =?utf-8?B?WWdZV3ZxRDNMUkRqNFV5STZRc1djbnl2Y25qV1Fld2p2S1daMzlPdmgybk4w?=
 =?utf-8?B?bkw1Z1A2MkdFOWFERjAzV0hRRVcwU0NERDFMYXAxZ0xYOUFhSkEyUHIwb0I3?=
 =?utf-8?B?bngwc1RLWFYxZUpPNDNCcVlZYmZuVkN6aHRKK2ZSRUtJeWNPVjVjQkFwYnJa?=
 =?utf-8?B?ZnEySlhjSEkzQUd2Y2ZzSTRLNWdML25RNjBqbXdtbDZBN2FHMWtXakRVQ1Rz?=
 =?utf-8?B?VEI4bVdQVTZPOXg5UTMvN3RieXA1L3p0MW00Mmx4SzBHU1htS3paNWpyUDJE?=
 =?utf-8?B?RXVKNTNDV1VnOTRWV3pWUGo2VDE2KzNIbVpITEI1akNwSmR1aFliZFUySWFn?=
 =?utf-8?B?cTA4Sm5RVW5ReEhSZzlTMzVyakJwcWN3Y0wzdUlEd1pGZmc1SVlGOFhxalg3?=
 =?utf-8?B?SGxGU3hRSDMyNnlpR2VyYVUzdDBVNzJsY1F2ZC9iSkdOazNUWmdMUU1ZMUxu?=
 =?utf-8?B?b0FKUldsWDdhdFlkemhUNjdLeVNsMjRpV3p0NVc0ZXhJcFRpbmE4MGJsSWcy?=
 =?utf-8?B?eTYrRDVYQlBwYkpveUtleTErbVhqSTE3MXVEUUFYWU1RZjFLRG1NYzdQekNZ?=
 =?utf-8?B?OWk0QmxXVFdoY0pxLzdIeTcwZnBWNFkySloxZlAvQmsxZVZldHVqZUhyQ08r?=
 =?utf-8?B?UlNsa3JHdWVOMUE3UFR5U1lFQkQrVEVvUEppampwQVFGam80aVYxTVFOSGti?=
 =?utf-8?B?dytSZ2VyM210Wmt2T21wZndHWlZ2Njc0aWRLWXB4VFBRd3cxbjZzaE05WHdP?=
 =?utf-8?B?c1NTMk84UkdsVHVzc1RiY2NzTlZFZE1vY2IzMHZsajdYQXk4RWdMZ05QekI1?=
 =?utf-8?B?YUtuM0MwVzIyT0wyNFhaZStqV1RSd0x4NzBtWjZJZE5lYjVXQitDTU14SElO?=
 =?utf-8?B?ZUZSc3gvazhCcGJ4eXdBb2dTMVZqbkYvc2N2cktXWFFMdlFVUzVMTjI4cHFT?=
 =?utf-8?B?MFUxTnhOVGpSU0JkYWFwMTlseDdiSWd5Z0JkWjEyVTBpK1BYNE1JbTRvYjJi?=
 =?utf-8?B?MWlvUnduT0JHcHc3OGJxbGtFb0xhaVFVSm9ESkpjcEt0cjZJdG1ZVUFJaG9v?=
 =?utf-8?B?TXJ0T2t3NnRYMk91WTR0Z3hzaDU1YVY5d3R4RzIxMVExTEFZZ0VaeDl5a08y?=
 =?utf-8?B?UHIxL3E4T3NEaVptRENKdz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4457278765C33343B6F07F2ADFB6F312@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3184.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d3964b0-8b06-43bc-4553-08d9583377af
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2021 17:07:12.2258
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cGUsuzU6jQ7oQjfneRQSPJV8n/b14cO8oLpl0ieqeKug9vwhNJsA5ItWSG9oMnko36U282XJS+jxlU6uN15t1mHcQ34N3xwm+NHH4rrsF2U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3133
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIxLTA4LTA1IGF0IDE2OjA2ICswMDAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUaHUsIEF1ZyAwNSwgMjAyMSwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IE9uIEZy
aSwgMiBKdWwgMjAyMSAxNTowNDo0NyAtMDcwMCBpc2FrdS55YW1haGF0YUBpbnRlbC5jb20gd3Jv
dGU6DQo+ID4gPiBGcm9tOiBSaWNrIEVkZ2Vjb21iZSA8cmljay5wLmVkZ2Vjb21iZUBpbnRlbC5j
b20+DQo+ID4gPiBAQCAtMjAyMCw2ICsyMDMyLDcgQEAgc3RhdGljIHN0cnVjdCBrdm1fbW11X3Bh
Z2UNCj4gPiA+ICprdm1fbW11X2dldF9wYWdlKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwNCj4gPiA+
ICAJc3AgPSBrdm1fbW11X2FsbG9jX3BhZ2UodmNwdSwgZGlyZWN0KTsNCj4gPiA+ICANCj4gPiA+
ICAJc3AtPmdmbiA9IGdmbjsNCj4gPiA+ICsJc3AtPmdmbl9zdG9sZW5fYml0cyA9IGdmbl9zdG9s
ZW5fYml0czsNCj4gPiA+ICAJc3AtPnJvbGUgPSByb2xlOw0KPiA+ID4gIAlobGlzdF9hZGRfaGVh
ZCgmc3AtPmhhc2hfbGluaywgc3BfbGlzdCk7DQo+ID4gPiAgCWlmICghZGlyZWN0KSB7DQo+ID4g
PiBAQCAtMjA0NCw2ICsyMDU3LDEzIEBAIHN0YXRpYyBzdHJ1Y3Qga3ZtX21tdV9wYWdlDQo+ID4g
PiAqa3ZtX21tdV9nZXRfcGFnZShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsDQo+ID4gPiAgCXJldHVy
biBzcDsNCj4gPiA+ICB9DQo+ID4gDQo+ID4gDQo+ID4gU29ycnkgZm9yIHJlcGx5aW5nIG9sZCB0
aHJlYWQsDQo+IA0KPiBIYSwgb25lIG1vbnRoIGlzbid0IG9sZCwgaXQncyBiYXJlbHkgZXZlbiBt
YXR1cmUuDQo+IA0KPiA+IGJ1dCB0byBtZSBpdCBsb29rcyB3ZWlyZCB0byBoYXZlIGdmbl9zdG9s
ZW5fYml0cw0KPiA+IGluICdzdHJ1Y3Qga3ZtX21tdV9wYWdlJy4gIElmIEkgdW5kZXJzdGFuZCBj
b3JyZWN0bHksIGFib3ZlIGNvZGUNCj4gPiBiYXNpY2FsbHkNCj4gPiBtZWFucyB0aGF0IEdGTiB3
aXRoIGRpZmZlcmVudCBzdG9sZW4gYml0IHdpbGwgaGF2ZSBkaWZmZXJlbnQNCj4gPiAnc3RydWN0
DQo+ID4ga3ZtX21tdV9wYWdlJywgYnV0IGluIHRoZSBjb250ZXh0IG9mIHRoaXMgcGF0Y2gsIG1h
cHBpbmdzIHdpdGgNCj4gPiBkaWZmZXJlbnQNCj4gPiBzdG9sZW4gYml0cyBzdGlsbCB1c2UgdGhl
IHNhbWUgcm9vdCwNCj4gDQo+IFlvdSdyZSBjb25mbGF0aW5nICJtYXBwaW5nIiB3aXRoICJQVEUi
LiAgVGhlIEdGTiBpcyBhIHBlci1QVEUNCj4gdmFsdWUuICBZZXMsIHRoZXJlDQo+IGlzIGEgZmlu
YWwgR0ZOIHRoYXQgaXMgcmVwcmVzZW50YXRpdmUgb2YgdGhlIG1hcHBpbmcsIGJ1dCBtb3JlDQo+
IGRpcmVjdGx5IHRoZSBmaW5hbA0KPiBHRk4gaXMgYXNzb2NpYXRlZCB3aXRoIHRoZSBsZWFmIFBU
RS4NCj4gDQo+IFREWCBlZmZlY3RpdmVseSBhZGRzIHRoZSByZXN0cmljdGlvbiB0aGF0IGFsbCBQ
VEVzIHVzZWQgZm9yIGEgbWFwcGluZw0KPiBtdXN0IGhhdmUNCj4gdGhlIHNhbWUgc2hhcmVkL3By
aXZhdGUgc3RhdHVzLCBzbyBtYXBwaW5nIGFuZCBQVEUgYXJlIHNvbWV3aGF0DQo+IGludGVyY2hh
bmdlYWJsZQ0KPiB3aGVuIHRhbGtpbmcgYWJvdXQgc3RvbGVuIGJpdHMgKHRoZSBzaGFyZWQgYml0
KSwgYnV0IGluIHRoZSBjb250ZXh0DQo+IG9mIHRoaXMgcGF0Y2gsDQo+IHRoZSBzdG9sZW4gYml0
cyBhcmUgYSBwcm9wZXJ0eSBvZiB0aGUgUFRFLg0KPiANCj4gQmFjayB0byB5b3VyIHN0YXRlbWVu
dCwgaXQncyBpbmNvcnJlY3QuICBQVEVzIChlZmZlY3RpdmVseSBtYXBwaW5ncw0KPiBpbiBURFgp
IHdpdGgNCj4gZGlmZmVyZW50IHN0b2xlbiBiaXRzIHdpbGwgX25vdF8gdXNlIHRoZSBzYW1lDQo+
IHJvb3QuICBrdm1fbW11X2dldF9wYWdlKCkgaW5jbHVkZXMNCj4gdGhlIHN0b2xlbiBiaXRzIGlu
IGJvdGggdGhlIGhhc2ggbG9va3VwIGFuZCBpbiB0aGUgY29tcGFyaXNvbiwgaS5lLg0KPiByZXN0
b3JlcyB0aGUNCj4gc3RvbGVuIGJpdHMgd2hlbiBsb29raW5nIGZvciBhbiBleGlzdGluZyBzaGFk
b3cgcGFnZSBhdCB0aGUgdGFyZ2V0DQo+IEdGTi4NCj4gDQo+IEBAIC0xOTc4LDkgKzE5OTAsOSBA
QCBzdGF0aWMgc3RydWN0IGt2bV9tbXVfcGFnZQ0KPiAqa3ZtX21tdV9nZXRfcGFnZShzdHJ1Y3Qg
a3ZtX3ZjcHUgKnZjcHUsDQo+ICAgICAgICAgICAgICAgICByb2xlLnF1YWRyYW50ID0gcXVhZHJh
bnQ7DQo+ICAgICAgICAgfQ0KPiANCj4gLSAgICAgICBzcF9saXN0ID0gJnZjcHUtPmt2bS0NCj4g
PmFyY2gubW11X3BhZ2VfaGFzaFtrdm1fcGFnZV90YWJsZV9oYXNoZm4oZ2ZuKV07DQo+ICsgICAg
ICAgc3BfbGlzdCA9ICZ2Y3B1LT5rdm0tDQo+ID5hcmNoLm1tdV9wYWdlX2hhc2hba3ZtX3BhZ2Vf
dGFibGVfaGFzaGZuKGdmbl9hbmRfc3RvbGVuKV07DQo+ICAgICAgICAgZm9yX2VhY2hfdmFsaWRf
c3AodmNwdS0+a3ZtLCBzcCwgc3BfbGlzdCkgew0KPiAtICAgICAgICAgICAgICAgaWYgKHNwLT5n
Zm4gIT0gZ2ZuKSB7DQo+ICsgICAgICAgICAgICAgICBpZiAoKHNwLT5nZm4gfCBzcC0+Z2ZuX3N0
b2xlbl9iaXRzKSAhPQ0KPiBnZm5fYW5kX3N0b2xlbikgew0KPiAgICAgICAgICAgICAgICAgICAg
ICAgICBjb2xsaXNpb25zKys7DQo+ICAgICAgICAgICAgICAgICAgICAgICAgIGNvbnRpbnVlOw0K
PiAgICAgICAgICAgICAgICAgfQ0KPiANCj4gPiB3aGljaCBtZWFucyBnZm5fc3RvbGVuX2JpdHMg
ZG9lc24ndCBtYWtlIGEgbG90IG9mIHNlbnNlIGF0IGxlYXN0DQo+ID4gZm9yIHJvb3QNCj4gPiBw
YWdlIHRhYmxlLiANCj4gDQo+IEl0IGRvZXMgbWFrZSBzZW5zZSwgZXZlbiB3aXRob3V0IGEgZm9s
bG93LXVwIHBhdGNoLiAgSW4gUmljaydzDQo+IG9yaWdpbmFsIHNlcmllcywNCj4gc3RlYWxpbmcg
YSBiaXQgZm9yIGV4ZWN1dGUtb25seSBndWVzdCBtZW1vcnksIHRoZXJlIHdhcyBvbmx5IGEgc2lu
Z2xlDQo+IHJvb3QuICBBbmQNCj4gZXhjZXB0IGZvciBURFgsIHRoZXJlIGNhbiBvbmx5IGV2ZXIg
YmUgYSBzaW5nbGUgcm9vdCBiZWNhdXNlIHRoZQ0KPiBzaGFyZWQgRVBUUCBpc24ndA0KPiB1c2Fi
bGUsIGkuZS4gdGhlcmUncyBvbmx5IHRoZSByZWd1bGFyL3ByaXZhdGUgRVBUUC4NCj4gDQo+ID4g
SW5zdGVhZCwgaGF2aW5nIGdmbl9zdG9sZW5fYml0cyBpbiAnc3RydWN0IGt2bV9tbXVfcGFnZScg
b25seSBtYWtlcw0KPiA+IHNlbnNlIGluDQo+ID4gdGhlIGNvbnRleHQgb2YgVERYLCBzaW5jZSBU
RFggcmVxdWlyZXMgdHdvIHNlcGFyYXRlIHJvb3RzIGZvcg0KPiA+IHByaXZhdGUgYW5kDQo+ID4g
c2hhcmVkIG1hcHBpbmdzLg0KPiA+IFNvIGdpdmVuIHdlIGNhbm5vdCB0ZWxsIHdoZXRoZXIgdGhl
IHNhbWUgcm9vdCwgb3IgZGlmZmVyZW50IHJvb3RzDQo+ID4gc2hvdWxkIGJlDQo+ID4gdXNlZCBm
b3IgZGlmZmVyZW50IHN0b2xlbiBiaXRzLCBJIHRoaW5rIHdlIHNob3VsZCBub3QgYWRkDQo+ID4g
J2dmbl9zdG9sZW5fYml0cycgdG8NCj4gPiAnc3RydWN0IGt2bV9tbXVfcGFnZScgYW5kIHVzZSBp
dCB0byBkZXRlcm1pbmUgd2hldGhlciB0byBhbGxvY2F0ZSBhDQo+ID4gbmV3IHRhYmxlDQo+ID4g
Zm9yIHRoZSBzYW1lIEdGTiwgYnV0IHNob3VsZCB1c2UgYSBuZXcgcm9sZSAoaS5lIHJvbGUucHJp
dmF0ZSkgdG8NCj4gPiBkZXRlcm1pbmUuDQo+IA0KPiBBIG5ldyByb2xlIHdvdWxkIHdvcmssIHRv
bywgYnV0IGl0IGhhcyB0aGUgZGlzYWR2YW50YWdlIG9mIG5vdA0KPiBhdXRvbWFnaWNhbGx5DQo+
IHdvcmtpbmcgZm9yIGFsbCB1c2VzIG9mIHN0b2xlbiBiaXRzLCBlLmcuIFhPIHN1cHBvcnQgd291
bGQgaGF2ZSB0bw0KPiBhZGQgYW5vdGhlcg0KPiByb2xlIGJpdC4NCj4gDQo+ID4gQW5kIHJlbW92
aW5nICdnZm5fc3RvbGVuX2JpdHMnIGluICdzdHJ1Y3Qga3ZtX21tdV9wYWdlJyBjb3VsZCBhbHNv
DQo+ID4gc2F2ZSBzb21lDQo+ID4gbWVtb3J5Lg0KPiANCj4gQnV0IEkgZG8gbGlrZSBzYXZpbmcg
bWVtb3J5Li4uICBPbmUgcG90ZW50aWFsbHkgYmFkIGlkZWEgd291bGQgYmUgdG8NCj4gdW5pb25p
emUNCj4gZ2ZuIGFuZCBzdG9sZW4gYml0cyBieSBzaGlmdGluZyB0aGUgc3RvbGVuIGJpdHMgYWZ0
ZXIgdGhleSdyZQ0KPiBleHRyYWN0ZWQgZnJvbSB0aGUNCj4gZ3BhLCBlLmcuDQo+IA0KPiAJdW5p
b24gew0KPiAJCWdmbl90IGdmbl9hbmRfc3RvbGVuOw0KPiAJCXN0cnVjdCB7DQo+IAkJCWdmbl90
IGdmbjo1MjsNCj4gCQkJZ2ZuX3Qgc3RvbGVuOjEyOw0KPiAJCX0NCj4gCX07DQo+IA0KPiB0aGUg
ZG93bnNpZGVzIGJlaW5nIHRoYXQgYWNjZXNzaW5nIGp1c3QgdGhlIGdmbiB3b3VsZCByZXF1aXJl
IGFuDQo+IGFkZGl0aW9uYWwgbWFza2luZw0KPiBvcGVyYXRpb24sIGFuZCB0aGUgc3RvbGVuIGJp
dHMgd291bGRuJ3QgYWxpZ24gd2l0aCByZWFsaXR5Lg0KDQpJdCBkZWZpbml0ZWx5IHNlZW1zIGxp
a2UgdGhlIHNwIGNvdWxkIGJlIHBhY2tlZCBtb3JlIGVmZmljaWVudGx5Lg0KT25lIG90aGVyIGlk
ZWEgaXMgdGhlIHN0b2xlbiBiaXRzIGNvdWxkIGp1c3QgYmUgcmVjb3ZlcmVkIGZyb20gdGhlIHJv
bGUNCmJpdHMgd2l0aCBhIGhlbHBlciwgbGlrZSBob3cgdGhlIHBhZ2UgZmF1bHQgZXJyb3IgY29k
ZSBzdG9sZW4gYml0cw0KZW5jb2RpbmcgdmVyc2lvbiBvZiB0aGlzIHdvcmtzLg0KDQpJZiB0aGUg
c3RvbGVuIGJpdHMgYXJlIG5vdCBmZWQgaW50byB0aGUgaGFzaCBjYWxjdWxhdGlvbiB0aG91Z2gg
aXQNCndvdWxkIGNoYW5nZSB0aGUgYmVoYXZpb3IgYSBiaXQuIE5vdCBzdXJlIGlmIGZvciBiZXR0
ZXIgb3Igd29yc2UuIEFsc28NCnRoZSBjYWxjdWxhdGlvbiBvZiBoYXNoIGNvbGxpc2lvbnMgd291
bGQgbmVlZCB0byBiZSBhd2FyZS4NCg0KRldJVywgSSBraW5kIG9mIGxpa2Ugc29tZXRoaW5nIGxp
a2UgU2VhbidzIHByb3Bvc2FsLiBJdCdzIGEgYml0DQpjb252b2x1dGVkLCBidXQgdGhlcmUgYXJl
IG1vcmUgdW51c2VkIGJpdHMgaW4gdGhlIGdmbiB0aGFuIHRoZSByb2xlLg0KQWxzbyB0aGV5IGFy
ZSBhIGxpdHRsZSBtb3JlIHJlbGF0ZWQuDQo=
