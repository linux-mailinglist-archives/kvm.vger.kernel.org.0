Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 180E946E13D
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 04:21:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbhLIDZI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 22:25:08 -0500
Received: from mga07.intel.com ([134.134.136.100]:12304 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229601AbhLIDZH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Dec 2021 22:25:07 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10192"; a="301389773"
X-IronPort-AV: E=Sophos;i="5.88,191,1635231600"; 
   d="scan'208";a="301389773"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2021 19:21:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,191,1635231600"; 
   d="scan'208";a="516095365"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga008.jf.intel.com with ESMTP; 08 Dec 2021 19:21:34 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 8 Dec 2021 19:21:33 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Wed, 8 Dec 2021 19:21:33 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Wed, 8 Dec 2021 19:21:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZCZzMtR0oiOq/UL9xInaBQgmt2rM0aUZebE2GM/hdzpYrFWjxJvKq38et5VPJPilibsFkuYcGG4vQ6KD9bXT2xcDbUi4vu7QlCn3tx/Y35ErOojMd4wnG+Pz/y+c69Bcdmz1Uyoxh7h7StvXbR7n6VkPZ2JbfjBQhjP9QBnVSuljiaqRsej5ywLUfGvSQv+o1VwZ6J/50XnpcSCXc20QDvIt06Ebg0zwrstcDk0zHXCPKfL0Y5PzVU9/TgyxhwD3DcjWoHyGeo/QYeixCe2zFfRFNvKtDJUBWKuoBoNpGh2O0WmPH4s52odv/CysyTBZDUfQAsm6e0/jC1cyMwwYNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0k6h+rQ/7WLqYwvuNG0Hf40VI0eS2t8nAUnBSPhPx6k=;
 b=Fx6yWjcK2nNG2NbR4xkBn8nPIQ9nz4QwL565aCADMeSNhm/IRdHHnd4YIAg7GDLPf8m7RAtjutgCMJ6zNMG+fN2LQTsS0sfjWDmydmjzXIRgzQLG++rohSNxrdijTCsrfzWkUdVTshpwwwmz3MrNoskgEjtpssu58i7JT+YPc2XcUYgcYoE8RAEjoj8HjxBrzxShn9tFKrhcvYmzZljh8F6ufmHN3N6ANOYZnTgEFi76haSqtRuJOtU0k5LhbidYjfcB57twj9djn1HcUkrCsy8YFH/9rgqjT3PuCX+LYRUSyOKlZ0QJydDdsIxsnH9ynBs67jpRZY0NVMXddAs18Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0k6h+rQ/7WLqYwvuNG0Hf40VI0eS2t8nAUnBSPhPx6k=;
 b=W8vr2d1TXR3SxR7t5J53bJvWp+Y0J92ECWNDmNqgkIwJbht8ZgxC/0052M59ozSEsjuBNrpVpGVnAd82iLKOFY6H/kye993a1KdKBjjRC2X+ESbRjFsQs4vcyQeX+fm5CCsGhAd8Se2hd7xitLsiK7BmhnDaCBpuiHVksQ1ABik=
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN6PR11MB1748.namprd11.prod.outlook.com (2603:10b6:404:101::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.12; Thu, 9 Dec
 2021 03:21:31 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04%2]) with mapi id 15.20.4755.016; Thu, 9 Dec 2021
 03:21:31 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>
CC:     Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "vivek.gautam@arm.com" <vivek.gautam@arm.com>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "vsethi@nvidia.com" <vsethi@nvidia.com>,
        "zhangfei.gao@linaro.org" <zhangfei.gao@linaro.org>,
        "will@kernel.org" <will@kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "wangxingang5@huawei.com" <wangxingang5@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Subject: RE: [RFC v16 1/9] iommu: Introduce attach/detach_pasid_table API
Thread-Topic: [RFC v16 1/9] iommu: Introduce attach/detach_pasid_table API
Thread-Index: AQHXyx+9zoVf6ec36EaoAw6mFm2RjKwlh1WAgAGLFwCAARJNAIAAUNaAgABaKgCAAOuOEA==
Date:   Thu, 9 Dec 2021 03:21:31 +0000
Message-ID: <BN9PR11MB5276E882C5CC5946CA0D4C6A8C709@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20211027104428.1059740-1-eric.auger@redhat.com>
 <20211027104428.1059740-2-eric.auger@redhat.com>
 <Ya3qd6mT/DpceSm8@8bytes.org>
 <c7e26722-f78c-a93f-c425-63413aa33dde@redhat.com>
 <e6733c59-ffcb-74d4-af26-273c1ae8ce68@linux.intel.com>
 <fbeabcff-a6d4-dcc5-6687-7b32d6358fe3@redhat.com>
 <20211208125616.GN6385@nvidia.com>
In-Reply-To: <20211208125616.GN6385@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3bd3d624-2522-4285-d1e9-08d9bac2ff49
x-ms-traffictypediagnostic: BN6PR11MB1748:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BN6PR11MB1748174AA1F08082FB009CE18C709@BN6PR11MB1748.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NSTjwSUynXxEVFzB+MpMes4m0NSAmmu5TGklk+liL/6TsRL6AWkvsXiszyz6Y2H+wovr95jkpuydQ2rCjj6JvHKyZnIGVr8rW7PZlkaGunTjEW18fAt1nQXFOqQcsJT3qNED9U6hT9UtRfwgWhsjQfrY2gSePcXK0CSHXd7b+T8RgG28kRhfV2G1DSY3CEdRkfZWmKVP2W6JvKHIzo/xvKDOCj0Xwnetm2B5iKTsxy8jzWagqJsj0ExRf1j2C97KPKh9ShlSuLAr/DSwDqcHdslFFH7CwNOUtHIveUqo3pVTFli8dfavGu+nic6mDaOKAoY/H3UBc2AW4rF7vbssl1sxu4SCV/m7E4TuFo1sSD5opvMCx1spangaXMhLTsTnt6BPE/d1F3rnwvGfXKMkzcDfPUHTS4nJCxdJgJb6dGeJS6WHUTtMnQ8vcAAuty7OQmE0R3d1bZuVHvFFHCnEvUoTCc9XXn5UH6xjQT5nbc7YbEwRzauL8CPWffUkWGHg5JsiIBQzY2EFs9gfm32JF6qNMu5BM/rM1C8JiqBs/k5DbdvCZmnOD9BUv+dovR2Scs8huTa0PZCc8syKLYlBBb+y5AKIedYjm0JpE1vrkiUZy/GKf8PaEZvZHMqOrDLmN4YYch0VeIpT9crSRcP+sR0lUYzgQjBD4Fr59uZqSdaKVWhm00UOX1swsaNxKEzlAwZLjFTc6nWj3Eibx49LqmmfvmSmqtjcMdZ9PyxNKo2Pe7+uvH0AKdjfKa5d5nuSo0uy88SHkbjkDhq57HXyFN6LSXtC2R0qqE9R2vJFswy3yjrG6iuqqkETT9NFH/1XyUo2GGKoAISsX+zNC9pcTQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(71200400001)(76116006)(966005)(508600001)(9686003)(2906002)(8676002)(316002)(8936002)(5660300002)(4326008)(66476007)(66556008)(64756008)(38100700002)(33656002)(66446008)(66946007)(54906003)(7416002)(122000001)(52536014)(7696005)(86362001)(6506007)(53546011)(26005)(110136005)(38070700005)(55016003)(83380400001)(186003)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eWtmcm05U1FIdGxVQmNNbTB1SllIVHRQZ09LV21XeUxrZ1hxZWErQnBkTG0r?=
 =?utf-8?B?STVpRTc2Vm12OGlrU1R1Y3NHN0MvRmpZRGxHMTRwYURtNmJ3NDMwTW0vRFVU?=
 =?utf-8?B?WHlHUDYzd2JCWllXQ2IvdXlwL2JteEMyaXdQM3ZGeXYvRnJoTXV0emxEdnI4?=
 =?utf-8?B?aEcwRlNFaFlrNEozS2Ztb1ZZd1BYSmNEeG5STk5pd3RoSGxYYWpOMUQ3aUVo?=
 =?utf-8?B?a2xzcmlnSCtBUFZyK2d5elpjTWdUNFRQRjFpY0xYVUp4ZHJpYUFHYy9oRURP?=
 =?utf-8?B?QXB1dlRYOXA5ZjN2T2FsUlBsclgyVk5PaysyNEJOcHdvaTBxNnprYThQQS9j?=
 =?utf-8?B?Y3puZHp5Umo4b21nNVdmb0RGTnNwd0E5c2wwcDRZZExRL2xjWmVlTkgrdXc5?=
 =?utf-8?B?VTAwUmdyYUVwMW1XMzhRTWJHeEx6YzJmaU1YWkZ6L1MvdG9qUW1FSEVTb01V?=
 =?utf-8?B?Q3dUZ3BpNWlWdXVBUnY5MGRMaEJCSElPSXZSTkNucHg1ZWtQRFczSGNxWEpJ?=
 =?utf-8?B?QnpaQ1RDSGdVRVZJNTFvVzRiS0Q0VjFWMVBZQlVoNXRUd1hJdFdySkFrTmk0?=
 =?utf-8?B?OE03MEdjVnRhNC83NjhRYTdjeEhZM08wOFFMRW80MnBieUhLa29FNldRVEVY?=
 =?utf-8?B?SUVZWEZpdEZjZmJ4RnNLc0tLY0Zmd0RQWndZa3pnd2JnUVczWThLVlZxbW1L?=
 =?utf-8?B?WEhLajFUczFYMXoxT2hKazNPeTA0K1lDd3k5eDdHZGlRb2NhUVpqRkVoTmQ0?=
 =?utf-8?B?UGlCaHRVcmJVbDNyZnkxa1V4MW5Ock1nVlJkc0NiRWFOK3h1LzVGSDc0cGN5?=
 =?utf-8?B?MUZRSlZMMjltak9FdzJGbzFhWnBPc2NnM0FLM2d5YlpOa1N3ZnJkaHJzWFBD?=
 =?utf-8?B?aVo3ajh4VVd5dEx3d0hpeEVYZG90MFNqWXk0bFFhc3VBM0ZweDZPSUttdmFa?=
 =?utf-8?B?T2xPa1UzNTRuUVE4QjVxVmdZQ2cvR1ZkQ2VDbGhzeTUzVHlHbG5XenRGNFFR?=
 =?utf-8?B?OTU0S3IwK1FRREFtdnZCdjBoOU56d0tmMEREYm4wOVZQL0ozS0wrUGM2R2hx?=
 =?utf-8?B?OE9wUVdBaEprbTNvVFRnQlRUaWl6MUR4Vk15NDNRamc4SWI1NUJ4bFQ5Tmla?=
 =?utf-8?B?Qk03UWZsRG44MXB3OVlOVmR5WHllZStBUVIra1hvazV5VVNTTlZ3QkIxY0lv?=
 =?utf-8?B?RWk3ZlllYTBMMG80VHdraVM0VWNTa3ZxRzlkZTUzSW5MOS9PbGxnbC9hemVM?=
 =?utf-8?B?OE1KQ2JvSkVWZytLRSsrbFB3QzE4U1hibGRwWVZRbmNacGRXSXRCa3NrbnNa?=
 =?utf-8?B?Y2lYWUd0SGJ3TFRsVEpFVVRFa3FGR2FWdzJ2dEtmNURIYW1ueEpBSmI2NjZJ?=
 =?utf-8?B?V0h0ZHArV1U5dDRWRVhBVFJJL3VJUWNySUV4MkJVeUhjRGZKcDFpNWRCaHQ5?=
 =?utf-8?B?ZDd1dks4YmtITVh0eVNKRXV1QllWSjdsZCs0M0tNeERmYkhsdGhjR3lFdVJ2?=
 =?utf-8?B?Rk1SeDV4aWR6TExGM0lzVDd5S2d4SVNaVXlBMTMwUms2U1dkQVp1ZzV1a1Np?=
 =?utf-8?B?VUZVQzRkQlJTeGVJTkYxTW1LVTUvSGpIaTlqazcveGZFZHRiODNYeGNldVB4?=
 =?utf-8?B?RjduNGYzSmVhcWF4YnR4SDI3cW9FMUNwUFJkeCs3TjVDVXk1Y25jT2swbk1L?=
 =?utf-8?B?LytuTExXdEM1dVEyM3h1bXlKUURwYXpOMWZUNlJPM3lZbXdmdURKZE01cFox?=
 =?utf-8?B?bFk4K3N0TTM1YTBsbXhqWTJURllsbkMyNmxRTjYwT1pBZjE3WUJHWVlBR1I5?=
 =?utf-8?B?ZUs2Z3QrczZzQ3dFUERkWVRkS2hMY3JUVE1XeVMyU1pPZ2tmd3FyU2RxTkNn?=
 =?utf-8?B?VTR3OHZuZzh5eVNNZjVIUE9ZODdxNXpGTjVqekFsSm5tZVllbEhvT3IydGc5?=
 =?utf-8?B?eVpKdjU3RzYwNi9Bam9CSzN0UHIvdnpVcEFYRHJHQjhVNlBnNC9TaDQ4QWhS?=
 =?utf-8?B?Z0dzaTZpSktjN0xja0VGYTZsVUdlQWNyVi94UUgrL3dNZUZpOUpqQ2NKVzht?=
 =?utf-8?B?TFhtUndTTDVtcUVFMCsxUGhGb3gzOWpJM2NmVmM2Z1kxWSt1bHNOWlg5TW1O?=
 =?utf-8?B?WnA0c3Rrb2U4bDM4SjYvNG5QUktSTHdtRTdkZU4yV2Q1YTNyTndqek9KTWxs?=
 =?utf-8?Q?RFTxINkqZM+MFddk7xsguBg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bd3d624-2522-4285-d1e9-08d9bac2ff49
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2021 03:21:31.7990
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: k82rFtDFd3e6tn+sk7tIARuTiO2PDMfqAnbWPXhW1inRm/O9vp9Ie1vzJ2o7fKsxAnXlv0TWXt18G/+f/5sJDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1748
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPg0KPiBTZW50OiBXZWRuZXNk
YXksIERlY2VtYmVyIDgsIDIwMjEgODo1NiBQTQ0KPiANCj4gT24gV2VkLCBEZWMgMDgsIDIwMjEg
YXQgMDg6MzM6MzNBTSArMDEwMCwgRXJpYyBBdWdlciB3cm90ZToNCj4gPiBIaSBCYW9sdSwNCj4g
Pg0KPiA+IE9uIDEyLzgvMjEgMzo0NCBBTSwgTHUgQmFvbHUgd3JvdGU6DQo+ID4gPiBIaSBFcmlj
LA0KPiA+ID4NCj4gPiA+IE9uIDEyLzcvMjEgNjoyMiBQTSwgRXJpYyBBdWdlciB3cm90ZToNCj4g
PiA+PiBPbiAxMi82LzIxIDExOjQ4IEFNLCBKb2VyZyBSb2VkZWwgd3JvdGU6DQo+ID4gPj4+IE9u
IFdlZCwgT2N0IDI3LCAyMDIxIGF0IDEyOjQ0OjIwUE0gKzAyMDAsIEVyaWMgQXVnZXIgd3JvdGU6
DQo+ID4gPj4+PiBTaWduZWQtb2ZmLWJ5OiBKZWFuLVBoaWxpcHBlIEJydWNrZXI8amVhbi1waGls
aXBwZS5icnVja2VyQGFybS5jb20+DQo+ID4gPj4+PiBTaWduZWQtb2ZmLWJ5OiBMaXUsIFlpIEw8
eWkubC5saXVAbGludXguaW50ZWwuY29tPg0KPiA+ID4+Pj4gU2lnbmVkLW9mZi1ieTogQXNob2sg
UmFqPGFzaG9rLnJhakBpbnRlbC5jb20+DQo+ID4gPj4+PiBTaWduZWQtb2ZmLWJ5OiBKYWNvYiBQ
YW48amFjb2IuanVuLnBhbkBsaW51eC5pbnRlbC5jb20+DQo+ID4gPj4+PiBTaWduZWQtb2ZmLWJ5
OiBFcmljIEF1Z2VyPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT4NCj4gPiA+Pj4gVGhpcyBTaWduZWQt
b2YtYnkgY2hhaW4gbG9va3MgZHViaW91cywgeW91IGFyZSB0aGUgYXV0aG9yIGJ1dCB0aGUgbGFz
dA0KPiA+ID4+PiBvbmUgaW4gdGhlIGNoYWluPw0KPiA+ID4+IFRoZSAxc3QgUkZDIGluIEF1ZyAy
MDE4DQo+ID4gPj4gKGh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L3BpcGVybWFpbC9rdm1h
cm0vMjAxOC0NCj4gQXVndXN0LzAzMjQ3OC5odG1sKQ0KPiA+ID4+IHNhaWQgdGhpcyB3YXMgYSBn
ZW5lcmFsaXphdGlvbiBvZiBKYWNvYidzIHBhdGNoDQo+ID4gPj4NCj4gPiA+Pg0KPiA+ID4+IMKg
wqAgW1BBVENIIHY1IDAxLzIzXSBpb21tdTogaW50cm9kdWNlIGJpbmRfcGFzaWRfdGFibGUgQVBJ
IGZ1bmN0aW9uDQo+ID4gPj4NCj4gPiA+Pg0KPiA+ID4+DQo+ID4gPj4gaHR0cHM6Ly9saXN0cy5s
aW51eGZvdW5kYXRpb24ub3JnL3BpcGVybWFpbC9pb21tdS8yMDE4LQ0KPiBNYXkvMDI3NjQ3Lmh0
bWwNCj4gPiA+Pg0KPiA+ID4+IFNvIGluZGVlZCBKYWNvYiBzaG91bGQgYmUgdGhlIGF1dGhvci4g
SSBndWVzcyB0aGUgbXVsdGlwbGUgcmViYXNlcyBnb3QNCj4gPiA+PiB0aGlzIGV2ZW50dWFsbHkg
cmVwbGFjZWQgYXQgc29tZSBwb2ludCwgd2hpY2ggaXMgbm90IGFuIGV4Y3VzZS4gUGxlYXNlDQo+
ID4gPj4gZm9yZ2l2ZSBtZSBmb3IgdGhhdC4NCj4gPiA+PiBOb3cgdGhlIG9yaWdpbmFsIHBhdGNo
IGFscmVhZHkgaGFkIHRoaXMgbGlzdCBvZiBTb0Igc28gSSBkb24ndCBrbm93IGlmIEkNCj4gPiA+
PiBzaGFsbCBzaW1wbGlmeSBpdC4NCj4gPiA+DQo+ID4gPiBBcyB3ZSBoYXZlIGRlY2lkZWQgdG8g
bW92ZSB0aGUgbmVzdGVkIG1vZGUgKGR1YWwgc3RhZ2VzKQ0KPiBpbXBsZW1lbnRhdGlvbg0KPiA+
ID4gb250byB0aGUgZGV2ZWxvcGluZyBpb21tdWZkIGZyYW1ld29yaywgd2hhdCdzIHRoZSB2YWx1
ZSBvZiBhZGRpbmcgdGhpcw0KPiA+ID4gaW50byBpb21tdSBjb3JlPw0KPiA+DQo+ID4gVGhlIGlv
bW11X3VhcGlfYXR0YWNoX3Bhc2lkX3RhYmxlIHVhcGkgc2hvdWxkIGRpc2FwcGVhciBpbmRlZWQg
YXMgaXQgaXMNCj4gPiBpcyBib3VuZCB0byBiZSByZXBsYWNlZCBieSAvZGV2L2lvbW11IGZlbGxv
dyBBUEkuDQo+ID4gSG93ZXZlciB1bnRpbCBJIGNhbiByZWJhc2Ugb24gL2Rldi9pb21tdSBjb2Rl
IEkgYW0gb2JsaWdlZCB0byBrZWVwIGl0IHRvDQo+ID4gbWFpbnRhaW4gdGhpcyBpbnRlZ3JhdGlv
biwgaGVuY2UgdGhlIFJGQy4NCj4gDQo+IEluZGVlZCwgd2UgYXJlIGdldHRpbmcgcHJldHR5IGNs
b3NlIHRvIGhhdmluZyB0aGUgYmFzZSBpb21tdWZkIHRoYXQgd2UNCj4gY2FuIHN0YXJ0IGFkZGlu
ZyBzdHVmZiBsaWtlIHRoaXMgaW50by4gTWF5YmUgaW4gSmFudWFyeSwgeW91IGNhbiBsb29rDQo+
IGF0IHNvbWUgcGFydHMgb2Ygd2hhdCBpcyBldm9sdmluZyBoZXJlOg0KPiANCj4gaHR0cHM6Ly9n
aXRodWIuY29tL2pndW50aG9ycGUvbGludXgvY29tbWl0cy9pb21tdWZkDQo+IGh0dHBzOi8vZ2l0
aHViLmNvbS9MdUJhb2x1L2ludGVsLWlvbW11L2NvbW1pdHMvaW9tbXUtZG1hLW93bmVyc2hpcC0N
Cj4gdjINCj4gaHR0cHM6Ly9naXRodWIuY29tL2x1eGlzMTk5OS9pb21tdWZkL2NvbW1pdHMvaW9t
bXVmZC12NS4xNi1yYzINCj4gDQo+IEZyb20gYSBwcm9ncmVzcyBwZXJzcGVjdGl2ZSBJIHdvdWxk
IGxpa2UgdG8gc3RhcnQgd2l0aCBzaW1wbGUgJ3BhZ2UNCj4gdGFibGVzIGluIHVzZXJzcGFjZScs
IGllIG5vIFBBU0lEIGluIHRoaXMgc3RlcC4NCj4gDQo+ICdwYWdlIHRhYmxlcyBpbiB1c2Vyc3Bh
Y2UnIG1lYW5zIGFuIGlvbW11ZmQgaW9jdGwgdG8gY3JlYXRlIGFuDQo+IGlvbW11X2RvbWFpbiB3
aGVyZSB0aGUgSU9NTVUgSFcgaXMgZGlyZWN0bHkgdHJhdmVzZXJpbmcgYQ0KPiBkZXZpY2Utc3Bl
Y2lmaWMgcGFnZSB0YWJsZSBzdHJ1Y3R1cmUgaW4gdXNlciBzcGFjZSBtZW1vcnkuIEFsbCB0aGUg
SFcNCj4gdG9kYXkgaW1wbGVtZW50cyB0aGlzIGJ5IHVzaW5nIGFub3RoZXIgaW9tbXVfZG9tYWlu
IHRvIGFsbG93IHRoZSBJT01NVQ0KPiBIVyBETUEgYWNjZXNzIHRvIHVzZXIgbWVtb3J5IC0gaWUg
bmVzdGluZyBvciBtdWx0aS1zdGFnZSBvciB3aGF0ZXZlci4NCg0KT25lIGNsYXJpZmljYXRpb24g
aGVyZSBpbiBjYXNlIHBlb3BsZSBtYXkgZ2V0IGNvbmZ1c2VkIGJhc2VkIG9uIHRoZQ0KY3VycmVu
dCBpb21tdV9kb21haW4gZGVmaW5pdGlvbi4gSmFzb24gYnJhaW5zdG9ybWVkIHdpdGggdXMgb24g
aG93DQp0byByZXByZXNlbnQgJ3VzZXIgcGFnZSB0YWJsZScgaW4gdGhlIElPTU1VIHN1Yi1zeXN0
ZW0uIE9uZSBpcyB0bw0KZXh0ZW5kIGlvbW11X2RvbWFpbiBhcyBhIGdlbmVyYWwgcmVwcmVzZW50
YXRpb24gZm9yIGFueSBwYWdlIHRhYmxlDQppbnN0YW5jZS4gVGhlIG90aGVyIG9wdGlvbiBpcyB0
byBjcmVhdGUgbmV3IHJlcHJlc2VudGF0aW9ucyBmb3IgdXNlcg0KcGFnZSB0YWJsZXMgYW5kIHRo
ZW4gbGluayB0aGVtIHVuZGVyIGV4aXN0aW5nIGlvbW11X2RvbWFpbi4NCg0KVGhpcyBjb250ZXh0
IGlzIGJhc2VkIG9uIHRoZSAxc3Qgb3B0aW9uLiBhbmQgQXMgSmFzb24gc2FpZCBpbiB0aGUgYm90
dG9tDQp3ZSBzdGlsbCBuZWVkIHRvIHNrZXRjaCBvdXQgd2hldGhlciBpdCB3b3JrcyBhcyBleHBl
Y3RlZC4g8J+Yig0KDQo+IA0KPiBUaGlzIHdvdWxkIGNvbWUgYWxvbmcgd2l0aCBzb21lIGlvY3Rs
cyB0byBpbnZhbGlkYXRlIHRoZSBJT1RMQi4NCj4gDQo+IEknbSBpbWFnaW5pbmcgdGhpcyBzdGVw
IGFzIGEgaW9tbXVfZ3JvdXAtPm9wLT5jcmVhdGVfdXNlcl9kb21haW4oKQ0KPiBkcml2ZXIgY2Fs
bGJhY2sgd2hpY2ggd2lsbCBjcmVhdGUgYSBuZXcga2luZCBvZiBkb21haW4gd2l0aA0KPiBkb21h
aW4tdW5pcXVlIG9wcy4gSWUgbWFwL3VubWFwIHJlbGF0ZWQgc2hvdWxkIGFsbCBiZSBOVUxMIGFz
IHRob3NlDQo+IGFyZSBpbXBvc3NpYmxlIG9wZXJhdGlvbnMuDQo+IA0KPiBGcm9tIHRoZXJlIHRo
ZSB1c3VhbCBzdHJ1Y3QgZGV2aWNlIChpZSBSSUQpIGF0dGFjaC9kZXRhdGNoIHN0dWZmIG5lZWRz
DQo+IHRvIHRha2UgY2FyZSBvZiByb3V0aW5nIERNQXMgdG8gdGhpcyBpb21tdV9kb21haW4uDQoN
ClVzYWdlLXdpc2UgdGhpcyBjb3ZlcnMgdGhlIGd1ZXN0IElPVkEgcmVxdWlyZW1lbnRzIGkuZS4g
d2hlbiB0aGUgZ3Vlc3QNCmtlcm5lbCBlbmFibGVzIHZJT01NVSBmb3Iga2VybmVsIERNQS1BUEkg
bWFwcGluZ3Mgb3IgZm9yIGRldmljZQ0KYXNzaWdubWVudCB0byBndWVzdCB1c2Vyc3BhY2UuDQoN
CkZvciBpbnRlbCB0aGlzIG1lYW5zIG9wdGltaXphdGlvbiB0byB0aGUgZXhpc3Rpbmcgc2hhZG93
LWJhc2VkIHZJT01NVQ0KaW1wbGVtZW50YXRpb24uDQoNCkZvciBBUk0gdGhpcyBhY3R1YWxseSBl
bmFibGVzIGd1ZXN0IElPVkEgdXNhZ2UgZm9yIHRoZSBmaXJzdCB0aW1lIChjb3JyZWN0DQptZSBF
cmljPykuIElJUkMgU01NVSBkb2Vzbid0IHN1cHBvcnQgY2FjaGluZyBtb2RlIHdoaWxlIHdyaXRl
LXByb3RlY3RpbmcNCmd1ZXN0IEkvTyBwYWdlIHRhYmxlIHdhcyBjb25zaWRlcmVkIGEgbm8tZ28u
IFNvIG5lc3RpbmcgaXMgY29uc2lkZXJlZCBhcw0KdGhlIG9ubHkgb3B0aW9uIHRvIHN1cHBvcnQg
dGhhdC4NCg0KYW5kIG9uY2UgJ3VzZXIgcGFzaWQgdGFibGUnIGlzIGluc3RhbGxlZCwgdGhpcyBh
Y3R1YWxseSBtZWFucyBndWVzdCBTVkEgdXNhZ2UNCmNhbiBhbHNvIHBhcnRpYWxseSB3b3JrIGZv
ciBBUk0gaWYgSS9PIHBhZ2UgZmF1bHQgaXMgbm90IGluY3VycmVkLg0KDQo+IA0KPiBTdGVwIHR3
byB3b3VsZCBiZSB0byBhZGQgdGhlIGFiaWxpdHkgZm9yIGFuIGlvbW11ZmQgdXNpbmcgZHJpdmVy
IHRvDQo+IHJlcXVlc3QgdGhhdCBhIFJJRCZQQVNJRCBpcyBjb25uZWN0ZWQgdG8gYW4gaW9tbXVf
ZG9tYWluLiBUaGlzDQo+IGNvbm5lY3Rpb24gY2FuIGJlIHJlcXVlc3RlZCBmb3IgYW55IGtpbmQg
b2YgaW9tbXVfZG9tYWluLCBrZXJuZWwgb3duZWQNCj4gb3IgdXNlciBvd25lZC4NCj4gDQo+IEkg
ZG9uJ3QgcXVpdGUgaGF2ZSBhbiBhbnN3ZXIgaG93IGV4YWN0bHkgdGhlIFNNTVV2MyB2cyBJbnRl
bA0KPiBkaWZmZXJlbmNlIGluIFBBU0lEIHJvdXRpbmcgc2hvdWxkIGJlIHJlc29sdmVkLg0KDQpG
b3Iga2VybmVsIG93bmVkIHRoZSBpb21tdWZkIGludGVyZmFjZSBzaG91bGQgYmUgZ2VuZXJpYyBh
cyB0aGUNCnZlbmRvciBkaWZmZXJlbmNlIGlzIG1hbmFnZWQgYnkgdGhlIGtlcm5lbCBpdHNlbGYu
DQoNCkZvciB1c2VyIG93bmVkIHdlJ2xsIG5lZWQgbmV3IHVBUElzIGZvciB1c2VyIHRvIHNwZWNp
ZnkgUEFTSUQuIA0KQXMgSSByZXBsaWVkIGluIGFub3RoZXIgdGhyZWFkIG9ubHkgSW50ZWwgY3Vy
cmVudGx5IHJlcXVpcmVzIGl0IGR1ZSB0bw0KbWRldi4gQnV0IG90aGVyIHZlbmRvcnMgY291bGQg
YWxzbyBkbyBzbyB3aGVuIHRoZXkgZGVjaWRlIHRvIA0Kc3VwcG9ydCBtZGV2IG9uZSBkYXkuDQoN
Cj4gDQo+IHRvIGdldCBhbnN3ZXJzIEknbSBob3BpbmcgdG8gc3RhcnQgYnVpbGRpbmcgc29tZSBz
a2V0Y2ggUkZDcyBmb3IgdGhlc2UNCj4gZGlmZmVyZW50IHRoaW5ncyBvbiBpb21tdWZkLCBob3Bl
ZnVsbHkgaW4gSmFudWFyeS4gSSdtIGxvb2tpbmcgYXQgdXNlcg0KPiBwYWdlIHRhYmxlcywgUEFT
SUQsIGRpcnR5IHRyYWNraW5nIGFuZCB1c2Vyc3BhY2UgSU8gZmF1bHQgaGFuZGxpbmcgYXMNCj4g
dGhlIG1haW4gZmVhdHVyZXMgaW9tbXVmZCBtdXN0IHRhY2tsZS4NCg0KTWFrZSBzZW5zZS4NCg0K
PiANCj4gVGhlIHB1cnBvc2Ugb2YgdGhlIHNrZXRjaGVzIHdvdWxkIGJlIHRvIHZhbGlkYXRlIHRo
YXQgdGhlIEhXIGZlYXR1cmVzDQo+IHdlIHdhbnQgdG8gZXhwb3NlZCBjYW4gd29yayB3aWxsIHdp
dGggdGhlIGNob2ljZXMgdGhlIGJhc2UgaXMgbWFraW5nLg0KPiANCj4gSmFzb24NCg0KVGhhbmtz
DQpLZXZpbg0K
