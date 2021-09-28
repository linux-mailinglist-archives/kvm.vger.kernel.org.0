Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC4541B788
	for <lists+kvm@lfdr.de>; Tue, 28 Sep 2021 21:26:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242419AbhI1T2T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 15:28:19 -0400
Received: from mail-mw2nam08on2045.outbound.protection.outlook.com ([40.107.101.45]:48170
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242418AbhI1T2P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Sep 2021 15:28:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XQMmX0XWOvTtUke0ynrRzhiwwY6Lc3g6F664xX6snU5FYks8AghI8P/8+LSuyN1ZMoafVQ0Gki0Pna2o3FP6mkcA6LFvG9rra8SJgg/mj/kwIOiWfXChkQKibcOfg9bYABZpLaJRyDlvm1GamuAMsJlzJHqSOf4IvnvfYUXV6KIEY7cMld2bUcDhBxpQ5NP9vmto83WxzXe2XBgD/gCwm6u7ElPzeEBc5UrnWZXpob4L6KBJ4pwnB+i519ucHC+mjKQ9WEw+T9ryc+GKnWgEbRJrzUY8RyiJlNbTFA8yaadIv0ZhZvR1EiiUKFxITSttpLQSH3d9jkuFPoHXJJ11NQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=j3Nc6z5FlLwLu5J+sbEDq/Q2eeGCdLyfynhidfzOx4Y=;
 b=Q3mzJiXX1jQQ++lKWxPxowiV/ji4wy0//Y8l8Fns2ISIxe1R5ObVyJpC2sL4uNKcWNmGMMQpRvrlqobBFRn4WzEULK4e9tb4LHMOFA98iqze6wIlOIE3j99q/fdrfUW8xN3uYHgysXZvxTgLVXcf3JmMu64/H5Qmnnj1P5Wuj9HpEfi8IS7IJuayOHJtZxntzSm+QWUynK8qbB9VlJrVL743NE9IZKcUjsl4bQ2mVDFnasAi5tVMXkCKE97sH5Qs5lrAznfdZwrDLnhO5l86X58fStIph82wYHsjAYoTHwQY3E3Fvdp7+MywtPjWerqYL//mvQIzbZuhM70C8XIl/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j3Nc6z5FlLwLu5J+sbEDq/Q2eeGCdLyfynhidfzOx4Y=;
 b=3SkF2W0UVu5SGqRACTE/muoFiyHCX0jttxPtBkWuaiy5Vr9KbvCP1pqqiKq8mADN+WyVGB4ejXrBBv0kDsZR2lXZ3qZA9Lrf2ltuDhf/i7N0jrGFrp/kAQMzaR9D5J+XwCXdXx4tbV/B13H6s6OIalUtOwi5HTDVzr05cLR+6OA=
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN6PR12MB2830.namprd12.prod.outlook.com (2603:10b6:805:e0::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Tue, 28 Sep
 2021 19:26:32 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::491e:2642:bae2:8b73]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::491e:2642:bae2:8b73%7]) with mapi id 15.20.4544.021; Tue, 28 Sep 2021
 19:26:32 +0000
From:   "Kalra, Ashish" <Ashish.Kalra@amd.com>
To:     Steve Rutherford <srutherford@google.com>
CC:     Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        "dovmurik@linux.ibm.com" <dovmurik@linux.ibm.com>,
        "tobin@linux.ibm.com" <tobin@linux.ibm.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>
Subject: Re: [PATCH v6 1/5] x86/kvm: Add AMD SEV specific Hypercall3
Thread-Topic: [PATCH v6 1/5] x86/kvm: Add AMD SEV specific Hypercall3
Thread-Index: AQHXmNfaIcWIQRTyNEK2tNwp4pCn2aul/wuAgAdCYACAAStkAIAAQK+AgAARHICAABUkgIABJawAgAAqeACAAB0HAIAJxOeAgAAF/Tc=
Date:   Tue, 28 Sep 2021 19:26:32 +0000
Message-ID: <2213EC9B-E3EC-4F23-BC1A-B11DF6288EE3@amd.com>
References: <cover.1629726117.git.ashish.kalra@amd.com>
 <6fd25c749205dd0b1eb492c60d41b124760cc6ae.1629726117.git.ashish.kalra@amd.com>
 <CABayD+fnZ+Ho4qoUjB6YfWW+tFGUuftpsVBF3d=-kcU0-CEu0g@mail.gmail.com>
 <YUixqL+SRVaVNF07@google.com> <20210921095838.GA17357@ashkalra_ubuntu_server>
 <YUnjEU+1icuihmbR@google.com> <YUnxa2gy4DzEI2uY@zn.tnic>
 <YUoDJxfNZgNjY8zh@google.com> <YUr5gCgNe7tT0U/+@zn.tnic>
 <20210922121008.GA18744@ashkalra_ubuntu_server> <YUs1ejsDB4W4wKGF@zn.tnic>
 <CABayD+eFeu1mWG-UGXC0QZuYu68B9wJNWJhjUo=HHgc_jsfBag@mail.gmail.com>
In-Reply-To: <CABayD+eFeu1mWG-UGXC0QZuYu68B9wJNWJhjUo=HHgc_jsfBag@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: alien8.de; dkim=none (message not signed)
 header.d=none;alien8.de; dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4524f717-1f35-4d49-5abd-08d982b5e13d
x-ms-traffictypediagnostic: SN6PR12MB2830:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR12MB2830D3E4FB897EAF75B432848EA89@SN6PR12MB2830.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OqaJOyR5wU6sa/XM0tBMUzulIVT4RFSl/YXTJntzd8RqFXGXmmTa9k6eAf1S9qRonE1ep3vXhlKJ8mG1/tmOp1OK69CKmZjMOmzm2l/2lKYpS2WktEajxVBd10v7fWtk8SidWqifztSt//Cj33v8qEEQGKx8qHWwakpoTuzP9KE+P0p2C3lGybVug84BpoJVq5LDQgddY92ZWQyWIB/4JsRFlWItfUsVCmvwlmIpRZEHZ7BH+bmuCnwkxqq2dkLn+LAlB1pbr5Hi0s7ax8oZxFG7T7usHTRuEfcyEFw+U7VCdAV7nirfFJlRMlYKFQktVKq/LMabm6TMCM24kdKBWRTZc8TMeb0E7Lve9qW+g8ZzrvnZNzW06PT5EtqQjEUoxlYgUQ+5h/nImOqwvJY91FTuy1saKt2iC2Q0Jd0NMicFOd/pvIdhx8OzCRTLciZfbcOuukKERvxdzog6VT2rIX9jsxR2Z/dKRg4e9DwlMwkEA7Qt1+UmpjwVdmk7ePvveEi3vK+kZI3QlJ6LUtsnMczdbdm7Vf22WgCflOwL3xe2us02h0soSrDJlb5BAIZesSI7qEzx0mDS2Y8eXXWMmuhhp/HfoHbyOD1uMFyZod/oRkOxkty3KKOyv5dAYHXxXbhVvsU2f3HyMoQLObll4iWyXl3nSIH2RPg2tthXF40hFysu0qtbN2ncmGLdubF/ZuCcdkEin3NGjneDBP2gNdIO3UemNwl32OtVHobPHVw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(53546011)(122000001)(54906003)(5660300002)(316002)(6506007)(8936002)(76116006)(38070700005)(38100700002)(2616005)(8676002)(66446008)(2906002)(86362001)(66946007)(64756008)(66556008)(186003)(4326008)(7416002)(6486002)(33656002)(71200400001)(66476007)(4744005)(36756003)(508600001)(6512007)(6916009)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cWxXWG5EUFZyeG9YMy96QnZOckEzZnY5S3ZDNDFnMWUxYk9KS1NMZUJ3Wlp3?=
 =?utf-8?B?VUNDOWxvdzljbjVhZ0ZSTSs4ZnpLNEc4WDM2QjVQSXQrNVdNQm1Ic1lsb0VZ?=
 =?utf-8?B?M0F6Ujd6RVFXWmtucUxvWS9KOGs5SXhxRkRTb3h1Si9jeEluN1BPaUJrK0cz?=
 =?utf-8?B?QVZsL1hzd0VyQVBXRlFybTZFT3RPM09hNndDZ01WU2QwanQrZlJxdXZlU05o?=
 =?utf-8?B?ajlOL0tSOFlSbDdaaGZqYktnKzRmcWlYRW1JUGVkOEg1OXNmMnFDRDBJREZq?=
 =?utf-8?B?bXNLRk5KK29xTGk0NmYxaWJ1dm80R2VEN28reFhLSTZoWFU5TW5qOFliOTJD?=
 =?utf-8?B?RjkwSy9KUkpCTDYwWUZITU0yOWhrcWhkTUZEZlE3NFZ3VFp3Z3dwTXFpY0R1?=
 =?utf-8?B?TUZsUVpwcndkd2M0Y29PZVhQTExjUVl0M0YvSkNuMmZQSElORWhBT1UxcGlz?=
 =?utf-8?B?YlJoQnQyNjBJazUycm4rbUdFNytwM1lNQk5ubnAzeE9GQ01odk9TbG1tWldo?=
 =?utf-8?B?VVVscXk0ZjBXblQrcXRwNGVHNW5xOXZ1Q0R1cGdab0ZPQ0NjRjdEOENRMjVR?=
 =?utf-8?B?ekdNZFRvSHFvMm1sV1c3Q0NvU011anNiaXAwVEY0ZTJHOTc4c054bkxrbElj?=
 =?utf-8?B?NmVrcW8rR291WkJUQSsxdlVnM2FBWWxsT3RndWdTYTAvN01Sa2RMOXJFQTlk?=
 =?utf-8?B?V0J2NkxLMisrd1l3VDZORUxxL3NwYzQvZHFFSFhxRzhCc3ZrTEYycU54SzlY?=
 =?utf-8?B?eS9UOHYwQXFxRDR5YVVBb3JuQ1JnVG1LVDlqUkFJMUY3RWVwdXlmOEpUMm5j?=
 =?utf-8?B?ZU12MUtWVTE2ZndRdzMxZE9YUk1BNEtBQTU0NFpCNlFRclpRNjBSOUQzTWJF?=
 =?utf-8?B?SkdxSnAvaXR2a3h0aXBMR2p3N3ZUS3FmYmloY0RPd05YWHNyZ1RlNWwxSFpL?=
 =?utf-8?B?MlBXSmVwRXIvVGYvS3pZaHFmck05eXp2VFhVYldWNFZ2VVhTNEhlcUFpUG5G?=
 =?utf-8?B?QlFTZWN5VU9ldmJ4SlJBcFU0dU5mM3RZdFU5TTdRRzF3aHZ3T2lnR0ZiUXZ3?=
 =?utf-8?B?RkYvNmxWOTJoemkzL1RuL2lGeWFoVTdNczNQR3UwdTFHN2x5a0V4Rm1XN3Zx?=
 =?utf-8?B?OUhZL2VPUlFiaFVacVR2NTU4SEpjbGVLWHpKV250MGdwYWtJaEpjMmFHTTYy?=
 =?utf-8?B?UkdsTlpqMXd2N2pIK2lUdHBFNTRISlZtdlprQWZ3OGtXK0tqMGxYbmVMeGxk?=
 =?utf-8?B?WWpqbG5HUXhpVmZrWitEamV1My9ZMmFzemt6a2pPcklwMFY1aGxUZXM2MUxW?=
 =?utf-8?B?a1dQQWx2RUZhUzlrbVNhMGdPS21BTFpManVIQ0hyZm1PM1RwV3FZd3ZId2FH?=
 =?utf-8?B?T2JrVldxSUhPNTNkeW55a2ZTKzBMOXZ1KyttSC9wTWxZU1NaMUFSZThBWVNV?=
 =?utf-8?B?TmFDZ1JGRFQzZERVQzlDYSt6UEV5OTVYK2dTNFpNV3N1VzJGQXQrL0RKOThi?=
 =?utf-8?B?c1ZwbEN3Q21uVFZBYjd6aTc0SGYycUNXQ1Nhb1FHY0ZOK1dtejBmYmxNWHFD?=
 =?utf-8?B?LzByZExYaFQrQzBoZHlFTUdBcElZemx0V1ZaaE5odzFETnQxTVAyNk9vNFhr?=
 =?utf-8?B?UVI4Y005NUNOMXlYRmRJaER6TENESjNnNjJoSjdOQUFuQWUwYnNnVUdUMlhK?=
 =?utf-8?B?YmF5eHpadkxVOUxFaGFFR0xicUhBbzdQTWU5RWR2bVZKS0puMFFlQTJlN1FW?=
 =?utf-8?B?M0ZGVmxYcHdzTTdnZEMyVEd1MExxbUdNeDA1cjg2QUVUa1dQbnVjSGxWTkFr?=
 =?utf-8?B?RU1Ga21jZzIvY0RtdC9zR3pyZDZqQzd6UjRjakFyYjR0YUc3dG9qaVV6WTBq?=
 =?utf-8?Q?m3MKrLMtbOy1P?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4524f717-1f35-4d49-5abd-08d982b5e13d
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2021 19:26:32.7492
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gyqwHquvGEYwDdAqjLGBDRu5G/egBflIOnZICk5aCh7GjB4qJ7SdnPT/yEP3mHBX4eWXRnQIWXKwYbHCZ1ZYzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2830
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gT24gU2VwIDI4LCAyMDIxLCBhdCAyOjA1IFBNLCBTdGV2ZSBSdXRoZXJmb3JkIDxzcnV0
aGVyZm9yZEBnb29nbGUuY29tPiB3cm90ZToNCj4gDQo+IO+7v09uIFdlZCwgU2VwIDIyLCAyMDIx
IGF0IDY6NTQgQU0gQm9yaXNsYXYgUGV0a292IDxicEBhbGllbjguZGU+IHdyb3RlOg0KPj4gDQo+
Pj4gT24gV2VkLCBTZXAgMjIsIDIwMjEgYXQgMTI6MTA6MDhQTSArMDAwMCwgQXNoaXNoIEthbHJh
IHdyb3RlOg0KPj4+IFRoZW4gaXNuJ3QgaXQgY2xlYW5lciB0byBzaW1wbHkgZG8gaXQgdmlhIHRo
ZSBwYXJhdmlydF9vcHMgaW50ZXJmYWNlLA0KPj4+IGkuZSwgcHZfb3BzLm1tdS5ub3RpZnlfcGFn
ZV9lbmNfc3RhdHVzX2NoYW5nZWQoKSB3aGVyZSB0aGUgY2FsbGJhY2sNCj4+PiBpcyBvbmx5IHNl
dCB3aGVuIFNFViBhbmQgbGl2ZSBtaWdyYXRpb24gZmVhdHVyZSBhcmUgc3VwcG9ydGVkIGFuZA0K
Pj4+IGludm9rZWQgdGhyb3VnaCBlYXJseV9zZXRfbWVtb3J5X2RlY3J5cHRlZCgpL2VuY3J5cHRl
ZCgpLg0KPj4+IA0KPj4+IEFub3RoZXIgbWVtb3J5IGVuY3J5cHRpb24gcGxhdGZvcm0gY2FuIHNl
dCBpdCdzIGNhbGxiYWNrIGFjY29yZGluZ2x5Lg0KPj4gDQo+PiBZZWFoLCB0aGF0IHNvdW5kcyBl
dmVuIGNsZWFuZXIgdG8gbWUuDQo+IElmIEknbSBub3QgbWlzdGFrZW4sIHRoaXMgaXMgd2hhdCB0
aGUgcGF0Y2ggc2V0IGRvZXMgbm93Pw0KDQpZZXMgdGhhdOKAmXMgd2hhdCBJIG1lbnRpb25lZCB0
byBCb3Jpcy4NCg0KVGhhbmtzLA0KQXNoaXNo
