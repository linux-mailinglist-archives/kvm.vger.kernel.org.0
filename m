Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8D3649AB08
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 05:44:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357537AbiAYEFJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jan 2022 23:05:09 -0500
Received: from mga12.intel.com ([192.55.52.136]:22221 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S3420575AbiAYCYt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jan 2022 21:24:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643077489; x=1674613489;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9QRgxHm21iFW7RW5EhUCu2uoFYa84HxTfvUSQEuv2Kw=;
  b=fFVSsTn1IqR0ZXfvDpbzo1slMSwwuGAlbnmVG2WYQarDktTF2L3ubCKz
   WhtL8RiyA7nVxfIJMp8VUfRZIwXLOqEXQSMkf0ud+qvin0nC2ZEV7w4V6
   AwWKczD7j9FaQ8wRVOYiUPZauQKT7syi2PeN3BwQwqfjjHZfhfsSvsj11
   bBB57dCcpk+T4nQknDIKMlozAh6WrSRqQYukowVKKQN8mjhZBEpPtCH9L
   YRVh4/u7IvNMvqL6J2I5tr/4L2IN6VyPOgmxxiyYC8bod+Xr3lFvutmK7
   X1fgCaaKnpINQ5QkAZrgR9r1mY1u+CpbIl9rYAdZ6yhdKQQrGuz0SW1in
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10237"; a="226173614"
X-IronPort-AV: E=Sophos;i="5.88,313,1635231600"; 
   d="scan'208";a="226173614"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2022 17:54:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,313,1635231600"; 
   d="scan'208";a="624300981"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by fmsmga002.fm.intel.com with ESMTP; 24 Jan 2022 17:54:56 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 24 Jan 2022 17:54:55 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Mon, 24 Jan 2022 17:54:55 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Mon, 24 Jan 2022 17:54:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DP3c4ckl6TvT6KACHuBAytQDSGumh8oAB+wD4gIxo9i7wL/QCn7XPeAvnSFdKbGWJd3DlhFr9CJF7MJsw53g4atiOPxiGmy6rPonAGP2wiN+YkL8x3c1cECvzWjXrVredbkNbNylKrxXuWl+UBx9qdGS/EQ/0VTfpi/zEsayHtCE2NI63MEIwPPsh49Jj/rZnpK0U8B8QCu7PZpn0QaP+KXe2kYvuUMoERYnC/l7LQ+/w61tzv/sXrukImkvIuc1L2FmzonnSQsIrR5C1cmJvIw8ud/e36UlodLA/YksNWQ2L/fiyTp9W0cUqgTPEZQC25rWK4XJPVp8Pq+XCfb21Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9QRgxHm21iFW7RW5EhUCu2uoFYa84HxTfvUSQEuv2Kw=;
 b=IGT2kIgOsErEte14nRyG08ZXLb+C5qJFqP0Swrp5sIwKqKXi8PSJ+gEHVOOq2gw8gFF2v9vTxAr1gWre4drfDu090yy+gM3UWhdxOaFTnzoglEO/anSrK4mQtsdxLdc68l6dNHXoZx/SdcJHH3J41Ni0ihVLbjWuN85DeQNvimdK72jxtq6nukvThalKuSbNvIOEHI7JxcYN5OBKwrVCLP3sCqnH2/cmocG2njmVZToZ8ICXuwhQ4GOaziJcTH59uWjorMYAIwmnGg14sGc0m28eUgrASk7hZBv7s20gEo3We7cC/DYKXUyEGfBxCBiQQy17BWKnWMPWTobOjshHLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM5PR1101MB2298.namprd11.prod.outlook.com (2603:10b6:4:53::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.14; Tue, 25 Jan
 2022 01:54:52 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e46b:a312:2f85:76dc]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e46b:a312:2f85:76dc%5]) with mapi id 15.20.4909.017; Tue, 25 Jan 2022
 01:54:52 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Like Xu <like.xu.linux@gmail.com>
CC:     "Liu, Jing2" <jing2.liu@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Zhong, Yang" <yang.zhong@intel.com>
Subject: RE: [PATCH] KVM: x86/cpuid: Exclude unpermitted xfeatures for
 vcpu->arch.guest_supported_xcr0
Thread-Topic: [PATCH] KVM: x86/cpuid: Exclude unpermitted xfeatures for
 vcpu->arch.guest_supported_xcr0
Thread-Index: AQHYEB04i+jH6+Lv20CJG71ADhixA6xxwR/ggAADloCAAJhpgIAAAciAgACa5uA=
Date:   Tue, 25 Jan 2022 01:54:52 +0000
Message-ID: <BN9PR11MB5276170712A9EF842B36ACE48C5F9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220123055025.81342-1-likexu@tencent.com>
 <BN9PR11MB52762E2DEF810DF9AFAE1DDC8C5E9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <38c1fbc3-d770-48f3-5432-8fa1fde033f5@gmail.com>
 <Ye7SbfPL/QAjOI6s@google.com>
 <e5744e0b-00fc-8563-edb7-b6bf52c63b0e@redhat.com>
In-Reply-To: <e5744e0b-00fc-8563-edb7-b6bf52c63b0e@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8eda921d-1b08-4aff-27ab-08d9dfa5ad7b
x-ms-traffictypediagnostic: DM5PR1101MB2298:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <DM5PR1101MB2298B7DB675643A15DD3110E8C5F9@DM5PR1101MB2298.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DB/pavotzm4N6Ef24K3ETxTZFBy9jLV/YnzmjPVRv2Lbz7F4oAC+OxzH1wxstJaI17tcr74BNI1FwC02DKQqEftqSD+QPEFax8BEVB+XIUHd4l9ytABMJM39iSAQe80aU8oY8bHg5RfPzJAIZoz3DMDuawTp/qausZlZM9tPW3i6+RvqxWZWAL44GjCjrB8a60XaiXciQDD+rofDWd0kGkIx02+b3PHHgsFBzRbv47Q8MsC2/hP/kpWBOLv3XT/5e7u7lajGv0rxE2G2bRQrM1Btw0kHF8vssvGo/hk9UCK3EnyGtnm2xUi3a3TDVG8QunM5CEk1neJb4RNBFz/sRRI+Mmym7wUN7SigbKGDN5YR2OGfVy6KMltJzkYMM8WJuOvT4M1kxKE3GRsGwFP0AbD9jHwa3132VR5n9Gy0Ehvib3cZYZ3TFH09OxqXf4uXB02W4i91xTKmOP9S/Kllqap6CLg8p44A81TgzQDGYWjfR6RcXwIEObAbbdLD21DfTYaUn4tqbGRmVknP/FLrclfMkJkXbrXCSTtIBtHG9P+iYEDeW9Ajh1AqQg5hqMQqJ2madk9SzMT5OeGapYz+yyS1ThKMaYUje1VIuZheo5ImyhyKipNrT1eVN3Yl828mzUXpVDT5AtfQ1d0TJzGRcV8e5Pl9cKibvdQsucEb5rd45rc3f55tB8K/ZgP4iCKstk/VMEbfu8y8E6uTYJ7haQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(2906002)(86362001)(82960400001)(5660300002)(64756008)(54906003)(76116006)(316002)(4326008)(66946007)(66476007)(66446008)(38070700005)(52536014)(6506007)(8676002)(83380400001)(55016003)(7696005)(110136005)(8936002)(186003)(9686003)(33656002)(53546011)(107886003)(38100700002)(66556008)(26005)(71200400001)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MlhXY1phVkJGTFVMbnZkaXN4cU12Y0FKdngzczY3OGNXUjdjRS9DWFdvZXlT?=
 =?utf-8?B?UXlaZ0RKZStYWjg3Ty95akNOdnlDalJxSFFLN1RQeTYwanpXbVBpamkwczli?=
 =?utf-8?B?ekUwSWhtc0ZBRzJObVdnZ3E2ejZmRlNMeCtVSGtSekdYOEU3UmNCU1pNZkM5?=
 =?utf-8?B?NE51b1pPbnh2eWxLR0xiaGpTOWdqQkZhVDQ1UkJoMFFnZVpOZy9ZWm4vZTRh?=
 =?utf-8?B?U2p5dStjT0FycUF6Mm9vN3F5UjcraENGVjRFb2VQYW4wWmZ0Nk9KcldjUmhB?=
 =?utf-8?B?dU9rVktiLzg3Z0dtbXlTbFRZMHlXTVRaTk5DdHZpeWlUWFlRejJjQVJJQU1a?=
 =?utf-8?B?MHRHWlJuSVdMMTNONWdaN0wyK1FYRy9wMlJuRmNSU3h6SitjUlVGMDZidG1n?=
 =?utf-8?B?T2twcS9uK1krYzV0dHhicHNzMEkzWEdDVlRPTDVqUjhDOUJGU0poNkRYclBN?=
 =?utf-8?B?QUd1S3N5ZHpTMkt5TDdLRTQ1M0hLNVA3WWk3cksrOW5GN2tabnBWZkZiajF3?=
 =?utf-8?B?MDh2WmtGK2ZsbUhtczJkZjRzS0hsTGMvTHZnbFNTVnBlRWdiWXF6czBlTy9u?=
 =?utf-8?B?czh5TkV1SUxaM0ZPMXRsLzliS01TMlhwcFlKdmFCOUZWWEVETU5iMnROdUxV?=
 =?utf-8?B?T3hoaEhUdGYrQll3Ui9WMktVdUJDMFJ2UXRiaG4wVXhVK2RhcDRkQVZsT2Vk?=
 =?utf-8?B?bXJjTnE3VmtxY1dBOVlkdFBoVHJoend1RXM4Mjh5T2pTenkxZU9XUHFacEc1?=
 =?utf-8?B?LzY0T0RFR011Vms3ZS93LzFmM0gxT3hUV1VjSHZ5dDJRUlU0aWlRWnIyMldC?=
 =?utf-8?B?MXQvMzR0QXh3eDhKNUJNcEpGVzV5ZlZOSHdacXdFU2NCNy91R280U2NMWlJ4?=
 =?utf-8?B?TmtzYzRLZGxFbDhOQmVHVFBXVG1aeW9EelJ5MHJkMkZkZmo5L2FkRmRSMHFj?=
 =?utf-8?B?YlpDMm5wRVZCNE9CRUtsdVFFUDAyUmRiU0VDZVROazJFWFBLV2F6NWY1TnZo?=
 =?utf-8?B?ZmlSM3NMZHJYcU44TVM4VFV0TDAwaGtjd0h4YVdjWHBkR1NCaHFFVEx1WDBR?=
 =?utf-8?B?N0NvWmFpVy9aTkk3TUFQbTUvMUJORFJQS1ZnVDg3QVFqamRSaGl4UEw3dHJX?=
 =?utf-8?B?aC9ybWxiMDVxODVwSEx6eVhiZWtEZW85SFJUOS94U0x0YjJJcXFQVHNWWDlG?=
 =?utf-8?B?UmlvdUdhYjdwQ0w3U21NT0RtOUVCNzBkeFIyY3V5R1RVYWY1bVY3MzFZTmM1?=
 =?utf-8?B?L01Ob1I4aWZxTXBISGYzQWVlRE5Fd3RQMkthYzJpSDdic1VWRUFLZEtjcVp6?=
 =?utf-8?B?dTJMQUlVZG1GSmttby9rTTY3OTNpa2FGVmM1OVhaOHZoS0ZzaVJYcm1uanQ2?=
 =?utf-8?B?enFEa09CUE9zV1V1VjVvWlhKK2hQYWJmY1owc2JBcHJIMzdsZ0E1NHFZbFFa?=
 =?utf-8?B?STZHdThoU0ZLc3I3NlJxbUJ5a01MbjhEdWxtelB6RTNXWXBEdUlpQTlqbmcw?=
 =?utf-8?B?ZWpYOVRyOWRlYzFXRDU5OUdNWUFuRmNHaHNUQUZYTlZ3Q1dQOEJDN1JvR1NS?=
 =?utf-8?B?VGVSLzhORjdWTmovRVpmcXFOWVJ0WWdERk8rckFmNENUTmdqMjlDWnJ0NjZi?=
 =?utf-8?B?N2c4STIvemhQWHlERlllcVVuQ093RFhYQ2dsaVJoSXg2d2x1eXB5ZjJBL3Er?=
 =?utf-8?B?Y0RaV1p5QTZoWndFWnlWQkxWektBUHlnUHlaelRDZHNQMEV0ZVhwUUlkQWxK?=
 =?utf-8?B?UTBFY1dBWG1zL2pZb3BhbVJPTFNrMngyUm1zL0pDd1JlVk9zTjZzTlYrdlRY?=
 =?utf-8?B?L2YzQWFLSHNwLytMV0o4ZVYwOGVsZlJFWnZ0N25YS0llVEJnNm5raEdZdzhq?=
 =?utf-8?B?eGRWV0dLNmZJL1R3RUZRRTU2bzlGeUMwQ3o0UmVadU91bExMRnBZdVZRMmdS?=
 =?utf-8?B?Q2pPdjNLT0hEdGd3d2RVdUE2L3ZIcit3c1gzeDlQYjJ1azJBenNOUVFjMy9q?=
 =?utf-8?B?SFpKVVlRTzVNYkh5WFFQa1prSjdFU09aeW9YRVZiU0Q4MVdQUzlMY1BtSFZt?=
 =?utf-8?B?MS9icjlvQitGWDdnMW9JVVRGUm41UmFwcUNKNTNrSDB6ckRzK3VwSHRiOXlr?=
 =?utf-8?B?TjA0Mk1JNzNUUGk4UXFOeWN4dDMyZlB6N1o1NThiWG1lMnFiSHN5RnprMHhv?=
 =?utf-8?Q?KFZ3U7v6HfePVRe9VY2ZcUs=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8eda921d-1b08-4aff-27ab-08d9dfa5ad7b
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2022 01:54:52.1982
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0QS+ilB0wiWJvGdIK1B22kqmk6oWfXd8JCTfCKTlhwu7KUEKmGYhmUQIxRrdG2yXMN9LijeSM0t01ZxPV0UdnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1101MB2298
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBQYW9sbyBCb256aW5pIDxwYm9uemluaUByZWRoYXQuY29tPg0KPiBTZW50OiBUdWVz
ZGF5LCBKYW51YXJ5IDI1LCAyMDIyIDEyOjMwIEFNDQo+IA0KPiBPbiAxLzI0LzIyIDE3OjIzLCBT
ZWFuIENocmlzdG9waGVyc29uIHdyb3RlOg0KPiA+IE9uIE1vbiwgSmFuIDI0LCAyMDIyLCBMaWtl
IFh1IHdyb3RlOg0KPiA+PiBPbiAyNC8xLzIwMjIgMzowNiBwbSwgVGlhbiwgS2V2aW4gd3JvdGU6
DQo+ID4+Pj4gRnJvbTogTGlrZSBYdSA8bGlrZS54dS5saW51eEBnbWFpbC5jb20+DQo+ID4+Pj4g
U2VudDogU3VuZGF5LCBKYW51YXJ5IDIzLCAyMDIyIDE6NTAgUE0NCj4gPj4+Pg0KPiA+Pj4+IEZy
b206IExpa2UgWHUgPGxpa2V4dUB0ZW5jZW50LmNvbT4NCj4gPj4+Pg0KPiA+Pj4+IEEgbWFsaWNp
b3VzIHVzZXIgc3BhY2UgY2FuIGJ5cGFzcyB4c3RhdGVfZ2V0X2d1ZXN0X2dyb3VwX3Blcm0oKSBp
bg0KPiB0aGUNCj4gPj4+PiBLVk1fR0VUX1NVUFBPUlRFRF9DUFVJRCBtZWNoYW5pc20gYW5kIG9i
dGFpbiB1bnBlcm1pdHRlZA0KPiB4ZmVhdHVyZXMsDQo+ID4+Pj4gc2luY2UgdGhlIHZhbGlkaXR5
IGNoZWNrIG9mIHhjcjAgZGVwZW5kcyBvbmx5IG9uIGd1ZXN0X3N1cHBvcnRlZF94Y3IwLg0KPiA+
Pj4NCj4gPj4+IFVucGVybWl0dGVkIHhmZWF0dXJlcyBjYW5ub3QgcGFzcyBrdm1fY2hlY2tfY3B1
aWQoKS4uLg0KPiA+Pg0KPiA+PiBJbmRlZWQsIDVhYjJmNDViYmE0ODk0YTBkYjRhZjg1NjdkYTNl
ZmQ2MjI4ZGQwMTAuDQo+ID4+DQo+ID4+IFRoaXMgcGFydCBvZiBsb2dpYyBpcyBwcmV0dHkgZnJh
Z2lsZSBhbmQgZnJhZ21lbnRlZCBkdWUgdG8gc2VtYW50aWMNCj4gPj4gaW5jb25zaXN0ZW5jaWVz
IGJldHdlZW4gc3VwcG9ydGVkX3hjcjAgYW5kIGd1ZXN0X3N1cHBvcnRlZF94Y3IwDQo+ID4+IGlu
IG90aGVyIHRocmVlIHBsYWNlczoNCj4gPg0KPiA+IFRoZXJlIGFyZSBubyBpbmNvbnNpc3RlbmNp
ZXMsIGF0IGxlYXN0IG5vdCBpbiB0aGUgZXhhbXBsZXMgYmVsb3csIGFzIHRoZQ0KPiBleGFtcGxl
cw0KPiA+IGFyZSBpbnRlbmRlZCB0byB3b3JrIGluIGhvc3QgY29udGV4dC4gIGd1ZXN0X3N1cHBv
cnRlZF94Y3IwIGlzIGFib3V0IHdoYXQNCj4gdGhlIGd1ZXN0DQo+ID4gaXMvaXNuJ3QgYWxsb3dl
ZCB0byBhY2Nlc3MsIGl0IGhhcyBubyBiZWFyaW5nIG9uIHdoYXQgaG9zdCB1c2Vyc3BhY2UNCj4g
Y2FuL2Nhbid0IGRvLg0KPiA+IE9yIGFyZSB5b3UgdGFsa2luZyBhYm91dCBhIGRpZmZlcmVudCB0
eXBlIG9mIGluY29uc2lzdGVuY3k/DQo+IA0KPiBUaGUgZXh0cmEgY29tcGxpY2F0aW9uIGlzIHRo
YXQgYXJjaF9wcmN0bChBUkNIX1JFUV9YQ09NUF9HVUVTVF9QRVJNKQ0KPiBjaGFuZ2VzIHdoYXQg
aG9zdCB1c2Vyc3BhY2UgY2FuL2Nhbid0IGRvLiAgSXQgd291bGQgYmUgZWFzaWVyIGlmIHdlDQo+
IGNvdWxkIGp1c3Qgc2F5IHRoYXQgS1ZNX0dFVF9TVVBQT1JURURfQ1BVSUQgcmV0dXJucyAidGhl
IG1vc3QiIHRoYXQNCj4gdXNlcnNwYWNlIGNhbiBkbywgYnV0IHdlIGFscmVhZHkgaGF2ZSB0aGUg
Y29udHJhY3QgdGhhdCB1c2Vyc3BhY2UgY2FuDQo+IHRha2UgS1ZNX0dFVF9TVVBQT1JURURfQ1BV
SUQgYW5kIHBhc3MgaXQgc3RyYWlnaHQgdG8gS1ZNX1NFVF9DUFVJRDIuDQo+IA0KPiBUaGVyZWZv
cmUsICBLVk1fR0VUX1NVUFBPUlRFRF9DUFVJRCBtdXN0IGxpbWl0IGl0cyByZXR1cm5lZCB2YWx1
ZXMgdG8NCj4gd2hhdCBoYXMgYWxyZWFkeSBiZWVuIGVuYWJsZWQuDQo+IA0KPiBXaGlsZSByZXZp
ZXdpbmcgdGhlIFFFTVUgcGFydCBvZiBBTVggc3VwcG9ydCAodGhpcyBtb3JuaW5nKSwgSSBhbHNv
DQo+IG5vdGljZWQgdGhhdCB0aGVyZSBpcyBubyBlcXVpdmFsZW50IGZvciBndWVzdCBwZXJtaXNz
aW9ucyBvZg0KPiBBUkNIX0dFVF9YQ09NUF9TVVBQLiAgVGhpcyBuZWVkcyB0byBrbm93IEtWTSdz
IHN1cHBvcnRlZF94Y3IwLCBzbyBpdCdzDQo+IHByb2JhYmx5IGJlc3QgcmVhbGl6ZWQgYXMgYSBu
ZXcgS1ZNX0NIRUNLX0VYVEVOU0lPTiByYXRoZXIgdGhhbiBhcyBhbg0KPiBhcmNoX3ByY3RsLg0K
PiANCg0KV291bGQgdGhhdCBsZWFkIHRvIGEgd2VpcmQgc2l0dWF0aW9uIHdoZXJlIGFsdGhvdWdo
IEtWTSBzYXlzIG5vIHN1cHBvcnQNCm9mIGd1ZXN0IHBlcm1pc3Npb25zIHdoaWxlIHRoZSB1c2Vy
IGNhbiBzdGlsbCByZXF1ZXN0IHRoZW0gdmlhIHByY3RsKCk/DQoNCkkgd29uZGVyIHdoZXRoZXIg
aXQncyBjbGVhbmVyIHRvIGRvIGl0IHN0aWxsIHZpYSBwcmN0bCgpIGlmIHdlIHJlYWxseSB3YW50
IHRvDQplbmhhbmNlIHRoaXMgcGFydC4gQnV0IGFzIHlvdSBzYWlkIHRoZW4gaXQgbmVlZHMgYSBt
ZWNoYW5pc20gdG8ga25vdyANCktWTSdzIHN1cHBvcnRlZF94Y3IwIChhbmQgaWYgS1ZNIGlzIG5v
dCBsb2FkZWQgdGhlbiBubyBndWVzdCBwZXJtaXNzaW9uDQpzdXBwb3J0IGF0IGFsbCkuLi4NCg0K
VGhhbmtzDQpLZXZpbg0K
