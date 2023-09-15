Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E833E7A23F3
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 18:53:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234794AbjIOQwt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 12:52:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235142AbjIOQwr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 12:52:47 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2078.outbound.protection.outlook.com [40.107.93.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E826A19BC;
        Fri, 15 Sep 2023 09:52:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lHE1cIaemuEcYXl/JD8ul48C7HDABmnhJZx6sACMYFipQUBDsOorcDQibgYKLatQf3UaBYDjrHXAHHgdt40+AnUW8IQRmtr3furWJt6fs9CzgmBT7baqkGtY2OUn3Q6P16CVQOQIWFBdof2WJSm1BapXnknK25TEOxpjDHfo0+6utxgZ/BASlZ5KHMS8bsNZno1m+ygF6FM8JRqmHmHnLCPjXxxi1Qc+HPzEIpoXA8e5LVjTE5FQU9El4y6OfO6dyyHBco05VrwL8SULdXgxsQkTv0/duL8CSiZzw5XvvkMXpDxMZpM7uIlskDy3/jivBjnzKelrRwQcvmNK3Ru3VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LkLhbhcNBOjE5xR36P2hAmPn7otCTBFMC7+3gkKs+xU=;
 b=Telqxj6lVXfIqvur5yk96+rGwxn5vptPB8c/3ixhKtBXUD4sp2JmRSC+oPuu4U3Hcg5LiIUNKFGR42EbiFieLPJECmmydiXxf+M63dGq0A0FU5v8BkaI0NzpNwxoWPmhD23jc2E9y9wVP8oocaDOzaWlQbTIvgmS+TTCVS29YdxGvQZGZOxqz7K25lyT9vj1PbtccJeHsB30cOXfWLXuNNb3c+hJECq6gqo5I/trfbQtHH5ZytxCxtD5KZ9Bz05w89E4bfMDCJkxhyLk6pbNoeTvZCdKeNzQ2IMoWNsfm06GhCttEZi7ZTtcm25K/iD3EjbP/G/nrUmcAryAalVajw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LkLhbhcNBOjE5xR36P2hAmPn7otCTBFMC7+3gkKs+xU=;
 b=dUJ4LxHfIB5pirvNVFcC64BPLGgH30yTldDUYdLq3EEWcOzV3jXZSgExkh5mv8Qsw5HZT6PMwktwl4cW8vvLhbY0BJIm+WxNK8nNp40ZNtQx58ZRS4ncCCkvhnmXAgccDMxhtwIx2IEvC4JspvmVsJlIykOgCV0bgGcCU+OGeos=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DS0PR12MB6414.namprd12.prod.outlook.com (2603:10b6:8:cd::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.35; Fri, 15 Sep
 2023 16:52:39 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d267:7b8b:844f:8bcd]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d267:7b8b:844f:8bcd%7]) with mapi id 15.20.6792.021; Fri, 15 Sep 2023
 16:52:39 +0000
Message-ID: <8b047dad-84ac-69f9-3875-38bca92d7534@amd.com>
Date:   Fri, 15 Sep 2023 11:52:35 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 1/2] KVM: SVM: Fix TSC_AUX virtualization setup
Content-Language: en-US
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Babu Moger <babu.moger@amd.com>
References: <cover.1694721045.git.thomas.lendacky@amd.com>
 <8a5c1d2637475c7fb9657cdd6cb0e86f2bb3bab6.1694721045.git.thomas.lendacky@amd.com>
 <ZQNs7uo8F62XQawJ@google.com> <f2c0907c-9e30-e01b-7d65-a20e6be4bf49@amd.com>
In-Reply-To: <f2c0907c-9e30-e01b-7d65-a20e6be4bf49@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9PR13CA0035.namprd13.prod.outlook.com
 (2603:10b6:806:22::10) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|DS0PR12MB6414:EE_
X-MS-Office365-Filtering-Correlation-Id: 9aa38bac-c58c-4a95-1703-08dbb60c2ba1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ccqC6HY2FLZUw4vpiMucwNZI8HNYwXvn2mFqLhSIPgxIviO6AUmEainq11FQa43nihocE+Pqbqwvz24dteZioW8C2fCj9KxiqoMVXFtvS3lm2Ct7ru+DRTyG7kStHCBXNCagWQEGbN6I7quhHSF+gG5L7fNUZfrGAm8EvU5dv1fupIa0j52tCoBsrtBSBhV/o6OKlSRP4B05Ggn81ayq3SIlEJ43wAUkupSGFkEclCH4A+TUOuSaYHdrVUNnyrSqAkaDYalY1b05zqPGqVF9iU1MEfa8rArk/wPOhtOGUeqkvH8/QXidb3TUk49QxCFFUIjz65qB3TSXsKB/DTiNArncTr0M369saHYvUnu1S/sTsbfIvkWQNvLU0rnJa2KiCexcxsqn5rSzQfs+BPV5shcckhpG8nbJP+HMRawQ/xNgZQo08MXedJ0CYrLM+HJ7/jAY44rCxBS6952r/ryr+mEefXj31dJLhuK/YxHIslwnQmlYPdQKKfQEwYoeCgh5e55m//vr+dKbTuSOXGhtVxNGUykdg59cuH+Td3WQA+hyEu46mKh47Pq4PEWI6eT14Hcodk7gGKXNbURWxFaZNrP3/WwUx0B9AJDw+4iyzyK/MmTzphCwwk36NdYVAxF/EB/I5FFqupbSSn1jIgX6xA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(366004)(346002)(39860400002)(136003)(396003)(451199024)(1800799009)(186009)(5660300002)(4326008)(8676002)(86362001)(54906003)(41300700001)(316002)(66476007)(31686004)(8936002)(6916009)(66556008)(66946007)(31696002)(66899024)(36756003)(478600001)(2906002)(2616005)(6486002)(6506007)(26005)(53546011)(6666004)(6512007)(38100700002)(4744005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MFJ4bXZCRERnL0J6TlJjWHZBZlRUWlNySFVERmlKNjdOVFk4R2xYZjZDbitv?=
 =?utf-8?B?TDF6MkNZKzgzOXVoN2VHemNJeWhHYUZ3ZGd4NW1MaFpCVkxieHZWY284QkVT?=
 =?utf-8?B?QzVrUGxWdnpNQ1lDK2RGajJHa1BQT2Uwcnl6NzFCekZ3cTJUTUwwZXpCQm9T?=
 =?utf-8?B?VkFNSzRLejFtbXZxK29ZVlo5Ymp4ZXlselRJQUlCb3FzUHcxdEZLOThaNHdo?=
 =?utf-8?B?MCtFejFvaUV5b3NJYmgxV3BiQzFMVk8xUDQxRS9RTnlRVndqanBLZXM5aTFy?=
 =?utf-8?B?R3hDSktvMTJkdURINWt0Y1NkNWhadndTYWEvTHhNT0pSUktsL05CKzkvNmx1?=
 =?utf-8?B?WFRpZVhURTlsZ3Y2L1dyc2FNZENBU1p4S0JhMnFNQm5NblF5eHdGUkxKSnJt?=
 =?utf-8?B?OUw5MlJ1R0wwRjdhWko3MTZTODZnMlExQXNOQTJuZ3lKQjVZTDNjbDBCUW1t?=
 =?utf-8?B?SEdVWlNrT0RacVNPK0VtMVd1MFVqK2FkUGZoL2tCV1lhSm1JakN6M1VDNzNZ?=
 =?utf-8?B?MmEreFE1czE4ZFBKTmJ4RWo2SFZxaTBSSGRrNmhTYVNXUy9VNFFJVnh6NFpI?=
 =?utf-8?B?TVhrc2tGYlpDVHRqSTlTaGlBenpXMEFQZWdSYXoxLzlCcG52UlVSRWZDUHVG?=
 =?utf-8?B?aVJMbW9lRkozQm1HRTl6VTB5MUZGdVZaWXlsbU5vVnhzcHkvbG96S1pqYjBP?=
 =?utf-8?B?ejVYcldobzZ4bUpUejlIZjE4aWtVVldZZUN5QVlrVHdyZlpIdXVXN3R1enV5?=
 =?utf-8?B?UktLWURnb21UZ3c0SVBQTjl3RU16bDd1ME9qdDBhbHRDc3BiOWxrbkF2dlBB?=
 =?utf-8?B?b1VaWmU1U2pxaUxxbWFtNGxITXZScWd4R1ZmT2YvZER5UFdrYVNCbnBzM2R6?=
 =?utf-8?B?MDFPQnhDMzFzT1B3dTRuVitMUXgvcUR5MDUyNnNyU1JEU2hIQnVpT0sxZ0xH?=
 =?utf-8?B?S2ljNllja1l4WFJCVVJlU1hnU0RNMHJVN1VFMjZWb2tDdi9WNmx1UXplQVdX?=
 =?utf-8?B?UlYxdjdjaU8zaDZTR1djUzhyMmRyb0g5U2poNTE2TDEvajZjSFlrOGVZSGQ5?=
 =?utf-8?B?MUp3alFiSUVVczhJUFBaUG9pdDg1RWxpUTAzWXNyMG05OG0xVnVYdjYwNld0?=
 =?utf-8?B?N3Ewc3hSenExMCswVVE1SW1pTVAxMnNWK251MkROa2xLM3RTVThnVUNqbnpi?=
 =?utf-8?B?UHk5RXVDcUpzSlczdlZnSTFxQklQTFZFSUlxSDF0RGErZXpER0l5QURDcnFm?=
 =?utf-8?B?UjdVd0tIR1pBZ1YxOVJXOEhacW83ZFhGOHV3NXo2THV1R1VJdjl5d25icVUy?=
 =?utf-8?B?QUN6MFFyYktBYXo5dTkydEZrNE05UmtKNVN6Rm1UbmpGUUExbEdKb3NsWlJ6?=
 =?utf-8?B?aDNKT1FBdFZMSkl3cEp3L0FWZW85cy9zeGtVUkZ3RlVGMzcxS0UwcGRrbEhW?=
 =?utf-8?B?TFNuV3AvcWRrdk01aHo4WmZxU1lkKytxdCtIL0JRQ05kRUU2b2JKMTBOVFgr?=
 =?utf-8?B?UmVpN3BkaDBPZEdMTC9wMDNPQmxIOW40N3dqVGJoTEZ6WTNkanpTUG56M1lY?=
 =?utf-8?B?SU4wc1VvOG56R3IyWlhHWkdSZFhDV3JFQnJPOWIxeWpxazJTR0lpOUJTaW1T?=
 =?utf-8?B?eE9xdStlQTdyRkVMajVVeVV2ejVjYW5Xa0ZBcVM3V3FvbTE3MVJ5V3Yvanlm?=
 =?utf-8?B?VHQ2MWZ4ZjJBdzNlam43RHJXT055WE1GdjJMeGpNc1hkSTQvcmNLWEVLK25i?=
 =?utf-8?B?YzQ3TWdlUHpweVlDUjd3OWZBQjROcFJtbzBTNnIzV3E5S0hIQmFCcXVNYkY1?=
 =?utf-8?B?VW00UkR3N1VkZFpuUEhlSzltK0Izc2ZzbU9JbTRaZWt2OEQrV2paLzNhZWdq?=
 =?utf-8?B?aVVjc1pmQ3plaXA5QWFZRzcyNkVLWFdaYllwZWhmUXpWVkNmdmd2dGorY2p3?=
 =?utf-8?B?amY3L3JCQzMrUVpRMis1STZOQzlkMXdCS3lPSm5jTU9MTXlzV3g4ZVIrZXk0?=
 =?utf-8?B?T0VsUVgzSDhYTzZJRXhWNHB0TGdMTkc4cExPR2s2enNFd3dnRUVKdGMzWkVO?=
 =?utf-8?B?Nk9QSlRlVmxUQ0FyZHgxNVYrRncvSkdHKzMrQTBYQWdHeWZ6eVJzdFNMVEF1?=
 =?utf-8?Q?jQepyM9gmU5Fna9FHwdFjhbuW?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9aa38bac-c58c-4a95-1703-08dbb60c2ba1
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2023 16:52:39.2497
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EHeFKAfIOPLQVj2d0rivlifkzJsbXMgRC3HJ8vmOBnWFudoVcKq3hyZfmZ4BHcWVp3txwjDqkGueN0DojVOw7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6414
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/14/23 15:48, Tom Lendacky wrote:
> On 9/14/23 15:28, Sean Christopherson wrote:
>> On Thu, Sep 14, 2023, Tom Lendacky wrote:

> 
>>
>>> +        if (guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
>>> +            svm_clr_intercept(svm, INTERCEPT_RDTSCP);
>>
>> Same thing here.
> 
> Will do.

For RDTSCP, svm_recalc_instruction_intercepts() will set/clear the RDTSCP 
intercept as part of the svm_vcpu_set_after_cpuid() path, but it will only 
do it based on kvm_cpu_cap_has(X86_FEATURE_RDTSCP) being true, which is 
very likely.

Do you think that is good enough and we can drop the setting and clearing 
of the RDTSCP intercept in the sev_es_vcpu_set_after_cpuid() function and 
only deal with the TSC_AUX MSR intercept?

On a side note, it looks like RDTSCP would not be intercepted if the KVM 
cap X86_FEATURE_RDTSCP feature is cleared, however unlikely, in 
kvm_set_cpu_caps() and RDTSCP is not advertised to the guest (assuming the 
guest is ignoring the RDTSCP CPUID bit).

Thanks,
Tom

> 
> Thanks,
> Tom
> 
>>
>>> +    }
>>> +}
