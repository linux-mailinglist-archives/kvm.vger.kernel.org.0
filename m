Return-Path: <kvm+bounces-39997-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 96B73A4D764
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 10:07:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3CCD61703F2
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 09:06:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 447AA2036E8;
	Tue,  4 Mar 2025 09:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B3Ny1zWL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D13331FE472
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 09:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741078855; cv=none; b=ahW08zfAvEmSTlT9fpNE3tUHycJv8TL+MmPAdt5GRRZvCXKh5WYQRDOYrQ39b92NNkm9GcMHw4TYJetYc4vmPSjBBSYR3R6YnoRrhg0u4wKeOd9WgfLmsGTUwfouprSqawzbrDrG3tWpSMbtOBXdDB/grM2Mwb6RpBkBqNyor4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741078855; c=relaxed/simple;
	bh=OoPp9XyS2jWaQakABftfnWg6+XHFQIyhZmXs4vC83yg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=p9L2YdjxQGSULI+pYi9I5hQVFs+BRdFrUnkIuGhw3lELnGpL/8n8WjWyxlXAuAh6FZqVEPFfO5vJI7C7033V5fyLGUChriNeS49WbcC65YIHIhokYacnDNeQWX/V6q5Mkv6fHUDHdAnudjtkEYr6K0ng9F4WUVh+89eb9dricMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B3Ny1zWL; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741078853; x=1772614853;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=OoPp9XyS2jWaQakABftfnWg6+XHFQIyhZmXs4vC83yg=;
  b=B3Ny1zWLIGoglHv+SdNfen9/03yYWvKGgu/V11BuyLRniSwqBUg10hHx
   WKHOJKdHG+UT0wzAoL1bVbb/e2IaXXpD6gZWG5B7bKezT3tjUI4GuluCn
   a0LcDkpVeRRgkkLJmhDfcA4Y9CMcjSNGfBEOcYbSCni10dYxdSwzyzVIk
   qMNaM+wmn8uOiMviXOW9JG+2GU8D1oTOugHDOF3Q7ky/7GPfcHbea19aN
   H7k/swF0RsGENpKzip8S/VSBRg2yqjWRrLmjQc4NiPx3VtoYwJ5FQKl0I
   GCpw7p8AzaVNqvkTNgTHABR6RSrbNPgXCHXzOdjIUXROa+sp9L9VbVIMU
   g==;
X-CSE-ConnectionGUID: WDjgcvJRScu6WkR6/ayvqA==
X-CSE-MsgGUID: kmNaKF1sTrmcBabYd3RS/Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11362"; a="52631322"
X-IronPort-AV: E=Sophos;i="6.13,331,1732608000"; 
   d="scan'208";a="52631322"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2025 01:00:52 -0800
X-CSE-ConnectionGUID: LvFIOIQOTVq1fD42FYCJ6Q==
X-CSE-MsgGUID: x/FUcEJMTDe7hHBRxaRqOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,331,1732608000"; 
   d="scan'208";a="118999215"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa009.fm.intel.com with ESMTP; 04 Mar 2025 01:00:51 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH 0/2] KVM: x86: Cleanup and fix for reporting CPUID leaf 0x80000022
Date: Tue,  4 Mar 2025 03:23:12 -0500
Message-Id: <20250304082314.472202-1-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Patch 1 is a cleanup and Patch 2 is a fix. Please see the individual
patch for detail.

Xiaoyao Li (2):
  KVM: x86: Remove the unreachable case for 0x80000022 leaf in
    __do_cpuid_func()
  KVM: x86: Explicitly set eax and ebx to 0 when X86_FEATURE_PERFMON_V2
    cannot be exposed to guest

 arch/x86/kvm/cpuid.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)


base-commit: 7d2154117a02832ab3643fe2da4cdc9d2090dcb2
-- 
2.34.1


