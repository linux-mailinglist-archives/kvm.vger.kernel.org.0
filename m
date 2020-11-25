Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE822C35E9
	for <lists+kvm@lfdr.de>; Wed, 25 Nov 2020 02:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727727AbgKYBFj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Nov 2020 20:05:39 -0500
Received: from mail-db8eur05on2083.outbound.protection.outlook.com ([40.107.20.83]:22471
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726249AbgKYBFi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Nov 2020 20:05:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OWGsz1eGflFlQyJItS3FJ3oUxcvf/qkLoi6POtDjwRw=;
 b=25OO1En29FxOAHwBt+TzOnOn6Gg8zQeZFg+lusiYOYOaltm1MzGyAHThL6gj85TpRFE2IvCxntMxPaHn3m8taLLVdSeePIj1KwF9AK7CP6/SeJiqqWojBp0v8Wh2UJWVTC8O+PML++1VUnyORdTi3tKGuOxiWyZvLlE0ysxT+Vo=
Received: from DB6PR07CA0187.eurprd07.prod.outlook.com (2603:10a6:6:42::17) by
 AM0PR08MB5393.eurprd08.prod.outlook.com (2603:10a6:208:18c::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3611.20; Wed, 25 Nov 2020 01:05:33 +0000
Received: from DB5EUR03FT023.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:6:42:cafe::41) by DB6PR07CA0187.outlook.office365.com
 (2603:10a6:6:42::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.11 via Frontend
 Transport; Wed, 25 Nov 2020 01:05:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT023.mail.protection.outlook.com (10.152.20.68) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3589.20 via Frontend Transport; Wed, 25 Nov 2020 01:05:32 +0000
Received: ("Tessian outbound fcd5bc555ddc:v71"); Wed, 25 Nov 2020 01:05:32 +0000
X-CR-MTA-TID: 64aa7808
Received: from 148b9a89a34c.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id EDCBCDB7-81EF-489A-B503-EF93A9E7CB5C.1;
        Wed, 25 Nov 2020 01:05:27 +0000
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 148b9a89a34c.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Wed, 25 Nov 2020 01:05:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=beRk+GO1M1C/EsIRXyC+l00DIVDgWof6u6t70nxT8Kk8bI/RA77H7yqqdwjFBixMWol3tJzcHCmCzjOzaz7/pojrfjlf4OX5tneoSb3xr/DhvyI5o7gwXorC+tecZHYPzXm6mq9CISDV4ocM38nxT88fhNTPdBIpICFcM1Oz9DMy3HaZMQ45Gxk7O1XnX/6M4+jYwCsAPiGwISle2S/UJ1RGPmNp7mF1ac/wW2H+Chkd3P08/dSLXckg6WJFXh8XkmHusCZt4pG1UTGCq/e6wEjPq5rb956tWGIzqSrd1IVOvlArWvRaiIrN4JWpnNL9uhIKWiMixtqHzB+7df4Eqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OWGsz1eGflFlQyJItS3FJ3oUxcvf/qkLoi6POtDjwRw=;
 b=hedoU+3q4qc4ileJibIDAdqnPatPGeI6Iy5EVh1zfTtP0PiR4HIrUQ2u9+CMIgvch2fuOpxEN2eSdBauvVSdK/Bk1QeW78frvjqqEiPW57byv96gMmpAAZjP/YbzaGOvI44jBSNIGlGmm4mB43zpF7XaNPCd79vdeeYCwoU4YRFi+ia60ViSYz1rcGQ10JOzAQw916vcT0RKrCpgMHQalD0+ofQiIkaPAQQfzpGp265GB2F9s+6EVHWkvg1h+Cynt5iRD3x9v65Dm9M4hW2qr5agfBQIj1mEtbo0Cs+CyZzcdklMNpevfgJKEo0I91TcDlmXHfBwG73wgZV7LRRw0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OWGsz1eGflFlQyJItS3FJ3oUxcvf/qkLoi6POtDjwRw=;
 b=25OO1En29FxOAHwBt+TzOnOn6Gg8zQeZFg+lusiYOYOaltm1MzGyAHThL6gj85TpRFE2IvCxntMxPaHn3m8taLLVdSeePIj1KwF9AK7CP6/SeJiqqWojBp0v8Wh2UJWVTC8O+PML++1VUnyORdTi3tKGuOxiWyZvLlE0ysxT+Vo=
Received: from AM6PR08MB3224.eurprd08.prod.outlook.com (2603:10a6:209:47::13)
 by AM6PR08MB4852.eurprd08.prod.outlook.com (2603:10a6:20b:cc::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.25; Wed, 25 Nov
 2020 01:05:26 +0000
Received: from AM6PR08MB3224.eurprd08.prod.outlook.com
 ([fe80::98:7f10:6467:b45]) by AM6PR08MB3224.eurprd08.prod.outlook.com
 ([fe80::98:7f10:6467:b45%7]) with mapi id 15.20.3589.030; Wed, 25 Nov 2020
 01:05:25 +0000
From:   Justin He <Justin.He@arm.com>
To:     Peter Xu <peterx@redhat.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stefan Hajnoczi <stefanha@redhat.com>
Subject: RE: [PATCH] vfio iommu type1: Bypass the vma permission check in
 vfio_pin_pages_remote()
Thread-Topic: [PATCH] vfio iommu type1: Bypass the vma permission check in
 vfio_pin_pages_remote()
Thread-Index: AQHWvoBE9VjkV/EoWUaRm8NTyyUuUKnXnbsAgABuRoA=
Date:   Wed, 25 Nov 2020 01:05:25 +0000
Message-ID: <AM6PR08MB32245E7F990955395B44CE6BF7FA0@AM6PR08MB3224.eurprd08.prod.outlook.com>
References: <20201119142737.17574-1-justin.he@arm.com>
 <20201124181228.GA276043@xz-x1>
In-Reply-To: <20201124181228.GA276043@xz-x1>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 05FD380247F12D4C86FFAAE27F97F788.0
x-checkrecipientchecked: true
Authentication-Results-Original: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=arm.com;
x-originating-ip: [203.126.0.113]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 160c49ec-5038-4210-368f-08d890de359b
x-ms-traffictypediagnostic: AM6PR08MB4852:|AM0PR08MB5393:
X-Microsoft-Antispam-PRVS: <AM0PR08MB53932732E7CAFC21D4FD1F3FF7FA0@AM0PR08MB5393.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:9508;OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: TJiLNzJXlgJtsCzOuE0FVbTcJ290LNKUBed6ylpZvm7DacGvgvPwnH4Q7VeBzLHSeAQTBcUXRUQrMnJqNzPQ69BGCw9NEzv6AFSmfvxN+MicBBMg9xFddyJu5nlF9S8pAxgbrzovvcYsZXox642XY8dPdbYcm9/Rh/fJWYXsxRtlxG0ZC/h14g4l6rJvrGujcFkMckZf9kiSqjbMGLWUmf9n7VcX6udDuCHywd5iFPZUSEgKGw06pKwu2zgElrnUq0nl+tOv913lCshz6LDbyp9Xud6Gv7HH+rcgKLiOWTJnKqlx1g50FoSV2q6NaaXOabzSTT+za6ER65vKG2qpWBLkgBFJxg1m1OCrIIEb4HKosvVs+rbIVZHGvNi5WOLsWCkIAfLUwX7y8er9zJApjQ==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB3224.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(376002)(396003)(39860400002)(136003)(8676002)(66476007)(7696005)(66946007)(66446008)(52536014)(8936002)(66556008)(83380400001)(86362001)(54906003)(6506007)(966005)(53546011)(33656002)(478600001)(55016002)(64756008)(4326008)(5660300002)(2906002)(76116006)(316002)(9686003)(186003)(6916009)(71200400001)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: O/QNy4BWN0ZsLAtGMG2sS4QzukEtnX5ReBm539OYmeairsO6y2KfKdaBiooEXMAcvVsG6aAA4XbehktXmaP0Q+GAVDw16LkYX98l2jiRSivpTAy7gPcy8KT3H4NLqhkejGDnDQ2OK9c+Ar7EBcrgz6UiMwvTAlo9ntuPXV90TQkXR/NC7szNbXVqEwTHWKx0t+0Ud5OSW6wcExJc1H8PVCsfDJ/IQv5FLjIHmR3w28Tw+Goxv/FpRuTGbrVN3dF1LOZVkY/5DnPRhcQICnNn8fo/Szx1kzudHPuiYxBD7K6ATr5rVwtQ94KwEMrCK9v3EJULdKnNBEWAyu9qhQ+Ioqp6O2Ri0FxCG4+OPAI0bkNL4ckP2Fboi4jed+sNsmeuutdgOOxsmvqWtlbXg+QfQgQiU7vtncASplpOLCngBs/A5OgyNzG4lEWFfFxeIOVXBfxaBauwvOyXvhrm3uZJOMY00kw52DqGb0+EvlCmKkRNCNzywb5B4NCtBJemQ+9AfrR7y02rmYS+QWGTNVyW6W9W37Disschrnw2Mwsqn2q+V0Aovr7sCmajq8YW6CsPygeVYCjvCBSymsQG7MgfAjLVzYjA5jYVkIs8M7qR8smsx8lBGkWnY+/jgvKQ/nwKhtOtr9ahdCHWHf2nTmxiG6HRyEkTmsZI5Xpymb3UCPHW0D98jdozefG8DNLbatM/OJ6OHGXwmfpa52+zHEzp/f6ggUahH/K6bM28YsIYE50jvd907GGSXYBB7YDVlXXuncdksSf8B3A11NgUrgQCaz2MngUEqtBcFrTAKHReYtPgN68oG0RTDfFh9wZKQ3/7gyglLBCgQuE6LeqAeDqNTJ9RQbfpq8svmyhXVQUhmsvL8Iml5i57eGfXZH8fnCDZWsToajKqF/HS+tDocBCGOQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB4852
Original-Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT023.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: e63688f0-afb1-473f-8ccb-08d890de3165
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CtAC0G8tyK6I72pqInM5GKThjz6JFDKXfoyOU3SjURX09uQgybuS/2duK9yWR9zWyRywGRPsd9cveJlnjQ8iss/LBACPOEvtkvLlFucHyL8EDS1sjrgc+4+kIIYfmTVh3TZPe45C/Os8vl12hXt6lC2kk7kQKXc7GKbrdYt9vFm0ZAOpJsvj2Whj+heu9jUT51YxyrFJFo2zq85J9Yk8rNEQMldYoQ/N+rUz3QPHOKxVBkFcidQuP9Q2XS3Xz2DiIk0FiiOZLerWlXTa5G9Nzr3Mciio7YQWyWSlHV/iKwVck7Q7Hub385s+ZDa/9fZNp290LyP6WmESmmG4HPeHV+HOllpW+EHGvSQnNcrL7Jpm2l/2BEjwOwgSftRE5sqarsdoH/+z9LaQt3BlabZKnDZWi57LATTK6hjXyrKim8GCgzJ/C4pyKO9h8UUPI29O0JG6KG3O0TgIoTeeat4MRPjr7to+3NwETajpNeyiLM8=
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(39860400002)(136003)(396003)(376002)(346002)(46966005)(6862004)(26005)(6506007)(8936002)(107886003)(450100002)(7696005)(54906003)(2906002)(4326008)(33656002)(55016002)(53546011)(8676002)(316002)(5660300002)(52536014)(186003)(70586007)(70206006)(9686003)(356005)(81166007)(83380400001)(82310400003)(82740400003)(336012)(966005)(86362001)(478600001)(47076004);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2020 01:05:32.9339
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 160c49ec-5038-4210-368f-08d890de359b
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: DB5EUR03FT023.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB5393
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgUGV0ZXINCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBQZXRlciBY
dSA8cGV0ZXJ4QHJlZGhhdC5jb20+DQo+IFNlbnQ6IFdlZG5lc2RheSwgTm92ZW1iZXIgMjUsIDIw
MjAgMjoxMiBBTQ0KPiBUbzogSnVzdGluIEhlIDxKdXN0aW4uSGVAYXJtLmNvbT4NCj4gQ2M6IEFs
ZXggV2lsbGlhbXNvbiA8YWxleC53aWxsaWFtc29uQHJlZGhhdC5jb20+OyBDb3JuZWxpYSBIdWNr
DQo+IDxjb2h1Y2tAcmVkaGF0LmNvbT47IGt2bUB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5l
bEB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmU6IFtQQVRDSF0gdmZpbyBpb21tdSB0eXBl
MTogQnlwYXNzIHRoZSB2bWEgcGVybWlzc2lvbiBjaGVjayBpbg0KPiB2ZmlvX3Bpbl9wYWdlc19y
ZW1vdGUoKQ0KPg0KPiBIaSwgSmlhLA0KPg0KPiBPbiBUaHUsIE5vdiAxOSwgMjAyMCBhdCAxMDoy
NzozN1BNICswODAwLCBKaWEgSGUgd3JvdGU6DQo+ID4gVGhlIHBlcm1pc3Npb24gb2YgdmZpbyBp
b21tdSBpcyBkaWZmZXJlbnQgYW5kIGluY29tcGF0aWJsZSB3aXRoIHZtYQ0KPiA+IHBlcm1pc3Np
b24uIElmIHRoZSBpb3RsYi0+cGVybSBpcyBJT01NVV9OT05FIChlLmcuIHFlbXUgc2lkZSksIHFl
bXUgd2lsbA0KPiA+IHNpbXBseSBjYWxsIHVubWFwIGlvY3RsKCkgaW5zdGVhZCBvZiBtYXBwaW5n
LiBIZW5jZSB2ZmlvX2RtYV9tYXAoKSBjYW4ndA0KPiA+IG1hcCBhIGRtYSByZWdpb24gd2l0aCBO
T05FIHBlcm1pc3Npb24uDQo+ID4NCj4gPiBUaGlzIGNvcm5lciBjYXNlIHdpbGwgYmUgZXhwb3Nl
ZCBpbiBjb21pbmcgdmlydGlvX2ZzIGNhY2hlX3NpemUNCj4gPiBjb21taXQgWzFdDQo+ID4gIC0g
bW1hcChOVUxMLCBzaXplLCBQUk9UX05PTkUsIE1BUF9BTk9OWU1PVVMgfCBNQVBfUFJJVkFURSwg
LTEsIDApOw0KPiA+ICAgIG1lbW9yeV9yZWdpb25faW5pdF9yYW1fcHRyKCkNCj4gPiAgLSByZS1t
bWFwIHRoZSBhYm92ZSBhcmVhIHdpdGggcmVhZC93cml0ZSBhdXRob3JpdHkuDQo+DQo+IElmIGlp
dWMgaGVyZSB3ZSdsbCByZW1hcCB0aGUgYWJvdmUgUFJPVF9OT05FIGludG8gUFJPVF9SRUFEfFBS
T1RfV1JJVEUsDQo+IHRoZW4uLi4NCj4NCj4gPiAgLSB2ZmlvX2RtYV9tYXAoKSB3aWxsIGJlIGlu
dm9rZWQgd2hlbiB2ZmlvIGRldmljZSBpcyBob3RwbHVnIGFkZGVkLg0KPg0KPiAuLi4gaGVyZSBJ
J20gc2xpZ2h0bHkgY29uZnVzZWQgb24gd2h5IFZGSU9fSU9NTVVfTUFQX0RNQSB3b3VsZCBlbmNv
dW50ZXINCj4gdm1hDQo+IGNoZWNrIGZhaWwgLSBhcmVuJ3QgdGhleSBhbHJlYWR5IGdldCBydyBw
ZXJtaXNzaW9ucz8NCg0KTm8sIHdlIGhhdmVuJ3QgZ290IHRoZSB2bWEgcncgcGVybWlzc2lvbiB5
ZXQsIGJ1dCB0aGUgZGVmYXVsdCBwZXJtaXNzaW9uIGluDQp0aGlzIGNhc2UgaXMgcncgYnkgZGVm
YXVsdC4NCg0KV2hlbiBxZW11IHNpZGUgaW52b2tlIHZmaW9fZG1hX21hcCgpLCB0aGUgcncgb2Yg
aW9tbXUgd2lsbCBiZSBhdXRvbWF0aWNhbGx5DQphZGRlZCBbMV0gWzJdIChjdXJyZW50bHkgbWFw
IGEgTk9ORSByZWdpb24gaXMgbm90IHN1cHBvcnRlZCBpbiBxZW11IHZmaW8pLg0KWzFdIGh0dHBz
Oi8vZ2l0LnFlbXUub3JnLz9wPXFlbXUuZ2l0O2E9YmxvYjtmPWh3L3ZmaW8vY29tbW9uLmM7aD02
ZmYxZGFhNzYzZjg3YTFlZDUzNTFiY2MxOWFlYjAyN2M0M2I4YThmO2hiPUhFQUQjbDQ3OQ0KWzJd
IGh0dHBzOi8vZ2l0LnFlbXUub3JnLz9wPXFlbXUuZ2l0O2E9YmxvYjtmPWh3L3ZmaW8vY29tbW9u
LmM7aD02ZmYxZGFhNzYzZjg3YTFlZDUzNTFiY2MxOWFlYjAyN2M0M2I4YThmO2hiPUhFQUQjbDQ4
Ng0KDQpCdXQgYXQga2VybmVsIHNpZGUsIHRoZSB2bWEgcGVybWlzc2lvbiBpcyBjcmVhdGVkIGJ5
IFBST1RfTk9ORS4NCg0KVGhlbiB0aGUgY2hlY2sgaW4gY2hlY2tfdm1hX2ZsYWdzKCkgYXQgWzNd
IHdpbGwgYmUgZmFpbGVkLg0KWzNdIGh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51
eC9rZXJuZWwvZ2l0L3RvcnZhbGRzL2xpbnV4LmdpdC90cmVlL21tL2d1cC5jI245MjkNCg0KPg0K
PiBJJ2QgYXBwcmVjaWF0ZSBpZiB5b3UgY291bGQgZXhwbGFpbiB3aHkgdmZpbyBuZWVkcyB0byBk
bWEgbWFwIHNvbWUNCj4gUFJPVF9OT05FDQoNClZpcnRpb2ZzIHdpbGwgbWFwIGEgUFJPVF9OT05F
IGNhY2hlIHdpbmRvdyByZWdpb24gZmlyc3RseSwgdGhlbiByZW1hcCB0aGUgc3ViDQpyZWdpb24g
b2YgdGhhdCBjYWNoZSB3aW5kb3cgd2l0aCByZWFkIG9yIHdyaXRlIHBlcm1pc3Npb24uIEkgZ3Vl
c3MgdGhpcyBtaWdodA0KYmUgYW4gc2VjdXJpdHkgY29uY2Vybi4gSnVzdCBDQyB2aXJ0aW9mcyBl
eHBlcnQgU3RlZmFuIHRvIGFuc3dlciBpdCBtb3JlIGFjY3VyYXRlbHkuDQoNCg0KLS0NCkNoZWVy
cywNCkp1c3RpbiAoSmlhIEhlKQ0KDQoNCj4gcGFnZXMgYWZ0ZXIgYWxsLCBhbmQgd2hldGhlciBR
RU1VIHdvdWxkIGJlIGFibGUgdG8gcG9zdHBvbmUgdGhlIHZmaW8gbWFwIG9mDQo+IHRob3NlIFBS
T1RfTk9ORSBwYWdlcyB1bnRpbCB0aGV5IGdvdCB0byBiZWNvbWUgd2l0aCBSVyBwZXJtaXNzaW9u
cy4NCj4NCj4gVGhhbmtzLA0KPg0KPiAtLQ0KPiBQZXRlciBYdQ0KDQpJTVBPUlRBTlQgTk9USUNF
OiBUaGUgY29udGVudHMgb2YgdGhpcyBlbWFpbCBhbmQgYW55IGF0dGFjaG1lbnRzIGFyZSBjb25m
aWRlbnRpYWwgYW5kIG1heSBhbHNvIGJlIHByaXZpbGVnZWQuIElmIHlvdSBhcmUgbm90IHRoZSBp
bnRlbmRlZCByZWNpcGllbnQsIHBsZWFzZSBub3RpZnkgdGhlIHNlbmRlciBpbW1lZGlhdGVseSBh
bmQgZG8gbm90IGRpc2Nsb3NlIHRoZSBjb250ZW50cyB0byBhbnkgb3RoZXIgcGVyc29uLCB1c2Ug
aXQgZm9yIGFueSBwdXJwb3NlLCBvciBzdG9yZSBvciBjb3B5IHRoZSBpbmZvcm1hdGlvbiBpbiBh
bnkgbWVkaXVtLiBUaGFuayB5b3UuDQo=
