Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23A01228E91
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 05:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731960AbgGVDYt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 23:24:49 -0400
Received: from mga17.intel.com ([192.55.52.151]:17794 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731857AbgGVDYr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jul 2020 23:24:47 -0400
IronPort-SDR: jb6XrvRsJlxNHXV/e/q/fVm2QuPxsEh4/b0tLIk1YF+cbjdfxyM9+jXsGBK07FmIYaXrIywsid
 vzbPMBU50VAg==
X-IronPort-AV: E=McAfee;i="6000,8403,9689"; a="130347524"
X-IronPort-AV: E=Sophos;i="5.75,381,1589266800"; 
   d="scan'208";a="130347524"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2020 20:24:43 -0700
IronPort-SDR: E+ObgITDP9dPKS4+6dG+GwbtIHjVtDacLmza+ta3uifuHTUJq3+c2sCbow1m+Yb6G7Etvo+p4F
 G73StCD5G6AQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,381,1589266800"; 
   d="scan'208";a="284084320"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by orsmga003.jf.intel.com with ESMTP; 21 Jul 2020 20:24:42 -0700
Received: from fmsmsx151.amr.corp.intel.com (10.18.125.4) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 21 Jul 2020 20:24:41 -0700
Received: from FMSEDG001.ED.cps.intel.com (10.1.192.133) by
 FMSMSX151.amr.corp.intel.com (10.18.125.4) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 21 Jul 2020 20:24:41 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Tue, 21 Jul 2020 20:24:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ndD996P6UrSUmlIAx90Z2P9uynrT1bBvVK9orb2q08+r7ymjWlJ62ylyGLClrFcqnK6sfxjygSqbmWWyIMn3eqvdBaCHcZ+PqYdWTadarIE+CALW1PVU08Rfif7kPlghKiAhpiL0NX0JhYdW09aZPBoEkPFxlPtNrN/KkJXvvoBGNyOfARJY3czhaCA52h0vofSQYidt6V+AfvNol95+uVV5wsZtXrbUH08/HVl8JNhHNXZNdAdHF1zOqBKKJG4912O7mLx9nyuG8KWqkRDNqZpmy8sDihsqBnDiSSddhB4aW86R6CzLg1gE+KtpvDBAWMifsuFbaegJ3fPT4IpBHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VJgCtWYGa+JwFR6xg0e8TD8FPlu1X7s3VqD5RabJF/4=;
 b=LeXrchMdm0GZxLou4RUe9gATj30oEkLuE/mQyTK7kXAC4Boh9AVL3/lBd5fMgrvM0v7RbeFgIKIlROUoJgOY+XIoPMt2f9TZ9nzREl7lsUSkQz7HPkaNFdws610CYoE7usPRdDd0E4tNHS52jnv1wgfmiCsTQSI2WY2ru/QgEtjj8Ln+rz5KH7oVWNa0wRRO231q4GLmDTzglZprUZVtl6QQjoodtC3UfYjk2jHrVWTF8Xe1hPgRk4tH2leCabcfshy0i85Uf9yWnfTH3LBbiFOkN2E8oeli+N4dunBqTHxL6q6B0sy1Dju4KpV3F5u4MnULtUgWWJ+BEv/Lsmb/ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VJgCtWYGa+JwFR6xg0e8TD8FPlu1X7s3VqD5RabJF/4=;
 b=y6nVkzNDbUCvouogBZVifiFtFCGIJD7vBkIS87GkooWk+iyQ2iSByX9HRZP+G6FABVxJmYVOsafQXNP0XD5Jo6KL1A5LpBPsbKcUDiJL/WGqcOeHzMIhJ7UdgAmM/7CoM4IsdRlDNdYMQjd1PiGDSMMY44c4xUSzhrOmbA2v+f8=
Received: from MWHPR11MB1645.namprd11.prod.outlook.com (2603:10b6:301:b::12)
 by MWHPR11MB1391.namprd11.prod.outlook.com (2603:10b6:300:23::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.21; Wed, 22 Jul
 2020 03:24:39 +0000
Received: from MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::9864:e0cb:af36:6feb]) by MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::9864:e0cb:af36:6feb%5]) with mapi id 15.20.3195.028; Wed, 22 Jul 2020
 03:24:39 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Xiang Zheng <zhengxiang9@huawei.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     Kirti Wankhede <kwankhede@nvidia.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>,
        "Yang, Ziye" <ziye.yang@intel.com>,
        "Liu, Changpeng" <changpeng.liu@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
        "eskultet@redhat.com" <eskultet@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "jonathan.davies@nutanix.com" <jonathan.davies@nutanix.com>,
        "eauger@redhat.com" <eauger@redhat.com>,
        "aik@ozlabs.ru" <aik@ozlabs.ru>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "felipe@nutanix.com" <felipe@nutanix.com>,
        "Zhengxiao.zx@Alibaba-inc.com" <Zhengxiao.zx@Alibaba-inc.com>,
        "shuangtai.tst@alibaba-inc.com" <shuangtai.tst@alibaba-inc.com>,
        "Ken.Xue@amd.com" <Ken.Xue@amd.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Wang Haibin <wanghaibin.wang@huawei.com>
Subject: RE: [PATCH Kernel v24 0/8] Add UAPIs to support migration for VFIO
 devices
Thread-Topic: [PATCH Kernel v24 0/8] Add UAPIs to support migration for VFIO
 devices
Thread-Index: AQHWNTOesMj3oV4z60GHhAB0JXq2KqkRpv2AgAFPMgCAAEajgIAABjAA
Date:   Wed, 22 Jul 2020 03:24:39 +0000
Message-ID: <MWHPR11MB16454E9D60B5DE71B5FAE4658C790@MWHPR11MB1645.namprd11.prod.outlook.com>
References: <1590697854-21364-1-git-send-email-kwankhede@nvidia.com>
 <450612c3-2a92-9034-7958-ee7f3c1a8c52@huawei.com>
 <20200721164304.0ce76b2e@x1.home>
 <3351a7d0-4fb1-a902-b902-a638a3d3047a@huawei.com>
In-Reply-To: <3351a7d0-4fb1-a902-b902-a638a3d3047a@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.198]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 115f56f9-21c8-49e5-7209-08d82deec48c
x-ms-traffictypediagnostic: MWHPR11MB1391:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB13912A425EDDBBFD03EBB1FA8C790@MWHPR11MB1391.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: F3LR162t+0WBLB7HohyNsR7yEEQPq0jAdtHaGwFYV2Fh02OvUFJZ+eCCsYxoXSsCxQnDkXem1ImBQM3eUSM2Rp5OLsviyAZ2ydC1fHg0jPkODFtN4hG5i8gpBKWcCxszNqnNvqVEdo+I+rK1+DhxfEe+BONnOQsrPwBxaAo77096xqB/XCTo6X3a+HIHVLlIealjgO+ltWuV06+l4AGbP/o0721D6ma6bqNnK/2L/SaDn+U2inmirEoxd3ZPBKJLGb8/aXH4tarWosaqrJ2nCHlUtn7UTP8IRJbRTvT0VFEZ3CpGf5j8bNwN+BstbSv/EzP2q6V0bxOumcr+zRyC5A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1645.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39860400002)(376002)(346002)(136003)(366004)(2906002)(186003)(76116006)(71200400001)(66946007)(83380400001)(66556008)(52536014)(33656002)(64756008)(66476007)(66446008)(9686003)(5660300002)(55016002)(53546011)(478600001)(86362001)(6506007)(7696005)(8676002)(8936002)(316002)(54906003)(110136005)(26005)(7416002)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 7UGj+7vPpaBt4RmV29N2IYgSIAsU37We/0IHp/smUdYp27cWOTylA0J+FA1FlLcw2LU61K6ttU2zpLTci5c3gxMO6hFxFMJSJiIsuAk37ZgD/VfEHNnCvJO+p2r7HkzhgqBQkvx5ucewpASa8o5SHj2teMmkcAul27YGX5rY8j1rHK4d9CXEccfxUIJ7LiRIdH2oBQafoW0zWmVcqzn7+0mgPydigLpm6qr4wuhnZNoZ2nrSBL+DIhZKUQjrkstgxqTvUQstLR8yJj+t1CDhAfg11iC69o8hiu+CpV9POT2OB4J5x/Tz0jhE/aNRrVjYKx0gjnC1r2j3bQ1/ICfTci7yaw4As40fH3pU+hrezuPiAghzXBy+tfVcztzr1i9ifnZlykxOek9sXnzQTR1/gr3QrQifo6EUlcBehk/xPASSmPZwODoDI/Nd4kJWFGqzBnoR1/gtH7as1vN+/ntXWo/Appl7PAppK/8yZ+BWYvrrspIVSMUTxkg8YJkPugD8
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1645.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 115f56f9-21c8-49e5-7209-08d82deec48c
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2020 03:24:39.5310
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0+nz0IGuJxxr/qkt8nGcY0/iG+IX9QJB6xbcxE3DouyUFipDGZOcp9faERz64xFQSCrbsdNgQb6lozmKiu25YA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1391
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBYaWFuZyBaaGVuZw0KPiBTZW50OiBXZWRuZXNkYXksIEp1bHkgMjIsIDIwMjAgMTA6
NTYgQU0NCj4gDQo+IEhpIEFsZXgsDQo+IA0KPiBUaGFuayB5b3UgZm9yIHlvdXIgc3VnZ2VzdGlv
bi4NCj4gDQo+IE9uIDIwMjAvNy8yMiA2OjQzLCBBbGV4IFdpbGxpYW1zb24gd3JvdGU6DQo+ID4g
T24gVHVlLCAyMSBKdWwgMjAyMCAxMDo0MzoyMSArMDgwMA0KPiA+IFhpYW5nIFpoZW5nIDx6aGVu
Z3hpYW5nOUBodWF3ZWkuY29tPiB3cm90ZToNCj4gPg0KPiA+PiBIaSBLaXJ0aSwNCj4gPj4NCj4g
Pj4gU29ycnkgdG8gZGlzdHVyYiB5b3Ugc2luY2UgdGhpcyBwYXRjaCBzZXQgaGFzIGJlZW4gbWVy
Z2VkLCBhbmQgSSBjYW5ub3QNCj4gPj4gcmVjZWl2ZSB0aGUgcWVtdS1zaWRlIGVtYWlscyBhYm91
dCB0aGlzIHBhdGNoIHNldC4NCj4gPj4NCj4gPj4gV2UgYXJlIGdvaW5nIHRvIHN1cHBvcnQgbWln
cmF0aW9uIGZvciBWRklPIGRldmljZXMgd2hpY2ggc3VwcG9ydCBkaXJ0eQ0KPiA+PiBwYWdlcyB0
cmFja2luZy4NCj4gPj4NCj4gPj4gQW5kIHdlIGFsc28gcGxhbiB0byBsZXZlcmFnZSBTTU1VIEhU
VFUgZmVhdHVyZSB0byBkbyB0aGUgZGlydHkgcGFnZXMNCj4gPj4gdHJhY2tpbmcgZm9yIHRoZSBk
ZXZpY2VzIHdoaWNoIGRvbid0IHN1cHBvcnQgZGlydHkgcGFnZXMgdHJhY2tpbmcuDQo+ID4+DQo+
ID4+IEZvciB0aGUgYWJvdmUgdHdvIGNhc2VzLCB3aGljaCBzaWRlIGRldGVybWluZXMgdG8gY2hv
b3NlIElPTU1VIGRyaXZlcg0KPiBvcg0KPiA+PiB2ZW5kb3IgZHJpdmVyIHRvIGRvIGRpcnR5IGJp
dG1hcCB0cmFja2luZywgUWVtdSBvciBWRklPPw0KPiA+Pg0KPiA+PiBJbiBicmllZiwgaWYgYm90
aCBJT01NVSBhbmQgVkZJTyBkZXZpY2VzIHN1cHBvcnQgZGlydHkgcGFnZXMgdHJhY2tpbmcsDQo+
ID4+IHdlIGNhbiBjaGVjayB0aGUgY2FwYWJpbGl0eSBhbmQgcHJlZmVyIHRvIHRyYWNrIGRpcnR5
IHBhZ2VzIG9uIGRldmljZQ0KPiA+PiB2ZW5kb3IgZHJpdmVyIHdoaWNoIGlzIG1vcmUgZWZmaWNp
ZW50Lg0KPiA+Pg0KPiA+PiBUaGUgcXVzZXRpb24gaXMgd2hpY2ggc2lkZSB0byBkbyB0aGUgY2hl
Y2sgYW5kIHNlbGVjdGlvbj8gSW4gbXkgb3BpbmlvbiwNCj4gPj4gUWVtdS91c2Vyc3BhY2Ugc2Vl
bXMgbW9yZSBzdWl0YWJsZS4NCj4gPg0KPiA+IERpcnR5IHBhZ2UgdHJhY2tpbmcgaXMgY29uc29s
aWRhdGVkIGF0IHRoZSB2ZmlvIGNvbnRhaW5lciBsZXZlbC4NCj4gPiBVc2Vyc3BhY2UgaGFzIG5v
IGJhc2lzIGZvciBkZXRlcm1pbmluZyBvciBpbnRlcmZhY2UgZm9yIHNlbGVjdGluZyBhDQo+ID4g
ZGlydHkgYml0bWFwIHByb3ZpZGVyLCBzbyBJIHdvdWxkIGRpc2FncmVlIHRoYXQgUUVNVSBzaG91
bGQgcGxheSBhbnkNCj4gPiByb2xlIGhlcmUuICBUaGUgY29udGFpbmVyIGRpcnR5IGJpdG1hcCB0
cmllcyB0byBwcm92aWRlIHRoZSBmaW5lc3QNCj4gPiBncmFudWxhcml0eSBhdmFpbGFibGUgYmFz
ZWQgb24gdGhlIHN1cHBvcnQgb2YgYWxsIHRoZSBkZXZpY2VzL2dyb3Vwcw0KPiA+IG1hbmFnZWQg
YnkgdGhlIGNvbnRhaW5lci4gIElmIHRoZXJlIGFyZSBncm91cHMgYXR0YWNoZWQgdG8gdGhlDQo+
ID4gY29udGFpbmVyIHRoYXQgaGF2ZSBub3QgcGFydGljaXBhdGVkIGluIHBhZ2UgcGlubmluZywg
dGhlbiB3ZSBjb25zaWRlcg0KPiA+IGFsbCBETUEgbWFwcGluZ3Mgd2l0aGluIHRoZSBjb250YWlu
ZXIgYXMgcGVyc2lzdGVudGx5IGRpcnR5LiAgT25jZSBhbGwNCj4gPiBvZiB0aGUgcGFydGljaXBh
bnRzIHN1YnNjcmliZSB0byBwYWdlIHBpbm5pbmcsIHRoZSBkaXJ0eSBzY29wZSBpcw0KPiA+IHJl
ZHVjZWQgdG8gdGhlIHBpbm5lZCBwYWdlcy4gIElPTU1VIHN1cHBvcnQgZm9yIGRpcnR5IHBhZ2Ug
bG9nZ2luZyB3b3VsZA0KPiA+IGludHJvZHVjZSBmaW5lciBncmFudWxhcml0eSB5ZXQsIHdoaWNo
IHdlIHdvdWxkIHByb2JhYmx5IHByZWZlciBvdmVyDQo+ID4gcGFnZSBwaW5uaW5nLCBidXQgaW50
ZXJmYWNlcyBmb3IgdGhpcyBoYXZlIG5vdCBiZWVuIGRldmlzZWQuDQo+IA0KPiBLZXZpbiBhbmQg
aGlzIGNvbGxlYWd1ZXMgbWF5IGFkZCB0aGVzZSBBUElzIGluIHRoZSBmdXR1cmUuDQo+IFdlIGFs
c28gcGxhbiB0byBzdXBwb3J0IHRoZXNlIGludGVyZmFjZXMgb24gU01NVSBkcml2ZXIgYW5kIGFm
dGVyd2FyZHMgd2UNCj4gY2FuIGhhdmUgYSBmdXJ0aGVyIGRpc2N1c3Npb24uDQoNClllcywgd2Ug
YXJlIHdvcmtpbmcgb24gdGhhdCBwYXJ0LiBHZW5lcmFsbHkgc3BlYWtpbmcgSSBhZ3JlZSB3aXRo
IEFsZXgNCnRoYXQgdGhlIGtlcm5lbCBzaG91bGQgZGVjaWRlIGRpcnR5IGJpdG1hcCBwcm92aWRl
ciBhbmQgSU9NTVUgZGlydHkNCmxvZ2dpbmcgaXMgbGlrZWx5IHByZWZlcnJlZCBvdmVyIHBhZ2Ug
cGlubmluZy4gUGFnZSBwaW5uaW5nIGVpdGhlciBwcm92aWRlcw0Kb25seSBjb2Fyc2UtZ3JhaW5l
ZCBkaXJ0eSBpbmZvIChlLmcuIDEwMCdzIE1CIHBpbm5lZCBwYWdlcyBvYnNlcnZlZCBpbg0KdkdQ
VSBjYXNlKSBvciB3aGVuIHJlYWNoaW5nIGZpbmVyIGdyYW51bGFyaXR5IGl0IG1heSBhZmZlY3Qg
ZmFzdC1wYXRoIA0KcGVyZm9ybWFuY2UgKGUuZy4gZHJpdmVyIG1heSBoYXZlIHRvIGludGVyY2Vw
dCBmYXN0LXBhdGggb3BlcmF0aW9ucyB0bw0KdHJhY2sgZGlydGllZCBwYWdlcyBjbG9zZWx5KS4g
SU9NTVUgcHJvdmlkZXMgYW4gYXJjaGl0ZWN0dXJhbCBhbmQNCmxpZ2h0ZXIgYXBwcm9hY2ggZm9y
IHRyYWNraW5nIGRpcnR5IHBhZ2VzLg0KDQpUaGFua3MNCktldmluDQoNCj4gDQo+ID4NCj4gPiBJ
ZGVhbGx5IHVzZXJzcGFjZSBzaG91bGQgYmUgdW5hd2FyZSBvZiBhbnkgb2YgdGhpcywgdGhlIGJl
bmVmaXQgd291bGQNCj4gPiBiZSBzZWVuIHRyYW5zcGFyZW50bHkgYnkgaGF2aW5nIGEgbW9yZSBz
cGFyc2VseSBmaWxsZWQgZGlydHkgYml0bWFwLA0KPiA+IHdoaWNoIG1vcmUgYWNjdXJhdGVseSBy
ZWZsZWN0cyBob3cgbWVtb3J5IGlzIGFjdHVhbGx5IGJlaW5nIGRpcnRpZWQuDQo+IA0KPiBZZXMs
IGluZGVlZC4NCj4gDQo+IC0tDQo+IFRoYW5rcywNCj4gWGlhbmcNCg0K
