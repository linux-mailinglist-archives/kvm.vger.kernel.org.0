Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3EBF76C2C7
	for <lists+kvm@lfdr.de>; Wed,  2 Aug 2023 04:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231656AbjHBCTI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 22:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231660AbjHBCTG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 22:19:06 -0400
Received: from mgamail.intel.com (unknown [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 447112708;
        Tue,  1 Aug 2023 19:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690942742; x=1722478742;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TgVRAgxmS6I36yid7IqHce8McyKjI7M4UGxTLGznM78=;
  b=N1QbGR4PCQkeULJJfZjohYr0OtDFJCZVFCYDScQSXMyibIfp6aMpKS5y
   Qe68Of8Sc7X86T0NGIQ+0PRDBGgD6uaDdl76DqLUz6UlFnR8kdd2gYDV6
   C5Jfdk5amMKUrqceFrkGz66mR0nyqSeHqbXaYp3uVHQCxWc0SJnE8fCNC
   Njqr3kxW/v67gu5UnlcbGNr2C/MTD1pV7FVR175aZzcKemMALBo00fA0Z
   9oRR4eL1NkNSCwUFGoIsp4WkXCcqck21+CKkdhBzaOCi+kBoquTdVDRKE
   YI3zlocLZPpfEEkluru3AIK38krGpRJPv+NavHbaK0TGITB1mv9qNu3yp
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10789"; a="400404987"
X-IronPort-AV: E=Sophos;i="6.01,248,1684825200"; 
   d="scan'208";a="400404987"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2023 19:19:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10789"; a="706006993"
X-IronPort-AV: E=Sophos;i="6.01,248,1684825200"; 
   d="scan'208";a="706006993"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga006.jf.intel.com with ESMTP; 01 Aug 2023 19:19:01 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 1 Aug 2023 19:19:01 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 1 Aug 2023 19:19:01 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 1 Aug 2023 19:19:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=llK2/FbWXEbEc896RwN8n9BXFttJszoqP5oGUbE6d/3VQGpuAQ6ytOEmGagBXNeVnlROISvy9q7UQHQafYnlhO9nYrt4G4F0AKZoUmmvHN2y+n0/sOrEhTJUmOnWBnWGGPiobX8oeWJ7MWs4yEwTZXaDy9YlnnLyfPINVqlrQLG4IlrE/zPYtrbwP3HzkIZGbzymnINtt/X9yxavEFQZ54voUkivHH44kKtoM5OHpWmsRTIF1m0FSDIhNAA6DPQZsZ0tDCIlIcZuRBrb4fUsTZ6QD1ErTaMkXhoKiCfowF/u00/SBJG/BiVuAjl63+K4cDqvMkLxKL5lq0elJoLvNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YlP8N1w6tRbJDrkm3uejxDowgwBX2p1mCS3KqCLWpDM=;
 b=JGpfjlYDtg6aFkpawOtF6vArwklxqFkWfgvWdCvnKu8PD8oijfZeNq82YWoHSophHFdA9blF+RuBYJdIGov29Nd3TKXM08DDgb7K9+ZPCDhSSU2mtbqWqJEyxDb5Ix/Ncqa6FMyK50Q/rUiOz0r8Er0prVoBdsoVf5DuivehvpHSFWHucfHKN/BrjXdkRSKk0Sz7MKYYbSCrrTDC0oSjyWwoxLI8G1CsF65sYLhXF9HbsdkEEyMx8ARljHFMtHwmh04eBpDEPun9i6huj0Wq9h71PKFqFQ8XMNk7ObVdRySZjMkjVAh68DtOtAzpSLvoqhYtjz4G38rHYLI20xILnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by PH0PR11MB5190.namprd11.prod.outlook.com (2603:10b6:510:3c::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.44; Wed, 2 Aug
 2023 02:18:58 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::e19b:4538:227d:3d37]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::e19b:4538:227d:3d37%6]) with mapi id 15.20.6631.043; Wed, 2 Aug 2023
 02:18:58 +0000
Message-ID: <580d2f69-a282-9b01-cd2d-0c46d9e1e8dd@intel.com>
Date:   Wed, 2 Aug 2023 10:18:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [RFC PATCH v2 4/6] KVM: SVM: Save shadow stack host state on
 VMRUN
To:     John Allen <john.allen@amd.com>,
        Sean Christopherson <seanjc@google.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>, <rick.p.edgecombe@intel.com>,
        <x86@kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>
References: <20230524155339.415820-1-john.allen@amd.com>
 <20230524155339.415820-5-john.allen@amd.com> <ZJYKksVIORhPtD6T@google.com>
 <ZMkie3B7obtTTpLu@johallen-workstation> <ZMkymz22bHTsFCTD@google.com>
 <ZMk6xzfVF0C+sTuK@johallen-workstation>
Content-Language: en-US
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZMk6xzfVF0C+sTuK@johallen-workstation>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR02CA0028.apcprd02.prod.outlook.com
 (2603:1096:4:195::8) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|PH0PR11MB5190:EE_
X-MS-Office365-Filtering-Correlation-Id: dc08b65c-c07e-49fd-8627-08db92fed41c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qRjYV0mYSjcjc/L5lbnKg/pWoslHBT3it+r3xRaJUsd9Pyr8JGtulXkl5ynqw1XryaQ+tgaYpyfpqYjIk1fjoMQjEGnswNJGCGXdHe6d1KleCoYoX3nhbP1qkWkb6Fnqnlz39q1VmCmCoNMnONaECR5HzfxI4ZSO6tBNaqrfD1lyCawyg8XGDDeOhFBXh92QjrVpA6MVUFLdskZqWyuhlJC98c4XI0/cZFjuWS+gO0woQt9BaZjHYn1iD44P8/8mIQQbbJlT8BJQYN7mE8Y1F/sEqj0zZJKAQWsV5yP6RxjxNovPuJy+oErNHnWcSoi2IOwKAhOe1FLElv0i5DMTXZ+rjkuz0dMRcSt7/brwdWVZqjahTP5yGGygUGuJ44ZQBai8vaS1aKZ+1pdcH/akF/9imkSILF6qCCngBlOrmxP8t7Hw1cF1o4I7vV6tWSdYF/1DBlyu1rshSJ7GJJSDqVAMTWDoIynrL3TyA9gwhY2g1iJjHvRKwIoYVO5l65XZ+Lprpb7VadnHrfoP+/iS7dyH6oRaws/dGRf3cpVu/J6uPXo5hh3da23NJgkuDv/TOrHG2SDoj6rKhC0kEmEzRj9sTM+dfWUGGQ69zrRBKO2cYiyZv4irmqHFbSS7yeU6jXiK5i9Jlm+etZGNVZAfVA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(136003)(39860400002)(376002)(366004)(451199021)(41300700001)(5660300002)(8676002)(66946007)(8936002)(31686004)(4326008)(82960400001)(110136005)(478600001)(66556008)(66476007)(2906002)(316002)(31696002)(6512007)(86362001)(6666004)(6486002)(83380400001)(6506007)(53546011)(26005)(38100700002)(2616005)(36756003)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eUdPTkROWDdkdEM4VkxmZlFiYSs1d3dxVDVRUzZtUjhHcU1CSi9CaXZkL3lL?=
 =?utf-8?B?QU4zWC9FcENZa3NMV2hIVjhCOVNhZGF3UjlycitwcDgrVTNXM1UzdlR3ZnBW?=
 =?utf-8?B?NlQ2ZGZEWXJ5TVVJMnRNVlBvb3JLdWdUeDdlR0c4Y0c2NzVlQlB1K0RrMXFN?=
 =?utf-8?B?TWF4dUFhaEtSQ3VDenJxeXZDKzY2NStQaDhZK1ZjQ0o1OVEvcjZvazV2V2F6?=
 =?utf-8?B?bFI1cUordWdYVXFhczJsajA0R2xybjlkclA0WUluWkZFWXJydXBBSStER08y?=
 =?utf-8?B?NXpCZ3E1WXNIbHlPVkJhYk9DQ0dueDh3NXJCcUI0bkdXTEhmbEo3L2dDUEJ5?=
 =?utf-8?B?RlM5dDVFUVlCekRvVVZPVDJYajVmNjhxY1dhVDFWNU1vaFpJQ2xjNmpRcW1X?=
 =?utf-8?B?Q0xnd0VjTVRpVzJGbG94QlNtSkdwTUhHVGl2M0xQSkdHbjR3WVozR29NN1kr?=
 =?utf-8?B?cTRyUUxNZnpQYkxkWkpDZEZSTUZWb2RidFdWNHpVSEtnalFNM3liOEpkZnFj?=
 =?utf-8?B?aHFQYU1TQWp6TnZLNGRobW1FcVFuTVh6TngxZ1BIVWVLVXJhbnh1S1N2elZI?=
 =?utf-8?B?Y2x6RUdaSEd6VmhQTEZpUWxRekJQV3FxUzNzSTdicTVFNmdzZU5KVXZiMXRW?=
 =?utf-8?B?dXpjak9WOVRMR013N0p1L05zejJ2U0kvbjhYYXdXL2ZTU3BhRTdkNW15UTdD?=
 =?utf-8?B?TmNNbzUvN0g0UFNla3BSWVhNdExXWld6MVJyck1BMEdMY3hyL2tBdEpSanNE?=
 =?utf-8?B?cXJmK0dmeFdXeUlaR2N2ZlhaTXc1MjN0dE9NN3czQUpjR28yWkt4RHBHY3Bl?=
 =?utf-8?B?R1lQby9Tc2RYcytHQ0dQb1lqb0I5LzQxSFJFSmVEak03dE5nNnNLMnJQcENt?=
 =?utf-8?B?RzBHODJuWlR3ZU83dVE5cFNFb3FhOHVjUFNrUzA2K0JPN2hmTS81Z1dGa3JX?=
 =?utf-8?B?V3JoMFQ3SWgyQXlHWXBsQTQvWnZkaDJnZ3BKZTJzajdBd3krejBWdHViQUdG?=
 =?utf-8?B?aDZUcENqaGdBMmJPQzExeXNkVWJsS2dKUWJ5bU5LZXFESFY2cnNBMUFXSlBx?=
 =?utf-8?B?c3VtbTJ6RWdWQStleGw0SkdwRGdUbm1jVUl1MXVnMzNuV0c4b250STFWdTlU?=
 =?utf-8?B?WTNmRHZISTR0K1BkL0RBQ2Fnc0N6dG5qNVJmYlJWbkp3RDUycmxReDhxekFR?=
 =?utf-8?B?bVU2cG5IYXZQR3ZXZEUyKzNXZHVHR054NlNacEpXOFdZTnM1YmN6dFF1SnA4?=
 =?utf-8?B?L2J6TnJXV2R5cjNTQllXY0JCdGxaV3Urb2hpSVMwb0lPVnEzZ2tCWTRmSlBV?=
 =?utf-8?B?QytMRXVaSU9wamlDcDFyNGtWSXM1MWRmUmN4d3Nodk1jV24xOUZyMmtsc0Jn?=
 =?utf-8?B?M21iWWJCQXlrajFCb1dDZmJINlN1NGdJWUJLWWZRbHpsaE5OVnZOMEdkVkVN?=
 =?utf-8?B?eTBnYWdsWjZPdUhDVGk3ME9EaHNKTmZvL2VDTTBOS3FxUVJNdEp5YVdmMWlp?=
 =?utf-8?B?amY1YnYxbER2Zk5yT2NFZEVWYTgrUC9hc2VDb21hb0JiMk5mQ0JtQUZxNmVQ?=
 =?utf-8?B?a0FFNEZwUG9pNXJza2Z2cTMxd2NjUHFlczQ0YXBNaFlsc1piekRrZE1RSXh1?=
 =?utf-8?B?a0IzVXk2alJiM2pwZ2pnL1dtSGMrYzVwdGkvYWtQaWIzSURzNWpRMWJlWVc1?=
 =?utf-8?B?THBtMDJwc2NSbVJ1SXdONXpkWXFUVWZDQ2FybTJwVFFHVmlONWJnbndwc2tj?=
 =?utf-8?B?SEVUMndrRXBYL1Y5Y3VmWUVGNmdhTUg1VndXSWkzZGw3VTJzM0QwZkdBQzdm?=
 =?utf-8?B?SURlN3J5bjJIeGJKdjZSRk9VTlVzV1hxS1RYa21IWmwxK2JWUW1KM1hiVG1J?=
 =?utf-8?B?cS9OeVFobTRDSEhmTUM1QjNhRW5VT25uK1JBNGF6amhBUG4zZXA5NHpESEtF?=
 =?utf-8?B?TG9QU0ppVXg2V2xBVG9wdUV6ZlZRVXl5MUFURXBWUW51eHd5cE1jN2g2VDRw?=
 =?utf-8?B?TW9UR3Y0T0p5SnZGWERrYklPeWNLR3F5b3RhdHBPMHJaYTlrdHNYM0djckVH?=
 =?utf-8?B?ckZXUzVNVlZvbEZlZ3RIbFdqd1dWTUtqVnUvOVpMRFAwVHVmWVlXci9odHUz?=
 =?utf-8?B?QkozampwVGgyOHFvL0ZSTjRGc1NBQ1pHRTFqbDZ3RXRSZkhkVERnRnJ0ejc1?=
 =?utf-8?B?aHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: dc08b65c-c07e-49fd-8627-08db92fed41c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2023 02:18:58.4123
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iVlwaMiPIII6Cwi1bPLYILj3oFwUs+s8+xkaTs5RufeDpQtti7ZERHfHBQdwSEy9Kk/Ya/zL6AuafuZdenToCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5190
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 8/2/2023 1:03 AM, John Allen wrote:
> On Tue, Aug 01, 2023 at 09:28:11AM -0700, Sean Christopherson wrote:
>> On Tue, Aug 01, 2023, John Allen wrote:
>>> On Fri, Jun 23, 2023 at 02:11:46PM -0700, Sean Christopherson wrote:
>>>> On Wed, May 24, 2023, John Allen wrote:
>>>> As for the values themselves, the kernel doesn't support Supervisor Shadow Stacks
>>>> (SSS), so PL0-2_SSP are guaranteed to be zero.  And if/when SSS support is added,
>>>> I doubt the kernel will ever use PL1_SSP or PL2_SSP, so those can probably be
>>>> ignored entirely, and PL0_SSP might be constant per task?  In other words, I don't
>>>> see any reason to try and track the host values for support that doesn't exist,
>>>> just do what VMX does for BNDCFGS and yell if the MSRs are non-zero.  Though for
>>>> SSS it probably makes sense for KVM to refuse to load (KVM continues on for BNDCFGS
>>>> because it's a pretty safe assumption that the kernel won't regain MPX supported).
>>>>
>>>> E.g. in rough pseudocode
>>>>
>>>> 	if (boot_cpu_has(X86_FEATURE_SHSTK)) {
>>>> 		rdmsrl(MSR_IA32_PLx_SSP, host_plx_ssp);
>>>>
>>>> 		if (WARN_ON_ONCE(host_pl0_ssp || host_pl1_ssp || host_pl2_ssp))
>>>> 			return -EIO;
>>>> 	}
>>> The function in question returns void and wouldn't be able to return a
>>> failure code to callers. We would have to rework this path in order to
>>> fail in this way. Is it sufficient to just WARN_ON_ONCE here or is there
>>> some other way we can cause KVM to fail to load here?
>> Sorry, I should have been more explicit than "it probably make sense for KVM to
>> refuse to load".  The above would go somewhere in __kvm_x86_vendor_init().
> I see, in that case that change should probably go up with:
> "KVM:x86: Enable CET virtualization for VMX and advertise to userspace"
> in Weijiang Yang's series with the rest of the changes to
> __kvm_x86_vendor_init(). Though I can tack it on in my series if
> needed.

The downside with above WARN_ON check is, KVM has to clear PL{0,1,2}_SSP 
for all CPUs when

SVM/VMX module is unloaded given guest would use them, otherwise, it may 
hit the check next

time the module is reloaded.

Can we add  check as below to make it easier?

@@ -9616,6 +9618,24 @@ static int __kvm_x86_vendor_init(struct 
kvm_x86_init_ops *ops)
                 return -EIO;
         }

+       if (boot_cpu_has(X86_FEATURE_SHSTK)) {
+               rdmsrl(MSR_IA32_S_CET, host_s_cet);
+               if (host_s_cet & CET_SHSTK_EN) {
+                       /*
+                        * Current CET KVM solution assumes host supervisor
+                        * shadow stack is always disable. If it's enabled
+                        * on host side, the guest supervisor states would
+                        * conflict with that of host's. When host 
supervisor
+                        * shadow stack is enabled one day, part of 
guest CET
+                        * enabling code should be refined to make both 
parties
+                        * work properly. Right now stop KVM module loading
+                        * once host supervisor shadow stack is detected on.
+                        */
+                       pr_err("Host supervisor shadow stack is not 
compatible with KVM!\n");
+                       return -EIO;
+               }
+       }
+
         x86_emulator_cache = kvm_alloc_emulator_cache();
         if (!x86_emulator_cache) {
                 pr_err("failed to allocate cache for x86 emulator\n");

Anyway, these PLx_SSP only takes effect when SSS is enabled on host, 
otherwise,

they can used as scratch registers when SHSTK is available.

