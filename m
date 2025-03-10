Return-Path: <kvm+bounces-40568-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1686BA58BC3
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 06:54:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CBE9D3A8F8D
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 05:54:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EE3B1C760D;
	Mon, 10 Mar 2025 05:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aAcG5Seo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A16CE1B4153
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 05:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741586089; cv=none; b=m83QHc9X+v4qtxAlwDBhFpsCepjxrmav9B/SlTO0UTv8cqGO67v765OeYtBZEs6jdnhFv95lJCkv6zHH6F3QQRH0xlc5LnkImq3HsKRDhEUZJVm3MGr1WfkEYKp2PufgT8iMF0PblIDQrY6OUURi4++GaxWK9Hn+dR8+z77RELM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741586089; c=relaxed/simple;
	bh=1if8kCzFykxRHlFQsVAw9s4TMtD6YxgLSUGTBrtLggo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ST/8TAA3x1CjnveSbmERa2NqJoEAjtDP7dYYa/doiIirX5WTHcmnIGStcxYnK+QXHFDqa7cdm7zbrNLg6mIJAQzAijz5NyC09VDe06efomnmQoWUHPZyupv57CvUTTSPDqEQHEnx5p1wm4/qkcNKvHKoVKCU/9HU5/YAenn4NpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aAcG5Seo; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741586087; x=1773122087;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=1if8kCzFykxRHlFQsVAw9s4TMtD6YxgLSUGTBrtLggo=;
  b=aAcG5Seo02/7d22uOviErey5i/HRphJOhH+XJsIaGJ1giJJRwTMtpwvn
   gv3nTyenT02rGMGoYVFLASg7e508M5fSoJlNIJroniR4NRTlKhhHmiiW2
   /iMlxPnc0pxHKLNveXxm7vJRVu4VgsfK6wfVE83Kvs+oVr4OZICpNEub1
   hWYiQiaiR7pf09Xn66gOETttzTysO0s1j2/oDZN6NGPWG2WcI6+rO/eTv
   xHj5SpNFxGRdMjx7ZUkpW5568NWXUaDSnk/tsj7+S6IaBebS4RjUVeOV7
   MlwyVfnGsQjXtMm2myjvISXwfvlRWLXRPCfxyt+3j8F9NBpikzx91D0CY
   g==;
X-CSE-ConnectionGUID: BnJd0/RgQnywTSjuVnaMlg==
X-CSE-MsgGUID: LKjW9TkuREONgctG1BT7jQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11368"; a="59974669"
X-IronPort-AV: E=Sophos;i="6.14,235,1736841600"; 
   d="scan'208";a="59974669"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2025 22:54:46 -0700
X-CSE-ConnectionGUID: KBvqclvjRFqWgIt2V7Es1w==
X-CSE-MsgGUID: WqZ6P5YMQxCmvukuV2rF9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,235,1736841600"; 
   d="scan'208";a="150828926"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa001.fm.intel.com with ESMTP; 09 Mar 2025 22:54:43 -0700
Date: Mon, 10 Mar 2025 14:14:52 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Dongli Zhang <dongli.zhang@oracle.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, pbonzini@redhat.com,
	mtosatti@redhat.com, sandipan.das@amd.com, babu.moger@amd.com,
	likexu@tencent.com, like.xu.linux@gmail.com,
	zhenyuw@linux.intel.com, groug@kaod.org, khorenko@virtuozzo.com,
	alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
	davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
	dapeng1.mi@linux.intel.com, joe.jin@oracle.com
Subject: Re: [PATCH v2 07/10] target/i386/kvm: query kvm.enable_pmu parameter
Message-ID: <Z86DXK0MAuC+mP/Y@intel.com>
References: <20250302220112.17653-1-dongli.zhang@oracle.com>
 <20250302220112.17653-8-dongli.zhang@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250302220112.17653-8-dongli.zhang@oracle.com>

On Sun, Mar 02, 2025 at 02:00:15PM -0800, Dongli Zhang wrote:
> Date: Sun,  2 Mar 2025 14:00:15 -0800
> From: Dongli Zhang <dongli.zhang@oracle.com>
> Subject: [PATCH v2 07/10] target/i386/kvm: query kvm.enable_pmu parameter
> X-Mailer: git-send-email 2.43.5
> 
> There is no way to distinguish between the following scenarios:
> 
> (1) KVM_CAP_PMU_CAPABILITY is not supported.
> (2) KVM_CAP_PMU_CAPABILITY is supported but disabled via the module
> parameter kvm.enable_pmu=N.
> 
> In scenario (1), there is no way to fully disable AMD PMU virtualization.
> 
> In scenario (2), PMU virtualization is completely disabled by the KVM
> module.

KVM_CAP_PMU_CAPABILITY is introduced since ba7bb663f554 ("KVM: x86:
Provide per VM capability for disabling PMU virtualization") in v5.18,
so I understand you want to handle the old linux before v5.18.

Let's sort out all the cases:

1) v5.18 and after, if the parameter "enable_pmu" is Y and then
   KVM_CAP_PMU_CAPABILITY exists, so everything could work.

2) v5.18 and after, "enable_pmu" is N and then KVM_CAP_PMU_CAPABILITY
   doesn't exist, QEMU needs to helpe user disable vPMU.

3) v5.17 (since "enable_pmu" is introduced in v5.17 since 4732f2444acd
   ("KVM: x86: Making the module parameter of vPMU more common")),
   there's no KVM_CAP_PMU_CAPABILITY and vPMU enablement depends on
   "enable_pmu". QEMU's enable_pmu option should depend on kvm
   parameter.

4) before v5.17, there's no "enable_pmu" so that there's no way to
   fully disable AMD PMU.

IIUC, you want to distinguish 2) and 3). And your current codes won't
break old kernels on 4) because "kvm_pmu_disabled" defaults false.
Therefore, overall the idea of this patch is good for me.

But IMO, the logics all above can be compatible by:

 * First check the KVM_CAP_PMU_CAPABILITY,
 * Only if KVM_CAP_PMU_CAPABILITY doesn't exist, then check the kvm parameter

...instead of always checking the parameter as you are currently doing.

What about this change? :-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 4902694129f9..9a6044e41a82 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -2055,13 +2055,34 @@ int kvm_arch_pre_create_vcpu(CPUState *cpu, Error **errp)
          * behavior on Intel platform because current "pmu" property works
          * as expected.
          */
-        if (has_pmu_cap && !X86_CPU(cpu)->enable_pmu) {
-            ret = kvm_vm_enable_cap(kvm_state, KVM_CAP_PMU_CAPABILITY, 0,
-                                    KVM_PMU_CAP_DISABLE);
-            if (ret < 0) {
-                error_setg_errno(errp, -ret,
-                                 "Failed to set KVM_PMU_CAP_DISABLE");
-                return ret;
+        if (has_pmu_cap) {
+            if (!X86_CPU(cpu)->enable_pmu) {
+                ret = kvm_vm_enable_cap(kvm_state, KVM_CAP_PMU_CAPABILITY, 0,
+                                        KVM_PMU_CAP_DISABLE);
+                if (ret < 0) {
+                    error_setg_errno(errp, -ret,
+                                     "Failed to set KVM_PMU_CAP_DISABLE");
+                    return ret;
+                }
+            }
+        } else {
+            /*
+             * KVM_CAP_PMU_CAPABILITY is introduced in Linux v5.18. For old linux,
+             * we have to check enable_pmu parameter for vPMU support.
+             */
+            g_autofree char *kvm_enable_pmu;
+
+            /*
+             * The kvm.enable_pmu's permission is 0444. It does not change until a
+             * reload of the KVM module.
+             */
+            if (g_file_get_contents("/sys/module/kvm/parameters/enable_pmu",
+                &kvm_enable_pmu, NULL, NULL)) {
+                if (*kvm_enable_pmu == 'N' && !X86_CPU(cpu)->enable_pmu) {
+                    error_setg(errp, "Failed to enable PMU since "
+                               "KVM's enable_pmu parameter is disabled");
+                    return -1;
+                }
             }
         }
     }

---

This example not only eliminates the static variable ¡°kvm_pmu_disabled¡±,
but also explicitly informs the user that vPMU is not available and
QEMU's "pmu" option doesn't work.

As a comparison, your patch 8 actually "silently" disables PMU (in the
kvm_init_pmu_info()) and user can only find it in Guest through PMU
exceptions.

Thanks,
Zhao



