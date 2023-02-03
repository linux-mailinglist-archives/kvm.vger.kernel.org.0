Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44E90689C23
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 15:48:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233373AbjBCOse (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 09:48:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231663AbjBCOsc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 09:48:32 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01BC0AD27;
        Fri,  3 Feb 2023 06:48:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675435711; x=1706971711;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3ZXfW3OZ9rOl30CkxCVAbG0KUPE0+HfzveRINET94sI=;
  b=Qdnc6FB+76CEt7/qZ07s4qEW0Ldd9WuYW6Q45REq4AZ15AeVG8PqVaNx
   0Yw3XTO+UQ3Zyd8kylow3KchFpWHpVZlaNwsiilDCRI4tsS4pfe510qXt
   Ix8oHOJ5WgCiwquIn/J6GK8T8lg1+j8BJhavSOLgskobz0/H2Sd8wCWG5
   SBzXlFKRdF/ob87PqawDeMW6GZKal0inYxDVL//ljQQWpx5ApZbJhncQ1
   +7Xn1FgLYkzlk8voV4nHp/2Ef2QXQuIRxHNtmkVBn398gfw2sdNMsqnh9
   fFb3jIKO02fM+avVVJ2Ze9WR7lhXKCVt9UzrdZd85nrsQpsCXZfpzVdOk
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10610"; a="326459099"
X-IronPort-AV: E=Sophos;i="5.97,270,1669104000"; 
   d="scan'208";a="326459099"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2023 06:48:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10610"; a="729284308"
X-IronPort-AV: E=Sophos;i="5.97,270,1669104000"; 
   d="scan'208";a="729284308"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga008.fm.intel.com with ESMTP; 03 Feb 2023 06:48:31 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 3 Feb 2023 06:48:30 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 3 Feb 2023 06:48:30 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.46) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 3 Feb 2023 06:48:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gYj9mCSrRDxq3Fwqh0jQ0j2lSqF587KkjI6y9O336U4ttziUzTKvZV4Nqq4hGWQs+1qFFruG1v15CtaVJ1k+nl0GE23NLMq6rGJasHMPYlnJvOC737H5i0BhGEW9tcSuUTPfxvHOX1K967cgTmOqw1mMp03x738cVwKBLb1+vS8Wu+iKQs4NYvKLws0N9NbMMYLXd0bDGJhmIEVJFDIHiOK8VkCDN0Ym8tXtXGRJ/OuqSb2YHw4zp8goHbQSIL+pABdRaf1HGIQmmHfnaNPRSuJ34A1xswS9BSvQaYkGV/JXrUeMNs1BFRrw67Yn6qcPsRUOPZpC1T05k+ymRbjmeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3ZXfW3OZ9rOl30CkxCVAbG0KUPE0+HfzveRINET94sI=;
 b=C5l2rb+zO2EhLeUFg1orZdEGE5uWKHAmkvLBtIoZogV9YZ9BRIBPyZBdiMMiweHTk4g5xzE1Wb0aoi/nMGD9HHKCIslV4FoYpb1AWG4q37tGV4TgiKDuVwfbBwv83qoe3B9UMVwyHue9ibln68WqASDSwBAO4GtoFPG3cfZKjEY4MTlsFVTf0ma+f2ZBTh/9xTRYK/8l/r5TJH2nfTvQKNw8CpkXiYFVLnQ96kL/EsSYDdqCQcPCfSshiiUkswSDModZydtdbwN8g3+FMBCIxXaTmbPMJ4CqULyc9fBjrDeCJtHNnLQJWx015IbYCb0JohsEKSMhf9JpFh7PbDB3Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CY8PR11MB6867.namprd11.prod.outlook.com (2603:10b6:930:5d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.31; Fri, 3 Feb
 2023 14:48:26 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3%4]) with mapi id 15.20.6064.024; Fri, 3 Feb 2023
 14:48:26 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "cohuck@redhat.com" <cohuck@redhat.com>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "pmorel@linux.ibm.com" <pmorel@linux.ibm.com>,
        "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
        "frankja@linux.ibm.com" <frankja@linux.ibm.com>,
        "imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>,
        "david@redhat.com" <david@redhat.com>,
        "akrowiak@linux.ibm.com" <akrowiak@linux.ibm.com>,
        "jjherne@linux.ibm.com" <jjherne@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3] vfio: fix deadlock between group lock and kvm lock
Thread-Topic: [PATCH v3] vfio: fix deadlock between group lock and kvm lock
Thread-Index: AQHZNyMjAB7EXHsi0Ue5s99XWjtHT6687BlAgABckoCAAAYT4A==
Date:   Fri, 3 Feb 2023 14:48:26 +0000
Message-ID: <DS0PR11MB75294E12D65903C07AAD8F92C3D79@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230202162442.78216-1-mjrosato@linux.ibm.com>
 <DS0PR11MB75295F851A74ACE7CAFB0ACCC3D79@DS0PR11MB7529.namprd11.prod.outlook.com>
 <d322c7d4-9643-a0f4-1575-0cf4c3eb2bc8@linux.ibm.com>
In-Reply-To: <d322c7d4-9643-a0f4-1575-0cf4c3eb2bc8@linux.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|CY8PR11MB6867:EE_
x-ms-office365-filtering-correlation-id: efdd87fa-335c-41e4-4a7d-08db05f5b4f2
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: h9TOQ5ny+Xp4jYus25mg2zfBlQ97yhEmTj4A0FRNoWktzj7DWZjaMpMfdN7//a5Hkajv+T9U0vjDI0XwOQDqGYoXkOpBcS2O8BPKjbMcQwnxeooP0pdHg96o1UnndDprZxgVSJQX5WcL3VRezk1Z8O1yLw/PqfNHuJFKirpSCW05CQrxf40FgXPWf30A5WMWszGKk3Rgfa/kl3SozyFCfSbZ5Zb498CsVqTucqDLlfYa1Qu8XeroA7gG0qVEeAfw/ynxh7lOu7DOJ2S4elnTyj5MI+DyAWhICCdhNBE19mzaONZrSM899cmXm9okl6uNZ21+n0jUVhBjKvWOa6sr8yrMM6tAliMkJBb7ueogQZL1TQdCNzWcqua3bl5p5c/iCwIiDuGUFOj27kpkRSC9wigZGIaNKqZQzD+ilXezKxF6IvK/Vv2SI8jFoSyMP55VrjXGCQCHgSPcQHouBRmZ4pWlTFmNcXknV2LUdMzi3CZqmtErMW1zPxSbNiz1+WO2ReQCCDsGL9P3D+v9auEoVewPadcyy+CMlbHje1ET1p+nhAEQHvyjd5vCPCyZjU6oWM5/nYNsQpDR8biCwf20gk9HrZx74FoHjoSbhvEh1y9/NISERA42qktuj20u9qWWewWBo4qIy6hxNoPKK9pMsp1GqwDzW2m9L4+E4zB7jmH/uaCFpvJyjZ5hrYe81n0A09cNfli9WvI66cZw1qH+8TNcPTgb2oiwDMervKObZTo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(376002)(396003)(366004)(39860400002)(346002)(451199018)(33656002)(82960400001)(86362001)(122000001)(38100700002)(478600001)(53546011)(6506007)(83380400001)(9686003)(186003)(26005)(38070700005)(54906003)(110136005)(2906002)(8676002)(76116006)(66476007)(5660300002)(4326008)(316002)(66946007)(66556008)(66446008)(7696005)(71200400001)(64756008)(7416002)(41300700001)(8936002)(52536014)(55016003)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K0lVbHJQZFQ3ZzVkeFhsRHNjR05YZlo5K2RPRll2U21Dakp3L1BKNlNmN2xt?=
 =?utf-8?B?VmlyUURzeCtkY2dJRldReGovRmdabldNNWVvZEZNaXozYktHRTJNdXdHREhY?=
 =?utf-8?B?cEU3bHk4aXFQQ3dRR1BhY1l1NXhRTEZ6Q3Z5Z1hkUVJDbVZ6b1ZRdXZNQzVh?=
 =?utf-8?B?aW9nWU80eVoyalpJT1ZIMHlDVno2akNnamVnRjVkcXVDaU1ZMzFWV2o2VXFm?=
 =?utf-8?B?UkFHTzVqV3ptTzVwbGxDRktMbWZUdDFmdlQ2b0xoVDIvamp4WS9wN29XVFcw?=
 =?utf-8?B?eHFXcmRPc29vMWZQUmo4N3FBRzQvQUx0bnBOU0t6UUo0d01EQ0xUT21vMloy?=
 =?utf-8?B?QitXcDJCeXFnbGdMcGpMY1dIR0E3WnFCaGhjNmxPT0xlRVM3dlRBOVJzbDRw?=
 =?utf-8?B?RmZaWjJFM2RMQXFrdytRUk5Jck1WS0Z4ZlJld0JHcWVUUHY5V3BIMm9sQjA5?=
 =?utf-8?B?Z2pRTGhCUEhwWFNZT2VwdHQ3bmxuQVFLUURKWXE1SmxnUGI1U2xPbm5TSkJ4?=
 =?utf-8?B?VVJXN2FhTEF5YzBjdHB3WDNLUUE0MnJZQjFvZEwrNXE0NEcwZkh4eWxiMzA2?=
 =?utf-8?B?R1Z5NVRiWXliRzRodGJ5TjFaODJ0NTV4OEJMOXJNTzg0V2pMbG1OVW9Id0Iz?=
 =?utf-8?B?di9OUm9Vd0F3dGxoLzQ1N0FjOEpKYmhZZ0M5WDhWcS9hN2pXbTNyZ0hLd3dY?=
 =?utf-8?B?dzNGSHZzMzh6ZW4wSnRhcnNKTEZZYlFlRS9qTTFuNlNTdFdiS2k5QWVzaWVG?=
 =?utf-8?B?ZjlOcWZCVmFuUkVsUDRBaUZGMXRWUExNVUlaZmh5bDZuaXdNYmtPN0poc095?=
 =?utf-8?B?UFVYNGNkTVc5NzFyWGpSU0lqL3cvNE9jb2FaSjBDUmpaTzZlQWlTa1ZnNHVR?=
 =?utf-8?B?RGowOEw0MmNwMCtkd2pkQ1ExaWgvaG5YM0RWeFc4TnNGTnJXQnBodE9HY21w?=
 =?utf-8?B?VVVPYndQSGU4bkF2WlJkR2Z1VzhHMS8zQk1oSmNXMksyVkFSRFBGamoyanZN?=
 =?utf-8?B?QWpRTmZpRWE5Zk9SWW5GNncrZEdycTU5SmY4dWpPUmhzN0wxWEJwbTJzZ3lN?=
 =?utf-8?B?Y0hPK09kRGVUSHIyN1JxUFBaTXFVV3g1a3J1MlMxdm42cEZNanJtZy9sbHgy?=
 =?utf-8?B?cmZDbzNHZE93MXByV1hJeGgvWklNb1JZLzByU0pZeDYyZmM5VHNLVm5ET2RW?=
 =?utf-8?B?bWtFQ1piN0psR0hJS0U0NHFuemV2OUM5b3U0dy9uYXc1OUxhNDZSNERCRXNq?=
 =?utf-8?B?TGdEWFgzNE9JU2hoc3E1NDR4ek5WMGtnelkrRCswZDl0L1Eya3FCNHVEdEhY?=
 =?utf-8?B?SC9TYXo5RWQ4SE84QXA3R1FDaTYzQUVZbGNZWGJ4Z204ak1CWS95N253NnlF?=
 =?utf-8?B?QlNxcXlGUllrbEcvVTRCL3l6b1pKMmxXY0FXZDhvODNTVzFuNXVtUjlJV2hx?=
 =?utf-8?B?UTZJTC85T09HQ3FZS3A4SFB3Z29hbnlONjZpOVdUSnNOUHJxNHFScjhtT0or?=
 =?utf-8?B?OHFjMUdaWThlSHdiWTd6THBWR2x4R21TRmFpYVY0VDVNSU9McUg2aEtONnNt?=
 =?utf-8?B?TE9oczl3SFJWZTE4MFI4dUpjdnZvc3hFN2wyTmdxUUh3OGt4RUd2b2tSU212?=
 =?utf-8?B?RnU4UXhWMW10SDJtaHcxYkpMN0ZwSDZwWUVkcjJIVWQ2M1RaN1g0SXp0SkNu?=
 =?utf-8?B?N2lDRkI2VE4vN3RpSmFGN0hDRmdLRUkxRXRGQXVDQU5lT2pCNzdWOHlGNUYv?=
 =?utf-8?B?YVBVNWMrNnQyM0hWSjk2SkxKc242ZHZESW9PdUkzdkZBQUlOMUxZV1FnUnRh?=
 =?utf-8?B?c0xYaHhjL2VXSHFHbWtVQ1NuQUpvTGJWZURKUXV4TE1qWkJLNC9zTXhOMHlC?=
 =?utf-8?B?allSUTFqN0E0UHFoR2VtQzFmYzNFejVMaCsvenhhR29xOE45cFFjS2syck1S?=
 =?utf-8?B?RWVQaUNkcWxjbG9tU0JWSXRSbytpR0VmSjRySFZWdzl3TmlkRVJiQ2Q3NEQz?=
 =?utf-8?B?VU5mWUZNK25wa21mYUx6cUtWNFBwRFdYNmQ0L3cxY3k5eUp5ZllLbWlLMlBn?=
 =?utf-8?B?MXZBYlFOaWtSVjBGNDlaaUdjR3VLMnl2TGpkVXB2SEtxOVB4UzdQTE1wZFVy?=
 =?utf-8?Q?L+8JIWz4qXZOQ1wp/5daVlcY/?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efdd87fa-335c-41e4-4a7d-08db05f5b4f2
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2023 14:48:26.3805
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AKoCJJtc06dIdgcFvKkczZER1pcYiXuEpBLQls8ygJf1mPg1fiwS4u22nekhZRDKePmTkWWQoS+vF2lWSjWyxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6867
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBNYXR0aGV3IFJvc2F0byA8bWpyb3NhdG9AbGludXguaWJtLmNvbT4NCj4gU2VudDog
RnJpZGF5LCBGZWJydWFyeSAzLCAyMDIzIDEwOjI2IFBNDQo+IA0KPiBPbiAyLzMvMjMgMzo1OCBB
TSwgTGl1LCBZaSBMIHdyb3RlOg0KPiA+IEhpIE1hdHRoZXcsDQo+ID4NCj4gLi4uDQo+ID4+ICog
Q2FuJ3QgcGFzcyBncm91cC0+a3ZtIHRvIHZmaW9fZGV2aWNlX29wZW4sIGFzIGl0IHJlZmVyZW5j
ZXMgdGhlIHZhbHVlDQo+ID4+ICAgb3V0c2lkZSBvZiBuZXcgbG9jay4gIFBhc3MgZGV2aWNlLT5r
dm0gdG8gbWluaW1pemUgY2hhbmdlcyBpbiB0aGlzDQo+ID4+ICAgZml4IChBbGV4LCBZaSkNCj4g
Li4uDQo+ID4+IEBAIC0zNjEsNyArNDIwLDYgQEAgc3RhdGljIGludCB2ZmlvX2RldmljZV9maXJz
dF9vcGVuKHN0cnVjdA0KPiB2ZmlvX2RldmljZQ0KPiA+PiAqZGV2aWNlLA0KPiA+PiAgCWlmIChy
ZXQpDQo+ID4+ICAJCWdvdG8gZXJyX21vZHVsZV9wdXQ7DQo+ID4+DQo+ID4+IC0JZGV2aWNlLT5r
dm0gPSBrdm07DQo+ID4NCj4gPiBTaW5jZSB5b3UndmUgZGVsZXRlZCB0aGUgb25seSB1c2FnZSBv
ZiBrdm0gcG9pbnRlciBpbiB0aGlzIGZ1bmN0aW9uLCBJDQo+ID4gZ3Vlc3MgeW91IGNhbiByZW1v
dmUgdGhlIGt2bSBwYXJhbWV0ZXIgZnJvbSB2ZmlvX2RldmljZV9vcGVuKCkNCj4gPiBhbmQgdmZp
b19kZXZpY2VfZmlyc3Rfb3BlbigpLiA6LSkgaWYgaXQgbWFrZXMgdGhpcyBwYXRjaCB0b28gYmln
LCBtYXkNCj4gPiBqdXN0IGhhdmUgYW5vdGhlciBwYXRjaCB0byBkbyBpdC4NCj4gPg0KPiANCj4g
SGkgWWksDQo+IA0KPiBZZWFoLCBJIG1lbnRpb25lZCBpdCBicmllZmx5IChhbmQgdmFndWVseSBJ
IGd1ZXNzKSBpbiB0aGUgY292ZXIsIHRoYXQgd2FzDQo+IGludGVudGlvbmFsbHkgbGVmdCBvdXQg
dG8gcmVkdWNlIHRoZSBwYXRjaCBzaXplIHNpbmNlIHRoaXMgaXMgYSBmaXguICBJIHRob3VnaHQN
Cj4gdGhhdCB3YXMgdGhlIGNvbnNlbnN1cyBmcm9tIHRoZSB2MiBjb21tZW50cyBhbnl3YXkuDQo+
IA0KPiBJZiBJIGVuZCB1cCBkb2luZyBhIHY0IGZvciB0aGlzIEkgY2FuIGp1c3QgaW5jbHVkZSB0
aGUgcmVtb3ZhbCBhcyBhIDJuZCBwYXRjaA0KPiAod2l0aG91dCBhIGZpeGVzIHRhZykgYW5kIEFs
ZXggY2FuIHNxdWFzaCBvciBrZWVwIHNlcGFyYXRlIGFzIHByZWZlcnJlZCAtLSBpZg0KPiBub3Qg
eW91IGNhbiBmZWVsIGZyZWUgdG8gZG8gdGhhdCByZW1vdmFsIHdpdGggeW91ciBjZGV2IGZvbGxv
dy11cCB0aGF0DQo+IGV4cGxvaXRzIHRoaXMgd29yay4NCg0KU3VyZS4g8J+Yig0KDQpSZWdhcmRz
LA0KWWkgTGl1DQo=
