Return-Path: <kvm+bounces-2426-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 16A097F704A
	for <lists+kvm@lfdr.de>; Fri, 24 Nov 2023 10:45:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C26281F20F23
	for <lists+kvm@lfdr.de>; Fri, 24 Nov 2023 09:45:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8013D171BC;
	Fri, 24 Nov 2023 09:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="e7f94pez"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80D40D68;
	Fri, 24 Nov 2023 01:45:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Q04QX2XORVuRYVk3Q76mtdjHo7RHw4z3tLXdjxXDBbU=; b=e7f94pez0o4pH8GJtdQLvvrb/K
	QM8zbbzp0e70Ta9FPV+Fp6nlHm5hidpLRSEWjY2Mj9MGUPqRzVZF7tUFAWvcR3yKAruCCzq9M6eKh
	/hah733yG5gALgRdgiS6k3GWt7OvJXCxmq++mgZQZTDDPEmiLsb/wTaxeLQ2MjbWHBqhG/U/OhFmW
	Kpcv+ZsQMOHe4CmmpMEq/zriijNfnO0gkNRq9b9JiPvjqyKT9kNpSn4OFQwR0Bdi+bdAsvnY7W2C9
	xO2NuEbfh1YqpB7j4A19BbCBe8ApTiFZSCGczimyIVbMmhYSmNSAy97E+cl8MhWyOVczkvZOKTd5o
	/AXqbm/Q==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1r6SkB-008R1y-43; Fri, 24 Nov 2023 09:45:03 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 7155D3002BE; Fri, 24 Nov 2023 10:45:02 +0100 (CET)
Date: Fri, 24 Nov 2023 10:45:02 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Yang Weijiang <weijiang.yang@intel.com>
Cc: seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	chao.gao@intel.com, rick.p.edgecombe@intel.com, mlevitsk@redhat.com,
	john.allen@amd.com
Subject: Re: [PATCH v7 03/26] x86/fpu/xstate: Add CET supervisor mode state
 support
Message-ID: <20231124094502.GL3818@noisy.programming.kicks-ass.net>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
 <20231124055330.138870-4-weijiang.yang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231124055330.138870-4-weijiang.yang@intel.com>

On Fri, Nov 24, 2023 at 12:53:07AM -0500, Yang Weijiang wrote:

> Note, in KVM case, guest CET supervisor state i.e., IA32_PL{0,1,2}_MSRs,
> are preserved after VM-Exit until host/guest fpstates are swapped, but
> since host supervisor shadow stack is disabled, the preserved MSRs won't
> hurt host.

Just to be clear, with FRED all this changes, right? Then we get more
VMCS fields for SSS state.

