Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B14F068EBEC
	for <lists+kvm@lfdr.de>; Wed,  8 Feb 2023 10:44:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbjBHJoG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Feb 2023 04:44:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjBHJoF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Feb 2023 04:44:05 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on20606.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5b::606])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0CE330E4;
        Wed,  8 Feb 2023 01:44:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lNGZrsToZVA70Mv1p/yaTRZRZstWVTzt4w9eLeZXGqLzWzoH5lruaKl9gJKlFCuyBWNWQjxW/l8PAPqGU1zWz6s0p1APo/FNdw5tmsN6izexWTOYgrH1pEItVl6SmSfZz9mCxkMxyiOKFXwbd/Nu3g4SBFOxkYFrzjY2c8xpW9jQTx8+tGqC6LJDP1Fgr6lyWpH8IuY9uxfWsFJ1zOPERk2HAC6JXRNHL2PTwUunURfZF2DxxOg3cD0IhHI1usvxvI5dycK8GYG+d4U/amcRG+2f6Lqe4Xy+5zKb9WHc85wtcgsD3A+xGLTtgyuPG3JJbHkXQk+b7e3TS0+zTmtEow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j304b6f9uvvM//j5BL6cYCP7USeiGSCLgN0td70QGWg=;
 b=YULcPvf4Adb04SMtgCSqfIQ37UHkBNDWqfjCVOC0UhUSq+opRZZDAFN8fU6HGWLAqHeaUBxz3EEgoRZ2bA53IOhHtvfif21tUHfb/pl4NygoJPDSyLUIrNrkMleTV6l/JeS8HJwZse+3Oig4OjZEIr/dIiqN/QeD+DyC0wCbYgpGbMpAFsbv0WlJNxf4BwhwgmRTAA+oNopFd1hobwTxtJxy4aLfcVetdOcW2o3CCROHQbkwn64SW3j543ghhzpfeDCMzTBQJOqJyVc1qr+X4T2MV9R6zvU8Mo78XZG7Sffm6uWsXSYlP4y900UBxsla2y80ooi8ZUrA5VVkAvo7Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j304b6f9uvvM//j5BL6cYCP7USeiGSCLgN0td70QGWg=;
 b=KTEePs9yQcXCS2F+w0SaDDzYNmBZAF4BWvg8vA0N4DqcIusteGMKhv6W7hnFNq4vzCZPlKtBkYnNg+iv97bFnYVHbFyPmIQNp0zkka0De5f4kgRbs7GxdfaHh8nszmpYMCWVixkTEzkRr78JOaWky1EKrmjamOBi2dTv+GP1YNw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY5PR12MB6323.namprd12.prod.outlook.com (2603:10b6:930:20::11)
 by MN2PR12MB4486.namprd12.prod.outlook.com (2603:10b6:208:263::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Wed, 8 Feb
 2023 09:44:00 +0000
Received: from CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::caf0:cffe:94c4:df18]) by CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::caf0:cffe:94c4:df18%2]) with mapi id 15.20.6064.031; Wed, 8 Feb 2023
 09:44:00 +0000
Message-ID: <a59505b3-5405-0409-bbf1-34466932c2c1@amd.com>
Date:   Wed, 8 Feb 2023 15:13:44 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 07/11] KVM: x86: add a delayed hardware NMI injection
 interface
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Sandipan Das <sandipan.das@amd.com>,
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
        "H. Peter Anvin" <hpa@zytor.com>
References: <20221129193717.513824-1-mlevitsk@redhat.com>
 <20221129193717.513824-8-mlevitsk@redhat.com> <Y9mWFlGdzoa8ZDW7@google.com>
From:   Santosh Shukla <santosh.shukla@amd.com>
In-Reply-To: <Y9mWFlGdzoa8ZDW7@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0008.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:95::20) To CY5PR12MB6323.namprd12.prod.outlook.com
 (2603:10b6:930:20::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6323:EE_|MN2PR12MB4486:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a010845-5707-4150-2bd4-08db09b90132
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j9fSpgIxMO2/OcZ0MZhyHGrnv813qRHj7oJG6aIya2WUDcEtIhai7OZVMcP8ru1DhxwJ2mTueKxs/HJMIREaRGVMyk0+BECM6VcN7m2us5F3CDMk+36LY9EHd5e9ul3bglBby40kP47NTBW2iM70RrTDnXTzAcgUto93IO+rwOGneF4QEYVItayKiJ7SuBvbCwiVx7Oo+CGsR4tA6AORpw4FBNOtmYwqZnJlezd/AHKs0IFs1IHQYBm/e/KR9tT407vLp0pfEOCuNkg8SR5AGtA8WOZihoViowsUKnIhwZm29FB1aAQOcZZ/99AYUsQ31YmxgzQbfrMt7r2nX1HiXn5u23l9UBOX+l3IqhLNtrD9GRYl5ZOzeV/AHVqe54XlPwGS+pm7Fb9pkt5BAf176gazUCFDVC9fBT0z1g80wFiTkfhXYiW7ouYCaHSbYaJM0psuENbYna2D8qq3sNcRLj/VJizebV//mOs/K6Y9YFFxRiQvyNlUzKnTEes8u0XYRxZsLOU2MvTSz/3dFE+F4wN2uW+QpxnclYqg2gYo6JJQBMJMZZLqsitqbAM9Z+qXZwFbAR+oOni7qvGUjPgvCrQGIYNIuG2Sbhng2rypM9HjBGqHUz3oVeNHBOjje9SOScne3Km22lDZFaymH41ttypNFUo/CE+wftHQ4HVmJWDCVLMTuVyi2zSa/d16kcz0JKXRWnf3DPr9jQrMuWJvrpsltQjPYVoEekMkZCjlE/o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6323.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(39860400002)(396003)(376002)(366004)(451199018)(31686004)(83380400001)(44832011)(36756003)(5660300002)(2906002)(7416002)(186003)(31696002)(6512007)(26005)(6506007)(53546011)(8936002)(6666004)(66556008)(41300700001)(478600001)(6486002)(86362001)(38100700002)(2616005)(110136005)(54906003)(66946007)(4326008)(66476007)(316002)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MllpOWFHNmNaZ2NwM3ZrVXRkZk5MbC9ZUXNGQ3kvRG5vNlI2WmdiVlB0WUFD?=
 =?utf-8?B?WXdmNlVjU09CYXRSNk1OMm9Wd1F5SFZ5R3JJdlVyUEh2NWkxbDdaZGhDeURP?=
 =?utf-8?B?c0xEbTRHUTIzdHE3a3ZhTE5mMWZXN3laOEhsY2dBTFhFQVg5OFNQd3VxK1NT?=
 =?utf-8?B?YmdJYU9qVzRueFhuT2twamdMV0haN0NnNVZYSkh2NDFja3hvSG1teFNVQ2ti?=
 =?utf-8?B?WGxkamVkd2JtRjFFK3lPK3MzUS9ITFN4dGttZXhSUmpnQlY4TVVVRUxBcVBr?=
 =?utf-8?B?S0JjUi9XT0JpZmJZc05Lc3o2d3hDdUFPMlE5Y21waEJoSVpDTTZUVHdwVEJB?=
 =?utf-8?B?Qk4rUzVIWExLblc5Y0o0aGtIYjdKYjlaSXR2cFBlaHgzc1pFR1BwQUhmZjR4?=
 =?utf-8?B?bUtPenBEYjZaSW1aR3hJMUlqdHRweW53bjF6YUJXNDJ0clgrRHhZRlRla1BM?=
 =?utf-8?B?a2k1N1hHNUZxdTk2UDA2NjJIR0cwS0R3b1NwZnorN1B1Tk1QWEx0MVJReHBq?=
 =?utf-8?B?UVRQOVRUQndER2phVXhRR09nTkp3ZmxyV1Avckl2UW52aGxEZ0xWQXVBZ2tF?=
 =?utf-8?B?cVNtWHNGdWMxM0JBWkdpeFBjNmxEekJmLzIvNE5qMTk5ZkEzakhoaHJERTFi?=
 =?utf-8?B?cnEra0RKalY4cS9MNFkwQ285Y3djbzNWekhaVjBKUG9oSk5JU1BpZng3TEZl?=
 =?utf-8?B?SGNLdE8ySjFmaVdUenpxRHdsMEp5Yzk4dTgydTMwaWl3dGF2VU5vVm5vTCsx?=
 =?utf-8?B?Qnk5RlYxeGsrRkxDYmY0ZUJ5SVRJRHhadUc4VEd2eXpIdkdpeGZnUTV2WG5J?=
 =?utf-8?B?b0hPZkFNcFhvK2U4amVBMUZ3L0l6Rm92Wi9VQTlKMCsrZDZDWGRXdE1qUmt3?=
 =?utf-8?B?ZVgyeFdnVVV6Vk9sRG8xZDhPR040S0NZZFY1Tk1rL2RKbEp4Ymk5dW5MM1d2?=
 =?utf-8?B?WEpGVGljeWVaRndkSGFoRVc2ZStmWVBGY1hza3hhMVM0OGxRb01wdzlodmZx?=
 =?utf-8?B?ekNCNTQ3Q0w5NlQ5Y3NVWFpwSmhzOXo5VUNadUxkYm1KY0Fidmw2VDMwR0xX?=
 =?utf-8?B?UVVXd2w3MEtvODRQNXhvaC9MVWUyaHN2eG15M3l1Unl5RExzYzF5WHl2NTFz?=
 =?utf-8?B?b1RKaDB0TjBMWTVLVkIweS9jTnF6RUF1L2p5MG9tYzUyVjdWUkdQZWJadUNa?=
 =?utf-8?B?YXZoRmN2NVd2RGVveTV6dnhnb0VUanpuUXRhcnJ3Zk10aE5BWDRDVmp1TVI0?=
 =?utf-8?B?Ym1sa1YrVUJPUWRrbDRQSy8ySzRwLzZjTDUrUjd5b2hPYUdqNkxza1RGb0lV?=
 =?utf-8?B?eDVidldlWXZFK3N3aXZpaE1YeVpRRk5XbHlrT3VKUnE3RzhzRHFrVlRnamxI?=
 =?utf-8?B?VnRDTGxETURsd0RQZGhDR0ZFUDl3RVBMRWdWU1NhdTUrYnkrVWp4a1g3M0VT?=
 =?utf-8?B?VHJOV1BRVkluYlVIUHM4R0ZIWTZGcmlsdzVhZUtsT1prVTdpRGw4Z0R0b2VY?=
 =?utf-8?B?WWtvRGhDSnhFUWduYXNFMEg2WVNYTVNCaFNwSUxCM2ZlYysyeHdwMTB0OUwx?=
 =?utf-8?B?b3F3WC9LKzRRelRxbVhQdWhScUVmY1JSdGtaRnJJdnNiUUxBUThMQ2FKeThG?=
 =?utf-8?B?MHNGVWVJVkUxd2NZdVNldzQwSjJrQ1k3UjJmQURXTTI5dUpwQzR3aDRSbEls?=
 =?utf-8?B?OUM3MWsvNGcyMXJydER3Z0tYQ1VoSEZUWHJsRU5ZTThrMEVJYnhlNjlOQXQ1?=
 =?utf-8?B?QllSL0hmT0NySTljK3FySVduQUFNRGZUOWNoNmpWeGppck9ldngrWHZYejFs?=
 =?utf-8?B?SngvdUUrUVVCOHMrWmJxdjcvNzd5OFN0VENJdldOWXJkaC9PelpLNUU3bVR2?=
 =?utf-8?B?cTcraW9mNkFtNU10VVMzMVhQYjVLVVRNbkdtWWRiVmhMNXZSWlJ2SzlhRUs4?=
 =?utf-8?B?SW1SVnREc2dFQWFaMEREUjJ0b1Bpb2lmMDBKbGRnaFZIM01JeEJTK3VKWmVy?=
 =?utf-8?B?QjNQUWZadDBKNC9OdTFPWko2ZlVnaWpyOGxmMktCcmV5WERJZ2hNMnE4K1Zw?=
 =?utf-8?B?NnBKajNCamlHMXpFUWFhYTdlaDBUdE9rcTF1Unk2SGE0Wlc2RlpBWVVmVlNG?=
 =?utf-8?Q?LvdJ03UiA0wR7V2IJI/jg7YLk?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a010845-5707-4150-2bd4-08db09b90132
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6323.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 09:44:00.1096
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0wLLiNAurPvpfH7BHwtDmt8VgRyncPB97mmteU9aZEm+ZNZe/SgqD4vX7yR4Yxt5DkbSLZ1vJHg80ta/HN0KwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4486
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/1/2023 3:58 AM, Sean Christopherson wrote:
> On Tue, Nov 29, 2022, Maxim Levitsky wrote:
>> @@ -5191,9 +5191,12 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
>>  
>>  	vcpu->arch.nmi_injected = events->nmi.injected;
>>  	if (events->flags & KVM_VCPUEVENT_VALID_NMI_PENDING)
>> -		vcpu->arch.nmi_pending = events->nmi.pending;
>> +		atomic_add(events->nmi.pending, &vcpu->arch.nmi_queued);
>> +
>>  	static_call(kvm_x86_set_nmi_mask)(vcpu, events->nmi.masked);
>>  
>> +	process_nmi(vcpu);
> 
> Argh, having two process_nmi() calls is ugly (not blaming your code, it's KVM's
> ABI that's ugly).  E.g. if we collapse this down, it becomes:
> 
> 	process_nmi(vcpu);
> 
> 	if (events->flags & KVM_VCPUEVENT_VALID_NMI_PENDING) {
> 		<blah blah blah>
> 	}
> 	static_call(kvm_x86_set_nmi_mask)(vcpu, events->nmi.masked);
> 
> 	process_nmi(vcpu);
> 
> And the second mess is that V_NMI needs to be cleared.
> 

Can you please elaborate on "V_NMI cleared" scenario? Are you mentioning about V_NMI_MASK or svm->nmi_masked?

> The first process_nmi() effectively exists to (a) purge nmi_queued and (b) keep
> nmi_pending if KVM_VCPUEVENT_VALID_NMI_PENDING is not set.  I think we can just
> replace that with an set of nmi_queued, i.e.
> 
> 	if (events->flags & KVM_VCPUEVENT_VALID_NMI_PENDING) {
> 		vcpu->arch-nmi_pending = 0;	
> 		atomic_set(&vcpu->arch.nmi_queued, events->nmi.pending);
> 		process_nmi();
> 
You mean replace above process_nmi() with kvm_make_request(KVM_REQ_NMI, vcpu), right?
I'll try with above proposal.

>	}
> 
> because if nmi_queued is non-zero in the !KVM_VCPUEVENT_VALID_NMI_PENDING, then
> there should already be a pending KVM_REQ_NMI.  Alternatively, replace process_nmi()
> with a KVM_REQ_NMI request (that probably has my vote?).
> 
> If that works, can you do that in a separate patch?  Then this patch can tack on
> a call to clear V_NMI.
> 
>>  	if (events->flags & KVM_VCPUEVENT_VALID_SIPI_VECTOR &&
>>  	    lapic_in_kernel(vcpu))
>>  		vcpu->arch.apic->sipi_vector = events->sipi_vector;
>> @@ -10008,6 +10011,10 @@ static int kvm_check_and_inject_events(struct kvm_vcpu *vcpu,
>>  static void process_nmi(struct kvm_vcpu *vcpu)
>>  {
>>  	unsigned limit = 2;
>> +	int nmi_to_queue = atomic_xchg(&vcpu->arch.nmi_queued, 0);
>> +
>> +	if (!nmi_to_queue)
>> +		return;
>>  
>>  	/*
>>  	 * x86 is limited to one NMI running, and one NMI pending after it.
>> @@ -10015,13 +10022,34 @@ static void process_nmi(struct kvm_vcpu *vcpu)
>>  	 * Otherwise, allow two (and we'll inject the first one immediately).
>>  	 */
>>  	if (static_call(kvm_x86_get_nmi_mask)(vcpu) || vcpu->arch.nmi_injected)
>> -		limit = 1;
>> +		limit--;
>> +
>> +	/* Also if there is already a NMI hardware queued to be injected,
>> +	 * decrease the limit again
>> +	 */
>> +	if (static_call(kvm_x86_get_hw_nmi_pending)(vcpu))
>> +		limit--;
> 
> I don't think this is correct.  If a vNMI is pending and NMIs are blocked, then
> limit will end up '0' and KVM will fail to pend the additional NMI in software.
> After much fiddling, and factoring in the above, how about this?
> 
> 	unsigned limit = 2;
> 
> 	/*
> 	 * x86 is limited to one NMI running, and one NMI pending after it.
> 	 * If an NMI is already in progress, limit further NMIs to just one.
> 	 * Otherwise, allow two (and we'll inject the first one immediately).
> 	 */
> 	if (vcpu->arch.nmi_injected) {
> 		/* vNMI counts as the "one pending NMI". */
> 		if (static_call(kvm_x86_is_vnmi_pending)(vcpu))
> 			limit = 0;
> 		else
> 			limit = 1;
> 	} else if (static_call(kvm_x86_get_nmi_mask)(vcpu) ||
> 		   static_call(kvm_x86_is_vnmi_pending)(vcpu)) {
> 		limit = 1;
> 	}
> 
> 	vcpu->arch.nmi_pending += atomic_xchg(&vcpu->arch.nmi_queued, 0);
> 	vcpu->arch.nmi_pending = min(vcpu->arch.nmi_pending, limit);
> 
> 	if (vcpu->arch.nmi_pending &&
> 	    static_call(kvm_x86_set_vnmi_pending(vcpu)))
> 		vcpu->arch.nmi_pending--;
> 
> 	if (vcpu->arch.nmi_pending)
> 		kvm_make_request(KVM_REQ_EVENT, vcpu);
> 
> With the KVM_REQ_EVENT change in a separate prep patch:
> 
> --
> From: Sean Christopherson <seanjc@google.com>
> Date: Tue, 31 Jan 2023 13:33:02 -0800
> Subject: [PATCH] KVM: x86: Raise an event request when processing NMIs iff an
>  NMI is pending
> 
> Don't raise KVM_REQ_EVENT if no NMIs are pending at the end of
> process_nmi().  Finishing process_nmi() without a pending NMI will become
> much more likely when KVM gains support for AMD's vNMI, which allows
> pending vNMIs in hardware, i.e. doesn't require explicit injection.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/x86.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 508074e47bc0..030136b6ebbd 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10134,7 +10134,9 @@ static void process_nmi(struct kvm_vcpu *vcpu)
>  
>  	vcpu->arch.nmi_pending += atomic_xchg(&vcpu->arch.nmi_queued, 0);
>  	vcpu->arch.nmi_pending = min(vcpu->arch.nmi_pending, limit);
> -	kvm_make_request(KVM_REQ_EVENT, vcpu);
> +
> +	if (vcpu->arch.nmi_pending)
> +		kvm_make_request(KVM_REQ_EVENT, vcpu);
>  }
>  
>  void kvm_make_scan_ioapic_request_mask(struct kvm *kvm,
> 

Looks good to me, will include as separate patch.

Thanks,
Santosh
