Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27CD56F6235
	for <lists+kvm@lfdr.de>; Thu,  4 May 2023 01:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbjECXtt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 May 2023 19:49:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbjECXts (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 May 2023 19:49:48 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3CE08A57;
        Wed,  3 May 2023 16:49:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683157786; x=1714693786;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=AHqleT4kG6RAxw0MptMc1dQDu1WHBD27qV4hnRU1AW0=;
  b=kW/L4THMeGQDTo1g4kxfq9eWUdaZ0wqMudQJI8+cKPRVyZJHatcaPmVP
   KPr9SQRg17zltzw7b61WUXHW66XRr2x+imFX0rGRu3yBPiTlmFBBaOj7O
   54t4BKHs7msTYm4AdZRjlqE6u97NZhNg/HmQlTv1NR5KyWgl5ZqD4dg/l
   dQiuXe/viAIZGWS0PLDgdJZDgNPVN5r1iu9VVKDk91tW3XrIJvOYc1yPS
   OcJsGMtSn4gjBu0+9e/kJQ4UTbNp+i5kgteFLyJOEhAjhxtHC60HNqGJ7
   ZI3eBLzyxi4RkWY1HxxYqTRqXn9BZLfbwxiXd7Bm+V8ppUTudcJ0wVbNI
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10699"; a="333161010"
X-IronPort-AV: E=Sophos;i="5.99,248,1677571200"; 
   d="scan'208";a="333161010"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2023 16:49:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10699"; a="674295569"
X-IronPort-AV: E=Sophos;i="5.99,248,1677571200"; 
   d="scan'208";a="674295569"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga006.jf.intel.com with ESMTP; 03 May 2023 16:49:45 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 3 May 2023 16:49:44 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 3 May 2023 16:49:44 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.43) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 3 May 2023 16:49:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wc9CnkhYdNm+L/zpnR1AJxcj+eOPX4LrVA6BhOhj5+T21FEnv7RVji+i/5JYwT7rE/gumDzE1To7Jn2MJ/fLXYspmmFsHknHVozy/R9G9ZmIQi4HisHNtVpiSEyXKXARfharJruqC++h3QdAgY6Vo89UaaFRJpczpuRRpqQmDhZjPDjFy/oBZkX0EBvQ1CkaYeojQSta8h5TEiz+65R5ZBslaJKECfsS5NgGJs/0WDbAF/OzDWsOYN4i/YVDo6F2ZIF5BbIgJ+f4pYvDpVgbWGiMp3tgcD1LtZFQtQ/kjHzY+4Alx0BX1KW7ncPLkTrVVrrvI0Kg8gaOO7NpZkevGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AHqleT4kG6RAxw0MptMc1dQDu1WHBD27qV4hnRU1AW0=;
 b=XUgqxvLs+Pq7ikha3bN706O8kkJiI35Qjm+hFpKGc67+pUrTUFSAIkxs1kJqm25P2Y6hH36SOLA1v9QtAF59eCvBA8MZWakPwiFjNbPfwrm1pNyX7zwT9+ou/Mw7hxCKLhXQsw9KQtWPdOhbwKdpZ1ciNfMM7NeYs1E1YdTz/TBk6mmGmwyxvLv+L6DI+1yqk086pSOBFq/FlpSQu66mNT8a6MZQzYKeUeMUlhVRgMCbQScK/NopI0xBdRmQPLaeeIK1ONtud7rBfFDrXL6ZIzG2R/akN8IC+ux1fDadw4zAHiStyKvLx0MWAxiH2DuJlnVJbBt1LQkqfwNxVeBwEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA1PR11MB5945.namprd11.prod.outlook.com (2603:10b6:806:239::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.22; Wed, 3 May
 2023 23:49:36 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2%5]) with mapi id 15.20.6340.031; Wed, 3 May 2023
 23:49:36 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "guoke@uniontech.com" <guoke@uniontech.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "haiwenyao@uniontech.com" <haiwenyao@uniontech.com>
Subject: Re: [PATCH 3/5] KVM: x86: Use MTRR macros to define possible MTRR MSR
 ranges
Thread-Topic: [PATCH 3/5] KVM: x86: Use MTRR macros to define possible MTRR
 MSR ranges
Thread-Index: AQHZfe1ov2lIQfXQHEGWFmfB/aS7ZK9JMM2AgAADfoCAAAOrgA==
Date:   Wed, 3 May 2023 23:49:35 +0000
Message-ID: <50845b82a804a5891f18508f73dd3e5d8d49950c.camel@intel.com>
References: <20230503182852.3431281-1-seanjc@google.com>
         <20230503182852.3431281-4-seanjc@google.com>
         <b57efeeb80319183e93d5a10bc8a812ff891bd53.camel@intel.com>
         <ZFLvytrl+Lj+mC4L@google.com>
In-Reply-To: <ZFLvytrl+Lj+mC4L@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA1PR11MB5945:EE_
x-ms-office365-filtering-correlation-id: 3decf094-90fd-4db0-052b-08db4c310d0e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QsVTKZCzFOiULP7/zG7WhIU+MrYM8WV/jYVqw3WJy9ftfwYxf795LM1WmFu30xbCaYE9ay0JNZ/krqllmxXbPmvwcv1qzQCna18LWvdkgMiG0CiBojWJzGc/27Phy46m5PRuQl2biJfoqY+iUfIKi5wwgXzme3VbpMB4j5QgWHTVyZ3nvE/1TzlU4xxp0oIitoBkRmLwO96pfQiwjaeV16lZomKqT2OyDwfCFsZyG3X41eXLIYhQbvSLvRqcG+4iMq/TIlpBcACzVr2msbQkUU72gRZUHxfL1okYibb4C1rCfzXOELnAc6Axq7uSKZhlBcOwXc7vzKC8/b1hR79UBVRKko+jXrgQeV4y4NWyBXEtKyyOXHg+BE6j7vLuuC8iXE2GS8WTfI2KKKpeZvwP775eXfrog3gqAecN8CVm5zjFKrBdycm++qSE8nv1BxYTDpSb4OwdvrWVSJtP3S+oDx+PoCmeaOpyZxfFAoUx81gITsVJPKFdbAEqrnaNfjix5x26we3O9ktkbwYwzdBN1MMgY6N705KbwDg1c0o+HU1y7z8RZRX8k9ICfvy9RamT9V3Ctneei80pDQQ4j6OIBrrguKcV4X0w5e0b+nZvbFM0JlieryDFoHVeBkz07xTKGG5CJdr/rNddYItAr4CBQDNQ2aaklTZ30VuPAfsmyW0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(396003)(376002)(136003)(366004)(451199021)(82960400001)(86362001)(36756003)(38070700005)(38100700002)(6506007)(6512007)(66476007)(91956017)(54906003)(122000001)(6486002)(2616005)(26005)(71200400001)(186003)(8676002)(8936002)(478600001)(5660300002)(76116006)(41300700001)(66446008)(2906002)(66556008)(316002)(66946007)(6916009)(4326008)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MXNVSVFFWnpBTEp3VHhkblZVTUFiNWlFTnkrUHNoTk02RjVoaTlhTUg5dUNN?=
 =?utf-8?B?Nm0rcVFXbXVGTEtrQW5rQnh0aVhmaWJra1hwbnM2MkthVU1YUVoxOFV0UHNp?=
 =?utf-8?B?RlpybnFnRTRKc2ludWtuTWRGeWdnVkNlejhNcElXT2lGY0doNk1hcWNvV2Nn?=
 =?utf-8?B?ODdBVHJYd2NocklwbldvQkRRRVdteitpa3RxTmNlSkhjaExQNDIwdlBoWDJC?=
 =?utf-8?B?L2RRaW1SOEJSNzB0d09JcHBRaGVjZ3VKdVA0c1pFT05zUzdxT0w5Qi9jalh4?=
 =?utf-8?B?YW1ERVJLKzdiREZkQXpQWFhJbjJWbmRzTGdHYndiNjBMMmJHZVpuVitSTVV2?=
 =?utf-8?B?ZjJhZ3BaVzVHNTB5cmNRWHh3SmV4U2ZpNW5XTENncS9oUkFUZ1Z1VzRlMWd2?=
 =?utf-8?B?OFpNcEFRKzg0bS9tMVdUdUZhbHNkU00ybHlzNW01MmhBY3dKRzZFaDdyQ1R4?=
 =?utf-8?B?VXJxdnl6OVVWb01DUGxtMXZ6U3VERUJwOGkxMGx5VHN0KytRL2RqbmhSVzB3?=
 =?utf-8?B?b2VtdWx0UEVnNlp6SUtWMFB6TEhVYUs0eVd4RXVEK0FFRWRzdVdUSEN5YXRO?=
 =?utf-8?B?NVdVNS9NYUR3Um4vempFOXRmdVMzbGxHaG9nNGI2NFRjVCtDYlVDMDNYazdN?=
 =?utf-8?B?MjRoQTBUYzR1b0lmK05WQmZTcW53Y213WDlhOURUbE51OEZPb3d5NHIrcFJY?=
 =?utf-8?B?RzJmUHFFMU9ITUxVNFMzbEVhL1lybXdVa0VYZ2F5U3FPamFCTGZ3c0RzMFhC?=
 =?utf-8?B?NkdBL005bEkyTnhzV2xNZmtKT0RjWUFXZU1PVlZ5YzM3d3RUaGZuR1VsN0hr?=
 =?utf-8?B?K0JKOGxTOERCZjJPMjFyTExFNFpkM2lZdlNMbkZtYWpDTS85UWZtaWlzeUlw?=
 =?utf-8?B?VUdxY0gybGhhRXdQY2QydDdaOU93RFNhR0RIS0NSd1VwUFpIbGx6dzRhclNS?=
 =?utf-8?B?R1VXdUtzdzh1OWRtRmxkRW9ITWtWN1BwOVVnWCtkNFNUdFhQekQyd1YvVmJZ?=
 =?utf-8?B?TzRCd1luM0xxNzVURVpUNnZsbVd5Q0hja3J4eFl2UXZEZitya2ZtOTlJY1lF?=
 =?utf-8?B?WTE3dTZWd1ZyTStYcG56RUExM2t6Ti9vNmE0N3I2OU5Fc0RzVCt3MnF2c2M4?=
 =?utf-8?B?eDJ4Y1hZUlBTN3JUR1JwMkZGaUp6TVBPSWFwS1JEcFdQdGtwQ2hDbVpVdUJm?=
 =?utf-8?B?cm9GcW5tYk9WdUdtUmFNa3NWaTFvS0NxbVB5cHhGQndzWkQ3dGFYeWJUZDBi?=
 =?utf-8?B?NGRFNDlDdG5VL3RMYjZZK25RRTdiR2hIRTZVMUxYcW5idlk4Sjl2c2dzVjE2?=
 =?utf-8?B?UG5hcHJiWU9ueC81Nkl5aGkyWitvUTVFeFJLTkIxbWtxZDhNVTJxZG92Y21W?=
 =?utf-8?B?U0x5SWZQRnRISHFVdk9xUW9zNzFNcU1UbmU1Yk9jOUVHd2JnaFV5V04rbU1o?=
 =?utf-8?B?d050QXhQbUl6SFVpTUxVaGwwdlVpeWRoZjlhRVRmamwxeWN3eFNZY0JXajRF?=
 =?utf-8?B?dDNjWkR4WmxtbjR0LzgxRmx2b3JMWFZ1TjVONHVpYm1JcW9vN2NKNlVNeXEx?=
 =?utf-8?B?Zk8xWFF0MUVGZFpMbWpEMVhFWS9oa1lmeVFJKzlxc2VxVkp4Mk9EM0c0R1ly?=
 =?utf-8?B?TkViSWJsbFR4ak1DTnpNK0EzZURZNUhXSS9WRUdqN25HRzRlbVRua2tzdDZl?=
 =?utf-8?B?TkxhdHJSbE1FWXVJa0dKMGlYNDhCNEJuazNoUU1OYkxBNmdkallsQmd1VERs?=
 =?utf-8?B?N1NhWEJzeW5WNkcxamNZU3NWUzBDR2RUN2FoTW8vaUtQTHJGTWpwS01YM2cv?=
 =?utf-8?B?NGl4YVRtME5Hc2FWRFZrdkhQa1g3T0RIRm16UDFudWJkc0dwYTlma1p3dlBw?=
 =?utf-8?B?NkREcy9vb01QOTNGWXJhTi81WFhUSnpZWVVXVlBVS3hGczQzQUw5cTdZVVBh?=
 =?utf-8?B?cnNMc3dseFY1UHc3K0orWldwZUNGQkdBVkRwaGJLanV6V2V5UHZLY0pWNVV6?=
 =?utf-8?B?V3MyNnZaWDd1RW5WR2YyWGNsSVhtS1RMd2dXaWRRQWFhR2NscWVIL09LOWxJ?=
 =?utf-8?B?cUhhTCtLZ2QrZ1FXRW1HRS9WK0hiaVZnOExQQ1lXSWRKd25nQmRCWXh6eVIx?=
 =?utf-8?Q?CwMjcUweqi/GQGh9U6batGM9g?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E657952A0BC72D4686E1F4BBDEED9057@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3decf094-90fd-4db0-052b-08db4c310d0e
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2023 23:49:35.8947
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YkjpJFeDVbdFfOZtZP0acI3ECrlLoYuTvJLDojrz4F6VRC/BG8zIDMmvK/DrcxJ4sl+10iIbr+Qofwx4g0h/EA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5945
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIzLTA1LTAzIGF0IDIzOjM2ICswMDAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBXZWQsIE1heSAwMywgMjAyMywgSHVhbmcsIEthaSB3cm90ZToNCj4gPiBPbiBX
ZWQsIDIwMjMtMDUtMDMgYXQgMTE6MjggLTA3MDAsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6
DQo+ID4gPiBVc2UgdGhlIE1UUlIgbWFjcm9zIHRvIGlkZW50aWZ5IHRoZSByYW5nZXMgb2YgcG9z
c2libGUgTVRSUiBNU1JzIGluc3RlYWQNCj4gPiA+IG9mIGJvdW5kaW5nIHRoZSByYW5nZXMgd2l0
aCBhIG1pc21hc2ggb2Ygb3BlbiBjb2RlZCB2YWx1ZXMgYW5kIHVucmVsYXRlZA0KPiA+ID4gTVNS
IGluZGljZXMuICBDYXJ2aW5nIG91dCB0aGUgZ2FwIGZvciB0aGUgbWFjaGluZSBjaGVjayBNU1Jz
IGluIHBhcnRpY3VsYXINCj4gPiA+IGlzIGNvbmZ1c2luZywgYXMgaXQncyBlYXN5IHRvIGluY29y
cmVjdGx5IHRoaW5rIHRoZSBjYXNlIHN0YXRlbWVudCBoYW5kbGVzDQo+ID4gPiBNQ0UgTVNScyBp
bnN0ZWFkIG9mIHNraXBwaW5nIHRoZW0uDQo+ID4gPiANCj4gPiA+IERyb3AgdGhlIHJhbmdlLWJh
c2VkIGZ1bm5lbGluZyBvZiBNU1JzIGJldHdlZW4gdGhlIGVuZCBvZiB0aGUgTUNFIE1TUnMNCj4g
PiA+IGFuZCBNVFJSX0RFRl9UWVBFLCBpLmUuIDB4MkEwLTB4MkZGLCBhbmQgaW5zdGVhZCBoYW5k
bGUgTVRUUl9ERUZfVFlQRSBhcw0KPiA+ID4gdGhlIG9uZS1vZmYgY2FzZSB0aGF0IGl0IGlzLg0K
PiA+ID4gDQo+ID4gPiBFeHRyYWN0IFBBVCAoMHgyNzcpIGFzIHdlbGwgaW4gYW50aWNpcGF0aW9u
IG9mIGRyb3BwaW5nIFBBVCAiaGFuZGxpbmciDQo+ID4gPiBmcm9tIHRoZSBNVFJSIGNvZGUuDQo+
ID4gPiANCj4gPiA+IEtlZXAgdGhlIHJhbmdlLWJhc2VkIGhhbmRsaW5nIGZvciB0aGUgdmFyaWFi
bGUrZml4ZWQgTVRSUnMgZXZlbiB0aG91Z2gNCj4gPiA+IGNhcHR1cmluZyB1bmtub3duIE1TUnMg
MHgyMTQtMHgyNEYgaXMgYXJndWFibHkgIndyb25nIi4gIFRoZXJlIGlzIGEgZ2FwIGluDQo+ID4g
PiB0aGUgZml4ZWQgTVRSUnMsIDB4MjYwLTB4MjY3LCBpLmUuIHRoZSBNVFJSIGNvZGUgbmVlZHMg
dG8gZmlsdGVyIG91dA0KPiA+ID4gdW5rbm93biBNU1JzIGFueXdheXMsw6/Cv8K9DQo+ID4gPiAN
Cj4gPiANCj4gPiBMb29rcyBhIGxpdHRsZSBiaXQgaGFsZiBtZWFzdXJlLCBidXQgLi4uDQo+IA0K
PiBZZWFoLCBJIGRvbid0IGxvdmUgaXQsIGJ1dCBJIGNvdWxkbid0IGNvbnZpbmNlIG15c2VsZiB0
aGF0IHByZWNpc2VseSBpZGVudGlmeWluZw0KPiBrbm93biBNVFJScyB3YXMgd29ydGggdGhlIGV4
dHJhIGVmZm9ydC4NCj4gDQo+ID4gPiBhbmQgdXNpbmcgYSBzaW5nbGUgcmFuZ2UgZ2VuZXJhdGVz
IG1hcmdpbmFsbHkgYmV0dGVyDQo+ID4gPiBjb2RlIGZvciB0aGUgYmlnIHN3aXRjaCBzdGF0ZW1l
bnQuDQo+ID4gDQo+ID4gY291bGQgeW91IGVkdWNhdGUgd2h5IGJlY2F1c2UgSSBhbSBpZ25vcmFu
dCBvZiBjb21waWxlciBiZWhhdmlvdXI/IDopDQo+IA0KPiBDYXB0dXJpbmcgdGhlIGVudGlyZSBy
YW5nZSBpbnN0ZWFkIG9mIGZpbHRlcmluZyBvdXQgdGhlIGdhcHMgYWxsb3dzIHRoZSBjb21waWxl
cg0KPiB0byBoYW5kbGUgbXVsdGlwbGUgTVNScyB3aXRoIGZld2VyIENNUCtKY2MgY2hlY2tzLg0K
PiANCj4gRS5nLiB0aGluayBvZiBpdCBsaWtlIHRoaXMgKEkgYWN0dWFsbHkgbWlzc2VkIGEgZ2Fw
KQ0KPiANCj4gCWlmIChtc3IgPj0gMHgyMDAgJiYgbXNyIDw9IDB4MjZmKQ0KPiANCj4gdmVyc3Vz
DQo+IA0KPiAJaWYgKChtc3IgPj0gMHgyMDAgJiYgbXNyIDw9IDB4MjEzKSB8fCAobXNyID09IDB4
MjUwKSB8fCAobXNyID09IDB4MjU4KSB8fA0KPiAJICAgIChtc3IgPT0gMHgyNTkpIHx8IChtc3Ig
Pj0gMHgyNjggJiYgbXNyIDw9IDB4MjZmKSkNCg0KSSBzZWUuICBUaGFua3MuDQoNCj4gDQo+IE5v
dGhpbmcgZW5vcm1vdXMsIGFuZCBpdCdzIG5vdCBsaWtlIG5vbi1mYXN0cGF0aCBXUk1TUiBpcyBw
ZXJmb3JtYW5jZSBjcml0aWNhbCwNCj4gYnV0IGFkZCBpbiB0aGUgZXh0cmEgY29kZSBmb3IgcHJl
Y2lzZWx5IGNhcHR1cmluZyB0aGUgTVRSUnMgaW4gYm90aCB4ODYuYyBfYW5kXw0KPiBtdHJyLmMs
IGFuZCBJTU8gaXQncyB3b3J0aCBiZWluZyBpbXByZWNpc2UuDQoNClJpZ2h0LiAgV2UgZG9uJ3Qg
bmVlZCB0byBjYXRjaCBhbGwgaG9sZXMgdW5sZXNzIHdlIGVmZmVjdGl2ZWx5IHJlbW92ZQ0KbXNy
X210cnJfdmFsaWQoKSBhbmQgY2F0Y2ggYWxsIGhvbGVzIGluIHg4Ni5jIEkgZ3Vlc3MuwqAgQnV0
IHNlZW1zIHNlcGFyYXRpbmcNCmZpeGVkIHJhbmdlIHZzIHZhcmlhYmxlIHJhbmdlcyBzZWVtcyBt
b3JlIGNsZWFyIGluIHRoZSBjb2RlLg0KDQpCdXQgYXMgeW91IHNhaWQgd2UgY2Fubm90IGp1c3Rp
ZnkgaGF2aW5nIGR1cGxpY2F0ZWQgY2hlY2sgaW4geDg2LmMgYW5kIG10cnIuYywNCnNvIG5vIG9w
aW5pb24gaGVyZS4NCg0K
