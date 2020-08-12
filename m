Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5069242479
	for <lists+kvm@lfdr.de>; Wed, 12 Aug 2020 06:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbgHLEF1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Aug 2020 00:05:27 -0400
Received: from mga04.intel.com ([192.55.52.120]:55481 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725766AbgHLEF1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Aug 2020 00:05:27 -0400
IronPort-SDR: zkvKbhCamUHgxE0WInE9WXFUmKqt+UV6hGGVY1SbJ+oB7a/f0knPjgeVkjAKeFpX9rARjgc0Ey
 F2UFM2lJPJXw==
X-IronPort-AV: E=McAfee;i="6000,8403,9710"; a="151309229"
X-IronPort-AV: E=Sophos;i="5.76,302,1592895600"; 
   d="scan'208";a="151309229"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2020 21:05:26 -0700
IronPort-SDR: VAd92/oty1Qtmz15zsYyLODnF4l/i8kpSsflDbxVXazdn8MBUbAi3veFPSNhElxJSy6B4+BbRI
 rLRXpCOk7lfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,302,1592895600"; 
   d="scan'208";a="398725679"
Received: from orsmsx605-2.jf.intel.com (HELO ORSMSX605.amr.corp.intel.com) ([10.22.229.85])
  by fmsmga001.fm.intel.com with ESMTP; 11 Aug 2020 21:05:26 -0700
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 11 Aug 2020 21:05:25 -0700
Received: from orsmsx116.amr.corp.intel.com (10.22.240.14) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 11 Aug 2020 21:05:25 -0700
Received: from ORSEDG001.ED.cps.intel.com (10.7.248.4) by
 ORSMSX116.amr.corp.intel.com (10.22.240.14) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 11 Aug 2020 21:05:25 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.106)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 11 Aug 2020 21:05:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZXXf59t73ZPbXDWnwzv90HsgoQG7jQMe8emUrXwc+uN1A2WCGP7RmjXBEsWDJ2aI3ntn6ho5ZjyzlRxuWVjRwVRGuyVqoAMO/UOcNLICQdNSISsan5gpI498/SgTTLHHPPVvoW3nSqVcSKenVy+b4F8w9tvqfWZ9zN9mK3ZoJBBG+JXqAQFegBAdGNXLuStfXtu8jEABegPBHvZkIfgfebiK1lMzn5Zr8DuC3S0t+I4Q9QmyBhgmbEflsUcn6aB9M3moiBuUg/klsLIv2Rbw97Jerg42KbampYe5gJGitinlQ5a/SAo7JJZ7XLbCF/kOgxUFuRf/yVXqvnkp3nYnVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gmbj+F40iIni2C7+NITSzk/kDefvg4ivQRDGpbj3GBg=;
 b=GxRdPcBblVPtVSYI5HPyx7a2EO/6F/nCiGxPK3h731FzZJcp7Kc7WoeF65oBNJby0jE71SqCuqtoQAt4dGAtZiQLnm+rHiin4T4EBZs0NTqCXt+hfSqmwi7KW4dRlWCRnn0xfOVrFX3VxjmupUZ3dibvg5DHZiD34Xd9tUmh/U/0wX7J+NbXWYN9j5EM+aFfD6AxQKsl1PqObxG2l/qHTZGCDVSsFMhWwL7Sm4q21SuWAT/2wmwBExuSx89xI42WwlZKV7PiXZWZGAzKptOlrU5P6dHzyGO5+00UgtCW49tW1x1nOvN9A66laGe8YoTnOyMkmprUKjXlXv4pgxV3IA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gmbj+F40iIni2C7+NITSzk/kDefvg4ivQRDGpbj3GBg=;
 b=aIIH6unQBZRPyTIyJIxpsyMXSxa/pcASAk9/EKC7s6PXbe8xxZiY5P9hCZDHgQO18k/bkmpe/piDN9YoZBMNuoTzNoUYAlsbJK43cRWDXb97cJNHq2SsEqxd4eAXbK1cGEzKSSRFp4bT5LoTaxEpc4wCAOCP1OGjAGKoHpLIdzc=
Received: from MWHPR11MB1645.namprd11.prod.outlook.com (2603:10b6:301:b::12)
 by MWHPR1101MB2093.namprd11.prod.outlook.com (2603:10b6:301:50::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.15; Wed, 12 Aug
 2020 04:05:23 +0000
Received: from MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::6dfe:feb8:25f1:ac9c]) by MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::6dfe:feb8:25f1:ac9c%7]) with mapi id 15.20.3261.025; Wed, 12 Aug 2020
 04:05:23 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Wang <jasowang@redhat.com>, Jason Gunthorpe <jgg@nvidia.com>,
        "Alex Williamson" <alex.williamson@redhat.com>
CC:     "Jiang, Dave" <dave.jiang@intel.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "Dey, Megha" <megha.dey@intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Lin, Jing" <jing.lin@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "netanelg@mellanox.com" <netanelg@mellanox.com>,
        "shahafs@mellanox.com" <shahafs@mellanox.com>,
        "yan.y.zhao@linux.intel.com" <yan.y.zhao@linux.intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Ortiz, Samuel" <samuel.ortiz@intel.com>,
        "Hossain, Mona" <mona.hossain@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH RFC v2 00/18] Add VFIO mediated device support and DEV-MSI
 support for the idxd driver
Thread-Topic: [PATCH RFC v2 00/18] Add VFIO mediated device support and
 DEV-MSI support for the idxd driver
Thread-Index: AQHWX3hut2htBlMVB0qfW0Pa+gZbC6kSPbuAgABwW8CAAzMrAIAUgAoAgAJJ4oCABDO9YIADE1sAgAACHkA=
Date:   Wed, 12 Aug 2020 04:05:23 +0000
Message-ID: <MWHPR11MB1645DDC2C87D533B2A09A2D58C420@MWHPR11MB1645.namprd11.prod.outlook.com>
References: <159534667974.28840.2045034360240786644.stgit@djiang5-desk3.ch.intel.com>
 <20200721164527.GD2021248@mellanox.com>
 <CY4PR11MB1638103EC73DD9C025F144C98C780@CY4PR11MB1638.namprd11.prod.outlook.com>
 <20200724001930.GS2021248@mellanox.com> <20200805192258.5ee7a05b@x1.home>
 <20200807121955.GS16789@nvidia.com>
 <MWHPR11MB16452EBE866E330A7E000AFC8C440@MWHPR11MB1645.namprd11.prod.outlook.com>
 <b59ce5b0-5530-1f30-9852-409f7c9f630a@redhat.com>
In-Reply-To: <b59ce5b0-5530-1f30-9852-409f7c9f630a@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.202]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 21b3d769-0bdb-4473-6ad3-08d83e74efbb
x-ms-traffictypediagnostic: MWHPR1101MB2093:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR1101MB2093292F4E298988A20887748C420@MWHPR1101MB2093.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lE8gbhx135SStEb08DpFsAxZfjEAchpc2U0+8R14214CdavxC1acYoEqveXD184PKcSdLPmc8IgYdIFDMT++BTTmrdM//bkuVZp1peEgRtqr3VPozdgQo/kaZFqijnjAYYI9Nhv99flqTh3+ZaQdSJ0/ml8NVbds2Hi/zBhT/vJl08d4g2ga/tlxdCnifxyKySfWS97uq1N4XGwd7uRpYw32QUiIJo+i4oNDagFLYovvljETy0SXFzDT4drjwRXJZd2RTI9SHQwGWDgxP/yQIA9Prf1C7gX2UvvaU+x3A9WJYF1MDxsvRGslJirwu1OMkLz5WuwChjxKdwvZ76GswvSdajm7tFX9Qpy8aBAxLryQAF71pretvj5ZY87y/lYLz81wbGuK7wEZekFzMsC3uw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1645.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(366004)(396003)(39860400002)(7416002)(186003)(33656002)(64756008)(2906002)(71200400001)(6506007)(66946007)(76116006)(26005)(66446008)(66476007)(66556008)(9686003)(7696005)(55016002)(966005)(52536014)(5660300002)(4326008)(478600001)(86362001)(316002)(83380400001)(8936002)(8676002)(110136005)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: ntHdvaSwKHzDENfGoof5FiU0JDU2PqBMC8nVA5+ppKTinc8Dff2IEyVolyrRvf7ANj0VhmBxSgXX6YGkFz8LeWt4uZwOfeiswKc3oUoo9I3zTAECJktF5pu5mNh3YAXm8svDV31IX40RTPtxeZTD5oMgt4zIidX4FVXG6UbmTg8z1CcLnhKclQcQP2c23rNrzEMpmwR2hMGKl/UC+8V4ZYRisdGeh781Vh++go5iJmFimiRsWPlCXTH5WKL3oNML0U6h/GR1DcA41X/5Ybc6t+Q8gMySYuSiiq+2MIGN3y0eFh76SeZ4z4d+AqCAchZ1tCa/l9k/ra5FxRGma0HIeHd/nJWJN+k4dPrLUdZ/b6ATrlHKkjKCN6w4XE8GhmBOdD8sj9Rimzk4wbIzGFSD3VUWNbK4GvFO7+TLpHFtk8FN33MbtIGKUK85vUT+ysHj1XWmAj92fEYbJqNLFc6BHF1CrokByd02mtvuN1Vw4b9sEH4CNa2xWNfpMjMM7mE24IPaC0cBiVRSPFUAq7fsCAixFVyNqsUv0PneqAXFPETbcWMmxn8e/Udq/bbWiNcPyS1BhxSIfAO8KPVBuyHIkYnhnVpATbeTqDurYnWMYtZdtDl02Pnh9QgkRkRNXtsw0oK96JkOugIg10kRtbAKvw==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1645.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21b3d769-0bdb-4473-6ad3-08d83e74efbb
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Aug 2020 04:05:23.0401
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OBFDHP9AoXT+Cvq01BldGTvZCHYevlP/yfRqpjy4yazCoEzowSCapB1bjfjZpxtXcgUARmLNpzd7KvkHdJMzrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2093
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBKYXNvbiBXYW5nIDxqYXNvd2FuZ0ByZWRoYXQuY29tPg0KPiBTZW50OiBXZWRuZXNk
YXksIEF1Z3VzdCAxMiwgMjAyMCAxMToyOCBBTQ0KPiANCj4gDQo+IE9uIDIwMjAvOC8xMCDkuIvl
jYgzOjMyLCBUaWFuLCBLZXZpbiB3cm90ZToNCj4gPj4gRnJvbTogSmFzb24gR3VudGhvcnBlIDxq
Z2dAbnZpZGlhLmNvbT4NCj4gPj4gU2VudDogRnJpZGF5LCBBdWd1c3QgNywgMjAyMCA4OjIwIFBN
DQo+ID4+DQo+ID4+IE9uIFdlZCwgQXVnIDA1LCAyMDIwIGF0IDA3OjIyOjU4UE0gLTA2MDAsIEFs
ZXggV2lsbGlhbXNvbiB3cm90ZToNCj4gPj4NCj4gPj4+IElmIHlvdSBzZWUgdGhpcyBhcyBhbiBh
YnVzZSBvZiB0aGUgZnJhbWV3b3JrLCB0aGVuIGxldCdzIGlkZW50aWZ5IHRob3NlDQo+ID4+PiBz
cGVjaWZpYyBpc3N1ZXMgYW5kIGNvbWUgdXAgd2l0aCBhIGJldHRlciBhcHByb2FjaC4gIEFzIHdl
J3ZlIGRpc2N1c3NlZA0KPiA+Pj4gYmVmb3JlLCB0aGluZ3MgbGlrZSBiYXNpYyBQQ0kgY29uZmln
IHNwYWNlIGVtdWxhdGlvbiBhcmUgYWNjZXB0YWJsZQ0KPiA+Pj4gb3ZlcmhlYWQgYW5kIGxvdyBy
aXNrIChpbW8pIGFuZCBzb21lIGRlZ3JlZSBvZiByZWdpc3RlciBlbXVsYXRpb24gaXMNCj4gPj4+
IHdlbGwgd2l0aGluIHRoZSB0ZXJyaXRvcnkgb2YgYW4gbWRldiBkcml2ZXIuDQo+ID4+IFdoYXQg
dHJvdWJsZXMgbWUgaXMgdGhhdCBpZHhkIGFscmVhZHkgaGFzIGEgZGlyZWN0IHVzZXJzcGFjZSBp
bnRlcmZhY2UNCj4gPj4gdG8gaXRzIEhXLCBhbmQgZG9lcyB1c2Vyc3BhY2UgRE1BLiBUaGUgcHVy
cG9zZSBvZiB0aGlzIG1kZXYgaXMgdG8NCj4gPj4gcHJvdmlkZSBhIHNlY29uZCBkaXJlY3QgdXNl
cnNwYWNlIGludGVyZmFjZSB0aGF0IGlzIGEgbGl0dGxlIGRpZmZlcmVudA0KPiA+PiBhbmQgdHJp
dmlhbGx5IHBsdWdzIGludG8gdGhlIHZpcnR1YWxpemF0aW9uIHN0YWNrLg0KPiA+IE5vLiBVc2Vy
c3BhY2UgRE1BIGFuZCBzdWJkZXZpY2UgcGFzc3Rocm91Z2ggKHdoYXQgbWRldiBwcm92aWRlcykN
Cj4gPiBhcmUgdHdvIGRpc3RpbmN0IHVzYWdlcyBJTU8gKGF0IGxlYXN0IGluIGlkeGQgY29udGV4
dCkuIGFuZCB0aGlzIG1pZ2h0DQo+ID4gYmUgdGhlIG1haW4gZGl2ZXJnZW5jZSBiZXR3ZWVuIHVz
LCB0aHVzIGxldCBtZSBwdXQgbW9yZSB3b3JkcyBoZXJlLg0KPiA+IElmIHdlIGNvdWxkIHJlYWNo
IGNvbnNlbnN1cyBpbiB0aGlzIG1hdHRlciwgd2hpY2ggZGlyZWN0aW9uIHRvIGdvDQo+ID4gd291
bGQgYmUgY2xlYXJlci4NCj4gPg0KPiA+IEZpcnN0LCBhIHBhc3N0aHJvdWdoIGludGVyZmFjZSBy
ZXF1aXJlcyBzb21lIHVuaXF1ZSByZXF1aXJlbWVudHMNCj4gPiB3aGljaCBhcmUgbm90IGNvbW1v
bmx5IG9ic2VydmVkIGluIGFuIHVzZXJzcGFjZSBETUEgaW50ZXJmYWNlLCBlLmcuOg0KPiA+DQo+
ID4gLSBUcmFja2luZyBETUEgZGlydHkgcGFnZXMgZm9yIGxpdmUgbWlncmF0aW9uOw0KPiA+IC0g
QSBzZXQgb2YgaW50ZXJmYWNlcyBmb3IgdXNpbmcgU1ZBIGluc2lkZSBndWVzdDsNCj4gPiAJKiBQ
QVNJRCBhbGxvY2F0aW9uL2ZyZWUgKG9uIHNvbWUgcGxhdGZvcm1zKTsNCj4gPiAJKiBiaW5kL3Vu
YmluZCBndWVzdCBtbS9wYWdlIHRhYmxlIChuZXN0ZWQgdHJhbnNsYXRpb24pOw0KPiA+IAkqIGlu
dmFsaWRhdGUgSU9NTVUgY2FjaGUvaW90bGIgZm9yIGd1ZXN0IHBhZ2UgdGFibGUgY2hhbmdlczsN
Cj4gPiAJKiByZXBvcnQgcGFnZSByZXF1ZXN0IGZyb20gZGV2aWNlIHRvIGd1ZXN0Ow0KPiA+IAkq
IGZvcndhcmQgcGFnZSByZXNwb25zZSBmcm9tIGd1ZXN0IHRvIGRldmljZTsNCj4gPiAtIENvbmZp
Z3VyaW5nIGlycWJ5cGFzcyBmb3IgcG9zdGVkIGludGVycnVwdDsNCj4gPiAtIC4uLg0KPiA+DQo+
ID4gU2Vjb25kLCBhIHBhc3N0aHJvdWdoIGludGVyZmFjZSByZXF1aXJlcyBkZWxlZ2F0aW5nIHJh
dyBjb250cm9sbGFiaWxpdHkNCj4gPiBvZiBzdWJkZXZpY2UgdG8gZ3Vlc3QgZHJpdmVyLCB3aGls
ZSB0aGUgc2FtZSBkZWxlZ2F0aW9uIG1pZ2h0IG5vdCBiZQ0KPiA+IHJlcXVpcmVkIGZvciBpbXBs
ZW1lbnRpbmcgYW4gdXNlcnNwYWNlIERNQSBpbnRlcmZhY2UgKGVzcGVjaWFsbHkgZm9yDQo+ID4g
bW9kZXJuIGRldmljZXMgd2hpY2ggc3VwcG9ydCBTVkEpLiBGb3IgZXhhbXBsZSwgaWR4ZCBhbGxv
d3MgZm9sbG93aW5nDQo+ID4gc2V0dGluZyBwZXIgd3EgKGd1ZXN0IGRyaXZlciBtYXkgY29uZmln
dXJlIHRoZW0gaW4gYW55IGNvbWJpbmF0aW9uKToNCj4gPiAJLSBwdXQgaW4gZGVkaWNhdGVkIG9y
IHNoYXJlZCBtb2RlOw0KPiA+IAktIGVuYWJsZS9kaXNhYmxlIFNWQTsNCj4gPiAJLSBBc3NvY2lh
dGUgZ3Vlc3QtcHJvdmlkZWQgUEFTSUQgdG8gTVNJL0lNUyBlbnRyeTsNCj4gPiAJLSBzZXQgdGhy
ZXNob2xkOw0KPiA+IAktIGFsbG93L2RlbnkgcHJpdmlsZWdlZCBhY2Nlc3M7DQo+ID4gCS0gYWxs
b2NhdGUvZnJlZSBpbnRlcnJ1cHQgaGFuZGxlIChlbmxpZ2h0ZW5lZCBmb3IgZ3Vlc3QpOw0KPiA+
IAktIGNvbGxlY3QgZXJyb3Igc3RhdHVzOw0KPiA+IAktIC4uLg0KPiA+DQo+ID4gV2UgcGxhbiB0
byBzdXBwb3J0IGlkeGQgdXNlcnNwYWNlIERNQSB3aXRoIFNWQS4gVGhlIGRyaXZlciBqdXN0IG5l
ZWRzDQo+ID4gdG8gcHJlcGFyZSBhIHdxIHdpdGggYSBwcmVkZWZpbmVkIGNvbmZpZ3VyYXRpb24g
KGUuZy4gc2hhcmVkLCBTVkEsDQo+ID4gZXRjLiksIGJpbmQgdGhlIHByb2Nlc3MgbW0gdG8gSU9N
TVUgKG5vbi1uZXN0ZWQpIGFuZCB0aGVuIG1hcA0KPiA+IHRoZSBwb3J0YWwgdG8gdXNlcnNwYWNl
LiBUaGUgZ29hbCB0aGF0IHVzZXJzcGFjZSBjYW4gZG8gRE1BIHRvDQo+ID4gYXNzb2NpYXRlZCB3
cSBkb2Vzbid0IGNoYW5nZSB0aGUgZmFjdCB0aGF0IHRoZSB3cSBpcyBzdGlsbCAqb3duZWQqDQo+
ID4gYW5kICpjb250cm9sbGVkKiBieSBrZXJuZWwgZHJpdmVyLiBIb3dldmVyIGFzIGZhciBhcyBw
YXNzdGhyb3VnaA0KPiA+IGlzIGNvbmNlcm5lZCwgdGhlIHdxIGlzIGNvbnNpZGVyZWQgJ293bmVk
JyBieSB0aGUgZ3Vlc3QgZHJpdmVyIHRodXMNCj4gPiB3ZSBuZWVkIGFuIGludGVyZmFjZSB3aGlj
aCBjYW4gc3VwcG9ydCBsb3ctbGV2ZWwgKmNvbnRyb2xsYWJpbGl0eSoNCj4gPiBmcm9tIGd1ZXN0
IGRyaXZlci4gSXQgaXMgc29ydCBvZiBhIG1lc3MgaW4gdUFQSSB3aGVuIG1peGluZyB0aGUNCj4g
PiB0d28gdG9nZXRoZXIuDQo+IA0KPiANCj4gU28gZm9yIHVzZXJzcGFjZSBkcml2ZXJzIGxpa2Ug
RFBESywgaXQgY2FuIHVzZSBib3RoIG9mIHRoZSB0d28gdUFQSXM/DQoNCnllcy4NCg0KPiANCj4g
DQo+ID4NCj4gPiBCYXNlZCBvbiBhYm92ZSB0d28gcmVhc29ucywgd2Ugc2VlIGRpc3RpbmN0IHJl
cXVpcmVtZW50cyBiZXR3ZWVuDQo+ID4gdXNlcnNwYWNlIERNQSBhbmQgcGFzc3Rocm91Z2ggaW50
ZXJmYWNlcywgYXQgbGVhc3QgaW4gaWR4ZCBjb250ZXh0DQo+ID4gKHRob3VnaCBvdGhlciBkZXZp
Y2VzIG1heSBoYXZlIGxlc3MgZGlzdGluY3Rpb24gaW4tYmV0d2VlbikuIFRoZXJlZm9yZSwNCj4g
PiB3ZSBkaWRuJ3Qgc2VlIHRoZSB2YWx1ZS9uZWNlc3NpdHkgb2YgcmVpbnZlbnRpbmcgdGhlIHdo
ZWVsIHRoYXQgbWRldg0KPiA+IGFscmVhZHkgaGFuZGxlcyB3ZWxsIHRvIGV2b2x2ZSBhbiBzaW1w
bGUgYXBwbGljYXRpb24tb3JpZW50ZWQgdXNlc3BhY2UNCj4gPiBETUEgaW50ZXJmYWNlIHRvIGEg
Y29tcGxleCBndWVzdC1kcml2ZXItb3JpZW50ZWQgcGFzc3Rocm91Z2ggaW50ZXJmYWNlLg0KPiA+
IFRoZSBjb21wbGV4aXR5IG9mIGRvaW5nIHNvIHdvdWxkIGluY3VyIGZhciBtb3JlIGtlcm5lbC1z
aWRlIGNoYW5nZXMNCj4gPiB0aGFuIHRoZSBwb3J0aW9uIG9mIGVtdWxhdGlvbiBjb2RlIHRoYXQg
eW91J3ZlIGJlZW4gY29uY2VybmVkIGFib3V0Li4uDQo+ID4NCj4gPj4gSSBkb24ndCB0aGluayBW
RklPIHNob3VsZCBiZSB0aGUgb25seSBlbnRyeSBwb2ludCB0bw0KPiA+PiB2aXJ0dWFsaXphdGlv
bi4gSWYgd2Ugc2F5IHRoZSB1bml2ZXJzZSBvZiBkZXZpY2VzIGRvaW5nIHVzZXIgc3BhY2UgRE1B
DQo+ID4+IG11c3QgYWxzbyBpbXBsZW1lbnQgYSBWRklPIG1kZXYgdG8gcGx1ZyBpbnRvIHZpcnR1
YWxpemF0aW9uIHRoZW4gaXQNCj4gPj4gd2lsbCBiZSBhbG90IG9mIG1kZXZzLg0KPiA+IENlcnRh
aW5seSBWRklPIHdpbGwgbm90IGJlIHRoZSBvbmx5IGVudHJ5IHBvaW50LiBhbmQgVGhpcyBoYXMg
dG8gYmUgYQ0KPiA+IGNhc2UtYnktY2FzZSBkZWNpc2lvbi4NCj4gDQo+IA0KPiBUaGUgcHJvYmxl
bSBpcyB0aGF0IGlmIHdlIHRpZSBhbGwgY29udHJvbHMgdmlhIFZGSU8gdUFQSSwgdGhlIG90aGVy
DQo+IHN1YnN5c3RlbSBsaWtlIHZEUEEgaXMgbGlrZWx5IHRvIGR1cGxpY2F0ZSB0aGVtLiBJIHdv
bmRlciBpZiB0aGVyZSBpcyBhDQo+IHdheSB0byBkZWNvdXBsZSB0aGUgdlNWQSBvdXQgb2YgVkZJ
TyB1QVBJPw0KDQp2U1ZBIGlzIGEgcGVyLWRldmljZSAoZWl0aGVyIHBkZXYgb3IgbWRldikgZmVh
dHVyZSB0aHVzIG5hdHVyYWxseSBzaG91bGQgDQpiZSBtYW5hZ2VkIGJ5IGl0cyBkZXZpY2UgZHJp
dmVyIChWRklPIG9yIHZEUEEpLiBGcm9tIHRoaXMgYW5nbGUgc29tZQ0KZHVwbGljYXRpb24gaXMg
aW5ldml0YWJsZSBnaXZlbiBWRklPIGFuZCB2RFBBIGFyZSBvcnRob2dvbmFsIHBhc3N0aHJvdWdo
DQpmcmFtZXdvcmtzLiBXaXRoaW4gdGhlIGtlcm5lbCB0aGUgbWFqb3JpdHkgb2YgdlNWQSBoYW5k
bGluZyBpcyBkb25lIGJ5DQpJT01NVSBhbmQgSU9BU0lEIG1vZHVsZXMgdGh1cyBtb3N0IGxvZ2lj
IGFyZSBzaGFyZWQuDQoNCj4gDQo+IA0KPiA+ICAgSWYgYW4gdXNlcnNwYWNlIERNQSBpbnRlcmZh
Y2UgY2FuIGJlIGVhc2lseQ0KPiA+IGFkYXB0ZWQgdG8gYmUgYSBwYXNzdGhyb3VnaCBvbmUsIGl0
IG1pZ2h0IGJlIHRoZSBjaG9pY2UuDQo+IA0KPiANCj4gSXQncyBub3QgdGhhdCBlYXN5IGV2ZW4g
Zm9yIFZGSU8gd2hpY2ggcmVxdWlyZXMgYSBsb3Qgb2YgbmV3IHVBUElzIGFuZA0KPiBpbmZyYXN0
cnVjdHVyZXMoZS5nIG1kZXYpIHRvIGJlIGludmVudGVkLg0KPiANCj4gDQo+ID4gQnV0IGZvciBp
ZHhkLA0KPiA+IHdlIHNlZSBtZGV2IGEgbXVjaCBiZXR0ZXIgZml0IGhlcmUsIGdpdmVuIHRoZSBi
aWcgZGlmZmVyZW5jZSBiZXR3ZWVuDQo+ID4gd2hhdCB1c2Vyc3BhY2UgRE1BIHJlcXVpcmVzIGFu
ZCB3aGF0IGd1ZXN0IGRyaXZlciByZXF1aXJlcyBpbiB0aGlzIGh3Lg0KPiANCj4gDQo+IEEgd2Vh
ayBwb2ludCBmb3IgbWRldiBpcyB0aGF0IGl0IGNhbid0IHNlcnZlIGtlcm5lbCBzdWJzeXN0ZW0g
b3RoZXIgdGhhbg0KPiBWRklPLiBJbiB0aGlzIGNhc2UsIHlvdSBuZWVkIHNvbWUgb3RoZXIgaW5m
cmFzdHJ1Y3R1cmVzIChsaWtlIFsxXSkgdG8gZG8NCj4gdGhpcy4NCg0KbWRldiBpcyBub3QgZXhj
bHVzaXZlIGZyb20ga2VybmVsIHVzYWdlcy4gSXQncyBwZXJmZWN0bHkgZmluZSBmb3IgYSBkcml2
ZXINCnRvIHJlc2VydmUgc29tZSB3b3JrIHF1ZXVlcyBmb3IgaG9zdCB1c2FnZXMsIHdoaWxlIHdy
YXBwaW5nIG90aGVycw0KaW50byBtZGV2cy4NCg0KVGhhbmtzDQpLZXZpbg0KDQo+IA0KPiAoRm9y
IGlkeGQsIHlvdSBwcm9iYWJseSBkb24ndCBuZWVkIHRoaXMsIGJ1dCBpdCdzIHByZXR0eSBjb21t
b24gaW4gdGhlDQo+IGNhc2Ugb2YgbmV0d29ya2luZyBvciBzdG9yYWdlIGRldmljZS4pDQo+IA0K
PiBUaGFua3MNCj4gDQo+IFsxXSBodHRwczovL3BhdGNod29yay5rZXJuZWwub3JnL3BhdGNoLzEx
MjgwNTQ3Lw0KPiANCj4gDQo+ID4NCj4gPj4gSSB3b3VsZCBwcmVmZXIgdG8gc2VlIHRoYXQgdGhl
IGV4aXN0aW5nIHVzZXJzcGFjZSBpbnRlcmZhY2UgaGF2ZSB0aGUNCj4gPj4gZXh0cmEgbmVlZGVk
IGJpdHMgZm9yIHZpcnR1YWxpemF0aW9uIChlZyBieSBoYXZpbmcgYXBwcm9wcmlhdGUNCj4gPj4g
aW50ZXJuYWwga2VybmVsIEFQSXMgdG8gbWFrZSB0aGlzIGVhc3kpIGFuZCBhbGwgdGhlIGVtdWxh
dGlvbiB0byBidWlsZA0KPiA+PiB0aGUgc3ludGhldGljIFBDSSBkZXZpY2UgYmUgZG9uZSBpbiB1
c2Vyc3BhY2UuDQo+ID4gSW4gdGhlIGVuZCB3aGF0IGRlY2lkZXMgdGhlIGRpcmVjdGlvbiBpcyB0
aGUgYW1vdW50IG9mIGNoYW5nZXMgdGhhdA0KPiA+IHdlIGhhdmUgdG8gcHV0IGluIGtlcm5lbCwg
bm90IHdoZXRoZXIgd2UgY2FsbCBpdCAnZW11bGF0aW9uJy4gRm9yIGlkeGQsDQo+ID4gYWRkaW5n
IHNwZWNpYWwgcGFzc3Rocm91Z2ggcmVxdWlyZW1lbnRzIChndWVzdCBTVkEsIGRpcnR5IHRyYWNr
aW5nLA0KPiA+IGV0Yy4pIGFuZCByYXcgY29udHJvbGxhYmlsaXR5IHRvIHRoZSBzaW1wbGUgdXNl
cnNwYWNlIERNQSBpbnRlcmZhY2UNCj4gPiBpcyBmb3Igc3VyZSBtYWtpbmcga2VybmVsIG1vcmUg
Y29tcGxleCB0aGFuIHJldXNpbmcgdGhlIG1kZXYNCj4gPiBmcmFtZXdvcmsgKHBsdXMgc29tZSBk
ZWdyZWUgb2YgZW11bGF0aW9uIG1vY2t1cCBiZWhpbmQpLiBOb3QgdG8NCj4gPiBtZW50aW9uIHRo
ZSBtZXJpdCBvZiB1QVBJIGNvbXBhdGliaWxpdHkgd2l0aCBtZGV2Li4uDQo+ID4NCj4gPiBUaGFu
a3MNCj4gPiBLZXZpbg0KPiA+DQoNCg==
