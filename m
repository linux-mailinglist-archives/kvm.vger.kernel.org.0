Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5EB560B47
	for <lists+kvm@lfdr.de>; Wed, 29 Jun 2022 22:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbiF2Uz2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jun 2022 16:55:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiF2Uz0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jun 2022 16:55:26 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CA1A248CE;
        Wed, 29 Jun 2022 13:55:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656536121; x=1688072121;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/fqQrTbB5hwvEF8/wgk0nHNjlG+nsxOv0K37xyKVse8=;
  b=e40tpIwt01UB1Yz6WXMMvrZml8zQfGj6S8iW6xHEtZEImitdIzwBcJkg
   6Nss04YoV5Ds0tf556AFsMw2zALuRG1nCZ570LsTF/TxijvYXH9amio+l
   fnPjMjx+NRO91Jy6CtYsegZ07Y6QUeVjULHoQUm6xBwrag/rYfb1vpgpJ
   GfLAzY1Qecl00YgN5EctpSpsheyQhoDFQYgAdQ6o/DvUGTXnOClYAV1DP
   f6Fm7ZHA/GM2Vz7pa3CRw+74GKnRa/BajCZlq+JkasxgpRY1E0ox9zlii
   7U6OUQek1+jBnfpGvJ+9VF6iKjR/KGifTXbsaCEinQ6YqMAMph4jpbaKP
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10393"; a="283252514"
X-IronPort-AV: E=Sophos;i="5.92,232,1650956400"; 
   d="scan'208";a="283252514"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2022 13:55:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,232,1650956400"; 
   d="scan'208";a="623452516"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga001.jf.intel.com with ESMTP; 29 Jun 2022 13:55:21 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 29 Jun 2022 13:55:20 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 29 Jun 2022 13:55:20 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 29 Jun 2022 13:55:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XD7bBkibsXHC2gYzz+LhBEwVJ82v75VvSZUVXsNeK7AuKGPaeHQiwc88RuN35PeBwpxbGtM03j3JIZ05WcHQRnW2CwuQ9rNb0NcOEsKtTVoqGfGzp+s+/qpnSZbWw/NzDgFDlb9C1/qIgDHfa80slxU0EQj+hteYH3i7lo0XU7mg4DpfHN7ZDmLs8WH16YoY433UnDNaz69VWMgMVNSctBjdSY0IZ0yr+9YaIQ+yRPRjnn1IsXo8Kabf0whNJoG2EHjlfJeQ/LpArDNZ+eXZ5LPhZRl7SzDRQ/pm6eShJ5B6QFn3ntzsql5ER0mpLBL1+GwDIwBt2rX5M1PmBBVdXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/fqQrTbB5hwvEF8/wgk0nHNjlG+nsxOv0K37xyKVse8=;
 b=jCdoY/6ph29cDAUJRhnVqZJgLe/FBr5SbZK2vfcYK/0p3StJXrezIt9/b1ZCbPrmMlDj3kb86Oht3ONjNwndHZd9KAdCLUGLXZ4BR/3CyxmeYy1oBlAFdHeBx7fB9W7aLLEcsabMZrcVRjVEssZD14HBfFbMELO/kL8jAHuhorp1jeTDeYn3GTUnvfaiMgToZFnF4XUoAk4iw4Dpw+o5mBQDXST7Ny7mdumM423xMKqTkAG2Zg4XyXQy2rkYwBggJm1LCcn2YYFtXBRdX5g87Mt3M9gOZ1kR6H0MnBBnWhLBwrvm8+TycNY2M/ci7RKsd/9KqcZKgPI90Y2836ZZXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL0PR11MB3042.namprd11.prod.outlook.com (2603:10b6:208:78::17)
 by SN6PR11MB3280.namprd11.prod.outlook.com (2603:10b6:805:bb::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.16; Wed, 29 Jun
 2022 20:55:18 +0000
Received: from BL0PR11MB3042.namprd11.prod.outlook.com
 ([fe80::f8f7:ef02:6185:285c]) by BL0PR11MB3042.namprd11.prod.outlook.com
 ([fe80::f8f7:ef02:6185:285c%7]) with mapi id 15.20.5373.019; Wed, 29 Jun 2022
 20:55:18 +0000
From:   "Dong, Eddie" <eddie.dong@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Anirudh Rayabharam" <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 04/14] KVM: VMX: Extend VMX controls macro shenanigans
Thread-Topic: [PATCH 04/14] KVM: VMX: Extend VMX controls macro shenanigans
Thread-Index: AQHYik6KKFE01MBgH0muEzHMVocHMK1jv5fQgABLRoCAAtM2UA==
Date:   Wed, 29 Jun 2022 20:55:18 +0000
Message-ID: <BL0PR11MB3042FA68F1EA02B5300E01168ABB9@BL0PR11MB3042.namprd11.prod.outlook.com>
References: <20220627160440.31857-1-vkuznets@redhat.com>
 <20220627160440.31857-5-vkuznets@redhat.com>
 <BL0PR11MB304264B62299D642FF906C298AB99@BL0PR11MB3042.namprd11.prod.outlook.com>
 <YrpbiWw1E4DXQ962@google.com>
In-Reply-To: <YrpbiWw1E4DXQ962@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.500.17
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 84c380c7-c6d3-4427-3ba4-08da5a11aca6
x-ms-traffictypediagnostic: SN6PR11MB3280:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LeXPNWK6IkK4htJoTpd/Iw4bZ2HAwV9awVp7viqu26kDAyX8FWx06uF08akqExoAL50dM4qVpTH//bXvQRiUVQGiIPqefu8iemgcHw9K7H3U87pFNlovQvUJURKTmWr99f+cj6in6WXv5wa28mInyQoT5UgfpMmMXvl7iF6zIFSkijKgrIhapfvVzMB7W4w7VDNUyXuVnjwdYZnsqI9T2rywbEF6Rnq6kh3XjwK/ih5rcjZzP4vTztnKUAPhXeyWNaNLeqLoYpY0Bp16JsckgcaDW4dC8BFXl3Y/RitSaHbvUk2AAYmy5V9abJu7n5O+qc1B9mv5API86KGBrwsxAjKJj7LV5DV6vV8yi3b40E0+WsNkx/Z6Jtz+bQ/hjShjdq8gmcgdymD6DbdbBNg7YszDIKWEGyhT4OAJptPPGR2QKsTWK01AJ7PI+8tJaVuieXQheJmjmhEsF8pj7Nc9tlYsEJLxiq9PqJtLuxZLfjGWp8RgVmnKsjy4WvgrG3mwgqofOSER26U9o0vFXu6aqME30mlyl76kyDIjirpFvDBQ/usB6NquEpmL656rIfPJXuErKx7ANLMFH9X7iYcIa5emhElB6jm1xhp4QXSe84jNpDV99mzjlFvy2zn95wTRssjbLujJumLYIWzViOjUBYWJXbkcyZvSlWSE4DDeq483PJv1EqvHYYRBzqKJkYaQAVvfNLR1dFMEO7hFK/zbK49ovbARB8N75JoDQhs9Ycv3LDNFPYyfxQx3fQuTsKC0g0QonWchyMKFUTF5w2tpawbuZ/PY7j4TSIdnPQy4Dvo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR11MB3042.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(136003)(376002)(396003)(366004)(346002)(6916009)(38070700005)(54906003)(8676002)(82960400001)(122000001)(5660300002)(478600001)(7696005)(33656002)(55016003)(38100700002)(7416002)(53546011)(6506007)(86362001)(66446008)(9686003)(8936002)(316002)(71200400001)(2906002)(41300700001)(76116006)(4326008)(83380400001)(66556008)(52536014)(186003)(26005)(66946007)(66476007)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TFVlRjBmZmxXOE1SVkt6bERnSmQxdUhMMVNWeUpJUUtmOUhXTDNVTjM2cHlT?=
 =?utf-8?B?WGZFS050TVhHdGpZNWpWZ1QrN1FtVjVuOFYwTk1SK2thbHpEcGt0S0dZU1Vp?=
 =?utf-8?B?aGhuM05sdjBMMXFmWnRvQVNOQ2VnRjJjeGY3SjBaOFZwSGE5VU1YN0haSkhK?=
 =?utf-8?B?ejE5eU94TDAyNzdPUG9OeGNVdCs5ZE56TWlIUFJNK29sbUo0b2pTd0xJaklz?=
 =?utf-8?B?TXl2VXFaWFJTOWN1Sjk2dFlxd0ZoQ2VOMUhnQXk5TC92TWUzRkI4bVFBZTlm?=
 =?utf-8?B?YWFNT3lkTTRFYXg5L2VWcE8xY1QxbGdoU2NUUmtQeEFWU01JZ1NDN2tiL1Rw?=
 =?utf-8?B?b3h3MFRCZGlncXUrcGg5WGJ2eXJhc3FDc3lkblg5NEFPbzdSNDZmYjhlNkdn?=
 =?utf-8?B?VFBNclpVZkhGcnNVbXFFQTkyWUpaUG80WmZQSW10TTZud09KR2dXakhDOWRN?=
 =?utf-8?B?OXBjWEFqMXg2MExiT0NIOW4vck5xejl3OWxNcmtKUGVySFYzSE9rU21uT2ZW?=
 =?utf-8?B?OXloN3c4R3RTbXZaYzlmTFNGYmVNcHZlMVcxN1ZCOFh0enVpZGhIQlN2Z0VY?=
 =?utf-8?B?RjQ0QlI0WDc2cjJzYkxGZ2lwdzFQMnI4aVVYbjRhQWRsOVhoTE1qUHVEQSs2?=
 =?utf-8?B?aDNJNGhPNmJHZE5WVTZ3bFIxTjBiWGQ4QUxEdThkUXRDT1E3SnFmOHM4cFR4?=
 =?utf-8?B?dnNuYm40WTlwaEYrVjRHR3YwNDJmMDNNc1BtbVp0R0RsblJEL0MyZllCaXly?=
 =?utf-8?B?SHRCa09tdVQ2d2FpblJGamlpM0I0MEsxcFl2dURERWNNOE0rQVV3Nlk2NWRT?=
 =?utf-8?B?NjAwR3FlR2FqRnJPeEIyMDdYZ2VpbnBxdzg1Q25zM0tHOGo0YUpNblZwQjBO?=
 =?utf-8?B?dktNT0FtbWp2ZHdkbHlFVndqNUx0VnhkYnZJditqYWZkS09LZDQ3cnlHazE2?=
 =?utf-8?B?eFFZMithRGYyaS9seHFTbU0yWmlENGtROU4ra1NzUEpNcEdaaS8yU05RbzI2?=
 =?utf-8?B?SCt4N3hCUHp5UXJuWmxPTnVrb2RxUUNiQUVlV21DTmRuWDRCeWNYSzBjSExh?=
 =?utf-8?B?OE83aEhxQlU2WXVadUlVcWRjT2UzTUx0T2l1bHpQb2Y1NjY5V3ZvVGhESzV6?=
 =?utf-8?B?MWdvWVhoY1c4UXVscDJvWnVKUnJGQzZCVVBiSG15emlCclVLQlJKVWF0ZW05?=
 =?utf-8?B?anI5dlJoL1EyWVJvT2duRWtmVGhuZWZsZTdXNzMwU1FNU1lnUGRYWklYcm1w?=
 =?utf-8?B?YkljUUh6RWYveTFvbFlEbTZJS2pMdloybnk3Vzc4VVdEU0NyQytlMTJzaHVX?=
 =?utf-8?B?YzJubmJBZENSL2VUeCs1RnRFL3R5L3kwbHg4b1VpUEdzVUdNb3NQczlpNHhC?=
 =?utf-8?B?dVVFandSMVkrS2pOTGpWdUV5QldJNXdxU3BhbjJDMkVkWnV2bSs5U0MrNTFn?=
 =?utf-8?B?bTRrOEVkQ0NFYk9mY3RkZ0VGRmlTMFdENmJPZnNNUHpyWVViODdSOTBxdkd1?=
 =?utf-8?B?NzVRNVZMRkI4TGxXaTBzK216bStwenFoeGl1emErdXdFa2VrYkx3cGJ0TFlG?=
 =?utf-8?B?WkZ6bXQzZXN5RHFLMk5zTTZJWlY5Lys1SkhsdGh1WCtaSXJMR05xVkF6Vno4?=
 =?utf-8?B?SHgwZ3B5bk9CUEtRWFVCVWM1VnY2QUNuR2JadEhESzJ6R3pXTzJvY3NROExJ?=
 =?utf-8?B?eGVnSk44QzUySTJVVytXVkM3ZGNBSzNZZEpTM1JzU1g0bTdBKzlURm0xTjdT?=
 =?utf-8?B?aTdYNUtIOUwrdCtvYVdHMU5RMXo3NDFvcm5KbzNSK0ZrY1hlL0VaN2FxR2xv?=
 =?utf-8?B?WGlCbTh1YUhnaVRqcTdNVFJZNnpab1NTUkVXdEVaRERURUIyMnlIWkxxQm81?=
 =?utf-8?B?Si96cng4YVRKVUNoa1BhbnlQNkxXL3N5NUVGRWVvdjFRanpna2lUUUZhTmZQ?=
 =?utf-8?B?Kzl3bGFWU09KSU9FUmpRN0Z1amxuVkR5Rlk5Y2R3aXZneWRrU01HQzFNNWFU?=
 =?utf-8?B?azRHK0plRFUzVmZiMGhNcHJuSGs3MDlHSGpmb0NUWElKclNtNzRxcWdGVUpF?=
 =?utf-8?B?MGF1THdTdzhES2FvQUI5QnYrVWhpbnU2Q3YrL0I1bVd6YnVKcEtiQWRHNzB5?=
 =?utf-8?Q?Iu7LN0/FfVZVbplRjtR3shN2S?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR11MB3042.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84c380c7-c6d3-4427-3ba4-08da5a11aca6
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2022 20:55:18.3397
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4bc3jiSGnppwGzZFbM8EABeU3d7FzZMNITL/7qkdsMZOkW7GZoHLjY6Alw7F/UusxrZkV1ghFoSc1QZmMjlDTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3280
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogU2VhbiBDaHJpc3RvcGhl
cnNvbiA8c2VhbmpjQGdvb2dsZS5jb20+DQo+IFNlbnQ6IE1vbmRheSwgSnVuZSAyNywgMjAyMiA2
OjM4IFBNDQo+IFRvOiBEb25nLCBFZGRpZSA8ZWRkaWUuZG9uZ0BpbnRlbC5jb20+DQo+IENjOiBW
aXRhbHkgS3V6bmV0c292IDx2a3V6bmV0c0ByZWRoYXQuY29tPjsga3ZtQHZnZXIua2VybmVsLm9y
ZzsgUGFvbG8NCj4gQm9uemluaSA8cGJvbnppbmlAcmVkaGF0LmNvbT47IEFuaXJ1ZGggUmF5YWJo
YXJhbQ0KPiA8YW5yYXlhYmhAbGludXgubWljcm9zb2Z0LmNvbT47IFdhbnBlbmcgTGkgPHdhbnBl
bmdsaUB0ZW5jZW50LmNvbT47DQo+IEppbSBNYXR0c29uIDxqbWF0dHNvbkBnb29nbGUuY29tPjsg
TWF4aW0gTGV2aXRza3kNCj4gPG1sZXZpdHNrQHJlZGhhdC5jb20+OyBsaW51eC1oeXBlcnZAdmdl
ci5rZXJuZWwub3JnOyBsaW51eC0NCj4ga2VybmVsQHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0
OiBSZTogW1BBVENIIDA0LzE0XSBLVk06IFZNWDogRXh0ZW5kIFZNWCBjb250cm9scyBtYWNybw0K
PiBzaGVuYW5pZ2Fucw0KPiANCj4gT24gTW9uLCBKdW4gMjcsIDIwMjIsIERvbmcsIEVkZGllIHdy
b3RlOg0KPiA+ID4gIHN0YXRpYyBpbmxpbmUgdm9pZCBsbmFtZSMjX2NvbnRyb2xzX2NsZWFyYml0
KHN0cnVjdCB2Y3B1X3ZteCAqdm14LCB1IyNiaXRzDQo+ID4gPiB2YWwpCVwNCj4gPiA+ICB7DQo+
ID4gPiAJXA0KPiA+ID4gKwlCVUlMRF9CVUdfT04oISh2YWwgJiAoS1ZNX1JFUV9WTVhfIyN1bmFt
ZSB8DQo+ID4gPiBLVk1fT1BUX1ZNWF8jI3VuYW1lKSkpOwlcDQo+ID4gPiAgCWxuYW1lIyNfY29u
dHJvbHNfc2V0KHZteCwgbG5hbWUjI19jb250cm9sc19nZXQodm14KSAmIH52YWwpOw0KPiA+ID4g
CVwNCj4gPiA+ICB9DQo+ID4NCj4gPiBXaXRoIHRoaXMsIHdpbGwgaXQgYmUgc2FmZXIgaWYgd2Ug
cHJlc2VudCBMMSBDVFJMIE1TUnMgd2l0aCB0aGUgYml0cw0KPiA+IEtWTSByZWFsbHkgdXNlcz8g
RG8gSSBtaXNzIHNvbWV0aGluZz8NCj4gDQo+IEtWTSB3aWxsIHN0aWxsIGFsbG93IEwxIHRvIHVz
ZSBmZWF0dXJlcy9jb250cm9scyB0aGF0IEtWTSBpdHNlbGYgZG9lc24ndCB1c2UsIGJ1dA0KPiBl
eHBvc2luZyBmZWF0dXJlcy9jb250cm9scyB0aGF0IEtWTSBkb2Vzbid0IHVzZSB3aWxsIHJlcXVp
cmUgYSBtb3JlIGV4cGxpY2l0DQo+ICJvdmVycmlkZSIgb2Ygc29ydHMsIGUuZy4gdG8gcHJldmVu
dCBhZHZlcnRpc2luZyBmZWF0dXJlcyB0aGF0IGFyZSBzdXBwb3J0ZWQgaW4NCj4gaGFyZHdhcmUs
IGtub3duIHRvIEtWTSwgYnV0IGRpc2FibGVkIGZvciB3aGF0ZXZlciByZWFzb24sIGUuZy4gYSBD
UFUgYnVnLA0KPiBlVk1DUyBpbmNvbXBhdGliaWxpdHksIG1vZHVsZSBwYXJhbSwgZXRjLi4uDQpN
bW0sIHRoYXQgaXMgZmluZSB0b28uDQpCdXQsIGRvIHdlIGNvbnNpZGVyIHRoZSBwb3RlbnRpYWwg
bmVlZCBvZiBtaWdyYXRpb24gZm9yIGEgTDEgVk1NID8gTm9ybWFsbHkgdGhlIFZNIGNhbiBiZSBj
b25maWd1cmVkIHRvIGJlIGFzIGhhcmR3YXJlIG5ldXRyYWwgZm9yIGJldHRlciBjb21wYXRpYmls
aXR5LCBvciBleHBvc2luZyBhcyBjbG9zZSB0byBoYXJkd2FyZSBmZWF0dXJlIGFzIHBvc3NpYmxl
IGZvciBwZXJmb3JtYW5jZS4NCkZvciBuZXN0ZWQgZmVhdHVyZXMsIEkgdGhvdWdodCB3ZSBkaWRu
J3Qgc3VwcG9ydCBtaWdyYXRpb24gaWYgTDEgVk1NIHlldCwgc28gZXhwb3NpbmcgaGFyZHdhcmUg
Y2FwYWJpbGl0eSBieSBkZWZhdWx0IGlzIGZpbmUgYXQgbW9tZW50LiBXZSBtYXkgcmV2aXNpdCBv
bmUgZGF5IGluIGZ1dHVyZSBpZiB3ZSBuZWVkIHRvIHN1cHBvcnQgbWlncmF0aW9uLiAgVGhpcyBN
QUNSTyBkbyBoZWxwIGFueXdheSDwn5iKDQoNCj4gDQo+IFRoZSBpbnRlbnQgb2YgdGhpcyBCVUlM
RF9CVUdfT04oKSBpcyB0byBkZXRlY3QgS1ZNIHVzYWdlIG9mIGJpdHMgdGhhdCBhcmVuJ3QNCj4g
ZW5hYmxlZCBieSBkZWZhdWx0LCBpLmUuIHRvIGxvd2VyIHRoZSBwcm9iYWJpbGl0eSB0aGF0IGEg
Y29udHJvbCBnZXRzIHVzZWQgYnkgS1ZNDQo+IGJ1dCBpc24ndCBleHBvc2VkIHRvIEwxIGJlY2F1
c2UgaXQncyBhIGR5bmFtaWNhbGx5IGVuYWJsZWQgY29udHJvbC4NCg==
