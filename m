Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 894DC2192A1
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 23:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbgGHVjA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 17:39:00 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40602 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725903AbgGHVjA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jul 2020 17:39:00 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 068LMn3X042696;
        Wed, 8 Jul 2020 21:38:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=ko1YfXN8wgwAryd3bGGP/gu/gjyowRCX0FdE9uhk9m8=;
 b=DT8vAyCyvxhkc6S7n9cKgpTt/ZX6HcBrNq+enALwQ5sqd03rKTDR0cKunBOIFiMMjr5U
 /RZq98DBfJALvK1O3xEZBGQWme3QdeYAIrQyiirzShpqcoLHrGQ7+2IqMWfh2FVu1RIn
 WeEML0/05huEDWtxz7wU6i9InWAfIw2d9ifTsQ/Y4FLtMIHfAYEHXtyzIdx9ljWHke7R
 kH0Ipw8I9Til1DsAGknxO96YUbAXjJ48wqjtTau3LhgFOo/PXh63v4Eg1Xfk0U1DvZWh
 n/uiYKcmzwwaRXCnPPQCNC7GaNn+5CiSwHTyVUxJ+huUGT+dcnEZn938NGsfJwxQbszp JA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 325k3491a2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 08 Jul 2020 21:38:57 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 068LOXvj053795;
        Wed, 8 Jul 2020 21:36:56 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 325k3y0u91-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jul 2020 21:36:56 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 068LauSj014454;
        Wed, 8 Jul 2020 21:36:56 GMT
Received: from localhost.localdomain (/10.159.144.146)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 08 Jul 2020 14:36:55 -0700
Subject: Re: [PATCH 2/3 v4] KVM: nSVM: Check that MBZ bits in CR3 and CR4 are
 not set on vmrun of nested guests
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <1594168797-29444-1-git-send-email-krish.sadhukhan@oracle.com>
 <1594168797-29444-3-git-send-email-krish.sadhukhan@oracle.com>
 <699b4ea4-d8df-e098-8f5c-3abe8e4c138c@redhat.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <10167403-c0c0-920e-19ba-8b5fcc70dff4@oracle.com>
Date:   Wed, 8 Jul 2020 14:36:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <699b4ea4-d8df-e098-8f5c-3abe8e4c138c@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9676 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 phishscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007080129
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9676 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 mlxlogscore=999 priorityscore=1501 clxscore=1015 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007080129
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/8/20 3:03 AM, Paolo Bonzini wrote:
> On 08/07/20 02:39, Krish Sadhukhan wrote:
>> +extern int kvm_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
>> +
> This should be added in x86.h, not here.
>
>> +static bool nested_vmcb_checks(struct vcpu_svm *svm, struct vmcb *vmcb)
>>   {
>>   	if ((vmcb->save.efer & EFER_SVME) == 0)
>>   		return false;
>> @@ -231,6 +233,22 @@ static bool nested_vmcb_checks(struct vmcb *vmcb)
>>   	    (vmcb->save.cr0 & X86_CR0_NW))
>>   		return false;
>>   
>> +	if (!is_long_mode(&(svm->vcpu))) {
>> +		if (vmcb->save.cr4 & X86_CR4_PAE) {
>> +			if (vmcb->save.cr3 & MSR_CR3_LEGACY_PAE_RESERVED_MASK)
>> +				return false;
>> +		} else {
>> +			if (vmcb->save.cr3 & MSR_CR3_LEGACY_RESERVED_MASK)
>> +				return false;
>> +		}
>> +	} else {
>> +		if ((vmcb->save.cr4 & X86_CR4_PAE) &&
>> +		    (vmcb->save.cr3 & MSR_CR3_LONG_RESERVED_MASK))
>> +			return false;
>> +	}
> is_long_mode here is wrong, as it refers to the host.
>
> You need to do something like this:
>
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 385461496cf5..cbbab83f19cc 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -222,8 +222,9 @@ static bool nested_vmcb_check_controls(struct vmcb_control_area *control)
>   	return true;
>   }
>   
> -static bool nested_vmcb_checks(struct vmcb *vmcb)
> +static bool nested_vmcb_checks(struct vcpu_svm *svm, struct vmcb *vmcb)
>   {
> +	bool nested_vmcb_lma;
>   	if ((vmcb->save.efer & EFER_SVME) == 0)
>   		return false;
>   
> @@ -234,6 +237,27 @@ static bool nested_vmcb_checks(struct vmcb *vmcb)
>   	if (!kvm_dr6_valid(vmcb->save.dr6) || !kvm_dr7_valid(vmcb->save.dr7))
>   		return false;
>   
> +	nested_vmcb_lma =
> +	        (vmcb->save.efer & EFER_LME) &&
> +                (vmcb->save.cr0 & X86_CR0_PG);
> +
> +	if (!nested_vmcb_lma) {
> +		if (vmcb->save.cr4 & X86_CR4_PAE) {
> +			if (vmcb->save.cr3 & MSR_CR3_LEGACY_PAE_RESERVED_MASK)
> +				return false;
> +		} else {
> +			if (vmcb->save.cr3 & MSR_CR3_LEGACY_RESERVED_MASK)
> +				return false;
> +		}
> +	} else {
> +		if (!(vmcb->save.cr4 & X86_CR4_PAE) ||
> +		    !(vmcb->save.cr0 & X86_CR0_PE) ||
> +		    (vmcb->save.cr3 & MSR_CR3_LONG_RESERVED_MASK))
> +			return false;
> +	}
> +	if (kvm_valid_cr4(&(svm->vcpu), vmcb->save.cr4))
> +		return false;
> +
>   	return nested_vmcb_check_controls(&vmcb->control);
>   }
>   
> which also takes care of other CR0/CR4 checks in the APM.


Thanks for adding additional other checks and fixing the long-mode check.

>
> I'll test this a bit more and queue it.  Are you also going to add
> more checks in svm_set_nested_state?


I will send a patch to cover the missing checks in svm_set_nested_state().

>
> Paolo
>
