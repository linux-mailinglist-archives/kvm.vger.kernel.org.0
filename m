Return-Path: <kvm+bounces-6188-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D063D82D3DA
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 06:20:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 490351F215AD
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 05:20:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B673A46B4;
	Mon, 15 Jan 2024 05:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="luRdA5kE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA1B34401
	for <kvm@vger.kernel.org>; Mon, 15 Jan 2024 05:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705296029; x=1736832029;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Qbjdb6h6fIbGw1gsZSjaB1Wuih1qWNvn8mYbw+QrrZs=;
  b=luRdA5kEOVxSHuReuS11MxGRnOM3/rR/ApkM7TzOLxPk2UgXBRXwTCAx
   Lc3w0D6cFiJLoJZJU3xpG349PoKg+gJThhyg4IH1ddF4wrPDGWNfjwjrn
   vnsJJPJ0BsQcWc9BnzJAoxVGYrmPRp1NfBr8TeU3wUuO7+hQ1RE6nvtey
   Hogd3gcYY9GFM1ZDsJ2kGy0xg+xc1K2Ix3DMDN6THvHvg33LE9MlcZFoB
   tieiMJhxZVJm9agw4g7B+GM2Y0xe0WKztPxrptEVBrfezND0TPFPjXs8B
   DDN0qFiBtYbvpH0zg3EOBwU9QE3kqmUybiAynPD/ermMu7XfjdMk6Fg+Y
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10953"; a="398401306"
X-IronPort-AV: E=Sophos;i="6.04,195,1695711600"; 
   d="scan'208";a="398401306"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2024 21:20:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,195,1695711600"; 
   d="scan'208";a="25368932"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by orviesa002.jf.intel.com with ESMTP; 14 Jan 2024 21:20:24 -0800
Date: Mon, 15 Jan 2024 13:20:22 +0800
From: Yuan Yao <yuan.yao@linux.intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Zhao Liu <zhao1.liu@linux.intel.com>,
	Eduardo Habkost <eduardo@habkost.net>,
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
Message-ID: <20240115052022.xbv6exhm4af7kai7@yy-desk-7060>
References: <20240108082727.420817-1-zhao1.liu@linux.intel.com>
 <20240108082727.420817-9-zhao1.liu@linux.intel.com>
 <20240115032524.44q5ygb25ieut44c@yy-desk-7060>
 <ZaSv51/5Eokkv5Rr@intel.com>
 <336a4816-966d-42b0-b34b-47be3e41446d@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <336a4816-966d-42b0-b34b-47be3e41446d@intel.com>
User-Agent: NeoMutt/20171215

On Mon, Jan 15, 2024 at 12:34:12PM +0800, Xiaoyao Li wrote:
> On 1/15/2024 12:09 PM, Zhao Liu wrote:
> > Hi Yuan,
> >
> > On Mon, Jan 15, 2024 at 11:25:24AM +0800, Yuan Yao wrote:
> > > Date: Mon, 15 Jan 2024 11:25:24 +0800
> > > From: Yuan Yao <yuan.yao@linux.intel.com>
> > > Subject: Re: [PATCH v7 08/16] i386: Expose module level in CPUID[0x1F]
> > >
> > > On Mon, Jan 08, 2024 at 04:27:19PM +0800, Zhao Liu wrote:
> > > > From: Zhao Liu <zhao1.liu@intel.com>
> > > >
> > > > Linux kernel (from v6.4, with commit edc0a2b595765 ("x86/topology: Fix
> > > > erroneous smp_num_siblings on Intel Hybrid platforms") is able to
> > > > handle platforms with Module level enumerated via CPUID.1F.
> > > >
> > > > Expose the module level in CPUID[0x1F] if the machine has more than 1
> > > > modules.
> > > >
> > > > (Tested CPU topology in CPUID[0x1F] leaf with various die/cluster
> > > > configurations in "-smp".)
> > > >
> > > > Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> > > > Tested-by: Babu Moger <babu.moger@amd.com>
> > > > Tested-by: Yongwei Ma <yongwei.ma@intel.com>
> > > > Acked-by: Michael S. Tsirkin <mst@redhat.com>
> > > > ---
> > > > Changes since v3:
> > > >   * New patch to expose module level in 0x1F.
> > > >   * Add Tested-by tag from Yongwei.
> > > > ---
> > > >   target/i386/cpu.c     | 12 +++++++++++-
> > > >   target/i386/cpu.h     |  2 ++
> > > >   target/i386/kvm/kvm.c |  2 +-
> > > >   3 files changed, 14 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> > > > index 294ca6b8947a..a2d39d2198b6 100644
> > > > --- a/target/i386/cpu.c
> > > > +++ b/target/i386/cpu.c
> > > > @@ -277,6 +277,8 @@ static uint32_t num_cpus_by_topo_level(X86CPUTopoInfo *topo_info,
> > > >           return 1;
> > > >       case CPU_TOPO_LEVEL_CORE:
> > > >           return topo_info->threads_per_core;
> > > > +    case CPU_TOPO_LEVEL_MODULE:
> > > > +        return topo_info->threads_per_core * topo_info->cores_per_module;
> > > >       case CPU_TOPO_LEVEL_DIE:
> > > >           return topo_info->threads_per_core * topo_info->cores_per_module *
> > > >                  topo_info->modules_per_die;
> > > > @@ -297,6 +299,8 @@ static uint32_t apicid_offset_by_topo_level(X86CPUTopoInfo *topo_info,
> > > >           return 0;
> > > >       case CPU_TOPO_LEVEL_CORE:
> > > >           return apicid_core_offset(topo_info);
> > > > +    case CPU_TOPO_LEVEL_MODULE:
> > > > +        return apicid_module_offset(topo_info);
> > > >       case CPU_TOPO_LEVEL_DIE:
> > > >           return apicid_die_offset(topo_info);
> > > >       case CPU_TOPO_LEVEL_PACKAGE:
> > > > @@ -316,6 +320,8 @@ static uint32_t cpuid1f_topo_type(enum CPUTopoLevel topo_level)
> > > >           return CPUID_1F_ECX_TOPO_LEVEL_SMT;
> > > >       case CPU_TOPO_LEVEL_CORE:
> > > >           return CPUID_1F_ECX_TOPO_LEVEL_CORE;
> > > > +    case CPU_TOPO_LEVEL_MODULE:
> > > > +        return CPUID_1F_ECX_TOPO_LEVEL_MODULE;
> > > >       case CPU_TOPO_LEVEL_DIE:
> > > >           return CPUID_1F_ECX_TOPO_LEVEL_DIE;
> > > >       default:
> > > > @@ -347,6 +353,10 @@ static void encode_topo_cpuid1f(CPUX86State *env, uint32_t count,
> > > >           if (env->nr_dies > 1) {
> > > >               set_bit(CPU_TOPO_LEVEL_DIE, topo_bitmap);
> > > >           }
> > > > +
> > > > +        if (env->nr_modules > 1) {
> > > > +            set_bit(CPU_TOPO_LEVEL_MODULE, topo_bitmap);
> > > > +        }
> > > >       }
> > > >
> > > >       *ecx = count & 0xff;
> > > > @@ -6394,7 +6404,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
> > > >           break;
> > > >       case 0x1F:
> > > >           /* V2 Extended Topology Enumeration Leaf */
> > > > -        if (topo_info.dies_per_pkg < 2) {
> > > > +        if (topo_info.modules_per_die < 2 && topo_info.dies_per_pkg < 2) {
> > >
> > > A question:
> > > Is the original checking necessary ?
> > > The 0x1f exists even on cpu w/o modules/dies topology on bare metal, I tried
> > > on EMR:
> > >
> > > // leaf 0
> > > 0x00000000 0x00: eax=0x00000020 ebx=0x756e6547 ecx=0x6c65746e edx=0x49656e69
> > >
> > > // leaf 0x1f
> > > 0x0000001f 0x00: eax=0x00000001 ebx=0x00000002 ecx=0x00000100 edx=0x00000004
> > > 0x0000001f 0x01: eax=0x00000007 ebx=0x00000080 ecx=0x00000201 edx=0x00000004
> > > 0x0000001f 0x02: eax=0x00000000 ebx=0x00000000 ecx=0x00000002 edx=0x00000004
> > >
> > > // leaf 0xb
> > > 0x0000000b 0x00: eax=0x00000001 ebx=0x00000002 ecx=0x00000100 edx=0x00000004
> > > 0x0000000b 0x01: eax=0x00000007 ebx=0x00000080 ecx=0x00000201 edx=0x00000004
> > > 0x0000000b 0x02: eax=0x00000000 ebx=0x00000000 ecx=0x00000002 edx=0x00000004
> >
> > The 0x1f is introduced for CascadeLake-AP with die level. And yes the
> > newer mahcines all have this leaf.
> >
> > >
> > > So here leads to different cpu behavior from bare metal, even in case
> > > of "-cpu host".
> > >
> > > In SDM Vol2, cpudid instruction section:
> > >
> > > " CPUID leaf 1FH is a preferred superset to leaf 0BH. Intel
> > > recommends using leaf 1FH when available rather than leaf
> > > 0BH and ensuring that any leaf 0BH algorithms are updated to
> > > support leaf 1FH. "
> > >
> > > My understanding: if 0x1f is existed (leaf 0.eax >= 0x1f)
> > > then it should have same values in lp/core level as 0xb.
>
> No. leaf 0x1f reports the same values in lp/core leve as leaf 0xb only when
> the machine supports these two levels. If the machine supports more levels,
> they will be different.
>
> e.g., the data on one Alder lake:
>
> 0x0000000b 0x00: eax=0x00000001 ebx=0x00000001 ecx=0x00000100 edx=0x00000006
> 0x0000000b 0x01: eax=0x00000007 ebx=0x00000004 ecx=0x00000201 edx=0x00000006
> 0x0000000b 0x02: eax=0x00000000 ebx=0x00000000 ecx=0x00000002 edx=0x00000006
>
> 0x0000001f 0x00: eax=0x00000001 ebx=0x00000001 ecx=0x00000100 edx=0x00000006
> 0x0000001f 0x01: eax=0x00000003 ebx=0x00000004 ecx=0x00000201 edx=0x00000006
> 0x0000001f 0x02: eax=0x00000007 ebx=0x00000004 ecx=0x00000302 edx=0x00000006
> 0x0000001f 0x03: eax=0x00000000 ebx=0x00000000 ecx=0x00000003 edx=0x00000006

Ah, so my understanding is incorrect on this.

I tried on one raptor lake i5-i335U, which also hybrid soc but doesn't have
module level, in this case 0x1f and 0xb have same values in core/lp level.

>
>
> > Yes, I think it's time to move to default 0x1f.
>
> we don't need to do so until it's necessary.
>
> > The compatibility issue can be solved by a cpuid-0x1f option similar to
> > cpuid-0xb. I'll cook a patch after this patch series.
> >
> > Thanks,
> > Zhao
> >
> > >
> > > >               *eax = *ebx = *ecx = *edx = 0;
> > > >               break;
> > > >           }
> > > > diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> > > > index eecd30bde92b..97b290e10576 100644
> > > > --- a/target/i386/cpu.h
> > > > +++ b/target/i386/cpu.h
> > > > @@ -1018,6 +1018,7 @@ enum CPUTopoLevel {
> > > >       CPU_TOPO_LEVEL_INVALID,
> > > >       CPU_TOPO_LEVEL_SMT,
> > > >       CPU_TOPO_LEVEL_CORE,
> > > > +    CPU_TOPO_LEVEL_MODULE,
> > > >       CPU_TOPO_LEVEL_DIE,
> > > >       CPU_TOPO_LEVEL_PACKAGE,
> > > >       CPU_TOPO_LEVEL_MAX,
> > > > @@ -1032,6 +1033,7 @@ enum CPUTopoLevel {
> > > >   #define CPUID_1F_ECX_TOPO_LEVEL_INVALID  CPUID_B_ECX_TOPO_LEVEL_INVALID
> > > >   #define CPUID_1F_ECX_TOPO_LEVEL_SMT      CPUID_B_ECX_TOPO_LEVEL_SMT
> > > >   #define CPUID_1F_ECX_TOPO_LEVEL_CORE     CPUID_B_ECX_TOPO_LEVEL_CORE
> > > > +#define CPUID_1F_ECX_TOPO_LEVEL_MODULE   3
> > > >   #define CPUID_1F_ECX_TOPO_LEVEL_DIE      5
> > > >
> > > >   /* MSR Feature Bits */
> > > > diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> > > > index 4ce80555b45c..e5ddb214cb36 100644
> > > > --- a/target/i386/kvm/kvm.c
> > > > +++ b/target/i386/kvm/kvm.c
> > > > @@ -1913,7 +1913,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
> > > >               break;
> > > >           }
> > > >           case 0x1f:
> > > > -            if (env->nr_dies < 2) {
> > > > +            if (env->nr_modules < 2 && env->nr_dies < 2) {
> > > >                   break;
> > > >               }
> > > >               /* fallthrough */
> > > > --
> > > > 2.34.1
> > > >
> > > >
> >
>

