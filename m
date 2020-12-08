Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFDE42D21E0
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 05:19:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726000AbgLHERM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 23:17:12 -0500
Received: from mail-bn8nam11on2087.outbound.protection.outlook.com ([40.107.236.87]:64077
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725874AbgLHERL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Dec 2020 23:17:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nrY+HZLtJUx0lp5Ml0SfvBp2XSGRYHEC+yMSqTRBlBlbc6sd3+dS3NwJDNWfyEdSSDHwAPPTM6Sbuq5hxnCnO4lMYbKjbR+CfAIASZ5MED9VBImBYeojcbz0av4OPVPa5R0FJJi9LCelcgK+yL/7tS9ya2Od5+xiKZajG6kYVNcvef5Lk2oqGPf4H8cJcFjV1fTjX/XrtnA+Dn7ty8VAbUZobmNVA8qNV4JKzhZVESagImhVbpbdnEdWfsNm2OE+vTgWPYU2nVC+GiH/a3cxlsaFglh4XJ0O2R4cMH33PUUH1q2BXU7Smqu+rylBbzMBvADOUCGTrh/k73y1xR/+NA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NArjP58aH6d2PN5j6zpxB/P3V8QzdebfmD9ca4VG+oI=;
 b=Mz3K+c2s4T2rDXYlOaNkzx944qi0erOfmXt0TAgfYicsH4jYfv+N/evSBdTrsIlzWVcAF+51Tkz41dwOeWMDJlqjjzznsbCPOq2h1VnDUrnfelS9T9bKFx8kp4uj4TjgqgbU1aZ2Ky8YUCdmnd1Fu+VvS4zxB5xb2ZKCeW/V6+taQE+T0659TJzVSj5dR0wKofyORqHEZmvSiHkhBVxRRM9mPZ2XXlIB92e6LM/2jkMCDn64MZ8M75s5iaaVPoUPtDzn3d+/FSpapwoKyC4N9xFFxafblojmwIt5Dl9gGxYQh6mWI0Tt9Skg7YkZQlMeIddRlomzBPx84W7lCWOziw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NArjP58aH6d2PN5j6zpxB/P3V8QzdebfmD9ca4VG+oI=;
 b=LFkPmVq4JJYWqTCde0UqDE+QWDjg2QO23614cmjeTQBeqvjOgkGBhyY4UCeloIvhkmI2HoJbWnfuqKSM3pV6kzCAr4lgnQ9e9eFudwRb2yCqtFscoAM6BmP45NKtEZEIKl+qc938wRMz4kXdbQQ4B66yCLVcbxF2cmfCDZlgz9U=
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN6PR12MB2638.namprd12.prod.outlook.com (2603:10b6:805:6f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21; Tue, 8 Dec
 2020 04:16:17 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec%3]) with mapi id 15.20.3632.021; Tue, 8 Dec 2020
 04:16:16 +0000
From:   "Kalra, Ashish" <Ashish.Kalra@amd.com>
To:     Steve Rutherford <srutherford@google.com>
CC:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@suse.de>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        "dovmurik@linux.vnet.ibm.com" <dovmurik@linux.vnet.ibm.com>,
        "tobin@ibm.com" <tobin@ibm.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "frankeh@us.ibm.com" <frankeh@us.ibm.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>
Subject: Re: [PATCH v2 1/9] KVM: x86: Add AMD SEV specific Hypercall3
Thread-Topic: [PATCH v2 1/9] KVM: x86: Add AMD SEV specific Hypercall3
Thread-Index: AQHWx3tfPmTvg2IrwUqsSmrr0oneAqnp5YdagAKq3DuAABJlGA==
Date:   Tue, 8 Dec 2020 04:16:16 +0000
Message-ID: <24B3FA3A-CBA6-48F1-909F-521EFB57CAC2@amd.com>
References: <cover.1606782580.git.ashish.kalra@amd.com>
 <b6bc54ed6c8ae4444f3acf1ed4386010783ad386.1606782580.git.ashish.kalra@amd.com>
 <X8gyhCsEMf8QU9H/@google.com>
 <d63529ce-d613-9f83-6cfc-012a8b333e38@redhat.com>
 <X86Tlin14Ct38zDt@google.com>,<CABayD+esy0yeKi9W3wQw+ou4y4840LPCwd-PHhN1J6Uh_fvSjA@mail.gmail.com>
In-Reply-To: <CABayD+esy0yeKi9W3wQw+ou4y4840LPCwd-PHhN1J6Uh_fvSjA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
x-originating-ip: [136.49.12.8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d18f4f1b-e5c1-4701-bc81-08d89b30021f
x-ms-traffictypediagnostic: SN6PR12MB2638:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR12MB263854FE63D74AFA7C2188758ECD0@SN6PR12MB2638.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XRQN/N8FRayNQ8rPK1FWbO1Kw3MfGP4Ztzdp4fenM2gsjokOD8+tkgCFtlbXMAe6vyo9JmQZJBFDtSwCQeIVAV1R/9VTyFu1kvAQe0OFGBm4IzGc6cRnu0MsSgv4YuXQgyH/nhRQSLj7//Etu0ChRyYYXZ3+ewh2mNA0vCZ6Ky1OWalzEgV/oB1kJEsVeASSsiEqaYDkdcCsVER5b1QqhV1JthIpk3wRYQDktSQ4SNYaKE4VE5j7zcP3BDXstDeo7/Y9JPsIRGd+XyWxAuSmDfVmwl2usHm/TitpoKcOsJyyQaYJmXH5GvgndNXHnF9haGaMTZ5Gn813P3BFXngrQTfYCXGOLmvnnGzrxH0eAa6kU33SRuhrlBqOc/Qid+eb
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(396003)(346002)(366004)(376002)(26005)(66446008)(54906003)(53546011)(6916009)(8676002)(66476007)(66946007)(8936002)(64756008)(2906002)(83380400001)(6506007)(6486002)(86362001)(186003)(4326008)(33656002)(2616005)(316002)(7416002)(36756003)(6512007)(5660300002)(71200400001)(76116006)(478600001)(66556008)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?NVJHQmlzU2RXUzB5T0NyZG9HZzJXbjIySDVWNkFPcDhockhYTFhyVjdoT25s?=
 =?utf-8?B?Uy9MY1dHdnZiUXByK3g4LzVoc3dvK2JCOU13TVFvUi9DbU94TVk3Q3ZkLzUy?=
 =?utf-8?B?STN5Q3VpU2FFRFZCQ1NrVGJicW94cmxVNlpZdFdPVitUWGJjbjAvNDhNZFNP?=
 =?utf-8?B?VnR4VzlubHErSGdFOFVvWHJZM0s0T0lzY25kZ0xUMGNGT2xCWWU4YUtVRFNz?=
 =?utf-8?B?dWJRVlZmWEYvVXZleXJwWVZqaENLamNSK3RMYmkwNnBPTWZVeXkvcHN1blFi?=
 =?utf-8?B?MDU2QWNsVXpHWWY3Z2hYN3p5L3FVdUZEaVhPNHl6WDNKSjZnV01YMmVONHN1?=
 =?utf-8?B?RmQyTU1jT2lOMFFnaUhBMFVld0RKcksySGZjZ3UvWEJrWkRVNElDZk1vc0Jm?=
 =?utf-8?B?WkQza2FwNGI0WmgxUmtmODlpcnJadEExRlEvNXF4UmlPZDM2VkMrdCtvdzJy?=
 =?utf-8?B?NEYzSG1aY3ppNnZMeWFxbm5iN1UrenI3WWd2dkY3dnMxQzM0TlZCSGJLRWx1?=
 =?utf-8?B?djFtYStFQUYwMTU2S2xLeHNlU3FYUkhEelpkVmNWOS9XU0g1b2FOS2dWL3gx?=
 =?utf-8?B?NHp1SUxzNHQ0dXdDTHlkcWJPbk42eVlsZnpvTStRa3RRZVFLdEFCY2JGbFVJ?=
 =?utf-8?B?Z0JwT2QwTlpqRmxqNC9IL2lxVWNia1hnaytKTjliWXQ1b0M2UDg4M0RTMHZQ?=
 =?utf-8?B?bHVTQ1NIYkM0aXZDWjR5YXlJeEZ4ZzJuVTB6K0Q5Z0ZBOTJTbi9xcHlMVHkr?=
 =?utf-8?B?QzJ6NEEzZkJ6SXliVndMVVNpZU1RUGhZN0FTSHNhMHBadWlwZG9nLzArVkV1?=
 =?utf-8?B?c0NIRGt4Y1FzRURRY3ZjMjE5Y0dqdGhDODFpQm9OK2NwZUIrNXhoV1NyQ2hx?=
 =?utf-8?B?MmcyNnhyVkxVS3RGQUF5NWNoalU5SUlkYWJHdG9xcEVXWXZuVzdRbEVRa3JF?=
 =?utf-8?B?RU01ZmI3enhzNWwzK3paOWlCdml5WjBJSmczbnh2TGRGb3YvZmZiNWJ3OUlV?=
 =?utf-8?B?S2J1VDFCWFV2M0t0TjlkWnFKVFkwUGZLcExwWnhjNEh1MDlIYUtUNkpVcys2?=
 =?utf-8?B?TmkyY2tGTVlWN1hjRnVVaVR3dHhQUXVTZ2NicG9VV21yeXEveGlSMjVOM1RG?=
 =?utf-8?B?RFl4MGV3bkdMM3N3UTY4YkxkeUJKV2ExbVY5eVRXRDdxVXBoZ2tCWURkMVUv?=
 =?utf-8?B?UDlNeGdSN0h3UnRXMDZZRjM5dnNkK1NXQitGUFUyemY2Tk9TbDZ3VkMrK2NF?=
 =?utf-8?B?K25pQVdIY0JpTTdKYjZTN3ZNb1ZFQVdrejVTMkpVc1gvbHdITUJ2bUlvWmpk?=
 =?utf-8?Q?9G2A6ceUJSocs=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d18f4f1b-e5c1-4701-bc81-08d89b30021f
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Dec 2020 04:16:16.8875
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jcdHrhn3C/ZoxgqdLU5OuVpveMOW1cCwWI1TU8qDeho8K5LDr94yLyYfKv2jC4gEhh2bOOMo1W7Q3+EdCRbEEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2638
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SSBkb27igJl0IHRoaW5rIHRoYXQgdGhlIGJpdG1hcCBieSBpdHNlbGYgaXMgcmVhbGx5IGEgcGVy
Zm9ybWFuY2UgYm90dGxlbmVjayBoZXJlLg0KDQpUaGFua3MsDQpBc2hpc2gNCg0KPiBPbiBEZWMg
NywgMjAyMCwgYXQgOToxMCBQTSwgU3RldmUgUnV0aGVyZm9yZCA8c3J1dGhlcmZvcmRAZ29vZ2xl
LmNvbT4gd3JvdGU6DQo+IA0KPiDvu79PbiBNb24sIERlYyA3LCAyMDIwIGF0IDEyOjQyIFBNIFNl
YW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUuY29tPiB3cm90ZToNCj4+IA0KPj4+IE9u
IFN1biwgRGVjIDA2LCAyMDIwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0KPj4+IE9uIDAzLzEyLzIw
IDAxOjM0LCBTZWFuIENocmlzdG9waGVyc29uIHdyb3RlOg0KPj4+PiBPbiBUdWUsIERlYyAwMSwg
MjAyMCwgQXNoaXNoIEthbHJhIHdyb3RlOg0KPj4+Pj4gRnJvbTogQnJpamVzaCBTaW5naCA8YnJp
amVzaC5zaW5naEBhbWQuY29tPg0KPj4+Pj4gDQo+Pj4+PiBLVk0gaHlwZXJjYWxsIGZyYW1ld29y
ayByZWxpZXMgb24gYWx0ZXJuYXRpdmUgZnJhbWV3b3JrIHRvIHBhdGNoIHRoZQ0KPj4+Pj4gVk1D
QUxMIC0+IFZNTUNBTEwgb24gQU1EIHBsYXRmb3JtLiBJZiBhIGh5cGVyY2FsbCBpcyBtYWRlIGJl
Zm9yZQ0KPj4+Pj4gYXBwbHlfYWx0ZXJuYXRpdmUoKSBpcyBjYWxsZWQgdGhlbiBpdCBkZWZhdWx0
cyB0byBWTUNBTEwuIFRoZSBhcHByb2FjaA0KPj4+Pj4gd29ya3MgZmluZSBvbiBub24gU0VWIGd1
ZXN0LiBBIFZNQ0FMTCB3b3VsZCBjYXVzZXMgI1VELCBhbmQgaHlwZXJ2aXNvcg0KPj4+Pj4gd2ls
bCBiZSBhYmxlIHRvIGRlY29kZSB0aGUgaW5zdHJ1Y3Rpb24gYW5kIGRvIHRoZSByaWdodCB0aGlu
Z3MuIEJ1dA0KPj4+Pj4gd2hlbiBTRVYgaXMgYWN0aXZlLCBndWVzdCBtZW1vcnkgaXMgZW5jcnlw
dGVkIHdpdGggZ3Vlc3Qga2V5IGFuZA0KPj4+Pj4gaHlwZXJ2aXNvciB3aWxsIG5vdCBiZSBhYmxl
IHRvIGRlY29kZSB0aGUgaW5zdHJ1Y3Rpb24gYnl0ZXMuDQo+Pj4+PiANCj4+Pj4+IEFkZCBTRVYg
c3BlY2lmaWMgaHlwZXJjYWxsMywgaXQgdW5jb25kaXRpb25hbGx5IHVzZXMgVk1NQ0FMTC4gVGhl
IGh5cGVyY2FsbA0KPj4+Pj4gd2lsbCBiZSB1c2VkIGJ5IHRoZSBTRVYgZ3Vlc3QgdG8gbm90aWZ5
IGVuY3J5cHRlZCBwYWdlcyB0byB0aGUgaHlwZXJ2aXNvci4NCj4+Pj4gDQo+Pj4+IFdoYXQgaWYg
d2UgaW52ZXJ0IEtWTV9IWVBFUkNBTEwgYW5kIFg4Nl9GRUFUVVJFX1ZNTUNBTEwgdG8gZGVmYXVs
dCB0byBWTU1DQUxMDQo+Pj4+IGFuZCBvcHQgaW50byBWTUNBTEw/ICBJdCdzIGEgc3ludGhldGlj
IGZlYXR1cmUgZmxhZyBlaXRoZXIgd2F5LCBhbmQgSSBkb24ndA0KPj4+PiB0aGluayB0aGVyZSBh
cmUgYW55IGV4aXN0aW5nIEtWTSBoeXBlcmNhbGxzIHRoYXQgaGFwcGVuIGJlZm9yZSBhbHRlcm5h
dGl2ZXMgYXJlDQo+Pj4+IHBhdGNoZWQsIGkuZS4gaXQnbGwgYmUgYSBub3AgZm9yIHNhbmUga2Vy
bmVsIGJ1aWxkcy4NCj4+Pj4gDQo+Pj4+IEknbSBhbHNvIHNrZXB0aWNhbCB0aGF0IGEgS1ZNIHNw
ZWNpZmljIGh5cGVyY2FsbCBpcyB0aGUgcmlnaHQgYXBwcm9hY2ggZm9yIHRoZQ0KPj4+PiBlbmNy
eXB0aW9uIGJlaGF2aW9yLCBidXQgSSdsbCB0YWtlIHRoYXQgdXAgaW4gdGhlIHBhdGNoZXMgbGF0
ZXIgaW4gdGhlIHNlcmllcy4NCj4+PiANCj4+PiBEbyB5b3UgdGhpbmsgdGhhdCBpdCdzIHRoZSBn
dWVzdCB0aGF0IHNob3VsZCAiZG9uYXRlIiBtZW1vcnkgZm9yIHRoZSBiaXRtYXANCj4+PiBpbnN0
ZWFkPw0KPj4gDQo+PiBOby4gIFR3byB0aGluZ3MgSSdkIGxpa2UgdG8gZXhwbG9yZToNCj4+IA0K
Pj4gIDEuIE1ha2luZyB0aGUgaHlwZXJjYWxsIHRvIGFubm91bmNlL3JlcXVlc3QgcHJpdmF0ZSB2
cy4gc2hhcmVkIGNvbW1vbiBhY3Jvc3MNCj4+ICAgICBoeXBlcnZpc29ycyAoS1ZNLCBIeXBlci1W
LCBWTXdhcmUsIGV0Yy4uLikgYW5kIHRlY2hub2xvZ2llcyAoU0VWLSogYW5kIFREWCkuDQo+PiAg
ICAgSSdtIGNvbmNlcm5lZCB0aGF0IHdlJ2xsIGVuZCB1cCB3aXRoIG11bHRpcGxlIGh5cGVyY2Fs
bHMgdGhhdCBkbyBtb3JlIG9yDQo+PiAgICAgbGVzcyB0aGUgc2FtZSB0aGluZywgZS5nLiBLVk0r
U0VWLCBIeXBlci1WK1NFViwgVERYLCBldGMuLi4gIE1heWJlIGl0J3MgYQ0KPj4gICAgIHBpcGUg
ZHJlYW0sIGJ1dCBJJ2QgbGlrZSB0byBhdCBsZWFzdCBleHBsb3JlIG9wdGlvbnMgYmVmb3JlIHNo
b3ZpbmcgaW4gS1ZNLQ0KPj4gICAgIG9ubHkgaHlwZXJjYWxscy4NCj4+IA0KPj4gDQo+PiAgMi4g
VHJhY2tpbmcgc2hhcmVkIG1lbW9yeSB2aWEgYSBsaXN0IG9mIHJhbmdlcyBpbnN0ZWFkIG9mIGEg
dXNpbmcgYml0bWFwIHRvDQo+PiAgICAgdHJhY2sgYWxsIG9mIGd1ZXN0IG1lbW9yeS4gIEZvciBt
b3N0IHVzZSBjYXNlcywgdGhlIHZhc3QgbWFqb3JpdHkgb2YgZ3Vlc3QNCj4+ICAgICBtZW1vcnkg
d2lsbCBiZSBwcml2YXRlLCBtb3N0IHJhbmdlcyB3aWxsIGJlIDJtYissIGFuZCBjb252ZXJzaW9u
cyBiZXR3ZWVuDQo+PiAgICAgcHJpdmF0ZSBhbmQgc2hhcmVkIHdpbGwgYmUgdW5jb21tb24gZXZl
bnRzLCBpLmUuIHRoZSBvdmVyaGVhZCB0byB3YWxrIGFuZA0KPj4gICAgIHNwbGl0L21lcmdlIGxp
c3QgZW50cmllcyBpcyBob3BlZnVsbHkgbm90IGEgYmlnIGNvbmNlcm4uICBJIHN1c3BlY3QgYSBs
aXN0DQo+PiAgICAgd291bGQgY29uc3VtZSBmYXIgbGVzcyBtZW1vcnksIGhvcGVmdWxseSB3aXRo
b3V0IGltcGFjdGluZyBwZXJmb3JtYW5jZS4NCj4gDQo+IEZvciBhIGZhbmNpZXIgZGF0YSBzdHJ1
Y3R1cmUsIEknZCBzdWdnZXN0IGFuIGludGVydmFsIHRyZWUuIExpbnV4DQo+IGFscmVhZHkgaGFz
IGFuIHJidHJlZS1iYXNlZCBpbnRlcnZhbCB0cmVlIGltcGxlbWVudGF0aW9uLCB3aGljaCB3b3Vs
ZA0KPiBsaWtlbHkgd29yaywgYW5kIHdvdWxkIHByb2JhYmx5IGFzc3VhZ2UgYW55IHBlcmZvcm1h
bmNlIGNvbmNlcm5zLg0KPiANCj4gU29tZXRoaW5nIGxpa2UgdGhpcyB3b3VsZCBub3QgYmUgd29y
dGggZG9pbmcgdW5sZXNzIG1vc3Qgb2YgdGhlIHNoYXJlZA0KPiBwYWdlcyB3ZXJlIHBoeXNpY2Fs
bHkgY29udGlndW91cy4gQSBzYW1wbGUgVWJ1bnR1IDIwLjA0IFZNIG9uIEdDUCBoYWQNCj4gNjBp
c2ggZGlzY29udGlndW91cyBzaGFyZWQgcmVnaW9ucy4gVGhpcyBpcyBieSBubyBtZWFucyBhIHRo
b3JvdWdoDQo+IHNlYXJjaCwgYnV0IGl0J3Mgc3VnZ2VzdGl2ZS4gSWYgdGhpcyBpcyB0eXBpY2Fs
LCB0aGVuIHRoZSBiaXRtYXAgd291bGQNCj4gYmUgZmFyIGxlc3MgZWZmaWNpZW50IHRoYW4gbW9z
dCBhbnkgaW50ZXJ2YWwtYmFzZWQgZGF0YSBzdHJ1Y3R1cmUuDQo+IA0KPiBZb3UnZCBoYXZlIHRv
IGFsbG93IHVzZXJzcGFjZSB0byB1cHBlciBib3VuZCB0aGUgbnVtYmVyIG9mIGludGVydmFscw0K
PiAoc2ltaWxhciB0byB0aGUgbWF4aW11bSBiaXRtYXAgc2l6ZSksIHRvIHByZXZlbnQgaG9zdCBP
T01zIGR1ZSB0bw0KPiBtYWxpY2lvdXMgZ3Vlc3RzLiBUaGVyZSdzIHNvbWV0aGluZyBuaWNlIGFi
b3V0IHRoZSBndWVzdCBkb25hdGluZw0KPiBtZW1vcnkgZm9yIHRoaXMsIHNpbmNlIHRoYXQgd291
bGQgZWxpbWluYXRlIHRoZSBPT00gcmlzay4NCg==
