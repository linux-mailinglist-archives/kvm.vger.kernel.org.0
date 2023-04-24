Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 162E16EC60C
	for <lists+kvm@lfdr.de>; Mon, 24 Apr 2023 08:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbjDXGNk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 02:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjDXGNi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 02:13:38 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23ED81BD8;
        Sun, 23 Apr 2023 23:13:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682316816; x=1713852816;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cUhF+dFXOeGblMLe5iTO7cO8YQjMam+jl1SebiUWfrA=;
  b=eqehyAcj/UazzYqVw6PG8VUZDCM9RymGgu+kmvNSeLM8njDjJ+CPrAR7
   CTE22AcN/SZlj4HqJEXfsi1KnLhVHho2UtuKYFxxdXLsb3ebCk0pPBo38
   AcGLpV6OobkjSpDGNf58e7Awz1Qr1A5Ny8oE1vNXb95gwhsYtbxL6DtCV
   JWbQhwRz9bm2HPqu/4C5KljRwGrG9Msf+wra5FRCGjMIJ1J2EesyY/SF/
   cMCB4wIbgmNHLon+zFcMYeGoucT0dMcl8r031EVkjjrZXGAKc/MJBn4LS
   XsAo+s5hgeY5Qo0q/RJEdQrDxrmUNyURxk9KUNocROycotGw4sBy2r9Th
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10689"; a="335256077"
X-IronPort-AV: E=Sophos;i="5.99,221,1677571200"; 
   d="scan'208";a="335256077"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2023 23:13:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10689"; a="782286022"
X-IronPort-AV: E=Sophos;i="5.99,221,1677571200"; 
   d="scan'208";a="782286022"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by FMSMGA003.fm.intel.com with ESMTP; 23 Apr 2023 23:13:35 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 23 Apr 2023 23:13:17 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Sun, 23 Apr 2023 23:13:17 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sun, 23 Apr 2023 23:13:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PaoKk5F3pwYLye0r5zQfocboKfd2cG99G3I0b5TsHXcLksMMyKxVY4C5SO19TBuGBEu69GUMbCfHEgE6IT/IH2Oqh6dZL80Yjtu36qUaA2WNwccvGhtTOy3aUG8JTLHn4h2vyWMZJY0RP7HehGV6R/hpZ8k3N+Ah1kXWTprF0LCXNBGN1PoqsprTeoUHRRJIbQNXdYZJTfkdlPn1Pmnsa6CLDqt4bNo2bTVqU/jIxUXMZfz3nenPKfV4FG7hham1hLb2+qnXjeW13y3S8d/jhGEByuyLzhSXQsnnSBAKRYjhbWLRM9smMmaa0KApxvtTT7K6rdSanIrLiPRAD5zvlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TJnE4NtzXr3Ijpk5/N5q3bGTXNLerstiggUnAiBxiE0=;
 b=PDw1AYzFhDRywVZQIj2sL3Xe90WjMsyiAjLuFHweJA7SmBPuQI13935ovq9yHiIwFf8qmDmuwzUkEKq1rej8fYcHvXib5jB2DOAlywppNQWWjYfC5ysjb/8zd/Y09TWtsUyK3fe3Tav4UsZhOE/rrmWHcRfnsNQgxWuLcmsymz0n1vv6wQEslFkpy5X9HpEDXjC4m38AuaRDoNZBcGwEKtRJVuzSgNWeqZABkZCyKlfHolmnTZ98GnJFyfsErrG5uD/+TqNCRnCO4b+Q8o58CJjAQCJGLbdMehuzgtOq8QvUKs4A9r8ixOknTsA3Kl4DJ983XJd5WYQSgtt/0TwdKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by SA1PR11MB6822.namprd11.prod.outlook.com (2603:10b6:806:29f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Mon, 24 Apr
 2023 06:12:59 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea74:f9ea:fdca:4890]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea74:f9ea:fdca:4890%5]) with mapi id 15.20.6319.033; Mon, 24 Apr 2023
 06:12:59 +0000
Message-ID: <03de07df-da43-774f-3bb3-632455566053@intel.com>
Date:   Mon, 24 Apr 2023 14:12:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2 00/21] Enable CET Virtualization
To:     Binbin Wu <binbin.wu@linux.intel.com>
CC:     <rick.p.edgecombe@intel.com>, <seanjc@google.com>,
        <peterz@infradead.org>, <pbonzini@redhat.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <john.allen@amd.com>
References: <20230421134615.62539-1-weijiang.yang@intel.com>
 <821ee57d-83cf-56ae-cc49-b8e8fcadf2ea@linux.intel.com>
Content-Language: en-US
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <821ee57d-83cf-56ae-cc49-b8e8fcadf2ea@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR04CA0188.apcprd04.prod.outlook.com
 (2603:1096:4:14::26) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|SA1PR11MB6822:EE_
X-MS-Office365-Filtering-Correlation-Id: dccb71cc-ed00-48dd-0213-08db448af3b5
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9AMr0eo8cE41exoVjrBPJ+rENOGkbo8aabtP+rCfHx03i78XyAcUN+T8rXH+L961w18BlFtdu6wzzdE168RbaQor4a8B/68PE1d2pyGJ0unArsVFJaI1q4Tybu/uRd9pxSqybOMe9IXBTHQdHaoV/rEUGcH2t2Q8JBSIvpjjtH886izsnWTtnzpUWDRailEcHGx/OI1aV3EZx/Esn120G5I/c7tQ6Pka5WKwVZjNBrQz/Aupay4yC/x/JEK4Cr1OXlno9PtPnX3S5/zEuRd+AtBjj6NH8jMJZi2az6XeIwU8RUL2/r7hDN+ZuDeeC+sBzY0v98xJM4Lbcc6iQ/IuQLCvxTHYHi/NnnMEoe6UWntUBN3BLwuqRSBNa6GZvT/vz0jMqhAIy374uWE2TcW4IXPlxkqHWd8fT5bakc/GQzCOJsotqLLo538X1cdqmaKMESxriWmdAqHyPV1EhcU+Wgjr9aKvBTEeZCY0Cdurdbmagh714ROe87FykYDXBIMMHFDK/DaAl/LLjS91ow7yBsahLikPambCNLG+Qw7iUvZaAnt0N/5ysr+L5jB9bo1pNof/98VSCcoqRI2aGSRaZ5Budj1YjCvsSsQGXhlEycjM254XOBCf33OkqFxYKY8l7Xn+tRbvCSAUsO4+b0a6Jg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(346002)(396003)(376002)(136003)(39860400002)(451199021)(66476007)(38100700002)(8676002)(8936002)(2906002)(86362001)(5660300002)(36756003)(41300700001)(31696002)(6486002)(6666004)(6512007)(6506007)(53546011)(26005)(2616005)(31686004)(478600001)(83380400001)(186003)(316002)(82960400001)(66556008)(4326008)(66946007)(6916009)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q092ZEkycmJsVXkwOHF3cnpvYnM2WXJ5eW5qa0dwY3hYcU1la1JHLzRBMVV5?=
 =?utf-8?B?ckk5ZUJ6SEFpcFFqSTNVTk5lb0FuNzNnR0V4M3dUNHRqUHNaS2JTbXJtQ05l?=
 =?utf-8?B?bmRCeVZXNk5QSCtJQU84R3lqOTBZN0VOMHR4RGtEb0JFcHNLaDI5Zm9kYjRh?=
 =?utf-8?B?cUl4K1UxN00wblJzWVowTCs2ZkFUaXdEZW1pZ3pSY3Uwc3FvRTZMbEpyRzZk?=
 =?utf-8?B?cHNuNXJ0TmNnRGZKZDdnLzdMZGtJd29YVW80S2l6cm1qMnhFRjZvUjFFNlEw?=
 =?utf-8?B?SjVSeUxGcG5HaEJSK1JpRlZJRS9YbjRVZE5SNGV2MzNjdnIrN3RXaEY2aXRq?=
 =?utf-8?B?U0NKazFFdUFVZGRDam0wUXM3K2VUZU5sblhUcWFUbXkxd1RkYUo3WWdRTndW?=
 =?utf-8?B?WTgyU05sbWVSc2VnL2dVTVJtNXZDTlhqanB4a3J6aG1abVp4bGhGbzZ6Qm5X?=
 =?utf-8?B?dVhhRlNqdUoyNXhrTDZ2SEtldzZlVVptb2JwckN3Q1VIVkNWdERBdHNEQjBx?=
 =?utf-8?B?N1diVlk5NW05SDZKbnczODJNVjRLY1dtT25hazk3RXJWNDdnV2RpQXJ5UndV?=
 =?utf-8?B?eVpBMWhiVkd2ZnV1Z3g4WGNKSlRhSnp5ZGFRb3JyMjExemtmV2FRR05ZUTR2?=
 =?utf-8?B?YmcvVEpPeE9CNU8zdkdZb2ttdTBxai9pSUJSajUzYjYweHdCNFYxUHJZL25T?=
 =?utf-8?B?T04yb3dYeUhDaW9zWmxaK1plQ2QrTWJ5bmJ5SFdjWTlzU09PNUFuek1WZzNp?=
 =?utf-8?B?WmV4Nyt3ajZOc1phZmk4NGVNRGtPc0FxYS9qa3VFN2E4bzdzZnNPSkRuNjhE?=
 =?utf-8?B?S08rZmdrY0ZBcWM0M3FyamMwYjh6WVBNNytZM3FkZVRyOXNsMFBtVFJ4aGsv?=
 =?utf-8?B?UmlsWU16MmVrdXhwMkZQYWh0QUpZN201YmNWK2I1SXVXa2V6dzNVUW5KcnI1?=
 =?utf-8?B?RlVtTGJXNFlweEFOdDR4UjF0dkU3c3lNSnpCNmVialJMYytWc3dBT2dweGFw?=
 =?utf-8?B?Z1E4WmZzUWtJd1JOU1MvcjdXUVgwQ01xQkJsVkFWeE9oaGl2Mk4zcm5VazYw?=
 =?utf-8?B?SVpRTFBxNTc0Slp4eEJab3FXTGpaN2RocXhvMm9jWUhzUUNFYndDVWVNcHNO?=
 =?utf-8?B?UzUzenNCZGc3UG1MbG43ckZlbndUWlh5bm5iTDJQMTdSbDlKQm8zd1U4TlZJ?=
 =?utf-8?B?L0E4YXpOVFV5bTlNa2p6UWVteVlSMlpjRzBSeG5FM01neWE0V3RGOGQrWEw5?=
 =?utf-8?B?c3FiRzVtc0x0OFZFZ0QvVHJ1dVVZSlBVdERrNlQ3ZnN4YXJCSlJTSkhqY2wz?=
 =?utf-8?B?bkM1a0pMcW0rVzFzRjR5cmplYlNJUHJFMm5RSFJLa0VHYXM4SysyWXUvMEsv?=
 =?utf-8?B?RjR1MExJT0RGVGRhVXN4eXpnWjgyZklreUdxTXhIT1hSSXVxRXJKdnJtdU10?=
 =?utf-8?B?RjY0a09oY2JuenlWVE1sQ2NONnQ3L3FJQjFZRGtTUHVxQWhNOXBMWno1VUp6?=
 =?utf-8?B?aVNQMUwwVGFiQ2l6MC8zcCtXeXkrVC9SeUp3cGZhb3h0UWIza0RPTlo2Qzk5?=
 =?utf-8?B?NWljYUQrcE1QZWFLc3k5TUdia1FvNlU1REwvdkJRSXluSTdaSzJoSm5zYStx?=
 =?utf-8?B?V21mRWIxdnhOMFZSMHFhOGM0dGpVYmJLN1habkwrNkc0SHRMbFBvb0NVQmFP?=
 =?utf-8?B?QW1xUjhZeXd1ZGNUTTFJU0lqOGdpL3JBeE9YRGVxOVFTZXhVR1dobU5IbHZK?=
 =?utf-8?B?TlZxdVQ2WkFOLzdncE9aVWVDaWZkdFBZQjdlWG8wa1Q3N3V3YlNKd0pid0lr?=
 =?utf-8?B?K3RQQi9mcldqZll6Uk44VzBPK0xoYXduYloweWhxVHhjdWJVbW5kVHR0VEx5?=
 =?utf-8?B?dEdyaHU3ZTB0Sjlkd0hObGhQZDk3dVdXeGFUWjcrMFQvQVFEZFpOZ1NsYVF3?=
 =?utf-8?B?NnlwNWt3VWxVMjBCdVJiMVJpWC90UTVMTGxjb0RFckRncUJjTEZFbkE1aXgr?=
 =?utf-8?B?UHVEWGRXNU1GSWhJSVRXTWRQbVFhalJ3ckllUUtTYjNlNHNPZ0VSaWpjYy9u?=
 =?utf-8?B?M2gxY01rcmFmYUx0OEdZTkRPdjVITWEwdEtENlJMeDlKOGxBcnBTNFdYWGl5?=
 =?utf-8?B?eExLSlF3RjZneHJIVFNiSmp2djlzZjlyb2NTYXZuNFAyMnc2eU9iWENIM1Nr?=
 =?utf-8?B?bFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: dccb71cc-ed00-48dd-0213-08db448af3b5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2023 06:12:59.1283
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0diQ3tBj+FkGPNQO2102Jm6HM5croXU5db4OGtS9f1BR/rOygl5DxtNoOQZX3RkuIeEG1Xmlc8Em6pPX697rlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6822
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/23/2023 4:30 PM, Binbin Wu wrote:
>
> On 4/21/2023 9:45 PM, Yang Weijiang wrote:
[...]
>> Indirect Branch Tracking (IBT):
>>    IBT adds new instrutions, ENDBRANCH{32|64}, to mark valid target 
>> addresses
>
> /s/instrutions/instructions

Thanks for review, I'll fix these spelling issues.

>
>
>>    of indirect branches (CALL, JMP etc...). If an indirect branch is 
>> executed
>>    and the next instruction is _not_ an ENDBRANCH, the processor 
>> generates a #CP.
>
> IMHO, it's better to mention the behavior of the new instructions when 
> IBT is not enabled or
> on the old platforms that don't support the feature.

Sure, will do it.

>
> [...]
>>
>> CET supervisor mode states are grouped into two categories - XSAVES 
>> dependent
>> and non-dependent, the former includes MSR_IA32_PL{0,1,2}_SSP, the later
>> consists of MSR_IA32_S_CET and MSR_IA32_INTR_SSP_TBL. The XSAVES 
>> dependent
>> MSR's save/restore depends on S_CET bit set in MSR_XSS. Since the 
>> native series
>> doesn't enable S_CET support,
>
> Do you know the reason why native patch doesn't enable S_CET support?

This bit controls XSAVES for supervisor SHSTK, but the landing native 
part is only for user SHSTK

so it doesn't need to touch it. Anyway, enabling the bit requires 
additional FPU area size(3*8byte).

>
>
>> these s-SHSTK shadow stack pointers are invalid.
>>
>> Moveover, new VMCS fields, {GUEST|HOST}_{S_CET,SSP,INTR_SSP_TABL}, are
>> introduced for guest/host supervisor state switch. When CET 
>> entry/exit load
>> bits are set, the guest/host MSR_IA32_{S_CET,INTR_SSP_TBL,SSP} are 
>> swapped
>> automatically at vm-exit/entry. With these new fields, current guest 
>> kernel
>> IBT enalbing doesn't depend on host {XSAVES|XRSTORS} support.
>
> /s/enalbing/enabling
>
>
>>
>>
>> Tests:
>> -------------------------------------------------------------------------- 
>>
>> This series passed basic CET user shadow stack test and kernel IBT 
>> test in
>> L1 and L2 guest. It also passed CET KUT test which has been merged 
>> there.
>>
>> Executed all KUT tests and KVM selftests against this series, all 
>> test cases
>> passes except the vmx test, the failure is due to CR4_CET bit testing in
>> test_vmxon_bad_cr(). After add CR4_CET bit to skip list, the test 
>> passed.
>> I'll send a patch to fix this issue later.
>>
>>
>> To run user shadow stack test and kernel IBT test in VM, you need an CET
>> capable platform, e.g., Sapphire Rapids server, and follow below 
>> steps to
>> build host/guest kernel properly:
>>
>> 1. Buld host kernel. Patch this series to kernel tree and build kernel
>
> /s/Buld/Build
>
>
>> with CET capable gcc version(e.g., >=8.5.0).
>
> I guess these should be some compiler option(s), can you also list it 
> here if any?

Please check gcc options: -fcf-protection=[full|branch|return|none]

>
>
>>
>> 2. Build guest kernel. Patch CET native series to kernel tree and opt-in
>> CONFIG_X86_KERNEL_IBT and CONFIG_X86_USER_SHADOW_STACK options.
>
> I guess guest kernel also needs to be built using CET capable tool 
> chain with CET enabled?

Yes.

For kernel IBT testing, KERNEL_IBT option + CET enabled tool chain is a 
must.

>
>
[...]
