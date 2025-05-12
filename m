Return-Path: <kvm+bounces-46147-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 76B1BAB3287
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 11:00:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 01072189C876
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 09:00:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13E4325A325;
	Mon, 12 May 2025 08:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HAxHghDU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DEA025A2A6;
	Mon, 12 May 2025 08:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747040264; cv=none; b=cSTtPvAxCpDNw0Q5Y1aoiEPYC6Dqk6UxNoERUHzv6YBiqDN5SN0NsZaott0HOExMB593Sdrf6s6e8siwIIaxYd45o3wPvCxl5CPXt5TC9tV+B0tU7DSExyz6ZCipfV5OOAJhEbRRXfBw3cd8+RGVlImwPcbGS+n/d224BEYQqzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747040264; c=relaxed/simple;
	bh=2hwfJlxtKCrmA/U7kWwtPfgBIj+XASaD+BQF4ujJlQA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=h42AfwNpSPWyGm5+Vp/zWzgoKaq58B253Z83vXQuYZWrB76bfQyMIUMrQMWqQkSeAhuu0fj3ewsZvjIbTfhL9DIDObB4TZDLZ8gkeQwmj6Hz3m+iYo284Z5l9UAxHRjGRGNa1wx+aEGA0d/w9vUpv6oKNfSRIBpRnl4bILlwLxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HAxHghDU; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747040263; x=1778576263;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=2hwfJlxtKCrmA/U7kWwtPfgBIj+XASaD+BQF4ujJlQA=;
  b=HAxHghDUOaW68hwHyh1oFRGkoAr3TGUroI9Mp8PXB3Wfn1GI4kJFRzN0
   lMV7QnGct5Vds2gvjPY0/cvueQXafhPMtp81JGboUiVF8bzMYslnf0RBT
   mZzmFZs8X1TK2sRIz9NK8dYnudEsJu/SOtHOYUHGXqz4S4v8uylTZZnuo
   WWExptrXFlsmDpqWyNzkJMJlgMINWD/QGZ1r3KUD22zCpiFDVYcXP2gIT
   t3caZoMO9hTskzKA0v75Qs5GxGqVxLoyXNK5FE9YCw9sDO1KQLsqzj113
   +j7mF5SfXMQyC/S28RmpeMTeptJSC4pDikYX79E1+8AtpYYE5++HmQ5Gh
   w==;
X-CSE-ConnectionGUID: +FkhSPRTS9ueuzqfBd6ysA==
X-CSE-MsgGUID: i0xJIGAJSSuOHrc0/huFQg==
X-IronPort-AV: E=McAfee;i="6700,10204,11430"; a="59488677"
X-IronPort-AV: E=Sophos;i="6.15,281,1739865600"; 
   d="scan'208";a="59488677"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2025 01:57:42 -0700
X-CSE-ConnectionGUID: rC1bDCljTv+3nTsch+G/Xg==
X-CSE-MsgGUID: ZDoCbOdQS/uiChmcW5EFKA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,281,1739865600"; 
   d="scan'208";a="138235770"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2025 01:57:42 -0700
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
Subject: [PATCH v7 0/6] Introduce CET supervisor state support
Date: Mon, 12 May 2025 01:57:03 -0700
Message-ID: <20250512085735.564475-1-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Dear maintainers and reviewers,

I kindly request your consideration for merging this series. Most of
patches have received Reviewed-by/Acked-by tags.

Thanks Chang, Rick, Xin, Sean and Dave for their help with this series.

== Changelog ==
v6->v7:
 - Collect reviews from Rick
 - Tweak __fpstate_reset() to handle guest fpstate rather than adding a
   guest-specific reset function (Sean & Dave)
 - Fold xfd initialization into __fpstate_reset() (Sean)
 - v6: https://lore.kernel.org/all/20250506093740.2864458-1-chao.gao@intel.com/

== Background ==

CET defines two register states: CET user, which includes user-mode control
registers, and CET supervisor, which consists of shadow-stack pointers for
privilege levels 0-2.

Current kernel disables shadow stacks in kernel mode, making the CET
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
  x86/fpu/xstate: Differentiate default features for host and guest FPUs
  x86/fpu: Initialize guest FPU permissions from guest defaults
  x86/fpu: Initialize guest fpstate and FPU pseudo container from guest
    defaults
  x86/fpu: Remove xfd argument from __fpstate_reset()

Yang Weijiang (2):
  x86/fpu/xstate: Introduce "guest-only" supervisor xfeature set
  x86/fpu/xstate: Add CET supervisor xfeature support as a guest-only
    feature

 arch/x86/include/asm/fpu/types.h  | 49 +++++++++++++++++++++++++++----
 arch/x86/include/asm/fpu/xstate.h |  9 ++++--
 arch/x86/kernel/fpu/core.c        | 49 ++++++++++++++++++++++---------
 arch/x86/kernel/fpu/init.c        |  1 +
 arch/x86/kernel/fpu/xstate.c      | 40 ++++++++++++++++++++-----
 arch/x86/kernel/fpu/xstate.h      |  5 ++++
 6 files changed, 123 insertions(+), 30 deletions(-)

-- 
2.47.1


