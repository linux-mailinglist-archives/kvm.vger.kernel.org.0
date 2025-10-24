Return-Path: <kvm+bounces-61070-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9262BC07F9F
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 22:03:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 514193B2F7B
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 20:02:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0F312D877D;
	Fri, 24 Oct 2025 20:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rwRgO4o8"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98B9B2D7DCC;
	Fri, 24 Oct 2025 20:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761336157; cv=none; b=hrYSNaG/SD0jZL/n27qDvYep8iQxfV3unDymj7JE0VXAHijjuFOIfWm9uJWLVUdsaxBlWLtv5cMxryyCV9g7qO36GD6+ItEh1U43b2NGeQOHOzGEWrvxSCTX/OLdhuVHdVb00KBOQVj48QQdN1T9U04fXwM1AfR3eCD+z9TnHEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761336157; c=relaxed/simple;
	bh=vfUgt4k72DvBEeU2fU4/r5DGQD0ftgObA4BeYkuVwIE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ka6jnLtgwVUqmEicS4D0H7cjSwk4LylXb1yBzVBz1xAzG1FhhUju5us5KS9McgUp5ae25pYzwB27wNOWShGPH1izwgkxJ2fC1TPDN72f+vLYvJFLULLAutFn1iplQfc4+QpBrdGa8YlVGUFnzWSIX+UMNR07LyG5okpLFZ3l4Wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rwRgO4o8; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 24 Oct 2025 20:02:18 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761336152;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=H2bUD9KlKdYatiPyUTCu38afpr/yquVN3OzkBaN2pF8=;
	b=rwRgO4o8NabR8babRurPwwO4kZlQATGm7wai2lokHSk0AivOGhmLTbkIx/AGgbnhOBPnXp
	JiuYiiKxV3buNq1wYxgu7/njf6huSyn6JW2cJuhRK1oi2eeWREI/9VuoItsdYH2Iy7NDK0
	Fc6h81ksXE8LHSYV4dSJtlDjJs498vg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [kvm-unit-tests 0/7] More tests for selective CR0 intercept
Message-ID: <7cteriht5er2w6tdoqryymd3adxm2s3ysx36wkr5jvmvkx7oud@6r7r77gguzhu>
References: <20251024194925.3201933-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251024194925.3201933-1-yosry.ahmed@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Fri, Oct 24, 2025 at 07:49:18PM +0000, Yosry Ahmed wrote:
> From: Yosry Ahmed <yosryahmed@google.com>

Ugh I messed up the From email address again (and the Signed-off-by)..

> 
> Add more test cases for the selective CR0 write intercept, covering bugs
> fixed by
> https://lore.kernel.org/kvm/20251024192918.3191141-1-yosry.ahmed@linux.dev/.
> 
> Patches 1-5 are cleanups and prep work. Patch 6 generalizes the existing
> test to make it easy to extend, and patch 7 adds the actual tests.
> 
> Yosry Ahmed (7):
>   x86/svm: Cleanup selective cr0 write intercept test
>   x86/svm: Move CR0 selective write intercept test near CR3 intercept
>   x86/svm: Add FEP helpers for SVM tests
>   x86/svm: Report unsupported SVM tests
>   x86/svm: Move report_svm_guest() to the top of svm_tests.c
>   x86/svm: Generalize and improve selective CR0 write intercept test
>   x86/svm: Add more selective CR0 write and LMSW test cases
> 
>  lib/x86/desc.h  |   8 +++
>  x86/svm.c       |   9 ++-
>  x86/svm.h       |   1 +
>  x86/svm_tests.c | 178 ++++++++++++++++++++++++++++++++++--------------
>  4 files changed, 144 insertions(+), 52 deletions(-)
> 
> -- 
> 2.51.1.821.gb6fe4d2222-goog
> 

