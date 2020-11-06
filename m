Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4302A8FA4
	for <lists+kvm@lfdr.de>; Fri,  6 Nov 2020 07:48:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726128AbgKFGrx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Nov 2020 01:47:53 -0500
Received: from mga07.intel.com ([134.134.136.100]:38619 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725830AbgKFGrw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Nov 2020 01:47:52 -0500
IronPort-SDR: y4gW5Nq0IJoooRt8Fg0U/1vBCino8kmaPeojtFae9jQlsi2HqIE5xkaQUyNyGVpUr7exVNRKTa
 x6nmaoGNM1Og==
X-IronPort-AV: E=McAfee;i="6000,8403,9796"; a="233675855"
X-IronPort-AV: E=Sophos;i="5.77,455,1596524400"; 
   d="scan'208";a="233675855"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2020 22:47:52 -0800
IronPort-SDR: Ym44kh/QNX7vY1YjoNWyb08Gd+1msysBH2GbijL7QaNdyA+e4rfGYAnGdRAuFgaeY8iZAHeNy4
 lHbfr+zdA3UA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,455,1596524400"; 
   d="scan'208";a="354597517"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga004.fm.intel.com with ESMTP; 05 Nov 2020 22:47:51 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 5 Nov 2020 22:47:51 -0800
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 5 Nov 2020 22:47:50 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 5 Nov 2020 22:47:50 -0800
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (104.47.37.53) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Thu, 5 Nov 2020 22:47:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=To5OX9bSNhSawJzWolxTMBbfCxDouEMtoX4BC3sl1PjonfiW/dzIxRqjzdqD/7CmX1mG9zJJ5y7xNRXEK73NIt8KWMk+PxfKvvCQIr6D6IV12IMaxc3M0KP5j4I4ET38+p4nh2x7OjtadK4SvpwlbtiQ8uqWDXCINsxGr29zlElS/+FMUPRS41Te+t8vvF+1//zZ5onIM6CPrGwBvK9QN3gzKrgW8b3g/T3rdbU6Gqjh7UKGzGjsQRqZBCYGASxUPYgwUHl27H+FOW+JtIRtUi4jfQjnVErdfCQ4yYGtyfUiYvvw24mDADg2VCwHhJlmlmmqfIMf0w9b6PalYT1X/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FBrYDwGTeOSvhgGFavAIhgl1bH1ZdRCCG0gpquPzPno=;
 b=jmxxzZtUlpZmy6z1rIYqLqD32GauPBErG2d1P6Ix0Tq4a21Xx5ur2hZroe5Ag+KhNX7Eqa/fTX0VBajODGMU3ste8/6+Z9P3TtGmyFdY9E0lmLuHvvBlqm1CDSbAPDAPlv43se5S+eapuF+atj5ZcKDfwSBVzppztBAUNvmcgSyOqMue/ZI3yfbfUBpS2LSaVa9gNl4+wWIGYKU9JQ+AtGaeyzcn0HkinPp6fJ43su+FM2FJwcDZ4eA8k3YuF4Dt2bSpBEO8xO3kgyeI7ISb9RuGgGppl7sThPbIx93kznuBXf5CS/3AFm+zi/Sopy4Cc6MPSPFT6f5U83G/q7gnaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FBrYDwGTeOSvhgGFavAIhgl1bH1ZdRCCG0gpquPzPno=;
 b=K2sy0aB98OY6coyk7knZTHfzJISzj18ZgBSxe0Bts4RuZFh7o7EBJpcqw2UI5O2i9+81jESq0op1387yzA3qnoyUfgx8hEYO32o2b7p8qOQpx5wSNuRj2qjgAlZ/SzpfY5VAVq2y24Xv2Nlc1C8i5E9dhvwU1sVznpQc+dJO9wA=
Received: from CY4PR11MB1957.namprd11.prod.outlook.com (2603:10b6:903:120::15)
 by CY4PR11MB1303.namprd11.prod.outlook.com (2603:10b6:903:29::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.28; Fri, 6 Nov
 2020 06:47:48 +0000
Received: from CY4PR11MB1957.namprd11.prod.outlook.com
 ([fe80::807:d5ba:5158:e2f3]) by CY4PR11MB1957.namprd11.prod.outlook.com
 ([fe80::807:d5ba:5158:e2f3%11]) with mapi id 15.20.3499.032; Fri, 6 Nov 2020
 06:47:48 +0000
From:   "Qi, Yadong" <yadong.qi@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
CC:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "liran.alon@oracle.com" <liran.alon@oracle.com>,
        "nikita.leshchenko@oracle.com" <nikita.leshchenko@oracle.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Chen, Luhai" <luhai.chen@intel.com>,
        "Zhu, Bing" <bing.zhu@intel.com>,
        "Wang, Kai Z" <kai.z.wang@intel.com>
Subject: RE: [PATCH] KVM: x86: emulate wait-for-SIPI and SIPI-VMExit
Thread-Topic: [PATCH] KVM: x86: emulate wait-for-SIPI and SIPI-VMExit
Thread-Index: AQHWkKDXpbo0akWSWkKXeJbWVxPoT6m5+qKAgADw/1A=
Date:   Fri, 6 Nov 2020 06:47:48 +0000
Message-ID: <CY4PR11MB195721D5477F548C1FC56E83E3ED0@CY4PR11MB1957.namprd11.prod.outlook.com>
References: <20200922052343.84388-1-yadong.qi@intel.com>
 <187635d0-7786-5d8f-a41a-45a6abd9d001@redhat.com>
In-Reply-To: <187635d0-7786-5d8f-a41a-45a6abd9d001@redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.102.204.38]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d94ed433-b5ca-4833-cec8-08d8821fdfce
x-ms-traffictypediagnostic: CY4PR11MB1303:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR11MB13039115B74998FE6EED50A8E3ED0@CY4PR11MB1303.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: W0xWTiE8ozJl8SGwaq5tcXSZmtWGgxWcY8h7vzt4vEveVHYxSIXHeFYbTEZ4poTrl8e5nBzYF7DjlqpAeAq53mLTbExe5wpLP83YcKZhu1p+qZ4ZPnaptigKB74vfF/mO4g7qRHWtRhln3ovG9yT3Fyb3ZjB3AtFS4iKfNBJrXl9oOlS+cavmBjLWDQFqzANlKvuMBrfWd5AB7ZOr7raLODYDGSw8zvHxXrAwF9KxCPozsJS2TQ8uDe655HkitdBa+kxhf7hl5ZlKMRcWXQz+KOU7yRLJY1BCZRCHwZqoHPXXT9vC6CBIfTGnxaNgTyxsHlquvPpxU36dVhm/P8tvQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR11MB1957.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(396003)(366004)(39860400002)(26005)(83380400001)(5660300002)(54906003)(8936002)(55016002)(316002)(52536014)(110136005)(186003)(107886003)(7696005)(8676002)(71200400001)(9686003)(64756008)(4326008)(7416002)(2906002)(66946007)(76116006)(6506007)(66556008)(478600001)(86362001)(66476007)(66446008)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 7lZgE+gDA+Q7wXZ7dm7aM9dXViEp3kwAwNX2V33CqQPEd4lOR1Af9FytDLjrhXP/ARDJ1lmuTei4/9DvtiFTgUNB+dX3CMd2T3V5yAZlH2mvgolUJjeF2VcJaUHit2qXcxhCANJzaOV18EW9QXODHJ8t+IO5FW/zO+wjBlAJ4wt42H/FWUKXJrjdc3dHXaQdnYOZ1BFs/sir4u3+gVu1utMfwmQmUPMGkvZ5N52Ztgwy5xUukDiLbrDTz0CqZMdfQpbMo+hWZtM9lEu1/wmME9MJn9GTdpU+y3LKKncDeRLypK/wg4TWSJSC/vhUqBkSt///kFs0lxM+u8/BWLLhkFxaWRSproiyxvv35snVHa1cIpWexqZVKSTHS5sKHKfHs787jGXAb2pvTubHjivBF8ll7Fq5EdL7cM+o9ZFD4/rP8sJ7TR0Kgc+/bIA/wZxzlKbm4kYX3zVUsSGR5CH5XJ+gLTGddpDdvoan5HdJE0fhAMCzPCFNNFmKPncpmk2KAna4IYITzRSE7OuYT6v/uuzZxwMM+1tHVIxCOLnxDqvFrkttOoIAPFmwAO3xTULE+jwt+MoS5c0ACQPXkoGiBjeo+f8heaZAqvtenRZEjFgL3lPR6z12JbiZr0Kn/E2rrduCk/CtupT1WidB1la1FA==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR11MB1957.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d94ed433-b5ca-4833-cec8-08d8821fdfce
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2020 06:47:48.0945
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9GjGlYIaLbBtMvhFFtUtuo1BunMc5d2KzNSULYYoFJqpV5jyh3IcsgS95EUg+Uv8ZbM+JJwpZywoa/fRtNQN7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB1303
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBUaGVyZSBpcyBhIHByb2JsZW0gaW4gdGhpcyBwYXRjaCwgaW4gdGhhdCB0aGlzIGNoYW5nZSBp
cyBpbmNvcnJlY3Q6DQo+IA0KPiA+DQo+ID4gQEAgLTI4NDcsNyArMjg0Nyw4IEBAIHZvaWQga3Zt
X2FwaWNfYWNjZXB0X2V2ZW50cyhzdHJ1Y3Qga3ZtX3ZjcHUNCj4gKnZjcHUpDQo+ID4gIAkgKi8N
Cj4gPiAgCWlmIChrdm1fdmNwdV9sYXRjaF9pbml0KHZjcHUpKSB7DQo+ID4gIAkJV0FSTl9PTl9P
TkNFKHZjcHUtPmFyY2gubXBfc3RhdGUgPT0NCj4gS1ZNX01QX1NUQVRFX0lOSVRfUkVDRUlWRUQp
Ow0KPiA+IC0JCWlmICh0ZXN0X2JpdChLVk1fQVBJQ19TSVBJLCAmYXBpYy0+cGVuZGluZ19ldmVu
dHMpKQ0KPiA+ICsJCWlmICh0ZXN0X2JpdChLVk1fQVBJQ19TSVBJLCAmYXBpYy0+cGVuZGluZ19l
dmVudHMpICYmDQo+ID4gKwkJICAgICFpc19ndWVzdF9tb2RlKHZjcHUpKQ0KPiA+ICAJCQljbGVh
cl9iaXQoS1ZNX0FQSUNfU0lQSSwgJmFwaWMtPnBlbmRpbmdfZXZlbnRzKTsNCj4gPiAgCQlyZXR1
cm47DQo+ID4gIAl9DQo+IA0KPiBIZXJlIHlvdSdyZSBub3QgdHJ5aW5nIHRvIHByb2Nlc3MgYSBs
YXRjaGVkIElOSVQ7IHlvdSBqdXN0IHdhbnQgdG8gZGVsYXkgdGhlDQo+IHByb2Nlc3Npbmcgb2Yg
dGhlIFNJUEkgdW50aWwgY2hlY2tfbmVzdGVkX2V2ZW50cy4NCj4gDQo+IFRoZSBjaGFuZ2UgZG9l
cyBoYXZlIGEgY29ycmVjdCBwYXJ0IGluIGl0LiAgSW4gcGFydGljdWxhciwNCj4gdm14X2FwaWNf
aW5pdF9zaWduYWxfYmxvY2tlZCBzaG91bGQgaGF2ZSBiZWVuDQo+IA0KPiBkaWZmIC0tZ2l0IGEv
YXJjaC94ODYva3ZtL3ZteC92bXguYyBiL2FyY2gveDg2L2t2bS92bXgvdm14LmMgaW5kZXgNCj4g
NDdiODM1N2I5NzUxLi42NDMzOTEyMWE0ZjAgMTAwNjQ0DQo+IC0tLSBhL2FyY2gveDg2L2t2bS92
bXgvdm14LmMNCj4gKysrIGIvYXJjaC94ODYva3ZtL3ZteC92bXguYw0KPiBAQCAtNzU1OCw3ICs3
NTU4LDcgQEAgc3RhdGljIHZvaWQgZW5hYmxlX3NtaV93aW5kb3coc3RydWN0IGt2bV92Y3B1DQo+
ICp2Y3B1KQ0KPiANCj4gICBzdGF0aWMgYm9vbCB2bXhfYXBpY19pbml0X3NpZ25hbF9ibG9ja2Vk
KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkNCj4gICB7DQo+IC0JcmV0dXJuIHRvX3ZteCh2Y3B1KS0+
bmVzdGVkLnZteG9uOw0KPiArCXJldHVybiB0b192bXgodmNwdSktPm5lc3RlZC52bXhvbiAmJiAh
aXNfZ3Vlc3RfbW9kZSh2Y3B1KTsNCj4gICB9DQo+IA0KPiAgIHN0YXRpYyB2b2lkIHZteF9taWdy
YXRlX3RpbWVycyhzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+IA0KPiB0byBvbmx5IGxhdGNoIElO
SVQgc2lnbmFscyBpbiByb290IG1vZGUuICBIb3dldmVyLCBTSVBJIG11c3QgYmUgY2xlYXJlZA0K
PiB1bmNvbmRpdGlvbmFsbHkgb24gU1ZNOyB0aGUgIiFpc19ndWVzdF9tb2RlIiB0ZXN0IGluIHRo
YXQgY2FzZSBpcyBpbmNvcnJlY3QuDQo+IA0KPiBUaGUgcmlnaHQgd2F5IHRvIGRvIGl0IGlzIHRv
IGNhbGwgY2hlY2tfbmVzdGVkX2V2ZW50cyBmcm9tDQo+IGt2bV9hcGljX2FjY2VwdF9ldmVudHMu
ICBUaGlzIHdpbGwgY2F1c2UgYW4gSU5JVCBvciBTSVBJIHZtZXhpdCwgYXMgcmVxdWlyZWQuDQo+
IFRoZXJlIGlzIHNvbWUgZXh0cmEgY29tcGxpY2F0aW9uIHRvIHJlYWQgcGVuZGluZ19ldmVudHMN
Cj4gKmJlZm9yZSoga3ZtX2FwaWNfYWNjZXB0X2V2ZW50cyBhbmQgbm90IHN0ZWFsIGZyb20gdGhl
IGd1ZXN0IGFueSBJTklUIG9yIFNJUEkNCj4gdGhhdCBpcyBzZW50IGFmdGVyIGt2bV9hcGljX2Fj
Y2VwdF9ldmVudHMgcmV0dXJucy4NCj4gDQo+IFRoYW5rcyB0byB5b3VyIHRlc3QgY2FzZSwgSSB3
aWxsIHRlc3QgYSBwYXRjaCBhbmQgc2VuZCBpdC4NCj4gDQpUaGFua3MgdmVyeSBtdWNoLCBQYW9s
by4NCkJUVywgSSBub3RpY2VkIGFub3RoZXIgaXNzdWUgaW4gc3luY192bWNzMDJfdG9fdm1jczEy
KCk6DQp2bWNzMTItPmd1ZXN0X2FjdGl2aXR5X3N0YXRlIGlzIG5vdCBzZXQgcHJvcGVybHkgd2hl
biBtcF9zdGF0ZSBpcyBJTklUX1JFQ0VJVkVELg0KSSB3aWxsIGNvcnJlY3QgaXQgYW5kIHNlbmQg
djIgb2YgUGF0Y2ggMi8yLg0K
