Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A422EF2EE
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 02:44:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729823AbfKEBny (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 20:43:54 -0500
Received: from mail-eopbgr680047.outbound.protection.outlook.com ([40.107.68.47]:36966
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728987AbfKEBnx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Nov 2019 20:43:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LhPIqeh3DfMDsSklT6DZQLkv//RXn0M7FM62sWP3Uolwz7ITlGeheSnsccSlFQHGBTHhbCoGSB0r+tDUTp1mqTZ4Rj4zpukfXq9WYz4dodU0kRFrzebkTqGV7LeuQI/yccgTblRYfsFS1DV+/fxYMIqi9s98Qc3FePi0MBgCFotvwSgNpHi0bkaYwmBBr601TLOa++bZi6wkpbfdGH7yPkqleBQnDOyBBPVdg2ScVIswp6fASW2e9t/oGjy0kRy5WjEH+ZGl+SoDNs4mMIMy/hqS1Ib6ldTWyhl1ovy+tx92YPtybN4gmaxWhzVPTobUzycnQVa4nZdNtxNdJiBncg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jPVoCDG2IiT6up052c1p+MnX/feFXoKzmV27jwwOnCs=;
 b=gH4Ih5I2BEad1vvUZVZtSu9iRZnHRR+mPy1vnce01NDb2s5cdO+xNueJbQRLuRXMQTWQF5ofPHipAn8+uKzAFdL+clQvM4AWZoDyx3ZNaJZlN5TXXDHj8et8g/iF0SfLfzn9qGQWZLKWrX1EFnnnSEzHCdQd+gB6/OP3NvhnH/ilPG2zGVzYiDjITpI1lky/p6heMneCV+NcB6YgxG/pqklTc/EM1bVxGlx12cWgrvxYq0QdOqO2tU1mVVR1lj0Jmo0hNLWYK3s33Vf1hrjY8ztsYEopziWzV6XoG22b1bUAf6qtjaJw9llqC5o0swwIy6L0AKRrBkrvEjh71SNP5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jPVoCDG2IiT6up052c1p+MnX/feFXoKzmV27jwwOnCs=;
 b=ku4oNAwB5NUBv/K2rC4W3rZKEb7+QKMZSVtwqc2SNOKVSnx6PnvsP0KsLxgyBRp67CzUtyOM5X9UNOfrnlqE0MP+OYDXkfyoONCR9cR9Pu+7aSveiZtxeTEqHjPzEi8uzqTpuCRzGu7aaVWlzuKN8A4yKVLx+605fql7K429bwc=
Received: from DM5PR12MB2471.namprd12.prod.outlook.com (52.132.141.138) by
 DM5PR12MB1484.namprd12.prod.outlook.com (10.172.40.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Tue, 5 Nov 2019 01:43:09 +0000
Received: from DM5PR12MB2471.namprd12.prod.outlook.com
 ([fe80::c5a3:6a2e:8699:1999]) by DM5PR12MB2471.namprd12.prod.outlook.com
 ([fe80::c5a3:6a2e:8699:1999%6]) with mapi id 15.20.2408.024; Tue, 5 Nov 2019
 01:43:09 +0000
From:   "Moger, Babu" <Babu.Moger@amd.com>
To:     Borislav Petkov <bp@alien8.de>
CC:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "yamada.masahiro@socionext.com" <yamada.masahiro@socionext.com>,
        "nayna@linux.ibm.com" <nayna@linux.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH v2] x86/Kconfig: Rename UMIP config parameter
Thread-Topic: [PATCH v2] x86/Kconfig: Rename UMIP config parameter
Thread-Index: AQHVk1GLQf345nN80kenPnepADNDDqd7jEsAgABBiYA=
Date:   Tue, 5 Nov 2019 01:43:09 +0000
Message-ID: <DM5PR12MB2471E24B40B96E3863B69955957E0@DM5PR12MB2471.namprd12.prod.outlook.com>
References: <157290058655.2477.5193340480187879024.stgit@naples-babu.amd.com>
 <20191104214734.GB7862@zn.tnic>
In-Reply-To: <20191104214734.GB7862@zn.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Babu.Moger@amd.com; 
x-originating-ip: [2600:1700:270:e9d0:3c89:875f:4410:7d2c]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 506033a6-7ec6-40a2-f153-08d761918312
x-ms-traffictypediagnostic: DM5PR12MB1484:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <DM5PR12MB1484A27F4D09C4704FD82631957E0@DM5PR12MB1484.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0212BDE3BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(39860400002)(366004)(376002)(136003)(189003)(199004)(13464003)(55016002)(76176011)(7416002)(71200400001)(53546011)(476003)(76116006)(99286004)(66476007)(6436002)(46003)(102836004)(5660300002)(6246003)(9686003)(229853002)(54906003)(316002)(6506007)(6306002)(7696005)(52536014)(8676002)(66946007)(81156014)(81166006)(186003)(8936002)(478600001)(305945005)(66446008)(966005)(6116002)(6916009)(64756008)(66556008)(486006)(14454004)(7736002)(74316002)(446003)(86362001)(11346002)(25786009)(256004)(33656002)(4326008)(14444005)(71190400001)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1484;H:DM5PR12MB2471.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kOZ18tG7ETmvlBRqf9/nQSxdnzKHD7I1T/B4CfytFpqLwMxklWq1HeS062lX1kmiqjs4meiB+ZTKNxv1ZkxXwcKC0qFbkNOb/oVZ5+sODvDKB12bTLLTDPNsft5btPnTKSvl3xdzS/zbHHOga3GJzTaNgSHFVi4BFS9Gz+ykQtA62E2SZ9MsogY5fGCh3vzYtjaIuUdZ9unFkbRXmTSGaaOvXByM8K9w0Tq88WK8+BfMXuh0rc0K+UJR+DsVR0bP8EWvAVrC0w3nbPmJ1omDKPZ5ohDOVrEcBHKnAN1Aj9xQeVIKu9NA8DGT42ANe50W6Vho3CUQjd36RKQYIWQQ3T1baOUafzB4PftUETxQ0r/VbE5mqlp9QWctUxSL5tBd1E9TIsFTGA8gwKxfrnFj1t9mXOmEML+YgklYOv1ZDqmzG/ZYb88zb7yvkpW+UOtzI31AshUfPWONx4WUPcD3iRGErmx3ub94Gn1iYMiZwWM=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 506033a6-7ec6-40a2-f153-08d761918312
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2019 01:43:09.2084
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qx5rAHvbTYtmQ5AU973RciAVtYaTnk2DqmCdRgQH68q3v2G3BRvDp/Oy1HnRR4GZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1484
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQm9yaXNsYXYgUGV0a292
IDxicEBhbGllbjguZGU+DQo+IFNlbnQ6IE1vbmRheSwgTm92ZW1iZXIgNCwgMjAxOSAzOjQ4IFBN
DQo+IFRvOiBNb2dlciwgQmFidSA8QmFidS5Nb2dlckBhbWQuY29tPg0KPiBDYzogdGdseEBsaW51
dHJvbml4LmRlOyBtaW5nb0ByZWRoYXQuY29tOyBocGFAenl0b3IuY29tOw0KPiBwYm9uemluaUBy
ZWRoYXQuY29tOyBya3JjbWFyQHJlZGhhdC5jb207IHNlYW4uai5jaHJpc3RvcGhlcnNvbkBpbnRl
bC5jb207DQo+IHZrdXpuZXRzQHJlZGhhdC5jb207IHdhbnBlbmdsaUB0ZW5jZW50LmNvbTsgam1h
dHRzb25AZ29vZ2xlLmNvbTsNCj4geDg2QGtlcm5lbC5vcmc7IGpvcm9AOGJ5dGVzLm9yZzsgbHV0
b0BrZXJuZWwub3JnOyB6b2hhckBsaW51eC5pYm0uY29tOw0KPiB5YW1hZGEubWFzYWhpcm9Ac29j
aW9uZXh0LmNvbTsgbmF5bmFAbGludXguaWJtLmNvbTsgbGludXgtDQo+IGtlcm5lbEB2Z2VyLmtl
cm5lbC5vcmc7IGt2bUB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmU6IFtQQVRDSCB2Ml0g
eDg2L0tjb25maWc6IFJlbmFtZSBVTUlQIGNvbmZpZyBwYXJhbWV0ZXINCj4gDQo+IE9uIE1vbiwg
Tm92IDA0LCAyMDE5IGF0IDA4OjUwOjUxUE0gKzAwMDAsIE1vZ2VyLCBCYWJ1IHdyb3RlOg0KPiA+
IEFNRCAybmQgZ2VuZXJhdGlvbiBFUFlDIHByb2Nlc3NvcnMgc3VwcG9ydCB0aGUgVU1JUCAoVXNl
ci1Nb2RlDQo+ID4gSW5zdHJ1Y3Rpb24gUHJldmVudGlvbikgZmVhdHVyZS4gU28sIHJlbmFtZSBY
ODZfSU5URUxfVU1JUCB0bw0KPiA+IGdlbmVyaWMgWDg2X1VNSVAgYW5kIG1vZGlmeSB0aGUgdGV4
dCB0byBjb3ZlciBib3RoIEludGVsIGFuZCBBTUQuDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBC
YWJ1IE1vZ2VyIDxiYWJ1Lm1vZ2VyQGFtZC5jb20+DQo+ID4gLS0tDQo+ID4gdjI6DQo+ID4gICBM
ZWFybmVkIHRoYXQgZm9yIHRoZSBoYXJkd2FyZSB0aGF0IHN1cHBvcnQgVU1JUCwgd2UgZG9udCBu
ZWVkIHRvDQo+ID4gICBlbXVsYXRlLiBSZW1vdmVkIHRoZSBlbXVsYXRpb24gcmVsYXRlZCBjb2Rl
IGFuZCBqdXN0IHN1Ym1pdHRpbmcNCj4gPiAgIHRoZSBjb25maWcgY2hhbmdlcy4NCj4gPg0KPiA+
ICBhcmNoL3g4Ni9LY29uZmlnICAgICAgICAgICAgICAgICAgICAgICAgIHwgICAgOCArKysrLS0t
LQ0KPiA+ICBhcmNoL3g4Ni9pbmNsdWRlL2FzbS9kaXNhYmxlZC1mZWF0dXJlcy5oIHwgICAgMiAr
LQ0KPiA+ICBhcmNoL3g4Ni9pbmNsdWRlL2FzbS91bWlwLmggICAgICAgICAgICAgIHwgICAgNCAr
Ky0tDQo+ID4gIGFyY2gveDg2L2tlcm5lbC9NYWtlZmlsZSAgICAgICAgICAgICAgICAgfCAgICAy
ICstDQo+ID4gIDQgZmlsZXMgY2hhbmdlZCwgOCBpbnNlcnRpb25zKCspLCA4IGRlbGV0aW9ucygt
KQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L0tjb25maWcgYi9hcmNoL3g4Ni9LY29u
ZmlnDQo+ID4gaW5kZXggZDZlMWZhYTI4YzU4Li44MjFiN2NlYmZmMzEgMTAwNjQ0DQo+ID4gLS0t
IGEvYXJjaC94ODYvS2NvbmZpZw0KPiA+ICsrKyBiL2FyY2gveDg2L0tjb25maWcNCj4gPiBAQCAt
MTg4MCwxMyArMTg4MCwxMyBAQCBjb25maWcgWDg2X1NNQVANCj4gPg0KPiA+ICAJICBJZiB1bnN1
cmUsIHNheSBZLg0KPiA+DQo+ID4gLWNvbmZpZyBYODZfSU5URUxfVU1JUA0KPiA+ICtjb25maWcg
WDg2X1VNSVANCj4gPiAgCWRlZl9ib29sIHkNCj4gPiAtCWRlcGVuZHMgb24gQ1BVX1NVUF9JTlRF
TA0KPiA+IC0JcHJvbXB0ICJJbnRlbCBVc2VyIE1vZGUgSW5zdHJ1Y3Rpb24gUHJldmVudGlvbiIg
aWYgRVhQRVJUDQo+ID4gKwlkZXBlbmRzIG9uIFg4NiAmJiAoQ1BVX1NVUF9JTlRFTCB8fCBDUFVf
U1VQX0FNRCkNCj4gCQkgICBeXl4NCj4gDQo+IFdoYXQncyB0aGUgZGVwZW5kZW5jeSBvbiBYODYg
Zm9yPw0KPiANCj4gQXJlbid0IHRoZSBDUFVfU1VQXyogdGhpbmdzIGVub3VnaD8NCg0KWWVzLiBJ
dCBzaG91bGQgYmUgZ29vZCBlbm91Z2guIFdpbGwgdXBkYXRlLg0KPiANCj4gLS0NCj4gUmVnYXJk
cy9HcnVzcywNCj4gICAgIEJvcmlzLg0KPiANCj4gaHR0cHM6Ly9wZW9wbGUua2VybmVsLm9yZy90
Z2x4L25vdGVzLWFib3V0LW5ldGlxdWV0dGUNCg==
