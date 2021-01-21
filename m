Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA8F42FDE78
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 02:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728461AbhAUBBT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 20:01:19 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:49030 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727835AbhAUAhr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jan 2021 19:37:47 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10L0XXAp124588;
        Thu, 21 Jan 2021 00:36:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=l6qI+RJW0hP+VLiG8YI/2VbRAoTZhSKiMod+/ZWG//Q=;
 b=OYa9h5Jvspu6OMoP6QZwK73JbvVGnhPnm1R/I8bSWOyi94D6atfaYxrMEnJjjUpSUCsW
 C8mbSidkc9dRQpH18LS7xtG4MXUF84Hh/sRTxreb/+A3MMIze7UQfqYwGTQ8jFoCxmu6
 Cd23ZNzPgQSTqSgEuPWLCuLXbMCc/qGtVz9zY0NuBtZvomuXLR8G+axNnS1+KMfSPlls
 PvwXOExf9SEiXCFc7GBpp2BnNSp0HORkijZP5x9dR+NKanOKF8kSO6DQvEuUIOUU3egv
 uociV1SLn1+QwF1MuCEWqCH88L8+4B4DIJ2pG4AlnycwsV5cURII8H7kzk7oAjJdtbAS iw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 3668qad2j9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jan 2021 00:36:55 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10L0ZqMV173225;
        Thu, 21 Jan 2021 00:36:55 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2056.outbound.protection.outlook.com [104.47.36.56])
        by aserp3020.oracle.com with ESMTP id 3668rev2gp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jan 2021 00:36:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BBVajncG2rDABck/AU/LUMb+14PnVLmzjgT07v6fkqgUzPcsh/KM2yNI57qvXpFQfdpdjGdE44/w6dTCWiIJOL6/BVTFhjJguporkJzVid5s7TFeAtrWFPjBiu8B2BIPN6UjiLTDLbme9aW2bnJSG2SRWIf1h7YPJibhIdwTjKlguvB9crwGHIKkhTME9umxEpouCe1CcQMNcjjBTaj3AxscQqqd72jMDxVgmvwxYflM/nMsv97ayZAlEzAIQlBlo7ncrbTIklBniRraEsBgOLGQhQHAnyniebKwOquSm6150OdMCXqJAOTKpkSPmF8SNK9XL7gaeZUP06RTKol7fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l6qI+RJW0hP+VLiG8YI/2VbRAoTZhSKiMod+/ZWG//Q=;
 b=ho+av2QZT4IVQ3/CZWlhG3ji/IrlOuqoJ+hB+RlhXOU1chJVb9PfS+phIzsOMIBkpQKUxcjd9p8I90hImUfsCXA9zt7ou7AuDyturhqjTygmeoIYfeaEl5GqnFuVC5y4IbJ4qIT+aTf7VnFd9pTx+RxpRDiQ7tN1V800jmlKR9QWiP+yfkJANKTYRnmInGtZOV3QSnhpDSoiUZP9hVy/9YYWl47IRZV2jstYaSoMdR/M1gyvLrzzOyvoZ7a63aTDTK7u6ObRjS/XgiYeh3JssdQVdsx8KuS42FkIcJ1zJtA+rv9TaUwCstPmnQ4S37QpisfvMF2sTJ6QELZ8AJrPjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l6qI+RJW0hP+VLiG8YI/2VbRAoTZhSKiMod+/ZWG//Q=;
 b=cfgYpJKLal4Rykex4SZDmhmfmJhYFKIzOkDyFsPG7w3owTuGSpnKsoCXhVc2aeJ6QORZiX2eoQA4qg/pc3wJbek8IuqE7+Ezj4WwjyBXlPNPIaGN5YJRZGL4mfV8J4gvJh4Wqe7vNYow+D+51qw5myXPZ0Y7BxNXn+Am69kWiOw=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SN6PR10MB3088.namprd10.prod.outlook.com (2603:10b6:805:d3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11; Thu, 21 Jan
 2021 00:36:53 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f1cf:7b28:58cb:3620]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f1cf:7b28:58cb:3620%6]) with mapi id 15.20.3742.014; Thu, 21 Jan 2021
 00:36:53 +0000
Subject: Re: [PATCH 1/3 v2] nSVM: Check addresses of MSR and IO bitmap
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
References: <20210116022039.7316-1-krish.sadhukhan@oracle.com>
 <20210116022039.7316-2-krish.sadhukhan@oracle.com>
 <YAd9MBkpDjC1MY6E@google.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <1a48eb89-db02-da68-585f-07f1c5ca6d26@oracle.com>
Date:   Wed, 20 Jan 2021 16:36:49 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <YAd9MBkpDjC1MY6E@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [2606:b400:8301:1010::16aa]
X-ClientProxiedBy: DM5PR2001CA0021.namprd20.prod.outlook.com
 (2603:10b6:4:16::31) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (2606:b400:8301:1010::16aa) by DM5PR2001CA0021.namprd20.prod.outlook.com (2603:10b6:4:16::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9 via Frontend Transport; Thu, 21 Jan 2021 00:36:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9b2e2ada-d395-4249-73e4-08d8bda4a5ce
X-MS-TrafficTypeDiagnostic: SN6PR10MB3088:
X-Microsoft-Antispam-PRVS: <SN6PR10MB3088354EE8DCE381DFE8A92881A19@SN6PR10MB3088.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IkjeyeoLHAB/dO8d6ZdvPpKyoy0HlYSj4Vfi6uhU0VPN9ZJqZ9t88oF26Eq6xacEbGLwEbPBY6b13bCuSlIxBZVcCWru6LPFW5+ywnjzECr+8h9pAi3BzjTa8Twr9t2FhBkoFVigbEmjKba26cZ6HyHxG+gNu71a6jVXJtNFWQlKORzAmSKc2t3bcR5dwlRkoirHIjNGyl7T8+KRNiszj7hI4BuLjJ0jtVAOH5rok3lF3sKTwY2l0FbdTjzHkJFUYfMAqsFktWRi7T8o2f9D+zET6lQb2r+SdM9ZiZvTNHgeQTsA/tb4GXV/VmSHnEGLMTRsIbkxNCq1+36X9RYfpJXswq3HOKFPgIQSCdCBgzjXomr4da6xLNhGG0qSNH4+D6GWdR0ftiW+m4lIn/FBs5Mxpm83SN/Oc5ZJkIZLUTKFPvq/7o3SlylSBu7NsfDWwtQAH5eYwtXw7p4DN3DDDKXFaDttMD+f/Gp+iLvo88k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(346002)(39860400002)(136003)(376002)(66946007)(53546011)(2906002)(83380400001)(6486002)(8676002)(8936002)(66556008)(316002)(6506007)(66476007)(44832011)(31686004)(6916009)(2616005)(4326008)(6512007)(31696002)(86362001)(508600001)(186003)(36756003)(16526019)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UHhlS0x4MDIrbEFnR3FPWWl0V3BZVWFXdjZnb1ZUaHVxWlNUTnBoNk1KbjB3?=
 =?utf-8?B?YWhpK0FCQ2xiZjB5YWxtZnR1amx6eDQwRW9wbzNpYnh6WmhBSGFNQVBBa0ZM?=
 =?utf-8?B?MDUyZ2tZYjJCS2NpRWlSWnR1TDA5L0hFT1l6aW1YaTg0bkNPUmp0NER4NHRw?=
 =?utf-8?B?SzlIMnEzWGppa01lQjJxUCtXUkliZitBUHF1ajVIeUl6Y0JjdW12VGNFOWow?=
 =?utf-8?B?S09ESEY5eFhGYmlMNHNmenJ3SDNGUlVhcFV6OEEzNHRzV1Y5cjZrWVh0SXEz?=
 =?utf-8?B?ZG5HWlJzd2ZlSXJyWmJrMlJNY05ISTNnSldNd2Eyb3NORTRtcUZyRVB4VWRp?=
 =?utf-8?B?MytNMjFTLzkvcUN3QmZ6azBpT1FiUjlUcVFVb1ZVZXB2VUtEeEpVUlZZQStw?=
 =?utf-8?B?QnMreC92WVJzczR6eXNBSjQzdXAzNmdiTHh2SzFLMXBIc25INFh0L1dWR2FT?=
 =?utf-8?B?bERVUWl2Nkp6UzdEZTQvQW0xd2JtUG1JcmdJUXJBOVlzemdEeGZ5eEZsSmMw?=
 =?utf-8?B?TG5XRWhCeCtWK1o1bDNBL0V1SUtQYVlIR3U1SFpDTHZoaW9zc3dIbW1nVXFM?=
 =?utf-8?B?cmxKTTBmdDJSRWpvRHNud1dENlF4ODRXU0wyWUovSkdzam84Zzc5K0NsS2w0?=
 =?utf-8?B?bjRsd2pMaHo1TTZXOUZucm83bzVuWFI5MGZsWFdsaHNBZDR0dkdXcldMWDFy?=
 =?utf-8?B?Q1ZpU2FFbWxwS1IwSUx2MEIxWmRTcHFSRGorQjR2NGp3NXFSTmsyTTkvOHNS?=
 =?utf-8?B?TDFYTllxc25WRkRBc3dERmp5WHE3S2tMTkxUSWpyOGNvSVNiNzNRYmQrR1lO?=
 =?utf-8?B?TmhkdGg1V1VrZkpzOXF3RUtsaFpuM0habEY2VmtvcDZZUWJIcjVJVkN5U1h2?=
 =?utf-8?B?OXBpYmdlcm9wbTRrY0w5b3dVRmhTUmM4dWswdjZSSHVIOGZkWkcvU1ZxM0RI?=
 =?utf-8?B?aW4vY0FEVFRtLzVzanR0Vll0dUlxVzgrUkNOYmhHQnJSdXFFMUd1cEd1Skph?=
 =?utf-8?B?L2lYWUV2aVU0MVZSaFRCRGlOVnRIZnpZZG8rdWxwTDNjWCtkUENVaVpqanNR?=
 =?utf-8?B?dVNjTDJTVnhEMWE1WjAvbWlrekJYb3BKZW1hQ3J5ZHdIYm9RS1FTOE95ampZ?=
 =?utf-8?B?L1ltZzA4aFFEL0hKSm1XQ0phaURTNURtaGI4bjl0MmRCL0UvVnpySERieUha?=
 =?utf-8?B?eGVlQmhGTFRyN1RHeE1GY0JGcDE5YWRVUmtvUy96Y2s2QU5xWWIvS2hmbUJo?=
 =?utf-8?B?aDF6TWprbGROZS9NQVlzeXEzYi9iS211SGp1V2ZOZGRheTUyaHJjZGFxN21B?=
 =?utf-8?B?Tk9qVnlqZ1dkN0R6T2VEVU5XRXRVcnBRYlZsSVh3bkJ2QU1KeFdkV3hNbWl2?=
 =?utf-8?B?YWdkU1ZWSHhjTHc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b2e2ada-d395-4249-73e4-08d8bda4a5ce
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2021 00:36:52.9440
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n8K7/3peMNv39+Ib+itRA94Jqhpf285CccsUUJoBnL08uI8qEch5t+yr7IuhSHZZyflChu7VgtcwGWGq17JqoI8d+JtY/L1I1j536+WAWGI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB3088
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9870 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=0
 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101210001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9870 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 impostorscore=0 mlxscore=0 priorityscore=1501 phishscore=0 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 adultscore=0 clxscore=1015 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101210001
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 1/19/21 4:45 PM, Sean Christopherson wrote:
> On Sat, Jan 16, 2021, Krish Sadhukhan wrote:
>> According to section "Canonicalization and Consistency Checks" in APM vol 2,
>> the following guest state is illegal:
>>
>>          "The MSR or IOIO intercept tables extend to a physical address that
>>           is greater than or equal to the maximum supported physical address."
>>
>> Also check that these addresses are aligned on page boundary.
>>
>> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
>> ---
>>   arch/x86/kvm/svm/nested.c | 18 ++++++++++++------
>>   1 file changed, 12 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
>> index cb4c6ee10029..2419f392a13d 100644
>> --- a/arch/x86/kvm/svm/nested.c
>> +++ b/arch/x86/kvm/svm/nested.c
>> @@ -211,7 +211,8 @@ static bool svm_get_nested_state_pages(struct kvm_vcpu *vcpu)
>>   	return true;
>>   }
>>   
>> -static bool nested_vmcb_check_controls(struct vmcb_control_area *control)
>> +static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
>> +				       struct vmcb_control_area *control)
>>   {
>>   	if ((vmcb_is_intercept(control, INTERCEPT_VMRUN)) == 0)
>>   		return false;
>> @@ -223,10 +224,15 @@ static bool nested_vmcb_check_controls(struct vmcb_control_area *control)
>>   	    !npt_enabled)
>>   		return false;
>>   
>> +	if (!page_address_valid(vcpu, control->msrpm_base_pa))
>> +		return false;
>> +	if (!page_address_valid(vcpu, control->iopm_base_pa))
> These checks are wrong.  The MSRPM is 8kb in size, and the IOPM is 12kb, and the
> APM explicitly states that the last byte is checked:
>
>    if the address of the last byte in the table is greater than or equal to the
>    maximum supported physical address, this is treated as illegal VMCB state and
>    causes a #VMEXIT(VMEXIT_INVALID).
>
> KVM can't check just the last byte, as that would fail to detect a wrap of the
> 64-bit boundary.  Might be worth adding yet another helper?  I think this will
> work, though I'm sure Paolo has a much more clever solution :-)
>
>    static inline bool page_range_valid(struct kvm_vcpu *vcpu, gpa_t gpa, int size)
>    {
> 	gpa_t last_page = gpa + size - PAGE_SIZE;
>
> 	if (last_page < gpa)
> 		return false;
>
> 	return page_address_valid(last_page);
>    }
>
> Note, the IOPM is 12kb in size, but KVM allocates and initializes 16kb, i.e.
> using IOPM_ALLOC_ORDER for the check would be wrong.  Maybe define the actual
> size for both bitmaps and use get_order() instead of hardcoding the order?  That
> would make it easy to "fix" svm_hardware_setup() so that it doesn't initialize
> unused memory.


Is there any issues with using alloc_pages_exact() instead of 
alloc_pages() for allocating the IOPM bitmap ?

>
>> +		return false;
>> +
>>   	return true;
>>   }
>>   
>> -static bool nested_vmcb_checks(struct vcpu_svm *svm, struct vmcb *vmcb12)
>> +static bool nested_vmcb_checks(struct kvm_vcpu *vcpu, struct vmcb *vmcb12)
>>   {
>>   	bool vmcb12_lma;
>>   
>> @@ -255,10 +261,10 @@ static bool nested_vmcb_checks(struct vcpu_svm *svm, struct vmcb *vmcb12)
>>   		    (vmcb12->save.cr3 & MSR_CR3_LONG_MBZ_MASK))
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
>> @@ -485,7 +491,7 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
>>   	if (WARN_ON_ONCE(!svm->nested.initialized))
>>   		return -EINVAL;
>>   
>> -	if (!nested_vmcb_checks(svm, vmcb12)) {
>> +	if (!nested_vmcb_checks(&svm->vcpu, vmcb12)) {
>>   		vmcb12->control.exit_code    = SVM_EXIT_ERR;
>>   		vmcb12->control.exit_code_hi = 0;
>>   		vmcb12->control.exit_info_1  = 0;
>> @@ -1173,7 +1179,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
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
