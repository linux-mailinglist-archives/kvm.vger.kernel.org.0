Return-Path: <kvm+bounces-42442-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5ECE4A786E8
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 05:46:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9DA5E3AF4CD
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 03:46:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F8E72309B2;
	Wed,  2 Apr 2025 03:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="d7YoxvOk"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E71515D1;
	Wed,  2 Apr 2025 03:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743565602; cv=none; b=oYC0XExepBkL6EY+0D7MQ/ZdD2qh6IWdy9YdUxTOik+glUUKZi2wMUWstu79ciI/eURWxiC6sSu3he41C2Bb6TjGZaOwXw3LpHWYJKAWuDOraJfmHNkghfc3HyQnlK65JY4P06/yWkb9GWu3+QxMkq56sB5Ws6/gD72NK/0FuNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743565602; c=relaxed/simple;
	bh=itFb7mH56VIHh1MdibQIr63I3OMPQvhBlOjKG1lYYJA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XT2NncJzUeCjaJDVm4raPMXE7PWT70xwbH48arEZr49l3ozKa6mCZHYH7dSu8Y1S7x1KNcPp64I81trMkRHhvyBYJOCzOoh0u+fBbg6dNw+kIhEkjSc67V8p+dAp2tBcywpht1RI/7GZmdWcEWC9d4B+da4jq24TRIhCA01wxvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=d7YoxvOk; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [192.168.7.202] ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 5323jYCp4052768
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Tue, 1 Apr 2025 20:45:34 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 5323jYCp4052768
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025032001; t=1743565538;
	bh=B/0Ul12154gIBLTRQGmDrSHkQipxSmmaRYkawQNhljs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=d7YoxvOk9CIKebUmypsUBsbIGJDe0uIJODZYK5DJptXRC7jV6F3X1iHgsxaJq7z/U
	 nBC47DHx45CFSikk6yorSJmHvn/RCUzlkE0NIfP5y7UNWDRWBv91w7rT+GXmQbAe6z
	 HCcFPhy4gq4eFfyUGP1oJ31ejuLGzPZzPtgaEGzAY4WeayjxRzdkiEm1K913UJ2qFb
	 o2q11OGn9+Uc+NNdgOH1HNABy4p6gq8usi/RT27lr00ZcWFGEXHyfLPucBEl+bhIGt
	 HaLheaydO5A8cmC7yD4/mcLHEGK1M9ACDi53Kn4fWVEbhWUVQAm5iuaES3HqoGE7N5
	 7tT7gwjoWNc5Q==
Message-ID: <7a503d55-db41-42da-8133-4a3dbbd36c7e@zytor.com>
Date: Tue, 1 Apr 2025 20:45:33 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 01/15] x86/msr: Replace __wrmsr() with
 native_wrmsrl()
To: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-hyperv@vger.kernel.org, virtualization@lists.linux.dev,
        linux-edac@vger.kernel.org, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org, linux-ide@vger.kernel.org,
        linux-pm@vger.kernel.org, bpf@vger.kernel.org, llvm@lists.linux.dev,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, jgross@suse.com,
        andrew.cooper3@citrix.com, peterz@infradead.org, acme@kernel.org,
        namhyung@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@kernel.org,
        irogers@google.com, adrian.hunter@intel.com, kan.liang@linux.intel.com,
        wei.liu@kernel.org, ajay.kaher@broadcom.com,
        alexey.amakhalov@broadcom.com, bcm-kernel-feedback-list@broadcom.com,
        tony.luck@intel.com, pbonzini@redhat.com, vkuznets@redhat.com,
        seanjc@google.com, luto@kernel.org, boris.ostrovsky@oracle.com,
        kys@microsoft.com, haiyangz@microsoft.com, decui@microsoft.com,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <20250331082251.3171276-1-xin@zytor.com>
 <20250331082251.3171276-2-xin@zytor.com> <Z-pruogreCuU66wm@gmail.com>
 <9D15DE81-2E68-4FCD-A133-4963602E18C9@zytor.com> <Z-ubVFyoOzwKhI53@gmail.com>
Content-Language: en-US
From: Xin Li <xin@zytor.com>
Autocrypt: addr=xin@zytor.com; keydata=
 xsDNBGUPz1cBDACS/9yOJGojBFPxFt0OfTWuMl0uSgpwk37uRrFPTTLw4BaxhlFL0bjs6q+0
 2OfG34R+a0ZCuj5c9vggUMoOLdDyA7yPVAJU0OX6lqpg6z/kyQg3t4jvajG6aCgwSDx5Kzg5
 Rj3AXl8k2wb0jdqRB4RvaOPFiHNGgXCs5Pkux/qr0laeFIpzMKMootGa4kfURgPhRzUaM1vy
 bsMsL8vpJtGUmitrSqe5dVNBH00whLtPFM7IbzKURPUOkRRiusFAsw0a1ztCgoFczq6VfAVu
 raTye0L/VXwZd+aGi401V2tLsAHxxckRi9p3mc0jExPc60joK+aZPy6amwSCy5kAJ/AboYtY
 VmKIGKx1yx8POy6m+1lZ8C0q9b8eJ8kWPAR78PgT37FQWKYS1uAroG2wLdK7FiIEpPhCD+zH
 wlslo2ETbdKjrLIPNehQCOWrT32k8vFNEMLP5G/mmjfNj5sEf3IOKgMTMVl9AFjsINLHcxEQ
 6T8nGbX/n3msP6A36FDfdSEAEQEAAc0WWGluIExpIDx4aW5Aenl0b3IuY29tPsLBDQQTAQgA
 NxYhBIUq/WFSDTiOvUIqv2u9DlcdrjdRBQJlD89XBQkFo5qAAhsDBAsJCAcFFQgJCgsFFgID
 AQAACgkQa70OVx2uN1HUpgv/cM2fsFCQodLArMTX5nt9yqAWgA5t1srri6EgS8W3F+3Kitge
 tYTBKu6j5BXuXaX3vyfCm+zajDJN77JHuYnpcKKr13VcZi1Swv6Jx1u0II8DOmoDYLb1Q2ZW
 v83W55fOWJ2g72x/UjVJBQ0sVjAngazU3ckc0TeNQlkcpSVGa/qBIHLfZraWtdrNAQT4A1fa
 sWGuJrChBFhtKbYXbUCu9AoYmmbQnsx2EWoJy3h7OjtfFapJbPZql+no5AJ3Mk9eE5oWyLH+
 QWqtOeJM7kKvn/dBudokFSNhDUw06e7EoVPSJyUIMbYtUO7g2+Atu44G/EPP0yV0J4lRO6EA
 wYRXff7+I1jIWEHpj5EFVYO6SmBg7zF2illHEW31JAPtdDLDHYcZDfS41caEKOQIPsdzQkaQ
 oW2hchcjcMPAfyhhRzUpVHLPxLCetP8vrVhTvnaZUo0xaVYb3+wjP+D5j/3+hwblu2agPsaE
 vgVbZ8Fx3TUxUPCAdr/p73DGg57oHjgezsDNBGUPz1gBDAD4Mg7hMFRQqlzotcNSxatlAQNL
 MadLfUTFz8wUUa21LPLrHBkUwm8RujehJrzcVbPYwPXIO0uyL/F///CogMNx7Iwo6by43KOy
 g89wVFhyy237EY76j1lVfLzcMYmjBoTH95fJC/lVb5Whxil6KjSN/R/y3jfG1dPXfwAuZ/4N
 cMoOslWkfZKJeEut5aZTRepKKF54T5r49H9F7OFLyxrC/uI9UDttWqMxcWyCkHh0v1Di8176
 jjYRNTrGEfYfGxSp+3jYL3PoNceIMkqM9haXjjGl0W1B4BidK1LVYBNov0rTEzyr0a1riUrp
 Qk+6z/LHxCM9lFFXnqH7KWeToTOPQebD2B/Ah5CZlft41i8L6LOF/LCuDBuYlu/fI2nuCc8d
 m4wwtkou1Y/kIwbEsE/6RQwRXUZhzO6llfoN96Fczr/RwvPIK5SVMixqWq4QGFAyK0m/1ap4
 bhIRrdCLVQcgU4glo17vqfEaRcTW5SgX+pGs4KIPPBE5J/ABD6pBnUUAEQEAAcLA/AQYAQgA
 JhYhBIUq/WFSDTiOvUIqv2u9DlcdrjdRBQJlD89ZBQkFo5qAAhsMAAoJEGu9DlcdrjdR4C0L
 /RcjolEjoZW8VsyxWtXazQPnaRvzZ4vhmGOsCPr2BPtMlSwDzTlri8BBG1/3t/DNK4JLuwEj
 OAIE3fkkm+UG4Kjud6aNeraDI52DRVCSx6xff3bjmJsJJMb12mWglN6LjdF6K+PE+OTJUh2F
 dOhslN5C2kgl0dvUuevwMgQF3IljLmi/6APKYJHjkJpu1E6luZec/lRbetHuNFtbh3xgFIJx
 2RpgVDP4xB3f8r0I+y6ua+p7fgOjDLyoFjubRGed0Be45JJQEn7A3CSb6Xu7NYobnxfkwAGZ
 Q81a2XtvNS7Aj6NWVoOQB5KbM4yosO5+Me1V1SkX2jlnn26JPEvbV3KRFcwV5RnDxm4OQTSk
 PYbAkjBbm+tuJ/Sm+5Yp5T/BnKz21FoCS8uvTiziHj2H7Cuekn6F8EYhegONm+RVg3vikOpn
 gao85i4HwQTK9/D1wgJIQkdwWXVMZ6q/OALaBp82vQ2U9sjTyFXgDjglgh00VRAHP7u1Rcu4
 l75w1xInsg==
In-Reply-To: <Z-ubVFyoOzwKhI53@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/1/2025 12:52 AM, Ingo Molnar wrote:
> 
> * H. Peter Anvin <hpa@zytor.com> wrote:
> 
>> On March 31, 2025 3:17:30 AM PDT, Ingo Molnar <mingo@kernel.org> wrote:
>>>
>>> * Xin Li (Intel) <xin@zytor.com> wrote:
>>>
>>>> -	__wrmsr      (MSR_AMD_DBG_EXTN_CFG, val | 3ULL << 3, val >> 32);
>>>> +	native_wrmsrl(MSR_AMD_DBG_EXTN_CFG, val | 3ULL << 3);
>>>
>>> This is an improvement.
>>>
>>>> -	__wrmsr      (MSR_IA32_PQR_ASSOC, rmid_p, plr->closid);
>>>> +	native_wrmsrl(MSR_IA32_PQR_ASSOC, (u64)plr->closid << 32 | rmid_p);
>>>
>>>> -	__wrmsr      (MSR_IA32_PQR_ASSOC, rmid_p, closid_p);
>>>> +	native_wrmsrl(MSR_IA32_PQR_ASSOC, (u64)closid_p << 32 | rmid_p);
>>>
>>> This is not an improvement.
>>>
>>> Please provide a native_wrmsrl() API variant where natural [rmid_p, closid_p]
>>> high/lo parameters can be used, without the shift-uglification...
>>>
>>> Thanks,
>>>
>>> 	Ingo
>>
>> Directing this question primarily to Ingo, who is more than anyone
>> else the namespace consistency guardian:
>>
>> On the subject of msr function naming ... *msrl() has always been
>> misleading. The -l suffix usually means 32 bits; sometimes it means
>> the C type "long" (which in the kernel is used instead of
>> size_t/uintptr_t, which might end up being "fun" when 128-bit
>> architectures appear some time this century), but for a fixed 64-but
>> type we normally use -q.
> 
> Yeah, agreed - that's been bothering me for a while too. :-)
> 
>> Should we rename the *msrl() functions to *msrq() as part of this
>> overhaul?
> 
> Yeah, that's a good idea, and because talk is cheap I just implemented
> this in the tip:WIP.x86/msr branch with a couple of other cleanups in
> this area (see the shortlog & diffstat below), but the churn is high:
> 
>    144 files changed, 1034 insertions(+), 1034 deletions(-)
> 
> So this can only be done if regenerated and sent to Linus right before
> an -rc1 I think:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip WIP.x86/msr

Hi Ingo,

Is this branch public?

I wanted to rebase on it and then incooperate your review comments, but
couldn't find the branch.

Thanks!
     Xin

> 
> Thanks,
> 
> 	Ingo
> 
> =======================>
> Ingo Molnar (18):
>        x86/msr: Standardize on u64 in <asm/msr.h>
>        x86/msr: Standardize on u64 in <asm/msr-index.h>
>        x86/msr: Use u64 in rdmsrl_amd_safe() and wrmsrl_amd_safe()
>        x86/msr: Use u64 in rdmsrl_safe() and paravirt_read_pmc()
>        x86/msr: Rename 'rdmsrl()' to 'rdmsrq()'
>        x86/msr: Rename 'wrmsrl()' to 'wrmsrq()'
>        x86/msr: Rename 'rdmsrl_safe()' to 'rdmsrq_safe()'
>        x86/msr: Rename 'wrmsrl_safe()' to 'wrmsrq_safe()'
>        x86/msr: Rename 'rdmsrl_safe_on_cpu()' to 'rdmsrq_safe_on_cpu()'
>        x86/msr: Rename 'wrmsrl_safe_on_cpu()' to 'wrmsrq_safe_on_cpu()'
>        x86/msr: Rename 'rdmsrl_on_cpu()' to 'rdmsrq_on_cpu()'
>        x86/msr: Rename 'wrmsrl_on_cpu()' to 'wrmsrq_on_cpu()'
>        x86/msr: Rename 'mce_rdmsrl()' to 'mce_rdmsrq()'
>        x86/msr: Rename 'mce_wrmsrl()' to 'mce_wrmsrq()'
>        x86/msr: Rename 'rdmsrl_amd_safe()' to 'rdmsrq_amd_safe()'
>        x86/msr: Rename 'wrmsrl_amd_safe()' to 'wrmsrq_amd_safe()'
>        x86/msr: Rename 'native_wrmsrl()' to 'native_wrmsrq()'
>        x86/msr: Rename 'wrmsrl_cstar()' to 'wrmsrq_cstar()'
> 
>   arch/x86/coco/sev/core.c                           |   2 +-
>   arch/x86/events/amd/brs.c                          |   8 +-
>   arch/x86/events/amd/core.c                         |  12 +--
>   arch/x86/events/amd/ibs.c                          |  26 ++---
>   arch/x86/events/amd/lbr.c                          |  20 ++--
>   arch/x86/events/amd/power.c                        |  10 +-
>   arch/x86/events/amd/uncore.c                       |  12 +--
>   arch/x86/events/core.c                             |  42 ++++----
>   arch/x86/events/intel/core.c                       |  66 ++++++-------
>   arch/x86/events/intel/cstate.c                     |   2 +-
>   arch/x86/events/intel/ds.c                         |  10 +-
>   arch/x86/events/intel/knc.c                        |  16 +--
>   arch/x86/events/intel/lbr.c                        |  44 ++++-----
>   arch/x86/events/intel/p4.c                         |  24 ++---
>   arch/x86/events/intel/p6.c                         |  12 +--
>   arch/x86/events/intel/pt.c                         |  32 +++---
>   arch/x86/events/intel/uncore.c                     |   2 +-
>   arch/x86/events/intel/uncore_discovery.c           |  10 +-
>   arch/x86/events/intel/uncore_nhmex.c               |  70 ++++++-------
>   arch/x86/events/intel/uncore_snb.c                 |  42 ++++----
>   arch/x86/events/intel/uncore_snbep.c               |  50 +++++-----
>   arch/x86/events/msr.c                              |   2 +-
>   arch/x86/events/perf_event.h                       |  26 ++---
>   arch/x86/events/probe.c                            |   2 +-
>   arch/x86/events/rapl.c                             |   8 +-
>   arch/x86/events/zhaoxin/core.c                     |  16 +--
>   arch/x86/hyperv/hv_apic.c                          |   4 +-
>   arch/x86/hyperv/hv_init.c                          |  66 ++++++-------
>   arch/x86/hyperv/hv_spinlock.c                      |   6 +-
>   arch/x86/hyperv/ivm.c                              |   2 +-
>   arch/x86/include/asm/apic.h                        |   8 +-
>   arch/x86/include/asm/debugreg.h                    |   4 +-
>   arch/x86/include/asm/fsgsbase.h                    |   4 +-
>   arch/x86/include/asm/kvm_host.h                    |   2 +-
>   arch/x86/include/asm/microcode.h                   |   2 +-
>   arch/x86/include/asm/msr-index.h                   |  12 +--
>   arch/x86/include/asm/msr.h                         |  50 +++++-----
>   arch/x86/include/asm/paravirt.h                    |   8 +-
>   arch/x86/include/asm/spec-ctrl.h                   |   2 +-
>   arch/x86/kernel/acpi/cppc.c                        |   8 +-
>   arch/x86/kernel/amd_nb.c                           |   2 +-
>   arch/x86/kernel/apic/apic.c                        |  16 +--
>   arch/x86/kernel/apic/apic_numachip.c               |   6 +-
>   arch/x86/kernel/cet.c                              |   2 +-
>   arch/x86/kernel/cpu/amd.c                          |  28 +++---
>   arch/x86/kernel/cpu/aperfmperf.c                   |  28 +++---
>   arch/x86/kernel/cpu/bugs.c                         |  24 ++---
>   arch/x86/kernel/cpu/bus_lock.c                     |  18 ++--
>   arch/x86/kernel/cpu/common.c                       |  68 ++++++-------
>   arch/x86/kernel/cpu/feat_ctl.c                     |   4 +-
>   arch/x86/kernel/cpu/hygon.c                        |   6 +-
>   arch/x86/kernel/cpu/intel.c                        |  10 +-
>   arch/x86/kernel/cpu/intel_epb.c                    |  12 +--
>   arch/x86/kernel/cpu/mce/amd.c                      |  22 ++---
>   arch/x86/kernel/cpu/mce/core.c                     |  58 +++++------
>   arch/x86/kernel/cpu/mce/inject.c                   |  32 +++---
>   arch/x86/kernel/cpu/mce/intel.c                    |  32 +++---
>   arch/x86/kernel/cpu/mce/internal.h                 |   2 +-
>   arch/x86/kernel/cpu/microcode/amd.c                |   2 +-
>   arch/x86/kernel/cpu/microcode/intel.c              |   2 +-
>   arch/x86/kernel/cpu/mshyperv.c                     |  12 +--
>   arch/x86/kernel/cpu/resctrl/core.c                 |  10 +-
>   arch/x86/kernel/cpu/resctrl/monitor.c              |   2 +-
>   arch/x86/kernel/cpu/resctrl/pseudo_lock.c          |   2 +-
>   arch/x86/kernel/cpu/resctrl/rdtgroup.c             |   6 +-
>   arch/x86/kernel/cpu/sgx/main.c                     |   2 +-
>   arch/x86/kernel/cpu/topology.c                     |   2 +-
>   arch/x86/kernel/cpu/topology_amd.c                 |   4 +-
>   arch/x86/kernel/cpu/tsx.c                          |  20 ++--
>   arch/x86/kernel/cpu/umwait.c                       |   2 +-
>   arch/x86/kernel/fpu/core.c                         |   2 +-
>   arch/x86/kernel/fpu/xstate.c                       |  10 +-
>   arch/x86/kernel/fpu/xstate.h                       |   2 +-
>   arch/x86/kernel/fred.c                             |  20 ++--
>   arch/x86/kernel/hpet.c                             |   2 +-
>   arch/x86/kernel/kvm.c                              |  28 +++---
>   arch/x86/kernel/kvmclock.c                         |   4 +-
>   arch/x86/kernel/mmconf-fam10h_64.c                 |   8 +-
>   arch/x86/kernel/process.c                          |  16 +--
>   arch/x86/kernel/process_64.c                       |  20 ++--
>   arch/x86/kernel/reboot_fixups_32.c                 |   2 +-
>   arch/x86/kernel/shstk.c                            |  18 ++--
>   arch/x86/kernel/traps.c                            |  10 +-
>   arch/x86/kernel/tsc.c                              |   2 +-
>   arch/x86/kernel/tsc_sync.c                         |  14 +--
>   arch/x86/kvm/svm/avic.c                            |   2 +-
>   arch/x86/kvm/svm/sev.c                             |   2 +-
>   arch/x86/kvm/svm/svm.c                             |  16 +--
>   arch/x86/kvm/vmx/nested.c                          |   4 +-
>   arch/x86/kvm/vmx/pmu_intel.c                       |   4 +-
>   arch/x86/kvm/vmx/sgx.c                             |   8 +-
>   arch/x86/kvm/vmx/vmx.c                             |  66 ++++++-------
>   arch/x86/kvm/x86.c                                 |  38 ++++----
>   arch/x86/lib/insn-eval.c                           |   6 +-
>   arch/x86/lib/msr-smp.c                             |  16 +--
>   arch/x86/lib/msr.c                                 |   4 +-
>   arch/x86/mm/pat/memtype.c                          |   4 +-
>   arch/x86/mm/tlb.c                                  |   2 +-
>   arch/x86/pci/amd_bus.c                             |  10 +-
>   arch/x86/platform/olpc/olpc-xo1-rtc.c              |   6 +-
>   arch/x86/platform/olpc/olpc-xo1-sci.c              |   2 +-
>   arch/x86/power/cpu.c                               |  26 ++---
>   arch/x86/realmode/init.c                           |   2 +-
>   arch/x86/virt/svm/sev.c                            |  20 ++--
>   arch/x86/xen/suspend.c                             |   6 +-
>   drivers/acpi/acpi_extlog.c                         |   2 +-
>   drivers/acpi/acpi_lpit.c                           |   2 +-
>   drivers/cpufreq/acpi-cpufreq.c                     |   8 +-
>   drivers/cpufreq/amd-pstate-ut.c                    |   6 +-
>   drivers/cpufreq/amd-pstate.c                       |  22 ++---
>   drivers/cpufreq/amd_freq_sensitivity.c             |   2 +-
>   drivers/cpufreq/e_powersaver.c                     |   6 +-
>   drivers/cpufreq/intel_pstate.c                     | 108 ++++++++++-----------
>   drivers/cpufreq/longhaul.c                         |  24 ++---
>   drivers/cpufreq/powernow-k7.c                      |  14 +--
>   drivers/crypto/ccp/sev-dev.c                       |   2 +-
>   drivers/edac/amd64_edac.c                          |   6 +-
>   drivers/gpu/drm/i915/selftests/librapl.c           |   4 +-
>   drivers/hwmon/fam15h_power.c                       |   6 +-
>   drivers/idle/intel_idle.c                          |  34 +++----
>   drivers/mtd/nand/raw/cs553x_nand.c                 |   6 +-
>   drivers/platform/x86/intel/ifs/core.c              |   4 +-
>   drivers/platform/x86/intel/ifs/load.c              |  20 ++--
>   drivers/platform/x86/intel/ifs/runtest.c           |  16 +--
>   drivers/platform/x86/intel/pmc/cnp.c               |   6 +-
>   drivers/platform/x86/intel/pmc/core.c              |   8 +-
>   .../x86/intel/speed_select_if/isst_if_common.c     |  18 ++--
>   .../x86/intel/speed_select_if/isst_if_mbox_msr.c   |  14 +--
>   .../x86/intel/speed_select_if/isst_tpmi_core.c     |   2 +-
>   drivers/platform/x86/intel/tpmi_power_domains.c    |   4 +-
>   drivers/platform/x86/intel/turbo_max_3.c           |   4 +-
>   .../x86/intel/uncore-frequency/uncore-frequency.c  |  10 +-
>   drivers/platform/x86/intel_ips.c                   |  36 +++----
>   drivers/powercap/intel_rapl_msr.c                  |   6 +-
>   .../int340x_thermal/processor_thermal_device.c     |   2 +-
>   drivers/thermal/intel/intel_hfi.c                  |  14 +--
>   drivers/thermal/intel/intel_powerclamp.c           |   4 +-
>   drivers/thermal/intel/intel_tcc_cooling.c          |   4 +-
>   drivers/thermal/intel/therm_throt.c                |  10 +-
>   drivers/video/fbdev/geode/gxfb_core.c              |   2 +-
>   drivers/video/fbdev/geode/lxfb_ops.c               |  22 ++---
>   drivers/video/fbdev/geode/suspend_gx.c             |  10 +-
>   drivers/video/fbdev/geode/video_gx.c               |  16 +--
>   include/hyperv/hvgdk_mini.h                        |   2 +-
>   144 files changed, 1034 insertions(+), 1034 deletions(-)


