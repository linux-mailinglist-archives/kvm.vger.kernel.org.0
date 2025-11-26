Return-Path: <kvm+bounces-64758-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 4704AC8C2A5
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 23:14:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id C0AB4353846
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 22:14:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 822DE340DB0;
	Wed, 26 Nov 2025 22:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gN+bijw5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D187C16DEB0;
	Wed, 26 Nov 2025 22:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764195281; cv=none; b=HNgrPQH+hYI3oWXOZvBax5zwqkz26w6PrII79F1l135s912SRqoszgcFPlgrYsxzqvOAFlWjuPa3ZjFzUMDNCERnm/py8oAVa+tDzFHgw7qRenCeT8VlCPg/i7qytlzko661BFJHxNsv06kfsGmNgxrGFjSgGMa5/R8WfYPOClw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764195281; c=relaxed/simple;
	bh=70td1qKC3id3YHVaYLpVpTz8A6GGqamjCuyo4ZOeQKY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=qAA+JJq8Mvvv4RycuqoVyP8CoK2jkiAuQcGuhuUMePRgUN5PEv8Xcuk2eOl0ffm0jBQra66+3HmJWc1fEf1n/xHQZN0zbFTv2s/DrU+KHYzV1LSEI0DA/goiAJnF7RNJ+kNRIykxrlfkQ2CXeEVR/2SNm9c8VVuGiJtNnicnuCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gN+bijw5; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764195280; x=1795731280;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=70td1qKC3id3YHVaYLpVpTz8A6GGqamjCuyo4ZOeQKY=;
  b=gN+bijw5fn2Ujwfnj4Ef1y+XkB0i0cz1wfMVJ26Fi9oxewosclagT9Ql
   5VNL60kNKQg98NKOaV0s45pg63yO/EIPMh1iTJa+KVwqyg1uJThLdyNE6
   8mogN4ixfIowdNgwthVmwYjbNCgNrc8VOn0xvHx0C0/gq4/UH/+0aQx8i
   qhqg1TGoffDx7uOQ189e5cbFDCy1KimIbfgJfNLl0PU4iQnujQmF49CmP
   JJU+1E6nIVt+a0e4QNrHIZVLEX4uykOMA6hh1i3A8fA3Sz9mj7guUc6eT
   3sDexmXikUkIJQi8xR3rcAoqj6gfaqzYS5kWntym2quS1XMWlYLjU3+VV
   w==;
X-CSE-ConnectionGUID: oyZoaNerQDuoMCGQy1Z0bw==
X-CSE-MsgGUID: 6vVilwS3QmqdFp6+G8BI3g==
X-IronPort-AV: E=McAfee;i="6800,10657,11625"; a="65246327"
X-IronPort-AV: E=Sophos;i="6.20,229,1758610800"; 
   d="scan'208";a="65246327"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 14:14:39 -0800
X-CSE-ConnectionGUID: YSm6q+tfSxqYhYA2ghTQVg==
X-CSE-MsgGUID: AsS8fef8SYSlq+yigEoZ5A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,229,1758610800"; 
   d="scan'208";a="192965021"
Received: from guptapa-desk.jf.intel.com (HELO desk) ([10.165.239.46])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 14:14:39 -0800
Date: Wed, 26 Nov 2025 14:14:38 -0800
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
Subject: [PATCH v5 0/9] VMSCAPE optimization for BHI variant
Message-ID: <20251126-vmscape-bhb-v5-0-02d66e423b00@linux.intel.com>
X-B4-Tracking: v=1; b=H4sIAMR5J2kC/23NP0/DMBAF8K9SecaVz39iHVMRS0cGNsTg+C7EU
 ptUcWsVVfnuWEECIjq+e7rfu4nMU+IsHjc3MXFJOY1DDe5hI2Ifhg+WiWoWWmmnEBpZjjmGE8u
 2byV5sg2i953uRP04Tdyl66K9iZen1+e9eK/nPuXzOH0uGwWW8pvTdsUVkEpScNApBjSWdoc0X
 K7bNJz5sI3jcdGK/hFAgVsLugoIsSXCaAI29wXzR9B+LZgqOI8mamcso7kv2F8BANeCrQIECmS
 5QaL4X5jn+QuGW28jeQEAAA==
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

v5:
- For BHI seq, limit runtime-patching to loop counts only (Dave).
  Dropped 2 patches that moved the BHB seq to a macro.
- Remove redundant switch cases in vmscape_select_mitigation() (Nikolay).
- Improve commit message (Nikolay).
- Collected tags.

Thank you Dave and Nikolay for great suggestions and the review.

v4: https://lore.kernel.org/r/20251119-vmscape-bhb-v4-0-1adad4e69ddc@linux.intel.com
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
Target: IBPB at VMexit-to-userspace Vs the new BHB-clear at
	VMexit-to-userspace mitigation (both compared against baseline).

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
Pawan Gupta (9):
      x86/bhi: x86/vmscape: Move LFENCE out of clear_bhb_loop()
      x86/bhi: Make clear_bhb_loop() effective on newer CPUs
      x86/vmscape: Rename x86_ibpb_exit_to_user to x86_predictor_flush_exit_to_user
      x86/vmscape: Move mitigation selection to a switch()
      x86/vmscape: Use write_ibpb() instead of indirect_branch_prediction_barrier()
      x86/vmscape: Use static_call() for predictor flush
      x86/vmscape: Deploy BHB clearing mitigation
      x86/vmscape: Fix conflicting attack-vector controls with =force
      x86/vmscape: Add cmdline vmscape=on to override attack vector controls

 Documentation/admin-guide/hw-vuln/vmscape.rst   |  8 ++++
 Documentation/admin-guide/kernel-parameters.txt |  4 +-
 arch/x86/Kconfig                                |  1 +
 arch/x86/entry/entry_64.S                       | 13 +++--
 arch/x86/include/asm/cpufeatures.h              |  2 +-
 arch/x86/include/asm/entry-common.h             |  9 ++--
 arch/x86/include/asm/nospec-branch.h            | 11 +++--
 arch/x86/kernel/cpu/bugs.c                      | 64 +++++++++++++++++++------
 arch/x86/kvm/x86.c                              |  4 +-
 arch/x86/net/bpf_jit_comp.c                     |  2 +
 10 files changed, 89 insertions(+), 29 deletions(-)
---
base-commit: 6a23ae0a96a600d1d12557add110e0bb6e32730c
change-id: 20250916-vmscape-bhb-d7d469977f2f

Best regards,
-- 
Pawan



