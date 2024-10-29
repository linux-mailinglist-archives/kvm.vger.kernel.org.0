Return-Path: <kvm+bounces-29940-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BE239B47C7
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 12:05:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6C8F11C23BA0
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 11:05:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD781204941;
	Tue, 29 Oct 2024 11:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rO849xIe"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CEA52038A0
	for <kvm@vger.kernel.org>; Tue, 29 Oct 2024 11:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730199607; cv=none; b=T2j0pugmJtM2yB2nq96olIC3zEeEVQAbiAuQfFgE951VO+HuQSQK0mzcfeVHaIMfH3cFvkLG+eE1A/LgrqEV9AJDjPt9ZGG2Qeb4xAcmK8iHUT/+3VGv46IHDqoMndwtCq72CACYF3JFezu415Sd7zTaahDLXr8v7K29AqQcak8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730199607; c=relaxed/simple;
	bh=HhZbqtZuxKxQxqrndfZAbO6YeYl5LxGMW+6euQ3ejc8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Sb2vHkU2VsBzvKXHpXTjLpxLe7a8FItEiKikD4cTgHjxaSII8ktuoViGIYKQ6nfbtPPP5XZPENtkLyKlgmpwU9v502zwwmU5pfwdHx7f/WSVNTdISWfXpR/IHd1jzNegkvNBFTc1vG8I+2uHwsVz0zOj/qbFx72CcXtutPIAXRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rO849xIe; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 29 Oct 2024 11:59:59 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730199602;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+1Ofz6JttHGFC2vw3TiGAj1tgzkguZcw6Bi7ei+eLAk=;
	b=rO849xIeuRxIsjoQ6damynYvkd/N1lB1aF84Soa6gH5fwOvLTc/gpk+pUe6QrJQBKlBeP7
	CbM3dAuJStfPc+9bfCk7LLPnvwqef+ruqIfTQG+zwwx8aAAyT1G2se/lUY3buSfx9nXc4v
	S9Vz3IdYgPrM06oZr4HfL8yzPFF0/N8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, thuth@redhat.com, 
	lvivier@redhat.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, nrb@linux.ibm.com, 
	npiggin@gmail.com
Subject: Re: [RFC kvm-unit-tests PATCH] lib/report: Return pass/fail result
 from report
Message-ID: <20241029-d07c6097495c361bcda9b0c5@orel>
References: <20241023165347.174745-2-andrew.jones@linux.dev>
 <Zxu9MkAob0zVCsYQ@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zxu9MkAob0zVCsYQ@arm.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Oct 25, 2024 at 04:45:54PM +0100, Alexandru Elisei wrote:
> Hi Drew,
> 
> On Wed, Oct 23, 2024 at 06:53:48PM +0200, Andrew Jones wrote:
> > A nice pattern to use in order to try and maintain parsable reports,
> > but also output unexpected values, is
> > 
> >     if (!report(value == expected_value, "my test")) {
> >         report_info("failure due to unexpected value (received %d, expected %d)",
> >                     value, expected_value);
> >     }
> 
> This looks like a good idea to me, makes the usage of report() similar to
> the kernel pattern of wrapping an if condition around WARN_ON():
> 
> 	if (WARN_ON(condition)) {
> 		do_stuff()
> 	}
> 
> Plus, current users are not affected by the change so I see no reason not
> to have the choice.
> 
> > 
> > Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> > ---
> >  lib/libcflat.h |  6 +++---
> >  lib/report.c   | 28 +++++++++++++++++++++-------
> >  2 files changed, 24 insertions(+), 10 deletions(-)
> > 
> > diff --git a/lib/libcflat.h b/lib/libcflat.h
> > index eec34c3f2710..b4110b9ec91b 100644
> > --- a/lib/libcflat.h
> > +++ b/lib/libcflat.h
> > @@ -97,11 +97,11 @@ void report_prefix_pushf(const char *prefix_fmt, ...)
> >  extern void report_prefix_push(const char *prefix);
> >  extern void report_prefix_pop(void);
> >  extern void report_prefix_popn(int n);
> > -extern void report(bool pass, const char *msg_fmt, ...)
> > +extern bool report(bool pass, const char *msg_fmt, ...)
> >  		__attribute__((format(printf, 2, 3), nonnull(2)));
> > -extern void report_xfail(bool xfail, bool pass, const char *msg_fmt, ...)
> > +extern bool report_xfail(bool xfail, bool pass, const char *msg_fmt, ...)
> >  		__attribute__((format(printf, 3, 4), nonnull(3)));
> > -extern void report_kfail(bool kfail, bool pass, const char *msg_fmt, ...)
> > +extern bool report_kfail(bool kfail, bool pass, const char *msg_fmt, ...)
> >  		__attribute__((format(printf, 3, 4), nonnull(3)));
> >  extern void report_abort(const char *msg_fmt, ...)
> >  					__attribute__((format(printf, 1, 2)))
> > diff --git a/lib/report.c b/lib/report.c
> > index 0756e64e6f10..43c0102c1b0e 100644
> > --- a/lib/report.c
> > +++ b/lib/report.c
> > @@ -89,7 +89,7 @@ void report_prefix_popn(int n)
> >  	spin_unlock(&lock);
> >  }
> >  
> > -static void va_report(const char *msg_fmt,
> > +static bool va_report(const char *msg_fmt,
> >  		bool pass, bool xfail, bool kfail, bool skip, va_list va)
> >  {
> >  	const char *prefix = skip ? "SKIP"
> > @@ -114,14 +114,20 @@ static void va_report(const char *msg_fmt,
> >  		failures++;
> >  
> >  	spin_unlock(&lock);
> > +
> > +	return pass || xfail;
> 
> va_report() has 4 boolean parameters that the callers set. 'kfail' can be
> ignored, because all it does is control which variable serves as the
> accumulator for the failure.
> 
> I was thinking about the 'skip' parameter - report_skip() sets pass = xfail
> = false, skip = true. Does it matter that va_report() returns false for
> report_skip()? I don't think so (report_skip() returns void), just wanting
> to make sure we've considered all the cases.  Sorry if this looks like
> nitpicking.

I think I considered all the cases, but if you see something missing, then
I'm all ears.

> 
> Other than that, the patch looks good to me.

Thanks,
drew

