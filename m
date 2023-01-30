Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 269DB680D99
	for <lists+kvm@lfdr.de>; Mon, 30 Jan 2023 13:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236747AbjA3M2H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 07:28:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232776AbjA3M2F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 07:28:05 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A5AC1C31C;
        Mon, 30 Jan 2023 04:28:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675081683; x=1706617683;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=K8qe9VZV8/vRobBl1U1CU4PJYHabDjaIU6D658ngQvY=;
  b=bDDanayd+588a7UxBmIjxYNu5jve/tiE/Vn+G2m2uNYJhnd3CS9do8ao
   odN7GmYzsdV7ROymSbxFDDaDO2uWjAAXHvrKSWCMaeUm8sjhmNk38/bKn
   /CVUzLA98OKyMua0fUqQoPVlycklzUeCHlMI+b6gc/W4ZV0Ct6LraxHe7
   PaoEnU6hnkToCRO2raCrHX/P/9DDOxpb6TM3akVYVMJcEH5nz5/Ms+knl
   HVGl3veFeOOMb6r9q+NMcF5Hh1+5X6zbebu9sgEaxqG/iYeXgXhUn1URd
   M9y2YF446jeCIluWPq9bfjceTqSp96J/zhOLFIP4z7gchSA+V7NQeOyWs
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10605"; a="325240755"
X-IronPort-AV: E=Sophos;i="5.97,257,1669104000"; 
   d="scan'208";a="325240755"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2023 04:28:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10605"; a="837953126"
X-IronPort-AV: E=Sophos;i="5.97,257,1669104000"; 
   d="scan'208";a="837953126"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga005.jf.intel.com with ESMTP; 30 Jan 2023 04:28:02 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 30 Jan 2023 04:28:02 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 30 Jan 2023 04:28:02 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.45) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 30 Jan 2023 04:28:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f3NV5pZTWQcKzV2J08J/oOd8SYHNYBgW+Nr+JMY3sTsLG/JKfSJS4HvkyYNoAOXiwj/4J/p9cu798L0LQPdcwDo3hY19r6t70AUD4POlIFvCr1QQhBSpzF2YPhn0uBxfB5i4gsbEt0TyU2AdXeZpxVYf4lj2ox0P7CWFGv+MT7ZqpwzvrKfP2E4ocIQeDZna0cVupyAhzu0BXVF9935Zyg9ekvSM+CXf+kZiW4Q35LLMbe3SyGWCzlwrTZ12v3nO1LPxRWRUrLtBKcRNVP4NMOEnPfw5Q90e+164U0W7ynq0NUnaErtb+ifFYZt+4UUIJqggWJ+LLdL8pXi4osBJSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dt9MXog8wnCFlZIsOvCg5jeLbG93apo8bbfPSPuSrqI=;
 b=NS02IxpY7lO4UmwrUVLazhcGRzUq/yntNyFt3dndIQB124Vrmx4+APqSJZmq8lnyrXFZP6w/aOHvhfSW8NJzYvZ0WQyUsbaoiHZPmQbFC4fJgvzjhj+3pbtjSe+fxE+vwPYC9L9iYNhDJeoBchTU4QukZ1NYkYlQ6TP7Zn824L7TdDa2VUp21fHADEdqBf8/vXP4p0gUaIFqoa97onYQ0H23m+d2+pLt9DsUnfL+h/8Jl8OrZuuqfU0R2pFtjBCQyy3wm8sMcWCqt4e1ImiYLLUm/EmdBVvppx9lnpSk14kTvRC1Oim6IRoYXlNaIis3FzxTEvJ5dlhF6hpyNiAwhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by MW4PR11MB6690.namprd11.prod.outlook.com (2603:10b6:303:1e8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Mon, 30 Jan
 2023 12:28:00 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::7d42:36a8:6101:4ccf]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::7d42:36a8:6101:4ccf%2]) with mapi id 15.20.6043.036; Mon, 30 Jan 2023
 12:28:00 +0000
Message-ID: <691a2870-8fa5-be85-55ae-31b2c5eb4f69@intel.com>
Date:   Mon, 30 Jan 2023 20:27:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 08/15] KVM: x86: Add Arch LBR MSRs to msrs_to_save_all
 list
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
CC:     <pbonzini@redhat.com>, <jmattson@google.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <like.xu.linux@gmail.com>, <kan.liang@linux.intel.com>,
        <wei.w.wang@intel.com>
References: <20221125040604.5051-1-weijiang.yang@intel.com>
 <20221125040604.5051-9-weijiang.yang@intel.com> <Y9RFngDO3ip9vTwi@google.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <Y9RFngDO3ip9vTwi@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2P153CA0011.APCP153.PROD.OUTLOOK.COM (2603:1096::21) To
 PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|MW4PR11MB6690:EE_
X-MS-Office365-Filtering-Correlation-Id: d941f568-a643-4c73-fbd6-08db02bd6cc3
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +6TzAB+CybWvDiKJ1+yk/JKlvN3vWFbu0njHMZBLkc4KQeEN6z/nM/OtHb+f6K0SGXUTZ3kxtd1gQ0sfA1hyOvJmpdf3pqQuY3BWJ4fQ6oVELLMoJGdPZXcViT6HhgMUxStBSLS+P6LNMBiXae/lCeyOOpRfHesBKGFt+PR/GGh57cCb9TgC6kzio2Nw6yIi9VSeFWCah7R23TSgilTuCtc8E1l3ore9jkiYxkuxhrgQClnA5YOEEHfvi02ly2HRSOe4diKaMytbQlklTzw2I9M/e+hhE4MXSR8/O57EfKvO31jf6XZRLSL5ptfflrp9549bcHMJJ6TJG/jgXYIVWtkxpdnSXNK9/fLys7SyMVC7k3YIV9JAN9bDIPc1+cwUHY6a0Oe4NGJuagCXXtggXVoDEy9yC9MU2gFfpvHGW237KIz3JsRJpETeTBtDuJOaXjzgO/zL1uNIS8EdU6WYQPapKUjtFlqu2R6GEyqBNPR8GJlffrcNTcAiZJtVn24Kswkm8L68/I0F6L8CyXDGlrH/kaBjX/WHDLeZOM7zx119Q4Jo2hRYER4PDjQySFLSUYg1Kd4bFO1jWRfNhz5HjAB3IbmbFZL9NUkdmduxVWrRUrIx7Ih+SmyAtIw1l72wXCKGk4fbUE7boYEwEtwHZuWCi75c5X5ePdruNuC5rW5p8dQRqzXmQcCftAts3pD+1Znu5mtefYx6ygSHBMZ2XDwAjDFZghBJ2Wef2O/LNZg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(346002)(376002)(396003)(39860400002)(136003)(451199018)(31696002)(31686004)(8676002)(66476007)(66556008)(6916009)(4326008)(41300700001)(66946007)(8936002)(83380400001)(478600001)(86362001)(82960400001)(316002)(2906002)(38100700002)(6666004)(6486002)(26005)(6506007)(53546011)(5660300002)(4744005)(186003)(6512007)(36756003)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SnE4cHkwNFR5V3l4R0ZNVmZQQm5ZZ3hGR3crbE82WjR1OHc5eVJCWjNVVllC?=
 =?utf-8?B?OHljcVNQTENSb3BsYWhWK2I3N1A1VFBTTWlmY0UvUVhPbys1d0lMdFRuWnhJ?=
 =?utf-8?B?ZjBwUlFlTVVxQSthM0wrdkV0T3pVVWIxUExUK2x6eWxCS083d3lNRGdESVFX?=
 =?utf-8?B?ZjNab3piOG9mQThaYmRvRkFhbkIrNG1tL242c1NBandabUpDa3N5NVlOV1di?=
 =?utf-8?B?RFgwS3d0NnZoRzJ3WTFnNHIvK2VsM1gxQXdETXgxUitoZGdZR1dGV0V6SWlZ?=
 =?utf-8?B?WE9LT01nakxRdkpGMTRkaS83OVA3TkQ5SmppWkVRajJqT0QvVDZDUUNlay8x?=
 =?utf-8?B?NXBYOUlJMGFISzZ0SnpZU0l0eVY4OXExOTFwWDZZTldUcHZEUmdlaDAvZVZv?=
 =?utf-8?B?S3NwUVNNVWhta3h0N2I3MnZrVENMT2N4UXFISGN5Z1lkWlA3dTNFMlFyeWE1?=
 =?utf-8?B?OWRYbGQxeGtwYmZKT1ZJdUwyeThYa21USHI4cE9pai9rQWtLWmVYdEJHT1ZQ?=
 =?utf-8?B?b0NjSHZWTllzZTQ1U0h5azRONG1BOXp3QmNNMUFpb0FKOExBci9nQUJMNG1h?=
 =?utf-8?B?eVJ3UXpzbGtmWTFCSzNQQ3lLS255V3ltLzF2Qmx3dHNxWkZQbDBNRk9jQ0Ew?=
 =?utf-8?B?azBxYzZJUkpBZlVtYllqWXRtVTIxdkxUT1pNQi9oSjhIZEx3WGM3d2UyMHlt?=
 =?utf-8?B?ckgvK3lQVndrWU9URmlmekRQbVpEaTc4LzVnc1phK2E2Sk1xVXRJaU15WSsz?=
 =?utf-8?B?MUtoaVZHVFFCemY1K1JQSm40NmNPRnJrTGdCMzRPbk5qdUp3ZnZuemIvdm9Q?=
 =?utf-8?B?NlZIaHNrN3pRMnVXaGZCZTVJTUQxYkgyR1RCa2JlRkpNTExMV1pueW1jUUE4?=
 =?utf-8?B?SmZGSy9tclVVcGd0aXI2TVVqUEh5S0Z0a3plK2JoalNPbVJwUk1Eek1oV1RX?=
 =?utf-8?B?Nzd3QUpRU1RNazZRYnY1VlZrNmx3VmRWbVB0SkVrMmwvcmNqcGtCUnJmS09u?=
 =?utf-8?B?QjdwVFpjY08rZHdFWEdGNjJCb05qbHNrckZEd2kzVWlmRmJQKzZoV3hrSDNS?=
 =?utf-8?B?Y1NndWRIaTJzZmZJR3hMNyt4OU9nZ2dSOXVNSEp2VGN3c291SWtmWmdod1lz?=
 =?utf-8?B?eWQyU1FPK05KOWo1anRGQnNmeW9nSTJSZ0M5TXE5RkVnbTh6UFZKYXBPK3lD?=
 =?utf-8?B?UXE5aWxsNWYzSEhnMS9HZWZNSE5NQ20rZnFXdkNVNUl1MHo4RGU4bHcxejVm?=
 =?utf-8?B?T0hwOG9GYkwxZkV2eGdhV1VTZjU5QWZzOXJBcTlKR0JURnlUK3JiTk04b1Zx?=
 =?utf-8?B?QWswMzJTUVdidmdxK09LSEg4VzFIbXN0WG92RGIyMEVKRXV5Q2xhcTBGQ1B3?=
 =?utf-8?B?NVdYaXAxeVc5MU1yeHMyWEdYbi9wd3grNXNxa3g5RnlSdFoyN3A1dDRvVkV3?=
 =?utf-8?B?dEdNeEtoVUg5SUpiTThVZGk5akdnbTJ0a1lraGNiekJSQkx2KzBlRk5Bc0dK?=
 =?utf-8?B?a3FJNEs2OWM1SnhkaDFhcUFSK0JHMmh5U2pxcHRETFdGSWIvcUlLUVh4bzZX?=
 =?utf-8?B?MTRDcXpxUmxieXBJSG9wd0pUbzhIbVlTOUtUaTFtSVd4dkhwVllmYldjQTFH?=
 =?utf-8?B?TllmbzZteUltRTRTZU9hUXhGNkFiNXpaajVEdmllNGVxRVhzSFZmOUlWVE05?=
 =?utf-8?B?ZldKU3BFakNvWUZhWUM0blpxTWFEbDB5M2lBNUE4ckF3Y2Q0VDJUM2Jld2Yr?=
 =?utf-8?B?bWNTaHhQYVd5cG8zUVdSQ1VaUzdkelJ3RGtKblZrdnhDTm95RGpRSjlzdzFH?=
 =?utf-8?B?QXVWY0xsR280aUQrc1Q2YXN1OEoydHZwUVFXS3E1SDg4WFhYMjNnVmJTSkpU?=
 =?utf-8?B?OE1xVHZ3TEl4Rlg2RjRQR0VxUTBvWGphWWNDNTR4ZnhDdDA5MlYwRnNMRlhP?=
 =?utf-8?B?ZVQrdnhielBtRmNuVUZKMjNndm5JdmdzdzVsMjc4eFRFQmN3Zy9oK3RQL0c5?=
 =?utf-8?B?QVhUeWZuRjF4elRaM2pMcmhoOUJ2RUtSQTlzNjVUYWNIN3k5T2tqa0NoSjl3?=
 =?utf-8?B?K2YrZmJqcWM4amtGYW50UjcwLzdmMGtsMkZCa3lIU00yQVl1QkFtVmZlTFQx?=
 =?utf-8?B?VTJqaEZ1RG5RM0RTekFKaWNLSXUyeGxsdjR6TDc5bWR5dnVBcDVkcE9DQys4?=
 =?utf-8?B?SkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d941f568-a643-4c73-fbd6-08db02bd6cc3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2023 12:28:00.3508
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SgujvXA8bnJANjQoUdZQDhe/UTcCOeBSLHc7x8BVzeqrpkq3KjMNOWePetN6WQISCcpAGiYTb0VjhuMQJy4tbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6690
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 1/28/2023 5:43 AM, Sean Christopherson wrote:
> On Thu, Nov 24, 2022, Yang Weijiang wrote:
>> Arch LBR MSR_ARCH_LBR_DEPTH and MSR_ARCH_LBR_CTL are queried by
>> userspace application before it wants to {save|restore} the Arch LBR
>> data. Other LBR related data MSRs are omitted here intentionally due
>> to lengthy list(32*3). Userspace can still use KVM_{GET|SET}_MSRS to
>> access them if necessary.
> Absolutely not.  "there are a lot of them" isn't sufficient justification.  If
> the MSRs need to be migrated, then KVM needs to report them.  If the expectation
> is that XSAVES will handle them, then KVM needs to take a dependency on XSAVES
> when enabling arch LBRs.

OK, will add the full MSR list.

