Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C09F660A01
	for <lists+kvm@lfdr.de>; Sat,  7 Jan 2023 00:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbjAFXAX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 18:00:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbjAFXAU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 18:00:20 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 941AE392C8;
        Fri,  6 Jan 2023 15:00:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673046018; x=1704582018;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Or504SgHh5zAT7d6q6ymHqeN0vwbRk+dniK+N2pt98E=;
  b=Pfhpn3oFEkPIo6C0h8a+Twf6vZ+LJQbQ5lO3h0KHWrrlQMtA6U89AeWO
   dxaReELU3gLZuQCzCuL/A4rHu7arKOF75Wjx0ts4GKfTJjOWaSCIjAJ0K
   uvTAmXtkLhsUX1iE23uKqmy93Ew4Jh0VDXMd63ATfsFCTzq/kP8cZxY/m
   C59hTHzgvnM4TlsuuSUHIqumBpOLTdx0ux02Qv0JBFGp3XYEco6FCGwxI
   vqYDlGhP2DU0mneIunpul6V5O7XRffMZc1FXIC6w9kDKdu2h2VxE3B4l3
   sUFJQunHRPdxxkNaKbOxL4Aom9DgMCyNzcUemSvMeKdfLdeSbxJwIXYRo
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="324595971"
X-IronPort-AV: E=Sophos;i="5.96,306,1665471600"; 
   d="scan'208";a="324595971"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 15:00:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="780119595"
X-IronPort-AV: E=Sophos;i="5.96,306,1665471600"; 
   d="scan'208";a="780119595"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga004.jf.intel.com with ESMTP; 06 Jan 2023 15:00:17 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 6 Jan 2023 15:00:16 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 6 Jan 2023 15:00:16 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.173)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 6 Jan 2023 15:00:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l6NA3wRXzGTAcEQI39DPm8iYCF9AetXrvZcvcmOfOg1i5QKL5x3lvCky3eaBONz2yhXlHjxI0iyRnmecSy4DY+Ql2NO3MuPU9rT47gQkWRCAwwfrbKxCGEC6VtEEGcGkPpHATMOHQwG2VUhkJaI9l8uQZqlQKH/V+PXO16eBuvcwm0K+aBGmbtwLfKs/rnd+MTxBOtvN2bTG5wLqVb7xihTaX/qV3zZrB9WiyK4oGZDmAcCkJHCtszhR7vzDyEjgVu2kVwYJ5J+rAFn2RxOJrE/IcDfQ9JECOFfphq+5wj2G0U8QDKpqUmol41lfVoV3MuCOyNWlxNqf1bbFdsyysg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Or504SgHh5zAT7d6q6ymHqeN0vwbRk+dniK+N2pt98E=;
 b=Wj5WwYZVuerW/pUVs5lY+/8ZIZAcyyAAvBLkaDfBboWtZINhafqBmpboCQa8TRb+TWKCwAl1oGycZi1n1m0V2FqYgXER5nqpCzrXxholdasE4hCCEUCjLuAa5WjQXFD7wNA6vcbC6uNLt0ti0lBdvfAqjtZchyauub017PeDscmfpyXGXhkc1YLIg/Prh9OiCUs7hkBnHrZthOgtO7GyB0/ccVzBz6sP+iUkTN5pj7f418ERW6s31vIpdRNFkS7SkWSRLTd6sJ91rCB7p8YiKKfk3ljKBux9GtIvV5tLcxoZyDLfKt1dpKd6vebOjBqicXoqBRdsT3i4sb5nPh4Kmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by PH8PR11MB6925.namprd11.prod.outlook.com (2603:10b6:510:227::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Fri, 6 Jan
 2023 23:00:14 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::4577:b24b:a776:ee39]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::4577:b24b:a776:ee39%5]) with mapi id 15.20.5944.019; Fri, 6 Jan 2023
 23:00:14 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>
Subject: RE: [RFC PATCH v2 32/32] x86/fred: disable FRED by default in its
 early stage
Thread-Topic: [RFC PATCH v2 32/32] x86/fred: disable FRED by default in its
 early stage
Thread-Index: AQHZIbCFmhzklFbmSEWJ2UXNHqTFDq6R51GAgAAaaJA=
Date:   Fri, 6 Jan 2023 23:00:14 +0000
Message-ID: <SA1PR11MB673442AED398A6BDCD50C700A8FB9@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20230106085617.17248-1-xin3.li@intel.com>
 <20230106085617.17248-33-xin3.li@intel.com>
 <46772FCB-7313-47E9-ADCD-8BD556E8F265@zytor.com>
In-Reply-To: <46772FCB-7313-47E9-ADCD-8BD556E8F265@zytor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|PH8PR11MB6925:EE_
x-ms-office365-filtering-correlation-id: 71a43e90-0eeb-4aae-32b4-08daf039c592
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Bmb2+zzI5CGItoxz7UOnk/wOukJqFWWkpmAadT4Y5FwNmTJxeyGFyUD8tugNndwptBZz1nEsynscWvFZLZ7m7MfZZ7DJnR9Sja8Zct3ykBJxD9zMYTmzaF0jP1IbhA0bzgmSmWo6CxQacHWBiQnL9/Dk9fRKEXXKjMWTzBhjzWGeuKJRHWKBv4k4oO1m5pKYMYSMhqa+vHDF7pehpIVOECahUzFNe/blJ0QG7t2h8SC9Km0SrbtYq0U4TmTiLzJPpE8ljGvH0A5mhwD5Q79kutKksJonx9XSpRc+fnIaPtB60sZqBYe4XxAK1M5gKr/j1jGpys7h8pFKy6YkY+o5vzhXUqxATN2QrqaMVWMR/pKzzBTWKiH+0hEllBcvoImmSdC8rmIlKSDitIhZINAxduQOJymDN1qDbLlwky8Vn4N6pk6fL+ptCZRYN7rAfhHpYl6FFfFuivEbBS+0lgs3ciIHIA4AowNVfevCfzPFAZV6HJmkaSxvDLZoAIJUQy1WZIym/T0hVdPyXxzxbzQcAy4cPSJ2p/F/iDB0OiajyuVHcyWzKAfO8Uermyf6wQJiWKnqKFy5VQdEEDustIujvMZBakELC4wV4weY3MhRQ4oKpHb3aRbbqyboOgONmWI2Bu20ncmP9Nb5g5dccg2rA8euvHAIv78FmbTwoFO5iQXoVvY2N0+ZMTLZcjCj167xQlOrZlJUWhNrGRA12Gl9PQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(346002)(366004)(376002)(136003)(451199015)(7416002)(54906003)(86362001)(41300700001)(8936002)(83380400001)(82960400001)(52536014)(38100700002)(122000001)(2906002)(38070700005)(5660300002)(7696005)(9686003)(64756008)(66476007)(4326008)(26005)(316002)(186003)(55016003)(8676002)(66446008)(478600001)(66556008)(6506007)(71200400001)(110136005)(66946007)(76116006)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aFNONXpNQWQ1dGw1b0IvbXdaRWYrVTRYZW1GYUh4QlBuQ2hsYkRIUDkycDhj?=
 =?utf-8?B?dVRDUXlpMlZGNG0yR3pmREk5TzUxT050RldZclU5VHduaTJsalo1c3U5SG50?=
 =?utf-8?B?QXVBYzJ2UVhKa0FaUFpzNzBsV24yTFpNYVdhTFhENVVPZDlWUTVmY2pvU2VL?=
 =?utf-8?B?cnhKSFFWYU9rVzIvYndhRlBCZzVYeDNETUlMcFdGR3YwZlpZdXVNeEQ1TDRy?=
 =?utf-8?B?aE5yVEJrd3YvenYrNXcycjN1ZVhqWGRvOUxqWkhiT0dNMWpxOGE1K0p2Ry8r?=
 =?utf-8?B?MERuN1NYUkhsR1FHK1lyUm5FSy9TTjZjYXpTcFJrNXNhTEFxWjA0bWZubG8w?=
 =?utf-8?B?cnoxSFBJeUZ6T1NXUTg3QUhVdjF3ZWc0d1lPRTN1akdlbUI0alpmNjZrUzVN?=
 =?utf-8?B?V28rczhaMjdXb0Rxb2dLMWZvaFhLU2VDbjFsQVRrRHFacExRRlNmeWpObmpH?=
 =?utf-8?B?c3pldVg3ZmF0YkdxNmFVWGJ2Q3V1TjBEc04zWUZRZmo1ZngwQVBEb0ZBMHND?=
 =?utf-8?B?dnhjSGYwcmhjVWcvTW1uTHZjMDd0WnZ0OXlVODZ0cFFPZnBISXp0WjZ0ZW93?=
 =?utf-8?B?S2RreGU2eFpTTHhONWVma3VPZUIyTmxoOWpYQ3paNDhwTzZySGZvUDRKSHU0?=
 =?utf-8?B?YnBsNXpZUjFSUTUwdGRVRUdJMG1LVEZGZ05qVFRqRXFlaEowRFN3THFWY2xV?=
 =?utf-8?B?NWZMYUVJdm9XM2hRUWxpd2xjTkh4VUFkSFV2VDNvQnBBMlFiRUgwMXkzTjFI?=
 =?utf-8?B?TzdaS0pLQ3U2L3FPemFMei9odVRrc1M0Z01OV29zbk9mVDZOY1RsT010cUxR?=
 =?utf-8?B?M0tPelV6enVuK0NjRWFXMnppa2dXSnVReU8rOHRWeXBraVFUNXNuRlV2RnBW?=
 =?utf-8?B?d2d4RUUxeXZFeGVmeDVsWURVblI0dHBmT0FZdTZBeUhScU9INldJYkJVemhV?=
 =?utf-8?B?KzcwODc4YVlZcnlBbHZEV3FQbzJiVWZaVm1jYzg2bXNSVjliN2tGMUZGZHBs?=
 =?utf-8?B?VThUZ0k4MC9xYXkxdTFqMEVlOGRnV1F4NE5CUEJ6VWVxRGlXSFRYeUEydzZk?=
 =?utf-8?B?NXBRZzFtUTc5YU1NQzN3amdGYlV2V0QrODk5OXhicXB1US9UenBsQTNRcUtN?=
 =?utf-8?B?YmpzVys5cG9DZ2RFaHN2eXNVREE1SHFVV1dkR1FaRFVFL1JTcWUreEtIdjRP?=
 =?utf-8?B?d1lrZnhsWitHbTdSdFJ5TFdQTVZsc01zSy9SKzM4Vm8zVmh1MEd4M2FkUGpJ?=
 =?utf-8?B?a1Z6ZHc2SVVFWURUbGVEaDE3WERnemI3SDB5K1FlMzF5a24zd1Fvd1lTSFVS?=
 =?utf-8?B?b2h3b2kwTGdHdUhzNERtd3I1TzNOQnJzNjNjeDVjL0EvRzR0dlo0bkhiak5o?=
 =?utf-8?B?YmhJbFdlaHZKdWtHOXgvNEFjbFZYYk1SK2FoYlIwVFhSNkhNaEE0eGdjaVMv?=
 =?utf-8?B?aWcyejJxOTI1RE4rZWlkOVJReXQ3K2JWUmJsN2dOaTR5YkdzSWg1RUhFRHdh?=
 =?utf-8?B?SStoVFBoVkRobllwbDAzdjJoM1hqdnptQzRKQU9zaXU3eFZZYWtqcWJTNUtP?=
 =?utf-8?B?Y2tXYmRjbmJweWhNdjhzdTZ2V0E5Wm5Gcmg0VFlmOWM2RER0MlBXN2lBdlBN?=
 =?utf-8?B?Q2tDT0greG1RdDU2WE9IWm5zZjBJU0FNMWZnUU1QRk9rTXlDRDVwMkl4UUox?=
 =?utf-8?B?MURqamhhMmU3NWlKVExLM1RwSWI2QmwrUDhpSU1NWkZ5b0ZaNTdFbFRvSGlw?=
 =?utf-8?B?N0hWd1M3eHI0aEFEM1ZDTXZvUVdQSkdISFlBaVp3OWh2aUllajRvSnljMDVJ?=
 =?utf-8?B?Tm1IZVZjU05lWFdqdWFsZWhMcCt3TWo0M1FqMy9ySExTeDArbVBCL3lTbmto?=
 =?utf-8?B?OUJ6czFQMWRScGwzdS9scy80L1dDUkNLVTdyYXMva0hPcnlGZ0dxZytFdURv?=
 =?utf-8?B?M3I3VnRBQWF3VjF6VHVUR3FWSjQyNnZOUnVvbUs3NVNWc0JQemdaUll4VGk5?=
 =?utf-8?B?TkxlVDZMb2RTbHJqeWowaGRoRmJWRGJVOWhjYU9nVDdUelA3OU05R3JzMmZL?=
 =?utf-8?B?VWZmalE0dU83TFVld1YxZC81anJyNFZaNUIyL0l4bmpuM3JBQjJZWTcyejVy?=
 =?utf-8?Q?em2Vr3q4WJCNRMRm21J+tsh/c?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71a43e90-0eeb-4aae-32b4-08daf039c592
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jan 2023 23:00:14.4372
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XNJbqYbiyHYHB0k19TT/8FcogGYamP6nRo9z/fTHW79E/bYBD1YF+A4l6jL8/oNFeZ/cCcGu8yEYcrO5ADwsMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6925
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiA+RGlzYWJsZSBGUkVEIGJ5IGRlZmF1bHQgaW4gaXRzIGVhcmx5IHN0YWdlLg0KPiA+DQo+ID5U
byBlbmFibGUgRlJFRCwgYSBuZXcga2VybmVsIGNvbW1hbmQgbGluZSBvcHRpb24gImZyZWQiIG5l
ZWRzIHRvIGJlIGFkZGVkLg0KPiA+DQo+ID5TaWduZWQtb2ZmLWJ5OiBYaW4gTGkgPHhpbjMubGlA
aW50ZWwuY29tPg0KPiA+LS0tDQo+ID4gRG9jdW1lbnRhdGlvbi9hZG1pbi1ndWlkZS9rZXJuZWwt
cGFyYW1ldGVycy50eHQgfCA0ICsrKysNCj4gPiBhcmNoL3g4Ni9rZXJuZWwvY3B1L2NvbW1vbi5j
ICAgICAgICAgICAgICAgICAgICB8IDMgKysrDQo+ID4gMiBmaWxlcyBjaGFuZ2VkLCA3IGluc2Vy
dGlvbnMoKykNCj4gPg0KPiA+ZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24vYWRtaW4tZ3VpZGUv
a2VybmVsLXBhcmFtZXRlcnMudHh0DQo+ID5iL0RvY3VtZW50YXRpb24vYWRtaW4tZ3VpZGUva2Vy
bmVsLXBhcmFtZXRlcnMudHh0DQo+ID5pbmRleCA0MmFmOWNhMDEyN2UuLjBiYzc2ZDkyNmRkNCAx
MDA2NDQNCj4gPi0tLSBhL0RvY3VtZW50YXRpb24vYWRtaW4tZ3VpZGUva2VybmVsLXBhcmFtZXRl
cnMudHh0DQo+ID4rKysgYi9Eb2N1bWVudGF0aW9uL2FkbWluLWd1aWRlL2tlcm5lbC1wYXJhbWV0
ZXJzLnR4dA0KPiA+QEAgLTE1MDYsNiArMTUwNiwxMCBAQA0KPiA+IAkJCVdhcm5pbmc6IHVzZSBv
ZiB0aGlzIHBhcmFtZXRlciB3aWxsIHRhaW50IHRoZSBrZXJuZWwNCj4gPiAJCQlhbmQgbWF5IGNh
dXNlIHVua25vd24gcHJvYmxlbXMuDQo+ID4NCj4gPisJZnJlZA0KPiA+KwkJCUZvcmNlZnVsbHkg
ZW5hYmxlIGZsZXhpYmxlIHJldHVybiBhbmQgZXZlbnQgZGVsaXZlcnksDQo+ID4rCQkJd2hpY2gg
aXMgb3RoZXJ3aXNlIGRpc2FibGVkIGJ5IGRlZmF1bHQuDQo+ID4rDQo+ID4gCWZ0cmFjZT1bdHJh
Y2VyXQ0KPiA+IAkJCVtGVFJBQ0VdIHdpbGwgc2V0IGFuZCBzdGFydCB0aGUgc3BlY2lmaWVkIHRy
YWNlcg0KPiA+IAkJCWFzIGVhcmx5IGFzIHBvc3NpYmxlIGluIG9yZGVyIHRvIGZhY2lsaXRhdGUg
ZWFybHkgZGlmZiAtLWdpdA0KPiA+YS9hcmNoL3g4Ni9rZXJuZWwvY3B1L2NvbW1vbi5jIGIvYXJj
aC94ODYva2VybmVsL2NwdS9jb21tb24uYyBpbmRleA0KPiA+NWRlNjgzNTZmZTYyLi4xYTE2MDMz
N2FkNDEgMTAwNjQ0DQo+ID4tLS0gYS9hcmNoL3g4Ni9rZXJuZWwvY3B1L2NvbW1vbi5jDQo+ID4r
KysgYi9hcmNoL3g4Ni9rZXJuZWwvY3B1L2NvbW1vbi5jDQo+ID5AQCAtMTQzNCw2ICsxNDM0LDkg
QEAgc3RhdGljIHZvaWQgX19pbml0IGNwdV9wYXJzZV9lYXJseV9wYXJhbSh2b2lkKQ0KPiA+IAlj
aGFyICphcmdwdHIgPSBhcmcsICpvcHQ7DQo+ID4gCWludCBhcmdsZW4sIHRhaW50ID0gMDsNCj4g
Pg0KPiA+KwlpZiAoIWNtZGxpbmVfZmluZF9vcHRpb25fYm9vbChib290X2NvbW1hbmRfbGluZSwg
ImZyZWQiKSkNCj4gPisJCXNldHVwX2NsZWFyX2NwdV9jYXAoWDg2X0ZFQVRVUkVfRlJFRCk7DQo+
ID4rDQo+ID4gI2lmZGVmIENPTkZJR19YODZfMzINCj4gPiAJaWYgKGNtZGxpbmVfZmluZF9vcHRp
b25fYm9vbChib290X2NvbW1hbmRfbGluZSwgIm5vMzg3IikpICNpZmRlZg0KPiA+IENPTkZJR19N
QVRIX0VNVUxBVElPTg0KPiANCj4gU3BlY2lmaWNhbGx5LCB0aGUgaW50ZW50IGlzIHRvIGVuYWJs
ZSBpdCBieSBkZWZhdWx0IG9uY2UgaGFyZHdhcmUgaXMgd2lkZWx5IGF2YWlsYWJsZS4NCj4gVGhp
cyBhbGxvd3MgZS5nLiBkaXN0cm9zIHRvIGNvbXBpbGUgaW4gdGhlIHN1cHBvcnQgZm9yIG9wdC1p
biBmaWVsZCB0ZXN0aW5nIGJlZm9yZQ0KPiB0aHJvd2luZyB0aGUgc3dpdGNoLg0KPiANCj4gVGhl
IG1vdGl2YXRpb24gZm9yIHRoaXMgY29tZXMgZnJvbSB0aGUgU01BUCBleHBlcmllbmNlIHdoZXJl
IHRoZSBjb2RlIHdhcw0KPiBmdW5jdGlvbmFsIGFuZCBjb3JyZWN0IHdoZW4gbWVyZ2VkLCBidXQg
YSBjaGFuZ2UgZWxzZXdoZXJlIGluIHRoZSBrZXJuZWwgY29kZQ0KPiBiYXNlIGJyb2tlIGl0IGR1
cmluZyB0aGUgaW50ZXJ2ZW5pbmcgcGVyaW9kLg0KDQpUaGFua3MgZm9yIHRoZSBjbGFyaWZpY2F0
aW9uLg0K
