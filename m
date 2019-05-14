Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0958F1CC43
	for <lists+kvm@lfdr.de>; Tue, 14 May 2019 17:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbfENPwL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 May 2019 11:52:11 -0400
Received: from mail-eopbgr820070.outbound.protection.outlook.com ([40.107.82.70]:49432
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725916AbfENPwL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 May 2019 11:52:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amd-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EmW+u8Pr0LB9YtbOQ/lGTDz63206JAT2zpJymOaTIZE=;
 b=uEw13o1NCtKN24JooA03TZCdOXsH5p/vV7uqfJ4uLBCz7Gboyl06mFfVPZFLYTwKIw05QseJRkChOXF0IkAerZnNdJ5J/36kTuUwcuFTYWevo4xqFCriay96gsvedsMGGi+rc6YDX2krotdrim3sx/PQAyhTOwnPxkdWNpSgwjM=
Received: from DM6PR12MB2844.namprd12.prod.outlook.com (20.176.117.96) by
 DM6PR12MB3004.namprd12.prod.outlook.com (20.178.29.209) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.25; Tue, 14 May 2019 15:52:08 +0000
Received: from DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::edb0:d696:3077:51bc]) by DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::edb0:d696:3077:51bc%2]) with mapi id 15.20.1878.024; Tue, 14 May 2019
 15:52:08 +0000
From:   "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
To:     "Graf, Alexander" <graf@amazon.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>
Subject: Re: [PATCH] svm/avic: Do not send AVIC doorbell to self
Thread-Topic: [PATCH] svm/avic: Do not send AVIC doorbell to self
Thread-Index: AQHVAbWM1dd1RWWcW0KGDe4yNBolwqZfqq2AgAsr2wA=
Date:   Tue, 14 May 2019 15:52:08 +0000
Message-ID: <bf389c60-1e47-80c1-43cc-9211a729b693@amd.com>
References: <1556890721-9613-1-git-send-email-suravee.suthikulpanit@amd.com>
 <ca64dd06-df77-050a-92ff-5d5448382390@amazon.com>
In-Reply-To: <ca64dd06-df77-050a-92ff-5d5448382390@amazon.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
x-originating-ip: [165.204.78.1]
x-clientproxiedby: SN4PR0501CA0020.namprd05.prod.outlook.com
 (2603:10b6:803:40::33) To DM6PR12MB2844.namprd12.prod.outlook.com
 (2603:10b6:5:45::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 37ff25fd-c45c-4f89-b584-08d6d8841e63
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB3004;
x-ms-traffictypediagnostic: DM6PR12MB3004:
x-microsoft-antispam-prvs: <DM6PR12MB30049AE7D57D5631B3937905F3080@DM6PR12MB3004.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1186;
x-forefront-prvs: 0037FD6480
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(136003)(376002)(39860400002)(396003)(366004)(189003)(199004)(52116002)(14454004)(65826007)(76176011)(6512007)(86362001)(2906002)(2201001)(25786009)(7736002)(305945005)(4326008)(3846002)(6246003)(31696002)(53936002)(64126003)(65956001)(65806001)(66066001)(6116002)(53546011)(186003)(476003)(2616005)(58126008)(54906003)(99286004)(316002)(446003)(6436002)(486006)(6486002)(26005)(2501003)(102836004)(386003)(31686004)(6506007)(110136005)(68736007)(72206003)(66946007)(73956011)(36756003)(66476007)(5660300002)(66446008)(64756008)(66556008)(229853002)(256004)(8676002)(81156014)(8936002)(11346002)(81166006)(71200400001)(71190400001)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3004;H:DM6PR12MB2844.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: WzpWXKruLSjA2a12BkBBnJ+9JeYWMEorXlZ7sduuoTpVEVgxWiJk/2pAsOQYzifRLT6LuPJoPldjoJ1VUSFRw3g0DbIP9FCZkagFbqXmwICOlxGqc/DdP2iakXCRnLlrkbHn89/IC7+lxcuLEHufIYi3osmpmfmLPuLEAaIzVYHYyfH1XDmV5i4wFhJAFEyR6CJBWzakldtFgiibWulnHJ18kR+4karWkgwg6Y3F08kk7E/4mwW57xiPM+gKPw/fBXNr/ahmce94qjzuiK7IbXj/mnnw8whsTwi9X30WW9lXrUF4HUzwzhC7Z8sIDTwbQYA7mJmgw2cGqT4FlSd5DbDR7i6NsLr0jNL2oU9vvtHDwX6+baMuM2h9QLxTekoHjljVoyn0C81CJtGevC7odjhtMUHv65kayVifEkP6gHM=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2485C81F5FB50647BC8569080C342F1C@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37ff25fd-c45c-4f89-b584-08d6d8841e63
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 May 2019 15:52:08.1441
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3004
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

QWxleCwNCg0KT24gNS83LzIwMTkgODoxNiBBTSwgR3JhZiwgQWxleGFuZGVyIHdyb3RlOg0KPiBb
Q0FVVElPTjrCoEV4dGVybmFswqBFbWFpbF0NCj4gDQo+IE9uwqAwMy4wNS4xOcKgMTU6MzgswqBT
dXRoaWt1bHBhbml0LMKgU3VyYXZlZcKgd3JvdGU6DQo+PiBBVklDwqBkb29yYmVsbMKgaXPCoHVz
ZWTCoHRvwqBub3RpZnnCoGHCoHJ1bm5pbmfCoHZDUFXCoHRoYXTCoGludGVycnVwdHMNCj4+IGhh
c8KgYmVlbsKgaW5qZWN0ZWTCoGludG/CoHRoZcKgdkNQVcKgQVZJQ8KgYmFja2luZ8KgcGFnZS7C
oEN1cnJlbnTCoGxvZ2ljDQo+PiBjaGVja3PCoG9ubHnCoGlmwqBhwqBWQ1BVwqBpc8KgcnVubmlu
Z8KgYmVmb3JlwqBzZW5kaW5nwqBhwqBkb29yYmVsbC4NCj4+IEhvd2V2ZXIswqB0aGXCoGRvb3Ji
ZWxswqBpc8Kgbm90wqBuZWNlc3NhcnnCoGlmwqB0aGXCoGRlc3RpbmF0aW9uDQo+PiBDUFXCoGlz
wqBpdHNlbGYuDQo+Pg0KPj4gQWRkwqBsb2dpY8KgdG/CoGNoZWNrwqBjdXJyZW50bHnCoHJ1bm5p
bmfCoENQVcKgYmVmb3JlwqBzZW5kaW5nwqBkb29yYmVsbC4NCj4+DQo+PiBTaWduZWQtb2ZmLWJ5
OsKgU3VyYXZlZcKgU3V0aGlrdWxwYW5pdCA8c3VyYXZlZS5zdXRoaWt1bHBhbml0QGFtZC5jb20+
DQo+IA0KPiBSZXZpZXdlZC1ieTrCoEFsZXhhbmRlcsKgR3JhZiA8Z3JhZkBhbWF6b24uY29tPg0K
DQpUaGFua3MuDQoNCj4+IC0tLQ0KPj4gwqDCoGFyY2gveDg2L2t2bS9zdm0uY8KgfMKgMTHCoCsr
KysrKystLS0tDQo+PiDCoMKgMcKgZmlsZcKgY2hhbmdlZCzCoDfCoGluc2VydGlvbnMoKykswqA0
wqBkZWxldGlvbnMoLSkNCj4+DQo+PiBkaWZmwqAtLWdpdMKgYS9hcmNoL3g4Ni9rdm0vc3ZtLmPC
oGIvYXJjaC94ODYva3ZtL3N2bS5jDQo+PiBpbmRleMKgMTIyNzg4Zi4uNGJiZjZmY8KgMTAwNjQ0
DQo+PiAtLS3CoGEvYXJjaC94ODYva3ZtL3N2bS5jDQo+PiArKyvCoGIvYXJjaC94ODYva3ZtL3N2
bS5jDQo+PiBAQMKgLTUyODMsMTDCoCs1MjgzLDEzwqBAQMKgc3RhdGljwqB2b2lkwqBzdm1fZGVs
aXZlcl9hdmljX2ludHIoc3RydWN0wqBrdm1fdmNwdcKgKnZjcHUswqBpbnTCoHZlYykNCj4+IMKg
wqDCoMKgwqDCoGt2bV9sYXBpY19zZXRfaXJyKHZlYyzCoHZjcHUtPmFyY2guYXBpYyk7DQo+PiDC
oMKgwqDCoMKgwqBzbXBfbWJfX2FmdGVyX2F0b21pYygpOw0KPj4NCj4+IC3CoMKgwqDCoMKgaWbC
oChhdmljX3ZjcHVfaXNfcnVubmluZyh2Y3B1KSkNCj4+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoHdybXNybChTVk1fQVZJQ19ET09SQkVMTCwNCj4+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKga3ZtX2NwdV9nZXRfYXBpY2lkKHZjcHUtPmNwdSkpOw0KPj4gLcKg
wqDCoMKgwqBlbHNlDQo+PiArwqDCoMKgwqDCoGlmwqAoYXZpY192Y3B1X2lzX3J1bm5pbmcodmNw
dSkpwqB7wqA+wqArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGludMKgY3B1aWTCoD3CoHZjcHUtPmNw
dTsNCj4+ICsNCj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlmwqAoY3B1aWTCoCE9wqBn
ZXRfY3B1KCkpDQo+IA0KPiBUaW55wqBuaXRwaWNrOsKgV2hhdMKgd291bGTCoGtlZXDCoHlvdcKg
ZnJvbcKgY2hlY2tpbmfCoHZjcHUtPmNwdcKgZGlyZWN0bHnCoGhlcmU/DQoNCk5vdGhpbmcuIEp1
c3QgY29kaW5nIHN0eWxlLg0KDQpUaGFua3MsDQpTdXJhdmVlDQo=
