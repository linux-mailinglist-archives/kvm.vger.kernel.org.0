Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2866AFE9
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2019 21:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728495AbfGPTd7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jul 2019 15:33:59 -0400
Received: from mail-eopbgr750051.outbound.protection.outlook.com ([40.107.75.51]:48966
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726213AbfGPTd6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jul 2019 15:33:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cutQwD2fvE/IDY6D8B5e0+1qga20eBU3aOnTlpu0wxABsFFrPcCxSqirEV8m0SgGX7o99/k2KOePk6IstZikVh1TQGojwH3GyznSM6AfOAjOE7Ct6aZqfSxai99Vnk0m2lEcqxH06JI/sH9XnOfwyS+Ndy8AVlhHcGCwX7RWJ4O3lwSit4VDJCzj4dFYvjdUDNnC+B9NKpJb6WI1JnKyVVYOzvTYWwIYbMLx1KrWgkwDRQCbedcMiv3g1M7yb8bqeu3pr+KdU56MAoPN1qTTD9i72QeS2ZwcCLW0EXVoyJUqwLUWdd46RmwF4/Hnd+18cHFkY4jkrcGsUIwKWMwxpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NUgaomo9wmccwejtpGy80upjwVia6eM7xKxgF4jBbKE=;
 b=IuVDYO3akXmdaTfT3ks+OMrub4yyXFjXPzViqG1woFyVmlpMMAoeGFUY2CnCjPtZkAPvB7HqrP3UTNRAsHT1FGeqIWtnEKly0z+n9n2EA0G24MbuPWnZYkE1yq2zE3AF7QDaOPeSre5wcTjWudbxbyxSGD3ibun42F646sRoA4bV8dmWir/JZgI4nex4iSpNfCknhJ7wVZ1FOGDke+Z7YSN7K5QAnJvOjLzFAfi1RwrkuUNNA6EiCERE14wKa52mJ+8RX/cYRqZAhM/LKnRHi6SPM6b4pjH9+YvSpWUYgDxlNGxsXESuVHFlV65h3SqIAVov70riuwT/eTpDJilsmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=amd.com;dmarc=pass action=none header.from=amd.com;dkim=pass
 header.d=amd.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NUgaomo9wmccwejtpGy80upjwVia6eM7xKxgF4jBbKE=;
 b=kgVMwvbqA2o0bA6hku96/segXpfGJZvzmSjg2KHaRMmOMgdnU9zLI2wdsxq6zI+h8DnpDCWHuMedEI210ouJbblmcUGSkDna6vyiBalS2m+qUZ/hz/QvBT3ybuC1z0U75A/wb9cKnHJ93XvBFUl0sgYiBhdvB2AocOUZs2wvilk=
Received: from DM6PR12MB2682.namprd12.prod.outlook.com (20.176.118.13) by
 DM6PR12MB3963.namprd12.prod.outlook.com (10.255.174.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.14; Tue, 16 Jul 2019 19:33:56 +0000
Received: from DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::7439:ea87:cc5d:71]) by DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::7439:ea87:cc5d:71%7]) with mapi id 15.20.2073.012; Tue, 16 Jul 2019
 19:33:56 +0000
From:   "Singh, Brijesh" <brijesh.singh@amd.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Liran Alon <liran.alon@oracle.com>
CC:     "Singh, Brijesh" <brijesh.singh@amd.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH 2/2] KVM: x86: Rename need_emulation_on_page_fault() to
 handle_no_insn_on_page_fault()
Thread-Topic: [PATCH 2/2] KVM: x86: Rename need_emulation_on_page_fault() to
 handle_no_insn_on_page_fault()
Thread-Index: AQHVO0w8yx+aB1Al0EKSMExHbTWWAqbNZVmAgAADhACAAAKKgIAAOM4A
Date:   Tue, 16 Jul 2019 19:33:56 +0000
Message-ID: <907f5b95-cb14-155a-2e86-d808b46856c6@amd.com>
References: <20190715203043.100483-1-liran.alon@oracle.com>
 <20190715203043.100483-3-liran.alon@oracle.com>
 <20190716154855.GA1987@linux.intel.com>
 <ECF661D3-A0F0-4F55-A7E5-CE6E204947D1@oracle.com>
 <20190716161035.GB1987@linux.intel.com>
In-Reply-To: <20190716161035.GB1987@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN4PR0501CA0107.namprd05.prod.outlook.com
 (2603:10b6:803:42::24) To DM6PR12MB2682.namprd12.prod.outlook.com
 (2603:10b6:5:42::13)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=brijesh.singh@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.77.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a652ee14-f5e1-4a0c-03b6-08d70a248af3
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DM6PR12MB3963;
x-ms-traffictypediagnostic: DM6PR12MB3963:
x-microsoft-antispam-prvs: <DM6PR12MB3963BB9C3C306342F5D5D136E5CE0@DM6PR12MB3963.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:765;
x-forefront-prvs: 0100732B76
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(39860400002)(346002)(376002)(366004)(199004)(189003)(66066001)(99286004)(7736002)(102836004)(68736007)(54906003)(305945005)(8936002)(316002)(110136005)(8676002)(52116002)(386003)(11346002)(186003)(2616005)(446003)(26005)(81156014)(81166006)(14454004)(66446008)(486006)(64756008)(6512007)(66556008)(66476007)(53936002)(66946007)(2906002)(25786009)(3846002)(6116002)(36756003)(31696002)(14444005)(6486002)(478600001)(86362001)(6436002)(256004)(476003)(5660300002)(53546011)(76176011)(6506007)(71200400001)(71190400001)(229853002)(4744005)(31686004)(6246003)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3963;H:DM6PR12MB2682.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: /zSBgGJKWyZXATraKG8FOXTTpL+pG4K4v1UC0P3LtLGRfxIL4o/R/1XbI8YkDAt1Z+eJ71kx1GvcQXt4vsY/Cb3nEL/Pqc4iQyDTCW+FMP78DuR+pGv7EmiGXrrc6jOx47Kp6DRa0GxZyniWZTz3nbWCYhnQjBkjBu95kzFx/ADejRe5b1demzEVhoRvwMBzZp63cK3JHBNXRDILxO/iqlx+HZZdlErV2qzfXe9twBl5sVcPoYcE/lS642scKHTF7f4pv7/Mfzi4lSPL3f67f1XBh0zbCSFS5vyhDo5phM6l+crFW3mstvd1hBoUDKFic7TFh+biw5XAHZzP1Mw4S6t/1hNZ1dyq8mULzXgZAzZh9CgwG5dSJLCFDHWZCsJUts9o42iaNn3oZe9mxIzoeI2J1a/bknxuxbcXjhJyyQY=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0A56FE2F741B304BA5DE20357574B9D9@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a652ee14-f5e1-4a0c-03b6-08d70a248af3
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jul 2019 19:33:56.3626
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sbrijesh@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3963
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCk9uIDcvMTYvMTkgMTE6MTAgQU0sIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6DQo+IE9u
IFR1ZSwgSnVsIDE2LCAyMDE5IGF0IDA3OjAxOjMwUE0gKzAzMDAsIExpcmFuIEFsb24gd3JvdGU6
DQo+Pg0KPj4+IE9uIDE2IEp1bCAyMDE5LCBhdCAxODo0OCwgU2VhbiBDaHJpc3RvcGhlcnNvbiA8
c2Vhbi5qLmNocmlzdG9waGVyc29uQGludGVsLmNvbT4gd3JvdGU6DQo+Pj4gCWt2bV9tYWtlX3Jl
cXVlc3QoS1ZNX1JFUV9UUklQTEVfRkFVTFQsIHZjcHUpOw0KPj4+IAlyZXR1cm4gZmFsc2U7DQo+
Pg0KPj4gSSBkb27igJl0IHRoaW5rIHdlIHNob3VsZCB0cmlwbGUtZmF1bHQgYW5kIHJldHVybiDi
gJxmYWxzZeKAnS4gQXMgZnJvbSBhIHNlbWFudGljDQo+PiBwZXJzcGVjdGl2ZSwgd2Ugc2hvdWxk
IHJldHVybiB0cnVlLg0KPiANCj4gRmFpciBlbm91Z2gsIEkgZ3Vlc3MgaXQncyBubyBkaWZmZXJl
bnQgdGhhbiB0aGUgd2Fybi1hbmQtY29udGludWUgbG9naWMNCj4gdXNlZCBpbiB0aGUgdW5yZWFj
aGFibGUgVk0tRXhpdCBoYW5kbGVycy4NCj4gDQo+PiBCdXQgdGhpcyBjb21taXQgaXMgZ2V0dGlu
ZyByZWFsbHkgcGhpbG9zb3BoaWNhbCA6KSBNYXliZSBsZXTigJlzIGhlYXIgUGFvbG/igJlzDQo+
PiBwcmVmZXJlbmNlIGZpcnN0IGJlZm9yZSBkb2luZyBhbnkgY2hhbmdlLg0KPiANCj4gSGVuY2Ug
bXkgcmVjb21tZW5kYXRpb24gdG8gcHV0IHRoZSBmdW5jdGlvbiBjaGFuZ2UgaW4gYSBzZXBhcmF0
ZSBwYXRjaCA6LSkNCj4gDQoNCldlbGwsIGR1cmluZyB0aGUgaW5pdGlhbCBwYXRjaCB3ZSBoYWQg
c29tZSBkaXNjdXNzaW9uIGFib3V0IHRoZSBmdW5jdGlvbg0KbmFtZXMuIEF0IHRoYXQgdGltZSB3
ZSBhbGwgZmVsdCB0aGUgbmFtZSB3YXMgb2theS4gSSBkb24ndCBoYXZlIGFueQ0Kc3Ryb25nIHBy
ZWZlcmVuY2UuIExldHMgZ28gd2l0aCB3aGF0ZXZlciBldmVyeW9uZSBhZ3JlZXMgdG8gOikNCg0K
LUJyaWplc2gNCg==
