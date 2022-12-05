Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 037AD642A13
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 15:05:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231708AbiLEOF1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 09:05:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbiLEOFZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 09:05:25 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2044.outbound.protection.outlook.com [40.107.92.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2F071A056;
        Mon,  5 Dec 2022 06:05:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dMNxI/LspFMY1xKRGagQ361IsO1ZgieFFp0o/RyXVMhI+6ej4iI82G84JC/ja369AXqO/dL0SqNdm7cB0UiMmAhwF2E6+ZlqADcXy7/T/RHMT5t7xfZ9cPWd8t1BsCiihxhFI3I5/OxcGb0egDiXS4O7K9Nk8hTHUsix1WjUlDZ1bk1U+oT5ykScfZViOE+Q0Yg2N/lBjv6nwau7DTVNXdQDw6Bc/ypaP1eAqNYHZyfJne8arYmXw6cV89xGYriIi4+7qMwmnKFvIBsO6G7mUYkhqwHGbRgCh3qHy3hsE8qhJ1TeGOIyEIuG5FiDkYcUsr2DlxHkONcsnxG3zuOWFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DUbyU2Js/1uj96PFKloL2HOf2Qh5bP1D8lM2xd6Lle8=;
 b=VNtFybfTbCPHESnNDFB2KEk20cW4/yLLOLKntLk/qVQdS/pOLcJ6ahtc00+k9fn+K1BKyriTCVZ7zpLV1CmC6Ee3vkEmyq4NGdsBVIhCkqCrlc/wrBpzRkVS7BsGIL9FP6VDlyQLpPSUmI8/HfMGK5WrE05sT751QMIWsk3rUIA93hyfbFvTz4wCUJ9/vkYWkRZK8qslhHeyRZAXwc7LoT9InNwUL9niLtTj7/UpQdyMtw+m4xENkyUdFbE3MJM64BgqPxh6PMOr4NybZvP66C6AdyS+7CwXdULA4pXkbl3Tzk4ukCg7U24cRE/rkaBu0cnIQPu138XRB6rhjqa2Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DUbyU2Js/1uj96PFKloL2HOf2Qh5bP1D8lM2xd6Lle8=;
 b=GuVNmkk25lUB4CQQcaAPE5VMHL0oXhDFb3/5R/KNE6TigtmBjpBzyGwfPI62iaJwh5054/w8lYHvadH6kpnmVmNsuXDhrosQr1YiD1wl1kyGDIBWLLyLlxdYMm58MMWXqfSYjWXFCLuVc6Z0dvueDZy7ivsOxdAT8uM+hRQn4jE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY5PR12MB6323.namprd12.prod.outlook.com (2603:10b6:930:20::11)
 by DM4PR12MB6637.namprd12.prod.outlook.com (2603:10b6:8:bb::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Mon, 5 Dec
 2022 14:05:20 +0000
Received: from CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::caf0:cffe:94c4:df18]) by CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::caf0:cffe:94c4:df18%4]) with mapi id 15.20.5880.014; Mon, 5 Dec 2022
 14:05:20 +0000
Message-ID: <946d0a77-eecb-5e30-716b-1d6cffd7f12c@amd.com>
Date:   Mon, 5 Dec 2022 19:35:04 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v2 01/11] KVM: nSVM: don't sync back tlb_ctl on nested VM
 exit
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Sandipan Das <sandipan.das@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Babu Moger <babu.moger@amd.com>, linux-kernel@vger.kernel.org,
        Jing Liu <jing2.liu@intel.com>,
        Wyes Karny <wyes.karny@amd.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>, santosh.shukla@amd.com
References: <20221129193717.513824-1-mlevitsk@redhat.com>
 <20221129193717.513824-2-mlevitsk@redhat.com>
From:   Santosh Shukla <santosh.shukla@amd.com>
In-Reply-To: <20221129193717.513824-2-mlevitsk@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0041.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:81::15) To CY5PR12MB6323.namprd12.prod.outlook.com
 (2603:10b6:930:20::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6323:EE_|DM4PR12MB6637:EE_
X-MS-Office365-Filtering-Correlation-Id: e7964ea5-eced-4d58-5480-08dad6c9bec2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JIG2zONbiEhK3IuHeJhzrPGHoZ3IJJCzs758vn5M7UaHzM0r7vOYJk08I13m7lFABFohWjMR+67L+f9phNbeysEUZQCeRhpEbNnttuK83Ieodo2OtxC5r1kHmMWNILEYiTc7La5n1zZG9pC3ef8TbXp8/PtW2E3AfuWG4o6euXwtU+n8BU7C8V66C8Unve9wblXv3p6HjEhnvrpRk9gpSqIX8n4A3nYeg64mybpygKCCHoGfLu/78RjuOzOpFa/d/P5T5UGb7ebZg1GvjHkB4ibaU1jwnmlWS1Bhk+rH9OXvQvCJVNVqFRSJoFRhnf0P3TZoF6jJWSvaqHuAHPQmDJwapXw+T9Zl0ZvWFJIt/UKUPqn9+bIYsnUsJzlsehpi4AoOb30Yn9qjnWQzbh+07WB2oR3jERr1hRaFd9Cm4vh+ufAQWw33AI4C9nd1BMTw/qDPMnnQ41CNJJIptySyp1IySTB2G5NbBPZRqHnOQsdf+dvOOLEqqol1PQ9eyKxAEFumWMYIH++y7di2UOqvasxZ5asLiuTTGc5ASIhT0V2eyt+3YreU+D6NmohFSVgH17UPp2uTwVAWbWgvX0lTDdK6WP2RXZkR23YLSq4uhOjes9LwHV8HJvXWXXib7Oim2XW5XdLkSEINN2W34eoILSNcUosFi+sTuT6cGIQ8n45v+lDZ5VQkb1CCJWKmVtly59UUVBrJEnv2NqQAp9U/dL/cnd0haLtMK8bgXQk9x24=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6323.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(39860400002)(396003)(366004)(376002)(451199015)(83380400001)(5660300002)(31696002)(86362001)(44832011)(7416002)(4744005)(2906002)(8936002)(4326008)(8676002)(41300700001)(53546011)(6512007)(26005)(6506007)(6666004)(2616005)(316002)(54906003)(186003)(66476007)(66946007)(66556008)(6486002)(38100700002)(478600001)(36756003)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZDFlVEhycTVraTRjOGdKL2Y4Nlk2VWNPdnZGQTZXQzBmY2NKYk5VWVd4Rlpo?=
 =?utf-8?B?RUU3NHNvZndWL3J4VjlPOFREVFFwSkVmR2REWmFIUmVEcnlqQWIvVlhESXpl?=
 =?utf-8?B?SmZIQTRGMGZFU1QzdVFaUmwwUExBdW03TVVTQlRYVUZ3RjZMSWxkeDFEcWlS?=
 =?utf-8?B?cWV5b1lFSGlIaHdZdkpIOEwvZkE0Sjh0RUpHcStDYVYvcDVxcWx3Q0NxWEtY?=
 =?utf-8?B?ZzhlVk45SnphSGREaWdtZ2ZiSWVoOVlNUGIva3gyTC81aHhrOVIyN0hMd2Z6?=
 =?utf-8?B?UkZCN2l2RW5UT2hEMSs0U2lxblI0eldNRkF2ZU1oQ3hCb0tMRHFxMzloeHkx?=
 =?utf-8?B?WXRTbXFpYzNOZ0ZWalNKRzFOY0RMMkFlRGk4V0lENHJEaSttOXJOVFg1Z3pZ?=
 =?utf-8?B?MHVERnkvUEFUWGZ6V2o0akNjTnl4ZHVITXFRU1M4ZUk4dndMMWJqS0kxdzIr?=
 =?utf-8?B?QlA0V2FDR09BdkZBOTVaRFdwbitXaFZvQzhnRXl2anFOQ0JtcmRGVHFHSmFv?=
 =?utf-8?B?MmJhbS9BdmZuSndRblk0NGdTZDFkM0kvc2RiWXhhVHNpQVh0bmt5VXMwQnh5?=
 =?utf-8?B?WFhkN3BzckVnVWdweDR5WXpiaFlyVk5paURIb2dnUngydmRKd3k1Wk9aOENI?=
 =?utf-8?B?bzE1TjVGUkh0MUFScTNDS0YxLzk1aDFoY1VDa09hU0xPN0ZnZlNLNGlNUHRo?=
 =?utf-8?B?ek0rUENDRmM4R0ZqbE0yT0NidGpmM0RpeHhGOXpZTXluZHRnWHRjSzFVWjc5?=
 =?utf-8?B?WSt6K2dRQUw1QmJ1SStwdDJsRkdRdHBlOTRMbitLdlR4NVd5OVpvS1J3ODNr?=
 =?utf-8?B?UzFSSG1rQjNYdjdnUm0xUlFiZVJqaEZiODE1MVU5SGtHK2JJOHdxZFJFNFU5?=
 =?utf-8?B?YkVkdHhsNkNCTzFXMHZyU0kwaGRUQklXcEYwYUY0RVc1VzR3cmNxeCs3blE3?=
 =?utf-8?B?SXVnZHpMNVFBUjVhdzZIR01NNCthRGRSeEM3cy9yNmNOUDdUaGliV2ordmF6?=
 =?utf-8?B?WHAvQnM3Y1RMTys2azIvYk9OdlBKWGgxbG5YR1FrekdEUStvdURFMTlBY1Bl?=
 =?utf-8?B?SUFqb2VaSzBPVmx6bElYa0J6ZitxbzYwRTZncG9wZFViWjBPODFWSE0ycG0z?=
 =?utf-8?B?bWFNRHQ5emErUjZzMzQxc2xwVjZ0MG5keFZTVHVwck1JQ2JoYll5eGluY09n?=
 =?utf-8?B?Y1l5UTM2TFdpQTQxWEEzWGZKNW1IdGNPcFFlRVNEbWQ5WkNYSkl0Z200c0dy?=
 =?utf-8?B?ejZkckRLM1c4L3VLdzNnTmdBK1B5eDNUZ0liV2FzZFZ1K3FnMlBBaUM4ZnpK?=
 =?utf-8?B?NjI2MGdRZngrZDk2RWw4OXVBYkVheUtucUNKN01pQkxjeFZuUTFGUE4ranJm?=
 =?utf-8?B?cmxCZ1hJdmtIRytvYVFGVC8yNVpwaUsrbjI0TmdjTXhiN3NQYnBKMEhqSVEy?=
 =?utf-8?B?aGpmMW9MZmFjdmxmaUNNV1p2QlI4ZGJId3lJdE8xbHZENC9IdXZDV2dVanpj?=
 =?utf-8?B?OTFWdmZxY1dscWNZa01TcFF5TFhXNk1jcWhZTDZENHpCL3Zsdmk2eVRrWitO?=
 =?utf-8?B?QUJMVkhVaVlHUzlYRDhreEt1NFhPZXlCeTZQMTZzbkV5Y2RpM1BwOVp4Mm9Z?=
 =?utf-8?B?dStCaUxpREZqYStidGxES0hUZWNSbHo2Q1NlT2ZodzFJcitaMGdiYVg1bkxq?=
 =?utf-8?B?cDcvWFc1NVFUSGowZVBBYlpNdDBqMlpYdjJqWmZ5TXVaSnpCNnZEVlhCM0po?=
 =?utf-8?B?L2t4cE42UllETnZZZlR0K0tuS0pGeEExaVhlTDY0QUVvQ1EwWHU5cUZRdGVX?=
 =?utf-8?B?djE1SkplcVJieGkxK013RHM0RzZTNndrK1VBTmhDVlVLS3gvRUFWNXU3RFE5?=
 =?utf-8?B?VnNKUzREWld2UW9EYTFwN3QwRUZOUTdJSTczb1ZnN203czJqckRoZjVScWR1?=
 =?utf-8?B?ZHlhb1JrT0p6NStMMFBXdUJTZTJYMWhEeHMvZkxYSmw1NlN6RVFKUHJMNTJO?=
 =?utf-8?B?QmtUcHFnL1F1UnVUQ3ZtR0FYcy8rdnRWd056SFpxQ0VYNW9Vb3VNS1RhTHI3?=
 =?utf-8?B?Z2UwWk5QZ1dCRWRmZFVxVElvNjhYNDg0d2VaRG1YdmFIODgyMXJkRC9IK0c3?=
 =?utf-8?Q?kRjGGGe9yNrcXCJRLHyTmrOBx?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7964ea5-eced-4d58-5480-08dad6c9bec2
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6323.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 14:05:20.7599
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Sr41PmYdj0wWxmJvmWm9ueLO3FKEvmPU29NfsytqFbxbYCjKamLHT92C+uf/3xW6YUIBWfBFJn6nnVD7/ujFwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6637
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Maxim,

On 11/30/2022 1:07 AM, Maxim Levitsky wrote:
> The CPU doesn't change TLB_CTL value as stated in the PRM (15.16.2):
> 
nits:
s / PRM (15.16.2) / APM (15.16.1 - TLB Flush)

>   "The VMRUN instruction reads, but does not change, the
>   value of the TLB_CONTROL field"
> 
> Therefore the KVM shouldn't do that either.
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/svm/nested.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index bc9cd7086fa972..37af0338da7c32 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -1010,7 +1010,6 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
>  		vmcb12->control.next_rip  = vmcb02->control.next_rip;
>  
>  	vmcb12->control.int_ctl           = svm->nested.ctl.int_ctl;
> -	vmcb12->control.tlb_ctl           = svm->nested.ctl.tlb_ctl;
>  	vmcb12->control.event_inj         = svm->nested.ctl.event_inj;
>  	vmcb12->control.event_inj_err     = svm->nested.ctl.event_inj_err;
>  

