Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84C394974D4
	for <lists+kvm@lfdr.de>; Sun, 23 Jan 2022 19:59:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234815AbiAWS7L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 Jan 2022 13:59:11 -0500
Received: from mx0b-002c1b01.pphosted.com ([148.163.155.12]:33100 "EHLO
        mx0b-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234780AbiAWS7K (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 23 Jan 2022 13:59:10 -0500
Received: from pps.filterd (m0127842.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20NCVOZm022515;
        Sun, 23 Jan 2022 10:59:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=message-id : date :
 from : subject : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=j6qNnu5AWID1aKr63sdHXdFoBNN5dX/9eSHCLFlJs5c=;
 b=OHEjsp1Z6qB+FvlhvYJarecVB/yYSVkOl0w/9CnISuuvWkfoqApMALXydNdRihg2b09T
 AHl8eAYlN1JGHyYvwIlsbrXklQkYe9IxzipTAckqoxt1GLJBDKRMWJ/kZVZXmM2Q0gWh
 dZ0rvJzee3DImQ/IBYqiKJP+ToKX/51k/Gif5m+tqh2h6gZto82VSrnR19PMBAQy5scD
 8lVlEn/Z8NFwK3XfDrVld33n9qhfZPdImpSzFBkrQCE9tRbVIPLp66FO5HcgbTJ0vjxH
 ytCHq7jSv+TcUrZp5cAJfwMODLl7UXbsPWCVCRyNdjE0yBVDl3CrDtnnYaGCeme0WREZ gw== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3drj4k9r29-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 23 Jan 2022 10:59:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jYuoJc2Z/DPq2F2e0y8Q9T1g2Bf2Sp2shL79JSekmdcFEmHpNwjGiZVbF5pGK11cpK1M0SD5t4bjX+CqLwJwy89MHNBoCtkJ/EIL4D4Ho3cmT0+BfVOjgndlz2zsc7uXAy4wHxzUiU504q0SIbnZn4qsn0J3O6r7KulhIhuuhLgVUJBvKlcoYeFQSnXGUnjrxcTsRTXggSxwpM2aDF4xnb74WsUzPvfIfZocQbTRGmSkocpLgN7hMHy7AZxPLVCa0wxLYDQnWrv8bGr1OsrDAuLBnjtXSQdpfYk64hwdmBSWNCOKew6bUF5VuuvpLSb52c/VgCRol4H4SX2dY5bETg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j6qNnu5AWID1aKr63sdHXdFoBNN5dX/9eSHCLFlJs5c=;
 b=iBtt6ox6MtNv6QWvHc26pm84szXG28+MqJY9QARvJ22y/IOQLcZLu1vqeUUoYEzLLtrYzMbqw0UFdTda3WKQKCoinVYhZVleZzV0243HMacbLSTL+MmI9VJo/wxq59lFwXyt7upen2GPPjYXVb7TGpUExZ6h0n7RSJL4tXfEb80odzOahEvX9Mn3Iux/2uCkcPHHQIadSkVeJV9WYm8u7W2cLMQc4k+vBs2m3hOy9ctZHYcRlEgxttKciE6g97LFdwAHm4RWqyL3xOm5MOxFzBOybVclSb8bYc4r7Kuzrs5Fd+m0oKSKkpJq6nfuZ/EytC9OV7Ueww3A9b4KpcSnhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by SJ0PR02MB7807.namprd02.prod.outlook.com (2603:10b6:a03:325::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.8; Sun, 23 Jan
 2022 18:59:01 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::9419:ac11:8987:54e]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::9419:ac11:8987:54e%8]) with mapi id 15.20.4909.017; Sun, 23 Jan 2022
 18:59:01 +0000
Message-ID: <d610ce6d-3753-405b-80c7-b6c5f261fce2@nutanix.com>
Date:   Mon, 24 Jan 2022 00:28:49 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
Subject: Re: [PATCH v2 1/1] KVM: Implement dirty quota-based throttling of
 vcpus
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org, agraf@csgraf.de,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
References: <20211220055722.204341-1-shivam.kumar1@nutanix.com>
 <20211220055722.204341-2-shivam.kumar1@nutanix.com>
 <Ydx2EW6U3fpJoJF0@google.com>
In-Reply-To: <Ydx2EW6U3fpJoJF0@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA1PR01CA0180.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:d::18) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6c55518a-36f0-4d1a-08d8-08d9dea26aa8
X-MS-TrafficTypeDiagnostic: SJ0PR02MB7807:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR02MB7807BA40E7ED48EA728F1223B35D9@SJ0PR02MB7807.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 82YcmJmLIV5nPmMORyDni3L+SBM6RIAUv5ZVT1mI4WPhj/OJDc4ZoXut33Rwff46hIX6wmmdmHZX/SkUYEJiZGHxOq3rhik2m5Aa98lfYgoViPE0i7Nm2r2lBQ3UYPyRIqtxYS16xTk21myrl4KHaDMX8eA3mQcv7++vJScT1EdVz5Qodcp/ydjsZ7YdfakecZ9p9+lTD2xSXAFHXfK/jw9LCd9gtxSxgsIPfqRlfj4I/gZZnNoUXP06QiqvvloZzOJHpezDV4CI0CteLtfdN/6/gs711S160nLv6Fwt8c61d+B22PotvX6ZPaNxVsCJmPY5fOHw2adJBMr4/o1ILYGaSIC/7OQMtgiK1SNzqQ5vQuKXHYzjog3MqxLYsi4nP7gbZaHrlh8xlmqw06v7keEqs1i6oLZkVjhp6U4PAi7on2N8re78BnWETqY/BZZGGQG9rQsDaa0NQBEtQoS69Lm7NikYdE+36SDUOjBwhIpfZOyGlmPtbxxkzjo3GDNYemouYbRtbasdGPm2M/XG19pqUoCK4oQafZkWaPgvqtJQvEwGycGrELhFfZO0b84MJQh+MjS6thS05FpRcm24iUmYI1hasO3bUL5DHP87VvUccLqQQB33XnyLDYvwC6ez7CXaxCl4kStpfhb6tIAXhPZrUneYo8QvPiARjaafcbqh9R3ueGxT4SrHqEfllaBAaQeS1sNH8xgOagKwn7+JiDdZc1LHoBe4/vFEYXuXE998anESUH1BlI+ISPDl+i4sGJQNYDZKi8jcVT0jD86ml7wIbTQMDgR7WfB/BVZgDBA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(316002)(2616005)(107886003)(66946007)(55236004)(66476007)(6916009)(6506007)(53546011)(186003)(86362001)(66556008)(5660300002)(4326008)(38100700002)(31696002)(508600001)(6512007)(8936002)(26005)(6486002)(15650500001)(2906002)(54906003)(31686004)(83380400001)(6666004)(36756003)(8676002)(590914001)(14143004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c1FIdENGUlpyU2xuRmVDUWdSMHJmYmI4akwzTzJPdUk1eVdEZ3RROGJoemNk?=
 =?utf-8?B?MnRKQ0JyWGt6SkhiMEtzSk14aURCZ3BsM3U0YmFHN2dEQnFrSjVjTVZ0V1Bn?=
 =?utf-8?B?dTd6NERXTnlaWmFkaHE1dXNnTy9kMXdUSExUODBnelNyQTBFU0NqMis0SkdL?=
 =?utf-8?B?cGdyUDBHRjJOcmsvS29XLzJhQmwybDZYeTBFOFZ4THVlSGxuUG9lb29lU1Rs?=
 =?utf-8?B?N0hNMXpmVC9uem9RRWNxQmNabDZFc3hvMTQvZXc2ZVk3M2JBZ0tVbFl5NEpZ?=
 =?utf-8?B?Q1VGNHoyQlNWZ0dtODhzTHF0eVRmbUlwV3ljeEtUamtYWkdpNENjQTgvVXQ3?=
 =?utf-8?B?c0JNTUF4ZWQ1YlMyb0VrUGp4Tk5iUG9DdURMenhpelJrdGxScmRkUFZTWEtq?=
 =?utf-8?B?cDBneWZ1VHFUcmJ0N0gvMHF1b3VpY2NlR3RXL3hvK3gzc3hicjlVdTZ1b2pr?=
 =?utf-8?B?emVtdVlkdlh2Q2VtbkdYQ1h1cUxUcDhpdUNjb2l0NXIrUFdxZ3UwTFAvWVZC?=
 =?utf-8?B?cTVIZnRkaXdzN05YU2RnN0gvWXgwOGg1UkVYcmFaODRHSC9OYWV0ZFk2YnB1?=
 =?utf-8?B?czU4c1I1K3VWbWpRNC9JU0g4ZHN1WEx4dnFYWWlzL1RvSU93eWw2dzQ3blR3?=
 =?utf-8?B?d3RXZUNRdmx4ZWRMVFF0ZVQ1aHV6RmxqQW9qcjRQV2VXckxDd0dqeXdjMi9O?=
 =?utf-8?B?amFIQXpqRGprVEkzV2lVK2l5Z3BFUVdTbXl6bzA2RXZGaG1QZ0REV3hodVRw?=
 =?utf-8?B?Z04xK01zdm90cEVZNjdyS1ZtaHVURnpvWWdNYSs1SFFzUS9DcExNa1EybllL?=
 =?utf-8?B?aEd1TW56WVE0LzNLNHhyUlJqNS9WMUdGcGcvam9DRmN2OXhxaUozL2l0SFFN?=
 =?utf-8?B?Y29PSDF2SUd1dGZ2NGl1UzRQbXBiTlVLWUEvTVE4ZG9EMzN3NDJLaWZVYnY3?=
 =?utf-8?B?eW9XTWJLWmRyRVlNVjFveHRVV1lNNnM0bk9mNEZFU3NoS1FHRWFtSGwwbjU5?=
 =?utf-8?B?ZUNrSlJrWUs2L05rSFNTYlN1ZktaRTJhMVlSeDN5Y1h2amswOER2ZmxtdU9m?=
 =?utf-8?B?TXZkZ3o5UUhSM3REVzF4cWNNVTJBLzFQRTlONHBobkVrSEZDZVZoSFJTZm9o?=
 =?utf-8?B?VGl4RjRsaDYyVlZvTW43TVAxYW8zcEFKUlI3MnJGckJSaTI2NG1Oa2REaDNQ?=
 =?utf-8?B?ZTFjaTlyMHVQamJRU3FHbS9STktOcmtCdUVhLzFBbFZFNHZBbjNuZUZxQmkx?=
 =?utf-8?B?alB5anNLU3BySGlXNDhqTm8zU1Q1ZGJpdTV1aUtQNjNUbVJzM1hMbVlyQ0tJ?=
 =?utf-8?B?aVNrOXAwYlNxZFQ2NUx5UC9EdjU2VlhhM1htL1BrQzg1VDNUczNCWXlOazU5?=
 =?utf-8?B?VHhPMTZVci9nWFRCekpCUHhWSUdJWVNCWlYzYVFQVHkzdUtrdjNkS2M1SUNu?=
 =?utf-8?B?THlIcjI4dUR2RER3d0ZtOSs3SVY2ZXdVYm04RzEzaTBmY0hZNDdTK2RObm8y?=
 =?utf-8?B?SnhoVkJiK05KdTR1UDg4UnhNRERCb0tac01xWGxkVlE2ZVBpcFRCZlpHZkpI?=
 =?utf-8?B?cW1GZEVvcC9ZUE1nUGNFWW9BVis1NXZqMDZDZ1ZGbHNrMlBabWFJeGxlUzNn?=
 =?utf-8?B?SjN6N3FYb2pvdll5TGVBaXk0N1RJTFFIYkV4Wkh3MVRHQ3NGOUY0aWsrdExU?=
 =?utf-8?B?VlMwdFJWWUtnVUozK2ZjYkNnQkd5ajVMa25VZjJqdDRGN1hLWXV4ZEZSd3hH?=
 =?utf-8?B?ZVRTTlpCdm04NHk4MGxvbFlQS1NOczFoL3pmWFRJSXp2THE0WHgza3FVeFFy?=
 =?utf-8?B?aXM0TE9BOGxMUXJhN3RzRExrQnczU1YwSmYwNG9qcjNlTmNTVDVtV2l1bnU3?=
 =?utf-8?B?eDhjSlpBaStEczJMbExCYzdBUTk4TUk4eHZmNDdpSGU4Yk5YbGFXdlBWQ1JI?=
 =?utf-8?B?U1ZaRjdMU0NNVzFCZEsyRHhwN0dFb1dtbDlFS3dSeU1VSnI2b3hVRERjRmo1?=
 =?utf-8?B?STVQVmhvcWc2Y0RUTlNPeEN4WkMxenJqciszMEZIUklHQjhhUDlKL1ExY2dm?=
 =?utf-8?B?eUlERkhiZ3h3SEtGbFlvbXBKV1JPSU45YlZrOUE5MUNNT05VU2pDVmU4cHFF?=
 =?utf-8?B?TU1sclcwaWYzNHhPRFFaN3RseC9BcmZFS3RCaFVLN0YzMElTZ2pPVGw5a2R6?=
 =?utf-8?B?ZzZ5VEF3Q0FyTUcrbEVEaDRFbDFKcFhsTlo5UFp5T1pCZWhQT1RRU0NRWUQr?=
 =?utf-8?Q?zMxEH1+++yUE1k+X/8Gcm/D6SE6n3EXjracNCYS8jQ=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c55518a-36f0-4d1a-08d8-08d9dea26aa8
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2022 18:59:00.9006
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iSY/hYmIZsdJJLlkKsORdBDWuGCSJZPseliYEKeMvTtwPytsYWPMZKWcyzcz5XNBFKNrLzx1ub/HfpP1fjUry57iyaHKSkg49EbcGpFbgx4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR02MB7807
X-Proofpoint-GUID: QZxrR5VPmL-RGpF_jIEfEpdcbHFBzlWM
X-Proofpoint-ORIG-GUID: QZxrR5VPmL-RGpF_jIEfEpdcbHFBzlWM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-23_05,2022-01-21_01,2021-12-02_01
X-Proofpoint-Spam-Reason: safe
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 10/01/22 11:38 pm, Sean Christopherson wrote:
> On Mon, Dec 20, 2021, Shivam Kumar wrote:
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 9a2972fdae82..723f24909314 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -10042,6 +10042,11 @@ static inline bool kvm_vcpu_running(struct kvm_vcpu *vcpu)
>>   		!vcpu->arch.apf.halted);
>>   }
>>   
>> +static inline bool is_dirty_quota_full(struct kvm_vcpu *vcpu)
>> +{
>> +	return (vcpu->stat.generic.dirty_count >= vcpu->run->dirty_quota);
>> +}
>> +
>>   static int vcpu_run(struct kvm_vcpu *vcpu)
>>   {
>>   	int r;
>> @@ -10079,6 +10084,18 @@ static int vcpu_run(struct kvm_vcpu *vcpu)
>>   				return r;
>>   			vcpu->srcu_idx = srcu_read_lock(&kvm->srcu);
>>   		}
>> +
>> +		/*
>> +		 * Exit to userspace when dirty quota is full (if dirty quota
>> +		 * throttling is enabled, i.e. dirty quota is non-zero).
>> +		 */
>> +		if (vcpu->run->dirty_quota > 0 && is_dirty_quota_full(vcpu)) {
> Kernel style is to omit the "> 0" when checking for non-zero.  It matters here
> because the "> 0" suggests dirty_quota can be negative, which it can't.
>
> To allow userspace to modify dirty_quota on the fly, run->dirty_quota should be
> READ_ONCE() with the result used for both the !0 and >= checks.  And then also
> capture the effective dirty_quota in the exit union struct (free from a memory
> perspective because the exit union is padded to 256 bytes).   That way if userspace
> wants to modify the dirty_quota while the vCPU running it will get coherent data
> even though the behavior is somewhat non-deterministic.
>
> And then to simplify the code and also make this logic reusable for other
> architectures, move it all into the helper and put the helper in kvm_host.h.
>
> For other architectures, unless the arch maintainers explicitly don't want to
> support this, I would prefer we enable at least arm64 right away to prevent this
> from becoming a de facto x86-only feature.  s390 also appears to be easy to support.
> I almost suggested moving the check to generic code, but then I looked at MIPS
> and PPC and lost all hope :-/
>
>> +			vcpu->run->exit_reason = KVM_EXIT_DIRTY_QUOTA_FULL;
>>
>>
>> --
>>
I am not able to test this on arm64 and s390 as I don't have access to 
arm64 and s390 hardware. Looking forward to your suggestions. Thank you!
