Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38D6E702B7A
	for <lists+kvm@lfdr.de>; Mon, 15 May 2023 13:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240922AbjEOL2N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 May 2023 07:28:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbjEOL2K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 May 2023 07:28:10 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9C7E10E;
        Mon, 15 May 2023 04:28:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684150089; x=1715686089;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=b90M98zy1/AVcR6VAW/1ROF39ExD4NX3etziLHIB4F4=;
  b=Re2YdMr+z34rNyBbEmUdufTbbQgHWJX3pxVJB/IRa5458rttIu3m4mNa
   JWbWCBQtBQt6SF8+2jSfDy0uYYJ3VmvSeOeS229BJtPuN+xPdCpBNelAE
   41J3MXqyrFAwcnQ1pFbUeoxbqYh3zV/5mZD7iXcE5QlrDV42POpV43fww
   FawEsieS4rcwVQOONL3mVLEtbIXhX9A1Wutp+1U/GtanY3dclX7HIM38t
   mcC57rXfW3lZqvwRJtssLgAOngzeHFvk1HDEn4xH8Or+weQX+gPs2A9dY
   3M9ZroGsC+gUpJV5rxqkZZbSAtDpW00PimrRprrhsCXjTGSj/WDqr4XAq
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10710"; a="348669838"
X-IronPort-AV: E=Sophos;i="5.99,276,1677571200"; 
   d="scan'208";a="348669838"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2023 04:28:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10710"; a="947374142"
X-IronPort-AV: E=Sophos;i="5.99,276,1677571200"; 
   d="scan'208";a="947374142"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga006.fm.intel.com with ESMTP; 15 May 2023 04:28:09 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 15 May 2023 04:28:09 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 15 May 2023 04:28:09 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.102)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 15 May 2023 04:28:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lf5UCxVm2OQjmbhIbQkkwoNXhY0kei83HNHIboCUO9gh1RNBVAWCKdB2RzAoh4BgtP9oFVE1vx2ORhFWFU1E8eN0mAVCOpmSl4kS1llr3DvNM+yDmZCjgpXikRjBhNcdVDSjnW206pfxUZ0vapNwj61snzDZQoX0XY54vRmIBRK/xbLY2I3fV9pvv1zflucQAWegS2MzxB3lJFQCwyBKjtf8bFZuMcYeAeB35vaKJ02mOaqy//SuJcRP+qJbjdcf3JlnOIRs8Dqp7AYZG9fb2hHx5ecnMsSHOUNTweST/bb2T1mwWY3Nqxdw5T3I1wppBRZBuJj873dcRfsweJpBUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b90M98zy1/AVcR6VAW/1ROF39ExD4NX3etziLHIB4F4=;
 b=kilpIc1+zvVBJOOL3jo8VtLbxEMcmUJtNUdVaoiUlKQmjxspZBZ/Hpf70c72TMem6GII+apOEgu6lEErxy5NFIG/axblK1S5zxdKF9wQlnl/ak1pRH1/ArqCl4dolwAoCJGY3SiP+YdMOGs6eYw7eDgBKCgE701zu83FVXeBtF0+9G0MxEBJrF9gbLf4eW8C5+NsMkXJjb+txcAMkXJJbtijXwKFaNbnh9kJuqBZ3AhvnVNinDHa4QDmkpqBvWfLWVj6B1QXV9VNarntMXj8NoErW/Mb7biFBTd+38m4NGOeWPXnX6lt/AeHx8Mqudrxw8EbnmqUPFOwwTG4XGZHOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM4PR11MB5549.namprd11.prod.outlook.com (2603:10b6:5:388::7) by
 PH7PR11MB8454.namprd11.prod.outlook.com (2603:10b6:510:30c::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6387.30; Mon, 15 May 2023 11:28:07 +0000
Received: from DM4PR11MB5549.namprd11.prod.outlook.com
 ([fe80::f381:7ce8:7d26:503d]) by DM4PR11MB5549.namprd11.prod.outlook.com
 ([fe80::f381:7ce8:7d26:503d%4]) with mapi id 15.20.6387.030; Mon, 15 May 2023
 11:28:07 +0000
From:   "Wang, Zhi A" <zhi.a.wang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v3 06/28] drm/i915/gvt: Error out on an attempt to
 shadowing an unknown GTT entry type
Thread-Topic: [PATCH v3 06/28] drm/i915/gvt: Error out on an attempt to
 shadowing an unknown GTT entry type
Thread-Index: AQHZhTL1fcbPoSM+NEGi6+Tk5NN29K9bNj0A
Date:   Mon, 15 May 2023 11:28:06 +0000
Message-ID: <8d976f25-4cbc-6114-c9b4-3e3efb5e2cac@intel.com>
References: <20230513003600.818142-1-seanjc@google.com>
 <20230513003600.818142-7-seanjc@google.com>
In-Reply-To: <20230513003600.818142-7-seanjc@google.com>
Accept-Language: en-FI, en-US
Content-Language: aa
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR11MB5549:EE_|PH7PR11MB8454:EE_
x-ms-office365-filtering-correlation-id: 0da3a255-50d9-4398-bfdd-08db5537747f
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6VJEUwlDCENjuPVivGzhLFsG0fUnuWhVmyIkQgNDpytcOBR16NAZuXJr/+0sXlB6txCw/EqExBO5c1ihfq009w+o/c2HeCXKyQ0rwN7V8MkFmJjHYBtadDXNAJbotBHAQ7O2IKXtp7PUzp1oPI7gSCgo26r++qdZJMN/gnuyECBlis/FdtkFKVrE7lfJmucXTK+aaZXvN6iarTVcE9wKps5rF8MlMCHRuBVh+7sMkzENFH2hsQhU6KFkQTodqOLdNOILX5nn9jkYPnZ1Q6eeM0m/YnfPC7bppArCHlGB50673D2UXgLhYODwuUvnOaj/N7ztzyo0gF6lkkgm3QDigj3BgSnHmQHRmU/vw9sz6UeQ9JUGxPRoJtmmY3lRAgk4cjYkzSM4Z1FLyWIUNwux3S5sCyhGnuufX4ega8jJ0odDLf65SxW6mq5q7mpj4zr2V+2uMb0D+idMqY/T7eTELSLfH/2IFjn21Ow8614GS0hgvPPWl96s2xT0GDSfMJpKkxEQJXwtWYh4HmJAcHBTL53D8Ap1cveQpG2MD8ygMebCwiNYcbGroy3Jcc9zbBtcOa7+2oBp1gKcgO60T3iRcXChI0vkg3XF0Zu2DICxXCjRXAdePwJf2P3ehnkuWvvIn1HzmBoKEKdxZKBgzIvlrsDpXSTI+c9kUPjYUyoDaV5e1eBe0drTzDdAABTwl/J2
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5549.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(39860400002)(396003)(366004)(376002)(451199021)(36756003)(91956017)(86362001)(54906003)(110136005)(316002)(66556008)(66446008)(64756008)(66946007)(66476007)(4326008)(478600001)(6486002)(76116006)(4744005)(5660300002)(8676002)(8936002)(2906002)(38070700005)(38100700002)(31696002)(82960400001)(122000001)(41300700001)(6512007)(2616005)(186003)(53546011)(26005)(6506007)(83380400001)(71200400001)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NDYrTS9jT2dMSkk1S1Y2WlhzRTlVZ3h5SWdzY1BiNEx5aGRsejhWQ0t5NDQx?=
 =?utf-8?B?S2FKVHEvZG16NFJIbWo4QjhhNWxzRkdneDloYUFxcHdSTkZxdjJpUEFyNW05?=
 =?utf-8?B?ZU5KbFc3K0szMHVwUEI0UmhXcFp0dUZPdXFxWkJKd1MvZFo1b2VDY2lNa0lZ?=
 =?utf-8?B?amU0NGR6STVmT0NnVVNYN1psTXI4SXQ5WWlmVGt5Y3h1cEU1a0EzN2RXd3oz?=
 =?utf-8?B?NXBhRFV3NTFDQ1hsWUtHMldxem0yMDFMSWU4cDJJV2Y5OXFoZVhOZXp4MWh6?=
 =?utf-8?B?eFhYYlAzd3dILyttcDVLN0lPdGQ3REtFNmxhOVJsazh2UDk3d0ZaRnkrTzRr?=
 =?utf-8?B?aEdUTldrQ2xTNlJ1UjdidHVSU041RnFFSFM3MnQxMi9iRHlMMlFHbVpqa1dU?=
 =?utf-8?B?YXQvSUNTR2h0YmRYazNHdFlORk9SRTFrNjVML28zeCtMMFYza2lXdk9JQnVr?=
 =?utf-8?B?emdCdi8xaVVXSkg0MHZCMU83eElFdkNoa21XWXc3WmVlTXdMd1hUR2dVL0Rq?=
 =?utf-8?B?V2Z1TEFrb1czK3BWejNSL3Y4TFlWR3R6eUdvVzZ6MS91bThLNThCSWdORmRn?=
 =?utf-8?B?eWE3eE1LNGJzRENUSmxFN3k5WFNCVWdLaUFPOVVxSkFLU0Zkc3Nxcmpyb0xs?=
 =?utf-8?B?ZHhOWWJZUnlBUVRTak04UXp6QldJQlc2UDFjcUlzZjAzd2dMU2dvWUZVUENv?=
 =?utf-8?B?YXlXNUlWcVNLOEtYejBLSGQ1WVpGNWpsdi9SRlJTbS9Xc0U4UTI4SUdWRDV0?=
 =?utf-8?B?ZGFHdlpyUlhqSUttSkMzR0VLb0FESjkwMGpUZTlLaDBROXBLMnkrRjhVY1FZ?=
 =?utf-8?B?VWVUZmViS2F2QllPKzBRL2JpQXFmdzUyUU5lZk8rbklRWUUwd2VoNE4vcit6?=
 =?utf-8?B?WFRvR2dEV3poVExhU2c5WXFIMm1yY3I3c1NLcWN6RHkwbXFHTUhBc3ZiSWJ4?=
 =?utf-8?B?VkdZMjlTcFRtaFFkclE2NUkya05zemkrLzZPM3NuTzVTVi8rOWxUZk8xME1O?=
 =?utf-8?B?VWk0eGVJOHZvUFQvdnptcDFGSEhnamtxajdKYnVDTEwybmc4THVEcjZlTXVj?=
 =?utf-8?B?NWovVEdzL3NDUlR3WFMyWHJGdjZqbzgrNHBYaWN2RWxZRCtEcnViWGlTQUdC?=
 =?utf-8?B?K1pvVzBVL0NxQXpidy9sRHFTSS9YQytRdXJmWWg3bXNuT3p1d0FGWmlDSjlr?=
 =?utf-8?B?Rm1uV0FoVlFKYmJES09wamQzeEtDTVFIYy9nRkh5bnVaVEErU0xaOFBvSGZI?=
 =?utf-8?B?KzQ0V0lKdk91Y2hmYXhZVXRJZFU1dUlWSC9DaVJJV09iTFNiWnVhMCsyTjFx?=
 =?utf-8?B?UTRxdmNVR0M5ckkvdWYyWXNWTmR0RERxbnljQm5FMy93YlY2a25QdlJsWFdh?=
 =?utf-8?B?Tml2Nm5iMEVxajhHbW44YzBIWTVHQWhnRE9PK0FqT0FFYVFJeVR0SXRwNDJ0?=
 =?utf-8?B?Tlgvb29qY01FQnd0bmdjWTh5KzcwMUVWaThpZTV1NGpQWTVvTHptbVN0anRT?=
 =?utf-8?B?T1JpSzR6RjhqS0UyRVFQMDZaVkxnajdjeGIxZzhPejA4WitqRVhvNlliZzkv?=
 =?utf-8?B?Z3BJamZkM3l6K0IyUkd1ZE9Pc0E0ZDZKQ0huUGxmRFdBQW04eWJhdEsvTENn?=
 =?utf-8?B?RkZ1ZnpBdEVMdmJlQ0M2WTV4QjgwS2czWkRUNXpoSERkbzJ2SWVUdnVOeDd4?=
 =?utf-8?B?MDdxak5rd1RzSlNBNkZiL3M0KzZ4Qk5rOWNTcEo1Wm91dExTa3RVcnNoZExH?=
 =?utf-8?B?L0xteU5ZSDl6dU96S1U2Z0VrMVRmTE40VzRSeEkrVjcvY01vcnhNWmhzRlhM?=
 =?utf-8?B?QzlYKzlIaUljRnNqekhFazN3eUZtZXE4blRBUWxXMEdjYWFSRElUdnczcUJo?=
 =?utf-8?B?ZXVIQ2N2Y0xsNjFBQnZTQUFNMlNUZThOU0NSZmhYOXpHTjlzK3NQWjNTemtH?=
 =?utf-8?B?U1oweS8vbFZ0WGtmcmp3UmYwOVRTYzRlNUlGVkloQ2FPejUyMTM1ek9WdmdM?=
 =?utf-8?B?OFptaktPRHYyZzl0czlQTWljWVNGNGk0UHA2dk43YXBLZGVzanE0V1RKd295?=
 =?utf-8?B?b08yc2hJSDlVNHpiUk93aGxzdGs3Sm5HQ3lWdFVBbzFFSWV1SnkzeGd6VnJu?=
 =?utf-8?Q?z37iP20ZELqoGoXCsIi3xFL4k?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FCFF46F3CDD1384185FF3100D992DCC4@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5549.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0da3a255-50d9-4398-bfdd-08db5537747f
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2023 11:28:06.8707
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: puidPGAyQsDat5TpMm53vC59lHa/g/vX+PT934OAWY4ZGAEnNHNQ9BOYAufGb8stBho3EUx69DHrLpRCED/MYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8454
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gNS8xMy8yMDIzIDg6MzUgQU0sIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6DQoNClJldmll
d2VkLWJ5OiBaaGkgV2FuZyA8emhpLmEud2FuZ0BpbnRlbC5jb20+DQoNCj4gQmFpbCBmcm9tIHBw
Z3R0X3BvcHVsYXRlX3NoYWRvd19lbnRyeSgpIGlmIGFuIHVuZXhwZWN0ZWQgR1RUIGVudHJ5IHR5
cGUNCj4gaXMgZW5jb3VudGVyZWQgaW5zdGVhZCBvZiBzdWJ0bHkgZmFsbGluZyB0aHJvdWdoIHRv
IHRoZSBjb21tb24gImRpcmVjdA0KPiBzaGFkb3ciIHBhdGguICBFbGltaW5hdGluZyB0aGUgZGVm
YXVsdC9lcnJvciBwYXRoJ3MgcmVsaWFuY2Ugb24gdGhlIGNvbW1vbg0KPiBoYW5kbGluZyB3aWxs
IGFsbG93IGhvaXN0aW5nIGludGVsX2d2dF9kbWFfbWFwX2d1ZXN0X3BhZ2UoKSBpbnRvIHRoZSBj
YXNlDQo+IHN0YXRlbWVudHMgc28gdGhhdCB0aGUgMk1pQiBjYXNlIGNhbiB0cnkgaW50ZWxfZ3Z0
X2RtYV9tYXBfZ3Vlc3RfcGFnZSgpDQo+IGFuZCBmYWxsYmFjayB0byBzcGxpdHRpbmcgdGhlIGVu
dHJ5IG9uIGZhaWx1cmUuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBTZWFuIENocmlzdG9waGVyc29u
IDxzZWFuamNAZ29vZ2xlLmNvbT4NCj4gLS0tDQo+ICAgZHJpdmVycy9ncHUvZHJtL2k5MTUvZ3Z0
L2d0dC5jIHwgMSArDQo+ICAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspDQo+IA0KPiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJtL2k5MTUvZ3Z0L2d0dC5jIGIvZHJpdmVycy9ncHUv
ZHJtL2k5MTUvZ3Z0L2d0dC5jDQo+IGluZGV4IDJhZWQzMWI0OTdjOS4uNjFlMzhhY2VlMmQ1IDEw
MDY0NA0KPiAtLS0gYS9kcml2ZXJzL2dwdS9kcm0vaTkxNS9ndnQvZ3R0LmMNCj4gKysrIGIvZHJp
dmVycy9ncHUvZHJtL2k5MTUvZ3Z0L2d0dC5jDQo+IEBAIC0xMzA2LDYgKzEzMDYsNyBAQCBzdGF0
aWMgaW50IHBwZ3R0X3BvcHVsYXRlX3NoYWRvd19lbnRyeShzdHJ1Y3QgaW50ZWxfdmdwdSAqdmdw
dSwNCj4gICAJCXJldHVybiAtRUlOVkFMOw0KPiAgIAlkZWZhdWx0Og0KPiAgIAkJR0VNX0JVR19P
TigxKTsNCj4gKwkJcmV0dXJuIC1FSU5WQUw7DQo+ICAgCX0NCj4gICANCj4gICAJLyogZGlyZWN0
IHNoYWRvdyAqLw0KDQo=
