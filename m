Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 304E05A5B4C
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 07:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbiH3F4v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 01:56:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiH3F4t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 01:56:49 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 209139AFD4;
        Mon, 29 Aug 2022 22:56:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661839008; x=1693375008;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/nzdR9ouRz1SXzuGw9Jme37oe8aQeIjv8X3xWw1xTBQ=;
  b=JvzPc8FGwLn3Xgft9d5Mk8/gCfVl5n/nzs3RpWjyDLGHi7TkCk5qjHHO
   vzsAiuiqRQsjwBNM2TVGIXVQRXEr/HgsMdsWPt0gSClAjfV9x1wGr/VYK
   NY+brcrdy+YEHxp9n0GliUSShnQPgEmm//ZdrZHW09jnBgma09psCMQgY
   aXHkMZ/Yn87x+aBFoN8RC6779Rem5g+7ctYa83yorEDH1eNstqkchekgI
   DjOVjguP10MNV193wpm9kTxKQ+Ln9ZGuQ5JvE4WeY3CvN5oJlHzXQfpyt
   9il36geKfD4GveQoNC/hrNtRPOg26nQ8EOOASRwln/b/BxG0gizsr1Og1
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10454"; a="292668031"
X-IronPort-AV: E=Sophos;i="5.93,274,1654585200"; 
   d="scan'208";a="292668031"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2022 22:56:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,274,1654585200"; 
   d="scan'208";a="737616788"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga004.jf.intel.com with ESMTP; 29 Aug 2022 22:56:14 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 29 Aug 2022 22:56:14 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 29 Aug 2022 22:56:14 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 29 Aug 2022 22:56:14 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.42) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 29 Aug 2022 22:56:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I2iDkUo6yTImjZYdXRqSOQ7+IzQ6E9Xl3L/ELs9V7L+BfE5TMzKNrdlkAdYxBM8C100mafFTmJizxEIyqxoHpRDYAyDb9J0WPpf5jxQm3/0tKUoudMryrQ5Xj0gMwdnEOWHwq8sNuicOtkvuxh09Rsitj5cNTb0TEpGR4XK9Z8gU5BiUIMvNMFZVgjL//CjvB2MufqjMzCEple8RVqyjlWjm5fP36AtmoNCvjPISlTxOS7I/u/hMSJX1KuL+mRm/sx+I1DNEZDPJ9tja0i9ThMB/2gszCOqoVMzY0vk+k8gEuMUhsea+7LTFJ0xsRpqdgtFCErCs+wJhYxjohOxvJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/nzdR9ouRz1SXzuGw9Jme37oe8aQeIjv8X3xWw1xTBQ=;
 b=ii7NfDsqYr1QM5oQ8r1nV3t/aUuDREhULLY0LFmDgBSc9l6LPrwWLIj6RBjY6CTET8uyHxdyGyJcvulg4A3yOzyadj+btKLzAXvb1x+9IclkwrFo2GxyoGMnjJvc5vVDyzW+5g0zYPYgGUHSix0vy+E+TI87iaq9K6dG/IsAbPWu5NjAbcLmyQWE8QeolulZ1ViR7ojbVP3ipCG1EOSNdT5p8iPUzSS4kcyr9rApL3fnhbIgq1RbK7ve80ajPdBYJvue2XifC8uCXCNhbxqSXrTn3fBVrNqPm5Ir+nk1dUU4J0msUxXlqsAud6VQ5eOH+2PJ72qwnaVF62NSKMSIsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB4824.namprd11.prod.outlook.com (2603:10b6:510:38::13)
 by DS7PR11MB6222.namprd11.prod.outlook.com (2603:10b6:8:99::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.21; Tue, 30 Aug
 2022 05:56:09 +0000
Received: from PH0PR11MB4824.namprd11.prod.outlook.com
 ([fe80::adb4:9c0e:5140:9596]) by PH0PR11MB4824.namprd11.prod.outlook.com
 ([fe80::adb4:9c0e:5140:9596%4]) with mapi id 15.20.5566.021; Tue, 30 Aug 2022
 05:56:09 +0000
From:   "Mi, Dapeng1" <dapeng1.mi@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>
CC:     "rafael@kernel.org" <rafael@kernel.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>
Subject: RE: [PATCH] KVM: x86: use TPAUSE to replace PAUSE in halt polling
Thread-Topic: [PATCH] KVM: x86: use TPAUSE to replace PAUSE in halt polling
Thread-Index: AQHYt5jfiwON7Q5LUE+jIx7HUxEKwK2+LJ2AgAFKPtCAAYM0gIAF+glw
Date:   Tue, 30 Aug 2022 05:56:09 +0000
Message-ID: <PH0PR11MB4824511867EAD25089612535CD799@PH0PR11MB4824.namprd11.prod.outlook.com>
References: <20220824091117.767363-1-dapeng1.mi@intel.com>
 <YwZDL4yv7F2Y4JBP@google.com>
 <PH0PR11MB4824201DABEFF588B4E0FE34CD729@PH0PR11MB4824.namprd11.prod.outlook.com>
 <7558c548-7866-9176-34a2-056f4a72a483@redhat.com>
In-Reply-To: <7558c548-7866-9176-34a2-056f4a72a483@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.6.500.17
dlp-product: dlpe-windows
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 43406e0e-d599-4e4b-b8f8-08da8a4c5621
x-ms-traffictypediagnostic: DS7PR11MB6222:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: smZ0B7KgyVm89CDYpqFJ5iZcKJnk4bafLpz7RVkwzLKhHurFRzWr1byMKNFXeDd8jT5g2XDCHIcaiRRF5IBCXB7mJry9TYeewAWpYypUY8qa+biPailj+qZmBT54Y5T3roIvzN53V1retvwW/L94nKMTP7Hkud54RhZ30RO3P4ZzKNonGCidcVF40A5rGSUrqTutrPzmZgKgTJ05NTgQdvMjND55D2cR1lddBTp3mWbMaWghOZM1XO0HxldP7sX9rp4NrCfkMMkJee2DRZMp0gJkaSqThHSk5/EDuWy6hpVaMj9bb8WBotLFEIn6g8HaYunNV3QRCK61Yu7aRN46c4rtOufUyoLw1oX/GY5pnK8XR8UVJNCHPqT8BCksiQ+4AqVqMR2tyxUvtID0nP22wotzFZbGnFCjWHto5fmTtnQD6zDEmppUuXIydD2HukYeFgGU/qB0tId9dIQruCeLF31r001JNUbCckoTdsOgDHxvZUVHo7HkyiMFZbyMxOiUYX09RvYHhnXKBWA8V28AhZdjAQfCs42ydgyF/K5rf16T1ZXCoon2WdwOZ9Tlz98gqRC0e5oIE88IMtEAYvePu1Vw1HUuHbUezKiQObA5jujTyvztKOjC3YJoH45j13gFcrpCMtv7Yi8+zdqWWzLgaDOolfdPEEbnr7HFFCLwUe1QdHt+474kGlO3OIWbgVTIyDOMmO7AmqMbhD9pP6n+cqRUlmaHn2Nx4c9+Mxb2A6J0Et4Q4pJX/bSRatKV4LSscDVOk6322F1GRPOTGBdiTA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4824.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(366004)(396003)(136003)(346002)(39860400002)(8676002)(64756008)(66556008)(66946007)(66476007)(76116006)(110136005)(4326008)(66446008)(54906003)(316002)(38100700002)(5660300002)(2906002)(52536014)(8936002)(122000001)(26005)(38070700005)(82960400001)(53546011)(86362001)(9686003)(6506007)(7696005)(33656002)(71200400001)(41300700001)(478600001)(55016003)(83380400001)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dXdnbVFtSFhJNVZDQ05hU2hnUjJZY3FHK2dzUVVPS1Z0cjh2L3NPK3EwZnJY?=
 =?utf-8?B?aDVDSTRKeEh1TjM0YnlpYzRuamtBM0ZyZTh4aHhvMDFWWExPb3NDOTRCZ0Rk?=
 =?utf-8?B?UUJzczVrUEtScGsySW9yNTFQUEwyNE8wa3ZIOE82OTkxSEdtWXpXQ2dMa0Ri?=
 =?utf-8?B?Z0s0bWNuQUNRVU80aDB0SGR4TFVUcXZpYll5WVBPRlRjODl2cDdRdlo1SkYr?=
 =?utf-8?B?TXdEbjYxcC9ydzJXYkFiTGxxOWxxeWJ1K0laeTA2MDZkUkdSdzNZS1FPbE5t?=
 =?utf-8?B?R09CdlpRaUk2ME1TZzEyazVTaGNSMTRlZUJLazBOSCtPZ1VYeG11Z2t3WGxS?=
 =?utf-8?B?NnUyT1BkVjBaVFY0TCsrL09GN1NWNk80aUhRUEdKYkozZC84TDdwOUJ5NytJ?=
 =?utf-8?B?YlJCdnRkeDdSaE5oYXQrUk9CRk1lVk9IR2s2eTdDWE1abmF3R0hjQkN1NG9x?=
 =?utf-8?B?UThYRXJNM1lGUEpXVjVlTmlSb0RBTHRvR0lXNEY1eWZ1YUxaY0psZWcvUXdt?=
 =?utf-8?B?NkdmemJPaGEvdDcwWFg0dzlhZGFubm8rNXlvQzh1WUF5c0gzakNZWDZvd29C?=
 =?utf-8?B?a1lOWmdFZlNLbTNKYzZFVzRrVnlwRVFFWkNpNW5HeVo4bnFQcFNQMHliU0dr?=
 =?utf-8?B?SXphZmVLNGxRYlVuWTgzdmpzc2FTcUtXM2ZHZGY1aWxNZEtRZGI3N3c0d2V6?=
 =?utf-8?B?ZmJkTlpSL044TC95aWQ0Nzk2TmJHaWNudHZqQ2p2L3FuZFpLMGVFSHowNjdD?=
 =?utf-8?B?VnBpV0ZMVDdVaXRwWEJnQ2FrNmRaOVJSN2NzOFgrOG52QlZtQ09HQmYzcW10?=
 =?utf-8?B?RWpHUDZYL0xZbDhWa0hNTUhpQWI0cjZWWjJNbUpoMmZiT2QxTGdYaEFIc2du?=
 =?utf-8?B?Yjl4S2ttMEpndEZEKzYrdm1CaWNDN0h0S1N6d0J3cjErT3laOG1YKyswY1pI?=
 =?utf-8?B?T01vVjdBSFE0cGlxM1h0M2JjVDdsZVFCaDdoQkZQVnYyMlJoMzlJN3JUc3VU?=
 =?utf-8?B?azV5ODFLQjNINzJEbjZGY3FKZThJM1VSZVFXbTFJc2RUZlJPdGE2citPN0V6?=
 =?utf-8?B?ejRtbFVkK1R0MGlqS1R2VjZCSVloQkgyR3FSbWp1ZCt5Ukt2WFRxWE1ONXRj?=
 =?utf-8?B?YUtCT2lDNmxqVzd6RkxQNHpwNXNkN0llYXE2WDZZekkvVUJ3TEVVODkySk1t?=
 =?utf-8?B?Yi9aaXcwWVFsYmN0Zm1WUUhFVnZvOHJmZ0ZIS25tRW84eFhXS2J0azF3NjRB?=
 =?utf-8?B?R3d4c3dQRTgrSG44SllMbTUvOUVYQ0U0NkVNL0hBS0R0VFJ6ZWtEdUtlN2dY?=
 =?utf-8?B?MGFlWkdOQ0xqcGVxdnNEVm81YkdzYTZ0RXNFVEJaRlMyKy9DMUZFVERSNDVV?=
 =?utf-8?B?cUlZNGZKK2lZNWRmQ1AxUEdLQXJXN3pzMkxmK01od3hycEhZZWYzWDhHZDhG?=
 =?utf-8?B?SFl5RFE0WW5wbG14MkJnbWJiemdmczlaNzlZK0Y1ZTFUZkZZLzRKUTRoZ0Ns?=
 =?utf-8?B?dE83bWxKY1N1TVU0cSsreVR4dzdna0VVUHFWMGxCc0NFU0JMdHJ3MUJYQWtC?=
 =?utf-8?B?UlVBQzZFeWdxRHNSYk82ZC9HNjl2dGZ4M29sWUZJY01lUWJtemJMQ21qUTZ5?=
 =?utf-8?B?UHYzRmFMU0EyOHZ0a0dvY0EyODNNR1c2ZUpZSFMrQmx5K01nOW9vV0xhQXgr?=
 =?utf-8?B?aElETnZEcmx6OE8weEdnb1VUb0xpVFppb01jdDZPY2JNcU9HY1Z5WlVyb242?=
 =?utf-8?B?WXg2N3d4OXpWYjZ4N0N6WisvdGhYeWZYejdNTHp2dWlOVGdoU2piNUh2ODl1?=
 =?utf-8?B?UDJsVXNGSlZkNzZIL3R4T21hLy9JOFZzZTlkOVROK25CTDBuOUF5QVVWVlAr?=
 =?utf-8?B?ZERUalkza3M5Yzl5enB5VEN3SlMrOFVpS0NJbDkvUnQySnVlaTFSV25iZm51?=
 =?utf-8?B?SFNpaFJEUkVSRFlweVp0UlprQmVPSCtNRHgrZ1B3dWVIY3AwMXVFWGpUenlI?=
 =?utf-8?B?MnZCWk0zK3hkY3dGT0tyY2RDRlRCMTlBVTlEQ1g2QzdKMDlUQlBKQ3dUbmE0?=
 =?utf-8?B?QmtYdkNMNW1rT2NqSHZKOU56VGhoRy8rMEpnTytaQ3I0UWtDak8xUzJGdGtt?=
 =?utf-8?Q?nQVYWfsDs6ORFPvTb5m21/GdT?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4824.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43406e0e-d599-4e4b-b8f8-08da8a4c5621
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2022 05:56:09.3076
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: W9jt/oMcioj4zMqF/LhwEv6qlIncrS37s8+U2AF+CNx9nd++s4dAMI5TOhZOuwwma8bzEccyCYsc9Rh9vHvoTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6222
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBQYW9sbyBCb256aW5pIDxwYm9uemluaUByZWRoYXQuY29tPg0KPiBTZW50OiBGcmlk
YXksIEF1Z3VzdCAyNiwgMjAyMiA2OjE0IFBNDQo+IFRvOiBNaSwgRGFwZW5nMSA8ZGFwZW5nMS5t
aUBpbnRlbC5jb20+OyBDaHJpc3RvcGhlcnNvbiwsIFNlYW4NCj4gPHNlYW5qY0Bnb29nbGUuY29t
Pg0KPiBDYzogcmFmYWVsQGtlcm5lbC5vcmc7IGRhbmllbC5sZXpjYW5vQGxpbmFyby5vcmc7IGxp
bnV4LXBtQHZnZXIua2VybmVsLm9yZzsNCj4gbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsg
a3ZtQHZnZXIua2VybmVsLm9yZzsNCj4gemhlbnl1d0BsaW51eC5pbnRlbC5jb20NCj4gU3ViamVj
dDogUmU6IFtQQVRDSF0gS1ZNOiB4ODY6IHVzZSBUUEFVU0UgdG8gcmVwbGFjZSBQQVVTRSBpbiBo
YWx0IHBvbGxpbmcNCj4gDQo+IE9uIDgvMjUvMjIgMTM6MzEsIE1pLCBEYXBlbmcxIHdyb3RlOg0K
PiA+PiBJIHNheSAiaWYiLCBiZWNhdXNlIEkgdGhpbmsgdGhpcyBuZWVkcyB0byBjb21lIHdpdGgg
cGVyZm9ybWFuY2UNCj4gPj4gbnVtYmVycyB0byBzaG93IHRoZSBpbXBhY3Qgb24gZ3Vlc3QgbGF0
ZW5jeSBzbyB0aGF0IEtWTSBhbmQgaXRzIHVzZXJzDQo+ID4+IGNhbiBtYWtlIGFuIGluZm9ybWVk
IGRlY2lzaW9uLg0KPiA+PiBBbmQgaWYgaXQncyB1bmxpa2VseSB0aGF0IGFueW9uZSB3aWxsIGV2
ZXIgd2FudCB0byBlbmFibGUgVFBBVVNFIGZvcg0KPiA+PiBoYWx0IHBvbGxpbmcsIHRoZW4gaXQn
cyBub3Qgd29ydGggdGhlIGV4dHJhIGNvbXBsZXhpdHkgaW4gS1ZNLg0KPiA+IEkgZXZlciBydW4g
dHdvIHNjaGVkdWxpbmcgcmVsYXRlZCBiZW5jaG1hcmtzLCBoYWNrYmVuY2ggYW5kIHNjaGJlbmNo
LCBJDQo+IGRpZG4ndCBzZWUgIHRoZXJlIGFyZSBvYnZpb3VzIHBlcmZvcm1hbmNlIGltcGFjdC4N
Cj4gPg0KPiA+IEhlcmUgYXJlIHRoZSBoYWNrYmVuY2ggYW5kIHNjaGJlbmNoIGRhdGEgb24gSW50
ZWwgQURMIHBsYXRmb3JtLg0KPiANCj4gQ2FuIHlvdSBjb25maXJtICh1c2luZyBkZWJ1Z2ZzIGZv
ciBleGFtcGxlKSB0aGF0IGhhbHQgcG9sbGluZyBpcyB1c2VkIHdoaWxlDQo+IGhhY2tiZW5jaCBp
cyBydW5uaW5nLCBhbmQgbm90IHVzZWQgd2hpbGUgaXQgaXMgbm90IHJ1bm5pbmc/DQoNClNvcnJ5
LCBJIG1heSBub3QgZGVzY3JpYmUgdGhlIHRlc3QgY2FzZSBjbGVhcmx5LiBUaGUgaGFja2JlbmNo
IGFuZCBzY2hiZW5jaCBhcmUgcnVuIG9uIEhvc3QgDQpyYXRoZXIgdGhhbiBhIFZNLiBXaGVuIHRo
ZSBoYWNrYmVuY2ggb3Igc2NoYmVuY2ggaXMgcnVuIG9uIEhvc3QsIHRoZXJlIGlzIGEgRklPIHdv
cmtsb2FkIHJ1bm5pbmcNCmluIGEgVk0gaW4gdGhlIGJhY2tncm91bmQgYW5kIHRoZSBGSU8gd291
bGQgdHJpZ2dlciBhIGxhcmdlIG51bWJlciBvZiBITFQgVk0tZXhpdHMgYW5kIGV2ZW50dWFsbHkN
Cmludm9rZSBoYWx0IHBvbGxpbmcuIA0KDQpJbiB0aGlzIHRlc3QsIEkgd2FudCB0byBjaGVjayB3
aGV0aGVyIHBvdGVudGlhbCBwb2xsaW5nIHRpbWUgZXh0ZW5kaW5nIHdvdWxkIGluY3JlYXNlIHRo
ZSBzY2hlZHVsaW5nDQpsYXRlbmN5IG9uIGhvc3QuIEJ1dCBpdCBsb29rcyB0aGUgaW1wYWN0IGZv
ciBzY2hlZHVsaW5nIGxhdGVuY3kgaXMgcXVpdGUgbWluaW1hbC4NCg0KPiANCj4gSW4gcGFydGlj
dWxhciwgSSB0aGluayB5b3UgbmVlZCB0byBydW4gdGhlIHNlcnZlciBhbmQgY2xpZW50IG9uIGRp
ZmZlcmVudCBWTXMsDQo+IGZvciBleGFtcGxlIHVzaW5nIG5ldHBlcmYncyBVRFBfUlIgdGVzdC4g
IFdpdGggaGFja2JlbmNoIHRoZSBwaW5nLXBvbmcgaXMNCj4gc2ltcGx5IGJldHdlZW4gdHdvIHRh
c2tzIG9uIHRoZSBzYW1lIENQVSwgYW5kIHRoZSBoeXBlcnZpc29yIGlzIG5vdA0KPiBleGVyY2lz
ZWQgYXQgYWxsLg0KPiANCg0KSGVyZSBhcmUgdGhlIG5ldHBlcmYncyBVRFBfUlIgdGVzdCByZXN1
bHQgYmV0d2VlbiB0d28gVk1zIGxvY2F0ZSBvbiB0d28gZGlmZmVyZW50IHBoeXNpY2FsIG1hY2hp
bmVzLg0KDQpOZXRwZXJmIAkJCVZhbmlsbGEgKEF2Zy4pCQlUUEFVU0UgKEF2Zy4pCQklRGVsdGEN
ClVEUF9SUiAoVHJhbnMuIFJhdGUvcykJCTUwMy44CQkJNTAzLjkJCQkwLjAyJQ0KDQpJdCBsb29r
cyB0aGVyZSBpcyBubyBvYnZpb3VzIGRpZmZlcmVuY2Ugd2l0aCBUUEFVU0UgY2hhbmdlIG9uIFVE
UCBSUiB0ZXN0Lg0KDQoNCj4gUGFvbG8NCg0K
