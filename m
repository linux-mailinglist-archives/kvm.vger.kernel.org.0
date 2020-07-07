Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51A4E216934
	for <lists+kvm@lfdr.de>; Tue,  7 Jul 2020 11:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727936AbgGGJho (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jul 2020 05:37:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:59281 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725825AbgGGJhn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jul 2020 05:37:43 -0400
IronPort-SDR: 4313BGGihjR/aJKCWXiVs1d/ZpOjksmBmEkMUZYOK2dGdeBjPKz1QANuQCrYWe4P3UNPXXpJqg
 kkeWzDMGG+AQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9674"; a="135808682"
X-IronPort-AV: E=Sophos;i="5.75,323,1589266800"; 
   d="scan'208";a="135808682"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2020 02:37:41 -0700
IronPort-SDR: ZYv/SNMrbfKvY0Jn6oyI/pCcD69B27/gRJ3Sq7lCPe7vg/MG74SxjrBf1bmnhx//p7SPXe0Ctu
 IJIAyt4SO+ZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,323,1589266800"; 
   d="scan'208";a="305600781"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga004.fm.intel.com with ESMTP; 07 Jul 2020 02:37:39 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 7 Jul 2020 02:37:37 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 7 Jul 2020 02:37:37 -0700
Received: from ORSEDG001.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 7 Jul 2020 02:37:37 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (104.47.38.52) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Tue, 7 Jul 2020 02:37:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZQjp9B1uLn2TwGmFdwFKVo0PxLTbC8U7pUStl8JWJ2ZJAuVKcUwIsS1bVA3WNCzG4Z0ImTM9GsR8GTbXEwBbGq82GlZDO8oVgrEQ4/yGLSWIggg/DLFilYwGcHnbG2r7LANyzyjdfv8jTdJHY0T00fegwWJ8oDsvRYjwIWP2h86OZRfi+8y1nwOD7kBeUSZGuvXE0quliPA3HmFCJeZB2cqwd+93HR1PqcbmDjtcT6sDQpamkJkIwXZs/twJW8a2MoEMRF/BCqVUru8OVjYNESCK3J69CB+h87cc2OVo2T4ZQL8HsoQ1bgVDYzEyp/ONMPFY9JAac3BSqHOXfMDzkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iuzY5aLq0Lr8Z+ioYE3u2gdJvrPWPFeDdM3zAI6rmZg=;
 b=N0QhmhL2bkxWfJR1W9znpvY0aU5wUHwusESOeI36uNaPCZ/nozEqLvCWHCn8mm3AAE/XCfIfoy8HukNvLqsm322uasCpxVwKrgp46AdvtVMOZpBB8FQAVOBuu1TvflH2BxFvhjt0ckWqBagSDg7Pcs5JbDg5DLOWWgKYpbiA8dDq4rhc8n+UwADhUPiZ2sYG4csRQeC3hsnXLR1VPAvjwh41ow7KMsXq6rV1WkltFS1qExDy8i/jwaAR59NRdrR47/lhKqq8pfFz2i2fEyTBcdAyaEf0Emrx0WG93zrOWRiKQbHBiL80a7hCqfG6wDSpv2QOwBtmEmoan7yeNroSHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iuzY5aLq0Lr8Z+ioYE3u2gdJvrPWPFeDdM3zAI6rmZg=;
 b=QfI53lbETs/tNT5UXN73E4jvJAsgIE6ABSR1aaLCABr+PF9utAJ6zGmKbK0D8M8DOBzqzpuamLsoPhlGuNevjqsHVfEnAtSftSWyKrTdhChCndjl+ejPsdLoD2DZyNCNXY9yaEIvCKHKkKTlHF7Y+Wgfvv1S2KHJE2b/YnwCHnI=
Received: from DM5PR11MB1435.namprd11.prod.outlook.com (2603:10b6:4:7::18) by
 DM6PR11MB3068.namprd11.prod.outlook.com (2603:10b6:5:6b::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3153.21; Tue, 7 Jul 2020 09:37:35 +0000
Received: from DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364]) by DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364%10]) with mapi id 15.20.3153.029; Tue, 7 Jul 2020
 09:37:35 +0000
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
Subject: RE: [PATCH v4 06/15] iommu/vt-d: Support setting ioasid set to domain
Thread-Topic: [PATCH v4 06/15] iommu/vt-d: Support setting ioasid set to
 domain
Thread-Index: AQHWUfUYO2lBnvRuAEuteXmbkCY+m6j6picAgAE6LVA=
Date:   Tue, 7 Jul 2020 09:37:35 +0000
Message-ID: <DM5PR11MB14353BF4E197D947CFF720BAC3660@DM5PR11MB1435.namprd11.prod.outlook.com>
References: <1593861989-35920-1-git-send-email-yi.l.liu@intel.com>
 <1593861989-35920-7-git-send-email-yi.l.liu@intel.com>
 <d47367ab-f986-4c09-2578-3e364aa57835@redhat.com>
In-Reply-To: <d47367ab-f986-4c09-2578-3e364aa57835@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.214]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 468e22d8-df4d-4e63-8e78-08d822596155
x-ms-traffictypediagnostic: DM6PR11MB3068:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB30689DFBB6AE506BD2A43C1DC3660@DM6PR11MB3068.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0457F11EAF
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: p8U9fEye7imZOx6PTYTfuPvne5qYYIROdw/qeDApf31d+LK2c5+J04CnnolZ5mbPQU9PwyFf7SvG6nVeEjsQHhGdqGauD0m0omWw4817YCqQI85gWfLCq61TVcKyCJUjVLfbDXd6+KSJ2ITA3RLW1Moer3eCKVB/LfAT+uyp+PM3tQpSi0xwOSuKKllhbB1mktLuwk+wM/x74AadfCXtycQh3NXKB7Jz6ff2LrH/6YG+o+hPRXzZv+hiDmZ8bJbvUZCYVbYj4MIgwU7Xzhix9OMNctFCqVDjfOSgv7nc+BC8dMr0WEyl+udEQz6YOpO3T35MHeDfpsDK5aFXWFK2Bw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1435.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(346002)(376002)(366004)(396003)(136003)(66446008)(5660300002)(186003)(66476007)(110136005)(55016002)(9686003)(316002)(33656002)(54906003)(8936002)(66556008)(86362001)(64756008)(26005)(2906002)(66946007)(71200400001)(76116006)(8676002)(52536014)(478600001)(53546011)(83380400001)(6506007)(7696005)(4326008)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: VKIcd/NGO665LBP+b1Js6ucdJ8nMsCUzWpZ+Qhb2GMWZGT3Ssr70G8DNABjrhYQw93yj+ihNVwGvFDYVPQGWm8icMkuG95OdcV/2EETpipOaQvP4HsrAw4aGYKkVe/jf/gM/cbqXQTYwNN/B+cVH/hA2hqYk7p4dDrtpSpOnpt4GkOL67SqZ9FVdDaYzVvrE20GWafhzZU2n5fgPbbAZwSapV+bHOe2I0+fFnp3Ob1o4yBOQEVCKNdao8NG7EEqLHNNSSlHlychrbuOgKV579ZyKeMcKxRWyWYrpe7kuz7rfG0QA4cdLpmCMy3I1s7AK1bR6xfQy5asXIhDbJZy9J04N6jDv/B7U/99UJC9Tqdct3UAy/P0d1zV/4SKgE7FY8Bgc6qYJy0gVKZpoMJMK48gC+zJzZMr3V0s24bmQCGEz8O/As6oM0VZCVsg4GIQUTjZFbE/clUfSgdQIk3P7zYO+lY+XkT+tWOzXgdGMmeJlJgDl/7ZhQ0RaEQ9PXOyd
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1435.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 468e22d8-df4d-4e63-8e78-08d822596155
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jul 2020 09:37:35.1126
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: llJ3NBjt1MHNy8N7o7HXK0QYnfcFQDa44v54Dqcu0At56kFoob9BPTY3UcRwTh4I741Ze7Fc/mvVrFjt4Fwvww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3068
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgRXJpYywNCg0KPiBGcm9tOiBBdWdlciBFcmljIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+
IFNlbnQ6IE1vbmRheSwgSnVseSA2LCAyMDIwIDEwOjUyIFBNDQo+IA0KPiBIaSBZaSwNCj4gDQo+
IE9uIDcvNC8yMCAxOjI2IFBNLCBMaXUgWWkgTCB3cm90ZToNCj4gPiBGcm9tIElPTU1VIHAuby52
LiwgUEFTSURzIGFsbG9jYXRlZCBhbmQgbWFuYWdlZCBieSBleHRlcm5hbCBjb21wb25lbnRzDQo+
ID4gKGUuZy4gVkZJTykgd2lsbCBiZSBwYXNzZWQgaW4gZm9yIGdwYXNpZF9iaW5kL3VuYmluZCBv
cGVyYXRpb24uIElPTU1VDQo+ID4gbmVlZHMgc29tZSBrbm93bGVkZ2UgdG8gY2hlY2sgdGhlIFBB
U0lEIG93bmVyc2hpcCwgaGVuY2UgYWRkIGFuIGludGVyZmFjZQ0KPiA+IGZvciB0aG9zZSBjb21w
b25lbnRzIHRvIHRlbGwgdGhlIFBBU0lEIG93bmVyLg0KPiA+DQo+ID4gSW4gbGF0ZXN0IGtlcm5l
bCBkZXNpZ24sIFBBU0lEIG93bmVyc2hpcCBpcyBtYW5hZ2VkIGJ5IElPQVNJRCBzZXQgd2hlcmUN
Cj4gPiB0aGUgUEFTSUQgaXMgYWxsb2NhdGVkIGZyb20uIFRoaXMgcGF0Y2ggYWRkcyBzdXBwb3J0
IGZvciBzZXR0aW5nIGlvYXNpZA0KPiA+IHNldCBJRCB0byB0aGUgZG9tYWlucyB1c2VkIGZvciBu
ZXN0aW5nL3ZTVkEuIFN1YnNlcXVlbnQgU1ZBIG9wZXJhdGlvbnMNCj4gPiBvbiB0aGUgUEFTSUQg
d2lsbCBiZSBjaGVja2VkIGFnYWluc3QgaXRzIElPQVNJRCBzZXQgZm9yIHByb3BlciBvd25lcnNo
aXAuDQo+ID4NCj4gPiBDYzogS2V2aW4gVGlhbiA8a2V2aW4udGlhbkBpbnRlbC5jb20+DQo+ID4g
Q0M6IEphY29iIFBhbiA8amFjb2IuanVuLnBhbkBsaW51eC5pbnRlbC5jb20+DQo+ID4gQ2M6IEFs
ZXggV2lsbGlhbXNvbiA8YWxleC53aWxsaWFtc29uQHJlZGhhdC5jb20+DQo+ID4gQ2M6IEVyaWMg
QXVnZXIgPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT4NCj4gPiBDYzogSmVhbi1QaGlsaXBwZSBCcnVj
a2VyIDxqZWFuLXBoaWxpcHBlQGxpbmFyby5vcmc+DQo+ID4gQ2M6IEpvZXJnIFJvZWRlbCA8am9y
b0A4Ynl0ZXMub3JnPg0KPiA+IENjOiBMdSBCYW9sdSA8YmFvbHUubHVAbGludXguaW50ZWwuY29t
Pg0KPiA+IFNpZ25lZC1vZmYtYnk6IExpdSBZaSBMIDx5aS5sLmxpdUBpbnRlbC5jb20+DQo+ID4g
U2lnbmVkLW9mZi1ieTogSmFjb2IgUGFuIDxqYWNvYi5qdW4ucGFuQGxpbnV4LmludGVsLmNvbT4N
Cj4gPiAtLS0NCj4gPiAgZHJpdmVycy9pb21tdS9pbnRlbC9pb21tdS5jIHwgMTYgKysrKysrKysr
KysrKysrKw0KPiA+ICBpbmNsdWRlL2xpbnV4L2ludGVsLWlvbW11LmggfCAgNCArKysrDQo+ID4g
IGluY2x1ZGUvbGludXgvaW9tbXUuaCAgICAgICB8ICAxICsNCj4gPiAgMyBmaWxlcyBjaGFuZ2Vk
LCAyMSBpbnNlcnRpb25zKCspDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9pb21tdS9p
bnRlbC9pb21tdS5jIGIvZHJpdmVycy9pb21tdS9pbnRlbC9pb21tdS5jDQo+ID4gaW5kZXggNjJl
YmUwMS4uODlkNzA4ZCAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL2lvbW11L2ludGVsL2lvbW11
LmMNCj4gPiArKysgYi9kcml2ZXJzL2lvbW11L2ludGVsL2lvbW11LmMNCj4gPiBAQCAtMTc5Myw2
ICsxNzkzLDcgQEAgc3RhdGljIHN0cnVjdCBkbWFyX2RvbWFpbiAqYWxsb2NfZG9tYWluKGludCBm
bGFncykNCj4gPiAgCWlmIChmaXJzdF9sZXZlbF9ieV9kZWZhdWx0KCkpDQo+ID4gIAkJZG9tYWlu
LT5mbGFncyB8PSBET01BSU5fRkxBR19VU0VfRklSU1RfTEVWRUw7DQo+ID4gIAlkb21haW4tPmhh
c19pb3RsYl9kZXZpY2UgPSBmYWxzZTsNCj4gPiArCWRvbWFpbi0+aW9hc2lkX3NpZCA9IElOVkFM
SURfSU9BU0lEX1NFVDsNCj4gPiAgCUlOSVRfTElTVF9IRUFEKCZkb21haW4tPmRldmljZXMpOw0K
PiA+DQo+ID4gIAlyZXR1cm4gZG9tYWluOw0KPiA+IEBAIC02MDM5LDYgKzYwNDAsMjEgQEAgaW50
ZWxfaW9tbXVfZG9tYWluX3NldF9hdHRyKHN0cnVjdCBpb21tdV9kb21haW4NCj4gKmRvbWFpbiwN
Cj4gPiAgCQl9DQo+ID4gIAkJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmZGV2aWNlX2RvbWFpbl9s
b2NrLCBmbGFncyk7DQo+ID4gIAkJYnJlYWs7DQo+ID4gKwljYXNlIERPTUFJTl9BVFRSX0lPQVNJ
RF9TSUQ6DQo+IG5vIG5lZWQgdG8gdGFrZSB0aGUgZGV2aWNlX2RvbWFpbl9sb2NrPw0KDQpvaCwg
eWVzLiB0aGFua3MgZm9yIHNwb3R0aW5nIGl0Lg0KDQo+ID4gKwkJaWYgKCEoZG1hcl9kb21haW4t
PmZsYWdzICYgRE9NQUlOX0ZMQUdfTkVTVElOR19NT0RFKSkgew0KPiA+ICsJCQlyZXQgPSAtRU5P
REVWOw0KPiA+ICsJCQlicmVhazsNCj4gPiArCQl9DQo+ID4gKwkJaWYgKChkbWFyX2RvbWFpbi0+
aW9hc2lkX3NpZCAhPSBJTlZBTElEX0lPQVNJRF9TRVQpICYmDQo+ID4gKwkJICAgIChkbWFyX2Rv
bWFpbi0+aW9hc2lkX3NpZCAhPSAoKihpbnQgKikgZGF0YSkpKSB7DQo+IHN0b3JpbmcgKihpbnQg
KikgZGF0YSkgaW4gYSBsb2NhbCB2YXJpYWJsZSB3b3VsZCBpbmNyZWFzZSB0aGUNCj4gcmVhZGFi
aWxpdHkgb2YgdGhlIGNvZGUgSSB0aGluay4NCg0Kd2lsbCBkbyBpdC4gOi0pDQoNClJlZ2FyZHMs
DQpZaSBMaXUNCg0KPiA+ICsJCQlwcl93YXJuX3JhdGVsaW1pdGVkKCJtdWx0aSBpb2FzaWRfc2V0
ICglZDolZCkgc2V0dGluZyIsDQo+ID4gKwkJCQkJICAgIGRtYXJfZG9tYWluLT5pb2FzaWRfc2lk
LA0KPiA+ICsJCQkJCSAgICAoKihpbnQgKikgZGF0YSkpOw0KPiA+ICsJCQlyZXQgPSAtRUJVU1k7
DQo+ID4gKwkJCWJyZWFrOw0KPiA+ICsJCX0NCj4gPiArCQlkbWFyX2RvbWFpbi0+aW9hc2lkX3Np
ZCA9ICooaW50ICopIGRhdGE7DQo+ID4gKwkJYnJlYWs7DQo+ID4gIAlkZWZhdWx0Og0KPiA+ICAJ
CXJldCA9IC1FSU5WQUw7DQo+ID4gIAkJYnJlYWs7DQo+ID4gZGlmZiAtLWdpdCBhL2luY2x1ZGUv
bGludXgvaW50ZWwtaW9tbXUuaCBiL2luY2x1ZGUvbGludXgvaW50ZWwtaW9tbXUuaA0KPiA+IGlu
ZGV4IDNmMjNjMjYuLjBkMGFiMzIgMTAwNjQ0DQo+ID4gLS0tIGEvaW5jbHVkZS9saW51eC9pbnRl
bC1pb21tdS5oDQo+ID4gKysrIGIvaW5jbHVkZS9saW51eC9pbnRlbC1pb21tdS5oDQo+ID4gQEAg
LTU0OSw2ICs1NDksMTAgQEAgc3RydWN0IGRtYXJfZG9tYWluIHsNCj4gPiAgCQkJCQkgICAyID09
IDFHaUIsIDMgPT0gNTEyR2lCLCA0ID09IDFUaUIgKi8NCj4gPiAgCXU2NAkJbWF4X2FkZHI7CS8q
IG1heGltdW0gbWFwcGVkIGFkZHJlc3MgKi8NCj4gPg0KPiA+ICsJaW50CQlpb2FzaWRfc2lkOwkv
Kg0KPiA+ICsJCQkJCSAqIHRoZSBpb2FzaWQgc2V0IHdoaWNoIHRyYWNrcyBhbGwNCj4gPiArCQkJ
CQkgKiBQQVNJRHMgdXNlZCBieSB0aGUgZG9tYWluLg0KPiA+ICsJCQkJCSAqLw0KPiA+ICAJaW50
CQlkZWZhdWx0X3Bhc2lkOwkvKg0KPiA+ICAJCQkJCSAqIFRoZSBkZWZhdWx0IHBhc2lkIHVzZWQg
Zm9yIG5vbi1TVk0NCj4gPiAgCQkJCQkgKiB0cmFmZmljIG9uIG1lZGlhdGVkIGRldmljZXMuDQo+
ID4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvaW9tbXUuaCBiL2luY2x1ZGUvbGludXgvaW9t
bXUuaA0KPiA+IGluZGV4IDI1NjdjMzMuLjIxZDMyYmUgMTAwNjQ0DQo+ID4gLS0tIGEvaW5jbHVk
ZS9saW51eC9pb21tdS5oDQo+ID4gKysrIGIvaW5jbHVkZS9saW51eC9pb21tdS5oDQo+ID4gQEAg
LTEyNCw2ICsxMjQsNyBAQCBlbnVtIGlvbW11X2F0dHIgew0KPiA+ICAJRE9NQUlOX0FUVFJfRlNM
X1BBTVVWMSwNCj4gPiAgCURPTUFJTl9BVFRSX05FU1RJTkcsCS8qIHR3byBzdGFnZXMgb2YgdHJh
bnNsYXRpb24gKi8NCj4gPiAgCURPTUFJTl9BVFRSX0RNQV9VU0VfRkxVU0hfUVVFVUUsDQo+ID4g
KwlET01BSU5fQVRUUl9JT0FTSURfU0lELA0KPiA+ICAJRE9NQUlOX0FUVFJfTUFYLA0KPiA+ICB9
Ow0KPiA+DQo+ID4NCj4gVGhhbmtzDQo+IA0KPiBFcmljDQoNCg==
