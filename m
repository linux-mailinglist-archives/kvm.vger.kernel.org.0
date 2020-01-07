Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 906F1132D34
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2020 18:38:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728391AbgAGRiC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jan 2020 12:38:02 -0500
Received: from mail-eopbgr770089.outbound.protection.outlook.com ([40.107.77.89]:30852
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728344AbgAGRiC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jan 2020 12:38:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WrFeP5rKvx70dRFt9uR5JF4KgjI1UCn5QZkX+Kjk+9UNDQboVoTrzbP2b2NN5/zBKdx49rFxlIggJGzk4xC3/FKIteunLWDUJITplAn5hLiV0SAfsxj5UIGGZ6K41m172qs9DETxOuqZ96fJQ8mEhY+b/DUWt9qM59kR45QVf20S2kA+z51s5zLsFon94mWFyovT8bYtOUnqH9EhxwAsD2dE/d94vlDKl0DdNoYzgspJhGws7bTFcvIb+pEpRLojplGtPHYQwCwkX+dthFGpLnXoUc3ZS9X4yIjTN0l4CtSbN+HI77io+htSnBLC3jyZwAfe8syFchIwuaZ5C1Ux/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3P6FHk2oK+RbLU4dn7rR2DTbNY9syJsy580x+71sU/A=;
 b=K+kL7TCj/5QCOt9A8Hom1hM5flUyed5zqTyswWQaGjsKIn/1JUjBo0Rbx1BbzDPJapQzRuZ8YaqqqmW6CaVEmhJZD9hn97ng10rI0xS7d5j/2hf9XtFVWuR6R07NH+KREbG91wRe6CX3mA9KnehAOrfxlPYctOxqbQ020+mOOuos779rB5fd+mMQ3kbu1uA0oZYkzHOo/RecA/HtZFWjx+QyGB51x2mznxuGLMrDY5yF9K0K5ZriDKHcvnZvPhXGUqeZLDJAIyksJG6vXVULDqmkOl39oDShN36uXPm+idZ7ow1/Nwy+WzptRmOYdeeh6jVBR0gtMpRwH7clZIThbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 81.255.187.177) smtp.rcpttodomain=redhat.com smtp.mailfrom=exfo.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=exfo.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=EXFO.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3P6FHk2oK+RbLU4dn7rR2DTbNY9syJsy580x+71sU/A=;
 b=gsKXVUrFe7ZQQNTZQuFOy7+RuNYL1kajpDcetjafF2RDB8MjcYQrnPTkasoftycy6FQ8XrFqG6G6FAaLIrnnB6MDvCfd6pcXM76mzir18my5WRZDtmdKNwf0ypb3FR4l0WtpLM3+Apau2p41843Kwr/ivxQDt9j7yU+vQWQFRUk=
Received: from DM5PR11CA0015.namprd11.prod.outlook.com (2603:10b6:3:115::25)
 by MWHPR11MB1808.namprd11.prod.outlook.com (2603:10b6:300:10f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2602.12; Tue, 7 Jan
 2020 17:37:59 +0000
Received: from CO1NAM05FT010.eop-nam05.prod.protection.outlook.com
 (2a01:111:f400:7e50::204) by DM5PR11CA0015.outlook.office365.com
 (2603:10b6:3:115::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2602.11 via Frontend
 Transport; Tue, 7 Jan 2020 17:37:59 +0000
Authentication-Results: spf=pass (sender IP is 81.255.187.177)
 smtp.mailfrom=exfo.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=exfo.com;
Received-SPF: Pass (protection.outlook.com: domain of exfo.com designates
 81.255.187.177 as permitted sender) receiver=protection.outlook.com;
 client-ip=81.255.187.177; helo=ON_Mail.exfo.com;
Received: from ON_Mail.exfo.com (81.255.187.177) by
 CO1NAM05FT010.mail.protection.outlook.com (10.152.96.117) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.2623.4 via Frontend Transport; Tue, 7 Jan 2020 17:37:58 +0000
Received: from SPRNEXCHANGE01.exfo.com (10.50.50.95) by
 SPRNEXCHANGE01.exfo.com (10.50.50.95) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1531.3; Tue, 7 Jan 2020 18:37:56 +0100
Received: from SPRNEXCHANGE01.exfo.com ([::1]) by SPRNEXCHANGE01.exfo.com
 ([::1]) with mapi id 15.01.1531.010; Tue, 7 Jan 2020 18:37:56 +0100
From:   Gregory Esnaud <Gregory.ESNAUD@exfo.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [Newbie question] Why usage of CPU inside VM and outside VM is
 different
Thread-Topic: [Newbie question] Why usage of CPU inside VM and outside VM is
 different
Thread-Index: AdXFchc6k6fghFvyR2Cb2NX5qpnvFQAAUI6AAAKJVSD///YxgP//7wbw
Date:   Tue, 7 Jan 2020 17:37:56 +0000
Message-ID: <ab0ccf4e4ed14b058f859197f204083f@exfo.com>
References: <8254fdfcfb7c4a82a5fc7a309152528e@exfo.com>
 <a8fb7ace-f52e-3a36-1c53-1db9468404e6@redhat.com>
 <fc4a7dfc9d344facaed8d34adcff3fc4@exfo.com>
 <3193f727-1031-b76b-4b3b-302316c9d058@redhat.com>
In-Reply-To: <3193f727-1031-b76b-4b3b-302316c9d058@redhat.com>
Accept-Language: fr-FR, en-US
Content-Language: fr-FR
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.72.130.123]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:81.255.187.177;IPV:CAL;SCL:-1;CTRY:FR;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(39850400004)(396003)(346002)(376002)(136003)(189003)(199004)(186003)(356004)(86362001)(36756003)(316002)(24736004)(53546011)(7696005)(2616005)(108616005)(426003)(110136005)(26005)(81166006)(81156014)(8936002)(8676002)(70586007)(70206006)(5660300002)(336012)(26826003)(2906002)(478600001)(966005);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR11MB1808;H:ON_Mail.exfo.com;FPR:;SPF:Pass;LANG:en;PTR:extranet.astellia.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ccb36914-d1aa-468f-729c-08d79398564d
X-MS-TrafficTypeDiagnostic: MWHPR11MB1808:
X-Microsoft-Antispam-PRVS: <MWHPR11MB1808AEFE5509E176D6B8EED2F43F0@MWHPR11MB1808.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 027578BB13
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9BHsnvBc0NgBokcovMQ0lBnu/QxmIRFpQhHMIOIsXvNVWX/Jb6CvW6/puO+hXI27CtlREmQ7/lZk0WbawvQiLt+2+cL9dvlWn+/DzHXxR4tW6N5a/Hh1YnHqM5b6hdsdu+tzPWdlXwsVXn5A3pcMLzMyF31oRQ0CdWHalURkJDHdkt7EkXLiFJuzFNXELlVznas73ysIpwtEPEjXdFBtrvBKiXr0aGJxsLPht+pag9ToDHhiT/o2YWqcTf5loC/Sqq6pxRM5hiq+FrWaBwKB76YvNo9le55gPh8iZfSjywA6gMdcUIA0WE7UOI1L9lZbhbrUb9L9DBtYZHq7V4l/6gJKHRdvTcDU1cD4bFGlAPdmFhfdNozs/i/2UOZp/Wp1Q3K9EqA/XAoYuyfy3CIfG8eF5ArOtHuiOl/g3dOfLBKxq5fLdK/+c/UgoBJyMEFgr3VzDYV8sZJ3ce2EX4adK24KdJ3F9zGrBc+AlSQ8ev/drxsyn6b6+241plBZe0ixOBZeZPhPGZnLSfFFfYTbvw==
X-OriginatorOrg: EXFO.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2020 17:37:58.5330
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ccb36914-d1aa-468f-729c-08d79398564d
X-MS-Exchange-CrossTenant-Id: 1c75be0f-2569-4bcc-95f7-3ad9d904f42a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=1c75be0f-2569-4bcc-95f7-3ad9d904f42a;Ip=[81.255.187.177];Helo=[ON_Mail.exfo.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1808
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBUaGF0J3MgYSBwb3NzaWJpbGl0eS4gIEFuZCBpZiBpdCdzIGNvcnJlY3QsIHlvdXIgcHJvdmlk
ZXIgaXMgY2VydGFpbmx5IGNvcnJlY3QgaW4gY29tcGxhaW5pbmcuIDopDQpZZXMsIGJ1dCBhcyBh
IGNsb3VkIHByb3ZpZGVyIGhlIHNob3VsZCBwcm92aWRlIHVzIHByZXJlcXVpc2l0ZXMgb24gVk0g
Y29uZmlnIPCfmIkuDQoNCkkgd2lsbCBnaXZlIGl0IGEgdHJ5IQ0KDQpUaGFua3MhDQoNCi0tLS0t
TWVzc2FnZSBkJ29yaWdpbmUtLS0tLQ0KRGXCoDogUGFvbG8gQm9uemluaSA8cGJvbnppbmlAcmVk
aGF0LmNvbT4gDQpFbnZvecOpwqA6IG1hcmRpIDcgamFudmllciAyMDIwIDE4OjM2DQrDgMKgOiBH
cmVnb3J5IEVzbmF1ZCA8R3JlZ29yeS5FU05BVURAZXhmby5jb20+OyBrdm1Admdlci5rZXJuZWwu
b3JnDQpPYmpldMKgOiBSZTogW05ld2JpZSBxdWVzdGlvbl0gV2h5IHVzYWdlIG9mIENQVSBpbnNp
ZGUgVk0gYW5kIG91dHNpZGUgVk0gaXMgZGlmZmVyZW50DQoNCk9uIDA3LzAxLzIwIDE4OjMyLCBH
cmVnb3J5IEVzbmF1ZCB3cm90ZToNCj4gSGkgUGFvbG8sDQo+IA0KPiBUaGFua3MgZm9yIHlvdXIg
cXVpY2sgYW5zd2VyLg0KPiANCj4gQXJlIHlvdSB1c2luZyBvbmx5IDIgQ1BVcyBhdCAxMDAlLCBv
ciBhcmUgeW91IHVzaW5nIDkgQ1BVcyBhdCBhIHRvdGFsIG9mIDIwMCU/IA0KPiANCj4gSW5zaWRl
IHRoZSBWTSwgYSB0b3AgY29tbWFuZCBzaG93IHRoYXQgd2UgYXJlIHVzaW5nIDIgQ1BVIEAgMTAw
JTogDQo+IGh0dHBzOi8vZnJhbWFkcm9wLm9yZy9yL2dOZjNlckpWZjYjdDJITElwelBIR3R4SHpI
ZUxybkdHanNSU1pacG12OUhQVloNCj4gdC9MSUlQOHM9IEZyb20gdGhlIGh5cGVydmlzb3IgKGll
LCAqb3V0c2lkZSogdGhlIHZtKSwgYSB0b3AgY29tbWFuZCANCj4gc2hvdyB0aGF0IHRoZSBWTSBj
b25zdW1pbmcgOSBjcHU6IA0KPiBodHRwczovL2ZyYW1hZHJvcC5vcmcvci8tRm1yQmhNR1g1I3Ev
NmFaOEZxMk1udXp6Mys2Ri9wYTgzVStqelBveDFoZDk4DQo+IDR0dzdEa3VBPQ0KPiANCj4gU28s
IGlmIEknbSB1bmRlcnN0YW5kaW5nIHlvdSBjb3JyZWN0bHksIGFuIHBhcmFtZXRlciBvZiBrZXJu
ZWwgb2Ygb3VyIFZNIGlzIGlkZWw9cG9sbCB0aGF0IHdlIHNob3VsZCBjaGFuZ2U/DQo+IA0KDQpU
aGF0J3MgYSBwb3NzaWJpbGl0eS4gIEFuZCBpZiBpdCdzIGNvcnJlY3QsIHlvdXIgcHJvdmlkZXIg
aXMgY2VydGFpbmx5IGNvcnJlY3QgaW4gY29tcGxhaW5pbmcuIDopDQoNClBhb2xvDQoNCg==
