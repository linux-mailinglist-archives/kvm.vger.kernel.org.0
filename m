Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18F8A5A2C48
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 18:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236250AbiHZQ1P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 12:27:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbiHZQ1O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 12:27:14 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2051.outbound.protection.outlook.com [40.107.94.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0395FDF666;
        Fri, 26 Aug 2022 09:27:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GKU6ESjdL0+YStCscr3HiXGV19sqiuMEwkpOsNYJi6zxmVmPCqhQkyTro83DYn2VpAUmSLShijW6+BKS9IxtXA4sBeQoLi2hum+MI3JbD5W/GFSjOvDNzw0KaCQ+do2mzicULoNNJZRjo1TVJB2TPFMdmSkdOalX90U24u77rjSY4kiabJe0CoECUHXNZztiDPYaVKQO0VFRYF9V8Eoeims09ZVT+yiPfKtRMxHx8vpUHqMOOQ6FC1MxHvsi2KGgl2BUjb3FJ7gP9lIRshtMgAKuSJkkpJuafOToFzKs4087AeLVHDFT7+bzyaGCr8ZJzihtLAnYo8VdIcpa0gWX+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pN9JGd0WjS1w7wm89J6a/gNDMaNcRy5Uv/ULeqMcRFI=;
 b=Towtgx4MAB/dTehlquF0MQWGiS1Rwc5JP0We9M4+S2EJkXpo1UeiJ5mgWnMA/6mjugeVtc5w/veeMFAuep1/XWeJ24Llw4V8jlhxBmGQdxqAxidoHta4CTcQP8nrPXC++viJjgYN+ErdKeCtBov5xiLOVx6MUPEUlEKv0yxfdIKD76Rda6S4E7hotkh7l8H95hVs2CApGk5ytG7Oi2gTGbzkkrC6+DGzi2tETWvmrZ6/FJseffjL5bRf6iinwxRXFtRlQY7dnzhUfIWrQ67TM5mjSepnRGW+yb6sj0tv55Gkpg7+yepfKTgMQyyrq6TFEVVacjY0lGM9GE5zF1c/gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pN9JGd0WjS1w7wm89J6a/gNDMaNcRy5Uv/ULeqMcRFI=;
 b=zy8izXhX+UPfGspaI3EoRYxzn8m5Q7rMvrfxyJpk2x1aFzu4yqwIovjmLIJaXdm2ta+MGtgiopA9AFwSPVuCKYskNAYT682WwKgO7u8D77ARwdXD9r4TfMzDpasXuYyoJdJCPPFAiVYynMRIty+dh6eHqKoby6xMSscKgOV9rDg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY5PR12MB6323.namprd12.prod.outlook.com (2603:10b6:930:20::11)
 by DM6PR12MB4732.namprd12.prod.outlook.com (2603:10b6:5:32::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Fri, 26 Aug
 2022 16:27:09 +0000
Received: from CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::1901:1d1e:a186:b37a]) by CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::1901:1d1e:a186:b37a%6]) with mapi id 15.20.5566.016; Fri, 26 Aug 2022
 16:27:09 +0000
Message-ID: <a1412227-151c-dc2a-1592-3eb71eb9f24f@amd.com>
Date:   Fri, 26 Aug 2022 21:56:55 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCHv3 5/8] KVM: SVM: Add VNMI support in inject_nmi
Content-Language: en-US
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>,
        "Shukla, Santosh" <santosh.shukla@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mlevitsk@redhat.com
References: <20220810061226.1286-1-santosh.shukla@amd.com>
 <20220810061226.1286-6-santosh.shukla@amd.com>
 <bf9e8a9c-5172-b61a-be6e-87a919442fbd@maciej.szmigiero.name>
 <e10b3de6-2df0-1339-4574-8477a924b78e@amd.com>
 <f96b867f-4c32-4950-8508-234fe2cda7b9@maciej.szmigiero.name>
 <1062bf85-0d44-011b-2377-d6be1485ce65@amd.com>
 <3752b74b-74e1-00fd-d80d-41104e07fe95@maciej.szmigiero.name>
 <ce3c852e-4ee0-36df-383c-0957a6e02a6d@amd.com>
 <ddbb19b8-417f-f839-591d-a0610ea9629b@maciej.szmigiero.name>
 <ca464c8c-872f-f86b-6fca-7ef7b374a304@amd.com>
 <d30192e4-9e12-f770-e944-e3c38b9514b8@maciej.szmigiero.name>
From:   "Shukla, Santosh" <santosh.shukla@amd.com>
In-Reply-To: <d30192e4-9e12-f770-e944-e3c38b9514b8@maciej.szmigiero.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN3PR01CA0123.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:96::13) To CY5PR12MB6323.namprd12.prod.outlook.com
 (2603:10b6:930:20::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9ec63181-e7fa-4212-eb2d-08da877fd26f
X-MS-TrafficTypeDiagnostic: DM6PR12MB4732:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: npQkxEaGecuV1cDSUf82yCY6SvrfdkjJ0uM3V4baG14y/BkhYJoGMijGM8+d6TCXaG3JYYW164WOeXm0YcnHGHfAp79zF1LFSWp4ysYdOrXwnaPu8PWsa2NIhuQkwRykjsG3PKLjMhsQlKLjZNt3UZ3Tmgf3RNdYUsk5OJaSCTlP+gl8C5fG2GVSBQIfGDFnCv4fCmxjj4ra1ouDJwUi3jlEpwphX4ecWgKjFhpJn0MYQwCdwv32LsNvUcG+zhwOVGEhJ71bsMhBYak3QAc2WsLqprrmB8S13E4O44XeWHHuZWDDUAwH/4Rma3i20X1tJed8rbr8iWFHxHepf7r6t0Yiz5k1ZLG3Rw60njw5lRr0RRqFdl45GxWNvjDPQ/qMyvj41x4cIyF2nLeg5y4UL2GvvmE0RrtrPzgklq48h77ocTjgisozDU07MmXA24A5A4vt2ztrmSXlrS8iWfNYRcplRkKz+aYFhWo6qWxAlcRnNrgBElXuLsh/vX+bYKU+txZae8P/AFCZ6fGCkpTddNJoaA2Sb1+hASy+MgeYYLwpt9LJprIl4lDFFgegy99Xsp3VNMRW15DdJAEWdRMYgf4aKh0oishrRWyhroLoaPd4gO7OMobEpk/xGcaOd4VeLDStBwng+AgARpUS1y8TJrdeQj7hd5MbhEN6/OHT/e+mkfKuGzWsmR7s8mPWEajpxb8gLrRbXXH1iGiA3d8e225mRdDDPAMV59hdguGX338W3+F5JvJgYqwNhTTmc9BzK/hQxN86YLrNRqwLTWT78mjFH9cKfK3JI68Hu5dMdpc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6323.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(366004)(136003)(39860400002)(376002)(36756003)(31686004)(110136005)(38100700002)(54906003)(66946007)(4326008)(66556008)(8676002)(66476007)(316002)(31696002)(478600001)(5660300002)(6512007)(86362001)(8936002)(2616005)(186003)(41300700001)(6666004)(53546011)(6486002)(26005)(6506007)(83380400001)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NUpkb3dFVVRFbW1rQnBrdW44VFRxRWdBRndxQm9IUTdzYW80ZGlhMC9pUlFR?=
 =?utf-8?B?ZWh2NFc1TDB5S3hCWnBwNmRoUGxVbzdyc2VHd0J6cGdjbTRiODhYRXZVWWJq?=
 =?utf-8?B?STRpRmJ0dUJoSFBWajRJd3hNc1kwdDZyZlU4SjFqMmFvcXEvVGUzVGlXNmd2?=
 =?utf-8?B?dGRIM2JCQ21ZZkJicU5hakJUKzh0MjZwWW9NZGNiRlQ2Zzg0TC9vM1ZySFgr?=
 =?utf-8?B?bWVsUXArUnVldkFuR3hWY0JoZUpFdUVBK2NxVkZEaFRpR0lpVTBCazJhMkFt?=
 =?utf-8?B?elNCWm5GRXhGV0FwK3B1TmVhUGlpS01jQkI5R3daYlVLVUdMZkxxb0g0M2R3?=
 =?utf-8?B?ZHdxODNyVjVEUDhwd2pMdXprSkZ0K2RORUJuMDgvM0FBcG9HcEx3dWx1Tksz?=
 =?utf-8?B?VWRCb1k0dXVPeXQ3cFNVUmxtT0RmSGVZK29RTGVZTG5nWFAzZUFIajFKNno4?=
 =?utf-8?B?d1RGeElvRjF6SFNMUDRZUWFHTDNYNlppTTFjbUp4TDRDOTVHbHBoQ0hCZ1Yw?=
 =?utf-8?B?a2p0MHNqcTNpZnpxUHhyTUtlMWgyL0lPcUZmd0hneWdtNGFGTWJ1ZzFMWWd1?=
 =?utf-8?B?QlJaUWpDNmFxVTNZTUo5U08yUG50cTliWENuRFVzM1VhQThreFpWanRuT28x?=
 =?utf-8?B?OExlMlNoUFlLeld6elU2N2JXZmVMajArZzQ2OHhGaWtNWUNTWWhzZ0J0UVZx?=
 =?utf-8?B?dktlWEltVlQ5MGNxcW5nTmd1Q2ZSaytRSEtsUW02TXVsRW0wQW9mdTVTcHJC?=
 =?utf-8?B?YmVhaFZmOVc1b3R6ZkoyMkhQb0pvYXMxYVYvM1RvUVVVRVd0UDd3d1lsRTho?=
 =?utf-8?B?NjhORS9kdlExbzhrZHIrd0lvRFhMbVNaQXdrNklzK2VKTkVvdnBUUU1KSGNM?=
 =?utf-8?B?RTZvMktjYkMxUFplZnQ1Q1Fsbjd0Uk1lM1ZUOU1OaVNMRkdiNTBkK2ZhTDd1?=
 =?utf-8?B?K3VBUGpjUGNpMnU4YkpSVFlXZEticEZQdkZ1UEZUdEV0UUovS3BseldwQkk4?=
 =?utf-8?B?YVRYL3RaV0lmeXIyaDQwYzF1K2cvRkNuVkRGSW1VSTdwSldRaWlYSC9IMEJL?=
 =?utf-8?B?Tkt5NFlhditJMllCV0M1Vk01eDJ3bXhHbzB4aG5wT3liT01iVUNrVDVUc3g3?=
 =?utf-8?B?QmFlU3lUQVM1Zms3SDFDR0FHVGxwSEhtQStOODVCVUwyVFp3dTNibWZUOElx?=
 =?utf-8?B?eTdLL2F2Tm9iTGNsMnNKc3QwOU9BMk5nWVdFSU9nUmkremhwbHl0endieXBD?=
 =?utf-8?B?UUM4N2EwbWRzb1VlbEsreEZhMUhrcktudzRIQmc5VklwaFVBQ21wV2RYYkwv?=
 =?utf-8?B?TDV5emVPcm9yeDRjWjBpUk5tTEFFOW83T2p3VERJRzZSTXBXTXd1cGZmb21x?=
 =?utf-8?B?WUhkVFhNcU1GWllLREFxaTNGS2djNkFiUlZ4RWZBcnlvVzdYU1R1U1d3V1Bh?=
 =?utf-8?B?RmFmaThzTHhRNDQxb0JrS0NMd3JJVis0d1Y3ZW1qMFpPaDBWTzNTMVRQM3FO?=
 =?utf-8?B?dHlPazd2d0dIcTNmOHlRWlpSYkh3QVlCMUt2MzZDNVptVGVRc3pwRXVxL0hP?=
 =?utf-8?B?eGNqc2UyM0NNK2NFTEVtcmU3MkRRcDNpbjZIeUgvMWY4SzRLbXZmejJEMUxH?=
 =?utf-8?B?VjVvOU5OSGt1VjQyZ09uWjNTa2kzdlVLRlMxMlY5U2tIK3VUYlVibVl4ZWJ2?=
 =?utf-8?B?U0pGRDNiR2pNT2FHdHZVV1BnUlZXaGswSmFUVTFXR0hEZjV6K0tJbHFrcVov?=
 =?utf-8?B?K2FsQ1Q5L05yZGZkRnJVMFRTYzEzMk9lbExxWkM4Sm1maW9NOGhzRlVoRHZY?=
 =?utf-8?B?NjR4RmRheWJlYXBlVjV2SFJjejFJK0xKejB0eURnMjkySklwdFFvTWltSmx5?=
 =?utf-8?B?Z1h2R3lmbHpLSUtqdVJLaVpId2dBMkF6T3hVVkpNdkxLVmN5ZlZWZlVGSFoz?=
 =?utf-8?B?ZEVMc3hwbURFczBTZG13b2IrWm50d3RjK21rQktZMWJ4ajgrV2Z1WGhWblhC?=
 =?utf-8?B?MEtFSzFRMERHeFNDVmdESENuVzUrYzJpWmhGS2VxRWdsR25sa1FkK2g1UW9r?=
 =?utf-8?B?WXhIelJiUUtoR1E3WFJkSDhVTUFFbWh0VVJoVlBNUWIyUVo4N1VLb00wN0kx?=
 =?utf-8?Q?u261kbovXRkO2bqAb4qj67ROu?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ec63181-e7fa-4212-eb2d-08da877fd26f
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6323.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2022 16:27:09.4852
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VlO5L1V/dB//0SJNHFxPofq+le4Natc9ZjZ21xQixwjYTYU6aXIXJ21MNTJwpLP5NT0rSwp/FS9wF+4nJsPBsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4732
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/26/2022 5:50 PM, Maciej S. Szmigiero wrote:
> On 26.08.2022 11:35, Shukla, Santosh wrote:
>> On 8/25/2022 7:46 PM, Maciej S. Szmigiero wrote:
>>> On 25.08.2022 16:05, Shukla, Santosh wrote:
>>>> On 8/25/2022 6:15 PM, Maciej S. Szmigiero wrote:
>>>>> On 25.08.2022 12:56, Shukla, Santosh wrote:
>>>>>> On 8/24/2022 6:26 PM, Maciej S. Szmigiero wrote:
>>>>>>> On 24.08.2022 14:13, Shukla, Santosh wrote:
>>>>>>>> Hi Maciej,
>>>>>>>>
>>>>>>>> On 8/11/2022 2:54 AM, Maciej S. Szmigiero wrote:
>>>>>>>>> On 10.08.2022 08:12, Santosh Shukla wrote:
>>>>>>>>>> Inject the NMI by setting V_NMI in the VMCB interrupt control. processor
>>>>>>>>>> will clear V_NMI to acknowledge processing has started and will keep the
>>>>>>>>>> V_NMI_MASK set until the processor is done with processing the NMI event.
>>>>>>>>>>
>>>>>>>>>> Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
>>>>>>>>>> ---
>>>>>>>>>> v3:
>>>>>>>>>> - Removed WARN_ON check.
>>>>>>>>>>
>>>>>>>>>> v2:
>>>>>>>>>> - Added WARN_ON check for vnmi pending.
>>>>>>>>>> - use `get_vnmi_vmcb` to get correct vmcb so to inject vnmi.
>>>>>>>>>>
>>>>>>>>>>       arch/x86/kvm/svm/svm.c | 7 +++++++
>>>>>>>>>>       1 file changed, 7 insertions(+)
>>>>>>>>>>
>>>>>>>>>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>>>>>>>>>> index e260e8cb0c81..8c4098b8a63e 100644
>>>>>>>>>> --- a/arch/x86/kvm/svm/svm.c
>>>>>>>>>> +++ b/arch/x86/kvm/svm/svm.c
>>>>>>>>>> @@ -3479,7 +3479,14 @@ static void pre_svm_run(struct kvm_vcpu *vcpu)
>>>>>>>>>>       static void svm_inject_nmi(struct kvm_vcpu *vcpu)
>>>>>>>>>>       {
>>>>>>>>>>           struct vcpu_svm *svm = to_svm(vcpu);
>>>>>>>>>> +    struct vmcb *vmcb = NULL;
>>>>>>>>>>       +    if (is_vnmi_enabled(svm)) {
>>>>>>>>>
>>>>>>>>> I guess this should be "is_vnmi_enabled(svm) && !svm->nmi_l1_to_l2"
>>>>>>>>> since if nmi_l1_to_l2 is true then the NMI to be injected originally
>>>>>>>>> comes from L1's VMCB12 EVENTINJ field.
>>>>>>>>>
>>>>>>>>
>>>>>>>> Not sure if I understood the case fully.. so trying to sketch scenario here -
>>>>>>>> if nmi_l1_to_l2 is true then event is coming from EVTINJ. .which could
>>>>>>>> be one of following case -
>>>>>>>> 1) L0 (vnmi enabled) and L1 (vnmi disabled)
>>>>>>>
>>>>>>> As far as I can see in this case:
>>>>>>> is_vnmi_enabled() returns whether VMCB02's int_ctl has V_NMI_ENABLE bit set.
>>>>>>>
>>>>>>
>>>>>> For L1 with vnmi disabled case - is_vnmi_enabled()->get_vnmi_vmcb() will return false so the
>>>>>> execution path will opt EVTINJ model for re-injection.
>>>>>
>>>>> I guess by "get_vnmi_vmcb() will return false" you mean it will return NULL,
>>>>> since this function returns a pointer, not a bool.
>>>>>
>>>>
>>>> Yes, I meant is_vnmi_enabled() will return false if vnmi param is unset.
>>>>
>>>>> I can't see however, how this will happen:
>>>>>> static inline struct vmcb *get_vnmi_vmcb(struct vcpu_svm *svm)
>>>>>> {
>>>>>>       if (!vnmi)
>>>>>>           return NULL;
>>>>>           ^ "vnmi" variable controls whether L0 uses vNMI,
>>>>>          so this variable is true in our case
>>>>>
>>>>
>>>> No.
>>>>
>>>> In L1 case (vnmi disabled) - vnmi param will be false.
>>>
>>> Perhaps there was a misunderstanding here - the case here
>>> isn't the code under discussion running as L1, but as L0
>>> where L1 not using vNMI - L1 here can be an old version of KVM,
>>> or Hyper-V, or any other hypervisor.
>>>
>>
>> Ok.
>>
>>> In this case L0 is re-injecting an EVENTINJ NMI into L2 on
>>> the behalf of L1.
>>> That's when "nmi_l1_to_l2" is true.
>>   hmm,. trying to understand the event re-injection flow -
>> First L1 (non-vnmi) injecting event to L2 guest, in-turn
>> intercepted by L0, 
> 
> That's right, the L1's VMRUN of L2 gets intercepted by L0.
> 
>> L0 sees event injection through EVTINJ
> 
> It sees that L1 wants to inject an NMI into L2 via VMCB12 EVTINJ.
> 
>> so sets the 'nmi_l1_to_l2' var 
> 
> That's right, L0 needs to keep track of this fact.
> 
>> and then L0 calls svm_inject_nmi()
> 
> Not yet - at this point svm_inject_nmi() is NOT called
> (rather than, VMCB12 EVTINJ is directly copied into VMCB02 EVTINJ).
> 
> Now L0 does the actual VMRUN of L2.
> 
> Let's say that there is an intervening VMExit during delivery of
> that NMI to L2, of type which is handled by L0 (perhaps a NPF on
> L2 IDT or so).
> 
> In this case the NMI will be returned in VMCB02 EXITINTINFO and
> needs to be re-injected into L2 on the next VMRUN,
> again via EVTINJ.
> 
> That's when svm_inject_nmi() will get called to re-inject
> that NMI.
> 
>> to re-inject event in L2 - is that correct (nmi_l1_to_l2) flow?
> Hope the flow is clear now.
> 

Yes, Thank-you for the clarification :).

Santosh.

>>
>> Thanks,.
>> Santosh
> 
> Thanks,
> Maciej

