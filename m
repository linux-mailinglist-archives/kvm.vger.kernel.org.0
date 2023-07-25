Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C15A7626C0
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 00:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231342AbjGYWae (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 18:30:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233594AbjGYW2o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 18:28:44 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CF1D7EEA;
        Tue, 25 Jul 2023 15:22:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690323725; x=1721859725;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Et2V24z2t1n8BPQVsTbvTObWBDx8ykz7SPMk7I/ZOWY=;
  b=JKkDx4AsW7/IQTT9aeK3lBzPp4xzojGQv+76B/oMmHZzdWA47TNxb4ZW
   7Wo9FENUTrUnUST/h2/R/zH8tiHficqb4v9drd06tuwLsnjkyZwopW7WU
   iLY//PhXlUx3+SN5R68prriqeMIbRTXvW/kB0lvcaxler9arqHQHl+cN1
   kWtPazLrUg65DFzjHeMQAdcZ+p2FfRsgiuONjzoDs8PY4vrmFYUJbxxxM
   05I4EbmpduiFOBLn4xPbtJWdiYibyoP9p1MUwUciZbLCy5Q847LTASAfy
   x4Bftw9J+8vnGPzP0bTqEIuI2QeEfTgzsIteAQ9/rIvjH0IA9BDUTc752
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="347465413"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="347465413"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:20:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="816426463"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="816426463"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by FMSMGA003.fm.intel.com with ESMTP; 25 Jul 2023 15:20:41 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 25 Jul 2023 15:20:40 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 25 Jul 2023 15:20:40 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 25 Jul 2023 15:20:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nlrH41Ke65LIS81fdAom4Sqxd/veFVzgJ2lkZxC6mGE9qxtPRmb0aDFaWUo8SOvlxgmX7QTGLaIqs+m/LvCR2+c9rGufNYwM+19relxE8WFBRoPDKD80RUq1qAcfZ+fd8QSkry8IcqjCsz0cbCRxqcEkf+qBLlbAtyWIJ+ZcAZw0IsF14FwtJVKAvM9+fSSrqFfbzWsgfkKeVIUWvWAEE+1NBpWFc45BPLGTnjSGlDqlDvwApxexPNIWq7WNXCe6ONDdk4K8QItj4eer07s661pdbf2+U1GRYWFoqi7SzLlIPxsMQWgN0nu4KFfhfeto/GuOMvkuEbg7EzC2Yxcr/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Et2V24z2t1n8BPQVsTbvTObWBDx8ykz7SPMk7I/ZOWY=;
 b=U8qZwZY9Vgz1B8zNrOc01eUOKx71qEuX85f4GHU0sxHauKgF/nA90svt2PpC3uYidBX11xgQQkuRi26LwcE/apVRN/oS7CzcdpwAGYRXICUkCexWe63hdKrEM93avR+EnvZ11g/SbF1myCWbUE3DHqer6zOq/zzvMX6lTPC+y/sZEWDO3saMOrZXqQdB2sKz5E6gDS3vvmPgsLhnGb2TyaZhJjBNoJPwVm/qaFpUDw0atFri7i25BblT0QG6rJN3IBxi/G5mEplHjGA0m+hLi4ULlB4T1oxZNpU7F54IimOjYLT7Ta81+9YGyVoy9rdmURlOFIuBrzt+95NzY/rsdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MW4PR11MB6935.namprd11.prod.outlook.com (2603:10b6:303:228::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.24; Tue, 25 Jul
 2023 22:20:37 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3729:308d:4f:81c8]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3729:308d:4f:81c8%3]) with mapi id 15.20.6609.032; Tue, 25 Jul 2023
 22:20:37 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "Gao, Chao" <chao.gao@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 19/19] KVM: VMX: Skip VMCLEAR logic during emergency
 reboots if CR4.VMXE=0
Thread-Topic: [PATCH v4 19/19] KVM: VMX: Skip VMCLEAR logic during emergency
 reboots if CR4.VMXE=0
Thread-Index: AQHZvBC20pPLjDeC6UKpM4HW6FXiBK/J3lyAgADxZQCAAESTAA==
Date:   Tue, 25 Jul 2023 22:20:36 +0000
Message-ID: <a95c1e35329999bef5d76c848accc66f24029f11.camel@intel.com>
References: <20230721201859.2307736-1-seanjc@google.com>
         <20230721201859.2307736-20-seanjc@google.com>
         <c90d244a6b372322028d0e5b42d60fb1a23476da.camel@intel.com>
         <ZMARLNcPwovmOZvg@google.com>
In-Reply-To: <ZMARLNcPwovmOZvg@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MW4PR11MB6935:EE_
x-ms-office365-filtering-correlation-id: 1335e960-fb64-430c-bf24-08db8d5d5ebf
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Q4o3RdR+t5fGODthMCIPWzRf7FdQzruqyFSIoiIdK6m2zGE2/UFenWmEflQsdIfs7XPZtGj/GgCdTvwg356wTL9GaA+D/usP6wvXeFZWzQUQAa3LMx4Om7VZBEm5Au4Ed9k/7MgBGBApj7k4fI8NhcJ4Gy0QgOaBl4zDAXANoPXBwm7nKZN3JoilIZICBlH9o2bRzXkazUIqtOgM5TEr3XDKSKqkCy1i3MAtqgbC7K8cdSwPaKJK0EepF5XVhaJc7exZQ2UO7ikKPWTo9RawGLweGt6DUED/t+EZbS+mywP66TSyGwxG1MS5w3smAYK3mhruYpxUc38q85j01CLl5wds6Nc/RDnJbQyUMtTBsSSEVYnIvLDWfYsyvpDIDNddXsXeg+bb2yEcvcwtVy76D7sDlt1Mj+SXhHNK+swB2teiUtLBTNIYf4mRIbut/P+Zen5gbiz0bF0vvCWnjNQUlW4CVf4BsXnGlbIJ2k2wIv7vo41mPlSZlSIzxT3toLgpJPNojvHDF5B1/v2BFfsFs0Tks6VMr1Tkfvw8j9n6hqj9c4CFkJcaIcvwD/rc04urzRtlo2qJRyQSewA/P+RMTEru/A4WrnxV1Ixjii0sYWDVjhbVEzf/FEihgn0IOlWI
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(376002)(39860400002)(366004)(136003)(451199021)(86362001)(478600001)(83380400001)(38100700002)(186003)(26005)(41300700001)(71200400001)(54906003)(7416002)(316002)(4326008)(8936002)(2906002)(122000001)(66556008)(66946007)(64756008)(66476007)(66446008)(6486002)(6512007)(2616005)(91956017)(82960400001)(8676002)(76116006)(6916009)(38070700005)(36756003)(5660300002)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dGZTdkpKRFBGdzllekRrM0VuVFRnRDRUb3JFL29ITjU2cDhPbDR4VmgvaU9S?=
 =?utf-8?B?NmMvVUVQRGhLZDBIL2FqbXN0ZW9Fd0lFUTRaQ24xU0J1NzVVWnRXQnV5dTNv?=
 =?utf-8?B?VWlMZ2pPT3htMmhNb1ZlWVNxWm9yOXBVbW5MNVhPclNjNVdzbGFFZjV6dWxH?=
 =?utf-8?B?V3d6M3JPc1NwbHV3MFdHU01Lb0lWQUxNK1NaN1hvWU52S1FYTUlhbnhYSnpj?=
 =?utf-8?B?cVVXVFZnaUlLenNKSEV1Uy9HN25GQXgycDN1amtLUCsxT3AwRnRYY3VUZEpn?=
 =?utf-8?B?NFFtM2dOeEp1TzlaNWRCSVNIVk9jbkxqeXVzSUFuSXpOS1E2UlRJNGQ4bHc0?=
 =?utf-8?B?QjJYclQ5dk9NMkdOeDZsOEZLNVJhazFMOWIzaXordnNpcjJoc251SEZQWXFD?=
 =?utf-8?B?cXlRTDIyZXZ4U2JTaURGTXg3amJJMjRyQjNiSStNaGlRM09vZWU2MXJ3dEtu?=
 =?utf-8?B?bEZZVStBK1dBTjNhQWh6R3I3ZnZFai8wVEJCZTAvS0FGeUsvUjJoQnJob0lv?=
 =?utf-8?B?UnZiQWNCa3pITDRUL2RnOVJ1eTVxNzc1ZldTL3pWbkU1alAxZ1NxK0JQOXBQ?=
 =?utf-8?B?Q01iTldHYkV5WS9Lb1hWblh5ZDQ1QU05R2Y0aGQzNlMxSDEyVFN1NE45ZVFB?=
 =?utf-8?B?SStpUFprWkZnVUUxREZqaWR6M2k4NzhPUjFzdFp5eUxLa2NoNWJPVThKeXFp?=
 =?utf-8?B?WDRrM3ZUVVZ1c0xrY21pSGFrL1JnemltZVczclpiaStlb1M5bGtkbW5kU2RD?=
 =?utf-8?B?a2FhYmVwMEYrRWs1WkZoMVRYWVczWVlnLzdIVm9TWFFUZDBOOVdWZkRtTFZn?=
 =?utf-8?B?QjVxYWhoZW5WNnZCbmpzWG5rckRWaTZsRVV4UkVFd2FucGZvUFZCYndUY0ZZ?=
 =?utf-8?B?QXNwd2QwRVA0bTJBODJTYjNPTEoycWE4enFaZ3BRajhvRGZIbnVyMzAvS2Q4?=
 =?utf-8?B?NEhqYTA5SUhSMmJvN28vdEx0aEdQbXk1bTdQREdoTVhuQWxjZ0ZWbnV1ekpw?=
 =?utf-8?B?QkpzVVBlamRxTjVCcnFEc09NSEFqLzVGSzlWTXdOc2tTcVc0ME5WY0E2TEZ2?=
 =?utf-8?B?aEptUit3aTdsUWc4Q1JUdkRzNWZYQXdrby9PZjZpZjBVT1cxTVZnZEFPK1hh?=
 =?utf-8?B?UVhTSnIxTTY1VTN1RlBaTUQwNnFNWFhpSGkwT0dKRDNET1BqUnpFYzlJWmxo?=
 =?utf-8?B?cUhjV0RkMFpaaGhzblM0Q2V6SlVDN0JyWXdkdzRwOFRtK0xlUXh1S2xqam5r?=
 =?utf-8?B?djFBY1JiWmZ3QVk0elc0YzVGclVuME04QjNIQTNRTDJYS2Y1Sm1seGpIa1ls?=
 =?utf-8?B?d21WOGNXZDhOOWZ3QTdMKzkvZFV4a3dzNThqL0MvbXZEVVJ3WDJiWXhtZmdX?=
 =?utf-8?B?N0VEM1Z4a0VwMUtsSTE1TnZ2UGtJREc4VjJzTzEvLzA4cFhOdzdnd2xWQ01Q?=
 =?utf-8?B?N0pidmV0OFNIY3ExTVFWNWpDK0VEeS9zUDJCUDlIMnF6RlhHcWt1STE1Z2tl?=
 =?utf-8?B?K1J3WVV2TkNWSmRHVjgvM1JaSzN2RDN2Q2pHY2F3TDVMNWIwR0JSS2tUZ2dJ?=
 =?utf-8?B?NldlZWhxb0pQYlpidmFvRzg1bGM4VG14UUMwZVlGNnRiT1c2azA4RWd5ZlBX?=
 =?utf-8?B?MHlXVnNiL24reDV4RzFiekg2RzY0aVdicXNUUTJkSlp6ejIySXNHbUIycjVN?=
 =?utf-8?B?Y0pzRm5IbmU3Zml5QVhVbU16VjZYcW1iY1NZSU9QT3lEdFdGemVlcGVOeEtL?=
 =?utf-8?B?QWRNanoxMHR1QXMrWXBDS1QvbmFxMFdIYVVqNkNvSEo1UTZkRnNKazk4eWNT?=
 =?utf-8?B?MXIzcjhTTDh5c1BWT0xoUFpFRVFmOUc3YUlsdmljaSt5OWNDVHhya3BpNVFY?=
 =?utf-8?B?cHliREZiQlpXMTIwd1JUTmp4S2Q5Q0F6dWJHNlpMd1o1WnQwZm5VWDlkZGxu?=
 =?utf-8?B?ZmJPS2F4ZjZwc3FSeHpVQUJOYWFzWmRUUFpuRTQxZG02K0hBSEFTNFBWdUFF?=
 =?utf-8?B?T2ZwVlpYVnB5bVhMdzFQTGl0c0FGeE5WZWR2UXFjZWV2bFFJL0pLSHhaTGRs?=
 =?utf-8?B?YVFjbm13L1U2TVptVmRhYm5BTG5QcTE5V1d0RTdISG5OR0V1bHFvKzFhZGNV?=
 =?utf-8?Q?2KVZMPI65kXsCIsRmo8spQ+9T?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6E747FC8F223D5469C6626D3698E086F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1335e960-fb64-430c-bf24-08db8d5d5ebf
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2023 22:20:36.3995
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sJ8x0PtOiPjg1292bV7/t3kIWzXuO5REmg+xpMgnOTzamwy7CKBfU25UdN9cNEb2SFGh3pz+2nOk6Z3ua83NGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6935
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

T24gVHVlLCAyMDIzLTA3LTI1IGF0IDExOjE1IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUdWUsIEp1bCAyNSwgMjAyMywgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IE9uIEZy
aSwgMjAyMy0wNy0yMSBhdCAxMzoxOCAtMDcwMCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToN
Cj4gPiA+IEJhaWwgZnJvbSB2bXhfZW1lcmdlbmN5X2Rpc2FibGUoKSB3aXRob3V0IHByb2Nlc3Np
bmcgdGhlIGxpc3Qgb2YgbG9hZGVkDQo+ID4gPiBWTUNTZXMgaWYgQ1I0LlZNWEU9MCwgaS5lLiBp
ZiB0aGUgQ1BVIGNhbid0IGJlIHBvc3QtVk1YT04uICBJdCBzaG91bGQgYmUNCj4gPiA+IGltcG9z
c2libGUgZm9yIHRoZSBsaXN0IHRvIGhhdmUgZW50cmllcyBpZiBWTVggaXMgYWxyZWFkeSBkaXNh
YmxlZCwgYW5kDQo+ID4gPiBldmVuIGlmIHRoYXQgaW52YXJpYW50IGRvZXNuJ3QgaG9sZCwgVk1D
TEVBUiB3aWxsICNVRCBhbnl3YXlzLCBpLmUuDQo+ID4gPiBwcm9jZXNzaW5nIHRoZSBsaXN0IGlz
IHBvaW50bGVzcyBldmVuIGlmIGl0IHNvbWVob3cgaXNuJ3QgZW1wdHkuDQo+ID4gPiANCj4gPiA+
IEFzc3VtaW5nIG5vIGV4aXN0aW5nIEtWTSBidWdzLCB0aGlzIHNob3VsZCBiZSBhIGdsb3JpZmll
ZCBub3AuICBUaGUNCj4gPiA+IHByaW1hcnkgbW90aXZhdGlvbiBmb3IgdGhlIGNoYW5nZSBpcyB0
byBhdm9pZCBoYXZpbmcgY29kZSB0aGF0IGxvb2tzIGxpa2UNCj4gPiA+IGl0IGRvZXMgVk1DTEVB
UiwgYnV0IHRoZW4gc2tpcHMgVk1YT04sIHdoaWNoIGlzIG5vbnNlbnNpY2FsLg0KPiA+ID4gDQo+
ID4gPiBTdWdnZXN0ZWQtYnk6IEthaSBIdWFuZyA8a2FpLmh1YW5nQGludGVsLmNvbT4NCj4gPiA+
IFNpZ25lZC1vZmYtYnk6IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUuY29tPg0K
PiA+ID4gLS0tDQo+ID4gPiAgYXJjaC94ODYva3ZtL3ZteC92bXguYyB8IDEyICsrKysrKysrKyst
LQ0KPiA+ID4gIDEgZmlsZSBjaGFuZ2VkLCAxMCBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygt
KQ0KPiA+ID4gDQo+ID4gPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3ZteC92bXguYyBiL2Fy
Y2gveDg2L2t2bS92bXgvdm14LmMNCj4gPiA+IGluZGV4IDVkMjE5MzE4NDJhNS4uMGVmNWVkZTlj
YjdjIDEwMDY0NA0KPiA+ID4gLS0tIGEvYXJjaC94ODYva3ZtL3ZteC92bXguYw0KPiA+ID4gKysr
IGIvYXJjaC94ODYva3ZtL3ZteC92bXguYw0KPiA+ID4gQEAgLTc3MywxMiArNzczLDIwIEBAIHN0
YXRpYyB2b2lkIHZteF9lbWVyZ2VuY3lfZGlzYWJsZSh2b2lkKQ0KPiA+ID4gIA0KPiA+ID4gIAlr
dm1fcmVib290aW5nID0gdHJ1ZTsNCj4gPiA+ICANCj4gPiA+ICsJLyoNCj4gPiA+ICsJICogTm90
ZSwgQ1I0LlZNWEUgY2FuIGJlIF9jbGVhcmVkXyBpbiBOTUkgY29udGV4dCwgYnV0IGl0IGNhbiBv
bmx5IGJlDQo+ID4gPiArCSAqIHNldCBpbiB0YXNrIGNvbnRleHQuICBJZiB0aGlzIHJhY2VzIHdp
dGggVk1YIGlzIGRpc2FibGVkIGJ5IGFuIE5NSSwNCj4gPiA+ICsJICogVk1DTEVBUiBhbmQgVk1Y
T0ZGIG1heSAjVUQsIGJ1dCBLVk0gd2lsbCBlYXQgdGhvc2UgZmF1bHRzIGR1ZSB0bw0KPiA+ID4g
KwkgKiBrdm1fcmVib290aW5nIHNldC4NCj4gPiA+ICsJICovDQo+ID4gDQo+ID4gSSBhbSBub3Qg
cXVpdGUgZm9sbG93aW5nIHRoaXMgY29tbWVudC4gIElJVUMgdGhpcyBjb2RlIHBhdGggaXMgb25s
eSBjYWxsZWQgZnJvbQ0KPiA+IE5NSSBjb250ZXh0IGluIGNhc2Ugb2YgZW1lcmdlbmN5IFZNWCBk
aXNhYmxlLg0KPiANCj4gVGhlIENQVSB0aGF0IGluaXRpYXRlcyB0aGUgZW1lcmdlbmN5IHJlYm9v
dCBjYW4gaW52b2tlIHRoZSBjYWxsYmFjayBmcm9tIHByb2Nlc3MNCj4gY29udGV4dCwgb25seSBy
ZXNwb25kaW5nIENQVXMgYXJlIGd1YXJhbnRlZWQgdG8gYmUgaGFuZGxlZCB2aWEgTk1JIHNob290
ZG93bi4NCj4gRS5nLiBgcmVib290IC1mYCB3aWxsIHJlYWNoIHRoaXMgcG9pbnQgc3luY2hyb25v
dXNseS4NCj4gDQo+ID4gSG93IGNhbiBpdCByYWNlIHdpdGggIlZNWCBpcyBkaXNhYmxlZCBieSBh
biBOTUkiPw0KPiANCj4gU29tZXdoYXQgdGhlb3JldGljYWxseSwgYSBkaWZmZXJlbnQgQ1BVIGNv
dWxkIHBhbmljKCkgYW5kIGRvIGEgc2hvb3Rkb3duIG9mIHRoZQ0KPiBDUFUgdGhhdCBpcyBoYW5k
bGluZyBgcmVib290IC1mYC4NCg0KWWVhaCB0aGlzIGlzIHRoZSBvbmx5IGNhc2UgSSBjYW4gdGhp
bmsgb2YgdG9vLg0KDQpBbnl3YXksIExHVE0uICBUaGFua3MgZm9yIGV4cGxhaW5pbmcuIA0KDQo=
