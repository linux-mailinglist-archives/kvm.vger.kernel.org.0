Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 678E36B068
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2019 22:27:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728781AbfGPU1P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jul 2019 16:27:15 -0400
Received: from mail-eopbgr700052.outbound.protection.outlook.com ([40.107.70.52]:27681
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728340AbfGPU1P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jul 2019 16:27:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MjQwj/p98OxstgAVAHE6sNa2HSkdLmkG6UA2jy7Ri+fDnvYBQ63kWQ+jJb2A0Ijvo3ml5u81kQrq2rw/GNzGSTBIh8qkRnuEvFEW2tuV4zbznW9pxQmLMXRetIQCV9W5SjaT4S7lHg1ZPEErTE47bBeI9+dZgsMh4F1eGJNViyt/oFXCT7+suxZwOTS/GwCxarVSvZtYQwTGxaG2ov7aX5zCmJLts+t7ZJf9gdMnXXawjCcBeA0NGt2GYYMxXd0BM2GdFnTPS5WNZfQbh+87w7qZXv6b//++2Df4uLDjnlV8YgN7vvd290+BuYr9CQd03acHdues+EMKWkSjGLHY/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oLWoskOWGL8aq6K5HWhBDhXmJl6A5+xeeGItp/Fo6zM=;
 b=YMiEQgWJ8G/vuw9V9peXMWmIm3APfpUNE1XI2SX4TtUlyHO/8dZjDDivdxMTmLKCrl2EdtxZs1zqiraDKCI255D1pECkzeKbSWGfUdqmT0DuR8k8gavWXPn1d0L6KOm/e1NaJjt4G2PRsuefL3gbuMcB9KMoaWQGskEJT7snE4RLWKc/xyhj0yfZWLQSuf2Qh/tV0+t1RvA4aQ0pIykx03O5sCm7puCz02IIvftYbSCmHC7T2ap2C4nJ7Al9ZdO0LhHHPbtoJXZ/8dexcuBfhM5we3NBFnK9RHPBdsxtSdqerFePlNRSqaQu+ErEzmMoexKl1olcF8ZoonWRzuhjeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=amd.com;dmarc=pass action=none header.from=amd.com;dkim=pass
 header.d=amd.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oLWoskOWGL8aq6K5HWhBDhXmJl6A5+xeeGItp/Fo6zM=;
 b=ZI44WC+tMvUVS6elFClCUK8hurrVzDhQSmrgt62Loj2u8YiyVm0kLP7tnI1JrySHMnThZL3MFYyl5pUeZRUSc1RLZvp9TxXTj/Dj4JMpSU7rhuCeZRbtdh/CRiE/dg5cZeP3ujsCOuiHGxvdSu5XWIDbtDMkErX+EMD3AyJG/p0=
Received: from DM6PR12MB2682.namprd12.prod.outlook.com (20.176.118.13) by
 DM6PR12MB3116.namprd12.prod.outlook.com (20.178.31.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.10; Tue, 16 Jul 2019 20:27:12 +0000
Received: from DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::7439:ea87:cc5d:71]) by DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::7439:ea87:cc5d:71%7]) with mapi id 15.20.2073.012; Tue, 16 Jul 2019
 20:27:12 +0000
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
Thread-Index: AQHVO0w5JJR7Enn+ZEGfnHG07AdKnabMIb8AgAFDlACAAAIYgIAAA+gAgAAC6ACAAAXogIAABBmAgAAInwCAAAJiAIAAH44AgAABewCAAAf7AIAAAd6AgAAE+AA=
Date:   Tue, 16 Jul 2019 20:27:12 +0000
Message-ID: <17d102bd-74ef-64f8-0237-3a49d64ea344@amd.com>
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
 <31926848-2cf3-caca-335d-5f3e32a25cd3@amd.com>
 <AAAE41B2-C920-46E5-A171-46428E53FB20@oracle.com>
In-Reply-To: <AAAE41B2-C920-46E5-A171-46428E53FB20@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN6PR01CA0010.prod.exchangelabs.com (2603:10b6:805:b6::23)
 To DM6PR12MB2682.namprd12.prod.outlook.com (2603:10b6:5:42::13)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=brijesh.singh@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.77.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c08ce4f2-9157-42a5-d6c7-08d70a2bfbc1
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB3116;
x-ms-traffictypediagnostic: DM6PR12MB3116:
x-microsoft-antispam-prvs: <DM6PR12MB31169A65B0ED32847748214CE5CE0@DM6PR12MB3116.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0100732B76
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(396003)(366004)(376002)(39860400002)(189003)(199004)(81166006)(14454004)(66556008)(64756008)(66446008)(2906002)(71200400001)(71190400001)(6436002)(229853002)(68736007)(8936002)(316002)(86362001)(31696002)(4744005)(6486002)(36756003)(54906003)(52116002)(305945005)(76176011)(3846002)(11346002)(476003)(2616005)(486006)(6506007)(6116002)(26005)(102836004)(186003)(53936002)(25786009)(99286004)(8676002)(6246003)(81156014)(66476007)(478600001)(256004)(446003)(66066001)(4326008)(6512007)(14444005)(66946007)(6916009)(5660300002)(53546011)(7736002)(386003)(31686004);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3116;H:DM6PR12MB2682.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: LVVyJN5pUgP5TV4kyQzx/C1Lr/bUrJPqZl5smJl5m+0w+fdNJ9v/OPhiy9QAWl8DPWRJP3YOfMq/CQa+CaQn1eAlKXDX2kHbpOisiTodN6tLBfo7qgW8gEy/1VyReeQI2gzOZ/uhn02nbhG9K6xxRKDPT8LJwP57wy6iGAgHj5DMOrvQz0SHBGFwmAz2iFvNU+CKrWqo8T1mEJrOeatgtl96lEN7w/3BcvBnpRn18l3QnNzv71zP7nYNRUhWltZLl8/tS1wfs9TggMe1YGjM9lsRDV1jB8E0su8ML79XC1ykRT9MQzB696AqN2Y8NBk3IWtzgoUWWKlwAyrOSmKCHo33Tx9Qowr1sLEioWz37DaktyEnRS3Eiws96CSskUpALZFkRoV0aNvuTJIL0CIaydsIyX2TWBRT6uSowcEftcE=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7F2A233C30CAB447B86AA5A7950977DF@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c08ce4f2-9157-42a5-d6c7-08d70a2bfbc1
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jul 2019 20:27:12.1779
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sbrijesh@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3116
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCk9uIDcvMTYvMTkgMzowOSBQTSwgTGlyYW4gQWxvbiB3cm90ZToNCi4uLg0KDQoNCj4+DQo+
PiBXZSBhcmUgZGlzY3Vzc2luZyByZXNlcnZlZCBOUEYgc28gd2UgbmVlZCB0byBiZSBhdCBDUEwz
Lg0KPiANCj4gSSBkb27igJl0IHNlZSB0aGUgY29ubmVjdGlvbiBiZXR3ZWVuIGEgcmVzZXJ2ZWQg
I05QRiBhbmQgdGhlIG5lZWQgdG8gYmUgYXQgQ1BMMy4NCj4gQSB2Q1BVIGNhbiBleGVjdXRlIGF0
IENQTDwzIGEgcGFnZSB0aGF0IGlzIG1hcHBlZCB1c2VyLWFjY2Vzc2libGUgaW4gZ3Vlc3QgcGFn
ZS10YWJsZXMgaW4gY2FzZSBDUjQuU01FUD0wDQo+IGFuZCB0aGVuIGluc3RydWN0aW9uIHdpbGwg
ZXhlY3V0ZSBzdWNjZXNzZnVsbHkgYW5kIGNhbiBkZXJlZmVyZW5jZSBhIHBhZ2UgdGhhdCBpcyBt
YXBwZWQgaW4gTlBUIHVzaW5nIGFuIGVudHJ5IHdpdGggYSByZXNlcnZlZCBiaXQgc2V0Lg0KPiBU
aHVzLCByZXNlcnZlZCAjTlBGIHdpbGwgYmUgcmFpc2VkIHdoaWxlIHZDUFUgaXMgYXQgQ1BMPDMg
YW5kIERlY29kZUFzc2lzdCBtaWNyb2NvZGUgd2lsbCBzdGlsbCByYWlzZSBTTUFQIHZpb2xhdGlv
bg0KPiBhcyBDUjQuU01BUD0xIGFuZCBtaWNyb2NvZGUgcGVyZm9ybSBkYXRhLWZldGNoIHdpdGgg
Q1BMPDMuIFRoaXMgbGVhZGluZyBleGFjdGx5IHRvIEVycmF0YSBjb25kaXRpb24gYXMgZmFyIGFz
IEkgdW5kZXJzdGFuZC4NCj4gDQoNClllcywgdkNQVSBhdCBDUEw8MyBjYW4gcmFpc2UgdGhlIFNN
QVAgdmlvbGF0aW9uLiBXaGVuIFNNRVAgaXMgZGlzYWJsZWQsDQp0aGUgZ3Vlc3Qga2VybmVsIG5l
dmVyIHNob3VsZCBiZSBleGVjdXRpbmcgZnJvbSBjb2RlIGluIHVzZXItbW9kZSBwYWdlcywNCnRo
YXQnZCBiZSBpbnNlY3VyZS4gU28gSSBhbSBub3Qgc3VyZSBpZiBrZXJuZWwgY29kZSBjYW4gY2F1
c2UgdGhpcw0KZXJyYXRhLiBIYXZpbmcgc2FpZCBzbywgSSdtIE9LIHRvIHJlbW92ZSB0aGUgQ1BM
IGNoZWNrIGlmIGl0IG1ha2VzIGNvZGUNCm1vcmUgcmVhZGFibGUuDQoNCi1CcmlqZXNoDQo=
