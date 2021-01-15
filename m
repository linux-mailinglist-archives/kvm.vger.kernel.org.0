Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B70F42F71DD
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 06:01:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726268AbhAOFAz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 00:00:55 -0500
Received: from mga01.intel.com ([192.55.52.88]:55949 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726019AbhAOFAy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 00:00:54 -0500
IronPort-SDR: m2FiZ0aODES401SYc2r1QMh8oA3AscGuPvH5wNtiwAquirRaXzpNA9dvjSmz0myvmWrVaI3ueN
 oGV8q53PgygQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9864"; a="197161025"
X-IronPort-AV: E=Sophos;i="5.79,348,1602572400"; 
   d="scan'208";a="197161025"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2021 21:00:11 -0800
IronPort-SDR: MoN/7Pmx3pmlrPO3Yc/FB4SxBleXwaag7FW5x5RmlseQOoYZVlbOWyZqEGcfbP2tz50R7nV+1v
 sXnwk/8WWAHQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,348,1602572400"; 
   d="scan'208";a="465465949"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by fmsmga001.fm.intel.com with ESMTP; 14 Jan 2021 21:00:11 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 14 Jan 2021 21:00:11 -0800
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 14 Jan 2021 21:00:10 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 14 Jan 2021 21:00:10 -0800
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (104.47.46.55) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Thu, 14 Jan 2021 21:00:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oB3zPSN48BXVEP5ggycke86thUjOGynI/yiBwaW/ejXropOTq+7d5JtCI7I+I+DUG6oOa4JLJ71B502gVQhl9QRY6yGSTcg8QJhk9WQWD1lsHZiOZgi0OqBO60flUnLJHrypa28Ak2wYXsvAqsMZLKC90IjFhOo6b1t2qBaTrRYFAQb2MH3o2Zzf5XU/hcSuUYptka2Pq4CQKbH6V3VeNMxemh/hYeS+btWXHmVze9uvOZQsDuwLEdNqHRUBOCo8Ff3pb+RjXJfjQoOUVD5MJprMCfA6o+bgh0j0vgZO0eBRXO73ZbCVpbgfPZSykb30XU3P1m1NdeDXyyMaEzso0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZLswqX8CtWakuSSk/aKsdhLK3k76+tQHkBhFg3wEvFI=;
 b=T/BCOBuwDT3OAXlN7FRNPeVR27G8zzj6E0OyU1O1uLBLhEf6Ha66A1txa0kXGWs4FR8z5w1DiV/5fnZrLumftkabg3a0ssdMwWmYxJsRZPSjG86dedvpbbzRpzuMjHT/LWl4fgYDFs3PKx5cJX2FiM0LwiLPdVoNUUHyoQ752mfhl1a3ETWzauVqnoIYnw84a38oA2CK1GgHZQNgBK/mIX5z0RYBqrNmlXETgEIoq4e9kqzV53k6nRrVrOW1t+EPgGahfuFBBcMJn23jHTd5u8F/6preorvGx/WAq5sA1V/rTSL7AtsweMisHUlhhK6Ir3v/EGfDa81YPyYrgUjNrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZLswqX8CtWakuSSk/aKsdhLK3k76+tQHkBhFg3wEvFI=;
 b=sW2H8gaC8YgB9Ucmy9nQPI6G8ZuLhBVkYX7c/8/ymoV70BTFH7125dXTTRDS5g0AWaw0c7JkBk53MDWkUIyanof04A6UX4qBSCNVhIwMHghIZi8HV1+av3z8ttNPLY2OaDByQgHrjFJJGSylwr/RgpC1zF2DO5euFhHJNt2MHeI=
Received: from PH0PR11MB4855.namprd11.prod.outlook.com (2603:10b6:510:41::12)
 by PH0PR11MB4984.namprd11.prod.outlook.com (2603:10b6:510:34::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9; Fri, 15 Jan
 2021 04:59:35 +0000
Received: from PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::d8ce:8971:4d20:c430]) by PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::d8ce:8971:4d20:c430%6]) with mapi id 15.20.3763.011; Fri, 15 Jan 2021
 04:59:35 +0000
From:   "Bae, Chang Seok" <chang.seok.bae@intel.com>
To:     "Liu, Jing2" <jing2.liu@linux.intel.com>
CC:     "Liu, Jing2" <jing2.liu@intel.com>, "bp@suse.de" <bp@suse.de>,
        "luto@kernel.org" <luto@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "Brown, Len" <len.brown@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 10/21] x86/fpu/xstate: Update xstate save function to
 support dynamic xstate
Thread-Topic: [PATCH v3 10/21] x86/fpu/xstate: Update xstate save function to
 support dynamic xstate
Thread-Index: AQHW2UTrfabGiuGaq0+dx4jPc8ZDRKob7zCAgACnYACABtLUgIAE2oAA
Date:   Fri, 15 Jan 2021 04:59:35 +0000
Message-ID: <BFF7E955-B3BB-45A2-8A01-00ED8971C8D7@intel.com>
References: <20201223155717.19556-1-chang.seok.bae@intel.com>
 <20201223155717.19556-11-chang.seok.bae@intel.com>
 <BYAPR11MB3256BBBB24F9131D99CF7EF5A9AF0@BYAPR11MB3256.namprd11.prod.outlook.com>
 <29CB32F5-1E73-46D4-BF92-18AD05F53E8E@intel.com>
 <0361132a-c088-331b-de1f-e0de23d729ab@linux.intel.com>
In-Reply-To: <0361132a-c088-331b-de1f-e0de23d729ab@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [73.189.248.82]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1953fcfe-b96c-46b1-59da-08d8b9125ae4
x-ms-traffictypediagnostic: PH0PR11MB4984:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR11MB498443D375B83DB467F43D8ED8A70@PH0PR11MB4984.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: m2GHaNo+zwnhm7ygB+Zh7IwPMqMmWe46n8kQItBnfI4sWlkVoY7QaP4V08bAjbFnWc50FcYhWY9uEMJR5yL0ibMafX/Az6dRKuap7paDw3dkOVVrQ3cmOYvgilBi/dPxi6Zg62eYUBC+ZHGRtLJe3sbv44vic5h6X/Xc5UBM8BFBUjTrFkYYD1nfE79FvXyDsijtJbX4m72IImpVquaoYat4+Vm3V+LwU/Uo00u8P5fCkJssDAx5WtGjr11v6QiENiiNmlJgR/eQuvN1kOl0eHd6wLlrMKvHZmm7tqUcMN0IqqywN50qWJh/Oc6e/8doUJ2M14ToB2k5MCugg0VlZ2Kj99wiN5DmhXSdyW1TaRDM1foWVy7dWvD08x+J0FFSExwjT1K1u8eFcD9rtu34vS0YnRjL2WqmEmeU/dfY6898fK8Szb3VDshCIm0cprfB
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4855.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(346002)(376002)(39860400002)(366004)(316002)(8676002)(6512007)(33656002)(36756003)(86362001)(5660300002)(478600001)(71200400001)(2906002)(53546011)(15650500001)(64756008)(66446008)(66556008)(83380400001)(6916009)(66946007)(66476007)(6506007)(4326008)(26005)(54906003)(2616005)(8936002)(76116006)(186003)(6486002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?WEVhalNDcTBveGwrRjJwbSt6aUo5T0dXNUdFRFdDSVB5N2xTeU94R2N6NGp4?=
 =?utf-8?B?VTFxMU9IVDBJNnhBN0p1UXZIZEdJSGcvS2ZVa08ydXVIOEtWZzRHNW9IanhV?=
 =?utf-8?B?blhQbnBxb3R1MmpHNGRSaXkzMklDajA0ZGx0RGpLTCszaWUxaWIyeFE5NVJj?=
 =?utf-8?B?cHhweU9EMXlBTi8wckNZb0F6Uis0V0QwREY1S1YwbGF6YktFYzd3NFVwS0g2?=
 =?utf-8?B?VENTM21UL1NneWlLNFZ4RmlxNmM0YytNVVBhY1E2K2wyZkhhblo5VkdkMXow?=
 =?utf-8?B?ejc1cXNkb0Y5bENMZXhyOSt6aStnaTVxZmZJdG1YR0FpUTZvWHdjSzlESWJp?=
 =?utf-8?B?UnBtc3N2NjVaSEJ5RjR1cStyNm1Pd1ljcnBoU3Z6Ry8zSm5sTEZGeHhWRjJU?=
 =?utf-8?B?YlczbUNmMVBsOTA0eHNuZm1xUlRBQTJzUXZjTzBaRXd1d0w4K0NYMjk1RTVp?=
 =?utf-8?B?TU1WNGpvUnRIRUNQMjFJOUovb0QzdnZrZldzTElXSi9GZmppZFNZbjBlMWpJ?=
 =?utf-8?B?ZzlldkE2SlJtNllWWTZveWpYenZrM0dIOHNaN2l1SHVoU0dOZjJ1N1VGYVJC?=
 =?utf-8?B?SWdGV2FoV1M5TWx6cDV5TFJsQk1aVzNpWjFST0lTNHNRREJIL09hd2Fyd0Vq?=
 =?utf-8?B?RTUyZVROMHk5SjJOcTZubHdjbW41RkI0Z0xZcXFuUy9VMkxabkxneEp0dHdM?=
 =?utf-8?B?c2ZhUVNCNEVXa09oMENCakV3aUppa0djV3dqeFVRYVkveFJCNlNFTkdHLzZL?=
 =?utf-8?B?NlhaL1hGL3lQWUsrcnNOYXpSMDc1NTYwcFpRVVFuWkxvdTFxa0NYMGhJSWUx?=
 =?utf-8?B?cXMzRXJqaXBiTTN2c21CdnlsUTVIYnhuWkorRzNWa3VjOXhNOGpRVDRsSThy?=
 =?utf-8?B?QjFydXFERndMM29RMlI1RjlwZ05UdEVVVWVCV1c1YjBDVzJ2U0Nod2NmSExp?=
 =?utf-8?B?cWZTclBnNzh2VzlGM2NwSDM3cjRYNjYyOEQrVTcrdUxlRzdiNWtSVTEyZEpy?=
 =?utf-8?B?UFVpOENJVGFabXIrMERHdXZnRThheCtpaTQxN1R1T2FuU2t0MkU4ZFRQREhm?=
 =?utf-8?B?a2xMb29pb241dUxIMjFDMTRXM2VDOTBidkZwUUUyRlRMMm5zV0Nqc3dWeUlp?=
 =?utf-8?B?SXdSUXRUL0Q3cU45RFRjRUQ0c0JIMVRES3A5RG5zaDFuU29KYmdPNHVzcDlS?=
 =?utf-8?B?OFZSVjBVeWFRelJFcktHYzkra0ZGME84akJqZEF0U2lIQmZMRzBweW5PM0ZC?=
 =?utf-8?B?Z0xVbHU2QUs5a1UrcTc4QlhaK3p0OWMwcjN4dG9tN3h4c01vMkhOQ29aQThD?=
 =?utf-8?Q?yOlRJMxYOBj3t5wQTfzsP7X9EcGQneu5JP?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EBA4BF13EEB91B4AACDFABF6AFCCA44A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4855.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1953fcfe-b96c-46b1-59da-08d8b9125ae4
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2021 04:59:35.6697
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NBQv/+TSQcuAdvJWjzgF20xg2hBIWUJR2sySpMUr9EUXPMeGd66BTcaLzGBzZeLoMCQ/zr+B4eL+O2VfTmAC3mc2p+HyHKVKGqQlisjONtk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4984
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQo+IE9uIEphbiAxMSwgMjAyMSwgYXQgMTg6NTIsIExpdSwgSmluZzIgPGppbmcyLmxpdUBsaW51
eC5pbnRlbC5jb20+IHdyb3RlOg0KPiANCj4gT24gMS84LzIwMjEgMjo0MCBBTSwgQmFlLCBDaGFu
ZyBTZW9rIHdyb3RlOg0KPj4+IE9uIEphbiA3LCAyMDIxLCBhdCAxNzo0MSwgTGl1LCBKaW5nMiA8
amluZzIubGl1QGludGVsLmNvbT4gd3JvdGU6DQo+Pj4gDQo+Pj4gc3RhdGljIHZvaWQga3ZtX3Nh
dmVfY3VycmVudF9mcHUoc3RydWN0IGZwdSAqZnB1KSAgew0KPj4+ICsJc3RydWN0IGZwdSAqc3Jj
X2ZwdSA9ICZjdXJyZW50LT50aHJlYWQuZnB1Ow0KPj4+ICsNCj4+PiAJLyoNCj4+PiAJICogSWYg
dGhlIHRhcmdldCBGUFUgc3RhdGUgaXMgbm90IHJlc2lkZW50IGluIHRoZSBDUFUgcmVnaXN0ZXJz
LCBqdXN0DQo+Pj4gCSAqIG1lbWNweSgpIGZyb20gY3VycmVudCwgZWxzZSBzYXZlIENQVSBzdGF0
ZSBkaXJlY3RseSB0byB0aGUgdGFyZ2V0Lg0KPj4+IAkgKi8NCj4+PiAtCWlmICh0ZXN0X3RocmVh
ZF9mbGFnKFRJRl9ORUVEX0ZQVV9MT0FEKSkNCj4+PiAtCQltZW1jcHkoJmZwdS0+c3RhdGUsICZj
dXJyZW50LT50aHJlYWQuZnB1LnN0YXRlLA0KPj4+ICsJaWYgKHRlc3RfdGhyZWFkX2ZsYWcoVElG
X05FRURfRlBVX0xPQUQpKSB7DQo+Pj4gKwkJbWVtY3B5KCZmcHUtPnN0YXRlLCAmc3JjX2ZwdS0+
c3RhdGUsDQo+Pj4gCQkgICAgICAgZnB1X2tlcm5lbF94c3RhdGVfbWluX3NpemUpOw0KDQo8c25p
cD4NCg0KPj4+IC0JZWxzZQ0KPj4+ICsJfSBlbHNlIHsNCj4+PiArCQlpZiAoZnB1LT5zdGF0ZV9t
YXNrICE9IHNyY19mcHUtPnN0YXRlX21hc2spDQo+Pj4gKwkJCWZwdS0+c3RhdGVfbWFzayA9IHNy
Y19mcHUtPnN0YXRlX21hc2s7DQo+Pj4gDQo+Pj4gVGhvdWdoIGR5bmFtaWMgZmVhdHVyZSBpcyBu
b3Qgc3VwcG9ydGVkIGluIGt2bSBub3csIHRoaXMgZnVuY3Rpb24gc3RpbGwgbmVlZA0KPj4+IGNv
bnNpZGVyIG1vcmUgdGhpbmdzIGZvciBmcHUtPnN0YXRlX21hc2suDQo+PiBDYW4geW91IGVsYWJv
cmF0ZSB0aGlzPyBXaGljaCBwYXRoIG1pZ2h0IGJlIGFmZmVjdGVkIGJ5IGZwdS0+c3RhdGVfbWFz
aw0KPj4gd2l0aG91dCBkeW5hbWljIHN0YXRlIHN1cHBvcnRlZCBpbiBLVk0/DQo+PiANCj4+PiBJ
IHN1Z2dlc3QgdGhhdCB3ZSBjYW4gc2V0IGl0IGJlZm9yZSBpZi4uLmVsc2UgKGZvciBib3RoIGNh
c2VzKSBhbmQgbm90IGNoYW5nZSBvdGhlci4NCj4+IEkgdHJpZWQgYSBtaW5pbXVtIGNoYW5nZSBo
ZXJlLiAgVGhlIGZwdS0+c3RhdGVfbWFzayB2YWx1ZSBkb2VzIG5vdCBpbXBhY3QgdGhlDQo+PiBt
ZW1jcHkoKS4gU28sIHdoeSBkbyB3ZSBuZWVkIHRvIGNoYW5nZSBpdCBmb3IgYm90aD8NCj4gDQo+
IFN1cmUsIHdoYXQgSSdtIGNvbnNpZGVyaW5nIGlzIHRoYXQgIm1hc2siIGlzIHRoZSBmaXJzdCB0
aW1lIGludHJvZHVjZWQgaW50byAiZnB1IiwNCj4gcmVwcmVzZW50aW5nIHRoZSB1c2FnZSwgc28g
bm90IG9ubHkgc2V0IGl0IHdoZW4gbmVlZGVkLCBidXQgYWxzbyBtYWtlIGl0IGFzIGENCj4gcmVw
cmVzZW50YXRpb24sIGluIGNhc2Ugb2YgYW55d2hlcmUgdXNpbmcgaXQgKGVzcGVjaWFsbHkgYmV0
d2VlbiB0aGUgaW50ZXJ2YWwNCj4gb2YgdGhpcyBzZXJpZXMgYW5kIGt2bSBzZXJpZXMgaW4gZnV0
dXJlKS4NCg0KVGhhbmsgeW91IGZvciB0aGUgZmVlZGJhY2suIFNvcnJ5LCBJIGRvbid0IGdldCBh
bnkgbG9naWNhbCByZWFzb24gdG8gc2V0IHRoZQ0KbWFzayBhbHdheXMgaGVyZS4gUGVyaGFwcywg
S1ZNIGNvZGUgY2FuIGJlIHVwZGF0ZWQgbGlrZSB5b3UgbWVudGlvbmVkIHdoZW4NCnN1cHBvcnRp
bmcgdGhlIGR5bmFtaWMgc3RhdGVzIHRoZXJlLg0KDQpQbGVhc2UgbGV0IG1lIGtub3cgaWYgSeKA
mW0gbWlzc2luZyBhbnkgZnVuY3Rpb25hbCBpc3N1ZXMuDQoNClRoYW5rcywNCkNoYW5n
