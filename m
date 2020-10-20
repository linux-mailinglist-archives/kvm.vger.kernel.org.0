Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F41B2293855
	for <lists+kvm@lfdr.de>; Tue, 20 Oct 2020 11:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393054AbgJTJkk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 05:40:40 -0400
Received: from mga05.intel.com ([192.55.52.43]:20115 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730911AbgJTJkj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Oct 2020 05:40:39 -0400
IronPort-SDR: c8qKB0YqeRy5ok87jYpDV0Y7BRPpAy/ABakpNVjqc9bYb2rm3BHQGFFh6G6zFC4HhcFRSBV++I
 Ea0BrUkxKYwg==
X-IronPort-AV: E=McAfee;i="6000,8403,9779"; a="251877256"
X-IronPort-AV: E=Sophos;i="5.77,396,1596524400"; 
   d="scan'208";a="251877256"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2020 02:40:39 -0700
IronPort-SDR: FWo3kPNaOONQagw9Vj4JKGhw9u3YgC8eGCo5AS9IukMq+61rYt9ZDiTnfbiGrN4txa0MI8R7/0
 YZL6DASVVvTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,396,1596524400"; 
   d="scan'208";a="347799112"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga004.fm.intel.com with ESMTP; 20 Oct 2020 02:40:39 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 20 Oct 2020 02:40:38 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 20 Oct 2020 02:40:38 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 20 Oct 2020 02:40:38 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Tue, 20 Oct 2020 02:40:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KXl8E3rgQ/0UOE6ge65qVXVPyBf1hxby5O6bhk2TkfrgfByArp/kpCScR6iYT9Grpmzvqu0RciDRVEji2Jw7ts6YlLZhm1j7Z328NQCDFTso3bJJOjV+Zei2BaAhM0DoK1e7cLgGoHA2DzQQM9gkC3hAj/OWVtVQokKEhP5I6kt2H0u0gt7bRYoB+x4upQtReiPhaKOAuLl2FhKC/YYjDAHXaHpD7m5xwLlgfIuc3L0UMt9dKjCzUHcH1/ncw0EWxGuPyFWWpuw+I8zUa9yXAXlHxyHYJGjpP+9kVxpBGljf/q/eEbl0SXjzvE6ho8xRlkKlSjXdw/hBkPeQ3Bj1Bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZtMidOIPRBkK3ufSbTAxkwRLURaJUSRuNTLp4pHpoxQ=;
 b=gDV4+Pr001C6JhLzTbyYeSl55OhIY3Qzit8vrC7exbSUgy1IXc5Dt6qLja7tlKjL+TvfrasyvI1l4/FTgaYMUnjPY3NiCff4GroI496DtZEPVSk2SKoqgrUF2Vlz8/Lj+dm0d5ss1fKIVuuOP4if62zyruBDpcRkl/PEaE6bzysml3X2bJgy2xALLK3zHySJXK1zIiyyjp7MvJV1tIyTCFcxtlwP1Xk1w5bf5e7td+Gm/vIgTI/JXfaeDKGN1ETiPFyR5f6EuVTyo75RKP113lR5sViOTEmtbQAuT7wOHxl/Q8783AVyilW2bAP04G5ACKkJ/49BHGaFrjGlTb+gEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZtMidOIPRBkK3ufSbTAxkwRLURaJUSRuNTLp4pHpoxQ=;
 b=saQqukmzlgqF7keE81ZwX3FBlCQQa0Ypzl5eowv3wqDdD5Wlkia62WPWxjejZlhza05JEjoOnLO2x4sXuO7FBhduh1kEWDNwDbh2JuymPRQnkdNIpH3OjmE6TBOyy2xo0Ng77Zh89q1xnluBmzx+2PGVj0SVisolXhwLD+0XvSI=
Received: from DM5PR11MB1435.namprd11.prod.outlook.com (2603:10b6:4:7::18) by
 DM6PR11MB4076.namprd11.prod.outlook.com (2603:10b6:5:197::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3477.23; Tue, 20 Oct 2020 09:40:15 +0000
Received: from DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::a1ec:ba6b:5057:be2f]) by DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::a1ec:ba6b:5057:be2f%11]) with mapi id 15.20.3477.028; Tue, 20 Oct
 2020 09:40:15 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Wang <jasowang@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>
CC:     "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Wu, Hao" <hao.wu@intel.com>,
        "stefanha@gmail.com" <stefanha@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: RE: (proposal) RE: [PATCH v7 00/16] vfio: expose virtual Shared
 Virtual Addressing to VMs
Thread-Topic: (proposal) RE: [PATCH v7 00/16] vfio: expose virtual Shared
 Virtual Addressing to VMs
Thread-Index: AdagceQQLvqwjRCrQOaq1hZ7MgDUUAAt0sKAACmGxcAAPBsbAAAARpcAAAOFkAAAAwCSQADzeAMAAANpJxAAAu+FgAAAOEXw
Date:   Tue, 20 Oct 2020 09:40:14 +0000
Message-ID: <DM5PR11MB143545475500159AD958F006C31F0@DM5PR11MB1435.namprd11.prod.outlook.com>
References: <MWHPR11MB1645CFB0C594933E92A844AC8C070@MWHPR11MB1645.namprd11.prod.outlook.com>
 <45faf89a-0a40-2a7a-0a76-d7ba76d0813b@redhat.com>
 <MWHPR11MB1645CF252CF3493F4A9487508C050@MWHPR11MB1645.namprd11.prod.outlook.com>
 <9c10b681-dd7e-2e66-d501-7fcc3ff1207a@redhat.com>
 <MWHPR11MB164501E77BDB0D5AABA8487F8C020@MWHPR11MB1645.namprd11.prod.outlook.com>
 <21a66a96-4263-7df2-3bec-320e6f38a9de@redhat.com>
 <DM5PR11MB143531293E4D65028801FDA1C3020@DM5PR11MB1435.namprd11.prod.outlook.com>
 <a43d47f5-320b-ef60-e2be-a797942ea9f2@redhat.com>
 <DM5PR11MB1435D55CAE858CC8EC2AFA47C31F0@DM5PR11MB1435.namprd11.prod.outlook.com>
 <6e478a9e-2051-c0cd-b6fd-624ff5ef0f53@redhat.com>
In-Reply-To: <6e478a9e-2051-c0cd-b6fd-624ff5ef0f53@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [221.220.190.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d76d8ba8-2111-442c-5a80-08d874dc25f5
x-ms-traffictypediagnostic: DM6PR11MB4076:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB40765EC06FBA335B17647069C31F0@DM6PR11MB4076.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rkBouEMlMZsPD7JC1722X67xfLPdikFeLfamOO306b2irudkN7TzMx8/PPMZAEmSMbWiS5gsWj2QD8V5EWHCqdCyeUAnoVCkXMiEt+PCLvEuD5WtWKPOgIagQzsuave7qVzlIF+IfFwMfD1n/2ITLvtare+nJOTgDes5pl8LsQTCNNHurlm1Jp8pIh80bXNjsuU4y7KdC2FV3pYKmHPjRUFN1V2FVBmUz+UBSuutrLrZIOtvGYmDtMCvRJDUTYTEE5dStkI3a74fLnDYOH9evyoM5edw0fWjVEZGJsOvCZz3kqOAFEXCy4Wd4ZFVA3FWgP2bPbUqngdrUJ6HRq+omA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1435.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(376002)(346002)(396003)(366004)(55016002)(186003)(110136005)(316002)(2906002)(8676002)(6506007)(33656002)(9686003)(54906003)(26005)(7416002)(86362001)(71200400001)(52536014)(4326008)(7696005)(66946007)(76116006)(83380400001)(66556008)(66476007)(64756008)(5660300002)(8936002)(66446008)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: CJ3XYX40/h9GqY6d+ywJARgyzCjwtbhVjI6L4sHDIO8FclY1vcvwaE01jJYZ1Q4zHBWsYbnusy7y+KnGQQqSVN+WoETBPqneNSXy+h2S1C70vTeCtxGx8022WWLGpIZBt+m/VgQQ1W/YttBYSlGtNinlDQhc/RoL/92XC5z9UQcVg2pSBSfAWPrYexeN8GYXOkD3SmBqPhG3IlzELiR69Z9BbZGTpq5alx2ZTxmOm6T54m+MfmQ7HtB7EHH63d22uI8A+4t3dGDYacjck4/2oQFHKFAXZVgGP7c2nSTEFvdKGk5wv32/fvCKLy5bbTupMB703YkPa0lMrgT4ZGDVZAH1cBbFjlLqWrQZd0LB0Txh1+w9nkbqwL8sPEiDS9jMOd0o+hqZo21Ku89ukTn/04QfXLJVXg06lAoG/1mkkx8rQ0GCctuOtQVP83UfiKOIOjh1UJLlvQu+U+zLEFUyIPcNzxpO1ED52UxZL8qFaYgQx7C3kK+RzGJbiKG/tvJQGzIE/zaTSEA3iVsDVdkG8yUjd+ivOcpmm5awdvOJtOF01AT2isPakPDzEW2VHzaArlKw3oik/EidOGEiev8FBdqbcQBoJGqjDQqOwTOakuWot03Px3iX02F+IFVrc8eWSEfoP4XGykYEDjTQvK5HfA==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1435.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d76d8ba8-2111-442c-5a80-08d874dc25f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2020 09:40:14.8500
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kyiB9rHf2vCC+0jwP9gAcfDRTS6XY/rSLPCYjsHFp3IRQlvzvDQTSW5ssXBq/vICdJhyEFDuSP6SZcUyzRHHcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4076
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBKYXNvbiBXYW5nIDxqYXNvd2FuZ0ByZWRoYXQuY29tPg0KPiBTZW50OiBUdWVzZGF5
LCBPY3RvYmVyIDIwLCAyMDIwIDU6MjAgUE0NCj4gDQo+IEhpIFlpOg0KPiANCj4gT24gMjAyMC8x
MC8yMCA/PzQ6MTksIExpdSwgWWkgTCB3cm90ZToNCj4gPj4gWWVzLCBidXQgc2luY2UgUEFTSUQg
aXMgYSBnbG9iYWwgaWRlbnRpZmllciBub3csIEkgdGhpbmsga2VybmVsDQo+ID4+IHNob3VsZCB0
cmFjayB0aGUgYSBkZXZpY2UgbGlzdCBwZXIgUEFTSUQ/DQo+ID4gV2UgaGF2ZSBzdWNoIHRyYWNr
LiBJdCdzIGRvbmUgaW4gaW9tbXUgZHJpdmVyLiBZb3UgY2FuIHJlZmVyIHRvIHRoZQ0KPiA+IHN0
cnVjdCBpbnRlbF9zdm0uIFBBU0lEIGlzIGEgZ2xvYmFsIGlkZW50aWZpZXIsIGJ1dCBpdCBkb2Vz
buKAmXQgYWZmZWN0DQo+ID4gdGhhdCB0aGUgUEFTSUQgdGFibGUgaXMgcGVyLWRldmljZS4NCj4g
Pg0KPiA+PiBTbyBmb3Igc3VjaCBiaW5kaW5nLCBQQVNJRCBzaG91bGQgYmUNCj4gPj4gc3VmZmlj
aWVudCBmb3IgdUFQSS4NCj4gPiBub3QgcXVpdGUgZ2V0IGl0LiBQQVNJRCBtYXkgYmUgYm91bmQg
dG8gbXVsdGlwbGUgZGV2aWNlcywgaG93IGRvIHlvdQ0KPiA+IGZpZ3VyZSBvdXQgdGhlIHRhcmdl
dCBkZXZpY2UgaWYgeW91IGRvbuKAmXQgcHJvdmlkZSBzdWNoIGluZm8uDQo+IA0KPiANCj4gSSBt
YXkgbWlzcyBzb2VtdGhpbmcgYnV0IGlzIHRoZXJlIGFueSByZWFzb24gdGhhdCB1c2Vyc3BhY2Ug
bmVlZCB0byBmaWd1cmUgb3V0DQo+IHRoZSB0YXJnZXQgZGV2aWNlPyBQQVNJRCBpcyBhYm91dCBh
ZGRyZXNzIHNwYWNlIG5vdCBhIHNwZWNpZmljIGRldmljZSBJIHRoaW5rLg0KDQpJZiB5b3UgaGF2
ZSBtdWx0aXBsZSBkZXZpY2VzIGFzc2lnbmVkIHRvIGEgVk0sIHlvdSB3b24ndCBleHBlY3QgdG8g
YmluZCBhbGwNCm9mIHRoZW0gdG8gYSBQQVNJRCBpbiBhIHNpbmdsZSBiaW5kIG9wZXJhdGlvbiwg
cmlnaHQ/IHlvdSBtYXkgd2FudCB0byBiaW5kDQpvbmx5IHRoZSBkZXZpY2VzIHlvdSByZWFsbHkg
bWVhbi4gVGhpcyBtYW5uZXIgc2hvdWxkIGJlIG1vcmUgZmxleGlibGUgYW5kDQpyZWFzb25hYmxl
LiA6LSkNCg0KPiANCj4gPg0KPiA+Pj4+PiBUaGUgYmluZGluZyByZXF1ZXN0IGlzIGluaXRpYXRl
ZCBieSB0aGUgdmlydHVhbCBJT01NVSwgd2hlbg0KPiA+Pj4+PiBjYXB0dXJpbmcgZ3Vlc3QgYXR0
ZW1wdCBvZiBiaW5kaW5nIHBhZ2UgdGFibGUgdG8gYSB2aXJ0dWFsIFBBU0lEDQo+ID4+Pj4+IGVu
dHJ5IGZvciBhIGdpdmVuIGRldmljZS4NCj4gPj4+PiBBbmQgZm9yIEwyIHBhZ2UgdGFibGUgcHJv
Z3JhbW1pbmcsIGlmIFBBU0lEIGlzIHVzZSBieSBib3RoIGUuZyBWRklPDQo+ID4+Pj4gYW5kIHZE
UEEsIHVzZXIgbmVlZCB0byBjaG9vc2Ugb25lIG9mIHVBUEkgdG8gYnVpbGQgbDIgbWFwcGluZ3M/
DQo+ID4+PiBmb3IgTDIgcGFnZSB0YWJsZSBtYXBwaW5ncywgaXQncyBkb25lIGJ5IFZGSU8gTUFQ
L1VOTUFQLiBmb3IgdmRwYSwgSQ0KPiA+Pj4gZ3Vlc3MgaXQgaXMgdGxiIGZsdXNoLiBzbyB5b3Ug
YXJlIHJpZ2h0LiBLZWVwaW5nIEwxL0wyIHBhZ2UgdGFibGUNCj4gPj4+IG1hbmFnZW1lbnQgaW4g
YSBzaW5nbGUgdUFQSSBzZXQgaXMgYWxzbyBhIHJlYXNvbiBmb3IgbXkgY3VycmVudA0KPiA+Pj4g
c2VyaWVzIHdoaWNoIGV4dGVuZHMgVkZJTyBmb3IgTDEgbWFuYWdlbWVudC4NCj4gPj4gSSdtIGFm
cmFpZCB0aGF0IHdvdWxkIGludHJvZHVjZSBjb25mdXNpbmcgdG8gdXNlcnNwYWNlLiBFLmc6DQo+
ID4+DQo+ID4+IDEpIHdoZW4gaGF2aW5nIG9ubHkgdkRQQSBkZXZpY2UsIGl0IHVzZXMgdkRQQSB1
QVBJIHRvIGRvIGwyDQo+ID4+IG1hbmFnZW1lbnQNCj4gPj4gMikgd2hlbiB2RFBBIHNoYXJlcyBQ
QVNJRCB3aXRoIFZGSU8sIGl0IHdpbGwgdXNlIFZGSU8gdUFQSSB0byBkbyB0aGUNCj4gPj4gbDIg
bWFuYWdlbWVudD8NCj4gPiBJIHRoaW5rIHZEUEEgd2lsbCBzdGlsbCB1c2UgaXRzIG93biBsMiBm
b3IgdGhlIGwyIG1hcHBpbmdzLiBub3Qgc3VyZQ0KPiA+IHdoeSB5b3UgbmVlZCB2RFBBIHVzZSBW
RklPJ3MgbDIgbWFuYWdlbWVudC4gSSBkb24ndCB0aGluayBpdCBpcyB0aGUgY2FzZS4NCj4gDQo+
IA0KPiBTZWUgcHJldmlvdXMgZGlzY3Vzc2lvbiB3aXRoIEtldmluLiBJZiBJIHVuZGVyc3RhbmQg
Y29ycmVjdGx5LCB5b3UgZXhwZWN0IGEgc2hhcmVkDQo+IEwyIHRhYmxlIGlmIHZEUEEgYW5kIFZG
SU8gZGV2aWNlIGFyZSB1c2luZyB0aGUgc2FtZSBQQVNJRC4NCg0KTDIgdGFibGUgc2hhcmluZyBp
cyBub3QgbWFuZGF0b3J5LiBUaGUgbWFwcGluZyBpcyB0aGUgc2FtZSwgYnV0IG5vIG5lZWQgdG8N
CmFzc3VtZSBMMiB0YWJsZXMgYXJlIHNoYXJlZC4gRXNwZWNpYWxseSBmb3IgVkZJTy92RFBBIGRl
dmljZXMuIEV2ZW4gd2l0aGluDQphIHBhc3N0aHJ1IGZyYW1ld29yaywgbGlrZSBWRklPLCBpZiB0
aGUgYXR0cmlidXRlcyBvZiBiYWNrZW5kIElPTU1VIGFyZSBub3QNCnRoZSBzYW1lLCB0aGUgTDIg
cGFnZSB0YWJsZSBhcmUgbm90IHNoYXJlZCwgYnV0IHRoZSBtYXBwaW5nIGlzIHRoZSBzYW1lLg0K
DQo+IEluIHRoaXMgY2FzZSwgaWYgbDIgaXMgc3RpbGwgbWFuYWdlZCBzZXBhcmF0ZWx5LCB0aGVy
ZSB3aWxsIGJlIGR1cGxpY2F0ZWQgcmVxdWVzdCBvZg0KPiBtYXAgYW5kIHVubWFwLg0KDQp5ZXMs
IGJ1dCB0aGlzIGlzIG5vdCBhIGZ1bmN0aW9uYWwgaXNzdWUsIHJpZ2h0PyBJZiB3ZSB3YW50IHRv
IHNvbHZlIGl0LCB3ZQ0Kc2hvdWxkIGhhdmUgYSBzaW5nbGUgdUFQSSBzZXQgd2hpY2ggY2FuIGhh
bmRsZSBib3RoIEwxIGFuZCBMMiBtYW5hZ2VtZW50Lg0KVGhhdCdzIGFsc28gd2h5IHlvdSBwcm9w
b3NlZCB0byByZXBsYWNlIHR5cGUxIGRyaXZlci4gcmlnaHQ/DQoNClJlZ2FyZHMsDQpZaSBMaXUN
Cg0KPiANCj4gVGhhbmtzDQo+IA0KPiANCj4gPg0KPiA+IFJlZ2FyZHMsDQo+ID4gWWkgTGl1DQo+
ID4NCg0K
