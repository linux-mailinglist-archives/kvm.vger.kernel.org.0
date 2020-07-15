Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAB152201C5
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 03:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728056AbgGOBXb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jul 2020 21:23:31 -0400
Received: from mga11.intel.com ([192.55.52.93]:42503 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728048AbgGOBXa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jul 2020 21:23:30 -0400
IronPort-SDR: y3NqrjdRB4j11bDYzUeUFIEK8gFNc1tIQBc9yWnEiLLQbgoWZrT3gUADjUAw6KXkboPygLdT3u
 4ETitvZOJhlg==
X-IronPort-AV: E=McAfee;i="6000,8403,9682"; a="147069274"
X-IronPort-AV: E=Sophos;i="5.75,353,1589266800"; 
   d="scan'208";a="147069274"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2020 18:23:30 -0700
IronPort-SDR: iFUhZb4c999lAp81Ts1oFd03zXzh39TO404nynZjfs5BueweB/d609tE2flxyFGE4DQf+xqfW8
 YEnKJmH0nLtQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,353,1589266800"; 
   d="scan'208";a="390645501"
Received: from orsmsx104.amr.corp.intel.com ([10.22.225.131])
  by fmsmga001.fm.intel.com with ESMTP; 14 Jul 2020 18:23:29 -0700
Received: from orsmsx152.amr.corp.intel.com (10.22.226.39) by
 ORSMSX104.amr.corp.intel.com (10.22.225.131) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 14 Jul 2020 18:23:29 -0700
Received: from ORSEDG001.ED.cps.intel.com (10.7.248.4) by
 ORSMSX152.amr.corp.intel.com (10.22.226.39) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 14 Jul 2020 18:23:29 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 14 Jul 2020 18:23:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WlV9b4fd4UEk8I5HNZ/QpYdZc55nWXKko1GjaXxNlndDBzmJm666xmadyZbx6EWlRkvdWS2z2kEh0E42qm9+pvO1c+29rEWX90gXQs/iou3k5XalLvmTvTfYFz/KpBRYo7KOS1MEac+qhglsN5SzFATFc9xyf4h+9fy9GvtoTHOFcQ2twzpA7MPM1LROaO5f8TQTXhvUlwfhor+xFktrJqPXcShXetrAxb4pGilouKovg1zQIUjoF9aarw5mUQk8qdKhUOUtEK0PgRKKPquE37SL2QakUr+WqJWbTH9TCcRVlyxxHsx280Mq4NDqt/P0gT3imXWMRquhr5lb+E6Lpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CgeON+F+HITzyTjk8SwWvCe3hfV2261krmoOXN/zPeg=;
 b=PERL1rJ8+js1Xh4lmjALE0zfyyGjzH2jWGVDcSgJ/+c8Pfpys5QhJFCndtLjeE7KSmarpvoSqXXgWTLcFkNw8ownhytNGvhUP635ffF073Q8XG1YTkZJBN0N+2tqS9jTR61xxiI6MjfZxFYNeIgIBx/d+BmObFNI9nZajKsE7fWDIaFzKkKrL+SYoaX+YMAcgRN08kMI4sRX8SJpp9QX7YyaGRgmCBgWPsvuaEF3H02I5y1v4USMEo6aFDVkviq+JsqNQtaJWbKOhVtJGj7EtVUTccR3tq0HyqGpQPD/qqWlLu9cBlHlqfJ8KsjqVRxKc4ECFc2XVj4UBq4O7h2+TQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CgeON+F+HITzyTjk8SwWvCe3hfV2261krmoOXN/zPeg=;
 b=LOW5XRoxgP/uNuBe4NVsAmIn3SkUhZFKyrALtez+umXAzDd8DBQEBt6U8/JGFMhJoFIDiMJW+wZDtSHVuAPTjpP8IF3x4pGltC94przRnWxGN93/xG0iI98vlj9FWkCacdbghPUAK+H3ZjCCQypC8ZFCjZoOWx1pa/mYUWJ0GtI=
Received: from MWHPR11MB1645.namprd11.prod.outlook.com (2603:10b6:301:b::12)
 by MWHPR11MB1568.namprd11.prod.outlook.com (2603:10b6:301:f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.23; Wed, 15 Jul
 2020 01:23:26 +0000
Received: from MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::9864:e0cb:af36:6feb]) by MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::9864:e0cb:af36:6feb%5]) with mapi id 15.20.3195.018; Wed, 15 Jul 2020
 01:23:26 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Christoph Hellwig <hch@infradead.org>
CC:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: RE: [PATCH v3 4/4] vfio/type1: Use iommu_aux_at(de)tach_group() APIs
Thread-Topic: [PATCH v3 4/4] vfio/type1: Use iommu_aux_at(de)tach_group() APIs
Thread-Index: AQHWWaRWAT4ieRfuc06ojNA63fOJkqkGvU8AgACHTgCAAI6hAIAABegA
Date:   Wed, 15 Jul 2020 01:23:26 +0000
Message-ID: <MWHPR11MB1645BB5C265C520EEA005B078C7E0@MWHPR11MB1645.namprd11.prod.outlook.com>
References: <20200714055703.5510-1-baolu.lu@linux.intel.com>
 <20200714055703.5510-5-baolu.lu@linux.intel.com>
 <20200714082514.GA30622@infradead.org>
 <20200714092930.4b61b77c@jacob-builder>
 <ac4507d5-a5fc-d078-9bfc-f9e9fd1244e7@linux.intel.com>
In-Reply-To: <ac4507d5-a5fc-d078-9bfc-f9e9fd1244e7@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.193]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f016d9d3-12dc-4263-33f4-08d8285dac90
x-ms-traffictypediagnostic: MWHPR11MB1568:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB15682969129D9E93C37855138C7E0@MWHPR11MB1568.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: o/X7g5h4Wmq88MkL2WR513T5j5T/KOytcMtjSJU3gQymSGCfjooYE31THmCTimYbzO93jJUtggRCpEwdmMo2gQf1b6UKKEefqzFhKL3k1TAlTEBR+9a4KQ4fZt6M9oitps8rqhYkpHbIdXdedffMQHm4gDtRrRzev7CsdtNcp4ZNb3nwXaNyywQQPSv6UdiKCfetunHWD7yYj9IPVp8dE1N7DXYYou1COGj3DJ5a7iqx3YRRyBmlFgkN1B9fT2mor6N/j4yPDKGuZ/W6NgLwi0UZgbB5R7ZQ0hzBWmG8SwDMqOxGbX12UEwulEADBTl3Td3sxywJAJ5WptvW0R/jsD14+K1+vDt5s00fBpuz2DbKaTCRBTE7R8fCUM5e+WKfY87fO4v5p55tvWfoLAPg/w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1645.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(366004)(346002)(396003)(376002)(33656002)(86362001)(76116006)(66946007)(71200400001)(966005)(54906003)(7416002)(7696005)(52536014)(478600001)(316002)(66446008)(64756008)(66476007)(110136005)(66556008)(5660300002)(26005)(8676002)(8936002)(6506007)(4326008)(53546011)(9686003)(186003)(2906002)(55016002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 7DNuMYcq1clwzXW0J1c6EMH8bVEKL4Ndr9yEVEqVUbfVYkRavcl7aYgeDgcG0VO6b+iGW3QiYiAWq1BWE+Wc+Nb5zUh4yANI1JCeNHHySNOh3CLXI07M1WJFnl3DeZt3Ge2VGnt8IvMLIKyl86NEZsceqrbxHaXHwpGeQz5W4Re4kDk89eQQ7BPRumbakr0DSYYQfK6aBTv16X3Jaf6KvHnMLOjnjgsQVnvBRNsECUQkYeZ7yQYBgzKiF52Az9CLYLQC2ZC5dDG8BkFkrIKAAo4FEsieKrfRBHn5Il5zXVtptrOQKNSCprJIPvg5eg9tluxAwn5QlhGHLeLFylJDYiKpuByjMroXqTh1cNcX4NnabEIXe9F8JlC+wYJazqILKmspkt9SzEpp87t6x9d2k7V9kV8Z8CsBV64OVxlAEzcbOoiAyuV4vx4srl3k705rkp3d4OC6PqG7kf4SgZUuzMYpYBFukKsDl6ruzYsBd/N1Fq4i1V/XwjOxfO2l+uiM
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1645.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f016d9d3-12dc-4263-33f4-08d8285dac90
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2020 01:23:26.4706
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M79tBxCNnOLifIYv818t19gTPFzRSpOs9isrdQGSgT6wTAiZmYYM6BsuIILG5wmm8qL915/8OvYx2FoRy071sQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1568
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBMdSBCYW9sdSA8YmFvbHUubHVAbGludXguaW50ZWwuY29tPg0KPiBTZW50OiBXZWRu
ZXNkYXksIEp1bHkgMTUsIDIwMjAgOTowMCBBTQ0KPiANCj4gSGkgQ2hyaXN0b3BoIGFuZCBKYWNv
YiwNCj4gDQo+IE9uIDcvMTUvMjAgMTI6MjkgQU0sIEphY29iIFBhbiB3cm90ZToNCj4gPiBPbiBU
dWUsIDE0IEp1bCAyMDIwIDA5OjI1OjE0ICswMTAwDQo+ID4gQ2hyaXN0b3BoIEhlbGx3aWc8aGNo
QGluZnJhZGVhZC5vcmc+ICB3cm90ZToNCj4gPg0KPiA+PiBPbiBUdWUsIEp1bCAxNCwgMjAyMCBh
dCAwMTo1NzowM1BNICswODAwLCBMdSBCYW9sdSB3cm90ZToNCj4gPj4+IFJlcGxhY2UgaW9tbXVf
YXV4X2F0KGRlKXRhY2hfZGV2aWNlKCkgd2l0aA0KPiA+Pj4gaW9tbXVfYXV4X2F0KGRlKXRhY2hf
Z3JvdXAoKS4gSXQgYWxzbyBzYXZlcyB0aGUNCj4gPj4+IElPTU1VX0RFVl9GRUFUX0FVWC1jYXBh
YmxlIHBoeXNjYWlsIGRldmljZSBpbiB0aGUgdmZpb19ncm91cCBkYXRhDQo+ID4+PiBzdHJ1Y3R1
cmUgc28gdGhhdCBpdCBjb3VsZCBiZSByZXVzZWQgaW4gb3RoZXIgcGxhY2VzLg0KPiA+PiBUaGlz
IHJlbW92ZXMgdGhlIGxhc3QgdXNlciBvZiBpb21tdV9hdXhfYXR0YWNoX2RldmljZSBhbmQNCj4g
Pj4gaW9tbXVfYXV4X2RldGFjaF9kZXZpY2UsIHdoaWNoIGNhbiBiZSByZW1vdmVkIG5vdy4NCj4g
PiBpdCBpcyBzdGlsbCB1c2VkIGluIHBhdGNoIDIvNCBpbnNpZGUgaW9tbXVfYXV4X2F0dGFjaF9n
cm91cCgpLCByaWdodD8NCj4gPg0KPiANCj4gVGhlcmUgaXMgYSBuZWVkIHRvIHVzZSB0aGlzIGlu
dGVyZmFjZS4gRm9yIGV4YW1wbGUsIGFuIGF1eC1kb21haW4gaXMNCj4gYXR0YWNoZWQgdG8gYSBz
dWJzZXQgb2YgYSBwaHlzaWNhbCBkZXZpY2UgYW5kIHVzZWQgaW4gdGhlIGtlcm5lbC4gSW4NCj4g
dGhpcyB1c2FnZSBzY2VuYXJpbywgdGhlcmUncyBubyBuZWVkIHRvIHVzZSB2ZmlvL21kZXYuIFRo
ZSBkZXZpY2UgZHJpdmVyDQo+IGNvdWxkIGp1c3QgYWxsb2NhdGUgYW4gYXV4LWRvbWFpbiBhbmQg
Y2FsbCBpb21tdV9hdXhfYXR0YWNoX2RldmljZSgpIHRvDQo+IHNldHVwIHRoZSBpb21tdS4NCj4g
DQoNCmFuZCBoZXJlIGlzIG9uZSBleGFtcGxlIHVzYWdlIGZvciBhZGRpbmcgcGVyLWluc3RhbmNl
IHBhZ2V0YWJsZXMgZm9yIGRybS9tc206DQpodHRwczovL2xvcmUua2VybmVsLm9yZy9sa21sLzIw
MjAwNjI2MjAwNDE0LjE0MzgyLTUtamNyb3VzZUBjb2RlYXVyb3JhLm9yZy8NCg0KVGhhbmtzDQpL
ZXZpbg0K
