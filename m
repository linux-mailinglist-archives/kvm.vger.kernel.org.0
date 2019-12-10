Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB3891190CB
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2019 20:36:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbfLJTgG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Dec 2019 14:36:06 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:39564 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbfLJTgG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Dec 2019 14:36:06 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBAJY7u1008668;
        Tue, 10 Dec 2019 19:36:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=89B3iHbQr9MkCL7j5mEOxS/m6No1bAkeVSY2Cuaa/EY=;
 b=JC2arjjA86iUBeuc9cnDyQ0DjR4icDUmd1G/l+4TZGwmYdxfX5nJ+SkFKHGcDD7rqc05
 Ds1tvdhOBfvThzvmecqSs0GEmKjvCVZEPwG5ZaruxMXE6VCgARGdpDpDyuWZoNqcc4oW
 WFG7C5hj/4UdT91Mu6c66v+lKs9GCSonC9DG1TaExuitA+rWZrN+kduef3yxurFJ0OgA
 i0BSR+rPzKOw2rYL/v3JJA+CHo7rcOI6fnX8NZyMnFX4kNKLC9ZFuQc5fi/HxGi4VS0V
 DhkdmHrgrTmUMZfGeYKkh60RyYdwr3mXdFXJQZ9U0IVY7UNAHqFS6c0cU8EuWnfv0PAZ 5w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2wrw4n56u0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Dec 2019 19:36:02 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBAJXXaL096678;
        Tue, 10 Dec 2019 19:36:01 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2wt6bdct3r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Dec 2019 19:36:01 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBAJZxaf007683;
        Tue, 10 Dec 2019 19:35:59 GMT
Received: from [10.159.229.173] (/10.159.229.173)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Dec 2019 11:35:59 -0800
Subject: Re: [PATCH 1/4] KVM: nVMX: Check GUEST_SYSENTER_ESP and
 GUEST_SYSENTER_EIP on vmentry of nested guests
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
References: <20191206231302.3466-1-krish.sadhukhan@oracle.com>
 <20191206231302.3466-2-krish.sadhukhan@oracle.com>
 <CALMp9eQ4_qtcO1BbraOwXHamXwi4M3AOq1NE7X84wgxxm=ismA@mail.gmail.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <47daeae4-6836-9d60-729a-d5e2d5810edd@oracle.com>
Date:   Tue, 10 Dec 2019 11:35:58 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eQ4_qtcO1BbraOwXHamXwi4M3AOq1NE7X84wgxxm=ismA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9467 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912100161
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9467 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912100161
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 12/10/19 9:57 AM, Jim Mattson wrote:
> On Fri, Dec 6, 2019 at 3:49 PM Krish Sadhukhan
> <krish.sadhukhan@oracle.com> wrote:
>> According to section "Checks on Guest Control Registers, Debug Registers, and
>> and MSRs" in Intel SDM vol 3C, the following checks are performed on vmentry
>> of nested guests:
>>
>>      "The IA32_SYSENTER_ESP field and the IA32_SYSENTER_EIP field must each
>>       contain a canonical address."
>>
>> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
>> Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
>> ---
>>   arch/x86/kvm/vmx/nested.c | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> index 0e7c9301fe86..a2d1c305a7d8 100644
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -2770,6 +2770,10 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
>>              CC(!nested_guest_cr4_valid(vcpu, vmcs12->guest_cr4)))
>>                  return -EINVAL;
>>
>> +       if (CC(!is_noncanonical_address(vmcs12->guest_sysenter_esp)) ||
>> +           CC(!is_noncanonical_address(vmcs12->guest_sysenter_eip)))
>> +               return -EINVAL;
>> +
> Don't the hardware checks on the corresponding vmcs02 fields suffice
> in this case?

In prepare_vmcs02(), we have the following code:

         if (vmx->nested.dirty_vmcs12 || hv_evmcs) {
                 prepare_vmcs02_rare(vmx, vmcs12);

If vmcs12 is dirty, we are setting these two fields from vmcs12 and I 
thought the values needed to be checked in software. Did I miss something ?

>
>>          if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PAT) &&
>>              CC(!kvm_pat_valid(vmcs12->guest_ia32_pat)))
>>                  return -EINVAL;
>> --
>> 2.20.1
>>
