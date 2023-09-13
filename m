Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB5D79DE4C
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 04:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235284AbjIMCfO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Sep 2023 22:35:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbjIMCfN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Sep 2023 22:35:13 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18D3C1713;
        Tue, 12 Sep 2023 19:35:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694572510; x=1726108510;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lODDBleXIaFgH8M8H8w71iOqIs/Aj54vMQ7xcv1z5rk=;
  b=nMChqdlXyUJFza/631DonpJIarcd2Td4S1mSXO9rQDQ2oFinA0dqQshS
   hy58i6LQbkdDjNvbmxX757V1j6fAdZcs9ieW/lWgdEf/PjjSinIawBBax
   xTDTvouqgPvdmlJEI7OSK+KveHjylGklN2vuXj0WGeKgUNCVZ+KtVtO//
   NWXdL4G2XlTK6SJ/SvT5GxBXTuWtdzWcxE0BOcS8H3Gom/Pp2E4KO/9PC
   NQVUczuCj/VHuliUHNfwztOxBRbKNVAMGQCyqxSyqFOYlKVaqoawKQGJq
   Dl13d2+1JmNE0DdbKxvoPJt3tiSplhu7FgJOwrc99yXjIV87mIfhwOJKL
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10831"; a="377456091"
X-IronPort-AV: E=Sophos;i="6.02,142,1688454000"; 
   d="scan'208";a="377456091"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2023 19:35:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10831"; a="1074780619"
X-IronPort-AV: E=Sophos;i="6.02,142,1688454000"; 
   d="scan'208";a="1074780619"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Sep 2023 19:35:08 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Tue, 12 Sep 2023 19:35:07 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Tue, 12 Sep 2023 19:35:07 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Tue, 12 Sep 2023 19:34:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bk/HNJHFqyZ8sovJIbLEpik5kNAGsK/6ZnZsqPKJDg/fIJ5vbiKyusa0dp97H6JUWZSf2I3IiF03cqE6q03aWItE8Q0RsEZcPVUegYsIT0aB9NheyLdsY8yDanwnEFitWhPdODuviQeAGms4SNJwBPIAQBLkdc1Ab91m+NExZPAcIna0vPHouXR/NzZ34ayOijcMpdt4CydQt6f+elv7sWPuvavx8VZQEgusCrl8NyQ7Gv0kOjClLLhuT5IhCi4XLgidgPj5MYX8+SV+ZIAEKJawWbgHY9eYr4kvp+zXsmsoMkPjiD2EU38Iq1kpRgSc94vOAT+0zESilhPO1+LhZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lODDBleXIaFgH8M8H8w71iOqIs/Aj54vMQ7xcv1z5rk=;
 b=kP/k7IkbZLW0PKbOpI6xV2/o0De84dMlWPsRBDOThe4ct4p+ShNyi6fqQL0cd4zUQVkkqYfMhv7t0MRBZ/68bLyHqioGJu2xmIwHYly2MAd0WRp66d+nDIMWGp3z0iaCcZCvGPVQI4w/SFWxE8H4ulU0QeQS1iJoQjTLgqbvKNBz55YDc5/akKevX/VwxsdmUTwFQQzJoV+YZjwVNKwZooFQCjwb/KTxDbn8ond9s5PIQ3GtA5XWGZYp8RYrpQihKlIOIz+uT2/8SzFiF2DCp98BGS3KYNVN+JCua5mfKn4C4XYLjWRa/0L1d4p0givQt6ElDYyg7/xw7s2UPRVlcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BL1PR11MB5270.namprd11.prod.outlook.com (2603:10b6:208:313::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.37; Wed, 13 Sep
 2023 02:34:56 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::ddda:2559:a7a6:8323]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::ddda:2559:a7a6:8323%7]) with mapi id 15.20.6768.036; Wed, 13 Sep 2023
 02:34:56 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Baolu Lu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Will Deacon" <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        "Jason Gunthorpe" <jgg@ziepe.ca>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>
CC:     "Liu, Yi L" <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4 09/10] iommu: Make iommu_queue_iopf() more generic
Thread-Topic: [PATCH v4 09/10] iommu: Make iommu_queue_iopf() more generic
Thread-Index: AQHZ1vydYVSBpw8DUkS1M41ymLRuMK/6p/jwgAGR2gCABkO3EIABz/QAgAECbfCABnSVAIAJh5mQgABh4gCAAnd2QA==
Date:   Wed, 13 Sep 2023 02:34:55 +0000
Message-ID: <BN9PR11MB52769C830A65FCE6CBA037278CF0A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230825023026.132919-1-baolu.lu@linux.intel.com>
 <20230825023026.132919-10-baolu.lu@linux.intel.com>
 <BN9PR11MB52762A33BC9F41AB424915688CE3A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <cfd9e0b8-167e-a79b-9ef1-b3bfa38c9199@linux.intel.com>
 <BN9PR11MB5276926066CC3A8FCCFD3DB08CE6A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ed11a5c4-7256-e6ea-e94e-0dfceba6ddbf@linux.intel.com>
 <BN9PR11MB5276622C8271402487FA44708CE4A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <c9228377-0a5c-adf8-d0ef-9a791226603d@linux.intel.com>
 <BN9PR11MB52764790D53DF8AB4ED417098CF2A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <eca39154-bc45-3c7d-88a9-b377f4d248f9@linux.intel.com>
In-Reply-To: <eca39154-bc45-3c7d-88a9-b377f4d248f9@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|BL1PR11MB5270:EE_
x-ms-office365-filtering-correlation-id: 835d7930-8156-4793-571e-08dbb4020468
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jjuT4JvuzE8G2koseetmsm6Jbaruz7Azccrdpi46HRe4NW+g7CroMiZZvKhynvUiV4NKVdg9tyVYHYXJz86WOeQ+w3kv4i9H/ItSM3Yr6TXa6QyzH0wdSkVzZ/9bCcZaPkLh89rcBqXzNl9d5DyuisjSe8RDOGZ7GAQq2ceeMmlNI69cnV8FYuyQLiMhCmxn1WPFUvqAVjLTV9GaPwmmBQfnSrPjPmU8XS0Zz5HO7+Cw7xH65ZDez+QSECROXnq8lB86fU2JTdXooAAz0ayAqOECmNzkqW1J9otfcnVwmx83cnYydU2TqXCsKerFGz4/2WZZfLgX0e4MhRWlAkkI2llCZ+zp86UMLvJ85s2l1kDtBgtboCV+LAnv7i+J7K2UHIDoWUmco8DDT3D6ivflKB0uGwOow5Ceouhdnfh4zrwZwA6Wliu0L3o6IQHfVFgn26xvB3zw+kdtdbhoSnYSwY0V0QxTb0LRr8GcZGH5lVjmVdv3o2BUeup/otOtQ4GOA+9xtGou1iOUXQSCoI6lAi2TIF3T14+6lpNNc9CFkZE5eGRTB0Aywbh5/DRkTUypnBqjFjzM47nrJ/U8EgE/mpotzld8EVMTf5J7YBE8ZNA1RRXbaaqhSZO4ZP9xz9Vekb/OjsXXltP3VpQ5BwtVvQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(376002)(39860400002)(136003)(366004)(346002)(186009)(451199024)(1800799009)(83380400001)(76116006)(41300700001)(316002)(26005)(7696005)(53546011)(6506007)(66556008)(4326008)(82960400001)(478600001)(64756008)(66946007)(8676002)(66446008)(66476007)(8936002)(38100700002)(52536014)(5660300002)(54906003)(122000001)(38070700005)(110136005)(86362001)(2906002)(7416002)(33656002)(55016003)(71200400001)(9686003)(41533002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YVIzUW9DMkRPQjgyT0VqbDdlb0RLQ0RxQlo5VG12bHdEZXg1czJ0VGtxMmhY?=
 =?utf-8?B?NmhKYXJrZ21LNTBZUXlpS1NqUGVuc1F1NXM4a0VFWmtMeFN4T3NoVXBueHF0?=
 =?utf-8?B?Tm1IU0xGMGdIdGRHbW9ITmQzWHl2aW1walgxZWV5V3l4UWw1SjNQL0ZRcHJv?=
 =?utf-8?B?SXU5K3J1d3J1RGJKN1ZMNlBWQzNObzZNODZ4amx4bCs0clZkbUV6N3Yxdngw?=
 =?utf-8?B?NE9KVFlQN1RSNER4cEx5L0pFVEdKS0NxYm1TTGtxQldMeWNwcDBlejlWVHU4?=
 =?utf-8?B?TEVUNmFkMnBSeUFlZzRwSnBGOXJYUWJ4eWNvQU9TSXh6WlZYU0N5WHFkMy9n?=
 =?utf-8?B?SE5TNzQvc3pVVS82ZnMrdTdJZEwzMExSeHVSZ3YvUlo4SG1iZkROclAvSXZy?=
 =?utf-8?B?b25CYndwRnJpT3BxQU1OUFV2MlpRejV4S2t3NmtodkNMSFNkamVZYzVQQjk5?=
 =?utf-8?B?aHBJUFh2OEpDUWlqYlpoelhDQzNHQWVWOXNYOG1ScWw4M093ODQyaWxKblRL?=
 =?utf-8?B?eFh6K29vajJMdGpKUmdNNWtaK0NYM1dzREhpQ2JOS1ErcHhpVE5pRm1WbWI5?=
 =?utf-8?B?MTZEZjlnTXl4THdLcEp2K3ZxNUZXWmFSNVVNOWhEOXUzOWVXUUYxVHp1VmJT?=
 =?utf-8?B?NEJ2dUZIM09hWVdBU2RHUEFPdkxFMmF4Sm1acGJSSTR5WlhKb2pmdDVDaC9G?=
 =?utf-8?B?MEdCaHRkUUZNSkQ3YmJYbzd5YjkxV1NVU1B5S1g1clhFUjdhUnliSGNrTW5I?=
 =?utf-8?B?SGU5LzdWT2ovV3ZrVWIzSlRIWk1wczFwWnVIS3BJZitJcU1QQXFMS1BISWwz?=
 =?utf-8?B?RzVqclpWOVJMUjJtYTEyYkZob2FHU0tUM0I3MVNreDVlT0NXMHRXWjByd0o2?=
 =?utf-8?B?WFZtS3dhbmUveWg2NzNOR3JoTmRSSndLRWFRNlcrNmxuSm13QVhaK2hXUWpn?=
 =?utf-8?B?ajMwTlNnRlBObXlSZXlhSGs2WGJ5eFM5OXhVWHh5WXZnSDFkTmRSWFZqd09P?=
 =?utf-8?B?b1ZMYVJtaWcweTRDWXM4UDduMU1MS1VLSFltVGplcXdSZWVQbUlDbGljT0lZ?=
 =?utf-8?B?YkpHM2RsS2Y4MHlrSlFLdFQ4NTdJT2R2N3pSMTRpelpPUEl6M3VLZjdNZm8y?=
 =?utf-8?B?NWIzYkNnd0VGNUhxaUEwMW1MZ05RR2dab2JOSUZVbDAwRzlSdUJpWVI2R0dC?=
 =?utf-8?B?VnFVczBNNERISG1CRzBYR1FGeUVXOTF1Z0FHUVNVZEZFMllUMWZSWFNuSk1M?=
 =?utf-8?B?eGJCOWFDcDZrVkVoUEx1My9SbU5KSVNXOXdqa2djcXpwWEhzMSs5ck1QeU1P?=
 =?utf-8?B?cWE0RkE1N01vdU9qamI0OVNGZXhvNDIwcHY3NEU1VjVRWGFZdWFLKytXTnRC?=
 =?utf-8?B?WmZ1ajJsMmFhYXBCamRLZmQvWnRkSXpjbXBhRDkrNEUwOWVFZTJSWFdxNDgx?=
 =?utf-8?B?OGtOcWxNUlp0c2FaVncrb3V5THNFNGJLbURmN2hnTXRjazd0TlRrOEdITE9G?=
 =?utf-8?B?TElzWktlVlFod05LV1R1VEpIZXRCdzdhcWNUemxsMEpxVTBRMkM3eDlaYWpv?=
 =?utf-8?B?Sy91bGlSZHpwNU9HcEhGZkQyNjFhMzQxSCs2Mis4MVRqY1JpVGlLMjdYdDZE?=
 =?utf-8?B?ZlZFZUQ1eTlpRWhBVml3RmVYbGhVa2I5Q21tRk4vUmR6bWFxd1QzSHRLNnBM?=
 =?utf-8?B?OFppNTFUUktJc1h6OThYMk1uTE82OGNsMlhsRWdBKzFjMUJSWUxXRFdFTHVk?=
 =?utf-8?B?NXRaRE51OVVJaGlFYWZOL1grcm1DL1NkdDEvT0EwSGtjdGZ1WE9UcjRuQXRL?=
 =?utf-8?B?UzZaMTVDS2RXdUlyZDJydkg2L0hVQW44TTYxT3hUd2N5VG03SktaM3lZbEpC?=
 =?utf-8?B?ZFIrd3U3ZC9QaVBOWDlzSnV1akc1SGRFRktEb0V1UzZpQW1IczFnelJqcnpP?=
 =?utf-8?B?cnVEajl6a2dLWkVlb1JPb3Z6WkY3RDdadkdQNDhBbzhQNWxITmNKMDRjQkx1?=
 =?utf-8?B?SENCdi9yV3hOeUtnTjRzVFl3KzM2citVeWdvekwwN2ZOZE9XT3NIR0JYS0g4?=
 =?utf-8?B?SDhGK0NqUHNpWlF2K1ByZms1ak1yV2xVMGVES212bDZaVGx0eHhEU0xQM0s5?=
 =?utf-8?Q?v4PMfPAL12cmeyCcuiu8MYryc?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 835d7930-8156-4793-571e-08dbb4020468
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2023 02:34:55.9760
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ml5cLT1TaLNdDVKPn7qbf7rj0UUoNIKiQY8tVOM7mZg1VI0TlsHh1MX/1Qv3wJA4gWYBSxSjIR/kXJpsx9kGLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5270
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBCYW9sdSBMdSA8YmFvbHUubHVAbGludXguaW50ZWwuY29tPg0KPiBTZW50OiBNb25k
YXksIFNlcHRlbWJlciAxMSwgMjAyMyA4OjQ2IFBNDQo+IA0KPiBPbiAyMDIzLzkvMTEgMTQ6NTcs
IFRpYW4sIEtldmluIHdyb3RlOg0KPiA+PiBGcm9tOiBCYW9sdSBMdSA8YmFvbHUubHVAbGludXgu
aW50ZWwuY29tPg0KPiA+PiBTZW50OiBUdWVzZGF5LCBTZXB0ZW1iZXIgNSwgMjAyMyAxOjI0IFBN
DQo+ID4+DQo+ID4+IEhpIEtldmluLA0KPiA+Pg0KPiA+PiBJIGFtIHRyeWluZyB0byBhZGRyZXNz
IHRoaXMgaXNzdWUgaW4gYmVsb3cgcGF0Y2guIERvZXMgaXQgbG9va3Mgc2FuZSB0bw0KPiA+PiB5
b3U/DQo+ID4+DQo+ID4+IGlvbW11OiBDb25zb2xpZGF0ZSBwZXItZGV2aWNlIGZhdWx0IGRhdGEg
bWFuYWdlbWVudA0KPiA+Pg0KPiA+PiBUaGUgcGVyLWRldmljZSBmYXVsdCBkYXRhIGlzIGEgZGF0
YSBzdHJ1Y3R1cmUgdGhhdCBpcyB1c2VkIHRvIHN0b3JlDQo+ID4+IGluZm9ybWF0aW9uIGFib3V0
IGZhdWx0cyB0aGF0IG9jY3VyIG9uIGEgZGV2aWNlLiBUaGlzIGRhdGEgaXMgYWxsb2NhdGVkDQo+
ID4+IHdoZW4gSU9QRiBpcyBlbmFibGVkIG9uIHRoZSBkZXZpY2UgYW5kIGZyZWVkIHdoZW4gSU9Q
RiBpcyBkaXNhYmxlZC4gVGhlDQo+ID4+IGRhdGEgaXMgdXNlZCBpbiB0aGUgcGF0aHMgb2YgaW9w
ZiByZXBvcnRpbmcsIGhhbmRsaW5nLCByZXNwb25kaW5nLCBhbmQNCj4gPj4gZHJhaW5pbmcuDQo+
ID4+DQo+ID4+IFRoZSBmYXVsdCBkYXRhIGlzIHByb3RlY3RlZCBieSB0d28gbG9ja3M6DQo+ID4+
DQo+ID4+IC0gZGV2LT5pb21tdS0+bG9jazogVGhpcyBsb2NrIGlzIHVzZWQgdG8gcHJvdGVjdCB0
aGUgYWxsb2NhdGlvbiBhbmQNCj4gPj4gICAgIGZyZWVpbmcgb2YgdGhlIGZhdWx0IGRhdGEuDQo+
ID4+IC0gZGV2LT5pb21tdS0+ZmF1bHRfcGFyYW1ldGVyLT5sb2NrOiBUaGlzIGxvY2sgaXMgdXNl
ZCB0byBwcm90ZWN0IHRoZQ0KPiA+PiAgICAgZmF1bHQgZGF0YSBpdHNlbGYuDQo+ID4+DQo+ID4+
IEltcHJvdmUgdGhlIGlvcGYgY29kZSB0byBlbmZvcmNlIHRoaXMgbG9jayBtZWNoYW5pc20gYW5k
IGFkZCBhDQo+IHJlZmVyZW5jZQ0KPiA+PiBjb3VudGVyIGluIHRoZSBmYXVsdCBkYXRhIHRvIGF2
b2lkIHVzZS1hZnRlci1mcmVlIGlzc3VlLg0KPiA+Pg0KPiA+DQo+ID4gQ2FuIHlvdSBlbGFib3Jh
dGUgdGhlIHVzZS1hZnRlci1mcmVlIGlzc3VlIGFuZCB3aHkgYSBuZXcgdXNlciBjb3VudA0KPiA+
IGlzIHJlcXVpcmVkPw0KPiANCj4gSSB3YXMgY29uY2VybmVkIHRoYXQgd2hlbiBpb21tdWZkIHVz
ZXMgaW9wZiwgcGFnZSBmYXVsdCByZXBvcnQvcmVzcG9uc2UNCj4gbWF5IG9jY3VyIHNpbXVsdGFu
ZW91c2x5IHdpdGggZW5hYmxlL2Rpc2FibGUgUFJJLg0KPiANCj4gQ3VycmVudGx5LCB0aGlzIGlz
IG5vdCBhbiBpc3N1ZSBhcyB0aGUgZW5hYmxlL2Rpc2FibGUgUFJJIGlzIGluIGl0cyBvd24NCj4g
cGF0aC4gSW4gdGhlIGZ1dHVyZSwgd2UgbWF5IGRpc2NhcmQgdGhpcyBpbnRlcmZhY2UgYW5kIGVu
YWJsZSBQUkkgd2hlbg0KPiBhdHRhY2hpbmcgdGhlIGZpcnN0IFBSSS1jYXBhYmxlIGRvbWFpbiwg
YW5kIGRpc2FibGUgaXQgd2hlbiBkZXRhY2hpbmcNCj4gdGhlIGxhc3QgUFJJLWNhcGFibGUgZG9t
YWluLg0KDQpUaGVuIGxldCdzIG5vdCBkbyBpdCBub3cgdW50aWwgdGhlcmUgaXMgYSByZWFsIG5l
ZWQgYWZ0ZXIgeW91IGhhdmUgYQ0KdGhvcm91Z2ggZGVzaWduIGZvciBpb21tdWZkLg0KDQo+IA0K
PiA+DQo+ID4gYnR3IGEgRml4IHRhZyBpcyByZXF1aXJlZCBnaXZlbiB0aGlzIG1pc2xvY2tpbmcg
aXNzdWUgaGFzIGJlZW4gdGhlcmUgZm9yDQo+ID4gcXVpdGUgc29tZSB0aW1lLi4uDQo+IA0KPiBJ
IGRvbid0IHNlZSBhbnkgcmVhbCBpc3N1ZSBmaXhlZCBieSB0aGlzIGNoYW5nZS4gSXQncyBvbmx5
IGEgbG9jaw0KPiByZWZhY3RvcmluZyBhZnRlciB0aGUgY29kZSByZWZhY3RvcmluZyBhbmQgcHJl
cGFyaW5nIGl0IGZvciBpb21tdWZkIHVzZS4NCj4gUGVyaGFwcyBJIG1pc3NlZCBhbnl0aGluZz8N
Cj4gDQoNCm1pc2xvY2tpbmcgYWxyZWFkeSBleGlzdHMgdG9kYXkgZm9yIHRoZSBwYXJ0aWFsIGxp
c3Q6DQoNCiAgLSBpb21tdV9xdWV1ZV9pb3BmKCkgdXNlcyBkZXYtPmlvbW11LT5sb2NrOw0KICAt
IGlvcGZfcXVldWVfZGlzY2FyZF9wYXJ0aWFsKCkgdXNlcyBxdWV1ZS0+bG9jazsNCg0K
