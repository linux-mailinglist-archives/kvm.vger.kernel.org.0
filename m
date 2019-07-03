Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD8A5EADC
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2019 19:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727034AbfGCRvG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jul 2019 13:51:06 -0400
Received: from esa2.hc3370-68.iphmx.com ([216.71.145.153]:10066 "EHLO
        esa2.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbfGCRvG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jul 2019 13:51:06 -0400
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Jul 2019 13:51:05 EDT
Authentication-Results: esa2.hc3370-68.iphmx.com; dkim=none (message not signed) header.i=none; spf=None smtp.pra=andrew.cooper3@citrix.com; spf=Pass smtp.mailfrom=Andrew.Cooper3@citrix.com; spf=None smtp.helo=postmaster@mail.citrix.com
Received-SPF: None (esa2.hc3370-68.iphmx.com: no sender
  authenticity information available from domain of
  andrew.cooper3@citrix.com) identity=pra;
  client-ip=162.221.158.21; receiver=esa2.hc3370-68.iphmx.com;
  envelope-from="Andrew.Cooper3@citrix.com";
  x-sender="andrew.cooper3@citrix.com";
  x-conformance=sidf_compatible
Received-SPF: Pass (esa2.hc3370-68.iphmx.com: domain of
  Andrew.Cooper3@citrix.com designates 162.221.158.21 as
  permitted sender) identity=mailfrom;
  client-ip=162.221.158.21; receiver=esa2.hc3370-68.iphmx.com;
  envelope-from="Andrew.Cooper3@citrix.com";
  x-sender="Andrew.Cooper3@citrix.com";
  x-conformance=sidf_compatible; x-record-type="v=spf1";
  x-record-text="v=spf1 ip4:209.167.231.154 ip4:178.63.86.133
  ip4:195.66.111.40/30 ip4:85.115.9.32/28 ip4:199.102.83.4
  ip4:192.28.146.160 ip4:192.28.146.107 ip4:216.52.6.88
  ip4:216.52.6.188 ip4:162.221.158.21 ip4:162.221.156.83 ~all"
Received-SPF: None (esa2.hc3370-68.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@mail.citrix.com) identity=helo;
  client-ip=162.221.158.21; receiver=esa2.hc3370-68.iphmx.com;
  envelope-from="Andrew.Cooper3@citrix.com";
  x-sender="postmaster@mail.citrix.com";
  x-conformance=sidf_compatible
IronPort-SDR: rE1PPiUYLx+553PsS26Oksn7RexOFKwbp8ae46DhGB/64c3y1B8aHgZXiE5SGq0Sa9UxFpVlt+
 ZL/6ZbYqHeMlMEgoRzBmrALe/TKpJWXvXTpxmgqCCESMqSpp5w0X44Cf0OwaVFjqLZYNLA0Jbq
 2NKHealGMif/ysgufrg943fsEX4QlejwJ6OyjEhnJtOjUKjrtL1bJAPtzWo28FZOG8LkOlynZh
 77t6DNBpk49LLY7g5mUU8wqd+T8ymlTKYnuD76xnUKLBc0yn+8s/WYsfT6bJ633QmHXWm6xBm/
 mPw=
X-SBRS: 2.7
X-MesageID: 2556619
X-Ironport-Server: esa2.hc3370-68.iphmx.com
X-Remote-IP: 162.221.158.21
X-Policy: $RELAYED
X-IronPort-AV: E=Sophos;i="5.63,446,1557201600"; 
   d="scan'208";a="2556619"
Subject: Re: [Xen-devel] [PATCH v2 4/9] x86/mm/tlb: Flush remote and local
 TLBs concurrently
To:     Nadav Amit <namit@vmware.com>, Juergen Gross <jgross@suse.com>
CC:     Sasha Levin <sashal@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        kvm list <kvm@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@kernel.org>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        xen-devel <xen-devel@lists.xenproject.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
References: <20190702235151.4377-1-namit@vmware.com>
 <20190702235151.4377-5-namit@vmware.com>
 <d89e2b57-8682-153e-33d8-98084e9983d6@suse.com>
 <A4BC0EDE-71F0-455D-964A-7250D005FB56@vmware.com>
From:   Andrew Cooper <andrew.cooper3@citrix.com>
Openpgp: preference=signencrypt
Autocrypt: addr=andrew.cooper3@citrix.com; prefer-encrypt=mutual; keydata=
 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
 6+ahAA==
Message-ID: <6038042c-917f-d361-5d79-f0205152fe00@citrix.com>
Date:   Wed, 3 Jul 2019 18:43:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <A4BC0EDE-71F0-455D-964A-7250D005FB56@vmware.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-ClientProxiedBy: AMSPEX02CAS01.citrite.net (10.69.22.112) To
 AMSPEX02CL02.citrite.net (10.69.22.126)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/07/2019 18:02, Nadav Amit wrote:
>> On Jul 3, 2019, at 7:04 AM, Juergen Gross <jgross@suse.com> wrote:
>>
>> On 03.07.19 01:51, Nadav Amit wrote:
>>> To improve TLB shootdown performance, flush the remote and local TLBs
>>> concurrently. Introduce flush_tlb_multi() that does so. Introduce
>>> paravirtual versions of flush_tlb_multi() for KVM, Xen and hyper-v (Xen
>>> and hyper-v are only compile-tested).
>>> While the updated smp infrastructure is capable of running a function on
>>> a single local core, it is not optimized for this case. The multiple
>>> function calls and the indirect branch introduce some overhead, and
>>> might make local TLB flushes slower than they were before the recent
>>> changes.
>>> Before calling the SMP infrastructure, check if only a local TLB flush
>>> is needed to restore the lost performance in this common case. This
>>> requires to check mm_cpumask() one more time, but unless this mask is
>>> updated very frequently, this should impact performance negatively.
>>> Cc: "K. Y. Srinivasan" <kys@microsoft.com>
>>> Cc: Haiyang Zhang <haiyangz@microsoft.com>
>>> Cc: Stephen Hemminger <sthemmin@microsoft.com>
>>> Cc: Sasha Levin <sashal@kernel.org>
>>> Cc: Thomas Gleixner <tglx@linutronix.de>
>>> Cc: Ingo Molnar <mingo@redhat.com>
>>> Cc: Borislav Petkov <bp@alien8.de>
>>> Cc: x86@kernel.org
>>> Cc: Juergen Gross <jgross@suse.com>
>>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>>> Cc: Dave Hansen <dave.hansen@linux.intel.com>
>>> Cc: Andy Lutomirski <luto@kernel.org>
>>> Cc: Peter Zijlstra <peterz@infradead.org>
>>> Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
>>> Cc: linux-hyperv@vger.kernel.org
>>> Cc: linux-kernel@vger.kernel.org
>>> Cc: virtualization@lists.linux-foundation.org
>>> Cc: kvm@vger.kernel.org
>>> Cc: xen-devel@lists.xenproject.org
>>> Signed-off-by: Nadav Amit <namit@vmware.com>
>>> ---
>>>  arch/x86/hyperv/mmu.c                 | 13 +++---
>>>  arch/x86/include/asm/paravirt.h       |  6 +--
>>>  arch/x86/include/asm/paravirt_types.h |  4 +-
>>>  arch/x86/include/asm/tlbflush.h       |  9 ++--
>>>  arch/x86/include/asm/trace/hyperv.h   |  2 +-
>>>  arch/x86/kernel/kvm.c                 | 11 +++--
>>>  arch/x86/kernel/paravirt.c            |  2 +-
>>>  arch/x86/mm/tlb.c                     | 65 ++++++++++++++++++++-------
>>>  arch/x86/xen/mmu_pv.c                 | 20 ++++++---
>>>  include/trace/events/xen.h            |  2 +-
>>>  10 files changed, 91 insertions(+), 43 deletions(-)
>> ...
>>
>>> diff --git a/arch/x86/xen/mmu_pv.c b/arch/x86/xen/mmu_pv.c
>>> index beb44e22afdf..19e481e6e904 100644
>>> --- a/arch/x86/xen/mmu_pv.c
>>> +++ b/arch/x86/xen/mmu_pv.c
>>> @@ -1355,8 +1355,8 @@ static void xen_flush_tlb_one_user(unsigned long addr)
>>>  	preempt_enable();
>>>  }
>>>  -static void xen_flush_tlb_others(const struct cpumask *cpus,
>>> -				 const struct flush_tlb_info *info)
>>> +static void xen_flush_tlb_multi(const struct cpumask *cpus,
>>> +				const struct flush_tlb_info *info)
>>>  {
>>>  	struct {
>>>  		struct mmuext_op op;
>>> @@ -1366,7 +1366,7 @@ static void xen_flush_tlb_others(const struct cpumask *cpus,
>>>  	const size_t mc_entry_size = sizeof(args->op) +
>>>  		sizeof(args->mask[0]) * BITS_TO_LONGS(num_possible_cpus());
>>>  -	trace_xen_mmu_flush_tlb_others(cpus, info->mm, info->start, info->end);
>>> +	trace_xen_mmu_flush_tlb_multi(cpus, info->mm, info->start, info->end);
>>>    	if (cpumask_empty(cpus))
>>>  		return;		/* nothing to do */
>>> @@ -1375,9 +1375,17 @@ static void xen_flush_tlb_others(const struct cpumask *cpus,
>>>  	args = mcs.args;
>>>  	args->op.arg2.vcpumask = to_cpumask(args->mask);
>>>  -	/* Remove us, and any offline CPUS. */
>>> +	/* Flush locally if needed and remove us */
>>> +	if (cpumask_test_cpu(smp_processor_id(), to_cpumask(args->mask))) {
>>> +		local_irq_disable();
>>> +		flush_tlb_func_local(info);
>> I think this isn't the correct function for PV guests.
>>
>> In fact it should be much easier: just don't clear the own cpu from the
>> mask, that's all what's needed. The hypervisor is just fine having the
>> current cpu in the mask and it will do the right thing.
> Thanks. I will do so in v3. I don’t think Hyper-V people would want to do
> the same, unfortunately, since it would induce VM-exit on TLB flushes.

Why do you believe the vmexit matters?  You're talking one anyway for
the IPI.

Intel only have virtualised self-IPI, and while AMD do have working
non-self IPIs, you still take a vmexit anyway if any destination vcpu
isn't currently running in non-root mode (IIRC).

At that point, you might as well have the hypervisor do all the hard
work via a multi-cpu shootdown/flush hypercall, rather than trying to
arrange it locally.

~Andrew
