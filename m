Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA01D3997EC
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 04:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbhFCCNp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 22:13:45 -0400
Received: from mga04.intel.com ([192.55.52.120]:26955 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229541AbhFCCNo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 22:13:44 -0400
IronPort-SDR: Dfb6NZh2uiimnrpAoBNFLLbuROxHfgg4s09QXsnmnxnXXAAgCnVKK0+5C2HA1NPVOvbwaqwDv1
 ZQuXmtBF2IBg==
X-IronPort-AV: E=McAfee;i="6200,9189,10003"; a="202087232"
X-IronPort-AV: E=Sophos;i="5.83,244,1616482800"; 
   d="scan'208";a="202087232"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2021 19:11:59 -0700
IronPort-SDR: REKzntk7jJM/UAwkcsv5IXqR9eE5fkld6o1Ug7zUBqohQoAEPX2H8rTNVkSjK0ewWN8lsdkLBE
 wTFS9NC3Ay1g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,244,1616482800"; 
   d="scan'208";a="483279171"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 02 Jun 2021 19:11:57 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Wed, 2 Jun 2021 19:11:57 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Wed, 2 Jun 2021 19:11:56 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.173)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Wed, 2 Jun 2021 19:11:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=grboheJ4UWuwGdqqnSVsO9c7xcl1705WlUZmpURbTDx1CiZvouoesPTjvVOqeLeg1gR7b8TMxpjD952XngkPyMdQFV/7bhITwOrFWcb8lsbfDg/4wENYWj7ryhWY6CgJmeCqbpgIbb1eKHmoZPq4O/LD2HAo45yBdYXEhGCy4VtXdeGpvPwbzWvI13YbhlgiHarGPYekSyHMqqiBuwHO6RqvEcf6rsvFjiM3qpzfvuSSp0tsUh5y+We2Hd/u9MEAZbz/ddvdEdVi9pRskNT+LqcCqAjoo+RuphXpzHFKgwU27xeEPy3+gGkKI3I01qXrGwVY3kNSfcg41HPg+ZBQ8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c8rUeggm5riKvqerW3QpsUe8kmxCR9xenN48OMn/+e8=;
 b=VSWdqBtUBr1linoH1p9FE64+MhrLKXu7EBPE/V8lQKlGUjvivb8vX483etpWHvSxa0c8pVq7ehtbOM0vZXXNwm2l7fMoXiSkiQYnCgG4RBrwVrWtIQiqplBvrOauoTx3Rre8J+pss+Y6p/z+Zsg9HYIiRuBYUv6yVpRuN1QqsdNsvV4PXUVaqWVsG812BF+kwArSkojH0JQd9WrLvqVL/rPk73KhzHtnBgt0sCdPjUReiK0wTqLmQ5Hrplg6ahvyhZkVfuhT0Y+PvRE6PqM5HPnfnoVKVj451iqBC/P2uT7vqapUaGVkfUlvSDdVoxtw07E4xG+9yaHFg1FD/CDxvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c8rUeggm5riKvqerW3QpsUe8kmxCR9xenN48OMn/+e8=;
 b=RBDbhv9PnY1Zm93PqZsrx0x0dvuRso9Zv7KVoC0Qn4sB2svwjxzxSf6dCb53/0h2Uf8fthfqcadQsFGT8lDA1p+zLaUv+lR7wZFVH6+02QM5+bmgxKvXjfNYc5pgoQNtKkkTrX68U8OVxyX26qh+0+M5tFyMJ0jxD0RozR4VU64=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by MW3PR11MB4636.namprd11.prod.outlook.com (2603:10b6:303:5a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.24; Thu, 3 Jun
 2021 02:11:53 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1%12]) with mapi id 15.20.4173.030; Thu, 3 Jun 2021
 02:11:53 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        David Gibson <david@gibson.dropbear.id.au>
CC:     LKML <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        "Lu Baolu" <baolu.lu@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>, Jason Wang <jasowang@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: RE: [RFC] /dev/ioasid uAPI proposal
Thread-Topic: [RFC] /dev/ioasid uAPI proposal
Thread-Index: AddSzQ970oLnVHLeQca/ysPD8zMJZwBGs/UAAORLsoAAFGh/AAAUU3yg
Date:   Thu, 3 Jun 2021 02:11:53 +0000
Message-ID: <MWHPR11MB18862E994DE35AB46347CE0E8C3C9@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210528173538.GA3816344@nvidia.com> <YLcl+zaK6Y0gB54a@yekko>
 <20210602161648.GY1002214@nvidia.com>
In-Reply-To: <20210602161648.GY1002214@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.142.24]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6f3b21d4-86b2-4411-4338-08d92634f4c8
x-ms-traffictypediagnostic: MW3PR11MB4636:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR11MB4636AF2FE7BA9BA2F7A02C458C3C9@MW3PR11MB4636.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: r416oZNF7vDhnIno+vxz0cIlesgG8VTMJtqJRPBQkUlLSfdlkxx8NJzlcGN0iUKB717maXrqcYX/JX0W4+nTNbhbis8kdKeGVW8NNM/WS9x6u1cuD57/ONTH+CtoVPcAm69js6xt/7X4c0+GZgxGdq3AboSd3W3rb4ZUmw3LmVA/jxhP2xC62dYiOsQhqYj+KRw9dLDrCEXokx4Eig/y1AQf5o6zwyrvQhiKGILE0TEYdCm6CCOQkoYE0cNEdUlkVeZnIC8TtxQ3T4NZa5S1gHFEua2JtevvmVFEY/23LhJofsc6vSwmAUYfIpamYzxGLeMiLoOo+kuHPm1KV4HqdYAOE0cg8mCGD4fmVc6up/Nl5Lyqqw+NOBnEEHYLZwNg6EXfNAqQMIFccoMVGm3u9gUOVc7M1ZXwvEvTE+m5r4pwCTV9cityqduAzFfVENMEuCQSVE7biQamCOGmOaebeE/J3xooru1aIALN2cjfFEqKDcnLxWfxCi9fMMoeLhTcNGoG/8cZSPO0BIybt+w91/T/TIap0coylAvjA9D/DJYZabTYaGCxyo0wpNaHMCGcJ7OQ4wgaP+Sa06dEe1JiicCb6+J37oSStWG4uYubjHA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(376002)(346002)(396003)(366004)(122000001)(186003)(6506007)(76116006)(86362001)(8936002)(55016002)(4326008)(7416002)(52536014)(7696005)(8676002)(5660300002)(26005)(110136005)(38100700002)(66446008)(54906003)(83380400001)(316002)(71200400001)(33656002)(66556008)(2906002)(66476007)(478600001)(9686003)(64756008)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?YWxzblRXSXBtUnlOdTk0dndJY2UrN3FoOGdCMUs3OEdWNmZqUGxnZUlvbTVv?=
 =?utf-8?B?bHI1c29OMXYvbERaTWMveXBtNFJMMWdnZG5FNk9JbjZXWEpCSFhTak1keEc3?=
 =?utf-8?B?ZCtjTngyOXd4TzFHWXFEbGNTOHd3T29VaHV5dUViYkt4RjlMWHdTbG1qVlhr?=
 =?utf-8?B?UmV5TEtGYlJzMzFiNVZQR2gwYk5Idm9kUGFBWEhFYk9jNUtLcktvaEFVM0Ju?=
 =?utf-8?B?M2ZzTEdUQnJTZlJUaHJ4UzlEdWFvanZlR1ZNbkp2WHV4UjB2MitUK1ZWVktY?=
 =?utf-8?B?MlV4NmxEQVNQQkc1d0owMVpFVk41OWgxa0FBUXJRS0w5QWZCRDFHaC8rWklN?=
 =?utf-8?B?bVdmODF3NUh2L045MkNiTk1TV1N2YzVIcEFTTjFnRTFvaFdSaENXWWFnMy8v?=
 =?utf-8?B?cjBEM1g0T3FVUmw5N3hPR1Y4NWtwTTNkN2lpWXBPQjhTamFpajFJTWV4Uk5y?=
 =?utf-8?B?bmwzS0p6Q2F1TWJxUFA3QS85RFBhNnd4MWhCSDhEVXdvbjZTMzJRREJlNWRT?=
 =?utf-8?B?dVZOc3k5dzVWN0VjVGhtZGdtTis2eERlSFozS2VzMUFIcnRlWjlrUm41RVVz?=
 =?utf-8?B?NmNCRm9yR3phZUdFa2ZwT09ia0RXNWNCc0FJT3lOVGRZVjBzUVNpdFp1NmJD?=
 =?utf-8?B?c0lPeGZLeE1mRVRadWR2eWwwZldSRnd2M0pVTGJndmc4TjA1RDhDcVZSY1VL?=
 =?utf-8?B?U0JBUnpTNnlvWlJtbzFSMDlxSWJhV2dPamQ2K1c0ZXhUcEJockhhL21LRnNs?=
 =?utf-8?B?OEI5eGhyK0F2TkZMb2xsK1l2TXBJSHpzNStFR3pUZGhpenRCbU45Ny9qdkVS?=
 =?utf-8?B?SkY4SC82Q09TMTRFdnJYMDVKcVZRWWVuU25teXhnenRZZVBSVW9HRXFpY0hJ?=
 =?utf-8?B?MEtRUG5vVlA3ZnFlKzYrSTdCUS85bUxiWHpjVDkwcTBGVWl0RFU1MHdXYUYv?=
 =?utf-8?B?UlRzVkFTYVRNVXY5TUMzd1JZWnBKVHRxRWQ3dGlzeFVkZlFENCtkbm92d2NR?=
 =?utf-8?B?M0pIVkVoRGFrTU1DTFpQN20yTXhUNU5qSUNBanpvekRweStZUUpnOVMrQm5y?=
 =?utf-8?B?c0lRL2MzUjZNa2VReVVPbXFRM1NtUGFnMjV5MUk2WDVBazFGWWlMbC9RRUY3?=
 =?utf-8?B?akZqZm9jSi9GMkhpdUI2YVhvdHZoZWl5VWZSa3NRSFd0Q3lURk1USXIxQzgv?=
 =?utf-8?B?b3hJYUcxbmdJZGJnMmJJOHM1UEo5K21FZGQ0MTdCdTdlWXNpZ1FnVVFZNnNn?=
 =?utf-8?B?SmEvekVDbGh6eUV2ZDcwMGtLMnFuenNHT2NPQk9wMlpLeG5XZGFUN1gxU21Z?=
 =?utf-8?B?R1hrM0YvU2FrY2V1ckZIbmFzZmpTU3l5OS9jTFNMSGhyUzJVSmdFYjJIUU53?=
 =?utf-8?B?STFTT0ZqNXZDV2pMbnpBUndhbHpPZTQrd29GcnAxT2pvY2RDYWxNRGpsVHpT?=
 =?utf-8?B?UHhEZCtMeGl6OURDZCtBYXpOb1FRbDFQUkJWMHJWMzAwZmF0bFJETVNMcGgr?=
 =?utf-8?B?b0xkbHB0cFp5andxSG8yQ0RSSUx6SEU5TnhwL1VwZyttNlIwL01OSHoxZ0ls?=
 =?utf-8?B?TEpnSzlSa1ZpYitnZjRCVG85QXhlYVltSEpHT3hGMkwyd1NwNno0Kzd3T1pH?=
 =?utf-8?B?WU9QR3A1czRFaHVKR1VudERGeGFCd3RqcXJ5eDdiNjBNdlhML0huVXp1U1U5?=
 =?utf-8?B?UWhuSG0rZ1RSdXVRMmJqWGtQTWdjOGtLaWp1RWtXY1Z6M3B5QkRIL29TVkdV?=
 =?utf-8?Q?Ds8hGjaVQpjt7o9so3QO7wZ4sLbjVbhS3g08am0?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f3b21d4-86b2-4411-4338-08d92634f4c8
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2021 02:11:53.4456
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eQJP0uh0qaGxiY7ISZt4ASQwTJ75ziI8acb+7+KiPMN4qothPtVD+1y2ll2ZyULHBR4r9pv8cgi6Mb58XvOpLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4636
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPg0KPiBTZW50OiBUaHVyc2Rh
eSwgSnVuZSAzLCAyMDIxIDEyOjE3IEFNDQo+DQpbLi4uXSANCj4gPiA+IElmIHRoZXJlIGFyZSBu
byBoeXBlcnZpc29yIHRyYXBzIChkb2VzIHRoaXMgZXhpc3Q/KSB0aGVuIHRoZXJlIGlzIG5vDQo+
ID4gPiB3YXkgdG8gaW52b2x2ZSB0aGUgaHlwZXJ2aXNvciBoZXJlIGFuZCB0aGUgY2hpbGQgSU9B
U0lEIHNob3VsZCBzaW1wbHkNCj4gPiA+IGJlIGEgcG9pbnRlciB0byB0aGUgZ3Vlc3QncyBkYXRh
IHN0cnVjdHVyZSB0aGF0IGRlc2NyaWJlcyBiaW5kaW5nLiBJbg0KPiA+ID4gdGhpcyBjYXNlIHRo
YXQgSU9BU0lEIHNob3VsZCBjbGFpbSBhbGwgUEFTSURzIHdoZW4gYm91bmQgdG8gYQ0KPiA+ID4g
UklELg0KPiA+DQo+ID4gQW5kIGluIHRoYXQgY2FzZSBJIHRoaW5rIHdlIHNob3VsZCBjYWxsIHRo
YXQgb2JqZWN0IHNvbWV0aGluZyBvdGhlcg0KPiA+IHRoYW4gYW4gSU9BU0lELCBzaW5jZSBpdCBy
ZXByZXNlbnRzIG11bHRpcGxlIGFkZHJlc3Mgc3BhY2VzLg0KPiANCj4gTWF5YmUuLiBJdCBpcyBj
ZXJ0YWlubHkgYSBzcGVjaWFsIGNhc2UuDQo+IA0KPiBXZSBjYW4gc3RpbGwgY29uc2lkZXIgaXQg
YSBzaW5nbGUgImFkZHJlc3Mgc3BhY2UiIGZyb20gdGhlIElPTU1VDQo+IHBlcnNwZWN0aXZlLiBX
aGF0IGhhcyBoYXBwZW5lZCBpcyB0aGF0IHRoZSBhZGRyZXNzIHRhYmxlIGlzIG5vdCBqdXN0IGEN
Cj4gNjQgYml0IElPVkEsIGJ1dCBhbiBleHRlbmRlZCB+ODAgYml0IElPVkEgZm9ybWVkIGJ5ICJQ
QVNJRCwgSU9WQSIuDQoNCk1vcmUgYWNjdXJhdGVseSA2NCsyMD04NCBiaXQgSU9WQSDwn5iKDQoN
Cj4gDQo+IElmIHdlIGFyZSBhbHJlYWR5IGdvaW5nIGluIHRoZSBkaXJlY3Rpb24gb2YgaGF2aW5n
IHRoZSBJT0FTSUQgc3BlY2lmeQ0KPiB0aGUgcGFnZSB0YWJsZSBmb3JtYXQgYW5kIG90aGVyIGRl
dGFpbHMsIHNwZWNpZnlpbmcgdGhhdCB0aGUgcGFnZQ0KDQpJJ20gbGVhbmluZyB0b3dhcmQgdGhp
cyBkaXJlY3Rpb24gbm93LCBhZnRlciBhIGRpc2N1c3Npb24gd2l0aCBCYW9sdS4NCkhlIHJlbWlu
ZGVkIG1lIHRoYXQgYSBkZWZhdWx0IGRvbWFpbiBpcyBhbHJlYWR5IGNyZWF0ZWQgZm9yIGVhY2gN
CmRldmljZSB3aGVuIGl0J3MgcHJvYmVkIGJ5IHRoZSBpb21tdSBkcml2ZXIuIFNvIGl0IGxvb2tz
IHdvcmthYmxlDQp0byBleHBvc2UgYSBwZXItZGV2aWNlIGNhcGFiaWxpdHkgcXVlcnkgdUFQSSB0
byB1c2VyIG9uY2UgYSBkZXZpY2UNCmlzIGJvdW5kIHRvIHRoZSBpb2FzaWQgZmQuIE9uY2UgaXQn
cyBhdmFpbGFibGUsIHRoZSB1c2VyIHNob3VsZCBiZSBhYmxlDQp0byBqdWRnZSB3aGF0IGZvcm1h
dC9tb2RlIHNob3VsZCBiZSBzZXQgd2hlbiBjcmVhdGluZyBhbiBJT0FTSUQuDQoNCj4gdGFibmxl
IGZvcm1hdCBpcyB0aGUgODAgYml0ICJQQVNJRCwgSU9WQSIgZm9ybWF0IGlzIGEgZmFpcmx5IHNt
YWxsDQo+IHN0ZXAuDQoNCkluIGNvbmNlcHQgdGhpcyB2aWV3IGlzIHRydWUuIEJ1dCB3aGVuIGRl
c2lnbmluZyB0aGUgdUFQSSBwb3NzaWJseQ0Kd2Ugd2lsbCBub3QgY2FsbCBpdCBhIDg0Yml0IGZv
cm1hdCBhcyB0aGUgUEFTSUQgdGFibGUgaXRzZWxmIGp1c3QNCnNlcnZlcyAyMGJpdCBQQVNJRCBz
cGFjZS4gDQoNCldpbGwgdGhpbmsgbW9yZSBob3cgdG8gbWFyayBpdCBpbiB0aGUgbmV4dCB2ZXJz
aW9uLg0KDQo+IA0KPiBJIHdvdWxkbid0IHR3aXN0IHRoaW5ncyBpbnRvIGtub3RzIHRvIGNyZWF0
ZSBhIGRpZmZlcmVuY2UsIGJ1dCBpZiBpdA0KPiBpcyBlYXN5IHRvIGRvIGl0IHdvdWxkbid0IGh1
cnQgZWl0aGVyLg0KPiANCg0KVGhhbmtzDQpLZXZpbg0K
