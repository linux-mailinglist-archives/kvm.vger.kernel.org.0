Return-Path: <kvm+bounces-67308-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E5CD8D00779
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 01:32:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E79D430194E0
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 00:31:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CF471DE3AD;
	Thu,  8 Jan 2026 00:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZpHGEz07"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B0D41A0BF3;
	Thu,  8 Jan 2026 00:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767832308; cv=none; b=o3t1LvdRCVBow2bVjL6Vmjq7ASM+TN3vs+WwIcj63/vhILKkiTlT7lijWKrLoyOPN4unO9eSIQIxRagkHCYDENwUODDiwaJjTCG3TvK0c61Ul6Zl67FGySocBrGnWTjfA6+IaVAIWSmwHejZFTmgIjVuiqTWr0EcEC9N2zL3a2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767832308; c=relaxed/simple;
	bh=Wt+9t76IVSJ+QyzKQjtW4wD8J/ELnJsYJiCapvuaUfQ=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=RVRapuEUTTv4NPi5NZ7sXM/RQsKFZvGEW25ShZF07D9RgO6X77LCSR6okG+2+wjY03BYMGt28R6aVGDLXPDgiwV0MSMw1kiK5YMhJL4juEiez3IUEXGcbDeRjJmVfjrRVzJKbDBdpT1EBb/RSmn/nJaTk5uRK65HsTwlhSVYwQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZpHGEz07; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767832307; x=1799368307;
  h=from:subject:date:message-id:mime-version:
   content-transfer-encoding:to:cc;
  bh=Wt+9t76IVSJ+QyzKQjtW4wD8J/ELnJsYJiCapvuaUfQ=;
  b=ZpHGEz07LPr3pYlzfR0FN7LkjNz7P0iti7JRlzJ5CUxCnODo6cGx7uW+
   MZivWc8EmE/HhZ0NAApgg83dyAajcaV+SOHebiiAXOMkIdb1DAKBDQ+wE
   iG94/0K0XpODBNFkE3KwBNy99kWs6TmjKN+aFFNsTILe8fMKMWeAExs58
   LqXJltZIYaohQl70nVYJy8vHhghSZE0wj0cXRZbFADCmeKoKksQ4Ec9/K
   GHoq3gmO8cB2SgQBJNeD1EziT+SsjHBBfCCI64+95fZlUGmuSVnCi0F69
   pQ0AyT8oNPjgVwmSgfisqdqxsFMqmMf/LEbztN9ZInhDb40OL3QA/NUJU
   Q==;
X-CSE-ConnectionGUID: CPSC5HBpTmSaJr3xcAMmuQ==
X-CSE-MsgGUID: enMdXfS8T7SKvkYQlW3LBw==
X-IronPort-AV: E=McAfee;i="6800,10657,11664"; a="86625966"
X-IronPort-AV: E=Sophos;i="6.21,209,1763452800"; 
   d="scan'208";a="86625966"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2026 16:31:47 -0800
X-CSE-ConnectionGUID: PMxOtC1pTJiPd+JkGyo/2A==
X-CSE-MsgGUID: wh/4zFXxSHCX5Qlo8Fy6RA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,209,1763452800"; 
   d="scan'208";a="207908357"
Received: from vverma7-desk1.amr.corp.intel.com (HELO [192.168.1.200]) ([10.124.222.195])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2026 16:31:45 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH 0/2] x86/virt/tdx: Print TDX module version to dmesg
Date: Wed, 07 Jan 2026 17:31:27 -0700
Message-Id: <20260107-tdx_print_module_version-v1-0-822baa56762d@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAN/6XmkC/x2M4QpAMBRGX0X3t9UsUV5FWto+3GJ0h5S8u/Hz1
 DnnpghhRGqymwQnR15DgiLPyE19GKHYJyajTaULXavdX3YTDrtdVn/MsCfkixRK19fwLpmGUr4
 JBr7+dds9zws0uxJnagAAAA==
X-Change-ID: 20260107-tdx_print_module_version-e4ca7edc2022
To: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
 kvm@vger.kernel.org
Cc: x86@kernel.org, Chao Gao <chao.gao@intel.com>, 
 Dan Williams <dan.j.williams@intel.com>, Kai Huang <kai.huang@intel.com>, 
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 "H. Peter Anvin" <hpa@zytor.com>, Kiryl Shutsemau <kas@kernel.org>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>
X-Mailer: b4 0.15-dev-e44bb
X-Developer-Signature: v=1; a=openpgp-sha256; l=2182;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=Wt+9t76IVSJ+QyzKQjtW4wD8J/ELnJsYJiCapvuaUfQ=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDJlxvz7efxDHcqvh4nzDS+/7zW/r8qQYy67VYl4X7/JGv
 rViL8/FjlIWBjEuBlkxRZa/ez4yHpPbns8TmOAIM4eVCWQIAxenAExkQhUjw9Znc22flQfcj/4X
 ssLnzu0VK232xnc8t7necum74RmziSsZ/idsUvN7qT3vc/LnpQenrFSbltLivfumsaKP8Kw1Gd9
 OX2cGAA==
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

=== Problem & Solution ===

Currently, there is neither an ABI, nor any other way to determine from
the host system, what version of the TDX module is running. A sysfs ABI
for this has been proposed in [1], but it may need additional discussion.

Many/most TDX developers already carry patches like this in their
development branches. It can be tricky to know which TDX module is
actually loaded on a system, and so this functionality has been needed
regularly for development and processing bug reports. Hence, it is
prudent to break out the patches to retrieve and print the TDX module
version, as those parts are very straightforward, and get some level of
debugability and traceability for TDX host systems.

=== Dependencies ===

None. This is based on v6.19-rc4, and applies cleanly to tip.git.

=== Patch details ===

Patch 1 is a prerequisite that adds the infrastructure to retrieve the
TDX module version from its global metadata. This was originally posted in [2].

Patch 2 is based on a patch from Kai Huang [3], and prints the version to
dmesg during init.

=== Testing ===

This has passed the usual suite of tests, including successful 0day
builds, KVM Unit tests, KVM selftests, a TD creation smoke test, and
selected KVM tests from the Avocado test suite.

[1]: https://lore.kernel.org/all/20260105074350.98564-1-chao.gao@intel.com/
[2]: https://lore.kernel.org/all/20260105074350.98564-2-chao.gao@intel.com/
[3]: https://lore.kernel.org/all/57eaa1b17429315f8b5207774307f3c1dd40cf37.1730118186.git.kai.huang@intel.com/

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
Chao Gao (1):
      x86/virt/tdx: Retrieve TDX module version

Vishal Verma (1):
      x86/virt/tdx: Print TDX module version during init

 arch/x86/include/asm/tdx_global_metadata.h  |  7 +++++++
 arch/x86/virt/vmx/tdx/tdx.c                 |  5 +++++
 arch/x86/virt/vmx/tdx/tdx_global_metadata.c | 16 ++++++++++++++++
 3 files changed, 28 insertions(+)
---
base-commit: 9ace4753a5202b02191d54e9fdf7f9e3d02b85eb
change-id: 20260107-tdx_print_module_version-e4ca7edc2022

Best regards,
--  
Vishal Verma <vishal.l.verma@intel.com>


