Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E1EE4647CA
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 08:18:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347179AbhLAHVp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 02:21:45 -0500
Received: from mga11.intel.com ([192.55.52.93]:5960 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232535AbhLAHVo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Dec 2021 02:21:44 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10184"; a="233904849"
X-IronPort-AV: E=Sophos;i="5.87,278,1631602800"; 
   d="scan'208";a="233904849"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2021 23:18:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,278,1631602800"; 
   d="scan'208";a="477441196"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by orsmga002.jf.intel.com with ESMTP; 30 Nov 2021 23:18:23 -0800
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 30 Nov 2021 23:18:22 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Tue, 30 Nov 2021 23:18:22 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Tue, 30 Nov 2021 23:18:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XGxq+IJzjFwCwE8vF76ZP+nVB65UNZwRW2rMt50lwDP6waeUBBjtTVHTWB11r/cA6eFH3Oelll11e68Eg+hBX8jSTcrvR+CzXqZVJvsVv0WL+Rx6Udgllh2n0rxzvGpfI/ucJ16PqF1uvl+ATiCofQ398m+bbq9GeoKZOLIu4vocdvJL+fsYYZwQRJyMQnr6mXu/+eZH9mQxI9wplYwnA2ZTmTso8kMN9PUSn52aNqf45M13BAV9j52XFqA+9DJ2altzq+9Otuj70pKarjgzJHtJw+0DRxiJtGBPw/rSJwcMaS4YuVcSON5J/jS1Pb8ZSPm/YUOb9xwGJedJCXZlQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HYZrz4pLAQJdLV50BACzL/BrR8aLYWRGvSC5D5CW2h4=;
 b=J4HlD3XN252qXU56W4Hr4Cr2/QB8XHWaLye6hYSbLq9/5rB/FfnNs4ojABdbJ/VncT74Y17s8SgMdtCkKWOG9j2gSXbJl5I3YZyVgtH0i+LZs3TsfOQOupKHrjI6IpOLT0/29SgGjuYgxs94ZoIyh9ESr+QuPq+JUUvfYa9wnidYv9is1VFewWylZd32stNUn56ww3afE8Z7KoneDNidTuH8BYDrcMLtSfPt0u/RDSSBB9v6NxABJ5B2n3HXNNE8je6Ps/iYaHWyJu5IV+PMdfnD/YxSgRjVuPslqzqSX/hbSbMYcNEtszqYhg4acBI5YzXqUYbUl+YFKNd0vOzNWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HYZrz4pLAQJdLV50BACzL/BrR8aLYWRGvSC5D5CW2h4=;
 b=tT9hTjXUphjRmCNcf0SS4M14l2uLMlF1vXVTMl3Hdvl9NY/fmMNrU6fZCQb2FWqlEM124oIA72lt3oIcZOCUgdz0IF90hakI7T5Gx+XRuuOn7mN7aO605jXbYvWQKoTxO6y3Qv6rK+4RRQqhuGDOT0RqdHKF5jvgz3h7AKSnMgU=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN6PR11MB3892.namprd11.prod.outlook.com (2603:10b6:405:80::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Wed, 1 Dec
 2021 07:18:21 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::3d42:a047:dc28:e92b]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::3d42:a047:dc28:e92b%9]) with mapi id 15.20.4755.014; Wed, 1 Dec 2021
 07:18:21 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: RE: Q. about KVM and CPU hotplug
Thread-Topic: Q. about KVM and CPU hotplug
Thread-Index: Adflvg/SIgoQKcU9QlaunmfcAiKUJgADptsAAAmteAAABO5tAAAeeXew
Date:   Wed, 1 Dec 2021 07:18:21 +0000
Message-ID: <BN9PR11MB54338553E818F452D87D27D88C689@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <BL1PR11MB54295ADE4D7A81523EA50B2D8C679@BL1PR11MB5429.namprd11.prod.outlook.com>
 <3d3296f0-9245-40f9-1b5a-efffdb082de9@redhat.com> <8735ndd9hd.ffs@tglx>
 <527c1261-8f21-bcbe-e28e-652a1e37ab14@redhat.com>
In-Reply-To: <527c1261-8f21-bcbe-e28e-652a1e37ab14@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f9c8cd91-4aed-41bd-c469-08d9b49ac1a4
x-ms-traffictypediagnostic: BN6PR11MB3892:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BN6PR11MB3892408219B05AB93B0F4A4B8C689@BN6PR11MB3892.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:224;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pKbHiPufEqqz0F3Rw2I+AiwUko/i7g44yu6zid9qr2sI7RVDJfIUNDkAPozr5aXk1SKdMPgBd3yisgleYVg8PT7IYiH1OFVq5pYOxsYU9lmDY6+hSgneMsa9hYoSNryXB1Oa0ktrk3xhLQP+06WMVg1h4hJusNATkY1EdXee7S2Dfl4XdSqtqDWFsta3+RKfMdt8A5dIz18xyFx840lKwUe26ltZCEeJu90cr5nrUoeebjPQR/zNtmisdAU7szUZKQ/tXcHSm3kQ0QdpvqI4vaY52zjHyUOTZ/l3VAjNl+OuCJxbCFrNy6swYDJvVHMVsiZcP3hpzqGXwk+QLEBo0OyQ/kd5LoD9RXUeklGSsel6G9nH2cXVgnLNpb/r0p8Wj7SCSsq7ocEGelKK9PwkmaMWPfARkfXb16saE8/ukV2Tuz4LpvwQ0oGfeqoYEbG8Fq0LfCa+/9HZu+EuXyZIUM6/5LuCJnOH22rq+FxjCJglbJmVAyYQKOzXFuVyYK/mcUt4bbJo1xPHUv1RewDuGuBk8b7GohMR2sHfmp3jKRrgrnetohYyCzoA5bSvZMTrZJjQ1tXN4o4hc8WO3uFRGlOTH8oi+rJVK/yre2pAHPRUxPFnEtKfkwLET7OQ9YpSym/r3wUzOe94msTk+YVoYBIbjN5Xm13XK+zD2YTEhJTZTS5yXp/s7/qTgGQCeGTly94/Kdu4TTJvN5PeV078Vw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(26005)(6506007)(53546011)(186003)(8676002)(316002)(2906002)(38100700002)(122000001)(38070700005)(52536014)(5660300002)(82960400001)(508600001)(4326008)(71200400001)(8936002)(33656002)(66946007)(86362001)(76116006)(55016003)(7696005)(110136005)(9686003)(64756008)(66446008)(66556008)(83380400001)(66476007)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SFErN3NBMnNueDVYN1ZmaWNjUnNwRzFKMjNPSyt4Y3VKQ2I0dW1DTzRuRzV4?=
 =?utf-8?B?RW5SVHROMEU3Tmc4V3ptZk9FZUpQKzdDcUtMK0J0T0pHalRucDFsWUo5eExF?=
 =?utf-8?B?eUlHeXlKaTY2UnVjWjltVzVqR21UR1pGcEhPL1JXRVFmeit2VnJIa05ZOC9P?=
 =?utf-8?B?MElKVWZmRENYZzF1QTAxZytDWlBWcHJhNjJNR0hValBMN1NwbWtISEdVQ1RK?=
 =?utf-8?B?Z0Y5RHBiOWZTQ3VETWNHY0hrdkVEMFhmZVlHOFVqeHprcU5QdnFDNW55RU96?=
 =?utf-8?B?bXc5RWdtUzVFUXMwRWlRZW1rajNiZVFPRVJ0VWtidFZTY2NISkhlTUg1cGVP?=
 =?utf-8?B?d0J0akNqWGdHT0gzWjZaVjRCKytHaFJuSTlremNhaVo5aVFreG8yVElpajVj?=
 =?utf-8?B?eXJ5aUhnQWhkdmp0aXR4aUZ3RFhiTGNaTm5xTG1ReTNWYk9Pa29ETk1DZUlu?=
 =?utf-8?B?S3ZvTDgrRGRqR2kzMXlVWnQvMkZiRXZ1TDZZNDVCMFBkcEtSM0k4SngxcHpC?=
 =?utf-8?B?ZDljdmhUZ0F4bmlGNkRqM1QyeEhVNldJUWhHMlR3T0IzM3VjR3ArclB5cE5l?=
 =?utf-8?B?MXV2bGsyck03bUQ1RHpxdlhqMTRFZXNOVmUxcWVQSTk0Y0tlWmxGVEZFalVw?=
 =?utf-8?B?aWZ3cEZEWmY4bnN5R0xxcUg4QWtPeWtoSWdRM0RzVlVzeU9rc3ZPTXJ4N1ZP?=
 =?utf-8?B?aktkL3hKdTg3SnZpdUVXTGp0N045b2hkV1pSQlVMUmVDZ21Yd1hJZ3RKUXdp?=
 =?utf-8?B?VHJZOWRMTlQwUURFVU15NzBGMTJORFBYdklqeHI4Zzg5NUdTdk9VZ3o5cVgw?=
 =?utf-8?B?NGtYL0V0Z00yU2l2N2N2Z1RGc1EyMGdPZFJmckhUY2U4ZXRnSG1IQUhUNm1E?=
 =?utf-8?B?V29qVHYyWC9zRHhzSVNMa0REQlhYMFRLZFRNTGh2dWRncW9SbzVXNEtKdDgw?=
 =?utf-8?B?S2s4NWJEVFZIUGVleUMvVHVnalBsdTRRWTM5ekx6WmRTVDQyM3NiQVJrYU0v?=
 =?utf-8?B?aHFLN1dISkp5dytzeCtOQTRqZDIxcXlaYkVEY3dQdUtuM0tEQUppNDNSZlJ5?=
 =?utf-8?B?dXBabVFDaTI0dllsWXRrVXFudXRKWk9oUFEyVmxtMXcrZHF4eTRlRkIrc1F1?=
 =?utf-8?B?TU1nTkFtRHR5U2EyMDJkazhXeGd4OGtDTGR3dEdEWXNYaDlORFZHbnk5U3p4?=
 =?utf-8?B?TnpSV0pQb2NEN1YraXpINVpKMUtNVXM2eTV0YWZNUVJVbTBHUk1XUzAwSExM?=
 =?utf-8?B?T2xCdWdrSFg2aU02Z0VGQVJwcXhRdG9lbVZIemJtY0Q1ay9yd0dqWlIxanVL?=
 =?utf-8?B?dmRmblpYQ0R1ZkhpZm52bSs2bXJUUUlWd3BrbktYNWdwTTZuQU9GcXpVMUpw?=
 =?utf-8?B?Z3QvdGEwekFnZE51bzhVcmZ4TjBWR2JTN3J6bEpGQzdhbk44eEdvS3hQWkh4?=
 =?utf-8?B?U1REUU5SRWFvak01M0txQTRSemorMGNYWGxxZVVzK0RvTjByc2hQeHVNbG1k?=
 =?utf-8?B?UTN3TTNmQUN1Q0o0T2EreTg3djkzeWl0TGFUaEtkbjBNNXczRjZBSXhVcUlZ?=
 =?utf-8?B?VFVGTEVXM1JxcnVCaHQ5U0I2ZDhtUnlXbTJzNW5jUS9Yc01uTC9EU3dBUVo3?=
 =?utf-8?B?akFoSFlqZzlnMjV4ZUtNakNPZnRDVFpXQjAyVHppQnpESEhvbzFxaXkwV0s5?=
 =?utf-8?B?STVEK1l6MnAvQWpEeXhKVVJWRC9RODB2MU9VOEVGR3lKVS8xYzZ5blpHZGxX?=
 =?utf-8?B?YTdHT1ZSeVpMdzVlR3lKZ2cveFRkd1hmb0VGM2FoS2JLTGJtTWNrVFJ0MkJF?=
 =?utf-8?B?VFNGS0xZNG90MnBtWXRHY1ViNm9qd2h2ODVGNElIOGJQakRUM2Z2SEQzMjJi?=
 =?utf-8?B?dHV6Vkl4bS9oQlpTYXF1WjJkaUhTcGFTbU55eVZ6bzZ5c3pSR25hWmdrK3Vq?=
 =?utf-8?B?UERnQktiTDZPNStRQ3hncjFSSEoya1ZQdC9udjMwUnBPTWdscHRlYlVpaVkr?=
 =?utf-8?B?V1pHdXlYcTR1akZPeUJrOEMxLzhwK0wyQjBXZVZ6UkFuOEZxS0FsZ1VGWUQ4?=
 =?utf-8?B?V29tazEwMEQ0cUZ6RjBFd0tEK2lXb0xQa0Y3aERGMFF0aXlJKzdlZ2p0aUZM?=
 =?utf-8?B?Z2NsUFZaU1BwU0Z4MldQa2pmemxDL2U1Q29RTkRoMlJ0YzJaRTBKZHhsbXp4?=
 =?utf-8?Q?4Goh8IiyA6OBHgRUiA1Av60=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9c8cd91-4aed-41bd-c469-08d9b49ac1a4
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Dec 2021 07:18:21.5264
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Cx9y/cwqYX1XqfcbbIOadW14Q8iBc1sZRA+6dWzpbBF8y1Ly2srnx4a0m2y0HmwLoPOgKjnwQLfftUKT4Y1zVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB3892
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBQYW9sbyBCb256aW5pIDxwYW9sby5ib256aW5pQGdtYWlsLmNvbT4NCj4gU2VudDog
V2VkbmVzZGF5LCBEZWNlbWJlciAxLCAyMDIxIDEyOjI3IEFNDQo+IA0KPiBPbiAxMS8zMC8yMSAx
NTowNSwgVGhvbWFzIEdsZWl4bmVyIHdyb3RlOg0KPiA+IFdoeSBpcyB0aGlzIGhvdHBsdWcgY2Fs
bGJhY2sgaW4gdGhlIENQVSBzdGFydGluZyBzZWN0aW9uIHRvIGJlZ2luIHdpdGg/DQo+IA0KPiBK
dXN0IGJlY2F1c2UgdGhlIG9sZCBub3RpZmllciBpbXBsZW1lbnRhdGlvbiB1c2VkIENQVV9TVEFS
VElORyAtIGluIGZhY3QNCj4gdGhlIGNvbW1pdCBtZXNzYWdlcyBzYXkgdGhhdCBDUFVfU1RBUlRJ
Tkcgd2FzIGFkZGVkIHBhcnRseSAqZm9yKiBLVk0NCj4gKGNvbW1pdCBlNTQ1YTYxNDBiNjksICJr
ZXJuZWwvY3B1LmM6IGNyZWF0ZSBhIENQVV9TVEFSVElORyBjcHVfY2hhaW4NCj4gbm90aWZpZXIi
LCAyMDA4LTA5LTA4KS4NCj4gDQo+ID4gSWYgeW91IHN0aWNrIGl0IGludG8gdGhlIG9ubGluZSBz
ZWN0aW9uIHdoaWNoIHJ1bnMgb24gdGhlIGhvdHBsdWdnZWQgQ1BVDQo+ID4gaW4gdGhyZWFkIGNv
bnRleHQ6DQo+ID4NCj4gPiAJQ1BVSFBfQVBfT05MSU5FX0lETEUsDQo+ID4NCj4gPiAtLT4gICAJ
Q1BVSFBfQVBfS1ZNX1NUQVJUSU5HLA0KPiA+DQo+ID4gCUNQVUhQX0FQX1NDSEVEX1dBSVRfRU1Q
VFksDQo+ID4NCj4gPiB0aGVuIGl0IGlzIGFsbG93ZWQgdG8gZmFpbCBhbmQgaXQgc3RpbGwgd29y
a3MgaW4gdGhlIHJpZ2h0IHdheS4NCj4gDQo+IFllcywgbW92aW5nIGl0IHRvIHRoZSBvbmxpbmUg
c2VjdGlvbiBzaG91bGQgYmUgZmluZTsgaXQgd291bGRuJ3Qgc29sdmUNCj4gdGhlIFREWCBwcm9i
bGVtIGhvd2V2ZXIuICBGYWlsdXJlIHdvdWxkIHJvbGxiYWNrIHRoZSBob3RwbHVnIGFuZCBmb3Ji
aWQNCj4gaG90cGx1ZyBhbHRvZ2V0aGVyIHdoZW4gVERYIGlzIGxvYWRlZCwgd2hpY2ggaXMgbm90
IGFjY2VwdGFibGUuDQo+IA0KDQpGYWlsIGhvdHBsdWcganVzdCBiZWNhdXNlIFREWCBpcyBsb2Fk
ZWQgaXMgbm90IGFjY2VwdGFibGUuDQoNCkJ1dCBmYWlsIGhvdHBsdWcgd2hlbiBhIHRydXN0ZWQg
ZG9tYWluIHVzaW5nIFREWCBpcyBhY3RpdmUgaW1vIG1ha2VzIA0Kc2Vuc2UuIEl0J3Mgc2ltaWxh
ciBwaGlsb3NvcGh5IHRvIFZNWCB3aGljaCwgd2l0aCBhYm92ZSBjaGFuZ2UsIHdpbGwgDQpmYWls
IGhvdHBsdWcgd2hlbiBrdm1fdXNhZ2VfY291bnQgaXMgbm9uLXplcm8gKGltcGx5aW5nIGEgVk0g
aXMgDQphY3RpdmUpIGJ1dCBWTVggaW5pdGlhbGl6YXRpb24gZmFpbHMgb24gdGhpcyBDUFUuIFdl
IGNhbiBhZGQgc2ltaWxhcg0KdGR4X3VzYWdlX2NvdW50IHRvIG1hcmsgYWN0aXZlIFREWCB1c2Vy
cyBhbmQgZm9yYmlkIGhvdHBsdWcNCndoZW4gdGhpcyB2YXJpYWJsZSBpcyBub24temVyby4NCg0K
SW4gZ2VuZXJhbCBJIHRoaW5rIGl0J3MgYW4gYWNjZXB0YWJsZSBwb2xpY3kgdG8gZmFpbCBhbiBv
cGVyYXRpb24gaWYgaXQgDQpicmVha3MgYWN0aXZlIGV4aXN0aW5nIHVzYWdlcy4uLiDwn5iKDQoN
ClRoYW5rcw0KS2V2aW4NCg==
