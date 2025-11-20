Return-Path: <kvm+bounces-63770-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 39265C724FD
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 07:17:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sea.lore.kernel.org (Postfix) with ESMTPS id CD9522A1F5
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 06:17:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D25FA27FD5D;
	Thu, 20 Nov 2025 06:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W2Nbt272"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEAFC4C98;
	Thu, 20 Nov 2025 06:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763619456; cv=none; b=AvKTmA4dFUcMxCmtFsTRVlqhQMDCUx8BbUsPQ0H8A0e3ODMhJBOK2IbELKNUFOtvsfa13OLZ4p6Bhjlnj9n3UGgku1Al1JaEcmsW9Rt2T2jqV6CxRDgDVfXU9aaXSt2HoZ1/HGUviz9734BIfJcPV054F0WOB0x6QzBm01re18I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763619456; c=relaxed/simple;
	bh=XrsQdz2tLAJSqPVnube39kw+4N0HijWoU8dbWY8GeLg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=TIz3QaVtdazdDmijLmKRSuesshtG8ZQ6Uxl+ac971kjb7miuJANa/FX0hbgIId/FvbqN+yGX2yhCHTFaFlE7OFGffZ4wHUTQfaTJOqDRkZzY3lb6kIBgP32lUuMXte/r4E7x0IAIEa9cRKZLo2Qd11F7VRvJjOCqCRFegDz0Cug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W2Nbt272; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763619454; x=1795155454;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=XrsQdz2tLAJSqPVnube39kw+4N0HijWoU8dbWY8GeLg=;
  b=W2Nbt272Yl9TFQW9nlA1GiebLNBWTEFhZZ/+J84jCSwk1kdxa5qeCmJD
   uiQZVqtEZH7Eum+FfnOKf/LC2jFPWCxvBuPVNe5a1DRcfzWIaC0jHfT1d
   sJyEYRASMhW8vTtVExNgKETngHLh3KxpJVABmd8Ulv2QnGWfQjs0I6icc
   xmEdiD//3fren7zHwaqROFxYEeFvHPCN8B898d5/H1Wu8fDV8UhfbWTFu
   DCFg9NreHnpAwikAa/vWQAnXRzQWC27SF5syB8ASCPVORvGsGTVFI/zet
   a1RLIDozu/4tGaeeiMsgC+Iycnaz0IW2JuVyl3xpJqOAtac/oHG64hpky
   w==;
X-CSE-ConnectionGUID: 0QWWP956RsWfxnXFgf0UQA==
X-CSE-MsgGUID: nYFp5xUwTQ6KJOAhi4cEQA==
X-IronPort-AV: E=McAfee;i="6800,10657,11618"; a="77035454"
X-IronPort-AV: E=Sophos;i="6.19,317,1754982000"; 
   d="scan'208";a="77035454"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 22:17:33 -0800
X-CSE-ConnectionGUID: sK1rvV/cQkikO7mOknNcxQ==
X-CSE-MsgGUID: Xa3SI499SlCDj9br0RsE0Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,317,1754982000"; 
   d="scan'208";a="191532099"
Received: from guptapa-desk.jf.intel.com (HELO desk) ([10.165.239.46])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 22:17:33 -0800
Date: Wed, 19 Nov 2025 22:17:32 -0800
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: x86@kernel.org, David Kaplan <david.kaplan@amd.com>,
	Nikolay Borisov <nik.borisov@suse.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Asit Mallick <asit.k.mallick@intel.com>,
	Tao Zhang <tao1.zhang@intel.com>
Subject: [PATCH v4 00/11] VMSCAPE optimization for BHI variant
Message-ID: <20251119-vmscape-bhb-v4-0-1adad4e69ddc@linux.intel.com>
X-B4-Tracking: v=1; b=H4sIAHCxHmkC/23NvQrCMBQF4FeRzEby23CdFBdHBzdxaJNbG6itN
 DVUpO9uqCAWHc893O88ScDOYyDrxZN0GH3wbZOCWi6IrfLmgtS7lIlgQjPgGY3XYPMb0qIqqDN
 OZQDGlKIk6ePWYemHSTuRw/a425NzOlc+9G33mDYin8o3J9SMi5wy6nLNS4YcpHKb2jf3YeWbH
 uuVba+TFsVH4IzruSCSANwWzoGVOWT/BfklCDMXZBK0AWmFlgpB/grjOL4AH+/+uTcBAAA=
X-Change-ID: 20250916-vmscape-bhb-d7d469977f2f
X-Mailer: b4 0.14.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Sean, David, since this version differs quite a bit from v3, I have not
included the Ack tag you provided. Please let me know if it is okay to add
them back.

v4:
- Move LFENCE to the callsite, out of clear_bhb_loop(). (Dave)
- Make clear_bhb_loop() work for larger BHB. (Dave)
  This now uses hardware enumeration to determine the BHB size to clear.
- Use write_ibpb() instead of indirect_branch_prediction_barrier() when
  IBPB is known to be available. (Dave)
- Use static_call() to simplify mitigation at exit-to-userspace. (Dave)
- Refactor vmscape_select_mitigation(). (Dave)
- Fix vmscape=on which was wrongly behaving as AUTO. (Dave)
- Split the patches. (Dave)
  - Patch 1-4 prepares for making the sequence flexible for VMSCAPE use.
  - Patch 5 trivial rename of variable.
  - Patch 6-8 prepares for deploying BHB mitigation for VMSCAPE.
  - Patch 9 deploys the mitigation.
  - Patch 10-11 fixes ON Vs AUTO mode.

v3: https://lore.kernel.org/r/20251027-vmscape-bhb-v3-0-5793c2534e93@linux.intel.com
- s/x86_pred_flush_pending/x86_predictor_flush_exit_to_user/ (Sean).
- Removed IBPB & BHB-clear mutual exclusion at exit-to-userspace.
- Collected tags.

v2: https://lore.kernel.org/r/20251015-vmscape-bhb-v2-0-91cbdd9c3a96@linux.intel.com
- Added check for IBPB feature in vmscape_select_mitigation(). (David)
- s/vmscape=auto/vmscape=on/ (David)
- Added patch to remove LFENCE from VMSCAPE BHB-clear sequence.
- Rebased to v6.18-rc1.

v1: https://lore.kernel.org/r/20250924-vmscape-bhb-v1-0-da51f0e1934d@linux.intel.com

Hi All,

These patches aim to improve the performance of a recent mitigation for
VMSCAPE[1] vulnerability. This improvement is relevant for BHI variant of
VMSCAPE that affect Alder Lake and newer processors.

The current mitigation approach uses IBPB on kvm-exit-to-userspace for all
affected range of CPUs. This is an overkill for CPUs that are only affected
by the BHI variant. On such CPUs clearing the branch history is sufficient
for VMSCAPE, and also more apt as the underlying issue is due to poisoned
branch history.

Below is the iPerf data for transfer between guest and host, comparing IBPB
and BHB-clear mitigation. BHB-clear shows performance improvement over IBPB
in most cases.

Platform: Emerald Rapids
Baseline: vmscape=off

(pN = N parallel connections)

| iPerf user-net | IBPB    | BHB Clear |
|----------------|---------|-----------|
| UDP 1-vCPU_p1  | -12.5%  |   1.3%    |
| TCP 1-vCPU_p1  | -10.4%  |  -1.5%    |
| TCP 1-vCPU_p1  | -7.5%   |  -3.0%    |
| UDP 4-vCPU_p16 | -3.7%   |  -3.7%    |
| TCP 4-vCPU_p4  | -2.9%   |  -1.4%    |
| UDP 4-vCPU_p4  | -0.6%   |   0.0%    |
| TCP 4-vCPU_p4  |  3.5%   |   0.0%    |

| iPerf bridge-net | IBPB    | BHB Clear |
|------------------|---------|-----------|
| UDP 1-vCPU_p1    | -9.4%   |  -0.4%    |
| TCP 1-vCPU_p1    | -3.9%   |  -0.5%    |
| UDP 4-vCPU_p16   | -2.2%   |  -3.8%    |
| TCP 4-vCPU_p4    | -1.0%   |  -1.0%    |
| TCP 4-vCPU_p4    |  0.5%   |   0.5%    |
| UDP 4-vCPU_p4    |  0.0%   |   0.9%    |
| TCP 1-vCPU_p1    |  0.0%   |   0.9%    |

| iPerf vhost-net | IBPB    | BHB Clear |
|-----------------|---------|-----------|
| UDP 1-vCPU_p1   | -4.3%   |   1.0%    |
| TCP 1-vCPU_p1   | -3.8%   |  -0.5%    |
| TCP 1-vCPU_p1   | -2.7%   |  -0.7%    |
| UDP 4-vCPU_p16  | -0.7%   |  -2.2%    |
| TCP 4-vCPU_p4   | -0.4%   |   0.8%    |
| UDP 4-vCPU_p4   |  0.4%   |  -0.7%    |
| TCP 4-vCPU_p4   |  0.0%   |   0.6%    |

[1] https://comsec.ethz.ch/research/microarch/vmscape-exposing-and-exploiting-incomplete-branch-predictor-isolation-in-cloud-environments/

---
Pawan Gupta (11):
      x86/bhi: x86/vmscape: Move LFENCE out of clear_bhb_loop()
      x86/bhi: Move the BHB sequence to a macro for reuse
      x86/bhi: Make the depth of BHB-clearing configurable
      x86/bhi: Make clear_bhb_loop() effective on newer CPUs
      x86/vmscape: Rename x86_ibpb_exit_to_user to x86_predictor_flush_exit_to_user
      x86/vmscape: Move mitigation selection to a switch()
      x86/vmscape: Use write_ibpb() instead of indirect_branch_prediction_barrier()
      x86/vmscape: Use static_call() for predictor flush
      x86/vmscape: Deploy BHB clearing mitigation
      x86/vmscape: Override conflicting attack-vector controls with =force
      x86/vmscape: Add cmdline vmscape=on to override attack vector controls

 Documentation/admin-guide/hw-vuln/vmscape.rst   |  8 +++
 Documentation/admin-guide/kernel-parameters.txt |  4 +-
 arch/x86/Kconfig                                |  1 +
 arch/x86/entry/entry_64.S                       | 49 +++++++++++-------
 arch/x86/include/asm/cpufeatures.h              |  2 +-
 arch/x86/include/asm/entry-common.h             |  9 ++--
 arch/x86/include/asm/nospec-branch.h            | 11 ++--
 arch/x86/kernel/cpu/bugs.c                      | 67 +++++++++++++++++++------
 arch/x86/kvm/x86.c                              |  4 +-
 arch/x86/net/bpf_jit_comp.c                     |  2 +
 10 files changed, 114 insertions(+), 43 deletions(-)
---
base-commit: 6a23ae0a96a600d1d12557add110e0bb6e32730c
change-id: 20250916-vmscape-bhb-d7d469977f2f

Best regards,
-- 
Thanks,
Pawan



