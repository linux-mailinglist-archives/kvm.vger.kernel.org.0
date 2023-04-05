Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EEE36D7EAA
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 16:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238499AbjDEOJH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 10:09:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238402AbjDEOIv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 10:08:51 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 043A510F4;
        Wed,  5 Apr 2023 07:07:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680703670; x=1712239670;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=33Wq+c0t7DoFAti4DW9yNRzpQJ3kGtkbgD484ONF5e4=;
  b=hLXJFgwRckU9/aWG9ZnhZ8OrHjKXEOku/zrfwTKUuNfh2mkhjIz/z+i1
   CzxHE7A+0IGNgvZFU/QkKdOFYX19AgHwFXzBEm4ChCZSvjuIHbhPo42V/
   QwiKo3Zn+m++hSfXc2lOlXSwGp+5H2niuYRzeRuFjM5kFsN0O+7QwdkZk
   UwNZAoCoxWol80+I76r8O7p2pyiLnBhREortjfeyAyWwS2hT7P6odKKfK
   /HN/MJgBHwjNPQr1wuQoHQ7Z+BxiAy0HibYR9HUAa6T+9Hl/VSZQsz2Bc
   Py7LIAKuH5cI3yZG7k7zefdIeZKph4anX5J6UOI3Ojq/JSFGXLsLqW49k
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="407541720"
X-IronPort-AV: E=Sophos;i="5.98,319,1673942400"; 
   d="scan'208";a="407541720"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2023 07:04:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="719335594"
X-IronPort-AV: E=Sophos;i="5.98,319,1673942400"; 
   d="scan'208";a="719335594"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP; 05 Apr 2023 07:04:57 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 5 Apr 2023 07:04:53 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 5 Apr 2023 07:04:53 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.45) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 5 Apr 2023 07:04:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KSpo3bvn1ig/L4CnMdeBl3qNZsH9U34P/cd0O9fHyS0TRngFXuGz3a/sD4q6Ar+Gcr9VyJMNQ6ougNLO5rzT9ODvkl1+23FDYsDy5eRkMpBSEQGXXCXyTAhVzC/+d/CjTxf3McsF73qn5ZwXtEh9L9o7TLCnGB5o8CO2rRkigSZpgJCT/Hm5dMUmnP9tPnaQKAtjmKV/UVUB/aINgI8GyXDzh3oi0zKETMrTcqpJ+Jkb3YyZ8G/BZGqjtcH3QmUiVEerFXYrLPlWt7EeorrnvY7TFqavlAKPJD0r5qNR0lvHamPVmx/HruR8bFp48P+W3Qq1mO8M5bp0bZGda0fV/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=33Wq+c0t7DoFAti4DW9yNRzpQJ3kGtkbgD484ONF5e4=;
 b=AkE4D7xFk/lvLuR4v/1KjijYtzrhFzqpBOceARawoIEipHtPjCKA88N07MpGVVyO1iWNldTbXDoHhs7Q+SKQ9SP8XU45StRwni9DXm6QxtZJUIkVlwDQ78jahSgfNHdINLslMzzCpNmby8bUwOmtG5fNtw9Bh7MpETvue4/17z1P9N78hzvjg2Ywb7FyFbhKmAEJQIsh+wMYO9LkbS6jGOaw3aQwNiDA7Kne4tm+R1KMd5D3wAt8gigIhAqDt+XUqflCLVwcBS3ENsgmjIpQyDruMVinZKg7eT/f650ppIFHm0uuZ5GOTKTYPEWbS6s/4eYe83463NvGW3MgDEUohg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by IA1PR11MB6241.namprd11.prod.outlook.com (2603:10b6:208:3e9::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Wed, 5 Apr
 2023 14:04:51 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de%5]) with mapi id 15.20.6254.035; Wed, 5 Apr 2023
 14:04:51 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>
Subject: RE: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Thread-Topic: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Thread-Index: AQHZZKiCMJJkpNrujkKpjX0h05Zqwa8cqG8AgAAcMGA=
Date:   Wed, 5 Apr 2023 14:04:51 +0000
Message-ID: <DS0PR11MB7529D4E354C3B85D7698017DC3909@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230401144429.88673-1-yi.l.liu@intel.com>
 <20230401144429.88673-13-yi.l.liu@intel.com>
 <a937e622-ce32-6dda-d77c-7d8d76474ee0@redhat.com>
In-Reply-To: <a937e622-ce32-6dda-d77c-7d8d76474ee0@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|IA1PR11MB6241:EE_
x-ms-office365-filtering-correlation-id: 2bf473ce-0716-48db-85cd-08db35deb969
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hhyh/MsdfABevMApPu7VdCo2aGhvqnkEZGSSEyUzKV8gcInMv/V9/XQ1gUl8mejqt6acY86Qck8jUf/6Ixh3mE1WfxndXtKrDXrX7D2+kWUhSOGLeV/POO8OQNO1j5kOnebxE0RtrLkZt4SLrlE7oDhNpmXWQPoqDtbLpLSKohJl6/D9QOsXIXLDVuLEWMFqgYCuf72EADtdk8xvAbJ3sw0hsARYidyHKPCCF3kA/ds7FnF6tSrWeWTN9j29XGy+Sxbe1V8PTw1+XA932ZLIhprzOVLeMMgUuLSMtUYMHGc5jUgvEmHrloRzyHAU8qULzazktNBdPsKHtslyg//IK1UzOWH7SzBZ0m7JwxbzRxDhx5w4FRv7QZFk2evnJVKN5gBsXRQLgNoA21LMPgynBJpoKc+8nU2AoQ3I053mRPLAV9dY5dvZ9I22Ok2Afj+T8I3vMJqqmzldVbygoDD+epOHjQ00bw45jBmdHk5JE7sZ554a2kxasYzFrrsUf5ER9G2Q5Ng4HA1a7jQK4chRlULkZ5E6GNjxp9y6w9tvQVdENqpgmX+c0dAzmWTVW5wqxhSLgHWMnmPfi/LGOlwey87JCQq3es9ig6m0AF9/7mzmJkFtjkWXCOOrtc6mqacLE4uysw7Xs+ZcQ6dA37i7oQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(396003)(376002)(39860400002)(136003)(451199021)(2906002)(38100700002)(86362001)(7416002)(5660300002)(66556008)(66446008)(478600001)(52536014)(66476007)(8936002)(64756008)(76116006)(4326008)(316002)(8676002)(41300700001)(54906003)(186003)(55016003)(71200400001)(6636002)(33656002)(66946007)(110136005)(7696005)(53546011)(26005)(122000001)(83380400001)(6506007)(82960400001)(38070700005)(9686003)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TkhPZ1FjYnQ3NXhRU0NvTjUrVE04NnBGTWYzOFRXaHc5VHdzWGo4SU9yS2ha?=
 =?utf-8?B?OEZ4bDVOMDdIckQxNDJucVZzaDI3ZDlHR081Rmt4THV0cWxsQUNIYXFTTnlq?=
 =?utf-8?B?VkJuNEEyODdaUTFJdnRRQndTd1MySmRqTXp2Rk5tUktyelV1ZkVTYjc0R0U5?=
 =?utf-8?B?ekJGMU1qZTRqeERuTkRhTW91MFhuRjJ2OXhiOUdXaUZzdWRYbFBVZGJoN0I1?=
 =?utf-8?B?ZVRiOERqdXdqMWdXclV3K1EvRm14b3dmalc4UDdEd2lSajNyamdQNmpvekFY?=
 =?utf-8?B?a3R2Sk56dGhNRFNkdE42bkNkM2J0T1pST00yeVpxR3dWczZzeU9UNG96a3Nr?=
 =?utf-8?B?Z3JLdHpzZENaUTlVZHpXMFlpZkUrbmRQUnMzM21KYkNhbkxqZTFNckY2bStk?=
 =?utf-8?B?ZFZ0RjZYY1RkWk43TkxEVjV4WG9CVHpDVTB3WFlBY3N1Z3JFbTBrMWVqcS9w?=
 =?utf-8?B?Vm9qUnhoMG5tWGNOVjdXQThPUy9lU3BuemdKUy9raFdxUFppbWc4N014ZEJD?=
 =?utf-8?B?K01uUHVNWWZYdmE2SlQ3TGExSlVBTWowK3U4d0tnN1QxeUZ0SkE3cEFUbmtv?=
 =?utf-8?B?NkVQaVhiOE9reitLNGUxakwvMUozbEFESEN6QnZFcTNqang1NlVFNGZDWkFC?=
 =?utf-8?B?YUJkNmdGUUxua0xHOGREV0dHMHRtaEhsWVJiV3p2T21FY1ZXcWhGUkpzMDNz?=
 =?utf-8?B?MmVmVUc3ZUZvbmY2TkxsQ3FCMUJXYTN6dmxvTS9vRlRUd3BaQnIvcERhODVO?=
 =?utf-8?B?c2Fob3VnMXRvSEJMeTJiMmZZcUJqdUI3L1RxRytzSjJtaDZSd2N6MlcxMnJ0?=
 =?utf-8?B?ckp6dHhZek1BUGNuM0RDYjN6SmFySE9McVpQUVFMQXVtMFNDOUdQVEc1aFMr?=
 =?utf-8?B?K1dVTURHcE84eS81RFNtV3E5b0VhZlV6aHVybVM0LzZFUUJIRjFkMVZJNmFw?=
 =?utf-8?B?a0ZCK2p0M3J2cXdMYzVrVkN5RG8vZlMybkF6aUtRTXR4aDBldEc0UG1POEtZ?=
 =?utf-8?B?S3dlbnZHZGpxblVseEJ3STY1OXJadTVCa2dmUlRON3NZUnVvVVZOV1ZSL0cr?=
 =?utf-8?B?WExTNjAwNWFXYUJmbkRQd0NhUGcrOUtNcTUrWjJUS0lScnBTdEtBOUNJd2JF?=
 =?utf-8?B?ekRXVGxOTm1rMzZBUWlEaUtBSkllanlDcEkrc1FMVGorLzZ1cis4dDNNZGZz?=
 =?utf-8?B?eFFaSkU0VVdDUUdaZXUweHBTSGxYbHduVDdXbFYrQ3J0MXpWbE1Ic0pETjky?=
 =?utf-8?B?REEzOGJCeTA2OHJtcC9LYXlicUlFQUJQOEdDL21zR3ZzL0tEcVp3TGhUSEZ0?=
 =?utf-8?B?c3ZzMmZCTFBQcFNkckJxdjB3V1FkRFluN0FFdFVVL25qWTJ2Q0gzbldCLzhs?=
 =?utf-8?B?dzRDdmQwNmhvVFg0emE0N3Yra3Z1STNjYU1GUURpdXZqUnViQUo0emJQNVRX?=
 =?utf-8?B?VDJOMHhnYXVHWE5XeWxoVmpSYXZJTkxTRjc3S1FLQWpjenBpdVpUd1RSMXhH?=
 =?utf-8?B?azdZdDJsQlk0alJaVDhTK2hDUkkwUnFXejRZaktYbXQvSzR3Q2JoSmxFQU1r?=
 =?utf-8?B?REVSWDdGU2piQlR4WUZjTjVYcFJ2a1hjSHFKV2pTNy9TdldaK0VmOXF6UDVW?=
 =?utf-8?B?NEd5ek9KWXhmVzFxZGJsSGNZNFQ5Q0NPQnN6MmFteGxFZUlwRlZhL3VrL2dB?=
 =?utf-8?B?ZUluR3NYbi9wYW1YSFM0dTdodDZTMXZxKzYwOC9QOTZJWnorSlZnbGJrT0hQ?=
 =?utf-8?B?ZGoxWVIyMUZCNUhKY1JnbzVsRGxhUXZ2L3lSYTZZZkRRVkNTUjZmL3ZDMEky?=
 =?utf-8?B?SThFV1Z5WmN2RDNiZDFoSGM4ZHlnTDA4VW5ERWt2SVhXK3pCTTI1TzJObllz?=
 =?utf-8?B?ZHo0K3gvR1M2RkFkVllLNUdobDkyNjFQQzBpWVIySnlpMHpQclMyVjl3MkpS?=
 =?utf-8?B?Qzc4b0dtWDJWYnVRZ0xRSWxONFd3WW5ubjhGSzFmVDQ5cW8yS3pLNUpZZDBG?=
 =?utf-8?B?OU5WczBGWjl3NzltanZFQVJxenQvZFZ3MEtYOWdQNzE0WjhnYUxmV2kzVnYz?=
 =?utf-8?B?SWRwclNoS2dZdURCNXRNd0g0NG9BWXhjZFVPcXdaU1oxeTNBc2o4dVdEdUpG?=
 =?utf-8?Q?spIOQoubs105d0aWjKn3OEHMg?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bf473ce-0716-48db-85cd-08db35deb969
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2023 14:04:51.2599
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oS8OheeiY4CyvOVDTWk9ugnlgbpkC1GCcrk/vqX7hoSO+7CL/SZtJ9NY1A25iTfCpeuyLfP/m7EkfQG7vltxSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6241
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgRXJpYywNCg0KPiBGcm9tOiBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+
IFNlbnQ6IFdlZG5lc2RheSwgQXByaWwgNSwgMjAyMyA4OjIwIFBNDQo+IA0KPiBIaSBZaSwNCj4g
T24gNC8xLzIzIDE2OjQ0LCBZaSBMaXUgd3JvdGU6DQo+ID4gZm9yIHRoZSB1c2VycyB0aGF0IGFj
Y2VwdCBkZXZpY2UgZmRzIHBhc3NlZCBmcm9tIG1hbmFnZW1lbnQgc3RhY2tzIHRvIGJlDQo+ID4g
YWJsZSB0byBmaWd1cmUgb3V0IHRoZSBob3N0IHJlc2V0IGFmZmVjdGVkIGRldmljZXMgYW1vbmcg
dGhlIGRldmljZXMNCj4gPiBvcGVuZWQgYnkgdGhlIHVzZXIuIFRoaXMgaXMgbmVlZGVkIGFzIHN1
Y2ggdXNlcnMgZG8gbm90IGhhdmUgQkRGIChidXMsDQo+ID4gZGV2Zm4pIGtub3dsZWRnZSBhYm91
dCB0aGUgZGV2aWNlcyBpdCBoYXMgb3BlbmVkLCBoZW5jZSB1bmFibGUgdG8gdXNlDQo+ID4gdGhl
IGluZm9ybWF0aW9uIHJlcG9ydGVkIGJ5IGV4aXN0aW5nIFZGSU9fREVWSUNFX0dFVF9QQ0lfSE9U
X1JFU0VUX0lORk8NCj4gPiB0byBmaWd1cmUgb3V0IHRoZSBhZmZlY3RlZCBkZXZpY2VzLg0KPiA+
DQo+ID4gU2lnbmVkLW9mZi1ieTogWWkgTGl1IDx5aS5sLmxpdUBpbnRlbC5jb20+DQo+ID4gLS0t
DQo+ID4gIGRyaXZlcnMvdmZpby9wY2kvdmZpb19wY2lfY29yZS5jIHwgNTggKysrKysrKysrKysr
KysrKysrKysrKysrKysrKy0tLS0NCj4gPiAgaW5jbHVkZS91YXBpL2xpbnV4L3ZmaW8uaCAgICAg
ICAgfCAyNCArKysrKysrKysrKystDQo+ID4gIDIgZmlsZXMgY2hhbmdlZCwgNzQgaW5zZXJ0aW9u
cygrKSwgOCBkZWxldGlvbnMoLSkNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3ZmaW8v
cGNpL3ZmaW9fcGNpX2NvcmUuYyBiL2RyaXZlcnMvdmZpby9wY2kvdmZpb19wY2lfY29yZS5jDQo+
ID4gaW5kZXggMTlmNWIwNzVkNzBhLi5hNWE3ZTE0OGRjZTEgMTAwNjQ0DQo+ID4gLS0tIGEvZHJp
dmVycy92ZmlvL3BjaS92ZmlvX3BjaV9jb3JlLmMNCj4gPiArKysgYi9kcml2ZXJzL3ZmaW8vcGNp
L3ZmaW9fcGNpX2NvcmUuYw0KPiA+IEBAIC0zMCw2ICszMCw3IEBADQo+ID4gICNpZiBJU19FTkFC
TEVEKENPTkZJR19FRUgpDQo+ID4gICNpbmNsdWRlIDxhc20vZWVoLmg+DQo+ID4gICNlbmRpZg0K
PiA+ICsjaW5jbHVkZSA8dWFwaS9saW51eC9pb21tdWZkLmg+DQo+ID4NCj4gPiAgI2luY2x1ZGUg
InZmaW9fcGNpX3ByaXYuaCINCj4gPg0KPiA+IEBAIC03NjcsNiArNzY4LDIwIEBAIHN0YXRpYyBp
bnQgdmZpb19wY2lfZ2V0X2lycV9jb3VudChzdHJ1Y3QNCj4gdmZpb19wY2lfY29yZV9kZXZpY2Ug
KnZkZXYsIGludCBpcnFfdHlwDQo+ID4gIAlyZXR1cm4gMDsNCj4gPiAgfQ0KPiA+DQo+ID4gK3N0
YXRpYyBzdHJ1Y3QgdmZpb19kZXZpY2UgKg0KPiA+ICt2ZmlvX3BjaV9maW5kX2RldmljZV9pbl9k
ZXZzZXQoc3RydWN0IHZmaW9fZGV2aWNlX3NldCAqZGV2X3NldCwNCj4gPiArCQkJICAgICAgIHN0
cnVjdCBwY2lfZGV2ICpwZGV2KQ0KPiA+ICt7DQo+ID4gKwlzdHJ1Y3QgdmZpb19kZXZpY2UgKmN1
cjsNCj4gPiArDQo+ID4gKwlsb2NrZGVwX2Fzc2VydF9oZWxkKCZkZXZfc2V0LT5sb2NrKTsNCj4g
PiArDQo+ID4gKwlsaXN0X2Zvcl9lYWNoX2VudHJ5KGN1ciwgJmRldl9zZXQtPmRldmljZV9saXN0
LCBkZXZfc2V0X2xpc3QpDQo+ID4gKwkJaWYgKGN1ci0+ZGV2ID09ICZwZGV2LT5kZXYpDQo+ID4g
KwkJCXJldHVybiBjdXI7DQo+ID4gKwlyZXR1cm4gTlVMTDsNCj4gPiArfQ0KPiA+ICsNCj4gPiAg
c3RhdGljIGludCB2ZmlvX3BjaV9jb3VudF9kZXZzKHN0cnVjdCBwY2lfZGV2ICpwZGV2LCB2b2lk
ICpkYXRhKQ0KPiA+ICB7DQo+ID4gIAkoKihpbnQgKilkYXRhKSsrOw0KPiA+IEBAIC03NzYsMTMg
Kzc5MSwyMCBAQCBzdGF0aWMgaW50IHZmaW9fcGNpX2NvdW50X2RldnMoc3RydWN0IHBjaV9kZXYg
KnBkZXYsIHZvaWQNCj4gKmRhdGEpDQo+ID4gIHN0cnVjdCB2ZmlvX3BjaV9maWxsX2luZm8gew0K
PiA+ICAJaW50IG1heDsNCj4gPiAgCWludCBjdXI7DQo+ID4gKwlib29sIHJlcXVpcmVfZGV2aWQ7
DQo+ID4gKwlzdHJ1Y3QgaW9tbXVmZF9jdHggKmlvbW11ZmQ7DQo+ID4gKwlzdHJ1Y3QgdmZpb19k
ZXZpY2Vfc2V0ICpkZXZfc2V0Ow0KPiA+ICAJc3RydWN0IHZmaW9fcGNpX2RlcGVuZGVudF9kZXZp
Y2UgKmRldmljZXM7DQo+ID4gIH07DQo+ID4NCj4gPiAgc3RhdGljIGludCB2ZmlvX3BjaV9maWxs
X2RldnMoc3RydWN0IHBjaV9kZXYgKnBkZXYsIHZvaWQgKmRhdGEpDQo+ID4gIHsNCj4gPiAgCXN0
cnVjdCB2ZmlvX3BjaV9maWxsX2luZm8gKmZpbGwgPSBkYXRhOw0KPiA+ICsJc3RydWN0IHZmaW9f
ZGV2aWNlX3NldCAqZGV2X3NldCA9IGZpbGwtPmRldl9zZXQ7DQo+ID4gIAlzdHJ1Y3QgaW9tbXVf
Z3JvdXAgKmlvbW11X2dyb3VwOw0KPiA+ICsJc3RydWN0IHZmaW9fZGV2aWNlICp2ZGV2Ow0KPiA+
ICsNCj4gPiArCWxvY2tkZXBfYXNzZXJ0X2hlbGQoJmRldl9zZXQtPmxvY2spOw0KPiA+DQo+ID4g
IAlpZiAoZmlsbC0+Y3VyID09IGZpbGwtPm1heCkNCj4gPiAgCQlyZXR1cm4gLUVBR0FJTjsgLyog
U29tZXRoaW5nIGNoYW5nZWQsIHRyeSBhZ2FpbiAqLw0KPiA+IEBAIC03OTEsNyArODEzLDIxIEBA
IHN0YXRpYyBpbnQgdmZpb19wY2lfZmlsbF9kZXZzKHN0cnVjdCBwY2lfZGV2ICpwZGV2LCB2b2lk
DQo+ICpkYXRhKQ0KPiA+ICAJaWYgKCFpb21tdV9ncm91cCkNCj4gPiAgCQlyZXR1cm4gLUVQRVJN
OyAvKiBDYW5ub3QgcmVzZXQgbm9uLWlzb2xhdGVkIGRldmljZXMgKi8NCj4gPg0KPiA+IC0JZmls
bC0+ZGV2aWNlc1tmaWxsLT5jdXJdLmdyb3VwX2lkID0gaW9tbXVfZ3JvdXBfaWQoaW9tbXVfZ3Jv
dXApOw0KPiA+ICsJaWYgKGZpbGwtPnJlcXVpcmVfZGV2aWQpIHsNCj4gPiArCQkvKg0KPiA+ICsJ
CSAqIFJlcG9ydCBkZXZfaWQgb2YgdGhlIGRldmljZXMgdGhhdCBhcmUgb3BlbmVkIGFzIGNkZXYN
Cj4gPiArCQkgKiBhbmQgaGF2ZSB0aGUgc2FtZSBpb21tdWZkIHdpdGggdGhlIGZpbGwtPmlvbW11
ZmQuDQo+ID4gKwkJICogT3RoZXJ3aXNlLCBqdXN0IGZpbGwgSU9NTVVGRF9JTlZBTElEX0lELg0K
PiA+ICsJCSAqLw0KPiA+ICsJCXZkZXYgPSB2ZmlvX3BjaV9maW5kX2RldmljZV9pbl9kZXZzZXQo
ZGV2X3NldCwgcGRldik7DQo+ID4gKwkJaWYgKHZkZXYgJiYgdmZpb19kZXZpY2VfY2Rldl9vcGVu
ZWQodmRldikgJiYNCj4gPiArCQkgICAgZmlsbC0+aW9tbXVmZCA9PSB2ZmlvX2lvbW11ZmRfcGh5
c2ljYWxfaWN0eCh2ZGV2KSkNCj4gPiArCQkJdmZpb19pb21tdWZkX3BoeXNpY2FsX2RldmlkKHZk
ZXYsICZmaWxsLT5kZXZpY2VzW2ZpbGwtDQo+ID5jdXJdLmRldl9pZCk7DQo+ID4gKwkJZWxzZQ0K
PiA+ICsJCQlmaWxsLT5kZXZpY2VzW2ZpbGwtPmN1cl0uZGV2X2lkID0gSU9NTVVGRF9JTlZBTElE
X0lEOw0KPiA+ICsJfSBlbHNlIHsNCj4gPiArCQlmaWxsLT5kZXZpY2VzW2ZpbGwtPmN1cl0uZ3Jv
dXBfaWQgPSBpb21tdV9ncm91cF9pZChpb21tdV9ncm91cCk7DQo+ID4gKwl9DQo+ID4gIAlmaWxs
LT5kZXZpY2VzW2ZpbGwtPmN1cl0uc2VnbWVudCA9IHBjaV9kb21haW5fbnIocGRldi0+YnVzKTsN
Cj4gPiAgCWZpbGwtPmRldmljZXNbZmlsbC0+Y3VyXS5idXMgPSBwZGV2LT5idXMtPm51bWJlcjsN
Cj4gPiAgCWZpbGwtPmRldmljZXNbZmlsbC0+Y3VyXS5kZXZmbiA9IHBkZXYtPmRldmZuOw0KPiA+
IEBAIC0xMjMwLDE3ICsxMjY2LDI3IEBAIHN0YXRpYyBpbnQgdmZpb19wY2lfaW9jdGxfZ2V0X3Bj
aV9ob3RfcmVzZXRfaW5mbygNCj4gPiAgCQlyZXR1cm4gLUVOT01FTTsNCj4gPg0KPiA+ICAJZmls
bC5kZXZpY2VzID0gZGV2aWNlczsNCj4gPiArCWZpbGwuZGV2X3NldCA9IHZkZXYtPnZkZXYuZGV2
X3NldDsNCj4gPg0KPiA+ICsJbXV0ZXhfbG9jaygmdmRldi0+dmRldi5kZXZfc2V0LT5sb2NrKTsN
Cj4gPiArCWlmICh2ZmlvX2RldmljZV9jZGV2X29wZW5lZCgmdmRldi0+dmRldikpIHsNCj4gPiAr
CQlmaWxsLnJlcXVpcmVfZGV2aWQgPSB0cnVlOw0KPiA+ICsJCWZpbGwuaW9tbXVmZCA9IHZmaW9f
aW9tbXVmZF9waHlzaWNhbF9pY3R4KCZ2ZGV2LT52ZGV2KTsNCj4gPiArCX0NCj4gPiAgCXJldCA9
IHZmaW9fcGNpX2Zvcl9lYWNoX3Nsb3Rfb3JfYnVzKHZkZXYtPnBkZXYsIHZmaW9fcGNpX2ZpbGxf
ZGV2cywNCj4gPiAgCQkJCQkgICAgJmZpbGwsIHNsb3QpOw0KPiA+ICsJbXV0ZXhfdW5sb2NrKCZ2
ZGV2LT52ZGV2LmRldl9zZXQtPmxvY2spOw0KPiA+DQo+ID4gIAkvKg0KPiA+ICAJICogSWYgYSBk
ZXZpY2Ugd2FzIHJlbW92ZWQgYmV0d2VlbiBjb3VudGluZyBhbmQgZmlsbGluZywgd2UgbWF5IGNv
bWUgdXANCj4gPiAgCSAqIHNob3J0IG9mIGZpbGwubWF4LiAgSWYgYSBkZXZpY2Ugd2FzIGFkZGVk
LCB3ZSdsbCBoYXZlIGEgcmV0dXJuIG9mDQo+ID4gIAkgKiAtRUFHQUlOIGFib3ZlLg0KPiA+ICAJ
ICovDQo+ID4gLQlpZiAoIXJldCkNCj4gPiArCWlmICghcmV0KSB7DQo+ID4gIAkJaGRyLmNvdW50
ID0gZmlsbC5jdXI7DQo+ID4gKwkJaWYgKGZpbGwucmVxdWlyZV9kZXZpZCkNCj4gPiArCQkJaGRy
LmZsYWdzID0gVkZJT19QQ0lfSE9UX1JFU0VUX0ZMQUdfSU9NTVVGRF9ERVZfSUQ7DQo+ID4gKwl9
DQo+ID4NCj4gPiAgcmVzZXRfaW5mb19leGl0Og0KPiA+ICAJaWYgKGNvcHlfdG9fdXNlcihhcmcs
ICZoZHIsIG1pbnN6KSkNCj4gPiBAQCAtMjM0NiwxMiArMjM5MiwxMCBAQCBzdGF0aWMgYm9vbCB2
ZmlvX2Rldl9pbl9maWxlcyhzdHJ1Y3QNCj4gdmZpb19wY2lfY29yZV9kZXZpY2UgKnZkZXYsDQo+
ID4gIHN0YXRpYyBpbnQgdmZpb19wY2lfaXNfZGV2aWNlX2luX3NldChzdHJ1Y3QgcGNpX2RldiAq
cGRldiwgdm9pZCAqZGF0YSkNCj4gPiAgew0KPiA+ICAJc3RydWN0IHZmaW9fZGV2aWNlX3NldCAq
ZGV2X3NldCA9IGRhdGE7DQo+ID4gLQlzdHJ1Y3QgdmZpb19kZXZpY2UgKmN1cjsNCj4gPg0KPiA+
IC0JbGlzdF9mb3JfZWFjaF9lbnRyeShjdXIsICZkZXZfc2V0LT5kZXZpY2VfbGlzdCwgZGV2X3Nl
dF9saXN0KQ0KPiA+IC0JCWlmIChjdXItPmRldiA9PSAmcGRldi0+ZGV2KQ0KPiA+IC0JCQlyZXR1
cm4gMDsNCj4gPiAtCXJldHVybiAtRUJVU1k7DQo+ID4gKwlsb2NrZGVwX2Fzc2VydF9oZWxkKCZk
ZXZfc2V0LT5sb2NrKTsNCj4gPiArDQo+ID4gKwlyZXR1cm4gdmZpb19wY2lfZmluZF9kZXZpY2Vf
aW5fZGV2c2V0KGRldl9zZXQsIHBkZXYpID8gMCA6IC1FQlVTWTsNCj4gPiAgfQ0KPiA+DQo+ID4g
IC8qDQo+ID4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvdWFwaS9saW51eC92ZmlvLmggYi9pbmNsdWRl
L3VhcGkvbGludXgvdmZpby5oDQo+ID4gaW5kZXggMjU0MzJlZjIxM2VlLi41YTM0MzY0ZTNiOTQg
MTAwNjQ0DQo+ID4gLS0tIGEvaW5jbHVkZS91YXBpL2xpbnV4L3ZmaW8uaA0KPiA+ICsrKyBiL2lu
Y2x1ZGUvdWFwaS9saW51eC92ZmlvLmgNCj4gPiBAQCAtNjUwLDExICs2NTAsMzIgQEAgZW51bSB7
DQo+ID4gICAqIFZGSU9fREVWSUNFX0dFVF9QQ0lfSE9UX1JFU0VUX0lORk8gLSBfSU9XUihWRklP
X1RZUEUsIFZGSU9fQkFTRSArIDEyLA0KPiA+ICAgKgkJCQkJICAgICAgc3RydWN0IHZmaW9fcGNp
X2hvdF9yZXNldF9pbmZvKQ0KPiA+ICAgKg0KPiA+ICsgKiBUaGlzIGNvbW1hbmQgaXMgdXNlZCB0
byBxdWVyeSB0aGUgYWZmZWN0ZWQgZGV2aWNlcyBpbiB0aGUgaG90IHJlc2V0IGZvcg0KPiA+ICsg
KiBhIGdpdmVuIGRldmljZS4gIFVzZXIgY291bGQgdXNlIHRoZSBpbmZvcm1hdGlvbiByZXBvcnRl
ZCBieSB0aGlzIGNvbW1hbmQNCj4gPiArICogdG8gZmlndXJlIG91dCB0aGUgYWZmZWN0ZWQgZGV2
aWNlcyBhbW9uZyB0aGUgZGV2aWNlcyBpdCBoYXMgb3BlbmVkLg0KPiA+ICsgKiBUaGlzIGNvbW1h
bmQgYWx3YXlzIHJlcG9ydHMgdGhlIHNlZ21lbnQsIGJ1cyBhbmQgZGV2Zm4gaW5mb3JtYXRpb24g
Zm9yDQo+ID4gKyAqIGVhY2ggYWZmZWN0ZWQgZGV2aWNlLCBhbmQgc2VsZWN0aXZlbHkgcmVwb3J0
IHRoZSBncm91cF9pZCBvciB0aGUgZGV2X2lkDQo+ID4gKyAqIHBlciB0aGUgd2F5IGhvdyB0aGUg
ZGV2aWNlIGJlaW5nIHF1ZXJpZWQgaXMgb3BlbmVkLg0KPiA+ICsgKgktIElmIHRoZSBkZXZpY2Ug
aXMgb3BlbmVkIHZpYSB0aGUgdHJhZGl0aW9uYWwgZ3JvdXAvY29udGFpbmVyIG1hbm5lciwNCj4g
PiArICoJICB0aGlzIGNvbW1hbmQgcmVwb3J0cyB0aGUgZ3JvdXBfaWQgZm9yIGVhY2ggYWZmZWN0
ZWQgZGV2aWNlLg0KPiA+ICsgKg0KPiA+ICsgKgktIElmIHRoZSBkZXZpY2UgaXMgb3BlbmVkIGFz
IGEgY2RldiwgdGhpcyBjb21tYW5kIG5lZWRzIHRvIHJlcG9ydA0KPiBzL25lZWRzIHRvIHJlcG9y
dC9yZXBvcnRzDQoNCmdvdCBpdC4NCg0KPiA+ICsgKgkgIGRldl9pZCBmb3IgZWFjaCBhZmZlY3Rl
ZCBkZXZpY2UgYW5kIHNldCB0aGUNCj4gPiArICoJICBWRklPX1BDSV9IT1RfUkVTRVRfRkxBR19J
T01NVUZEX0RFVl9JRCBmbGFnLiAgRm9yIHRoZSBhZmZlY3RlZA0KPiA+ICsgKgkgIGRldmljZXMg
dGhhdCBhcmUgbm90IG9wZW5lZCBhcyBjZGV2IG9yIGJvdW5kIHRvIGRpZmZlcmVudCBpb21tdWZk
cw0KPiA+ICsgKgkgIHdpdGggdGhlIGRldmljZSB0aGF0IGlzIHF1ZXJpZWQsIHJlcG9ydCBhbiBp
bnZhbGlkIGRldl9pZCB0byBhdm9pZA0KPiBzL2JvdW5kIHRvIGRpZmZlcmVudCBpb21tdWZkcyB3
aXRoIHRoZSBkZXZpY2UgdGhhdCBpcyBxdWVyaWVkL2JvdW5kIHRvDQo+IGlvbW11ZmRzIGRpZmZl
cmVudCBmcm9tIHRoZSByZXNldCBkZXZpY2Ugb25lPw0KDQpobW1tLCBJJ20gbm90IGEgbmF0aXZl
IHNwZWFrZXIgaGVyZS4gVGhpcyBfSU5GTyBpcyB0byBxdWVyeSBpZiB3YW50DQpob3QgcmVzZXQg
YSBnaXZlbiBkZXZpY2UsIHdoYXQgZGV2aWNlcyB3b3VsZCBiZSBhZmZlY3RlZC4gU28gaXQgYXBw
ZWFycw0KdGhlIHF1ZXJpZWQgZGV2aWNlIGlzIGJldHRlci4gQnV0IEknZCBhZG1pdCAidGhlIHF1
ZXJpZWQgZGV2aWNlIiBpcyBhbHNvDQoidGhlIHJlc2V0IGRldmljZSIuIG1heSBBbGV4IGhlbHAg
cGljayBvbmUuIPCfmIoNCg0KUmVnYXJkcywNCllpIExpdQ0KDQo+ID4gKyAqCSAgcG90ZW50aWFs
IGRldl9pZCBjb25mbGljdCBhcyBkZXZfaWQgaXMgbG9jYWwgdG8gaW9tbXVmZC4gIEZvciBzdWNo
DQo+ID4gKyAqCSAgYWZmZWN0ZWQgZGV2aWNlcywgdXNlciBzaGFsbCBmYWxsIGJhY2sgdG8gdXNl
IHRoZSBzZWdtZW50LCBidXMgYW5kDQo+ID4gKyAqCSAgZGV2Zm4gaW5mbyB0byBtYXAgaXQgdG8g
b3BlbmVkIGRldmljZS4NCj4gPiArICoNCj4gPiAgICogUmV0dXJuOiAwIG9uIHN1Y2Nlc3MsIC1l
cnJubyBvbiBmYWlsdXJlOg0KPiA+ICAgKgktZW5vc3BjID0gaW5zdWZmaWNpZW50IGJ1ZmZlciwg
LWVub2RldiA9IHVuc3VwcG9ydGVkIGZvciBkZXZpY2UuDQo+ID4gICAqLw0KPiA+ICBzdHJ1Y3Qg
dmZpb19wY2lfZGVwZW5kZW50X2RldmljZSB7DQo+ID4gLQlfX3UzMglncm91cF9pZDsNCj4gPiAr
CXVuaW9uIHsNCj4gPiArCQlfX3UzMiAgIGdyb3VwX2lkOw0KPiA+ICsJCV9fdTMyCWRldl9pZDsN
Cj4gPiArCX07DQo+ID4gIAlfX3UxNglzZWdtZW50Ow0KPiA+ICAJX191OAlidXM7DQo+ID4gIAlf
X3U4CWRldmZuOyAvKiBVc2UgUENJX1NMT1QvUENJX0ZVTkMgKi8NCj4gPiBAQCAtNjYzLDYgKzY4
NCw3IEBAIHN0cnVjdCB2ZmlvX3BjaV9kZXBlbmRlbnRfZGV2aWNlIHsNCj4gPiAgc3RydWN0IHZm
aW9fcGNpX2hvdF9yZXNldF9pbmZvIHsNCj4gPiAgCV9fdTMyCWFyZ3N6Ow0KPiA+ICAJX191MzIJ
ZmxhZ3M7DQo+ID4gKyNkZWZpbmUgVkZJT19QQ0lfSE9UX1JFU0VUX0ZMQUdfSU9NTVVGRF9ERVZf
SUQJKDEgPDwgMCkNCj4gPiAgCV9fdTMyCWNvdW50Ow0KPiA+ICAJc3RydWN0IHZmaW9fcGNpX2Rl
cGVuZGVudF9kZXZpY2UJZGV2aWNlc1tdOw0KPiA+ICB9Ow0KPiBFcmljDQoNCg==
