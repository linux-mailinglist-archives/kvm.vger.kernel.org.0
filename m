Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3118646C993
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 01:50:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238668AbhLHAyU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 19:54:20 -0500
Received: from mga09.intel.com ([134.134.136.24]:52020 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234092AbhLHAyT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 19:54:19 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10191"; a="237533609"
X-IronPort-AV: E=Sophos;i="5.87,295,1631602800"; 
   d="scan'208";a="237533609"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2021 16:50:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,295,1631602800"; 
   d="scan'208";a="600373398"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by FMSMGA003.fm.intel.com with ESMTP; 07 Dec 2021 16:50:48 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 7 Dec 2021 16:50:48 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Tue, 7 Dec 2021 16:50:48 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.106)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Tue, 7 Dec 2021 16:50:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ws0ilyO88CXWiAVTnEDrITwJ9IQuIt5kSbCElF/sD1AaDLfztDvf7M1djLqTlAbeRvT0GhVbG9fuLAHMPGw4dILeMCQeEzGCT4/pXM7Q7Nu+SLvTEaZ3+8RX045y7Bh3uQFIGHzwkPaqHl4RUFBmJTbUd7tvrOzTT9k3R00w/vSGaaAibn3acW2WayGZTpkIsj2ZrZBRfXkS8lX0r3+7NlA5+eFg2XXrcWG8pU1IxqCXuYSpd2ttqZVlbwQGPa/LnU6ATZYjsuX1xng/wozVuj30+4MYUQ14zGZ1picYFw1rsK4hXZsKUf7md0coaYdporDjmYqRLXFc3K+dsv9wBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uBqseOfOOfEZV68DFPKA9b/aiU2IgxG69FWxLflkea4=;
 b=VRGbxHUp0rZf4SsLBZzFZtWgEzbZ+k4zmIC3lEAZpKJT/I092zeagsI+Htc97Ig+5U3O9oFi9TGu1TPqpBct9efEp4BJBEHWCrC3xt5uXPmMZH0DPUbLS/DoCLaJdQC3vl+EHXJMSWOnV+8H5nSpiQb6UuoWNYkYp9cy4UcZABcDMSuSSHsuG0rU/jJQdzgFgR32/e8pFWawMBxC7CnCQ32yObF8JKPWcghTRlmsE9e8pm2Jq/XmyFrPQmcWr8xuXKoyEdZjvs8Gw/aS8gGkEe3DqwgJ+9uH8WPYs2zeNO064uozcEhnw5lkqBmIDuE/aZb7hQDjrv20K1WV1c60Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uBqseOfOOfEZV68DFPKA9b/aiU2IgxG69FWxLflkea4=;
 b=Dj+vLxZGefRydm6KeCjdBl3IzRYb3KyQ1qUvTRJIGZXWBMtam6osmagYq1Ek7EwRQ/E1ISDaIQBjKXydA2bHxCgxD8T/TNtoBiRQZT2Kms8/7r+/1sGYg9hkGeYk44Qss9BjjNwcA1ZVxOhwwnliPv6Iszq0dJzXsJeLaRyzpQ8=
Received: from DM6PR11MB4443.namprd11.prod.outlook.com (2603:10b6:5:14d::27)
 by DM6PR11MB4025.namprd11.prod.outlook.com (2603:10b6:5:197::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.11; Wed, 8 Dec
 2021 00:50:38 +0000
Received: from DM6PR11MB4443.namprd11.prod.outlook.com
 ([fe80::50f8:b705:7a3e:8703]) by DM6PR11MB4443.namprd11.prod.outlook.com
 ([fe80::50f8:b705:7a3e:8703%7]) with mapi id 15.20.4755.022; Wed, 8 Dec 2021
 00:50:38 +0000
From:   "Nakajima, Jun" <jun.nakajima@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Arjan van de Ven" <arjan@linux.intel.com>,
        Jing Liu <jing2.liu@linux.intel.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "Cooper, Andrew" <andrew.cooper3@citrix.com>,
        "Bae, Chang Seok" <chang.seok.bae@intel.com>
Subject: Rewording of Setting IA32_XFD[18] (Re: Thoughts of AMX KVM support
 based on latest kernel)
Thread-Topic: Rewording of Setting IA32_XFD[18] (Re: Thoughts of AMX KVM
 support based on latest kernel)
Thread-Index: AQHX682d8HUox8KhpEaChBLWpUD/ZA==
Date:   Wed, 8 Dec 2021 00:50:38 +0000
Message-ID: <9F8F8297-E70F-427C-BEDA-9FAB86877DBD@intel.com>
References: <BYAPR11MB325685AB8E3DFD245846F854A9939@BYAPR11MB3256.namprd11.prod.outlook.com>
 <878rxn6h6t.ffs@tglx> <16BF8BE6-B7B1-4F3E-B972-9D82CD2F23C8@intel.com>
 <2e2ab02c-b324-e136-924a-0376040163a8@redhat.com>
 <BN9PR11MB5433D6A1368904D9B748846B8C9A9@BN9PR11MB5433.namprd11.prod.outlook.com>
 <c7d87723-5533-257f-fbf0-ecd3a0b96602@redhat.com>
 <D93C093C-8420-45DA-99F5-0A5318ADBBEF@intel.com> <87sfvslaha.ffs@tglx>
 <5ABC728C-9FD3-4BEB-BD02-61E910D69847@intel.com>
In-Reply-To: <5ABC728C-9FD3-4BEB-BD02-61E910D69847@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.7)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e8a6168a-870f-4b9a-8294-08d9b9e4c077
x-ms-traffictypediagnostic: DM6PR11MB4025:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <DM6PR11MB40251B04D5707EC86DD067AA9A6F9@DM6PR11MB4025.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: omSrKBrfs07XE8iDvjLg2WqB232k9JWCIFDqH8XRBRlJwl48SO43XyMjy6XtpqapM37eh9CTbyqZ/qAX2gUtMywvcSqZUA1L1h8sV7umc4dA5gBgjdJoQXjCbPXdzR/tU5id4I9WjXmMtdVgYwz5Y2enu/REGo1V4hjc83De8kmrTeVrjjcYKr4Oo1EBL/lfX3EKnYavPJdA2hkcn9gqdYW6bfFv6SZaBT2hJRKkCF/8K5RvweuTONHWWVNFqTksS+NnaU+FWOQIJOF5IsTlNsbF2NQO53hl93pSXPAkX0oTFcYTH1bo+rA6hiRyNbrKBPevccxq0yNXbMbReFZkzZ7QXt2JJUkIMbwfjSUav5UuTuIGs27m53PA4negf3oUIaZ0yUDxdFo4DMY9qZkB8MiD3k7TqkgTfzhugTD8TYHleZ5d4Pd9WCQJAWTVJAxjLySihoXH+vXLCi/xqO6Z0aCG2IxWU5ygbjCZBoVAQovbuR/XReYJty9AVcUJdVcjzSVC/JWabJAMjvfM1ZTRfMBdKJOLcEIS6oFO5BZwnBuvs29fZ7IT7WLg+ztQRght0sFxWPvjh17jkbAA/YyJG4kA6aGX735cT4L2bdQNqyr51eJycSY0fnIcy20MCuSbuCMq8+ADNZNif+Zt1VJxea4UPKQ4EIwJl6U93+qY+ikNd9JUSD703x+N8wEZ1xedidgrS8s3v94o5+D8OKCr1qCZV/K/VqVdwNJOMQrHP3As4tGqPyhFBluBA0R/nCxx
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4443.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6916009)(2616005)(7416002)(86362001)(186003)(38100700002)(53546011)(26005)(6506007)(122000001)(71200400001)(33656002)(5660300002)(66556008)(64756008)(66946007)(66476007)(66446008)(91956017)(6512007)(76116006)(508600001)(4326008)(6486002)(36756003)(8676002)(83380400001)(82960400001)(2906002)(316002)(38070700005)(54906003)(8936002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QUVqazZNcDBuMkVhNWU0N3VFbzlHZUkwdFVSc2pjbUN6U2YySE9hUithazBt?=
 =?utf-8?B?TW1ML2pqb3luZkZrSWZHaS94NlVUbVoxN0hwUjNGbWg2ek4vaUtRaGdvaTc4?=
 =?utf-8?B?ZkdnZW9YS1g2VEFVa1hWTTg3UkVtOUMrbTdDbU5KSTgvS1dXQSttT1J1SDlr?=
 =?utf-8?B?SzV2eWU5VEpZS0ViUXhxZEZLazk2ZUZNTk9tU04wV0J0a1NoZ0Ivb05iNFlM?=
 =?utf-8?B?N0hxRE1XK04wVlUyTWI4czVXWmF4Vlp5T1BoMVJPYlhtcHpTTXFwTm1kbUFp?=
 =?utf-8?B?TXN6WGdQamZZUENnaGttWDZlUTZydyswQThnNGFNQTB2NDNYMlE4akF5dHky?=
 =?utf-8?B?bVZEZkNHemJhTDYyaUxCd0l1UmpHSnhUYjZ1UWM4aHptRTN3VW1nUUJZWGhG?=
 =?utf-8?B?aHo4bXRLZ2s4VFBHYUtGOUdEQXN2Z1JSYzN0eHlMMmZqU2tLa2V4eHoySXAy?=
 =?utf-8?B?NzJHNndqY0hkUXpteU1DMmpkWXcwcllZbzVJWndIL3dEaWgzcnVKYkZzTmFv?=
 =?utf-8?B?UFNyR0x0djAvbzFaUEdKTVVSaHVnWjVaTzJKWE9lVU1SZjZYQ2grS1ZkVktZ?=
 =?utf-8?B?b00rUHdtc2lIdWRtV0FYTXM1YldTR3pFUWxkSXdrVU5HekRvYkMxa1JFQUNX?=
 =?utf-8?B?VTZmYzdXcEc3akdFQTNBQTNaN0ZZQUdsa3dhZmp2bFVQRUZxWTE1UjhBOWlh?=
 =?utf-8?B?TlhkUXR5ejdSRGFRS01NWjJkUlhrbGJiVGlNQURNU0Z2RXh1dm9qc2xGeTJr?=
 =?utf-8?B?R0d2dGxSTS9mbmk3dDhLTHlwSks3L1Q5UHlsN09JSTF6dVEybHNyS0FIdlJz?=
 =?utf-8?B?M096N3ZTL0hManpTVTZ0bm1oNW1OYzJWRTZtY3l1UDRtUStmUjlpcURJTkdo?=
 =?utf-8?B?VkRwTmZMMjUzWXRTTHRScTNQcEl1R3BJekY4azg2Z004T0dTOFBrSmd3b0dK?=
 =?utf-8?B?RjRobjQxanM3c1R3SThiUTdrQ3BVUSs3ODVKQnJFUVF4M0NtUXA2Ym9CSkxB?=
 =?utf-8?B?SjFhSUd3YS9JUkhlRGdWeFowTzBHZVdnWlBJS2tqMUFXOTBnak45amNlbVpY?=
 =?utf-8?B?MTRuY1ZOODhIWGNkYU9VMjZUUmFBRE1lU0l3Q1BITGJYajAzQVpLQytXNTFl?=
 =?utf-8?B?WEszTWNGZm52dUt1UVNiVHVTdHorOXV4b2t1RVBHeHIrSmxWWTJpcnFTRVM1?=
 =?utf-8?B?RnQyTUtmVllpMDl3RitIOEdVNHBvbzJnOGJ4OHFZSmxmQzJ0YUJmWkxxbEU2?=
 =?utf-8?B?eTVlVldFeWNnK3o0NS9Ld3FHTmJLR0dXV3NXRVZBTmlCZDlNS3J3M1RqOVhF?=
 =?utf-8?B?WjFXbjRIcWNwcUpsL0grbUlFcmpnMzBUNFlMZUExZzhkMDRpOEVmY0VIaU9o?=
 =?utf-8?B?UEhrdURORGcxWWRHVWdvckRTMVVyRnZmbFFEZW1iaUt2ZTFHMmo2MHBKZjMz?=
 =?utf-8?B?N2tXMXpXNTBZVVNzK3JXa0FLT1JuQlRVQmRFNHgvZnpEeWh1USs3OXl5Wm94?=
 =?utf-8?B?alppU3pVRzRpSlpUT2FtREtrRGgxWDhJWnlOaklmZkNJeXZoSmdJNThzYlBh?=
 =?utf-8?B?d1R4d3pNTlI1cHduc09FajhTNmlMRkdRN2h3QSthQUNrc1dSOXNBSUZnV0hY?=
 =?utf-8?B?NzhsN1duOWwxQW5qZm1pS0gvUUV5aWJyR0FFdEJvK0NncHlFWnIwOGRxdWZL?=
 =?utf-8?B?Y1NScGZxQjV1L0FOSWY3bWFCS2RuMk5nOFgyMWJlS1lGSzhWaDlWL1prb3hJ?=
 =?utf-8?B?VUcrV3AyWDZ6OHhZY3dpT3BiR1lqMk1oTnIveEpPTzN0UGV1TEhVQ0ljUHdO?=
 =?utf-8?B?cHV0MVdJZit2VUxCOWszTTU2Z09HMTZ0bTF1aVlzNjNFTTV6NVpVVzNzdDdX?=
 =?utf-8?B?TXNLajZxZ3NJOGdiczRsM3AyU2dPcTRSdVNtaTFVakJzU3NENVYvbmx4VmdZ?=
 =?utf-8?B?R0M4ODhGU0k5VThJNktlWHR3SHlBYjhGUG5iWDVBNWhQQnNqSEREeDQ1RDg5?=
 =?utf-8?B?aktpY0V4TXFKdUFkMDNWQk5NczZxb1p0bFhoNWFXbklpYnNuR0tFengvTFBI?=
 =?utf-8?B?ZDVhVlJQSDdSV2lFSjBVZmJ6QkdMR1ZNVndEK0ZRVEtvQnREWUNYK2JMeDNH?=
 =?utf-8?B?RU0wcTcxU2MyR2xwbUpBZDdkR2NjdUNpNHl3b1d5ZS8yZ1VmdSs4Q2wvejgx?=
 =?utf-8?Q?Uq1Sj5X3tDjc2Vuv47mxL7A=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E7459A90DB4F9B45A1A024530ABBD774@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4443.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8a6168a-870f-4b9a-8294-08d9b9e4c077
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Dec 2021 00:50:38.1016
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N2o3Wy0KDv4y0Fwy+vUOZPae2ePEZK/5VYNjoLlXgCyN/Wv0DXATE7DEv8huh/p+BvKTnjB7Hi68xQIwhxwUhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4025
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gT24gTm92IDE5LCAyMDIxLCBhdCA3OjQxIEFNLCBOYWthamltYSwgSnVuIDxqdW4ubmFr
YWppbWFAaW50ZWwuY29tPiB3cm90ZToNCj4gDQo+IEhpIFRob21hcywNCj4gDQo+PiBPbiBOb3Yg
MTksIDIwMjEsIGF0IDI6MTMgQU0sIFRob21hcyBHbGVpeG5lciA8dGdseEBsaW51dHJvbml4LmRl
PiB3cm90ZToNCj4+IA0KPj4gSnVuLA0KPj4gDQo+PiBPbiBUaHUsIE5vdiAxOCAyMDIxIGF0IDIz
OjE3LCBKdW4gTmFrYWppbWEgd3JvdGU6DQo+Pj4gT24gTm92IDE3LCAyMDIxLCBhdCA0OjUzIEFN
LCBQYW9sbyBCb256aW5pIDxwYm9uemluaUByZWRoYXQuY29tPiB3cm90ZToNCj4+Pj4gDQo+Pj4+
IEl0IGRvZXNuJ3QgaGF2ZSB0byBoYXBwZW4gaW4gY3VycmVudCBwcm9jZXNzb3JzLCBidXQgaXQg
c2hvdWxkIGJlDQo+Pj4+IGFyY2hpdGVjdHVyYWxseSB2YWxpZCBiZWhhdmlvciB0byBjbGVhciB0
aGUgcHJvY2Vzc29yJ3Mgc3RhdGUgYXMgc29vbg0KPj4+PiBhcyBhIGJpdCBpbiBYRkQgaXMgc2V0
IHRvIDEuDQo+Pj4gDQo+Pj4gMy4zIFJFQ09NTUVOREFUSU9OUyBGT1IgU1lTVEVNIFNPRlRXQVJF
DQo+Pj4gDQo+Pj4gU3lzdGVtIHNvZnR3YXJlIG1heSBkaXNhYmxlIHVzZSBvZiBJbnRlbCBBTVgg
YnkgY2xlYXJpbmcgWENSMFsxODoxN10sDQo+Pj4gYnkgY2xlYXJpbmcgQ1I0Lk9TWFNBVkUsIG9y
IGJ5IHNldHRpbmcgSUEzMl9YRkRbMThdLiBJdCBpcyByZWNvbW1lbmRlZA0KPj4+IHRoYXQgc3lz
dGVtIHNvZnR3YXJlIGluaXRpYWxpemUgQU1YIHN0YXRlIChlLmcuLCBieSBleGVjdXRpbmcNCj4+
PiBUSUxFUkVMRUFTRSkgYmVmb3JlIGRvaW5nIHNvLiBUaGlzIGlzIGJlY2F1c2UgbWFpbnRhaW5p
bmcgQU1YIHN0YXRlIGluDQo+Pj4gYSBub24taW5pdGlhbGl6ZWQgc3RhdGUgbWF5IGhhdmUgbmVn
YXRpdmUgcG93ZXIgYW5kIHBlcmZvcm1hbmNlDQo+Pj4gaW1wbGljYXRpb25zLg0KPj4+IA0KPj4+
IFN5c3RlbSBzb2Z0d2FyZSBzaG91bGQgbm90IHVzZSBYRkQgdG8gaW1wbGVtZW50IGEg4oCcbGF6
eSByZXN0b3Jl4oCdDQo+Pj4gYXBwcm9hY2ggdG8gbWFuYWdlbWVudCBvZiB0aGUgWFRJTEVEQVRB
IHN0YXRlIGNvbXBvbmVudC4gVGhpcyBhcHByb2FjaA0KPj4+IHdpbGwgbm90IG9wZXJhdGUgY29y
cmVjdGx5IGZvciBhIHZhcmlldHkgb2YgcmVhc29ucy4gT25lIGlzIHRoYXQgdGhlDQo+Pj4gTERU
SUxFQ0ZHIGFuZCBUSUxFUkVMRUFTRSBpbnN0cnVjdGlvbnMgaW5pdGlhbGl6ZSBYVElMRURBVEEg
YW5kIGRvIG5vdA0KPj4+IGNhdXNlIGFuICNOTSBleGNlcHRpb24uIEFub3RoZXIgaXMgdGhhdCBh
biBleGVjdXRpb24gb2YgWFNBVkUgYnkgYQ0KPj4+IHVzZXIgdGhyZWFkIHdpbGwgc2F2ZSBYVElM
RURBVEEgYXMgaW5pdGlhbGl6ZWQgaW5zdGVhZCBvZiB0aGUgZGF0YQ0KPj4+IGV4cGVjdGVkIGJ5
IHRoZSB1c2VyIHRocmVhZC4NCj4+IA0KPj4gQ2FuIHRoaXMgcHJldHR5IHBsZWFzZSBiZSByZXdv
cmRlZCBzbyB0aGF0IGl0IHNheXM6DQo+PiANCj4+IFdoZW4gc2V0dGluZyBJQTMyX1hGRFsxOF0g
dGhlIEFNWCByZWdpc3RlciBzdGF0ZSBpcyBub3QgZ3VhcmFudGVlZCB0bw0KPj4gYmUgcHJlc2Vy
dmVkLiBUaGUgcmVzdWx0aW5nIHJlZ2lzdGVyIHN0YXRlIGRlcGVuZHMgb24gdGhlDQo+PiBpbXBs
ZW1lbnRhdGlvbi4NCj4+IA0KPj4gQWxzbyBpdCdzIGEgcmVhbCBkZXNpZ24gZGlzYXN0ZXIgdGhh
dCBjb21wb25lbnQgMTcgY2Fubm90IGJlIGZlbmNlZCBvZmYNCj4+IHZpYSBYRkQuIFRoYXQncyBy
ZWFsbHkgaW5jb25zaXN0ZW50IGFuZCBsZWFkcyBleGFjdGx5IHRvIHRoaXMgaGFsZg0KPj4gZGVm
aW5lZCBzdGF0ZS4NCj4+IA0KPiANCj4gSeKAmWxsIHdvcmsgd2l0aCB0aGUgSC9XIHRlYW0gb24g
dGhvc2UgKGkuZS4gcmV3b3JkaW5nIGFuZCB0aGUgY29tcG9uZW50IDE3IGlzc3VlKS4NCj4gDQoN
ClRoZSBmb2xsb3dpbmcgaXMgYSBwb3NzaWJsZSBkb2N1bWVudGF0aW9uIHVwZGF0ZSB0aGF0IG1h
eSBjb252ZXkgdGhlIHJld29yZGluZyB5b3UgcmVxdWVzdGVkLg0KRG9lcyB0aGlzICh0aGUgbGFz
dCBzZW50ZW5jZSwg4oCcSW4gYWRkaXRpb24sIOKAnCkgd29yayBmb3IgeW91Pw0KDQoNCjMuMyBS
RUNPTU1FTkRBVElPTlMgRk9SIFNZU1RFTSBTT0ZUV0FSRQ0KDQpTeXN0ZW0gc29mdHdhcmUgbWF5
IGRpc2FibGUgdXNlIG9mIEludGVsIEFNWCBieSBjbGVhcmluZyBYQ1IwWzE4OjE3XSwgYnkgY2xl
YXJpbmcgQ1I0Lk9TWFNBVkUsIG9yIGJ5IHNldHRpbmcgSUEzMl9YRkRbMThdLiBTeXN0ZW0gc29m
dHdhcmUgc2hvdWxkIGluaXRpYWxpemUgQU1YIHN0YXRlIChlLmcuLCBieSBleGVjdXRpbmcgVElM
RVJFTEVBU0UpIHdoZW4gZG9pbmcgc28gYmVjYXVzZSBtYWludGFpbmluZyBBTVggc3RhdGUgaW4g
YSBub24taW5pdGlhbGl6ZWQgc3RhdGUgbWF5IGhhdmUgbmVnYXRpdmUgcG93ZXIgYW5kIHBlcmZv
cm1hbmNlIGltcGxpY2F0aW9ucy4gSW4gYWRkaXRpb24sIHNvZnR3YXJlIHNob3VsZCBub3QgcmVs
eSBvbiB0aGUgc3RhdGUgb2YgdGhlIHRpbGUgZGF0YSBhZnRlciBzZXR0aW5nIElBMzJfWEZEWzE4
XTsgc29mdHdhcmUgc2hvdWxkIGFsd2F5cyByZWxvYWQgb3IgcmVpbml0aWFsaXplIHRoZSB0aWxl
IGRhdGEgYWZ0ZXIgY2xlYXJpbmcgSUEzMl9YRkRbMThdLg0KDQpUaGFua3MsDQotLS0gDQpKdW4N
Cg0KDQoNCg==
