Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E517293015
	for <lists+kvm@lfdr.de>; Mon, 19 Oct 2020 22:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732368AbgJSUtv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Oct 2020 16:49:51 -0400
Received: from mga01.intel.com ([192.55.52.88]:7627 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727715AbgJSUtv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Oct 2020 16:49:51 -0400
IronPort-SDR: UO+D5eve4OBVKpvf4AJQwjZVpyw3PQNqdzSzakOORa5s4hKu3xG78myT1m3aPbZ2TDF17vdBgC
 vbZ5E2BZP9NQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9779"; a="184718632"
X-IronPort-AV: E=Sophos;i="5.77,395,1596524400"; 
   d="scan'208";a="184718632"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2020 13:49:47 -0700
IronPort-SDR: w/3NM8H105BTAEvZhjkieIszbtag/knWVoeJZnHHmsqlwDrNtk8o1/AwaKLEHVHDKsqk6CcSqd
 IvGxy4K3dP+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,395,1596524400"; 
   d="scan'208";a="348020008"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga008.jf.intel.com with ESMTP; 19 Oct 2020 13:49:46 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 19 Oct 2020 13:49:46 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 19 Oct 2020 13:49:46 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 19 Oct 2020 13:49:46 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.104)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Mon, 19 Oct 2020 13:49:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cDgVSc4Jmd6biAZhCZV8zLnLQYzOi3dYxVZqYS3K+4suYpDh3gxd6Y7HwFb0ucr1yAHbrJyInJkhLV3BhJwTd9CB3rOOUYKu7pX5LCu0GYA+JriYXiN5KdJNC6VADF7rseJ2JkNLXpTkTbkGHhvtqV4maJV0C9rSW2KB0UNijAAokkfeRI1qC7/WVSc33j0BEEVCFGItBfWKrzdeBYQTgE+hN+KmorSxra5DoSFga514wy3kdWhOJcWdXKGKWz0F2e3sMRU5fcGoatvlNsPmQdpoivFpc3o10h9QvfsORsk3do8F/rfjpbn6tJHwZw4gpVfCZmTMRyr3ZapHXIurrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vh033PO9nYMOrpRMU3FEichHXw34ZzcskPVajW5eWdQ=;
 b=bbzQuxvXoZ0OoFKyfo4lQfrRHOcuRUp5+O7vj/8VvJSj24xIk20TVFFcxdSMrQ142aQf6RTFcpkm0mHesBotYvt3HlnqN/pmFzAW7K5RvHckifsZW6Kpaxx56WHH807I4M7hLCWvLuB28MrRBkKT09cPuhiZY8qFEOrH5TeK6SmQl3wlL6yF+iOWsiGYTIW68ELmbVcRFSsgd9twxGj+qX29C84dhiQED0oWB74WPrRg7JmJK7M5X9StRqERX1IEktuxOewmJzKN+aLDpXfOFoKuKRvO+sLA39zWBscl+cTbg60xigqD0tzm+efPjuL8gLVAaJRiF0V0u8j7bxEAvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vh033PO9nYMOrpRMU3FEichHXw34ZzcskPVajW5eWdQ=;
 b=VMime1YEV+qfQJIOf9sOcslNe7eTqaalwqhCqq1nDZgluKTV5pYM72dWRp54EZXRO9r0XhMH83vkjet/JzlDkuuYpG8QoJ6tiW9LnypSNoGGV97sUfxvDPDokBq2iEEi4ig87buLg1ACuhsi8S2BrOtYWzbdKl95DmDDsGYTexo=
Received: from SN6PR11MB3184.namprd11.prod.outlook.com (2603:10b6:805:bd::17)
 by SA2PR11MB4810.namprd11.prod.outlook.com (2603:10b6:806:116::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.23; Mon, 19 Oct
 2020 20:49:44 +0000
Received: from SN6PR11MB3184.namprd11.prod.outlook.com
 ([fe80::b901:8e07:4340:6704]) by SN6PR11MB3184.namprd11.prod.outlook.com
 ([fe80::b901:8e07:4340:6704%7]) with mapi id 15.20.3477.028; Mon, 19 Oct 2020
 20:49:44 +0000
From:   "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "bgardon@google.com" <bgardon@google.com>
CC:     "kernellwp@gmail.com" <kernellwp@gmail.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "yulei.kernel@gmail.com" <yulei.kernel@gmail.com>,
        "pshier@google.com" <pshier@google.com>,
        "pfeiner@google.com" <pfeiner@google.com>,
        "cannonmatthews@google.com" <cannonmatthews@google.com>,
        "xiaoguangrong.eric@gmail.com" <xiaoguangrong.eric@gmail.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "junaids@google.com" <junaids@google.com>
Subject: Re: [PATCH v2 07/20] kvm: x86/mmu: Support zapping SPTEs in the TDP
 MMU
Thread-Topic: [PATCH v2 07/20] kvm: x86/mmu: Support zapping SPTEs in the TDP
 MMU
Thread-Index: AQHWolfRezmt0QLaq0i752J87u6M5amfbg0A
Date:   Mon, 19 Oct 2020 20:49:43 +0000
Message-ID: <e13ab415da6376dfd7337052d5876a42f4c0a11e.camel@intel.com>
References: <20201014182700.2888246-1-bgardon@google.com>
         <20201014182700.2888246-8-bgardon@google.com>
In-Reply-To: <20201014182700.2888246-8-bgardon@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.30.1 (3.30.1-1.fc29) 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.55.55.45]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6684e87b-1290-4b0f-d659-08d874708218
x-ms-traffictypediagnostic: SA2PR11MB4810:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR11MB4810FADAD8B8007C5985684EC91E0@SA2PR11MB4810.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: juav2Ezj/BDEHspFVX1LC+FS5qNSApQTLG7gQLxekwK3kJH9mpd/bm3DTRnpTvBiVv7sYRdx3cjPBigaaVaszhwdH3ewiOC+FNLlvgasNOKqLtHMfvooDXX2kIBVAQZpLa7gokPdvowNOEgKLymPedr2gZoD/Jo/5a0QDOBpI3pt2x/LIYJL9MpqlX2KDkSD/9EKLkGqsbaO6YWXLMYCQj3ecSWsyptJLOe4+J7gH1/k/3RaWEeH9ama8Ggu6op7xf84qa7s7HnGfGeTM6XnBUaKQT9Di/Oz9jvgBZqRfjJ7LZKAWasd66cwkYeH2UdFgwRAokAgDnyofGkv7FA+MA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3184.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(346002)(376002)(366004)(396003)(71200400001)(478600001)(83380400001)(86362001)(186003)(2906002)(26005)(6506007)(6486002)(2616005)(54906003)(6512007)(4326008)(110136005)(64756008)(316002)(5660300002)(4001150100001)(8936002)(66556008)(7416002)(66476007)(8676002)(36756003)(76116006)(91956017)(66946007)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: aKIjbfL/wAA2BFfI7p9XoxbWlLYPQvljkdqdctSvdqulpxBOZp1I2PlklQFPDOepEfljOKPX6tOshuGdh/B74uINpm9dj5iJ6u+k9GJmEFZv/daLT2YaLEf2I+MH4mqe4x4um5PX3KJj2qMt27NsGbZSENUMVbRkzpkqbK6FhY3xbMJwj3oF/W0MRmfmLmlFjHK/gGSriUF5A688/epn6oeYZXixj2jEQX/mGOs20wLsJ/KJ7BjuBOhL/FlxUN+9aGKhDhPeBmCVTQB9lVZm+dtJjyFG0wg30c4xhkM7VLSKPATLyXohqNBrBovKrSZubQpcJ8YOMyn8IyafczghsnnYTzwxkCFFZWBNupsjpBIi3bVB65Hy7K/axBTHUzguQONTRl4Ut9lZFCeg9eQkCQZmyKji9iyQMtcOxDMnL8+qCNQUFMaBMUM6fRkZJpYeA9z5zEFpBd6E/BoQ1xlJk+u8CPv9cDtlDRz59Qxmfv+W/4MPIeRPc7MXe6skrODkeJzmX1uLnyeh7Xc4vwjVrAeMijn6LMZzDeVVOtd5ekH2UuS3cWCW94YjvHVvl4mh6ZxvwMBxPPjSejSWO2LCYe42oQPYM6cy8wqVORUzYifP3+ikmpPb/BCjom3PfM+GMa1i7tY7kbsZGnWQY8X6Lw==
Content-Type: text/plain; charset="utf-8"
Content-ID: <C75FE9D77E79A94481CFC93874059499@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3184.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6684e87b-1290-4b0f-d659-08d874708218
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2020 20:49:43.7991
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: K1XL26KvXZRlhb1ScqxkH42k1vqF+cSImWSh5geCrCg5es5R3in5zHwCc57yF3tc7Oje8XuUN6HTF6gohQF3eg1q8viZ/qllR7nqWpdnKOM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4810
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIwLTEwLTE0IGF0IDExOjI2IC0wNzAwLCBCZW4gR2FyZG9uIHdyb3RlOg0KPiBA
QCAtNTgyNyw2ICs1ODMxLDcgQEAgdm9pZCBrdm1femFwX2dmbl9yYW5nZShzdHJ1Y3Qga3ZtICpr
dm0sIGdmbl90DQo+IGdmbl9zdGFydCwgZ2ZuX3QgZ2ZuX2VuZCkNCj4gICAgICAgICBzdHJ1Y3Qg
a3ZtX21lbXNsb3RzICpzbG90czsNCj4gICAgICAgICBzdHJ1Y3Qga3ZtX21lbW9yeV9zbG90ICpt
ZW1zbG90Ow0KPiAgICAgICAgIGludCBpOw0KPiArICAgICAgIGJvb2wgZmx1c2g7DQo+ICANCj4g
ICAgICAgICBzcGluX2xvY2soJmt2bS0+bW11X2xvY2spOw0KPiAgICAgICAgIGZvciAoaSA9IDA7
IGkgPCBLVk1fQUREUkVTU19TUEFDRV9OVU07IGkrKykgew0KPiBAQCAtNTg0Niw2ICs1ODUxLDEy
IEBAIHZvaWQga3ZtX3phcF9nZm5fcmFuZ2Uoc3RydWN0IGt2bSAqa3ZtLCBnZm5fdA0KPiBnZm5f
c3RhcnQsIGdmbl90IGdmbl9lbmQpDQo+ICAgICAgICAgICAgICAgICB9DQo+ICAgICAgICAgfQ0K
PiAgDQo+ICsgICAgICAgaWYgKGt2bS0+YXJjaC50ZHBfbW11X2VuYWJsZWQpIHsNCj4gKyAgICAg
ICAgICAgICAgIGZsdXNoID0ga3ZtX3RkcF9tbXVfemFwX2dmbl9yYW5nZShrdm0sIGdmbl9zdGFy
dCwNCj4gZ2ZuX2VuZCk7DQo+ICsgICAgICAgICAgICAgICBpZiAoZmx1c2gpDQo+ICsgICAgICAg
ICAgICAgICAgICAgICAgIGt2bV9mbHVzaF9yZW1vdGVfdGxicyhrdm0pOw0KPiArICAgICAgIH0N
Cj4gKw0KPiAgICAgICAgIHNwaW5fdW5sb2NrKCZrdm0tPm1tdV9sb2NrKTsNCj4gIH0NCg0KSGks
DQoNCkknbSBqdXN0IGdvaW5nIHRocm91Z2ggdGhpcyBsb29raW5nIGF0IGhvdyBJIG1pZ2h0IGlu
dGVncmF0ZSBzb21lIG90aGVyDQpNTVUgY2hhbmdlcyBJIGhhZCBiZWVuIHdvcmtpbmcgb24uIEJ1
dCBhcyBsb25nIGFzIEkgYW0sIEknbGwgdG9zcyBvdXQNCmFuIGV4dHJlbWVseSBzbWFsbCBjb21t
ZW50IHRoYXQgdGhlICJmbHVzaCIgYm9vbCBzZWVtcyB1bm5lY2Vzc2FyeS4NCg0KSSdtIGFsc28g
d29uZGVyaW5nIGEgYml0IGFib3V0IHRoaXMgZnVuY3Rpb24gaW4gZ2VuZXJhbC4gSXQgc2VlbXMg
dGhhdA0KdGhpcyBjaGFuZ2UgYWRkcyBhbiBleHRyYSBmbHVzaCBpbiB0aGUgbmVzdGVkIGNhc2Us
IGJ1dCB0aGlzIG9wZXJhdGlvbg0KYWxyZWFkeSBmbHVzaGVkIGZvciBlYWNoIG1lbXNsb3QgaW4g
b3JkZXIgdG8gZmFjaWxpdGF0ZSB0aGUgc3BpbiBicmVhay4NCklmIHNsb3RfaGFuZGxlX2xldmVs
X3JhbmdlKCkgdG9vayBzb21lIGV4dHJhIHBhcmFtZXRlcnMgaXQgY291bGQgbWF5YmUNCmJlIGF2
b2lkZWQuIE5vdCBzdXJlIGlmIGl0J3Mgd29ydGggaXQuDQoNClJpY2sNCg==
