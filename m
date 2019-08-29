Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E325AA0EED
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 03:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbfH2Bay (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 21:30:54 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:32772 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbfH2Bay (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 21:30:54 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7T1TEvJ057977;
        Thu, 29 Aug 2019 01:30:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=CtMaeqMXyeB1M8q3REz8poHfRL75Pm+1jHwPSY48jlE=;
 b=p/55GI+dIOX0SGnK57KAX1IePGb2Wx+R/BUsxKZwhrFiyx6K7MrLlO7zM46wozq7k/35
 2XNoj8YuNklRdH4D7sMeDDLynWQgM/BFT4Me5gFEZ+G59weod5zHfQjEeH5bqweGzFlD
 qtJDMxClVvAHrntCNUgCJ1L73hIltE5QRYiBPqjy6ZU2qFCV/o4fe03XRh/DdN9PCaiz
 DP9H/M/PANSjrMdK39Oh61LJAArOOzuDD8rznzXkJrMpVgzh2yIhj/W7POw0l6LIDZvP
 A2EKzC8VFuq97SH4apxYXbPLT++r/JWHB83bqB3k4bQ4h7YcER5jR0s0eB1vqPfFO7Zm pg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2up509012y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 01:30:32 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7T1SvdY045569;
        Thu, 29 Aug 2019 01:30:31 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2undw82u1q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 01:30:31 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7T1UUAf028280;
        Thu, 29 Aug 2019 01:30:30 GMT
Received: from dhcp-10-132-91-76.usdhcp.oraclecorp.com (/10.132.91.76)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 28 Aug 2019 18:30:30 -0700
Subject: Re: [PATCH 1/7] KVM: nVMX: Use kvm_set_msr to load
 IA32_PERF_GLOBAL_CTRL on vmexit
To:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, Peter Shier <pshier@google.com>
References: <20190828234134.132704-1-oupton@google.com>
 <20190828234134.132704-2-oupton@google.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <ed9ae8fc-d4d6-3dde-bac3-3c9068f0fc42@oracle.com>
Date:   Wed, 28 Aug 2019 18:30:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.4.0
MIME-Version: 1.0
In-Reply-To: <20190828234134.132704-2-oupton@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9363 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=4 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908290014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9363 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=4 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908290014
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 08/28/2019 04:41 PM, Oliver Upton wrote:
> The existing implementation for loading the IA32_PERF_GLOBAL_CTRL MSR
> on VM-exit was incorrect, as the next call to atomic_switch_perf_msrs()
> could cause this value to be overwritten. Instead, call kvm_set_msr()
> which will allow atomic_switch_perf_msrs() to correctly set the values.
>
> Suggested-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>   arch/x86/kvm/vmx/nested.c | 13 ++++++++++---
>   1 file changed, 10 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index ced9fba32598..b0ca34bf4d21 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -3724,6 +3724,7 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
>   				   struct vmcs12 *vmcs12)
>   {
>   	struct kvm_segment seg;
> +	struct msr_data msr_info;
>   	u32 entry_failure_code;
>   
>   	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_EFER)
> @@ -3800,9 +3801,15 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
>   		vmcs_write64(GUEST_IA32_PAT, vmcs12->host_ia32_pat);
>   		vcpu->arch.pat = vmcs12->host_ia32_pat;
>   	}
> -	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL)
> -		vmcs_write64(GUEST_IA32_PERF_GLOBAL_CTRL,
> -			vmcs12->host_ia32_perf_global_ctrl);
> +	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL) {
> +		msr_info.host_initiated = false;
> +		msr_info.index = MSR_CORE_PERF_GLOBAL_CTRL;
> +		msr_info.data = vmcs12->host_ia32_perf_global_ctrl;
> +		if (kvm_set_msr(vcpu, &msr_info))
> +			pr_debug_ratelimited(
> +				"%s cannot write MSR (0x%x, 0x%llx)\n",
> +				__func__, msr_info.index, msr_info.data);
> +	}
>   
>   	/* Set L1 segment info according to Intel SDM
>   	    27.5.2 Loading Host Segment and Descriptor-Table Registers */

These patches are what I am already working on. I sent the following:

         [KVM nVMX]: Check "load IA32_PERF_GLOBAL_CTRL" on vmentry of 
nested guests
         [PATCH 0/4][kvm-unit-test nVMX]: Test "load 
IA32_PERF_GLOBAL_CONTROL" VM-entry control on vmentry of nested guests

a few months back. I got feedback from the alias and am working on v2 
which I will send soon...
