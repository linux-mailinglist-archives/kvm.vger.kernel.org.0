Return-Path: <kvm+bounces-40980-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DABA2A60139
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 20:30:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2A9EC1789B7
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 19:30:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99FCD1F30C7;
	Thu, 13 Mar 2025 19:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EU+WoIA1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296235464E;
	Thu, 13 Mar 2025 19:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741894231; cv=none; b=UblSNkXmpL8d/xKPdpPCpLDHmU3c/EDNiW1ECLNrB4/LIbA8IrJbtiRfduSmaCVt44Ap8e6WjQu7QqWawoDa0VeNDadAgved62R2ZXy7sxu+Ahd+pRU7Ha6HzdK57Ow6fit8eT75hsXcsjIEaffEseHRHh2k5nuPPm7oAMc9zmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741894231; c=relaxed/simple;
	bh=5i7L0CPrSTHSEEB5ouokAnkbT/b1kxYKe1/8pJ+B+Ks=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=QjIkT1iMFX9nO4ZuJEW/pBVFtb97Hz11PF+zvMzq1xWqqBr2Nis/zb5jEiQJLdODj420fP5KGQQeFnCjFJXyPOWKPUvVj+Y1Z9ja6eN/0AAsmjYW3Tr9FyYnFUiKQ6ehuSUjjbLM5JjV7dHC8FMTWCoRqcLsd/T54ek6QEeZkNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EU+WoIA1; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741894229; x=1773430229;
  h=from:subject:date:message-id:mime-version:
   content-transfer-encoding:to:cc;
  bh=5i7L0CPrSTHSEEB5ouokAnkbT/b1kxYKe1/8pJ+B+Ks=;
  b=EU+WoIA1jKB9RJyPXHGZ8kTT0CTZz0cvsdWCS6IMoUtOUew1ENJOW8ci
   nDf8WbCgUGbkF9ZsWN5ZGT/a4DjHmM9no4K0eZku/W57ZJw68LWB2hRyG
   iS2zipLNIUKq/8vvajOewlf90+jmHVeIYmUt/WfjbprjRhP0Y/bN5ujq2
   XPIIkUfi7rhAZmdjX9zH6u+kTkhup+Kh226V1X9iEU5F9Z9UX8d5LYM2V
   NMXralH86kYbLnyQkSnczFfGIrTRjBB5KfL+iU/j3amaiUFPe4V23D7Ll
   P4E3Knc9DzEI7D6AJVxF/QuMWB4CQAAMct8fnSs4sEGivqLSXHrM0At20
   g==;
X-CSE-ConnectionGUID: DeqwY4yKQReoijyF8+ikwQ==
X-CSE-MsgGUID: VGcx8kWeTtGQWSaY1rgeJg==
X-IronPort-AV: E=McAfee;i="6700,10204,11372"; a="43237111"
X-IronPort-AV: E=Sophos;i="6.14,245,1736841600"; 
   d="scan'208";a="43237111"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2025 12:30:28 -0700
X-CSE-ConnectionGUID: 1Z6KhG5BRK2/qF2MLY/e+g==
X-CSE-MsgGUID: PtCIMKBvSFSsODgmSyZ/4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,245,1736841600"; 
   d="scan'208";a="151988212"
Received: from vverma7-desk1.amr.corp.intel.com (HELO [192.168.1.200]) ([10.125.108.107])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2025 12:30:27 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH 0/4] KVM: TDX: Cleanup the kvm_x86_ops structure for
 vmx/tdx
Date: Thu, 13 Mar 2025 13:30:00 -0600
Message-Id: <20250313-vverma7-cleanup_x86_ops-v1-0-0346c8211a0c@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIADgy02cC/4WNQQ6CMBBFr0JmbU2nSkFW3sMQgmWQSaAlLTYYw
 t2tXMDle8l/f4NAnilAlW3gKXJgZxPgKQMztPZFgrvEoKTK5QVRxEh+agthRmrte27WUjduDsJ
 oRbmka4FKQ1rPnnpej/KjTjxwWJz/HEcRf/Z/M6KQ4qaeRH2JutP9ne1C49m4Cep9379tTPBOv
 gAAAA==
X-Change-ID: 20250311-vverma7-cleanup_x86_ops-c62e50e47126
To: Sean Christopherson <seanjc@google.com>, 
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>
X-Mailer: b4 0.15-dev-c25d1
X-Developer-Signature: v=1; a=openpgp-sha256; l=2457;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=5i7L0CPrSTHSEEB5ouokAnkbT/b1kxYKe1/8pJ+B+Ks=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDOmXjYKrPMqPdV3sfdShOss+jrFM89CsKd///SmrX//sq
 5dOFVtGRykLgxgXg6yYIsvfPR8Zj8ltz+cJTHCEmcPKBDKEgYtTACZi0sLwz24xv+HTHbty57xb
 o3Jc6tNKM5t57CLtbkn/LnWl+Fpd2cLwV/xKlmui54lLX+7O8XwQo5Bk/HO6gMz0zrV/vUxmzA1
 ZxQUA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

This is a cleanup that should follow the initial TDX base support (i.e.
not an immediate fix needed for kvm-coco-queue).

In [1], Sean points out that the kvm_x86_ops structure and its
associated helpers and wrappers can be cleaned up a lot by -

1. Putting the wrappers under CONFIG_KVM_INTEL_TDX, and
2. Defining the helpers with macros that switch between the tdx and
   non-tdx case, as well as NULL out the TDX-only stubs when needed.

This cleans up the generated code by completely removing trampolines
that would otherwise be left behind in the CONFIG_KVM_INTEL_TDX=n case.

[1]: https://lore.kernel.org/kvm/Z6v9yjWLNTU6X90d@google.com/

For example, looking at vt_refresh_apicv_exec_ctrl(), before this cleanup,
when CONFIG_KVM_INTEL_TDX=n, the following asm is generated:

0000000000036490 <vt_refresh_apicv_exec_ctrl>:
   36490:       f3 0f 1e fa             endbr64
   36494:       e8 00 00 00 00          call   36499 <vt_refresh_apicv_exec_ctrl+0x9>
                        36495: R_X86_64_PLT32   __fentry__-0x4
   36499:       e9 00 00 00 00          jmp    3649e <vt_refresh_apicv_exec_ctrl+0xe>
                        3649a: R_X86_64_PLT32   vmx_refresh_apicv_exec_ctrl-0x4
   3649e:       66 90                   xchg   %ax,%ax

But with these patches, it goes away completely.

These patches have been tested with TDX kvm-unit-tests, booting a Linux
TD, TDX enhanced KVM selftests, and building and examining the generated
assembly (or lack thereof) with both CONFIG_KVM_INTEL_TDX=y and
CONFIG_KVM_INTEL_TDX=n

Based on a patch by Sean Christopherson <seanjc@google.com>

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
Vishal Verma (4):
      KVM: TDX: Move apicv_pre_state_restore to posted_intr.c
      KVM: VMX: Move x86_ops wrappers under CONFIG_KVM_INTEL_TDX
      KVM: VMX: Make naming consistent for kvm_complete_insn_gp via define
      KVM: VMX: Clean up and macrofy x86_ops

 arch/x86/kvm/vmx/posted_intr.h |   1 +
 arch/x86/kvm/vmx/tdx.h         |   2 +-
 arch/x86/kvm/vmx/x86_ops.h     |  68 +-------------
 arch/x86/kvm/vmx/main.c        | 204 ++++++++++++++++++++---------------------
 arch/x86/kvm/vmx/posted_intr.c |   8 ++
 5 files changed, 113 insertions(+), 170 deletions(-)
---
base-commit: 85c9490bbed74b006a614e542da404a55ff5938f
change-id: 20250311-vverma7-cleanup_x86_ops-c62e50e47126

Best regards,
-- 
Vishal Verma <vishal.l.verma@intel.com>


