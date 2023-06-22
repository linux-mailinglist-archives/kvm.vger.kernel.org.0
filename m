Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7FE739DE0
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 11:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbjFVJ5R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jun 2023 05:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbjFVJ4u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jun 2023 05:56:50 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B8D72979;
        Thu, 22 Jun 2023 02:55:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687427729; x=1718963729;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=nfx5Kx+YofBJE7sOxzWd1q5iQN0M5XDdD9Qh0JN+4+M=;
  b=dd41VnvotTituRQ/91A8F1RNp1JIsZKjDulHNnge8hR2MzXEW7FMagaz
   fqbyCl4p5GO1o2Gjs9//E6W2qRSDSq2kegN4lbFjcVMnMxd5jIqtR6sQy
   tNo1YFIu6gS7U5u07xGc8GbYBxVI6t3LOJoXcgM6l0gh00wbYIk7O8Vag
   5fOjKlAjwW5KbGCUrjkyUl8HyoqyIU9EvRvYhjEyPJZcbA9FTPeUcU5VR
   zB6JfS+41u6wtx4LcSy/YPiqu8CbKALP9tjSwgk3azHQ7BvEFxWHhvrfQ
   WASGOznvKfJNQcqF0chPjFmCnaZSUxM9LeYhPjaLVLcf2GlucX+CKIXOi
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10748"; a="357935546"
X-IronPort-AV: E=Sophos;i="6.00,263,1681196400"; 
   d="scan'208";a="357935546"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2023 02:55:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10748"; a="664986640"
X-IronPort-AV: E=Sophos;i="6.00,263,1681196400"; 
   d="scan'208";a="664986640"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga003.jf.intel.com with ESMTP; 22 Jun 2023 02:55:27 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 22 Jun 2023 02:55:27 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 22 Jun 2023 02:55:27 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 22 Jun 2023 02:55:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ca/bpQAF5BBN1xKaQwIPglARa+5/mItm+2feTlAJufN3jfxC0+nuGL+opqOXYuoplWKqEUmlUJFPaYGJNB7znyGa/JhL0vWcF1u0YuOF8UYZ/GwFAPJlpkfJKPNtE6dq9OWOnWrimDRVSCwJA3shKXgNrCSDWHugw/dJi6TGj4PubvV1pEWhiNi/Ttsvrb/f5JozOPJvGB9shAn68Zg7gLO9EfvThNx6GX2ZXJ2KYAjsElgSZUVeNAZtpFj0h4l5sJUIGQVk/W6BMg/MSc+0m+TDLDrDeEhFkoeQMUNr4HQxMKVuZW8dxUuPlmdGf7BF7kx2A4anJx38vxoHwFRkOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nfx5Kx+YofBJE7sOxzWd1q5iQN0M5XDdD9Qh0JN+4+M=;
 b=l5CSM776ki24RkDM0ZrSSlHxjL1CShNZiTxj6og3e0iEqhfli/cr8BrDWE65HFVi3YNQx3UYf19wbnycyCRMkn9EWHLMqAhfr7hEJaPQnKTIILK1LZztiiPY/XZlxrDY7k5qkX7SkvUEkG/8+B+yNqz9QI+GyPU9j/JQ6I2h3Ioo7OUM+bhOaZgqpVcBxgucQskk+WXfJwR/vNH0fBXnLRUJqquodgje0u4dq8rgcBnmPowlp4GqQ75kAiwJSf+jTxuN+2P6kV8dVC8Z1ge+yGcTpr5VgUcHvDHJ5BbacCPU2WwxFB91m8buNer8JaVRSsry5SpA3EXfrLnHYaT9iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM4PR11MB6190.namprd11.prod.outlook.com (2603:10b6:8:ad::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Thu, 22 Jun
 2023 09:55:23 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6521.020; Thu, 22 Jun 2023
 09:55:23 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "michael.roth@amd.com" <michael.roth@amd.com>
CC:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "tobin@ibm.com" <tobin@ibm.com>,
        "liam.merwick@oracle.com" <liam.merwick@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "Lutomirski, Andy" <luto@kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "pgonda@google.com" <pgonda@google.com>,
        "srinivas.pandruvada@linux.intel.com" 
        <srinivas.pandruvada@linux.intel.com>,
        "slp@redhat.com" <slp@redhat.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "alpergun@google.com" <alpergun@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dovmurik@linux.ibm.com" <dovmurik@linux.ibm.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "bp@alien8.de" <bp@alien8.de>,
        "Annapurve, Vishal" <vannapurve@google.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "vbabka@suse.cz" <vbabka@suse.cz>,
        "marcorr@google.com" <marcorr@google.com>,
        "ashish.kalra@amd.com" <ashish.kalra@amd.com>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "nikunj.dadhania@amd.com" <nikunj.dadhania@amd.com>,
        "Rodel, Jorg" <jroedel@suse.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "kirill@shutemov.name" <kirill@shutemov.name>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "ardb@kernel.org" <ardb@kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Subject: Re: [PATCH RFC v9 04/51] KVM: x86: Determine shared/private faults
 using a configurable mask
Thread-Topic: [PATCH RFC v9 04/51] KVM: x86: Determine shared/private faults
 using a configurable mask
Thread-Index: AQHZnOphA4hNJcIpGkeiRJNqOV8fuK+KheOAgAmr4oCAAA39gIABrsSAgAC28gA=
Date:   Thu, 22 Jun 2023 09:55:22 +0000
Message-ID: <c116b7ab8ca02116f2b8d19a8214161c3b30576c.camel@intel.com>
References: <20230612042559.375660-1-michael.roth@amd.com>
         <20230612042559.375660-5-michael.roth@amd.com>
         <20230614164709.GT2244082@ls.amr.corp.intel.com>
         <20230620202841.7qizls3u3kcck45g@amd.com>
         <20230620211845.GV2244082@ls.amr.corp.intel.com>
         <20230621230031.37hdnymbjzwjgbo2@amd.com>
In-Reply-To: <20230621230031.37hdnymbjzwjgbo2@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DM4PR11MB6190:EE_
x-ms-office365-filtering-correlation-id: 12af70e6-fc56-47bb-f74b-08db7306cb9c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: f2ztTwAJkqQAl+V8qQYOuLq0Jt+fYDiIuLfY/VqMLaeY/3I3qArsmkVKxpR05xTAagbnKj7U7l6K0+bOY0UAXUUe2thr9kGmPX1Ah4Iii8M9xwCd8ZjBAP9dhB+tLP2UTzqra90001WBD4K7BI+OcBUqb0dGsxLKGgvSTdeYqok8pOzCafqS25i8YcJywGjEH/8Pwn1xZp1S9bCEePewmLwO1nws+/NG09IMxgtoMA6MaTwQCaRXiR0JHj4OiN36aNcF39aY8C9ADdoEJeJdArruWhPoQGI3KinWYZkCRgDq7qmzTT+CLdEaORI6ISTDv6q5Mv6aBn1GP6xe9t4knh3nsFdqzSGwNQFzowGfKFuPiSRZW8BBHLf7fN5mN6VrjK21Xpmh+7F15As5KEumt0kQyHQRsaN2iRaGk8UTEo819AQ8ifIs6qsy7ntsf8YrIe25pxSD74VlcaK47/f+9AKvvNpEroitvbclTeQuVDh7b9uW9zqvnekHFruhNdBdQNMurjH169Sff/AdhR8SgCBuc+WaBUDLeDyh1GhnZ4p69CqKmmIgrEeCZ1cdMkkxekxNXBBGI36IdSe5rEuGWaPq9e1tpBB4h0qcGiIptsIdNS082umxaCYFlfNl1kab
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(39860400002)(366004)(136003)(376002)(346002)(451199021)(86362001)(2906002)(38070700005)(122000001)(38100700002)(82960400001)(8936002)(41300700001)(8676002)(36756003)(6486002)(76116006)(66946007)(91956017)(4326008)(71200400001)(66476007)(66556008)(64756008)(66446008)(6512007)(478600001)(26005)(186003)(6506007)(2616005)(316002)(7406005)(7416002)(54906003)(110136005)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TzdEVDlJaWozNlgzYklmWXNLUWdodG9hRWsrSWZSaUIxMzI0eFF3dkdBT1Ar?=
 =?utf-8?B?RnlGOTJYWWJ2R0p0a3ZHNmdPZTBRTHRxWXhTODhndGNVNjBodkVNeVBjeGRx?=
 =?utf-8?B?Y3ljRlBKeTlGd0ZpNVVacGFkZElKV0dUMmQ5bVp4cVQrc1JobHhhNktObGxM?=
 =?utf-8?B?TTFBRmR0UnNDd0ZYdEcyYmxoM2Z4dFNQL1IzUkZQalpzS0ZxVVl0Uk5SZnBU?=
 =?utf-8?B?b1ZMVEtXUVRXS3dlTU1waFBzd1BTWDczT05kSEdsU013MXhjeG5vUkExK2dj?=
 =?utf-8?B?algrY2k4TnR2VFRyY1d4VElBOGkxL3lma1Q0OVBuWUxyQnp2NHFBNEJic3FU?=
 =?utf-8?B?VDVtSUZyMVdPdmdHT0RENWpxQU1iQnRmZDU5WTg3dFUyNy90Q1ByRWJKQ2Rm?=
 =?utf-8?B?ZFhNTi90QUhlQUs5eTNUd3JFaEs1OWRhc29OdFR3bHlLRmZwQW9Jcm9ubm9M?=
 =?utf-8?B?VThkU2xlUW9EOG1vNmNjVlBPVWJYY2o3NUU2R3ZMWlFOeFVoLzdvRTJ2aWFE?=
 =?utf-8?B?UG1OWnJML1luVkRsQlNYV2VrUjZDV25Ga1pVbXVFelFUdHdLTWlVNExzWWlY?=
 =?utf-8?B?Q2QrQXpHODBTajdWQUxTZGlleXZ4c3FDeTZWUGoyZ1dZWHdCRE9iS0VPYkwy?=
 =?utf-8?B?djRTYm9pRlhOY1E3OTRkS2VjMHNRakx1VkxxZTlWYUxhSVN4MS9sc3lIRWdi?=
 =?utf-8?B?UlFzTENUanBMbVhVeWFlUmFpL1hlcENSTkxFQ2hhYUVFc1NqUndTK2wyeXdx?=
 =?utf-8?B?NWJnZDArWWx6bjl0R2JQQ2d3OWlpT3QxM1ovNWU2L245aHFDcTJUa2hLWE8z?=
 =?utf-8?B?dFE1UURscnJWSldPbWl6VHBoOG1PNDc1aitwZFptVTBjQzAwd3hSdWdWUlI2?=
 =?utf-8?B?WkZRRVh4dXdUU2hMVlJNMTY5UTRkVmFwVzYvOVZ1WVRmc1dJMGt3ZzJ0YUs1?=
 =?utf-8?B?Y3MzVldZYzFqQ0J5a2VDQU5sSjVOVHF6blZhb2VVcm5JdUFoeWZOaGlKUGF3?=
 =?utf-8?B?TjRpcU15SU5YeTd2bnVJWUNhajFlUnN1YVZYMlJYcGhBN0pnRnlVbmVnV21s?=
 =?utf-8?B?VWF1MlozSlJUUmhlTTRKZHZDVWQrNnpqUExXMFlLS2Y0T2Q1cGZWaGtVZnpQ?=
 =?utf-8?B?VDVBcVBSeWloM3pBKzJGT3lKU2xOcFFDSHhVSWFYRVVzalU2ck8wbXRiWVhy?=
 =?utf-8?B?ZEhseGNtZ2plQy9QZHVHYWc4dml6bHN0OGRER0paSTM1Q3luOTFEVmVKejhH?=
 =?utf-8?B?NldTSjhsSkJXQjE2U2QvMXJ4NDh4VmVoVXp2eE1yMGJTWlBhaGhSWFlZUnlF?=
 =?utf-8?B?bjNjbDM2Mmppam0zc1pwZVFwNWlBM1FlelVxeEQyQmxVaWxaOFF3V0FFV2xs?=
 =?utf-8?B?TWdFOTFyLy9ETVhqSnN2V0ZmNVZpMjJBWS91TVdvYmJ2SE1IZG1EcW5sRXhJ?=
 =?utf-8?B?UVBhc1ArVUQvUmlkSFhQb2hQTFl6OHRkZkxabCtJaGFYZ0NwRmJiMjRGcHcw?=
 =?utf-8?B?aThOdFJCdW5LaXBLUFBPWGovVHcwODE5UGlFclByZGxPbEVuYWp4MXY4THNo?=
 =?utf-8?B?dSs5YjVsUHN1SjYySlErWW5LSGRjbzhuQ2VRaWtCdWowTTNlTGdQV0E1a0RZ?=
 =?utf-8?B?eU5wZVBvcVhqRmQ2RGZOalJZUFFDQ3BDQTg3SURqUTVDMnhtaThiLzkwL0Fy?=
 =?utf-8?B?b0VscURJdk5qRGdCakxHYTc1bHFrSUVLOVI0WjFTV0txL0JLYmt0d1ZGVXN3?=
 =?utf-8?B?dm5vS3JJOGNlNGxBMmIyb0M3NHlOT3dWRUhScEVkdWpHUWJ3TTZNSmE0R0J5?=
 =?utf-8?B?TURBMHMwTG5EdHN3UGRqdlJKWnp6cEowRzJZWXZSU29JTnV0eURvQmtwRmph?=
 =?utf-8?B?TG1jK2s1UVEvR2ppUzNLM0w1anNMWlRjS0VpcFRCSnBraGF2RUxUQ3NiaEpt?=
 =?utf-8?B?TzdHK0xsc09mRHZMWFQ4eWNaV2J4azhLTlJZdmVNU1RlbVdlL25JTDVvdUcv?=
 =?utf-8?B?VkZoL01SZUJ4bGZWWnlmNXd2YjB1REdLbDFvM2xpWnRoSVArWUpuYjU4VnFU?=
 =?utf-8?B?eGpZL243Tmg1REdMR3p2WDJuY3FmTjJYTk01djJTbitpTkQrc0hRbFRiRDVp?=
 =?utf-8?Q?j4vTRRjhn9fjtN2c+gTNZ855P?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E5E6B13C56399C4BB323FBF43FEA0748@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12af70e6-fc56-47bb-f74b-08db7306cb9c
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jun 2023 09:55:22.5928
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vgZDAC9F5ZcaNfMRrZ0WWX6k9aff4Jy220hwjfla1iYg85MP6ERs8e/6LrFjlDHEFYxIES921KsCdtbe1e8Igw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6190
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQo+IA0KPiBTbyBpZiB3ZSB3ZXJlIHRvIHN0cmFpZ2h0LWZvcndhcmRseSBpbXBsZW1lbnQgdGhh
dCBiYXNlZCBvbiBob3cgVERYDQo+IGN1cnJlbnRseSBoYW5kbGVzIGNoZWNraW5nIGZvciB0aGUg
c2hhcmVkIGJpdCBpbiBHUEEsIHBhaXJlZCB3aXRoIGhvdw0KPiBTRVYtU05QIGhhbmRsZXMgY2hl
Y2tpbmcgZm9yIHByaXZhdGUgYml0IGluIGZhdWx0IGZsYWdzLCBpdCB3b3VsZCBsb29rDQo+IHNv
bWV0aGluZyBsaWtlOg0KPiANCj4gICBib29sIGt2bV9mYXVsdF9pc19wcml2YXRlKGt2bSwgZ3Bh
LCBlcnIpDQo+ICAgew0KPiAgICAgLyogU0VWLVNOUCBoYW5kbGluZyAqLw0KPiAgICAgaWYgKGt2
bS0+YXJjaC5tbXVfcHJpdmF0ZV9mYXVsdF9tYXNrKQ0KPiAgICAgICByZXR1cm4gISEoZXJyICYg
YXJjaC5tbXVfcHJpdmF0ZV9mYXVsdF9tYXNrKTsNCj4gDQo+ICAgICAvKiBURFggaGFuZGxpbmcg
Ki8NCj4gICAgIGlmIChrdm0tPmFyY2guZ2ZuX3NoYXJlZF9tYXNrKQ0KPiAgICAgICByZXR1cm4g
ISEoZ3BhICYgYXJjaC5nZm5fc2hhcmVkX21hc2spOw0KDQpUaGUgbG9naWMgb2YgdGhlIHR3byBh
cmUgaWRlbnRpY2FsLiAgSSB0aGluayB0aGV5IG5lZWQgdG8gYmUgY29udmVyZ2VkLg0KDQpFaXRo
ZXIgU0VWLVNOUCBzaG91bGQgY29udmVydCB0aGUgZXJyb3IgY29kZSBwcml2YXRlIGJpdCB0byB0
aGUgZ2ZuX3NoYXJlZF9tYXNrLA0Kb3IgVERYJ3Mgc2hhcmVkIGJpdCBzaG91bGQgYmUgY29udmVy
dGVkIHRvIHNvbWUgcHJpdmF0ZSBlcnJvciBiaXQuDQoNClBlcmhhcHMgY29udmVydGluZyBTRVYt
U05QIG1ha2VzIG1vcmUgc2Vuc2UgYmVjYXVzZSBpZiBJIHJlY2FsbCBjb3JyZWN0bHkgU0VWDQpn
dWVzdCBhbHNvIGhhcyBhIEMtYml0LCBjb3JyZWN0Pw0KDQpPciwgLi4uDQoNCj4gDQo+ICAgICBy
ZXR1cm4gZmFsc2U7DQo+ICAgfQ0KPiANCj4gICBrdm1fbW11X2RvX3BhZ2VfZmF1bHQodmNwdSwg
Z3BhLCBlcnIsIC4uLikNCj4gICB7DQo+ICAgICBzdHJ1Y3Qga3ZtX3BhZ2VfZmF1bHQgZmF1bHQg
PSB7DQo+ICAgICAgIC4uLg0KPiAgICAgICAuaXNfcHJpdmF0ZSA9IGt2bV9mYXVsdF9pc19wcml2
YXRlKHZjcHUtPmt2bSwgZ3BhLCBlcnIpDQoNCi4uLiBzaG91bGQgd2UgZG8gc29tZXRoaW5nIGxp
a2U6DQoNCgkuaXNfcHJpdmF0ZSA9IHN0YXRpY19jYWxsKGt2bV94ODZfZmF1bHRfaXNfcHJpdmF0
ZSkodmNwdS0+a3ZtLCBncGEswqANCgkJCQkJCQkgICAgZXJyKTsNCg0KPw0KDQo+ICAgICB9Ow0K
PiANCj4gICAgIC4uLg0KPiAgIH0NCj4gDQo+IEFuZCB0aGVuIGFyY2gubW11X3ByaXZhdGVfZmF1
bHRfbWFzayBhbmQgYXJjaC5nZm5fc2hhcmVkX21hc2sgd291bGQgYmUNCj4gc2V0IHBlci1LVk0t
aW5zdGFuY2UsIGp1c3QgbGlrZSB0aGV5IGFyZSBub3cgd2l0aCBjdXJyZW50IFNOUCBhbmQgVERY
DQo+IHBhdGNoc2V0cywgc2luY2Ugc3R1ZmYgbGlrZSBLVk0gc2VsZi10ZXN0IHdvdWxkbid0IGJl
IHNldHRpbmcgdGhvc2UNCj4gbWFza3MsIHNvIGl0IG1ha2VzIHNlbnNlIHRvIGRvIGl0IHBlci1p
bnN0YW5jZSBpbiB0aGF0IHJlZ2FyZC4NCj4gDQo+IEJ1dCB0aGF0IHN0aWxsIGdldHMgYSBsaXR0
bGUgYXdrd2FyZCBmb3IgdGhlIEtWTSBzZWxmLXRlc3QgdXNlLWNhc2Ugd2hlcmUNCj4gLmlzX3By
aXZhdGUgc2hvdWxkIHNvcnQgb2YgYmUgaWdub3JlZCBpbiBmYXZvciBvZiB3aGF0ZXZlciB0aGUg
eGFycmF5DQo+IHJlcG9ydHMgdmlhIGt2bV9tZW1faXNfcHJpdmF0ZSgpLsKgDQo+IA0KDQpJIG11
c3QgaGF2ZSBtaXNzZWQgc29tZXRoaW5nLiAgV2h5IGRvZXMgS1ZNIHNlbGYtdGVzdCBoYXZlIGlt
cGFjdCB0byBob3cgZG9lcw0KS1ZNIGhhbmRsZXMgcHJpdmF0ZSBmYXVsdD8gDQoNCj4gSW4geW91
ciBNaXNjLiBzZXJpZXMgSSBiZWxpZXZlIHlvdQ0KPiBoYW5kbGVkIHRoaXMgYnkgaW50cm9kdWNp
bmcgYSBQRkVSUl9IQVNBVFRSX01BU0sgYml0IHNvIHdlIGNhbiBkZXRlcm1pbmUNCj4gd2hldGhl
ciBleGlzdGluZyB2YWx1ZSBvZiBmYXVsdC0+aXNfcHJpdmF0ZSBzaG91bGQgYmUNCj4gaWdub3Jl
ZC9vdmVyd3JpdHRlbiBvciBub3QuDQo+IA0KPiBTbyBtYXliZSBrdm1fZmF1bHRfaXNfcHJpdmF0
ZSgpIG5lZWRzIHRvIHJldHVybiBhbiBpbnRlZ2VyIHZhbHVlDQo+IGluc3RlYWQsIGxpa2U6DQo+
IA0KPiAgIGVudW0gew0KPiAgICAgS1ZNX0ZBVUxUX1ZNTV9ERUZJTkVELA0KPiAgICAgS1ZNX0ZB
VUxUX1NIQVJFRCwNCj4gICAgIEtWTV9GQVVMVF9QUklWQVRFLA0KPiAgIH0NCj4gDQo+ICAgYm9v
bCBrdm1fZmF1bHRfaXNfcHJpdmF0ZShrdm0sIGdwYSwgZXJyKQ0KPiAgIHsNCj4gICAgIC8qIFNF
Vi1TTlAgaGFuZGxpbmcgKi8NCj4gICAgIGlmIChrdm0tPmFyY2gubW11X3ByaXZhdGVfZmF1bHRf
bWFzaykNCj4gICAgICAgKGVyciAmIGFyY2gubW11X3ByaXZhdGVfZmF1bHRfbWFzaykgPyBLVk1f
RkFVTFRfUFJJVkFURSA6IEtWTV9GQVVMVF9TSEFSRUQNCj4gDQo+ICAgICAvKiBURFggaGFuZGxp
bmcgKi8NCj4gICAgIGlmIChrdm0tPmFyY2guZ2ZuX3NoYXJlZF9tYXNrKQ0KPiAgICAgICAoZ3Bh
ICYgYXJjaC5nZm5fc2hhcmVkX21hc2spID8gS1ZNX0ZBVUxUX1NIQVJFRCA6IEtWTV9GQVVMVF9Q
UklWQVRFDQo+IA0KPiAgICAgcmV0dXJuIEtWTV9GQVVMVF9WTU1fREVGSU5FRDsNCj4gICB9DQo+
IA0KPiBBbmQgdGhlbiBkb3duIGluIF9fa3ZtX2ZhdWx0aW5fcGZuKCkgd2UgZG86DQo+IA0KPiAg
IGlmIChmYXVsdC0+aXNfcHJpdmF0ZSA9PSBLVk1fRkFVTFRfVk1NX0RFRklORUQpDQo+ICAgICBm
YXVsdC0+aXNfcHJpdmF0ZSA9IGt2bV9tZW1faXNfcHJpdmF0ZSh2Y3B1LT5rdm0sIGZhdWx0LT5n
Zm4pOw0KPiAgIGVsc2UgaWYgKGZhdWx0LT5pc19wcml2YXRlICE9IGt2bV9tZW1faXNfcHJpdmF0
ZSh2Y3B1LT5rdm0sIGZhdWx0LT5nZm4pKQ0KPiAgICAgcmV0dXJuIGt2bV9kb19tZW1vcnlfZmF1
bHRfZXhpdCh2Y3B1LCBmYXVsdCk7DQo+IA0KPiAgIGlmIChmYXVsdC0+aXNfcHJpdmF0ZSkNCj4g
ICAgIHJldHVybiBrdm1fZmF1bHRpbl9wZm5fcHJpdmF0ZSh2Y3B1LCBmYXVsdCk7DQoNCg0KV2hh
dCBkb2VzIEtWTV9GQVVMVF9WTU1fREVGSU5FRCBtZWFuLCBleGFjdGx5Pw0KDQpTaG91bGRuJ3Qg
dGhlIGZhdWx0IHR5cGUgY29tZSBmcm9tIF9oYXJkd2FyZV8/DQo=
