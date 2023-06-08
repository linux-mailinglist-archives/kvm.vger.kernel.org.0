Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D0DE72770A
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 08:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234558AbjFHGHK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 02:07:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233550AbjFHGHH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 02:07:07 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97DAA26A2;
        Wed,  7 Jun 2023 23:07:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686204426; x=1717740426;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Om3F/KasNsxRk3UPq9Baop7ujEzKWjhZB5KU30uiwh0=;
  b=BHFeIqxS4T3DzwNWAMfIujaTw4goTGBomYlhBCfPljuudMBHa7zJanOH
   TOQY7yhfXOBV3PGc5Hzxz53INORqWb2iyg3lJvy1FNnugXZFX4tAqhAAG
   j8bSaRpJkEQUPyBi2CMH44Jk1mNriY1mgIxsCoqJwXGUDKbvCucLdMbIi
   /DXwtXQcaiUuLjqeYk/fHTwXHzLYp8WcSwtN40+fEDpXGBUBp0G/3MZje
   0MOCppGJqebhWtSBQwusj5dT9MBRYsMMT6oFddCIi0AU7sPS0/rzFRTpi
   RQy7q/6QIe9+t6e9+Lti442zn9LoyDiEoliDDW+wi8oqwjvoiE2ynXxv9
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="354705974"
X-IronPort-AV: E=Sophos;i="6.00,226,1681196400"; 
   d="scan'208";a="354705974"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 23:07:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="739564777"
X-IronPort-AV: E=Sophos;i="6.00,226,1681196400"; 
   d="scan'208";a="739564777"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga008.jf.intel.com with ESMTP; 07 Jun 2023 23:07:05 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 7 Jun 2023 23:07:04 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 7 Jun 2023 23:07:04 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.42) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 7 Jun 2023 23:07:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SoRsmsQunc18x6STMdgwuR2OXuwmCDq1Up7cjyG333ZNUqLm4oxiPAosPIgr6ZC4vT1QiG2jC6h/EkD1P9hB1B5/ZVsv+ppiL19mqiSErr2Yn5uMStHqyQBeiQBBnam+rW3I7wd70QDTQercOscHPFI2mlPADB8Atv9QRa4vuIXTn3haGjII/ragXYaMb7gZDfNwvk+WoiPqdiBQVDHYuRcRGQoBnqEpI9qyaXZVdpn3ajUa7y0UW5GL2acZi1dwyb+qZzZnr9S5xh8LNovmezmH5xCMZ+YJdmShpJ240DylhWOmqfLkopVZgic3PeTdKPPtMOkwVQQl6jQM+bZSow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nP2hElk8LUJHA82UwxI7hwszpaPYvbeSfKOTsuA1UlE=;
 b=CaMYd5y5lf8EoRNbB5xU+BtGKqqR4HVAZI50YTfjPbsbNL8/PYDxFF/Lz+9CpDLmDtHxbAKiT0iDvMLiZCYEfZAd22vepi1U8ZrJSndHPAMH4hfk1aLlcr15SNPk45NJtO3n7nJKrgJEL9niBJRCDltYuKnjjP+wU2xRHQHb4sGiEt3WHxF6z156oTCZthYNqFd/JOt+keD8NsyUgDq3RGbvjTcFSmjpJjkxM+uEUv7kQVIfjXqgU0M3+qTEaLnLek+Koq6teop/Csnt3h/EpNaXCUHySPqxCj1QSOPxt/wspEVEY6utffnF+XFxCDChNfNQTUWUcUVC8WnB+LGw9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by IA1PR11MB6074.namprd11.prod.outlook.com (2603:10b6:208:3d6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.24; Thu, 8 Jun
 2023 06:07:02 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4707:8818:a403:f7a9]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4707:8818:a403:f7a9%5]) with mapi id 15.20.6455.030; Thu, 8 Jun 2023
 06:07:02 +0000
Message-ID: <14fee87d-838b-e097-d663-2d947d5edcc5@intel.com>
Date:   Thu, 8 Jun 2023 14:06:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH v3 12/21] KVM:x86: Add fault checks for guest CR4.CET
 setting
Content-Language: en-US
To:     Chao Gao <chao.gao@intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <peterz@infradead.org>,
        <rppt@kernel.org>, <binbin.wu@linux.intel.com>,
        <rick.p.edgecombe@intel.com>, <john.allen@amd.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20230511040857.6094-1-weijiang.yang@intel.com>
 <20230511040857.6094-13-weijiang.yang@intel.com>
 <ZH8Sfv+qh/WR7c8s@chao-email>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZH8Sfv+qh/WR7c8s@chao-email>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0048.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::17) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|IA1PR11MB6074:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ad3384f-c5c0-46f9-0036-08db67e69368
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /zCYQskfInBNqrIsslzVrzvErRpUgYWU5P8lEBM0q6a0gTmv8ERrRTLXtzSDu8c1SApunmC5hrUa7aaDRb1f0ij6LGrb6TKgrKB77clE3fiZ+m9vk7ojeNL6qP7VGTAINIidpf8InKQ9lBmJbDLAkXNFLeXZP7062a6YFSf9dYQ8Haoo4TcOI8vy8ACbJkaLb2KPRrCyMSVibK5ie+nlNigPFOzMWNE4u26pdXBkSqRil3f5iJaB57awmcY0UpRwgiyfGtoUE51uGEvxtBXH+Jlimu5DNWXTG3Te1GHgudxPQYJfPZPw6UPLrKUaKa2OF3X0y72p3sb0L17ahkigJJa+1gMsx6vmEqjpJl0WownLIKk8uowcZ963n9ZrK6SG0kKYrh1ivbvfbsIMEbkAg6RGaZFD7hZFfpfHhSCZk8G+Bt0FVE6nREGF/CjfxL0IM3vbBj4vxR+ykMNXQbEYmH5igg4Vx2Py5fuF+Gp8ardOYLvpvtiqzeg1d4KJBoNeqC7v4LUpWbhjugBBWUiIj3xidB3mHjJx8CSkUxBUtz8qbaS6OfMLrmreSpv7SuIt6nR9FXcS9XXC4c6szF6N46b7IzYl/SdCfx8CDLaIEroktxT5x64dGtQ5Q3m/fMAU6JqwZfn1q4AIQEC/Aus94g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(396003)(346002)(366004)(376002)(39860400002)(451199021)(8936002)(6862004)(186003)(2906002)(37006003)(478600001)(4326008)(2616005)(6636002)(66476007)(6666004)(66946007)(66556008)(8676002)(5660300002)(53546011)(41300700001)(6506007)(6512007)(26005)(6486002)(31696002)(82960400001)(36756003)(86362001)(316002)(38100700002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S3JYUWVDZThGRWRQOUd5UlAxMWM0MElzdVlXb3VMSXE3dWhkcVNxenZyU0gz?=
 =?utf-8?B?N0JYN3JQRUdHZHc2RmhpbG1YNXZCakpYRk5QTW1vbXRlM2NxQTdyNHBweWRk?=
 =?utf-8?B?M0N4ZkdpWm1jN3ROYlFUZ1NnU2JKSFAzWlV0L1M2OXlLb3JDK0FrditFT2Jy?=
 =?utf-8?B?YUtXUlBCcUpWakdFRDhvM2FaeEQwaDgrL0dNS2E1cko4Qk5QWk1yQ05SVkN2?=
 =?utf-8?B?S2VYSDVyUXZGMGtlby8xWGxKalpnZjYybVgvVFA4OEJCRnhJSFNPMWVkTGNu?=
 =?utf-8?B?bk5iK1pRZ1VERmVscVRXVVdHSnY3YXBZRXhDLzhMYkRESmhnSjV0anJyb0Rv?=
 =?utf-8?B?L0VCMXVLNkFoVmRWaU1DVUxmbUNScWExWjByMDFuek42R3ZoNFBpNnQyRmpi?=
 =?utf-8?B?N1BtNUxEQVZpUmlXQllPOGtTWVptT1BMSTFjMmxIR05BYzdZdTIxem9jbUg1?=
 =?utf-8?B?TldPZnVPZEVGRTBwdDVVeGwwaXdyNnkwSHNFRHBqYkNUd1BmWjgwaHk0UVRN?=
 =?utf-8?B?UnNubUlrQndINTI2TTdTSGZKOEkzKzdHY1I4cUVFbTZ6ck5JYjlLUDRiWG55?=
 =?utf-8?B?WWJOOHFrNzVpYU1KQVE0RjNXaVVaOHpWYWU4RFA5K010NmVrdDFpcGhxQ2hu?=
 =?utf-8?B?U1Z0RUVnVFFLYURXeko4cjc3MUg2Vi9iZ0ZZanZEL1FLdUM3YkcxVi9yZHR4?=
 =?utf-8?B?NUhIbmZueVdHSlpmalRLNDF0NnlBNk9yNlRDTWdSelcwZ2svbW95d2hOYTd4?=
 =?utf-8?B?VFJuSUFiSjlhbTFXaGVUTnJnc0VWN2NDQnN1Q2thVXJWcmh0N3dwdXVjMGNB?=
 =?utf-8?B?cFNQUFNDeDlZZ0JjMzZQNU5yUSt2QWZTQnBJTDh4cXZaWG5BeHFIZm9BZitB?=
 =?utf-8?B?YS93MnN5NGp1NmF5dVVRMWNaUXlpOGdNZjAwZmhXcGFQdDQvbnZob2RSNmNx?=
 =?utf-8?B?Z2JzNnZxZlJPQ3NBQlRlSEhDYVBCTXJXeVVGTDJYSy9ZSEp5T0dUeU5HRHVR?=
 =?utf-8?B?K2dDaTFQTkRRL20xY1NxdGp4Zk14UTdVSEJyaTc5Wml3SUZURlVSdHJRRjdU?=
 =?utf-8?B?aDVoZmk1b0pTODNoWFZ0Z2hnVVFndEZDdEY5MDZwWExtdENGTWsvUGpRcDEx?=
 =?utf-8?B?azZvUFFvVEZaNEVZN3lIRnEzWjNieVkvRlA4bGo1MVlYSUVLK1c1Z0NRRFR6?=
 =?utf-8?B?OXQ5L3kyQytDVGJhTVRlZEY0UjNURzJKSlZPSnc0MkphV1podjNybHJib0FB?=
 =?utf-8?B?eU9Ua0ZBeHJUVjJhL3I0dVgrMlAyUWpWUkxhRzBnd0ptQWF2TUNEL2h6Nmh5?=
 =?utf-8?B?ZlVOSWZpcytybHVjQ1VFamRmRmJvMEJxK0piVmRIbVVKSm5md0l0TlFoWGtZ?=
 =?utf-8?B?L1NhTGpISG8wWWpKZTdhbXUyMU8wVUI5amFlTHl1UHczbEE0MkxFQjNLMldy?=
 =?utf-8?B?Nm5MRFpnYlo0Rno5RlI2QjNwT1EwTnlqa21PbnB2c0RLRjRpTW1uMVg4Wisy?=
 =?utf-8?B?UE9NR3ZUK1JqdFdvN2VRdWQ0Ryt3aDBuaFNYcGp0MlY2Nm9Nd3VTeWNDdU1x?=
 =?utf-8?B?a29POEdidm1waGdnbjZBS0k0KzBiVzlIbHAvZVZWeEQzVm1tWWxIb2tKY1Vh?=
 =?utf-8?B?RjZWTEZsMEk2bE9seG5HN01EVUVvVThLZzBTL2xwSmdabU5kVm5pTkQzNy9r?=
 =?utf-8?B?Y3VFOUxHYlBVNE5TQUFod2w2TDRrYVhFZzlJUHpIZk9QbGV4NnpWUnExcS83?=
 =?utf-8?B?ZEZkNlE0cHVBWE0xaFBLT3RESVRPcVNERUtZM2oweHZPcUpvVWtpMUF5MjVK?=
 =?utf-8?B?ZDB2UWdRcVIzYzU0VWZJZUVldkt1dDhLT1ljZjZSYW01RUllbDBFWEk2RDV5?=
 =?utf-8?B?L0FSM3VUaEgrd2l6UTJuMGIzbFZmZ1R4TmxIZEZZNnFnUHl1Tk91QXJxalE1?=
 =?utf-8?B?RzBVZms0MkJkQWdXQUdQM2RvTjA4TVJwT3g1NzlWazh5UUcvRzk2L3BEWWMv?=
 =?utf-8?B?SDlWSjZscnZwY1BaNVFjYkFhSUN5TlJtNklaTE9GMkNJcEo3bHFyOTZEN2R4?=
 =?utf-8?B?V3ZYUjhLRXhSN2ErQ0ppNS9Ycms5QjNaazAwN2MvbUM0NVcwVFBPaU16OW5m?=
 =?utf-8?B?MFRvQ2ZndEUreXh4TkFmRy9PTFVjM0FqMTVRMGZGRGYweGY2SVZsSkwxWS9E?=
 =?utf-8?B?RlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ad3384f-c5c0-46f9-0036-08db67e69368
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2023 06:07:01.9681
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9ZAYUz5Srubusjd7JeMBWZ2zIeH5iX0aimCAo05Vul+Fn9I8krRLSFpAicDg+W3TR0NOTWqqW95DqQopQqpxTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6074
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/6/2023 7:03 PM, Chao Gao wrote:
> On Thu, May 11, 2023 at 12:08:48AM -0400, Yang Weijiang wrote:
>> Check potential faults for CR4.CET setting per Intel SDM.
>> CR4.CET is the master control bit for CET features (SHSTK and IBT).
>> In addition to basic support checks,
> To me, this implies some checks against CR4.CET when enabling SHSTK or
> IBT. but the checks are not added by this patch. Then, why bother to
> mention this?

OK, I'll remove these unnecessary words and change the commit logs.

>
>> CET can be enabled if and only
>> if CR0.WP==1, i.e. setting CR4.CET=1 faults if CR0.WP==0 and setting
>> CR0.WP=0 fails if CR4.CET==1.
>>
>> Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
>> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>> ---
>> arch/x86/kvm/x86.c | 6 ++++++
>> 1 file changed, 6 insertions(+)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index a768cbf3fbb7..b6eec9143129 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -995,6 +995,9 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
>> 	    (is_64_bit_mode(vcpu) || kvm_is_cr4_bit_set(vcpu, X86_CR4_PCIDE)))
>> 		return 1;
>>
>> +	if (!(cr0 & X86_CR0_WP) && kvm_is_cr4_bit_set(vcpu, X86_CR4_CET))
>> +		return 1;
>> +
>> 	static_call(kvm_x86_set_cr0)(vcpu, cr0);
>>
>> 	kvm_post_set_cr0(vcpu, old_cr0, cr0);
>> @@ -1210,6 +1213,9 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
>> 			return 1;
>> 	}
>>
>> +	if ((cr4 & X86_CR4_CET) && !kvm_is_cr0_bit_set(vcpu, X86_CR0_WP))
>> +		return 1;
>> +
>> 	static_call(kvm_x86_set_cr4)(vcpu, cr4);
>>
>> 	kvm_post_set_cr4(vcpu, old_cr4, cr4);
>> -- 
>> 2.27.0
>>
