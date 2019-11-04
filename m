Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEE2EEE799
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2019 19:45:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729312AbfKDSpw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 13:45:52 -0500
Received: from mail-eopbgr770077.outbound.protection.outlook.com ([40.107.77.77]:23431
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728322AbfKDSpw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Nov 2019 13:45:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vlk44fRfsIjjqhroRRQ830507XMJ07dBSSFX91awRsA2u5+76IU+pFxE9uRqScrSVkp7+DHNW62jq2zTnh5QaIgRN8vXePOBA7pOagUWjn0j1bCUGkJPbWC5itg+m+dl3iWdHi3fueuoQzclZYJYew8e5mabD1/2UBh97KGfwL/REj3ltn4IF//GHtljF73bJWm0wj5ngzgA/igUudNAucK7VUCp6cWDiCX3//cXa03z9Qv/0bZnrtYmip4cmtZ3RuzMUqGkOijWW6aTIB3H2Bi8bYE3BNWU1hWng9sLsaFjWJAo7FdvBxiJ6TED25tdGDeFL+GCcU3hoylg+wEzzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B0iB+VWwJ4LDy/hlbatE2rqqhaJ+93T8hF1Voe2/rQE=;
 b=Of31cqBKksUJPPEQ+sNZ03OGH1yYeHUgojDgorzLcJxUtCpQqQZR3UwXVxa0zGn4DQyfo5uUnEqAnfjUgSqlp7DXsdGF0tj0LtAt0CGGcWIXX/heyqRItTk+WDU+BB4no9rmIzKQ4EVobiyhOzibsQsREOEz0oKMSsJ5bioLvFfw8sTVK/GutXul2K8h8H7OstR9ZBqad6s3cTLC42eiJMSeuK+Qo6jMIEVRJYw+l47JD9febIwr5HaayJmqouBzJIzC6zqcgUHRvGCmAs3NcVE+e+T8AQQeCCknf3mBqJOEfLvwVCEOLy5ahY9MrCxScFoT4JuLACTAP8F8xwqM9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B0iB+VWwJ4LDy/hlbatE2rqqhaJ+93T8hF1Voe2/rQE=;
 b=F8FHjl29VZMGIF5GSqWrbk9jQ34GwkB+4RD9xI7vmEo91rSEBiDvuqqso5FtnyagW3e5La8Q1vEDGm1RjLW04MxafLtI62dVvLcXIM4DTO3FrmrxqiUXRpCMSxK3CHxFEPOBWiW214VoJX4e1w3JRQ6UBtpg77fBVjW7dhagB8w=
Received: from DM5PR12MB2471.namprd12.prod.outlook.com (52.132.141.138) by
 DM5PR12MB1211.namprd12.prod.outlook.com (10.168.239.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Mon, 4 Nov 2019 18:45:48 +0000
Received: from DM5PR12MB2471.namprd12.prod.outlook.com
 ([fe80::c5a3:6a2e:8699:1999]) by DM5PR12MB2471.namprd12.prod.outlook.com
 ([fe80::c5a3:6a2e:8699:1999%6]) with mapi id 15.20.2408.024; Mon, 4 Nov 2019
 18:45:48 +0000
From:   "Moger, Babu" <Babu.Moger@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>
CC:     "x86@kernel.org" <x86@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "yamada.masahiro@socionext.com" <yamada.masahiro@socionext.com>,
        "nayna@linux.ibm.com" <nayna@linux.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/4] kvm: svm: Enable UMIP feature on AMD
Thread-Topic: [PATCH 2/4] kvm: svm: Enable UMIP feature on AMD
Thread-Index: AQHVkNqD+3M/4HqTrkKsDppH5BsZ1qd662IAgABzC4A=
Date:   Mon, 4 Nov 2019 18:45:48 +0000
Message-ID: <2f61ae5c-0658-e5c9-754c-9ca80148a54d@amd.com>
References: <157262960837.2838.17520432516398899751.stgit@naples-babu.amd.com>
 <157262962352.2838.15656190309312238595.stgit@naples-babu.amd.com>
 <37c61050-e315-fc84-9699-bb92e5afacda@redhat.com>
In-Reply-To: <37c61050-e315-fc84-9699-bb92e5afacda@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN6PR15CA0030.namprd15.prod.outlook.com
 (2603:10b6:805:16::43) To DM5PR12MB2471.namprd12.prod.outlook.com
 (2603:10b6:4:b5::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Babu.Moger@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.77.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 27a7e77c-28e1-4f7a-44c0-08d76157353e
x-ms-traffictypediagnostic: DM5PR12MB1211:
x-microsoft-antispam-prvs: <DM5PR12MB12117CA525A02B0A875AE3E8957F0@DM5PR12MB1211.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 0211965D06
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(136003)(39860400002)(346002)(376002)(199004)(189003)(2616005)(6116002)(2501003)(3846002)(66946007)(478600001)(7736002)(25786009)(76176011)(6486002)(386003)(6506007)(6246003)(7416002)(52116002)(6436002)(11346002)(446003)(305945005)(110136005)(4326008)(8676002)(476003)(81166006)(66066001)(316002)(486006)(8936002)(2906002)(186003)(31696002)(36756003)(229853002)(2201001)(5660300002)(102836004)(54906003)(14444005)(26005)(81156014)(53546011)(256004)(99286004)(31686004)(14454004)(66446008)(71190400001)(71200400001)(6512007)(66556008)(64756008)(86362001)(66476007)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1211;H:DM5PR12MB2471.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: V4lfZxC0iwkj70pF7ukvuyztUHfPp79AKAp2rtQc50P3AAPFeoEkbeOQ/IgaN2CQTXenqF5n0fiEUK70k87R9EbyTzx9rHLDTOlb/trgllnOnWh9YtAqU94mvzZrwckBdgEgigqva4JIrFBMeul82AbxZuQFfreklTs+dHa47GkJrl7RoIT/JejiReLn7XdT8ypsclKbiI6L+RD1XT/DUbppNDzbn9DY7wwsc4ZgX7qtea54BFBJhrjc24sEB71+cSS/2LfxYHPj/4mjvBJ9qbslJoRZveXaEKWRU6pDPLF9vG5CCllhv/0E/0L5PyILf+VUbxLPqSTbPdQ9+3kcTetqeZPmOccWMHwLbi6tdBGBUpUMiVbqav6yUAbGSDOlLK+Sn5bf8fx7qn4CryWsB5ivuofgxuxFU4sbrTlKzSgmyjH9gwH7YayQrkN3mJhk
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <8D4C479EB3B38C40B08E87EDC1A8C05D@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27a7e77c-28e1-4f7a-44c0-08d76157353e
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2019 18:45:48.3494
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u8QOKVv4wlfAyH/NX/stxF+09tEtMzifrfuuzEHCHFECv1zJvNiB6BVQssc+hpbi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1211
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCk9uIDExLzQvMTkgNTo1NCBBTSwgUGFvbG8gQm9uemluaSB3cm90ZToNCj4gT24gMDEvMTEv
MTkgMTg6MzMsIE1vZ2VyLCBCYWJ1IHdyb3RlOg0KPj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2
bS9zdm0uYyBiL2FyY2gveDg2L2t2bS9zdm0uYw0KPj4gaW5kZXggNDE1M2NhOGNkZGI3Li43OWFi
YmRlY2ExNDggMTAwNjQ0DQo+PiAtLS0gYS9hcmNoL3g4Ni9rdm0vc3ZtLmMNCj4+ICsrKyBiL2Fy
Y2gveDg2L2t2bS9zdm0uYw0KPj4gQEAgLTI1MzMsNiArMjUzMywxMSBAQCBzdGF0aWMgdm9pZCBz
dm1fZGVjYWNoZV9jcjRfZ3Vlc3RfYml0cyhzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+PiAgew0K
Pj4gIH0NCj4+ICANCj4+ICtzdGF0aWMgYm9vbCBzdm1fdW1pcF9lbXVsYXRlZCh2b2lkKQ0KPj4g
K3sNCj4+ICsJcmV0dXJuIGJvb3RfY3B1X2hhcyhYODZfRkVBVFVSRV9VTUlQKTsNCj4+ICt9DQo+
IA0KPiBGb3IgaGFyZHdhcmUgdGhhdCBzdXBwb3J0cyBVTUlQLCB0aGlzIGlzIG9ubHkgbmVlZGVk
IGJlY2F1c2Ugb2YgeW91cg0KPiBwYXRjaCAxLiAgV2l0aG91dCBpdCwgWDg2X0ZFQVRVUkVfVU1J
UCBzaG91bGQgYWxyZWFkeSBiZSBlbmFibGVkIG9uDQo+IHByb2Nlc3NvcnMgdGhhdCBuYXRpdmVs
eSBzdXBwb3J0IFVNSVAuDQoNClllcywgVGhhdCBpcyBjb3JyZWN0LiBXaWxsIHJlbW92ZSB0aGUg
cGF0Y2ggIzEuIEludGVudGlvbiB3YXMgdG8gZW5hYmxlDQpVTUlQIGZvciB0aGUgaGFyZHdhcmUg
dGhhdCBzdXBwb3J0cyBpdC4gV2lsbCBzZW5kIG91dCBvbmx5IHRoZSBjb25maWcNCmNoYW5nZXMo
UGF0Y2ggIzQpLiAgQWxzbyB0aGVyZSBpcyBhIGNvbXBsZXhpdHkgd2l0aCBzdXBwb3J0aW5nIGVt
dWxhdGlvbg0Kb24gU0VWIGd1ZXN0Lg0KDQo+IA0KPiBJZiB5b3Ugd2FudCBVTUlQICplbXVsYXRp
b24qIGluc3RlYWQsIHRoaXMgc2hvdWxkIGJlY29tZSAicmV0dXJuIHRydWUiLg0KPiANCj4+ICBz
dGF0aWMgdm9pZCB1cGRhdGVfY3IwX2ludGVyY2VwdChzdHJ1Y3QgdmNwdV9zdm0gKnN2bSkNCj4+
ICB7DQo+PiAgCXVsb25nIGdjcjAgPSBzdm0tPnZjcHUuYXJjaC5jcjA7DQo+PiBAQCAtNDQzOCw2
ICs0NDQzLDEzIEBAIHN0YXRpYyBpbnQgaW50ZXJydXB0X3dpbmRvd19pbnRlcmNlcHRpb24oc3Ry
dWN0IHZjcHVfc3ZtICpzdm0pDQo+PiAgCXJldHVybiAxOw0KPj4gIH0NCj4+ICANCj4+ICtzdGF0
aWMgaW50IHVtaXBfaW50ZXJjZXB0aW9uKHN0cnVjdCB2Y3B1X3N2bSAqc3ZtKQ0KPj4gK3sNCj4+
ICsJc3RydWN0IGt2bV92Y3B1ICp2Y3B1ID0gJnN2bS0+dmNwdTsNCj4+ICsNCj4+ICsJcmV0dXJu
IGt2bV9lbXVsYXRlX2luc3RydWN0aW9uKHZjcHUsIDApOw0KPj4gK30NCj4+ICsNCj4+ICBzdGF0
aWMgaW50IHBhdXNlX2ludGVyY2VwdGlvbihzdHJ1Y3QgdmNwdV9zdm0gKnN2bSkNCj4+ICB7DQo+
PiAgCXN0cnVjdCBrdm1fdmNwdSAqdmNwdSA9ICZzdm0tPnZjcHU7DQo+PiBAQCAtNDc3NSw2ICs0
Nzg3LDEwIEBAIHN0YXRpYyBpbnQgKCpjb25zdCBzdm1fZXhpdF9oYW5kbGVyc1tdKShzdHJ1Y3Qg
dmNwdV9zdm0gKnN2bSkgPSB7DQo+PiAgCVtTVk1fRVhJVF9TTUldCQkJCT0gbm9wX29uX2ludGVy
Y2VwdGlvbiwNCj4+ICAJW1NWTV9FWElUX0lOSVRdCQkJCT0gbm9wX29uX2ludGVyY2VwdGlvbiwN
Cj4+ICAJW1NWTV9FWElUX1ZJTlRSXQkJCT0gaW50ZXJydXB0X3dpbmRvd19pbnRlcmNlcHRpb24s
DQo+PiArCVtTVk1fRVhJVF9JRFRSX1JFQURdCQkJPSB1bWlwX2ludGVyY2VwdGlvbiwNCj4+ICsJ
W1NWTV9FWElUX0dEVFJfUkVBRF0JCQk9IHVtaXBfaW50ZXJjZXB0aW9uLA0KPj4gKwlbU1ZNX0VY
SVRfTERUUl9SRUFEXQkJCT0gdW1pcF9pbnRlcmNlcHRpb24sDQo+PiArCVtTVk1fRVhJVF9UUl9S
RUFEXQkJCT0gdW1pcF9pbnRlcmNlcHRpb24sDQo+IA0KPiBUaGlzIGlzIG1pc3NpbmcgZW5hYmxp
bmcgdGhlIGludGVyY2VwdHMuICBBbHNvLCB0aGlzIGNhbiBiZSBqdXN0DQo+IGVtdWxhdGVfb25f
aW50ZXJjZXB0aW9uIGluc3RlYWQgb2YgYSBuZXcgZnVuY3Rpb24uDQo+IA0KPiBQYW9sbw0KPiAN
Cj4+ICAJW1NWTV9FWElUX1JEUE1DXQkJCT0gcmRwbWNfaW50ZXJjZXB0aW9uLA0KPj4gIAlbU1ZN
X0VYSVRfQ1BVSURdCQkJPSBjcHVpZF9pbnRlcmNlcHRpb24sDQo+PiAgCVtTVk1fRVhJVF9JUkVU
XSAgICAgICAgICAgICAgICAgICAgICAgICA9IGlyZXRfaW50ZXJjZXB0aW9uLA0KPj4gQEAgLTU5
NzYsMTEgKzU5OTIsNiBAQCBzdGF0aWMgYm9vbCBzdm1feHNhdmVzX3N1cHBvcnRlZCh2b2lkKQ0K
Pj4gIAlyZXR1cm4gYm9vdF9jcHVfaGFzKFg4Nl9GRUFUVVJFX1hTQVZFUyk7DQo+PiAgfQ0KPj4g
IA0KPj4gLXN0YXRpYyBib29sIHN2bV91bWlwX2VtdWxhdGVkKHZvaWQpDQo+PiAtew0KPj4gLQly
ZXR1cm4gZmFsc2U7DQo+PiAtfQ0KPj4gLQ0KPj4gIHN0YXRpYyBib29sIHN2bV9wdF9zdXBwb3J0
ZWQodm9pZCkNCj4+ICB7DQo+PiAgCXJldHVybiBmYWxzZTsNCj4+DQo+IA0K
