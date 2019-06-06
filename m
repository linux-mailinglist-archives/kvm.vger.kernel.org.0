Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 076BD37D29
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 21:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729167AbfFFTVb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 15:21:31 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:52636 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728504AbfFFTVb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 15:21:31 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x56JIs1x159577;
        Thu, 6 Jun 2019 19:21:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=ZGGJPKfsk3L036pLr1d8EGwGK6t0E9/V4tYTxXtWdSk=;
 b=UlnRJc85OqZweCACVjr2mQuCCbo75VXDxn3xgd26QlcqJODiscULfKzaYDvPbQAW11O6
 G2+kAHoDFWH8H7HWw00UhDZ88W2cOglcbx8QFpkO2EpV+lSkttwnqzcRXFHzICUFY5Kk
 kADzMcVYB0Cs9Poq2Of5CFyampgqvkNCehB3mLkSInXEy6qM+viruJN3vdeLv87ZJFz1
 UmHK9+KH50VqrTf+9OwLdeHa0nSxpWBmXTSVPXX7902Mtbq92EVFho1aDI3UHnOwri11
 QTgDt4TDaFRybK7guvT19bcCjJBMfx1GGLN0oxgr0UVsdl9DLP9Jvq3L97FB9RCiQAWi kQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2suj0qtcgy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jun 2019 19:21:07 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x56JIbns054295;
        Thu, 6 Jun 2019 19:19:06 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2swnhaxgyj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jun 2019 19:19:06 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x56JJ57d012830;
        Thu, 6 Jun 2019 19:19:06 GMT
Received: from dhcp-10-132-91-225.usdhcp.oraclecorp.com (/10.132.91.225)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 06 Jun 2019 12:19:05 -0700
Subject: Re: [PATCH] KVM: nVMX: Rename prepare_vmcs02_*_full to
 prepare_vmcs02_*_extra
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <1559834652-105872-1-git-send-email-pbonzini@redhat.com>
 <20190606184117.GJ23169@linux.intel.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <89dd5d66-0d37-ea41-3f6d-72d5a8a9815d@oracle.com>
Date:   Thu, 6 Jun 2019 12:19:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.4.0
MIME-Version: 1.0
In-Reply-To: <20190606184117.GJ23169@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9280 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906060128
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9280 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906060129
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 06/06/2019 11:41 AM, Sean Christopherson wrote:
> On Thu, Jun 06, 2019 at 05:24:12PM +0200, Paolo Bonzini wrote:
>> These function do not prepare the entire state of the vmcs02, only the
>> rarely needed parts.  Rename them to make this clearer.
>>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
>>   arch/x86/kvm/vmx/nested.c | 8 ++++----
>>   1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> index 84438cf23d37..fd8150ef6cce 100644
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -1955,7 +1955,7 @@ static void prepare_vmcs02_constant_state(struct vcpu_vmx *vmx)
>>   	vmx_set_constant_host_state(vmx);
>>   }
>>   
>> -static void prepare_vmcs02_early_full(struct vcpu_vmx *vmx,
>> +static void prepare_vmcs02_early_extra(struct vcpu_vmx *vmx,
> Or maybe 'uncommon', 'rare' or 'ext'?  I don't I particularly love any of
> the names, but they're all better than 'full'.

The big chunk of the work in this function is done via 
prepare_vmcs02_constant_state(). It seems cleaner to get rid of 
prepare_vmcs02_early_full(), call prepare_vmcs02_constant_state() 
directly from prepare_vmcs02_early() and move the three vmcs_write16() 
calls to prepare_vmcs02_early().

>
> Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
>
>>   				      struct vmcs12 *vmcs12)
>>   {
>>   	prepare_vmcs02_constant_state(vmx);
>> @@ -1976,7 +1976,7 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
>>   	u64 guest_efer = nested_vmx_calc_efer(vmx, vmcs12);
>>   
>>   	if (vmx->nested.dirty_vmcs12 || vmx->nested.hv_evmcs)
>> -		prepare_vmcs02_early_full(vmx, vmcs12);
>> +		prepare_vmcs02_early_extra(vmx, vmcs12);
>>   
>>   	/*
>>   	 * PIN CONTROLS
>> @@ -2130,7 +2130,7 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
>>   	}
>>   }
>>   
>> -static void prepare_vmcs02_full(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
>> +static void prepare_vmcs02_extra(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
>>   {
>>   	struct hv_enlightened_vmcs *hv_evmcs = vmx->nested.hv_evmcs;
>>   
>> @@ -2254,7 +2254,7 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
>>   	struct vcpu_vmx *vmx = to_vmx(vcpu);
>>   
>>   	if (vmx->nested.dirty_vmcs12 || vmx->nested.hv_evmcs) {
>> -		prepare_vmcs02_full(vmx, vmcs12);
>> +		prepare_vmcs02_extra(vmx, vmcs12);
>>   		vmx->nested.dirty_vmcs12 = false;
>>   	}
>>   
>> -- 
>> 1.8.3.1
>>

