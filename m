Return-Path: <kvm+bounces-63178-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E471C5B686
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 06:43:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8EDF53B292F
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 05:42:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C87E52C326F;
	Fri, 14 Nov 2025 05:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xmAHSUKQ"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F32F132117
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 05:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763098972; cv=none; b=B+6n5GICLVywhq7f+ZGDZndbZh5cXdUc8VVigzsB9FdQFos+hKLgv6l3QxERh8QwQ4jKTTc+qDJpLz3av5l7zfNPq7MYDfD8dpJWfwCVh406OoTHFxIzr9x2J8jltVxupDpPeYH76T1D8m8R+YGZ4oZ99IKGQIsPaIsygSwO4W0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763098972; c=relaxed/simple;
	bh=aMKNqwgl/9WlJI+YdRWPaBz9oYrKvbhXP1T7EG0A7VI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ItAx5C9fVCDqn8fZ+xmYs+AVooUcDLAFrRYajNpQjLkn8ZrsGWixr+alRHiOBBb6v6tBsp4/1D/pp8Km+4cprT6iB7duSj4GBy9IEXhzR308JJqtaOfclZoiK3I+LkAjnlmOdNqADoLVBtxNMOUwkCo/h2lZH6l/RPYf6b/3PD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xmAHSUKQ; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 14 Nov 2025 05:42:39 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763098968;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zFsOTmlsOl708GIPzuojLKXbIV8VsQWdXvhf1T+bUwY=;
	b=xmAHSUKQ9eSB7qN/0WHZtQt8N47zHjtFAwsv3QRVyIuONz6ZUkBvRCJOih8s3/CcCDmHVV
	H3Hn++tE4jKCvOEsPFHMWz6nMUEcEEw+HiNfxFFYiMiniVBiILz0ylOuFpV1n+xvY2yY+B
	41JVOswiFL1i7wR4/pQrofofaoiZQ68=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Kevin Cheng <chengkev@google.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 00/14] Improvements for (nested) SVM testing
Message-ID: <dgptshkyiqlf7yjkebkglvrwhp5khq52myrfr2isfniwptelrw@vdc7duibowiz>
References: <20251110232642.633672-1-yosry.ahmed@linux.dev>
 <176307992383.1723017.8674241803582531057.b4-ty@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176307992383.1723017.8674241803582531057.b4-ty@google.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Nov 13, 2025 at 04:46:13PM -0800, Sean Christopherson wrote:
> On Mon, 10 Nov 2025 23:26:28 +0000, Yosry Ahmed wrote:
> > This is a combined v2/v3 of the patch series in [1] and [2], with a
> > couple of extra changes.
> > 
> > The series mostly includes fixups and cleanups, and more importantly new
> > tests for selective CR0  write intercepts and LBRV, which cover bugs
> > recently fixed by [3] and [4].
> > 
> > [...]
> 
> Applied to kvm-x86 next.  In the future, please only bundle related and/or
> dependent patches, especially for one-off patches.  It's a lot easier on my
> end (and likely for most maintainers and reviewers) to deal separate series.
> 
> E.g. if you need to spin a new version, then you aren't spamming everyone
> with 10+ patches just to rev one patch that might not even be realted to the
> rest.  And having separate series makes it easier to select exactly what I
> want to apply.

Noted. I thought that I was going to end up sending a handful of
scattered patches and it will actually end up being difficult for you to
keep track of them. To be honest, it was also easier for me :P

Anyway, will separate such changes going forward!

> 
> Concretely, at a glance, this could/should be 7 different patches/series:
> 
>    1, 2, 3-5 + 7 + 10-11, 6, 8, 9, 12-13, 14

3-5 + 7 + 10-11 is more-or-less what was in v1. I piled the rest on the
series :)

> 
> [01/14] scripts: Always return '2' when skipping tests
>         https://github.com/kvm-x86/kvm-unit-tests/commit/1825b2d46c1a
> [02/14] x86/vmx: Skip vmx_pf_exception_test_fep early if FEP is not available
>         https://github.com/kvm-x86/kvm-unit-tests/commit/cab22b23b676
> [03/14] x86/svm: Cleanup selective cr0 write intercept test
>         https://github.com/kvm-x86/kvm-unit-tests/commit/5f57e54c42e6
> [04/14] x86/svm: Move CR0 selective write intercept test near CR3 intercept
>         https://github.com/kvm-x86/kvm-unit-tests/commit/0fa8b9beffba
> [05/14] x86/svm: Add FEP helpers for SVM tests
>         https://github.com/kvm-x86/kvm-unit-tests/commit/1c5e0e1c75aa
> [06/14] x86/svm: Report unsupported SVM tests
>         https://github.com/kvm-x86/kvm-unit-tests/commit/d7e64b50d0e3
> [07/14] x86/svm: Move report_svm_guest() to the top of svm_tests.c
>         https://github.com/kvm-x86/kvm-unit-tests/commit/9af8f8e09dff
> [08/14] x86/svm: Print SVM test names before running tests
>         https://github.com/kvm-x86/kvm-unit-tests/commit/044c33c54661
> [09/14] x86/svm: Deflake svm_tsc_scale_test
>         [ DROP ]
> [10/14] x86/svm: Generalize and improve selective CR0 write intercept test
>         https://github.com/kvm-x86/kvm-unit-tests/commit/cc34f04ac665
> [11/14] x86/svm: Add more selective CR0 write and LMSW test cases
>         https://github.com/kvm-x86/kvm-unit-tests/commit/09e2c95edefd
> [12/14] x86/svm: Cleanup LBRV tests
>         https://github.com/kvm-x86/kvm-unit-tests/commit/114a564310f6
> [13/14] x86/svm: Add more LBRV test cases
>         https://github.com/kvm-x86/kvm-unit-tests/commit/ffd01c54af99
> [14/14] x86/svm: Rename VMCB fields to match KVM
>         [ WAIT ]
> 
> --
> https://github.com/kvm-x86/kvm-unit-tests/tree/next

