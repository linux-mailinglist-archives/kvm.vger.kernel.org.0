Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9294D340177
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 10:08:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbhCRJIF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 05:08:05 -0400
Received: from mga14.intel.com ([192.55.52.115]:55757 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229654AbhCRJHp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Mar 2021 05:07:45 -0400
IronPort-SDR: Yqf72BFybBg8D3YxN1yvxgB6GXzPC02NI9lkBQFVy9AJkmAn0ipXXd9pvfQOK7GVBsQyybTsT3
 ng5zbZedOgew==
X-IronPort-AV: E=McAfee;i="6000,8403,9926"; a="189008803"
X-IronPort-AV: E=Sophos;i="5.81,258,1610438400"; 
   d="scan'208";a="189008803"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2021 02:07:45 -0700
IronPort-SDR: Xqn6B8jx59UKZths6LI16MKk86QwbjKJOBVP67js6D2kg0HjY9NUdrr3wqkIys2WUGh+1INGmu
 tXs6NwARPV4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,258,1610438400"; 
   d="scan'208";a="602598147"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga006.fm.intel.com with ESMTP; 18 Mar 2021 02:07:45 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 18 Mar 2021 02:07:44 -0700
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 18 Mar 2021 02:07:43 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Thu, 18 Mar 2021 02:07:43 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.104)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Thu, 18 Mar 2021 02:07:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bDzOafm5QpXvyScVtkWxRju2aGbqXVNVml6GLHoevNBFxOW1eGSVtzldz9XZPMYsSKBE1rmqoppRx13h9X7s6Qs38327TMWJu3kPoNNvK7nrNpDsqWQDWt8+T6Q1Q7+39xN2wQcgQg5uZ1y2BMmDWWX81t7vDPdWmyS8yJ/5CoNLqlLFRitfsRYXAjeT5TvRBnSXUy/vqzH6TlBspYynmZFlJdmwrwA+LYBM8T2SFNvD/nG2dkJokoE4jMSHQhkB9/zPhHQwH1edlWd8SdTdJkDSjTj1dSp0dLA1o+h2lkBeyvy5Apov0wsaViIFl5ZewTuXAkXLFPSwuGCunqlBCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YDwNbeBWRdcE9eaMatpeqzc81Rvl+KsDp+7bu2hEs+k=;
 b=oRiRVhBitCIwPa/kaSz7vZpu8Cz+RbjuSsHy7gpkDqUcWztWMfLkghwi52ZgJE3Qo4gy6EohC8cVmRR97fga4lqfUOL3hTWeRIQ38OYI6wyqaLsNiz4K9fpoXltYOkTHQG6uZobJZuT3/YWOr2UobLJYxwyjSdqM91bf3ZG+r/Qa74OoJbPguAPAuTtDR7E3keLGrhi+iDhKhhhMrwjtm4lM6oghDcIyPjI3x4iELL5Psc55PCPxVGBkC2VzW4I7ZgU6cx92uRGHbP7SPNoL21DB+eeNZLmqySBUwQE1yEbpWAfenrX9xXu+X0dGCt1XSbqY/1OU62rPfgq02nlu8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YDwNbeBWRdcE9eaMatpeqzc81Rvl+KsDp+7bu2hEs+k=;
 b=GbOAAv2MpmgVnHd1VmwwYLm8yuXjLIsNvkKBoDutcgewW77eAbRSptllOrTF7ngei6s9U7rJYo9rGSI6xe35O4F3j90vhGDZVlsOkRz1NjD8lNLCX9mbvidRR8Tflkw8B29pl7uFLFA1RqrCoxAq8CbvSTX3kgnuK14cz1b+NTI=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by MW3PR11MB4572.namprd11.prod.outlook.com (2603:10b6:303:5e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Thu, 18 Mar
 2021 09:07:41 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::75b0:a8e9:60cb:7a29]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::75b0:a8e9:60cb:7a29%9]) with mapi id 15.20.3955.018; Thu, 18 Mar 2021
 09:07:41 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Shenming Lu <lushenming@huawei.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Eric Auger <eric.auger@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        "wanghaibin.wang@huawei.com" <wanghaibin.wang@huawei.com>,
        "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>
Subject: RE: [RFC PATCH v1 0/4] vfio: Add IOPF support for VFIO passthrough
Thread-Topic: [RFC PATCH v1 0/4] vfio: Add IOPF support for VFIO passthrough
Thread-Index: AQHW8vkytb+JKYXDyUeYG8HWtmg34ao/PksAgAOljRCAAZMegIADINTAgEIZxQCAABPukA==
Date:   Thu, 18 Mar 2021 09:07:40 +0000
Message-ID: <MWHPR11MB188656845973A662A7E96BDA8C699@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <20210125090402.1429-1-lushenming@huawei.com>
 <20210129155730.3a1d49c5@omen.home.shazbot.org>
 <MWHPR11MB188684B42632FD0B9B5CA1C08CB69@MWHPR11MB1886.namprd11.prod.outlook.com>
 <47bf7612-4fb0-c0bb-fa19-24c4e3d01d3f@huawei.com>
 <MWHPR11MB1886C71A751B48EF626CAC938CB39@MWHPR11MB1886.namprd11.prod.outlook.com>
 <4f904b23-e434-d42b-15a9-a410f3b4edb9@huawei.com>
In-Reply-To: <4f904b23-e434-d42b-15a9-a410f3b4edb9@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [101.88.226.48]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3a5f58ff-7760-4b98-9b7c-08d8e9ed48c4
x-ms-traffictypediagnostic: MW3PR11MB4572:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR11MB45722C057DB6B76668E39B718C699@MW3PR11MB4572.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LjOvPkb5VvnF8K05+7zzgPK4WI9e57EHeiuLgtY4bXGNzcYSQzSKO3/HZJx/My3vro53434L5+N39J2/hXBg0JPGeBKepFaSP3nbu/L8Dfd1xadOHbX0JrIRPnUM2o5L18l9JuUkaDEX7q2IjUQ2KpzAl+2YWib0dmnAI5IiA1nvHVF3yY77tk9g+rTgcgmPG8est1M2TxoYpOoWqu6KSrtRF/tgNAaQpJBZvItrALkDgMgZNsPow5NK8Ilwq7vEcvp23jE8IwLDS+o1nomW4HC8FzZcGXDFHr5RNMhq9okl5PKmNZQEspklroxLAIEoapiVwzcbD0dyZUSPXG21pllC6MzySI33NmZx72kn0GKRLk6LTckAPiyFUmI9dFpFPoBBfYDwAk4Wdezj10XKdzHjFEZr1LAlK0VYeeqYNGV5VsgzqEwFGl8swMwnLELU12J9FJ0Q1zsjveFiu0pRWXu4NlS71aLnDm1IDE8s49FdH8uZmZlLeHh90nZFpd8pejNvq2UER357lXiCTniRfPKIeK4fB9OZCDIBJRiXys3MpUcXvgHTkIsqcCgol2FZsvbkl5uCV1Ny9A1IfKWnEJhBOvwT31FxmA5+Sx0z3cEWGA+n245D7e2t6XD9+Bws
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(366004)(346002)(136003)(39860400002)(186003)(5660300002)(4326008)(2906002)(8936002)(38100700001)(7696005)(7416002)(110136005)(66946007)(54906003)(52536014)(316002)(478600001)(55016002)(71200400001)(6506007)(66446008)(8676002)(64756008)(26005)(86362001)(9686003)(33656002)(66556008)(66476007)(83380400001)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?M0Z0Nnd1YUoxVEtkdXR5eFFhaHUzZE82Z2hIOGhoNk5BTTU2N0JOalQvRkVO?=
 =?utf-8?B?UW01ZEhmWUlkZ2lRQkhYbVVOS1d2RmlWTEJZaWJKUVJFZEF5Nno1c0tCcU9j?=
 =?utf-8?B?bmgwMk5JaGErRDZXZVptYkNIL2l3amtQSEtMREhrZFA1VXdFUnFJbk9pT1lC?=
 =?utf-8?B?WmIvdVRPUkllWndQMXdtWTVMUmZmT1YzRTgreU83TXFoNkxMM2pDOWpLZyth?=
 =?utf-8?B?OTJ5NWhLNUJGaU96WUVZWEQ4dXZxWE1PdUxpT25wNWJsYXByUDkwdWtTYjZ0?=
 =?utf-8?B?OGk5WWtadDl1OUJ0WFg1VzF2R0svOHQ4MFdvWE9vNXRYZGVSaU9majBpcGFx?=
 =?utf-8?B?dnF1ZUdyOUZkSG5QcVV1eklMSU5JTi85cGl4ampDYWt5ckpXZzRQczdqYVlC?=
 =?utf-8?B?cnpJRnJnbUYxeTRYTWhGREF2SlNKcjNTYitFa0p5b1BKUXd1UENrUUpTWXF3?=
 =?utf-8?B?QTZMRER5NFpOZlFQeEZYSXN1S2N5MkVEdEtQUUtXWFNWNDlCU2M4QXBZTE05?=
 =?utf-8?B?K3JSdEY3UmgwQ2ZTcERncUdqNTZVMThhVzNIaVhkb2MxcXZ3TDNZNTZGdWNp?=
 =?utf-8?B?ZVJuWjBONFNCUWdBdlhqcmowWkYyR3V0VVpiQUsxd2VUTEpxTWV0RG5wZ1dR?=
 =?utf-8?B?cFdTK2ZxVXE0S05GY0lXOU1kbmdYODFOQUN6QWRVRGdHZ0Nmc1hLMmxTdHBj?=
 =?utf-8?B?NnVkY0JoZGdGWnBpU2MxQzFFcThoYmF0bzN6eTIrQVBlQisrU1JtR0Y5WnJn?=
 =?utf-8?B?bFgrdVdnem9RZ0pEUHl6N3RwZCtkdVFwSm8vRmxFemozVVNWZUsrYndRSUZI?=
 =?utf-8?B?eHlQb2ZoS3pmazlyR3NxYi8xT1haNi9HK2wwcWZPamV1Wk85TlZCUnhpRUk4?=
 =?utf-8?B?V0ErYzV1WFhUenFXeXBudGJLc0EwaFpjbEczdEMxYStPSjliQlZjb1duNWFr?=
 =?utf-8?B?Y1pUSk9LL0tLRG45b1V0REw3M3JiakxDTjhNQ3RmT3JnVmRZS1pLcGRmT3Fn?=
 =?utf-8?B?VmRhcG9EY0ZPbWFDQ1NFT09zM0luT2FQd2VzbG9iTFN5ZTc1S2xsalN2VkNs?=
 =?utf-8?B?WEtQQUpoT05rbWVTQW43RDdyQllUUmJJSmFtbllXbkxZM3oyRG5rM1ZuUW1m?=
 =?utf-8?B?WTkyZ3ZBa2p0V0MzWU55QzBDSmNqYkdkamFTUWdJMEdxdjVVaDdONVlOMWNu?=
 =?utf-8?B?RHY5Z2NWLzh3Z25kRmcvaitoTk8vTStXSVA4TWN6eDhVU3ErUFUzbmd5YVkw?=
 =?utf-8?B?MnhqaWc5YUpUVTdrVTZRcGpJaVgxU05uTlJNcUl2SkFoK1orZ1hSWVRhckhB?=
 =?utf-8?B?c25HZ3Q3OEthUVY0akR6TWJtM1N6SXREeG1ROFBUeU5zZHNUOHFFTk40ZllK?=
 =?utf-8?B?RlRiWjVSRFJsRGJPVEdRMTk1L1c4Rk1LUWttdEwyaGRnUDVxbjZ3U3plSGZX?=
 =?utf-8?B?TDJLbThrV1JhdHVTeEhoNVlpQU92Rnc5bGkxSEJZR3psQVk4R3ZYRlB5TVN5?=
 =?utf-8?B?U1NrSmxOdHJPU1VjWFY3NTlRZnkvUHBTVmRIaC9pY1NiaDdiWUY0MFg1a3hD?=
 =?utf-8?B?d3RVcHozTUZZdHRPMTZiSDZVZXlXSVdsR2RoNUZKdVhPbG96Umt0YmNQTHRI?=
 =?utf-8?B?MEgyZElzT2VCQ0M0aEhSZUV4TDczeHJPTk8vbm4xWCt3akZwMStGYWRvd0tR?=
 =?utf-8?B?WnBKYVV6WEM2M0JGUjkrRXhQLzRhd1ZlK1JHL0ZDa3FSaCsvNllYVFlxdmRN?=
 =?utf-8?Q?fWo7eeUlT9A6jDKi2eVF18BHNZ46ijIKJxRxjRn?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a5f58ff-7760-4b98-9b7c-08d8e9ed48c4
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Mar 2021 09:07:40.9360
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6SwWhtn5o5FNoL+Xev5PTDV+MFgYNwTHEwPk0E9ptFwrwnMFtBt5jKv0+lVz2Pr4NjtL4cQBM/L+YBq8TPGEUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4572
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBTaGVubWluZyBMdSA8bHVzaGVubWluZ0BodWF3ZWkuY29tPg0KPiBTZW50OiBUaHVy
c2RheSwgTWFyY2ggMTgsIDIwMjEgMzo1MyBQTQ0KPiANCj4gT24gMjAyMS8yLzQgMTQ6NTIsIFRp
YW4sIEtldmluIHdyb3RlOj4+PiBJbiByZWFsaXR5LCBtYW55DQo+ID4+PiBkZXZpY2VzIGFsbG93
IEkvTyBmYXVsdGluZyBvbmx5IGluIHNlbGVjdGl2ZSBjb250ZXh0cy4gSG93ZXZlciwgdGhlcmUN
Cj4gPj4+IGlzIG5vIHN0YW5kYXJkIHdheSAoZS5nLiBQQ0lTSUcpIGZvciB0aGUgZGV2aWNlIHRv
IHJlcG9ydCB3aGV0aGVyDQo+ID4+PiBhcmJpdHJhcnkgSS9PIGZhdWx0IGlzIGFsbG93ZWQuIFRo
ZW4gd2UgbWF5IGhhdmUgdG8gbWFpbnRhaW4gZGV2aWNlDQo+ID4+PiBzcGVjaWZpYyBrbm93bGVk
Z2UgaW4gc29mdHdhcmUsIGUuZy4gaW4gYW4gb3B0LWluIHRhYmxlIHRvIGxpc3QgZGV2aWNlcw0K
PiA+Pj4gd2hpY2ggYWxsb3dzIGFyYml0cmFyeSBmYXVsdHMuIEZvciBkZXZpY2VzIHdoaWNoIG9u
bHkgc3VwcG9ydCBzZWxlY3RpdmUNCj4gPj4+IGZhdWx0aW5nLCBhIG1lZGlhdG9yIChlaXRoZXIg
dGhyb3VnaCB2ZW5kb3IgZXh0ZW5zaW9ucyBvbiB2ZmlvLXBjaS1jb3JlDQo+ID4+PiBvciBhIG1k
ZXYgd3JhcHBlcikgbWlnaHQgYmUgbmVjZXNzYXJ5IHRvIGhlbHAgbG9jayBkb3duIG5vbi1mYXVs
dGFibGUNCj4gPj4+IG1hcHBpbmdzIGFuZCB0aGVuIGVuYWJsZSBmYXVsdGluZyBvbiB0aGUgcmVz
dCBtYXBwaW5ncy4NCj4gPj4NCj4gPj4gRm9yIGRldmljZXMgd2hpY2ggb25seSBzdXBwb3J0IHNl
bGVjdGl2ZSBmYXVsdGluZywgdGhleSBjb3VsZCB0ZWxsIGl0IHRvIHRoZQ0KPiA+PiBJT01NVSBk
cml2ZXIgYW5kIGxldCBpdCBmaWx0ZXIgb3V0IG5vbi1mYXVsdGFibGUgZmF1bHRzPyBEbyBJIGdl
dCBpdCB3cm9uZz8NCj4gPg0KPiA+IE5vdCBleGFjdGx5IHRvIElPTU1VIGRyaXZlci4gVGhlcmUg
aXMgYWxyZWFkeSBhIHZmaW9fcGluX3BhZ2VzKCkgZm9yDQo+ID4gc2VsZWN0aXZlbHkgcGFnZS1w
aW5uaW5nLiBUaGUgbWF0dGVyIGlzIHRoYXQgJ3RoZXknIGltcGx5IHNvbWUgZGV2aWNlDQo+ID4g
c3BlY2lmaWMgbG9naWMgdG8gZGVjaWRlIHdoaWNoIHBhZ2VzIG11c3QgYmUgcGlubmVkIGFuZCBz
dWNoIGtub3dsZWRnZQ0KPiA+IGlzIG91dHNpZGUgb2YgVkZJTy4NCj4gPg0KPiA+IEZyb20gZW5h
YmxpbmcgcC5vLnYgd2UgY291bGQgcG9zc2libHkgZG8gaXQgaW4gcGhhc2VkIGFwcHJvYWNoLiBG
aXJzdA0KPiA+IGhhbmRsZXMgZGV2aWNlcyB3aGljaCB0b2xlcmF0ZSBhcmJpdHJhcnkgRE1BIGZh
dWx0cywgYW5kIHRoZW4gZXh0ZW5kcw0KPiA+IHRvIGRldmljZXMgd2l0aCBzZWxlY3RpdmUtZmF1
bHRpbmcuIFRoZSBmb3JtZXIgaXMgc2ltcGxlciwgYnV0IHdpdGggb25lDQo+ID4gbWFpbiBvcGVu
IHdoZXRoZXIgd2Ugd2FudCB0byBtYWludGFpbiBzdWNoIGRldmljZSBJRHMgaW4gYSBzdGF0aWMN
Cj4gPiB0YWJsZSBpbiBWRklPIG9yIHJlbHkgb24gc29tZSBoaW50cyBmcm9tIG90aGVyIGNvbXBv
bmVudHMgKGUuZy4gUEYNCj4gPiBkcml2ZXIgaW4gVkYgYXNzaWdubWVudCBjYXNlKS4gTGV0J3Mg
c2VlIGhvdyBBbGV4IHRoaW5rcyBhYm91dCBpdC4NCj4gDQo+IEhpIEtldmluLA0KPiANCj4gWW91
IG1lbnRpb25lZCBzZWxlY3RpdmUtZmF1bHRpbmcgc29tZSB0aW1lIGFnby4gSSBzdGlsbCBoYXZl
IHNvbWUgZG91YnQNCj4gYWJvdXQgaXQ6DQo+IFRoZXJlIGlzIGFscmVhZHkgYSB2ZmlvX3Bpbl9w
YWdlcygpIHdoaWNoIGlzIHVzZWQgZm9yIGxpbWl0aW5nIHRoZSBJT01NVQ0KPiBncm91cCBkaXJ0
eSBzY29wZSB0byBwaW5uZWQgcGFnZXMsIGNvdWxkIGl0IGFsc28gYmUgdXNlZCBmb3IgaW5kaWNh
dGluZw0KPiB0aGUgZmF1bHRhYmxlIHNjb3BlIGlzIGxpbWl0ZWQgdG8gdGhlIHBpbm5lZCBwYWdl
cyBhbmQgdGhlIHJlc3QgbWFwcGluZ3MNCj4gaXMgbm9uLWZhdWx0YWJsZSB0aGF0IHNob3VsZCBi
ZSBwaW5uZWQgYW5kIG1hcHBlZCBpbW1lZGlhdGVseT8gQnV0IGl0DQo+IHNlZW1zIHRvIGJlIGEg
bGl0dGxlIHdlaXJkIGFuZCBub3QgZXhhY3RseSB0byB3aGF0IHlvdSBtZWFudC4uLiBJIHdpbGwN
Cj4gYmUgZ3JhdGVmdWwgaWYgeW91IGNhbiBoZWxwIHRvIGV4cGxhaW4gZnVydGhlci4gOi0pDQo+
IA0KDQpUaGUgb3Bwb3NpdGUsIGkuZS4gdGhlIHZlbmRvciBkcml2ZXIgdXNlcyB2ZmlvX3Bpbl9w
YWdlcyB0byBsb2NrIGRvd24NCnBhZ2VzIHRoYXQgYXJlIG5vdCBmYXVsdGFibGUgKGJhc2VkIG9u
IGl0cyBzcGVjaWZpYyBrbm93bGVkZ2UpIGFuZCB0aGVuDQp0aGUgcmVzdCBtZW1vcnkgYmVjb21l
cyBmYXVsdGFibGUuDQoNClRoYW5rcw0KS2V2aW4NCg==
