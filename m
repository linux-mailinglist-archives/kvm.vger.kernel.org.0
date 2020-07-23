Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8E7722AE90
	for <lists+kvm@lfdr.de>; Thu, 23 Jul 2020 14:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726782AbgGWMGH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jul 2020 08:06:07 -0400
Received: from mga07.intel.com ([134.134.136.100]:21389 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726558AbgGWMGG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jul 2020 08:06:06 -0400
IronPort-SDR: GBJK0pOInx7XunwR8j3w+bygFeR/iSLHB4Kn0etslXn/IJ8wzQAtJrjpGxeq/w0lR3QJo0T0uF
 /5pje0kSTXKA==
X-IronPort-AV: E=McAfee;i="6000,8403,9690"; a="215120761"
X-IronPort-AV: E=Sophos;i="5.75,386,1589266800"; 
   d="scan'208";a="215120761"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2020 05:05:59 -0700
IronPort-SDR: SBisw0KLhXfk9DVG+dAku/va1s5OZ4NRVe/T0a6CylLFrNB9dWnoeA6dasD+PArKRPcOjIazig
 St5VppGdqxSA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,386,1589266800"; 
   d="scan'208";a="320630836"
Received: from orsmsx106.amr.corp.intel.com ([10.22.225.133])
  by fmsmga002.fm.intel.com with ESMTP; 23 Jul 2020 05:05:55 -0700
Received: from orsmsx111.amr.corp.intel.com (10.22.240.12) by
 ORSMSX106.amr.corp.intel.com (10.22.225.133) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 23 Jul 2020 05:05:54 -0700
Received: from ORSEDG001.ED.cps.intel.com (10.7.248.4) by
 ORSMSX111.amr.corp.intel.com (10.22.240.12) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 23 Jul 2020 05:05:54 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 23 Jul 2020 05:05:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T6gnJAKz9S5yraYiYGbHrsMTrtlbJ/BPuQZVNlg6fmA+5We8rq9zX/MZWPqe70IQYDSyCMvP42S4P980LVRXH+lnOzuHJ0wztqOc+NRBii/j59s9x3x9uK6Bwr/EzuglQaVtM3mKEcIrCzS7WGaP7UP8ipDIId7aqy71ZPeqaGtvVXZ9j/7DibPO7DF7SHjWXew9EnyeLY2dEXBOt3GIcoDujH+nCv7UisUwVc7U5WbmGpsglugA9EFCYZBQz2n1NtXEYtikkVek8Amb1SQqSs0kmHI23XSJBl09UrgIIZI96Gy3rtzogH6jdOTVBW2s1hw0pjy2k9lpknSY7A/OMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XU0xVkNRG7Ih/+Xs97zWNr94AjZozEaUK4V22gBuO2k=;
 b=UmTDczu1L+AeZzAliG0aimbJKqWd7+c2RedxHqWPVhxAyWL1yhZrJZ5ljxHa3KwCtiWXBTnl+xNH4Mek2leoTC3dkJnWklBeZelqzzLgLjz9QPKJoLFrriNa7OXnJj3PplGTJV2RRfmMVllD9dWVBJ66pDOmhxT7LAm0dDDbsvkz1WTQnQ+MvOZv063DlgIS1XOZ7iBAlPeaf8OmnLOi4EcJVyaLId3yB7DqFAfMGHxkduHaqVvcHifxQ/Ohyg2MM2TJR9QEG8n8fh6qk/+Es+XmUbJmF/iqFzeudi8CiSgBCJaAiQzI4Qa/seY2CZyqX02WAJWuxbkPkaw++uAVUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XU0xVkNRG7Ih/+Xs97zWNr94AjZozEaUK4V22gBuO2k=;
 b=P56rWQmRDrysrIygAYJF4pdM97HBxWHC3djYyH8LOeCKN2Nxgq5QTJzDGN+v+fyfF/c8mfaWUbuX20ZY6MCSI9u1BpZRMOcZ/Su62zkSGRAn28D77AFRV8/h3ro69k8b6xB+mPcsnxseA81Hsp5IVrWKngOHMlTp6G8GPTo+KAA=
Received: from DM5PR11MB1435.namprd11.prod.outlook.com (2603:10b6:4:7::18) by
 DM6PR11MB3515.namprd11.prod.outlook.com (2603:10b6:5:6c::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3216.20; Thu, 23 Jul 2020 12:05:52 +0000
Received: from DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364]) by DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364%10]) with mapi id 15.20.3216.020; Thu, 23 Jul
 2020 12:05:52 +0000
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
Subject: RE: [PATCH v5 12/15] vfio/type1: Add vSVA support for IOMMU-backed
 mdevs
Thread-Topic: [PATCH v5 12/15] vfio/type1: Add vSVA support for IOMMU-backed
 mdevs
Thread-Index: AQHWWD2m9cYqxGch9Ui/XGA0vhDWoakQcFWAgASyDUA=
Date:   Thu, 23 Jul 2020 12:05:52 +0000
Message-ID: <DM5PR11MB14359BEC34E22DD1921A39D4C3760@DM5PR11MB1435.namprd11.prod.outlook.com>
References: <1594552870-55687-1-git-send-email-yi.l.liu@intel.com>
 <1594552870-55687-13-git-send-email-yi.l.liu@intel.com>
 <5921bffc-9daa-99be-9a12-6d94ce1950d2@redhat.com>
In-Reply-To: <5921bffc-9daa-99be-9a12-6d94ce1950d2@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.216]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d440f6ab-454f-4d0d-12f7-08d82f00bf21
x-ms-traffictypediagnostic: DM6PR11MB3515:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB3515AE9288ADE948E8B678EBC3760@DM6PR11MB3515.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HHYWynRlaS6Zyr92pEyjSSFzWqp3TfyphmEHqCPyB03vnUM5ZzgbZBh/hN2Sk0G6ZDSWPPEOiCxU/9ttF9GcQDOTh9y82RYe2H2kORthqKXq87PMY8FWRSVPSpObg1NWlQmMoFZzaJZSw9/9GS9CYbngvRYea3o6Ml8Lds1daq/eIkMbOfXNnvGQg01CJ2MmMBZLEqUtm11hD59lPtUInBtWN5l5Yp8Y+cYj72QXGRVb6nXjzBxTU09dFzep1P6FlIrbic+jl0AEzeqH/XFfP/qGjw2Y5/3K8fLxmsltz/qWjPbxoJbI0rLMm/t2KQid21Oq0mqNCbsEsE9It+8FPpCNz2BXKiTGLEg+VJaIb/D/0cfm0luiahUlaWywsnvK5yPYLOU9p0ckCl7bza8vstbgssJaKRajJ4hzcDTtanvyBNv+Mvsr+ATaMSU0gNqCctYTOcFX6e9EozhnpG6uuqICq8sp3e+ZXQTF6yrvdrQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1435.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(346002)(376002)(366004)(396003)(136003)(8936002)(76116006)(2906002)(966005)(8676002)(71200400001)(7416002)(66446008)(83380400001)(64756008)(66556008)(66476007)(66946007)(52536014)(316002)(54906003)(5660300002)(53546011)(6506007)(9686003)(110136005)(33656002)(55016002)(478600001)(86362001)(26005)(186003)(4326008)(7696005)(15398625002)(43620500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: AQVCJhZuGJhbwxv3tIMxtwti1Q7s2wFGtgQuzEjMbZndKJ1bRgOJG0O+Td3uSw0PM3JpBdBz2RbXYj6kurnO9z+VNvBwrdf0O6Si6cVMUrG5aUh/VGfFjfHKUe2oHQZfS/dXymV3rKRH7YLOkVEzBeBqmHaqc6+0KphWxV0U/kSgDwvxCrxFKGoaKHM4C9urEVeZ+0us3WvZxp9dFun33NyepkVd1pIOQ5O8TgrzhpS1LNSWWjXd29DTLgjqQSzHvdDMd6LdBuiY0kJOx2bNm2BFbT4Jz1ZDdDmnOj4HcwDFuJ3ibZ6sJeF9hVlvRTXmge85xTUYvJmcixTG+ABikStcM+JPi5NsW3J+vcxn4bQL935j6VbOPB4UF69ICzH0B9ihDEDg2igvGPb3Rjj9G2G5V5bfX9qL0bB4MSdSrm7n3tQoqaGFG0IkSk2OaRB7FL6O9Eyk3lwypGmbSBrfKrF7q+fWgh5I31Hm88vHXJPFxrA99slEJdMT3FUTDTEg
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1435.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d440f6ab-454f-4d0d-12f7-08d82f00bf21
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2020 12:05:52.4297
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: n3/09sYkki1B0zf3hRUuPpHP7fAOoXqlF3qtaZGZLK+rSkoDB8oYoznHl9JDrMMaqlvmr1sWpxgql9Lcaz2noQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3515
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgRXJpYywNCg0KPiBGcm9tOiBBdWdlciBFcmljIDwgZXJpYy5hdWdlckByZWRoYXQuY29tPg0K
PiBTZW50OiBNb25kYXksIEp1bHkgMjAsIDIwMjAgODoyMiBQTQ0KPiANCj4gWWksDQo+IA0KPiBP
biA3LzEyLzIwIDE6MjEgUE0sIExpdSBZaSBMIHdyb3RlOg0KPiA+IFJlY2VudCB5ZWFycywgbWVk
aWF0ZWQgZGV2aWNlIHBhc3MtdGhyb3VnaCBmcmFtZXdvcmsgKGUuZy4gdmZpby1tZGV2KQ0KPiA+
IGlzIHVzZWQgdG8gYWNoaWV2ZSBmbGV4aWJsZSBkZXZpY2Ugc2hhcmluZyBhY3Jvc3MgZG9tYWlu
cyAoZS5nLiBWTXMpLg0KPiA+IEFsc28gdGhlcmUgYXJlIGhhcmR3YXJlIGFzc2lzdGVkIG1lZGlh
dGVkIHBhc3MtdGhyb3VnaCBzb2x1dGlvbnMgZnJvbQ0KPiA+IHBsYXRmb3JtIHZlbmRvcnMuIGUu
Zy4gSW50ZWwgVlQtZCBzY2FsYWJsZSBtb2RlIHdoaWNoIHN1cHBvcnRzIEludGVsDQo+ID4gU2Nh
bGFibGUgSS9PIFZpcnR1YWxpemF0aW9uIHRlY2hub2xvZ3kuIFN1Y2ggbWRldnMgYXJlIGNhbGxl
ZCBJT01NVS0NCj4gPiBiYWNrZWQgbWRldnMgYXMgdGhlcmUgYXJlIElPTU1VIGVuZm9yY2VkIERN
QSBpc29sYXRpb24gZm9yIHN1Y2ggbWRldnMuDQo+IHRoZXJlIGlzIElPTU1VIGVuZm9yY2VkIERN
QSBpc29sYXRpb24NCj4gPiBJbiBrZXJuZWwsIElPTU1VLWJhY2tlZCBtZGV2cyBhcmUgZXhwb3Nl
ZCB0byBJT01NVSBsYXllciBieSBhdXgtZG9tYWluDQo+ID4gY29uY2VwdCwgd2hpY2ggbWVhbnMg
bWRldnMgYXJlIHByb3RlY3RlZCBieSBhbiBpb21tdSBkb21haW4gd2hpY2ggaXMNCj4gPiBhdXhp
bGlhcnkgdG8gdGhlIGRvbWFpbiB0aGF0IHRoZSBrZXJuZWwgZHJpdmVyIHByaW1hcmlseSB1c2Vz
IGZvciBETUENCj4gPiBBUEkuIERldGFpbHMgY2FuIGJlIGZvdW5kIGluIHRoZSBLVk0gcHJlc2Vu
dGF0aW9uIGFzIGJlbG93Og0KPiA+DQo+ID4gaHR0cHM6Ly9ldmVudHMxOS5saW51eGZvdW5kYXRp
b24ub3JnL3dwLWNvbnRlbnQvdXBsb2Fkcy8yMDE3LzEyL1wNCj4gPiBIYXJkd2FyZS1Bc3Npc3Rl
ZC1NZWRpYXRlZC1QYXNzLVRocm91Z2gtd2l0aC1WRklPLUtldmluLVRpYW4tSW50ZWwucGRmDQo+
ID4NCj4gPiBUaGlzIHBhdGNoIGV4dGVuZHMgTkVTVElOR19JT01NVSBvcHMgdG8gSU9NTVUtYmFj
a2VkIG1kZXYgZGV2aWNlcy4gVGhlDQo+ID4gbWFpbiByZXF1aXJlbWVudCBpcyB0byB1c2UgdGhl
IGF1eGlsaWFyeSBkb21haW4gYXNzb2NpYXRlZCB3aXRoIG1kZXYuDQo+IA0KPiBTbyBhcyBhIHJl
c3VsdCB2U1ZNIGJlY29tZXMgZnVuY3Rpb25hbCBmb3Igc2NhbGFibGUgbW9kZSBtZWRpYXRlZCBk
ZXZpY2VzLCByaWdodD8NCg0KeWVzLiBhcyBsb25nIGFzIHRoZSBtZWRpYXRlZCBkZXZpY2VzIHJl
cG9ydHMgUEFTSUQgY2FwYWJpbGl0eS4NCg0KPiA+DQo+ID4gQ2M6IEtldmluIFRpYW4gPGtldmlu
LnRpYW5AaW50ZWwuY29tPg0KPiA+IENDOiBKYWNvYiBQYW4gPGphY29iLmp1bi5wYW5AbGludXgu
aW50ZWwuY29tPg0KPiA+IENDOiBKdW4gVGlhbiA8anVuLmoudGlhbkBpbnRlbC5jb20+DQo+ID4g
Q2M6IEFsZXggV2lsbGlhbXNvbiA8YWxleC53aWxsaWFtc29uQHJlZGhhdC5jb20+DQo+ID4gQ2M6
IEVyaWMgQXVnZXIgPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT4NCj4gPiBDYzogSmVhbi1QaGlsaXBw
ZSBCcnVja2VyIDxqZWFuLXBoaWxpcHBlQGxpbmFyby5vcmc+DQo+ID4gQ2M6IEpvZXJnIFJvZWRl
bCA8am9yb0A4Ynl0ZXMub3JnPg0KPiA+IENjOiBMdSBCYW9sdSA8YmFvbHUubHVAbGludXguaW50
ZWwuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IExpdSBZaSBMIDx5aS5sLmxpdUBpbnRlbC5jb20+
DQo+ID4gLS0tDQo+ID4gdjEgLT4gdjI6DQo+ID4gKikgY2hlY2sgdGhlIGlvbW11X2RldmljZSB0
byBlbnN1cmUgdGhlIGhhbmRsaW5nIG1kZXYgaXMgSU9NTVUtYmFja2VkDQo+ID4gLS0tDQo+ID4g
IGRyaXZlcnMvdmZpby92ZmlvX2lvbW11X3R5cGUxLmMgfCAzOQ0KPiA+ICsrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrLS0tLQ0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgMzUgaW5zZXJ0
aW9ucygrKSwgNCBkZWxldGlvbnMoLSkNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Zm
aW8vdmZpb19pb21tdV90eXBlMS5jDQo+ID4gYi9kcml2ZXJzL3ZmaW8vdmZpb19pb21tdV90eXBl
MS5jIGluZGV4IDk2MGNjNTkuLmYxZjFhZTIgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy92Zmlv
L3ZmaW9faW9tbXVfdHlwZTEuYw0KPiA+ICsrKyBiL2RyaXZlcnMvdmZpby92ZmlvX2lvbW11X3R5
cGUxLmMNCj4gPiBAQCAtMjM3MywyMCArMjM3Myw0MSBAQCBzdGF0aWMgaW50IHZmaW9faW9tbXVf
cmVzdl9yZWZyZXNoKHN0cnVjdA0KPiB2ZmlvX2lvbW11ICppb21tdSwNCj4gPiAgCXJldHVybiBy
ZXQ7DQo+ID4gIH0NCj4gPg0KPiA+ICtzdGF0aWMgc3RydWN0IGRldmljZSAqdmZpb19nZXRfaW9t
bXVfZGV2aWNlKHN0cnVjdCB2ZmlvX2dyb3VwICpncm91cCwNCj4gPiArCQkJCQkgICAgc3RydWN0
IGRldmljZSAqZGV2KQ0KPiA+ICt7DQo+ID4gKwlpZiAoZ3JvdXAtPm1kZXZfZ3JvdXApDQo+ID4g
KwkJcmV0dXJuIHZmaW9fbWRldl9nZXRfaW9tbXVfZGV2aWNlKGRldik7DQo+ID4gKwllbHNlDQo+
ID4gKwkJcmV0dXJuIGRldjsNCj4gPiArfQ0KPiA+ICsNCj4gPiAgc3RhdGljIGludCB2ZmlvX2Rl
dl9iaW5kX2dwYXNpZF9mbihzdHJ1Y3QgZGV2aWNlICpkZXYsIHZvaWQgKmRhdGEpICB7DQo+ID4g
IAlzdHJ1Y3QgZG9tYWluX2NhcHN1bGUgKmRjID0gKHN0cnVjdCBkb21haW5fY2Fwc3VsZSAqKWRh
dGE7DQo+ID4gIAl1bnNpZ25lZCBsb25nIGFyZyA9ICoodW5zaWduZWQgbG9uZyAqKWRjLT5kYXRh
Ow0KPiA+ICsJc3RydWN0IGRldmljZSAqaW9tbXVfZGV2aWNlOw0KPiA+ICsNCj4gPiArCWlvbW11
X2RldmljZSA9IHZmaW9fZ2V0X2lvbW11X2RldmljZShkYy0+Z3JvdXAsIGRldik7DQo+ID4gKwlp
ZiAoIWlvbW11X2RldmljZSkNCj4gPiArCQlyZXR1cm4gLUVJTlZBTDsNCj4gPg0KPiA+IC0JcmV0
dXJuIGlvbW11X3N2YV9iaW5kX2dwYXNpZChkYy0+ZG9tYWluLCBkZXYsICh2b2lkIF9fdXNlciAq
KWFyZyk7DQo+ID4gKwlyZXR1cm4gaW9tbXVfc3ZhX2JpbmRfZ3Bhc2lkKGRjLT5kb21haW4sIGlv
bW11X2RldmljZSwNCj4gPiArCQkJCSAgICAgKHZvaWQgX191c2VyICopYXJnKTsNCj4gPiAgfQ0K
PiA+DQo+ID4gIHN0YXRpYyBpbnQgdmZpb19kZXZfdW5iaW5kX2dwYXNpZF9mbihzdHJ1Y3QgZGV2
aWNlICpkZXYsIHZvaWQgKmRhdGEpDQo+ID4gew0KPiA+ICAJc3RydWN0IGRvbWFpbl9jYXBzdWxl
ICpkYyA9IChzdHJ1Y3QgZG9tYWluX2NhcHN1bGUgKilkYXRhOw0KPiA+ICAJdW5zaWduZWQgbG9u
ZyBhcmcgPSAqKHVuc2lnbmVkIGxvbmcgKilkYy0+ZGF0YTsNCj4gPiArCXN0cnVjdCBkZXZpY2Ug
KmlvbW11X2RldmljZTsNCj4gPg0KPiA+IC0JaW9tbXVfc3ZhX3VuYmluZF9ncGFzaWQoZGMtPmRv
bWFpbiwgZGV2LCAodm9pZCBfX3VzZXIgKilhcmcpOw0KPiA+ICsJaW9tbXVfZGV2aWNlID0gdmZp
b19nZXRfaW9tbXVfZGV2aWNlKGRjLT5ncm91cCwgZGV2KTsNCj4gPiArCWlmICghaW9tbXVfZGV2
aWNlKQ0KPiA+ICsJCXJldHVybiAtRUlOVkFMOw0KPiA+ICsNCj4gPiArCWlvbW11X3N2YV91bmJp
bmRfZ3Bhc2lkKGRjLT5kb21haW4sIGlvbW11X2RldmljZSwNCj4gPiArCQkJCSh2b2lkIF9fdXNl
ciAqKWFyZyk7DQo+ID4gIAlyZXR1cm4gMDsNCj4gPiAgfQ0KPiA+DQo+ID4gQEAgLTIzOTUsOCAr
MjQxNiwxMyBAQCBzdGF0aWMgaW50IF9fdmZpb19kZXZfdW5iaW5kX2dwYXNpZF9mbihzdHJ1Y3Qg
ZGV2aWNlDQo+ICpkZXYsIHZvaWQgKmRhdGEpDQo+ID4gIAlzdHJ1Y3QgZG9tYWluX2NhcHN1bGUg
KmRjID0gKHN0cnVjdCBkb21haW5fY2Fwc3VsZSAqKWRhdGE7DQo+ID4gIAlzdHJ1Y3QgaW9tbXVf
Z3Bhc2lkX2JpbmRfZGF0YSAqdW5iaW5kX2RhdGEgPQ0KPiA+ICAJCQkJKHN0cnVjdCBpb21tdV9n
cGFzaWRfYmluZF9kYXRhICopZGMtPmRhdGE7DQo+ID4gKwlzdHJ1Y3QgZGV2aWNlICppb21tdV9k
ZXZpY2U7DQo+ID4gKw0KPiA+ICsJaW9tbXVfZGV2aWNlID0gdmZpb19nZXRfaW9tbXVfZGV2aWNl
KGRjLT5ncm91cCwgZGV2KTsNCj4gPiArCWlmICghaW9tbXVfZGV2aWNlKQ0KPiA+ICsJCXJldHVy
biAtRUlOVkFMOw0KPiA+DQo+ID4gLQlfX2lvbW11X3N2YV91bmJpbmRfZ3Bhc2lkKGRjLT5kb21h
aW4sIGRldiwgdW5iaW5kX2RhdGEpOw0KPiA+ICsJX19pb21tdV9zdmFfdW5iaW5kX2dwYXNpZChk
Yy0+ZG9tYWluLCBpb21tdV9kZXZpY2UsIHVuYmluZF9kYXRhKTsNCj4gPiAgCXJldHVybiAwOw0K
PiA+ICB9DQo+ID4NCj4gPiBAQCAtMzA3Nyw4ICszMTAzLDEzIEBAIHN0YXRpYyBpbnQgdmZpb19k
ZXZfY2FjaGVfaW52YWxpZGF0ZV9mbihzdHJ1Y3QNCj4gPiBkZXZpY2UgKmRldiwgdm9pZCAqZGF0
YSkgIHsNCj4gPiAgCXN0cnVjdCBkb21haW5fY2Fwc3VsZSAqZGMgPSAoc3RydWN0IGRvbWFpbl9j
YXBzdWxlICopZGF0YTsNCj4gPiAgCXVuc2lnbmVkIGxvbmcgYXJnID0gKih1bnNpZ25lZCBsb25n
ICopZGMtPmRhdGE7DQo+ID4gKwlzdHJ1Y3QgZGV2aWNlICppb21tdV9kZXZpY2U7DQo+ID4gKw0K
PiA+ICsJaW9tbXVfZGV2aWNlID0gdmZpb19nZXRfaW9tbXVfZGV2aWNlKGRjLT5ncm91cCwgZGV2
KTsNCj4gPiArCWlmICghaW9tbXVfZGV2aWNlKQ0KPiA+ICsJCXJldHVybiAtRUlOVkFMOw0KPiA+
DQo+ID4gLQlpb21tdV9jYWNoZV9pbnZhbGlkYXRlKGRjLT5kb21haW4sIGRldiwgKHZvaWQgX191
c2VyICopYXJnKTsNCj4gPiArCWlvbW11X2NhY2hlX2ludmFsaWRhdGUoZGMtPmRvbWFpbiwgaW9t
bXVfZGV2aWNlLCAodm9pZCBfX3VzZXINCj4gPiArKilhcmcpOw0KPiA+ICAJcmV0dXJuIDA7DQo+
ID4gIH0NCj4gPg0KPiA+DQo+IEJlc2lkZXMsDQo+IA0KPiBMb29rcyBncm9vZCB0byBtZQ0KPiAN
Cj4gUmV2aWV3ZWQtYnk6IEVyaWMgQXVnZXIgPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT4NCg0KdGhh
bmtzIDotKQ0KDQpSZWdhcmRzLA0KWWkgTGl1DQoNCj4gRXJpYw0KDQo=
