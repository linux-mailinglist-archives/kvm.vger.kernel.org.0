Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE74FEE79B
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2019 19:46:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729606AbfKDSqt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 13:46:49 -0500
Received: from mail-eopbgr750049.outbound.protection.outlook.com ([40.107.75.49]:14542
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729322AbfKDSqt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Nov 2019 13:46:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KQuf+cpAbztKfYwUQvK9R53TrW5Xej0YQJwJshyaPkJfmQnWRhZr+jn1iQdV2J1deZvKj6yX3oDa7nryvor6c0CbZUbARdraiDnFiuOwGdkLbvrqPgTO0FPBeMiYIx1R/gO5RvALt9HI1jpdgTMTHLzfOFvxHxOnGd6NBZHHrq4VAFS1JHobXfO0bv+kyWG2pi8bClUWb5GsZq3LUZvkENPGYStt6SOuZ/pe7v4Em0hH3n5/3FBfGAarqohDzbiMvYGDXA1o8Mp8OUcNzIWphGoty5SfEfJtw794qWidvk8WLBmLBhe26MUxWUEWX5oz3HyIntMNN5u1lCYZ1qFxSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kNwe7A3GuvKdPFAvnnS3dmnVcJQIeC6QcdKkpLjhTsg=;
 b=juMLq61l3x/UzLoRKylTlhvPYVYFILlz7+UgHeV2NmEsAH50W7GmsYmA8z7sQp3g6LQ4FuATwuD8u3KdgNevlK0LDs7rr8bMuAUextBmaVDZW7l+0JmRsKgl73nZ5/ZoL8K8dBoxpS07EGUjoyTU3yUVcsvpXXj0n/ngqbpg584Fc+fLMv+6DCE8Q699wGLTf3lzas5A+6JsH1cHGUwK9Co8AXBFp9mnTmQqWaXeA4anal3VFv8HRwtBLSEn82/nrjb5EI5aAgqyRJBnuGLedetDBWG4TDREtTrEiN2hCKUu2vH/YUiFSldy24Ohpzb/Bm/F22TKjuTnQ3TPo6qN0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kNwe7A3GuvKdPFAvnnS3dmnVcJQIeC6QcdKkpLjhTsg=;
 b=HiF28n/c4ToBpfDdwQNpSiNprOBBXUgdgRXwyy883JWbB8hjStjlsS2YtpWPXAGy9AE3mWV32nIEunq5Er2Ty2vYviZ29/SPRWDg0IGKYIetwPH23PUDLVlQ5LoINzkpl3+qGikXW/LqLLV4TB1xgP5EZUN1dpnutqlhzPiMzog=
Received: from DM5PR12MB2471.namprd12.prod.outlook.com (52.132.141.138) by
 DM5PR12MB1211.namprd12.prod.outlook.com (10.168.239.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Mon, 4 Nov 2019 18:46:46 +0000
Received: from DM5PR12MB2471.namprd12.prod.outlook.com
 ([fe80::c5a3:6a2e:8699:1999]) by DM5PR12MB2471.namprd12.prod.outlook.com
 ([fe80::c5a3:6a2e:8699:1999%6]) with mapi id 15.20.2408.024; Mon, 4 Nov 2019
 18:46:46 +0000
From:   "Moger, Babu" <Babu.Moger@amd.com>
To:     Borislav Petkov <bp@alien8.de>
CC:     Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "yamada.masahiro@socionext.com" <yamada.masahiro@socionext.com>,
        "nayna@linux.ibm.com" <nayna@linux.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/4] kvm: svm: Enable UMIP feature on AMD
Thread-Topic: [PATCH 2/4] kvm: svm: Enable UMIP feature on AMD
Thread-Index: AQHVkNqD+3M/4HqTrkKsDppH5BsZ1qd2otoA//+6a4CAAFUPgP//tzQAgABVAYCAAYQYoIABE/sAgAIIFwA=
Date:   Mon, 4 Nov 2019 18:46:46 +0000
Message-ID: <7d9ca6fb-ebc5-9c04-30f6-b9c67233cd63@amd.com>
References: <157262960837.2838.17520432516398899751.stgit@naples-babu.amd.com>
 <157262962352.2838.15656190309312238595.stgit@naples-babu.amd.com>
 <CALMp9eQT=a99YhraQZ+awMKOWK=3tg=m9NppZnsvK0Q1PWxbAw@mail.gmail.com>
 <669031a1-b9a6-8a45-9a05-a6ce5fb7fa8b@amd.com>
 <CALCETrXdo2arN=s9Bt1LmYkPajcBj1NuTPC8dwuw2mMZqT0tRw@mail.gmail.com>
 <91a05d64-36c0-c4c4-fe49-83a4db1ade10@amd.com>
 <CALMp9eRWjj1b7bPdiJO3ZT2xDCyV=Ypf6GUcQLkXnqr7YrXDRg@mail.gmail.com>
 <DM5PR12MB2471947F435B18CBC1F68142957D0@DM5PR12MB2471.namprd12.prod.outlook.com>
 <20191103114516.GA32261@zn.tnic>
In-Reply-To: <20191103114516.GA32261@zn.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN6PR15CA0002.namprd15.prod.outlook.com
 (2603:10b6:805:16::15) To DM5PR12MB2471.namprd12.prod.outlook.com
 (2603:10b6:4:b5::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Babu.Moger@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.77.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0796b231-4d34-4f98-e2f9-08d76157580b
x-ms-traffictypediagnostic: DM5PR12MB1211:
x-microsoft-antispam-prvs: <DM5PR12MB12110378D7C155AEFE301425957F0@DM5PR12MB1211.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 0211965D06
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(136003)(39860400002)(346002)(376002)(199004)(189003)(2616005)(6116002)(3846002)(66946007)(478600001)(7736002)(25786009)(76176011)(6486002)(386003)(6506007)(6246003)(7416002)(52116002)(6436002)(11346002)(446003)(305945005)(4326008)(8676002)(476003)(81166006)(66066001)(316002)(486006)(8936002)(2906002)(6916009)(186003)(31696002)(36756003)(229853002)(5660300002)(102836004)(54906003)(4744005)(14444005)(26005)(81156014)(53546011)(256004)(99286004)(31686004)(14454004)(66446008)(71190400001)(71200400001)(6512007)(66556008)(64756008)(86362001)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1211;H:DM5PR12MB2471.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5I9baEi/RK+ppqQz7A8GT1OvUpCF5TpQ41xWxPlR35q7zL4B8DMZYaN8y2Ongk9YWWj4pbgZtuAYHbFMQs2VvnlKgL2/frNyy1fcOQMC4ClJRHSkerIzouDHdjFCJAF7+UfC4lKU0Az4vYaH4LZq4A4mCwGIkrhS/WBlbI0IIksWVlZHoJaioHauDmT8BmPyBm2E+95YED2dOTPXIGN1Y8RzSDA3nbQktiTr1J8YBk0lg4nqwPNIEb+YXFlkNbldv0nxd9VgZw9YkR/rRL+W8ks55cC1/QLZ5dMBW4E33ui9UKzmsou8ESA7C73eGNMQRbBcy+phb7ogNK/sn+xT8p6Bi0XP1I2Hvi/QIggX8AUkS8UFUfkONNfo58yiIzc/uQnFKDomrQSkQA4FrstUa4O5hDwYDCYc8I1gwdYmcRQUzt5CQxkFqXDwlWjjKvZF
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <701308F59C5DC24CBF93CBEF4A192159@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0796b231-4d34-4f98-e2f9-08d76157580b
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2019 18:46:46.6745
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZPaP/BnmU/QSJaTew/5PfrI4wlkXw249sbHNISPTUEk5EB1d69658s4KC4psCvYL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1211
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCk9uIDExLzMvMTkgNTo0NSBBTSwgQm9yaXNsYXYgUGV0a292IHdyb3RlOg0KPiBPbiBTYXQs
IE5vdiAwMiwgMjAxOSBhdCAwNzoyMzo0NVBNICswMDAwLCBNb2dlciwgQmFidSB3cm90ZToNCj4+
IEhvdyBhYm91dCB1cGRhdGluZyB0aGUgS2NvbmZpZyAocGF0Y2ggIzQpIGFuZCB1cGRhdGUgaXQg
dG8NCj4+IENPTkZJR19YODZfVU1JUCAoaW5zdGVhZCBvZiBDT05GSUdfWDg2X0lOVEVMX1VNSVAp
Lg0KPiANCj4gWWVzLCBwbHMgZG8gdGhhdCBhbmQgbWFrZSBpdCBkZXBlbmQgb24gQ1BVX1NVUF9B
TUQgdG9vLg0KDQpTdXJlLiBXaWxsIHNlbmQgdGhlIHBhdGNoIHNvb24uIFRoYW5rcw0KPiANCj4g
VGh4Lg0KPiANCg==
