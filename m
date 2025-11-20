Return-Path: <kvm+bounces-64003-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id E2E42C76A61
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 00:47:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 607B74E4808
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 23:47:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E62D30DD22;
	Thu, 20 Nov 2025 23:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="b6Rr1QbY"
X-Original-To: kvm@vger.kernel.org
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C495221FCD
	for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 23:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763682423; cv=none; b=uWPv5AK51Tu0R4+Qg0V66MCJfRAeD2H7ETgwMb+Xg9MByAQ1o0EhFLy+ABhjIb0rVPH7+sjMv9+vqmCv5waddk0GpPzgyngseSrm6FEioa5LAT7Pz3V5w3+ekP4mZ4KZzU3RmsVYWm5G0ZbZ9/dA3u+syt6V4r/54M5ISY6oNo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763682423; c=relaxed/simple;
	bh=78tNh63S5jbCFjqvxrxwBqADbhhJAUxJk81WKeCe8bg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RiKwNmLX3jdkWhn1wex9yBloQhVm4JaQzBfr7S7qnP2fQMO0afywJOdbcJj4kqzFbINytLnVg7eDK4MQXCEQEBiBK3uZaRITnixGHk2xK1nUWjX3QVTlbqKUnKlIFP7W0BQo3PhfpI3gPncP5ypvaXTfIaHjwH3RZLK53z2RHxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=b6Rr1QbY; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 20 Nov 2025 23:46:39 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763682406;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jGS7/fBJFQ9+OhNTTIerduiElvyxEZD18GYekvLrZd0=;
	b=b6Rr1QbYcnM47WYAM9NnPE28P7DfjQeVFbsSG9y+UAY8no70Srp2My3xNKUmIPnGK6pQZP
	NHwgJP0sByLK6OGzbyBT2mEmixFu5THH2KCahOKLTaZRgGsoPCDfnfYgtqaungo9gludVS
	mlWLZ7FVAjc972PS9xsPPl9/hzaU2lk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 01/23] KVM: selftests: Minor improvements to asserts
 in test_vmx_nested_state()
Message-ID: <apcrmtprcj7uqqkozjdd7t7lrlef5y7et4if7gfdupu6oopvu6@7v7umuew3zjp>
References: <20251021074736.1324328-1-yosry.ahmed@linux.dev>
 <20251021074736.1324328-2-yosry.ahmed@linux.dev>
 <aR-m85ZKhRIPB14J@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aR-m85ZKhRIPB14J@google.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Nov 20, 2025 at 03:40:35PM -0800, Sean Christopherson wrote:
> On Tue, Oct 21, 2025, Yosry Ahmed wrote:
> > Display the address as hex if the asserts for the vmxon_pa and vmcs12_pa
> > fail, and assert that the flags are 0 as expected.
> > 
> > Reviewed-by: Jim Mattson <jmattson@google.com>
> > Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > ---
> >  .../selftests/kvm/x86/vmx_set_nested_state_test.c      | 10 ++++++++--
> >  1 file changed, 8 insertions(+), 2 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/kvm/x86/vmx_set_nested_state_test.c b/tools/testing/selftests/kvm/x86/vmx_set_nested_state_test.c
> > index 67a62a5a88951..c4c400d2824c1 100644
> > --- a/tools/testing/selftests/kvm/x86/vmx_set_nested_state_test.c
> > +++ b/tools/testing/selftests/kvm/x86/vmx_set_nested_state_test.c
> > @@ -241,8 +241,14 @@ void test_vmx_nested_state(struct kvm_vcpu *vcpu)
> >  	TEST_ASSERT(state->size >= sizeof(*state) && state->size <= state_sz,
> >  		    "Size must be between %ld and %d.  The size returned was %d.",
> >  		    sizeof(*state), state_sz, state->size);
> > -	TEST_ASSERT(state->hdr.vmx.vmxon_pa == -1ull, "vmxon_pa must be -1ull.");
> > -	TEST_ASSERT(state->hdr.vmx.vmcs12_pa == -1ull, "vmcs_pa must be -1ull.");
> > +	TEST_ASSERT(state->hdr.vmx.vmxon_pa == -1ull,
> > +		    "vmxon_pa must be 0x%llx, but was 0x%llx",
> > +		    -1ull, state->hdr.vmx.vmxon_pa);
> > +	TEST_ASSERT(state->hdr.vmx.vmcs12_pa == -1ull,
> > +		    "vmcs12_pa must be 0x%llx, but was 0x%llx",
> > +		    -1llu, state->hdr.vmx.vmcs12_pa);
> > +	TEST_ASSERT(state->flags == 0,
> > +		    "Flags must be equal to 0, but was 0x%hx", state->flags);
> 
> The error messages aren't adding a whole lot, why not just use TEST_ASSERT_EQ()?

I hadn't discovered TEST_ASSERT_EQ() at that point in my life, not until
later while working on that series :D

Seems like TEST_ASSERT_EQ() already prints in hex, so that's nice. I can
switch to TEST_ASSERT_EQ() if/when I respin.

