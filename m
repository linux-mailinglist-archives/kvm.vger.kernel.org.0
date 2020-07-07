Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1FF2216922
	for <lists+kvm@lfdr.de>; Tue,  7 Jul 2020 11:35:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727850AbgGGJex (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jul 2020 05:34:53 -0400
Received: from mga07.intel.com ([134.134.136.100]:15551 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725941AbgGGJew (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jul 2020 05:34:52 -0400
IronPort-SDR: ABTMOwUhPn+BR78rx3UqDtOnfeaUwXqB+uw9f3BxF1H2oajcQEU1b9OVJBkBDapTpIZD8uQoXN
 gXiwQ7DoUW5g==
X-IronPort-AV: E=McAfee;i="6000,8403,9674"; a="212533378"
X-IronPort-AV: E=Sophos;i="5.75,323,1589266800"; 
   d="scan'208";a="212533378"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2020 02:34:49 -0700
IronPort-SDR: mjwmhkMUNU0ooCQVOfgHcOZHwMKth5kmG+6t5eWXEYXagMDHUhRZNMtcmciU16rw1nABgvYQTT
 Prx2nilRVXkg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,323,1589266800"; 
   d="scan'208";a="305600119"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga004.fm.intel.com with ESMTP; 07 Jul 2020 02:34:48 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 7 Jul 2020 02:34:48 -0700
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 7 Jul 2020 02:34:47 -0700
Received: from ORSEDG001.ED.cps.intel.com (10.7.248.4) by
 orsmsx606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 7 Jul 2020 02:34:47 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 7 Jul 2020 02:34:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h1iaWz4cIHiMUfC73wBwLl5xc+8MV7Qt71YUBKE43tKMkUptvxLHNSF4XsB7eSEjiIHxn9HSakcEMDMaaXIPz8V6JPacErXQ+T9xREbsw43BOcrAJjQMeu2WLM1WEvrz6ZjaEaUQraHr6ECDkW07MP0E/DoZL2ePceDGxy2+7Msa/uSAsbCiw04KTGnzRM9wy+D/6Im4QawMmUPZ+T2ohzrEogcn3f6Hi1j50fNt3nZ8aWgpl8QvlhL6vA/9VmuxpiEl7E6znFmmg2vdg0s0IK4ndxI+qT+Y5BeYxdgCY501ELZgh+IOzf6dCDXuikVXwaGk3JfaLabDK0rhG75Nvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M7hp26Ioh3NUFKQS4x0a6QfXV/CZxDCjs8kA8fjk3nY=;
 b=UhSvXqu1yi+LJXyvrmHqInJkBDct/UH0NtDyGWtFQoE2PRDmHW9xhcNA9pOQW+aJ8CWAYanS3Ws0jnjlGQb0uOLqUmBdYWIqTAv8DeUJtj5oYZbai7BU3UdRPC3rTwl+bcYSxhRNTE0Y/DHYdBiXD3LIqkDZ52D/mLmwCXoz+BJQdAD9ip37oyDxUxJZpk+C5wrDVjKBhNcdwAv3mQR+MZchdyTVRYn0UlBr2XcNw++NwiW3oF8WR7cBzLga1lSHNAFyHaW1gNz9ZvHffpDBDrBj0O+y78GCXyyAEnuwRI5eyGOG/teCEU6wfLIaWaTRGmUXMH8J33LflIFEetVx7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M7hp26Ioh3NUFKQS4x0a6QfXV/CZxDCjs8kA8fjk3nY=;
 b=ouaYrT9+X1jGOLQ2DoUb/t0BWz8nCB6S8SwM1NKjZC8JN08iidJXVdykU7oJjw8CwakBdfpxUt2KO76ZI394UI7BFQVTLHoTrkSvPI7NOHW9piP4Wu8l92pVipp7cYY3xpzXY19TRr1A2IxCu0LmbV9hHEAKeezO7jWqD2vqGdQ=
Received: from DM5PR11MB1435.namprd11.prod.outlook.com (2603:10b6:4:7::18) by
 DM6PR11MB3692.namprd11.prod.outlook.com (2603:10b6:5:13e::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3153.27; Tue, 7 Jul 2020 09:34:45 +0000
Received: from DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364]) by DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364%10]) with mapi id 15.20.3153.029; Tue, 7 Jul 2020
 09:34:45 +0000
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
Thread-Index: AQHWUfUbywl8Q+WBl0+9l/PlGyuXiKj6mYIAgAFGARA=
Date:   Tue, 7 Jul 2020 09:34:45 +0000
Message-ID: <DM5PR11MB14351139CE062B03BE26B773C3660@DM5PR11MB1435.namprd11.prod.outlook.com>
References: <1593861989-35920-1-git-send-email-yi.l.liu@intel.com>
 <1593861989-35920-5-git-send-email-yi.l.liu@intel.com>
 <d3de1052-e363-b81e-1384-0de62d1ceeda@redhat.com>
In-Reply-To: <d3de1052-e363-b81e-1384-0de62d1ceeda@redhat.com>
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
x-ms-office365-filtering-correlation-id: 5f60253d-731e-4320-ee73-08d82258fbfb
x-ms-traffictypediagnostic: DM6PR11MB3692:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB3692B09A520C9FBB368B0DE7C3660@DM6PR11MB3692.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:983;
x-forefront-prvs: 0457F11EAF
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8QHujbFCYAdixtGrXr2XPaY212WqRPtkFAE4JNNU8r7IkErgRqI2bpuMbf67VZRgcflBQqfFQ2vx7ICVFnErr9P1Lz5Gjo6OzQEIVsvpjaUyGtmKW3fVDn0JF7aZjREQxX+ZgaGT2I5jQbsdsMm5w5dVG53oygBMBKQWVjYcmcuBVvsQ1/I/IYe0bq91eqmbPlnan7+ZdTgrQUKlYJpiBQTwQSOB9AHO00/OSKwGRJXzpL82VPr2hnxjyqEbMC/o8xxX5TtwhkpXeIsNtCBAKTJD45Xbq4wwF0eHQfP7o2WboLWW/CEcWK23suB5Ip6WghYwOToOoSowmtggLRR2s4HSXkZu31AuYV2UHpTpHWkDf4GSR9/kZ/FJ7GFmg0aqujnXt9istdYuxdJn4Vo9fw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1435.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(39860400002)(366004)(376002)(346002)(110136005)(52536014)(5660300002)(54906003)(2906002)(316002)(83380400001)(8676002)(33656002)(4326008)(66946007)(66446008)(76116006)(66476007)(66556008)(64756008)(26005)(55016002)(71200400001)(966005)(478600001)(7696005)(186003)(8936002)(86362001)(6506007)(7416002)(53546011)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: AUOoGAddku1qUNXPuTjhwv1sgvJ/RdTt1Gn4W4xhPYHUfC5LTB6PrDaWQ32FHXdTMA4Fsb76FwTOLvdJ+4nQllj9aOmF9fTGC2Jq1pw7mR7xmdzl0Gr/m0qc9SWs60GZOAhImHHYzZ+shOLJNi0/bzKov2DEbz0Wg/Y9EJA/dqlDDcCNgFR/bkAftE/FVt9NyTNm1/cxX66+uJ8vFxV+yaXdTg9SdOGu9DCZ7hMbay1zsYrv0+K0mO3X1RifgGNrRYOE//Qj0uHsZzW2a5xUhvjCUNjEmto7cEiwnbM7gCzHixpjq1EzkAtL/w4+QX3Guxmk+ZzVsy+D5WKx3St0IwhqxK+AcBb7LrUpAWdY6ulNlyNcMTt1a7glV+Z0DZiH6Irv+Gq9rs6n8J7WqmeKPZ2w2ThbifN9VZtgi9EAQGfHPMaq+mMr1eda8aHmiRrhuj4GTDsLjNjW9nYMGXeI1JKHxJcDWQFMemidKiaPotpAxtj1gy6DgGvGBnEX1UtS
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1435.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f60253d-731e-4320-ee73-08d82258fbfb
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jul 2020 09:34:45.0984
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UHgvB47bLCgi3COKA2MEzKeNL+DuetDucpHgp2qe5xxlwRQTpW96+ipIGXJmHznH15BqRfotxQnqQ/8Hv4yFLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3692
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgRXJpYywNCg0KPiBGcm9tOiBBdWdlciBFcmljIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+
IFNlbnQ6IE1vbmRheSwgSnVseSA2LCAyMDIwIDEwOjA3IFBNDQo+IA0KPiBIaSBZaSwNCj4gT24g
Ny80LzIwIDE6MjYgUE0sIExpdSBZaSBMIHdyb3RlOg0KPiA+IFRoaXMgcGF0Y2ggZXhwb3J0cyBp
b21tdSBuZXN0aW5nIGNhcGFiaWxpdHkgaW5mbyB0byB1c2VyIHNwYWNlIHRocm91Z2gNCj4gPiBW
RklPLiBVc2VyIHNwYWNlIGlzIGV4cGVjdGVkIHRvIGNoZWNrIHRoaXMgaW5mbyBmb3Igc3VwcG9y
dGVkIHVBUElzIChlLmcuDQo+ID4gUEFTSUQgYWxsb2MvZnJlZSwgYmluZCBwYWdlIHRhYmxlLCBh
bmQgY2FjaGUgaW52YWxpZGF0aW9uKSBhbmQgdGhlIHZlbmRvcg0KPiA+IHNwZWNpZmljIGZvcm1h
dCBpbmZvcm1hdGlvbiBmb3IgZmlyc3QgbGV2ZWwvc3RhZ2UgcGFnZSB0YWJsZSB0aGF0IHdpbGwg
YmUNCj4gPiBib3VuZCB0by4NCj4gPg0KPiA+IFRoZSBuZXN0aW5nIGluZm8gaXMgYXZhaWxhYmxl
IG9ubHkgYWZ0ZXIgdGhlIG5lc3RpbmcgaW9tbXUgdHlwZSBpcyBzZXQNCj4gPiBmb3IgYSBjb250
YWluZXIuIEN1cnJlbnQgaW1wbGVtZW50YXRpb24gaW1wb3NlcyBvbmUgbGltaXRhdGlvbiAtIG9u
ZQ0KPiA+IG5lc3RpbmcgY29udGFpbmVyIHNob3VsZCBpbmNsdWRlIGF0IG1vc3Qgb25lIGdyb3Vw
LiBUaGUgcGhpbG9zb3BoeSBvZg0KPiA+IHZmaW8gY29udGFpbmVyIGlzIGhhdmluZyBhbGwgZ3Jv
dXBzL2RldmljZXMgd2l0aGluIHRoZSBjb250YWluZXIgc2hhcmUNCj4gPiB0aGUgc2FtZSBJT01N
VSBjb250ZXh0LiBXaGVuIHZTVkEgaXMgZW5hYmxlZCwgb25lIElPTU1VIGNvbnRleHQgY291bGQN
Cj4gPiBpbmNsdWRlIG9uZSAybmQtbGV2ZWwgYWRkcmVzcyBzcGFjZSBhbmQgbXVsdGlwbGUgMXN0
LWxldmVsIGFkZHJlc3Mgc3BhY2VzLg0KPiA+IFdoaWxlIHRoZSAybmQtbGV2ZSBhZGRyZXNzIHNw
YWNlIGlzIHJlYXNvbmFibHkgc2hhcmFibGUgYnkgbXVsdGlwbGUgZ3JvdXBzDQo+ID4gLCBibGlu
ZGx5IHNoYXJpbmcgMXN0LWxldmVsIGFkZHJlc3Mgc3BhY2VzIGFjcm9zcyBhbGwgZ3JvdXBzIHdp
dGhpbiB0aGUNCj4gPiBjb250YWluZXIgbWlnaHQgaW5zdGVhZCBicmVhayB0aGUgZ3Vlc3QgZXhw
ZWN0YXRpb24uIEluIHRoZSBmdXR1cmUgc3ViLw0KPiA+IHN1cGVyIGNvbnRhaW5lciBjb25jZXB0
IG1pZ2h0IGJlIGludHJvZHVjZWQgdG8gYWxsb3cgcGFydGlhbCBhZGRyZXNzIHNwYWNlDQo+ID4g
c2hhcmluZyB3aXRoaW4gYW4gSU9NTVUgY29udGV4dC4gQnV0IGZvciBub3cgbGV0J3MgZ28gd2l0
aCB0aGlzIHJlc3RyaWN0aW9uDQo+ID4gYnkgcmVxdWlyaW5nIHNpbmdsZXRvbiBjb250YWluZXIg
Zm9yIHVzaW5nIG5lc3RpbmcgaW9tbXUgZmVhdHVyZXMuIEJlbG93DQo+ID4gbGluayBoYXMgdGhl
IHJlbGF0ZWQgZGlzY3Vzc2lvbiBhYm91dCB0aGlzIGRlY2lzaW9uLg0KPiA+DQo+ID4gaHR0cHM6
Ly9sa21sLm9yZy9sa21sLzIwMjAvNS8xNS8xMDI4DQo+ID4NCj4gPiBDYzogS2V2aW4gVGlhbiA8
a2V2aW4udGlhbkBpbnRlbC5jb20+DQo+ID4gQ0M6IEphY29iIFBhbiA8amFjb2IuanVuLnBhbkBs
aW51eC5pbnRlbC5jb20+DQo+ID4gQ2M6IEFsZXggV2lsbGlhbXNvbiA8YWxleC53aWxsaWFtc29u
QHJlZGhhdC5jb20+DQo+ID4gQ2M6IEVyaWMgQXVnZXIgPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT4N
Cj4gPiBDYzogSmVhbi1QaGlsaXBwZSBCcnVja2VyIDxqZWFuLXBoaWxpcHBlQGxpbmFyby5vcmc+
DQo+ID4gQ2M6IEpvZXJnIFJvZWRlbCA8am9yb0A4Ynl0ZXMub3JnPg0KPiA+IENjOiBMdSBCYW9s
dSA8YmFvbHUubHVAbGludXguaW50ZWwuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IExpdSBZaSBM
IDx5aS5sLmxpdUBpbnRlbC5jb20+DQo+ID4gLS0tDQo+ID4gdjMgLT4gdjQ6DQo+ID4gKikgYWRk
cmVzcyBjb21tZW50cyBhZ2FpbnN0IHYzLg0KPiA+DQo+ID4gdjEgLT4gdjI6DQo+ID4gKikgYWRk
ZWQgaW4gdjINCj4gPiAtLS0NCj4gPg0KPiA+ICBkcml2ZXJzL3ZmaW8vdmZpb19pb21tdV90eXBl
MS5jIHwgMTA1DQo+ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0NCj4g
PiAgaW5jbHVkZS91YXBpL2xpbnV4L3ZmaW8uaCAgICAgICB8ICAxNiArKysrKysNCj4gPiAgMiBm
aWxlcyBjaGFuZ2VkLCAxMDkgaW5zZXJ0aW9ucygrKSwgMTIgZGVsZXRpb25zKC0pDQo+ID4NCj4g
PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy92ZmlvL3ZmaW9faW9tbXVfdHlwZTEuYyBiL2RyaXZlcnMv
dmZpby92ZmlvX2lvbW11X3R5cGUxLmMNCj4gPiBpbmRleCA3YWNjYjU5Li44MDYyM2I4IDEwMDY0
NA0KPiA+IC0tLSBhL2RyaXZlcnMvdmZpby92ZmlvX2lvbW11X3R5cGUxLmMNCj4gPiArKysgYi9k
cml2ZXJzL3ZmaW8vdmZpb19pb21tdV90eXBlMS5jDQo+ID4gQEAgLTYyLDE4ICs2MiwyMCBAQCBN
T0RVTEVfUEFSTV9ERVNDKGRtYV9lbnRyeV9saW1pdCwNCj4gPiAgCQkgIk1heGltdW0gbnVtYmVy
IG9mIHVzZXIgRE1BIG1hcHBpbmdzIHBlciBjb250YWluZXIgKDY1NTM1KS4iKTsNCj4gPg0KPiA+
ICBzdHJ1Y3QgdmZpb19pb21tdSB7DQo+ID4gLQlzdHJ1Y3QgbGlzdF9oZWFkCWRvbWFpbl9saXN0
Ow0KPiA+IC0Jc3RydWN0IGxpc3RfaGVhZAlpb3ZhX2xpc3Q7DQo+ID4gLQlzdHJ1Y3QgdmZpb19k
b21haW4JKmV4dGVybmFsX2RvbWFpbjsgLyogZG9tYWluIGZvciBleHRlcm5hbCB1c2VyICovDQo+
ID4gLQlzdHJ1Y3QgbXV0ZXgJCWxvY2s7DQo+ID4gLQlzdHJ1Y3QgcmJfcm9vdAkJZG1hX2xpc3Q7
DQo+ID4gLQlzdHJ1Y3QgYmxvY2tpbmdfbm90aWZpZXJfaGVhZCBub3RpZmllcjsNCj4gPiAtCXVu
c2lnbmVkIGludAkJZG1hX2F2YWlsOw0KPiA+IC0JdWludDY0X3QJCXBnc2l6ZV9iaXRtYXA7DQo+
ID4gLQlib29sCQkJdjI7DQo+ID4gLQlib29sCQkJbmVzdGluZzsNCj4gPiAtCWJvb2wJCQlkaXJ0
eV9wYWdlX3RyYWNraW5nOw0KPiA+IC0JYm9vbAkJCXBpbm5lZF9wYWdlX2RpcnR5X3Njb3BlOw0K
PiA+ICsJc3RydWN0IGxpc3RfaGVhZAkJZG9tYWluX2xpc3Q7DQo+ID4gKwlzdHJ1Y3QgbGlzdF9o
ZWFkCQlpb3ZhX2xpc3Q7DQo+ID4gKwlzdHJ1Y3QgdmZpb19kb21haW4JCSpleHRlcm5hbF9kb21h
aW47IC8qIGRvbWFpbiBmb3INCj4gPiArCQkJCQkJCSAgICAgZXh0ZXJuYWwgdXNlciAqLw0KPiA+
ICsJc3RydWN0IG11dGV4CQkJbG9jazsNCj4gPiArCXN0cnVjdCByYl9yb290CQkJZG1hX2xpc3Q7
DQo+ID4gKwlzdHJ1Y3QgYmxvY2tpbmdfbm90aWZpZXJfaGVhZAlub3RpZmllcjsNCj4gPiArCXVu
c2lnbmVkIGludAkJCWRtYV9hdmFpbDsNCj4gPiArCXVpbnQ2NF90CQkJcGdzaXplX2JpdG1hcDsN
Cj4gPiArCWJvb2wJCQkJdjI7DQo+ID4gKwlib29sCQkJCW5lc3Rpbmc7DQo+ID4gKwlib29sCQkJ
CWRpcnR5X3BhZ2VfdHJhY2tpbmc7DQo+ID4gKwlib29sCQkJCXBpbm5lZF9wYWdlX2RpcnR5X3Nj
b3BlOw0KPiA+ICsJc3RydWN0IGlvbW11X25lc3RpbmdfaW5mbwkqbmVzdGluZ19pbmZvOw0KPiA+
ICB9Ow0KPiA+DQo+ID4gIHN0cnVjdCB2ZmlvX2RvbWFpbiB7DQo+ID4gQEAgLTEzMCw2ICsxMzIs
OSBAQCBzdHJ1Y3QgdmZpb19yZWdpb25zIHsNCj4gPiAgI2RlZmluZSBJU19JT01NVV9DQVBfRE9N
QUlOX0lOX0NPTlRBSU5FUihpb21tdSkJXA0KPiA+ICAJCQkJCSghbGlzdF9lbXB0eSgmaW9tbXUt
PmRvbWFpbl9saXN0KSkNCj4gPg0KPiA+ICsjZGVmaW5lIElTX0RPTUFJTl9JTl9DT05UQUlORVIo
aW9tbXUpCSgoaW9tbXUtPmV4dGVybmFsX2RvbWFpbikgfHwgXA0KPiA+ICsJCQkJCSAoIWxpc3Rf
ZW1wdHkoJmlvbW11LT5kb21haW5fbGlzdCkpKQ0KPiA+ICsNCj4gPiAgI2RlZmluZSBESVJUWV9C
SVRNQVBfQllURVMobikJKEFMSUdOKG4sIEJJVFNfUEVSX1RZUEUodTY0KSkgLw0KPiBCSVRTX1BF
Ul9CWVRFKQ0KPiA+DQo+ID4gIC8qDQo+ID4gQEAgLTE5MjksNiArMTkzNCwxMyBAQCBzdGF0aWMg
dm9pZCB2ZmlvX2lvbW11X2lvdmFfaW5zZXJ0X2NvcHkoc3RydWN0DQo+IHZmaW9faW9tbXUgKmlv
bW11LA0KPiA+DQo+ID4gIAlsaXN0X3NwbGljZV90YWlsKGlvdmFfY29weSwgaW92YSk7DQo+ID4g
IH0NCj4gPiArDQo+ID4gK3N0YXRpYyB2b2lkIHZmaW9faW9tbXVfcmVsZWFzZV9uZXN0aW5nX2lu
Zm8oc3RydWN0IHZmaW9faW9tbXUgKmlvbW11KQ0KPiA+ICt7DQo+ID4gKwlrZnJlZShpb21tdS0+
bmVzdGluZ19pbmZvKTsNCj4gPiArCWlvbW11LT5uZXN0aW5nX2luZm8gPSBOVUxMOw0KPiA+ICt9
DQo+ID4gKw0KPiA+ICBzdGF0aWMgaW50IHZmaW9faW9tbXVfdHlwZTFfYXR0YWNoX2dyb3VwKHZv
aWQgKmlvbW11X2RhdGEsDQo+ID4gIAkJCQkJIHN0cnVjdCBpb21tdV9ncm91cCAqaW9tbXVfZ3Jv
dXApDQo+ID4gIHsNCj4gPiBAQCAtMTk1OSw2ICsxOTcxLDEyIEBAIHN0YXRpYyBpbnQgdmZpb19p
b21tdV90eXBlMV9hdHRhY2hfZ3JvdXAodm9pZA0KPiAqaW9tbXVfZGF0YSwNCj4gPiAgCQl9DQo+
ID4gIAl9DQo+ID4NCj4gPiArCS8qIE5lc3RpbmcgdHlwZSBjb250YWluZXIgY2FuIGluY2x1ZGUg
b25seSBvbmUgZ3JvdXAgKi8NCj4gPiArCWlmIChpb21tdS0+bmVzdGluZyAmJiBJU19ET01BSU5f
SU5fQ09OVEFJTkVSKGlvbW11KSkgew0KPiA+ICsJCW11dGV4X3VubG9jaygmaW9tbXUtPmxvY2sp
Ow0KPiA+ICsJCXJldHVybiAtRUlOVkFMOw0KPiA+ICsJfQ0KPiA+ICsNCj4gPiAgCWdyb3VwID0g
a3phbGxvYyhzaXplb2YoKmdyb3VwKSwgR0ZQX0tFUk5FTCk7DQo+ID4gIAlkb21haW4gPSBremFs
bG9jKHNpemVvZigqZG9tYWluKSwgR0ZQX0tFUk5FTCk7DQo+ID4gIAlpZiAoIWdyb3VwIHx8ICFk
b21haW4pIHsNCj4gPiBAQCAtMjAyOSw2ICsyMDQ3LDM2IEBAIHN0YXRpYyBpbnQgdmZpb19pb21t
dV90eXBlMV9hdHRhY2hfZ3JvdXAodm9pZA0KPiAqaW9tbXVfZGF0YSwNCj4gPiAgCWlmIChyZXQp
DQo+ID4gIAkJZ290byBvdXRfZG9tYWluOw0KPiA+DQo+ID4gKwkvKiBOZXN0aW5nIGNhcCBpbmZv
IGlzIGF2YWlsYWJsZSBvbmx5IGFmdGVyIGF0dGFjaGluZyAqLw0KPiA+ICsJaWYgKGlvbW11LT5u
ZXN0aW5nKSB7DQo+ID4gKwkJc3RydWN0IGlvbW11X25lc3RpbmdfaW5mbyB0bXA7DQo+ID4gKwkJ
c3RydWN0IGlvbW11X25lc3RpbmdfaW5mbyAqaW5mbzsNCj4gPiArDQo+ID4gKwkJLyogRmlyc3Qg
Z2V0IHRoZSBzaXplIG9mIHZlbmRvciBzcGVjaWZpYyBuZXN0aW5nIGluZm8gKi8NCj4gPiArCQly
ZXQgPSBpb21tdV9kb21haW5fZ2V0X2F0dHIoZG9tYWluLT5kb21haW4sDQo+ID4gKwkJCQkJICAg
IERPTUFJTl9BVFRSX05FU1RJTkcsDQo+ID4gKwkJCQkJICAgICZ0bXApOw0KPiA+ICsJCWlmIChy
ZXQpDQo+ID4gKwkJCWdvdG8gb3V0X2RldGFjaDsNCj4gPiArDQo+ID4gKwkJaW5mbyA9IGt6YWxs
b2ModG1wLnNpemUsIEdGUF9LRVJORUwpOw0KPiA+ICsJCWlmICghaW5mbykgew0KPiA+ICsJCQly
ZXQgPSAtRU5PTUVNOw0KPiA+ICsJCQlnb3RvIG91dF9kZXRhY2g7DQo+ID4gKwkJfQ0KPiA+ICsN
Cj4gPiArCQkvKiBOb3cgZ2V0IHRoZSBuZXN0aW5nIGluZm8gKi8NCj4gPiArCQlpbmZvLT5zaXpl
ID0gdG1wLnNpemU7DQo+ID4gKwkJcmV0ID0gaW9tbXVfZG9tYWluX2dldF9hdHRyKGRvbWFpbi0+
ZG9tYWluLA0KPiA+ICsJCQkJCSAgICBET01BSU5fQVRUUl9ORVNUSU5HLA0KPiA+ICsJCQkJCSAg
ICBpbmZvKTsNCj4gPiArCQlpZiAocmV0KSB7DQo+ID4gKwkJCWtmcmVlKGluZm8pOw0KPiA+ICsJ
CQlnb3RvIG91dF9kZXRhY2g7DQo+ID4gKwkJfQ0KPiA+ICsJCWlvbW11LT5uZXN0aW5nX2luZm8g
PSBpbmZvOw0KPiA+ICsJfQ0KPiA+ICsNCj4gPiAgCS8qIEdldCBhcGVydHVyZSBpbmZvICovDQo+
ID4gIAlpb21tdV9kb21haW5fZ2V0X2F0dHIoZG9tYWluLT5kb21haW4sIERPTUFJTl9BVFRSX0dF
T01FVFJZLA0KPiAmZ2VvKTsNCj4gPg0KPiA+IEBAIC0yMTM4LDYgKzIxODYsNyBAQCBzdGF0aWMg
aW50IHZmaW9faW9tbXVfdHlwZTFfYXR0YWNoX2dyb3VwKHZvaWQNCj4gKmlvbW11X2RhdGEsDQo+
ID4gIAlyZXR1cm4gMDsNCj4gPg0KPiA+ICBvdXRfZGV0YWNoOg0KPiA+ICsJdmZpb19pb21tdV9y
ZWxlYXNlX25lc3RpbmdfaW5mbyhpb21tdSk7DQo+ID4gIAl2ZmlvX2lvbW11X2RldGFjaF9ncm91
cChkb21haW4sIGdyb3VwKTsNCj4gPiAgb3V0X2RvbWFpbjoNCj4gPiAgCWlvbW11X2RvbWFpbl9m
cmVlKGRvbWFpbi0+ZG9tYWluKTsNCj4gPiBAQCAtMjMzOCw2ICsyMzg3LDggQEAgc3RhdGljIHZv
aWQgdmZpb19pb21tdV90eXBlMV9kZXRhY2hfZ3JvdXAodm9pZA0KPiAqaW9tbXVfZGF0YSwNCj4g
PiAgCQkJCQl2ZmlvX2lvbW11X3VubWFwX3VucGluX2FsbChpb21tdSk7DQo+ID4gIAkJCQllbHNl
DQo+ID4NCj4gCXZmaW9faW9tbXVfdW5tYXBfdW5waW5fcmVhY2NvdW50KGlvbW11KTsNCj4gPiAr
DQo+ID4gKwkJCQl2ZmlvX2lvbW11X3JlbGVhc2VfbmVzdGluZ19pbmZvKGlvbW11KTsNCj4gPiAg
CQkJfQ0KPiA+ICAJCQlpb21tdV9kb21haW5fZnJlZShkb21haW4tPmRvbWFpbik7DQo+ID4gIAkJ
CWxpc3RfZGVsKCZkb21haW4tPm5leHQpOw0KPiA+IEBAIC0yNTQ2LDYgKzI1OTcsMzAgQEAgc3Rh
dGljIGludCB2ZmlvX2lvbW11X21pZ3JhdGlvbl9idWlsZF9jYXBzKHN0cnVjdA0KPiB2ZmlvX2lv
bW11ICppb21tdSwNCj4gPiAgCXJldHVybiB2ZmlvX2luZm9fYWRkX2NhcGFiaWxpdHkoY2Fwcywg
JmNhcF9taWcuaGVhZGVyLCBzaXplb2YoY2FwX21pZykpOw0KPiA+ICB9DQo+ID4NCj4gPiArc3Rh
dGljIGludCB2ZmlvX2lvbW11X2luZm9fYWRkX25lc3RpbmdfY2FwKHN0cnVjdCB2ZmlvX2lvbW11
ICppb21tdSwNCj4gPiArCQkJCQkgICBzdHJ1Y3QgdmZpb19pbmZvX2NhcCAqY2FwcykNCj4gPiAr
ew0KPiA+ICsJc3RydWN0IHZmaW9faW5mb19jYXBfaGVhZGVyICpoZWFkZXI7DQo+ID4gKwlzdHJ1
Y3QgdmZpb19pb21tdV90eXBlMV9pbmZvX2NhcF9uZXN0aW5nICpuZXN0aW5nX2NhcDsNCj4gPiAr
CXNpemVfdCBzaXplOw0KPiA+ICsNCj4gPiArCXNpemUgPSBzaXplb2YoKm5lc3RpbmdfY2FwKSAr
IGlvbW11LT5uZXN0aW5nX2luZm8tPnNpemU7DQo+ID4gKw0KPiA+ICsJaGVhZGVyID0gdmZpb19p
bmZvX2NhcF9hZGQoY2Fwcywgc2l6ZSwNCj4gPiArCQkJCSAgIFZGSU9fSU9NTVVfVFlQRTFfSU5G
T19DQVBfTkVTVElORywgMSk7DQo+ID4gKwlpZiAoSVNfRVJSKGhlYWRlcikpDQo+ID4gKwkJcmV0
dXJuIFBUUl9FUlIoaGVhZGVyKTsNCj4gPiArDQo+ID4gKwluZXN0aW5nX2NhcCA9IGNvbnRhaW5l
cl9vZihoZWFkZXIsDQo+ID4gKwkJCQkgICBzdHJ1Y3QgdmZpb19pb21tdV90eXBlMV9pbmZvX2Nh
cF9uZXN0aW5nLA0KPiA+ICsJCQkJICAgaGVhZGVyKTsNCj4gPiArDQo+ID4gKwltZW1jcHkoJm5l
c3RpbmdfY2FwLT5pbmZvLCBpb21tdS0+bmVzdGluZ19pbmZvLA0KPiA+ICsJICAgICAgIGlvbW11
LT5uZXN0aW5nX2luZm8tPnNpemUpOw0KPiA+ICsNCj4gPiArCXJldHVybiAwOw0KPiA+ICt9DQo+
ID4gKw0KPiA+ICBzdGF0aWMgaW50IHZmaW9faW9tbXVfdHlwZTFfZ2V0X2luZm8oc3RydWN0IHZm
aW9faW9tbXUgKmlvbW11LA0KPiA+ICAJCQkJICAgICB1bnNpZ25lZCBsb25nIGFyZykNCj4gPiAg
ew0KPiA+IEBAIC0yNTg2LDYgKzI2NjEsMTIgQEAgc3RhdGljIGludCB2ZmlvX2lvbW11X3R5cGUx
X2dldF9pbmZvKHN0cnVjdA0KPiB2ZmlvX2lvbW11ICppb21tdSwNCj4gPiAgCWlmIChyZXQpDQo+
ID4gIAkJcmV0dXJuIHJldDsNCj4gPg0KPiA+ICsJaWYgKGlvbW11LT5uZXN0aW5nX2luZm8pIHsN
Cj4gPiArCQlyZXQgPSB2ZmlvX2lvbW11X2luZm9fYWRkX25lc3RpbmdfY2FwKGlvbW11LCAmY2Fw
cyk7DQo+IEkgdGhpbmsgdGhpcyBzaG91bGQgaGFwcGVuIHdoaWxlIGhvbGRpbmcgdGhlICZpb21t
dS0+bG9jayBiZWNhdXNlDQo+IG5vdGhpbmcgcHJldmVudHMgdGhlIGdyb3VwIGZyb20gYmVpbmcg
ZGV0YWNoZWQgaW4tYmV0d2Vlbg0KDQp5ZXMsIHlvdSdyZSByaWdodC4gd2lsbCBjb3JyZWN0IGl0
Lg0KDQpSZWdhcmRzLA0KWWkgTGl1DQoNCj4gVGhhbmtzDQo+IA0KPiBFcmljDQo+ID4gKwkJaWYg
KHJldCkNCj4gPiArCQkJcmV0dXJuIHJldDsNCj4gPiArCX0NCj4gPiArDQo+ID4gIAlpZiAoY2Fw
cy5zaXplKSB7DQo+ID4gIAkJaW5mby5mbGFncyB8PSBWRklPX0lPTU1VX0lORk9fQ0FQUzsNCj4g
Pg0KPiA+IGRpZmYgLS1naXQgYS9pbmNsdWRlL3VhcGkvbGludXgvdmZpby5oIGIvaW5jbHVkZS91
YXBpL2xpbnV4L3ZmaW8uaA0KPiA+IGluZGV4IDkyMDQ3MDUuLjNlM2RlOWMgMTAwNjQ0DQo+ID4g
LS0tIGEvaW5jbHVkZS91YXBpL2xpbnV4L3ZmaW8uaA0KPiA+ICsrKyBiL2luY2x1ZGUvdWFwaS9s
aW51eC92ZmlvLmgNCj4gPiBAQCAtMTAzOSw2ICsxMDM5LDIyIEBAIHN0cnVjdCB2ZmlvX2lvbW11
X3R5cGUxX2luZm9fY2FwX21pZ3JhdGlvbiB7DQo+ID4gIAlfX3U2NAltYXhfZGlydHlfYml0bWFw
X3NpemU7CQkvKiBpbiBieXRlcyAqLw0KPiA+ICB9Ow0KPiA+DQo+ID4gKyNkZWZpbmUgVkZJT19J
T01NVV9UWVBFMV9JTkZPX0NBUF9ORVNUSU5HICAzDQo+ID4gKw0KPiA+ICsvKg0KPiA+ICsgKiBS
ZXBvcnRpbmcgbmVzdGluZyBpbmZvIHRvIHVzZXIgc3BhY2UuDQo+ID4gKyAqDQo+ID4gKyAqIEBp
bmZvOgl0aGUgbmVzdGluZyBpbmZvIHByb3ZpZGVkIGJ5IElPTU1VIGRyaXZlci4gVG9kYXkNCj4g
PiArICoJCWl0IGlzIGV4cGVjdGVkIHRvIGJlIGEgc3RydWN0IGlvbW11X25lc3RpbmdfaW5mbw0K
PiA+ICsgKgkJZGF0YS4NCj4gPiArICovDQo+ID4gK3N0cnVjdCB2ZmlvX2lvbW11X3R5cGUxX2lu
Zm9fY2FwX25lc3Rpbmcgew0KPiA+ICsJc3RydWN0CXZmaW9faW5mb19jYXBfaGVhZGVyIGhlYWRl
cjsNCj4gPiArCV9fdTMyCWZsYWdzOw0KPiA+ICsJX191MzIJcGFkZGluZzsNCj4gPiArCV9fdTgJ
aW5mb1tdOw0KPiA+ICt9Ow0KPiA+ICsNCj4gPiAgI2RlZmluZSBWRklPX0lPTU1VX0dFVF9JTkZP
IF9JTyhWRklPX1RZUEUsIFZGSU9fQkFTRSArIDEyKQ0KPiA+DQo+ID4gIC8qKg0KPiA+DQoNCg==
