Return-Path: <kvm+bounces-51757-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 53F9DAFC82A
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 12:20:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 354154838FB
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 10:19:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2E4F26B2B3;
	Tue,  8 Jul 2025 10:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZJ4Z77Hq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79DC9256C8D;
	Tue,  8 Jul 2025 10:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751969975; cv=none; b=ofwIK+ZYPSW/i7lIF34SGJ44oLT/FqDwq5YpDDx2OXifkeVsMPFPTjMWvjpxFxMjoPWsiBuSI4CG65Sexse2wKuAxZBLNIPCJ3/U1ArZBfRH/pEpLa1scd9uSlTdrhziP/rr7fhBiSImrMeKiQ51byiZVafJcs9OZx3gN5Oxb2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751969975; c=relaxed/simple;
	bh=wvJMYsc9yWz2URT+SK4ZAszSqtGgIMpsnmycjhsLP10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dvUP2/wh/A0+m4tXct8fcILbtkO8e5RsXMBS4qNzZ1ZscgPgJMfKUwXlfCG8GFSskGfTEa2vVOKpyEW/u385+Uit6wcX9VbcH6ARUUFDShR12TNKpaBB0Su/OJnaIcAZE1zYsj/F8I3bNpqydLQhsroQQi5+XplrVTplOnJ9xbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.helo=mgamail.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZJ4Z77Hq; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.helo=mgamail.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751969975; x=1783505975;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wvJMYsc9yWz2URT+SK4ZAszSqtGgIMpsnmycjhsLP10=;
  b=ZJ4Z77Hqk8PGSZ73TlH+PNvnDiLofw23OnszGwlppVKhefmDXsYfWxqc
   WA0I/tGUSXgmBl1Q3yoVDL9bZotOrphItryR5M1ru0zJhNe0wZUZkNSqX
   ImyIgpUHmLTaBxiS03cJhwOkuh+3vH5eSofzgqCtClxm6BmsAgRozE45B
   57clgib8FdI+T8o2XEkr6jZGREkRL9m86F8C80T0AyyuEcmtT79QySOKv
   6JkTLwfEhB49O6X2TKP3H1qSha2lTMJ2VZIqmMqyJVtKYU8+MQVdd3le6
   sLAbEWUhufalBwMy5gw0ut90KRkk9aZmDlQHOGDukiToij/N4+sOv2Di3
   g==;
X-CSE-ConnectionGUID: WQf8ui9vS0uyQMRaQZOjdg==
X-CSE-MsgGUID: 4utsMFzoQQi1tkkq7OraFw==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="76751336"
X-IronPort-AV: E=Sophos;i="6.16,297,1744095600"; 
   d="scan'208";a="76751336"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 03:19:33 -0700
X-CSE-ConnectionGUID: TVh3WA+aQ0qfksSH3ynRVA==
X-CSE-MsgGUID: 1kOjowWnSzC9c4OYM785lQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,297,1744095600"; 
   d="scan'208";a="155196381"
Received: from black.fi.intel.com ([10.237.72.28])
  by orviesa009.jf.intel.com with ESMTP; 08 Jul 2025 03:19:28 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id A0F741B5; Tue, 08 Jul 2025 13:19:27 +0300 (EEST)
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Dave Hansen <dave.hansen@linux.intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-coco@lists.linux.dev,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH 2/3] MAINTAINERS: Add Rick Edgecombe as a TDX reviewer
Date: Tue,  8 Jul 2025 13:19:21 +0300
Message-ID: <20250708101922.50560-3-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250708101922.50560-1-kirill.shutemov@linux.intel.com>
References: <20250708101922.50560-1-kirill.shutemov@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rick worked extensively to enable TDX in KVM. He will continue to work
on TDX and should be involved in discussions regarding TDX.

Add Rick as a TDX reviewer.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8071871ea59c..b0363770450f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -26947,6 +26947,7 @@ F:	arch/x86/kernel/unwind_*.c
 X86 TRUST DOMAIN EXTENSIONS (TDX)
 M:	Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
 R:	Dave Hansen <dave.hansen@linux.intel.com>
+R:	Rick Edgecombe <rick.p.edgecombe@intel.com>
 L:	x86@kernel.org
 L:	linux-coco@lists.linux.dev
 S:	Supported
-- 
2.47.2


