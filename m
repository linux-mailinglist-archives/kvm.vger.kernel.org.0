Return-Path: <kvm+bounces-66222-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 92D45CCAD4F
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 09:18:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C98F7308AEEF
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 08:14:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C6403321CA;
	Thu, 18 Dec 2025 08:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AuVzWDTp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2722033123B;
	Thu, 18 Dec 2025 08:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766045606; cv=none; b=i2oO5KeDemDj1M9AlZgBQo+++4VXAZOiKFmhuiYSljYDQevlvkCIU5MXUMrAtGbpqbBNdxU1UaXLDERISBQvNbpA8iTAcLYar/viZL8HEmf0kcDLRF7kN6k0SCfOsiwRI/9VVdXSQkhCBliQbMc1/jPsKNpctqVP/QJjcEmD5/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766045606; c=relaxed/simple;
	bh=ZjcLwbd0y65ZVAqORI4St6bn8gnxvPZ5WjQ8K/gdWMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GQ04aUGe8ODYLIa9KjqPzq9sW7tV88K6KXMoEXtJlKNexChKphMbuGCO8yLMq+2prrhAcWog+Cr9MYrnpPJ6JYp520J15bBsRyv0CUHYOG71uHZjxICSRnbd7cmWZqrWCitj9wvPtWi1IyS/Ym/3Ez+Gtk6WXGXkspIqzsKUi5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AuVzWDTp; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766045604; x=1797581604;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ZjcLwbd0y65ZVAqORI4St6bn8gnxvPZ5WjQ8K/gdWMQ=;
  b=AuVzWDTpxC3+mqMmN2MK/DnurbaT+tiPeB81FFvIUz9ve/OsjYVDP1P/
   Cjdd7b0+uGR05/bQCO4yRGBl9o4Vzo8JFrECVuGXBNEMxcgir6u6ecqmF
   eQ9BzA+5V0bqV/855tMGyhit4fROHgpUi95KU0kHeyXJB5ZY86AZWJqjp
   n74eSqKn5UyA/GkNIj3zMWolDRVJZ7W8DYjY0FBjGEIQQBW+DSmNEWW/7
   1GNc0BfhUz3FjKg/Cswzg/FPge/irK/WasWXjNC2vbaRJhnimophmoN24
   bb4s0XaTMdCn8vMPvivnJqBh+ZlEhEoqVUYOEb948wEWbRIKJ5ygY7r5k
   w==;
X-CSE-ConnectionGUID: fywXS7PqQru10JsZwvhQDg==
X-CSE-MsgGUID: G6TfBWF7RxCpX6ZgX9cb2Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11645"; a="67188056"
X-IronPort-AV: E=Sophos;i="6.21,156,1763452800"; 
   d="scan'208";a="67188056"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2025 00:13:23 -0800
X-CSE-ConnectionGUID: 78cBZ3ynR+CHLyljucik4g==
X-CSE-MsgGUID: 9FMCuQOiTR+d7rbJe4qF+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,156,1763452800"; 
   d="scan'208";a="198599610"
Received: from ktian1-pkvm.sh.intel.com ([10.239.48.205])
  by orviesa008.jf.intel.com with ESMTP; 18 Dec 2025 00:13:20 -0800
From: Kevin Tian <kevin.tian@intel.com>
To: Alex Williamson <alex@shazbot.org>,
	Ankit Agrawal <ankita@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Ramesh Thomas <ramesh.thomas@intel.com>,
	Yunxiang Li <Yunxiang.Li@amd.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] vfio/pci: Fix issues with qword access
Date: Thu, 18 Dec 2025 08:16:48 +0000
Message-ID: <20251218081650.555015-1-kevin.tian@intel.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Certain devices (e.g. Intel X710) don't support qword access to the
rom bar, otherwise PCI aer errors are observed. Fix it by disabling
the qword access to the rom bar.

While at it, also restrict accesses to the legacy VGA resource to
dword. More for paranoia so stable kernel is not CC-ed.

v2:
- Rebase to 6.19-rc1
- Use enum to avoid adding another bool arg (Alex)
- Elaborate the commit msg (Alex)
- New patch to disallow qword access to legacy VGA (Alex)

v1:
https://lore.kernel.org/all/20251212020941.338355-1-kevin.tian@intel.com/

Kevin Tian (2):
  vfio/pci: Disable qword access to the PCI ROM bar
  vfio/pci: Disable qword access to the VGA region

 drivers/vfio/pci/nvgrace-gpu/main.c |  4 ++--
 drivers/vfio/pci/vfio_pci_rdwr.c    | 25 ++++++++++++++++++-------
 include/linux/vfio_pci_core.h       | 10 +++++++++-
 3 files changed, 29 insertions(+), 10 deletions(-)

-- 
2.43.0


