Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B6BA47BA1A
	for <lists+kvm@lfdr.de>; Tue, 21 Dec 2021 07:42:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233926AbhLUGmU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Dec 2021 01:42:20 -0500
Received: from mga17.intel.com ([192.55.52.151]:56612 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233369AbhLUGmT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Dec 2021 01:42:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640068939; x=1671604939;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CJLKd6awyRAKkkRfM+CqoiMDlpQ5oH9EkhxroXzGwQg=;
  b=deUbRr+buEwdCsxGKJB6W9YHBZPmsm/PKlVjWJ0blBtrWV61VJ7Vum5c
   KXq4OJHwc95koO9rfJqp0R2ChhSC8LF2DZDbKBdjesQWv9sPhGL4PgFI3
   sBZXG5Z01ZbVsg+CNA6mYKq/hgx2c+PBhlM2ESA5nVgVi/i+54coqBeWc
   gvzrZSMMGr0xYhBpHPRbKvMrPD3R6YYhPJhKv5LGoOcibZ63V1a7VOzi7
   IfU90mbkTN0sLe/pXjWLNS5z0r/+O3WP5046e8bCjmiPQou8dfgq+iVad
   T7Hzhqk3inBVk8BbcSBou2QV9El2SbjHYzMsVrQv4F09wQp65Fq5s1Kxg
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10204"; a="221013169"
X-IronPort-AV: E=Sophos;i="5.88,222,1635231600"; 
   d="scan'208";a="221013169"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2021 22:42:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,222,1635231600"; 
   d="scan'208";a="757670090"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga005.fm.intel.com with ESMTP; 20 Dec 2021 22:42:18 -0800
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 20 Dec 2021 22:42:18 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 20 Dec 2021 22:42:17 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Mon, 20 Dec 2021 22:42:17 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.42) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Mon, 20 Dec 2021 22:42:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NwBKxFySxy8IXH8CUe5wH0ASWJBV5HkXvwHEWiASmcFLgX/44Lvf2vfk8+s1GaWKae9MBW66H4QT/ZQm47K0kD1UsmscsPKPQIYvrpxVYT1fPQjYv7jJQUtE0gj2fDjzxARNvvMK3ZFvptRCYxMGIKC9x+UI0p8QsUr+Yn4ObJDCvCFbhUi13KyVXzLIZeriJhnQo8HX8rUu7oLIxG7pdXN93GbSSrS8uuBIYPKYSkKlEBZB7Im4+fX2gJvhEpH5Gs+vog/GkYiaU7wUbzptPiV77c487KXT6gxVT6PLdjJk2vldi30ZDV4hq6cFzE8+xw2be5caElqWRbfnCGIsHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CJLKd6awyRAKkkRfM+CqoiMDlpQ5oH9EkhxroXzGwQg=;
 b=hQ9oyyfOm3RWOeWkR8ZbJyZmfi1BBbPm0srTzgF3PNPz/MusyYBTL08ZrntS13Cp5G4imQ7UQYqF19sewcudJyhHrlsZ0HDMcFI1YC/PxmouOMP3htDpuEkp/Or1BSbwfkI7cN65CqjvOuVseZE3l2kHvBGDmbwZAsO9n9Y3a9+Nh9p1EDx3k1wgmbSDKzcR/dTh1zcBEGdfW+9ZUYRmsBwee72FPPGz1+/PaNTtYh+/2dFXAAxa/SylLUXvMXb336uVQfwK8llB/82k+fXjt+gBT+StKIEsD7elopDOQGmGA1fHkLMZBR74Hej4J1mMVpkPW1KzOrFccz0QE2Th6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MWHPR11MB1245.namprd11.prod.outlook.com (2603:10b6:300:28::11)
 by MWHPR11MB1565.namprd11.prod.outlook.com (2603:10b6:301:c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Tue, 21 Dec
 2021 06:42:11 +0000
Received: from MWHPR11MB1245.namprd11.prod.outlook.com
 ([fe80::c9f6:5be9:f253:6059]) by MWHPR11MB1245.namprd11.prod.outlook.com
 ([fe80::c9f6:5be9:f253:6059%12]) with mapi id 15.20.4801.020; Tue, 21 Dec
 2021 06:42:11 +0000
From:   "Liu, Jing2" <jing2.liu@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
CC:     "Christopherson,, Sean" <seanjc@google.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "jing2.liu@linux.intel.com" <jing2.liu@linux.intel.com>,
        "Zeng, Guang" <guang.zeng@intel.com>,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        "Zhong, Yang" <yang.zhong@intel.com>
Subject: RE: [PATCH v2 22/23] kvm: x86: Disable interception for IA32_XFD on
 demand
Thread-Topic: [PATCH v2 22/23] kvm: x86: Disable interception for IA32_XFD on
 demand
Thread-Index: AQHX81sJlYe2IUDRBk6KQYJQAGVfOKw7Gy4AgAFouQA=
Date:   Tue, 21 Dec 2021 06:42:11 +0000
Message-ID: <MWHPR11MB1245BC0FA24DE0565D6952AAA97C9@MWHPR11MB1245.namprd11.prod.outlook.com>
References: <20211217153003.1719189-1-jing2.liu@intel.com>
 <20211217153003.1719189-23-jing2.liu@intel.com>
 <6e95b6f7-44dc-7e48-4e6e-81cf85fc11c6@redhat.com>
In-Reply-To: <6e95b6f7-44dc-7e48-4e6e-81cf85fc11c6@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6a0e711d-2797-4ad5-0899-08d9c44d0487
x-ms-traffictypediagnostic: MWHPR11MB1565:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <MWHPR11MB15658DA88AFA5AF9CDB8FD66A97C9@MWHPR11MB1565.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: atZhG1qo44GVObBZq3vcTBxxkiWmKAv+Jq17gJntDfB35Mk+P3bNAd/JHjPbBVa8/3O6q4CPa9+LnE27susSff05Ce4JkRQ5uG7P1KfqFzL8sPTZfZ6QkuvQ1fntKjkwLlr1+cbydVkZOnKLwLQPoNG+oUDDNGqLnJMrJDAJ9A3cqMJzT/kc25ND4N1gstvf1rWimO+AtViGmIFn2qs43ozJ4Pp4OBA89XhyyzYhI+HtHP4BQcp2Ncy4cgQtgGtxlELgffEZO4hhEhPkmFkeyQD0R+jEbyftGDGyZIX5UPpl9y0TWe/OfgUjt3aH9IPRQ8OrqzKTR6N5OLF/+zEzZVFqFfSoHLnQNXiwvTpyo7TDnisidywntSs+tSjzPk0LD5C0FPiUipccWKFAVJt4Yu4yPSmp5Xim27B9eXKxm7Sfqr6LoE9XWQBRHFR7yTWGaL2xzvA3OrtuBjkOWI1OzqlZuDCP7wtNLDp6AAZ1cTlKDTWGUxZRKXoJD1E+paEb+KvVmkfM5kBU6H0LTZj5xE8/BB8JzLYbqcETKhLD2iN8hh+/ArohmfvInUfQ+952tCsfYK/+SkXILbDeVvT6ddQ6JoMMpy1NPNn3V64HuZKYnfmJc75xVcGQn8mIT9W4YQiY9RevNnU0POinQLxSZeQYUJM4KO6dBfTPQnS7Q154S9UCdW2EsnNNebd6SghMTBccPbVuDmk3/eVc2Cspou7TOVOnG8vepdO23WoOFP0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1245.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(82960400001)(2906002)(71200400001)(8936002)(110136005)(5660300002)(54906003)(122000001)(38100700002)(316002)(4326008)(38070700005)(83380400001)(66446008)(7416002)(186003)(9686003)(53546011)(52536014)(4744005)(66476007)(66556008)(55016003)(64756008)(7696005)(6506007)(8676002)(76116006)(26005)(66946007)(33656002)(86362001)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZDg2TEY1VTNEVnJEbVEySnExNWNuRHZDNVhZdUExN0NVZ3pORTBFWWxBeXhN?=
 =?utf-8?B?d1djVTZ1a285N3JOQXRneEVsOTlua3V0Y0xWUmxKR3ZhcGFBK1lBb2pqcklh?=
 =?utf-8?B?YVA5eG1obEVmeWtaSkMwS01JczhEdWwrTTlqa3QwVHh2R3VjK3FMWGFlM28w?=
 =?utf-8?B?YndENjVwM2ZoZm0rWmdrTGU2NWJsZ3U5Rm10TXJJUnNkYUw4a3hyZFBraURs?=
 =?utf-8?B?NHFBcjI5aHhFUlhBS3NaOG5INTdlUUh6VzdWNHg2TUpZdUpORUNBd3lhaSty?=
 =?utf-8?B?bDVLYmdxRzRHVHlTMjhUQU92NnlKenR4Ukx4VnlqZzBwN2R4QUtmR3Rlb1Qr?=
 =?utf-8?B?T3VxaHZwejBQVTdoUEVPTDVqQ2ZkS2Ntcno2QkhJd0dxakRtSjB4bzVwQVQy?=
 =?utf-8?B?TW1Rbjg0NEVPQ3Vka1dGcjhKQ1N0ek42OW9MU2xKWm5wREUwRGJvMS8ySEdn?=
 =?utf-8?B?b21kTTFvVmVocW5ueE1VRnpKWHZHY2lkU093QXpIa0FkRGlMaWJrVk5ab2pW?=
 =?utf-8?B?RGNQYTQ5MTVXRHozUjhlUi9OblF5RnVpNlJBLy8zVXJWK1M5bHhNNThza3I4?=
 =?utf-8?B?VHY3VENwZlNuaDRLQkRWQlQyS0hkajJZcmhWaVVIUmlXQXBIczI3WWVHd1d3?=
 =?utf-8?B?eWNpYmlqU3RvWG1jRVJlUm94WXVQZVgxdmxJbE9NcTFvbmhhL0JrZDE2b0U2?=
 =?utf-8?B?SUtIV2JmNlpYZjB4RXNFakhNOGI4WGFHMW1kb0dOVjRkL0FoQVphdERJUDlL?=
 =?utf-8?B?bVZiM29MZDdyTkRhRXJTYmtuVFAveCtlNlhLL0tqTVN6N040NFlCaEJwTzln?=
 =?utf-8?B?QXk4STJPNTQzaGljVFFoVGtjSWZxNTlQQjVlVW9kb09USVYrZ05GOG9abDVY?=
 =?utf-8?B?Zi9RTWtIcXViUUZSN05pZ2MzTEdyVVpxOVB3WHk3a1RFL0k0L0NsM29hWDZq?=
 =?utf-8?B?QVc0ZEFtNExpMjRWTjFvQzlQbmpqNVQwbmxvNlhJZjg0M3FUZ29OY2EzN0p5?=
 =?utf-8?B?NHkyOFdWdXpSVVdibWNiTndzMnRIb2Q1a1dHWnpheG90VlRsdzN1ZUhkcXRw?=
 =?utf-8?B?TzcrUm9jUFd5UUozKzlaZnJlMEFxdDJ5UjhNak1IZUpwTUFIQWNUcDNwbkl0?=
 =?utf-8?B?YmJTUXhYcEVrcE5yWHR1QzlvQXR3RkkvWWpyQ25JUlIyT2pGL3M0L1kwSkVh?=
 =?utf-8?B?dmVQUVlURUx2TkY4N2VoSnhKMHp5WjZlN01BTUE3WFpIalBuWXAvVzUvNDE2?=
 =?utf-8?B?VjY1bjdyNVJRS0p1ZlFTcytBSXA5S1N2eTVsc0hGQUdPam5xbmtUZFVZRzJr?=
 =?utf-8?B?cC9pb2xRMWZVdDVGRXhLYzJLalM5RUg5eVVRRmlMSXgvUzdLQ3dWZ2VQR3l3?=
 =?utf-8?B?V3dmT1VYSUJDdTNvOGUvYUQ4NllzV09ZTVM1MmlPR2N0Mm9Rd1BBM3J2c2V4?=
 =?utf-8?B?OGxsMWRYRnFMOUZycHQwZ29hRFNkRWhMYkhtcFhaaEk5WjdvZG02R3plTFJa?=
 =?utf-8?B?cDJFb054VHdId090QmdHU3RsRFl4eXhqT2thQUZ6cVpkUzJ0RGVrdEZoR3BQ?=
 =?utf-8?B?NXhXd2wyRVppTURNWUQyN1BMZndlY2c0RndKRmg3alBiOUphbndMbWZIODNM?=
 =?utf-8?B?a3pPcXFEZjl3SEZRa3dieWxrOGZjK1ZhMFUyUDd1cmw1ZVlhdEt2NVErdnhC?=
 =?utf-8?B?a29yQkxkR1lkZENRdlllRkVBOHFubVFuV09TYVR2dFVPTlAxZXZmSnR4NmpB?=
 =?utf-8?B?cDl6QkY2Z0FrMUZPQklkRTRLelB4R0thdW05ZGJubDZxYnRoVjJNVEFlWUJ6?=
 =?utf-8?B?VlFhQmVOTmd1UE10bDk1V1V1M0lVWFBlb0VkVDhxbGlIekcxd3ZSTFJ0eWtR?=
 =?utf-8?B?MkpqdkIwbEdINHM2M0cwaFdLWVgyMTkzN2dRRTJpVlFkNU04OGFjbUd0QjI5?=
 =?utf-8?B?cWVodi81MzJxcVkzRjdmOCtpNmNuWXdjL3BzR3RrbVZiVEgzS0lwd1hrNGtP?=
 =?utf-8?B?TVhwTTNEeVRHbjdjWlN6Ty9HVkZsdXBZdzBhdUJ5YUl4ZmpCL0c2RGpZdVJE?=
 =?utf-8?B?S3laRjRPMGdXejVUM3lVeEVzem55R2RUOHA0NjFhOEx1K2o0L1A1UithcjY2?=
 =?utf-8?B?T2picmNuNG9FeTBzTDYxZzkrb0lOY3dRZG9PQjduQ3I1Z21HelRFMUtUWFRu?=
 =?utf-8?Q?21MCqtaXZsp4KlUdYPF+yQk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1245.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a0e711d-2797-4ad5-0899-08d9c44d0487
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Dec 2021 06:42:11.5870
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UtuKKKO5QS5a6b6e9RhikNGXhNssSskHudRZ5I30iAKFX65G0nOd4/+ZiA70Sq0UBRe9XW/nUgVSyIq4CysiZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1565
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gMTIvMjAvMjAyMSA1OjA3IFBNLCBQYW9sbyBCb256aW5pIHdyb3RlOg0KPiANCj4gT24gMTIv
MTcvMjEgMTY6MzAsIEppbmcgTGl1IHdyb3RlOg0KPiA+ICsrKyBiL2FyY2gveDg2L2t2bS94ODYu
Yw0KPiA+IEBAIC0zNjg2LDYgKzM2ODYsOSBAQCBpbnQga3ZtX3NldF9tc3JfY29tbW9uKHN0cnVj
dCBrdm1fdmNwdQ0KPiAqdmNwdSwgc3RydWN0IG1zcl9kYXRhICptc3JfaW5mbykNCj4gPiAgIAkJ
CXJldHVybiAxOw0KPiA+DQo+ID4gICAJCWZwdV91cGRhdGVfZ3Vlc3RfeGZkKCZ2Y3B1LT5hcmNo
Lmd1ZXN0X2ZwdSwgZGF0YSk7DQo+ID4gKw0KPiA+ICsJCWlmIChkYXRhICYmIGt2bV94ODZfb3Bz
LnNldF94ZmRfcGFzc3Rocm91Z2gpDQo+ID4gKwkJCXN0YXRpY19jYWxsKGt2bV94ODZfc2V0X3hm
ZF9wYXNzdGhyb3VnaCkodmNwdSk7DQo+ID4gICAJCWJyZWFrOw0KPiA+ICAgCWNhc2UgTVNSX0lB
MzJfWEZEX0VSUjoNCj4gDQo+IA0KPiBQbGVhc2UgaW5zdGVhZCBhZGQgYSAiY2FzZSIgdG8gdm14
X3NldF9tc3I6DQoNCk9LLCBpdCBzZWVtcyB0aGUgcGFzc3Rocm91Z2ggc2V0dXAgaXMgcHJlZmVy
cmVkIGluIHZteC5jLg0KRG8gd2UgYWxzbyB3YW50IGEgY2FzZSBpbiB2bXhfZ2V0X21zciAoZm9y
IHBhdGNoIDExKSwgZXZlbiB0aG91Z2gNCm5vIHNwZWNpZmljIGhhbmRsaW5nIHRoZXJlPw0KDQpU
aGFua3MsDQpKaW5nDQoNCg0KPiANCj4gCWNhc2UgTVNSX0lBMzJfWEZEOg0KPiAJCXJldCA9IGt2
bV9zZXRfbXNyX2NvbW1vbih2Y3B1LCBtc3JfaW5mbyk7DQo+IAkJaWYgKCFyZXQgJiYgZGF0YSkg
ew0KPiAJCQl2bXhfZGlzYWJsZV9pbnRlcmNlcHRfZm9yX21zcih2Y3B1LA0KPiBNU1JfSUEzMl9Y
RkQsIE1TUl9UWVBFX1JXKTsNCj4gCQkJdmNwdS0+YXJjaC54ZmRfb3V0X29mX3N5bmMgPSB0cnVl
Ow0KPiAJCX0NCj4gCQlicmVhazsNCj4gDQo+IFBhb2xvDQo=
