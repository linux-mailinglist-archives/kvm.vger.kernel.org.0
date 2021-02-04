Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76E4F30FA01
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 18:45:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238531AbhBDRms (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 12:42:48 -0500
Received: from mga17.intel.com ([192.55.52.151]:19396 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238610AbhBDRcD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Feb 2021 12:32:03 -0500
IronPort-SDR: Cpvku/SXqJ5UkvXYeJJlz1HhyVbzlx7anQd8Ns7ACtvw5MXMMUFcSPG8w1HDJ5fMgA7Ps4JwfW
 4pMjHIRlzZTA==
X-IronPort-AV: E=McAfee;i="6000,8403,9885"; a="161045469"
X-IronPort-AV: E=Sophos;i="5.81,401,1610438400"; 
   d="scan'208";a="161045469"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2021 09:31:19 -0800
IronPort-SDR: /Tih8dIiTD5YVADC9tGE3K5wcnKnmVVpJfJqH9sKIZwpAHZ56jcl22/oG2HF5GTg4lHANFOupn
 WNaP5kE5PLAw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,401,1610438400"; 
   d="scan'208";a="483637387"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga001.fm.intel.com with ESMTP; 04 Feb 2021 09:31:19 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 4 Feb 2021 09:31:18 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Thu, 4 Feb 2021 09:31:18 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.176)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Thu, 4 Feb 2021 09:31:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d6148vMcbPyR1wN47wRGLRh00K/wy2waGQo43SV0k95AM8TSSoXehjN9KXhzA8ayN4Xkj/eHaEnDBAS7boVYHVqW0G+VE6wxigCZ53Jfh8m6NItZI/V/YWB3cQNLo71ftFpkuyu9575Iuyj8PnLOQH11LkcUEXjYt6xCbry0tJfi0nmDzWGu9HUiraypQP0g26ELnKBwWkp+FBebN/RuHghZvSsT6FTQx4Iq+ryYlwPa0miTdv000ktfGop2FCQ6Z7INa0m0DxvyMgS4oC/QQWh8AIdacdXIHOm29kOfAeEhfj6IanXn38c6Bxag0740m18iSm3K3dt9JLVEqKTDdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U0L/OzmWMAPUStiAObxzJCU3WL2Vb1EzEQnv9uQWenk=;
 b=oRUAVAgQzwXvGiHfBaG+WU59p7kneBCFEF0MG1Tihrd8zzu9rgpjQxM8V7Zi5PUOdSjavcHle88WBoHUhWeriwl2BMJwJ769ky8KYr9UNxSHgzuObp5GhGo3kdKZW34OnjJsWEEoxnaQpOeM5EkehrL4tC/6z4u4FZjHD5e0IMM4j0RxWfaohBaNVeUkfViaSRL1BpsoLXWa9TmgQK6MwHBhZ3KR5rqGA4TrqswP7M24PSuGWlZD5vEY/9CpUObI7kTavhUulwgeOtPJVt7Lb3el/eCg6HzMYA/Ozsv6+vJW96u0mh/jWV+pgk6yv6R2zFY76KDe2SfIV4nQ7nMmvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U0L/OzmWMAPUStiAObxzJCU3WL2Vb1EzEQnv9uQWenk=;
 b=Y898eQ1KvlKtBruNY69HAM3dZsziZeRmviVWKkPdyzj5EnyuqBjwIdZp8myix+8Ym2CuRd6oXbTZrFNu1Zt1ppw8oIfOfyVSJD8yRz9ytdtmqWIzq6R7yXBaJ7Zq98/qojmZWD4ECyPDzpYMgnCQcy9ZcEXUVJyiUb96KYJLXmM=
Received: from SN6PR11MB3184.namprd11.prod.outlook.com (2603:10b6:805:bd::17)
 by SA2PR11MB5068.namprd11.prod.outlook.com (2603:10b6:806:116::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.19; Thu, 4 Feb
 2021 17:31:11 +0000
Received: from SN6PR11MB3184.namprd11.prod.outlook.com
 ([fe80::ac4a:f330:44cb:fbf4]) by SN6PR11MB3184.namprd11.prod.outlook.com
 ([fe80::ac4a:f330:44cb:fbf4%7]) with mapi id 15.20.3805.028; Thu, 4 Feb 2021
 17:31:11 +0000
From:   "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "seanjc@google.com" <seanjc@google.com>
CC:     "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>
Subject: Re: [PATCH 07/12] KVM: x86: SEV: Treat C-bit as legal GPA bit
 regardless of vCPU mode
Thread-Topic: [PATCH 07/12] KVM: x86: SEV: Treat C-bit as legal GPA bit
 regardless of vCPU mode
Thread-Index: AQHW+omuBE5yjAcpaU+GTJSpysfjUapHPrkAgAAEi4CAAIo6gIAAdHwA
Date:   Thu, 4 Feb 2021 17:31:11 +0000
Message-ID: <e68beed4c536712ddf28cdd8296050222731415e.camel@intel.com>
References: <20210204000117.3303214-1-seanjc@google.com>
         <20210204000117.3303214-8-seanjc@google.com>
         <5fa85e81a54800737a1417be368f0061324e0aec.camel@intel.com>
         <YBtZs4Z2ROeHyf3m@google.com>
         <f1d2f324-d309-5039-f4f6-bbec9220259f@redhat.com>
In-Reply-To: <f1d2f324-d309-5039-f4f6-bbec9220259f@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.3 (3.38.3-1.fc33) 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.139.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c358900f-da92-4bda-f704-08d8c932aa46
x-ms-traffictypediagnostic: SA2PR11MB5068:
x-microsoft-antispam-prvs: <SA2PR11MB50688DF4063874479E71918AC9B39@SA2PR11MB5068.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oVinA0ftOzRjD2XM9t5oq2jNWXHWuYvrFBJ/rWfuCgHP7PjNqUekwfXnmx8kIqFcbhng9w303iKUiCgdWT1X+VG3HeDfc+AgC048g8NGic4JhmH8F3VojtG1Pp7V/dD0tsEH0JcU80HDWZ2F0k49b+7q+LuDht/gzbPn3revUXy/QHenms2hsaQhZk/xMo6DMVPZKgFLUHre84LXvG+hAx2MBIXodBZ19MeNxQQRNeVe8C4+WtBwMPr6ha9gCeO+5gxHWGVN+Vs6mqp1ZZfHMnlbQwnw0S089m25U3MMk4d1YnHHh/+vGnt98j5xFMoz5QEVjZokjXIrqxrz/NYZ1P4pZS66I3vmt6UfBi9eoGFFPLa6Yb2+y87lN+ZR17iD+5kdIrl8sNpTv5qmdAMD3kdqCQadhlDcnlZ7T+NrC2zYgSh2rwaD+D3Ttu6Ee6ErVmZhm9IvOj1zD9AksMpt6Bgb+yjGFn4K+nqHYOkUhMT+80zo1tZL6sEw1PsZE3BDBymY1PJYJyabYzxOg6zEs5avEc3vkc4FEAheCNgwxB6D1Gtf63NcdALrVDNG9RLU
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3184.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(346002)(366004)(136003)(39860400002)(6506007)(53546011)(66446008)(186003)(76116006)(8936002)(8676002)(66946007)(6512007)(86362001)(91956017)(71200400001)(2616005)(316002)(64756008)(5660300002)(54906003)(36756003)(110136005)(66556008)(478600001)(7416002)(26005)(66476007)(4326008)(6486002)(2906002)(26953001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 53063fcBARt8CpDYlrTEGp1veTFJdrwRtTzejaBeyLtMF3oU9wrB6O2IAFlN1sXxdydti6JBPEWROHaxOluFEaxB7hCi6SBhcW7n1Ex/U+yoBy5ohFnxto8iigFByDQ2gbLpmhOlXz+hXT/Mqz52X4kunSNya66mpjIJmWlOqKtDNiTlwKjantN+D0rZlnUBeuQOXaLQ1lvLnT+2R4he6vRkPiAreHobvjeUAL202ydvu5hhlGkvfu8UZee0+RMrlPuGNfkpJ2aKA4AaxLxr3vO9ay4v9s2+CkRJStHC1qcRYIMZZvNi9ZU2kXFEWKKJAHbq29a15agb6Sjb3jAXdMqPaXmNV5adHeNc6vz8xd/vgg2ShMwIxbesIyYXpmFJ3NYyCv6SJQv6IseSPwnEp8G9tM4idjQrefuqs2xeed99BN5fMnfPJ+scZ61fjAJDas5mrcivL1+I/m3KN4qIVwcOdWWzNmPmQPGnTy2nWLtEh/yl08blYoHZ+3aWMVUNrN6m8r65D+d6b4oVTvDv+GPq6dbsBt4m0HpAzx4kN9Tlfz05FAcqm1Al/RCVm4i3jkolquiK+tpqiVbCgb9vIagp6vz9SOnG+A0HjwsjC5SFnmM/p046aXpmIa+AXJbAmIRHL1JteTtcVf817pyEg3ddy0+RK65PXbPA2Qvr0PyGgzJjNk/twVEZKWzRzO82AH4j/geWitJKnEOPCit50wQbwdOwKqXNlJ7WmjZcqN7Z4FFp+ZsPwidtZCqPZUf2
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <92F6C51863FB40408AC12E0F660A147D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3184.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c358900f-da92-4bda-f704-08d8c932aa46
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Feb 2021 17:31:11.3401
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +avXqYgJjLmLddiyzUJSMCnWSaSxUZLLjhplNP3omfnf+don0NO6uIRJwffC1J8baxKiBiiXbzc0BzkpcKJHJIX8DOqSzgMBgBlcBfZYhRQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5068
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIxLTAyLTA0IGF0IDExOjM0ICswMTAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiBPbiAwNC8wMi8yMSAwMzoxOSwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToNCj4gPiBBaCwg
dG9vayBtZSBhIGZldyBtaW51dGVzLCBidXQgSSBzZWUgd2hhdCB5b3UncmUgc2F5aW5nLsKgIExB
TSB3aWxsDQo+ID4gaW50cm9kdWNlDQo+ID4gYml0cyB0aGF0IGFyZSByZXB1cnBvc2VkIGZvciBD
UjMsIGJ1dCBub3QgZ2VuZXJpYyBHUEFzLsKgIEFuZCwgdGhlDQo+ID4gYmVoYXZpb3IgaXMNCj4g
PiBiYXNlZCBvbiBDUFUgc3VwcG9ydCwgc28gaXQnZCBtYWtlIHNlbnNlIHRvIGhhdmUgYSBtYXNr
IGNhY2hlZCBpbg0KPiA+IHZjcHUtPmFyY2gNCj4gPiBhcyBvcHBvc2VkIHRvIGNvbnN0YW50bHkg
Z2VuZXJhdGluZyBpdCBvbiB0aGUgZmx5Lg0KPiA+IA0KPiA+IERlZmluaXRlbHkgYWdyZWUgdGhh
dCBoYXZpbmcgYSBzZXBhcmF0ZSBjcjNfbG1fcnN2ZF9iaXRzIG9yDQo+ID4gd2hhdGV2ZXIgaXMg
dGhlDQo+ID4gcmlnaHQgd2F5IHRvIGdvIHdoZW4gTEFNIGNvbWVzIGFsb25nLsKgIE5vdCBzdXJl
IGl0J3Mgd29ydGgga2VlcGluZw0KPiA+IGEgZHVwbGljYXRlDQo+ID4gZmllbGQgaW4gdGhlIG1l
YW50aW1lLCB0aG91Z2ggaXQgd291bGQgYXZvaWQgYSBzbWFsbCBhbW91bnQgb2YNCj4gPiB0aHJh
c2guDQo+IA0KPiBXZSBkb24ndCBldmVuIGtub3cgaWYgdGhlIGNyM19sbV9yc3ZkX2JpdHMgd291
bGQgYmUgYSBmaWVsZCBpbiANCj4gdmNwdS0+YXJjaCwgb3IgcmF0aGVyIGNvbXB1dGVkIG9uIHRo
ZSBmbHkuwqAgU28gcmVuYW1pbmcgdGhlIGZpZWxkIGluIA0KPiB2Y3B1LT5hcmNoIHNlZW1zIGxp
a2UgdGhlIHNpbXBsZXN0IHRoaW5nIHRvIGRvIG5vdy4NCg0KRmFpciBlbm91Z2guIEJ1dCBqdXN0
IHRvIGNsYXJpZnksIEkgbWVhbnQgdGhhdCBJIHRob3VnaHQgdGhlIGNvZGUgd291bGQNCmJlIG1v
cmUgY29uZnVzaW5nIHRvIHVzZSBpbGxlZ2FsIGdwYSBiaXQgY2hlY2tzIGZvciBjaGVja2luZyBj
cjMuIEl0DQpzZWVtcyB0aGV5IGFyZSBvbmx5IGluY2lkZW50YWxseSB0aGUgc2FtZSB2YWx1ZS4g
QWx0ZXJuYXRpdmVseSB0aGVyZQ0KY291bGQgYmUgc29tZXRoaW5nIGxpa2UgYSBpc19yc3ZkX2Ny
M19iaXRzKCkgaGVscGVyIHRoYXQganVzdCB1c2VzDQpyZXNlcnZlZF9ncGFfYml0cyBmb3Igbm93
LiBQcm9iYWJseSBwdXQgdGhlIGNvbW1lbnQgaW4gdGhlIHdyb25nIHBsYWNlLg0KSXQncyBhIG1p
bm9yIHBvaW50IGluIGFueSBjYXNlLg0KDQo=
