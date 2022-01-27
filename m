Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ACF249D71C
	for <lists+kvm@lfdr.de>; Thu, 27 Jan 2022 02:03:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234221AbiA0BDr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jan 2022 20:03:47 -0500
Received: from mga14.intel.com ([192.55.52.115]:30795 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234153AbiA0BDq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jan 2022 20:03:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643245426; x=1674781426;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=r2W53dhaiLntyYFFixGFWhCclYbwrG/BJm71MLZVnMU=;
  b=gh+YJTFQ6Q9nCwanpxx+52atgvq+Sdfuqy2h/tcQJsONOn7qv3DgN3ym
   gPJW/QynQfRGIhhN7j4b/yncOcRa4uGKic8Lkmg2K4E+wdqxGXKxHpc3l
   o6RnMAGtqYW8zOlqKBOokEUXhwfiYVUqBBRUL8tjLG2/xXzc/BfpXV6UM
   /xap2qBm6lw3DK1wpmXDa6DdbZWkyda8Nr2c7Ich1geLvjAgJLzQfh/Fj
   CY/eD59H3CTcA3Q9uGBSRBvgahksagAfpinMLnFc/eI4rPqNtTsxfqBkC
   qf9zV4wDOklaI6/rGoNC5yjh5cYSz3aGDJxGhoFB4c/mEq0cXKJE4CHhK
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10239"; a="246927034"
X-IronPort-AV: E=Sophos;i="5.88,319,1635231600"; 
   d="scan'208";a="246927034"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 17:03:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,319,1635231600"; 
   d="scan'208";a="674544224"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by fmsmga001.fm.intel.com with ESMTP; 26 Jan 2022 17:03:46 -0800
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 26 Jan 2022 17:03:45 -0800
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 26 Jan 2022 17:03:45 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Wed, 26 Jan 2022 17:03:45 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.177)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Wed, 26 Jan 2022 17:03:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JVb0cguUhifCoP9Dydyo1cXJULVbwTccMdoz5WUoqGMBC0C5kmhAtq4A1XnBZ8Xhd+GWNitQQTR1A72jJwuEnIr+u9kG+tEJQQkm6KZFjcGjLFffzsonJkDjq9QuU0cJ2ALju15I4zYRPx+SvA1A8nnbtyOh9ZfufR7ofw30wPKpW0bfOOpRBhEha/B8iW+erJew/5BVnNzENoLGFBv++ZbfdNzElUFvk26BRWtTPlhyB3LVO2ZXLkXtjN+56DsxPsT41ImE8sowUy7JUcGVwJad2f88EuaCzxht4dg8aLRPgUVeoCRANRsvcmuDqSJAnZ/kHYr1Tl5VvVrWspmWtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r2W53dhaiLntyYFFixGFWhCclYbwrG/BJm71MLZVnMU=;
 b=HvTEMeuGjXhqjvv8ofCaUgbSnguVI8DBck9sPu8yHo8tqKPTTz8sMQa81XSoBL/htGo2HW23W36/iY5gLz/ZZZuXCNZExcxJ00O2Eh6f0M+w4hOgreFD74XFk7I5QJdGVRRny6MmNLC2ow8/DCzsQEXaPX+plaXohwCzuoArtHp3lqFzcAPcgTXLBqzWkCnPtArfAzKbK+AasOGF8M5ztJW1xt7qumHLa7YEC6H3dwP9Fnmmt1jZrCHfKt4KDEqcjfyAe5WdbwsfHJPNUK5IcszGVB7T2uPjFjWuzzSf4xHJRgKYCZj79l54R1YkJKxj0+ci+04fHz5izLSGs++y0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MWHPR11MB1648.namprd11.prod.outlook.com (2603:10b6:301:e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.8; Thu, 27 Jan
 2022 01:03:42 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e46b:a312:2f85:76dc]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e46b:a312:2f85:76dc%4]) with mapi id 15.20.4909.019; Thu, 27 Jan 2022
 01:03:42 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "Yishai Hadas" <yishaih@nvidia.com>
Subject: RE: [PATCH RFC] vfio: Revise and update the migration uAPI
 description
Thread-Topic: [PATCH RFC] vfio: Revise and update the migration uAPI
 description
Thread-Index: AQHYCX3pQbl/KJiueUy+Ou1rwdnoq6xzKCRggACfIwCAAMkU4IAABfUAgAAA/XCAALJVgIAAN2OAgACThvCAAAengIAAAZAQ
Date:   Thu, 27 Jan 2022 01:03:42 +0000
Message-ID: <BN9PR11MB5276C08C65B73FE6B1F81ACA8C219@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-a4f7cab64938+3f-vfio_mig_states_jgg@nvidia.com>
 <BN9PR11MB5276BD5DB1F51694501849568C5F9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220125131158.GJ84788@nvidia.com>
 <BN9PR11MB5276AFC1BDE4B4D9634947C28C209@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220126013258.GN84788@nvidia.com>
 <BN9PR11MB5276CC27EA06D32608E118648C209@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220126121447.GQ84788@nvidia.com> <20220126153301.GS84788@nvidia.com>
 <BN9PR11MB5276826AC416E13B62AD99568C219@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220127004825.GV84788@nvidia.com>
In-Reply-To: <20220127004825.GV84788@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 70ee0653-da60-433a-089c-08d9e130dc91
x-ms-traffictypediagnostic: MWHPR11MB1648:EE_
x-microsoft-antispam-prvs: <MWHPR11MB164857FA7BF28CF716A7FBE48C219@MWHPR11MB1648.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4o2ZGL36CNJFQ9O/ul6BWANiy3xsIRjCh/tgqXyP+pkJd23OZJ49UshLbtUXxJbkbkTKLsuOhlyX0Tlm5T4fqMWNLHskVuDNhKyuUN52laNiAEg8l29PunDEMtIYFBHjE6V9dtrvsucaP7Q89P6cEq7tifndOTDBUOVx7Xr+g0kcf0zhpsn50cizlDZPhhpnKZHXt9YcWetjBL1KExxXecA3eVHrQXuOxsfxb8hhzLA7lDbRs0M/fWf8gmCcUAgFnPGZvvpbH2ZColtTUXUjDaG3YtqumiRbJ7F5gQS4VtPWfiQe+xgcku49DD4zLpffmFC6ckeSc1RaWhfjoN+5uf4usZ4OodG++VTST2HYpd5/pj4jOYxzdDlRmboZNaekK3TTtB3mUxJzJkH3zNEk9P1Meq2HOXZox7SqTtsnyB9LVw9v2GOW3fL+/QgIWoLRHe+iBSGSXUlMxdMqlpIH3wNOgtVoflZ4qbPlYqGJvkGaj020gJ501JCJas8eggfkHDzPcd1M/u4hdzOMRpn0ac14v6+boSYvh3nBpfVpWns1gsUO27an2VW2iKOF/TKj1Dqj2iSZ4GjrRRA2W4p6Mluq12qG8zUdlNsAc221uOHgfcrHNhaFT+VFQ+6O41qYAsDNlhCBMeIJERYcjTFVUinYTP3g54QPl1aW+WMO3FTgqDLZDH9WBnBZIkh6MYcazn5e1U1AFWV9AxZygwcQJA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(5660300002)(76116006)(66476007)(186003)(52536014)(316002)(9686003)(8936002)(508600001)(7696005)(86362001)(6506007)(66556008)(66946007)(64756008)(66446008)(33656002)(8676002)(71200400001)(38070700005)(54906003)(26005)(2906002)(82960400001)(122000001)(55016003)(6916009)(38100700002)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Vm1saUZqcVA0STRrcjVFd3pOTTdOdDA1a1JDRWEyVTR5YWhZRW9vdW1rVk1n?=
 =?utf-8?B?TmRmUUhDeUtoSng0RVA4N044Q2dySXk1RzhweEkwNEJ4cytCOHptSFFIa25O?=
 =?utf-8?B?L2xTQVA0QkFxR0lkY1dRa281OGNoRmhYWTNTODlhQ3l0Tng5T0J3Tjl6VGQ1?=
 =?utf-8?B?YjYyOUd3QW95N2F5T25TbVdFNGNhdnF3WVZxVkRFOGU4NzZ4K2pVOElDMGRh?=
 =?utf-8?B?TmVRUTl3RE1qR1M5R0ZSQU1yUGhqQjRhMmNYZ29Ka0pBVWxNS25yMzBYNEpE?=
 =?utf-8?B?S3liVnY5Ynpoc05lUktUMk9uRi9jemVZc2Zhc1IrVEdHYUYvbEJWOC9wVmt4?=
 =?utf-8?B?UW1LQmF4S2hWTmp3bnNNcXJHc2I0VGs2TGp3WEU5Mldrc1VGVFdXbVd4bWdG?=
 =?utf-8?B?Q2RNNE5kS0tjQzFhbFdIYmthZmwwWEwyOFZ1dDB3NEdEZ0g5Nk9iNGg4MElS?=
 =?utf-8?B?MUZhTTB5bkp2eEFWMDRhbUhLdi9aRHk3UDBlQ0U0U3dTMFFjUjRGeERyMlhk?=
 =?utf-8?B?alhzdzJYQ1dGM2w0a2syd0FPRE4zWHZ5MUhBQXFwVG9XeDJlZ21pb2J3QXFU?=
 =?utf-8?B?U2owMVlYSWRrQ0hOdDg3ZWNsdW5hTjBqMVV2REtPSXg5M1ZCZ1ZmUHRad3ZF?=
 =?utf-8?B?Q2lwSXNHakNLdk1BUWV1N1MxY2srd0ZSVUd1M09tU2R1alpvWjBRZ0lZenJT?=
 =?utf-8?B?TklidHNySHgwemdYeUEwMVRwS1FhdUpFcmw5b2ZodjloT3c1R3hLL1lDbHJG?=
 =?utf-8?B?TXNtS1UyWWJ3enN6M1F6WE1WcmFsNVBrUFhzT1A5b1ltQ1JHMVBDdjZpQmt5?=
 =?utf-8?B?bE8xaVMxcDdXMXJ0Wms2dG0ycXhuQllVZ1Q5ZHRQdG1PV2NCc3FsWWR3bHdm?=
 =?utf-8?B?VEE0QzREUkNHZXZ4c1pEWVVEQ0JsOUNpNE44U3pBOVgzVk01OWdQUGpRNXdZ?=
 =?utf-8?B?Zk1QZDNCN2VHSGhxSnd4UUkyZW5oY2xIcy9pNHNMVERhd3k2ekhGMkU2eCtH?=
 =?utf-8?B?bWo1UCtoM3B1aWVrRG42NVVuN25oR2NGTFRFVTVUYU1mdkVCTWJ3dGVoT0Jw?=
 =?utf-8?B?YVFXUUZuWlNXOHBTV3FXZk5FUnZwbHIybGNnSXBwNUEyRFNBcHNXMGlZaDJO?=
 =?utf-8?B?NkZzWjErRGhGeFNQcUNQSjZ4OUZoangrelVyN1I1N3F5RTRLSytxQ0xRWkt6?=
 =?utf-8?B?WWZmVWZZbm85V1FXaWlMWjJSZFUyVjB4Vy91Mk8za1VTMS9LU29rcVJWUnBF?=
 =?utf-8?B?MmtCUXZCdUxOeWFZT2VBbTdsaTFWb200UXRsNkMrSjlxbDdNMGhiL3dJc1Nm?=
 =?utf-8?B?QUMxeHM4SjZjY2R5ZmxKL2oxbFR0VkthcFBSLzhqN3NmLytkUUxhVGFEclRr?=
 =?utf-8?B?VWFXbnNoajdnclozWDQwWXo3dDA2MGJEVTlRTXpMcnJ2OTl6RmFNQklwQTdF?=
 =?utf-8?B?M0RKRStUS21veXNYVExCRytpU2xLUjJoV2t4MEtFT2hTSzVIcDdHMU94bTdp?=
 =?utf-8?B?czk4bGFDbzhNMnFSU3pVT1RsZzlKQVR4TlI5SUJxOS8zeldOQThObWZtQ0JG?=
 =?utf-8?B?UXBkQ3ZCMGdoK1dzcjAwaDB6YTRDSXJ0b1lKblpnNjNKajZxUmZXV3dqQjZH?=
 =?utf-8?B?SHhpY09kQkNSZVlGK0FETWVVZVVWY3RlcXd2Q3l3OG9uK3BRMndjRnR0ZFR3?=
 =?utf-8?B?VTNxNFViSmttOXBmZW1IeXVuR2xkL0RJNnhpNmw2TkxDMUxXWURUdlpodSth?=
 =?utf-8?B?b1JJd0JrbnJDK1RBTlVOVktRUHk4UEFNNy9Ubm9kMG4zOXJBeHVvMkMzbksx?=
 =?utf-8?B?RFNkNjJpTXlSamxEMGVXUFVFWXBSenYwZm1EemRnS3FkdEdjdkVRcE1od1lL?=
 =?utf-8?B?NEoveVQ5UmdXeHRNVElZN2YvUUxFQ3NCWUZpWVJqT0hWNkx1QUdjR2V2dDhR?=
 =?utf-8?B?SzhzdVgydkhxZ1JsQmVLeUhKQ0tBQlNkSkIydmYxam5DSTNDTmJhRTF4TGdU?=
 =?utf-8?B?QnA3cU9MSW0wOHpuZWc4eDRmTE5heHdxYzN4K2lsQm4ycXVWSkl4SUNvVWVW?=
 =?utf-8?B?bjd6R1VnV004c0RrMDhrUFpFRjZ3YnQ1UGhTaXNBaFIrMWtJMTFaOTZTeUVh?=
 =?utf-8?B?dm1XKy9SblI2aWRCOUlpcE91SGxPbFJraTlCMHU0dGE4ODR1OWUrekNpdEto?=
 =?utf-8?Q?8YhEKduViusH4wvfUzklJBc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70ee0653-da60-433a-089c-08d9e130dc91
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2022 01:03:42.3714
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: f+gGCwiYRMo3wZBHtkik0eeDqaCPLnB6g/B53qgn74dZ6vKno+VyGzjwYT0QBMY3eF2E9b4iOdzas+/mK/zZTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1648
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPg0KPiBTZW50OiBUaHVyc2Rh
eSwgSmFudWFyeSAyNywgMjAyMiA4OjQ4IEFNDQo+IA0KPiBPbiBUaHUsIEphbiAyNywgMjAyMiBh
dCAxMjozODoyNEFNICswMDAwLCBUaWFuLCBLZXZpbiB3cm90ZToNCj4gPiA+IFNvLi4gdGhpcyB2
UFJJIHJlcXVpcmVtZW50IGlzIHF1aXRlIGEgYmlnIGRldmlhdGlvbi4gV2UgY2FuIGNlcnRhaW5s
eQ0KPiA+ID4gaGFuZGxlIGl0IGluc2lkZSB0aGUgRlNNIGZyYW1ld29yaywgYnV0IGl0IGRvZXNu
J3Qgc2VlbSBiYWNrd2FyZA0KPiA+ID4gY29tcGF0aWJsZS4gSSB3b3VsZG4ndCB3b3JyeSB0b28g
bXVjaCBhYm91dCBkZWZpbmluZyBpdCBub3cgYXQgbGVhc3QNCj4gPg0KPiA+IE5vdyBJIHNlZSB5
b3VyIHBvaW50LiBZZXMsIHdlIGhhdmUgdG8gZG8gc29tZSBpbmNvbXBhdGlibGUgd2F5IHRvDQo+
ID4gc3VwcG9ydCB2UFJJLiBJbiB0aGUgZW5kIHdlIG5lZWQgcGFydCBvZiBhcmMgaW4gRlNNIGNh
biBydW4gd2l0aA0KPiA+IGFjdGl2ZSB2Q1BVcy4NCj4gDQo+IEkgc3RpbGwgdGhpbmsgdGhlIHJp
Z2h0IGFuc3dlciBpcyBhIG5ldyBzdGF0ZSB0aGF0IHN0b3BzIG5ldyBQUklzIGZyb20NCj4gY29t
aW5nLCBJJ20ganVzdCBub3Qgc3VyZSB3aGF0IHRoYXQgbWVhbnMuIElmIHRoZSBkZXZpY2UgY2Fu
J3QNCj4gYWN0dWFsbHkgc3RvcCBQUklzIHVudGlsIGl0IGhhcyBjb21wbGV0ZWQgUFJJcyAtIHRo
YXQgaXMgcHJldHR5IG1lc3NlZA0KPiB1cCAtIGJ1dCBpdCBtZWFucyBhdCBsZWFzdCB3ZSBoYXZl
IHRoaXMgd2VpcmQgUFJJIHN0YXRlIHRoYXQgbWlnaHQNCj4gdGltZW91dCBvbiBzb21lIGRldmlj
ZXMsIGFuZCBiZXR0ZXIgZGV2aWNlcyBtaWdodCBpbW1lZGlhdGVseSByZXR1cm4uDQo+IA0KPiBU
aGlzIGlzIGV2ZW4gcXVpdGUgcG9zc2libHkgdGhlIHNhbWUgSFcgZnVuY3Rpb24gYXMgTkRNQS4u
DQoNCldlIGNhbiBkaXNjdXNzIGluIGRldGFpbCBhZnRlciB0aGUgYmFzZSBGU00gaXMgbWVyZ2Vk
LiBXaXRoIGFjdHVhbCBjb2RlDQppdCdkIGJlIGVhc2llciB0byBpZGVudGlmeSB0aGUgcmlnaHQg
YXBwcm9hY2ggb2Ygc3VwcG9ydGluZyB0aGF0IHVzYWdlLiANClRoZSBvdXRwdXQgZnJvbSBjdXJy
ZW50IGRpc2N1c3Npb24gaXMgdGhhdCBJIGtub3cgd2hhdCB0aGUgY29tcGF0aWJpbGl0eQ0KbWVh
bnMgaW4gY3VycmVudCBGU00uIPCfmIoNCg0KPiANCj4gQW55aG93LCBkdWUgdG8gdGhpcyBkaXNj
dXNzaW9uIEkgcmVkaWQgb3VyIHYyIGRyYWZ0IHRvIHVzZSBjYXAgYml0cw0KPiBpbnN0ZWFkIG9m
IHRoZSBhcmNfc3VwcG9ydGVkIGlvY3RsLCBhcyBpdCBzZWVtcyBsaWtlIGl0IGlzIG1vcmUgcm9i
dXN0DQo+IGFnYWluc3QgdGhlIG5vdGlvbiBpbiBmdXR1cmUgc29tZSBkZXZpY2VzIHdvbid0IGV2
ZW4gc3VwcG9ydCB0aGUgYmFzaWMNCj4gbWFuZGF0b3J5IHRyYW5zaXRpb25zLiBTbyB3ZSdkIHR1
cm4gb2ZmIG9sZCBiaXRzIGFuZCB0dXJuIG9uIG5ldyBiaXRzDQo+IGZvciB0aGVzZSBkZXZpY2Vz
Li4NCj4gDQoNClRoaXMgbWFrZXMgc2Vuc2UuDQoNCkp1c3Qgb25lIHRoaW5nIHJlbGF0ZWQgdG8g
bXkgYW5vdGhlciByZXBseS4gSSBkb24ndCBrbm93IGhvdyBtYW55DQpkZXZpY2VzIHRvZGF5IHVz
ZXMgdGhlIGRyYWluaW5nIG1vZGVsIHRvIHN0b3AgdGhlIGRldmljZS4gQnV0IGdpdmVuDQpzbyBt
YW55IGRldmljZSBjbGFzc2VzIGFuZCB2ZW5kb3JzIGluIHRoZSBtYXJrZXQsIGlzIGl0IHJlYXNv
bmFibGUNCnRvIGNvbnNpZGVyIGNlcnRhaW4gdGltZW91dCBpbnRlcmZhY2UgaW4gdGhpcyB2MiBk
cmFmdCBub3cgc28gdGhlDQp1c2VyIGNhbiBiZSBsZWZ0IGluIGEgYmV0dGVyIHBvc2l0aW9uIGlu
IGNhc2Ugb2YgcG90ZW50aWFsIFNMQSB2aW9sYXRpb24NCndoZW4gZm9sbG93aW5nIGNlcnRhaW4g
RlNNIGFyYz8gDQoNClRoYW5rcw0KS2V2aW4NCg==
