Return-Path: <kvm+bounces-48105-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2028EAC928D
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 17:32:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5553BA449C9
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 15:32:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 560841990D8;
	Fri, 30 May 2025 15:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ni84IwnC"
X-Original-To: kvm@vger.kernel.org
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 844A2194C75
	for <kvm@vger.kernel.org>; Fri, 30 May 2025 15:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748619168; cv=none; b=hjySnAFKFMwSbFuoJAB/5TYrWNrlTSoynkbF+3VVGanOAsk+7uooAt1YanTXdMSZvYr/LJQF1VIlegddJFevAqbtzLqQLiqsXt7y8NanqABjC30T9hEe9YoWES+zpM8FMPQ7caSDdykDxCn7/jHTth5gM73I3nzBZPBlJVyq7qM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748619168; c=relaxed/simple;
	bh=mAjaU7Qr9YiMKppaQRquT+CyUKRCXRpJoToVy0E+CHs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qcUeT+IuxY08oZCgxIURvDYH2/N718oDczFfx/XXLu9Bs3EPNjbfQ0+36/N0vgCRWnajfMlc+L0CtYEnu5scMqdkBL3eVABiyOpf22yWGx0aueVy9oyY38JYWW5pawEyuyNXgkzkFXLhVwG8bR3eJDp69jyg7+ZPevjGcY2bKZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ni84IwnC; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 30 May 2025 17:32:40 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1748619163;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YZ83udEdBIzkBInLz5YFUVKBSBkAadhz6QczoNgNxOA=;
	b=Ni84IwnCptYtoXGojeqKngiAzRtOb+JY4ymE/SIQ5VzwZiXlUe3fOPB4CC7XQ7FKeQxpen
	COJjkjZzm6f4qxoEp8JfZdJFiM9dNv9MEZbGmfA24YXLl/TcGZL7AV5e73fjPi90LpUild
	OzpMmTvK619gEg2xp6Ji+NFDz2xNxx4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Huth <thuth@redhat.com>, 
	kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH] runtime: Skip tests if the target
 "kernel" file doesn't exist
Message-ID: <20250530-cc607e1b406bb1baa3b29667@orel>
References: <20250529205820.3790330-1-seanjc@google.com>
 <20250530-4859709c9df9481d6897a818@orel>
 <aDnOZc9FS59AV3pH@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aDnOZc9FS59AV3pH@google.com>
X-Migadu-Flow: FLOW_OUT

On Fri, May 30, 2025 at 08:27:33AM -0700, Sean Christopherson wrote:
> On Fri, May 30, 2025, Andrew Jones wrote:
> > On Thu, May 29, 2025 at 01:58:20PM -0700, Sean Christopherson wrote:
> > > Skip the test if its target kernel/test file isn't available so that
> > > skipping a test that isn't supported for a given config doesn't require
> > > manually flagging the testcase in unittests.cfg.  This fixes "failures"
> > > on x86 with CONFIG_EFI=y due to some tests not being built for EFI, but
> > > not being annotated in x86/unittests.cfg.
> > > 
> > > Alternatively, testcases could be marked noefi (or efi-only), but that'd
> > > require more manual effort, and there's no obvious advantage to doing so.
> > > 
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > ---
> > >  scripts/runtime.bash | 5 +++++
> > >  1 file changed, 5 insertions(+)
> > > 
> > > diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> > > index ee229631..a94d940d 100644
> > > --- a/scripts/runtime.bash
> > > +++ b/scripts/runtime.bash
> > > @@ -150,6 +150,11 @@ function run()
> > >          done
> > >      fi
> > >  
> > > +    if [ ! -f "$kernel" ]; then
> > > +        print_result "SKIP" $testname "" "Test file '$kernel' not found";
> > > +        return 2;
> > > +    fi
> > > +
> > 
> > I see mkstandalone.sh already has something like this. There's still one
> > other place, though, which is print_testname(). Should we filter tests
> > from the listing that are missing their kernels?
> 
> Huh, TIL you can list testcases :-)
> 
> I would say no?  Because then listing testcases would depend on a successful
> build, which would be annoying in a variety of scenarios.
> 
> It would also be weird to list testcases that are excluded based on e.g. arch,
> but not list testcases that are effectively excluded via Makefile.

Sounds reasonable.

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

Thanks,
drew

