Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E732822586B
	for <lists+kvm@lfdr.de>; Mon, 20 Jul 2020 09:26:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbgGTH0P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jul 2020 03:26:15 -0400
Received: from mga18.intel.com ([134.134.136.126]:29144 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725815AbgGTH0O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jul 2020 03:26:14 -0400
IronPort-SDR: XaiJswa3EvezM8qTtULO/Mi9fVaEqOeE6z0paBBNLn5UGvgJrue5Bv8HiIW0lukies7bRh0/p3
 wO+3yphe+Qww==
X-IronPort-AV: E=McAfee;i="6000,8403,9687"; a="137349150"
X-IronPort-AV: E=Sophos;i="5.75,374,1589266800"; 
   d="scan'208";a="137349150"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2020 00:26:13 -0700
IronPort-SDR: gGJGoEet6hHRDf439fPoMRRwb9wYMJrfHeOJR2TmvVCFY57lv07xTJ6BMhN+/kmNuKJzJ2nCuQ
 Ka2w2G3kxjBg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,374,1589266800"; 
   d="scan'208";a="319439673"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga002.fm.intel.com with ESMTP; 20 Jul 2020 00:26:13 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 20 Jul 2020 00:26:13 -0700
Received: from FMSEDG001.ED.cps.intel.com (10.1.192.133) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 20 Jul 2020 00:26:13 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (104.47.46.51) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Mon, 20 Jul 2020 00:26:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bGsx8lUyKPTVP1+ALGXXK/Dc3GePR/1UtjY0rpq5uCBjB63zDmKzFtOPNeFmHeLe9RQowV2NJOVIS7AazmaUsddyGtVyTUSQF1CxT0jidiJ4yWcwKC6+h3pXNrA+jGHE88p2cLNdmUD0ub+6I6nFzoT0R2LFJ8E2DGLkTpRrSyjrT/EDY0QcwtbimxvsdtRUEHZqEdEt7V1CnUIQEHnNJz1L43Ufn0u6Kp29jFRB0e2EpQ6pbE7zpQYDdSu97MtCHmMCpK0NPnPE98V7ztoM/bA7R3SHcLENuG5vdbt9DS7m8KbOwQi+PpK9UYreGVuy6c2oKMp7TMs2VzMp5nmfHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qy/sMhRYB+WN7aAeagfUO4zW6pX7UdFKCrkSmrSUd78=;
 b=H64+2Ti/mJ+IQASO0dgrqPfpZTH1e0h504aZFwrfPJUpyW89IKAAh8bMeiskozO4wlk86j6lVMFXAhIteKk/STWENt9/AvN1DknM8yE1EVCrYbvg4Hj+bM6h05GkfLhrbVXz76aSzR7NoT6GcKDlWqnF9L46SOZ8HWjGoRIUNI0RWp7w33sLa/NYL2X0tyuHoO1JMXyhsYjgEXFXZlt8v8GQx0glF/ejPgbeyaydjb5tbJTAPO7bZ249PcSCX168BdNd/A7bT40kqlCrabIf78lFDQxtbiBJp5VGIeh5T/akfctbhWkDCzKOycfQWX6X+kMWDTcK2srDjwhxSGLU8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qy/sMhRYB+WN7aAeagfUO4zW6pX7UdFKCrkSmrSUd78=;
 b=bvH607wXDYquHXKjjaxkp4BvsuxLd7czIu4UWpponHSiKpJWGBPSETt3hkxIYzfMANgKfGS20v7K8GLN++dC4q/j/Tcf7fmnPgdItvLzxVtDPB9n3H1NvIbo2i3avonpAoYMl4Fzd215TY/Es2tTVwm23GbXALhJU//JFFKklFQ=
Received: from DM5PR11MB1435.namprd11.prod.outlook.com (2603:10b6:4:7::18) by
 DM6PR11MB4722.namprd11.prod.outlook.com (2603:10b6:5:2a7::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3195.23; Mon, 20 Jul 2020 07:26:05 +0000
Received: from DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364]) by DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364%10]) with mapi id 15.20.3195.025; Mon, 20 Jul
 2020 07:26:05 +0000
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
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>
Subject: RE: [PATCH v5 03/15] iommu/smmu: Report empty domain nesting info
Thread-Topic: [PATCH v5 03/15] iommu/smmu: Report empty domain nesting info
Thread-Index: AQHWWD2lVc+q/avNRU2WMQZyTvsTFakMDAeAgAQRYnA=
Date:   Mon, 20 Jul 2020 07:26:05 +0000
Message-ID: <DM5PR11MB143577DE3526B1BA09A99326C37B0@DM5PR11MB1435.namprd11.prod.outlook.com>
References: <1594552870-55687-1-git-send-email-yi.l.liu@intel.com>
 <1594552870-55687-4-git-send-email-yi.l.liu@intel.com>
 <5ee6b661-9c46-20ee-332a-1a449b6f3a43@redhat.com>
In-Reply-To: <5ee6b661-9c46-20ee-332a-1a449b6f3a43@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.200]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bb7192c7-53a5-4cc1-9b8e-08d82c7e2a3e
x-ms-traffictypediagnostic: DM6PR11MB4722:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB4722608E062C33321315D6F0C37B0@DM6PR11MB4722.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:660;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WzmFWBCwYRGKjJ5/+pOwLdac9TRPBWqGI3wht+JLN40hjHIv2q67jE+ThmwHFJ3Nia/3aYQxs+/JG2qXVc8bfJzPqdsmMV0ZGjz0MUwkk96etBv2j1xuj5LYsdZ8gkkfmd13DBX1wRn8gqh+HPSVcAbytHNsbe4m847wZVr/fnwrBOEaRbWB2SxLVYdNnziGIPkB1k7h29jSklBBttKyivqgrpjEaMbqqYfUZGOQSRA1be5ABaznLIx4vM3/Ei0FK3CU67uWs3NenMMuAhuAUB/NUsAcJk4YmSpdRhTXlK8jduoaVy+mt53IqvR+UejXXx5dEq9ZM+2KXPvzjR/qRg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1435.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(366004)(136003)(396003)(376002)(39860400002)(6506007)(53546011)(52536014)(26005)(33656002)(186003)(5660300002)(4326008)(316002)(478600001)(54906003)(110136005)(71200400001)(9686003)(2906002)(86362001)(55016002)(66446008)(64756008)(66476007)(76116006)(66946007)(66556008)(7696005)(8676002)(83380400001)(8936002)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 9thVEy+/jwHsQKPagTzxEfEsIqP3RMLwZ2aLafGliQrqNTXVLSqffszLNGDjLQeb1dZ1RyHozPV5P9L/e7zSaCzZ1/NK+yCB490ZwEyXK+oamcHnbGM2Sg82dCmfyaNZrZ9zlzFGU8v25JfJqklbaUa6T5ZovxvhBhhrAz2/d3FmYvdD4+HJ/mmmXKLZmJt/a0dtYUUhH3hKIvvITeV8OKtsxfhyL8TiZr7X6vzj+ykCfukIJGsYiz/uEiHK0UpVKk+fqebExCWucsGuXOEG/tZBbZjnt8GT/ntQvbxqABRIggtZH77bZkEvVFmLzd1oalGkYeJtTJfVxRSm8c2Z7ntPw+Vy1Vd2jpc4V3mPKZX+Fr40QblOBWwLJZZPmj7suiH7Z6iCtBHCI1RocGDiBrLdZx5XFPNrMStXIPygqsnpB3pO/gnLotM41zY002nYTACMk/mDBkf1q5pkqae7He4Lb+2zog7/MKKrqKqCpqo9DVN4LXv5UFq4vqnSwDYe
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1435.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb7192c7-53a5-4cc1-9b8e-08d82c7e2a3e
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jul 2020 07:26:05.7863
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ImGzk2KuGEzoVr6DtDa5W5cROKJjb5uvtkhKnmAN87hXjuATjSErMHWznOLvKCSauWuLkCgx+MP+ywrR3zM3Nw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4722
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgRXJpYywNCg0KPiBGcm9tOiBBdWdlciBFcmljIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+
IA0KPiBZaSwNCj4gDQo+IE9uIDcvMTIvMjAgMToyMCBQTSwgTGl1IFlpIEwgd3JvdGU6DQo+ID4g
VGhpcyBwYXRjaCBpcyBhZGRlZCBhcyBpbnN0ZWFkIG9mIHJldHVybmluZyBhIGJvb2xlYW4gZm9y
DQo+ID4gRE9NQUlOX0FUVFJfTkVTVElORywNCj4gPiBpb21tdV9kb21haW5fZ2V0X2F0dHIoKSBz
aG91bGQgcmV0dXJuIGFuIGlvbW11X25lc3RpbmdfaW5mbyBoYW5kbGUuDQo+IA0KPiB5b3UgbWF5
IGFkZCBpbiB0aGUgY29tbWl0IG1lc3NhZ2UgeW91IHJldHVybiBhbiBlbXB0eSBuZXN0aW5nIGlu
Zm8gc3RydWN0IGZvciBub3cNCj4gYXMgdHJ1ZSBuZXN0aW5nIGlzIG5vdCB5ZXQgc3VwcG9ydGVk
IGJ5IHRoZSBTTU1Vcy4NCg0Kd2lsbCBkby4NCg0KPiBCZXNpZGVzOg0KPiBSZXZpZXdlZC1ieTog
RXJpYyBBdWdlciA8ZXJpYy5hdWdlckByZWRoYXQuY29tPg0KDQp0aGFua3MuDQoNClJlZ2FyZHMs
DQpZaSBMaXUNCg0KPiBUaGFua3MNCj4gDQo+IEVyaWMNCj4gPg0KPiA+IENjOiBXaWxsIERlYWNv
biA8d2lsbEBrZXJuZWwub3JnPg0KPiA+IENjOiBSb2JpbiBNdXJwaHkgPHJvYmluLm11cnBoeUBh
cm0uY29tPg0KPiA+IENjOiBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+ID4g
Q2M6IEplYW4tUGhpbGlwcGUgQnJ1Y2tlciA8amVhbi1waGlsaXBwZUBsaW5hcm8ub3JnPg0KPiA+
IFN1Z2dlc3RlZC1ieTogSmVhbi1QaGlsaXBwZSBCcnVja2VyIDxqZWFuLXBoaWxpcHBlQGxpbmFy
by5vcmc+DQo+ID4gU2lnbmVkLW9mZi1ieTogTGl1IFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4N
Cj4gPiBTaWduZWQtb2ZmLWJ5OiBKYWNvYiBQYW4gPGphY29iLmp1bi5wYW5AbGludXguaW50ZWwu
Y29tPg0KPiA+IC0tLQ0KPiA+IHY0IC0+IHY1Og0KPiA+ICopIGFkZHJlc3MgY29tbWVudHMgZnJv
bSBFcmljIEF1Z2VyLg0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJzL2lvbW11L2FybS1zbW11LXYzLmMg
fCAyOSArKysrKysrKysrKysrKysrKysrKysrKysrKystLQ0KPiA+ICBkcml2ZXJzL2lvbW11L2Fy
bS1zbW11LmMgICAgfCAyOSArKysrKysrKysrKysrKysrKysrKysrKysrKystLQ0KPiA+ICAyIGZp
bGVzIGNoYW5nZWQsIDU0IGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pDQo+ID4NCj4gPiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy9pb21tdS9hcm0tc21tdS12My5jIGIvZHJpdmVycy9pb21tdS9h
cm0tc21tdS12My5jDQo+ID4gaW5kZXggZjU3ODY3Ny4uZWM4MTVkNyAxMDA2NDQNCj4gPiAtLS0g
YS9kcml2ZXJzL2lvbW11L2FybS1zbW11LXYzLmMNCj4gPiArKysgYi9kcml2ZXJzL2lvbW11L2Fy
bS1zbW11LXYzLmMNCj4gPiBAQCAtMzAxOSw2ICszMDE5LDMyIEBAIHN0YXRpYyBzdHJ1Y3QgaW9t
bXVfZ3JvdXANCj4gKmFybV9zbW11X2RldmljZV9ncm91cChzdHJ1Y3QgZGV2aWNlICpkZXYpDQo+
ID4gIAlyZXR1cm4gZ3JvdXA7DQo+ID4gIH0NCj4gPg0KPiA+ICtzdGF0aWMgaW50IGFybV9zbW11
X2RvbWFpbl9uZXN0aW5nX2luZm8oc3RydWN0IGFybV9zbW11X2RvbWFpbg0KPiAqc21tdV9kb21h
aW4sDQo+ID4gKwkJCQkJdm9pZCAqZGF0YSkNCj4gPiArew0KPiA+ICsJc3RydWN0IGlvbW11X25l
c3RpbmdfaW5mbyAqaW5mbyA9IChzdHJ1Y3QgaW9tbXVfbmVzdGluZ19pbmZvICopZGF0YTsNCj4g
PiArCXVuc2lnbmVkIGludCBzaXplOw0KPiA+ICsNCj4gPiArCWlmICghaW5mbyB8fCBzbW11X2Rv
bWFpbi0+c3RhZ2UgIT0gQVJNX1NNTVVfRE9NQUlOX05FU1RFRCkNCj4gPiArCQlyZXR1cm4gLUVO
T0RFVjsNCj4gPiArDQo+ID4gKwlzaXplID0gc2l6ZW9mKHN0cnVjdCBpb21tdV9uZXN0aW5nX2lu
Zm8pOw0KPiA+ICsNCj4gPiArCS8qDQo+ID4gKwkgKiBpZiBwcm92aWRlZCBidWZmZXIgc2l6ZSBp
cyBzbWFsbGVyIHRoYW4gZXhwZWN0ZWQsIHNob3VsZA0KPiA+ICsJICogcmV0dXJuIDAgYW5kIGFs
c28gdGhlIGV4cGVjdGVkIGJ1ZmZlciBzaXplIHRvIGNhbGxlci4NCj4gPiArCSAqLw0KPiA+ICsJ
aWYgKGluZm8tPnNpemUgPCBzaXplKSB7DQo+ID4gKwkJaW5mby0+c2l6ZSA9IHNpemU7DQo+ID4g
KwkJcmV0dXJuIDA7DQo+ID4gKwl9DQo+ID4gKw0KPiA+ICsJLyogcmVwb3J0IGFuIGVtcHR5IGlv
bW11X25lc3RpbmdfaW5mbyBmb3Igbm93ICovDQo+ID4gKwltZW1zZXQoaW5mbywgMHgwLCBzaXpl
KTsNCj4gPiArCWluZm8tPnNpemUgPSBzaXplOw0KPiA+ICsJcmV0dXJuIDA7DQo+ID4gK30NCj4g
PiArDQo+ID4gIHN0YXRpYyBpbnQgYXJtX3NtbXVfZG9tYWluX2dldF9hdHRyKHN0cnVjdCBpb21t
dV9kb21haW4gKmRvbWFpbiwNCj4gPiAgCQkJCSAgICBlbnVtIGlvbW11X2F0dHIgYXR0ciwgdm9p
ZCAqZGF0YSkgIHsgQEAgLQ0KPiAzMDI4LDggKzMwNTQsNyBAQA0KPiA+IHN0YXRpYyBpbnQgYXJt
X3NtbXVfZG9tYWluX2dldF9hdHRyKHN0cnVjdCBpb21tdV9kb21haW4gKmRvbWFpbiwNCj4gPiAg
CWNhc2UgSU9NTVVfRE9NQUlOX1VOTUFOQUdFRDoNCj4gPiAgCQlzd2l0Y2ggKGF0dHIpIHsNCj4g
PiAgCQljYXNlIERPTUFJTl9BVFRSX05FU1RJTkc6DQo+ID4gLQkJCSooaW50ICopZGF0YSA9IChz
bW11X2RvbWFpbi0+c3RhZ2UgPT0NCj4gQVJNX1NNTVVfRE9NQUlOX05FU1RFRCk7DQo+ID4gLQkJ
CXJldHVybiAwOw0KPiA+ICsJCQlyZXR1cm4gYXJtX3NtbXVfZG9tYWluX25lc3RpbmdfaW5mbyhz
bW11X2RvbWFpbiwNCj4gZGF0YSk7DQo+ID4gIAkJZGVmYXVsdDoNCj4gPiAgCQkJcmV0dXJuIC1F
Tk9ERVY7DQo+ID4gIAkJfQ0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2lvbW11L2FybS1zbW11
LmMgYi9kcml2ZXJzL2lvbW11L2FybS1zbW11LmMgaW5kZXgNCj4gPiAyNDNiYzRjLi4wOWUyZjFi
IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvaW9tbXUvYXJtLXNtbXUuYw0KPiA+ICsrKyBiL2Ry
aXZlcnMvaW9tbXUvYXJtLXNtbXUuYw0KPiA+IEBAIC0xNTA2LDYgKzE1MDYsMzIgQEAgc3RhdGlj
IHN0cnVjdCBpb21tdV9ncm91cA0KPiAqYXJtX3NtbXVfZGV2aWNlX2dyb3VwKHN0cnVjdCBkZXZp
Y2UgKmRldikNCj4gPiAgCXJldHVybiBncm91cDsNCj4gPiAgfQ0KPiA+DQo+ID4gK3N0YXRpYyBp
bnQgYXJtX3NtbXVfZG9tYWluX25lc3RpbmdfaW5mbyhzdHJ1Y3QgYXJtX3NtbXVfZG9tYWluDQo+
ICpzbW11X2RvbWFpbiwNCj4gPiArCQkJCQl2b2lkICpkYXRhKQ0KPiA+ICt7DQo+ID4gKwlzdHJ1
Y3QgaW9tbXVfbmVzdGluZ19pbmZvICppbmZvID0gKHN0cnVjdCBpb21tdV9uZXN0aW5nX2luZm8g
KilkYXRhOw0KPiA+ICsJdW5zaWduZWQgaW50IHNpemU7DQo+ID4gKw0KPiA+ICsJaWYgKCFpbmZv
IHx8IHNtbXVfZG9tYWluLT5zdGFnZSAhPSBBUk1fU01NVV9ET01BSU5fTkVTVEVEKQ0KPiA+ICsJ
CXJldHVybiAtRU5PREVWOw0KPiA+ICsNCj4gPiArCXNpemUgPSBzaXplb2Yoc3RydWN0IGlvbW11
X25lc3RpbmdfaW5mbyk7DQo+ID4gKw0KPiA+ICsJLyoNCj4gPiArCSAqIGlmIHByb3ZpZGVkIGJ1
ZmZlciBzaXplIGlzIHNtYWxsZXIgdGhhbiBleHBlY3RlZCwgc2hvdWxkDQo+ID4gKwkgKiByZXR1
cm4gMCBhbmQgYWxzbyB0aGUgZXhwZWN0ZWQgYnVmZmVyIHNpemUgdG8gY2FsbGVyLg0KPiA+ICsJ
ICovDQo+ID4gKwlpZiAoaW5mby0+c2l6ZSA8IHNpemUpIHsNCj4gPiArCQlpbmZvLT5zaXplID0g
c2l6ZTsNCj4gPiArCQlyZXR1cm4gMDsNCj4gPiArCX0NCj4gPiArDQo+ID4gKwkvKiByZXBvcnQg
YW4gZW1wdHkgaW9tbXVfbmVzdGluZ19pbmZvIGZvciBub3cgKi8NCj4gPiArCW1lbXNldChpbmZv
LCAweDAsIHNpemUpOw0KPiA+ICsJaW5mby0+c2l6ZSA9IHNpemU7DQo+ID4gKwlyZXR1cm4gMDsN
Cj4gPiArfQ0KPiA+ICsNCj4gPiAgc3RhdGljIGludCBhcm1fc21tdV9kb21haW5fZ2V0X2F0dHIo
c3RydWN0IGlvbW11X2RvbWFpbiAqZG9tYWluLA0KPiA+ICAJCQkJICAgIGVudW0gaW9tbXVfYXR0
ciBhdHRyLCB2b2lkICpkYXRhKSAgeyBAQCAtDQo+IDE1MTUsOCArMTU0MSw3IEBADQo+ID4gc3Rh
dGljIGludCBhcm1fc21tdV9kb21haW5fZ2V0X2F0dHIoc3RydWN0IGlvbW11X2RvbWFpbiAqZG9t
YWluLA0KPiA+ICAJY2FzZSBJT01NVV9ET01BSU5fVU5NQU5BR0VEOg0KPiA+ICAJCXN3aXRjaCAo
YXR0cikgew0KPiA+ICAJCWNhc2UgRE9NQUlOX0FUVFJfTkVTVElORzoNCj4gPiAtCQkJKihpbnQg
KilkYXRhID0gKHNtbXVfZG9tYWluLT5zdGFnZSA9PQ0KPiBBUk1fU01NVV9ET01BSU5fTkVTVEVE
KTsNCj4gPiAtCQkJcmV0dXJuIDA7DQo+ID4gKwkJCXJldHVybiBhcm1fc21tdV9kb21haW5fbmVz
dGluZ19pbmZvKHNtbXVfZG9tYWluLA0KPiBkYXRhKTsNCj4gPiAgCQlkZWZhdWx0Og0KPiA+ICAJ
CQlyZXR1cm4gLUVOT0RFVjsNCj4gPiAgCQl9DQo+ID4NCg0K
