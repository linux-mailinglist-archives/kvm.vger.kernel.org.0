Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 061AB473D2D
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 07:25:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230468AbhLNGZs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 01:25:48 -0500
Received: from mga05.intel.com ([192.55.52.43]:43414 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230425AbhLNGZr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Dec 2021 01:25:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639463147; x=1670999147;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=R80Cwovin9qjdS0FKZYAIpf+DfQKnNaA6uD9eQ+2m7c=;
  b=PkIU4tcgqGScGWSRJzBkyJ7txXAnmoVzbmemrJPRPDY7A9sTDTLHHu53
   S0zGxxV34ip30ME6/7Adobzg0utTV57PWeGtBMmhsIL/bGwF4KhIfB4sE
   8bcSoa17MiQumbd6NPKtQpmTxXfc1jRMgdSFU1HFabsFPO4VfV4ifR8IR
   wem6/AWVyzslHsE2lILTG/C8ejNKaAX/YKPlTQBK/6FqVVSz345Tp7fcZ
   h7fBjSFs2N7JhCMOYVWlv/yGcsMSLy/wQaC6mAWlMlqu39FVj7uuCZGSm
   T/Xf0zUQ6yWy7C7YXZt0NgOiSxt/PirIiJG7T1cHIU93g0fVjtaZHEdnO
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10197"; a="325182549"
X-IronPort-AV: E=Sophos;i="5.88,204,1635231600"; 
   d="scan'208";a="325182549"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2021 22:25:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,204,1635231600"; 
   d="scan'208";a="583266033"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga004.fm.intel.com with ESMTP; 13 Dec 2021 22:25:47 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 13 Dec 2021 22:25:46 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Mon, 13 Dec 2021 22:25:46 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Mon, 13 Dec 2021 22:25:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hHJzVSnkqcJrCEb1DyX68pSHEGSgZyBnfKew5E9QReVyutMHXWnQeQ+vZqBudl3oRvYrB2AWBQnjmJjvn22cORUw+3CmFYOkzdaTcC6SIBnp4Cktx0LxB5nTrfKxc9ck0KZU8F9rkAjLSsFeTIHQVgK42/UKHx+wPrSfLJwaS7Dw/gFxy3gpNiL1c2QAWq5UY76F1uvvyFeRVbh02BpkymhShtmSvweUdJ/iS5yjJY2OSbDtRncaOK2N8PlNQ95mNNoaJ4m/B5rXP9PvyP5ggBIrLT3Q6yfYt+ZJ6lJwsEkQL8E5z8ld8jxPAjGRnA06zKF4by1hjlZOiTUpNrstmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R80Cwovin9qjdS0FKZYAIpf+DfQKnNaA6uD9eQ+2m7c=;
 b=H22jSPXGKOgyigQUGun5nlmG6AX0nV3js3SdF0XOaF4Jwo7QT2wMven9grl67XJ+oxHPRg/XWjacRY7GcHbh+fknOW4sX0IGVJD7Tq5sq6hA5PWECzxCOalO9KeF8OTPK/WgVGrCPb8lrqAkE73NnBcgRza63nEMxqZOhLhb+rzAk0L3sEhrdJrMLCZBem3yJqg7wiBKM1N2mh+8fMHjl4qjdkinscSoGbMRfbKgFLjtkAvWl0+re5EUfvqzycBv7pmXmWdEAkFG5/PV6oPXGMTgIYRWByhfROAOctfezwwTzj0CCiyIi5ncq+o8pvMDPG8YHYAOYYLbHC9Syly9rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R80Cwovin9qjdS0FKZYAIpf+DfQKnNaA6uD9eQ+2m7c=;
 b=KCDf7JdUlNhuAtL8jY1QHy13OsuWLDMu+Asa3MeNUPR619dKKPD5ZC1Nmlhdllr8YkUblIYaruA8NmKbOe2GBho3ow3rlrp0xON9BAcYVZW7NUXBXdB6DFJyXKJ3XQEWb2xSPwEeSCHErGFHoMvuJ4pEVZd1L1QmkeJft6ixNo4=
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN8PR11MB3571.namprd11.prod.outlook.com (2603:10b6:408:8f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.12; Tue, 14 Dec
 2021 06:25:41 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04%3]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 06:25:41 +0000
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
Subject: RE: [patch 5/6] x86/fpu: Provide fpu_update_guest_xcr0/xfd()
Thread-Topic: [patch 5/6] x86/fpu: Provide fpu_update_guest_xcr0/xfd()
Thread-Index: AQHX8JViV3rUbi5iYUCgo3JeBUJUo6wxgJXA
Date:   Tue, 14 Dec 2021 06:25:41 +0000
Message-ID: <BN9PR11MB5276484E87EC67749AF538618C759@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20211214022825.563892248@linutronix.de>
 <20211214024948.048572883@linutronix.de>
In-Reply-To: <20211214024948.048572883@linutronix.de>
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
x-ms-office365-filtering-correlation-id: 0c156675-44a3-4aae-eef5-08d9beca8d58
x-ms-traffictypediagnostic: BN8PR11MB3571:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BN8PR11MB3571AA7D41B6B6D8EEA532DB8C759@BN8PR11MB3571.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /OZlqcsXnovWWdRh+LVi8Mf467sOOwtb9NKvznrLVp4p9l2HYuInqlmKridALxjRTb0SAWmVqOxFE5a3k5yVGuBYL6P1p4PHDAzZn0T1pzaHxtisHg+rY6ahn5Qqd9kUIjwPSyab5kpr0Gpcy1PqeH9+lz+apZYPDro+jPM+GIBms99FGZnGa9O+QVMMZiCUM8PJyAFIFqOPE/9qH7VyFY4TS2PGOYXVxt+qVluxFtE0CzM1tN3oSeWa+eiNCzGhv/9Mqj7YDvy9UZ/UV8VRl6GGsz8LWULYdW1LLJ/8yPCmrrvNSEe31V/sIh6WXOB31Zd7zLK1cpwyd9Oc+XrLfPMOcN4CDkuwcP7POwQJamvm/rbTx6lbosTxH0v4iKgiHdemcOblYldfOzIZx8fTBayBjlGJDb9c7cgYSkZcECvOuVP4wgOPeiJVF1Gqb0Bir4AjJgAgsGhFqpWaiRNI5Pq5226oqN/pZuJS7RxB9iNUNu+M8wYVeQrzNvM9tMLg8SWZj76XmbblHKnL7YYkpRSDIeu3pNo/IMV/laP8oiEJXgoemlGeOsvHA++/KUNX8LOMakLZ9b5bUF3e5PqC/aXO0zL201jX83rgSvQmJyx831+fnB/Or93uzzEuaMns+r9Bj4ZjI40NJV96vkB471J2pX1q7RTQIR9VeIpx0+2buuqNbikvz2JS12gpB4IPa+PECHOMgHEw1e4pZyoefg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(7696005)(55016003)(6506007)(38100700002)(122000001)(52536014)(71200400001)(186003)(26005)(82960400001)(2906002)(508600001)(33656002)(110136005)(66946007)(54906003)(9686003)(4326008)(5660300002)(83380400001)(66446008)(86362001)(316002)(76116006)(38070700005)(64756008)(66476007)(8676002)(66556008)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QXpwdHJIeHhqdjcybkx4R3dVQWNoUWJRUGhXeGhQMzd4UEo5TlhsZVNJcUJn?=
 =?utf-8?B?OGxSMTkzVE9QM0FsMWFBdEdybFJMRmN1aldqRzNIWnV3NlVJVkZtWVM5S3Br?=
 =?utf-8?B?UUl0NENRalVrZ2tJQzhNZWJpNmE0ajFXMFpyemZSa0RLZDBwa2VhNzZvMENN?=
 =?utf-8?B?Vk8ySGMvSTMwMG5GUVVEU2x6dkNlZ0d6bmhTZUlpNWlKSFNoL2VRNWIzdnlV?=
 =?utf-8?B?VVBpNkQ1T0dnVld2OTFKK0F3T1M4VlRKYnY3d3ArUTJ3dnVZYmZvLzNtTE5w?=
 =?utf-8?B?dnlMcFF3WkV0U0l0dERPdFBxZXo0Z0NHU2FXUDRyVVBrMzVaUkgyTjRHdytn?=
 =?utf-8?B?aDMzMnBuVHRhMDRyUG5JQzNaN1MrVzR2VUFZUUM2TUVYR2NWZzFHa1A4d3BB?=
 =?utf-8?B?bDgva0xEdU8zWm5XMlh2eGkvc0JmenJmNG5pcDVBSVpJc3FzVDJyYzQxc1hm?=
 =?utf-8?B?cmw2SGpVUU41cDc5M3BUMWl3Z2VrZlNSZ2N2UHNndFRnbUhsRlBVa2pDNmhs?=
 =?utf-8?B?VjV2Z0RsSkMzeWZlcHBpcUEvZFVqSXZWVHJJZE83WC9GTDVZU2xDdDhSOWpU?=
 =?utf-8?B?UHJ2NERJcDVVZkVST3Jsc0x3L2JQV2YrUkZvaW9MTk1sUlNqSWFCaGp4OUR1?=
 =?utf-8?B?QkRLeDVocDFqZmVjRnFTMHdIWHA1UnJZU01mN1U5Mm82QWM3Ri9QVGFCajBx?=
 =?utf-8?B?U0pNZ1hCdDl3U1pKd3k3L3hTcDNRY2pKZVVJYWh6by80ZmtjTXJNVFRlS3Fy?=
 =?utf-8?B?ZTdtYjV4MXVla1loNWF3MmJqUkxvSytJalV0elUxSlpZb3NIdkkzL3ZhdnE2?=
 =?utf-8?B?YjdKRko0VzBIaGRIY2NFNExKWlNTSzJ1bHpremdodERyQ0h0RkhjL3k2WTVI?=
 =?utf-8?B?M1p0NER6dm1YNkZrZG5MUmU3MmtPbmVKS1ljd1JpQURDcE5Pc2U4a0MzRzBC?=
 =?utf-8?B?dTRXZm1rcysySHBJZnlTSUJKMDV1cTBoNkhVczBacmtBcnVVVG9XR0I0YmdF?=
 =?utf-8?B?dmxuMFNyS0xBVDg1cHA0VU9mWjIrTkdxbmV0TS9NUVBHU282RnFJeTNwUlBG?=
 =?utf-8?B?Z01NOTJNYkc0d3p1NkhFMnlvV0ZDWGlsSk5IeUdNREFRbk95N05TOHdoT3VR?=
 =?utf-8?B?SHE5OGh2N1VrUjJIL1VCY0dON2xLRG9HSGxiamQ2RGJUYm9XTEJRS1l4QmdR?=
 =?utf-8?B?OEZiK1pGV2djR2pPbklJZnFhaFNCUzFuVGdyNE1mLzkxV3ZmYUtpN2VZWEJu?=
 =?utf-8?B?bTl1OWMwL0lzR0xXNC9RS3QyTXhDblY3UW9sbzRJcnJiL2hzWWtaRTViNFQ4?=
 =?utf-8?B?ekpVSFB5SEpIKy9YS2R0Wml3aFVjZXQzSjE1dHBtc2ZYUnhPNmVXTTNDME1y?=
 =?utf-8?B?TEFjcjlsd2J6dngxOVQ4WHlpaEZ4eExMcUZneUw4OWFoS0YvNHBOOWd2aTht?=
 =?utf-8?B?cXZCdy81SGlmS1V3dVFHRmk1VE00N09QY3d3aTBMbCtYaDhDaVpsSGJraTEr?=
 =?utf-8?B?MlQyOGtaN2g0djFBMmJrOVlNRmd0dDBvSDNxN1dHYXd4T2FOUzdKaUcrVXNQ?=
 =?utf-8?B?Skp3dmdwbG9uRnc5b3lZenJrMXhZM0dLakxoQzBncEZ6THV1STVDWFhTREV1?=
 =?utf-8?B?RjduMko0Yy9oMUJwQ3c4amtnRFJtVmprMHYzOWpRR240by9zUy9XWU5DRC9r?=
 =?utf-8?B?YUMzVjBTM0FPVFVST21sVnRtOEZaN29Ecnc2OG9mZTJhVExBQzBJZE0vK09M?=
 =?utf-8?B?Q2RrakxGOWtLOVhHRk5XWHhyZnorb2N2M0FqQ3VvdFhlbUQrTGFwaWRaY2hY?=
 =?utf-8?B?T2FyZlNUaDdTdVozcVE0MjV3bjdxK09Kell6YnRZM3Z1L01XRE00Nk1FMGRh?=
 =?utf-8?B?Y2NjSksxcjFWbFNvMWZESFoyd1IwVGc3VlQwN3AvTnR4KzlUVDltOThmL0ln?=
 =?utf-8?B?eDQ4Q3BpcVJHd0Nod3hmbSsxUU13TnhzOS8rekxNd2tZUHFkYlh6SlBhMHpJ?=
 =?utf-8?B?VE9sS3Rja0FkaTZNMnE4RTlsOHp1aG5KWGFZcVFrT3JHRThvVUc2MFhUS2Ry?=
 =?utf-8?B?TmRSdVo1RWt0dGY2eXBCL2JaZ3l1S1pXK2g1Q1BMM3VxUGVBdDIzKzcxKzc0?=
 =?utf-8?B?b2IzNnBjdndDTDVzNDRRVGF4aE9nNzhMTFgwd0syOURCdGxwdEwyN0JJWTZy?=
 =?utf-8?Q?dPEgyKSO8ma5dfqqat9Axn0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c156675-44a3-4aae-eef5-08d9beca8d58
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Dec 2021 06:25:41.2836
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: f5CStUXMFzMwJcpu8iJqdgmx8VraAkk9azPtwxYYUulv2uMnaVMqK8wRiacLA7d4LzIKdY8q6r7C0c23x1c+7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3571
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBUaG9tYXMgR2xlaXhuZXIgPHRnbHhAbGludXRyb25peC5kZT4NCj4gU2VudDogVHVl
c2RheSwgRGVjZW1iZXIgMTQsIDIwMjEgMTA6NTAgQU0NCj4gDQo+IEtWTSBjYW4gcmVxdWlyZSBm
cHN0YXRlIGV4cGFuc2lvbiBkdWUgdG8gdXBkYXRlcyB0byBYQ1IwIGFuZCB0byB0aGUgWEZEDQo+
IE1TUi4gSW4gYm90aCBjYXNlcyBpdCBpcyByZXF1aXJlZCB0byBjaGVjayB3aGV0aGVyOg0KPiAN
Cj4gICAtIHRoZSByZXF1ZXN0ZWQgdmFsdWVzIGFyZSBjb3JyZWN0IG9yIHBlcm1pdHRlZA0KPiAN
Cj4gICAtIHRoZSByZXN1bHRpbmcgeGZlYXR1cmUgbWFzayB3aGljaCBpcyByZWxldmFudCBmb3Ig
WFNBVkVTIGlzIGEgc3Vic2V0IG9mDQo+ICAgICB0aGUgZ3Vlc3RzIGZwc3RhdGUgeGZlYXR1cmUg
bWFzayBmb3Igd2hpY2ggdGhlIHJlZ2lzdGVyIGJ1ZmZlciBpcyBzaXplZC4NCj4gDQo+ICAgICBJ
ZiB0aGUgZmVhdHVyZSBtYXNrIGRvZXMgbm90IGZpdCBpbnRvIHRoZSBndWVzdHMgZnBzdGF0ZSB0
aGVuDQo+ICAgICByZWFsbG9jYXRpb24gaXMgcmVxdWlyZWQuDQo+IA0KPiBQcm92aWRlIGEgY29t
bW9uIHVwZGF0ZSBmdW5jdGlvbiB3aGljaCB1dGlsaXplcyB0aGUgZXhpc3RpbmcgWEZEDQo+IGVu
YWJsZW1lbnQNCj4gbWVjaGFuaWNzIGFuZCB0d28gd3JhcHBlciBmdW5jdGlvbnMsIG9uZSBmb3Ig
WENSMCBhbmQgb25lIGZvciBYRkQuDQo+IA0KPiBUaGVzZSB3cmFwcGVycyBoYXZlIHRvIGJlIGlu
dm9rZWQgZnJvbSBYU0VUQlYgZW11bGF0aW9uIGFuZCB0aGUgWEZEDQo+IE1TUg0KPiB3cml0ZSBl
bXVsYXRpb24uDQo+IA0KPiBYQ1IwIG1vZGlmaWNhdGlvbiBjYW4gb25seSBwcm9jZWVkIHdoZW4g
ZnB1X3VwZGF0ZV9ndWVzdF94Y3IwKCkgcmV0dXJucw0KPiBzdWNjZXNzLg0KDQpDdXJyZW50bHkg
WENSMCBpcyBtb2RpZmllZCByaWdodCBiZWZvcmUgZW50ZXJpbmcgZ3Vlc3Qgd2l0aCBwcmVlbXB0
aW9uIA0KZGlzYWJsZWQgKHNlZSBrdm1fbG9hZF9ndWVzdF94c2F2ZV9zdGF0ZSgpKS4gU28gdGhp
cyBhc3N1bXB0aW9uIGlzIG1ldC4NCg0KPiANCj4gWEZEIG1vZGlmaWNhdGlvbiBpcyBkb25lIGJ5
IHRoZSBGUFUgY29yZSBjb2RlIGFzIGl0IHJlcXVpcmVzIHRvIHVwZGF0ZSB0aGUNCj4gc29mdHdh
cmUgc3RhdGUgYXMgd2VsbC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFRob21hcyBHbGVpeG5lciA8
dGdseEBsaW51dHJvbml4LmRlPg0KDQpbLi4uXQ0KPiArc3RhdGljIGlubGluZSBpbnQgZnB1X3Vw
ZGF0ZV9ndWVzdF94ZmQoc3RydWN0IGZwdV9ndWVzdCAqZ3Vlc3RfZnB1LCB1NjQgeGNyMCwNCj4g
dTY0IHhmZCkNCj4gK3sNCj4gKwlyZXR1cm4gX19mcHVfdXBkYXRlX2d1ZXN0X2ZlYXR1cmVzKGd1
ZXN0X2ZwdSwgeGNyMCwgeGZkKTsNCj4gK30NCg0Kbm8gbmVlZCB0byBwYXNzIGluIHhjcjAuIEl0
IGNhbiBiZSBmZXRjaGVkIGZyb20gdmNwdS0+YXJjaC54Y3IwLg0KDQo+ICtpbnQgX19mcHVfdXBk
YXRlX2d1ZXN0X2ZlYXR1cmVzKHN0cnVjdCBmcHVfZ3Vlc3QgKmd1ZXN0X2ZwdSwgdTY0IHhjcjAs
DQo+IHU2NCB4ZmQpDQo+ICt7DQo+ICsJdTY0IGV4cGFuZCwgcmVxdWVzdGVkOw0KPiArDQo+ICsJ
bG9ja2RlcF9hc3NlcnRfcHJlZW1wdGlvbl9lbmFibGVkKCk7DQo+ICsNCj4gKwkvKiBPbmx5IHBl
cm1pdHRlZCBmZWF0dXJlcyBhcmUgYWxsb3dlZCBpbiBYQ1IwICovDQo+ICsJaWYgKHhjcjAgJiB+
Z3Vlc3RfZnB1LT5wZXJtKQ0KPiArCQlyZXR1cm4gLUVQRVJNOw0KPiArDQo+ICsJLyogQ2hlY2sg
Zm9yIHVuc3VwcG9ydGVkIFhGRCB2YWx1ZXMgKi8NCj4gKwlpZiAoeGZkICYgflhGRUFUVVJFX01B
U0tfVVNFUl9EWU5BTUlDIHx8IHhmZCAmDQo+IH5mcHVfdXNlcl9jZmcubWF4X2ZlYXR1cmVzKQ0K
PiArCQlyZXR1cm4gLUVOT1RTVVBQOw0KPiArDQo+ICsJaWYgKCFJU19FTkFCTEVEKENPTkZJR19Y
ODZfNjQpKQ0KPiArCQlyZXR1cm4gMDsNCg0KdGhpcyBjb3VsZCBiZSBjaGVja2VkIGZpcnN0Lg0K
DQpUaGFua3MNCktldmluDQo=
