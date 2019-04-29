Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA091E82A
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2019 18:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728803AbfD2QyM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Apr 2019 12:54:12 -0400
Received: from mail-eopbgr750051.outbound.protection.outlook.com ([40.107.75.51]:64223
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728520AbfD2QyM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Apr 2019 12:54:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amd-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2cS2Tbwu5wABgFx0DVz1/x77dFfsdmtrFruoRp8B/4w=;
 b=Di1LCS3UX5gmP54Vvo90HrLKB2MsVQXglntN3QkDijA+1I6lrYVkSJGYwKjdd0Qe8ZyEbEoIeoYU2UJ2euHrtVUlx9y1avuYOuoo6pl/V8Sta3THuW1okLpYGabi8y2/7N3tcaUCCcErP6y+SRNhlg1NVvDhzFE2jVPMb+kjJxM=
Received: from DM6PR12MB2682.namprd12.prod.outlook.com (20.176.116.31) by
 DM6PR12MB3354.namprd12.prod.outlook.com (20.178.31.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.15; Mon, 29 Apr 2019 16:54:08 +0000
Received: from DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::9183:846f:a93e:9a43]) by DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::9183:846f:a93e:9a43%5]) with mapi id 15.20.1835.016; Mon, 29 Apr 2019
 16:54:08 +0000
From:   "Singh, Brijesh" <brijesh.singh@amd.com>
To:     "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "Singh, Brijesh" <brijesh.singh@amd.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?utf-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@suse.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v1 02/10] KVM: SVM: Add KVM_SEND_UPDATE_DATA command
Thread-Topic: [RFC PATCH v1 02/10] KVM: SVM: Add KVM_SEND_UPDATE_DATA command
Thread-Index: AQHU+rgr5ZWFEHS1e0SVdIqZ4Ix/v6ZO6KyAgAR6MoA=
Date:   Mon, 29 Apr 2019 16:54:08 +0000
Message-ID: <0883651a-ac95-022a-1a16-978ddb2cc35d@amd.com>
References: <20190424160942.13567-1-brijesh.singh@amd.com>
 <20190424160942.13567-3-brijesh.singh@amd.com>
 <c0cf8d9b-4b47-f578-bc51-29739a3c2f8d@amd.com>
In-Reply-To: <c0cf8d9b-4b47-f578-bc51-29739a3c2f8d@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN2PR01CA0002.prod.exchangelabs.com (2603:10b6:804:2::12)
 To DM6PR12MB2682.namprd12.prod.outlook.com (2603:10b6:5:4a::31)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=brijesh.singh@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.77.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 41c6f68c-7ab1-49bd-870b-08d6ccc34baf
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB3354;
x-ms-traffictypediagnostic: DM6PR12MB3354:
x-microsoft-antispam-prvs: <DM6PR12MB3354911405F54EB45C998513E5390@DM6PR12MB3354.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0022134A87
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(39860400002)(366004)(136003)(346002)(376002)(189003)(199004)(43544003)(14454004)(186003)(2906002)(110136005)(478600001)(11346002)(2616005)(81166006)(6506007)(53546011)(386003)(8676002)(81156014)(446003)(7416002)(8936002)(76176011)(102836004)(36756003)(26005)(6116002)(3846002)(54906003)(316002)(5660300002)(2501003)(68736007)(66066001)(229853002)(4326008)(86362001)(6246003)(31686004)(476003)(97736004)(31696002)(256004)(6486002)(14444005)(53936002)(6436002)(6512007)(25786009)(73956011)(66946007)(66446008)(64756008)(66556008)(66476007)(71190400001)(305945005)(71200400001)(7736002)(52116002)(99286004)(486006);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3354;H:DM6PR12MB2682.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: cIYiNpj+sh30PnY0uxvSpRgiQuNu+gOitxpV5wRvpFMM6yMugvxkiq2wV9JKlIrLKW73hztg0v/C05yGOE7uzYF0wzvqkHmh/gXsep3P3ddKza6wxQYlTvOmWkoiT012tRF1KNjjEjvO+asiPH9JDpx8ssb7FR6dmHcR6UlDvDI2cY85SzIywzcmzgPr0cFKciPvju7/EMT18V2ophTUmvWzkH+qmdOB1ULVvrPAkWvt50xSaEWbVqGD2od61hm6TivoATjn571ZYylzIGeGtdaYrK4g1OiuFn28Gq9a2t1JEA/81EY47KkrTmQbrc/U1dzLH2otjsf63q9MCCE+V/HFeIRsq9dwsJ2bWEI5QdCmPLTY+gwZelbyTfMKZjI7TxHDFowpn2X4FqaoMIQ/SgWt8eM8f6whMS0kyC9dCRc=
Content-Type: text/plain; charset="utf-8"
Content-ID: <ED6640A095C20241AFFA51CB3FF8F15E@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41c6f68c-7ab1-49bd-870b-08d6ccc34baf
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2019 16:54:08.3670
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3354
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCk9uIDQvMjYvMTkgMzozMSBQTSwgTGVuZGFja3ksIFRob21hcyB3cm90ZToNCi4uLg0KDQo+
PiAgIA0KPj4gICBzdGF0aWMgdW5zaWduZWQgaW50IG1heF9zZXZfYXNpZDsNCj4+ICAgc3RhdGlj
IHVuc2lnbmVkIGludCBtaW5fc2V2X2FzaWQ7DQo+PiArc3RhdGljIHVuc2lnbmVkIGxvbmcgbWVf
bWFzazsNCj4gDQo+IHNldl9tZV9tYXNrID8NCj4gDQoNCkFncmVlZC4NCg0KPj4gICBzdGF0aWMg
dW5zaWduZWQgbG9uZyAqc2V2X2FzaWRfYml0bWFwOw0KPj4gICAjZGVmaW5lIF9fc21lX3BhZ2Vf
cGEoeCkgX19zbWVfc2V0KHBhZ2VfdG9fcGZuKHgpIDw8IFBBR0VfU0hJRlQpDQo+PiAgIA0KPj4g
QEAgLTEyMTYsMTUgKzEyMTcsMjEgQEAgc3RhdGljIGludCBhdmljX2dhX2xvZ19ub3RpZmllcih1
MzIgZ2FfdGFnKQ0KPj4gICBzdGF0aWMgX19pbml0IGludCBzZXZfaGFyZHdhcmVfc2V0dXAodm9p
ZCkNCj4+ICAgew0KPj4gICAJc3RydWN0IHNldl91c2VyX2RhdGFfc3RhdHVzICpzdGF0dXM7DQo+
PiArCWludCBlYXgsIGVieDsNCj4+ICAgCWludCByYzsNCj4+ICAgDQo+PiAtCS8qIE1heGltdW0g
bnVtYmVyIG9mIGVuY3J5cHRlZCBndWVzdHMgc3VwcG9ydGVkIHNpbXVsdGFuZW91c2x5ICovDQo+
PiAtCW1heF9zZXZfYXNpZCA9IGNwdWlkX2VjeCgweDgwMDAwMDFGKTsNCj4+ICsJLyoNCj4+ICsJ
ICogUXVlcnkgdGhlIG1lbW9yeSBlbmNyeXB0aW9uIGluZm9ybWF0aW9uLg0KPj4gKwkgKiAgRUJY
OiAgQml0IDA6NSBQYWdldGFibGUgYml0IHBvc2l0aW9uIHVzZWQgdG8gaW5kaWNhdGUgZW5jcnlw
dGlvbiAoYWthIENiaXQpLg0KPj4gKwkgKiAgRUNYOiAgTWF4aW11bSBudW1iZXIgb2YgZW5jcnlw
dGVkIGd1ZXN0cyBzdXBwb3J0ZWQgc2ltdWx0YW5lb3VzbHkuDQo+PiArCSAqICBFRFg6ICBNaW5p
bXVtIEFTSUQgdmFsdWUgdGhhdCBzaG91bGQgYmUgdXNlZCBmb3IgU0VWIGd1ZXN0Lg0KPj4gKwkg
Ki8NCj4+ICsJY3B1aWQoMHg4MDAwMDAxZiwgJmVheCwgJmVieCwgJm1heF9zZXZfYXNpZCwgJm1p
bl9zZXZfYXNpZCk7DQo+PiAgIA0KPj4gICAJaWYgKCFtYXhfc2V2X2FzaWQpDQo+PiAgIAkJcmV0
dXJuIDE7DQo+PiAgIA0KPj4gLQkvKiBNaW5pbXVtIEFTSUQgdmFsdWUgdGhhdCBzaG91bGQgYmUg
dXNlZCBmb3IgU0VWIGd1ZXN0ICovDQo+PiArCW1lX21hc2sgPSAxVUwgPDwgKGVieCAmIDB4M2Yp
Ow0KPj4gICAJbWluX3Nldl9hc2lkID0gY3B1aWRfZWR4KDB4ODAwMDAwMUYpOw0KPiANCj4gWW91
IGNhbiByZW1vdmUgdGhpcyBzaW5jZSB5b3Ugb2J0YWluZWQgaXQgd2l0aCB0aGUgY3B1aWQoKSBj
YWxsIGFib3ZlLg0KPiANCg0KSSB0aG91Z2h0IEkgcmVtb3ZlZCBpdCBidXQuLiBJIHdpbGwgdGFr
ZSBjYXJlIGluIG5leHQgcmV2Lg0KDQo+PiAgIA0KPj4gICAJLyogSW5pdGlhbGl6ZSBTRVYgQVNJ
RCBiaXRtYXAgKi8NCj4+IEBAIC03MDUzLDYgKzcwNjAsMTE4IEBAIHN0YXRpYyBpbnQgc2V2X3Nl
bmRfc3RhcnQoc3RydWN0IGt2bSAqa3ZtLCBzdHJ1Y3Qga3ZtX3Nldl9jbWQgKmFyZ3ApDQo+PiAg
IAlyZXR1cm4gcmV0Ow0KPj4gICB9DQo+PiAgIA0KPj4gK3N0YXRpYyBpbnQgc2V2X3NlbmRfdXBk
YXRlX2RhdGEoc3RydWN0IGt2bSAqa3ZtLCBzdHJ1Y3Qga3ZtX3Nldl9jbWQgKmFyZ3ApDQo+PiAr
ew0KPj4gKwlzdHJ1Y3Qga3ZtX3Nldl9pbmZvICpzZXYgPSAmdG9fa3ZtX3N2bShrdm0pLT5zZXZf
aW5mbzsNCj4+ICsJc3RydWN0IHNldl9kYXRhX3NlbmRfdXBkYXRlX2RhdGEgKmRhdGE7DQo+PiAr
CXN0cnVjdCBrdm1fc2V2X3NlbmRfdXBkYXRlX2RhdGEgcGFyYW1zOw0KPj4gKwl2b2lkICpoZHIg
PSBOVUxMLCAqdHJhbnNfZGF0YSA9IE5VTEw7DQo+PiArCXN0cnVjdCBwYWdlICoqZ3Vlc3RfcGFn
ZSA9IE5VTEw7DQo+PiArCXVuc2lnbmVkIGxvbmcgbjsNCj4+ICsJaW50IHJldCwgb2Zmc2V0Ow0K
Pj4gKw0KPj4gKwlpZiAoIXNldl9ndWVzdChrdm0pKQ0KPj4gKwkJcmV0dXJuIC1FTk9UVFk7DQo+
PiArDQo+PiArCWlmIChjb3B5X2Zyb21fdXNlcigmcGFyYW1zLCAodm9pZCBfX3VzZXIgKikodWlu
dHB0cl90KWFyZ3AtPmRhdGEsDQo+PiArCQkJc2l6ZW9mKHN0cnVjdCBrdm1fc2V2X3NlbmRfdXBk
YXRlX2RhdGEpKSkNCj4+ICsJCXJldHVybiAtRUZBVUxUOw0KPj4gKw0KPj4gKwlkYXRhID0ga3ph
bGxvYyhzaXplb2YoKmRhdGEpLCBHRlBfS0VSTkVMKTsNCj4+ICsJaWYgKCFkYXRhKQ0KPj4gKwkJ
cmV0dXJuIC1FTk9NRU07DQo+PiArDQo+PiArCS8qIHVzZXJzcGFjZSB3YW50cyB0byBxdWVyeSBl
aXRoZXIgaGVhZGVyIG9yIHRyYW5zIGxlbmd0aCAqLw0KPj4gKwlpZiAoIXBhcmFtcy50cmFuc19s
ZW4gfHwgIXBhcmFtcy5oZHJfbGVuKQ0KPj4gKwkJZ290byBjbWQ7DQo+PiArDQo+PiArCXJldCA9
IC1FSU5WQUw7DQo+PiArCWlmICghcGFyYW1zLnRyYW5zX3VhZGRyIHx8ICFwYXJhbXMuZ3Vlc3Rf
dWFkZHIgfHwNCj4+ICsJICAgICFwYXJhbXMuZ3Vlc3RfbGVuIHx8ICFwYXJhbXMuaGRyX3VhZGRy
KQ0KPj4gKwkJZ290byBlX2ZyZWU7DQo+PiArDQo+PiArCS8qIENoZWNrIGlmIHdlIGFyZSBjcm9z
c2luZyB0aGUgcGFnZSBib3VuZHJ5ICovDQo+PiArCXJldCA9IC1FSU5WQUw7DQo+PiArCW9mZnNl
dCA9IHBhcmFtcy5ndWVzdF91YWRkciAmIChQQUdFX1NJWkUgLSAxKTsNCj4+ICsJaWYgKChwYXJh
bXMuZ3Vlc3RfbGVuICsgb2Zmc2V0ID4gUEFHRV9TSVpFKSkNCj4+ICsJCWdvdG8gZV9mcmVlOw0K
Pj4gKw0KPj4gKwlyZXQgPSAtRU5PTUVNOw0KPj4gKwloZHIgPSBrbWFsbG9jKHBhcmFtcy5oZHJf
bGVuLCBHRlBfS0VSTkVMKTsNCj4+ICsJaWYgKCFoZHIpDQo+PiArCQlnb3RvIGVfZnJlZTsNCj4+
ICsNCj4+ICsJZGF0YS0+aGRyX2FkZHJlc3MgPSBfX3BzcF9wYShoZHIpOw0KPj4gKwlkYXRhLT5o
ZHJfbGVuID0gcGFyYW1zLmhkcl9sZW47DQo+PiArDQo+PiArCXJldCA9IC1FTk9NRU07DQo+PiAr
CXRyYW5zX2RhdGEgPSBrbWFsbG9jKHBhcmFtcy50cmFuc19sZW4sIEdGUF9LRVJORUwpOw0KPj4g
KwlpZiAoIXRyYW5zX2RhdGEpDQo+PiArCQlnb3RvIGVfZnJlZTsNCj4+ICsNCj4+ICsJZGF0YS0+
dHJhbnNfYWRkcmVzcyA9IF9fcHNwX3BhKHRyYW5zX2RhdGEpOw0KPj4gKwlkYXRhLT50cmFuc19s
ZW4gPSBwYXJhbXMudHJhbnNfbGVuOw0KPj4gKw0KPj4gKwkvKiBQaW4gZ3Vlc3QgbWVtb3J5ICov
DQo+PiArCXJldCA9IC1FRkFVTFQ7DQo+PiArCWd1ZXN0X3BhZ2UgPSBzZXZfcGluX21lbW9yeShr
dm0sIHBhcmFtcy5ndWVzdF91YWRkciAmIFBBR0VfTUFTSywNCj4+ICsJCQkJICAgIFBBR0VfU0la
RSwgJm4sIDApOw0KPj4gKwlpZiAoIWd1ZXN0X3BhZ2UpDQo+PiArCQlnb3RvIGVfZnJlZTsNCj4+
ICsNCj4+ICsJZGF0YS0+Z3Vlc3RfYWRkcmVzcyA9IF9fc21lX3BhZ2VfcGEoZ3Vlc3RfcGFnZVsw
XSkgKyBvZmZzZXQ7DQo+IA0KPiBJZiB0aGUgQy1iaXQgbmVlZHMgdG8gYmUgc2V0IHJlZ2FyZGxl
c3MgYmVsb3csIHRoZW4geW91IGRvbid0IG5lZWQgdGhlDQo+IF9fc21lIHZlcnNpb24gb2YgdGhp
cy4NCj4gDQoNCk5vdGVkLg0KDQo=
