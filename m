Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 058198F081
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2019 18:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731548AbfHOQZs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Aug 2019 12:25:48 -0400
Received: from mail-eopbgr760043.outbound.protection.outlook.com ([40.107.76.43]:65343
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731471AbfHOQZZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Aug 2019 12:25:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j9Vs2ezzomlh8KQUW2QVC0Uy+oop65jmFVrZbjWjtBr/ewrb/XqeXDg15D52sgwpPrHBNRmAyMLnqZ+sKfEUrsxU+dLvUkDPNY7BGLkqzLlwXkgoBqgwP7Ei90sgXRYIuehFdVk89Gd0hImuyaasedoODOs7expeX9L4TM77zlFX+edkrgpw/I5yG4DohzsjJPkaKiKwzOpXhdzD2UDKeHD5C1swJtpLRBSCh4CWXVy4fclINYxgEGB4nIs03H0v/zM95N94zotEVmVEq1TISwUac+GWMhz7X8NmtUVXX7TG3XdK3O9aQYSOwOrx2l0l+iUatx373COBA5pJkSegLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cQ/VVz2weoxNMoAJivb5oHWdiFL6y32tXYl1KrtNYN8=;
 b=CNtH/SAZr/SUWvYcYDjHAr4ZDTk1IEdWxf0ak268kv/etOTtxgakEVeKskMKDJ7wPJjSUIbeeOesxv/bde2Sit2HGqj0CYNE34hUuDXTpuaU86pxhCUDH6yQk1/4kSiT5/LO6TQ+5giRWDn7Ht3nCNQimYIQXRiwm5iwtEiUadh2h5cMfDELZLp7EbOZ3FxqW98kUsbKk7PpGRBJX6EalYccNW9d3NV4LlTQUQSmxyGGl+jffzc7JMQEffVtidpQXaeQ4NxxsQTyRSRM3YHHtWexJWx0sOgYo1kepG3UNLW10FZRSvV3h5Il14PBuy4vvICjxCXTR9Fn14NTuNwueg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cQ/VVz2weoxNMoAJivb5oHWdiFL6y32tXYl1KrtNYN8=;
 b=AFDzmBSLUJGtcdnrFHrNuFPb7QqYGMM4DF5BtQM6rn6KUEV7saa6dn04KBzS8tMTUOv8rtUz0EwtRACjdTMpcYH4eEnAV8g1imlwvHX75wn7coHhkTniR4zJ4aiTjIXSXLSizp7W6i1GBrQBQFxpv7WWv+ucPH1qpQfey6NRbU0=
Received: from DM6PR12MB2844.namprd12.prod.outlook.com (20.176.117.96) by
 DM6PR12MB2603.namprd12.prod.outlook.com (20.176.116.84) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.23; Thu, 15 Aug 2019 16:25:21 +0000
Received: from DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::e95a:d3ee:e6a0:2825]) by DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::e95a:d3ee:e6a0:2825%7]) with mapi id 15.20.2157.022; Thu, 15 Aug 2019
 16:25:21 +0000
From:   "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "graf@amazon.com" <graf@amazon.com>,
        "jschoenh@amazon.de" <jschoenh@amazon.de>,
        "karahmed@amazon.de" <karahmed@amazon.de>,
        "rimasluk@amazon.com" <rimasluk@amazon.com>,
        "Grimm, Jon" <Jon.Grimm@amd.com>,
        "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
Subject: [PATCH v2 15/15] svm: Allow AVIC with in-kernel irqchip mode
Thread-Topic: [PATCH v2 15/15] svm: Allow AVIC with in-kernel irqchip mode
Thread-Index: AQHVU4YILrKjYuKokEOebbb/2w3mWw==
Date:   Thu, 15 Aug 2019 16:25:21 +0000
Message-ID: <1565886293-115836-16-git-send-email-suravee.suthikulpanit@amd.com>
References: <1565886293-115836-1-git-send-email-suravee.suthikulpanit@amd.com>
In-Reply-To: <1565886293-115836-1-git-send-email-suravee.suthikulpanit@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [165.204.78.1]
x-clientproxiedby: SN6PR04CA0084.namprd04.prod.outlook.com
 (2603:10b6:805:f2::25) To DM6PR12MB2844.namprd12.prod.outlook.com
 (2603:10b6:5:45::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 1.8.3.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1444f66c-e692-4270-29d2-08d7219d2b2c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB2603;
x-ms-traffictypediagnostic: DM6PR12MB2603:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB26032E7AF58580337552E34EF3AC0@DM6PR12MB2603.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-forefront-prvs: 01304918F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(39860400002)(366004)(136003)(346002)(199004)(189003)(14454004)(256004)(6436002)(81166006)(81156014)(478600001)(4326008)(4744005)(99286004)(14444005)(66574012)(5660300002)(25786009)(50226002)(8936002)(305945005)(66066001)(476003)(26005)(6512007)(6116002)(186003)(102836004)(7736002)(446003)(71190400001)(53936002)(2501003)(11346002)(6506007)(2616005)(2906002)(6486002)(8676002)(386003)(36756003)(3846002)(110136005)(4720700003)(316002)(486006)(86362001)(66476007)(66946007)(66556008)(64756008)(76176011)(66446008)(54906003)(52116002)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB2603;H:DM6PR12MB2844.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: anBJa/wqf4fnN2wg3c/I7bDdYkeUxZF9dj732IczinqBJjvggYBAywNWVyKhmbfRpvDPP7Ze1Qz0tOWgBDyEoznJK7HMi3wlxCM3ZYve4NWICzlILhdRWb/XDwMOsnzv+60JpXrURCbFnn+AIsrSSMuQ1Dq1IA9rV9ikV9bH6UzaxcILFRwNig3Skz1e/7vjsNCd6kHHzzsvd9oQoH1WK89CfY2o9tbVou3klzR5OZpxuB+t7rSsa6A1NRMHJ8KY2KqKb/l0awYUYmUId0zwNwez7kMXGL9TVfRz2+7ScuZ9FJS2Uq1X4c/M2/Cjo9swBZR+GBjasIJ/iXepa9Dnw/4sBYpzqhzQYUPPZT9/rWM5ulPEvmkzvyhzBv2bA2O5tao4M/lr7trtt/qi0I1u/GZgmVBNbWJP1QZSPMlo1ak=
Content-Type: text/plain; charset="utf-8"
Content-ID: <866CA85226F0254B98E4292EF13F05E5@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1444f66c-e692-4270-29d2-08d7219d2b2c
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2019 16:25:21.7149
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tJY6LRSpKjE+s6hm53KY+VdfIBc4LKqNrHgKqn2Zaqa+BK+9CBpqIXPXqncTt6SYOq47KczyXEq8GB9Uzg/1TQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2603
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T25jZSBydW4tdGltZSBBVklDIGFjdGl2YXRlL2RlYWN0aXZhdGUsIGFuZCBQSUMgYW5kIElPQVBJ
QyBFT0kgd29ya2Fyb3VuZA0KZm9yIEFWSUMgaXMgc3VwcG9ydGVkLCB3ZSBjYW4gcmVtb3ZlIHRo
ZSBrZXJuZWwgaXJxY2hpcCBzcGxpdCBtb2RlDQpyZXF1aXJlbWVudCBmb3IgQVZJQy4NCg0KSGVu
Y2UsIHJlbW92ZSB0aGUgY2hlY2sgZm9yIGlycWNoaXAgc3BsaXQgbW9kZSB3aGVuIGVuYWJsaW5n
IEFWSUMuDQoNCkNjOiBSYWRpbSBLcsSNbcOhxZkgPHJrcmNtYXJAcmVkaGF0LmNvbT4NCkNjOiBQ
YW9sbyBCb256aW5pIDxwYm9uemluaUByZWRoYXQuY29tPg0KU2lnbmVkLW9mZi1ieTogU3VyYXZl
ZSBTdXRoaWt1bHBhbml0IDxzdXJhdmVlLnN1dGhpa3VscGFuaXRAYW1kLmNvbT4NCi0tLQ0KIGFy
Y2gveDg2L2t2bS9zdm0uYyB8IDIgKy0NCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyks
IDEgZGVsZXRpb24oLSkNCg0KZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS9zdm0uYyBiL2FyY2gv
eDg2L2t2bS9zdm0uYw0KaW5kZXggNDY5MDM1MS4uMDRjODM5MiAxMDA2NDQNCi0tLSBhL2FyY2gv
eDg2L2t2bS9zdm0uYw0KKysrIGIvYXJjaC94ODYva3ZtL3N2bS5jDQpAQCAtNTE4MCw3ICs1MTgw
LDcgQEAgc3RhdGljIHZvaWQgc3ZtX3NldF92aXJ0dWFsX2FwaWNfbW9kZShzdHJ1Y3Qga3ZtX3Zj
cHUgKnZjcHUpDQogDQogc3RhdGljIGJvb2wgc3ZtX2dldF9lbmFibGVfYXBpY3Yoc3RydWN0IGt2
bSAqa3ZtKQ0KIHsNCi0JcmV0dXJuIGF2aWMgJiYgaXJxY2hpcF9zcGxpdChrdm0pOw0KKwlyZXR1
cm4gYXZpYzsNCiB9DQogDQogc3RhdGljIHZvaWQgc3ZtX2h3YXBpY19pcnJfdXBkYXRlKHN0cnVj
dCBrdm1fdmNwdSAqdmNwdSwgaW50IG1heF9pcnIpDQotLSANCjEuOC4zLjENCg0K
