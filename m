Return-Path: <kvm+bounces-54370-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 65586B1FF65
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 08:31:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 81C0B1656AE
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 06:31:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD7032D63E5;
	Mon, 11 Aug 2025 06:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Xya46S0C"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E3E32750FB
	for <kvm@vger.kernel.org>; Mon, 11 Aug 2025 06:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754893857; cv=none; b=ZfHMk3KIABSuCMxJaU2MG0EoH8UJmLkDY/abK8UJuAGibi0qep23Qh5HAy20EyFCIFRH9NVyAMCi87iU64B36Q/me1WOLSmNB3reBnReWRRg5M6bBftiGmQ6MIF5SNQBjrbQnasJY5MbltwRIX0W6BzohQeH2aKjUDbDwFtxrI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754893857; c=relaxed/simple;
	bh=Q1KUbveF1o+vIqWuCGSlMXHBaVY/YluZqUIs+iEnnD8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KeX7lkByOUrnGj+C89Fr5JFu8PC0/7mHniXsIW1EV8RSFdLvIEEgiBIBvZr99GJ+lIhcjBa6BFLIxb9lJQXIaN2Q9XWmtach8wBMnd19yjrgo+TOh9glk6frGB04Ap6qpsdyER/lZwc9yZlECag2DLWwI+MYcwM06zDXZBvV59Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Xya46S0C; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754893857; x=1786429857;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Q1KUbveF1o+vIqWuCGSlMXHBaVY/YluZqUIs+iEnnD8=;
  b=Xya46S0C8l33FXqz8P17rzkSASVJkdNePY9mjldp8ymGGfHWAsQVn45Z
   LseYVqAQ06lZ1/ajJ5+WhnNBflkoKZqk8LuhwiisFcTNnZ1x6HNmjLV8X
   clEgv0SBGQ4q9zxkRRx8UEUPvb1aMLaz6ST9njQ3a18jPYjpW+9q0dUyJ
   OuA7sDV5akWn4TAyR9kLvZsdzcNdONix87UpKaFNNUPU1uwCWogvNRQFE
   +AJfayB0JzfOQOFF9yLHsCWRhBxfgzTdkEvHVi+U1eTANQ9B8GFCFpJ0l
   yVHhFw9EsZVhuvT/z4roaBvl4WQrWUJS3vq9kg861e/hNoMpNRgdGo2rd
   A==;
X-CSE-ConnectionGUID: zJJ5XS20THWFsXPWvhSOdA==
X-CSE-MsgGUID: 2yFmDM0AQGWcpmZUqRYg4w==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="79707643"
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="79707643"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2025 23:30:55 -0700
X-CSE-ConnectionGUID: +8aBPSHQT7yJHrzmyR0CeA==
X-CSE-MsgGUID: laqLSXqoSsCeVSqKTm/Fyw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="196666470"
Received: from emr-bkc.sh.intel.com ([10.112.230.82])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2025 23:30:53 -0700
From: Chenyi Qiang <chenyi.qiang@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Chenyi Qiang <chenyi.qiang@intel.com>,
	kvm@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [kvm-unit-tests PATCH 0/2] nVMX: Improve IA32_DEBUGCTLMSR test on debug controls
Date: Mon, 11 Aug 2025 14:30:32 +0800
Message-ID: <20250811063035.12626-1-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Current nested debugctls test focuses on DR7 value and fakes the result of
IA32_DEBUGCTLMSR in comment. Although the test can pass because DR7 is the
only criterion to determine the result, there are some error messages
appearing in dmesg due to accessing to BTF | LBR bits in IA32_DEBUGCTLMSR
with report_ignored_msrs KVM parameter enabled.

Try to avoid these error messages by using some valid bit in
IA32_DEBUGCTLMSR in a separate test.

Chenyi Qiang (2):
  nVMX: Remove the IA32_DEBUGCTLMSR access in debugctls test
  nVMX: Test IA32_DEBUGCTLMSR behavior on set and cleared save/load
    debug controls

 x86/vmx_tests.c | 134 ++++++++++++++++++++++++++++++++++++------------
 1 file changed, 102 insertions(+), 32 deletions(-)


base-commit: 989726f28e1e2137a5cafbe187fffc335cc15b2a
-- 
2.43.5


