Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B378D6239BC
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 03:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232498AbiKJCVG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 21:21:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbiKJCVC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 21:21:02 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4EA321E3A;
        Wed,  9 Nov 2022 18:21:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668046861; x=1699582861;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=IMlYDxb2XcFMioYCtNAKqgL863k5JuepT/AfV4jdnbc=;
  b=Gp7Kajy6lmY9T1wfs0GMQkOpWgEHrkHuBEnyYeMb6z9NCw5Frfg+97Jt
   YpVZIymXMm110QA2s31189mJxb9mZGHFdRCKMLicSwN3IZkN0QfodGJsw
   WW9oxoVSsra+ZVWcCnUq2ZXpjvw6Lx4k60dUa+xwhFnWqvHqDh92kjjCk
   N2Kbq2WP/mAb6Z+iBdkjVe0YOrSw4UN2sVlEpFxg3Vx4HKfcjGjwIzH/c
   kgs44ditSFig85cKQmwJ7mJBzYBwsILdZ39l/kSl8VUCRLzs6VxaMvHFS
   RRSWQ7ZM/Sf7S8kIzQ9pbwMYBBE77YMN34xujy0CQRDSoTwaNxRJQI7Wg
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="375429569"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="375429569"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 18:21:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="614919873"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="614919873"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP; 09 Nov 2022 18:21:01 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 9 Nov 2022 18:20:59 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 9 Nov 2022 18:20:59 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 9 Nov 2022 18:20:59 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 9 Nov 2022 18:20:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PAOCKk9cpMVJ4frLOnmA/0n4rug887FR/BwKDpAchtdLjRcrR1ah3dm5M0zOfVRFg4DRA5RIAHzyWcE92zqk6/hLcdRYToSdfx2U+7q6g2bPNoOJUx1WIBJfRCU/Tr/RmQYKZZLOe808L3AyFC7v2s4hfp80lVWCNbFNwomVoG+5Wn/nEAImFyKIyxZUXFHEh7IN/r8c4mdSeJHhwOQ89NB9B41pz/+oS8pyDvrLaRRUA7GZWJ6fLoiGNmFSS/MW+YHOUuIotqVOn5cRCEY/3atj4H90BxhAUvauzXokiZcN0yHfcAQVp5vLUoEHWuyd4LZu71sx8KkeRe3hv7wKoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IMlYDxb2XcFMioYCtNAKqgL863k5JuepT/AfV4jdnbc=;
 b=deWFltI391ZmxsocxzWq3awKtoibpskshGPWeHLPMrfb313V9ejXLYExh8bJAa3laLcGXKRTnAmIMJKdceASHD0gtRHCw19cFUsrQ48PpSNULXjhRiXOH6PiViLNVVaNnql19bCN3mJgTGHv03iWiebXi9OkZPQ+/wYG+diJYiXGbTs+JGiZVmowgUVsYVSO0pLJUi/iyJd1zbZ9FEA4yPhp9v/06DCNEgGzpvee/0L+e5Zg+oulhos8d+caTyws+3Alh32D1AX5teBA24XHNjQ2uCQotbZZnUOGv1dgfAWqZbYEdXl0cTnYjZ0hN5JYCgPNHutyEvPJ+q4EUynaSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MN2PR11MB4680.namprd11.prod.outlook.com (2603:10b6:208:26d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Thu, 10 Nov
 2022 02:20:57 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b%3]) with mapi id 15.20.5791.026; Thu, 10 Nov 2022
 02:20:57 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "frankja@linux.ibm.com" <frankja@linux.ibm.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "chenhuacai@kernel.org" <chenhuacai@kernel.org>,
        "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>,
        "palmer@dabbelt.com" <palmer@dabbelt.com>,
        "paul.walmsley@sifive.com" <paul.walmsley@sifive.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "anup@brainfault.org" <anup@brainfault.org>,
        "imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
        "aleksandar.qemu.devel@gmail.com" <aleksandar.qemu.devel@gmail.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "atishp@atishpatra.org" <atishp@atishpatra.org>,
        "farosas@linux.ibm.com" <farosas@linux.ibm.com>,
        "david@redhat.com" <david@redhat.com>,
        "Yao, Yuan" <yuan.yao@intel.com>,
        "mpe@ellerman.id.au" <mpe@ellerman.id.au>,
        "alexandru.elisei@arm.com" <alexandru.elisei@arm.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "james.morse@arm.com" <james.morse@arm.com>,
        "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
        "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "Gao, Chao" <chao.gao@intel.com>,
        "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>
Subject: Re: [PATCH 38/44] KVM: Disable CPU hotplug during hardware enabling
Thread-Topic: [PATCH 38/44] KVM: Disable CPU hotplug during hardware enabling
Thread-Index: AQHY7xJy2pUg1L4bCkib6AOkbzD9bK43Y9yAgAAUIAA=
Date:   Thu, 10 Nov 2022 02:20:57 +0000
Message-ID: <d1d4f912292fbfb4f7d88940f22eb9fbcc582ba1.camel@intel.com>
References: <20221102231911.3107438-1-seanjc@google.com>
         <20221102231911.3107438-39-seanjc@google.com>
         <4f523a166badbd61a1cfb6269334e9c9354ade64.camel@intel.com>
In-Reply-To: <4f523a166badbd61a1cfb6269334e9c9354ade64.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MN2PR11MB4680:EE_
x-ms-office365-filtering-correlation-id: ec0501b3-4e9c-452d-d0c1-08dac2c233d5
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bvFBpBaFTCNoNBGdktA9oSwQKDTH4YZN6q89cfuJls+9Bm+5WyVsVDfZEfqnL8j8trppMnc91ySiOOBT9pYYn4OOdC82DbYqjlE/b2u8RNzJv2e1ENAKBLN4KRoJRyTSCo8qjS1V2nUCXapSB0r2SGHN6s4iJUHBuCOMvT+F4/Wi+bSGQl6O8T4BuW81AnYxJ/+dJ4dNkTCDFDxNDmwRmEJW6HodACPU77V4yCwpLRasDbbgE+eoNzrD+Hc+4csMgausaPXD6WQsqc3dApFAYwvmuNR/1UGTu6fZ2H6jNAkX/18wolyD6GImPhKzgKST/TkN+pF6jBGXLU4NEKOX+Rd6pnxaXrpLzb5DqeMvTQ9dP/J9lReSU01v5eV9LCAkvh4Qu4lkfvWgA+dgH3147XtgjB9Hep6LTDJAUSK8wbGzGe3bIQj9vPADL5P1xgDvKSP4K4CAcwM3haoqFCSrb5c72W3/PCrF2r7pBr+dUTl5KetpyB2RNQdgCUVwfgyhDhZRQPYIyO6APeIar7jG6G7WnhuODJhFwhAMxpWQofo5mAgfCGigMtxxr3+jrANrWRLl8oGdtDQzh2Xa1Z3F1LD1Q2kvMPNwVKz3NdxMn2ISt4GI0/oR3mCq7ficWhxudCRIH81kLKriVxt+6Tsl/ZOy8Fg65C/MDZWkB3eIcYiNSw/1dvwRPck9KsOm9FRGbGXRqn2YhnTshstXMplmAfym45O7b7pH1BrY2MZSNSKZrZdcIyouCNb07yvWEgYRSGnsWt5pNxtIcpPdawTyozpmzrSfpEalqUMDupIMyIU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(346002)(136003)(39860400002)(366004)(451199015)(38100700002)(122000001)(2906002)(4001150100001)(4744005)(86362001)(38070700005)(921005)(7406005)(4326008)(6506007)(2616005)(6512007)(478600001)(26005)(66476007)(316002)(54906003)(82960400001)(66556008)(66446008)(76116006)(64756008)(66946007)(91956017)(71200400001)(6486002)(8676002)(110136005)(8936002)(5660300002)(186003)(7416002)(36756003)(83380400001)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N2JVRHQ5WTZiM3FxZ2hnbU55Zk9mODdJWlNpY281ay8raDAwMnFzK2c0cHJV?=
 =?utf-8?B?c0ZrK0Jza2o0SThtSm5MbjNPOXM5Z2RhOEM1UDF2VXYyUWFVbzdOblYvQWli?=
 =?utf-8?B?L0I0RlRPUXU4blBtU3VzdisySG5PR25QenBoMStXTnFackErZndBRHZRTExV?=
 =?utf-8?B?cmhodW9mY29EZlNBR1RUclAzeUk2SXhsSUJrVVdXbUVLWFhRYU5idEJIamky?=
 =?utf-8?B?MjFwc3ExU2lVa0VKbzY3Z0U1bmR4OWVEZ1kxcSsrUk5rMmt1bVc2enBGSG9V?=
 =?utf-8?B?VEtRa0F5NzdNMGZTR1dsM0dMVWtKQ2hFSEovano2VjFYV1lXREFzSFdMOEVv?=
 =?utf-8?B?VmZyekZxbTlXaDl1QVhienVMbFEwbjZJSW5VamgyVXZ2UUlmTHRBOS96QzY0?=
 =?utf-8?B?VEREa09hVk1WQkFaQ2EvaS92M25ldkhUdmZIa3RqQll4NEF2M3Z4TDByVTl2?=
 =?utf-8?B?Q1FwTS95cjM1QW0wRzVrNXhud0pUTHgrb0lCZG8xRVZtK2dvcXZTcjFQZ2JP?=
 =?utf-8?B?cFoyNEE4MDQwcDg1alc1UVZIdU13OEkwSG5JeVc5dXVvcDZvUmsxYzBXWERW?=
 =?utf-8?B?a3BKSkkrTGVBcmUvdUxkR1J2dU1URjBzdlRCbDIzL3VTYXIrOW9hMTZPZ0ZP?=
 =?utf-8?B?QWhlQVAwa1RLWXBaZ0Q1YTJXMENDNGpNaUwxdlp3QkJsZHMxdDM1V2Q5T2ho?=
 =?utf-8?B?RVp2MHUvSm5xa1FiMzVtb0ROWjdIcDdhYnJxRFBxNTlyM0VEaXNpRm16Z0lV?=
 =?utf-8?B?VDJZQWw1b3dJKzdmWDFrZWhwNjk2QTlKNERyVDZWS0wxUjF3QU02ZmdWMTdR?=
 =?utf-8?B?OXVYM0tHYVViZU0wYnlVNXpTaUphWUM2Y0hhZUJKcWFGZ1lyNE9hcEZaTVM5?=
 =?utf-8?B?UVVocWZwSGw3aXEzY2ZMNjJibTk5SjN5QmRXdmJQUXZReDFUclp5TEQwQW5u?=
 =?utf-8?B?NjBpZVZXZzFMOStaTUZDUlVNUDBqeEJXR1hVYUhneGFiTldlTkVvSzhFQmxt?=
 =?utf-8?B?Nm1HWjJvUkdOUFZ1N0Z2NmRidlNwZDBzakgwUVcvUVJCaysvTi81UFJjUmh3?=
 =?utf-8?B?T1pWeVB5cmZBQWVlQzZtcDBCZndrMkxUS21KR3FlREFuREh0bkRVRys5emcx?=
 =?utf-8?B?TEJCQWN0UWlvYUdudGFBQVlYcloybUpLbEhXdFhESnN4NUpxTkFTQ1lOR3Jv?=
 =?utf-8?B?aTdVeVBMalVtVUJxOTZIaWF5RVNxS0MvWUUwSGdkb3JPSGh4YlBXTlk3RzBS?=
 =?utf-8?B?WEFvVHhObWlEV2IvM3F3ZGQvVFF3N3NoMHVNTEJGdHQ3MW5jajNOQmRWZ3pO?=
 =?utf-8?B?STFOUkJad20rakRJTXZ3MC9leXNXMEJIa1RvUWdYTXVFQjlJZEtwVndFSnZP?=
 =?utf-8?B?cDQ4eks5b1RvNmFiR0EyMVZDcjJqek1QUXRwYnljL1dsUVZiVUd3NEpUWGkx?=
 =?utf-8?B?UnlDUHlsNFZMdGJ3MHMvNUVVaDVreWFEUk5rcCtkb3F4dVVKeHlFcWgvWi9C?=
 =?utf-8?B?VjVRb2JqMkt2dDZReWN1b2NOcXV0Z1NXcDJnQ3RhR3lMQndwRS9IWTN6bEZW?=
 =?utf-8?B?ZGw1alRtK3kxbGFXd0paL0RlRzVrMmZKMVJITmROMmI5bFdIaXJVY0xTUXVt?=
 =?utf-8?B?QkxDdlI1eFJhYW02dU5BTHhQTnBCSUJPS0QrNXJFQVZUSFRtaDJUcVJPVTM1?=
 =?utf-8?B?Q3E0dTdCaVdUVngwR1FuSGViRjlQYVE0Qit4R0pXcm9zbDlZY3E5Yi9PRWpk?=
 =?utf-8?B?QUVJMWo4UWwvMHdNWjg4ZW9rR01TMXRIRVdCNUlIaUI2eU9KREUzck9lYkJi?=
 =?utf-8?B?amkxM1ZWT2hRYWVEb2FLT0NYKy9kaHovNzZnM3VCRVNkWG5OVi8vUm1LY1lj?=
 =?utf-8?B?bDJiVlQzRkgrT0tVd0xTc0JRWm9nMVJHSHpDTWRXYnRyU2FsOXFOdWpTWTZ2?=
 =?utf-8?B?TGFRSkF3bFoxWGFhY3EyVFhPakVrRmVxY2JmQ3JreFpZdEdmTXYrMnc0bFRZ?=
 =?utf-8?B?b1JNT2kzc3NQeWlGL2ptTkVKdXJkK01DNUJrakVrdjBhREs0RVllK2RQODhP?=
 =?utf-8?B?SkpldERBZ2JPMlpzWGJBYk1HOENFUjd1bDlvL0wyRm5wMTdUaFhNTm9YNENh?=
 =?utf-8?B?MG16ZnlDRG93c1FWZitXSkxZdldCb0lta0lxTWlUQldLY21ocng5RkNqa20w?=
 =?utf-8?B?N1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0E411A7854D97B4A842952146CBFE876@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec0501b3-4e9c-452d-d0c1-08dac2c233d5
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2022 02:20:57.4972
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pmBT173SRRP6urjuNWymGd8XKkR4KpmGc6QrOl3H40+9mWt5A7QgR2KoRbh6cTo2ASXXpxC0SdYxVD+XTYWhEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4680
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIyLTExLTEwIGF0IDAxOjA4ICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+
IC0JV0FSTl9PTighaXJxc19kaXNhYmxlZCgpKTsNCj4gPiArCS8qDQo+ID4gKwkgKiBDb21wYXRp
YmlsaXR5IGNoZWNrcyBhcmUgZG9uZSB3aGVuIGxvYWRpbmcgS1ZNIGFuZCB3aGVuIGVuYWJsaW5n
DQo+ID4gKwkgKiBoYXJkd2FyZSwgZS5nLiBkdXJpbmcgQ1BVIGhvdHBsdWcsIHRvIGVuc3VyZSBh
bGwgb25saW5lIENQVXMgYXJlDQo+ID4gKwkgKiBjb21wYXRpYmxlLCBpLmUuIEtWTSBzaG91bGQg
bmV2ZXIgcGVyZm9ybSBhIGNvbXBhdGliaWxpdHkgY2hlY2sNCj4gPiBvbg0KPiA+ICsJICogYW4g
b2ZmbGluZSBDUFUuDQo+ID4gKwkgKi8NCj4gPiArCVdBUk5fT04oIWlycXNfZGlzYWJsZWQoKSAm
JiBjcHVfYWN0aXZlKGNwdSkpOw0KPiANCj4gQ29tbWVudCBkb2Vzbid0IG1hdGNoIHdpdGggdGhl
IGNvZGU/DQo+IA0KPiAiS1ZNIHNob3VsZCBuZXZlciBwZXJmb3JtIGEgY29tcGF0aWJpbGl0eSBj
aGVjayBvbiBvbiBvZmZsaW5lIENQVSIgc2hvdWxkIGJlDQo+IHNvbWV0aGluZyBsaWtlOg0KPiAN
Cj4gCVdBUk5fT04oIWNwdV9vbmxpbmUoY3B1KSk7DQo+IA0KPiBTbywgc2hvdWxkIHRoZSBjb21t
ZW50IGJlIHNvbWV0aGluZyBsaWtlIGJlbG93Pw0KPiANCj4gIktWTSBjb21wYXRpYmlsaXR5IGNo
ZWNrIGhhcHBlbnMgYmVmb3JlIENQVSBpcyBtYXJrZWQgYXMgYWN0aXZlIi4NCg0KQWxzbyBpZ25v
cmUgdGhpcyBvbmUgYXMgSSBvbmx5IHRob3VnaHQgYWJvdXQgaG90cGx1ZyBjYXNlLg0K
