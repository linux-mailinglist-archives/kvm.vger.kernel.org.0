Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37C576D144D
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 02:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbjCaAqN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 20:46:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbjCaAqL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 20:46:11 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC45D1025B;
        Thu, 30 Mar 2023 17:46:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680223567; x=1711759567;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   mime-version:in-reply-to;
  bh=QgFBf5KEbvkFkKbkudg8nlxCme0ew/oJPmuhMpk05hA=;
  b=TxIvtsbexl82jFiVp6+iAXXoi8l6sJMK4ucWEQvpJD6ZDZUb0CaO57j2
   AJg7tmKnxVtZetvHGWKgG+0hAnauRejGahTEc5ueTGm30xr3iMqZ4olkA
   BWQbp487HNeVvE/R00cBT8d9rpiw16tmG1ccc6XdDqm/rE3kFKZRyLiH5
   uIY9BK+edtrafnSVrFgaaQFkTF/U27fB0aJZkbX4Chx24XaOoCkw02cYH
   OkMqDW6Ad+irYElNwmo/FxlkOOrZ/y9QCO4j/O5rtYGhc/d6en0izjy4q
   alynq+axf7XKAwKzRVX8pyIbM3cXpdEo6N86CCr0afOLKVjrTfMIr1oHr
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="329845695"
X-IronPort-AV: E=Sophos;i="5.98,306,1673942400"; 
   d="asc'?scan'208";a="329845695"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2023 17:46:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="715221850"
X-IronPort-AV: E=Sophos;i="5.98,306,1673942400"; 
   d="asc'?scan'208";a="715221850"
Received: from debian-skl.sh.intel.com (HELO debian-skl) ([10.239.160.45])
  by orsmga008.jf.intel.com with ESMTP; 30 Mar 2023 17:46:03 -0700
Date:   Fri, 31 Mar 2023 08:43:29 +0800
From:   Zhenyu Wang <zhenyuw@linux.intel.com>
To:     "Liang, Kan" <kan.liang@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        CodyYao-oc <CodyYao-oc@zhaoxin.com>
Subject: Re: [PATCH v3] perf/x86: use hexidecimal value for cpuid
Message-ID: <ZCYssdebU2L+f4YC@debian-scheme>
Reply-To: Zhenyu Wang <zhenyuw@linux.intel.com>
References: <20230312132633.228006-1-zhenyuw@linux.intel.com>
 <20230322053746.4888-1-zhenyuw@linux.intel.com>
 <e60623a4-57e1-dde6-1c76-d9c7f956d3f1@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="OqhR5S+cgao2dAmZ"
Content-Disposition: inline
In-Reply-To: <e60623a4-57e1-dde6-1c76-d9c7f956d3f1@linux.intel.com>
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--OqhR5S+cgao2dAmZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


On 2023.03.24 09:33:19 -0400, Liang, Kan wrote:
>

sorry that I missed this one in my inbox...

> On 2023-03-22 1:37 a.m., Zhenyu Wang wrote:
> > It's easier to use hexidecimal value instead of decimal for reading
> > and following with SDM doc, also align with other cpuid calls. As new
> > cpuid leaf would be added in future, this tries to convert current
> > forms and would take it as convention for new leaf definition.
> >=20
> > This changes name for both cpuid type and cpuid calls.
>=20
> It seems the patch touches 3 CPUIDs, 0xa, 0x1c and 0x14, right?
> The patch also crosses several different subsystems and drivers.
> I think it may be better to divide the patch by CPUID. Each patch to
> handle one CPUID. It's easier for review.

ok, I can do that.

>=20
> Also, can you please add a macro for the CPUID leaf number?
> Please refer ARCH_PERFMON_EXT_LEAF (0x23).
>

As originally the purpose of this change is to use hex value in cpuid
call and struct name, good to see that use for 0x23.  If define every
macro for these, e.g ARCH_PERFMON_LEAF(0xa), PT_LEAF(0x14),
LBR_LEAF(0x1c), struct name needs change too?  As in context of what
source file you're reading, you already get idea what these cpuid
numbers are for what kind of leaf...

>=20
> >=20
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> > Cc: Mark Rutland <mark.rutland@arm.com>
> > Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> > Cc: Jiri Olsa <jolsa@kernel.org>
> > Cc: Namhyung Kim <namhyung@kernel.org>
> > Cc: Kan Liang <kan.liang@linux.intel.com>
> > Cc: CodyYao-oc <CodyYao-oc@zhaoxin.com>
> > Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
> > ---
> > v3:
> > - add more explanation in commit message for purpose of this
> > - use lowercase number in call to align with current code
> >=20
> > v2:
> > - rename in cpuid data type as well
> >=20
> >  arch/x86/events/intel/core.c      | 10 +++++-----
> >  arch/x86/events/intel/lbr.c       |  8 ++++----
> >  arch/x86/events/intel/pt.c        |  2 +-
> >  arch/x86/events/zhaoxin/core.c    |  8 ++++----
> >  arch/x86/include/asm/perf_event.h | 12 ++++++------
> >  arch/x86/kvm/cpuid.c              |  4 ++--
> >  arch/x86/kvm/vmx/pmu_intel.c      |  4 ++--
> >  7 files changed, 24 insertions(+), 24 deletions(-)
> >=20
> > diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
> > index a3fb996a86a1..5487a39d4975 100644
> > --- a/arch/x86/events/intel/core.c
> > +++ b/arch/x86/events/intel/core.c
> > @@ -5170,7 +5170,7 @@ static __init void intel_arch_events_quirk(void)
> > =20
> >  static __init void intel_nehalem_quirk(void)
> >  {
> > -	union cpuid10_ebx ebx;
> > +	union cpuid_0xa_ebx ebx;
> > =20
> >  	ebx.full =3D x86_pmu.events_maskl;
> >  	if (ebx.split.no_branch_misses_retired) {
> > @@ -5878,9 +5878,9 @@ __init int intel_pmu_init(void)
> >  	struct attribute **td_attr    =3D &empty_attrs;
> >  	struct attribute **mem_attr   =3D &empty_attrs;
> >  	struct attribute **tsx_attr   =3D &empty_attrs;
> > -	union cpuid10_edx edx;
> > -	union cpuid10_eax eax;
> > -	union cpuid10_ebx ebx;
> > +	union cpuid_0xa_edx edx;
> > +	union cpuid_0xa_eax eax;
> > +	union cpuid_0xa_ebx ebx;
> >  	unsigned int fixed_mask;
> >  	bool pmem =3D false;
> >  	int version, i;
> > @@ -5903,7 +5903,7 @@ __init int intel_pmu_init(void)
> >  	 * Check whether the Architectural PerfMon supports
> >  	 * Branch Misses Retired hw_event or not.
> >  	 */
> > -	cpuid(10, &eax.full, &ebx.full, &fixed_mask, &edx.full);
> > +	cpuid(0xa, &eax.full, &ebx.full, &fixed_mask, &edx.full);
> >  	if (eax.split.mask_length < ARCH_PERFMON_EVENTS_COUNT)
> >  		return -ENODEV;
> > =20
> > diff --git a/arch/x86/events/intel/lbr.c b/arch/x86/events/intel/lbr.c
> > index c3b0d15a9841..616a6904af03 100644
> > --- a/arch/x86/events/intel/lbr.c
> > +++ b/arch/x86/events/intel/lbr.c
> > @@ -1497,16 +1497,16 @@ static bool is_arch_lbr_xsave_available(void)
> >  void __init intel_pmu_arch_lbr_init(void)
> >  {
> >  	struct pmu *pmu =3D x86_get_pmu(smp_processor_id());
> > -	union cpuid28_eax eax;
> > -	union cpuid28_ebx ebx;
> > -	union cpuid28_ecx ecx;
> > +	union cpuid_0x1c_eax eax;
> > +	union cpuid_0x1c_ebx ebx;
> > +	union cpuid_0x1c_ecx ecx;
> >  	unsigned int unused_edx;
> >  	bool arch_lbr_xsave;
> >  	size_t size;
> >  	u64 lbr_nr;
> > =20
> >  	/* Arch LBR Capabilities */
> > -	cpuid(28, &eax.full, &ebx.full, &ecx.full, &unused_edx);
> > +	cpuid(0x1c, &eax.full, &ebx.full, &ecx.full, &unused_edx);
> > =20
> >  	lbr_nr =3D fls(eax.split.lbr_depth_mask) * 8;
> >  	if (!lbr_nr)
> > diff --git a/arch/x86/events/intel/pt.c b/arch/x86/events/intel/pt.c
> > index 42a55794004a..da3c5d748365 100644
> > --- a/arch/x86/events/intel/pt.c
> > +++ b/arch/x86/events/intel/pt.c
> > @@ -235,7 +235,7 @@ static int __init pt_pmu_hw_init(void)
> >  	}
> > =20
> >  	for (i =3D 0; i < PT_CPUID_LEAVES; i++) {
> > -		cpuid_count(20, i,
> > +		cpuid_count(0x14, i,
> >  			    &pt_pmu.caps[CPUID_EAX + i*PT_CPUID_REGS_NUM],
> >  			    &pt_pmu.caps[CPUID_EBX + i*PT_CPUID_REGS_NUM],
> >  			    &pt_pmu.caps[CPUID_ECX + i*PT_CPUID_REGS_NUM],
> > diff --git a/arch/x86/events/zhaoxin/core.c b/arch/x86/events/zhaoxin/c=
ore.c
> > index 3e9acdaeed1e..1d071974f4db 100644
> > --- a/arch/x86/events/zhaoxin/core.c
> > +++ b/arch/x86/events/zhaoxin/core.c
> > @@ -504,9 +504,9 @@ static __init void zhaoxin_arch_events_quirk(void)
> > =20
> >  __init int zhaoxin_pmu_init(void)
> >  {
> > -	union cpuid10_edx edx;
> > -	union cpuid10_eax eax;
> > -	union cpuid10_ebx ebx;
> > +	union cpuid_0xa_edx edx;
> > +	union cpuid_0xa_eax eax;
> > +	union cpuid_0xa_ebx ebx;
> >  	struct event_constraint *c;
> >  	unsigned int unused;
> >  	int version;
> > @@ -517,7 +517,7 @@ __init int zhaoxin_pmu_init(void)
> >  	 * Check whether the Architectural PerfMon supports
> >  	 * hw_event or not.
> >  	 */
> > -	cpuid(10, &eax.full, &ebx.full, &unused, &edx.full);
> > +	cpuid(0xa, &eax.full, &ebx.full, &unused, &edx.full);
> > =20
> >  	if (eax.split.mask_length < ARCH_PERFMON_EVENTS_COUNT - 1)
> >  		return -ENODEV;
> > diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/p=
erf_event.h
> > index 8fc15ed5e60b..0d2d735c8167 100644
> > --- a/arch/x86/include/asm/perf_event.h
> > +++ b/arch/x86/include/asm/perf_event.h
> > @@ -125,7 +125,7 @@
> >   * Intel "Architectural Performance Monitoring" CPUID
> >   * detection/enumeration details:
> >   */
> > -union cpuid10_eax {
> > +union cpuid_0xa_eax {
> >  	struct {
> >  		unsigned int version_id:8;
> >  		unsigned int num_counters:8;
> > @@ -135,7 +135,7 @@ union cpuid10_eax {
> >  	unsigned int full;
> >  };
> > =20
> > -union cpuid10_ebx {
> > +union cpuid_0xa_ebx {
> >  	struct {
> >  		unsigned int no_unhalted_core_cycles:1;
> >  		unsigned int no_instructions_retired:1;
> > @@ -148,7 +148,7 @@ union cpuid10_ebx {
> >  	unsigned int full;
> >  };
> > =20
> > -union cpuid10_edx {
> > +union cpuid_0xa_edx {
> >  	struct {
> >  		unsigned int num_counters_fixed:5;
> >  		unsigned int bit_width_fixed:8;
> > @@ -170,7 +170,7 @@ union cpuid10_edx {
> >  /*
> >   * Intel Architectural LBR CPUID detection/enumeration details:
> >   */
> > -union cpuid28_eax {
> > +union cpuid_0x1c_eax {
> >  	struct {
> >  		/* Supported LBR depth values */
> >  		unsigned int	lbr_depth_mask:8;
> > @@ -183,7 +183,7 @@ union cpuid28_eax {
> >  	unsigned int		full;
> >  };
> > =20
> > -union cpuid28_ebx {
> > +union cpuid_0x1c_ebx {
> >  	struct {
> >  		/* CPL Filtering Supported */
> >  		unsigned int    lbr_cpl:1;
> > @@ -195,7 +195,7 @@ union cpuid28_ebx {
> >  	unsigned int            full;
> >  };
> > =20
> > -union cpuid28_ecx {
> > +union cpuid_0x1c_ecx {
> >  	struct {
> >  		/* Mispredict Bit Supported */
> >  		unsigned int    lbr_mispred:1;
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index 599aebec2d52..57f43dc87538 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -967,8 +967,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_=
array *array, u32 function)
> >  		}
> >  		break;
> >  	case 0xa: { /* Architectural Performance Monitoring */
> > -		union cpuid10_eax eax;
> > -		union cpuid10_edx edx;
> > +		union cpuid_0xa_eax eax;
> > +		union cpuid_0xa_edx edx;
> > =20
> >  		if (!static_cpu_has(X86_FEATURE_ARCH_PERFMON)) {
> >  			entry->eax =3D entry->ebx =3D entry->ecx =3D entry->edx =3D 0;
> > diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> > index e8a3be0b9df9..f4b165667ca9 100644
> > --- a/arch/x86/kvm/vmx/pmu_intel.c
> > +++ b/arch/x86/kvm/vmx/pmu_intel.c
> > @@ -512,8 +512,8 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
> >  	struct kvm_pmu *pmu =3D vcpu_to_pmu(vcpu);
> >  	struct lbr_desc *lbr_desc =3D vcpu_to_lbr_desc(vcpu);
> >  	struct kvm_cpuid_entry2 *entry;
> > -	union cpuid10_eax eax;
> > -	union cpuid10_edx edx;
> > +	union cpuid_0xa_eax eax;
> > +	union cpuid_0xa_edx edx;
> >  	u64 perf_capabilities;
> >  	u64 counter_mask;
> >  	int i;

--OqhR5S+cgao2dAmZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQTXuabgHDW6LPt9CICxBBozTXgYJwUCZCYsrAAKCRCxBBozTXgY
J+HQAJ9BaeUPH5+lbVl1Og8ByKoED0uO+QCeJO0IaXDlYDlE7uMrvW1zJh6qMBc=
=DWEN
-----END PGP SIGNATURE-----

--OqhR5S+cgao2dAmZ--
