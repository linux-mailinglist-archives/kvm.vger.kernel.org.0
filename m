Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACF1E63E1C4
	for <lists+kvm@lfdr.de>; Wed, 30 Nov 2022 21:21:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbiK3UVO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 15:21:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbiK3UUu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 15:20:50 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC3ED62CA;
        Wed, 30 Nov 2022 12:17:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669839457; x=1701375457;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=i98BOe9xsPiqAwgR3NmhCqsOrJQeDxd5T+HWqyF0D4c=;
  b=gdPwpiZIZKOaVguVSUUnseRtss4XRvLQ74JfHgZw17CWFJbD9QW6UcSW
   N7VxmFTPu3yendPli+IObvVWq6B38wH/FapJy5xpytiRtPgzkhVOkz/Qk
   DiE6Q3lozs3ieSqgEVkAvnMztnUN44HKA6dok54hlg4C2u+h2AfgI4ehi
   ZW8dETj8MyE0EUemfahnXjb/8W6dgA1zwYrLHzmIEe7yMytic0Iwy8bPc
   3qR59sjTuQTcqfNo/+gDRvMvnvUHYFknNhAu+SLQdHU7Ui1TxnwibTn/O
   fwA5wH3AibN9o5ZPdlHIvWcDmYGlxqeJAM1OQr7cQODwXEYQIzonef/b1
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="313132265"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="313132265"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 12:17:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="750494530"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="750494530"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga002.fm.intel.com with ESMTP; 30 Nov 2022 12:17:37 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 30 Nov 2022 12:17:36 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 30 Nov 2022 12:17:36 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.109)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 30 Nov 2022 12:17:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CVBWSug1MZZzLj8Q5sS5lFTaA5JMFF73Ucs6udz6DbQ4LFKA2BhpZi0HZto4TZ8Q9WvgquAyGM5XR4clYYKOrVKt5nlxwKqbTE0ebYKQOjT+5Gz++7SQ7X5feCUbqBLUQAtguqFn0USYF0HWC8/X9b3+ggLQPab10TZyhR6p7PYMJvTsQ+pqBF9gZsumi9OBiiHfslHzzF5TwctKHZVoKyz06vO3nIAv75MLuj3VXnYoAQWTjw3k2WFBX4KEL9S8k3U4KnIt6ZNxYvJ6nEO+YfdUYU8j1axlsxKBksYg+5yNeBLw7UhNUeQv89bIn26EeAzfHEayEkz5qD2++xb1gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i98BOe9xsPiqAwgR3NmhCqsOrJQeDxd5T+HWqyF0D4c=;
 b=UBllsqjrnTv6flGxAF2P2icRHXiCBjJVYTCYQC8oMkYaiaZIVcFO/UpcvX0rEfCqQT0KrxhE8mzotFEXTCyhBE5oHqUOzuIHjtoBjY9eMoY77DhxgFshSSb/GFHmolMsVALNqBnDtVbazHcOG6x4gh42NiWnjAVP/zonvHB5LO5HGGcgf50i4BwgzcYDWY5OVX5BaA/8KhQFPoK4By+3HoADziFBdwRN0fsmpieEmRsRtSmZEUMgjnzkfwiqTIWefHUOAkaquY/6oThdw/6Okgfe1dZKlgnsr4X0TFD3uECs6402iZXtD0YQmPERH/4VUljOHVSx4Y80TeuSNu0gtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA1PR11MB6895.namprd11.prod.outlook.com (2603:10b6:806:2b2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Wed, 30 Nov
 2022 20:17:33 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%9]) with mapi id 15.20.5857.023; Wed, 30 Nov 2022
 20:17:33 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Hansen, Dave" <dave.hansen@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
CC:     "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: RE: [PATCH v7 17/20] x86/virt/tdx: Configure global KeyID on all
 packages
Thread-Topic: [PATCH v7 17/20] x86/virt/tdx: Configure global KeyID on all
 packages
Thread-Index: AQHY/T3LiMVg2HYmLEKsa3j9uYLXLa5W3zSAgABTgICAAG9dAIAAVNZg
Date:   Wed, 30 Nov 2022 20:17:33 +0000
Message-ID: <BL1PR11MB59781B5C333F964A81FC4DEDF7159@BL1PR11MB5978.namprd11.prod.outlook.com>
References: <cover.1668988357.git.kai.huang@intel.com>
 <8d8285cc5efa6302cf42a3fe2c9153d1a9dbcdac.1668988357.git.kai.huang@intel.com>
 <a537b97b-0bdc-5bcc-9ce7-470f8fc1245b@linux.intel.com>
 <3d19683cdc13b7a3884f1e9e75743e922d4630f3.camel@intel.com>
 <6b0980fc-74e7-3be5-c4a3-2583d6c26137@intel.com>
In-Reply-To: <6b0980fc-74e7-3be5-c4a3-2583d6c26137@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA1PR11MB6895:EE_
x-ms-office365-filtering-correlation-id: c2e21e40-434a-459d-f074-08dad30fea51
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +bezIrRtHBsOTiNToawEBoAROEIRwT6oxBJcUsLt5VvdI1g/CQWdt1MCTmWfEYZWNf/961tOz4fYrUW2aWvXEveB8JYRHrezdgxZRjlR2FKRjUeowv24sBcoBjW0562HvPAK+gMN4eSF3Yzq9XTXB6MtK9vlVEmixQWp5Q1wJLT5wr2I8QTDksUsRJ/f8AVvZqAA1gtKcZL3MwbShl8q2kUOt1wk6q4HM3NBNOEV1X5LA+7Xxp2ZsdcPm/EvoZjCyfcmvT0/wPxF4cE1FCV3z2UGhBLIi6vBY6Gho+tU/Y6I6CPAMAQwOLWOj+SL/6t+qHeGhfIZrC3km9Pkj2Vc2KQQYRtBU5PCrprjFhvvpUhxSGtpIE2VKkeaGC1MKvLE4bUF89IMssdOtcYEDsnJ09P4AJ3x2RCls5nsq4IliXE7dzP2g1/OPwb3l3dJszXyhN2d6LIvq94u9rIRrHHJUAYHGZalRlGLgy6T3A2robUZ4fKpxZvtuUDHQK3sZK/6kdFzt2SgtwrWDKWK28JL6aeIwgDKo78F0h51NQ8GWQvUcocx0CyN0/HYXSy/mPrxfhqWJBLkJb1Jw3r0gCBM/kZGTAlkJNa9Sjs4Vg6Az4c96ervY16+MPyWoxtDkPdmoJFlMXxDHtRsmIDeQF+YWD8X+BCAOcmhnL+a/jEmRlggCe0VrS4BFgD4OwVOJv9LLAFY4ypnEYNkW+tXJzN0EA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(346002)(136003)(376002)(396003)(451199015)(4001150100001)(52536014)(5660300002)(66446008)(66946007)(110136005)(66556008)(41300700001)(8676002)(66476007)(4326008)(64756008)(76116006)(54906003)(316002)(478600001)(122000001)(6506007)(7696005)(26005)(71200400001)(55016003)(2906002)(82960400001)(38070700005)(9686003)(186003)(53546011)(8936002)(86362001)(7416002)(83380400001)(38100700002)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WXJTcjJwQnRrVlgzMzdqRmQrVEpRTUQ1VEhTUFVxczNsdENqV1ZKUURoOVJB?=
 =?utf-8?B?Q2dKbWlyWmRpTkxaMWFxNGs3Z2E0OTRnMEIzTnhIZmpMNW5yWXZnWUxIK1B0?=
 =?utf-8?B?T2EzbXpySU5xeGVKcTZsTDBlOEh1TXdsQzZGT21nTE9uUWpvU003SitZUnNo?=
 =?utf-8?B?emxnd0ZkY0lkODhydXpNZWhiYTNpRkxJUjQzY3NJWkZmZU9YaXczYzRlQ2Ur?=
 =?utf-8?B?SldOWXNxZGc0a2dHbDExOUoyd3V3ZnpOWlF2QmpUWjlCYnVlQUd3aEtLV0Mz?=
 =?utf-8?B?NHpLaVZ2Y2dPRVRTU1FRN2pPMlhVcm1OZVBZWlFwUm4xUWlkV0xCSnZZU1Vl?=
 =?utf-8?B?eldzVmM1S2J0MWl4dFVIMi9yNjdORHJ2MUd2aFo0Z3BNZ0dsdzVsdFNNZzZI?=
 =?utf-8?B?RE8rZ3ZNVytyTjhka0dZK1lZQjlGZWtGV1MwenVaZHZqUmJFcGNEUlBSODJT?=
 =?utf-8?B?SHNjZWR5KzhHc0h5aklMUmFBTVlydmxsb3VFcUl5T05ocElHTExjanlWeGdD?=
 =?utf-8?B?U25QcG8zMmdJWGhUOWZUK3RjZkRrMnNBM3hGZ2V2OENrWDBoY09DUG5kcDNT?=
 =?utf-8?B?dEl6TVBHcktaM3J5bDJJNDJiUTVGV2oyNmJtVnhWY1JsNmJmRWpDV3RXL1cv?=
 =?utf-8?B?VThHQlpOcXl2NElkVUZEMENNSktRcHpyY3pGYXdXbFZ2RkxrbG02dVBPR3lH?=
 =?utf-8?B?MnNMdGI2dTlhaXVPSjhKSlMydVBLcjFvWmw1R1hOMzB3Q0svdzNQSm9XUkVh?=
 =?utf-8?B?dzVVL3JmVWk4dFp1VU42MTJqb1Ura0J5NDJocGdxc0orMGZTcHorTUxPejlQ?=
 =?utf-8?B?Q1ZHNloxOEN0RmFLN25zREs5Z0x2V0c5REUvZ1NJWjVKUmpraGlWOFR5VzNP?=
 =?utf-8?B?UUp6d1QyZTJGN256OVNGcjhzVmdMMng1d2djbGNOYmE1endxdnpUTmVwS3pm?=
 =?utf-8?B?WTJUb1ZObGJwQnpzNVkvZk5jMHlvWkVYUFpUTzkrSWw4bEtxOURYWXdoVTZY?=
 =?utf-8?B?c2M0QjlpZDhOcnJmUlIwQ0FrRlhoZDdyUEZVSG4zeUpmazJRZmFKVGNQREZD?=
 =?utf-8?B?WHM4L3ZVbkxONjl5OVB2TllYYmkrdVM5elJMZFFrNkRsYXVMWFJ4eEYyV2RP?=
 =?utf-8?B?bTdPMGwzYmR4UEhFR3VMV0VjeWU3TzNtVDJRczBPZ1M1Ty9aeWZUdS9ucU5h?=
 =?utf-8?B?K2s3NC9acUpJTXdjdm8rS3BpTGQwdHAwK0tiV2hPUkJuVFRTeE9zMm1ad3Bh?=
 =?utf-8?B?cS9PcXB0MkRDQWkxUDVqSjFkdDVJR2luNGZGZ09YYnRZRlh1SEdacnNCVDZM?=
 =?utf-8?B?MzNtYUFnR1VUY2ZXN0xwUGVqSURCT1c2SnhoeEdudktMUDR1YXN1Y3JYQkdG?=
 =?utf-8?B?c1ErU0FCc3pMTFRtSWVTMDN1a2xKR2tJcXNSOEQzaWNqZXhxaTg2OFpqTnZC?=
 =?utf-8?B?L3hNVmRoOHBrc1Z3djdCUjNKd1AzL2U1L1VyNFIxSkxnSnlIbHVOTnZlaVRW?=
 =?utf-8?B?VXhSZnpWMlNBd2hNL24wRmxyNHNuRDVoWXdlblJoS2lKUitmUXlHUWdQZnh3?=
 =?utf-8?B?cWorOTU0Zmo5OG9QOW9hV01HWTljK0VSdmUyL2tHanByNERDKy9yTDROb3lF?=
 =?utf-8?B?UFN2bTlxdXh4cW45Tk5QRTRXaUcvd1BIWTZJdndhZlFocG8rSFFZZHE0ZFpu?=
 =?utf-8?B?RHEzYlA0bkNrWFArY1RzanE2SG5ZNXRzWHlXSC9VRGRXM3pvK1F3b2owK2lh?=
 =?utf-8?B?dnhONFNrZWNpS2U5RXZ5eEtSQnU2YktMMFRDU2pacjhIbmw2Zld2cmRpOGRr?=
 =?utf-8?B?Tkgva1I4UTU5R0cyU3o4Si9zaEhnbFNEelo5RzJqYXNBV3FZYlA0YTBQeFA1?=
 =?utf-8?B?SVRpNnB2cWpyU0xQWGRVOGw1aWhzem5MMTlILzRxczJ0cUJkckVMS1FQZXMw?=
 =?utf-8?B?RUU1UElpY3lpWElwUDRNeFNyeDBYN0haaU9hVXc3b2RvbENiRXVWK21ES3cv?=
 =?utf-8?B?TzlLSzd0NlRiNFliVythV25xc3IvYWdLUk9GVFNaRmorbksxRU9ycUc4WUdB?=
 =?utf-8?B?MnM2bXRQUG10c2xDNnY4L1dsVjB5TlJIYzludG1tdHRCNU5ScXNxYmRPbFFa?=
 =?utf-8?Q?TasO6W81LycrtYduSeyARMWy2?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2e21e40-434a-459d-f074-08dad30fea51
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2022 20:17:33.5398
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvh8COdh6a7l/N4RD1xL2oGq8tpqxae7ypiWN78JqAcfFNkfYrakCVLduUib35jPRkZeJGFfsFEP4sMcbk8/wQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6895
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBPbiAxMS8zMC8yMiAwMDozNCwgSHVhbmcsIEthaSB3cm90ZToNCj4gPiBPbiBXZWQsIDIwMjIt
MTEtMzAgYXQgMTE6MzUgKzA4MDAsIEJpbmJpbiBXdSB3cm90ZToNCj4gPj4gT24gMTEvMjEvMjAy
MiA4OjI2IEFNLCBLYWkgSHVhbmcgd3JvdGU6DQo+ID4+PiBBZnRlciB0aGUgYXJyYXkgb2YgVERN
UnMgYW5kIHRoZSBnbG9iYWwgS2V5SUQgYXJlIGNvbmZpZ3VyZWQgdG8gdGhlDQo+ID4+PiBURFgg
bW9kdWxlLCB1c2UgVERILlNZUy5LRVkuQ09ORklHIHRvIGNvbmZpZ3VyZSB0aGUga2V5IG9mIHRo
ZQ0KPiA+Pj4gZ2xvYmFsIEtleUlEIG9uIGFsbCBwYWNrYWdlcy4NCj4gPj4+DQo+ID4+PiBUREgu
U1lTLktFWS5DT05GSUcgbXVzdCBiZSBkb25lIG9uIG9uZSAoYW55KSBjcHUgZm9yIGVhY2ggcGFj
a2FnZS4NCj4gPj4+IEFuZCBpdCBjYW5ub3QgcnVuIGNvbmN1cnJlbnRseSBvbiBkaWZmZXJlbnQg
Q1BVcy4gIEltcGxlbWVudCBhDQo+ID4+PiBoZWxwZXIgdG8gcnVuIFNFQU1DQUxMIG9uIG9uZSBj
cHUgZm9yIGVhY2ggcGFja2FnZSBvbmUgYnkgb25lLCBhbmQNCj4gPj4+IHVzZSBpdCB0byBjb25m
aWd1cmUgdGhlIGdsb2JhbCBLZXlJRCBvbiBhbGwgcGFja2FnZXMuDQo+ID4+Pg0KPiA+Pj4gSW50
ZWwgaGFyZHdhcmUgZG9lc24ndCBndWFyYW50ZWUgY2FjaGUgY29oZXJlbmN5IGFjcm9zcyBkaWZm
ZXJlbnQNCj4gPj4+IEtleUlEcy4gIFRoZSBrZXJuZWwgbmVlZHMgdG8gZmx1c2ggUEFNVCdzIGRp
cnR5IGNhY2hlbGluZXMNCj4gPj4+IChhc3NvY2lhdGVkIHdpdGggS2V5SUQgMCkgYmVmb3JlIHRo
ZSBURFggbW9kdWxlIHVzZXMgdGhlIGdsb2JhbA0KPiA+Pj4gS2V5SUQgdG8gYWNjZXNzIHRoZSBQ
QU1ULiAgRm9sbG93aW5nIHRoZSBURFggbW9kdWxlIHNwZWNpZmljYXRpb24sDQo+ID4+PiBmbHVz
aCBjYWNoZSBiZWZvcmUgY29uZmlndXJpbmcgdGhlIGdsb2JhbCBLZXlJRCBvbiBhbGwgcGFja2Fn
ZXMuDQo+ID4+Pg0KPiA+Pj4gR2l2ZW4gdGhlIFBBTVQgc2l6ZSBjYW4gYmUgbGFyZ2UgKH4xLzI1
NnRoIG9mIHN5c3RlbSBSQU0pLCBqdXN0IHVzZQ0KPiA+Pj4gV0JJTlZEIG9uIGFsbCBDUFVzIHRv
IGZsdXNoLg0KPiA+Pj4NCj4gPj4+IE5vdGUgaWYgYW55IFRESC5TWVMuS0VZLkNPTkZJRyBmYWls
cywgdGhlIFREWCBtb2R1bGUgbWF5IGFscmVhZHkNCj4gPj4+IGhhdmUgdXNlZCB0aGUgZ2xvYmFs
IEtleUlEIHRvIHdyaXRlIGFueSBQQU1ULiAgVGhlcmVmb3JlLCBuZWVkIHRvDQo+ID4+PiB1c2Ug
V0JJTlZEIHRvIGZsdXNoIGNhY2hlIGJlZm9yZSBmcmVlaW5nIHRoZSBQQU1UcyBiYWNrIHRvIHRo
ZQ0KPiA+Pj4ga2VybmVsLiAgTm90ZSB1c2luZyBNT1ZESVI2NEIgKHdoaWNoIGNoYW5nZXMgdGhl
IHBhZ2UncyBhc3NvY2lhdGVkDQo+ID4+PiBLZXlJRCBmcm9tIHRoZSBvbGQgVERYIHByaXZhdGUg
S2V5SUQgYmFjayB0byBLZXlJRCAwLCB3aGljaCBpcyB1c2VkDQo+ID4+PiBieSB0aGUga2VybmVs
KQ0KPiA+Pg0KPiA+PiBJdCBzZWVtcyBub3QgYWNjdXJhdGUgdG8gc2F5IE1PVkRJUjY0QiBjaGFu
Z2VzIHRoZSBwYWdlJ3MgYXNzb2NpYXRlZA0KPiBLZXlJRC4NCj4gPj4gSXQganVzdCB1c2VzIHRo
ZSBjdXJyZW50IEtleUlEIGZvciBtZW1vcnkgb3BlcmF0aW9ucy4NCj4gPg0KPiA+IFRoZSAid3Jp
dGUiIHRvIHRoZSBtZW1vcnkgY2hhbmdlcyB0aGUgcGFnZSdzIGFzc29jaWF0ZWQgS2V5SUQgdG8g
dGhlDQo+ID4gS2V5SUQgdGhhdCBkb2VzIHRoZSAid3JpdGUiLiAgQSBtb3JlIGFjY3VyYXRlIGV4
cHJlc3Npb24gcGVyaGFwcw0KPiA+IHNob3VsZCBiZSBNT1ZESVI2NEIgKyBNRkVOU0UsIGJ1dCBJ
IHRoaW5rIGl0IGRvZXNuJ3QgbWF0dGVyIGluIGNoYW5nZWxvZy4NCj4gDQo+IEp1c3QgZGVsZXRl
IGl0IGZyb20gdGhlIGNoYW5nZWxvZy4gIEl0J3MgYSBkaXN0cmFjdGlvbi4gIEknbSBub3QgZXZl
biBzdXJlIGl0J3MNCj4gKm5lY2Vzc2FyeSogdG8gZG8gYW55IG1lbW9yeSBjb250ZW50IGNvbnZl
cnNpb24gYWZ0ZXIgdGhlIFREWCBtb2R1bGUgaGFzDQo+IHdyaXR0ZW4gZ3Vuay4NCj4gDQo+IFRo
ZXJlIHdvbid0IGJlIGFueSBpbnRlZ3JpdHkgaXNzdWVzIGJlY2F1c2UgaW50ZWdyaXR5IGVycm9y
cyBkb24ndCBkbyBhbnl0aGluZyBmb3INCj4gS2V5SUQtMCAobm8gI01DKS4NCj4gDQo+IEkgX3Ro
aW5rXyB0aGUgcmVhZHMgb2YgdGhlIHBhZ2UgdXNpbmcgS2V5SUQtMCB3aWxsIHNlZSBhYm9ydCBw
YWdlIHNlbWFudGljcy4NCj4gVGhhdCdzICpGSU5FKi4NCg0KSSdsbCByZW1vdmUgdGhpcyBmcm9t
IHRoZSBjaGFuZ2Vsb2cuICBUaGFua3MhDQo=
