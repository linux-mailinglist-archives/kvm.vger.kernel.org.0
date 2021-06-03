Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54C71399766
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 03:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbhFCBNl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 21:13:41 -0400
Received: from mga12.intel.com ([192.55.52.136]:40211 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229568AbhFCBNk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 21:13:40 -0400
IronPort-SDR: lZYfBjrYYvgLHZaSrKaiOsd/ae1WHAWTyCDGS5/4a3BdqJoghOYvUbHXSDOZ4Pv464ZtZDEq3S
 rqxxQ3PI9Gzw==
X-IronPort-AV: E=McAfee;i="6200,9189,10003"; a="183616418"
X-IronPort-AV: E=Sophos;i="5.83,244,1616482800"; 
   d="scan'208";a="183616418"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2021 18:11:56 -0700
IronPort-SDR: mq3rksswdiogvmlpGd6brqV/0DrPQTIn2yEMIOuatX18nc/8Vgo/Pjl5NXIKLERBMdztc2hsUH
 MJRbq0XHxnxQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,244,1616482800"; 
   d="scan'208";a="417146598"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga002.jf.intel.com with ESMTP; 02 Jun 2021 18:11:55 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Wed, 2 Jun 2021 18:11:54 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Wed, 2 Jun 2021 18:11:54 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Wed, 2 Jun 2021 18:11:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R+11ocAvKT8qldUWYABe6s75CNPtCEpj99tvoLqbimL/dEy670E7Bg2H4ea/Cyb6aA4ESjYqpmUY8/crrMp2pytCMkbmoRNTsutkN6QCEqcO/3AsQEMC7B71dVCAwM8VCsrN5qK0cUOaoXFt92zHSJgUcV84AewbkbHs03DlCtRFprKAR829hWkFWjePTka1fgYh8qhTBNoBaf34R10Qdg/MOxUewsBdBcPtJQBjIHM+oTLZYHnwi3jckoSlMoVzboUWyiZ968PCUaphqw7W4Ch2671Xhx9I/SLWtfPgf8YcaePXxIVzoa6zq3YcbXbY6qkR0UhJqS4+pHfyf2lkBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wPwW51P//vMq6YsQswokpGQYC9fQvJZHpKBlLz2vf8I=;
 b=La2mlitWxXs91S7rj9uZc+3qLvB+xbF4ZV1/Tr9XvjvNAVtLSwlYWKR1WdhCbpjjjZ78OLCIvvIL3hla2a/mvf7QFpRYWm5HDCUAitZj1cQYvW0FUKgltANp2UVSuGMowjGxuvm2Q9NqdGu+8uVp72k8PGxicmHg15wn7OgGlejKZkoB/ZQo0oEJ6yTkIHY9XoSpxc9cJNsABno/2uIit7rJ5oYvFZIMI4L4V7THSkG9+w6Mw3Gu6xXlOYwMzen9llYG5qkk5MnxRnzOYS3115ohPLcIzxWs6y+WJDm0g5QDTFkjr0/S2a38TVLSU21J1wDsOsWsU1ilaQcJr5WUag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wPwW51P//vMq6YsQswokpGQYC9fQvJZHpKBlLz2vf8I=;
 b=ndF043+fBfIP6dq220yJeu6COcBB8Y8aKGb08WhA+V+qP18597MBDVBT3lwRA1EkMKTVtTxDJakgWghoHQ+c68L1/xh0XHHQk87cgUacgnM3FYScrwftL4EGeBubuLiM1Wg0Yddj161zHDg++Tx0Lve1dJOdKvwmNHH3mtsCxUY=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by MWHPR11MB1614.namprd11.prod.outlook.com (2603:10b6:301:11::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Thu, 3 Jun
 2021 01:11:37 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1%12]) with mapi id 15.20.4173.030; Thu, 3 Jun 2021
 01:11:37 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        "Jiang, Dave" <dave.jiang@intel.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Dey, Megha" <megha.dey@intel.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH v6 00/20] Add VFIO mediated device support and DEV-MSI
 support for the idxd driver
Thread-Topic: [PATCH v6 00/20] Add VFIO mediated device support and DEV-MSI
 support for the idxd driver
Thread-Index: AQHXTqAZRXZQVBJp50eOXR3CymY0rKrxt7OAgA82YYCAAH+rgIAAHwJQ
Date:   Thu, 3 Jun 2021 01:11:37 +0000
Message-ID: <MWHPR11MB188664D9E7CA60782B75AC718C3C9@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
 <20210523232219.GG1002214@nvidia.com>
 <86cde154-37c7-c00d-b0c6-06b15b50dbf7@intel.com>
 <20210602231747.GK1002214@nvidia.com>
In-Reply-To: <20210602231747.GK1002214@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.142.24]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 961dedea-6d8f-4ef1-130a-08d9262c897d
x-ms-traffictypediagnostic: MWHPR11MB1614:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB1614BAF43F4BE239D623DCA48C3C9@MWHPR11MB1614.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KX6kUGh7yh6rCZDFdBpyIQO9CidwoERRiyGL1ti9m7PiSy/CGGzIS7IjPOwHgm23qomdSrVISxCaxRWO0azv7VJhGHG2+5DTPC2WxgHYz9Zr5mB4jkCfYrrdfMIOeulwEZ28b1JSvRAOikHYufgkSzBC2nfk6I/uqR05mXGmD8S9DnIFJ2FRwTxQCtJhVk+XQQFwH0L6F5ULARsmMFw/Hk6c33p5cGrLPMtAjSRWfhbd5j69MfJEzQRkU++WbQEoE6hI28+yOxPbCw8xRNQUi+AY0Npkr2EtN9sLSB2UvAYO9N0eqPBnefBoxjnIVCbzByKD6PeENrgXitHFNqdEFeUCKXpv3Z2Py4FJWpEElY+o1hOb/QhuXj9CVw7xcZQCUKeic14mnxxfVNaX1E9exwO0HoceoXtLKGGXOZaSWEacXPho8zWGcqCvzArz+nG5RSDANHW6U+vymW+LO+gAmp1uNBGzaadwpd0A4HF/ULE9pn97bbfzQTS0hRYJ2vxND/Z7rZBef7o8EZ4e6+LA9XBRY19W7GZdOtUy0t8YplCxG2dc9lclEiK6T6GYW0S9af+t9DApOrJaoqvN9jILb9HBqFurNU5HvS6FQTbenVM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(396003)(346002)(39860400002)(376002)(52536014)(5660300002)(76116006)(186003)(55016002)(66446008)(64756008)(478600001)(66556008)(66476007)(66946007)(122000001)(2906002)(33656002)(26005)(110136005)(316002)(54906003)(6506007)(53546011)(7696005)(71200400001)(4326008)(7416002)(6636002)(8676002)(86362001)(9686003)(38100700002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?SnpDRllqc0tGeU53SW84WitGamV1bGh3NWQvUXVHRXBBUHN1QmFoemorcE02?=
 =?utf-8?B?SGtyRHB6RW9yQlJ2MjFyVll5YVFMendUNEdlSTlhQ3pJMXBjajJTWURGNjNF?=
 =?utf-8?B?NEZCc3JFTk5ZSUlVRTExdkJMVlJldXovMS91VVVSZ0dlQUh6eHA2RHhxTE1p?=
 =?utf-8?B?VnpGVFhFQitXTEZTUnJPUmJZek5hYXNmWnhCaHhvbVUrL2Y2eUR6UWlDckIr?=
 =?utf-8?B?SHcxU2tNUjJ1NUtnOFB0NytleVdQdkhBWk95YzVhL1VYRElFN24zaE5hSFNV?=
 =?utf-8?B?MUhoU0V0RW5zd1B0bmdZckJDSFRObUkxb2NpbEFVNzdJTmtSVG5Mek82a3Bo?=
 =?utf-8?B?bndhSXdsVURsdFFJOEJseDd3cFBrM1JEOUtDdmRYbUFoL0lJNkFLU3JBZ3lQ?=
 =?utf-8?B?ZGtzNHhrb2d2QklDS0REeGhHSUs0V25PeGVpR3lCYW1vM0l6elRsamdTeWpq?=
 =?utf-8?B?UzdETDJRblY5NFVRTDdwdWhNTEJGbWdnVGdXY0dmb05BdkltNlZqODk3VWJx?=
 =?utf-8?B?c0szZnZBV0V4anJiak9scEwwcWR4aUtneXZYNnU0RFRhSEJlcVY4Q1J6a2x2?=
 =?utf-8?B?R3lQZ2haR3ZQS2ZtaU41ZXVZcnR6N0FvNHNmOHM0azdpbytjRjZUUE9mODNO?=
 =?utf-8?B?U2ZWVHIxbVVoZ2FONytOd2tKdUJDbGg0WFVNalZ2K1ducVJXTzZWMjJvT0ZZ?=
 =?utf-8?B?ZHZtQWhNQjJOemNGd3F2WStEbFQ2dzJUMUQxb3pDWjRhRC9DakpyRmZSaGlE?=
 =?utf-8?B?K2JBcVcvbG45cTFYQTEvZ2NZM3hpcUZPOVlGWFlSRG1adiswMlBwS1BSejBv?=
 =?utf-8?B?anRZdzNSYVZjdS9CMkRjZXNsL2pGUzJQSlpwRXh4SlVsZ2FFUTFWdnQyK244?=
 =?utf-8?B?WTdCaDhHLzBSUGJhYWFkL0dSMlhZOEJwaU85K21TZENHTkNscklYblZMeDYz?=
 =?utf-8?B?NzZWbHU5cXR2UUtxM3MvRzBWdzFMU21kTm9pcnY1NlQwcklDRXQ3a3BwUmtQ?=
 =?utf-8?B?S0tHRE5QWFl0SFBDSkhZZzNkMDB2d2RlUjRmaXYrR3ArQTAwRXNoOVl0cWw3?=
 =?utf-8?B?MmRtMEZaY1BacmJNeXEwQllsRDluNUdjWHo1NVZCZmlPWENxamdvbWFtellS?=
 =?utf-8?B?TGpnMXB1cU0yMUxsN1k3cXByYjFMNVMzeWFFajhTMFBRajY1Z1hpVmRhZEpQ?=
 =?utf-8?B?MmRRWStEVmk2N2ZXclZTNWJ1ck1YN0dsQk43RUFFSWc0aE1Ea1JhY3pvR2l6?=
 =?utf-8?B?UEVFUkFRUUg3amtQZ256cE93c3dnL2tSME1PcTJNaHMrcnNLUEl0N3VVaEVz?=
 =?utf-8?B?SmdyaVBTQkNzQTQ1ekY3aE1aZHd2S2d2RDZZYVYrSUg4TFhvTlpTRzZBazcv?=
 =?utf-8?B?YkRPNlRVa1QwZ2RUeUNVSVdqT3ZldHhJN0FSK21hcVVWeDRtOFZqWlY3NUhM?=
 =?utf-8?B?U3k0OHg1a3Y4b0hybmJVUUI3TG1yL1l5ZStHclFoeUtnSFZubFE4MVdJMVNl?=
 =?utf-8?B?dWJxOW00M2FTZVJNaEZsLzlTdUVQR2ZZZCtsdi9uUCs2L25idFhySi9jaG9n?=
 =?utf-8?B?Nll1N0F6MDFQUTE1eE8wRHR0ZW4yWmlUZlltWloxeGZlYWQrOTVDWkdhMjFl?=
 =?utf-8?B?MXE2Rzc1b01YT2VjaGViZ2FsSmFiamxnZ3pzQWFTd09jb292SmlGajZMLzBk?=
 =?utf-8?B?Ync0WnY5UWw2RXhGUHN5Vy8wVVN6VFJnZTQrcUxhWEIxbUh6QW9relN5Zlds?=
 =?utf-8?Q?4JVIKZP66Jb3IvfAyV8IJCL0rMkbHA2Oyow9Bty?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 961dedea-6d8f-4ef1-130a-08d9262c897d
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2021 01:11:37.3289
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HqEG/zVFTEwZCM/7AKnqLeOfUNJATnRtTOuXr090qX3Do4Te0F2c43Fm0L1xdf/TlyXTiq5/dJEhhXADdbSt4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1614
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPg0KPiBTZW50OiBUaHVyc2Rh
eSwgSnVuZSAzLCAyMDIxIDc6MTggQU0NCj4gDQo+IE9uIFdlZCwgSnVuIDAyLCAyMDIxIGF0IDA4
OjQwOjUxQU0gLTA3MDAsIERhdmUgSmlhbmcgd3JvdGU6DQo+ID4NCj4gPiBPbiA1LzIzLzIwMjEg
NDoyMiBQTSwgSmFzb24gR3VudGhvcnBlIHdyb3RlOg0KPiA+ID4gT24gRnJpLCBNYXkgMjEsIDIw
MjEgYXQgMDU6MTk6MDVQTSAtMDcwMCwgRGF2ZSBKaWFuZyB3cm90ZToNCj4gPiA+ID4gSW50cm9k
dWNpbmcgbWRldiB0eXBlcyDigJwxZHdxLXYx4oCdIHR5cGUuIFRoaXMgbWRldiB0eXBlIGFsbG93
cw0KPiA+ID4gPiBhbGxvY2F0aW9uIG9mIGEgc2luZ2xlIGRlZGljYXRlZCB3cSBmcm9tIGF2YWls
YWJsZSBkZWRpY2F0ZWQgd3FzLiBBZnRlcg0KPiA+ID4gPiBhIHdvcmtxdWV1ZSAod3EpIGlzIGVu
YWJsZWQsIHRoZSB1c2VyIHdpbGwgZ2VuZXJhdGUgYW4gdXVpZC4gT24gbWRldg0KPiA+ID4gPiBj
cmVhdGlvbiwgdGhlIG1kZXYgZHJpdmVyIGNvZGUgd2lsbCBmaW5kIGEgZHdxIGRlcGVuZGluZyBv
biB0aGUgbWRldg0KPiA+ID4gPiB0eXBlLiBXaGVuIHRoZSBjcmVhdGUgb3BlcmF0aW9uIGlzIHN1
Y2Nlc3NmdWwsIHRoZSB1c2VyIGdlbmVyYXRlZCB1dWlkDQo+ID4gPiA+IGNhbiBiZSBwYXNzZWQg
dG8gcWVtdS4gV2hlbiB0aGUgZ3Vlc3QgYm9vdHMgdXAsIGl0IHNob3VsZCBkaXNjb3ZlciBhDQo+
ID4gPiA+IERTQSBkZXZpY2Ugd2hlbiBkb2luZyBQQ0kgZGlzY292ZXJ5Lg0KPiA+ID4gPg0KPiA+
ID4gPiBGb3IgZXhhbXBsZSBvZiDigJwxZHdxLXYx4oCdIHR5cGU6DQo+ID4gPiA+IDEuIEVuYWJs
ZSB3cSB3aXRoIOKAnG1kZXbigJ0gd3EgdHlwZQ0KPiA+ID4gPiAyLiBBIHVzZXIgZ2VuZXJhdGVk
IHV1aWQuDQo+ID4gPiA+IDMuIFRoZSB1dWlkIGlzIHdyaXR0ZW4gdG8gdGhlIG1kZXYgY2xhc3Mg
c3lzZnMgcGF0aDoNCj4gPiA+ID4gZWNobyAkVVVJRCA+DQo+IC9zeXMvY2xhc3MvbWRldl9idXMv
MDAwMFw6MDBcOjBhLjAvbWRldl9zdXBwb3J0ZWRfdHlwZXMvaWR4ZC0xZHdxLQ0KPiB2MS9jcmVh
dGUNCj4gPiA+ID4gNC4gUGFzcyB0aGUgZm9sbG93aW5nIHBhcmFtZXRlciB0byBxZW11Og0KPiA+
ID4gPiAiLWRldmljZSB2ZmlvLXBjaSxzeXNmc2Rldj0vc3lzL2J1cy9wY2kvZGV2aWNlcy8wMDAw
OjAwOjBhLjAvJFVVSUQiDQo+ID4gPiBTbyB0aGUgaWR4ZCBjb3JlIGRyaXZlciBrbm93cyB0byBj
cmVhdGUgYSAidmZpbyIgd3Egd2l0aCBpdHMgb3duIG11Y2gNCj4gPiA+IG1hY2hpbmVyeSBidXQg
eW91IHN0aWxsIHdhbnQgdG8gaW52b2x2ZSB0aGUgaG9ycmlibGUgbWRldiBndWlkIHN0dWZmPw0K
PiA+ID4NCj4gPiA+IFdoeT8/DQo+ID4NCj4gPiBBcmUgeW91IHJlZmVycmluZyB0byBjYWxsaW5n
IG1kZXZfZGV2aWNlX2NyZWF0ZSgpIGRpcmVjdGx5IGluIHRoZSBtZGV2DQo+ID4gaWR4ZF9kcml2
ZXIgcHJvYmU/DQo+IA0KPiBObywganVzdCBjYWxsIHZmaW9fcmVnaXN0ZXJfZ3JvdXBfZGV2IGFu
ZCBmb3JnZXQgYWJvdXQgbWRldi4NCj4gDQo+ID4gSSB0aGluayB0aGlzIHdvdWxkIHdvcmsgd2l0
aCBvdXIgZGVkaWNhdGVkIHdxIHdoZXJlIGEgc2luZ2xlIG1kZXYNCj4gPiBjYW4gYmUgYXNzaWdu
ZWQgdG8gYSB3cS4NCj4gDQo+IE9rLCBzb3VuZHMgZ3JlYXQNCj4gDQo+ID4gSG93ZXZlciwgbGF0
ZXIgb24gd2hlbiB3ZSBuZWVkIHRvIHN1cHBvcnQgc2hhcmVkIHdxIHdoZXJlIHdlIGNhbg0KPiA+
IGNyZWF0ZSBtdWx0aXBsZSBtZGV2IHBlciB3cSwgd2UnbGwgbmVlZCBhbiBlbnRyeSBwb2ludCB0
byBkbyBzby4gSW4NCj4gPiB0aGUgbmFtZSBvZiBtYWtpbmcgdGhpbmdzIGNvbnNpc3RlbnQgZnJv
bSB1c2VyIHBlcnNwZWN0aXZlLCBnb2luZw0KPiA+IHRocm91Z2ggc3lzZnMgc2VlbXMgdGhlIHdh
eSB0byBkbyBpdC4NCj4gDQo+IFdoeSBub3QgdXNlIHlvdXIgYWxyZWFkeSB2ZXJ5IGNvbXBsaWNh
dGVkIGlkeGQgc3lzZnMgdG8gZG8gdGhpcz8NCj4gDQoNCkphc29uLCBjYW4geW91IGNsYXJpZnkg
eW91ciBhdHRpdHVkZSBvbiBtZGV2IGd1aWQgc3R1ZmY/IEFyZSB5b3UgDQpjb21wbGV0ZWx5IGFn
YWluc3QgaXQgb3IgY2FzZS1ieS1jYXNlPyBJZiB0aGUgZm9ybWVyLCB0aGlzIGlzIGEgYmlnDQpk
ZWNpc2lvbiB0aHVzIGl0J3MgYmV0dGVyIHRvIGhhdmUgY29uc2Vuc3VzIHdpdGggQWxleC9LaXJ0
aS4gSWYgdGhlDQpsYXR0ZXIsIHdvdWxkIGxpa2UgdG8gaGVhciB5b3VyIGNyaXRlcmlhIGZvciB3
aGVuIGl0IGNhbiBiZSB1c2VkDQphbmQgd2hlbiBub3QuLi4NCg0KVGhhbmtzDQpLZXZpbg0K
