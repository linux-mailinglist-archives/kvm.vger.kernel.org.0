Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A244F476EC4
	for <lists+kvm@lfdr.de>; Thu, 16 Dec 2021 11:21:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235975AbhLPKVy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Dec 2021 05:21:54 -0500
Received: from mga11.intel.com ([192.55.52.93]:62148 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235936AbhLPKVy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Dec 2021 05:21:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639650113; x=1671186113;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2l127/kYCB6MjEjLBdtQkLdyJz4SqAtUq+uXf/aT4Gk=;
  b=Bmn7eVT3b+J/Hr5WchUzBvTgD1lC9Nl7Ro12hOpSwqbmJSZmvyDL/pTt
   jluUtsjj6ussXSc1TPuoxh3rjNEDidSd5LBiTjFpESaySqpU/3g3ifPoV
   JKziGK2fP/8GurwFoSxk9XzcH4FGjjjWVZSzL2Ie84RRr0P4WtVVeEqF+
   DutHJDvzA3TfkIrbTlDoRTutSHqAsMLinRg0XIu7QQfT/64ItK+RVUElA
   ernaOOAoZxoCYo/alhwO7vawQwF4LGhJGteqh+Qk4Nq8Ca9xSMiJIyKrj
   wQlHEGVoyO9elH6wpHxbhrXyPFSazZzfDNnOCLRwEFk4pJKEqCwDkLX6O
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10199"; a="236995787"
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="236995787"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2021 02:21:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="464623420"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga003.jf.intel.com with ESMTP; 16 Dec 2021 02:21:53 -0800
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 16 Dec 2021 02:21:52 -0800
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 16 Dec 2021 02:21:51 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Thu, 16 Dec 2021 02:21:51 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Thu, 16 Dec 2021 02:21:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YswuAlZycVDgeiw4LcXC55AsTLmcvdL5BERAyO29D4i+gPQbYTbuP3asbtBQqrXrSXFdQrZMPvl2lcuMNYjk2rwKwiE0aK0QNsRiGK6hY9nP3De1SOm0xBPNpKSIq0cVpbGrYEt2hzUZ1rx85jjsKO3nDu28eGdmQ3LlZlMtUSCttyPHOf7WpRk4z79RQDAPmrv1DCkgG1pjNo4NXf4k9eixr23J7zevCRZWIgbZW90hXEcS5jj2VFuneocREN1/H5ertnAJUUonVpTEc6Yk0piVa/y03i61dzGJxLdB0f5J0JPo6tft0vtJFzTEv+NYgDMZCxq9PjB80Q+ZEd4eBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2l127/kYCB6MjEjLBdtQkLdyJz4SqAtUq+uXf/aT4Gk=;
 b=Puizmq2G4rFpCJYrQNg/6DxccCniiFSgmEZlmJknREu7kJ1+uQZ0rmRuRfiS2e79TD6i5N3iZZAHqVu2APfAIItJDYXjvgOLu4yw1ohDuE+UItApsae9k3p1DiJOyxMXb2etcKl/+dfXKIYJxxR9pR0mHJKD8mlcUGBaw9H50o5WGWA07BgXL0imckR8MNtE27J0NsZlCX2nQUIBvFugAFrbj+7ZU3702VX7MFBz1uJ5t8v//12mEeq7eqwsWXuKe76UxHw0siakqI5Y5eJg583EAf0f/HMnhXew/mkX/hIZR/V+1C5mdredbVY8X+/jOCxg5AvWizZm9DNIQFo7tA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN6PR11MB4177.namprd11.prod.outlook.com (2603:10b6:405:83::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Thu, 16 Dec
 2021 10:21:48 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04%3]) with mapi id 15.20.4778.018; Thu, 16 Dec 2021
 10:21:48 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        "quintela@redhat.com" <quintela@redhat.com>
CC:     LKML <linux-kernel@vger.kernel.org>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Jing Liu <jing2.liu@linux.intel.com>,
        "Zhong, Yang" <yang.zhong@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "Zeng, Guang" <guang.zeng@intel.com>
Subject: RE: [patch 5/6] x86/fpu: Provide fpu_update_guest_xcr0/xfd()
Thread-Topic: [patch 5/6] x86/fpu: Provide fpu_update_guest_xcr0/xfd()
Thread-Index: AQHX8JViV3rUbi5iYUCgo3JeBUJUo6wyGCEAgAAIi4CAAAi/gIAAH5YAgAAT0FyAABRSAIAAEuhSgABOroCAAIPaAIAABQ6AgAADz4CAAYge0A==
Date:   Thu, 16 Dec 2021 10:21:48 +0000
Message-ID: <BN9PR11MB5276FE9D7F220C60DFB328428C779@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20211214022825.563892248@linutronix.de>
 <20211214024948.048572883@linutronix.de>
 <854480525e7f4f3baeba09ec6a864b80@intel.com> <87zgp3ry8i.ffs@tglx>
 <b3ac7ba45c984cf39783e33e0c25274d@intel.com> <87r1afrrjx.ffs@tglx>
 <87k0g7qa3t.fsf@secure.mitica> <87k0g7rkwj.ffs@tglx>
 <878rwm7tu8.fsf@secure.mitica> <afeba57f71f742b88aac3f01800086f9@intel.com>
 <878rwmrxgb.ffs@tglx> <a4fbf9f8-8876-f58c-d2b6-15add35bedd0@redhat.com>
 <8f37c8a3-1823-0e8f-dc24-6dbae5ce1535@redhat.com>
In-Reply-To: <8f37c8a3-1823-0e8f-dc24-6dbae5ce1535@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0dd9f663-2d7c-4e4b-eac3-08d9c07dde9e
x-ms-traffictypediagnostic: BN6PR11MB4177:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BN6PR11MB417745D8853C0E469B7E36528C779@BN6PR11MB4177.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: e8BaA5A0OIiSuChg6BVf9JnQlcGxVSD0D+Yb82yN/ueQ6rXRDwnNd8eXPEB6FZTQLx6cqGHt48msD7Je3JTbd3YCU0qOr6IQ/2KZL/5iB+V9QX+8O728Ar8T70Orvrua0LiWocROIuzoIfHi5vU7mIL8XW3C+xGMzoj/TUZR5YJLKwxDOSvuE3RGPhOdGKdjglO1z76IQlIl4b7K1IUj3YNkQZMkq3cfqKS36LLEsroqxMy4OXgUXq7S6opS0oBmg4s6vpFOGUK7HjXT0jgQQvg2XKuXh/I97M+nTPIIGPJqsg7NIzBr+O6jKmpG4Fe8OlF8OegLOsftbuNhHQCujBxlJGgSYsQDjOpN5DyQrC/pUDHfgWish+NE+7vN0p+VUliz8+VPhc70LMOyWkiT9XRuyOHxR7Al+/ybA4iGSKlJ1AAOTDp3BdFLRG51MFn3Sc4Zf1BIDTWtporDJQkPWtO20vyW7HRoUGh+pZUfvgFIR4nFgvaV30DiIZ78aB/Obi6wFan7P+NBYU3dPeyI8PqHNGfJUxz5yqPGAo3I7W0EKJqgQK9LlqNvc1v6ZOM8ocrbWvEHnfZxMrvsaq9hTOUDKHKgcWr0QV/8KmIkJEOdCAT72I+gxzzFK1RmBovF6dCNiflDPe2hw9eMlvruIDY48WuKiWX30PB0K5wQ98iFZuTFlipPH6ow2qP5+KHLMyL32dCtzxakl8AIqN8T5VIYX0TKC42obuINxwFRUeUgaaV2bIpSuU/FCzClPyFp6VQIP37rOD4a1z2mqv/yMYUNruwOa/3aoZKqP67oyNM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(9686003)(54906003)(4326008)(33656002)(7696005)(110136005)(52536014)(55016003)(6506007)(66556008)(66446008)(66946007)(64756008)(76116006)(122000001)(83380400001)(82960400001)(66476007)(38070700005)(8936002)(966005)(86362001)(38100700002)(186003)(316002)(71200400001)(4744005)(508600001)(5660300002)(8676002)(2906002)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?STZIdmJZenlKRExXZkZrQVhKemlZQ0Y0UXBQL005Mnk0SGFpM0U3Y2Nxaldp?=
 =?utf-8?B?T3hzb1FjKzJ6d2RWakQxK0F0UFFMUUlCRDkydmtqZUhNdXBSZ3RPQ0FFVVZy?=
 =?utf-8?B?WUFLbjRKMDZRNHV2Z2p3S0tXcnZzOHpkaWNtTTRGemZiUWtiVlNCZEt1aDd6?=
 =?utf-8?B?NjN6aTV0bkYvQ0N6aEgzS0R0YnB0WkdYN0VKOERkdGlBLzRZZGlObnFjSTA5?=
 =?utf-8?B?cGtqRnRSa2tBUVd1RXFRdTV3U2oxUFlqeVJtTC9saHY3R0lhS2Z6THZTZnBV?=
 =?utf-8?B?SHg1Y2J2cXdDanJnVFljSDllZFNYSi9RaXJDbzRuSUpOTCt6ODByd1VBUndo?=
 =?utf-8?B?QkhzcG9XSnBWYWp2VitudENpYktpWWtNSWUvLzI4emIvVVNJa2RaWjl3TzRr?=
 =?utf-8?B?Y1VPYW5ITmdXSGVXUDl5dmlqRzkyMVdQc1djZlRTdURzSFFWb3pacDVKMUNK?=
 =?utf-8?B?QXovN3lYQ2puYThWM1NYd2YxY1NxQ3dxVzk2ZlQrY2U4Q0U4UGNUVDdHZGJW?=
 =?utf-8?B?Y0hpNzBackU0RWg4azFocDVIM3U1Mkd4d2o3RHpPOERUZXROTUdLWFcxdCto?=
 =?utf-8?B?Q2N6REVpNS8zUjloajdRYW1USGdNejkzYzZFU00yejRjOE5zejF5YURKZmtE?=
 =?utf-8?B?dHdaMEJoMkdKcHFqcTJNVWZka1FId0MrcFZZeWlDL1Q2M0hwTnlXcGk5MWxT?=
 =?utf-8?B?REdPQWRWVElFZllTSXcrSWJ2cWQyR2pzeW1uQUYyZkhiVEhQZ3ZsUVk4SjFt?=
 =?utf-8?B?SXppZ3VDR2RZZlg4ejM0ZTNNSzhzMFRBemNTQ0Q3VkF2NU9HV2ZUTXoyazIz?=
 =?utf-8?B?NjAyNzZCVkpieFBTNHEvTzVOTWVhZU5FeTU4VmNxV1VOQk4xT3lKMjRiU21O?=
 =?utf-8?B?NytYK2Vzc0NJY2grOXNBU3ZKV296Y3ZmUjZVQU1oTkdDMXpONDZuYWlxamxx?=
 =?utf-8?B?WDErSTQvVVRObWdtSTRoNnk1Z0Fkd0Y5MGhCR2dGRU0vNXJSUG1jMXN4T2ky?=
 =?utf-8?B?bXJOc3ZJRmtoQUhNY1FKdDNQa1k3aEJHZVovaS9FQW1DRUc1NFhoWUsxVGk3?=
 =?utf-8?B?cVdqbVoyenpjUXJ1akZWZjhuSENvejJ1T0syOVZ2aFMwbytaQ0xrdFFQM2Ur?=
 =?utf-8?B?UzZFZVhzQzMzUUswNTB1ZlEwMnQrOHQ5UjhQMTlpWktScGp5aHJlRTdYSGtS?=
 =?utf-8?B?OWZhZGptY2Vyb0JqVHNTZlJxMENsYUJuMHRXNkRZS3BZQ2ltbXJmQ1NvZDNo?=
 =?utf-8?B?UXhIZlJiWHdvQ2VBWkNUTmFad2tuNWtpdGwxSmEyaWFWQjYyMExFV1htUW0v?=
 =?utf-8?B?MUpTeWQwN2ZFY3FmYnJza1Z6ZWpaQW51T01OcU1ubnpHaFkyL1Uwbmw0ZzlK?=
 =?utf-8?B?SzlRbWFrdEptc0RmRUJIc0pWYi95UDdWUkdrd0lhb05TQjVQSlRSZW9lY040?=
 =?utf-8?B?anplRW93YXBSaTJ2bzFoN3FLcHNZa2dsSllSN1JSNVVUT2MvZitaeWxpV1R4?=
 =?utf-8?B?aTBkUWkwSTdETHN4cEl4ZGVVSWcwOTdzd2c2WTRZRUtiRkoxdFJxZEQ1QW1L?=
 =?utf-8?B?Y1JJSXdPWm10alVPN0FLR25IY3pXT2ROWnJMREpRRHN4U0hKaGIrUnZSTW9t?=
 =?utf-8?B?eWJaQmMyQk5ES1BRa2kyeUpWUjdPSzR1ZkxEeFJwMkhFMjBZd3drd1k4aElJ?=
 =?utf-8?B?Qi9iWG9hMmtQY3c5WUp6VUZZZkMvVEVsM0RXL3A0TmZWbFVkSW9QZWFzSGlE?=
 =?utf-8?B?UTBXSHFrN2N3UHNITEpabkF0ZWIvanJLUHpyRUJMSFV5OUNPSkRsRXBSUzdt?=
 =?utf-8?B?UXpyWmE5UncxUmEzZlVMcHUvN3pGdXFuYUdjNkY4SHVPN0dWSXZVbW5Gc2lW?=
 =?utf-8?B?d1hjV2kzUktaTDlIc3d2bXo4TDQ4dVBWcWMvTU1hR012RlI3b2UrZ3Q4a29V?=
 =?utf-8?B?cTdYU3d3VmVvYW44RWhjTllaazNoRzBLZjVqeVdydWtHQ3pVMUhxK3Ewcmk0?=
 =?utf-8?B?V1M4b2xkK2VvcFk5dTZlSFlrbVRxUFNUK0JrMkFobk9XeTJJemp0TUkvSmtR?=
 =?utf-8?B?QnFpMFkyVmZBc1J5UWQvUjcvUkJUU2pMY0Jpem1WbnNGaWlMcDZBckdDK0dy?=
 =?utf-8?B?SGo1dzVhVDJNRy9PUGJxVEltdmFITHd5bHIzMDkxTnNTZmhqTS9MRUVuaGQr?=
 =?utf-8?Q?W9+6Ghd2bELqERbtECOcGIU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0dd9f663-2d7c-4e4b-eac3-08d9c07dde9e
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2021 10:21:48.6603
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3wQZpybq3kgRGNcXCZW3fCcVR014iEkOetQ/4QNexC2hr+CUU+PXJiGEQ+NnMwjQDSljLy/VkBDGORUYh4Yw4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB4177
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBQYW9sbyBCb256aW5pDQo+IFNlbnQ6IFdlZG5lc2RheSwgRGVjZW1iZXIgMTUsIDIw
MjEgNjo0MSBQTQ0KPiANCj4gVGhlcmUncyBhbHNvIGFub3RoZXIgaW1wb3J0YW50IHRoaW5nIHRo
YXQgaGFzbid0IGJlZW4gbWVudGlvbmVkIHNvIGZhcjoNCj4gS1ZNX0dFVF9TVVBQT1JURURfQ1BV
SUQgc2hvdWxkIF9ub3RfIGluY2x1ZGUgdGhlIGR5bmFtaWMgYml0cyBpbg0KPiBDUFVJRFsweERd
IGlmIHRoZXkgaGF2ZSBub3QgYmVlbiByZXF1ZXN0ZWQgd2l0aCBwcmN0bC4gIEl0J3Mgb2theSB0
bw0KPiByZXR1cm4gdGhlIEFNWCBiaXQsIGJ1dCBub3QgdGhlIGJpdCBpbiBDUFVJRFsweERdLg0K
DQpUaGVyZSBpcyBubyB2Y3B1IGluIHRoaXMgaW9jdGwsIHRodXMgd2UgY2Fubm90IGNoZWNrIHZj
cHUtPmFyY2guZ3Vlc3RfZnB1LnBlcm0uDQoNClRoaXMgdGhlbiByZXF1aXJlcyBleHBvc2luZyB4
c3RhdGVfZ2V0X2d1ZXN0X2dyb3VwX3Blcm0oKSB0byBLVk0uIFRob21hcywgDQphcmUgeW91IE9L
IHdpdGggdGhpcyBjaGFuZ2UgZ2l2ZW4gUGFvbG8ncyBhc2s/IHYxIGluY2x1ZGVkIHRoaXMgY2hh
bmdlIGJ1dA0KaXQgd2FzIG5vdCBuZWNlc3NhcnkgYXQgdGhlIG1vbWVudDoNCg0KCWh0dHBzOi8v
bG9yZS5rZXJuZWwub3JnL2xrbWwvODdsZjBvdDUwcS5mZnNAdGdseC8NCg0KYW5kIFBhb2xvLCBk
byB3ZSB3YW50IHRvIGRvY3VtZW50IHRoYXQgcHJjdGwoKSBtdXN0IGJlIGRvbmUgYmVmb3JlDQpj
YWxsaW5nIEtWTV9HRVRfU1VQUE9SVEVEX0NQVUlEPyBJZiB5ZXMsIHdoZXJlIGlzIHRoZSBwcm9w
ZXIgbG9jYXRpb24/DQoNClRoYW5rcw0KS2V2aW4NCg==
