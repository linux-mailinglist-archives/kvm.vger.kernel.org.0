Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74D823A1051
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 12:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238099AbhFIJkg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 05:40:36 -0400
Received: from mga06.intel.com ([134.134.136.31]:62059 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234802AbhFIJkf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 05:40:35 -0400
IronPort-SDR: GCifOWBar94eE3rza7LEfacfxKpo2LkxjqCSvfL+yWMB/xOzi1a5r3dECrpVoBT7Pyjv7hpm10
 dp5n+mJwxmUA==
X-IronPort-AV: E=McAfee;i="6200,9189,10009"; a="266193832"
X-IronPort-AV: E=Sophos;i="5.83,260,1616482800"; 
   d="scan'208";a="266193832"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2021 02:38:40 -0700
IronPort-SDR: o467rMdeKf21PQV/hnXCJfnq5t0z79A6eZE9Uy9xMPNUNfCb/68FbTDVVyuM9LlTWz9diBKMRu
 GaPraB4FkJKw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,260,1616482800"; 
   d="scan'208";a="449886365"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga008.fm.intel.com with ESMTP; 09 Jun 2021 02:38:39 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Wed, 9 Jun 2021 02:38:39 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Wed, 9 Jun 2021 02:38:39 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Wed, 9 Jun 2021 02:38:39 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.170)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Wed, 9 Jun 2021 02:37:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dXqK6ujMqA8fXFpPoDGfvCU2OnjIxC/iCzAGE8LlYROZrbkbWy3wsvbix4xjAUhcXdlAxON22/ClWRPVfuHuS52pUexqMiMb4uav7XvShq/YvcLCGJ2luxyaj3g3SAqK715BwpjxilG1B0XUn5E6yYB9INkAc2GWCpCLPPMtFlHDvrUC61pz1JXrV+FqktPyGmbAGbs3z4qkcu0MWPtW3ijqzAORYG59/lIYSOYHP5I9RhmH3f9stMOA109aMYHmdQ/VHep7G1/S010eFYrCQSI0KeZYJ3fFYpcQvxVPG4Ihp7xJ2NESeOR420WYTRcpC1ag0E+vyK43p4ZbzleIAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fbJHONPVub+osidIT4A8TP7Nf1Ar25wOcdGPIo3+4Io=;
 b=Mib25x5ZibW/ZMcYW1grm6AaNwKVSIrMMgo+prDC6XIQTgBiw5xhQy0b74hzMyuraTb7OJ+HxO04wW3l2kH0beOI1VNUyVt24bY7dUYWvt+243oLGzQJUV8DnuunNWY1BZu2M3N7LdlTubM+/Y8oyWV3n3sv1E/3aTKW7jZu9TCM23ipbRjdD9thvsmBHOPK5G3il7AEzKdREBl+g1sRCfmMCnYkawnfx3zfDZfYYFVeZKirO2QEtQMFbIVDxGRWbpVi1OWxPZRCp1wooQpnExH+cVGgvNsnMbja1xrke/yWhdQtZgBpjMXfqzibUaZazB1xdqz+gCOH+3d+evqlQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fbJHONPVub+osidIT4A8TP7Nf1Ar25wOcdGPIo3+4Io=;
 b=ea8mugZtdO3ouuwJDIcYtVGb94IwDkqERd23Iuh+m00DCiDRieu5sOB3yZxeB7PbghSlAfxtOf2dVdPiUV6hVbnTBgMqJ0zFyuG58McN+Oa/mo/uteAKN+sX5XucR/I3fumHvgAHG4AbnjQ6cgACAsQybSodYumf7NDxUXfYNyY=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by MWHPR1101MB2302.namprd11.prod.outlook.com (2603:10b6:301:5a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23; Wed, 9 Jun
 2021 09:37:39 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1%12]) with mapi id 15.20.4195.030; Wed, 9 Jun 2021
 09:37:39 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        "Jason Wang" <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shenming Lu <lushenming@huawei.com>
CC:     Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "Kirti Wankhede" <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "David Woodhouse" <dwmw2@infradead.org>,
        Joerg Roedel <joro@8bytes.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: RE: Plan for /dev/ioasid RFC v2
Thread-Topic: Plan for /dev/ioasid RFC v2
Thread-Index: AddbO/WEUAFl3MPnRsG8exiH8bwEagBy43MAAAKwy+A=
Date:   Wed, 9 Jun 2021 09:37:39 +0000
Message-ID: <MWHPR11MB1886FEFB5C8358EB65DBEA1A8C369@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <MWHPR11MB188699D0B9C10EB51686C4138C389@MWHPR11MB1886.namprd11.prod.outlook.com>
 <b1bb72b5-cb98-7739-8788-01e36ec415a8@redhat.com>
In-Reply-To: <b1bb72b5-cb98-7739-8788-01e36ec415a8@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [101.80.65.46]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a926205a-c7f6-4c4b-04d0-08d92b2a3938
x-ms-traffictypediagnostic: MWHPR1101MB2302:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR1101MB2302DD71C4E3E9B26AB31C2A8C369@MWHPR1101MB2302.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wIOaCmKkEwBS7Ds72MWRWsBLHIaygrTEksQqiCbeGGkB/XdeSKl4YA2tiQYYDuCNGz2N3mth3OSDj1li0zlZk4TufS/hucofiRXFOCJr8OIRQjemveXo2ZI6WcvVCVLJaUquxPuJGnI2TT0zcJd8coATrQM6z4LTe5ZGJbFZhFzeJBIPLVk41gwSaYrOMoHSBlEJOb6omjRkK7eU4bgP9kfQVsKDswnzlGFi4fpbBD7BdQsD+YnOknFUBR7b3a4lQij2oMvd4KLO4EiHM7qWxWY8B8kiiiYsiFVCt7Xn+nOq6iICgo85EUmiyGT9WLEx6ID7fXYlmlVBFdYKpSoIS1hpXlDS7bgkXuXn/3qESnGx2c0khzH0z/Otwsb6czzx8E1JMy9aYGDpfdjyK00iZJc6iWJfIsdJ4IIBdxn6jOnx2yOXicpPXu9nZHPf534vcND31eMudOdcKGnjyMfo3X2JbRDG1f9KaHHs3nhHX2aKBTlaHuio5kyGpWLYagqEI7cOhi9R4uwEeojNWmdgxhj0OzISJWlN9Th/fOGB5gFv5JNckrCnsuW9buCJFMQujc554rqwfsmblfrrXRS1NYZAlJvMv+6VV0gISzFdZfLtfXwUJvpPW28g8NLi/0A54IiSmxbwE1XnD+Y4Ri32v8tvhTqOQ4Wmg0XnPok3PFo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(346002)(39860400002)(366004)(136003)(186003)(2906002)(4326008)(76116006)(64756008)(316002)(53546011)(54906003)(122000001)(26005)(8676002)(66476007)(66946007)(66556008)(66446008)(5660300002)(8936002)(86362001)(71200400001)(478600001)(921005)(7416002)(33656002)(38100700002)(110136005)(52536014)(83380400001)(6506007)(7696005)(55016002)(9686003)(21314003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WXphQVZNZ0hDamtISEl0SFpiM1dhNG1aYmJqb0xONFlJOGhTdFNuVFNXTENw?=
 =?utf-8?B?TmtINGdXZndjN0Q1L2lNUmpYQW1JcDJDeTB0eFI0eE1yZThtTm1kajNJZWg4?=
 =?utf-8?B?dHlheG44NVhrSkhMVnJpeENZMlBjY05JTG5UNWtOd0VRcHdEcSs2ekdBMEVu?=
 =?utf-8?B?UlZINENJNm9yTXZHajRuNHBJUXBXUHJvM0tUTGNpa2lPd25HMkZHUmNuS204?=
 =?utf-8?B?Q2tuT0RrOUdXTEY3eXFhL09hU09TcUI5SDdsbHdTVFpQQ3pwVEdSMVhIRW9m?=
 =?utf-8?B?b0FZdi9HSG9rRE5qY1QrcWltU0JpbnZreHVhV1F2cy9OTHJhZGFUaFNnTzJu?=
 =?utf-8?B?ZkJVSXVGL3Z4RkFsVUgzNSszL3ZOaWdJWVNOVGVDMGJUTVRoVzdjNk51SzA5?=
 =?utf-8?B?Wkg2L3pRb1ZpOGM0RkRhQkx0RER1MXluZVNLRHc3c2JGVm9zMTVaQU5ZWmJB?=
 =?utf-8?B?WVNUczh5ZW5GN3g3VmI2a1BjYXZ4Q0hwckRYaEc2ZGM4N2ZKRXNjdUU1azdq?=
 =?utf-8?B?d21ra1UrcUlDNGRyMWJkMGRRSGg0aUt4a2tmMlF5V0M4aEk2TFBYaGJ2cVdu?=
 =?utf-8?B?YWJEWlRzbHZhQjNCcmprUEFpbGtpWUs0V0tJWTdqYU9xVStDcUhla0RIVVBy?=
 =?utf-8?B?MFZLT0pBREU4RVV6NTh1RmpORitnTEpkYWRtME12VW50VklPTTNkaEw2ZEhi?=
 =?utf-8?B?bExjZytNb3NZVndNVGtDZnhBQXhaRS8ySEtUc2pvM0RhMUhCL05mSDJWUXF1?=
 =?utf-8?B?NkJVYXVnWlBFWVBSVnRoVmJzM3laNGZEOXVpY05BOGFJQXdsZjk3YXp3RStC?=
 =?utf-8?B?RWNrYXVQMUYyNFNrNCtYUW0xVDc2NXU2V2pUeE9LeThBeGhIdzF1VUdpRmJR?=
 =?utf-8?B?b3NoeHI5bnd4Y2xpczZrSHlsRlZpaTkram4zR0VYTEhMR1FPeDl2MEVRSjhv?=
 =?utf-8?B?ZkdZVWo1V2p2NHhPRkF2SXRQZGRKcC8vSjJmUnZtcGd3c2Y0UGFiLzVJMUw4?=
 =?utf-8?B?NjFpSnpzOUhJcXhjbzRCNXFFM3V4QVNEK2p1ckNUZVNZTzVQb1pKcTlHVU5Y?=
 =?utf-8?B?TjJQQldyZVVrTDQxV1pEVjlwdGdWWVRHbGNvd29QSENuc091MVV3YnZwNXZw?=
 =?utf-8?B?N0I4elQyMGE3b21XcHRKbTZOaERIQUNDL1Q0WFpqc2laWXhsWEhyZjVHbHJ1?=
 =?utf-8?B?c3E4NUl6Mnl4bmxaOStjTVNsaU9sTGdKVlZXbDVSS1RoQTZGN2xleDIxRTVa?=
 =?utf-8?B?ZU00czA3N2RzQy93bU81d29BTDBYNzJ1b1RzTXBaYUhFMllEOTJNNnRQak1o?=
 =?utf-8?B?ZXUzV3ZERXlKYWxFSkJuN3F5cVZ2a2lwbS9NYTRIRkNlVW1xOWxWRXBielp4?=
 =?utf-8?B?MjYvWGFHaFFNRjRkV2NONFlGT09uMnY3eFhpRVpackdQZkxyblliYkp6RzVu?=
 =?utf-8?B?WWV6WjZqSkdIZjE3ek5vY2Zyam5kZkk0QTM5SGVtUVhCU2duOHplRXhKVXVy?=
 =?utf-8?B?citjREJtV3pvakV2VG0vVlBrbFNuNWR5TlZtRnRMaEFieUU0RUU3OWZVL29E?=
 =?utf-8?B?QnhmYUpEZFUzeHUyNW5qOTFuYVJVRHd1WStIVzFlSDNQeVgwL2FyZS96cW9Y?=
 =?utf-8?B?RG9jTG9qMytKcStIeDlGakEycVdHZXNXZzFyZHRjRnZrMXNUWTdycTZSZVFO?=
 =?utf-8?B?S1E2MS9udGNrVWM0Y0lKQWNSbnd0OXpOaEJ3SExqeGRKUFdmWFBFY3NaMWI0?=
 =?utf-8?Q?Q7IpWHhn0p8gXc3Xyo=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a926205a-c7f6-4c4b-04d0-08d92b2a3938
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jun 2021 09:37:39.5520
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: krPYw9Qw5JHJLWRZnNdxE2BwuAl+5L80wh2KVzERenJVscAghbP3UMH+hwT2Tiq6FRP8D5V1jOlXvR8XfRVZvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2302
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+IFNlbnQ6IFdlZG5l
c2RheSwgSnVuZSA5LCAyMDIxIDQ6MTUgUE0NCj4gDQo+IEhpIEtldmluLA0KPiANCj4gT24gNi83
LzIxIDQ6NTggQU0sIFRpYW4sIEtldmluIHdyb3RlOg0KPiA+IEhpLCBhbGwsDQo+ID4NCj4gPiBX
ZSBwbGFuIHRvIHdvcmsgb24gdjIgbm93LCBnaXZlbiBtYW55IGdvb2QgY29tbWVudHMgYWxyZWFk
eSByZWNlaXZlZA0KPiA+IGFuZCBzdWJzdGFudGlhbCBjaGFuZ2VzIGVudmlzaW9uZWQuIFRoaXMg
aXMgYSB2ZXJ5IGNvbXBsZXggdG9waWMgd2l0aA0KPiA+IG1hbnkgc3ViLXRocmVhZHMgYmVpbmcg
ZGlzY3Vzc2VkLiBUbyBlbnN1cmUgdGhhdCBJIGRpZG4ndCBtaXNzIHZhbHVhYmxlDQo+ID4gc3Vn
Z2VzdGlvbnMgKGFuZCBhbHNvIGtlZXAgZXZlcnlvbmUgb24gdGhlIHNhbWUgcGFnZSksIGhlcmUg
SSdkIGxpa2UgdG8NCj4gPiBwcm92aWRlIGEgbGlzdCBvZiBwbGFubmVkIGNoYW5nZXMgaW4gbXkg
bWluZC4gUGxlYXNlIGxldCBtZSBrbm93IGlmDQo+ID4gYW55dGhpbmcgaW1wb3J0YW50IGlzIGxv
c3QuICA6KQ0KPiA+DQo+ID4gLS0NCj4gPg0KPiA+IChSZW1haW5pbmcgb3BlbnMgaW4gdjEpDQo+
ID4NCj4gPiAtICAgUHJvdG9jb2wgYmV0d2VlbiBrdm0vdmZpby9pb2FzaWQgZm9yIHdiaW52ZC9u
by1zbm9vcC4gSSdsbCBzZWUgaG93DQo+ID4gICAgIG11Y2ggY2FuIGJlIHJlZmluZWQgYmFzZWQg
b24gZGlzY3Vzc2lvbiBwcm9ncmVzcyB3aGVuIHYyIGlzIG91dDsNCj4gPg0KPiA+IC0gICBEZXZp
Y2UtY2VudHJpYyAoSmFzb24pIHZzLiBncm91cC1jZW50cmljIChEYXZpZCkgdUFQSS4gRGF2aWQg
aXMgbm90IGZ1bGx5DQo+ID4gICAgIGNvbnZpbmNlZCB5ZXQuIEJhc2VkIG9uIGRpc2N1c3Npb24g
djIgd2lsbCBjb250aW51ZSB0byBoYXZlIGlvYXNpZCB1QVBJDQo+ID4gICAgIGJlaW5nIGRldmlj
ZS1jZW50cmljIChidXQgaXQncyBmaW5lIGZvciB2ZmlvIHRvIGJlIGdyb3VwLWNlbnRyaWMpLiBB
IG5ldw0KPiA+ICAgICBzZWN0aW9uIHdpbGwgYmUgYWRkZWQgdG8gZWxhYm9yYXRlIHRoaXMgcGFy
dDsNCj4gPg0KPiA+IC0gICBQQVNJRCB2aXJ0dWFsaXphdGlvbiAoc2VjdGlvbiA0KSBoYXMgbm90
IGJlZW4gdGhvcm91Z2hseSBkaXNjdXNzZWQgeWV0Lg0KPiA+ICAgICBKYXNvbiBnYXZlIHNvbWUg
c3VnZ2VzdGlvbiBvbiBob3cgdG8gY2F0ZWdvcml6ZSBpbnRlbmRlZCB1c2FnZXMuDQo+ID4gICAg
IEkgd2lsbCByZXBocmFzZSB0aGlzIHNlY3Rpb24gYW5kIGhvcGUgbW9yZSBkaXNjdXNzaW9ucyBj
YW4gYmUgaGVsZCBmb3INCj4gPiAgICAgaXQgaW4gdjI7DQo+ID4NCj4gPiAoQWRvcHRlZCBzdWdn
ZXN0aW9ucykNCj4gPg0KPiA+IC0gICAoSmFzb24pIFJlbmFtZSAvZGV2L2lvYXNpZCB0byAvZGV2
L2lvbW11IChzbyBkb2VzIHVBUEkgZS5nLiBJT0FTSUQNCj4gPiAgICAgX1hYWCB0byBJT01NVV9Y
WFgpLiBPbmUgc3VnZ2VzdGlvbiAoSmFzb24pIHdhcyB0byBhbHNvIHJlbmFtZQ0KPiA+ICAgICBS
SUQrUEFTSUQgdG8gU0lEK1NTSUQuIEJ1dCBnaXZlbiB0aGUgZmFtaWxpYXJpdHkgb2YgdGhlIGZv
cm1lciwgSSB3aWxsDQo+ID4gICAgIHN0aWxsIHVzZSBSSUQrUEFTSUQgaW4gdjIgdG8gZWFzZSB0
aGUgZGlzY3Vzc29pbjsNCj4gPg0KPiA+IC0gICAoSmFzb24pIHYxIHByZXZlbnRzIG9uZSBkZXZp
Y2UgZnJvbSBiaW5kaW5nIHRvIG11bHRpcGxlIGlvYXNpZF9mZCdzLiBUaGlzDQo+ID4gICAgIHdp
bGwgYmUgZml4ZWQgaW4gdjI7DQo+ID4NCj4gPiAtICAgKEplYW4vSmFzb24pIE5vIG5lZWQgdG8g
dHJhY2sgZ3Vlc3QgSS9PIHBhZ2UgdGFibGVzIG9uIEFSTS9BTUQuDQo+IFdoZW4NCj4gPiAgICAg
YSBwYXNpZCB0YWJsZSBpcyBib3VuZCwgaXQgYmVjb21lcyBhIGNvbnRhaW5lciBmb3IgYWxsIGd1
ZXN0IEkvTyBwYWdlDQo+IHRhYmxlczsNCj4gd2hpbGUgSSBhbSB0b3RhbGx5IGluIGxpbmUgd2l0
aCB0aGF0IGNoYW5nZSwgSSBndWVzcyB3ZSBuZWVkIHRvIHJldmlzaXQNCj4gdGhlIGludmFsaWRh
dGUgaW9jdGwNCj4gdG8gc3VwcG9ydCBQQVNJRCB0YWJsZSBpbnZhbGlkYXRpb24uDQoNClllcywg
dGhpcyBpcyBwbGFubmVkIHdoZW4gZG9pbmcgdGhpcyBjaGFuZ2UuDQoNCj4gPg0KPiA+IC0gICAo
SmVhbi9KYXNvbikgQWNjb3JkaW5nbHkgYSBkZXZpY2UgbGFiZWwgaXMgcmVxdWlyZWQgc28gaW90
bGIgaW52YWxpZGF0aW9uDQo+ID4gICAgIGFuZCBmYXVsdCBoYW5kbGluZyBjYW4gYm90aCBzdXBw
b3J0IHBlci1kZXZpY2Ugb3BlcmF0aW9uLiBQZXIgSmVhbidzDQo+ID4gICAgIHN1Z2dlc3Rpb24s
IHRoaXMgbGFiZWwgd2lsbCBjb21lIGZyb20gdXNlcnNwYWNlICh3aGVuIFZGSU9fQklORF8NCj4g
PiAgICAgSU9BU0lEX0ZEKTsNCj4gDQo+IHdoYXQgaXMgbm90IHRvdGFsbHkgY2xlYXIgdG8gbWUg
aXMgdGhlIGNvcnJlc3BvbmRhbmNlIGJldHdlZW4gdGhpcyBsYWJlbA0KPiBhbmQgdGhlIFNJRC9T
U0lEIHR1cGxlLg0KPiBNeSB1bmRlcnN0YW5kaW5nIGlzIGl0IHJhdGhlciBtYXBzIHRvIHRoZSBT
SUQgYmVjYXVzZSB5b3UgY2FuIGF0dGFjaA0KPiBzZXZlcmFsIGlvYXNpZHMgdG8gdGhlIGRldmlj
ZS4NCj4gU28gaXQgaXMgbm90IGNsZWFyIHRvIG1lIGhvdyB5b3UgcmVjb25zdHJ1Y3QgdGhlIFNT
SUQgaW5mbw0KPiANCg0KWWVzLCBkZXZpY2UgaGFuZGxlIG1hcHMgdG8gU0lELiBUaGUgZmF1bHQg
ZGF0YSByZXBvcnRlZCB0byB1c2Vyc3BhY2UNCndpbGwgaW5jbHVkZSB7ZGV2aWNlX2xhYmVsLCBp
b2FzaWQsIHZlbmRvcl9mYXVsdF9kYXRhfS4gSW4geW91ciBjYXNlDQpJIGJlbGlldmUgU1NJRCB3
aWxsIGJlIGluY2x1ZGVkIGluIHZlbmRvcl9mYXVsdF9kYXRhIHRodXMgbm8gcmVjb25zdHJ1Y3QN
CnJlcXVpcmVkLiBGb3IgSW50ZWwgdGhlIHVzZXIgY291bGQgZmlndXJlIG91dCB2UEFTSUQgYWNj
b3JkaW5nIHRvIGRldmljZV8NCmxhYmVsIGFuZCBpb2FzaWQsIGkuZS4gbm8gbmVlZCB0byBpbmNs
dWRlIFBBU0lEIGluZm8gaW4gdmVuZG9yX2ZhdWx0X2RhdGEuDQoNClRoYW5rcw0KS2V2aW4NCg==
