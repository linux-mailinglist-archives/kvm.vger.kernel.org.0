Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00A057CC09B
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 12:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234801AbjJQKYm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 06:24:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233570AbjJQKYl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 06:24:41 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2062.outbound.protection.outlook.com [40.107.92.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 826ED8E;
        Tue, 17 Oct 2023 03:24:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hIwND35CjyiM4db2fCgPyB8elnu4xQAx5+mgEaGkC1yncUr988efMZPxUO6Ei6xolFeXWk7uPvfsvjsY50UbL07KIwQSb9ps82VTWkOdO5LXDeEZrwHJBvo6FDohbAvkIaVBzuPkxDfEwJL+Q/3rkyxl94c9o94xKAHzRgH1sKpivXuOU86Gl+AT6UmGrwqfwiF7QJ0mfM09lNvf/WfuGTtUgg9uEdHiJQUwQtwUpBLB1ALnw+iSgZMfLI727vHe58WSwo10GDLguHe23vjr5dtk4yXxUrVHXAcXq88PTCPgDRTC21xbxGVeI7K9GBGDcTOPJ3PIk+qUJ+vO2D3o1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hkI/ESHaVWN97YLxP2N1yT5zwD12AFsR7KpZBtrljjI=;
 b=Jo6/5/+Wry9zjW9kOQLFz0G5o5EbLJyQkMy0s3opiO9zaCsemCXle5hLfHEIummv4E26+4sS0YvNpQqAPkrbv1OwnHNWwC8Epfro4hAc6To7kDDPp0Q7/OQGf+QSXoPDV6HMablHXf9GVh2IjFDVMt0uM1lWCkY9o0Cdxnq1LWGOxsncsyFhZAKGNcJtqnMM37+CFNAEUikOVyXRUPuflbfmKBx6yxnOFp6ZYC2Qhbv7piXQuPCnOsBAFZAvVL6kpCmTkuQibLFq1Z16D981cJfV2+A+zUvusSzocHVPMxJYN3+2tqe12EWjQrKCdBTLvVyRSsfXYwenUTpW0kuGGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hkI/ESHaVWN97YLxP2N1yT5zwD12AFsR7KpZBtrljjI=;
 b=tgMF8GJeNwms9quKFbvWQ7DOzuIq96OAvUtrPfK+Yk3g7s7ElYnKZllW0KNY7+q2PTbNnFNOo/91ndPTfnm2f7FXkGJRSKSjVQcUC9R50wMpKbGKl4tM6fghvQi6qzzkyGWMXIFAAl8KKWx969CCphSzzYYvepeBL8rTPwK40ZM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6214.namprd12.prod.outlook.com (2603:10b6:8:96::13) by
 IA0PR12MB9046.namprd12.prod.outlook.com (2603:10b6:208:405::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.35; Tue, 17 Oct
 2023 10:24:37 +0000
Received: from DS7PR12MB6214.namprd12.prod.outlook.com
 ([fe80::2d00:60c4:e350:a14d]) by DS7PR12MB6214.namprd12.prod.outlook.com
 ([fe80::2d00:60c4:e350:a14d%5]) with mapi id 15.20.6907.021; Tue, 17 Oct 2023
 10:24:37 +0000
Message-ID: <b2bfead3-0f48-d832-daee-e7c2069dae5d@amd.com>
Date:   Tue, 17 Oct 2023 15:54:20 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [Patch v4 07/13] perf/x86: Add constraint for guest perf metrics
 event
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Ingo Molnar <mingo@kernel.org>,
        Dapeng Mi <dapeng1.mi@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Like Xu <likexu@tencent.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>, kvm@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhang Xiong <xiong.y.zhang@intel.com>,
        Lv Zhiyuan <zhiyuan.lv@intel.com>,
        Yang Weijiang <weijiang.yang@intel.com>,
        Dapeng Mi <dapeng1.mi@intel.com>,
        David Dunn <daviddunn@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mingwei Zhang <mizhang@google.com>,
        Jim Mattson <jmattson@google.com>,
        Like Xu <like.xu.linux@gmail.com>
References: <20231002204017.GB27267@noisy.programming.kicks-ass.net>
 <ZRtmvLJFGfjcusQW@google.com>
 <20231003081616.GE27267@noisy.programming.kicks-ass.net>
 <ZRwx7gcY7x1x3a5y@google.com>
 <20231004112152.GA5947@noisy.programming.kicks-ass.net>
 <CAL715W+RgX2JfeRsenNoU4TuTWwLS5H=P+vrZK_GQVQmMkyraw@mail.gmail.com>
 <ZR3eNtP5IVAHeFNC@google.com> <ZR3hx9s1yJBR0WRJ@google.com>
 <c69a1eb1-e07a-8270-ca63-54949ded433d@gmail.com>
 <03b7da03-78a1-95b1-3969-634b5c9a5a56@amd.com>
 <20231011141535.GF6307@noisy.programming.kicks-ass.net>
From:   Manali Shukla <manali.shukla@amd.com>
In-Reply-To: <20231011141535.GF6307@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0053.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:98::14) To DS7PR12MB6214.namprd12.prod.outlook.com
 (2603:10b6:8:96::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6214:EE_|IA0PR12MB9046:EE_
X-MS-Office365-Filtering-Correlation-Id: d48c7f94-beaf-4f59-8077-08dbcefb432f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 54TDlUDGqRqMDC6EKucEzfGRjGDZuEQp/Du+oCMAXQcImnmswBr9qizOi3JKAQeEUqhV6G3xtvLDLxUhb6W2eVg2xsp9229evs/0OsX/eDoPYdJ68iquQYrqYIvWX2NgmGlAUYNUG+A1eBy9KdCIpcaPDfpTFsnxPk3JCZORYJdISucdWtpSPzBcmYPWPAM1rKZut5UlX4DjuMCqr6zNWIjNN2s/lLxnte1RI64TIIK/AZ8rK+cGl3+tusy9eJroSH7/+3BuLxJB5VIn3vJE8cmNvu2FwzAmusn8R08A8SpK9fA3uY+g6wTCtdrYqzSUlSj620sooeiOSHgKlkmfxU0fPz9cidaNUGeVaE2fnGzRgElK++pFIUzOBboncHYCz/CiOiOgOyXXC0L4ML84bFIeuE7lsi1bo2L7T/c7gNKaV+WK5UeTZpiwKRvSMiBR3+N9S2/0w4OkJ5r7Ovp4O8F4IklwX8iBXpIYupmATADGBuqamgN7eVPOkw49YkrMg7gwAo1CV8OEFrJoSRR3pxRPwMHb9ktZhy7JXlQ0vGtM7ex6mIAFjQhRPSEmKjwfb6XGwmFrIh/amiOUT/017Yw1O2oxQQrYNtWzoiOwXZMQK2ZLrOGty0Q639Y2v2Jv7nMj6sWSUDnI+1tOnUYgfg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6214.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(366004)(396003)(136003)(346002)(39860400002)(230922051799003)(64100799003)(451199024)(1800799009)(186009)(31686004)(6666004)(478600001)(66476007)(54906003)(6916009)(6486002)(66946007)(66556008)(41300700001)(83380400001)(31696002)(38100700002)(86362001)(6512007)(316002)(2616005)(26005)(6506007)(53546011)(5660300002)(44832011)(36756003)(7416002)(8676002)(4326008)(2906002)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MFNRclVSVGVrSTZreTJaaitwWXBaOXFiRitEZWlYL09YOVRyZFdOTXl2dVp1?=
 =?utf-8?B?QVA3eU11ajRnc3VGQk5CMUZKRDUxQm92YXhjRUJ5RnZoWUFzM3NlN0VKalhO?=
 =?utf-8?B?enJqQTN5bGRWMXZ1bVB5eFE4VmVlaTROOCt0VzhoMHozd1ZmcXdlc2Zvb2lJ?=
 =?utf-8?B?MDZtaXNzcEVGZnNaMTltRFg0a1JwckQ1d2xQOTZBV0NEOFp2V0FwR3lRVUd3?=
 =?utf-8?B?Znk2VXJaRVdLRnZnOU1rRnY2dkY2RnErSmI5N0lKSURCTkNwUlNjM3ZZUVQ2?=
 =?utf-8?B?RnRiNUhidXFRb284cmdwOENja3FQa2hERlNVZmxMZ3JGL1JqMkxPK25PS2xw?=
 =?utf-8?B?QTNla3NlMmo0TGxaRm5IRXU0c1EwbzN0bmM5M0pzWHZHOFFMMUtCN0lMWU1x?=
 =?utf-8?B?VVNrbGpBamkwcldSdXJkdE9ZVWdzWDZBTSs3NU0xYnhSWFNpeFYvdkY2bmh0?=
 =?utf-8?B?OGZXS2Y4cWU5d1FpblRRNHIxaU16OWUvNkNveStVY2EwYVJiODBzVmdVcnh4?=
 =?utf-8?B?MHF4VU1tRzFFaVlUVEh2bjVoYVdMbHdBRW5RTENISU9TVisrV1BvVXordzNa?=
 =?utf-8?B?U013NnNLU29jaUorajg1V0tiYll3eVFjbTFNcDVmUFphOGMvMnhYQ1F3cjMv?=
 =?utf-8?B?UUtnRzkrYlFzWUUzbVUremdVUVN3K2NUWFA0bVBKTTF4RnJLdlNtWU8rZkpw?=
 =?utf-8?B?M01XbDRhL1JNUmRmNEtYM2pqQmYwRXo0d1RCdmhLZlZMdENkS0EyNzZkenpu?=
 =?utf-8?B?OEJmRS84N0tkdld3REVIOWhqd1hSV1U4WDVYcjVhbWxrWndueE52U2FSZG5G?=
 =?utf-8?B?Z3RuQ2UzaVkxSHFmR09oUzNRQlFrZjNVQXgzSC9uZFpsbHMwODhyc1dYL3VE?=
 =?utf-8?B?SlR4V3lxSFpvNXQyUjh1MTRPZ3pva1UyYU44R2IxRlZyc2Fja3V0MHVYQW1W?=
 =?utf-8?B?d3JRMi9KSnl0ejFiNm5VTEsxcm5LblIyV0Q4WFJycU5iUFVuY05wT0lqLy95?=
 =?utf-8?B?cFJWellMcEs4bklkKzdaR2tXQnErOTljaXUyYklmZ3RkT3NQYUp1VmU2Q3VT?=
 =?utf-8?B?MDRXOXVoc1Q5OEcyTjAzMVRmcER4Si90K3J1NUYwUW5EWmRDeHRUclAyRjNY?=
 =?utf-8?B?VXhqRi83clh4MVRqMXpMWVdSTDFIeFJBbW5OTlFUeGJwNjVZdEtRWWw2ZHRa?=
 =?utf-8?B?NHdQc0t2anVpVm9hUU4xWXIxRVIxS3RreC9YcDhuMUNwZm5PdlpTQ0lIM1BL?=
 =?utf-8?B?YjVRb1NOdjF3a01HZWhVa0JPNGlRWVR6TW5pOVhLS2NEQ0VuYkJUaDhYZXJ5?=
 =?utf-8?B?VVBGRmVrV2NtRzRYOWk2b2dDZTYvellPbFp3UERtZWFRZXYvd1B6WmU3czlo?=
 =?utf-8?B?amI3R3RBcnJmNE8zM216anZOMHUvektlRk56MTdqeUttUExSakNvVXlsSnJm?=
 =?utf-8?B?clZCVGozRXJzZjhBSHljYUhEN2NJNngzejBHS1hDdGc3aDJIckxGenJqdkNp?=
 =?utf-8?B?UDk0RlRTdHF3bnpRQnpsSzNyR2RrK3AzUmRSb1pIdU9nM3pzS3VhaEJuRWhq?=
 =?utf-8?B?MDFyb052R2QwSHpUWENvYjhGa1M0YnlQWUdsUkRGMFNBK0ZHZnM5STl1Nkpq?=
 =?utf-8?B?dWtSN1NLc0ducVBpYUUyRHRCdkswQUl6STFZenErTGo5ai9NendXVEJTbTly?=
 =?utf-8?B?ZS90RnhzZlZJSUlsb3VEUG5vVFBhczYwNkNvc1B0QndYcCs2eXU1WTRjVlZF?=
 =?utf-8?B?b0c4OGliU2NlZVJrZ0hNalFsdUpCbi9aQzdhWEZMeExHc2pvZ2JYQ1JFaUNm?=
 =?utf-8?B?ZzdJa0kzOVNoeUpvcnhNWDFCYkFLdGZjMWV0Z1dTM25KV29FTWdubUZUVUll?=
 =?utf-8?B?SmZQNitxcXFVRGk1RDJiK3VzTHluM2tmbFZ4QlRmOExDQlJWYTRiT09MSGV2?=
 =?utf-8?B?bEhCaFJCQnVJWkowSmFBSytwcVliREdtZGlLQ3VlSHg1dW14WCtoTm1TSHpm?=
 =?utf-8?B?YXc2TllhUkM5WmU0eUd3cU9zVzZPYU9kZUhXSEsxaTNLRWJaSDJvenVHc25U?=
 =?utf-8?B?M1BLemdGUUlTODNVYkZVN29TUEtVeUloNmVvUjJXOTNLOUNSZWhmTHBmSTNv?=
 =?utf-8?Q?Engi8IdTE2r2kSlSz8OWq4BH8?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d48c7f94-beaf-4f59-8077-08dbcefb432f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6214.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2023 10:24:36.8835
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8QlTE4/zQ4WtJ9Vp0cUieFmZ9Kl3gp26tUMT3hZIwIr2LzbPqgQwtrrH6RMc+P32U4JaeCogHO0YMMWjM3wRxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB9046
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/11/2023 7:45 PM, Peter Zijlstra wrote:
> On Mon, Oct 09, 2023 at 10:33:41PM +0530, Manali Shukla wrote:
>> Hi all,
>>
>> I would like to add following things to the discussion just for the awareness of
>> everyone.
>>
>> Fully virtualized PMC support is coming to an upcoming AMD SoC and we are
>> working on prototyping it.
>>
>> As part of virtualized PMC design, the PERF_CTL registers are defined as Swap
>> type C: guest PMC states are loaded at VMRUN automatically but host PMC states
>> are not saved by hardware.
> 
> Per the previous discussion, doing this while host has active counters
> that do not have ::exclude_guest=1 is invalid and must result in an
> error.
> 

Yeah, exclude_guest should be enforced on host, while host has active PMC
counters and VPMC is enabled.

> Also, I'm assuming it is all optional, a host can still profile a guest
> if all is configured just so?
> 

Correct, host should be able to profile guest, if VPMC is not enabled.

>> If hypervisor is using the performance counters, it
>> is hypervisor's responsibility to save PERF_CTL registers to host save area
>> prior to VMRUN and restore them after VMEXIT. 
> 
> Does VMEXIT clear global_ctrl at least?
> 

global_ctrl will be initialized to reset value(0x3F) during VMEXIT. Similarly,
all the perf_ctl and perf_ctr are initialized to reset values(0) at VMEXIT.

>> In order to tackle PMC overflow
>> interrupts in guest itself, NMI virtualization or AVIC can be used, so that
>> interrupt on PMC overflow in guest will not leak to host.
> 
> Can you please clarify -- AMD has this history with very dodgy PMI
> boundaries. See the whole amd_pmu_adjust_nmi_window() crud. Even the
> PMUv2 update didn't fix that nonsense.
> 
> How is any virt stuff supposed to fix this? If the hardware is late
> delivering PMI, what guarantees a guest PMI does not land in host
> context and vice-versa?
> 
> How does NMI virtualization (what even is that) or AVIC (I'm assuming
> that's a virtual interrupt controller) help?
> 

When NMI virtualization is enabled and source of VNMI is in guest, micro code will 
make sure that VNMI will directly be delivered to the guest (even if NMI was late
delivered), so there is no issue of leaking guest NMI to the host.

> Please make very sure, with your hardware team, that PMI must not be
> delivered after clearing global_ctrl (preferably) or at the very least,
> there exists a sequence of operations that provides a hard barrier
> to order PMI.
> 
We are verifying all the corner cases, while prototyping PMC virtualization. 
As of now, we don't see guest NMIs leaking to host issue. But latency issues 
still stays. 

