Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56A7E456658
	for <lists+kvm@lfdr.de>; Fri, 19 Nov 2021 00:17:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233149AbhKRXUr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 18:20:47 -0500
Received: from mga06.intel.com ([134.134.136.31]:31756 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231751AbhKRXUq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Nov 2021 18:20:46 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10172"; a="295128516"
X-IronPort-AV: E=Sophos;i="5.87,246,1631602800"; 
   d="scan'208";a="295128516"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2021 15:17:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,246,1631602800"; 
   d="scan'208";a="672996622"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga005.jf.intel.com with ESMTP; 18 Nov 2021 15:17:45 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 18 Nov 2021 15:17:44 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Thu, 18 Nov 2021 15:17:44 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.48) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Thu, 18 Nov 2021 15:17:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GRS1xKVgVX+1sQZqEx9FEWq0Hz9UL+CVQjCe/2sSS/1s4ckHPgx6ytUhRE6+GYiF5SavPd+qFlo3YhV3zODw3Qiir+f73TNyJy96P15Cl3MirEDT3qHwFz4QrA/4eex8ZxP5Qm0FIhP+kqaoUTQtexuazGTTEkjQG5ulaVZCSFuImiWio5P6GvrdpeCmuF5E8+vIlct68fqRBFIbVh8aEIs8zsDoiPZsPaNgOELm32dIMXDvZEopnzffwZgdogfysZ9iTm50owTRPMD+iVeDH+aD/b5J8PYyUzODOnk1Qa1IJbuJPmeHDPGMgIKHITDEhjKwArCQ10yVyXekr/4ajQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=96l+gkM324O8h2SBdpEfg2kXILDYhuITdoo5uOEgxCU=;
 b=gXhKgafnxEZ5vgW6D6GSCFfbJeQ0yGpJOYDk4/HsjLBBNQQ/0Umi+fKt8Z+UfzU+FEJBrYXI3+tWwJ0ywJwRrg2UeX1Mn8XS8HDK2OD2tMrLk7lCQguXTvortQtJ3/nYXQyIjXv8kwn2G5x9lC3A8PJl4z/DRi0XFO5ntZp+4vNrZ9wwPXv51Gh2AgJhResfVkY0MLuq84fxeRyskB61B5AvKkRNcCa77NSIk0+2S8E2uPDV2+ODW0jhAN9PzClEOjmyOXsYMyzRxz4X41jETnaPG9WWNzH7xP9z75fMVu6HNuVes7W36col8Px6BCAnAUH8u8V5HSGRW+oGESqkng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=96l+gkM324O8h2SBdpEfg2kXILDYhuITdoo5uOEgxCU=;
 b=LHFznTaDgg5xFL1RsJ1oUugvErsqSwjBQI6g3q13TTvrTI8KpH71STAqGsH6sWspSOXZ82ynFngVtw/MI7bsThBTNO6ZZEo1OJYaWCTDiulQ2DDzDfpzQAoz1Na9FX+Kig48hSKRYbYOdm1fzJ6z5z3bJb12bA0fn5ZQpVFgnLc=
Received: from BY5PR11MB4435.namprd11.prod.outlook.com (2603:10b6:a03:1ce::30)
 by BYAPR11MB3109.namprd11.prod.outlook.com (2603:10b6:a03:8c::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.25; Thu, 18 Nov
 2021 23:17:42 +0000
Received: from BY5PR11MB4435.namprd11.prod.outlook.com
 ([fe80::348f:bbe0:8491:993]) by BY5PR11MB4435.namprd11.prod.outlook.com
 ([fe80::348f:bbe0:8491:993%5]) with mapi id 15.20.4690.027; Thu, 18 Nov 2021
 23:17:42 +0000
From:   "Nakajima, Jun" <jun.nakajima@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Jing Liu <jing2.liu@linux.intel.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "Cooper, Andrew" <andrew.cooper3@citrix.com>,
        "Bae, Chang Seok" <chang.seok.bae@intel.com>
Subject: Re: Thoughts of AMX KVM support based on latest kernel
Thread-Topic: Thoughts of AMX KVM support based on latest kernel
Thread-Index: AdfWMJGMz5/jeSLQRn+nYCX+7Qj8nwE7nDEAABP7RQAABYsJgAAE2utwAAZntwAASBWZAA==
Date:   Thu, 18 Nov 2021 23:17:42 +0000
Message-ID: <D93C093C-8420-45DA-99F5-0A5318ADBBEF@intel.com>
References: <BYAPR11MB325685AB8E3DFD245846F854A9939@BYAPR11MB3256.namprd11.prod.outlook.com>
 <878rxn6h6t.ffs@tglx> <16BF8BE6-B7B1-4F3E-B972-9D82CD2F23C8@intel.com>
 <2e2ab02c-b324-e136-924a-0376040163a8@redhat.com>
 <BN9PR11MB5433D6A1368904D9B748846B8C9A9@BN9PR11MB5433.namprd11.prod.outlook.com>
 <c7d87723-5533-257f-fbf0-ecd3a0b96602@redhat.com>
In-Reply-To: <c7d87723-5533-257f-fbf0-ecd3a0b96602@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.7)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: aad605b9-b386-488b-7bf5-08d9aae99f67
x-ms-traffictypediagnostic: BYAPR11MB3109:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BYAPR11MB3109769181764E323017370F9A9B9@BYAPR11MB3109.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 51oPexlq/+HunYjkuqWjuiC+WuwgCq2d73QDcKyUdhJzJKXzOfZ1y6HZXjaEQU2JNdSDf7IyhknZzjscSS6Wt63BmLPhlofzSwVw29F2qrrQyagQqessQqTg+4GnJ/SSyvQscLWuOOXRxJeHHf9s8teJjjIG7RU7QNnuhaMZX0lCcO0xX6KDz72NEoLuU9KYZ8awQK02BZPNh9B4bl5fUueetxrM5sL8Qq9pYlhAOHjiKJjaZbmaOuO9rIaHUPqXjfZBBTXYWayc28xmvfVaEgMFIzFAPcug7c3qkCNkLpTU9Eu1ifpCgCoSRtoDES5IggHsJuNwp8791frCxGO/cDymFdR8RlhrRmtP5NMO41i76okq28fWlvyZIArUnsqShB/L7e+zF0FLKNJzUDmAYeASmmSfsXbOM1GaAhyJAMeJvh/QAAUpkQQnMU65OmdNhEO6tzkXUpXhWqBXFyAwIoizViQgcRg5RfYhbtfhDr1KBYSHRW0uSbhH/B46UxV1y4aDhsUfHoZ7wuwyHYVWrlVpUk5vF4nuLjMJ6DBTMVOI0V7LWQQqxWNqlkgdCOmfD1wPBsvHsEJ4hJXC/GIJqmqSK3a65wFRoocqq+pGIUJ0FSCmBMJH3+nzDeOGCLygRIP/vTgLQBf4q0A47kibEc0JgCwLWomg4Rk24R2kt6Kaj0nCcyXDd9ghIXZyKn/XjHP/BiDRIGVAhgkUQ0V6noIaf45Uk4G3pXvjLUuNb+lv6VVx4dFcYwQ7g6H/SxRayzSXenhqw63YjBr8A0d/Pm8e43W/yxbeUEwFr1BMc9z1uY1bCAELkA1Hfm9Gjzdk2Wg7YFv5srGyRvVCCkLN9g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4435.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(5660300002)(122000001)(26005)(64756008)(33656002)(7416002)(508600001)(8936002)(966005)(66476007)(38100700002)(82960400001)(316002)(36756003)(6506007)(53546011)(54906003)(186003)(66946007)(83380400001)(38070700005)(76116006)(2906002)(6512007)(66556008)(86362001)(71200400001)(2616005)(66446008)(8676002)(6916009)(6486002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QUtJeEExK3R6ZFRBUHcrZGJxeVRMN3BJR2ZVOERpa2U0SVJqd1hSeTRuaXFz?=
 =?utf-8?B?RUg0K3ZSWDhlb3dBZWY1cUJBQTk0NmQ1NXlzTmNQMHlGbzJFOHFEVXZkTm9T?=
 =?utf-8?B?cE43K1hETU94cStJcmRwTW1rNDIvREtqWWRwaU5Ob0dLSCtqMG9HbW5wR2Nz?=
 =?utf-8?B?NGhTR2EvWHdaV2dlREpRZVhaUExwM3B2bG9COFExaXBKT2hRVGtvNHhRMXhG?=
 =?utf-8?B?UDg4M0JBWThVekxya3daYk5IcFFmeUxvM3QyeGxRTW1LcEd3YmpCUzQrbEcv?=
 =?utf-8?B?RU52MjBocFRHVHBROExObVdNdFlCSFhjTVRFa3VnV1Y1Q3VrNy9aZTFSa2dr?=
 =?utf-8?B?cFlXVDBTUnFSaDU2WmhmeVpaenZQUW0vNGhVNUZFcEhQQ1lHd0hEYkduS2l2?=
 =?utf-8?B?SHQwZjhwRStBWHEzVW40UE1sSk1Lem5YMHFTbWx6bk5tWU1IRk4yWk1SUGRJ?=
 =?utf-8?B?b3VPcnp0TG44YkJzc1V2U2dZK2lHMnc4TUFuNUcyMkxkdm1VNTEvR3lsa0Jv?=
 =?utf-8?B?UDl3aGdsb3M0TW1PTkJOT1hnaUhmaHBiODJxd2RjY2JCMEZkSlFjV2FhcGht?=
 =?utf-8?B?dWszVGpORTBWT2RYQVJ4VU52Z2NGUmUxMFdZVVVkWUNVNEJtTjJOdjUra0xI?=
 =?utf-8?B?ajJDYVlOT2VxME9WRWFDSVRzbDJEVVFrMWFXV2hhWnQ4UlFRSzdpb3ZNcllX?=
 =?utf-8?B?MVVDcUlFTnpJVHlMUWhaMHVuVGRZaEMvODlkKzgvdWxpOUVSc1IwNSs2MHI1?=
 =?utf-8?B?WFpBeFZEbG9ycUo1ZkRZV0JYcTNLUkorY2k1ZDQ2QkxDbUdTTzJPbjdqdmZG?=
 =?utf-8?B?MDh5TFFra3ZLWUdPeWNKbUZvWDZ1aTIyRnYyNkxVM1VETnp5U1ZDYTEwTWg2?=
 =?utf-8?B?N2FiaXdpa3ZyRVIrZXUvVTBia0xNS2toVHByQjk0NVZzWlAzQWxnT1dGODJY?=
 =?utf-8?B?UGtWdmFmWHp6V2NvRGZobXNYK2dQYTVON0daK2VlUjVzSFZYYmcwM2ZwUVNz?=
 =?utf-8?B?cEdBQ0szU0NUR3ZNZEtoOEFBK2RyUUZVVVBHQVhnd3c5TTdYT0NIUmxjTDB4?=
 =?utf-8?B?dVA1UEFFVGRrSnRIdkZhaU1MSGdLMXdwbDVoTGZZL2M4TndPR0haOVRhclVa?=
 =?utf-8?B?bnk4VVVjYWFRajZOaHB5TzFGTEhtTGJ0RGtlcGROVnRYWjJpQVVSODhtSVZS?=
 =?utf-8?B?VXZoajhtS2daK1FEeFkrZmFWaEg3V0ozdzM0Z0hoWHVwNTdUU3hDc0ZrWU4z?=
 =?utf-8?B?ckdQSnZGcjQ2WWQwUGJGZjFLSkNwVmtUVVJuVGdxdHhGNjl3YUVudW11OHc3?=
 =?utf-8?B?b29weW4vSnBGQkFla2NrZkxwSTFXa1VsbkQ1TElkQ29LK280ZTRPeHZGNFF5?=
 =?utf-8?B?WFh5YnphbGlRWkJ1U0twTlVkQkdBWk8wNzhtcThieTRRN2tZNzZiZWpWbkJC?=
 =?utf-8?B?RnNwSDhEMUtCdnFxT2YvTTlLbjc0bUhjVytnTW5EOGs1MUFkaEdQWDFxTnph?=
 =?utf-8?B?bDZoYTAvMXV3YkNWZy9uSGIyNUU0QlNBMXRZNnMyZDRsM1d6TDY0ZkpLek1G?=
 =?utf-8?B?N1ZCZm8vZXREeTBwaTVmbEdRM05Sbkh5K1pJaXUyYm1Yb2xpWUFhQXFicC9t?=
 =?utf-8?B?bkJTS25kOFpzd2cvb00yNlhoVEQxZG9YclBhWGNUT2JaRFFVd0pMSDc4am5N?=
 =?utf-8?B?NGY0T1NlM0s4V1prUDBhWWh0MCtUWnJadGM0K1h5M3poOUFRSHJxb1B3Tldo?=
 =?utf-8?B?Ly9yZURlNlhMMGNyR2xFMngwN09lMnE3TW9pOFlEQjFtYm95QkFhSlJUWGlD?=
 =?utf-8?B?bGRBNE01UUZEeFYzUHhrV2M1MC9JMmhEeklxK3p4bWpXSmdjRENSWkdZc25p?=
 =?utf-8?B?RFZRai9mYUZuZzlzZEZKVU5ZTEhOMG9BNWtxZWI4SU5udE1la3Z4QndWTXV2?=
 =?utf-8?B?RGJ5dlhpRy82aVZpT3RMR0dVSHczSnBybFU1ekk3VGdFTC9JN3E4aVVJRHFJ?=
 =?utf-8?B?c0RibU5pcWV5TE9OVk44ejlkVGZJemgxR0JWKzVZUTJkTzdtTjhmK3BidDVh?=
 =?utf-8?B?YkwzRnlvNkZtZGQrS3VxdVlSaVJ6KzRVUDZ3QzZ2T1pkOElqQVV0eitnYTQx?=
 =?utf-8?B?TUhIUWkzL0pOVmFTRWVZLy9TRFJQOTk4R3dlUjYvNTVlU1VGRWNpM0E5c2lO?=
 =?utf-8?Q?5enHFWek6NugT7UEV8IOZg4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B0F3FB42BA3C564F9C7A9B2850F744D3@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4435.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aad605b9-b386-488b-7bf5-08d9aae99f67
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2021 23:17:42.6248
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: I3gKNIEK1hhj+OZOgqR12HOXswZ6QynE/Jh+r6zRzHfSGf8HnzhAGm+8nBttKUriQYVfOVcZ+EJVnjE+fqpPEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3109
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTm92IDE3LCAyMDIxLCBhdCA0OjUzIEFNLCBQYW9sbyBCb256aW5pIDxwYm9uemluaUByZWRo
YXQuY29tPiB3cm90ZToNCj4gDQo+IE9uIDExLzE3LzIxIDExOjE1LCBUaWFuLCBLZXZpbiB3cm90
ZToNCj4+IFdlIGFyZSBub3Qgc3VyZSB3aGV0aGVyIHN1Y2ggdHJpY2sgaXMgd29ydGh3aGlsZSwg
c2luY2UgYSBzYW5lDQo+PiBndWVzdCBzaG91bGRuJ3Qgc2V0IFhGRFtBTVhdPTEgYmVmb3JlIHN0
b3JpbmcgdGhlIEFNWCBzdGF0ZS4gVGhpcw0KPj4gaXMgd2h5IHdlIHdhbnQgdG8gc2VlayBTRE0g
Y2hhbmdlIHRvIG1hcmsgb3V0IHRoYXQgdGhlIHNvZnR3YXJlDQo+PiBzaG91bGQgbm90IGFzc3Vt
ZSBYVElMRURBVEEgaXMgc3RpbGwgdmFsaWQgd2hlbiBYRkRbQU1YXT0xLg0KPiANCj4gT2theSwg
SSBqdXN0IGRvbid0IHdhbnQgaXQgdG8gYmUgY2FsbGVkIG91dCBhcyB2aXJ0dWFsaXphdGlvbiBz
cGVjaWZpYy4NCj4gDQo+IEl0IGRvZXNuJ3QgaGF2ZSB0byBoYXBwZW4gaW4gY3VycmVudCBwcm9j
ZXNzb3JzLCBidXQgaXQgc2hvdWxkIGJlIGFyY2hpdGVjdHVyYWxseSB2YWxpZCBiZWhhdmlvciB0
byBjbGVhciB0aGUgcHJvY2Vzc29yJ3Mgc3RhdGUgYXMgc29vbiBhcyBhIGJpdCBpbiBYRkQgaXMg
c2V0IHRvIDEuDQo+IA0KPiBQYW9sbw0KPiANCg0KV2UgcmVjb21tZW5kIHRoYXQgInN5c3RlbSBz
b2Z0d2FyZSBpbml0aWFsaXplIEFNWCBzdGF0ZSBfYmVmb3JlXyBkb2luZyBzbyIgKGJlbG93KS4g
QWxzbywgSSB0aGluayB3aGF0IHRoZSDigJxjcmVhdGl2ZeKAnSBndWVzdCBpcyBkb2luZyBpcyAi
bGF6eSByZXN0b3Jl4oCdLCBhbmQgIlRoaXMgYXBwcm9hY2ggd2lsbCBub3Qgb3BlcmF0ZSBjb3Jy
ZWN0bHkgZm9yIGEgdmFyaWV0eSBvZiByZWFzb25zLiINCg0KaHR0cHM6Ly9zb2Z0d2FyZS5pbnRl
bC5jb20vc2l0ZXMvZGVmYXVsdC9maWxlcy9tYW5hZ2VkL2M1LzE1L2FyY2hpdGVjdHVyZS1pbnN0
cnVjdGlvbi1zZXQtZXh0ZW5zaW9ucy1wcm9ncmFtbWluZy1yZWZlcmVuY2UucGRmDQoNCg0KMy4z
IFJFQ09NTUVOREFUSU9OUyBGT1IgU1lTVEVNIFNPRlRXQVJFDQoNClN5c3RlbSBzb2Z0d2FyZSBt
YXkgZGlzYWJsZSB1c2Ugb2YgSW50ZWwgQU1YIGJ5IGNsZWFyaW5nIFhDUjBbMTg6MTddLCBieSBj
bGVhcmluZyBDUjQuT1NYU0FWRSwgb3IgYnkgc2V0dGluZw0KSUEzMl9YRkRbMThdLiBJdCBpcyBy
ZWNvbW1lbmRlZCB0aGF0IHN5c3RlbSBzb2Z0d2FyZSBpbml0aWFsaXplIEFNWCBzdGF0ZSAoZS5n
LiwgYnkgZXhlY3V0aW5nIFRJTEVSRUxFQVNFKQ0KYmVmb3JlIGRvaW5nIHNvLiBUaGlzIGlzIGJl
Y2F1c2UgbWFpbnRhaW5pbmcgQU1YIHN0YXRlIGluIGEgbm9uLWluaXRpYWxpemVkIHN0YXRlIG1h
eSBoYXZlIG5lZ2F0aXZlIHBvd2VyIGFuZCBwZXJmb3JtYW5jZSBpbXBsaWNhdGlvbnMuDQoNClN5
c3RlbSBzb2Z0d2FyZSBzaG91bGQgbm90IHVzZSBYRkQgdG8gaW1wbGVtZW50IGEg4oCcbGF6eSBy
ZXN0b3Jl4oCdIGFwcHJvYWNoIHRvIG1hbmFnZW1lbnQgb2YgdGhlIFhUSUxFREFUQQ0Kc3RhdGUg
Y29tcG9uZW50LiBUaGlzIGFwcHJvYWNoIHdpbGwgbm90IG9wZXJhdGUgY29ycmVjdGx5IGZvciBh
IHZhcmlldHkgb2YgcmVhc29ucy4gT25lIGlzIHRoYXQgdGhlIExEVElMRUNGRyBhbmQgVElMRVJF
TEVBU0UgaW5zdHJ1Y3Rpb25zIGluaXRpYWxpemUgWFRJTEVEQVRBIGFuZCBkbyBub3QgY2F1c2Ug
YW4gI05NIGV4Y2VwdGlvbi4gQW5vdGhlciBpcyB0aGF0IGFuIGV4ZWN1dGlvbiBvZiBYU0FWRSBi
eSBhIHVzZXIgdGhyZWFkIHdpbGwgc2F2ZSBYVElMRURBVEEgYXMgaW5pdGlhbGl6ZWQgaW5zdGVh
ZCBvZiB0aGUgZGF0YSBleHBlY3RlZCBieSB0aGUgdXNlciB0aHJlYWQuDQoNCi0tLSANCkp1bg0K
DQoNCg0KDQoNCg==
