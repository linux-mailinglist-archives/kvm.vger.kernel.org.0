Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0388755D40
	for <lists+kvm@lfdr.de>; Mon, 17 Jul 2023 09:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230307AbjGQHo7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jul 2023 03:44:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbjGQHo6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jul 2023 03:44:58 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44AC4E7B;
        Mon, 17 Jul 2023 00:44:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689579874; x=1721115874;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ha/T+3C7XF0qfZ8OPOTQvQx/u/0rEsVIgzbRcg8oKEY=;
  b=B2fgeDmPxQV4fSsKhbwgxlrqlfKFYh4BfSbuE9Z3z1txFYI9FLuAvid0
   FbL89mdKDYaFcpu4ogLNaUBeDWbviHmbngDBa4pPkpRs7ELTq0GX1sWo6
   g+0SCcJ9N/+4FradpfzF1/N+2ZqEdHWSpXbn2tlvuVTVsxtcKkaKNspaT
   P++t42lO90qJrykAfQg7ufkT4EMSS5KKwvE0gfVdSKigCMIbGa/nfoHT/
   2s0Nkw4X4QHymFPClzQL3mDLRwVcdzQmNvj09TggnZQjdtaU+rFFFulox
   fvD1sXwIeZWmYse6sq2b8DGc8i0k0FhFiuD+JxQo/ATy5XbgsjlALFksb
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10773"; a="429627599"
X-IronPort-AV: E=Sophos;i="6.01,211,1684825200"; 
   d="scan'208";a="429627599"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2023 00:44:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10773"; a="847188633"
X-IronPort-AV: E=Sophos;i="6.01,211,1684825200"; 
   d="scan'208";a="847188633"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga004.jf.intel.com with ESMTP; 17 Jul 2023 00:44:33 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 17 Jul 2023 00:44:32 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 17 Jul 2023 00:44:32 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.48) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Mon, 17 Jul 2023 00:44:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n8VUoivRBu6vO6u2kgBv+v7E2Lz8Mxd6cARhtd0Rexna2u79wGFR5/+d7RlmCVi14KB4Bm+4edPIXta6irJzHZSX123pBgSzI3y7aDnCV5ot3UGTPOh/vv1ZM4/wlhJTCnzfvO5aWtWf00xRG9nJgyVW60ruiY3+xy0y/kGCTzp0Tg7uBmSmO35DeAcUfNi0iMX6oULsRZM48/iHlqCX57GJkCcNOLpua6/vlj0xNvuhw7Ui+iF4phs4mmdM9XZgeksfuPhKOX5APGa2xt47dPwu8vIX8JqYcU/3Ye6+YZ1fL5Zf9qLE/ktEshfZOqvR6siyRaeqGmzOG8hK8BZz4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H2NkdMlLqpuJJ5dNEcK7pdY2SUJqu5MXoIPzTwYThLU=;
 b=QejpIeX1ylaSNrtD0iVmKwVl3ItqWjLJyubOnUuGFW3n9zeO2T7X7PV317ZUGia6wIE+j0acQ5/JEyC+FaoUbBaSu5C2lV8JehpOLDltU08qld8cOCFOac4ijavLmQrx6X/x7+CiYCdC3TKGMUTvE5JYMlS/lyV1SwtTOnTm9/p4sBbvJFXHGAgVnV+F0rZFg8PzC31Ye/ao5v6JpVYxgHt++zyms9ntLZSwMMISgR1Umy/gKD7AEpR+QxOqCoPMxHvky15RQRZJDjJ0uvcA6u3eB6oPRbPY+hY6a56eIKTHyC026iJUwo6Jym3b1LNhKx0RF7GL/Q1Ppfg/STjXtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA2PR11MB4972.namprd11.prod.outlook.com (2603:10b6:806:fb::21)
 by PH8PR11MB8064.namprd11.prod.outlook.com (2603:10b6:510:253::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.26; Mon, 17 Jul
 2023 07:44:29 +0000
Received: from SA2PR11MB4972.namprd11.prod.outlook.com
 ([fe80::8ef0:32de:3a98:76c0]) by SA2PR11MB4972.namprd11.prod.outlook.com
 ([fe80::8ef0:32de:3a98:76c0%4]) with mapi id 15.20.6588.031; Mon, 17 Jul 2023
 07:44:29 +0000
Message-ID: <e44a9a1a-0826-dfa7-4bd9-a11e5790d162@intel.com>
Date:   Mon, 17 Jul 2023 15:44:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v3 00/21] Enable CET Virtualization
To:     Sean Christopherson <seanjc@google.com>
CC:     <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <peterz@infradead.org>,
        <rppt@kernel.org>, <binbin.wu@linux.intel.com>,
        <rick.p.edgecombe@intel.com>, <john.allen@amd.com>,
        Chao Gao <chao.gao@intel.com>
References: <20230511040857.6094-1-weijiang.yang@intel.com>
 <ZIufL7p/ZvxjXwK5@google.com>
 <147246fc-79a2-3bb5-f51f-93dfc1cffcc0@intel.com>
 <ZIyiWr4sR+MqwmAo@google.com>
 <c438b5b1-b34d-3e77-d374-37053f4c14fa@intel.com>
 <ZJYF7haMNRCbtLIh@google.com>
Content-Language: en-US
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZJYF7haMNRCbtLIh@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR02CA0091.apcprd02.prod.outlook.com
 (2603:1096:4:90::31) To SA2PR11MB4972.namprd11.prod.outlook.com
 (2603:10b6:806:fb::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR11MB4972:EE_|PH8PR11MB8064:EE_
X-MS-Office365-Filtering-Correlation-Id: b2fb740e-9f79-44e7-ad70-08db8699a6e2
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f3HdgP33M1nz8TRVOsXi5OkVMBZfCv2GFobdnai1AN++5nSMEtrh6VxLvkLF+jNDsKo8igWYqFGrnnWVHg+KOA76Mlmj9n1lwhTr9T1dgmFKb3rOVuwSFRkXp52IKSICJBTnV3lfFLn5Te49gmHayPBd0vIkIzJAWNimgDyNwXKe0wBxWCGVVyBTv2K1SPLeZ27mqwHqIjQtqbeGC1fTfAtuLVfwsVZ/QAqEhD5eLyUEMIXL3j3h6IPs4Ip6YE5hFEn+T9WjkZKhtf8uqAvYkBBSReSPDth5t3n5QzFFWmMoGLfACyUwwFX2nPiwAPzUlr3EaBWOXvOwAt9VIEIwqBhPbAw600oQCvcWP1hwTFUlAPcxC6AcyPlnhLEFwk2SPGb0P8AbCkL9g1F19u1qqLLIfWj/csr60UFc7n84BPidtsN8lM6Pon9XW8ppR+te92b4T5tVW2Hjdi8OrB0oB8soVOM3TOPsDIXE58h090S2Rz5f9qO9gVM3Z4JXcJqjWC/5V7kuItP+4ByEM03VhdVyhSXeUYEyhR/CefMAe13CTiz13mrKKxloZuP8Q5KiEI3lyNkbz3slQGP97bQPbO19cK9TKzNHnvM/PmD/hYZyYxXldt7lVtSt/Gsiv3twBYPhCDQKyX4zSeOG9KKFNw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR11MB4972.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(376002)(39860400002)(346002)(396003)(451199021)(2906002)(38100700002)(6512007)(82960400001)(83380400001)(2616005)(186003)(26005)(6506007)(53546011)(5660300002)(31696002)(86362001)(8936002)(36756003)(8676002)(30864003)(478600001)(6486002)(6666004)(316002)(41300700001)(66476007)(4326008)(66556008)(66946007)(6916009)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WUhrVjRPT0JNcmlpSklVbXM0Q3VSM2szY0IxelpLeklnNXg5K2o2WU1qUTdy?=
 =?utf-8?B?RG9KYTBlSjZqMnFKZ0VtbWliUXpuWVVzNkNKNHFLLzZES3dmNnNNRk9weVBZ?=
 =?utf-8?B?N3VDSG5FczBMcnVSWGdnaGEzNng4SWY1WFRwVm9MSnd0MzI4d0xDOWE3TWxK?=
 =?utf-8?B?WUVFOHJ5OTlWNkJYdlBJWURxbTIxdmVpNlNYM2hyTUVpbnA0aVRSWWROQ1Ru?=
 =?utf-8?B?L2UxNlFZMlluTmtIbzk0UTdQSkswaENRZ290MVNzajNQb0MyQkVSKy81NHdQ?=
 =?utf-8?B?Q2xNcFo3OE1IcFFUL3o5Q2F1Vk1wdHZUeVk2VWNaV04yMjRIQWNrYWkwcHBi?=
 =?utf-8?B?N2tPbTE4KzZzTElSV3JGTlVjOGlyUGdncjJ0TlRxSit3QlZEZGRKdkRVbDhi?=
 =?utf-8?B?SktnVHFuRXE3Y1U4MzF5VlgvUzVoaTdxOWlhZEYrYnBNT0ludUhWSDd1SmJ3?=
 =?utf-8?B?bkswamRjT0tSK0QxenVRWVExTDVBMlVoOGZVTi9xTWJLbFRlUWJkcWNyVXdJ?=
 =?utf-8?B?UWtrdTdXUWF2dDdRamh5WDk2NHhRcnZHQXZoOHRxRTRVZmpPaXRqdjZnaDhn?=
 =?utf-8?B?S3g2UVpNKytBbGdhNkZLR1piR0pSWktNN3owN2ptTUJ5SHV1NHE3Z3JRZ29v?=
 =?utf-8?B?VDBWbkhQZEE3U0FBRUxRUVByUlFWUGo4ZGc5SDRoWk1NZFkxdWkzNnVFdFNv?=
 =?utf-8?B?ZXNDbFBVOHRoTDdLMFVaVldGUzdCeXVHRzYvR2FhMlZEb3c3SERuNjZSdm9p?=
 =?utf-8?B?SUlhMjdJQWxqY0tlVm5jcmdudE5FMjl0cExlY1JUU0hEV2Zoc3c5alQ2YTFQ?=
 =?utf-8?B?YVFPbllJYW1KVklrMUdvNDg3ZC9KdXNxZU5Qc2ppL3ZYVnFyTm9vTXdKRmNv?=
 =?utf-8?B?dE5kcm1BYnNEZUUzM1JCcWtlRXpVZjhWOVFLYURnd1hZMTQ1Z0VSRCs5Z1Fh?=
 =?utf-8?B?OUZ6dWRuYjcyK1NVbDFWazdtTW13T09mTTNrQktYTGNPY29ybytWRlF2dWNl?=
 =?utf-8?B?SlJycytnMVp6RmdtQkhtVitxR0U3Q0orTCtQemU0WU0vRkJxRVgxcUxUMnZm?=
 =?utf-8?B?U2NnNVlFM0ltOHR6OXRZUEdGTFYzYlNLVGxyL2lDdjQ3T2t1bDhXUWtxc1Fi?=
 =?utf-8?B?Y09sVldVbGZEZC9kQnM5SW5kNHJDdTVXdGlGMjR4Rm92cFlxNFc2QXBaWjB5?=
 =?utf-8?B?VlpZVUlFOHQzcGpWcVRBNjhIc1V4WTVVUGIyN3FETk1QQ1JtNEx2Y1dSa0tr?=
 =?utf-8?B?ekZHb3UvTXBWTHl3c2hEKzFtajVSL1BYTnlpVWc0MUZIWFJNL0RuT2FhaTFh?=
 =?utf-8?B?MmZRZmU0N3NtNFZVWFhDVjRKYXBUZVVSQ1laZ01jVFBQZEJQNVQvMGliRG9I?=
 =?utf-8?B?ZFBWU0QzSHY0bzJwNzFNM3Z5eGVTTjBWRVA1amViRVFnTEdBeFA3MDg5TkpD?=
 =?utf-8?B?KzMvMXBqZTNaMTg1VjBRQjV6NlE0cGprVXhIUEhCT0UwVnBEU0pEY0xBQmhp?=
 =?utf-8?B?NmpOUjZIbU9ycEJKbUR6NFNsckNEbGNlbFYrQTE5eWJYdTdwZFJFMHBaNGR6?=
 =?utf-8?B?dzB1d0RRMVB2d0ZYTThmRklnekgzTXptQXpsNXNVUlI1UDlHMGpxaCs5Wkg4?=
 =?utf-8?B?R3ZwR2VtRFcySEEwS3NuZDFldGp3ZldnUGxtMW82SGdLSG1SUExibnpiVmhG?=
 =?utf-8?B?RitTQjEvQ0t5UW5EVjJPNGYzS003SUtzcDlmNjhqRzA4THpTaWFybjZYM1Ay?=
 =?utf-8?B?T0I5S0wvbE4zVFVwUmZuRWVzRDdjcXg5cGtjNzhSRVpyUFVrSkJyam5jZ1Nl?=
 =?utf-8?B?WEM1eXZZQ3R2WU9YRFBWWFk2dWtuYmpaWjhQY3pBVDRWVm84Yk9wTnUyWFE4?=
 =?utf-8?B?Z0NTWnRwV1UyQjB3RzA1a0FRZkdFNUlYYzJvWko3TnhqWjI1YmhwcTJyaWM4?=
 =?utf-8?B?ckhLVlpLbk1jc2p5S0d1aUpJSTBBYzFDd0RxeG11Ymo5aVZyVzV0Y3hrVzBF?=
 =?utf-8?B?amszSkdjdHN1aHRaSml1VFJ3SC9Uci9OV1dlNmluaHBRWllEMlZHT1ZpNEg4?=
 =?utf-8?B?WDV4NTdKRDA1KzQxbXVsR056VTBqZFJkTS9HNno4Mm9mSkt0aXk3akM1MXQx?=
 =?utf-8?B?OXpXVHFkNXpsY3VOajdLRWIvbkZnaHNSdnkzQWRtRnc5V0oxYnp5TkIyNnFu?=
 =?utf-8?B?V2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b2fb740e-9f79-44e7-ad70-08db8699a6e2
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB4972.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2023 07:44:29.4797
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QsbiS/4M2JC+ZQbt54FWZfHUE//TofgltIOv1EFUo3SRVHqBXw2uN+6jIMGcCqhDJV9b3vj+ANHy8OMv+C3TEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB8064
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/24/2023 4:51 AM, Sean Christopherson wrote:
> On Mon, Jun 19, 2023, Weijiang Yang wrote:
>> On 6/17/2023 1:56 AM, Sean Christopherson wrote:
>>> On Fri, Jun 16, 2023, Weijiang Yang wrote:
>>>> On 6/16/2023 7:30 AM, Sean Christopherson wrote:
>>>>> On Thu, May 11, 2023, Yang Weijiang wrote:
>>>>>
[...]
>> Let me make it clear, you want me to do two things:
>>
>> 1)Add Supervisor Shadow Stack  state support(i.e., XSS.bit12(CET_S)) into
>> kernel so that host can support guest Supervisor Shadow Stack MSRs in g/h FPU
>> context switch.
> If that's necessary for correct functionality, yes.

Hi, Sean,

I held off posting the new version and want to sync up with you on this 
point to avoid

surprising you.

After discussed adding the patch in kernel with Rick and Chao, we got 
blow conclusions

on doing so:

the Pros:
  - Super easy to implement for KVM.
  - Automatically avoids saving and restoring this data when the vmexit
    is handled within KVM.

the Cons:
  - Unnecessarily restores XFEATURE_CET_KERNEL when switching to
    non-KVM task's userspace.
  - Forces allocating space for this state on all tasks, whether or not
    they use KVM, and with likely zero users today and the near future.
  - Complicates the FPU optimization thinking by including things that
    can have no affect on userspace in the FPU

Given above reasons, I implemented guest CET supervisor states management

in KVM instead of adding a kernel patch for it.

Below are 3 KVM patches to support it:

Patch 1: Save/reload guest CET supervisor states when necessary:

=======================================================================

commit 16147ede75dee29583b7d42a6621d10d55b63595
Author: Yang Weijiang <weijiang.yang@intel.com>
Date:   Tue Jul 11 02:26:17 2023 -0400

     KVM:x86: Make guest supervisor states as non-XSAVE managed

     Save and reload guest CET supervisor states, i.e.,PL{0,1,2}_SSP,
     when vCPU context is being swapped before and after userspace
     <->kernel entry, also do the same operation when vCPU is sched-in
     or sched-out.

     Enabling CET supervisor state management only in KVM due to:
     1) Currently, suervisor SHSTK is not enabled on host side, only
     KVM needs to care about the guest's suervisor SHSTK states.
     2) Enabling them in kernel FPU state framework has global effects
     to all threads on host kernel, but the majority of the threads
     are free to CET supervisor states. And it requires additional
     storage size of thread FPU state area.

     Add a new helper kvm_arch_sched_out() for that purpose. Adding
     the support in kvm_arch_vcpu_put/load() without the new helper
     looks possible, but the put/load functions are also called in
     vcpu_put()/load(), the latter are heavily used in KVM, so adding
     new helper makes the implementation clearer.

     Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>

diff --git a/arch/arm64/include/asm/kvm_host.h 
b/arch/arm64/include/asm/kvm_host.h
index 7e7e19ef6993..98235cb3d258 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1023,6 +1023,7 @@ void kvm_arm_vcpu_ptrauth_trap(struct kvm_vcpu *vcpu);

  static inline void kvm_arch_sync_events(struct kvm *kvm) {}
  static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
+static inline void kvm_arch_sched_out(struct kvm_vcpu *vcpu, int cpu) {}
  void kvm_arm_init_debug(void);
  void kvm_arm_vcpu_init_debug(struct kvm_vcpu *vcpu);
diff --git a/arch/mips/include/asm/kvm_host.h 
b/arch/mips/include/asm/kvm_host.h
index 957121a495f0..56c5e85ba5a3 100644
--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
@@ -893,6 +893,7 @@ static inline void kvm_arch_free_memslot(struct kvm 
*kvm,
                                          struct kvm_memory_slot *slot) {}
  static inline void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen) {}
  static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
+static inline void kvm_arch_sched_out(struct kvm_vcpu *vcpu, int cpu) {}
  static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
  static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}

diff --git a/arch/powerpc/include/asm/kvm_host.h 
b/arch/powerpc/include/asm/kvm_host.h
index 14ee0dece853..11587d953bf6 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -880,6 +880,7 @@ static inline void kvm_arch_sync_events(struct kvm 
*kvm) {}
  static inline void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen) {}
  static inline void kvm_arch_flush_shadow_all(struct kvm *kvm) {}
  static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
+static inline void kvm_arch_sched_out(struct kvm_vcpu *vcpu, int cpu) {}
  static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
  static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}

diff --git a/arch/riscv/include/asm/kvm_host.h 
b/arch/riscv/include/asm/kvm_host.h
index ee0acccb1d3b..6ff4a04fe0f2 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -244,6 +244,7 @@ struct kvm_vcpu_arch {

  static inline void kvm_arch_sync_events(struct kvm *kvm) {}
  static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
+static inline void kvm_arch_sched_out(struct kvm_vcpu *vcpu, int cpu) {}
  #define KVM_ARCH_WANT_MMU_NOTIFIER

diff --git a/arch/s390/include/asm/kvm_host.h 
b/arch/s390/include/asm/kvm_host.h
index 2bbc3d54959d..d1750a6a86cf 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -1033,6 +1033,7 @@ extern int kvm_s390_gisc_unregister(struct kvm 
*kvm, u32 gisc);

  static inline void kvm_arch_sync_events(struct kvm *kvm) {}
  static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
+static inline void kvm_arch_sched_out(struct kvm_vcpu *vcpu, int cpu) {}
  static inline void kvm_arch_free_memslot(struct kvm *kvm,
                                          struct kvm_memory_slot *slot) {}
  static inline void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen) {}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e2c549f147a5..7d9cfb7e2fe8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11212,6 +11212,31 @@ static void kvm_put_guest_fpu(struct kvm_vcpu 
*vcpu)
         trace_kvm_fpu(0);
  }

+static void kvm_save_cet_supervisor_ssp(struct kvm_vcpu *vcpu)
+{
+       preempt_disable();
+       if (unlikely(guest_can_use(vcpu, X86_FEATURE_SHSTK))) {
+               rdmsrl(MSR_IA32_PL0_SSP, vcpu->arch.cet_s_ssp[0]);
+               rdmsrl(MSR_IA32_PL1_SSP, vcpu->arch.cet_s_ssp[1]);
+               rdmsrl(MSR_IA32_PL2_SSP, vcpu->arch.cet_s_ssp[2]);
+               wrmsrl(MSR_IA32_PL0_SSP, 0);
+               wrmsrl(MSR_IA32_PL1_SSP, 0);
+               wrmsrl(MSR_IA32_PL2_SSP, 0);
+       }
+       preempt_enable();
+}
+
+static void kvm_reload_cet_supervisor_ssp(struct kvm_vcpu *vcpu)
+{
+       preempt_disable();
+       if (unlikely(guest_can_use(vcpu, X86_FEATURE_SHSTK))) {
+               wrmsrl(MSR_IA32_PL0_SSP, vcpu->arch.cet_s_ssp[0]);
+               wrmsrl(MSR_IA32_PL1_SSP, vcpu->arch.cet_s_ssp[1]);
+               wrmsrl(MSR_IA32_PL2_SSP, vcpu->arch.cet_s_ssp[2]);
+       }
+       preempt_enable();
+}
+
  int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
  {
         struct kvm_queued_exception *ex = &vcpu->arch.exception;
@@ -11222,6 +11247,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
         kvm_sigset_activate(vcpu);
         kvm_run->flags = 0;
         kvm_load_guest_fpu(vcpu);
+       kvm_reload_cet_supervisor_ssp(vcpu);

         kvm_vcpu_srcu_read_lock(vcpu);
         if (unlikely(vcpu->arch.mp_state == KVM_MP_STATE_UNINITIALIZED)) {
@@ -11310,6 +11336,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
         r = vcpu_run(vcpu);

  out:
+       kvm_save_cet_supervisor_ssp(vcpu);
         kvm_put_guest_fpu(vcpu);
         if (kvm_run->kvm_valid_regs)
                 store_regs(vcpu);
@@ -12398,9 +12425,17 @@ void kvm_arch_sched_in(struct kvm_vcpu *vcpu, 
int cpu)
                 pmu->need_cleanup = true;
                 kvm_make_request(KVM_REQ_PMU, vcpu);
         }
+
+       kvm_reload_cet_supervisor_ssp(vcpu);
+
         static_call(kvm_x86_sched_in)(vcpu, cpu);
  }
+void kvm_arch_sched_out(struct kvm_vcpu *vcpu, int cpu)
+{
+       kvm_save_cet_supervisor_ssp(vcpu);
+}
+
  void kvm_arch_free_vm(struct kvm *kvm)
  {
         kfree(to_kvm_hv(kvm)->hv_pa_pg);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d90331f16db1..b3032a5f0641 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1423,6 +1423,7 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct 
kvm_vcpu *vcpu,
  int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu);

  void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu);
+void kvm_arch_sched_out(struct kvm_vcpu *vcpu, int cpu);

  void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
  void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 66c1447d3c7f..42f28e8905e1 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5885,6 +5885,7 @@ static void kvm_sched_out(struct preempt_notifier *pn,
  {
         struct kvm_vcpu *vcpu = preempt_notifier_to_vcpu(pn);

+       kvm_arch_sched_out(vcpu, 0);
         if (current->on_rq) {
                 WRITE_ONCE(vcpu->preempted, true);
                 WRITE_ONCE(vcpu->ready, true);

Patch 2: optimization patch for above one:

===================================================================

commit ae5fe7c81cc3b93193758d1b7b4ab74a92a51dad
Author: Yang Weijiang <weijiang.yang@intel.com>
Date:   Fri Jul 14 20:03:52 2023 -0400

     KVM:x86: Optimize CET supervisor SSP save/reload

     Make PL{0,1,2}_SSP as write-intercepted to detect whether
     guest is using these MSRs. Disable intercept to the MSRs
     if they're written with non-zero values. KVM does save/
     reload for the MSRs only if they're used by guest.

     Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>

diff --git a/arch/x86/include/asm/kvm_host.h 
b/arch/x86/include/asm/kvm_host.h
index 69cbc9d9b277..c50b555234fb 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -748,6 +748,7 @@ struct kvm_vcpu_arch {
         bool tpr_access_reporting;
         bool xsaves_enabled;
         bool xfd_no_write_intercept;
+       bool cet_sss_active;
         u64 ia32_xss;
         u64 microcode_version;
         u64 arch_capabilities;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 90ce1c7d3fd7..21c89d200c88 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2156,6 +2156,18 @@ static u64 vmx_get_supported_debugctl(struct 
kvm_vcpu *vcpu, bool host_initiated
         return debugctl;
  }

+static void vmx_disable_write_intercept_sss_msr(struct kvm_vcpu *vcpu)
+{
+       if (guest_can_use(vcpu, X86_FEATURE_SHSTK)) {
+               vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL0_SSP,
+                               MSR_TYPE_RW, false);
+               vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL1_SSP,
+                               MSR_TYPE_RW, false);
+               vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL2_SSP,
+                               MSR_TYPE_RW, false);
+       }
+}
+
  /*
   * Writes msr value into the appropriate "register".
   * Returns 0 on success, non-0 otherwise.
@@ -2427,7 +2439,17 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, 
struct msr_data *msr_info)
  #define VMX_CET_CONTROL_MASK   (~GENMASK_ULL(9,6))
  #define LEG_BITMAP_BASE(data)  ((data) >> 12)
         case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
-               return kvm_set_msr_common(vcpu, msr_info);
+               if (kvm_set_msr_common(vcpu, msr_info))
+                       return 1;
+               /*
+                * Write to the base SSP MSRs should happen ahead of 
toggling
+                * of IA32_S_CET.SH_STK_EN bit.
+                */
+               if (!msr_info->host_initiated &&
+                   msr_index != MSR_IA32_PL3_SSP && data) {
+                       vmx_disable_write_intercept_sss_msr(vcpu);
+                       wrmsrl(msr_index, data);
+               }
                 break;
         case MSR_IA32_U_CET:
         case MSR_IA32_S_CET:
@@ -7773,12 +7795,17 @@ static void 
vmx_update_intercept_for_cet_msr(struct kvm_vcpu *vcpu)
                                 MSR_TYPE_RW, false);
                 vmx_set_intercept_for_msr(vcpu, MSR_IA32_S_CET,
                                 MSR_TYPE_RW, false);
+               /*
+                * Supervisor shadow stack MSRs are intercepted until
+                * they're written by guest, this is designed to
+                * optimize the save/restore overhead.
+                */
                 vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL0_SSP,
-                               MSR_TYPE_RW, false);
+                               MSR_TYPE_R, false);
                 vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL1_SSP,
-                               MSR_TYPE_RW, false);
+                               MSR_TYPE_R, false);
                 vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL2_SSP,
-                               MSR_TYPE_RW, false);
+                               MSR_TYPE_R, false);
                 vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL3_SSP,

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cab31dbb2bec..06dc5111da3b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4049,8 +4049,11 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, 
struct msr_data *msr_info)
                 if (!IS_ALIGNED(data, 4))
                         return 1;
                 if (msr == MSR_IA32_PL0_SSP || msr == MSR_IA32_PL1_SSP ||
-                   msr == MSR_IA32_PL2_SSP)
+                   msr == MSR_IA32_PL2_SSP) {
+                       if (!msr_info->host_initiated && data)
+                               vcpu->arch.cet_sss_active = true;
                         vcpu->arch.cet_s_ssp[msr - MSR_IA32_PL0_SSP] = 
data;
+               }
                 else if (msr == MSR_IA32_PL3_SSP)
                         kvm_set_xsave_msr(msr_info);
                 break;
@@ -11250,7 +11253,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
         kvm_sigset_activate(vcpu);
         kvm_run->flags = 0;
         kvm_load_guest_fpu(vcpu);
-       kvm_reload_cet_supervisor_ssp(vcpu);
+       if (vcpu->arch.cet_sss_active)
+               kvm_reload_cet_supervisor_ssp(vcpu);

         kvm_vcpu_srcu_read_lock(vcpu);
         if (unlikely(vcpu->arch.mp_state == KVM_MP_STATE_UNINITIALIZED)) {
@@ -11339,7 +11343,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
         r = vcpu_run(vcpu);

  out:
-       kvm_save_cet_supervisor_ssp(vcpu);
+       if (vcpu->arch.cet_sss_active)
+               kvm_save_cet_supervisor_ssp(vcpu);
         kvm_put_guest_fpu(vcpu);
         if (kvm_run->kvm_valid_regs)
                 store_regs(vcpu);
         kvm_vcpu_srcu_read_lock(vcpu);
         if (unlikely(vcpu->arch.mp_state == KVM_MP_STATE_UNINITIALIZED)) {
@@ -11339,7 +11343,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
         r = vcpu_run(vcpu);

  out:
-       kvm_save_cet_supervisor_ssp(vcpu);
+       if (vcpu->arch.cet_sss_active)
+               kvm_save_cet_supervisor_ssp(vcpu);
         kvm_put_guest_fpu(vcpu);
         if (kvm_run->kvm_valid_regs)
                 store_regs(vcpu);
@@ -12428,15 +12433,16 @@ void kvm_arch_sched_in(struct kvm_vcpu *vcpu, 
int cpu)
                 pmu->need_cleanup = true;
                 kvm_make_request(KVM_REQ_PMU, vcpu);
         }
-
-       kvm_reload_cet_supervisor_ssp(vcpu);
+       if (vcpu->arch.cet_sss_active)
+               kvm_reload_cet_supervisor_ssp(vcpu);

         static_call(kvm_x86_sched_in)(vcpu, cpu);
  }

  void kvm_arch_sched_out(struct kvm_vcpu *vcpu, int cpu)
  {
-       kvm_save_cet_supervisor_ssp(vcpu);
+       if (vcpu->arch.cet_sss_active)
+               kvm_save_cet_supervisor_ssp(vcpu);
  }

  void kvm_arch_free_vm(struct kvm *kvm)

=============================================================

Patch 3: support guest CET supervisor xstate bit:

commit 2708b3c959db56fb9243f9a157884c2120b8810c
Author: Yang Weijiang <weijiang.yang@intel.com>
Date:   Sat Jul 15 20:56:37 2023 -0400

     KVM:x86: Enable guest CET supervisor xstate bit support

     Add S_CET bit in kvm_caps.supported_xss so that guest can enumerate
     the feature in CPUID(0xd,1).ECX.

     Guest S_CET xstate bit is specially handled, i.e., it can be exposed
     without related enabling on host side, because KVM manually 
saves/reloads
     guest supervisor SHSTK SSPs and current XSS swap logic for 
host/guest aslo
     supports doing so, thus it's safe to enable the bit without host 
support.

     Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2653e5eb54ee..071bcdedc530 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -228,7 +228,8 @@ static struct kvm_user_return_msrs __percpu 
*user_return_msrs;
                                 | XFEATURE_MASK_BNDCSR | 
XFEATURE_MASK_AVX512 \
                                 | XFEATURE_MASK_PKRU | XFEATURE_MASK_XTILE)

-#define KVM_SUPPORTED_XSS      (XFEATURE_MASK_CET_USER)
+#define KVM_SUPPORTED_XSS      (XFEATURE_MASK_CET_USER | \
+                                XFEATURE_MASK_CET_KERNEL)

  u64 __read_mostly host_efer;
  EXPORT_SYMBOL_GPL(host_efer);
@@ -9639,6 +9640,7 @@ static int __kvm_x86_vendor_init(struct 
kvm_x86_init_ops *ops)
         if (boot_cpu_has(X86_FEATURE_XSAVES)) {
                 rdmsrl(MSR_IA32_XSS, host_xss);
                 kvm_caps.supported_xss = host_xss & KVM_SUPPORTED_XSS;
+               kvm_caps.supported_xss |= XFEATURE_MASK_CET_KERNEL;
         }

         kvm_init_pmu_capability(ops->pmu_ops);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index f8f042c91728..df187d7c3e74 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -362,7 +362,7 @@ static inline bool kvm_mpx_supported(void)
                 == (XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR);
  }

-#define CET_XSTATE_MASK (XFEATURE_MASK_CET_USER)
+#define CET_XSTATE_MASK (XFEATURE_MASK_CET_USER | XFEATURE_MASK_CET_KERNEL)
  /*
   * Shadow Stack and Indirect Branch Tracking feature enabling depends on
   * whether host side CET user xstate bit is supported or not.

=================================================================

What's your thoughts on the solution? Is it appropriate for KVM?

Thanks!

[...]

