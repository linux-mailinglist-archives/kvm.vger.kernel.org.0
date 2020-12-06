Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2D22D0566
	for <lists+kvm@lfdr.de>; Sun,  6 Dec 2020 15:12:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728113AbgLFOKQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Dec 2020 09:10:16 -0500
Received: from mail-mw2nam10on2047.outbound.protection.outlook.com ([40.107.94.47]:3041
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726757AbgLFOKP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Dec 2020 09:10:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JSE0BveNEG5BLagGbN3cPJHMRVc9FrCVzLO3P+01HAlDzT/RD3gP1Y4lDiRlDaNwbmg6TbUe3dVKoOCoCpCNNTu4qv0M94I5ROdzXw1df/tbzWdrHBoc5N+ga7tWIxO/ycAynMMt/e/vCT88ay2hmjv36XCKYO8WnjlnOJe1qo0OXSL3rfAdULnCxJbaldyDVav6aaQUtWUQNbKX2EU9L7buNODUkE+7kvYHtAybSsDzzhL+XW7viHHOITM9IBxgYE9EP5RF4CzoytBoyhvJH+EFhGeGpqlKxqNobIdi+CHrngTh0VYma8FBk91+Cl3FTt5AyC4MMs0meG5QFmGLPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dAajB+0DHLNGF6BhVNSxgOudLrYDNJIDBrPlgjc7m94=;
 b=HGnguoD2yzRG4AakHhBsroNTzVOraS6YBFsoHnESuytVIKiA5SJ7e6BuGfomilYjgz8pOcKSUNBwTR9FQ+gKrx67Mti9D2iWMID0Y9T0jct94apdTVWjlK7yvqfZ1ok95vzyXhzEJzCK3MZCf8i+TpdwxaluTXjp7vPDWOrwuTWF0KIXu4Ruq9QWGwF6vTmBeXrW4tBUaLYa7NN4z28vDUuvCW/Rgq+2lLea6mlrlgc0A7PL5unmsyZ5WnJLVjckiVvB3gYwLs55XIaCjeS6OmUKi2ix516pJjm2vsR99MbVyE5tBkRPWNLF3knXOfQn3gILGYiL+hNCzjz+A+n2Fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dAajB+0DHLNGF6BhVNSxgOudLrYDNJIDBrPlgjc7m94=;
 b=jnS3quq9N4he3C93r0ODNkXT7yokjreOy1HjfJJ+bBdL5txrtjyM0yZXCK5O7ZaG1wtEbQjgktaJ5gKBpyGSVxwysPUOhtViZzASxFNqPYM4NUdHqhOL/Mq9/EcxPTWQFU36ghCVJzZsFPr6SwJRMr7B3jbH2h7+wWp3CarLg4s=
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN1PR12MB2511.namprd12.prod.outlook.com (2603:10b6:802:23::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.23; Sun, 6 Dec
 2020 14:09:21 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec%3]) with mapi id 15.20.3632.021; Sun, 6 Dec 2020
 14:09:21 +0000
From:   "Kalra, Ashish" <Ashish.Kalra@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Sean Christopherson <seanjc@google.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "bp@suse.de" <bp@suse.de>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "srutherford@google.com" <srutherford@google.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "venu.busireddy@oracle.com" <venu.busireddy@oracle.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v8 13/18] KVM: x86: Introduce new
 KVM_FEATURE_SEV_LIVE_MIGRATION feature & Custom MSR.
Thread-Topic: [PATCH v8 13/18] KVM: x86: Introduce new
 KVM_FEATURE_SEV_LIVE_MIGRATION feature & Custom MSR.
Thread-Index: AQHWymAuO15yco/y+0qZupKZxhig2qnp6J/qgAA1anA=
Date:   Sun, 6 Dec 2020 14:09:21 +0000
Message-ID: <890C57FE-6B42-4AC5-BC4A-CB2FEAA0A674@amd.com>
References: <X8pocPZzn6C5rtSC@google.com>
 <20201204170855.1131-1-Ashish.Kalra@amd.com>
 <X8pwmoQW6VSA2SZy@google.com>,<8fa0f11e-2737-5ecb-f2e6-4e5c21e68b9c@redhat.com>
In-Reply-To: <8fa0f11e-2737-5ecb-f2e6-4e5c21e68b9c@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
x-originating-ip: [136.49.12.8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e5033fda-8718-40f9-7a25-08d899f08765
x-ms-traffictypediagnostic: SN1PR12MB2511:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN1PR12MB25113EB591AB7953E34774C38ECF0@SN1PR12MB2511.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IMjFpD8SUZ8+bejN7X0bXDEimulb5FTi2xT10+UsOvhOjIYfSzAXm5zX2VMLXHWB7g05qH077Tq01aaNw/MS26uzGcGnXsEkHbKlknwtLcXTh/vY/we2qqV0lvQ7ptowZTEUzUOTMbpubAM66ANRAKc4Lecn9H7KV2s2KPI70cVTKrMAitGanYxv/p7oxONfLggqjWMGGQbKAnM8xxotdpSA2XpE3A5YRXgp/dPTSFpJ7UzJr4WTupQ2soasoPlkqBbP9E0kPfGew7ZphvQ79AJ/pnqL6TryERGtWRYar+zoGY7sV8SrFOwExWWnOC15GlvvsXqxP3jjF9IxrounmDXHXrZQvMoyoAQbuXz0mPTvjJOzv6Gjo4mPOEya9Mr9
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(346002)(39850400004)(366004)(136003)(7416002)(76116006)(4326008)(66476007)(66556008)(36756003)(64756008)(66946007)(33656002)(86362001)(6916009)(54906003)(6486002)(6512007)(71200400001)(8676002)(2616005)(2906002)(8936002)(91956017)(66446008)(316002)(186003)(478600001)(26005)(53546011)(5660300002)(6506007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?M1Y0ZGxpcVZKRCt4R1ZkSHRQSElPb0xMNlJ3aCtQVkIyS1hUYkp1ZW94TUZh?=
 =?utf-8?B?c2RQZ05DY08rYnVZS3EzbHlDdHYwQjA2aitsWnJVdGx1SVl0VEk3QlNaVWVl?=
 =?utf-8?B?dllPVlVRamRyWjJxWmFRZE5YQ3lnZFo5Y3BLb2p0V0FZeFJpSEpwUGNZQnVv?=
 =?utf-8?B?K3ZFS0lqbkpxNkJ5Smp1bS9QWmFWOTQ3ZmFEQTF1Sm1YaWZGaGJ2aGVsbmNU?=
 =?utf-8?B?eVlNbWw0S3p6ZzBRWTdLWERrUHFCM2F4ejNUV1hMRTdQalBVeG81MGxBRnlj?=
 =?utf-8?B?azFvdmV4OTRINVVNd1BsQ3N1VTc3SGVxZHRpR3FpclJDeU1DcjNhbGtLemJV?=
 =?utf-8?B?ZExjWXdVekhYYVlRSEFyRjk5UXdrUjd1YUdXMmVxOVFLaVNRN0wvd1JHdHJD?=
 =?utf-8?B?K1ZDdktoQU9FeXdHbG44Nm5qQ3pRYyt1SDd1TmJFYlltQnVJTGVMOEg0OUxp?=
 =?utf-8?B?VTIrcVBIbjV0ZHVDMG11MjhRbGlNejg1N0J5VXJJM1B6YW5KMDYyVWlaZTdC?=
 =?utf-8?B?UVYrLytRbUJlZmhLenphVUYxTnlPMnhLR3hzR3VlUHFJOEp1cng3THpER21p?=
 =?utf-8?B?RHZ0Z3RxaytnSldMWHdUWEVtUi9ZVytTRkxhdmdIOXE4eXpJRWlndjNpeW9w?=
 =?utf-8?B?Q3hieG0zSnFtMFZ0MXFXOUZScEo1VStuSTF6Q1M0NzFxRmN5VkRWamR0bDZt?=
 =?utf-8?B?NlQ2UitZQXpRakJoUSszbmJtYTFSNE9jN0xUbGk1VFRmVjNrNTRvOExYL1FT?=
 =?utf-8?B?TnJQOXpMc2FabXJoSXVxQjBZTUdwM0hxeUwyTk1MeVRFUEMrQThJbGhXM0t5?=
 =?utf-8?B?Y0FkdDFzZmVCZTh6WWNtZEJiK2FBQys5ZG55bk9kR2RoSTdRL2JSYlZScEJB?=
 =?utf-8?B?N3FsK0lyT1lEU2RMaVNNNnkvUXVYaUo2VmVEaFdqWXlwd3FteWwyWlpvQTFC?=
 =?utf-8?B?WmlVN1FSRE9ZejVzcUViQUFreWhEUEZjRjRBMGZiQ1hYSkhjNVpZUHYyTEZv?=
 =?utf-8?B?VHNsUjQrZDhwVm1mbEZKSk5XS3V4Yk5TcUpFSmpLancwRmJyU3ZGSU9XemJn?=
 =?utf-8?B?aGsxcHorcmx6Nm1pVjYrb0NieGEzQ2l3cG5QSkw4YkhsYUNiRTAzMzduY2hR?=
 =?utf-8?B?MTNMTEtUUDE2WmVGd0ZlK1c5bHhoSFI4Q0N4amxGaWU4QmZmdXJFV2VUWXZ1?=
 =?utf-8?B?K3g3a2kxS3JhUVpWaFZKQnRLZVJMZmRXc0d1Z0JHTlhDcm9NQ0F6WXJLTEln?=
 =?utf-8?B?VmxmTjc0K29uYUp1RUpCZVhkM200aXZBZzZXTS95c21xZzFuQUNaSW9lWVlO?=
 =?utf-8?Q?yJszY+taFc2/Q=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5033fda-8718-40f9-7a25-08d899f08765
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Dec 2020 14:09:21.4731
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YzxkOU7MWUUFBHwluEqfhDRPUp4Mkj/EsBxhj+ls4nnLIigL3YS8+r76UW8e03oH5OUOWJUnnpTRfxEbuVA3Mw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2511
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQo+IE9uIERlYyA2LCAyMDIwLCBhdCA0OjU4IEFNLCBQYW9sbyBCb256aW5pIDxwYm9uemluaUBy
ZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+IO+7v09uIDA0LzEyLzIwIDE4OjIzLCBTZWFuIENocmlz
dG9waGVyc29uIHdyb3RlOg0KPj4+IE9uIEZyaSwgRGVjIDA0LCAyMDIwLCBBc2hpc2ggS2FscmEg
d3JvdGU6DQo+Pj4gQW4gaW1tZWRpYXRlIHJlc3BvbnNlLCBhY3R1YWxseSB0aGUgU0VWIGxpdmUg
bWlncmF0aW9uIHBhdGNoZXMgYXJlIHByZWZlcnJlZA0KPj4+IG92ZXIgdGhlIFBhZ2UgZW5jcnlw
dGlvbiBiaXRtYXAgcGF0Y2hlcywgaW4gb3RoZXIgd29yZHMsIGlmIFNFViBsaXZlDQo+Pj4gbWln
cmF0aW9uIHBhdGNoZXMgYXJlIGFwcGxpZWQgdGhlbiB3ZSBkb24ndCBuZWVkIHRoZSBQYWdlIGVu
Y3J5cHRpb24gYml0bWFwDQo+Pj4gcGF0Y2hlcyBhbmQgd2UgcHJlZmVyIHRoZSBsaXZlIG1pZ3Jh
dGlvbiBzZXJpZXMgdG8gYmUgYXBwbGllZC4NCj4+PiANCj4+PiBJdCBpcyBub3QgdGhhdCBwYWdl
IGVuY3J5cHRpb24gYml0bWFwIHNlcmllcyBzdXBlcnNlZGUgdGhlIGxpdmUgbWlncmF0aW9uDQo+
Pj4gcGF0Y2hlcywgdGhleSBhcmUganVzdCBjdXQgb2YgdGhlIGxpdmUgbWlncmF0aW9uIHBhdGNo
ZXMuDQo+PiBJbiB0aGF0IGNhc2UsIGNhbiB5b3UgcG9zdCBhIGZyZXNoIHZlcnNpb24gb2YgdGhl
IGxpdmUgbWlncmF0aW9uIHNlcmllcz8gIFBhb2xvDQo+PiBpcyBvYnZpb3VzbHkgd2lsbGluZyB0
byB0YWtlIGEgYmlnIGNodW5rIG9mIHRoYXQgc2VyaWVzLCBhbmQgaXQgd2lsbCBsaWtlbHkgYmUN
Cj4+IGVhc2llciB0byByZXZpZXcgd2l0aCB0aGUgZnVsbCBjb250ZXh0LCBlLmcuIG9uZSBvZiBt
eSBjb21tZW50cyBvbiB0aGUgc3RhbmRhbG9uZQ0KPj4gZW5jcnlwdGlvbiBiaXRtYXAgc2VyaWVz
IHdhcyBnb2luZyB0byBiZSB0aGF0IGl0J3MgaGFyZCB0byByZXZpZXcgd2l0aG91dCBzZWVpbmcN
Cj4+IHRoZSBsaXZlIG1pZ3JhdGlvbiBhc3BlY3QuDQo+IA0KPiBJdCBzdGlsbCBhcHBsaWVzIHdp
dGhvdXQgY2hhbmdlLiAgRm9yIG5vdyBJJ2xsIG9ubHkga2VlcCB0aGUgc2VyaWVzIHF1ZXVlZCBp
biBteSAobilTVk0gYnJhbmNoLCBidXQgd2lsbCBob2xkIG9uIGFwcGx5aW5nIGl0IHRvIGt2bS5n
aXQncyBxdWV1ZSBhbmQgbmV4dCBicmFuY2hlcy4NCj4gDQoNCk9rIHRoYW5rcyBQYW9sby4NCg==
