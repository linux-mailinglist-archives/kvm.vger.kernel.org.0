Return-Path: <kvm+bounces-6069-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DA8B182AA89
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 10:09:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 486CF1F2349B
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 09:09:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1490D101C5;
	Thu, 11 Jan 2024 09:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X3/gkLqz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEA03FC0C
	for <kvm@vger.kernel.org>; Thu, 11 Jan 2024 09:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704964135; x=1736500135;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=u+wzhwnjwnUJ0WCOAr9zS3iSp7euwPeQTCo/TLxYbWQ=;
  b=X3/gkLqzavLToG1xtD5Q6SuDFJZdaDn1KngJCG1/CbgMvFjmAF2KkJIU
   wIlLHmyIwCXeqYqqprLNciWKM955nBNegctYY1Qmq8HF0ahqvv5Z2g26s
   Prj2QECflcdDHSd5unX9HB/6bAMfIgiCCgtnQdkqnJqW9PqnVXLhMwh28
   UNxemEiexRq6en5Ueshq8aeoMPW/0uw+WLskWnfcYXClKZpFlnI4Ac8jo
   ZHdbRlqWmoLTPz0GIh3JZ2r9gkyHC+mdiLIPE+QJuzF2v+Oz8T7rYo4Fn
   HhpG6i+8OkCdwW8nyYrPjq6GdOBFuQSSrZ1wJ9cK548EXVQVjiC4Rrt24
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10949"; a="397661158"
X-IronPort-AV: E=Sophos;i="6.04,185,1695711600"; 
   d="scan'208";a="397661158"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2024 01:08:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,185,1695711600"; 
   d="scan'208";a="24566937"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmviesa001.fm.intel.com with ESMTP; 11 Jan 2024 01:08:50 -0800
Date: Thu, 11 Jan 2024 17:21:46 +0800
From: Zhao Liu <zhao1.liu@linux.intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Zhuocheng Ding <zhuocheng.ding@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>, Babu Moger <babu.moger@amd.com>,
	Yongwei Ma <yongwei.ma@intel.com>
Subject: Re: [PATCH v7 08/16] i386: Expose module level in CPUID[0x1F]
Message-ID: <ZZ+zKmOee3j9KK2D@intel.com>
References: <20240108082727.420817-1-zhao1.liu@linux.intel.com>
 <20240108082727.420817-9-zhao1.liu@linux.intel.com>
 <a7b93109-9543-4967-a467-9fead80b434d@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a7b93109-9543-4967-a467-9fead80b434d@intel.com>

Hi Xiaoyao,

On Thu, Jan 11, 2024 at 02:04:53PM +0800, Xiaoyao Li wrote:
> Date: Thu, 11 Jan 2024 14:04:53 +0800
> From: Xiaoyao Li <xiaoyao.li@intel.com>
> Subject: Re: [PATCH v7 08/16] i386: Expose module level in CPUID[0x1F]
> 
> On 1/8/2024 4:27 PM, Zhao Liu wrote:
> > From: Zhao Liu <zhao1.liu@intel.com>
> > 
> > Linux kernel (from v6.4, with commit edc0a2b595765 ("x86/topology: Fix
> > erroneous smp_num_siblings on Intel Hybrid platforms") is able to
> > handle platforms with Module level enumerated via CPUID.1F.
> > 
> > Expose the module level in CPUID[0x1F] if the machine has more than 1
> > modules.
> > 
> > (Tested CPU topology in CPUID[0x1F] leaf with various die/cluster
> > configurations in "-smp".)
> > 
> > Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> > Tested-by: Babu Moger <babu.moger@amd.com>
> > Tested-by: Yongwei Ma <yongwei.ma@intel.com>
> > Acked-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> > Changes since v3:
> >   * New patch to expose module level in 0x1F.
> >   * Add Tested-by tag from Yongwei.
> > ---
> >   target/i386/cpu.c     | 12 +++++++++++-
> >   target/i386/cpu.h     |  2 ++
> >   target/i386/kvm/kvm.c |  2 +-
> >   3 files changed, 14 insertions(+), 2 deletions(-)
> > 
> > diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> > index 294ca6b8947a..a2d39d2198b6 100644
> > --- a/target/i386/cpu.c
> > +++ b/target/i386/cpu.c
> > @@ -277,6 +277,8 @@ static uint32_t num_cpus_by_topo_level(X86CPUTopoInfo *topo_info,
> >           return 1;
> >       case CPU_TOPO_LEVEL_CORE:
> >           return topo_info->threads_per_core;
> > +    case CPU_TOPO_LEVEL_MODULE:
> > +        return topo_info->threads_per_core * topo_info->cores_per_module;
> >       case CPU_TOPO_LEVEL_DIE:
> >           return topo_info->threads_per_core * topo_info->cores_per_module *
> >                  topo_info->modules_per_die;
> > @@ -297,6 +299,8 @@ static uint32_t apicid_offset_by_topo_level(X86CPUTopoInfo *topo_info,
> >           return 0;
> >       case CPU_TOPO_LEVEL_CORE:
> >           return apicid_core_offset(topo_info);
> > +    case CPU_TOPO_LEVEL_MODULE:
> > +        return apicid_module_offset(topo_info);
> >       case CPU_TOPO_LEVEL_DIE:
> >           return apicid_die_offset(topo_info);
> >       case CPU_TOPO_LEVEL_PACKAGE:
> > @@ -316,6 +320,8 @@ static uint32_t cpuid1f_topo_type(enum CPUTopoLevel topo_level)
> >           return CPUID_1F_ECX_TOPO_LEVEL_SMT;
> >       case CPU_TOPO_LEVEL_CORE:
> >           return CPUID_1F_ECX_TOPO_LEVEL_CORE;
> > +    case CPU_TOPO_LEVEL_MODULE:
> > +        return CPUID_1F_ECX_TOPO_LEVEL_MODULE;
> >       case CPU_TOPO_LEVEL_DIE:
> >           return CPUID_1F_ECX_TOPO_LEVEL_DIE;
> >       default:
> > @@ -347,6 +353,10 @@ static void encode_topo_cpuid1f(CPUX86State *env, uint32_t count,
> >           if (env->nr_dies > 1) {
> >               set_bit(CPU_TOPO_LEVEL_DIE, topo_bitmap);
> >           }
> > +
> > +        if (env->nr_modules > 1) {
> > +            set_bit(CPU_TOPO_LEVEL_MODULE, topo_bitmap);
> > +        }
> >       }
> >       *ecx = count & 0xff;
> > @@ -6394,7 +6404,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
> >           break;
> >       case 0x1F:
> >           /* V2 Extended Topology Enumeration Leaf */
> > -        if (topo_info.dies_per_pkg < 2) {
> > +        if (topo_info.modules_per_die < 2 && topo_info.dies_per_pkg < 2) {
> 
> maybe we can come up with below function if we have env->valid_cpu_topo[] as
> I suggested in patch 5.
> 
> bool cpu_x86_has_valid_cpuid1f(CPUX86State *env) {
> 	return env->valid_cpu_topo[2] ? true : false;
> }
> 
> ...

This makes sense.

> 
> >               *eax = *ebx = *ecx = *edx = 0;
> >               break;
> >           }
> > diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> > index eecd30bde92b..97b290e10576 100644
> > --- a/target/i386/cpu.h
> > +++ b/target/i386/cpu.h
> > @@ -1018,6 +1018,7 @@ enum CPUTopoLevel {
> >       CPU_TOPO_LEVEL_INVALID,
> >       CPU_TOPO_LEVEL_SMT,
> >       CPU_TOPO_LEVEL_CORE,
> > +    CPU_TOPO_LEVEL_MODULE,
> >       CPU_TOPO_LEVEL_DIE,
> >       CPU_TOPO_LEVEL_PACKAGE,
> >       CPU_TOPO_LEVEL_MAX,
> > @@ -1032,6 +1033,7 @@ enum CPUTopoLevel {
> >   #define CPUID_1F_ECX_TOPO_LEVEL_INVALID  CPUID_B_ECX_TOPO_LEVEL_INVALID
> >   #define CPUID_1F_ECX_TOPO_LEVEL_SMT      CPUID_B_ECX_TOPO_LEVEL_SMT
> >   #define CPUID_1F_ECX_TOPO_LEVEL_CORE     CPUID_B_ECX_TOPO_LEVEL_CORE
> > +#define CPUID_1F_ECX_TOPO_LEVEL_MODULE   3
> >   #define CPUID_1F_ECX_TOPO_LEVEL_DIE      5
> >   /* MSR Feature Bits */
> > diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> > index 4ce80555b45c..e5ddb214cb36 100644
> > --- a/target/i386/kvm/kvm.c
> > +++ b/target/i386/kvm/kvm.c
> > @@ -1913,7 +1913,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
> >               break;
> >           }
> >           case 0x1f:
> > -            if (env->nr_dies < 2) {
> > +            if (env->nr_modules < 2 && env->nr_dies < 2) {
> 
> then cpu_x86_has_valid_cpuid1f() can be used here.
>

Good idae, I will also try this.

Thanks,
Zhao

