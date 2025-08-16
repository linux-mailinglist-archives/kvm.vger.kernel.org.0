Return-Path: <kvm+bounces-54834-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A6D8B28E8E
	for <lists+kvm@lfdr.de>; Sat, 16 Aug 2025 16:45:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 00ED1587843
	for <lists+kvm@lfdr.de>; Sat, 16 Aug 2025 14:45:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F2FB2F1FFD;
	Sat, 16 Aug 2025 14:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aOFuBYsf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4F7F1E9B37;
	Sat, 16 Aug 2025 14:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755355492; cv=none; b=HPBfvjLPJKez8/3p73nzEC6II3vEoVD1jQ4EBfJkY7EALq1f/PUgrbYz4ER2eFJItVkX5/IfZ1uKLdr8sXVkdqXS9CdBHtqDUdBwCOiYQq04HseDuYpZaaRmfmZl3fZxM1nAskONHGc7SllI2NFv1qKRsRsJn1DaK6AHIDc1gTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755355492; c=relaxed/simple;
	bh=425T8XrFe31ZYXPIPNALEHvQC7Iv5QFDuBEBtSxDdak=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=COjsg5w6AjN3ucvK4HF9dn4LBYg6VAMnPOrmeb0fKfGy5ukxmgtS8SgbPY6vzUdJXykVyLSsVPXYDY0jMgI34+fB8DvwbcKaa5xEQEeCjWVAmf3LmYO9c0iY8n4BupttIjxW43JLFogp/V84kS5d5EMJu2mXfyvENjcbU1rQy54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aOFuBYsf; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755355491; x=1786891491;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=425T8XrFe31ZYXPIPNALEHvQC7Iv5QFDuBEBtSxDdak=;
  b=aOFuBYsfWfJ9sVU74ThPJULTUuPA2OKz37FLBquA5LG2UJ3UwHd3SqKe
   5LPx4GVZjoY4BOvfU78IV60jIRPnQMUeW3ofyQaugkdFs1J1jBnx/zOBl
   UlL5jcYitVia6gIFsljcMexEhEFz6JH2eWw54HBFGNlYZDHkW/bxXkJDw
   oL32bG9UnHSoNGhRsZUbzpgw5K3qV2zGJKMU58xfOE0VXeZsFbKlwGAOL
   7F4+CgIBxyN34aP4GAxx/zFjucp1PbfqpdCWS/5gzurIkwifyJjBewyrY
   VsFX65QZUjUsZ3a3r1fvXAzBcWhE3NHh/xacUhkLl+idxs5r8jj25KBj7
   g==;
X-CSE-ConnectionGUID: m5kz/SXyQZ+L4RmObY3OFA==
X-CSE-MsgGUID: YVsFLQlSQhSLgaTO9d/Pwg==
X-IronPort-AV: E=McAfee;i="6800,10657,11524"; a="57508492"
X-IronPort-AV: E=Sophos;i="6.17,293,1747724400"; 
   d="scan'208";a="57508492"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2025 07:44:51 -0700
X-CSE-ConnectionGUID: GgjB0gb6QieY+FEtMWX2mw==
X-CSE-MsgGUID: Q9JO8j63SmOzYdmf71upWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,293,1747724400"; 
   d="scan'208";a="198220456"
Received: from abityuts-desk.ger.corp.intel.com (HELO localhost.localdomain) ([10.245.245.93])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2025 07:44:46 -0700
From: Adrian Hunter <adrian.hunter@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	kirill.shutemov@linux.intel.com,
	kai.huang@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com,
	binbin.wu@linux.intel.com,
	isaku.yamahata@intel.com,
	linux-kernel@vger.kernel.org,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	ira.weiny@intel.com
Subject: [PATCH RFC 0/2] KVM: TDX: MWAIT in guest
Date: Sat, 16 Aug 2025 17:44:33 +0300
Message-ID: <20250816144436.83718-1-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: c/o Alberga Business Park, 6 krs, Bertel Jungin Aukio 5, 02600 Espoo, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit

Hi

TDX support for using the MWAIT instruction in a guest has issues.

One option is just to disable it, see patch 1.

Then perhaps provide a distinct way to enable it, documenting the
limitations TDX has compared with VMX in this regard, so that users
will be made aware of the limitations.  See patch 2.

Other options:
1. Do nothing but document the limitations.
2. Patch 1 but not patch 2; look for a better solution


Adrian Hunter (2):
      KVM: TDX: Disable general support for MWAIT in guest
      KVM: TDX: Add flag to support MWAIT instruction only

 Documentation/virt/kvm/x86/intel-tdx.rst | 28 ++++++++++-
 arch/x86/include/asm/kvm_host.h          |  2 +
 arch/x86/include/uapi/asm/kvm.h          |  3 ++
 arch/x86/kvm/vmx/tdx.c                   | 80 +++++++++++++++++++++++++-------
 arch/x86/kvm/x86.c                       |  8 ++--
 5 files changed, 98 insertions(+), 23 deletions(-)


Regards
Adrian

