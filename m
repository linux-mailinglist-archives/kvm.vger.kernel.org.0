Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3CA5218206
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 10:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbgGHII4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 04:08:56 -0400
Received: from mga07.intel.com ([134.134.136.100]:11277 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726285AbgGHIIz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jul 2020 04:08:55 -0400
IronPort-SDR: d9rdTGCJkiDBhdJSC7csAkzMx0+Hnju9H283gCFuXo47S1b636VHM2lMw1xI0xcHUO4tOv9HfX
 2c6S4/Xv5vZg==
X-IronPort-AV: E=McAfee;i="6000,8403,9675"; a="212700021"
X-IronPort-AV: E=Sophos;i="5.75,327,1589266800"; 
   d="scan'208";a="212700021"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2020 01:08:51 -0700
IronPort-SDR: HqExt5Ydq/O2JVGcZl8NU9tduvZ3s/5NI5qHf6mALfhXEQdxZ4Zdzd0qtnjtPctqlY3tvLCzZX
 N1ZN5G/+xNeA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,327,1589266800"; 
   d="scan'208";a="297647597"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by orsmga002.jf.intel.com with ESMTP; 08 Jul 2020 01:08:50 -0700
Received: from fmsmsx151.amr.corp.intel.com (10.18.125.4) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 8 Jul 2020 01:08:50 -0700
Received: from FMSEDG002.ED.cps.intel.com (10.1.192.134) by
 FMSMSX151.amr.corp.intel.com (10.18.125.4) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 8 Jul 2020 01:08:42 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.69) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Wed, 8 Jul 2020 01:08:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LzL/GSpR3NS4nC6bU0OYsiHOW4cZem33Y2s98HBshKqK1JK800BozaRlvAvU1Kkx8kXSr8FACsfp8qUmBf0ixyo7446pDe931i87PuDfIhSJB+C9VQY+1hbscslBLWYW1t67shJq1ctsKMrTQpBrE5uaq+2cyk9FHBl4UxYF3n0NXSAdiikxoWSCZNCEv7b8AT7Mo0skhPBAlrNa+BA4UgyvTyhmC94zl/9qczm9RsAALVI5adb/WwRi3ZD3PZUmYNoYl2TGFZCoCXUyi9TpbCaMeBBhCNvc58Q4sWtP39G8M7sgqBniXcF13kGdcyZs0s/Q6vToIIN3VLfp7KLfHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a2EwgJFRYruhtOGqjRBGUFgbcUCZvP39L4zSBk5l6co=;
 b=HF3X7SUJxaK3VmExW3cYJ2v8pk/sBqVyZZIlYNmlnZfxSJMlsUIor/4MaWm/jOJpkdnYUscvtBG0Fs1p19/PSN0GK+6/Is+SeOdMNSfhogy/ProX7aIc+Qpg+GlRNdxL2dn3NVQjT+ndhuVTcfFXwL7URon+9upclcbhkHjvS8J7CIeSaF7rrSMIHB3ZU7c5mheSnW4NOApB9QIFBahvNKORlLDe5qu8B0XQ157+NavL492PAM3bhHb0Or7JpLBrQ0SocYRDNQUgyso04TfcYxsvubrx1dRxW19GZVRXevzEu+sVXxhMHJw27057Hg4JmiKDIuZM3uj0UdiVjpQ/fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a2EwgJFRYruhtOGqjRBGUFgbcUCZvP39L4zSBk5l6co=;
 b=hXHnik2VNN2zcGj3+/PsFU4UtGcTYnJ+7/zmw520QpYPLKfim7OWhToli65JP25kn3d1qBY0YDD5rMlWteuVBr4iucsMKQ9617sg3ftSJ6YWWMyslnpYyxav7eTtp38J+Yj6VHy0ivkxmo1CJBT1ZJxqUy2CGJ1xwztnFnp9soA=
Received: from DM5PR11MB1435.namprd11.prod.outlook.com (2603:10b6:4:7::18) by
 DM6PR11MB4530.namprd11.prod.outlook.com (2603:10b6:5:2a4::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3153.22; Wed, 8 Jul 2020 08:08:40 +0000
Received: from DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364]) by DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364%10]) with mapi id 15.20.3174.021; Wed, 8 Jul 2020
 08:08:40 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Auger Eric <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Wu, Hao" <hao.wu@intel.com>,
        "stefanha@gmail.com" <stefanha@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4 04/15] vfio/type1: Report iommu nesting info to
 userspace
Thread-Topic: [PATCH v4 04/15] vfio/type1: Report iommu nesting info to
 userspace
Thread-Index: AQHWUfUbywl8Q+WBl0+9l/PlGyuXiKj6XuYAgAAkWACAABBDgIABSlsAgAF6DCA=
Date:   Wed, 8 Jul 2020 08:08:40 +0000
Message-ID: <DM5PR11MB143531E2B54ED82FB0649F8CC3670@DM5PR11MB1435.namprd11.prod.outlook.com>
References: <1593861989-35920-1-git-send-email-yi.l.liu@intel.com>
 <1593861989-35920-5-git-send-email-yi.l.liu@intel.com>
 <d434cbcc-d3b1-d11d-0304-df2d2c93efa0@redhat.com>
 <DM5PR11MB1435290B6CD561EC61027892C3690@DM5PR11MB1435.namprd11.prod.outlook.com>
 <94b4e5d3-8d24-9a55-6bee-ed86f3846996@redhat.com>
 <DM5PR11MB14357A5953EB630A58FF568EC3660@DM5PR11MB1435.namprd11.prod.outlook.com>
In-Reply-To: <DM5PR11MB14357A5953EB630A58FF568EC3660@DM5PR11MB1435.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [117.169.230.114]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e54e2b05-dd4f-4980-2b5e-08d823161ffd
x-ms-traffictypediagnostic: DM6PR11MB4530:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB45308D374E10F3131D9271D8C3670@DM6PR11MB4530.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 04583CED1A
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jICB7Yt7OF4AoPe8jBNCHe5nWMCRPjg4zDP4LZgSz4IAK5VG0x6DDi6Up5oCCa7xbCZCWo031R8I45jn44zREMQwKCPXv++qeaeOGb2/61yeeXtX2KMpMaKCJx6KRl74+yWhnmGZNzjXym7W0Iw0peiFSnw9TH04HjIFwnrAcTCp3m6DTXQaxda3WlcNPLZQAWyJW8PlT+6iVW4MKiMI0MEsAnxM6w7/Q/XVU4Ru7Vv5Q16QTIxMy0OPLnI5bZb6x53aEK/1RIAcW9Opi9nDjiupPsrrhDTUf9wA9yNXlyym0Rh525UP6vYTZUvRvD/Fi5JoKEojtTkzsYwhrz/TIRTYIZ5nIM9qSJL4guudTVg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1435.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(376002)(136003)(346002)(366004)(54906003)(5660300002)(33656002)(71200400001)(478600001)(8676002)(966005)(8936002)(316002)(4326008)(110136005)(45080400002)(2906002)(64756008)(66946007)(76116006)(7416002)(52536014)(66556008)(66476007)(9686003)(66446008)(55016002)(26005)(186003)(7696005)(6506007)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: n5gIFVGpJXTrVpW7Z3F6R9qQkS0X69H0WLTATRaF5L6P4sGLQc4VjewVzx3rFF5/1yZX7+rYYRqLg3H2bStMf3L9jR6gysBOT1ZYPxRYCMD8HvkqKyiWkNOr2iNXmt/ESy1NSa9g/X3/AyocQUWYc3yn0NQcnbOgKRJaCFNwxiNK6RS8+/gmO2MboOXAP8ebAiN6fCjRGXu+fUn4Pmnm8dfd27SJdybERO8bW3LW8IWU3JTLvdlq8MIaLCFA/oWtnxgOlYYsVVfa/gGelKEnhWxC54pRwAKD52hkd64X+EVJABfM5BH/hM29RtSrChYiuAOR0284+f7FaNlcNBPQDdyuoJM+0lOxqQW8atQne2ShKfwSKtgKNLf+/MFfpxcK3/7BoaG/pIVupot+BH/DdEBYri0woZTv9Z/Y5fVZq95BqoL4CGlKfRSrUa+uHruiR1MNKaxFGT184tH0pkdME1a7ngMUdLdhwdD2dqjqDjMvsdGzcoJCyAkfTJGZ+YyO
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1435.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e54e2b05-dd4f-4980-2b5e-08d823161ffd
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2020 08:08:40.4473
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SzRW2T3KIwwXNxKeRj1mgOO3AjLBwAGqM4TNVqY+Pa9atRZMEms8VfEbmar1E3lfO6I/ear1FiuzGneu+GoZGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4530
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgQWxleCwNCg0KRXJpYyBhc2tlZCBpZiB3ZSB3aWxsIHRvIGhhdmUgZGF0YSBzdHJjdXQgb3Ro
ZXIgdGhhbiBzdHJ1Y3QgaW9tbXVfbmVzdGluZ19pbmZvDQp0eXBlIGluIHRoZSBzdHJ1Y3QgdmZp
b19pb21tdV90eXBlMV9pbmZvX2NhcF9uZXN0aW5nIEBpbmZvW10gZmllbGQuIEknbSBub3QNCnF1
aXQgc3VyZSBvbiBpdC4gSSBndWVzcyB0aGUgYW5zd2VyIG1heSBiZSBub3QgYXMgVkZJTydzIG5l
c3Rpbmcgc3VwcG9ydCBzaG91bGQNCmJhc2VkIG9uIElPTU1VIFVBUEkuIGhvdyBhYm91dCB5b3Vy
IG9waW5pb24/DQoNCisjZGVmaW5lIFZGSU9fSU9NTVVfVFlQRTFfSU5GT19DQVBfTkVTVElORyAg
Mw0KKw0KKy8qDQorICogUmVwb3J0aW5nIG5lc3RpbmcgaW5mbyB0byB1c2VyIHNwYWNlLg0KKyAq
DQorICogQGluZm86CXRoZSBuZXN0aW5nIGluZm8gcHJvdmlkZWQgYnkgSU9NTVUgZHJpdmVyLiBU
b2RheQ0KKyAqCQlpdCBpcyBleHBlY3RlZCB0byBiZSBhIHN0cnVjdCBpb21tdV9uZXN0aW5nX2lu
Zm8NCisgKgkJZGF0YS4NCisgKi8NCitzdHJ1Y3QgdmZpb19pb21tdV90eXBlMV9pbmZvX2NhcF9u
ZXN0aW5nIHsNCisJc3RydWN0CXZmaW9faW5mb19jYXBfaGVhZGVyIGhlYWRlcjsNCisJX191MzIJ
ZmxhZ3M7DQorCV9fdTMyCXBhZGRpbmc7DQorCV9fdTgJaW5mb1tdOw0KK307DQoNCmh0dHBzOi8v
bG9yZS5rZXJuZWwub3JnL2xpbnV4LWlvbW11L0RNNVBSMTFNQjE0MzUyOTBCNkNENTYxRUM2MTAy
Nzg5MkMzNjkwQERNNVBSMTFNQjE0MzUubmFtcHJkMTEucHJvZC5vdXRsb29rLmNvbS8NCg0KUmVn
YXJkcywNCllpIExpdQ0KDQo+IEZyb206IExpdSwgWWkgTA0KPiBTZW50OiBUdWVzZGF5LCBKdWx5
IDcsIDIwMjAgNTozMiBQTQ0KPiANClsuLi5dDQo+ID4gPg0KPiA+ID4+PiArDQo+ID4gPj4+ICsv
Kg0KPiA+ID4+PiArICogUmVwb3J0aW5nIG5lc3RpbmcgaW5mbyB0byB1c2VyIHNwYWNlLg0KPiA+
ID4+PiArICoNCj4gPiA+Pj4gKyAqIEBpbmZvOgl0aGUgbmVzdGluZyBpbmZvIHByb3ZpZGVkIGJ5
IElPTU1VIGRyaXZlci4gVG9kYXkNCj4gPiA+Pj4gKyAqCQlpdCBpcyBleHBlY3RlZCB0byBiZSBh
IHN0cnVjdCBpb21tdV9uZXN0aW5nX2luZm8NCj4gPiA+Pj4gKyAqCQlkYXRhLg0KPiA+ID4+IElz
IGl0IGV4cGVjdGVkIHRvIGNoYW5nZT8NCj4gPiA+DQo+ID4gPiBob25lc3RseSwgSSdtIG5vdCBx
dWl0ZSBzdXJlIG9uIGl0LiBJIGRpZCBjb25zaWRlcmVkIHRvIGVtYmVkIHN0cnVjdA0KPiA+ID4g
aW9tbXVfbmVzdGluZ19pbmZvIGhlcmUgaW5zdGVhZCBvZiB1c2luZyBpbmZvW10uIGJ1dCBJIGhl
c2l0YXRlZCBhcw0KPiA+ID4gdXNpbmcgaW5mb1tdIG1heSBsZWF2ZSBtb3JlIGZsZXhpYmlsaXR5
IG9uIHRoaXMgc3RydWN0LiBob3cgYWJvdXQNCj4gPiA+IHlvdXIgb3Bpbmlvbj8gcGVyaGFwcyBp
dCdzIGZpbmUgdG8gZW1iZWQgdGhlIHN0cnVjdA0KPiA+ID4gaW9tbXVfbmVzdGluZ19pbmZvIGhl
cmUgYXMgbG9uZyBhcyBWRklPIGlzIHNldHVwIG5lc3RpbmcgYmFzZWQgb24NCj4gPiA+IElPTU1V
IFVBUEkuDQo+ID4gPg0KPiA+ID4+PiArICovDQo+ID4gPj4+ICtzdHJ1Y3QgdmZpb19pb21tdV90
eXBlMV9pbmZvX2NhcF9uZXN0aW5nIHsNCj4gPiA+Pj4gKwlzdHJ1Y3QJdmZpb19pbmZvX2NhcF9o
ZWFkZXIgaGVhZGVyOw0KPiA+ID4+PiArCV9fdTMyCWZsYWdzOw0KPiA+ID4+IFlvdSBtYXkgZG9j
dW1lbnQgZmxhZ3MuDQo+ID4gPg0KPiA+ID4gc3VyZS4gaXQncyByZXNlcnZlZCBmb3IgZnV0dXJl
Lg0KPiA+ID4NCj4gPiA+IFJlZ2FyZHMsDQo+ID4gPiBZaSBMaXUNCj4gPiA+DQo+ID4gPj4+ICsJ
X191MzIJcGFkZGluZzsNCj4gPiA+Pj4gKwlfX3U4CWluZm9bXTsNCj4gPiA+Pj4gK307DQo+ID4g
Pj4+ICsNCj4gPiA+Pj4gICNkZWZpbmUgVkZJT19JT01NVV9HRVRfSU5GTyBfSU8oVkZJT19UWVBF
LCBWRklPX0JBU0UgKyAxMikNCj4gPiA+Pj4NCj4gPiA+Pj4gIC8qKg0KPiA+ID4+Pg0KPiA+ID4+
IFRoYW5rcw0KPiA+ID4+DQo+ID4gPj4gRXJpYw0KPiA+ID4NCg0K
