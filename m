Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4336258C02
	for <lists+kvm@lfdr.de>; Tue,  1 Sep 2020 11:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbgIAJse (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Sep 2020 05:48:34 -0400
Received: from mga01.intel.com ([192.55.52.88]:45983 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725848AbgIAJsd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Sep 2020 05:48:33 -0400
IronPort-SDR: GwY50oq4SBhA1ZZaHeZphMVW7GQx1nlLkVbbL/43lKgaT4WkNPEnZElv4Ja+c/jjo+ns9125hg
 GHiWasgv3X7Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9730"; a="175182513"
X-IronPort-AV: E=Sophos;i="5.76,378,1592895600"; 
   d="scan'208";a="175182513"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2020 02:48:28 -0700
IronPort-SDR: 4q/8Z+HM4L+2cyvEXpy266+QgYYO5JBN4wZuUOAgH36/4+M+6u3aICYHyd/LnGMl1RW2jo14vV
 cPrkRTMQnLow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,378,1592895600"; 
   d="scan'208";a="375098680"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by orsmga001.jf.intel.com with ESMTP; 01 Sep 2020 02:48:28 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 1 Sep 2020 02:45:38 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 1 Sep 2020 02:45:37 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 1 Sep 2020 02:45:37 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (104.47.37.51) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Tue, 1 Sep 2020 02:45:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wbydlf5kxtLYEkXGwS5TgoUotT2li+3Bt1LFCBVDzgETVoGKOwv+FUkDYYaWSfT3r8qm0K4YY3gPad7J8Uaf1QHN1YlwEjz2opOiZ6IXC8bTHSM/pSe9ku7KMynTuOwPkRzblIwzbTVgL8FmfRtHHEsBk8oydEu/vTtNcByws4bA+Y14Ch3V/eohTgWzUHr8DS9M4ha68jn3cRI1pCAwKdJsVu7LHT+bD6fyuq8iA6CRqK4RIx5kmGFPw7WS9Ewk3xAMFJXtWKMBJ192NwA8TjC7yDDpmyiAwTmWR/0Cnd34nDq8GeTB/kGx5+yMw94fk6TVI9EG3eU1ZPNltE9G/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C4GXdHmsI71qYCqQLOMfb6xIChtQ1JeNzjKFxQQBqRI=;
 b=WSXzXFpOIwRH331NDdjxfAGEwa6876qVYz/WCIN7wb+qnfwoU/AP5CGrpsLBwchYmTTzMtb/rv65NyxnFe83Ybc0PUNWVSpVK/+vcrvp2Qnhojx3G7X2aGfhLOSNvz4xANKzBXh9B5dcs2CzusP2ck+zSJ6yDf9PtNtwVfJAspJBTZ8RaLg0wzUc7EnIfEV8AnBp9kXVpedTwdF5QV1HmneEMRoQLnR5ZLfWarIRvzFg6hVZ3Q5nPSydM4pGVM6OlqZuo4E8q8TOjiEMUVTv9d+bphG+G01Gxy7FUmZiiZM68Vj8gPD+WNK0UnYT23hPCgbOrCg/CRKc0mWj5RDacw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C4GXdHmsI71qYCqQLOMfb6xIChtQ1JeNzjKFxQQBqRI=;
 b=KJhctEzslsmMd+AMKnJn0+Iv2lfXtcVdLoKjEr+4A5rAf5RNiUUw8hfdiRD85zeujX6tmKrfUvQw62C/BHVNjxjCh3FN7BRRw/mZsoRx4OEU8Hyd0GG+tEbdCAn8ZB+N2XD2Iq8waQ//WBU/eysxmLjG3x3e19ldRBn6HnE91Io=
Received: from MWHPR11MB1645.namprd11.prod.outlook.com (2603:10b6:301:b::12)
 by MWHPR11MB2045.namprd11.prod.outlook.com (2603:10b6:300:29::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.22; Tue, 1 Sep
 2020 09:45:29 +0000
Received: from MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::6dfe:feb8:25f1:ac9c]) by MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::6dfe:feb8:25f1:ac9c%7]) with mapi id 15.20.3326.025; Tue, 1 Sep 2020
 09:45:29 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Niklas Schnelle <schnelle@linux.ibm.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     Matthew Rosato <mjrosato@linux.ibm.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "pmorel@linux.ibm.com" <pmorel@linux.ibm.com>,
        "mpe@ellerman.id.au" <mpe@ellerman.id.au>,
        "oohall@gmail.com" <oohall@gmail.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: RE: [PATCH v3] PCI: Introduce flag for detached virtual functions
Thread-Topic: [PATCH v3] PCI: Introduce flag for detached virtual functions
Thread-Index: AQHWcYg/TyRozVVkm0OIcCd0yq3sd6lMXYkAgAAM5gCAABUsgIAA0zqAgAZGScA=
Date:   Tue, 1 Sep 2020 09:45:29 +0000
Message-ID: <MWHPR11MB16451C94F2A2E7D57AEFE6E68C2E0@MWHPR11MB1645.namprd11.prod.outlook.com>
References: <20200827203335.GA2101829@bjorn-Precision-5520>
 <babde252-4909-9d3b-e5dc-bae4e6a20cd1@linux.ibm.com>
In-Reply-To: <babde252-4909-9d3b-e5dc-bae4e6a20cd1@linux.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.202]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6b63a050-2efd-4ebc-b016-08d84e5bc306
x-ms-traffictypediagnostic: MWHPR11MB2045:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB204552B2D8A8EA7BABF78D4B8C2E0@MWHPR11MB2045.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8HJadSrKTeEKIiD/+/R017unG93P8nfCA5OHUIfxbQzblW/VTm1K9kwxatM9CCZUnquqAcXBV+FmRdyxj4V99BpXrYm9K46kHeC3cvnO9M5e27sJcdUBmtXl4lPELV8KWi9PMgt00jBSlpXWRDcPdrzxoF6nrDG0U+qYx4ejeRABLMmg3u+YjD3atpUrkV3gKxqAcVXJ16bUC6CfbXuou4j77tnqyY1FzdWKF2DTKyLlOAk1Uun0u1z9sbH4PjV/Gtyw4zk/o2IoG7QnE55k/JmdpcD2Qh5Y77bVPtiMf6jDNgaTTpIKyGJgQt0OJMkKzkPTt3WHJ26HVmTCPMzBgQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1645.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(366004)(376002)(136003)(396003)(8676002)(83380400001)(86362001)(71200400001)(2906002)(316002)(26005)(186003)(478600001)(7416002)(76116006)(66946007)(9686003)(53546011)(54906003)(5660300002)(8936002)(66556008)(107886003)(52536014)(110136005)(7696005)(33656002)(64756008)(6506007)(66476007)(66446008)(4326008)(55016002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 5geBquPKTgAq/xyyJRorMdt4YaMgEggbk/C2SjtBlzFQq23Bl5Mlh9ytfc2pKVe+afMLQmlfXiMI+Ig3d6gZhteulf8rUYkPW7E5PL1FFH9QT0308+s9wdUdYCcEHry39mxUHZo+s1X3W7jeUdgo4vcxI5Jb7A3Cbra4o9X9CoS9/T+4xV0Ni7q75Rgse3YjDbpRqQBIx5WtsNtXF3CMutXZFuywOQ60PnH9eZI3l8vxzg7F7Mo40RLjZctePwQWcRnuN8DViILK8mzs7yBDXRopQcLDhxBuGLcZpoh7ujNq39EDNYJfXGnD8TT2Sfv3gMmRUlk/uWf1PnZlMGIvLweIQQvKAY8SpnxG4DCPMtPi1mXi3WQhZzDJGLMs8MNdMilTnlhmMtsH/E2oV/xuSZ/ulmfkw40ViJEybFDkUsSM5a7NHD0Cf5N82nyVlLiB/upvA4F5FmaoxF9FmF+AHYBtXMnu858Vquh3gyzPsHrj0em7kinthbFKCGZaHwijs2Ha2gjLg3PyALymFee0YcHRv5v0P4/+i+XAfIe/nPeH//qzIzaI91pBLWrBtbbtkt998s7L9JL7v7YCOlnsLyvWTGziiIeatGTVUQMlDzlAEKeYwF8CPyp6g+YBxVaI+eDdlsBdjNUQJKlHIyMduw==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1645.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b63a050-2efd-4ebc-b016-08d84e5bc306
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Sep 2020 09:45:29.2651
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oFMIjHgXz0Ev7VUtei/s1DD4rpvV0492UsPnbEKyO+J/j1arI9bYmbclfo2R4hWN2WdSRpc9QmJFVxMRRhuZVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB2045
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBrdm0tb3duZXJAdmdlci5rZXJuZWwub3JnIDxrdm0tb3duZXJAdmdlci5rZXJuZWwu
b3JnPiBPbiBCZWhhbGYNCj4gT2YgTmlrbGFzIFNjaG5lbGxlDQo+IFNlbnQ6IEZyaWRheSwgQXVn
dXN0IDI4LCAyMDIwIDU6MTAgUE0NCj4gVG86IEJqb3JuIEhlbGdhYXMgPGhlbGdhYXNAa2VybmVs
Lm9yZz47IEFsZXggV2lsbGlhbXNvbg0KPiA8YWxleC53aWxsaWFtc29uQHJlZGhhdC5jb20+DQo+
IA0KWy4uLl0NCj4gPj4NCj4gPj4gRldJVywgcGNpX3BoeXNmbigpIG5ldmVyIHJldHVybnMgTlVM
TCwgaXQgcmV0dXJucyB0aGUgcHJvdmlkZWQgcGRldiBpZg0KPiA+PiBpc192aXJ0Zm4gaXMgbm90
IHNldC4gIFRoaXMgcHJvcG9zYWwgd291bGRuJ3QgY2hhbmdlIHRoYXQgcmV0dXJuIHZhbHVlLg0K
PiA+PiBBSVVJIHBjaV9waHlzZm4oKSwgdGhlIGNhbGxlciBuZWVkcyB0byB0ZXN0IHRoYXQgdGhl
IHJldHVybmVkIGRldmljZSBpcw0KPiA+PiBkaWZmZXJlbnQgZnJvbSB0aGUgcHJvdmlkZWQgZGV2
aWNlIGlmIHRoZXJlJ3MgcmVhbGx5IGNvZGUgdGhhdCB3YW50cyB0bw0KPiA+PiB0cmF2ZXJzZSB0
byB0aGUgUEYuDQo+ID4NCj4gPiBPaCwgc28gdGhpcyBWRiBoYXMgaXNfdmlydGZuPT0wLiAgVGhh
dCBzZWVtcyB3ZWlyZC4gIFRoZXJlIGFyZSBsb3RzIG9mDQo+ID4gb3RoZXIgd2F5cyB0aGF0IGEg
VkYgaXMgZGlmZmVyZW50OiBWZW5kb3IvRGV2aWNlIElEcyBhcmUgMHhmZmZmLCBCQVJzDQo+ID4g
YXJlIHplcm9lcywgZXRjLg0KPiA+DQo+ID4gSXQgc291bmRzIGxpa2UgeW91J3JlIHN3ZWVwaW5n
IHRob3NlIHVuZGVyIHRoZSBydWcgYnkgYXZvaWRpbmcgdGhlDQo+ID4gbm9ybWFsIGVudW1lcmF0
aW9uIHBhdGggKGUuZy4sIHlvdSBkb24ndCBoYXZlIHRvIHNpemUgdGhlIEJBUnMpLCBidXQNCj4g
PiBpZiBpdCBhY3R1YWxseSBpcyBhIFZGLCBpdCBzZWVtcyBsaWtlIHRoZXJlIG1pZ2h0IGJlIGZl
d2VyIHN1cnByaXNlcw0KPiA+IGlmIHdlIHRyZWF0IGl0IGFzIG9uZS4NCj4gPg0KPiA+IFdoeSBk
b24ndCB5b3UganVzdCBzZXQgaXNfdmlydGZuPTEgc2luY2UgaXQgKmlzKiBhIFZGLCBhbmQgdGhl
biBkZWFsDQo+ID4gd2l0aCB0aGUgc3BlY2lhbCBjYXNlcyB3aGVyZSB5b3Ugd2FudCB0byB0b3Vj
aCB0aGUgUEY/DQo+ID4NCj4gPiBCam9ybg0KPiA+DQo+IA0KPiBBcyB3ZSBhcmUgYWx3YXlzIHJ1
bm5pbmcgdW5kZXIgYXQgbGVhc3QgYSBtYWNoaW5lIGxldmVsIGh5cGVydmlzb3INCj4gd2UncmUg
c29tZXdoYXQgaW4gdGhlIHNhbWUgc2l0dWF0aW9uIGFzIGUuZy4gYSBLVk0gZ3Vlc3QgaW4NCj4g
dGhhdCB0aGUgVkZzIHdlIHNlZSBoYXZlIHNvbWUgZW11bGF0aW9uIHRoYXQgbWFrZXMgdGhlbSBh
Y3QgbW9yZSBsaWtlDQo+IG5vcm1hbCBQQ0kgZnVuY3Rpb25zLiBJdCBqdXN0IHNvIGhhcHBlbnMg
dGhhdCB0aGUgbWFjaGluZSBsZXZlbCBoeXBlcnZpc29yDQo+IGRvZXMgbm90IGVtdWxhdGUgdGhl
IFBDSV9DT01NQU5EX01FTU9SWSwgaXQgZG9lcyBlbXVsYXRlIEJBUnMgYW5kDQo+IFZlbmRvci9E
ZXZpY2UgSURzDQo+IHRob3VnaC4NCj4gU28gaXNfdmlydGZuIGlzIDAgZm9yIHNvbWUgVkYgZm9y
IHRoZSBzYW1lIHJlYXNvbiBpdCBpcyAwIG9uDQo+IEtWTS9FU1hpL0h5cGVyVi9KYWlsaG91c2Xi
gKYNCj4gZ3Vlc3RzIG9uIG90aGVyIGFyY2hpdGVjdHVyZXMuDQoNCkkgd29uZGVyIHdoZXRoZXIg
aXQncyBhIGdvb2QgaWRlYSB0byBhbHNvIGZpbmQgYSB3YXkgdG8gc2V0IGlzX3ZpcnRmbg0KZm9y
IG5vcm1hbCBLVk0gZ3Vlc3Qgd2hpY2ggZ2V0IGEgdmYgYXNzaWduZWQuIFRoZXJlIGFyZSBvdGhl
ciBjYXNlcyANCndoZXJlIGZhaXRoZnVsIGVtdWxhdGlvbiBvZiBjZXJ0YWluIFBDSSBjYXBhYmls
aXRpZXMgaXMgZGlmZmljdWx0LCBlLmcuIA0Kd2hlbiBlbmFibGluZyBndWVzdCBTVkEgcmVsYXRl
ZCBmZWF0dXJlcyAoUEFTSUQvQVRTL1BSUykuIFBlciBQQ0llIA0Kc3BlYywgc29tZSBvciBhbGwg
ZmllbGRzIG9mIHRob3NlIGNhcGFiaWxpdGllcyBhcmUgc2hhcmVkIGJldHdlZW4gUEYgDQphbmQg
VkYuIEFtb25nIHRoZW06DQoNCjEpIFNvbWUgY291bGQgYmUgZW11bGF0ZWQgcHJvcGVybHkgYW5k
IGluZGlyZWN0bHkgcmVmbGVjdGVkIGluIGhhcmR3YXJlLCANCmUuZy4gSW50ZWwgVlQtZCBhbGxv
d3MgYWRkaXRpb25hbCBjb250cm9sIHBlciBWRiBhYm91dCB3aGV0aGVyIHRvIGFjY2VwdCANCnBh
Z2UgcmVxdWVzdCwgZXhlY3V0ZS9wcml2aWxlZ2VkIHBlcm1pc3Npb24sIGV0Yy4gdGh1cyBhbGxv
d2luZyBWRi1zcGVjaWZpYyANCmNvbnRyb2wgZXZlbiB3aGVuIGRldmljZS1zaWRlIHNldHRpbmcg
aXMgc2hhcmVkOw0KCQ0KMikgU29tZSBjb3VsZCBiZSBwdXJlbHkgZW11bGF0ZWQgaW4gc29mdHdh
cmUgYW5kIGl0J3MgaGFybWxlc3MgdG8gbGVhdmUNCnRoZSBoYXJkd2FyZSBmb2xsb3dpbmcgUEYg
c2V0dGluZywgZS5nLiBBVFMgZW5hYmxlLCBTVFUoPyksIG91dHN0YW5kaW5nDQpwYWdlIHJlcXVl
c3QgYWxsb2NhdGlvbiwgZXRjLjsNCg0KMykgSG93ZXZlciwgSSBkaWRu4oCZdCBzZWUgYSBjbGVh
biB3YXkgb2YgZW11bGF0aW5nIHBhZ2VfcmVxdWVzdF9jdHJsLnJlc2V0DQphbmQgcGFnZV9yZXF1
ZXN0X3N0YXR1cy5zdG9wcGVkLiBUaG9zZSB0d28gaGF2ZSBjbGVhciBkZWZpbml0aW9uIGFib3V0
DQpvdXRzdGFuZGluZyBwYWdlIHJlcXVlc3RzLiBUaGV5IGFyZSBzaGFyZWQgdGh1cyB3ZSBjYW5u
b3QgaXNzdWUgcGh5c2ljYWwNCmFjdGlvbiBqdXN0IGR1ZSB0byByZXF1ZXN0IG9uIG9uZSBWRiwg
d2hpbGUgcHVyZSBzb2Z0d2FyZSBlbXVsYXRpb24gDQpjYW5ub3QgZ3VhcmFudGVlIHRoZSBkZXNp
cmVkIGV4cGVjdGF0aW9uLiBPZiBjb3Vyc2UgdGhpcyBpc3N1ZSBhbHNvIGV4aXN0cw0KZXZlbiBv
biBiYXJlIG1ldGFsIC0gcGNpX2VuYWJsZS9kaXNhYmxlL3Jlc2V0X3ByaSBqdXN0IGRvIG5vdGhp
bmcgZm9yDQp2Zi4gQnV0IHRoZXJlIGlzIGNoYW5jZSB0byBtaXRpZ2F0ZSAoZS5nLiB0aW1lb3V0
KSwgYnV0IG5vdCBwb3NzaWJsZSBpbiBndWVzdA0KaWYgdGhlIGd1ZXN0IGRvZXNuJ3Qga25vdyBp
dCdzIGFjdHVhbGx5IGEgVkYuDQoNClNldHRpbmcgaXNfdmlydGZuPTEgYWxsb3dzIGd1ZXN0IHRv
IGJlIGNvb3BlcmF0aXZlIGxpa2UgcnVubmluZyB0b2dldGhlcg0Kd2l0aCBQRiBkcml2ZXIuIEJ1
dCB0aGVyZSBpcyBhbiBvcmRlcmluZyBpc3N1ZS4gVGhlIGd1ZXN0IGtub3dzIHdoZXRoZXINCmEg
ZGV2aWNlIGlzIFZGIG9ubHkgd2hlbiB0aGUgVkYgZHJpdmVyIGlzIGxvYWRlZCAoYmFzZWQgb24g
UENJX0lEKSwgYnV0DQpyZWxhdGVkIGNhcGFiaWxpdGllcyBtaWdodCBiZSBhbHJlYWR5IGVuYWJs
ZWQgd2hlbiBhdHRhY2hpbmcgdGhlIGRldmljZQ0KdG8gSU9NTVUgKGF0IGxlYXN0IGZvciBpbnRl
bF9pb21tdSkuIEJ1dCBzdXBwb3NlIGl0J3Mgbm90IGEgaGFyZCBmaXguDQpMYXN0LCBkZXRhY2hl
ZCB2ZiBpcyBub3QgYSBQQ0lTSUcgZGVmaW5pdGlvbi4gU28gdGhlIGhvc3Qgc3RpbGwgbmVlZHMg
dG8NCmRvIHByb3BlciBlbXVsYXRpb24gKGV2ZW4gbm90IGZhaXRoZnVsKSBvZiB0aG9zZSBjYXBh
YmlsaXRpZXMgZm9yIGd1ZXN0cyANCndobyBkb24ndCByZWNvZ25pemUgZGV0YWNoZWQgdmYuDQoN
ClRob3VnaHRzPw0KDQpUaGFua3MNCktldmluDQo=
