Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54B03E7FC
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2019 18:44:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728823AbfD2Qn5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Apr 2019 12:43:57 -0400
Received: from mail-eopbgr690061.outbound.protection.outlook.com ([40.107.69.61]:16899
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728520AbfD2Qn4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Apr 2019 12:43:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amd-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TYyWNcu7FCggw4Uv8bWgg9K/2sSIp4hmI7hYXCtC/oQ=;
 b=GYJJoS4IoQIuhvXAMFkWjr33iHetlcX0PL6OiO2T6oPdp1pbwQ2AiuCW/eoaOrDZP0BVn83IL9NkpabdubTr7gEUb8BOoIQNuNWwGMEUA/porm+nAyL3rSj1Ig72Jkpo6+jJ96d9kiLymQyWNiZmH9UzPbT8rDTVHmx/HoMYZII=
Received: from DM6PR12MB2682.namprd12.prod.outlook.com (20.176.116.31) by
 DM6PR12MB2619.namprd12.prod.outlook.com (20.176.116.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.13; Mon, 29 Apr 2019 16:43:53 +0000
Received: from DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::9183:846f:a93e:9a43]) by DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::9183:846f:a93e:9a43%5]) with mapi id 15.20.1835.016; Mon, 29 Apr 2019
 16:43:53 +0000
From:   "Singh, Brijesh" <brijesh.singh@amd.com>
To:     Borislav Petkov <bp@alien8.de>
CC:     "Singh, Brijesh" <brijesh.singh@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?utf-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v1 01/10] KVM: SVM: Add KVM_SEV SEND_START command
Thread-Topic: [RFC PATCH v1 01/10] KVM: SVM: Add KVM_SEV SEND_START command
Thread-Index: AQHU+rgqsjyUQYD5ekOPbYup8IOCm6ZOfjkAgAAFPwCAAGh9gIAEA5iAgABuRgCAAAIvgA==
Date:   Mon, 29 Apr 2019 16:43:53 +0000
Message-ID: <9d330734-02cf-9d21-e26f-56fe9d16fa03@amd.com>
References: <20190424160942.13567-1-brijesh.singh@amd.com>
 <20190424160942.13567-2-brijesh.singh@amd.com>
 <20190426141042.GF4608@zn.tnic>
 <e6f8da38-b8dd-a9c5-a358-5f33b6ea7b37@amd.com>
 <20190426204327.GM4608@zn.tnic>
 <2b63d983-a622-3bec-e6ac-abfd024e19c0@amd.com>
 <20190429163602.GE2324@zn.tnic>
In-Reply-To: <20190429163602.GE2324@zn.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN4PR0501CA0117.namprd05.prod.outlook.com
 (2603:10b6:803:42::34) To DM6PR12MB2682.namprd12.prod.outlook.com
 (2603:10b6:5:4a::31)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=brijesh.singh@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.77.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7bd3823a-da8c-41b6-5580-08d6ccc1dd59
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB2619;
x-ms-traffictypediagnostic: DM6PR12MB2619:
x-microsoft-antispam-prvs: <DM6PR12MB261911E3119BC80F557977B2E5390@DM6PR12MB2619.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3044;
x-forefront-prvs: 0022134A87
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(396003)(366004)(136003)(376002)(346002)(189003)(199004)(102836004)(68736007)(53936002)(26005)(31686004)(6512007)(2906002)(8676002)(81166006)(186003)(81156014)(4326008)(36756003)(25786009)(53546011)(14454004)(6506007)(6246003)(8936002)(7736002)(54906003)(2616005)(446003)(386003)(11346002)(316002)(476003)(66066001)(305945005)(99286004)(478600001)(76176011)(229853002)(6916009)(52116002)(6486002)(66476007)(6436002)(66556008)(486006)(66946007)(7416002)(6116002)(558084003)(97736004)(14444005)(256004)(31696002)(66446008)(73956011)(3846002)(71200400001)(93886005)(71190400001)(86362001)(5660300002)(64756008);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB2619;H:DM6PR12MB2682.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: lWnzl1C+vEhEIaX/9nXFaDmdYF06yuhz2+BT05ysgtekrkyuk5xt3/hfBeFmjKyCwMtX6dNVt22DgEqBB2TUo7R/C2qKZiuRZ0WbZ9io5TfuJIWP+PJpld/RJQ/xMIH8M+hkOHYVFvNCkkhlRpOdEeg6PlSu96T2J+Gajwotr59uXJ/IONFx+jRHVulc7sr3l0wJ2GnpGq/UtYvyJQ2+W8yx0bler+U7bE6M94o4CLNYS8QMB9aQx9X2o6U4NNNZyF5yn8EOYyeOroQsZ5ApqMcGgs/SPICSgD79zKmbJJd6uhOF/QE3wuPvshCn8QXOp6h1NddND19hqDQsCioG1PGpPrs29ZS9GZW7HjcTONy0+dzLRkw+xT8SfDXSW/UD8mAp2aZF/m6XEE7czdTwUEq2xQmsrnjid/lR/6LF8TM=
Content-Type: text/plain; charset="utf-8"
Content-ID: <47D67942F49E49489E04543939504C08@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bd3823a-da8c-41b6-5580-08d6ccc1dd59
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2019 16:43:53.8070
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2619
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCk9uIDQvMjkvMTkgMTE6MzYgQU0sIEJvcmlzbGF2IFBldGtvdiB3cm90ZToNCj4gU28gd2hh
dCBhYm91dCB0aGlzPyBMaW1pdGluZyB0byBhIHNhbmUgbGVuZ3RoLi4uDQoNClN1cmUsIHdlIGhh
dmUgZGVmaW5lZCBhIFNFVl9GV19CTE9CX01BWF9TSVpFIGFuZCBjYW4gdXNlIGl0IHRvIGxpbWl0
DQp0aGUgYmxvYiBjb3B5IHNpemUuIEkgd2lsbCBkbyB0aGlzIGluIG5leHQgcmV2LiB0aGFua3MN
Cg0KLUJyaWplc2gNCg==
