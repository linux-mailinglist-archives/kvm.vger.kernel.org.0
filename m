Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 282D7ED05B
	for <lists+kvm@lfdr.de>; Sat,  2 Nov 2019 20:27:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbfKBTZa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 2 Nov 2019 15:25:30 -0400
Received: from mail-eopbgr700080.outbound.protection.outlook.com ([40.107.70.80]:17252
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726574AbfKBTZ3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 2 Nov 2019 15:25:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hnb720bgsJOkFkPPeAtqLzK0YXuLRSQEM8SPrMGP3pnhgQPXHPItsu9JoBy/XOhPZ4elzluqkIUnHnik3qY8Yq8gAgqxqSs4L0pfo53RbyMvvhrtw1ozDycE1M2xQqjm9EWI0NObDUipInlfmCa2KzLuteiY4j4GKnuWZcuVG+Lzs5HQQVqXzsZsIIST2xW3JNAVQ5yj2/hM05R7alsZbec6Z2HwCKyHHugW8WkylNZAxKb1lXnrX7iSucdx+mbVMxjPQg1OTGgJM6+ePSTANMYaqBaI6EV3alSexEX29AgJ7ceQy8v9Z4UA8LUfm3/Ykka9kHKn6rr2+hWo6/CWxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LkynnW1TjaWOFltASb4r3ILi5/LJdIk32wuW6h4x/I4=;
 b=NfOgMnrZultH8kd+qsGadgjc1KAG/xHHKM2l9VDW9OIBSTohe8zdXnQEpvUntuI3GPUJx7b7pW4mKmoUXf8V0c9sw30V8lpFIwSvsoHVk90pfJ/l38kI6c04RCjL7wW5I/0ryIUqxE+CVwEpCuJdzP67HCEqKFeDlvsPvs6k1O7/+JoJCudmFPdy0TfcHyxfwJmwx7upDEPQmuT5tqV/PqDSeZ+B860QVnYqsIbLH751WbRk2ohiF6pI4PubyOoXtDAnGKT1nj/kO43FXfxQCCM/FouMryVVFk3r0M6HCYlukpY9HQzN4uQjf1LBoKNZfSnvwYCo2JvLxThl3CzTzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LkynnW1TjaWOFltASb4r3ILi5/LJdIk32wuW6h4x/I4=;
 b=1TJZZ4Zoabf6KiUG/HwR2lLgJraA1loBBkIix0Dv+JDCnrywu8UhsI6SjP3qJroMjxw6lp2PrqdG2sjsmX3zgwy6VTlcZqmxWgTDVn1jqCd6Pt08D3tPtGy6/QM3NGMbnQeMhl3GKM5FIHY5lxLj61jjOioUWfGJWN8ch7ypnZA=
Received: from DM5PR12MB2471.namprd12.prod.outlook.com (52.132.141.138) by
 DM5PR12MB1131.namprd12.prod.outlook.com (10.168.236.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Sat, 2 Nov 2019 19:23:45 +0000
Received: from DM5PR12MB2471.namprd12.prod.outlook.com
 ([fe80::c5a3:6a2e:8699:1999]) by DM5PR12MB2471.namprd12.prod.outlook.com
 ([fe80::c5a3:6a2e:8699:1999%6]) with mapi id 15.20.2408.024; Sat, 2 Nov 2019
 19:23:45 +0000
From:   "Moger, Babu" <Babu.Moger@amd.com>
To:     Jim Mattson <jmattson@google.com>
CC:     Andy Lutomirski <luto@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
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
Subject: RE: [PATCH 2/4] kvm: svm: Enable UMIP feature on AMD
Thread-Topic: [PATCH 2/4] kvm: svm: Enable UMIP feature on AMD
Thread-Index: AQHVkNqD+3M/4HqTrkKsDppH5BsZ1qd2otoA//+6a4CAAFUPgP//tzQAgABVAYCAAYQYoA==
Date:   Sat, 2 Nov 2019 19:23:45 +0000
Message-ID: <DM5PR12MB2471947F435B18CBC1F68142957D0@DM5PR12MB2471.namprd12.prod.outlook.com>
References: <157262960837.2838.17520432516398899751.stgit@naples-babu.amd.com>
 <157262962352.2838.15656190309312238595.stgit@naples-babu.amd.com>
 <CALMp9eQT=a99YhraQZ+awMKOWK=3tg=m9NppZnsvK0Q1PWxbAw@mail.gmail.com>
 <669031a1-b9a6-8a45-9a05-a6ce5fb7fa8b@amd.com>
 <CALCETrXdo2arN=s9Bt1LmYkPajcBj1NuTPC8dwuw2mMZqT0tRw@mail.gmail.com>
 <91a05d64-36c0-c4c4-fe49-83a4db1ade10@amd.com>
 <CALMp9eRWjj1b7bPdiJO3ZT2xDCyV=Ypf6GUcQLkXnqr7YrXDRg@mail.gmail.com>
In-Reply-To: <CALMp9eRWjj1b7bPdiJO3ZT2xDCyV=Ypf6GUcQLkXnqr7YrXDRg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Babu.Moger@amd.com; 
x-originating-ip: [2600:1700:270:e9d0:adc5:7ead:a321:89b1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4bab6545-f59e-4901-7541-08d75fca2dcb
x-ms-traffictypediagnostic: DM5PR12MB1131:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <DM5PR12MB11317A636E3F08EA3A8A33ED957D0@DM5PR12MB1131.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0209425D0A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(396003)(39860400002)(366004)(136003)(189003)(199004)(13464003)(54534003)(6116002)(2906002)(74316002)(7416002)(7736002)(316002)(8936002)(99286004)(305945005)(54906003)(81166006)(81156014)(66446008)(64756008)(186003)(6916009)(66556008)(66476007)(8676002)(76116006)(66946007)(55016002)(6306002)(9686003)(229853002)(446003)(71200400001)(71190400001)(6436002)(486006)(46003)(4326008)(11346002)(6246003)(86362001)(14444005)(256004)(5660300002)(966005)(14454004)(33656002)(102836004)(52536014)(76176011)(25786009)(7696005)(478600001)(53546011)(6506007)(476003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1131;H:DM5PR12MB2471.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aCTfF+yvZ8XSjVGlmr361gVrXVzVWODRff1Z/R22b/Xeio4ayiVMFJ4vM85b/BJ9jGD6q/p8z/32DaRet9gbydALGYKvN1C0u1kbifagCVnTjD3xV1enan6aClgFf7tlLJdjuJN5TAx/BRu7A36mjamWN47n/Qf3RXtL2vNN4BUHhT1/mhaNhM11/b5h9ZDN+P6A66XK0lLN16XCUfECLXUdoCgtFVtNqAtYhMjV/rY6+UDD53U5TzeY1mWz2z262XusDaXKCnghYZOFN96EZldpO9xa6Zr50Ow7zsxBFDe2ihmz7V8ncaRCLN7hwMO5t1HeqVBp9MtVr+8NeG8FdBAfPh+8qNV/s8fAc3N9HTYE3XnjL+rZSdfam2C/20zLkxV6LXWI9Xmrj5SOiPdqI3/Z+5i6wWBLcEQXVRNPUpKIQSCILlOPnbn/yxtGTcvrkHwUjL4cmum+TEv1wg5gueFUf8XCRJ3wPTuHyE7XUoY=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bab6545-f59e-4901-7541-08d75fca2dcb
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Nov 2019 19:23:45.1796
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HvYXdGPNL1b8HHDbAqrzdP7AkJAboVOE+61SpFtscjmM70CbvJb0vozZlFBRNN+V
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1131
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbToga3ZtLW93bmVyQHZnZXIu
a2VybmVsLm9yZyA8a3ZtLW93bmVyQHZnZXIua2VybmVsLm9yZz4gT24gQmVoYWxmDQo+IE9mIEpp
bSBNYXR0c29uDQo+IFNlbnQ6IEZyaWRheSwgTm92ZW1iZXIgMSwgMjAxOSAzOjA4IFBNDQo+IFRv
OiBNb2dlciwgQmFidSA8QmFidS5Nb2dlckBhbWQuY29tPg0KPiBDYzogQW5keSBMdXRvbWlyc2tp
IDxsdXRvQGtlcm5lbC5vcmc+OyB0Z2x4QGxpbnV0cm9uaXguZGU7DQo+IG1pbmdvQHJlZGhhdC5j
b207IGJwQGFsaWVuOC5kZTsgaHBhQHp5dG9yLmNvbTsgcGJvbnppbmlAcmVkaGF0LmNvbTsNCj4g
cmtyY21hckByZWRoYXQuY29tOyBzZWFuLmouY2hyaXN0b3BoZXJzb25AaW50ZWwuY29tOyB2a3V6
bmV0c0ByZWRoYXQuY29tOw0KPiB3YW5wZW5nbGlAdGVuY2VudC5jb207IHg4NkBrZXJuZWwub3Jn
OyBqb3JvQDhieXRlcy5vcmc7DQo+IHpvaGFyQGxpbnV4LmlibS5jb207IHlhbWFkYS5tYXNhaGly
b0Bzb2Npb25leHQuY29tOw0KPiBuYXluYUBsaW51eC5pYm0uY29tOyBsaW51eC1rZXJuZWxAdmdl
ci5rZXJuZWwub3JnOyBrdm1Admdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0gg
Mi80XSBrdm06IHN2bTogRW5hYmxlIFVNSVAgZmVhdHVyZSBvbiBBTUQNCj4gDQo+IE9uIEZyaSwg
Tm92IDEsIDIwMTkgYXQgMTowNCBQTSBNb2dlciwgQmFidSA8QmFidS5Nb2dlckBhbWQuY29tPiB3
cm90ZToNCj4gPg0KPiA+DQo+ID4NCj4gPiBPbiAxMS8xLzE5IDI6MjQgUE0sIEFuZHkgTHV0b21p
cnNraSB3cm90ZToNCj4gPiA+IE9uIEZyaSwgTm92IDEsIDIwMTkgYXQgMTI6MjAgUE0gTW9nZXIs
IEJhYnUgPEJhYnUuTW9nZXJAYW1kLmNvbT4NCj4gd3JvdGU6DQo+ID4gPj4NCj4gPiA+Pg0KPiA+
ID4+DQo+ID4gPj4gT24gMTEvMS8xOSAxOjI5IFBNLCBKaW0gTWF0dHNvbiB3cm90ZToNCj4gPiA+
Pj4gT24gRnJpLCBOb3YgMSwgMjAxOSBhdCAxMDozMyBBTSBNb2dlciwgQmFidSA8QmFidS5Nb2dl
ckBhbWQuY29tPg0KPiB3cm90ZToNCj4gPiA+Pj4+DQo+ID4gPj4+PiBBTUQgMm5kIGdlbmVyYXRp
b24gRVBZQyBwcm9jZXNzb3JzIHN1cHBvcnQgVU1JUCAoVXNlci1Nb2RlDQo+IEluc3RydWN0aW9u
DQo+ID4gPj4+PiBQcmV2ZW50aW9uKSBmZWF0dXJlLiBUaGUgVU1JUCBmZWF0dXJlIHByZXZlbnRz
IHRoZSBleGVjdXRpb24gb2YgY2VydGFpbg0KPiA+ID4+Pj4gaW5zdHJ1Y3Rpb25zIGlmIHRoZSBD
dXJyZW50IFByaXZpbGVnZSBMZXZlbCAoQ1BMKSBpcyBncmVhdGVyIHRoYW4gMC4NCj4gPiA+Pj4+
IElmIGFueSBvZiB0aGVzZSBpbnN0cnVjdGlvbnMgYXJlIGV4ZWN1dGVkIHdpdGggQ1BMID4gMCBh
bmQgVU1JUA0KPiA+ID4+Pj4gaXMgZW5hYmxlZCwgdGhlbiBrZXJuZWwgcmVwb3J0cyBhICNHUCBl
eGNlcHRpb24uDQo+ID4gPj4+Pg0KPiA+ID4+Pj4gVGhlIGlkZWEgaXMgdGFrZW4gZnJvbSBhcnRp
Y2xlczoNCj4gPiA+Pj4+IGh0dHBzOi8vbHduLm5ldC9BcnRpY2xlcy83MzgyMDkvDQo+ID4gPj4+
PiBodHRwczovL2x3bi5uZXQvQXJ0aWNsZXMvNjk0Mzg1Lw0KPiA+ID4+Pj4NCj4gPiA+Pj4+IEVu
YWJsZSB0aGUgZmVhdHVyZSBpZiBzdXBwb3J0ZWQgb24gYmFyZSBtZXRhbCBhbmQgZW11bGF0ZSBp
bnN0cnVjdGlvbnMNCj4gPiA+Pj4+IHRvIHJldHVybiBkdW1teSB2YWx1ZXMgZm9yIGNlcnRhaW4g
Y2FzZXMuDQo+ID4gPj4+Pg0KPiA+ID4+Pj4gU2lnbmVkLW9mZi1ieTogQmFidSBNb2dlciA8YmFi
dS5tb2dlckBhbWQuY29tPg0KPiA+ID4+Pj4gLS0tDQo+ID4gPj4+PiAgYXJjaC94ODYva3ZtL3N2
bS5jIHwgICAyMSArKysrKysrKysrKysrKysrLS0tLS0NCj4gPiA+Pj4+ICAxIGZpbGUgY2hhbmdl
ZCwgMTYgaW5zZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMoLSkNCj4gPiA+Pj4+DQo+ID4gPj4+PiBk
aWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3N2bS5jIGIvYXJjaC94ODYva3ZtL3N2bS5jDQo+ID4g
Pj4+PiBpbmRleCA0MTUzY2E4Y2RkYjcuLjc5YWJiZGVjYTE0OCAxMDA2NDQNCj4gPiA+Pj4+IC0t
LSBhL2FyY2gveDg2L2t2bS9zdm0uYw0KPiA+ID4+Pj4gKysrIGIvYXJjaC94ODYva3ZtL3N2bS5j
DQo+ID4gPj4+PiBAQCAtMjUzMyw2ICsyNTMzLDExIEBAIHN0YXRpYyB2b2lkDQo+IHN2bV9kZWNh
Y2hlX2NyNF9ndWVzdF9iaXRzKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkNCj4gPiA+Pj4+ICB7DQo+
ID4gPj4+PiAgfQ0KPiA+ID4+Pj4NCj4gPiA+Pj4+ICtzdGF0aWMgYm9vbCBzdm1fdW1pcF9lbXVs
YXRlZCh2b2lkKQ0KPiA+ID4+Pj4gK3sNCj4gPiA+Pj4+ICsgICAgICAgcmV0dXJuIGJvb3RfY3B1
X2hhcyhYODZfRkVBVFVSRV9VTUlQKTsNCj4gPiA+Pj4+ICt9DQo+ID4gPj4+DQo+ID4gPj4+IFRo
aXMgbWFrZXMgbm8gc2Vuc2UgdG8gbWUuIElmIHRoZSBoYXJkd2FyZSBhY3R1YWxseSBzdXBwb3J0
cyBVTUlQLA0KPiA+ID4+PiB0aGVuIGl0IGRvZXNuJ3QgaGF2ZSB0byBiZSBlbXVsYXRlZC4NCj4g
PiA+PiBNeSB1bmRlcnN0YW5kaW5nLi4NCj4gPiA+Pg0KPiA+ID4+IElmIHRoZSBoYXJkd2FyZSBz
dXBwb3J0cyB0aGUgVU1JUCwgaXQgd2lsbCBnZW5lcmF0ZSB0aGUgI0dQIGZhdWx0IHdoZW4NCj4g
PiA+PiB0aGVzZSBpbnN0cnVjdGlvbnMgYXJlIGV4ZWN1dGVkIGF0IENQTCA+IDAuIFB1cnBvc2Ug
b2YgdGhlIGVtdWxhdGlvbiBpcyB0bw0KPiA+ID4+IHRyYXAgdGhlIEdQIGFuZCByZXR1cm4gYSBk
dW1teSB2YWx1ZS4gU2VlbXMgbGlrZSB0aGlzIHJlcXVpcmVkIGluIGNlcnRhaW4NCj4gPiA+PiBs
ZWdhY3kgT1NlcyBydW5uaW5nIGluIHByb3RlY3RlZCBhbmQgdmlydHVhbC04MDg2IG1vZGVzLiBJ
biBsb25nIG1vZGUgbm8NCj4gPiA+PiBuZWVkIHRvIGVtdWxhdGUuIEhlcmUgaXMgdGhlIGJpdCBl
eHBsYW5hdGlvbg0KPiBodHRwczovL2x3bi5uZXQvQXJ0aWNsZXMvNzM4MjA5Lw0KPiA+ID4+DQo+
ID4gPg0KPiA+ID4gSW5kZWVkLiAgQWdhaW4sIHdoYXQgZG9lcyB0aGlzIGhhdmUgdG8gZG8gd2l0
aCB5b3VyIHBhdGNoPw0KPiA+ID4NCj4gPiA+Pg0KPiA+ID4+Pg0KPiA+ID4+PiBUbyB0aGUgZXh0
ZW50IHRoYXQga3ZtIGVtdWxhdGVzIFVNSVAgb24gSW50ZWwgQ1BVcyB3aXRob3V0IGhhcmR3YXJl
DQo+ID4gPj4+IFVNSVAgKGkuZS4gc21zdyBpcyBzdGlsbCBhbGxvd2VkIGF0IENQTD4wKSwgd2Ug
Y2FuIGFsd2F5cyBkbyB0aGUgc2FtZQ0KPiA+ID4+PiBlbXVsYXRpb24gb24gQU1ELCBiZWNhdXNl
IFNWTSBoYXMgYWx3YXlzIG9mZmVyZWQgaW50ZXJjZXB0cyBvZiBzZ2R0LA0KPiA+ID4+PiBzaWR0
LCBzbGR0LCBhbmQgc3RyLiBTbywgaWYgeW91IHJlYWxseSB3YW50IHRvIG9mZmVyIHRoaXMgZW11
bGF0aW9uIG9uDQo+ID4gPj4+IHByZS1FUFlDIDIgQ1BVcywgdGhpcyBmdW5jdGlvbiBzaG91bGQg
anVzdCByZXR1cm4gdHJ1ZS4gQnV0LCBJIGhhdmUgdG8NCj4gPiA+Pj4gYXNrLCAid2h5PyINCj4g
PiA+Pg0KPiA+ID4+DQo+ID4gPj4gVHJ5aW5nIHRvIHN1cHBvcnQgVU1JUCBmZWF0dXJlIG9ubHkg
b24gRVBZQyAyIGhhcmR3YXJlLiBObyBpbnRlbnRpb24gdG8NCj4gPiA+PiBzdXBwb3J0IHByZS1F
UFlDIDIuDQo+ID4gPj4NCj4gPiA+DQo+ID4gPiBJIHRoaW5rIHlvdSBuZWVkIHRvIHRvdGFsbHkg
cmV3cml0ZSB5b3VyIGNoYW5nZWxvZyB0byBleHBsYWluIHdoYXQgeW91DQo+ID4gPiBhcmUgZG9p
bmcuDQo+ID4gPg0KPiA+ID4gQXMgSSB1bmRlcnN0YW5kIGl0LCB0aGVyZSBhcmUgYSBjb3VwbGUg
b2YgdGhpbmdzIEtWTSBjYW4gZG86DQo+ID4gPg0KPiA+ID4gMS4gSWYgdGhlIHVuZGVybHlpbmcg
aGFyZHdhcmUgc3VwcG9ydHMgVU1JUCwgS1ZNIGNhbiBleHBvc2UgVU1JUCB0bw0KPiA+ID4gdGhl
IGd1ZXN0LiAgU0VWIHNob3VsZCBiZSBpcnJlbGV2YW50IGhlcmUuDQo+ID4gPg0KPiA+ID4gMi4g
UmVnYXJkbGVzcyBvZiB3aGV0aGVyIHRoZSB1bmRlcmx5aW5nIGhhcmR3YXJlIHN1cHBvcnRzIFVN
SVAsIEtWTQ0KPiA+ID4gY2FuIHRyeSB0byBlbXVsYXRlIFVNSVAgaW4gdGhlIGd1ZXN0LiAgVGhp
cyBtYXkgYmUgaW1wb3NzaWJsZSBpZiBTRVYNCj4gPiA+IGlzIGVuYWJsZWQuDQo+ID4gPg0KPiA+
ID4gV2hpY2ggb2YgdGhlc2UgYXJlIHlvdSBkb2luZz8NCj4gPiA+DQo+ID4gTXkgaW50ZW50aW9u
IHdhcyB0byBkbyAxLiAgTGV0IG1lIGdvIGJhY2sgYW5kIHRoaW5rIGFib3V0IHRoaXMgYWdhaW4u
DQo+IA0KPiAoMSkgYWxyZWFkeSB3b3Jrcy4NCg0KVGhhdOKAmXMgcmlnaHQuIFRoYW5rcyBKaW0g
YW5kIEFuZHkuDQpIb3cgYWJvdXQgdXBkYXRpbmcgdGhlIEtjb25maWcgKHBhdGNoICM0KSBhbmQg
dXBkYXRlIGl0IHRvIENPTkZJR19YODZfVU1JUCAoaW5zdGVhZCBvZiBDT05GSUdfWDg2X0lOVEVM
X1VNSVApLg0KUmlnaHQgbm93LCBpdCBhcHBlYXJzIGl0IGlzIHN1cHBvcnRlZCBvbiBvbmx5IElu
dGVsLg0K
