Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D11E51C2215
	for <lists+kvm@lfdr.de>; Sat,  2 May 2020 03:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726660AbgEBBFP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 May 2020 21:05:15 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48598 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726381AbgEBBFP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 May 2020 21:05:15 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04213Oxl126315;
        Sat, 2 May 2020 01:05:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=DjX+MsNWu02BKnC2iVD49ygiZ9ja043L7yehGypnFJw=;
 b=lZcjAfvvPec00dwBCpVCiKyV2tK9f6U9RybbLvpwJyx3+m3MGGLRmOEHm41uvyaaaeZ1
 yci91XA8RJCOBZWJsCbDihPrKAy89quCZ1kLwErmEpepdKydZ/C57/TBHRV9EglWxy8M
 q+QzwMaLZbhtlsdy6RC9asO48LJSx70gAzzJSlw0lpnNw3KZjlvoy7EsHv9iSkRKXHDM
 4eMr15XuIqFDUQeINJKJQ/gqruaXwAozlWbGF/BLE1RzUHPQH0SP5YQJzG/pvl3+KI4u
 CmhToQziClt75S89LBrWGD197JsLTW2JxLKrgaB09/S/GxWWKmv4vFtZh+S7LakcQ9qC zw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 30r7f84gyb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 02 May 2020 01:05:11 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04213Rnk072799;
        Sat, 2 May 2020 01:05:11 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 30rwyquxue-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 02 May 2020 01:05:10 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04215AfQ005207;
        Sat, 2 May 2020 01:05:10 GMT
Received: from [192.168.14.112] (/79.176.191.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 01 May 2020 18:05:09 -0700
Subject: Re: [PATCH RFC 1/1] KVM: x86: add KVM_HC_UCALL hypercall
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Forrest Yuan Yu <yuanyu@google.com>
Cc:     kvm@vger.kernel.org
References: <20200501185147.208192-1-yuanyu@google.com>
 <20200501185147.208192-2-yuanyu@google.com>
 <20200501204552.GD4760@linux.intel.com>
From:   Liran Alon <liran.alon@oracle.com>
Message-ID: <49fea649-9376-f8f8-1718-72672926e1bf@oracle.com>
Date:   Sat, 2 May 2020 04:05:06 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200501204552.GD4760@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9608 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 phishscore=0 malwarescore=0 spamscore=0 adultscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005020005
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9608 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxlogscore=999
 spamscore=0 malwarescore=0 clxscore=1011 phishscore=0 mlxscore=0
 lowpriorityscore=0 suspectscore=0 adultscore=0 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005020005
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 01/05/2020 23:45, Sean Christopherson wrote:
> On Fri, May 01, 2020 at 11:51:47AM -0700, Forrest Yuan Yu wrote:
>> The purpose of this new hypercall is to exchange message between
>> guest and hypervisor. For example, a guest may want to ask hypervisor
>> to harden security by setting restricted access permission on guest
>> SLAT entry. In this case, the guest can use this hypercall to send
>>
>> a message to the hypervisor which will do its job and send back
>> anything it wants the guest to know.
> Hrm, so this reintroduces KVM_EXIT_HYPERCALL without justifying _why_ it
> needs to be reintroduced.  I'm not familiar with the history, but the
> comments in the documentation advise "use KVM_EXIT_IO or KVM_EXIT_MMIO".
Both of these options have the disadvantage of requiring instruction 
emulation (Although a trivial one for PIO). Which enlarge host attack 
surface.
I think this is one of the reasons why Hyper-V defined their PV devices 
(E.g. NetVSC/StorVSC) doorbell kick with hypercall instead of PIO/MMIO.
(This is currently not much relevant as KVM's instruction emulator is 
not optional and is not even offloaded to host userspace. But relevant 
for the future...)
>
> Off the top of my head, IO and/or MMIO has a few advantages:
>
>    - Allows the guest kernel to delegate permissions to guest userspace,
>      whereas KVM restrict hypercalls to CPL0.
>    - Allows "pass-through", whereas VMCALL is unconditionally forwarded to
>      L1.
>    - Is vendor agnostic, e.g. VMX and SVM recognized different opcodes for
>      VMCALL vs VMMCALL.
I agree with all the above (I believe similar rational had led VMware to 
design their Backdoor PIO interface).

Also note that recently AWS introduced Nitro Enclave PV device which is 
also de-facto a PV control-plane interface between guest and host userspace.
Why similar approach couldn't have been used here?
(Capability is exposed on a per-VM basis by attaching PV device to VM, 
communication interface is device specific and no KVM changes, only host 
userspace changes).
>   
>> Signed-off-by: Forrest Yuan Yu <yuanyu@google.com>
>> ---
>> diff --git a/Documentation/virt/kvm/cpuid.rst b/Documentation/virt/kvm/cpuid.rst
>> index 01b081f6e7ea..ff313f6827bf 100644
>> --- a/Documentation/virt/kvm/cpuid.rst
>> +++ b/Documentation/virt/kvm/cpuid.rst
>> @@ -86,6 +86,9 @@ KVM_FEATURE_PV_SCHED_YIELD        13          guest checks this feature bit
>>                                                 before using paravirtualized
>>                                                 sched yield.
>>   
>> +KVM_FEATURE_UCALL                 14          guest checks this feature bit
>> +                                              before calling hypercall ucall.
> Why make the UCALL a KVM CPUID feature?  I can understand wanting to query
> KVM support from host userspace, but presumably the guest will care about
> capabiliteis built on top of the UCALL, not the UCALL itself.
I agree with this.
In case of PV device approach, device detection by guest will be the 
capability discovery.
>
>> +
>>   KVM_FEATURE_CLOCSOURCE_STABLE_BIT 24          host will warn if no guest-side
>>                                                 per-cpu warps are expeced in
>>                                                 kvmclock
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index c5835f9cb9ad..388a4f89464d 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -3385,6 +3385,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>>   	case KVM_CAP_GET_MSR_FEATURES:
>>   	case KVM_CAP_MSR_PLATFORM_INFO:
>>   	case KVM_CAP_EXCEPTION_PAYLOAD:
>> +	case KVM_CAP_UCALL:
> For whatever reason I have a metnal block with UCALL, can we call this
> KVM_CAP_USERSPACE_HYPERCALL
+1
>
>>   		r = 1;
>>   		break;
>>   	case KVM_CAP_SYNC_REGS:
>> @@ -4895,6 +4896,10 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>>   		kvm->arch.exception_payload_enabled = cap->args[0];
>>   		r = 0;
>>   		break;
>> +	case KVM_CAP_UCALL:
>> +		kvm->arch.hypercall_ucall_enabled = cap->args[0];
>> +		r = 0;
>> +		break;
>>   	default:
>>   		r = -EINVAL;
>>   		break;
>> @@ -7554,6 +7559,19 @@ static void kvm_sched_yield(struct kvm *kvm, unsigned long dest_id)
>>   		kvm_vcpu_yield_to(target);
>>   }
>>   
>> +static int complete_hypercall(struct kvm_vcpu *vcpu)
>> +{
>> +	u64 ret = vcpu->run->hypercall.ret;
>> +
>> +	if (!is_64_bit_mode(vcpu))
> Do we really anticipate adding support in 32-bit guests?  Honest question.
>
>> +		ret = (u32)ret;
>> +	kvm_rax_write(vcpu, ret);
>> +
>> +	++vcpu->stat.hypercalls;
>> +
>> +	return kvm_skip_emulated_instruction(vcpu);
>> +}
>> +
>>   int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>>   {
>>   	unsigned long nr, a0, a1, a2, a3, ret;
>> @@ -7605,17 +7623,26 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>>   		kvm_sched_yield(vcpu->kvm, a0);
>>   		ret = 0;
>>   		break;
>> +	case KVM_HC_UCALL:
>> +		if (vcpu->kvm->arch.hypercall_ucall_enabled) {
>> +			vcpu->run->hypercall.nr = nr;
>> +			vcpu->run->hypercall.args[0] = a0;
>> +			vcpu->run->hypercall.args[1] = a1;
>> +			vcpu->run->hypercall.args[2] = a2;
>> +			vcpu->run->hypercall.args[3] = a3;
> If performance is a justification for a more direct userspace exit, why
> limit it to just four parameters?  E.g. why not copy all registers to
> kvm_sync_regs and reverse the process on the way back in?
I don't think performance should be relevant for a hypercall interface. 
It's control-plane path.
If a fast-path is required, guest should use this interface to 
coordinate a separate fast-path (e.g. via ring-buffer on some guest 
memory page).

Anyway, these kind of questions is another reason why I agree with Sean 
it seems using a PV device is preferred.
Instead of forcing a general userspace hypercall interface standard, one 
could just implement whatever PV device it wants in host userspace which 
is device specific.

In QEMU's VMPort implementation BTW, userspace calls 
cpu_synchronize_state() which de-facto syncs tons of vCPU state from KVM 
to userspace. Not just the GP registers.
Because it's a slow-path, it's considered fine. :P

-Liran

>
>> +			vcpu->run->exit_reason = KVM_EXIT_HYPERCALL;
>> +			vcpu->arch.complete_userspace_io = complete_hypercall;
>> +			return 0; // message is going to userspace
>> +		}
>> +		ret = -KVM_ENOSYS;
>> +		break;
>>   	default:
>>   		ret = -KVM_ENOSYS;
>>   		break;
>>   	}
>>   out:
>> -	if (!op_64_bit)
>> -		ret = (u32)ret;
>> -	kvm_rax_write(vcpu, ret);
>> -
>> -	++vcpu->stat.hypercalls;
>> -	return kvm_skip_emulated_instruction(vcpu);
>> +	vcpu->run->hypercall.ret = ret;
>> +	return complete_hypercall(vcpu);
>>   }
>>   EXPORT_SYMBOL_GPL(kvm_emulate_hypercall);
