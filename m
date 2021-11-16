Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEB5C453C24
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 23:13:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231934AbhKPWOu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 17:14:50 -0500
Received: from mga18.intel.com ([134.134.136.126]:46556 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230484AbhKPWOt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 17:14:49 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10170"; a="220722604"
X-IronPort-AV: E=Sophos;i="5.87,239,1631602800"; 
   d="scan'208";a="220722604"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2021 14:11:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,239,1631602800"; 
   d="scan'208";a="494658361"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga007.jf.intel.com with ESMTP; 16 Nov 2021 14:11:51 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 16 Nov 2021 14:11:51 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Tue, 16 Nov 2021 14:11:51 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.42) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Tue, 16 Nov 2021 14:11:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lh+RaLDWNKP9zhZRcLzUhD7ruXF+XlxN3iaFtCiozfKscDvfIq5PyBWJVnRolFAMS8xNNK4BrLmEVGhxz0GxsZtyIF6BTkxt6WG9xNXNz//Rz0kFZ/7CnmxBK/y+Vzcw+p11hX8daMpENdZanTjU0t/N4Uz+BOs7l44v2DRDYx2WFk/xARGXUk5X+LKoRQETWVOYMM7q7zYHWFY/1Hk7ZoCAzBDif4yxolUNP60G4Qn0OLgVKlky6oL2wnUybeN6NPkIOXC7qv0ctnL0FquIGlm9skWJG8lZXotpuKrm42bIAG7q15OuIPW17SDimujW4IXPksiW2auHJ2N8Dx+7iQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ej+APB4IReg5DI7Nh5hl77J87dhjriSaKMECd5iVEYg=;
 b=fHnssJ8QYBNOBcazQwN8umiHNOoR1N0POaFK5NWcovWAYoNDHhLyUzvHBD8o5PD7xNNIosAxKa1UEqzTpcJALCSsaUuvF4qYsVZuAWi5s+537O6fVw2VJkxcfId9HJ5XeveoD9PQhNvV1yjlte4uGo5EjcceMdq1Ygy+NQ+FtogfGZTs8PM9eSTicZkq0811otNx7qOjnaDbI8ovVvbp9sCTXvAQLY8JKqNdsce98sNT7Vd40pKA11WJzzfnO07R4OUDvs+eBUuX7ibXo80HlN3wo86akB7j0mTB/eo5l+dEZmJy3s3+2zdcf3bHIA/4FiPpcQ/liTkTd3bQH0MRJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ej+APB4IReg5DI7Nh5hl77J87dhjriSaKMECd5iVEYg=;
 b=Xgy5RkPt8sHa/5n8sAjkt3Zi6nBF/da1b583LyQPgzJrVA5XnjwzaV1r8zqxFJg7rxHj79Ewu5r/SQHWlNqqXzrMjKFB4jA+U4alLUkKPXzJJ4ZhusXE4S5xGTE+HmD7gT+QsaX9jQ2/P12q5jwirwJSGeeJwJGzpiNnFgz6lrE=
Received: from BY5PR11MB4435.namprd11.prod.outlook.com (2603:10b6:a03:1ce::30)
 by BY5PR11MB4418.namprd11.prod.outlook.com (2603:10b6:a03:1cc::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.16; Tue, 16 Nov
 2021 22:11:50 +0000
Received: from BY5PR11MB4435.namprd11.prod.outlook.com
 ([fe80::348f:bbe0:8491:993]) by BY5PR11MB4435.namprd11.prod.outlook.com
 ([fe80::348f:bbe0:8491:993%5]) with mapi id 15.20.4690.027; Tue, 16 Nov 2021
 22:11:49 +0000
From:   "Nakajima, Jun" <jun.nakajima@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Jing Liu <jing2.liu@linux.intel.com>,
        "Cooper, Andrew" <andrew.cooper3@citrix.com>,
        "Bae, Chang Seok" <chang.seok.bae@intel.com>
Subject: Re: Thoughts of AMX KVM support based on latest kernel
Thread-Topic: Thoughts of AMX KVM support based on latest kernel
Thread-Index: AdfWMJGMz5/jeSLQRn+nYCX+7Qj8nwEs3NUAAAfspQAABfT8AAAB3lQAAAGjd4AAA1hfAA==
Date:   Tue, 16 Nov 2021 22:11:49 +0000
Message-ID: <44A8C7BB-5178-4AA7-A97F-68247B5167C9@intel.com>
References: <BYAPR11MB325685AB8E3DFD245846F854A9939@BYAPR11MB3256.namprd11.prod.outlook.com>
 <87k0h85m65.ffs@tglx> <YZPWsICdDTZ02UDu@google.com> <87ee7g53rp.ffs@tglx>
 <04978d6d-8e1a-404d-b30d-402a7569c1f0@redhat.com> <87zgq34z4c.ffs@tglx>
In-Reply-To: <87zgq34z4c.ffs@tglx>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.7)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dd42db09-c1b9-4d13-7a41-08d9a94e1677
x-ms-traffictypediagnostic: BY5PR11MB4418:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BY5PR11MB4418EB4ACA4F38CB921C5BE69A999@BY5PR11MB4418.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: st+rSJJ3MWc29CfseuF1bezud9Gt/atNxz3+PxjucbnV6oDKsaUfmWxRsUCwU2PG6uM+ssfUbn6cUhvTZPbUNyQmznU1MaC9pF1z7xt/t+y8dc/CJ1s4DquNZQ9j0TvjTfNIh6xV75mCdCqmznDuehxKMq9NqideKL87N3ti9cZtEbYWjdhJmy21YRt8IeHfX0Frm7SvlmdY0p4f1Jltyk6IbMFJO2+5SoeB7evbSGzSoKefbk9cf/NQj5/2cirrxXQ2yJg4f2FDxXL0SoYQufSU1IMg+q7X2OGVkPzpCNrxDcTQxQWmgd0X6cbCf3URdslrLnVjfs2GZVvRoXWjORo0x7wV3mnU+U8uysGwyU73u/g+3Zg1EXfj+EjoD62XmVehdmVh1iGUDMWEpFkcLSykyhsiSqFbA9cLldfxe3Ie2icZKLYK09mqFyOtwHs8m0QnGOD1IK8q7Sf0qV2dUEsUwM3XsTWMwMT2t/da0ylrFejrIjGoNuVTisTQtgSBV2Er9m2fC9BlWTjEpptCgQy2o321fvMkg4uSf2z/iTMQ3gsNE388kVlgDak1B3DaXD4t/O+1GiCSxv8o+6tfiGFnTI9uDAhsLMbKPrK9gGj1jCiCQ3OjmFdFQz6NN9vN/5lpqWm5M8eifpH7vTEL3v65312NykDkZvJIiYbgXlytL39mkY5tPrHY4BE3ojyyI6f3zY5bxaPpq401jVQxgsVqVH81/HeQCu/EJqCvYjg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4435.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(122000001)(508600001)(8676002)(26005)(6512007)(2906002)(4326008)(53546011)(6916009)(54906003)(316002)(6506007)(33656002)(64756008)(66556008)(66476007)(186003)(83380400001)(38070700005)(86362001)(6486002)(66946007)(66446008)(5660300002)(76116006)(82960400001)(2616005)(8936002)(36756003)(38100700002)(7416002)(71200400001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UENrZFB3cXRGdmRsd21uenJSbk94VWlaU1A4aHpub2k0bXkxN09JeTNXbEtH?=
 =?utf-8?B?dW84c0ZHd1lhYXF4WkIrS0hpRFFRODEwUUtWRHIxc1Y0QS9HM3ZzQS9McWZH?=
 =?utf-8?B?MnlSclM2aDBldkZONkYrQzNmZ1FEQmtKaDJ0MGhUNWxwczhWWUFSVVc1QnRh?=
 =?utf-8?B?T1NGM3ZCajhhdUx6dk1vSUZhVEtGYUtZLytZcEMrOWRudDBQSVhycUh4Um01?=
 =?utf-8?B?R0E0SC9lRnhMckFyRzB4RU5PcWxRaHIvVGlJY1pZY040d1FmVEJyTk9uVHVO?=
 =?utf-8?B?aUNVblJCb0V6ZlIyb2JzUHN3QkRPc0xRSWMvY1EwZlppT3hWNXZ1TWJ2cUFK?=
 =?utf-8?B?a1U5Z1hqM0pSQzdTZHRCNmNab3VIMzF5YnBDNG9LcEpCSUhuSFAyL0xnN1Z0?=
 =?utf-8?B?WllYU0hpRnNFS1QwbU1hTWFoSGc0cU5KVGttR2JzdXgrUHgwSDJiK29GUWp0?=
 =?utf-8?B?VFNhNWdXc0MySE0wcGprOEdCaHUyaWkrR0ZoOEwzZDNPQXV0RVpJMWtYRnZ4?=
 =?utf-8?B?c2FMUi9KakN5OXVndG9GcTBISkZacWdxQURzSG9wMzBnOUxaSm1yL2p2V1lo?=
 =?utf-8?B?QXhWUjFwUjRTalc5TFNJRHo0cG5SL0ZRajUwQlc4bk1SZzh0NGYvOXBFNkRx?=
 =?utf-8?B?aHJ5K2w0a29yWUF1ZFA5NEtDZEc2SC84M3QxR25HcjhYQjJTaHc3c1VEUTNt?=
 =?utf-8?B?YWwxU0lCdGZCL2FkYnBMOXVPY0hKd3dTdE9aUTRDS1lxNFpEQ2ZlWEpCQmV0?=
 =?utf-8?B?VklqOXBUVlBheFVFb0UvK3BTaHlNQjU2QWdPTU9ZV0I5Ulc0OHl2djhsWlJw?=
 =?utf-8?B?QVRRcmdhRVd5ZEVqNHhqem95N0ZQRU9nSnpubjE2THE4VnlaZE9aMndFdXM0?=
 =?utf-8?B?dHVMVUJkSHNIZWhETkROMmMvQXlmdTl6cHlPS2ozOGE0TkJUYTFFMFZQbmZz?=
 =?utf-8?B?OXBOWkZBMytpQm1kSEsrS29xT2h3Mko0S3Body9NWm5jOWJlaEJ2TzFzbGJK?=
 =?utf-8?B?MzdQZ3BxcXRKRDJZbnE2UWpMU1htNTRsNXQ2cThEVmhQZS9qZTFGSDZNL2Nk?=
 =?utf-8?B?aGY4UGc2Nm51NEFGakR0dDJMM3RYdWdYeFY2ZVBzdmdQREZMbEJUNlFYT09r?=
 =?utf-8?B?Z2RoeU1rQWRNaEdIWlczWklPc05rVDNHNDR5MUpTV21jTzR1ZTJoYzZHeDZI?=
 =?utf-8?B?SHZoekJITDBrMGVoOXdKbWkzcE52bm9lZHlXZEFqSlZjRmpMZ3RORUh0VFBJ?=
 =?utf-8?B?Rnk1ODZGR0ZXYU56bUNhVUpmYUFqQmZvSzd5eWlicWNFYWF4ZjJ2bmF1Zzhz?=
 =?utf-8?B?UzRMczdyZk9xamptcC9odnhzRHNlRFRIRGNEWFk5VjFwLytlck5qUGo3VXhG?=
 =?utf-8?B?T0lDL3BDbXlDS3pDOW5iZFBBUDJEREdSS1NXRVdUdWVsZEFzTUh3eTVzRnNM?=
 =?utf-8?B?OUhETWNETWw1ZW1nOVZmbjRHS1BPUG1ralhENlFXNXp5VUJYQU5SMmYzNkRR?=
 =?utf-8?B?YnlNMythb1ZabHUyYjliWTdCbGpxRFUvVUJwajdmVnlRTHVtUTlITmw5UmVL?=
 =?utf-8?B?dFVYdG1pQW9xTlZHWFhuelIwdUh6ditmZklIaUYzR3NrQ3d4YUh3T0xpL1JZ?=
 =?utf-8?B?NlNHUHlPZkkxTVRrTHVhdHZUZDlNaUg3YXQwNWYyRTJMbjFGbFhLaGJQSWZm?=
 =?utf-8?B?QWcvUWtNK04yTHBiNkFiaUwyck8xdS9JdnZvNFlvaWhkQnJWKzJjN1NmbVAr?=
 =?utf-8?B?TWxpVXUrVitFci9QMnV5citZSWdndXEvK2tZRUZpbnNWQXRWajhwQ3J3ZVd6?=
 =?utf-8?B?QU16bjBSK3R6NVFBMGVDTCthVUdNTDQzeUxTR1N1VURjT1ZyNjB4b3pXWGpF?=
 =?utf-8?B?c01rem40d0xERW85c2t2cHdKekc3aVZkbmF1NGtTODlrRXFBVzBOa2s0NFZ1?=
 =?utf-8?B?aXBRU2oxOEptZEZCZi9wZDNqL09ZUHJ4L2wwbkpKU003SSs2ZkUvYllXcnBX?=
 =?utf-8?B?SWxxOVBMdzFZdHRLOHpSeklZYVVJeEc3YVRCelNJNDVUWnRjUWdtVFpLY3U1?=
 =?utf-8?B?YzJMNU9vQjhnZXAvdTlWT1J0dFdzZDZFRHVxOWNVSWJzSWxtU1dBaFRJalpL?=
 =?utf-8?B?cEJKcXJJL0dDREx4S2VWazRmYUlsMmdLam9vRkl0NEYwdnllVVRBakpOSmEz?=
 =?utf-8?Q?22iWUseh+8fvDZe3EXaSl/I=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D0C2125ECBDC2548BD10F2A3B5365711@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4435.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd42db09-c1b9-4d13-7a41-08d9a94e1677
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Nov 2021 22:11:49.7868
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: J9TsIMY04WfluJGHWXParoU8oMHriOsG5gDe0yTvYgQcy1yeqmjsUWAwPHdKO8uWP7CudBj8kygWsRtDetrBFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4418
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiANCj4gT24gTm92IDE2LCAyMDIxLCBhdCAxMjozNiBQTSwgVGhvbWFzIEdsZWl4bmVyIDx0Z2x4
QGxpbnV0cm9uaXguZGU+IHdyb3RlOg0KPiANCj4gUGFvbG8sDQo+IA0KPiBPbiBUdWUsIE5vdiAx
NiAyMDIxIGF0IDIwOjQ5LCBQYW9sbyBCb256aW5pIHdyb3RlOg0KPj4gT24gMTEvMTYvMjEgMTk6
NTUsIFRob21hcyBHbGVpeG5lciB3cm90ZToNCj4+PiBXZSBjYW4gZG8gdGhhdCwgYnV0IEknbSB1
bmhhcHB5IGFib3V0IHRoaXMgY29uZGl0aW9uYWwgaW4gc2NoZWR1bGUoKS4gU28NCj4+PiBJIHdh
cyBhc2tpbmcgZm9yIGRvaW5nIGEgc2ltcGxlIEtWTSBvbmx5IHNvbHV0aW9uIGZpcnN0Og0KPj4+
IA0KPj4+IHZjcHVfcnVuKCkNCj4+PiAgICAgICAgIGt2bV9sb2FkX2d1ZXN0X2ZwdSgpDQo+Pj4g
ICAgICAgICAgICAgd3Jtc3JsKFhGRCwgZ3Vlc3RfZnBzdGF0ZS0+eGZkKTsNCj4+PiAgICAgICAg
ICAgICBYUlNUT1JTDQo+Pj4gDQo+Pj4gICAgICAgICBkbyB7DQo+Pj4gDQo+Pj4gICAgICAgICAg
ICBsb2NhbF9pcnFfZGlzYWJsZSgpOw0KPj4+IA0KPj4+ICAgICAgICAgICAgaWYgKHRlc3RfdGhy
ZWFkX2ZsYWcoVElGX05FRURfRlBVX0xPQUQpKQ0KPj4+IAkJc3dpdGNoX2ZwdV9yZXR1cm4oKQ0K
Pj4+ICAgICAgICAgICAgICAgICAgIHdybXNybChYRkQsIGd1ZXN0X2Zwc3RhdGUtPnhmZCk7DQo+
Pj4gDQo+Pj4gICAgICAgICAgICBkbyB7DQo+Pj4gICAgICAgICAgICAgICAgIHZtZW50ZXIoKTsg
ICAgICAgICAgICAgIC8vIEd1ZXN0IG1vZGlmaWVzIFhGRA0KPj4+ICAgICAgICAgICAgfSB3aGls
ZSAocmVlbnRlcik7DQo+Pj4gDQo+Pj4gICAgICAgICAgICB1cGRhdGVfeGZkX3N0YXRlKCk7ICAg
ICAgICAgIC8vIFJlc3RvcmUgY29uc2lzdGVuY3kNCj4+PiANCj4+PiAgICAgICAgICAgIGxvY2Fs
X2lycV9lbmFibGUoKTsNCj4+PiANCj4+PiBhbmQgY2hlY2sgaG93IGJhZCB0aGF0IGlzIGZvciBL
Vk0gaW4gdGVybXMgb2Ygb3ZlcmhlYWQgb24gQU1YIHN5c3RlbXMuDQo+PiANCj4+IEkgYWdyZWUs
IHRoaXMgaXMgaG93IHdlIGhhbmRsZSBTUEVDX0NUUkwgZm9yIGV4YW1wbGUgYW5kIGl0IGNhbiBi
ZSANCj4+IGV4dGVuZGVkIHRvIFhGRC4NCj4gDQo+IFNQRUNfQ1RSTCBpcyBkaWZmZXJlbnQgYmVj
YXVzZSBpdCdzIGRvbmUgcmlnaHQgYWZ0ZXIgZWFjaCBWTUVYSVQuDQo+IA0KPiBYRkQgY2FuIGJl
IGRvbmUgbGF6eSB3aGVuIGJyZWFraW5nIG91dCBvZiB0aGUgZXhpdCBmYXN0cGF0aCBsb29wIGJl
Zm9yZQ0KPiBlbmFibGluZyBpbnRlcnJ1cHRzLg0KDQpJIGFncmVlLiBUaGUgWEZEIGZlYXR1cmVz
IGFyZSBmb3IgdXNlci1zcGFjZS4NCg0KDQo+IA0KPj4gV2Ugc2hvdWxkIGZpcnN0IGRvIHRoYXQs
IHRoZW4gc3dpdGNoIHRvIHRoZSBNU1IgbGlzdHMuIA0KPj4gIEhhY2tpbmcgaW50byBzY2hlZHVs
ZSgpIHNob3VsZCByZWFsbHkgYmUgdGhlIGxhc3QgcmVzb3J0Lg0KPj4gDQo+Pj4gICAgICAgICAg
IGxvY2FsX2lycV9lbmFibGUoKTsgICAgIDwtIFByb2JsZW0gc3RhcnRzIGhlcmUNCj4+PiANCj4+
PiAgICAgICAgICAgcHJlZW1wdF9lbmFibGUoKTsJICAgPC0gQmVjb21lcyB3aWRlciBoZXJlDQo+
PiANCj4+IEl0IGRvZXNuJ3QgYmVjb21lIHRoYXQgbXVjaCB3aWRlciBiZWNhdXNlIHRoZXJlJ3Mg
YWx3YXlzIHByZWVtcHQgDQo+PiBub3RpZmllcnMuICBTbyBpZiBpdCdzIG9rYXkgdG8gc2F2ZSBY
RkQgaW4gdGhlIFhTQVZFUyB3cmFwcGVyIGFuZCBpbiANCj4+IGt2bV9hcmNoX3ZjcHVfcHV0KCks
IHRoYXQgbWlnaHQgYmUgYWxyZWFkeSByZW1vdmUgdGhlIG5lZWQgdG8gZG8gaXQgDQo+PiBzY2hl
ZHVsZSgpLg0KPiANCj4gRGlkIG5vdCB0aGluayBhYm91dCBwcmVlbXB0aW9uIG5vdGlmaWVycy4g
UHJvYmFibHkgYmVjYXVzZSBJIGhhdGUNCj4gbm90aWZpZXJzIHdpdGggYSBwYXNzaW9uIHNpbmNl
IEkgaGFkIHRvIGRlYWwgd2l0aCB0aGUgQ1BVIGhvdHBsdWcNCj4gbm90aWZpZXIgdHJhaW53cmVj
ay4NCj4gDQo+IEJ1dCB5ZXMgdGhhdCB3b3VsZCB3b3JrLiBTbyB0aGUgcGxhY2VzIHRvIGRvIHRo
YXQgd291bGQgYmU6DQo+IA0KPiAxKSBrdm1fc2NoZWRfb3V0KCkgLT4ga3ZtX2FyY2hfdmNwdV9w
dXQoKQ0KPiAyKSBrZXJuZWxfZnB1X2JlZ2luX21hc2soKQ0KPiAzKSBrdm1fcHV0X2d1ZXN0X2Zw
dSgpDQo+IA0KPiBCdXQgSSByZWFsbHkgd291bGQgc3RhcnQgd2l0aCB0aGUgdHJpdmlhbCB2ZXJz
aW9uIEkgc3VnZ2VzdGVkIGJlY2F1c2UNCj4gdGhhdCdzIGFscmVhZHkgaW4gdGhlIHNsb3cgcGF0
aCBhbmQgbm90IGF0IGV2ZXJ5IFZNRVhJVC4NCj4gDQo+IEknZCBiZSByZWFsbHkgc3VycHJpc2Vk
IGlmIHRoYXQgUkRNU1IgaXMgdHJ1bHkgbm90aWNlYWJsZSB3aXRoaW4gYWxsIHRoZQ0KPiBvdGhl
ciBjcnVkIHRoaXMgcGF0aCBpcyBkb2luZy4NCj4gDQoNCkkgYWxzbyBhZ3JlZSBoZXJlLCBhbmQg
d2XigJlsbCBtZWFzdXJlIHRoZSBlZmZlY3QgdG8gZG91YmxlLWNoZWNrLg0KDQpXZSBkb27igJl0
IHdhbnQgdG8gY29tcGxpY2F0ZSBvciBvcHRpbWl6ZSB0aGUgc3lzdGVtIGZvciB2ZXJ5IHJhcmUg
Y2FzZXMuDQpJIGxpa2UgeW91ciAidHJpdmlhbCB2ZXJzaW9uIiBiZWNhdXNlIGFsbCB0aGUgdGhp
bmdzIEtWTSBuZWVkcyB0byBkbyBpcyBqdXN0IHJlc3RvcmUgdGhlIGNvbnNpc3RlbnQgc3RhdGUu
DQoNCg0KLS0tIA0KSnVuDQoNCg0K
