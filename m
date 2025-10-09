Return-Path: <kvm+bounces-59747-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B3E4BCB307
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 01:24:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5F20E425013
	for <lists+kvm@lfdr.de>; Thu,  9 Oct 2025 23:24:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 704472882DB;
	Thu,  9 Oct 2025 23:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NKd5qfww"
X-Original-To: kvm@vger.kernel.org
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 429E72877DB
	for <kvm@vger.kernel.org>; Thu,  9 Oct 2025 23:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760052259; cv=none; b=YAauDYlmQoiCVdkuWxZkExSUgqPOZnIm2EPpUFgeUr27b0Gr7zj304onMARdcZMg4JpQnPxfeBBVfPx3sfcob7DeLCBHbLDcI/JKwOm2zLU1DCYuZRGPGGsesEm+05T2ngcqSQ6z2Fujpsj84RbjBpnmxFJQezmOw2qy9ZmsSVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760052259; c=relaxed/simple;
	bh=gb6+kgsPdEZsCXYqeP/WBffqIKJD+QujlZEul3CXZMk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sCh8VigY1iKcGYU4z3MOu6ZLBp5ZqEKi6+ncO0thaINRGg1tXvhhz3znGeEalV+TAGPL70OQymCoiDGWTRUDA6LdDMMs4KM9LRJikC+j+gWRdXqs44PMs23JEoL03YJs59RIL4nI63y+p6iIKTu/lVEcMQtN6Vy66G1jXlKveYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NKd5qfww; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 9 Oct 2025 23:24:10 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760052254;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c8+eqI1GnESCV/6qqpxbOeDo5s3/0CF3tmLj3ohK2TI=;
	b=NKd5qfww3DCPFBmMakUN/VXY67bbCvp+wCFdJz3v8bseNpFkVVRw+NDQsk+Q37ZFbIuS5l
	vC7jtWsCVPt+/V32kfuk7xIrWFo+BpS3QmVfakzY5jrDnI+f8hsp84H6mlDXXouqg5QwKE
	Dt5kw+H+j/VEJ7oy20wakfqga36ZOjQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Jim Mattson <jmattson@google.com>
Cc: Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/12] KVM: selftests: Remove invalid CR3 test from
 vmx_tsc_adjust_test
Message-ID: <7egn6azfxckepxadqwqg6s7lsu4ycm4lhchn2ijx7zydcseifw@jvfuvy4vz44h>
References: <20251001145816.1414855-1-yosry.ahmed@linux.dev>
 <20251001145816.1414855-6-yosry.ahmed@linux.dev>
 <CALMp9eT5DjpTy_UcU_99uHjSWymk09riWePTCzZG7RyHb5KFUw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALMp9eT5DjpTy_UcU_99uHjSWymk09riWePTCzZG7RyHb5KFUw@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Oct 09, 2025 at 03:55:32PM -0700, Jim Mattson wrote:
> On Wed, Oct 1, 2025 at 8:02 AM Yosry Ahmed <yosry.ahmed@linux.dev> wrote:
> >
> > From: Yosry Ahmed <yosryahmed@google.com>
> >
> > Checking that VMLAUNCH fails with an invalid CR3 is irrelevant to this
> > test. Remove it to simplify the test a little bit before generalizing it
> > to cover SVM.
> >
> > Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> 
> Is there value in moving the invalid CR3 test elsewhere, rather than
> just eliminating it?

It's a very basic test, but yeah we can keep it. I was doing the lazy
thing by just dropping it to see if anyone will comment.

I will find a new home for it (or keep it here out of more laziness).

