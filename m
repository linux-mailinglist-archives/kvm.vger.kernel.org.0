Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CAD15A581
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2019 21:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbfF1Tzt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jun 2019 15:55:49 -0400
Received: from mail-eopbgr800077.outbound.protection.outlook.com ([40.107.80.77]:31451
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727060AbfF1Tzs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jun 2019 15:55:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0S9Dtq1zBh8XQid342iv9frt9+pCu4i9/fWnGZj4a80=;
 b=mmkDuO1x+Znhxvf7PK62DmMmST4xF9NSoNXry+L/J0wjGGhdklEGilL0pAtR0AblhZS9JItpNizNfgk37y6qlDshKAYp/e8EXanHlBLOZVOnt1duz3KdsPKW1Uts4KalNMk72xKFFPangQTeMAwHKQid29O/pSGO5JH3ymNMqf0=
Received: from DM6PR12MB3163.namprd12.prod.outlook.com (20.179.104.150) by
 DM6PR12MB3404.namprd12.prod.outlook.com (20.178.198.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.18; Fri, 28 Jun 2019 19:55:45 +0000
Received: from DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::1ddd:450:1798:1782]) by DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::1ddd:450:1798:1782%6]) with mapi id 15.20.2008.018; Fri, 28 Jun 2019
 19:55:45 +0000
From:   "Lendacky, Thomas" <Thomas.Lendacky@amd.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>
Subject: AMD SEV-ES and Guest-Host Communicaiton Block (GHCB) usage
 standardization
Thread-Topic: AMD SEV-ES and Guest-Host Communicaiton Block (GHCB) usage
 standardization
Thread-Index: AQHVLet5ZHj1x81pBkqTQudjE4CCEQ==
Date:   Fri, 28 Jun 2019 19:55:45 +0000
Message-ID: <91c990f9-879a-54d9-873f-ec5533784099@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: DM6PR13CA0054.namprd13.prod.outlook.com
 (2603:10b6:5:134::31) To DM6PR12MB3163.namprd12.prod.outlook.com
 (2603:10b6:5:182::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.77.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4547549d-9e7a-4c20-0057-08d6fc029bc3
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB3404;
x-ms-traffictypediagnostic: DM6PR12MB3404:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <DM6PR12MB3404621D79CE345ABC09BBC7ECFC0@DM6PR12MB3404.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 00826B6158
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(39860400002)(376002)(346002)(396003)(199004)(189003)(31686004)(966005)(72206003)(14454004)(99286004)(102836004)(53936002)(6306002)(6436002)(186003)(52116002)(68736007)(6512007)(66066001)(478600001)(26005)(6486002)(386003)(6506007)(8676002)(81156014)(81166006)(6116002)(305945005)(7736002)(64756008)(3846002)(8936002)(5660300002)(316002)(110136005)(66446008)(66556008)(66946007)(66476007)(73956011)(86362001)(2616005)(486006)(476003)(36756003)(25786009)(2501003)(256004)(2906002)(14444005)(71200400001)(71190400001)(31696002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3404;H:DM6PR12MB3163.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ZACUg1ohJhKq13pyH1a90kfH99OqvcDSmWGG9i3hcquPZt26tG97r2yPGhenUATnBJ8mcUjen6rbY/HRMzrOYG8SDdxhnh+hi3gsDY8Q5BVNpvyBkcWS0odDbighBmFvtF/zwSGBPScTW5Lq7xFlhsYY0sA1qY0JpV70Mnsbha+P+mk1nesdCJQbFvy4gZVcPJuUhDvUygs1+PBkgLNm5nG7UAzMTzp/4wuClpXz+1FDY9r2WrAtqSWrt0Emgzs4J+Oco7ls49JaiGTGKNoZxiaKi9mbP+H/mcxD9gFu2pwVCOmC05F+9hywzKsCgZE20xdtpENfJbNmnlNrMHvF3m0yv2DgHoBCR+zr2bZJ0NkZ/7eR7aoauqGsAL2Gc4aAKGxs7VSU+Oq0vHHFCrask6UVWJslAAZXlKTQ0oUGqKs=
Content-Type: text/plain; charset="utf-8"
Content-ID: <940579B8C7A55C4EA7CCAD10787560C0@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4547549d-9e7a-4c20-0057-08d6fc029bc3
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2019 19:55:45.5794
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tlendack@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3404
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VGhpcyBpcyBhbiBpbmZvcm1hdGlvbmFsIHBvc3QgYWJvdXQgQU1EIFNlY3VyZSBFbmNyeXB0ZWQg
VmlydHVhbGl6YXRpb24gLQ0KRW5jcnlwdGVkIFN0YXRlLg0KDQpJbiBhZGRpdGlvbiB0byB0aGUg
U2VjdXJlIEVuY3J5cHRlZCBWaXJ0dWFsaXphdGlvbiAoU0VWKSBmZWF0dXJlLCBBTUQgRVBZQw0K
cHJvY2Vzc29ycyBhbHNvIHByb3ZpZGUgYSBmZWF0dXJlIGNhbGxlZCBTZWN1cmUgRW5jcnlwdGVk
IFZpcnR1YWxpemF0aW9uIC0NCkVuY3J5cHRlZCBTdGF0ZSAoU0VWLUVTKS4gQnVpbGRpbmcgb24g
dGhlIG1lbW9yeSBlbmNyeXB0aW9uIHRlY2hub2xvZ3kgaW4NClNFViwgU0VWLUVTIHByb3RlY3Rz
IHRoZSBndWVzdCByZWdpc3RlciBzdGF0ZSBmcm9tIHRoZSBoeXBlcnZpc29yIGJ5DQplbmNyeXB0
aW5nIHRoZSBndWVzdCByZWdpc3RlciBzdGF0ZS4gU2luY2UgdGhlIGd1ZXN0IHJlZ2lzdGVyIHN0
YXRlIGlzDQplbmNyeXB0ZWQsIGEgbWV0aG9kIG9mIGNvbW11bmljYXRpbmcgYmV0d2VlbiB0aGUg
Z3Vlc3QgYW5kIHRoZSBoeXBlcnZpc29yDQppcyByZXF1aXJlZCBpbiBvcmRlciBmb3IgdGhlIGh5
cGVydmlzb3IgdG8gcHJvdmlkZSBjZXJ0YWluIGZ1bmN0aW9uYWxpdHkNCnRvIHRoZSBndWVzdCAo
ZS5nLiBDUFVJRCBzdXBwb3J0KS4NCg0KQSBzcGVjaWZpY2F0aW9uIGhhcyBiZWVuIGRldmVsb3Bl
ZCB0byBlbnN1cmUgdGhhdCBhIHNpbmdsZSBndWVzdCBpbWFnZSBjYW4NCnJ1biB3aXRob3V0IG1v
ZGlmaWNhdGlvbiBhY3Jvc3MgbXVsdGlwbGUgaHlwZXJ2aXNvcnMuIFRoaXMgc3BlY2lmaWNhdGlv
bg0KZXN0YWJsaXNoZXMgaG93IGFuIFNFVi1FUyBndWVzdCBhbmQgYW4gU0VWLUVTIGNhcGFibGUg
aHlwZXJ2aXNvciBzaG91bGQNCmNvbW11bmljYXRlIHdpdGggZWFjaCBvdGhlci4gU2luY2UgdGhl
IHJlZ2lzdGVyIHN0YXRlIG9mIGFuIFNFVi1FUyBndWVzdA0KaXMgZW5jcnlwdGVkLCBhIHNoYXJl
ZCBjb21tdW5pY2F0aW9uIGFyZWEgbXVzdCBiZSB1c2VkIGluIG9yZGVyIHRvIGFsbG93DQp0aGUg
Z3Vlc3QgYW5kIGh5cGVydmlzb3IgdG8gY29tbXVuaWNhdGUsIHRoZSBHdWVzdC1Ib3N0IENvbW11
bmljYXRpb24NCkJsb2NrIChHSENCKS4gVGhlIHNwZWNpZmljYXRpb24gZGVmaW5lcyB0aGUgZm9y
bWF0IGFuZCB1c2Ugb2YgdGhlIEdIQ0IsDQp0aGUgZ3Vlc3QgZXhpdHMgdGhhdCBtdXN0IGJlIGlu
aXRpYWxseSBzdXBwb3J0ZWQgYW5kIHJlcXVpcmVtZW50cyBmb3INCmNlcnRhaW4gc2NlbmFyaW9z
LCBzdWNoIGFzIEFQIGJvb3RpbmcuDQoNClRoZSBzcGVjaWZpY2F0aW9uIGlzIGRlZmluZWQgYXMg
dGhlIFNFVi1FUyBHdWVzdC1IeXBlcnZpc29yIENvbW11bmljYXRpb24NCkJsb2NrIFN0YW5kYXJk
aXphdGlvbiBkb2N1bWVudC4gVGhpcyBkb2N1bWVudCBpcyBhdmFpbGFibGUgYXQgdGhlIEFNRA0K
U2VjdXJlIEVuY3J5cHRlZCBWaXJ0dWFsaXphdGlvbiB3ZWIgcGFnZSBbMV0gKG9yIGRpcmVjdGx5
IFsyXSkuIFRoZSBBTUQNClNlY3VyZSBFbmNyeXB0ZWQgVmlydHVhbGl6YXRpb24gd2ViIHBhZ2Ug
YWxzbyBjb250YWlucyBhZGRpdGlvbmFsDQppbmZvcm1hdGlvbiByZWxhdGVkIHRvIFNFViBhbmQg
U0VWLUVTLg0KDQpUaGFua3MsDQpUb20NCg0KWzFdIGh0dHBzOi8vZGV2ZWxvcGVyLmFtZC5jb20v
c2V2Lw0KWzJdIGh0dHBzOi8vZGV2ZWxvcGVyLmFtZC5jb20vd3AtY29udGVudC9yZXNvdXJjZXMv
NTY0MjEucGRmDQo=
