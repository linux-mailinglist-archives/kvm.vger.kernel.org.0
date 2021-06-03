Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAB98399838
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 04:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbhFCCvo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 22:51:44 -0400
Received: from mga07.intel.com ([134.134.136.100]:59464 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229625AbhFCCvn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 22:51:43 -0400
IronPort-SDR: mIBQmLkfOTeDAzMcyEN37VZff7600pPF9Qz7hOJce7jlEWuPv++Op53Nyzj69oAc52DnPXwp45
 XzRx/fscZMSQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10003"; a="267818419"
X-IronPort-AV: E=Sophos;i="5.83,244,1616482800"; 
   d="scan'208";a="267818419"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2021 19:49:58 -0700
IronPort-SDR: XMWr/AKlGAhLCQAl0eJj8PKV+muv3FjCOA7kuZn7keT8UVhMhz1JRlYTzDQuUrgtbFVcJ6B6/8
 mu5/cE6cUcUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,244,1616482800"; 
   d="scan'208";a="417172359"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga002.jf.intel.com with ESMTP; 02 Jun 2021 19:49:58 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Wed, 2 Jun 2021 19:49:58 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Wed, 2 Jun 2021 19:49:58 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Wed, 2 Jun 2021 19:49:58 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Wed, 2 Jun 2021 19:49:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lHkN5W0B/OnzvegAmd7XRIQMsjMdYRMJHTT/wcCGv7S4YRfdK7MtHjNbFpv6kdb9pc0bCNhFy3wuy8j3wNKK6V++Aoo+BjMQgbqBtjWJ/17NPtaCGT+LfulFchtvoOgchUymXskfAwktEZDjgdPmMOWKY/dR5byduY1tWgN1uoDx+aokWWhkuzFbhKsc9rJ3SGDNsu+yphTzznWXfzt2geOwe7BKgxo5b0nauIybaRJEnpdAC6bdRr7SGW+PIkcy6CeSKVvr4ajrvD5do9HhQR/6yceBgG+1v+LhCfati2uH7+uNN2ab3cwk4cQPc3Nhb94EVQfKFGVPAQBRLwCDnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZtWXx1r1RszHXP2unKznpZwI/8pkMnEQwY2nGva35fw=;
 b=C+tQpxBdm/XbmlsVOK5nnqHsVd1ftYCdufrbXYqPr/gxwSVyoMbb4cPIKc4D6USXHvBucvynbbmvqwwpPCeIQM4x5Q0WfZI4QD5MM1KYPdU1/aFbVjNp50WhRq3gLyU0/7W9r5z6L6nLqyY9Z0hl2YG+2kxcZh/sIx5phDFbqw3+fiOQn+p7Llkc6lfewS3PjkZcs7I1ZzMY3Iu5nWqM7dAOUTmZkSnfbaVDoEPPMmM0IPggdQNyILl77HAcwIUMsu07u6370HvxOVb/aQzCsNVEfalNS3vav7TgkvjMjy6CIy11uFHo98FmjpCQeuTmCUZO/lgz5B8VhNVX0FOPmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZtWXx1r1RszHXP2unKznpZwI/8pkMnEQwY2nGva35fw=;
 b=YhhXj2FA6pORjrd2/5fbKj7UWkUgKy26T8t0GoOIvLdCePom2QECsPL8z3/g90aulRwng55ibkgZYkN/INU4hJCh/MKA8Yb971rrkoB+STT3SpSShbzWW5bxYHtkSz0KtS3dpAyHx867kSLE2ju2o7k4bpYp9yprrqUt02+/0ho=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by CO1PR11MB4930.namprd11.prod.outlook.com (2603:10b6:303:9b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22; Thu, 3 Jun
 2021 02:49:56 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1%12]) with mapi id 15.20.4173.030; Thu, 3 Jun 2021
 02:49:56 +0000
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
Thread-Index: AddSzQ970oLnVHLeQca/ysPD8zMJZwBLsqGAAN/dRYAAFU5FAAATgeoA
Date:   Thu, 3 Jun 2021 02:49:56 +0000
Message-ID: <MWHPR11MB1886A746307BD6E16FCBC3418C3C9@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210528195839.GO1002214@nvidia.com> <YLcpw5Kx61L7TVmR@yekko>
 <20210602165838.GA1002214@nvidia.com>
In-Reply-To: <20210602165838.GA1002214@nvidia.com>
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
x-ms-office365-filtering-correlation-id: c9b8b1ef-0a13-4bc0-4382-08d9263a4552
x-ms-traffictypediagnostic: CO1PR11MB4930:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO1PR11MB4930CF21AA334E0F99408B798C3C9@CO1PR11MB4930.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: F/2JQsr9tKiWUaO/jU6slSm1IufS0Hc4KQQcO9hKhiutemzk2csfU+u7o8j+OAWeFNTr9osjwl/dfPEMs3vWdP9oeDS3v9xP2j6EixA9TCW1MWUp8ZM52Y2+meUrUAStZ2Akp2SBX9cIgTdDwv0Nc5uykGc/3ZG/jZb+68moqFFJbwbGN2ZZArrVREOVMHjKTfgFdmFbX8sBBjo/D3b2QybN4P4p7pna6N8hi54+snSePzYIY0VzOcjLn+9w39EFbzOm7OCrGHFBB0sAAcCfSLCT0wAjFDy3d4QRsnZSYOG5lqBkMfk+3HRB6U9rG01RNx6sPO3njHSUq98yJGMYVt5yu3+5U/d/i7ijbej4aP7rl96V3iPyD1V6dmTtPsQzdsoFGQj0+H7fp2p6iAPJIw197duXDtV1lN2j63WvPXXiR1xmqaJRGRbLbrsX0B9xfJch6V6F7cqlSo+KuU+8QjQlIPtrN5JQP9ty378c5hicBiLVGfARg07wyVvHrXcbYVGCS9gQlnv2k3yT5woe+BmgpzJ0g0H4v9H8XXv55vrTRQLuDYOo/Dk0vnN3RhVkMaDnDVu8kJ93/JyJEJjpLl4+QM750Rx9gF2QS0Shdi4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(39860400002)(396003)(346002)(366004)(7696005)(6506007)(71200400001)(5660300002)(186003)(26005)(54906003)(110136005)(7416002)(316002)(52536014)(66556008)(66476007)(66446008)(64756008)(76116006)(66946007)(9686003)(55016002)(8936002)(8676002)(2906002)(83380400001)(4326008)(33656002)(86362001)(122000001)(38100700002)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?UzF4WmVaV3dMa1Y4Y1JMZzdGbGI4czNlRlZlbGFIb2Q0SkI5dlR3MmRwOEUz?=
 =?utf-8?B?QklUejBUQ1pxZ1kzeUZnYzhiZTQrcmtkUm1KRHJ2UUJGQjhycUFmc0VkUE5s?=
 =?utf-8?B?QnJwVnFteFQ5NWFER2VoNlMvRGdBdGZ4ZlVZWVBiSzl0TlYwVlM4alZkaUdl?=
 =?utf-8?B?MlBEaVlhT3VFczgzSW9sVmkrM1VzemxVRlJoUXJGYzBDNmN1eld4UFlCdjQ3?=
 =?utf-8?B?eUZiTjZ6OWVlVFFDQmlFK01VaXVkbVY2Y1dzTHJMRkpaZDlSamVuOW9EWEsz?=
 =?utf-8?B?L3p3QmZWakZ0ZWVqVVd1eUh0ZmVtOWExWXRnRlB5dHBkRkREOGhSa3k1UGUz?=
 =?utf-8?B?ZzFMdi9iUzhRb0hKcW55aTFKRmVKUW9wUU9ZYURnRFMzck0vbUZKV0txNEFP?=
 =?utf-8?B?MzBvWGRZbytYTldST0pmNzFlN2UvSDBnZUlOWXJ6OHlxZ2YrZHN5U1pRWHBa?=
 =?utf-8?B?K2JVOEs4TFErM3ZVdXU0aHoxUWFHckFUSkNhK3F6YlJGVUlyamRNbGdzWFhv?=
 =?utf-8?B?U05BQjVPR2hKOXlSVUpidFlxNEt1VG5wZUlQT252QlNoU2dOMG9pSGR6QU96?=
 =?utf-8?B?ejFjdndHZTJ1Ti9aU01WZGllSmtVeTlUdDVqWU9PdzdYYmpaN2NJNmJpWWZM?=
 =?utf-8?B?NldoQW13bHpxcTRyWTRGWHZpZTdLMElMdXZNV2ZMNmlieDQ4V1pKcWJkc0xR?=
 =?utf-8?B?QmZyaVRxOURDWTFod1FJQ0hsbkF5N2ExdnZQVG9MdlZFTmw3RFJ3Q2c3OXRE?=
 =?utf-8?B?KzBCQVNPOHZPa3hET2w5Mks5TG45a29aNWJmRzV1VWxHa1UrbngvNkpJRkQ2?=
 =?utf-8?B?RVZSMUNNNnFLL1dJZTVBQ210WE1rL3pMVnpDTm5UT20xb1RmUnZ2d3dFT2JM?=
 =?utf-8?B?Z2VNdzBFK1Zlb2dMTEluTkh2cG82dGlWQk40emlhTUMzUzdJb1ovWFNKa3RJ?=
 =?utf-8?B?TzUyOER3SHk2S1VUOGZzaUpOYzFRaFBYSlRkVEpvRklXOGpxdlpPR3RHMFJ2?=
 =?utf-8?B?NFY1L2w2NTZMc3JHWmFnUGN4bWhVNWtDYlJaVmx1d1pUdTZqTlpLZXMycUM2?=
 =?utf-8?B?akpqby80WGVtWERESEs3WjNnRUZMTE45citmTWs3eEx4eUhicTdIcWRLTTZw?=
 =?utf-8?B?VzFSWTIzL3NYVkdxOHVRWkthNjRkTS9uQWFWaTQyTWcwM1UzSFpoK0pKcldR?=
 =?utf-8?B?T1RiMEZsWXM5YzlURGo4OGlRZEZYdmVVczRwYnVyT0o2dkg2RUJySktrZjk4?=
 =?utf-8?B?Y0JyZmlvL3p6M1Z1SVFBY0NYS2FSdE5CeXplUXdJMlRBeTdEUXcxcVdKZDFJ?=
 =?utf-8?B?YmJneXQ4OWM2WG9yQThIajBrY1BOeDJ4Q050Tm5pZUJZT0Rwc0FaTUZSTUx3?=
 =?utf-8?B?SUxzcldSWFdxbHdZNmFOa2w1K3o2SEVmcnh6amEwRk1ZdVE4clEvTDROZzNx?=
 =?utf-8?B?Y2NjdDVEcHN2SlZVNlNqQ0JnNUY1eTk4S1VTU1NJekwrRnZGcHI0L3BSVElV?=
 =?utf-8?B?Vms0aTc2NEs3d2tPSUc5dThYcG13MTZRZDNrVXdhbmd4dGxOMjJUVlo3bjRp?=
 =?utf-8?B?TThrQXI0bG9odld6bGFJVXgydkRnR1FmdXBOL0JyM1lHczAyTmduTWNKbTAz?=
 =?utf-8?B?MGFvMHRBcENFNHN5RE1IQlNPUU1Id2ducmJzWmRsUklwL0FRcDBqeE1scGV1?=
 =?utf-8?B?bUozRmZuZVM0SXVFWFc0dGk4R0daVEk4TlNDNXhrb01QOTVibmFUUER5VHky?=
 =?utf-8?Q?Um87dtK8Mf7IScgzXM2JgAVjDZvwwGCZGJxgmev?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9b8b1ef-0a13-4bc0-4382-08d9263a4552
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2021 02:49:56.1164
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WzmxaYxfJYxYtTB7mGeJ7MPLNBoghi1J2SJVTseaDKY6zmV52s68dXMYecc7Y0gLCaM3EDcHaSC19ARlY0WWlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4930
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPg0KPiBTZW50OiBUaHVyc2Rh
eSwgSnVuZSAzLCAyMDIxIDEyOjU5IEFNDQo+IA0KPiBPbiBXZWQsIEp1biAwMiwgMjAyMSBhdCAw
NDo0ODozNVBNICsxMDAwLCBEYXZpZCBHaWJzb24gd3JvdGU6DQo+ID4gPiA+IAkvKiBCaW5kIGd1
ZXN0IEkvTyBwYWdlIHRhYmxlICAqLw0KPiA+ID4gPiAJYmluZF9kYXRhID0gew0KPiA+ID4gPiAJ
CS5pb2FzaWQJPSBndmFfaW9hc2lkOw0KPiA+ID4gPiAJCS5hZGRyCT0gZ3ZhX3BndGFibGUxOw0K
PiA+ID4gPiAJCS8vIGFuZCBmb3JtYXQgaW5mb3JtYXRpb24NCj4gPiA+ID4gCX07DQo+ID4gPiA+
IAlpb2N0bChpb2FzaWRfZmQsIElPQVNJRF9CSU5EX1BHVEFCTEUsICZiaW5kX2RhdGEpOw0KPiA+
ID4NCj4gPiA+IEFnYWluIEkgZG8gd29uZGVyIGlmIHRoaXMgc2hvdWxkIGp1c3QgYmUgcGFydCBv
ZiBhbGxvY19pb2FzaWQuIElzDQo+ID4gPiB0aGVyZSBhbnkgcmVhc29uIHRvIHNwbGl0IHRoZXNl
IHRoaW5ncz8gVGhlIG9ubHkgYWR2YW50YWdlIHRvIHRoZQ0KPiA+ID4gc3BsaXQgaXMgdGhlIGRl
dmljZSBpcyBrbm93biwgYnV0IHRoZSBkZXZpY2Ugc2hvdWxkbid0IGltcGFjdA0KPiA+ID4gYW55
dGhpbmcuLg0KPiA+DQo+ID4gSSdtIHByZXR0eSBzdXJlIHRoZSBkZXZpY2UocykgY291bGQgbWF0
dGVyLCBhbHRob3VnaCB0aGV5IHByb2JhYmx5DQo+ID4gd29uJ3QgdXN1YWxseS4NCj4gDQo+IEl0
IGlzIGEgYml0IHN1YnRsZSwgYnV0IHRoZSAvZGV2L2lvbW11IGZkIGl0c2VsZiBpcyBjb25uZWN0
ZWQgdG8gdGhlDQo+IGRldmljZXMgZmlyc3QuIFRoaXMgcHJldmVudHMgd2lsZGx5IGluY29tcGF0
aWJsZSBkZXZpY2VzIGZyb20gYmVpbmcNCj4gam9pbmVkIHRvZ2V0aGVyLCBhbmQgYWxsb3dzIHNv
bWUgImdldCBpbmZvIiB0byByZXBvcnQgdGhlIGNhcGFiaWxpdHkNCj4gdW5pb24gb2YgYWxsIGRl
dmljZXMgaWYgd2Ugd2FudCB0byBkbyB0aGF0Lg0KDQpJIHdvdWxkIGV4cGVjdCB0aGUgY2FwYWJp
bGl0eSByZXBvcnRlZCBwZXItZGV2aWNlIHZpYSAvZGV2L2lvbW11LiANCkluY29tcGF0aWJsZSBk
ZXZpY2VzIGNhbiBiaW5kIHRvIHRoZSBzYW1lIGZkIGJ1dCBjYW5ub3QgYXR0YWNoIHRvDQp0aGUg
c2FtZSBJT0FTSUQuIFRoaXMgYWxsb3dzIGluY29tcGF0aWJsZSBkZXZpY2VzIHRvIHNoYXJlIGxv
Y2tlZA0KcGFnZSBhY2NvdW50aW5nLg0KDQo+IA0KPiBUaGUgb3JpZ2luYWwgY29uY2VwdCB3YXMg
dGhhdCBkZXZpY2VzIGpvaW5lZCB3b3VsZCBhbGwgaGF2ZSB0byBzdXBwb3J0DQo+IHRoZSBzYW1l
IElPQVNJRCBmb3JtYXQsIGF0IGxlYXN0IGZvciB0aGUga2VybmVsIG93bmVkIG1hcC91bm1hcCBJ
T0FTSUQNCj4gdHlwZS4gU3VwcG9ydGluZyBkaWZmZXJlbnQgcGFnZSB0YWJsZSBmb3JtYXRzIG1h
eWJlIGlzIHJlYXNvbiB0bw0KPiByZXZpc2l0IHRoYXQgY29uY2VwdC4NCg0KSSBob3BlIG15IG1l
bW9yeSB3YXMgbm90IGJyb2tlbiwgdGhhdCB0aGUgb3JpZ2luYWwgY29uY2VwdCB3YXMgDQp0aGUg
ZGV2aWNlcyBhdHRhY2hlZCB0byB0aGUgc2FtZSBJT0FTSUQgbXVzdCBzdXBwb3J0IHRoZSBzYW1l
DQpmb3JtYXQuIE90aGVyd2lzZSB0aGV5IG5lZWQgYXR0YWNoIHRvIGRpZmZlcmVudCBJT0FTSURz
IChidXQgc3RpbGwNCndpdGhpbiB0aGUgc2FtZSBmZCkuDQoNCj4gDQo+IFRoZXJlIGlzIGEgc21h
bGwgYWR2YW50YWdlIHRvIHJlLXVzaW5nIHRoZSBJT0FTSUQgY29udGFpbmVyIGJlY2F1c2Ugb2YN
Cj4gdGhlIGdldF91c2VyX3BhZ2VzIGNhY2hpbmcgYW5kIHBpbm5lZCBhY2NvdW50aW5nIG1hbmFn
ZW1lbnQgYXQgdGhlIEZEDQo+IGxldmVsLg0KDQpXaXRoIGFib3ZlIGNvbmNlcHQgd2UgZG9uJ3Qg
bmVlZCBJT0FTSUQgY29udGFpbmVyIHRoZW4uDQoNCj4gDQo+IEkgZG9uJ3Qga25vdyBpZiB0aGF0
IHNtYWxsIGFkdmFudGFnZSBpcyB3b3J0aCB0aGUgZXh0cmEgY29tcGxleGl0eQ0KPiB0aG91Z2gu
DQo+IA0KPiA+IEJ1dCBpdCB3b3VsZCBjZXJ0YWlubHkgYmUgcG9zc2libGUgZm9yIGEgc3lzdGVt
IHRvIGhhdmUgdHdvDQo+ID4gZGlmZmVyZW50IGhvc3QgYnJpZGdlcyB3aXRoIHR3byBkaWZmZXJl
bnQgSU9NTVVzIHdpdGggZGlmZmVyZW50DQo+ID4gcGFnZXRhYmxlIGZvcm1hdHMuICBVbnRpbCB5
b3Uga25vdyB3aGljaCBkZXZpY2VzIChhbmQgdGhlcmVmb3JlDQo+ID4gd2hpY2ggaG9zdCBicmlk
Z2UpIHlvdSdyZSB0YWxraW5nIGFib3V0LCB5b3UgZG9uJ3Qga25vdyB3aGF0IGZvcm1hdHMNCj4g
PiBvZiBwYWdldGFibGUgdG8gYWNjZXB0LiAgQW5kIGlmIHlvdSBoYXZlIGRldmljZXMgZnJvbSAq
Ym90aCogYnJpZGdlcw0KPiA+IHlvdSBjYW4ndCBiaW5kIGEgcGFnZSB0YWJsZSBhdCBhbGwgLSB5
b3UgY291bGQgdGhlb3JldGljYWxseSBzdXBwb3J0DQo+ID4gYSBrZXJuZWwgbWFuYWdlZCBwYWdl
dGFibGUgYnkgbWlycm9yaW5nIGVhY2ggTUFQIGFuZCBVTk1BUCB0byB0YWJsZXMNCj4gPiBpbiBi
b3RoIGZvcm1hdHMsIGJ1dCBpdCB3b3VsZCBiZSBwcmV0dHkgcmVhc29uYWJsZSBub3QgdG8gc3Vw
cG9ydA0KPiA+IHRoYXQuDQo+IA0KPiBUaGUgYmFzaWMgcHJvY2VzcyBmb3IgYSB1c2VyIHNwYWNl
IG93bmVkIHBndGFibGUgbW9kZSB3b3VsZCBiZToNCj4gDQo+ICAxKSBxZW11IGhhcyB0byBmaWd1
cmUgb3V0IHdoYXQgZm9ybWF0IG9mIHBndGFibGUgdG8gdXNlDQo+IA0KPiAgICAgUHJlc3VtYWJs
eSBpdCB1c2VzIHF1ZXJ5IGZ1bmN0aW9ucyB1c2luZyB0aGUgZGV2aWNlIGxhYmVsLiBUaGUNCj4g
ICAgIGtlcm5lbCBjb2RlIHNob3VsZCBsb29rIGF0IHRoZSBlbnRpcmUgZGV2aWNlIHBhdGggdGhy
b3VnaCBhbGwgdGhlDQo+ICAgICBJT01NVSBIVyB0byBkZXRlcm1pbmUgd2hhdCBpcyBwb3NzaWJs
ZS4NCj4gDQo+ICAgICBPciBpdCBhbHJlYWR5IGtub3dzIGJlY2F1c2UgdGhlIFZNJ3MgdklPTU1V
IGlzIHJ1bm5pbmcgaW4gc29tZQ0KPiAgICAgZml4ZWQgcGFnZSB0YWJsZSBmb3JtYXQsIG9yIHRo
ZSBWTSdzIHZJT01NVSBhbHJlYWR5IHRvbGQgaXQsIG9yDQo+ICAgICBzb21ldGhpbmcuDQoNCkkn
ZCBleHBlY3QgdGhlIGJvdGguIEZpcnN0IGdldCB0aGUgaGFyZHdhcmUgZm9ybWF0LiBUaGVuIGRl
dGVjdCB3aGV0aGVyDQppdCdzIGNvbXBhdGlibGUgdG8gdGhlIHZJT01NVSBmb3JtYXQuDQoNCj4g
DQo+ICAyKSBxZW11IGNyZWF0ZXMgYW4gSU9BU0lEIGFuZCBiYXNlZCBvbiAjMSBhbmQgc2F5cyAn
SSB3YW50IHRoaXMgZm9ybWF0Jw0KDQpCYXNlZCBvbiBlYXJsaWVyIGRpc2N1c3Npb24gdGhpcyB3
aWxsIHBvc3NpYmx5IGJlOg0KDQpzdHJ1Y3QgaW9tbXVfaW9hc2lkX2NyZWF0ZV9pbmZvIHsNCg0K
Ly8gaWYgc2V0IHRoaXMgaXMgYSBndWVzdC1tYW5hZ2VkIHBhZ2UgdGFibGUsIHVzZSBiaW5kK2lu
dmFsaWRhdGUsIHdpdGgNCi8vIGluZm8gcHJvdmlkZWQgaW4gc3RydWN0IHBndGFibGVfaW5mbzsN
Ci8vIGlmIGNsZWFyIGl0J3MgaG9zdC1tYW5hZ2VkIGFuZCB1c2UgbWFwK3VubWFwOw0KI2RlZmlu
ZSBJT01NVV9JT0FTSURfRkxBR19VU0VSX1BHVEFCTEUJCTENCg0KLy8gaWYgc2V0IGl0IGlzIGZv
ciBwYXNpZCB0YWJsZSBiaW5kaW5nLiBzYW1lIGltcGxpY2F0aW9uIGFzIFVTRVJfUEdUQUJMRQ0K
Ly8gZXhjZXB0IGl0J3MgZm9yIGEgZGlmZmVyZW50IHBndGFibGUgdHlwZQ0KI2RlZmluZSBJT01N
VV9JT0FTSURfRkxBR19VU0VSX1BBU0lEX1RBQkxFCTINCglpbnQJCWZsYWdzOw0KDQoJLy8gQ3Jl
YXRlIG5lc3RpbmcgaWYgbm90IElOVkFMSURfSU9BU0lEDQoJdTMyCQlwYXJlbnRfaW9hc2lkOw0K
DQoJLy8gYWRkaXRpb25hbCBpbmZvIGFib3V0IHRoZSBwYWdlIHRhYmxlDQoJdW5pb24gew0KCQkv
LyBmb3IgdXNlci1tYW5hZ2VkIHBhZ2UgdGFibGUNCgkJc3RydWN0IHsNCgkJCXU2NAl1c2VyX3Bn
ZDsNCgkJCXUzMglmb3JtYXQ7DQoJCQl1MzIJYWRkcl93aWR0aDsNCgkJCS8vIGFuZCBvdGhlciB2
ZW5kb3IgZm9ybWF0IGluZm8NCgkJfSBwZ3RhYmxlX2luZm87DQoNCgkJLy8gZm9yIGtlcm5lbC1t
YW5hZ2VkIHBhZ2UgdGFibGUNCgkJc3RydWN0IHsNCgkJCS8vIG5vdCByZXF1aXJlZCBvbiB4ODYN
CgkJCS8vIGZvciBwcGMsIGlpcmMgdGhlIHVzZXIgd2FudHMgdG8gY2xhaW0gYSB3aW5kb3cNCgkJ
CS8vIGV4cGxpY2l0bHk/DQoJCX0gbWFwX2luZm87DQoJfTsNCn07DQoNCnRoZW4gdGhlcmUgd2ls
bCBiZSBubyBVTkJJTkRfUEdUQUJMRSBpb2N0bC4gVGhlIHVuYmluZCBpcyBkb25lIA0KYXV0b21h
dGljYWxseSB3aGVuIHRoZSBJT0FTSUQgaXMgZnJlZWQuDQoNCj4gDQo+ICAzKSBxZW11IGJpbmRz
IHRoZSBJT0FTSUQgdG8gdGhlIGRldmljZS4NCg0KbGV0J3MgdXNlICdhdHRhY2gnIGZvciBjb25z
aXN0ZW5jeS4g8J+YiiAnYmluZCcgaXMgZm9yIGlvYXNpZCBmZCB3aGljaCBtdXN0DQpiZSBjb21w
bGV0ZWQgaW4gc3RlcCAwKSBzbyBmb3JtYXQgY2FuIGJlIHJlcG9ydGVkIGluIHN0ZXAgMSkNCg0K
PiANCj4gICAgIElmIHFtZXUgZ2V0cyBpdCB3cm9uZyB0aGVuIGl0IGp1c3QgZmFpbHMuDQo+IA0K
PiAgNCkgRm9yIHRoZSBuZXh0IGRldmljZSBxZW11IHdvdWxkIGhhdmUgdG8gZmlndXJlIG91dCBp
ZiBpdCBjYW4gcmUtdXNlDQo+ICAgICBhbiBleGlzdGluZyBJT0FTSUQgYmFzZWQgb24gdGhlIHJl
cXVpcmVkIHByb2VwcnRpZXMuDQo+IA0KPiBZb3UgcG9pbnRlZCB0byB0aGUgY2FzZSBvZiBtaXhp
bmcgdklPTU1VJ3Mgb2YgZGlmZmVyZW50IHBsYXRmb3Jtcy4gU28NCj4gaXQgaXMgY29tcGxldGVs
eSByZWFzb25hYmxlIGZvciBxZW11IHRvIGFzayBmb3IgYSAiQVJNIDY0IGJpdCBJT01NVQ0KPiBw
YWdlIHRhYmxlIG1vZGUgdjIiIHdoaWxlIHJ1bm5pbmcgb24gYW4geDg2IGJlY2F1c2UgdGhhdCBp
cyB3aGF0IHRoZQ0KPiB2SU9NTVUgaXMgd2lyZWQgdG8gd29yayB3aXRoLg0KPiANCj4gUHJlc3Vt
YWJseSBxZW11IHdpbGwgZmFsbCBiYWNrIHRvIHNvZnR3YXJlIGVtdWxhdGlvbiBpZiB0aGlzIGlz
IG5vdA0KPiBwb3NzaWJsZS4NCj4gDQo+IE9uZSBpbnRlcmVzdGluZyBvcHRpb24gZm9yIHNvZnR3
YXJlIGVtdWxhdGlvbiBpcyB0byBqdXN0IHRyYW5zZm9ybSB0aGUNCj4gQVJNIHBhZ2UgdGFibGUg
Zm9ybWF0IHRvIGEgeDg2IHBhZ2UgdGFibGUgZm9ybWF0IGluIHVzZXJzcGFjZSBhbmQgdXNlDQo+
IG5lc3RlZCBiaW5kL2ludmFsaWRhdGUgdG8gc3luY2hyb25pemUgd2l0aCB0aGUga2VybmVsLiBX
aXRoIFNXIG5lc3RpbmcNCj4gSSBzdXNwZWN0IHRoaXMgd291bGQgYmUgbXVjaCBmYXN0ZXINCj4g
DQoNCm9yIGp1c3QgdXNlIG1hcCt1bm1hcC4gSXQncyBubyBkaWZmZXJlbmNlIGZyb20gaG93IGFu
IHZpcnRpby1pb21tdSBjb3VsZA0Kd29yayBvbiBhbGwgcGxhdGZvcm1zLCB3aGljaCBpcyBieSBk
ZWZpbml0aW9uIGlzIG5vdCB0aGUgc2FtZSB0eXBlIGFzIHRoZQ0KdW5kZXJseWluZyBoYXJkd2Fy
ZS4NCg0KVGhhbmtzDQpLZXZpbg0K
