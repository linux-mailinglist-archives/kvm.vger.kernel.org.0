Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D93074DBEFC
	for <lists+kvm@lfdr.de>; Thu, 17 Mar 2022 07:08:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbiCQGJw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Mar 2022 02:09:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbiCQGJe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Mar 2022 02:09:34 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81FED27B634;
        Wed, 16 Mar 2022 22:47:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647496069; x=1679032069;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lCVtDC/lBr2C8qG6qoU3Dgd0cSCZlL1we72ke9h2Otg=;
  b=TnCJ1vYHlYVFgjrwuQODoXhmUc/iQFBd4IuvVB9lJQfqEG2ySUDSjBmp
   SVycuoipcxvbliVribgsyJuLBRvo0zqFjGJCkK/6H9q7e5ekXKxe3oEel
   uCCwTICGLcAzgByL8MFcE02sHH0acFDsOkYfI3SNYpTQNiU8LdgjLk5YM
   u6LDFzobqgq3Z+1cpP7qqL0CA6Cy2qP4NGdRuf+UCxmjrns8KULl3fyXQ
   v5sK3Uto/g/Vhrub7/udQOBeUApT0PMFyVzMoQuglNOXEGo/+xbdt0o0B
   SiYL22LbMBUnExI/FwMRm/HaYXiZ8ONjOjgJz4mOVpVUPYvB9UgG/fiMC
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10288"; a="256976992"
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; 
   d="scan'208";a="256976992"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2022 22:47:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; 
   d="scan'208";a="498714581"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga003.jf.intel.com with ESMTP; 16 Mar 2022 22:47:48 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 16 Mar 2022 22:47:47 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Wed, 16 Mar 2022 22:47:47 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Wed, 16 Mar 2022 22:47:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y6mzG9PRLLm584DPpR74Wi3wvTRynnuulaSXcDLJbCxnft9xnsMtm+Tx75Gw0b1VGmTUQXZG6cMd8HMjPokIXZJ+DHKJ3ZNkjfh7wQij4N76rgm4n2LBg8MgCs9CCh31W2ZKp/+V5PrQF9JjMQ2Ck4ncl/DNmfJcvPQ5NDUz2cBk0MHurmMjW0rj4I95tOoDgYtDsZC2pAe8t7qkhwD7vL9XeY9r51wVv7QTJlhApql3Pp1Rcy1GSzJoN2+9fNGTOimi9cFhPe0QbqpT7/DEg/XpdDHHrTNF+WBHZ1zYlt59Y4lsv7Vw2Ygp0BClqfcPQLiXo6kcwFolzjrunfCbzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lCVtDC/lBr2C8qG6qoU3Dgd0cSCZlL1we72ke9h2Otg=;
 b=haKnCDeDhKfV4dddI4XGiPDQQicrYdwQ3MVl+F3UmJ41JcFhA8EWj6JuTz+5pxF7cdXe000IG+Z1854tLqpZ1MUptnapyZtX+thH0f784pybBm7xsX0kwm8m2t1XQenzBC8Q5JQPGv1oGR3kLUwXBse5STtRwQCJJ6DPlKmBlFnxlUCrTf1li/LDOQgwlq2eylusdSoNPiur50QZU0hDAWwAk2NQifGCUnRI5qi4JDxb5nd9nTBBxiFs6zmZ7+uwEVtznDgaz4n2Mv+LkN52CafaGJhIOLzQSo4ovYZbDBJhC5mioNAyuDNotsR5Ijjs9/zJQthGiTze8aCWwfUq4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MW3PR11MB4746.namprd11.prod.outlook.com (2603:10b6:303:5f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.24; Thu, 17 Mar
 2022 05:47:36 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c8aa:b5b2:dc34:e893]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c8aa:b5b2:dc34:e893%8]) with mapi id 15.20.5081.014; Thu, 17 Mar 2022
 05:47:36 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Robin Murphy <robin.murphy@arm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "david@redhat.com" <david@redhat.com>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "oberpar@linux.ibm.com" <oberpar@linux.ibm.com>,
        "vneethv@linux.ibm.com" <vneethv@linux.ibm.com>,
        "agordeev@linux.ibm.com" <agordeev@linux.ibm.com>,
        "imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>,
        "will@kernel.org" <will@kernel.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "frankja@linux.ibm.com" <frankja@linux.ibm.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "gerald.schaefer@linux.ibm.com" <gerald.schaefer@linux.ibm.com>,
        "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
        "thuth@redhat.com" <thuth@redhat.com>,
        "gor@linux.ibm.com" <gor@linux.ibm.com>,
        "schnelle@linux.ibm.com" <schnelle@linux.ibm.com>,
        "hca@linux.ibm.com" <hca@linux.ibm.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "freude@linux.ibm.com" <freude@linux.ibm.com>,
        "pmorel@linux.ibm.com" <pmorel@linux.ibm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "svens@linux.ibm.com" <svens@linux.ibm.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>
Subject: RE: [PATCH v4 14/32] iommu: introduce iommu_domain_alloc_type and the
 KVM type
Thread-Topic: [PATCH v4 14/32] iommu: introduce iommu_domain_alloc_type and
 the KVM type
Thread-Index: AQHYN9xnDDDBVY4pLUqXQfRGdryZ0KzARNcAgALO3mA=
Date:   Thu, 17 Mar 2022 05:47:36 +0000
Message-ID: <BN9PR11MB5276360F6DBDC3A238F3E41A8C129@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220314194451.58266-1-mjrosato@linux.ibm.com>
 <20220314194451.58266-15-mjrosato@linux.ibm.com>
 <a9637631-c23b-4158-d2cb-597a36b09a6b@arm.com>
In-Reply-To: <a9637631-c23b-4158-d2cb-597a36b09a6b@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f8dadb0b-ae4c-40ac-9a7c-08da07d9a406
x-ms-traffictypediagnostic: MW3PR11MB4746:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <MW3PR11MB47469F80773C2EB68934FC948C129@MW3PR11MB4746.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 20MwV//iMEiMhHUlqbOR42HJCr9w64wK8hIrYeRH0PkD2AV6d6UBtLI0cfljAds2PoN6wKsZyUUYbBIAsYBPaBVpfEvaF8QDh2oimSCpzvpivkcmSqrcTs1lNwBokCqO/kIQuboGKMYND5fYKjTo3xCi8dRqejJ+AouQO4DEmtnvuwTNtIagAxELhlHtlzgCvDCuamOW13pzrxVqGjvXBD/7tehxBcLnNYoGIiJoOTpyILIC/z1csThlQL5jDa3gRWsGuMY4Nmk1ExGqR2d37ncIpCMwuub4jCigPXXXcryrcO8P0gM1Kl+xy7qWrsgSXkttoaBTm6KrSIK21T8SqLCuN9lEnEzjqSEKf87x5wA1CsJxz1gzxxSmjgYwmw/f7/AUsR7FBW9nd5kTm/+Rx1vjhHtcQrMa6LXOgOWV0dDGf8MCyJwHTXqcypVK63t2YutuAJUpG+ZmcCyzZ86BycV9uk/vvz8OtDiD6o7EjYvYK48eNv1pwY/oZouJj51BenXUjeGiVbYjjtaNSGMlYcmKFRuOUoHjG7+t2TruGaW0SqjXLo6eF85M4QMIU36yMKsmZVcpi+lnJqGP8EB797v5tX17XuyClr2iLRWb6D7Ljkl4kXa4hfkNCJOxwSkKcL+Zq+VH2PwLz1eP6e0JIhcW6w3v+gZ4vZkppn7LeDpgXMOqdUY/p7jaBhDjd+j5OFW2xD/QunIZ0AHLXKZkDw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66446008)(66476007)(66556008)(66946007)(76116006)(64756008)(4326008)(8676002)(86362001)(508600001)(55016003)(26005)(186003)(107886003)(2906002)(5660300002)(82960400001)(54906003)(52536014)(38070700005)(33656002)(8936002)(71200400001)(9686003)(316002)(7416002)(7406005)(53546011)(122000001)(6506007)(7696005)(38100700002)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SUtnMGR2VE9aYzhIZkxsR21vTDY3akU0c01tb2s0STFYZXptb1ZEOHV2VjRZ?=
 =?utf-8?B?SkIrUFNiN2pZWTBaQkVYSjRtWE12U0ZUMDJEb3hPaFJhQVJrNGtxWUJTMWQ1?=
 =?utf-8?B?K1RiWitlQ091eEIvMno2b0ZQeWgyTGJDWUl2U2lnQk1aM0FxcXlUZWNadE10?=
 =?utf-8?B?R0crM0F5UUtaRUd5R25DVzZCYjlhNHR6cnNpbzVhMmQzY1BlOElqcDJrYXFW?=
 =?utf-8?B?ZHh0ZjJLYWZiMVBqUktWVTQxQ1JFUXB3TlEvVGxyMGFsbHpwVHlaaUtKM05L?=
 =?utf-8?B?TWlWMVY0SGNraDJRNU93TXU4NGFRNFcxQzhWTjZjM1pLVVRBQWdaVUVnWldl?=
 =?utf-8?B?WVdzT2NvampGcFdncnZ5M3ZkZG8wQjdKV3FSS1oyTXB0R1YzRkVwRXZHS0Mz?=
 =?utf-8?B?WHQvVXZBUDgrNTF0S3lZZkJDU0VwRGUweVlOb1BQa0syZEVoNm5wS1kvZlds?=
 =?utf-8?B?VUV0blMwdlc1SW9ISERkQmJoczBLQnhRbjMvM0NLWnQvS0hFZEhVNCtFcjNB?=
 =?utf-8?B?K0h2NHdxQ08wZWE5WUJJKzRMekF2VFJQaXlOQTFGaWhzbHNEbk5rWGRRcUt5?=
 =?utf-8?B?d25MeWxnc1lBVXR6em00ODAycWJZa2xtaVFIVTBUTjkyWk9XTTdVV2hDMk9W?=
 =?utf-8?B?TUNrcHR4ZWpsbVhjcjI3T0MxU3VJYTNvM3ZMNHcrMU56Sy9NOVl0UVllSnN5?=
 =?utf-8?B?WlJEbk1GWktQVXI2YVdYMU11MVlNWFRidE1KQnlrK1E3TXFobThjRzZpUllI?=
 =?utf-8?B?VXVoSTE1elVWSE1aM205Z2Q3RzFzNitiZ2ZTM3QzL21CNDFaN3JKRDkxNTJo?=
 =?utf-8?B?emFVQ2VUOWl6QWVNTDhSajltdW9iTURkZXp6TllvRjNYUjdZMzlWYzlCQ0hv?=
 =?utf-8?B?aitIYUV5cWJSZENqdW9TQ2xyRkNCK2o3Ny9rMjlIUENhN0t1NnJMb2hxMllN?=
 =?utf-8?B?WDZPYzEyYUVaRkF4cEJacWJWbVlmc0Z1dkN5bVV3WXVmRGJrWTVkS2w2ODhE?=
 =?utf-8?B?NHQzd2hkQ2pwMFM1d0pnNE9xeWRLSnVkRWZwL3dKNlVoaE1DL3Q5TXFTbmhY?=
 =?utf-8?B?RjEzaXRyblBCYjBGKzZDcWtrMWFhekNSNGhyT0dqbEthMG9aTDlKQ2RHcmM5?=
 =?utf-8?B?RE5qVWhSTFhab0xNTXMyU0orLzJOUEsvcXJZRTNZU3ovVDJSaEM0ZVNBZkJQ?=
 =?utf-8?B?STRtcWdlaTlqb3hPaTVMUHB3RWRQaWw2b0dRMEE0S1BwZ091ck1kN3lPTzAr?=
 =?utf-8?B?MHRpYjlsVjlPL3VIRlQwbU1tK0lYZWxjNGJ5UjNad2U3RVcvUk1BbTFJSFcv?=
 =?utf-8?B?U3dkdW1xYUF3NjNMcFY4dEdBZGd1UFRrS2VWcWcvWXlqVmZ2SFhxQnZyNUlm?=
 =?utf-8?B?QnpoakZSeDg5dDNVVzZMQnpSVXo3dmltblpubExzWHlvR2ZiNVkySjlGR1lB?=
 =?utf-8?B?RUhOTlVwYkV5TUxUZzVqcmtwRHZwOVJxdjZHYW5JTHBxdXR6eWgxY2tYOTB5?=
 =?utf-8?B?Ym9mamdRVmNNNnlzOVB6aUFNUWJyYlVyMk1NckYrT3k2SGVJNFJkaWV1djl2?=
 =?utf-8?B?ZFp1M3pHSVYwVXlZTFpGalZIM0p5WkhxbEYzc3BYcno5VnlCSlVhSngzTTU2?=
 =?utf-8?B?KzFLRmFCR01XWXBybWdVWGIwRHIyVnNoaWlzbFhNVkNEY1owM2FKcCt3Q2J5?=
 =?utf-8?B?bGw4S0xmU09VTlJDYjNOYmNpYlY2Mk1FSEpuTmxsY21EUEFtM3pjTjVXcFRq?=
 =?utf-8?B?bGRsZ0ZYUGoyeEQ0YjlPZzFEUTlUVTkrL0JzeGFZaWxYazFhaSsveVdFVlNP?=
 =?utf-8?B?aHNmNlZxNWZKc1BUQ2RhSnhLR0tNenZXc0VEU1JHNklpOXlyWXZCNFFEOUpL?=
 =?utf-8?B?clFxdWpLUUdHMjAxZmt1TmptdU91U2RzbDZtZDE5blZLVjd0YWdyYjJxK1hp?=
 =?utf-8?Q?nfvzdCDU5PCAB69ip/4Qxu+JsjTKDWql?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8dadb0b-ae4c-40ac-9a7c-08da07d9a406
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2022 05:47:36.6134
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0csErHFjAsZ2EvQXAmHtHWEyzoMDWncLeEGyEUQSuOSvmm6639pbdiSVCuwVRIFp67PVTyuk/Pz7UQAUhj/eFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4746
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBSb2JpbiBNdXJwaHkNCj4gU2VudDogVHVlc2RheSwgTWFyY2ggMTUsIDIwMjIgNjo0
OSBQTQ0KPiANCj4gT24gMjAyMi0wMy0xNCAxOTo0NCwgTWF0dGhldyBSb3NhdG8gd3JvdGU6DQo+
ID4gczM5MHggd2lsbCBpbnRyb2R1Y2UgYW4gYWRkaXRpb25hbCBkb21haW4gdHlwZSB0aGF0IGlz
IHVzZWQgZm9yDQo+ID4gbWFuYWdpbmcgSU9NTVUgb3duZWQgYnkgS1ZNLiAgRGVmaW5lIHRoZSB0
eXBlIGhlcmUgYW5kIGFkZCBhbg0KPiA+IGludGVyZmFjZSBmb3IgYWxsb2NhdGluZyBhIHNwZWNp
ZmllZCB0eXBlIHZzIHRoZSBkZWZhdWx0IHR5cGUuDQo+IA0KPiBJJ20gYWxzbyBub3QgYSBodWdl
IGZhbiBvZiBhZGRpbmcgYSBuZXcgZG9tYWluX2FsbG9jIGludGVyZmFjZSBsaWtlDQo+IHRoaXMs
IGhvd2V2ZXIgaWYgaXQgaXMganVzdGlmaWFibGUsIHRoZW4gcGxlYXNlIG1ha2UgaXQgdGFrZSBz
dHJ1Y3QNCj4gZGV2aWNlIHJhdGhlciB0aGFuIHN0cnVjdCBidXNfdHlwZSBhcyBhbiBhcmd1bWVu
dC4NCj4gDQo+IEl0IGFsc28gc291bmRzIGxpa2UgdGhlcmUgbWF5IGJlIGEgZGVncmVlIG9mIGNv
bmNlcHR1YWwgb3ZlcmxhcCBoZXJlDQo+IHdpdGggd2hhdCBKZWFuLVBoaWxpcHBlIGlzIHdvcmtp
bmcgb24gZm9yIHNoYXJpbmcgcGFnZXRhYmxlcyBiZXR3ZWVuIEtWTQ0KPiBhbmQgU01NVSBmb3Ig
QW5kcm9pZCBwS1ZNLCBzbyBpdCdzIHByb2JhYmx5IHdvcnRoIHNvbWUgdGhvdWdodCBvdmVyDQo+
IHdoZXRoZXIgdGhlcmUncyBhbnkgc2NvcGUgZm9yIGNvbW1vbiBpbnRlcmZhY2VzIGluIHRlcm1z
IG9mIGFjdHVhbA0KPiBpbXBsZW1lbnRhdGlvbi4NCj4gDQoNClNhbWUgaGVyZS4gWWFuIFpoYW8g
aXMgd29ya2luZyBvbiBwYWdlIHRhYmxlIHNoYXJpbmcgYmV0d2VlbiBLVk0NCmFuZCBWVC1kLiBU
aGlzIGlzIG9uZSBpbXBvcnRhbnQgdXNhZ2UgdG8gYnVpbGQgYXRvcCBpb21tdWZkIGFuZA0KYSBz
ZXQgb2YgY29tbW9uIGludGVyZmFjZXMgYXJlIGRlZmluaXRlbHkgbmVjZXNzYXJ5IGhlcmUuIPCf
mIoNCg0KVGhhbmtzDQpLZXZpbg0K
