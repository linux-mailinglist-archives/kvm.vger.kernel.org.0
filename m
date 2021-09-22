Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED7F341403C
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 05:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbhIVD7c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 23:59:32 -0400
Received: from mga06.intel.com ([134.134.136.31]:11844 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230054AbhIVD7c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Sep 2021 23:59:32 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10114"; a="284523228"
X-IronPort-AV: E=Sophos;i="5.85,312,1624345200"; 
   d="scan'208";a="284523228"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2021 20:58:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,312,1624345200"; 
   d="scan'208";a="550089594"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by FMSMGA003.fm.intel.com with ESMTP; 21 Sep 2021 20:58:01 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 21 Sep 2021 20:58:01 -0700
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 21 Sep 2021 20:58:00 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Tue, 21 Sep 2021 20:58:00 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Tue, 21 Sep 2021 20:58:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dr7sHDbws5z0xpGZ5Zint0qV6be5IpiyeyQy15iA/IXaKCXXAffaal66WRnhN9bONxkL4antB+zN82LNwUN6S+CTBKwqS9t90TGylhyXMTOOVBPA1HFodKiV11NanQCxfarzaeRkbs29AwBSDqM+4nRnYwHRWE2qm1XP8DFkE81OF6oXSZkm7Zk6cwbgik8mdURRx8zEipV2tMGc8w6kYukoMexrx31KMmeRDdD+uQ/pw9u3AKeU9PXWekKv39H/IVa7VN3WOV8FamGModmg7yLiO3bOV+1e6rXKfFG/R8NyVyAblEqiq5kVE26q8cWs7hopdFpX6RTjG2cYz7waOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=rnlIUEDUxpqeaqtlNfhSRMF9wqpAX0lQoBGfgQao1IQ=;
 b=jNXtjd+jl1thQbVOMVJh+OJiA0bz3vXNeGGI/U0FaRGT+sfPb4eg+ceHQ+ghydg+Y5UflMbO8280YliKQ3rvvUuof5EnFQAs+Zhxattec98YFTvP9/LNC5XKSXfiv5nCMjycyHRboLo+cy8goDbeChf3wSn0RnIySpGHhat7devZKDM3iqIbycIJvKvEc3GyWf7JuAkDIYv00E7T/Jp9Zgb1TweXXzhm0vKvwPvpk7dmuTuPP4w3MdEUVL3tvyVXawqyxeDjC6kEE0f0BdHP7vtrPda9feAoEMIoGHqT3dSezu3ccVdigIfSrperQKAYFoygOouromqUrqA0M0QZCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rnlIUEDUxpqeaqtlNfhSRMF9wqpAX0lQoBGfgQao1IQ=;
 b=F9ro41Qqro/aLO/WZ6eKUccpe38R803HxsbFblCM4Su8kcZPcKmaE2nROJuOkDhXDJbNAQOummypUzjZbKcnRUDNUNUAOS/+8pPmps3YFWNtVw6IpTVpOcH3N9KZWMencIVerAx08LAZ4RkxguQdPjgjYcR0Xi3EVUJxUouNoLQ=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN6PR11MB3889.namprd11.prod.outlook.com (2603:10b6:405:81::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.16; Wed, 22 Sep
 2021 03:57:59 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%8]) with mapi id 15.20.4523.018; Wed, 22 Sep 2021
 03:57:59 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>, "Liu, Yi L" <yi.l.liu@intel.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "hch@lst.de" <hch@lst.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "lkml@metux.net" <lkml@metux.net>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "yi.l.liu@linux.intel.com" <yi.l.liu@linux.intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>
Subject: RE: [RFC 16/20] vfio/type1: Export symbols for dma [un]map code
 sharing
Thread-Topic: [RFC 16/20] vfio/type1: Export symbols for dma [un]map code
 sharing
Thread-Index: AQHXrSGoD6AQyi1Z5UavJoEQQwyuZ6uuztwAgACifuA=
Date:   Wed, 22 Sep 2021 03:57:58 +0000
Message-ID: <BN9PR11MB54333F7E43C4A69E58DE5D978CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-17-yi.l.liu@intel.com>
 <20210921181448.GA327412@nvidia.com>
In-Reply-To: <20210921181448.GA327412@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 06c22150-8492-4801-7cba-08d97d7d2ac6
x-ms-traffictypediagnostic: BN6PR11MB3889:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR11MB38892C316C0666D758BB9CA18CA29@BN6PR11MB3889.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: C4K3tXXJ9UFSKcwRfUDgQdGNJJe9d62UNNMYBSD2ydW/GZGhgyDwmNunyFjyoBtSSB+CfzLdRzwbKfmOiB2zKj5kKSQFQgEDIjWmbV+UcmzqGRJw7okI8N8Wj+BQIRZA8eAqvqpK7+P630yZr/w/mLkXTPNdNDAuiR3AwsU/mjOSLAEXbHFdKGC4BS1P69AbiThQkdAZCL3HXSh6O8fC86omOzRUeXcC8uqIBTwUOpewwQ2T5CxFfm/+YRH38s4yRq+Gyk4nFRDjEB1PSHJKnpkyw7152rOdGlJo+K9nOXF4u+FVZTvLxTGIIK+1ZPbDoU2Fq0mH+sr4TgbWLChC1G07VN4ZVyfl5444VPRtaMFItDFMLoBDFKm7Ad6FvHyZi3Q7s1dp7stem2fOw3+Ge9TIlBAvevEEMbuMOIU1PKuLrpjJODDZ4X3s7rnwEDy1W42PlXZZi49/AbZgqrrarIg8H1mSMIVCh/s8KcNiv6qAj5b7acu5rTeqsIfhh6Cgyv13oVU97+1B5JNgVsk2pIZWL7PNsSFUOnZAqBz3eG4XnvQe6cp1z2p3OzE+ycNQtmuoMr70C78DfRTxVvNInwyhzSXWW53jeSGj/NOowNsBGQZNS00xcRH2BepLS2/KDKz6+lGTbbKtvIk4vq8LTe20pj80qG9u/J3STvjlkfmAmkOi4/YB2JM3bdHmzEH+FConGFmIUbEh/ajqN4hpKg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(186003)(33656002)(38100700002)(55016002)(71200400001)(9686003)(122000001)(38070700005)(64756008)(8676002)(8936002)(508600001)(7416002)(2906002)(6636002)(4326008)(66556008)(66476007)(76116006)(66946007)(5660300002)(6506007)(86362001)(66446008)(26005)(52536014)(7696005)(316002)(110136005)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UHYyaDJKSzk3QkFOM2FBdlduOVFXM0tMK1dLK3o2M0syR09jOHE2aUU2enZY?=
 =?utf-8?B?cHNMU1BkVmxCR0dwaUp6WWRyZjNpTEZRVnV6YUJMMXE2YzRtWkFCRlJaa3pL?=
 =?utf-8?B?MUR5bTNEQ1BJZ3U3QzczSjhUT2g3alVaK2k1aFJYR1ZNRkxONncvaS9UR0JX?=
 =?utf-8?B?cEYxeHpDTTU3YUgyZ0hNN3lxZVlyUU9KTSs0TUp4OG1aRFFUODdqZnZ4cS9T?=
 =?utf-8?B?Y3FnTjM4ZkpoL1B0NEJ5endyVGM0Z2sraHpmam4wOUpwaTBHem1wNFd1cWw3?=
 =?utf-8?B?YU5RQVJ6SFdkU3JMVzIxc3o3blNYckg3dFlndyt2V3FCTHY2cVdzS2ZyTW5Z?=
 =?utf-8?B?LzJ1Zm5HT0diOXZYVHBsb01MMkpkU0pnWEs1MTVCQ243cDR2Vk1BVEdYOXR4?=
 =?utf-8?B?S0JOYzBORlVMbldmTkxPdHExblNBVFBsSWdnMWVRMDdHNEpHMTVRWjVXcEly?=
 =?utf-8?B?QVNKM3cxb2tvcEs0a3VnSXJkOEFKdFRYNmNqTnpISDY2MTN4YzJITUxHMDZE?=
 =?utf-8?B?MjhwRFpzZkFzLytqbEtaYkZWeWxqYlE3aDVTWmJSckJMdCttajV4WDQ0Skhs?=
 =?utf-8?B?WFNFaThsNmFRQnptTFVnb0lPYXVOMGxPRHdzb3c0VEgxS3dTaDMrbllZZ0Er?=
 =?utf-8?B?V3BSc291UjdmR045V2JBT2tLRFYwVVUrMHIzeXl2dmZvMGxFdk8wak5MZDZq?=
 =?utf-8?B?RDgvMVRvMERiTld6UWNudkFDWmJpQnU3U1BDZG5EUGFKeGtEOS9FVzhJblJJ?=
 =?utf-8?B?SVVxUEkzZlpJYXgyVktBNzdQVERHUGM1QVAreVR1OTdPWTRlb2ZWOEl1aXFt?=
 =?utf-8?B?SHJRcWh3cXpPRXBIRVBWK2duU2UySFlDam14ck9kY3B6MmR0WVhxWlJ2NXlk?=
 =?utf-8?B?WEFvY0M4WXZqeE54dSs5enV2R0VraEZEcGxDKzhDWFJsQStpVTVYN3MzdDBP?=
 =?utf-8?B?ME8yYXU3SFpDa2krV0VnUlJEV1pTczN3MnNSNVF1dmZ6dlpVT3hWb1hTQlVB?=
 =?utf-8?B?UjhDWW5WYTc2RXVKMUY3SzFoN1AxblVreW5ueVBac2liZVZqbmlUVkhQQ0ts?=
 =?utf-8?B?L3VXaHNHd1VOMUVvalNaMFN5WlptdzNTblViUXFLWlkvWVd1MlBQNktoVXNz?=
 =?utf-8?B?QVk2WldhKzZIZzBzOU9DSDF0RHZZeXlHUVhmVmNpNWNoUWFiT1JDbnFGTEtF?=
 =?utf-8?B?MDB0NjJUOCs4Mm9QMFdLanNpWmpEM1hLOU01dmR5d2pqUEk5VUNBU2E2a0Jn?=
 =?utf-8?B?UjhOUTBTMGxkMVpJbjk3R0pYQXRsK2Jkb3k1MlpVZjlnTldnRjROSFZiS2Zv?=
 =?utf-8?B?VEdDYTFsTlo2bThnSThFVUo5QXdCbHJIZitMdUZKWEFlcFNRdm5vTWFISmlm?=
 =?utf-8?B?YUJBVHA1OUViSG9CZTdEQzhxZ3pnN21zWUd3YThFT3BxTTEzYjZ4WkRPVFRy?=
 =?utf-8?B?eWVVMHZENTBVbWhMMTRFb0pFRlV0a1NVai9ZNUpqU0dHRFdUOWl6SHdTMWFI?=
 =?utf-8?B?ODA0SkJkaDUvdXVzRnMrdG1FWjc4eGpkeEZsNXF1c0JwSFNjRkNhS1czYlNm?=
 =?utf-8?B?bXE1WTFFQTZMa0l5dHplWG5BS29LVnBjeC9hYnllaXJPWjB0WDdWQ0h3NThN?=
 =?utf-8?B?RVRNZDE2SnU4ZnNhTHhNNXhSSk02ZUFHUk1yV3A4U05GVDV0TDgwR09icWlO?=
 =?utf-8?B?SWZNak4wdzV1bENNNWNGSmZXZDFHa3ZRVEVBaGs5V000ZTRKUnBOcDRMdmla?=
 =?utf-8?Q?A9Uflgd0EeVPN+ZHMBcCAeYPiRk3E7LFLLRpepj?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06c22150-8492-4801-7cba-08d97d7d2ac6
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2021 03:57:59.0122
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: o3QdhnZSfR1aqa5kG8egxdVdHnxT9ivNoBz44F5q72VNheEhecc/eRb2NcpoqzDwgui7XQnbuR8FWAB7nrF1uw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB3889
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPg0KPiBTZW50OiBXZWRuZXNk
YXksIFNlcHRlbWJlciAyMiwgMjAyMSAyOjE1IEFNDQo+IA0KPiBPbiBTdW4sIFNlcCAxOSwgMjAy
MSBhdCAwMjozODo0NFBNICswODAwLCBMaXUgWWkgTCB3cm90ZToNCj4gPiBbSEFDSy4gd2lsbCBm
aXggaW4gdjJdDQo+ID4NCj4gPiBUaGVyZSBhcmUgdHdvIG9wdGlvbnMgdG8gaW1wZWxlbWVudCB2
ZmlvIHR5cGUxdjIgbWFwcGluZyBzZW1hbnRpY3MgaW4NCj4gPiAvZGV2L2lvbW11Lg0KPiA+DQo+
ID4gT25lIGlzIHRvIGR1cGxpY2F0ZSB0aGUgcmVsYXRlZCBjb2RlIGZyb20gdmZpbyBhcyB0aGUg
c3RhcnRpbmcgcG9pbnQsDQo+ID4gYW5kIHRoZW4gbWVyZ2Ugd2l0aCB2ZmlvIHR5cGUxIGF0IGEg
bGF0ZXIgdGltZS4gSG93ZXZlcg0KPiB2ZmlvX2lvbW11X3R5cGUxLmMNCj4gPiBoYXMgb3ZlciAz
MDAwTE9DIHdpdGggfjgwJSByZWxhdGVkIHRvIGRtYSBtYW5hZ2VtZW50IGxvZ2ljLCBpbmNsdWRp
bmc6DQo+IA0KPiBJIGNhbid0IHJlYWxseSBzZWUgYSB3YXkgZm9yd2FyZCBsaWtlIHRoaXMuIEkg
dGhpbmsgc29tZSBzY2hlbWUgdG8NCj4gbW92ZSB0aGUgdmZpbyBkYXRhc3RydWN0dXJlIGlzIGdv
aW5nIHRvIGJlIG5lY2Vzc2FyeS4NCj4gDQo+ID4gLSB0aGUgZG1hIG1hcC91bm1hcCBtZXRhZGF0
YSBtYW5hZ2VtZW50DQo+ID4gLSBwYWdlIHBpbm5pbmcsIGFuZCByZWxhdGVkIGFjY291bnRpbmcN
Cj4gPiAtIGlvdmEgcmFuZ2UgcmVwb3J0aW5nDQo+ID4gLSBkaXJ0eSBiaXRtYXAgcmV0cmlldmlu
Zw0KPiA+IC0gZHluYW1pYyB2YWRkciB1cGRhdGUsIGV0Yy4NCj4gDQo+IEFsbCBvZiB0aGlzIG5l
ZWRzIHRvIGJlIHBhcnQgb2YgdGhlIGlvbW11ZmQgYW55aG93Li4NCg0KeWVzDQoNCj4gDQo+ID4g
VGhlIGFsdGVybmF0aXZlIGlzIHRvIGNvbnNvbGlkYXRlIHR5cGUxdjIgbG9naWMgaW4gL2Rldi9p
b21tdSBpbW1lZGlhdGVseSwNCj4gPiB3aGljaCByZXF1aXJlcyBjb252ZXJ0aW5nIHZmaW9faW9t
bXVfdHlwZTEgdG8gYmUgYSBzaGltIGRyaXZlci4NCj4gDQo+IEFub3RoZXIgY2hvaWNlIGlzIHRo
ZSB0aGUgZGF0YXN0cnVjdHVyZSBjb3VsZGUgbW92ZSBhbmQgdGhlIHR3bw0KPiBkcml2ZXJzIGNv
dWxkIHNoYXJlIGl0cyBjb2RlIGFuZCBjb250aW51ZSB0byBleGlzdCBtb3JlIGluZGVwZW5kZW50
bHkNCj4gDQoNCndoZXJlIHRvIHB1dCB0aGUgc2hhcmVkIGNvZGU/DQoNCmJ0dyB0aGlzIGlzIG9u
ZSBtYWpvciBvcGVuIHRoYXQgSSBwbGFuIHRvIGRpc2N1c3MgaW4gTFBDLiDwn5iKDQo=
