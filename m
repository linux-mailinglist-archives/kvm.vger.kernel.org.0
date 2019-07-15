Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8706268A87
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2019 15:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730213AbfGON2W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jul 2019 09:28:22 -0400
Received: from mail-eopbgr710089.outbound.protection.outlook.com ([40.107.71.89]:58430
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730172AbfGON2W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jul 2019 09:28:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XO8dQbpMa0G9OUd7t/m+1STTmQ7vOKDvQP7K9j1fRKozH63GYRL1pYoCFaPC+PiUiUWgVEdTHYTDn8k95gykshuM6PJBvzw7fORKIxmf7gsalYKPeptzxT6k10uGH9GdLBCM5M6xz+NfkMEmI5Fs+5hnMJI5DAy7w9/CgRlUReX5OI2/PwjBSQ6BZcH6P6ASkZ3081QHHc0PdDt+1zTgzJCjR/T6xW/CectG6NdSKAIShAMEb9/2dX2adeKhhXo0i4Hj9HzziQKpSph1Odmb6tXNod7cDYr9Kz/h39Erka3xw8C/82WkXga2UNoa6u9V8r1aKQ7v6TwiZvXYAOgD0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mq4tlHzm3ZKTw9qsVuJUrzSckDhxg8O2Twr38acOtWk=;
 b=TcHbmzsZACUAc4DYBxDgp4XFUzjdzQDLUmjZmd8k73wulds8uzQBFHk6Vt6zlzJz1gZnUeeK4XGoqqmIJd541I4nG+DgySLVpzBKXCwo5SQp5M52HJLueH2aGTvuqVutY/ekiJ50cUcFo91wNl0+h8Otr6MxOKKMmAWWx4yLWRPWgihfuXAFjO5/lY50iCauBbnmF6Q7CSLoxsYGrWEkyYcIOYwJc5SV/kNJI85DHMnXm6Fw463pytK8kKFMML3zofEkJNtvE2TXKnWMKnLji2GZWDiUu3jrpDJ13PaI5yPWbbB/ScTAmhOBHbXcZ648x+1kArN7ChhKVZIbaBmNKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=amd.com;dmarc=pass action=none header.from=amd.com;dkim=pass
 header.d=amd.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mq4tlHzm3ZKTw9qsVuJUrzSckDhxg8O2Twr38acOtWk=;
 b=U+aUbELP+08kaXHgbFzEK0BINr2vnov2OVzQ6kfVdruJ43p/Dty/5Yb5SJndudln5Gpcyl6lhC0kdWyWeteERN1FOtsilbQxNh3Aru7085vdpO28fb4WFgBi9Vf32bPaZ/FU9q3pmpxGTE0T1Ntr+925gpp6+4hgPVNlEqLMgzg=
Received: from DM6PR12MB3163.namprd12.prod.outlook.com (20.179.104.150) by
 DM6PR12MB3994.namprd12.prod.outlook.com (10.255.175.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.10; Mon, 15 Jul 2019 13:28:19 +0000
Received: from DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::9c3d:8593:906c:e4f7]) by DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::9c3d:8593:906c:e4f7%6]) with mapi id 15.20.2073.012; Mon, 15 Jul 2019
 13:28:19 +0000
From:   "Lendacky, Thomas" <Thomas.Lendacky@amd.com>
To:     Christoph Hellwig <hch@infradead.org>,
        Halil Pasic <pasic@linux.ibm.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Thiago Jung Bauermann <bauerman@linux.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH 1/1] s390/protvirt: restore force_dma_unencrypted()
Thread-Topic: [PATCH 1/1] s390/protvirt: restore force_dma_unencrypted()
Thread-Index: AQHVOw+4rDn9YtKGU0COMSucJynHjabLqgKAgAACLwA=
Date:   Mon, 15 Jul 2019 13:28:19 +0000
Message-ID: <7e393b48-4165-e1d4-0450-e52dd914a3cd@amd.com>
References: <20190715131719.100650-1-pasic@linux.ibm.com>
 <20190715132027.GA18357@infradead.org>
In-Reply-To: <20190715132027.GA18357@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN4PR0501CA0053.namprd05.prod.outlook.com
 (2603:10b6:803:41::30) To DM6PR12MB3163.namprd12.prod.outlook.com
 (2603:10b6:5:182::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.77.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ba1ef297-8674-41f7-fdba-08d709284cf6
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB3994;
x-ms-traffictypediagnostic: DM6PR12MB3994:
x-microsoft-antispam-prvs: <DM6PR12MB3994EC071383F0C67C16F75BECCF0@DM6PR12MB3994.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-forefront-prvs: 00997889E7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(346002)(39860400002)(396003)(366004)(199004)(189003)(31686004)(186003)(14454004)(26005)(102836004)(8936002)(7416002)(99286004)(256004)(5660300002)(64756008)(229853002)(305945005)(68736007)(4744005)(478600001)(81166006)(81156014)(8676002)(66556008)(25786009)(66476007)(66946007)(71200400001)(66446008)(86362001)(66066001)(7736002)(71190400001)(6246003)(11346002)(110136005)(31696002)(476003)(486006)(54906003)(446003)(2616005)(4326008)(316002)(6512007)(76176011)(52116002)(53546011)(6506007)(386003)(53936002)(3846002)(6116002)(2906002)(36756003)(6486002)(6436002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3994;H:DM6PR12MB3163.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: PW25rgAmFMVrgH7+vKtuA0v/AQfedq0qrgrYGEGpqQ0CdQTF/YLfQDSjDfUo/9m3WyXGIJKLRErqMqtFljuYjXv/w90GAJe0nPgdzOwtJ+gauH0lE8cuzc6wwflDzW2RjwHIQqmLhEU4oZGCtJN+DH1q/jNQRCvMNmLVjbcFEPIXsocdvoqSdMmq9ajAX1/JeSfZblVdGhR5UfCdAmo80YqWP8y035pFETJYgMOVlBUP7JLDFkZJxO1C0g3IHMQXc5rxZY+yhCZFkswCCX+IEfeZ2cUDqT1JShZZM8hkNoNxN71X+W2FjrJecthY6xNJZ4z0a86sVQ+2Z1G9U04+UM2R3Wg1MA74XjFWFRbL6jsBHlu9nY+3QyQwCcmQ+nA6Nmahvcmq8YWWcN4rWCUPL+YBjc8/H2v6Y4ZrhIfzEIg=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BD6BC4716FFCF1428F04F1E63D721AB7@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba1ef297-8674-41f7-fdba-08d709284cf6
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2019 13:28:19.3320
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tlendack@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3994
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gNy8xNS8xOSA4OjIwIEFNLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90ZToNCj4gVGhpcyBsb29r
cyBnb29kIHRvIG1lIC0gaWYgeW91IGFuZCBUb20gYXJlIGZpbmUgd2l0aCBpdCBJJ2QgbGlrZSB0
bw0KPiBmb2xkIGl0IGludG8gaGlzIGNvbW1pdCBzbyB0aGF0IHdoYXQgSSdsbCBzZW5kIHRvIExp
bnVzIGlzIGJpc2VjdGlvbg0KPiBjbGVhbi4NCg0KSSdtIG9rIHdpdGggZm9sZGluZyBpdCBpbi4g
U29ycnkgYWJvdXQgbWlzc2luZyB0aGF0Lg0KDQpUaGFua3MsDQpUb20NCg0KPiANCj4+IE5vdGU6
IHdlIHN0aWxsIG5lZWQgc2V2X2FjdGl2ZSgpIGRlZmluZWQgYmVjYXVzZSBvZiB0aGUgcmVmZXJl
bmNlDQo+PiBpbiBmcy9jb3JlL3ZtY29yZSwgYnV0IHRoaXMgb25lIGlzIGxpa2VseSB0byBnbyBh
d2F5IHNvb24gYWxvbmcNCj4+IHdpdGggdGhlIG5lZWQgZm9yIGFuIHMzOTAgc2V2X2FjdGl2ZSgp
Lg0KPiANCj4gQW55IGNoYW5jZSB3ZSBjb3VsZCBub3QgY2hhbmdlIHRoZSByZXR1cm4gdmFsdWUg
ZnJvbSB0aGUgZnVuY3Rpb24NCj4gYXQgbGVhc3QgaW4gdGhpcyBwYXRjaC9mb2xkIGFzIHRoYXQg
Y2hhbmdlIHNlZW1zIHVucmVsYXRlZCB0byB0aGUNCj4gZG1hIGZ1bmN0aW9uYWxpdHkuICBJZiB0
aGF0IGlzIHdoYXQgeW91IHJlYWxseSB3YW50ZWQgYW5kIG9ubHkNCj4gdGhlIGRtYSBjb2RlIHdh
cyBpbiB0aGUgd2F5IHdlIGNhbiBoYXBwaWx5IG1lcmdlIGl0IGFzIGEgc2VwYXJhdGUNCj4gcGF0
Y2gsIG9mIGNvdXNlLg0KPiANCg==
