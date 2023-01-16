Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 617C766BCE7
	for <lists+kvm@lfdr.de>; Mon, 16 Jan 2023 12:29:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbjAPL34 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Jan 2023 06:29:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbjAPL3c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Jan 2023 06:29:32 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D48F1F4A7;
        Mon, 16 Jan 2023 03:29:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673868571; x=1705404571;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=mBi/rCCy0HIvyNINUuxP8jeFcij6h2JmJtyeGNsukOs=;
  b=BMCUcaSHj/VWJrO+bJwyzddYwJ/Q9nMk92cZNYQPj/U9Cnhdc71ig6jx
   N0ZdoqMOyRoI4c/UFFI8qoEHH+JvVvDuSEMqgxaTf3cWl8Z9Eq2t2djtH
   2MxNIZZgYjhoXOTR3pB+VhQUaOfoLmFEGxSv1a6eohcVURO4bOB8yVxUL
   9wecADBgQPka86wYfNNlBgy9qQYSEd4fZChS9f8RllUGgEglzxf+y+42i
   q3z8ZsF8x8/VK/Nl5ziZlslhsq7a4UtxLF8EP6zZ6OSg9B2vxQ2rWSpgV
   99s4GWBrGoWvVjVZl0Yhduv2x8A85R7t5k6NXs9huT/rEz7mQK1Umj3ql
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10591"; a="410690226"
X-IronPort-AV: E=Sophos;i="5.97,220,1669104000"; 
   d="scan'208";a="410690226"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2023 03:29:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10591"; a="652235531"
X-IronPort-AV: E=Sophos;i="5.97,220,1669104000"; 
   d="scan'208";a="652235531"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga007.jf.intel.com with ESMTP; 16 Jan 2023 03:29:30 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 16 Jan 2023 03:29:29 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 16 Jan 2023 03:29:29 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 16 Jan 2023 03:29:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h1tRw6C5HiKChATVFtsHuWcqg4fHCzPKSVtDzPNDd1gZEoaYpg58vgkv6mPHOVU7M/y1iYz8R2RX0q9u/ZQsrY6nK8f0O5vhB2zvM4jtVDvPdDLD1wxUgzvRFxPrtBslik+XtX48myYaAZ5V9ij5MxK4LXJlU+6eIi0shWcEauv7u/vWxnzEgM7RC1FiEdsQR1QEEhgwy7ChseMlhfddQcjGVLzECnrKbpxTm68Y1bevfriiTSyBlpDB8925JLYfaIUJMWZUWiJofhCHn+IBow6O31SOcD3DcNm7pOl3aATwPPYl2ajF/ZzRYwfmS6ged+Gtu2WTYoW0ipAK/mEPDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mBi/rCCy0HIvyNINUuxP8jeFcij6h2JmJtyeGNsukOs=;
 b=odtUNNxtVu07wRE0ZwupCrCIpcAAxWzetnNzfpZs9pMSpO8rCgvxVEtNQa5nC9EHjqpdFEx4U/Alho8oiLiI9Oa+LFzoxoKQ6px7sDmd1aPeHwPkuvaK544P+1K2X+d41fdJUWynMDz9TzSXMrg8VynLmP0ikB/oiMrXM1RaiHgKMxqdfqHg539uakCaNEvQ0syR6uLH8x6ofxSythahxneEc3tmzlWc70lFjb54zMtAlsm8SpYqiekVXVEO2zjjnKwqJ8kgxi+tcYeuQ/8aATPvT2VLmHnJtV+ekzeQWnIzJiFECBWDaOV9/B6kHpMcHPYbNmSmBZl7zRltyp1fGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH0PR11MB7424.namprd11.prod.outlook.com (2603:10b6:510:287::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Mon, 16 Jan
 2023 11:29:26 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a%6]) with mapi id 15.20.5986.019; Mon, 16 Jan 2023
 11:29:26 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC:     "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v11 035/113] KVM: x86/mmu: Allow per-VM override of the
 TDP max page level
Thread-Topic: [PATCH v11 035/113] KVM: x86/mmu: Allow per-VM override of the
 TDP max page level
Thread-Index: AQHZJqVxPoq1Vy8PcEKdLN6vJzLTSK6g7kOA
Date:   Mon, 16 Jan 2023 11:29:25 +0000
Message-ID: <177e69ec580607b1a5fa6e64d7472fe1ecb7e714.camel@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
         <c0e874de58d172d490a565a9ec7b3361bcc74907.1673539699.git.isaku.yamahata@intel.com>
In-Reply-To: <c0e874de58d172d490a565a9ec7b3361bcc74907.1673539699.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH0PR11MB7424:EE_
x-ms-office365-filtering-correlation-id: fd6bbfb7-47e2-41bf-2843-08daf7b4ec85
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aJCuNz1MBX0T2NsELOUsGtLjnPHfKz5a1+S8OWUSwC0YsvHg1FNDn35nQWM2Yjwc/G3MpIhAxKtSqVe3+S9h9j2LYzhhq1dtAhwh57LHBYTU6fupmwPkSieH50BcLdtWNdJ7nyShhKeWeGpyE60btaOqT7iRhgC5KlhWBMGDi6UYi1DIGd8PLsFXwrk51wmPRZpYuGXri+orhO0l/K+n6pQ0/lwlApB3UG1dBV3Hzp0EU5EN6Fhyzg0+xKheYPC59tEID9+YVBOOK3qTpsAFu98rfFIC6ro3yecAAWsVyICAoeFV166jjp1JEUuLa/ysL+nsHMcxZWv36c+n578XylTbINYisZkUL25tfX2vporujVLfqR+jeW8Rj19kbB0S/g+EqNZM+T5pouVAZaD1FR18N5pU8TtfUSulBAMbEjOdljGqA7umxmw7stVZdN9xUNDzx6a3mvJYmN0BBqLLi+n/refYP09h8qsL/OxyH6WfGivF5ilYi91QMOQZY84fOHHlskPswswme5CXHzZW61aJW3q5ba/SGp5iPCrUrSw+2EIMISIEbHEyjfgU9Ie54evpPPLCIrLN8qJek4DISU8+5bsMu4H5VIfLVW7TFldTPZMStw4ZnABnvK+YnTEcArX0bAbdrsCpbD+Z+XVc3OPzvW4jzNyV1031xQU+WoTi0fFv3BHFEjWau9pUULDXVC6TuQyJ46zexG9Cue+Wsg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(346002)(136003)(366004)(396003)(451199015)(110136005)(2906002)(5660300002)(4744005)(54906003)(6636002)(316002)(36756003)(2616005)(38100700002)(122000001)(71200400001)(26005)(86362001)(186003)(6506007)(82960400001)(6486002)(6512007)(478600001)(8936002)(66476007)(91956017)(64756008)(66446008)(66946007)(38070700005)(4326008)(66556008)(8676002)(76116006)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bS8wZTVuRWZJd245ZDNnODNaWjYwOW1nVkxnNjdsMXpTVlFPcThnUThQS3Vr?=
 =?utf-8?B?RERTRTc0bDMzTTRmTkxBWnRQaUJYQk1IVUo4MjIzTElaWVpvU3Z4ZGxxL3Zk?=
 =?utf-8?B?QWE0U1Rid0hTTVUwMzZwZ0JNODhWR0o4YTFVaWhzYVA2NU93VjE4VlJwamx1?=
 =?utf-8?B?eVp2NWk2aC9jQjltaHdUeFJJYlVvalZHRlYxdTJMQnJlQzhQMUNma0Zoenc0?=
 =?utf-8?B?Qmcya2hua1hOSE96QTUzbEEvT2hFOUU3MzZwQytPaU1yMGU4YmdPbmkxM1RN?=
 =?utf-8?B?Ky9SMkI0ejFhOU4wZ2VuZ2FZNDJMN1NIbEhwSHNKVkF4a3hwck9nUm5jVnJ4?=
 =?utf-8?B?clUxbUdiZ2QwQ3NHQVNOekZHb3BEQW4rdEJzYTI3L25jUFh3SnI4bk05MGEr?=
 =?utf-8?B?VGtzUkU1Y3dvd2RpMTN5Zy80UkxWNFljNzNxM0dhYjhac0didzVsc3pCYWlH?=
 =?utf-8?B?T0t3ZW9xazdqNzZhZkVCRVhKSHNjNm0xVm1jR2ZGRXVSbVUrakRRWGVMT1ZD?=
 =?utf-8?B?UWRBSlpvYlNOcTIyalcxVDlmL3d3MTMzNTdzL2ZrYWFOSHVjWSt5OVR4UFFn?=
 =?utf-8?B?ZmNpWVlrZmxBdGNHaFFwZUdRR3VOQ0dSczlJTW5ERVo0QnVCRlM2eWcyNmd4?=
 =?utf-8?B?d1UxOFI3V0FmRTdJZjFLZUNDbVIraW8zeStkU2M2VG9uS2ZGMUNOS1FCbWxy?=
 =?utf-8?B?MGFYMUF4d2ZNM3ZKRlVLaEJlc3BSdXpucG02emtpejNPZVdTSFVpdTRCV0sw?=
 =?utf-8?B?Skh3RGs2K3p3S21DNjIrY0l1d21vdmtzbDAzQzB2V1ZyNUd6N1hiYkgreTV3?=
 =?utf-8?B?WVFLdms0RTZzTmw4ZUVEZnFwR0d2Z2JucDhpSFJHWkZtaHBSb2RPY253S0xK?=
 =?utf-8?B?SmNTdXUzNFJPdnF4N0NXN0RabzJia0c3eFV3STcweGFodDFtcFdDMmpraTJN?=
 =?utf-8?B?TjZjSDNza1p0RnNvMEdSd2IxT05DTUgxWUlwNS9Cc2t0MDd6dmt1SVIzUENj?=
 =?utf-8?B?emprWU5GS0tHeEwybkpHRDg4NzN1cWhmSVJMczl6MVlibUc0cFZOeElZNzBn?=
 =?utf-8?B?UGFBWDRLdkRnaVh0RnYrY0k4QU1TejJQT1VtTHZINGdNY0R4RnFmQ0NtM1FD?=
 =?utf-8?B?dk9BTzg1dXZ3b3ovS1dLam1pSHA1c01XRnBKWGlLTld5K1pLTm9STVZ4YVdZ?=
 =?utf-8?B?bmliQ0RKcjRONEVmempKU3ZOd0IyMHlQaDBKc3lDbHZ5YVZLSWNyM2xReHZp?=
 =?utf-8?B?dnFxckl6bUZtQ0NYQkZya3hQUEFpWE4yNCs3OCtQZXdpYjdnL1lZZ1ZWWXpT?=
 =?utf-8?B?aG95ZFdHRTFVTlZMRXhWNklqVTRqaC84eEtmUmNpZklSZEhhZVFEdmtLS2ZB?=
 =?utf-8?B?Z1IveWRsbjVycTlrMEZNS3VuQURwNjA2QzVCZTA3bGpTL3RRKzBaRVI0VEZ5?=
 =?utf-8?B?UmlQd2RsVk9hU1lWZytPQVBEa051aGpqOVR1VEp5TVhjd1NHaEpUTG5STW9M?=
 =?utf-8?B?eE5yeTFSUmFoblovdzI1LzhXU2N1TGh6TDNRbkgxVmZBZ3ZGQ1RmQ0VTcFNm?=
 =?utf-8?B?TWRJOTgzQmhrb3Q4SUQzZGtKUXZHVTBJaVlqVk5SRTQyUjJRN3hsWVh2akUv?=
 =?utf-8?B?Kzdoc0lVcTVKRzRjd0t4cUJBMGpyV3A3aW5CbHp0dVpVRWNRemI0MEx3MnlG?=
 =?utf-8?B?M2xWQ2I1dlhJWEo2TCtxcHZvMXRDSFc3dUIxSFZjTWRIL2V4c2dmRFFzbGRU?=
 =?utf-8?B?eW9xOUpiRDlucllYQVRIVjA0aDhtd29uUEZiU2w2SzFlZ2dLWmZTOTBzRFF5?=
 =?utf-8?B?Vit0MXZ2azJDcGZYYXpXWmNPRE41SFlLbzZqNndpcUJDcXNTVmppSjJlZG9D?=
 =?utf-8?B?eUcwZkNqaGgwT1FZdDBwNSsxaVcvcWpNTktQejVZcW1Ya2hXUkFoY3R0anhk?=
 =?utf-8?B?a21YSzdLZFFycElyNFJkL25QUDg5ajFielZ5NkE5V1lWdUloVHdDd3RTK1Ur?=
 =?utf-8?B?Umhma21WQlExclNZdFV3NVFqcFoyTzhtOEdRcWdkb0NvcnlCTlpNenBpZUFM?=
 =?utf-8?B?OWllTzZmL0g3QWFRTUF4R1lMYm5seVQrZTZwRVVIb2VkdlBtQWVObGtHR1Zq?=
 =?utf-8?B?QmIrM1JNM2MyeGNZbG1HS25pSDQ2cnVQK1ZnQnB3VXBvU3BTZ1RMMzdzZWlv?=
 =?utf-8?B?SVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A3A01E8F799A344CB2B1F4C3CFD3FA3A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd6bbfb7-47e2-41bf-2843-08daf7b4ec85
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2023 11:29:26.0045
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EYGHsclxJTS49aumW6HX7IvaZsZwLDy+DBSYkJEmBRaChNmy62JG5pOJiqHVH2yk3v6W+mD2N5FCYLmDYH56nQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7424
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIzLTAxLTEyIGF0IDA4OjMxIC0wODAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20gd3JvdGU6DQo+IEZyb206IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW4uai5jaHJpc3RvcGhl
cnNvbkBpbnRlbC5jb20+DQo+IA0KPiBURFggcmVxdWlyZXMgc3BlY2lhbCBoYW5kbGluZyB0byBz
dXBwb3J0IGxhcmdlIHByaXZhdGUgcGFnZS4gIEZvcg0KPiBzaW1wbGljaXR5LCBvbmx5IHN1cHBv
cnQgNEsgcGFnZSBmb3IgVEQgZ3Vlc3QgZm9yIG5vdy4gIEFkZCBwZXItVk0gbWF4aW11bQ0KPiBw
YWdlIGxldmVsIHN1cHBvcnQgdG8gc3VwcG9ydCBkaWZmZXJlbnQgbWF4aW11bSBwYWdlIHNpemVz
IGZvciBURCBndWVzdCBhbmQNCj4gY29udmVudGlvbmFsIFZNWCBndWVzdC4NCj4gDQo+IFNpZ25l
ZC1vZmYtYnk6IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW4uai5jaHJpc3RvcGhlcnNvbkBpbnRl
bC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IElzYWt1IFlhbWFoYXRhIDxpc2FrdS55YW1haGF0YUBp
bnRlbC5jb20+DQoNCkFja2VkLWJ5OiBLYWkgSHVhbmcgPGthaS5odWFuZ0BpbnRlbC5jb20+DQo=
