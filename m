Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4398348651
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 02:18:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbhCYBRm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 21:17:42 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45654 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239579AbhCYBRK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 21:17:10 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12P1GBnQ172855;
        Thu, 25 Mar 2021 01:16:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=KhCULEwl/dTT21xwu3O2cJFj40SBhVqZQ2OLIrQSM/c=;
 b=RrRBpsHsZqd8iEZByHnqjS1fq0AxHN76lFEsMrB0iVgD4J19J6+/51kgkR6O6befmmLV
 pN8llzTZGfWBKOF8J5k9QbVC6cGgzxZde0L9hRusxYjMwukm5KCP36Je9rmKS7cbtK7k
 qhcfD6BSwTX+OIl42+7UyWSkszOOqBs7avg5A5i/JsoSch/9zUqBdhpuyd8SReVxVGTf
 x7WUNfSC/MoFevevws5Zf93n1Qzn9xurQq/6rRD0RwiFh4Iytk4JJwyLlCq1tdYfZ3mB
 1fsvIGXwPT1Jo5gnFiVuIvYGGZCuQW/q3tHQW0i69eDwB4dvXZKMGiKFfuOctY/F4qGh Kw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 37d8frcq41-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Mar 2021 01:16:11 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12P1EUJO162429;
        Thu, 25 Mar 2021 01:16:10 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by aserp3020.oracle.com with ESMTP id 37dty19ns4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Mar 2021 01:16:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WL9QD5k9YJb/ac0ZP+gV9IJl49/nAM78A5nFeKwYgdt2vEsBa56ihwrM4UetYmAD2Hh2o8GQDmU5e7XME94hBpVBdCHqVav/qcMkd92EgyP1wUYRwAIAQKx9TdY5HagZnYXwzYOT7bzFjvG6EkYLbaGirEuIA27B0tMUSdUTTmN9FdAZXw7u0uBib+i8lr6fMR8c6TWYX6FvPj8VEB9Sntinv423eizElJNftAvW3q30+GFerBfdZalOVdBCwFla0pUHrmnbSxRa/WMaibAmZB5feoMbgFV/sXNa97tdc7rsmgYHXeFvLEOhhm1tzL3HDxdJ9Klb4KBMKWS88jcCyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KhCULEwl/dTT21xwu3O2cJFj40SBhVqZQ2OLIrQSM/c=;
 b=TwOOkK3pIfy7+5xiTJ4KjZtF+J6oYoHSNb1lEKYGb3xDlJEoaqgbdFu95czFwg7vB0FWH8C/hTLKdHSMmuFV/YxiXjmYVJVZHygONQCbZCVcW+cHMNEPFvTTyH8avtFRaN7QCh/skhs/co5qyd5yfPahD0yAE70l8VLMnQiMxmNVbaqo8EmYV4n2BZEmJdiNQaKJ2Fn1kHUd6Be4/NjX3G0n2BawdoV80gTDpqLvZMlc2cqKfl3oacPIxQizzSczyCSyZMFHjgnuHDvplQGR3zWnZ7hCHrT33H1p5FW9i8wpAHIpCIY3ONwnECXkMjuzgZJXivKPbfN3J7vRpqsg7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KhCULEwl/dTT21xwu3O2cJFj40SBhVqZQ2OLIrQSM/c=;
 b=Ur6FfNxXbciqGFjkUcSrnRB2BCZGjUzdcy7B/LdDf5FPDtwGNpGkgwhL3rTX/+ZSdA2cbfzXoZeh3THJdlbORTmp83yPEpmRF5G3MIGVP8ErSZuQsvzG+4ps58/SF/NJ7p+BnlF9IPNw15dUfiHaiy2Lv98OVuBbCkclNMIA7X0=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SA2PR10MB4793.namprd10.prod.outlook.com (2603:10b6:806:110::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Thu, 25 Mar
 2021 01:16:08 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7%7]) with mapi id 15.20.3955.025; Thu, 25 Mar 2021
 01:16:08 +0000
Subject: Re: [PATCH 2/5 v4] KVM: nSVM: Check addresses of MSR and IO
 permission maps
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
References: <20210324175006.75054-1-krish.sadhukhan@oracle.com>
 <20210324175006.75054-3-krish.sadhukhan@oracle.com>
 <YFuP3tNOLQfXAY1l@google.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <66e5e78f-f280-16b9-9c92-32db335dbbd6@oracle.com>
Date:   Wed, 24 Mar 2021 18:16:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <YFuP3tNOLQfXAY1l@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [2606:b400:8301:1010::16aa]
X-ClientProxiedBy: CH0PR03CA0025.namprd03.prod.outlook.com
 (2603:10b6:610:b0::30) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (2606:b400:8301:1010::16aa) by CH0PR03CA0025.namprd03.prod.outlook.com (2603:10b6:610:b0::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.26 via Frontend Transport; Thu, 25 Mar 2021 01:16:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b3ab46c6-598d-45f3-59e9-08d8ef2b91d9
X-MS-TrafficTypeDiagnostic: SA2PR10MB4793:
X-Microsoft-Antispam-PRVS: <SA2PR10MB4793B17B7BB5BDF809389ECD81629@SA2PR10MB4793.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fHbOLtIMwF9PlAFywohifKrml7JtDo/EetUduEg1N2TsidqxVae0fImZOpKrNps5ryhU5oK10hARn09ANuSbn8i0yNbhVMABDGGHELRbo/TnsWs4uvwEnuNDcflyOvUzZqjJvlDQrTucsrZKsbSelRo88rnYXSQnQTUeewte6gcwpn47u1Y9lca20IZ5Op8xxQaSVjHaGD+bqu+EbJxfuX1IzNHcBBGMu6FwPGRfHfUxuW65/Q4VMS6O8eqdPjo0UkOJOghnvqcuB0M2RdcHenTxsjeOwJBCjIli2h9TU6Hm5Tc2mgkdtWAQVLDpIeT9iffZrCQ5hstksJO7+p/+ZDV8wxb6A1nSDvsXhXLpDJxt3ThCii+NTUFjvYqW2JvX7JEP1/xa330uNe/qjDcK4L7izkMtnOpCBPXjlG7pWquaGmytmhp0cJHtKGSSlHKWQb8X1jy11GkVhjyt0KwvUAM8SfGwpuD86F00IBxIxi5TsL9FSoBAwnHQnwlb1PVwti2k3jPsOYEcD8FrdxJ9b89y/kEiBSEumIEgnBDNjJRfqLormf24tij2Q+XOOkoZYZSyrjAoYfCo8UgfZix0Pw8KrBpQeizJSaFCQb8IwfuwaWgQfAthJ3nzDmkBh0u+gYpjgoxwMzAmAw4pweh/s+IYk6+for+KT+xd2xhG2M/K/f2BQMiB9WST5qbUX9l6HPlh29X4nyUwdRE5arXxm/twLM1PC8UwMVpj0U8GHC+8LXLzOzChWDy9XJWAR04wMu7oOD9MfB/FWpJFFwiChDAOSvKWtOBr7dxxWrT6N7A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(376002)(346002)(366004)(39860400002)(31686004)(31696002)(5660300002)(83380400001)(2616005)(38100700001)(36756003)(66476007)(66946007)(86362001)(66556008)(478600001)(6512007)(16526019)(186003)(316002)(2906002)(8936002)(4326008)(8676002)(6916009)(966005)(6506007)(44832011)(6486002)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NEVkZnMyb29lV3gybzgwVE1EQ2NPL2w0MHJka3dZUUVWaThwTGtnVFdVcWtU?=
 =?utf-8?B?NDlnNDRKd0ZzMHFsemZzdldWMGMwYjRTV2laWXBLazlqbkxyZmhTa1VrRVNl?=
 =?utf-8?B?eDZzOUpwSEJLVyt4MjNwQ2IraEY1MjluUVdDK09oSmZNbkFHY3RRbDJPV3BJ?=
 =?utf-8?B?b2tLQytzSnlwcEY5ckROckY3aER5bWg0YjE0b0p1Y0xtQlV4YmNMK1lrSmlF?=
 =?utf-8?B?MWw0ZmhCekhsTkR2UHBOdjZsM3Y4RE4vdlhOU1FqZ0M1SkdCNUhHYUxYK3ZY?=
 =?utf-8?B?WGNpL0F4Wk1icGluUXhVanlnSmw0eURpdEhpWW9PL3M4TmNNUjRDUXZneXh1?=
 =?utf-8?B?ZWhBS3pqanhETzEvcjdxa3lXZFlaMzFBeVVndDlyYUgxN0FTY0duVmYxRkk3?=
 =?utf-8?B?MmI0WU81eEdGNlQwL0hSTUswcVNZeU5GbDhJeHdNb3VVSS95cHpvSHNLelB5?=
 =?utf-8?B?amlmamRzWm5wU1g2MDRQUVF6eklicUttd0w0WEMyc3g1QTNmaTllcU1JT3Za?=
 =?utf-8?B?UWRBdHJpQ0xueitSS1dPbXNxLzBaTHZqc0tIMkgxSEZIbEdDeWRpZXgvZ1Zu?=
 =?utf-8?B?dDBrR1pPRkx4cFgyYjliU09JSmw3N2E3cmFJdW5LSVRrTXFnQXlkSkppRU1u?=
 =?utf-8?B?ZGRHN1lJeVFQWXQyNlRqNEJjN29HdFNrdGVVaHdQazFCbUNBd0NHV2szdyty?=
 =?utf-8?B?MmhRZ2p4UU80NXJHR1NnUFN3UUFMa1RZalJIcExQVmUzYW4yRGpTd2Z1Q3p6?=
 =?utf-8?B?NmJpaTJqMmdNenlNY1dNVHdlU3dtODRObnVNTHBEZ1B2S0I0RVVYc3ZWSHVz?=
 =?utf-8?B?TGxvYjhRNklZbVNwYzNHejJZdytwNDVEUk9zMDlCVHBLelJ6L0JYUTMyZk50?=
 =?utf-8?B?NmhKTUplQjNpdXJLa09vZXNYL2dZMzJUWWNxNzV2SzliYVVVT3Q4Uko1WWM1?=
 =?utf-8?B?c3U2MkZzNTlVaVZXSk5Db3U4Q3k2RDRPN3dsbGtnOGQ2QkNDS1B4RHZlM0R0?=
 =?utf-8?B?cHQzRVZhRXAwZDQwc1h0aWFoa2prWjVrU09zZU5TM2RZMVdxNWdUOUljaDdm?=
 =?utf-8?B?R3dUUTdxczhpREM1cWpEYlRNVHBXcEEvclpXWk5EMUZIUzdTNGhveE0yUWM4?=
 =?utf-8?B?bHgyK1c5ckl2WlNCeXdEcTJvWldvS1ZLQVJlTGRmNUJqVThTOTByZVhVcWxZ?=
 =?utf-8?B?NXR3d0V6cXN0SnFGZzk0UE1zSm9WT0QvQjVDbWE1YzZoSFNOcDNFSmw1cGky?=
 =?utf-8?B?ZnMxeUNVYldmS2Z0SHF6MkxCd3NsbE95dXRoWWFwWFRqTnpTOU1ZSk1qZVdO?=
 =?utf-8?B?bHV6K3gvald3SWRCTmNvTnhwQmErNHU3VmFjZTJROG1SQVNVK2xzV0FNSHpu?=
 =?utf-8?B?MGQvNnNPL25tellwdmhqR3JsWkJkdG4wWlc1akp1Tm1aODIvV0FmVEdZRTU5?=
 =?utf-8?B?NkRDV2hqbmo5MEt6aW1mYU1jR3pwbTNrZXRNSlBmTDhoOTFNQm9ubUtPNkJ4?=
 =?utf-8?B?MkltOTdRbm9yWUhXdTMvWDRCV0tHTFJHNDdlTlJGcXVrTWlGYzNuRm9JWVFB?=
 =?utf-8?B?ZjBDRnJtY0pUTG1hMFhpYlA4WnJFOFN3WUhOUE1pc05zcGo2NXNQTUFhSjM0?=
 =?utf-8?B?T3BJSUpiaTJUTWlLZkg2anZucjZ4QUlTcjFvMGxqUTJnYUdLay9zczNoWGVk?=
 =?utf-8?B?dHl6Q2h0VnZHWVBQVXN1MTVhbVVCSkJqUWVvTWN2Z2liMnlWOTNHem1JQkpO?=
 =?utf-8?B?Q0EzNFdweUpSWW9seCtoczEyWVJka0I2MEpqSjFsdlpuRncrNTEvREViTGoy?=
 =?utf-8?B?QnQyNitoT1JBWTM2c1NWdz09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3ab46c6-598d-45f3-59e9-08d8ef2b91d9
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2021 01:16:08.4276
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i5Ra8GaGcZOe++ZcScUVwDlrYt//vT7/+zQ22n5ds3ksbUShwbx7HoVuWhJo5PInCSEpmsXsBNFYRyer/dE6dvn8EXKGIjsauAcnBGQf2fE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4793
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9933 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103250006
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9933 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 impostorscore=0 spamscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 adultscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103250006
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/24/21 12:15 PM, Sean Christopherson wrote:
> On Wed, Mar 24, 2021, Krish Sadhukhan wrote:
>> According to section "Canonicalization and Consistency Checks" in APM vol 2,
>> the following guest state is illegal:
>>
>>      "The MSR or IOIO intercept tables extend to a physical address that
>>       is greater than or equal to the maximum supported physical address."
>>
>> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
>> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
>> ---
>>   arch/x86/kvm/svm/nested.c | 28 +++++++++++++++++++++-------
>>   1 file changed, 21 insertions(+), 7 deletions(-)
>>
>> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
>> index 35891d9a1099..b08d1c595736 100644
>> --- a/arch/x86/kvm/svm/nested.c
>> +++ b/arch/x86/kvm/svm/nested.c
>> @@ -231,7 +231,15 @@ static bool svm_get_nested_state_pages(struct kvm_vcpu *vcpu)
>>   	return true;
>>   }
>>   
>> -static bool nested_vmcb_check_controls(struct vmcb_control_area *control)
>> +static bool nested_svm_check_bitmap_pa(struct kvm_vcpu *vcpu, u64 pa,
>> +				       u8 order)
>> +{
>> +	u64 last_pa = PAGE_ALIGN(pa) + (PAGE_SIZE << order) - 1;
> Ugh, I really wish things that "must" happen were actually enforced by hardware.
>
>    The MSRPM must be aligned on a 4KB boundary... The VMRUN instruction ignores
>    the lower 12 bits of the address specified in the VMCB.
>
> So, ignoring an unaligned @pa is correct, but that means
> nested_svm_exit_handled_msr() and nested_svm_intercept_ioio() are busted.


How about we call PAGE_ALIGN() on the addresses where they are allocated 
i.e., in svm_vcpu_alloc_msrpm() and in svm_hardware_setup() ? That way 
even if we are not checking for alignment here, we are still good.

>
>> +	return last_pa > pa && !(last_pa >> cpuid_maxphyaddr(vcpu));
> Please use kvm_vcpu_is_legal_gpa().
>
>> +}
>> +
>> +static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
>> +				       struct vmcb_control_area *control)
>>   {
>>   	if ((vmcb_is_intercept(control, INTERCEPT_VMRUN)) == 0)
>>   		return false;
>> @@ -243,12 +251,18 @@ static bool nested_vmcb_check_controls(struct vmcb_control_area *control)
>>   	    !npt_enabled)
>>   		return false;
>>   
>> +	if (!nested_svm_check_bitmap_pa(vcpu, control->msrpm_base_pa,
>> +	    MSRPM_ALLOC_ORDER))
>> +		return false;
>> +	if (!nested_svm_check_bitmap_pa(vcpu, control->iopm_base_pa,
>> +	    IOPM_ALLOC_ORDER))
> I strongly dislike using the alloc orders, relying on kernel behavior to
> represent architectural values it sketchy.  Case in point, IOPM_ALLOC_ORDER is a
> 16kb size, whereas the actual size of the IOPM is 12kb.


You're right, the IOPM check is wrong.

>   I also called this out
> in v1...
>
> https://urldefense.com/v3/__https://lkml.kernel.org/r/YAd9MBkpDjC1MY6E@google.com__;!!GqivPVa7Brio!PkV46MQtWW8toodVKSwtWy_wKBPlsT8ME0Y_NND8Xs05NJir6WSNS4ndmhVuqW9N3Jef$


OK, I will define the actual size.

BTW, can we can switch to alloc_pages_exact() instead of alloc_pages() 
for allocating the IOPM bitmap ? The IOPM stays allocated throughout the 
lifetime of the guest and hence it won't impact performance much.

>> +		return false;
>> +
>>   	return true;
>>   }
>>   
>> -static bool nested_vmcb_checks(struct vcpu_svm *svm, struct vmcb *vmcb12)
>> +static bool nested_vmcb_checks(struct kvm_vcpu *vcpu, struct vmcb *vmcb12)
>>   {
>> -	struct kvm_vcpu *vcpu = &svm->vcpu;
>>   	bool vmcb12_lma;
>>   
>>   	if ((vmcb12->save.efer & EFER_SVME) == 0)
>> @@ -268,10 +282,10 @@ static bool nested_vmcb_checks(struct vcpu_svm *svm, struct vmcb *vmcb12)
>>   		    kvm_vcpu_is_illegal_gpa(vcpu, vmcb12->save.cr3))
>>   			return false;
>>   	}
>> -	if (!kvm_is_valid_cr4(&svm->vcpu, vmcb12->save.cr4))
>> +	if (!kvm_is_valid_cr4(vcpu, vmcb12->save.cr4))
>>   		return false;
>>   
>> -	return nested_vmcb_check_controls(&vmcb12->control);
>> +	return nested_vmcb_check_controls(vcpu, &vmcb12->control);
>>   }
>>   
>>   static void load_nested_vmcb_control(struct vcpu_svm *svm,
>> @@ -515,7 +529,7 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
>>   	if (WARN_ON_ONCE(!svm->nested.initialized))
>>   		return -EINVAL;
>>   
>> -	if (!nested_vmcb_checks(svm, vmcb12)) {
>> +	if (!nested_vmcb_checks(&svm->vcpu, vmcb12)) {
> Please use @vcpu directly.


It's all cleaned up in patch# 3.

>    Looks like this needs a rebase, as the prototype for
> nested_svm_vmrun() is wrong relative to kvm/queue.
>
>>   		vmcb12->control.exit_code    = SVM_EXIT_ERR;
>>   		vmcb12->control.exit_code_hi = 0;
>>   		vmcb12->control.exit_info_1  = 0;
>> @@ -1191,7 +1205,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
>>   		goto out_free;
>>   
>>   	ret = -EINVAL;
>> -	if (!nested_vmcb_check_controls(ctl))
>> +	if (!nested_vmcb_check_controls(vcpu, ctl))
>>   		goto out_free;
>>   
>>   	/*
>> -- 
>> 2.27.0
>>
