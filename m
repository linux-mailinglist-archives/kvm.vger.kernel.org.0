Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B023D464782
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 07:59:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240129AbhLAHC5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 02:02:57 -0500
Received: from mga17.intel.com ([192.55.52.151]:42541 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231401AbhLAHC4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Dec 2021 02:02:56 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10184"; a="217091939"
X-IronPort-AV: E=Sophos;i="5.87,278,1631602800"; 
   d="scan'208";a="217091939"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2021 22:59:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,278,1631602800"; 
   d="scan'208";a="654664909"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga001.fm.intel.com with ESMTP; 30 Nov 2021 22:59:35 -0800
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 30 Nov 2021 22:59:35 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Tue, 30 Nov 2021 22:59:35 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.170)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Tue, 30 Nov 2021 22:59:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BxNkVEkNqefeSzTE7o0ZKV8fQ6zLnWbU2NciM5qyFbS/R1Zp9DVCnDPDjoMSnA/tewF9VV9ooVy5tAsvsM+5legaBsXtHDytuOo5UiJgHdCrjw9ntPvosfAq20OPcVqRNqo6Cjn3Odd9AfmLgsg3BfeNYvMfxvD4/vAxBQlmzNi/NUmJLbNnbHin6O/M6ZRBU4SYIvLq9mXszeCqwrI8GAJt5NTF4JknQ2ldI7Nv22Z0pfxBWa2Zms6OKzQEn9kTCC6RjRDnxuO8CDaZyFQBChoxwLK66eD5Y8bGBi7IgaXZLIGoYVexNd35Bh1bUD1C1TB/ijAl/atfB5fIfIq9TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4+WPrxfvCUCRTRhtmkFXvmAkF4k4g5aul9wwwVkORe8=;
 b=LZuUNNHc1N4gsszSpF+1xsQyLld500ZvA/72NpDZ1WkdX3IlT2Vo1i8IGTgzVnw5zStDTt87ANqPgr8uDnUUSeWsJ/s2PtxEffWjG1LXyt97t1dlc56IOQffji4rqoGTsPsZH53uwyCEpMmNcNB38vgbBqCqciUwU+a7+gGZlI+UakNOVwUjKhp1puaojGPQ2+gmPlwWfGeHn/lAw/LZlA/aj9PpSpHSwtgFB8DTx08qISWE9glTWVDNhtVol/9Ado1RIFpJizcS+4ikjL0Kvwrju8jzXUeD9CcWLYd6OLwEdwOp9rcKKtZ0uBRP2mJyAUU749RuEmTpLO+0RcZ7Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4+WPrxfvCUCRTRhtmkFXvmAkF4k4g5aul9wwwVkORe8=;
 b=yPMPiXqpLkqwXh/NoV5LVZMvIWxBUU0MoDjjossgFovLrdlj/1NFsPOh+tvPa/WHLYXPAKl4zNHOlxkIQgINrH5GksaEmhyzUCyTmP68VFW/QoZA3zXm3wX6sBeWcX1sdcc6/ZVzyBZas6RKLJAD1Gcl9q7JK6UzuIyBLcvmMNg=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN8PR11MB3762.namprd11.prod.outlook.com (2603:10b6:408:8d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Wed, 1 Dec
 2021 06:59:33 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::3d42:a047:dc28:e92b]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::3d42:a047:dc28:e92b%9]) with mapi id 15.20.4755.014; Wed, 1 Dec 2021
 06:59:33 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>
Subject: RE: Q. about KVM and CPU hotplug
Thread-Topic: Q. about KVM and CPU hotplug
Thread-Index: Adflvg/SIgoQKcU9QlaunmfcAiKUJgADptsAACzuVmA=
Date:   Wed, 1 Dec 2021 06:59:33 +0000
Message-ID: <BN9PR11MB54333C976289C4AA42D7B1AA8C689@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <BL1PR11MB54295ADE4D7A81523EA50B2D8C679@BL1PR11MB5429.namprd11.prod.outlook.com>
 <3d3296f0-9245-40f9-1b5a-efffdb082de9@redhat.com>
In-Reply-To: <3d3296f0-9245-40f9-1b5a-efffdb082de9@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 331f0f21-d21c-48db-43c1-08d9b4982126
x-ms-traffictypediagnostic: BN8PR11MB3762:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BN8PR11MB3762BE6D95821DD7F8A2B9EC8C689@BN8PR11MB3762.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pXjyRoDp1ZOHYih1rIWhvTX5NjNS/J015C222QJBSTB4wYIsb3GDezP4haYo/Vr4LJjqzjZIt134QQyvQyoiHbvQCKj8rkEpdA5iQMF5nhgWuwsJtx4g9eeISR1EqgWdjvZjkB/WvUdlXi6RIVM9glef7XI6mEbVaoKdPZlqyQnZY9Sw8y8BEni0DUZ0+HMgyy86Sw/wZ60LWa9Ne4CPxoYI7Wbm/7nGDWhJDggIylkUtlm/TEAfTXqYLQl12U//febvOzRU01Q79YCe78xG5AA5kL5VWjrHyeLA6WhlKOaI1dEMkz9WGJBafxgn0BZ54GAczlxOqWc6AscLa3YS+agtjsRo5Y1rdy/h93qhznicMaZMzsKfl+loW1G3UN1YxzOqed4zoQdFtwSrkz6NUujQwxq/ufzji7k4oG/23rCGnmKMatifRsom0kJk09rM0Lhv8uC6JikoZ6RbRUYk48b+GQI7UzrwAXO0yTwnUest2xNVp+R1nM24HtJy/ykCxMDKJ1n2jJb3oOR5gfIyEwRk4GZ7zpfH84EJnVH5VNBctBqEetU3QXC3hWbe57Dg24+yIipqz6oaqLH37aJLN+yoQl8cN8Ha6+FOQ99H7GBia6u5AM33L32zQAvKhUOvbFxrABb/w4pOsaJ+ColxmrwvpeynQscgHgNRbfmv8aexEcmDsp04F9b9YQ8p3ND39xhDN8Y0TSdH9XHlyCFPRw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8676002)(66946007)(33656002)(38070700005)(5660300002)(110136005)(66556008)(6506007)(64756008)(107886003)(86362001)(66476007)(66446008)(76116006)(52536014)(71200400001)(54906003)(2906002)(186003)(8936002)(4326008)(26005)(508600001)(53546011)(82960400001)(9686003)(55016003)(122000001)(38100700002)(7696005)(83380400001)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UVNuNXpubHg2a2wwTTdXVm9JczN0OFFYUGUxdzdZQ0ZuTGtwNU5lOFdMckdU?=
 =?utf-8?B?NkZ2QnZPS3UzcWJZdG9nSW9UWUg2SG9EdStTTE5MN1VmeHdwNW03dDVyL1pt?=
 =?utf-8?B?WFlWSktpejJ3bE5qdUtkazlhNjRjRmtTdVZZcnlQQjZBMzdLN2NOeUY3Tmxv?=
 =?utf-8?B?NzN4OXp5NWFHTkZNTUNPU2ZDdXVzMjR0TmJzZzBqUkJGMXY2WmZVOFZOd1JT?=
 =?utf-8?B?cGtnNEx0N1htbUJTNTZubkVRNXIrVW9HS1pmSGdVVDU3aDRXcExyOWl2Ylph?=
 =?utf-8?B?YlRlTCtkd2ZTV3pPWTRNQ0xjK3c1LzRTMXpKTnpwMFBwY3dWKzdrU21HWnVn?=
 =?utf-8?B?dHcvcnRzTEswOHhpR1Y1ZU9JNDlrWWNHSXJwMS9rbWhKamREZXNod3pDU1VV?=
 =?utf-8?B?amcyaFhnMFc0Q3hzNUN1QVFEbS95NFRuRGROZWx5MHdBVG1lWE5OWWs0aWpQ?=
 =?utf-8?B?MXh4ZXJydThJcnhGMEFyMTJqRm05RnBUaTl6c2NxZFhzZDRSSkc2RzJjUHRh?=
 =?utf-8?B?SEsrU3BlZmY0a3JWSUNQWGhNQXBsZExjLytreWFSQkh3MFVhMzJLajNDRUxG?=
 =?utf-8?B?aWEyeDJtMUg1SjZlVmYvZUFVTXVZbzRSd0tvTi85N3FaVklRa0NoYnAwaVNr?=
 =?utf-8?B?aUhPZ1FtalgxTm4rbENMUWtpMnZXNXJ0L0QwRml1dU1BeDVMU1ZOVThmenRK?=
 =?utf-8?B?QXp6VnNLSC9NVy9wQTZsVTJMcUYzbjBLNllnaDFkdnZiZDcySlhTdWlQaFh2?=
 =?utf-8?B?dzJNTGEvZkt3Mjd4SzNobkloTHhtc2dmWUtlWDJWTWZoSHhoNU5QY1J0cGVL?=
 =?utf-8?B?dmVZMEFrMy9hRzZBZUdraTRIbC9GZGJJRS9qbkFVT0szT3RvNFR2K1BONDZF?=
 =?utf-8?B?MjBqOXdibkc3SHRzMjZ3WEVvQjRmbnhyYXZzZEVEakdkMUt2VVJRcDIyN2Zm?=
 =?utf-8?B?S1RZRXc5cXlyZUR2b2FxRkJKWTdQdHY5T1B2SzRQdG5DczNZdU9SL1RMNmlR?=
 =?utf-8?B?TXBaZE80NkFXZnliS0tLdHFmQVRaTzZUS1ZBZDJlT0tESTJqUFhINGlTVkJV?=
 =?utf-8?B?M0loTFJRZkRvVlgzRGlleUl5bDc4NnM3S2xwRDl6VmxmK25Ldk81eDNPdlhT?=
 =?utf-8?B?OEp6RVpKYWZLV3RXUS9qdHNJQjR6RFZDQmhlaTdTaG9WUGVsdnBCRTZBb2d6?=
 =?utf-8?B?RGRvWjNLVFg0elZxTmhBNWlwdURraTdaZnUrSDZucHhGN2JEbVl4RnlXd1lV?=
 =?utf-8?B?Sll1bFlodzkvMFFtaW9IMWhCY1QwNVZHVjdPVHp1ak9zR0ZyWVhTN1dRSkdq?=
 =?utf-8?B?L3dKVjl1d3d1S3VyL3pMaU43elI3WUVjRlV5VytCVmJNVEM2anFVd3pETG5h?=
 =?utf-8?B?NFM5RzFXalhNU3hTVnEwK2Q3QVBJUDRtMm1PSk9HdTVvL3NoeEV2MkJHa2ho?=
 =?utf-8?B?SUg5SFpyZ2VGTnNWb29QREJvZmVMdTR2WGxDMkczU3VwTWcvNTR6MGc2eEgx?=
 =?utf-8?B?NllPdnladUtsSUtjL0lBN3FETjBWazNveWJONDNaclk2YTQvUHJuMDdobzVU?=
 =?utf-8?B?dWVkOGNKMXR1REttUHczUktqd2hhRDFYcHVhSC94WDk5ZEZBRXh0WGs2RnUy?=
 =?utf-8?B?eWE3T0g3Y3NVeHZ2WnBKOU1iRDdGdm85dVVXZ2tTbDlRa2E0R292c29hN2Mx?=
 =?utf-8?B?V0JZNDRqdnAyakIzUzZLWmJUckZMWXdnUDdDN1ZmSmpUR1hxVm81ZGp0b2pq?=
 =?utf-8?B?bzJ5NzgzR2k2YzIyUklWN1Fuc0M3OEVZSDliaDNEMUVYTjZVcTF4L3h2clMz?=
 =?utf-8?B?Ulo0OTNsWmk5cDEzM2FwUzduQTF2N0Y2MTQyOHIyanAvQjM5OHlWZkhudklE?=
 =?utf-8?B?TXZnak9XbVNEeWV1YXM5SzFMbDljY3U1TitObzF2QjlsQWpNUW55MTFDRW1i?=
 =?utf-8?B?aUR3MTRGVXI2SW1wamFsK2VJbFFHcG41SjBkZEhrZExZN2pVeHZ1ZzNiaUdh?=
 =?utf-8?B?M1hDbkppTFFyanRPNmlsOGFzMVFEbzU4Z3QwWXFWYURIZ3pwcllzNEl5eGw0?=
 =?utf-8?B?ZEMyR2g5Y3gvVzIzQ0xCM0c2MkVjeUczSnEvRGNSeVhvWnZmbmVFUUFDTXNI?=
 =?utf-8?B?N3Vkd3hlNVM4REJWWnNvQ1ZCL0hRbkJVY3hFV0FuNVRVVGs0VWJrbE5pNXBj?=
 =?utf-8?Q?OE85s6zQ3vo2TKltthqItGg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 331f0f21-d21c-48db-43c1-08d9b4982126
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Dec 2021 06:59:33.2316
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j1nvTIxeSNPhx8aXACC83TwiJNVrK0ri33sZrdnKoZUNyuhVky23Dct62aIioENUH4bTpNcPTe/zFb+JplcYEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3762
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBQYW9sbyBCb256aW5pIDxwYW9sby5ib256aW5pQGdtYWlsLmNvbT4NCj4gU2VudDog
VHVlc2RheSwgTm92ZW1iZXIgMzAsIDIwMjEgNToyOSBQTQ0KPiANCj4gT24gMTEvMzAvMjEgMDk6
MjcsIFRpYW4sIEtldmluIHdyb3RlOg0KPiA+IAkJciA9IGt2bV9hcmNoX2hhcmR3YXJlX2VuYWJs
ZSgpOw0KPiA+DQo+ID4gCQlpZiAocikgew0KPiA+IAkJCWNwdW1hc2tfY2xlYXJfY3B1KGNwdSwg
Y3B1c19oYXJkd2FyZV9lbmFibGVkKTsNCj4gPiAJCQlhdG9taWNfaW5jKCZoYXJkd2FyZV9lbmFi
bGVfZmFpbGVkKTsNCj4gPiAJCQlwcl9pbmZvKCJrdm06IGVuYWJsaW5nIHZpcnR1YWxpemF0aW9u
IG9uIENQVSVkDQo+IGZhaWxlZFxuIiwgY3B1KTsNCj4gPiAJCX0NCj4gPiAJfQ0KPiA+DQo+ID4g
VXBvbiBlcnJvciBoYXJkd2FyZV9lbmFibGVfZmFpbGVkIGlzIGluY3JlbWVudGVkLiBIb3dldmVy
IHRoaXMgdmFyaWFibGUNCj4gPiBpcyBjaGVja2VkIG9ubHkgaW4gaGFyZHdhcmVfZW5hYmxlX2Fs
bCgpIGNhbGxlZCB3aGVuIHRoZSAxc3QgVk0gaXMgY2FsbGVkLg0KPiA+DQo+ID4gVGhpcyBpbXBs
aWVzIHRoYXQgS1ZNIG1heSBiZSBsZWZ0IGluIGEgc3RhdGUgd2hlcmUgaXQgZG9lc24ndCBrbm93
IGEgQ1BVDQo+ID4gbm90IHJlYWR5IHRvIGhvc3QgVk1YIG9wZXJhdGlvbnMuDQo+ID4NCj4gPiBU
aGVuIEknbSBjdXJpb3VzIHdoYXQgd2lsbCBoYXBwZW4gaWYgYSB2Q1BVIGlzIHNjaGVkdWxlZCB0
byB0aGlzIENQVS4gRG9lcw0KPiA+IEtWTSBpbmRpcmVjdGx5IGNhdGNoIGl0IChlLmcuIHZtZW50
ZXIgZmFpbCkgYW5kIHJldHVybiBhIGRldGVybWluaXN0aWMgZXJyb3INCj4gPiB0byBRZW11IGF0
IHNvbWUgcG9pbnQgb3IgbWF5IGl0IGxlYWQgdG8gdW5kZWZpbmVkIGJlaGF2aW9yPyBBbmQgaXMg
dGhlcmUNCj4gPiBhbnkgbWV0aG9kIHRvIHByZXZlbnQgdkNQVSB0aHJlYWQgZnJvbSBiZWluZyBz
Y2hlZHVsZWQgdG8gdGhlIENQVT8NCj4gDQo+IEl0IHNob3VsZCBmYWlsIHRoZSBmaXJzdCB2bXB0
cmxkIGluc3RydWN0aW9uLiAgSXQgd2lsbCByZXN1bHQgaW4gYSBmZXcNCj4gV0FSTl9PTkNFIGFu
ZCBwcl93YXJuX3JhdGVsaW1pdGVkIChzZWUgdm14X2luc25fZmFpbGVkKS4gIEZvciBWTVggdGhp
cw0KPiBzaG91bGQgYmUgYSBwcmV0dHkgYmFkIGZpcm13YXJlIGJ1ZywgYW5kIGl0IGhhcyBuZXZl
ciBiZWVuIHJlcG9ydGVkLg0KPiBLVk0gZGlkIGZpbmQgc29tZSB1bmRvY3VtZW50ZWQgZXJyYXRh
IGJ1dCBub3QgdGhpcyBvbmUhDQo+IA0KDQpvciBpdCBtYXkgYmUgY2F1c2VkIGJ5IGluY29tcGF0
aWJsZSBDUFUgY2FwYWJpbGl0aWVzLCB3aGljaCBpcyBjdXJyZW50bHkNCm1pc3NpbmcgYSBjaGVj
ayBpbiBrdm1fc3RhcnRpbmdfY3B1KCkuIFNvIGZhciB0aGUgY29tcGF0aWJpbGl0eSBjaGVjayBp
cw0KZG9uZSBvbmx5IG9uY2UgYmVmb3JlIHJlZ2lzdGVyaW5nIGNwdSBob3RwbHVnIHN0YXRlIG1h
Y2hpbmU6DQoNCiAgICAgICAgZm9yX2VhY2hfb25saW5lX2NwdShjcHUpIHsNCiAgICAgICAgICAg
ICAgICBzbXBfY2FsbF9mdW5jdGlvbl9zaW5nbGUoY3B1LCBjaGVja19wcm9jZXNzb3JfY29tcGF0
LCAmYywgMSk7DQogICAgICAgICAgICAgICAgaWYgKHIgPCAwKQ0KICAgICAgICAgICAgICAgICAg
ICAgICAgZ290byBvdXRfZnJlZV8yOw0KICAgICAgICB9DQoNCiAgICAgICAgciA9IGNwdWhwX3Nl
dHVwX3N0YXRlX25vY2FsbHMoQ1BVSFBfQVBfS1ZNX1NUQVJUSU5HLCAia3ZtL2NwdTpzdGFydGlu
ZyIsDQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGt2bV9zdGFydGluZ19j
cHUsIGt2bV9keWluZ19jcHUpOw0KDQpUaGFua3MNCktldmluDQo=
