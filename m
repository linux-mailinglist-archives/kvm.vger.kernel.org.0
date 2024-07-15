Return-Path: <kvm+bounces-21638-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 09E959311AE
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 11:53:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B50EA1F22B13
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 09:53:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39CC718732C;
	Mon, 15 Jul 2024 09:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CiUxJTcl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4477335C0;
	Mon, 15 Jul 2024 09:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721037219; cv=none; b=oEhpG3FlOe3jEW3lgqWGgn2KJWzbKbZya9QvtU8DwzXbg2s/3HrFtS0MedeLKa9fwAp4gfgP7AGPlUTcYKWdavCBAFdCtG/Xroep+UDiIk9pnBnr8Z7sQjzsfRrhgncTKRjZ7HbkpSg/mb/2bSh/QpVP4pfCJmkOfRCkL+SEtJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721037219; c=relaxed/simple;
	bh=CfMnHS5zJUENrAraCEsrzQew3kJSn98ssCkzn4XE9vc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OUoBdHztlas1YAbFQNTP6DpGizFSJdqwAHQuRfAbRIDhcmuoZFeRcfRSbncF9v8li9F3DsK+KYTLh+ocN/T2vgHksac3enekf9jtoQ3Le/XaHv5IIIwIPPyizeTtiISKWKIIjWCrK7f0iUkr9xW7OPgHRcSODOpUSZ5EDovhy7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CiUxJTcl; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721037218; x=1752573218;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=CfMnHS5zJUENrAraCEsrzQew3kJSn98ssCkzn4XE9vc=;
  b=CiUxJTcl8omieCZu4XnbrCuRz9M1wW2L4mBBjnyHLhh5zEBOBotMR8GY
   a1KbjtfA25Xk6VUZKP3HjwHSVqqpZAWZbUHmxkkIMktitSeM7WFRAccUh
   jtlJEepPrQaDnW134p8ZVbhO4ri1PV5vg7acNGxbYxn2j03K64NiJDA/0
   VdzH4dCPeTDrWiFGyVVKCXPovHVOclp5ZrQPHsf5UiO0bcLU01zNetMDO
   +KFWD0EXgFWVlvXFO/P4F9fvUZHZBWWtCcxybrr/HhXQQlCNUoXur1+lX
   zMiQ2lI3mWg5KL9ENQzNzL+QDZR7aDwZXeNSDZRzzw4rctgiHs4/4ekV2
   g==;
X-CSE-ConnectionGUID: wePK3tVMTbCq2kE+r1zuvg==
X-CSE-MsgGUID: xmlsARpSQ9KYRwIpMhHudA==
X-IronPort-AV: E=McAfee;i="6700,10204,11133"; a="29800080"
X-IronPort-AV: E=Sophos;i="6.09,210,1716274800"; 
   d="scan'208";a="29800080"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2024 02:53:37 -0700
X-CSE-ConnectionGUID: 5YlYDFg1QSmphb37NGbiHA==
X-CSE-MsgGUID: il7UJBUKQ62fdIDdABr0gQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,210,1716274800"; 
   d="scan'208";a="49531650"
Received: from linux.bj.intel.com ([10.238.157.71])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2024 02:53:36 -0700
Date: Mon, 15 Jul 2024 17:48:37 +0800
From: Tao Su <tao1.su@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+2fb9f8ed752c01bc9a3f@syzkaller.appspotmail.com
Subject: Re: [PATCH] KVM: x86: Suppress MMIO that is triggered during task
 switch emulation
Message-ID: <ZpTwddPr+4X6CCof@linux.bj.intel.com>
References: <20240712144841.1230591-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240712144841.1230591-1-seanjc@google.com>

On Fri, Jul 12, 2024 at 07:48:41AM -0700, Sean Christopherson wrote:

[...]

> See commit 0dc902267cb3 ("KVM: x86: Suppress pending MMIO write exits if
> emulator detects exception") for more details on KVM's limitations with
> respect to emulated MMIO during complex emulator flows.
> 

I try to understand the changelog of commit 0dc902267cb3 but I’m confused with
the MMIO read. The commit said, "For MMIO reads, KVM immediately exits to
userspace upon detecting MMIO as userspace provides the to-be-read value in a
buffer, and so KVM can safely (more or less) restart the instruction from the
beginning." But in read_emulated(), mc->end is adjusted after checking rc,
i.e., although the value will be saved in the buffer, mc->end is not adjusted
after existing to userspace.

Maybe this would really support a buffer for multiple MMIO read instructions
(e.g. POPA)?

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 5d4c86133453..841d5b6f21b0 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1367,8 +1367,11 @@ static int read_emulated(struct x86_emulate_ctxt *ctxt,
 
 	rc = ctxt->ops->read_emulated(ctxt, addr, mc->data + mc->end, size,
 				      &ctxt->exception);
-	if (rc != X86EMUL_CONTINUE)
+	if (rc != X86EMUL_CONTINUE) {
+		if (rc == X86EMUL_IO_NEEDED)
+			mc->end += size;
 		return rc;
+	}
 
 	mc->end += size;

[...]

