Return-Path: <kvm+bounces-33413-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B960F9EB1D0
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 14:25:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EC22D16894A
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 13:25:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA1901A9B40;
	Tue, 10 Dec 2024 13:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DE/PdLr4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B67A1A4F1B;
	Tue, 10 Dec 2024 13:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733837135; cv=none; b=Mp/FWhnsbBEKvBPjx0ZwCZxrqF6J2Rzih5x/+bDNxrf0rki3jpXEo7P8/sLZND9X0XbIahaUEr8TWwg9eZjBErQZilR3Ttv2IkEzxcinEf5S4KH83wmVAGM6QN6Y5AJSqSFRWVyu6degdFNyjDFg7bKPQw8FC/8QeqQkqicgQ4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733837135; c=relaxed/simple;
	bh=uorSrgTMsxO83UHOUDN15prR5267ifmFoFJoQApUrEM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=WGl2bBkmkl0EFme5QOQnhbQ4B9CHt9YEPhvKwQmMaablev33ptwBHpVuy5g28inbc733+BwuFML0Dw3HkIZuNeSHXKAn8RLJ8tIkjEFLSuV73dz7iMBYA1pWJ+AhL4mZSTAK7PIKs15YIFaZmcKLjPhWpcTXimCsrqEmh+PWNUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DE/PdLr4; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733837134; x=1765373134;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=uorSrgTMsxO83UHOUDN15prR5267ifmFoFJoQApUrEM=;
  b=DE/PdLr4x4ymFE42eTtSgWbSXEIkYkXOMw/zw6RTsc3rbv6fF5SCr8Yb
   krCTpz8CFgSPRamwNXs+ua68xjX8wcMGcnPWCXMdULmMCgXjo1E9aBxy/
   IcnhLgvfhHKsTlZ3+M1H7y06QNW0nd3jog9b+mM1Odf5p3CBqwRtz9gJv
   UC3Lh9DDP8dlqFAkbSDKRPMrsrraM196sYaw6VnKrDDZowCiJ64PjVnuK
   0vKuVw1g/b3m4yNVxH2KVFR07/pA2sMmY53bCg41SB6EnqMtu+M0wKs65
   Qfn2WgrzM+1OtlHDnWumHRBUkkH4IHOVeycnFl5PYIf+6LglducHG7MI9
   Q==;
X-CSE-ConnectionGUID: CiTJeFfsQhWtcbcHBrKZPw==
X-CSE-MsgGUID: li09n00rQJaMc0uFkgUiQQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11282"; a="37864740"
X-IronPort-AV: E=Sophos;i="6.12,222,1728975600"; 
   d="scan'208";a="37864740"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2024 05:25:33 -0800
X-CSE-ConnectionGUID: kAXulFG/RNKzQ4U3tJAWng==
X-CSE-MsgGUID: Yb7NMUjdR+uW08Vk43f11w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,222,1728975600"; 
   d="scan'208";a="95750017"
Received: from rthomas.sc.intel.com ([172.25.112.51])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2024 05:25:33 -0800
From: Ramesh Thomas <ramesh.thomas@intel.com>
To: alex.williamson@redhat.com,
	jgg@ziepe.ca,
	schnelle@linux.ibm.com,
	gbayer@linux.ibm.com
Cc: kvm@vger.kernel.org,
	linux-s390@vger.kernel.org,
	ankita@nvidia.com,
	yishaih@nvidia.com,
	pasic@linux.ibm.com,
	julianr@linux.ibm.com,
	bpsegal@us.ibm.com,
	ramesh.thomas@intel.com,
	kevin.tian@intel.com,
	cho@microsoft.com
Subject: [PATCH v3 0/2]  Extend 8-byte PCI load/store support to x86 arch
Date: Tue, 10 Dec 2024 05:19:36 -0800
Message-Id: <20241210131938.303500-1-ramesh.thomas@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch series extends the recently added 8-byte PCI load/store
support to the x86 architecture. 

Refer patch series adding above support:
https://lore.kernel.org/all/20240522150651.1999584-1-gbayer@linux.ibm.com/

The 8-byte implementations are enclosed inside #ifdef checks of the
macros "ioread64" and "iowrite64". These macros don't get defined if
CONFIG_GENERIC_IOMAP is defined. CONFIG_GENERIC_IOMAP gets defined for
x86 and hence the macros are undefined. Due to this the 8-byte support
was not enabled for x86 architecture.

To resolve this, include the header file io-64-nonatomic-lo-hi.h that
maps the ioread64 and iowrite64 macros to a generic implementation in
lib/iomap.c. This was the intention of defining CONFIG_GENERIC_IOMAP.

Tested using a pass-through PCI device bound to vfio-pci driver and
doing BAR reads and writes that trigger calls to
vfio_pci_core_do_io_rw() that does the 8-byte reads and writes.

Patch history:
v3: Do not add the check for CONFIG_64BIT and only remove the checks for
ioread64 and iowrite64.

v2: Based on Jason's feedback moved #include io-64-nonatomic-lo-hi.h
to vfio_pci_rdwr.c and replaced #ifdef checks of iowrite64 and ioread64
macros with checks for CONFIG_64BIT.

https://lore.kernel.org/all/20240522232125.548643-1-ramesh.thomas@intel.com/
https://lore.kernel.org/all/20240524140013.GM69273@ziepe.ca/
https://lore.kernel.org/all/bfb273b2-fc5e-4a8b-a40d-56996fc9e0af@intel.com/

Ramesh Thomas (2):
  vfio/pci: Enable iowrite64 and ioread64 for vfio pci
  vfio/pci: Remove #ifdef iowrite64 and #ifdef ioread64

 drivers/vfio/pci/vfio_pci_rdwr.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

-- 
2.34.1


