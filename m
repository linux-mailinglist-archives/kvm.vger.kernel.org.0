Return-Path: <kvm+bounces-63491-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 22C3AC67BD6
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 07:36:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sea.lore.kernel.org (Postfix) with ESMTPS id D46B92976A
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 06:36:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA9132EA16C;
	Tue, 18 Nov 2025 06:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AQhqmmdV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2A11B4257
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 06:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763447763; cv=none; b=uV0ixUHJ226LOFXJkXBQxIW91oLpD8uwow/dekxu1KHPTyiTLHAIqKn6UBGenQ3ySmA23pj2eRGTpdmhlQr/Chu9lfwi9LuhiTYav3RjucPKNDFfTmhM08QtCaHhEbMGKL6bJDxkkXP5kI8zh5kFuDppGbEjGvY3blImqYlx+f4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763447763; c=relaxed/simple;
	bh=A65mMd5lWNs6XXTjhO21knFYXJM3Yt8rXvU/WLqh2Ko=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=kAX7Z0T57wUFtlzNT/ZwEgh53FmBjF5pf9+iEtD10dgijZMHaDEC+Ht7PR3oAGfBkX3keMF4hlGticqyFP9+jZ+Z+ZjhZtqKzc4rJM7wZprwTHt+Y+rCIDQTmX8g0RLliUpXZdRTfTMXpynsS/8okUIIhkePbOMV/8lF2w18TSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AQhqmmdV; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763447762; x=1794983762;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=A65mMd5lWNs6XXTjhO21knFYXJM3Yt8rXvU/WLqh2Ko=;
  b=AQhqmmdVl/NMzQIMCyhmZKfVTp2/Q8fGiabI+wTbM6QI1L0RLD7FqAQt
   OWP/ozFtZnZ6xbiQxOiWI62PC4mNSVamRysAxEjx0zeoxtXujLpEGVCV7
   pjV4Y7A3ia9W8RtZVdr3sndc2RR8NKj4FOhpwRuXSz3r6XkyWZ/6GOcSk
   B/GXiET/ET43RuRiBnHMrGXfMwURjrDBbrRwL92hupzVVCDCENDoO/Hiu
   75L0D/ETNhiJ43fhJPogp41Ug5/9au9XMTzXdYSj+ybLujOPCG8kphVla
   R7nS9VKRzDbXl2vie0ZYTf4qSSvyP8tItv6Df1H987KV7Aj8qAv8jAvZ9
   Q==;
X-CSE-ConnectionGUID: D5ZHd9TLRu2fRuNNRwhgQA==
X-CSE-MsgGUID: 2JGwUGUdRQaIsno6JnIi0A==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="82850934"
X-IronPort-AV: E=Sophos;i="6.19,314,1754982000"; 
   d="scan'208";a="82850934"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 22:36:01 -0800
X-CSE-ConnectionGUID: NHinHyBvTS+9fcI76gGa9g==
X-CSE-MsgGUID: 9zQlB8GdQYK4i39ikxw46g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,314,1754982000"; 
   d="scan'208";a="189962628"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa010.jf.intel.com with ESMTP; 17 Nov 2025 22:35:59 -0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	"Chang S . Bae" <chang.seok.bae@intel.com>,
	Zide Chen <zide.chen@intel.com>,
	Xudong Hao <xudong.hao@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH 0/5] i386/cpu: Support APX for KVM
Date: Tue, 18 Nov 2025 14:58:12 +0800
Message-Id: <20251118065817.835017-1-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

This series adds APX (Advanced Performance Extensions) support in QEMU
to enable APX in Guest based on KVM.

This series is based on CET v4:

https://lore.kernel.org/qemu-devel/20251118034231.704240-1-zhao1.liu@intel.com/

And you can also find the code here:

https://gitlab.com/zhao.liu/qemu/-/commits/i386-all-for-dmr-v1.1-11-17-2025

The patches for KVM side can be found at:

https://lore.kernel.org/kvm/20251110180131.28264-1-chang.seok.bae@intel.com/


Thanks for your review!


Overview
========

Intel Advanced Performance Extensions (Intel APX) expands the Intel 64
instruction set architecture with access to more registers (16
additional general-purpose registers (GPRs) R16–R31) and adds various
new features that improve general-purpose performance. The extensions
are designed to provide efficient performance gains across a variety of
workloads without significantly increasing silicon area or power
consumption of the core. 

APX spec link (rev.07) is:
https://cdrdv2.intel.com/v1/dl/getContent/861610

At QEMU side, the enabling work mainly includes two parts:

1. save/restore/migrate the xstate of APX.
   * APX xstate is a user xstate, but it reuses MPX xstate area in
     un-compacted XSAVE buffer.
   * To address this, QEMU will reject both APX and MPX if their CPUID
     feature bits are set at the same (in Patch 1).

2. add related CPUIDs support in feature words.

Thanks and Best Regards,
Zhao
---
Zhao Liu (2):
  i386/cpu: Support APX CPUIDs
  i386/cpu: Mark apx xstate as migratable

Zide Chen (3):
  i386/cpu: Add APX EGPRs into xsave area
  i386/cpu: Cache EGPRs in CPUX86State
  i386/cpu: Add APX migration support

 target/i386/cpu.c          | 68 ++++++++++++++++++++++++++++++++++++--
 target/i386/cpu.h          | 26 +++++++++++++--
 target/i386/machine.c      | 24 ++++++++++++++
 target/i386/xsave_helper.c | 14 ++++++++
 4 files changed, 128 insertions(+), 4 deletions(-)

-- 
2.34.1


