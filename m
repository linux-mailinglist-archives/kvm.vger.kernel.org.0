Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 082B673F0A5
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 03:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbjF0Bxo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 21:53:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbjF0Bxl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 21:53:41 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D8981702;
        Mon, 26 Jun 2023 18:53:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687830820; x=1719366820;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZUTLKl6pSfYZ8SAyprF3jzXaoVQdeftrug0vBYTA51s=;
  b=heoWtc9B+4ovXfQBCYQgVX3q6NIbWsELTpVlkrRoXJ9VsAT9A865uRbE
   SDZ4/n+Z6Q16nXvJ7YWRrr4N+4TUqtYysI8So8ZKYaRgxpFras7lxT9RV
   PjrFqnI1uI2N/WkeVl9GVBI1iU+P4Nj1OkXVYkFKEuOcZMkGpGabkVLob
   EZ2/RSbwFetjwnpD5iPDFIauwvpI00IEjY+q6w2jI02v8Y1Pq+40Fsie6
   5ahirF5IwulTNZ9umcE8S66X133nrENWC3vFzV2LwmL2oWefPnYF06Iyd
   srG6IpRONn9FigGeVku8GRHiDqTSrFQcni0fc4qcoGNKaK9uKAri7fs2d
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="351227700"
X-IronPort-AV: E=Sophos;i="6.01,161,1684825200"; 
   d="scan'208";a="351227700"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2023 18:53:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="1046724436"
X-IronPort-AV: E=Sophos;i="6.01,161,1684825200"; 
   d="scan'208";a="1046724436"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP; 26 Jun 2023 18:53:34 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 26 Jun 2023 18:53:33 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 26 Jun 2023 18:53:33 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 26 Jun 2023 18:53:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kHJhXfrhUB314PafEmRW3soLNRjjvQhr2wqfhAcWvYeZl25dcq67P6Bw5O9ogpANhSLGep6X3IFjIiSq3ow7W8muhqsRaW8wA3MsXZ9vqwuGp4JpsbcNwb6gSOOhqWDQz74ONhm4UwW92MMQrvTgxJNt6YoPM+nyIkgURFV5sgeoXg5Dsod4mxKElZZSHvhVAQpqtS9ekljBSexcUZEPJ/Ez+xGgFFvXebIAy/KZadkDST4zvotBpZ1BvXgosQjhMhasbbK5EOiJVd/pNRwR11INkqEZOz6OQSow7NG/9t579nsuzN8sUE7/uqp+hRh6qYzvSWZVH5VdmWDKBOITYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x4Nk235S4BpmDDknlaBwarSmHfr/HqdM1WgMeM+Yb14=;
 b=IAYo/9p1BCVk8sokmwbvBwKuhIOjVF73HneZEv7ppJyzrTJaNO14Is04VRrPdkX5RxNabzD1Ee4jBYJ6UwTRJU7CV150u+NQScm+t377QjfYOduRXeIEBcugXWK7ypCJbLzgGLwrfBz4NT9EvEegLZtG4UjBYAPHOjzcsYYIyURLwtFsIXRiKUfVUt+KzpGlPNMqj08VVhX8UBjUZfzajxlU9M9kkb9ImOGLOv3zP8zE9gkK4jXOEv5V/rXbbAZvIu7d+9sCHgJ1TssWkWahfJYyT7e+SpHqpjBWMxPbcPWUXH9z9HykrtUsXIcUZhSSQu7D1QYywkpthDaIQBZB4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by SJ0PR11MB6670.namprd11.prod.outlook.com (2603:10b6:a03:44a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Tue, 27 Jun
 2023 01:53:25 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4707:8818:a403:f7a9]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4707:8818:a403:f7a9%6]) with mapi id 15.20.6521.023; Tue, 27 Jun 2023
 01:53:25 +0000
Message-ID: <7836430e-0698-08e5-77b7-68372463e70a@intel.com>
Date:   Tue, 27 Jun 2023 09:53:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v3 20/21] KVM:x86: Enable kernel IBT support for guest
To:     Sean Christopherson <seanjc@google.com>
CC:     <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <peterz@infradead.org>,
        <rppt@kernel.org>, <binbin.wu@linux.intel.com>,
        <rick.p.edgecombe@intel.com>, <john.allen@amd.com>
References: <20230511040857.6094-1-weijiang.yang@intel.com>
 <20230511040857.6094-21-weijiang.yang@intel.com>
 <ZJYyuBdh8Ob+zzT2@google.com>
 <3b546ed7-145e-6cd2-effe-e17e958cc226@intel.com>
 <ZJn6F93Ed/i18BL5@google.com>
Content-Language: en-US
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZJn6F93Ed/i18BL5@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0004.apcprd02.prod.outlook.com
 (2603:1096:4:194::14) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|SJ0PR11MB6670:EE_
X-MS-Office365-Filtering-Correlation-Id: 7cd0a368-b944-4c3a-a329-08db76b14b60
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2FWWMKECNTDbkSiFTS29pqoWrIqpsEtG/kgmYlPs1udo4DQXOmAa4uGt45E/PI1c3W9XgbXSMSVGPuKQita66Us5Y8Y8qxDcGVOWcFKMWfYXxeInJfq+L6gqvxmN97aluWUDCpyjKZyEdZ1Oc2WVKHYKI8Mbelxlc62gLNQI0Vsxg6USB7bgmmeE+2DA/79VyKb4APgDSP/7YTplM2wlVra0sXdwFyPvqHMTpKrDI7hSCX0BL6vrXdvq6IWqBODeo6uBeUUk4zVh/ayDbkblYv6SIPMEPJeT4WT3lMUSkI6GBXi1XOYj0ftOW+XCfH965HN3v66uJVvtl+qeeRM+++Rt7vnPWSYcGdSqfFoywRDoJs9xlb4gWUPxLxjPtpj2EScKuJmgz0OE0XCvsYtqZIy7f2t0dj9/GOSQEb6XIOmDlRQwe76ipQMvL6ZtvHkM3Ta1G1XqOvYIDxyq0ppSCk/aUuGartf2BlPE8P73gFLMuKJUmBHIOR6xqtJF60R4H2HrrGvlMXHDCC5KRD6A8ApC4JI7YdSh73Cr2EJ8IsrJl4fJk3VLXh5qsPGDv1gHqBipRPka+OZ/rQY30M0uaI10XK7CgQgdIISLVV3blB/LF4E8p/lUV+YpDgc1mlkv6Mw/44xp+fyfc6ALa9oLvQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(366004)(136003)(396003)(346002)(39860400002)(451199021)(6486002)(478600001)(26005)(2616005)(83380400001)(6666004)(53546011)(6506007)(2906002)(186003)(6512007)(5660300002)(41300700001)(86362001)(36756003)(38100700002)(66946007)(31696002)(316002)(82960400001)(4326008)(8676002)(8936002)(66476007)(6916009)(66556008)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SG5ka2NNNHhZOCtKbkcvK3FlOEVyWk82aFVaTHVUeU5EbVBmZHRiRGgyVW13?=
 =?utf-8?B?d2xCeDNLQ2pKcG1IenZHMWlWTldQTnBaK25lbVZQbHdQaytVSWt2NzF3YlBI?=
 =?utf-8?B?L3BWZ1Y4bnBrMTJwclhKNVZrSFE5MGk4UFNlNld0aVI1NjNYVlkwWlFNRUtz?=
 =?utf-8?B?cFVWVDZTMUx4OUQyYmc5bzdrbzVVMTZvVjdOS3drVDE3a2c5VXIyc28rVWlW?=
 =?utf-8?B?czh1MS9EYWdMMVMvU0pKNWVBTXFVdk1IU1I5dUxEK1pFVElpMkMzMjR0WEZZ?=
 =?utf-8?B?MXFwTU15N3ZnVWdyMnpER3pLcGQxeUZPU3NaMmxPcy84MG5GZVVtRHYrOFoy?=
 =?utf-8?B?YzFwcW5RbllpQk5UUEZzTjh1ajBYa015UUpHSEw1MlJ2V2NBekxsUXVTL05a?=
 =?utf-8?B?WENnQ0ZZeFZyRjJEc3dVdTIrRHpiQUs3QkFrcXlpbHBRUEJoUGhPTWdDYzJV?=
 =?utf-8?B?QzRSM3ByTHpJREZXMm9zcy9jSjBZMFR4cEpXNkQwdEQ4Vkxhc1JZbDBGVVBU?=
 =?utf-8?B?MTV2WU8waTkxSnhJQUN1TlZQck9uTlRaamVuT0dTcHExTC9kVUZvVDRFbVNm?=
 =?utf-8?B?R0ZMVmZmRTQrV3o5dS96QjViQTFJZlV4c0xHUzhCQ0QzMnU5MWNUYVlFZkk5?=
 =?utf-8?B?d0w1VGJKVHAyV09rWXJVUEdJNXZUVkV4WWsrSm9wMmowUGxLR0x0Y1FUd1JU?=
 =?utf-8?B?ejdyWUxOeE1uQ3huNmd0TGFyaWt3aHBQZnNja0dvcVhtSk9JWDU0dUtyRlZ6?=
 =?utf-8?B?OXdrRDBJVkhZWVFhM2o2MEF2eGtGckZrT3J4UkpkS1pSTnZtWHlRTGtURW9p?=
 =?utf-8?B?UElDd2tFS3o2YUZEdCtHajVCd3B1MnJJYnpueE0zTnUvK1JxRGQwVEZWTnBU?=
 =?utf-8?B?UmE0azdFM0VISktJRG5SZ3pjUlFWK1JBbjN0YVNGNDdQNGUrRTdWREc2ZUVh?=
 =?utf-8?B?eE0rQUlXNzlDV1dyOEdzbXcyNVRMSUxqVWtsU1VUaFNqKzNPcnBYQnpWYUpl?=
 =?utf-8?B?WUhrb2xYMGIzMUc2ZytXUWJ4ODBRLzBCcS9hK3JWVGxpZnNpaGphVUtmenFB?=
 =?utf-8?B?SE5LalM0VUlzalpRMmpBOVNiZ0FJMDY0ZFhKd0hmMXFUOVBBU0JveTVPdWNG?=
 =?utf-8?B?SGZRSW4raE9zaXdIdmpPRVFpWUlFL205WmJ2am9sRnM1bUNvOVRmaGdDb3lO?=
 =?utf-8?B?MVhNWmYyZFNjRjlpdmpIZXg3QURjRWZRTmNiQ2liMlFDYjVmSUJETy9rT041?=
 =?utf-8?B?TWFncWRxZE5qcTBTR3lVZ0FEMUNma3p0ZkNSYk1mY2Zvb2ZGalJWWW41Y3R2?=
 =?utf-8?B?UnFkYlJXQmRaQ0tDTEpXbHJCNnF3RW10Y3hoQjZzY0plb3VWUzJFcHN4ZjRK?=
 =?utf-8?B?ZWViL2ZhTlA5ZDc4T2IxVkpVTEV4M1RhdE9ldnlsQXp4NkhoRUFpQXJ2YTBo?=
 =?utf-8?B?N0xKcDZIWmdBL2J1bVhuSlA5WExuZ1hPekUza2Z2SDd1dGQ3RmFGa2NyZHRX?=
 =?utf-8?B?UjhRY0MzNjBYOFNSVko1ZXJuN3VhY1puekRvSmRjOUljU1hGNDI0TVh5NmFW?=
 =?utf-8?B?RnRYZGZIYnRlMHE0VU5kK0hlMk5MOGUydmlSemZLVG9WLzllUGVhTGRSQUdH?=
 =?utf-8?B?WWxmMlVrZHRtVGlRTDdRaTc0Q0VBeGgwSWVZZ0pIb3FnNUxTRERzWGFFOFVV?=
 =?utf-8?B?VEptRUUwNHhsY1VVTGh0TllTSk5uajA0UXZUeUs0SEV6cXV1cXNPaWZLR3Jz?=
 =?utf-8?B?UVpLNlpYNzRvSnV3K3JOdVZ4ZGd4dlFaTks0L2E4Z2g1NG1oeHp0cmRHUmJI?=
 =?utf-8?B?YllDYWVKUUpvWitLNUM5ZUlkY2g5UHBqN1NvM1ZMdUtRTVpkU3Q2aTBDb1B4?=
 =?utf-8?B?QTI1WTg5dFNLd29CSUpxOTNjNUFSbzdJVkRzV3pXbW5sOGl3UzVOam1OajRW?=
 =?utf-8?B?RnU4RUprSVNlaEs2dk5WZm1HQUljdjJrYnB1ZGxONktiaXVyQzFmdnBReUFP?=
 =?utf-8?B?OWdmSlJFY0tzZStjYkp1aFlpdmV2blUyVEgyY051bFFVYllYcGJQWk5NWFdo?=
 =?utf-8?B?YTZNSnVFakR6dnJqYnlTT2NpZ2ZTcGZadWZscFVzOUtBdDFYTGp6WmZoUnZz?=
 =?utf-8?B?bHhIVFAwS1NRWlNhY2xUcnVYTE9mUk1DTjBUNXhpQzlKZklmaWdSc3QzV0tR?=
 =?utf-8?B?S1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cd0a368-b944-4c3a-a329-08db76b14b60
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2023 01:53:25.1922
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oSMZtbWR9W/Kdv4vundhbhVnix4EX/B/ViJnpIDFC+Z7WFekNUl9ywK86g7hD0Kp6GCtRUKMEEE+5zR6t2lnAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6670
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


On 6/27/2023 4:50 AM, Sean Christopherson wrote:
> On Mon, Jun 26, 2023, Weijiang Yang wrote:
>> On 6/24/2023 8:03 AM, Sean Christopherson wrote:
>>>> @@ -7322,6 +7331,19 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
>>>>    	kvm_wait_lapic_expire(vcpu);
>>>> +	/*
>>>> +	 * Save host MSR_IA32_S_CET so that it can be reloaded at vm_exit.
>>>> +	 * No need to save the other two vmcs fields as supervisor SHSTK
>>>> +	 * are not enabled on Intel platform now.
>>>> +	 */
>>>> +	if (IS_ENABLED(CONFIG_X86_KERNEL_IBT) &&
>>>> +	    (vm_exit_controls_get(vmx) & VM_EXIT_LOAD_CET_STATE)) {
>>>> +		u64 msr;
>>>> +
>>>> +		rdmsrl(MSR_IA32_S_CET, msr);
>>> Reading the MSR on every VM-Enter can't possibly be necessary.  At the absolute
>>> minimum, this could be moved outside of the fastpath; if the kernel modifies S_CET
>>> from NMI context, KVM is hosed.  And *if* S_CET isn't static post-boot, this can
>>> be done in .prepare_switch_to_guest() so long as S_CET isn't modified from IRQ
>>> context.
>> Agree with you.
>>
>>> But unless mine eyes deceive me, S_CET is only truly modified during setup_cet(),
>>> i.e. is static post boot, which means it can be read once at KVM load time, e.g.
>>> just like host_efer.
>> I think handling S_CET like host_efer from usage perspective is possible
>> given currently only
>>
>> kernel IBT is enabled in kernel, I'll remove the code and initialize the
>> vmcs field once like host_efer.
>>
>>> The kernel does save/restore IBT when making BIOS calls, but if KVM is running a
>>> vCPU across a BIOS call then we've got bigger issues.
>> What's the problem you're referring to?
> I was pointing out that S_CET isn't strictly constant, as it's saved/modified/restored
> by ibt_save() + ibt_restore().  But KVM should never run between those paired
> functions, so from KVM's perspective the host value is effectively constant.

Yeah, so I think host S_CET setup can be handled as host_efer, thanks.

>
>>>> +		vmcs_writel(HOST_S_CET, msr);
>>>> +	}
>>>> +
>>>>    	/* The actual VMENTER/EXIT is in the .noinstr.text section. */
>>>>    	vmx_vcpu_enter_exit(vcpu, __vmx_vcpu_run_flags(vmx));
>>>> @@ -7735,6 +7757,13 @@ static void vmx_update_intercept_for_cet_msr(struct kvm_vcpu *vcpu)
>>>>    	incpt |= !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);
>>>>    	vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL3_SSP, MSR_TYPE_RW, incpt);
>>>> +
>>>> +	/*
>>>> +	 * If IBT is available to guest, then passthrough S_CET MSR too since
>>>> +	 * kernel IBT is already in mainline kernel tree.
>>>> +	 */
>>>> +	incpt = !guest_cpuid_has(vcpu, X86_FEATURE_IBT);
>>>> +	vmx_set_intercept_for_msr(vcpu, MSR_IA32_S_CET, MSR_TYPE_RW, incpt);
>>>>    }
>>>>    static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>>>> @@ -7805,7 +7834,7 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>>>>    	/* Refresh #PF interception to account for MAXPHYADDR changes. */
>>>>    	vmx_update_exception_bitmap(vcpu);
>>>> -	if (kvm_cet_user_supported())
>>>> +	if (kvm_cet_user_supported() || kvm_cpu_cap_has(X86_FEATURE_IBT))
>>> Yeah, kvm_cet_user_supported() simply looks wrong.
>> These are preconditions to set up CET MSRs for guest, in
>> vmx_update_intercept_for_cet_msr(),
>>
>> the actual MSR control is based on guest_cpuid_has() results.
> I know.  My point is that with the below combination,
>
> 	kvm_cet_user_supported()		= true
> 	kvm_cpu_cap_has(X86_FEATURE_IBT)	= false
> 	guest_cpuid_has(vcpu, X86_FEATURE_IBT)	= true
>
> KVM will passthrough MSR_IA32_S_CET for guest IBT even though IBT isn't supported
> on the host.
>
> 	incpt = !guest_cpuid_has(vcpu, X86_FEATURE_IBT);
> 	vmx_set_intercept_for_msr(vcpu, MSR_IA32_S_CET, MSR_TYPE_RW, incpt);
>
> So either KVM is broken and is passing through S_CET when it shouldn't, or the
> check on kvm_cet_user_supported() is redundant, i.e. the above combination is
> impossible.
>
> Either way, the code *looks* wrong, which is almost as bad as it being functionally
> wrong.

Got your point, I'll refine related code to make the handling reasonable.

