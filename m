Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC0F77C611
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 04:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234352AbjHOCqQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 22:46:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234345AbjHOCqJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 22:46:09 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19BEB171B;
        Mon, 14 Aug 2023 19:46:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692067568; x=1723603568;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=MTIjU7y1z7+qMP8kEfa7Pw3ixz1egZwGASZQy+MZ7KA=;
  b=n35oz0pCRLSVArYAL7kT40LlAYTOfmcFR5BjhSvn+sYBIx2O4DexXk3X
   eQHBT5V/oU8O8pwC6v7O5UjxCpcqH6xVa6lvp7ChGVwTtsRhb25togvSC
   cuMO3wgk85Tml23ulBBNm2YRO5OjQupqoscRTrM/iFEv0k9X4bm5WJVs0
   WlmzwGyTqLdahU0gWt5aUeSc52iFApnmGT7eBDUtdf28oBObMlPNbODVd
   2tE7M/ugqk3Qch879GPdHu5Vc/UyJe/T8SP6EDWypoKmUQhBW7ZyO26OO
   T9jDiZVHAF/4rYFXXH32/OfzcRNPcqyUimNK4vwD++QD6gt8HMvoa0/CJ
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10802"; a="371091427"
X-IronPort-AV: E=Sophos;i="6.01,173,1684825200"; 
   d="scan'208";a="371091427"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2023 19:46:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10802"; a="823688708"
X-IronPort-AV: E=Sophos;i="6.01,173,1684825200"; 
   d="scan'208";a="823688708"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP; 14 Aug 2023 19:46:06 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 14 Aug 2023 19:46:06 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 14 Aug 2023 19:46:06 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Mon, 14 Aug 2023 19:46:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RzMePt0o+tdNjpcY9iirndlznd27KjvgCfltixCSD1vdQMjiUH7Kaxpr1azv7o+eF01Nefzw8mtGcOP0nsEVSlIqA2ESFx/StA4i4IQRsQO8IQHZ9bcxgWVMJSyPRq5Ab4IDFKwUEvy7agxM41cgiaCHibxm+WqjOND8fwSl7AGYE0RfgC8HTPF/270GJjvlWypJrw/D2OExwmngE//7QYPOhZ32MbdpPozdcLFFcKJPlIBq3Kqt31wkJtFQnCvZ9ruBBHqJAcNjtHDG3mDQ0thkOUlENwERpmO7JZOrW5P21W/FsVG7Ch1oYj9+OWKWkFv16qdJHNCK9mXU7lyOYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MTIjU7y1z7+qMP8kEfa7Pw3ixz1egZwGASZQy+MZ7KA=;
 b=JQtnXHnWy/74dS0/bcx/lMTRi53KeufEIAAT2fhAasgmPbXk8Wo3+KtEja/wiKrxlxX8yqxdGmh52zUPMaWFspCZ4P//fxvwDQ13y/8VsiqH/jHliZldQSqNbysp1ZKRd8opFTSZzhSJdTvqd+E//LnGx3NdGLw6z2jmcsF2YPiZeOyW1ej1SQC3CuJ285/id9V+a4vHD0wWzDVdQfoyBI8AM5jHdZrGj03BfkOUSMMu7eP/+8eEXngdBBEC2w4UnIjflxfsqg1PWLrcCk6L1hjnFe5NDk/7ygU6+dIDgja2AtQmYDJ94UZ0I/qQWGvgexT7Q8Ahpue16cXYoEM7pQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CY8PR11MB7846.namprd11.prod.outlook.com (2603:10b6:930:79::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.26; Tue, 15 Aug
 2023 02:45:59 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed%4]) with mapi id 15.20.6678.025; Tue, 15 Aug 2023
 02:45:59 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Brett Creeley <bcreeley@amd.com>, Jason Gunthorpe <jgg@nvidia.com>,
        "Alex Williamson" <alex.williamson@redhat.com>
CC:     Christoph Hellwig <hch@lst.de>,
        Brett Creeley <brett.creeley@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "horms@kernel.org" <horms@kernel.org>,
        "shannon.nelson@amd.com" <shannon.nelson@amd.com>
Subject: RE: [PATCH v14 vfio 6/8] vfio/pds: Add support for dirty page
 tracking
Thread-Topic: [PATCH v14 vfio 6/8] vfio/pds: Add support for dirty page
 tracking
Thread-Index: AQHZyXH315oZeaJfAkWWY6/5iKI7jq/g/BYAgAEh2wCAAB5AAIAACU2AgACQSWCAAOwNAIAACPgAgAAFuACAAADSAIAAA0MAgAAEvoCAAJjmoIAFuMcAgACG0qA=
Date:   Tue, 15 Aug 2023 02:45:59 +0000
Message-ID: <BN9PR11MB527661C57FAFB0C30931339F8C14A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230808162718.2151e175.alex.williamson@redhat.com>
 <01a8ee12-7a95-7245-3a00-2745aa846fca@amd.com>
 <20230809113300.2c4b0888.alex.williamson@redhat.com>
 <ZNPVmaolrI0XJG7Q@nvidia.com>
 <BN9PR11MB5276F32CC5791B3D91C62A468C13A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230810104734.74fbe148.alex.williamson@redhat.com>
 <ZNUcLM/oRaCd7Ig2@nvidia.com>
 <20230810114008.6b038d2a.alex.williamson@redhat.com>
 <ZNUhqEYeT7us5SV/@nvidia.com>
 <20230810115444.21364456.alex.williamson@redhat.com>
 <ZNUoX77mXBTHJHVJ@nvidia.com>
 <BN9PR11MB5276884693015FE95A0939AF8C10A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <26f50be4-1195-ae7f-844f-5babff158bee@amd.com>
In-Reply-To: <26f50be4-1195-ae7f-844f-5babff158bee@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CY8PR11MB7846:EE_
x-ms-office365-filtering-correlation-id: 2c8393e6-32a3-4c35-ac89-08db9d39c1d1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IjimDmoomCxt4NN8vOPOCkbug5lRQ3ml+5pusTvz6feNX63K2YGLc4GPS+JEYtiaup/E50qjq51lN9fy8K3edeBGzDZslA9tTLMgKIh9P5gYklxwBkIM8y8K3Ygg+gw/URCaIkxUVkDaoVMU0VADRlkzz8270MhgFU82WHXrqLviB9p7GUchwcTWehJzf2VaBRxnYqQ4CXROjz5OGlVmJUL8XaCYU4p47HvJIEt8jkcYe//wF6iLbyFc9JBeINgqjgrnTWKaL7TK+IVfQm0hi4KnaiZ8nZFogxFEbFeEz/M0cbUH4jzV7NQ0nhLkaj9gcblgnF5+X3LaFAg9FSdK/saGzivIudTBTBe6xjVm2CR96cl16206LppLwpp8i64FiVMlT+bxIwOlxWGZyiaq94iZiJp+LyUpwA63xgge5NZY889Hv/Fr4czRGKRlxYXhHmcAgowH7dsar+cAm+Vu45Jl98KQHVXXxE9n54clWM0ubH8IDprjjg9ZyWPpDaxCMq73u1WmHqMBWZK3eStoLNGFZNU02O7B6EoYcWb7OsvvEjdYDWOlJ5cokT5iJ+bI8O2PPmOVTJLZKupv0hvXArabuKgICFAEyrtk+zZJ9VXhqaYgP3i47ld+RgGvE8LhaLd0qQGouvFz9yO2ja++MA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(346002)(136003)(396003)(376002)(451199021)(1800799006)(186006)(38100700002)(55016003)(54906003)(110136005)(7696005)(71200400001)(478600001)(122000001)(82960400001)(52536014)(7416002)(2906002)(38070700005)(5660300002)(86362001)(33656002)(4326008)(64756008)(66446008)(66476007)(66556008)(76116006)(66946007)(41300700001)(8936002)(8676002)(316002)(6506007)(53546011)(26005)(83380400001)(9686003)(14143004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S3pQenRGTzkvUFlMaHp1bXBCZlZQQ00yNE1NcnlLbVhaWEdjck5wUndUekxO?=
 =?utf-8?B?VVBSNkl6Qi9ycDRsMFE1eE1EZFNjYVVRdS9ld0lycE1wekRnQlZWQzlHb1Mx?=
 =?utf-8?B?cUpvNVBuUTg1T0NQbUpoTEdHdWNFVzAyMktHVDN6NXJGR2RLa2d3MGs3NDlo?=
 =?utf-8?B?T3FYbmEzVFhURGUvQXhndWVGUDE2SHBoWDdXWUhDQkRHYk9Fc0pIYTJPZGNu?=
 =?utf-8?B?Tjg4Q1lTbFZwMjBTZ3VuTlpIWUdhYU1mZmlxak4zL2JEeElBNSs5dXgvaWw3?=
 =?utf-8?B?VVorb29IUEZIaDY2THJqTDhHVzhtbC9JVXZuVkRLNE11QTZSYXdtZFIyeWYz?=
 =?utf-8?B?WThPdHpYVjNWVkU3bnlSK283RndLaGgwQ2NVcmVJYm9XUWdlcHZtMVNmUHBk?=
 =?utf-8?B?VjlYWlpzMGpQR1VzNzloT1o1T1FaVklFV04wcFNJdWFIZXpLSzdsN3MrVWpJ?=
 =?utf-8?B?cjRJbFBVRktPRGdWWDl5SWliOU56TnJ2d25FcW9Mdlo0a0RuaFo2MG44V2pr?=
 =?utf-8?B?NkVqL2xxdk1lNmsrbUswdUMvNUlEMkxESFc2SkhyV2F2WEVRUE02U1RacVlU?=
 =?utf-8?B?UlZTYkRpdnhXSW4rYkZvQ1FReUs2UkhiWWxqWVNVaTF4bVFEVGtmb3BmOGlZ?=
 =?utf-8?B?eFdhaU5wMUtXbjFTbXd6dk1RaXd0amRwRFZpMVJ5bkNKMEpyYktmS3haY0ty?=
 =?utf-8?B?cmltTlExWUpqZ20reCtHc3UyZWlvWEdNbmxNSmFYYkxqdUJsai80NGhFR3Iv?=
 =?utf-8?B?QUpHek94b0dQNStIdDQrbE1ieW9HaHRIMmVpSzYyczZHTktXeWpGQ25DUnlv?=
 =?utf-8?B?TDFvRkhKMkFjcTlnZHNOMnF5TVZzTitOSFRxbWZ1WGx1M05IR09FdmFwOFc0?=
 =?utf-8?B?S0plSE9MRWx4dGhyd0VUU2VvT1dFNjhuN2pIMnhsOVNIVVJrRTRaT3lPMjJG?=
 =?utf-8?B?Yzkyc3ZmSklRT29wSHF4b2NvZ2w0bHI2eFdvb2QzM2tydGFxUnJuWXVadjRu?=
 =?utf-8?B?clRnN0pRUnJWektvdHBwSitNTHhuTlJJNGhzOEFJTW8veGlwMmhUQ1FnS1VH?=
 =?utf-8?B?Q3ZHRTBqYll6RkpYTVgySFVGQUxGTDRFKzVXWDMwVzN2NHpTeEdBbnMvOUdG?=
 =?utf-8?B?SDJwOWNuWW1Ecnczd1dLOWt6T0d6VTZNbVJNelFCUzBlMFZ2dUVqd3RtWHF1?=
 =?utf-8?B?NFB0NWs2bk50OE1NcnNtV0x4czBWQUpiRVV5Mjl0alhpVzBvT0NpbkNiVUNY?=
 =?utf-8?B?emE3cUFCNVB6L3RNVWFTMng2UU55NSsyc1NGd1ZpTnFOMTJmVDZXVjFEQ0Yz?=
 =?utf-8?B?SUpDbWhqemdZR0F2djduLzFxQWYza2VCdm5GczRMUDNFbGtmM0U0bHNmYzhz?=
 =?utf-8?B?RkNEdHg4a0dLL0UyZnZxT002MnBmY0E4cjA3enBUOXlhSGJPSjhnQ0RSQ0Jt?=
 =?utf-8?B?L1VkcmlXeTBwMmppcWdYRVU0YktPanI0bUZqOTkvMW9FOXB6ZGVWdytKZTNR?=
 =?utf-8?B?MWJiNnpqaUhCQjkzY2p1UHpuOGF4MU5hZ1VEbUswWVgxQmpQUWI3WGdSZ1ky?=
 =?utf-8?B?ODZtRG8zUWZaVk03TFNxQzhmOWpLQUJucktrM3FuSyt6QlRNT0pQdElUak5F?=
 =?utf-8?B?NnpJNGRJc0UyZFJ0aUo4MmJ5T2FmV3RYU1ZBdEoyWHZSNWhCZS9jc2VETGhX?=
 =?utf-8?B?NVhaeVZsM1hsLzZxWjIxQkFOcWQvMWVTb1B3Y3IrMWsxSndaRklTTTMrZlA3?=
 =?utf-8?B?enZzZGVrQVB0TkpJZmVFbk9xMEg4YjVaRWpEVHkwUWxwL1NEQnloVVRXdkJB?=
 =?utf-8?B?VTk5Q0h5Z3lRRW14M2tyRUl5MGZVUHVaTUpmUk94Wk5WRHNVUFRJNHZaV2hE?=
 =?utf-8?B?WitMT0p0c3ZIclIxVWhOaFZ0Z2JaOXBndnVzQm5ncTFzNjcwMjhOUFlvQWR2?=
 =?utf-8?B?QVlJTkwvL0NDUDRPbDFBa1F3MUd4dVRqazVtdnVRaWJQNE1HSjY1Q0hqRHZj?=
 =?utf-8?B?eWpmVmRmZE1KUGJqdElBRkwwVzJ0QXp0UFJhRXorWmlENng2RWwwbnNaNERD?=
 =?utf-8?B?VXhnMTFIUUlMUXZZcHpWZ2U1Rng5Z3BTK0FCeWI1R1BtS0lqNkhtdzEwRGt1?=
 =?utf-8?Q?TGehogxZk7sG08KQWEcIvE039?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c8393e6-32a3-4c35-ac89-08db9d39c1d1
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2023 02:45:59.3009
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: k1/SW6g9RWMaOBzr12uZslC/JYJ/JTfmrBjqh87l4os8h2E/Cyk7HZSSMdFNXzVWQXeScL8tEMstJz+FyNw7GQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7846
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBCcmV0dCBDcmVlbGV5IDxiY3JlZWxleUBhbWQuY29tPg0KPiBTZW50OiBUdWVzZGF5
LCBBdWd1c3QgMTUsIDIwMjMgMjo0MiBBTQ0KPiANCj4gT24gOC8xMC8yMDIzIDg6MjUgUE0sIFRp
YW4sIEtldmluIHdyb3RlOg0KPiA+IENhdXRpb246IFRoaXMgbWVzc2FnZSBvcmlnaW5hdGVkIGZy
b20gYW4gRXh0ZXJuYWwgU291cmNlLiBVc2UgcHJvcGVyDQo+IGNhdXRpb24gd2hlbiBvcGVuaW5n
IGF0dGFjaG1lbnRzLCBjbGlja2luZyBsaW5rcywgb3IgcmVzcG9uZGluZy4NCj4gPg0KPiA+DQo+
ID4+IEZyb206IEphc29uIEd1bnRob3JwZSA8amdnQG52aWRpYS5jb20+DQo+ID4+IFNlbnQ6IEZy
aWRheSwgQXVndXN0IDExLCAyMDIzIDI6MTIgQU0NCj4gPj4NCj4gPj4gT24gVGh1LCBBdWcgMTAs
IDIwMjMgYXQgMTE6NTQ6NDRBTSAtMDYwMCwgQWxleCBXaWxsaWFtc29uIHdyb3RlOg0KPiA+Pj4g
T24gVGh1LCAxMCBBdWcgMjAyMyAxNDo0MzowNCAtMDMwMA0KPiA+Pj4gSmFzb24gR3VudGhvcnBl
IDxqZ2dAbnZpZGlhLmNvbT4gd3JvdGU6DQo+ID4+Pg0KPiA+Pj4+IE9uIFRodSwgQXVnIDEwLCAy
MDIzIGF0IDExOjQwOjA4QU0gLTA2MDAsIEFsZXggV2lsbGlhbXNvbiB3cm90ZToNCj4gPj4+Pg0K
PiA+Pj4+PiBQQ0kgRXhwcmVzc8KuIEJhc2UgU3BlY2lmaWNhdGlvbiBSZXZpc2lvbiA2LjAuMSwg
cGcgMTQ2MToNCj4gPj4+Pj4NCj4gPj4+Pj4gICAgOS4zLjMuMTEgVkYgRGV2aWNlIElEIChPZmZz
ZXQgMUFoKQ0KPiA+Pj4+Pg0KPiA+Pj4+PiAgICBUaGlzIGZpZWxkIGNvbnRhaW5zIHRoZSBEZXZp
Y2UgSUQgdGhhdCBzaG91bGQgYmUgcHJlc2VudGVkIGZvciBldmVyeQ0KPiBWRg0KPiA+PiB0byB0
aGUgU0kuDQo+ID4+Pj4+DQo+ID4+Pj4+ICAgIFZGIERldmljZSBJRCBtYXkgYmUgZGlmZmVyZW50
IGZyb20gdGhlIFBGIERldmljZSBJRC4uLg0KPiA+Pj4+Pg0KPiA+Pj4+PiBUaGF0PyAgVGhhbmtz
LA0KPiA+Pj4+DQo+ID4+Pj4gTlZNZSBtYXRjaGVzIHVzaW5nIHRoZSBjbGFzcyBjb2RlLCBJSVJD
IHRoZXJlIGlzIGxhbmd1YWdlIHJlcXVpcmluZw0KPiA+Pj4+IHRoZSBjbGFzcyBjb2RlIHRvIGJl
IHRoZSBzYW1lLg0KPiA+Pj4NCj4gPj4+IE9rLCB5ZXM6DQo+ID4+Pg0KPiA+Pj4gICAgNy41LjEu
MS42IENsYXNzIENvZGUgUmVnaXN0ZXIgKE9mZnNldCAwOWgpDQo+ID4+PiAgICAuLi4NCj4gPj4+
ICAgIFRoZSBmaWVsZCBpbiBhIFBGIGFuZCBpdHMgYXNzb2NpYXRlZCBWRnMgbXVzdCByZXR1cm4g
dGhlIHNhbWUgdmFsdWUNCj4gPj4+ICAgIHdoZW4gcmVhZC4NCj4gPj4+DQo+ID4+PiBTZWVtcyBs
aW1pdGluZywgYnV0IGl0J3MgaW5kZWVkIHRoZXJlLiAgV2UndmUgZ290IGEgbG90IG9mIGNsZWFu
dXAgdG8NCj4gPj4+IGRvIGlmIHdlJ3JlIGdvaW5nIHRvIHN0YXJ0IHJlamVjdGluZyBkcml2ZXJz
IGZvciBkZXZpY2VzIHdpdGggUENJDQo+ID4+PiBzcGVjIHZpb2xhdGlvbnMgdGhvdWdoIDspICBU
aGFua3MsDQo+ID4+DQo+ID4+IFdlbGwuLiBJZiB3ZSBkZWZhY3RvIHNheSB0aGF0IExpbnV4IGlz
IGVuZG9yc2luZyBpZ25vcmluZyB0aGlzIHBhcnQgb2YNCj4gPj4gdGhlIHNwZWMgdGhlbiBJIHBy
ZWRpY3Qgd2Ugd2lsbCBzZWUgbW9yZSB2ZW5kb3JzIGZvbGxvdyB0aGlzIGFwcHJvYWNoLg0KPiA+
Pg0KPiA+DQo+ID4gTG9va3MgUENJIGNvcmUgYXNzdW1lcyB0aGUgY2xhc3MgY29kZSBtdXN0IGJl
IHNhbWUgYWNyb3NzIFZGcyAodGhvdWdoDQo+ID4gbm90IGNyb3NzIFBGL1ZGKS4gQW5kIGl0IGV2
ZW4gdmlvbGF0ZXMgdGhlIHNwZWMgdG8gcmVxdWlyZSBSZXZpc2lvbiBJRA0KPiA+IGFuZCBTdWJz
eXN0ZW0gSUQgbXVzdCBiZSBzYW1lIHRvbzoNCj4gPg0KPiA+IHN0YXRpYyB2b2lkIHBjaV9yZWFk
X3ZmX2NvbmZpZ19jb21tb24oc3RydWN0IHBjaV9kZXYgKnZpcnRmbikNCj4gPiB7DQo+ID4gICAg
ICAgICAgc3RydWN0IHBjaV9kZXYgKnBoeXNmbiA9IHZpcnRmbi0+cGh5c2ZuOw0KPiA+DQo+ID4g
ICAgICAgICAgLyoNCj4gPiAgICAgICAgICAgKiBTb21lIGNvbmZpZyByZWdpc3RlcnMgYXJlIHRo
ZSBzYW1lIGFjcm9zcyBhbGwgYXNzb2NpYXRlZCBWRnMuDQo+ID4gICAgICAgICAgICogUmVhZCB0
aGVtIG9uY2UgZnJvbSBWRjAgc28gd2UgY2FuIHNraXAgcmVhZGluZyB0aGVtIGZyb20gdGhlDQo+
ID4gICAgICAgICAgICogb3RoZXIgVkZzLg0KPiA+ICAgICAgICAgICAqDQo+ID4gICAgICAgICAg
ICogUENJZSByNC4wLCBzZWMgOS4zLjQuMSwgdGVjaG5pY2FsbHkgZG9lc24ndCByZXF1aXJlIGFs
bCBWRnMgdG8NCj4gPiAgICAgICAgICAgKiBoYXZlIHRoZSBzYW1lIFJldmlzaW9uIElEIGFuZCBT
dWJzeXN0ZW0gSUQsIGJ1dCB3ZSBhc3N1bWUgdGhleQ0KPiA+ICAgICAgICAgICAqIGRvLg0KPiA+
ICAgICAgICAgICAqLw0KPiA+ICAgICAgICAgIHBjaV9yZWFkX2NvbmZpZ19kd29yZCh2aXJ0Zm4s
IFBDSV9DTEFTU19SRVZJU0lPTiwNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
JnBoeXNmbi0+c3Jpb3YtPmNsYXNzKTsNCj4gPiAgICAgICAgICBwY2lfcmVhZF9jb25maWdfYnl0
ZSh2aXJ0Zm4sIFBDSV9IRUFERVJfVFlQRSwNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAmcGh5c2ZuLT5zcmlvdi0+aGRyX3R5cGUpOw0KPiA+ICAgICAgICAgIHBjaV9yZWFkX2Nv
bmZpZ193b3JkKHZpcnRmbiwgUENJX1NVQlNZU1RFTV9WRU5ET1JfSUQsDQo+ID4gICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgJnBoeXNmbi0+c3Jpb3YtPnN1YnN5c3RlbV92ZW5kb3IpOw0K
PiA+ICAgICAgICAgIHBjaV9yZWFkX2NvbmZpZ193b3JkKHZpcnRmbiwgUENJX1NVQlNZU1RFTV9J
RCwNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAmcGh5c2ZuLT5zcmlvdi0+c3Vi
c3lzdGVtX2RldmljZSk7DQo+ID4gfQ0KPiA+DQo+ID4gRG9lcyBBTUQgZGlzdHJpYnV0ZWQgY2Fy
ZCBwcm92aWRlIG11bHRpcGxlIFBGJ3MgZWFjaCBmb3IgYSBjbGFzcyBvZg0KPiA+IFZGJ3Mgb3Ig
YSBzaW5nbGUgUEYgZm9yIGFsbCBWRidzPw0KPiANCj4gSGV5IEtldmluLA0KPiANCj4gVGhlIEFN
RCBQZW5zYW5kbyBEU0MgcHJvdmlkZXMgbXVsdGlwbGUgUEZzIGZvciBlYWNoIGNsYXNzIG9mIFZG
cy4NCj4gQWxsIG9mIG91ciBwcm9kdWN0aW9uIGRldmljZXMgd2lsbCBtZWV0IHRoZSBhc3N1bXB0
aW9ucyBvZiB0aGUgcGNpIGNvcmUNCj4gZnVuY3Rpb24gYWJvdmUgdGhhdCBhbGwgVkZzIG1hdGNo
IFZGMCBmb3IgdGhvc2UgY29tbW9uIGZpZWxkcy4NCj4gDQo+IEkndmUgYmVlbiBvdXQgZm9yIGEg
ZmV3IGRheXMgc28gYXBvbG9naWVzIGZvciB0aGUgZGVsYXllZCByZXNwb25zZS4NCj4gDQoNClNv
dW5kcyBnb29kLiBObyBtb3JlIG9wZW4gdGhlbi4g8J+Yig0KDQo=
