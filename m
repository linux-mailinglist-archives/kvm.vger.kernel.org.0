Return-Path: <kvm+bounces-59341-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 35155BB15FD
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 19:37:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9001E3B7DB6
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 17:37:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86B272D2389;
	Wed,  1 Oct 2025 17:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oeFDfJlp"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF017288DB;
	Wed,  1 Oct 2025 17:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759340252; cv=none; b=MJOpkz3iCAutOSTbD9iycQxRS0tlf8UvX+mKIpfhjcCB72SnppRdbpByH9RQFGaP/3H053cqcEPb8Ijq4puk+peOJf+79JTjLJFG0IYY5Ft3Uthj4DzRDIzQBrwE2dkKiX0A0dCfRWDT0404pq0w4Fo6wDWF1uM4PVhyc8NQTJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759340252; c=relaxed/simple;
	bh=/x8jnFlp+pZikJIsr0XFxgtMvU+vygC3iiTNoADfSU8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LKJFxwMydE+oJm2+Ml5MwWyCHUL3wQzrmNmfzSTk/28CM03RPRRQbSZUOwRX26i5+8zWYltdbrMGridMN9fGdjnGxgI8OnLR6UfZiFhnskngrLAyvm9rjTCDoIyBbJZ8spEIV16V40v+a0BP3e2A7j4D22dIlm1YGYW0B2oWOIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=oeFDfJlp; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 1 Oct 2025 17:37:24 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759340247;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ClGwCAWgmd6Y9XhcXrM4mIg0PMmoGJSBh00dpa+3S9I=;
	b=oeFDfJlpcIuYigHDZAqOeHCTn0pnMtlMZPjNPQDu/I9hZyqVpnD0GcKawWD4cH7AIQ+mgn
	rPoeWdo/Ik2hYIqpdbij2ROwmx43oBWf6oZVIqjyxc4nC0ZqdrwUJqLlzWgdZKp2aAWcFh
	rshRkbNvLdtmQgfKx9+v8qLgwc+/T3Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/12] Extend test coverage for nested SVM
Message-ID: <7o6d5jxr4t6t5p4x3dhnwcllcnzf3radjblqaqd54sc3liilvf@frz74eu2ubb7>
References: <20251001145816.1414855-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251001145816.1414855-1-yosry.ahmed@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Wed, Oct 01, 2025 at 02:58:04PM +0000, Yosry Ahmed wrote:
> There are multiple selftests exercising nested VMX that are not specific
> to VMX (at least not anymore). Extend their coverage to nested SVM.
> 
> Yosry Ahmed (12):
>   KVM: selftests: Minor improvements to asserts in
>     test_vmx_nested_state()
>   KVM: selftests: Extend vmx_set_nested_state_test to cover SVM
>   KVM: selftests: Extend vmx_close_while_nested_test to cover SVM
>   KVM: selftests: Extend vmx_nested_tsc_scaling_test to cover SVM
>   KVM: selftests: Remove invalid CR3 test from vmx_tsc_adjust_test
>   KVM: selftests: Extend vmx_tsc_adjust_test to cover SVM
>   KVM: selftests: Pass the root HVA directly to nested mapping functions
>   KVM: selftests: Use 'leaf' instead of hugepage to describe EPT entries
>   KVM: selftests: Move all PTE accesses into nested_create_pte()
>   KVM: selftests: Move EPT-specific init outside nested_create_pte()
>   KVM: selftests: Refactor generic nested mapping outside VMX code
>   KVM: selftests: Extend vmx_dirty_log_test to cover SVM

Ugh, wrong From email on all the patches due to some unorthodox
cherry-picking :)

> 
>  tools/testing/selftests/kvm/Makefile.kvm      |  11 +-
>  .../selftests/kvm/include/x86/nested_map.h    |  20 ++
>  .../selftests/kvm/include/x86/svm_util.h      |  13 ++
>  tools/testing/selftests/kvm/include/x86/vmx.h |  13 +-
>  .../testing/selftests/kvm/lib/x86/memstress.c |   5 +-
>  .../selftests/kvm/lib/x86/nested_map.c        | 150 +++++++++++++++
>  tools/testing/selftests/kvm/lib/x86/svm.c     |  70 +++++++
>  tools/testing/selftests/kvm/lib/x86/vmx.c     | 180 +++---------------
>  ...ested_test.c => close_while_nested_test.c} |  42 +++-
>  ...rty_log_test.c => nested_dirty_log_test.c} |  95 ++++++---
>  ...adjust_test.c => nested_tsc_adjust_test.c} |  79 ++++----
>  ...aling_test.c => nested_tsc_scaling_test.c} |  48 ++++-
>  ...d_state_test.c => set_nested_state_test.c} | 132 +++++++++++--
>  13 files changed, 609 insertions(+), 249 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/include/x86/nested_map.h
>  create mode 100644 tools/testing/selftests/kvm/lib/x86/nested_map.c
>  rename tools/testing/selftests/kvm/x86/{vmx_close_while_nested_test.c => close_while_nested_test.c} (64%)
>  rename tools/testing/selftests/kvm/x86/{vmx_dirty_log_test.c => nested_dirty_log_test.c} (62%)
>  rename tools/testing/selftests/kvm/x86/{vmx_tsc_adjust_test.c => nested_tsc_adjust_test.c} (61%)
>  rename tools/testing/selftests/kvm/x86/{vmx_nested_tsc_scaling_test.c => nested_tsc_scaling_test.c} (83%)
>  rename tools/testing/selftests/kvm/x86/{vmx_set_nested_state_test.c => set_nested_state_test.c} (67%)
> 
> -- 
> 2.51.0.618.g983fd99d29-goog
> 

