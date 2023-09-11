Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 791E679A390
	for <lists+kvm@lfdr.de>; Mon, 11 Sep 2023 08:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234440AbjIKGfc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 02:35:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234317AbjIKGfb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 02:35:31 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D7DFEA;
        Sun, 10 Sep 2023 23:35:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694414126; x=1725950126;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XSfVQm+Gq5fbjDMJ/qDf5u/2wgEklFAdlecevkhXZ2Q=;
  b=WIh+/3lj+7oVqnjd26UuTuHCeQNRKCnjGpMqwkbRblVu9weFw+lP/eac
   Uvrkp0x5bhoWpRbwM9I23/RZlMrII/20zP/W64hEEPjQpSD4yhqGUotWU
   asD/TlJMbwujxOA8wpsIDRlbXSW1k34AgiX2v2X6ivojvc1xP0S++EP3r
   RqvEBsSSxwmcwtWlYgo6wt/qbK7hzn2zGHLW9mrySXPRoBHbhKVxKJ0yz
   hhzTsdT/D8EYYHudnVzvnR1pZopr+eOnGSc5BPhcjs8QmDCBXgFIaLVKh
   6WtdehH/y8QcaG6GewKSVmjLGpfdD4OKHf1jKaz5t7EIv9GEbFmVUrq2r
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10829"; a="408974582"
X-IronPort-AV: E=Sophos;i="6.02,243,1688454000"; 
   d="scan'208";a="408974582"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2023 23:35:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10829"; a="916922403"
X-IronPort-AV: E=Sophos;i="6.02,243,1688454000"; 
   d="scan'208";a="916922403"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Sep 2023 23:35:21 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Sun, 10 Sep 2023 23:35:21 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Sun, 10 Sep 2023 23:35:21 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.175)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Sun, 10 Sep 2023 23:35:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oVYNR14cNrx2zQXnkPbR1pcITfu0SbSgQGkIFmCJpmiuIGzMnA9E0h+xui94QNYYFPU94eL+sgzkxOmgA/SThBgAAqXjGisNJOFob5eu8iLuaJA7+S5MeRbRCH71Mopd1q5HPJfu3XFopbMQvSB6PuVoebPIHt7wkqzBMPN8EonSNAjYuscb6cfViumspWQYLEFMiGYiNyjI7HlOne6qa3VojvCE/rB+tptMI2gUxvv/WTtOrSWz+JShR7E0Cxb5WtzPmUFHlK4OMssiwpOBFkhhkZZ1IjQU4ouYexT+YTHpCEWlUHuuAOnB6qImFinS46DiJmkuBs8QfcEiPrVDAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XSfVQm+Gq5fbjDMJ/qDf5u/2wgEklFAdlecevkhXZ2Q=;
 b=JURoiHPEdDydrjnA1N4YzBl2aexdxTGITpVVFh/g3vRU9ErW6VnS8F0+dXstlnoqLzrLcEcr1mYQ5WmeyrKbmhD4RwiUktxJawVdaO1LEr5uvAXJL48i4j7W8X4ldS9eUBNF/zuz1qKaKFx4JX62FoDaWMN/4WxxFPTBwEJyX2U9Z45JEH26aJQnvL88ioAw/Xy9BeRUUhNdy7RBtW40MqN1xQiaTxEjEjRh3IofUxEd8FOwKv3EPrOZGpQMxXLX9DJDLVU59jznD4B0H5czTqSTcrGcQJVuVtLlzMjvlK2efbvrR2NhVLyQfo66AUwwKz8LtZkdM242sjDcCM5eLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ0PR11MB8296.namprd11.prod.outlook.com (2603:10b6:a03:47a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.36; Mon, 11 Sep
 2023 06:35:18 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::ddda:2559:a7a6:8323]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::ddda:2559:a7a6:8323%7]) with mapi id 15.20.6768.029; Mon, 11 Sep 2023
 06:35:18 +0000
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
Thread-Index: AQHZ1vydYVSBpw8DUkS1M41ymLRuMK/6p/jwgAGRCACABkHzwIABseKAgAEiyiCABnOVAIAJgYCQ
Date:   Mon, 11 Sep 2023 06:35:18 +0000
Message-ID: <BN9PR11MB52768F9AEBC4BF39300E44478CF2A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230825023026.132919-1-baolu.lu@linux.intel.com>
 <20230825023026.132919-10-baolu.lu@linux.intel.com>
 <BN9PR11MB52762A33BC9F41AB424915688CE3A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <cbfbe969-1a92-52bf-f00c-3fb89feefd66@linux.intel.com>
 <BN9PR11MB52768891BC89107AD291E45C8CE6A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <67aa00ae-01e6-0dd8-499f-279cb6df3ddd@linux.intel.com>
 <BN9PR11MB527610423B186F1C5E734A4B8CE4A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <068e3e43-a5c9-596b-3d39-782b7893dbcc@linux.intel.com>
In-Reply-To: <068e3e43-a5c9-596b-3d39-782b7893dbcc@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ0PR11MB8296:EE_
x-ms-office365-filtering-correlation-id: febe0702-c5e6-4b5b-6238-08dbb2914401
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tognyT7yEPv8xjeF2w6NTbuDqJ5SgWSogQOpAjtf4/OAkBvqn507UfVxfuUxvb0BHC5X1yX3Z0NrMVzjy8K9hd74UFwxIdMCI/pi5JiuvOpm5do7Tz4U0CDswaiaPmWFcWweoKrn53eBX1wAhioHM/UnGYnKjJ0w6yrPojpJh2Snyc63eK2V5jc3erk2ozS2+a9DIY3K26PAv7ZfmwwWWa633wfWPFnMP9BCnGoq6DuKehy3YeyzC9xd1i70ZUn07aV+Gv9Ak1wB9DeT+H6cMkXpq0hO0KggRU9PB+yma16RFuMeaUFJaJEY4qCqX8sztAA401RJLPTB5c0AZxDHEY97B4euz0R28EW+FEl+nZoD7AoDweNcV08u9lRUWcxws7KfOudIbYxRKTZ0GooVz3ptCHeiIMBmaG/poPULfadjigMkcqBT/qfkbqDVZ2XQefuC3JEo6C5UCmKmLspjBNNhJKf4i9MeMXKn8hXMim1ZIpC9s+MPLU88tKw7+m1OvvdkR8IqRg/5MD+dRcZRCmvl1TcEOXWnWMHWv3HK75yE13a+QQBIwe5eiEl25HXJOEqZ1kt70yz51O38rHPtERzrqX5PrkahVtvsD+0W3l1jGaolrM0wGtjGrCl+kY8UC5CuRxhS2WpyfgdV9cMnwA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(39860400002)(396003)(376002)(346002)(451199024)(186009)(1800799009)(2906002)(52536014)(55016003)(26005)(7416002)(316002)(41300700001)(66446008)(66556008)(54906003)(64756008)(66476007)(66946007)(76116006)(110136005)(478600001)(5660300002)(8936002)(8676002)(4326008)(6506007)(7696005)(9686003)(71200400001)(83380400001)(33656002)(38100700002)(82960400001)(38070700005)(86362001)(122000001)(41533002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?T1I5SkoyNzFMaFhGa2NoVG5aU0NKaVN2Z0UyVWlMd3ZyUTJoQ3c2c0k5dVNB?=
 =?utf-8?B?Zi9EenpsT2Q1WC9vTXdxTlM2Y1FlSSswOUplZmRPNEVyenBkYnpwRUM5VmVa?=
 =?utf-8?B?Y0Y5V1ZwYTNVbXhOUldJdEU3Q3FFYmFoZnBKbG53THk3L0g2aEdRRFpaZkNw?=
 =?utf-8?B?TXQyeS9VQ0VxQ3dheHZBQXVialhZL1JuYkRhWlBqeUZ5bVJNQXU2cmdNb21D?=
 =?utf-8?B?VmpiN0czL1B1Y1pqaldrdk51aEpYT0dxUFJNZC9aYzRwR3JFSzBaTlJwUGQ0?=
 =?utf-8?B?RHV4SFR1ekFFU2pxZUFEZEQrUXBqK0tIMzNGTEs2eFpuZ2tHeE84UmZ2MEZN?=
 =?utf-8?B?OUgvS2hPTFF5UEprdGNWODBTQXBrYWZLekVPNDkxWk1UOFRVM09WQjg2TkMz?=
 =?utf-8?B?SzBGMEYxc3NLOEQ3Q081SzVIV1hyTnZqb2pXRmJwdE8zSjV5a2hvVzlGcXNu?=
 =?utf-8?B?ZnhyUWVPWkR2VkpkeXJsb0FCYmY4MDQxcnZiZmR2a2VEZWlvUXpnTUcyQXZa?=
 =?utf-8?B?S3ZTUFRpYVdqbkllc0hLcUNBSTNnVUJwYnVZT2RVdGFlNU9rTzNqbGpaeFg3?=
 =?utf-8?B?MHEvem1IQnM2TkJUVGl6UnB1WDFESTR4TDljQ1dCZTNpNW44R0xjVk83RFJ3?=
 =?utf-8?B?NWxyTy82ckVSVEtjNkQyNnVCemhZWHBDL0lzdUNDcmZHQm1zOC9KbGpZTlZM?=
 =?utf-8?B?MGlrWjRodlNRRFNJUW1TM2hDbUVJM0NtV29ZN3BNT3EzcmpnbERRQmVBdDJT?=
 =?utf-8?B?MGU3OTF0VGhPT0Q5ZUNrUTdPbk9CRXVrNE9kd3RpLzdGVUVYMDVob010YitL?=
 =?utf-8?B?eXNJTThLY2J4ejhOYm1GVm1DbXpXUmhuN0FQSXF4Z0hYS1U0UWM1MEdsOW5J?=
 =?utf-8?B?VXRFbURDbEdoVStpN0hDYmZVZGd4N1ZleDkvRTZ2WVFQOTFTV0VJMk1abHBo?=
 =?utf-8?B?Q0lyNHQrUWorREhDZ0JSMHM2di9PZnZ5cGpnZUU0b3lMTUVwYmdOd01XZzhQ?=
 =?utf-8?B?dTl1cUl2Y0Y2M1BGVVdDWDV0V1F2TFFkeXRkWkFoQllZeWpHQVl0R2UxUE9U?=
 =?utf-8?B?Z2I2dk15SHN1TFI5Z2k0bFU1RDlQZGdHWjdsZ0I4dXhuVFJFYWZxandtTzhB?=
 =?utf-8?B?Z3AxeHlmR3JIcFk1UzdQeWZCc3YwbFF3RlpPU2VCTEw0OHlWVEFySktzNWJ0?=
 =?utf-8?B?UVV6aDJGYTZIV2FWYUlHcHJoc0ZCY09LRUVxT2pOZUh1aHRKMFZnbG9pNUtI?=
 =?utf-8?B?S2dIaFdPQzJCaWQ1cWFJdjlabDVHR2RSeE15bi9tUEdGcVo2UHgvOXduYjRG?=
 =?utf-8?B?OWo1azVBQ29vZVV6dUcrTVppRElTRS9BdEkxYUdMM0lPYlY4YWNqbVJzOTdo?=
 =?utf-8?B?WWk2TWZDbU9nWWhMNVNXakdOZWN3OGpRaVRScGZZbVhhaGN4enRmdkd5a2hw?=
 =?utf-8?B?NWQxRXdqRXBiYWo0Q0FjNnl6K3NVTWZvdUlsS0tzSVJiVlh6MzloakVSQ1BN?=
 =?utf-8?B?Tlo5ZkNGS0V5QnlLL3FLcEdxZytlTFdGQUtsbkVwczBqWWE4Ymd0ZTNKSzBh?=
 =?utf-8?B?SXdqV0tiSklWUVpwTjZSWUtJWUR3TE1VZ01jdFg0cGMvQmNOWk5xTUxOSVVO?=
 =?utf-8?B?MEpOaElRTXY0WjZpVWJwNWg5Z1ZIWVc4NE9JRUh5SDNJSy9XQWJJVk8vL3dk?=
 =?utf-8?B?U2h0RU0xeTJ6UllPZTJPZnF6VkZkdkorSlNlZnU3SUltMEZBTjlrRjBLQVRK?=
 =?utf-8?B?ZjVkdFNBQVNXaHR6aHEwR3ExUDlubHowL3AxcnFjUkVJSlVVYU04cVJ6OCtH?=
 =?utf-8?B?bnJ2K3R6MTRKSFRjRjhoU3BQaFhabEZycVZDZEZab0xnNUgwSUJWVFFoL2h5?=
 =?utf-8?B?WTlGc1JsdmdSdDVGZkZZSzFvcXN1aHpweXVlZmJPWHhrUHJidjdEV3ViZk90?=
 =?utf-8?B?bkdPTDZlVU9wNTFlaFI4QTNJU215ZTJTeWN2emFkcWFDbEhxcnd6aVdOMEtJ?=
 =?utf-8?B?SWZSOGhVUU5QZlVqSkpCRkc5U0xrYWF5eWFxQVp6cmtPbjdCWjFvb2hRZ2Jj?=
 =?utf-8?B?OEx5cG1xT0VoMFZIcDk2TDhQczI3QzlaeW5pcjdvOE1tKzN3aXZheFhiaU9i?=
 =?utf-8?Q?Y5OknLM+/Mjr8TbiDB8xZRv73?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: febe0702-c5e6-4b5b-6238-08dbb2914401
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2023 06:35:18.3640
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: a/wofyyg69pEbM7MOFzxZNajHdEB2umBG2rVsL0kV8JIJkW9etrD5ZfZ2fxPGpfjLGBPeKPXTK2ELy0fTxXYoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB8296
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBCYW9sdSBMdSA8YmFvbHUubHVAbGludXguaW50ZWwuY29tPg0KPiBTZW50OiBUdWVz
ZGF5LCBTZXB0ZW1iZXIgNSwgMjAyMyAxOjIwIFBNDQo+IA0KPiBJIGFkZGVkIGJlbG93IHBhdGNo
IHRvIGFkZHJlc3MgdGhlIGlvcGZfcXVldWVfZmx1c2hfZGV2KCkgaXNzdWUuIFdoYXQgZG8NCj4g
eW91IHRoaW5rIG9mIHRoaXPvvJ8NCj4gDQo+IGlvbW11OiBJbXByb3ZlIGlvcGZfcXVldWVfZmx1
c2hfZGV2KCkNCj4gDQo+IFRoZSBpb3BmX3F1ZXVlX2ZsdXNoX2RldigpIGlzIGNhbGxlZCBieSB0
aGUgaW9tbXUgZHJpdmVyIGJlZm9yZSByZWxlYXNpbmcNCj4gYSBQQVNJRC4gSXQgZW5zdXJlcyB0
aGF0IGFsbCBwZW5kaW5nIGZhdWx0cyBmb3IgdGhpcyBQQVNJRCBoYXZlIGJlZW4NCj4gaGFuZGxl
ZCBvciBjYW5jZWxsZWQsIGFuZCB3b24ndCBoaXQgdGhlIGFkZHJlc3Mgc3BhY2UgdGhhdCByZXVz
ZXMgdGhpcw0KPiBQQVNJRC4gVGhlIGRyaXZlciBtdXN0IG1ha2Ugc3VyZSB0aGF0IG5vIG5ldyBm
YXVsdCBpcyBhZGRlZCB0byB0aGUgcXVldWUuDQo+IA0KPiBUaGUgU01NVXYzIGRyaXZlciBkb2Vz
bid0IHVzZSBpdCBiZWNhdXNlIGl0IG9ubHkgaW1wbGVtZW50cyB0aGUNCj4gQXJtLXNwZWNpZmlj
IHN0YWxsIGZhdWx0IG1vZGVsIHdoZXJlIERNQSB0cmFuc2FjdGlvbnMgYXJlIGhlbGQgaW4gdGhl
IFNNTVUNCj4gd2hpbGUgd2FpdGluZyBmb3IgdGhlIE9TIHRvIGhhbmRsZSBpb3BmJ3MuIFNpbmNl
IGEgZGV2aWNlIGRyaXZlciBtdXN0DQo+IGNvbXBsZXRlIGFsbCBETUEgdHJhbnNhY3Rpb25zIGJl
Zm9yZSBkZXRhY2hpbmcgZG9tYWluLCB0aGVyZSBhcmUgbm8NCj4gcGVuZGluZyBpb3BmJ3Mgd2l0
aCB0aGUgc3RhbGwgbW9kZWwuIFBSSSBzdXBwb3J0IHJlcXVpcmVzIGFkZGluZyBhIGNhbGwgdG8N
Cj4gaW9wZl9xdWV1ZV9mbHVzaF9kZXYoKSBhZnRlciBmbHVzaGluZyB0aGUgaGFyZHdhcmUgcGFn
ZSBmYXVsdCBxdWV1ZS4NCj4gDQo+IFRoZSBjdXJyZW50IGltcGxlbWVudGF0aW9uIG9mIGlvcGZf
cXVldWVfZmx1c2hfZGV2KCkgaXMgYSBzaW1wbGlmaWVkDQo+IHZlcnNpb24uIEl0IGlzIG9ubHkg
c3VpdGFibGUgZm9yIFNWQSBjYXNlIGluIHdoaWNoIHRoZSBwcm9jZXNzaW5nIG9mIGlvcGYNCj4g
aXMgaW1wbGVtZW50ZWQgaW4gdGhlIGlubmVyIGxvb3Agb2YgdGhlIGlvbW11IHN1YnN5c3RlbS4N
Cj4gDQo+IEltcHJvdmUgdGhpcyBpbnRlcmZhY2UgdG8gbWFrZSBpdCBhbHNvIHdvcmsgZm9yIGhh
bmRsaW5nIGlvcGYgb3V0IG9mIHRoZQ0KPiBpb21tdSBjb3JlLg0KPiANCj4gU2lnbmVkLW9mZi1i
eTogTHUgQmFvbHUgPGJhb2x1Lmx1QGxpbnV4LmludGVsLmNvbT4NCj4gLS0tDQo+ICAgaW5jbHVk
ZS9saW51eC9pb21tdS5oICAgICAgfCAgNCArKy0tDQo+ICAgZHJpdmVycy9pb21tdS9pbnRlbC9z
dm0uYyAgfCAgMiArLQ0KPiAgIGRyaXZlcnMvaW9tbXUvaW8tcGdmYXVsdC5jIHwgNDANCj4gKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0NCj4gICAzIGZpbGVzIGNoYW5nZWQs
IDQxIGluc2VydGlvbnMoKyksIDUgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvaW5j
bHVkZS9saW51eC9pb21tdS5oIGIvaW5jbHVkZS9saW51eC9pb21tdS5oDQo+IGluZGV4IDc3YWQz
M2ZmZTNhYy4uNDY1ZTIzZTk0NWQwIDEwMDY0NA0KPiAtLS0gYS9pbmNsdWRlL2xpbnV4L2lvbW11
LmgNCj4gKysrIGIvaW5jbHVkZS9saW51eC9pb21tdS5oDQo+IEBAIC0xMjc1LDcgKzEyNzUsNyBA
QCBpb21tdV9zdmFfZG9tYWluX2FsbG9jKHN0cnVjdCBkZXZpY2UgKmRldiwNCj4gc3RydWN0DQo+
IG1tX3N0cnVjdCAqbW0pDQo+ICAgI2lmZGVmIENPTkZJR19JT01NVV9JT1BGDQo+ICAgaW50IGlv
cGZfcXVldWVfYWRkX2RldmljZShzdHJ1Y3QgaW9wZl9xdWV1ZSAqcXVldWUsIHN0cnVjdCBkZXZp
Y2UgKmRldik7DQo+ICAgaW50IGlvcGZfcXVldWVfcmVtb3ZlX2RldmljZShzdHJ1Y3QgaW9wZl9x
dWV1ZSAqcXVldWUsIHN0cnVjdCBkZXZpY2UNCj4gKmRldik7DQo+IC1pbnQgaW9wZl9xdWV1ZV9m
bHVzaF9kZXYoc3RydWN0IGRldmljZSAqZGV2KTsNCj4gK2ludCBpb3BmX3F1ZXVlX2ZsdXNoX2Rl
dihzdHJ1Y3QgZGV2aWNlICpkZXYsIGlvYXNpZF90IHBhc2lkKTsNCj4gICBzdHJ1Y3QgaW9wZl9x
dWV1ZSAqaW9wZl9xdWV1ZV9hbGxvYyhjb25zdCBjaGFyICpuYW1lKTsNCj4gICB2b2lkIGlvcGZf
cXVldWVfZnJlZShzdHJ1Y3QgaW9wZl9xdWV1ZSAqcXVldWUpOw0KPiAgIGludCBpb3BmX3F1ZXVl
X2Rpc2NhcmRfcGFydGlhbChzdHJ1Y3QgaW9wZl9xdWV1ZSAqcXVldWUpOw0KPiBAQCAtMTI5NSw3
ICsxMjk1LDcgQEAgaW9wZl9xdWV1ZV9yZW1vdmVfZGV2aWNlKHN0cnVjdCBpb3BmX3F1ZXVlDQo+
ICpxdWV1ZSwNCj4gc3RydWN0IGRldmljZSAqZGV2KQ0KPiAgIAlyZXR1cm4gLUVOT0RFVjsNCj4g
ICB9DQo+IA0KPiAtc3RhdGljIGlubGluZSBpbnQgaW9wZl9xdWV1ZV9mbHVzaF9kZXYoc3RydWN0
IGRldmljZSAqZGV2KQ0KPiArc3RhdGljIGlubGluZSBpbnQgaW9wZl9xdWV1ZV9mbHVzaF9kZXYo
c3RydWN0IGRldmljZSAqZGV2LCBpb2FzaWRfdCBwYXNpZCkNCj4gICB7DQo+ICAgCXJldHVybiAt
RU5PREVWOw0KPiAgIH0NCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvaW9tbXUvaW50ZWwvc3ZtLmMg
Yi9kcml2ZXJzL2lvbW11L2ludGVsL3N2bS5jDQo+IGluZGV4IDc4MGM1YmQ3M2VjMi4uNGMzZjQ1
MzNlMzM3IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL2lvbW11L2ludGVsL3N2bS5jDQo+ICsrKyBi
L2RyaXZlcnMvaW9tbXUvaW50ZWwvc3ZtLmMNCj4gQEAgLTQ5NSw3ICs0OTUsNyBAQCB2b2lkIGlu
dGVsX2RyYWluX3Bhc2lkX3BycShzdHJ1Y3QgZGV2aWNlICpkZXYsIHUzMg0KPiBwYXNpZCkNCj4g
ICAJCWdvdG8gcHJxX3JldHJ5Ow0KPiAgIAl9DQo+IA0KPiAtCWlvcGZfcXVldWVfZmx1c2hfZGV2
KGRldik7DQo+ICsJaW9wZl9xdWV1ZV9mbHVzaF9kZXYoZGV2LCBwYXNpZCk7DQo+IA0KPiAgIAkv
Kg0KPiAgIAkgKiBQZXJmb3JtIHN0ZXBzIGRlc2NyaWJlZCBpbiBWVC1kIHNwZWMgQ0g3LjEwIHRv
IGRyYWluIHBhZ2UNCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvaW9tbXUvaW8tcGdmYXVsdC5jIGIv
ZHJpdmVycy9pb21tdS9pby1wZ2ZhdWx0LmMNCj4gaW5kZXggM2U2ODQ1YmM1OTAyLi44NDcyOGZi
ODlhYzcgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvaW9tbXUvaW8tcGdmYXVsdC5jDQo+ICsrKyBi
L2RyaXZlcnMvaW9tbXUvaW8tcGdmYXVsdC5jDQo+IEBAIC0zMDksMTcgKzMwOSw1MyBAQCBFWFBP
UlRfU1lNQk9MX0dQTChpb21tdV9wYWdlX3Jlc3BvbnNlKTsNCj4gICAgKg0KPiAgICAqIFJldHVy
bjogMCBvbiBzdWNjZXNzIGFuZCA8MCBvbiBlcnJvci4NCj4gICAgKi8NCj4gLWludCBpb3BmX3F1
ZXVlX2ZsdXNoX2RldihzdHJ1Y3QgZGV2aWNlICpkZXYpDQo+ICtpbnQgaW9wZl9xdWV1ZV9mbHVz
aF9kZXYoc3RydWN0IGRldmljZSAqZGV2LCBpb2FzaWRfdCBwYXNpZCkNCj4gICB7DQo+ICAgCXN0
cnVjdCBpb21tdV9mYXVsdF9wYXJhbSAqaW9wZl9wYXJhbSA9DQo+IGlvcGZfZ2V0X2Rldl9mYXVs
dF9wYXJhbShkZXYpOw0KPiArCWNvbnN0IHN0cnVjdCBpb21tdV9vcHMgKm9wcyA9IGRldl9pb21t
dV9vcHMoZGV2KTsNCj4gKwlzdHJ1Y3QgaW9tbXVfcGFnZV9yZXNwb25zZSByZXNwOw0KPiArCXN0
cnVjdCBpb3BmX2ZhdWx0ICppb3BmLCAqbmV4dDsNCj4gKwlpbnQgcmV0ID0gMDsNCj4gDQo+ICAg
CWlmICghaW9wZl9wYXJhbSkNCj4gICAJCXJldHVybiAtRU5PREVWOw0KPiANCj4gICAJZmx1c2hf
d29ya3F1ZXVlKGlvcGZfcGFyYW0tPnF1ZXVlLT53cSk7DQo+ICsNCj4gKwltdXRleF9sb2NrKCZp
b3BmX3BhcmFtLT5sb2NrKTsNCj4gKwlsaXN0X2Zvcl9lYWNoX2VudHJ5X3NhZmUoaW9wZiwgbmV4
dCwgJmlvcGZfcGFyYW0tPnBhcnRpYWwsIGxpc3QpIHsNCj4gKwkJaWYgKCEoaW9wZi0+ZmF1bHQu
cHJtLmZsYWdzICYNCj4gSU9NTVVfRkFVTFRfUEFHRV9SRVFVRVNUX1BBU0lEX1ZBTElEKSB8fA0K
PiArCQkgICAgaW9wZi0+ZmF1bHQucHJtLnBhc2lkICE9IHBhc2lkKQ0KPiArCQkJYnJlYWs7DQo+
ICsNCj4gKwkJbGlzdF9kZWwoJmlvcGYtPmxpc3QpOw0KPiArCQlrZnJlZShpb3BmKTsNCj4gKwl9
DQo+ICsNCj4gKwlsaXN0X2Zvcl9lYWNoX2VudHJ5X3NhZmUoaW9wZiwgbmV4dCwgJmlvcGZfcGFy
YW0tPmZhdWx0cywgbGlzdCkgew0KPiArCQlpZiAoIShpb3BmLT5mYXVsdC5wcm0uZmxhZ3MgJg0K
PiBJT01NVV9GQVVMVF9QQUdFX1JFUVVFU1RfUEFTSURfVkFMSUQpIHx8DQo+ICsJCSAgICBpb3Bm
LT5mYXVsdC5wcm0ucGFzaWQgIT0gcGFzaWQpDQo+ICsJCQljb250aW51ZTsNCj4gKw0KPiArCQlt
ZW1zZXQoJnJlc3AsIDAsIHNpemVvZihzdHJ1Y3QgaW9tbXVfcGFnZV9yZXNwb25zZSkpOw0KPiAr
CQlyZXNwLnBhc2lkID0gaW9wZi0+ZmF1bHQucHJtLnBhc2lkOw0KPiArCQlyZXNwLmdycGlkID0g
aW9wZi0+ZmF1bHQucHJtLmdycGlkOw0KPiArCQlyZXNwLmNvZGUgPSBJT01NVV9QQUdFX1JFU1Bf
SU5WQUxJRDsNCj4gKw0KPiArCQlpZiAoaW9wZi0+ZmF1bHQucHJtLmZsYWdzICYNCj4gSU9NTVVf
RkFVTFRfUEFHRV9SRVNQT05TRV9ORUVEU19QQVNJRCkNCj4gKwkJCXJlc3AuZmxhZ3MgPSBJT01N
VV9QQUdFX1JFU1BfUEFTSURfVkFMSUQ7DQoNCk91dCBvZiBjdXJpb3NpdHkuIElzIGl0IGEgdmFs
aWQgY29uZmlndXJhdGlvbiB3aGljaCBoYXMgUkVRVUVTVF9QQVNJRF9WQUxJRA0Kc2V0IGJ1dCBS
RVNQX1BBU0lEX1ZBTElEIGNsZWFyZWQ/IEknbSB1bmNsZWFyIHdoeSBhbm90aGVyIHJlc3BvbnNl
DQpmbGFnIGlzIHJlcXVpcmVkIGJleW9uZCB3aGF0IHRoZSByZXF1ZXN0IGZsYWcgaGFzIHRvbGQu
Li4NCg0KPiArDQo+ICsJCXJldCA9IG9wcy0+cGFnZV9yZXNwb25zZShkZXYsIGlvcGYsICZyZXNw
KTsNCj4gKwkJaWYgKHJldCkNCj4gKwkJCWJyZWFrOw0KPiArDQo+ICsJCWxpc3RfZGVsKCZpb3Bm
LT5saXN0KTsNCj4gKwkJa2ZyZWUoaW9wZik7DQo+ICsJfQ0KPiArCW11dGV4X3VubG9jaygmaW9w
Zl9wYXJhbS0+bG9jayk7DQo+ICAgCWlvcGZfcHV0X2Rldl9mYXVsdF9wYXJhbShpb3BmX3BhcmFt
KTsNCj4gDQo+IC0JcmV0dXJuIDA7DQo+ICsJcmV0dXJuIHJldDsNCj4gICB9DQo+ICAgRVhQT1JU
X1NZTUJPTF9HUEwoaW9wZl9xdWV1ZV9mbHVzaF9kZXYpOw0KPiANCg0KVGhpcyBsb29rcyBPSy4g
QW5vdGhlciBuaXQgaXMgdGhhdCB0aGUgd2FybmluZyBvZiAibm8gcGVuZGluZyBQUlEiDQppbiBp
b21tdV9wYWdlX3Jlc3BvbnNlKCkgc2hvdWxkIGJlIHJlbW92ZWQgZ2l2ZW4gd2l0aCBhYm92ZQ0K
Y2hhbmdlIGl0J3MgZXhwZWN0ZWQgZm9yIGlvbW11ZmQgcmVzcG9uc2VzIHRvIGJlIHJlY2VpdmVk
IGFmdGVyIHRoaXMNCmZsdXNoIG9wZXJhdGlvbiBpbiBpb21tdSBjb3JlLg0K
