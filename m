Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 532AD5F8DA4
	for <lists+kvm@lfdr.de>; Sun,  9 Oct 2022 21:05:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbiJITFm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 9 Oct 2022 15:05:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230141AbiJITFj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 9 Oct 2022 15:05:39 -0400
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CA4E1D643
        for <kvm@vger.kernel.org>; Sun,  9 Oct 2022 12:05:38 -0700 (PDT)
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 299CJrGU006978;
        Sun, 9 Oct 2022 12:05:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=8uJ/G4r9Ho18vSaeDXSfxMABVad7E4RQyaH4E3bjKC8=;
 b=J8YaOZSui391dNH/9cYf/Z1mby6LKnINc/Sd7gSYN1+T9q/25CkUCARHKa25TZknuEBG
 8ckNLCmhBYelteZsP8/AgO5AS0TURXDrXquOI+G+Uhza70T+UvAyDtRjcqSDdcgXl4T8
 BPGuJp1Dtwwmmd6EMyRXGeQh8rOUdsW4ByBZ1b7QkAzcE2Y3fq9vK4EYdMGPcyhjAlnW
 NGp76einMUgKlXL1A0n4i5CGJTOou3OOUDDJwC/BUkAZStmHkc94RcmI/2RZ/d92D8DJ
 m5m37XzulIG2KU+0HSYBk7oUIW/3BUGVDW5/5RapVHsWXpx3+7xj6FvvIvx0S+0vjH/c yQ== 
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2176.outbound.protection.outlook.com [104.47.73.176])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3k38rxt36j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 09 Oct 2022 12:05:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W/VpcjsCCkA2o4Hfexkf4hmXx1/JIkeLKbvRGcWZ6jld/6tuDWaM0l50k8kbr1gGZVg2RoDzTjT7G3d6T21ssSH3oAlb1XdUJTuvJCSWAp5tcLB9ooK4OSxeJ5OFkXSBZzV8CQCodEVFKVHWNMSwDVQm5rh9fhJGPr/VTohceT7jMzIAAJfUvfEt4IwUnxzNRvzIvwScDaga6VfBFhbX3qEZ0fuqI4gOTgxiJjAhlThPyXnuSIH5rU2ZInnZTa9E/BNKRWRHfA6s2XgZ2mxu/+WkFR6BBYPIKFkfh51L/u6RPVrp7N20ICkh4WTOAOgw71ATA6lzXnHoI2nutT4qSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8uJ/G4r9Ho18vSaeDXSfxMABVad7E4RQyaH4E3bjKC8=;
 b=F5pNkFYUH7jiGbVNajZTAKKygoylshvdRn/dOhesHgmOS+BOFJ6GqAagKINwcuCbHj7BUMjWR3PY2bVTJD5iHXhNWyrpiDlSukfPXsZMRiCPp5BJh1s95MG8yAQ+5bVAreHo7T9mJwIYRXpS0L3zXkyUZKoVa7wvR0vmqlq7mliTsK/G6zZBeLXIjGSB5yDkxiTbHxCThPVhDNRa8jsXDliZA4HqIWOC4s0SBaYKmRT5ya/tXaVTsvfcTMCEBItVY4C6fjikyZKvsc4G6WOCBgCXcSav7DtJAGwOlf+NyA6u5e3jtbXo+rbFTpOay5STtgi2YZ2ga/11YHvsGTxc6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by BL3PR02MB8219.namprd02.prod.outlook.com (2603:10b6:208:341::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15; Sun, 9 Oct
 2022 19:05:24 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::c0a5:1300:e72c:46b2]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::c0a5:1300:e72c:46b2%5]) with mapi id 15.20.5709.015; Sun, 9 Oct 2022
 19:05:24 +0000
Message-ID: <c6700c5d-d942-065b-411c-7f4723836054@nutanix.com>
Date:   Mon, 10 Oct 2022 00:35:12 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH v6 2/5] KVM: x86: Dirty quota-based throttling of vcpus
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, james.morse@arm.com,
        borntraeger@linux.ibm.com, david@redhat.com, kvm@vger.kernel.org,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
References: <20220915101049.187325-1-shivam.kumar1@nutanix.com>
 <20220915101049.187325-3-shivam.kumar1@nutanix.com>
 <Y0B+bPDrMdJQVX6p@google.com>
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
In-Reply-To: <Y0B+bPDrMdJQVX6p@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA1PR01CA0145.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:71::15) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR02MB7555:EE_|BL3PR02MB8219:EE_
X-MS-Office365-Filtering-Correlation-Id: 21f6378f-d411-433c-919c-08daaa293810
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J+/zolylx9Q0KRP4kfTOZLNYV8m6RfWTRC/vCiIFQ3S3ZhTgtzkw78y7VoMmkURYduaoepVYo6P0ndNGEoo4hr989EXwo+MC5T6YuIkibD9872BZP+hVOJsipnJWfAvlA5IJyo8AKmHAdF2as1T5nslKlmjFkMvBZf19oWUD8rhch+wkFHFCUvyY/MhckSYTDZlvMpqI9Z33IlTpMHwVh+2GDTvkYadagYobK84uxP7kR3OXFXHnizKtCGK2vZTPGZ/AKZRwpOHlPkCSusY8WjyVk/wnODt+33SRPfdmGA2cIqG5iqw8GKaoMyBAMMtzldIVrND2xjzOijcdVBZgsAgRx2jJvO/S4QkN/EldtYA/QqDI5pqjc0v6Xi2yFnHlEXlRXYIfL/VEUGrI6M3SKGhVhPI9oA1NithyqVfM27zPowLMNrDaNa5MeusBa8p6wqHtA4Sd62NJiunUnARmhThmCARV8aYwFUOyzFU1RofdM5qGK4VyDfFoEJHEEQfmZHd/NJo3ZI+no4HgYv/k02k7YLa9QaSOe0hUhBzK5trPAdN9KBLCXWGI2/NYjzcEw/lTPZilTg+gzHOFV8QunFuQ8FBR6Pd5yNOslV6gMX3UJ3nJ3QJlnk8hrXNQ42cGnn0IGoXaWHtrn/HyphnFOPuVBHgj6r4JDZzj8DSEWAnjnoAPEaNmqtm4n7DrCKw3rf5vVhlt3NxX5cIV6lbhr3cgnDLC+PB5eowISOGWTTsXKHH1g+O1G4GDj81ez63Zx5s7IxSzta2Q8d00M2lBveFBZ1u4i5Ek4KxAlqEdfbdvjLxYaotb23sYVn1xM0br
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(39850400004)(376002)(366004)(396003)(346002)(451199015)(6512007)(6506007)(26005)(478600001)(53546011)(186003)(107886003)(6666004)(2616005)(2906002)(15650500001)(6486002)(83380400001)(66946007)(54906003)(6916009)(316002)(4326008)(41300700001)(66476007)(66556008)(5660300002)(8936002)(8676002)(86362001)(38100700002)(31696002)(36756003)(31686004)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?elEyMFNDS2lSTkJ3aFd3bUVzdVFwSlB5b1VuenZpWDJmREl0SndadjVFWlVa?=
 =?utf-8?B?RjYyOVRNa21MT2RlVFgremM0M094TEpFTzg0SHVEQVVqSDI4VXN0VUxuTDdF?=
 =?utf-8?B?d2ptVXV0a0JBVHdQMEUySVJCSE95RjV6Q1NZOU9aTEhudVQxdXd4ZitGU2xl?=
 =?utf-8?B?bmJ1bmE3eEpIK24ycWlEQk95SnpreDJCLzN0MGNaeWZhbkJqams4aDFFQnl0?=
 =?utf-8?B?eHoxempIY1F3ZW9RY290c1RML2RLeEI2SC9UUDNUd3FoVk5vdEwzNDl5UW9G?=
 =?utf-8?B?dFR1cUFLMk90bytaeEIybkxhbUtxUXVUSmswbWdQanVHb2g2anJsY2x2REdM?=
 =?utf-8?B?eG1zVnZlbUt1NWNXN3g3Q1NBNFQvanFRcGU0L3JuU0Q4SXZjRTNCKzFjRXZG?=
 =?utf-8?B?QVZPRG5Ed21jTjc4d2lZckdqVkdQM01XMmp3My9GSXdtc2QvWlJWbUJJNkhL?=
 =?utf-8?B?WEZKaGFZT1lBV25wekVDOFdScWtyaFF2LzFjaGtjNEJRbEY1Y1Q1YVdrWW5W?=
 =?utf-8?B?dXNWOGFIWVEwUzB3UDQ1L0RBM05uTUd2cjVPVWpRamVFWVF3c00xZFlaT1dx?=
 =?utf-8?B?dFcrY2NncXVDdlRVWUF2OXJxdzROV2QwaUdmdWVRZ016aUx4dy9Yb1FVd0ZC?=
 =?utf-8?B?VUpmcDRNT25ERE9UWnRiZVpha29YeVR2NDJTUXJITndaWHNja2YzdDY2NUxL?=
 =?utf-8?B?dWhmQXR0dDdOTVJlNDc2dy9XTEIzTEJUTGdwQmhiOE5kWC81SG9GUVNrSjU4?=
 =?utf-8?B?bDUwUzRwS1d0SDVCalhCRVJsOVU1aEc3dmZBbjVGRlNGdVN3eDB4MVRjSE51?=
 =?utf-8?B?RUZQWG4zcFNJbFBoSVZMZTJaSjd0YWFsNEt3SEI3QkNiU01EK3NNbUEvcnJP?=
 =?utf-8?B?eCtuNGNIUEw5THdkRU9CbHZMN3dkZkhSUlMvbU9yelhMUGNDbTdqb0QwbzFL?=
 =?utf-8?B?ZWV1OHF0UllZVEJVcFFiVCtUSmlIODV2bUJxK2VST1RDejMvRW02ZHBlVEhG?=
 =?utf-8?B?Yndla05Rd0UxU1lEK0ZuMUtFK0c5cmtWb3IwWG10aXR3V28zZXhEMnJac3lR?=
 =?utf-8?B?d3NDd0t0WDBxcU9tL3FjejRQaFFsNUVEUkVsRkZNTzVBUGRBOSt0OVAyQUtS?=
 =?utf-8?B?Mko4RDAraVZ2VlVjcThNQzVTYjdISzQvRW5KbU9PZldXU2F2Qk9HNDlJcDVa?=
 =?utf-8?B?TnhCZ1hhUmNmcituQVdBa0U3Z0FrQVV3S2h0aC8rMU1Lam1sV2ZjdUEwcHFO?=
 =?utf-8?B?Tmx0b0M3dFJMNW0xS1Q2YStrUFJwdmQ0bDdwY0VadXJXaUgrbk1VelVhbGNO?=
 =?utf-8?B?bTFGUGFsZGNxRHB6djA4dmF2d0FBTjRvbGpkV3dpQXhudkNtVTVoSTNBY0pu?=
 =?utf-8?B?RGxPa3F0NlBpQjUyTzQybnlnendJdm1pMGx3RFFVVUFPM3Q1YmJvK20zSC81?=
 =?utf-8?B?WnBnRWh1d3FnN1lBaUNESFl2TWY3SXVUUlJseVVQNlU1dnJCV2g2L2pyU0ly?=
 =?utf-8?B?cWcwT2E2WUdZQXdDaGJiV2g2RUVxVTYzNUxwYW9DUDM5d2JUS0pWdUI5M1No?=
 =?utf-8?B?ZE1pZElMYTNUT1MrYUIxRGQ0UHFJL0NYNzVMQW4yK21HZjVJbkZ6eHFCdmFG?=
 =?utf-8?B?VGlBQTNkL3NXUFJ1b1pBbnExc0h0bXptWnk5VlVOQUhXS3BYZGxiWkVxSlo4?=
 =?utf-8?B?UmV5Y1liMUprTTREVVVCOE1MejFhRG5XMGxueEs5RkY1cVNGQ2xnSWYxdWtp?=
 =?utf-8?B?VVRNbXExa0pYcGJNMXhGaHgyUUM3eWhIeXVpQjhDS0JQamZtTU81UEtRS3pQ?=
 =?utf-8?B?QkgzV21yZXpGQTM0bE1xMXZ1TjJ1NHltREpCanFZMGNNcGZLcGlXeGtZTUQ5?=
 =?utf-8?B?ZmNDbEQ0SUg2S1J0UGtUZU4ySVdsdzA5QlAwWDh4TWpQc01Nd0dVQlhNRnFx?=
 =?utf-8?B?RlA4YjNnMVBHdE10TWRQL1grOE91TGRYMlFhQ1h2azJqaE5ObmVrb1NwejEz?=
 =?utf-8?B?UWxCMHRLRzlWZkVQV0hsM2RRUTk2YjU3LzBESXVzWlRBdy9EQlJsTEdBNHRo?=
 =?utf-8?B?MnhxY3ZjNzR5UmNFdHI0RkFwSDZpbUUzc0pjRUxBSGxoazM0U2M4a2RDcTZ3?=
 =?utf-8?B?d3pzTVVNQlBwZjg5QU01R1dNUFNpQ0p2d2NFcWhjeUptNkttaVVoUk1CU2dD?=
 =?utf-8?B?YUE9PQ==?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21f6378f-d411-433c-919c-08daaa293810
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2022 19:05:24.0773
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8HfFbuQivbRrcV2uPOQLU7b3qT8UDqfDpq0WUuGbfGIP0J+eJ6Ss+uET+3AYqG6dkThCpL7BZCnQb2XvKPcsobxKswCqwhJCSZrtSBeT3Rc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR02MB8219
X-Proofpoint-GUID: Io9weZN56JB9dcs7Cc6FHJJiadS11fbX
X-Proofpoint-ORIG-GUID: Io9weZN56JB9dcs7Cc6FHJJiadS11fbX
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



On 08/10/22 1:00 am, Sean Christopherson wrote:
> On Thu, Sep 15, 2022, Shivam Kumar wrote:
>> index c9b49a09e6b5..140a5511ed45 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -5749,6 +5749,9 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
>>   		 */
>>   		if (__xfer_to_guest_mode_work_pending())
>>   			return 1;
>> +
>> +		if (!kvm_vcpu_check_dirty_quota(vcpu))
> 
> A dedicated helper is no longer necessary, this can _test_ the event, a la
> KVM_REQ_EVENT above:
> 
> 		if (kvm_test_request(KVM_REQ_DIRTY_QUOTA_EXIT, vcpu))
> 			return 1;
> 
>> +			return 0;
>>   	}
>>   
>>   	return 1;
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 43a6a7efc6ec..8447e70b26f5 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -10379,6 +10379,15 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>>   			r = 0;
>>   			goto out;
>>   		}
>> +		if (kvm_check_request(KVM_REQ_DIRTY_QUOTA_EXIT, vcpu)) {
>> +			struct kvm_run *run = vcpu->run;
>> +
> 
>> +			run->exit_reason = KVM_EXIT_DIRTY_QUOTA_EXHAUSTED;
>> +			run->dirty_quota_exit.count = vcpu->stat.generic.pages_dirtied;
>> +			run->dirty_quota_exit.quota = vcpu->dirty_quota;
> 
> As mentioned in patch 1, the code code snippet I suggested is bad.  With a request,
> there's no need to snapshot the quota prior to making the request.  If userspace
> changes the quota, then using the new quota is perfectly ok since KVM is still
> providing sane data.  If userspace lowers the quota, an exit will still ocurr as
> expected.  If userspace disables or increases the quota to the point where no exit
> is necessary, then userspace can't expect and exit and won't even be aware that KVM
> temporarily detected an exhausted quota.
> 
> And all of this belongs in a common KVM helper.  Name isn't pefect, but it aligns
> with kvm_check_request().
> 
> #ifdef CONFIG_HAVE_KVM_DIRTY_QUOTA
> static inline bool kvm_check_dirty_quota_request(struct kvm_vcpu *vcpu)
> {
> 	struct kvm_run *run = vcpu->run;
> 
> 	run->exit_reason = KVM_EXIT_DIRTY_QUOTA_EXHAUSTED;
> 	run->dirty_quota_exit.count = vcpu->stat.generic.pages_dirtied;
> 	run->dirty_quota_exit.quota = READ_ONCE(run->dirty_quota);
> 
> 	/*
> 	 * Re-check the quota and exit if and only if the vCPU still exceeds its
> 	 * quota.  If userspace increases (or disables entirely) the quota, then
> 	 * no exit is required as KVM is still honoring its ABI, e.g. userspace
> 	 * won't even be aware that KVM temporarily detected an exhausted quota.
> 	 */
> 	return run->dirty_quota_exit.count >= run->dirty_quota_exit.quota;
> }
> #endif
> 
> And then arch usage is simply something like:
> 
> 		if (kvm_check_dirty_quota_request(vcpu)) {
> 			r = 0;
> 			goto out;
> 		}
If we are not even checking for request KVM_REQ_DIRTY_QUOTA_EXIT, what's 
the use of kvm_make_request in patch 1?
