Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2A153B7426
	for <lists+kvm@lfdr.de>; Tue, 29 Jun 2021 16:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234367AbhF2OUN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Jun 2021 10:20:13 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:29970 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234352AbhF2OUM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 29 Jun 2021 10:20:12 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15TEC68e016064;
        Tue, 29 Jun 2021 14:17:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=dj/n0HVm0ky0mz4LCuRbjEMbW6TVBTd3rSIMpQ4XRXQ=;
 b=Ex4dMcTtyk7p/adRs7+pFn5IJDcOU1xn0bSCrxZPuEUG4FM4vWkb8E5GgHbT+P4/TeTP
 i1FCV+CF0u/Qw3hK2seIHKOgRjv7HrPHDI38DVpAZNLZXloBVFo9USXYWV5KLsjFipcD
 8tueI1dbkepr6ufPdFncZ7RSCCuZPar5D7x4gOnS90VSVRT+wisAjoXUG+lJsbPSaF+/
 kwc29AIkbJmlTcePHiRUc3BdzKynpZENdb8d1+t+SpGi9ooJyyOPEjr/GbREV9c5B73e
 GuQaE0OPbaLXS8bB7/PvhjNL9aB4uB4I+zboyQlzppdnmdXIS3ZB0PJrRjCF8v/ES2mD HA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 39f6pqbqs6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Jun 2021 14:17:37 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15TEBfX5136939;
        Tue, 29 Jun 2021 14:17:35 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by userp3030.oracle.com with ESMTP id 39dsbxxytn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Jun 2021 14:17:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MvyVC7v/WI6ahpW//IJ6mQ4iP6LslSs3Kn1Z4cJisKF+AxbLvlpcBxjD+KYvL+DIZB9zhAVSYe0lcqEjYPElM7KkCxHM4Z0UPNLxOUqtEHi129dvHkHo8vylEgcwi43C1LeKba8aN7eLngirvjnEPigvoF6sTyt8L1Fncz4MLd3jjlE1GpU2NXkRWoIoXqZxT/bX3ZRrqMLWomTiGNkgBbhEipLmdweLw9X9jmqXSkljw2LzAR0WaPGa/BPh8nJTkV7XxAQ8ewCqsXTNaxeVJ9yLFwEwzXrRox/PxFCR1VVK/sAK+OI++DQyC0ZDcSyhF16bySSCczvqoS1cet6Fzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dj/n0HVm0ky0mz4LCuRbjEMbW6TVBTd3rSIMpQ4XRXQ=;
 b=H7n2CRApkSBVEJrMHF1g3C7+p0iVz4uO9yLWEr+zALLAawFl+5SucEeuwJG5xF+65dk6LI8ingn2G37bHBSMwHGCoGdds+u6iiNJaFiMWOnqfAR6tvWyaYyHMUSo+ydflWejd/psGHhzjpvZReaSbTV4pdKlPV0qe27Tm4OQ+OWQ2l7d3GCgeSXErmGgkiNpiSJDMCwpvn5ftwOfxZETpZrkAKI2kNAyzeBt5RaQGnSMD5nf/kPYqnFGjl8mwFedLSrRxhcpDAxj+/2Iw/sHHRRXqUJfJzuenALJtr9Qp2bOshVeZP7WGfIqIK7tQxg7sF1LWsrjzR5Z5kaLzwU0Wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dj/n0HVm0ky0mz4LCuRbjEMbW6TVBTd3rSIMpQ4XRXQ=;
 b=eTVge7WGamAHuDYpAhaidSoqk+hWJA7+HAdqRQiDt6f26La0i8SDoDzAUR7eQEIoZ/Sjc5S73Mmpk/HV5uDupzH5qEppG0P1DHu6j+AHJdv12AlTMc8/v6gB8pMr63R3m8+txXm0KcYzoPaMpWJMDjxSrZhrqlx+80yUQoU0S/I=
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=oracle.com;
Received: from CH2PR10MB4391.namprd10.prod.outlook.com (2603:10b6:610:7d::11)
 by CH0PR10MB5177.namprd10.prod.outlook.com (2603:10b6:610:df::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.20; Tue, 29 Jun
 2021 14:17:33 +0000
Received: from CH2PR10MB4391.namprd10.prod.outlook.com
 ([fe80::9490:e23f:3d15:9cd6]) by CH2PR10MB4391.namprd10.prod.outlook.com
 ([fe80::9490:e23f:3d15:9cd6%9]) with mapi id 15.20.4264.027; Tue, 29 Jun 2021
 14:17:33 +0000
Subject: Re: [PATCH] KVM: arm64: Disabling disabled PMU counters wastes a lot
 of time
To:     Marc Zyngier <maz@kernel.org>
Cc:     will@kernel.org, catalin.marinas@arm.com, alexandru.elisei@arm.com,
        james.morse@arm.com, suzuki.poulose@arm.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, konrad.wilk@oracle.com,
        alexandre.chartre@oracle.com
References: <20210628161925.401343-1-alexandre.chartre@oracle.com>
 <878s2tavks.wl-maz@kernel.org>
 <e3843c2c-e20a-ef58-c795-1ba8f1d91ff6@oracle.com>
 <877dicbx61.wl-maz@kernel.org>
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
Message-ID: <abcbd6db-da75-a6ad-01f3-7c614172ebd4@oracle.com>
Date:   Tue, 29 Jun 2021 16:17:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
In-Reply-To: <877dicbx61.wl-maz@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2.7.202.103]
X-ClientProxiedBy: LO2P265CA0412.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a0::16) To CH2PR10MB4391.namprd10.prod.outlook.com
 (2603:10b6:610:7d::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (2.7.202.103) by LO2P265CA0412.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:a0::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.21 via Frontend Transport; Tue, 29 Jun 2021 14:17:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4cd9fc28-75e5-4497-ee7f-08d93b08a30e
X-MS-TrafficTypeDiagnostic: CH0PR10MB5177:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CH0PR10MB5177ECE16D4B08378ED412459A029@CH0PR10MB5177.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qM4mKfzc2nk5YFVE2jLNL8Ksj58T/8RE5HkbgnOjaM0AyhtyPCWYzqcfRD+ZDur+tTyvXvhaVG4Pg0m2xabWpS3GFsQmPcDMQB+yyVI7hcE60xGkfXEkQEluA9IGZLvv3ObH7gjogvQxN+lm4H8pcQhOphd8+OW2DPvpSPtD2g3ksxJK8A/+4EFODF2RAK4t/VABvUwUu3Jv+fpHXove+UvRV4ciuXpPVqZtCGoFWXMda6I8qbP3zc3xO6xUvrPW8QPzqD2inUxfKl8P1VHpHbLGualSI7CdFyPXgxbKQsDf9fF5PVHMab6u4presSiNqA16VO5B9FYnxuUI7RddZaKgu/QCc8KI8J5qOiO6hbaplBYnI2ciVqDivzkySTg+SSS01JnUPDuun3px8ce7kULv4Cw/eYD4kAITS8BXyYccRToZqcOsF9VfBKQWdoawYAP5anWZ7bfLBUeE9bAii0CERTvOh29cXyZTJL0vxmafcv6KG1L9NDu6YyFiWr2UlCEKpLouDx4Yl00WFQqCiNIzxbRrgUmvk6i1yvLFGeYkRxpURO7JBv7JYZfAK4uqLFVfhujvo4ZhJVBVA7eIb8pc8Wxf/7LvEz9ZWikto3Q01qIkYa4YNr/BtCIE765wvAImAQ/4FBjVetrDOEX60O476kw3lmx3bQBZz/jHGE6WjRc9z3AaphO9gQAofQuzFTFbJLx2zUFJal2DWlGU9zbvGaY1hnK4cFYKsC8wvmY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4391.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(396003)(346002)(136003)(366004)(16526019)(186003)(6486002)(8676002)(83380400001)(86362001)(5660300002)(6512007)(31686004)(36756003)(2616005)(31696002)(44832011)(53546011)(6506007)(6916009)(66556008)(66476007)(26005)(66946007)(38100700002)(316002)(6666004)(478600001)(4326008)(2906002)(107886003)(956004)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Ry9xNFBMY3ZPZWtXN1cyQmxONkxrckxyY29sVk0vd2NvV3hNVVhFSDJmS2Nq?=
 =?utf-8?B?SWttQWJnUUEzT28wNzhNbW8wcXB0WW5JdC96UE42TXFWVjkvT21rS3BzT3dG?=
 =?utf-8?B?YnVmL2hKQTl2dW8wNmh1dXVWMVNiQU44Wkwra2sralJGQS9YTjlwTXNaNzVy?=
 =?utf-8?B?UUtKdkFPdmFaME41ZUMwdFFoZC9RTVpCWVNVQWhMUmlFNUpLZVFDeUJSRUI5?=
 =?utf-8?B?bHFhVzJMOXlLamc4L3RCbWp6eW5MZ3RKK3g0YWpCZFk2SVZyd29RTXlSK08r?=
 =?utf-8?B?b3gvamZMM3lRMFVNOW9TcERJUHJqcW1YMXBNY01DMVk5bE5NbUpIL3pPYyt2?=
 =?utf-8?B?bzgzbE44RkNncUljdnMyTDdod3NLMnVCb3NIc1g5YllrRFRxbkJSU2o0MVR4?=
 =?utf-8?B?SjlwcyttWEVqblEwdlovSUlSTTE5VFlUaXdDQ2g5YzNPbWoySFRhOEI3VUNJ?=
 =?utf-8?B?QzVFVzFLU2FIUXQwRlUvZXJzYzEyNURZbjN6RzhwZkFoTmVPcW5XdXRXNCsz?=
 =?utf-8?B?N01aY2pSWHE5enp0Vm9jRVhKMkZKQlAzbFlYVmZZdnd5aENDSllSMVhQeVEy?=
 =?utf-8?B?MkRBNjk5NnRXSU02M25VSWlIaVVYdzhiNU5nMVYwZHBCL3RhZ3p3UnNvUm40?=
 =?utf-8?B?d3cwR0dNOTdMazBqUGY0YWVrRGdXa3NsRUxHK3g3U3pnNHJxSktWeVpDU3Fj?=
 =?utf-8?B?eDBCMUh0SHR2NHFaWjkxeUN0UElJTnhWa3pJeHZSSDJram5GUVpoYm1kYnVJ?=
 =?utf-8?B?UDlCRlZOT3hrajhHZ2M5YTY0UTdXQUNNNmFQKzg2bE8wM1NnT280bnlOVitO?=
 =?utf-8?B?QzNQbXZ5eFliSHNhYmk2Z0oxcXlkOEJEbnlpOHJJOHkvL09CWFJoQkpPbVBR?=
 =?utf-8?B?Y0UwWlh6UzFVT2U5UmNFTnlyY1laV0JmQXZzTDM3UlZtS0dIUE9pSmZHOG9X?=
 =?utf-8?B?TWE0YmtJRldxVzVyb0hHcW9IbkhLWkZUYzJaN1dtN3Z6NXpubERLTGN5eGFy?=
 =?utf-8?B?dzFTdlNEMlI3RDJ0YjlsRVBlcEhLbkQ5cTdOWjFQT040SVZMbHVkeVVRUGth?=
 =?utf-8?B?R1F6VWxHandlRkxucG5Td2JvUG9KcHFXVCtjcTV6dDI5d1dqWFhRbWlwakJm?=
 =?utf-8?B?MFdrd0JRRm5yakk2dVhrREllZTMwc0xqcE5uaUxkUlJLRS9yYVB3UWVsVWNW?=
 =?utf-8?B?QW5pRkpwY2hKUmpwUnJZNUxZczdjUFFQaVhSZVhLblRnUldwdVBtQ2xOUUNV?=
 =?utf-8?B?TGd6aWFTM0RHT0IzUUI5UzJxNjFpN3NQMUxLMWxzRnprZHYyd1puenhJQWg1?=
 =?utf-8?B?NGw4ZzI0MXBsOG1PQmtaM0VvOFZNNUxERnIyMmdjVXBxRGlXbk1GeGFBSVVP?=
 =?utf-8?B?dlJVY0FIbDRJMGhuT1RReUNibHNsOU8xaWdHMU9aMVFET2tVNTczUVhNNnhD?=
 =?utf-8?B?SEVZOWFhdE5TRTY0WEY4RmVja2VIUGNsbkhtWVlhbWdLTG8rODR1Um9ScTBa?=
 =?utf-8?B?QzRMSm15YW94dU1EUTFuKzlJSENGdko5K1M3c1cvWXFvN0ZzRXNEOFN5ZG9M?=
 =?utf-8?B?aTJaNnZQajRoOG10MlByempITXFKM1NMUnFLTm5iK3dlRlBIbmYyaDhrdksv?=
 =?utf-8?B?ekFqaThMNUkxMTlPRFJOWlcrTGdpSTFuTGlVdW5nUldyZnlvbnYzTTNsOTRD?=
 =?utf-8?B?aXZobDcrSlRzdDljV3RXQmhFaDlMME5Ec0JZY2hCU0JEMkdHYzFrV3ZUTGFB?=
 =?utf-8?Q?nWBLVubJnXSe3ogJUjXW1Y9vu3pYwyv4LTVdFAU?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cd9fc28-75e5-4497-ee7f-08d93b08a30e
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4391.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2021 14:17:33.2282
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jCpizpbFod5ElzWD24tPpvApIjjEOzcoQXlTZDpdVPs+pMGXyOZufQbgeCOZ18MzW6FtVZjps5jyMaq5FSMwbHdsT+5Iy13PInvGc8HQuIM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5177
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10029 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 bulkscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106290096
X-Proofpoint-GUID: RwmgjoAFvyDRbC-LhsYZRu40CziKljsC
X-Proofpoint-ORIG-GUID: RwmgjoAFvyDRbC-LhsYZRu40CziKljsC
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/29/21 3:47 PM, Marc Zyngier wrote:
> On Tue, 29 Jun 2021 14:16:55 +0100,
> Alexandre Chartre <alexandre.chartre@oracle.com> wrote:
>>
>>
>> Hi Marc,
>>
>> On 6/29/21 11:06 AM, Marc Zyngier wrote:
>>> Hi Alexandre,
> 
> [...]
> 
>>> So the sysreg is the only thing we should consider, and I think we
>>> should drop the useless masking. There is at least another instance of
>>> this in the PMU code (kvm_pmu_overflow_status()), and apart from
>>> kvm_pmu_vcpu_reset(), only the sysreg accessors should care about the
>>> masking to sanitise accesses.
>>>
>>> What do you think?
>>>
>>
>> I think you are right. PMCNTENSET_EL0 is already masked with
>> kvm_pmu_valid_counter_mask() so there's effectively no need to mask
>> it again when we use it. I will send an additional patch (on top of
>> this one) to remove useless masking. Basically, changes would be:
>>
>> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
>> index bab4b735a0cf..e0dfd7ce4ba0 100644
>> --- a/arch/arm64/kvm/pmu-emul.c
>> +++ b/arch/arm64/kvm/pmu-emul.c
>> @@ -373,7 +373,6 @@ static u64 kvm_pmu_overflow_status(struct kvm_vcpu *vcpu)
>>                  reg = __vcpu_sys_reg(vcpu, PMOVSSET_EL0);
>>                  reg &= __vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
>>                  reg &= __vcpu_sys_reg(vcpu, PMINTENSET_EL1);
>> -               reg &= kvm_pmu_valid_counter_mask(vcpu);
>>          }
>>           return reg;
>> @@ -564,21 +563,22 @@ void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val)
>>    */
>>   void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
>>   {
>> -       unsigned long mask = kvm_pmu_valid_counter_mask(vcpu);
>> +       unsigned long mask;
>>          int i;
>>           if (val & ARMV8_PMU_PMCR_E) {
>>                  kvm_pmu_enable_counter_mask(vcpu,
>> -                      __vcpu_sys_reg(vcpu, PMCNTENSET_EL0) & mask);
>> +                      __vcpu_sys_reg(vcpu, PMCNTENSET_EL0));
>>          } else {
>>                  kvm_pmu_disable_counter_mask(vcpu,
>> -                      __vcpu_sys_reg(vcpu, PMCNTENSET_EL0) & mask);
>> +                      __vcpu_sys_reg(vcpu, PMCNTENSET_EL0));
>>          }
>>           if (val & ARMV8_PMU_PMCR_C)
>>                  kvm_pmu_set_counter_value(vcpu, ARMV8_PMU_CYCLE_IDX, 0);
>>           if (val & ARMV8_PMU_PMCR_P) {
>> +               mask = kvm_pmu_valid_counter_mask(vcpu);
> 
> Careful here, this clashes with a fix from Alexandru that is currently
> in -next (PMCR_EL0.P shouldn't reset the cycle counter) and aimed at
> 5.14. And whilst you're at it, consider moving the 'mask' declaration
> here too.
> 
>>                  for_each_set_bit(i, &mask, 32)
>>                          kvm_pmu_set_counter_value(vcpu, i, 0);
>>          }
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index 1a7968ad078c..2e406905760e 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
>> @@ -845,7 +845,7 @@ static bool access_pmcnten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>>                          kvm_pmu_disable_counter_mask(vcpu, val);
>>                  }
>>          } else {
>> -               p->regval = __vcpu_sys_reg(vcpu, PMCNTENSET_EL0) & mask;
>> +               p->regval = __vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
>>          }
>>           return true;
> 
> If you are cleaning up the read-side of sysregs, access_pminten() and
> access_pmovs() could have some of your attention too.
> 

Ok, so for now, I will just resubmit the initial patch with the commit
comment fixes. Then, look at all the mask cleanup on top of Alexandru
changes and prepare another patch.

alex.
