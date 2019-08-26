Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 453D29D6EB
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2019 21:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730138AbfHZTlq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Aug 2019 15:41:46 -0400
Received: from mail-eopbgr790042.outbound.protection.outlook.com ([40.107.79.42]:21899
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728560AbfHZTlq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Aug 2019 15:41:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gAGeWL0rJqCWqf4FQhAaeQlpplI5pi7M4yVGiKuzyLL0n+gz6G4mkQQNTTdr3lv9H5X0/ECnbe3ejCKzRyKoArrn1ePf+0d+BPUbJL3DjwMMG99j/jKeOFOGrJf07KmYekE6JM+iDJiLgzTWs5F/m6Lpsjo77ziCH6XlmDla4mcsz/pWG2N0FbN4w6TGdFT4QPe41gUiaMQI3UL9ZScfwypLCzheNk7RpyT34cawYWVhVRgZlLAB7TTG2+Hq33FS+ehwSV1qF+MtiivCYuFoZPUNVP3Yc94dTz1ndTSjyxiyQ7poX6uNq0VcpTOcJiMTeaNvXRkj4nghw1ee2CZvtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dcnv/k2VXrmmXKgR/ELur1uwOaMdlbflHKoIUEoux7A=;
 b=Cd5gSbZD26hEq9l5H71YYeCSpCsjcEXdmxbzHAjivWTFiAFiF1iIsOvEdHpaDOwYZl5fB2X6P3KTWow2BZ8wLINfXoszgdLGlSSd/GFEDr8KANtR0gCtgC720NsInOtWjGA9x/6eYXwJh/FEutZXKb7hwI4shdvIdokMdjevapDshnYRwseXmfereL1y4p6aaGeXUpwfd+wjP36jvJnOAFmbjFWRbfZbItkOLMYRBPeYjZvFnc1x+2phKt/inK1sfQCghhcloS58zbPRZgUqQMkKkFWSYYA3/ZdpF3ImZY9rNCchntb0o9nvathwQlKTX0skBsvH/PYN7iBmLiiJ1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dcnv/k2VXrmmXKgR/ELur1uwOaMdlbflHKoIUEoux7A=;
 b=AFu1dOTev0zDHIAqkDxuApK8+ui1EYa4PSV0xJGjK/Xpy9775Toq8hKRK8XHU83+uzvaNizTyuhceMA3WAfrcTv7japaLSrB1CvhozdL1yohhiA6GsCbqD7dacDHBJVO92MW+NxfnShtI+dW7/D/vcGjstnBXMApqhP/zOYQa7s=
Received: from DM6PR12MB2844.namprd12.prod.outlook.com (20.176.117.96) by
 DM6PR12MB3996.namprd12.prod.outlook.com (10.255.175.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.19; Mon, 26 Aug 2019 19:41:40 +0000
Received: from DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::e95a:d3ee:e6a0:2825]) by DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::e95a:d3ee:e6a0:2825%7]) with mapi id 15.20.2178.023; Mon, 26 Aug 2019
 19:41:40 +0000
From:   "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
To:     Alexander Graf <graf@amazon.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jschoenh@amazon.de" <jschoenh@amazon.de>,
        "karahmed@amazon.de" <karahmed@amazon.de>,
        "rimasluk@amazon.com" <rimasluk@amazon.com>,
        "Grimm, Jon" <Jon.Grimm@amd.com>
Subject: Re: [PATCH v2 04/15] kvm: x86: Add per-VM APICv state debugfs
Thread-Topic: [PATCH v2 04/15] kvm: x86: Add per-VM APICv state debugfs
Thread-Index: AQHVU4YAxicok8C98kOOsiSZW3JVFacCQeaAgAujmoA=
Date:   Mon, 26 Aug 2019 19:41:39 +0000
Message-ID: <049c0f98-bd89-ee3c-7869-92972f2d7c31@amd.com>
References: <1565886293-115836-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1565886293-115836-5-git-send-email-suravee.suthikulpanit@amd.com>
 <a48080a5-7ece-280d-2c1f-9d3f4c273a8d@amazon.com>
In-Reply-To: <a48080a5-7ece-280d-2c1f-9d3f4c273a8d@amazon.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
x-originating-ip: [165.204.77.1]
x-clientproxiedby: SN4PR0501CA0006.namprd05.prod.outlook.com
 (2603:10b6:803:40::19) To DM6PR12MB2844.namprd12.prod.outlook.com
 (2603:10b6:5:45::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: db8ee638-1864-4246-837e-08d72a5d6a34
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB3996;
x-ms-traffictypediagnostic: DM6PR12MB3996:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB3996C315EB4186C283BAA223F3A10@DM6PR12MB3996.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 01415BB535
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(396003)(39860400002)(376002)(346002)(199004)(189003)(316002)(446003)(4744005)(6246003)(478600001)(6512007)(31686004)(2906002)(71190400001)(229853002)(54906003)(3846002)(6116002)(58126008)(71200400001)(2616005)(110136005)(11346002)(8676002)(52116002)(81166006)(102836004)(7736002)(8936002)(25786009)(476003)(2501003)(305945005)(26005)(76176011)(256004)(81156014)(53546011)(99286004)(186003)(386003)(6506007)(36756003)(66446008)(64756008)(66556008)(66476007)(4326008)(66946007)(5660300002)(31696002)(65956001)(6486002)(65806001)(66066001)(86362001)(6436002)(486006)(2201001)(14454004)(53936002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3996;H:DM6PR12MB2844.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: znSL0n9PpkUGzIXE/7JfPNbDajV/u/KeOJLdKBpFwjw0DkwS1dTe4pLRPxlAywWz37nOssiV3THi9SQLXQNCH4seGy6Bd8wR0JXofBdPVHJJSCdR2aIc0EsJuDPKQcb/Z8RjssrbDHU6a3VQQCl+0TT2U2yEJySasvr5xhEcdih7OyEdDbl1mEevXEeUUy++jwT1V7ppXTv1Vv30+p6QThnFpRoZ9iQt9SEPDs37L3MgJvh1upSw2juhEGbQbeUsbIqXodb7XV1CMY8ksxENdaOUkdhnQUkQJEZ0keL359dnI4BVH91D2+9KSrLNzCO4HB67WvTenXuHnfBnbsO3er4m9SSGdnWB8t5hUVLFWIyOBcN/OcWzLXYj0WE1UD+hJyekIfT/U5xksDngkYUuV4zhcToNPQQfT5KUAO5HHAk=
Content-Type: text/plain; charset="utf-8"
Content-ID: <15F64B81694D4044B92A946DBD1BCD3D@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db8ee638-1864-4246-837e-08d72a5d6a34
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2019 19:41:40.5082
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r7k6sjMrTGRORM1xSH8k4rWltmPhox8BDgD2CyfFi4bnEmK3ALzZiYwjA5wt9dFJ1VASeKJ43QflIHxCUwh1CA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3996
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

QWxleCwNCg0KT24gOC8xOS8yMDE5IDQ6NTcgQU0sIEFsZXhhbmRlciBHcmFmIHdyb3RlOg0KPiAN
Cj4gDQo+IE9uIDE1LjA4LjE5IDE4OjI1LCBTdXRoaWt1bHBhbml0LCBTdXJhdmVlIHdyb3RlOg0K
Pj4gQ3VycmVudGx5LCB0aGVyZSBpcyBubyB3YXkgdG8gdGVsbCB3aGV0aGVyIEFQSUN2IGlzIGFj
dGl2ZQ0KPj4gb24gYSBwYXJ0aWN1bGFyIFZNLiBUaGlzIG9mdGVuIGNhdXNlIGNvbmZ1c2lvbiBz
aW5jZSBBUElDdg0KPj4gY2FuIGJlIGRlYWN0aXZhdGVkIGF0IHJ1bnRpbWUuDQo+Pg0KPj4gSW50
cm9kdWNlIGEgZGVidWdmcyBlbnRyeSB0byByZXBvcnQgQVBJQ3Ygc3RhdGUgb2YgYSBWTS4NCj4+
IFRoaXMgY3JlYXRlcyBhIHJlYWQtb25seSBmaWxlOg0KPj4NCj4+IMKgwqDCoCAvc3lzL2tlcm5l
bC9kZWJ1Zy9rdm0vNzA4NjAtMTQvYXBpY3Ytc3RhdGUNCj4+DQo+PiBTaWduZWQtb2ZmLWJ5OiBT
dXJhdmVlIFN1dGhpa3VscGFuaXQgPHN1cmF2ZWUuc3V0aGlrdWxwYW5pdEBhbWQuY29tPg0KPiAN
Cj4gU2hvdWxkbid0IHRoaXMgZmlyc3QgYW5kIGZvcmVtb3N0IGJlIGEgVk0gaW9jdGwgc28gdGhh
dCB1c2VyIHNwYWNlIGNhbiBpbnF1aXJlIGl0cyBvd24gc3RhdGU/DQo+IA0KPiANCj4gQWxleA0K
DQpJIGludHJvZHVjZSB0aGlzIG1haW5seSBmb3IgZGVidWdnaW5nIHNpbWlsYXIgdG8gaG93IEtW
TSBpcyBjdXJyZW50bHkgcHJvdmlkZXMNCnNvbWUgcGVyLVZDUFUgaW5mb3JtYXRpb246DQoNCiAg
ICAgL3N5cy9rZXJuZWwvZGVidWcva3ZtLzE1OTU3LTE0L3ZjcHUwLw0KICAgICAgICAgbGFwaWNf
dGltZXJfYWR2YW5jZV9ucw0KICAgICAgICAgdHNjLW9mZnNldA0KICAgICAgICAgdHNjLXNjYWxp
bmctcmF0aW8NCiAgICAgICAgIHRzYy1zY2FsaW5nLXJhdGlvLWZyYWMtYml0cw0KDQpJJ20gbm90
IHN1cmUgaWYgdGhpcyBuZWVkcyB0byBiZSBWTSBpb2N0bCBhdCB0aGlzIHBvaW50LiBJZiB0aGlz
IGluZm9ybWF0aW9uIGlzDQp1c2VmdWwgZm9yIHVzZXItc3BhY2UgdG9vbCB0byBpbnF1aXJlIHZp
YSBpb2N0bCwgd2UgY2FuIGFsc28gcHJvdmlkZSBpdC4NCg0KVGhhbmtzLA0KU3VyYXZlZQ0K
