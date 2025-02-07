Return-Path: <kvm+bounces-37548-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 782C3A2B96C
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 04:08:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 13FE7166715
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 03:07:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B5E0156236;
	Fri,  7 Feb 2025 03:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gHAWfr7d"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF3862030A;
	Fri,  7 Feb 2025 03:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738897670; cv=none; b=R1evhKnGSR5tGWVhnY9VWRVboZNoR3Bs+yTewo1sOts4f1NRE0ydPOYw0jG8MZ6it0PZHJBLBIDoMB1JiqhA+eBPkk3wmc5/fbjpTp4HNqQCbsj/9qroOgLUhnT/J4wYIe6nyH42aC8vNhf3u16y9jAj6lCqGL1Hb+/uAc8Ya+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738897670; c=relaxed/simple;
	bh=irmY+ScNwd02B+hlfgJ44cubtu6zCKlaPwTexghingU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fWWuoarY8W2K5j1h7ZWfjTuiPaZlQsPImpWGuk6ujfuqt5EygRm+ozLYChkLmlvL0LxkYsmohsBjyrG5VZV2B0ubc+xi5xmhYOWtx2K5ms5odqX4ItVUExLIwG5dWu1DsyMn44nndLOFnwg1lPH4IJNiSQ9H0NeCd9p704zr04E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gHAWfr7d; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1738897668; x=1770433668;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=irmY+ScNwd02B+hlfgJ44cubtu6zCKlaPwTexghingU=;
  b=gHAWfr7dBy+6G5VsYhIYqaqpBhRWLJ7AvGIbqgmFnKa6WAhNXUp5Fu4D
   e6V9/60TIyKBKpiIg30tzwpgeDi0ztsFBSgW21PoqcZ7qBIOXmJDx2I1G
   DI92675aWZdqYm43Yq4mpSMgM3ir29V8qdAkHcWmA/U3Z899iN5QuW0An
   R7ZSnSfgkwq79B5kKOZ5c5xPkoYb3OQ4DkbZANI03IEKVrVPfkaMdb5tk
   n60OzTdTmlzyqj1xYd6M9s7pHxAUoTIZOvTFzdRRCXx+aIry00zyvIs2L
   LM23dQsj8B54+oxGytJ4kmxbwiFVExl/ynHC8Ga6e7IiXDMGmFTP6zDnV
   Q==;
X-CSE-ConnectionGUID: SAMg61rSSGSI6Uypf0ch+A==
X-CSE-MsgGUID: V7rTsmiQQkuvm4gsCSn83A==
X-IronPort-AV: E=McAfee;i="6700,10204,11336"; a="39798636"
X-IronPort-AV: E=Sophos;i="6.13,266,1732608000"; 
   d="scan'208";a="39798636"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2025 19:07:47 -0800
X-CSE-ConnectionGUID: LVQEyuJ9Q4ms9cVUXgh3uA==
X-CSE-MsgGUID: LnwGmhcwTSels91lzG7ltw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,266,1732608000"; 
   d="scan'208";a="116436270"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2025 19:07:46 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: rick.p.edgecombe@intel.com,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH 0/4] Small changes related to prefetch and spurious faults
Date: Fri,  7 Feb 2025 11:06:40 +0800
Message-ID: <20250207030640.1585-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This series contains some small changes related to prefetch/prefault and
spurious faults.

Patch 1 checks if a shadow-present old SPTE is leaf to determine a
        prefetch fault is spurious.

Patch 2 merges the case of prefetch into the case of is_access_allowed().

Patch 3 is according to the previous discussion at [1].

Patch 4 always free obsolete roots before reload mmu.

With below scenario
1. add a memslot with size 4K
2. prefault GPA A in the memslot
3. delete the memslot
4. re-add the memslot with size 2M
5. prefault GPA A again.

Patch 1 is required if zap all quirk is disabled in step 3.
Patch 5 is required if zap all is performed in step 3 and if step 2/5 are
        executed before any vcpu_run().

The series can be applied to both
f7bafceba76e9ab475b413578c1757ee18c3e44b and
eb723766b1030a23c38adf2348b7c3d1409d11f0.

Thanks
Yan

[1] https://lore.kernel.org/kvm/Z2WTZGHmPDXHSrTA@google.com/

Yan Zhao (4):
  KVM: x86/mmu: Further check old SPTE is leaf for spurious prefetch
    fault
  KVM: x86/tdp_mmu: Merge the prefetch into the is_access_allowed()
    check
  KVM: x86/mmu: Make sure pfn is not changed for spurious fault
  KVM: x86/mmu: Free obsolete roots when pre-faulting SPTEs

 arch/x86/kvm/mmu/mmu.c     | 8 +++++++-
 arch/x86/kvm/mmu/tdp_mmu.c | 6 ++----
 2 files changed, 9 insertions(+), 5 deletions(-)

-- 
2.43.2


