Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E00E5647C46
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 03:29:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbiLIC3O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 21:29:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiLIC3M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 21:29:12 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2064.outbound.protection.outlook.com [40.107.244.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0C337508E;
        Thu,  8 Dec 2022 18:29:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WkM7kvCHOBUEO8agoi+1kxQweNaNvxvsB5PmYZo8q/Sz7NZyL1zlec1bYuzSFx/oVt6phsxfG0Us6tsojh1cxPW5Ql4JXRJJqiYJIPcjbEXB1EHpMExz0yDwrCXpXsv6Xgsj0nyzMDdrgw6NuZRY+b/64VlEsGyvw7rZXmlnHuN+ksxdNyuRBD5c7t2esMKggq+JYwI4LnayiYd3lvnbkivJa0Zus5K39mbW6X9mxUX4XIHnVTBrv3qUPI6QJocXa1iFNlIvmpLahg1PcuzvmqkrgxNTya2F9KTj48Lv6mPURbNzDW0GNwc+08qdG273xemRbgD7NDzYMTLTud7P+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wTiR3Vheq1JReHQyKs6zjSM9TPMtkd8703fjD1gZLD4=;
 b=J76Y6QUdHhRgULf7FFubggODTzKTI458CGXbn/3Uz5aGJIk/0tMaULrZK3qPzmWNTKp4cD68njGPGJimOiNShIJKnBIZJEBx3BdgCLD7inZRKNc+Xc/JCaD/QIFYxUsT43Jpo9r890Jg/UbPt0oGZUXqY8QyjmGz32Hb9o/4j5pd+HRnBql+HcTnMsbBn/AQL9aHt75TYZ/sHzAFnuWO/bFbLMC4FF8BkNg23+ttf4tdyASR5LZQi9WiiBq4uDPMJGrSz2SHBt3wz900J6BwzsuU2NfswHG7C1x0JQIi3wmtXQhACs6lKLvsxKdD/hD2ERIuxW6LCsowglgn8RWzNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wTiR3Vheq1JReHQyKs6zjSM9TPMtkd8703fjD1gZLD4=;
 b=xRxUDvB0BltNnrYaSj8HojU1m+fyjhWnhRche3JZ08vHrHGS0SFwJa5dO6w1s/PY3Wh77fAidYxggl4uFxnTDYrPsljDGbLkfM0W1BDHtWCwt4VV7QAJbckhFrcWI8sq8FCh8YK+3htqSvifca0sozkYw8rq/bkzcdIynfP6VQA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB2843.namprd12.prod.outlook.com (2603:10b6:5:48::24) by
 LV2PR12MB5893.namprd12.prod.outlook.com (2603:10b6:408:175::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.16; Fri, 9 Dec
 2022 02:29:08 +0000
Received: from DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::7dc4:8eb:cc3c:3cd4]) by DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::7dc4:8eb:cc3c:3cd4%6]) with mapi id 15.20.5880.016; Fri, 9 Dec 2022
 02:29:08 +0000
Message-ID: <8ef9aee5-69d9-8367-ac28-45d116768e4f@amd.com>
Date:   Fri, 9 Dec 2022 13:28:56 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH kernel 2/3] KVM: SEV: Enable DebugSwap
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Michael Sterritt <sterritt@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Ingo Molnar <mingo@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "H. Peter Anvin" <hpa@zytor.com>
References: <20221201021948.9259-1-aik@amd.com>
 <20221201021948.9259-3-aik@amd.com> <Y4jmd2mHRVOnoQ0+@google.com>
From:   Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <Y4jmd2mHRVOnoQ0+@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY3PR01CA0082.ausprd01.prod.outlook.com
 (2603:10c6:0:19::15) To DM6PR12MB2843.namprd12.prod.outlook.com
 (2603:10b6:5:48::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2843:EE_|LV2PR12MB5893:EE_
X-MS-Office365-Filtering-Correlation-Id: d2f20cf0-6bdd-45f4-723b-08dad98d260f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Nv79e6ewVXKc0zErJ0DOam1H8pPDerGm3BSsm24gYCMsO74FRHjiCwz8KeEaTYMsZcy0vUWqwBbpTZqJU2UldUYBsScoqYmdp33B4752nePUMbTBkVLrBoYWnVGbv2UUOHg74ay7/djzlKOoQ3yoHDQlAwaIbWK46y+zbuBgzgjI2ne9/CUOzRsgHn8e3h6ZXm2S4H+8DiXjYCoqWvPr5IbczCkyLPiPK4LBYp25k3IPW7/aadrgCOFwlUUsRiRXznUN1GwE0tv8aVlBBUANXL3H9GTPgUTOOdiCSeViyydUzxJ5QBHFcBPs1DzOctNk3VGej8ps1HykmaJ+2yg4AlcBjtM2zxpjk4zFteoCTu/SUV3bL0Xs4/BCSiDA6Ez2Vy/MqM9lhewBPwH3tD6hF3gMRLUhxcXetXR6GvCfZ1Bg2rx1fS6S2Xf/waqWBnOtTEf60Z/7B9wVBwOGwCjjWrc2zp3AN1ORDvtrWJkWEY3iDD9JpaMWKnkt7pWZ7XRoxrdHE8MjJlA9wybm7Ec6JpSDLhJ3Ls+HdTTEp8jy/LKn72RfFxFHjsgI6+DEOcybc7P/SGPuEc2kRyv4vdHltrwF6nGm+baQFf8ZeNm+8InR/ay3Mof0OToXVJ6GNtNoFlKn17FslzktfYbHK9x+ytoCNaDSpoBIUwllj9WyYF+j+3gov4r30SBbAl7a+ZatxcYcsOh89JH+OyQSJsQvc+FslGVUEj1oNi2BiqmbnwtHXoh1xOQwT942wzj74wXs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2843.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(346002)(136003)(366004)(376002)(451199015)(53546011)(7416002)(2906002)(6666004)(36756003)(316002)(38100700002)(6506007)(966005)(54906003)(478600001)(6486002)(5660300002)(6916009)(31686004)(31696002)(83380400001)(26005)(6512007)(8676002)(4326008)(66556008)(2616005)(66476007)(186003)(66946007)(45080400002)(8936002)(41300700001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dE1QSElJbVk4M2h1d0taTlNnM1dWQ0tiYmJieS9rMCtRbDFiSW5tRXJKTzFG?=
 =?utf-8?B?V2tuaUxVYlVjWk03NHVJaU95MzBicndjcG5lUW1CcnpjNjJjd1JiNTBMNGpJ?=
 =?utf-8?B?c0UxN0h1Z0N1MlNzNCs2MlpRYTI3d2cwZllXZnRxcjczeWw2SmpKazljRlla?=
 =?utf-8?B?TWFxSmJHOHcwQ1ZWcy9rbFJrTThvdVRPUWVZc0VVTWJDZGxCaUxxczFRQ0tn?=
 =?utf-8?B?N1E3bHBKOTlmY211ei83eVlvbzQwaExjdEY4VUQ1YTR0MmxMMlRkMkJLd0Qy?=
 =?utf-8?B?NzF0U3F3bm9Odkp4MERFbDVGNzY3Y21oNlBqMmtqMTFMSitNVTZ2YklQVlV3?=
 =?utf-8?B?WkFDQUFjWVRGWkIyWk04cFpWcWlFMThhZVovd2xmMTVndXJ0ZmtWaHFmdkZr?=
 =?utf-8?B?Umw5N0tBM2Q4ZDVGNzBzT1IvY2JKMklGOWYxeEhrNUtCY2RMWVR6cEphSGVJ?=
 =?utf-8?B?ZVg4dHlNb1VXQ3JMNzN4MWhkei9mOUhudjgvcE84OTZaYlVZaWFNSTRzYnhS?=
 =?utf-8?B?eUZIS1dWa0N4amxxUXpldkV3YmNTSjNleWZybGk4ZHNJOXNpd3ZsM2VPMDNh?=
 =?utf-8?B?SnRsOUUrdTZBcFV4WjAwUWlZR1BsUEdrdGV4ZzRPWjlOM0tmWGU2clMxU2x6?=
 =?utf-8?B?VWNCUGZrSjM4b3JLL042ZHdtc0t2ZzdsdjNHNmpsdlk5dWo0Z2lyQS9qY241?=
 =?utf-8?B?UHlaRWZiOS8yNmtFUXhGVkptZFU1My9mRzBXalF6LytZdGcweS95WE1DZ3gr?=
 =?utf-8?B?OFNqKzE3WEdPbWQvOVpPSTNQWmRXcFpUdDBSLzBUZ2hyalBOUENNOS9NaFVE?=
 =?utf-8?B?UnNMUDRLNk9ScEJtbmMydHc3ZksyN2lwMW95QUFUc1BjNml1MzhkNmVlSlRm?=
 =?utf-8?B?dHR2VGphcGdnNmdNM2RPd3p4bWxaaDlSbGlsZEpCREZrR01DT0tqTjZHWWtW?=
 =?utf-8?B?V3QvTldDakpDaXU2ZjB3VFBVU1c3NDFPYnBtYUp1Wis3TzU3bENleThpYnVF?=
 =?utf-8?B?WW9CeTFiWDFvSW9XMlNKRlFlY3VvVWRNRGxidXo5ZUZmcDdESUV3Z2Nob0ZZ?=
 =?utf-8?B?R0xlVitDN0oxRlYvRTFBTzkybTVvZjZ0UVVVcWpXWHlyRXYxTXJCSTZkS0J6?=
 =?utf-8?B?Yno1U0kwc3htRWw1UkduaEFoS1dicDlBbWpnMll3cUg2VUkvZXM1RExMUDQ4?=
 =?utf-8?B?ck51dytZcUY1N09qYlJteW5jMWpXdm1GTkFhWkF2THVabzNoOU1zY0FuYVI5?=
 =?utf-8?B?ZWVzd2R1T0E4dlI5UHNhdkdqZ2ZMblhiYUd0Sk1XTlBIdm9JQ1VHaDZGYlMw?=
 =?utf-8?B?ekl2MzRMRGhreEU4SVdXa3l5cldpVjNtWE50alRGb0VVNFppSmtVcFBSQ0dG?=
 =?utf-8?B?bVJLTXoyTlNBcXcrc1crMWIwYmlsM0RuUElVcEJXZFlzMEE2TGw1QjRPMEUy?=
 =?utf-8?B?TkYyWG5raGxzdndiL3NyQ2RqVlkyWGNkbkFjamZSWXpOUUJNekxGbnZwTWpP?=
 =?utf-8?B?N0s4Ykw4MW9OMkk2ZjZmWG9qU2JlczdrTlN3WmxzSEdaYTRuVFRlQ0JLRS9P?=
 =?utf-8?B?Y1B3VXFzbHB3ck0rMHliamxja0lCckJWWldiZ0oxYjJJOWo4YzVxVzlzbHZs?=
 =?utf-8?B?NXdvMXJ2cStkM1Y2eGtFZzV5TXpuYkpRNlRISzNLditzSXJ4NmR5eW05dVJ2?=
 =?utf-8?B?NFo2RytOL1dIUjRJaDdobWM4SmpIY3JKQ1FGY0lhUExQUk1sc01HQ2xUbFFZ?=
 =?utf-8?B?UVYvLzZEOGdiTVFWTG1uRlVuTTQveHZpL29PYzlYdFV2emJEbGxvNVBCaVlw?=
 =?utf-8?B?SE9FeWRNbzkwRVFKZU9rUzBObXBEcTVNTFJGOW1HWkRNQmpzV3JYdUtyOUV1?=
 =?utf-8?B?Vnhyb2M2UXVTYmZveExyUXFYT3QvckEyZkI3ZHVVVzJndzk5NVdLbDQ0VWsy?=
 =?utf-8?B?ZFZkcFVrZWJoWVJlZ1R2MFdRZEZ3dFdRSnBNS1NUTjlDYU1mMlNmbDg5S1VI?=
 =?utf-8?B?bnExdHl5QTRNV1NaeFhLRk04WVVZQXZvenhXSTRKbUlvbFZpTEg2OHczZmZh?=
 =?utf-8?B?TjQwak9vQW1NNjZ0VExXNjFia1BxOVVpY3dvUkpaRCtyZ0hLRkVoRCtFaEVD?=
 =?utf-8?Q?NVwd5NdRaAq65ouNfCOM/BD2R?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2f20cf0-6bdd-45f4-723b-08dad98d260f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2843.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 02:29:08.1633
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E6f2sZN6fUuyyhdBn3SOM3zJckGZ/P/v73ExkGdZ8ZE5rdEXywZbUJphscPWQBoImNJxBPse9jdxgthbGTG5jA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5893
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/12/22 04:37, Sean Christopherson wrote:
> On Thu, Dec 01, 2022, Alexey Kardashevskiy wrote:
>> AMD Milan introduces support for the swapping, as type 'B',
> 
> Please make the changelog standalone, i.e. don't rely on the shortlog to provide
> context.  "the swapping" is inscrutable without the shortlog.
> 
>> of DR[0-3] and DR[0-3]_ADDR_MASK registers. It requires that
>> SEV_FEATURES[5] be set in the VMSA.
> 
> Avoid pronouns in shortlogs, changelogs, and comments, as pronouns tend to be
> ambiguous.  "Software can enable DebugSwap by setting SEV_FEATURE[5] in the VMSA."
> isn't much more effort to type.
> 
>>
>> This requires the KVM to eliminate the intercept of #DB. However,
> 
> Same here, e.g. does "this" mean that the architecture requires DB interception
> to be disabled to enable DebugSwap?
> 
>> because of the infinite #DB loop DoS that a malicious guest can do,
>> it can only be eliminated based if CPUID Fn80000021_EAX[0]
> 
> And "it" here.
> 
>> (NoNestedDataBp) is set in the host/HV.
>>
>> This eliminates #DB intercept, DR7 intercept for SEV-ES/SEV-SNP guest.
>> This saves DR[0-3] / DR[0-3]_ADDR_MASK in the host save area before VMRUN.
>> This sets SEV_FEATURES[5] in VMSA.
> 
> And all of these "this".  Assuming "this" means "this patch", rewrite these
> sentences to be commands that state what changes are being done.
> 
>> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
>> ---
>>   arch/x86/include/asm/svm.h |  1 +
>>   arch/x86/kvm/svm/svm.h     | 18 +++++++++++-----
>>   arch/x86/kvm/svm/sev.c     | 22 +++++++++++++++++++-
>>   arch/x86/kvm/svm/svm.c     |  6 ++++--
>>   4 files changed, 39 insertions(+), 8 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
>> index 0361626841bc..373a0edda588 100644
>> --- a/arch/x86/include/asm/svm.h
>> +++ b/arch/x86/include/asm/svm.h
>> @@ -273,6 +273,7 @@ enum avic_ipi_failure_cause {
>>   #define AVIC_HPA_MASK	~((0xFFFULL << 52) | 0xFFF)
>>   #define VMCB_AVIC_APIC_BAR_MASK		0xFFFFFFFFFF000ULL
>>   
>> +#define SVM_SEV_FEAT_DEBUG_SWAP                        BIT(5)
>>   
>>   struct vmcb_seg {
>>   	u16 selector;
>> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
>> index 199a2ecef1ce..4d75b14bffab 100644
>> --- a/arch/x86/kvm/svm/svm.h
>> +++ b/arch/x86/kvm/svm/svm.h
>> @@ -83,6 +83,7 @@ enum {
>>   struct kvm_sev_info {
>>   	bool active;		/* SEV enabled guest */
>>   	bool es_active;		/* SEV-ES enabled guest */
>> +	bool debug_swap;        /* SEV-ES Debug swap enabled */
>>   	unsigned int asid;	/* ASID used for this guest */
>>   	unsigned int handle;	/* SEV firmware handle */
>>   	int fd;			/* SEV device fd */
>> @@ -388,6 +389,7 @@ static inline bool vmcb12_is_intercept(struct vmcb_ctrl_area_cached *control, u3
>>   
>>   static inline void set_dr_intercepts(struct vcpu_svm *svm)
>>   {
>> +	struct kvm_sev_info *sev = &to_kvm_svm(svm->vcpu.kvm)->sev_info;
>>   	struct vmcb *vmcb = svm->vmcb01.ptr;
>>   
>>   	if (!sev_es_guest(svm->vcpu.kvm)) {
>> @@ -407,20 +409,26 @@ static inline void set_dr_intercepts(struct vcpu_svm *svm)
>>   		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR6_WRITE);
>>   	}
>>   
>> -	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
>> -	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
>> +	if (!sev->debug_swap) {
>> +		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
>> +		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
>> +	}
>>   
>>   	recalc_intercepts(svm);
>>   }
>>   
>>   static inline void clr_dr_intercepts(struct vcpu_svm *svm)
>>   {
>> +	struct kvm_sev_info *sev = &to_kvm_svm(svm->vcpu.kvm)->sev_info;
>>   	struct vmcb *vmcb = svm->vmcb01.ptr;
>>   
>>   	vmcb->control.intercepts[INTERCEPT_DR] = 0;
>>   
>> -	/* DR7 access must remain intercepted for an SEV-ES guest */
>> -	if (sev_es_guest(svm->vcpu.kvm)) {
>> +	/*
>> +	 * DR7 access must remain intercepted for an SEV-ES guest unless
>> +	 * the DebugSwap feature is set
> 
> Please explain _why_.
> 
>> +	 */
>> +	if (sev_es_guest(svm->vcpu.kvm) && !sev->debug_swap) {
>>   		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
>>   		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
>>   	}
>> @@ -677,7 +685,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu);
>>   int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in);
>>   void sev_es_vcpu_reset(struct vcpu_svm *svm);
>>   void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
>> -void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa);
>> +void sev_es_prepare_switch_to_guest(struct kvm_vcpu *vcpu, struct sev_es_save_area *hostsa);
>>   void sev_es_unmap_ghcb(struct vcpu_svm *svm);
>>   
>>   /* vmenter.S */
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index efaaef2b7ae1..fac8b48e3162 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -21,6 +21,7 @@
>>   #include <asm/pkru.h>
>>   #include <asm/trapnr.h>
>>   #include <asm/fpu/xcr.h>
>> +#include <asm/debugreg.h>
>>   
>>   #include "mmu.h"
>>   #include "x86.h"
>> @@ -253,6 +254,7 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
>>   	if (asid < 0)
>>   		goto e_no_asid;
>>   	sev->asid = asid;
>> +	sev->debug_swap = sev->es_active &&
> 
> Enabling DebugSwap should be guarded with a module param so that the admin can
> disable the feature if necessary.  And then the per-vCPU variable goes away.
> 
>> kvm_cpu_cap_get(KVM_X86_FEATURE_NO_NESTED_DATA_BP);
> 
> kvm_cpu_cap_has().
> 
> And use X86_FEATURE_* directly, which is the whole point of the __feature_translate()
> shenanigans.
> 
>>   
>>   	ret = sev_platform_init(&argp->error);
>>   	if (ret)
>> @@ -564,6 +566,7 @@ static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
>>   static int sev_es_sync_vmsa(struct vcpu_svm *svm)
>>   {
>>   	struct sev_es_save_area *save = svm->sev_es.vmsa;
>> +	struct kvm_sev_info *sev = &to_kvm_svm(svm->vcpu.kvm)->sev_info;
>>   
>>   	/* Check some debug related fields before encrypting the VMSA */
>>   	if (svm->vcpu.guest_debug || (svm->vmcb->save.dr7 & ~DR7_FIXED_1))
>> @@ -604,6 +607,9 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
>>   	save->xss  = svm->vcpu.arch.ia32_xss;
>>   	save->dr6  = svm->vcpu.arch.dr6;
>>   
>> +	if (sev->debug_swap)
>> +		save->sev_features |= SVM_SEV_FEAT_DEBUG_SWAP;
> 
> Resurrecting my objection to "AP Creation NAE event"[*], what happens if a hypervisor
> supports GHCB_HV_FT_SNP_AP_CREATION but not DebugSwap?  IIUC, a guest can corrupt
> host DRs by enabling DebugSwap in the VMSA of an AP vCPU, e.g. the CPU will load
> zeros on VM-Exit if the host hasn't stuffed the host save area fields.
> 
> KVM can obviously just make sure to save its DRs if hardware supports DebugSwap,
> but what if DebugSwap is buggy and needs to be disabled?


IIUC KVM will have to save DRs somewhere (not in the host save area) and 
restore on vmexit and enable intercepts for DR accesses. btw buggy how? 
I cannot imagine but can you? :) SEV-ES/SNP so relies on this swapping, 
hard to imagine just DebugSwap being that broken...


> And what about the next
> feature that can apparently be enabled by the guest?
> [*] https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Fall%2FYWnbfCet84Vup6q9%40google.com&amp;data=05%7C01%7CAlexey.Kardashevskiy%40amd.com%7C73c50a32d6eb4dd8e76c08dad3c2cd04%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C638055130890406019%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=0I4WhDhwve4%2FHebrIk2h4MYbrmlCNiif4bDNLpY7DcU%3D&amp;reserved=0

-- 
Alexey
