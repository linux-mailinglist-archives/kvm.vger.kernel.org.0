Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0786D6B032
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2019 22:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728535AbfGPUCt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jul 2019 16:02:49 -0400
Received: from mail-eopbgr720085.outbound.protection.outlook.com ([40.107.72.85]:2477
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726213AbfGPUCs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jul 2019 16:02:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HeLEjRzvA3/0zpRBAVYv71hHWv82W03J/sVkAvYVuriGhd+HSh238ng7I711PgZJiq9VWoMroEHPe3SBubu1/mCGBUlLaQbC9fEif+AQM+M4omurjU/DlvTM/FTs5FJ052aXM/PbB+fapEqLcWXZq7V4lfN26vKLi83nkVUOLR+P7MJMOrvqCY5NaJ6vXth9vRUKIa4EDNJGEJq6RdjethZR686VbTvwpyd95GDdV4PU1pCZScIjCvg9wIP4haIrHvJfmUV7KVOHIhw5v0drZWCPHzKneyAaMXPuPR0VgqdwoB5qe10S7uBelcRidaq+qs0jre7iaATlHMPGOygGjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T5HTnW0pizBbwQqRp8mIbaFX6++xgvMhHk0NNTj1/x0=;
 b=fOQUKWhwWDI3UD8YZ1Fe+iTH5Vi0JeRiTITyDurVzgLurEmq2/D6qkabaOJ10TeDD0xgEdXkV3u+NFVqQcQ/kN7Us12M+nmuVYvoc2Eakrs8eFhtl15IsltN+0ei45AXcmMXaPImk9S/c3qoB82n6GZ6Uh6ghptMGImpx1x2Yvjp9K98lG0yLUI52YqeeFdXtfuEt6Sp5DMKEN6oy7xerPvX36qwL4h8cdRANlyeyH/49Cbxv12k+Fe8FYOHLXOuApGGK7Dz05l9kM8+NpsgsHFzgsT434jtgXMfU6rVt+Ez+IOnLDQAjyHSJsLPXFKlyQ3f2hqO3HO3BkDafEwqDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=amd.com;dmarc=pass action=none header.from=amd.com;dkim=pass
 header.d=amd.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T5HTnW0pizBbwQqRp8mIbaFX6++xgvMhHk0NNTj1/x0=;
 b=IGfXYef4HJ4fSzEilXhEHx3yirclC7h0qy8UlkRgOwxWy6lvTCb9XY1IggLZNSlCzG6fBrv1Jz1b1LP/GffTdZ/+sT9a0Yz0e6kHfGGsKrJeK5L91BkCmcXpDM5bq98sLOXOj3S/nNC5ZmT9mkJNjLPPn3AUZScONIUaB9+a3R0=
Received: from DM6PR12MB2682.namprd12.prod.outlook.com (20.176.118.13) by
 DM6PR12MB2652.namprd12.prod.outlook.com (20.176.116.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.14; Tue, 16 Jul 2019 20:02:44 +0000
Received: from DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::7439:ea87:cc5d:71]) by DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::7439:ea87:cc5d:71%7]) with mapi id 15.20.2073.012; Tue, 16 Jul 2019
 20:02:44 +0000
From:   "Singh, Brijesh" <brijesh.singh@amd.com>
To:     Liran Alon <liran.alon@oracle.com>
CC:     "Singh, Brijesh" <brijesh.singh@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH 1/2] KVM: SVM: Fix workaround for AMD Errata 1096
Thread-Topic: [PATCH 1/2] KVM: SVM: Fix workaround for AMD Errata 1096
Thread-Index: AQHVO0w5JJR7Enn+ZEGfnHG07AdKnabMIb8AgAFDlACAAAIYgIAAA+gAgAAC6ACAAAXogIAABBmAgAAInwCAAAJiAIAAH44AgAABewCAAAf7AA==
Date:   Tue, 16 Jul 2019 20:02:43 +0000
Message-ID: <31926848-2cf3-caca-335d-5f3e32a25cd3@amd.com>
References: <20190715203043.100483-1-liran.alon@oracle.com>
 <20190715203043.100483-2-liran.alon@oracle.com>
 <1ef0f594-2039-1aeb-4fe0-edbc21fa1f60@amd.com>
 <CF48BCA4-4BC8-4AC8-8B48-85FA29E16719@oracle.com>
 <f6c78d65-70fc-4a79-44db-6abb0434db73@amd.com>
 <F2442A5C-702A-433D-9156-056E1844F378@oracle.com>
 <20190716164151.GC1987@linux.intel.com>
 <60D01C4B-EC2E-453E-B5F6-BBE8FA94E31D@oracle.com>
 <ce1284de-6088-afd7-ead4-6ef70b89f365@redhat.com>
 <DD44D29C-36C4-42E7-905E-7300F92F3BE6@oracle.com>
 <015b03bc-8518-2066-c916-f5e12dd2d506@amd.com>
 <174F27B9-2C6B-4B9F-8091-56FA85B32BB2@oracle.com>
In-Reply-To: <174F27B9-2C6B-4B9F-8091-56FA85B32BB2@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN1PR12CA0064.namprd12.prod.outlook.com
 (2603:10b6:802:20::35) To DM6PR12MB2682.namprd12.prod.outlook.com
 (2603:10b6:5:42::13)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=brijesh.singh@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.77.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c8adddc3-35bf-48f0-400d-08d70a2890ad
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DM6PR12MB2652;
x-ms-traffictypediagnostic: DM6PR12MB2652:
x-microsoft-antispam-prvs: <DM6PR12MB2652C154E9495E47BEB5428FE5CE0@DM6PR12MB2652.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0100732B76
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(136003)(39860400002)(396003)(366004)(199004)(189003)(2616005)(11346002)(2906002)(476003)(6246003)(66066001)(478600001)(71200400001)(31686004)(71190400001)(256004)(3846002)(229853002)(446003)(68736007)(6486002)(99286004)(6436002)(14444005)(6116002)(6916009)(76176011)(66946007)(316002)(66476007)(66556008)(64756008)(66446008)(6512007)(14454004)(81156014)(305945005)(4326008)(81166006)(53936002)(486006)(102836004)(54906003)(26005)(5660300002)(53546011)(386003)(25786009)(8676002)(86362001)(186003)(6506007)(31696002)(8936002)(7736002)(36756003)(52116002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB2652;H:DM6PR12MB2682.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 1nktFS1Qi/Bb49SrwHboizek5/EaXP2nBntrupTqAvR7erUk/6Y8GUPr2Xm4Vpj6QPB5fbP21/rbJG1AykouAf+3NB8f+K7hZRmKfbAxArqz2qK44rmswrTOHngRaCAElnhe/PdZTK6rwpIcsC/p8mHxlpHl/MDcyRmKdJtO1vhTqdUnVN7NDPTCCvNdECBLDcLp1AD0aewZYw0dOfP+L8Gj51cGl84RMYQ18A15Q9sh6Cs2Gr5GpTtNJkKtPsgGXnam0NEjf4HPMoDcz2k1O3FepiKdN+3gCJbCY3aWHZrEdbaXa1msLjOLDjsV/WRpybqp7lyAxYbo2aI3JThgrN56/LGyTNG7vtOv4yuhizPnYYHRIYK69boTnLG57Ryqk9RcBB3gzf/u7ujqczRmfjMPsDw1KT0tTYco3HedFFM=
Content-Type: text/plain; charset="utf-8"
Content-ID: <230E71AC94DD0F408E328F012C246644@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8adddc3-35bf-48f0-400d-08d70a2890ad
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jul 2019 20:02:43.9946
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sbrijesh@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2652
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCk9uIDcvMTYvMTkgMjozNCBQTSwgTGlyYW4gQWxvbiB3cm90ZToNCj4gDQo+IA0KPj4gT24g
MTYgSnVsIDIwMTksIGF0IDIyOjI4LCBTaW5naCwgQnJpamVzaCA8YnJpamVzaC5zaW5naEBhbWQu
Y29tPiB3cm90ZToNCj4+DQo+Pg0KPj4NCj4+IE9uIDcvMTYvMTkgMTI6MzUgUE0sIExpcmFuIEFs
b24gd3JvdGU6DQo+Pj4NCj4+Pg0KPj4+PiBPbiAxNiBKdWwgMjAxOSwgYXQgMjA6MjcsIFBhb2xv
IEJvbnppbmkgPHBib256aW5pQHJlZGhhdC5jb20+IHdyb3RlOg0KPj4+Pg0KPj4+PiBPbiAxNi8w
Ny8xOSAxODo1NiwgTGlyYW4gQWxvbiB3cm90ZToNCj4+Pj4+IElmIHRoZSBDUFUgcGVyZm9ybXMg
dGhlIFZNRXhpdCB0cmFuc2l0aW9uIG9mIHN0YXRlIGJlZm9yZSBkb2luZyB0aGUgZGF0YSByZWFk
IGZvciBEZWNvZGVBc3Npc3QsDQo+Pj4+PiB0aGVuIEkgYWdyZWUgdGhhdCBDUEwgd2lsbCBiZSAw
IG9uIGRhdGEtYWNjZXNzIHJlZ2FyZGxlc3Mgb2YgdkNQVSBDUEwuIEJ1dCB0aGlzIGFsc28gbWVh
bnMgdGhhdCBTTUFQDQo+Pj4+PiB2aW9sYXRpb24gc2hvdWxkIGJlIHJhaXNlZCBiYXNlZCBvbiBo
b3N0IENSNC5TTUFQIHZhbHVlIGFuZCBub3QgdkNQVSBDUjQuU01BUCB2YWx1ZSBhcyBLVk0gY29k
ZSBjaGVja3MuDQo+Pj4+Pg0KPj4+Pj4gRnVydGhlcm1vcmUsIHZDUFUgQ1BMIG9mIGd1ZXN0IGRv
ZXNu4oCZdCBuZWVkIHRvIGJlIDMgaW4gb3JkZXIgdG8gdHJpZ2dlciB0aGlzIEVycmF0YS4NCj4+
Pj4NCj4+Pj4gVW5kZXIgdGhlIGNvbmRpdGlvbnMgaW4gdGhlIGNvZGUsIGlmIENQTCB3ZXJlIDwz
IHRoZW4gdGhlIFNNQVAgZmF1bHQNCj4+Pj4gd291bGQgaGF2ZSBiZWVuIHNlbnQgdG8gdGhlIGd1
ZXN0Lg0KPj4+PiBCdXQgSSBhZ3JlZSB0aGF0IGlmIHdlIG5lZWQgdG8NCj4+Pj4gY2hhbmdlIGl0
IHRvIGNoZWNrIGhvc3QgQ1I0LCB0aGVuIHRoZSBDUEwgb2YgdGhlIGd1ZXN0IHNob3VsZCBub3Qg
YmUNCj4+Pj4gY2hlY2tlZC4NCj4+Pg0KPj4+IFllcC4NCj4+PiBXZWxsIGl0IGFsbCBkZXBlbmRz
IG9uIGhvdyBBTUQgQ1BVIGFjdHVhbGx5IHdvcmtzLg0KPj4+IFdlIG5lZWQgc29tZSBjbGFyaWZp
Y2F0aW9uIGZyb20gQU1EIGJ1dCBmb3Igc3VyZSB0aGUgY3VycmVudCBjb2RlIGluIEtWTSBpcyBu
b3Qgb25seSB3cm9uZywgYnV0IHByb2JhYmx5IGhhdmUgbmV2ZXIgYmVlbiB0ZXN0ZWQuIDpQDQo+
Pj4NCj4+PiBMb29raW5nIGZvciBmdXJ0aGVyIGNsYXJpZmljYXRpb25zIGZyb20gQU1EIGJlZm9y
ZSBzdWJtaXR0aW5nIHYy4oCmDQo+Pj4NCj4+DQo+PiBXaGVuIHRoaXMgZXJyYXRhIGlzIGhpdCwg
dGhlIENQVSB3aWxsIGJlIGF0IENQTDMuIEZyb20gaGFyZHdhcmUNCj4+IHBvaW50LW9mLXZpZXcg
dGhlIGJlbG93IHNlcXVlbmNlIGhhcHBlbnM6DQo+Pg0KPj4gMS4gQ1BMMyBndWVzdCBoaXRzIHJl
c2VydmVkIGJpdCBOUFQgZmF1bHQgKE1NSU8gYWNjZXNzKQ0KPiANCj4gV2h5IENQVSBuZWVkcyB0
byBiZSBhdCBDUEwzPw0KPiBUaGUgcmVxdWlyZW1lbnQgZm9yIFNNQVAgc2hvdWxkIGJlIHRoYXQg
dGhpcyBwYWdlIGlzIHVzZXItYWNjZXNzaWJsZSBpbiBndWVzdCBwYWdlLXRhYmxlcy4NCj4gVGhp
bmsgb24gYSBjYXNlIHdoZXJlIGd1ZXN0IGhhdmUgQ1I0LlNNQVA9MSBhbmQgQ1I0LlNNRVA9MC4N
Cj4gDQoNCldlIGFyZSBkaXNjdXNzaW5nIHJlc2VydmVkIE5QRiBzbyB3ZSBuZWVkIHRvIGJlIGF0
IENQTDMuDQoNCj4+DQo+PiAyLiBNaWNyb2NvZGUgdXNlcyBzcGVjaWFsIG9wY29kZSB3aGljaCBh
dHRlbXB0cyB0byByZWFkIGRhdGEgdXNpbmcgdGhlDQo+PiBDUEwwIHByaXZpbGVnZXMuIFRoZSBt
aWNyb2NvZGUgcmVhZCBDUzpSSVAsIHdoZW4gaXQgaGl0cyBTTUFQIGZhdWx0LA0KPj4gaXQgZ2l2
ZXMgdXAgYW5kIHJldHVybnMgbm8gaW5zdHJ1Y3Rpb24gYnl0ZXMuDQo+Pg0KPj4gKE5vdGU6IHZD
UFUgaXMgc3RpbGwgYXQgQ1BMMykNCj4gDQo+IFNvIGF0IHRoaXMgcG9pbnQgZ3Vlc3QgdkNQVSBD
UjQuU01BUCBpcyB3aGF0IG1hdHRlcnMgcmlnaHQ/IE5vdCBob3N0IENSNC5TTUFQLg0KPiANCg0K
WWVzLCBpdHMgZ3Vlc3QgdkNQVSBTTUFQLg0KDQo+Pg0KPj4gMy4gQ1BVIGNhdXNlcyAjVk1FWElU
IGZvciBvcmlnaW5hbCBmYXVsdCBhZGRyZXNzLg0KPj4NCj4+IFRoZSBTTUFQIGZhdWx0IG9jY3Vy
cmVkIHdoaWxlIHdlIGFyZSBzdGlsbCBpbiBndWVzdCBjb250ZXh0LiBJdCB3aWxsIGJlDQo+PiBu
aWNlIHRvIGhhdmUgY29kZSB0ZXN0IGV4YW1wbGUgdG8gdHJpZ2dlcnMgdGhpcyBlcnJhdGEuDQo+
IA0KPiBJIGNhbiB3cml0ZSBzdWNoIGNvZGUgaW4ga3ZtLXVuaXQtdGVzdHMgZm9yIHlvdSB0byBy
dW4gb24gcmVsZXZhbnQgaGFyZHdhcmUgaWYgeW91IGhhdmUgc3VjaCBhIG1hY2hpbmUgcHJlc2Vu
dC4NCj4gSSBkb27igJl0IGhhdmUgcmVsZXZhbnQgbWFjaGluZSB3aXRoIG1lIGFuZCB0aGVyZWZv
cmUgSSB3cm90ZSBhIGRpc2NsYWltZXIgSSBjb3VsZG7igJl0IHRlc3QgaXQgaW4gY292ZXIgbGV0
dGVyLg0KPiANCg0KSSBoYXZlIHJlcXVpcmVkIGhhcmR3YXJlIGFuZCBzaG91bGQgYmUgYWJsZSB0
byBydW4gc29tZSB0ZXN0IGZvciB5b3UuDQoNCj4gU28gdG8gc3VtLXVwIHdoYXQgS1ZNIG5lZWRz
IHRvIGRvOg0KPiAxKSBDaGVjayBndWVzdCB2Q1BVIENSNC5TTUFQIGlzIHNldCB0byAxLiAoQXMg
SSBmaXhlZCBpbiB0aGlzIGNvbW1pdCkuDQo+IDIpIFJlbW92ZSB0aGUgY2hlY2sgZm9yIENQTD09
My4gSWYgd2UgcmVhbGx5IHdhbnQgdG8gYmUgcGVkYW50aWMsIHdlIGNhbiBwYXJzZSBndWVzdCBw
YWdlLXRhYmxlcyB0byBzZWUgaWYgUFRFIGhhdmUgVS9TIGJpdCBzZXQgdG8gMS4NCg0KDQpSZW1l
bWJlciBpbiB0aGUgY2FzZSBvZiBTRVYgZ3Vlc3QsIHRoZSBwYWdlLXRhYmxlcyBhcmUgZW5jcnlw
dGVkIHdpdGgNCnRoZSBndWVzdCBzcGVjaWZpYyBrZXkgYW5kIHdlIHdpbGwgbm90IGJlIGFibGUg
dG8gd2FsayBpdCB0byBpbnNwZWN0DQp0aGUgVS9TIGJpdC4gV2Ugd2FudCB0byBkZXRlY3QgdGhl
IGVycmF0YSBhbmQgaWYgaXRzIFNFViBndWVzdCB0aGVuDQp3ZSBjYW4ndCBkbyBtdWNoLCBmb3Ig
bm9uLVNFViBmYWxsYmFjayB0byBpbnN0cnVjdGlvbiBkZWNvZGUgd2hpY2gNCndpbGwgd2FsayB0
aGUgZ3Vlc3QgcGFnZS10YWJsZXMgdG8gZmV0Y2ggdGhlIGluc3RydWN0aW9uIGJ5dGVzLg0KDQoN
Cj4gV2hhdCBkbyB5b3UgdGhpbms/DQo+IA0KPiAtTGlyYW4NCj4gDQo+Pg0KPj4+IC1MaXJhbg0K
Pj4+DQo+Pj4+DQo+Pj4+IFBhb2xvDQo+Pj4+DQo+Pj4+PiBJdOKAmXMgb25seSBpbXBvcnRhbnQg
dGhhdCBndWVzdCBwYWdlLXRhYmxlcyBtYXBzIHRoZSBndWVzdCBSSVAgYXMgdXNlci1hY2Nlc3Np
YmxlLiBpLmUuIFUvUyBiaXQgaW4gUFRFIHNldCB0byAxLg0KPj4+Pg0KPj4+DQo+IA0K
