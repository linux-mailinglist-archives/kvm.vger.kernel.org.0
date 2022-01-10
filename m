Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 528FC4892F1
	for <lists+kvm@lfdr.de>; Mon, 10 Jan 2022 09:01:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242312AbiAJIBR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 03:01:17 -0500
Received: from mga04.intel.com ([192.55.52.120]:20872 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239605AbiAJH7y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jan 2022 02:59:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641801594; x=1673337594;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=91hJ7VrnqBYhGQoitLBZn4XQpEwV87dot/P2ctqMxLU=;
  b=BH0cPfC7bD9h7Z67I+AJhOx/GCWPjyCygeioVr8djGDmcRaKCeFz4wxH
   pWd3iuw0zway7HbniK+HF0DYjMsTv92UU/G/mBgtuSfb7cmNpx1bSn9Vb
   SLrkwpd0TbX285LmQr2dg/AHkYEzg7mVhFf1HBwGxm9vyiMmCQ6sRnUMA
   XXAhtMEXByU1UcVDCtGoacSCwSaIH9eJEmeJ+ciDpCErA25kTa868j7Tt
   mun/AniQ4kWpV8HwEsZ+57TR54ddpy3Xfw8ziXof2yNThevLGyWIdAwXj
   X67ha+pY39ShHPsMFwwpVlOEkpJyaZITuyIvDkJVjCweasjJMiaInHa6Z
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10222"; a="241987708"
X-IronPort-AV: E=Sophos;i="5.88,276,1635231600"; 
   d="scan'208";a="241987708"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2022 23:55:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,276,1635231600"; 
   d="scan'208";a="764446077"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga005.fm.intel.com with ESMTP; 09 Jan 2022 23:55:20 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Sun, 9 Jan 2022 23:55:20 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Sun, 9 Jan 2022 23:55:19 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Sun, 9 Jan 2022 23:55:19 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Sun, 9 Jan 2022 23:55:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iFeJtLCqld78lbPfNd7GVkI3yDnaFZIuiivC4N7ede4K1btZfN924PiHgocuXhsTwG3R30Z8Q2d44bZW7gz0da5qx6ZX3hgigzABZdmqHKWHL4yELAkOjblJXueLnF3PHDSxH9gBZUYacxAagrx+ijV8XFiZ8QNdH651GewOseU7bZUEHBmlw8ufk1vH1zFMaAXTKVmVkKQm0kpybR77nEHmGAltjoJURTwCnpWOAZOi1egErv2+zFdKmBnv6p6CR3pIQU4H+2gYw0/kttpufBnF8tNP7ETfEqUZoC0qnFKEeOx5T2igUAox6YIpynj6Z3IQiTYOg9NFw880jeh1Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=91hJ7VrnqBYhGQoitLBZn4XQpEwV87dot/P2ctqMxLU=;
 b=ca3hwh1bwVpnOmqTBQ6htSQeqBRuw6YWLN9FH2kJVckios8WYy09DqMv9sIljbHgXNE22BQNK+Y1dVohdnRm2w2unVMUp8HlOrGeg1gs0wZcfBShSoid0PEliJ92QuFuBF709bfpv7rk5OBE6ezBYaPyJnFREpKrel+xl6RfxiyGrzsvWrJnMYSO/6Kfgi3GJtYd4vLD6gdxjeJVuD1ITvO47rlrV+4mJxhmGWDaWEx/cz46aN5B4IE5vqnNzRGj4dLDGVbTy/pf2B/r6sbxRjtJWj/aIxuGakTzfJnnoOeuMt4LhHoz2EzQgwVDjHJ8FRcOt58WrmR1P6NWFRjFpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN7PR11MB2868.namprd11.prod.outlook.com (2603:10b6:406:a9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Mon, 10 Jan
 2022 07:55:16 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04%2]) with mapi id 15.20.4867.012; Mon, 10 Jan 2022
 07:55:16 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     "cohuck@redhat.com" <cohuck@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>
Subject: RE: [RFC PATCH] vfio: Update/Clarify migration uAPI, add NDMA state
Thread-Topic: [RFC PATCH] vfio: Update/Clarify migration uAPI, add NDMA state
Thread-Index: AQHX7VV0XQcySACwoUuiLSnTAAZEGKwq7veAgAX5vQCAAUtwAIAJ0m2AgBdyDgCAAv/9AIAAM0+AgAVWcQA=
Date:   Mon, 10 Jan 2022 07:55:16 +0000
Message-ID: <BN9PR11MB52767CB9E4C30143065549C98C509@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <163909282574.728533.7460416142511440919.stgit@omen>
 <20211210012529.GC6385@nvidia.com>
 <20211213134038.39bb0618.alex.williamson@redhat.com>
 <20211214162654.GJ6385@nvidia.com>
 <20211220152623.50d753ec.alex.williamson@redhat.com>
 <20220104202834.GM2328285@nvidia.com>
 <20220106111718.0e5f5ed6.alex.williamson@redhat.com>
 <20220106212057.GM2328285@nvidia.com>
In-Reply-To: <20220106212057.GM2328285@nvidia.com>
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
x-ms-office365-filtering-correlation-id: 02afbf7a-7265-42d5-a624-08d9d40e8a7d
x-ms-traffictypediagnostic: BN7PR11MB2868:EE_
x-microsoft-antispam-prvs: <BN7PR11MB2868F454A84112B4964FE53D8C509@BN7PR11MB2868.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /5CFh7nEx+fvpxDXIQ0kcEBaJMdJxvkJeoEEfPPy1iP4vCts3NBpBzbyDpSQMlniGjImzDTKi1vmIUMpfqbDfMAB78vuQXWQ40HrS+er4ki4yGkpOFzb2+u+sfViBJ8Ipym5KFafpBDW13wVKeq6LpFZJrjeaK6bEzKUBPGcCofW/TnO6500MQv1ShSgmO+2Ug7mEZwXIOtTK1cCNbp0rkH5WFSSyi6iA73SC0JJh1xlkvJCel4fvbC0D92AIRUEDzWEGJDYLP8pCZywsnV+/PgNQcsoj9c1wCixOyXYN8HHPQ6JKymneqG6fdvVZQxR1MCH4kW1QclOJO7jiTgPZIu9oc5mLX/EH++yP3EQOcOJQqEgRqtg2AQ567rUEb6mkEXzdTTs2TorqeOC8piZextYMLbDCauQdjpNSjHgvy2a/XutOpofwlJGMASoFHy2Lkh48RE46xCORlbYWW3Kbh6hAj8LD/S8g9FlWHgxae4nkVgvw+/IARWCF/vMk8SuFECqC9sY9723oFaWvQNJvYfpQWBtT3kqA+jqQTZ+Q8MQh1EsDsYencXNUng2TTfNjAdyQPz8MYeLx/65GT0bafS+peyGlGjchNaa0FXxGGGmE1bH9zXBlbEapgLH+QGws53UwdiqdvvQsf7UCcyfsJn0pDwmbUBsBVT8rFtvse1Zpra+193TwlB5Lm+WZVrF/8cuIkMff3f8I6stcGDC4g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(52536014)(26005)(38100700002)(33656002)(316002)(55016003)(76116006)(83380400001)(38070700005)(71200400001)(9686003)(186003)(508600001)(64756008)(66446008)(82960400001)(66476007)(66556008)(7696005)(66946007)(86362001)(5660300002)(122000001)(8936002)(4326008)(8676002)(2906002)(54906003)(6506007)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cVB0Wk5SOGVmcTk1UDVEOHk0cFJJSytwaUVWa3NYWWRuazVYeThMNUdnL3NE?=
 =?utf-8?B?WUtkdDIwMmc4eVM2b28xRytWU3liSGQ2L2JTZnlEWmU1Zyt1eDFRU2NQdEFv?=
 =?utf-8?B?aFEzTDkvdlROSUV5YkppUDU4Q1Y2V0IwdXgwZVlpNmI4djJVbDdkMzhEdFo0?=
 =?utf-8?B?blJaSnFLRFlUeXdQc1YrN3RlZ283T2lZdTdiL3ZqbmprRnYyU2p6b3BaUEVC?=
 =?utf-8?B?WTN2ZzRuT056aEpoOWxRSmpzTDdDM25oU2RQSHF0Mk5sbWM0U1FZZWdjVnRG?=
 =?utf-8?B?R3ZVNnVQZmx6SG85YzRMMTVmR09pS3JMNStCRTg3eVlsVTRNUG53akRPTVA2?=
 =?utf-8?B?dWtydXRCYTZoMnRXR3FmSnB1bzJIYmc4ampnWjgxUGM0cE1yZUxyVjdWOFJS?=
 =?utf-8?B?OVNENjhSSU9FSkhWL2hkK1BnV202ZTdFSnpUc25ZM2FMdkVCN0hUaUdQcHNX?=
 =?utf-8?B?UHZzRGtHSk9IREdWbm5PRDFET1gxeFBpS2sxYitEU25CeG4wMWJ1MzhTWjlj?=
 =?utf-8?B?bDU4OHNLTWRXWi82YmE1dVFFMFZwVEZjMVpycmV6b282L3BSbWpTdnhiTWJw?=
 =?utf-8?B?ZTJOZDlveFBDTlllem00Z3lxWldsSXNleEg5WkpKRmtQQlUvS0U1NjNkbmpm?=
 =?utf-8?B?SFpkZ3dwRC9vTFE2eG9tVHgyUTVRQVExT1NXdnB1TEllQUN0c2x6YXEyRVMx?=
 =?utf-8?B?YkhsL1JzZW56dmtHVjJIelRaMlpDZEFpZkVGYTFya2MzZElVN3JPSmJsbWdG?=
 =?utf-8?B?TFoxU2lGWlhjWmhDRUt0MStBeE1NemNzYzJVTWdkbEwzR2t1cWVaQWphUjJy?=
 =?utf-8?B?QWNzWHByTEpGV3c2WTNxZVpveFRjNDFWQmlHU1ZIN243eTVPdS9oNFM4S2VP?=
 =?utf-8?B?VzBHbjh0S0t1QzB6emJ6SnRlelRIQWhycDUrR21Od3M4ZG55VUFONk5xdjFl?=
 =?utf-8?B?emI2ZVBlNDlTc1l4Y0thNU1maU16eldDV1JraUJGUUl6YzBLelJkVE1RdUpo?=
 =?utf-8?B?THBGK1lIRTl0NDJsQXZXZFRzUy84eHM5M0lKS3VzdHRoVUlLazN3bkV2K2Q3?=
 =?utf-8?B?VFZLb2JoTGpHN3lTSEQ0eTFQTEJMbklSUGYrcWt4U3hISHlxVWdyOFdnLzFT?=
 =?utf-8?B?THhjaEdDTVlRT1MwVm9GRmdLZjh5TEplY2VDWTlRNkFtdnBCZm1nNE1OeENH?=
 =?utf-8?B?UFRRYTYrRndFZTlma0VHRHlhVHBoZERGT0p0UE9VQ2RwZ3BwTHJDVFJUckUw?=
 =?utf-8?B?U2RSeEZHbGoxenkveGh1RUwrenByMTNwU2pLOXh4bjR2ZXdlSEt1NHl2NDJE?=
 =?utf-8?B?eVl4VG9XK2djWmlEaEVlQTFiVjc4bFJjRlJqVUl4Y2U4Vmo2c2UrZml2cU9M?=
 =?utf-8?B?b2cwVVhzbExqcjdJRk1hNGZYb3JlcVh5ZjZrMnRRWGJrdHZqOVdrZ29aRkN5?=
 =?utf-8?B?b284aDA1WnFydHlyT1luUCszd3BPYmhyR054eFB5WjJQcUpGdkFMT2VnVFBW?=
 =?utf-8?B?dnlVKzBiUk1nS1M1ZXV0U3JGRXVxY1Z3aEN6UHhGcjZmL1RvVTlQdWdiZUtX?=
 =?utf-8?B?eEZYUE5oS0x1Y1BRbmpBVlVoemtQYVBnbnRQK05YZzJpMGE0NmEzbEJLSUpK?=
 =?utf-8?B?d1NRY1JmWks5cjJyRklSV28vN2JJTUtlT29iQ0JYeTJaT1l3Q3puZUhzU1Bz?=
 =?utf-8?B?dXRHYVpKa3pjNDNaaXhxd3R2cnplUG1VN2RuLzR4c21jSkZOYjBibGtkRGpL?=
 =?utf-8?B?bytSWmdnZHpqSDJTSytnWUdLcHczUTNGOVRZNnJ4QVQ4bW9IMUtaRnZGcHRN?=
 =?utf-8?B?RW1RVE9JdmhOdUQ5OUd2cUlrODRVYW96RHdtQVExUVhTVzVGVlZ1UU0yTGls?=
 =?utf-8?B?RThmRkptdGtRTFNoWmJEOGc4WVFUNTl2alVWYmhrMi9LNlBCZUZESTUrdDBu?=
 =?utf-8?B?bEs3cmRJdElMVHljaEpmKzI1eURTVGp3bFBSYnhWZUVjRDBZNUdZRVZRWHZP?=
 =?utf-8?B?Tk5mdFNPa1F4dkpNWWIyd3lnMjROa3AxbW5IY0ljOWxaVEVINDRRVFVVZThy?=
 =?utf-8?B?bklvUHAyL2ErTWIzWktrcDBLZ2dSSDZrUjRFLzR4TmJtVzRUM2xiVkcyS1NT?=
 =?utf-8?B?UnYzS3dBWmRCZW9hcmhmNUN6eVdIczVxRGw2ZU5zazl1aVVYN1VoRE00T2p2?=
 =?utf-8?Q?vWVxfco12DoOrqXhMc+ToMg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02afbf7a-7265-42d5-a624-08d9d40e8a7d
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2022 07:55:16.6811
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rBj1BC7FqT3q5Sc/tlYTNbfI7/9ZFC3ehaRhmoKc800/KXMaxjrvOdzFiJ36CNyz6/wYqnqShdzhfXX/yz8P1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR11MB2868
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPg0KPiBTZW50OiBGcmlkYXks
IEphbnVhcnkgNywgMjAyMiA1OjIxIEFNDQo+IA0KPiBXZSB3ZXJlIGFsc28gdGhpbmtpbmcgdG8g
cmV0YWluIFNUT1AuIFNBVklORyAtPiBTVE9QIGNvdWxkIHBvc3NpYmx5DQo+IHNlcnZlIGFzIHRo
ZSBhYm9ydCBwYXRoIHRvIGF2b2lkIGEgZG91YmxlIGFjdGlvbiwgYW5kIHNvbWUgb2YgdGhlIHVz
ZQ0KPiBjYXNlcyB5b3UgSUQnZCBiZWxvdyBhcmUgYWNoaWV2YWJsZSBpZiBTVE9QIHJlbWFpbnMu
DQoNCndoYXQgaXMgdGhlIGV4YWN0IGRpZmZlcmVuY2UgYmV0d2VlbiBhIG51bGwgc3RhdGUge30g
KGltcGx5aW5nICFSVU5OSU5HKQ0KYW5kIFNUT1AgaW4gdGhpcyBjb250ZXh0Pw0KDQpJZiB0aGV5
IGFyZSBkaWZmZXJlbnQsIHdobyAodXNlciBvciBkcml2ZXIpIHNob3VsZCBjb25kdWN0IGFuZCB3
aGVuIGRvIA0Kd2UgZXhwZWN0IHRyYW5zaXRpb25pbmcgdGhlIGRldmljZSBpbnRvIGEgbnVsbCBz
dGF0ZT8NCg0KPiANCj4gPiBXZSBoYXZlIDIwIHBvc3NpYmxlIHRyYW5zaXRpb25zLiAgSSd2ZSBt
YXJrZWQgdGhvc2UgYXZhaWxhYmxlIHZpYSB0aGUNCj4gPiAib2RkIGFzY2lpIGFydCIgZGlhZ3Jh
bSBhcyAoYSksIHRoYXQncyA3IHRyYW5zaXRpb25zLiAgV2UgY291bGQNCj4gPiBlc3NlbnRpYWxs
eSByZW1vdmUgdGhlIE5VTEwgc3RhdGUgYXMgdW5yZWFjaGFibGUgYXMgdGhlcmUgc2VlbXMgbGl0
dGxlDQo+ID4gdmFsdWUgaW4gdGhlIDIgdHJhbnNpdGlvbnMgbWFya2VkIChhKSogaWYgd2UgbG9v
ayBvbmx5IGF0IG1pZ3JhdGlvbiwNCj4gPiB0aGF0IHdvdWxkIGJyaW5nIHVzIGRvd24gdG8gNSBv
ZiAxMiBwb3NzaWJsZSB0cmFuc2l0aW9ucy4gIFdlIG5lZWQgdG8NCj4gPiBnaXZlIHVzZXJzcGFj
ZSBhbiBhYm9ydCBwYXRoIHRob3VnaCwgc28gd2UgbWluaW1hbGx5IG5lZWQgdGhlIDINCj4gPiB0
cmFuc2l0aW9ucyBtYXJrZWQgKGIpICg3LzEyKS4NCj4gDQo+ID4gU28gbm93IHdlIGNhbiBkaXNj
dXNzIHRoZSByZW1haW5pbmcgNSB0cmFuc2l0aW9uczoNCj4gPg0KPiA+IHtTQVZJTkd9IC0+IHtS
RVNVTUlOR30NCj4gPiAJSWYgbm90IHN1cHBvcnRlZCwgdXNlciBjYW4gYWNoaWV2ZSB0aGlzIHZp
YToNCj4gPiAJCXtTQVZJTkd9LT57UlVOTklOR30tPntSRVNVTUlOR30NCj4gPiAJCXtTQVZJTkd9
LVJFU0VULT57UlVOTklOR30tPntSRVNVTUlOR30NCj4gDQo+IFRoaXMgY2FuIGJlOg0KPiANCj4g
U0FWSU5HIC0+IFNUT1AgLT4gUkVTVU1JTkcNCg0KRnJvbSBBbGV4J3Mgb3JpZ2luYWwgZGVzY3Jp
cHRpb24gdGhlIGRlZmF1bHQgZGV2aWNlIHN0YXRlIGlzIFJVTk5JTkcuDQpUaGlzIHN1cHBvc2Vk
IHRvIGJlIHRoZSBpbml0aWFsIHN0YXRlIG9uIHRoZSBkZXN0IG1hY2hpbmUgZm9yIHRoZQ0KZGV2
aWNlIGFzc2lnbmVkIHRvIFFlbXUgYmVmb3JlIFFlbXUgcmVzdW1lcyB0aGUgZGV2aWNlIHN0YXRl
Lg0KVGhlbiBob3cgZG8gd2UgZWxpbWluYXRlIHRoZSBSVU5OSU5HIHN0YXRlIGluIGFib3ZlIGZs
b3c/IFdobw0KbWFrZXMgU1RPUCBhcyB0aGUgaW5pdGlhbCBzdGF0ZSBvbiB0aGUgZGVzdCBub2Rl
Pw0KDQo+ID4gZHJpdmVycyBmb2xsb3cgdGhlIHByZXZpb3VzbHkgcHJvdmlkZWQgcHNldWRvIGFs
Z29yaXRobSB3aXRoIHRoZQ0KPiA+IHJlcXVpcmVtZW50IHRoYXQgdGhleSBjYW5ub3QgcGFzcyB0
aHJvdWdoIGFuIGludmFsaWQgc3RhdGUsIHdlIG5lZWQgdG8NCj4gPiBmb3JtYWxseSBhZGRyZXNz
IHdoZXRoZXIgdGhlIE5VTEwgc3RhdGUgaXMgaW52YWxpZCBvciBqdXN0IG5vdA0KPiA+IHJlYWNo
YWJsZSBieSB0aGUgdXNlci4NCj4gDQo+IFdoYXQgaXMgYSBOVUxMIHN0YXRlPw0KDQpIYWgsIHNl
ZW1zIEknbSBub3QgdGhlIG9ubHkgb25lIGhhdmluZyB0aGlzIGNvbmZ1c2lvbi4g8J+Yig0KDQo+
IA0KPiBXZSBoYXZlIGRlZmluZWQgKGZyb20gbWVtb3J5LCBmb3JnaXZlIG1lIEkgZG9uJ3QgaGF2
ZSBhY2Nlc3MgdG8NCj4gWWlzaGFpJ3MgbGF0ZXN0IGNvZGUgYXQgdGhlIG1vbWVudCkgOCBmb3Jt
YWwgRlNNIHN0YXRlczoNCj4gDQo+ICBSVU5OSU5HDQo+ICBQUkVDT1BZDQo+ICBQUkVDT1BZX05E
TUENCj4gIFNUT1BfQ09QWQ0KPiAgU1RPUA0KPiAgUkVTVU1JTkcNCj4gIFJFU1VNSU5HX05ETUEN
Cj4gIEVSUk9SIChwZXJoYXBzIE1VU1RfUkVTRVQpDQoNCkVSUk9SLT5TSFVURE9XTj8gVXN1YWxs
eSBhIHNodXRkb3duIHN0YXRlIGltcGxpZXMgcmVzZXQgcmVxdWlyZWQuLi4NCg0KPiANCj4gPiBC
dXQgSSB0aGluayB5b3UndmUgaWRlbnRpZmllZCB0d28gY2xhc3NlcyBvZiBETUEsIE1TSSBhbmQg
ZXZlcnl0aGluZw0KPiA+IGVsc2UuICBUaGUgZGV2aWNlIGNhbiBhc3N1bWUgdGhhdCBhbiBNU0kg
aXMgc3BlY2lhbCBhbmQgbm90IGluY2x1ZGVkIGluDQo+ID4gTkRNQSwgYnV0IGl0IGNhbid0IGtu
b3cgd2hldGhlciBvdGhlciBhcmJpdHJhcnkgRE1BcyBhcmUgcDJwIG9yIG1lbW9yeS4NCj4gPiBJ
ZiB3ZSBkZWZpbmUgdGhhdCB0aGUgbWluaW11bSByZXF1aXJlbWVudCBmb3IgbXVsdGktZGV2aWNl
IG1pZ3JhdGlvbiBpcw0KPiA+IHRvIHF1aWVzY2UgcDJwIERNQSwgZXguIGJ5IG5vdCBhbGxvd2lu
ZyBpdCBhdCBhbGwsIHRoZW4gTkRNQSBpcw0KPiA+IGFjdHVhbGx5IHNpZ25pZmljYW50bHkgbW9y
ZSByZXN0cmljdGl2ZSB3aGlsZSBpdCdzIGVuYWJsZWQuDQo+IA0KPiBZb3UgYXJlIHJpZ2h0LCBi
dXQgaW4gYW55IHByYWN0aWNhbCBwaHlzaWNhbCBkZXZpY2UgTkRNQSB3aWxsIGJlDQo+IGltcGxl
bWVudGVkIGJ5IGhhbHRpbmcgYWxsIERNQXMsIG5vdCBqdXN0IHAycCBvbmVzLg0KPiANCj4gSSBk
b24ndCBtaW5kIHdoYXQgd2UgbGFiZWwgdGhpcywgc28gbG9uZyBhcyB3ZSB1bmRlcnN0YW5kIHRo
YXQgaGFsdGluZw0KPiBhbGwgRE1BIGlzIGEgdmFsaWQgZGV2aWNlIGltcGxlbWVudGF0aW9uLg0K
PiANCj4gQWN0dWFsbHksIGhhdmluZyByZWZsZWN0ZWQgb24gdGhpcyBub3csIG9uZSBvZiB0aGUg
dGhpbmdzIG9uIG15IGxpc3QNCj4gdG8gZml4IGluIGlvbW11ZmQsIGlzIHRoYXQgbWRldnMgY2Fu
IGdldCBhY2Nlc3MgdG8gUDJQIHBhZ2VzIGF0IGFsbC4NCj4gDQo+IFRoaXMgaXMgY3VycmVudGx5
IGJ1Z2d5IGFzLWlzIGJlY2F1c2UgdGhleSBjYW5ub3QgRE1BIG1hcCB0aGVzZQ0KPiB0aGluZ3Ms
IHRvdWNoIHRoZW0gd2l0aCB0aGUgQ1BVIGFuZCBrbWFwLCBvciBkbywgcmVhbGx5LCBhbnl0aGlu
ZyB3aXRoDQo+IHRoZW0uDQoNCkNhbiB5b3UgZWxhYm9yYXRlIHdoeSBtZGV2IGNhbm5vdCBhY2Nl
c3MgcDJwIHBhZ2VzPw0KDQo+IA0KPiBTbyB3ZSBzaG91bGQgYmUgYmxvY2tpbmcgbWRldidzIGZy
b20gYWNjZXNzaW5nIFAyUCwgYW5kIGluIHRoYXQgY2FzZSBhDQo+IG1kZXYgZHJpdmVyIGNhbiBx
dWl0ZSByaWdodGx5IHNheSBpdCBkb2Vzbid0IHN1cHBvcnQgUDJQIGF0IGFsbCBhbmQNCj4gc2Fm
ZWx5IE5PUCBORE1BIGlmIE5ETUEgaXMgZGVmaW5lZCB0byBvbmx5IGltcGFjdCBQMlAgdHJhbnNh
Y3Rpb25zLg0KPiANCj4gUGVyaGFwcyB0aGF0IGFuc3dlcnMgdGhlIHF1ZXN0aW9uIGZvciB0aGUg
UzM5MCBkcml2ZXJzIGFzIHdlbGwuDQo+IA0KPiA+IFNob3VsZCBhIGRldmljZSBpbiB0aGUgRVJS
T1Igc3RhdGUgY29udGludWUgb3BlcmF0aW9uIG9yIGJlIGluIGENCj4gPiBxdWllc2NlZCBzdGF0
ZT8gIEl0IHNlZW1zIG9idmlvdXMgdG8gbWUgdGhhdCBzaW5jZSB0aGUgRVJST1Igc3RhdGUgaXMN
Cj4gPiBlc3NlbnRpYWxseSB1bmRlZmluZWQsIHRoZSBkZXZpY2Ugc2hvdWxkIGNlYXNlIG9wZXJh
dGlvbnMgYW5kIGJlDQo+ID4gcXVpZXNjZWQgYnkgdGhlIGRyaXZlci4gIElmIHRoZSBkZXZpY2Ug
aXMgY29udGludWluZyB0byBvcGVyYXRlIGluIHRoZQ0KPiA+IHByZXZpb3VzIHN0YXRlLCB3aHkg
d291bGQgdGhlIGRyaXZlciBwbGFjZSB0aGUgZGV2aWNlIGluIHRoZSBFUlJPUg0KPiA+IHN0YXRl
PyAgSXQgc2hvdWxkIGhhdmUgcmV0dXJuZWQgYW4gZXJybm8gYW5kIGxlZnQgdGhlIGRldmljZSBp
biB0aGUNCj4gPiBwcmV2aW91cyBzdGF0ZS4NCj4gDQo+IFdoYXQgd2UgZm91bmQgd2hpbGUgaW1w
bGVtZW50aW5nIGlzIHRoZSB1c2Ugb2YgRVJST1IgYXJpc2VzIHdoZW4gdGhlDQo+IGRyaXZlciBo
YXMgYmVlbiBmb3JjZWQgdG8gZG8gbXVsdGlwbGUgYWN0aW9ucyBhbmQgaXMgdW5hYmxlIHRvIGZ1
bGx5DQo+IHVud2luZCB0aGUgc3RhdGUuIFNvIHRoZSBkZXZpY2Vfc3RhdGUgaXMgbm90IGZ1bGx5
IHRoZSBvcmlnaW5hbCBzdGF0ZQ0KPiBvciBmdWxseSB0aGUgdGFyZ2V0IHN0YXRlLiBUaHVzIGl0
IGlzIEVSUk9SLg0KPiANCj4gVGhlIGFkZGl0aW9uYWwgcmVxdWlyZW1lbnQgdGhhdCB0aGUgZHJp
dmVyIGRvIGFub3RoZXIgYWN0aW9uIHRvDQo+IHF1aWVzY2UgdGhlIGRldmljZSBvbmx5IGludHJv
ZHVjZXMgdGhlIHBvc3NpYmxpdHkgZm9yIHRyaXBsZSBmYWlsdXJlLg0KPiANCj4gU2luY2UgaXQg
ZG9lc24ndCBicmluZyBhbnkgdmFsdWUgdG8gdXNlcnNwYWNlLCBJIHByZWZlciB3ZSBub3QgZGVm
aW5lDQo+IHRoaW5ncyBpbiB0aGlzIGNvbXBsaWNhdGVkIHdheS4NCg0KU28gRVJST1IgaXMgcmVh
bGx5IGFib3V0IHVucmVjb3ZlcmFibGUgZmFpbHVyZXMuIElmIHJlY292ZXJhYmxlIHN1cHBvc2UN
CmVycm5vIHNob3VsZCBoYXZlIGJlZW4gcmV0dXJuZWQgYW5kIHRoZSBkZXZpY2UgaXMgc3RpbGwg
aW4gdGhlIG9yaWdpbmFsDQpzdGF0ZS4gSXMgdGhpcyB1bmRlcnN0YW5kaW5nIGNvcnJlY3Q/DQoN
CmJ0dyB3aGljaCBlcnJubyBpbmRpY2F0ZXMgdG8gdGhlIHVzZXIgdGhhdCB0aGUgZGV2aWNlIGlz
IGJhY2sgdG8gdGhlDQpvcmlnaW5hbCBzdGF0ZSBvciBpbiB0aGUgRVJST1Igc3RhdGU/IG9yIHdh
bnQgdGhlIHVzZXIgdG8gYWx3YXlzIGNoZWNrDQp0aGUgZGV2aWNlIHN0YXRlIHVwb24gYW55IHRy
YW5zaXRpb24gZXJyb3I/DQoNCj4gDQo+ID4gPiBJIHByZWZlciBhIG1vZGVsIHdoZXJlIHRoZSBk
ZXZpY2UgaXMgYWxsb3dlZCB0byBrZWVwIGRvaW5nIHdoYXRldmVyIGl0DQo+ID4gPiB3YXMgZG9p
bmcgYmVmb3JlIGl0IGhpdCB0aGUgZXJyb3IuIFlvdSBhcmUgcHVzaGluZyBmb3IgYSBtb2RlbCB3
aGVyZQ0KPiA+ID4gdXBvbiBlcnJvciB3ZSBtdXN0IGZvcmNlIHRoZSBkZXZpY2UgdG8gc3RvcC4N
Cj4gPg0KPiA+IElmIHRoZSBkZXZpY2UgY29udGludWVzIG9wZXJhdGluZyBpbiB0aGUgcHJldmlv
dXMgbW9kZSB0aGVuIGl0DQo+ID4gc2hvdWxkbid0IGVudGVyIHRoZSBFUlJPUiBzdGF0ZSwgaXQg
c2hvdWxkIHJldHVybiBlcnJubyBhbmQgcmUtcmVhZGluZw0KPiA+IGRldmljZV9zdGF0ZSBzaG91
bGQgaW5kaWNhdGUgaXQncyBpbiB0aGUgcHJldmlvdXMgc3RhdGUuDQo+IA0KPiBDb250aW51ZXMg
b3BlcmF0aW5nIGluIHRoZSBuZXcvcHJldmlvdXMgc3RhdGUgaXMgYW4gJ3VwcGVyIGJvdW5kJyBv
bg0KPiB3aGF0IGl0IGlzIGFsbG93ZWQgdG8gZG8uIEZvciBpbnN0YW5jZSBpZiB3ZSBhcmUgZ29p
bmcgZnJvbSBSVU5OSU5HIC0+DQo+IFNBVklORyBtbHg1IG11c3QgdHJhbnNpdCB0aHJvdWdoICdS
VU5OSU5HfE5ETUEnIGFzIHBhcnQgb2YgaXRzDQo+IGludGVybmFsIGRlc2lnbi4NCj4gDQo+IElm
IGl0IHRoZW4gZmFpbHMgaXQgY2FuJ3QgY29udGludWUgdG8gcHJldGVuZCBpdCBpcyBSVU5OSU5H
IHdoZW4gaXQgaXMNCj4gZG9pbmcgUlVOTklOR3xORE1BIGFuZCBhIGRvdWJsZSBmYWlsdXJlIG1l
YW5zIHdlIGNhbid0IHJlc3RvcmUNCj4gUlVOTklORy4NCj4gDQo+IEFsbG93aW5nIEVSUk9SIHRv
IGNvbnRpbnVlIGFueSBiZWhhdmlvciBhbGxvd2VkIGJ5IFJVTk5JTkcgYWxsb3dzIHRoZQ0KPiBk
ZXZpY2UgdG8gYmUgbGVmdCBpbiBSVU5OSU5HfE5ETUEgYW5kIGVsaW1pbmF0ZXMgdGhlIHBvc3Np
YmxpdHkgb2YNCj4gdHJpcGxlIGZhaWx1cmUgaW4gYSB0cmFuc2l0aW9uIHRvICdTVE9QJy4NCj4g
DQo+IEluZGVlZCB3ZSBjYW4gc2ltcGxpZnkgdGhlIGRyaXZlciBieSByZW1vdmluZyBmYWlsdXJl
IHJlY292ZXJpZXMgZm9yDQo+IGNhc2VzIHRoYXQgaGF2ZSBhIGRvdWJsZSBmYXVsdCBhbmQgc2lt
cGx5IGdvIHRvIEVSUk9SLiBUaGlzIGlzIG5vdCBzbw0KPiB2aWFibGUgaWYgRVJST1IgaXRzZWxm
IHJlcXVpcmVzIGFuIGFjdGlvbiB0byBlbnRlciBpdCBhcyB3ZSBnZXQgYmFjaw0KPiB0byBoYXZp
bmcgdG8gZGVhbCB3aXRoIGRvdWJsZSBhbmQgdHJpcGxlIGZhdWx0cy4NCg0KT3IgaGF2ZSBhIHdh
eSBmb3IgdGhlIHVzZXIgdG8gc3BlY2lmeSB0aGUgcG9saWN5IHdoZW4gZW50ZXJpbmcgRVJST1Is
DQplLmcuIGFza2luZyB0aGUgbWlncmF0aW9uIGRyaXZlciB0byBjb25kdWN0IGFuIGludGVybmFs
IHJlc2V0IGlmIHVuZGVmaW5lZA0KYmVoYXZpb3IgaW4gdGhpcyBzdGF0ZSBpcyBhIGNvbmNlcm4g
YW5kIHRoZSB1c2VyIGRvZXNuJ3Qgd2FudCB0byBmdXJ0aGVyDQpkaWFnbm9zZSB0aGUgZGV2aWNl
IGNvbnRleHQ/DQoNClRoYW5rcw0KS2V2aW4NCg==
