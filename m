Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED6AF132D14
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2020 18:33:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728407AbgAGRdC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jan 2020 12:33:02 -0500
Received: from mail-bn8nam12on2056.outbound.protection.outlook.com ([40.107.237.56]:7275
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728325AbgAGRdC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jan 2020 12:33:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d1NgiNCDqXzCkHFa81N07si8OmaBTwrd1nyuVNhkxiJ7XtgnOct0Io9UO0QkyyB98Kvtiof8GUW+/CiA5X1wrcFO7UF1FXEbZ4RnDPrVzByxU3RKn7bJtwQg3GSdY1cghI8uRMiiKf0bnkFAu5CHbIQSVZz4Q/RbM8Mn5S1O5IrVDwkAT9yQRrtmBenUMaUl1SFFBzlYOGfHKmSN+CuTAizOLgRA9GOppxZcoQNyfpxuFo0T5i/oEdeQuJltLxkCeCWZ6KoRBRPc98f3jatWbt9xrySou+Gf2lY5NSilWrwK1pCTCPNIiOucYdlKWrqFRkofg2Xyl5ukG8QjLd0abQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6C8MPxewC8lfgkjZldhk5MdPnOPvYKi/GF7vUTRU4gs=;
 b=EzRoXmwWkmQH9WhiT3dqauB8pGLvlIHGmqXWV93XyuUMFHCkuDLnK0Ces6OF8GviHUV5UCcVd80vNJ5Rv191pn1d/mZ3lFpZgPFtA62GW6gOW9/4YGOxObMxQVQntPH8u2WaanRG/BwrSchNjBPqxKGFOy1XyE063GR1DVcD2HzlG9wFnITJVi24+zq0x3364grLt3cWEc25QHEnkxsKiemH822xIN0UIASaiAo5GKOaVN50KF7uV0VGLIvI4O1U79rJdZcSV6R8pnUz5W5OTXfE7mZ8yZm9psevtDhYffwN0hNfuCaG1aRV+N4Bin0gqKgnhog8n8zLNnIdtKcfHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 81.255.187.177) smtp.rcpttodomain=redhat.com smtp.mailfrom=exfo.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=exfo.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=EXFO.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6C8MPxewC8lfgkjZldhk5MdPnOPvYKi/GF7vUTRU4gs=;
 b=jTQrsZIzTjmuIiTRWDfefI4N2IVIcaCFGxoWSZ2pjQsZRu7XoENJzPeiaMiwXisz2RWheatMXocGC9Bzuqv3MK9WBmR/Jm0yM5Pu4g0Tnco8kMAPaRATeq0+SfSh2jLdvJ+wUdjdxKRjoQexpzQpaa4b0+Vev+A9JZIxVTYjU0I=
Received: from BN6PR11CA0053.namprd11.prod.outlook.com (2603:10b6:404:f7::15)
 by MN2PR11MB3760.namprd11.prod.outlook.com (2603:10b6:208:fa::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2602.12; Tue, 7 Jan
 2020 17:32:58 +0000
Received: from CO1NAM05FT003.eop-nam05.prod.protection.outlook.com
 (2a01:111:f400:7e50::200) by BN6PR11CA0053.outlook.office365.com
 (2603:10b6:404:f7::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2602.11 via Frontend
 Transport; Tue, 7 Jan 2020 17:32:58 +0000
Authentication-Results: spf=pass (sender IP is 81.255.187.177)
 smtp.mailfrom=exfo.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=exfo.com;
Received-SPF: Pass (protection.outlook.com: domain of exfo.com designates
 81.255.187.177 as permitted sender) receiver=protection.outlook.com;
 client-ip=81.255.187.177; helo=ON_Mail.exfo.com;
Received: from ON_Mail.exfo.com (81.255.187.177) by
 CO1NAM05FT003.mail.protection.outlook.com (10.152.96.108) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.2623.4 via Frontend Transport; Tue, 7 Jan 2020 17:32:57 +0000
Received: from SPRNEXCHANGE01.exfo.com (10.50.50.95) by
 SPRNEXCHANGE01.exfo.com (10.50.50.95) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1531.3; Tue, 7 Jan 2020 18:32:56 +0100
Received: from SPRNEXCHANGE01.exfo.com ([::1]) by SPRNEXCHANGE01.exfo.com
 ([::1]) with mapi id 15.01.1531.010; Tue, 7 Jan 2020 18:32:56 +0100
From:   Gregory Esnaud <Gregory.ESNAUD@exfo.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [Newbie question] Why usage of CPU inside VM and outside VM is
 different
Thread-Topic: [Newbie question] Why usage of CPU inside VM and outside VM is
 different
Thread-Index: AdXFchc6k6fghFvyR2Cb2NX5qpnvFQAAUI6AAAKJVSA=
Date:   Tue, 7 Jan 2020 17:32:55 +0000
Message-ID: <fc4a7dfc9d344facaed8d34adcff3fc4@exfo.com>
References: <8254fdfcfb7c4a82a5fc7a309152528e@exfo.com>
 <a8fb7ace-f52e-3a36-1c53-1db9468404e6@redhat.com>
In-Reply-To: <a8fb7ace-f52e-3a36-1c53-1db9468404e6@redhat.com>
Accept-Language: fr-FR, en-US
Content-Language: fr-FR
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.72.130.123]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:81.255.187.177;IPV:CAL;SCL:-1;CTRY:FR;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(39850400004)(346002)(396003)(136003)(376002)(199004)(189003)(356004)(110136005)(2616005)(316002)(426003)(478600001)(24736004)(108616005)(336012)(8936002)(70206006)(70586007)(36756003)(81156014)(81166006)(8676002)(53546011)(86362001)(5660300002)(966005)(26826003)(26005)(186003)(2906002)(7696005);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3760;H:ON_Mail.exfo.com;FPR:;SPF:Pass;LANG:en;PTR:extranet.astellia.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9b720fcd-ac48-4893-7a96-08d79397a307
X-MS-TrafficTypeDiagnostic: MN2PR11MB3760:
X-Microsoft-Antispam-PRVS: <MN2PR11MB376068B164774841539BFD63F43F0@MN2PR11MB3760.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 027578BB13
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9aQyU8cA6YsKICRsuNNsJsMvaTYNwNezNCOrk39cBhhJcjHy01sCJUWrbnImtPMeFa8GvTMxig1tW5Ph8F6O1mQMyywrpSwWDbTPiV/BvjLYK7wx0oCC2QYrRFGXECZZFSijTB+xN0hIQE3jUQBQB3oqPEEFw3gKm85nVoiXd2cLBE2Pahn7fh2LVO/WFu2ti38+LNpC2hGXn5tp4p2r0/EcW2fb6Pa6z2jghrgUioDZf0N8cDycvYie6KQ++Pz2w1ZN+7n+SzKyEn0izitZwzZJp9R7UlxpP0QYFG5sw7R8nyLoyOlIlNmFYpc9OqWUib26F3eGsCzN/NEyL90gFXERSWEPxqCYagMSc8tOW/qa4KqKkRfePZx64YVKTqKGSEfOBXJ/GTzKohXFVHbjtyktJr5EprwxRnCuASr/1yQOHzIxcQ6NQX2lDVQ52qUuF9Ro4hNMWocDOWrV6lRJgspGPPvz/YlyP/+8qXBjU9w=
X-OriginatorOrg: EXFO.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2020 17:32:57.7633
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b720fcd-ac48-4893-7a96-08d79397a307
X-MS-Exchange-CrossTenant-Id: 1c75be0f-2569-4bcc-95f7-3ad9d904f42a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=1c75be0f-2569-4bcc-95f7-3ad9d904f42a;Ip=[81.255.187.177];Helo=[ON_Mail.exfo.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3760
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgUGFvbG8sDQoNClRoYW5rcyBmb3IgeW91ciBxdWljayBhbnN3ZXIuDQoNCkFyZSB5b3UgdXNp
bmcgb25seSAyIENQVXMgYXQgMTAwJSwgb3IgYXJlIHlvdSB1c2luZyA5IENQVXMgYXQgYSB0b3Rh
bCBvZiAyMDAlPyANCg0KSW5zaWRlIHRoZSBWTSwgYSB0b3AgY29tbWFuZCBzaG93IHRoYXQgd2Ug
YXJlIHVzaW5nIDIgQ1BVIEAgMTAwJTogaHR0cHM6Ly9mcmFtYWRyb3Aub3JnL3IvZ05mM2VySlZm
NiN0MkhMSXB6UEhHdHhIekhlTHJuR0dqc1JTWlpwbXY5SFBWWnQvTElJUDhzPQ0KRnJvbSB0aGUg
aHlwZXJ2aXNvciAoaWUsICpvdXRzaWRlKiB0aGUgdm0pLCBhIHRvcCBjb21tYW5kIHNob3cgdGhh
dCB0aGUgVk0gY29uc3VtaW5nIDkgY3B1OiBodHRwczovL2ZyYW1hZHJvcC5vcmcvci8tRm1yQmhN
R1g1I3EvNmFaOEZxMk1udXp6Mys2Ri9wYTgzVStqelBveDFoZDk4NHR3N0RrdUE9DQoNClNvLCBp
ZiBJJ20gdW5kZXJzdGFuZGluZyB5b3UgY29ycmVjdGx5LCBhbiBwYXJhbWV0ZXIgb2Yga2VybmVs
IG9mIG91ciBWTSBpcyBpZGVsPXBvbGwgdGhhdCB3ZSBzaG91bGQgY2hhbmdlPw0KDQoNClRoYW5r
cyBhZ2FpbiwNCg0KLS0tLS1NZXNzYWdlIGQnb3JpZ2luZS0tLS0tDQpEZcKgOiBQYW9sbyBCb256
aW5pIDxwYm9uemluaUByZWRoYXQuY29tPiANCkVudm95w6nCoDogbWFyZGkgNyBqYW52aWVyIDIw
MjAgMTc6NTkNCsOAwqA6IEdyZWdvcnkgRXNuYXVkIDxHcmVnb3J5LkVTTkFVREBleGZvLmNvbT47
IGt2bUB2Z2VyLmtlcm5lbC5vcmcNCk9iamV0wqA6IFJlOiBbTmV3YmllIHF1ZXN0aW9uXSBXaHkg
dXNhZ2Ugb2YgQ1BVIGluc2lkZSBWTSBhbmQgb3V0c2lkZSBWTSBpcyBkaWZmZXJlbnQNCg0KT24g
MDcvMDEvMjAgMTY6NTcsIEdyZWdvcnkgRXNuYXVkIHdyb3RlOg0KPiANCj4gRnJvbSBhbiBoeXBl
cnZpc29yICh2aWEgdG9wIGNvbW1hbmQpIHBvaW50IG9mIHZpZXcgb3VyIFZNIGlzIGNvbnN1bWlu
ZyANCj4gOSBDUFUgKDkwMCUpLiBUaGlzIHdhcyByZXBvcnRlZCBieSBvdXIgcGxhdGZvcm0gcHJv
dmlkZXIuDQo+IEZyb20gYSBWTSBwb2ludCBvZiB2aWV3IHdlIGFyZSBjb25zdW1pbmcgb25seSAy
IENQVSAoMjAwJSksIHdpdGggYSB0b3AgDQo+IGFsc28uDQo+IA0KPiBPdXIgcHJvdmlkZXIgY2xh
aW0gdXMgdG8gZXhwbGFpbiB3aHkgd2UgYXJlIGNvbnN1bWluZyBzbyBtdWNoIENQVS4NCj4gQnV0
IHdlIGNhbm5vdCB0cm91Ymxlc2hvb3QgdGhlIGluZnJhIGFzIGl0J3Mgbm90IG91ciByZXNwb25z
aWJpbGl0eS4NCj4gRnJvbSBvdXIgcG9pbnQgb2YgdmlldywgZXZlcnl0aGluZyBpcyBvay4NCg0K
QXJlIHlvdSB1c2luZyBvbmx5IDIgQ1BVcyBhdCAxMDAlLCBvciBhcmUgeW91IHVzaW5nIDkgQ1BV
cyBhdCBhIHRvdGFsIG9mIDIwMCU/ICBJZiB0aGUgZm9ybWVyLCBpdCBpcyBwb3NzaWJsZSB0aGF0
IHlvdSBhcmUgdXNpbmcgc29tZXRoaW5nIGxpa2UgaWRsZT1wb2xsLCBzbyB0aGUgbWFjaGluZSBf
aXNfIGlkbGUgYnV0IHN0aWxsIGNvbnN1bWluZyAxMDAlIGhvc3QgQ1BVLg0KVGhpcyBpcyBzb21l
dGhpbmcgdGhhdCB5b3Ugc2hvdWxkIGtub3csIGhvd2V2ZXIuDQoNCklmIHRoZSBsYXR0ZXIsIHRo
ZSBob3N0IGlzIHByb2JhYmx5IGRvaW5nIGEgbGl0dGxlIGJpdCBvZiBidXN5IHdhaXRpbmcgdG8g
aW1wcm92ZSB5b3VyIHBlcmZvcm1hbmNlLiAgVGhlIHByb3ZpZGVyIGNhbiBkaXNhYmxlIGl0IHVz
aW5nIHRoZQ0Ka3ZtLmhhbHRfcG9sbF9ucz0wIG1vZHVsZSBwYXJhbWV0ZXIgYW5kIHRoZXJlIGlz
IG5vdGhpbmcgdGhhdCB5b3UgY2FuIGRvIGFib3V0IGl0LiAgQnV0IGl0IGlzIHVubGlrZWx5IHRo
YXQgaXQgY2F1c2VzIHRoZSB1dGlsaXphdGlvbiB0byBqdW1wIHNvIG11Y2guDQoNClBhb2xvDQoN
Cg==
