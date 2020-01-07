Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51324132E41
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2020 19:18:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728580AbgAGSSr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jan 2020 13:18:47 -0500
Received: from mail-dm6nam10on2046.outbound.protection.outlook.com ([40.107.93.46]:41344
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727925AbgAGSSq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jan 2020 13:18:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ha2tYIv6oPABArATIV9vDYQQIm6occLN1fpqhJ17VFPJVo64dTvnb964e+KpLHd0FrTTxrfePMWBM/ZDREjla+zHXigYx77SjH/YgDPwS7TyXuiUPgH/rWzfprtPbnfhFSM8c+wmgY+cmzTtmaC1xgz8LK+cxsUw4ddKbhm4Ei6O23MVEpUXmI8ikXeIoHjvM1EFEPiWZvq25cokZ5T5LKrpoA3BuJDuN5We1ZOb5+J2/lD33bbVE76LwpPBxoQFKUmVTDS3JiovXEjYFNDGFMwU70dcKLcMTB/dTPYsEXOX97LPdrg3EZUxhbnIEQp5uOfHpYUXuWVMRwSFHPykRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tvvofV9RvnZs/cxQtu1sZWrMobnvYe7A0/neRbqzefw=;
 b=B3l75zPgi+TlhnrjHYXdvF8/KoQcr8ROg0DUGEbZHwgtwkrlim2P+dyfSUTF5S/f5/1qFXDRDsqJIkcat/Cz3wMy2uGbg8mnHzMzg+izrWk/LBy7WU5TysrdJ36gmd2HDMqOk1mejP8PhuPVZwwPfQM+1cDdzehDlKFx28ZbQ12c0gCwTnIoN4ax5sGqFU3ZbP7+Kfv7W49y4pU3xR5dQOfmVBYZZo+Yk+t4VWX8vPDAx1WPH7nPBBezIKAMlu+Xyvn9b0g1vEgkHUn8KmXi4Z3LKZD/APAjuXBJEriQ/iiHg3Dd8fOXLYlYN38PjZZ8cuQSmWz2j8E/8cUlh8tlyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 81.255.187.177) smtp.rcpttodomain=redhat.com smtp.mailfrom=exfo.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=exfo.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=EXFO.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tvvofV9RvnZs/cxQtu1sZWrMobnvYe7A0/neRbqzefw=;
 b=NP2dICqIHw/pE00+QmXu8/C+eF5a5ljgig2SJZXLvUcrA0MRSCy4h0EvyupXauNYuOag+tyyRcCtqJ1Egb5elGiF8GjEcOfUSPLPpPrtf7iIJvwP7rjh6/dXvVCuUZoHqDwIpXNRV/zs0g5L347q8UutlAtqm1Mi62nNYYegaOA=
Received: from BN6PR11CA0028.namprd11.prod.outlook.com (2603:10b6:404:4b::14)
 by MWHPR11MB1949.namprd11.prod.outlook.com (2603:10b6:300:110::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2602.11; Tue, 7 Jan
 2020 18:18:43 +0000
Received: from CO1NAM05FT035.eop-nam05.prod.protection.outlook.com
 (2a01:111:f400:7e50::209) by BN6PR11CA0028.outlook.office365.com
 (2603:10b6:404:4b::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.9 via Frontend
 Transport; Tue, 7 Jan 2020 18:18:42 +0000
Authentication-Results: spf=pass (sender IP is 81.255.187.177)
 smtp.mailfrom=exfo.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=exfo.com;
Received-SPF: Pass (protection.outlook.com: domain of exfo.com designates
 81.255.187.177 as permitted sender) receiver=protection.outlook.com;
 client-ip=81.255.187.177; helo=ON_Mail.exfo.com;
Received: from ON_Mail.exfo.com (81.255.187.177) by
 CO1NAM05FT035.mail.protection.outlook.com (10.152.96.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.2623.4 via Frontend Transport; Tue, 7 Jan 2020 18:18:41 +0000
Received: from SPRNEXCHANGE01.exfo.com (10.50.50.95) by
 SPRNEXCHANGE01.exfo.com (10.50.50.95) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1531.3; Tue, 7 Jan 2020 19:18:39 +0100
Received: from SPRNEXCHANGE01.exfo.com ([::1]) by SPRNEXCHANGE01.exfo.com
 ([::1]) with mapi id 15.01.1531.010; Tue, 7 Jan 2020 19:18:39 +0100
From:   Gregory Esnaud <Gregory.ESNAUD@exfo.com>
To:     Gregory Esnaud <Gregory.ESNAUD@exfo.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [Newbie question] Why usage of CPU inside VM and outside VM is
 different
Thread-Topic: [Newbie question] Why usage of CPU inside VM and outside VM is
 different
Thread-Index: AdXFchc6k6fghFvyR2Cb2NX5qpnvFQAAUI6AAAKJVSD///YxgP//7wbw///SzZA=
Date:   Tue, 7 Jan 2020 18:18:39 +0000
Message-ID: <ea7c7d0448d24fe1b426e313c7df19c6@exfo.com>
References: <8254fdfcfb7c4a82a5fc7a309152528e@exfo.com>
 <a8fb7ace-f52e-3a36-1c53-1db9468404e6@redhat.com>
 <fc4a7dfc9d344facaed8d34adcff3fc4@exfo.com>
 <3193f727-1031-b76b-4b3b-302316c9d058@redhat.com>
 <ab0ccf4e4ed14b058f859197f204083f@exfo.com>
In-Reply-To: <ab0ccf4e4ed14b058f859197f204083f@exfo.com>
Accept-Language: fr-FR, en-US
Content-Language: fr-FR
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.72.130.123]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:81.255.187.177;IPV:CAL;SCL:-1;CTRY:FR;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(376002)(39850400004)(136003)(396003)(346002)(189003)(199004)(24736004)(81166006)(8936002)(5660300002)(2906002)(36756003)(86362001)(70586007)(108616005)(8676002)(81156014)(70206006)(7696005)(478600001)(110136005)(316002)(2616005)(26826003)(966005)(186003)(26005)(336012)(356004)(53546011)(426003);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR11MB1949;H:ON_Mail.exfo.com;FPR:;SPF:Pass;LANG:en;PTR:extranet.astellia.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2ebad802-cb89-44ee-1173-08d7939e068b
X-MS-TrafficTypeDiagnostic: MWHPR11MB1949:
X-Microsoft-Antispam-PRVS: <MWHPR11MB1949D5219F67236F603ECBDAF43F0@MWHPR11MB1949.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 027578BB13
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kamLj9cMhwRvd++IiC/XDJvQSfuYzbJBQ47cZKHAjdC00HK2DQFJmaAHNGut68+zwVHogZ2nlHbww4pzasOlmsTPgEBToVWgWuu7F2IZrSk7wLhxZ8XMDR+UhVkU+OtC1nPpC4xrgLhQ9hg2Cl44HJNvX3pqRlIFUCQmQIF2y00NthGVB2WZgZ9OEcmajKRZEIR1p4QqpBhBTRlej6DMXQyIf1TIL3eudsxRS6IY+lLmg+RahuTZlWqV6UzUdorMy1sKuDQj6XOplANVaLckcTxtHgfnwKx/zQoLvxaadk8ON5ztY4CpzeLCknpPNgJbt+eHnIIqfrvkRCy37CKgzVsjczXb4hiMM//hoTmNIdNpOINqZRxf8l+fFmUE2lcywHdPmdSt06UnfP8ApaDfI8yfD0fki57G86C4ndQBlGx+K8siDjtFp2NtheO6HknPiPFKapIxPzQUpimuPHaUAYR4vUmyvsbe6D1pQTvxKkE=
X-OriginatorOrg: EXFO.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2020 18:18:41.7005
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ebad802-cb89-44ee-1173-08d7939e068b
X-MS-Exchange-CrossTenant-Id: 1c75be0f-2569-4bcc-95f7-3ad9d904f42a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=1c75be0f-2569-4bcc-95f7-3ad9d904f42a;Ip=[81.255.187.177];Helo=[ON_Mail.exfo.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1949
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

UGFvbG8sDQoNCkluIGluc3RhbnRpYXRlZCBhIFZNIHRvIHRyeSBpZGVsPXBvbGwuDQoNCkJlZm9y
ZSBtb2RpZnkga2VybmVsIHBhcmFtZXRlcnMsIEkgd291bGQgbGlrZSB0byBjaGVjayBjdXJyZW50
IGNvbmZpZy4uLiBzYWRlbHkgbm90aGluZyBhdCBhbGwgdGFsayBhYm91dCBpZGxlOiANCg0Kcm9v
dEBpbXNwcm9iZTA6L2hvbWUvYWRtX2FzdGVsbGlhIyBjYXQgL3Byb2MvY21kbGluZQ0Kcm8gcm9v
dD0vZGV2L21hcHBlci9yaGVsLXJvb3QgcmRfTk9fTFVLUyBMQU5HPWVuX1VTLlVURi04IHJkX0xW
TV9MVj1yaGVsL3Jvb3QgcmRfTk9fTUQgU1lTRk9OVD1sYXRhcmN5cmhlYi1zdW4xNiAgS0VZQk9B
UkRUWVBFPXBjIEtFWVRBQkxFPXVzIGNyYXNoa2VybmVsPTEyOU1ANDhNIHJoZ2IgcXVpZXQgcmRf
Tk9fRE0gcmhnYiBxdWlldCBjb25zb2xlPXR0eVMwDQpyb290QGltc3Byb2JlMDovaG9tZS9hZG1f
YXN0ZWxsaWEjIHN5c2N0bCAtYXxncmVwIC1pIGlkbGUNCmtlcm5lbC5zY2hlZF9kb21haW4uY3B1
MC5kb21haW4wLmlkbGVfaWR4ID0gMQ0Ka2VybmVsLnNjaGVkX2RvbWFpbi5jcHUwLmRvbWFpbjAu
bmV3aWRsZV9pZHggPSAwDQprZXJuZWwuc2NoZWRfZG9tYWluLmNwdTEuZG9tYWluMC5pZGxlX2lk
eCA9IDENCmtlcm5lbC5zY2hlZF9kb21haW4uY3B1MS5kb21haW4wLm5ld2lkbGVfaWR4ID0gMA0K
a2VybmVsLnNjaGVkX2RvbWFpbi5jcHUyLmRvbWFpbjAuaWRsZV9pZHggPSAxDQprZXJuZWwuc2No
ZWRfZG9tYWluLmNwdTIuZG9tYWluMC5uZXdpZGxlX2lkeCA9IDANCmtlcm5lbC5zY2hlZF9kb21h
aW4uY3B1My5kb21haW4wLmlkbGVfaWR4ID0gMQ0Ka2VybmVsLnNjaGVkX2RvbWFpbi5jcHUzLmRv
bWFpbjAubmV3aWRsZV9pZHggPSAwDQprZXJuZWwuc2NoZWRfZG9tYWluLmNwdTQuZG9tYWluMC5p
ZGxlX2lkeCA9IDENCmtlcm5lbC5zY2hlZF9kb21haW4uY3B1NC5kb21haW4wLm5ld2lkbGVfaWR4
ID0gMA0Ka2VybmVsLnNjaGVkX2RvbWFpbi5jcHU1LmRvbWFpbjAuaWRsZV9pZHggPSAxDQprZXJu
ZWwuc2NoZWRfZG9tYWluLmNwdTUuZG9tYWluMC5uZXdpZGxlX2lkeCA9IDANCmtlcm5lbC5zY2hl
ZF9kb21haW4uY3B1Ni5kb21haW4wLmlkbGVfaWR4ID0gMQ0Ka2VybmVsLnNjaGVkX2RvbWFpbi5j
cHU2LmRvbWFpbjAubmV3aWRsZV9pZHggPSAwDQpuZXQuaXB2NC50Y3Bfc2xvd19zdGFydF9hZnRl
cl9pZGxlID0gMQ0KDQoNCkNoZWVycywNCg0KDQotLS0tLU1lc3NhZ2UgZCdvcmlnaW5lLS0tLS0N
CkRlwqA6IGt2bS1vd25lckB2Z2VyLmtlcm5lbC5vcmcgPGt2bS1vd25lckB2Z2VyLmtlcm5lbC5v
cmc+IERlIGxhIHBhcnQgZGUgR3JlZ29yeSBFc25hdWQNCkVudm95w6nCoDogbWFyZGkgNyBqYW52
aWVyIDIwMjAgMTg6MzgNCsOAwqA6IFBhb2xvIEJvbnppbmkgPHBib256aW5pQHJlZGhhdC5jb20+
OyBrdm1Admdlci5rZXJuZWwub3JnDQpPYmpldMKgOiBSRTogW05ld2JpZSBxdWVzdGlvbl0gV2h5
IHVzYWdlIG9mIENQVSBpbnNpZGUgVk0gYW5kIG91dHNpZGUgVk0gaXMgZGlmZmVyZW50DQoNCj4g
VGhhdCdzIGEgcG9zc2liaWxpdHkuICBBbmQgaWYgaXQncyBjb3JyZWN0LCB5b3VyIHByb3ZpZGVy
IGlzIGNlcnRhaW5seSANCj4gY29ycmVjdCBpbiBjb21wbGFpbmluZy4gOikNClllcywgYnV0IGFz
IGEgY2xvdWQgcHJvdmlkZXIgaGUgc2hvdWxkIHByb3ZpZGUgdXMgcHJlcmVxdWlzaXRlcyBvbiBW
TSBjb25maWcg8J+YiS4NCg0KSSB3aWxsIGdpdmUgaXQgYSB0cnkhDQoNClRoYW5rcyENCg0KLS0t
LS1NZXNzYWdlIGQnb3JpZ2luZS0tLS0tDQpEZcKgOiBQYW9sbyBCb256aW5pIDxwYm9uemluaUBy
ZWRoYXQuY29tPiBFbnZvecOpwqA6IG1hcmRpIDcgamFudmllciAyMDIwIDE4OjM2IMOAwqA6IEdy
ZWdvcnkgRXNuYXVkIDxHcmVnb3J5LkVTTkFVREBleGZvLmNvbT47IGt2bUB2Z2VyLmtlcm5lbC5v
cmcgT2JqZXTCoDogUmU6IFtOZXdiaWUgcXVlc3Rpb25dIFdoeSB1c2FnZSBvZiBDUFUgaW5zaWRl
IFZNIGFuZCBvdXRzaWRlIFZNIGlzIGRpZmZlcmVudA0KDQpPbiAwNy8wMS8yMCAxODozMiwgR3Jl
Z29yeSBFc25hdWQgd3JvdGU6DQo+IEhpIFBhb2xvLA0KPiANCj4gVGhhbmtzIGZvciB5b3VyIHF1
aWNrIGFuc3dlci4NCj4gDQo+IEFyZSB5b3UgdXNpbmcgb25seSAyIENQVXMgYXQgMTAwJSwgb3Ig
YXJlIHlvdSB1c2luZyA5IENQVXMgYXQgYSB0b3RhbCBvZiAyMDAlPyANCj4gDQo+IEluc2lkZSB0
aGUgVk0sIGEgdG9wIGNvbW1hbmQgc2hvdyB0aGF0IHdlIGFyZSB1c2luZyAyIENQVSBAIDEwMCU6
IA0KPiBodHRwczovL2ZyYW1hZHJvcC5vcmcvci9nTmYzZXJKVmY2I3QySExJcHpQSEd0eEh6SGVM
cm5HR2pzUlNaWnBtdjlIUFZaDQo+IHQvTElJUDhzPSBGcm9tIHRoZSBoeXBlcnZpc29yIChpZSwg
Km91dHNpZGUqIHRoZSB2bSksIGEgdG9wIGNvbW1hbmQgDQo+IHNob3cgdGhhdCB0aGUgVk0gY29u
c3VtaW5nIDkgY3B1Og0KPiBodHRwczovL2ZyYW1hZHJvcC5vcmcvci8tRm1yQmhNR1g1I3EvNmFa
OEZxMk1udXp6Mys2Ri9wYTgzVStqelBveDFoZDk4DQo+IDR0dzdEa3VBPQ0KPiANCj4gU28sIGlm
IEknbSB1bmRlcnN0YW5kaW5nIHlvdSBjb3JyZWN0bHksIGFuIHBhcmFtZXRlciBvZiBrZXJuZWwg
b2Ygb3VyIFZNIGlzIGlkZWw9cG9sbCB0aGF0IHdlIHNob3VsZCBjaGFuZ2U/DQo+IA0KDQpUaGF0
J3MgYSBwb3NzaWJpbGl0eS4gIEFuZCBpZiBpdCdzIGNvcnJlY3QsIHlvdXIgcHJvdmlkZXIgaXMg
Y2VydGFpbmx5IGNvcnJlY3QgaW4gY29tcGxhaW5pbmcuIDopDQoNClBhb2xvDQoNCg==
