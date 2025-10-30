Return-Path: <kvm+bounces-61466-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C580C1ECC9
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 08:37:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0891F1896787
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 07:38:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F4D33376A3;
	Thu, 30 Oct 2025 07:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="V7sgk+D7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3DB3241695
	for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 07:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761809849; cv=none; b=Dkx54n954oacw2z3kAv9BUjeXMCq9h15jB/5MC1qbU0zmLGB2BHOTfjO8u7fvIHQSxer7yBQUuonTYLOdih2ZC13kBuSKZTuVdZoMsy047FjKeyBPDh+QCAXzj4cBm3cdV9h1Cidkg4Dj+a9uhs7DDWEJd2Dgsclh5/iNSy6uYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761809849; c=relaxed/simple;
	bh=XEYqBp5IFwaMA3wIDDqbOBvGDSk7djaOF7tel6gS8Ws=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZBZaW9Ai1Rif7Wg5ji53pPOyylkolRImrZoxgM3duJ0HB2FTu/jRCMZpqBjHQpXF+IQnyoyVrYBlTwwUl/PzZ7aMPK/SyMKLtySJ1/nYatT74eXZVvAh7Gl+Le25F0PagnYqN0SbMADX/5kFN8i9qc2yABQu4S53vxMOhGym0sY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=V7sgk+D7; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761809848; x=1793345848;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=XEYqBp5IFwaMA3wIDDqbOBvGDSk7djaOF7tel6gS8Ws=;
  b=V7sgk+D75kHYjFfWWEUHcw5s+3Znyp0yLNKPEc96lHROKSNiekSJl37H
   6oTHQT4WMNiymZ8WmSs85j6gBtWMYTHhhx+0429jPcp0CLfV5unEnzb8s
   C61Vjm+Gw9Gx/TH6z9vad3xA4pYCeiJhjvn7ZuArnZ1+RUtKrIYNcNvOl
   4GrUIL1CSZSzRrk6BhvsTAjrguTl5gINGAB5y77gQi7czZ4uzlq0Ri/9r
   vk6pHyTA1aCLVVb6advOzfnHGyCAbXJBqZyYJCTsaIULHTer1RQp0MXQY
   /YJM+y1ZJsnNx/1AxAM/t1wjvmBDcKHU9ajuIeLwnQBeUTqm/fTzM8DtI
   w==;
X-CSE-ConnectionGUID: v0x2i5okToeI+Qn3Kfknaw==
X-CSE-MsgGUID: hLa+uFH5R16liRsOG268LQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="63845615"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="63845615"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2025 00:37:28 -0700
X-CSE-ConnectionGUID: qNHEFOXMQju1/17pbOeM0Q==
X-CSE-MsgGUID: XGyuw1NfRaqO3NlhKiubtA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,266,1754982000"; 
   d="scan'208";a="186229652"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2025 00:37:26 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org
Cc: seanjc@google.com,
	minipli@grsecurity.net,
	Chao Gao <chao.gao@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm-unit-tests PATCH v2 0/2] Fix triple fault in eventinj test
Date: Thu, 30 Oct 2025 00:37:21 -0700
Message-ID: <20251030073724.259937-1-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As reported in [1], the eventinj test can cause a triple fault due to an
invalid RSP after IRET. Fix this by pushing a valid stack pointer to the
crafted IRET frame in do_iret(), ensuring RSP is restored to a valid
stack in 64-bit mode.

[1]: https://lore.kernel.org/kvm/aMahfvF1r39Xq6zK@intel.com/

Chao Gao (2):
  x86/eventinj: Use global asm label for nested NMI IP address
    verification
  x86/eventinj: Push SS and SP to IRET frame

 x86/eventinj.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

-- 
2.47.3


