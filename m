Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7613772D4F4
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 01:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235018AbjFLXba (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 19:31:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjFLXb3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 19:31:29 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90113E6B;
        Mon, 12 Jun 2023 16:31:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686612688; x=1718148688;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=S9JLGivn5iwkntwNXFbsBU0vICAiWGjeEQqmpVFsXHw=;
  b=bxPniov2e04gKT5fJ2Uu0JQMCGbT36jD/oaHF7557grUVGRia305Qn7a
   O/kC5dRondnYaxxFZzN0rYBMAIWDB496sitqbIMypWpvrO+JO6ZL9IVH4
   d9B+udeLRIQFsgZrCSE+i3MbF8Lau9/hw7E8MUr6b1mkANSDB1MJW0DLD
   heTMBfM330bvhIP9PL7jG2IMkmRXKIUK9+4MBUmA+rcQXOQlfpRuOj2JH
   zDBHcQGN2U5M5WTBO1Ga3BNIGGvTBI/UekGrtv3nCVm4+HgVUJf3NEPZ/
   CVseRN72bcbUy3uoMw7JtHUqFXXk06SbYKjw5P4RgOmHgm3n6aNqS0AF7
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="357072518"
X-IronPort-AV: E=Sophos;i="6.00,238,1681196400"; 
   d="scan'208";a="357072518"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2023 16:31:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="688815356"
X-IronPort-AV: E=Sophos;i="6.00,238,1681196400"; 
   d="scan'208";a="688815356"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga006.jf.intel.com with ESMTP; 12 Jun 2023 16:31:27 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 12 Jun 2023 16:31:27 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 12 Jun 2023 16:31:27 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.103)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 12 Jun 2023 16:31:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GT4mACZc3A6iaf0p6Ulot4wScmjvffQ9rh9eZMLQRFLOcK0KkB/LL5Q1eudI8GSiTE5axrv0szkdH7loHr4ldSJvUoXQXOA2IAKStKBvBetl3Klz64pa8JdhHufnlpY8cA2FQogXtY5ghmau/2ys6MO6gtpNf2J4f+K0gJTHwR3xbsie0YegzyMSVYLD/D0xQ7ZAg+2/tI+Fjsb79Xpai/n+NBUqUbgz3S/vFOIkiIsVhNpKlBZ/c8XYtyczAmFeVwB8haMokKBgn5I4RUc8cerdYB57tBXytX8loC8I7mjWrT/EkSrEFC9IBzl5RDouamkVe54IkFv3x4U/aXs/bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S9JLGivn5iwkntwNXFbsBU0vICAiWGjeEQqmpVFsXHw=;
 b=NOveH3gow1eCBH9pvPolOrp/4JfS5FuJNWmzxClZ0xF7Y5puza6TIPPhOR2A6+PWyRcWgbki2tjwhTPMEscHmRWERNkS9iO+Mihr8TPOsgQZ29B5JORT4NqbH9kbFke2ufEq5da9wQb5RxBQ3R1cYCQoxgnpnhjlQyGtevZS3cTKFsEzHolYmnpqwwnx2jCPcp4W1DS4msdoX0tE/J9k/PaDg7+G92WnMnQjoyKtyduiGJfBJ7J5gUYGqMVhFBG2LtOSvbFn37UHOEgSxFBdT7YBY8PW/akSGileHEAkuoN6DtCJ/h6Dxw2ahjkDefjuSApSr2wQSj1ZOHg720HlpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MW4PR11MB6810.namprd11.prod.outlook.com (2603:10b6:303:207::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.39; Mon, 12 Jun
 2023 23:31:24 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6455.043; Mon, 12 Jun 2023
 23:31:24 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v11 19/20] x86/mce: Improve error log of kernel space TDX
 #MC due to erratum
Thread-Topic: [PATCH v11 19/20] x86/mce: Improve error log of kernel space TDX
 #MC due to erratum
Thread-Index: AQHZlu+6CL+cHWwyoE2KpZjKTZv14K+Ce7kAgAQMw4CAAFEuAIAAYl4AgACiFYA=
Date:   Mon, 12 Jun 2023 23:31:24 +0000
Message-ID: <9e9b9a4ff4b30ed21c1c26a87d0ca839ab08f60f.camel@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
         <116cafb15625ac0bcda7b47143921d0c42061b69.1685887183.git.kai.huang@intel.com>
         <20230609131754.dhii5ctfwtzx667o@box.shutemov.name>
         <90aefcfd663c654197c5878e410f55cc4473eb79.camel@intel.com>
         <20230612075910.jqkiofjm6mkdl7cy@box.shutemov.name>
         <f4d7c31f-18b4-e98c-a08a-2352813c9c8d@intel.com>
In-Reply-To: <f4d7c31f-18b4-e98c-a08a-2352813c9c8d@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MW4PR11MB6810:EE_
x-ms-office365-filtering-correlation-id: f06069c5-4fa8-449d-059a-08db6b9d22df
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2xeI8YR0Z9lYYTknbuLeAkOnuu3uf2qrUzSBQA+hO7l0XaEZkcFRV7gYC+ZuoBZ+zhmWZ3d4IP4FGtTwBXJJ0KpbmxgO673xhqYf2e/B6Aw1k5e3C447XKpUvq0yZbyOPqViY4tiLumHmq/52TC0BszPvq+Gd2I1Gwp+InfM5lLvKFkn7+lsF1xevTW8iL0PmxgMjb+sv+VshniAWuvs3cJYnDlInY+QCUtK+adC3BaRXQE8EB8ZSsisVy36IGvMeu5NQCL4pF3UOrLlOxHoQ0ueO7Jn12yd3uWdcah+WxMjLDJWkqk5xBZTshS5BLh+RWOcjG+onxTcwUqbnB+xK7Knun9iYe+TGIw2B72q1II9SDfxYiEscL7ReL5rNHt6rcO+15xwYGN+3cK+mzuR6EwJucv//zbjsEXv3+FR05NCCdxS0xBBE6EEmKNLpue994A4V5xf/TMvfcFdtRqrsQTGUhQ2/yfKj1oDGlsdyX29BfsVJXO8iJT/FcKvQmFOuL1V0rh7KmE1jhtcepwtqENqZ88j2dLp6HhxBjW6sYzw2adzBe123BdEMw3IDXnHI4Z7f7RFG7Qp+ziYwStf0uRHsvpVX42r8lRPdAvqSyFXHo4KKbAPqj+qkfv9O6zw
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(346002)(396003)(39860400002)(376002)(136003)(451199021)(53546011)(6512007)(6506007)(186003)(26005)(6486002)(2616005)(122000001)(38100700002)(71200400001)(36756003)(66946007)(6636002)(64756008)(76116006)(82960400001)(66446008)(66556008)(66476007)(91956017)(4326008)(478600001)(8936002)(38070700005)(86362001)(8676002)(54906003)(5660300002)(110136005)(41300700001)(316002)(7416002)(2906002)(4744005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WWxQV0k1dGNiQThOZFBpMXJvajJydDV0QkdXbEpkNlpGZlhDYjZOWDVET3hn?=
 =?utf-8?B?YUZ6YUZrNnp1akVISUxoMHNNeDUzSTd6emIyVUVHYi92cWc0QWlrKys2YUky?=
 =?utf-8?B?Q2tPMEFwU1pJTk0vQ1RWcGMwWUNmZzZteXVxalZFOVluckNCV0gvZXkvOHgw?=
 =?utf-8?B?RzF5cnM4Q0ZjM0I4WTdxZGd6VGJlbzlCN3JpN01JRUNZRWdIbkpUZlZ6dUVY?=
 =?utf-8?B?b2tFR1VJcTZ2MWRHOC9lOWZwQnhPSEJ1b2lSMGxXbDI4NkJRdFNqNWNDU2tO?=
 =?utf-8?B?U3Q2WHZHaTI4UTY0ZUMra1V3QXUzbnJpZmUwTHJFZTBZZFlqdEUxUEVNV3BD?=
 =?utf-8?B?UnJmd2htRm83WWYyU3o0NWtHaHpma2JvSzY0NnBXT0U0alV2UWd5cDlFem9Y?=
 =?utf-8?B?NkhIckZRT3ByMGYveEsyQVU0QXVLbi9NUWNRdTVHbFNnWHZNT3c1aVZKeDN0?=
 =?utf-8?B?RjRzMmJua3BuYk1CUnlrVUNjQndDeE9RRkJKVUJkWEx5U3c2MFRJYS8vU3Za?=
 =?utf-8?B?MlRWVVNOQm14aXlOSWM2TFJSR1BTNzZEVXFza2dtQVVRcmxiM1FFZXBkd25w?=
 =?utf-8?B?WTJ5SDQ3RmtETnZaK3B3dkNhTkRMNFRuQ0pKTGFIdnRKWHp6QkhrOUE0bmZq?=
 =?utf-8?B?T3RIOEk2a0I2Wkd0dk95T0VUajdyQkpESG05Q04xekhjVWVjOFdDemcwWG9B?=
 =?utf-8?B?Smhtbk15a2o2WVN5SGZla3FCMWNNelMzdmJyTDdLck1FclU4eW53SUlFcFly?=
 =?utf-8?B?YU9XeStpL2J1RDJKbzFyQTVDY2Q0bHZSQlFuZmE5OXFHemZheElpUlExaEhn?=
 =?utf-8?B?VkppM1NQNVBhaVNUaUh1cUsyRnNyMmpNL0pQTnM4QVY1Yy9hU014SkxSZ3dm?=
 =?utf-8?B?WTZRQllTdEk4TStUVUJnd05JZGdIVDlDck9taDhLZDVTK3ZtdHVIZm5rWWJl?=
 =?utf-8?B?SmVuSHhrWjBtYVhtMDIzL1ZvS3JHTDdMTjZtK1IvWW5tS0ZoWTVQK2tEb2hi?=
 =?utf-8?B?dUlRRGlNYlFrNE5pT2p2dFdWbEJGSkZqWE4rNXVPNEdkeXduUGl4Qmxac2pC?=
 =?utf-8?B?SlFaK1NiYnoraWJRc0VuWkp1bHA5dHlOTFAyZVp1S0gxbGRUWXJ4WGlJWm5v?=
 =?utf-8?B?TWVwTHFmUFI3OHE1ZTZXM21HbTh2ZmR1ZmJVcVJNbSs0QU9QSXpBWDkweUU1?=
 =?utf-8?B?cUpYWjdxSGs2TlhSYWROaU1ZQ3kwS1AwR3VacUltZ0ZqMEFrZndFMmRDUnZS?=
 =?utf-8?B?YmdlaUI2NlJXTkZDQVhUQkFwUnhTNTM4SlNnL1UvRnRmWENKY1AxVVM1VFFC?=
 =?utf-8?B?UFZhMUR5MWgvZ2NxVFI1Rk9TTTZCdHFsUlVkc3NXZjg3NzFROFlaVWg1R01j?=
 =?utf-8?B?MXByQ1BOdTRaUHgxMnpXYnhDUnhrTkVzaTBmZlZNOG1BN0ZFT2RTUy9UZjhL?=
 =?utf-8?B?OXN3MjFYS2ZlNXBQeVpuODk5ZVY0TkhnU0dia3hRMndvWGYyeDRHb09HaE9M?=
 =?utf-8?B?U0c5ZHdndVBCMzUrdHVXMDA3MGEzY1RKRzc4V3k1WFpLbFZRVlJKZFBDU0tL?=
 =?utf-8?B?YXpUQVZnK0J5eUxtNmhoL1dmbUlTTDJhWGN3SGxoTUxpb21kbUhmR2JlUmt1?=
 =?utf-8?B?OUZsZUVzbm40NjF0ZGpwTjN2Z2VNL1gxSHR6N1diV1NjR0FTYktPZzdoQm5w?=
 =?utf-8?B?cFVpcE9DakVkTDJWT0pBVmtabGhrUDBzK0VwSkpidGxKdGp2STZuTkVObU96?=
 =?utf-8?B?RXp6TzRQTmxHcWtJUWdqT25lRU40ekdSTmYvOFJyWXhTM0xqb0gzUHNCclc0?=
 =?utf-8?B?QzRsSTh2Z1RQT2JQWDlRekMwbUdWSVU3WXdyM0VUTGptYkFrYi9pWVQvTFl2?=
 =?utf-8?B?YVdmeEpRcEVnRUY4SnY1UW1wWDBPOXFhb1Q0RHRvM29DYVNma3QwQTd1VHZ0?=
 =?utf-8?B?b05tNFFwcXlQeWJ2RlJpblR6dlhyOUVBbjh6c2dTaEZqdzVVcFhtVWxFWkdv?=
 =?utf-8?B?clhyVkZuR1lDbERUS1pESFg4OGNDSVE5NityWWlFcnF5UlpWR1AyaHBsK0t5?=
 =?utf-8?B?bmJPRUNwNStqeHAvQUdhelJuODQzRzBqRnM0T1hQRkxmUlZYRFA3QWVKM2gx?=
 =?utf-8?B?S1QzK0JlZk1vVE5LWG9ZelNONG5YOFEvdjhsQ1ZqQUpWMXJ1SEpiWVkvb0dC?=
 =?utf-8?B?Vnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B285B151BEF03C438CF9E45F70C04AB2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f06069c5-4fa8-449d-059a-08db6b9d22df
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2023 23:31:24.1539
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OMeWeBSxOgEVvl8We3/RZbQtmFe2sHyQl9/LEiljLGFVPRhiDg7190HgPa6HMY83wnJu6xDX/XToeZNnysCkQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6810
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uLCAyMDIzLTA2LTEyIGF0IDA2OjUxIC0wNzAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gNi8xMi8yMyAwMDo1OSwga2lyaWxsLnNodXRlbW92QGxpbnV4LmludGVsLmNvbSB3cm90ZToN
Cj4gPiA+ICJNZW1vcnkgZXJyb3IgZnJvbSBURFggcHJpdmF0ZSBtZW1vcnkuIE1heSBiZSByZXN1
bHQgb2YgQ1BVIGVycmF0dW0gY2F1c2VkIGJ5DQo+ID4gPiBrZXJuZWwgYnVnLiINCj4gPiBGaW5l
LCBJIGd1ZXNzLg0KPiANCj4gSnVzdCBiZSBzaG9ydCBhbmQgc3dlZXQ6DQo+IA0KPiBtY2U6IFtI
YXJkd2FyZSBFcnJvcl06IFREWCBwcml2YXRlIG1lbW9yeSBlcnJvci4gIFBvc3NpYmxlIGtlcm5l
bCBidWcuDQoNClRoYW5rcyENCg==
