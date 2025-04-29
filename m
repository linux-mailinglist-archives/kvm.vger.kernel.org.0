Return-Path: <kvm+bounces-44816-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BD944AA162D
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 19:34:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 086709A2DE1
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 17:28:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2A742522A4;
	Tue, 29 Apr 2025 17:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="dl5+1MRV"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C6B124A047;
	Tue, 29 Apr 2025 17:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947687; cv=none; b=Lya/z+p2Mc/kSt4iTO807Tfd7avahWjl2yOC0MDenTS32/ilsaBrgALAU9g0hClDWFmM8Ep5ZzqMI0k+29KC+1PTXNMBzoMcBYP7jybdbfxtAurs62AAgqCiYRAt+HsrZAxsC64ebnj/ZBgHBc6k51HkC2kyQ+kl6aKaP4cUyAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947687; c=relaxed/simple;
	bh=PVYVePB1lbPvKBWI8S6NDXuosqAzYQbVsfIh1jwWuVA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sHqfE4g0jqTWml/auAgjmvHzh43eo6mH2vkxi8Ioki2/vmXRMjjAQAK0cFZpvA85XiI4hPSk5jiexPKDqONtZ4BJaxqnIHmQGBQAh7v8VOFhqjmxKW3mBrmGqXUzLNFPx7MvwoGJ0uZCkLaO0JIgOCavdCo/RJzI1CfdRM99Oyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=dl5+1MRV; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [192.168.7.202] ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 53THR949509822
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Tue, 29 Apr 2025 10:27:09 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 53THR949509822
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025042001; t=1745947632;
	bh=bi2Aevh2QzYHJjU5ZT4PV0lJuEojRhQww5I9NeYJf50=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=dl5+1MRV352QgdzCN55c3h5YzJsglVUunIeznoTZvR86tIRDHDduoKYAilNdy8UVy
	 OEGai/Yt9OZDvSPgIzIhkxcj5ShG9kvXTjGlJ2zesdY1/FbO18R7e2/VTEIl7GKjaO
	 xK07wa+p3OMX38teq7q76S09I4+Yz7Pt2REmAngLro9casDIXZcpeegj2EJx1I2ig2
	 0/6ceuNx+bbiqR41148AXDkYgIeIfISQrjLKScf+66Hnx0A5RHGDmj07zcwLcWBYtD
	 nuOvbzvclQP9Rcm7KE8EOSlR4rY0H6lR8tUdU/bUWP3YHocv+vO11bc0h3sHbn5MNb
	 tpVmjIEc6McWQ==
Message-ID: <7df3c16b-9353-4f30-a13b-1f0eb8563e69@zytor.com>
Date: Tue, 29 Apr 2025 10:27:09 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 01/15] x86/msr: Add missing includes of <asm/msr.h>
To: =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-hyperv@vger.kernel.org,
        virtualization@lists.linux.dev, linux-pm@vger.kernel.org,
        linux-edac@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-acpi@vger.kernel.org, linux-hwmon@vger.kernel.org,
        Netdev <netdev@vger.kernel.org>, platform-driver-x86@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        acme@kernel.org, jgross@suse.com, andrew.cooper3@citrix.com,
        peterz@infradead.org, namhyung@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@kernel.org,
        irogers@google.com, adrian.hunter@intel.com, kan.liang@linux.intel.com,
        wei.liu@kernel.org, ajay.kaher@broadcom.com,
        bcm-kernel-feedback-list@broadcom.com, tony.luck@intel.com,
        pbonzini@redhat.com, vkuznets@redhat.com, seanjc@google.com,
        luto@kernel.org, boris.ostrovsky@oracle.com, kys@microsoft.com,
        haiyangz@microsoft.com, decui@microsoft.com,
        dapeng1.mi@linux.intel.com
References: <20250427092027.1598740-1-xin@zytor.com>
 <20250427092027.1598740-2-xin@zytor.com>
 <a1917b37-e41e-d303-749b-4007cda01605@linux.intel.com>
Content-Language: en-US
From: Xin Li <xin@zytor.com>
Autocrypt: addr=xin@zytor.com; keydata=
 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
 l75w1xInsg==
In-Reply-To: <a1917b37-e41e-d303-749b-4007cda01605@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 4/29/2025 2:45 AM, Ilpo Järvinen wrote:
> On Sun, 27 Apr 2025, Xin Li (Intel) wrote:
> 
>> For some reason, there are some TSC-related functions in the MSR
>> header even though there is a tsc.h header.
>>
>> To facilitate the relocation of rdtsc{,_ordered}() from <asm/msr.h>
>> to <asm/tsc.h> and to eventually eliminate the inclusion of
>> <asm/msr.h> in <asm/tsc.h>, add <asm/msr.h> to the source files that
>> reference definitions from <asm/msr.h>.
>>
>> Signed-off-by: Xin Li (Intel) <xin@zytor.com>
>> Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
>> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
>> ---
>>
>> Change in v4:
>> *) Add missing includes in a different patch (Ilpo Järvinen).
>> *) Add all necessary direct inclusions for msr.h (Ilpo Järvinen).
>>
>> Change in v3:
>> * Add a problem statement to the changelog (Dave Hansen).
>> ---
>>   arch/x86/events/msr.c                                         | 3 +++
>>   arch/x86/events/perf_event.h                                  | 1 +
>>   arch/x86/events/probe.c                                       | 2 ++
> 
> Under arch/x86/events/ a few files seem to be missing the include?
> 
>>   arch/x86/hyperv/ivm.c                                         | 1 +
> 
> Also under hyperv/ not all files are covered but I'm a bit hesitant to
> suggest a change there since I'm not sure if they (hypervisors) do
> something special w.r.t. msr.
> 
>>   arch/x86/include/asm/fred.h                                   | 1 +
>>   arch/x86/include/asm/microcode.h                              | 2 ++
>>   arch/x86/include/asm/mshyperv.h                               | 1 +
>>   arch/x86/include/asm/msr.h                                    | 1 +
>>   arch/x86/include/asm/suspend_32.h                             | 1 +
>>   arch/x86/include/asm/suspend_64.h                             | 1 +
>>   arch/x86/include/asm/switch_to.h                              | 2 ++
> 
> arch/x86/kernel/acpi/ ?
> acrh/x86/kernel/cet.c ?
> ...
> 
> There seem to be quite many under arch/x86/ that still don't have it, I
> didn't list them all as there were so many after this point.
> 
> But that's up to x86 maintainers how throughout they want you to be.
> 
> This command may be helpful to exclude the files which already have the
> include so you can focus on the ones that may still be missing it:
> 
> git grep -l -e rdmsr -e wrmsr | grep -v -f <(git grep -l -e 'asm/msr\.h')
> 
>>   arch/x86/kernel/cpu/resctrl/pseudo_lock.c                     | 1 +
>>   arch/x86/kernel/fpu/xstate.h                                  | 1 +
>>   arch/x86/kernel/hpet.c                                        | 1 +
>>   arch/x86/kernel/process_64.c                                  | 1 +
>>   arch/x86/kernel/trace_clock.c                                 | 2 +-
>>   arch/x86/kernel/tsc_sync.c                                    | 1 +
>>   arch/x86/lib/kaslr.c                                          | 2 +-
>>   arch/x86/mm/mem_encrypt_identity.c                            | 1 +
>>   arch/x86/realmode/init.c                                      | 1 +
>>   drivers/acpi/acpi_extlog.c                                    | 1 +
>>   drivers/acpi/processor_perflib.c                              | 1 +
>>   drivers/acpi/processor_throttling.c                           | 3 ++-
>>   drivers/char/agp/nvidia-agp.c                                 | 1 +
>>   drivers/cpufreq/amd-pstate-ut.c                               | 2 ++
>>   drivers/crypto/ccp/sev-dev.c                                  | 1 +
>>   drivers/edac/amd64_edac.c                                     | 1 +
>>   drivers/edac/ie31200_edac.c                                   | 1 +
>>   drivers/edac/mce_amd.c                                        | 1 +
>>   drivers/hwmon/hwmon-vid.c                                     | 4 ++++
>>   drivers/idle/intel_idle.c                                     | 1 +
>>   drivers/misc/cs5535-mfgpt.c                                   | 1 +
>>   drivers/net/vmxnet3/vmxnet3_drv.c                             | 4 ++++
>>   drivers/platform/x86/intel/ifs/core.c                         | 1 +
>>   drivers/platform/x86/intel/ifs/load.c                         | 1 +
>>   drivers/platform/x86/intel/ifs/runtest.c                      | 1 +
>>   drivers/platform/x86/intel/pmc/cnp.c                          | 1 +
>>   drivers/platform/x86/intel/speed_select_if/isst_if_common.c   | 1 +
>>   drivers/platform/x86/intel/speed_select_if/isst_if_mbox_msr.c | 1 +
>>   drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c   | 1 +
>>   drivers/platform/x86/intel/turbo_max_3.c                      | 1 +
>>   .../platform/x86/intel/uncore-frequency/uncore-frequency.c    | 1 +
>>   drivers/powercap/intel_rapl_common.c                          | 1 +
>>   drivers/powercap/intel_rapl_msr.c                             | 1 +
>>   .../thermal/intel/int340x_thermal/processor_thermal_device.c  | 1 +
>>   drivers/thermal/intel/intel_tcc_cooling.c                     | 1 +
>>   drivers/thermal/intel/x86_pkg_temp_thermal.c                  | 1 +
>>   drivers/video/fbdev/geode/display_gx.c                        | 1 +
>>   drivers/video/fbdev/geode/gxfb_core.c                         | 1 +
>>   drivers/video/fbdev/geode/lxfb_ops.c                          | 1 +
> 
> Under drivers/ this looked pretty complete. Nice work.
> 
> Acked-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com> # for pdx86

Thanks a lot!


> 
> I also noticed these files might not need to include msr.h:
> 
> drivers/cpufreq/elanfreq.c
> drivers/cpufreq/sc520_freq.c
> drivers/accel/habanalabs/common/habanalabs_ioctl.c
> 
> ...so if you want, you may consider optionally adding a cleanup patch to
> remove the include from them.
> 
>> --- a/drivers/video/fbdev/geode/gxfb_core.c
>> +++ b/drivers/video/fbdev/geode/gxfb_core.c
>> @@ -30,6 +30,7 @@
>>   #include <linux/cs5535.h>
>>   
>>   #include <asm/olpc.h>
>> +#include <asm/msr.h>
> 
> In wrong order.
>>   
>>   #include "gxfb.h"
> 

I am more than happy to send v4A to address all your comments.

