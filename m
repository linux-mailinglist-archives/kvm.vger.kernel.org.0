Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6BA2243398
	for <lists+kvm@lfdr.de>; Thu, 13 Aug 2020 07:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726419AbgHMF0V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Aug 2020 01:26:21 -0400
Received: from mga17.intel.com ([192.55.52.151]:48477 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725937AbgHMF0V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Aug 2020 01:26:21 -0400
IronPort-SDR: EOjheOyQ8iwMlbJszr1pCZnlwSSxyOW8McdLkp5v3ysl4EuZDIVHMcSCPwWAAOR+QsELBfXFme
 W7dNU1APwz/g==
X-IronPort-AV: E=McAfee;i="6000,8403,9711"; a="134219555"
X-IronPort-AV: E=Sophos;i="5.76,307,1592895600"; 
   d="scan'208";a="134219555"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2020 22:26:18 -0700
IronPort-SDR: CtQpoMJmcGliew/SsonhWiWtiy1DizG6KAa1hxtJGvXz5coZdIsRxhIzHZWOzXvTcHyzhR3w16
 53SGWX+XRGMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,307,1592895600"; 
   d="scan'208";a="278045982"
Received: from fmsmsx603-2.cps.intel.com (HELO fmsmsx603.amr.corp.intel.com) ([10.18.84.213])
  by fmsmga008.fm.intel.com with ESMTP; 12 Aug 2020 22:26:18 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 12 Aug 2020 22:26:18 -0700
Received: from fmsmsx151.amr.corp.intel.com (10.18.125.4) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 12 Aug 2020 22:26:18 -0700
Received: from FMSEDG001.ED.cps.intel.com (10.1.192.133) by
 FMSMSX151.amr.corp.intel.com (10.18.125.4) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 12 Aug 2020 22:26:17 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.109)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Wed, 12 Aug 2020 22:26:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NS0XQ3go9nnB37288UMwdfu40oWp+DYGj6+yJQ3zdbM5w07zTKQyXeKFnRW3i+EUT0fTw2yAqKoLXsnOGDVsGKWUnHjDn0x5c6/l3L2GtFxCZuFGIF9k+1/0fU+2sm+uJqnMcTxkqSzIzqz6hf34HWJh4ZvQpnd+pst5uh6mx4rw5blR1CnNWg+GYlp6/PVaAoPaTQYOL4mk/yD3wilgsGtrCDfa9i0utoHH3Irrg2Gf9mVVYMsjXpUnCtjtmXuWDH0W0QRYE/PWn9HfAGs7Ph7zoqwH1e95PLLXnAFoz1IOv+/muzL4PLE64UB3//TLqYmq6CXu2x+g/Z/gkXcIEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cv40q4LjWP16p63WCM+cKQiA8AFO+FnISfACgSfSBTQ=;
 b=HEy82rExZ+1MIrFBnBffSMaeWRjFHQSl8UbHR5xMAyN3hZIm4P7UDTcBM42TG5qPPD4q3xrVCapsQ/dixYRFMK9Tron4rEUrdw6MA5IM5znMgBb4luVNlg6zEOWK8V2v9iD2R29DhQmRMeuY6ugeYJ713oCmZo4p0HUX45ya+9iIQGD+b+GCCR2V2H0xPptz3v6xflp99iWfGwuwGl5z854OmGYO4pR6d1NuHM8HPrPvwg2ifG+8MRWES/0cW734/FnjtkkeO2UHsmHQZILjKWSGhzqgSqHwvmz/TTVIvjcsDNbftQu+/B/AzuUyZDKh/8P7uNsKGbmhaIJS4PkWWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cv40q4LjWP16p63WCM+cKQiA8AFO+FnISfACgSfSBTQ=;
 b=IaLkMwYSVwRNkFlJcc9w9LOdGb3z/8H7d9yLRqjZfVaa6fx+rxIVA9qdV6DJhiz1lXA5z5K/pDjjTdgdLhj7QE450EnG5Pg04xlstgl9POmisCrAqAp/MNL1zn9LopyoCT5ClBgjHkEfqFbnE3DK73W38PmjTSgkooh7gtuUeUw=
Received: from MWHPR11MB1645.namprd11.prod.outlook.com (2603:10b6:301:b::12)
 by MW3PR11MB4729.namprd11.prod.outlook.com (2603:10b6:303:5d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.15; Thu, 13 Aug
 2020 05:26:14 +0000
Received: from MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::6dfe:feb8:25f1:ac9c]) by MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::6dfe:feb8:25f1:ac9c%7]) with mapi id 15.20.3283.016; Thu, 13 Aug 2020
 05:26:14 +0000
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
Thread-Index: AQHWX3hut2htBlMVB0qfW0Pa+gZbC6kSPbuAgABwW8CAAzMrAIAUgAoAgAJJ4oCABDO9YIADE1sAgAACHkCAAaKQAIAACXXA
Date:   Thu, 13 Aug 2020 05:26:14 +0000
Message-ID: <MWHPR11MB1645F911EFB993C9067B58DD8C430@MWHPR11MB1645.namprd11.prod.outlook.com>
References: <159534667974.28840.2045034360240786644.stgit@djiang5-desk3.ch.intel.com>
 <20200721164527.GD2021248@mellanox.com>
 <CY4PR11MB1638103EC73DD9C025F144C98C780@CY4PR11MB1638.namprd11.prod.outlook.com>
 <20200724001930.GS2021248@mellanox.com> <20200805192258.5ee7a05b@x1.home>
 <20200807121955.GS16789@nvidia.com>
 <MWHPR11MB16452EBE866E330A7E000AFC8C440@MWHPR11MB1645.namprd11.prod.outlook.com>
 <b59ce5b0-5530-1f30-9852-409f7c9f630a@redhat.com>
 <MWHPR11MB1645DDC2C87D533B2A09A2D58C420@MWHPR11MB1645.namprd11.prod.outlook.com>
 <ecc76dfb-7047-c1ab-e244-d73f05688f20@redhat.com>
In-Reply-To: <ecc76dfb-7047-c1ab-e244-d73f05688f20@redhat.com>
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
x-ms-office365-filtering-correlation-id: 4f2f96bf-f929-43d2-8e5a-08d83f4965c7
x-ms-traffictypediagnostic: MW3PR11MB4729:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR11MB4729B8FD1B992648D76314DC8C430@MW3PR11MB4729.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: L+b8pH8DOHdyROM2v0frOMe1M8oTRe9ZeFHBpfOjcLkG2wy0a2bmiazuCk65PHqP7AbSW6k530EtBWnAfWYZeOQcUlaQrLgZD92S20FxcBWF8MCYv7hj8oSTwEzfYck7k6zUDZGRtIUm4cSDM3gxOv1ob06K4um9s3LEjliig49tv9AeRuNHSwVguC8UpQDnB6MUei9LPmyo281jCzMX3HtACwSnFls9LbcIZkKUVSSnstq1BZBj4XHSLvKbcHGTzRmakILhnnwm74r43wG+8wGgXrvVM6vy1z9+ISvWPtqRW2LqAcYiCpypn+f8g2z9ohbAbInIsUUNefoB6T1MZg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1645.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(346002)(376002)(136003)(396003)(39860400002)(66556008)(7416002)(76116006)(66476007)(26005)(66446008)(186003)(64756008)(66946007)(4326008)(8936002)(478600001)(6506007)(86362001)(7696005)(71200400001)(316002)(8676002)(9686003)(2906002)(83380400001)(55016002)(52536014)(33656002)(5660300002)(110136005)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: Bi1vQiqh7QdoyCo8egeKjxDEORdfkgp+43+HkTBgWNuIO16tzAzC88y9F+J1wUGsPSecOPjqiMVzIsMgR57WfN7QpBPJv4chJX+NJ/qHgm+wxLAHx7kmV37Y1xOvp/cF9sX3zi7Wor82yt3YuNjmif04EDAJsUqgbVRQdI4mrcmDCMMXvk8ucckeA2sac9YZ42gOc5q1kLmP8CIKYwUqu6yOF+Ua/ayzc2p3I9hTJ9f5u/PbY3lShPdvHpAIlUV+cN2iy+thcAbAcnsRM2ASCxQIbVKeYhTN7bfOs37plbYS8fgOedlx7g9v6v13Koqixry74RoxJks9+uInIXHImJZxisaxOl5UKiWsRlQdM3mVfqiGghdPi2Qbdomm2eECyycYdZ8rd8zqecF/sLEXjxWYO5AeBovTWjraCiwzxuiIoFWNWDwTVFcbKO95TYuxDu5wK+AAuojNMlQUoJplckrthtP5YOoD3aovsIelHy9+yHw910mySi2PXforCCSVjbUBxm5AO02f5gBrXg41rRrToYVfky0IStXrR4SPEOK1SOtb929p8HL11S1lR2qeiMS5xFPq1f5eVy9/GsCPmzTNNLLkDbf7SlwlyPKgcc+Tt3nYlrfYjtXS/ohkZ9pWKc1Lwg++VWb/9U1AirNrJQ==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1645.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f2f96bf-f929-43d2-8e5a-08d83f4965c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2020 05:26:14.2885
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pl7lJw3573ZAo1pkAvLSlDwuzarzQswOasVOjQeDuRgXmLht0UydYouDgn7C+c+u1s+UV/21rYEuLynfJT8O2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4729
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBKYXNvbiBXYW5nIDxqYXNvd2FuZ0ByZWRoYXQuY29tPg0KPiBTZW50OiBUaHVyc2Rh
eSwgQXVndXN0IDEzLCAyMDIwIDEyOjM0IFBNDQo+IA0KPiANCj4gT24gMjAyMC84LzEyIOS4i+WN
iDEyOjA1LCBUaWFuLCBLZXZpbiB3cm90ZToNCj4gPj4gVGhlIHByb2JsZW0gaXMgdGhhdCBpZiB3
ZSB0aWUgYWxsIGNvbnRyb2xzIHZpYSBWRklPIHVBUEksIHRoZSBvdGhlcg0KPiA+PiBzdWJzeXN0
ZW0gbGlrZSB2RFBBIGlzIGxpa2VseSB0byBkdXBsaWNhdGUgdGhlbS4gSSB3b25kZXIgaWYgdGhl
cmUgaXMgYQ0KPiA+PiB3YXkgdG8gZGVjb3VwbGUgdGhlIHZTVkEgb3V0IG9mIFZGSU8gdUFQST8N
Cj4gPiB2U1ZBIGlzIGEgcGVyLWRldmljZSAoZWl0aGVyIHBkZXYgb3IgbWRldikgZmVhdHVyZSB0
aHVzIG5hdHVyYWxseSBzaG91bGQNCj4gPiBiZSBtYW5hZ2VkIGJ5IGl0cyBkZXZpY2UgZHJpdmVy
IChWRklPIG9yIHZEUEEpLiBGcm9tIHRoaXMgYW5nbGUgc29tZQ0KPiA+IGR1cGxpY2F0aW9uIGlz
IGluZXZpdGFibGUgZ2l2ZW4gVkZJTyBhbmQgdkRQQSBhcmUgb3J0aG9nb25hbCBwYXNzdGhyb3Vn
aA0KPiA+IGZyYW1ld29ya3MuIFdpdGhpbiB0aGUga2VybmVsIHRoZSBtYWpvcml0eSBvZiB2U1ZB
IGhhbmRsaW5nIGlzIGRvbmUgYnkNCj4gPiBJT01NVSBhbmQgSU9BU0lEIG1vZHVsZXMgdGh1cyBt
b3N0IGxvZ2ljIGFyZSBzaGFyZWQuDQo+IA0KPiANCj4gU28gd2h5IG5vdCBpbnRyb2R1Y2UgdlNW
QSB1QVBJIGF0IElPTU1VIG9yIElPQVNJRCBsYXllcj8NCg0KT25lIG1heSBhc2sgYSBzaW1pbGFy
IHF1ZXN0aW9uIHdoeSBJT01NVSBkb2Vzbid0IGV4cG9zZSBtYXAvdW5tYXANCmFzIHVBUEkuLi4N
Cg0KPiANCj4gDQo+ID4NCj4gPj4+ICAgIElmIGFuIHVzZXJzcGFjZSBETUEgaW50ZXJmYWNlIGNh
biBiZSBlYXNpbHkNCj4gPj4+IGFkYXB0ZWQgdG8gYmUgYSBwYXNzdGhyb3VnaCBvbmUsIGl0IG1p
Z2h0IGJlIHRoZSBjaG9pY2UuDQo+ID4+IEl0J3Mgbm90IHRoYXQgZWFzeSBldmVuIGZvciBWRklP
IHdoaWNoIHJlcXVpcmVzIGEgbG90IG9mIG5ldyB1QVBJcyBhbmQNCj4gPj4gaW5mcmFzdHJ1Y3R1
cmVzKGUuZyBtZGV2KSB0byBiZSBpbnZlbnRlZC4NCj4gPj4NCj4gPj4NCj4gPj4+IEJ1dCBmb3Ig
aWR4ZCwNCj4gPj4+IHdlIHNlZSBtZGV2IGEgbXVjaCBiZXR0ZXIgZml0IGhlcmUsIGdpdmVuIHRo
ZSBiaWcgZGlmZmVyZW5jZSBiZXR3ZWVuDQo+ID4+PiB3aGF0IHVzZXJzcGFjZSBETUEgcmVxdWly
ZXMgYW5kIHdoYXQgZ3Vlc3QgZHJpdmVyIHJlcXVpcmVzIGluIHRoaXMgaHcuDQo+ID4+IEEgd2Vh
ayBwb2ludCBmb3IgbWRldiBpcyB0aGF0IGl0IGNhbid0IHNlcnZlIGtlcm5lbCBzdWJzeXN0ZW0g
b3RoZXIgdGhhbg0KPiA+PiBWRklPLiBJbiB0aGlzIGNhc2UsIHlvdSBuZWVkIHNvbWUgb3RoZXIg
aW5mcmFzdHJ1Y3R1cmVzIChsaWtlIFsxXSkgdG8gZG8NCj4gPj4gdGhpcy4NCj4gPiBtZGV2IGlz
IG5vdCBleGNsdXNpdmUgZnJvbSBrZXJuZWwgdXNhZ2VzLiBJdCdzIHBlcmZlY3RseSBmaW5lIGZv
ciBhIGRyaXZlcg0KPiA+IHRvIHJlc2VydmUgc29tZSB3b3JrIHF1ZXVlcyBmb3IgaG9zdCB1c2Fn
ZXMsIHdoaWxlIHdyYXBwaW5nIG90aGVycw0KPiA+IGludG8gbWRldnMuDQo+IA0KPiANCj4gSSBt
ZWFudCB5b3UgbWF5IHdhbnQgc2xpY2VzIHRvIGJlIGFuIGluZGVwZW5kZW50IGRldmljZSBmcm9t
IHRoZSBrZXJuZWwNCj4gcG9pbnQgb2YgdmlldzoNCj4gDQo+IEUuZyBmb3IgZXRoZXJuZXQgZGV2
aWNlcywgeW91IG1heSB3YW50IDEwSyBtZGV2cyB0byBiZSBwYXNzZWQgdG8gZ3Vlc3QuDQo+IA0K
PiBTaW1pbGFybHksIHlvdSBtYXkgd2FudCAxMEsgbmV0IGRldmljZXMgd2hpY2ggaXMgY29ubmVj
dGVkIHRvIHRoZSBrZXJuZWwNCj4gbmV0d29ya2luZyBzdWJzeXN0ZW1zLg0KPiANCj4gSW4gdGhp
cyBjYXNlIGl0J3Mgbm90IHNpbXBseSByZXNlcnZpbmcgcXVldWVzIGJ1dCB5b3UgbmVlZCBzb21l
IG90aGVyDQo+IHR5cGUgb2YgZGV2aWNlIGFic3RyYWN0aW9uLiBUaGVyZSBjb3VsZCBiZSBzb21l
IGtpbmQgb2YgZHVwbGljYXRpb24NCj4gYmV0d2VlbiB0aGlzIGFuZCBtZGV2Lg0KPiANCg0KeWVz
LCBzb21lIGFic3RyYWN0aW9uIHJlcXVpcmVkIGJ1dCBpc24ndCBpdCB3aGF0IHRoZSBkcml2ZXIg
c2hvdWxkDQpjYXJlIGFib3V0IGluc3RlYWQgb2YgbWRldiBmcmFtZXdvcmsgaXRzZWxmPyBJZiB0
aGUgZHJpdmVyIHJlcG9ydHMNCnRoZSBzYW1lIHNldCBvZiByZXNvdXJjZSB0byBib3RoIG1kZXYg
YW5kIG5ldHdvcmtpbmcsIGl0IG5lZWRzIHRvDQptYWtlIHN1cmUgd2hlbiB0aGUgcmVzb3VyY2Ug
aXMgY2xhaW1lZCBpbiBvbmUgaW50ZXJmYWNlIHRoZW4gaXQNCnNob3VsZCBiZSBtYXJrZWQgaW4t
dXNlIGluIGFub3RoZXIuIGUuZy4gZWFjaCBtZGV2IGluY2x1ZGVzIGENCmF2YWlsYWJsZV9pbnRh
bmNlcyBhdHRyaWJ1dGUuIHRoZSBkcml2ZXIgY291bGQgcmVwb3J0IDEwayBhdmFpbGFibGUNCmlu
c3RhbmNlcyBpbml0aWFsbHkgYW5kIHRoZW4gdXBkYXRlIGl0IHRvIDVLIHdoZW4gYW5vdGhlciA1
SyBpcyB1c2VkDQpmb3IgbmV0IGRldmljZXMgbGF0ZXIuDQoNCk1kZXYgZGVmaW5pdGVseSBoYXMg
aXRzIHVzYWdlIGxpbWl0YXRpb25zLiBTb21lIG1heSBiZSBpbXByb3ZlZCANCmluIHRoZSBmdXR1
cmUsIHNvbWUgbWF5IG5vdC4gQnV0IHRob3NlIGFyZSBkaXN0cmFjdGluZyBmcm9tIHRoZQ0Kb3Jp
Z2luYWwgcHVycG9zZSBvZiB0aGlzIHRocmVhZCAobWRldiB2cy4gdXNlcnNwYWNlIERNQSkgYW5k
IGJldHRlcg0KYmUgZGlzY3Vzc2VkIGluIG90aGVyIHBsYWNlcyBlLmcuIExQQy4uLiANCg0KVGhh
bmtzDQpLZXZpbg0K
