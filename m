Return-Path: <kvm+bounces-45572-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 365E8AABF8E
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 11:33:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9E8181C21804
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 09:33:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B96DD267389;
	Tue,  6 May 2025 09:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Uz65PTqt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08CE81E1DE2;
	Tue,  6 May 2025 09:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746523959; cv=none; b=IKdOJqKVFaY/GWNdfr29dFrlnv91/HP1dn2k+7jVt15OpLfyFrHG/naE8oJIJsUj94PqJ63Pcfpw2Cvk/vlix3YnP4kKaW1s6/oLoS7DZ7kf48fYLNjjvx2VXUgTmkN3D9vkSx/MSYXZwNNAs8YHwVVO8KPOUR4j9pw3FLUBtGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746523959; c=relaxed/simple;
	bh=lwvJDDzJgpyzMN5j7nMzyRWTpYCN76lyhJW88Ipl7E4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=hEXiTQ6Gpco/1Uy+Svit5RM/5zJmcS5Exjyhpa/jVlUBVsqyqTuLIkeFJvPPiszE0cSCCiOkSkFoVF4DE6YVQ97pQI7bgbEWaHm2d69Z4YV+67+GkPeGqA2nxkZ1nSeY4OcO32l9llVRvqBfiDLBIJndBCsn5g86gur3QYRb9k0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Uz65PTqt; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746523958; x=1778059958;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=lwvJDDzJgpyzMN5j7nMzyRWTpYCN76lyhJW88Ipl7E4=;
  b=Uz65PTqt/CiwJZfFSag3Zu5M/h6Ri2DskvYsq87WOmzF7uPZzqOTYGTo
   II+JX1BUQwKHHF4ChST+x74WNjKycKQFTuusz2yp0LxTag8k0Z2SmyZYK
   earhNlrr9ZuXBYqF+dQonwkJWbA7n08HiDEgJZybY0syY4ekILKAaoBj/
   gb3P4R4Xrg6Zzd5wSlgK7xzT6d/pwb1xFwWRYR4zzRKbkO2ykPhmGiaJZ
   ECnkQKH5WhRKwA6mIGSyQ6Zsw/kkaQa/2lq6Pgv0vodaTvphrl1ZF6gLc
   9RXXpvkq2iquV9qZr4TAvvIrVfi4oU3uSjHk/svDfmHm2e2FWPJgZErdx
   Q==;
X-CSE-ConnectionGUID: 3wIApTs/QBe3rY0Mf/5gOg==
X-CSE-MsgGUID: TSiaNCvURgy/Wd+OE244TQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11424"; a="35800272"
X-IronPort-AV: E=Sophos;i="6.15,266,1739865600"; 
   d="scan'208";a="35800272"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2025 02:32:37 -0700
X-CSE-ConnectionGUID: ezp0KobZT36Ug7UFYV0HtA==
X-CSE-MsgGUID: Dky+NdxbTnivGhJzBRu53g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,266,1739865600"; 
   d="scan'208";a="135446779"
Received: from spr.sh.intel.com ([10.239.53.19])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2025 02:32:30 -0700
From: Chao Gao <chao.gao@intel.com>
To: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	tglx@linutronix.de,
	dave.hansen@intel.com,
	seanjc@google.com,
	pbonzini@redhat.com
Cc: peterz@infradead.org,
	rick.p.edgecombe@intel.com,
	weijiang.yang@intel.com,
	john.allen@amd.com,
	bp@alien8.de,
	chang.seok.bae@intel.com,
	xin3.li@intel.com,
	Chao Gao <chao.gao@intel.com>,
	Aruna Ramakrishna <aruna.ramakrishna@oracle.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Eric Biggers <ebiggers@google.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	Kees Cook <kees@kernel.org>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Mitchell Levy <levymitchell0@gmail.com>,
	Nikolay Borisov <nik.borisov@suse.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Samuel Holland <samuel.holland@sifive.com>,
	Sohil Mehta <sohil.mehta@intel.com>,
	Stanislav Spassov <stanspas@amazon.de>,
	Uros Bizjak <ubizjak@gmail.com>,
	Vignesh Balasubramanian <vigbalas@amd.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v6 0/7] Introduce CET supervisor state support
Date: Tue,  6 May 2025 17:36:05 +0800
Message-ID: <20250506093740.2864458-1-chao.gao@intel.com>
X-Mailer: git-send-email 2.46.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Dear maintainers and reviewers,

I kindly request your consideration for merging this series. The changes
between v5 (posted one month ago) and v6 are minimal, and most of the
patches have received Reviewed-by/Acked-by tags.

Thanks Chang, Rick, Xin and Sean for their help with this series.

== Changelog ==
v5->v6:
 - Collect reviews from Chang and Rick
 - Reset guest default size to FPU legacy size when XSAVE is not available
   or not enabled (Chang)
 - Drop guest default user features and size, as they will not differ from
   host FPUs (Rick)
 - v5: https://lore.kernel.org/kvm/20250410072605.2358393-1-chao.gao@intel.com/

== Background ==

CET defines two register states: CET user, which includes user-mode control
registers, and CET supervisor, which consists of shadow-stack pointers for
privilege levels 0-2.

Current kernels disable shadow stacks in kernel mode, making the CET
supervisor state unused and eliminating the need for context switching.

== Problem ==

To virtualize CET for guests, KVM must accurately emulate hardware
behavior. A key challenge arises because there is no CPUID flag to indicate
that shadow stack is supported only in user mode. Therefore, KVM cannot
assume guests will not enable shadow stacks in kernel mode and must
preserve the CET supervisor state of vCPUs.

== Solution ==

An initial proposal to manually save and restore CET supervisor states
using raw RDMSR/WRMSR in KVM was rejected due to performance concerns and
its impact on KVM's ABI. Instead, leveraging the kernel's FPU
infrastructure for context switching was favored [1].

The main question then became whether to enable the CET supervisor state
globally for all processes or restrict it to vCPU processes. This decision
involves a trade-off between a 24-byte XSTATE buffer waste for all non-vCPU
processes and approximately 100 lines of code complexity in the kernel [2].
The agreed approach is to first try this optimal solution [3], i.e.,
restricting the CET supervisor state to guest FPUs only and eliminating
unnecessary space waste.

Key changes in this series are:

1) Fix existing issue regarding enabling guest supervisor states support.
2) Add default features and size for guest FPUs.
3) Add infrastructure to support guest-only features.
4) Add CET supervisor state as the first guest-only feature.

With the series in place, guest FPUs have xstate_bv[12] == xcomp_bv[12] == 1
and CET supervisor state is saved/reloaded when xsaves/xrstors executes on
guest FPUs. non-guest FPUs have xstate_bv[12] == xcomp_bv[12] == 0, then
CET supervisor state is not saved/restored.

== Performance ==

We measured context-switching performance with the benchmark [4] in following
three cases.

case 1: the baseline. i.e., this series isn't applied
case 2: baseline + this series. CET-S space is allocated for guest fpu only.
case 3: baseline + allocate CET-S space for all tasks. Hardware init
        optimization avoids writing out CET-S space on each XSAVES.

The performance differences in the three cases are very small and fall within the
run-to-run variation.

[1]: https://lore.kernel.org/kvm/ZM1jV3UPL0AMpVDI@google.com/
[2]: https://lore.kernel.org/kvm/1c2fd06e-2e97-4724-80ab-8695aa4334e7@intel.com/
[3]: https://lore.kernel.org/kvm/2597a87b-1248-b8ce-ce60-94074bc67ea4@intel.com/
[4]: https://github.com/antonblanchard/will-it-scale/blob/master/tests/context_switch1.c

Chao Gao (4):
  x86/fpu: Drop @perm from guest pseudo FPU container
  x86/fpu/xstate: Differentiate default features for host and guest FPUs
  x86/fpu: Initialize guest FPU permissions from guest defaults
  x86/fpu: Initialize guest fpstate and FPU pseudo container from guest
    defaults

Sean Christopherson (1):
  x86/fpu/xstate: Always preserve non-user xfeatures/flags in
    __state_perm

Yang Weijiang (2):
  x86/fpu/xstate: Introduce "guest-only" supervisor xfeature set
  x86/fpu/xstate: Add CET supervisor xfeature support as a guest-only
    feature

 arch/x86/include/asm/fpu/types.h  | 64 +++++++++++++++++++++++--------
 arch/x86/include/asm/fpu/xstate.h |  9 +++--
 arch/x86/kernel/fpu/core.c        | 46 +++++++++++++++-------
 arch/x86/kernel/fpu/init.c        |  1 +
 arch/x86/kernel/fpu/xstate.c      | 58 +++++++++++++++++++++-------
 arch/x86/kernel/fpu/xstate.h      |  5 +++
 6 files changed, 137 insertions(+), 46 deletions(-)


base-commit: 960bc2bcba5987a82530b9756e1f602a894cffa4
-- 
2.47.1


