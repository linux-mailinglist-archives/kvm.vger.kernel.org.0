Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF26F268963
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 12:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726434AbgINKjJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 06:39:09 -0400
Received: from mga03.intel.com ([134.134.136.65]:61231 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726409AbgINKih (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 06:38:37 -0400
IronPort-SDR: 0n41HJfX5DQpbFVQq3+UKqLvygAvQbXENWTpPCoZyn3jH/M3Htd4ovWZsvdltmWR2BElB9/738
 4NKjp7DGReHQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9743"; a="159093770"
X-IronPort-AV: E=Sophos;i="5.76,425,1592895600"; 
   d="scan'208";a="159093770"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 03:38:13 -0700
IronPort-SDR: W8qCG7PglJRTCn2+yaHS1TstApRjiQpzCPPSi+DJuXet160gzW8rGzMZ9q1d2RjNIc43eSyydR
 WuktPaHUXYwQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,425,1592895600"; 
   d="scan'208";a="408821674"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by fmsmga001.fm.intel.com with ESMTP; 14 Sep 2020 03:38:12 -0700
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 14 Sep 2020 03:38:12 -0700
Received: from orsmsx151.amr.corp.intel.com (10.22.226.38) by
 orsmsx606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 14 Sep 2020 03:38:12 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX151.amr.corp.intel.com (10.22.226.38) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 14 Sep 2020 03:38:11 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Mon, 14 Sep 2020 03:38:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nho/Hk51tSm311nMvc4kQCsG+qp3eStuBMYHyNA+DkK5a5aBeYRlDnHtVHHsoBzT69a7R4ri3V/f+Me0GGPeNVyeXRRHurP1mBY+nkwDc49XSWeR9A0a5b31V3txsVczn55wHwPh7LmgtV/r+io0GGFi6iPJjlYccbawD7/mB224MHkbROAij/2ZXB3bbyXbXbBo1pMY1IwvaL586YAbsYV11wnN7QMOS1Izz0/N6kttlpF4456wAxRM9sbB9UEVJsW396l7vH6rDqIicCJrAo0N1GqqMVVAIV1VVbBO5KArIz+CJiP8W7VlZd/7R1xQVpTEJCASPQSVRjSiLjiljQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SP3VY7c4R3TuaPyuZN1pPwgVv77mluRbR7RBcbHyDNQ=;
 b=kVSkLujsUTsZhZxjKiO03kMlWY7wVVlZ4g1trJ8iz2NWfk2iqTvKepRVUrI62vJYE8nogqVeQuGPQutMNq1zkkrGgBtGJ8h6hQcVEn7QMBktWT79r+JWhnQJAt0D3LjfJ5ui6AH9Y8at3QEKDk6Gx4ogmditushGXISs/9Jh6ePvkvnV5go7IeNFIhHwwnFF9B+99mKSo813IOXrJMgAwuLpI8Ufd3VYmMwl7j1HVDq4bfUjnDEyPRydkkMdCkS3p7t5pQ5HP5FnY0rmLPU7b8O/j5gcw3YopM9bpxeGjTcbVPqIbZNEIRTDXO28eOfKNRRzN489YMd6ci3oRWictg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SP3VY7c4R3TuaPyuZN1pPwgVv77mluRbR7RBcbHyDNQ=;
 b=SJFsPJDl951lskiETSzBTZxRcBgWg5//eychAUbO6j8cVyVxkh7NAg7qoHf6jRkKCuN3XWq8RBJYP7DfF4cQHM6h0Ran5AQZWcx7T7L6Zw86uRJef5OYNc33dAFQtoMyzAQQh4NtONyh3QdG5+OEoRXNbSEsDfqIKaLJf2oYsL0=
Received: from MWHPR11MB1645.namprd11.prod.outlook.com (2603:10b6:301:b::12)
 by MWHPR11MB0061.namprd11.prod.outlook.com (2603:10b6:301:65::37) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.17; Mon, 14 Sep
 2020 10:38:10 +0000
Received: from MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::6dfe:feb8:25f1:ac9c]) by MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::6dfe:feb8:25f1:ac9c%7]) with mapi id 15.20.3370.019; Mon, 14 Sep 2020
 10:38:10 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Wang <jasowang@redhat.com>, "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>
CC:     "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "stefanha@gmail.com" <stefanha@gmail.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "Jason Gunthorpe" <jgg@nvidia.com>, "Wu, Hao" <hao.wu@intel.com>
Subject: RE: [PATCH v7 00/16] vfio: expose virtual Shared Virtual Addressing
 to VMs
Thread-Topic: [PATCH v7 00/16] vfio: expose virtual Shared Virtual Addressing
 to VMs
Thread-Index: AQHWh19AhgenwZ1qREOwvjqrd6cs+KlnjewAgAA1gYCAABf0AIAAANCQ
Date:   Mon, 14 Sep 2020 10:38:10 +0000
Message-ID: <MWHPR11MB1645C702D148A2852B41FCA08C230@MWHPR11MB1645.namprd11.prod.outlook.com>
References: <1599734733-6431-1-git-send-email-yi.l.liu@intel.com>
 <411c81c0-f13c-37cc-6c26-cafb42b46b15@redhat.com>
 <MWHPR11MB164517F15EF2C4831C191CF28C230@MWHPR11MB1645.namprd11.prod.outlook.com>
 <c3e07f47-3ce9-caf4-8a01-b68fdaae853d@redhat.com>
In-Reply-To: <c3e07f47-3ce9-caf4-8a01-b68fdaae853d@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.209]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 647391d4-081d-4dfb-163d-08d8589a466c
x-ms-traffictypediagnostic: MWHPR11MB0061:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB0061695F736EE2355F6D61FF8C230@MWHPR11MB0061.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sKMctvdhHinr+B13yduk+KbLXSMAqXCgGC9LZPBQC1xuJ8s6H7AXCgcgHJ1/q1YLlhBnsH0n/INB5gpC6TK1US6nU0eUChiJe9/pL59/4yS6yHooAy/pcp96V0YSjrfC4UeAbyEyIwnRibaAEsbnOq+JBAh9y6Gk5smc6//65iQiiUgUVjjEQvwqyV7o1LfWhea6rLQp+EfeYyLdelH1usjJ2ps9D9UEU6cwsmtvzS+8X6eMPIjK8Qg8Te1s9BD58qtZHD41da4jVEhGf2FR4ICog9x92TdHB399+vOGM/jMFV0VoqBwSsu9CEgUN3VC8m3irqsQ4TsuAHqSABbnkA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1645.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(136003)(366004)(376002)(33656002)(5660300002)(52536014)(7696005)(478600001)(71200400001)(86362001)(55016002)(316002)(7416002)(26005)(2906002)(6506007)(8676002)(66946007)(66446008)(64756008)(66556008)(66476007)(9686003)(54906003)(4326008)(83380400001)(76116006)(8936002)(110136005)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: zxj/Y/aKVREZUxE5P4USjqw9nFgn7lhBR6CwiwkQ0P4P3tAIOGMqSlIcJv3b7w4qdilDMP6VYRXtr6CGjZ+2fIU2nA66W1Svuwc3E9LYrrDLmrDMppU0KotnXL3aBlFpu0gcVgAKQL8yrxEL1rL9fHbm/pHS4WUZJkSXOTLUzRGpmjl+YnwKgeBrm9YJEJAkfD0ZQFfn2vuvi9n2b1WIsToZFQPNl77nOHUO5yWk+uLTKjwa/vAUc9HTHHEQF+p1MCNBEoxjnMp9azv9qVY9wndGEkFfG+Ryoa/EZ9z5jmKZkvSI5hQlErAmfo1hVTbwL8QERV/YRYPL6H+uaVZuUJcM+ku0cOF8NzYe1uizwy57XaCeNWTniNFhi4mOJeylu3zY2MENZIGAkJoyt0YYioo8zTpXYauskB7aZE1vHNNBoDjw5CSx76+FQV+yoWN/1YWVVM/hblpfwjBxi5/6W7u1sphkwCVliGpvtIqkq4hKsH5AvR0mKqWHhr/xsIa6PtAOQKaqtGl4FcU/j4hWJSzdSdXt/SgjqsOg9y9PIChUYcIjkmS93DdCYzZAdPB+6Pe8ImNyn0Qp1AfTU253VnXOytAjw4EFAi9adhF/9EHoafolnhYlQ9AtVOi3pXu6gOJGgAYyv6BssOxGMMZ7RA==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1645.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 647391d4-081d-4dfb-163d-08d8589a466c
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2020 10:38:10.1502
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hhzmVtdZeYX0LRJcCkdv9Wn/tihL8yH3m6uJG4SxG5v9KbFNqBrqXTzdVOABtV7WDVTFET/b0S2ifU/UewJXqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB0061
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBKYXNvbiBXYW5nDQo+IFNlbnQ6IE1vbmRheSwgU2VwdGVtYmVyIDE0LCAyMDIwIDQ6
NTcgUE0NCj4gDQo+IE9uIDIwMjAvOS8xNCDkuIvljYg0OjAxLCBUaWFuLCBLZXZpbiB3cm90ZToN
Cj4gPj4gRnJvbTogSmFzb24gV2FuZyA8amFzb3dhbmdAcmVkaGF0LmNvbT4NCj4gPj4gU2VudDog
TW9uZGF5LCBTZXB0ZW1iZXIgMTQsIDIwMjAgMTI6MjAgUE0NCj4gPj4NCj4gPj4gT24gMjAyMC85
LzEwIOS4i+WNiDY6NDUsIExpdSBZaSBMIHdyb3RlOg0KPiA+Pj4gU2hhcmVkIFZpcnR1YWwgQWRk
cmVzc2luZyAoU1ZBKSwgYS5rLmEsIFNoYXJlZCBWaXJ0dWFsIE1lbW9yeSAoU1ZNKSBvbg0KPiA+
Pj4gSW50ZWwgcGxhdGZvcm1zIGFsbG93cyBhZGRyZXNzIHNwYWNlIHNoYXJpbmcgYmV0d2VlbiBk
ZXZpY2UgRE1BIGFuZA0KPiA+Pj4gYXBwbGljYXRpb25zLiBTVkEgY2FuIHJlZHVjZSBwcm9ncmFt
bWluZyBjb21wbGV4aXR5IGFuZCBlbmhhbmNlDQo+ID4+IHNlY3VyaXR5Lg0KPiA+Pj4gVGhpcyBW
RklPIHNlcmllcyBpcyBpbnRlbmRlZCB0byBleHBvc2UgU1ZBIHVzYWdlIHRvIFZNcy4gaS5lLiBT
aGFyaW5nDQo+ID4+PiBndWVzdCBhcHBsaWNhdGlvbiBhZGRyZXNzIHNwYWNlIHdpdGggcGFzc3Ro
cnUgZGV2aWNlcy4gVGhpcyBpcyBjYWxsZWQNCj4gPj4+IHZTVkEgaW4gdGhpcyBzZXJpZXMuIFRo
ZSB3aG9sZSB2U1ZBIGVuYWJsaW5nIHJlcXVpcmVzDQo+IFFFTVUvVkZJTy9JT01NVQ0KPiA+Pj4g
Y2hhbmdlcy4gRm9yIElPTU1VIGFuZCBRRU1VIGNoYW5nZXMsIHRoZXkgYXJlIGluIHNlcGFyYXRl
IHNlcmllcw0KPiAobGlzdGVkDQo+ID4+PiBpbiB0aGUgIlJlbGF0ZWQgc2VyaWVzIikuDQo+ID4+
Pg0KPiA+Pj4gVGhlIGhpZ2gtbGV2ZWwgYXJjaGl0ZWN0dXJlIGZvciBTVkEgdmlydHVhbGl6YXRp
b24gaXMgYXMgYmVsb3csIHRoZSBrZXkNCj4gPj4+IGRlc2lnbiBvZiB2U1ZBIHN1cHBvcnQgaXMg
dG8gdXRpbGl6ZSB0aGUgZHVhbC1zdGFnZSBJT01NVSB0cmFuc2xhdGlvbiAoDQo+ID4+PiBhbHNv
IGtub3duIGFzIElPTU1VIG5lc3RpbmcgdHJhbnNsYXRpb24pIGNhcGFiaWxpdHkgaW4gaG9zdCBJ
T01NVS4NCj4gPj4+DQo+ID4+Pg0KPiA+Pj4gICAgICAgLi0tLS0tLS0tLS0tLS0uICAuLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLg0KPiA+Pj4gICAgICAgfCAgIHZJT01NVSAgICB8ICB8IEd1
ZXN0IHByb2Nlc3MgQ1IzLCBGTCBvbmx5fA0KPiA+Pj4gICAgICAgfCAgICAgICAgICAgICB8ICAn
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tJw0KPiA+Pj4gICAgICAgLi0tLS0tLS0tLS0tLS0t
LS0vDQo+ID4+PiAgICAgICB8IFBBU0lEIEVudHJ5IHwtLS0gUEFTSUQgY2FjaGUgZmx1c2ggLQ0K
PiA+Pj4gICAgICAgJy0tLS0tLS0tLS0tLS0nICAgICAgICAgICAgICAgICAgICAgICB8DQo+ID4+
PiAgICAgICB8ICAgICAgICAgICAgIHwgICAgICAgICAgICAgICAgICAgICAgIFYNCj4gPj4+ICAg
ICAgIHwgICAgICAgICAgICAgfCAgICAgICAgICAgICAgICBDUjMgaW4gR1BBDQo+ID4+PiAgICAg
ICAnLS0tLS0tLS0tLS0tLScNCj4gPj4+IEd1ZXN0DQo+ID4+PiAtLS0tLS18IFNoYWRvdyB8LS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS18LS0tLS0tLS0NCj4gPj4+ICAgICAgICAgdiAgICAgICAg
diAgICAgICAgICAgICAgICAgICAgICAgICAgdg0KPiA+Pj4gSG9zdA0KPiA+Pj4gICAgICAgLi0t
LS0tLS0tLS0tLS0uICAuLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS4NCj4gPj4+ICAgICAgIHwgICBw
SU9NTVUgICAgfCAgfCBCaW5kIEZMIGZvciBHVkEtR1BBICB8DQo+ID4+PiAgICAgICB8ICAgICAg
ICAgICAgIHwgICctLS0tLS0tLS0tLS0tLS0tLS0tLS0tJw0KPiA+Pj4gICAgICAgLi0tLS0tLS0t
LS0tLS0tLS0vICB8DQo+ID4+PiAgICAgICB8IFBBU0lEIEVudHJ5IHwgICAgIFYgKE5lc3RlZCB4
bGF0ZSkNCj4gPj4+ICAgICAgICctLS0tLS0tLS0tLS0tLS0tXC4tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0uDQo+ID4+PiAgICAgICB8ICAgICAgICAgICAgIHx8U0wgZm9yIEdQQS1IUEEs
IGRlZmF1bHQgZG9tYWlufA0KPiA+Pj4gICAgICAgfCAgICAgICAgICAgICB8ICAgJy0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLScNCj4gPj4+ICAgICAgICctLS0tLS0tLS0tLS0tJw0KPiA+
Pj4gV2hlcmU6DQo+ID4+PiAgICAtIEZMID0gRmlyc3QgbGV2ZWwvc3RhZ2Ugb25lIHBhZ2UgdGFi
bGVzDQo+ID4+PiAgICAtIFNMID0gU2Vjb25kIGxldmVsL3N0YWdlIHR3byBwYWdlIHRhYmxlcw0K
PiA+Pj4NCj4gPj4+IFBhdGNoIE92ZXJ2aWV3Og0KPiA+Pj4gICAgMS4gcmVwb3J0cyBJT01NVSBu
ZXN0aW5nIGluZm8gdG8gdXNlcnNwYWNlICggcGF0Y2ggMDAwMSwgMDAwMiwgMDAwMywNCj4gPj4g
MDAxNSAsIDAwMTYpDQo+ID4+PiAgICAyLiB2ZmlvIHN1cHBvcnQgZm9yIFBBU0lEIGFsbG9jYXRp
b24gYW5kIGZyZWUgZm9yIFZNcyAocGF0Y2ggMDAwNCwgMDAwNSwNCj4gPj4gMDAwNykNCj4gPj4+
ICAgIDMuIGEgZml4IHRvIGEgcmV2aXNpdCBpbiBpbnRlbCBpb21tdSBkcml2ZXIgKHBhdGNoIDAw
MDYpDQo+ID4+PiAgICA0LiB2ZmlvIHN1cHBvcnQgZm9yIGJpbmRpbmcgZ3Vlc3QgcGFnZSB0YWJs
ZSB0byBob3N0IChwYXRjaCAwMDA4LCAwMDA5LA0KPiA+PiAwMDEwKQ0KPiA+Pj4gICAgNS4gdmZp
byBzdXBwb3J0IGZvciBJT01NVSBjYWNoZSBpbnZhbGlkYXRpb24gZnJvbSBWTXMgKHBhdGNoIDAw
MTEpDQo+ID4+PiAgICA2LiB2ZmlvIHN1cHBvcnQgZm9yIHZTVkEgdXNhZ2Ugb24gSU9NTVUtYmFj
a2VkIG1kZXZzIChwYXRjaCAwMDEyKQ0KPiA+Pj4gICAgNy4gZXhwb3NlIFBBU0lEIGNhcGFiaWxp
dHkgdG8gVk0gKHBhdGNoIDAwMTMpDQo+ID4+PiAgICA4LiBhZGQgZG9jIGZvciBWRklPIGR1YWwg
c3RhZ2UgY29udHJvbCAocGF0Y2ggMDAxNCkNCj4gPj4NCj4gPj4gSWYgaXQncyBwb3NzaWJsZSwg
SSB3b3VsZCBzdWdnZXN0IGEgZ2VuZXJpYyB1QVBJIGluc3RlYWQgb2YgYSBWRklPDQo+ID4+IHNw
ZWNpZmljIG9uZS4NCj4gPj4NCj4gPj4gSmFzb24gc3VnZ2VzdCBzb21ldGhpbmcgbGlrZSAvZGV2
L3N2YS4gVGhlcmUgd2lsbCBiZSBhIGxvdCBvZiBvdGhlcg0KPiA+PiBzdWJzeXN0ZW1zIHRoYXQg
Y291bGQgYmVuZWZpdCBmcm9tIHRoaXMgKGUuZyB2RFBBKS4NCj4gPj4NCj4gPiBKdXN0IGJlIGN1
cmlvdXMuIFdoZW4gZG9lcyB2RFBBIHN1YnN5c3RlbSBwbGFuIHRvIHN1cHBvcnQgdlNWQSBhbmQN
Cj4gPiB3aGVuIGNvdWxkIG9uZSBleHBlY3QgYSBTVkEtY2FwYWJsZSB2RFBBIGRldmljZSBpbiBt
YXJrZXQ/DQo+ID4NCj4gPiBUaGFua3MNCj4gPiBLZXZpbg0KPiANCj4gDQo+IHZTVkEgaXMgaW4g
dGhlIHBsYW4gYnV0IHRoZXJlJ3Mgbm8gRVRBLiBJIHRoaW5rIHdlIG1pZ2h0IHN0YXJ0IHRoZSB3
b3JrDQo+IGFmdGVyIGNvbnRyb2wgdnEgc3VwcG9ydC7CoCBJdCB3aWxsIHByb2JhYmx5IHN0YXJ0
IGZyb20gU1ZBIGZpcnN0IGFuZA0KPiB0aGVuIHZTVkEgKHNpbmNlIGl0IG1pZ2h0IHJlcXVpcmUg
cGxhdGZvcm0gc3VwcG9ydCkuDQo+IA0KPiBGb3IgdGhlIGRldmljZSBwYXJ0LCBpdCByZWFsbHkg
ZGVwZW5kcyBvbiB0aGUgY2hpcHNldCBhbmQgb3RoZXIgZGV2aWNlDQo+IHZlbmRvcnMuIFdlIHBs
YW4gdG8gZG8gdGhlIHByb3RvdHlwZSBpbiB2aXJ0aW8gYnkgaW50cm9kdWNpbmcgUEFTSUQNCj4g
c3VwcG9ydCBpbiB0aGUgc3BlYy4NCj4gDQoNClRoYW5rcyBmb3IgdGhlIGluZm8uIFRoZW4gaGVy
ZSBpcyBteSB0aG91Z2h0Lg0KDQpGaXJzdCwgSSBkb24ndCB0aGluayAvZGV2L3N2YSBpcyB0aGUg
cmlnaHQgaW50ZXJmYWNlLiBPbmNlIHdlIHN0YXJ0IA0KY29uc2lkZXJpbmcgc3VjaCBnZW5lcmlj
IHVBUEksIGl0IGJldHRlciBiZWhhdmVzIGFzIHRoZSBvbmUgaW50ZXJmYWNlDQpmb3IgYWxsIGtp
bmRzIG9mIERNQSByZXF1aXJlbWVudHMgb24gZGV2aWNlL3N1YmRldmljZSBwYXNzdGhyb3VnaC4N
Ck5lc3RlZCBwYWdlIHRhYmxlIHRocnUgdlNWQSBpcyBvbmUgd2F5LiBNYW51YWwgbWFwL3VubWFw
IGlzDQphbm90aGVyIHdheS4gSXQgZG9lc24ndCBtYWtlIHNlbnNlIHRvIGhhdmUgb25lIHRocm91
Z2ggZ2VuZXJpYw0KdUFQSSBhbmQgdGhlIG90aGVyIHRocm91Z2ggc3Vic3lzdGVtIHNwZWNpZmlj
IHVBUEkuIEluIHRoZSBlbmQNCnRoZSBpbnRlcmZhY2UgbWlnaHQgYmVjb21lIC9kZXYvaW9tbXUs
IGZvciBkZWxlZ2F0aW5nIGNlcnRhaW4NCklPTU1VIG9wZXJhdGlvbnMgdG8gdXNlcnNwYWNlLiAN
Cg0KSW4gYWRkaXRpb24sIGRlbGVnYXRlZCBJT01NVSBvcGVyYXRpb25zIGhhdmUgZGlmZmVyZW50
IHNjb3Blcy4NClBBU0lEIGFsbG9jYXRpb24gaXMgcGVyIHByb2Nlc3MvVk0uIHBndGJsLWJpbmQv
dW5iaW5kLCBtYXAvdW5tYXAgDQphbmQgY2FjaGUgaW52YWxpZGF0aW9uIGFyZSBwZXIgaW9tbXUg
ZG9tYWluLiBwYWdlIHJlcXVlc3QvDQpyZXNwb25zZSBhcmUgcGVyIGRldmljZS9zdWJkZXZpY2Uu
IFRoaXMgcmVxdWlyZXMgdGhlIHVBUEkgdG8gYWxzbw0KdW5kZXJzdGFuZCBhbmQgbWFuYWdlIHRo
ZSBhc3NvY2lhdGlvbiBiZXR3ZWVuIGRvbWFpbi9ncm91cC8NCmRldmljZS9zdWJkZXZpY2UgKHN1
Y2ggYXMgZ3JvdXAgYXR0YWNoL2RldGFjaCksIGluc3RlYWQgb2YgZG9pbmcgDQppdCBzZXBhcmF0
ZWx5IGluIFZGSU8gb3IgdkRQQSBhcyB0b2RheS4gDQoNCkJhc2VkIG9uIGFib3ZlLCBJIGZlZWwg
YSBtb3JlIHJlYXNvbmFibGUgd2F5IGlzIHRvIGZpcnN0IG1ha2UgYSANCi9kZXYvaW9tbXUgdUFQ
SSBzdXBwb3J0aW5nIERNQSBtYXAvdW5tYXAgdXNhZ2VzIGFuZCB0aGVuIA0KaW50cm9kdWNlIHZT
VkEgdG8gaXQuIERvaW5nIHRoaXMgb3JkZXIgaXMgYmVjYXVzZSBETUEgbWFwL3VubWFwIA0KaXMg
d2lkZWx5IHVzZWQgdGh1cyBjYW4gYmV0dGVyIGhlbHAgdmVyaWZ5IHRoZSBjb3JlIGxvZ2ljIHdp
dGggDQptYW55IGV4aXN0aW5nIGRldmljZXMuIEZvciB2U1ZBLCB2RFBBIHN1cHBvcnQgaGFzIG5v
dCBiZSBzdGFydGVkDQp3aGlsZSBWRklPIHN1cHBvcnQgaXMgY2xvc2UgdG8gYmUgYWNjZXB0ZWQu
IEl0IGRvZXNuJ3QgbWFrZSBtdWNoIA0Kc2Vuc2UgYnkgYmxvY2tpbmcgdGhlIFZGSU8gcGFydCB1
bnRpbCB2RFBBIGlzIHJlYWR5IGZvciB3aWRlIA0KdmVyaWZpY2F0aW9uIGFuZCAvZGV2L2lvbW11
IGlzIG1hdHVyZSBlbm91Z2guIFllcywgdGhlIG5ld2x5LQ0KYWRkZWQgdUFQSXMgd2lsbCBiZSBm
aW5hbGx5IGRlcHJlY2F0ZWQgd2hlbiAvZGV2L2lvbW11IHN0YXJ0cyANCnRvIHN1cHBvcnQgdlNW
QS4gQnV0IHVzaW5nIC9kZXYvaW9tbXUgd2lsbCBhbnl3YXkgZGVwcmVjYXRlIA0Kc29tZSBleGlz
dGluZyBWRklPIElPTU1VIHVBUElzIGF0IHRoYXQgdGltZS4uLg0KDQpUaGFua3MNCktldmluDQo=
