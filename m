Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF8E475381
	for <lists+kvm@lfdr.de>; Wed, 15 Dec 2021 08:09:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240386AbhLOHJq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Dec 2021 02:09:46 -0500
Received: from mga17.intel.com ([192.55.52.151]:57130 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240334AbhLOHJp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Dec 2021 02:09:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639552185; x=1671088185;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=oZtumBL89VUJwQKdN6QThYmxdKBYnyU41/I0SlSzThk=;
  b=Iyh4fiurCxn+zVmFeAcNB0poy9lhJAs55L4AiNUO8mn/jquTOWkapJs7
   tbQXuMR5GNLNCMy+7YWw/10V1sipqTZkL3gJM4Yo80UPwjSNZ1nnz+9/v
   ZXMOb71vVaQdZBQRG+DufHfIQvu62GDbVhnj+TGclxc0/EWU0UaBgxHKK
   AzYta1uEcj3jGAH5/PniOvx2hFWKj0zPS5KlQ4Bv3hii8kUXE9z8zlzZx
   JHULY8unQsz5cVE3uUAq3uQ94dhZttmrSTD8W/x1szqQV0mNuN89tdWwR
   fxuHpAATndGrARjOvJyjj85mIAMyCmSbMmJGlA1aGiMBsV/396S6+2Z6N
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10198"; a="219849647"
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="219849647"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2021 23:09:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="545482096"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by orsmga001.jf.intel.com with ESMTP; 14 Dec 2021 23:09:44 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 14 Dec 2021 23:09:44 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 14 Dec 2021 23:09:44 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Tue, 14 Dec 2021 23:09:44 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.108)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Tue, 14 Dec 2021 23:09:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R7guzULhnAGhUFuphZQvLYXkA/JD+YNLyXkly7SP3G5SNv1l+A2rCeVj86sejgJIRhysFqcpLaPhzgWKiAYUloXLVkk7UiQc43T4eQubNDbZzPjCbPQLT7ciP/8EsPX0NqzKr1XWHMlVtYY0rv+SxPIs1WSzeLwj1tbrA1WvKimYXIvvISHPumJL2GnlJOid2y/0K1SW+JwqeiJefdbqZHBlsxenamSc4qM3A73v/CQDXDulCDGJyJi53gdps3junJ8gKrv8XFtKN3Ee2DEhsWk3fEgbiqtvATLuVSphXs2ZPPf1iAmkhw8bD6oO8JDRpn90k2pOYuTSx//6yAqT1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oZtumBL89VUJwQKdN6QThYmxdKBYnyU41/I0SlSzThk=;
 b=DFNimuLq2W4FB77sLhhIGmO7u3Xd9NNlE5gLND0B9t9MpVrZQGO20HsoO3RpOfdUtAc5DRIx45HOzVsKAx3veGez1VFdDVYe0x21prr6028YlzrHNiSYogSRpl8I61giZ/A05inQKGHQ8eclx84WlUuThhDDvY+6Tef0FzGy53GVb/wsnphBGvtsZihoH2YpnkzIByTOJhOnIRp27z54O5S6nbC222JFJWF6MasbJnDfEL9HYZsnPHqD2QiUacyLMyAkEP6QWnOsjJ+irLKbveBMMWUdcnOdp3vKRG5RhRYE7ZOty+RWPKln/OzFZ3J5i3VFngZC/JGOjs1Pj2H7ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oZtumBL89VUJwQKdN6QThYmxdKBYnyU41/I0SlSzThk=;
 b=YD7UXLQhlUsOeZkKgcLUMd9erdhq57dsrv6YIPCHYH5q8sU2mZzeQ8DKd315VJi28ucl/YWYgpP4ZGusHJQ4NolT+WyNiNmhUa4JcmSfeYKIrsTcYwEaU05DJ3EQgP7CCJDCkTJJ3pM5VumZHDKuxRroF/HcBkgwXgFNi37s50o=
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN7PR11MB2610.namprd11.prod.outlook.com (2603:10b6:406:ab::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.16; Wed, 15 Dec
 2021 07:09:39 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04%3]) with mapi id 15.20.4778.018; Wed, 15 Dec 2021
 07:09:39 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Jing2" <jing2.liu@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Zhong, Yang" <yang.zhong@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
CC:     "Christopherson,, Sean" <seanjc@google.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "jing2.liu@linux.intel.com" <jing2.liu@linux.intel.com>
Subject: RE: [PATCH 09/19] kvm: x86: Prepare reallocation check
Thread-Topic: [PATCH 09/19] kvm: x86: Prepare reallocation check
Thread-Index: AQHX63yAqCRfeGSRMUi4D/tAeYgczawwLT2AgAFthgCAADWBAIAASjIAgAESOSA=
Date:   Wed, 15 Dec 2021 07:09:39 +0000
Message-ID: <BN9PR11MB5276E47CE437597435FE4B188C769@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20211208000359.2853257-1-yang.zhong@intel.com>
 <20211208000359.2853257-10-yang.zhong@intel.com>
 <fc113a81-b5b8-aaae-5799-c6d49b77b2b4@redhat.com>
 <BN9PR11MB5276416CED5892C20F56EB888C759@BN9PR11MB5276.namprd11.prod.outlook.com>
 <d513db49-bb94-becf-be7e-f26dceb3e1bf@redhat.com>
 <MWHPR11MB12453B3CE026CE7087C29E3FA9759@MWHPR11MB1245.namprd11.prod.outlook.com>
In-Reply-To: <MWHPR11MB12453B3CE026CE7087C29E3FA9759@MWHPR11MB1245.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a0b77f50-72f6-4082-8a9d-08d9bf99dc34
x-ms-traffictypediagnostic: BN7PR11MB2610:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BN7PR11MB26102854C15C6B43BCAE23FA8C769@BN7PR11MB2610.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ojgpzrfKdBvh2rYJK0PtRMWx/vUklNjEXxVv3ZUHnkBwEmXjAPC5iFpruQQ0yh1l9fzHKoGz3a8dRIztqEUjN4zXiJpmwR2A39LDN+pFRp/y78Ra6BXnyEDLNPvGVV/n/fdPzfsZMmVNF8FvpaGSuUb+29T+wFIAGO1JubxfcT58/Y8wqu6aRryHE8IEjz73cT/2jvxDVfJN+u06PeY+5ECuqTU0ezPc3EP9w+v0/+X5PIWkm98x7SDdeCvHC78wKJGPncOOONeDnt46giaNZvi/aAF/Y1BImBNFf7XGtUf2CLm6T8vo6HGkV/bIgz9RWna81iElH5dqkWi1gNw0VfIDYJydni5nxcM9k6RXKU+B8/mVvfubrNR3ikxHRX4Y1srSoY1hOvOgkhWjAi5MEFrgGLTP/ZeGH6i8cU0QrExNvzAat650h884uh0b78bCz8YiFW7Nr7sV/naRcVzjr9osBc2TaBlDwEy/eozXvqrD6NLBmIsUzfl8rBeN1F8upiAzXGZ4/cAbdc+4uow8o2NmzgO3EvvVPWFQYwBH4qKpOcs3D1AEEEG0c5POxDspdRKAn69BIAlJSB8687OAFiuoY7peF5eV9KQSfYvXte/Bta/SAeVN+3pjj5OFpQMhzeMkH465Q44vSuEOnS+w8vMe1y4u56SDy1kjrJxUYaAvlVdR+Y346wwbbZ2GngAHsH+9L2/W94XtDvC1bzjh45XQiymzLPTjyH/5nmthEDE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66556008)(66476007)(82960400001)(8676002)(2906002)(4326008)(54906003)(52536014)(64756008)(71200400001)(66446008)(55016003)(83380400001)(9686003)(508600001)(26005)(5660300002)(921005)(110136005)(66946007)(33656002)(8936002)(86362001)(38070700005)(38100700002)(316002)(186003)(6506007)(76116006)(53546011)(7696005)(7416002)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VHB0WUhHdXBCd2tnTVMxS3QxcStMU21uUHA4KytrWEUrS2ZvSndTd0d1TUh4?=
 =?utf-8?B?bjdxKzlpSVh1LzN0U05oNUZaSVFBVlFndmdQZ2g2RzVOMHB5SUMwa2NKVHNz?=
 =?utf-8?B?VHJ6dUJlRjJ0dGUzRnVEc29DVmRnUjROSW9xVUdxeVlMek9YMEt3QkZod29q?=
 =?utf-8?B?NWFydlVTb3Z2ZUlEcHZwZnFZZEFZdk93dEFKNURwanVjN2FaZVEwUWlqa1VQ?=
 =?utf-8?B?VlBQRU9VWEVESURVRTRwTzhZUWZZcTJwMW1LOHZ4YUpNMTd6Yjlwa0I5ZUIx?=
 =?utf-8?B?alh1MGpoZ3J2anBLTnFvWE4vMUYvek1jS3VCNlAxU1B0RnZ3N2d6eEErRFBV?=
 =?utf-8?B?NGtsVnF6eFp1QVF2M04xWHNuRXJSeW82NmVlbHhqOGVPYmxRWUZGai9YM21I?=
 =?utf-8?B?YTJGRmVZMDRJMzBkRWQycVNaYStQVTRtZVhrWkZrOFN3eWVyNWQ3V1RVRmtN?=
 =?utf-8?B?MWZhQTcrSVh6SmVRb2hTcHQwL3JUQ3FRYzFwU05OcEVqTmgvaXhKVXpYbHBB?=
 =?utf-8?B?WDZtbXRKOVM3UEQzakNPaFpVKzJCY2xweHhiYW1lY3ZhVmtOajJqc29Ec0Vw?=
 =?utf-8?B?SE1lTUhFcjFsMEVUVlFmY1I3M2tURThQYXdmTFpySnFWVWR3UHpQcW93U0FX?=
 =?utf-8?B?dWNDQWFjS09rZEdtcTRjM0VuY2pSY1VzaEcrUndwbFkydGpUSERNckJ3ZDJ4?=
 =?utf-8?B?aUh4a3dWaWxpRzFqQmJtdjV5L0lqOXZsS3dueWVKT3F4VXQrRkdGK0IzdTdj?=
 =?utf-8?B?RFoxWXBiYysyZzRGOUltTCtpeCtyUVRtSnJaT1IzR21KVjVuRHdUYXB3MnhP?=
 =?utf-8?B?UXl5aHNnSjJoMjVkN0gxWWNQYkh0eUVob3dCTHRIbHVLeUd0eVZQQTNWbTJ5?=
 =?utf-8?B?OXlJSmdkWTVxOExtYVEvTXBJMzNYK3RXSGliNHVQTlAvcnZnYmVLK25PSU40?=
 =?utf-8?B?ZU1JZGJlZy9lYVVYZFhGVUljWkJDVG9zSDVkZXBPRW5QamZvTkJ4K3JveFR1?=
 =?utf-8?B?R0xVMjZSUWcrYTVVN3N6NERkc2prYWxPOXF2WnIydUJnR2NwV3FkSm9VTXFu?=
 =?utf-8?B?WXlQV3hKUkVkYjIxWDRQMklleEUxQ0JOWjJFcTBDSDNzQVpSSlY3UHN2M0t1?=
 =?utf-8?B?SkFhUWpvQWlKYTh1S1dMVTE0Rk1Xc1U2eW1Vb2hJS0ZLQXBtb0xQZmN3VkRL?=
 =?utf-8?B?N3B0cTR0OVV0TURhVjY2aXk4NHRobTBOOE51YTJIaFdGWlZRU2JMSUluYmJl?=
 =?utf-8?B?Z245cDNKZWlZL2UvZXhFOXkxQTgyb3lkT3hyOVNSS0dQWEhQWmh2R3JMSHho?=
 =?utf-8?B?a2xjMlR3TWN0NWJYbmY0Q1l0WktaZkpsUUZBbVc2emhsOGFnZ2dlSDBpWmpk?=
 =?utf-8?B?WVlnRDBuU3pnQ2sxN21NWm9RdGRyWklJMThsQk1Kalh0VWg2aXUwWURtSzRC?=
 =?utf-8?B?b0lFOC9ZTjlDQ05FY1NOcXlwN0ZETmdvb3FYaHdHbldwaHJ6OXJHVlNtdks1?=
 =?utf-8?B?a1d6ZVEzcTJ2a3JvdGdOK1k0bUtzck50ZVFIeUlKODhKUlFiYkkrbFowUmNG?=
 =?utf-8?B?QTA3UzZrMXlKT3VyMjBObTZncEwxZE40V1ZuN1pmRUNQTnpla09PaWkwdXlr?=
 =?utf-8?B?Wjl6WGlOMGY5U2dhOVhVOVFtT0YxMmhSdEZ2R0ZJbUdVblUyY0JPOVo1UmFJ?=
 =?utf-8?B?M3BkajRoak5jUVJLZDhkcWkyRTl2YkU3ejAvYy9UZGR2VW9jaWVRWVg0L05B?=
 =?utf-8?B?ZXM4eFp2ay9MTDZwSFVYM1J2bHZMb0NxdmdrMjNiUzlnejZFV09VNTZEMkVk?=
 =?utf-8?B?NjVLTm10eDhZLzhuenlUWlRCcjlVYUZqSXB5aTJWN2NGeU1BdEFraDYybUdv?=
 =?utf-8?B?dWw3VDdFT0NqU2Y0c3lMTUdxQW1acVliTURuWTdxS2hCeXFWbERocEVkalVZ?=
 =?utf-8?B?Z0lhMm1nWVFFWnlERHBXTzlPS2t3SkNadlJjZDYyZ1B6T3ZreDdUYVQ2eHZw?=
 =?utf-8?B?N1BFNG16STZSMDBMVVhGM3FFMVhHMXNhTTdHMW1keXFhemVOMG5NYW43c0xL?=
 =?utf-8?B?cHN0WWR4Y1p3WWVkSG1rSE5GTGxhYzY5YnNVRVJGYkNTeHVCVlJ3QTdvSHpL?=
 =?utf-8?B?aGFIUjR4WEN6Ymdud1VOV2tuK3RjQTJCMjlVTWt1MzRDbFltS1RBVWZ6Ym4v?=
 =?utf-8?Q?tMuMU7T3D46F4l9hTC6e3sY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0b77f50-72f6-4082-8a9d-08d9bf99dc34
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2021 07:09:39.3514
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aFZKda8PI6MIzV/mJ84RzIH46K/7+loJ57vdJLwptYThALQY3tZ/SbjJ1wpgv8y+rCaT5nuaiaobU4H89x3oZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR11MB2610
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBMaXUsIEppbmcyIDxqaW5nMi5saXVAaW50ZWwuY29tPg0KPiBTZW50OiBUdWVzZGF5
LCBEZWNlbWJlciAxNCwgMjAyMSAxMDo0MiBQTQ0KPiANCj4gT24gMTIvMTQvMjAyMSA2OjE2IFBN
LCBQYW9sbyBCb256aW5pIHdyb3RlOg0KPiA+DQo+ID4gT24gMTIvMTQvMjEgMDg6MDYsIFRpYW4s
IEtldmluIHdyb3RlOg0KPiA+ID4+IC0gaWYgKGR5bmFtaWNfZW5hYmxlZCAmIH5ndWVzdF9mcHUt
PnVzZXJfcGVybSkgIT0gMCwgdGhlbiB0aGlzIGlzIGENCj4gPiA+PiB1c2Vyc3BhY2UgZXJyb3Ig
YW5kIHlvdSBjYW4gI0dQIHRoZSBndWVzdCB3aXRob3V0IGFueSBpc3N1ZS4NCj4gPiA+PiBVc2Vy
c3BhY2UgaXMgYnVnZ3kNCj4gPiA+DQo+ID4gPiBJcyBpdCBhIGdlbmVyYWwgZ3VpZGVsaW5lIHRo
YXQgYW4gZXJyb3IgY2F1c2VkIGJ5IGVtdWxhdGlvbiBpdHNlbGYgKGUuZy4NCj4gPiA+IGR1ZSB0
byBubyBtZW1vcnkpIGNhbiBiZSByZWZsZWN0ZWQgaW50byB0aGUgZ3Vlc3QgYXMgI0dQLCBldmVu
IHdoZW4NCj4gPiA+IGZyb20gZ3Vlc3QgcC5vLnYgdGhlcmUgaXMgbm90aGluZyB3cm9uZyB3aXRo
IGl0cyBzZXR0aW5nPw0KPiA+DQo+ID4gTm8gbWVtb3J5IGlzIGEgdHJpY2t5IG9uZSwgaWYgcG9z
c2libGUgaXQgc2hvdWxkIHByb3BhZ2F0ZSAtRU5PTUVNIHVwIHRvDQo+ID4gS1ZNX1JVTiBvciBL
Vk1fU0VUX01TUi4gIEJ1dCBpdCdzIGJhc2ljYWxseSBhbiBpbXBvc3NpYmxlIGNhc2UgYW55d2F5
LA0KPiA+IGJlY2F1c2UgZXZlbiB3aXRoIDhLIFRJTEVEQVRBIHdlJ3JlIHdpdGhpbiB0aGUgbGlt
aXQgb2YNCj4gPiBQQUdFX0FMTE9DX0NPU1RMWV9PUkRFUi4NCj4gPg0KPiA+IFNvLCBzaW5jZSBp
dCdzIG5vdCBlYXN5IHRvIGRvIGl0IHJpZ2h0IG5vdywgd2UgY2FuIGxvb2sgYXQgaXQgbGF0ZXIu
DQo+IA0KPiBGb3IgdGhlIHdheSBoYW5kbGluZyB4Y3IwIGFuZCB4ZmQgaW9jdGwgZmFpbHVyZSwg
eGNyMCBhbmQgeGZkIGhhdmUNCj4gZGlmZmVyZW50IGhhbmRsaW5ncy4gQ3VycmVudCBLVk1fU0VU
X1hDUlMgcmV0dXJucyAtRUlOVkFMIHRvDQo+IHVzZXJzcGFjZS4gS1ZNX1NFVF9NU1IgaXMgYWx3
YXlzIGFsbG93ZWQgYXMgdGhlIGRpc2N1c3Npb24gaW4NCj4gYW5vdGhlciB0aHJlYWQuDQo+IA0K
PiBTbyBJJ20gdGhpbmtpbmcgaWYgcmVhbGxvY2F0aW9uIGZhaWx1cmUgaW4gS1ZNX1NFVF9YQ1JT
IGFuZA0KPiBLVk1fU0VUX01TUiAobWF5IGR1ZSB0byBOT01FTSBvciBFUEVSTSBvciBFTk9UU1VQ
UCksDQo+IHdoYXQgaXMgdGhlIHdheSB3ZSB3b3VsZCBsaWtlIHRvIGNob29zZT8NCj4gDQoNCktW
TV9TRVRfTVNSUyBjYW4gZGVmaW5pdGVseSBhY2NlcHQgZmFpbHVyZSBhY2NvcmRpbmcgdG8gbXNy
X2lvKCkuDQpJIHRoaW5rIFBhb2xvJ3MgcG9pbnQgaXMgbW9yZSBhYm91dCB0aGF0IHRoZSByZXN0
b3JlIHBhdGggc2hvdWxkIG5vdA0KaW5oZXJpdCBhbnkgY2hlY2sgcmVsYXRlZCB0byB2Q1BVIGNh
cGFiaWxpdHkuIEl0J3MgYSBkaWZmZXJlbnQgbWF0dGVyDQppZiB0aGUgZXJyb3IgaXMgY2F1c2Vk
IGJ5IG90aGVyIGhvc3Qga2VybmVsIGVycm9ycy4NCg0KR2l2ZW4gdGhhdCB3ZSBkb24ndCBuZWVk
IGFueSBzcGVjaWFsIGhhbmRsaW5nIGJldHdlZW4gdGhlIHR3bw0Kc2NlbmFyaW9zIChzZXQgYnkg
Z3Vlc3QgdnMuIHNldCBieSBob3N0KSBpbiB0aG9zZSBlbXVsYXRpb24gcGF0aHMuIA0KSnVzdCBy
ZXR1cm4gJzEnIHRvIGluZGljYXRlIGVycm9yIGFuZCB3aGF0ZXZlciBlcnJvciBwb2xpY3kgZXhp
c3RzIA0KaW4gdGhvc2Ugc2NlbmFyaW9zIGlzIGp1c3QgYXBwbGllZC4NCg0KVGhhbmtzDQpLZXZp
bg0K
