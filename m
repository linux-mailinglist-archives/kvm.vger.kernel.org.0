Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84EF12CF447
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 19:49:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727848AbgLDStP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 13:49:15 -0500
Received: from mail-bn8nam08on2051.outbound.protection.outlook.com ([40.107.100.51]:20673
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726173AbgLDStP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Dec 2020 13:49:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eS9m7pQHS82mlWAIoz6eSc8aWiv6KBNJ0nfOlJfK+aPGgc82klQdWPi01NADAJSVK4SmiXVR+WQlQIcrdenU80Lt2uLIEd3Um4IKNhVk2M6o+eZopXLeRG+WGdDtFlhfUvtnHjkStLYKiDdn5n24XiBDb8/3qISJf9truGBjymHEnCxIzhVT4OCT51t5qTe+CtTQoy6cbcJKv7G2x4wMvAjaBO8wN3dH/xJk9reUIkgXfuH08Jjo7gVDKxwLzpCTXGHfWBklvv9ET26wlYtTgCUWMVO9pMWSQbcdpxHuoVXpi98LH89bdakgo8QkxB3kDcTx528kAUIT8i/3nYhE/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZeH0K0X7qkcPYNMYhfU8gIWBthiB7P8vC2tRL1rX0QU=;
 b=DhhKOzH7Tk325drNLalBhIr6mSMF7ArcXO6bgLG0XVSUiiwPszgoYCFoBRrmaLw3sICrT0KHRBuZ8J0SoFYAARR+/fX82wLUHmxuPTLFKg3neaInjK0UDzDl13JUvP/GYmGnp8t6emt8gvO+wvH0KA2l9jGPc+Dk/X3pkveIe7CSvZfT+ULL7CxKYvl+yetVliIolcCTh7+15rIEctUa2m3gKWYlasx5GF0uJasB39SAhhdR+JKz6A9iYFlSHXN1DH9cZjso8gH01dHP95GxCVCZIF4z8pwFxNE+2xCVr34Ryko/vgQC+tZskTGGpjlY/rgF5SGbYGEkwC1vI177Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZeH0K0X7qkcPYNMYhfU8gIWBthiB7P8vC2tRL1rX0QU=;
 b=0QL26qIFjaol7lsXcv4FznacOE137e0Jdv/krgdoRKSk+QqphsJ9cQv1FZUanCo35ursFHXBqhNCUwH9MrkdKuP2pi4sowSXVF2q79oeJfCqeOo+z91FbzPy2NVCCugUluG04Y8+EUCDo/Y9iJT0r5uJzlxTDiNdzmicCJvG1ls=
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4430.namprd12.prod.outlook.com (2603:10b6:806:70::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.20; Fri, 4 Dec
 2020 18:48:22 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec%3]) with mapi id 15.20.3611.025; Fri, 4 Dec 2020
 18:48:22 +0000
From:   "Kalra, Ashish" <Ashish.Kalra@amd.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "bp@suse.de" <bp@suse.de>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Steve Rutherford <srutherford@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "venu.busireddy@oracle.com" <venu.busireddy@oracle.com>,
        X86 ML <x86@kernel.org>
Subject: Re: [PATCH v8 13/18] KVM: x86: Introduce new
 KVM_FEATURE_SEV_LIVE_MIGRATION feature & Custom MSR.
Thread-Topic: [PATCH v8 13/18] KVM: x86: Introduce new
 KVM_FEATURE_SEV_LIVE_MIGRATION feature & Custom MSR.
Thread-Index: AQHWymg5O15yco/y+0qZupKZxhig2qnnRUaAgAAB/g0=
Date:   Fri, 4 Dec 2020 18:48:22 +0000
Message-ID: <C0A5487F-3B45-4343-9528-8A1BC213C2F3@amd.com>
References: <X8pocPZzn6C5rtSC@google.com>
 <20201204180645.1228-1-Ashish.Kalra@amd.com>,<CAMS+r+XBhFHnXrepzMq+hkaP3yHOUELjyc65JQipKCN+7zubVw@mail.gmail.com>
In-Reply-To: <CAMS+r+XBhFHnXrepzMq+hkaP3yHOUELjyc65JQipKCN+7zubVw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
x-originating-ip: [136.49.12.8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ba069a9b-6873-4da6-3c5c-08d898852d1c
x-ms-traffictypediagnostic: SA0PR12MB4430:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA0PR12MB443019CD6E68CAA09E68D91F8EF10@SA0PR12MB4430.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 84ZYj1mHDrdGgNXCzQ4tYxLb7AIYstS0+wYL9r4K5n82S0AVpyH7KidJSLcpXJYtCPw7xwz0GRqWb0SX4JwgTmJ520SB/9y3N2YM/1EUYmLNqPcXi50SUrLwyamWkTDRSO6UZE6GBcSKUUUYMF0cWtUc/b+yiQtiF6jtAjvj+2eIzAVcGNVoEchNKeOm6FxNbtDV+B2YibdZpb8IJmnjgWwWGf4TnXHgGbeLgb+XSfO6v2CBpiYKlCeCRHQNH8A2p3tJmZLVFXyhXG6r6ZXHHN1Sl/aOH4ALu1QiIseJHia94wVBmCyKpuXQg4NBnHLJyR9b+A340sFD2+pMAv0rcQj//ESp/fpQqiCv5XFnq37TKjUoRpfVgtkwzaxIEw8G
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(39860400002)(136003)(376002)(346002)(66556008)(4326008)(64756008)(66446008)(6916009)(2906002)(53546011)(66946007)(66476007)(36756003)(316002)(6506007)(33656002)(8936002)(76116006)(71200400001)(2616005)(7416002)(86362001)(6512007)(5660300002)(54906003)(186003)(26005)(4744005)(8676002)(6486002)(478600001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?M21jWnFWNk95eGdYNTNOKzNWaU9pQ2pGaXhNdnR3T1p0UkdUbHptK1hlT2x5?=
 =?utf-8?B?WjNQVVN5Vmt6VGoybnRrK2M4YjV6YlZaSFVrbyswRlIwelNFd1MvbW52dVNR?=
 =?utf-8?B?ZUFyMVFYdm9rYWcwN1VKNTBoTm85S2h5UGtCR05ITXRldmROb1cyYmFsN1kw?=
 =?utf-8?B?Z0RFaUYyYmJ1MTFObFdRQXpvQlI1NlJDVFh2SnpYam5HMGg0UmRPb0lHb1l2?=
 =?utf-8?B?ZlNndmdZVk12TGVJTkVSMDQya0JONUNxNzIzVVlibXVsNmtDNUxXR1pic0Zn?=
 =?utf-8?B?Q1Roa3BPWElwSFJNWTh1ajlDRVY3RUNxTmF4eGJFbC9MbW1yVGNES3YvYVNI?=
 =?utf-8?B?RUJDQjF2aFYvV1crbVJJN3kxcWQ4RHUxeXhZVVYzYnJ2Z214bW9uQWJweGpi?=
 =?utf-8?B?N1NVL1BvTEFaOS9icE9ZUkxOVzk2Z2Jab04wYmE2TkNtV04xQzBuUnU5RnJV?=
 =?utf-8?B?ekJDaEt0cWxSRjlkNk1SWWxsQzB5R1VYNGVrcE1mYlp1M3A4bHIveS9zWnU2?=
 =?utf-8?B?NXFHYWFoNE13N0MzR1UvY01TdU1aNVdPNDZDVzVsSlFvSFhnTWVPY1VDU2xU?=
 =?utf-8?B?TW5UaWV3bGx0WU5sQjd1MmE4bFVkUWRZVk1POWNzUHBtQ2p2UGxERnozUjhp?=
 =?utf-8?B?RnZIclR6QStjU29RUEZNRWY1VXRla2E4WGFEMXEyRDkrUGFwZzdSRmJXVUJl?=
 =?utf-8?B?SlovdGVKdjB5UDQxK0JpTUdnQUJTMGg0SkFVZDVrdzNsME5scytIYjBrYlJZ?=
 =?utf-8?B?TnFMQmdpMGltM0xiZUJHYllTK1ZFc0lneVJ3VlJocnZWRTk1RlYveW00ck9C?=
 =?utf-8?B?NzBYNGRoOWJiWDVKckRnUEJUUE9nRUtGUlJaVnlhV3NuQVo0VithUTk3cDRl?=
 =?utf-8?B?UGdlWjFNcjlFMmlHdUZLcUxiRG1DRytVK2FTTTNsbmlIVVBtQkUwTTdiOFhz?=
 =?utf-8?B?dmhsTlJudW5MM1REMGtsL2tVaHJaM1Q1SjNsUmlDcUF1eE5KMHVBeTlsWjlU?=
 =?utf-8?B?N0IySW5Xay93Z3F6dUdHZnB6cnZuWFp3c1pGaGFUOHBaRFNYRUhXYXR2bEdo?=
 =?utf-8?B?N2F1M2N0bTZjZ1VLK2NBMEU3d1pPT3VUQ2I4VzgwRjk0K3orSk1YemdjTUIz?=
 =?utf-8?B?U2pQNTN3RGR4T240cjZRb2N2TmxMSWdUUG9SNGxkTVI2ek1hZmJSWWlFVzhk?=
 =?utf-8?B?Q012ZnA2VkQzS0xmemgrVUJoMzZLWGpueEtNL3FtcWV4MlpjUDMrOGlaTHEw?=
 =?utf-8?B?eGFRdXQ5SDl4U0JscVoycEdwcXV0Y3d3MEVBbXZDRmgwZ2VjTm0wcnZXVHov?=
 =?utf-8?Q?fDl9Rd6Hnf150=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba069a9b-6873-4da6-3c5c-08d898852d1c
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2020 18:48:22.7143
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S+O6aJk9dYNx5788mTm3UBg5dByvgAkbg+c4N2aKZF/BdgToOBH5ZSlSis1NaenhxBEYz5VSvxVi8je0PtPzNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4430
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VGhpcyB0aW1lIEkgcmVjZWl2ZWQgeW91ciBlbWFpbCBkaXJlY3RseS4NCg0KVGhhbmtzLA0KQXNo
aXNoDQoNCj4gT24gRGVjIDQsIDIwMjAsIGF0IDEyOjQxIFBNLCBTZWFuIENocmlzdG9waGVyc29u
IDxzZWFuamNAZ29vZ2xlLmNvbT4gd3JvdGU6DQo+IA0KPiDvu79PbiBGcmksIERlYyA0LCAyMDIw
IGF0IDEwOjA3IEFNIEFzaGlzaCBLYWxyYSA8QXNoaXNoLkthbHJhQGFtZC5jb20+IHdyb3RlOg0K
Pj4gDQo+PiBZZXMgaSB3aWxsIHBvc3QgYSBmcmVzaCB2ZXJzaW9uIG9mIHRoZSBsaXZlIG1pZ3Jh
dGlvbiBwYXRjaGVzLg0KPj4gDQo+PiBBbHNvLCBjYW4geW91IHBsZWFzZSBjaGVjayB5b3VyIGVt
YWlsIHNldHRpbmdzLCB3ZSBhcmUgb25seSBhYmxlIHRvIHNlZSB5b3VyIHJlc3BvbnNlIG9uIHRo
ZQ0KPj4gbWFpbGluZyBsaXN0IGJ1dCB3ZSBhcmUgbm90IGdldHRpbmcgeW91ciBkaXJlY3QgcmVz
cG9uc2VzLg0KPiANCj4gSHJtLCBhcyBpbiB5b3UgZG9uJ3QgZ2V0IHRoZSBlbWFpbD8NCj4gDQo+
IElzIHRoaXMgZW1haWwgYW55IGRpZmZlcmVudD8gIFNlbmRpbmcgdmlhIGdtYWlsIGluc3RlYWQg
b2YgbXV0dC4uLg0K
