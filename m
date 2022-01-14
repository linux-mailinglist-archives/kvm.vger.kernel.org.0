Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2596348EB19
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 14:53:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236806AbiANNxP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 08:53:15 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:8792 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230472AbiANNxN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Jan 2022 08:53:13 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20EBveur020151;
        Fri, 14 Jan 2022 13:51:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=vP1aoBsPQt/yrozo2sUvU5CVIot6dV2VEGneghSkLFA=;
 b=a2gFV4734kGqUgIHKXadnrCFSKuBjJRY30aUQdGCFiYF8jRsHV+z2mI4wFE/Vmth6kUs
 8QUMtKN08iYUGQdeGav2yl4jGVMOnN+FjLbFBpgJ6dEmNOs7wsMT4y+PEc1wueG6Atxc
 OXnSBTyBBQbA8HCalgy5VAexQD8ps0se//ZDpVvQbn1K2qLNcATAExxwxxPYpHjsKd1u
 IS1l1Q16lhrtUXAVpb64mZZhXTVa4ROac7uK7SIt27/2EeBnhIyQDnzALcLTG4mxbb6L
 eHN77+UCRvY8NAuo6a9ZGGf68003niLfHTxMzqmoVo9J4NtX4+8u69ZsERMOzAndRSg7 ZA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dk8rvj1er-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 13:51:46 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20EDEb57026077;
        Fri, 14 Jan 2022 13:51:45 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dk8rvj1e0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 13:51:45 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20EDkqGP005393;
        Fri, 14 Jan 2022 13:51:43 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 3df1vjxub1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 13:51:43 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20EDpeCG37093796
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jan 2022 13:51:40 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2808052051;
        Fri, 14 Jan 2022 13:51:40 +0000 (GMT)
Received: from [9.171.88.24] (unknown [9.171.88.24])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id A47C752050;
        Fri, 14 Jan 2022 13:51:38 +0000 (GMT)
Message-ID: <b66c4856-7826-9cff-83f3-007d7ed5635c@linux.ibm.com>
Date:   Fri, 14 Jan 2022 14:51:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 0/5] kvm: fix latent guest entry/exit bugs
Content-Language: en-US
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     linux-kernel@vger.kernel.org, aleksandar.qemu.devel@gmail.com,
        alexandru.elisei@arm.com, anup.patel@wdc.com,
        aou@eecs.berkeley.edu, atish.patra@wdc.com,
        benh@kernel.crashing.org, bp@alien8.de, catalin.marinas@arm.com,
        chenhuacai@kernel.org, dave.hansen@linux.intel.com,
        david@redhat.com, frankja@linux.ibm.com, frederic@kernel.org,
        gor@linux.ibm.com, hca@linux.ibm.com, imbrenda@linux.ibm.com,
        james.morse@arm.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, maz@kernel.org, mingo@redhat.com,
        mpe@ellerman.id.au, nsaenzju@redhat.com, palmer@dabbelt.com,
        paulmck@kernel.org, paulus@samba.org, paul.walmsley@sifive.com,
        pbonzini@redhat.com, seanjc@google.com, suzuki.poulose@arm.com,
        tglx@linutronix.de, tsbogend@alpha.franken.de, vkuznets@redhat.com,
        wanpengli@tencent.com, will@kernel.org
References: <20220111153539.2532246-1-mark.rutland@arm.com>
 <127a6117-85fb-7477-983c-daf09e91349d@linux.ibm.com>
 <YeFqUlhqY+7uzUT1@FVFF77S0Q05N>
 <ae1a42ab-f719-4a4e-8d2a-e2b4fa6e9580@linux.ibm.com>
 <YeF7Wvz05JhyCx0l@FVFF77S0Q05N>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <YeF7Wvz05JhyCx0l@FVFF77S0Q05N>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: V601sx0TRChMmHg9UgBYp6CkK53iWuCv
X-Proofpoint-ORIG-GUID: EIy8ZE84WROG9oqjCpjBq0scXVJmJ2Sk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-14_05,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 bulkscore=0 mlxlogscore=584
 priorityscore=1501 clxscore=1015 phishscore=0 spamscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201140090
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 14.01.22 um 14:32 schrieb Mark Rutland:
> On Fri, Jan 14, 2022 at 01:29:46PM +0100, Christian Borntraeger wrote:
>>
>>
>> Am 14.01.22 um 13:19 schrieb Mark Rutland:
>>> On Thu, Jan 13, 2022 at 04:20:07PM +0100, Christian Borntraeger wrote:
>>>> Am 11.01.22 um 16:35 schrieb Mark Rutland:
>>>>> Several architectures have latent bugs around guest entry/exit, most
>>>>> notably:
>>>>>
>>>>> 1) Several architectures enable interrupts between guest_enter() and
>>>>>       guest_exit(). As this period is an RCU extended quiescent state (EQS) this
>>>>>       is unsound unless the irq entry code explicitly wakes RCU, which most
>>>>>       architectures only do for entry from usersapce or idle.
>>>>>
>>>>>       I believe this affects: arm64, riscv, s390
>>>>>
>>>>>       I am not sure about powerpc.
>>>>>
>>>>> 2) Several architectures permit instrumentation of code between
>>>>>       guest_enter() and guest_exit(), e.g. KASAN, KCOV, KCSAN, etc. As
>>>>>       instrumentation may directly o indirectly use RCU, this has the same
>>>>>       problems as with interrupts.
>>>>>
>>>>>       I believe this affects: arm64, mips, powerpc, riscv, s390
>>>>>
>>>>> 3) Several architectures do not inform lockdep and tracing that
>>>>>       interrupts are enabled during the execution of the guest, or do so in
>>>>>       an incorrect order. Generally
>>>>>       this means that logs will report IRQs being masked for much longer
>>>>>       than is actually the case, which is not ideal for debugging. I don't
>>>>>       know whether this affects the correctness of lockdep.
>>>>>
>>>>>       I believe this affects: arm64, mips, powerpc, riscv, s390
>>>>>
>>>>> This was previously fixed for x86 specifically in a series of commits:
>>>>>
>>>>>      87fa7f3e98a1310e ("x86/kvm: Move context tracking where it belongs")
>>>>>      0642391e2139a2c1 ("x86/kvm/vmx: Add hardirq tracing to guest enter/exit")
>>>>>      9fc975e9efd03e57 ("x86/kvm/svm: Add hardirq tracing on guest enter/exit")
>>>>>      3ebccdf373c21d86 ("x86/kvm/vmx: Move guest enter/exit into .noinstr.text")
>>>>>      135961e0a7d555fc ("x86/kvm/svm: Move guest enter/exit into .noinstr.text")
>>>>>      160457140187c5fb ("KVM: x86: Defer vtime accounting 'til after IRQ handling")
>>>>>      bc908e091b326467 ("KVM: x86: Consolidate guest enter/exit logic to common helpers")
>>>>>
>>>>> But other architectures were left broken, and the infrastructure for
>>>>> handling this correctly is x86-specific.
>>>>>
>>>>> This series introduces generic helper functions which can be used to
>>>>> handle the problems above, and migrates architectures over to these,
>>>>> fixing the latent issues.
>>>>>
>>>>> I wasn't able to figure my way around powerpc and s390, so I have not
>>>>
>>>> I think 2 later patches have moved the guest_enter/exit a bit out.
>>>> Does this make the s390 code clearer?
>>>
>>> Yes; that's much simpler to follow!
>>>
>>> One major thing I wasn't sure about for s390 is the sequence:
>>>
>>> 	guest_enter_irqoff();	// Enters an RCU EQS
>>> 	...
>>> 	local_irq_enable();
>>> 	...
>>> 	sie64a(...);
>>> 	...
>>> 	local_irq_disable();
>>> 	...
>>> 	guest_exit_irqoff();	// Exits an RCU EQS
>>>
>>> ... since if an IRQ is taken between local_irq_{enable,disable}(), RCU won't be
>>> watching, and I couldn't spot whether your regular IRQ entry logic would wake
>>> RCU in this case, or whether there was something else I'm missing that saves
>>> you here.
>>>
>>> For other architectures, including x86 and arm64, we enter the guest with IRQs
>>> masked and return from the guest with IRQs masked, and don't actually take IRQs
>>> until we unmask them in the host, after the guest_exit_*() logic has woken RCU
>>> and so on.
>>>
>>> I wasn't able to find documentation on the semantics of SIE, so I couldn't spot
>>> whether the local_irq_{enable,disable}() calls were necessary, or could be
>>> removed.
>>
>> We run the SIE instruction with interrupts enabled. SIE is interruptible.
>> The disable/enable pairs are just because  guest_enter/exit_irqoff() require them.
> 
> What I was trying to figure out was when an interrupt is taken between
> guest_enter_irqoff() and guest_exit_irqoff(), where is RCU woken? I couldn't
> spot that in the s390 entry code (probably simply because I'm not familiar with
> it), and so AFAICT that means IRQ code could run without RCU watching, which
> would cause things to explode.
> 
> On other architectures that problem is avoided because IRQs asserted during the
> guest cause a specific guest exit rather than a regular IRQ exception, and the
> HW enables/disables IRQs when entering/exiting the guest, so the host can leave
> IRQs masked across guest_enter_irqoff()..guest_exit_irqoff().
> 
> Am I right in understanding that SIE itself won't enable (host) interrupts
> while running the guest, and so it *needs* to be run with interrupts already
> enabled?

yes

> 
>> One thing to be aware of: in our entry.S - after an interrupt - we leave SIE by
>> setting the return address of the interrupt after the sie instruction so that we
>> get back into this __vcpu_run loop to check for signals and so.
> 
> Just to check, that's after the IRQ handler runs, right?

and yes.
