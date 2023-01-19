Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E53DA672FD7
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 05:02:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbjASEAK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 23:00:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230112AbjASDs6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 22:48:58 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFFDC69B38
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 19:45:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674099974; x=1705635974;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vYcSrxlDNDOZObKj0Ym+8+QVYRTknW0YdZROBL0trtg=;
  b=buq9KCVwYQjLYQNPwn+kIveEmCCp1gIxwBHL+NrrJJtwoX/5l9QkQL6a
   hpnUbDkM09my6yb0nvWdMAf4EkP7Z5vhqOzCfqaJke3gd9XhL/iN+YrPx
   aEMqsZz3uwfT/mxcxo6nj7fe/aAmGJK4AxqqlHqQNeFQgSCp4uFE1HoNB
   902BihusZHwbobR48QCSjzFNrWbs0fypF+YThrkrwwF8WhfIYoGEASMUP
   0k8nfuuz3SYh3y6AIwFWDynltMYuMr9E2nWBWcXS06ThahRDzF27noy4r
   jDeIj0AD3dNKtMhDDGKrbSkSgoa1t9t3yoxwlbXx7kAPvuyNK4z1+dqgY
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="304868355"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="304868355"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 19:43:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="609919897"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="609919897"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga003.jf.intel.com with ESMTP; 18 Jan 2023 19:43:21 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 19:43:21 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 18 Jan 2023 19:43:21 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 18 Jan 2023 19:43:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dXSVIPDDUweBKx52wuzvxmip0bCf5ECeyjVhY81cixfxqe5gVk6CkWP8/kJLoeA9mEkyLxW5TzcADM7ra2iORrHaOp2R1oKtvFsSUkiCAdRUeBDR3hUhXSDRaluWSc5r83HvkPZHVTbJGMtLux7VlIrlHGuT3t548FvjeKwT76mNg6yEey4W/vt02EeCThizOIcWdx7ynDD1H+eNn3ngjBd/nQ3nt8KfLmAEXOqh0Yr33HRDkc+6ipChSJZqTJeoy1tQtVOCo2J7LYK/x3c/P9/RaQAt90WDShGWbGk5IgNFnohocmep3RIHyRSBmoT8rydynpI96bJd1uv80E1vkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vYcSrxlDNDOZObKj0Ym+8+QVYRTknW0YdZROBL0trtg=;
 b=nj3q4XQBm8FD5nzfajWJRkmep/vsg7Ca3Wknd0J5UHape/mlE5HnLlfevl87j4+eWLGsxGEZUzoz8kUvmqn/5hLVfALn37yvtR1s/rNTAa9oTOcGjr6cuBBznLegxV56IYP+xkMQ4/I5rBxfh8cP8hyGGiwIPbes4/tqK8qpGb+CQlIMYTwAqcn45Gq4FknYb2xc3RTcCcrygQzkK9VRTaKv5wxLPkL1zTCekd7fUYVJgfSncoa/Oent5RPjdgTWGifmTR2S9HqpOAB95hoXSNfCfDy5+cqVf6y18O10M46WvqiGSwx+GiGvlvsERJlUTJNUnDwl/DUcc0R7sAQeIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH0PR11MB7542.namprd11.prod.outlook.com (2603:10b6:510:28b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Thu, 19 Jan
 2023 03:43:14 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3%3]) with mapi id 15.20.5986.023; Thu, 19 Jan 2023
 03:43:14 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>
Subject: RE: [PATCH 08/13] vfio: Block device access via device fd until
 device is opened
Thread-Topic: [PATCH 08/13] vfio: Block device access via device fd until
 device is opened
Thread-Index: AQHZKnqYE1wy2qbufkqZv2YFZFXODK6j63aAgABHvwCAAOfXgIAAAB5g
Date:   Thu, 19 Jan 2023 03:43:14 +0000
Message-ID: <DS0PR11MB7529A9A30D572B96AB4C49D8C3C49@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230117134942.101112-1-yi.l.liu@intel.com>
 <20230117134942.101112-9-yi.l.liu@intel.com>
 <BN9PR11MB5276941A0F5FD7880DD1C41C8CC79@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Y8f5lEcYaL6QgiDD@nvidia.com>
 <BN9PR11MB527637735DDEAEEE742852968CC49@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB527637735DDEAEEE742852968CC49@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|PH0PR11MB7542:EE_
x-ms-office365-filtering-correlation-id: 21c4c886-c66c-48e5-c9c0-08daf9cf4b6e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fxjaUMYxX7D8ZO0oQog/R6ryvu7F94yx6G2/6AQUyzXbYvlcUYj8z79TrzRwc2BdHHU/+LTnEqeRQAw3+NpPHxhTaF8203KH9g3BkI4k1qYpCbkevYmBccCmt08Aqrlftbne00LuaHgo+L2aFGMJtmlAvF3MS5fz/SDWyePtjIs0H/PnbmSi5VhPfVDq9mK1dxrCXqRuxnChWOckqms05qI5krjJaAZZMb8pVVth+0mNVWMdSwzfXjSIh4va/O+EaKaiTuhcMo7ZX9gtQfJyPjH+T27hebe26eYaE9Lsrb2utAVw7H+BBw2Dxxm1Y2mcMu1DWv/sm9paZmSW5YKNII0FHMMnots2zJ+e9D8gbRxfBWSqYhYVaf2zT6wPZmoOOypo7shAJEtBN6cvMhYWb3VgKVs7jHnsOt14BlFnm1y/LUlmL5o18WIa1xxV51nPfloxAYJWELBvm4lSO/cjyqgfzXl8tBCZRdcJwpjZk758j/afI8SlPanQ1l4iviSGAW80CAj0xa6irefBuS64bHl0FRN2jS4UzNG4OEu+S/X1NTys8Kbbqj4iI9WLjCyJuEi3Y+tTPajV7zMI3iIz0irxykQWL4xc8VgTsBvcJtRuvodTG654LHpQKpQ5b9zTZ6Md1n/KZWb/76UxOHDbcicnDJDIa5x5MVjTLLcTGWGLHhOLJjrk3QbDnWIqgeqRg6RqeU578yBnaFVjZkXYGw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(376002)(136003)(396003)(346002)(366004)(451199015)(38070700005)(6506007)(33656002)(86362001)(66946007)(66556008)(7416002)(55016003)(52536014)(5660300002)(66476007)(8936002)(2906002)(82960400001)(38100700002)(122000001)(4744005)(76116006)(316002)(64756008)(4326008)(54906003)(71200400001)(110136005)(7696005)(478600001)(41300700001)(8676002)(66446008)(186003)(83380400001)(9686003)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WjBwcDFMaVNqUXpHVGxqQWdGWmo4TDZFcVV1MStqMEg1KzJnZTFuOFp4aWNY?=
 =?utf-8?B?dUx0YVJ3Mm5BRFhzWFNsUHV2QXFrMVJGMUpDdGZmT3I3ZGJlWjJMVWd5MzJQ?=
 =?utf-8?B?VW5nVTJKRzhBMW1RR1FqckROMkNkc3FmQmVCajU2SjJnbTVNd3NWUGRYOUZB?=
 =?utf-8?B?TjVLUk1lMEtmVUwrcStOK0UwNXh0Ny9rTGJvWVg5Y1ZNbmhxRzNUVG8vdGtI?=
 =?utf-8?B?VThxR3ZOOXhzSjV0OWd5Ung3bVVMMS8yRmpOM3B0c2dIa1dsUzdUMXZ3TWVl?=
 =?utf-8?B?anBzTXdBVmdZR1pka0tqUW0xb0VXdy9TNitLUWxwcFBsaUNZcnUvT2RUZ2hE?=
 =?utf-8?B?RXgrM3JSeFRWZThwNEttMExsYzBLdGorNldQNmE0TFkxTGFMLzVhMkpXZzZU?=
 =?utf-8?B?am9wZnVHbW9yUVJUTEJFVkFGZGpZUU5uZDVEYUk1ZHB6MHBGN0R0OXUzNGtE?=
 =?utf-8?B?bDE3YklLZDBWMU1WNHF0STdGRW9WRStsM2R6U210dzJZSG1WaVVGSWtZdVV2?=
 =?utf-8?B?KzBNbWJ1UGdSSDhYYnF5d0pXQkk0RVlpQzlWTmpYb1ljRURXa0FVeGx1eElK?=
 =?utf-8?B?UzlsaDhQUDFhZi90OGo3N0tvRGZoTFNNenp1MWJFN0Y2cU9UK1NrWXlLb01J?=
 =?utf-8?B?dUU0TFFPRlVkeCtCK1JqLzQrS2wvTjBkNnFWRHB5QVVxSk90cHV2L1pqS0JB?=
 =?utf-8?B?Q3VKa1JZVWtrT25SWWZPTFBFelZXb2FlUlFsY2k0SEtlcDNxYitqU0RVTDlD?=
 =?utf-8?B?R0NEVlRWOFpYS1ducDVtTElUbFFHZGlVRVJoWUdJeXlETmsvUjY1UWtLUEtF?=
 =?utf-8?B?YUxpenZPMExtdmg0eDc0WVBKMGk0MFMrVGZrTTlreG0vNDFDVVhuMlJpdlpo?=
 =?utf-8?B?VHhWd2RBRFpyT2xKQ2NLUzlkQzVlb3MyYjVjeUxCR0N6ZFQrNy91OGptbG9y?=
 =?utf-8?B?eEhFSkRLeEY4MkltblRsbEJnaDJUb2ZsMi9SZ2RMcDJncThVaUNUSmxYaU5X?=
 =?utf-8?B?MVNaa1l4WnphNDI5MTBMVlpoRTNEZHdsdWQ1eDBpaVorSS9EMi8yZ0Y2Szk4?=
 =?utf-8?B?TGtsOHQ3YnN0dFlXZ3VzMEdKR3gvcjBXMDRzQThBQ0doWVVjOWFKRm13YU9S?=
 =?utf-8?B?SWd0R1VESUZ2NW5XR24vWkNhZlo2d090ZEZXMUROWmxDQ0J4bUhOd2ZzQjFk?=
 =?utf-8?B?M2Q5NXlWSitvWUQ0bTlqelJRbzZiM3E1amllb2QxT3F2MW1xNDdaREZWeFdt?=
 =?utf-8?B?MFNyQjloVk1vWlM0L3NCUEMzcC9QWThpVy9RS3NETGxPYkhSZXR0TUd5U1lN?=
 =?utf-8?B?ZmJUWjZqSFBPa212UUg2ZmdMdWJlQ0UxTEhaQmNwVUt1VjFadVZKL1BHbVRp?=
 =?utf-8?B?ejZ6NnpJaXRtOUUvQ25CYjZLR3U5cmxqUjVVamlHS2pLdEM0Qys5WnljQmlD?=
 =?utf-8?B?S2tHRTJvUHVYRlhKcC9iRW82WWVDbk1jNG05RFQyR3BRaHE3LzBhNUhtQWMr?=
 =?utf-8?B?YnZwTmYvek5nRjJMZEU3VE1wZU9TMkVBY3dKNlpzdUt3ZUY4QWFKd2Z3Q3cx?=
 =?utf-8?B?cVdJOXFUdktvT1BOZVl4YUF3amc1MDFuN0tUY25WRS9ocE9JU1pPZE84UGV0?=
 =?utf-8?B?V3ZjYnZ3WVJZUTF0UmxzTUdEQnFhMUlIK0NCcGFyQnk0Tk1IVEJ4UzF2NlNp?=
 =?utf-8?B?dkZrYzlsNmgrdEpJS01KS2RnMTZVbGVtKzJLOEVEbWZyWnVVMmpBUGlVNjJs?=
 =?utf-8?B?TXpQUXJhaTFKMzhBMVVqaWpnbHp0TktwVk4reEFqdWQ0ZnVFdlczQ2Y4N1d2?=
 =?utf-8?B?dkNGOHVuL0JoQ2tKUi9YRy94eEg5WUZxVnNEanVpemRqczlVUGtXNnZWSUk4?=
 =?utf-8?B?QmxUeE9VQitLZ2g0OGY0T0Jpa21aaEZMY2pWa3BHcFJlc3JGaGU4Q3Q5czhs?=
 =?utf-8?B?WkpnUVI1OWcwemh4RWJjTkZaRXFPMzFwaXVwK3U1TkZRWUpSWnJoQWVZMGFM?=
 =?utf-8?B?elZaK1J6S21Vc0N1WVlCd3o1QmUxWldSTnhCb0pFbm8rNHR1Z0NVcWZ6aUJH?=
 =?utf-8?B?STJrOFJoeEhlL0NQV2o2V3hoOFFzTURJbjlOOU5KcGRvQk1NUmFLYWVkRGtp?=
 =?utf-8?Q?uQQyDGb1uK+zhpUqlHqas/QVu?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21c4c886-c66c-48e5-c9c0-08daf9cf4b6e
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2023 03:43:14.5288
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oW1M1KjFWhfJR79ipGxlIH9nfyIUWDmR33tcToVil8Ff3+3opfiTBjT/6PvOTtj6PVCLSpU0jHi4P+swXInciA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7542
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBUaWFuLCBLZXZpbiA8a2V2aW4udGlhbkBpbnRlbC5jb20+DQo+IFNlbnQ6IFRodXJz
ZGF5LCBKYW51YXJ5IDE5LCAyMDIzIDExOjQyIEFNDQoNCj4gPiA+IE15IHF1ZXN0aW9uIHRvIHRo
ZSBsYXN0IHZlcnNpb24gd2FzIG5vdCBhbnN3ZXJlZC4uLg0KPiA+ID4NCj4gPiA+IENhbiB5b3Ug
ZWxhYm9yYXRlIHdoeSBpdCBpcyBpbXBvc3NpYmxlIHRvIHVuYmluZD8gSXMgaXQgbW9yZSBhbg0K
PiA+ID4gaW1wbGVtZW50YXRpb24gY2hvaWNlIG9yIGNvbmNlcHR1YWwgcmVzdHJpY3Rpb24/DQo+
ID4NCj4gPiBBdCBsZWFzdCBmb3IgdGhlIGltcGxlbWVudGF0aW9uIGl0IGlzIGR1ZSB0byB0aGUg
dXNlIG9mIHRoZSBsb2NrbGVzcw0KPiA+IHRlc3QgZm9yIGJpbmQuDQo+ID4NCj4gPiBJdCBjYW4g
c2FmZWx5IGhhbmRsZSB1bmJpbmQtPmJpbmQgYnV0IGl0IGNhbm5vdCBoYW5kbGUNCj4gPiBiaW5k
LT51bmJpbmQuIFRvIGFsbG93cyB0aGlzIHdlJ2QgbmVlZCB0byBhZGQgYSBsb2NrIG9uIGFsbCB0
aGUgdmZpbw0KPiA+IGlvY3RscyB3aGljaCBzZWVtcyBjb3N0bHkuDQo+ID4NCj4gDQo+IE9LLCBp
dCBtYWtlcyBzZW5zZS4gWWksIGNhbiB5b3UgYWRkIHRoaXMgbWVzc2FnZSBpbiBuZXh0IHZlcnNp
b24/DQogDQpZZWFoLiDwn5iKIA0KDQpSZWdhcmRzLA0KWWkgTGl1IA0K
