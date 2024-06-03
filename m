Return-Path: <kvm+bounces-18607-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 816508D7DB9
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 10:46:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E0C50B23080
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 08:46:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EEDE82C7E;
	Mon,  3 Jun 2024 08:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="E9N3W8Xl"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A75824A4
	for <kvm@vger.kernel.org>; Mon,  3 Jun 2024 08:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717404338; cv=none; b=HYihJ8ZRnPgbboNV1D47jnMzex/w2/Q9ly7avXTAER0kKBKvx0xOCGw4ZNePUqkhAvMYmhQIcN0l+vIdGKKqw1W78LlAvCI3d4wkaWrgcjncySTPVstBOsC6DvBLHLRqiGZrZRwiyhIprXphuFYuhOA6iDm2SRK3BXHwESx600s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717404338; c=relaxed/simple;
	bh=69cNYYcu1N3d2SDDZLAEBONBN/obk2sHbiVN+BQCUsw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SW+8Z9WKgG7ljOk47MpMeHqYOR56GeFZm5gPchWrrDy6o5BZaYYOFVSKSd1s+rBJmMIfmctz83Yyq8b+VpyhtvXsHJpd5iwi++1KOmX0roRj+dXXarlf7yIulncVEldyngf/LDLWTFpVc9uUJWL8Dr5sQNYL3k0e+i1i0aTZOuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=E9N3W8Xl; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: npiggin@gmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1717404333;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=67q2YlOk9Qz9nC720q9vy5lz/QJs4bEAeHEdidRZZ3c=;
	b=E9N3W8Xl1yHKl4ZxTVp00nMR659izjCqfu482rt5+x+vV/AM6TTGO6m5DWGh2Fw68FQ5pn
	egU8gNYGwR/YspVlsHkU5KuZAI/7an8pktoI8pCVUTx9qxxlESYrUHv2PV26ftdZxQ9Kss
	h7b7MQxN8Ur7Jna5HiTRHhZRXTaVKqo=
X-Envelope-To: thuth@redhat.com
X-Envelope-To: kvm@vger.kernel.org
Date: Mon, 3 Jun 2024 10:45:28 +0200
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 2/4] doc: update unittests doc
Message-ID: <20240603-31e6c41fcae1f2ac0a92ebe5@orel>
References: <20240602122559.118345-1-npiggin@gmail.com>
 <20240602122559.118345-3-npiggin@gmail.com>
 <20240603-740192cec3e3e8cdaaf69275@orel>
 <D1Q8BCQQPHYG.29QVJF8LL6EDI@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D1Q8BCQQPHYG.29QVJF8LL6EDI@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Jun 03, 2024 at 06:12:05PM GMT, Nicholas Piggin wrote:
> On Mon Jun 3, 2024 at 4:47 PM AEST, Andrew Jones wrote:
> > On Sun, Jun 02, 2024 at 10:25:56PM GMT, Nicholas Piggin wrote:
> > > Document the special groups, check path restrictions, and a small fix
> > > for check option syntax.
> > > 
> > > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> > > ---
> > >  docs/unittests.txt | 11 ++++++++---
> > >  1 file changed, 8 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/docs/unittests.txt b/docs/unittests.txt
> > > index 6ff9872cf..509c529d7 100644
> > > --- a/docs/unittests.txt
> > > +++ b/docs/unittests.txt
> > > @@ -69,8 +69,11 @@ groups
> > >  groups = <group_name1> <group_name2> ...
> > >  
> > >  Used to group the test cases for the `run_tests.sh -g ...` run group
> > > -option. Adding a test to the nodefault group will cause it to not be
> > > -run by default.
> > > +option. The group name is arbitrary, except for these special groups:
> > > +- Tests in the "nodefault" group are not run by default (with no -g option).
> > > +- Tests in the "migration" group are run with the migration harness and
> > > +  expects the test to make migrate_*() calls.
> >
> > expect make migrate_*() calls.
> 
> Not sure if I follow you, but the grammar does sound a bit off now that
> I read it back. Is this better?
> 
> "... are run with the migration harness and are expected to make
>  migrate_*() calls."

This one looks good to me.

Thanks,
drew

> 
> or
> 
> "... are run with the migration harness, which expects them to make
>  migrate_*() calls."
> 
> >
> > > +- Tests in the "panic" group expect QEMU to enter the GUEST_PANICKED state.
> > >  
> > >  accel
> > >  -----
> > > @@ -89,8 +92,10 @@ Optional timeout in seconds, after which the test will be killed and fail.
> > >  
> > >  check
> > >  -----
> > > -check = <path>=<<value>
> > > +check = <path>=<value>
> > >  
> > >  Check a file for a particular value before running a test. The check line
> > >  can contain multiple files to check separated by a space, but each check
> > >  parameter needs to be of the form <path>=<value>
> > > +
> > > +The path and value can not contain space, =, or shell wildcard characters.
> >
> > cannot
> 
> Huh, seems that is the more usual and formal form. I dind't know that.
> 
> Thanks,
> Nick
> 
> >
> > Otherwise,
> >
> > Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
> >
> > Thanks,
> > drew
> 

