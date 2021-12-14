Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06D1C473C57
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 06:13:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbhLNFNK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 00:13:10 -0500
Received: from mga12.intel.com ([192.55.52.136]:8498 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229757AbhLNFNK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Dec 2021 00:13:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639458790; x=1670994790;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2aqkSVIT2kxK/RZkvRrWf/KI9NR1LzpRD4H4jjCvvoc=;
  b=Zk3Ly0UgTHsrJJqayA96O1KbrX5W6Jy4U4kGxNJdou9+x9vQf4zM7KEh
   +sBEo2Eo7R0xdiv7IkoriEpcJYnQfoaSmTzAZTOTpfLEJbid55aQoysNJ
   wjuw+rBXth7SSleXV+KGMB3DCJ8/j6da4XZxT0NyPTzTwSIfNzCa/hRQH
   sMIJjYGClZoe7kMH6onqvzCXR8h0fvtBCtEATEVoimnL1RKy+JWBjG2Mo
   gaLH7TpGjo2SR6wd9G1wDY1HerACwM5zwJgcAK9OG8KDqHnfJ/5hvzb3M
   XlQ1ChDsN2P487EyD+RLpnERCLrBN3MnbqDkJk0MxxQbMdJ0fOtx5dTbo
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10197"; a="218914179"
X-IronPort-AV: E=Sophos;i="5.88,204,1635231600"; 
   d="scan'208";a="218914179"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2021 21:13:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,204,1635231600"; 
   d="scan'208";a="481777346"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by orsmga002.jf.intel.com with ESMTP; 13 Dec 2021 21:13:09 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 13 Dec 2021 21:13:08 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Mon, 13 Dec 2021 21:13:08 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.175)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Mon, 13 Dec 2021 21:13:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HX1UaDdg5NhhHkrZiGBrCc7rsI4PvTj0g24c13KPmrQH+APP/yMPsTKODqDJZKrgVCEBsZ7qMB3pLIoZiaUzQGOHY1aYJiwWBzXtK1zmWJVnroAsiMD3zUr9BE85frJWMFTdk7JCZLOT9lwGvQAoXnYiDZnRCwtLdgzZvvhvER7MuLAfh0ks+mmeXxHnByFJyVGL5vvUCk2EGrr2l5HjFP986KBUDVpxckbYmXJ9qD8g/RiYy+5fAOB0GlUk8yFddj1FxfmCgEFz5yXNq7frUBgqHy8bQqdBCepIsNk3aiD/YBPrcSylQQR1hsqhfthpsYwH3L1FCuqpdaqVWVm9hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2aqkSVIT2kxK/RZkvRrWf/KI9NR1LzpRD4H4jjCvvoc=;
 b=axne3JNl2l559MtGXruJXSlAmpvmduhXnRVR+6pvQ/SZn7CKMNPfFFFz86ktO6YRvKS7UnbkDcORgRf3jMNNZ/Nv9h6Y9hudAnPwS87nfQPXq4yGGL7ZJFBn4MYAHFhC3hIhaPiOT5RkmmoC6ahgupc2gT6rQJpBuhg11Y70PTOkCHSqwpxc0raEOto/azssIpznpaes1D0HhBhD3ywQaa74cTEy3Yi4otEeIBMYt8AgMN2Bk5CCkpc29lBUWNRVi2EJCs7Vm6lB3Ac3MtUzX6KFMpOxHOcWLORDiAnFazCCHwhHesckHtCLOjtQ5K0A8XyhPBFMyArhIE+wTGcImQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2aqkSVIT2kxK/RZkvRrWf/KI9NR1LzpRD4H4jjCvvoc=;
 b=qmA0xjBdN0+h6vlC3UN6rvI6rGfLmohhJLplrC0VcpCWTWRuqzQRlGDdl3P0lFW9JblonFDdPDW8C7Gw6XXgWSr9Vu1Gv1lnq8W5DcBdOjog7ybP+q6ud8hy1+Bn3kr4dX0K2DDeL710E0+RBaBGEV7D4Ol9w/m5jhJN7QIAULs=
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN8PR11MB3810.namprd11.prod.outlook.com (2603:10b6:408:8f::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.16; Tue, 14 Dec
 2021 05:13:03 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04%3]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 05:13:03 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
CC:     Jing Liu <jing2.liu@linux.intel.com>,
        "Zhong, Yang" <yang.zhong@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>
Subject: RE: [patch 1/6] x86/fpu: Extend fpu_xstate_prctl() with guest
 permissions
Thread-Topic: [patch 1/6] x86/fpu: Extend fpu_xstate_prctl() with guest
 permissions
Thread-Index: AQHX8JVfTOg3rNFsK0+aakD3CIY5xawxabVA
Date:   Tue, 14 Dec 2021 05:13:03 +0000
Message-ID: <BN9PR11MB5276B6158AC37CA38201D4308C759@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20211214022825.563892248@linutronix.de>
 <20211214024947.818549574@linutronix.de>
In-Reply-To: <20211214024947.818549574@linutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a4405c15-5748-4676-4a18-08d9bec067ad
x-ms-traffictypediagnostic: BN8PR11MB3810:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BN8PR11MB3810C5FD8E87F1F5EC28409A8C759@BN8PR11MB3810.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fCBbNTpJ7xu/Cvf4JpsOE4pEOrnCbLnZYBdz3Z8AljLI+N+RowZqrYgV/TR0SC04Enw42J85yG8cSdnMrOEFoTZ7DOncCocjinMyfg6tOHPJGJLWbT+ejnrI0Im2DYZrbOLPADu+nRLpzOcAPaYLa+oeuUZdTIIX6BqX9dC6cQ/96HVigsfigRW7ieP9F2aSrVM1+eSllGU+Bff/I1dbEko5ByPAgG/0NxD/Z2yAyfZe0KG1u4sK39WuKU2wtquo+EpSByEiJ1J1XlAdAaBlMfR2r6RI7R8vY8hWWp+fssX1Sz+kTAtNec8QPnjxJwrCqs3x24ip9N63MFsgdMh5QUNKBOPV3PO8BRKxx6lkYKSHKEOHbN/Uw3YQ2GlX1AY+lt3sY1y8QvM64ruLCZtLC5BUS0UxvFF5M6U7bFAsura/vVe7KyLkYwRKvrJZTMfHv+IOYuLI96vgoNYURUARVuhDfIdBy88cjHZhCBPSlsjuSWolHJfi5bdb20zSJl3FcHxALTmg/Bun8WOcwDGvFhXu11WTtPZxAu5tM7NGnLBlvX38XtVuPCGKCkECAY37Bxz0GFkt8kkWNrjLGIvB3bKQehkvFDMZJ7JmzJAuTmOun57Wfb02OuW+yrytwDdWzKG4ZEnsuI8izt/6jLwcnf0SQ5Iw0UUwT1jXuOgMY39tRoegMiVrE3xM4aJKWkRfhRdMj2KNcXHEHubsw5Utpg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(52536014)(9686003)(66556008)(186003)(26005)(66476007)(64756008)(71200400001)(38070700005)(76116006)(66946007)(82960400001)(6506007)(66446008)(8676002)(7696005)(83380400001)(8936002)(86362001)(316002)(33656002)(54906003)(110136005)(508600001)(4326008)(2906002)(55016003)(122000001)(5660300002)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y3Vua0ZZdDFUNEpkN3phMjY3TmhLSjMvOEZYZjRVNm45b0gxZ1hQbEhISTQy?=
 =?utf-8?B?ZWtUMm9NSWdEZk9MTXVsbzJETzZENHgyNGlWTVQ0d0twS1lzS3ZIdUt4VWtS?=
 =?utf-8?B?MzBhTVVvZlZXYzhubEJ6S1dKQU1rMlJHWlFHcHVPSmowNTYyOTBVeDNYQ3gv?=
 =?utf-8?B?bkMzU2hUOWJHOW1mMGtOOERQT1RYSHVWOHJza05Yd2JwRUt1a3JDUlFRU1JU?=
 =?utf-8?B?dS9YczJMbFA5K2xOMXhNNnNSREx0MVU3dXEybW1qQWNyYUw0WGl3Zmd2a0sv?=
 =?utf-8?B?eEorWkg5c2ttRjR1ZUh5SlZNQW9WTjZrUjdmNmJPbXQ3REZrT3NrNXFaR2V1?=
 =?utf-8?B?QmpaV0tGbTgrZXBGOXErdUMrZkVVOFN4WDgxU0N2b0JZMDcySmRXZE02aEdB?=
 =?utf-8?B?YmdWbGE4V3g1bllRMTJGTFR5eTVhRjlzYVVHN1hXRFBLTXYrcnYyWENnaTcv?=
 =?utf-8?B?T2ZueWQvUUxZNG02OHhyVzA2UnlNYkRQU1VPdk5HQUllRXFUalQvTGJaMnlj?=
 =?utf-8?B?Tnc5M1N0bWJNR3k1cVhYZElFSWxUVjl5aDBjR2Z6bGNCcldEZlFFNEREYjg3?=
 =?utf-8?B?TExPaC93aVZEUzRvOEJ6ZTZxN0VjRmx0K3lWa0phVXlDc3BoZC9HU3p6NE82?=
 =?utf-8?B?UHR0UWVEN20va2h6NEJFcGd6UU5OZDFUSDlJUnRwdVVHR2lGWThOUFVydGZY?=
 =?utf-8?B?YW85ZEFGa0txbms2aEgxREhZNHltNTN3Y0Jad1hxSVRaNzR5azdTLytzdkdi?=
 =?utf-8?B?TjZRcnJYQmNkRnZUNytLUm5qWStXekpOekdjZjJ5VmNxWWFjalNuV1c3UU9F?=
 =?utf-8?B?aElacEE0Ni9aV0JZeWJJTUhSbU5TUVFhYnNxMEZqUXgrb0NUQ2VCMTN2cm9w?=
 =?utf-8?B?djVSaS9ZRnlJN21vanBlRTBabWN6elNRUUtUbktIY1ZHdU1IWlVwMURjTlRu?=
 =?utf-8?B?UUV4ditUeWhoYjlKWnNLMkdQcWg3Mi9VR0lCMFRWN2VzZDA0bzVRM3VmT2Y4?=
 =?utf-8?B?Zi9zTHRlanZLUHQxZVJyQXlXemFwRDg1ZEc2Q0RyeS9ESmd3eFhRR2JDMk5l?=
 =?utf-8?B?eFRLQ29POTE4djBBVFJHVkIzc1pmcGxYZFhUU29GMWVTbmxmS3grelo1c3V1?=
 =?utf-8?B?dzJlVzVKT0ROYXZ3WEJsV2U5ZTJmVFE4dFk1NGNldWVzemNpeFpRaW50aTZv?=
 =?utf-8?B?c2lPM3ViWWJhRVVuNllERGNQeXNMODFUejMzUFk0VEdMeC8xb3ZSZm92QU9m?=
 =?utf-8?B?UnFuSDV4dDhQNS96a0FuUDZvTG4ra0VBbGNMVWxKanhTV2VoaUJ1SWxpc2Nr?=
 =?utf-8?B?OHlBZWNuRTJ1T2hSbXRTSWhMOWtNaEcwb3k2RWMyMW9kOVdBRmdoZVZ0UTJI?=
 =?utf-8?B?SGZkZ0RXQy9kZWRRZ1htbjF2RTZuZ1NLMFlPSmp6NW8za0F3WGhHUDhINzd2?=
 =?utf-8?B?c3lDSndMamxud3FGT04zRmlCZW1WS2dxeUZEa3dIbTRid2FLaEJFSHFjN3RR?=
 =?utf-8?B?dTl2bmhZd21WdVU5ekthc0JDVW5iTzU0OWs1eFdqekdRKzdIMGhrOG1aaldp?=
 =?utf-8?B?cmFFeWRrNkpuMEJ4VUI1NVB2R2FQTDFSeTQ5bDJuOWJCM1o2WUcvT211aVY1?=
 =?utf-8?B?bnZGU1NjT0JzUmRKenBQZUFlc0VqdHhGMzRZbUpHV3lzVnZBNllhQ2xGZEtI?=
 =?utf-8?B?SlRSN3ZlMVQvbWFVbDV4NDBoLzI1Z1VqSXRxYk9mZDU1V1FsTWtINzFVWFRZ?=
 =?utf-8?B?VnNoU1ByaHVmc2x1R1htYW15U1RpVEpsVHptbUFPWFFMdUZBcURZUCtWN3F0?=
 =?utf-8?B?WDVwTWhhWkFlOC83ZVdsVG5WMDNXNDVXNE9RTHRkMlhKNTVpZjFxN1hZdVIx?=
 =?utf-8?B?akRjU0o4MjJnKzJiRFBZVU1iK250S08wOGtJUjlPTkhWanRvNGhzT044L2dP?=
 =?utf-8?B?NzQrMWQrMURidXBMT0hKemlWVjVGYkY2R1ZrOUlzQmcwNU5JaFdDdCttSnQ3?=
 =?utf-8?B?TkhOM05QUWVXNUd2SjdscElDVUV1d3U3VU9WMFZKRkJ2dzhFdC9SeUo3S0Jo?=
 =?utf-8?B?VG53N1VabEtCc3R6UlMzbEZKVkdYY0NrRDFhK3dTcGFOcWxmYXc4V1IzeVg4?=
 =?utf-8?B?cEg5cW93V2ZSQzdYSDVlNUVDejVwQmdXMTVXZ0hlMkwzcUxvZE9WWlFnMTJz?=
 =?utf-8?Q?LsnqzM8aUmjzZGBfTSMXH2I=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4405c15-5748-4676-4a18-08d9bec067ad
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Dec 2021 05:13:03.0620
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CcE1Jedts5i6iUER7XZVQVy1qwse1/Jkq6i6BILS9MNO3eSl04jUuU57gXQuHIV2fuid/Hw+b8BPKDQfGfGGLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3810
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBUaG9tYXMgR2xlaXhuZXIgPHRnbHhAbGludXRyb25peC5kZT4NCj4gU2VudDogVHVl
c2RheSwgRGVjZW1iZXIgMTQsIDIwMjEgMTA6NTAgQU0NCj4gDQo+IEtWTSByZXF1aXJlcyBhIGNs
ZWFyIHNlcGFyYXRpb24gb2YgaG9zdCB1c2VyIHNwYWNlIGFuZCBndWVzdCBwZXJtaXNzaW9ucw0K
PiBmb3IgZHluYW1pYyBYU1RBVEUgY29tcG9uZW50cy4NCj4gDQo+IEFkZCBhIGd1ZXN0IHBlcm1p
c3Npb25zIG1lbWJlciB0byBzdHJ1Y3QgZnB1IGFuZCBhIHNlcGFyYXRlIHNldCBvZiBwcmN0bCgp
DQo+IGFyZ3VtZW50czogQVJDSF9HRVRfWENPTVBfR1VFU1RfUEVSTSBhbmQNCj4gQVJDSF9SRVFf
WENPTVBfR1VFU1RfUEVSTS4NCj4gDQo+IFRoZSBzZW1hbnRpY3MgYXJlIGVxdWl2YWxlbnQgdG8g
dGhlIGhvc3QgdXNlciBzcGFjZSBwZXJtaXNzaW9uIGNvbnRyb2wNCj4gZXhjZXB0IGZvciB0aGUg
Zm9sbG93aW5nIGNvbnN0cmFpbnRzOg0KPiANCj4gICAxKSBQZXJtaXNzaW9ucyBoYXZlIHRvIGJl
IHJlcXVlc3RlZCBiZWZvcmUgdGhlIGZpcnN0IHZDUFUgaXMgY3JlYXRlZA0KPiANCj4gICAyKSBQ
ZXJtaXNzaW9ucyBhcmUgZnJvemVuIHdoZW4gdGhlIGZpcnN0IHZDUFUgaXMgY3JlYXRlZCB0byBl
bnN1cmUNCj4gICAgICBjb25zaXN0ZW5jeS4gQW55IGF0dGVtcHQgdG8gZXhwYW5kIHBlcm1pc3Np
b25zIHZpYSB0aGUgcHJjdGwoKSBhZnRlcg0KPiAgICAgIHRoYXQgcG9pbnQgaXMgcmVqZWN0ZWQu
DQoNCkEgY3VyaW9zaXR5IHF1ZXN0aW9uLiBEbyB3ZSBhbGxvdyB0aGUgdXNlciB0byByZWR1Y2Ug
cGVybWlzc2lvbnM/DQoNCj4gQEAgLTQ3Nyw2ICs0NzksMTMgQEAgc3RydWN0IGZwdSB7DQo+ICAJ
c3RydWN0IGZwdV9zdGF0ZV9wZXJtCQlwZXJtOw0KPiANCj4gIAkvKg0KPiArCSAqIEBndWVzdF9w
ZXJtOg0KPiArCSAqDQo+ICsJICogUGVybWlzc2lvbiByZWxhdGVkIGluZm9ybWF0aW9uIGZvciBn
dWVzdCBwc2V1ZG8gRlBVcw0KPiArCSAqLw0KDQp3aHkgY2FsbGluZyBpdCAncHNldWRvJz8gSXQn
cyByZWFsIEZQVSBzdGF0ZSBtYW5hZ2VkIGJ5IHRoaXMgc2VyaWVzLi4uDQoNCj4gQEAgLTE3NDIs
NiArMTc1MSw3IEBAIGxvbmcgZnB1X3hzdGF0ZV9wcmN0bChzdHJ1Y3QgdGFza19zdHJ1Y3QNCj4g
IAl1NjQgX191c2VyICp1cHRyID0gKHU2NCBfX3VzZXIgKilhcmcyOw0KPiAgCXU2NCBwZXJtaXR0
ZWQsIHN1cHBvcnRlZDsNCj4gIAl1bnNpZ25lZCBsb25nIGlkeCA9IGFyZzI7DQo+ICsJYm9vbCBn
dWVzdCA9IGZhbHNlOw0KPiANCj4gIAlpZiAodHNrICE9IGN1cnJlbnQpDQo+ICAJCXJldHVybiAt
RVBFUk07DQo+IEBAIC0xNzYwLDExICsxNzcwLDIwIEBAIGxvbmcgZnB1X3hzdGF0ZV9wcmN0bChz
dHJ1Y3QgdGFza19zdHJ1Y3QNCj4gIAkJcGVybWl0dGVkICY9IFhGRUFUVVJFX01BU0tfVVNFUl9T
VVBQT1JURUQ7DQo+ICAJCXJldHVybiBwdXRfdXNlcihwZXJtaXR0ZWQsIHVwdHIpOw0KPiANCj4g
KwljYXNlIEFSQ0hfR0VUX1hDT01QX0dVRVNUX1BFUk06DQo+ICsJCXBlcm1pdHRlZCA9IHhzdGF0
ZV9nZXRfZ3Vlc3RfZ3JvdXBfcGVybSgpOw0KPiArCQlwZXJtaXR0ZWQgJj0gWEZFQVRVUkVfTUFT
S19VU0VSX1NVUFBPUlRFRDsNCj4gKwkJcmV0dXJuIHB1dF91c2VyKHBlcm1pdHRlZCwgdXB0cik7
DQoNClNpbWlsYXJseSBhcyBkb25lIGZvciBBUkNIX1JFUV9YQ09NUF9HVUVTVF9QRVJNOg0KDQor
CWNhc2UgQVJDSF9HRVRfWENPTVBfR1VFU1RfUEVSTToNCisJCWd1ZXN0ID0gdHJ1ZTsNCisJCWZh
bGx0aHJvdWdoOw0KKw0KCWNhc2UgQVJDSF9HRVRfWENPTVBfUEVSTToNCgkJLyoNCgkJICogTG9j
a2xlc3Mgc25hcHNob3QgYXMgaXQgY2FuIGFsc28gY2hhbmdlIHJpZ2h0IGFmdGVyIHRoZQ0KCQkg
KiBkcm9wcGluZyB0aGUgbG9jay4NCgkJICovDQotCQlwZXJtaXR0ZWQgPSB4c3RhdGVfZ2V0X2hv
c3RfZ3JvdXBfcGVybSgpOw0KKwkJcGVybWl0dGVkID0geHN0YXRlX2dldF9ncm91cF9wZXJtKGd1
ZXN0KTsNCgkJcGVybWl0dGVkICY9IFhGRUFUVVJFX01BU0tfVVNFUl9TVVBQT1JURUQ7DQoJCXJl
dHVybiBwdXRfdXNlcihwZXJtaXR0ZWQsIHVwdHIpOw0KDQpTbyB0aGUgY29tbWVudCBhYm91dCAn
bG9ja2xlc3MnIGlzIHNoYXJlZCBieSBib3RoLg0KDQo+ICsNCj4gKwljYXNlIEFSQ0hfUkVRX1hD
T01QX0dVRVNUX1BFUk06DQo+ICsJCWd1ZXN0ID0gdHJ1ZTsNCj4gKwkJZmFsbHRocm91Z2g7DQo+
ICsNCj4gIAljYXNlIEFSQ0hfUkVRX1hDT01QX1BFUk06DQo+ICAJCWlmICghSVNfRU5BQkxFRChD
T05GSUdfWDg2XzY0KSkNCj4gIAkJCXJldHVybiAtRU9QTk9UU1VQUDsNCj4gDQo+IC0JCXJldHVy
biB4c3RhdGVfcmVxdWVzdF9wZXJtKGlkeCk7DQo+ICsJCXJldHVybiB4c3RhdGVfcmVxdWVzdF9w
ZXJtKGlkeCwgZ3Vlc3QpOw0KPiANCj4gIAlkZWZhdWx0Og0KPiAgCQlyZXR1cm4gLUVJTlZBTDsN
Cg0KVGhhbmtzDQpLZXZpbg0K
