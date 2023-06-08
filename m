Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83BD67274BE
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 04:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232920AbjFHCKz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 22:10:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjFHCKx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 22:10:53 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E47726A1;
        Wed,  7 Jun 2023 19:10:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686190249; x=1717726249;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=jDOq2wKt4EAv4T8of4KjEmEyD0DHIhZS6o4oStTg7Is=;
  b=DGnQuOhUbrVLT8l1RUSslIAH+ErsseQLkZ+tRXOau1/zYbY30g0q7kEo
   e9yUdwHaY6cW52eelxjV0dU9b2C4d7QwllJlD7fpA2y5o/7mC3aFSIYz4
   va0TeDAN4AnmStHS4B5Kn8FiMX0t5SwNB+opXKqZoeLl/Z6wcinYF3kNd
   bdlgkC7eQZQCzl8Nenlcpe3IYeLRUXGiDzSrbarv/PBtsofHhqcSuhiQh
   0brE9FaLJF0O/vd6Udfu0hpXoL9x1jm+WKLy6cfao3BgICvTiVzLOogB1
   HcpkpnqTaRPYFh5oKm/04vC9KSviF1jB4sJT0+uRQ890unkrPnsYMaS8O
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="385510219"
X-IronPort-AV: E=Sophos;i="6.00,225,1681196400"; 
   d="scan'208";a="385510219"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 19:10:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="703890833"
X-IronPort-AV: E=Sophos;i="6.00,225,1681196400"; 
   d="scan'208";a="703890833"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga007.jf.intel.com with ESMTP; 07 Jun 2023 19:10:48 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 7 Jun 2023 19:10:47 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 7 Jun 2023 19:10:47 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 7 Jun 2023 19:10:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iASZC3+/nKXZPlmu8vhwIKLK2zoAYZITLSxSUPH1ON9lQA1lBwxbu8GNnNQbehXM5Cf0UTuY4WszkCXGIf02VMfAxqjVhjc3WFadiUf7oTPgc2QkCHenmSFts5aC6ktwDWc+BtVoFVBU/HH1D5hscvsiBJu4V5RFrgpOA/OefT9nMKk2OB1i5OdCzkZ+vUkwUu2nnd/P7JqKqj5whf7E1+nBrjn7WM1FGdZdCVVv9XZRWX2QeLuFwG/g8B75t3xk39e3W/jcEMY60URFUmPoANuMDzY5B7lSliVP3JUlB0ESMove1Id1hQcij4gJggNAgbs2Uixln6sPyXG3VqSnaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jDOq2wKt4EAv4T8of4KjEmEyD0DHIhZS6o4oStTg7Is=;
 b=EiEIYkSuSlEB02cIY4t4LXajds3KuakyX4v1Hxshln6HhiuodwvOLrLait5m+LtBzIgLHu5kbF+yBF+9ss7r9Po/Mn19BxauRFTJEMdVKl9pnr76/0pqnuWNrSs3wYZFHC+l+EHAd8cpguYRVCevRtAw8lOCkdpPVaRBgCSRksD2iD53N5TJvFpgRXLozvUnvgJ9UYjFdzJI15thB4zGFFv+02s8gtm+CZEfxjg2Jnky4JNJgmm/YbDOgfU8ChrbqEta9r5M6+Quh0T37ha5Z0nYVuo0JNAySr8LCeuUW2z0lwn8L7BTVdyjzhoiSU2hVamHWQx8l1KRWpZtD0kv7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS0PR11MB6470.namprd11.prod.outlook.com (2603:10b6:8:c2::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6477.19; Thu, 8 Jun 2023 02:10:45 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6455.030; Thu, 8 Jun 2023
 02:10:45 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v11 07/20] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Thread-Topic: [PATCH v11 07/20] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Thread-Index: AQHZlu+wNwpF26yA2UWLC9EXmgAK/K9/eecAgAC1FAA=
Date:   Thu, 8 Jun 2023 02:10:45 +0000
Message-ID: <963deb7f6bcadbf2848ef54540ba1758b43731d6.camel@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
         <21b3a45cb73b4e1917c1eba75b7769781a15aa14.1685887183.git.kai.huang@intel.com>
         <e7c21694-d31b-4dbe-f75b-5a7c0127f5c8@intel.com>
In-Reply-To: <e7c21694-d31b-4dbe-f75b-5a7c0127f5c8@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DS0PR11MB6470:EE_
x-ms-office365-filtering-correlation-id: 7b3e39f7-3d4a-46ad-e63e-08db67c5919b
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oWpL1nr+6DXaw1dnsBa+7YFRpOkFd8fJ/qAZIzwLuvKplLCi07h4fxbtEyd4EA4biiAVehJH6CJCdXsdzyXfLlRhNfSKJ9lcBcgZgFwV3FG2GIyS5+Hp4WiNJiP/4DGjw5zSoeB1fDMC89Fe15Pjvx4DcMMQVnKla/6TKrPmbCHfnRTGlHGdMu/aGedT7sse5VremAno3tNqIw+R7BwV2qUHaW1XBzhZ3HTbOlWxPT3JmvSRuxE0SEbH/9YO8jv8CVyqrfVHJfHorXe17jYVw8OtDU85ouuxRq3cz1hVE9uKzfzg2Zn7risSzSOSC0i4yxW1JNwa9x2kga+1sMkpT99S/xez47j9ADTOyrGzzwwic3OwNqbWUd4fiziIwxnUf1nQZMpvBdYcE0UEjTDA2AO48DBcHDqhCbqwPH6UnoQlh2yqO0wXMVQXZDuFl11hYnY9wkw352kJxFS/00Vfp/OjgwhovvoKwIAihRdUWbhjj9tGnlt8XLUqCcAYx6Hs3N0X41wjVtlMNucPRSwZBQtApHTtuc2diMWX2QorzZu+HhbDSLAS+ociFdCznG58Mx/R8FzxAgsAZOSwmR0Yf0kEXa/u4tVDOncjU3WFFzanjvvR703ZmlrfENIyN6Ij
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(396003)(366004)(39860400002)(346002)(376002)(451199021)(186003)(53546011)(86362001)(82960400001)(7416002)(6506007)(6512007)(26005)(6486002)(2616005)(83380400001)(8936002)(8676002)(71200400001)(478600001)(36756003)(5660300002)(54906003)(110136005)(38070700005)(38100700002)(91956017)(2906002)(316002)(41300700001)(4326008)(66946007)(122000001)(66476007)(64756008)(76116006)(66556008)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WE5ML0c1TTNuelFtaWNLWEtDN1UxcDU4eUcxVzh1bXdMSGdRRTk1NEt4TERi?=
 =?utf-8?B?MXlqWExqamJQbkhFWXpZM2Y4TWJTalY3dHpwbGRWNFZZNktvZ1lvZVl2ZHdT?=
 =?utf-8?B?azlCdElqV3BHak5UU2F2RDdnMUJ0U3RZSjFrRmlDR2hIcW41Vk5GVU43NEx6?=
 =?utf-8?B?L01CbHVrMWNLQkxwWWIwQmRtWThpdm9VSDVrOWRpbk1aZ0E3b2g3MXgzMUpY?=
 =?utf-8?B?SVoyS05MY1Jva1VndktWTXh3VmQzNjBXQm9jUkZYWlFnQ1hCZm9uZE4va2Nj?=
 =?utf-8?B?WTQzOEZnQ2kyZEIvQXNldnRkSVlkK2ltRU1oVkEzY3NxTlpUS1ZJYWpkdTlm?=
 =?utf-8?B?OU1MVnV5ck1PbTBZS25nTW90cUd4WjlsM0EvRDlZWXZuRHE4WGhGY1pTNVl0?=
 =?utf-8?B?ZWU4RmRTdS9aYk9nU0h0bUtBUUNpSitpMFMyeW9ybFFoL20yQkRCb1RKME5Y?=
 =?utf-8?B?dGd0NFg5a3gvVElpN3VyYUxjVU5DSmhxUkw4TEJJWmg1R2hWQ3Y3UUhUWDZ1?=
 =?utf-8?B?M2ZIRFcwZnpaL1VHajJQbmZwZXg2aVFTMkFNYnhaSkZHbGVtbWgwQkRYK1NG?=
 =?utf-8?B?YXdHbVlFTjBnVURQU0t1TEFIZE02R3BCU0kzY3RiVmp6cWVtV3pHSFZaNHkz?=
 =?utf-8?B?TFdSTmJVRDJwL1NGaWkzbGJWem01bEhnUXcyc3JhQkwzdE1vMVR2clM4M2Nz?=
 =?utf-8?B?ckZNUzA2M2txTDVLcUhQRUhobmNHeG9VVDFDODl2Qm03eUxScTlyWWhMWWpj?=
 =?utf-8?B?WWVhSk04U2J6TDFZSjBhSS9ta3dObTdIN2QwbWVvbjhuem0wL0ZrNTNuMGl2?=
 =?utf-8?B?c0RPV2V2YUJiZVUrcWQ3dllxUVI3K29kNFhJQmNJTlI5blI4MjVvSnJmSHRj?=
 =?utf-8?B?L0d5ajdyVVU5UnhmcEd3SjdqYzRqcy9vNkN4NWtvQmwyejZtb21Pd0lHSDZ3?=
 =?utf-8?B?ZGZvT3ZHSVVqYlBVVCtSTHRCY0c0RDdPSFphUGYxT0w5M3R6eWUvaTRLK1dW?=
 =?utf-8?B?cGFwYlcrMUlPR1lVK1g1bFJvRjBqdVpQUTdzazUxNUtQc0hSeXhtQzBEcUpr?=
 =?utf-8?B?Y29Xay8xa2JXT1hyaXQ3Q2F2T0dTbzlsUHFWSWRTcTcyZDhTZ0JBRkNFVFZW?=
 =?utf-8?B?encyalJ4MlIzVU9NZGkrM2lmZFN0Qmtlc3RzUEo1b3c2YzRBNUxuQkVkLzcz?=
 =?utf-8?B?TnExMHkvR0NDYlRWdXo4NVVqK0lvMUJMbThmVktDdllyeG13ckJKK3M3bnB3?=
 =?utf-8?B?NFFiVVZGWmVoOXBDTnBLYkFaWWhHMVNqS1NoRE5vUE5ic0NESjNBQXN1eStr?=
 =?utf-8?B?a3d6YlU5OWZTUkRrdmw3aFJMcDBwaWVRcDIxVWpZdmhxZkdWVkZjd1V6RWVB?=
 =?utf-8?B?dkttc2pzNThmQ3h6UzdYVVZ0N0h6RTRYVGFmQnNuT0VDT1FEZzQrWFdrMU1Q?=
 =?utf-8?B?TU9ldUNzcXp6dyt4RU12SGo0Y2FsUHhKMFhtWC9zNEZVVGpOYUxXVVFwSXhq?=
 =?utf-8?B?MTdMV2ZFZDY0SDAwMURpY0JETG9ROXlndE8rWHhVc1ZlY09JL3U2TDNDdmRV?=
 =?utf-8?B?MHVpT3h5YVYvMW1QZEJzYnNLK1hxQWM3blpqTlR5SHFuQm9LYnZEaW10Zjh1?=
 =?utf-8?B?Z2o0Z245SjV4amhUb0ZmQmJSVzZpWlMvcGpFZkdIWWdvNVhGWFZYcld2ZllB?=
 =?utf-8?B?U3c1Uk52WmcxUDJUeTJiZzl0bEI0WTR5aThiaHJ3dkRKOGxKbzhtNjNVUFox?=
 =?utf-8?B?NVJUdEJ3QTQvbFJob3lldTJIWEpkMW5DT25SbEtDcTdOazl4TkdLbGpoSHdk?=
 =?utf-8?B?NGRuN21nZCtYaUlPdU9LN3Z1VDdUazFZVFFMVjlnb1EwSDl4aGhvbjNOcTR6?=
 =?utf-8?B?Q3BuOXhjOGM4dXR2d1MzVmpRQXU3YXY3RHFObHlZdThNL3FwQlA4Y1JXTVQ0?=
 =?utf-8?B?QnIyL0J0WllHaWgyL0JNU0dPbUdKdTlYMkM1SUlucmF0Yk9OUUJJUlAwUTBo?=
 =?utf-8?B?blFaMmN1azhrNUdXd0RxRXV6aFVwQ2s4TUxVd1IyME1veEF3WEYwYi9aL05H?=
 =?utf-8?B?TFRPTGpVc3Y2L3M5OUt5bEo1cmNkUEwyQms0WmVPeU9ZRkZ5dTc2QlhnWXpa?=
 =?utf-8?B?ckxMUkhSeGNwQ2J1aDRScTgxM0habVR0QXppVFgwY1N5SHp1RE5GdE1iNFdJ?=
 =?utf-8?B?N1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0F9EF245D964634B9827C96E477E7549@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b3e39f7-3d4a-46ad-e63e-08db67c5919b
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2023 02:10:45.1611
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1TG57cGbPIJs8ryr2hq8K/gYOBGk+eucsbGKyDLycbHN0aOniFraB/lg+WwTvAZ+ai2WU6Z9ccInzJ0PTXCCDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6470
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIzLTA2LTA3IGF0IDA4OjIyIC0wNzAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gNi80LzIzIDA3OjI3LCBLYWkgSHVhbmcgd3JvdGU6DQo+IC4uLg0KPiA+ICtzdGF0aWMgaW50
IHRyeV9pbml0X21vZHVsZV9nbG9iYWwodm9pZCkNCj4gPiArew0KPiA+ICsJdW5zaWduZWQgbG9u
ZyBmbGFnczsNCj4gPiArCWludCByZXQ7DQo+ID4gKw0KPiA+ICsJLyoNCj4gPiArCSAqIFRoZSBU
RFggbW9kdWxlIGdsb2JhbCBpbml0aWFsaXphdGlvbiBvbmx5IG5lZWRzIHRvIGJlIGRvbmUNCj4g
PiArCSAqIG9uY2Ugb24gYW55IGNwdS4NCj4gPiArCSAqLw0KPiA+ICsJcmF3X3NwaW5fbG9ja19p
cnFzYXZlKCZ0ZHhfZ2xvYmFsX2luaXRfbG9jaywgZmxhZ3MpOw0KPiANCj4gV2h5IGlzIHRoaXMg
InJhd18iPw0KPiANCj4gVGhlcmUncyB6ZXJvIG1lbnRpb24gb2YgaXQgYW55d2hlcmUuDQoNCklz
YWt1IHBvaW50ZWQgb3V0IHRoZSBub3JtYWwgc3BpbmxvY2tfdCBpcyBjb252ZXJ0ZWQgdG8gc2xl
ZXBpbmcgbG9jayBmb3INClBSRUVNUFRfUlQga2VybmVsLiAgS1ZNIGNhbGxzIHRoaXMgd2l0aCBJ
UlEgZGlzYWJsZWQsIHRodXMgcmVxdWlyZXMgYSBub24tDQpzbGVlcGluZyBsb2NrLg0KDQpIb3cg
YWJvdXQgYWRkaW5nIGJlbG93IGNvbW1lbnQgaGVyZT8NCg0KCS8qDQoJICogTm9ybWFsIHNwaW5s
b2NrX3QgaXMgY29udmVydGVkIHRvIHNsZWVwaW5nIGxvY2sgaW4gUFJFRU1QVF9SVA0KCSAqIGtl
cm5lbC4gIFVzZSByYXdfc3BpbmxvY2tfdCBpbnN0ZWFkIHNvIHRoaXMgZnVuY3Rpb24gY2FuIGJl
IGNhbGxlZA0KCSAqIGV2ZW4gd2hlbiBJUlEgaXMgZGlzYWJsZWQgaW4gYW55IGtlcm5lbCBjb25m
aWd1cmF0aW9uLg0KCSAqLw0KDQoNCj4gDQo+ID4gKwlpZiAodGR4X2dsb2JhbF9pbml0X3N0YXR1
cyAmIFREWF9HTE9CQUxfSU5JVF9ET05FKSB7DQo+ID4gKwkJcmV0ID0gdGR4X2dsb2JhbF9pbml0
X3N0YXR1cyAmIFREWF9HTE9CQUxfSU5JVF9GQUlMRUQgPw0KPiA+ICsJCQktRUlOVkFMIDogMDsN
Cj4gPiArCQlnb3RvIG91dDsNCj4gPiArCX0NCj4gPiArDQo+ID4gKwkvKiBBbGwgJzAncyBhcmUg
anVzdCB1bnVzZWQgcGFyYW1ldGVycy4gKi8NCj4gPiArCXJldCA9IHNlYW1jYWxsKFRESF9TWVNf
SU5JVCwgMCwgMCwgMCwgMCwgTlVMTCwgTlVMTCk7DQo+ID4gKw0KPiA+ICsJdGR4X2dsb2JhbF9p
bml0X3N0YXR1cyA9IFREWF9HTE9CQUxfSU5JVF9ET05FOw0KPiA+ICsJaWYgKHJldCkNCj4gPiAr
CQl0ZHhfZ2xvYmFsX2luaXRfc3RhdHVzIHw9IFREWF9HTE9CQUxfSU5JVF9GQUlMRUQ7DQo+ID4g
K291dDoNCj4gPiArCXJhd19zcGluX3VubG9ja19pcnFyZXN0b3JlKCZ0ZHhfZ2xvYmFsX2luaXRf
bG9jaywgZmxhZ3MpOw0KPiA+ICsNCj4gPiArCXJldHVybiByZXQ7DQo+ID4gK30NCj4gPiArDQo+
ID4gKy8qKg0KPiA+ICsgKiB0ZHhfY3B1X2VuYWJsZSAtIEVuYWJsZSBURFggb24gbG9jYWwgY3B1
DQo+ID4gKyAqDQo+ID4gKyAqIERvIG9uZS10aW1lIFREWCBtb2R1bGUgcGVyLWNwdSBpbml0aWFs
aXphdGlvbiBTRUFNQ0FMTCAoYW5kIFREWCBtb2R1bGUNCj4gPiArICogZ2xvYmFsIGluaXRpYWxp
emF0aW9uIFNFQU1DQUxMIGlmIG5vdCBkb25lKSBvbiBsb2NhbCBjcHUgdG8gbWFrZSB0aGlzDQo+
ID4gKyAqIGNwdSBiZSByZWFkeSB0byBydW4gYW55IG90aGVyIFNFQU1DQUxMcy4NCj4gPiArICoN
Cj4gPiArICogTm90ZSB0aGlzIGZ1bmN0aW9uIG11c3QgYmUgY2FsbGVkIHdoZW4gcHJlZW1wdGlv
biBpcyBub3QgcG9zc2libGUNCj4gPiArICogKGkuZS4gdmlhIFNNUCBjYWxsIG9yIGluIHBlci1j
cHUgdGhyZWFkKS4gIEl0IGlzIG5vdCBJUlEgc2FmZSBlaXRoZXINCj4gPiArICogKGkuZS4gY2Fu
bm90IGJlIGNhbGxlZCBpbiBwZXItY3B1IHRocmVhZCBhbmQgdmlhIFNNUCBjYWxsIGZyb20gcmVt
b3RlDQo+ID4gKyAqIGNwdSBzaW11bHRhbmVvdXNseSkuDQo+IA0KPiBsb2NrZGVwX2Fzc2VydF8q
KCkgYXJlIHlvdXIgZnJpZW5kcy4gIFVubGlrZSBjb21tZW50cywgdGhleSB3aWxsDQo+IGFjdHVh
bGx5IHRlbGwgeW91IGlmIHRoaXMgZ29lcyB3cm9uZy4NCg0KWWVhaC4gIFdpbGwgZG8uICBUaGFu
a3MgZm9yIHJlbWluZGluZy4NCg0KPiANCj4gPiAraW50IHRkeF9jcHVfZW5hYmxlKHZvaWQpDQo+
ID4gK3sNCj4gPiArCXVuc2lnbmVkIGludCBscF9zdGF0dXM7DQo+ID4gKwlpbnQgcmV0Ow0KPiA+
ICsNCj4gPiArCWlmICghcGxhdGZvcm1fdGR4X2VuYWJsZWQoKSkNCj4gPiArCQlyZXR1cm4gLUVJ
TlZBTDsNCj4gPiArDQo+ID4gKwlscF9zdGF0dXMgPSBfX3RoaXNfY3B1X3JlYWQodGR4X2xwX2lu
aXRfc3RhdHVzKTsNCj4gPiArDQo+ID4gKwkvKiBBbHJlYWR5IGRvbmUgKi8NCj4gPiArCWlmIChs
cF9zdGF0dXMgJiBURFhfTFBfSU5JVF9ET05FKQ0KPiA+ICsJCXJldHVybiBscF9zdGF0dXMgJiBU
RFhfTFBfSU5JVF9GQUlMRUQgPyAtRUlOVkFMIDogMDsNCj4gPiArDQo+ID4gKwkvKg0KPiA+ICsJ
ICogVGhlIFREWCBtb2R1bGUgZ2xvYmFsIGluaXRpYWxpemF0aW9uIGlzIHRoZSB2ZXJ5IGZpcnN0
IHN0ZXANCj4gPiArCSAqIHRvIGVuYWJsZSBURFguICBOZWVkIHRvIGRvIGl0IGZpcnN0IChpZiBo
YXNuJ3QgYmVlbiBkb25lKQ0KPiA+ICsJICogYmVmb3JlIGRvaW5nIHRoZSBwZXItY3B1IGluaXRp
YWxpemF0aW9uLg0KPiA+ICsJICovDQo+ID4gKwlyZXQgPSB0cnlfaW5pdF9tb2R1bGVfZ2xvYmFs
KCk7DQo+ID4gKw0KPiA+ICsJLyoNCj4gPiArCSAqIElmIHRoZSBtb2R1bGUgZ2xvYmFsIGluaXRp
YWxpemF0aW9uIGZhaWxlZCwgdGhlcmUncyBubyBwb2ludA0KPiA+ICsJICogdG8gZG8gdGhlIHBl
ci1jcHUgaW5pdGlhbGl6YXRpb24uICBKdXN0IG1hcmsgaXQgYXMgZG9uZSBidXQNCj4gPiArCSAq
IGZhaWxlZC4NCj4gPiArCSAqLw0KPiA+ICsJaWYgKHJldCkNCj4gPiArCQlnb3RvIHVwZGF0ZV9z
dGF0dXM7DQo+ID4gKw0KPiA+ICsJLyogQWxsICcwJ3MgYXJlIGp1c3QgdW51c2VkIHBhcmFtZXRl
cnMgKi8NCj4gPiArCXJldCA9IHNlYW1jYWxsKFRESF9TWVNfTFBfSU5JVCwgMCwgMCwgMCwgMCwg
TlVMTCwgTlVMTCk7DQo+ID4gKw0KPiA+ICt1cGRhdGVfc3RhdHVzOg0KPiA+ICsJbHBfc3RhdHVz
ID0gVERYX0xQX0lOSVRfRE9ORTsNCj4gPiArCWlmIChyZXQpDQo+ID4gKwkJbHBfc3RhdHVzIHw9
IFREWF9MUF9JTklUX0ZBSUxFRDsNCj4gPiArDQo+ID4gKwl0aGlzX2NwdV93cml0ZSh0ZHhfbHBf
aW5pdF9zdGF0dXMsIGxwX3N0YXR1cyk7DQo+ID4gKw0KPiA+ICsJcmV0dXJuIHJldDsNCj4gPiAr
fQ0KPiA+ICtFWFBPUlRfU1lNQk9MX0dQTCh0ZHhfY3B1X2VuYWJsZSk7DQo+IA0KPiBZb3UgZGFu
Y2VkIGFyb3VuZCBpdCBpbiB0aGUgY2hhbmdlbG9nLCBidXQgdGhlIHJlYXNvbiBmb3IgdGhlIGV4
cG9ydHMgaXMNCj4gbm90IGNsZWFyLg0KDQpJJ2xsIGFkZCBvbmUgc2VudGVuY2UgdG8gdGhlIGNo
YW5nZWxvZyB0byBleHBsYWluOg0KDQoJRXhwb3J0IGJvdGggdGR4X2NwdV9lbmFibGUoKSBhbmQg
dGR4X2VuYWJsZSgpIGFzIEtWTSB3aWxsIGJlIHRoZSBrZXJuZWwNCgljb21wb25lbnQgdG8gdXNl
IFREWC4NCg0KPiANCj4gPiArc3RhdGljIGludCBpbml0X3RkeF9tb2R1bGUodm9pZCkNCj4gPiAr
ew0KPiA+ICsJLyoNCj4gPiArCSAqIFRPRE86DQo+ID4gKwkgKg0KPiA+ICsJICogIC0gR2V0IFRE
WCBtb2R1bGUgaW5mb3JtYXRpb24gYW5kIFREWC1jYXBhYmxlIG1lbW9yeSByZWdpb25zLg0KPiA+
ICsJICogIC0gQnVpbGQgdGhlIGxpc3Qgb2YgVERYLXVzYWJsZSBtZW1vcnkgcmVnaW9ucy4NCj4g
PiArCSAqICAtIENvbnN0cnVjdCBhIGxpc3Qgb2YgIlREIE1lbW9yeSBSZWdpb25zIiAoVERNUnMp
IHRvIGNvdmVyDQo+ID4gKwkgKiAgICBhbGwgVERYLXVzYWJsZSBtZW1vcnkgcmVnaW9ucy4NCj4g
PiArCSAqICAtIENvbmZpZ3VyZSB0aGUgVERNUnMgYW5kIHRoZSBnbG9iYWwgS2V5SUQgdG8gdGhl
IFREWCBtb2R1bGUuDQo+ID4gKwkgKiAgLSBDb25maWd1cmUgdGhlIGdsb2JhbCBLZXlJRCBvbiBh
bGwgcGFja2FnZXMuDQo+ID4gKwkgKiAgLSBJbml0aWFsaXplIGFsbCBURE1Scy4NCj4gPiArCSAq
DQo+ID4gKwkgKiAgUmV0dXJuIGVycm9yIGJlZm9yZSBhbGwgc3RlcHMgYXJlIGRvbmUuDQo+ID4g
KwkgKi8NCj4gPiArCXJldHVybiAtRUlOVkFMOw0KPiA+ICt9DQo+ID4gKw0KPiA+ICtzdGF0aWMg
aW50IF9fdGR4X2VuYWJsZSh2b2lkKQ0KPiA+ICt7DQo+ID4gKwlpbnQgcmV0Ow0KPiA+ICsNCj4g
PiArCXJldCA9IGluaXRfdGR4X21vZHVsZSgpOw0KPiA+ICsJaWYgKHJldCkgew0KPiA+ICsJCXBy
X2VycigiVERYIG1vZHVsZSBpbml0aWFsaXphdGlvbiBmYWlsZWQgKCVkKVxuIiwgcmV0KTsNCj4g
DQo+IEhhdmUgeW91IGFjdHVhbGx5IGdvbmUgYW55ICBsb29rZWQgYXQgaG93IHRoaXMgcHJfKigp
J3MgbG9vaz8NCj4gDQo+IFdvbid0IHRoZXkgc2F5Og0KPiANCj4gCXRkeDogVERYIG1vZHVsZSBp
bml0aWFsaXplZA0KPiANCj4gSXNuJ3QgdGhhdCBhIF9iaXRfIHNpbGx5PyAgV2h5IG5vdCBqdXN0
IHNheToNCj4gDQo+IAlwcl9pbmZvKCJtb2R1bGUgaW5pdGlhbGl6ZWQuXG4iKTsNCg0KSSBkaWQu
ICBIb3dldmVyIEkgbWlnaHQgaGF2ZSBhIGJhZCB0YXN0ZSA6KQ0KDQpXaWxsIGNoYW5nZSAoYW5k
IGNoYW5nZSBvdGhlciBwcigpIGlmIHRoZXJlJ3Mgc2ltaWxhciBwcm9ibGVtKS4NCg0K
