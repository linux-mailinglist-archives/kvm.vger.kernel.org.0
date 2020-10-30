Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4417529FF5A
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 09:05:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725988AbgJ3IFB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 04:05:01 -0400
Received: from mga05.intel.com ([192.55.52.43]:31224 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725808AbgJ3IE7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Oct 2020 04:04:59 -0400
IronPort-SDR: 4E3CPRlyiFvVHPQyur7HD+4VSg/i6jidiHwhMVSlEeNV/ufBBGGI/04jShTvsLrWu/jUaS0P4Y
 cE+XPEJz6Iqw==
X-IronPort-AV: E=McAfee;i="6000,8403,9789"; a="253282810"
X-IronPort-AV: E=Sophos;i="5.77,432,1596524400"; 
   d="scan'208";a="253282810"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2020 01:04:59 -0700
IronPort-SDR: +r9CoGHPmMM8gPsly3DSA7WUCt6pfGykFkx87n80FjR4aAHNhJx/IzJIGJTSHEjsNrkgg3s3LB
 H+0VYuUvSVeA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,432,1596524400"; 
   d="scan'208";a="304869549"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by fmsmga007.fm.intel.com with ESMTP; 30 Oct 2020 01:04:59 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 30 Oct 2020 01:04:58 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 30 Oct 2020 01:04:58 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.176)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Fri, 30 Oct 2020 01:04:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RgyLHqu0ElF+7+mBuHCEIac7ZawES+Joi5XpYgLb4WvuEfKi3R/sYvHRMznUt839WxYN0/ZLXKT+hkdfH0Apz2gfkfBzWlUmv6SOsxLsPHcywQLGnFhD4yC5ElrCuuaFoChjqaqULV5tMbWnYsA4aHtAmak8RUxL0VgpoAyOj0iRUQmWs0Dvy2aToJxckpc5d0fe+ykhZReTkk0M0/lD9a0UorYwVmqE7pTnz/aluePI3QvmmPlBR13/UWuy0gIIygTvgAKdIKvZGbWnvauF0XnbV9vr87Py5PmYfxSWgt0YdQI9LS61JWVyttv+yps3Znz24RcYUpeVPTtUydcp3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+v5R9lavaqsW304bMnPvk2RaF4qGizFLQp/puAjVPi0=;
 b=F3DPU9j9LCNdlzacH0bjKV72dTQqJwBRmiXVN7s71MIHxYq+o3o3OCpcJ0xWkwFksww+Af/0l11T9cXEOZIFsz1DmTXvMQeesUKD13rORXCfDsTBPhZ8/iXF3da4Krh/smEHX3NZO8YYDUnaPb8IQtfl48MPbabWoNMicOzLn1vQ0EWiOju7vahkZN8SQB7HFIRnxGMFi2ySgdigrz3EdfOTePhsH3hrRgb5wWzD4NCsmzJ0NhYyF/Zd84EHfPNiSLs9fkFI+GadoYfGRTytLK9XRxj3zxUOPCpj/mMxKvlbXVmgH1NNHUmbRzx8c8I7su0hN810NuFy2QZXr50Ulw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+v5R9lavaqsW304bMnPvk2RaF4qGizFLQp/puAjVPi0=;
 b=ioI5SGkYvzZPvwH+ymqQZbjZRxBJ31h6tZKj8nyuBaymJ0npUvZs26FSiiRVP3mcn9SRTgev9BMsqO7AiaZWr2c50x5hobLbdISjoNbkW7BFclSlfE6qkeO5IFJOENUuRsj1u0C9wL79+F+pMUzIALhhquiCk2t2Jof6IQjUfsI=
Received: from MWHPR11MB1645.namprd11.prod.outlook.com (2603:10b6:301:b::12)
 by MWHPR1101MB2285.namprd11.prod.outlook.com (2603:10b6:301:57::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Fri, 30 Oct
 2020 08:04:54 +0000
Received: from MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::c88f:585f:f117:930b]) by MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::c88f:585f:f117:930b%8]) with mapi id 15.20.3477.034; Fri, 30 Oct 2020
 08:04:54 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>, "Wu, Hao" <hao.wu@intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "Raj, Ashok" <ashok.raj@intel.com>
Subject: RE: ENQCMD
Thread-Topic: ENQCMD
Thread-Index: AQHWrpFph6cQOfVFrUiBr+s3ZPoYi6mvxf9A
Date:   Fri, 30 Oct 2020 08:04:54 +0000
Message-ID: <MWHPR11MB164567FA998B13128EB284D48C150@MWHPR11MB1645.namprd11.prod.outlook.com>
References: <20201030075046.GA307361@stefanha-x1.localdomain>
In-Reply-To: <20201030075046.GA307361@stefanha-x1.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 79e31d81-dc4d-4509-8d51-08d87caa7c73
x-ms-traffictypediagnostic: MWHPR1101MB2285:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR1101MB228551A67B25C1515E90C5678C150@MWHPR1101MB2285.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /ogM1s2lMT6hV6L/jLerOq76IKA3ywpPdTwD1jqOx+GmhLhZQwZFSxCpy7hSZ6at+7VyNmiBdLjyQ5U7e1pKpgRLlQ+O4VfCjclO4Tk8mOI1+cM1EXgx9XGH90wpvU1QKAMYAN/07O7mcAN53qbvKVdoCSoBudlDXg24jZP2PmkJcEs5KEd1z3ZuL92Zm+aGPB154OL1gh97gXuVicYpjjV1aPrB8DhXrt5NYQNt+5YISQ6YbLPdiyYy0ztoeb56+e/5TcmKW7cy/B3x9ZhjGWEZ3mCueGGfiLUl63+xmzOA+rvMs43bptag6IIaVvOnORXv0Z31G403eoSpkUbCZZINzt2MK1bs6iMhRk+fbW0X9niJz+CRJJ2itHYl16jZ517paLge0w4J+ek7K19TsA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1645.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(136003)(396003)(346002)(376002)(54906003)(110136005)(5660300002)(107886003)(4326008)(26005)(2906002)(83380400001)(66946007)(7696005)(6506007)(64756008)(66556008)(66446008)(66476007)(33656002)(55016002)(6636002)(9686003)(76116006)(7116003)(71200400001)(86362001)(52536014)(3480700007)(186003)(8936002)(966005)(316002)(8676002)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: j3nPLaHDN0mxG5byJeMVGHP0q39vaO6sEp0wFxgZJHwLqvbUYdy2+wF80QeFJnCdzNv92gKyvfoeDPqWkQ8/p9nCMqCCh1b5tuvpNCKTqeEfIyvmRMnMCkQqePLp8z0D0j9kXcuWLuh04z1B++R6yB+tDLC2j2NM9p/GrBYQn/t98wrWRRiBFaQqdRDfRvSwqsSxlb9oWHS+u/kIMz76IiIqDEJqx7XRrDySDfRvp8Tzha1s86RDQtwFWogD5M0U5tAmpjqeVqAkZ3hmyL/qh8WkctDL3fwZs93hgse2W9Y5gQatlvHQpztZFH7TaRL8nWQNUbSyrhpxEanngsJawgF3ES3zwS/g2mg9vJvI4E7rBrKuO6tF1VHU0MWagSBbR3Yyyzs3pVycTqoO8jlV0L9RTLiRST6dF78Th5nZJAM7BqFBznPGoTLO+IucScAMUDmk/3IiEEXU1uNsm+KlpzUddZwKUbL3thKEnBQtiRzXieCDNcK8bmGkogDhvlcLiT92Gs1Z/K1th3I1QUD+hby/QZKBIZAeqngvXpPwl3V3goYP3dvbx7lQEvvkEAMfKlgrdYmaFzrQ43ATU68sONiiEMIJXRfO9irW2vCaCdhIi8nb2lOgcCiZh99/eMqH4HPosYJ7/O/PadxkDAPcFA==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1645.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79e31d81-dc4d-4509-8d51-08d87caa7c73
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2020 08:04:54.6057
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sCY/HaJhXujpFE3iOftKX7L+1LuXHzCdJF9T2DwmmBpW5tbXaFNrtgEdZo4ymiqU5nslmtqia+PtUcJ8q3dZcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2285
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBTdGVmYW4gSGFqbm9jemkgPHN0ZWZhbmhhQHJlZGhhdC5jb20+DQo+IFNlbnQ6IEZy
aWRheSwgT2N0b2JlciAzMCwgMjAyMCAzOjUxIFBNDQo+IA0KPiBIaSwNCj4gVGhlICJTY2FsYWJs
ZSBXb3JrIFN1Ym1pc3Npb24gaW4gRGV2aWNlIFZpcnR1YWxpemF0aW9uIiB0YWxrIGF0IEtWTQ0K
PiBGb3J1bSAyMDIwIHdhcyBpbnRlcmVzdGluZyBhbmQgSSBoYXZlIHNvbWUgYmVnaW5uZXIgcXVl
c3Rpb25zIGFib3V0DQo+IEVOUUNNRDoNCj4gaHR0cHM6Ly9zdGF0aWMuc2NoZWQuY29tL2hvc3Rl
ZF9maWxlcy9rdm1mb3J1bTIwMjAvMjIvU2NhbGFibGVfV29ya19TdQ0KPiBibWlzc2lvbl9Jbl9E
ZXZpY2VfVmlydHVhbGl6YXRpb24ucGRmDQo+IA0KPiBTZWN1cml0eQ0KPiAtLS0tLS0tLQ0KPiBJ
ZiB0aGUgRU5RQ01EIGluc3RydWN0aW9uIGlzIGFsbG93ZWQgZm9yIHVzZXJzcGFjZSBhcHBsaWNh
dGlvbnMsIGhvdyBjYW4NCj4gdGhleSBiZSBwcmV2ZW50ZWQgZnJvbSB3cml0aW5nIHRvIHRoZSBN
TUlPIGFkZHJlc3MgZGlyZWN0bHkgKHdpdGhvdXQgdGhlDQo+IEVOUUNNRCBpbnN0cnVjdGlvbikg
YW5kIGZha2luZyB0aGUgNjQtYnl0ZSBlbnF1ZXVlIHJlZ2lzdGVyIGRhdGEgZm9ybWF0Pw0KPiBG
b3IgZXhhbXBsZSwgdGhleSBjb3VsZCBzZXQgdGhlIFBSSVYgYml0IG9yIGFuIGFyYml0cmFyeSBQ
QVNJRC4NCg0KRU5RQ01EIHBheWxvYWQgaXMgdHJhbnNtaXR0ZWQgdGhyb3VnaCBETVdyIHRyYW5z
YWN0aW9ucyAoc2xpZGUgMTApLCB3aGljaA0KY2Fubm90IGJlIHRyaWdnZXJlZCB0aHJvdWdoIG90
aGVyIG1lbW9yeSBpbnN0cnVjdGlvbnMuIFRoZSBkZXZpY2UgcG9ydGFsDQpvbmx5IGhhbmRsZXMg
RE1XciB0cmFuc2FjdGlvbnMuDQoNClBSSVYgY2Fubm90IGJlIHNldCBieSBFTlFDTUQuIE9ubHkg
YnkgRU5RQ01EUyAoaW4gcmluZzApLg0KDQpQQVNJRCBpcyBjb3BpZWQgZnJvbSBhIE1TUiB3aGVu
IEVOUUNNRCBpcyBleGVjdXRlZC4gdGhlIE1TUiBpcyBtYW5hZ2VkDQpieSB0aGUga2VybmVsLiBV
c2Vyc3BhY2UgY2Fubm90IHNwZWNpZnkgaXQgZGlyZWN0bHkuDQoNCj4gDQo+IFdvcmsgUXVldWUg
RGVzaWduDQo+IC0tLS0tLS0tLS0tLS0tLS0tDQo+IEhhdmUgeW91IGxvb2tlZCBhdCBleHRlbmRp
bmcgZXhpc3RpbmcgaGFyZHdhcmUgaW50ZXJmYWNlcyBsaWtlIE5WTWUgb3INCj4gVklSVElPIHRv
IHN1cHBvcnQgZW5xdWV1ZSByZWdpc3RlcnM/DQoNClRoZSBmaXJzdCBkZXZpY2VzIHN1cHBvcnRp
bmcgRU5RQ01EIGFyZSBEU0EvSUFYLiBUaGUgbmF0aXZlIHN1cHBvcnQgDQpqdXN0IGxhbmRlZCBp
biB0aGUga2VybmVsLiBJbiBjb25jZXB0IGFueSBkZXZpY2Ugd2hpY2ggd2FudHMgdG8gc3VwcG9y
dA0Kc2hhcmVkIHdvcmsgcXVldWUgY2FuIGltcGxlbWVudCB0aGlzIGNhcGFiaWxpdHkuDQoNCj4g
DQo+IEhhdmUgeW91IGJlbmNobWFya2VkIE5WTWUgb3IgVklSVElPIGRldmljZXMgdXNpbmcgRU5R
Q01EIGluc3RlYWQgb2YNCj4gdGhlIHRyYWRpdGlvbmFsIHN1Ym1pc3Npb24gcXVldWluZyBtZWNo
YW5pc20/DQoNCk5vLiBXZSBkb24ndCBoYXZlIHN1Y2ggZGV2aWNlcyB5ZXQuDQoNCj4gDQo+IElz
IEVOUUNNRCBmYXN0ZXIgdGhhbiB0cmFkaXRpb25hbCBJL08gcmVxdWVzdCBzdWJtaXNzaW9uPyBJ
ZiBub3QsIHRoZW4gSQ0KPiBndWVzcyBpdCdzIG9ubHkgaW50ZW5kZWQgZm9yIHNoYXJlZCBxdWV1
ZXMgd2hlcmUgdGhlIFBBU0lEIHRyYW5zbGF0aW9uDQo+IGlzIG5lZWRlZD8NCg0KRU5RQ01EIGlz
IG5vbi1wb3N0ZWQgdHJhbnNhY3Rpb24uIFNvIGl0J3MgYSBsaXR0bGUgYml0IHNsb3dlciB0aGFu
IG5vcm1hbA0Kd3JpdGVzLiBUaGUgcG9pbnQgaXMgdG8gY2FycnkgJ3JldHJ5JyBzaWduYWwgYmFj
ayBpbiBjYXNlIG9mIHJlc291cmNlIGNvbnRlbnRpb24uDQoNCmFuZCA2NGJ5dGVzIHBheWxvYWQg
aXMgYWxzbyBhbiBhZHZhbnRhZ2UuIGUuZy4gZm9yIERTQS9JQVggdGhlIHdob2xlDQp3b3JrIGRl
c2NyaXB0b3IgY2FuIGJlIGluY2x1ZGVkIGluIHRoZSBFTlFDTUQgcGF5bG9hZC4NCg0KPiANCj4g
QSBmZXcgdGhvdWdodHMgY29tZSB0byBtaW5kOg0KPiANCj4gICogVHJhZGl0aW9uYWwgc3VibWlz
c2lvbiBxdWV1ZXMgYXJlIG5vIGxvbmdlciBuZWVkZWQgYW5kIGNhbiBiZQ0KPiAgICByZXBsYWNl
ZCBieSBhbiBlbnF1ZXVlIHJlZ2lzdGVyLiBOVk1lIHNxcyBhbmQgVklSVElPIGF2YWlsIHJpbmdz
DQo+ICAgIGFyZW4ndCBuZWVkZWQgYW55bW9yZSwgYWx0aG91Z2ggdGhlIHNxZXMgYW5kIHZyaW5n
IGRlc2NyaXB0b3JzIGFyZQ0KPiAgICBzdGlsbCBuZWVkZWQgdG8gcmVwcmVzZW50IGNvbW1hbmRz
IGFuZCBidWZmZXJzLg0KDQp5ZXMsIHRoaXMgaXMgb25lIHBvc3NpYmxlIGVuaGFuY2VtZW50Lg0K
DQo+IA0KPiAgICBPciB0aGUgZW5xdWV1ZSByZWdpc3RlciBjYW4gYmUgdXNlZCBzaW1wbHkgYXMg
YSBkb29yYmVsbCB0byBzdGFydCBETUENCj4gICAgcmVhZGluZyByZXF1ZXN0cyBmcm9tIGEgdHJh
ZGl0aW9uYWwgc3VibWlzc2lvbiBxdWV1ZS4gSW4gdGhpcyBjYXNlDQo+ICAgIHRoZSBhZHZhbnRh
Z2UgaXMgdGhhdCBhIHNpbmdsZSBzaGFyZWQgaGFyZHdhcmUgdW5pdCAoQURJKSBjYW4gZW11bGF0
ZQ0KPiAgICBtdWx0aXBsZSBxdWV1ZXMgYXQgdGhlIHNhbWUgdGltZS4NCj4gDQo+ICAqIEluIG9y
ZGVyIHRvIHN1cHBvcnQgc3VibWl0dGluZyBtdWx0aXBsZSByZXF1ZXN0cyBpbiBhIHNpbmdsZSBl
bnF1ZXVlDQo+ICAgIHJlZ2lzdGVyIGFjY2VzcyB0aGVyZSBuZWVkcyB0byBiZSBzb21lIGtpbmQg
b2YgY2hhaW5pbmcgbWVjaGFuaXNtLg0KPiAgICBGb3IgZXhhbXBsZSwgdGhlIERldmljZSBTcGVj
aWZpYyBDb21tYW5kIGZpZWxkIGNvbnRhaW5zIGEgbnVtX3JlcXMNCj4gICAgZmllbGQgdGVsbGlu
ZyB0aGUgZGV2aWNlIGhvdyBtYW55IHJlcXVlc3RzIHRvIERNQS4NCg0KeWVzLCB0aGlzIGxlYXZl
cyB0byBkZXZpY2Ugc3BlY2lmaWMgZm9ybWF0LiBlLmcuIERTQSBkZWZpbmVzIGEgY2hhaW5pbmcN
CmRlc2NyaXB0IHR5cGUgdG8gY2hhaW4gbXVsdGlwbGUgcmVxdWVzdHMgdG9nZXRoZXIuDQoNCj4g
DQo+IEkgZG9uJ3Qga25vdyBtdWNoIGFib3V0IEVOUUNNRCBhbmQgYW0gdHJ5aW5nIHRvIGZpZ3Vy
ZSBvdXQgd2hlcmUgaXQgZml0cw0KPiBpbi4gUGxlYXNlIGxldCBtZSBrbm93IGlmIHRoaXMgbWF0
Y2hlcyBob3cgdGhpcyBmZWF0dXJlIGlzIGludGVuZGVkIHRvDQo+IGJlIHVzZWQuDQo+IA0KDQpJ
IHRoaW5rIHlvdSBjYXB0dXJlZCBtb3N0IG9mIHRoZSBpbnRlbnRpb24gb2YgIEVOUUNNRC4g8J+Y
ig0KDQpUaGFua3MNCktldmluDQo=
