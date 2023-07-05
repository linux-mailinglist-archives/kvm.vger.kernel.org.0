Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAAFD748474
	for <lists+kvm@lfdr.de>; Wed,  5 Jul 2023 14:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231879AbjGEMyM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jul 2023 08:54:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231304AbjGEMyK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jul 2023 08:54:10 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 737C31997;
        Wed,  5 Jul 2023 05:54:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688561644; x=1720097644;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=1ZgKboolPwed7gYBuyAFRMZntRVvq7u2vRZViYJgZO0=;
  b=T+FiUihOBzLaI+5J1BcBrLqr+QQvsYCsHjXl8sf+WHBpJIThpFu2uB35
   SpnPOMflxVLlY+J6DejNtY9HdCMizbjhr4k29LuafDkXYJjSaUFWqphGL
   RP9kQrj1N6um/48YmXxjRmH7NnG/1zkKgb6qfTJTNMzVQ0eRKa9Ue3qEO
   9oM71RRPxdH/fxUtJVF0XacjezjCLF6d1JF0Cur6a/wbatYuHbV81JDAk
   kQnP6UN8j36piRWYJxPPtY7lVBD4SrwOW9p5LyO8IIvkEm4H+ag53QMDU
   NGYfxqfPexOx/nefiLBZmW7UmZcD/O2qJ6CY5DzXKFm4YQxJ4GmwTvj0L
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10762"; a="429366317"
X-IronPort-AV: E=Sophos;i="6.01,183,1684825200"; 
   d="scan'208";a="429366317"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2023 05:54:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10762"; a="965816000"
X-IronPort-AV: E=Sophos;i="6.01,183,1684825200"; 
   d="scan'208";a="965816000"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga006.fm.intel.com with ESMTP; 05 Jul 2023 05:54:03 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 5 Jul 2023 05:54:02 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 5 Jul 2023 05:54:02 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.109)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 5 Jul 2023 05:54:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iSTUVEzKkT3vcaPLHGsR13txn0D5OlhvESNfjmuRXYRFM29ecKfqktwZUZVAHu3Yg122iXt7RzjO1W/VXMxW1MM5IOex9oQ/L6livpuSu1H8yO/juh4EUbK7ZPRaL+2jzqFtYPDmjbl7rJQ3msq2Cn8LgUG0GB0yAcnYMJhdZmZJd4yjghcx20G+WRtXsswhqSbkkZL7wf72WoyrNXHvHuY1S6yrV0OwMhkKMdkv862x1ttReEBbj4WEM58P31FtudRYdGvv47NBEqgr+lNmgRHKR3lUSSaBVpDb/shyUogxPeQiZisdZ1ybVFWcXXV7af3Uc9PutQxGtCnbApnNtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1ZgKboolPwed7gYBuyAFRMZntRVvq7u2vRZViYJgZO0=;
 b=UDXJM6tF0tt2gP/lknnCvDfWFBaNNnN9Eqyc4jDhLeHFh3SNWut/AjMf5/Vc1hMD8FgmWFd0T1rnHEfYfrS7DiWDngm0ayZ8LujatoFIpjDPbUQlW6Y5SAyB7kGMB7Jp6VTQnKE0OVar8OFEB1D1plq5ejWH17sNttQ5zsApW8iH2aNY3ZlyHPbPhXZVVedohi3LPwhSe5gRIu2pasijDM30U9WYK27wxJHed+6WMNZ1QZW1ScEM7c3/ebgaQr3qPC6RlZXvaz2JMGinW+KuNG6SV1exNMsJcd3GCAQubs0WSFooXK7pXPbMyGcQIxob060jYJ2Wg6ItzCIpithquw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB6500.namprd11.prod.outlook.com (2603:10b6:510:213::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6544.24; Wed, 5 Jul
 2023 12:53:59 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6565.016; Wed, 5 Jul 2023
 12:53:58 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "peterz@infradead.org" <peterz@infradead.org>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "hpa@zytor.com" <hpa@zytor.com>, "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v12 20/22] x86/virt/tdx: Allow SEAMCALL to handle #UD and
 #GP
Thread-Topic: [PATCH v12 20/22] x86/virt/tdx: Allow SEAMCALL to handle #UD and
 #GP
Thread-Index: AQHZqDW2iSvVOZI03kGK/IB0Vnjb6a+gWhoAgABWcYCAAOlagIABiuaAgAAEHICAAB1gAIAEuVMAgAME8ICAABRuAIAADHeAgAAJqIA=
Date:   Wed, 5 Jul 2023 12:53:58 +0000
Message-ID: <3bef89e1bc5935625483cc5bf339c13f643c2c29.camel@intel.com>
References: <c124550719716f1f7759c2bdea70f4722d8e0167.1687784645.git.kai.huang@intel.com>
         <20230628152900.GI2438817@hirez.programming.kicks-ass.net>
         <20230628203823.GR38236@hirez.programming.kicks-ass.net>
         <42e13ccf7f27a68c0dd64640eed378c38ef40967.camel@intel.com>
         <20230630100659.GF2533791@hirez.programming.kicks-ass.net>
         <20230630102141.GA2534364@hirez.programming.kicks-ass.net>
         <20230630120650.GB2534364@hirez.programming.kicks-ass.net>
         <fdd81fbd2424d8da04f98d156668cad5e73c740b.camel@intel.com>
         <20230705102137.GX4253@hirez.programming.kicks-ass.net>
         <ab3dea02892920cd6640a31a9c846afd6c6a9d54.camel@intel.com>
         <20230705121921.GZ4253@hirez.programming.kicks-ass.net>
In-Reply-To: <20230705121921.GZ4253@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH7PR11MB6500:EE_
x-ms-office365-filtering-correlation-id: 792d4af9-08d0-4601-ac92-08db7d56e60c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GwJuz5v3inb5Vf46dMBT84nKH/y92nmg3KY75/nIkfzjlxcoCUGAZYPcTyAEOL/nsNhvbqNW/MDUZNkkeyHTjdzTWPtA42pOoeRDhvF42Rj15Sf1SNcVTuXC2ZCNi8ygAYoXa1Fiq/0IK37KDsp9szeGFyERyU9pXX5g8s9z3+9l3hMrSpiIsVq1rw0N43efojHS6cyaoaG888WXzyzCx2zcz4jtiEJi1O93rbXG+ZBFyvXYB5vHrZuFkmNsOrg1oMsRZ+18Nwy4M2ZW0FB04bnDzawDjm8lGBfvyUvqn3H1okyrwItBY7kufDC5dgGSRYPDH4CR/sEiXT0I6sMwEMmIHCEAdMrp7KwDQmA4O5eoVrLd9QQjNg2ABqKIuhZvhudCFpz+/xW5Wqn69+PDWl8bLtF2H5CmQywvFDuauK/4S6MLf50wEKc6QdUw19gdgGlMlbbPPn+L7qDlWwG/FipsjEohdleByMEYbzORU3k/Z1YjTZ64obb8nJIHz12RMA6lDneqQOVBSjDHbkxAmWcInyFY6oYPD7L3RZsLDmMOS5y7aKPj3s8GrnX1+V235spIltJt52JZ33EhbIV3G5R1re4NdJRsJHho1JH36oHrputpjnYroR/qpn3H0Vmi
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(376002)(136003)(366004)(39860400002)(451199021)(54906003)(26005)(6512007)(186003)(8936002)(86362001)(71200400001)(36756003)(8676002)(7416002)(2906002)(5660300002)(6486002)(41300700001)(478600001)(38100700002)(122000001)(38070700005)(66556008)(6506007)(66476007)(4326008)(6916009)(66446008)(82960400001)(76116006)(91956017)(66946007)(64756008)(2616005)(83380400001)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WmdYOENnUTRxQXdBaHBlM1FtNkM5b1FwK1k1TUhFdWFIYVNiM05WQXVkb2l0?=
 =?utf-8?B?cFM2MUZuYTNnaVNtUlVRSnE0eU05SkxCeGsyczNzb2ltL1pSK3BtclBRZ0Fh?=
 =?utf-8?B?QzFsczlXY1c5S3NyZ2xaTDlyWk9MQ2F1WGVhdFI3YlpPQVUwYkkzTEYxRTlD?=
 =?utf-8?B?aTk2eWNWTllmZGhaWGgzKzdNeHdsOFE3ZlNsTm5NbWdsYmUzc3owd3I1TE92?=
 =?utf-8?B?Qzkrbm1WcXdsc2dFK2wycjBMdkNXRklqTXlMWmRnZ1lHK1RNSlZXMHZKbk5p?=
 =?utf-8?B?K0daTittWml2UFBKQ1RNZEdQY043YTJXVHF5YzhvNDJEMTRzd0NCS0l5L0lO?=
 =?utf-8?B?SDBhN2JBT3ZRY0RBK0RCQ1FKUGlnYitsZG4zNlkvZEM4UE9jd1JLQ3kyMFdz?=
 =?utf-8?B?b1RKdU1KVnVkalVsSU1uUXRtS0s3VXN3WVNQZXNHeUROeHBTSnpRdEh4ajdz?=
 =?utf-8?B?M2IvTUJONGNISnpNd2JOd0hkdy8xTkZ5dWM4eWJBcHpmbGhMZkFJclRkRGE1?=
 =?utf-8?B?TkxzNC9ZSzlCTXJjSWRGaWhtRGtYdVE4aU5TQ3o0ckUveVBueXVqdS9ORHdB?=
 =?utf-8?B?enlkallpcFdGWGZlSXpaQzNZN2prckRrTUpyc1ZDTkk5dHlFN0pPOHZ6SHoy?=
 =?utf-8?B?dUFIaTh2Nm1EVkRGanlEVHl1S0FMWnhTelBhOGRteVI2N2huMFJWYXQ4Qjlk?=
 =?utf-8?B?L2J6c0pZNm9mNEVoSDlYcTN5elU3L1lIYnZoenU5THhqQ09EcXFrMDBNN0E0?=
 =?utf-8?B?ZmhRVXA3RTdtZmlWenQ4OHVYZDdDTlJBRTJXT2JrVnV5ektFRXhHY2Vldzhk?=
 =?utf-8?B?RjRkcGJRcjJ1SEtObGxxVm0yS2lyV2IxWCttcTBmZnZwMDBvdTR1YlBHSnlj?=
 =?utf-8?B?c3hJdlk4VklETldOMDBDNG9mYmZ5dmlrYlBTWHVsUExSaXZXeGl1RHE0MHc0?=
 =?utf-8?B?dStDdmdiVEwvRUFVeGdUZThBVGwyUUpBR0xXOVFrRStxN3lwSUF6MlVERnRr?=
 =?utf-8?B?TTNxc1hpeHNuYXdodEo3c1RnQXJta1RNM3dhY0xZd2ZVa3U5Z1V1Q3RaSzBN?=
 =?utf-8?B?dlBhUFJHcmxGUFJqN0xpM0RDeWtyMEx6bGFpbk1ZNnRJWnh1Z05YdXB0Yk5q?=
 =?utf-8?B?V3RIYTVRVm42MnhhLzdaU0svYi95N1JqelpjOStUMTZVZUxYUXhBS0NrQmQ3?=
 =?utf-8?B?YmRGVkNXMXV4NDZveE1VM3hZWVludFVISVdXMk0wZkx1RWhYREtpYnA1aktn?=
 =?utf-8?B?Y211L2JSVy9sVWZ6b1FpUGxjazNhTmRJOEQyUlVtQXNUVzFYMWxlM1RKeUw0?=
 =?utf-8?B?eDZLUHZTT2VVWUxDRE9rZkhhNldKNnRabWNiTTZ6ODUrMnZzTWxzVzRWY21K?=
 =?utf-8?B?NTlNL0xCQytVV2U3MmxsOXdDbmtxU0dMbkdDaENCRjUyZEhCV242c2pCWnhI?=
 =?utf-8?B?a05Bbk5aVVFSbVFSdExpWFlYcDk4aFJUMmtiN3o3N2h6SjFidmtScjVNR0pi?=
 =?utf-8?B?YmxJZ1FXWFhMd0FYVkJmbVl0eDREMEhWbk5mdG1LcjhsVkYzVkt3bHZRbTFY?=
 =?utf-8?B?cXM5L2ttUGpYTkt2dnhCSS9rTExKbjlTSEZ5RE5tejd1SjhxdktoQW5zQU5W?=
 =?utf-8?B?a2c2NXVlRlVwL0liaVJNUUNLZmZxMEhQRC8yaEZXS1U4ZnlUUVFDREJjNjZT?=
 =?utf-8?B?VjM0dzlYZFRsdjhCdnJKd3NrcFJtelRkUldIWHVVMHJTMzFYR2JjVUlkSXpx?=
 =?utf-8?B?ZHFqa1RVNGE2OStBS0wrOGQ4djd6L256T090NlRiRTRtSWVPYnFMQWcyeTNk?=
 =?utf-8?B?U3BNcjZxVkRleE1EbWVkMDZ6bWVhQlYwOGtNYWlVcUxIN1o1Z0dyOVY4UHR5?=
 =?utf-8?B?UFJ0V0NadUNQdUQ5U1c0aEM3Q05nWEdQSGk0dUxlbWthY01kek5nYnVMTWlW?=
 =?utf-8?B?SkFGTnMzZW9tQ1FKeFN4b3ZRZnpjZnlVSXJpbXM0R0dyWXozaEd5bEZSckJz?=
 =?utf-8?B?dnBQakVtUW9GTk5QZDg3aGpXZTd6R2ZRN3ZJSUNmVjJCL2xVc2VydHdCU1hv?=
 =?utf-8?B?MHFjdytwNE8rZVY2aWw2aERjRG5aS3lXeDI2Y1BzUHVoN3RYWWVNMHBlYzg2?=
 =?utf-8?Q?WdHl4naGJ30JKihq2up7d65fv?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <883C43CDBA80714BAC760A8D0A872E54@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 792d4af9-08d0-4601-ac92-08db7d56e60c
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2023 12:53:58.2831
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: V0aPRRFZkbRuPbD/VWrVv4WFWtZt9D8usMwr94TckpXeaX0Aox1Yam6y+dRpBwKxFFHgOBl48jeeqciH91yXww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6500
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIzLTA3LTA1IGF0IDE0OjE5ICswMjAwLCBQZXRlciBaaWpsc3RyYSB3cm90ZToN
Cj4gT24gV2VkLCBKdWwgMDUsIDIwMjMgYXQgMTE6MzQ6NTNBTSArMDAwMCwgSHVhbmcsIEthaSB3
cm90ZToNCj4gDQo+ID4gWWVhaCBJIHRoaW5rIGZyb20gbG9uZy10ZXJtJ3Mgdmlldywgc2luY2Ug
U0VBTUNBTExzIHRvIHN1cHBvcnQgbGl2ZSBtaWdyYXRpb24NCj4gPiBwcmV0dHkgbXVjaCB1c2Vz
IGFsbCBSQ1gvUkRYL1I4LVIxNSBhcyBpbnB1dC9vdXRwdXQsIGl0IHNlZW1zIHJlYXNvbmFibGUg
dG8NCj4gPiB1bmlmeSBhbGwgb2YgdGhlbSwgYWx0aG91Z2ggSSBndWVzcyB0aGVyZSBtaWdodCBi
ZSBzb21lIHNwZWNpYWwgaGFuZGxpbmcgdG8NCj4gPiBWUC5WTUNBTEwgYW5kL29yIFZQLkVOVEVS
LCBlLmcuLCBiZWxvdzoNCj4gPiANCj4gPiAgICAgICAgIC8qIFREVk1DQUxMIGxlYWYgcmV0dXJu
IGNvZGUgaXMgaW4gUjEwICovICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgDQo+ID4gICAg
ICAgICBtb3ZxICVyMTAsICVyYXgNCj4gPiANCj4gPiBTbyBsb25nLXRlcm1seSwgSSBkb24ndCBo
YXZlIG9iamVjdGlvbiB0byB0aGF0LiAgQnV0IG15IHRoaW5raW5nIGlzIGZvciB0aGUNCj4gPiBm
aXJzdCB2ZXJzaW9uIG9mIFREWCBob3N0IHN1cHBvcnQsIHdlIGRvbid0IGhhdmUgdG8gc3VwcG9y
dCBhbGwgU0VBTUNBTExzIGJ1dA0KPiA+IG9ubHkgdGhvc2UgaW52b2x2ZWQgaW4gYmFzaWMgVERY
IHN1cHBvcnQuIA0KPiANCj4gU2luY2UgdGhvc2UgY2FsbHMgYXJlIG91dCBub3csIHdlIHNob3Vs
ZCBsb29rIGF0IHRoZW0gbm93LCB0aGVyZSBpcyBubw0KPiBwb2ludCBpbiBkZWxheWluZyB0aGUg
cGFpbi4gVGhhdCB0aGVuIGdpdmVzIHVzIHR3byBvcHRpb25zOg0KPiANCj4gIC0gd2UgYWNjZXB0
IHRoZW0gYW5kIHRoZWlyIHdvbmt5IGNhbGxpbmcgY29udmVudGlvbiBhbmQgb3VyIGNvZGUgc2hv
dWxkDQo+ICAgIGJlIHJlYWR5IGZvciBpdC4NCj4gDQo+ICAtIHdlIHJlamVjdCB0aGVtIGFuZCBz
ZW5kIHRoZSBURFggdGVhbSBhIG1lc3NhZ2UgdG8gcGxlYXNlIHRyeSBhZ2Fpbg0KPiAgICBidXQg
d2l0aCBhIHNhbmVyIGNhbGxpbmcgY29udmVudGlvbi4NCj4gDQo+IFN0aWNraW5nIG91ciBoZWFk
IGluIHRoZSBzYW5kIGFuZCBwcmV0ZW5kaW5nIGxpa2UgdGhleSBkb24ndCBleGlzdCBpc24ndA0K
PiByZWFsbHkgYSB2aWFibGUgb3B0aW9uIGF0IHRoaXMgcG9pbnQuDQoNCk9LLiAgSSdsbCB3b3Jr
IG9uIHRoaXMuDQoNCkJ1dCBJIHRoaW5rIGV2ZW4gd2Ugd2FudCB0byB1bmlmeSBfX3RkeF9tb2R1
bGVfY2FsbCgpIGFuZCBfX3RkeF9oeXBlcmNhbGwoKSwgdGhlDQpmaXJzdCBzdGVwIHNob3VsZCBi
ZSBtYWtpbmcgX190ZHhfbW9kdWxlX2NhbGwoKSBsb29rIGxpa2UgX190ZHhfaHlwZXJjYWxsKCk/
ICBJDQptZWFuIGZyb20gb3JnYW5pemluZyBwYXRjaHNldCdzIHBvaW50IG9mIHZpZXcsIHdlIGNh
bm5vdCBqdXN0IGRvIGluIG9uZSBiaWcNCnBhdGNoIGJ1dCBuZWVkIHRvIHNwbGl0IGludG8gc21h
bGwgcGF0Y2hlcyB3aXRoIGVhY2ggZG9pbmcgb25lIHRoaW5nLg0KDQpCeSB0aGlua2luZyBpcyBw
ZXJoYXBzIHdlIGNhbiBvcmdhbml6ZSB0aGlzIHdheToNCg0KIDEpIFBhdGNoKGVzKSB0byBtYWtl
IFREWF9NT0RVTEVfQ0FMTCBtYWNybyAvIF9fdGR4X21vZHVsZV9jYWxsKCkgbG9vayBsaWtlDQpf
X3RkeF9oeXBlcmNhbGwoKS4NCiAyKSBBZGQgU0VBTUNBTEwgc3VwcG9ydCBiYXNlZCBvbiBURFhf
TU9EVUxFX0NBTEwsIGUuZy4sIGltcGxlbWVudCBfX3NlYW1jYWxsKCkuDQogMykgVW5pZnkgX190
ZHhfbW9kdWxlX2NhbGwoKS9fX3NlYW1jYWxsKCkgd2l0aCBfX3RkeF9oeXBlcmNhbGwoKS4NCg0K
RG9lcyB0aGlzIGxvb2sgZ29vZD8NCg0KQnR3LCBJJ3ZlIGFscmVhZHkgcGFydCAxKSBiYXNlZCBv
biB5b3VyIGNvZGUsIGFuZCBzZW50IHRoZSBwYXRjaGVzIHRvIEtpcmlsbCBmb3INCnJldmlldy4g
IFNob3VsZCBJIHNlbnQgdGhlbSBvdXQgZmlyc3Q/DQoNCj4gDQo+ID4gQWxzbywgdGhlIG5ldyBT
RUFNQ0FMTHMgdG8gaGFuZGxlIGxpdmUgbWlncmF0aW9uIGFsbCBzZWVtIHRvIGhhdmUgYmVsb3cN
Cj4gPiBzdGF0ZW1lbnQ6DQo+ID4gDQo+ID4gCUFWWCwgQVZYMglNYXkgYmUgcmVzZXQgdG8gdGhl
IGFyY2hpdGVjdHVyYWwgSU5JVCBzdGF0ZQ0KPiA+IAlhbmQNCj4gPiAJQVZYNTEyDQo+ID4gCXN0
YXRlDQo+ID4gDQo+ID4gV2hpY2ggbWVhbnMgdGhvc2UgU0VBTUNBTExzIG5lZWQgdG8gcHJlc2Vy
dmUgQVZYKiBzdGF0ZXMgdG9vPw0KPiANCj4gWWVzLCB3ZSBuZWVkIHRvIGVuc3VyZSB0aGUgdXNl
cnNwYWNlICdGUFUnIHN0YXRlIGlzIHNhdmVkIGJlZm9yZQ0KPiB3ZSBjYWxsIHRoZW0uIEJ1dCBJ
IF90aGlua18gdGhhdCBLVk0gYWxyZWFkeSBkb2VzIG11Y2ggb2YgdGhhdC4NCg0KTGV0IG1lIGxv
b2sgaW50byB0aGlzLg0KDQo+IA0KPiA+IEFuZCByZWFkaW5nIHRoZSBzcGVjLCB0aGUgVlAuVk1D
QUxMIGFuZCBWUC5FTlRFUiBhbHNvIGNhbiB1c2UgWE1NMCAtIFhNTTE1IGFzDQo+ID4gaW5wdXQv
b3V0cHV0LiAgTGludXggVlAuVk1DQUxMIHNlZW1zIGRvZXNuJ3Qgc3VwcG9ydCB1c2luZyBYTU0w
IC0gWE1NMTUgYXMNCj4gPiBpbnB1dC9vdXRwdXQsIGJ1dCBLVk0gY2FuIHJ1biBvdGhlciBndWVz
dCBPU2VzIHRvbyBzbyBJIHRoaW5rIEtWTSBWUC5FTlRFUiBuZWVkcw0KPiA+IHRvIGhhbmRsZSBY
TU0wLVhNTTE1IGFzIGlucHV0L291dHB1dCB0b28uDQo+IA0KPiBXaHkgd291bGQgS1ZNIGFjY2Vw
dCBWTUNBTExzIGl0IGRvZXNuJ3Qga25vdyBhYm91dD8gSnVzdCB0cmFzaCB0aGUNCj4gZ3Vlc3Qg
YW5kIGNhbGwgaXQgYSBkYXkuDQo+IA0KPiA+IFRoYXQgYmVpbmcgc2FpZCwgSSB0aGluayBhbHRo
b3VnaCB3ZSBjYW4gcHJvdmlkZSBhIGNvbW1vbiBhc20gbWFjcm8gdG8gY292ZXINCj4gPiBWUC5F
TlRFUiwgSSBzdXNwZWN0IEtWTSBzdGlsbCBuZWVkcyB0byBkbyBhZGRpdGlvbmFsIGFzc2VtYmx5
IGFyb3VuZCB0aGUgbWFjcm8NCj4gPiB0b28uICBTbyBJIGFtIG5vdCBzdXJlIHdoZXRoZXIgd2Ug
c2hvdWxkIHRyeSB0byBjb3ZlciBWUC5FTlRFUi4NCj4gDQo+IE5vdCBzdXJlIGFib3V0IGFzbSwg
d2UgaGF2ZSBpbnRlcmZhY2VzIHRvIHNhdmUgdGhlIFhNTS9BVlggcmVncy4NCj4ga2VybmVsX2Zw
dV9iZWdpbigpIGNvbWVzIHRvIG1pbmQsIGJ1dCBJIGtub3cgdGhlcmUncyBtb3JlIG9mIHRoYXQs
DQo+IGluY2x1ZGluZyBzb21lIGZvciBLVk0gc3BlY2lmaWNhbGx5Lg0KDQpZZWFoIGRvZXNuJ3Qg
aGF2ZSB0byBiZSBhc20gaWYgaXQgY2FuIGJlIGRvbmUgaW4gQy4NCg0KPiANCj4gPiA+IEkgZG9u
J3QgdGhpbmsgdGhleSBzaG91bGQgYmUgc3BlY2lhbCwgdGhleSdyZSByZWFsbHkganVzdCB5ZXQg
YW5vdGhlcg0KPiA+ID4gbGVhZiBjYWxsLiBZZXMsIHRoZXkgaGF2ZSBhIHNoaXQgY2FsbGluZyBj
b252ZW50aW9uLCBhbmQgeWVzIFZQLkVOVEVSIGlzDQo+ID4gPiB0ZXJtaW5hbGx5IGJyb2tlbiBm
b3IgdW5jb25kaXRpb25hbGx5IGNsb2JiZXJpbmcgQlAgOi0oDQo+ID4gPiANCj4gPiA+IFRoYXQg
cmVhbGx5ICptdXN0KiBiZSBmaXhlZC4NCj4gPiANCj4gPiBTdXJlIEkgZG9uJ3QgaGF2ZSBvYmpl
Y3Rpb24gdG8gdGhpcywgYW5kIGZvciBWUC5FTlRFUiBwbGVhc2Ugc2VlIGFib3ZlLg0KPiA+IA0K
PiA+IEJ1dCBJJ2QgbGlrZSB0byBzYXkgdGhhdCwgZ2VuZXJhbGx5IHNwZWFraW5nLCBmcm9tIHZp
cnR1YWxpemF0aW9uJ3MgcG9pbnQgb2YNCj4gPiB2aWV3LCBndWVzdCBoYXMgaXRzIG93biBCUCBh
bmQgY29uY2VwdHVhbGx5IHRoZSBoeXBlcnZpc29yIG5lZWRzIHRvIHJlc3RvcmUNCj4gPiBndWVz
dCdzIEJQIGJlZm9yZSBqdW1waW5nIHRvIHRoZSBndWVzdC4gIEUuZy4sIGZvciBub3JtYWwgVk1Y
IGd1ZXN0LCBLVk0gYWx3YXlzDQo+ID4gcmVzdG9yZXMgZ3Vlc3QncyBCUCBiZWZvcmUgVk1FTlRF
UiAoYXJjaC94ODYva3ZtL3ZteC92bWVudGVyLlMpOg0KPiA+IA0KPiA+IFNZTV9GVU5DX1NUQVJU
KF9fdm14X3ZjcHVfcnVuKQ0KPiA+ICAgICAgICAgcHVzaCAlX0FTTV9CUA0KPiA+ICAgICAgICAg
bW92ICAlX0FTTV9TUCwgJV9BU01fQlANCj4gPiAJDQo+ID4gCS4uLg0KPiA+IAltb3YgVkNQVV9S
QlAoJV9BU01fQVgpLCAlX0FTTV9CUA0KPiA+IAkuLi4NCj4gPiAJdm1lbnRlci92bXJlc3VtZQ0K
PiA+IAkuLi4NCj4gPiBTWU1fSU5ORVJfTEFCRUwodm14X3ZtZXhpdCwgU1lNX0xfR0xPQkFMKQ0K
PiA+IAkuLi4uLg0KPiA+IAltb3YgJV9BU01fQlAsIFZDUFVfUkJQKCVfQVNNX0FYKQ0KPiA+IAku
Li4NCj4gPiAJcG9wICVfQVNNX0JQDQo+ID4gICAgICAgICBSRVQNCj4gDQo+IFRoYXQncyBkaXNn
dXN0aW5nIDovIFNvIHdoYXQgaGFwcGVucyBpZiB3ZSBnZXQgYW4gTk1JIGFmdGVyIFZNRU5URVIg
YW5kDQo+IGJlZm9yZSBQT1A/IFRoZW4gaXQgc2VlcyBhIGdhcmJhZ2UgQlAgdmFsdWUuDQoNCkxv
b2tzIHNvLg0KDQo+IA0KPiBXaHkgaXMgYWxsIHRoaXMgc3R1ZmYgc3VjaCB1dHRlciBjcmFwPw0K
PiANCg0KVGhlIHByb2JsZW0gaXMgS1ZNIGhhcyB0byBzYXZlL3Jlc3RvcmUgQlAgZm9yIGd1ZXN0
LCBiZWNhdXNlIFZNWCBoYXJkd2FyZQ0KZG9lc24ndCBzYXZlL3Jlc3RvcmUgQlAgZHVyaW5nIFZN
RU5URVIvVk1FWElULiAgSSBhbSBub3Qgc3VyZSB3aGV0aGVyIHRoZXJlJ3MgYQ0KYmV0dGVyIHdh
eSB0byBoYW5kbGUuDQoNCk15IGJyYWluIGlzIGdldHRpbmcgc2xvdyByaWdodCBub3cgYXMgaXQn
cyAxLWhvdXIgcGFzdCBtaWRuaWdodCBhbHJlYWR5LiAgSSBhbQ0KaG9waW5nIFBhb2xvL1NlYW4g
Y2FuIGp1bXAgaW4gaGVyZS4gOikNCg==
