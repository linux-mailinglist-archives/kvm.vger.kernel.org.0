Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07EB818B108
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 11:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726879AbgCSKSQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 06:18:16 -0400
Received: from mail-mw2nam12on2060.outbound.protection.outlook.com ([40.107.244.60]:26209
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725767AbgCSKSQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Mar 2020 06:18:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H1tkatth7CVsiYa97rHxPe6DLDeBKavCWicnLBhbNnNa6EOSbMnYlyjwLcafGmGnj5OEUISVo6lEyTCebtmqyHGWqCWZ/aL/m6LbyIWfc69hv/157TLxjVdJ6CM93vbrBi+KLK7aYDAea1A9GlKeIGjqC8n2++Zvsl+R1DhYHrUO1dDjoneVvC6r3u4pxkqtDpvitXT+zT92k9bXVP5nVerMqRWhpcduKVd6MfXFijKdmSQZiadIxHkI05/3RTAGdblJoUlp2DwsEy4/JI8J2LMi1rfi2p/3s6c08rdt4BoVQnd0Gi4bJtHiPoTHQh59IGWI6icnkJhmwqRVUrfjyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mo8e0pXhkGwPQEZRTSw0aOdffc0ir1EEXwgAoYdFxcA=;
 b=jLSG179RhSQqdJDSWyMX/rtaxuAM0qTSbqkFYnZKsuDY1qrWSXFsH5zHuHsshKj2QuoEj0SbjReN4ABqwUO1I79HnSny3GQ7p+1DgUH8w3XcECaJg6evDpwSjRJKMZSmOru6DIjo5sqo0o9xeOWW6KBxfE8FQKfUv/R7drgyyT+AUFNOrVbZZjR9zpVfPujEC6hbwBvh94nLlbszvQ6hQOcxCKCW/QrD3fwS5az3zFTx2qDbXJcsRQgoh5aFMXw7/5rpFAhVMcZ6OLndRpkYJemXNmN2w8HbeKK17vPhPQ5dGRgcyS+aHUdoOadeKplkhT3d+Zs3ZG+EmvAP8txRFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mo8e0pXhkGwPQEZRTSw0aOdffc0ir1EEXwgAoYdFxcA=;
 b=aL/kN99qUGitTqWObhgqhfPe98f0Sl2IiL/rrDWEYE5m7vzidFJZwERh5DLxPYYXoKS50Boc4Qh5oZmW8Czr2DvsOIZam7R3ZpG4og3KYDWjrMg9L+Pu3i6jJWS9Ob0KKSi0B5fsfLL6FR8c6uWiuHgvJaxcQANhE5eaeltPjsQ=
Received: from MN2PR05MB6141.namprd05.prod.outlook.com (2603:10b6:208:c7::25)
 by MN2PR05MB6430.namprd05.prod.outlook.com (2603:10b6:208:da::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.15; Thu, 19 Mar
 2020 10:18:09 +0000
Received: from MN2PR05MB6141.namprd05.prod.outlook.com
 ([fe80::d811:e1e3:563c:b15c]) by MN2PR05MB6141.namprd05.prod.outlook.com
 ([fe80::d811:e1e3:563c:b15c%5]) with mapi id 15.20.2835.017; Thu, 19 Mar 2020
 10:18:08 +0000
From:   Thomas Hellstrom <thellstrom@vmware.com>
To:     "joro@8bytes.org" <joro@8bytes.org>,
        "x86@kernel.org" <x86@kernel.org>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "jgross@suse.com" <jgross@suse.com>,
        Doug Covelli <dcovelli@vmware.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "jroedel@suse.de" <jroedel@suse.de>,
        "jslaby@suse.cz" <jslaby@suse.cz>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>
Subject: Re: [PATCH 63/70] x86/vmware: Add VMware specific handling for
 VMMCALL under SEV-ES
Thread-Topic: [PATCH 63/70] x86/vmware: Add VMware specific handling for
 VMMCALL under SEV-ES
Thread-Index: AQHV/c7ZOteOIAWN8UyHhBoVBotVIqhPs7+A
Date:   Thu, 19 Mar 2020 10:18:08 +0000
Message-ID: <5abc70ce42e1445b8ae097a38951b0aa6f67bac8.camel@vmware.com>
References: <20200319091407.1481-1-joro@8bytes.org>
         <20200319091407.1481-64-joro@8bytes.org>
In-Reply-To: <20200319091407.1481-64-joro@8bytes.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.30.5 (3.30.5-1.fc29) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=thellstrom@vmware.com; 
x-originating-ip: [155.4.205.35]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9b707c62-5402-460e-4e63-08d7cbeed264
x-ms-traffictypediagnostic: MN2PR05MB6430:|MN2PR05MB6430:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR05MB6430931CC0072E0121F26722A1F40@MN2PR05MB6430.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-forefront-prvs: 0347410860
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(396003)(39860400002)(376002)(136003)(199004)(36756003)(81166006)(8676002)(81156014)(8936002)(66446008)(91956017)(76116006)(66476007)(6512007)(66556008)(66946007)(4744005)(2906002)(64756008)(2616005)(4326008)(6486002)(110136005)(6506007)(71200400001)(478600001)(26005)(186003)(5660300002)(54906003)(86362001)(7416002)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR05MB6430;H:MN2PR05MB6141.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tCCzaZjQ87474xfvc8a7iF8QljXkWir31FB1ldl1y33ZF4yTmnaSTO3r56xrZ+QDDLbo+c/vQqyJM0zBto9qNdP5CGXTJQhGdV4Nq6YlZo+wOy+sdZICfsZa0HTWBPKn4zv7ENpPKyJodsQuiGqcjcQZPwQHFBcDDl2q7N8jAeef2dMv2ERuDryDStFWQ4UjRz5ZMi1YOggyP2whnvYnHNYAwm6SZgEs/MpNq4KvHV69g5zqHvIqHOCBkzCsXonlNhq38iEP0W15z59HiGZbNCJiJvpX9brpsa7VrfXwWlKotPyIZTNRN4zNTg+Kc4e12DSaQ5bguaaFFHNOhRl/WPUO4qvof5F4Brbf5RT6C3pw7BwpdMY8v27Z3L4aPP5k7EUq/In7eUrTyP7F5hwU4YtRxgmsD9TrLF5tfrMw4Qq/3xpNcwCJiAA5QNai+sOg
x-ms-exchange-antispam-messagedata: nEc/RJF+4teV1+NBaqg2KQikDnco/cHkELcTJKqVlQvnZOYdr/6wj06u4yVo62eOQX3gMazeBCfHu54Y2rlUXo/3JS+kSSQNGMkYtwuaFMjkkkllSlbXpASlNXEP8TYhTlhq+IK6IXi2cPf5AnexZg==
Content-Type: text/plain; charset="utf-8"
Content-ID: <AD4E5ECE942544418011A3A4E96E3198@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b707c62-5402-460e-4e63-08d7cbeed264
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Mar 2020 10:18:08.6509
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: F9ucOi0ghDSiwEzRa5tPWsYL+W3xeKqBM8PrcQriWFR3uPxaok127lLcB+GgupNAVp/dgOqZEkHXuND53Lbb2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR05MB6430
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIwLTAzLTE5IGF0IDEwOjE0ICswMTAwLCBKb2VyZyBSb2VkZWwgd3JvdGU6DQo+
IEZyb206IERvdWcgQ292ZWxsaSA8ZGNvdmVsbGlAdm13YXJlLmNvbT4NCj4gDQo+IFRoaXMgY2hh
bmdlIGFkZHMgVk13YXJlIHNwZWNpZmljIGhhbmRsaW5nIGZvciAjVkMgZmF1bHRzIGNhdXNlZCBi
eQ0KPiBWTU1DQUxMIGluc3RydWN0aW9ucy4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IERvdWcgQ292
ZWxsaSA8ZGNvdmVsbGlAdm13YXJlLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogVG9tIExlbmRhY2t5
IDx0aG9tYXMubGVuZGFja3lAYW1kLmNvbT4NCj4gWyBqcm9lZGVsQHN1c2UuZGU6IC0gQWRhcHQg
dG8gZGlmZmVyZW50IHBhcmF2aXJ0IGludGVyZmFjZSBdDQo+IENvLWRldmVsb3BlZC1ieTogSm9l
cmcgUm9lZGVsIDxqcm9lZGVsQHN1c2UuZGU+DQo+IFNpZ25lZC1vZmYtYnk6IEpvZXJnIFJvZWRl
bCA8anJvZWRlbEBzdXNlLmRlPg0KPiAtLS0NCj4gIGFyY2gveDg2L2tlcm5lbC9jcHUvdm13YXJl
LmMgfCA1MCArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKw0KPiAtLS0tDQo+ICAxIGZp
bGUgY2hhbmdlZCwgNDUgaW5zZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMoLSkNCj4gDQoNCkFja2Vk
LWJ5OiBUaG9tYXMgSGVsbHN0cm9tIDx0aGVsbHN0cm9tQHZtd2FyZS5jb20+DQoNCg==
