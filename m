Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B7BE79FD42
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 09:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233798AbjINHcC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 03:32:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbjINHcB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 03:32:01 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C8F3F3
        for <kvm@vger.kernel.org>; Thu, 14 Sep 2023 00:31:57 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id a640c23a62f3a-9ada6b0649fso89059766b.1
        for <kvm@vger.kernel.org>; Thu, 14 Sep 2023 00:31:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694676716; x=1695281516; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7k+nvi3cHu0PqyOJuYcDS2NSzchwTyBb049vuILD9VM=;
        b=Hmt9/RTbnC5/VT6wj9Jexz+rT9wjr6pfnjEl5MRG13fmC6le6X5DvFRs34Jkm3t0Qy
         GE+AvL/u8SCZtnY9Shay4nHbIKdfDktA9hbWsmCobSHZL2hpB83zdpMfXIQ/zeSWyE1a
         iMtP3GAUGV2LfzCuSMOiU20vdr+4chNABWau6ur2ZecwE1WFMS1O/6Z7N6StX7lOaHg+
         JoMIlnG/rF+169rHQf9R64IGs2nQFY3mQp26Od7UogYO9hdH+5264/EqfoecK8t9B41P
         /uf9kCejw7bRHoia8bfr61uZ+CclwPSelX54VokmbZd3jiYS6rmEW0F6pozT64YTJsgA
         Qrtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694676716; x=1695281516;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7k+nvi3cHu0PqyOJuYcDS2NSzchwTyBb049vuILD9VM=;
        b=lsmo1F53O3avp2m23x6wwxdXb7lgtsgW7GhcScFz3Rr4mVIOPsAWliyLnDN+kEoNTl
         ij58noAD9yxWE3dnUr8LTbLnUWvjeHfzcUn3XG9ObGgP6nFRW/rSQIJjf2jt3imht1GY
         V5c5UulfkPZNmciGZZjtq2+ODhns+Y9SqjwTHNVzlxraAkLubCe26rnIY2S/r4AYAvnc
         aOoFBjNJfs8/cFhTvsrlpO+fSLxlzQfj/dwcqleq2b1m76aKYxrNtU8hA1UuZj5j+3fC
         RhBpnrxtgShwME/soSPEEP4EATCVDGRPjjmZSsoxwu2KJwG9xBTTWFyzJA4GytlNwFno
         SexQ==
X-Gm-Message-State: AOJu0YwWgwzcl2rU8VMe0nPvIDvRaTaJkGQzDkgIxpIknUL0Y5V5Ursp
        o7RMw3UtGFOLgIBZmtaIIo9eDw==
X-Google-Smtp-Source: AGHT+IHfvUon/ApI28i2lY7/HYjaBek8ki5O6ZArTm52IqeebG9moB3kdv1BU1xGPFo6ZAHQgM5iEA==
X-Received: by 2002:a17:907:2ccb:b0:9a2:292d:ea63 with SMTP id hg11-20020a1709072ccb00b009a2292dea63mr3933017ejc.37.1694676715688;
        Thu, 14 Sep 2023 00:31:55 -0700 (PDT)
Received: from [192.168.69.115] (sem44-h01-176-172-56-29.dsl.sta.abo.bbox.fr. [176.172.56.29])
        by smtp.gmail.com with ESMTPSA id x11-20020a170906148b00b0098e78ff1a87sm590819ejc.120.2023.09.14.00.31.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Sep 2023 00:31:55 -0700 (PDT)
Message-ID: <b6f8be4e-2c47-95ec-c29c-dcca67d882ae@linaro.org>
Date:   Thu, 14 Sep 2023 09:31:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH v4 03/21] softmmu: Fix CPUSTATE.nr_cores' calculation
Content-Language: en-US
To:     Zhao Liu <zhao1.liu@linux.intel.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Zhenyu Wang <zhenyu.z.wang@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Babu Moger <babu.moger@amd.com>,
        Zhao Liu <zhao1.liu@intel.com>,
        Zhuocheng Ding <zhuocheng.ding@intel.com>
References: <20230914072159.1177582-1-zhao1.liu@linux.intel.com>
 <20230914072159.1177582-4-zhao1.liu@linux.intel.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20230914072159.1177582-4-zhao1.liu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 14/9/23 09:21, Zhao Liu wrote:
> From: Zhuocheng Ding <zhuocheng.ding@intel.com>
> 
>  From CPUState.nr_cores' comment, it represents "number of cores within
> this CPU package".
> 
> After 003f230e37d7 ("machine: Tweak the order of topology members in
> struct CpuTopology"), the meaning of smp.cores changed to "the number of
> cores in one die", but this commit missed to change CPUState.nr_cores'
> calculation, so that CPUState.nr_cores became wrong and now it
> misses to consider numbers of clusters and dies.
> 
> At present, only i386 is using CPUState.nr_cores.
> 
> But as for i386, which supports die level, the uses of CPUState.nr_cores
> are very confusing:
> 
> Early uses are based on the meaning of "cores per package" (before die
> is introduced into i386), and later uses are based on "cores per die"
> (after die's introduction).
> 
> This difference is due to that commit a94e1428991f ("target/i386: Add
> CPUID.1F generation support for multi-dies PCMachine") misunderstood
> that CPUState.nr_cores means "cores per die" when calculated
> CPUID.1FH.01H:EBX. After that, the changes in i386 all followed this
> wrong understanding.
> 
> With the influence of 003f230e37d7 and a94e1428991f, for i386 currently
> the result of CPUState.nr_cores is "cores per die", thus the original
> uses of CPUState.cores based on the meaning of "cores per package" are
> wrong when multiple dies exist:
> 1. In cpu_x86_cpuid() of target/i386/cpu.c, CPUID.01H:EBX[bits 23:16] is
>     incorrect because it expects "cpus per package" but now the
>     result is "cpus per die".
> 2. In cpu_x86_cpuid() of target/i386/cpu.c, for all leaves of CPUID.04H:
>     EAX[bits 31:26] is incorrect because they expect "cpus per package"
>     but now the result is "cpus per die". The error not only impacts the
>     EAX calculation in cache_info_passthrough case, but also impacts other
>     cases of setting cache topology for Intel CPU according to cpu
>     topology (specifically, the incoming parameter "num_cores" expects
>     "cores per package" in encode_cache_cpuid4()).
> 3. In cpu_x86_cpuid() of target/i386/cpu.c, CPUID.0BH.01H:EBX[bits
>     15:00] is incorrect because the EBX of 0BH.01H (core level) expects
>     "cpus per package", which may be different with 1FH.01H (The reason
>     is 1FH can support more levels. For QEMU, 1FH also supports die,
>     1FH.01H:EBX[bits 15:00] expects "cpus per die").
> 4. In cpu_x86_cpuid() of target/i386/cpu.c, when CPUID.80000001H is
>     calculated, here "cpus per package" is expected to be checked, but in
>     fact, now it checks "cpus per die". Though "cpus per die" also works
>     for this code logic, this isn't consistent with AMD's APM.
> 5. In cpu_x86_cpuid() of target/i386/cpu.c, CPUID.80000008H:ECX expects
>     "cpus per package" but it obtains "cpus per die".
> 6. In simulate_rdmsr() of target/i386/hvf/x86_emu.c, in
>     kvm_rdmsr_core_thread_count() of target/i386/kvm/kvm.c, and in
>     helper_rdmsr() of target/i386/tcg/sysemu/misc_helper.c,
>     MSR_CORE_THREAD_COUNT expects "cpus per package" and "cores per
>     package", but in these functions, it obtains "cpus per die" and
>     "cores per die".
> 
> On the other hand, these uses are correct now (they are added in/after
> a94e1428991f):
> 1. In cpu_x86_cpuid() of target/i386/cpu.c, topo_info.cores_per_die
>     meets the actual meaning of CPUState.nr_cores ("cores per die").
> 2. In cpu_x86_cpuid() of target/i386/cpu.c, vcpus_per_socket (in CPUID.
>     04H's calculation) considers number of dies, so it's correct.
> 3. In cpu_x86_cpuid() of target/i386/cpu.c, CPUID.1FH.01H:EBX[bits
>     15:00] needs "cpus per die" and it gets the correct result, and
>     CPUID.1FH.02H:EBX[bits 15:00] gets correct "cpus per package".
> 
> When CPUState.nr_cores is correctly changed to "cores per package" again
> , the above errors will be fixed without extra work, but the "currently"
> correct cases will go wrong and need special handling to pass correct
> "cpus/cores per die" they want.
> 
> Fix CPUState.nr_cores' calculation to fit the original meaning "cores
> per package", as well as changing calculation of topo_info.cores_per_die,
> vcpus_per_socket and CPUID.1FH.

What a pain. Can we split this patch in 2, first the x86 part
and then the common part (softmmu/cpus.c)?

> Fixes: a94e1428991f ("target/i386: Add CPUID.1F generation support for multi-dies PCMachine")
> Fixes: 003f230e37d7 ("machine: Tweak the order of topology members in struct CpuTopology")
> Signed-off-by: Zhuocheng Ding <zhuocheng.ding@intel.com>
> Co-developed-by: Zhao Liu <zhao1.liu@intel.com>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> ---
> Changes since v3:
>   * Describe changes in imperative mood. (Babu)
>   * Fix spelling typo. (Babu)
>   * Split the comment change into a separate patch. (Xiaoyao)
> 
> Changes since v2:
>   * Use wrapped helper to get cores per socket in qemu_init_vcpu().
> 
> Changes since v1:
>   * Add comment for nr_dies in CPUX86State. (Yanan)
> ---
>   softmmu/cpus.c    | 2 +-
>   target/i386/cpu.c | 9 ++++-----
>   2 files changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/softmmu/cpus.c b/softmmu/cpus.c
> index 0848e0dbdb3f..fa8239c217ff 100644
> --- a/softmmu/cpus.c
> +++ b/softmmu/cpus.c
> @@ -624,7 +624,7 @@ void qemu_init_vcpu(CPUState *cpu)
>   {
>       MachineState *ms = MACHINE(qdev_get_machine());
>   
> -    cpu->nr_cores = ms->smp.cores;
> +    cpu->nr_cores = machine_topo_get_cores_per_socket(ms);
>       cpu->nr_threads =  ms->smp.threads;
>       cpu->stopped = true;
>       cpu->random_seed = qemu_guest_random_seed_thread_part1();
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 24ee67b42d05..709c055c8468 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -6015,7 +6015,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>       X86CPUTopoInfo topo_info;
>   
>       topo_info.dies_per_pkg = env->nr_dies;
> -    topo_info.cores_per_die = cs->nr_cores;
> +    topo_info.cores_per_die = cs->nr_cores / env->nr_dies;
>       topo_info.threads_per_core = cs->nr_threads;
>   
>       /* Calculate & apply limits for different index ranges */
> @@ -6091,8 +6091,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>                */
>               if (*eax & 31) {
>                   int host_vcpus_per_cache = 1 + ((*eax & 0x3FFC000) >> 14);
> -                int vcpus_per_socket = env->nr_dies * cs->nr_cores *
> -                                       cs->nr_threads;
> +                int vcpus_per_socket = cs->nr_cores * cs->nr_threads;
>                   if (cs->nr_cores > 1) {
>                       *eax &= ~0xFC000000;
>                       *eax |= (pow2ceil(cs->nr_cores) - 1) << 26;
> @@ -6270,12 +6269,12 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>               break;
>           case 1:
>               *eax = apicid_die_offset(&topo_info);
> -            *ebx = cs->nr_cores * cs->nr_threads;
> +            *ebx = topo_info.cores_per_die * topo_info.threads_per_core;
>               *ecx |= CPUID_TOPOLOGY_LEVEL_CORE;
>               break;
>           case 2:
>               *eax = apicid_pkg_offset(&topo_info);
> -            *ebx = env->nr_dies * cs->nr_cores * cs->nr_threads;
> +            *ebx = cs->nr_cores * cs->nr_threads;
>               *ecx |= CPUID_TOPOLOGY_LEVEL_DIE;
>               break;
>           default:

