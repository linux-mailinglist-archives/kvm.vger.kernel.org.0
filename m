Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 478BD2DC7AE
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 21:21:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728878AbgLPUSu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Dec 2020 15:18:50 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:34886 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728867AbgLPUSu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Dec 2020 15:18:50 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BGKEXML164411;
        Wed, 16 Dec 2020 20:18:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=j286CjgxHgz1qwlQn/RARa8ecin2nybO/6ohNUkNOug=;
 b=Qz0QjcXzHP+DkSK8NLOgV8DGxLByLPPP+m2vXKwT1h9dqh5BMa548F7IBbbnoN67rAnM
 yJGvWfpNYOhk4ilVOQZsbOwJn9tykRD3tyaOf/cYEBSgjWRn4CSUN96TV+jCg5HD/GfX
 cW9uHDNrY+y3uVPtYHTV72kshp7dfRkeJfz9c34azgnWr1ugI+lh/HZ4iP+dopC31dN7
 2+I5ZPjf5/JkMta3w2qEulSNET2vpLARvoqnONY+71bz1jX0mXb9tRwMM5O+mWEgePKQ
 xpsepkN7QRUZB1sJGxag5kaD65AwAKN2v5QYWcLkpBQAQR3FzqOFwpO1f74QShA0ZLjO SA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 35cn9rjb9k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 16 Dec 2020 20:18:04 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BGKFEWW102139;
        Wed, 16 Dec 2020 20:16:04 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 35e6jt98jv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Dec 2020 20:16:04 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BGKG3E8001831;
        Wed, 16 Dec 2020 20:16:03 GMT
Received: from localhost.localdomain (/10.159.143.35)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 16 Dec 2020 12:16:03 -0800
Subject: Re: [PATCH] KVM/nVMX: Use __vmx_vcpu_run in
 nested_vmx_check_vmentry_hw
To:     Uros Bizjak <ubizjak@gmail.com>, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <20201029134145.107560-1-ubizjak@gmail.com>
 <CAFULd4av_xehfPBBL76dH+On4ezLa6rqU6YkqBuLhPcvZTr5pQ@mail.gmail.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <c0f5129e-a04a-5b9c-f561-1132283077f1@oracle.com>
Date:   Wed, 16 Dec 2020 12:15:54 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <CAFULd4av_xehfPBBL76dH+On4ezLa6rqU6YkqBuLhPcvZTr5pQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9837 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 adultscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012160125
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9837 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 impostorscore=0 lowpriorityscore=0 clxscore=1011 spamscore=0
 malwarescore=0 priorityscore=1501 phishscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012160125
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 12/16/20 1:24 AM, Uros Bizjak wrote:
> Ping.  This patch didn't receive any feedback.
>
> Thanks,
> Uros.
>
> On Thu, Oct 29, 2020 at 2:41 PM Uros Bizjak <ubizjak@gmail.com> wrote:
>> Replace inline assembly in nested_vmx_check_vmentry_hw
>> with a call to __vmx_vcpu_run.  The function is not
>> performance critical, so (double) GPR save/restore
>> in __vmx_vcpu_run can be tolerated, as far as performance
>> effects are concerned.
>>
>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
>> Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
>> ---
>>   arch/x86/kvm/vmx/nested.c | 32 +++-----------------------------
>>   arch/x86/kvm/vmx/vmx.c    |  2 --
>>   arch/x86/kvm/vmx/vmx.h    |  1 +
>>   3 files changed, 4 insertions(+), 31 deletions(-)
>>
>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> index 89af692deb7e..6ab62bf277c4 100644
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -12,6 +12,7 @@
>>   #include "nested.h"
>>   #include "pmu.h"
>>   #include "trace.h"
>> +#include "vmx.h"
>>   #include "x86.h"
>>
>>   static bool __read_mostly enable_shadow_vmcs = 1;
>> @@ -3056,35 +3057,8 @@ static int nested_vmx_check_vmentry_hw(struct kvm_vcpu *vcpu)
>>                  vmx->loaded_vmcs->host_state.cr4 = cr4;
>>          }
>>
>> -       asm(
>> -               "sub $%c[wordsize], %%" _ASM_SP "\n\t" /* temporarily adjust RSP for CALL */
>> -               "cmp %%" _ASM_SP ", %c[host_state_rsp](%[loaded_vmcs]) \n\t"
>> -               "je 1f \n\t"
>> -               __ex("vmwrite %%" _ASM_SP ", %[HOST_RSP]") "\n\t"
>> -               "mov %%" _ASM_SP ", %c[host_state_rsp](%[loaded_vmcs]) \n\t"
>> -               "1: \n\t"
>> -               "add $%c[wordsize], %%" _ASM_SP "\n\t" /* un-adjust RSP */
>> -
>> -               /* Check if vmlaunch or vmresume is needed */
>> -               "cmpb $0, %c[launched](%[loaded_vmcs])\n\t"
>> -
>> -               /*
>> -                * VMLAUNCH and VMRESUME clear RFLAGS.{CF,ZF} on VM-Exit, set
>> -                * RFLAGS.CF on VM-Fail Invalid and set RFLAGS.ZF on VM-Fail
>> -                * Valid.  vmx_vmenter() directly "returns" RFLAGS, and so the
>> -                * results of VM-Enter is captured via CC_{SET,OUT} to vm_fail.
>> -                */
>> -               "call vmx_vmenter\n\t"
>> -
>> -               CC_SET(be)
>> -             : ASM_CALL_CONSTRAINT, CC_OUT(be) (vm_fail)
>> -             : [HOST_RSP]"r"((unsigned long)HOST_RSP),
>> -               [loaded_vmcs]"r"(vmx->loaded_vmcs),
>> -               [launched]"i"(offsetof(struct loaded_vmcs, launched)),
>> -               [host_state_rsp]"i"(offsetof(struct loaded_vmcs, host_state.rsp)),
>> -               [wordsize]"i"(sizeof(ulong))
>> -             : "memory"
>> -       );
>> +       vm_fail = __vmx_vcpu_run(vmx, (unsigned long *)&vcpu->arch.regs,
>> +                                vmx->loaded_vmcs->launched);
>>
>>          if (vmx->msr_autoload.host.nr)
>>                  vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, vmx->msr_autoload.host.nr);
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index d14c94d0aff1..0f390c748b18 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -6591,8 +6591,6 @@ static fastpath_t vmx_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
>>          }
>>   }
>>
>> -bool __vmx_vcpu_run(struct vcpu_vmx *vmx, unsigned long *regs, bool launched);
>> -
>>   static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
>>                                          struct vcpu_vmx *vmx)
>>   {
>> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
>> index f6f66e5c6510..32db3b033e9b 100644
>> --- a/arch/x86/kvm/vmx/vmx.h
>> +++ b/arch/x86/kvm/vmx/vmx.h
>> @@ -339,6 +339,7 @@ void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
>>   struct vmx_uret_msr *vmx_find_uret_msr(struct vcpu_vmx *vmx, u32 msr);
>>   void pt_update_intercept_for_msr(struct kvm_vcpu *vcpu);
>>   void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp);
>> +bool __vmx_vcpu_run(struct vcpu_vmx *vmx, unsigned long *regs, bool launched);
>>   int vmx_find_loadstore_msr_slot(struct vmx_msrs *m, u32 msr);
>>   void vmx_ept_load_pdptrs(struct kvm_vcpu *vcpu);
>>
>> --
>> 2.26.2
>>
Semantically __vmx_vcpu_run() is called to enter guest mode. In 
nested_vmx_check_vmentry_hw(), we are not entering guest mode. Guest 
mode is entered when nested_vmx_enter_non_root_mode() calls 
enter_guest_mode().

Secondly, why not just replace the first half of the assembly block with 
a call to vmx_update_host_rsp() and leave the rest as is ?

