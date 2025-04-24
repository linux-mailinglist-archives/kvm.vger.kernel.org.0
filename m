Return-Path: <kvm+bounces-44106-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9106EA9A715
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 10:56:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4414F7B18B5
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 08:55:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1ACD22129B;
	Thu, 24 Apr 2025 08:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JAhP6//O"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1EBD221264;
	Thu, 24 Apr 2025 08:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745484803; cv=none; b=ks8Z3wFs0x8IYC9sK4AqWcY6NzDgzlzcxExfKm6Pj9V2k5ZigoO4b0DbvcXMbY3Tux5JhcsLQbbtcb16UXoOSqnQtaIQTNlgCHmd1pMx/jxotsh5Cien4RUX4d7/mDnC5UGhspWkZZ9xvF3ZNw7tm0qQvT5ln2exwigcugrY2gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745484803; c=relaxed/simple;
	bh=t2hZm27dRntJXSA1F5KCv9d+KIKNQGiBzVbzp6VvGv0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DwdBxCDMe5VKSrXawdCpFiwGDoOZ6jw8pRuMuiuTSZLHBImlY0+JRroFP8SuhelGSQYn09BXsCT7fNPQRiySBmejLrMhOwiwYiYDj9WO5TzggEBOnuaOYS3JL7jaDS8pklDXSJJTVRKhcY+qO7CNg518OTfUe8wcsWpgdQBZls8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JAhP6//O; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745484802; x=1777020802;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=t2hZm27dRntJXSA1F5KCv9d+KIKNQGiBzVbzp6VvGv0=;
  b=JAhP6//OGHgAQW3pr5oUx06TIsT/XrvNwoXmc3XRCMjFwzDAGq9nGZts
   VLsFTJwPdHiU8nUTfTV64++l1Xd8qH2v5KcRyZGV9M/xzNsexwPcUIBJl
   /hWvnnM5sjip24uEVuGDRzinBpr7fceTXYXdEb8KjI/WydKFmnZe5ULy2
   u4snwFk1JuU7Uw9ooc9yBOKYZu4rNO/5+XlJFsFyj5WKdyUb1K71Uc+DT
   WW/gS2rIj32KBjVttS10CpJlHRJ8avozDiUcBxQ8XV5yZFzI/9FmvthcQ
   Jt6Qo5V3ld4Df4/SVK7HtBIVb8r7Nu6yhQQzXtHouHrEsfwtFe3hHAldZ
   Q==;
X-CSE-ConnectionGUID: QcRks7VNRKmL4Ru2MwjuaQ==
X-CSE-MsgGUID: XzSSvQY9TwS5dfdbevKfmA==
X-IronPort-AV: E=McAfee;i="6700,10204,11412"; a="58477654"
X-IronPort-AV: E=Sophos;i="6.15,235,1739865600"; 
   d="scan'208";a="58477654"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2025 01:53:19 -0700
X-CSE-ConnectionGUID: KOncYxVFQCeB6YNE+6eqcQ==
X-CSE-MsgGUID: ju8qnH2pQOOyrTYpZtcVtw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,235,1739865600"; 
   d="scan'208";a="163535709"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.128]) ([10.124.245.128])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2025 01:53:14 -0700
Message-ID: <27175b8e-144d-42cb-b149-04031e9aa698@linux.intel.com>
Date: Thu, 24 Apr 2025 16:53:11 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: kvm guests crash when running "perf kvm top"
To: Seth Forshee <sforshee@kernel.org>, Peter Zijlstra
 <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: x86@kernel.org, linux-perf-users@vger.kernel.org, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <Z_VUswFkWiTYI0eD@do-x1carbon>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <Z_VUswFkWiTYI0eD@do-x1carbon>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Is the command "perf kvm top" executed in host or guest when you see gues=
t
crash? Is it easy to be reproduced? Could you please provide the detailed=

steps to reproduce the issue with 6.15-rc1 kernel?


On 4/9/2025 12:54 AM, Seth Forshee wrote:
> A colleague of mine reported kvm guest hangs when running "perf kvm top=
"
> with a 6.1 kernel. Initially it looked like the problem might be fixed
> in newer kernels, but it turned out to be perf changes which must avoid=

> triggering the issue. I was able to reproduce the guest crashes with
> 6.15-rc1 in both the host and the guest when using an older version of
> perf. A bisect of perf landed on 7b100989b4f6 "perf evlist: Remove
> __evlist__add_default", but this doesn't look to be fixing any kind of
> issue like this.
>
> This box has an Ice Lake CPU, and we can reproduce on other Ice Lakes
> but could not reproduce on another box with Broadwell. On Broadwell
> guests would crash with older kernels in the host, but this was fixed b=
y
> 971079464001 "KVM: x86/pmu: fix masking logic for
> MSR_CORE_PERF_GLOBAL_CTRL". That does not fix the issues we see on Ice
> Lake.
>
> When the guests crash we aren't getting any output on the serial
> console, but I got this from a memory dump:
>
> BUG: unable to handle page fault for address: fffffe76ffbaf00000
> BUG: unable to handle page fault for address: fffffe76ffbaf00000
> #PF: supervisor write access in kernel mode
> #PF: error_code(0x0002) - not-present page
> BUG: unable to handle page fault for address: fffffe76ffbaf00000
> #PF: supervisor write access in kernel mode
> #PF: error_code(0x0002) - not-present page
> PGD 2e044067 P4D 3ec42067 PUD 3ec41067 PMD 3ec40067 PTE ffffffffff120
> Oops: Oops: 0002 [#1] SMP NOPTI
> BUG: unable to handle page fault for address: fffffe76ffbaf00000
> #PF: supervisor write access in kernel mode
> #PF: error_code(0x0002) - not-present page
> PGD 2e044067 P4D 3ec42067 PUD 3ec41067 PMD 3ec40067 PTE ffffffffff120
> Oops: Oops: 0002 [#2] SMP NOPTI
> CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 6.15.0-rc1 #3 VOLUNTAR=
Y
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009)/Incus, BIOS unknown =
02/02/2022
> BUG: unable to handle page fault for address: fffffe76ffbaf00000
> #PF: supervisor write access in kernel mode
> #PF: error_code(0x0002) - not-present page
> PGD 2e044067 P4D 3ec42067 PUD 3ec41067 PMD 3ec40067 PTE ffffffffff120
> Oops: Oops: 0002 [#3] SMP NOPTI
> CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 6.15.0-rc1 #3 VOLUNTAR=
Y
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009)/Incus, BIOS unknown =
02/02/2022
>
> We got something different though from an ubuntu VM running their 6.8
> kernel:
>
> BUG: kernel NULL pointer dereference, address: 000000000000002828
> BUG: kernel NULL pointer dereference, address: 000000000000002828
> #PF: supervisor read access in kernel mode
> #PF: error_code(0x0000) - not-present page
> PGD 10336a067 P4D 0=20
> Oops: 0000 [#1] PREEMPT SMP NOPTI
> BUG: kernel NULL pointer dereference, address: 000000000000002828
> #PF: supervisor read access in kernel mode
> #PF: error_code(0x0000) - not-present page
> PGD 10336a067 P4D 0=20
> Oops: 0000 [#2] PREEMPT SMP NOPTI
> BUG: kernel NULL pointer dereference, address: 000000000000002828
> #PF: supervisor read access in kernel mode
> #PF: error_code(0x0000) - not-present page
> PGD 10336a067 P4D 0=20
> Oops: 0000 [#3] PREEMPT SMP NOPTI
> CPU: 1 PID: 0 Comm: swapper/1 Not tainted 6.8.0-56-generic #58-Ubuntu
> BUG: kernel NULL pointer dereference, address: 000000000000002828
> #PF: supervisor read access in kernel mode
> #PF: error_code(0x0000) - not-present page
> PGD 10336a067 P4D 0=20
> Oops: 0000 [#4] PREEMPT SMP NOPTI
> CPU: 1 PID: 0 Comm: swapper/1 Not tainted 6.8.0-56-generic #58-Ubuntu
> BUG: kernel NULL pointer dereference, address: 000000000000002828
> #PF: supervisor read access in kernel mode
> #PF: error_code(0x0000) - not-present page
> PGD 10336a067 P4D 0=20
> Oops: 0000 [#5] PREEMPT SMP NOPTI
> CPU: 1 PID: 0 Comm: swapper/1 Not tainted 6.8.0-56-generic #58-Ubuntu
> RIP: 0010:__sprint_symbol.isra.0+0x6/0x120
> Code: ff e8 0e 9d 00 01 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 90 90=
 90 90 90 90 90 90 90 90 90 90 90 90 90 90 0f 1f 44 00 00 55 <48> 89 e5 4=
1 57 49 89 f7 41 56 4c 63 f2 4c 8d 45 b8 48 8d 55 c0 41
> RSP: 0018:ff25e52d000e6ff8 EFLAGS: 00000046
> BUG: #DF stack guard page was hit at 0000000040b441e1 (stack is 0000000=
0a1788787..000000008e7f4216)
> BUG: #DF stack guard page was hit at 000000002fed44fb (stack is 0000000=
0a1788787..000000008e7f4216)
> BUG: #DF stack guard page was hit at 000000002fed44fb (stack is 0000000=
0a1788787..000000008e7f4216)
> BUG: #DF stack guard page was hit at 000000002fed44fb (stack is 0000000=
0a1788787..000000008e7f4216)
> BUG: #DF stack guard page was hit at 000000002fed44fb (stack is 0000000=
0a1788787..000000008e7f4216)
> BUG: #DF stack guard page was hit at 000000002fed44fb (stack is 0000000=
0a1788787..000000008e7f4216)
> BUG: #DF stack guard page was hit at 000000002fed44fb (stack is 0000000=
0a1788787..000000008e7f4216)
> BUG: #DF stack guard page was hit at 000000002fed44fb (stack is 0000000=
0a1788787..000000008e7f4216)
> BUG: #DF stack guard page was hit at 000000002fed44fb (stack is 0000000=
0a1788787..000000008e7f4216)
> BUG: #DF stack guard page was hit at 000000002fed44fb (stack is 0000000=
0a1788787..000000008e7f4216)
> BUG: #DF stack guard page was hit at 000000002fed44fb (stack is 0000000=
0a1788787..000000008e7f4216)
> BUG: #DF stack guard page was hit at 000000002fed44fb (stack is 0000000=
0a1788787..000000008e7f4216)
> BUG: #DF stack guard page was hit at 000000002fed44fb (stack is 0000000=
0a1788787..000000008e7f4216)
> BUG: #DF stack guard page was hit at 000000002fed44fb (stack is 0000000=
0a1788787..000000008e7f4216)
> BUG: #DF stack guard page was hit at 000000002fed44fb (stack is 0000000=
0a1788787..000000008e7f4216)
> BUG: #DF stack guard page was hit at 000000002fed44fb (stack is 0000000=
0a1788787..000000008e7f4216)
> BUG: #DF stack guard page was hit at 000000002fed44fb (stack is 0000000=
0a1788787..000000008e7f4216)
> BUG: #DF stack guard page was hit at 000000002fed44fb (stack is 0000000=
0a1788787..000000008e7f4216)
> BUG: #DF stack guard page was hit at 000000002fed44fb (stack is 0000000=
0a1788787..000000008e7f4216)
> BUG: #DF stack guard page was hit at 000000002fed44fb (stack is 0000000=
0a1788787..000000008e7f4216)
> BUG: #DF stack guard page was hit at 000000002fed44fb (stack is 0000000=
0a1788787..000000008e7f4216)
> BUG: #DF stack guard page was hit at 000000002fed44fb (stack is 0000000=
0a1788787..000000008e7f4216)
> BUG: #DF stack guard page was hit at 000000002fed44fb (stack is 0000000=
0a1788787..000000008e7f4216)
> BUG: #DF stack guard page was hit at 000000002fed44fb (stack is 0000000=
0a1788787..000000008e7f4216)
> BUG: #DF stack guard page was hit at 000000002fed44fb (stack is 0000000=
0a1788787..000000008e7f4216)
> BUG: #DF stack guard page was hit at 000000002fed44fb (stack is 0000000=
0a1788787..000000008e7f4216)
> BUG: #DF stack guard page was hit at 000000002fed44fb (stack is 0000000=
0a1788787..000000008e7f4216)
>
> CPU information from one of the boxes where we see this:
>
> processor	: 0
> vendor_id	: GenuineIntel
> cpu family	: 6
> model		: 106
> model name	: Intel(R) Xeon(R) Gold 5318Y CPU @ 2.10GHz
> stepping	: 6
> microcode	: 0xd0003f5
> cpu MHz		: 800.000
> cache size	: 36864 KB
> physical id	: 0
> siblings	: 44
> core id		: 0
> cpu cores	: 22
> apicid		: 0
> initial apicid	: 0
> fpu		: yes
> fpu_exception	: yes
> cpuid level	: 27
> wp		: yes
> flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov =
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx pdpe=
1gb rdtscp lm constant_tsc art arch_perfmon pebs bts rep_good nopl xtopol=
ogy nonstop_tsc cpuid aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx =
smx est tm2 ssse3 sdbg fma cx16 xtpr pdcm pcid dca sse4_1 sse4_2 x2apic m=
ovbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm abm 3dno=
wprefetch cpuid_fault epb cat_l3 intel_ppin ssbd mba ibrs ibpb stibp ibrs=
_enhanced tpr_shadow flexpriority ept vpid ept_ad fsgsbase tsc_adjust bmi=
1 avx2 smep bmi2 erms invpcid cqm rdt_a avx512f avx512dq rdseed adx smap =
avx512ifma clflushopt clwb intel_pt avx512cd sha_ni avx512bw avx512vl xsa=
veopt xsavec xgetbv1 xsaves cqm_llc cqm_occup_llc cqm_mbm_total cqm_mbm_l=
ocal split_lock_detect wbnoinvd dtherm ida arat pln pts hwp hwp_act_windo=
w hwp_epp hwp_pkg_req vnmi avx512vbmi umip pku ospke avx512_vbmi2 gfni va=
es vpclmulqdq avx512_vnni avx512_bitalg avx512_vpopcntdq la57 rdpid fsrm =
md_clear pconfig flush_l1d arch_capabilities
> vmx flags	: vnmi preemption_timer posted_intr invvpid ept_x_only ept_ad=
 ept_1gb ept_5level flexpriority apicv tsc_offset vtpr mtf vapic ept vpid=
 unrestricted_guest vapic_reg vid ple shadow_vmcs pml ept_violation_ve ep=
t_mode_based_exec tsc_scaling
> bugs		: spectre_v1 spectre_v2 spec_store_bypass swapgs mmio_stale_data =
eibrs_pbrsb gds bhi spectre_v2_user
> bogomips	: 4000.00
> clflush size	: 64
> cache_alignment	: 64
> address sizes	: 46 bits physical, 57 bits virtual
> power management:
>
> Let me know if I can provide any additional information or testing.
>
> Thanks,
> Seth
>

