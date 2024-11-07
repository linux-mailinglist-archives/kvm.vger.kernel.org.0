Return-Path: <kvm+bounces-31064-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A0BEB9BFF30
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 08:35:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AA1A01C24256
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 07:35:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCAD019ABCB;
	Thu,  7 Nov 2024 07:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Zg9ERZ1Z"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7DD8198A1A
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 07:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730964892; cv=none; b=WQ2543LjxGexGzyPNyHRa7deTafPKEXZRmZNDDLiQVOaN/d8fSIhEldLNngOP/CSi9VK218v3z6A4ekY2jowNtotYqUQiCH6MtpFCaF71hiQFOt49scbEgPQ+vBWUDewz3GqKh4C8d+vXVfqL750KCq9xGVWu3x9MmcHuuTiyJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730964892; c=relaxed/simple;
	bh=IOqD1V9wRLxHen71Wykek1sZduHKbJXXD+yIx0K/nkI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SmZ7VJBs/aYox7quzDeBf50HwusA3KUv9ALIfHGn08KroXpK6ILwjKGhTYHSfPVOcIP99JKLsjmnAKkltwUPcdyApy5Jdt9dP2IsJZqLFwLXx8rUhw/wZwnL3KwFBhHvDV10nobyX2HZZIVW3mg4KCHx8f5fsMmoN+7rd+MRok4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Zg9ERZ1Z; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730964891; x=1762500891;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=IOqD1V9wRLxHen71Wykek1sZduHKbJXXD+yIx0K/nkI=;
  b=Zg9ERZ1Z9F+YGjtbsCvZ0XNxUfX/jRqhOczpCnWgPjGbjymixVF+EEpD
   oNS5QP5XNYHCY+IjZkwF0JXEafeLWDL2GMoSKZJKa9bkh5Rkt9eW4TVB6
   m5tl2Fmz/hctBCYHEBjAQuI4nKueRjKuFSFwKRUfWZPTQHgE8FRmdqPdZ
   CRQDIYkPsEKuK7hbdTlsPS1B9xEoxh5F3JCw3YyPxR3kVhn56q8kGg7Oo
   oWfVOv1HomKFDJycyMTNQcRk9lMhWoGl5Ih06471a/Bb+VBCJSht/USkc
   p8OZsaJv/+STOCTXmaUHu3GrSLIVjy3kbjTUI3+9BqNMu4dx72R0sL3g8
   A==;
X-CSE-ConnectionGUID: 92hraI0XT1Kpe1oP942KoQ==
X-CSE-MsgGUID: npAB3682TTm1YnEmQZz+8A==
X-IronPort-AV: E=McAfee;i="6700,10204,11248"; a="48311553"
X-IronPort-AV: E=Sophos;i="6.11,265,1725346800"; 
   d="scan'208";a="48311553"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 23:34:50 -0800
X-CSE-ConnectionGUID: 5c+QaFilT+iM3PDdzWyeoA==
X-CSE-MsgGUID: TWqSbT6hS7qTLYATld285w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,265,1725346800"; 
   d="scan'208";a="85761361"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orviesa008.jf.intel.com with ESMTP; 06 Nov 2024 23:34:46 -0800
Date: Thu, 7 Nov 2024 15:52:42 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Dongli Zhang <dongli.zhang@oracle.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, pbonzini@redhat.com,
	mtosatti@redhat.com, sandipan.das@amd.com, babu.moger@amd.com,
	likexu@tencent.com, like.xu.linux@gmail.com,
	zhenyuw@linux.intel.com, groug@kaod.org, lyan@digitalocean.com,
	khorenko@virtuozzo.com, alexander.ivanov@virtuozzo.com,
	den@virtuozzo.com, joe.jin@oracle.com, davydov-max@yandex-team.ru,
	dapeng1.mi@linux.intel.com, zide.chen@intel.com
Subject: Re: [PATCH 2/7] target/i386/kvm: introduce 'pmu-cap-disabled' to set
 KVM_PMU_CAP_DISABLE
Message-ID: <ZyxxygVaufOntpZJ@intel.com>
References: <20241104094119.4131-1-dongli.zhang@oracle.com>
 <20241104094119.4131-3-dongli.zhang@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241104094119.4131-3-dongli.zhang@oracle.com>

(+Dapang & Zide)

Hi Dongli,

On Mon, Nov 04, 2024 at 01:40:17AM -0800, Dongli Zhang wrote:
> Date: Mon,  4 Nov 2024 01:40:17 -0800
> From: Dongli Zhang <dongli.zhang@oracle.com>
> Subject: [PATCH 2/7] target/i386/kvm: introduce 'pmu-cap-disabled' to set
>  KVM_PMU_CAP_DISABLE
> X-Mailer: git-send-email 2.43.5
> 
> The AMD PMU virtualization is not disabled when configuring
> "-cpu host,-pmu" in the QEMU command line on an AMD server. Neither
> "-cpu host,-pmu" nor "-cpu EPYC" effectively disables AMD PMU
> virtualization in such an environment.
> 
> As a result, VM logs typically show:
> 
> [    0.510611] Performance Events: Fam17h+ core perfctr, AMD PMU driver.
> 
> whereas the expected logs should be:
> 
> [    0.596381] Performance Events: PMU not available due to virtualization, using software events only.
> [    0.600972] NMI watchdog: Perf NMI watchdog permanently disabled
> 
> This discrepancy occurs because AMD PMU does not use CPUID to determine
> whether PMU virtualization is supported.

Intel platform doesn't have this issue since Linux kernel fails to check
the CPU family & model when "-cpu *,-pmu" option clears PMU version.

The difference between Intel and AMD platforms, however, is that it seems
Intel hardly ever reaches the ¡°...due virtualization¡± message, but
instead reports an error because it recognizes a mismatched family/model.

This may be a drawback of the PMU driver's print message, but the result
is the same, it prevents the PMU driver from enabling.

So, please mention that KVM_PMU_CAP_DISABLE doesn't change the PMU
behavior on Intel platform because current "pmu" property works as
expected.

> To address this, we introduce a new property, 'pmu-cap-disabled', for KVM
> acceleration. This property sets KVM_PMU_CAP_DISABLE if
> KVM_CAP_PMU_CAPABILITY is supported. Note that this feature currently
> supports only x86 hosts, as KVM_CAP_PMU_CAPABILITY is used exclusively for
> x86 systems.
> 
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> ---
> Another previous solution to re-use '-cpu host,-pmu':
> https://lore.kernel.org/all/20221119122901.2469-1-dongli.zhang@oracle.com/

IMO, I prefer the previous version. This VM-level KVM property is
difficult to integrate with the existing CPU properties. Pls refer later
comments for reasons.

>  accel/kvm/kvm-all.c        |  1 +
>  include/sysemu/kvm_int.h   |  1 +
>  qemu-options.hx            |  9 ++++++-
>  target/i386/cpu.c          |  2 +-
>  target/i386/kvm/kvm.c      | 52 ++++++++++++++++++++++++++++++++++++++
>  target/i386/kvm/kvm_i386.h |  2 ++
>  6 files changed, 65 insertions(+), 2 deletions(-)
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index 801cff16a5..8b5ba45cf7 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -3933,6 +3933,7 @@ static void kvm_accel_instance_init(Object *obj)
>      s->xen_evtchn_max_pirq = 256;
>      s->device = NULL;
>      s->msr_energy.enable = false;
> +    s->pmu_cap_disabled = false;
>  }

The CPU property "pmu" also defaults to "false"...but:

 * max CPU would override this and try to enable PMU by default in
   max_x86_cpu_initfn().

 * Other named CPU models keep the default setting to avoid affecting
   the migration.

The pmu_cap_disabled and ¡°pmu¡± property look unbound and unassociated,
so this can cause the conflict when they are not synchronized. For
example,

-cpu host -accel kvm,pmu-cap-disabled=on

The above options will fail to launch a VM (on Intel platform).

Ideally, the ¡°pmu¡± property and pmu-cap-disabled should be bound to each
other and be consistent. But it's not easy because:
 - There is no proper way to have pmu_cap_disabled set different default
   values (e.g., "false" for max CPU and "true" for named CPU models)
   based on different CPU models.
 - And, no proper place to check the consistency of pmu_cap_disabled and
   enable_pmu.

Therefore, I prefer your previous approach, to reuse current CPU "pmu"
property.

Further, considering that this is currently the only case that needs to
to set the VM level's capability in the CPU context, there is no need to
introduce a new kvm interface (in your previous patch), which can instead
be set in kvm_cpu_realizefn(), like:


diff --git a/target/i386/kvm/kvm-cpu.c b/target/i386/kvm/kvm-cpu.c
index 99d1941cf51c..05e9c9a1a0cf 100644
--- a/target/i386/kvm/kvm-cpu.c
+++ b/target/i386/kvm/kvm-cpu.c
@@ -42,6 +42,8 @@ static bool kvm_cpu_realizefn(CPUState *cs, Error **errp)
 {
     X86CPU *cpu = X86_CPU(cs);
     CPUX86State *env = &cpu->env;
+    KVMState *s = kvm_state;
+    static bool first = true;
     bool ret;

     /*
@@ -63,6 +65,29 @@ static bool kvm_cpu_realizefn(CPUState *cs, Error **errp)
      *   check/update ucode_rev, phys_bits, guest_phys_bits, mwait
      *   cpu_common_realizefn() (via xcc->parent_realize)
      */
+
+    if (first) {
+        first = false;
+
+        /*
+         * Since Linux v5.18, KVM provides a VM-level capability to easily
+         * disable PMUs; however, QEMU has been providing PMU property per
+         * CPU since v1.6. In order to accommodate both, have to configure
+         * the VM-level capability here.
+         */
+        if (!cpu->enable_pmu &&
+            kvm_check_extension(s, KVM_CAP_PMU_CAPABILITY)) {
+            int r = kvm_vm_enable_cap(s, KVM_CAP_PMU_CAPABILITY, 0,
+                                      KVM_PMU_CAP_DISABLE);
+
+            if (r < 0) {
+                error_setg(errp, "kvm: Failed to disable pmu cap: %s",
+                           strerror(-r));
+                return false;
+            }
+        }
+    }
+
     if (cpu->max_features) {
         if (enable_cpu_pm) {
             if (kvm_has_waitpkg()) {
---

In addition, if PMU is disabled, why not mask the perf related bits in
8000_0001_ECX? :)

Regards,
Zhao


