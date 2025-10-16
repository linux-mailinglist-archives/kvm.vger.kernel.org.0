Return-Path: <kvm+bounces-60118-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id A02C8BE1308
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 03:51:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 928AC4E9693
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 01:51:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63ED11EB195;
	Thu, 16 Oct 2025 01:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fnucBwCJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BCA31A256E;
	Thu, 16 Oct 2025 01:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760579503; cv=none; b=o9V+ZBEfMRJnXBibTb+tp1hZE61sxiQ98HWtPaz0YrS93//Xf5zBXhU0KjeJXZOhZaIVgpWFVnS6PTe59EmUNk8RRes3vnMHMERYGBunh9szIYIxPRpFLVVu5EywW/MQU4Hc2+oaPHx+IqetD8Fu8LTI4CRjOg5Vgs0zcvqdxsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760579503; c=relaxed/simple;
	bh=S8oBMhKAT6w97NZObBqNnSz/L32t2Ezjd0QEjrghIng=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=JUPgeaB/V1jnSwINkNlFqYKXc2o2pB4+DJYMmZjthFLuwMsHFrird6whXQvugaec8u6avD5O1n8rdQWOT2Gs6ettz4sZ1mcjD8KWIkhiKxPigFetvNxErdR24OqnP9FATqunJ0pY6QOxigm8u16PWmVTXDGNBvBtv+kOse1ziQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fnucBwCJ; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760579502; x=1792115502;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=S8oBMhKAT6w97NZObBqNnSz/L32t2Ezjd0QEjrghIng=;
  b=fnucBwCJPva4JkQh1lrEwemnywDoJGB5MWsxW0T5bODQuzpiSdW2KwiD
   bkapTWU1+Nb62k3Qv+Fjydd7L75k+ZPHccs7ZibJDK1Ti/3BRZ8qQ/iai
   eGWZXZ/22OhYKkryapCuI7cL8b/CPAtZulkvEGh+0buDuIvqKaT/+BaPv
   6ZmwY1lz6L5X/Png9jtCJBFDhW2h//TRR0l8oIe+4YZE3qtf3pa6WPs9x
   Bh/Zo4vg2BfS0yKcibPcBi1iYU0rStN/rtL3+Jx1dbxXGZ1vKw1O1W9kn
   0FOr4mKgcBPuoB5eYRQcR2D1C88K4QaFV7tRUbKLiuIHx5Dt1ZI+B4K++
   Q==;
X-CSE-ConnectionGUID: jJ/c+6oxSlaD29D+X35+0g==
X-CSE-MsgGUID: VE/ZnBrOQ+apAqkZZzIgZg==
X-IronPort-AV: E=McAfee;i="6800,10657,11583"; a="85382908"
X-IronPort-AV: E=Sophos;i="6.19,232,1754982000"; 
   d="scan'208";a="85382908"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2025 18:51:41 -0700
X-CSE-ConnectionGUID: Cs0DyJWsTja9Kx5uhBTxKg==
X-CSE-MsgGUID: BhTi85ymSZ+ditOBoVoZww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,232,1754982000"; 
   d="scan'208";a="213279849"
Received: from dnelso2-mobl.amr.corp.intel.com (HELO desk) ([10.124.223.20])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2025 18:51:40 -0700
Date: Wed, 15 Oct 2025 18:51:39 -0700
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	David Kaplan <david.kaplan@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Asit Mallick <asit.k.mallick@intel.com>,
	Tao Zhang <tao1.zhang@intel.com>
Subject: [PATCH v2 0/3] VMSCAPE optimization for BHI variant
Message-ID: <20251015-vmscape-bhb-v2-0-91cbdd9c3a96@linux.intel.com>
X-B4-Tracking: v=1; b=H4sIAA1P8GgC/1WNPQ+CMBRF/wp5syVt5SN10rg4OrgZBqCv8hIop
 MUGQ/jvNjg5nntzz13BoyP0cEpWcBjI02gjyEMCbVfbFzLSkUFymXMlChYG39YTsqZrmC51Vih
 VlkYaiIvJoaFltz3hfnlcb1DFuCM/j+6zfwSxlz+dzP50QTDOdJ0Lw1GoY6bPPdn3kpKdsU/bc
 YBq27Yv+8BEgrMAAAA=
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

v2:
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

Roadmap:

- First patch introduces clear_bhb_long_loop() for processors with larger
  branch history tables.
- Second patch replaces IBPB on exit-to-userspace with branch history
  clearing sequence.

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
Pawan Gupta (3):
      x86/bhi: Add BHB clearing for CPUs with larger branch history
      x86/vmscape: Replace IBPB with branch history clear on exit to userspace
      x86/vmscape: Remove LFENCE from BHB clearing long loop

 Documentation/admin-guide/hw-vuln/vmscape.rst   |  8 ++++
 Documentation/admin-guide/kernel-parameters.txt |  4 +-
 arch/x86/entry/entry_64.S                       | 63 ++++++++++++++++++-------
 arch/x86/include/asm/cpufeatures.h              |  1 +
 arch/x86/include/asm/entry-common.h             | 12 +++--
 arch/x86/include/asm/nospec-branch.h            |  5 +-
 arch/x86/kernel/cpu/bugs.c                      | 53 +++++++++++++++------
 arch/x86/kvm/x86.c                              |  5 +-
 8 files changed, 110 insertions(+), 41 deletions(-)
---
base-commit: 3a8660878839faadb4f1a6dd72c3179c1df56787
change-id: 20250916-vmscape-bhb-d7d469977f2f

Best regards,
-- 
Pawan



