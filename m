Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA122B3DB0
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 08:33:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727692AbgKPHb7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 02:31:59 -0500
Received: from mga09.intel.com ([134.134.136.24]:17546 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727567AbgKPHb6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 02:31:58 -0500
IronPort-SDR: vYnShSCNC28He2EebSnxFcNBqqpI9OYfIx4giBO3UYFThTAavNGrKpXZcaqDXNu+2NN1hsjV5q
 xamwkrZjyRxA==
X-IronPort-AV: E=McAfee;i="6000,8403,9806"; a="170880799"
X-IronPort-AV: E=Sophos;i="5.77,481,1596524400"; 
   d="scan'208";a="170880799"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2020 23:31:53 -0800
IronPort-SDR: zT01ETi3oSYeBtbZzPXMWZxLNh0C6yB17AglvPSp334UGO7j6cpRduTwLI28KAexVlqDhQhYJH
 fQ4v9hhHqaAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,481,1596524400"; 
   d="scan'208";a="367411556"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by FMSMGA003.fm.intel.com with ESMTP; 15 Nov 2020 23:31:52 -0800
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sun, 15 Nov 2020 23:31:52 -0800
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sun, 15 Nov 2020 23:31:51 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Sun, 15 Nov 2020 23:31:51 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Sun, 15 Nov 2020 23:31:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AU3SCuy4t8frdRIkAPYQ7TbFAwRttwdb2aC97gUrxYvqM8J3n4T9zpYSH2CJp5+uBi8UUjBJqMpjKO4SJm4b8R6fW1PXoGq9Slm1ZbOaFflmeNHWWuZrmUW6X4/r3LRzWwiq2SKMeQXRVeK7jAYmuLAmkCoEeU5sdq0YvSKzuW1kGj65hUCwWw30xHRWnJVslhk7DnVurU+It/nfLke0+30qou50HXBdy+1uHuBj1yUtMI+ELXWQ1cLklXZfg5WhF6UFkKkcQBr+97POv2YANzawhEIv4CncTxYOBvBYqrGT1A+5VSz4PSs9e+sVGgJPSoCTchUgjmHIyzBZmAzwJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n26GMehNB1UURBY9bH9tI807HiamRaZPF/rsTwDrcNI=;
 b=fzWSKkJdZ8DdH1WePcD+Bm8EcU64y8OMqV6AVIVQKLDOtGA3SCsPn5NkFY9VweBWR78/zP9Z4WTU56BEq2dJlm50lK1muCwDQakGHeYptJ5DE1n3GSNen+UOCt+0XCIqN7AY6riZjIKZ1Mg6C7BCjQUBb5lC1ig7zb3chCzWOkoQvqCP8O+GVsmw2LrtbdtWwE6xiZytOvtVYKfK3sNhkITIMLtpHI8hOPgcBhy0CHGBsF1ILr31QVez/OPw4kwAOEy31KIBXo5EX7Iqz5UszE2cuKQmPUCvveL9vIq/3mz+a5I43QP6nNGFYSE4R7hffBcXBSAZz1GGAD6LGaqevQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n26GMehNB1UURBY9bH9tI807HiamRaZPF/rsTwDrcNI=;
 b=ollmXl2gyPyRhSPHW5OZwOv3qobRXzyGsWAd7vZ28zLDt4Nq9sNw4TWqbfEE+SjPztp55ynfgXDhIjmIE0jOFwYQL2KI2HO2A9MlFIPq6c+aqSCokLyZL6mceFRPd3ekjH78u7n6jzHcAax1kgDK9cjGQZPbzENuyf2iudpQ48g=
Received: from MWHPR11MB1645.namprd11.prod.outlook.com (2603:10b6:301:b::12)
 by MW3PR11MB4523.namprd11.prod.outlook.com (2603:10b6:303:5b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.25; Mon, 16 Nov
 2020 07:31:50 +0000
Received: from MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::31c9:44c6:7323:61ac]) by MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::31c9:44c6:7323:61ac%7]) with mapi id 15.20.3564.028; Mon, 16 Nov 2020
 07:31:49 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Raj, Ashok" <ashok.raj@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC:     Christoph Hellwig <hch@infradead.org>,
        "Wilk, Konrad" <konrad.wilk@oracle.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Bjorn Helgaas" <helgaas@kernel.org>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "Dey, Megha" <megha.dey@intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "netanelg@mellanox.com" <netanelg@mellanox.com>,
        "shahafs@mellanox.com" <shahafs@mellanox.com>,
        "yan.y.zhao@linux.intel.com" <yan.y.zhao@linux.intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Ortiz, Samuel" <samuel.ortiz@intel.com>,
        "Hossain, Mona" <mona.hossain@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>
Subject: RE: [PATCH v4 06/17] PCI: add SIOV and IMS capability detection
Thread-Topic: [PATCH v4 06/17] PCI: add SIOV and IMS capability detection
Thread-Index: AQHWru26nCdjGLbk80+ZhPfx8iZ806mwjmaAgAAYm4CAABfkAIAAARAAgAQYdwCAAOAGcIAAp6mAgAD1diCAAJvfgIAADi9AgAAGfICAArW6cIAAY8KAgAA79QCAABGDgIAAY1IAgAAHBYCAAsnwAIAAVwYAgAC+sACAAGcnAIAAVyaAgABtcgCAAFeIgIAAPx2AgAEDTgCAAnqggIAANQ4AgAJZMACAALP3gIAA7NsAgACHqwCAACyRgIAAJKAAgABss7A=
Date:   Mon, 16 Nov 2020 07:31:49 +0000
Message-ID: <MWHPR11MB164539B8FDE63D5CBDA300E18CE30@MWHPR11MB1645.namprd11.prod.outlook.com>
References: <875z6dik1a.fsf@nanos.tec.linutronix.de>
 <20201110141323.GB22336@otc-nc-03>
 <MWHPR11MB16455B594B1B48B6E3C97C108CE80@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201112193253.GG19638@char.us.oracle.com>
 <877dqqmc2h.fsf@nanos.tec.linutronix.de>
 <20201114103430.GA9810@infradead.org>
 <20201114211837.GB12197@araj-mobl1.jf.intel.com>
 <877dqmamjl.fsf@nanos.tec.linutronix.de>
 <20201115193156.GB14750@araj-mobl1.jf.intel.com>
 <875z665kz4.fsf@nanos.tec.linutronix.de>
 <20201116002232.GA2440@araj-mobl1.jf.intel.com>
In-Reply-To: <20201116002232.GA2440@araj-mobl1.jf.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b04885b8-523b-48fd-90ea-08d88a01ae77
x-ms-traffictypediagnostic: MW3PR11MB4523:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR11MB45231986AB0997471F40A17B8CE30@MW3PR11MB4523.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xJjlREf3HmcSJ8Gzxzu3CYYtiX4VMGuGrWj659kXP/+RjBMcUjeAmBznVQiv9B7abL61ItA6s1mb+AWe731E1JHDfQ8kyvZnN2oCaLJKQ82ZojW2xA/Flp+K8I50fNhO8ut3sEJ7BAQAxJpQmL9cbTz6C/bzZQ9MKON0pVrflFtL6HZsY4XOCKtV0TugXGY4ePwPnrEEN2G7Nq9T5MsfT7bOWvQTWqf+JBY1t2zZn2wg8wNjQfC+QeJpX5ZuL+jGHraSQ1bKzcg4pKYQGbaiC74xcQvy7XPTj/+qEA/37TJiGBOUPTJ15MLTjbKKuNfCrzhA/3q8fYaaY9GOtVg4KQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1645.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(136003)(366004)(346002)(396003)(110136005)(2906002)(4326008)(54906003)(478600001)(7696005)(6506007)(7416002)(316002)(186003)(26005)(9686003)(8676002)(55016002)(66476007)(66556008)(64756008)(66446008)(83380400001)(52536014)(76116006)(66946007)(33656002)(86362001)(71200400001)(5660300002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: N+ip5PvXm8BS+xQmvyBorLFT70qbRgfYxDuVfNLz8+MaTl6wa8Ti3zj3YqMhUawSZS0msHdsJRJ+MEqpn3FXrLpwHwuHTxE6Bz74u8M5itxmTL+xzfPJ61iJ/CzFrtVTsuMxfgiWiZ0nuCYbHqaWVCVUN+dNRrULvvYRZRWogcJIrxIMLrvlqoZI/Kt05IE3Gkz7GPJZoLaVGe/CKWACng3iPzBx2NfZ2F07nvTD7Ec4HPqC8V+MRW+Rxi3vt4x3v4rxrfesdJ1YULPfdKqHvghQxd6h6Iy1Kr7tUdNmxkSFplsJkmOw0sWH6RJzGRm285psVB4VqfTzZZZ5pIjMXhUY7lK5h9J9jDnh0+kORA4LGA0XgfHvNFTkWEIZ/tb5VZ7BVbGQxOEjhyrPH2WrXNz7ID3A5eYre+4q67tXwkA+FInNZF5seilRFkGR8Kd6BSvSZvwTYorhUnVRyGH6c2JrlL9RrQ6LXt+aDhND9FT0inLh36J56yaCkhC6ylKBslu0W5rEnTQlRl8i7jYd/cfiVhSLczpg2w2fjigeajP+pWE5agQJXv0ydRMm7gnApWr2kqarVuIYj6YaVEBDRmPzyeZX0sAYKsikG3L8LtjTTb8DYRAMNIDyW3vexei7iuQfraGAPzClDgzzCJgioQ==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1645.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b04885b8-523b-48fd-90ea-08d88a01ae77
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Nov 2020 07:31:49.7038
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qjiLA4lxFZK9IjU+oUBeUvnLd61EZoJ7YdyYbnpn9AKukePJQlpLVgwrfm455fhgFzNDQhHYtdZYTSlHlMYCaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4523
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBSYWosIEFzaG9rIDxhc2hvay5yYWpAaW50ZWwuY29tPg0KPiBTZW50OiBNb25kYXks
IE5vdmVtYmVyIDE2LCAyMDIwIDg6MjMgQU0NCj4gDQo+IE9uIFN1biwgTm92IDE1LCAyMDIwIGF0
IDExOjExOjI3UE0gKzAxMDAsIFRob21hcyBHbGVpeG5lciB3cm90ZToNCj4gPiBPbiBTdW4sIE5v
diAxNSAyMDIwIGF0IDExOjMxLCBBc2hvayBSYWogd3JvdGU6DQo+ID4gPiBPbiBTdW4sIE5vdiAx
NSwgMjAyMCBhdCAxMjoyNjoyMlBNICswMTAwLCBUaG9tYXMgR2xlaXhuZXIgd3JvdGU6DQo+ID4g
Pj4gPiBvcHQtaW4gYnkgZGV2aWNlIG9yIGtlcm5lbD8gVGhlIHdheSB3ZSBhcmUgcGxhbm5pbmcg
dG8gc3VwcG9ydCB0aGlzIGlzOg0KPiA+ID4+ID4NCj4gPiA+PiA+IERldmljZSBzdXBwb3J0IGZv
ciBJTVMgLSBDYW4gZGlzY292ZXIgaW4gZGV2aWNlIHNwZWNpZmljIG1lYW5zDQo+ID4gPj4gPiBL
ZXJuZWwgc3VwcG9ydCBmb3IgSU1TLiAtIFN1cHBvcnRlZCBieSBJT01NVSBkcml2ZXIuDQo+ID4g
Pj4NCj4gPiA+PiBBbmQgd2h5IGV4YWN0bHkgZG8gd2UgaGF2ZSB0byBlbmZvcmNlIElPTU1VIHN1
cHBvcnQ/IFBsZWFzZSBzdG9wDQo+IGxvb2tpbmcNCj4gPiA+PiBhdCBJTVMgcHVyZWx5IGZyb20g
dGhlIElEWEQgcGVyc3BlY3RpdmUuIFdlIGFyZSB0YWxraW5nIGFib3V0IHRoZQ0KPiA+ID4+IGdl
bmVyYWwgY29uY2VwdCBoZXJlIGFuZCBub3QgYWJvdXQgdGhlIHJlc3RyaWN0ZWQgSW50ZWwgdW5p
dmVyc2UuDQo+ID4gPg0KPiA+ID4gSSB0aGluayB5b3UgaGF2ZSBtZW50aW9uZWQgaXQgYWxtb3N0
IGV2ZXJ5IHJlcGx5IDotKS4uR290IHRoYXQhIFBvaW50IHRha2VuDQo+ID4gPiBzZXZlcmFsIGVt
YWlscyBhZ28hISA6LSkNCj4gPg0KPiA+IFlvdSBzdXJlPyBJIF90cnlfIHRvIG5vdCBtZW50aW9u
IGl0IGFnYWluIHRoZW4uIE5vIHByb21pc2UgdGhvdWdoLiA6KQ0KPiANCj4gSGV5Li4gYW55dGhp
bmcgdGhhdCdzIGVudGVydGFpbmluZyBnbyBmb3IgaXQgOi0pDQo+IA0KPiA+DQo+ID4gPiBJIGRp
ZG4ndCBtZWFuIGp1c3QgZm9yIGlkeGQsIEkgc2FpZCBmb3IgKkFOWSogZGV2aWNlIGRyaXZlciB0
aGF0IHdhbnRzIHRvDQo+ID4gPiB1c2UgSU1TLg0KPiA+DQo+ID4gV2hpY2ggaXMgd3JvbmcuIEFn
YWluOg0KPiA+DQo+ID4gQSkgRm9yIFBGL1ZGIG9uIGJhcmUgbWV0YWwgdGhlcmUgaXMgYWJzb2x1
dGVseSBubyBJT01NVSBkZXBlbmRlbmN5DQo+ID4gICAgYmVjYXVzZSBpdCBkb2VzIG5vdCBoYXZl
IGEgUEFTSUQgcmVxdWlyZW1lbnQuIEl0J3MganVzdCBhbg0KPiA+ICAgIGFsdGVybmF0aXZlIHNv
bHV0aW9uIHRvIE1TSVtYXSwgd2hpY2ggYWxsb3dzIG9wdGltaXphdGlvbnMgbGlrZQ0KPiA+ICAg
IHN0b3JpbmcgdGhlIG1lc3NhZ2UgaW4gZHJpdmVyIG1hbmFnZXMgcXVldWUgbWVtb3J5IG9yIGxp
ZnRpbmcgdGhlDQo+ID4gICAgcmVzdHJpY3Rpb24gb2YgMjA0OCBpbnRlcnJ1cHRzIHBlciBkZXZp
Y2UuIE5vdGhpbmcgZWxzZS4NCj4gDQo+IFlvdSBhcmUgcmlnaHQuLiBteSBleWVzIHdlcmUgY2xv
dWRlZCBieSB2aXJ0dWFsaXphdGlvbi4uIG5vIGRlcGVuZGVuY3kgZm9yDQo+IG5hdGl2ZSBhYnNv
bHV0ZWx5Lg0KPiANCj4gPg0KPiA+IEIpIEZvciBQRi9WRiBpbiBhIGd1ZXN0IHRoZSBJT01NVSBk
ZXBlbmRlbmN5IG9mIElNUyBpcyBhIHJlZCBoZXJyaW5nLg0KPiA+ICAgIFRoZXJlIGlzIG5vIGRp
cmVjdCBkZXBlbmRlbmN5IG9uIHRoZSBJT01NVS4NCj4gPg0KPiA+ICAgIFRoZSBwcm9ibGVtIGlz
IHRoZSBpbmFiaWxpdHkgb2YgdGhlIFZNTSB0byB0cmFwIHRoZSBtZXNzYWdlIHdyaXRlIHRvDQo+
ID4gICAgdGhlIElNUyBzdG9yYWdlIGlmIHRoZSBzdG9yYWdlIGlzIGluIGd1ZXN0IGRyaXZlciBt
YW5hZ2VkIG1lbW9yeS4NCj4gPiAgICBUaGlzIGNhbiBiZSBzb2x2ZWQgd2l0aCBlaXRoZXINCj4g
Pg0KPiA+ICAgIC0gYSBoeXBlcmNhbGwgd2hpY2ggdHJhbnNsYXRlcyB0aGUgZ3Vlc3QgTVNJIG1l
c3NhZ2UNCj4gPiAgICBvcg0KPiA+ICAgIC0gYSB2SU9NTVUgd2hpY2ggdXNlcyBhIGh5cGVyY2Fs
bCBvciB3aGF0ZXZlciB0byB0cmFuc2xhdGUgdGhlIGd1ZXN0DQo+ID4gICAgICBNU0kgbWVzc2Fn
ZQ0KPiA+DQo+ID4gQykgU3ViZGV2aWNlcyBhbGEgbWRldiBhcmUgYSBkaWZmZXJlbnQgc3Rvcnku
IFRoZXkgcmVxdWlyZSBQQVNJRCB3aGljaA0KPiA+ICAgIGVuZm9yY2VzIElPTU1VIGFuZCB0aGUg
SU1TIHBhcnQgaXMgbm90IG1hbmFnZWQgYnkgdGhlIHVzZXJzIGFueXdheS4NCj4gDQo+IFlvdSBh
cmUgcmlnaHQgYWdhaW4gOikNCj4gDQo+IFRoZSBzdWJkZXZpY2VzIHJlcXVpcmUgUEFTSUQgJiBJ
T01NVSBpbiBuYXRpdmUsIGJ1dCBpbnNpZGUgdGhlIGd1ZXN0IHRoZXJlDQo+IGlzIG5vDQo+IG5l
ZWQgZm9yIElPTU1VIHVubGVzcyB5b3Ugd2FudCB0byBidWlsZCBTVk0gb24gdG9wLiBzdWJkZXZp
Y2VzIHdvcmsNCj4gd2l0aG91dA0KPiBhbnkgdklPTU1VIG9yIGh5cGVyY2FsbCBpbiB0aGUgZ3Vl
c3QuIE9ubHkgYmVjYXVzZSB0aGV5IGxvb2sgbGlrZSBub3JtYWwNCj4gUENJIGRldmljZXMgd2Ug
Y291bGQgbWFwIGludGVycnVwdHMgdG8gbGVnYWN5IE1TSXguDQoNCkd1ZXN0IG1hbmFnZWQgc3Vi
ZGV2aWNlcyBvbiBQRi9WRiByZXF1aXJlcyB2SU9NTVUuIEFueXdheSBJIHRoaW5rDQpUaG9tYXMg
d2FzIGp1c3QgcG9pbnRpbmcgb3V0IHRoYXQgc3ViZGV2aWNlcyBhcmUgdGhlIG9ubHkgY2F0ZWdv
cnkgb3V0DQpvZiBhYm92ZSB0aHJlZSB3aGljaCBtYXkgaGF2ZSBidXNpbmVzcyB0aWVkIHRvIElP
TU1VLiDwn5iKDQoNCj4gDQo+ID4NCj4gPiBTbyB3ZSBoYXZlIGEgY291cGxlIG9mIHByb2JsZW1z
IHRvIHNvbHZlOg0KPiA+DQo+ID4gICAxKSBGaWd1cmUgb3V0IHdoZXRoZXIgdGhlIE9TIHJ1bnMg
b24gYmFyZSBtZXRhbA0KPiA+DQo+ID4gICAgICBUaGVyZSBpcyBubyByZWxpYWJsZSBhbnN3ZXIg
dG8gdGhhdCwgc28gd2UgZWl0aGVyOg0KPiA+DQo+ID4gICAgICAgLSBVc2UgaGV1cmlzdGljcyBh
bmQgYXNzdW1lIHRoYXQgZmFpbHVyZSBpcyB1bmxpa2VseSBhbmQgaW4gY2FzZQ0KPiA+ICAgICAg
ICAgb2YgZmFpbHVyZSBibGFtZSB0aGUgaW5jb21wZXRlbmNlIG9mIFZNTSBhdXRob3JzIGFuZC9v
cg0KPiA+ICAgICAgICAgc3lzYWRtaW5zDQo+ID4NCj4gPiAgICAgIG9yDQo+ID4NCj4gPiAgICAg
ICAtIERlZmF1bHQgdG8gSU1TIGRpc2FibGVkIGFuZCBsZXQgdGhlIHN5c2FkbWluIGVuYWJsZSBp
dCB2aWENCj4gPiAgICAgICAgIGNvbW1hbmQgbGluZSBvcHRpb24uDQo+ID4NCj4gPiAgICAgICAg
IElmIHRoZSBrZXJuZWwgZGV0ZWN0cyB0byBydW4gaW4gYSBWTSBpdCB5ZWxscyBhbmQgZGlzYWJs
ZXMgaXQNCj4gPiAgICAgICAgIHVubGVzcyB0aGUgT1MgYW5kIHRoZSBoeXBlcnZpc29yIGFncmVl
IHRvIHByb3ZpZGUgc3VwcG9ydCBmb3INCj4gPiAgICAgICAgIHRoYXQgc2NlbmFyaW8gKHNlZSAj
MikuDQo+ID4NCj4gPiAgICAgICAgIFRoYXQncyBmYWlscyBhcyB3ZWxsIGlmIHRoZSBzeXNhZG1p
biBkb2VzIHNvIHdoZW4gdGhlIE9TIHJ1bnMgb24NCj4gPiAgICAgICAgIGEgVk1NIHdoaWNoIGlz
IG5vdCBpZGVudGlmaWFibGUsIGJ1dCBhdCBsZWFzdCB3ZSBjYW4gcmlnaHRmdWxseQ0KPiA+ICAg
ICAgICAgYmxhbWUgdGhlIHN5c2FkbWluIGluIHRoYXQgY2FzZS4NCj4gDQo+IGNtZGxpbmUgaXNu
J3QgbmljZSwgYmVzdCB0byBoYXZlIHRoaXMgZnVuY3Rpb25hbCBvdXQgb2YgYm94Lg0KPiANCj4g
Pg0KPiA+ICAgICAgb3INCj4gPg0KPiA+ICAgICAgIC0gRGVjbGFyZSB0aGF0IElNUyBhbHdheXMg
ZGVwZW5kcyBvbiBJT01NVQ0KPiANCj4gQXMgeW91IGhhZCBtZW50aW9uZWQgSU1TIGhhcyBubyBy
ZWFsIGRlcGVuZGVuY3kgb24gSU9NTVUgaW4gbmF0aXZlLg0KPiANCj4gd2UganVzdCBuZWVkIHRv
IG1ha2Ugc3VyZSBpZiBydW5uaW5nIGluIGd1ZXN0IHdlIGhhdmUgc3VwcG9ydCBmb3IgaXQNCj4g
cGx1bWJlZC4NCj4gDQo+ID4NCj4gPiAgICAgICAgIEkgcGVyc29uYWx5IGRvbid0IGNhcmUsIGJ1
dCBwZW9wbGUgd29ya2luZyBvbiB0aGVzZSBraW5kIG9mDQo+ID4gICAgICAgICBkZXZpY2UgYWxy
ZWFkeSBzYWlkLCB0aGF0IHRoZXkgd2FudCB0byBhdm9pZCBpdCB3aGVuIHBvc3NpYmxlLg0KPiA+
DQo+ID4gICAgICAgICBJZiB5b3Ugd2FudCB0byBnbyB0aGF0IHJvdXRlLCB0aGVuIHBsZWFzZSB0
YWxrIHRvIHRob3NlIGZvbGtzDQo+ID4gICAgICAgICBhbmQgYXNrIHRoZW0gdG8gYWdyZWUgaW4g
cHVibGljLg0KPiA+DQo+ID4gICAgICBZb3UgYWxzbyBuZWVkIHRvIHRha2UgaW50byBhY2NvdW50
IHRoYXQgdGhpcyBtdXN0IHdvcmsgb24gYWxsDQo+ID4gICAgICBhcmNoaXRlY3R1cmVzIHdoaWNo
IHN1cHBvcnQgdmlydHVhbGl6YXRpb24gYmVjYXVzZSBJTVMgaXMNCj4gPiAgICAgIGFyY2hpdGVj
dHVyZSBpbmRlcGVuZGVudC4NCj4gDQo+IFdoYXQgeW91IHN1Z2dlc3QgbWFrZXMgcGVyZmVjdCBz
ZW5zZS4gV2UgY2FuIGNlcnRhaW5seSBnZXQgYnV5IGluIGZyb20NCj4gaW9tbXUgbGlzdCBhbmQg
aGF2ZSB0aGlzIGNvLW9yZGluYXRlZCBiZXR3ZWVuIGFsbCBleGlzdGluZyBpb21tdSB2YXJpZW50
cy4NCg0KRG9lcyBhIGh5YnJpZCBzY2hlbWUgc291bmQgZ29vZCBoZXJlPw0KDQotIFNheSBhIGNt
ZGxpbmUgcGFyYW1ldGVyOiBpbXM9W2F1dG98b258b2ZmXSwgd2l0aCAnYXV0bycgYXMgZGVmYXVs
dDsNCg0KLSBpZiBpbXM9YXV0bzoNCg0KICAgICogSWYgYXJjaCBkb2Vzbid0IGltcGxlbWVudCBw
cm9iYWJseV9vbl9iYXJlX21ldGFsLCBkaXNhbGxvdyBpbXM7DQoNCiAgICAqIElmIHByb2JhYmx5
X29uX2JhcmVfbWV0YWwgcmV0dXJucyBmYWxzZSwgZGlzYWxsb3cgaW1zOw0KCSMgKGZ1dHVyZSkg
aWYgaHlwZXJjYWxsIGlzIHN1cHBvcnRlZCwgYWxsb3cgaW1zOw0KDQogICAgKiBJZiBwcm9iYWJs
eV9vbl9iYXJlX21ldGFsIHJldHVybnMgdHJ1ZSwgYWxsb3cgaW1zIHdpdGggY2F2ZWF0IG9uDQpw
b3NzaWJsZSBtaXMtaW50ZXJjZXB0aW9uIG9mIHJ1bm5pbmcgb24gYW4gb2xkIGh5cGVydmlzb3Iu
IFN5c2FkbWluDQptYXkgbmVlZCB0byBkb3VibGUtY29uZmlybSBpbiBvdGhlciBtZWFucyANCgkj
IChmdXR1cmUpIGlmIGRlZmluaXRlbHlfb25fYmFyZV9tZXRhbCBpcyBzdXBwb3J0ZWQsIG5vIGNh
dmVhdDsNCg0KLSBpZiBpbXM9b246DQoNCiAgICAqIElmIHByb2JhYmx5X29uX2JhcmVfbWV0YWwg
cmV0dXJuIGZhbHNlLCB5ZWxsIGFuZCBkaXNhYmxlIGl0IHVudGlsDQpoeXBlcmNhbGwgaXMgc3Vw
cG9ydGVkOw0KDQogICAgKiBJbiBhbGwgb3RoZXIgY2FzZXMgYWxsb3cgaW1zLiBTeXNhZG1pbiBz
aG91bGQgYmUgYmxhbWVkIGlmIGFueQ0KZmFpbHVyZSBhcyBkb2luZyBzbyBpbXBsaWVzIHRoYXQg
ZXh0cmEgY29uZmlybWF0aW9uIGhhcyBiZWVuIGRvbmU7DQoNCi0gaWYgaW1zPW9mZiwgdGhlbiBs
ZWF2ZSBpdCBvZmYuDQoNCkl0J3Mgbm90IG5lY2Vzc2FyeSB0byBjbGFpbSBzdHJpY3QgZGVwZW5k
ZW5jeSBiZXR3ZWVuIGltcyBhbmQgaW9tbXUuDQpJbnN0ZWFkLCB3ZSBjb3VsZCBsZWF2ZSBpb21t
dSBiZWluZyBhbiBhcmNoIHNwZWNpZmljIGNoZWNrIHdoZW4gaXQNCmFwcGxpZXM6DQoNCnByb2Jh
Ymx5X29uX2JhcmVfbWV0YWwoKQ0Kew0KICAgICAgIGlmIChDUFVJRChGRUFUVVJFX0hZUEVSVklT
T1IpKQ0KICAgICAgICAJcmV0dXJuIGZhbHNlOw0KICAgICAgIGlmIChkbWlfbWF0Y2hfaHlwZXJ2
aXNvcl92ZW5kb3IoKSkNCiAgICAgICAgCXJldHVybiBmYWxzZTsNCiAgICAgICBpZiAoaW9tbXVf
ZXhpc3RpbmcoKSAmJiBpb21tdV9pbl9ndWVzdCgpKQ0KICAgICAgICAJcmV0dXJuIGZhbHNlOw0K
DQogICAgICAgIHJldHVybiBQUk9CQUJMWV9SVU5OSU5HX09OX0JBUkVfTUVUQUw7DQp9DQogDQo+
IA0KPiA+DQo+ID4gICAyKSBHdWVzdCBzdXBwb3J0IGZvciBQRi9WRg0KPiA+DQo+ID4gICAgICBB
Z2FpbiB3ZSBoYXZlIHNldmVyYWwgc2NlbmFyaW9zIGRlcGVuZGluZyBvbiB0aGUgSU1TIHN0b3Jh
Z2UNCj4gPiAgICAgIHR5cGUuDQo+ID4NCj4gPiAgICAgICAtIElmIHRoZSBzdG9yYWdlIHR5cGUg
aXMgZGV2aWNlIG1lbW9yeSB0aGVuIGl0J3MgcHJldHR5IG11Y2ggdGhlDQo+ID4gICAgICAgICBz
YW1lIGFzIE1TSVtYXSBqdXN0IGEgZGlmZmVyZW50IGxvY2F0aW9uLg0KPiANCj4gVHJ1ZSwgYnV0
IHN0aWxsIG5lZWQgdG8gaGF2ZSBzb21lIHNwZWNpYWwgaGFuZGxpbmcgZm9yIHRyYXBwaW5nIHRo
b3NlIG1taW8NCj4gYWNjZXNzLiBVbmxpa2UgZm9yIE1TSXggVkZJTyBhbHJlYWR5IHRyYXBzIHRo
ZW0gYW5kIGV2ZXJ5dGhpbmcgaXMNCj4gcHJlLXBsdW1tYmVkLiBJdCBpc24ndCBzZWFtbGVzcyBh
cyBpdHMgZm9yIE1TSXguDQoNCnllcy4gU28gd2hhdCBhYm91dCB0eWluZyBndWVzdCBJTVMgdG8g
aHlwZXJjYWxsIGV2ZW4gd2hlbiBlbXVsYXRpb24NCmlzIHBvc3NpYmxlIG9uIHNvbWUgZGV2aWNl
cz8gIEl0J3MgZGlmZmljdWx0IGZvciB0aGUgZ3Vlc3QgdG8ga25vdyB0aGF0DQppdHMgSU1TIGlz
IGVtdWxhdGVkIGJ5IGh5cGVydmlzb3IuIEFkb3B0aW5nIGFuIHVuaWZpZWQgcG9saWN5IGZvciBh
bGwNCklNUy1jYXBhYmxlIGRldmljZXMgbWlnaHQgYmUgYW4gZWFzaWVyIHBhdGguDQoNCj4gDQo+
ID4NCj4gPiAgICAgICAtIElmIHRoZSBzdG9yYWdlIGlzIGluIGRyaXZlciBtYW5hZ2VkIG1lbW9y
eSB0aGVuIHRoaXMgbmVlZHMNCj4gPiAgICAgICAgICMxIHBsdXMgZ3Vlc3QgT1MgYW5kIGh5cGVy
dmlzb3Igc3VwcG9ydCAoaHlwZXJjYWxsL3ZJT01NVSkNCj4gDQo+IFZpb2xlbnQgYWdyZWVtZW50
IGhlcmUgOi0pDQo+IA0KPiA+DQo+ID4gICAzKSBHdWVzdCBzdXBwb3J0IGZvciBQRi9WRiBhbmQg
Z3Vlc3QgbWFuYWdlZCBzdWJkZXZpY2UgKG1kZXYpDQo+ID4NCj4gPiAgICAgIERlcGVuZHMgb24g
IzEgYW5kICMyIGFuZCBpcyBhbiBvcnRob2dvbmFsIHByb2JsZW0gaWYgSSdtIG5vdA0KPiA+ICAg
ICAgbWlzc2luZyBzb21ldGhpbmcuDQo+ID4NCj4gPiBUbyBtb3ZlIGZvcndhcmQgd2UgbmVlZCB0
byBtYWtlIGEgZGVjaXNpb24gYWJvdXQgIzEgYW5kICMyIG5vdy4NCj4gDQo+IE1vc3RseSBpbiBh
Z3JlZW1lbnQuIEV4Y2VwdCBmb3IgbWRldiAoY3VycmVudCBjb25zaWRlcmVkIHVzZSBjYXNlKSBo
YXZlIG5vDQo+IG5lZWQgZm9yIElNUyBpbiB0aGUgZ3Vlc3QuIChEb24ndCBnZXQgbWUgd3Jvbmcs
IEknbSBub3Qgc2F5aW5nIHNvbWUgb2RkDQo+IGRldmljZSBtYW5hZ2luZyBzdWItZGV2aWNlcyB3
b3VsZCBuZWVkIElNUyBpbiBhZGRpdGlvbiBhbmQgdGhhdCB0aGUgMjA0OA0KPiBNU0l4IGVtdWxh
dGlvbi4NCj4gPg0KPiA+IFRoaXMgbmVlZHMgdG8gYmUgd2VsbCB0aG91Z2h0IG91dCBhcyBjaGFu
Z2luZyBpdCBhZnRlciB0aGUgZmFjdCBpcw0KPiA+IGdvaW5nIHRvIGJlIGEgbmlnaHRtYXJlLg0K
PiA+DQo+ID4gL21lIGdydWRnaW5nbHkgcmVmcmFpbnMgZnJvbSBtZW50aW9uaW5nIHRoZSBvYnZp
b3VzIG9uY2UgbW9yZS4NCj4gPg0KPiANCj4gU28gdGhpcyBpc24ndCBhbiBpZHhkIGFuZCBJbnRl
bCBvbmx5IHRoaW5nIDotKS4uLg0KPiANCj4gQ2hlZXJzLA0KPiBBc2hvaw0KDQpUaGFua3MNCktl
dmluDQoNCg==
