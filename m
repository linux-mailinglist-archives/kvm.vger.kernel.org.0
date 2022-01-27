Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B4F249D771
	for <lists+kvm@lfdr.de>; Thu, 27 Jan 2022 02:22:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234428AbiA0BWG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jan 2022 20:22:06 -0500
Received: from mga02.intel.com ([134.134.136.20]:57504 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234416AbiA0BWF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jan 2022 20:22:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643246525; x=1674782525;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=x5m8++WsH+Q0VvOB9b18Wz510BKSAjjSP9wHucwgQ1I=;
  b=Gr3q8AglvE8v2rExWRo6G7Qxaw4O7tixsbhegqKjQI7EsrzYEB7thPnw
   EK0sBcaYmcUqnZWlKqzbl3NMUQO2Zl1ZCGpMgbv5nUtV3UsXpPuIcg46m
   j/6gPho3H7qPD8oe98jMV/DAKLCwW5zO/42kSrl3U3dDmDKtX6BWl/ObP
   yb/aspbk9q0KEoh9vcR/SOaQ1hSGe7T0aakfkUMMXQl/ijtLVAR9IqQ3B
   VwjJEC3yKjdMt4uB2t1qq4wzxwqZXhc/ciI/CybUGAHTfHoPpIHx4w3tn
   Mc55tfQO1FZPJWlEr8Vq7WVMfNTPFJZ4e2mlilCLxQLI/vRZKdLNGWDqL
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10239"; a="234087056"
X-IronPort-AV: E=Sophos;i="5.88,319,1635231600"; 
   d="scan'208";a="234087056"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 17:22:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,319,1635231600"; 
   d="scan'208";a="628506510"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga004.jf.intel.com with ESMTP; 26 Jan 2022 17:22:04 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 26 Jan 2022 17:22:04 -0800
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 26 Jan 2022 17:22:04 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Wed, 26 Jan 2022 17:22:04 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Wed, 26 Jan 2022 17:22:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TcCLbfis9B7kConowPRn3T0IHFJIMsq9NYqy0Je+WH4AwQESEq+4PjMgAUbq9waaN0kYK4SUza6YlZHqOgnOvPB3CM2ak2Sbq9fGyo/aSNiXQiSB+McMaM4PMfu6REAY+qroCUC1RgsJLJgsWP+PkXUTsb7oM6SY8egESCvxlSdBY78NWaajdZD+0wpASZ8aeHVtNurt12R5fx6qEH4xKMJt0kEYMPyLLUijyY+GNtOWSDwcpwLLVyiPvLs8n9yQqYC8TzpzFabqQF4y7R4WGIVu9wyRChtWjsyThYleTr5JVTxWZ+V+Ml/KaZAuBgGOu0f/RWubEfgiqNf565ZmdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x5m8++WsH+Q0VvOB9b18Wz510BKSAjjSP9wHucwgQ1I=;
 b=bpYxxBdz6zo4d6brjSWX3tEA58esfNKN+D13T5aHK2OfT4wElR2eA3k5fSqvQAottwIbCqhLBJHLa/5T4NkB2r86ayFyDvYz/D8vA0LcLeKYKtSHym/hdUVb60e2d/T0vJjlaTFeL5oKiStXdY2nuG1DKxiSMw76iv4cHNT5i6B6Yq0BsrjQ/J+X5+7tVKxMaPFVdnLrY6c3IvbbfM6biEBYZgXXJ5A4lrxwluTo5cNzsbDPEawpKk9zRclitVcYIr+K7mXDUb3pQ5spG8pUXKlarEuVK7Iz8/HWvfLuP5blTTeXVPV3Bgd7ZUoAXSfG3db6RN/Sc6AxsGCviQz+VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BYAPR11MB2950.namprd11.prod.outlook.com (2603:10b6:a03:8f::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.12; Thu, 27 Jan
 2022 01:21:59 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e46b:a312:2f85:76dc]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e46b:a312:2f85:76dc%4]) with mapi id 15.20.4909.019; Thu, 27 Jan 2022
 01:21:59 +0000
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
Thread-Index: AQHYCX3pQbl/KJiueUy+Ou1rwdnoq6xzKCRggACfIwCAAMkU4IAABfUAgAAA/XCAALJVgIAAz/0AgAAI4ACAAABS8A==
Date:   Thu, 27 Jan 2022 01:21:59 +0000
Message-ID: <BN9PR11MB52769CD32910BB5AB89AB7398C219@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-a4f7cab64938+3f-vfio_mig_states_jgg@nvidia.com>
 <BN9PR11MB5276BD5DB1F51694501849568C5F9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220125131158.GJ84788@nvidia.com>
 <BN9PR11MB5276AFC1BDE4B4D9634947C28C209@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220126013258.GN84788@nvidia.com>
 <BN9PR11MB5276CC27EA06D32608E118648C209@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220126121447.GQ84788@nvidia.com>
 <BN9PR11MB5276141AC961A04A89235B428C219@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220127011058.GW84788@nvidia.com>
In-Reply-To: <20220127011058.GW84788@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 636ec24d-9043-47d1-f99c-08d9e1336a44
x-ms-traffictypediagnostic: BYAPR11MB2950:EE_
x-microsoft-antispam-prvs: <BYAPR11MB29508CBE6D79F3C03B56C41A8C219@BYAPR11MB2950.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: btxKgVgowJJjnWIK4F3Rw7ILsvtyDe0aelOY/o19xRI1Nio2147ak+iSy2uUfSq7sKpDOsNpcO9IjXPmCGVMAUcOZHa7G6LiCqlOxKpugN699TGpv0ZJdpmwaBoM1RTUB+g+7cejRdJ9ABrM3qF3GpnLUQg+PvPINGMaU2AuUlioWgPsTV220Be9O64+SyB6OzCCrBngTpU/n6Ll/+lOHgHXV/rW80b0Q/RyiJCP88Q32jnW0EUOX1peAyR3ahmX1EzCTxsJE4X5pt0HesWym/sGg7PhV9uKLiAehYPNa4DGUrktLbp7hcfeLbhBYZfOBae1reRjO/C4vFM1zGtBNne6ZDrKwdjULbEDtvsfNLd6Zo7y9l+9Vc2GdF58FAYIZA0eiiqKYfxViXSZVzScj0djF8w001VJAdr3XFepeEeYvfmTOPY3fwDVIGx9+F4Xg5Q+xvp66p7tXk7f8gMdgSX6+GewA/twAJpMcqOl4MQ9pRCRoBqx0rh9qCCLdfCRMUh3QoaqkQzpCWaj9wRVqRNJ3W8XqKT7Vkj+bGOMc2t84HTnSZ2rbU6k+hyCddbBjbGb5Tf7tAdKHeSJT9VS5f8oQTBImP1+/VCGqLTYnYdmNxW3qExn9ufeOpjz/hj36w7e06uzF9CxN5DGCEJdsd/FXUU5Px4hOSjnWb4ootSBLYtPGFehw/XpX+WqGUAfj3rPK1DSFvbE2Gb5FqwH2g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6506007)(5660300002)(54906003)(8676002)(38070700005)(6916009)(86362001)(9686003)(4326008)(8936002)(52536014)(122000001)(83380400001)(33656002)(55016003)(2906002)(7696005)(38100700002)(66476007)(508600001)(66946007)(64756008)(66556008)(66446008)(76116006)(82960400001)(26005)(71200400001)(316002)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VDhKQ1lZWmlWQjhkb0JGeGsrbnZ0SkdiRnoxa2FzWVh0aGdHYW1DR25OOTk5?=
 =?utf-8?B?UStBamZNaUR3UXlMVE8xSWdRWlpQazRWSzJ3Z3AzZTc3NS9wMFZ4RFA2OTdx?=
 =?utf-8?B?MTRqUmJmTktYK1RlUUJYV3hjRXdzWTJLNEx5THFHaVJmaGYzWExFWDNxTUUw?=
 =?utf-8?B?NHdlZWtuNWhJeSt1anhPazhLZ3R6MTh4OExiYitYQzdwajBUUFBSVVdBMmdq?=
 =?utf-8?B?SlErdmRtVGQ1b2NoNEFlR2VwU2IzWkh3WElKWTQ1Yzk5d3dDMDBYOVZobklz?=
 =?utf-8?B?NlQxWmRVMlhmd2tMc0RkWWt2MDNBVGt3Y2xiRnhjeCs2NjRLREdmZVZ1ZkpW?=
 =?utf-8?B?elo0TjBhbmJwVnBPSnp2ZUlwWVkzTkx5MVFMQkI3WG1WdUh6OFJER2JGZGJm?=
 =?utf-8?B?T2VlSzV2cm5tTzZFZW1EUmREeDM5ZDBsb1RhL3RCdlRGYXY0YVBGUkdONDRS?=
 =?utf-8?B?QkxDYjE4VkpYNUdzbzdNL1ZNalFQREpSeGJYS25yZkREVUVJRE8wU2x0Qlcv?=
 =?utf-8?B?R0RIeVhoTWJpd09wR2czdWRjaWVwOTVKODZRTFFiVUtBaWFmbUQ3ajFVME5T?=
 =?utf-8?B?WlNNRWlJYWJCenM5Y1dzdG1MR1BKSklmT2R3cFNBbTd2b2ljRUxOTGxxMDFk?=
 =?utf-8?B?STloYWdBWnphQ3I3YkhtSE9KSlFHZGxBUlRzRkRRZUlOUmtDMmxjNit2clg0?=
 =?utf-8?B?akFKU2JEeW5MMXR1M1kwbll0MHpnOHhYZ21OYjVLNlRoQ1VrSTZSWEtvVlVm?=
 =?utf-8?B?YXlkWnN5NUhxc2lUTU0xYmtXeU9MK0psaDZjUzgrZjZvUUJTbGYxeFZhTDk5?=
 =?utf-8?B?SlZGeDRkN28xK1hiTVJHZHk2NjVUMTJDNi9wVDZ1WU9qRkZPWkE4WitzaEFh?=
 =?utf-8?B?Mkl1enZ5RzY1SDR2dFlOUUJnMFFzeG5aYzlZWlVVYnpvR2FmSEJCQzVxaDFR?=
 =?utf-8?B?c0VOZE9HcHR5S0ZlTUpuMGx2YVRiRk9IbE5xb3JNRFV0OEVaRUlXUUExeUpm?=
 =?utf-8?B?ZTNtR3dGcFNJaUtlcXlCNmpNNzQyYTZIU3ZYTlp2NmdHMFA2dFFJR2FVVGY3?=
 =?utf-8?B?ZU5CMC8wdHJodEhwSy9POVVkZ2s0Y3ZxQ216a3luTVE4VzhITmxNUXZyQ1g3?=
 =?utf-8?B?RjFoTWsxcG1UcW91L1NPdUhFTHRZVHVsUXlhbXkwK3JsQWkzUVNHaWpvQmpk?=
 =?utf-8?B?czRHZm5odkMwZG52NWN6U3kxU3RiVWluVFNnQTZsaG5iNElqejBpd0xsMGhB?=
 =?utf-8?B?dUcrUWE1elU0L1R1Yzd1OWMrVmlLc05TcEI4a1F3SnNBaDN1Z3dNQi9Oa3BU?=
 =?utf-8?B?Zk9hd2tTS0hrTFZrNnNic0ZRN3h0MGdMTlkyT21ONHRzZG84TThLV3lNOU5v?=
 =?utf-8?B?Z1pKay91eW0xbGpYU0VTUUc2Rjdpa1NHZnJ0VVdmMFdJdDRiQUFxSGE2SlpK?=
 =?utf-8?B?a2oyWDFKOHRXQ2RjQUpuOHh2Z2hWZ1JqT2tSTlhmdUlXQUs2cDF3dVpzdVdI?=
 =?utf-8?B?RmlqMFdPVjh4c0FuUE55eXBXSGgxLys4RHFTbWwxcXFYRFFvckRqN0VZcWsv?=
 =?utf-8?B?RUtqOGgycXZ0VitiQUwxSUFVcmNnU3ZsMFNTOHhJWFBTNFNUNi9XQlBaQ0tx?=
 =?utf-8?B?eE9pemt6SlhhYUpmWHVMQUpkN0h4eCtyS2l3UFFYYVMwbVQrd2ZYWDJUN0hB?=
 =?utf-8?B?V3J5clNzdE1DaDFIcUs0VHJsUXJGbmZTaEFXSlFhejN2M3o3QzMrMU84Ymh6?=
 =?utf-8?B?L0E5R0M0OW8vL0RWenp6elRoTEU1TS9NaThtMlkrN3hjam9iUWJEV290OUFE?=
 =?utf-8?B?K09nZUxUQ3pHYmhxdTZjTzdWS1VzUVJ4ckVpVmFtYitSM3czbXM2aW54QWpw?=
 =?utf-8?B?MWUxV0lxUTZvblhrMzJVMlBuZjRrcXYxZ1piMWZSVUFkSkFRQ2pPcUFNT1Rm?=
 =?utf-8?B?RUIvWUYwa1JZVzE0ckFFSlpLRm1kT2Y5c21NTjRRUGJxd2J3UkEwKzMwRWVs?=
 =?utf-8?B?YVpmbWo3alpBVmRNaTBHckhLVXE1NXB0TmlOVzJ3bjJNbVF5Yk1GdnVuNEFL?=
 =?utf-8?B?VGZkdmpSM28wRjI4bEZVUDJUNDRqaGhTY3h1NWNrNXNwOFpXSytGU3ArR1dF?=
 =?utf-8?B?cm55TmxCVE9GcmMwNVFuak5veDJPeWJqZTMrc043WWlBOVNlYmNtaGFuTnA2?=
 =?utf-8?Q?tbhDa99k7VoL97r6eu2iY58=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 636ec24d-9043-47d1-f99c-08d9e1336a44
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2022 01:21:59.1169
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ztn4vH1dUrbh52r19SVdb71wwRPTelems+77tJL00XYMXL7m22Me57fEelCBCcvbNJAH3bmXPaniaafYUY9KGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2950
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPg0KPiBTZW50OiBUaHVyc2Rh
eSwgSmFudWFyeSAyNywgMjAyMiA5OjExIEFNDQo+IA0KPiBPbiBUaHUsIEphbiAyNywgMjAyMiBh
dCAxMjo1Mzo1NEFNICswMDAwLCBUaWFuLCBLZXZpbiB3cm90ZToNCj4gPiA+IEZyb206IEphc29u
IEd1bnRob3JwZSA8amdnQG52aWRpYS5jb20+DQo+ID4gPiBTZW50OiBXZWRuZXNkYXksIEphbnVh
cnkgMjYsIDIwMjIgODoxNSBQTQ0KPiA+ID4NCj4gPiA+IE9uIFdlZCwgSmFuIDI2LCAyMDIyIGF0
IDAxOjQ5OjA5QU0gKzAwMDAsIFRpYW4sIEtldmluIHdyb3RlOg0KPiA+ID4NCj4gPiA+ID4gPiBB
cyBTVE9QX1BSSSBjYW4gYmUgZGVmaW5lZCBhcyBoYWx0aW5nIGFueSBuZXcgUFJJcyBhbmQgYWx3
YXlzIHJldHVybg0KPiA+ID4gPiA+IGltbWVkaWF0ZWx5Lg0KPiA+ID4gPg0KPiA+ID4gPiBUaGUg
cHJvYmxlbSBpcyB0aGF0IG9uIHN1Y2ggZGV2aWNlcyBQUklzIGFyZSBjb250aW51b3VzbHkgdHJp
Z2dlcmVkDQo+ID4gPiA+IHdoZW4gdGhlIGRyaXZlciB0cmllcyB0byBkcmFpbiB0aGUgaW4tZmx5
IHJlcXVlc3RzIHRvIGVudGVyIFNUT1BfUDJQDQo+ID4gPiA+IG9yIFNUT1BfQ09QWS4gSWYgd2Ug
c2ltcGx5IGhhbHQgYW55IG5ldyBQUklzIGluIFNUT1BfUFJJLCBpdA0KPiA+ID4gPiBlc3NlbnRp
YWxseSBpbXBsaWVzIG5vIG1pZ3JhdGlvbiBzdXBwb3J0IGZvciBzdWNoIGRldmljZS4NCj4gPiA+
DQo+ID4gPiBTbyB3aGF0IGNhbiB0aGlzIEhXIGV2ZW4gZG8/IEl0IGNhbid0IGltbWVkaWF0ZWx5
IHN0b3AgYW5kIGRpc2FibGUgaXRzDQo+ID4gPiBxdWV1ZXM/DQo+ID4gPg0KPiA+ID4gQXJlIHlv
dSBzdXJlIGl0IGNhbiBzdXBwb3J0IG1pZ3JhdGlvbj8NCj4gPg0KPiA+IEl0J3MgYSBkcmFpbmlu
ZyBtb2RlbCB0aHVzIGNhbm5vdCBpbW1lZGlhdGVseSBzdG9wLiBJbnN0ZWFkIGl0IGhhcyB0bw0K
PiA+IHdhaXQgZm9yIGluLWZseSByZXF1ZXN0cyB0byBiZSBjb21wbGV0ZWQgKGV2ZW4gbm90IHRh
bGtpbmcgYWJvdXQgdlBSSSkuDQo+IA0KPiBTbywgaXQgY2FuJ3QgY29tcGxldGUgZHJhaW5pbmcg
d2l0aG91dCBjb21wbGV0aW5nIGFuIHVua25vd24gbnVtYmVyIG9mDQo+IHZQUklzPw0KDQpSaWdo
dC4NCg0KPiANCj4gPiB0aW1lb3V0IHBvbGljeSBpcyBhbHdheXMgaW4gdXNlcnNwYWNlLiBXZSBq
dXN0IG5lZWQgYW4gaW50ZXJmYWNlIGZvciB0aGUNCj4gdXNlcg0KPiA+IHRvIGNvbW11bmljYXRl
IGl0IHRvIHRoZSBrZXJuZWwuDQo+IA0KPiBDYW4gdGhlIEhXIHRlbGwgaWYgdGhlIGRyYWluaW5n
IGlzIGNvbXBsZXRlZCBzb21laG93PyBJZSBjYW4gaXQNCj4gdHJpZ2dlciBhbmQgZXZlbnRmZCBv
ciBzb21ldGhpbmc/DQoNClllcy4gU29mdHdhcmUgY2FuIHNwZWNpZnkgYW4gaW50ZXJydXB0IHRv
IGJlIHRyaWdnZXJlZCB3aGVuIHRoZSBkcmFpbmluZw0KY29tbWFuZCBpcyBjb21wbGV0ZWQuDQoN
Cj4gDQo+IFRoZSB2MiBBUEkgaGFzIHRoaXMgbmljZSBmZWF0dXJlIHdoZXJlIGl0IGNhbiByZXR1
cm4gYW4gRkQsIHNvIHdlDQo+IGNvdWxkIHBvc3NpYmx5IGdvIGludG8gYSAnc3RvcHBpbmcgUFJJ
JyBzdGF0ZSBhbmQgdGhhdCBjYW4gcmV0dXJuIGFuDQo+IGV2ZW50ZmQgZm9yIHRoZSB1c2VyIHRv
IHBvbGwgb24gdG8ga25vdyB3aGVuIGl0IGlzIE9LIHRvIG1vdmUgb253YXJkcy4NCj4gDQo+IFRo
YXQgd2FzIHRoZSBzdGlja2luZyBwb2ludCBiZWZvcmUsIHdlIHdhbnQgY29tcGxldGluZyBSVU5O
SU5HX1AyUCB0bw0KPiBtZWFuIHRoZSBkZXZpY2UgaXMgaGFsdGVkLCBidXQgdlBSSSBpZGVhbGx5
IHdhbnRzIHRvIGRvIGEgYmFja2dyb3VuZA0KPiBoYWx0aW5nIC0gbm93IHdlIGhhdmUgYSB3YXkg
dG8gZG8gdGhhdC4uDQoNCnRoaXMgaXMgbmljZS4NCg0KPiANCj4gUmV0dXJuaW5nIHRvIHJ1bm5p
bmcgd291bGQgYWJvcnQgdGhlIGRyYWluaW5nLg0KPiANCj4gVXNlcnNwYWNlIGRvZXMgdGhlIHRp
bWVvdXQgd2l0aCBwb2xsIG9uIHRoZSBldmVudCBmZC4uDQoNClllcy4NCg0KPiANCj4gVGhpcyBh
bHNvIGxvZ2ljYWxseSBqdXN0aWZpZXMgd2h5IHRoaXMgaXMgbm90IGJhY2t3YXJkcyBjb21wYXRh
YmlsZSBhcw0KPiBvbmUgb2YgdGhlIHJ1bGVzIGluIHRoZSBGU00gY29uc3RydWN0aW9uIGlzIGFu
eSBhcmMgdGhhdCBjYW4gcmV0dXJuIGENCj4gRkQgbXVzdCBiZSB0aGUgZmluYWwgYXJjLg0KPiAN
Cj4gU28sIGlmIHRoZSBGU00gc2VxZXVuY2UgaXMNCj4gDQo+ICAgIFJVTk5JTkcgLT4gUlVOTklO
R19TVE9QX1BSSSAtPiBSVU5OSU5HX1NUT1BfUDJQX0FORF9QUkkgLT4NCj4gU1RPUF9DT1BZDQo+
IA0KPiBUaGVuIGJ5IHRoZSBkZXNpZ24gcnVsZXMgd2UgY2Fubm90IHBhc3MgdGhyb3VnaCBSVU5O
SU5HX1NUT1BfUFJJDQo+IGF1dG9tYXRpY2FsbHksIGl0IG11c3QgYmUgZXhwbGljaXQuDQo+IA0K
PiBBIGNhcCBsaWtlICJydW5uaW5nX3AycCByZXR1cm5zIGFuIGV2ZW50IGZkLCBkb2Vzbid0IGZp
bmlzaCB1bnRpbCB0aGUNCj4gVkNQVSBkb2VzIHN0dWZmLCBhbmQgc3RvcHMgcHJpIGFzIHdlbGwg
YXMgcDJwIiBtaWdodCBiZSBhbGwgdGhhdCBpcw0KPiByZXF1aXJlZCBoZXJlIChhbmQgbm90IGFu
IGFjdHVhbCBuZXcgc3RhdGUpDQo+IA0KPiBJdCBpcyBzb21ld2hhdCBiaXp6YXJvIGZyb20gYSB3
b3JkaW5nIHBlcnNwZWN0aXZlLCBidXQgZG9lcw0KPiBwb3RlbnRpYWxseSBhbGxvdyBxZW11IHRv
IGJlIGFsbW9zdCB1bmNoYW5nZWQgZm9yIHRoZSB0d28gY2FzZXMuLg0KPiANCg0KbGV0IG1lIGhh
dmUgbW9yZSB0aGlua2luZyBvbiB0aGlzIHBhcnQuIEkgbmVlZCBiZXR0ZXIgdW5kZXJzdGFuZGlu
Zw0Kb2YgZXhpc3RpbmcgZGVzaWduIHJ1bGVzIGJlZm9yZSBjb25jbHVkaW5nIGFncmVlbWVudCBo
ZXJlLCB0aG91Z2ggaXQgZG9lcw0Kc291bmQgbGlrZSBhIGdvb2Qgc2lnbmFsLiDwn5iKDQoNClRo
YW5rcw0KS2V2aW4NCg==
