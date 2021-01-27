Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F721305196
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 05:59:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238541AbhA0EZM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 23:25:12 -0500
Received: from mga09.intel.com ([134.134.136.24]:12608 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391985AbhA0BZn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 20:25:43 -0500
IronPort-SDR: eDH7166I4ZlBtl0Fpxp4PJWhxLLsBgMZw0D3+HUbS+c+vat5sZlj2qTmqgZjXVrGJuoNXWwa72
 YkFRpUfOxBag==
X-IronPort-AV: E=McAfee;i="6000,8403,9876"; a="180145384"
X-IronPort-AV: E=Sophos;i="5.79,378,1602572400"; 
   d="scan'208";a="180145384"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 17:23:43 -0800
IronPort-SDR: QLFfIcEoclOsTFKK+VquZ6hhgm5gyQc3zQKr/eYHp97+WUEgFBcNnO+kPqZCvV9J9ir7fVJB3H
 nSCoc8QOsI1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,378,1602572400"; 
   d="scan'208";a="353636984"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga003.jf.intel.com with ESMTP; 26 Jan 2021 17:23:43 -0800
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 26 Jan 2021 17:23:42 -0800
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 26 Jan 2021 17:23:42 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 26 Jan 2021 17:23:42 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Tue, 26 Jan 2021 17:23:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RcLO+TzsQ57KDbG2Ed9tHlYlQ8EB9BrryDBAn1G+dxenkJjZO7Ie/kaAPC6n9/uefEyvGo0pA/1Vh7pzUzWwdO23KHG5mr6TCPXvWqIPkXb3uEz09Md6VVCCBFnBF0Kc2RNrES0B3mt1obVnCjJxu2pf85F8yw7MVr/T+7zJhV9WkrjUg4f2qx2QmnbkH8NYnQVXKE71RmUYchutKjSU+RYNLf4daOoYNqojTMgzae23415udPyzmpflFFaNtEsEp5hn42VKM+BtyT8sO6odO7ypRPhAZqX3Nbw9oRcjvRxlz4JyGeOpYYdwcKydREfboRToDniCuH6M+S6HPrv7HQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jS6EZhRc3BB7mxHOllwFt1wmExfdEQGdUsbxAojYf0Y=;
 b=IbnrqNlgDJ5P5SCFMQoAR5CDVy4KSgWwU8xw86VT7FU+HGZ1zrhXAuCfvq7txBcwNQfXaabtgwB3C9GEkM3oTrMwmecHQBJ5+xNm32pPtQiucK4/rHsAM3uQhPt3nj5h5ZVXd+EoKKhosZQXctqrk3SrZXhRujI1tGOwIwjcw10CxAhaBi+mPcNMSCGJ5oh/lLUXxeTkC7EZhhNFuMLGffhXPzpkdr/pbvCdKKGp+Mnv6UX+5PVRygxDrWDBSd1JNQR63ziKYauY0vXgFS13NsrDUeDhfgH9fG8d5SX2a9lh4LCHkZJWvhsVDGhc6Hxqeg7Q4XAJPuPeWg/9nf6g1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jS6EZhRc3BB7mxHOllwFt1wmExfdEQGdUsbxAojYf0Y=;
 b=RayFOg9p0FXYwVmpsTl0w/Noy1Z40u9/IcBhBVuHnKiX24jd++IIr+/yRdGsIZkFU7MmKrTGTJdi9r4FUHiK2wmt5BzR57JEqY5hCvyJwfdZ9dX2rkETU0f2N3+yd0DWboESBd0+ZbEay32uQhIMbraI+HsZc8+vAs3p7rwV81c=
Received: from PH0PR11MB4855.namprd11.prod.outlook.com (2603:10b6:510:41::12)
 by PH0PR11MB4885.namprd11.prod.outlook.com (2603:10b6:510:35::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Wed, 27 Jan
 2021 01:23:35 +0000
Received: from PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::78e6:b455:ce90:fcb0]) by PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::78e6:b455:ce90:fcb0%6]) with mapi id 15.20.3784.019; Wed, 27 Jan 2021
 01:23:35 +0000
From:   "Bae, Chang Seok" <chang.seok.bae@intel.com>
To:     Borislav Petkov <bp@suse.de>
CC:     Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "Brown, Len" <len.brown@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 06/21] x86/fpu/xstate: Calculate and remember dynamic
 xstate buffer sizes
Thread-Topic: [PATCH v3 06/21] x86/fpu/xstate: Calculate and remember dynamic
 xstate buffer sizes
Thread-Index: AQHW2UTqFFigv51YEEOlWJDvbevvbqoztVkAgAcuLYA=
Date:   Wed, 27 Jan 2021 01:23:35 +0000
Message-ID: <6811FA0A-21A6-4519-82B8-C128C30127E0@intel.com>
References: <20201223155717.19556-1-chang.seok.bae@intel.com>
 <20201223155717.19556-7-chang.seok.bae@intel.com>
 <20210122114430.GB5123@zn.tnic>
In-Reply-To: <20210122114430.GB5123@zn.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=intel.com;
x-originating-ip: [73.189.248.82]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6083bd88-fe61-4a8d-8a12-08d8c2622b1b
x-ms-traffictypediagnostic: PH0PR11MB4885:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR11MB4885042EB280EF1FE29A1457D8BB9@PH0PR11MB4885.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eiZEPHR4QwrhHBih11YC53RLKLdlD/rpHZiqQiXee4M8Nrx1FzN1kst7/qtME30lHkYdMEB8aFTuGa2qv0o7/yas1DCs/RE32hg1uGLjuCNw03LsaghRRQwYtrQxFNpb1B1IFtl5bGmITkkX/aSprYLRHCcHxdz9n2L7Pl+M2dLrBMPercaT3k5GSr2hJg660CoBxVvP5QfSHMHolwFMTBmqRAYfHk/pIQwtC74UMxTO18a76CpAxbCcsTnGesOjN/WPoFWLGlC84UgWk/kzmcDA+43Nb+t+5NYSM/uMvyTa5pxHx9mP5I+uaHiGR6zKsojb9YYL4Y2y/ECBU5il0cZxYAYff59RW6cEvwDWca+xRpLvNR1Ys4DVCeXh/GAnsuK5ndF/3RsGDZjx3VLFA1yuDq/9eytx6VAvyVmcp9kJh1UZWpLj9Ng1M9grzblugR95e6Vclbzk/kDd/yLrR1Ce/EJIDhx3jqt+yoChkXnMS08oD5hrB9zV/kEd6iwaXxP0OUGJLzg4vfdIO/55K3QVZD4WZP6r08KO/ISjoNi+omV5NsVryBQDwbuJVyMlnANCvCnMlGJadIr6qqVg2uTljpS9SRNnln+jZDj3wNwDh2m6H7sqrneHmHHaAyuzttz7PIEUWNGMv8gssQkltPqBzz36mekGGr4GVAQtbYM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4855.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(396003)(366004)(136003)(186003)(91956017)(76116006)(2616005)(53546011)(33656002)(6506007)(2906002)(8676002)(66946007)(26005)(8936002)(36756003)(66476007)(64756008)(6486002)(66446008)(66556008)(6512007)(966005)(4326008)(478600001)(6916009)(5660300002)(71200400001)(86362001)(316002)(54906003)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?T3dQT3Z1emxrMEd1NVg5WFVXblpOOXk3dzVNcndMU2RDSEFWMDQ3cEhIRXdv?=
 =?utf-8?B?ci9kaHFWK2JjclZ1K2o4Zk80Y20rY0NGUnF6cFB3QlRLbE8xSzFiNnZ5WEJy?=
 =?utf-8?B?NjV5Qzk3Zk9QTEg4M1dWZ0UwMXlKQ3ZBNW9yRU1oRndyM0dBcVo5NEhMdXdM?=
 =?utf-8?B?cm1Wd1I0bkdGSmJGb3ZJcVAxeG5VN3g5aWdKTnA0UkNGVko5c2t5aEV0dFZJ?=
 =?utf-8?B?a1ZhM2xtcXZOUGlZM0E5OGdSVVJmWHEwVTd1bWIwVFY4R1hIeDZLOTVnNkhO?=
 =?utf-8?B?ZVlWVXNKUmRlemRZNTFMUHluVTZkZWxwell4RlJQQjV1T29GL1QzaWtmNE1S?=
 =?utf-8?B?OHRuVWUwakN2KzlGZnJ4cCtNY1B1RCtldjdFZENHQkozZjQ5QXhkVjlPUVdv?=
 =?utf-8?B?QVFNcUZNdzBkakpPSWFvZm93YXlzK3ZnRHhtR3AvTHgxd3ZtS01rTGFjVkY2?=
 =?utf-8?B?cDgza1NIWURiNTBiQUtvRFYxRkFPZW5DcXhJVUhSVnc4OU1vaDhmV2lsWVlL?=
 =?utf-8?B?Q3RROXdPRTJTSEh4dnZYZkxkSU9PSnBpSDJCTEwrVmZPODNySTlzZFo0a0J4?=
 =?utf-8?B?U1F5cnptNFRBZzFZdjVYZ1FjNEQ5dVJuYjY2OWhmK2pXSW1xbVVBNUw0RmFs?=
 =?utf-8?B?ZWFKd3lHZlVhVE0wWWlhZ0c0OENRNENBSm5vL1Z2bHVqd3lUTUJpWWtGWlRL?=
 =?utf-8?B?TVhyeHBSV0tlRThTTzV3bmp4Y09aWTYrZGhJbi9vMWxkbE1iMVRLaVV3Zmdn?=
 =?utf-8?B?ODdXSHh0WHpsUlFiZ2NOaGwxM2pjRks3TXlpVUppOWs3UW4wdU1Nd2owRzli?=
 =?utf-8?B?S1lydjI0VklKUzZ6VEFSUjdJcVdTWmI5R3FsL3Z3SlpmWDVjV0VEVEJXbktP?=
 =?utf-8?B?SEUyUGRrUzhYRnNOdmM2T0JvTGVYbEhSRU04SE9sVXJFZEx5TlFkd2dYSFps?=
 =?utf-8?B?VU9sRWRIWlU1OXVCUVppTGNtenY5ZkZPNXFuanhkNlFHYkdMWlFpajBwV2Jk?=
 =?utf-8?B?UkNwa1pxcXo4bm9saFdVd0NNY2lxKzlHb2xTaDVMMDV6TkMwRC80ZVJ6QjI3?=
 =?utf-8?B?S1NmSWVhMk95U2s5bnFKMm00K0RQTUY2ekJrZ2JlMnJ1NnRDSlEwRW93bEcv?=
 =?utf-8?B?djJONnBWOEV2OEY0QWFTQitxY21TaUxGVFJPQ0ZXNlhDcEhsUDZUK21lUjRX?=
 =?utf-8?B?cEVjWGRjNWNuWVQ1VE4vcTBsTHJrOUJ0QTRkTzZncWdQaWp1V29sNUg0TWZm?=
 =?utf-8?B?a0NtMFA2K3V5cjd6SGFwYS94WERURmlraEp0ZUF4bU14YzRLZ3BHWk16eTlQ?=
 =?utf-8?B?bEZjWjRLWnUvQVhycGRrN1JTSUFrTTN3eDRXL0dYdWpsa0JlaEZSN256MVZL?=
 =?utf-8?B?YzhJZDNtUHJRc1paNmVuWWlyNzdzbjJtNE1aYXpCMWZxK1F3ZmVKTGVWeGtx?=
 =?utf-8?B?Y3hrWmowR1h0UWJCVFJyOEQxYXdWSzdTZmVMWkZRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <303012E5B5C03A49A2F179A5FE5490F7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4855.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6083bd88-fe61-4a8d-8a12-08d8c2622b1b
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2021 01:23:35.6573
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PU+4bkK563R2QMkhaUTD260ervdCE8Ktgx8NjwbHxSO65syuGSbMPaxrtL7y+NKqE/5Ef8WjJGAgdNXsBBFlMOh9hmMFnWp5jb2TB9/eJMw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4885
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gSmFuIDIyLCAyMDIxLCBhdCAwMzo0NCwgQm9yaXNsYXYgUGV0a292IDxicEBzdXNlLmRlPiB3
cm90ZToNCj4gT24gV2VkLCBEZWMgMjMsIDIwMjAgYXQgMDc6NTc6MDJBTSAtMDgwMCwgQ2hhbmcg
Uy4gQmFlIHdyb3RlOg0KPj4gVGhlIHhzdGF0ZSBidWZmZXIgaXMgY3VycmVudGx5IGluLWxpbmUg
d2l0aCBzdGF0aWMgc2l6ZS4gVG8gYWNjb21tb2RhdGVhDQo+IA0KPiAiaW4tbGluZSIgZG9lc24n
dCBmaXQgaW4gdGhpcyBjb250ZXh0LCBlc3BlY2lhbGx5IHNpbmNlICJpbmxpbmUiDQo+IGlzIGEg
a2V5d29yZCB3aXRoIGFub3RoZXIgbWVhbmluZy4gUGxlYXNlIHJlcGxhY2UgaXQgd2l0aCBhIGJl
dHRlcg0KPiBmb3JtdWxhdGlvbiBpbiB0aGlzIHBhdGNoLg0KDQpIb3cgYWJvdXQg4oCYZW1iZWRk
ZWTigJk/LA0KICAgIOKAnFRoZSB4c3RhdGUgYnVmZmVyIGlzIGN1cnJlbnRseSBlbWJlZGRlZCBp
bnRvIHN0cnVjdCBmcHUgd2l0aCBzdGF0aWMgc2l6ZS4iDQoNCj4+IC1leHRlcm4gdW5zaWduZWQg
aW50IGZwdV9rZXJuZWxfeHN0YXRlX3NpemU7DQo+PiArZXh0ZXJuIHVuc2lnbmVkIGludCBmcHVf
a2VybmVsX3hzdGF0ZV9taW5fc2l6ZTsNCj4+ICtleHRlcm4gdW5zaWduZWQgaW50IGZwdV9rZXJu
ZWxfeHN0YXRlX21heF9zaXplOw0KPiANCj4gSXMgaXQgdGltZSB0byBncm91cCB0aGlzIGludG8g
YSBzdHJ1Y3Qgc28gdGhhdCBhbGwgdGhvc2Ugc2V0dGluZ3MgZ28NCj4gdG9nZXRoZXIgaW5zdGVh
ZCBpbiBzaW5nbGUgdmFyaWFibGVzPw0KPiANCj4gc3RydWN0IGZwdV94c3RhdGUgew0KPiAJdW5z
aWduZWQgaW50IG1pbl9zaXplLCBtYXhfc2l6ZTsNCj4gCXVuc2lnbmVkIGludCB1c2VyX3NpemU7
DQo+IAkuLi4NCj4gfTsNCj4gDQo+IGV0Yy4NCg0KPHNuaXA+DQoNCj4gQW5kIHNpbmNlIHdlJ3Jl
IHByb2JhYmx5IGdvaW5nIHRvIHN0YXJ0IHF1ZXJ5aW5nIGRpZmZlcmVudCBhc3BlY3RzIGFib3V0
DQo+IHRoZSBidWZmZXIsIGluc3RlYWQgb2YgZXhwb3J0aW5nIGFsbCBraW5kcyBvZiB2YXJpYWJs
ZXMgaW4gdGhlIGZ1dHVyZSwNCj4gbWF5YmUgdGhpcyBzaG91bGQgYmUgYSBzaW5nbGUgZXhwb3J0
ZWQgZnVuY3Rpb24gY2FsbGVkDQo+IA0KPiBnZXRfeHN0YXRlX2J1ZmZlcl9hdHRyKHR5cGVkZWYg
YnVmZmVyX2F0dHIpDQo+IA0KPiB3aGljaCBnaXZlcyB5b3Ugd2hhdCB5b3Ugd2FubmEga25vdyBh
Ym91dCBpdC4uLiBGb3IgZXhhbXBsZToNCj4gDQo+IGdldF94c3RhdGVfYnVmZmVyX2F0dHIoTUlO
X1NJWkUpOw0KPiBnZXRfeHN0YXRlX2J1ZmZlcl9hdHRyKE1BWF9TSVpFKTsNCj4gLi4uDQoNCk9r
YXkuIEkgd2lsbCBwcmVwYXJlIGEgc2VwYXJhdGUgY2xlYW51cCBwYXRjaCB0aGF0IGNhbiBiZSBh
cHBsaWVkIGF0IHRoZSBlbmQNCm9mIHRoZSBzZXJpZXMuIFdpbGwgcG9zdCB0aGUgY2hhbmdlIGlu
IHRoaXMgdGhyZWFkIGF0IGZpcnN0Lg0KDQo+PiAvKiBXaGl0ZWxpc3QgdGhlIEZQVSBzdGF0ZSBm
cm9tIHRoZSB0YXNrX3N0cnVjdCBmb3IgaGFyZGVuZWQgdXNlcmNvcHkuICovDQo+PiAtc3RhdGlj
IGlubGluZSB2b2lkIGFyY2hfdGhyZWFkX3N0cnVjdF93aGl0ZWxpc3QodW5zaWduZWQgbG9uZyAq
b2Zmc2V0LA0KPj4gLQkJCQkJCXVuc2lnbmVkIGxvbmcgKnNpemUpDQo+PiAtew0KPj4gLQkqb2Zm
c2V0ID0gb2Zmc2V0b2Yoc3RydWN0IHRocmVhZF9zdHJ1Y3QsIGZwdS5zdGF0ZSk7DQo+PiAtCSpz
aXplID0gZnB1X2tlcm5lbF94c3RhdGVfc2l6ZTsNCj4+IC19DQo+PiArZXh0ZXJuIHZvaWQgYXJj
aF90aHJlYWRfc3RydWN0X3doaXRlbGlzdCh1bnNpZ25lZCBsb25nICpvZmZzZXQsIHVuc2lnbmVk
IGxvbmcgKnNpemUpOw0KPiANCj4gV2hhdCdzIHRoYXQgbW92ZSBmb3I/DQoNCk9uZSBvZiBteSBk
cmFmdHMgaGFkIHNvbWUgaW50ZXJuYWwgaGVscGVyIHRvIGJlIGNhbGxlZCBpbiB0aGVyZS4gTm8g
cmVhc29uDQpwcmlvciB0byBhcHBseWluZyB0aGUgZ2V0X3hzdGF0ZV9idWZmZXJfYXR0cigpIGhl
bHBlci4gQnV0IHdpdGggaXQsIGJldHRlciB0bw0KbW92ZSB0aGlzIG91dCBvZiB0aGlzIGhlYWRl
ciBmaWxlIEkgdGhpbmsuDQoNCj4+IEBAIC02MjcsMTMgKzYyNywxOCBAQCBzdGF0aWMgdm9pZCBj
aGVja194c3RhdGVfYWdhaW5zdF9zdHJ1Y3QoaW50IG5yKQ0KPj4gICovDQo+IA0KPiA8LS0gVGhl
cmUncyBhIGNvbW1lbnQgb3ZlciB0aGlzIGZ1bmN0aW9uIHRoYXQgbWlnaHQgbmVlZCBhZGp1c3Rt
ZW50Lg0KDQpEbyB5b3UgbWVhbiBhbiBlbXB0eSBsaW5lPyAoSnVzdCB3YW50IHRvIGNsYXJpZnku
KQ0KDQo+PiBzdGF0aWMgdm9pZCBkb19leHRyYV94c3RhdGVfc2l6ZV9jaGVja3Modm9pZCkNCj4+
IHsNCg0KPHNuaXA+DQoNCj4+IAlpZiAoYm9vdF9jcHVfaGFzKFg4Nl9GRUFUVVJFX1hTQVZFUykp
DQo+IA0KPiB1c2luZ19jb21wYWN0ZWRfZm9ybWF0KCkNCj4gDQo+IEZQVSBjb2RlIG5lZWRzIHRv
IGFncmVlIG9uIG9uZSBoZWxwZXIgYW5kIG5vdCB1c2UgYm90aC4gOi1cDQoNCkFncmVlZC4gSSB3
aWxsIHByZXBhcmUgYSBwYXRjaC4gQXQgbGVhc3Qgd2lsbCBwb3N0IHRoZSBkaWZmIGhlcmUuDQoN
CjxzbmlwPg0KDQo+PiArCS8qIEVuc3VyZSB3ZSBoYXZlIHRoZSBzdXBwb3J0ZWQgaW4tbGluZSBz
cGFjZTogKi8NCj4gDQo+IFdobydzICJ3ZSI/DQoNCkhvdyBhYm91dDoNCiAgICDigJxFbnN1cmUg
dGhlIHNpemUgZml0cyBpbiB0aGUgc3RhdGljYWxseS1hbGxvY2F0ZWQgYnVmZmVyOiINCg0KPj4g
KwlpZiAoIWlzX3N1cHBvcnRlZF94c3RhdGVfc2l6ZShmcHVfa2VybmVsX3hzdGF0ZV9taW5fc2l6
ZSkpDQo+PiArCQlyZXR1cm4gLUVJTlZBTDsNCg0KTm8gZXhjdXNlLCBqdXN0IHBvaW50aW5nIG91
dCB0aGUgdXBzdHJlYW0gY29kZSBoYXMg4oCcd2XigJ0gdGhlcmUgWzFdLg0KDQpUaGFua3MsDQpD
aGFuZw0KDQpbMV0gaHR0cHM6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9n
aXQvdG9ydmFsZHMvbGludXguZ2l0L3RyZWUvYXJjaC94ODYva2VybmVsL2ZwdS94c3RhdGUuYyNu
NzUyDQoNCg==
