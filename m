Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52A6528D8EE
	for <lists+kvm@lfdr.de>; Wed, 14 Oct 2020 05:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729258AbgJNDQa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Oct 2020 23:16:30 -0400
Received: from mga18.intel.com ([134.134.136.126]:16589 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726049AbgJNDQa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Oct 2020 23:16:30 -0400
IronPort-SDR: btSobpPqWRXMBIGf8wekK/kw5Uo1PAj5cSEFWLFRPSopFAzJHgk8CiSqRDBBNqEr/I8O6HARwL
 7+sb3RNA7ROA==
X-IronPort-AV: E=McAfee;i="6000,8403,9773"; a="153858664"
X-IronPort-AV: E=Sophos;i="5.77,373,1596524400"; 
   d="scan'208";a="153858664"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2020 20:16:28 -0700
IronPort-SDR: 6QCFfIZ128vB61U1C+aj3TZPFYr7NkXBD2B4QKX5OJQAL5CB348XvFnzNsyPopLzJs+klu2Dmr
 EwgP23Oq6ekA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,373,1596524400"; 
   d="scan'208";a="299813896"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by fmsmga007.fm.intel.com with ESMTP; 13 Oct 2020 20:16:28 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 13 Oct 2020 20:16:28 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 13 Oct 2020 20:16:27 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 13 Oct 2020 20:16:27 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Tue, 13 Oct 2020 20:16:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CiuOUieHfdHKZJwIpIBUURu+NZPzy0Vnvt0JFKad8pgBamNYlybBATXSHA7nn8Ew2BfBnt4+UfdO0b7KgkkDdwkHZyf/s19gvw/9KDiXwSTtvkF8T0SgKxugn8++bsRCCkjZuL/ghIepIQoDRDFoIj0yPXP/pZhi8Fcj8fTrKvNhT/rkcTs1IGXDfoIftMj0i905NwDr1I/IK1iZRG/GuOpiyeUL0fJTH2L4FyEyaAMqQ3tQyIeYG8PvWlGF5bknwud4CYhX67Oj/FfQiJT/1kfbZEvc2AkbVnJK+PUNN11uFO5Vu7mk66daFyYI7iGCzQnNmyaka28QUu3GXFKjYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OyP74VFb83xsN+co1DLSiZl3jyOmtX15n15xQPVZHpY=;
 b=NuIsfK/7SVC/Ii6joQgSorCTgB0b98pMKxZaJq4w8sN+gifTagO2tWmgwYNHHIp9rYcTaiOpt8WmS9TU/L3Nkf0eq1pZnKQO5EzA0fPnL0ZZu2YTzMNiCQeBWSpUeV8pSJt2PAQZQH/S60AF2N0gIemqFb+KLo1LT/Q+rlcCoXw2KC1UFvwbu5bxItm0XtreXJ2E2qoVwHNMNYtp/Fz6ajxxs6wjOcoHJTR79TyTEne4A+ItzrxlcPNPYcDzsM91i8B9HMgw7lDpeiRY+QciMe8a+3gqqjJ7Y/fAx5Vu235ptVDnz8AscCUqMPNHZwLNxOeVyRg0rac/HJJ5PY3RdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OyP74VFb83xsN+co1DLSiZl3jyOmtX15n15xQPVZHpY=;
 b=KP/OdPTsNoGbS6iioZeimHhLB0X/s5StnCCte7tOfPT30OqejIdWCkJa9Owz9f5qrpYjJONKgyJchVTehdbehktgs5sanM8JsAxFq+iYctbESeVvLPqLhTDJxWHym/+EQcemwlP+8AZQ484EhUcMzjdo4Rgb8GE+zM37AdPYol0=
Received: from MWHPR11MB1645.namprd11.prod.outlook.com (2603:10b6:301:b::12)
 by MW3PR11MB4603.namprd11.prod.outlook.com (2603:10b6:303:5e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.22; Wed, 14 Oct
 2020 03:16:22 +0000
Received: from MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::c88f:585f:f117:930b]) by MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::c88f:585f:f117:930b%8]) with mapi id 15.20.3455.032; Wed, 14 Oct 2020
 03:16:22 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Wang <jasowang@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>
CC:     "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Wu, Hao" <hao.wu@intel.com>,
        "stefanha@gmail.com" <stefanha@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: RE: (proposal) RE: [PATCH v7 00/16] vfio: expose virtual Shared
 Virtual Addressing to VMs
Thread-Topic: (proposal) RE: [PATCH v7 00/16] vfio: expose virtual Shared
 Virtual Addressing to VMs
Thread-Index: AdagceQQLvqwjRCrQOaq1hZ7MgDUUABZWmqg
Date:   Wed, 14 Oct 2020 03:16:22 +0000
Message-ID: <MWHPR11MB1645AE971BD8DAF72CE3E1198C050@MWHPR11MB1645.namprd11.prod.outlook.com>
References: <MWHPR11MB1645CFB0C594933E92A844AC8C070@MWHPR11MB1645.namprd11.prod.outlook.com>
In-Reply-To: <MWHPR11MB1645CFB0C594933E92A844AC8C070@MWHPR11MB1645.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.215]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1c738281-2b06-4952-544c-08d86fef8726
x-ms-traffictypediagnostic: MW3PR11MB4603:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR11MB460339A11309AD66746F1D868C050@MW3PR11MB4603.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Id3HbMu/SuNBhG1EnSJ9qyya97VYQQYsgdXeJonVgmo8TmaBqLobfN3md/aq99KE2Kvu2fbqCtckyLgl9Fi+mDof2rysNfK61sYfrYoUlqtAU2KKsXkL2Hf18BybXFIsXrQXEcGvkfIVQAincMg3gK1xKJXHSomxxlD5G6Y67mUH7eWYR+6vILqcVn+v5y3DGuIlPcG3gUKXQPX48gx2UQcdFDy8dI1nvVlpybdjdxzWjhFKaT0uxYf2R7k4hOQ4mEsMa1eu0bze/Y5zzDdKU0NL3WTmWUef+4ECv2jzk8c14QpcKoQ2g5A2v1iNw9Z0OQ0tsBJ/FFzUTgHb3CpDIA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1645.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(39860400002)(136003)(366004)(396003)(7696005)(83380400001)(55016002)(71200400001)(8676002)(8936002)(86362001)(478600001)(6506007)(9686003)(7416002)(186003)(26005)(33656002)(2906002)(54906003)(110136005)(66476007)(316002)(4326008)(76116006)(66946007)(52536014)(64756008)(66446008)(5660300002)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: MN9Ec4pZ0mNKgmyoedTd+EvBtiLNhLSjZrgBdTy+spGmxKuCZay4ncwLpYcjazLGZCb17Gvdnqh8xmjnm2UiWl3C8XzXTBazWZBbvnsP/hYDbL+OS6jrUl+yZL2Vn0QA9Qk98+l2vCXsrX671gswJK4SGMkosgFRAwCliNRZJYb2egGwSGfedK0Vc26WAL4KQxMzONhKroUkPOSzO6zbnQVsHIzs+YWBd1Jt1DqIugq9naedfBUsT92UhESHa9do2hkvfZfnR+ShDyEOgl5yiqyav5YSRIbuYscoZ8OJ5HT+CIbcoDUP/PtzSSpojW+Mkd95RqkldkYVUGU6I8esQWuQdsNkhc72vEIxoEfdZcNyqHcqoh1GcV0E0HCGTRQr/WGpWHt6ZNVQO0vw4axfL/3Y8Gx0C3/+l9CQm+4wx0JZaG2J124mKt4qoQjtyF3m/jOQrKicm/R9IlofZYFczcIrfBYqkdoKzIunBLkSmO8zA62ilH6XjWeNiIei60dsvG5IqWz+mOAgwwiGv6VFe72PZbE9VG31P2l9ApWgiG37fu1PMAImmsrjBNiffQ/E6me/rZm8LntnX9hHz8fagM6EXhszQTnDDwkPZefDQ7DxK1Eq3OA82i0OqgLJLwkKnOqqzbx7RbhVKwYFuJr9lg==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1645.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c738281-2b06-4952-544c-08d86fef8726
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2020 03:16:22.5679
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Me+X5cVm6eETQQW/Fger3Ew2U6Kh61t85SsXth2c4umIJXoMmeFq8aajFp1HmH+VbGUtqm+/gsCN8xHQbMHoxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4603
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGksIEFsZXggYW5kIEphc29uIChHKSwNCg0KSG93IGFib3V0IHlvdXIgb3BpbmlvbiBmb3IgdGhp
cyBuZXcgcHJvcG9zYWw/IEZvciBub3cgbG9va3MgYm90aA0KSmFzb24gKFcpIGFuZCBKZWFuIGFy
ZSBPSyB3aXRoIHRoaXMgZGlyZWN0aW9uIGFuZCBtb3JlIGRpc2N1c3Npb25zDQphcmUgcG9zc2li
bHkgcmVxdWlyZWQgZm9yIHRoZSBuZXcgL2Rldi9pb2FzaWQgaW50ZXJmYWNlLiBJbnRlcm5hbGx5
IA0Kd2UncmUgZG9pbmcgYSBxdWljayBwcm90b3R5cGUgdG8gc2VlIGFueSB1bmZvcmVzZWVuIGlz
c3VlIHdpdGggdGhpcw0Kc2VwYXJhdGlvbi4gDQoNClBsZWFzZSBsZXQgdXMga25vdyB5b3VyIHRo
b3VnaHRzLg0KDQpUaGFua3MNCktldmluDQoNCj4gRnJvbTogVGlhbiwgS2V2aW4gPGtldmluLnRp
YW5AaW50ZWwuY29tPg0KPiBTZW50OiBNb25kYXksIE9jdG9iZXIgMTIsIDIwMjAgNDozOSBQTQ0K
PiANCj4gPiBGcm9tOiBKYXNvbiBXYW5nIDxqYXNvd2FuZ0ByZWRoYXQuY29tPg0KPiA+IFNlbnQ6
IE1vbmRheSwgU2VwdGVtYmVyIDE0LCAyMDIwIDEyOjIwIFBNDQo+ID4NCj4gWy4uLl0NCj4gID4g
SWYgaXQncyBwb3NzaWJsZSwgSSB3b3VsZCBzdWdnZXN0IGEgZ2VuZXJpYyB1QVBJIGluc3RlYWQg
b2YgYSBWRklPDQo+ID4gc3BlY2lmaWMgb25lLg0KPiA+DQo+ID4gSmFzb24gc3VnZ2VzdCBzb21l
dGhpbmcgbGlrZSAvZGV2L3N2YS4gVGhlcmUgd2lsbCBiZSBhIGxvdCBvZiBvdGhlcg0KPiA+IHN1
YnN5c3RlbXMgdGhhdCBjb3VsZCBiZW5lZml0IGZyb20gdGhpcyAoZS5nIHZEUEEpLg0KPiA+DQo+
ID4gSGF2ZSB5b3UgZXZlciBjb25zaWRlcmVkIHRoaXMgYXBwcm9hY2g/DQo+ID4NCj4gDQo+IEhp
LCBKYXNvbiwNCj4gDQo+IFdlIGRpZCBzb21lIHN0dWR5IG9uIHRoaXMgYXBwcm9hY2ggYW5kIGJl
bG93IGlzIHRoZSBvdXRwdXQuIEl0J3MgYQ0KPiBsb25nIHdyaXRpbmcgYnV0IEkgZGlkbid0IGZp
bmQgYSB3YXkgdG8gZnVydGhlciBhYnN0cmFjdCB3L28gbG9zaW5nDQo+IG5lY2Vzc2FyeSBjb250
ZXh0LiBTb3JyeSBhYm91dCB0aGF0Lg0KPiANCj4gT3ZlcmFsbCB0aGUgcmVhbCBwdXJwb3NlIG9m
IHRoaXMgc2VyaWVzIGlzIHRvIGVuYWJsZSBJT01NVSBuZXN0ZWQNCj4gdHJhbnNsYXRpb24gY2Fw
YWJpbGl0eSB3aXRoIHZTVkEgYXMgb25lIG1ham9yIHVzYWdlLCB0aHJvdWdoDQo+IGJlbG93IG5l
dyB1QVBJczoNCj4gCTEpIFJlcG9ydC9lbmFibGUgSU9NTVUgbmVzdGVkIHRyYW5zbGF0aW9uIGNh
cGFiaWxpdHk7DQo+IAkyKSBBbGxvY2F0ZS9mcmVlIFBBU0lEOw0KPiAJMykgQmluZC91bmJpbmQg
Z3Vlc3QgcGFnZSB0YWJsZTsNCj4gCTQpIEludmFsaWRhdGUgSU9NTVUgY2FjaGU7DQo+IAk1KSBI
YW5kbGUgSU9NTVUgcGFnZSByZXF1ZXN0L3Jlc3BvbnNlIChub3QgaW4gdGhpcyBzZXJpZXMpOw0K
PiAxLzMvNCkgaXMgdGhlIG1pbmltYWwgc2V0IGZvciB1c2luZyBJT01NVSBuZXN0ZWQgdHJhbnNs
YXRpb24sIHdpdGgNCj4gdGhlIG90aGVyIHR3byBvcHRpb25hbC4gRm9yIGV4YW1wbGUsIHRoZSBn
dWVzdCBtYXkgZW5hYmxlIHZTVkEgb24NCj4gYSBkZXZpY2Ugd2l0aG91dCB1c2luZyBQQVNJRC4g
T3IsIGl0IG1heSBiaW5kIGl0cyBnSU9WQSBwYWdlIHRhYmxlDQo+IHdoaWNoIGRvZXNuJ3QgcmVx
dWlyZSBwYWdlIGZhdWx0IHN1cHBvcnQuIEZpbmFsbHksIGFsbCBvcGVyYXRpb25zIGNhbg0KPiBi
ZSBhcHBsaWVkIHRvIGVpdGhlciBwaHlzaWNhbCBkZXZpY2Ugb3Igc3ViZGV2aWNlLg0KPiANCj4g
VGhlbiB3ZSBldmFsdWF0ZWQgZWFjaCB1QVBJIHdoZXRoZXIgZ2VuZXJhbGl6aW5nIGl0IGlzIGEg
Z29vZCB0aGluZw0KPiBib3RoIGluIGNvbmNlcHQgYW5kIHJlZ2FyZGluZyB0byBjb21wbGV4aXR5
Lg0KPiANCj4gRmlyc3QsIHVubGlrZSBvdGhlciB1QVBJcyB3aGljaCBhcmUgYWxsIGJhY2tlZCBi
eSBpb21tdV9vcHMsIFBBU0lEDQo+IGFsbG9jYXRpb24vZnJlZSBpcyB0aHJvdWdoIHRoZSBJT0FT
SUQgc3ViLXN5c3RlbS4gRnJvbSB0aGlzIGFuZ2xlDQo+IHdlIGZlZWwgZ2VuZXJhbGl6aW5nIFBB
U0lEIG1hbmFnZW1lbnQgZG9lcyBtYWtlIHNvbWUgc2Vuc2UuDQo+IEZpcnN0LCBQQVNJRCBpcyBq
dXN0IGEgbnVtYmVyIGFuZCBub3QgcmVsYXRlZCB0byBhbnkgZGV2aWNlIGJlZm9yZQ0KPiBpdCdz
IGJvdW5kIHRvIGEgcGFnZSB0YWJsZSBhbmQgSU9NTVUgZG9tYWluLiBTZWNvbmQsIFBBU0lEIGlz
IGENCj4gZ2xvYmFsIHJlc291cmNlIChhdCBsZWFzdCBvbiBJbnRlbCBWVC1kKSwgd2hpbGUgaGF2
aW5nIHNlcGFyYXRlIFZGSU8vDQo+IFZEUEEgYWxsb2NhdGlvbiBpbnRlcmZhY2VzIG1heSBlYXNp
bHkgY2F1c2UgY29uZnVzaW9uIGluIHVzZXJzcGFjZSwNCj4gZS5nLiB3aGljaCBpbnRlcmZhY2Ug
dG8gYmUgdXNlZCBpZiBib3RoIFZGSU8vVkRQQSBkZXZpY2VzIGV4aXN0Lg0KPiBNb3Jlb3Zlciwg
YW4gdW5pZmllZCBpbnRlcmZhY2UgYWxsb3dzIGNlbnRyYWxpemVkIGNvbnRyb2wgb3ZlciBob3cN
Cj4gbWFueSBQQVNJRHMgYXJlIGFsbG93ZWQgcGVyIHByb2Nlc3MuDQo+IA0KPiBPbmUgdW5jbGVh
ciBwYXJ0IHdpdGggdGhpcyBnZW5lcmFsaXphdGlvbiBpcyBhYm91dCB0aGUgcGVybWlzc2lvbi4N
Cj4gRG8gd2Ugb3BlbiB0aGlzIGludGVyZmFjZSB0byBhbnkgcHJvY2VzcyBvciBvbmx5IHRvIHRo
b3NlIHdoaWNoDQo+IGhhdmUgYXNzaWduZWQgZGV2aWNlcz8gSWYgdGhlIGxhdHRlciwgd2hhdCB3
b3VsZCBiZSB0aGUgbWVjaGFuaXNtDQo+IHRvIGNvb3JkaW5hdGUgYmV0d2VlbiB0aGlzIG5ldyBp
bnRlcmZhY2UgYW5kIHNwZWNpZmljIHBhc3N0aHJvdWdoDQo+IGZyYW1ld29ya3M/IEEgbW9yZSB0
cmlja3kgY2FzZSwgdlNWQSBzdXBwb3J0IG9uIEFSTSAoRXJpYy9KZWFuDQo+IHBsZWFzZSBjb3Jy
ZWN0IG1lKSBwbGFucyB0byBkbyBwZXItZGV2aWNlIFBBU0lEIG5hbWVzcGFjZSB3aGljaA0KPiBp
cyBidWlsdCBvbiBhIGJpbmRfcGFzaWRfdGFibGUgaW9tbXUgY2FsbGJhY2sgdG8gYWxsb3cgZ3Vl
c3QgZnVsbHkNCj4gbWFuYWdlIGl0cyBQQVNJRHMgb24gYSBnaXZlbiBwYXNzdGhyb3VnaCBkZXZp
Y2UuIEknbSBub3Qgc3VyZQ0KPiBob3cgc3VjaCByZXF1aXJlbWVudCBjYW4gYmUgdW5pZmllZCB3
L28gaW52b2x2aW5nIHBhc3N0aHJvdWdoDQo+IGZyYW1ld29ya3MsIG9yIHdoZXRoZXIgQVJNIGNv
dWxkIGFsc28gc3dpdGNoIHRvIGdsb2JhbCBQQVNJRA0KPiBzdHlsZS4uLg0KPiANCj4gU2Vjb25k
LCBJT01NVSBuZXN0ZWQgdHJhbnNsYXRpb24gaXMgYSBwZXIgSU9NTVUgZG9tYWluDQo+IGNhcGFi
aWxpdHkuIFNpbmNlIElPTU1VIGRvbWFpbnMgYXJlIG1hbmFnZWQgYnkgVkZJTy9WRFBBDQo+ICAo
YWxsb2MvZnJlZSBkb21haW4sIGF0dGFjaC9kZXRhY2ggZGV2aWNlLCBzZXQvZ2V0IGRvbWFpbiBh
dHRyaWJ1dGUsDQo+IGV0Yy4pLCByZXBvcnRpbmcvZW5hYmxpbmcgdGhlIG5lc3RpbmcgY2FwYWJp
bGl0eSBpcyBhbiBuYXR1cmFsDQo+IGV4dGVuc2lvbiB0byB0aGUgZG9tYWluIHVBUEkgb2YgZXhp
c3RpbmcgcGFzc3Rocm91Z2ggZnJhbWV3b3Jrcy4NCj4gQWN0dWFsbHksIFZGSU8gYWxyZWFkeSBp
bmNsdWRlcyBhIG5lc3RpbmcgZW5hYmxlIGludGVyZmFjZSBldmVuDQo+IGJlZm9yZSB0aGlzIHNl
cmllcy4gU28gaXQgZG9lc24ndCBtYWtlIHNlbnNlIHRvIGdlbmVyYWxpemUgdGhpcyB1QVBJDQo+
IG91dC4NCj4gDQo+IFRoZW4gdGhlIHRyaWNreSBwYXJ0IGNvbWVzIHdpdGggdGhlIHJlbWFpbmlu
ZyBvcGVyYXRpb25zICgzLzQvNSksDQo+IHdoaWNoIGFyZSBhbGwgYmFja2VkIGJ5IGlvbW11X29w
cyB0aHVzIGVmZmVjdGl2ZSBvbmx5IHdpdGhpbiBhbg0KPiBJT01NVSBkb21haW4uIFRvIGdlbmVy
YWxpemUgdGhlbSwgdGhlIGZpcnN0IHRoaW5nIGlzIHRvIGZpbmQgYSB3YXkNCj4gdG8gYXNzb2Np
YXRlIHRoZSBzdmFfRkQgKG9wZW5lZCB0aHJvdWdoIGdlbmVyaWMgL2Rldi9zdmEpIHdpdGggYW4N
Cj4gSU9NTVUgZG9tYWluIHRoYXQgaXMgY3JlYXRlZCBieSBWRklPL1ZEUEEuIFRoZSBzZWNvbmQg
dGhpbmcgaXMNCj4gdG8gcmVwbGljYXRlIHtkb21haW48LT5kZXZpY2Uvc3ViZGV2aWNlfSBhc3Nv
Y2lhdGlvbiBpbiAvZGV2L3N2YQ0KPiBwYXRoIGJlY2F1c2Ugc29tZSBvcGVyYXRpb25zIChlLmcu
IHBhZ2UgZmF1bHQpIGlzIHRyaWdnZXJlZC9oYW5kbGVkDQo+IHBlciBkZXZpY2Uvc3ViZGV2aWNl
LiBUaGVyZWZvcmUsIC9kZXYvc3ZhIG11c3QgcHJvdmlkZSBib3RoIHBlci0NCj4gZG9tYWluIGFu
ZCBwZXItZGV2aWNlIHVBUElzIHNpbWlsYXIgdG8gd2hhdCBWRklPL1ZEUEEgYWxyZWFkeQ0KPiBk
b2VzLiBNb3Jlb3ZlciwgbWFwcGluZyBwYWdlIGZhdWx0IHRvIHN1YmRldmljZSByZXF1aXJlcyBw
cmUtDQo+IHJlZ2lzdGVyaW5nIHN1YmRldmljZSBmYXVsdCBkYXRhIHRvIElPTU1VIGxheWVyIHdo
ZW4gYmluZGluZw0KPiBndWVzdCBwYWdlIHRhYmxlLCB3aGlsZSBzdWNoIGZhdWx0IGRhdGEgY2Fu
IGJlIG9ubHkgcmV0cmlldmVkIGZyb20NCj4gcGFyZW50IGRyaXZlciB0aHJvdWdoIFZGSU8vVkRQ
QS4NCj4gDQo+IEhvd2V2ZXIsIHdlIGZhaWxlZCB0byBmaW5kIGEgZ29vZCB3YXkgZXZlbiBhdCB0
aGUgMXN0IHN0ZXAgYWJvdXQNCj4gZG9tYWluIGFzc29jaWF0aW9uLiBUaGUgaW9tbXUgZG9tYWlu
cyBhcmUgbm90IGV4cG9zZWQgdG8gdGhlDQo+IHVzZXJzcGFjZSwgYW5kIHRoZXJlIGlzIG5vIDE6
MSBtYXBwaW5nIGJldHdlZW4gZG9tYWluIGFuZCBkZXZpY2UuDQo+IEluIFZGSU8sIGFsbCBkZXZp
Y2VzIHdpdGhpbiB0aGUgc2FtZSBWRklPIGNvbnRhaW5lciBzaGFyZSB0aGUgYWRkcmVzcw0KPiBz
cGFjZSBidXQgdGhleSBtYXkgYmUgb3JnYW5pemVkIGluIG11bHRpcGxlIElPTU1VIGRvbWFpbnMg
YmFzZWQNCj4gb24gdGhlaXIgYnVzIHR5cGUuIEhvdyAoc2hvdWxkIHdlIGxldCkgdGhlIHVzZXJz
cGFjZSBrbm93IHRoZQ0KPiBkb21haW4gaW5mb3JtYXRpb24gYW5kIG9wZW4gYW4gc3ZhX0ZEIGZv
ciBlYWNoIGRvbWFpbiBpcyB0aGUgbWFpbg0KPiBwcm9ibGVtIGhlcmUuDQo+IA0KPiBJbiB0aGUg
ZW5kIHdlIGp1c3QgcmVhbGl6ZWQgdGhhdCBkb2luZyBzdWNoIGdlbmVyYWxpemF0aW9uIGRvZXNu
J3QNCj4gcmVhbGx5IGxlYWQgdG8gYSBjbGVhciBkZXNpZ24gYW5kIGluc3RlYWQgcmVxdWlyZXMg
dGlnaHQgY29vcmRpbmF0aW9uDQo+IGJldHdlZW4gL2Rldi9zdmEgYW5kIFZGSU8vVkRQQSBmb3Ig
YWxtb3N0IGV2ZXJ5IG5ldyB1QVBJDQo+IChlc3BlY2lhbGx5IGFib3V0IHN5bmNocm9uaXphdGlv
biB3aGVuIHRoZSBkb21haW4vZGV2aWNlDQo+IGFzc29jaWF0aW9uIGlzIGNoYW5nZWQgb3Igd2hl
biB0aGUgZGV2aWNlL3N1YmRldmljZSBpcyBiZWluZyByZXNldC8NCj4gZHJhaW5lZCkuIEZpbmFs
bHkgaXQgbWF5IGJlY29tZSBhIHVzYWJpbGl0eSBidXJkZW4gdG8gdGhlIHVzZXJzcGFjZQ0KPiBv
biBwcm9wZXIgdXNlIG9mIHRoZSB0d28gaW50ZXJmYWNlcyBvbiB0aGUgYXNzaWduZWQgZGV2aWNl
Lg0KPiANCj4gQmFzZWQgb24gYWJvdmUgYW5hbHlzaXMgd2UgZmVlbCB0aGF0IGp1c3QgZ2VuZXJh
bGl6aW5nIFBBU0lEIG1nbXQuDQo+IG1pZ2h0IGJlIGEgZ29vZCB0aGluZyB0byBsb29rIGF0IHdo
aWxlIHRoZSByZW1haW5pbmcgb3BlcmF0aW9ucyBhcmUNCj4gYmV0dGVyIGJlaW5nIFZGSU8vVkRQ
QSBzcGVjaWZpYyB1QVBJcy4gYW55d2F5IGluIGNvbmNlcHQgdGhvc2UgYXJlDQo+IGp1c3QgYSBz
dWJzZXQgb2YgdGhlIHBhZ2UgdGFibGUgbWFuYWdlbWVudCBjYXBhYmlsaXRpZXMgdGhhdCBhbg0K
PiBJT01NVSBkb21haW4gYWZmb3Jkcy4gU2luY2UgYWxsIG90aGVyIGFzcGVjdHMgb2YgdGhlIElP
TU1VIGRvbWFpbg0KPiBpcyBtYW5hZ2VkIGJ5IFZGSU8vVkRQQSBhbHJlYWR5LCBjb250aW51aW5n
IHRoaXMgcGF0aCBmb3IgbmV3IG5lc3RpbmcNCj4gY2FwYWJpbGl0eSBzb3VuZHMgbmF0dXJhbC4g
VGhlcmUgaXMgYW5vdGhlciBvcHRpb24gYnkgZ2VuZXJhbGl6aW5nIHRoZQ0KPiBlbnRpcmUgSU9N
TVUgZG9tYWluIG1hbmFnZW1lbnQgKHNvcnQgb2YgdGhlIGVudGlyZSB2ZmlvX2lvbW11Xw0KPiB0
eXBlMSksIGJ1dCBpdCdzIHVuY2xlYXIgd2hldGhlciBzdWNoIGludHJ1c2l2ZSBjaGFuZ2UgaXMg
d29ydGh3aGlsZQ0KPiAoZXNwZWNpYWxseSB3aGVuIFZGSU8vVkRQQSBhbHJlYWR5IGdvZXMgZGlm
ZmVyZW50IHJvdXRlIGV2ZW4gaW4gbGVnYWN5DQo+IG1hcHBpbmcgdUFQSTogbWFwL3VubWFwIHZz
LiBJT1RMQikuDQo+IA0KPiBUaG91Z2h0cz8NCj4gDQo+IFRoYW5rcw0KPiBLZXZpbg0K
