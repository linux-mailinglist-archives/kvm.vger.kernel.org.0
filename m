Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD0C5F8DB7
	for <lists+kvm@lfdr.de>; Sun,  9 Oct 2022 21:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbiJIT1T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 9 Oct 2022 15:27:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbiJIT1R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 9 Oct 2022 15:27:17 -0400
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73FF02BB3D
        for <kvm@vger.kernel.org>; Sun,  9 Oct 2022 12:27:16 -0700 (PDT)
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 299CJrHC006978;
        Sun, 9 Oct 2022 12:27:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=bnMPoyCphK4IfqKKqpEjzfmG2+9vakq6dFtAH3Cx0k4=;
 b=pVXepM2PXs2Sb11ozh/KDAsXuX4+SJ6EiD/m3MsVK7rr6pX8SXY0mLwdRxHp1t0hsbJ6
 byf75+G/LZHA6hkdIkq5YRbIyT6cv3bjne3xrW4i014CHpjcX7MeS+tX5QaIp1XiZ8Et
 P4sqNTRCFgnTHFzBBDrJEuqVWh/3xfua1acMbmjADwm8sJSrHbZ36xEg7fhjgpCl+Bpz
 egeSabJ/bnrkhEntN3u446d1tvQ/xtrMc3rL8j5HiYRj/LGIzab0WDbqDVVVNZQZcXOQ
 6rrUcZtJq/nuqLFtVBu0y4svMgYpGXRTa/Vo014jyHlT7cbLJb32tyA70TiahqXc6Mcb oQ== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3k38rxt3sr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 09 Oct 2022 12:27:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ImU6vIry+QjOwepkrdN91O937WXGwsoqeDENvWR2Iv2IZHc4vj7P93Q5MSgR2EAzV4lF5WmZNA6Z3J9ZIRJK4ErmL2jmGVzdhjP9POd3aGzpsDd8bYkeqP7ML2HFOGOLU/LGuYxcPe0ThISQ596F4A3ID0tK7+41H1O3YTSbC6RA8byZ4DP2VF4+LcNZhjLtPt4MP7mZaC9CDZxhLI2W4UxfHqLuDK6hYGM8XVHdG70++H6Nxzjal28WeqRA6pjzBHp+ClEyXCykxtUfSe5Az7ypCCDZm252Sck3vyVxiZrE4KXaq+8Z147tXYV/yMTuSufpWzwbkffoXsaFB/1A2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bnMPoyCphK4IfqKKqpEjzfmG2+9vakq6dFtAH3Cx0k4=;
 b=LQZL89vjbJtiaoM9/q7LJtiEth6wOMcZXtxfrR/+Y0IhdCInSBHUgdmUfUFSOI8SWoY0wr9kmwPA093ZUKwqILl1IA+pnFGHQN6vLWpfIxySuczsLzqa0QB5tKfXqVpg4WvFIio/mp6oTYCATStgvgA0gC1wchtwqaDH6fbJgP5jKROmvLfsmD9k/heqiD89A/2rQSBusSpo/Bv4PRo4KkKFWlo7bCGl9Qxu2CHKC49V7IfgoJDDJTzTmUJWwRGzJjJUsjCbGm8PJK5D/KtQJlu46zAh1TE46cZ+KKjysEhi1hnacpWN42fYRu/l88AFQCw2VSy7SAXFCtU/kwP2Nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by CY5PR02MB8894.namprd02.prod.outlook.com (2603:10b6:930:3e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.32; Sun, 9 Oct
 2022 19:27:03 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::c0a5:1300:e72c:46b2]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::c0a5:1300:e72c:46b2%5]) with mapi id 15.20.5709.015; Sun, 9 Oct 2022
 19:27:02 +0000
Message-ID: <5feedb0e-202a-8624-601d-0058dd102c8e@nutanix.com>
Date:   Mon, 10 Oct 2022 00:56:46 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH v6 5/5] KVM: selftests: Add selftests for dirty quota
 throttling
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, james.morse@arm.com,
        borntraeger@linux.ibm.com, david@redhat.com, kvm@vger.kernel.org,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
References: <20220915101049.187325-1-shivam.kumar1@nutanix.com>
 <20220915101049.187325-6-shivam.kumar1@nutanix.com>
 <Y0BwDSIqPYCZZACm@google.com>
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
In-Reply-To: <Y0BwDSIqPYCZZACm@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0077.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:ad::18) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR02MB7555:EE_|CY5PR02MB8894:EE_
X-MS-Office365-Filtering-Correlation-Id: 41704dfa-9f3d-4035-535e-08daaa2c3e26
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vASNUp3USjqA8LCmuC87E0gMf7JaHGTJlrX1JqKswnysmRVXli7db9GhCj9CfS1O5EmKygKavDhlx00byPUBb+qF2mlGL55FSd32WralIEvZNHBzzHfvgrEI991QVbERoBBN7nseIWMFBX0mz+tdjU0c0fwyb8Y4GxBI1Ow9Mn/vdXtVco5kAP2JOjCshV5cLZjG2ez1kQxgpgDOhrRmemeBkaHNLHq+LU7AUbrYzKj4ORQybp34SG9wgi0bozOVrw3L7mFdWB9ngLH+8FHhZSVV37GLnyiia60x2DZtsgRHiP3Tig2h5JyooPOgZ18mLUHHTI8DSoHJhFRdGptPCjqfds9mD/ywGyj0RoVEfwKi2sed0zepNct8lOH/XPbKLHE2RNU0gRgDEOh6ZztMrglEapu5TMCeHajKKD/29VkncQCPXiJoAcy9QVuO/aPnvve1d/oNNK1UZ8STghXOKIPP7BlhEHN/mvyjt88XLUZL8pSkADaT7Q0+ShNB/2eBGvmUL/oZiMv4WQoViq+OH2rsInz0YQq45cwmc8q0By5XqaKfJpdqT8shs3hC5As06YlwMyUjSwuszFlm5i5whNc0M/rtsvZMjG/bYfx2YMEz4Exu/mQGUxUFUBIeDcDO8MlEXLQ5zdxu6dSLHTo8ElyDDbn9tuLDnx1eXCXrakcOxPhHnte2jQrWOUQjrQo1QuB32zZAGj/XiktHPPm8oaNyTZ82azmSlmm+7JnAkQ78NXmGD04vrr5TH+woi5FXO49TeHoFb4T1o6bVi7VYFLPfZ2aIFyJ5zNSWH39Zc7Z10rv9zZCeisqrwfwvK7/p
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(366004)(136003)(39850400004)(346002)(451199015)(8936002)(8676002)(6666004)(2616005)(6512007)(186003)(26005)(36756003)(5660300002)(53546011)(2906002)(66946007)(66476007)(41300700001)(107886003)(66556008)(15650500001)(6506007)(4326008)(83380400001)(6486002)(6916009)(86362001)(316002)(38100700002)(31696002)(478600001)(31686004)(54906003)(14143004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bkYwR2xQeW5EVlp6Z2I1c0xadno5MDBlVHZYZ2ZGdGNoYitGQ0tsR0NpaFRp?=
 =?utf-8?B?SnZQZ0tucldoZGxsOXdRakpFMWtRb01QZXk5OUN6YUNVck1RVUNoUEYrdEI4?=
 =?utf-8?B?bnlHMFZHckc1dmNIbm5FU0pyTjZPS1RZRTFuL1VmT1pwSWJJeW5HNHJhdTdx?=
 =?utf-8?B?ZVdlWEVOelluVVdkWmRMWkhnTDc0cUtkY2d4cFFjM1FrWlJxK0Vsazh3L242?=
 =?utf-8?B?TmwwWTAvaVVkNzFVMUEzOVNPMFZnWDlnd1lpR0ZSMXhsOHVIQUJXczJNQXFh?=
 =?utf-8?B?WENETW9NczZrSUhJUTErd2tkcWwrRlkra0FoZm15cTRyZzdWSGkzVzhGYXZ6?=
 =?utf-8?B?emtMZjU3czBxQkV3TGxmQlpmQlp4VGN6SURScHovckdRcWdjMUZSV2VrZDdI?=
 =?utf-8?B?a3JLUXNYOExUM3ZYYmhmaUJNREQyby95K1k2VkI4cWhTR2lkRTladGJETXBP?=
 =?utf-8?B?Uml6ajNMU1BEYUZTdmZ0Q0ZZZ1hWcXBOdEpDRjR4bytzV0tWOFRSMVBraXIz?=
 =?utf-8?B?MUNmOVA5ZnB6eHllNFpqNVBkUHBtNGdKU0RQRm4wYW94ZlVlR3JWY0h3RmRG?=
 =?utf-8?B?d0ZBb0h3MFZKd0NPek8vazhBc3ZsRWc4MkJzUjU4eGcxU2IzM3B5QmJnaFFN?=
 =?utf-8?B?QUJpbHQ0OGVEYitpMDltM2xRNHZxenhVUVdjZk9qNmJ2dDVpNEhwY0VXK21U?=
 =?utf-8?B?Zms3OVBFNm9odGFrZDFTaVJvWm1EQWpTQUdQVlBEUmJzayttekpuN25YYnlT?=
 =?utf-8?B?THQ2TEVDU29MUDEwUnlCVTRrVDZzc2RCZ3ZMbHVQL2FQb0VmUWpXTFNVTW5C?=
 =?utf-8?B?SFVuYVpRcmFyTzNVdHpTanJRVDlYbmZvSzdvb3gwL08rOW1ZNndLTlRjVG1X?=
 =?utf-8?B?K0g3Wkt5SjFNM1Y5VmF4cnhSbUlNRW95QXhpa2hBS29hWVNXcHNrejNKYlJ6?=
 =?utf-8?B?WEF2NWlKUlN2Z3cybTdwQmhPTVpRc0EzaldMWXdDcTdHb0R0L3NhaWxsRllY?=
 =?utf-8?B?K05PcFJjNGV2dTBwUVk0RlBPd2J5RHByZE5vVlByK0E2WkVaYStmeVhxcENs?=
 =?utf-8?B?cG5lRGpPN1JKdGpiTktKd0p2cFRSTEhRYnBobkhkK1FRVWpWK3Rjd01rSGE5?=
 =?utf-8?B?ZWlhdHBJYWtmWFFDTmE3R3NHWkQ4SFRGYTUyNWU1bU9YTmRXQjBMcWtrUnly?=
 =?utf-8?B?cWc4cm03L2JORTlVV2t1QnZmUjFoMytDbGsyT3YxK2VGTkJvUzRkUmlSb2I4?=
 =?utf-8?B?algzdmdhT2RianlUSVhmUEdwU1NJa1R3SFMyU1FoYWVxY0NEY3VsSUJxSFZR?=
 =?utf-8?B?UEJyZWptWjdoSWt6S2RLWFMyTUhyNzg3bndPRFViNXJxV3NYakJucEpaSXl0?=
 =?utf-8?B?TVBOcGE2dGh3U1o0OVArZFFldjZuKzJXaWNySkY5ZkhOZHBFS0drZE91TE4z?=
 =?utf-8?B?SWVydm04RkRSQnpFNFo4YkdDb1ZZQ2lQcThnNEk4T3JpWk1SK0dDODJYT3gw?=
 =?utf-8?B?Y3JNV29tUGhBaTF2L3FROHgzZnBxMHZRZzNKWFNNMW5nMzQxZndVVnNjdk0x?=
 =?utf-8?B?U3hFYmFTMGVuMFZwdlZHci9CUlRMS05sWWxlWXBYaHVMMkZ6UDV2TTFpK0py?=
 =?utf-8?B?MDlXVUtDeFdFVFEwSkZud0g1V1RRUGpISXkrWVBTbDhOVDFKZmdhREY5T0ls?=
 =?utf-8?B?ektDR2l4VHFaK1VabDBJa1lFQU93WUNSSjlRcXNTVEtRNWlySC9jWGorVTJQ?=
 =?utf-8?B?dEsxNndqcUJsYlB5T3g4ckhwdG56alk0OHdGemN4SDNTWDJtTGlMSEs4YWZO?=
 =?utf-8?B?M3N1bU5Wb3N5UTc3Z0lHMkxZVkhMQkYrd2tnS3lwbVFmOW5tWEhoZENzL3RU?=
 =?utf-8?B?SGNJVjgwV0ROSVpLYkNQMDBVQTRqcVRXQXRiTmxOa2lxSWZHd0JZb2VzTDJ1?=
 =?utf-8?B?aktZSFBsOUFKTUN3cjZiUXRqRngvdEFlQmxDZFdMLzhOUlNYbFZOaTR1OUEw?=
 =?utf-8?B?WTczbmtvSFN1TWFLTmhoMm1RV2R4NHVrS2lRVklvVExRODBJUHo1SlBab3Bl?=
 =?utf-8?B?amNYdnBlWE0wL3Jqa1RnVSt3Z2NaMHhzcUxBZDNpTWRidE1Dd0MvQ29KQmVQ?=
 =?utf-8?B?RDVKemxIaFVoeUVmWnczUnRUMmV0NldsTUVjNTI1RnpLQUhoVkI3a3Q5bElh?=
 =?utf-8?B?M2c9PQ==?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41704dfa-9f3d-4035-535e-08daaa2c3e26
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2022 19:27:02.7622
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J6zxS5MEvFUifTQmDyRjtRicehumwO4mLelVjCr3LPVuAtf3kCOT0LPi7H/80FA5ZhXdTUWsEPBrZQ1spSZJtRl7G3EKd0OXLVzWXDRTDaE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR02MB8894
X-Proofpoint-GUID: M5GSHxcv5q9mNifmZwTdooDdhans8too
X-Proofpoint-ORIG-GUID: M5GSHxcv5q9mNifmZwTdooDdhans8too
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-07_04,2022-10-07_01,2022-06-22_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 07/10/22 11:59 pm, Sean Christopherson wrote:
> On Thu, Sep 15, 2022, Shivam Kumar wrote:
>>   #endif /* SELFTEST_KVM_UTIL_BASE_H */
>> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
>> index 9889fe0d8919..4c7bd9807d0b 100644
>> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
>> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
>> @@ -18,6 +18,7 @@
>>   #include <linux/kernel.h>
>>   
>>   #define KVM_UTIL_MIN_PFN	2
>> +#define PML_BUFFER_SIZE	512
> 
> ...
> 
>> +	/*
>> +	 * Due to PML, number of pages dirtied by the vcpu can exceed its dirty
>> +	 * quota by PML buffer size.
>> +	 */
> 
> Buffering for PML is very Intel centric, and even then it's not guaranteed.  In
> x86, PML can and should be detected programmatically:
> 
> bool kvm_is_pml_enabled(void)
> {
> 	return is_intel_cpu() && get_kvm_intel_param_bool("pml");
> }
> Yes, I was looking for something like this. Thanks.
> 
> Not sure if it's worth a generic arch hook to get the CPU buffer size, e.g. the
> test could do:
> 
I can't think of any usecase for a custom buffer as of now. We are 
working on a proposal for dynamically adjusting the PML buffer size in 
order to throttle effectively with dirty quota. A potential usecase.
> 
> 	/*
> 	 * Allow ??? pages of overrun, KVM is allowed to dirty multiple pages
> 	 * before exiting to userspace, e.g. when emulating an instruction that
> 	 * performs multiple memory accesses.
> 	 */
> 	uint64_t buffer = ???;
> 
> 	/*
> 	 * When Intel's Page-Modification Logging (PML) is enabled, the CPU may
> 	 * dirty up to 512 pages (number of entries in the PML buffer) without
> 	 * exiting, thus KVM may effectively dirty that many pages before
> 	 * enforcing the dirty quota.
> 	 */
> #ifdef __x86_64__
> 	if (kvm_is_pml_enabled(void)
> 		buffer = PML_BUFFER_SIZE;
> #endif
> 	
> 
>> +	TEST_ASSERT(count <= quota + PML_BUFFER_SIZE, "Invalid number of pages
> 
> Clarify _why_ the count is invalid.
In the worst case, the vcpu will be able to dirty 512 more pages than 
its dirty quota due to PML.
> 
>> +		dirtied: count=%"PRIu64", quota=%"PRIu64"\n", count, quota);
> 
> Don't split strings unless it's truly necessary.  This is one of those cases where
> running over the 80 char soft limit is preferable to wrapping.  And no need to use
> PRIu64, selftests are 64-bit only.  E.g.
Got it, thanks.
> 
> 	TEST_ASSERT(count <= (quota + buffer),
> 		    "KVM dirtied too many pages: count = %lx, quota = %lx, buffer = %lx",
> 		    count, quota, buffer);
> 
> 
>> +
>> +	TEST_ASSERT(count >= quota, "Dirty quota exit happened with quota yet to
>> +		be exhausted: count=%"PRIu64", quota=%"PRIu64"\n", count, quota);
> 
> Similar comments here.
> 
>> +
>> +	if (count > quota)
>> +		pr_info("Dirty quota exit with unequal quota and count:
>> +			count=%"PRIu64", quota=%"PRIu64"\n", count, quota);
> 
> Not sure I'd bother with this.  Realistically, is anyone ever going to be able to
> do anything useful with this information?  E.g. is this just going to be a "PML is
> enabled!" message?
I thought this information could help detect anomalies when PML is 
disabled. If PML is disabled, I am expecting that the exit would be case 
when the quota equals count and count wouldn't ever exceed quota.

Now, when I think of, I think I should move this statement inside an 
'if' block and make it too an assertion.
	if (!kvm_is_pml_enabled(void))
		TEST_ASSERT(count == quota, "Dirty quota exit with unequal quota and 
count.");

> 
>> +
>> +	run->dirty_quota = count + test_dirty_quota_increment;
>> +}
>> -- 
>> 2.22.3
>>
