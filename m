Return-Path: <kvm+bounces-714-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AC1117E1F8C
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 12:09:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DF6C9B20D73
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 11:08:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC24418AEB;
	Mon,  6 Nov 2023 11:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NQkBWiDI"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD35E171D7
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 11:08:50 +0000 (UTC)
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB2DF98
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 03:08:48 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id ffacd0b85a97d-32fbf271346so1513829f8f.1
        for <kvm@vger.kernel.org>; Mon, 06 Nov 2023 03:08:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699268927; x=1699873727; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0yFelocR66jYXowauowrhR0mUeB3U99cidSOqtYw+Cg=;
        b=NQkBWiDIgicR1gWykWuId+4C8SxhjMrGR4qCpB7TKKogEbNsS+2WWbZc4AWUw/aRjC
         E0/7Z2a6GaGTJxhb5weYsz2VNlksbyDLSt/My6UL5GF8EJdXTKezUQ06PojJMC2N+ZWW
         Vjlfe8EufcXSUzO2Bups1tFG9U4X5ncHunwsaiiqozzn9+GbkN5Oe11u7Ywkllb8q68j
         A/tiqe6WAkLL2PflUj/5QfWtRB7XwYu7ZXb37IQ08PbuzAvpBcnDbNtSD4+Z5OSx6/2f
         67NGQDDSlxq3vXhoWzoj9lLYdvBtEsMXyp8VfwzgFnESgX+Z2qMFfgbsEsG/mI4PNIeb
         xE5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699268927; x=1699873727;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0yFelocR66jYXowauowrhR0mUeB3U99cidSOqtYw+Cg=;
        b=biDt5vuqboG91cQEOLbVt95EBk6ph0NJrfAS1Y4EDJfdRDScJmkxdfhALydZLU9BWT
         7ykzc9JRoJlJDUPaw1u0jqA+RyQ2UYrUlrKpQcjLlFWYXK++fvBGcoMLOPsC40xzrwZl
         pc9EtAZ9q2dPSBVKXiyl7+NJJQ0oj8YR1k9/Dx10VugREiF0256xB4Ph0HG3xMmP/Nn1
         Z3hXSWHeksCYNSqdCUdvY5WcuhcyOdW1qIao9O4+DCefoYBVUZiF9FlEY+XvqvJ6uTRh
         bIzxCDIpBHjUGUWVhDNIl520aVzSieDTZnLLUydM/Jzwh7Tdr3wmvaZYGC7+QiZoHX2x
         CnJQ==
X-Gm-Message-State: AOJu0YyC8RSHbaaHsF0t8SAIZcoFjG9+DM3aaErlNiVkUZdrnAJ5rVvr
	inhX1lwxVaGOHmsAh6rFFexlxw==
X-Google-Smtp-Source: AGHT+IGgL0F1g9v6gQaqWqalE046qIpD1vXiY6eu81D5A7cfp1tnEC2cOxrnm8DtADlNcX3GEcp3bw==
X-Received: by 2002:a5d:6c6f:0:b0:32f:8085:7411 with SMTP id r15-20020a5d6c6f000000b0032f80857411mr21345810wrz.24.1699268927044;
        Mon, 06 Nov 2023 03:08:47 -0800 (PST)
Received: from m1x-phil.lan (176-131-220-199.abo.bbox.fr. [176.131.220.199])
        by smtp.gmail.com with ESMTPSA id g8-20020a5d4888000000b0032f7cc56509sm1544640wrq.98.2023.11.06.03.08.44
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 06 Nov 2023 03:08:46 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org,
	qemu-s390x@nongnu.org,
	qemu-block@nongnu.org,
	qemu-riscv@nongnu.org,
	qemu-ppc@nongnu.org,
	qemu-arm@nongnu.org,
	Zhuocheng Ding <zhuocheng.ding@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Babu Moger <babu.moger@amd.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>
Subject: [PULL 45/60] system/cpus: Fix CPUState.nr_cores' calculation
Date: Mon,  6 Nov 2023 12:03:17 +0100
Message-ID: <20231106110336.358-46-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231106110336.358-1-philmd@linaro.org>
References: <20231106110336.358-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhuocheng Ding <zhuocheng.ding@intel.com>

From CPUState.nr_cores' comment, it represents "number of cores within
this CPU package".

After 003f230e37d7 ("machine: Tweak the order of topology members in
struct CpuTopology"), the meaning of smp.cores changed to "the number of
cores in one die", but this commit missed to change CPUState.nr_cores'
calculation, so that CPUState.nr_cores became wrong and now it
misses to consider numbers of clusters and dies.

At present, only i386 is using CPUState.nr_cores.

But as for i386, which supports die level, the uses of CPUState.nr_cores
are very confusing:

Early uses are based on the meaning of "cores per package" (before die
is introduced into i386), and later uses are based on "cores per die"
(after die's introduction).

This difference is due to that commit a94e1428991f ("target/i386: Add
CPUID.1F generation support for multi-dies PCMachine") misunderstood
that CPUState.nr_cores means "cores per die" when calculated
CPUID.1FH.01H:EBX. After that, the changes in i386 all followed this
wrong understanding.

With the influence of 003f230e37d7 and a94e1428991f, for i386 currently
the result of CPUState.nr_cores is "cores per die", thus the original
uses of CPUState.cores based on the meaning of "cores per package" are
wrong when multiple dies exist:
1. In cpu_x86_cpuid() of target/i386/cpu.c, CPUID.01H:EBX[bits 23:16] is
   incorrect because it expects "cpus per package" but now the
   result is "cpus per die".
2. In cpu_x86_cpuid() of target/i386/cpu.c, for all leaves of CPUID.04H:
   EAX[bits 31:26] is incorrect because they expect "cpus per package"
   but now the result is "cpus per die". The error not only impacts the
   EAX calculation in cache_info_passthrough case, but also impacts other
   cases of setting cache topology for Intel CPU according to cpu
   topology (specifically, the incoming parameter "num_cores" expects
   "cores per package" in encode_cache_cpuid4()).
3. In cpu_x86_cpuid() of target/i386/cpu.c, CPUID.0BH.01H:EBX[bits
   15:00] is incorrect because the EBX of 0BH.01H (core level) expects
   "cpus per package", which may be different with 1FH.01H (The reason
   is 1FH can support more levels. For QEMU, 1FH also supports die,
   1FH.01H:EBX[bits 15:00] expects "cpus per die").
4. In cpu_x86_cpuid() of target/i386/cpu.c, when CPUID.80000001H is
   calculated, here "cpus per package" is expected to be checked, but in
   fact, now it checks "cpus per die". Though "cpus per die" also works
   for this code logic, this isn't consistent with AMD's APM.
5. In cpu_x86_cpuid() of target/i386/cpu.c, CPUID.80000008H:ECX expects
   "cpus per package" but it obtains "cpus per die".
6. In simulate_rdmsr() of target/i386/hvf/x86_emu.c, in
   kvm_rdmsr_core_thread_count() of target/i386/kvm/kvm.c, and in
   helper_rdmsr() of target/i386/tcg/sysemu/misc_helper.c,
   MSR_CORE_THREAD_COUNT expects "cpus per package" and "cores per
   package", but in these functions, it obtains "cpus per die" and
   "cores per die".

On the other hand, these uses are correct now (they are added in/after
a94e1428991f):
1. In cpu_x86_cpuid() of target/i386/cpu.c, topo_info.cores_per_die
   meets the actual meaning of CPUState.nr_cores ("cores per die").
2. In cpu_x86_cpuid() of target/i386/cpu.c, vcpus_per_socket (in CPUID.
   04H's calculation) considers number of dies, so it's correct.
3. In cpu_x86_cpuid() of target/i386/cpu.c, CPUID.1FH.01H:EBX[bits
   15:00] needs "cpus per die" and it gets the correct result, and
   CPUID.1FH.02H:EBX[bits 15:00] gets correct "cpus per package".

When CPUState.nr_cores is correctly changed to "cores per package" again
, the above errors will be fixed without extra work, but the "currently"
correct cases will go wrong and need special handling to pass correct
"cpus/cores per die" they want.

Fix CPUState.nr_cores' calculation to fit the original meaning "cores
per package", as well as changing calculation of topo_info.cores_per_die,
vcpus_per_socket and CPUID.1FH.

Fixes: a94e1428991f ("target/i386: Add CPUID.1F generation support for multi-dies PCMachine")
Fixes: 003f230e37d7 ("machine: Tweak the order of topology members in struct CpuTopology")
Signed-off-by: Zhuocheng Ding <zhuocheng.ding@intel.com>
Co-developed-by: Zhao Liu <zhao1.liu@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
Tested-by: Babu Moger <babu.moger@amd.com>
Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20231024090323.1859210-4-zhao1.liu@linux.intel.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 system/cpus.c     | 2 +-
 target/i386/cpu.c | 9 ++++-----
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/system/cpus.c b/system/cpus.c
index 952f15868c..a444a747f0 100644
--- a/system/cpus.c
+++ b/system/cpus.c
@@ -631,7 +631,7 @@ void qemu_init_vcpu(CPUState *cpu)
 {
     MachineState *ms = MACHINE(qdev_get_machine());
 
-    cpu->nr_cores = ms->smp.cores;
+    cpu->nr_cores = machine_topo_get_cores_per_socket(ms);
     cpu->nr_threads =  ms->smp.threads;
     cpu->stopped = true;
     cpu->random_seed = qemu_guest_random_seed_thread_part1();
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index fc8484cb5e..358d9c0a65 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -6019,7 +6019,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
     X86CPUTopoInfo topo_info;
 
     topo_info.dies_per_pkg = env->nr_dies;
-    topo_info.cores_per_die = cs->nr_cores;
+    topo_info.cores_per_die = cs->nr_cores / env->nr_dies;
     topo_info.threads_per_core = cs->nr_threads;
 
     /* Calculate & apply limits for different index ranges */
@@ -6095,8 +6095,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
              */
             if (*eax & 31) {
                 int host_vcpus_per_cache = 1 + ((*eax & 0x3FFC000) >> 14);
-                int vcpus_per_socket = env->nr_dies * cs->nr_cores *
-                                       cs->nr_threads;
+                int vcpus_per_socket = cs->nr_cores * cs->nr_threads;
                 if (cs->nr_cores > 1) {
                     *eax &= ~0xFC000000;
                     *eax |= (pow2ceil(cs->nr_cores) - 1) << 26;
@@ -6273,12 +6272,12 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
             break;
         case 1:
             *eax = apicid_die_offset(&topo_info);
-            *ebx = cs->nr_cores * cs->nr_threads;
+            *ebx = topo_info.cores_per_die * topo_info.threads_per_core;
             *ecx |= CPUID_TOPOLOGY_LEVEL_CORE;
             break;
         case 2:
             *eax = apicid_pkg_offset(&topo_info);
-            *ebx = env->nr_dies * cs->nr_cores * cs->nr_threads;
+            *ebx = cs->nr_cores * cs->nr_threads;
             *ecx |= CPUID_TOPOLOGY_LEVEL_DIE;
             break;
         default:
-- 
2.41.0


