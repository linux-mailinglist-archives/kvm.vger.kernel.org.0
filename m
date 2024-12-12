Return-Path: <kvm+bounces-33641-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C4BBB9EFA20
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 18:58:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 065E81892C79
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 17:53:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7BF7223C50;
	Thu, 12 Dec 2024 17:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IXYWIwdI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D88021421C
	for <kvm@vger.kernel.org>; Thu, 12 Dec 2024 17:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025973; cv=none; b=kuOO28OSmRHUrHz+MEhlifmmpxQ4knx4NdmZw0Axl8kpIUlwXU6QYe7f+4+TEgMH6PkeBc/VTScozrQTM056/U+zFCJPHQEs5iZHab7jGGo7Kw8rsHnGA4O8wQPfpFAYboCHeqeK79Wcxw6YwKzKQ4S+vcqZnH2zsNBH8zTengo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025973; c=relaxed/simple;
	bh=/D7194Ss/b+oJBhhO0FKkDLp1gnVp/0N2VBsO0P1xVw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fii3UiHfqCIbrZH+A4Ttt+KrSOdJqTFFprOpElMrLRlMufB9NM/6S4Fizy2vdGz1nwXY3eQ7IUKKjgSiM1hMgLnmVZEvRLB0+zt3OetD7x5tJ8Yw3GVTKX/yaFUw5h5PXHkyPQ0tUTWWxSMG1Rzhbrjd9vTMso1x3oEioeKDv+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IXYWIwdI; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734025970; x=1765561970;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/D7194Ss/b+oJBhhO0FKkDLp1gnVp/0N2VBsO0P1xVw=;
  b=IXYWIwdIEtD/KQA6rZqHJmItcX1E9w/7/YOj2zGImhVs4/U8gbOhtkxf
   h8Q17/uoj7YqE4Rm3vUu76oMvJMPCJTFmZroChJnM0ZU1SR+NGA/iEMDq
   LlL72RDIHZa0s3PGtHwkd6jMMqKzqALUENYl5JroARtLZhcvMHKO7hBAW
   DF9JBs8g79Dsx/G+kLU9rlYbK5uJK8qSBdaQmskeuI1tPyj0C40AV0DGt
   S7BtDOU5qV+43rqbyysiufS/EwoTwoS3V2AgQRedITHsNGYc/Lduj+Lag
   ULBHn6ysFxViu/qNWDcvNqhOiCm6EX+1gquNnPCxAQRvgFYgAmeTK/PW+
   Q==;
X-CSE-ConnectionGUID: CNWLvFqfQjyiOLSP0rNT3Q==
X-CSE-MsgGUID: 6KIi3U7YSY61gM6CspcXwg==
X-IronPort-AV: E=McAfee;i="6700,10204,11284"; a="34700257"
X-IronPort-AV: E=Sophos;i="6.12,229,1728975600"; 
   d="scan'208";a="34700257"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2024 09:52:49 -0800
X-CSE-ConnectionGUID: UIxZ9EhrT+2os9RG/KDzcQ==
X-CSE-MsgGUID: jxboOayXTd2VbDYvDAM1Xw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,229,1728975600"; 
   d="scan'208";a="96705388"
Received: from puneetse-mobl.amr.corp.intel.com (HELO localhost) ([10.125.110.112])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2024 09:52:47 -0800
Date: Thu, 12 Dec 2024 11:52:43 -0600
From: Ira Weiny <ira.weiny@intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Riku Voipio <riku.voipio@iki.fi>,
	Richard Henderson <richard.henderson@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	Cornelia Huck <cohuck@redhat.com>,
	Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, rick.p.edgecombe@intel.com,
	kvm@vger.kernel.org, qemu-devel@nongnu.org
Subject: Re: [PATCH v6 55/60] i386/tdx: Fetch and validate CPUID of TD guest
Message-ID: <Z1si66iUjsqCoUgL@iweiny-mobl>
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
 <20241105062408.3533704-56-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241105062408.3533704-56-xiaoyao.li@intel.com>

On Tue, Nov 05, 2024 at 01:24:03AM -0500, Xiaoyao Li wrote:
> Use KVM_TDX_GET_CPUID to get the CPUIDs that are managed and enfored
> by TDX module for TD guest. Check QEMU's configuration against the
> fetched data.
> 
> Print wanring  message when 1. a feature is not supported but requested
> by QEMU or 2. QEMU doesn't want to expose a feature while it is enforced
> enabled.
> 
> - If cpu->enforced_cpuid is not set, prints the warning message of both
> 1) and 2) and tweak QEMU's configuration.
> 
> - If cpu->enforced_cpuid is set, quit if any case of 1) or 2).

Patches 52, 53, 54, and this one should probably be squashed

53's commit message is non-existent and really only makes sense because the
function is used here.  52's commit message is pretty thin.  Both 52 and 53 are
used here, the size of this patch is not adversely affected, and the reason for
the changes are more clearly shown in this patch.

54 somewhat stands on its own.  But really it is just calling the functionality
of this patch.  So I don't see a big reason for it to be on its own but up to
you.

> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  target/i386/kvm/tdx.c | 81 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 81 insertions(+)
> 
> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
> index e7e0f073dfc9..9cb099e160e4 100644
> --- a/target/i386/kvm/tdx.c
> +++ b/target/i386/kvm/tdx.c
> @@ -673,6 +673,86 @@ static uint32_t tdx_adjust_cpuid_features(X86ConfidentialGuest *cg,
>      return value;
>  }
>  
> +
> +static void tdx_fetch_cpuid(CPUState *cpu, struct kvm_cpuid2 *fetch_cpuid)
> +{
> +    int r;
> +
> +    r = tdx_vcpu_ioctl(cpu, KVM_TDX_GET_CPUID, 0, fetch_cpuid);
> +    if (r) {
> +        error_report("KVM_TDX_GET_CPUID failed %s", strerror(-r));
> +        exit(1);
> +    }
> +}
> +
> +static int tdx_check_features(X86ConfidentialGuest *cg, CPUState *cs)
> +{
> +    uint64_t actual, requested, unavailable, forced_on;
> +    g_autofree struct kvm_cpuid2 *fetch_cpuid;
> +    const char *forced_on_prefix = NULL;
> +    const char *unav_prefix = NULL;
> +    struct kvm_cpuid_entry2 *entry;
> +    X86CPU *cpu = X86_CPU(cs);
> +    CPUX86State *env = &cpu->env;
> +    FeatureWordInfo *wi;
> +    FeatureWord w;
> +    bool mismatch = false;
> +
> +    fetch_cpuid = g_malloc0(sizeof(*fetch_cpuid) +
> +                    sizeof(struct kvm_cpuid_entry2) * KVM_MAX_CPUID_ENTRIES);

Is this a memory leak?  I don't see fetch_cpuid returned or free'ed.  If so, it
might be better to use g_autofree() for this allocation.

Alternatively, this allocation size is constant, could this be on the heap and
not allocated at all?  (I assume it is big enough that a stack allocation is
unwanted.)

Ira

> +    tdx_fetch_cpuid(cs, fetch_cpuid);
> +
> +    if (cpu->check_cpuid || cpu->enforce_cpuid) {
> +        unav_prefix = "TDX doesn't support requested feature";
> +        forced_on_prefix = "TDX forcibly sets the feature";
> +    }
> +
> +    for (w = 0; w < FEATURE_WORDS; w++) {
> +        wi = &feature_word_info[w];
> +        actual = 0;
> +
> +        switch (wi->type) {
> +        case CPUID_FEATURE_WORD:
> +            entry = cpuid_find_entry(fetch_cpuid, wi->cpuid.eax, wi->cpuid.ecx);
> +            if (!entry) {
> +                /*
> +                 * If KVM doesn't report it means it's totally configurable
> +                 * by QEMU
> +                 */
> +                continue;
> +            }
> +
> +            actual = cpuid_entry_get_reg(entry, wi->cpuid.reg);
> +            break;
> +        case MSR_FEATURE_WORD:
> +            /*
> +             * TODO:
> +             * validate MSR features when KVM has interface report them.
> +             */
> +            continue;
> +        }
> +
> +        requested = env->features[w];
> +        unavailable = requested & ~actual;
> +        mark_unavailable_features(cpu, w, unavailable, unav_prefix);
> +        if (unavailable) {
> +            mismatch = true;
> +        }
> +
> +        forced_on = actual & ~requested;
> +        mark_forced_on_features(cpu, w, forced_on, forced_on_prefix);
> +        if (forced_on) {
> +            mismatch = true;
> +        }
> +    }
> +
> +    if (cpu->enforce_cpuid && mismatch) {
> +        return -1;
> +    }
> +
> +    return 0;
> +}
> +
>  static int tdx_validate_attributes(TdxGuest *tdx, Error **errp)
>  {
>      if ((tdx->attributes & ~tdx_caps->supported_attrs)) {
> @@ -1019,4 +1099,5 @@ static void tdx_guest_class_init(ObjectClass *oc, void *data)
>      x86_klass->cpu_instance_init = tdx_cpu_instance_init;
>      x86_klass->cpu_realizefn = tdx_cpu_realizefn;
>      x86_klass->adjust_cpuid_features = tdx_adjust_cpuid_features;
> +    x86_klass->check_features = tdx_check_features;
>  }
> -- 
> 2.34.1
> 

