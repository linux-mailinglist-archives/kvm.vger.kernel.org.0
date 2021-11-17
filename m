Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0776C4544C7
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 11:15:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236151AbhKQKSf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 05:18:35 -0500
Received: from mga18.intel.com ([134.134.136.126]:19477 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233876AbhKQKSd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Nov 2021 05:18:33 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10170"; a="220805164"
X-IronPort-AV: E=Sophos;i="5.87,241,1631602800"; 
   d="scan'208";a="220805164"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2021 02:15:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,241,1631602800"; 
   d="scan'208";a="593305201"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP; 17 Nov 2021 02:15:34 -0800
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 17 Nov 2021 02:15:34 -0800
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 17 Nov 2021 02:15:33 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Wed, 17 Nov 2021 02:15:33 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.173)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Wed, 17 Nov 2021 02:15:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mm6FMbNENed8DcTlYza0ubfjum6WNw3ANn3FEgqc9616ZGq9gW1xreMpB/LBikra6lvAwDd/ZR9uJwq6dwpCSB/XXrJ5F2gJdwsr1ycrcTNhaPjavPZlNYBzrT1XRfRUR0UYcGFhkEkyOkCdOUn+W0zsYHHVQRipm4ECzyPTw1Dzwvj0jdOLCHWvIuN2BH9gm/4ZTe6gqOPzf16R6KCk/M0G7TPNFC6A+0iKhyWWIXX4H/CdoqdhwFqId8qXqiWGldbVC25YeKnHan7A7M5FrDE5ta9PRsf/Ez4TOeKNK5F363vOYuIwdtCYkLj0CMDY+vK0ywMM9OUF9Kj5k5WyCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SZPultWxB+rpY9YEMDuy95bKwDODvX8CiEozDkqMUpo=;
 b=C6REOg//9w2qyeCn37CXk0WnNTOMdL9zBXK76b2mp20WiChrRMrHV/fi6puyrLjC6jknWbTh9SezUghyXpSw+JSag17mxQd+3T1XzGsZoaIkNwlEZdo/BSBSD6yx7PEC0QUUI4LvH1MB+5BrDkoGFye6MM3in9rx5VF7OrQDlM70Lr4LJFQg/syMKpfzlqUxULSoLKGhvNj2BEhlXGjOOlOfk17vInqPOVLHN5XHHTjeIWe3/wHQwdR/vAVd45p24lmLT3RsLq9p91N5ZMykiSGEiB2gD6uaU56KKTriI4MT5eQ5wbwL6HCKI7sVd4U+tnkcjTDUdkTWCfKn+06m7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SZPultWxB+rpY9YEMDuy95bKwDODvX8CiEozDkqMUpo=;
 b=bIrSS5xQmpIddy8sUS16IPVJ6bjzkRBZhYdQlNs7wXyq+ICtneHf8a52dW/FYQnA5M48xTa7WvJVHhXkyCHOZ85koIPmM/WaoOeGTTvdgtR2qE8T9G/nDZFcvkRdrQpPqvOhtyzhDA/KNPbamSvtuzjPT66IFaVPTNpHVY3B2qM=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN6PR11MB1331.namprd11.prod.outlook.com (2603:10b6:404:49::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27; Wed, 17 Nov
 2021 10:15:32 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ecad:62e1:bab9:ac81]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ecad:62e1:bab9:ac81%9]) with mapi id 15.20.4690.027; Wed, 17 Nov 2021
 10:15:32 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC:     "Liu, Jing2" <jing2.liu@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Arjan van de Ven" <arjan@linux.intel.com>,
        Jing Liu <jing2.liu@linux.intel.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "Cooper, Andrew" <andrew.cooper3@citrix.com>,
        "Bae, Chang Seok" <chang.seok.bae@intel.com>
Subject: RE: Thoughts of AMX KVM support based on latest kernel
Thread-Topic: Thoughts of AMX KVM support based on latest kernel
Thread-Index: AdfWMJGMz5/jeSLQRn+nYCX+7Qj8nwE7nDEAABP7RQAABYsJgAAE2utw
Date:   Wed, 17 Nov 2021 10:15:32 +0000
Message-ID: <BN9PR11MB5433D6A1368904D9B748846B8C9A9@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <BYAPR11MB325685AB8E3DFD245846F854A9939@BYAPR11MB3256.namprd11.prod.outlook.com>
 <878rxn6h6t.ffs@tglx> <16BF8BE6-B7B1-4F3E-B972-9D82CD2F23C8@intel.com>
 <2e2ab02c-b324-e136-924a-0376040163a8@redhat.com>
In-Reply-To: <2e2ab02c-b324-e136-924a-0376040163a8@redhat.com>
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
x-ms-office365-filtering-correlation-id: 1aabefe4-b8c6-4576-a24e-08d9a9b33072
x-ms-traffictypediagnostic: BN6PR11MB1331:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BN6PR11MB133179A8115367617EBC8FD78C9A9@BN6PR11MB1331.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pfvVkKmUFGfllsFfxodlAnLjl6d8BQPq2iUslGrSHKB1eGWhwTIyT7u1bYQuVwpEmmca3pYzDw31yS15XnvrHFY+f9LANCaYB6OZkX+ZoRtGZh8UoINjqD26LsuniR9pUNJR+nucHsjmjb+d29dCvmP7LpMbxrBSehBCiTStG0vVGRUQxckhlxX8kmBN4c7/oq6/KaDzoGh1lrCwBx/EZYrcfnZW8dCtk9d6oqk8r5q9PeQB/k9jIrcIeDukE6rDkYbOC1pinTqkEp5WX+oYTTsWOoj7poELBqs/2w6MHtX8JQd5rzd5uJueDbpcESetpkimAMhjZqWSPnLtgc4NlOxUZJL8NCl4x2lbXiYfoL5nFU/EopjO/ZLGK4aNJTu2NUATtHXcZZOqmHiuP2lFnAYY+N//dhQ4+X+bsqvzVi56YSJmeah+SlhkfbLEQNNpDudx+8cO2J4w1QuzVRNJGy3cRIjfLyj+VcgWmQ0ClPNLBCK0UTCdxD4Qv6lzxALpZh2owh9wim2D+9EDq4pOAZMhEWO6NHusx8FwaiSJ8AKz2gnIxxMNeY6nFtzwMhLDEZ1EKwuTG0ffygDM1pMkQn4vhzkMwDr72BPBp2rF4lNWkI2VAVHIQXk6LGwfSza27M2VM+qfRqb5Sk+K7C88Iyfv9T24rtxndA18sPBYEP4E4HA6XlqVae2d+y7fmrryNPPjsku2oOx1HP5tAMBImA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(110136005)(52536014)(54906003)(33656002)(66946007)(86362001)(122000001)(55016002)(66446008)(66476007)(316002)(9686003)(7416002)(8936002)(66556008)(64756008)(53546011)(6506007)(186003)(8676002)(26005)(7696005)(76116006)(83380400001)(38100700002)(508600001)(82960400001)(71200400001)(2906002)(5660300002)(4326008)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QWFBakw2dk41WE16cEFLR052S0JRdDRLQm1xTDcxUWlsWDhLV1Q0RnFCR3pl?=
 =?utf-8?B?b3NubGZRKy9mMEU3KzNUOGxyaUlNeDVWeGFjQlNjV05BTzlUVkZvdGtIekVO?=
 =?utf-8?B?UlU2K2x1R0NiaFd2TlEwWFdUNXZ3YVNQTGZzNHVMRHhiNXRDWVdtb3JsbGRT?=
 =?utf-8?B?Y1hBckFBdDNTWlNiYitNWmlpYmVHMkV2b2YrMmhDUloxZWpuQVc0Z3VVVmYr?=
 =?utf-8?B?QWNQYklOVVFMYmtyZ1l3dnFTdEdndmkxRGI5bU5GRG9JMUsxSWd0Q2ROK1RD?=
 =?utf-8?B?NmpiWnNSQXVwREVXN2hCUDBvcE9PK3VCRENGTC9sR0hoY253WDZDYmVZb2Nl?=
 =?utf-8?B?U2Rpa05IcENpajFUUlNaVitCTi9Zdzh3T0NwVC9uZzkvWjlSY3lZVjk1MVgr?=
 =?utf-8?B?TnhwRHAyZHMzNUo2Q3hILy83RlF5M2Mxb2tjcVhoZlpxaytMb0d2MXZZa1J1?=
 =?utf-8?B?NUM2OURyUWY2UWtVSUlPa0dLSWhUMFpzUkY5ZE4vSXNKalNRdFByRGxJcVBD?=
 =?utf-8?B?akF6TFhucTFVQURibGVSbzlFZjltRFpQTFRLaXhVUW02dkFpWGhLUHk1SWc0?=
 =?utf-8?B?SThwc3RNNjRWNmNRVitScHM2S0tHWGo5N2l1aXFJeitRVVBNdTRGb3ZUaEdT?=
 =?utf-8?B?TWxUMjhQbXEwM01PKy80YjhCcW9NUVlSLzk0NDRWQk5kdVRKWWMzWXRXMS95?=
 =?utf-8?B?VnM3aU9lTkg2Z0J3bThMeEw3L09KNUtSVXJiSkxJVXRld0VwUmxZRTRlOUI1?=
 =?utf-8?B?Nzl1N2UvWURaaGUrK0t1T2VONURpTzRNdzVWbHFXekRBWEMzbDZKQnA5amI5?=
 =?utf-8?B?TTVyeXEzSys1OWtiaHp0V1lYNEdsYlRIMmpIeDBSdVNScXFGNUZ0WXUxMmwr?=
 =?utf-8?B?VXptTGxHbWhBTVMzRVkxd09aSFVZc0FaeXgyMGt1WTltaytZekxSTTgwK0sx?=
 =?utf-8?B?Z0YxbkR6MzREWElCemY2QThYOURjZWZtM0lJdXplazlFQmlyUmlJRGQ1Sktr?=
 =?utf-8?B?UEl4QXB4M2VVT1JBNWpYZDZhR2hJT0V2YnV6eWxKQmdvYzQrT0tZNFZieHBL?=
 =?utf-8?B?ampoamZQNlgxUzcwMGMvWlM4NWwrdXpEK21GSUEzeWJQL20rZC9TMHJselVM?=
 =?utf-8?B?ZjBxZnhWUytzWko3dXhmdFFNbEJNMWhxaWxFR1pOTnlYUGJDR0ZtalpVWUNy?=
 =?utf-8?B?TFZOREhIaFNtMVZRY010S29Ha3NaQzVlUVg0Qkl5dExXWWZkdzh2aWp5ZDRr?=
 =?utf-8?B?THo3SEVWVmNGSDk3YW5KUlBBT3V3TEZYcDIvRjYrZFliT29wWnBSRCttMW93?=
 =?utf-8?B?ZzUxWlBydlU0dTFxZitJK3UrOWt5SHNWeVgwNm9LcDhhRUJGU1VRakhueTFt?=
 =?utf-8?B?ZlJEa1RhTW9aZVMxaHVib3N3NmZ6SmVjWjRFQnp6R0NIQlJObmtnS1FnQitp?=
 =?utf-8?B?NnFPdDlLd0JQVjN1b2xoZnlEek9KRnRFR3Fya0lXeldUa0RVZlJReUF1cnZ3?=
 =?utf-8?B?SDFUbXRlUGp5ZkthaWwvdllEaVp0b3g0U2RnYS9veVN0N3RXVEc0K2FseFQ5?=
 =?utf-8?B?Lzd0Z0QvUWxhcnBTQ0syeXhDemIzQVEwcWx2b3NHRUNhcWM4OFo0dVNlSmtl?=
 =?utf-8?B?NTFRSXRVSzF4eE9Qb25QR1ZPOUEzZzRaWmtpRGVKajlOUTVVZ3JQL09wejI0?=
 =?utf-8?B?NWliRzNiTDVyZ0hRQ0M3S3U2NEFyOXovYUNKQlhuRnhENmFyUG1tblRNWDZz?=
 =?utf-8?B?Yk0wc2dTYUQ4bFpKOXIyZWRnNWwxYzdrQW1iVEovdHhmS3dkQk40ejc2VHh4?=
 =?utf-8?B?U1ZTeG45bjh0YlUvcVBTUDJnT1dDUEsxWEtGZlhsS1BYTU5QNFpnS3pNUHhO?=
 =?utf-8?B?WklQdjRXZUsrVFloYjJJU21IdmJYRkVhVGJscHl4T3VGRVlZVWYweGRVeVgr?=
 =?utf-8?B?YjFCdVhHYVlhdXdPTDh5NFF0dnRBOTliaS9kSkViQzRBWllWekZqWkNtWUxq?=
 =?utf-8?B?bVkzYVVScGxoSFRnNFVmaHFveXgrVnZyOG5PaW5QUGlvaE1zY3o5UkRoeEZt?=
 =?utf-8?B?UTZkL013SWZLZDBpb1hXVWNTRytacU1RSnlHQUxrSjgvVzNjOFd6YldxNzN4?=
 =?utf-8?B?YVhsUFBYWkFGSDlmNHFsQmNuNTY5NDBsUHlzS0JjK1UwSDNEL21qc080T1lM?=
 =?utf-8?Q?Q8H9Gbg5A3R53fd2S2Ci96s=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1aabefe4-b8c6-4576-a24e-08d9a9b33072
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Nov 2021 10:15:32.6147
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VPHRKely4yhY/VUtmn/GZY74z2951JD/fVdpMC2TQYbhayMiYH5AiQyMgkiZquMFe3xxlKKc8mMTEmU7gwIGbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1331
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBQYW9sbyBCb256aW5pIDxwYm9uemluaUByZWRoYXQuY29tPg0KPiBTZW50OiBXZWRu
ZXNkYXksIE5vdmVtYmVyIDE3LCAyMDIxIDM6MzEgUE0NCj4gDQo+IE9uIDExLzE3LzIxIDA1OjUy
LCBOYWthamltYSwgSnVuIHdyb3RlOg0KPiA+IElmIGEgKGNyZWF0aXZlKSBndWVzdCB3YW50cyB0
byBzZXQgWEZEW0FNWF0gPSAxIGZvciBmdW4gd2hpbGUga2VlcGluZw0KPiA+IEFNWCBzdGF0ZSBh
bGl2ZSB3aXRob3V0IHNhdmluZyB0aGUgQVhNIHN0YXRlLCBpdCBtYXkgbG9zZSB0aGUgc3RhdGUN
Cj4gPiBhZnRlciBWTSBleGl0L2VudHJ5Lg0KPiANCj4gSSB0aGluayB0aGlzIHNob3VsZCBub3Qg
aGFwcGVuLCB1bmxlc3MgeW91IGFsc28gZG9jdW1lbnQgdGhhdCBvdGhlcg0KPiByYW5kb20gZXZl
bnRzIChoeXBvdGhldGljYWxseSwgaXQgY291bGQgYmUgc29tZSBvdGhlciBjb3JlIHVzaW5nIEFN
WD8pDQo+IGNhbiBjYXVzZSB0aGUgbG9zcyBvZiBYVElMRURBVEEgaWYgWEZEW0FNWF09MS4gIFZp
cnR1YWxpemF0aW9uIHNob3VsZA0KPiBub3QgYmUgc3BlY2lhbCwgSSdkIHByZWZlciB0aGF0IHRo
ZSBndWVzdCBoYXMgdGhlIHNhbWUgYmVoYXZpb3IgYXMgYmFyZQ0KPiBtZXRhbCBpbiB0aGlzIHJl
c3BlY3QuDQo+IA0KDQpUaGUgc3RhdGUgbWF5IGJlIGxvc3Qgd2l0aCB0aGUgc2ltcGxlIHZlcnNp
b24gc3VnZ2VzdGVkIGJ5IFRob21hcywNCmJlY2F1c2Ugd2l0aCBYRkRbQU1YXT0xIHRoZSBBTVgg
c3RhdGUgd29uJ3QgYmUgc3RvcmVkIHRvIA0KZ3Vlc3RfZnBzdGF0ZSB3aGVuIHRoZSB2Y3B1IHRo
cmVhZCBpcyBwcmVlbXB0ZWQgYW5kIHRoZW4gZ2V0IGxvc3QNCndoZW4gcmVzdG9yZWQuIFRvIGVt
dWxhdGUgdGhlIGhhcmR3YXJlIGJlaGF2aW9yIHRoaXMgd2lsbCBuZWVkDQphZGRpdGlvbmFsIHRy
aWNrIHRvIGZvcmNlIFhGRFtBTVhdPTAgaWYgWEdFVEJWKDEpIGlzIHRydWUgKGlnbm9yaW5nIA0K
Z3Vlc3QgWEZEKSBpbiBmcHVfdXBkYXRlX2d1ZXN0X3hmZF9zdGF0ZSh2b2lkKS4gSXQgYWxzbyBp
bXBsaWVzIA0KdGhhdCB0aGUgYWN0dWFsIGd1ZXN0IFhGRCBuZWVkcyB0byBiZSBzYXZlZCBpbiBh
IHBsYWNlIGJlZm9yZSBmb3JjaW5nIA0KWEZEW0FNWF0gdG8gMCBhbmQgcmVjb3ZlcmVkIChhZnRl
ciBpbnRlcnJ1cHQgaXMgZGlzYWJsZWQpIGJlZm9yZSANCmVudGVyaW5nIHRoZSBndWVzdC4NCg0K
V2UgYXJlIG5vdCBzdXJlIHdoZXRoZXIgc3VjaCB0cmljayBpcyB3b3J0aHdoaWxlLCBzaW5jZSBh
IHNhbmUNCmd1ZXN0IHNob3VsZG4ndCBzZXQgWEZEW0FNWF09MSBiZWZvcmUgc3RvcmluZyB0aGUg
QU1YIHN0YXRlLiBUaGlzDQppcyB3aHkgd2Ugd2FudCB0byBzZWVrIFNETSBjaGFuZ2UgdG8gbWFy
ayBvdXQgdGhhdCB0aGUgc29mdHdhcmUNCnNob3VsZCBub3QgYXNzdW1lIFhUSUxFREFUQSBpcyBz
dGlsbCB2YWxpZCB3aGVuIFhGRFtBTVhdPTEuIA0KDQpUaGVuIEtWTSBjYW4gbWFrZSBhIHNpbXBs
ZSBhc3N1bXB0aW9uIHRoYXQgb25jZSBYRkRbQU1YXT0xDQppdCBpbXBsaWVzIHRoZSBndWVzdCBk
b2Vzbid0IGNhcmUgYWJvdXQgdGhlIEFNWCBzdGF0ZS4gVGhlbiB0aGUNCnNpbXBsZSB2ZXJzaW9u
IGZyb20gVGhvbWFzIGNhbiB3b3JrIHBlcmZlY3RseS4NCg0KVGhhbmtzDQpLZXZpbg0K
