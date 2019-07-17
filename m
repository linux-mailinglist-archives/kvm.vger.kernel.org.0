Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84E156C1A9
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2019 21:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729022AbfGQToH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jul 2019 15:44:07 -0400
Received: from mail-eopbgr790071.outbound.protection.outlook.com ([40.107.79.71]:6176
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726598AbfGQToG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Jul 2019 15:44:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C4c7MsB/2ZOM3nYt+rtK/9KFPqPx8ZIvlTU46T7zyU9SS3xXfUdJdTI6OS5bONgyYV0eOK0BwLxO/vpAJNNYpmlVeIEr4+MSShdGbcXuHkXY2TW47V6jkreW7aOE9/RHMHDaWgoqu15Fta3BwnrxK2kzlsVONg2WILGbg5yMhTA0D8P/aU70ltKnGzEk2C23/UCZQKBpC5BA0TUuMnewi7KSbt1GrTPpU6a0igOg2O7sd1bh5OpfMs66dociLmyne6oEdcSSBXlyVYJaC1OwsmD7Oz2LJ75DbmtlXp7q3TW+AMqVzrvYMqmef76u2LmtmnI5Ibi1PLUrCHLzuoToog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TXadSCt6ppOAY1CPvXfkoh66xz2Tl2pihgBS8UBFWww=;
 b=FpgmbxuJPAZwy8lu5XLlnCl3Ol7zNBihlZvWBa91pnmvQ/CIMoLD9EyG5SBn6W1zZ20Ga7T8Qoh44gBdKpugU1oXtYEj0o8z53OaRKemls3cffTTuPpnlaDJjvZFuDwf/hrLlGqYfK+Swa8c/1nNQUIuMpSqfnrGmVpilHUEJK8ksqEqizB6moqIcXz2parrZtOp1jkHRU4Valnw9EGlj97PV6VkXBF+Hsz1QG9i9Az1nG1Cjy1Te/0u1OGpH0To6izglMowthogvOKLSfQBcdOeKhrV7Kp5FEf59LGyV4IlygpMJDR8VLKb76QHD27RJ6qtn7GkhlDqi5O2zXljJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=amd.com;dmarc=pass action=none header.from=amd.com;dkim=pass
 header.d=amd.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TXadSCt6ppOAY1CPvXfkoh66xz2Tl2pihgBS8UBFWww=;
 b=i4XXUz/s50vGgtIrYOcKzzC+n5ETCLMCucaDfFmJJqVESxrwA5gfZ9ht3r1LTq3KkKrjc/v9xRdYzFI/OPUJ5ANVWSKvmKMMUZUk8VCDXAg0XVqd2FmTPKq1pYuHhWQ0aSMfb/k4jnpaepJc4qwIZgR9MzrgWW5rzYxCtKHI8Mw=
Received: from DM6PR12MB2844.namprd12.prod.outlook.com (20.176.117.96) by
 DM6PR12MB3563.namprd12.prod.outlook.com (20.178.199.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.11; Wed, 17 Jul 2019 19:44:03 +0000
Received: from DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::a91d:8752:288:ed5f]) by DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::a91d:8752:288:ed5f%6]) with mapi id 15.20.2073.012; Wed, 17 Jul 2019
 19:44:03 +0000
From:   "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>
Subject: Re: [PATCH 1/6] KVM: x86: Add callback functions for handling APIC
 ID, DFR and LDR update
Thread-Topic: [PATCH 1/6] KVM: x86: Add callback functions for handling APIC
 ID, DFR and LDR update
Thread-Index: AQHU4KZqWIh7CkaDPUGAVOVmco9DYqa6B+qAgBXmv4A=
Date:   Wed, 17 Jul 2019 19:44:03 +0000
Message-ID: <1fa8e887-8ef7-eaa9-567d-cfe349be2d3a@amd.com>
References: <20190322115702.10166-1-suravee.suthikulpanit@amd.com>
 <20190322115702.10166-2-suravee.suthikulpanit@amd.com>
 <15e1b25c-906a-03dd-cb69-6b99c8c98ff7@redhat.com>
In-Reply-To: <15e1b25c-906a-03dd-cb69-6b99c8c98ff7@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
x-originating-ip: [165.204.77.1]
x-clientproxiedby: SN6PR08CA0026.namprd08.prod.outlook.com
 (2603:10b6:805:66::39) To DM6PR12MB2844.namprd12.prod.outlook.com
 (2603:10b6:5:45::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 27e5e5d7-e9bc-4b81-d595-08d70aef1ef7
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB3563;
x-ms-traffictypediagnostic: DM6PR12MB3563:
x-microsoft-antispam-prvs: <DM6PR12MB356365CEE3519EF694180B9DF3C90@DM6PR12MB3563.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 01018CB5B3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(366004)(376002)(396003)(39860400002)(199004)(189003)(6436002)(31686004)(229853002)(65956001)(66066001)(26005)(65806001)(4326008)(99286004)(186003)(6512007)(6246003)(53936002)(66556008)(66446008)(64126003)(8936002)(3846002)(6116002)(8676002)(2616005)(81166006)(478600001)(81156014)(7736002)(476003)(446003)(11346002)(6486002)(65826007)(58126008)(86362001)(305945005)(68736007)(2501003)(316002)(31696002)(25786009)(71190400001)(2201001)(71200400001)(15650500001)(54906003)(110136005)(2906002)(36756003)(5660300002)(4744005)(52116002)(76176011)(102836004)(386003)(53546011)(6506007)(256004)(66476007)(64756008)(486006)(14444005)(66946007)(14454004);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3563;H:DM6PR12MB2844.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: WHqb+/bmg2z0878IB7j31pa1FrjEN30MlkfygWv8vez075PBB2etE2/ZLFZA1WJUB/avxgSz3AGOv8lIabSI7fKoLvW4QsCYPMtKn/LdIAsBBtjyRMlkKGFWcN53C8uMjKWJwiDF4TSQX6QmKkKTLfvuau1o+DIKzP9Dbtc3jVq7HQfXSMwwcUSsHXVbpttDKOlNeYvfoj/Z3PV5t/2DhuW6aShpW6j3cvWu1w5+Gs8V7NYRRUCKBZ1D09vMUO4GmGhHE3xLXdnZi94vcoS0SKrnE8eanG9nRuey2XJlNSqh0vMsmZ2xIROxeu7Md8GE9qiFY3AB1LqYWryxzy6jJspbuG+0TPOm2MPHW47wTrKQsHSanmPTYipPVfWDhEb31G5ksIzqcVVzYeNOqeS0zhDvmDnbNQr9gBSYtNsgZTI=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BD2DB7E021333E479685C297903D18B5@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27e5e5d7-e9bc-4b81-d595-08d70aef1ef7
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jul 2019 19:44:03.2253
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ssuthiku@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3563
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

UGFvbG8sDQoNCk9uIDcvMy8yMDE5IDQ6MTYgUE0sIFBhb2xvIEJvbnppbmkgd3JvdGU6DQo+IE9u
IDIyLzAzLzE5IDEyOjU3LCBTdXRoaWt1bHBhbml0LCBTdXJhdmVlIHdyb3RlOg0KPj4gQWRkIGhv
b2tzIGZvciBoYW5kbGluZyB0aGUgY2FzZSB3aGVuIGd1ZXN0IFZNIHVwZGF0ZSBBUElDIElELCBE
RlIgYW5kIExEUi4NCj4+IFRoaXMgaXMgbmVlZGVkIGR1cmluZyBBTUQgQVZJQyBpcyB0ZW1wb3Jh
cnkgZGVhY3RpdmF0ZWQuDQo+Pg0KPj4gU2lnbmVkLW9mZi1ieTogU3VyYXZlZSBTdXRoaWt1bHBh
bml0PHN1cmF2ZWUuc3V0aGlrdWxwYW5pdEBhbWQuY29tPg0KPiBXaHkgbm90IGRvIHRoaXMgbGF0
ZXIgd2hlbiBBVklDIGlzIHJlYWN0aXZhdGVkLCBpbg0KPiBzdm1fcmVmcmVzaF9hcGljdl9leGVj
X2N0cmw/DQo+IA0KPiBUaGFua3MsDQo+IA0KPiBQYW9sbw0KPiANCg0KQWN0dWFsbHksIGNhbGxp
bmcgYXZpY19wb3N0X3N0YXRlX3Jlc3RvcmUoKSBpbiB0aGUgc3ZtX3JlZnJlc2hfYXBpY3ZfZXhl
Y19jdHJsKCkNCnNob3VsZCB3b3JrIGFsc28uIEknbGwgZG8gdGhhdCB0aGVuLg0KDQpUaGFua3Ms
DQpTdXJhdmVlDQo=
