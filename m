Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25DB341A9B0
	for <lists+kvm@lfdr.de>; Tue, 28 Sep 2021 09:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239250AbhI1Hcc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 03:32:32 -0400
Received: from mga06.intel.com ([134.134.136.31]:39589 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239083AbhI1Hca (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Sep 2021 03:32:30 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10120"; a="285652219"
X-IronPort-AV: E=Sophos;i="5.85,328,1624345200"; 
   d="scan'208";a="285652219"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2021 00:30:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,328,1624345200"; 
   d="scan'208";a="478594063"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by fmsmga007.fm.intel.com with ESMTP; 28 Sep 2021 00:30:49 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 28 Sep 2021 00:30:48 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 28 Sep 2021 00:30:48 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Tue, 28 Sep 2021 00:30:48 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Tue, 28 Sep 2021 00:30:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jOZqp1bpo+wyaTnvrIYES4ZDuHAw2aK23OQoKgyRLv5x6WP4QkT1ytAzNGO4Vampw6r2x62Z/sWrhzBmKqkL+eMy4KlQRb+cWlwfiQ2kz/7rbXenJ0h9LIfeWKuYEnQJe1WQT65MqOygDmY5fY0f9IDvreV+CpRhDNDLWnIaBvhesvGVYgdD32oUHi2scz4VoTubQwQHX94RACfzi7F9aywAGlN6hQE1vCdb7QCbRbhIAWvHzUwaD/RP0tJXXIEAv0t/2ImkbHGmw9kqGoMhbJRr3mu4YsGwEb7YdNgy+r0nlHKRQh64JW4OSA/8cSakFEvxiW5R2EXro6R1Cv+M5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=DHWbWDzwJ29Z1o2rViAYICfEed7mVxV1IXKnYxvNTpo=;
 b=ld+MlESaqi5HsjjLI5Tzx7nIEn4Yvir1E5UbWOqjMsgtiAzU1fSl619wU+C1dawKtD512Dzo0HqVWTMOW//BtWa95GN2z53YCue5M2HvwnB6LodST75IdaukvmHhURfTegQLmCg3aKO67kbG3tvy9F/pCZGwDMA/QWQ2vVdZChW/RC4uuqCgx5mnwCOPwERkyJ/N5TtKHgMgX6mI/E4DCu27tGG/3ys//2GAZFTpbU7rb8uQn5W0OvX+s1wM9ZpNkDS2y3VkP1WMME296RAE/zvRjbcxpJjqSH26PBdbTSytGJkCqOnCYsj4cz0yaUCST7ffjv8mEbws7BYiI8khbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DHWbWDzwJ29Z1o2rViAYICfEed7mVxV1IXKnYxvNTpo=;
 b=gP+X3ILHKRnkE8eiy6RQBjXKBgx4E9WkKD3ky4MV1DT1kzJEqZWHTL37BHOSaFUQPyyJTTkh71cxiWDX55N6b3zVqyDaaCKPJsna/LHYMqRp75Obe421j2fFhcxUjdI/wK6OrI+bFGMl27nuGo+NtMTBw3hEbufSv5Vvj4SVWXk=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN6PR1101MB2338.namprd11.prod.outlook.com (2603:10b6:404:9c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.20; Tue, 28 Sep
 2021 07:30:41 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%8]) with mapi id 15.20.4544.021; Tue, 28 Sep 2021
 07:30:41 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
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
Subject: RE: [RFC 06/20] iommu: Add iommu_device_init[exit]_user_dma
 interfaces
Thread-Topic: [RFC 06/20] iommu: Add iommu_device_init[exit]_user_dma
 interfaces
Thread-Index: AQHXrSF9WDj+Z+DU+UqMJ7tQK2EdmauuvK2AgACKnbCAALw6gIAHYVYAgACkNwCAAQ1OQA==
Date:   Tue, 28 Sep 2021 07:30:41 +0000
Message-ID: <BN9PR11MB54337B7F65B98C2335B806938CA89@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-7-yi.l.liu@intel.com>
 <20210921170943.GS327412@nvidia.com>
 <BN9PR11MB5433DA330D4583387B59AA7F8CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210922123931.GI327412@nvidia.com>
 <BN9PR11MB5433CE19425E85E7F52093278CA79@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210927150928.GA1517957@nvidia.com>
In-Reply-To: <20210927150928.GA1517957@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b14776c0-7a1d-4603-bdfe-08d98251e03d
x-ms-traffictypediagnostic: BN6PR1101MB2338:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR1101MB2338F49714A0D470C68173BF8CA89@BN6PR1101MB2338.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: e2yMg4yran5mOb4WxY71bSKYHkg3vqpx/7myCXKU0vWoO8HqoGlhEVvAZDbqx2Pgu5syX1PwCN4FBTEjMS1Sh+pCnt7zYoqvr8X8GmRzW/tAlBn+/L7DgP4SVTrq38qqY8KZ6iguWCEnyzS4W6MV8MRB4VZPGLn4PuyjDrv0dCkAXuEaJ7/h1zJAh6lBYNbl1YlChQo43uySiQvxHTrVhUBPB+SvaZxJs9tzdQlzQxtvk2n32Wf8fOCxe1zLOaz8kAmmFLDoOBHahw5wXEbBqJBWA2jbAiW50T7zLBWqGaSZUR+D1OIFCgPMxTrHRWbEeFcGh51Zl7knPQU448fzZkNhGnUCjo3FTBrOUkhrvPojW4cbw+T/CM1qd+TaBhVWcHZ4p2W3kj41nHRXpU4706Tg5bc5oOg5guLtbA3Zp5HaULhnuXIOuab+whfeD1sYYBWJ2MVUh04h2EC655p3HPhsSFZ04KnWpusQBvJGREVmCX4u0UW/TL1PTFq3qNdrv/BI4B/q8USQPOeaZO57+CdkYQmkgxwVvMVzOSJb4y2hH1oXz+P+4o5atSEEh69dQl0YiBLxBrjAfFldonrbqUv8zcv2WPNSJklxXnoh75qZIOf+s/xwZAqkqbHfw5qT7tkQE8X8dkMB6qHgPa7A1M5BZepWv5QI5Nw30kshQWCeKUAodd20cJy18k4jwVnmd8aqALJyoQGM6T+v5KqTWA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(122000001)(26005)(55016002)(6506007)(2906002)(186003)(76116006)(71200400001)(66946007)(7416002)(316002)(66446008)(64756008)(66556008)(66476007)(54906003)(5660300002)(38100700002)(508600001)(9686003)(8676002)(52536014)(86362001)(83380400001)(33656002)(6916009)(7696005)(38070700005)(4326008)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RVByVWFoV1JrUUgrZFh3YzhDMS9NaVVmVDc4ekZrQ1Y3Y3dLY3I0Rjh0RHpJ?=
 =?utf-8?B?Vm0zL3lrOFoyQW1MeUt1SUZWc0UrQ2xFRHRpeWtMOW1aVVJCTEwyOFdwV2Nl?=
 =?utf-8?B?NnQ2QWhHekU2S2l3RzMybGtEeHlCTFpNcHBhNGx2TGJ6ZWRUYUtVd1B4VUEy?=
 =?utf-8?B?WCtjeVd5TDdJKzM0RW9naUVBdTJVbkp3eDNiTG5OUFZKZU5qeHJ6NTE3ZXND?=
 =?utf-8?B?eUZJNzVTWnJudGFIeG1QUE9SQUZkQzZsR01JNTErbHpwUnNyeEdkOEZjQVZ5?=
 =?utf-8?B?TnIwM2VFc3ZFbEVaOUc2RU9QWGdzQlBWamw3azg2TG5NMzVDMVFsc2xDZjdq?=
 =?utf-8?B?WkZkcm5YZjFGekF5RDYrcG1FWHVyQ1NPQ3E5NVJFazNiUy96bzQ3OTNiQ1dT?=
 =?utf-8?B?ZldBTkdObDFMZ21hWXpjWmhGYWNZZng5ZmlEdWFuVUR4d0htekhhcExhbWk1?=
 =?utf-8?B?bk5mTTlqNmF5cnhYSFkwbkoycVpEUnVibXd5YmxhdWFieGxxUXE2UUtEeWk4?=
 =?utf-8?B?V2pJRCtXZFFkQjcrMjV5b09WWnFUZzJTY1hUbDQ0RnRFMkJaWTdBQmxPRjB0?=
 =?utf-8?B?SWZQcGtXTzhkZ2JuUHBnMXpreUFna0ZRZk5tK3hKenkzNzFXb1c0Vyt3US9O?=
 =?utf-8?B?a1lveks5dEV1R2E5OGJYeXNlRFU0SURTeU55bFE0V2FIa3EvdUN5YWwySHZL?=
 =?utf-8?B?SzRFSU1jN0ROYWtCTjdTVkNFNDVIT3ZZVE9EZm10NXZpSUNQc0tHSDBUeThU?=
 =?utf-8?B?Qm1ibStCTiszbDYzMkVTZnZ6SUhYYktHL2FhWEpNOEgyc3ROMitZZ1J6UUFz?=
 =?utf-8?B?eTl3TWxmNFUzQWt0b2pQdDFjMTJjdzlMdWRlOWF6TmxYYnZEZit4TC9mRXJw?=
 =?utf-8?B?cU5tdEQ1eVJCVFRUMlhGS2Y0YXpHcndLVGpPSHdHeE9RQ0tpdHFtdkt1Uk1J?=
 =?utf-8?B?K3pWRTBCcXFBZTlnQTZDMWNkbk54VUZxeFB1YWpxUkxLTVNBMGRqMHQ1TnZm?=
 =?utf-8?B?QmVTZ295REFGZURCd1p5OUVPakpMMjh4dHlFSW5ubHJLZ3hWZ1B6K1g3VnVP?=
 =?utf-8?B?bHlybktLNWNDNEJBekh6VzVsOUZwOVFvVCtyUGFpRzBhV1BDNnVMS0h3bnl6?=
 =?utf-8?B?WmcvWXAwbGNHdVFDNHA0VGVHeGlIWXZOcFNqVUlHcnNFZHZaVnoyUm9TMHlJ?=
 =?utf-8?B?K2FWVXV3b1Y2NmxEN3pGNDBIelBYTU1JY3JGaHJibjZTS3p2Mzl4REhEVnhi?=
 =?utf-8?B?bXprV0Z3dmw0QWlPNGFLSm1jcHM1bWtzN3l3QjRZVi9jdk1qaHBxdURtNmlN?=
 =?utf-8?B?QzlsS1NHR01WbmhKdWJrdGVVYzdUeDYwN3dvL0dhaVNuM2Q5Uzc4Ulg1aHNp?=
 =?utf-8?B?SW1VVmpPRkEvRFA3RzZHRHkvcXNBaW01RXhqU3RuM2dTeko0NUh6M25HczVN?=
 =?utf-8?B?ZUFzRjg0aWM4aDBZeVhBaHlMSnJjRHRKNE5mOElrZHlGdFNoOHA3a09neHla?=
 =?utf-8?B?NWsxMzV4QTNrR1RFdkdBbTVkcEJhL1FYZDB0dm5lbHQwRW93V0l6ZURRdmVS?=
 =?utf-8?B?Tk1XSElXL2tWT2ZVUjhrSXpvREVmVHVJbnNGZWVUQ0tpYzFzSE9MS0FrK0Rz?=
 =?utf-8?B?c2lsbGJmYTZQR1dZa09YaVAwN2lwR2V6OURHWDRKSFIvSDZQb1V5Nm9USFVZ?=
 =?utf-8?B?OXU0bkUxdGVlYi9JZXdzN0ZiK1laOFkzdlhCdlFmY0l5bzBvS29lRE1NYjd5?=
 =?utf-8?Q?IvL/iy4MjGHTRd/rXCfTd4kRuWmimlYuE1BcYrG?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b14776c0-7a1d-4603-bdfe-08d98251e03d
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2021 07:30:41.3958
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zFjVqMuKjQ12hDQ4tv8Uj10RGlOL2rmi57lCWqoWg9r3JC1i2nhIxrSz+q2ca7Xh+cLbIuPREXQQrgHOpjSEcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2338
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPg0KPiBTZW50OiBNb25kYXks
IFNlcHRlbWJlciAyNywgMjAyMSAxMTowOSBQTQ0KPiANCj4gT24gTW9uLCBTZXAgMjcsIDIwMjEg
YXQgMDk6NDI6NThBTSArMDAwMCwgVGlhbiwgS2V2aW4gd3JvdGU6DQo+IA0KPiA+ICtzdGF0aWMg
aW50IGlvbW11X2Rldl92aWFibGUoc3RydWN0IGRldmljZSAqZGV2LCB2b2lkICpkYXRhKQ0KPiA+
ICt7DQo+ID4gKwllbnVtIGRtYV9oaW50IGhpbnQgPSAqZGF0YTsNCj4gPiArCXN0cnVjdCBkZXZp
Y2VfZHJpdmVyICpkcnYgPSBSRUFEX09OQ0UoZGV2LT5kcml2ZXIpOw0KPiA+ICsNCj4gPiArCS8q
IG5vIGNvbmZsaWN0IGlmIHRoZSBuZXcgZGV2aWNlIGRvZXNuJ3QgZG8gRE1BICovDQo+ID4gKwlp
ZiAoaGludCA9PSBETUFfRk9SX05PTkUpDQo+ID4gKwkJcmV0dXJuIDA7DQo+ID4gKw0KPiA+ICsJ
Lyogbm8gY29uZmxpY3QgaWYgdGhpcyBkZXZpY2UgaXMgZHJpdmVyLWxlc3MsIG9yIGRvZXNuJ3Qg
ZG8gRE1BICovDQo+ID4gKwlpZiAoIWRydiB8fCAoZHJ2LT5kbWFfaGludCA9PSBETUFfRk9SX05P
TkUpKQ0KPiA+ICsJCXJldHVybiAwOw0KPiANCj4gV2hpbGUgaXQgaXMga2luZCBvZiBjbGV2ZXIg
dG8gZmV0Y2ggdGhpcyBpbiB0aGUgZHJ2IGxpa2UgdGhpcywgdGhlDQo+IGxvY2tpbmcganVzdCBk
b2Vzbid0IHdvcmsgcmlnaHQuDQo+IA0KPiBUaGUgZ3JvdXAgaXRzZWxmIG5lZWRzIHRvIGhhdmUg
YW4gYXRvbWljIHRoYXQgZW5jb2RlcyB3aGF0IHN0YXRlIGl0IGlzDQo+IGluLiBZb3UgY2FuIHJl
YWQgdGhlIGluaXRpYWwgc3RhdGUgZnJvbSB0aGUgZHJ2LCB1bmRlciB0aGUNCj4gZGV2aWNlX2xv
Y2ssIGFuZCB1cGRhdGUgdGhlIGF0b21pYyBzdGF0ZQ0KDQp3aWxsIGRvLiANCg0KPiANCj4gQWxz
bywgZG9uJ3QgY2FsbCBpdCAiaGludCIsIHRoZXJlIGlzIG5vdGhpbmcgaGludHkgYWJvdXQgdGhp
cywgaXQgaGFzDQo+IGRlZmluaXRpdmUgZnVuY3Rpb25hbCBpbXBhY3RzLg0KDQpwb3NzaWJseSBk
bWFfbW9kZSAodG9vIGJyb2FkPykgb3IgZG1hX3VzYWdlDQoNCj4gDQo+IEdyZWcgd2lsbCB3YW50
IHRvIHNlZSBhIGRlZmluaWF0ZSBiZW5lZml0IGZyb20gdGhpcyBleHRyYSBnbG9iYWwgY29kZSwN
Cj4gc28gYmUgc3VyZSB0byBleHBsYWluIGFib3V0IHdoeSB0aGUgQlVHX09OIGlzIGJhZCwgYW5k
IGhvdyBkcml2ZXIgY29yZQ0KPiBpbnZvbHZlbWVudCBpcyBuZWVkZWQgdG8gZml4IGl0IHByb3Bl
cmx5Lg0KPiANCg0KU3VyZS4gYW5kIEkgcGxhbiB0byBhdCBsZWFzdCBoYXZlIHRoZSBwYXRjaGVz
IGFsaWduZWQgaW4gdGhpcyBsb29wIGZpcnN0LA0KYmVmb3JlIHJvbGxpbmcgdXAgdG8gR3JlZy4g
QmV0dGVyIHdlIGFsbCBjb25maXJtIGl0J3MgdGhlIHJpZ2h0IGFwcHJvYWNoIA0Kd2l0aCBhbGwg
Y29ybmVyIGNhc2VzIGNvdmVyZWQgYW5kIHRoZW4gaW52b2x2ZSBHcmVnIHRvIGhlbHAganVkZ2UN
CmEgY2xlYW4gZHJpdmVyIGNvcmUgY2hhbmdlLiDwn5iKDQoNClRoYW5rcw0KS2V2aW4NCg==
