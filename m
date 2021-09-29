Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CDA341BD94
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 05:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244012AbhI2Dl7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 23:41:59 -0400
Received: from mga11.intel.com ([192.55.52.93]:59998 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239755AbhI2Dl6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Sep 2021 23:41:58 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10121"; a="221649930"
X-IronPort-AV: E=Sophos;i="5.85,331,1624345200"; 
   d="scan'208";a="221649930"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2021 20:40:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,331,1624345200"; 
   d="scan'208";a="456870844"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga002.jf.intel.com with ESMTP; 28 Sep 2021 20:40:16 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 28 Sep 2021 20:40:16 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 28 Sep 2021 20:40:16 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Tue, 28 Sep 2021 20:40:16 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Tue, 28 Sep 2021 20:40:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VH3ctVDTGy9xBI5LcQg1bijht45DADyDE8N6rxrNEHLn3PaZJtKDEvYME2anPEDNDBbtLnCbXoaDPCf6KbV8lOzgjkX5ZDsSfgyqxx5xmCHFus8AyummqvsVXvfRDOc+WZX1whGIl6tHA65QFVX0TEA16X6ZdpUsdK2Jdy/tqoIQU57jJJtmyh0DyA1aU4GTWQRQLzSMv41cPyBZxZvPankum5W18uDBQuZ74IZTjpCydgrPdy/HcfOTh0lFiuzbBs8IPywjE/cFLnEv04rcqmBDC8ukhivuNupUIlQd6xJ5gSu6BoL/ojSIdSJBRI8XpznlO+P1XFUH9kUNid02ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=/PIgTQBKSwUdBL0Bm6gZFEBtO61PxTe7C9Y3AFELwmQ=;
 b=cAOWlbc741WxMsmQjmju8UD/dukKoaRUjNms7CiyeSCsVExOlN+PBG1z+/wCAYKSrVwyYti3JfVgWtDg3yFjVApoud/vVNMaMh0+M8puK1LHzHJEHZj+NA+zt3OFc50SfJZrZ8IigPIZZtllChGXBNym2ELlfUyu6oeKzrIjyeX4rjEuhTO6jIlq1QMu2bT/SDv8ApZPv5jpf49BQ7XQkpFdXclT5WnWflGBFH9dPacmfUbuJXnrQNfJUcYGL0iNgdaQtfJua0/p5O6aRptw/3YuUCF9Wmo2itOHGuJ5dcaZ+9iZ4/xH+gUdCf1LHV0bqWelSz+UQab5bvNVMlZdRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/PIgTQBKSwUdBL0Bm6gZFEBtO61PxTe7C9Y3AFELwmQ=;
 b=PU/z+IYYo2A9NSvDiPyr9ia+9vggyXd/1ZHc8hpf8bj6XWW09ijCIcLSboai7Dz+yblxPdGTwjU29NbPxgUj5O95NBgWr1T3oOKLc4X73/EUbR5XO+Apy9mQ24Mp9juKyax7uuE6sgrm7lFZuz9Q44H31N4Dtl21/SRy8kOcefQ=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN0PR11MB5759.namprd11.prod.outlook.com (2603:10b6:408:168::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Wed, 29 Sep
 2021 03:40:12 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%8]) with mapi id 15.20.4544.021; Wed, 29 Sep 2021
 03:40:11 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     David Gibson <david@gibson.dropbear.id.au>,
        "Liu, Yi L" <yi.l.liu@intel.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>, "hch@lst.de" <hch@lst.de>,
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
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>
Subject: RE: [RFC 03/20] vfio: Add vfio_[un]register_device()
Thread-Topic: [RFC 03/20] vfio: Add vfio_[un]register_device()
Thread-Index: AQHXrSFwNP3/pIcrZ0iM9X/cSoy0lKu6XWSAgAAOglA=
Date:   Wed, 29 Sep 2021 03:40:11 +0000
Message-ID: <BN9PR11MB5433C0320604707451C11C538CA99@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-4-yi.l.liu@intel.com> <YVPS43bNjvzdxdiM@yekko>
In-Reply-To: <YVPS43bNjvzdxdiM@yekko>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gibson.dropbear.id.au; dkim=none (message not signed)
 header.d=none;gibson.dropbear.id.au; dmarc=none action=none
 header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cf7f25f2-6eab-4ec1-d724-08d982fad792
x-ms-traffictypediagnostic: BN0PR11MB5759:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN0PR11MB575970FCD04D572B62805C888CA99@BN0PR11MB5759.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: e89VHTej4wUWYQy/l/E0ACXpN/QGlo1HbR4N7c6gjBA4oDI/hvx7b9cLxFRXfQt5mcIZKigTQlgdSzMfGeKBdRHP3pNttfN7wTwLXdfu7faM4wBKJX2o50VRocvjF3vlstEOgXFradaTKoAHEAdthQMRfmpAKdibBuXTlffS1FeuRthHq3KRHE0qhRnYpjpfLkFzBIEvNWQc7Aq4IgJBCy5t7dOmgxc7rlaJxsGPY1HVNXbOBjZgEE2kbCHU0jtRLaB+aRaACh5NUdz3bf/BD+e/ftrnzxB65dZbVYTk6hsczVEBbajOvbcFolwRWWMixpSHKdbYnr0kl0zRfDBzqcEuVJZfbkbom5Wo7dHhVAR5yZZ2+IIcJob9WrHffE2MwDMtSHHafctFQpq/hm/VFaVPWiFAguHmsiQf4TMVx3SCjU+cj2d5M4fRqTyGKBk6LkYwb8jQ2DQUoUBnKHa8coNqBNYQuhNlgKpTCdhn6CjnWCr/rJvOF6Ivw4Fyk+cgOJST7qF/KdwWxgSEs6q7edRw5BYEPCtBV0HN4pbmam6twZD0cVMSV167UhLOCvRfDLVudZEue52oDWgGLXnXdMLpPhe4ivVxfAr2nkFRi5KqmzqsD4JM+H29qwQNjlQppJlLmnHmJoHf5I5hvBjIfdsnk1IKs2NSUNwsH2XBnVc1LnVAoco2Ky1Su27vEeU/UfHKmjJcMrk76K/5IpCEeg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(316002)(6636002)(54906003)(86362001)(508600001)(52536014)(122000001)(7416002)(7696005)(110136005)(9686003)(66556008)(66476007)(64756008)(38070700005)(55016002)(26005)(8676002)(5660300002)(4326008)(76116006)(186003)(2906002)(33656002)(71200400001)(66946007)(6506007)(83380400001)(66446008)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NzlERGZJNkYvT2NtdEM1NnhRVCtHMDhCYnozYnBBWEQ2R1NEM2FyMG1JS0Vl?=
 =?utf-8?B?NjFMVWNFWjhmT3I5R3JyRjRuMFl3cjZYVm1nZGJKRnRwRU5kNmkxWGJzQVRZ?=
 =?utf-8?B?cDVySm9YM24vNGFBQzVNL2c3eVZ1OVBDclZBNHdHVzVLM2U1S0hiNkNhSU9Y?=
 =?utf-8?B?ZHRDUlgyKzlIRms0R3g4dEpGcnZvVmg4djJhMW5jWHNoNEtXTkRwcXRXUWd4?=
 =?utf-8?B?dUE1eEw1eGVySitMUkNUV3BJeUs4R3ZZa3BWVk1DQUgvRldwbitsUzY1Wm9N?=
 =?utf-8?B?aW1NR1Fwcy96N2doVDUrRlRMamFyR3BJUENNSDRVb3I3d21uM1RnVkV1Slli?=
 =?utf-8?B?RUp0VTNCcFNsdnhtaTAzSS93TEgrckVmUzFTSGV5eFRJL1ZseDNuS085ZmZ0?=
 =?utf-8?B?WnNqZk96eG9pWnoxZy9yU096ZmFYWTdvTUdiUkxZMmJSdTZlSUxZajduVTl0?=
 =?utf-8?B?V3p0US9iNVF4aVBaZjEzeFFqaStNUExqbGc4eUU2Uys5L3dxYVd5bHB5OHdK?=
 =?utf-8?B?Z2grckN1WVcvMEVLNGlkMzBCTGY1STJtZC9uSnYrYnNyaFlaYXlkUGttbmlL?=
 =?utf-8?B?M3c2VEU3VHJuWitCUGg5ZkU4QjlxbU1lR0k4bitLY090UVFzV2V6Q0owbHlk?=
 =?utf-8?B?L0RMVjBDWUkwaCtmSlVxMFZVbFVJQnNPQWszNWl0bmcvMFBtT1dTUFpQY1RS?=
 =?utf-8?B?T05meUhCc1YzVFVQbTUvWmZLbEhBcmJ6a25GQkt0Vy9EclU5NG1BN2hJK1c0?=
 =?utf-8?B?RW1qazB4OGRna0VsOEpnL1hTQU5Rd05STDc2SU9Edml4T0pnVmdjQ2ZnSDNV?=
 =?utf-8?B?bjB5ekkxWVMvckFIZHh1cHpPUXUxRUZ3UWZRTzZuZ242YWs1enNFQUF3WHFN?=
 =?utf-8?B?ZUpnTjczcjBUbzJISlE0b1UzVE13Z0pzVmRoNU9uaDZwWXBoTFBiZzhHdmJX?=
 =?utf-8?B?b0Y0elB6OGd1cjZsUzlRdjBTMkxQd0xXd08xNGVCMjROME0wMWhmR29Eak9N?=
 =?utf-8?B?THg2TUozdXAyZjJiOUhmTTJ3MmVXR3BxaDBEa1lpNmI3KzRMUlRvV0VLQTJj?=
 =?utf-8?B?ZnFGaW5FMTFHWlU0a21HUW5ISzhSZklNSVJxekFnYmQ0cnBkeTdIS1cxdUpJ?=
 =?utf-8?B?OEJxSzYvRGVRRC9MRWMwN0hOY1ZvRzl2L083RXJhMFlONTEvNGNNSFRJMXJw?=
 =?utf-8?B?ZGVuS2l3dTNHR25zeFhUQkw0cDU4RnJzWmNsUi9TYmF3OHBjbU1MeEt5R1R3?=
 =?utf-8?B?bldqNjBURlhFQ0ZFcWRWOU9qVFAyamxSWEFkK2t4ZmZRcWRwTzlNUUEyQTRJ?=
 =?utf-8?B?KzlRNWVGeTcxSzViNjhYTDZPNVRJcnBqZjRQbGFIdWk1WVY1d3JwRTIySDBu?=
 =?utf-8?B?bXpvOVYrNkM3bS9xZ09rNUxBWVVZTkxuLzVYcDFMazE3Z1FUWVdQTHo3VkhD?=
 =?utf-8?B?d1JDU21yakdMa3UwblBHRFlHYk56VjFBNWUyT24zdFBPMEpqSEhFNnpaemFO?=
 =?utf-8?B?WkE2dEgvUzZJZFdWajVzSnA1V01rdVlncGRjZUMyVnFUcjFza0lvdDNLbjFq?=
 =?utf-8?B?aTAraHR0RzlUeHVUSXhRQmNSRUVQTFh5VmJoOWFSaFBWMHpkQW00dHhGQU9y?=
 =?utf-8?B?cU9uY2lYM1AzS1dYWXRnTjhZQWo3NDM3bW9WeFI4dm5rR0xCb3lSOGlrMGVy?=
 =?utf-8?B?VGswMTduZFZpRi9ZR3EydHVGN00zb0djN1Nhc1F0SEVVS242d2tsbGlZREpt?=
 =?utf-8?Q?GOqjzy3WcjA6hWLBPArehLlGEEG8pCVMgH1XCQU?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf7f25f2-6eab-4ec1-d724-08d982fad792
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2021 03:40:11.8401
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2MtmJLs218ub7qUEmtqjy3VKrlgykGL185zJMhbyerFI7Bb4N3qwteoByuALkmobW5q1FPqHWo6TGI1IxFkyoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR11MB5759
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBEYXZpZCBHaWJzb24gPGRhdmlkQGdpYnNvbi5kcm9wYmVhci5pZC5hdT4NCj4gU2Vu
dDogV2VkbmVzZGF5LCBTZXB0ZW1iZXIgMjksIDIwMjEgMTA6NDQgQU0NCj4gDQo+ID4NCj4gPiBP
bmUgb3BlbiBhYm91dCBob3cgdG8gb3JnYW5pemUgdGhlIGRldmljZSBub2RlcyB1bmRlcg0KPiAv
ZGV2L3ZmaW8vZGV2aWNlcy8uDQo+ID4gVGhpcyBSRkMgYWRvcHRzIGEgc2ltcGxlIHBvbGljeSBi
eSBrZWVwaW5nIGEgZmxhdCBsYXlvdXQgd2l0aCBtaXhlZA0KPiBkZXZuYW1lDQo+ID4gZnJvbSBh
bGwga2luZHMgb2YgZGV2aWNlcy4gVGhlIHByZXJlcXVpc2l0ZSBvZiB0aGlzIG1vZGVsIGlzIHRo
YXQgZGV2bmFtZXMNCj4gPiBmcm9tIGRpZmZlcmVudCBidXMgdHlwZXMgYXJlIHVuaXF1ZSBmb3Jt
YXRzOg0KPiA+DQo+ID4gCS9kZXYvdmZpby9kZXZpY2VzLzAwMDA6MDA6MTQuMiAocGNpKQ0KPiA+
IAkvZGV2L3ZmaW8vZGV2aWNlcy9QTlAwMTAzOjAwIChwbGF0Zm9ybSkNCj4gPiAJL2Rldi92Zmlv
L2RldmljZXMvODNiOGY0ZjItNTA5Zi0zODJmLTNjMWUtZTZiZmUwZmExMDAxIChtZGV2KQ0KPiAN
Cj4gT29mLiAgSSByZWFsbHkgZG9uJ3QgdGhpbmsgdGhpcyBpcyBhIGdvb2QgaWRlYS4gIEVuc3Vy
aW5nIHRoYXQgYQ0KPiBmb3JtYXQgaXMgInVuaXF1ZSIgaW4gdGhlIHNlbnNlIHRoYXQgaXQgY2Fu
J3QgY29sbGlkZSB3aXRoIGFueSBvZiB0aGUNCj4gb3RoZXIgZm9ybWF0cywgZm9yICpldmVyeSog
dmFsdWUgb2YgdGhlIHBhcmFtZXRlcnMgb24gYm90aCBzaWRlcyBpcw0KPiBhY3R1YWxseSBwcmV0
dHkgY29tcGxpY2F0ZWQgaW4gZ2VuZXJhbC4NCj4gDQo+IEkgdGhpbmsgcGVyLXR5cGUgc3ViLWRp
cmVjdG9yaWVzIHdvdWxkIGJlIGhlbHBmdWwgaGVyZSwgSmFzb24ncw0KPiBzdWdnZXN0aW9uIG9m
IGp1c3Qgc2VxdWVudGlhbCBudW1iZXJzIHdvdWxkIHdvcmsgYXMgd2VsbC4NCg0Kd2UnbGwgZm9s
bG93IEphc29uJ3Mgc3VnZ2VzdGlvbiBpbiBuZXh0IHZlcnNpb24uDQoNCj4gPiArCS8qDQo+ID4g
KwkgKiBSZWZjb3VudGluZyBjYW4ndCBzdGFydCB1bnRpbCB0aGUgZHJpdmVyIGNhbGwgcmVnaXN0
ZXIuIERvbuKAmXQNCj4gPiArCSAqIHN0YXJ0IHR3aWNlIHdoZW4gdGhlIGRldmljZSBpcyBleHBv
c2VkIGluIGJvdGggZ3JvdXAgYW5kDQo+IG5vbmdyb3VwDQo+ID4gKwkgKiBpbnRlcmZhY2VzLg0K
PiA+ICsJICovDQo+ID4gKwlpZiAoIXJlZmNvdW50X3JlYWQoJmRldmljZS0+cmVmY291bnQpKQ0K
PiANCj4gSXMgdGhlcmUgYSBwb3NzaWJsZSByYWNlIGhlcmUgd2l0aCBzb21ldGhpbmcgZ2V0dGlu
ZyBpbiBhbmQNCj4gaW5jcmVtZW50aW5nIHRoZSByZWZjb3VudCBiZXR3ZWVuIHRoZSByZWFkIGFu
ZCBzZXQ/DQoNCnRoaXMgd2lsbCBub3QgYmUgcmVxdWlyZWQgaW4gbmV4dCB2ZXJzaW9uLCB3aGlj
aCB3aWxsIGFsd2F5cyBjcmVhdGUNCmJvdGggZ3JvdXAgYW5kIG5vbmdyb3VwIGludGVyZmFjZXMg
Zm9yIGV2ZXJ5IGRldmljZSAodGhlbiBsZXQNCmRyaXZlciBwcm92aWRpbmcgLmJpbmRfaW9tbXVm
ZCgpIGNhbGxiYWNrIGZvciB3aGV0aGVyIG5vbmdyb3VwDQppbnRlcmZhY2UgaXMgZnVuY3Rpb25h
bCkuIEl0IHdpbGwgYmUgY2VudHJhbGx5IHByb2Nlc3NlZCB3aXRoaW4NCmV4aXN0aW5nIHZmaW9f
W3VuXXJlZ2lzdGVyX2dyb3VwX2RldigpLCB0aHVzIGFib3ZlIHJhY2UgaXMgbm90DQphIGNvbmNl
cm4gYW55IG1vcmUuDQoNCj4gDQo+ID4gKwkJcmVmY291bnRfc2V0KCZkZXZpY2UtPnJlZmNvdW50
LCAxKTsNCj4gPg0KPiA+ICAJbXV0ZXhfbG9jaygmZ3JvdXAtPmRldmljZV9sb2NrKTsNCj4gPiAg
CWxpc3RfYWRkKCZkZXZpY2UtPmdyb3VwX25leHQsICZncm91cC0+ZGV2aWNlX2xpc3QpOw0KPiA+
IEBAIC04MDQsNyArODEwLDc4IEBAIGludCB2ZmlvX3JlZ2lzdGVyX2dyb3VwX2RldihzdHJ1Y3Qg
dmZpb19kZXZpY2UNCj4gKmRldmljZSkNCj4gPg0KPiA+ICAJcmV0dXJuIDA7DQo+ID4gIH0NCj4g
PiAtRVhQT1JUX1NZTUJPTF9HUEwodmZpb19yZWdpc3Rlcl9ncm91cF9kZXYpOw0KPiA+ICsNCj4g
PiArc3RhdGljIGludCBfX3ZmaW9fcmVnaXN0ZXJfbm9uZ3JvdXBfZGV2KHN0cnVjdCB2ZmlvX2Rl
dmljZSAqZGV2aWNlKQ0KPiA+ICt7DQo+ID4gKwlzdHJ1Y3QgdmZpb19kZXZpY2UgKmV4aXN0aW5n
X2RldmljZTsNCj4gPiArCXN0cnVjdCBkZXZpY2UgKmRldjsNCj4gPiArCWludCByZXQgPSAwLCBt
aW5vcjsNCj4gPiArDQo+ID4gKwltdXRleF9sb2NrKCZ2ZmlvLmRldmljZV9sb2NrKTsNCj4gPiAr
CWxpc3RfZm9yX2VhY2hfZW50cnkoZXhpc3RpbmdfZGV2aWNlLCAmdmZpby5kZXZpY2VfbGlzdCwg
dmZpb19uZXh0KSB7DQo+ID4gKwkJaWYgKGV4aXN0aW5nX2RldmljZSA9PSBkZXZpY2UpIHsNCj4g
PiArCQkJcmV0ID0gLUVCVVNZOw0KPiA+ICsJCQlnb3RvIG91dF91bmxvY2s7DQo+IA0KPiBUaGlz
IGluZGljYXRlcyBhIGJ1ZyBpbiB0aGUgY2FsbGVyLCBkb2Vzbid0IGl0PyAgU2hvdWxkIGl0IGJl
IGEgQlVHIG9yDQo+IFdBUk4gaW5zdGVhZD8NCg0KdGhpcyBjYWxsIGlzIGluaXRpYXRlZCBieSB1
c2Vyc3BhY2UuIFBlciBKYXNvbidzIHN1Z2dlc3Rpb24gd2UgZG9uJ3QgDQpldmVuIG5lZWQgdG8g
Y2hlY2sgaXQgdGhlbiBubyBsb2NrIGlzIHJlcXVpcmVkLiANCg0KVGhhbmtzDQpLZXZpbg0K
