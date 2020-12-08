Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE922D22FA
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 06:20:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbgLHFTe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 00:19:34 -0500
Received: from mail-dm6nam10on2062.outbound.protection.outlook.com ([40.107.93.62]:54483
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725208AbgLHFTd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 00:19:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jq3G4thOrXYAF4KGkuQpMwpg9R96pbGj2TrlIBxEDACiCxuqa6u90tv99m6z88j3cwm5nDvZu7NfbU2+S53nZtE6fytbS8WyTeAlu6tRUcumFaKKIDv+wlQ+i82mdvC8v8XppuySy2tCfK7pk/qia3jeGE3doF2gu0hAAWuKaMjGxedwmxwTJTVQWI3PVG9fbIAmgqJB/XGjgvNvnU5nFyvZ3L91f8hFQ9L8Sp2eGyH4Bj88X/1uKLGM8Wl297K6FH1uU1My49T4G8p8cHRI2ynv/GX5j9Mu4z7LlMz9asxArGlbbLJOp6RJVFzTxCU5IWxTrjB6d6SykO/sqthzlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fq/nWjzbuOEtwLKIVC3C7BxZKB6qQRtyrOgPmy/uydA=;
 b=O4t/S6P3ksVDaE83loId58kBAT9GDa6/9/24WmY4lIjbyzsITD55+PBoOpLYc4OIh+BDq1Mg7NN/4bUnSylL3UKAmHgKRCg6abXFGR3YlUx5ZljvxfwP94qaSBeHLDSx6IH/OJZJ4U7JFU6vhjphbU+wllqPjE8yt5JM8jKOlhKsvpQeMZZcgerF02uhoknU6ax+loD867i5rUY0yRR0ncvI1TwE49xtYQMGxKkRHHvPQ1VLYVyLyPAkI3i2/KjbRdZFsba9Elex5KwdDoGoKMmrsq2yvdb882awgixmaHqCELMqQbH4I1nqp6CnS2sBa80aHyckhA0d2v3HXsQbgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fq/nWjzbuOEtwLKIVC3C7BxZKB6qQRtyrOgPmy/uydA=;
 b=NsORz/caXEteYcNRuGPAERiOTnUmpasjuXRTGCbWqSC59GqwCKRHNVpy4UK1B5NQzFxs8CRAk/MH6QPYsTEFJz1AjWWQdIbSVoofBTacoOvI4vQcm9JXW5rBJiKh1Wbpr46KybtMm/nt7l/H5P0qUXGJGL/ZCFnr/YZUJFbFoi8=
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN1PR12MB2509.namprd12.prod.outlook.com (2603:10b6:802:29::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.20; Tue, 8 Dec
 2020 05:18:39 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec%3]) with mapi id 15.20.3632.021; Tue, 8 Dec 2020
 05:18:39 +0000
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
Thread-Index: AQHWzSGWhMvANWb9E0qMKjN0N5JscQ==
Date:   Tue, 8 Dec 2020 05:18:39 +0000
Message-ID: <373DF203-88D9-4501-AC0F-CB7D191050B1@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
x-originating-ip: [136.49.12.8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e9fbb03c-b5a4-408b-3314-08d89b38b8c2
x-ms-traffictypediagnostic: SN1PR12MB2509:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN1PR12MB2509F919104607E1B5CD8D428ECD0@SN1PR12MB2509.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uetEZOINw1JG6zlXStStejLlu6VFeHICrh0NOgX6iJ2dzkgp9yr3RNa9NW5eRfR8nrCcw3x4oelJuGAhhfYj5Vxjj91VkZaAn+SmeSly9hdfep3GOGr5kS7f7o7VxBjxNGlLoCqCDK78wRAJxIskiSvQhOmDGPvr3+x/8ZrXns0+LJt7Ar+0a2hHEGGJXGcqL9lBS8/hednF0H7mClT59qf9Djp7ZMO+QYvpQOjIJ/p8iIZG7Rg5BK4/o0QrARy/n3tNuKxLH/Lv92cAX9qSaaTXUM2elIvXr2S4ofS7HdlJiZ+VDeq1SUV06S5RpLGu8W9nzc+FetwQImjQQQxhzyh3cPvk7Bq0eu1dCFv9eJj8kSxKZPqwQ01mO9tpYuL8
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(366004)(346002)(396003)(376002)(83380400001)(316002)(6486002)(36756003)(478600001)(33656002)(66476007)(2906002)(26005)(53546011)(7416002)(6916009)(4326008)(86362001)(8676002)(8936002)(66946007)(54906003)(6506007)(64756008)(71200400001)(186003)(6512007)(76116006)(66556008)(66446008)(2616005)(5660300002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?ZE15LzIvK3V1UWh1S0pGN0JmNkYzSjNTbFh2Y3pQdG9ubXNnSTJnL2dybzQ1?=
 =?utf-8?B?bjVOdFR6SnU4Zzk4NTUwakkzam1ySjY4ZDN1dG5ERVNyam5XUFg0TEZCMXpO?=
 =?utf-8?B?V0VzY293WGxIbHMwd3RwWnh4c2ViYTJEMzJiT1JkUk5oNXpQU0hIMlNyU0Zt?=
 =?utf-8?B?OXZLMk9hd1NxbitQOUtyVFRDRkdMZ2dCem9UNzZlenZGN1h3WjBrUDhqOHlJ?=
 =?utf-8?B?OG40RDhtSzZLcTRoQWh3QzcxdHlzc1lLcW82bmVRQWs5WnptOHc5d3J2OFhz?=
 =?utf-8?B?K2w3NTMyWm5XaUIvaWNkSE1BQlQ5dXVnV3dubEFYbEl2MWJDK2JhTlNBM2ZV?=
 =?utf-8?B?V0poekFDa1NVNGk3MG5mcW5RMkVxUnFUNlJ1TnJKM2RWK250Y1JwQ3VvdWZ1?=
 =?utf-8?B?VDNWL2Q0Q3NaczFwZmovYU53U2U4dkptNjJneFRxdG92b29VeHpFaWI1dkU0?=
 =?utf-8?B?TDA3aWVLaTVoRHdoUnl0cjRSU0lSbitzaHNQeCtneUJmWHpTV3o3L0plZ09S?=
 =?utf-8?B?K3UvV1I0dDVIUDkxNEtFTmtZYk9KdjNwaU1TS2svWGd5aUxjWlBMRVpUenAz?=
 =?utf-8?B?MXVXZEN5RWZNQk5RZWFBY0srNFRPZytjc280UHFlekVucTdoYnVQVkZ4eFpR?=
 =?utf-8?B?UVRPQVBPZWMya3FmRmJRbFUvYXk3cUZSeFJNd2MvSVJCSEhUVUZXQ3M3ME5z?=
 =?utf-8?B?V1l4N1pkVTVmQS9sL1F4MHZocy82VG1vcDg1V0ZjVnFoQjJKeUM0WGVKVFhm?=
 =?utf-8?B?T0J2TGlkdGszSkhEazR3cFBrM1ZoS1U0N0lRbkV4RkVuRjRaN3VXL3FZVFk1?=
 =?utf-8?B?UEJkVVppUjJnbkQxOEhwK1pNUUs4cndTSkZjY3o4cmNhU2JjRWtoRzdOeHJY?=
 =?utf-8?B?eGFHMExNLzBHWDh6SXUrYTN2MGhZZjZpNUs1UXVFOHZGYSt4aFJ2M1hoQ1JL?=
 =?utf-8?B?S2FubFB3MG5ZekVJRGZWaFU4VFNGTjhPOTBMeW1iTG5OelBBSmRwV0ZEdHBw?=
 =?utf-8?B?MlVzR0JZVFRuemV0QU1NSkNBMWY5S095VzN6b2NYcXRFT2o1S1ZnalNTMzdr?=
 =?utf-8?B?Wjh1endPNkE3Zml0cDExTXRaakgrSGYrQU5XL2I4ZjF6NzJLZkpxSkFUM2pK?=
 =?utf-8?B?Yy9mTHh2VjZtM1dHaXZGS0lqY2dCcG1FZU9YT1BqM3BBTFpTMGxSSG9rY2dr?=
 =?utf-8?B?VUg5YWw1ZHpyb0lVcldZWExhb0t6NUtxTkgyQ0ovUmhlKzFsNGtWZjRWYkYr?=
 =?utf-8?B?OFhWczRGcFVwVWQ0Mm5HK1FrTzE1ckluUlMyNkt0U3phVTYyUnRSRzhlejhy?=
 =?utf-8?Q?HYbYygzGnta7M=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B89636C08695D7448C7E784AC5F01CB8@amdcloud.onmicrosoft.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9fbb03c-b5a4-408b-3314-08d89b38b8c2
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Dec 2020 05:18:39.2124
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WUnda1TYg/P6zfoUe/oTslUWKkqodEzqqA9YaiUd+ZX04o68ZkwDkHvV2odJI6rgpcWA0QubCaawmHj3EY6k+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2509
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQo+IA0KPj4gSSBzdXNwZWN0IGEgbGlzdA0KPj4gd291bGQgY29uc3VtZSBmYXIgbGVzcyBtZW1v
cnksIGhvcGVmdWxseSB3aXRob3V0IGltcGFjdGluZyBwZXJmb3JtYW5jZS4NCg0KQW5kIGhvdyBt
dWNoIGhvc3QgbWVtb3J5IGFyZSB3ZSB0YWxraW5nIGFib3V0IGZvciBoZXJlLCBzYXkgZm9yIGEg
NGdiIGd1ZXN0LCB0aGUgYml0bWFwIHdpbGwgYmUgdXNpbmcganVzdCB1c2luZyBzb21ldGhpbmcg
bGlrZSAxMjhrKy4NCg0KVGhhbmtzLA0KQXNoaXNoDQoNCj4gT24gRGVjIDcsIDIwMjAsIGF0IDEw
OjE2IFBNLCBLYWxyYSwgQXNoaXNoIDxBc2hpc2guS2FscmFAYW1kLmNvbT4gd3JvdGU6DQo+IA0K
PiDvu79JIGRvbuKAmXQgdGhpbmsgdGhhdCB0aGUgYml0bWFwIGJ5IGl0c2VsZiBpcyByZWFsbHkg
YSBwZXJmb3JtYW5jZSBib3R0bGVuZWNrIGhlcmUuDQo+IA0KPiBUaGFua3MsDQo+IEFzaGlzaA0K
PiANCj4+PiBPbiBEZWMgNywgMjAyMCwgYXQgOToxMCBQTSwgU3RldmUgUnV0aGVyZm9yZCA8c3J1
dGhlcmZvcmRAZ29vZ2xlLmNvbT4gd3JvdGU6DQo+Pj4g77u/T24gTW9uLCBEZWMgNywgMjAyMCBh
dCAxMjo0MiBQTSBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT4gd3JvdGU6
DQo+Pj4+IE9uIFN1biwgRGVjIDA2LCAyMDIwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0KPj4+PiBP
biAwMy8xMi8yMCAwMTozNCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToNCj4+Pj4+IE9uIFR1
ZSwgRGVjIDAxLCAyMDIwLCBBc2hpc2ggS2FscmEgd3JvdGU6DQo+Pj4+Pj4gRnJvbTogQnJpamVz
aCBTaW5naCA8YnJpamVzaC5zaW5naEBhbWQuY29tPg0KPj4+Pj4+IEtWTSBoeXBlcmNhbGwgZnJh
bWV3b3JrIHJlbGllcyBvbiBhbHRlcm5hdGl2ZSBmcmFtZXdvcmsgdG8gcGF0Y2ggdGhlDQo+Pj4+
Pj4gVk1DQUxMIC0+IFZNTUNBTEwgb24gQU1EIHBsYXRmb3JtLiBJZiBhIGh5cGVyY2FsbCBpcyBt
YWRlIGJlZm9yZQ0KPj4+Pj4+IGFwcGx5X2FsdGVybmF0aXZlKCkgaXMgY2FsbGVkIHRoZW4gaXQg
ZGVmYXVsdHMgdG8gVk1DQUxMLiBUaGUgYXBwcm9hY2gNCj4+Pj4+PiB3b3JrcyBmaW5lIG9uIG5v
biBTRVYgZ3Vlc3QuIEEgVk1DQUxMIHdvdWxkIGNhdXNlcyAjVUQsIGFuZCBoeXBlcnZpc29yDQo+
Pj4+Pj4gd2lsbCBiZSBhYmxlIHRvIGRlY29kZSB0aGUgaW5zdHJ1Y3Rpb24gYW5kIGRvIHRoZSBy
aWdodCB0aGluZ3MuIEJ1dA0KPj4+Pj4+IHdoZW4gU0VWIGlzIGFjdGl2ZSwgZ3Vlc3QgbWVtb3J5
IGlzIGVuY3J5cHRlZCB3aXRoIGd1ZXN0IGtleSBhbmQNCj4+Pj4+PiBoeXBlcnZpc29yIHdpbGwg
bm90IGJlIGFibGUgdG8gZGVjb2RlIHRoZSBpbnN0cnVjdGlvbiBieXRlcy4NCj4+Pj4+PiBBZGQg
U0VWIHNwZWNpZmljIGh5cGVyY2FsbDMsIGl0IHVuY29uZGl0aW9uYWxseSB1c2VzIFZNTUNBTEwu
IFRoZSBoeXBlcmNhbGwNCj4+Pj4+PiB3aWxsIGJlIHVzZWQgYnkgdGhlIFNFViBndWVzdCB0byBu
b3RpZnkgZW5jcnlwdGVkIHBhZ2VzIHRvIHRoZSBoeXBlcnZpc29yLg0KPj4+Pj4gV2hhdCBpZiB3
ZSBpbnZlcnQgS1ZNX0hZUEVSQ0FMTCBhbmQgWDg2X0ZFQVRVUkVfVk1NQ0FMTCB0byBkZWZhdWx0
IHRvIFZNTUNBTEwNCj4+Pj4+IGFuZCBvcHQgaW50byBWTUNBTEw/ICBJdCdzIGEgc3ludGhldGlj
IGZlYXR1cmUgZmxhZyBlaXRoZXIgd2F5LCBhbmQgSSBkb24ndA0KPj4+Pj4gdGhpbmsgdGhlcmUg
YXJlIGFueSBleGlzdGluZyBLVk0gaHlwZXJjYWxscyB0aGF0IGhhcHBlbiBiZWZvcmUgYWx0ZXJu
YXRpdmVzIGFyZQ0KPj4+Pj4gcGF0Y2hlZCwgaS5lLiBpdCdsbCBiZSBhIG5vcCBmb3Igc2FuZSBr
ZXJuZWwgYnVpbGRzLg0KPj4+Pj4gSSdtIGFsc28gc2tlcHRpY2FsIHRoYXQgYSBLVk0gc3BlY2lm
aWMgaHlwZXJjYWxsIGlzIHRoZSByaWdodCBhcHByb2FjaCBmb3IgdGhlDQo+Pj4+PiBlbmNyeXB0
aW9uIGJlaGF2aW9yLCBidXQgSSdsbCB0YWtlIHRoYXQgdXAgaW4gdGhlIHBhdGNoZXMgbGF0ZXIg
aW4gdGhlIHNlcmllcy4NCj4+Pj4gRG8geW91IHRoaW5rIHRoYXQgaXQncyB0aGUgZ3Vlc3QgdGhh
dCBzaG91bGQgImRvbmF0ZSIgbWVtb3J5IGZvciB0aGUgYml0bWFwDQo+Pj4+IGluc3RlYWQ/DQo+
Pj4gTm8uICBUd28gdGhpbmdzIEknZCBsaWtlIHRvIGV4cGxvcmU6DQo+Pj4gMS4gTWFraW5nIHRo
ZSBoeXBlcmNhbGwgdG8gYW5ub3VuY2UvcmVxdWVzdCBwcml2YXRlIHZzLiBzaGFyZWQgY29tbW9u
IGFjcm9zcw0KPj4+ICAgaHlwZXJ2aXNvcnMgKEtWTSwgSHlwZXItViwgVk13YXJlLCBldGMuLi4p
IGFuZCB0ZWNobm9sb2dpZXMgKFNFVi0qIGFuZCBURFgpLg0KPj4+ICAgSSdtIGNvbmNlcm5lZCB0
aGF0IHdlJ2xsIGVuZCB1cCB3aXRoIG11bHRpcGxlIGh5cGVyY2FsbHMgdGhhdCBkbyBtb3JlIG9y
DQo+Pj4gICBsZXNzIHRoZSBzYW1lIHRoaW5nLCBlLmcuIEtWTStTRVYsIEh5cGVyLVYrU0VWLCBU
RFgsIGV0Yy4uLiAgTWF5YmUgaXQncyBhDQo+Pj4gICBwaXBlIGRyZWFtLCBidXQgSSdkIGxpa2Ug
dG8gYXQgbGVhc3QgZXhwbG9yZSBvcHRpb25zIGJlZm9yZSBzaG92aW5nIGluIEtWTS0NCj4+PiAg
IG9ubHkgaHlwZXJjYWxscy4NCj4+PiAyLiBUcmFja2luZyBzaGFyZWQgbWVtb3J5IHZpYSBhIGxp
c3Qgb2YgcmFuZ2VzIGluc3RlYWQgb2YgYSB1c2luZyBiaXRtYXAgdG8NCj4+PiAgIHRyYWNrIGFs
bCBvZiBndWVzdCBtZW1vcnkuICBGb3IgbW9zdCB1c2UgY2FzZXMsIHRoZSB2YXN0IG1ham9yaXR5
IG9mIGd1ZXN0DQo+Pj4gICBtZW1vcnkgd2lsbCBiZSBwcml2YXRlLCBtb3N0IHJhbmdlcyB3aWxs
IGJlIDJtYissIGFuZCBjb252ZXJzaW9ucyBiZXR3ZWVuDQo+Pj4gICBwcml2YXRlIGFuZCBzaGFy
ZWQgd2lsbCBiZSB1bmNvbW1vbiBldmVudHMsIGkuZS4gdGhlIG92ZXJoZWFkIHRvIHdhbGsgYW5k
DQo+Pj4gICBzcGxpdC9tZXJnZSBsaXN0IGVudHJpZXMgaXMgaG9wZWZ1bGx5IG5vdCBhIGJpZyBj
b25jZXJuLiAgSSBzdXNwZWN0IGEgbGlzdA0KPj4+ICAgd291bGQgY29uc3VtZSBmYXIgbGVzcyBt
ZW1vcnksIGhvcGVmdWxseSB3aXRob3V0IGltcGFjdGluZyBwZXJmb3JtYW5jZS4NCj4+IEZvciBh
IGZhbmNpZXIgZGF0YSBzdHJ1Y3R1cmUsIEknZCBzdWdnZXN0IGFuIGludGVydmFsIHRyZWUuIExp
bnV4DQo+PiBhbHJlYWR5IGhhcyBhbiByYnRyZWUtYmFzZWQgaW50ZXJ2YWwgdHJlZSBpbXBsZW1l
bnRhdGlvbiwgd2hpY2ggd291bGQNCj4+IGxpa2VseSB3b3JrLCBhbmQgd291bGQgcHJvYmFibHkg
YXNzdWFnZSBhbnkgcGVyZm9ybWFuY2UgY29uY2VybnMuDQo+PiBTb21ldGhpbmcgbGlrZSB0aGlz
IHdvdWxkIG5vdCBiZSB3b3J0aCBkb2luZyB1bmxlc3MgbW9zdCBvZiB0aGUgc2hhcmVkDQo+PiBw
YWdlcyB3ZXJlIHBoeXNpY2FsbHkgY29udGlndW91cy4gQSBzYW1wbGUgVWJ1bnR1IDIwLjA0IFZN
IG9uIEdDUCBoYWQNCj4+IDYwaXNoIGRpc2NvbnRpZ3VvdXMgc2hhcmVkIHJlZ2lvbnMuIFRoaXMg
aXMgYnkgbm8gbWVhbnMgYSB0aG9yb3VnaA0KPj4gc2VhcmNoLCBidXQgaXQncyBzdWdnZXN0aXZl
LiBJZiB0aGlzIGlzIHR5cGljYWwsIHRoZW4gdGhlIGJpdG1hcCB3b3VsZA0KPj4gYmUgZmFyIGxl
c3MgZWZmaWNpZW50IHRoYW4gbW9zdCBhbnkgaW50ZXJ2YWwtYmFzZWQgZGF0YSBzdHJ1Y3R1cmUu
DQo+PiBZb3UnZCBoYXZlIHRvIGFsbG93IHVzZXJzcGFjZSB0byB1cHBlciBib3VuZCB0aGUgbnVt
YmVyIG9mIGludGVydmFscw0KPj4gKHNpbWlsYXIgdG8gdGhlIG1heGltdW0gYml0bWFwIHNpemUp
LCB0byBwcmV2ZW50IGhvc3QgT09NcyBkdWUgdG8NCj4+IG1hbGljaW91cyBndWVzdHMuIFRoZXJl
J3Mgc29tZXRoaW5nIG5pY2UgYWJvdXQgdGhlIGd1ZXN0IGRvbmF0aW5nDQo+PiBtZW1vcnkgZm9y
IHRoaXMsIHNpbmNlIHRoYXQgd291bGQgZWxpbWluYXRlIHRoZSBPT00gcmlzay4NCg==
