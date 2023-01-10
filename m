Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 856E4663664
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 01:47:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235582AbjAJAro (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 19:47:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbjAJArm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 19:47:42 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FD96186E5;
        Mon,  9 Jan 2023 16:47:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673311662; x=1704847662;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ijOU5+1/u08b5p3jw6dlnlJP43/FH/VRsW/Yup/5uc8=;
  b=jfR00cnYoN4sWCTFSGipv98+v4P2+rHNnlqImpH2Cx54hh+5YFahuegp
   pGpHaZ1QoY7OwX5Y6XGwsAfvWtYq8RgmCQBfOmFwRXDDcLebK0cjAAsnz
   CCQAvs2oP17ZOi7UbBoRF/gTr5gnQS70inzUEaUFKPzas1L9I/s+sh33i
   UZB5Ah8TvaQKxdzxIvXxh9hYCCWDkNloyv4gh6UvBgokktYBDfcJBtgQ2
   8vEXasEZ/kq4zc4w876wl0YRjW6pozux4kEUMilRTR7Nma3sUVnoH8kFa
   JE/cNSZZvnqKF0KSVF5a5DhXrlfisAbsCZL9WR/XnRrK4YE3qyQNXqkzY
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="303386360"
X-IronPort-AV: E=Sophos;i="5.96,313,1665471600"; 
   d="scan'208";a="303386360"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2023 16:47:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="725362750"
X-IronPort-AV: E=Sophos;i="5.96,313,1665471600"; 
   d="scan'208";a="725362750"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 09 Jan 2023 16:47:40 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 9 Jan 2023 16:47:40 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 9 Jan 2023 16:47:40 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 9 Jan 2023 16:47:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AC/wXpNJjYrFvOwiFk68GpJXlc0aVi8N37IwwBWo+AhgBOdpoyB48iAwRkjBzImDW7T6Pxy1Wb2kJiX5ckRTxvVNVFpPGlu8k0LXMlUIvNtM2S+b7uv/EwRqYYVLcQeDpqyYizUxxPcXNCxQKtYSgI6fBjgGcx02T4/R+/CurDgO+MeFEvOlLcOKpZiQGpXD2GnE9cr2pMgGmjcFflpuEn0VIkQZjkPqlTzeVlnAU8T/tfqklQm5b0SXAzb2JhjlrcKllF6mQQNujTvKIFVa/Qd0hCUB+tn9vjE4WphkGDXEu5o34x8nIWIKMRKEOBedva4y0ljfSBeV8TVpKg7qRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ijOU5+1/u08b5p3jw6dlnlJP43/FH/VRsW/Yup/5uc8=;
 b=Hp8S5iCuE4CVvAiSsEn32O7JLbGD2obHRCkkw5rmsnKGqPFXx/0Djv4w1F1kJJf1VNGiWY+G3T/1IcaRl1Lh20eXlRnA/+HJeGB6oUSPTWwQd5lZvwjz+gccNF713vf2iUfYUBN/EC+4YPn7RxBfjwnce9tv4iAjGN6pU4eSS5QlkXbz15GeyM00rhb6qT1i6bXpGEfaf7nuRT9coIRV+AFBFOkOFrK/S06HTuS3p7fdVpUrmwlyPBNJe7ytpz33ummlaqicOYQhTfdm6COkMckV132BphUwTjLgVrMFuuiI1yCmOWuJWKyIt8ReuXOmlndDLIZWsErBZsZkbBniUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA2PR11MB5034.namprd11.prod.outlook.com (2603:10b6:806:f8::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Tue, 10 Jan
 2023 00:47:36 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5986.018; Tue, 10 Jan 2023
 00:47:36 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v8 10/16] x86/virt/tdx: Allocate and set up PAMTs for
 TDMRs
Thread-Topic: [PATCH v8 10/16] x86/virt/tdx: Allocate and set up PAMTs for
 TDMRs
Thread-Index: AQHZC5gV8r8yaJynIESTR6K7FpCOGa6SS+oAgAS3JwA=
Date:   Tue, 10 Jan 2023 00:47:35 +0000
Message-ID: <b1eab1ae93f0563ec79260a43c2690bc428691bf.camel@intel.com>
References: <cover.1670566861.git.kai.huang@intel.com>
         <76a17c574da18c10ad7a4f96e010697aaa5f7c04.1670566861.git.kai.huang@intel.com>
         <64381030-bdbd-bc98-45b3-e3d40132a309@intel.com>
In-Reply-To: <64381030-bdbd-bc98-45b3-e3d40132a309@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA2PR11MB5034:EE_
x-ms-office365-filtering-correlation-id: 9abf41ea-ed3f-478c-a961-08daf2a44431
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: p2v2uge8P3Nkb9Pa9OdPtUGodZYLDXYeYGlU1qUO9717N1+o+N43JPzaB1XTlEW58Qkkcu1M98/nZLv6kAbFYuzymGHJ2DzZzHMVTEkKJCmFmm+cXzyhn+tjNIFAlBRzIp6Kjf/ljN+hwUEMCol3CBbhRypEsQogKPPe5Feb57DSBn0fLPvAkuPvWVYyy/Vp2ncQdog1uGQYrcabWh9gJ5oPGMAOuLk3I9TytATKGGaLynHC7TMStvogjMG+l965uKIXPpsJGEZULW4Cqp8tO+dz8dRkcD/MgT1jd2dv4gdFwsbzgZxcWc8gqfBtWXKpKGj7EmH2flY62K0BngrqsTuzVlbJ2uDQnwBvBcH6Nc7EFhqmkcibAG1mjhjpr/hUs6aFyiQp/3hqv9O4S40qYYHI4hd2hiCelhDh3Nr0U9goo1fz91TK49rtFsrRimWqURWGknmQn0fglW1/MCtJZSUT75C3+kSYtWwLuhCh8gSqL/Xsapyp72IT3D4YeXyjQJwb6CaFj1m8Wqe5NvuFC4PJgvShQxH4rwAumjeQq68SJDVvsoxUaWFvxtcjOHD9Iqw8atbNqXeYery+GF79KFJBPEjp8fDg8vziWOrVphreo8ZS/RJ8uwPWJHiiDHR5pNqAbhtUPhs5h/4FREexu5c4lLVTY1FsRU00R4jcUPPrtM3/51lDX7H2nnSWpr17z7Ht1Ca7KI3edvcYTki9Bm3I/kRXDfaBuASUh0/e0vM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(376002)(39860400002)(346002)(396003)(451199015)(8676002)(7416002)(4744005)(71200400001)(316002)(5660300002)(26005)(6512007)(6486002)(478600001)(186003)(2616005)(41300700001)(66946007)(76116006)(4326008)(110136005)(66476007)(91956017)(64756008)(66556008)(54906003)(66446008)(8936002)(36756003)(38070700005)(86362001)(53546011)(6506007)(122000001)(82960400001)(38100700002)(2906002)(17423001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VUo0aFFuYTY5QWdhcXhFRjRxYmdWOHQ4aXNkb2xKU1JraG5ncVNObnM1bFA1?=
 =?utf-8?B?Wmc4b3VFSjJNeUk1VE9HcTZGbzZvSHkzRUVGTVI1KzJNcXY2VHRMemNEUDU1?=
 =?utf-8?B?UjZkNTJNNFNFTWM5ZXpoSHh5bmM1UTlRQURrWC9xbjhKVUdLS05WZm92TVIw?=
 =?utf-8?B?SmhRQW5nclJsbFhmdFlqMFhTYW1nUEQrWE9kTk8yN3NwbHkzaE5qMHp5M3Ro?=
 =?utf-8?B?bHV0cUxsK3F5YVhwcll5V2hRdWdZRDdFK2hod0dpc1ZLTU8yeWtHMWlybnky?=
 =?utf-8?B?ZDNwWEFzQTUxU0tVUDBKVFE1QmtNNVUzeUpKd2RsbG9hcWxiZFB3am1rZkJk?=
 =?utf-8?B?ZHVyNnNSYjdxQ0hKZVowRDdDQkZmK3pWZXpMb21OSDY0aFdZaHU5Zm5RR3lj?=
 =?utf-8?B?cmMrL1ZLS09rU1ZzRWo1L0hGYUtSSWVMR2ZEdGpsMk9ZM3YxTGRmakRsS1pl?=
 =?utf-8?B?bEFMV3E1dWl5KzdLQ2F4VTN0ZVJqZjBXSUh6bFpGSHZ2eStkVndFSnlFaDFC?=
 =?utf-8?B?UDdZL0VNUzk3ZHl6SjRITlhvYUpBZmticXFVMUxSWmZ6Q3E5WXYxa3NXUUlB?=
 =?utf-8?B?bWpkUXViSjJJK05tRk5jbDZMYlZHYkxsQm5DS1plc0V3Z1NDWGIrZytXNlJQ?=
 =?utf-8?B?WmV2bThYWjdCSjkydU4rT0VlNHZlQWhPaHBpaXVQU2hlb2tEMnplbnBjVVRo?=
 =?utf-8?B?NVZ1Ui9JMlNzczBKamZwWEpxUGJMUnRoVWkvNU13cDBxQnZHeFhNZjRDR3pn?=
 =?utf-8?B?LzVqdVBQVGpvM1Q5S2haYW9TcVdPelQ4QkFyVm80NCtVT0Y3UGVrY0hXTHEy?=
 =?utf-8?B?ZFJTMzhCRXFWV2l1RTQ2Y2pSV1VhS0Ezb2k2MFB3cTZyeVNlU05KaGM4UUdr?=
 =?utf-8?B?LzhvY3FaRERYUGwvWW15NkNLekZjV20rT3NhZlY5UXRQL1c2Mk9SRlRLRnJH?=
 =?utf-8?B?TnhPMlNQNnJ0dkNUd2VDNTJJdXQ0bmc2cnk2MTVubmkxc05OYkhUbXdidTlY?=
 =?utf-8?B?UDE0bGNTNXJxTUVHcFdpaExIWEIyOUREMStvWExVazVKemhiQ1FLaDl6djk2?=
 =?utf-8?B?K3FCWlJZTUYxTnF6RHkyazZ0UFJRRzBydTFmd2RMTEJDZk1ibi9adGhVOGNk?=
 =?utf-8?B?NVNPK2NPeHg2MFN5TlIybGYxTE9hQU9QaEt2cFdNbEdXQWMzWGpKMzBhNWVl?=
 =?utf-8?B?WVhHQ0NiTlJkNHcvczNCOE14YVgzdWZORDh3OXNhZE1rNFpRUDZ3Z3Uvaldz?=
 =?utf-8?B?UnpNYWg2dzgya25mR1Btc2ZzQVhNd3hQMzI4MUw0aG9XSGh2cE13eTJHaVFR?=
 =?utf-8?B?VmwzQWNDSXRNdWRmQWdZZmRSYkZhSGZQblNZRVJoWEVoVnNFeW9XQnFra3VN?=
 =?utf-8?B?cTRIQ3VpbkZMUU8vU2dSS1B3VWZXNXJ1V3R4YXQ3Q1RNOWkrN0VaWjc2ZnRa?=
 =?utf-8?B?Smw0ci9lZWpNZHRIV01pS1RtbDhNWld0WXgvRTdwQmpzYmM5Z0p1aDRIQkRP?=
 =?utf-8?B?ZExma1Jrd3FnRUN3YmxabU51MVVPUms4NjMwTW9kN0J5OTZEbXA4bFlaVjVG?=
 =?utf-8?B?UzVYcWFPLzBjdEpNcm1aeHllMmI2S21EYlM1cXJEVGJ2alcxRW1HbkVrdU1s?=
 =?utf-8?B?QzFOZE81Zm9IWXgrcjh0Q0tTREFSdWlLUDgyZHVnQUFEamNPb2J2eWorRXp2?=
 =?utf-8?B?ZW5vcU9Mem96R1VpUWhBaUhsRlIxUy83ZHZzT0phZVEzRkpkUlFCMGh2VEp3?=
 =?utf-8?B?ZHBzSzIwZkRwcnovM1IwY1AzYlNzLzI5ZzZKY0V3R1NncjQzMU5OdWNLTWxj?=
 =?utf-8?B?aTNDTXovR0hDVzRpK3I0bzlEM2RGU3psOEdmVStmWmxzdWNuTlhkNTF3bGdn?=
 =?utf-8?B?RjBJYnN1eDFodWJsbDVwOGErNDRpRjFlM28rTEUwbHFYaFlZS1h2MUJxazAy?=
 =?utf-8?B?bjB5TlBJbmp3amk3TEp3d3gzY3ZZSVBxK2o4azNxdGZXak5menVGd0x5YjNw?=
 =?utf-8?B?aHZ0VlEzWUhTOTVnRFhQZ0lZU094WkJJWkJUQno3MjFMVHQ5MzQ1TkJYeHhV?=
 =?utf-8?B?V1d3MmdPdEpWTTEvemlwMnRMSFEwN3RETWJEZFR5VHRkamhQNmhXbkVhWGIz?=
 =?utf-8?B?R3kxN3h3UFA2alRrMndneDBVQTNnNzVtZ1ZWazJvTHcyRTNscUxHcDlzbkdU?=
 =?utf-8?B?K1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D276DAAA745A0948BA134F369CD1C997@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9abf41ea-ed3f-478c-a961-08daf2a44431
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2023 00:47:35.8372
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0nvh3pmMdbxu3Qjs3QPwVFWpt/+A0E2Whm0SL+EPsgOTlRJocCafYAyZ4GKI1pjvOPsvmpI0aM6dvurc0KUhiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5034
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIzLTAxLTA2IGF0IDE2OjQ3IC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMTIvOC8yMiAyMjo1MiwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IEBAIC01NzQsNiArNzc0LDEx
IEBAIHN0YXRpYyBpbnQgaW5pdF90ZHhfbW9kdWxlKHZvaWQpDQo+ID4gIAkgKiAgUmV0dXJuIGVy
cm9yIGJlZm9yZSBhbGwgc3RlcHMgYXJlIGRvbmUuDQo+ID4gIAkgKi8NCj4gPiAgCXJldCA9IC1F
SU5WQUw7DQo+ID4gKwlpZiAocmV0KQ0KPiA+ICsJCXRkbXJzX2ZyZWVfcGFtdF9hbGwoJnRkbXJf
bGlzdCk7DQo+ID4gKwllbHNlDQo+ID4gKwkJcHJfaW5mbygiJWx1IHBhZ2VzIGFsbG9jYXRlZCBm
b3IgUEFNVC5cbiIsDQo+ID4gKwkJCQl0ZG1yc19jb3VudF9wYW10X3BhZ2VzKCZ0ZG1yX2xpc3Qp
KTsNCj4gDQo+IENvdWxkIHlvdSBwbGVhc2UgY29udmVydCB0aGlzIHRvIG1lZ2FieXRlcyBvciBr
aWxvYnl0ZXM/ICBkbWVzZyBpcyBmb3INCj4gaHVtYW5zIGFuZCBodW1hbnMgZG9uJ3QgZ2VuZXJh
bGx5IGtub3cgaG93IGxhcmdlIHRoZWlyIHN5c3RlbXMgb3IgRElNTXMNCj4gYXJlIGluIHBhZ2Vz
IHdpdGhvdXQgbG9va2luZyBvciBncmFiYmluZyBhIGNhbGN1bGF0b3IuDQoNCldpbGwgY29udmVy
dCB0byBwcmludCBvdXQga2lsb2J5dGVzLg0K
