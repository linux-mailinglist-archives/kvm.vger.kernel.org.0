Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F07A06EF065
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 10:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239645AbjDZInm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 04:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239552AbjDZInk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 04:43:40 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C6FABF
        for <kvm@vger.kernel.org>; Wed, 26 Apr 2023 01:43:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682498619; x=1714034619;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=5icH05dhhtdD0gvWRK1MksGWlhydvx/mlnMgU/7FPK8=;
  b=j8aU3ryHL3L0jb4FWj1AS+/1/7WgxxsIUlu5d+Bp5XSIsHTISj1LWMEF
   SrFuo/OrjUX8w0PbjvHUHNbfIE2K8QcCea2gPDpjSc2IeHseJsAgThH2L
   u8MKuR8GqBmHHlSNetrVT8TnqjFdv4HolyuQ3HAhWe5v1WxNVpaV2DtZ2
   M3Fhzj/PkUx9D9iiqglZT7XTtlpvCFQzl/pRrikqGDbkt9aSDixRup2Sd
   qkxdFg20wjZ4r/Y17vIn5HvFNnhbQ9kp0f7MHD6C7xu+Qj3PF0KK1FUYZ
   gGzrGjwzFhOmuyAQv0VAa6FD9wzP8PyiLr7IX+uKaTn0YBGFWYxbyTCdI
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10691"; a="412353085"
X-IronPort-AV: E=Sophos;i="5.99,227,1677571200"; 
   d="scan'208";a="412353085"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2023 01:43:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10691"; a="724359556"
X-IronPort-AV: E=Sophos;i="5.99,227,1677571200"; 
   d="scan'208";a="724359556"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP; 26 Apr 2023 01:43:38 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 26 Apr 2023 01:43:38 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 26 Apr 2023 01:43:38 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.176)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 26 Apr 2023 01:43:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GwlMkJ+GC76FGCYosBHkgab1CPyJry6RTKmpYLJcU0X6au4bNhk8bT1GEyVbX+mHzz3gyQ6uyb+5OjI1xYNPng9BJCCWfJ50aY0CfFVcxvffiDYTI/6A3arsdG5UvfQ37XJsaoMjQp8A+HdXetmn2QgvSPpx22RyQNIOOssHzrMIu6p2h2QlQDX/1/lsZIGu71HLbmqLDzh/n5AC9Ve0RYvykp7YAR7X8dLO0ZjsR1iBsefy4zBPGsIzlxBYmVhUrUZD+VQbWxFcwZdXaF25yDNnQzTfMXP6vBJdlWwysLaIxRuCkeZ01Dzzod3U2cQgM8Z73ZZjiOjr4oUui5EdWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5icH05dhhtdD0gvWRK1MksGWlhydvx/mlnMgU/7FPK8=;
 b=nICY84c0Sy+IeqyJEcxkJq345UCDIQBeuCEIXGi5eKCLYaZbg7TfLyxooa6rsqjfoLXEGltgFJEhEjFPXqClmPKOBeKT6BRusnqvsz6/z7eRMtfwkmkfxI/SWqoeqq/hr7xYoZGrGtym0iOhm1Z/YaGAlQTfV5Nz+EWbj1uiUiMxZRsyfsJJAzvixyFCRP68kGBZbxe1qTeilXb1PL80E9EGdafKCpqhVJiRuXKSNSJO3NP//uQ89UHEZd/iAj2izzAI6qFkcPC0tpspDfLtHLt0Vr/T2FzvqVcUgLE9wr6/TX4EPxiEOkd4XMKrF811v+9jOvAyvOWB5iqBrIfBlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA1PR11MB6565.namprd11.prod.outlook.com (2603:10b6:806:250::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Wed, 26 Apr
 2023 08:43:36 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2%5]) with mapi id 15.20.6319.034; Wed, 26 Apr 2023
 08:43:36 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Gao, Chao" <chao.gao@intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
        "Guo, Xuelian" <xuelian.guo@intel.com>
Subject: Re: [PATCH v7 2/5] KVM: x86: Virtualize CR3.LAM_{U48,U57}
Thread-Topic: [PATCH v7 2/5] KVM: x86: Virtualize CR3.LAM_{U48,U57}
Thread-Index: AQHZZva2XlM7fnwAvESmPCLhodGl668nnluAgADkdoCAAA4jgIAAJr0AgABKcWCADGbRAIAAVjKAgAEJCwCABfnwAIAAR8SAgABejIA=
Date:   Wed, 26 Apr 2023 08:43:35 +0000
Message-ID: <b7d4d662d82ad1503d971a8716ff11edbfd33b14.camel@intel.com>
References: <20230404130923.27749-3-binbin.wu@linux.intel.com>
         <9c99eceaddccbcd72c5108f72609d0f995a0606c.camel@intel.com>
         <497514ed-db46-16b9-ca66-04985a687f2b@linux.intel.com>
         <7b296e6686bba77f81d1d8c9eaceb84bd0ef0338.camel@intel.com>
         <cc265df1-d4fc-0eb7-f6e8-494e98ece2d9@linux.intel.com>
         <BL1PR11MB5978D1FA3B572A119F5EF3A9F7989@BL1PR11MB5978.namprd11.prod.outlook.com>
         <5e229834-3e55-a580-d9f6-a5ffe971c567@linux.intel.com>
         <7895c517a84300f903cb04fbf2f05c4b8e518c91.camel@intel.com>
         <612345f3-74b8-d4bc-b87d-d74c8d0aedd1@linux.intel.com>
         <14e019dff4537cfcffe522750a10778b4e0f1690.camel@intel.com>
         <ZEiU5Rln4uztr1bz@chao-email>
In-Reply-To: <ZEiU5Rln4uztr1bz@chao-email>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA1PR11MB6565:EE_
x-ms-office365-filtering-correlation-id: 0e4baa96-ec97-40a5-fb46-08db4632530b
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LIj+TLPi0CXWHadIfLdQw6cCbLy4leUa9cNpvPwlGU+nZ3XTMqb59oJjGNGt0LW3Q/YuBQG1reWxhbqqhoUeMPcxk5rvX8Bs4goYiM3v0ijIHXEfzKAa6Fkz22UZeDTGWbmuaZxQeyxWzKOoDi6RZOKrae/WuM55K2OaHa0tMEy/SCup5yPIYi6TjpG5nL4pZl8BrFmcXMlTfkt0sFfh49FtsYpd4iurKXmaQ2/ON3poGiKpnrFyCLJctvsCxXI9pBITSFbiIlJUJ8Dgp1XNEANdUAbJYK/J0L1ESuIsAw5cQz5EvAK1TPkE0K7ChwkoN6MBz3U/8FgrNdPgjAzyAihvc9tF4xV1VBh5ljMO1cC38Z9H3TCqwedY5N48LWIEr4S93mU8zylWnER0pbuGxLWteYO7fOobBGs74rgbTLtethANNvIyMJa9k2eTd0+1Lz4G0ulkziWdFzoRhYxuSA6YPkTWKfeOyEfFfgzIyT+KUK7OCjOxEWw18Ft6SmIN8U5wdYG7ZpOjjCE3BG3kLjy1G2Ecj5/hlR7a3t0C+2sVx2sPDZ6fmtF5X6HthhJ6e729VxvJxaShp4/rYZUe7O5U9QMygyYlIusozuuybpeKHncfcAEFf7r1VxyItB3U
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(136003)(346002)(376002)(366004)(451199021)(76116006)(91956017)(83380400001)(66946007)(4326008)(2906002)(6506007)(6512007)(26005)(82960400001)(316002)(66556008)(64756008)(66446008)(66476007)(71200400001)(2616005)(6862004)(122000001)(8676002)(38100700002)(41300700001)(5660300002)(8936002)(38070700005)(37006003)(6636002)(54906003)(86362001)(478600001)(36756003)(186003)(6486002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TWYzWG96Tk1oVFFGV01maHpldThSRzFXbS8wY2g1SzNXWjdDeHowVmMySHhU?=
 =?utf-8?B?YVk3NDRNWGdyTXRLemVGeGp4dm5mMENxNzN2MEVMNXFTaHhtMkJxb2N1TmFz?=
 =?utf-8?B?SmlUVlJwalRpOTM3WHBlRFh0bFUwbmR1R0k1Q0hzd0MwTndaM3M2UzlNc3Vs?=
 =?utf-8?B?OUp1ZmFhaE0ycysxMklBdElqU0dDNVBydTREbmVDVjVpdTRJNzBXSy82aThu?=
 =?utf-8?B?bnJ4elBIdUU5QS9TZVdVV2dKMGpPWmFvcE5NeTJpSVNuQ1RkNFdUT2pGQTVM?=
 =?utf-8?B?VHg3TmM1UjIrYUJBdUl2YUZaYnd6NlByQS9mamZOeG0yMzVKNlFVcDRJd1k1?=
 =?utf-8?B?dm90YloxcGJzUzYzdDQyc3E0aktZdm9wK1VYV2RpVURJbnp3a1NzendoVFpH?=
 =?utf-8?B?SG1tK1d3eTZXaWQ3cnBlaXlGZitDN1ZUSm1NNjBtalNMbmIzbkFCYW9US0th?=
 =?utf-8?B?SlFzQlYxcHVYdFBHZ2VGcDBWY25yZmh2WmNETnUvQUtVZHpCbmFuRUlwMmk4?=
 =?utf-8?B?cWUwQlF2ak9iV0ZMUms2ckVhWHplNW9oaXJNczEvYmYzZkdNVWJOYm5EK3Yz?=
 =?utf-8?B?RlJqYjlQRGNvYkxBRE9UUUtLMEJ1MjBEd2xKZDdxeEV3dXdERkU5cUQrWmNt?=
 =?utf-8?B?UUZtK3dkTmpmSkpCb1hwUFZrNUptdFNtQzFOVXNCcDJON2VjaGtRbkxBMFV4?=
 =?utf-8?B?Y2ozZkw2YTluZFVWOCtORzA0b0haRmlPMngrY3ZRUEFKbHAvdDVwKzFUcDdQ?=
 =?utf-8?B?b2VTYVU4djVxZ2N0K1BFLzRaeTFIalpraTMydXhZSVBGT0JQOCtoOEhTaFZp?=
 =?utf-8?B?US9EYkZrYjloaHZtTllXVkxPNVRNRGdOcldibVNVZlc4eWVDdWtqMStaWHV6?=
 =?utf-8?B?cWttUmYvL1VHYklCR3NqMDBZeWFiT01OT1IzWWRSeTdlVGZaUFJpZnZXUW5v?=
 =?utf-8?B?QVhEOHZjdGp0QVQwV090MkdoZU1CQkhpU1lXeUpmaGQvWEJOWE9FT2RxRFN5?=
 =?utf-8?B?OFlZMEJnQVpFbU1zL2R5QmQ0V1YwTjNCWlFORi90Qm5FMFBwRjVIL3JkK1Qy?=
 =?utf-8?B?cHdwLzY2U04yNUtjN3JYTGtqV0ZaQlltOENkODBHcE5EeEJIeUtYR0p3aWJC?=
 =?utf-8?B?aCttNzNHdTdhL3RNRGZGVU5RSGU4Tkt3V1RUODVnMGo2bVlBUWIzWWlCV0c2?=
 =?utf-8?B?cU53c3lyMGNwV3VYSUlxYlJZRHFtcE5JL0tEcHBRV0oyWFM3V01oU202OENr?=
 =?utf-8?B?cWhmRC9HOVFWQlFKZTdwQ0EydFY3azNFNlpFU1lCWHR2SWlycW1FMFRrVzNL?=
 =?utf-8?B?a3hLSGRzSmpleTdzbUdQcHR3TmdQaHdTWERGM3RMc0hET0F6eFBWL1E1VjB3?=
 =?utf-8?B?SU5UWU1TRnhsUlBsNis1bjJnalllbzZtM05QU3MyN1lMa3ROdnhERFJ0cktV?=
 =?utf-8?B?SkdHRGFnM21hTnh6T1N1K29mbzZpN2R1N0FqOUNBck1icW9rekNROWZLMjJp?=
 =?utf-8?B?SmNOUnRoUlJyZTZwQ1kyQ2N6TUNEZXpSejgzejFCcFdtYk9BMDREVkRhVk8v?=
 =?utf-8?B?OVlYV1ZQeTZCNXNMSm1SK3ZRYVZkUHp1UmM3eXlYeC9KM2UvQ2c5VkcwREJi?=
 =?utf-8?B?c0VVUXkyQ0ZMdSswS1lSY1p5N0V5RmlyVUxjUGNrZHUwZGRrQ3E2T2s4ZkZD?=
 =?utf-8?B?R3J5ZFN3TTlGRmtRVWlRQzdLWnQ5RzN0K1JqL09aVkVKS24reVdLaWRqK3R3?=
 =?utf-8?B?SHA0Vk5LL3dlTGdZQUNQSm5YTTBqL3JZM05PSTdUWnYzUGhyQW5CdnhNK0xR?=
 =?utf-8?B?dzQ0RXRLQlpkV3NkNHpVTGQvcGVwQzdLWFhubzI1TXBaZ1M0aVNxamFGYkUw?=
 =?utf-8?B?RTliYVFtZ0VINklIMkp2dWVjV095amtCcWlEWkRKZDA2NzA4R2d5Z0p3Q3V5?=
 =?utf-8?B?ajZFazlTcEFFR1dKRERrSDhxNjlUR3ZMWEVlc0pCMlpDQ0ZLczExK05GYkRa?=
 =?utf-8?B?ajd2VDBmNWtGMGRvQjlBME85ekVEUlpRSXRmQ2ZLWUNDaDQ4dVBKazdMK3ps?=
 =?utf-8?B?eDdxWHlER3lIbUVYNXl1NUp0SnJ1ZkRKNW5iSzB5bVRtWWVRVnBqY0c1OUdo?=
 =?utf-8?Q?v25KvO4KuUChBqoGYzLl5FI6M?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6CFDFC00F2158C40AA33BDD59169ABC0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e4baa96-ec97-40a5-fb46-08db4632530b
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Apr 2023 08:43:35.8116
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M2mCmR6gSSCoqlwEmgSZHE5E25r5vh33fydwiVrwq4nTzKFHF49LLEWYXl6KgY8e4yUCQZdGMLiRbXFIbZ4Ypg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6565
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIzLTA0LTI2IGF0IDExOjA1ICswODAwLCBHYW8sIENoYW8gd3JvdGU6DQo+IE9u
IFdlZCwgQXByIDI2LCAyMDIzIGF0IDA2OjQ4OjIxQU0gKzA4MDAsIEh1YW5nLCBLYWkgd3JvdGU6
DQo+ID4gLi4uIHdoZW4gRVBUIGlzIG9uLCBhcyB5b3UgbWVudGlvbmVkIGd1ZXN0IGNhbiB1cGRh
dGUgQ1IzIHcvbyBjYXVzaW5nIFZNRVhJVCB0bw0KPiA+IEtWTS4NCj4gPiANCj4gPiBJcyB0aGVy
ZSBhbnkgZ2xvYmFsIGVuYWJsaW5nIGJpdCBpbiBhbnkgb2YgQ1IgdG8gdHVybiBvbi9vZmYgTEFN
IGdsb2JhbGx5PyAgSXQNCj4gPiBzZWVtcyB0aGVyZSBpc24ndCBiZWNhdXNlIEFGQUlDVCB0aGUg
Yml0cyBpbiBDUjQgYXJlIHVzZWQgdG8gY29udHJvbCBzdXBlciBtb2RlDQo+ID4gbGluZWFyIGFk
ZHJlc3MgYnV0IG5vdCBMQU0gaW4gZ2xvYmFsPw0KPiANCj4gUmlnaHQuDQo+IA0KPiA+IA0KPiA+
IFNvIGlmIGl0IGlzIHRydWUsIHRoZW4gaXQgYXBwZWFycyBoYXJkd2FyZSBkZXBlbmRzIG9uIENQ
VUlEIHB1cmVseSB0byBkZWNpZGUNCj4gPiB3aGV0aGVyIHRvIHBlcmZvcm0gTEFNIG9yIG5vdC4N
Cj4gPiANCj4gPiBXaGljaCBtZWFucywgSUlSQywgd2hlbiBFUFQgaXMgb24sIGlmIHdlIGRvbid0
IGV4cG9zZSBMQU0gdG8gdGhlIGd1ZXN0IG9uIHRoZQ0KPiA+IGhhcmR3YXJlIHRoYXQgc3VwcG9y
dHMgTEFNLCBJIHRoaW5rIGd1ZXN0IGNhbiBzdGlsbCBlbmFibGUgTEFNIGluIENSMyB3L28NCj4g
PiBjYXVzaW5nIGFueSB0cm91YmxlIChiZWNhdXNlIHRoZSBoYXJkd2FyZSBhY3R1YWxseSBzdXBw
b3J0cyB0aGlzIGZlYXR1cmUpPw0KPiANCj4gWWVzLiBCdXQgSSB0aGluayBpdCBpcyBhIG5vbi1p
c3N1ZSAuLi4NCj4gDQo+ID4gDQo+ID4gSWYgaXQncyB0cnVlLCBpdCBzZWVtcyB3ZSBzaG91bGQg
dHJhcCBDUjMgKGF0IGxlYXN0IGxvYWRpbmcpIHdoZW4gaGFyZHdhcmUNCj4gPiBzdXBwb3J0cyBM
QU0gYnV0IGl0J3Mgbm90IGV4cG9zZWQgdG8gdGhlIGd1ZXN0LCBzbyB0aGF0IEtWTSBjYW4gY29y
cmVjdGx5IHJlamVjdA0KPiA+IGFueSBMQU0gY29udHJvbCBiaXRzIHdoZW4gZ3Vlc3QgaWxsZWdh
bGx5IGRvZXMgc28/DQo+ID4gDQo+IA0KPiBPdGhlciBmZWF0dXJlcyB3aGljaCBuZWVkIG5vIGV4
cGxpY2l0IGVuYWJsZW1lbnQgKGxpa2UgQVZYIGFuZCBvdGhlcg0KPiBuZXcgaW5zdHJ1Y3Rpb25z
KSBoYXZlIHRoZSBzYW1lIHByb2JsZW0uDQoNCk9LLg0KDQo+IA0KPiBUaGUgaW1wYWN0IGlzIHNv
bWUgZ3Vlc3RzIGNhbiB1c2UgZmVhdHVyZXMgd2hpY2ggdGhleSBhcmUgbm90IHN1cHBvc2VkDQo+
IHRvIHVzZS4gVGhlbiB0aGV5IG1pZ2h0IGJlIGJyb2tlbiBhZnRlciBtaWdyYXRpb24gb3Iga3Zt
J3MgaW5zdHJ1Y3Rpb24NCj4gZW11bGF0aW9uLiBCdXQgdGhleSBwdXQgdGhlbXNlbHZlcyBhdCBz
dGFrZSwgS1ZNIHNob3VsZG4ndCBiZSBibGFtZWQuDQo+IA0KPiBUaGUgZG93bnNpZGUgb2YgaW50
ZXJjZXB0aW5nIENSMyBpcyB0aGUgcGVyZm9ybWFuY2UgaW1wYWN0IG9uIGV4aXN0aW5nDQo+IFZN
cyAoYWxsIHdpdGggb2xkIENQVSBtb2RlbHMgYW5kIHRodXMgYWxsIGhhdmUgbm8gTEFNKS4gSWYg
dGhleSBhcmUNCj4gbWlncmF0ZWQgdG8gTEFNLWNhcGFibGUgcGFydHMgaW4gdGhlIGZ1dHVyZSwg
dGhleSB3aWxsIHN1ZmZlcg0KPiBwZXJmb3JtYW5jZSBkcm9wIGV2ZW4gdGhvdWdoIHRoZXkgYXJl
IGdvb2QgdGVuZW50cyAoaS5lLiwgd29uJ3QgdHJ5IHRvDQo+IHVzZSBMQU0pLg0KPiANCj4gSU1P
LCB0aGUgdmFsdWUgb2YgcHJldmVudGluZyBzb21lIGd1ZXN0cyBmcm9tIHNldHRpbmcgTEFNX1U0
OC9VNTcgaW4gQ1IzDQo+IHdoZW4gRVBUPW9uIGNhbm5vdCBvdXR3ZWlnaCB0aGUgcGVyZm9ybWFu
Y2UgaW1wYWN0LiBTbywgSSB2b3RlIHRvDQo+IGRvY3VtZW50IGluIGNoYW5nZWxvZyBvciBjb21t
ZW50cyB0aGF0Og0KPiBBIGd1ZXN0IGNhbiBlbmFibGUgTEFNIGZvciB1c2Vyc3BhY2UgcG9pbnRl
cnMgd2hlbiBFUFQ9b24gZXZlbiBpZiBMQU0NCj4gaXNuJ3QgZXhwb3NlZCB0byBpdC4gS1ZNIGRv
ZW5zJ3QgcHJldmVudCB0aGlzIG91dCBvZiBwZXJmb3JtYW5jZQ0KPiBjb25zaWRlcmF0aW9uDQoN
ClllYWggcGVyZm9ybWFuY2UgaW1wYWN0IGlzIHRoZSBjb25jZXJuLiAgSSBhZ3JlZSB3ZSBjYW4g
anVzdCBjYWxsIG91dCB0aGlzIGluIA0KY2hhbmdlbG9nIGFuZC9vciBjb21tZW50cy4gIEp1c3Qg
d2FudCB0byBtYWtlIHN1cmUgdGhpcyBpcyBtZW50aW9uZWQvZGlzY3Vzc2VkLg0KDQpNeSBtYWlu
IGNvbmNlcm4gaXMsIGFzIChhbnkpIFZNRVhJVCBzYXZlcyBndWVzdCdzIENSMyB0byBWTUNTJ3Mg
R1VFU1RfQ1IzLCBLVk0NCm1heSBzZWUgR1VFU1RfQ1IzIGNvbnRhaW5pbmcgaW52YWxpZCBjb250
cm9sIGJpdHMgKGJlY2F1c2UgS1ZNIGJlbGlldmVzIHRoZQ0KZ3Vlc3QgZG9lc24ndCBzdXBwb3J0
IHRob3NlIGZlYXR1cmUgYml0cyksIGFuZCBpZiBLVk0gY29kZSBjYXJlbGVzc2x5IHVzZXMNCldB
Uk4oKSBhcm91bmQgdGhvc2UgY29kZSwgYSBtYWxpY2lvdXMgZ3Vlc3QgbWF5IGJlIGFibGUgdG8g
YXR0YWNrIGhvc3QsIHdoaWNoDQptZWFucyB3ZSBuZWVkIHRvIHBheSBtb3JlIGF0dGVudGlvbiB0
byBjb2RlIHJldmlldyBhcm91bmQgR1VFU1RfQ1IzIGluIHRoZQ0KZnV0dXJlLg0KDQpBbnl3YXkg
bm90IGludGVyY2VwdGluZyBDUjMgaXMgZmluZSB0byBtZSwgYW5kIHdpbGwgbGVhdmUgdGhpcyB0
byBvdGhlcnMuDQoNCg==
