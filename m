Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2262C597FF7
	for <lists+kvm@lfdr.de>; Thu, 18 Aug 2022 10:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238169AbiHRITN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Aug 2022 04:19:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232816AbiHRITM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Aug 2022 04:19:12 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA0A16B162
        for <kvm@vger.kernel.org>; Thu, 18 Aug 2022 01:19:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660810751; x=1692346751;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=qAFV1zFMLl03Ch5ntRfSFgHkZAjI7OgEZwKAdbMis40=;
  b=kp5EqyXoLi70u969v/AtPJ5Lo/w68Er3/kFvaZsuvhoDpjJzmWolZyov
   fdiTCiKgjxLrv10xCw1alq4TSY9UhckHnqPcEJmW4GKGq+aBaJk5Dda6l
   LsLbPjvZaBvxzfTE3r3qtRHY1lTPSPECQe3mPSWUrW1c1w6zUVDhmENT2
   OZolyouixNj5L9IJl03NStXejrXyohW+y3NeOaQRdkVJv6aTaVRTjOH3S
   SW+NJ+18zh/9tSs6NUItJJgu9LYOI+eew+BAMQaOcQYlCbkF4vNNgHMkS
   KEYe8CneRs/V9NISZLZbqaZZU2lBHQoJSzLo2iH+LK9t8vDEIQ0iC/YOA
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10442"; a="272466932"
X-IronPort-AV: E=Sophos;i="5.93,245,1654585200"; 
   d="scan'208";a="272466932"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 01:19:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,245,1654585200"; 
   d="scan'208";a="675975944"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga004.fm.intel.com with ESMTP; 18 Aug 2022 01:19:11 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 18 Aug 2022 01:19:10 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Thu, 18 Aug 2022 01:19:10 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.41) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Thu, 18 Aug 2022 01:19:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g96R4uhRt7RxFO28D95P2yCpomqcngGop59O0yUsO3T5MzXIOaYrbCxYkCpR7TRdYORzPVhWU6crhtIWOiabxhfTjvXkk44Ju+m122opJcDIQ22lBk0WJ/BSOjCv+1PE/s9qwgz7P0RgtpDcmAayrzNWm8zVavrDNn/czIAu7nS6PtW30pn3zUloc1V1WalI9yubv/LWG5uPximijTzgiRVW8Id8kpw8XuG44+JIHWT4jnh2k7YepUwXlmukKBegtev9NkY3Cxjs0E+WNtltp3DWeyelMnvRc9oWg5vD8nAFscz3k1g3U/7YAviPd2RiBAISh+dNKTOPKLf/rBL4iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qAFV1zFMLl03Ch5ntRfSFgHkZAjI7OgEZwKAdbMis40=;
 b=YAOs1jZJ0rPWPZuMkaOxjO7WtH75E+96jKphcb32n/IhP2Ak/fId2hXo322J6vVXafnnBlXWAX1YxxHHQ/MvRybLLEgQbk6TU/eAGsG1ch78Jrnv1rbVke4sgqwRnopCUAlME5vcf6aQKUW3cZI6rlRX/NNyjQw9hjfrF8Gc+OVraKc/AhX+Cj7tgiVAdkSQmSYwRr4FPoV/SxOYR6XLsoRvcHBzG2DKKR7qPdMV1F3inzdIgehOyGcOKGjaVrzMNYNuL9yQtl8bxYJvVhgXGZ5S83WCMtJWkfPrDa/WqPZHDy4oFgZKoNymWo/iyHRhqbkt7HWkIxoh2lT9fC2/Jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ0PR11MB6816.namprd11.prod.outlook.com (2603:10b6:a03:485::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16; Thu, 18 Aug
 2022 08:19:09 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::301a:151:bce8:29ac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::301a:151:bce8:29ac%3]) with mapi id 15.20.5525.011; Thu, 18 Aug 2022
 08:19:08 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>, Jason Gunthorpe <jgg@nvidia.com>,
        "Alex Williamson" <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH] vfio: Remove vfio_group dev_counter
Thread-Topic: [PATCH] vfio: Remove vfio_group dev_counter
Thread-Index: AQHYsMefUhZ1IgENlUynDdc+cU4pTK20SJAggAAKgACAAAGT4A==
Date:   Thu, 18 Aug 2022 08:19:08 +0000
Message-ID: <BN9PR11MB5276D734AF7794A504DB19488C6D9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-efa4029ed93d+22-vfio_dev_counter_jgg@nvidia.com>
 <BN9PR11MB5276F9EB0295CBD485A58D308C6D9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <23498829-6ebc-09cd-f9ce-635a17f1b709@intel.com>
In-Reply-To: <23498829-6ebc-09cd-f9ce-635a17f1b709@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 89a7e7b2-1bd1-46d9-42f5-08da80f25303
x-ms-traffictypediagnostic: SJ0PR11MB6816:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4ShLDdu6T0KryUkIe5VWuD5zjopHDiANdgvmJUcupZg1v0PpcRwmaJWYpIB5moclA+X1EIBXxLAX5WCahEtiZzwD0qJiLd6qGeyLeaJQZ4G9q2u65SbeH88gKGCqUF74Og0c1hvEkAlbpDY8Tzyp+yjQey4sGQ3ch/NLvxZvH7PLu+QlrDFLTLPJ0BM1zWeRTm8aYHn0HxXmPym5+KKnlRWDUBQWTpc0RDby3aXpl1G3wVaHZ2jOkwsLI/4deUU5OdbLebDRDjdNz5dd2OBrhIrfeOg80sLw+GbX63hXa0X6bYd7uhEWgan3PKpp08JyATutYDiEEKC5F6jpwSHmM69sqwQfezWRa8pneSn8EAYI3McSMncnn0fMByKWigLfkAfXF1lki/q8c2pRnREoPNoExk7Xs4UYAeqQZAp1a61D4p0o/whjxKpb7uPBjWRR1bdkVBoAU1YvLuWI413v46Rldlv4YfHwhK6cCzr85ZOtUeFBJpbJzRkguVwab5xc0ihRHZmUyRUfbzSdUqwHx3puyLvYZU1tR75aT3qwxSphjupw2p+GrvJfSj3+xIS7lXQ4+6dxCsybFHrjgSJkYGBxy0zQeHpqw/zFW077T8Z+RhOTEHYUQDRD4F7HvUMj4WU9OetPDcDGZ379XhHtyx3zPDEgOh003jIeDhu2iXtqMGVsiTyd1PasLuDvZMF1t1/5RDSVjlmdlfbqHsTalhrczEyj9v5sPyDhq7EIKV1+Yrwf2Zqog36EQ48upQOf8xoxnzTwaJO0Rpek08eFBUX++4j0raaYZUia5zBW8og=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(376002)(396003)(346002)(136003)(39860400002)(53546011)(66556008)(66946007)(38100700002)(66446008)(64756008)(82960400001)(316002)(8676002)(66476007)(38070700005)(186003)(5660300002)(86362001)(76116006)(6506007)(52536014)(8936002)(55016003)(2906002)(41300700001)(71200400001)(478600001)(7696005)(9686003)(45080400002)(26005)(110136005)(966005)(33656002)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c3FMQlA5bm5BZjY0WG54OXpSaFlQSXgyR2d3MkVMYnBaZWFEUFVNUE5iTk0v?=
 =?utf-8?B?eHNSZm5taDkvSzI5dkVEdEplL3VROVAvNzM4QkxpclA0NU1TUWVpejJsUzVh?=
 =?utf-8?B?dnMyVzY2cG9hdmNiQjRmamF1bXlSYzdiVjFHOEwvbGRUQTZUQm9kNlk1Z2Vo?=
 =?utf-8?B?ZXJhMENISk5SYUJTSUZJYzZ5Zm9LZ1YwRm9xK3hCN2Q0UldoY0VmNlVkTXZu?=
 =?utf-8?B?bFh2dCs3NEtzcWZBSTliclZ3ZUx0Z1FqVkxQcEFmamdMeWJFRGxpYWlEN0pv?=
 =?utf-8?B?eW4reWdjQzRyQnExczRIVmxwKzQrWjdCQzk0eWtMRnhNNnl4cThjSGxRVUtO?=
 =?utf-8?B?cmkzWGVObzNqd1hXLzhHekt6cERGV0F2L1lLK256dUhPRythb3RRTDlGS2x3?=
 =?utf-8?B?QXlhdWlqSTY1MDZIMXYwZEYyS0txaWl0UmhCWktXMFMvcHlVRC85dGNnV09k?=
 =?utf-8?B?OHJMWDVPRFM1SVNMU0w1TUd6R01OOHZFZ1A0TVpUa2lEa1BDa3F5Vko2UzNl?=
 =?utf-8?B?VU92enhmSXNnZW1wNFhTeExhTERUbDRrc2YxY0FQK2dUU1FLNU51YVU1VFc5?=
 =?utf-8?B?NWdSODJZQkJhY1ZYdXNJNWUxN3BmcE9NYzZFNzZ1c0lkNzVQdTdUcDFTSHB1?=
 =?utf-8?B?V1BhYlVFZWEwYkM5SjR0TkhZV0V3YWRwOTlwcWgzckdWekUycHBaQkZ5S2Zn?=
 =?utf-8?B?NXJpNHdBL3hWNElydEJvUkZKU1o0Tkxsbmgrb2FIVkVOcWJiSWRNejI4K1pm?=
 =?utf-8?B?WVE4UWU4a2ZXZndrSXhUdUNOZ1VwZFNLYWJQTy9iRVRnWnBFRTZQQUZRVXkv?=
 =?utf-8?B?b3JiYTFXSFU3K1o1M29kemFZNElKZGgyUXZSeHJkWUZNeGlpQVVITTVXWGhj?=
 =?utf-8?B?cjd0YlkwL00zczZHTUQvTEM4ZGU3OUpBRnQybUhVTXFXMENRWTJnY1FLYUhX?=
 =?utf-8?B?T0ZyYy81NUFmSmVDa01RNklWanZWVUlsUXRWYWsvVm5Tbm5LaldPaUxkc3Bh?=
 =?utf-8?B?YlMyNStJTER3R3Z4TFFBK0lpT2pPcDZ4UzRLTER3S3BLMHRWSkU2WktkYnYz?=
 =?utf-8?B?UFBobjJXRXlTdXh5b1d6Q0VEN2FTOW56UGtObWd2cm1pbGJtQTZJd0ZuRTBF?=
 =?utf-8?B?Qm9PMTNtVVMwdm12eXhkM3FuNk5RU2YxditmblRTMGZTanlIcUhkcC9hZ1U4?=
 =?utf-8?B?S0p5REtYT25VZkszMWlXTDlSV3IxK2lRc1QvcDdMOFFXY1pWMTRyT3BVV2Yx?=
 =?utf-8?B?NExJRWh3RUs5MWFzRzF1MHBqbmpUd0lvcFlHM2p3bm9PWDFBZXlpeW8zYW92?=
 =?utf-8?B?L2k1NkFCTHNEOUx2WDZsQ3cra0EzTkt6MDd3RnhpejNHeWVzRnlDL29MQUZt?=
 =?utf-8?B?ZEkrUFBYanc3Sko3a1p2NUhZak1JcWdReG1STDZzS0F2YWpNamFIdEtodzEr?=
 =?utf-8?B?MmNRS0hERlFaMHBLa29UR2R0YWFaMnp0UC9FbmFnTWpvWFYwOXVaaWVjcG9q?=
 =?utf-8?B?dTk1QWZ5VWc1RXBmdktXMzB3QjNVN0ZHOE5STW5hRUV3dnBkWXFyR0JMV0JN?=
 =?utf-8?B?MXk5eENnMjlBTDV6TjdjcUhmQW4vOTVTSC9UaXN0M2UxNFNaSmVVakdJNzdG?=
 =?utf-8?B?a05iNFVDM1FHTHBnZkd6anRlSUJCN25SYnhjN25IU0duZ3BtU2ZDblB4eHIy?=
 =?utf-8?B?UzltNUJ5S0xIQmNPaVlieXFLTnNaMUVacG80Q0hUaEF5VDJFL0EzbCsxbUpm?=
 =?utf-8?B?TUdHbEg2WGcrTHMxbms4LzUweFFsZlBWU0VqRmMvWWxxUDFnemVaZUYvZnBa?=
 =?utf-8?B?UG9jRElWN2tnTk5JeThrNnpNZm9FL3lEUlZ4ejdQdWVsNE11b1JuampaclFE?=
 =?utf-8?B?Z3JSR1REOE5zbmFwdmNNZHR1dXRXcTlRbksxQ3h2N3lVVzRreHFWWVZpWlF3?=
 =?utf-8?B?ZGNyWU9HMS9aRkpaMmxEbzJHT3Izck9zckFRTldIM3QyVnhnTUErSU1aaTZx?=
 =?utf-8?B?MlRScEJHM2lNS0dBaFRIOVhvR25qNUtJM2Y5K1BOTURNM2J0QVdScjZ3UURG?=
 =?utf-8?B?cHN3SHRVL0J2YVVPSUdoM1BvQXBuaG9OQTM4YWppWkFEU05YSEhZYVlIYjNB?=
 =?utf-8?Q?EnbgMCPHjo32DPC+feikshhyw?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89a7e7b2-1bd1-46d9-42f5-08da80f25303
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Aug 2022 08:19:08.9041
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3B6/utpNzVOyS+ByBxjMUCnMhxXrCddNdQwRW2bkRyD9hc8zDjivSAD+lA3Z0Y4Pr/CntoxPQFCfKjLC/L7VGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6816
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBMaXUsIFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gU2VudDogVGh1cnNkYXks
IEF1Z3VzdCAxOCwgMjAyMiA0OjEzIFBNDQo+IA0KPiBIaSBLZXZpbiwNCj4gDQo+IE9uIDIwMjIv
OC8xOCAxNTo0NiwgVGlhbiwgS2V2aW4gd3JvdGU6DQo+ID4+IEZyb206IEphc29uIEd1bnRob3Jw
ZSA8amdnQG52aWRpYS5jb20+DQo+ID4+IFNlbnQ6IFR1ZXNkYXksIEF1Z3VzdCAxNiwgMjAyMiAx
Mjo1MCBBTQ0KPiA+Pg0KPiA+PiBUaGlzIGNvdW50cyB0aGUgbnVtYmVyIG9mIGRldmljZXMgYXR0
YWNoZWQgdG8gYSB2ZmlvX2dyb3VwLCBpZSB0aGUNCj4gbnVtYmVyDQo+ID4+IG9mIGl0ZW1zIGlu
IHRoZSBncm91cC0+ZGV2aWNlX2xpc3QuDQo+ID4+DQo+ID4+IEl0IGlzIG9ubHkgcmVhZCBpbiB2
ZmlvX3Bpbl9wYWdlcygpLCBob3dldmVyIHRoYXQgZnVuY3Rpb24gYWxyZWFkeSBkb2VzDQo+ID4+
IHZmaW9fYXNzZXJ0X2RldmljZV9vcGVuKCkuIEdpdmVuIGFuIG9wZW5lZCBkZXZpY2UgaGFzIHRv
IGFscmVhZHkgYmUNCj4gPj4gcHJvcGVybHkgc2V0dXAgd2l0aCBhIGdyb3VwLCB0aGlzIHRlc3Qg
YW5kIHZhcmlhYmxlIGFyZSByZWR1bmRhbnQuIFJlbW92ZQ0KPiA+PiBpdC4NCj4gPg0KPiA+IEkg
ZGlkbid0IGdldCB0aGUgcmF0aW9uYWxlIGJlaGluZC4gVGhlIG9yaWdpbmFsIGNoZWNrIHdhcyBm
b3Igd2hldGhlcg0KPiA+IHRoZSBncm91cCBpcyBzaW5nbGV0b24uIFdoeSBpcyBpdCBlcXVpdmFs
ZW50IHRvIHRoZSBjb25kaXRpb24gb2YgYW4NCj4gPiBvcGVuZWQgZGV2aWNlPw0KPiA+DQo+ID4g
VGhvdWdoIEkgZG8gdGhpbmsgdGhpcyBjaGVjayBpcyB1bm5lY2Vzc2FyeS4gQWxsIHRoZSBkZXZp
Y2VzIGluIHRoZSBncm91cA0KPiA+IHNoYXJlIHRoZSBjb250YWluZXIgYW5kIGlvbW11IGRvbWFp
biB3aGljaCBpcyB3aGF0IHRoZSBwaW5uaW5nDQo+ID4gb3BlcmF0aW9uIGFwcGxpZXMgdG8uIEkn
bSBub3Qgc3VyZSB3aHkgdGhlIHNpbmdsZXRvbiByZXN0cmljdGlvbiB3YXMNCj4gPiBhZGRlZCBp
biB0aGUgZmlyc3QgcGxhY2UuDQo+IA0KPiBzZWUgaWYgeW91ciBjb25mdXNpb24gaXMgYWRkcmVz
c2VkIGluIGJlbG93IGxpbms/DQo+IA0KPiBodHRwczovL2xvcmUua2VybmVsLm9yZy9rdm0vQk45
UFIxMU1CNTI3NkY5RUIwMjk1Q0JENDg1QTU4RDMwOEM2RA0KPiA5QEJOOVBSMTFNQjUyNzYubmFt
cHJkMTEucHJvZC5vdXRsb29rLmNvbS9ULyNtNDJlYWYxNTQ4MjM1ODEwODINCj4gMGQ3ZTJhZDE0
OTEwOTJjNGIwYmJjYmENCj4gDQoNCkFoLCB5ZXMuIEkgZGlkbid0IG5vdGUgdGhhdCB0aGlzIGlz
IGFscmVhZHkgYWRkcmVzc2VkLiDwn5iKDQo=
